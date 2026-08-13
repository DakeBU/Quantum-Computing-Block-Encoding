#!/usr/bin/env python3
"""Bridge one QuantumComputinglib task request to the local ASPBE CLI."""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))

from tools.executable_manifest import migrate_task_packet, validate_executable_policy


ID_PATTERN = re.compile(r"^[A-Za-z0-9][A-Za-z0-9._-]{2,95}$")


def server_owned_profile(provider: str) -> dict[str, object]:
    """Return commands selected by the local runner, never by browser input."""

    environment_name = f"ASPBE_{provider.upper()}_AGENT_COMMAND"
    command = os.environ.get(environment_name, "").strip()
    if not command and provider == "openai":
        command = 'cd {root} && codex exec --dangerously-bypass-approvals-and-sandbox "$(cat {prompt})"'
    if not command:
        raise ValueError(
            f"Set {environment_name} on the self-hosted runner before using provider {provider}."
        )
    return {
        "description": f"Server-owned {provider} profile; no command was accepted from the browser.",
        "commands": {role: command for role in (
            "upper", "middle", "lower1", "lower2", "lower3", "reviewer", "default"
        )},
    }


def run(command: list[str], *, input_text: str | None = None) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        command,
        cwd=ROOT,
        input=input_text,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
        check=False,
    )


def fail(message: str, code: int = 2) -> int:
    print(json.dumps({"ok": False, "output": message}, ensure_ascii=False))
    return code


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--cycles", type=int, default=1)
    parser.add_argument("--execute", action="store_true")
    args = parser.parse_args()
    try:
        payload = json.load(sys.stdin)
    except (json.JSONDecodeError, UnicodeDecodeError) as error:
        return fail(f"Invalid request JSON: {error}")
    if not isinstance(payload, dict) or not isinstance(payload.get("task"), dict):
        return fail("Request must contain a task object.")
    task = payload["task"]
    task_id = str(task.get("id", ""))
    if not ID_PATTERN.fullmatch(task_id):
        return fail("Task id must contain 3-96 letters, digits, dots, underscores, or hyphens.")
    target = str(task.get("target", "")).strip()
    if not target:
        return fail("Task target is empty.")
    reproduction_preset = str(task.get("reproductionPreset", "custom"))
    if reproduction_preset in {"robin-cold", "robin-warm"}:
        arm = "cold" if reproduction_preset == "robin-cold" else "warm"
        expected_id = f"QBE-ROBIN-BE-{arm.upper()}-001"
        if task_id != expected_id:
            return fail(
                f"Preset {reproduction_preset} requires task id {expected_id}."
            )
        prepared = run(
            [sys.executable, "tools/run_robin_repro.py", "prepare", "--arm", arm]
        )
        if prepared.returncode != 0:
            return fail((prepared.stderr or prepared.stdout).strip())
        if not args.execute:
            print(
                json.dumps(
                    {
                        "ok": True,
                        "output": f"Prepared the frozen Robin {arm} arm; execution was not requested.",
                        "task": task_id,
                    },
                    ensure_ascii=False,
                )
            )
            return 0
        evolved = run(
            [
                sys.executable,
                "tools/run_robin_repro.py",
                "run",
                "--arm",
                arm,
                "--cycles",
                str(max(1, args.cycles)),
            ]
        )
        audited = run([sys.executable, "tools/run_robin_repro.py", "audit"])
        audit_path = ROOT / "experiments" / "robin-be" / "results" / "audit-summary.json"
        audit = json.loads(audit_path.read_text(encoding="utf-8")) if audit_path.is_file() else None
        combined = "\n".join(
            part
            for part in (
                evolved.stdout.strip(),
                evolved.stderr.strip(),
                audited.stdout.strip(),
                audited.stderr.strip(),
            )
            if part
        )
        response = {
            "ok": evolved.returncode == 0 and audited.returncode == 0,
            "output": f"Robin {arm} reproduction finished with exit code {evolved.returncode}.",
            "task": task_id,
            "log_tail": combined[-4000:],
            "audit": audit,
        }
        print(json.dumps(response, ensure_ascii=False))
        return 0 if response["ok"] else (evolved.returncode or audited.returncode or 1)
    provider = str(payload.get("provider", "openai"))
    try:
        profile = server_owned_profile(provider)
    except ValueError as error:
        return fail(str(error))

    policy = task.get("executablePolicy")
    if not isinstance(policy, dict):
        legacy_packet = payload.get("taskPacket")
        if isinstance(legacy_packet, dict):
            try:
                policy = migrate_task_packet(legacy_packet)["executablePolicy"]
            except ValueError as error:
                return fail(f"Invalid executable policy: {error}")
        else:
            policy = {
                "intermediateCheck": {
                    "backend": "none", "required": False,
                    "unitarityTolerance": 1e-10, "cleanBlockTolerance": 1e-10,
                    "requireCanonicalRoundTrip": True,
                },
                "exports": {"formats": []},
            }
    try:
        validate_executable_policy(policy)
    except ValueError as error:
        return fail(f"Invalid executable policy: {error}")

    profile_dir = ROOT / "agent-profiles"
    profile_dir.mkdir(parents=True, exist_ok=True)
    profile_path = profile_dir / f"web-{task_id}.json"
    profile_path.write_text(
        json.dumps(profile, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
        newline="\n",
    )

    format_to_target = {
        "qiskitPython": "qiskit",
        "openqasm3": "qasm3",
        "canonicalIrJson": "canonical-ir",
        "metricsJson": "metrics",
        "circuitText": "circuit-text",
    }
    requested_formats = policy["exports"]["formats"]
    export_targets = ",".join(
        format_to_target[str(item)] for item in requested_formats if str(item) in format_to_target
    )
    check = policy["intermediateCheck"]
    ingest = [
        sys.executable,
        "tools/qbe.py",
        "ingest-user-problem",
        task_id,
        "--title",
        task_id,
        "--language",
        str(task.get("language", "en")),
        "--kind",
        str(task.get("mode", "operatorBlockEncoding")),
        "--mode",
        str(task.get("mode", "operatorBlockEncoding")),
        "--source",
        "QuantumComputinglib user-owned API runner",
        "--export-targets",
        export_targets or "none",
        "--executable-check-backend",
        str(check["backend"]),
        "--executable-evidence-classes",
        (
            "roundTrip,numericUnitary,numericCleanBlock"
            if check["backend"] in {"both", "openqasm3RoundTrip"}
            else "numericUnitary,numericCleanBlock"
            if check["backend"] == "qiskitOperator"
            else "none"
        ),
        "--create-task",
        "--active",
    ]
    if check["required"]:
        ingest.append("--executable-check-required")
    packet = payload.get("packet")
    raw_input = packet if isinstance(packet, str) and packet.strip() else target
    ingested = run(ingest, input_text=raw_input)
    if ingested.returncode != 0:
        return fail((ingested.stderr or ingested.stdout or "Task ingestion failed.").strip())

    sleep = [
        sys.executable,
        "tools/qbe.py",
        "sleep-run",
        task_id,
        "--cycles",
        str(max(1, args.cycles)),
        "--agent-profile",
        str(profile_path.relative_to(ROOT)),
        "--check-each-cycle",
        "--report-language",
        str(task.get("language", "en")),
    ]
    if task.get("harness") == "game":
        sleep.append("--game-harness")
    else:
        sleep.append("--hierarchical-harness")
    sleep.append("--execute" if args.execute else "--dry-run")
    completed = run(sleep)
    combined = "\n".join(
        part for part in (completed.stdout.strip(), completed.stderr.strip()) if part
    )
    if completed.returncode != 0:
        return fail(combined[-20000:] or "ASPBE run failed.", completed.returncode)

    dashboard = None
    dashboard_path = ROOT / "reports" / task_id / "dashboard.json"
    if dashboard_path.is_file():
        try:
            dashboard = json.loads(dashboard_path.read_text(encoding="utf-8"))
        except json.JSONDecodeError:
            dashboard = None
    response: dict[str, object] = {
        "ok": True,
        "output": (
            f"ASPBE {'executed' if args.execute else 'prepared'} {max(1, args.cycles)} cycle(s) "
            f"for {task_id}. The API key remained in the runner process environment."
        ),
        "task": task_id,
        "log_tail": combined[-4000:],
    }
    if isinstance(dashboard, dict):
        response["dashboard"] = dashboard
    response["executablePolicy"] = policy
    print(json.dumps(response, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
