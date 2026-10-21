"""Bounded, provider-neutral baseline adapter protocol (offline by default).

An operator supplies a trusted executable adapter; no shell, credentials, tools,
repository or gold are passed to it. The adapter must enforce request.max_tokens
and per-request reservation at its endpoint. Remote accounting is never guessed.
"""
from __future__ import annotations
import json
import math
from pathlib import Path
import subprocess
import time

from qcb_core import digest, model_input, read_json, write_json


def run(items, config, destination, root, *, authorized=False, fixture=False):
    destination, root = Path(destination).resolve(), Path(root).resolve()
    if destination.is_relative_to(root):
        raise ValueError("raw predictions/usage must remain outside the public repository")
    required = {"adapter", "model", "checkpoint", "max_calls", "max_input_tokens",
                "max_output_tokens", "max_seconds", "max_cost_usd", "per_call_cost_ceiling_usd",
                "max_input_bytes", "max_output_bytes", "exposure"}
    if required - config.keys():
        raise ValueError("all model, checkpoint, token/time/cost/call limits are required")
    for key in required - {"adapter", "model", "checkpoint", "exposure"}:
        value = config[key]
        if type(value) not in (int, float) or not math.isfinite(value) or value <= 0:
            raise ValueError("limits must be positive finite numbers")
    if any(type(config[k]) is not int for k in ["max_calls", "max_input_tokens", "max_output_tokens", "max_input_bytes", "max_output_bytes"]):
        raise ValueError("count limits must be integers")
    command = config["adapter"]
    if not isinstance(command, list) or not command or any(not isinstance(x, str) for x in command):
        raise ValueError("adapter must be an argument vector, never a shell string")
    if config["exposure"] != "closed_book":
        raise ValueError("this no-tool baseline runner supports closed_book only")
    if not fixture and not authorized:
        return {"status": "dry_run", "calls": 0, "model_performance_measured": False,
                "planned_calls": min(len(items), config["max_calls"]), "config_hash": digest(config)}
    if fixture and config.get("provider") != "fixture":
        raise ValueError("fixture mode requires explicitly labelled local fixture adapter")
    config_hash, items_hash = digest(config), digest([model_input(i) for i in items])
    state_path = destination / "run.json"
    state = read_json(state_path) if state_path.exists() else {
        "schema_version": "qcb.run.v1", "config_hash": config_hash, "items_hash": items_hash,
        "model": config["model"], "checkpoint": config["checkpoint"], "exposure": "closed_book",
        "fixture": fixture, "model_performance_measured": False, "calls": [],
        "cost_usd": 0, "reserved_cost_usd": 0, "elapsed_seconds": 0, "predictions": [],
        "status": "running", "endpoint_limits": "Adapter must enforce token and cost reservation remotely."}
    if state["config_hash"] != config_hash or state["items_hash"] != items_hash or state["fixture"] != fixture:
        raise ValueError("resume input/config mismatch")
    if state["status"] == "failed":
        raise ValueError("failed/in-flight call needs operator reconciliation before resume")
    completed = {p["id"] for p in state["predictions"]}
    for item in items:
        if item["id"] in completed:
            continue
        if len(state["calls"]) >= config["max_calls"]:
            state["status"] = "call_limit"
            break
        reservation = config["per_call_cost_ceiling_usd"]
        if state["reserved_cost_usd"] + reservation > config["max_cost_usd"]:
            state["status"] = "spend_limit"
            break
        remaining = config["max_seconds"] - state["elapsed_seconds"]
        if remaining <= 0:
            state["status"] = "time_limit"
            break
        request = {"schema_version": "qcb.adapter.request.v1", "model": config["model"],
                   "checkpoint": config["checkpoint"], "task": model_input(item),
                   "max_input_tokens": config["max_input_tokens"], "max_tokens": config["max_output_tokens"],
                   "cost_ceiling_usd": reservation, "timeout_seconds": remaining}
        encoded = json.dumps(request, ensure_ascii=False).encode()
        if len(encoded) > config["max_input_bytes"]:
            raise ValueError("request exceeds input byte limit")
        # Persist reservation BEFORE calling; a crash cannot silently repeat billing.
        call = {"id": item["id"], "request_hash": digest(request), "status": "in_flight",
                "reserved_cost_usd": reservation, "input_tokens": None, "output_tokens": None,
                "cost_usd": None, "seconds": None}
        state["calls"].append(call)
        state["reserved_cost_usd"] += reservation
        state["status"] = "failed"  # conservative crash-safe state
        write_json(state_path, state)
        started = time.monotonic()
        try:
            # Do not inherit credentials; an authorized operator's adapter resolves
            # its own credentials in its own approved environment, not in prompts.
            import os
            env = {k: v for k, v in os.environ.items() if k in {"PATH", "SYSTEMROOT", "LANG"}}
            # Bounded output spool avoids unbounded capture_output memory.
            import tempfile
            with tempfile.TemporaryFile() as output:
                proc = subprocess.Popen(command, stdin=subprocess.PIPE, stdout=output, stderr=subprocess.DEVNULL, env=env)
                try:
                    proc.communicate(encoded, timeout=remaining)
                except subprocess.TimeoutExpired:
                    proc.kill()
                    proc.wait()
                    raise ValueError("adapter wall-clock deadline exceeded; usage unknown")
                output.seek(0, 2)
                if output.tell() > config["max_output_bytes"]:
                    raise ValueError("adapter output too large; usage requires reconciliation")
                output.seek(0)
                response = json.loads(output.read())
                if proc.returncode:
                    raise ValueError("adapter failed; remote usage unknown")
            if not isinstance(response, dict):
                raise ValueError("adapter response must be a JSON object")
            if response.get("model") != config["model"] or response.get("checkpoint") != config["checkpoint"]:
                raise ValueError("adapter model/checkpoint mismatch")
            if response.get("stop_reason") != "end_turn" or not isinstance(response.get("answer"), str):
                raise ValueError("adapter did not return a complete answer")
            usage = response["usage"]
            for k in ["input_tokens", "output_tokens", "cost_usd"]:
                if type(usage[k]) not in (int, float) or not math.isfinite(usage[k]) or usage[k] < 0:
                    raise ValueError("actual endpoint usage required, not estimates")
            if (usage["input_tokens"] > config["max_input_tokens"]
                    or usage["output_tokens"] > config["max_output_tokens"] or usage["cost_usd"] > reservation):
                raise ValueError("adapter violated reserved request limits")
            call.update(usage, status="fixture" if fixture else "completed")
            state["cost_usd"] += usage["cost_usd"]
            state["predictions"].append({"id": item["id"], "answer": response["answer"]})
            state["status"] = "running"
        except (ValueError, KeyError, OSError) as error:
            call["status"] = "failed_usage_unreconciled"
            state["error"] = str(error)
            raise
        finally:
            call["seconds"] = time.monotonic() - started
            state["elapsed_seconds"] += call["seconds"]
            write_json(state_path, state)
    else:
        state["status"] = "completed"
    state["model_performance_measured"] = not fixture and any(c["status"] == "completed" for c in state["calls"])
    write_json(state_path, state)
    write_json(destination / "predictions.json", state["predictions"])
    return state
