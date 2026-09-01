#!/usr/bin/env python3
"""QBE local workflow helper.

This file is adapted from the plain-file workflow philosophy of ARIS
(`wanshuiyin/Auto-claude-code-research-in-sleep`, MIT License), but all code in
this helper is QBE-specific.  It intentionally has no third-party dependencies.
It also adopts the trial JSONL / summary CSV pattern used in the public
Learning Beyond Gradients artifact repository.
It additionally follows a similar blueprint/DAG-control pattern studied in
LeanMarathon (`YuanheZ/LeanMarathon`): keep a durable system-of-record
snapshot, review target fidelity before broad proving, and discharge focused
proof leaves through deterministic gates.

The helper is not an AI agent.  It is the stable command surface an agent can
use while keeping all source-of-truth files in this Lean repository.
"""

from __future__ import annotations

import argparse
import csv
import datetime as _dt
import hashlib
import io
import importlib.metadata as importlib_metadata
import json
import os
import re
import shlex
import signal
import shutil
import subprocess
import sys
import time
from pathlib import Path
from typing import Callable


# Reserved by qbe_codex_agent.sh for authentication, entitlement, and quota
# failures that cannot be repaired by another agent retry.
PROVIDER_BLOCKED_EXIT_CODE = 78


def provider_blocked_control_state(
    state: dict[str, object], *, previous_cycle: int, run_tokens_used: int
) -> dict[str, object]:
    blocked = dict(state)
    blocked.update(
        {
            "cycle": previous_cycle,
            "status": "provider-blocked",
            "stop": False,
            "reason": (
                "The configured model provider rejected the request before agent "
                "work began. Resume the same cycle after access is restored."
            ),
            "execution_started": False,
            "estimated_cycle_input_tokens": 0,
            "estimated_run_input_tokens": run_tokens_used,
            "provider_blocked_at": now_stamp(),
        }
    )
    return blocked

try:
    from qbe_control import (
        CONTROL_STOP_EXIT_CODE,
        CycleDecision,
        classify_leaves,
        content_digest,
        decide_cycle,
        infer_acceptance_anchors,
        infer_epsilon_ladder,
        infer_executable_acceptance,
        infer_population_gate,
        infer_route_lock,
        latest_frontier_rows,
        latest_obligation_rows,
        load_control_state,
        prompt_budget_violation,
        reduce_latest_feedback,
        summarize_candidate_population,
        write_control_state,
    )
except ModuleNotFoundError:
    from tools.qbe_control import (
        CONTROL_STOP_EXIT_CODE,
        CycleDecision,
        classify_leaves,
        content_digest,
        decide_cycle,
        infer_acceptance_anchors,
        infer_epsilon_ladder,
        infer_executable_acceptance,
        infer_population_gate,
        infer_route_lock,
        latest_frontier_rows,
        latest_obligation_rows,
        load_control_state,
        prompt_budget_violation,
        reduce_latest_feedback,
        summarize_candidate_population,
        write_control_state,
    )

try:
    from qbe_lifecycle import shadow_replay, shadow_replay_markdown
    from qbe_runtime import (
        LockUnavailable,
        append_jsonl_locked,
        append_text_locked,
        atomic_write_json,
        atomic_write_text,
        file_lock,
        semantic_route_fingerprint,
        update_json_locked,
        update_text_locked,
        write_text_exclusive,
        write_text_if_missing,
    )
except ModuleNotFoundError:
    from tools.qbe_lifecycle import shadow_replay, shadow_replay_markdown
    from tools.qbe_runtime import (
        LockUnavailable,
        append_jsonl_locked,
        append_text_locked,
        atomic_write_json,
        atomic_write_text,
        file_lock,
        semantic_route_fingerprint,
        update_json_locked,
        update_text_locked,
        write_text_exclusive,
        write_text_if_missing,
    )


ROOT = Path(
    os.environ.get("QBE_ROOT", str(Path(__file__).resolve().parents[1]))
).expanduser().resolve()
REPOS_ROOT = ROOT.parent
OUTER_REPOS_ROOT = REPOS_ROOT / "outer_repos"
OUTER_PAPERS_ROOT = REPOS_ROOT / "outer_papers"
OUTER_REPOS_AUTOMATION_ROOT = OUTER_REPOS_ROOT / "automation_systems"
OUTER_REPOS_QUANTUM_ROOT = OUTER_REPOS_ROOT / "quantum"
OUTER_REPOS_SAMPLING_ROOT = OUTER_REPOS_ROOT / "sampling_theory_sde"
OUTER_REPOS_MATH_ROOT = OUTER_REPOS_ROOT / "mathematics_open_problems"
OUTER_PAPERS_AUTOMATION_ROOT = OUTER_PAPERS_ROOT / "automation_systems"
OUTER_PAPERS_QUANTUM_ROOT = OUTER_PAPERS_ROOT / "quantum"
OUTER_PAPERS_SAMPLING_ROOT = OUTER_PAPERS_ROOT / "sampling_theory_sde"
LOCAL_PAPER_SOURCE_ROOT = Path(
    os.environ.get("QBE_PAPER_SOURCE_ROOT", str(OUTER_PAPERS_ROOT))
).expanduser()
PROJECT_ARTICLE_ROOT = Path(
    os.environ.get("QBE_PROJECT_ARTICLE_ROOT", str(REPOS_ROOT / "Auto_Proof_Papers" / "ABEIS"))
).expanduser()


ARIS_LOCAL_REFERENCE = OUTER_REPOS_AUTOMATION_ROOT / "Auto-claude-code-research-in-sleep"
EOH_LOCAL_REFERENCE = OUTER_REPOS_AUTOMATION_ROOT / "EoH"
LBG_LOCAL_REFERENCE = OUTER_REPOS_AUTOMATION_ROOT / "learning-beyond-gradients"
LEANMARATHON_LOCAL_REFERENCE = OUTER_REPOS_AUTOMATION_ROOT / "LeanMarathon"
LEAN_QUANTUM_INFO_LOCAL_REFERENCE = OUTER_REPOS_QUANTUM_ROOT / "Lean-QuantumInfo"
LEAN_QUANTUM_LOCAL_REFERENCE = OUTER_REPOS_QUANTUM_ROOT / "lean-quantum"
QUANTUM_COMPUTING_LEAN_LOCAL_REFERENCE = OUTER_REPOS_QUANTUM_ROOT / "quantum-computing-lean"
MATHCODE_LOCAL_REFERENCE = OUTER_REPOS_AUTOMATION_ROOT / "mathcode"
OPTIMIZATION_PROBLEMS_LOCAL_REFERENCE = OUTER_REPOS_MATH_ROOT / "optimizationproblems"
MATHLIB_LOCAL_REFERENCE_CANDIDATES = [
    ROOT / ".lake" / "packages" / "mathlib" / "Mathlib",
    REPOS_ROOT / "mathlib4" / "Mathlib",
    REPOS_ROOT / "outer_repos" / "graph_theory" / "mathlib4" / "Mathlib",
    REPOS_ROOT / "outer_repos" / "graph_np_theory" / "mathlib4" / "Mathlib",
    REPOS_ROOT / "DeepSeek-Prover-V1.5" / "mathlib4" / "Mathlib",
]
LEANMARATHON_PDF = OUTER_PAPERS_AUTOMATION_ROOT / "LeanMarathon-2606.05400.pdf"
STATE_DIR = ROOT / ".qbe"
STATE_FILE = STATE_DIR / "state.json"
MANIFEST = ROOT / "MANIFEST.md"
QBE_DASHBOARD = ROOT / "QBE.md"
HUMAN_STATUS = ROOT / "HUMAN_STATUS.md"
REPORTS_GUIDE = ROOT / "REPORTS.zh.md"
GHL_FAILURE_MAP = ROOT / "paper-notes" / "GHL2025" / "markdown" / "unresolved-failures.zh.md"
GHL_FIG4_AUDIT = ROOT / "paper-notes" / "GHL2025" / "markdown" / "fig4-visual-audit.zh.md"
FINDINGS = ROOT / "findings.md"
TRIAL_LOG = ROOT / "runs" / "trials.jsonl"
TRIAL_SUMMARY = ROOT / "runs" / "trials_summary.csv"
BLUEPRINT_DIR = ROOT / "proof-blueprints"
VERIFIER_FEEDBACK_DIR = ROOT / "verifier-feedback"
TECHNICAL_LEMMA_DIR = ROOT / "research-wiki" / "technical-lemmas"
PAPER_CONTRIBUTION_DIR = ROOT / "research-wiki" / "paper-contributions"
GHL_CONTRIBUTION_DIR = PAPER_CONTRIBUTION_DIR / "GHL2025"
RETRIEVAL_INDEX_DIR = ROOT / "research-wiki" / "retrieval-index"
EFFICIENCY_DIR = ROOT / "runs" / "efficiency"
CONTEXT_PACK_DIR = ROOT / "runs" / "context-packs"
CONTROL_DIR = ROOT / "runs" / "control"
PROJECT_ARTICLE_UPDATE_DIR = ROOT / "paper-notes" / "project-paper" / "cycle-updates"
PROBLEM_EXPORT_DIR = ROOT / "paper-notes" / "problem-exports"
EXECUTABLE_EXPORT_DIR = ROOT / "executable-exports"
PRO_PROMPT_DIR = ROOT / "runs" / "pro-prompts"
MANUAL_MULTIAGENT_DIR = ROOT / "runs" / "manual-multiagent"
AGENT_PROFILE_DIR = ROOT / "agent-profiles"

AGENT_ROLES = ("upper", "middle", "lower", "reviewer")
INVALID_LEAN_TARGET_WORDS = {
    "lean", "planned", "none", "theorem", "lemma", "definition", "definitions",
    "target", "external", "contract", "no", "and", "or", "plus", "five",
}
TRIAL_KINDS = ("plan", "attempt", "build", "review", "proposal", "compression", "handoff")
TRIAL_STATUSES = ("queued", "running", "blocked", "failed", "compiled", "accepted", "rejected")
DEFAULT_LOWER_COUNT = 3
DEFAULT_ADAPTIVE_BASE_LOWER_COUNT = 1
DEFAULT_ADAPTIVE_EXPANDED_LOWER_COUNT = 3
DEFAULT_EXACT_STALL_CYCLES = 2
DEFAULT_UPPER_PANEL = True
DEFAULT_MIDDLE_PANEL = True
DEFAULT_PARALLEL_LOWER = False
DEFAULT_PARALLEL_PANELS = False
DEFAULT_GAME_HARNESS = False
DEFAULT_NATURAL_LOWER_COUNT = 2
DEFAULT_LEAN_LOWER_COUNT = 2
DEFAULT_MAX_NO_PROGRESS_CYCLES = 2
DEFAULT_MAX_EXTERNAL_GAP_CYCLES = 1
DEFAULT_MAX_PROMPT_TOKENS = 16000
DEFAULT_MAX_CYCLE_INPUT_TOKENS = 48000
DEFAULT_MAX_RUN_INPUT_TOKENS = 240000
DEFAULT_RETAIN_RUN_DIRS = 48

ACTIVE_AGENT_PROCESSES: set[subprocess.Popen] = set()

WORK_DIRS = [
    "tasks",
    "task-inbox",
    "conversion-windows",
    "paper-notes",
    "agent-briefs",
    "proof-attempts",
    "proof-blueprints",
    "verifier-feedback",
    "failure-memory",
    "candidate-populations",
    "open-problem-proposals",
    "proof-obligations",
    "reviews",
    "runs",
    "runs/efficiency",
    "runs/context-packs",
    "runs/pro-prompts",
    "runs/manual-multiagent",
    "run-presets",
    "agent-profiles",
    "executable-exports",
    "paper-notes/project-paper/cycle-updates",
    "paper-notes/problem-exports",
    "research-wiki/papers",
    "research-wiki/ideas",
    "research-wiki/claims",
    "research-wiki/experiments",
    "research-wiki/graph",
    "research-wiki/cited-results",
    "research-wiki/mathlib-lemmas",
    "research-wiki/technical-lemmas",
    "research-wiki/paper-contributions",
    "research-wiki/paper-contributions/GHL2025",
    "research-wiki/retrieval-index",
    "paper-notes/GHL2025/markdown/cycle-summaries",
]


def run(cmd: list[str]) -> int:
    print("$ " + " ".join(cmd))
    completed = subprocess.run(cmd, cwd=ROOT)
    return completed.returncode


def run_capture(cmd: list[str]) -> tuple[int, str]:
    completed = subprocess.run(cmd, cwd=ROOT, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    return completed.returncode, completed.stdout


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def approx_token_count(text: str) -> int:
    """Conservative local token proxy for harness accounting.

    This is not provider billing data.  It is useful for comparing prompt
    envelopes before exact provider usage is available.
    """

    if not text:
        return 0
    return max(1, (len(text) + 3) // 4)


def write_new(path: Path, text: str) -> None:
    try:
        write_text_exclusive(path, text)
    except FileExistsError:
        raise SystemExit(f"refusing to overwrite existing file: {path}") from None
    print(f"wrote {path.relative_to(ROOT)}")


def write_if_missing(path: Path, text: str) -> bool:
    if not write_text_if_missing(path, text):
        return False
    print(f"initialized {path.relative_to(ROOT)}")
    return True


def append_line(path: Path, line: str) -> None:
    append_text_locked(path, line + "\n")


def append_jsonl(path: Path, record: dict) -> None:
    record = dict(record)
    record.setdefault("runtime_schema_version", 1)
    changed_files = record.get("changed_files")
    if isinstance(changed_files, list):
        unique_files = sorted({str(item) for item in changed_files})
        record["changed_files_count"] = len(unique_files)
        record["changed_files_digest"] = record.get(
            "changed_files_digest", content_digest(unique_files)
        )
        if len(unique_files) > 40:
            record["changed_files"] = unique_files[:40] + [
                f"... {len(unique_files) - 40} additional changed files omitted"
            ]
        else:
            record["changed_files"] = unique_files
    fingerprint = semantic_route_fingerprint(record)
    if fingerprint:
        record.setdefault("route_fingerprint", fingerprint)
    append_jsonl_locked(path, record)


def load_jsonl(path: Path) -> list[dict]:
    if not path.exists():
        return []
    with file_lock(path):
        lines = path.read_text(encoding="utf-8").splitlines()
    records = []
    for line in lines:
        if not line.strip():
            continue
        try:
            records.append(json.loads(line))
        except json.JSONDecodeError as exc:
            raise SystemExit(f"invalid JSONL in {path}: {exc}") from exc
    return records


def load_recent_jsonl(
    path: Path,
    *,
    max_bytes: int = 16 * 1024 * 1024,
    max_records: int = 5000,
) -> list[dict]:
    """Read a bounded tail of an append-only JSONL log.

    Prompt construction needs current state, not a replay of hundreds of
    megabytes of historical attempts.  Full scans remain available through
    explicit reporting commands.
    """

    if not path.exists():
        return []
    with file_lock(path):
        size = path.stat().st_size
        with path.open("rb") as handle:
            start = max(0, size - max_bytes)
            handle.seek(start)
            if start:
                handle.readline()
            data = handle.read()
    records: list[dict] = []
    for raw in data.splitlines():
        if not raw.strip():
            continue
        try:
            value = json.loads(raw.decode("utf-8", errors="replace"))
        except json.JSONDecodeError:
            continue
        if isinstance(value, dict):
            records.append(value)
    return records[-max_records:]


def load_feedback_payload(args: argparse.Namespace) -> dict:
    """Load structured verifier feedback from CLI args."""
    feedback: dict = {}
    if getattr(args, "feedback_json", ""):
        source = args.feedback_json.strip()
        try:
            if source.startswith("{") or source.startswith("["):
                feedback.update(json.loads(source))
            else:
                maybe_path = Path(source)
                if maybe_path.exists():
                    feedback.update(json.loads(maybe_path.read_text(encoding="utf-8")))
                else:
                    feedback.update(json.loads(source))
        except Exception as exc:
            raise SystemExit(f"invalid --feedback-json payload: {exc}") from exc
    for item in getattr(args, "feedback_field", []) or []:
        if "=" not in item:
            raise SystemExit(f"--feedback-field must be key=value, got: {item}")
        key, value = item.split("=", 1)
        key = key.strip()
        value = value.strip()
        if value.lower() == "true":
            parsed: object = True
        elif value.lower() == "false":
            parsed = False
        elif value.lower() in {"null", "none", ""}:
            parsed = None
        else:
            parsed = value
        feedback[key] = parsed
    return feedback


def now_stamp() -> str:
    return _dt.datetime.now().strftime("%Y-%m-%d %H:%M:%S")


def file_stamp() -> str:
    return _dt.datetime.now().strftime("%Y%m%d-%H%M%S")


def slugify(value: str) -> str:
    value = re.sub(r"[^A-Za-z0-9_.-]+", "-", value).strip("-")
    return value or "untitled"


def rel(path: Path) -> str:
    return str(path.relative_to(ROOT))


def display_path(path: Path) -> str:
    """Return a compact path for private agent prompts and diagnostics."""
    try:
        return str(path.relative_to(REPOS_ROOT))
    except ValueError:
        return str(path)


def latex_escape(value: object) -> str:
    """Escape plain text for a conservative LaTeX item/table cell."""
    text = str(value)
    replacements = {
        "\\": r"\textbackslash{}",
        "&": r"\&",
        "%": r"\%",
        "$": r"\$",
        "#": r"\#",
        "_": r"\_",
        "{": r"\{",
        "}": r"\}",
        "~": r"\textasciitilde{}",
        "^": r"\textasciicircum{}",
        "`": r"\textasciigrave{}",
        "–": "--",
        "—": "---",
        "“": "``",
        "”": "''",
        "‘": "`",
        "’": "'",
    }
    return "".join(replacements.get(ch, ch) for ch in text)


def write_text(path: Path, text: str) -> None:
    atomic_write_text(path, text)
    print(f"wrote {display_path(path)}")


def git_changed_files(limit: int = 80) -> list[str]:
    code, output = run_capture(["git", "status", "--short"])
    if code != 0:
        return []
    files = []
    for line in output.splitlines():
        if not line.strip():
            continue
        item = line[3:] if len(line) > 3 else line
        if " -> " in item:
            item = item.split(" -> ", 1)[1]
        files.append(item.strip())
    files = sorted(set(files))
    if limit > 0 and len(files) > limit:
        omitted = len(files) - limit
        return files[:limit] + [f"... {omitted} additional changed files omitted"]
    return files


def git_worktree_snapshot() -> dict[str, tuple[str, int | None, int | None]]:
    """Capture lightweight state for dirty paths without hashing the whole tree."""

    code, output = run_capture(["git", "status", "--short", "--untracked-files=all"])
    if code != 0:
        return {}
    snapshot: dict[str, tuple[str, int | None, int | None]] = {}
    for line in output.splitlines():
        if not line.strip():
            continue
        status = line[:2] if len(line) >= 2 else "??"
        item = line[3:] if len(line) > 3 else line
        if " -> " in item:
            item = item.split(" -> ", 1)[1]
        path = item.strip()
        candidate = ROOT / path
        try:
            stat = candidate.stat()
            snapshot[path] = (status, stat.st_size, stat.st_mtime_ns)
        except OSError:
            snapshot[path] = (status, None, None)
    return snapshot


def changed_snapshot_delta(
    before: dict[str, tuple[str, int | None, int | None]],
    after: dict[str, tuple[str, int | None, int | None]],
    limit: int = 80,
) -> list[str]:
    """Return only paths whose worktree state changed during one agent call."""

    files = sorted(path for path in before.keys() | after.keys() if before.get(path) != after.get(path))
    if limit > 0 and len(files) > limit:
        omitted = len(files) - limit
        return files[:limit] + [f"... {omitted} additional changed files omitted"]
    return files


def git_changed_files_since(
    before: dict[str, tuple[str, int | None, int | None]],
    limit: int = 80,
) -> list[str]:
    return changed_snapshot_delta(before, git_worktree_snapshot(), limit)


def latest_run_dir() -> Path | None:
    runs = [
        p for p in (ROOT / "runs").glob("*")
        if p.is_dir() and re.search(r"-cycle[0-9]+$", p.name)
    ]
    return sorted(runs)[-1] if runs else None


def latest_manual_multiagent_dir() -> Path | None:
    if not MANUAL_MULTIAGENT_DIR.exists():
        return None
    runs = [path for path in MANUAL_MULTIAGENT_DIR.glob("*") if path.is_dir()]
    return max(runs, key=lambda path: path.stat().st_mtime) if runs else None


def resolve_run_dir_arg(run_id: str, *, prefer_manual: bool = False) -> Path:
    if run_id == "latest":
        run_dir = latest_manual_multiagent_dir() if prefer_manual else latest_run_dir()
        if run_dir is None:
            raise SystemExit("no run directories found")
        return run_dir
    if run_id == "latest-manual":
        run_dir = latest_manual_multiagent_dir()
        if run_dir is None:
            raise SystemExit("no manual multi-agent directories found")
        return run_dir
    candidates = [
        ROOT / "runs" / run_id,
        ROOT / run_id,
        Path(run_id).expanduser(),
    ]
    for candidate in candidates:
        if candidate.exists() and candidate.is_dir():
            return candidate
    raise SystemExit(f"run directory not found: {run_id}")


def resolved_cycle(requested_cycle: int, run_dir: Path) -> int:
    if requested_cycle > 0:
        return requested_cycle
    match = re.search(r"-cycle(\d+)$", run_dir.name)
    if match:
        return int(match.group(1))
    return 1


def latest_report_run_dir() -> Path | None:
    """Latest run with generated report artifacts, ignoring prompt-only dry runs."""
    runs = [
        p for p in (ROOT / "runs").glob("*")
        if p.is_dir() and re.search(r"-cycle[0-9]+$", p.name)
    ]
    for run_dir in sorted(runs, reverse=True):
        if (
            (run_dir / "zh_summary.md").exists()
            or (run_dir / "memory_digest.md").exists()
            or (run_dir / "article_update.md").exists()
        ):
            return run_dir
    return sorted(runs)[-1] if runs else None


def latest_log_file() -> Path | None:
    log_dir = ROOT / "runs" / "logs"
    if not log_dir.exists():
        return None
    logs = [path for path in log_dir.glob("*.log") if path.is_file()]
    if not logs:
        return None
    return max(logs, key=lambda path: path.stat().st_mtime)


def infer_active_task_id(default: str = "QBE-AUTO-002") -> str:
    state = load_state()
    if state.get("active_task"):
        return str(state["active_task"])
    records = load_recent_jsonl(TRIAL_LOG)
    for record in reversed(records):
        task_id = record.get("task_id")
        if task_id:
            return str(task_id)
    if (ROOT / "tasks" / f"{default}.md").exists():
        return default
    tasks = sorted((ROOT / "tasks").glob("*.md"))
    return tasks[0].stem if tasks else default


def latest_dialogue_text(task_id: str | None = None, limit_chars: int = 8000) -> str:
    run_dirs = sorted([p for p in (ROOT / "runs").glob("*") if p.is_dir()], reverse=True)
    chunks: list[str] = []
    for run_dir in run_dirs:
        if task_id and slugify(task_id) not in run_dir.name and task_id not in run_dir.name:
            continue
        board = run_dir / "dialogue.md"
        if not board.exists():
            continue
        text = board.read_text(encoding="utf-8").strip()
        if text:
            chunks.append(f"## {run_dir.name}\n\n{text}")
        if sum(len(chunk) for chunk in chunks) >= limit_chars:
            break
    if not chunks:
        return "no dialogue records yet"
    joined = "\n\n".join(chunks)
    return joined[-limit_chars:]


def load_state() -> dict:
    if not STATE_FILE.exists():
        return {
            "version": 1,
            "active_task": None,
            "last_check": None,
            "notes": [],
        }
    return json.loads(read_text(STATE_FILE))


def update_state(
    update: Callable[[dict[str, object]], dict[str, object]],
) -> dict[str, object]:
    return update_json_locked(STATE_FILE, update)


def ensure_manifest() -> None:
    write_if_missing(
        MANIFEST,
        """# QBE Output Manifest

Auto-maintained by `tools/qbe.py`.  Tracks generated artifacts across the
block-encoding formalization lifecycle.

| Timestamp | Tool | File | Stage | Description |
|-----------|------|------|-------|-------------|
""",
    )


def add_manifest(tool: str, file: Path, stage: str, description: str) -> None:
    ensure_manifest()
    if file.is_absolute():
        try:
            file_display = str(file.relative_to(ROOT))
        except ValueError:
            file_display = display_path(file)
    else:
        file_display = str(file)
    append_line(MANIFEST, f"| {now_stamp()} | {tool} | `{file_display}` | {stage} | {description} |")


def init_texts() -> dict[Path, str]:
    return {
        QBE_DASHBOARD: """# QBE Dashboard

## Status

- Active task: none
- Build gate: run `python3 tools/qbe.py check`
- Primary target: given operator `A`, synthesize and Lean-verify a candidate
  block-encoding unitary `U_A`, then rank candidates by `BlockEncodingCost`

## Operating Rule

No task is complete until:

```bash
lake build && lake build Tests
```

succeeds.

## Next Steps

1. Run `python3 tools/qbe.py next-task`.
2. Run `python3 tools/qbe.py agent-brief <task-id>`.
3. Work through the generated brief and conversion window.
""",
        FINDINGS: """# Findings

Append concise discoveries about block-encoding constructions, failed oracle
assumptions, Lean proof obstacles, and useful design choices.

## Research Findings

## Engineering Findings
""",
        ROOT / "research-wiki" / "index.md": """# QBE Research Wiki

Persistent project knowledge for papers, ideas, claims, experiments, and gaps.
""",
        ROOT / "research-wiki" / "gap_map.md": """# Gap Map

Stable ids for missing block-encoding/oracle constructions.

| Gap | Status | Description | Linked tasks |
|-----|--------|-------------|--------------|
""",
        ROOT / "research-wiki" / "query_pack.md": """# Query Pack

Compressed context for agents.  Keep this short enough to paste into a new
session.

## Current Focus

- Given an operator `A`, normalizer `alpha`, and block projector, construct
  candidate block-encoding unitaries `U_A`, prove their Lean contracts, and
  rank them by `BlockEncodingCost`.

## Important Constraints

- Lean build gate is mandatory.
- New open problems need Lean-checkable acceptance tests.
- Trial results go to `runs/trials.jsonl` and `runs/trials_summary.csv`.
- Upper/middle/lower/reviewer agents coordinate through `runs/<run-id>/dialogue.md`.
""",
        ROOT / "research-wiki" / "graph" / "edges.jsonl": "",
        ROOT / "research-wiki" / "cited-results" / "README.md": """# Cited Results Memory

This directory records external theorem, lemma, oracle, arithmetic, and
quantum-information results that QBE papers rely on.

Use it to keep three statuses distinct:

- `paper-cited`: the current paper cites or invokes the result.
- `formalized`: QBE has a Lean declaration and build-tested proof or contract.
- `obligation`: QBE still needs to formalize or verify the result before a
  dependent theorem can be closed.

Do not treat a result as proved merely because it is standard, classical, or
cited by a paper.  Record the source, the exact statement used, the Lean target
or declaration, and each dependent QBE task.
""",
        TECHNICAL_LEMMA_DIR / "README.md": """# Technical Lemma Memory

This retrieval layer stores reusable external lemmas, standard quantum
primitives, classical facts, and source-paper dependencies used by ABEIS tasks.

Every memory card should expose the same fields:

- `id`
- `source`
- `statement`
- `lean_decl`
- `lean_status`
- `used_by`
- `dependencies`
- `next_action`
- `tags`

Allowed statuses:

- `paper-cited`
- `classic-unformalized`
- `contract-only`
- `obligation`
- `formalized`

This directory is retrieval memory.  A result closes a theorem only when the
referenced Lean declaration is build-tested for the exact statement being used.
""",
        PAPER_CONTRIBUTION_DIR / "README.md": """# Paper Contribution Memory

This retrieval layer separates a paper's own contributions from external
technical lemmas.  Paper-benchmark agents should consult this directory before
assigning lower-agent work so that paper steps, cited primitives, and standard
facts are not mixed together.
""",
        GHL_CONTRIBUTION_DIR / "README.md": """# Guseynov-Huang-Liu 2025 Contribution Memory

This directory tracks the first ABEIS paper-benchmark case study:
Guseynov--Huang--Liu 2025.  The generated `index.md`, `source-map.md`, and
`todo.md` files are refreshed from the source-anchor table, proof obligations,
trial logs, verifier feedback, and Lean `sorry` scan.
""",
        RETRIEVAL_INDEX_DIR / "README.md": """# Retrieval Index

Compact JSON indexes for upper and middle agents.  These files are designed to
be read instead of replaying the full long log when a new 6h cycle starts.
""",
        ROOT / "proof-obligations" / "README.md": """# Proof Obligations

Use this directory for proof-obligation ledgers extracted from papers or from
failed Lean attempts.
""",
        ROOT / "proof-attempts" / "README.md": """# Proof Attempts

Paper-benchmark mode may use local proof-attempt populations for a fixed Lean
theorem or lemma.  These records are for tactic/proof-script search, not for
changing the paper construction.  Operator-construction mode should use
`candidate-populations/` for competing `U_A` families.

Each record should identify:

- target theorem or lemma,
- attempted proof route,
- Lean error or remaining goals,
- reusable intermediate lemma found,
- status: rejected, promising, generalized, or proved.
""",
        ROOT / "proof-blueprints" / "README.md": """# Proof Blueprints

QBE proof blueprints are compact system-of-record snapshots for one task.

They are inspired by similar blueprint/DAG-control patterns in LeanMarathon,
but adapted to ABEIS quantum-construction targets:

- Lean declarations are the correctness core;
- Markdown/natural-language artifacts are the inner-cycle human proof map;
- closeout LaTeX artifacts state accepted proof blocks for reports and user papers;
- state-preparation blueprints expose the first-column invariant;
- block-encoding blueprints expose the clean-block invariant;
- proof obligations and cited-results ledgers keep unproved contracts explicit;
- dynamic leaf candidates tell lower agents which local proof node to attempt.

Refresh a blueprint before long runs:

```bash
python3 tools/qbe.py blueprint-refresh <task-id>
```
""",
        ROOT / "candidate-populations" / "README.md": """# Candidate Populations

State-preparation, operator-block-encoding, and exploratory-improvement modes
maintain EoH-like populations of candidate unitaries/circuits for the same
fixed target.

Each candidate family should identify:

- target acceptance predicate, such as `U |0^n> = |psi>` for state
  preparation or a clean-block equation for block encoding,
- normalization, normalizer, clean projector, or initial-state convention,
- construction idea,
- auxiliary qubit count,
- gate count, depth, and unresolved oracle calls,
- Lean declarations and file scope,
- partial diagnostics such as typechecks, dimension checks, small-case
  state-action tests, block tests, unitarity tests, block-entry checks,
  normalizer progress, schedule checks, resource progress, and remaining
  obligations,
- status: rejected, active, promising, merged, or proved.

A `BlockEncodingCost` score is only a search guide.  A construction is accepted
only when the Lean target and proof obligations are satisfied.
""",
        ROOT / "verifier-feedback" / "README.md": """# Verifier Feedback

This directory stores typed verifier-feedback packets for QBE lower-agent
attempts.  The pattern is inspired by non-Lean quantum-circuit benchmarks such
as QASM-Eval and Qiskit QuantumKatas, but QBE uses these diagnostics only as
pre-Lean search guidance.  Lean theorem closure remains the acceptance gate.

Use this when a lower attempt fails or partially succeeds.  Record small,
machine-readable fields instead of only prose:

```json
{
  "task": "QBE-AUTO-002",
  "leaf": "slot-three-branch-vanish",
  "mode": "statePreparation",
  "source_correspondence_ok": true,
  "lean_parse_ok": true,
  "lean_build_ok": false,
  "finite_matrix_ok": true,
  "state_action_ok": false,
  "block_entry_ok": null,
  "ancilla_cleanup_ok": null,
  "normalizer_ok": true,
  "unitarity_ok": null,
  "auxiliary_qubits": 1,
  "gate_count": null,
  "depth": null,
  "oracle_calls": 6,
  "closed_theorem_ok": false,
  "error_class": "symbolic_bridge_gap",
  "next_route": "repair candidate U before proving U |0^n> = |psi>"
}
```

Suggested classes:

- `source_translation_gap`
- `shape_or_register_gap`
- `finite_matrix_counterexample`
- `symbolic_bridge_gap`
- `lean_tactic_gap`
- `external_contract_gap`
- `stale_leaf`
- `invalid_route`

Scores and booleans are diagnostics.  They must not be promoted into
paper-theorem status unless a named Lean declaration closes the exact target.
""",
        ROOT / "failure-memory" / "README.md": """# Failure Memory

This directory stores reusable failure packets, not raw logs.  A packet should
be small enough for the next upper/middle/reviewer pass to retrieve without
replaying an entire run.

Use it when a failure repeats or when a reviewer identifies a route-level
mistake.  Recommended fields:

```json
{
  "task": "QBE-...",
  "leaf": "clean-entry-bridge",
  "trace_scope": "fine",
  "failure_class": "symbolic_bridge_gap",
  "local_symptom": "raw constructor equality fails",
  "root_cause": "semantic evalWith equality is the correct statement",
  "rejected_route": "prove raw Coeff matrix equality",
  "repair_route": "prove evalWith-level entry equality",
  "reusable_lesson": "separate symbolic syntax from evaluated semantics",
  "mathlib_queries": ["Matrix.mul_apply"],
  "promote_to_card": false
}
```

Fine-grained packets repair one proof leaf.  Coarse-grained packets repair the
route, theorem statement, access model, or harness allocation.  The reviewer
should reject lower work that repeats a known rejected route without explaining
why the previous failure no longer applies.
""",
        ROOT / "reviews" / "README.md": """# Reviews

Cross-model or human review artifacts for proof attempts and circuit designs.
""",
        ROOT / "runs" / "README.md": """# Runs

This directory is the persistent memory for overnight agent work.

Generated files:

- `trials.jsonl`: append-only trial log, inspired by Learning Beyond Gradients.
- `trials_summary.csv`: compact table rewritten from the JSONL log.
- `<run-id>/`: one prompt deck and dialogue board for a run cycle.

Every run should record:

- task id,
- agent role,
- attempted construction or proof change,
- changed files,
- build-gate result,
- next handoff.
""",
        ROOT / "open-problem-proposals" / "README.md": """# Open Problem Proposals

Draft open problems before they are promoted into
`QuantumBlockEncoding/OpenProblems.lean`.
""",
        ROOT / "agent-briefs" / "README.md": """# Agent Briefs

Generated context packets for AI agents.
""",
        ROOT / "research-wiki" / "mathlib-lemmas" / "README.md": """# Mathlib Lemma Retrieval Cards

Use this directory for reusable Mathlib findings that ABEIS agents should
remember.  A card should record the query, Mathlib module/theorem, local QBE
use site, whether it is imported directly or adapted locally, and any version
or dependency issue.
""",
    }


def cmd_init(_: argparse.Namespace) -> int:
    created_any = False
    for dirname in WORK_DIRS:
        path = ROOT / dirname
        if not path.exists():
            created_any = True
        path.mkdir(parents=True, exist_ok=True)
    for path, text in init_texts().items():
        created_any = write_if_missing(path, text) or created_any
    manifest_existed = MANIFEST.exists()
    ensure_manifest()
    created_any = created_any or not manifest_existed
    def initialize_state(state: dict[str, object]) -> dict[str, object]:
        state.setdefault("version", 1)
        state.setdefault("active_task", None)
        state["initialized_at"] = state.get("initialized_at") or now_stamp()
        return state

    update_state(initialize_state)
    if created_any:
        add_manifest("qbe.py init", QBE_DASHBOARD, "init", "Initialized QBE workflow files")
    return 0


def lean_workspace_digest() -> str:
    """Digest every Lean/build-input file covered by the project check."""

    paths = sorted((ROOT / "QuantumBlockEncoding").rglob("*.lean"))
    paths += sorted((ROOT / "Tests").rglob("*.lean"))
    paths += sorted(ROOT.glob("*.lean"))
    paths += [ROOT / "lakefile.lean", ROOT / "lean-toolchain", ROOT / "lake-manifest.json"]
    return content_digest(
        [
            {"path": rel(path), "text": read_text(path)}
            for path in paths
            if path.exists()
        ]
    )


def cmd_check(_: argparse.Namespace) -> int:
    code = cmd_harness_check(argparse.Namespace())
    if code == 0:
        code = run(["lake", "build"])
    if code == 0:
        code = run(["lake", "build", "Tests"])
    def record_check(state: dict[str, object]) -> dict[str, object]:
        state["last_check"] = {
            "timestamp": now_stamp(),
            "exit_code": code,
            "lean_workspace_digest": lean_workspace_digest(),
        }
        return state

    update_state(record_check)
    return code


def cmd_harness_check(_: argparse.Namespace) -> int:
    return run(
        [
            sys.executable,
            "-m",
            "unittest",
            "tools.test_qbe_runtime",
            "tools.test_qbe_lifecycle",
            "tools.test_qbe_control",
            "tools.test_enforce_mutation_scope",
            "tools.test_atlas_memory",
        ]
    )


def cmd_mathlib_search(args: argparse.Namespace) -> int:
    roots = mathlib_roots()
    if not roots:
        print("No local Mathlib checkout detected.")
        print("Set QBE_MATHLIB_ROOT or install Mathlib under .lake/packages/mathlib/Mathlib.")
        return 1
    query = args.query.strip()
    if not query:
        raise SystemExit("mathlib-search requires a nonempty query")

    rg = shutil.which("rg")
    flags = ["-n", "--glob", "*.lean"]
    if args.ignore_case:
        flags.append("-i")
    if args.word:
        flags.append("-w")

    matches: list[tuple[Path, str]] = []
    for root in roots:
        if rg:
            completed = subprocess.run(
                [rg, *flags, query, str(root)],
                cwd=ROOT,
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
            )
            if completed.returncode not in (0, 1):
                print(completed.stderr.strip(), file=sys.stderr)
                continue
            for line in completed.stdout.splitlines():
                matches.append((root, line))
                if len(matches) >= args.limit:
                    break
        else:
            needle = query.lower() if args.ignore_case else query
            for path in root.rglob("*.lean"):
                try:
                    for number, line in enumerate(path.read_text(encoding="utf-8", errors="ignore").splitlines(), 1):
                        hay = line.lower() if args.ignore_case else line
                        if needle in hay:
                            matches.append((root, f"{path}:{number}:{line}"))
                            if len(matches) >= args.limit:
                                break
                except OSError:
                    continue
                if len(matches) >= args.limit:
                    break
        if len(matches) >= args.limit:
            break

    print("Mathlib roots:")
    for root in roots:
        print(f"- {display_path(root)}")
    print()
    if not matches:
        print(f"No matches for {query!r}.")
        return 1
    print(f"Matches for {query!r} (limit {args.limit}):")
    for root, line in matches:
        printable = line
        root_str = str(root)
        if printable.startswith(root_str):
            printable = printable.replace(root_str, display_path(root), 1)
        print(printable)
    return 0


def cmd_atlas_memory(args: argparse.Namespace) -> int:
    command = [sys.executable, str(ROOT / "tools" / "atlas_memory.py"), args.atlas_action]
    if args.atlas_action == "search":
        command.append(args.query)
        command.extend(["--limit", str(args.limit)])
        if args.include_private:
            command.append("--include-private")
        if args.clean_only:
            command.append("--clean-only")
        if args.relevance:
            command.extend(["--relevance", args.relevance])
        if args.json:
            command.append("--json")
    elif args.atlas_action == "show":
        command.append(args.declaration)
    return subprocess.run(command, cwd=ROOT, check=False).returncode


def cmd_status(_: argparse.Namespace) -> int:
    cmd_init(argparse.Namespace())
    print(f"project: {ROOT}")
    state = load_state()
    print(f"active task: {state.get('active_task') or 'none'}")
    print(f"last check: {state.get('last_check') or 'none'}")
    print()
    code = run(["git", "status", "--short"])
    print()
    if code != 0:
        return code
    print("acceptance gate:")
    return cmd_check(_)


def cmd_harness_audit(args: argparse.Namespace) -> int:
    """Replay lifecycle and memory selection without changing harness state."""

    defaults = [
        "QBE-HARD-CUBIC-DIAGONAL-HIER-COLD-001",
        "QBE-HARD-CUBIC-DIAGONAL-HIER-HINTED-001",
    ]
    report = shadow_replay(ROOT, args.task or defaults)
    rendered = (
        json.dumps(report, indent=2, sort_keys=True, ensure_ascii=False) + "\n"
        if args.json
        else shadow_replay_markdown(report)
    )
    if args.output:
        output = Path(args.output)
        if not output.is_absolute():
            output = ROOT / output
        write_text(output, rendered)
    else:
        print(rendered, end="")
    return 1 if args.fail_on_stale and report.get("human_status_stale") else 0


def cmd_list_literature(_: argparse.Namespace) -> int:
    entries = parse_literature()
    for item in entries:
        print(f"{item.get('status', 'unknown'):10s} {item.get('key')} :: {item.get('title')} :: {item.get('url', '')}")
    print(f"total: {len(entries)}")
    return 0


def parse_literature() -> list[dict[str, str]]:
    source = read_text(ROOT / "QuantumBlockEncoding" / "Literature.lean")
    blocks = re.findall(r"\{\s*key := .*?\n\s*\}", source, flags=re.S)
    entries = []
    for block in blocks:
        item: dict[str, str] = {}
        for field in ["key", "title", "authors", "targetFile", "url", "note"]:
            match = re.search(field + r' := "([^"]*)"', block)
            if match:
                item[field] = match.group(1)
        year_match = re.search(r"year := ([0-9]+)", block)
        role_match = re.search(r"role := PaperRole\.([A-Za-z]+)", block)
        status_match = re.search(r"status := ImplementationStatus\.([A-Za-z]+)", block)
        if year_match:
            item["year"] = year_match.group(1)
        if role_match:
            item["role"] = role_match.group(1)
        if status_match:
            item["status"] = status_match.group(1)
        if "key" in item:
            entries.append(item)
    return entries


def task_files() -> list[Path]:
    return sorted((ROOT / "tasks").glob("*.md"))


def read_task_status(path: Path) -> str:
    text = read_text(path)
    match = re.search(r"^Status:\s*`?([^`\n]+)`?", text, flags=re.M)
    return match.group(1).strip() if match else "unknown"


def cmd_list_tasks(_: argparse.Namespace) -> int:
    cmd_init(argparse.Namespace())
    files = [p for p in task_files() if p.name != "README.md"]
    if not files:
        print("no task files yet")
        return 0
    for path in files:
        title = read_text(path).splitlines()[0].lstrip("# ").strip()
        print(f"{read_task_status(path):14s} {path.stem:20s} {title}")
    return 0


def parse_seed_tasks() -> list[dict[str, str]]:
    source = read_text(ROOT / "QuantumBlockEncoding" / "Automation.lean")
    blocks = re.findall(r"\{\s*id := .*?\n\s*\}", source, flags=re.S)
    parsed = []
    for block in blocks:
        item = {}
        for field in ["id", "title", "source", "targetLean"]:
            match = re.search(field + r' := "([^"]+)"', block)
            if match:
                item[field] = match.group(1)
        status_match = re.search(r"status := TaskStatus\.([A-Za-z]+)", block)
        if status_match:
            item["status"] = status_match.group(1)
        if "id" in item:
            parsed.append(item)
    return parsed


def cmd_next_task(_: argparse.Namespace) -> int:
    cmd_init(argparse.Namespace())
    local_tasks = [p for p in task_files() if p.name != "README.md"]
    active = [p for p in local_tasks if read_task_status(p) in {"active", "planned"}]
    if active:
        path = active[0]
        print(f"{path.stem}: {read_text(path).splitlines()[0].lstrip('# ').strip()}")
        print(f"path: {path.relative_to(ROOT)}")
        return 0
    seeds = parse_seed_tasks()
    seeds.sort(key=lambda t: 0 if t.get("status") == "active" else 1)
    if not seeds:
        print("no seed tasks found")
        return 0
    task = seeds[0]
    print(f"{task.get('id')}: {task.get('title')}")
    print(f"status: {task.get('status')}")
    print(f"target: {task.get('targetLean')}")
    print("create a task file with:")
    print(f"python3 tools/qbe.py new-task {task.get('id')} --title \"{task.get('title')}\" --source \"{task.get('source')}\" --target-lean \"{task.get('targetLean')}\"")
    return 0


def task_template(args: argparse.Namespace) -> str:
    now = _dt.datetime.now().strftime("%Y-%m-%d %H:%M")
    export_targets = getattr(args, "export_targets", "qiskit") or "none"
    executable_backend = getattr(args, "executable_check_backend", "none")
    executable_required = bool(getattr(args, "executable_check_required", False))
    executable_evidence = getattr(args, "executable_evidence_classes", "none")
    export_instantiation = (
        getattr(args, "export_instantiation", "")
        or "smallest certified instance first; record all register sizes and parameter values"
    )
    return f"""# {args.title}

Task id: `{args.id}`
Kind: `{args.kind}`
Mode: `{args.mode}`
Evaluation mode: `full-abeis`
Status: `planned`
Created: `{now}`

## Goal

State the quantum-construction target precisely.  For state preparation, the
preferred input is a normalized target state `|psi>` and the requested action:

```text
U |0^n> = |psi>
```

Equivalently, the first computational-basis column of `U` is `|psi>`.
For block encoding, the preferred input is a finite matrix/operator `A`, a
normalizer `alpha`, and the requested block-entry contract:

```text
(<0^a| ⊗ I) U_A (|0^a> ⊗ I) = A / alpha
```

The system should construct a unitary candidate `U`, prove in Lean that it
has the requested state action or operator block, and score the candidate by:

1. asymptotic tier first, especially polylogarithmic versus polynomial growth,
2. gate count inside one tier,
3. depth / parallel schedule length,
4. auxiliary qubits `a`,
5. unresolved oracle calls.

State whether this is a state-preparation task, a direct
operator-to-block-encoding construction task, a paper benchmark task, or an
exploratory improvement task.  Paper benchmark tasks reproduce a cited
construction as a baseline; improvement tasks may search for a better
construction only after the original target is fixed.

Hybrid strategy:

- `statePreparation`: given `|psi>`, search for a unitary `U` whose first
  column is `|psi>`, prove unitarity and `U |0^n> = |psi>`, and reject
  unnormalized unitary-output claims unless the vector is normalized or
  restated as a rank-one operator.
- `operatorBlockEncoding`: given `A`, search for candidate `U_A`
  constructions, prove the block-entry and unitarity contracts, and rank
  candidates by asymptotic tier, then gate count, depth, auxiliary qubits, and
  unresolved oracle calls.
- `paperBenchmark` / `faithfulPaper`: reproduce a cited construction as a
  source-faithful baseline.  Do not mutate the paper construction while proving
  the baseline.
- `exploratoryConstruction`: use Learning-Beyond-Gradients-style trial memory
  plus EoH-style candidate populations for circuit ideas.  Candidate scores are
  search hints only; Lean proof obligations decide acceptance.  This mode may
  improve a baseline after the original operator target is fixed.

LexElim scheduler discipline:

- Use LexElim-Out for faithful paper/theorem closure: filter routes by source
  faithfulness, correct Lean statement, necessary diagnostics, then proof
  progress/resources.
- Use LexElim-In for exploratory operator construction: read all feedback
  fields each round, but do not let lower-priority soft rewards override hard
  Lean correctness or necessary-condition diagnostics.

## Source

- Paper/open problem: `{args.source or "TBD"}`
- Lean target: `{args.target_lean}`

## State-Preparation Contract

- Target state `|psi>`: `TBD`
- Initial state: `|0^n>`
- Normalization status: `TBD`
- Required state action: `U |0^n> = |psi>`
- First-column invariant: `column_0(U) = |psi>`
- If unnormalized: normalize, or restate as rank-one operator `|v><0^n|`.

## Block-Encoding Contract

- Operator/matrix `A`: `TBD`
- System qubits `n`: `TBD`
- Normalizer `alpha`: `TBD`
- Required block: top-left / selected ancilla state / custom projector: `TBD`
- Free parameters allowed in the oracle: `TBD`
- Required exactness or error tolerance: `TBD`

## Executable Checks and Exports

- Requested targets: `{export_targets}`
- Executable check backend: `{executable_backend}`
- Executable check required: `{str(executable_required).lower()}`
- Executable evidence classes: `{executable_evidence}`
- Screening policy: canonical executable IR may reject, rank, or queue a
  candidate before proof.  It remains executable-screened until Lean closes
  the advertised semantic root.
- Certified-export policy: an artifact may advertise exact refinement only
  after it names the matching Lean declaration.
- Concrete export instantiation: `{export_instantiation}`
- Expected artifact root: `executable-exports/{slugify(args.id)}/`

Supported target labels include `qiskit`, `quantum-katas`, and `qasm3`.
Each export must state its Lean source declaration, register sizes, parameter
values, normalizer, projector, resource tuple, and export check command.

## Candidate Score

The default candidate score is defined in Lean as `BlockEncodingCost`.
ABEIS first compares asymptotic tiers, because polylogarithmic growth in
the system size is qualitatively different from polynomial growth.  Inside
one fixed asymptotic/logical-library tier, the concrete comparison tuple is:

```text
(gateCount, depth, auxiliaryQubits, oracleCalls)
```

Selection is lexicographic in that order after the asymptotic tier check.
In particular, fewer gates beats a shallower schedule; depth breaks
gate-count ties; auxiliary qubits break gate/depth ties.

## Conversion Window

### Markdown

Human explanation, scope, and dependencies.

### LaTeX

Paste-ready theorem/proof statement.  Keep notation synchronized with Lean names.

### Lean

Expected file and declarations:

```lean
-- target: {args.target_lean}
```

## Proof Obligations

- [ ] State target `|psi>` or matrix/operator target `A` is defined.
- [ ] Candidate unitary `U` or circuit schema is defined.
- [ ] For state preparation, `U |0^n> = |psi>` or first-column equality is stated.
- [ ] For block encoding, the block-entry contract is stated with the exact ancilla projector.
- [ ] Unitarity of `U` is proved or recorded as a named obligation.
- [ ] State normalization or block-encoding normalizer `alpha` is explicit.
- [ ] Auxiliary qubit count `a` is explicit when the construction uses ancillas.
- [ ] Asymptotic tier and concrete resource score `(gateCount, depth, a, oracleCalls)` are explicit.
- [ ] Candidate comparison against the current baseline is recorded when relevant.
- [ ] `lake build && lake build Tests` succeeds.

## Agent Notes

Do not mark this task complete unless the Lean build gate passes.

Use trial logging for every substantial attempt:

```bash
python3 tools/qbe.py trial-log --task {args.id} --role lower --kind attempt --status running --notes "starting construction search"
python3 tools/qbe.py trial-summary
```
"""


def cmd_new_task(args: argparse.Namespace) -> int:
    cmd_init(argparse.Namespace())
    safe_id = slugify(args.id)
    if not safe_id:
        raise SystemExit("task id becomes empty after sanitization")
    path = ROOT / "tasks" / f"{safe_id}.md"
    write_new(path, task_template(args))
    add_manifest("qbe.py new-task", path, "task", f"Created task {args.id}")
    return 0


def cmd_ingest_user_problem(args: argparse.Namespace) -> int:
    """Record a raw user problem in any language as a first-class task input."""
    cmd_init(argparse.Namespace())
    safe_id = slugify(args.id)
    lang = normalize_report_language(args.language)
    raw = args.text or ""
    if args.file:
        raw = read_text(Path(args.file))
    elif not raw and not sys.stdin.isatty():
        raw = sys.stdin.read()
    raw = raw.strip()
    if not raw:
        raise SystemExit("ingest-user-problem requires --text, --file, or stdin")
    title = args.title.strip() or f"User operator task {safe_id}"
    inbox_dir = ROOT / "task-inbox" / safe_id
    prompt_path = inbox_dir / f"user_prompt.{lang}.md"
    prompt_text = f"""# User Problem Input: {safe_id}

Language: `{lang}`

Task title: {title}

Ingested: `{now_stamp()}`

## Raw User Problem

{raw}
"""
    write_text(prompt_path, prompt_text)
    task_path = ROOT / "tasks" / f"{safe_id}.md"
    if args.create_task or not task_path.exists():
        task_text = user_problem_task_template(
            safe_id=safe_id,
            title=title,
            kind=args.kind,
            mode=args.mode,
            language=lang,
            prompt_path=rel(prompt_path),
            source=args.source,
            epsilon=args.epsilon,
            export_targets=args.export_targets,
            executable_check_backend=args.executable_check_backend,
            executable_check_required=args.executable_check_required,
            executable_evidence_classes=args.executable_evidence_classes,
            raw=raw,
        )
        write_text(task_path, task_text)
        action = "Created"
    else:
        append_text_locked(
            task_path,
            "\n".join(
                [
                    "",
                    f"## Additional Raw User Input: {now_stamp()}",
                    "",
                    f"- Language: `{lang}`",
                    f"- Artifact: `{rel(prompt_path)}`",
                    "",
                ]
            ),
        )
        action = "Updated"
    if args.active:
        update_state(lambda state: {**state, "active_task": safe_id})
    add_manifest("qbe.py ingest-user-problem", prompt_path, "task", f"Ingested raw user problem for {safe_id}")
    add_manifest("qbe.py ingest-user-problem", task_path, "task", f"{action} task from raw user problem {safe_id}")
    print(f"ingested: {display_path(prompt_path)}")
    print(f"task: {display_path(task_path)}")
    return 0


def user_problem_task_template(
    *,
    safe_id: str,
    title: str,
    kind: str,
    mode: str,
    language: str,
    prompt_path: str,
    source: str,
    epsilon: str,
    export_targets: str,
    raw: str,
    executable_check_backend: str = "none",
    executable_check_required: bool = False,
    executable_evidence_classes: str = "none",
) -> str:
    lean_root = (
        "UserSubmission."
        + re.sub(r"[^A-Za-z0-9_]", "_", safe_id)
        + "_rootCertificate"
    )
    return f"""# {title}

Task id: `{safe_id}`
Kind: `{kind}`
Mode: `{mode}`
Status: `active`
Lean acceptance anchors: `{lean_root}`

## Source Input

- Raw user language: `{language}`
- Raw input artifact: `{prompt_path}`
- Source: `{source}`
- Requested tolerance: `{epsilon}`
- Requested executable exports: `{export_targets}`
- Executable check backend: `{executable_check_backend}`
- Executable check required: `{str(executable_check_required).lower()}`
- Executable evidence classes: `{executable_evidence_classes}`

## Raw User Problem

{raw}

## Agent Contract

Upper agents must first translate this user-facing target into a precise
operator, normalizer, clean-block projector, error tolerance, and resource
metric.  Middle agents must preserve the raw-language source and explain any
interpretation step.  Lower agents must not prove a different target.

## Current Proof-DAG Frontier

| Node | Interface | Status | Lean |
| --- | --- | --- | --- |
| `ROOT-INITIALIZATION` | Freeze dimensions, normalization, register order, tolerance, and the exact acceptance theorem before candidate search. | active next | `{lean_root}` |
"""


def cmd_update_task(args: argparse.Namespace) -> int:
    path = ROOT / "tasks" / f"{slugify(args.id)}.md"
    if not path.exists():
        raise SystemExit(f"task not found: {path.relative_to(ROOT)}")

    def update_status(text: str) -> str:
        if re.search(r"^Status:", text, flags=re.M):
            return re.sub(
                r"^Status:\s*`?[^`\n]+`?",
                f"Status: `{args.status}`",
                text,
                count=1,
                flags=re.M,
            )
        return text + f"\nStatus: `{args.status}`\n"

    update_text_locked(path, update_status)
    if args.active:
        update_state(lambda state: {**state, "active_task": args.id})
    add_manifest("qbe.py update-task", path, "task", f"Updated {args.id} to {args.status}")
    print(f"updated {path.relative_to(ROOT)}")
    return 0


def cmd_conversion_window(args: argparse.Namespace) -> int:
    cmd_init(argparse.Namespace())
    safe_id = slugify(args.id)
    path = ROOT / "conversion-windows" / f"{safe_id}.md"
    text = f"""# Conversion Window: {args.title}

Task id: `{args.id}`
Created: `{now_stamp()}`

This is the controlled crossing between a paper, human explanation, and Lean.
Do not let a symbol move from LaTeX to Lean without recording its type, role,
normalization, and acceptance condition.

## LaTeX Input

Paste the theorem, definition, or proof fragment here.

## Symbol Map

List the Lean declarations that correspond to the LaTeX symbols.

| LaTeX | Markdown meaning | Lean name | Type / role | Status |
| --- | --- | --- | --- | --- |
| `A` | target matrix/operator | `A` | matrix target | unmapped |
| `U` | candidate circuit unitary | `U` | circuit matrix | unmapped |
| `alpha` | block-encoding normalizer | `alpha` | scalar/resource | unmapped |

## Oracle Contract

- Target operator:
- Claimed oracle behavior:
- Required block entry:
- Ancilla registers:
- Normalizer:
- Resource expression:

## Markdown Explanation

Short human-readable explanation of the construction and what must be verified.

## Lean Declaration Plan

| Declaration | File | Purpose | Builds? |
| --- | --- | --- | --- |
| TBD | `QuantumBlockEncoding/` | formal target | no |

## Lean Scratch

```lean
-- Add or update Lean code here before moving it to source files.
```

## Proof Obligations

- [ ] Matrix/operator target is represented in Lean.
- [ ] Candidate circuit/matrix is represented in Lean.
- [ ] Block-encoding predicate is stated against that matrix.
- [ ] Resource count is represented.
- [ ] Every nontrivial paper assumption is either proved or logged as an open problem.

## Agent Dialogue

Append short messages here or use:

```bash
python3 tools/qbe.py agent-note latest --role lower --message "Found missing normalizer definition."
```

## Build Gate

```bash
lake build && lake build Tests
```
"""
    write_new(path, text)
    add_manifest("qbe.py conversion-window", path, "conversion", f"Created conversion window {args.id}")
    return 0


def cmd_new_open_problem(args: argparse.Namespace) -> int:
    cmd_init(argparse.Namespace())
    path = ROOT / "open-problem-proposals" / f"{slugify(args.id)}.md"
    text = f"""# {args.title}

Candidate id: `{args.id}`
Status: `draft`
Created: `{now_stamp()}`

## Motivation

{args.motivation or "Describe which paper assumption or failed construction exposes this gap."}

## Formal Target

State the exact matrix, circuit, block encoding, or resource condition.

## Acceptance Test

State the Lean artifact that would close this problem.

## References

- {args.reference or "TBD"}

## Promotion Checklist

- [ ] Add entry to `QuantumBlockEncoding/OpenProblems.lean`.
- [ ] Add human-readable expansion to `docs/open_problems.md`.
- [ ] Run `python3 tools/qbe.py check`.
"""
    write_new(path, text)
    add_manifest("qbe.py new-open-problem", path, "open-problem", f"Created open problem proposal {args.id}")
    return 0


def cmd_agent_brief(args: argparse.Namespace) -> int:
    cmd_init(argparse.Namespace())
    task_path = ROOT / "tasks" / f"{slugify(args.id)}.md"
    if task_path.exists():
        task_text = read_text(task_path)
        title = task_text.splitlines()[0].lstrip("# ").strip()
    else:
        seeds = {task.get("id"): task for task in parse_seed_tasks()}
        if args.id not in seeds:
            raise SystemExit(f"task not found in tasks/ or Automation.lean: {args.id}")
        seed = seeds[args.id]
        title = seed.get("title", args.id)
        task_text = f"Seed task from Automation.lean\n\nTarget: {seed.get('targetLean')}\nSource: {seed.get('source')}\n"
    literature = subprocess.run(
        [sys.executable, str(Path(__file__).resolve()), "list-literature"],
        cwd=ROOT,
        text=True,
        stdout=subprocess.PIPE,
        check=False,
    ).stdout
    path = ROOT / "agent-briefs" / f"{slugify(args.id)}.md"
    recent_trials = recent_trial_text(args.id, limit=8)
    text = f"""# Agent Brief: {title}

Task id: `{args.id}`
Created: `{now_stamp()}`

## Mission

Advance this task toward a Lean-compiled block-encoding or oracle certificate.

## Task Contract

{task_text}

## Current Literature Registry

```text
{literature.strip()}
```

## Required Gate

```bash
lake build && lake build Tests
```

## Three-Layer Agent Protocol

- Upper agent: choose strategy, accept/reject directions, compress findings.
- Middle agent: maintain Lean-to-natural-language and natural-language-to-Lean
  proof translation, proof obligations, and compact memory.  LaTeX export is a
  closeout task, not an inner-cycle requirement.
- Lower agents: try one concrete circuit/proof construction each.
- Reviewer: check the actual Lean diff, resource assumptions, and citation trail.

Agents coordinate through `runs/<run-id>/dialogue.md` and append trial records to
`runs/trials.jsonl`.

## Recent Trial Memory

```text
{recent_trials}
```

## Working Instructions

1. Use a conversion window for any natural-language/Lean translation.
2. Put checked code in `QuantumBlockEncoding/`.
3. Put unresolved theorem gaps in `proof-obligations/`.
4. If a paper assumes an unimplemented oracle, draft an open problem proposal.
5. Update `MANIFEST.md` through `tools/qbe.py` commands when creating artifacts.
6. Log each attempt with `tools/qbe.py trial-log`.
"""
    write_new(path, text)
    add_manifest("qbe.py agent-brief", path, "brief", f"Created agent brief {args.id}")
    return 0


def recent_trial_text(task_id: str | None = None, limit: int = 10) -> str:
    records = load_recent_jsonl(TRIAL_LOG)
    if task_id:
        records = [record for record in records if record.get("task_id") == task_id]
    if not records:
        return "no trial records yet"
    lines = []
    for record in records[-limit:]:
        lines.append(
            "{timestamp} {role}/{kind} {status} score={score} :: {notes}".format(
                timestamp=record.get("timestamp", ""),
                role=record.get("role", ""),
                kind=record.get("kind", ""),
                status=record.get("status", ""),
                score=record.get("score", ""),
                notes=record.get("notes", ""),
            )
        )
    return "\n".join(lines)


def extract_section(text: str, heading_patterns: list[str]) -> str:
    matches: list[re.Match[str]] = []
    for pattern in heading_patterns:
        matches.extend(re.finditer(pattern, text, flags=re.M | re.I))
    if not matches:
        return ""
    match = sorted(matches, key=lambda m: m.start())[-1]
    start = match.start()
    next_match = re.search(r"^## (?!#).*$", text[start + 1 :], flags=re.M)
    end = start + 1 + next_match.start() if next_match else len(text)
    return text[start:end].strip()


def extract_preferred_section(text: str, heading_patterns: list[str]) -> str:
    """Extract the latest section for the first heading pattern that matches.

    `extract_section` intentionally returns the latest matching heading across
    all patterns.  That is useful for broad scans, but task directives need a
    priority order: a fresh `Current Run Directive` must override an older
    `Immediate 6h Focus` section even if the older section appears later in the
    task file.
    """
    for pattern in heading_patterns:
        matches = list(re.finditer(pattern, text, flags=re.M | re.I))
        if not matches:
            continue
        sections: list[tuple[int, str]] = []
        for match in matches:
            start = match.start()
            next_match = re.search(r"^## (?!#).*$", text[start + 1 :], flags=re.M)
            end = start + 1 + next_match.start() if next_match else len(text)
            sections.append((start, text[start:end].strip()))
        if "Current Run Directive" in pattern:
            def score(item: tuple[int, str]) -> tuple[int, int]:
                start, section = item
                lowered = section.lower()
                value = 0
                # A task file keeps historical directives for audit.  The
                # current directive is the fresh top section; do not let older
                # sections with legacy keywords outrank it.
                if start < 2000:
                    value += 10000
                if "source_prepared_projection_summation_correction" in section:
                    value += 2000
                if "finite_projection_feeder" in section or "final finite projection" in lowered:
                    value += 1000
                if "active lower2 target" in lowered:
                    value += 100
                return (value, -start)

            return max(sections, key=score)[1]
        return sorted(sections, key=lambda item: item[0])[-1][1]
    return ""


def compact_markdown_lines(path: Path, patterns: list[str], limit: int = 30) -> list[str]:
    if not path.exists():
        return []
    out: list[str] = []
    compiled = [re.compile(pattern, flags=re.I) for pattern in patterns]
    for raw in read_text(path).splitlines():
        line = raw.strip()
        if not line:
            continue
        if any(pattern.search(line) for pattern in compiled):
            out.append(line)
        if len(out) >= limit:
            break
    return out


def current_obligation_table_rows(text: str, limit: int = 20) -> list[str]:
    """Extract only the latest append-only obligation state."""
    return latest_obligation_rows(text, limit=limit)


def lean_index_files_for_task(task_text: str) -> list[Path]:
    """Return the Lean files that are relevant enough for prompt-time indexing.

    The default must be narrow.  A previous broad `QuantumBlockEncoding/*.lean`
    scan pulled the historical `RobinMatrix.lean` proof-development file into
    unrelated operator-construction prompts, wasting context and confusing the
    active task.  Task-specific branches should name their own files; the
    fallback excludes optional research modules with active obligations.
    """

    haystack = task_text.lower()
    evaluation_mode = infer_evaluation_mode(task_text)
    if evaluation_mode in {"task-only", "isolated-abeis"} and "forbidden" in haystack:
        return [
            ROOT / "QuantumBlockEncoding" / "BlockEncoding.lean",
            ROOT / "QuantumBlockEncoding" / "BlockEncodingClassics.lean",
            ROOT / "QuantumBlockEncoding" / "CircuitSemantics.lean",
            ROOT / "QuantumBlockEncoding" / "Core.lean",
            ROOT / "QuantumBlockEncoding" / "Circuit.lean",
        ]
    if any(marker in task_text for marker in ["GHL2025", "Guseynov", "Robin", "QBE-AUTO-002"]):
        return [
            ROOT / "QuantumBlockEncoding" / "GHL2025.lean",
            ROOT / "QuantumBlockEncoding" / "RobinMatrix.lean",
            ROOT / "QuantumBlockEncoding" / "CircuitSemantics.lean",
            ROOT / "QuantumBlockEncoding" / "BlockEncoding.lean",
        ]
    if "QBE-OP-CUBIC-STATEPREP-001" in task_text or "cubic" in haystack or "state-preparation" in haystack:
        return [
            ROOT / "QuantumBlockEncoding" / "CubicStatePreparation.lean",
            ROOT / "QuantumBlockEncoding" / "StatePreparation.lean",
            ROOT / "QuantumBlockEncoding" / "BlockEncodingClassics.lean",
            ROOT / "QuantumBlockEncoding" / "BlockEncoding.lean",
            ROOT / "QuantumBlockEncoding" / "Core.lean",
            ROOT / "QuantumBlockEncoding" / "Circuit.lean",
        ]
    if "QBE-OP-OPTCTRL-001" in task_text or "optimal-control" in haystack or "transfer-operator" in haystack:
        return [
            ROOT / "QuantumBlockEncoding" / "OptimalControl.lean",
            ROOT / "QuantumBlockEncoding" / "BlockEncoding.lean",
            ROOT / "QuantumBlockEncoding" / "CircuitSemantics.lean",
            ROOT / "QuantumBlockEncoding" / "Core.lean",
        ]
    excluded = {"RobinMatrix.lean"}
    return [
        path
        for path in sorted((ROOT / "QuantumBlockEncoding").glob("*.lean"))
        if path.name not in excluded
    ]


def lean_declaration_index(task_text: str, limit: int = 80) -> list[dict[str, str]]:
    keywords = ("theorem", "lemma", "def", "structure", "inductive", "abbrev")
    files = lean_index_files_for_task(task_text)
    rows: list[dict[str, str]] = []
    decl_re = re.compile(r"^\s*(?:noncomputable\s+)?(" + "|".join(keywords) + r")\s+([A-Za-z0-9_'.]+)")
    for path in files:
        if not path.exists():
            continue
        for line_no, line in enumerate(read_text(path).splitlines(), start=1):
            match = decl_re.match(line)
            if not match:
                continue
            name = match.group(2)
            if task_text and any(token in task_text for token in ["GHL2025", "Robin", "QBE-AUTO-002"]):
                if not any(marker in name for marker in ["GHL", "Robin", "robin", "Circuit", "Block", "banded", "functionOracle", "boundary", "swap", "indicator", "oneTerm"]):
                    continue
            if task_text and ("QBE-OP-CUBIC-STATEPREP-001" in task_text or "cubic" in task_text.lower()):
                if path.name == "CubicStatePreparation.lean":
                    pass
                elif not any(marker in name for marker in ["BlockEncoding", "QueryOperatorTarget", "Matrix", "gridSize", "Resource", "Circuit", "RegisterLayout", "Adaptive"]):
                    continue
            if task_text and ("QBE-OP-OPTCTRL-001" in task_text or "optimal-control" in task_text.lower()):
                if path.name == "OptimalControl.lean":
                    pass
                elif not any(marker in name for marker in ["BlockEncoding", "QueryOperatorTarget", "Matrix", "Circuit", "RegisterLayout", "Adaptive", "Resource"]):
                    continue
            rows.append(
                {
                    "file": rel(path),
                    "line": str(line_no),
                    "kind": match.group(1),
                    "name": name,
                }
            )
    return rows[-limit:]


def reusable_memory_card_rows(task_text: str, limit: int = 8) -> list[dict[str, object]]:
    """Rank a compact set of reusable cards without replaying the full wiki."""

    card_roots = [
        ROOT / "research-wiki" / "block-encoding-library" / "cards",
        ROOT / "research-wiki" / "state-preparation-library",
    ]
    paths = [
        path
        for root in card_roots
        if root.exists()
        for path in root.glob("*.md")
        if path.is_file()
    ]
    query = set(re.findall(r"[a-z0-9]+", task_text.lower()))
    stop = {
        "the", "and", "for", "with", "from", "this", "that", "task", "lean",
        "proof", "status", "active", "current", "exact", "operator", "target",
    }
    query -= stop
    lowered = task_text.lower()
    compiled_names: set[str] = set()
    for lean_path in lean_index_files_for_task(task_text):
        if not lean_path.exists():
            continue
        for match in re.finditer(
            r"(?m)^\s*(?:noncomputable\s+)?(?:def|abbrev|structure|class|theorem|lemma)\s+"
            r"([A-Za-z_][A-Za-z0-9_'.]*)",
            read_text(lean_path),
        ):
            compiled_names.add(match.group(1).rsplit(".", 1)[-1])
    rows: list[dict[str, object]] = []
    for path in paths:
        text = read_text(path)
        searchable = (path.stem + "\n" + text[:5000]).lower()
        tokens = set(re.findall(r"[a-z0-9]+", searchable)) - stop
        score = len(query & tokens)
        stem = path.stem.lower()
        if any(marker in lowered for marker in ("cubic", "x^3", "polynomial", "qsvt")):
            if "arithmetic.product" in stem:
                score += 160
            if "qsvt.consumer" in stem:
                score += 100
            if "rationalhouseholder" in stem:
                score += 180
        if "diagonal" in lowered and "entrywiseexact" in stem:
            score += 80
        if any(marker in lowered for marker in ("state preparation", "state-preparation", "first column")):
            if "route-selector" in stem:
                score += 200
            if "core.firstcolumn" in stem:
                score += 240
        if any(marker in lowered for marker in (
            "ancilla", "auxiliary qubit", "controlled conjugation",
            "promise register", "dirty workspace", "dirty ancilla",
        )) and "promiseancillatradeoff" in stem:
            score += 220
        anchors = []
        for token in re.findall(r"`([A-Za-z_][A-Za-z0-9_'.]+)`", text):
            if token not in anchors:
                anchors.append(token)
            if len(anchors) >= 12:
                break
        compiled_anchors = [
            anchor
            for anchor in anchors
            if anchor.rsplit(".", 1)[-1] in compiled_names
        ]
        if compiled_anchors:
            score += 20 + 4 * len(compiled_anchors)
        rows.append(
            {
                "path": rel(path),
                "score": score,
                "lean_anchors": anchors,
                "compiled_lean_anchors": compiled_anchors,
                "missing_lean_anchors": [
                    anchor for anchor in anchors if anchor not in compiled_anchors
                ],
            }
        )
    ranked = sorted(rows, key=lambda row: (-int(row["score"]), str(row["path"])))
    return [row for row in ranked if int(row["score"]) > 0][:limit]


def infer_blueprint_stage(task_text: str, proof_obligation_text: str) -> str:
    lower = (task_text + "\n" + proof_obligation_text).lower()
    if (
        any(marker in lower for marker in ["current run directive", "immediate 6h focus", "lower agent", "fixed theorem"])
        and any(marker in lower for marker in ["unproved", "remain false", "proved := false", "proof target", "dynamic leaf"])
    ):
        return "Stage 2 DAG proof discharge, with source-transcript checks still active"
    if "phase 1" in lower or "transcript" in lower or "contract capture" in lower:
        return "Stage 1 target/transcript stabilization"
    if "unproved" in lower or "remain false" in lower or "proved := false" in lower:
        return "Stage 2 DAG proof discharge"
    return "Stage unknown; upper must classify before broad lower work"


def dynamic_leaf_candidates(task_text: str, obligation_text: str, dialogue_text: str, limit: int = 12) -> list[str]:
    candidates: list[str] = []
    obligation_lower = obligation_text.lower()
    if (
        "there is no active proof leaf" in obligation_lower
        and "deterministic checker pass" in obligation_lower
    ):
        return []
    directive = extract_preferred_section(task_text, [r"^## Current Run Directive.*?$", r"^## Immediate .*?$"])
    if directive:
        current: list[str] = []
        in_code = False

        def flush_current() -> None:
            if current:
                candidates.append(" ".join(current).strip())
                current.clear()

        for line in directive.splitlines():
            if line.strip().startswith("```"):
                in_code = not in_code
                flush_current()
                continue
            if in_code:
                continue
            stripped = line.strip()
            if stripped.startswith("- ") or re.match(r"^[0-9]+\.", stripped):
                flush_current()
                current.append(stripped)
            elif current and line[:1].isspace() and stripped:
                current.append(stripped)
            else:
                flush_current()
        flush_current()
    if not candidates:
        for line in obligation_text.splitlines():
            stripped = line.strip()
            if not stripped:
                continue
            lowered = stripped.lower()
            if any(marker in lowered for marker in ["unproved", "remain false", "proved := false", "next", "planned", "obligation"]):
                candidates.append(stripped)
    if "already compiled" in dialogue_text or "already implemented" in dialogue_text or "No duplicate" in dialogue_text:
        candidates.insert(
            0,
            "Latest handoff indicates at least one assigned lower target was already compiled; upper/middle should retire stale directives before more proof search.",
        )
    compact: list[str] = []
    seen: set[str] = set()
    for item in candidates:
        item = re.sub(r"\s+", " ", item)
        if len(item) > 260:
            item = item[:257] + "..."
        if item in seen:
            continue
        seen.add(item)
        compact.append(item)
        if len(compact) >= limit:
            break
    return compact


def current_proof_dag_frontier(conversion_text: str, limit: int = 8) -> list[str]:
    return latest_frontier_rows(conversion_text, limit=limit)


def blueprint_path(task_id: str) -> Path:
    return BLUEPRINT_DIR / f"{slugify(task_id)}.md"


def refresh_blueprint(task_id: str) -> Path:
    cmd_init(argparse.Namespace())
    title, task_text = task_context(task_id)
    mode = infer_task_mode(task_text)
    conversion_path = ROOT / "conversion-windows" / f"{slugify(task_id)}.md"
    obligation_path = ROOT / "proof-obligations" / f"{slugify(task_id)}.md"
    task_path = ROOT / "tasks" / f"{slugify(task_id)}.md"
    conversion_text = read_text(conversion_path) if conversion_path.exists() else ""
    obligation_text = read_text(obligation_path) if obligation_path.exists() else ""
    dialogue_text = latest_dialogue_text(task_id, limit_chars=5000)
    stage = infer_blueprint_stage(task_text, obligation_text)
    directive = extract_preferred_section(task_text, [r"^## Current Run Directive.*?$", r"^## Immediate .*?$"])
    if not directive:
        directive = focused_task_contract(task_text)
    declarations = lean_declaration_index(task_text, limit=60)
    leaf_rows = current_proof_dag_frontier(conversion_text) or dynamic_leaf_candidates(task_text, obligation_text, dialogue_text)
    obligation_rows = current_obligation_table_rows(
        obligation_text,
        limit=24,
    ) or compact_markdown_lines(
        obligation_path,
        [
            r"unproved",
            r"remain false",
            r"proved := false",
            r"obligation",
            r"contract",
            r"next",
        ],
        limit=24,
    )
    correspondence_files = [
        task_path,
        conversion_path,
        obligation_path,
        ROOT / "paper-notes" / "GHL2025_RobinOneTerm.tex",
        ROOT / "paper-notes" / "GHL2025" / "markdown" / "00_status.md",
        ROOT / "paper-notes" / "GHL2025" / "latex" / "sections" / "00_status.tex",
        ROOT / "research-wiki" / "cited-results" / "GHL2025.md",
    ]
    artifacts = [path for path in correspondence_files if path.exists()]
    text = f"""# Proof Blueprint: {task_id}

Task id: `{task_id}`
Title: {title}
Mode: `{mode}`
Updated: `{now_stamp()}`
Blueprint stage: `{stage}`

This is QBE's compact system-of-record snapshot for long-horizon Lean proof
automation.  It follows a similar control pattern to LeanMarathon's evolving
blueprint, but QBE keeps the human-facing proof map split across Lean,
Markdown, LaTeX, proof obligations, and cited-results memory because
block-encoding papers require source notation, register conventions, and
oracle contracts to stay explicit.

## Current Directive

````text
{directive.strip()}
````

## Dynamic Leaf Queue

These are the current local proof or repair candidates.  Lower agents should
work on one item at a time; if an item is stale, upper/middle must retire it
before spending more proof-search tokens.

| Leaf | Status |
|---|---|
"""
    for item in leaf_rows:
        status = "stale-check" if item.startswith("Latest handoff indicates") else "candidate"
        text += f"| {item.replace('|', '/')} | {status} |\n"
    if not leaf_rows:
        text += "| none detected | upper must refresh the task directive |\n"
    text += """
## Open Obligation Signals

```text
"""
    text += "\n".join(obligation_rows) if obligation_rows else "no compact obligation signals found"
    text += """
```

## Lean Declaration Index

Recent task-relevant declarations:

| Kind | Lean name | File |
|---|---|---|
"""
    for row in declarations:
        text += f"| {row['kind']} | `{row['name']}` | `{row['file']}:{row['line']}` |\n"
    if not declarations:
        text += "| none | no task-relevant declaration found | n/a |\n"
    text += """
## Correspondence Artifacts

| Artifact | Role |
|---|---|
"""
    for path in artifacts:
        role = "task/proof map"
        if "conversion-windows" in str(path):
            role = "Lean/natural-language conversion"
        elif "proof-obligations" in str(path):
            role = "open obligations"
        elif "paper-notes" in str(path):
            role = "human-readable proof export"
        elif "cited-results" in str(path):
            role = "external theorem memory"
        text += f"| `{rel(path)}` | {role} |\n"
    text += f"""
## Latest Dialogue Signal

````text
{dialogue_text[-3000:]}
````

## Gate Policy

- Stage 1 target/transcript stabilization: upper and middle must verify that
  Lean statements, source-paper prose, register layouts, normalizers, and
  cited contracts match before broad lower proving.
- Stage 2 DAG proof discharge: lower agents work on dynamic leaves only;
  reviewer accepts inner-cycle progress only through `python3 tools/qbe.py check`
  and synchronized Lean-to-natural-language proof status.  LaTeX exports are
  checked at 6h/convergence closeout.
- Mixed lower-agent proof mode: lower 1 writes the natural-language dependency
  proof and active-leaf table; lower 2 compiles exactly one ready Lean leaf;
  lower 3, when available, runs necessary-condition diagnostics such as finite
  matrix/path/support checks and typed verifier-feedback packets before lower 2
  spends time on a large Lean proof.
- Refiner behavior: when several failures share a dependency, repair the
  connected illness area once instead of stacking independent patches.
- No agent may mark a proof complete from self-assessment, partial score, or
  process memory.  Lean plus explicit proof-map correspondence is the gate.
"""
    path = blueprint_path(task_id)
    atomic_write_text(path, text)
    add_manifest("qbe.py blueprint-refresh", path, "blueprint", f"Refreshed proof blueprint for {task_id}")
    return path


def blueprint_context(task_id: str, max_chars: int = 8000) -> str:
    path = blueprint_path(task_id)
    if not path.exists():
        return "No proof blueprint yet. Run `python3 tools/qbe.py blueprint-refresh <task-id>`."
    text = read_text(path).strip()
    if len(text) <= max_chars:
        return text
    return text[:4000] + "\n\n...[blueprint truncated]...\n\n" + text[-(max_chars - 4030):]


def cmd_blueprint_refresh(args: argparse.Namespace) -> int:
    path = refresh_blueprint(args.id)
    print(f"refreshed {rel(path)}")
    return 0


def latest_task_run_name(task_id: str) -> str:
    runs = sorted([path for path in (ROOT / "runs").glob(f"*-{slugify(task_id)}-cycle*") if path.is_dir()])
    return runs[-1].name if runs else "none"


def blueprint_status_state(task_id: str) -> dict:
    title, task_text = task_context(task_id)
    obligation_path = ROOT / "proof-obligations" / f"{slugify(task_id)}.md"
    conversion_path = ROOT / "conversion-windows" / f"{slugify(task_id)}.md"
    obligation_text = read_text(obligation_path) if obligation_path.exists() else ""
    conversion_text = read_text(conversion_path) if conversion_path.exists() else ""
    dialogue_text = latest_dialogue_text(task_id, limit_chars=5000)
    declarations = lean_declaration_index(task_text, limit=50)
    leaves = current_proof_dag_frontier(conversion_text, limit=10) or dynamic_leaf_candidates(task_text, obligation_text, dialogue_text, limit=10)
    obligation_rows = current_obligation_table_rows(
        obligation_text,
        limit=20,
    ) or compact_markdown_lines(
        obligation_path,
        [
            r"unproved",
            r"remain false",
            r"proved := false",
            r"obligation",
            r"contract",
            r"source",
            r"next",
        ],
        limit=20,
    )
    records = [record for record in load_recent_jsonl(TRIAL_LOG) if record.get("task_id") == task_id]
    role_counts: dict[str, int] = {}
    status_counts: dict[str, int] = {}
    for record in records:
        role = str(record.get("role", "unknown"))
        status = str(record.get("status", "unknown"))
        role_counts[role] = role_counts.get(role, 0) + 1
        status_counts[status] = status_counts.get(status, 0) + 1
    source_rows = []
    for key, path in local_paper_source_candidates(task_text):
        main_tex = path / "main.tex"
        source_rows.append(
            {
                "key": key,
                "path": display_path(main_tex),
                "exists": main_tex.exists(),
            }
        )
    if any(row["exists"] for row in source_rows):
        source_rows = [row for row in source_rows if row["exists"]]
    acceptance_anchors = infer_acceptance_anchors(task_text)
    verified_anchors = verified_task_acceptance_anchors(task_id, task_text=task_text)
    if not leaves and acceptance_anchors and not verified_anchors:
        root = acceptance_anchors[0]
        leaves = [
            f"ROOT-INITIALIZATION: construct the certificate DAG for the declared root; "
            f"status: active next; Lean: {root}"
        ]
    return {
        "task_id": task_id,
        "title": title,
        "generated": now_stamp(),
        "mode": infer_task_mode(task_text),
        "stage": infer_blueprint_stage(task_text, obligation_text),
        "latest_cycle": latest_task_run_name(task_id),
        "blueprint_path": display_path(blueprint_path(task_id)),
        "conversion_window": display_path(conversion_path),
        "proof_obligations": display_path(obligation_path),
        "dynamic_leaf_queue": leaves,
        "open_obligation_signals": obligation_rows,
        "lean_declarations": declarations,
        "reusable_memory_cards": reusable_memory_card_rows(task_text),
        "acceptance_anchors": list(acceptance_anchors),
        "verified_acceptance_anchors": list(verified_anchors),
        "trial_counts_by_role": role_counts,
        "trial_counts_by_status": status_counts,
        "local_paper_sources": source_rows,
        "changed_files": git_changed_files(),
        "controls_absorbed": [
            "ASTIS-style compact context/status artifacts for long runs",
            "LeanMarathon-style durable proof blueprint and dynamic leaf queue",
            "LBG-style trial memory and reviewer feedback compression",
            "EoH-style candidate/proof-attempt populations only where QBE mode permits them",
        ],
    }


def blueprint_status_text(state: dict) -> str:
    role_lines = [
        f"- `{role}`: {count}"
        for role, count in sorted(state["trial_counts_by_role"].items())
    ] or ["- no trial records"]
    status_lines = [
        f"- `{status}`: {count}"
        for status, count in sorted(state["trial_counts_by_status"].items())
    ] or ["- no trial records"]
    source_lines = []
    for row in state["local_paper_sources"]:
        status = "found" if row["exists"] else "missing"
        source_lines.append(f"- `{row['key']}` {status}: `{row['path']}`")
    declaration_lines = []
    for row in state["lean_declarations"]:
        declaration_lines.append(f"- `{row['kind']} {row['name']}` at `{row['file']}:{row['line']}`")
    changed_lines = [f"- `{path}`" for path in state["changed_files"][:40]] or ["- none"]
    return "\n".join(
        [
            "# QBE Blueprint Status",
            "",
            f"- Task: `{state['task_id']}`",
            f"- Title: {state['title']}",
            f"- Generated: `{state['generated']}`",
            f"- Mode: `{state['mode']}`",
            f"- Stage: {state['stage']}",
            f"- Latest cycle: `{state['latest_cycle']}`",
            f"- Blueprint: `{state['blueprint_path']}`",
            f"- Lean acceptance anchors: {', '.join(f'`{name}`' for name in state.get('acceptance_anchors', [])) or 'none declared'}",
            f"- Verified root anchors: {', '.join(f'`{name}`' for name in state.get('verified_acceptance_anchors', [])) or 'none'}",
            "",
            "## Dynamic Leaf Queue",
            "",
            "\n".join(f"- {leaf}" for leaf in state["dynamic_leaf_queue"]) or "- none detected",
            "",
            "## Open Obligation Signals",
            "",
            "\n".join(f"- {item}" for item in state["open_obligation_signals"]) or "- no compact obligation signals found",
            "",
            "## Trial Counts By Role",
            "",
            "\n".join(role_lines),
            "",
            "## Trial Counts By Status",
            "",
            "\n".join(status_lines),
            "",
            "## Local Paper Sources",
            "",
            "\n".join(source_lines) if source_lines else "- no source candidates inferred",
            "",
            "## Recent Lean Declarations",
            "",
            "\n".join(declaration_lines[-30:]) if declaration_lines else "- none indexed",
            "",
            "## Current Dirty Files",
            "",
            "\n".join(changed_lines),
            "",
            "## Controls",
            "",
            "\n".join(f"- {item}" for item in state["controls_absorbed"]),
            "",
            "## Next-Cycle Rule",
            "",
            "- Upper must choose one dynamic leaf or one refiner illness area before lower work.",
            "- Middle must map the selected source/user proof fragment to Lean declarations or explicit obligations in concise natural language.",
            "- Lower 1 writes the natural-language DAG proof packet; lower 2 proves one ready Lean leaf; lower 3, if present, runs finite/path/support diagnostics and records typed verifier feedback.",
            "- Lower must edit only the assigned local target and run `python3 tools/qbe.py check` after Lean edits.",
            "- Reviewer accepts inner-cycle progress only when the Lean gate and the natural-language proof map are synchronized; LaTeX export is checked at closeout.",
        ]
    ) + "\n"


def cmd_blueprint_status(args: argparse.Namespace) -> int:
    if args.refresh:
        refresh_blueprint(args.id)
    state = blueprint_status_state(args.id)
    output = Path(args.output) if args.output else BLUEPRINT_DIR / f"{slugify(args.id)}-status.md"
    if not output.is_absolute():
        output = ROOT / output
    write_text(output, blueprint_status_text(state))
    json_path = output.with_suffix(".json")
    write_text(json_path, json.dumps(state, indent=2, sort_keys=True, ensure_ascii=False) + "\n")
    add_manifest("qbe.py blueprint-status", output, "blueprint", f"Wrote blueprint status for {args.id}")
    print(f"status: {display_path(output)}")
    print(f"json: {display_path(json_path)}")
    return 0


def build_context_pack(task_id: str, cycle: int) -> str:
    title, task_text = task_context(task_id)
    paper_sources = local_paper_source_context(task_text)
    return "\n".join(
        [
            f"# QBE Context Pack: {task_id} cycle {cycle}",
            "",
            f"- Task: `{task_id}`",
            f"- Title: {title}",
            f"- Generated: `{now_stamp()}`",
            f"- Mode: `{infer_task_mode(task_text)}`",
            "",
            "## Focused Task Contract",
            "",
            focused_task_contract(task_text),
            "",
            "## Proof Blueprint",
            "",
            "```text",
            blueprint_context(task_id, max_chars=7000),
            "```",
            "",
            "## Recent Trial Memory",
            "",
            "```text",
            recent_trial_text(task_id, limit=10),
            "```",
            "",
            "## Local Paper Sources For Agent Work",
            "",
            "```text",
            paper_sources,
            "```",
            "",
            "## Control Discipline",
            "",
            "- Use this compact context before reading long historical files.",
            "- In paper-benchmark mode, reproduce the paper construction and do not add assumptions.",
            "- Translate the selected source/user proof fragment into Lean-facing declarations before lower proof search.",
            "- Maintain a proof-DAG frontier: root theorem, dependencies, active leaves, stale leaves, and owner lower profile.",
            "- Lower 1 writes the natural-language DAG proof packet; lower 2 compiles one ready Lean leaf; lower 3, if present, runs finite/path/support diagnostics before a large Lean proof.",
            "- Export newly accepted Lean proof blocks to problem-specific LaTeX only at 6h/convergence closeout, not after every tiny edit.",
            "- Keep `python3 tools/qbe.py check` as the deterministic gate.",
        ]
    ) + "\n"


def cmd_write_context_pack(args: argparse.Namespace) -> int:
    output = Path(args.output) if args.output else CONTEXT_PACK_DIR / f"{slugify(args.id)}-cycle{args.cycle:03d}.md"
    if not output.is_absolute():
        output = ROOT / output
    write_text(output, build_context_pack(args.id, args.cycle))
    add_manifest("qbe.py write-context-pack", output, "context", f"Wrote compact context pack for {args.id} cycle {args.cycle}")
    print(f"context-pack: {display_path(output)}")
    return 0


def analyze_efficiency_log(path: Path | None, task_id: str) -> dict:
    text = ""
    if path is not None and path.exists():
        text = path.read_text(encoding="utf-8", errors="replace")
    recent_records = [record for record in load_jsonl(TRIAL_LOG) if record.get("task_id") == task_id]
    status_counts: dict[str, int] = {}
    role_counts: dict[str, int] = {}
    for record in recent_records:
        status = str(record.get("status", "unknown"))
        role = str(record.get("role", "unknown"))
        status_counts[status] = status_counts.get(status, 0) + 1
        role_counts[role] = role_counts.get(role, 0) + 1
    cycle_lines = re.findall(r"cycle\s+\d+:\s+runs/[^\s]+", text)
    api_errors = re.findall(r"(?:API Error|Usage limit|429|quota)[^\n]*", text, flags=re.I)
    warnings = re.findall(r"(?:Warning|warning|failed|Build failed)[^\n]*", text)
    successes = len(re.findall(r"success|Build completed successfully", text, flags=re.I))
    check_runs = len(re.findall(r"\$ lake build|\$ python3 tools/qbe.py check|Build completed successfully", text))
    return {
        "task_id": task_id,
        "generated": now_stamp(),
        "log": display_path(path) if path else "none",
        "log_exists": bool(path and path.exists()),
        "line_count": len(text.splitlines()),
        "cycles_seen": cycle_lines[-12:],
        "success_signal_count": successes,
        "check_signal_count": check_runs,
        "api_or_quota_errors": api_errors[-10:],
        "warnings": warnings[-12:],
        "trial_counts_by_status": status_counts,
        "trial_counts_by_role": role_counts,
        "changed_files": git_changed_files(),
        "blueprint_status": blueprint_status_state(task_id),
    }


def efficiency_report_text(report: dict) -> str:
    status_lines = [
        f"- `{status}`: {count}"
        for status, count in sorted(report["trial_counts_by_status"].items())
    ] or ["- no trial records"]
    role_lines = [
        f"- `{role}`: {count}"
        for role, count in sorted(report["trial_counts_by_role"].items())
    ] or ["- no trial records"]
    changed_lines = [f"- `{path}`" for path in report["changed_files"][:50]] or ["- none"]
    blueprint = report["blueprint_status"]
    next_leaf = blueprint["dynamic_leaf_queue"][0] if blueprint["dynamic_leaf_queue"] else "upper must refresh the dynamic leaf queue"
    return "\n".join(
        [
            "# QBE Efficiency Report",
            "",
            f"- Task: `{report['task_id']}`",
            f"- Generated: `{report['generated']}`",
            f"- Log: `{report['log']}`",
            f"- Log exists: `{report['log_exists']}`",
            f"- Log lines: `{report['line_count']}`",
            f"- Success/build signals: `{report['success_signal_count']}`",
            f"- Check/build mentions: `{report['check_signal_count']}`",
            "",
            "## Cycles Seen",
            "",
            "\n".join(f"- {line}" for line in report["cycles_seen"]) or "- none detected",
            "",
            "## API Or Quota Errors",
            "",
            "\n".join(f"- {line}" for line in report["api_or_quota_errors"]) or "- none detected",
            "",
            "## Warnings",
            "",
            "\n".join(f"- {line}" for line in report["warnings"]) or "- none detected",
            "",
            "## Trial Counts By Status",
            "",
            "\n".join(status_lines),
            "",
            "## Trial Counts By Role",
            "",
            "\n".join(role_lines),
            "",
            "## Blueprint Snapshot",
            "",
            f"- Stage: {blueprint['stage']}",
            f"- Latest cycle: `{blueprint['latest_cycle']}`",
            f"- Next leaf/refiner target: {next_leaf}",
            "",
            "## Dirty Files",
            "",
            "\n".join(changed_lines),
            "",
            "## Next-Run Controls",
            "",
            "- Start with `python3 tools/qbe.py blueprint-status --refresh <task>`.",
            "- Use `python3 tools/qbe.py write-context-pack <task> --cycle <n>` for token-lean context.",
            "- Upper must retire stale dynamic leaves before assigning lower proof work.",
            "- Middle must classify blocked paper steps as internal, external cited result, classical Lean lemma, contract drift, or source-contract gap.",
            "- Reviewer should reject cycles that change Lean without updating the proof map or obligation ledger.",
        ]
    ) + "\n"


def cmd_efficiency_report(args: argparse.Namespace) -> int:
    task_id = args.task or infer_active_task_id()
    log_path = Path(args.log) if args.log else latest_log_file()
    if log_path is not None and not log_path.is_absolute():
        log_path = ROOT / log_path
    report = analyze_efficiency_log(log_path, task_id)
    if args.json:
        print(json.dumps(report, indent=2, sort_keys=True, ensure_ascii=False))
    output = Path(args.output) if args.output else EFFICIENCY_DIR / f"{file_stamp()}-{slugify(task_id)}-efficiency.md"
    if not output.is_absolute():
        output = ROOT / output
    write_text(output, efficiency_report_text(report))
    add_manifest("qbe.py efficiency-report", output, "review", f"Wrote efficiency report for {task_id}")
    if not args.json:
        print(f"efficiency-report: {display_path(output)}")
    return 0


GHL2025_SOURCE_ANCHORS = [
    {
        "id": "ODBS",
        "source": "main.tex:784-798",
        "paper": "Lemma 2，引用 arXiv:2405.12855 Lemma 1 的 banded-sparse-access oracle",
        "meaning": "Robin Lemma 2 使用 $\\hat{O}^{BS}_D |0\\rangle^{n-l}|s\\rangle^l|i\\rangle^n = |r_{si}\\rangle^n|i\\rangle^n$，其 primitive 和资源来源明确是前一篇 PDE 论文的 Lemma 1。",
        "status": "fixed-N8 route 已编译；任意 n 的 reversible extension 和统一资源定理仍作为外部来源合同。",
    },
    {
        "id": "ODTS",
        "source": "main.tex:822-843",
        "paper": "Lemma 3，banded-sparse matrix 的 sparse-amplitude oracle",
        "meaning": "clean branch 的振幅是 $D^{(s)}/\\mathcal{N}_D$，另有 square-root complement 分支保证 unitary。",
        "status": "contract/backlog：已有 route record 和 matrix interface；nonzero normalizer、sqrt/arccos 语义、二乘二 unitarity 仍是义务。",
    },
    {
        "id": "Of",
        "source": "main.tex:870-908",
        "paper": "Theorem 5，piece-wise polynomial function 的 amplitude oracle",
        "meaning": "$\\hat{O}_f$ 的 clean branch 振幅是 $f(x_j)/\\mathcal{N}_f$，其余分支与 clean workspace 正交。",
        "status": "contract/backlog：clean branch 已 typed；$\\mathcal{N}_f$ bound、orthogonality、workspace cleanup、unitary completion 还没有完整形式化。",
    },
    {
        "id": "HW",
        "source": "main.tex:948-955",
        "paper": "Sparse-register preparation $H_W^{(\\kappa)}$",
        "meaning": "制备 $\\kappa^{-1/2}\\sum_{s=0}^{\\kappa-1}|s\\rangle$，并引用 Shukla--Vedula 的实现复杂度。",
        "status": "theorem-facing route 已部分使用 clean-column contract；完整 gate-level state-preparation proof 仍是 external/backlog。",
    },
    {
        "id": "Uindic",
        "source": "main.tex:1056-1066",
        "paper": "Indicator unitary $U_{\\mathrm{indic}}(K_1,K_2)$",
        "meaning": "在 bulk region $K_1 \\le i \\le K_2$ 精确把 indicator qubit 置为 $|1\\rangle$。",
        "status": "permutation/self-inverse helper 和 theorem-facing $U_{\\mathrm{indic}}^\\dagger$ slot 已编译；它仍不是 final block-encoding proof。",
    },
    {
        "id": "RyBoundary",
        "source": "main.tex:1077-1085",
        "paper": "Boundary controlled $R_y$ rotations",
        "meaning": "Eq. (27) 漏写系数 2；标准旋转应使用 $\\theta_j^s = 2\\arccos(D_j^{(s)}/\\mathcal{N}_D)$。",
        "status": "fixed-N8 standard-Ry corrected route 已编译；原文单 arccos 仅保留为 source-typo transcript。",
    },
    {
        "id": "RobinTheorem",
        "source": "main.tex:1098-1109",
        "paper": "Theorem：one-term Robin block-encoding",
        "meaning": "声称构造 $A_k$ 的 $(\\mathcal{N}_D\\mathcal{N}_f\\kappa, \\lceil\\log_2 n\\rceil + \\lceil\\log_2 G_f\\rceil + \\lceil\\log_2\\kappa\\rceil + 4, 0)$ block-encoding。",
        "status": "main active target：还没有作为 theorem-facing Lean statement 闭合。",
    },
    {
        "id": "GammaSlices",
        "source": "main.tex:1111-1119",
        "paper": "Eq. ROBIN clarified",
        "meaning": "给出 $\\gamma_1,\\gamma_2,\\gamma_3$ wavefunction slices；关键 clean branch 是 $\\gamma_3$ 系数 $f(x_i)D_i^{(s)}/(\\mathcal{N}_D\\mathcal{N}_f\\kappa)$。",
        "status": "finite boundary instance 已有不少 route lemma；最终 projection/product bridge 还没闭合。",
    },
    {
        "id": "FigRobin",
        "source": "main.tex:1122-1164",
        "paper": "Fig. 1-term Robin circuit caption",
        "meaning": "指定完整 gate order：$H_W^{(\\kappa)}$、$U_{\\mathrm{indic}}$、$\\hat O^S_{D^T}$ 或 boundary $R_y$、$\\hat O^{BS}_{D^T}$、$U_{\\mathrm{indic}}^\\dagger$、$\\hat O_f$、SWAP、$(\\hat O_D^{BS})^\\dagger$、$(H_W^{(\\kappa)})^T$。",
        "status": "theorem-facing transcript guard 已编译：显式 $U_{\\mathrm{indic}}^\\dagger$ 和两侧 $H_W$ prepared route 可见；active backend 七门列表仍是独立 H-free component。",
    },
    {
        "id": "OneD",
        "source": "main.tex:1171-1278",
        "paper": "One-dimensional Hamiltonian block-encoding",
        "meaning": "用 LCU 组合 $A_k$、$A_k^\\dagger$、$B$、$x_\\xi$ 来 block-encode $H$。",
        "status": "one-term Robin 闭合之后再做；不是当前 active theorem blocker。",
    },
    {
        "id": "MultiD",
        "source": "main.tex:1596-1649",
        "paper": "Multi-dimensional block-encoding",
        "meaning": "把 1D 构造推广到 $A^{(d)}$、$B^{(d)}$ 和多维 oracle。",
        "status": "planned；依赖 one-term 和 LCU abstractions。",
    },
    {
        "id": "QSVT",
        "source": "main.tex:1676-1694",
        "paper": "Hamiltonian simulation/QSVT theorem",
        "meaning": "通过引用 Gilyén et al. theorem，把 block-encoding 用于 Hamiltonian simulation。",
        "status": "external theorem application；不是当前 gate-level Robin circuit closure 的一部分。",
    },
    {
        "id": "BlockEncodingDef",
        "source": "main.tex:2027-2035",
        "paper": "Block-encoding definition",
        "meaning": "定义所有 theorem statement 使用的 clean ancilla projection 和 approximation condition。",
        "status": "已作为 semantic target 使用；final one-term theorem 仍需把 circuit entry/projection 接到该定义。",
    },
]


def ghl2025_source_main_tex(task_text: str) -> Path | None:
    for key, path in local_paper_source_candidates(task_text):
        if key.startswith("GHL2025"):
            main_tex = path / "main.tex"
            if main_tex.exists():
                return main_tex
    return None


def lean_sorry_lines(limit: int = 20) -> list[str]:
    pattern_text = r"(^\s*sorry\s*$|:=\s*sorry\b|by\s+sorry\b)"
    scan_roots = [
        path
        for path in [ROOT / "QuantumBlockEncoding", ROOT / "Tests", ROOT / "ABEISTests"]
        if path.exists()
    ]
    rg = shutil.which("rg")
    if rg:
        code, output = run_capture(
            [rg, "-n", pattern_text, *[rel(path) for path in scan_roots]]
        )
        if code not in (0, 1):
            return [f"rg failed: {output.strip()}"]
        lines = [
            line.strip()
            for line in output.splitlines()
            if line.strip() and not line.startswith("QuantumBlockEncoding/RobinMatrix.lean:")
        ]
        return lines[:limit]

    pattern = re.compile(pattern_text)
    lines: list[str] = []
    for root in scan_roots:
        for path in sorted(root.rglob("*.lean")):
            relative_path = path.relative_to(ROOT).as_posix()
            if relative_path == "QuantumBlockEncoding/RobinMatrix.lean":
                continue
            try:
                text = path.read_text(encoding="utf-8")
            except UnicodeDecodeError:
                text = path.read_text(encoding="utf-8", errors="replace")
            for line_no, line in enumerate(text.splitlines(), start=1):
                if pattern.search(line):
                    lines.append(f"{relative_path}:{line_no}:{line.strip()}")
                    if len(lines) >= limit:
                        return lines
    return lines


def current_ghl2025_focus() -> list[str]:
    return [
        "保持 theorem-facing Fig. 4 transcript guard：显式 $U_{\\mathrm{indic}}^\\dagger$ 和两侧 $H_W^{(\\kappa)}$ prepared route 已可见，不要把 H-free 七门 backend 当作完整 Fig. 4 theorem。",
        "继续把 raw symbolic `Coeff` matrix equality 路线放在 diagnostic/backlog；当前主路线是 post-feeder active/prepared composition field，即把 active 七门 `[0,0]` evaluated entry 和 prepared sparse clean-clean entry 对齐。",
        "已编译的 `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3` 和 `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3` 只是 support feeders；不要把它们重新派给 lower。",
        "已编译的 `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3` 只是 slots `3` through `6` 的 support feeder；不要把它当作 full branch vanish。",
        "已编译的 `oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3` 是 slot-`1` full evaluated branch vanish feeder；不要重新派给 lower，也不要把它当作 theorem closure。",
        "已编译的 `oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3` 是 slot-`3` full evaluated branch vanish feeder；不要重新派给 lower，也不要把它当作 theorem closure。",
        "已编译的 `oneTermRobinGamma3BoundaryBackendBranchContribution_slotFourEval_zero_n3` 是 slot-`4` full evaluated branch vanish feeder；不要重新派给 lower，也不要把它当作 theorem closure。",
        "已编译的 `oneTermRobinGamma3BoundaryBackendBranchContribution_slotFiveEval_zero_n3` 是 slot-`5` full evaluated branch vanish feeder；不要重新派给 lower，也不要把它当作 theorem closure。",
        "已编译的 `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_preparedSparseCleanEntry_n3` 是 strict feeder；不要重新派给 lower。",
        "下一 Lean leaf 优先是 RHS unwrapped equality of `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_preparedSparseCleanEntry_n3 H env`，或等价的 `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env` / `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`。",
        "不要默认重试 H-free active selected-slot comparison；最新 diagnostic obstruction 已把这条路线分类为 shape/register gap，除非 lower 先给出新的 source-faithful active path。",
        "中层每轮对照 `main.tex:1098-1164`，明确哪些是 GHL 本文贡献、哪些是 Lemma 1/Lemma 3/Theorem 5 等外部 primitive contract。",
        "reviewer 必须拒绝新增假设、替换 oracle、把 contract-only 结果标成 proved，或继续证明已经判定为错误路线的 raw equality。",
    ]


def operator_construction_summary_zh(task_id: str, cycle: int, run_dir: Path) -> str:
    title, _task_text = task_context(task_id)
    state = blueprint_status_state(task_id)
    memory = memory_snapshot_state(task_id, cycle, run_dir)
    sorry_lines = lean_sorry_lines(limit=30)
    changed_lines = git_changed_files()
    latest_dialogue = read_text(run_dir / "dialogue.md") if (run_dir / "dialogue.md").exists() else ""
    dialogue_tail = latest_dialogue[-1800:].strip() if latest_dialogue.strip() else "本轮 dialogue 还没有有效交接。"
    dynamic = state.get("dynamic_leaf_queue", [])
    obligations = state.get("open_obligation_signals", [])
    sorry_text = "\n".join(f"- `{line}`" for line in sorry_lines) if sorry_lines else "- 当前没有检测到 `sorry`。"
    changed_text = "\n".join(f"- `{line}`" for line in changed_lines[:40]) if changed_lines else "- 当前工作区没有未提交变更。"
    dynamic_text = "\n".join(f"- {item}" for item in dynamic) if dynamic else "- blueprint 没有检测到动态 leaf；upper 需要刷新目标。"
    obligation_text = "\n".join(f"- {item}" for item in obligations[:20]) if obligations else "- 没有 compact obligation signals；请检查 `proof-obligations/` 原文。"
    feedback_text = markdown_table(
        memory.get("recent_verifier_feedback", []),
        [
            ("leaf", "leaf"),
            ("class", "error_class"),
            ("finite", "finite_matrix_ok"),
            ("entry", "block_entry_ok"),
            ("next", "next_route"),
        ],
        limit=8,
    )
    lower_task_text = markdown_table(
        memory.get("next_lower_tasks", []),
        [
            ("角色", "role"),
            ("目标", "goal"),
            ("产物", "must_write"),
        ],
    )
    if task_id == "QBE-OP-CUBIC-STATEPREP-001":
        verdict = """当前结论：这个 cubic 例子已经进入自适应 Scenario 2 任务轨道，但还没有完成最终 block encoding。系统已经识别出它不是普通 unitary state preparation，因为

```text
sum_j (j / 2^n)^3 |j>
```

一般不是归一化量子态。因此 Lean 目标被固定为秩一算子

```text
O_n = |v_n><0^n|,  v_n[j] = (j / 2^n)^3.
```

这一步是正确的目标澄清，不是最终构造。当前还没有任何 cubic 候选进入 certified population；因此不能画“已经找到 final exact/approx BE”的曲线，也不能声称已经优于外部系统的最终构造。"""
        curve_status = """- 简单主例 `QBE-OP-OPTCTRL-001` 已有 Lean-certified evolution curve：`docs/assets/optctrl_evolution.png`。
- cubic benchmark 目前只有自适应 Scenario 2 诊断曲线/表格：`reports/cubic-stateprep/latest.md` 和 dense verifier scaling；还没有 certified exact-phase / approximate-phase champion 曲线。
- 任何 README 或技术报告中关于 cubic 的曲线，都必须标注为“diagnostic / not final BE certificate”，直到 Lean 证明候选 `U_n` 的 unitary、clean block、误差和资源。"""
        input_status = """- 用户中文原文已保存到 `task-inbox/QBE-OP-CUBIC-STATEPREP-001/user_prompt.zh.md`。
- 输出语言可以用 `--report-language <lang>` 或 `QBE_REPORT_LANGUAGE=<lang>` 控制。
- 本地和未来 web 的共同入口应使用 `python3 tools/qbe.py ingest-user-problem ...`，让原始母语输入成为系统 artifact，而不是由人类在系统外预处理。"""
        comparison_status = """- 已安装并使用 Qiskit 环境；cubic 同目标 finite external comparison 已完成，见 `reports/cubic-stateprep/external_comparison.md` 和 `reports/cubic-stateprep/external_comparison_scaling.png`。
- NumPy dense completion 通过 `n = 1..6`，Qiskit `Operator` 通过 `n = 1..4`，Qiskit-QuantumKatas-style evaluator 通过 `n = 3`；这些都是 fixed small-n executable evidence。
- Qiskit export 已生成在 `executable-exports/QBE-OP-CUBIC-STATEPREP-001/qiskit/export.py`，但它只是 finite dense baseline，不是 final symbolic certificate。
- QASM-Eval、QUASAR、AI-Mandel 在本地 artifact 中没有 direct same-task BE constructor/verifier route；它们仍可作为 typed feedback / harness 设计对比。
- ABEIS 自己还没有 final cubic BE，因此不能说 cubic 最终构造已经优于外部系统；当前优势说法应限于目标：Lean 证明 symbolic family，避免大规模 dense statevector/unitary materialization。"""
        next_plan = """1. lower candidate architect 立刻给出第一个 concrete `U_n` 候选接口：register、projector、alpha、unitarity 证明形状、clean-block 证明形状、epsilon budget 和资源 tier。
2. lower Lean worker 并行关闭一个小 proof leaf：`CUBIC-NORM-001` 或直接 `CUBIC-ALPHA-001`，但不得把它当作阻止候选构造的串行闸门。
3. middle 把 active DAG 写成并行 frontier：`CUBIC-CAND-001`、`CUBIC-NORM-001/CUBIC-ALPHA-001`、`CUBIC-VER-CAND-001`。
4. verifier worker 一旦有具体 `U_n`，就运行有限 block-entry / Qiskit fixed-instance necessary-condition check；如果还没有 `U_n`，记录 `candidate_interface_gap`，不要重复 norm-only diagnostics。
5. reviewer 拒绝任何把未归一化向量当作 unitary output state 的候选，也拒绝没有 Lean theorem 的曲线点进入 certified population。"""
    else:
        verdict = """当前任务是 operator-first block-encoding construction，不是 GHL 论文复现。人类应首先检查：目标 operator、normalizer、clean projector、误差 tolerance、资源排序和 candidate population 是否清楚。"""
        curve_status = "- 尚未检测到该任务的专用 certified evolution curve；只有 Lean 命名 theorem 支持的 candidate 才能画成 achieved point。"
        input_status = "- 输出语言由 `--report-language <lang>` 或 `QBE_REPORT_LANGUAGE=<lang>` 控制；原始用户输入应通过 `task-inbox/` 或 `ingest-user-problem` 保留。"
        comparison_status = "- 外部 verifier 可作为 pre-Lean diagnostic 或 post-Lean executable export；不能替代 Lean theorem closure。"
        next_plan = "- upper 先刷新目标和资源 metric；middle 写 proof-DAG；lower 每次只关闭一个 active leaf。"
    return f"""# 中文循环总结：{task_id} cycle {cycle}

生成时间：`{now_stamp()}`

Run 目录：`{rel(run_dir)}`

任务标题：{title}

这个文件是每轮长跑/收敛循环的人类审计入口。它不替代 Lean 证明；它负责告诉人类和下一轮 agent：当前有没有真正的 block-encoding 证书、哪些只是诊断、哪些曲线不能画成最终结果。

## 本轮验收结论

{verdict}

## 母语输入与系统入口

{input_status}

## Exact / Approximate / 自适应阶段曲线状态

{curve_status}

## 外部系统公平对比状态

{comparison_status}

## 当前 Lean 编译/`sorry` 状态

{sorry_text}

## 当前动态 proof-DAG leaf

{dynamic_text}

## 当前未完成义务信号

{obligation_text}

## 最近 typed verifier feedback

{feedback_text}

## 下一轮 lower-agent 分工

{lower_task_text}

## 下一轮计划

{next_plan}

## 本轮 dialogue 末尾

```text
{dialogue_tail}
```

## 当前未提交文件

{changed_text}

## 人类检查建议

1. 如果某个图或 README 说 cubic 已经有 final exact/approx BE，要求它给出 Lean theorem 名、资源 theorem 名、`python3 tools/qbe.py check` 结果和 problem export。
2. 如果外部系统对比说“ABEIS 更好”，要求它说明是否已经同 prompt、同 tolerance、同 metric 跑完 end-to-end，而不是只做了 scaling forecast。
3. 如果 agent 直接把用户中文问题翻译成英文后才进系统，要求改为 `ingest-user-problem` 或 web ingestion 入口，让原始母语输入成为系统 artifact。
"""


def cycle_zh_summary_text(task_id: str, cycle: int, run_dir: Path) -> str:
    if not is_ghl_case_task(task_id):
        return operator_construction_summary_zh(task_id, cycle, run_dir)
    title, task_text = task_context(task_id)
    state = blueprint_status_state(task_id)
    memory = memory_snapshot_state(task_id, cycle, run_dir)
    source = ghl2025_source_main_tex(task_text)
    source_display = display_path(source) if source else "未检测到本地 GHL2025 main.tex；请检查 outer_papers/quantum/GHL2025/main.tex"
    sorry_lines = lean_sorry_lines(limit=30)
    changed_lines = git_changed_files()
    latest_dialogue = read_text(run_dir / "dialogue.md") if (run_dir / "dialogue.md").exists() else ""
    dialogue_tail = latest_dialogue[-1800:].strip() if latest_dialogue.strip() else "本轮 dialogue 还没有有效交接。"
    dynamic = state.get("dynamic_leaf_queue", [])
    obligations = state.get("open_obligation_signals", [])
    anchors = "\n".join(
        "| `{id}` | `{source}` | {paper} | {meaning} | {status} |".format(**row)
        for row in GHL2025_SOURCE_ANCHORS
    )
    sorry_text = "\n".join(f"- `{line}`" for line in sorry_lines) if sorry_lines else "- 当前没有检测到 `sorry`。"
    changed_text = "\n".join(f"- `{line}`" for line in changed_lines[:40]) if changed_lines else "- 当前工作区没有未提交变更。"
    dynamic_text = "\n".join(f"- {item}" for item in dynamic) if dynamic else "- blueprint 没有检测到动态 leaf；upper 需要刷新目标。"
    obligation_text = "\n".join(f"- {item}" for item in obligations[:20]) if obligations else "- 没有 compact obligation signals；请检查 `proof-obligations/` 原文。"
    open_ghl_text = markdown_table(
        memory.get("open_ghl_contribution_obligations", []),
        [
            ("ID", "id"),
            ("main.tex", "main_tex_anchor"),
            ("原文对象", "paper_object"),
            ("Lean/status", "lean_status"),
            ("依赖外部 lemma?", "depends_on_external_technical_lemma"),
        ],
        limit=10,
    )
    open_technical_text = markdown_table(
        memory.get("open_external_technical_lemma_obligations", []),
        [
            ("ID", "id"),
            ("source", "source"),
            ("status", "lean_status"),
            ("next action", "next_action"),
        ],
        limit=10,
    )
    feedback_text = markdown_table(
        memory.get("recent_verifier_feedback", []),
        [
            ("leaf", "leaf"),
            ("class", "error_class"),
            ("finite", "finite_matrix_ok"),
            ("entry", "block_entry_ok"),
            ("next", "next_route"),
        ],
        limit=6,
    )
    lower_task_text = markdown_table(
        memory.get("next_lower_tasks", []),
        [
            ("角色", "role"),
            ("目标", "goal"),
            ("产物", "must_write"),
        ],
    )
    focus_text = "\n".join(f"{idx}. {item}" for idx, item in enumerate(current_ghl2025_focus(), start=1))
    return f"""# 中文循环总结：{task_id} cycle {cycle}

生成时间：`{now_stamp()}`

Run 目录：`{rel(run_dir)}`

任务标题：{title}

本地原文 TeX：`{source_display}`

这个文件是每轮 6h/active-time 循环的人类审计入口。它的目的不是替代 Lean 证明，而是把 GHL 原文、Lean 状态、未复现义务、下一轮计划放在同一个中文页面里，方便人类上层 agent 给宏观指示。

## 本轮最重要判断

当前优先级仍然是忠实复现 GHL2025 的 one-term Robin block-encoding，也就是原文 `main.tex:1098-1164` 的 Theorem、Eq. ROBIN clarified、Fig. 1-term Robin circuit。不要在这个阶段把时间花到 1D Hamiltonian、multi-dimensional theorem、QSVT 文章写作 polish，除非它们是关闭 one-term theorem 的必要依赖。

## 给不熟悉 Lean 的读者看的解释

{plain_language_status_zh()}

## 哪些地方可以先用非 Lean verifier 加速

下面这些检查不是正式证明，也不能替代 Lean。它们的作用更像“先用计算器验算中间数”：如果快速检查失败，说明当前 Lean 目标、线路翻译或 index map 很可能写错，继续等 Lean 编译只会浪费时间；如果快速检查通过，只能说明没有发现反例，最后仍要 Lean 给出正式证明。

{prelean_verifier_table_zh()}

## GHL 原文对照表

| ID | 原文位置 | 原文对象 | 对人类的含义 | 当前 Lean/ABEIS 状态 |
|---|---:|---|---|---|
{anchors}

## 当前 Lean 编译/`sorry` 状态

{sorry_text}

## 当前动态 proof-DAG leaf

{dynamic_text}

## 当前未完成义务信号

{obligation_text}

## GHL 本文贡献未完成项

{open_ghl_text}

## 前人 technical lemma / standard primitive 未完成项

{open_technical_text}

## 最近 typed verifier feedback

{feedback_text}

## 下一轮 lower-agent 分工

{lower_task_text}

## 下一轮规划

{focus_text}

## 本轮 dialogue 末尾

```text
{dialogue_tail}
```

## 当前未提交文件

{changed_text}

## 人类检查建议

1. 先看 `FigRobin`、`GammaSlices`、`RobinTheorem` 三行，确认 agent 没有把 Fig. 4 的 gate 顺序改成自己的构造。
2. 再看 `ODBS`、`ODTS`、`Of`、`HW`、`RyBoundary`，确认这些是外部 primitive/contract 还是 GHL 本文自己需要证明的部分。
3. 如果下一轮还在攻击 raw `Coeff` constructor equality，应当让 reviewer 拒绝，因为主路线应是 `evalWith` semantic entry bridge。
4. 如果 agent 声称 GHL one-term theorem 完成，应要求它指出对应 `main.tex:1098-1164`、最终 Lean theorem 名称、`python3 tools/qbe.py check` 结果、以及 Markdown/LaTeX 证明导出位置。
"""


def normalize_report_language(language: str | None) -> str:
    value = (language or os.environ.get("QBE_REPORT_LANGUAGE") or "zh").strip()
    if not value:
        value = "zh"
    lowered = value.lower().replace("_", "-")
    aliases = {
        "chinese": "zh",
        "zh-cn": "zh",
        "zh-hans": "zh",
        "mandarin": "zh",
        "english": "en",
        "japanese": "ja",
        "korean": "ko",
    }
    return aliases.get(lowered, lowered)


def report_language_label(language: str | None) -> str:
    normalized = normalize_report_language(language)
    labels = {
        "zh": "Chinese",
        "en": "English",
        "ja": "Japanese",
        "ko": "Korean",
    }
    return labels.get(normalized, normalized)


def is_chinese_report_language(language: str | None) -> bool:
    return normalize_report_language(language).startswith("zh")


def summary_archive_dir(task_id: str) -> Path:
    """Return the public archive for human-facing closeout summaries."""
    safe_id = slugify(task_id)
    if safe_id == "QBE-AUTO-002":
        return ROOT / "paper-notes" / "GHL2025" / "markdown" / "cycle-summaries"
    return ROOT / "paper-notes" / safe_id / "markdown" / "cycle-summaries"


def cycle_summary_text(task_id: str, cycle: int, run_dir: Path, language: str | None = None) -> str:
    lang = normalize_report_language(language)
    if is_chinese_report_language(lang):
        return cycle_zh_summary_text(task_id, cycle, run_dir)
    title, _task_text = task_context(task_id)
    state = blueprint_status_state(task_id)
    memory = memory_snapshot_state(task_id, cycle, run_dir)
    sorry_lines = lean_sorry_lines(limit=30)
    changed_lines = git_changed_files()
    dynamic = state.get("dynamic_leaf_queue", [])
    obligations = state.get("open_obligation_signals", [])
    sorry_text = "\n".join(f"- `{line}`" for line in sorry_lines) if sorry_lines else "- No `sorry` lines detected."
    changed_text = "\n".join(f"- `{line}`" for line in changed_lines[:40]) if changed_lines else "- No uncommitted changes detected."
    dynamic_text = "\n".join(f"- {item}" for item in dynamic) if dynamic else "- No dynamic proof-DAG leaf detected; upper should refresh the target."
    obligation_text = "\n".join(f"- {item}" for item in obligations[:20]) if obligations else "- No compact obligation signals; inspect `proof-obligations/`."
    open_ghl_text = markdown_table(
        memory.get("open_ghl_contribution_obligations", []),
        [
            ("ID", "id"),
            ("source anchor", "main_tex_anchor"),
            ("paper object", "english_object"),
            ("Lean/status", "lean_status"),
            ("external lemma?", "depends_on_external_technical_lemma"),
        ],
        limit=10,
    )
    open_technical_text = markdown_table(
        memory.get("open_external_technical_lemma_obligations", []),
        [
            ("ID", "id"),
            ("source", "source"),
            ("status", "lean_status"),
            ("next action", "next_action"),
        ],
        limit=10,
    )
    feedback_text = markdown_table(
        memory.get("recent_verifier_feedback", []),
        [
            ("leaf", "leaf"),
            ("class", "error_class"),
            ("finite", "finite_matrix_ok"),
            ("entry", "block_entry_ok"),
            ("next", "next_route"),
        ],
        limit=6,
    )
    lower_task_text = markdown_table(
        memory.get("next_lower_tasks", []),
        [
            ("role", "role"),
            ("goal", "goal"),
            ("artifact", "must_write"),
        ],
    )
    language_note = (
        f"Preferred human report language: `{report_language_label(lang)}` (`{lang}`). "
        "Agents should translate future human-facing closeout prose into this language. "
        "This built-in fallback is English when no specialized translator agent has run."
    )
    return f"""# Cycle Summary: {task_id} cycle {cycle}

Generated: `{now_stamp()}`

Run directory: `{rel(run_dir)}`

Task title: {title}

{language_note}

This file is the long-run human audit entry point. It does not replace Lean.
It tells the next upper/middle agents what remains open, which feedback is
trusted only as a necessary-condition diagnostic, and what lower agents should
try next.

## Plain-Language Status

{task_plain_language_status_en(task_id)}

## Lean Build / Sorry Status

{sorry_text}

## Current Dynamic Proof-DAG Leaf

{dynamic_text}

## Current Open Obligation Signals

{obligation_text}

## Paper Contribution Obligations

{open_ghl_text}

## External Technical Lemma Obligations

{open_technical_text}

## Recent Typed Verifier Feedback

{feedback_text}

## Next Lower-Agent Tasks

{lower_task_text}

## Current Uncommitted Files

{changed_text}
"""


def write_cycle_summary(
    task_id: str,
    cycle: int,
    run_dir: Path,
    language: str | None = None,
) -> tuple[Path, Path]:
    lang = normalize_report_language(language)
    text = cycle_summary_text(task_id, cycle, run_dir, lang)
    if is_chinese_report_language(lang):
        run_path = run_dir / "zh_summary.md"
    else:
        run_path = run_dir / f"summary.{lang}.md"
    generic_path = run_dir / "summary.md"
    archive_dir = summary_archive_dir(task_id)
    archive_path = archive_dir / f"{run_dir.name}.{lang}.md"
    latest_path = archive_dir / f"latest.{lang}.md"
    write_text(run_path, text)
    write_text(generic_path, text)
    write_text(archive_path, text)
    write_text(latest_path, text)
    if is_chinese_report_language(lang):
        write_text(archive_dir / "latest.md", text)
    add_manifest("qbe.py cycle-summary", run_path, "review", f"Wrote {lang} cycle summary for {task_id} cycle {cycle}")
    add_manifest("qbe.py cycle-summary", archive_path, "paper-note", f"Archived {lang} cycle summary for {task_id} cycle {cycle}")
    return run_path, archive_path


def write_cycle_zh_summary(task_id: str, cycle: int, run_dir: Path) -> tuple[Path, Path]:
    return write_cycle_summary(task_id, cycle, run_dir, "zh")


OPTCTRL_MARKDOWN_ASSETS = {
    "abeis_loop": "abeis_loop.png",
    "oracle": "optctrl_oracle_baseline.png",
    "depth5": "optctrl_depth5.png",
    "pro": "optctrl_pro.png",
    "evolved": "optctrl_evolved.png",
    "evolution": "optctrl_evolution.png",
    "storyboard": "optctrl_storyboard.png",
    "adaptive_policy": "adaptive_be_policy.png",
}


def sync_optctrl_markdown_assets() -> dict[str, Path]:
    """Copy current report PNGs into the main repo for README/run summaries."""
    assets_dir = ROOT / "docs" / "assets"
    assets_dir.mkdir(parents=True, exist_ok=True)
    synced: dict[str, Path] = {}
    for key, filename in OPTCTRL_MARKDOWN_ASSETS.items():
        target = assets_dir / filename
        source = PROJECT_ARTICLE_ROOT / "figures" / filename
        if source.exists():
            target.write_bytes(source.read_bytes())
        synced[key] = target
    return synced


def markdown_link_from(base_dir: Path, target: Path) -> str:
    return os.path.relpath(target, start=base_dir).replace(os.sep, "/")


def optctrl_convergence_summary_text(language: str, run_dir: Path) -> str:
    assets = sync_optctrl_markdown_assets()
    img = {key: markdown_link_from(run_dir, path) for key, path in assets.items()}
    if is_chinese_report_language(language):
        return f"""# QBE-OP-OPTCTRL-001 多 agent 收敛运行总结

生成日期：{now_stamp()}

这是正式的收敛运行总结。当前聊天框作为人类交互顶层模块；upper、
middle、lower、reviewer 的角色化交接记录在 `dialogue.md`。本文件是
默认中文人类入口；英文版同步写在 `summary.en.md`。

## 目标算子

```text
E_1 = |0><1|_time ⊗ |0><1|_type ⊗ I_state
```

目标不是只说明 oracle 存在，而是给出一个具体 unitary/circuit，使它的
clean block 正好等于上面的 `E_1`，并且 Lean 证明这个说法。

## 收敛图

下图只画已经通过 Lean 证书的候选。蓝色区域是精确 BE 搜索；绿色区域是
精确冠军收敛后的近似 BE 阶段。Python 搜索、模拟器输出、ChatGPT Pro
建议在通过 Lean 之前只属于 insight pool，不会被画成已完成结果。

![E_1 block-encoding certified evolution]({img["evolution"]})

## 精确到近似的策略

![Adaptive exact-to-approximate BE policy]({img["adaptive_policy"]})

本主案例属于 Scenario 1：第 7 代已经得到 exact BE，并且
`OptimalControl.evolvedEqFlipZeroErrorApprox` 把它包装为 `epsilon = 0` 的
approximate BE。后续近似阶段可以继续搜索更少门的近似构造，但目前没有
更便宜的候选被 Lean 证书提升到 certified population。

## 各代 Lean-verified block encoding 线路图

这些图使用量子线路社区通用的 wire/control 记号；只展示已经有 Lean
证书的 block-encoding 候选。

### Generation 0：oracle-level seed

![Oracle-level seed]({img["oracle"]})

- Lean 证书：`OptimalControl.exampleVerified`
- 资源 tuple：`(gateCount, depth, auxiliaryQubits, oracleCalls) = (1, 1, 1, 1)`
- 解释：这是正确的一辅助量子比特 block-encoding seed，但包含一个未展开的
  permutation-completion oracle，因此只作为 correctness baseline。

### Generation 2：depth-5 logical completion

![Depth-5 logical completion]({img["depth5"]})

- Lean 证书：`OptimalControl.reducedDepth5Verified`
- 关键 Lean 锚点：`reducedDepth5Unitary_isRationalOrthogonal`,
  `reducedDepth5Unitary_cleanBlock`, `reducedDepth5GateImages_eval`
- 资源 tuple：`(6, 5, 1, 0)`
- 解释：这是第一个完全展开到逻辑 `{{X,CNOT,Toffoli}}` 门库的正确构造。

### Generation 6：ChatGPT Pro equality-transfer candidate

![Equality-transfer candidate]({img["pro"]})

- Lean 证书：`OptimalControl.proEqTransferVerified`
- 关键 Lean 锚点：`proEqTransferUnitary_isRationalOrthogonal`,
  `proEqTransferUnitary_cleanBlock`, `proEqTransferGateImages_eval`
- 资源 tuple：`(4, 4, 1, 0)`
- 解释：Pro 的建议先进入 insight pool；Lean 证明通过后才升级为 certified
  population。它给出了“先标记选中 branch，再移动到 clean block”的结构。

### Generation 7：evolved equality-flag + parallel flips champion

![Evolved champion]({img["evolved"]})

- Lean 证书：`OptimalControl.evolvedEqFlipVerified`
- 关键 Lean 锚点：`evolvedEqFlipUnitary_isRationalOrthogonal`,
  `evolvedEqFlipUnitary_cleanBlock`, `evolvedEqFlipGateImages_eval`,
  `evolvedEqFlipCandidate_cost`
- 资源 tuple：`(4, 2, 1, 0)`
- 线路：

```text
CCX(type,time -> auxiliary)
then parallel X_type, X_time, X_auxiliary
```

这是当前 concrete logical `{{X,CNOT,Toffoli}}` tier 的冠军构造。

## 为什么判断收敛

lower necessary-condition verifier 对 reduced 三比特 `{{X,CNOT,Toffoli}}` 全
方向逻辑门库做了精确枚举：

- 3 个门以内没有任何正确 clean-block 构造；
- 4 个门有正确构造；
- 4 个门以内没有 depth 1 的分层构造；
- depth 2 的 witness 正好是当前 Lean 已验证冠军。

因此，在具体 `r = 1, k = 1` 逻辑门库层面，继续 mutation/crossover 追求
更少门或更浅深度已经没有必要。这个 finite verifier 是收敛证据，不是
Lean 形式化的 lower-bound theorem。

## 边界

这不是硬件门分解最优性结论，不是任意 `k` 或任意 time-register 宽度的
通用 theorem，也不是 Lean 形式化 lower-bound theorem。下一步应该是：

1. 把有限枚举 lower bound 形式化进 Lean，如果论文需要 theorem；
2. 把 `r = 1, k = 1` 推广到更宽 time register；
3. 加硬件门分解 backend 并重新评分；
4. 把 operator-to-certificate 流程接到用户网页和母语报告接口。
"""
    return f"""# QBE-OP-OPTCTRL-001 Multi-Agent Convergence Run Summary

Generated: {now_stamp()}

This is the formal convergence-run summary.  The live chat acted as the human
interaction top module; role-separated upper, middle, lower, and reviewer
handoffs are recorded in `dialogue.md`.  The default Chinese human entry is
`zh_summary.md`.

## Target Operator

```text
E_1 = |0><1|_time ⊗ |0><1|_type ⊗ I_state
```

The task is not to assume an oracle exists.  The task is to construct a
specific unitary/circuit whose clean block is exactly `E_1`, and to have Lean
verify that statement.

## Convergence Plot

Only Lean-certified candidates are plotted as achieved constructions.  The
blue region is exact-BE search; the green region is the approximate-BE phase
after exact convergence.  Python searches, simulator traces, and ChatGPT Pro
ideas stay in the insight pool until Lean promotes them.

![E_1 block-encoding certified evolution]({img["evolution"]})

## Exact-To-Approximate Policy

![Adaptive exact-to-approximate BE policy]({img["adaptive_policy"]})

This main case is Scenario 1: generation 7 already gives an exact BE, and
`OptimalControl.evolvedEqFlipZeroErrorApprox` packages it as an `epsilon = 0`
approximate BE.  The approximate phase may continue searching for a cheaper
approximate construction, but no cheaper candidate is currently promoted by
Lean certificates.

## Lean-Verified Block-Encoding Circuits By Generation

These diagrams use the community-standard wire/control notation for quantum
circuits.  Only candidates with Lean certificates are shown as achieved
block-encoding constructions.

### Generation 0: oracle-level seed

![Oracle-level seed]({img["oracle"]})

- Lean certificate: `OptimalControl.exampleVerified`
- Resource tuple: `(gateCount, depth, auxiliaryQubits, oracleCalls) = (1, 1, 1, 1)`
- Meaning: a correct one-ancilla seed, still containing one opaque
  permutation-completion oracle.

### Generation 2: depth-5 logical completion

![Depth-5 logical completion]({img["depth5"]})

- Lean certificate: `OptimalControl.reducedDepth5Verified`
- Lean anchors: `reducedDepth5Unitary_isRationalOrthogonal`,
  `reducedDepth5Unitary_cleanBlock`, `reducedDepth5GateImages_eval`
- Resource tuple: `(6, 5, 1, 0)`
- Meaning: the first correct construction fully expanded in the logical
  `{{X,CNOT,Toffoli}}` gate library.

### Generation 6: ChatGPT Pro equality-transfer candidate

![Equality-transfer candidate]({img["pro"]})

- Lean certificate: `OptimalControl.proEqTransferVerified`
- Lean anchors: `proEqTransferUnitary_isRationalOrthogonal`,
  `proEqTransferUnitary_cleanBlock`, `proEqTransferGateImages_eval`
- Resource tuple: `(4, 4, 1, 0)`
- Meaning: the Pro idea became a certified parent only after Lean proved it.
  It exposed the branch-selection invariant.

### Generation 7: evolved equality-flag plus parallel-flips champion

![Evolved champion]({img["evolved"]})

- Lean certificate: `OptimalControl.evolvedEqFlipVerified`
- Lean anchors: `evolvedEqFlipUnitary_isRationalOrthogonal`,
  `evolvedEqFlipUnitary_cleanBlock`, `evolvedEqFlipGateImages_eval`,
  `evolvedEqFlipCandidate_cost`
- Resource tuple: `(4, 2, 1, 0)`
- Circuit:

```text
CCX(type,time -> auxiliary)
then parallel X_type, X_time, X_auxiliary
```

This is the current champion at the concrete logical `{{X,CNOT,Toffoli}}` tier.

## Why This Run Converged

The lower necessary-condition verifier exhaustively enumerated the reduced
three-bit logical `{{X,CNOT,Toffoli}}` orientation library:

- no correct clean-block candidate exists with at most 3 gates;
- correct 4-gate candidates exist;
- no depth-1 layered candidate exists with at most 4 gates;
- the depth-2 witness is exactly the current Lean-certified champion.

This is convergence evidence for the concrete `r = 1, k = 1` logical library.
It is not a Lean-formalized lower-bound theorem.

## Scope

This is not a hardware-optimality theorem, not a theorem for arbitrary `k` or
arbitrary time-register width, and not a Lean-formalized lower-bound theorem.
The next tasks are generalization, hardware decomposition, and optional Lean
formalization of the finite lower-bound search.
"""


def write_optctrl_convergence_summaries(run_dir: Path) -> tuple[Path, Path, Path]:
    zh = optctrl_convergence_summary_text("zh", run_dir)
    en = optctrl_convergence_summary_text("en", run_dir)
    zh_path = run_dir / "zh_summary.md"
    summary_zh_path = run_dir / "summary.zh.md"
    en_path = run_dir / "summary.en.md"
    generic_path = run_dir / "summary.md"
    write_text(zh_path, zh)
    write_text(summary_zh_path, zh)
    write_text(en_path, en)
    write_text(generic_path, zh)
    add_manifest("qbe.py optctrl-convergence-summary", zh_path, "review", "Wrote Chinese convergence summary with certified circuit figures")
    add_manifest("qbe.py optctrl-convergence-summary", en_path, "review", "Wrote English convergence summary with certified circuit figures")
    return zh_path, en_path, generic_path


def latest_proof_attempts(task_id: str, limit: int = 8) -> list[str]:
    attempts_dir = ROOT / "proof-attempts" / slugify(task_id)
    if not attempts_dir.exists():
        return []
    files = sorted(
        [path for path in attempts_dir.glob("*.md") if path.is_file()],
        key=lambda path: path.stat().st_mtime,
        reverse=True,
    )
    return [rel(path) for path in files[:limit]]


def status_is_open(status: str) -> bool:
    lowered = status.lower()
    closed_markers = ["formalized", "closed", "complete", "完成", "闭合"]
    open_markers = [
        "backlog",
        "contract",
        "obligation",
        "planned",
        "active",
        "not final",
        "unformalized",
        "未",
        "还",
        "仍",
        "义务",
        "依赖",
        "planned",
    ]
    if any(marker in lowered or marker in status for marker in open_markers):
        return True
    if any(marker in lowered or marker in status for marker in closed_markers):
        return False
    return True


def ghl_anchor_metadata(anchor_id: str) -> dict[str, object]:
    own_contributions = {
        "Uindic",
        "RyBoundary",
        "RobinTheorem",
        "GammaSlices",
        "FigRobin",
        "OneD",
        "MultiD",
    }
    external_dependencies = {
        "ODBS",
        "ODTS",
        "Of",
        "HW",
        "QSVT",
        "BlockEncodingDef",
        "FigRobin",
        "RobinTheorem",
        "GammaSlices",
        "RyBoundary",
    }
    lean_decls = {
        "ODBS": "bandedSparseAccessPaperMatrix / oracle contract helpers",
        "ODTS": "sparse-amplitude oracle contract helpers",
        "Of": "coefficient-amplitude oracle contract helpers",
        "HW": "HUniform / prepared sparse-register contract",
        "Uindic": "indicator permutation and dagger slot helpers",
        "RyBoundary": "boundary rotation coefficient/evalWith lemmas",
        "RobinTheorem": "oneTermRobin... theorem-facing statements",
        "GammaSlices": "oneTermRobinGamma3... entry/product lemmas",
        "FigRobin": "oneTermRobinGamma3... transcript/fold guards",
        "OneD": "planned LCU/Hamiltonian statements",
        "MultiD": "planned multidimensional statements",
        "QSVT": "external QSVT simulation theorem application",
        "BlockEncodingDef": "BlockEncoding semantic predicate",
    }
    english_objects = {
        "ODBS": "Banded-sparse-access oracle",
        "ODTS": "Sparse-amplitude oracle for a banded-sparse matrix",
        "Of": "Amplitude oracle for a piecewise-polynomial coefficient",
        "HW": "Uniform sparse-register preparation",
        "Uindic": "Indicator unitary",
        "RyBoundary": "Boundary-controlled Ry rotations",
        "RobinTheorem": "One-term Robin block-encoding theorem",
        "GammaSlices": "Gamma wavefunction slices and coefficient product",
        "FigRobin": "Figure 4 Robin circuit transcript",
        "OneD": "One-dimensional Hamiltonian block encoding",
        "MultiD": "Multidimensional block encoding",
        "QSVT": "Hamiltonian simulation/QSVT application",
        "BlockEncodingDef": "Clean-block block-encoding definition",
    }
    english_statuses = {
        "ODBS": "External contract/backlog: reversible extension, injectivity, dagger cleanup, and unitarity remain obligations.",
        "ODTS": "External contract/backlog: normalizer, square-root/arccos semantics, and two-by-two unitarity remain obligations.",
        "Of": "External contract/backlog: clean branch is typed; bounds, orthogonality, cleanup, and unitary completion remain obligations.",
        "HW": "The theorem-facing route uses a clean-column contract; full gate-level state-preparation remains external/backlog.",
        "Uindic": "Permutation and self-inverse helpers compile, but this is not yet the final block-encoding proof.",
        "RyBoundary": "The fixed-N8 standard-Ry correction is compiled; the printed single-arccos formula is retained only as a source typo.",
        "RobinTheorem": "Main active target: the theorem-facing Lean statement is not closed.",
        "GammaSlices": "Several finite boundary lemmas exist; the final projection/product bridge is still open.",
        "FigRobin": "Transcript guard compiles for visible indicator dagger and H preparation; the active seven-gate backend remains a component.",
        "OneD": "Deferred until the one-term Robin theorem closes.",
        "MultiD": "Planned; depends on one-term and LCU abstractions.",
        "QSVT": "External theorem application; not part of the current gate-level Robin circuit closure.",
        "BlockEncodingDef": "Used as the semantic target; the final circuit entry/projection bridge remains open.",
    }
    return {
        "is_ghl_contribution": anchor_id in own_contributions,
        "depends_on_external_technical_lemma": anchor_id in external_dependencies,
        "lean_decl": lean_decls.get(anchor_id, ""),
        "english_object": english_objects.get(anchor_id, anchor_id),
        "english_status": english_statuses.get(anchor_id, ""),
    }


def ghl_contribution_rows() -> list[dict[str, object]]:
    rows: list[dict[str, object]] = []
    for anchor in GHL2025_SOURCE_ANCHORS:
        meta = ghl_anchor_metadata(str(anchor["id"]))
        status = str(anchor["status"])
        rows.append(
            {
                "id": anchor["id"],
                "main_tex_anchor": anchor["source"],
                "paper_object": anchor["paper"],
                "english_object": meta["english_object"],
                "meaning": anchor["meaning"],
                "lean_decl": meta["lean_decl"],
                "lean_status": status,
                "english_status": meta["english_status"],
                "is_ghl_contribution": meta["is_ghl_contribution"],
                "depends_on_external_technical_lemma": meta[
                    "depends_on_external_technical_lemma"
                ],
                "open": status_is_open(status),
            }
        )
    return rows


def technical_lemma_rows() -> list[dict[str, object]]:
    return [
        {
            "id": "tl-ghl-lemma2-prior-lemma1-banded-sparse-access",
            "source": "GHL2025 arXiv:2506.20478 Lemma 2; arXiv:2405.12855 Lemma 1",
            "statement": "Banded-sparse-access oracle maps sparse slot and row index to the corresponding column index, with a reversible/unitary completion and dagger cleanup.",
            "lean_decl": "bandedSparseAccessPaperMatrix / ODBS contract helpers",
            "lean_status": "contract-only",
            "used_by": ["GHL2025 Fig. 4", "Robin boundary ODBS dagger cleanup"],
            "dependencies": ["sparse slot injectivity", "reversible extension", "finite matrix unitarity"],
            "next_action": "Reuse the compiled fixed-N8 primitive; keep only the arbitrary-n resource theorem as an explicit external contract.",
            "tags": ["GHL2025", "oracle", "sparse-access", "external-primitive"],
        },
        {
            "id": "tl-ghl-lemma3-sparse-amplitude",
            "source": "GHL2025 main.tex:822-843",
            "statement": "Sparse-amplitude oracle prepares clean-branch amplitudes D_j^(s)/N_D plus an orthogonal complement branch.",
            "lean_decl": "ODTS sparse-amplitude contract helpers",
            "lean_status": "contract-only",
            "used_by": ["GHL2025 gamma_1/gamma_2/gamma_3 slices"],
            "dependencies": ["nonzero normalizer", "sqrt/arccos semantics", "2x2 unitarity"],
            "next_action": "Maintain the clean-branch contract and isolate any missing unitarity proof as an external technical lemma.",
            "tags": ["GHL2025", "amplitude-oracle", "normalizer"],
        },
        {
            "id": "tl-ghl-theorem5-piecewise-polynomial-of",
            "source": "GHL2025 main.tex:870-908",
            "statement": "Coefficient oracle O_f prepares clean-branch amplitude f(x_j)/N_f for the piecewise-polynomial coefficient function.",
            "lean_decl": "coefficient-amplitude oracle contract helpers",
            "lean_status": "contract-only",
            "used_by": ["GHL2025 one-term Robin operator A_k = f(x) partial_x^m"],
            "dependencies": ["piecewise-polynomial evaluator", "N_f bound", "workspace orthogonality"],
            "next_action": "Use only as a named contract in the current theorem; do not invent stronger smoothness or range assumptions.",
            "tags": ["GHL2025", "coefficient-oracle", "piecewise-polynomial"],
        },
        {
            "id": "tl-uniform-sparse-register-preparation",
            "source": "GHL2025 main.tex:948-955; Shukla--Vedula 2024",
            "statement": "H_W^(kappa) prepares the uniform sparse-register superposition kappa^(-1/2) sum_s |s>.",
            "lean_decl": "HUniform / prepared sparse-register contract",
            "lean_status": "contract-only",
            "used_by": ["GHL2025 Fig. 4 left/right sparse-register preparation"],
            "dependencies": ["finite register size", "uniform-column normalization", "dagger cleanup"],
            "next_action": "Keep as a theorem-facing contract unless the exact state-preparation proof is needed to close a resource theorem.",
            "tags": ["state-preparation", "Hadamard", "external-primitive"],
        },
        {
            "id": "tl-ry-boundary-amplitude-convention",
            "source": "GHL2025 main.tex:1077-1085",
            "statement": "Boundary rotations must implement the paper's desired amplitude D_j^(s)/N_D under the correct R_y convention.",
            "lean_decl": "boundary rotation coefficient/evalWith lemmas",
            "lean_status": "obligation",
            "used_by": ["GHL2025 boundary-entry branch", "active gamma_3 coefficient leaf"],
            "dependencies": ["R_y convention audit", "cos(theta/2) versus cos(theta)", "source-supported angle translation"],
            "next_action": "Do not silently change the paper angle; prove the convention bridge or record the exact cited convention.",
            "tags": ["GHL2025", "Ry", "source-audit", "boundary"],
        },
        {
            "id": "tl-qsvt-blockencoding-simulation",
            "source": "GHL2025 main.tex:1676-1694; Gilyen et al. 2019",
            "statement": "A closed block encoding can be used as input to QSVT/Hamiltonian simulation complexity theorems.",
            "lean_decl": "planned external QSVT theorem application",
            "lean_status": "paper-cited",
            "used_by": ["GHL2025 Hamiltonian simulation section"],
            "dependencies": ["closed one-term/LCU block encodings", "QSVT theorem import or contract"],
            "next_action": "Defer until the one-term Robin theorem and LCU combination are closed.",
            "tags": ["QSVT", "simulation", "external-theorem"],
        },
        {
            "id": "tl-clean-block-definition",
            "source": "GHL2025 main.tex:2027-2035",
            "statement": "Block encoding is defined by a clean-ancilla projection whose top-left block approximates A/alpha.",
            "lean_decl": "BlockEncoding semantic predicate",
            "lean_status": "contract-only",
            "used_by": ["all theorem-facing block-encoding statements"],
            "dependencies": ["projector index convention", "normalizer alpha", "approximation epsilon"],
            "next_action": "Use as the final target predicate; ensure circuit entry lemmas are bridged to this semantic definition.",
            "tags": ["block-encoding", "definition", "clean-ancilla"],
        },
    ]


def recent_verifier_feedback(task_id: str, limit: int = 8) -> list[dict[str, object]]:
    records = [record for record in load_recent_jsonl(TRIAL_LOG) if record.get("task_id") == task_id]
    feedback_rows: list[dict[str, object]] = []
    stale_leaf_prefixes = ("slot3_", "slot4_", "slot5_", "slot6_")
    for record in reversed(records):
        feedback = record.get("verifier_feedback")
        if not isinstance(feedback, dict) or not feedback:
            continue
        leaf = str(feedback.get("leaf", ""))
        next_route = str(feedback.get("next_route", ""))
        if leaf.startswith(stale_leaf_prefixes):
            continue
        if "attempt slot6" in next_route or "slot-5 evaluated" in next_route:
            continue
        feedback_rows.append(
            {
                "timestamp": record.get("timestamp", ""),
                "trial_id": record.get("trial_id", ""),
                "role": record.get("role", ""),
                "status": record.get("status", ""),
                "leaf": leaf,
                "error_class": feedback.get("error_class", ""),
                "finite_matrix_ok": feedback.get("finite_matrix_ok", ""),
                "block_entry_ok": feedback.get("block_entry_ok", ""),
                "lean_parse_ok": feedback.get("lean_parse_ok", ""),
                "lean_build_ok": feedback.get("lean_build_ok", ""),
                "closed_theorem_ok": feedback.get("closed_theorem_ok", ""),
                "next_route": next_route,
                "leaf_signature": feedback.get("leaf_signature", ""),
                "evidence_digest": feedback.get("evidence_digest", ""),
                "capacity_decision": feedback.get("capacity_decision", ""),
                "tolerance_decision": feedback.get("tolerance_decision", ""),
                "search_decision": feedback.get("search_decision", ""),
                "epsilon_next": feedback.get("epsilon_next", ""),
                "requested_epsilon": feedback.get("requested_epsilon", ""),
                "candidate_id": feedback.get("candidate_id", ""),
                "candidate_family": feedback.get("candidate_family", ""),
                "population_action": feedback.get("population_action", ""),
                "parent_ids": feedback.get("parent_ids", ""),
                "fitness_evidence": feedback.get("fitness_evidence", ""),
                "selection_reason": feedback.get("selection_reason", ""),
            }
        )
        if len(feedback_rows) >= limit * 5:
            break
    if feedback_rows:
        return reduce_latest_feedback(feedback_rows)[:limit]
    task_feedback_dir = VERIFIER_FEEDBACK_DIR / task_id
    if task_feedback_dir.exists():
        feedback_files = sorted(task_feedback_dir.glob("*.md"), key=lambda p: p.stat().st_mtime, reverse=True)
    else:
        feedback_files = sorted(VERIFIER_FEEDBACK_DIR.glob(f"{task_id}*.md"), key=lambda p: p.stat().st_mtime, reverse=True)
    if not feedback_files and is_ghl_case_task(task_id):
        feedback_files = sorted(VERIFIER_FEEDBACK_DIR.glob("*.md"), key=lambda p: p.stat().st_mtime, reverse=True)
    for path in feedback_files[:limit]:
        feedback_rows.append(
            {
                "timestamp": _dt.datetime.fromtimestamp(path.stat().st_mtime).strftime("%Y-%m-%d %H:%M:%S"),
                "trial_id": rel(path),
                "role": "reviewer",
                "status": "packet",
                "leaf": path.stem,
                "error_class": "manual-packet",
                "finite_matrix_ok": "",
                "block_entry_ok": "",
                "closed_theorem_ok": "",
                "next_route": compact_markdown_lines(path, [r"next_route", r"Next route", r"route"], limit=2),
            }
        )
    return feedback_rows


def recent_trial_rows(task_id: str, limit: int = 8) -> list[dict[str, object]]:
    records = [record for record in load_recent_jsonl(TRIAL_LOG) if record.get("task_id") == task_id]
    rows = []
    for record in reversed(records[-limit:]):
        rows.append(
            {
                "timestamp": record.get("timestamp", ""),
                "trial_id": record.get("trial_id", ""),
                "role": record.get("role", ""),
                "kind": record.get("kind", ""),
                "status": record.get("status", ""),
                "lean_gate": record.get("lean_gate", ""),
                "artifact": record.get("artifact", ""),
            }
        )
    return rows


def task_contract_capsule(
    task_id: str,
    task_text: str,
    controller_state: dict[str, object],
    memory_cards: list[dict[str, object]],
    feedback_rows: list[dict[str, object]],
) -> dict[str, object]:
    """Build deterministic proof state that prose compaction cannot override."""

    target = extract_preferred_section(
        task_text,
        [r"^## Lean-Checkable Target.*?$", r"^## Target.*?$", r"^## Raw User Problem.*?$"],
    )
    if len(target) > 5000:
        target = target[:2500] + "\n...[contract compacted]...\n" + target[-2500:]

    def matching_lines(pattern: str, limit: int = 8) -> list[str]:
        return [
            line.strip()
            for line in task_text.splitlines()
            if re.search(pattern, line, flags=re.I)
        ][:limit]

    alpha_values = re.findall(r"\balpha\s*=\s*`?([^`\s,.;]+)", task_text, flags=re.I)
    compiled_anchors = sorted(
        {
            str(anchor)
            for card in memory_cards
            for anchor in card.get("compiled_lean_anchors", [])
            if isinstance(card.get("compiled_lean_anchors", []), list)
        }
    )
    failed_fingerprints = sorted(
        {
            semantic_route_fingerprint(
                {"task_id": task_id, "verifier_feedback": feedback}
            )
            for feedback in feedback_rows
            if feedback.get("error_class")
        }
        - {""}
    )
    route_record = {
        "task_id": task_id,
        "leaf_signature": controller_state.get("leaf_signature"),
        "evidence_digest": controller_state.get("evidence_digest"),
        "ready_leaf_ids": controller_state.get("ready_leaf_ids"),
        "search_phase": controller_state.get("search_phase"),
        "effective_epsilon": controller_state.get("effective_epsilon"),
    }
    superseded = re.search(
        r"^Superseded by:\s*`?([^`\n]+)`?",
        task_text,
        flags=re.M | re.I,
    )
    return {
        "schema_version": 1,
        "task_id": task_id,
        "task_kind": infer_task_kind(task_text),
        "contract_text": target.strip(),
        "contract_digest": content_digest([target.strip()]),
        "dimensions": matching_lines(r"\b(?:dimension|dimensions|N\s*=|2\^n|qubits?)\b"),
        "register_order": matching_lines(r"register order|register layout|low-order|high-order"),
        "ancilla_convention": matching_lines(r"ancilla|clean block|projector", limit=10),
        "normalization_alpha": alpha_values[:4],
        "search_phase": controller_state.get("search_phase", "exact"),
        "effective_epsilon": controller_state.get("effective_epsilon", "0"),
        "epsilon_ladder": list(infer_epsilon_ladder(task_text)),
        "compiled_lean_declarations": compiled_anchors,
        "ready_leaf_ids": controller_state.get("ready_leaf_ids", []),
        "certified_root_anchors": controller_state.get("certified_root_anchors", []),
        "executable_acceptance": {
            "required": controller_state.get("executable_acceptance_required", False),
            "complete": controller_state.get("executable_acceptance_complete", False),
            "command": controller_state.get("executable_acceptance_command", ""),
            "artifacts": controller_state.get("executable_acceptance_artifacts", []),
            "backend": controller_state.get("executable_check_backend", "none"),
            "evidence_classes": controller_state.get("executable_evidence_classes", []),
        },
        "active_route_fingerprint": semantic_route_fingerprint(route_record),
        "failed_route_fingerprints": failed_fingerprints,
        "superseded_by": superseded.group(1).strip() if superseded else "",
    }


def memory_snapshot_state(task_id: str, cycle: int, run_dir: Path) -> dict[str, object]:
    title, task_text = task_context(task_id)
    blueprint = blueprint_status_state(task_id)
    evaluation_mode = infer_evaluation_mode(task_text)
    library_assistance = evaluation_mode in {"lad", "full-abeis"}
    adaptive_memory = evaluation_mode == "full-abeis"
    if is_ghl_case_task(task_id) and library_assistance:
        ghl_rows = ghl_contribution_rows()
        technical_rows = technical_lemma_rows()
    else:
        ghl_rows = []
        technical_rows = []
    open_ghl = [
        row for row in ghl_rows
        if row.get("open") and row.get("is_ghl_contribution")
    ]
    open_technical = [row for row in technical_rows if row.get("lean_status") != "formalized"]
    source = ghl2025_source_main_tex(task_text)
    controller_state = load_control_state(control_state_path(task_id))
    memory_cards = reusable_memory_card_rows(task_text) if library_assistance else []
    feedback_rows = recent_verifier_feedback(task_id, limit=10) if adaptive_memory else []
    lower_tasks = [
        {
            "role": "lower-1-natural-language-proof-architect",
            "goal": "Translate the active source-paper proof step into a dependency DAG with exact source anchors and external-lemma calls.",
            "must_write": "proof-attempts/<task>/...-natural-language-dag.md",
        },
        {
            "role": "lower-2-lean-implementation-worker",
            "goal": "Close one active Lean leaf only, preferably the smallest entry/evalWith bridge selected by the blueprint.",
            "must_write": "Lean declaration plus trial-log verifier-feedback fields",
        },
        {
            "role": "lower-3-necessary-condition-verifier",
            "goal": "Check exact finite matrix/path/support conditions that must hold before the active Lean leaf can be true.",
            "must_write": "verifier-feedback/<task>/... plus trial-log feedback fields",
        },
    ]
    if not controller_state.get("ready_leaf_ids"):
        lower_tasks = []
    elif evaluation_mode in {"task-only", "lad"}:
        lower_tasks = [
            row
            for row in lower_tasks
            if row["role"] == "lower-2-lean-implementation-worker"
        ]
    return {
        "task_id": task_id,
        "title": title,
        "cycle": cycle,
        "generated": now_stamp(),
        "run_dir": rel(run_dir),
        "source_main_tex": display_path(source) if source else "",
        "mode": blueprint.get("mode", ""),
        "evaluation_mode": evaluation_mode,
        "stage": blueprint.get("stage", ""),
        "card_memory_protocol": {
            "idea_cards": "route inspiration only; mutate/recombine and reject when hypotheses do not fit",
            "compiled_lean_leaves": "reusable proof tools; instantiate or adapt instead of reproving",
            "contract_only_cards": "explicit proof-DAG boundaries; not Lean-closed evidence",
        },
        "dynamic_leaf_queue": blueprint.get("dynamic_leaf_queue", []),
        "open_obligation_signals": blueprint.get("open_obligation_signals", []),
        "lean_sorries": lean_sorry_lines(limit=40),
        "ghl_contributions": ghl_rows,
        "open_ghl_contribution_obligations": open_ghl,
        "technical_lemmas": technical_rows,
        "state_capsule": task_contract_capsule(
            task_id, task_text, controller_state, memory_cards, feedback_rows
        ),
        "reusable_memory_cards": memory_cards,
        "open_external_technical_lemma_obligations": open_technical,
        "recent_verifier_feedback": feedback_rows,
        "recent_trials": recent_trial_rows(task_id, limit=10) if adaptive_memory else [],
        "recent_proof_attempts": (
            latest_proof_attempts(task_id, limit=10) if adaptive_memory else []
        ),
        "controller_state": controller_state if adaptive_memory else {},
        "next_lower_tasks": lower_tasks,
    }


def markdown_table(rows: list[dict[str, object]], columns: list[tuple[str, str]], limit: int | None = None) -> str:
    selected = rows[:limit] if limit is not None else rows
    if not selected:
        return "_None._"
    header = "| " + " | ".join(title for title, _ in columns) + " |"
    sep = "| " + " | ".join("---" for _ in columns) + " |"
    body = []
    for row in selected:
        cells = []
        for _, key in columns:
            value = row.get(key, "")
            if isinstance(value, list):
                value = "; ".join(str(item) for item in value)
            cells.append(str(value).replace("\n", " ").replace("|", "\\|"))
        body.append("| " + " | ".join(cells) + " |")
    return "\n".join([header, sep, *body])


def prose_value(value: object) -> str:
    if isinstance(value, list):
        return "; ".join(str(item) for item in value)
    return str(value)


def plain_language_status_zh() -> str:
    return """现在 GHL 复现不是卡在“论文没有证明”，而是卡在把论文图里的线路翻译成 Lean 后，必须证明某些具体矩阵条目真的等于论文写的系数。普通理解是：论文说这串量子门最后会在 clean branch 里留下目标系数；Lean 要求我们把这串门看成一个大矩阵，然后精确证明对应的行列条目等于那个系数。

目前最重要的未闭合点是 one-term Robin 的 Fig. 4 / gamma_3 部分：需要证明 active clean branch 的 entry 等于 $f(x_i)D_i^{(s)}/(N_D N_f \\kappa)$，并证明其它不该留下贡献的 branch 确实为零或相互抵消。前人 oracle、state-preparation、QSVT 这些可以先保持为明确 contract，不应该混进“GHL 自己贡献已经证明完”的说法里。"""


def prelean_verifier_rows_zh() -> list[dict[str, object]]:
    return [
        {
            "part": "active `[0,0]` entry",
            "plain": "把 Fig. 4 中当前关注的几道门乘成一个有限矩阵，检查 clean branch 那个格子的数是不是论文需要的系数。",
            "quick_check": "exact rational matrix/path-sum evaluator",
            "if_fail": "Lean 不可能证明当前这个等式；应先修正 gate order、index map 或目标 statement。",
            "if_pass": "只说明目标没有被有限矩阵反例否定；最后仍要 Lean 证明一般化/形式化等式。",
        },
        {
            "part": "slots `3..6` vanish/cancel",
            "plain": "检查那些按论文应该不会进入 clean branch 的路径，最后是不是确实给 0。",
            "quick_check": "support/path checker for each slot",
            "if_fail": "说明某条不该存在的路径还活着；Lean proof 会卡住，先找错路由。",
            "if_pass": "说明这些 branch 有希望用 Lean 化简为 0，但还不是正式证明。",
        },
        {
            "part": "$R_y$ angle convention",
            "plain": "确认论文写的角度放进我们采用的 $R_y$ 矩阵后，振幅到底是 $D/N_D$ 还是 $\\cos(\\theta/2)$ 之类的半角。",
            "quick_check": "2x2 symbolic matrix check",
            "if_fail": "说明 angle convention 没对齐；不能靠 Lean tactic 硬证错误公式。",
            "if_pass": "说明 convention 至少一致；还要 Lean 写出具体 bridge lemma。",
        },
        {
            "part": "sparse-access map",
            "plain": "检查 oracle 把 `(slot,row)` 映到 column 的规则有没有冲突、有没有跑出范围。",
            "quick_check": "finite injectivity/range/permutation checker",
            "if_fail": "reversible/unitary oracle 无法成立；需要重读论文或补 domain 条件。",
            "if_pass": "说明可逆扩展没有显然有限反例；Lean 仍要证明 injectivity/cleanup。",
        },
        {
            "part": "$O_f$ clean branch",
            "plain": "检查 coefficient oracle 在 clean branch 上给出的数是不是 $f(x_i)/N_f$。",
            "quick_check": "exact evaluator for finite sample/function table",
            "if_fail": "block-entry 系数会错，GHL 主 theorem 不可能闭合。",
            "if_pass": "说明 coefficient route 数值方向正确；Lean 仍要证明 normalizer、orthogonality、cleanup。",
        },
    ]


def prelean_verifier_table_zh() -> str:
    return markdown_table(
        prelean_verifier_rows_zh(),
        [
            ("卡点", "part"),
            ("普通解释", "plain"),
            ("可先做的快速检查", "quick_check"),
            ("如果快速检查失败", "if_fail"),
            ("如果快速检查通过", "if_pass"),
        ],
    )


def plain_language_status_en() -> str:
    return (
        "The current GHL case study is not blocked because the paper lacks a "
        "proof sketch.  It is blocked because ABEIS must turn the circuit in "
        "the paper into an exact matrix statement and prove that the clean "
        "block entry has the coefficient claimed by the paper.  In ordinary "
        "terms, the paper says that a specific path through the circuit leaves "
        "the desired coefficient, while Lean requires the corresponding matrix "
        "entry and all unwanted branches to be proved exactly."
    )


def is_ghl_case_task(task_id: str) -> bool:
    _title, task_text = task_context(task_id)
    explicit = re.search(
        r"(?im)^\s*Paper report template\s*:\s*`?GHL2025`?\s*$",
        task_text,
    )
    return bool(explicit) or task_id in {"QBE-AUTO-001", "QBE-AUTO-002"}


def is_main_case_task(task_id: str) -> bool:
    title, task_text = task_context(task_id)
    haystack = f"{task_id}\n{title}\n{task_text}".lower()
    return (
        task_id == "QBE-OP-OPTCTRL-001"
        or "main-case" in haystack
        or "main case" in haystack
        or "transfer-operator" in haystack
        or "transfer operator" in haystack
    )


def task_plain_language_status_en(task_id: str) -> str:
    if is_main_case_task(task_id):
        return (
            "This cycle is an exploratory block-encoding construction task.  "
            "The target is the concrete transfer operator "
            "E_1 = |0><1|_T tensor |0><1|_tau tensor I_S.  The current report "
            "should state only the Lean-certified candidate package, its clean "
            "signal, alpha, epsilon, passive-register claim, resource score, "
            "and any blocked export or optimality obligations."
        )
    if is_ghl_case_task(task_id):
        return plain_language_status_en()
    title, _ = task_context(task_id)
    return (
        f"This cycle tracks the current construction status for {title}.  "
        "The generated appendix should state only the latest Lean-supported "
        "claim and open obligations for this task."
    )


def manuscript_rule_latex(task_id: str) -> str:
    if is_main_case_task(task_id):
        return (
            "The project report may discuss this cycle as process evidence and "
            "as a concrete logical reversible permutation-matrix block "
            "encoding.  It must not claim a generalized optimal-control "
            "theorem, arbitrary-register construction, hardware-gate "
            "optimality, or Lean-proved lower bound until the corresponding "
            "Lean declarations and resource model are closed."
        )
    if is_ghl_case_task(task_id):
        return (
            "The project report may discuss this cycle as paper-benchmark process evidence.  It must not\n"
            "claim completion of the GHL2025 paper-benchmark track \\citep{guseynovHuangLiu2025} unless\n"
            "the final theorem-facing block-extraction statement is closed in Lean and the\n"
            "natural-language proof map and closeout LaTeX export have been synchronized."
        )
    return (
        "The project report may discuss this cycle as process evidence.  It must not "
        "claim a completed theorem or globally optimal construction unless the "
        "corresponding Lean declaration and resource certificate are named."
    )


def article_delta_markdown(task_id: str) -> str:
    common = [
        "- Keep the main system claim: ABEIS is an auto-proof harness for turning quantum oracle assumptions into Lean-checked block-encoding/circuit certificates.",
    ]
    if is_main_case_task(task_id):
        common.extend(
            [
                "- Update the generated appendix with the current main-case construction status: concrete logical reversible permutation-matrix certificate, its comparison tuple, and the remaining export, generalization, hardware-decomposition, or lower-bound obligations.",
                "- Do not replay the full population history in Overleaf; keep history in `candidate-populations/` and verifier-feedback packets.",
                "- State the semantic tier precisely: concrete `r=1,k=1` logical permutation-matrix block encoding, not a hardware-decomposed or general-family theorem unless the named Lean declarations close those tiers.",
                "- State the certified-population rule: only candidates with named Lean certificates can be evolutionary parents or plotted solution points; Pro/Python/simulator ideas stay in the insight pool until Lean promotes them.",
            ]
        )
    elif is_ghl_case_task(task_id):
        common.extend(
            [
                "- Keep the paper-benchmark track honest: Guseynov--Huang--Liu 2025 is secondary benchmark data, not the main technical-report case study; final completion depends on the current Lean gate and `sorry` status below.",
                "- If this cycle only changes proof-route memory or obstruction analysis, update the report's evidence/appendix status, not the headline contribution.",
                "- If this 6h/convergence closeout closes a named Lean theorem, middle should export the theorem to the problem-specific LaTeX proof note before strengthening the project-paper claim.",
            ]
        )
    else:
        common.extend(
            [
                "- Update the generated appendix with only the current task champion, Lean-supported claims, and open obligations.",
                "- Keep detailed history in task ledgers and run artifacts, not the Overleaf appendix.",
            ]
        )
    return "\n".join(common)


def suggested_project_paper_edits_markdown(task_id: str) -> str:
    if is_main_case_task(task_id):
        return """| Report location | Safe update |
|---|---|
| `main/evidence.tex` | Mention the concrete explore-mode improvement only as process evidence and name the Lean declarations supporting it. |
| `main/lean_platform.tex` | Note that candidate populations can optimize over non-unique unitary completions, with Lean checking clean-block equality. |
| `appendix/generated_cycle_status.tex` | This file is overwritten automatically and should show only the latest current construction status. |
| Figures/tables | Reuse the PNG only as a certified concrete logical BE curve; label it clearly as not hardware-decomposed and not generalized.  Never plot insight-pool proposals as achieved points. |"""
    if is_ghl_case_task(task_id):
        return """| Report location | Safe update |
|---|---|
| `main/evidence.tex` | Add only stable harness lessons from this cycle, with no stronger claim than the Lean gate supports. |
| `main/ghl_case_study.tex` | Update the case-study status if a theorem, source-contract correction, or obstruction was accepted by reviewer. |
| `appendix/generated_cycle_status.tex` | This file is overwritten automatically and can be included as the latest machine-generated status appendix. |
| Figures/tables | Add or revise a figure only if the cycle changed the system design, proof-DAG frontier, or article-facing evidence. |"""
    return """| Report location | Safe update |
|---|---|
| `main/evidence.tex` | Add only stable, Lean-supported lessons from this cycle. |
| `appendix/generated_cycle_status.tex` | This file is overwritten automatically and should show only the latest status. |"""


def do_not_claim_markdown(task_id: str) -> str:
    if is_main_case_task(task_id):
        return """- Do not claim a generalized optimal-control theorem while the construction is only proved for the concrete `r=1,k=1` finite instance.
- Do not claim hardware-gate optimality before choosing and proving a hardware decomposition/resource model.
- Do not treat finite verifier scores or population-search convergence as mathematical optimality theorems.
- Do not use unverified Pro/Python/simulator proposals as evolutionary parents; they are insight-pool records until Lean certificates promote them."""
    if is_ghl_case_task(task_id):
        return """- Do not say the Guseynov--Huang--Liu one-term theorem is complete while any
  theorem-facing `sorry` or root block-extraction obligation remains.
- Do not present a cited oracle/state-preparation/LCU/QSVT primitive as proved
  unless a build-tested Lean declaration is named.
- Do not turn proof-search scores, agent self-assessments, or natural-language
  proof sketches into accepted mathematical claims."""
    return """- Do not claim the task theorem is complete without naming the closing Lean declaration.
- Do not turn proof-search scores or natural-language sketches into accepted mathematical claims."""


def contribution_obligation_heading(task_id: str) -> str:
    return "Open paper-benchmark obligations" if is_ghl_case_task(task_id) else "Open current-task contribution obligations"


def cited_contract_heading(task_id: str) -> str:
    return "Open cited-contract obligations" if is_ghl_case_task(task_id) else "Open current-task cited-contract obligations"


def prelean_verifier_rows_en(task_id: str | None = None) -> list[dict[str, object]]:
    if task_id == "QBE-OP-CUBIC-STATEPREP-001":
        return [
            {
                "part": "target normalization",
                "quick_check": "exact rational norm rows for sum_j (j/2^n)^6",
                "why_necessary": "if the requested vector is not normalized, a unitary state-preparation interpretation is the wrong target",
                "lean_still_needed": "Lean must prove the symbolic norm/normalizer bridge before any U_n candidate can be certified",
            },
            {
                "part": "rank-one support",
                "quick_check": "finite support check for O_n = |v_n><0^n|",
                "why_necessary": "a candidate for a different column support would encode a different operator",
                "lean_still_needed": "Lean must state and prove the clean-block equality against the rank-one operator",
            },
            {
                "part": "dense verifier scaling",
                "quick_check": "statevector/unitary memory forecast for n = 4, 8, 12, 16, 20",
                "why_necessary": "it tells upper agents when dense executable verification stops being a useful inner-loop check",
                "lean_still_needed": "Lean must prove a symbolic family; dense rows are fixed-instance executable checks, not certificates",
            },
            {
                "part": "candidate block entry",
                "quick_check": "small-n Qiskit or exact matrix check after a concrete U_n, alpha, projector, and ancilla layout exist",
                "why_necessary": "a failing finite block-entry check disproves the proposed candidate route",
                "lean_still_needed": "Lean must prove unitarity, clean block, approximation error, and resource score for the advertised family",
            },
            {
                "part": "epsilon budget",
                "quick_check": "arithmetic, rotation, and transduction error ledger summing to 1e-10 or an explicit relaxed tolerance",
                "why_necessary": "without a numerical budget, Scenario 2 approximate search has no acceptance target",
                "lean_still_needed": "Lean must connect the budget to the operator-norm block-encoding definition",
            },
        ]
    if task_id is not None and is_main_case_task(task_id):
        return [
            {
                "part": "target support and passive register",
                "quick_check": "exact table check: clean block has support only at (0,6),(1,7) and preserves S",
                "why_necessary": "if any other clean-block entry survives, the candidate encodes a different operator",
                "lean_still_needed": "Lean proves the clean-block equality against E_1, not just a finite printout",
            },
            {
                "part": "unitarity/permutation",
                "quick_check": "basis-action bijection/permutation check for the full signal-system map",
                "why_necessary": "the candidate U_A must be a unitary completion, not just a linear map with the right block",
                "lean_still_needed": "Lean proves rational orthogonality of the candidate matrix",
            },
            {
                "part": "resource tuple",
                "quick_check": "gate/depth/auxiliary/oracle count under the fixed project metric",
                "why_necessary": "population ranking is invalid if candidate costs are not computed under the same metric",
                "lean_still_needed": "Lean names the candidate cost theorem; finite search is only a convergence diagnostic",
            },
            {
                "part": "candidate package fields",
                "quick_check": "Lean parser/build check that the candidate record fields point to the compiled target, circuit, layout, resource, unitarity proposition, and block proposition",
                "why_necessary": "a field mismatch can make a true low-level block theorem unusable as a verified operator certificate",
                "lean_still_needed": "Lean must compile `mainCaseColdPartialPermCandidate` and `mainCaseColdPartialPermVerified`",
            },
            {
                "part": "post-Lean executable export",
                "quick_check": "Qiskit/OpenQASM finite check after the Lean candidate package compiles",
                "why_necessary": "users need runnable code to reproduce the concrete circuit, but only after the theorem target is fixed",
                "lean_still_needed": "nothing from Qiskit replaces the Lean theorem; it is an export check and figure source",
            },
        ]
    return [
        {
            "part": "active [0,0] entry",
            "quick_check": "exact rational matrix or path-sum evaluation",
            "why_necessary": "if the exact finite entry is not the target coefficient, the Lean equality for that entry cannot be true",
            "lean_still_needed": "a passing check is only a counterexample filter; Lean must still prove the named entry lemma",
        },
        {
            "part": "remaining branch vanish/cancel",
            "quick_check": "support and path checker for the remaining backend slots",
            "why_necessary": "if an unwanted clean-branch path survives numerically, the block projection cannot match the paper target",
            "lean_still_needed": "Lean must still prove the zero/cancellation lemma in the formal circuit semantics",
        },
        {
            "part": "Ry boundary convention",
            "quick_check": "symbolic 2-by-2 rotation check",
            "why_necessary": "a mismatched half-angle convention changes the boundary amplitude before any Lean tactic is relevant",
            "lean_still_needed": "Lean must still record the convention bridge as a source-supported theorem",
        },
        {
            "part": "sparse-access map",
            "quick_check": "finite range/injectivity/permutation check",
            "why_necessary": "a reversible oracle cannot exist for a colliding or out-of-range finite map",
            "lean_still_needed": "Lean must still prove the reversible extension and cleanup obligations",
        },
        {
            "part": "coefficient oracle clean branch",
            "quick_check": "exact finite evaluator for f(x_i)/N_f",
            "why_necessary": "the final block entry uses this coefficient, so a wrong clean branch invalidates the target theorem",
            "lean_still_needed": "Lean must still prove bounds, orthogonality, and unitary completion or keep them as contracts",
        },
    ]


def prelean_verifier_table_en(task_id: str | None = None) -> str:
    return markdown_table(
        prelean_verifier_rows_en(task_id),
        [
            ("proof part", "part"),
            ("fast check", "quick_check"),
            ("why this is a necessary condition", "why_necessary"),
            ("what Lean still proves", "lean_still_needed"),
        ],
    )


def memory_digest_markdown(snapshot: dict[str, object]) -> str:
    task_id = str(snapshot.get("task_id", ""))
    sorries = snapshot.get("lean_sorries", [])
    sorries_text = "\n".join(f"- `{line}`" for line in sorries) if sorries else "- No `sorry` detected."
    dynamic = snapshot.get("dynamic_leaf_queue", [])
    dynamic_text = "\n".join(f"- {item}" for item in dynamic) if dynamic else "- No dynamic proof-DAG leaf detected."
    feedback_rows = snapshot.get("recent_verifier_feedback", [])
    feedback_text = markdown_table(
        feedback_rows if isinstance(feedback_rows, list) else [],
        [
            ("time", "timestamp"),
            ("leaf", "leaf"),
            ("class", "error_class"),
            ("finite", "finite_matrix_ok"),
            ("entry", "block_entry_ok"),
            ("next", "next_route"),
        ],
        limit=8,
    )
    capsule = snapshot.get("state_capsule", {})
    capsule_text = json.dumps(capsule, indent=2, sort_keys=True, ensure_ascii=False)
    return f"""# Memory Digest: {snapshot.get('task_id')} cycle {snapshot.get('cycle')}

Generated: `{snapshot.get('generated')}`

Run directory: `{snapshot.get('run_dir')}`

Task title: {snapshot.get('title')}

This is the compact retrieval packet for the next upper/middle cycle.  It keeps
the long log, paper-source map, typed verifier feedback, and Lean `sorry` scan
separate from the next lower-agent task package.

## Deterministic state capsule

This JSON is authoritative for contract, route, tolerance, certificate, and
executable state.  Agent-written prose may explain it but may not replace it.

```json
{capsule_text}
```

## Plain-language status

{task_plain_language_status_en(task_id)}

{card_memory_protocol_markdown(task_id)}

## Pre-Lean verifier candidates

These checks are necessary-condition filters, not proofs.  A failure is useful
because it usually means the current target, index map, or circuit transcript
is wrong.  A pass only says that the target survived this exact finite check;
Lean must still close the theorem or keep the dependency as an explicit
contract.

{prelean_verifier_table_en(task_id)}

## Lean theorem closure signal

{sorries_text}

## Active proof-DAG leaves

{dynamic_text}

## {contribution_obligation_heading(task_id)}

{markdown_table(snapshot.get('open_ghl_contribution_obligations', []), [
    ('id', 'id'),
    ('main.tex anchor', 'main_tex_anchor'),
    ('paper object', 'paper_object'),
    ('Lean/status', 'lean_status'),
    ('external lemma?', 'depends_on_external_technical_lemma'),
])}

## {cited_contract_heading(task_id)}

{markdown_table(snapshot.get('open_external_technical_lemma_obligations', []), [
    ('id', 'id'),
    ('source', 'source'),
    ('status', 'lean_status'),
    ('used by', 'used_by'),
    ('next action', 'next_action'),
])}

## Recent typed verifier feedback

{feedback_text}

## Next lower-agent task split

{markdown_table(snapshot.get('next_lower_tasks', []), [
    ('role', 'role'),
    ('goal', 'goal'),
    ('artifact', 'must_write'),
])}
"""


def card_memory_protocol_markdown(task_id: str) -> str:
    export_note = ""
    if task_id == "QBE-MAIN-CASE-HIER-COLD-001":
        export_note = (
            "\n- Current COLD main-case note: the block-encoding construction is "
            "already Lean-certified by `mainCaseColdPartialPermVerified`.  "
            "Executable-export cycles should reuse that compiled leaf and must "
            "not reopen sparse, LCU, QSVT, dilation, approximate, or Pro-assisted "
            "construction routes unless upper/reviewer explicitly changes the task."
        )
    return f"""## Card-memory protocol

- Textbook block-encoding cards are route inspiration, not fixed recipes.  Upper
  and middle agents should use them to propose, mutate, or recombine several
  plausible proof routes, then reject cards whose hypotheses do not fit the
  target.
- Compiled Lean leaves are reusable proof tools.  If a named theorem already
  closes the needed leaf, instantiate or adapt it locally instead of reproving
  the same proof.
- Contract-only cards are explicit proof-DAG boundaries.  They can guide the
  plan, but they are not Lean-closed evidence and must stay visible in the
  dependency graph.
{export_note}
"""


def todo_markdown(snapshot: dict[str, object]) -> str:
    task_id = str(snapshot.get("task_id", ""))
    dynamic = snapshot.get("dynamic_leaf_queue", [])
    open_contrib = snapshot.get("open_ghl_contribution_obligations", [])
    open_external = snapshot.get("open_external_technical_lemma_obligations", [])
    sorries = snapshot.get("lean_sorries", [])
    if not dynamic and not open_contrib and not open_external and not sorries:
        return f"""# Next Todo Packet: {snapshot.get('task_id')} cycle {snapshot.get('cycle')}

Generated: `{snapshot.get('generated')}`

{card_memory_protocol_markdown(task_id)}

## Closeout State

No active proof-DAG leaf, open contribution obligation, open cited-contract
obligation, or Lean `sorry` was detected for this task snapshot.

## Next Action

1. Do not dispatch lower proof search for this exact snapshot.
2. If the task continues, upper/reviewer must first declare a new semantic tier,
   export target, optimization target, or approximate-search target.
3. Reuse compiled Lean leaves from the card-memory protocol; do not reopen a
   construction route merely because a textbook card exists.
"""
    if task_id == "QBE-OP-OPTCTRL-001":
        lower1_first_step = "Read the current construction status and candidate population row for the active optimal-control block-encoding witness."
    elif is_ghl_case_task(task_id):
        lower1_first_step = "Read the first open GHL contribution row below."
    else:
        lower1_first_step = "Read the first open current-task contribution row below."
    return f"""# Next Todo Packet: {snapshot.get('task_id')} cycle {snapshot.get('cycle')}

Generated: `{snapshot.get('generated')}`

{card_memory_protocol_markdown(task_id)}

## Lower 1: Natural-language proof architect

1. {lower1_first_step}
2. Write the exact source-proof translation: source anchor, local theorem goal,
   dependency DAG, external technical lemmas, and route rejected by verifier.
3. Do not change Lean code.

## Lower 2: Lean implementation worker

1. Pick one active proof-DAG leaf from the retrieval index.
2. Prove the smallest build-testable declaration; do not refactor the paper
   construction or change assumptions.
3. Log typed verifier feedback with `trial-log --feedback-field`.

## Lower 3: Necessary-condition verifier

1. Do not try to close the theorem by broad Lean search.
2. Run or design a finite matrix/path/support check that must pass if the
   active Lean leaf is true.
3. Record typed verifier feedback: `finite_matrix_ok`, `block_entry_ok`,
   `source_correspondence_ok`, `error_class`, and `next_route`.
4. If the diagnostic fails, ask middle to repair the target before lower 2
   spends another large proof attempt.

## {contribution_obligation_heading(task_id)}

{markdown_table(snapshot.get('open_ghl_contribution_obligations', []), [
    ('id', 'id'),
    ('main.tex anchor', 'main_tex_anchor'),
    ('paper object', 'paper_object'),
    ('Lean/status', 'lean_status'),
], limit=8)}

## {cited_contract_heading(task_id)}

{markdown_table(snapshot.get('open_external_technical_lemma_obligations', []), [
    ('id', 'id'),
    ('status', 'lean_status'),
    ('next action', 'next_action'),
], limit=8)}
"""


def ghl_contribution_index_markdown(rows: list[dict[str, object]]) -> str:
    return """# GHL2025 Paper Contribution Index

Generated by `python3 tools/qbe.py memory-refresh`.

""" + markdown_table(
        rows,
        [
            ("id", "id"),
            ("main.tex anchor", "main_tex_anchor"),
            ("paper object", "paper_object"),
            ("Lean declaration/status", "lean_status"),
            ("GHL contribution?", "is_ghl_contribution"),
            ("external technical lemma?", "depends_on_external_technical_lemma"),
        ],
    ) + "\n"


def ghl_contribution_todo_markdown(rows: list[dict[str, object]]) -> str:
    open_rows = [
        row for row in rows
        if row.get("open") and row.get("is_ghl_contribution")
    ]
    return """# GHL2025 Open Contribution Todo

Rows here are GHL2025 source-paper objects whose Lean reproduction is not yet
closed.  They should not be mixed with external technical lemma todo items.

""" + markdown_table(
        open_rows,
        [
            ("id", "id"),
            ("main.tex anchor", "main_tex_anchor"),
            ("paper object", "paper_object"),
            ("Lean/status", "lean_status"),
            ("depends on external?", "depends_on_external_technical_lemma"),
        ],
    ) + "\n"


def technical_lemma_index_markdown(rows: list[dict[str, object]]) -> str:
    return """# Technical Lemma Index

Generated by `python3 tools/qbe.py memory-refresh`.

""" + markdown_table(
        rows,
        [
            ("id", "id"),
            ("source", "source"),
            ("statement", "statement"),
            ("Lean declaration", "lean_decl"),
            ("status", "lean_status"),
            ("used by", "used_by"),
            ("next action", "next_action"),
            ("tags", "tags"),
        ],
    ) + "\n"


def technical_lemma_todo_markdown(rows: list[dict[str, object]]) -> str:
    open_rows = [row for row in rows if row.get("lean_status") != "formalized"]
    return """# Open External Technical Lemma Todo

These are not GHL2025's new contributions.  They are cited primitives,
standard facts, or reusable technical lemmas that current and future ABEIS
tasks may need.

""" + markdown_table(
        open_rows,
        [
            ("id", "id"),
            ("source", "source"),
            ("status", "lean_status"),
            ("used by", "used_by"),
            ("next action", "next_action"),
        ],
    ) + "\n"


def write_memory_refresh(task_id: str, cycle: int, run_dir: Path) -> tuple[Path, Path, Path]:
    snapshot = memory_snapshot_state(task_id, cycle, run_dir)
    digest_path = run_dir / "memory_digest.md"
    todo_path = run_dir / "todo.md"
    index_path = RETRIEVAL_INDEX_DIR / f"{slugify(task_id)}.json"
    write_text(digest_path, memory_digest_markdown(snapshot))
    write_text(todo_path, todo_markdown(snapshot))
    write_text(index_path, json.dumps(snapshot, indent=2, sort_keys=True, ensure_ascii=False) + "\n")
    ghl_rows = snapshot.get("ghl_contributions", [])
    technical_rows = snapshot.get("technical_lemmas", [])
    if is_ghl_case_task(task_id) and isinstance(ghl_rows, list):
        write_text(GHL_CONTRIBUTION_DIR / "index.md", ghl_contribution_index_markdown(ghl_rows))
        write_text(GHL_CONTRIBUTION_DIR / "source-map.md", ghl_contribution_index_markdown(ghl_rows))
        write_text(GHL_CONTRIBUTION_DIR / "todo.md", ghl_contribution_todo_markdown(ghl_rows))
    if is_ghl_case_task(task_id) and isinstance(technical_rows, list):
        write_text(TECHNICAL_LEMMA_DIR / "index.md", technical_lemma_index_markdown(technical_rows))
        write_text(TECHNICAL_LEMMA_DIR / "todo.md", technical_lemma_todo_markdown(technical_rows))
    add_manifest("qbe.py memory-refresh", digest_path, "memory", f"Wrote memory digest for {task_id} cycle {cycle}")
    add_manifest("qbe.py memory-refresh", index_path, "memory", f"Wrote retrieval index for {task_id}")
    return digest_path, todo_path, index_path


def cubic_stateprep_pro_prompt_text(task_id: str, cycle: int, run_dir: Path, snapshot: dict) -> str:
    changed = git_changed_files()
    def tail_file(path: Path, limit: int) -> str:
        return path.read_text(encoding="utf-8")[-limit:] if path.exists() else "not yet available"
    task_text = tail_file(ROOT / "tasks" / f"{slugify(task_id)}.md", 5000)
    candidates = tail_file(ROOT / "candidate-populations" / f"{slugify(task_id)}.md", 6000)
    obligations = tail_file(ROOT / "proof-obligations" / f"{slugify(task_id)}.md", 5000)
    sorries = "\n".join(f"- `{line}`" for line in snapshot.get("lean_sorries", []))
    dirty = "\n".join(f"- `{path}`" for path in changed[:50])
    return f"""# ChatGPT Pro Prompt: ABEIS cubic state-preparation hard case, cycle {cycle}

You cannot access my local files. Use only this self-contained prompt and public quantum-computing knowledge.

## Target

For positive integer `n`, `N = 2^n`, `x_j = j/N`, and `f(x)=x^3`. ABEIS formalizes the user request as the unnormalized rank-one operator

```text
O_n = |v_n><0^n|,    v_n[j] = (j / 2^n)^3.
```

Requested tolerance: `epsilon = 1e-10`. First try exact block encodings; if exact search stalls, use Scenario 2 approximate BE. Rank candidates within one asymptotic/backend tier by `(gateCount, depth, auxiliaryQubits, oracleCalls)`.

## Current task packet

```markdown
{task_text}
```

## Candidate population

```markdown
{candidates}
```

## Proof obligations

```markdown
{obligations}
```

## Lean sorry scan

{sorries or "- No `sorry` was recorded by the snapshot."}

## Request

Give a concrete construction/proof plan suitable for Lean formalization: propose BE families, split the best route into a proof DAG, mark Qiskit/NumPy necessary-condition checks, suggest mutation/crossover actions, give pseudo-Lean statement shapes, and if exact BE is unrealistic give the Scenario 2 error budget for `epsilon = 1e-10`.

## Dirty files

{dirty or "- No dirty files were listed."}
"""


def operator_construction_pro_prompt_text(task_id: str, cycle: int, run_dir: Path, snapshot: dict) -> str:
    """Self-contained Pro prompt for operator-first construction tasks."""
    changed = git_changed_files()

    def tail_file(path: Path, limit: int) -> str:
        return path.read_text(encoding="utf-8")[-limit:] if path.exists() else "not yet available"

    task_text = tail_file(ROOT / "tasks" / f"{slugify(task_id)}.md", 6000)
    candidates = tail_file(ROOT / "candidate-populations" / f"{slugify(task_id)}.md", 7000)
    obligations = tail_file(ROOT / "proof-obligations" / f"{slugify(task_id)}.md", 7000)
    proof_blueprint = tail_file(ROOT / "proof-blueprints" / f"{slugify(task_id)}.md", 5000)
    verifier_rows = markdown_table(snapshot.get("recent_verifier_feedback", []), [
        ("leaf", "leaf"),
        ("error class", "error_class"),
        ("finite matrix ok", "finite_matrix_ok"),
        ("block entry ok", "block_entry_ok"),
        ("next route", "next_route"),
    ], limit=12)
    sorries = "\n".join(f"- `{line}`" for line in snapshot.get("lean_sorries", []))
    dirty = "\n".join(f"- `{path}`" for path in changed[:50])
    active = "\n".join(f"- {item}" for item in snapshot.get("dynamic_leaf_queue", []) if item)
    signals = "\n".join(f"- {item}" for item in snapshot.get("open_obligation_signals", []) if item)
    return f"""# ChatGPT Pro Prompt: ABEIS operator-construction task `{task_id}`, cycle {cycle}

You cannot access my local files. Use only this self-contained prompt and public quantum-computing knowledge.

## ABEIS target mode

This is an operator-first block-encoding construction task, not a paper-reproduction task.
Do not cite or use the Guseynov--Huang--Liu Robin-boundary paper unless I explicitly ask for that paper benchmark.

The goal is:

1. Read the operator/oracle requirement from the task packet below.
2. Propose or repair a block-encoding unitary family `U_A`.
3. Rank candidates only after they have a clear semantic route to Lean certification.
4. Use finite Python/Qiskit checks only as diagnostics or post-Lean executable exports; they do not replace the Lean theorem.
5. Use the resource order configured by ABEIS: first compare asymptotic/resource tier, then within a tier prefer fewer gates, then lower depth, then fewer auxiliary qubits, then fewer oracle calls.

## Current task packet

```markdown
{task_text}
```

## Current proof blueprint

```markdown
{proof_blueprint}
```

## Candidate population / rejected routes

```markdown
{candidates}
```

## Proof obligations

```markdown
{obligations}
```

## Active proof-DAG leaves

{active or "- No active proof-DAG leaves were recorded in the compact snapshot."}

## Open obligation signals

{signals or "- No compact obligation signals were recorded in the compact snapshot."}

## Recent typed verifier feedback

{verifier_rows}

## Lean sorry scan

{sorries or "- No `sorry` was recorded by the snapshot."}

## What I need from you

Return a concrete, Lean-facing proof-engineering plan.

1. State the best next candidate route and explain why it should remain in the candidate population.
2. Split the route into a small proof DAG: target contract, unitarity, clean-block equality, approximation/error if any, and resource theorem.
3. Pick exactly one smallest next Lean leaf and give a precise pseudo-Lean theorem statement shape.
4. Identify which finite checks are necessary-condition filters and which are only post-Lean executable exports.
5. If exact certification is blocked, propose the approximate block-encoding route and an epsilon budget, but do not call it certified until the Lean theorem is named.
6. Identify stale/rejected routes that should not consume another lower-agent attempt.

## Current dirty files, for context only

{dirty or "- No dirty files were listed."}
"""


def chatgpt_pro_prompt_text(task_id: str, cycle: int, run_dir: Path) -> str:
    snapshot = memory_snapshot_state(task_id, cycle, run_dir)
    if task_id == "QBE-OP-CUBIC-STATEPREP-001":
        return cubic_stateprep_pro_prompt_text(task_id, cycle, run_dir, snapshot)
    if not is_ghl_case_task(task_id):
        return operator_construction_pro_prompt_text(task_id, cycle, run_dir, snapshot)
    title = str(snapshot.get("title", task_id))
    dynamic = snapshot.get("dynamic_leaf_queue", [])
    obligations = snapshot.get("open_obligation_signals", [])
    changed = git_changed_files()
    return f"""# ChatGPT Pro Prompt: ABEIS {task_id} cycle {cycle}

Copy everything below this line into ChatGPT Pro.

---

You are helping with ABEIS, an Auto-Block-Encoding-In-Sleep Lean 4 project for
quantum oracle and block-encoding circuit formalization.  You cannot access my
local files.  Please use only the public links below and the self-contained
status copied into this prompt.  Local Lean names and file paths are labels to
help me patch my repository later; do not assume you can open them.

## Public sources you may use

- Guseynov--Huang--Liu, "Quantum framework for simulating linear PDEs with
  Robin boundary conditions": https://arxiv.org/abs/2506.20478
- PDF: https://arxiv.org/pdf/2506.20478
- The relevant source-paper region is the one-term Robin block-encoding circuit
  around the paper's Fig. 4 and the theorem/equations corresponding to the
  Robin boundary construction.  In my local source map this is tracked as
  `main.tex:1098-1164`, but you should cite the public paper by theorem,
  equation, figure, and page/section rather than relying on local line numbers.

## Current ABEIS task

Task: `{task_id}`

Title: {title}

Run label: `{run_dir.name}`

Cycle: `{cycle}`

ABEIS is in paper-benchmark mode.  Do not add assumptions, change the
oracle contract, change the gate order, or replace the paper's construction by
a different construction.  If the paper relies on a previous theorem or a
standard quantum primitive, classify it as an external technical lemma rather
than silently proving a stronger or different statement.

## What remains open according to the current retrieval index

### Active proof-DAG leaves

{chr(10).join(f"- {item}" for item in dynamic if item) or "- No active proof-DAG leaf was recorded."}

### Open obligation signals

{chr(10).join(f"- {item}" for item in obligations if item) or "- No compact obligation signal was recorded."}

### Open GHL paper-contribution obligations

{markdown_table(snapshot.get('open_ghl_contribution_obligations', []), [
    ('id', 'id'),
    ('paper anchor', 'main_tex_anchor'),
    ('paper object', 'paper_object'),
    ('Lean/status', 'lean_status'),
    ('external lemma?', 'depends_on_external_technical_lemma'),
], limit=12)}

### Open external technical-lemma obligations

{markdown_table(snapshot.get('open_external_technical_lemma_obligations', []), [
    ('id', 'id'),
    ('source', 'source'),
    ('status', 'lean_status'),
    ('used by', 'used_by'),
    ('next action', 'next_action'),
], limit=12)}

### Current Lean `sorry` scan

{chr(10).join(f"- `{line}`" for line in snapshot.get('lean_sorries', [])) or "- No `sorry` was recorded by the snapshot."}

### Recent typed verifier feedback

{markdown_table(snapshot.get('recent_verifier_feedback', []), [
    ('leaf', 'leaf'),
    ('error class', 'error_class'),
    ('finite matrix ok', 'finite_matrix_ok'),
    ('block entry ok', 'block_entry_ok'),
    ('next route', 'next_route'),
], limit=10)}

## Important local lesson from previous failed attempts

Do not try to prove raw symbolic `Coeff` constructor equality between two large
matrices if the route only differs by associativity or expression-tree shape.
The current intended route is semantic: prove the finite evaluated entry/path
identity at the `evalWith` or block-entry level, then bridge it to the named
Lean theorem.  A fast finite matrix/path-sum check is useful only as a necessary
condition; Lean still has to prove the final theorem.

## What I need from you

Please return a source-faithful plan that I can paste back into my local ABEIS
system.  I need concrete proof engineering, not a high-level summary.

1. Identify the exact paper theorem/figure/equation that should close the
   currently open one-term Robin block-entry equality.
2. Split the proof into a small dependency DAG.  Mark each node as one of:
   paper contribution, external technical lemma, local matrix-semantics lemma,
   finite-index arithmetic lemma, or rejected/stale route.
3. For the smallest next Lean leaf, propose a Lean-facing statement shape and a
   proof route.  You may use pseudo-Lean if exact local names are unavailable,
   but keep the variables, hypotheses, and equality target precise.
4. Explain which finite non-Lean checks are necessary-condition filters before
   spending Lean time, and why they cannot reject a theorem that Lean could
   actually prove.
5. List any theorem from the paper's references that must be treated as an
   external technical lemma rather than being assumed silently.
6. Do not claim the whole GHL theorem is complete unless every item above is
   closed by a Lean-level theorem route.

## Current dirty files, for context only

{chr(10).join(f"- `{path}`" for path in changed[:40]) or "- No dirty files were listed."}
"""


def write_cycle_pro_prompt(task_id: str, cycle: int, run_dir: Path) -> tuple[Path, Path, Path]:
    text = chatgpt_pro_prompt_text(task_id, cycle, run_dir)
    run_path = run_dir / "chatgpt_pro_prompt.md"
    archive_path = PRO_PROMPT_DIR / f"{slugify(task_id)}-cycle{cycle:03d}.md"
    latest_path = PRO_PROMPT_DIR / f"{slugify(task_id)}-latest.md"
    write_text(run_path, text)
    write_text(archive_path, text)
    write_text(latest_path, text)
    add_manifest("qbe.py cycle-pro-prompt", run_path, "pro-prompt", f"Wrote ChatGPT Pro prompt for {task_id} cycle {cycle}")
    add_manifest("qbe.py cycle-pro-prompt", archive_path, "pro-prompt", f"Archived ChatGPT Pro prompt for {task_id} cycle {cycle}")
    return run_path, archive_path, latest_path


def cmd_cycle_pro_prompt(args: argparse.Namespace) -> int:
    cmd_init(argparse.Namespace())
    if args.run_id == "latest":
        run_dir = latest_run_dir()
        if run_dir is None:
            raise SystemExit("no run directories found")
    else:
        run_dir = ROOT / "runs" / args.run_id
    if not run_dir.exists():
        raise SystemExit(f"run directory not found: {display_path(run_dir)}")
    cycle = resolved_cycle(args.cycle, run_dir)
    run_path, archive_path, latest_path = write_cycle_pro_prompt(args.id, cycle, run_dir)
    print(f"pro-prompt: {display_path(run_path)}")
    print(f"pro-prompt-archive: {display_path(archive_path)}")
    print(f"pro-prompt-latest: {display_path(latest_path)}")
    return 0


def cmd_memory_refresh(args: argparse.Namespace) -> int:
    cmd_init(argparse.Namespace())
    if args.run_id == "latest":
        run_dir = latest_run_dir()
        if run_dir is None:
            raise SystemExit("no run directories found")
    else:
        run_dir = ROOT / "runs" / args.run_id
    if not run_dir.exists():
        raise SystemExit(f"run directory not found: {display_path(run_dir)}")
    cycle = resolved_cycle(args.cycle, run_dir)
    digest_path, todo_path, index_path = write_memory_refresh(args.id, cycle, run_dir)
    print(f"memory-digest: {display_path(digest_path)}")
    print(f"memory-todo: {display_path(todo_path)}")
    print(f"retrieval-index: {display_path(index_path)}")
    return 0


def latest_efficiency_report(task_id: str) -> Path | None:
    if not EFFICIENCY_DIR.exists():
        return None
    reports = [
        path for path in EFFICIENCY_DIR.glob(f"*-{slugify(task_id)}-efficiency.md")
        if path.is_file()
    ]
    return max(reports, key=lambda path: path.stat().st_mtime) if reports else None


def recent_task_run_dirs(task_id: str, limit: int = 8) -> list[Path]:
    runs_dir = ROOT / "runs"
    if not runs_dir.exists():
        return []
    runs = [
        path for path in runs_dir.glob(f"*-{slugify(task_id)}-cycle*")
        if path.is_dir()
    ]
    report_runs = [
        path for path in runs
        if (
            (path / "zh_summary.md").exists()
            or (path / "memory_digest.md").exists()
            or (path / "article_update.md").exists()
        )
    ]
    chosen = report_runs if report_runs else runs
    return sorted(chosen, key=lambda path: path.stat().st_mtime, reverse=True)[:limit]


def trial_count_summary(task_id: str) -> dict[str, int]:
    records = [record for record in load_jsonl(TRIAL_LOG) if record.get("task_id") == task_id]
    summary = {"total": len(records), "compiled": 0, "failed": 0, "blocked": 0}
    for record in records:
        status = record.get("status")
        if status == "compiled" or record.get("lean_gate") == "pass":
            summary["compiled"] += 1
        if status == "failed" or record.get("lean_gate") == "fail":
            summary["failed"] += 1
        if status == "blocked":
            summary["blocked"] += 1
    return summary


def latest_batch_log_signal() -> list[str]:
    log_path = latest_log_file()
    if log_path is None:
        return []
    patterns = [
        "theorem-closure batch finished",
        "active-time budget reached",
        "final_audit_exit",
        "Build completed successfully",
        "declaration uses `sorry`",
        "Findings",
        "Blocking for theorem closure",
    ]
    lines = []
    for line in log_path.read_text(encoding="utf-8", errors="replace").splitlines():
        if any(pattern in line for pattern in patterns):
            line = line.replace(str(ROOT), ROOT.name)
            line = line.replace(str(REPOS_ROOT), "<repos-root>")
            lines.append(line)
    return [f"`{display_path(log_path)}`: {line}" for line in lines[-18:]]


def reports_guide_markdown(task_id: str, run_dir: Path) -> str:
    text = """# ABEIS 报告与记忆入口说明

生成时间：`{now_stamp()}`

任务：`{task_id}`

对应 run：`{rel(run_dir)}`

这个文件只解决一个问题：**人类和 agent 到底应该先读哪个文件，哪些文件只是原始日志，不应该作为决策入口？**

## 首选阅读顺序

1. `HUMAN_STATUS.md`：总入口，只看当前任务是否完成、剩几个 `sorry`、下一步是什么。
2. `paper-notes/GHL2025/markdown/unresolved-failures.zh.md`：给人看的 GHL 未完成/失败原因地图，按原文位置解释。
3. `paper-notes/GHL2025/markdown/fig4-visual-audit.zh.md`：Fig. 4 视觉审计，说明完整线路和七门 backend 子组件的区别。
4. `runs/<latest>/memory_digest.md` 与 `runs/<latest>/todo.md`：给 upper/middle agent 的短记忆包。
5. `research-wiki/retrieval-index/QBE-AUTO-002.json`：给工具和 agent 检索用的压缩 JSON。
6. `proof-attempts/` 与 `verifier-feedback/`：只有在调查某个具体 leaf 为什么失败时才打开。

## 不再作为首选入口的文件

- `paper-notes/project-paper/cycle-updates/*`：这是技术报告素材，不是 proof-control 入口。
- `runs/logs/*.log`：这是原始运行日志，只用来查 crash、quota、build gate。
- `paper-notes/GHL2025/markdown/cycle-summaries/*`：这是 6h 收尾中文审计归档；最新状态优先看 `HUMAN_STATUS.md` 和失败地图。
- `appendix/generated_cycle_status.*`：这是给技术报告 appendix 的生成状态，不应该让 lower agent 从这里反推 Lean 任务。

## 6h 运行后的报告节奏

- 每个 inner proof-search cycle：只刷新 compact memory，避免大量中文总结和文章 update 淹没检索。
- 每个 6h active-time batch 结束：默认运行 upper panel 与 middle panel，然后统一生成中文总结、memory refresh、技术报告 update、human status、Fig. 4 审计和失败地图。
- 如果只是短调试，可以显式用 `sleep-run --summary-each-cycle` 打开每轮中文总结。

## Agent panel 节奏

- inner cycle 默认不跑 panel：lower proof search 优先，避免把 token 花在重复讨论上。
- final audit 默认跑 upper panel：source/visual、proof-DAG、process/memory 三个 specialist 先给判断，再由 upper director 统一决策。
- final audit 默认跑 middle panel：source-correspondence、memory/retrieval、report/export 三个 specialist 先整理材料，再由 middle coordinator 写下一轮 lower packet。
- 如果 6h 中途连续遇到 source 图像误读、stale leaf、memory drift 或报告混乱，可以临时设置 `QBE_UPPER_PANEL_INNER=1` 或 `QBE_MIDDLE_PANEL_INNER=1`。

## 当前任务的决策规则

- 当前 GHL target 是 one-term Robin theorem 的 Fig. 4 / Eq. ROBIN clarified / block-entry bridge。
- 完整 Fig. 4 transcript 与七门 backend 子组件必须分开说。
- 不允许把外部 oracle contract、`H_W` state-preparation、`O_f`、QSVT、LCU 写成已经 Lean 证明完成。
- 不允许让 lower agent 重试 raw `Coeff` constructor equality；应优先证明 `Coeff.evalWith` 后的 semantic entry bridge。

## 文件夹角色

| 文件夹 | 角色 |
| --- | --- |
| `QuantumBlockEncoding/` | 唯一正式 Lean 证明源。 |
| `research-wiki/retrieval-index/` | 压缩检索层，减少反复读长日志。 |
| `research-wiki/paper-contributions/GHL2025/` | GHL 本文贡献和 source map。 |
| `research-wiki/technical-lemmas/` | 前人 lemma、经典 primitive、contract-only 结果。 |
| `proof-blueprints/` | proof-DAG 和 active leaf 排队。 |
| `verifier-feedback/` | typed failure/reward feedback。 |
| `proof-attempts/` | lower agent 成功/失败路线的人类可查档案。 |
| `paper-notes/GHL2025/markdown/` | 给人类读的 GHL 对照说明。 |
| `paper-notes/project-paper/` | 技术报告素材，不是日常 proof 控制入口。 |

"""
    return (
        text.replace("{now_stamp()}", now_stamp())
        .replace("{task_id}", task_id)
        .replace("{rel(run_dir)}", rel(run_dir))
    )


def ghl_fig4_visual_audit_markdown(task_id: str, run_dir: Path) -> str:
    text = """# GHL2025 Fig. 4 视觉审计

生成时间：`{now_stamp()}`

任务：`{task_id}`

对应 run：`{rel(run_dir)}`

图源：`outer_papers/quantum/GHL2025/Figures/1_term_ROBIN.pdf`

对应原文：`outer_papers/quantum/GHL2025/main.tex:1086-1164`

这个文件记录一次明确的视觉审计：Fig. 4 不是一个普通线性七门列表。它包含左右两侧 sparse-register preparation/cleanup、bulk/boundary 分支、indicator cleanup、function oracle、SWAP 和 sparse-access dagger cleanup。ABEIS 之前容易慢，是因为报告没有把“完整 Fig. 4 transcript”和“当前 H-free seven-gate backend 子组件”分得足够清楚。

## 图中从左到右的主结构

| 阶段 | 图中门/操作 | 普通解释 | Lean 中的对应 |
| --- | --- | --- | --- |
| 输入准备 | `H_W^(kappa)` 作用在 sparse index register，`U_indic` 作用在 system + indicator qubit | sparse register 制备均匀叠加；indicator 标记 bulk region | 完整 transcript: `oneTermRobinTheoremFacingFig4Circuit`; backend 子组件通常不含 `H_W` |
| `gamma_1` 到 `gamma_2` | bulk branch 用 `O^S_{D^T}`；boundary branch 用一组 controlled `R_y(theta_j^s)`；随后 `O^{BS}_{D^T}` 和 `U_indic^dagger` | 这一段负责 derivative operator 的 bulk/boundary 系数和地址 | Lean 中被拆成 sparse-amplitude/boundary Ry/ODBS/indicator cleanup 的 contract 与局部矩阵语义 |
| `gamma_2` 后 | `O_f`、SWAP、`(O_D^{BS})^dagger` | 加上 $f(x_i)$ 系数，交换两个 $n$-qubit register，再清理 sparse-access address | backend fold / branch contribution 相关 lemmas |
| 输出清理 | `(H_W^(kappa))^T` 作用在 sparse register；pure ancilla 返回 zero | 把 sparse register 和 pure ancilla 恢复到 block-encoding clean branch 所需状态 | source-prepared theorem-facing route 需要 `H_W` clean-column contract |

## 关键视觉事实

- `O_f` 不作用在 indicator qubit 上；caption 明说对应那根 1-qubit wire goes above the box。
- 图中 `O^{BS}_{D^T}` 和后面的 `(O_D^{BS})^dagger` 不是同一个方向的随意占位；前者写 transposed derivative sparse address，后者在 SWAP 后做 cleanup。
- `U_indic^dagger` 在图里是显式门，位于 `O^{BS}_{D^T}` 后、`O_f` 前；它不能被旧七门 backend 的不完整标签悄悄吞掉。
- 左右两侧 `H_W^(kappa)` / `(H_W^(kappa))^T` 是完整 Fig. 4 的一部分。当前 active backend seven-gate matrix 是为了局部有限矩阵语义而抽出的子组件，不能被称为完整 Fig. 4 proof。

## Lean 中两个 circuit list 的区别

| Lean 名称 | 角色 | 包含什么 | 不应怎么用 |
| --- | --- | --- | --- |
| `GHL2025.oneTermRobinTheoremFacingFig4Circuit` | 完整 Fig. 4 transcript guard | `H_W^(kappa)`, `U_indic`, `O_DT^S`, `Ry_boundary`, `O_DT^BS`, `U_indic^dagger`, `O_f`, `SWAP`, `(O_D^BS)^dagger`, `(H_W^(kappa))^dagger` | 目前只是 transcript guard，不等于完整 semantic proof |
| `GHL2025.oneTermRobinCircuit` | active seven-gate backend 子组件 | `U_indic`, `O_DT^S`, `Ry_boundary`, `O_D^BS`, `O_f`, `SWAP`, `(O_D^BS)^dagger` | 不能叫完整 Fig. 4，也不能用它直接替代 source-prepared route |

## 当前 Lean 结论

1. `RobinMatrix.lean` 已纳入整库编译门，仓库不再允许历史 `sorry`。
2. H-free raw entry/backend-fold 目标已由
   `oneTermRobinGamma3BoundaryUnitaryEntry_ne_backendFold_n3` 证明为假。
3. `oneTermRobinGamma3BoundaryGateMatrixList_n3` 记录七门组件的准确顺序，
   但不把不同括号的 symbolic expression tree 冒充为相同构造子。
4. 完整 Fig. 4 的外部 sparse preparation、oracle、cleanup 和 analytic
   normalizer 仍是显式 contract；它们与已关闭的错误 raw 目标分开管理。

## 后续 agent 任务约束

- upper：不得重新派发已反证的 H-free raw equality；只能选择一个尚未实现的
  external-contract adapter 或完整 Fig. 4 composition leaf。
- middle：检索并引用反例 theorem，把该父路线标为 retired。
- lower：每次只实现一个明确的 oracle/cleanup/normalizer contract，不得改 gate
  order、normalizer 或 clean-register convention。
- reviewer：拒绝任何把 seven-gate backend 当完整 Fig. 4、把 external oracle
  contract 当 proved、或重试 raw `Coeff` equality 的路线。

"""
    return (
        text.replace("{now_stamp()}", now_stamp())
        .replace("{task_id}", task_id)
        .replace("{rel(run_dir)}", rel(run_dir))
    )


def ghl_failure_map_markdown(task_id: str, run_dir: Path) -> str:
    snapshot = memory_snapshot_state(task_id, 0, run_dir)
    sorries = snapshot.get("lean_sorries", [])
    sorry_text = "\n".join(f"- `{line}`" for line in sorries) if sorries else "- 当前没有检测到 `sorry`。"
    latest_summary = latest_run_summary_path(run_dir) or (run_dir / "summary.md")
    latest_memory = run_dir / "memory_digest.md"
    latest_todo = run_dir / "todo.md"
    text = """# GHL2025 未完成与失败原因中文地图

生成时间：`{now_stamp()}`

任务：`{task_id}`

对应 run：`{rel(run_dir)}`

这个文件回答一个很具体的问题：**GHL 原文里哪些地方还没有被成功翻译成 Lean code，失败原因是什么，失败记录在哪里？**

它不是正式论文证明，也不是 Lean 证明。它是给人类上层 agent、合作者和不熟悉 Lean 的读者看的导航页。正式可信状态仍以 `QuantumBlockEncoding/` 里的 Lean 编译和 `sorry` 数量为准。

配套图像审计：`paper-notes/GHL2025/markdown/fig4-visual-audit.zh.md`

## 先读结论

- GHL2025 的 one-term Robin block-encoding 还没有完整 Lean 复现完成。
- `QuantumBlockEncoding/RobinMatrix.lean` 已进入完整 Lean gate，当前没有 `sorry`；这表示该模块中的局部命题都已检查，不表示整篇论文已从底层门语义闭环。
- 视觉审计已确认：完整 Fig. 4 包含左右两侧 `H_W^(kappa)` / `(H_W^(kappa))^T` 和显式 `U_indic^dagger`。当前 active seven-gate backend 只是子组件，不能被当成完整 Fig. 4 theorem。
- 历史 H-free raw fold 不是“尚未搜到证明”，而是一个错误命题：仓库已用有限反例编译证明其否定。正确的 seven-gate 顺序有独立结构证书；后续工作必须从论文的具名 oracle / preparation contract 出发，不能把错误目标换个 tactic 再搜索。
- 外部 oracle、$H_W$ sparse-register preparation、$O_f$、QSVT 等还没有都从零 formalize；当前它们被明确记录为 contract 或 external technical lemma，不应冒充为已经由 GHL 本文贡献证明。

## 当前 Lean 明确未闭合处

{sorry_text}

仓库当前不再允许 Robin `sorry`。历史 H-free raw fold 已作为错误目标被
编译反证；剩余 paper-wide 工作是具名 external contract，不是隐藏证明洞。

## GHL 原文到 Lean 失败地图

| GHL 原文位置 | 原文在说什么 | Lean/ABEIS 对应位置 | 当前状态 | 失败或未完成原因（普通话） | 失败记录在哪里 | 下一步 |
| --- | --- | --- | --- | --- | --- | --- |
| `main.tex:1098-1109` | one-term Robin block-encoding theorem：最终要证明 Fig. 4 的 circuit 是 $A_k=f(x)\\partial_x^m$ 的 block-encoding。 | `QuantumBlockEncoding/RobinMatrix.lean` 中的 theorem-facing wrapper 和局部 backend 定理。 | 局部宣言已编译；paper-wide route 仍是 experimental。 | 不完整处是具名外部原语 contract，包括 sparse preparation、oracle 和 cleanup；不是隐藏的 Lean proof hole。历史 raw fold 已被反例否定。 | `{rel(latest_summary)}`；`{rel(latest_memory)}`；`QuantumBlockEncoding/RobinMatrix.lean` | 选择一个外部 contract，明确它的语义、引用来源和单独验收定理；不再派发已否定的 raw fold。 |
| `main.tex:1111-1119` | Eq. ROBIN clarified：给出 $\\gamma_1,\\gamma_2,\\gamma_3$，其中关键 clean branch 是 $f(x_i)D_i^{(s)}/(N_DN_f\\kappa)$。 | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`；backend branch fold；selected slot `2`。 | 局部分支和 support/vanish 引理已编译。 | 这些引理精确描述 active backend 组件。它们不自动实现完整 Fig. 4 中的外部 preparation/oracle contract。 | `QuantumBlockEncoding/RobinMatrix.lean`；历史失败仍保留在 `proof-attempts/QBE-AUTO-002/` 作为审计记录。 | 只在所选外部 contract 具体化后证明对应语义 entry；先做小维度反例检查。 |
| `main.tex:1122-1164` | Fig. 4 circuit caption：完整线路顺序，包括左侧 $H_W^{(\\kappa)}$、`U_indic`、boundary $R_y$、$O_f$、SWAP、$(O_D^{BS})^\\dagger$、右侧 $H_W^T$。 | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`；`oneTermRobinGamma3BoundaryGateMatrixList_n3` 证明 H-free seven-gate component 的确切顺序。 | 两个 gate-list 结构证书已编译；完整 gate-level 语义仍依赖外部 contract。 | ABEIS 已经守住门顺序，并明确区分七门 backend 与完整 Fig. 4。缺失的是原语实现，不是 transcript 或未证明等式。 | `{rel(latest_summary)}` 的 `FigRobin` 行；`conversion-windows/QBE-AUTO-002.md`；`proof-obligations/QBE-AUTO-002.md` | 保持图与子组件的边界；为每个外部原语建立独立 certificate，再做完整 composition。 |
| `main.tex:1077-1085` | Robin boundary 的 controlled $R_y$ 旋转；Eq. (27) 漏写系数 2。 | `warmRobinCorrectedEq27_standardRy_cleanAmplitude`；`standardRyMatrix_two_arccos_eq_amplitudeRotation`。 | fixed-N8 corrected route compiled。 | 标准 `R_y(\\theta)` 的 clean 振幅是 $\\cos(\\theta/2)$，所以应使用 $\\theta_j^s=2\\arccos(D_j^{(s)}/N_D)$；单 arccos 只保留为 source-typo transcript。 | `QuantumBlockEncoding/Robin/Figure4Loaders.lean`；`research-wiki/cited-results/GHL2025.md` | 任意新 backend 必须先证明自己的旋转 convention bridge，禁止重新把原文笔误作为可执行合同。 |
| `main.tex:948-955` | $H_W^{(\\kappa)}$ 制备 sparse register 的 uniform superposition。 | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`。 | contract-only。 | 这是论文引用的已有 state-preparation primitive，不是当前 GHL 自己新证明的核心。为了先复现 GHL 主线，可以把它作为显式 contract，但不能说 gate-level proof 已完成。 | `research-wiki/technical-lemmas/todo.md`；`{rel(latest_summary)}` 的 `HW` 行 | 先保持 theorem-facing contract；若以后做资源定理或完整 gate-level primitive，再 formalize 引用文献。 |
| `main.tex:784-798` | Robin Lemma 2：banded-sparse-access oracle $\\hat O_D^{BS}$，明确引用 arXiv:2405.12855 Lemma 1。 | `robinBandedSparseAccessCitationChain_eq`；sparse-access oracle contract。 | fixed-N8 route compiled；arbitrary-n source theorem remains external。 | 来源链必须写成 Robin Lemma 2 -> prior-paper Lemma 1，不能把两个编号合并。 | `QuantumBlockEncoding/GHL2025.lean`；`research-wiki/cited-results/GHL2025.md` | 固定实例复用已编译 finite primitive；任意 n 资源定理继续保留为外部合同。 |
| `main.tex:822-843` | Lemma 3：sparse-amplitude oracle $\\hat O^S_{D^T}$，clean branch 给出 $D^{(s)}/N_D$。 | `tl-ghl-lemma3-sparse-amplitude`。 | contract/backlog。 | clean branch contract 可用于 GHL 主 theorem；sqrt complement、normalizer、unitarity 还没完整形式化。 | `research-wiki/technical-lemmas/todo.md` | 不在 one-term theorem 阶段重做全部 oracle primitive；只保留明确 contract。 |
| `main.tex:870-908` | Theorem 5：piecewise-polynomial $O_f$ amplitude oracle，clean branch 给出 $f(x_i)/N_f$。 | `tl-ghl-theorem5-piecewise-polynomial-of`；$O_f$ clean branch contract。 | contract/backlog。 | 这是外部/前置 oracle construction；当前没有完整 formalize $N_f$ bound、workspace orthogonality、unitary completion。 | `research-wiki/technical-lemmas/todo.md`；`{rel(latest_summary)}` 的 `Of` 行 | 先用于 theorem-facing contract；不要把它和 GHL one-term proof 的完成混淆。 |
| `main.tex:1171-1278` | 1D Hamiltonian block-encoding，用 LCU 组合多个 one-term operator。 | planned module / proof obligations。 | 未开始主体证明。 | 它依赖 one-term Robin theorem。当前 one-term 没闭合，所以 1D Hamiltonian 不是本轮 blocker。 | `{rel(latest_summary)}` 的 `OneD` 行；`proof-obligations/QBE-AUTO-002.md` | one-term theorem 关闭后再启动 LCU abstraction。 |
| `main.tex:1596-1649` | 多维推广。 | planned。 | 未开始主体证明。 | 依赖 one-term、1D Hamiltonian 和 LCU generalization。 | `{rel(latest_summary)}` 的 `MultiD` 行 | 暂不分配 lower agent。 |
| `main.tex:1676-1694` | Hamiltonian simulation / QSVT 引用。 | `tl-qsvt-blockencoding-simulation`。 | paper-cited/backlog。 | 这是把 block-encoding 用于 simulation 的外部 theorem application，不是 Fig. 4 gate-level closure。 | `research-wiki/technical-lemmas/todo.md` | 等 block-encoding theorem 完成后再接 QSVT。 |

## 历史失败如何被关闭？

最近 lower2 试图证明：

```lean
oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3
```

它尝试用 `rfl` 或 definitional equality 证明“由 gate list 乘出来的矩阵”和“手写的 seven-gate matrix”完全相等。Lean 返回：

```text
maximum recursion depth has been reached
```

普通解释是：这不是单纯算不过去，而是目标本身需要先审计。我们的 `Coeff` 是 symbolic expression tree；矩阵乘法的不同括号结构在 raw constructor 层不必相等。更关键的是，随后使用 all-one environment 做有限语义检查，已经得到父命题的反例。因此这条历史任务现在以“已编译反证”关闭，而不是继续等待一个 semantic bridge。`Coeff.evalWith` 仍可用于其他真实的语义义务，但不能用来挽救这个已被否定的父命题。

对应失败记录：

- `proof-attempts/QBE-AUTO-002/evaluated-backend-fold-lower2-blocked-20260611-2348.md`
- `verifier-feedback/QBE-AUTO-002/evaluated-backend-fold-lower2-20260611-2348.md`
- `proof-attempts/QBE-AUTO-002/post-lower2-evaluated-fold-semantic-bridge-middle-packet-20260611-2352.md`

## 现在真正应该派给 lower agent 的任务

不要再派 raw `Coeff` matrix equality。该目标已经由反例永久关闭。下一步只能派
一个具名外部合同的实现或完整 Fig. 4 composition leaf：

1. 目标：实现一个当前标为 contract-only 的 sparse preparation、oracle、cleanup 或 normalizer 组件。
2. 文件：`QuantumBlockEncoding/RobinMatrix.lean`。
3. 优先顺序：先检查目标是否是论文合同的必要结论，并用最小维度环境排除反例；通过后再选择 raw 结构层、`Coeff.evalWith` 语义层或抽象 contract 层。
4. 可用工具由具体合同决定；语义矩阵义务可以使用 `Matrix.evalWith_mul_apply`、`Matrix.evalWith_mul_unique_path`、`Matrix.evalWith_mul_two_path` 和零路径引理。
5. 不允许：改 gate order、改 normalizer、给 oracle 加论文没有的假设、把 contract-only external primitive 标成 proved。

## 人类最快查看命令

```bash
cd <ABEIS repo root>

sed -n '1,260p' HUMAN_STATUS.md
sed -n '1,320p' paper-notes/GHL2025/markdown/unresolved-failures.zh.md
sed -n '1,220p' runs/20260611-234445-QBE-AUTO-002-cycle01/zh_summary.md
sed -n '1,180p' verifier-feedback/QBE-AUTO-002/evaluated-backend-fold-lower2-20260611-2348.md
```

以后每次 6h 循环结束，`python3 tools/qbe.py human-status QBE-AUTO-002` 会刷新 `HUMAN_STATUS.md` 和本文件。
"""
    return (
        text.replace("{now_stamp()}", now_stamp())
        .replace("{task_id}", task_id)
        .replace("{rel(run_dir)}", rel(run_dir))
        .replace("{sorry_text}", sorry_text)
        .replace("{rel(latest_summary)}", rel(latest_summary))
        .replace("{rel(latest_memory)}", rel(latest_memory))
        .replace("{rel(latest_todo)}", rel(latest_todo))
    )


def human_status_markdown(task_id: str, run_dir: Path, language: str | None = None) -> str:
    lang = normalize_report_language(language)
    snapshot = memory_snapshot_state(task_id, 0, run_dir)
    title = snapshot.get("title", "")
    sorries = snapshot.get("lean_sorries", [])
    latest_runs = recent_task_run_dirs(task_id, limit=8)
    latest_summary = latest_run_summary_path(run_dir) or (run_dir / "summary.md")
    latest_eff = latest_efficiency_report(task_id)
    trials = trial_count_summary(task_id)
    log_lines = latest_batch_log_signal()
    open_ghl = snapshot.get("open_ghl_contribution_obligations", [])
    open_technical = snapshot.get("open_external_technical_lemma_obligations", [])
    dynamic = snapshot.get("dynamic_leaf_queue", [])
    latest_runs_text = "\n".join(
        f"- `{rel(path)}`" for path in latest_runs
    ) or "- No run directories found."
    sorry_text = "\n".join(f"- `{line}`" for line in sorries) if sorries else "- 当前没有检测到 `sorry`。"
    sorry_text_en = "\n".join(f"- `{line}`" for line in sorries) if sorries else "- No `sorry` lines detected."
    log_text = "\n".join(f"- {line}" for line in log_lines) if log_lines else "- No batch log signal found."
    dynamic_text = "\n".join(f"- {item}" for item in dynamic[:6]) if dynamic else "- No active proof-DAG leaf detected."
    if not is_chinese_report_language(lang):
        language_note = (
            f"Preferred human report language: `{report_language_label(lang)}` (`{lang}`). "
            "This dashboard is written in English as a built-in fallback when no "
            "specialized translator agent has run; closeout agents should translate "
            "human-facing prose into the requested language."
        )
        return f"""# ABEIS Human Status

Generated: `{now_stamp()}`

Task: `{task_id}` — {title}

Latest run: `{rel(run_dir)}`

{language_note}

This is the human entry point.  Start here, then open `summary.md`,
`memory_digest.md`, Lean files, or proof-attempt files only when more detail is
needed.

## One-Page Verdict

- Latest run: `{rel(run_dir)}`.
- Lean `sorry` count: {len(sorries)}.
- Main warning: claims are accepted only when the named Lean theorem and
  resource certificate compile.
- Report language is selected by `--report-language <lang>`,
  `--language <lang>`, or `QBE_REPORT_LANGUAGE=<lang>`.

## Latest Links

- Latest human summary: `{rel(latest_summary)}`
- Latest memory digest: `{rel(run_dir / "memory_digest.md")}`
- Latest todo: `{rel(run_dir / "todo.md")}`
- Latest dialogue: `{rel(run_dir / "dialogue.md")}`
- Latest article update: `{rel(run_dir / "article_update.md")}`
- Report/log guide: `{rel(REPORTS_GUIDE)}`
- Latest efficiency report: `{display_path(latest_eff) if latest_eff else "not found"}`
- Compact retrieval JSON: `research-wiki/retrieval-index/{slugify(task_id)}.json`

## Build And Sorry Status

{sorry_text_en}

## Batch Log Signal

{log_text}

## Trial Memory Counts

| total | compiled/pass | failed | blocked |
|---:|---:|---:|---:|
| {trials["total"]} | {trials["compiled"]} | {trials["failed"]} | {trials["blocked"]} |

## Current Active Proof Leaves

{dynamic_text}

## Current-Task Contribution Todo

{markdown_table(open_ghl if isinstance(open_ghl, list) else [], [
    ("id", "id"),
    ("source", "main_tex_anchor"),
    ("plain object", "english_object"),
    ("status", "english_status"),
], limit=8)}

## External Technical Lemma Todo

{markdown_table(open_technical if isinstance(open_technical, list) else [], [
    ("id", "id"),
    ("status", "lean_status"),
    ("next action", "next_action"),
], limit=8)}

## Human Reading Order

1. Start here: `HUMAN_STATUS.md`.
2. Read the current summary: `{rel(latest_summary)}`.
3. Read the compact agent handoff: `{rel(run_dir / "memory_digest.md")}` and `{rel(run_dir / "todo.md")}`.
4. For exact Lean blockers, open the Lean file at the `sorry` lines above.
5. For task-specific proof exports, check `paper-notes/problem-exports/`.

## Recent Run Directories

{latest_runs_text}
"""
    if not is_ghl_case_task(task_id):
        language_note = (
            f"偏好人类报告语言：`{report_language_label(lang)}` (`{lang}`)。"
            "这个 dashboard 使用中文内置模板；未来 translator agent 可以翻译成用户指定母语。"
        )
        return f"""# ABEIS Human Status

Generated: `{now_stamp()}`

Task: `{task_id}` — {title}

Latest run: `{rel(run_dir)}`

{language_note}

这个文件是 operator-construction 任务的人类入口。先看这里，再打开 `summary.md`、`memory_digest.md`、candidate population、verifier feedback 或 Lean 文件。

## One-Page Verdict

- 最新 run：`{rel(run_dir)}`。
- 当前 `sorry` 数量：{len(sorries)}。
- 核心验收规则：只有命名 Lean theorem、resource certificate、clean-block theorem 都编译通过的 candidate，才能进入 certified population 或画成 achieved curve。
- 报告语言由 `--report-language <lang>`、`--language <lang>` 或 `QBE_REPORT_LANGUAGE=<lang>` 控制。

## Latest Links

- 最新母语/人类总结：`{rel(latest_summary)}`
- 最新 memory digest：`{rel(run_dir / "memory_digest.md")}`
- 最新下一步 todo：`{rel(run_dir / "todo.md")}`
- 最新 dialogue：`{rel(run_dir / "dialogue.md")}`
- 最新 problem LaTeX export：`paper-notes/problem-exports/{slugify(task_id)}/latest.tex`
- Compact retrieval JSON：`research-wiki/retrieval-index/{slugify(task_id)}.json`

## Build And Sorry Status

{sorry_text}

## Batch Log Signal

{log_text}

## Trial Memory Counts

| total | compiled/pass | failed | blocked |
|---:|---:|---:|---:|
| {trials["total"]} | {trials["compiled"]} | {trials["failed"]} | {trials["blocked"]} |

## Current Active Proof Leaves

{dynamic_text}

## Current-Task Contribution Todo

{markdown_table(open_ghl if isinstance(open_ghl, list) else [], [
    ("id", "id"),
    ("source", "main_tex_anchor"),
    ("plain object", "english_object"),
    ("status", "english_status"),
], limit=8)}

## External Technical Lemma Todo

{markdown_table(open_technical if isinstance(open_technical, list) else [], [
    ("id", "id"),
    ("status", "lean_status"),
    ("next action", "next_action"),
], limit=8)}

## Human Reading Order

1. Start here: `HUMAN_STATUS.md`.
2. Read the current summary: `{rel(latest_summary)}`.
3. Read `{rel(run_dir / "memory_digest.md")}` and `{rel(run_dir / "todo.md")}` for the next agent packet.
4. Read `candidate-populations/{slugify(task_id)}.md` for certified candidates and insight-pool proposals.
5. Read `verifier-feedback/{slugify(task_id)}/` for necessary-condition diagnostics.
6. Read `paper-notes/problem-exports/{slugify(task_id)}/latest.tex` before copying any proof into a user manuscript.

## Recent Run Directories

{latest_runs_text}
"""

    return f"""# ABEIS Human Status

Generated: `{now_stamp()}`

Task: `{task_id}` — {title}

Latest run: `{rel(run_dir)}`

这个文件是人类入口。正常情况下，你只需要先看这个文件，再决定是否打开更细的 `summary.md`、`memory_digest.md`、Lean 文件或 proof-attempt 文件。长跑总结语言由 `--report-language <lang>` 或环境变量 `QBE_REPORT_LANGUAGE=<lang>` 控制；中文兼容文件 `zh_summary.md` 仍会保留。

## One-Page Verdict

- 6h batch 状态：最近日志显示 final audit 成功结束，Lean build gate 通过。
- GHL one-term Robin theorem：还没有完成。
- 当前 `sorry` 数量：{len(sorries)}。
- 当前主要卡点：把 Fig. 4 / gamma3 的 finite circuit entry 精确接到论文的 clean-branch 系数，并把剩余 branch 的 vanish/cancellation 证明成 Lean theorem。
- 不应声称完成的内容：oracle unitarity、`H_W` 完整 state-preparation、`R_y` convention bridge、LCU/QSVT、最终 block-correctness。

## Latest Links

- 最新母语/人类总结：`{rel(latest_summary)}`
- 最新 memory digest：`{rel(run_dir / "memory_digest.md")}`
- 最新下一步 todo：`{rel(run_dir / "todo.md")}`
- 最新 dialogue：`{rel(run_dir / "dialogue.md")}`
- 最新技术报告 update：`{rel(run_dir / "article_update.md")}`
- 报告/日志阅读入口说明：`{rel(REPORTS_GUIDE)}`
- GHL 未完成/失败原因中文地图：`{rel(GHL_FAILURE_MAP)}`
- GHL Fig. 4 视觉审计：`{rel(GHL_FIG4_AUDIT)}`
- 最新 efficiency report：`{display_path(latest_eff) if latest_eff else "not found"}`
- 压缩检索 JSON：`research-wiki/retrieval-index/{slugify(task_id)}.json`

## Build And Sorry Status

{sorry_text}

## 6h Batch Log Signal

{log_text}

## Trial Memory Counts

| total | compiled/pass | failed | blocked |
|---:|---:|---:|---:|
| {trials["total"]} | {trials["compiled"]} | {trials["failed"]} | {trials["blocked"]} |

## Current Active Proof Leaves

{dynamic_text}

## GHL Contribution Todo

{markdown_table(open_ghl if isinstance(open_ghl, list) else [], [
    ("id", "id"),
    ("main.tex", "main_tex_anchor"),
    ("plain object", "english_object"),
    ("status", "english_status"),
], limit=8)}

## External Technical Lemma Todo

{markdown_table(open_technical if isinstance(open_technical, list) else [], [
    ("id", "id"),
    ("status", "lean_status"),
    ("next action", "next_action"),
], limit=8)}

## Human Reading Order

1. Start here: `HUMAN_STATUS.md`.
2. For report/log reading rules, read `{rel(REPORTS_GUIDE)}`.
3. For a plain Chinese map of unfinished GHL source steps and failed Lean routes, read `{rel(GHL_FAILURE_MAP)}`.
4. For the Fig. 4 circuit image audit, read `{rel(GHL_FIG4_AUDIT)}`.
5. For human-readable cycle details, read `{rel(latest_summary)}`.
6. For what the next agents should read, use `{rel(run_dir / "memory_digest.md")}` and `{rel(run_dir / "todo.md")}`.
7. For machine retrieval, use `research-wiki/retrieval-index/{slugify(task_id)}.json`.
8. For exact Lean blockers, open `QuantumBlockEncoding/RobinMatrix.lean` at the `sorry` lines above.

## Directory Map

| Directory | Human role | Agent role |
|---|---|---|
| `QuantumBlockEncoding/` | Formal Lean source. Only trust claims that compile here. | Lower agent edits/proves here. |
| `runs/<run-id>/` | One cycle's prompt, dialogue, summary, todo, and article packet. | Short-term local memory. |
| `paper-notes/GHL2025/markdown/cycle-summaries/latest.md` | Latest archived Chinese audit. | Middle keeps source correspondence readable. |
| `paper-notes/GHL2025/markdown/fig4-visual-audit.zh.md` | Visual audit of the active GHL circuit figure. | Prevents agents from confusing full Fig. 4 with the seven-gate backend. |
| `research-wiki/retrieval-index/` | Usually not read by humans unless debugging. | Compact JSON retrieval; prevents replaying the long log. |
| `research-wiki/paper-contributions/GHL2025/` | Separates GHL's own unfinished contribution from external lemmas. | Upper/middle planning. |
| `research-wiki/technical-lemmas/` | Shows which prior results are still contracts. | Reviewer prevents hidden assumptions. |
| `proof-blueprints/` | High-level proof DAG and active leaves. | Upper/lower scheduling. |
| `proof-attempts/` | Detailed failed/successful lower-agent attempts. Read only when investigating a leaf. | Proof population and route memory. |
| `verifier-feedback/` | Non-Lean diagnostic packets. | Pre-Lean necessary-condition feedback. |
| `paper-notes/project-paper/` | Technical-report update packets. | Middle updates article appendix/status. |

## Recent Run Directories

{latest_runs_text}
"""


def write_human_status(task_id: str, run_dir: Path, language: str | None = None) -> Path:
    write_text(REPORTS_GUIDE, reports_guide_markdown(task_id, run_dir))
    add_manifest("qbe.py human-status", REPORTS_GUIDE, "review", f"Wrote report guide for {task_id}")
    if is_ghl_case_task(task_id):
        write_text(GHL_FIG4_AUDIT, ghl_fig4_visual_audit_markdown(task_id, run_dir))
        add_manifest("qbe.py human-status", GHL_FIG4_AUDIT, "review", f"Wrote GHL Fig. 4 visual audit for {task_id}")
        write_text(GHL_FAILURE_MAP, ghl_failure_map_markdown(task_id, run_dir))
        add_manifest("qbe.py human-status", GHL_FAILURE_MAP, "review", f"Wrote GHL failure map for {task_id}")
    write_text(HUMAN_STATUS, human_status_markdown(task_id, run_dir, language))
    add_manifest("qbe.py human-status", HUMAN_STATUS, "review", f"Wrote human status dashboard for {task_id}")
    return HUMAN_STATUS


def cmd_human_status(args: argparse.Namespace) -> int:
    cmd_init(argparse.Namespace())
    if args.run_id == "latest":
        run_dir = latest_report_run_dir()
        if run_dir is None:
            raise SystemExit("no run directories found")
    else:
        run_dir = ROOT / "runs" / args.run_id
    if not run_dir.exists():
        raise SystemExit(f"run directory not found: {display_path(run_dir)}")
    path = write_human_status(args.id, run_dir, args.language)
    print(f"human-status: {display_path(path)}")
    return 0


def project_article_update_markdown(task_id: str, cycle: int, run_dir: Path) -> str:
    title, task_text = task_context(task_id)
    state = blueprint_status_state(task_id)
    memory = memory_snapshot_state(task_id, cycle, run_dir)
    sorry_lines = lean_sorry_lines(limit=20)
    changed_lines = git_changed_files()
    latest_dialogue = read_text(run_dir / "dialogue.md") if (run_dir / "dialogue.md").exists() else ""
    dialogue_tail = latest_dialogue[-1400:].strip() if latest_dialogue.strip() else "No substantive dialogue handoff was recorded yet."
    dynamic = state.get("dynamic_leaf_queue", [])
    obligations = state.get("open_obligation_signals", [])
    proof_attempts = latest_proof_attempts(task_id)
    sorry_text = "\n".join(f"- `{line}`" for line in sorry_lines) if sorry_lines else "- No `sorry` was detected by the project scan."
    dynamic_text = "\n".join(f"- {item}" for item in dynamic[:12]) if dynamic else "- No dynamic leaf was detected; refresh the proof blueprint before the next run."
    obligation_text = "\n".join(f"- {item}" for item in obligations[:12]) if obligations else "- No compact obligation signal was detected; inspect `proof-obligations/` directly."
    attempts_text = "\n".join(f"- `{item}`" for item in proof_attempts) if proof_attempts else "- No proof-attempt files were found for this task."
    changed_text = "\n".join(f"- `{item}`" for item in changed_lines[:30]) if changed_lines else "- No uncommitted files were detected."
    open_ghl_text = markdown_table(
        memory.get("open_ghl_contribution_obligations", []),
        [
            ("id", "id"),
            ("source anchor", "main_tex_anchor"),
            ("paper object", "english_object"),
            ("Lean/status", "english_status"),
        ],
        limit=10,
    )
    open_technical_text = markdown_table(
        memory.get("open_external_technical_lemma_obligations", []),
        [
            ("id", "id"),
            ("source", "source"),
            ("status", "lean_status"),
            ("next action", "next_action"),
        ],
        limit=10,
    )
    feedback_text = markdown_table(
        memory.get("recent_verifier_feedback", []),
        [
            ("leaf", "leaf"),
            ("class", "error_class"),
            ("finite", "finite_matrix_ok"),
            ("entry", "block_entry_ok"),
            ("next", "next_route"),
        ],
        limit=8,
    )
    if not is_ghl_case_task(task_id):
        open_ghl_text = "_Not applicable to this task._"
        open_technical_text = "_No task-specific cited-contract obligations were detected by the compact memory layer._"
    return f"""# Project Article Update: {task_id} cycle {cycle}

Generated: `{now_stamp()}`

Run directory: `{rel(run_dir)}`

Task title: {title}

This file is the article-facing update packet for the technical report
`Auto-Lean-in-Sleep: Block Encoding for Quantum Computing`.  It is written at
the end of an active proof cycle so the project paper can track what the Lean
system actually proved, failed, or learned.  It is not a polished manuscript
section; middle agents should fold stable claims into
the ABEIS technical report directory only when the claims are supported by
Lean declarations, source anchors, or explicit obligations.

## Article-facing delta

{article_delta_markdown(task_id)}

## Lean status signal

{sorry_text}

## Plain-language status for readers

{task_plain_language_status_en(task_id)}

## Current construction status

{task_article_status_markdown(task_id, run_dir)}

## Pre-Lean verifier candidates

These checks are necessary-condition filters, not proofs.  They are useful
because a failing exact finite check usually means the Lean target, circuit
transcript, or index map is wrong.  A passing check only means the candidate
survived this cheaper test; the final claim still needs a Lean theorem.

{prelean_verifier_table_en(task_id)}

## Current proof-DAG frontier

{dynamic_text}

## Open obligation signal

{obligation_text}

## {contribution_obligation_heading(task_id)}

{open_ghl_text}

## {cited_contract_heading(task_id)}

{open_technical_text}

## Recent typed verifier feedback

{feedback_text}

## Recent proof-attempt memory

{attempts_text}

## Suggested project-paper edits

{suggested_project_paper_edits_markdown(task_id)}

## Do not claim

{do_not_claim_markdown(task_id)}

## Dialogue tail

```text
{dialogue_tail}
```

## Current changed files

{changed_text}
"""


def article_status_plain(value: object) -> str:
    """Normalize generated proof status text for inclusion in the public report."""
    text = str(value)
    text = re.sub(
        r"\bmain\.tex:[0-9]+(?:-[0-9]+)?\b",
        "the source-paper TeX passage",
        text,
    )
    text = re.sub(
        r"\bGHL2025\s+main\.tex\s+lines?\s+[0-9,\-\sand]+",
        "the paper-benchmark source theorem and definition passages",
        text,
    )
    text = re.sub(
        r"\bmain\.tex\s+lines?\s+[0-9,\-\sand]+",
        "the source-paper theorem and definition passages",
        text,
    )
    text = re.sub(
        r"\blocal source anchors?\s+the source-paper TeX passage(?:,\s*[0-9]+(?:-[0-9]+)?)*",
        "source-paper anchors",
        text,
        flags=re.I,
    )
    replacements = [
        ("GHL Fig.", "the paper-benchmark figure"),
        ("GHL one-term", "the paper-benchmark one-term"),
        ("GHL-style", "paper-benchmark-style"),
        ("Guseynov--Huang--Liu", "the GHL2025 paper-benchmark track"),
    ]
    for old, new in replacements:
        text = text.replace(old, new)
    text = text.replace("the the GHL2025 paper-benchmark track", "the GHL2025 paper-benchmark track")
    return text


def project_article_public_markdown(markdown: str) -> str:
    """Normalize the mirrored Markdown copy that lives beside the public report."""
    return article_status_plain(markdown)


def latest_run_summary_path(run_dir: Path) -> Path | None:
    candidates = [
        run_dir / "summary.md",
        run_dir / "zh_summary.md",
    ]
    candidates.extend(sorted(run_dir.glob("summary.*.md")))
    for path in candidates:
        if path.exists():
            return path
    return None


def task_article_status_markdown(task_id: str, run_dir: Path) -> str:
    """Short latest-only manuscript status for the current task."""
    title, task_text = task_context(task_id)
    population_path = ROOT / "candidate-populations" / f"{task_id}.md"
    summary_path = latest_run_summary_path(run_dir)
    lines = [
        f"### Current construction status: `{task_id}`",
        "",
        f"Task title: {title}",
        "",
    ]
    if task_id == "QBE-OP-OPTCTRL-001" or "evolvedEqFlipCost" in task_text:
        lines.extend(
            [
                "Current concrete logical BE certificate: `OptimalControl.evolvedEqFlipVerified`.",
                "",
                "- Target: concrete `E_1 = |0><1|_time ⊗ |0><1|_type ⊗ I_state` with one time bit, one type bit, one passive state bit, and one block-encoding auxiliary bit.",
                "- Lean certificates: `evolvedEqFlipVerified`, `evolvedEqFlipUnitary_isRationalOrthogonal`, `evolvedEqFlipUnitary_cleanBlock`, `evolvedEqFlipGateImages_eval`, `evolvedEqFlipCandidate_cost`, and `exampleOperator_not_rationalOrthogonal`.",
                "- Certified logical record fields: `depth = 2`, `gateCount = 4`, `auxiliaryQubits = 1`, `oracleCalls = 0`; comparison tuple `(gateCount, depth, auxiliaryQubits, oracleCalls) = (4, 2, 1, 0)` in the concrete `{X,CNOT,Toffoli}` logical reversible permutation-matrix tier.",
                "- Finite verifier convergence signal: exact enumeration of the reduced three-bit `{X,CNOT,Toffoli}` orientation library found no clean-block candidate with at most 3 gates and no depth-1 layered candidate with at most 4 gates; the depth-2 witness matches `evolvedEqFlipVerified`.",
                "- Scope: finite-verifier-converged for this concrete `r=1,k=1` logical-library instance, with the zero-auxiliary whole-matrix obstruction closed; not yet generalized to arbitrary time width/state dimension, not hardware-decomposed, and not a Lean-proved depth lower bound.",
                "- Plot policy: plotted points must name rational-orthogonal matrix and clean-block Lean certificates at this semantic tier.",
                "- Next manuscript-facing action: state the concrete certificate and list the generalization, hardware-decomposition, and lower-bound obligations.",
                "",
            ]
        )
    elif task_id == "QBE-OP-CUBIC-STATEPREP-001":
        lines.extend(
            [
                "Current status: Adaptive Scenario 2 benchmark initialized, but no final block-encoding candidate has been promoted.",
                "",
                "- Target interpretation: `O_n = |v_n><0^n|`, with `v_n[j] = (j / 2^n)^3`; this avoids the invalid assumption that the requested vector is already a normalized unitary state-preparation output.",
                "- Lean certificates currently available: target declarations, `cubicOperator_only_first_column`, and exact small norm diagnostics `cubicNormSq_n1`, `cubicNormSq_n2`, `cubicNormSq_n3`.",
                "- Active frontier: candidate interface `CUBIC-CAND-001` runs in parallel with `CUBIC-NORM-001` or direct `CUBIC-ALPHA-001`; clean projector, approximate error budget, finite candidate verifier, and resource theorem follow the first named `U_n`.",
                "- Plot policy: cubic may show diagnostic scaling rows, but it must not show an achieved exact/approximate BE curve until a Lean-certified candidate exists.",
                "- External finite comparison: NumPy dense completion passed for `n = 1..6`, Qiskit `Operator` passed for `n = 1..4`, and Qiskit-QuantumKatas-style evaluator passed for `n = 3`; these rows are fixed small-`n` executable evidence, not symbolic family certificates.",
                "",
            ]
        )
    elif population_path.exists():
        lines.extend(
            [
                f"Candidate population exists at `{rel(population_path)}`.",
                "The generated report should describe only the current champion and open obligations, not the full population history.",
                "",
            ]
        )
    else:
        lines.extend([plain_language_status_en(), ""])
    if summary_path:
        lines.append(f"Latest human-readable cycle summary in the project run artifacts: `{rel(summary_path)}`.")
    if population_path.exists():
        lines.append(f"Candidate population ledger in the project repository: `{rel(population_path)}`.")
    return "\n".join(lines)


def task_article_status_latex(task_id: str, run_dir: Path) -> str:
    """LaTeX version of the latest-only task status for Overleaf."""
    title, task_text = task_context(task_id)
    summary_path = latest_run_summary_path(run_dir)
    population_path = ROOT / "candidate-populations" / f"{task_id}.md"
    if task_id == "QBE-OP-OPTCTRL-001" or "evolvedEqFlipCost" in task_text:
        items = [
            "Current concrete logical BE certificate: \\texttt{OptimalControl.evolvedEqFlipVerified}.",
            "Target: concrete \\(E_1=|0\\rangle\\langle 1|_{time}\\otimes |0\\rangle\\langle 1|_{type}\\otimes I_{state}\\) with one time bit, one type bit, one passive state bit, and one block-encoding auxiliary bit.",
            "Lean certificates: \\texttt{evolvedEqFlipVerified}, \\texttt{evolvedEqFlipUnitary\\_isRationalOrthogonal}, \\texttt{evolvedEqFlipUnitary\\_cleanBlock}, \\texttt{evolvedEqFlipGateImages\\_eval}, \\texttt{evolvedEqFlipCandidate\\_cost}, and \\texttt{exampleOperator\\_not\\_rationalOrthogonal}.",
            "Certified logical record fields: \\(\\mathrm{depth}=2\\), \\(\\mathrm{gateCount}=4\\), \\(\\mathrm{auxiliaryQubits}=1\\), \\(\\mathrm{oracleCalls}=0\\); comparison tuple \\((\\mathrm{gateCount},\\mathrm{depth},\\mathrm{auxiliaryQubits},\\mathrm{oracleCalls})=(4,2,1,0)\\) in the concrete \\(\\{X,\\mathrm{CNOT},\\mathrm{Toffoli}\\}\\) logical reversible permutation-matrix tier.",
            "Finite verifier convergence signal: exact enumeration of the reduced three-bit \\(\\{X,\\mathrm{CNOT},\\mathrm{Toffoli}\\}\\) orientation library found no clean-block candidate with at most three gates and no depth-one layered candidate with at most four gates; the depth-two witness matches \\texttt{evolvedEqFlipVerified}.",
            "Scope: finite-verifier-converged for this concrete \\(r=1,k=1\\) logical-library instance, with the zero-auxiliary whole-matrix obstruction closed; arbitrary-register generalization, hardware decomposition, and Lean-proved depth lower bounds remain open.",
            "Plot policy: plotted points must name rational-orthogonal matrix and clean-block Lean certificates at this semantic tier.",
            "Manuscript rule: present this as the current concrete certificate, not as a general-family or hardware-optimality theorem.",
        ]
    elif task_id == "QBE-OP-CUBIC-STATEPREP-001":
        items = [
            "Adaptive Scenario 2 benchmark initialized, but no final block-encoding candidate has been promoted.",
            "Target interpretation: \\(O_n=|v_n\\rangle\\langle 0^n|\\), with \\((v_n)_j=(j/2^n)^3\\).  This avoids treating the requested unnormalized vector as a unitary state-preparation output.",
            "Compiled Lean surface: target declarations, \\texttt{cubicOperator\\_only\\_first\\_column}, and small exact norm diagnostics \\texttt{cubicNormSq\\_n1}, \\texttt{cubicNormSq\\_n2}, and \\texttt{cubicNormSq\\_n3}.",
            "Active frontier: candidate interface \\texttt{CUBIC-CAND-001} runs in parallel with \\texttt{CUBIC-NORM-001} or direct \\texttt{CUBIC-ALPHA-001}; the clean projector, approximate error budget, finite candidate verifier, and resource theorem follow the first named \\(U_n\\).",
            "Plot policy: diagnostic scaling rows are allowed, but no achieved exact/approximate BE curve should be shown until a Lean-certified candidate exists.",
            "External finite comparison: NumPy dense completion passed for \\(n=1,\\ldots,6\\), Qiskit \\texttt{Operator} passed for \\(n=1,\\ldots,4\\), and a Qiskit-QuantumKatas-style evaluator passed for \\(n=3\\).  These rows are fixed small-\\(n\\) executable evidence, not symbolic family certificates.",
        ]
    elif population_path.exists():
        items = [
            "A candidate population ledger exists for this task.",
            "This generated appendix should summarize only the current champion and open obligations, not the full search history.",
        ]
    else:
        items = [latex_escape(plain_language_status_en())]
    if summary_path:
        items.append("Latest human-readable summary exists in the project run artifacts.")
    if population_path.exists():
        items.append("Candidate ledger exists in the main ABEIS repository.")
    item_text = "\n".join(f"  \\item {item}" for item in items)
    return f"""\\paragraph{{Current construction status for \\texttt{{{latex_escape(task_id)}}}.}}
Task title: {latex_escape(title)}.
\\begin{{itemize}}
{item_text}
\\end{{itemize}}
"""


def project_article_update_latex(task_id: str, cycle: int, run_dir: Path) -> str:
    state = blueprint_status_state(task_id)
    memory = memory_snapshot_state(task_id, cycle, run_dir)
    sorry_lines = lean_sorry_lines(limit=4)
    dynamic = state.get("dynamic_leaf_queue", [])
    obligations = state.get("open_obligation_signals", [])
    if sorry_lines:
        if task_id == "QBE-OP-OPTCTRL-001":
            sorry_items = "\n".join(
                ["  \\item The current transfer-operator certificate is carried by named declarations in \\texttt{QuantumBlockEncoding/OptimalControl.lean}; the repository-wide scan below reports unrelated paper-benchmark warnings."]
                + [f"  \\item Repository-wide warning: \\texttt{{{latex_escape(line)}}}" for line in sorry_lines]
            )
        else:
            sorry_items = "\n".join(f"  \\item \\texttt{{{latex_escape(line)}}}" for line in sorry_lines)
    else:
        sorry_items = "  \\item No \\texttt{sorry} was detected by the project scan."
    dynamic_items = "\n".join(
        f"  \\item {latex_escape(article_status_plain(item))}" for item in dynamic[:2]
    ) or "  \\item No dynamic proof leaf was detected; the next cycle should refresh the proof blueprint."
    obligation_items = "\n".join(
        f"  \\item {latex_escape(article_status_plain(item))}" for item in obligations[:3]
    ) or "  \\item No compact obligation signal was detected; inspect the proof-obligation ledger directly."
    open_ghl_rows = memory.get("open_ghl_contribution_obligations", [])
    if not is_ghl_case_task(task_id):
        open_ghl_items = "  \\item Not applicable to this task."
    elif isinstance(open_ghl_rows, list) and open_ghl_rows:
        open_ghl_items = "\n".join(
            "  \\item \\texttt{%s}: %s; status %s."
            % (
                latex_escape(row.get("id", "")),
                latex_escape(article_status_plain(row.get("english_object", row.get("paper_object", "")))),
                latex_escape(article_status_plain(row.get("english_status", row.get("lean_status", "")))),
            )
            for row in open_ghl_rows[:4]
        )
    else:
        open_ghl_items = "  \\item No open paper-benchmark contribution obligation was detected."
    open_technical_rows = memory.get("open_external_technical_lemma_obligations", [])
    if not is_ghl_case_task(task_id):
        open_technical_items = "  \\item No task-specific cited-contract obligation was detected by the compact memory layer."
    elif isinstance(open_technical_rows, list) and open_technical_rows:
        open_technical_items = "\n".join(
            "  \\item \\texttt{%s}: %s; next action %s."
            % (
                latex_escape(row.get("id", "")),
                latex_escape(article_status_plain(row.get("lean_status", ""))),
                latex_escape(article_status_plain(row.get("next_action", ""))),
            )
            for row in open_technical_rows[:3]
        )
    else:
        open_technical_items = "  \\item No open external technical lemma obligation was detected."
    feedback_rows = memory.get("recent_verifier_feedback", [])
    if isinstance(feedback_rows, list) and feedback_rows:
        feedback_items = "\n".join(
            "  \\item Leaf \\texttt{%s}, class \\texttt{%s}; next route: %s."
            % (
                latex_escape(row.get("leaf", "")),
                latex_escape(row.get("error_class", "")),
                latex_escape(article_status_plain(prose_value(row.get("next_route", "")))),
            )
            for row in feedback_rows[:2]
        )
    else:
        feedback_items = "  \\item No typed verifier-feedback packet was detected."
    return f"""% Auto-generated by tools/qbe.py project-article-update.
% Do not edit this file by hand; edit the proof artifacts or article sections instead.

\\section{{Current Cycle Status}}
\\label{{app:generated-cycle-status}}

This appendix is intentionally short.  The full run logs, preferred-language summaries,
and ChatGPT Pro prompts stay in the repository; the Overleaf report includes
only the compact status needed to keep the manuscript honest and fast to
compile.

\\paragraph{{Latest cycle.}}
\\texttt{{{latex_escape(task_id)}}}, cycle \\texttt{{{cycle}}};
generated at \\texttt{{{latex_escape(now_stamp())}}}.

\\paragraph{{Lean gate signal.}}
\\begin{{itemize}}
{sorry_items}
\\end{{itemize}}

\\paragraph{{Plain-language status for this case study.}}
{latex_escape(task_plain_language_status_en(task_id))}

{task_article_status_latex(task_id, run_dir)}

\\paragraph{{Current proof-DAG frontier.}}
\\begin{{itemize}}
{dynamic_items}
\\end{{itemize}}

\\paragraph{{{latex_escape(contribution_obligation_heading(task_id))}.}}
\\begin{{itemize}}
{open_ghl_items}
\\end{{itemize}}

\\paragraph{{{latex_escape(cited_contract_heading(task_id))}.}}
\\begin{{itemize}}
{open_technical_items}
\\end{{itemize}}

\\paragraph{{Recent verifier feedback.}}
\\begin{{itemize}}
{feedback_items}
\\end{{itemize}}

\\paragraph{{Manuscript rule.}}
{manuscript_rule_latex(task_id)}
"""


def problem_specific_latex_export(task_id: str, cycle: int, run_dir: Path) -> str:
    """Return a user-paper-facing LaTeX proof note for the active problem.

    This is intentionally different from the technical-report update.  It is a
    compact, copyable theorem/proof note for the mathematical problem being
    solved.  It should not contain raw logs or local absolute paths.
    """
    title, task_text = task_context(task_id)
    generated = latex_escape(now_stamp())
    if task_id == "QBE-OP-OPTCTRL-001" or "evolvedEqFlipCost" in task_text:
        return f"""% Auto-generated by tools/qbe.py problem-latex-export.
% Problem-specific proof note for copying into a user manuscript.
% Generated: {generated}.  Task: {latex_escape(task_id)}.
% Requires ordinary amsmath/amssymb notation.  The Lean declaration names are
% included as audit anchors and may be removed from a polished paper draft.

\\subsection{{A concrete block encoding of the transfer operator}}

Let \\(T\\) be a one-qubit time register, let \\(\\tau\\) be a one-qubit type
register, and let \\(S\\) be a one-qubit passive state register.  For the
concrete case \\(k=1\\), define
\\[
  E_1
  =
  |0\\rangle\\langle 1|_T
  \\otimes
  |0\\rangle\\langle 1|_\\tau
  \\otimes I_S .
\\]
The operator \\(E_1\\) is a partial isometry and is not itself a unitary on the
system register.  In the ABEIS Lean development this non-unitarity obstruction
is recorded by \\texttt{{OptimalControl.exampleOperator\\_not\\_rationalOrthogonal}}.

Add one block-encoding auxiliary qubit \\(a\\), initialized and projected in
\\(|0\\rangle_a\\).  We use computational-basis states
\\(|a,t,b,s\\rangle\\), where \\(t,b,a\\in\\{{0,1\\}}\\) and
\\(s\\in\\{{0,1\\}}\\).  Consider the logical reversible circuit
\\[
  U_{{\\mathrm{{evo}}}}
  =
  \\bigl(X_a X_T X_\\tau\\bigr)
  \\;\\mathrm{{CCX}}_{{\\tau,T\\to a}},
\\]
where the three \\(X\\) gates act on disjoint qubits and hence form one
parallel layer after the Toffoli layer.  The state register \\(S\\) is untouched.

\\paragraph{{Theorem.}}
The circuit \\(U_{{\\mathrm{{evo}}}}\\) is an exact one-ancilla block encoding of
\\(E_1\\):
\\[
  (\\langle 0|_a\\otimes I_{{T\\tau S}})
  U_{{\\mathrm{{evo}}}}
  (|0\\rangle_a\\otimes I_{{T\\tau S}})
  =
  E_1 .
\\]
In the logical gate library \\(\\{{X,\\mathrm{{CNOT}},\\mathrm{{Toffoli}}\\}}\\),
its certified score is
\\[
  (\\mathrm{{gateCount}},\\mathrm{{depth}},\\mathrm{{auxiliaryQubits}},
  \\mathrm{{oracleCalls}})
  =
  (4,2,1,0).
\\]
Equivalently, it is also an \\((\\alpha,a,\\varepsilon)=(1,1,0)\\)
approximate block encoding.

\\paragraph{{Proof.}}
We prove the claim on computational basis states; linearity then gives the
matrix identity.  The Toffoli first maps
\\[
  |a,t,b,s\\rangle
  \\longmapsto
  |a\\oplus tb,t,b,s\\rangle .
\\]
The parallel layer \\(X_aX_TX_\\tau\\) then maps this state to
\\[
  |1\\oplus a\\oplus tb,\\;1\\oplus t,\\;1\\oplus b,\\;s\\rangle .
\\]
Thus \\(U_{{\\mathrm{{evo}}}}\\) is unitary, because it is a composition of
reversible elementary gates.  In the finite Lean model this is the rational
orthogonality theorem
\\[
  \\texttt{{OptimalControl.evolvedEqFlipUnitary\\_isRationalOrthogonal}}.
\\]

Now restrict the input auxiliary to the clean value \\(a=0\\).  The above formula
becomes
\\[
  U_{{\\mathrm{{evo}}}}|0,t,b,s\\rangle
  =
  |1\\oplus tb,\\;1\\oplus t,\\;1\\oplus b,\\;s\\rangle .
\\]
Projecting the output auxiliary onto \\(\\langle 0|_a\\) keeps exactly the
branches with \\(1\\oplus tb=0\\), namely \\(t=b=1\\).  The four cases are
\\[
\\begin{{array}}{{c|c|c}}
(t,b) & U_{{\\mathrm{{evo}}}}|0,t,b,s\\rangle
  & (\\langle0|_a\\otimes I)U_{{\\mathrm{{evo}}}}|0,t,b,s\\rangle \\\\
\\hline
(0,0) & |1,1,1,s\\rangle & 0 \\\\
(0,1) & |1,1,0,s\\rangle & 0 \\\\
(1,0) & |1,0,1,s\\rangle & 0 \\\\
(1,1) & |0,0,0,s\\rangle & |0\\rangle_T|0\\rangle_\\tau|s\\rangle_S .
\\end{{array}}
\\]
Therefore the clean block sends \\(|1\\rangle_T|1\\rangle_\\tau|s\\rangle_S\\)
to \\(|0\\rangle_T|0\\rangle_\\tau|s\\rangle_S\\) and sends all other
\\((T,\\tau)\\)-basis branches to zero.  This is exactly
\\[
  |0\\rangle\\langle1|_T\\otimes
  |0\\rangle\\langle1|_\\tau\\otimes I_S
  =
  E_1 .
\\]
The formal Lean certificate proves the same clean-block equality entrywise:
\\[
  \\texttt{{OptimalControl.evolvedEqFlipVerified}},
  \\quad
  \\texttt{{OptimalControl.evolvedEqFlipUnitary\\_cleanBlock}}.
\\]
The resource count is also explicit.  The circuit has one Toffoli gate and
three \\(X\\) gates, hence gate count \\(4\\).  The Toffoli layer must precede
the flips, but the three flips act on disjoint qubits and form one parallel
layer, hence depth \\(2\\).  It uses one block-encoding auxiliary qubit and no
oracle calls.  This resource tuple is certified by
\\[
  \\texttt{{OptimalControl.evolvedEqFlipCandidate\\_cost}}.
\\]

        Finally, the approximate block-encoding statement follows from exactness.
With \\(\\alpha=1\\) and \\(\\varepsilon=0\\), the norm error is zero.  The Lean
project records this zero-error approximate certificate as
\\[
  \\texttt{{OptimalControl.evolvedEqFlipZeroErrorApprox}}.
\\]

\\paragraph{{Finite convergence diagnostic.}}
After correcting the resource order to
\\[
  \\mathrm{{gateCount}}
  \\;>\\;
  \\mathrm{{depth}}
  \\;>\\;
  \\mathrm{{auxiliaryQubits}}
  \\;>\\;
  \\mathrm{{oracleCalls}},
\\]
the ABEIS verifier exhaustively enumerated the reduced three-bit logical gate
library containing all orientations of \\(X\\), CNOT, and Toffoli.  In that
finite library there is no clean-block candidate with at most three gates, no
depth-one layered candidate with at most four gates, and the depth-two witness
with four gates is exactly the construction above.  This is recorded as a
finite verifier result rather than as a Lean lower-bound theorem.

\\paragraph{{Scope.}}
This note proves the concrete \\(r=1,k=1\\) logical reversible
permutation-matrix instance.  It is not a hardware-decomposed resource theorem,
not yet a general arbitrary-register construction, and not a Lean-proved
global optimality theorem.
"""
    if task_id == "QBE-OP-CUBIC-STATEPREP-001":
        return f"""% Auto-generated by tools/qbe.py problem-latex-export.
% Problem-specific proof/status note for copying into a user manuscript.
% Generated: {generated}.  Task: {latex_escape(task_id)}.
% This is a current-status note, not a completed block-encoding theorem.

\\subsection{{Cubic grid state-preparation operator: current formal target}}

Let \\(n\\geq 1\\), let \\(N=2^n\\), and set \\(x_j=j/N\\) for
\\(0\\leq j<N\\).  The user-level target is the operator whose action on the
all-zero basis vector is
\\[
  O_n |0^n\\rangle
  =
  \\sum_{{j=0}}^{{N-1}} x_j^3 |j\\rangle .
\\]
The vector on the right is generally not normalized.  Therefore this is not,
by itself, a unitary state-preparation specification.  ABEIS currently fixes
the Lean-facing target as the rank-one linear operator
\\[
  O_n
  =
  |v_n\\rangle\\langle 0^n|,
  \\qquad
  (v_n)_j = (j/2^n)^3 .
\\]
Equivalently, \\(O_n\\) maps \\(|0^n\\rangle\\) to the requested unnormalized
vector and maps every other computational-basis input to zero.

\\paragraph{{Compiled Lean surface.}}
The current Lean development names the target components as
\\[
\\begin{{array}}{{ll}}
\\texttt{{CubicStatePreparation.gridPoint}} & x_j=j/2^n,\\\\
\\texttt{{CubicStatePreparation.cubicAmplitude}} & x_j^3,\\\\
\\texttt{{CubicStatePreparation.cubicOperator}} & O_n=|v_n\\rangle\\langle 0^n|,\\\\
\\texttt{{CubicStatePreparation.requestedEpsilon}} & 10^{{-10}},\\\\
\\texttt{{CubicStatePreparation.defaultPolicy}} & \\,\\text{{adaptive exact-then-approximate search}},\\\\
\\texttt{{CubicStatePreparation.hardModeUpperAgentSchedule}} & [1,2,3,4],\\\\
\\texttt{{CubicStatePreparation.hardModeMiddleAgentSchedule}} & [1,2,3,4],\\\\
\\texttt{{CubicStatePreparation.hardModeLowerAgentSchedule}} & [3,4,5,6],\\\\
\\texttt{{CubicStatePreparation.hardModeExactStallWindow}} & 1,\\\\
\\texttt{{CubicStatePreparation.hardModeConstructionStallWindow}} & 1,\\\\
\\texttt{{CubicStatePreparation.hardModeLevelCycleBudget}} & [1,1,1,1],\\\\
\\texttt{{CubicStatePreparation.relaxedEpsilonLadder}} & [10^{{-10}},10^{{-9}},10^{{-8}},10^{{-7}},10^{{-6}}].
\\end{{array}}
\\]
Small exact norm diagnostics for \\(n=1,2,3\\) also compile:
\\[
  \\texttt{{cubicNormSq\\_n1}},\\qquad
  \\texttt{{cubicNormSq\\_n2}},\\qquad
  \\texttt{{cubicNormSq\\_n3}}.
\\]

\\paragraph{{Why the adaptive Scenario 2 branch is triggered.}}
The squared norm that controls any exact or approximate block encoding is
\\[
  \\|v_n\\|^2
  =
  \\sum_{{j=0}}^{{2^n-1}} \\left(\\frac{{j}}{{2^n}}\\right)^6 .
\\]
This norm is not identically one, so any proposed circuit that treats
\\(\\sum_j x_j^3|j\\rangle\\) as a normalized unitary output is rejected.  A
block encoding must instead state a normalizer \\(\\alpha\\), a clean-block
projector, an auxiliary register layout, and an error budget.

\\paragraph{{Finite executable verifier baseline.}}
ABEIS also ran the same cubic target through local finite executable
baselines.  NumPy dense completion passed for \\(n=1,\\ldots,6\\), Qiskit
\\texttt{{Operator}} verification passed for \\(n=1,\\ldots,4\\), and a
Qiskit-QuantumKatas-style evaluator passed for \\(n=3\\).  These checks
construct a finite dense one-auxiliary-qubit unitary whose clean block equals
\\(O_n/\\|v_n\\|\\) for the chosen small \\(n\\).  They are valid fixed-instance
executable checks, but they materialize dense matrices and are not symbolic family
certificates.

\\paragraph{{Current open obligations.}}
No final candidate unitary \\(U_n\\) has been promoted yet.  The current proof
DAG is:
\\[
\\begin{{array}}{{ll}}
\\text{{CUBIC-NORM-001}} & \\text{{prove a closed norm formula or a sufficient normalizer bound}},\\\\
\\text{{CUBIC-ALPHA-001}} & \\text{{connect the chosen normalizer to }} \\|O_n\\|,\\\\
\\text{{CUBIC-ERR-001}} & \\text{{split the }}10^{{-10}}\\text{{ tolerance across arithmetic and synthesis error}},\\\\
\\text{{CUBIC-CAND-001}} & \\text{{state and prove a concrete approximate }}U_n\\text{{ candidate.}}
\\end{{array}}
\\]
The existing dense executable diagnostics are useful fixed-instance executable checks, but they are
not block-encoding certificates.  In particular, a dense one-auxiliary unitary
matrix for this target already reaches terabyte-scale memory in the diagnostic
range, so the intended successful route is a symbolic arithmetic family proved
in Lean.

\\paragraph{{Current manuscript-safe claim.}}
At the current status, it is safe to claim only that ABEIS has parsed the user
target into a Lean-checkable rank-one operator, detected the normalization
obstruction, initialized Scenario~2 approximate-search obligations, and
recorded necessary-condition diagnostics.  It is not yet safe to claim a
completed exact block encoding, a completed approximate block encoding, or a
strictly better final circuit than external systems for this cubic benchmark.
"""
    status = task_article_status_latex(task_id, run_dir)
    return f"""% Auto-generated by tools/qbe.py problem-latex-export.
% Problem-specific proof/status note for copying into a user manuscript.
% Generated: {generated}.  Task: {latex_escape(task_id)}.

\\subsection{{Problem-specific proof note: \\texttt{{{latex_escape(task_id)}}}}}

Task title: {latex_escape(title)}.

{status}

\\paragraph{{Use in a manuscript.}}
This export is a problem-facing proof/status note, not a full technical-report
section.  Copy only claims whose Lean declarations are named above.  Claims
listed as obligations, cited contracts, diagnostics, or insight-pool proposals
should remain assumptions or future work until a Lean certificate promotes
them.
"""


def write_problem_latex_export(
    task_id: str,
    cycle: int,
    run_dir: Path,
    article_root: Path | None = None,
) -> tuple[Path, Path, Path, list[Path]]:
    latex = problem_specific_latex_export(task_id, cycle, run_dir)
    task_slug = slugify(task_id)
    export_dir = PROBLEM_EXPORT_DIR / task_slug
    run_tex = run_dir / "problem_export.tex"
    archive_tex = export_dir / f"{run_dir.name}.tex"
    latest_tex = export_dir / "latest.tex"
    write_text(run_tex, latex)
    write_text(archive_tex, latex)
    write_text(latest_tex, latex)
    add_manifest("qbe.py problem-latex-export", run_tex, "article", f"Wrote problem-specific LaTeX export for {task_id} cycle {cycle}")
    add_manifest("qbe.py problem-latex-export", archive_tex, "article", f"Archived problem-specific LaTeX export for {task_id} cycle {cycle}")
    external_written: list[Path] = []
    target_root = article_root
    if target_root and target_root.exists():
        ext_tex = target_root / "problem_exports" / f"{task_slug}.tex"
        write_text(ext_tex, latex)
        add_manifest("qbe.py problem-latex-export", ext_tex, "article", "Mirrored latest problem-specific LaTeX export")
        external_written.append(ext_tex)
    return run_tex, archive_tex, latest_tex, external_written


def write_project_article_update(
    task_id: str,
    cycle: int,
    run_dir: Path,
    article_root: Path | None = None,
) -> tuple[Path, Path, Path, Path, list[Path], tuple[Path, Path, Path, list[Path]]]:
    markdown = project_article_update_markdown(task_id, cycle, run_dir)
    latex = project_article_update_latex(task_id, cycle, run_dir)
    run_md = run_dir / "article_update.md"
    run_tex = run_dir / "article_update.tex"
    archive_md = PROJECT_ARTICLE_UPDATE_DIR / f"{run_dir.name}.md"
    archive_tex = PROJECT_ARTICLE_UPDATE_DIR / f"{run_dir.name}.tex"
    latest_md = PROJECT_ARTICLE_UPDATE_DIR / "latest.md"
    latest_tex = PROJECT_ARTICLE_UPDATE_DIR / "latest.tex"
    write_text(run_md, markdown)
    write_text(run_tex, latex)
    write_text(archive_md, markdown)
    write_text(archive_tex, latex)
    write_text(latest_md, markdown)
    write_text(latest_tex, latex)
    add_manifest("qbe.py project-article-update", run_md, "article", f"Wrote project article update for {task_id} cycle {cycle}")
    add_manifest("qbe.py project-article-update", archive_md, "article", f"Archived project article update for {task_id} cycle {cycle}")
    external_written: list[Path] = []
    target_root = article_root or PROJECT_ARTICLE_ROOT
    if target_root and (target_root / "main.tex").exists():
        ext_tex = target_root / "appendix" / "generated_cycle_status.tex"
        ext_md = target_root / "appendix" / "generated_cycle_status.md"
        write_text(ext_tex, latex)
        write_text(ext_md, project_article_public_markdown(markdown))
        add_manifest("qbe.py project-article-update", ext_tex, "article", "Mirrored latest generated status into the ABEIS technical report")
        external_written.extend([ext_tex, ext_md])
    problem_export = write_problem_latex_export(task_id, cycle, run_dir, target_root)
    return run_md, archive_md, run_tex, archive_tex, external_written, problem_export


def write_sleep_closeout_export(args: argparse.Namespace, cycle: int, run_dir: Path) -> None:
    """Write closeout LaTeX artifacts for a sleep-run cycle.

    Public users get the problem-specific proof note by default.  The ABEIS
    project-paper update is maintainer infrastructure and is written only when
    explicitly requested.
    """
    write_human_status(args.id, run_dir, getattr(args, "report_language", None))
    if args.project_article_update or args.article_update_each_cycle:
        write_project_article_update(args.id, cycle, run_dir)
    else:
        write_problem_latex_export(args.id, cycle, run_dir)


def validate_candidate_metrics(task_id: str) -> tuple[bool, list[str]]:
    path = ROOT / "candidate-populations" / f"{task_id}-metrics.csv"
    if not path.exists():
        return True, [f"no metrics CSV found for {task_id}; skipping candidate-curve validation"]
    errors: list[str] = []
    with path.open(newline="", encoding="utf-8") as handle:
        rows = list(csv.DictReader(handle))
    required = {"generation", "tier", "champion_id", "lean_certificates"}
    missing = required - set(rows[0].keys() if rows else [])
    if missing:
        errors.append(f"{rel(path)} missing required columns: {', '.join(sorted(missing))}")
    for i, row in enumerate(rows, start=2):
        tier = str(row.get("tier", ""))
        if tier in {"oracle-baseline", "final-be-status", "status"}:
            continue
        champion = str(row.get("champion_id", "")).strip()
        certs = str(row.get("lean_certificates", "")).strip()
        if not champion:
            errors.append(f"{rel(path)} row {i}: plotted non-oracle row has no champion_id")
        if not certs:
            errors.append(f"{rel(path)} row {i}: plotted non-oracle row has no Lean certificates")
        certs_lower = certs.lower()
        verifier_only_markers = [
            "python",
            "finite verifier",
            "simulator",
            "insight",
            "proposal",
            "search signal",
            "rank signal",
        ]
        if any(marker in certs_lower for marker in verifier_only_markers):
            errors.append(f"{rel(path)} row {i}: verifier-only text appears in Lean certificate field")
    if errors:
        return False, errors
    return True, [f"candidate metrics validated: {rel(path)}"]


def cmd_project_article_update(args: argparse.Namespace) -> int:
    run_dir = resolve_run_dir_arg(args.run_id)
    cycle = resolved_cycle(args.cycle, run_dir)
    article_root = Path(args.article_root).expanduser() if args.article_root else None
    run_md, archive_md, run_tex, archive_tex, external, problem_export = write_project_article_update(
        args.id,
        cycle,
        run_dir,
        article_root,
    )
    problem_run_tex, problem_archive_tex, problem_latest_tex, problem_external = problem_export
    print(f"article-update: {display_path(run_md)}")
    print(f"article-update-archive: {display_path(archive_md)}")
    print(f"article-update-tex: {display_path(run_tex)}")
    print(f"article-update-tex-archive: {display_path(archive_tex)}")
    for path in external:
        print(f"article-update-external: {display_path(path)}")
    print(f"problem-export-tex: {display_path(problem_run_tex)}")
    print(f"problem-export-archive: {display_path(problem_archive_tex)}")
    print(f"problem-export-latest: {display_path(problem_latest_tex)}")
    for path in problem_external:
        print(f"problem-export-external: {display_path(path)}")
    return 0


def cmd_problem_latex_export(args: argparse.Namespace) -> int:
    run_dir = resolve_run_dir_arg(args.run_id)
    cycle = resolved_cycle(args.cycle, run_dir)
    article_root = Path(args.article_root).expanduser() if args.article_root else None
    run_tex, archive_tex, latest_tex, external = write_problem_latex_export(
        args.id,
        cycle,
        run_dir,
        article_root,
    )
    print(f"problem-export-tex: {display_path(run_tex)}")
    print(f"problem-export-archive: {display_path(archive_tex)}")
    print(f"problem-export-latest: {display_path(latest_tex)}")
    for path in external:
        print(f"problem-export-external: {display_path(path)}")
    return 0


def cmd_manual_cycle_closeout(args: argparse.Namespace) -> int:
    """Close out a manual/chat-window multi-agent cycle with report sync."""
    cmd_init(argparse.Namespace())
    run_dir = resolve_run_dir_arg(args.run_id, prefer_manual=args.run_id == "latest")
    cycle = resolved_cycle(args.cycle, run_dir)
    if args.id == "QBE-OP-OPTCTRL-001":
        write_optctrl_convergence_summaries(run_dir)
    summary_path = latest_run_summary_path(run_dir)
    if summary_path is None:
        print(
            "warning: no zh_summary.md or summary.md found in "
            f"{display_path(run_dir)}; write a human-readable summary before publishing this cycle"
        )
    metrics_ok, metrics_messages = validate_candidate_metrics(args.id)
    for message in metrics_messages:
        print(("candidate-metrics-ok: " if metrics_ok else "candidate-metrics-error: ") + message)
    if not metrics_ok:
        return 1
    digest_path, todo_path, index_path = write_memory_refresh(args.id, cycle, run_dir)
    article_root = Path(args.article_root).expanduser() if args.article_root else None
    if args.project_article_update:
        run_md, archive_md, run_tex, archive_tex, external, problem_export = write_project_article_update(
            args.id,
            cycle,
            run_dir,
            article_root,
        )
        problem_run_tex, problem_archive_tex, problem_latest_tex, problem_external = problem_export
    else:
        run_md = archive_md = run_tex = archive_tex = None
        external = []
        problem_run_tex, problem_archive_tex, problem_latest_tex, problem_external = write_problem_latex_export(
            args.id,
            cycle,
            run_dir,
        )
    print(f"manual-closeout-run: {display_path(run_dir)}")
    if summary_path:
        print(f"manual-closeout-summary: {display_path(summary_path)}")
    print(f"manual-closeout-memory: {display_path(digest_path)}")
    print(f"manual-closeout-todo: {display_path(todo_path)}")
    print(f"manual-closeout-index: {display_path(index_path)}")
    if run_md and run_tex:
        print(f"manual-closeout-article: {display_path(run_md)}")
        print(f"manual-closeout-article-tex: {display_path(run_tex)}")
    print(f"manual-closeout-problem-tex: {display_path(problem_run_tex)}")
    print(f"manual-closeout-problem-latest: {display_path(problem_latest_tex)}")
    for path in external:
        print(f"manual-closeout-overleaf: {display_path(path)}")
    for path in problem_external:
        print(f"manual-closeout-problem-overleaf: {display_path(path)}")
    if args.project_article_update and not external:
        print("warning: no external technical-report appendix was written; check --article-root")
    return 0


def cmd_validate_candidate_metrics(args: argparse.Namespace) -> int:
    ok, messages = validate_candidate_metrics(args.id)
    for message in messages:
        print(message)
    return 0 if ok else 1


def cmd_cycle_zh_summary(args: argparse.Namespace) -> int:
    args.language = "zh"
    return cmd_cycle_summary(args)


def cmd_cycle_summary(args: argparse.Namespace) -> int:
    if args.run_id == "latest":
        run_dir = latest_run_dir()
        if run_dir is None:
            raise SystemExit("no run directories found")
    else:
        run_dir = ROOT / "runs" / args.run_id
    if not run_dir.exists():
        raise SystemExit(f"run directory not found: {rel(run_dir)}")
    cycle = resolved_cycle(args.cycle, run_dir)
    language = getattr(args, "language", None)
    run_path, archive_path = write_cycle_summary(args.id, cycle, run_dir, language)
    print(f"summary: {display_path(run_path)}")
    print(f"summary-archive: {display_path(archive_path)}")
    return 0


def write_trial_summary(records: list[dict]) -> list[dict]:
    rows = []
    cumulative_by_task: dict[str, int] = {}
    compiled_by_task: dict[str, int] = {}
    for index, record in enumerate(records, start=1):
        task_id = str(record.get("task_id", "unknown"))
        cumulative_by_task[task_id] = cumulative_by_task.get(task_id, 0) + 1
        if record.get("status") == "compiled" or record.get("lean_gate") == "pass":
            compiled_by_task[task_id] = compiled_by_task.get(task_id, 0) + 1
        feedback = record.get("verifier_feedback", {})
        if not isinstance(feedback, dict):
            feedback = {}
        rows.append(
            {
                "index": index,
                "timestamp": record.get("timestamp", ""),
                "trial_id": record.get("trial_id", ""),
                "task_id": task_id,
                "role": record.get("role", ""),
                "kind": record.get("kind", ""),
                "status": record.get("status", ""),
                "score": record.get("score", ""),
                "lean_gate": record.get("lean_gate", ""),
                "artifact": record.get("artifact", ""),
                "changed_files": ";".join(record.get("changed_files", [])),
                "cumulative_task_trials": cumulative_by_task[task_id],
                "compiled_task_trials": compiled_by_task.get(task_id, 0),
                "feedback_leaf": feedback.get("leaf", ""),
                "feedback_error_class": feedback.get("error_class", ""),
                "source_correspondence_ok": feedback.get("source_correspondence_ok", ""),
                "lean_parse_ok": feedback.get("lean_parse_ok", ""),
                "lean_build_ok": feedback.get("lean_build_ok", ""),
                "finite_matrix_ok": feedback.get("finite_matrix_ok", ""),
                "block_entry_ok": feedback.get("block_entry_ok", ""),
                "ancilla_cleanup_ok": feedback.get("ancilla_cleanup_ok", ""),
                "normalizer_ok": feedback.get("normalizer_ok", ""),
                "closed_theorem_ok": feedback.get("closed_theorem_ok", ""),
                "next_route": feedback.get("next_route", ""),
                "agent_wall_time_s": record.get("harness_metrics", {}).get("agent_wall_time_s", "")
                if isinstance(record.get("harness_metrics", {}), dict)
                else "",
                "prompt_chars": record.get("harness_metrics", {}).get("prompt_chars", "")
                if isinstance(record.get("harness_metrics", {}), dict)
                else "",
                "estimated_input_tokens": record.get("harness_metrics", {}).get("estimated_input_tokens", "")
                if isinstance(record.get("harness_metrics", {}), dict)
                else "",
                "notes": record.get("notes", ""),
            }
        )
    fieldnames = [
            "index",
            "timestamp",
            "trial_id",
            "task_id",
            "role",
            "kind",
            "status",
            "score",
            "lean_gate",
            "artifact",
            "changed_files",
            "cumulative_task_trials",
            "compiled_task_trials",
            "feedback_leaf",
            "feedback_error_class",
            "source_correspondence_ok",
            "lean_parse_ok",
            "lean_build_ok",
            "finite_matrix_ok",
            "block_entry_ok",
            "ancilla_cleanup_ok",
            "normalizer_ok",
            "closed_theorem_ok",
            "next_route",
            "agent_wall_time_s",
            "prompt_chars",
            "estimated_input_tokens",
            "notes",
    ]
    handle = io.StringIO(newline="")
    try:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)
        atomic_write_text(TRIAL_SUMMARY, handle.getvalue())
    finally:
        handle.close()
    return rows


def refresh_trial_summary_if_bounded(max_log_bytes: int = 16 * 1024 * 1024) -> list[dict] | None:
    """Avoid replaying a large historical log during every inner-cycle write."""

    if TRIAL_LOG.exists() and TRIAL_LOG.stat().st_size > max_log_bytes:
        print(
            f"deferred full trial-summary rewrite: {TRIAL_LOG.stat().st_size} bytes; "
            "run `python3 tools/qbe.py trial-summary` explicitly at closeout"
        )
        return None
    return write_trial_summary(load_jsonl(TRIAL_LOG))


def cmd_trial_log(args: argparse.Namespace) -> int:
    cmd_init(argparse.Namespace())
    changed = list(args.changed_file or [])
    if args.from_git:
        changed.extend(git_changed_files())
    trial_id = args.trial_id or f"{file_stamp()}-{slugify(args.task)}-{args.role}-{args.kind}"
    verifier_feedback = load_feedback_payload(args)
    record = {
        "timestamp": now_stamp(),
        "trial_id": trial_id,
        "task_id": args.task,
        "role": args.role,
        "kind": args.kind,
        "status": args.status,
        "score": args.score,
        "lean_gate": args.lean_gate,
        "artifact": args.artifact or "",
        "changed_files": sorted(set(changed)),
        "command": args.command or "",
        "notes": args.notes or "",
    }
    if verifier_feedback:
        record["verifier_feedback"] = verifier_feedback
    append_jsonl(TRIAL_LOG, record)
    rows = refresh_trial_summary_if_bounded()
    add_manifest("qbe.py trial-log", TRIAL_LOG, "trial", f"Logged {trial_id}")
    print(f"logged {trial_id}")
    if rows is not None:
        print(f"summary rows: {len(rows)} -> {rel(TRIAL_SUMMARY)}")
    else:
        print("summary rewrite deferred to explicit closeout")
    return 0


def cmd_trial_summary(_: argparse.Namespace) -> int:
    cmd_init(argparse.Namespace())
    records = load_jsonl(TRIAL_LOG)
    rows = write_trial_summary(records)
    if not rows:
        print("no trial records yet")
        return 0
    by_task: dict[str, dict[str, int]] = {}
    for row in rows:
        item = by_task.setdefault(str(row["task_id"]), {"total": 0, "compiled": 0, "failed": 0, "blocked": 0})
        item["total"] += 1
        if row["status"] == "compiled" or row["lean_gate"] == "pass":
            item["compiled"] += 1
        if row["status"] == "failed":
            item["failed"] += 1
        if row["status"] == "blocked":
            item["blocked"] += 1
    for task_id, item in sorted(by_task.items()):
        print(
            f"{task_id}: total={item['total']} compiled={item['compiled']} "
            f"failed={item['failed']} blocked={item['blocked']}"
        )
    print(f"wrote {rel(TRIAL_SUMMARY)}")
    return 0


def task_context(task_id: str) -> tuple[str, str]:
    task_path = ROOT / "tasks" / f"{slugify(task_id)}.md"
    if task_path.exists():
        text = read_text(task_path)
        return text.splitlines()[0].lstrip("# ").strip(), text
    seeds = {task.get("id"): task for task in parse_seed_tasks()}
    if task_id in seeds:
        seed = seeds[task_id]
        text = (
            "Seed task from Automation.lean\n\n"
            f"Title: {seed.get('title')}\n"
            f"Source: {seed.get('source')}\n"
            f"Target Lean: {seed.get('targetLean')}\n"
        )
        return seed.get("title", task_id), text
    return task_id, "No task file found. Create one with `tools/qbe.py new-task`."


def infer_task_mode(task_text: str) -> str:
    mode_match = re.search(r"^Mode:\s*`?([A-Za-z0-9_-]+)`?", task_text, flags=re.M)
    if mode_match:
        mode = mode_match.group(1)
        if mode in {
            "statePreparation",
            "operatorBlockEncoding",
            "paperBenchmark",
            "faithfulPaper",
            "exploratoryConstruction",
            "unspecified",
        }:
            return mode
    text = task_text.lower()
    faithful_markers = [
        "faithful",
        "paper-reproduction",
        "paper reproduction",
        "not an innovation",
        "do not invent",
        "primary paper target",
    ]
    exploratory_markers = [
        "open problem",
        "exploratory",
        "construction search",
        "new construction",
        "innovation",
        "candidate construction",
    ]
    paper_benchmark_markers = [
        "paperbenchmark",
        "paper benchmark",
        "benchmark case",
        "baseline candidate",
    ]
    operator_markers = [
        "operatorblockencoding",
        "operator-to-block-encoding",
        "operator to block encoding",
        "given operator",
        "given matrix",
        "candidate unitary",
        "u_a",
        "auxiliary qubits",
        "blockencodingcost",
    ]
    state_prep_markers = [
        "statepreparation",
        "state preparation",
        "state-preparation",
        "prepare |psi>",
        "target state",
        "first column",
        "u |0",
        "u|0",
    ]
    if any(marker in text for marker in state_prep_markers):
        return "statePreparation"
    if any(marker in text for marker in operator_markers):
        return "operatorBlockEncoding"
    if any(marker in text for marker in paper_benchmark_markers):
        return "paperBenchmark"
    if any(marker in text for marker in faithful_markers):
        return "faithfulPaper"
    if any(marker in text for marker in exploratory_markers):
        return "exploratoryConstruction"
    return "unspecified"


def infer_evaluation_mode(task_text: str) -> str:
    """Return the declared proof-agent evaluation boundary."""

    match = re.search(
        r"^Evaluation mode:\s*`?([A-Za-z0-9_-]+)`?",
        task_text,
        flags=re.M | re.I,
    )
    if not match:
        return "full-abeis"
    value = match.group(1).lower().replace("_", "-")
    aliases = {
        "task": "task-only",
        "taskonly": "task-only",
        "task-only": "task-only",
        "lad": "lad",
        "library-assisted": "lad",
        "isolated": "isolated-abeis",
        "isolated-abeis": "isolated-abeis",
        "cold-abeis": "isolated-abeis",
        "full": "full-abeis",
        "abeis": "full-abeis",
        "full-abeis": "full-abeis",
    }
    return aliases.get(value, "full-abeis")


def infer_task_kind(task_text: str) -> str:
    kind_match = re.search(r"^Kind:\s*`?([A-Za-z0-9_-]+)`?", task_text, flags=re.M)
    if kind_match and kind_match.group(1) in {"statePreparation", "operatorBlockEncoding"}:
        return kind_match.group(1)
    mode = infer_task_mode(task_text)
    return mode if mode in {"statePreparation", "operatorBlockEncoding"} else ""


def local_paper_source_candidates(task_text: str) -> list[tuple[str, Path]]:
    candidates: list[tuple[str, Path]] = []
    if LOCAL_PAPER_SOURCE_ROOT == OUTER_PAPERS_ROOT:
        raw_roots = [
            OUTER_PAPERS_QUANTUM_ROOT,
            OUTER_PAPERS_AUTOMATION_ROOT,
            OUTER_PAPERS_SAMPLING_ROOT,
        ]
    else:
        raw_roots = [
            LOCAL_PAPER_SOURCE_ROOT,
            OUTER_PAPERS_QUANTUM_ROOT,
            OUTER_PAPERS_ROOT,
        ]
    roots: list[Path] = []
    seen_roots: set[Path] = set()
    for root in raw_roots:
        try:
            resolved_root = root.resolve()
        except OSError:
            resolved_root = root
        if resolved_root in seen_roots:
            continue
        seen_roots.add(resolved_root)
        roots.append(root)
    if "GHL2025" in task_text or "Guseynov" in task_text or "2506.20478" in task_text:
        names = [
            "GHL2025",
            "Guseynov-Huang-Liu 2025",
            "Guseynov-Huang–Liu 2025",
            "Quantum framework for simulating linear PDEs with Robin boundary conditions",
        ]
        for root in roots:
            for name in names:
                candidates.append(("GHL2025", root / name))
            if root.exists():
                for main_tex in root.glob("**/main.tex"):
                    haystack = str(main_tex.parent).lower()
                    if any(marker in haystack for marker in ["ghl2025", "guseynov", "robin"]):
                        candidates.append(("GHL2025", main_tex.parent))
        legacy = ARIS_LOCAL_REFERENCE / "paper-sources" / "GHL2025"
        if legacy.exists():
            candidates.append(("GHL2025-legacy", legacy))
    seen: set[Path] = set()
    unique: list[tuple[str, Path]] = []
    for key, path in candidates:
        try:
            resolved = path.resolve()
        except OSError:
            resolved = path
        if resolved in seen:
            continue
        seen.add(resolved)
        unique.append((key, path))
    return unique


def local_paper_source_context(task_text: str) -> str:
    """Return optional local paper-source hints for agent prompts.

    Public QBE artifacts should cite stable paper anchors, not these local
    paths.  The hints are for private agent workspaces where TeX sources are
    already available.
    """
    rows = []
    expected = []
    for key, path in local_paper_source_candidates(task_text):
        main_tex = path / "main.tex"
        if main_tex.exists():
            rows.append(f"- {key}: `{display_path(main_tex)}`")
        else:
            expected.append(f"- {key}: `{display_path(main_tex)}`")
    if not rows:
        return (
            "No local paper-source archive was detected for this task.  If a "
            "paper source is needed, middle should record the missing source "
            "as an artifact gap rather than guessing a proof step.\n"
            f"Default shared paper-source root: `{display_path(LOCAL_PAPER_SOURCE_ROOT)}`.\n"
            "Set `QBE_PAPER_SOURCE_ROOT=/path/to/paper-sources` to override.\n"
            "Expected local source candidates:\n"
            + ("\n".join(expected[:8]) if expected else "- none inferred from task text")
        )
    return "\n".join(rows) + (
        "\nUse these local TeX files only as working sources.  Public proof "
        "maps must cite arXiv, theorem/lemma/equation/figure anchors, or "
        "bundled paper-note sections, not machine-specific absolute paths."
    )


def verifier_feedback_contract(task_id: str = "", task_text: str = "") -> str:
    ghl_tail = ""
    if task_id and is_ghl_case_task(task_id):
        ghl_tail = """

For GHL2025 one-term closure, useful pre-Lean diagnostics are finite
matrix-entry checks and support/branch decomposition checks.  Timeline or
hardware scheduling checks are not relevant to the current proof blocker.
"""
    return """Typed verifier-feedback contract:

- QBE borrows the useful shape of parser/unit-test/simulator feedback from
  non-Lean quantum-circuit systems, but Lean remains the final acceptance gate.
- Every lower attempt should classify progress with small fields when possible:
  `leaf`, `leaf_signature`, `evidence_digest`, `source_correspondence_ok`,
  `lean_parse_ok`, `lean_build_ok`,
  `finite_matrix_ok`, `state_action_ok`, `block_entry_ok`,
  `ancilla_cleanup_ok`, `normalizer_ok`, `unitarity_ok`, `resource_score`,
  `auxiliary_qubits`, `gate_count`, `depth`, `oracle_calls`,
  `closed_theorem_ok`, `error_class`, and `next_route`.
- Copy `leaf_signature` and `evidence_digest` from the current controller note.
  Feedback signed for an older state is retained for audit but cannot schedule
  new work.  When a privileged upper/reviewer role wants more capacity, it may
  additionally set `capacity_decision` to one or more of `increase_upper`,
  `increase_middle`, or `increase_lower`.  Each accepted decision increases
  that layer by one level only.  To leave exact search, set
  `tolerance_decision=open_approximate` and `epsilon_next` to the first rung;
  after an unchanged approximate cycle, use `tolerance_decision=relax_epsilon`
  with exactly the adjacent next rung.  The legacy `increase_exploration`
  value means the same one-rung transition.  The controller ignores unsigned,
  stale, repeated, premature, or rung-skipping requests.
- Suggested `error_class` values: `source_translation_gap`,
  `shape_or_register_gap`, `finite_matrix_counterexample`,
  `symbolic_bridge_gap`, `lean_tactic_gap`, `external_contract_gap`,
  `stale_leaf`, and `invalid_route`.
- In state-preparation mode, feedback should check normalization, unitarity,
  and `U |0^n> = |psi>` or first-column equality.  In paper-benchmark mode,
  feedback may rank proof routes for the same fixed statement, but it must not
  mutate the paper circuit, oracle contract, theorem, or assumptions.  In
  operator-block-encoding and exploratory modes, feedback may score candidate
  families by `BlockEncodingCost`, but a score is not proof.
- State preparation and block encoding share the same gradual controller.  For
  state preparation, epsilon bounds state-vector/first-column error; for block
  encoding, epsilon bounds the declared clean-block operator norm.  A phase
  change never changes the target state, target operator, normalizer, or norm.
- Log structured feedback with:

```bash
python3 tools/qbe.py trial-log --task <task> --role lower --kind attempt \\
  --status failed --feedback-field leaf=<leaf-id> \\
  --feedback-field lean_build_ok=false \\
  --feedback-field error_class=<class> \\
  --feedback-field next_route=\"<next narrow route>\"
```
""" + ghl_tail


def strategy_for_mode(mode: str) -> str:
    if mode == "statePreparation":
        return """Hybrid strategy for this mode:

- Treat the target state `|psi>` and initial state `|0^n>` as the fixed
  scientific target.  Do not silently replace an unnormalized vector with a
  unitary-output state; either normalize it or restate the target as a
  rank-one operator for block encoding.
- Maintain the first-column invariant: in the computational basis, the first
  column of candidate unitary `U` must equal `|psi>`.
- Keep three pools distinct: certified candidates have named Lean certificates;
  executable-validated candidates pass the declared exact/finite/Qiskit checks
  and are prioritized for proof; the insight pool contains unchecked Pro
  suggestions, Python searches, simulator traces, and reviewer ideas.
- Use simple anchors first when teaching or debugging: `H |0> = (|0> + |1>) /
  sqrt(2)` and `X |0> = |1>`, `X |1> = |0>`.
- For formula-defined amplitudes, split the work into normalization/error
  bounds, reversible arithmetic, rotation or amplitude loading, uncompute, and
  final state-action proof.
- Start at exact first-column equality.  Only an upper/reviewer decision after
  the exact stall budget may open the task's requested epsilon; later
  relaxations move one adjacent rung at a time and keep the same normalized
  target and error norm.
- If the prepared state is a PREPARE primitive for an LCU, sparse/Gram, or
  density/purification route, record that dependency explicitly before sending
  the downstream block-encoding task to lower agents.
- A candidate is accepted only after Lean proves the stated state-preparation
  theorem.  Resource scores rank candidates; they do not replace the theorem.
"""
    if mode == "operatorBlockEncoding":
        return """Hybrid strategy for this mode:

- Treat the user-provided operator `A` and normalizer `alpha` as the fixed
  scientific target.  Do not weaken the operator, add hidden promises, or
  change the requested block projector to rescue a candidate.
- Maintain an EoH-like candidate population under `candidate-populations/`.
  Each candidate must name its unitary/circuit family, auxiliary qubits `a`,
  gate count, depth/layer schedule, unresolved oracle calls, and current Lean
  obligations.
- Keep three pools distinct.  The certified population contains candidates
  with named Lean certificates for the required semantic tier, clean-block
  equality, and resource score.  The executable-validated population contains
  candidates that pass the declared exact/finite/Qiskit checks but still have
  open Lean obligations.  The insight pool contains unchecked suggestions and
  partial routes. Mutation and crossover may use certified or explicitly
  labelled executable-validated parents; champion claims and achieved plots use
  certified candidates only.
- Use necessary-condition feedback before expensive Lean proof search:
  dimension checks, unitarity checks on small symbolic/numeric instances,
  block-entry extraction checks, ancilla-cleanup checks, and schedule/depth
  checks.  These diagnostics may reject, rank, or provisionally promote a
  candidate and thereby decide where Lean effort goes. A floating-point check
  does not prove an exact theorem; an exact external witness may discharge an
  obligation only through a Lean-checked certificate bridge.
- Use the Learning-Beyond-Gradients-like loop to update compact memory after
  every attempt: which construction family improved, which failed by
  dimension/unitarity/block-entry/resource mismatch, and which proof leaf is
  next.
- Candidate selection is lexicographic by `BlockEncodingCost` inside one
  semantic/asymptotic tier: gate count first, then parallel depth, then
  auxiliary qubits, then unresolved oracle calls.  Gate-count improvements
  dominate depth improvements; parallel schedules break gate-count ties.
- Prefer exact block encodings first.  If exact search reaches the user's
  resource floor before the configured budget, enter Scenario 1 and continue
  approximate-improvement search with the exact champion as an epsilon-zero
  incumbent.  If exact search stalls or misses the floor, enter Scenario 2 and
  switch to approximate search, relaxing epsilon only when the task explicitly
  permits it.
- Phase-lock invariant: once the harness policy, task file, memory digest, or
  reviewer says Phase 2/Scenario 2 approximate search is active, upper,
  middle, and reviewer must reject plans that spend another broad cycle trying
  to close the old exact root.  Exact-route leaves may be kept only as bounded
  dependencies, reusable components, or negative evidence.  The active packet
  must instead name an approximate target, an epsilon tier, an error budget,
  and the Lean statement shape that would certify that tier.
- There is no fixed public "easy" or "hard" mode.  The default adaptive harness
  starts with a small prompt queue: one upper director, one middle coordinator,
  one lower worker, and a reviewer/build gate.  After each cycle, the upper and
  reviewer layers decide from the logs, proof-DAG frontier, population
  diversity, and marginal improvement whether to open upper/middle specialist
  panels or increase lower parallelism.  Extra agents are a controlled
  intervention, not a permanent assumption that more agents are always better.
- A candidate is accepted only after Lean proves the unitary and block-entry
  contracts for the stated target.  Resource scores rank candidates; they do
  not replace the theorem.
"""
    if mode in {"faithfulPaper", "paperBenchmark"}:
        return """Hybrid strategy for this mode:

- Use the Learning-Beyond-Gradients-like loop as the main process: Lean
  feedback, test failures, proof gaps, and reviewer findings are written into
  trial memory, compressed, and used to choose the next small proof task.
- If a lower agent fails on a fixed theorem or lemma, maintain a local
  proof-attempt population under `proof-attempts/`: different proof routes,
  tactic scripts, intermediate lemmas, and remaining goals may compete.
- The population is over proof routes for the same statement, not over new
  scientific constructions.  Do not mutate the paper's circuit or oracle.
- A proof route can be called successful only when the Lean target builds and
  the corresponding paper-note/conversion-window entry remains synchronized.
- Use `.agents/skills/qbe-hierarchical-proof-dag/SKILL.md` when a proof repeats
  local bit arithmetic, matrix-index calculations, projection lemmas, or gate
  obligations.  Promote repeated fragments to reusable Lean declarations.
- No agent may add a hypothesis, side condition, replacement oracle, or
  substitute circuit to make the statement easier.  If the paper step cannot
  yet be reproduced, record the exact obstruction as a proof obligation.
- Paper benchmark mode produces a baseline candidate and score.  After the
  baseline is source-faithful, a separate `operatorBlockEncoding` or
  `exploratoryConstruction` task may try to improve auxiliary qubits, gate
  count, depth, or unresolved oracle calls for the same operator target.
"""
    if mode == "exploratoryConstruction":
        return """Hybrid strategy for this mode:

- Use the Learning-Beyond-Gradients-like loop for memory: every candidate,
  rejection, partial success, Lean error, and reviewer concern is logged and
  compressed into the next cycle.
- Use the EoH-like loop only inside the search space: maintain candidate
  populations under `candidate-populations/`, with initialization, mutation,
  crossover/backbone recombination, selection, and archive pressure.
- Keep the certified population and insight pool separate.  Proposals from
  ChatGPT Pro, Python search, simulators, or reviewers may guide a lower-agent
  proof task, but they are not parents and not achieved solutions until Lean
  proves the stated certificate and resource score.
- Represent candidates as reusable oracle/proof DAGs when possible, following
  `.agents/skills/qbe-hierarchical-proof-dag/SKILL.md`; do not keep only a flat
  tactic or gate script when components can be shared.
- When Scenario 2 approximate search is active, the candidate population must
  contain at least one approximate candidate row with epsilon tier, current
  error source, proposed certificate theorem name, and the exact artifacts it
  reuses or explicitly postpones as contracts.  Do not let an old exact bridge
  remain the only active lower target.
- Candidate scores are search guides: typechecking, dimension checks,
  small-case block tests, normalizer progress, resource progress, and reduced
  proof-obligation count.  These scores do not prove correctness.
- A construction is accepted only when the Lean acceptance target and all
  required proof obligations are satisfied.
- Do not weaken the target or add assumptions to rescue a candidate.  Reject,
  mutate, or archive the candidate while preserving the original target.
"""
    return """Hybrid strategy for this mode:

- The upper agent must classify the task before broad lower-agent work begins.
- If this is operator block-encoding construction, fix `A`, `alpha`, and the
  block projector before candidate search.
- If this is a paper benchmark, use LBG-style proof maintenance and local
  proof-attempt populations only for fixed source statements.
- If this is exploratory improvement, use LBG-style memory plus EoH-like
  candidate populations for circuit ideas after the acceptance predicate and
  baseline score are precise.
"""


def focused_task_contract(task_text: str) -> str:
    """Return the current directive plus stable header for token-lean runs."""
    lines = task_text.strip().splitlines()
    header: list[str] = []
    for line in lines[:80]:
        if line.startswith("## "):
            break
        header.append(line)
    directive = extract_preferred_section(
        task_text,
        [r"^## Current Run Directive.*?$", r"^## Immediate .*?$"],
    )
    if not directive:
        sections = re.split(r"\n(?=## )", task_text.strip())
        selected = [
            section
            for section in sections
            if re.search(
                r"(?im)^## .*?(current|target|acceptance|constraint|next|status|proof-dag|obligation)",
                section,
            )
        ]
        compact = "\n\n".join((["\n".join(header).strip()] if header else []) + selected[-4:])
        if not compact.strip():
            compact = task_text[:4000] + "\n\n...[task context compacted]...\n\n" + task_text[-4000:]
        if len(compact) > 9000:
            compact = compact[:4500] + "\n\n...[focused task context compacted]...\n\n" + compact[-4500:]
        return compact.strip() + (
            "\n\n[Focused context mode: read the task file only when a named current "
            "leaf cannot be resolved from this packet.]"
        )
    prefix = "\n".join(header).strip()
    return (
        (prefix + "\n\n" if prefix else "")
        + directive
        + "\n\n[Focused context mode: older task sections are omitted from this prompt. "
        "Consult the task file only if the current directive is insufficient.]"
    )


def mathlib_roots() -> list[Path]:
    """Return available local Mathlib roots, including optional env override."""
    roots: list[Path] = []
    env_root = os.environ.get("QBE_MATHLIB_ROOT", "").strip()
    if env_root:
        roots.append(Path(env_root).expanduser())
    roots.extend(MATHLIB_LOCAL_REFERENCE_CANDIDATES)
    seen: set[Path] = set()
    available: list[Path] = []
    for root in roots:
        resolved = root.resolve() if root.exists() else root
        if resolved in seen:
            continue
        seen.add(resolved)
        if root.exists() and root.is_dir():
            available.append(root)
    return available


def mathlib_retrieval_context() -> str:
    roots = mathlib_roots()
    root_text = "\n".join(f"- {rel(root) if root.is_relative_to(ROOT) else root}" for root in roots)
    if not root_text:
        root_text = "- No local Mathlib checkout detected. Set `QBE_MATHLIB_ROOT` or install Mathlib before relying on local lemma search."
    return f"""Mathlib retrieval discipline:

- Before adding a generic matrix, finite-sum, algebra, order, topology,
  norm, continuity, boundedness, or extensionality lemma, search Mathlib first.
- Preferred command:

  ```bash
  python3 tools/qbe.py mathlib-search "<keyword-or-theorem-name>"
  ```

- Available local Mathlib roots:
{root_text}
- If Mathlib already has the lemma, import/reuse it when compatible with this
  project's Lean version and dependency policy.  If direct import is not yet
  enabled, record the exact Mathlib theorem/module in the proof packet and
  prove only the QBE-specific adapter locally.
- If no usable lemma is found, write the failed search query and why a local
  lemma is needed.  Reusable local lemmas should be stated in a Mathlib-quality
  form: small API, explicit hypotheses, stable proof route, and no task-local
  names unless the statement is genuinely block-encoding-specific.
"""


def atlas_retrieval_context() -> str:
    return """ATLAS external-textbook retrieval discipline:

- ATLAS v1 is a separately licensed external memory source, not an imported
  ASPBE proof package. Search it only after checking the local ASPBE inventory
  and Mathlib.
- Preferred conservative command:

  ```bash
  python3 tools/qbe.py atlas-search "<concept-or-theorem-name>" --clean-only
  ```

- Use `atlas-show <exact-name>` only for a result selected for one current
  proof-DAG edge. Preserve the pinned source URL and upstream quality status.
- `upstream-evaluated-clean` still means `external-memory-only` in ASPBE.
  Promote only an independently maintained local adapter that passes the Lean
  and Tests gates.
- Never copy the ATLAS corpus or generated theorem text into this MIT tree.
  Respect its CC BY-NC 4.0 license and upstream no-training rider.
"""


def failure_trace_and_judge_context() -> str:
    return """Failure-memory and decomposed-judge discipline:

- Do not keep failures only as long prose.  When a proof or construction route
  fails in a reusable way, write a compact packet under `failure-memory/` or
  `verifier-feedback/<task-id>/` with: `leaf`, `trace_scope`, `failure_class`,
  `local_symptom`, `root_cause`, `rejected_route`, `repair_route`,
  `reusable_lesson`, and relevant `mathlib_queries`.
- Fine-grained failures repair one active proof leaf.  Coarse-grained failures
  repair the route, theorem statement, source contract, external lemma, or
  harness allocation.  Upper/middle/reviewer must decide which scope applies
  before assigning more lower attempts.
- Treat the reviewer as a decomposed judge, not a vague preference oracle.
  This is the decomposed reviewer judge vector for ABEIS proof search.
  For every candidate or route, score separate requirements:
  `target_contract`, `unitarity`, `clean_block`, `normalizer_error`,
  `resource_tuple`, `proof_reuse`, `source_faithfulness`, and `exportability`.
  Lean-closed requirements are hard gates; natural-language plausibility and
  simulator checks are soft search signals.
- A candidate can be mutated or recombined from an insight only after the
  middle layer renders it into concrete artifacts: Lean theorem target,
  proof-DAG leaves, resource tuple, verifier packet, and human proof sketch.
- Persistent failure is mathematical signal.  Before retrying the same proof,
  ask whether the statement is false, missing a regularity/support/cleanup
  hypothesis, already solved in Mathlib, or trying to prove syntax equality
  where semantic equality is the right target.
- Proof-engineering checklist for every active leaf:
  1. Decompose aggressively: target a lemma that fits one agent context window.
  2. Specify more than the theorem: record local APIs, intended route, parent theorem, and Mathlib search terms.
  3. Treat repeated failure as mathematical signal: recheck assumptions or counterexamples before retrying tactics.
  4. Make hidden regularity reusable: cleanup, boundedness, nonemptiness, injectivity, support uniqueness, and norm bounds become named contracts.
  5. Do not frequently change the proof route once reviewer accepted a well-typed leaf; if the route changes, write a failure-memory packet.
"""


def role_prompt(
    role: str,
    task_id: str,
    title: str,
    task_text: str,
    cycle: int,
    run_dir: Path,
    context_mode: str = "full",
    lower_index: int = 0,
) -> str:
    trial_memory = recent_trial_text(task_id, limit=12)
    mode = infer_task_mode(task_text)
    evaluation_mode = infer_evaluation_mode(task_text)
    strategy = strategy_for_mode(mode)
    paper_sources = local_paper_source_context(task_text)
    verifier_feedback = verifier_feedback_contract(task_id, task_text)
    blueprint = blueprint_context(task_id)
    mathlib_context = mathlib_retrieval_context()
    atlas_context = atlas_retrieval_context()
    failure_judge_context = failure_trace_and_judge_context()
    if evaluation_mode == "task-only":
        trial_memory = ""
        paper_sources = ""
        blueprint = ""
        mathlib_context = ""
        atlas_context = ""
        failure_judge_context = ""
    elif evaluation_mode == "isolated-abeis":
        # Keep only this fresh task's evolving ledger and blueprint.  Do not
        # inject literature sources, curated proof memory, or cross-task
        # failure packets into a cold-start benchmark.
        paper_sources = ""
        mathlib_context = ""
        atlas_context = ""
        failure_judge_context = ""
    elif evaluation_mode == "lad":
        trial_memory = ""
        blueprint = ""
        failure_judge_context = ""
    displayed_task_text = task_text.strip() if context_mode == "full" else focused_task_contract(task_text)
    context_note = (
        "Full task context."
        if context_mode == "full"
        else "Focused task context: stable header plus the latest immediate/current directive only."
    )
    ghl_task = is_ghl_case_task(task_id)
    ghl_figure_audit_rule = ""
    if ghl_task:
        ghl_figure_audit_rule = """- Figure-audit rule: if the active leaf depends on a paper circuit diagram,
  upper/middle/lower1 must use the figure audit or inspect the figure source
  directly before assigning Lean work.  For GHL2025 Fig. 4, read
  `paper-notes/GHL2025/markdown/fig4-visual-audit.zh.md` and keep the full
  Fig. 4 transcript separate from the seven-gate backend component.
"""
    operator_scoped_retrieval = ""
    if task_id.startswith("QBE-OP-") and not ghl_task:
        operator_scoped_retrieval = f"""Task-scoped retrieval discipline for this operator target:

- This task is driven by the user-provided operator target, not by a paper
  source archive.  Do not start by running `list-literature`, broad `rg` over
  the whole repository, or searches through unrelated paper memories.
- Read only the task packet, proof blueprint, proof obligations, candidate
  population, task-specific verifier feedback, task-specific reports, and the
  Lean declaration index shown in this prompt unless upper explicitly upgrades
  the task into a paper-source or cited-literature audit.
- Task-local files to prefer:
  `tasks/{task_id}.md`,
  `proof-blueprints/{task_id}.md`,
  `proof-obligations/{task_id}.md`,
  `candidate-populations/{task_id}.md`,
  `verifier-feedback/{task_id}/`,
  `reports/{task_id}/` if it exists, and the Lean files named in the
  declaration index.
- If a command must search, scope it to one of those task-local files or to
  the exact Lean module named by the blueprint.  Broad repository search is a
  process bug for this cycle because it can import stale paper-benchmark
  context into an operator-construction task.
"""
    if evaluation_mode == "isolated-abeis":
        operator_scoped_retrieval = f"""Cold-start command boundary:

- Do not run repository-wide `rg`, `grep`, `find`, declaration inventory, or
  library search.  Do not inspect generated declaration indexes outside the
  allowlist below.
- Allowed inputs are `tasks/{task_id}.md`,
  `proof-blueprints/{task_id}.md`, `proof-obligations/{task_id}.md`,
  `candidate-populations/{task_id}/`, `verifier-feedback/{task_id}/`, and
  these generic modules only: `BlockEncoding.lean`,
  `BlockEncodingClassics.lean`, `CircuitSemantics.lean`, `Core.lean`, and
  `Circuit.lean`.
- Any source discovery outside this allowlist invalidates the arm.  Stop and
  record `invalid_route` rather than reading a paper-specific declaration.
"""
    elif evaluation_mode in {"task-only", "lad"}:
        operator_scoped_retrieval = ""
    controller_cmd = f'QBE_ROOT="{ROOT}" python3 "{Path(__file__).resolve()}"'
    shared = f"""Task: {task_id} - {title}
Mode: {mode}
Evaluation mode: {evaluation_mode}
Cycle: {cycle}
Run directory: {rel(run_dir)}
Context mode: {context_mode} ({context_note})

Mandatory project gate:

```bash
{controller_cmd} check
```

Runtime-controller invariant: use `{controller_cmd}` for orchestration,
agent notes, trial logging, and checks.  In an isolated experiment root,
`tools/qbe.py` may be a historical snapshot; do not inspect or invoke it to
infer the current policy.

Shared task contract:

```text
{displayed_task_text}
```

Recent trial memory:

```text
{trial_memory}
```

Evaluation boundary: `task-only` receives one bounded non-adaptive attempt;
`isolated-abeis` enables the adaptive controller and task-local population but
injects no historical ABEIS memory or library-assistance packet; `lad` may use
curated library retrieval but receives no trials, population, or failure
history; `full-abeis` enables the adaptive controller and all audited memory
layers.  Do not cross the declared boundary.

Inner-cycle gate rule for every evaluation mode: run only the mandatory
`{controller_cmd} check` shown above unless the active leaf itself changes Lean.
The outer `--check-each-cycle` controller owns `lake build` and `lake build
Tests`.  Never run `scripts/build-all.sh`, Blueprint/catalog generation, or a
website build from an upper, middle, lower, or reviewer prompt.  Those
publication gates run once after accepted experiment artifacts are merged into
the main checkout.  Repeating a full repository or publication build without a
relevant source digest change is not progress.

For `isolated-abeis` inner cycles, the required gate is exactly the controller
test suite plus `lake build` and `lake build Tests`.  Do not run `build-all`,
regenerate Blueprint catalogs, rebuild the website/library inventory, or edit
website/generated documentation.  Those surfaces intentionally describe the
full repository and are synchronized only after an accepted experiment is
merged back into the full checkout.

Proof blueprint snapshot:

```text
{blueprint}
```

Local paper-source archive for agent work:

```text
{paper_sources}
```

{operator_scoped_retrieval}

{mathlib_context}

{atlas_context}

{failure_judge_context}

	Operating model:

- QBE uses ARIS-style plain-file coordination and Learning-Beyond-Gradients-style
  trial memory, but the scientific target is Lean-checked quantum circuit
  matrix construction: given a target state or operator/query-oracle target,
  synthesize a candidate unitary, prove the requested state-action or
  block-entry relation in Lean, and compare candidates by asymptotic tier first
  and then by gate count, depth, auxiliary qubits, and unresolved oracle calls.
- Upper is the human-facing project director: choose the cycle objective,
  decide whether the task is operator construction, paper baseline
  reproduction, or exploratory improvement, and compress memory for the next
  cycle.  In long runs, QBE can
  replace one broad upper pass with a bounded upper panel: source/visual audit,
  proof-DAG strategy, process/memory audit, and director synthesis.
- Human interaction is part of the upper-layer control loop, not an out-of-band
  note.  Treat three events as official human-control inputs: scheduled 6h
  intervention, direct user questions, and user status checks followed by
  top-level instructions.  Upper and middle must translate those inputs into
  updated task packets, proof obligations, verifier-feedback routes, or
  candidate-population changes before lower agents continue.
- Middle is the workflow maintainer: synchronize Lean with concise natural
  language.  It translates lower Lean results into readable proof status and
  translates natural-language proof plans into Lean-facing declarations, file
  scopes, proof obligations, and lower-agent packets.  LaTeX is generated at
  6h/convergence closeout, not during routine inner proof-search cycles.  In
  final audits or stale-context episodes, QBE can split middle into a bounded
  panel: source correspondence, memory/retrieval, report/export, and
  coordinator synthesis.
- Lower agents are implementation workers: solve one assigned Lean/circuit
  task, run the gate if they edit Lean, and report useful failures without
  changing the scientific objective.
- Reviewer is the gatekeeper: audit the diff, build status, hidden oracle
  assumptions, normalizers, ancillas, `BlockEncodingCost`, schedule/depth,
  resource counts, links, and Markdown math discipline.
	- Lean source is authoritative for correctness.  Markdown/natural language is
	  the inner-cycle proof map; closeout LaTeX is the user/report proof export.
	  JSONL/CSV trial logs are the process memory.

	Verifier-feedback discipline:

	```text
	{verifier_feedback}
	```

	Mode discipline:

- LexElim scheduler rule: QBE does not scalarize hard and soft rewards.  Use
  LexElim-Out for faithful theorem closure: filter source faithfulness, correct
  Lean statement, necessary diagnostics, then proof progress/resources.  Use
  LexElim-In for exploratory construction: all feedback fields may schedule
  the next candidate pull, but only hard rejection or certified domination
  retires a candidate.  Soft proof-progress and token-cost signals never
  override Lean correctness or necessary-condition diagnostics.

- In `statePreparation` mode, the fixed target is the user-provided target
  state `|psi>` and initial state, usually `|0^n>`.  Agents may search over
  unitary/circuit families, but every candidate must record normalization,
  first-column or state-action theorem shape, resource score, and Lean
  obligations.  An unnormalized vector is not a unitary-output state unless it
  is normalized; otherwise route it as a rank-one operator target.
- In `operatorBlockEncoding` mode, the fixed target is the user-provided
  operator/matrix `A`, normalizer `alpha`, and block projector.  Agents may
  search over candidate unitary/circuit families, but every candidate must
  record its asymptotic tier plus concrete `BlockEncodingCost`, ordered as
  `(gateCount, depth, auxiliaryQubits, oracleCalls)` inside one tier, and Lean
  obligations.  Necessary-condition simulators and
  finite checks may reject bad candidates, rank survivors, and promote them to
  an executable-validated population. Such candidates may be evolutionary
  parents but must remain marked provisional. Only Lean-certified candidates
  may be plotted as achieved solutions or used for final mathematical claims.
- In `paperBenchmark` or `faithfulPaper` mode, reproduce the cited paper's
  construction as a baseline candidate.  Do not
  invent a replacement oracle or block encoding, and do not add assumptions,
  side conditions, or easier variants.  If a paper step is missing or too hard,
  record the exact proof obligation and keep `proved := false`.
- In paper-benchmark theorem-closure cycles, distinguish the current paper's own
  proof contribution from primitives it explicitly cites.  External oracle,
  state-preparation, arithmetic, and LCU/block-composition results may be used
  as precise typed contracts with `SemanticObligation`s and cited-results rows.
  Do not redirect the main lower packet into recursively proving a cited paper
  unless the task explicitly asks for contract formalization.  First close the
  current paper theorem under those contracts.
- Also distinguish source branches before declaring a source-contract gap.  If
  a displayed equation writes only the boundary branch and hides the bulk branch
  in `+ ...`, do not compare a bulk finite example against the displayed
  boundary endpoint.  Upper and middle must split boundary and bulk transcript
  targets, then assign lower work to the branch-correct target.
- In `exploratoryConstruction` mode, propose new oracle/block-encoding
  constructions only against a precise Lean-checkable acceptance target.  This
  mode is allowed to improve a paper baseline, but not to change the operator
  being encoded.  Do not weaken the target or add assumptions to make a
  candidate pass.
- If the mode is `unspecified`, the upper agent must classify the task before
  lower agents perform broad code changes.
- Prefer referencing shared Lean declarations and existing paper-note
  definitions.  Do not duplicate a definition in another file when an existing
  declaration or notation table can be referenced.
- Apply `.agents/skills/qbe-hierarchical-proof-dag/SKILL.md` when repeated
  subproofs, gate obligations, index arithmetic, or projection arguments appear.
  The goal is a reusable proof DAG, not a flat repeated trace.
- Proof-DAG invariant: a DAG is a directed acyclic graph of Lean declarations,
  source-proof steps, cited contracts, and proof obligations.  Edge `A -> B`
  means that `B` depends on `A`; agents must not create circular routes or
  repeatedly attack a high theorem while its active leaves are unproved.
  During theorem-closure cycles, upper and middle must expose a current
  frontier with node id, interface statement, dependencies, owner, Lean
  declaration, human proof-map location, local gate, and status.  Lower 1 may
  first solve the dependency plan in natural language; lower 2 must then
  implement exactly one active Lean leaf from that plan; lower 3, when present,
  should run necessary-condition diagnostics that can reject a wrong target
  before a large Lean proof attempt.
- Human-readable leaf rationale invariant: every active leaf assigned by upper
  or middle must say, in the selected report language when practical, what
  high-level theorem it serves, why the leaf is necessary, which part is a
  local Lean proof, which part is an external contract such as QSVT, and when
  the leaf should be retired.  A user should not need to read Lean goals to
  understand why the system is spending time on that subproblem.
- Apply `.agents/skills/qbe-proof-blueprint/SKILL.md` at the start of long
  runs or after a stale lower target is detected.  Refresh
  `proof-blueprints/<task-id>.md`, retire stale dynamic leaves, and then assign
  one local proof node.
	- Apply `.agents/skills/qbe-proof-diagnostics/SKILL.md` when reviewing Lean
	  proof progress, hidden assumptions, placeholders, suspicious semantic-flag
	  promotions, or reusable proof-block memory.  This records the MathCode-like
	  proof-diagnostics pattern in a QBE-specific form.
	- Apply `.agents/skills/qbe-verifier-feedback/SKILL.md` when a lower attempt
	  fails or partially succeeds.  Parser/build/finite-matrix/symbolic-feedback
	  fields should guide the next route, but they are not theorem closure.
- Maintain cited-results memory for external or classical ingredients.  If a
  paper invokes a prior theorem, arithmetic circuit, state-preparation result,
  sparse-Hamiltonian primitive, QSVT/LCU lemma, or "standard" fact, record the
  exact source and statement under `research-wiki/cited-results/` before using
  it as a dependency.  Reviewer must reject uncited or hallucinated prior
  results and any dependency marked as proved without a Lean declaration,
  explicit contract, or proof obligation.
- A cited-results row is enough for paper-benchmark theorem closure only when it is a
  precise contract and is not marked proved.  It is not enough for gate-level
  completion of that cited primitive; that belongs to a later task.
- Treat repeated proof failure in paper-benchmark mode as a source-dependency
  signal.  Upper and middle should re-read the local TeX source and its
  bibliography around the failing theorem before assigning more lower proof
  search.  If the paper relies on an external result, middle must add a
  precise cited-results entry and lower must not invent the missing theorem or
  add a new assumption.
- Paper-benchmark proof translation invariant: if the source TeX contains a proof or
  proof sketch for the target statement, upper and middle must translate that
  proof structure before declaring the Lean task blocked.  Each proof sentence
  or displayed equation should be classified as an existing Lean declaration,
  a new local Lean lemma, an external cited result, or a source-contract gap.
  A `source-contract-gap` classification is acceptable only after the local TeX
  and nearby citations have been checked and no paper-backed gate-level
  ingredient has been found.
- Branch-correctness invariant: a focused finite example must satisfy the same
  branch conditions as the source/user target line it is used to check.  If a
  problem has boundary/bulk cases, special register cases, or promise regions,
  the diagnostic instance must be drawn from the same case as the theorem
  branch.  A mismatch here is a planning bug to correct, not a theorem failure
  or a human convention request.
- Sparse-oracle faithfulness invariant: do not confuse sparse-register slots
  with nonzero coefficient values.  If the paper uses a fixed diagonal/band
  enumeration and says zero entries can be included, the index oracle still
  carries those slots; the coefficient or amplitude layer supplies zero.  A
  Lean image function that deletes such slots or folds them to an identity
  address is contract drift, not a paper proof gap.

{strategy}

Human-facing correspondence rule:

- If a cycle changes Lean declarations tied to a paper construction, update the
  conversion window, a `paper-notes/*.tex` note, or a `proof-obligations/`
  ledger in the same cycle.
- Preferred-language audit cadence: during long theorem-closure batches, do not
  spend context or filesystem churn writing a full human summary after every
  inner proof-search cycle.  The 6h wrapper writes one source-aligned audit page
  in the configured report language at the final upper/middle/reviewer audit.
  Use `--report-language <lang>` or `QBE_REPORT_LANGUAGE=<lang>` to select the
  user's mother tongue.  Use `--summary-each-cycle` only for short debugging
  runs where a summary after every cycle is desired.
{ghl_figure_audit_rule}
- Every executed cycle also refreshes `runs/<run-id>/memory_digest.md`,
  `runs/<run-id>/todo.md`, and
  `research-wiki/retrieval-index/{task_id}.json`.  Upper and middle agents
  should read this compact retrieval packet before replaying long logs.
- The memory layer separates paper contributions from external technical
  lemmas: paper-owned proof steps live under
  `research-wiki/paper-contributions/<paper-id>/`, user/operator targets live
  under task-specific blueprints and candidate populations, while cited
  primitives, standard facts, and reusable contracts live under
  `research-wiki/technical-lemmas/`.
- Lean compilation alone is not enough for paper-benchmark mode;
  humans must be able to compare the Lean names with the original theorem,
  equations, normalizers, register layout, and resource statement.
- Proof-export cadence is deliberately slower than Lean search.  Do not spend
  tokens rewriting a polished proof document after every small lower-agent
  change.  During the batch, middle should keep concise Markdown/natural-language
  proof maps.  At 6h/convergence closeout, middle should export accepted Lean
  proof blocks into the technical-report update and into
  `paper-notes/problem-exports/<task-id>/latest.tex`.  Paper-benchmark tasks
  may additionally maintain paper-specific Overleaf files under `paper-notes/`.
  A problem export must be step-by-step enough for a human reader to verify:
  state the target operator, define the candidate unitary/circuit, prove
  unitarity or reversibility, prove the clean-block equality branch by branch
  or entry by entry, prove the resource tuple, and state the exact or
  approximate error claim.  Reviewer should then audit that each proof export
  matches the compiled Lean declarations and does not claim unproved
  optimality.
- Visual closeout invariant: a convergence closeout or active-budget closeout
  for an operator-construction task is incomplete unless it records the current
  dashboard artifacts for readers: a PNG evolution curve, a PNG circuit
  storyboard for Lean-certified candidates only, a Qiskit/export status figure
  when executable export is requested, and a proof-DAG blueprint figure or
  Mermaid source explaining how coarse proof nodes were refined, verified,
  rejected, or postponed as external contracts.  If no Lean-certified
  candidate exists, the figure must say "no certified candidate yet" rather
  than plotting an achieved point.
- Executable-verifier cadence: when a task asks for Qiskit,
  QuantumKatas-style, OpenQASM/QASM, or another executable target, use a cheap
  instance early when it can reject, rank, or provisionally promote routes.
  Record the tested size, tolerance, register map, and semantic tier.  For the
  advertised exact theorem, close a named Lean certificate before certified
  promotion; an external exact witness counts only after a Lean checker verifies
  it.  After certification, emit the reproducible export packet under
  `executable-exports/<task-id>/` with the Lean root, normalizer, projector,
  resource tuple, and concrete instantiation.
- Project-paper cadence: the paper-specific LaTeX export is an appendix input
  to the larger article "Auto-Lean-in-Sleep: Block Encoding for Quantum
  Computing".  During Lean-heavy cycles, do not spend lower-agent effort on
  article polish.  In the final upper/middle/reviewer audit after a multi-hour
  batch, middle may update the appendix map, project-paper outline, and figure
  todo list so the compiled proof work can later be folded into the main
  article efficiently.
- Article-update cadence: the 6h theorem-closure wrapper writes
  `runs/<run-id>/article_update.md`, `runs/<run-id>/article_update.tex`, and
  the generated technical-report status once at the final audit.  Inner
  proof-search cycles should usually skip article updates and keep their
  effort on Lean proof closure plus compact memory refresh.
- Use `.agents/skills/qbe-project-paper-update/SKILL.md` when updating the
  technical report, generated cycle status appendix, article outline, figure
  todo list, or evidence discussion.  This is adapted from the ARIS paper
  writing loop but constrained by Lean truth: no claim becomes a paper claim
  unless it is backed by a Lean declaration, source/citation row, or explicit
  proof obligation.
- For mathematical prose, use `.agents/skills/qbe-math-writing/SKILL.md`.
  Keep definitions before theorem statements, justify nontrivial claims, use
  precise citations, and avoid duplicated definitions.
- In Markdown files, use `$...$` and `$$...$$` for math.  Do not use
  `\\(...\\)` or `\\[...\\]` delimiters in `.md` files.  LaTeX `.tex` files
  may use normal LaTeX delimiters.

Shared dialogue board:

```text
{rel(run_dir / "dialogue.md")}
```

When you finish, append a concise handoff with:

```bash
{controller_cmd} agent-note {run_dir.name} --role {role} --message "..."
{controller_cmd} trial-log --task {task_id} --role {role} --kind handoff --status queued --artifact {rel(run_dir)}
```
"""
    if context_mode != "full":
        state = blueprint_status_state(task_id)
        compact_trials = recent_trial_text(task_id, limit=4)
        compact_queue = "\n".join(
            f"- {row}" for row in state.get("dynamic_leaf_queue", [])
        ) or "- none"
        compact_obligations = "\n".join(
            f"- {row}" for row in state.get("open_obligation_signals", [])
        ) or "- none"
        compact_declarations = "\n".join(
            f"- {row.get('kind', '')} {row.get('name', '')}: {row.get('path', '')}"
            for row in state.get("lean_declarations", [])[:20]
        ) or "- none indexed"
        compact_cards = "\n".join(
            f"- {row.get('path', '')}: compiled anchors: "
            f"{', '.join(row.get('compiled_lean_anchors', [])) or 'none'}"
            for row in state.get("reusable_memory_cards", [])[:6]
        ) or "- none matched"
        shared = f"""Task: {task_id} - {title}
Mode: {mode}; cycle: {cycle}; run: {rel(run_dir)}

Mandatory gate: `{controller_cmd} check`
Use `{controller_cmd}` for notes, logs, checks, and controller state.

Current task contract:

```text
{displayed_task_text}
```

Dynamic proof-DAG queue:
{compact_queue}

Open dependency signals:
{compact_obligations}

Task-relevant Lean declarations:
{compact_declarations}

Ranked reusable BE/state-preparation memory cards:
{compact_cards}

Latest four trial records:

```text
{compact_trials}
```

Focused hard rules:

- Work only on a controller-ready leaf and preserve the declared route lock.
- Search existing declarations before adding a helper; edit the narrow named Lean module.
- In full-memory runs, search ATLAS only after local ASPBE and Mathlib retrieval;
  an ATLAS hit remains external until a narrow local adapter passes the Lean gate.
- For polynomial transforms, try compiled product/LCU arithmetic before opening a QSVT external dependency. QSVT is an optimization route unless the task explicitly requires QSVT itself.
- Lean build evidence is the correctness gate. Never add `sorry`, `admit`, an axiom, or a vacuous contract.
- External/QSVT nodes stay explicit supplier contracts; do not reopen broad theorem search unless assigned.
- Unrelated source or prose edits do not count as progress for the active leaf.
- Capacity and epsilon may change only through current signed upper/reviewer feedback, one level/rung at a time.
- When `Population gate: required`, lower proof work is forbidden until middle
  records at least one active candidate and upper/reviewer records `select` for
  an active id.  Use typed fields `candidate_id`, `candidate_family`,
  `population_action`, `parent_ids`, and `fitness_evidence`; prose alone does not
  advance the population.  Mutation needs one parent and crossover needs two.
- Record one concise typed handoff: leaf, exact declaration changed, gate result, error class if blocked, and next dependency.

Dialogue: `{rel(run_dir / 'dialogue.md')}`
"""
    if role == "upper":
        body = """You are the upper research director and human-intervention window.

Read the task, literature status, prior trials, changed files, and dialogue.
Your job is not to do broad implementation work.  Your job is to keep the
scientific process coherent.

Produce:

1. Task mode for this cycle: operator construction, paper benchmark, exploratory
   construction, or blocked pending human input.
2. One precise objective.
3. Current proof-DAG frontier: highest theorem, dependency nodes, active
   leaves, stale leaves to retire, and one refiner illness area if needed.
4. Non-goals and directions to stop pursuing, with reasons.
5. Middle-agent instructions for conversion windows, paper notes, proof
   obligations, and memory.
5a. Textbook-memory intuition.  Read the block-encoding memory library as an
   exam-prep notebook and inspiration source, not as a rigid detector or a
   memorized recipe table.  For nontrivial block-encoding targets, propose
   multiple route hypotheses before selecting one active route.  Name which
   Lin-note/classic construction patterns seem analogous, which ones are kept
   only for population diversity, and which compiled Lean leaves should be
   reused before any new proof is attempted.  Distinguish idea cards,
   compiled Lean leaves, and contract-only nodes.  A compiled leaf may be
   instantiated or adapted; an idea card may be mutated or rejected; a
   contract-only node must remain explicit and cannot be claimed as Lean
   closed.  Fast retrieval entry points:
   `research-wiki/block-encoding-library/route-selector.md`,
   `research-wiki/block-encoding-library/lean-leaf-module-graph.md`,
   `research-wiki/block-encoding-library/quantum-lean-leaf-atlas.md`,
   `research-wiki/block-encoding-library/compiled-lean-leaf-index.md`,
   `research-wiki/block-encoding-library/compiled-lean-leaf-index.json`, and,
   for diagonal-grid polynomial hints such as `x_j -> x_j^3`,
   `research-wiki/block-encoding-library/qsvt-hard-hint-route.md`.
   When auxiliary-qubit or controlled-conjugation cost is active, also inspect
   `research-wiki/block-encoding-library/cards/BE.Circuit.PromiseAncillaTradeoff.md`.
   Treat it as a candidate mutation only: require promise-subspace, restoration,
   involution (for dirty workspace), and same-tier resource proof leaves before
   selection or promotion.
6. Layer-allocation decision for this cycle.  In the Hierarchical Harness
   profile, spend enough budget in upper/middle/reviewer planning before lower
   workers run: upper fixes target and search direction, middle translates and
   maintains the insight population, reviewer blocks stale or unfounded lower
   work.  The Hierarchical Harness then uses an upper specialist panel, a middle
   specialist panel, and three complementary lower roles: lower 1 natural-language proof/construction
   architect, lower 2 Lean implementation worker, and lower 3
   necessary-condition verifier.  Increase upper, middle, or lower parallelism
   only when the logs justify it: stale target or weak strategy increases
   upper capacity; retrieval/translation drift increases middle capacity;
   several ready independent leaves or candidate families increase lower
   capacity.  Record the expected marginal gain and the fixed generation budget
   for the increase.
   Before handoff, write one typed policy decision against the controller's
   current `leaf_signature` and `evidence_digest`.  Use `capacity_decision`
   only for the layer whose bottleneck is evidenced; each decision advances
   one level.  If exact search has consumed its stall budget, either keep exact
   with a named remaining leaf or set `tolerance_decision=open_approximate`
   and `epsilon_next` to the first displayed rung.  In approximate search,
   either keep the current rung or request only the adjacent next rung.  Never
   combine a target change with an epsilon relaxation.
7. Lower-agent work packets with narrow file scopes and acceptance checks.
   Use lower 4 only as a refiner/reducer after a concrete Lean failure.
   Every packet should say whether it is trying to certify a candidate, translate
   a natural-language proof sketch into Lean, extract an insight-pool idea, or
   simplify an already-correct proof.
8. The verifier-feedback fields expected from lower agents for this cycle,
   including which finite-matrix, source-correspondence, or Lean-gate checks are
   meaningful and which ones are irrelevant.
9. Reviewer checklist.
10. A compressed handoff explaining what future agents should remember.
11. Any cited prior results or classical facts that the next cycle depends on,
   including whether they are already formalized or still obligations.

In paper-benchmark mode, preserve the paper construction and isolate every
unimplemented oracle as a proof obligation; do not permit new assumptions or
replacement conditions.  In exploratory mode, require a Lean-checkable target
before search begins and reject any target-weakening shortcut.

Paper-benchmark mode has a phase order.  Phase 1 is a fast, complete paper
transcript: map the paper's theorem, equations, circuit fragments, oracle
contracts, register layout, normalizers, and proof steps into Lean declarations
or explicit obligations.  Do not slow Phase 1 down with broad library
architecture, general-purpose abstractions, or non-critical proofs.  Phase 2,
after the transcript and contracts are complete, may reorganize shared APIs for
teaching, reuse by other papers, and exploratory construction mode.

Before assigning lower work in paper-benchmark mode, run a source-contract
audit: compare each Lean oracle/circuit contract with the paper's stated
register-level transformation, normalizer, ancilla cleanup condition, and
resource claim.  If a Lean declaration uses a simplified or drifted register
map, make the next objective a correction of that contract rather than a proof
attempt for the drifted statement.

When a paper-benchmark proof block fails or becomes blocked, run a source
dependency audit before assigning more lower proof search: inspect the local
TeX source around the statement, inspect nearby citations and bibliography
entries, decide whether the missing ingredient is internal, external, or a QBE
contract gap, and require middle to update `research-wiki/cited-results/` or
`proof-obligations/` before lower agents continue.
If the missing ingredient is external and the cited contract is already precise,
upper and middle should continue the current paper theorem conditionally on the
contract instead of spending the cycle proving the external theorem.
If the apparent blocker came from comparing a focused finite example to the
wrong source branch, middle should reassign lower work to a branch-correct
finite target instead of freezing the theorem route.

For paper statements that already have a TeX proof or proof sketch, require
middle to produce a proof-translation packet: list the source proof steps,
their Lean targets or existing declarations, and the exact external results
needed.  The next lower packet should implement one item from this map, not a
free-form search around the theorem.

For long theorem-closure runs, plan through the proof DAG explicitly.  Upper
should name the current root theorem, the shortest dependency path to the root,
the active leaf for lower 2, the natural-language proof plan requested from
lower 1, and any lower-3 necessary-condition diagnostic that can reject a
wrong target cheaply.  If a previous lower target is already compiled, retire
it instead of asking another worker to rediscover it.

Require the middle agent to maintain two-way translation every cycle:
source/user-problem-to-Lean for the next lower task, and Lean-to-concise
Markdown/natural-language for what has actually been proved, failed, or left
as an obligation.  Upper should use that synchronized proof map, not raw Lean
diffs alone, when planning the next cycle.  LaTeX is produced at
6h/convergence closeout through the technical-report packet and the
problem-specific proof-note export.

If a paper-benchmark lower attempt fails on a fixed lemma, ask the middle agent to
start or update a `proof-attempts/` record rather than changing the theorem.
If a repeated local argument appears, ask middle to introduce a
`qbe-hierarchical-proof-dag` block and assign lower work against that block. If
an exploratory-mode candidate family looks promising, assign separate lower
workers to mutation, recombination, and proof-obligation reduction in disjoint
file scopes.

When assigning documentation work, require the `qbe-math-writing` skill and
ask the reviewer to check definition ordering, citation precision, and whether
shared Lean definitions were referenced instead of duplicated.

If the cycle relies on a result from another paper or a standard theorem, ask
middle to update `research-wiki/cited-results/` and ask reviewer to verify that
the result has a precise source, a statement matching the use site, and a Lean
status that is not overstated.
"""
        if lower_index == -1:
            body += """

Upper-panel profile: source/visual auditor.

This pass answers only source-faithfulness questions.  Inspect the local paper
source context, figure audits, conversion windows, and current theorem target.
Do not assign broad Lean proof search.  Produce:

1. The exact source theorem/equation/figure/caption anchors relevant to the
   active target.
2. The register transcript, gate order, branch conditions, normalizer, and
   ancilla cleanup requirements that the Lean target must preserve.
3. Any mismatch between the source object and current Lean/proof-obligation
   object, classified as source-confirmed, external-citation-needed, or
   contract-drift.
4. A short recommendation to the director: continue the current leaf, repair
   the source contract, or ask middle for a proof-translation packet.
"""
            if ghl_task:
                body += """

For GHL2025 Fig. 4, keep the full circuit transcript separate from the local
seven-gate backend component.  The purpose is to prevent another cycle from
proving the wrong diagram.
"""
        elif lower_index == -2:
            body += """

Upper-panel profile: proof-DAG strategist.

This pass answers dependency-order questions.  Use the proof blueprint,
retrieval index, proof obligations, verifier feedback, and recent trials.  Do
not rewrite prose broadly.  Produce:

1. The current root theorem and the shortest dependency path to it.
2. Active leaves that are ready for lower work, with one recommended leaf.
3. Stale leaves or already-compiled targets that should be retired.
4. The exact lower-1 natural-language proof task, lower-2 Lean task, and
   lower-3 necessary-condition verifier task.
5. Any diagnostic that can reject a wrong target before Lean spends time on a
   large proof.

Prefer small semantic bridge lemmas over repeated attacks on a root theorem.
"""
        elif lower_index == -3:
            body += """

Upper-panel profile: process/memory auditor.

This pass answers whether the automation process is wasting context, repeating
failed routes, or hiding status from humans.  Inspect recent dialogue,
`runs/trials_summary.csv`, proof-attempt records, human reports, and compact
memory.  Produce:

1. Repeated failures that should become rejected-route memory.
2. Missing or stale memory cards, cited-results rows, verifier-feedback fields,
   preferred-language summaries, problem-specific proof exports, or maintainer
   article-update packets.
3. Token/time waste risks in the next cycle.
4. One concrete harness or prompt adjustment, if needed.
5. The reports humans should read after the run.

Do not ask lower agents to solve new mathematics from this profile; route that
through the director synthesis.
"""
        elif lower_index == -11:
            body += """

Upper Game Harness profile: Natural-Language Hierarchical Team.

This upper pass is the strategy director for a full natural-language team, not
a single sketch worker.  Its team has upper planning, middle memory, and lower
natural-language construction workers.  Its competitive goal is to construct
the best candidate block encoding and proof in human mathematics before the
Lean Team does so in Lean.  It must maintain a natural-language candidate
population, proof DAG, resource estimates, approximate-relaxation routes, and
recombination ideas.  It cannot declare acceptance.  It may mark a construction
as `reviewer-plausible` only when its own upper/middle audit finds the proof
coherent and target-faithful.  Reviewer-plausible constructions must be handed
to the Game Council for possible translation into Lean work packets.

If the Lean Team produces a compiled BE certificate, this team owns the
human-facing translation: write the step-by-step mathematical explanation that
will later become the user's LaTeX proof note, including target operator,
candidate unitary, clean-block proof, unitarity proof, resource tuple, and any
exact/approximate error statement.
"""
        elif lower_index == -12:
            body += """

Upper Game Harness profile: Lean Hierarchical Team.

This upper pass is the strategy director for a full Lean-facing team.  Its team
also reasons in natural language at the upper and middle layers, but its lower
workers write Lean construction and proof code.  Its competitive goal is to
directly produce a Lean-certified block encoding, resource theorem, and export
contract before the Natural-Language Team finishes a reviewer-plausible proof.
It should decide which candidate families are worth encoding in Lean, which
existing declarations should be reused, and which proof-DAG leaf is ready for
one lower Lean worker.

This team also owns translation from reviewer-plausible natural-language
constructions into Lean: after Game Council or reviewer approval, produce exact
Lean declarations, file scopes, theorem names, resource-score statements, and
small diagnostics for the selected idea.  Reject any natural-language idea that
changes the target, hides an oracle, lacks unitarity, or cannot state the
projector/normalizer cleanly.
"""
        elif lower_index == -13:
            body += """

Upper Game Harness profile: Game Council and capacity controller.

This pass reads the Natural-Language Hierarchical Team and Lean Hierarchical
Team upper/middle handoffs, then issues the binding cycle decision.  Treat the
teams as competitors over the same fixed operator target and resource order:
the Natural-Language Team competes by producing reviewer-plausible human proofs,
while the Lean Team competes by producing compiled Lean certificates.  Treat
them as collaborators over insight transfer: Lean-certified constructions must
be sent to the Natural-Language Team for human-readable proof export, and
reviewer-plausible natural-language constructions must be sent to the Lean Team
for formalization.

Decide which insight population items are preserved, recombined, retired, or
translated; which team owns the next bottleneck; whether to increase upper,
middle, natural-language lower, or Lean lower capacity for a fixed generation
budget; whether exact search has stalled enough to open the approximate-BE
phase; and whether to generate or update the preferred-language ChatGPT Pro
prompt.  Only Lean-certified candidates are accepted or plotted as achieved
solutions.
"""
        else:
            body += """

Upper profile: director synthesis.

If this run directory contains upper-panel specialist prompts or handoffs,
read them before assigning middle/lower work.  Synthesize the source/visual
audit, proof-DAG strategy, and process/memory audit into one coherent next
objective.  If the specialist reports disagree, resolve the conflict by
source faithfulness first, proof-DAG readiness second, and process efficiency
third.
"""
    elif role == "middle":
        body = """You are the middle formalization maintainer and memory manager.

Your job is to translate upper-level scientific strategy into executable Lean
work while preserving a human-readable proof map.

Maintain:

1. Conversion windows: source/user symbols when present, concise Markdown
   explanations, Lean names, normalizers, register layouts, and resource
   claims.  In inner cycles, prefer natural language plus Lean names over
   LaTeX prose.
2. Paper/problem notes: readable theorem/proof sketches tied to source
   equations or user-specified operator requirements.
3. Proof obligations: every missing circuit, oracle, lemma, bound, and resource
   equality must be explicit.
4. Trial memory: summarize what worked, what failed, and what should be tried
   next.
5. Lower-agent packets: exact declarations, target files, allowed write scope,
   and build/test expectations.
6. Cited-results memory: exact external results used by this paper, their
   source anchors, Lean status, and dependent proof blocks.
7. Proof-DAG frontier: root theorem, dependency edges, active leaves, stale
   leaves, owner lower-agent profile, human proof-map location, and Lean gate.
   Keep exactly one machine-readable section headed
   `## Current Obligation State [ACTIVE]` in the task's proof-obligation file;
   replace its contents instead of prepending or appending another active
   section.  Its table must expose `Node`, `Interface`, `Lean declaration`,
   optional `Dependency class`, and `Status`.  Every open row must say `exact`
   or `approximate`, and an executable row must say `active next Lean leaf`;
   otherwise the deterministic controller will not schedule lower work.
   `ROOT-INITIALIZATION` is setup, not the final root theorem: once concrete
   child rows freeze its dimensions, normalizer, register order, tolerance,
   and acceptance anchor, mark it `exact; discharged` and keep the unproved
   certificate in a separate `<TASK>-ROOT` row.
8. Verifier-feedback memory: for each lower attempt, record the leaf id, typed
   success/failure fields, error class, and next route in `runs/trials.jsonl`
    and, when useful, under `verifier-feedback/`.
   Store every task-local proof packet below
   `proof-attempts/<task-id>/`; never create a flat
   `proof-attempts/<task-id>-*.md` packet.
8a. Textbook-memory and insight-pool bridge: when upper names a classic
    block-encoding route, do not treat it as a fixed recipe.  Translate it into
    (i) one or more Lean proof leaves, (ii) one natural-language proof sketch
    packet, and (iii) an insight-pool record for alternative routes, mutations,
    recombinations, or failed but reusable ideas.  For each proposed route,
    mark whether it is an inspiration-only idea card, a compiled Lean leaf that
    should be reused directly, or a contract-only dependency.  Explicitly
    record when a natural-language proof suggests a Lean lemma, and when a Lean
    failure suggests a better human proof decomposition.  Start from
    `research-wiki/block-encoding-library/route-selector.md`; when the route
    mentions QSVT or diagonal polynomial transformations, also read
    `research-wiki/block-encoding-library/qsvt-hard-hint-route.md`.  Check
    `research-wiki/block-encoding-library/lean-leaf-module-graph.md`,
    `research-wiki/block-encoding-library/quantum-lean-leaf-atlas.md`, and
    `research-wiki/block-encoding-library/compiled-lean-leaf-index.md` before
    asking lower agents to reprove an existing declaration.
9. Closeout export bridge: at 6h or convergence closeout, ensure the
   problem-specific LaTeX proof note reflects the Lean status, proof-DAG
   frontier, and safe manuscript edits.  The ABEIS technical-report packet is
   maintainer-only; update it only under explicit `project-article-update` or
   `sleep-run --project-article-update`.  Do not produce LaTeX during ordinary
   inner proof-search cycles.
10. Post-Lean executable export bridge: if the task requests Qiskit,
    QuantumKatas-style, QASM/OpenQASM, or another executable output, create the
    export plan only after the relevant Lean certificate is named.  The plan
    must record the exact Lean theorem, concrete instantiation, register sizes,
    normalizer, projector, resource tuple, target language, and export check.

You are responsible for two-way translation.  Before lower work, translate the
paper's relevant theorem/equation/circuit fragment or the user's operator
requirement into a Lean-facing contract.  After lower work, translate the
actual Lean declarations, proof status, failed goals, and remaining obligations
back into concise Markdown/natural language so humans and upper agents can
decide the next Lean task.  Export LaTeX only at 6h/convergence closeout or
when the user explicitly asks for a proof-note export.

In paper-benchmark mode, optimize for Phase 1 first: complete the paper transcript
and exact Lean contracts before asking lower agents to prove non-critical
sublemmas or to build reusable library architecture.  If a proof-route lemma is
useful but not on the transcript critical path, record it as proof-route memory
and schedule it later.

For paper-benchmark theorem-closure mode, the current paper's theorem should close
under precise cited contracts before agents recursively formalize the cited
oracle/state-preparation/LCU papers.  Upper and middle must regulate this every
cycle: external cited work is backlog unless the active paper theorem cannot be
stated conditionally on a precise contract.

Upper and middle must also regulate branch selection every cycle.  A finite
example chosen for a displayed boundary formula must actually be a boundary
case, and a finite example chosen for a bulk formula must be tied to the bulk
part of the paper proof, including any `+ ...` branch that the source omits
from the display.

Upper and middle must also regulate gate-convention drift.  If a named rotation
angle is inconsistent with the active matrix convention, audit the local paper,
the cited subroutine paper, and any companion implementation before sending more
lower proof search.  Record the outcome as a source-backed correction route or
a source-contract gap.  For standard `R_y(theta)`, the clean entry is
`cos(theta/2)`, so an amplitude `a` normally requires `theta = 2 arccos(a)`.

Prefer small Lean changes that keep the repository compiling.  Do not bury a
failed oracle construction in prose; promote it to a proof obligation or open
problem.

In paper-benchmark mode, maintain proof-attempt populations only for fixed Lean
targets.  In exploratory mode, maintain candidate-population records that track
candidate family, partial score, changed files, remaining obligations, and next
mutation or recombination step.

When the task enables the population gate, write the machine-readable update in
the same cycle, for example:

```text
python3 tools/qbe.py trial-log --task <task-id> --role middle --kind proposal \
  --status accepted --feedback-field candidate_id=<stable-id> \
  --feedback-field candidate_family=<family> \
  --feedback-field population_action=propose \
  --feedback-field fitness_evidence=<named-lemma-or-diagnostic> \
  --feedback-field next_route=<one-narrow-route>
```

Use `retain`, `retire`, `mutate`, or `crossover` on later cycles.  Mutation must
name one `parent_ids` value and crossover must name two.  Do not keep every
candidate alive merely to show activity.

This command is a return gate, not optional documentation.  Before the middle
agent returns, it must execute the task-local `trial-log` command and verify
that it prints `logged ...`.  Writing a candidate only in Markdown leaves the
authoritative population empty and the reviewer must reject the cycle.

Before assigning lower work, search for existing Lean declarations and
paper-note definitions to reuse.  Do not create a second definition for a
matrix, normalizer, register layout, or theorem statement when a reference to
the existing one will do.

In paper-benchmark mode, maintain a source-contract audit before every lower
packet.  For each oracle or gate, record the paper anchor, exact input
registers, exact output registers, clean ancillas, and the Lean declaration
that represents that transformation.  Local source copies may be used while
working, but public repository artifacts should cite the paper, arXiv URL,
lemma/equation/figure labels, or bundled paper-note sections rather than a
machine-specific absolute path.  If the Lean contract does not match the paper,
mark it as contract drift and assign correction work before proof search.

Also maintain a source-dependency audit for blocked proof steps.  Re-read the
local TeX source and its bibliography around the failing proof block.  Classify
the missing ingredient as one of: an internal paper step that needs a Lean
interface, an external cited theorem/subroutine that needs a cited-results
entry, a classical fact that needs a named Lean lemma, or a genuine source
contract gap.  Do not send lower agents to continue tactic search until this
classification is written into the conversion window or proof-obligation
ledger.

When the paper contains a proof, translate the proof before planning lower
work.  A middle packet should name the proof paragraph/equation anchors, list
the proof steps in order, and map each step to an existing Lean declaration, a
new local lemma target, an external cited-result row, or an explicit
source-contract gap.  This proof-translation map is the input to lower agents.

Use `.agents/skills/qbe-hierarchical-proof-dag/SKILL.md` to maintain a
proof-DAG/reuse table whenever the same local argument would otherwise be
proved several times.  Lower packets should target one block interface at a
time.

Use `.agents/skills/qbe-verifier-feedback/SKILL.md` when a lower attempt has
partial progress or a useful failure.  Update `runs/trials.jsonl` through
`trial-log --feedback-field ...` and, if needed, write a durable JSON/Markdown
packet under `verifier-feedback/<task-id>/`.

Use `.agents/skills/qbe-project-paper-update/SKILL.md` only for local ABEIS
technical-report maintenance or when the user explicitly asks for a
manuscript-facing delta.  Ordinary public-user closeout writes the
problem-specific LaTeX proof note, not the ABEIS authors' technical report.
The update is concise and evidence-preserving: record what changed in
Lean/proof memory and list which stronger claims remain forbidden until Lean
supports them.  Do not spend lower-agent proof time on article polish.

When lower agents are available, middle must split the packet deliberately:
lower 1 receives a natural-language DAG/proof packet with source anchors,
definitions, dependencies, and the next Lean lemma; lower 2 receives a Lean
implementation packet for exactly one active leaf; lower 3, if present,
receives a necessary-condition verifier packet for finite matrix/path/support
checks and typed feedback.  The Lean packet should reference the lower-1 proof
map and lower-3 diagnostics if they exist, not restart broad search.  Lower 4
should be scheduled only as a refiner/reducer after a concrete Lean failure,
for example to isolate a maxRecDepth route or factor out a reusable lemma.

When editing Markdown or closeout LaTeX, follow `.agents/skills/qbe-math-writing/SKILL.md`:
definitions before theorem statements, short claim statements, precise
justifications, and no unannounced assumptions.  Markdown math uses `$` or
`$$`; LaTeX `.tex` files may use ordinary LaTeX syntax.

When a paper invokes a prior theorem, a "standard" result, or a classical
subroutine, update `research-wiki/cited-results/` before lower work depends on
it.  A cited result entry should name the source, exact statement used, Lean
declaration or planned declaration, dependency sites, and status.  Use
`obligation`, not `formalized`, unless the Lean target is actually present and
build-tested.
"""
        if lower_index == -1:
            body += """

Middle-panel profile: source-correspondence formalizer.

Focus only on paper-to-Lean correspondence.  Read the upper source/visual
audit if present.  Produce:

1. The source anchors and the paper object being translated.
2. The Lean declarations, theorem statements, and proof obligations that
   correspond to that object.
3. Any external technical lemma or cited-result row needed by the next lower
   packet.
4. A clear statement of what is owned by the active paper or user target, what
   is an external contract, and what is QBE-local semantic glue.
5. One lower-facing source contract, with no article prose polish.
"""
        elif lower_index == -2:
            body += """

Middle-panel profile: memory/retrieval curator.

Focus only on compact memory.  Read recent trials, verifier feedback,
proof-attempts, proof-blueprints, and retrieval indexes.  Produce:

1. Stale lower targets to retire.
2. Rejected routes that must be remembered.
3. The current active proof-DAG leaf and its dependencies.
4. Missing typed verifier-feedback fields or memory-card updates.
5. A compact next-cycle retrieval packet recommendation.

Do not rewrite the source proof or article text unless the memory state is
ambiguous without a one-line clarification.
"""
        elif lower_index == -3:
            body += """

Middle-panel profile: report/export maintainer.

Focus only on human-readable exports.  Read the source-correspondence and
memory curator notes if present.  Produce:

1. Which preferred-language status page, Markdown note, LaTeX status section, or technical
   report appendix must be updated at the final audit.
2. Which raw logs or generated files should not be human entry points.
3. A concise human-facing explanation of any open blocker.
4. Any manuscript claim that must remain forbidden until Lean closes it.
5. If the Lean theorem has closed and the user requested executable outputs,
   the required post-Lean export packet for Qiskit, QuantumKatas-style tests,
   OpenQASM/QASM, or other selected targets.

Do not assign Lean work and do not rewrite polished prose during inner proof
search.  This role is mainly for final-audit synchronization.
"""
        elif lower_index == -21:
            body += """

Middle Game Harness profile: Natural-Language Hierarchical Team curator.

This middle pass serves the Natural-Language Team's own hierarchy.  It turns
lower natural-language sketches into structured proof DAGs, candidate-family
records, resource estimates, insight-population entries, and reviewer-plausible
proof packets.  It must not mark a construction as accepted.  It must label
each candidate as speculative, reviewer-plausible, translated-to-Lean, or
retired.

It also owns Lean-to-human translation after a Lean success: when the Lean Team
closes a named certificate, translate the compiled theorem into a step-by-step
mathematical proof note for the user and list the circuit figures/evolution
curves that should appear in the closeout.
"""
        elif lower_index == -22:
            body += """

Middle Game Harness profile: Lean Hierarchical Team formalization curator.

This middle pass serves the Lean Team's own hierarchy.  It translates Game
Council insights and reviewer-plausible natural-language proofs into exact Lean
declarations, file scopes, active proof-DAG leaves, resource-score theorems,
and post-Lean executable export tasks.  It must state which natural-language
ideas are rejected, deferred, or ready for Lean lower workers, and it must keep
certified candidates separate from speculative or reviewer-plausible population
entries.

It should also feed Lean failures back to the Natural-Language Team as concise
mathematical blockers, so the natural-language side can repair proof ideas
instead of repeating an unformalizable route.
"""
        elif lower_index == -23:
            body += """

Middle Game Harness profile: Game Council coordination clerk.

This pass reconciles the two hierarchical team outputs into one shared cycle
ledger.  It should write: the competition status, the collaboration/translation
requests, the shared insight population update, the certified population update,
the next Natural-Language Team lower tasks, the next Lean Team lower tasks, and
any Pro-prompt trigger.  It should record whether the upper Game Council
requested a capacity increase, a recombination step, a team-to-team translation
step, or an exact-to-approximate phase switch.
"""
        else:
            body += """

Middle profile: coordinator synthesis.

If middle-panel specialist prompts or handoffs exist, read them before writing
the lower packet.  Synthesize source correspondence, compact memory, and
report/export status into lower-1 natural-language, lower-2 Lean
implementation, and lower-3 necessary-condition verifier tasks.  If the
specialists disagree, preserve source
faithfulness first, then proof-DAG readiness, then report cleanliness.
"""
    elif role == "reviewer":
        body = """You are the independent reviewer and gatekeeper.

Inspect the current diff, the conversion window, the task contract, and the
trial summary.  Run the requested Lean gate when practical.

Look for:

1. False proofs such as `Prop := True`, `trivial`, hidden `sorry`, or semantic
   booleans marked proved without construction.
2. Oracle assumptions that should be gate-level circuits or explicit proof
   obligations.
3. Normalizer, ancilla, register ordering, dimension, and resource-count drift.
4. Inner-cycle Lean/natural-language correspondence gaps, including Markdown
   math delimiters; closeout LaTeX export gaps when the run is at a 6h or
   convergence boundary.
5. Citation or source-link gaps.
6. Duplicated definitions that should be references to existing Lean or paper
   note declarations.
7. Mathematical writing violations covered by
   `.agents/skills/qbe-math-writing/SKILL.md`, especially definitions appearing
   after theorem statements.
8. Missed proof-DAG opportunities covered by
   `.agents/skills/qbe-hierarchical-proof-dag/SKILL.md`, especially repeated
   local proof fragments that should be named and reused.
9. Proof-diagnostics gaps covered by
   `.agents/skills/qbe-proof-diagnostics/SKILL.md`, especially hidden axioms,
   placeholders, suspicious semantic flag promotions, and useful failed
   fragments that should be stored in proof-attempt memory.
10. Verifier-feedback gaps covered by
   `.agents/skills/qbe-verifier-feedback/SKILL.md`, especially failures that
   lack typed fields and therefore cannot guide upper/middle scheduling.
11. Missing two-way translation: after Lean changes, the Markdown/natural-language
	   proof map must say what was actually proved, what failed, and how that
	   corresponds to the source or user problem statement.  At closeout, the
12. Missing retrieval discipline: for block-encoding construction, check that
    upper/middle/lower consulted `route-selector.md`, `lean-leaf-module-graph.md`,
    `quantum-lean-leaf-atlas.md`, `compiled-lean-leaf-index.md`, and, when
    applicable, `qsvt-hard-hint-route.md` instead of rediscovering existing
    textbook leaves or changing a stable proof route.  Also check the opposite
    failure mode: agents must not follow a textbook card dogmatically when the
    target calls for brainstorming, candidate-population diversity, or a new
    construction.  Compiled leaves are proof tools; idea cards are search
    inspiration; contract-only cards are explicit dependencies, not closed
    Lean proofs.
	   problem-specific LaTeX export must match that map.  The ABEIS
	   technical-report update is required only in maintainer mode.
12. Missing cited-results memory for prior work or "standard" facts used by the
	    paper.  Reject a dependency if the source, exact statement, Lean status, or
	    dependent use sites are vague.
13. Missing source-dependency audit after a paper-benchmark proof block gets
	    stuck.  Reviewer should ask whether middle re-read the local TeX source and
	    bibliography, whether the failure is internal/external/contractual, and
	    whether the next lower packet is justified by that classification.
14. Missing proof-translation map when the source TeX already contains a proof
	    or proof sketch.  Reviewer should reject broad lower proof search unless
	    middle mapped the paper proof steps to Lean declarations, local lemma
	    targets, cited-results entries, or explicit contract gaps.
15. Missing proof-DAG frontier.  Reviewer should reject cycles where lower
	    agents attack the root theorem directly without ready dependencies, ignore
	    the natural-language proof plan, duplicate a stale route, or fail to name
	    the active leaf being discharged.
16. Missing project-paper update.  Reviewer should check that the generated
	    `article_update.md/.tex` packet is truthful, that the technical-report
	    status appendix does not overclaim, and that any manual report edits are
	    backed by Lean declarations, source anchors, cited-result rows, or explicit
	    obligations.
17. Missing typed verifier feedback.  Reviewer should reject a failed lower
    handoff that says only "proof failed" without classifying whether the
    failure was source translation, shape/register, finite-matrix,
    symbolic-bridge, Lean-tactic, external-contract, stale-leaf, or invalid-route.
18. Missing post-Lean executable-export discipline.  Reviewer should reject a
    Qiskit, QuantumKatas-style, QASM/OpenQASM, or other executable artifact if
    it is presented as a final theorem without a matching named Lean
    certificate, or if it claims a larger parameter range than the Lean theorem
    and concrete export instantiation justify.
19. Missing reader-facing closeout figures.  At convergence or active-budget
    closeout for an operator-construction task, reviewer should require
    `reports/<task-id>/figures/` to contain the evolution curve, certified
    circuit storyboard, Qiskit/export status figure when executable export is
    requested, and a proof-DAG blueprint figure or Mermaid source.  If no
    candidate is certified, the figures must say so rather than plotting an
    unproved achieved point.
20. Missing proof elegance and readability audit.  Reviewer should reject
    needlessly duplicated local definitions, theorem statements whose
    hypotheses hide the operator contract, proof scripts that obscure a reusable
    textbook leaf, or exported Markdown/LaTeX proofs that a mathematically
    trained user cannot follow step by step.

Classify findings as blocking or advisory.  If the current task is a paper
benchmark, reject unrecorded invention and any added assumption or
side condition.  Also reject proof work on a Lean oracle contract whose
register-level transformation, ancilla cleanup, or normalizer does not match
the paper.  Public docs should not require a local absolute path to a paper
source; cite the paper and stable theorem/equation/figure anchors instead.  If
Lean fails, localize the failure and suggest the next smallest repair.

In paper-benchmark mode, also check phase discipline.  During Phase 1, broad
library reorganization, non-critical proof polishing, and reusable API design
are advisory at best; they should not displace completing the paper transcript,
oracle contracts, and proof-obligation map.

In paper-benchmark mode, check that proof-attempt populations did not alter the paper
construction.  In exploratory mode, check that candidate scores are treated as
search guidance rather than proof of correctness.

When a population gate is active, the reviewer must select one currently active
middle candidate or reject the population and explain what evidence is missing.
Selection is also typed, using `population_action=select`, the same
`candidate_id`, and `fitness_evidence` or `selection_reason`.  Never select an id
that middle has not proposed, retained, mutated, or crossed in the current
ledger.

The reviewer must execute its typed `trial-log` selection or rejection before
returning and verify the command's `logged ...` output.  A prose-only review is
not controller state and cannot authorize lower work.

For unattended construction runs, the review is incomplete without a typed
controller decision.  Copy the current `leaf_signature` and `evidence_digest`
from the run context.  Approve at most one-level increases for upper, middle,
or lower capacity, and only when the named bottleneck justifies them.  Approve
`open_approximate` or `relax_epsilon` only after the displayed stall condition
and only for the adjacent `epsilon_next` rung.  If no change is justified,
record that explicitly in the reviewer handoff rather than emitting a vague
request for more exploration.
"""
    else:
        body = """You are a lower implementation worker.

You are assigned one concrete Lean/circuit task.  Keep the attempt narrow:
define or repair one matrix, circuit schema, lemma, resource expression, test,
or proof-obligation promotion.  Respect the file scope given by the upper or
middle agent, and assume other agents may be editing nearby documentation.

Run the Lean gate if you edit Lean, or explain why it was not run.  Do not
change the scientific objective.  In paper-benchmark mode, do not replace the
paper construction with a new one and do not add assumptions.  In exploratory
mode, keep every proposed construction tied to the acceptance predicate.

In paper-benchmark mode, respect phase order.  If the assigned task is part of
Phase 1, implement only the narrow paper-transcript or contract item you were
given.  Do not introduce broad abstractions, reorganize the library, or switch
to a non-critical proof because it looks reusable.

If the assigned Lean target appears to prove a simplified contract rather than
the paper's register-level transformation, stop and record the mismatch as a
proof obligation instead of continuing implementation.

Before defining anything, search for an existing definition to reference.
Prefer small reusable lemmas over duplicated local encodings.  For block-encoding
construction leaves, first inspect the local memory entry points:
`research-wiki/block-encoding-library/route-selector.md`,
`research-wiki/block-encoding-library/lean-leaf-module-graph.md`,
`research-wiki/block-encoding-library/quantum-lean-leaf-atlas.md`, and
`research-wiki/block-encoding-library/compiled-lean-leaf-index.md`.  If the
assignment mentions a diagonal-grid polynomial, cubic map, qubitization, or
QSVT hint, also inspect `research-wiki/block-encoding-library/qsvt-hard-hint-route.md`
before proposing a new route.
If a compiled Lean leaf already proves the needed bridge, instantiate it or
write the smallest adapter.  If the memory entry is only an idea card, use it
as construction inspiration and record the proof obligations.  If the memory
entry is contract-only, do not reprove the whole external theorem unless that
is the assigned task; make the contract explicit and prove the local consumer
leaf around it.

If the assigned proof repeats a known argument, create or reuse a
`qbe-hierarchical-proof-dag` block rather than copying the proof script.

For theorem closure, treat the proof DAG as the work order.  If you cannot name
the active leaf, its dependencies, and the root theorem it feeds, stop and
record a handoff instead of editing a broad theorem.  A useful natural-language
proof decomposition is valid lower-agent work; a Lean implementation worker
should then compile one leaf from that decomposition.

Write failures clearly; a failed attempt is useful search data when it
identifies a blocked assumption, missing lemma, or impossible file scope.
Also write typed verifier feedback when possible.  At minimum, include the leaf
id, one `error_class`, and one `next_route`; if you edited Lean, include
`lean_parse_ok`, `lean_build_ok`, and `closed_theorem_ok`.

In paper-benchmark mode, record failed proof scripts or lemma routes under
`proof-attempts/` when useful.  In exploratory mode, record candidate-family
changes under `candidate-populations/` when useful, especially when the attempt
improves a partial Lean score but does not yet prove the target.
"""
        if lower_index == -30:
            body += """
Lower profile for this prompt: post-Lean executable exporter.

The declared Lean root anchors already compile.  Do not change theorem
statements or reopen the proof DAG.  Implement or repair only the task's
`Executable acceptance command` and declared artifacts.  The export must cite
the named Lean certificate, preserve its system/ancilla ordering, normalizer,
projector, and concrete parameter range, and run real Qiskit `Operator` plus
QASM checks.  A fixed-instance result is executable evidence, not a symbolic
proof.  Run the exact declared command before handoff and record every reported
error rather than replacing it with a prose claim.
"""
        elif lower_index == 1:
            body += """
Lower profile for this prompt: natural-language proof architect.

Your primary job is to reason mathematically before Lean coding.  Read the
local TeX source, conversion window, proof obligations, and current Lean DAG.
Then produce a compact proof design that a Lean-focused lower agent can use.

Expected output:

1. The exact source-paper proof fragment or equation being translated.
2. The natural-language proof of the active local theorem, with definitions
   stated before claims.
3. A proof-DAG table with node ids, dependencies, status, owner, and the next
   active leaf for the Lean worker.
4. A list of intermediate Lean lemmas, ordered by dependency, including which
   existing declarations should be reused.
5. A failure analysis if the current target is mathematically wrong or should
   be routed through a different equivalent theorem.
6. A short handoff in `proof-attempts/<task-id>/` or the dialogue board.

You may edit Markdown proof-attempt, conversion-window, or proof-obligation
files.  Avoid Lean edits unless the proof design exposes a very small
definition-free theorem that is safe to add.  Do not add assumptions, mutate
the paper circuit, or promote semantic flags.
"""
        elif lower_index == 2:
            body += """
Lower profile for this prompt: Lean implementation worker.

Your primary job is to turn the current proof design into compiling Lean.
Prefer existing declarations and the dependency map from the natural-language
proof architect.  If no such handoff is available yet, work from the current
upper/middle packet and keep the theorem scope narrow.

Expected output:

1. One small Lean theorem, lemma, or repair that compiles.
2. No new `sorry`, `admit`, hidden axiom, or theorem-flag promotion.
3. Run the mandatory controller check shown above after Lean edits.
4. A handoff naming the exact theorem closed or the exact remaining Lean goal.
5. If the proof blocks, store the useful failed route under
   `proof-attempts/<task-id>/`.

Do not spend the cycle on broad prose polish.  The natural-language proof
agent owns proof design; you own compiled declarations and gate checks.
If the active leaf is underspecified or stale, do not improvise a new theorem;
record the missing DAG packet and ask middle to refresh the frontier.
"""
        elif lower_index == 3:
            body += """
Lower profile for this prompt: necessary-condition verifier.

Your primary job is to protect the Lean worker from proving the wrong target.
Use exact finite matrix, path-sum, support/vanish, register-shape, or symbolic
2-by-2 convention checks that are necessary for the active Lean statement.

Expected output:

1. The active leaf being checked and why the diagnostic is a necessary
   condition for that leaf.
2. A small executable or Lean-local diagnostic, if one already exists or can be
   added safely without changing theorem statements.
3. Typed verifier feedback with at least `leaf`, `source_correspondence_ok`,
   `finite_matrix_ok`, `block_entry_ok`, `error_class`, and `next_route`.
4. A clear rejection if the finite/path/support check contradicts the current
   target, so middle can repair the source contract or proof-DAG leaf.

You should usually avoid editing theorem-facing Lean declarations.  If you edit
Lean, add only diagnostic lemmas/tests or small helpers that do not promote
semantic flags, oracle contracts, normalizers, or theorem completion.  Do not
use passing diagnostics as proof closure.
"""
        elif lower_index == 4:
            body += """
Lower profile for this prompt: Lean refiner/reducer.

Your primary job is to repair a concrete failed Lean route after lower 2 or the
reviewer has produced a specific error.  Good targets are reducing
`maxRecDepth`, extracting one reusable associativity/evalWith lemma, replacing
a raw constructor equality with a semantic bridge, or shrinking a tactic proof.

Expected output:

1. The exact failed theorem, error message, and rejected route.
2. One smaller lemma, simplification normal form, or proof-reduction patch.
3. No theorem statement drift and no new assumptions.
4. Run the mandatory controller check shown above after Lean edits.
5. A proof-attempt record explaining whether the refiner repair should be kept,
   retried, or rejected.

Do not duplicate lower 2's broad proof attempt and do not invent a new route
unless it directly repairs the reported failure.
"""
        elif 100 < lower_index < 200:
            body += f"""
Lower profile for this prompt: Natural-Language Hierarchical Team worker `{lower_index - 100}`.

Work only in natural language, diagrams, proof DAGs, candidate descriptions,
resource estimates, and necessary-condition plans. Do not edit Lean source.
Your value is to explore mathematically plausible constructions, approximate
relaxations, recombinations, and proof structures that may guide the Lean
team. Every claim must be labelled as speculative, reviewer-plausible, or
ready-for-Lean-translation. Preserve useful ideas in candidate-population or
proof-attempt memory, but never mark them accepted.
"""
        elif 200 < lower_index < 300:
            body += f"""
Lower profile for this prompt: Lean Hierarchical Team worker `{lower_index - 200}`.

Work only on Lean-facing construction and proof tasks. Read your Lean Team middle packet, the Game Council handoff, and any reviewer-plausible Natural-Language Team construction selected for translation; select one formally stated leaf or candidate,
and either add or repair compiling Lean declarations or write a typed failure
that explains why the natural-language idea cannot yet be formalized. Do not
accept a construction until the named Lean theorem and resource-score
declarations compile. If you edit Lean, run the mandatory controller check when
practical.
"""
        elif lower_index > 4:
            body += f"""
Lower profile for this prompt: auxiliary proof-route worker `{lower_index}`.

Use this worker only for exploratory construction mode or explicitly separated
candidate families.  Try an independent route to the same fixed acceptance
predicate, coordinate through the dialogue board, avoid overlapping file edits
where possible, and preserve useful failed fragments as proof-attempt memory.
"""
    return f"# {role.title()} Agent Prompt\n\n{body}\n\n## Shared Context\n\n{shared}"


def create_run_cycle(
    task_id: str,
    cycle: int,
    lower_count: int,
    run_id: str | None = None,
    context_mode: str = "full",
    blueprint_refresh: bool = False,
    upper_panel: bool = DEFAULT_UPPER_PANEL,
    middle_panel: bool = DEFAULT_MIDDLE_PANEL,
    game_harness: bool = DEFAULT_GAME_HARNESS,
    natural_lower_count: int = DEFAULT_NATURAL_LOWER_COUNT,
    lean_lower_count: int = DEFAULT_LEAN_LOWER_COUNT,
    harness_policy_note: str = "",
    upper_specialist_count: int | None = None,
    middle_specialist_count: int | None = None,
) -> Path:
    cmd_init(argparse.Namespace())
    if blueprint_refresh:
        refresh_blueprint(task_id)
    title, task_text = task_context(task_id)
    run_name = run_id or f"{file_stamp()}-{slugify(task_id)}-cycle{cycle:02d}"
    run_dir = ROOT / "runs" / run_name
    run_dir.mkdir(parents=True, exist_ok=False)
    displayed_task_text = task_text if context_mode == "full" else focused_task_contract(task_text)
    context = f"""# Run Context

Task id: `{task_id}`
Title: {title}
Cycle: `{cycle}`
Created: `{now_stamp()}`
Context mode: `{context_mode}`

Use this directory as the shared workspace for one upper/middle/lower/reviewer
cycle.  Agents converse through `dialogue.md`; durable results go into
`runs/trials.jsonl` and source files.

## Task Contract

{displayed_task_text}

## Recent Trial Memory

```text
{recent_trial_text(task_id, limit=12)}
```

## Proof Blueprint Snapshot

```text
{blueprint_context(task_id)}
```

## Harness Capacity Policy

{harness_policy_note or "Fixed-capacity cycle. Use the prompt deck as generated."}
"""
    (run_dir / "00_context.md").write_text(context, encoding="utf-8")
    (run_dir / "dialogue.md").write_text(
        f"# Dialogue: {task_id} cycle {cycle}\n\nAppend short role-tagged handoffs here.\n",
        encoding="utf-8",
    )
    upper_specialists = [
        ("upper", run_dir / "11_upper_source_visual.md", -1),
        ("upper", run_dir / "12_upper_proof_dag.md", -2),
        ("upper", run_dir / "13_upper_process_memory.md", -3),
    ]
    middle_specialists = [
        ("middle", run_dir / "21_middle_source_correspondence.md", -1),
        ("middle", run_dir / "22_middle_memory_retrieval.md", -2),
        ("middle", run_dir / "23_middle_report_export.md", -3),
    ]
    effective_upper_specialists = (
        3 if upper_panel and upper_specialist_count is None else max(0, min(3, upper_specialist_count or 0))
    )
    effective_middle_specialists = (
        3 if middle_panel and middle_specialist_count is None else max(0, min(3, middle_specialist_count or 0))
    )
    prompt_files = [("upper", run_dir / "10_upper_director.md", 0)]
    prompt_files.extend(upper_specialists[:effective_upper_specialists])
    if game_harness:
        prompt_files.extend(
            [
                ("upper", run_dir / "14_upper_nl_team.md", -11),
                ("upper", run_dir / "15_upper_lean_team.md", -12),
                ("upper", run_dir / "16_upper_game_council.md", -13),
            ]
        )
    prompt_files.append(("middle", run_dir / "20_middle_formalizer.md", 0))
    prompt_files.extend(middle_specialists[:effective_middle_specialists])
    if game_harness:
        prompt_files.extend(
            [
                ("middle", run_dir / "24_middle_nl_team.md", -21),
                ("middle", run_dir / "25_middle_lean_team.md", -22),
                ("middle", run_dir / "26_middle_game_coordination.md", -23),
            ]
        )
        for index in range(1, natural_lower_count + 1):
            prompt_files.append(("lower", run_dir / f"31_nl_lower_{index}.md", 100 + index))
        for index in range(1, lean_lower_count + 1):
            prompt_files.append(("lower", run_dir / f"32_lean_lower_{index}.md", 200 + index))
    else:
        for index in range(1, lower_count + 1):
            prompt_files.append(("lower", run_dir / f"30_lower_searcher_{index}.md", index))
    prompt_files.append(("lower", run_dir / "30_lower_exporter.md", -30))
    prompt_files.append(("reviewer", run_dir / "40_reviewer.md", 0))
    for role, path, lower_index in prompt_files:
        path.write_text(
            role_prompt(role, task_id, title, task_text, cycle, run_dir, context_mode, lower_index),
            encoding="utf-8",
        )
    handoff = f"""# Handoff

Task id: `{task_id}`
Cycle: `{cycle}`

## Upper Decision

## Middle Formalization State

## Lower Attempts

## Reviewer Findings

## Next Cycle Objective
"""
    (run_dir / "90_handoff.md").write_text(handoff, encoding="utf-8")
    append_jsonl(
        TRIAL_LOG,
        {
            "timestamp": now_stamp(),
            "trial_id": f"{run_name}-prompt-deck",
            "task_id": task_id,
            "role": "upper",
            "kind": "plan",
            "status": "queued",
            "score": "",
            "lean_gate": "",
            "artifact": rel(run_dir),
            "changed_files": [rel(p) for _, p, _ in prompt_files] + [rel(run_dir / "00_context.md"), rel(run_dir / "dialogue.md")],
            "command": "qbe.py run-cycle",
            "notes": (
                f"Created prompt deck with {lower_count} hierarchical lower agent(s); "
                f"game_harness={game_harness}; natural_lower_count={natural_lower_count}; "
                f"lean_lower_count={lean_lower_count}; upper_panel={upper_panel}; middle_panel={middle_panel}. "
                f"upper_specialists={effective_upper_specialists}; "
                f"middle_specialists={effective_middle_specialists}. "
                f"Harness policy: {(harness_policy_note or 'fixed-capacity')[:240]}"
            ),
        },
    )
    refresh_trial_summary_if_bounded()
    add_manifest("qbe.py run-cycle", run_dir, "run", f"Created run cycle for {task_id}")
    return run_dir


def cmd_run_cycle(args: argparse.Namespace) -> int:
    run_dir = create_run_cycle(
        args.id,
        args.cycle,
        args.lower_count,
        args.run_id,
        args.context_mode,
        args.blueprint_refresh,
        args.upper_panel,
        args.middle_panel,
        getattr(args, "game_harness", DEFAULT_GAME_HARNESS),
        getattr(args, "natural_lower_count", DEFAULT_NATURAL_LOWER_COUNT),
        getattr(args, "lean_lower_count", DEFAULT_LEAN_LOWER_COUNT),
    )
    print(f"created {rel(run_dir)}")
    print("agent prompts:")
    for path in sorted(run_dir.glob("*.md")):
        if path.name != "dialogue.md":
            print(f"- {rel(path)}")
    return 0


def prompt_role(path: Path) -> str:
    name = path.name
    if "upper" in name:
        return "upper"
    if "middle" in name:
        return "middle"
    if "reviewer" in name:
        return "reviewer"
    return "lower"


def prompt_profile_keys(prompt: Path) -> list[str]:
    """Return most-specific to least-specific command keys for a prompt."""
    stem = prompt.stem
    role = prompt_role(prompt)
    keys = [stem]
    match = re.search(r"30_lower_searcher_(\d+)", prompt.name)
    natural_match = re.search(r"31_(?:nl|natural)_lower_(\d+)", prompt.name)
    lean_match = re.search(r"32_lean_lower_(\d+)", prompt.name)
    if match:
        keys.extend([f"lower{match.group(1)}", "lower"])
    elif natural_match:
        keys.extend([f"nl_lower{natural_match.group(1)}", f"natural_lower{natural_match.group(1)}", "nl_lower", "natural_lower", "lower"])
    elif lean_match:
        keys.extend([f"lean_lower{lean_match.group(1)}", "lean_lower", "lower"])
    elif prompt.name == "14_upper_nl_team.md":
        keys.extend(["upper_nl_team", "upper_natural_team", "upper_game", "upper"])
    elif prompt.name == "15_upper_lean_team.md":
        keys.extend(["upper_lean_team", "upper_game", "upper"])
    elif prompt.name == "16_upper_game_council.md":
        keys.extend(["upper_game_council", "upper_council", "upper"])
    elif prompt.name == "24_middle_nl_team.md":
        keys.extend(["middle_nl_team", "middle_natural_team", "middle_game", "middle"])
    elif prompt.name == "25_middle_lean_team.md":
        keys.extend(["middle_lean_team", "middle_game", "middle"])
    elif prompt.name == "26_middle_game_coordination.md":
        keys.extend(["middle_game_council", "middle_council", "middle"])
    elif role == "upper":
        keys.extend(["upper"])
    elif role == "middle":
        keys.extend(["middle"])
    elif role == "reviewer":
        keys.extend(["reviewer"])
    else:
        keys.append(role)
    keys.append("default")
    # Preserve order while removing duplicates.
    seen: set[str] = set()
    ordered: list[str] = []
    for key in keys:
        if key not in seen:
            ordered.append(key)
            seen.add(key)
    return ordered


def resolve_agent_profile_path(value: str) -> Path:
    path = Path(value).expanduser()
    if path.exists():
        return path
    named = AGENT_PROFILE_DIR / value
    if named.exists():
        return named
    if not value.endswith(".json"):
        named_json = AGENT_PROFILE_DIR / f"{value}.json"
        if named_json.exists():
            return named_json
    raise SystemExit(f"agent profile not found: {value}")


def load_agent_command_profile(profile: str = "", cmd_file: str = "") -> dict[str, str]:
    """Load role/model command templates.

    JSON shape:

    {
      "default": "...",
      "upper": "...",
      "middle": "...",
      "lower1": "...",
      "lower2": "...",
      "lower3": "...",
      "reviewer": "..."
    }

    Values use the same placeholders as --agent-cmd: {root}, {prompt},
    {run_dir}, {task}, {cycle}, and {role}.
    """
    commands: dict[str, str] = {}
    source = profile or cmd_file
    if source:
        path = resolve_agent_profile_path(source)
        data = json.loads(path.read_text(encoding="utf-8"))
        if not isinstance(data, dict):
            raise SystemExit(f"agent profile must be a JSON object: {display_path(path)}")
        raw = data.get("commands", data)
        if not isinstance(raw, dict):
            raise SystemExit(f"agent profile commands must be a JSON object: {display_path(path)}")
        for key, value in raw.items():
            if not isinstance(value, str):
                raise SystemExit(f"agent profile command for {key!r} must be a string")
            if value.strip():
                commands[str(key)] = value.strip()
    return commands


def agent_command_for_prompt(
    profile_commands: dict[str, str],
    fallback_template: str,
    prompt: Path,
) -> str:
    for key in prompt_profile_keys(prompt):
        if key in profile_commands:
            return profile_commands[key]
    if fallback_template.strip():
        return fallback_template
    keys = ", ".join(prompt_profile_keys(prompt))
    raise SystemExit(f"no agent command template for {rel(prompt)}; tried keys: {keys}")


def upper_prompt_sequence(run_dir: Path, use_panel: bool) -> list[Path]:
    """Return upper prompts in execution order.

    The director prompt keeps the historical `10_upper_director.md` name for
    compatibility.  In panel mode it runs after the specialist audits, so it
    can synthesize their findings before middle/lower work begins.
    """
    director = run_dir / "10_upper_director.md"
    if not use_panel:
        return [director]
    specialists = [
        run_dir / "11_upper_source_visual.md",
        run_dir / "12_upper_proof_dag.md",
        run_dir / "13_upper_process_memory.md",
    ]
    game_panel = [
        run_dir / "14_upper_nl_team.md",
        run_dir / "15_upper_lean_team.md",
        run_dir / "16_upper_game_council.md",
    ]
    return [path for path in specialists + game_panel if path.exists()] + [director]



def upper_prompt_stages(run_dir: Path, use_panel: bool, game_harness: bool) -> list[list[Path]]:
    """Return upper prompts grouped by dependency stage.

    Independent auditors and the two Game Harness team directors can run in
    parallel.  The Game Council and director synthesis run after those
    handoffs exist.
    """
    director = run_dir / "10_upper_director.md"
    if not use_panel:
        return [[director]]
    independent = [
        run_dir / "11_upper_source_visual.md",
        run_dir / "12_upper_proof_dag.md",
        run_dir / "13_upper_process_memory.md",
    ]
    if game_harness:
        independent.extend(
            [
                run_dir / "14_upper_nl_team.md",
                run_dir / "15_upper_lean_team.md",
            ]
        )
    stages: list[list[Path]] = [[path for path in independent if path.exists()]]
    if game_harness and (run_dir / "16_upper_game_council.md").exists():
        stages.append([run_dir / "16_upper_game_council.md"])
    stages.append([director])
    return [stage for stage in stages if stage]


def middle_prompt_sequence(run_dir: Path, use_panel: bool) -> list[Path]:
    """Return middle prompts in execution order.

    The coordinator keeps the historical `20_middle_formalizer.md` name.  In
    panel mode it runs after specialist middle audits so it can write one
    coherent lower-agent packet.
    """
    coordinator = run_dir / "20_middle_formalizer.md"
    if not use_panel:
        return [coordinator]
    specialists = [
        run_dir / "21_middle_source_correspondence.md",
        run_dir / "22_middle_memory_retrieval.md",
        run_dir / "23_middle_report_export.md",
    ]
    game_panel = [
        run_dir / "24_middle_nl_team.md",
        run_dir / "25_middle_lean_team.md",
        run_dir / "26_middle_game_coordination.md",
    ]
    return [path for path in specialists + game_panel if path.exists()] + [coordinator]



def middle_prompt_stages(run_dir: Path, use_panel: bool, game_harness: bool) -> list[list[Path]]:
    """Return middle prompts grouped by dependency stage."""
    coordinator = run_dir / "20_middle_formalizer.md"
    if not use_panel:
        return [[coordinator]]
    independent = [
        run_dir / "21_middle_source_correspondence.md",
        run_dir / "22_middle_memory_retrieval.md",
        run_dir / "23_middle_report_export.md",
    ]
    if game_harness:
        independent.extend(
            [
                run_dir / "24_middle_nl_team.md",
                run_dir / "25_middle_lean_team.md",
            ]
        )
    stages: list[list[Path]] = [[path for path in independent if path.exists()]]
    if game_harness and (run_dir / "26_middle_game_coordination.md").exists():
        stages.append([run_dir / "26_middle_game_coordination.md"])
    stages.append([coordinator])
    return [stage for stage in stages if stage]


def lower_prompt_sequence(run_dir: Path) -> list[Path]:
    prompts: list[Path] = []
    prompts.extend(sorted(run_dir.glob("30_lower_searcher_*.md")))
    prompts.extend(sorted(run_dir.glob("31_nl_lower_*.md")))
    prompts.extend(sorted(run_dir.glob("31_natural_lower_*.md")))
    prompts.extend(sorted(run_dir.glob("32_lean_lower_*.md")))
    return prompts


def format_agent_command(template: str, prompt: Path, run_dir: Path, task_id: str, cycle: int) -> str:
    role = prompt_role(prompt)
    return template.format(
        root=str(ROOT),
        prompt=str(prompt),
        run_dir=str(run_dir),
        task=task_id,
        cycle=cycle,
        role=role,
    )


def start_agent_process(command: str) -> subprocess.Popen:
    process = subprocess.Popen(command, cwd=ROOT, shell=True, start_new_session=True)
    ACTIVE_AGENT_PROCESSES.add(process)
    return process


def wait_agent_process(process: subprocess.Popen) -> int:
    try:
        return process.wait()
    finally:
        ACTIVE_AGENT_PROCESSES.discard(process)


def terminate_active_agent_processes() -> None:
    """Terminate each external agent and every child in its process group."""

    processes = list(ACTIVE_AGENT_PROCESSES)
    for process in processes:
        if process.poll() is not None:
            ACTIVE_AGENT_PROCESSES.discard(process)
            continue
        try:
            os.killpg(os.getpgid(process.pid), signal.SIGTERM)
        except (ProcessLookupError, PermissionError):
            process.terminate()
    deadline = time.monotonic() + 5.0
    for process in processes:
        remaining = max(0.0, deadline - time.monotonic())
        try:
            process.wait(timeout=remaining)
        except subprocess.TimeoutExpired:
            try:
                os.killpg(os.getpgid(process.pid), signal.SIGKILL)
            except (ProcessLookupError, PermissionError):
                process.kill()
            process.wait()
        finally:
            ACTIVE_AGENT_PROCESSES.discard(process)


def run_agent_command(template: str, prompt: Path, run_dir: Path, task_id: str, cycle: int) -> tuple[int, float]:
    command = format_agent_command(template, prompt, run_dir, task_id, cycle)
    print("$ " + command)
    start = time.perf_counter()
    process = start_agent_process(command)
    return wait_agent_process(process), time.perf_counter() - start



def execute_prompt_stage(
    prompts: list[Path],
    profile_commands: dict[str, str],
    fallback_template: str,
    run_dir: Path,
    task_id: str,
    cycle: int,
    parallel: bool,
) -> int:
    if not prompts:
        return 0
    if parallel and len(prompts) > 1:
        running = []
        stage_snapshot = git_worktree_snapshot()
        for prompt in prompts:
            template = agent_command_for_prompt(profile_commands, fallback_template, prompt)
            command = format_agent_command(template, prompt, run_dir, task_id, cycle)
            print("$ " + command)
            start = time.perf_counter()
            process = start_agent_process(command)
            running.append((prompt, command, process, start, stage_snapshot))
        first_error = 0
        for prompt, command, process, start, before_snapshot in running:
            code = wait_agent_process(process)
            log_agent_attempt(
                task_id,
                run_dir,
                prompt,
                command,
                code,
                time.perf_counter() - start,
                before_snapshot,
            )
            if code != 0 and first_error == 0:
                first_error = code
        return first_error
    for prompt in prompts:
        template = agent_command_for_prompt(profile_commands, fallback_template, prompt)
        command = format_agent_command(template, prompt, run_dir, task_id, cycle)
        print("$ " + command)
        before_snapshot = git_worktree_snapshot()
        start = time.perf_counter()
        process = start_agent_process(command)
        code = wait_agent_process(process)
        log_agent_attempt(
            task_id,
            run_dir,
            prompt,
            command,
            code,
            time.perf_counter() - start,
            before_snapshot,
        )
        if code != 0:
            return code
    return 0


def log_agent_attempt(
    task_id: str,
    run_dir: Path,
    prompt: Path,
    command: str,
    code: int,
    wall_time_s: float | None = None,
    before_snapshot: dict[str, tuple[str, int | None, int | None]] | None = None,
) -> None:
    status = "accepted" if code == 0 else "failed"
    prompt_text = prompt.read_text(encoding="utf-8") if prompt.exists() else ""
    changed_files = (
        git_changed_files_since(before_snapshot)
        if before_snapshot is not None
        else git_changed_files()
    )
    harness_metrics = {
        "agent_wall_time_s": wall_time_s,
        "prompt_chars": len(prompt_text),
        "estimated_input_tokens": approx_token_count(prompt_text),
        "exact_token_accounting": False,
        "detail": "Agent wall time and local prompt-token proxy; provider token usage is not inferred.",
    }
    control = load_control_state(control_state_path(task_id))
    append_jsonl(
        TRIAL_LOG,
        {
            "timestamp": now_stamp(),
            "trial_id": f"{run_dir.name}-{prompt.stem}",
            "task_id": task_id,
            "role": prompt_role(prompt),
            "kind": "attempt",
            "status": status,
            "score": "",
            "lean_gate": "",
            "artifact": rel(prompt),
            "changed_files": changed_files,
            "changed_files_digest": content_digest(changed_files),
            "command": command,
            "notes": f"External agent command exit code {code}.",
            "harness_metrics": harness_metrics,
            "leaf_signature": control.get("leaf_signature", ""),
            "evidence_digest": control.get("evidence_digest", ""),
            "ready_leaf_ids": control.get("ready_leaf_ids", []),
            "search_phase": control.get("search_phase", ""),
            "effective_epsilon": control.get("effective_epsilon", ""),
        },
    )
    refresh_trial_summary_if_bounded()


def latest_task_run_dir(task_id: str) -> Path | None:
    pattern = f"*-{slugify(task_id)}-cycle*"
    candidates = sorted((ROOT / "runs").glob(pattern))
    return candidates[-1] if candidates else None


def control_state_path(task_id: str) -> Path:
    return CONTROL_DIR / f"{slugify(task_id)}.json"


def executable_acceptance_state_path(task_id: str) -> Path:
    return CONTROL_DIR / f"{slugify(task_id)}-executable.json"


def _executable_contract_paths(command: str, artifacts: tuple[str, ...]) -> list[Path]:
    paths: list[Path] = []
    for value in [*shlex.split(command), *artifacts]:
        candidate = (ROOT / value).resolve() if not Path(value).is_absolute() else Path(value).resolve()
        try:
            candidate.relative_to(ROOT)
        except ValueError:
            continue
        if candidate.is_file() and candidate not in paths:
            paths.append(candidate)
    return sorted(paths)


def _executable_contract_digest(command: str, artifacts: tuple[str, ...]) -> str:
    package_versions: dict[str, str] = {}
    for package in ("qiskit", "openqasm3"):
        try:
            package_versions[package] = importlib_metadata.version(package)
        except importlib_metadata.PackageNotFoundError:
            package_versions[package] = "missing"
    return content_digest(
        [
            {"command": command, "artifacts": list(artifacts)},
            {"python": sys.version, "packages": package_versions},
            [
                {
                    "path": rel(path),
                    "size": path.stat().st_size,
                    "sha256": content_digest([path.read_bytes().hex()]),
                }
                for path in _executable_contract_paths(command, artifacts)
            ],
        ]
    )


def verified_task_executable_acceptance(
    task_id: str,
    *,
    task_text: str | None = None,
    run_check: bool = False,
) -> bool:
    """Verify or execute the task-declared post-Lean acceptance gate.

    A successful result is cached against the command source and every declared
    artifact.  Failed unchanged inputs are not rerun, so an agent must make a
    material exporter change before another executable attempt spends time.
    """

    if task_text is None:
        _, task_text = task_context(task_id)
    contract = infer_executable_acceptance(task_text)
    if not contract.command:
        return False
    state_path = executable_acceptance_state_path(task_id)
    cached = load_control_state(state_path)
    current_digest = _executable_contract_digest(contract.command, contract.artifacts)
    artifact_paths = [(ROOT / value).resolve() for value in contract.artifacts]
    artifacts_present = bool(artifact_paths) and all(path.is_file() for path in artifact_paths)
    if (
        int(cached.get("exit_code", 1)) == 0
        and cached.get("input_digest") == current_digest
        and artifacts_present
    ):
        return True
    if not run_check:
        return False
    if cached.get("input_digest") == current_digest and int(cached.get("exit_code", 0)) != 0:
        return False

    argv = shlex.split(contract.command)
    if not argv:
        return False
    try:
        completed = subprocess.run(
            argv,
            cwd=ROOT,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            timeout=900,
        )
        exit_code = completed.returncode
        stdout = completed.stdout
        stderr = completed.stderr
    except (OSError, subprocess.TimeoutExpired) as exc:
        exit_code = 124 if isinstance(exc, subprocess.TimeoutExpired) else 127
        stdout = ""
        stderr = f"{type(exc).__name__}: {exc}"

    artifacts_present = bool(artifact_paths) and all(path.is_file() for path in artifact_paths)
    if exit_code == 0 and not artifacts_present:
        exit_code = 2
        stderr = (stderr + "\nDeclared executable acceptance artifacts are missing.").strip()
    final_digest = _executable_contract_digest(contract.command, contract.artifacts)
    payload = {
        "task_id": task_id,
        "timestamp": now_stamp(),
        "command": contract.command,
        "artifacts": list(contract.artifacts),
        "artifacts_present": artifacts_present,
        "exit_code": exit_code,
        "input_digest": final_digest,
        "stdout_tail": stdout[-8000:],
        "stderr_tail": stderr[-8000:],
        "backend": contract.backend,
        "required": contract.required,
        "evidence_classes": list(contract.evidence_classes),
        "exact_proof_authority": "leanCheckedRefinement" in contract.evidence_classes,
    }
    atomic_write_json(state_path, payload)
    append_jsonl(
        TRIAL_LOG,
        {
            "timestamp": now_stamp(),
            "trial_id": f"{file_stamp()}-{slugify(task_id)}-executable-gate",
            "task_id": task_id,
            "role": "reviewer",
            "kind": "build",
            "status": "accepted" if exit_code == 0 else "failed",
            "score": "",
            "lean_gate": "pass",
            "artifact": rel(state_path),
            "changed_files": [value for value in contract.artifacts if (ROOT / value).is_file()],
            "command": contract.command,
            "notes": "Deterministic post-Lean executable acceptance gate.",
            "verifier_feedback": {
                "leaf": "POST-LEAN-EXPORT",
                "lean_build_ok": True,
                "executable_backend": contract.backend,
                "evidence_classes": list(contract.evidence_classes),
                "qiskit_acceptance_ok": (
                    exit_code == 0 if contract.backend in {"qiskitOperator", "both"} else None
                ),
                "qasm_acceptance_ok": (
                    exit_code == 0 if contract.backend in {"openqasm3RoundTrip", "both"} else None
                ),
                "exact_proof_authority": (
                    exit_code == 0 and "leanCheckedRefinement" in contract.evidence_classes
                ),
                "error_class": "" if exit_code == 0 else "executable_export_gap",
                "next_route": "closeout" if exit_code == 0 else "repair the declared exporter before rerun",
            },
        },
    )
    refresh_trial_summary_if_bounded()
    if stdout.strip():
        print(stdout.strip())
    if stderr.strip():
        print(stderr.strip(), file=sys.stderr)
    return exit_code == 0


def _lean_declaration_fingerprint(text: str, name: str) -> str:
    short_name = name.rsplit(".", 1)[-1]
    start = re.search(
        rf"(?m)^(?:private\s+)?(?:def|abbrev|structure|class|theorem|lemma|opaque)\s+"
        rf"{re.escape(short_name)}\b",
        text,
    )
    if not start:
        return "missing"
    end = re.search(
        r"(?m)^(?:private\s+)?(?:def|abbrev|structure|class|theorem|lemma|opaque|namespace|end)\b",
        text[start.end() :],
    )
    stop = start.end() + end.start() if end else len(text)
    return content_digest([text[start.start() : stop]])


def _lean_declaration_kind(text: str, name: str) -> str:
    short_name = name.rsplit(".", 1)[-1]
    match = re.search(
        rf"(?m)^(?:private\s+)?(def|abbrev|structure|class|theorem|lemma|opaque)\s+"
        rf"{re.escape(short_name)}\b",
        text,
    )
    return match.group(1) if match else ""


def _task_acceptance_declarations(
    task_id: str, task_text: str | None = None
) -> tuple[tuple[str, ...], list[str]]:
    if task_text is None:
        _, task_text = task_context(task_id)
    declared = infer_acceptance_anchors(task_text)
    files = [
        path.read_text(encoding="utf-8", errors="replace")
        for path in lean_index_files_for_task(task_text)
        if path.exists()
    ]
    present = [
        anchor
        for anchor in declared
        if any(_lean_declaration_kind(text, anchor) in {"theorem", "lemma"} for text in files)
    ]
    return declared, present


def verified_task_acceptance_anchors(
    task_id: str, *, task_text: str | None = None
) -> tuple[str, ...]:
    """Return all root anchors only after a successful current-source check."""

    declared, present = _task_acceptance_declarations(task_id, task_text)
    if not declared or len(present) != len(declared):
        return ()
    last_check = load_state().get("last_check") or {}
    if int(last_check.get("exit_code", 1)) != 0:
        return ()
    if last_check.get("lean_workspace_digest") != lean_workspace_digest():
        return ()
    return declared


def task_lean_evidence_digest(
    task_id: str,
    frontier_rows: Sequence[str] = (),
    obligation_rows: Sequence[str] = (),
) -> str:
    """Hash only current Lean targets plus imports, not unrelated file churn."""

    _, task_text = task_context(task_id)
    leaves = classify_leaves(frontier_rows, obligation_rows)
    targets: set[str] = set()
    for leaf in leaves:
        targets.update(
            token
            for token in re.findall(r"[A-Za-z_][A-Za-z0-9_'.]*", leaf.lean_target)
            if token.lower() not in INVALID_LEAN_TARGET_WORDS
        )
    files: list[tuple[Path, str]] = []
    for path in lean_index_files_for_task(task_text):
        if path.exists():
            files.append((path, path.read_text(encoding="utf-8", errors="replace")))
    if not targets:
        return content_digest(
            [{"path": rel(path), "imports": re.findall(r"(?m)^import\s+.+$", text)}
             for path, text in files]
        )
    return content_digest(
        [
            {
                "target": target,
                "files": [
                    {
                        "path": rel(path),
                        "declaration": _lean_declaration_fingerprint(text, target),
                        "imports": re.findall(r"(?m)^import\s+.+$", text),
                    }
                    for path, text in files
                ],
            }
            for target in sorted(targets)
        ]
    )


def verified_closed_lean_leaf_ids(
    task_id: str,
    frontier_rows: Sequence[str],
    obligation_rows: Sequence[str],
    feedback: Sequence[dict[str, object]],
) -> tuple[str, ...]:
    """Return ready leaves backed by both verifier closure and a real declaration."""

    _, task_text = task_context(task_id)
    files = [
        path.read_text(encoding="utf-8", errors="replace")
        for path in lean_index_files_for_task(task_text)
        if path.exists()
    ]
    closed_feedback = {
        str(row.get("leaf", "")).strip().lower()
        for row in feedback
        if row.get("lean_build_ok") is True
        and row.get("closed_theorem_ok") is True
    }
    retired: list[str] = []
    for leaf in classify_leaves(frontier_rows, obligation_rows):
        if not leaf.ready_for_lean or leaf.leaf_id.lower() not in closed_feedback:
            continue
        targets = [
            token
            for token in re.findall(r"[A-Za-z_][A-Za-z0-9_'.]*", leaf.lean_target)
            if token.lower() not in INVALID_LEAN_TARGET_WORDS
        ]
        if targets and any(
            _lean_declaration_kind(text, target) in {"theorem", "lemma"}
            for target in targets
            for text in files
        ):
            retired.append(leaf.leaf_id)
    return tuple(retired)


def cycle_control_decision(args: argparse.Namespace, cycle: int) -> CycleDecision:
    state = blueprint_status_state(args.id)
    all_feedback = recent_verifier_feedback(args.id, limit=100)
    previous = load_control_state(control_state_path(args.id))
    _, task_text = task_context(args.id)
    evaluation_mode = infer_evaluation_mode(task_text)
    feedback = (
        all_feedback
        if evaluation_mode in {"full-abeis", "isolated-abeis"}
        else []
    )
    frontier_rows = state.get("dynamic_leaf_queue", [])
    obligation_rows = state.get("open_obligation_signals", [])
    allowed_routes, forbidden_routes = infer_route_lock(task_text)
    executable = infer_executable_acceptance(task_text)
    decision = decide_cycle(
        task_id=args.id,
        cycle=cycle,
        frontier_rows=frontier_rows,
        obligation_rows=obligation_rows,
        feedback=feedback,
        evidence_digest=task_lean_evidence_digest(
            args.id, frontier_rows, obligation_rows
        ),
        previous_state=previous,
        max_no_progress_cycles=max(
            1,
            int(getattr(args, "max_no_progress_cycles", DEFAULT_MAX_NO_PROGRESS_CYCLES)),
        ),
        max_external_gap_cycles=max(
            1,
            int(getattr(args, "max_external_gap_cycles", DEFAULT_MAX_EXTERNAL_GAP_CYCLES)),
        ),
        task_kind=infer_task_kind(task_text),
        epsilon_ladder=infer_epsilon_ladder(task_text),
        exact_stall_cycles=max(
            1,
            int(getattr(args, "exact_stall_cycles", DEFAULT_EXACT_STALL_CYCLES)),
        ),
        allowed_leaf_prefixes=allowed_routes,
        forbidden_leaf_prefixes=forbidden_routes,
        verified_closed_leaf_ids=verified_closed_lean_leaf_ids(
            args.id, frontier_rows, obligation_rows, all_feedback
        ),
        verified_root_anchors=verified_task_acceptance_anchors(
            args.id, task_text=task_text
        ),
        executable_acceptance_required=executable.required,
        executable_acceptance_complete=verified_task_executable_acceptance(
            args.id, task_text=task_text
        ),
        executable_acceptance_command=executable.command,
        executable_acceptance_artifacts=executable.artifacts,
        executable_check_backend=executable.backend,
        executable_evidence_classes=executable.evidence_classes,
        lean_acceptance_required=bool(infer_acceptance_anchors(task_text)),
        population_gate_required=(
            evaluation_mode in {"full-abeis", "isolated-abeis"}
            and infer_population_gate(task_text)
        ),
        evaluation_mode=evaluation_mode,
    )
    write_control_state(control_state_path(args.id), decision)
    if not decision.stop:
        population_path = ROOT / "candidate-populations" / args.id / "population-state.json"
        atomic_write_json(
            population_path,
            {
                "task_id": args.id,
                "cycle": cycle,
                "evaluation_mode": decision.evaluation_mode,
                "gate_required": decision.population_gate_required,
                "digest": decision.population_digest,
                "active_candidate_ids": list(decision.population_active_candidate_ids),
                "selected_candidate_ids": list(decision.population_selected_candidate_ids),
                "direction": decision.population_direction,
                "invalid_packets": list(decision.population_invalid_packets),
            },
        )
    intervention = CONTROL_DIR / f"{slugify(args.id)}-intervention.md"
    if not decision.stop and intervention.exists():
        intervention.unlink()
    return decision


def control_policy_note(decision: CycleDecision) -> str:
    note = (
        f"Controller mode: `{decision.mode}`. Evaluation mode: "
        f"`{decision.evaluation_mode}`. Status: `{decision.status}`. "
        f"Leaf signature: `{decision.leaf_signature}`. Evidence digest: "
        f"`{decision.evidence_digest}`. Ready leaves: "
        f"{', '.join(decision.ready_leaf_ids) or 'none'}. Reason: {decision.reason} "
        f"Capacity levels (upper, middle, lower)=({decision.upper_capacity_level}, "
        f"{decision.middle_capacity_level}, {decision.lower_capacity_level}). "
        f"Search phase: `{decision.search_phase}`; effective epsilon: "
        f"`{decision.effective_epsilon}`; historical ladder position: "
        f"`{decision.active_epsilon}`; ladder: "
        f"{', '.join(decision.epsilon_ladder) or 'not declared'}. "
        "A privileged decision may increase each layer by at most one level and "
        "may move tolerance by only one adjacent rung. It is valid only when "
        "typed verifier feedback repeats this exact leaf signature and evidence digest."
    )
    if decision.route_rejected_leaf_ids:
        note += (
            " Route-lock rejected leaves: "
            + ", ".join(decision.route_rejected_leaf_ids)
            + ". These leaves cannot schedule lower agents."
        )
    if decision.certified_root_anchors:
        note += (
            " Certified root anchors: "
            + ", ".join(decision.certified_root_anchors)
            + "."
        )
    if decision.executable_acceptance_required:
        note += (
            f" Executable gate complete={decision.executable_acceptance_complete}; "
            f"command=`{decision.executable_acceptance_command}`; artifacts="
            f"{', '.join(decision.executable_acceptance_artifacts) or 'none'}."
        )
    if decision.population_gate_required:
        note += (
            " Population direction: "
            + (decision.population_direction or "unselected")
            + "; active candidates: "
            + (", ".join(decision.population_active_candidate_ids) or "none")
            + "."
        )
    if decision.policy_rejections:
        note += " Rejected policy request: " + " ".join(decision.policy_rejections)
    if decision.prerequisite_leaf_ids:
        note += (
            " Frozen structural prerequisites: "
            + ", ".join(decision.prerequisite_leaf_ids)
            + "; classes: "
            + (", ".join(decision.prerequisite_error_classes) or "unspecified")
            + "."
        )
    return note


def write_control_intervention(task_id: str, decision: CycleDecision, detail: str = "") -> Path:
    path = CONTROL_DIR / f"{slugify(task_id)}-intervention.md"
    path.parent.mkdir(parents=True, exist_ok=True)
    choices = ""
    if decision.external_leaf_ids:
        choices = """
## Required dependency decision

Choose exactly one route before resuming:

1. prove a named local replacement lemma;
2. add and pin a dependency that provides the exact theorem;
3. record an explicit theorem-facing contract and remove it from the local proof queue; or
4. provide the missing mathematical/source decision as human input.
"""
    atomic_write_text(
        path,
        f"""# ABEIS control intervention: {task_id}

- mode: `{decision.mode}`
- evaluation mode: `{decision.evaluation_mode}`
- status: `{decision.status}`
- cycle: `{decision.cycle}`
- leaf signature: `{decision.leaf_signature}`
- Lean evidence digest: `{decision.evidence_digest}`
- unchanged cycles: `{decision.unchanged_cycles}`
- external-gap cycles: `{decision.external_gap_cycles}`
- capacity levels (upper/middle/lower): `{decision.upper_capacity_level}/{decision.middle_capacity_level}/{decision.lower_capacity_level}`
- search phase: `{decision.search_phase}`
- effective epsilon: `{decision.effective_epsilon}`
- historical ladder position: `{decision.active_epsilon}`
- epsilon ladder: `{', '.join(decision.epsilon_ladder) or 'not declared'}`
- ready leaves: `{', '.join(decision.ready_leaf_ids) or 'none'}`
- external leaves: `{', '.join(decision.external_leaf_ids) or 'none'}`
- unresolved leaves: `{', '.join(decision.unresolved_leaf_ids) or 'none'}`
- structural prerequisite leaves: `{', '.join(decision.prerequisite_leaf_ids) or 'none'}`
- structural error classes: `{', '.join(decision.prerequisite_error_classes) or 'none'}`

## Stop reason

{decision.reason}

{detail or 'No model call was started after this stop decision.'}
{choices}
## Resume condition

Update the current proof-DAG/obligation state or task-relevant Lean evidence.
The next `sleep-run` will recompute the signature and resume only when the
blocking state has materially changed.
""",
        encoding="utf-8",
    )
    print(f"wrote {rel(path)}")
    return path


def runtime_stop_decision(decision: CycleDecision, reason: str) -> CycleDecision:
    return CycleDecision(
        task_id=decision.task_id,
        cycle=decision.cycle,
        mode="human_blocked",
        status="blocked",
        reason=reason,
        leaf_signature=decision.leaf_signature,
        evidence_digest=decision.evidence_digest,
        ready_leaf_ids=decision.ready_leaf_ids,
        external_leaf_ids=decision.external_leaf_ids,
        unresolved_leaf_ids=decision.unresolved_leaf_ids,
        route_rejected_leaf_ids=decision.route_rejected_leaf_ids,
        prompt_plan=(),
        capacity_authorizations=decision.capacity_authorizations,
        unchanged_cycles=decision.unchanged_cycles,
        external_gap_cycles=decision.external_gap_cycles,
        stop=True,
        task_kind=decision.task_kind,
        upper_capacity_level=decision.upper_capacity_level,
        middle_capacity_level=decision.middle_capacity_level,
        lower_capacity_level=decision.lower_capacity_level,
        search_phase=decision.search_phase,
        epsilon_ladder=decision.epsilon_ladder,
        epsilon_index=decision.epsilon_index,
        active_epsilon=decision.active_epsilon,
        effective_epsilon=decision.effective_epsilon,
        auto_retired_leaf_ids=decision.auto_retired_leaf_ids,
        certified_root_anchors=decision.certified_root_anchors,
        policy_decision_digest=decision.policy_decision_digest,
        policy_transition_applied=decision.policy_transition_applied,
        policy_rejections=decision.policy_rejections,
        lean_acceptance_complete=decision.lean_acceptance_complete,
        executable_acceptance_required=decision.executable_acceptance_required,
        executable_acceptance_complete=decision.executable_acceptance_complete,
        executable_acceptance_command=decision.executable_acceptance_command,
        executable_acceptance_artifacts=decision.executable_acceptance_artifacts,
        population_gate_required=decision.population_gate_required,
        population_digest=decision.population_digest,
        population_active_candidate_ids=decision.population_active_candidate_ids,
        population_selected_candidate_ids=decision.population_selected_candidate_ids,
        population_direction=decision.population_direction,
        population_invalid_packets=decision.population_invalid_packets,
        prerequisite_leaf_ids=decision.prerequisite_leaf_ids,
        prerequisite_error_classes=decision.prerequisite_error_classes,
        evaluation_mode=decision.evaluation_mode,
    )


def controlled_prompt_stages(
    run_dir: Path,
    decision: CycleDecision,
    *,
    game_harness: bool,
    upper_panel: bool,
    middle_panel: bool,
    parallel_panels: bool,
    parallel_lower: bool,
    include_reviewer: bool,
) -> list[tuple[list[Path], bool]]:
    """Translate a controller plan into dependency-ordered prompt stages."""

    stages: list[tuple[list[Path], bool]] = []
    for item in decision.prompt_plan:
        if item == "upper":
            stages.extend(
                (stage, parallel_panels)
                for stage in upper_prompt_stages(run_dir, upper_panel, game_harness)
            )
        elif item == "middle":
            stages.extend(
                (stage, parallel_panels)
                for stage in middle_prompt_stages(run_dir, middle_panel, game_harness)
            )
        elif item == "lower1":
            path = run_dir / ("31_nl_lower_1.md" if game_harness else "30_lower_searcher_1.md")
            if path.exists():
                stages.append(([path], False))
        elif item == "lower2":
            path = run_dir / ("32_lean_lower_1.md" if game_harness else "30_lower_searcher_2.md")
            if path.exists():
                stages.append(([path], False))
        elif item == "lower3" and not game_harness:
            path = run_dir / "30_lower_searcher_3.md"
            if path.exists():
                stages.append(([path], False))
        elif item == "lower4" and not game_harness:
            path = run_dir / "30_lower_searcher_4.md"
            if path.exists():
                stages.append(([path], False))
        elif item == "lower_aux" and not game_harness:
            prompts = sorted(run_dir.glob("30_lower_searcher_*.md"))[4:]
            if prompts:
                stages.append((prompts, parallel_lower))
        elif item == "exporter":
            path = run_dir / "30_lower_exporter.md"
            if path.exists():
                stages.append(([path], False))
        elif item == "reviewer" and include_reviewer:
            path = run_dir / "40_reviewer.md"
            if path.exists():
                stages.append(([path], False))
    return stages


def selected_prompt_token_counts(
    stage_specs: list[tuple[list[Path], bool]],
) -> dict[str, int]:
    counts: dict[str, int] = {}
    for prompts, _ in stage_specs:
        for prompt in prompts:
            if prompt.exists():
                counts[rel(prompt)] = approx_token_count(prompt.read_text(encoding="utf-8"))
    return counts


def prune_task_run_dirs(task_id: str, keep: int) -> int:
    if keep <= 0:
        return 0
    candidates = sorted(
        path
        for path in (ROOT / "runs").glob(f"*-{slugify(task_id)}-cycle*")
        if path.is_dir()
    )
    removed = 0
    for path in candidates[:-keep]:
        shutil.rmtree(path)
        removed += 1
    if removed:
        print(f"pruned {removed} old generated run directories for {task_id}; retained {keep}")
    return removed


def adaptive_state_text(task_id: str, *, include_task: bool = True) -> str:
    """Compact text used by the sleep-run capacity controller."""
    parts: list[str] = []
    if include_task:
        for path in [
            ROOT / "tasks" / f"{task_id}.md",
            BLUEPRINT_DIR / f"{task_id}.md",
        ]:
            if path.exists():
                parts.append(path.read_text(encoding="utf-8", errors="ignore")[-12000:])
    retrieval = RETRIEVAL_INDEX_DIR / f"{task_id}.json"
    if retrieval.exists():
        parts.append(retrieval.read_text(encoding="utf-8", errors="ignore")[-12000:])
    latest = latest_task_run_dir(task_id)
    if latest is not None:
        for name in ["memory_digest.md", "todo.md", "dialogue.md"]:
            path = latest / name
            if path.exists():
                parts.append(path.read_text(encoding="utf-8", errors="ignore")[-8000:])
    return "\n\n".join(parts)


def adaptive_capacity_for_cycle(
    args: argparse.Namespace,
    cycle: int,
    decision: CycleDecision | None = None,
) -> dict[str, object]:
    """Choose capacity only from the current executable state.

    Stagnation text is evidence of a problem, not authorization to spend more
    tokens.  Expansion and epsilon/exploration changes require typed feedback
    signed with the controller's current leaf and Lean-evidence digests.
    """

    authorizations = set(decision.capacity_authorizations if decision else ())
    upper_level = decision.upper_capacity_level if decision else 0
    middle_level = decision.middle_capacity_level if decision else 0
    lower_level = decision.lower_capacity_level if decision else 0
    expanded = bool(upper_level or middle_level or lower_level)
    phase = decision.search_phase if decision else "exact"
    max_hier_lower = max(0, int(getattr(args, "lower_count", DEFAULT_LOWER_COUNT)))
    natural_max = max(0, int(getattr(args, "natural_lower_count", DEFAULT_NATURAL_LOWER_COUNT)))
    lean_max = max(0, int(getattr(args, "lean_lower_count", DEFAULT_LEAN_LOWER_COUNT)))

    effective_lower = min(max_hier_lower, DEFAULT_ADAPTIVE_BASE_LOWER_COUNT)
    natural_lower_count = min(natural_max, 1)
    lean_lower_count = min(lean_max, 1)
    upper_panel = False
    middle_panel = False
    upper_specialist_count = 0
    middle_specialist_count = 0
    parallel_panels = False
    capacity_label = "state-gated-small"

    if decision and decision.mode == "execute":
        effective_lower = min(max_hier_lower, max(2, effective_lower)) if max_hier_lower > 0 else 0
        if "lower3" in decision.prompt_plan and max_hier_lower > 0:
            effective_lower = min(max_hier_lower, max(3, effective_lower))
        if lower_level > 0:
            effective_lower = min(max_hier_lower, max(effective_lower, 3 + lower_level))
            natural_lower_count = min(natural_max, 1 + lower_level)
            lean_lower_count = min(lean_max, 1 + lower_level)
            capacity_label = "authorized-gradual-lower-expansion"
    elif decision and decision.mode in {
        "dependency_decision",
        "decompose",
        "phase_decision",
        "population",
        "export",
    }:
        effective_lower = 0
        natural_lower_count = 0
        lean_lower_count = 0
        upper_specialist_count = min(3, upper_level)
        middle_specialist_count = min(3, middle_level)
        upper_panel = upper_specialist_count > 0
        middle_panel = middle_specialist_count > 0
        parallel_panels = bool(
            (upper_panel or middle_panel)
            and getattr(args, "parallel_panels", DEFAULT_PARALLEL_PANELS)
        )
        capacity_label = "bounded-decision"

    note = (
        f"Adaptive capacity `{capacity_label}`. Phase target: `{phase}`. "
        f"Effective lower_count={effective_lower}; natural_lower_count={natural_lower_count}; "
        f"lean_lower_count={lean_lower_count}; upper_panel={upper_panel}; "
        f"middle_panel={middle_panel}; upper_specialists={upper_specialist_count}; "
        f"middle_specialists={middle_specialist_count}. "
    )
    if decision:
        note += control_policy_note(decision) + " "
    if authorizations:
        note += "Current signed capacity authorizations: " + ", ".join(sorted(authorizations)) + ". "
    else:
        note += "No signed capacity increase is active. "
    if phase.startswith("approximate"):
        note += (
            f"Approximate search is active only at epsilon={decision.effective_epsilon if decision else 'unknown'}; "
            "the next relaxation requires a new signed decision after an unchanged cycle."
        )
    elif phase == "dependency":
        note += (
            "The tolerance ladder is inactive while the task is waiting on a dependency decision; "
            "no lower agents or epsilon relaxation may be scheduled."
        )
    elif phase == "post_lean_export":
        note += "Lean is closed; only the declared executable exporter and reviewer gate may run."
    else:
        note += "Stagnation alone must never expand panels or relax epsilon."

    return {
        "lower_count": effective_lower,
        "upper_panel": upper_panel,
        "middle_panel": middle_panel,
        "upper_specialist_count": upper_specialist_count,
        "middle_specialist_count": middle_specialist_count,
        "parallel_panels": parallel_panels,
        "natural_lower_count": natural_lower_count,
        "lean_lower_count": lean_lower_count,
        "note": note,
        "phase": phase,
        "expanded": expanded,
    }


def _cmd_sleep_run_impl(args: argparse.Namespace) -> int:
    cmd_init(argparse.Namespace())
    if getattr(args, "reset_control_state", False):
        for path in [
            control_state_path(args.id),
            executable_acceptance_state_path(args.id),
            CONTROL_DIR / f"{slugify(args.id)}-intervention.md",
        ]:
            if path.exists():
                path.unlink()
        print(f"reset persistent controller state for {args.id}")
    profile_commands = load_agent_command_profile(args.agent_profile, args.agent_cmd_file)
    if args.execute and not args.agent_cmd and not profile_commands:
        raise SystemExit("--execute requires --agent-cmd or --agent-profile/--agent-cmd-file")
    if args.dry_run and args.execute:
        raise SystemExit("--dry-run and --execute cannot be used together")
    if args.upper_every < 0 or args.middle_every < 0 or args.reviewer_every < 0:
        raise SystemExit("--upper-every, --middle-every, and --reviewer-every must be nonnegative")
    _, task_text = task_context(args.id)
    declared_anchors, present_anchors = _task_acceptance_declarations(
        args.id, task_text
    )
    if (
        declared_anchors
        and len(present_anchors) == len(declared_anchors)
        and not verified_task_acceptance_anchors(args.id, task_text=task_text)
    ):
        print("root acceptance anchors are present; running one deterministic preflight check")
        code = cmd_check(argparse.Namespace())
        if code != 0:
            return code
    if verified_task_acceptance_anchors(args.id, task_text=task_text):
        executable = infer_executable_acceptance(task_text)
        if executable.command:
            verified_task_executable_acceptance(
                args.id, task_text=task_text, run_check=True
            )
    final_code = 0
    batch_started = time.perf_counter()
    active_budget_s = max(0.0, float(args.active_budget_minutes)) * 60.0

    def active_budget_reached() -> bool:
        return active_budget_s > 0 and (time.perf_counter() - batch_started) >= active_budget_s

    previous_cycle = int(load_control_state(control_state_path(args.id)).get("cycle", 0))
    for cycle in range(previous_cycle + 1, previous_cycle + args.cycles + 1):
        if args.blueprint_refresh:
            refresh_blueprint(args.id)
        if verified_task_acceptance_anchors(args.id, task_text=task_text):
            executable = infer_executable_acceptance(task_text)
            if executable.command:
                verified_task_executable_acceptance(
                    args.id, task_text=task_text, run_check=True
                )
        decision = cycle_control_decision(args, cycle)
        if decision.stop:
            if decision.status == "complete":
                print(f"controller closeout: {decision.reason}")
                return 0
            write_control_intervention(args.id, decision)
            return CONTROL_STOP_EXIT_CODE
        if getattr(args, "adaptive_capacity", True):
            effective = adaptive_capacity_for_cycle(args, cycle, decision)
            cycle_lower_count = int(effective["lower_count"])
            cycle_upper_panel = bool(effective["upper_panel"])
            cycle_middle_panel = bool(effective["middle_panel"])
            cycle_upper_specialist_count = int(effective["upper_specialist_count"])
            cycle_middle_specialist_count = int(effective["middle_specialist_count"])
            cycle_parallel_panels = bool(effective["parallel_panels"])
            cycle_natural_lower_count = int(effective["natural_lower_count"])
            cycle_lean_lower_count = int(effective["lean_lower_count"])
            harness_policy_note = str(effective["note"])
        else:
            cycle_lower_count = args.lower_count
            cycle_upper_panel = args.upper_panel
            cycle_middle_panel = args.middle_panel
            cycle_upper_specialist_count = 3 if cycle_upper_panel else 0
            cycle_middle_specialist_count = 3 if cycle_middle_panel else 0
            cycle_parallel_panels = args.parallel_panels
            cycle_natural_lower_count = getattr(args, "natural_lower_count", DEFAULT_NATURAL_LOWER_COUNT)
            cycle_lean_lower_count = getattr(args, "lean_lower_count", DEFAULT_LEAN_LOWER_COUNT)
            harness_policy_note = (
                "Fixed-capacity sleep-run: adaptive capacity is disabled, so CLI "
                "panel and lower-agent counts are used within the controller's "
                "ready-leaf and signed-capacity gates."
            )
        authorizations = set(decision.capacity_authorizations)
        if decision.mode == "execute":
            cycle_upper_panel = False
            cycle_middle_panel = False
            cycle_upper_specialist_count = 0
            cycle_middle_specialist_count = 0
            cycle_parallel_panels = False
            if cycle_lower_count > 0:
                cycle_lower_count = max(2, cycle_lower_count)
                if "lower3" in decision.prompt_plan:
                    cycle_lower_count = max(3, cycle_lower_count)
        else:
            cycle_lower_count = 0
            cycle_natural_lower_count = 0
            cycle_lean_lower_count = 0
            cycle_upper_panel = cycle_upper_panel and decision.upper_capacity_level > 0
            cycle_middle_panel = cycle_middle_panel and decision.middle_capacity_level > 0
            cycle_parallel_panels = cycle_parallel_panels and bool(
                cycle_upper_panel or cycle_middle_panel
            )
        harness_policy_note += " " + control_policy_note(decision)
        run_dir = create_run_cycle(
            args.id,
            cycle,
            cycle_lower_count,
            context_mode=args.context_mode,
            blueprint_refresh=False,
            upper_panel=cycle_upper_panel,
            middle_panel=cycle_middle_panel,
            game_harness=getattr(args, "game_harness", DEFAULT_GAME_HARNESS),
            natural_lower_count=cycle_natural_lower_count,
            lean_lower_count=cycle_lean_lower_count,
            harness_policy_note=harness_policy_note,
            upper_specialist_count=cycle_upper_specialist_count,
            middle_specialist_count=cycle_middle_specialist_count,
        )
        print(f"cycle {cycle}: {rel(run_dir)}")
        include_reviewer = (
            not args.skip_reviewer
            and args.reviewer_every > 0
            and (cycle - 1) % args.reviewer_every == 0
        )
        stage_specs = controlled_prompt_stages(
            run_dir,
            decision,
            game_harness=getattr(args, "game_harness", DEFAULT_GAME_HARNESS),
            upper_panel=cycle_upper_panel,
            middle_panel=cycle_middle_panel,
            parallel_panels=cycle_parallel_panels,
            parallel_lower=bool(args.parallel_lower),
            include_reviewer=include_reviewer,
        )
        upper_due = args.upper_every > 0 and (cycle - 1) % args.upper_every == 0
        middle_due = args.middle_every > 0 and (cycle - 1) % args.middle_every == 0
        stage_specs = [
            (stage, parallel)
            for stage, parallel in stage_specs
            if not stage
            or (prompt_role(stage[0]) != "upper" or upper_due)
            and (prompt_role(stage[0]) != "middle" or middle_due)
        ]
        prompt_tokens = selected_prompt_token_counts(stage_specs)
        run_state = load_control_state(control_state_path(args.id))
        run_tokens_used = int(run_state.get("estimated_run_input_tokens", 0) or 0)
        budget_issue = prompt_budget_violation(
            prompt_tokens,
            max_prompt_tokens=max(0, int(args.max_prompt_tokens)),
            max_cycle_tokens=max(0, int(args.max_cycle_input_tokens)),
            run_tokens_used=run_tokens_used,
            max_run_tokens=max(0, int(args.max_run_input_tokens)),
        )
        atomic_write_json(
            run_dir / "control_decision.json",
            {
                **decision.to_dict(),
                "selected_prompt_tokens": prompt_tokens,
                "estimated_cycle_input_tokens": sum(prompt_tokens.values()),
                "estimated_run_input_tokens_before_cycle": run_tokens_used,
                "budget_issue": budget_issue,
            },
        )
        if budget_issue:
            stopped = runtime_stop_decision(decision, budget_issue)
            write_control_state(control_state_path(args.id), stopped)
            write_control_intervention(
                args.id,
                stopped,
                detail="The prompt deck was measured locally and rejected before any model call.",
            )
            return CONTROL_STOP_EXIT_CODE
        has_agent_template = bool(args.agent_cmd or profile_commands)
        if args.dry_run or not has_agent_template:
            print("dry run: prompt deck created, no external agent command executed")
            prune_task_run_dirs(args.id, int(args.retain_run_dirs))
            continue
        if not args.execute:
            print("agent command configured but not executed; pass --execute to run it")
            prune_task_run_dirs(args.id, int(args.retain_run_dirs))
            continue
        write_control_state(
            control_state_path(args.id),
            decision,
            estimated_input_tokens=sum(prompt_tokens.values()),
        )
        cycle_code = 0
        for stage, parallel in stage_specs:
            cycle_code = execute_prompt_stage(
                stage,
                profile_commands,
                args.agent_cmd,
                run_dir,
                args.id,
                cycle,
                parallel,
            )
            if cycle_code != 0:
                break
        if cycle_code == PROVIDER_BLOCKED_EXIT_CODE:
            blocked_state = provider_blocked_control_state(
                load_control_state(control_state_path(args.id)),
                previous_cycle=previous_cycle,
                run_tokens_used=run_tokens_used,
            )
            atomic_write_json(control_state_path(args.id), blocked_state)
            atomic_write_json(
                run_dir / "provider-blocked.json",
                {
                    "task_id": args.id,
                    "attempted_cycle": cycle,
                    "exit_code": cycle_code,
                    "model_work_accepted": False,
                    "build_gate_skipped": True,
                    "reason": blocked_state["reason"],
                },
            )
            print(blocked_state["reason"], file=sys.stderr)
            return cycle_code
        if cycle_code != 0:
            final_code = cycle_code
        if args.check_each_cycle:
            before_build_snapshot = git_worktree_snapshot()
            code = cmd_check(argparse.Namespace())
            append_jsonl(
                TRIAL_LOG,
                {
                    "timestamp": now_stamp(),
                    "trial_id": f"{run_dir.name}-build-gate",
                    "task_id": args.id,
                    "role": "reviewer",
                    "kind": "build",
                    "status": "compiled" if code == 0 else "failed",
                    "score": "",
                    "lean_gate": "pass" if code == 0 else "fail",
                    "artifact": rel(run_dir),
                    "changed_files": git_changed_files_since(before_build_snapshot),
                    "command": "lake build && lake build Tests",
                    "notes": "Cycle build gate.",
                },
            )
            refresh_trial_summary_if_bounded()
            if code != 0:
                write_cycle_summary(args.id, cycle, run_dir, args.report_language)
                write_memory_refresh(args.id, cycle, run_dir)
                write_cycle_pro_prompt(args.id, cycle, run_dir)
                if not args.skip_article_update:
                    write_sleep_closeout_export(args, cycle, run_dir)
                prune_task_run_dirs(args.id, int(args.retain_run_dirs))
                return code
        closeout_this_cycle = cycle == args.cycles or active_budget_reached() or final_code != 0
        if args.summary_each_cycle or closeout_this_cycle:
            write_cycle_summary(args.id, cycle, run_dir, args.report_language)
        write_memory_refresh(args.id, cycle, run_dir)
        if closeout_this_cycle:
            write_cycle_pro_prompt(args.id, cycle, run_dir)
        write_article_this_cycle = args.article_update_each_cycle or closeout_this_cycle
        if not args.skip_article_update and write_article_this_cycle:
            write_sleep_closeout_export(args, cycle, run_dir)
        prune_task_run_dirs(args.id, int(args.retain_run_dirs))
        if active_budget_reached():
            append_jsonl(
                TRIAL_LOG,
                {
                    "timestamp": now_stamp(),
                    "trial_id": f"{run_dir.name}-active-budget-closeout",
                    "task_id": args.id,
                    "role": "upper",
                    "kind": "review",
                    "status": "accepted",
                    "score": "",
                    "lean_gate": "",
                    "artifact": rel(run_dir),
                    "changed_files": git_changed_files(),
                    "command": f"sleep-run --active-budget-minutes {args.active_budget_minutes}",
                    "notes": "Active-time budget reached after completing the current cycle; closeout summary, memory refresh, Pro prompt, and export were written.",
                },
            )
            refresh_trial_summary_if_bounded()
            break
        if final_code != 0:
            return final_code
    return final_code


def cmd_sleep_run(args: argparse.Namespace) -> int:
    previous_handlers = {
        signum: signal.getsignal(signum)
        for signum in (signal.SIGINT, signal.SIGTERM)
    }

    def interrupt_handler(signum: int, _frame: object) -> None:
        terminate_active_agent_processes()
        raise InterruptedError(f"sleep-run interrupted by signal {signum}")

    for signum in previous_handlers:
        signal.signal(signum, interrupt_handler)
    try:
        lease_path = CONTROL_DIR / f"{slugify(args.id)}-sleep-run.lease"
        try:
            with file_lock(lease_path, timeout=0):
                return _cmd_sleep_run_impl(args)
        except LockUnavailable:
            print(
                f"another sleep-run already owns task {args.id}; "
                "duplicate dispatch was not started",
                file=sys.stderr,
            )
            return CONTROL_STOP_EXIT_CODE
    except (KeyboardInterrupt, InterruptedError) as exc:
        state_path = control_state_path(args.id)
        state = load_control_state(state_path)
        state.update(
            {
                "status": "interrupted",
                "stop": True,
                "reason": str(exc),
                "interrupted_at": now_stamp(),
            }
        )
        atomic_write_json(state_path, state)
        print(str(exc), file=sys.stderr)
        return 130
    finally:
        terminate_active_agent_processes()
        for signum, handler in previous_handlers.items():
            signal.signal(signum, handler)


def cmd_agent_note(args: argparse.Namespace) -> int:
    cmd_init(argparse.Namespace())
    if args.run_id == "latest":
        run_dir = latest_run_dir()
        if run_dir is None:
            raise SystemExit("no run directories found")
    else:
        run_dir = ROOT / "runs" / args.run_id
    if not run_dir.exists():
        raise SystemExit(f"run directory not found: {rel(run_dir)}")
    message = args.message
    if args.file:
        message = read_text(Path(args.file))
    if not message:
        raise SystemExit("agent-note requires --message or --file")
    board = run_dir / "dialogue.md"
    append_text_locked(
        board,
        f"\n## {now_stamp()} - {args.role}\n\n{message.strip()}\n",
    )
    add_manifest("qbe.py agent-note", board, "dialogue", f"Appended {args.role} note")
    print(f"updated {rel(board)}")
    return 0


CASE_STATES = {"draft", "pendingReview", "executable-screened", "verified", "rejected"}
SECRET_FIELD = re.compile(r"(?:api[_-]?key|authorization|cookie|password|token)", re.I)


def _case_contains_secret(value: object, path: str = "") -> str | None:
    if isinstance(value, dict):
        for key, item in value.items():
            child = f"{path}.{key}" if path else str(key)
            if SECRET_FIELD.search(str(key)):
                return child
            found = _case_contains_secret(item, child)
            if found:
                return found
    elif isinstance(value, list):
        for index, item in enumerate(value):
            found = _case_contains_secret(item, f"{path}[{index}]")
            if found:
                return found
    return None


def canonical_case_hash(packet: dict[str, object]) -> str:
    mathematics = packet.get("mathematics", {})
    identity = {
        "kind": packet.get("kind"),
        "target": str(mathematics.get("target", "")).strip(),
        "normalizer": str(mathematics.get("normalizer", "")).strip(),
        "projector": str(mathematics.get("projector", "")).strip(),
        "epsilon": str(mathematics.get("epsilon", "")).strip(),
        "semantic_tier": str(mathematics.get("semantic_tier", "")).strip(),
    }
    encoded = json.dumps(identity, sort_keys=True, separators=(",", ":")).encode()
    return hashlib.sha256(encoded).hexdigest()


def validate_case_packet(packet: dict[str, object], *, promotion: bool = False) -> None:
    required = {
        "schema_version", "id", "title", "kind", "status", "mathematics",
        "lean", "provenance", "contributor", "verification", "executable",
        "resource", "license", "reuse_consent", "case_hash",
    }
    missing = sorted(required - packet.keys())
    if missing:
        raise ValueError(f"missing required fields: {', '.join(missing)}")
    if packet["schema_version"] != "2.0":
        raise ValueError("only contribution schema 2.0 is accepted")
    if packet["status"] not in CASE_STATES:
        raise ValueError(f"invalid integration state: {packet['status']}")
    if packet["kind"] not in {"statePreparation", "operatorBlockEncoding"}:
        raise ValueError("kind must be statePreparation or operatorBlockEncoding")
    secret = _case_contains_secret(packet)
    if secret:
        raise ValueError(f"credential-like field is forbidden: {secret}")
    if packet.get("case_hash") != canonical_case_hash(packet):
        raise ValueError("case_hash differs from canonical mathematical identity")
    if packet.get("license") != {"spdx": "MIT", "agreed": True}:
        raise ValueError("MIT license consent is required")
    consent = packet.get("reuse_consent", {})
    if consent.get("public_repository") is not True:
        raise ValueError("public repository consent is required")
    if promotion:
        if packet["status"] not in {"pendingReview", "executable-screened"}:
            raise ValueError("only reviewed cases can be promoted")
        if packet["verification"].get("accepted") is not True:
            raise ValueError("promotion requires accepted compiler evidence")
        if not str(packet["lean"].get("root", "")).strip():
            raise ValueError("promotion requires a named Lean root")
        executable = packet["executable"]
        if executable.get("advertised") and executable.get("accepted") is not True:
            raise ValueError("advertised executable evidence has not passed")


def cmd_ingest_case(args: argparse.Namespace) -> int:
    if not args.review_only:
        print("ingest-case is review-only; pass --review-only", file=sys.stderr)
        return 2
    source = Path(args.path).expanduser().resolve()
    packet = json.loads(source.read_text(encoding="utf-8"))
    try:
        validate_case_packet(packet)
    except ValueError as error:
        print(f"case packet rejected: {error}", file=sys.stderr)
        return 1
    packet["status"] = "pendingReview"
    destination = ROOT / "reports" / "case-review" / f"{slugify(str(packet['id']))}.json"
    destination.parent.mkdir(parents=True, exist_ok=True)
    atomic_write_json(destination, packet)
    print(f"review packet created: {rel(destination)}")
    print("not added to public retrieval memory")
    return 0


def cmd_promote_case(args: argparse.Namespace) -> int:
    source = ROOT / "reports" / "case-review" / f"{slugify(args.case_id)}.json"
    if not source.exists():
        print(f"review packet not found: {rel(source)}", file=sys.stderr)
        return 1
    packet = json.loads(source.read_text(encoding="utf-8"))
    try:
        validate_case_packet(packet, promotion=True)
    except ValueError as error:
        print(f"promotion refused: {error}", file=sys.stderr)
        return 1
    if packet["lean"].get("root") != args.lean_root:
        print("promotion refused: --lean-root differs from packet root", file=sys.stderr)
        return 1
    for command in (
        ["lake", "build"],
        ["lake", "build", "ABEISTests"],
        [sys.executable, "tools/replay_public_cases.py"],
        [sys.executable, "scripts/generate-blueprint-catalog.py"],
    ):
        result = subprocess.run(command, cwd=ROOT, check=False)
        if result.returncode:
            print(f"promotion refused: gate failed: {shlex.join(command)}", file=sys.stderr)
            return result.returncode
    inventory = json.loads((ROOT / "web/library/declarations.json").read_text(encoding="utf-8"))
    names = {item["fullName"] for item in inventory["declarations"]}
    if args.lean_root not in names:
        print("promotion refused: Lean root absent from generated inventory", file=sys.stderr)
        return 1
    packet["status"] = "verified"
    destination = ROOT / "website" / "community" / "verified-cases" / source.name
    destination.parent.mkdir(parents=True, exist_ok=True)
    atomic_write_json(destination, packet)
    print(f"verified case staged for repository review: {rel(destination)}")
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="ABEIS quantum construction project helper")
    sub = parser.add_subparsers(dest="cmd", required=True)

    sub.add_parser("init", help="initialize QBE workflow files").set_defaults(func=cmd_init)
    sub.add_parser("check", help="run Lean build gates").set_defaults(func=cmd_check)
    sub.add_parser(
        "harness-check",
        help="run deterministic lifecycle, concurrency, memory, and controller tests",
    ).set_defaults(func=cmd_harness_check)
    sub.add_parser("status", help="show git status and run build gates").set_defaults(func=cmd_status)
    p_audit = sub.add_parser(
        "harness-audit",
        help="read-only lifecycle and task-scoped-memory shadow replay",
    )
    p_audit.add_argument("--task", action="append", help="task id to include; repeatable")
    p_audit.add_argument("--json", action="store_true", help="emit structured JSON")
    p_audit.add_argument("--output", default="", help="optional report path")
    p_audit.add_argument(
        "--fail-on-stale",
        action="store_true",
        help="return nonzero when HUMAN_STATUS does not match the active task",
    )
    p_audit.set_defaults(func=cmd_harness_audit)
    p_mathlib = sub.add_parser("mathlib-search", help="search available local Mathlib checkouts for reusable lemmas")
    p_mathlib.add_argument("query")
    p_mathlib.add_argument("--limit", type=int, default=40)
    p_mathlib.add_argument("--ignore-case", action="store_true")
    p_mathlib.add_argument("--word", action="store_true", help="pass word-boundary search to ripgrep when available")
    p_mathlib.set_defaults(func=cmd_mathlib_search)
    p_atlas_index = sub.add_parser("atlas-index", help="index every theorem and lemma in the pinned local ATLAS v1 checkout")
    p_atlas_index.set_defaults(func=cmd_atlas_memory, atlas_action="index")
    p_atlas_search = sub.add_parser("atlas-search", help="search the license-aware local ATLAS theorem memory")
    p_atlas_search.add_argument("query")
    p_atlas_search.add_argument("--limit", type=int, default=20)
    p_atlas_search.add_argument("--include-private", action="store_true")
    p_atlas_search.add_argument("--clean-only", action="store_true")
    p_atlas_search.add_argument("--relevance", default="")
    p_atlas_search.add_argument("--json", action="store_true")
    p_atlas_search.set_defaults(func=cmd_atlas_memory, atlas_action="search")
    p_atlas_show = sub.add_parser("atlas-show", help="show one declaration from the pinned ATLAS checkout")
    p_atlas_show.add_argument("declaration")
    p_atlas_show.set_defaults(func=cmd_atlas_memory, atlas_action="show")
    p_atlas_verify = sub.add_parser("atlas-verify", help="index and build ATLAS v1 with its own pinned toolchain")
    p_atlas_verify.set_defaults(func=cmd_atlas_memory, atlas_action="verify")
    p_atlas_status = sub.add_parser("atlas-status", help="show the local ATLAS index and external build gate")
    p_atlas_status.set_defaults(func=cmd_atlas_memory, atlas_action="status")
    sub.add_parser("list-literature", help="list literature registry entries").set_defaults(
        func=cmd_list_literature
    )
    sub.add_parser("list-tasks", help="list task files").set_defaults(func=cmd_list_tasks)
    sub.add_parser("next-task", help="suggest the next task").set_defaults(func=cmd_next_task)
    p_case = sub.add_parser("ingest-case", help="validate a contributed SP/BE case and create a review packet")
    p_case.add_argument("path")
    p_case.add_argument("--review-only", action="store_true")
    p_case.set_defaults(func=cmd_ingest_case)
    p_promote = sub.add_parser("promote-case", help="promote a reviewed case only after full repository gates")
    p_promote.add_argument("case_id")
    p_promote.add_argument("--lean-root", required=True)
    p_promote.set_defaults(func=cmd_promote_case)

    p_task = sub.add_parser("new-task", help="create a task contract in tasks/")
    p_task.add_argument("id")
    p_task.add_argument("--title", required=True)
    p_task.add_argument("--kind", default="operatorBlockEncoding")
    p_task.add_argument(
        "--mode",
        choices=[
            "statePreparation",
            "operatorBlockEncoding",
            "paperBenchmark",
            "faithfulPaper",
            "exploratoryConstruction",
            "unspecified",
        ],
        default="unspecified",
    )
    p_task.add_argument("--source", default="")
    p_task.add_argument("--target-lean", default="QuantumBlockEncoding/OpenProblems.lean")
    p_task.add_argument(
        "--export-targets",
        default="qiskit",
        help="comma-separated post-Lean executable targets, e.g. qiskit,quantum-katas,qasm3; use none to disable",
    )
    p_task.add_argument(
        "--export-instantiation",
        default="",
        help="concrete register sizes/parameters for post-Lean executable exports",
    )
    p_task.add_argument(
        "--executable-check-backend",
        choices=["none", "qiskitOperator", "openqasm3RoundTrip", "both"],
        default="none",
    )
    p_task.add_argument("--executable-check-required", action="store_true")
    p_task.add_argument("--executable-evidence-classes", default="none")
    p_task.set_defaults(func=cmd_new_task)

    p_ingest = sub.add_parser(
        "ingest-user-problem",
        help="record a raw user problem in any language as the source artifact for an operator task",
    )
    p_ingest.add_argument("id")
    p_ingest.add_argument("--title", default="")
    p_ingest.add_argument("--language", default=os.environ.get("QBE_REPORT_LANGUAGE", "zh"))
    p_ingest.add_argument("--file", default="", help="read raw user problem from this file")
    p_ingest.add_argument("--text", default="", help="raw user problem text; stdin is also accepted")
    p_ingest.add_argument("--kind", default="operatorBlockEncoding")
    p_ingest.add_argument("--mode", default="exploratoryConstruction")
    p_ingest.add_argument("--source", default="user-provided")
    p_ingest.add_argument("--epsilon", default="")
    p_ingest.add_argument("--export-targets", default="qiskit,quantum-katas,qasm3")
    p_ingest.add_argument(
        "--executable-check-backend",
        choices=["none", "qiskitOperator", "openqasm3RoundTrip", "both"],
        default="none",
    )
    p_ingest.add_argument("--executable-check-required", action="store_true")
    p_ingest.add_argument("--executable-evidence-classes", default="none")
    p_ingest.add_argument("--create-task", action="store_true", help="create or overwrite the task shell if absent")
    p_ingest.add_argument("--active", action="store_true", help="set this task as active")
    p_ingest.set_defaults(func=cmd_ingest_user_problem)

    p_update = sub.add_parser("update-task", help="update task status")
    p_update.add_argument("id")
    p_update.add_argument("--status", required=True)
    p_update.add_argument("--active", action="store_true")
    p_update.set_defaults(func=cmd_update_task)

    p_window = sub.add_parser("conversion-window", help="create a Lean/natural-language conversion window")
    p_window.add_argument("id")
    p_window.add_argument("--title", required=True)
    p_window.set_defaults(func=cmd_conversion_window)

    p_problem = sub.add_parser("new-open-problem", help="draft a new open problem proposal")
    p_problem.add_argument("id")
    p_problem.add_argument("--title", required=True)
    p_problem.add_argument("--motivation", default="")
    p_problem.add_argument("--reference", default="")
    p_problem.set_defaults(func=cmd_new_open_problem)

    p_brief = sub.add_parser("agent-brief", help="create an agent brief for a task")
    p_brief.add_argument("id")
    p_brief.set_defaults(func=cmd_agent_brief)

    p_blueprint = sub.add_parser("blueprint-refresh", help="refresh compact task proof blueprint")
    p_blueprint.add_argument("id")
    p_blueprint.set_defaults(func=cmd_blueprint_refresh)

    p_blueprint_status = sub.add_parser("blueprint-status", help="write compact blueprint control status")
    p_blueprint_status.add_argument("id")
    p_blueprint_status.add_argument("--refresh", action="store_true")
    p_blueprint_status.add_argument("--output", default="")
    p_blueprint_status.set_defaults(func=cmd_blueprint_status)

    p_context = sub.add_parser("write-context-pack", help="write compact long-run context pack")
    p_context.add_argument("id")
    p_context.add_argument("--cycle", type=int, default=1)
    p_context.add_argument("--output", default="")
    p_context.set_defaults(func=cmd_write_context_pack)

    p_efficiency = sub.add_parser("efficiency-report", help="summarize recent long-run efficiency")
    p_efficiency.add_argument("--task", default="")
    p_efficiency.add_argument("--log", default="")
    p_efficiency.add_argument("--output", default="")
    p_efficiency.add_argument("--json", action="store_true")
    p_efficiency.set_defaults(func=cmd_efficiency_report)

    p_summary = sub.add_parser("cycle-summary", help="write a human-facing cycle summary in the requested report language")
    p_summary.add_argument("id")
    p_summary.add_argument("--cycle", type=int, default=1)
    p_summary.add_argument("--run-id", default="latest")
    p_summary.add_argument("--language", default=os.environ.get("QBE_REPORT_LANGUAGE", "zh"))
    p_summary.set_defaults(func=cmd_cycle_summary)

    p_zh_summary = sub.add_parser("cycle-zh-summary", help="compatibility alias: write a Chinese paper-source cycle summary")
    p_zh_summary.add_argument("id")
    p_zh_summary.add_argument("--cycle", type=int, default=1)
    p_zh_summary.add_argument("--run-id", default="latest")
    p_zh_summary.set_defaults(func=cmd_cycle_zh_summary)

    p_pro_prompt = sub.add_parser("cycle-pro-prompt", help="write a self-contained ChatGPT Pro prompt for unresolved leaves")
    p_pro_prompt.add_argument("id")
    p_pro_prompt.add_argument("--cycle", type=int, default=1)
    p_pro_prompt.add_argument("--run-id", default="latest")
    p_pro_prompt.set_defaults(func=cmd_cycle_pro_prompt)

    p_memory = sub.add_parser("memory-refresh", help="refresh compact task memory and retrieval index")
    p_memory.add_argument("id")
    p_memory.add_argument("--cycle", type=int, default=1)
    p_memory.add_argument("--run-id", default="latest")
    p_memory.set_defaults(func=cmd_memory_refresh)

    p_human = sub.add_parser("human-status", help="write the root human-facing status dashboard")
    p_human.add_argument("id")
    p_human.add_argument("--run-id", default="latest")
    p_human.add_argument("--language", default=os.environ.get("QBE_REPORT_LANGUAGE", "zh"))
    p_human.set_defaults(func=cmd_human_status)

    p_article_update = sub.add_parser("project-article-update", help="write an article-facing cycle update packet")
    p_article_update.add_argument("id")
    p_article_update.add_argument("--cycle", type=int, default=1)
    p_article_update.add_argument("--run-id", default="latest")
    p_article_update.add_argument(
        "--article-root",
        default="",
        help="optional technical-report root; defaults to QBE_PROJECT_ARTICLE_ROOT or ../Auto_Proof_Papers/ABEIS",
    )
    p_article_update.set_defaults(func=cmd_project_article_update)

    p_problem_export = sub.add_parser(
        "problem-latex-export",
        help="write a problem-specific LaTeX proof note for copying into a user manuscript",
    )
    p_problem_export.add_argument("id")
    p_problem_export.add_argument("--cycle", type=int, default=1)
    p_problem_export.add_argument("--run-id", default="latest")
    p_problem_export.add_argument(
        "--article-root",
        default="",
        help="optional technical-report root for mirroring problem_exports/<task>.tex",
    )
    p_problem_export.set_defaults(func=cmd_problem_latex_export)

    p_manual_closeout = sub.add_parser(
        "manual-cycle-closeout",
        help="close a manual/chat-window multi-agent cycle by refreshing memory and problem-facing exports",
    )
    p_manual_closeout.add_argument("id")
    p_manual_closeout.add_argument("--cycle", type=int, default=0)
    p_manual_closeout.add_argument(
        "--run-id",
        default="latest-manual",
        help="manual run id under runs/, e.g. manual-multiagent/20260617-optctrl-pro, or latest-manual",
    )
    p_manual_closeout.add_argument(
        "--article-root",
        default="",
        help="optional technical-report root; used only with --project-article-update",
    )
    p_manual_closeout.add_argument(
        "--project-article-update",
        action="store_true",
        help="local maintainer mode: also update the ABEIS technical report appendix",
    )
    p_manual_closeout.set_defaults(func=cmd_manual_cycle_closeout)

    p_validate_metrics = sub.add_parser(
        "validate-candidate-metrics",
        help="ensure a candidate-population metrics CSV does not plot verifier-only or pre-final witnesses as final solutions",
    )
    p_validate_metrics.add_argument("id")
    p_validate_metrics.set_defaults(func=cmd_validate_candidate_metrics)

    p_trial = sub.add_parser("trial-log", help="append one trial record to runs/trials.jsonl")
    p_trial.add_argument("--task", required=True)
    p_trial.add_argument("--role", choices=AGENT_ROLES, required=True)
    p_trial.add_argument("--kind", choices=TRIAL_KINDS, required=True)
    p_trial.add_argument("--status", choices=TRIAL_STATUSES, required=True)
    p_trial.add_argument("--trial-id", default="")
    p_trial.add_argument("--score", default="")
    p_trial.add_argument("--lean-gate", choices=("pass", "fail", "not-run"), default="")
    p_trial.add_argument("--artifact", default="")
    p_trial.add_argument("--changed-file", action="append")
    p_trial.add_argument("--from-git", action="store_true")
    p_trial.add_argument("--command", default="")
    p_trial.add_argument("--notes", default="")
    p_trial.add_argument(
        "--feedback-json",
        default="",
        help="structured verifier feedback as a JSON string or path to a JSON file",
    )
    p_trial.add_argument(
        "--feedback-field",
        action="append",
        help="append one structured verifier-feedback key=value field",
    )
    p_trial.set_defaults(func=cmd_trial_log)

    sub.add_parser("trial-summary", help="rewrite and print the trial summary").set_defaults(
        func=cmd_trial_summary
    )

    p_cycle = sub.add_parser("run-cycle", help="create one upper/middle/lower/reviewer prompt deck")
    p_cycle.add_argument("id")
    p_cycle.add_argument("--cycle", type=int, default=1)
    p_cycle.add_argument("--lower-count", type=int, default=DEFAULT_LOWER_COUNT)
    p_cycle.add_argument("--game-harness", dest="game_harness", action="store_true", default=DEFAULT_GAME_HARNESS, help="create the Game Harness prompts: Natural-Language Hierarchical Team, Lean Hierarchical Team, and Game Council")
    p_cycle.add_argument("--hierarchical-harness", dest="game_harness", action="store_false", help="use the Hierarchical Harness prompts; this is the default")
    p_cycle.add_argument("--natural-lower-count", type=int, default=DEFAULT_NATURAL_LOWER_COUNT, help="natural-language Game Harness lower-agent count in Game Harness mode")
    p_cycle.add_argument("--lean-lower-count", type=int, default=DEFAULT_LEAN_LOWER_COUNT, help="Lean Game Harness lower-agent count in Game Harness mode")
    p_cycle.add_argument("--run-id", default="")
    p_cycle.add_argument(
        "--context-mode",
        choices=("full", "focused"),
        default="full",
        help="use full task text or only the current directive plus stable header",
    )
    p_cycle.add_argument(
        "--blueprint-refresh",
        action="store_true",
        help="refresh proof-blueprints/<task>.md before writing the prompt deck",
    )
    p_cycle.add_argument(
        "--upper-panel",
        dest="upper_panel",
        action="store_true",
        default=DEFAULT_UPPER_PANEL,
        help="create source/visual, proof-DAG, and process/memory upper specialist prompts; enabled by default",
    )
    p_cycle.add_argument(
        "--no-upper-panel",
        dest="upper_panel",
        action="store_false",
        help="disable upper specialist prompts for a deliberately small cycle",
    )
    p_cycle.add_argument(
        "--middle-panel",
        dest="middle_panel",
        action="store_true",
        default=DEFAULT_MIDDLE_PANEL,
        help="create source-correspondence, memory/retrieval, and report/export middle specialist prompts; enabled by default",
    )
    p_cycle.add_argument(
        "--no-middle-panel",
        dest="middle_panel",
        action="store_false",
        help="disable middle specialist prompts for a deliberately small cycle",
    )
    p_cycle.set_defaults(func=cmd_run_cycle)

    p_sleep = sub.add_parser("sleep-run", help="create or execute repeated agent cycles")
    p_sleep.add_argument("id")
    p_sleep.add_argument("--cycles", type=int, default=8)
    p_sleep.add_argument(
        "--adaptive-capacity",
        dest="adaptive_capacity",
        action="store_true",
        default=True,
        help="gate prompts by ready leaves and allow expansion only from current signed verifier feedback; enabled by default",
    )
    p_sleep.add_argument(
        "--fixed-capacity",
        dest="adaptive_capacity",
        action="store_false",
        help="use requested counts, still subject to ready-leaf, signed-expansion, stop, and token-budget safety gates",
    )
    p_sleep.add_argument(
        "--exact-stall-cycles",
        type=int,
        default=int(os.environ.get("QBE_EXACT_STALL_CYCLES", str(DEFAULT_EXACT_STALL_CYCLES))),
        help="legacy planning hint; epsilon/exploration changes still require a signed current-state capacity decision",
    )
    p_sleep.add_argument(
        "--active-budget-minutes",
        type=float,
        default=float(os.environ.get("QBE_ACTIVE_BUDGET_MINUTES", "60")),
        help="active agent-time budget for the batch; after the current cycle finishes, write closeout summary/memory/Pro prompt and stop; set 0 to disable",
    )
    p_sleep.add_argument(
        "--max-no-progress-cycles",
        type=int,
        default=int(os.environ.get("QBE_MAX_NO_PROGRESS_CYCLES", str(DEFAULT_MAX_NO_PROGRESS_CYCLES))),
        help="stop before another model call after this many unchanged executable/decomposition cycles",
    )
    p_sleep.add_argument(
        "--max-external-gap-cycles",
        type=int,
        default=int(os.environ.get("QBE_MAX_EXTERNAL_GAP_CYCLES", str(DEFAULT_MAX_EXTERNAL_GAP_CYCLES))),
        help="bounded dependency-decision cycles allowed for an unchanged external contract gap",
    )
    p_sleep.add_argument(
        "--max-prompt-tokens",
        type=int,
        default=int(os.environ.get("QBE_MAX_PROMPT_TOKENS", str(DEFAULT_MAX_PROMPT_TOKENS))),
        help="local per-prompt token proxy limit; 0 disables",
    )
    p_sleep.add_argument(
        "--max-cycle-input-tokens",
        type=int,
        default=int(os.environ.get("QBE_MAX_CYCLE_INPUT_TOKENS", str(DEFAULT_MAX_CYCLE_INPUT_TOKENS))),
        help="local total input-token proxy limit for selected prompts in one cycle; 0 disables",
    )
    p_sleep.add_argument(
        "--max-run-input-tokens",
        type=int,
        default=int(os.environ.get("QBE_MAX_RUN_INPUT_TOKENS", str(DEFAULT_MAX_RUN_INPUT_TOKENS))),
        help="persistent per-task input-token proxy limit across resumed sleep-run calls; 0 disables",
    )
    p_sleep.add_argument(
        "--retain-run-dirs",
        type=int,
        default=int(os.environ.get("QBE_RETAIN_RUN_DIRS", str(DEFAULT_RETAIN_RUN_DIRS))),
        help="retain this many newest generated cycle directories per task; durable ledgers are not removed",
    )
    p_sleep.add_argument(
        "--reset-control-state",
        action="store_true",
        help="explicit human override: clear this task's no-progress counters and persistent run-token budget before starting",
    )
    p_sleep.add_argument("--lower-count", type=int, default=DEFAULT_LOWER_COUNT)
    p_sleep.add_argument("--game-harness", dest="game_harness", action="store_true", default=DEFAULT_GAME_HARNESS, help="use the Game Harness: Natural-Language Hierarchical Team, Lean Hierarchical Team, and Game Council")
    p_sleep.add_argument("--hierarchical-harness", dest="game_harness", action="store_false", help="use the Hierarchical Harness; this is the default")
    p_sleep.add_argument("--natural-lower-count", type=int, default=DEFAULT_NATURAL_LOWER_COUNT, help="natural-language Game Harness lower-agent count in Game Harness mode")
    p_sleep.add_argument("--lean-lower-count", type=int, default=DEFAULT_LEAN_LOWER_COUNT, help="Lean Game Harness lower-agent count in Game Harness mode")
    p_sleep.add_argument("--agent-cmd", default="")
    p_sleep.add_argument(
        "--agent-profile",
        default="",
        help="JSON profile under agent-profiles/ or a path mapping roles/lower slots to command templates",
    )
    p_sleep.add_argument(
        "--agent-cmd-file",
        default="",
        help="alias for --agent-profile; kept for users who think in command-file terms",
    )
    p_sleep.add_argument("--execute", action="store_true")
    p_sleep.add_argument("--dry-run", action="store_true")
    p_sleep.add_argument("--check-each-cycle", action="store_true")
    p_sleep.add_argument(
        "--summary-each-cycle",
        action="store_true",
        help="write and archive the human-facing source audit after every executed cycle; long 6h runs leave this off and write one final summary",
    )
    p_sleep.add_argument(
        "--report-language",
        default=os.environ.get("QBE_REPORT_LANGUAGE", "zh"),
        help="preferred human report language for cycle summaries, e.g. zh, en, ja, ko, fr; default reads QBE_REPORT_LANGUAGE or zh",
    )
    p_sleep.add_argument(
        "--context-mode",
        choices=("full", "focused"),
        default="focused",
        help="use full task text or only the current directive plus stable header",
    )
    p_sleep.add_argument(
        "--blueprint-refresh",
        action="store_true",
        help="refresh proof-blueprints/<task>.md before every cycle",
    )
    p_sleep.add_argument(
        "--upper-panel",
        dest="upper_panel",
        action="store_true",
        default=DEFAULT_UPPER_PANEL,
        help="execute a bounded upper panel before director synthesis whenever upper runs; enabled by default",
    )
    p_sleep.add_argument(
        "--no-upper-panel",
        dest="upper_panel",
        action="store_false",
        help="disable the upper specialist panel for this run",
    )
    p_sleep.add_argument(
        "--middle-panel",
        dest="middle_panel",
        action="store_true",
        default=DEFAULT_MIDDLE_PANEL,
        help="execute a bounded middle panel before coordinator synthesis whenever middle runs; enabled by default",
    )
    p_sleep.add_argument(
        "--no-middle-panel",
        dest="middle_panel",
        action="store_false",
        help="disable the middle specialist panel for this run",
    )
    p_sleep.add_argument(
        "--parallel-panels",
        dest="parallel_panels",
        action="store_true",
        default=DEFAULT_PARALLEL_PANELS,
        help="execute independent upper/middle panel prompts concurrently; use only with isolated or disjoint mutation scopes",
    )
    p_sleep.add_argument(
        "--sequential-panels",
        dest="parallel_panels",
        action="store_false",
        help="run upper/middle panel prompts sequentially for debugging or constrained environments",
    )
    p_sleep.add_argument(
        "--upper-every",
        type=int,
        default=1,
        help="execute the upper prompt every N cycles; 0 skips it",
    )
    p_sleep.add_argument(
        "--middle-every",
        type=int,
        default=1,
        help="execute the middle prompt every N cycles; 0 skips it",
    )
    p_sleep.add_argument(
        "--reviewer-every",
        type=int,
        default=1,
        help="execute the reviewer prompt every N cycles; 0 skips it",
    )
    p_sleep.add_argument(
        "--skip-reviewer",
        action="store_true",
        help="do not execute the reviewer agent prompt; combine with --check-each-cycle to keep the Lean build gate",
    )
    p_sleep.add_argument(
        "--parallel-lower",
        dest="parallel_lower",
        action="store_true",
        default=DEFAULT_PARALLEL_LOWER,
        help="execute eligible lower prompts concurrently; use only with isolated or disjoint mutation scopes",
    )
    p_sleep.add_argument(
        "--sequential-lower",
        dest="parallel_lower",
        action="store_false",
        help="run lower-agent prompts sequentially for debugging or constrained environments",
    )
    p_sleep.add_argument(
        "--skip-article-update",
        action="store_true",
        help="legacy name: do not write closeout problem LaTeX or maintainer article artifacts",
    )
    p_sleep.add_argument(
        "--project-article-update",
        action="store_true",
        help="local maintainer mode: mirror closeout status into the ABEIS technical report; public users normally leave this off",
    )
    p_sleep.add_argument(
        "--article-update-each-cycle",
        action="store_true",
        help="local maintainer legacy mode: write technical-report and problem LaTeX artifacts after every executed cycle instead of only at batch closeout",
    )
    p_sleep.set_defaults(func=cmd_sleep_run)

    p_note = sub.add_parser("agent-note", help="append a role-tagged note to a run dialogue board")
    p_note.add_argument("run_id", help="run directory name, or 'latest'")
    p_note.add_argument("--role", choices=AGENT_ROLES, required=True)
    p_note.add_argument("--message", default="")
    p_note.add_argument("--file", default="")
    p_note.set_defaults(func=cmd_agent_note)

    return parser


def main(argv: list[str]) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
