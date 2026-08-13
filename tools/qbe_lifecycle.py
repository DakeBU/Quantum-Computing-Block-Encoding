#!/usr/bin/env python3
"""Read-only lifecycle and historical replay logic for ABEIS tasks."""

from __future__ import annotations

import hashlib
import importlib.metadata as importlib_metadata
import json
import re
import shlex
import sys
from pathlib import Path
from typing import Mapping, Sequence

try:
    from qbe_runtime import file_lock, semantic_route_fingerprint
except ModuleNotFoundError:
    from tools.qbe_runtime import file_lock, semantic_route_fingerprint


LIFECYCLE_STATES = ("active", "superseded", "completed", "blocked", "archived")
CERTIFICATION_STAGES = (
    "generated",
    "executable-screened",
    "lean-obligation-queued",
    "lean-certified",
    "same-tier-comparable",
    "accepted",
)


def _content_digest(parts: Sequence[object]) -> str:
    payload = json.dumps(list(parts), ensure_ascii=True, sort_keys=True, default=str)
    return hashlib.sha256(payload.encode("utf-8")).hexdigest()


def lean_workspace_digest(root: Path) -> str:
    paths = sorted((root / "QuantumBlockEncoding").rglob("*.lean"))
    paths += sorted((root / "Tests").rglob("*.lean"))
    paths += sorted(root.glob("*.lean"))
    paths += [root / "lakefile.lean", root / "lean-toolchain", root / "lake-manifest.json"]
    payload = [
        {
            "path": str(path.relative_to(root)),
            "text": path.read_text(encoding="utf-8"),
        }
        for path in paths
        if path.exists()
    ]
    return _content_digest(payload)


def executable_contract_digest(
    root: Path,
    command: str,
    artifacts: Sequence[str],
) -> str:
    package_versions: dict[str, str] = {}
    for package in ("qiskit", "openqasm3"):
        try:
            package_versions[package] = importlib_metadata.version(package)
        except importlib_metadata.PackageNotFoundError:
            package_versions[package] = "missing"
    paths: list[Path] = []
    for value in [*shlex.split(command), *artifacts]:
        candidate = (root / value).resolve() if not Path(value).is_absolute() else Path(value).resolve()
        try:
            candidate.relative_to(root)
        except ValueError:
            continue
        if candidate.is_file() and candidate not in paths:
            paths.append(candidate)
    return _content_digest(
        [
            {"command": command, "artifacts": list(artifacts)},
            {"python": sys.version, "packages": package_versions},
            [
                {
                    "path": str(path.relative_to(root)),
                    "size": path.stat().st_size,
                    "sha256": _content_digest([path.read_bytes().hex()]),
                }
                for path in sorted(paths)
            ],
        ]
    )


def _load_json(path: Path) -> dict[str, object]:
    if not path.exists():
        return {}
    try:
        payload = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return {}
    return payload if isinstance(payload, dict) else {}


def _load_trial_rows(path: Path) -> tuple[list[dict[str, object]], list[str]]:
    rows: list[dict[str, object]] = []
    raw_lines: list[str] = []
    if not path.exists():
        return rows, raw_lines
    with file_lock(path):
        lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    for line in lines:
        if not line.strip():
            continue
        try:
            value = json.loads(line)
        except json.JSONDecodeError:
            continue
        if isinstance(value, dict):
            rows.append(value)
            raw_lines.append(line)
    return rows, raw_lines


def human_status_task(path: Path) -> str:
    if not path.exists():
        return ""
    match = re.search(
        r"^Task:\s*`([^`]+)`",
        path.read_text(encoding="utf-8", errors="replace"),
        flags=re.MULTILINE,
    )
    return match.group(1).strip() if match else ""


def _task_marker(root: Path, task_id: str, marker: str) -> str:
    path = root / "tasks" / f"{task_id}.md"
    if not path.exists():
        return ""
    match = re.search(
        rf"^{re.escape(marker)}:\s*`?([^`\n]+)`?\s*$",
        path.read_text(encoding="utf-8", errors="replace"),
        flags=re.MULTILINE | re.IGNORECASE,
    )
    return match.group(1).strip() if match else ""


def _artifacts_exist(root: Path, values: object) -> bool:
    if not isinstance(values, list) or not values:
        return False
    return all((root / str(value)).is_file() for value in values)


def completion_evidence(
    root: Path,
    task_id: str,
    trial_rows: Sequence[Mapping[str, object]],
) -> dict[str, object]:
    control = _load_json(root / "runs" / "control" / f"{task_id}.json")
    executable = _load_json(
        root / "runs" / "control" / f"{task_id}-executable.json"
    )
    repository_state = _load_json(root / ".qbe" / "state.json")
    last_check_raw = repository_state.get("last_check", {})
    last_check = last_check_raw if isinstance(last_check_raw, Mapping) else {}
    current_lean_digest = lean_workspace_digest(root)
    current_lean_gate = bool(
        int(last_check.get("exit_code", 1)) == 0
        and last_check.get("lean_workspace_digest") == current_lean_digest
    )
    root_anchors = control.get("certified_root_anchors", [])
    lean_complete = bool(
        current_lean_gate
        and control.get("lean_acceptance_complete")
        and isinstance(root_anchors, list)
        and root_anchors
    )
    executable_required = bool(control.get("executable_acceptance_required"))
    executable_backend = str(control.get("executable_check_backend", "both"))
    executable_command = str(control.get("executable_acceptance_command", ""))
    executable_artifacts_raw = control.get("executable_acceptance_artifacts", [])
    executable_artifacts = (
        [str(value) for value in executable_artifacts_raw]
        if isinstance(executable_artifacts_raw, list)
        else []
    )
    executable_digest_current = executable_contract_digest(
        root, executable_command, executable_artifacts
    )
    executable_complete = bool(
        control.get("executable_acceptance_complete")
        and int(executable.get("exit_code", 1)) == 0
        and executable.get("input_digest") == executable_digest_current
        and executable.get("artifacts_present") is True
        and _artifacts_exist(root, executable.get("artifacts"))
    )
    accepted_rows = []
    for row in trial_rows:
        if row.get("task_id") != task_id:
            continue
        feedback_raw = row.get("verifier_feedback", {})
        feedback = feedback_raw if isinstance(feedback_raw, Mapping) else {}
        backend = str(feedback.get("executable_backend", executable_backend))
        backend_ok = (
            feedback.get("qiskit_acceptance_ok") is True
            if backend == "qiskitOperator"
            else feedback.get("qasm_acceptance_ok") is True
            if backend == "openqasm3RoundTrip"
            else (
                feedback.get("qasm_acceptance_ok") is True
                and feedback.get("qiskit_acceptance_ok") is True
            )
            if backend == "both"
            else True
        )
        if row.get("status") == "accepted" and feedback.get("lean_build_ok") is True and backend_ok:
            accepted_rows.append(str(row.get("trial_id", "")))
    complete = bool(
        control.get("status") == "complete"
        and control.get("stop") is True
        and lean_complete
        and (not executable_required or (executable_complete and accepted_rows))
    )
    return {
        "complete": complete,
        "current_lean_gate": current_lean_gate,
        "lean_complete": lean_complete,
        "executable_required": executable_required,
        "executable_backend": executable_backend,
        "executable_complete": executable_complete,
        "certified_root_anchors": root_anchors if isinstance(root_anchors, list) else [],
        "accepted_executable_trial_ids": accepted_rows,
    }


def resolve_task_lifecycle(
    root: Path,
    task_id: str,
    *,
    state: Mapping[str, object],
    trial_rows: Sequence[Mapping[str, object]],
) -> dict[str, object]:
    evidence = completion_evidence(root, task_id, trial_rows)
    control = _load_json(root / "runs" / "control" / f"{task_id}.json")
    superseded_by = _task_marker(root, task_id, "Superseded by")
    declared_lifecycle = _task_marker(root, task_id, "Lifecycle").lower()
    task_exists = (root / "tasks" / f"{task_id}.md").is_file()

    if evidence["complete"]:
        lifecycle = "completed"
        reason = "current control state has Lean roots and the required executable policy passed"
    elif task_id == state.get("active_task"):
        lifecycle = "active"
        reason = "selected by .qbe/state.json"
    elif superseded_by:
        lifecycle = "superseded"
        reason = f"task declares successor {superseded_by}"
    elif control.get("status") == "blocked" or declared_lifecycle == "blocked":
        lifecycle = "blocked"
        reason = str(control.get("reason") or "task is explicitly marked blocked")
    elif declared_lifecycle == "archived" or not task_exists:
        lifecycle = "archived"
        reason = "task is explicitly archived or no current task card exists"
    else:
        lifecycle = "active"
        reason = "open task card; not selected as the repository-wide active frontier"
    return {
        "task_id": task_id,
        "lifecycle": lifecycle,
        "selected_active": task_id == state.get("active_task"),
        "reason": reason,
        "superseded_by": superseded_by,
        "evidence": evidence,
    }


def shadow_replay(root: Path, task_ids: Sequence[str]) -> dict[str, object]:
    root = root.resolve()
    state = _load_json(root / ".qbe" / "state.json")
    trial_rows, raw_lines = _load_trial_rows(root / "runs" / "trials.jsonl")
    selected = list(dict.fromkeys([*task_ids, str(state.get("active_task") or "")]))
    selected = [task_id for task_id in selected if task_id]
    status_task = human_status_task(root / "HUMAN_STATUS.md")
    active_task = str(state.get("active_task") or "")
    lifecycle = [
        resolve_task_lifecycle(root, task_id, state=state, trial_rows=trial_rows)
        for task_id in selected
    ]
    task_memory: dict[str, object] = {}
    for task_id in selected:
        matching = [
            (row, raw)
            for row, raw in zip(trial_rows, raw_lines)
            if row.get("task_id") == task_id
        ]
        tail = matching[-10:]
        route_fingerprints = [
            fingerprint
            for row, _ in matching
            if (fingerprint := str(row.get("route_fingerprint") or semantic_route_fingerprint(row)))
        ]
        task_memory[task_id] = {
            "all_rows": len(matching),
            "latest_tail_rows": len(tail),
            "all_chars": sum(len(raw) + 1 for _, raw in matching),
            "latest_tail_chars": sum(len(raw) + 1 for _, raw in tail),
            "route_fingerprint_rows": len(route_fingerprints),
            "distinct_route_fingerprints": len(set(route_fingerprints)),
        }
    full_chars = sum(len(raw) + 1 for raw in raw_lines)
    selected_tail_chars = sum(
        int(value["latest_tail_chars"])
        for value in task_memory.values()
        if isinstance(value, dict)
    )
    return {
        "schema_version": 1,
        "read_only": True,
        "active_task": active_task,
        "human_status_task": status_task,
        "human_status_stale": bool(active_task and status_task != active_task),
        "trial_log": {
            "rows": len(trial_rows),
            "chars": full_chars,
            "selected_latest10_chars": selected_tail_chars,
            "prompt_char_reduction": full_chars - selected_tail_chars,
            "prompt_reduction_ratio": (
                1.0 - selected_tail_chars / full_chars if full_chars else 0.0
            ),
        },
        "tasks": lifecycle,
        "task_memory": task_memory,
    }


def shadow_replay_markdown(report: Mapping[str, object]) -> str:
    lines = [
        "# ABEIS Harness Shadow Replay",
        "",
        "This report is read-only; it does not reopen tasks or modify control state.",
        "",
        f"- Active task: `{report.get('active_task') or 'none'}`",
        f"- HUMAN_STATUS task: `{report.get('human_status_task') or 'none'}`",
        f"- HUMAN_STATUS stale: `{str(bool(report.get('human_status_stale'))).lower()}`",
    ]
    trial = report.get("trial_log", {})
    if isinstance(trial, Mapping):
        lines.extend(
            [
                f"- Historical log: {trial.get('rows', 0)} rows / {trial.get('chars', 0)} characters",
                f"- Selected task tails: {trial.get('selected_latest10_chars', 0)} characters",
                f"- Prompt-character reduction: {100 * float(trial.get('prompt_reduction_ratio', 0.0)):.2f}%",
            ]
        )
    lines.extend(["", "| Task | Lifecycle | Lean | Executable | Reason |", "|---|---|---:|---:|---|"])
    for row in report.get("tasks", []):
        if not isinstance(row, Mapping):
            continue
        evidence = row.get("evidence", {})
        if not isinstance(evidence, Mapping):
            evidence = {}
        reason = str(row.get("reason", "")).replace("|", "/")
        lines.append(
            f"| `{row.get('task_id', '')}` | {row.get('lifecycle', '')} | "
            f"{evidence.get('lean_complete', False)} | "
            f"{evidence.get('executable_complete', False)} | {reason} |"
        )
    return "\n".join(lines) + "\n"
