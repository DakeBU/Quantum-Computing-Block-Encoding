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
import json
import os
import re
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
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
MATHCODE_LOCAL_REFERENCE = OUTER_REPOS_AUTOMATION_ROOT / "mathcode"
OPTIMIZATION_PROBLEMS_LOCAL_REFERENCE = OUTER_REPOS_MATH_ROOT / "optimizationproblems"
LEANMARATHON_PDF = OUTER_PAPERS_AUTOMATION_ROOT / "LeanMarathon-2606.05400.pdf"
STATE_DIR = ROOT / ".qbe"
STATE_FILE = STATE_DIR / "state.json"
MANIFEST = ROOT / "MANIFEST.md"
QBE_DASHBOARD = ROOT / "QBE.md"
HUMAN_STATUS = ROOT / "HUMAN_STATUS.md"
GHL_FAILURE_MAP = ROOT / "paper-notes" / "GHL2025" / "markdown" / "unresolved-failures.zh.md"
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
PROJECT_ARTICLE_UPDATE_DIR = ROOT / "paper-notes" / "project-paper" / "cycle-updates"

AGENT_ROLES = ("upper", "middle", "lower", "reviewer")
TRIAL_KINDS = ("plan", "attempt", "build", "review", "proposal", "compression", "handoff")
TRIAL_STATUSES = ("queued", "running", "blocked", "failed", "compiled", "accepted", "rejected")

WORK_DIRS = [
    "tasks",
    "conversion-windows",
    "paper-notes",
    "agent-briefs",
    "proof-attempts",
    "proof-blueprints",
    "verifier-feedback",
    "candidate-populations",
    "open-problem-proposals",
    "proof-obligations",
    "reviews",
    "runs",
    "runs/efficiency",
    "runs/context-packs",
    "paper-notes/project-paper/cycle-updates",
    "research-wiki/papers",
    "research-wiki/ideas",
    "research-wiki/claims",
    "research-wiki/experiments",
    "research-wiki/graph",
    "research-wiki/cited-results",
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


def write_new(path: Path, text: str) -> None:
    if path.exists():
        raise SystemExit(f"refusing to overwrite existing file: {path}")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")
    print(f"wrote {path.relative_to(ROOT)}")


def write_if_missing(path: Path, text: str) -> bool:
    if path.exists():
        return False
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")
    print(f"initialized {path.relative_to(ROOT)}")
    return True


def append_line(path: Path, line: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("a", encoding="utf-8") as handle:
        handle.write(line + "\n")


def append_jsonl(path: Path, record: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("a", encoding="utf-8") as handle:
        handle.write(json.dumps(record, sort_keys=True, ensure_ascii=False) + "\n")


def load_jsonl(path: Path) -> list[dict]:
    if not path.exists():
        return []
    records = []
    for line in path.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        try:
            records.append(json.loads(line))
        except json.JSONDecodeError as exc:
            raise SystemExit(f"invalid JSONL in {path}: {exc}") from exc
    return records


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
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")
    print(f"wrote {display_path(path)}")


def git_changed_files() -> list[str]:
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
    return sorted(set(files))


def latest_run_dir() -> Path | None:
    runs = [
        p for p in (ROOT / "runs").glob("*")
        if p.is_dir() and re.search(r"-cycle[0-9]+$", p.name)
    ]
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
    records = load_jsonl(TRIAL_LOG)
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


def save_state(state: dict) -> None:
    STATE_DIR.mkdir(parents=True, exist_ok=True)
    STATE_FILE.write_text(json.dumps(state, indent=2, sort_keys=True) + "\n", encoding="utf-8")


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
- Primary target: Guseynov-Huang-Liu Robin block encoding skeleton

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

- Finish primary target skeleton into concrete Lean semantics.

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
technical lemmas.  Faithful-reproduction agents should consult this directory
before assigning lower-agent work so that paper steps, cited primitives, and
standard facts are not mixed together.
""",
        GHL_CONTRIBUTION_DIR / "README.md": """# Guseynov-Huang-Liu 2025 Contribution Memory

This directory tracks the first ABEIS faithful-reproduction case study:
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

Faithful paper-reproduction mode may use local proof-attempt populations for a
fixed Lean theorem or lemma.  These records are for tactic/proof-script search,
not for changing the paper construction.

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
but adapted to QBE's block-encoding target:

- Lean declarations are the correctness core;
- Markdown and LaTeX artifacts are the human proof map;
- proof obligations and cited-results ledgers keep unproved contracts explicit;
- dynamic leaf candidates tell lower agents which local proof node to attempt.

Refresh a blueprint before long runs:

```bash
python3 tools/qbe.py blueprint-refresh <task-id>
```
""",
        ROOT / "candidate-populations" / "README.md": """# Candidate Populations

Exploratory construction mode may maintain EoH-like populations of candidate
oracle or block-encoding constructions.

Each candidate family should identify:

- target acceptance predicate,
- construction idea,
- Lean declarations and file scope,
- partial score such as typechecks, dimension checks, small-case block tests,
  normalizer progress, resource progress, and remaining obligations,
- status: rejected, active, promising, merged, or proved.

A score is only a search guide.  A construction is accepted only when the Lean
target and proof obligations are satisfied.
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
  "mode": "faithfulPaper",
  "source_correspondence_ok": true,
  "lean_parse_ok": true,
  "lean_build_ok": false,
  "finite_matrix_ok": true,
  "block_entry_ok": false,
  "ancilla_cleanup_ok": null,
  "normalizer_ok": true,
  "closed_theorem_ok": false,
  "error_class": "symbolic_bridge_gap",
  "next_route": "prove evalWith-level entry bridge for full index 48"
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
    state = load_state()
    state.setdefault("version", 1)
    state.setdefault("active_task", None)
    state["initialized_at"] = state.get("initialized_at") or now_stamp()
    save_state(state)
    if created_any:
        add_manifest("qbe.py init", QBE_DASHBOARD, "init", "Initialized QBE workflow files")
    return 0


def cmd_check(_: argparse.Namespace) -> int:
    code = run(["lake", "build"])
    if code != 0:
        return code
    code = run(["lake", "build", "Tests"])
    state = load_state()
    state["last_check"] = {"timestamp": now_stamp(), "exit_code": code}
    save_state(state)
    return code


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
    return f"""# {args.title}

Task id: `{args.id}`
Kind: `{args.kind}`
Mode: `{args.mode}`
Status: `planned`
Created: `{now}`

## Goal

State the oracle or block-encoding target precisely.

State whether this is faithful paper reproduction or exploratory construction.
Faithful tasks reproduce a cited construction.  Exploratory tasks search for a
new construction against a Lean-checkable acceptance predicate.

Hybrid strategy:

- `faithfulPaper`: use Learning-Beyond-Gradients-style trial memory and, when a
  fixed lemma fails, maintain a local proof-attempt population for proof routes.
  Do not mutate the paper construction.
- `exploratoryConstruction`: use Learning-Beyond-Gradients-style trial memory
  plus EoH-style candidate populations for circuit ideas.  Candidate scores are
  search hints only; Lean proof obligations decide acceptance.

## Source

- Paper/open problem: `{args.source or "TBD"}`
- Lean target: `{args.target_lean}`

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

- [ ] Matrix/operator target is defined.
- [ ] Circuit or circuit schema is defined.
- [ ] Normalization is explicit.
- [ ] Ancilla layout is explicit.
- [ ] Resource expression is explicit.
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


def cmd_update_task(args: argparse.Namespace) -> int:
    path = ROOT / "tasks" / f"{slugify(args.id)}.md"
    if not path.exists():
        raise SystemExit(f"task not found: {path.relative_to(ROOT)}")
    text = read_text(path)
    if re.search(r"^Status:", text, flags=re.M):
        text = re.sub(r"^Status:\s*`?[^`\n]+`?", f"Status: `{args.status}`", text, count=1, flags=re.M)
    else:
        text = text + f"\nStatus: `{args.status}`\n"
    path.write_text(text, encoding="utf-8")
    state = load_state()
    if args.active:
        state["active_task"] = args.id
        save_state(state)
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
- Middle agent: maintain LaTeX/Markdown/Lean translation and proof obligations.
- Lower agents: try one concrete circuit/proof construction each.
- Reviewer: check the actual Lean diff, resource assumptions, and citation trail.

Agents coordinate through `runs/<run-id>/dialogue.md` and append trial records to
`runs/trials.jsonl`.

## Recent Trial Memory

```text
{recent_trials}
```

## Working Instructions

1. Use a conversion window for any LaTeX/Markdown/Lean translation.
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
    records = load_jsonl(TRIAL_LOG)
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
    """Extract the current obligation table as compact prose rows."""
    if not text:
        return []
    start = text.find("Current obligation state:")
    if start < 0:
        return []
    rows: list[str] = []
    in_table = False
    for raw in text[start:].splitlines()[1:]:
        line = raw.strip()
        if not line:
            if in_table:
                break
            continue
        if not line.startswith("|"):
            if in_table:
                break
            continue
        in_table = True
        cells = [cell.strip() for cell in line.strip("|").split("|")]
        if len(cells) < 4 or cells[0] in {"Obligation", "---"}:
            continue
        obligation, lean_decl, dependency_class, status = cells[:4]
        rows.append(
            f"{obligation}: Lean {lean_decl}; class {dependency_class}; status {status}"
        )
        if len(rows) >= limit:
            break
    return rows


def lean_declaration_index(task_text: str, limit: int = 80) -> list[dict[str, str]]:
    keywords = ("theorem", "lemma", "def", "structure", "inductive", "abbrev")
    if any(marker in task_text for marker in ["GHL2025", "Guseynov", "Robin", "QBE-AUTO-002"]):
        files = [
            ROOT / "QuantumBlockEncoding" / "GHL2025.lean",
            ROOT / "QuantumBlockEncoding" / "RobinMatrix.lean",
            ROOT / "QuantumBlockEncoding" / "CircuitSemantics.lean",
        ]
    else:
        files = sorted((ROOT / "QuantumBlockEncoding").glob("*.lean"))
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
            rows.append(
                {
                    "file": rel(path),
                    "line": str(line_no),
                    "kind": match.group(1),
                    "name": name,
                }
            )
    return rows[-limit:]


def infer_blueprint_stage(task_text: str, proof_obligation_text: str) -> str:
    lower = (task_text + "\n" + proof_obligation_text).lower()
    if (
        any(marker in lower for marker in ["current run directive", "immediate 6h focus", "lower agent", "fixed theorem"])
        and any(marker in lower for marker in ["unproved", "remain false", "proved := false", "proof target", "dynamic leaf"])
    ):
        return "Stage 2 DAG proof discharge, with faithful transcript checks still active"
    if "phase 1" in lower or "transcript" in lower or "contract capture" in lower:
        return "Stage 1 target/transcript stabilization"
    if "unproved" in lower or "remain false" in lower or "proved := false" in lower:
        return "Stage 2 DAG proof discharge"
    return "Stage unknown; upper must classify before broad lower work"


def dynamic_leaf_candidates(task_text: str, obligation_text: str, dialogue_text: str, limit: int = 12) -> list[str]:
    candidates: list[str] = []
    directive = extract_section(task_text, [r"^## Immediate .*?$", r"^## Current Run Directive.*?$"])
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
    if not conversion_text:
        return []
    sections = re.split(r"\n(?=## )", conversion_text)
    priority_sections = [
        section
        for section in sections
        if "Updated proof-DAG frontier" in section
        and "Post-Feeder Active/Prepared" in section
        and "active_prepared_composition_leaf" in section
    ]
    if not priority_sections:
        priority_sections = [
            section
            for section in sections
            if "Updated proof-DAG frontier" in section
        and "Prepared-Sandwich Semantics" in section
        and "prepared_sandwich_gap_leaf" in section
        ]
    if not priority_sections:
        priority_sections = [
            section
            for section in sections
            if "Updated proof-DAG frontier" in section
            and "Post-Active-Selected-Slot Bridge" in section
            and "active_selected_slot_eval_comparison_leaf" in section
        ]
    if not priority_sections:
        priority_sections = [
            section
            for section in sections
            if "Updated proof-DAG frontier" in section
            and "Post-Selected-Slot Active-Uncast" in section
            and "active_selected_slot_eval_comparison_leaf" in section
        ]
    if not priority_sections:
        priority_sections = [
            section
            for section in sections
            if "Updated proof-DAG frontier" in section
            and "Active-Uncast" in section
            and "active_uncast_to_prepared_entry_leaf" in section
        ]
    if not priority_sections:
        priority_sections = [
            section
            for section in sections
            if "Updated proof-DAG frontier" in section
            and "Remaining-Slots Evaluated" in section
            and "unitary_fold_leaf" in section
            and "FullUnitaryFold" in section
        ]
    if not priority_sections:
        priority_sections = [
            section
            for section in sections
            if "Updated proof-DAG frontier" in section
            and "Remaining-Slots" in section
            and "unitary_fold_leaf" in section
            and "FullUnitaryFold" in section
        ]
    if not priority_sections:
        priority_sections = [
            section
            for section in sections
            if "Updated proof-DAG frontier" in section
            and "Post-Slot-One Support" in section
            and "unitary_fold_leaf" in section
            and "FullUnitaryFold" in section
        ]
    if not priority_sections:
        priority_sections = [
            section
            for section in sections
            if "Updated proof-DAG frontier" in section
            and "unitary_fold_leaf" in section
            and "FullUnitaryFold" in section
        ]
    if not priority_sections:
        priority_sections = [
            section
            for section in sections
            if "Updated proof-DAG frontier" in section and "unitary_fold_leaf" in section
        ]
    if not priority_sections:
        return []
    section = priority_sections[-1]
    rows: list[tuple[int, str]] = []
    priority = {
        "active_selected_slot_eval_comparison_leaf": 0,
        "active_prepared_composition_leaf": 0,
        "prepared_sandwich_gap_leaf": 1,
        "active_selected_to_fold_bridge": 8,
        "active_prepared_entry_feeder": 0,
        "active_uncast_to_prepared_entry_leaf": 2,
        "active_uncast_entry_leaf": 0,
        "source_prepared_entry_leaf": 3,
        "unitary_fold_leaf": 4,
        "backend_expansion_leaf": 5,
        "expanded_uncast_entry_leaf": 4,
        "expanded_uncast_recovery_leaf": 4,
        "expanded_all_slots_feeder": 4,
        "slot0_vanish_support": 4,
        "slot1_support_mismatch": 4,
        "remaining_slots_support_mismatch": 4,
        "slot1_full_vanish_leaf": 1,
        "slot1_branch_vanish_leaf": 1,
        "remaining_slots_evaluated_vanish_leaf": 1,
        "slot3_full_vanish_leaf": 1,
        "slot_support_vanish_lemmas": 5,
        "remaining_slot_support_leaf": 5,
        "branch_sum_to_unitary_fold_bridge": 6,
        "prepared_clean_equivalent_bridge": 7,
        "prepared_sparse_clean_entry_bridge": 8,
    }
    for line in section.splitlines():
        stripped = line.strip()
        if not stripped.startswith("|"):
            continue
        cells = [cell.strip() for cell in stripped.strip("|").split("|")]
        if len(cells) < 8 or cells[0] in {"Node", "---"}:
            continue
        node = cells[0].strip("`")
        if node == "retired_routes":
            continue
        status = cells[7]
        status_lower = status.lower()
        if not any(
            marker in status_lower
            for marker in [
                "active",
                "open",
                "allowed",
                "compiled feeder",
                "compiled support",
                "compiled bridge",
                "compiled conditional",
                "next",
            ]
        ):
            continue
        interface = re.sub(r"\s+", " ", cells[1])
        lean_decl = re.sub(r"\s+", " ", cells[4])
        if node == "unitary_fold_leaf" and "; diagnostic" in lean_decl:
            lean_decl = lean_decl.split("; diagnostic", 1)[0]
        max_lean_len = 260 if node == "unitary_fold_leaf" else 180
        if len(lean_decl) > max_lean_len:
            lean_decl = lean_decl[: max_lean_len - 3] + "..."
        if node == "unitary_fold_leaf" and "active" in status_lower:
            status = "open active mathematical leaf"
        item = f"{node}: {interface}; status: {status}; Lean: {lean_decl}"
        rows.append((priority.get(node, 50), item))
        if len(rows) >= limit:
            break
    rows.sort(key=lambda row: row[0])
    return [item for _, item in rows[:limit]]


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
    directive = extract_section(task_text, [r"^## Immediate .*?$", r"^## Current Run Directive.*?$"])
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

```text
{directive.strip()}
```

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
            role = "Lean/Markdown/LaTeX conversion"
        elif "proof-obligations" in str(path):
            role = "open obligations"
        elif "paper-notes" in str(path):
            role = "human-readable proof export"
        elif "cited-results" in str(path):
            role = "external theorem memory"
        text += f"| `{rel(path)}` | {role} |\n"
    text += f"""
## Latest Dialogue Signal

```text
{dialogue_text[-3000:]}
```

## Gate Policy

- Stage 1 target/transcript stabilization: upper and middle must verify that
  Lean statements, source-paper prose, register layouts, normalizers, and
  cited contracts match before broad lower proving.
- Stage 2 DAG proof discharge: lower agents work on dynamic leaves only;
  reviewer accepts progress only through `python3 tools/qbe.py check` and
  synchronized Markdown/LaTeX correspondence.
- Mixed lower-agent proof mode: when two lower agents are available, lower 1
  writes the natural-language dependency proof and active-leaf table; lower 2
  compiles exactly one ready Lean leaf from that table.
- Refiner behavior: when several failures share a dependency, repair the
  connected illness area once instead of stacking independent patches.
- No agent may mark a proof complete from self-assessment, partial score, or
  process memory.  Lean plus explicit proof-map correspondence is the gate.
"""
    path = blueprint_path(task_id)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")
    add_manifest("qbe.py blueprint-refresh", path, "blueprint", f"Refreshed proof blueprint for {task_id}")
    return path


def blueprint_context(task_id: str, max_chars: int = 12000) -> str:
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
    records = [record for record in load_jsonl(TRIAL_LOG) if record.get("task_id") == task_id]
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
            "- Middle must map the selected paper proof fragment to Lean declarations or explicit obligations.",
            "- With two lower agents, lower 1 writes the natural-language DAG proof packet and lower 2 proves one ready Lean leaf.",
            "- Lower must edit only the assigned local target and run `python3 tools/qbe.py check` after Lean edits.",
            "- Reviewer accepts progress only when the Lean gate and the Markdown/LaTeX correspondence are synchronized.",
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
            "- In faithful-paper mode, reproduce the paper construction and do not add assumptions.",
            "- Translate the selected LaTeX proof fragment into Lean-facing declarations before lower proof search.",
            "- Maintain a proof-DAG frontier: root theorem, dependencies, active leaves, stale leaves, and owner lower profile.",
            "- With two lower agents, lower 1 writes the natural-language DAG proof packet and lower 2 compiles one ready Lean leaf.",
            "- Export newly accepted Lean proof blocks to Markdown/LaTeX in batch, not after every tiny edit.",
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
        "paper": "Lemma 1，banded-sparse-access oracle",
        "meaning": "定义 $\\hat{O}^{BS}_D |0\\rangle^{n-l}|s\\rangle^l|i\\rangle^n = |r_{si}\\rangle^n|i\\rangle^n$，并从前一篇 PDE block-encoding 论文引用资源估计。",
        "status": "contract/backlog：已有 active matrix helper；完整 reversible extension、injectivity、dagger cleanup、unitarity 仍是义务。",
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
        "meaning": "boundary entry 逐元素处理，角度写作 $\\theta_j^s = \\arccos(D_j^{(s)}/\\mathcal{N}_D)$。",
        "status": "active convention audit：标准 $R_y(\\theta)$ 给出 $\\cos(\\theta/2)$，所以 Lean route 必须确认论文 convention，或使用有原文/引用支持的 doubled-angle 修正。",
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
    code, output = run_capture(["rg", "-n", r"(^\s*sorry\s*$|:=\s*sorry\b|by\s+sorry\b)", "QuantumBlockEncoding", "Tests"])
    if code not in (0, 1):
        return [f"rg failed: {output.strip()}"]
    lines = [line.strip() for line in output.splitlines() if line.strip()]
    return lines[:limit]


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


def cycle_zh_summary_text(task_id: str, cycle: int, run_dir: Path) -> str:
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


def write_cycle_zh_summary(task_id: str, cycle: int, run_dir: Path) -> tuple[Path, Path]:
    text = cycle_zh_summary_text(task_id, cycle, run_dir)
    run_path = run_dir / "zh_summary.md"
    archive_dir = ROOT / "paper-notes" / "GHL2025" / "markdown" / "cycle-summaries"
    archive_path = archive_dir / f"{run_dir.name}.md"
    latest_path = archive_dir / "latest.md"
    write_text(run_path, text)
    write_text(archive_path, text)
    write_text(latest_path, text)
    add_manifest("qbe.py cycle-zh-summary", run_path, "review", f"Wrote Chinese cycle summary for {task_id} cycle {cycle}")
    add_manifest("qbe.py cycle-zh-summary", archive_path, "paper-note", f"Archived Chinese cycle summary for {task_id} cycle {cycle}")
    return run_path, archive_path


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
        "RyBoundary": "Active convention audit: the Ry angle convention must be source-supported before closing the boundary amplitude proof.",
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
            "id": "tl-ghl-lemma1-banded-sparse-access",
            "source": "GHL2025 main.tex:784-798; previous PDE block-encoding construction",
            "statement": "Banded-sparse-access oracle maps sparse slot and row index to the corresponding column index, with a reversible/unitary completion and dagger cleanup.",
            "lean_decl": "bandedSparseAccessPaperMatrix / ODBS contract helpers",
            "lean_status": "contract-only",
            "used_by": ["GHL2025 Fig. 4", "Robin boundary ODBS dagger cleanup"],
            "dependencies": ["sparse slot injectivity", "reversible extension", "finite matrix unitarity"],
            "next_action": "Keep as explicit external contract until the exact cited construction is formalized or imported as a theorem.",
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
    records = [record for record in load_jsonl(TRIAL_LOG) if record.get("task_id") == task_id]
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
                "closed_theorem_ok": feedback.get("closed_theorem_ok", ""),
                "next_route": next_route,
            }
        )
        if len(feedback_rows) >= limit:
            break
    if feedback_rows:
        return feedback_rows
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
    records = [record for record in load_jsonl(TRIAL_LOG) if record.get("task_id") == task_id]
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


def memory_snapshot_state(task_id: str, cycle: int, run_dir: Path) -> dict[str, object]:
    title, task_text = task_context(task_id)
    blueprint = blueprint_status_state(task_id)
    ghl_rows = ghl_contribution_rows()
    technical_rows = technical_lemma_rows()
    open_ghl = [
        row for row in ghl_rows
        if row.get("open") and row.get("is_ghl_contribution")
    ]
    open_technical = [row for row in technical_rows if row.get("lean_status") != "formalized"]
    source = ghl2025_source_main_tex(task_text)
    return {
        "task_id": task_id,
        "title": title,
        "cycle": cycle,
        "generated": now_stamp(),
        "run_dir": rel(run_dir),
        "source_main_tex": display_path(source) if source else "",
        "mode": blueprint.get("mode", ""),
        "stage": blueprint.get("stage", ""),
        "dynamic_leaf_queue": blueprint.get("dynamic_leaf_queue", []),
        "open_obligation_signals": blueprint.get("open_obligation_signals", []),
        "lean_sorries": lean_sorry_lines(limit=40),
        "ghl_contributions": ghl_rows,
        "open_ghl_contribution_obligations": open_ghl,
        "technical_lemmas": technical_rows,
        "open_external_technical_lemma_obligations": open_technical,
        "recent_verifier_feedback": recent_verifier_feedback(task_id, limit=10),
        "recent_trials": recent_trial_rows(task_id, limit=10),
        "recent_proof_attempts": latest_proof_attempts(task_id, limit=10),
        "next_lower_tasks": [
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
        ],
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


def prelean_verifier_rows_en() -> list[dict[str, object]]:
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


def prelean_verifier_table_en() -> str:
    return markdown_table(
        prelean_verifier_rows_en(),
        [
            ("proof part", "part"),
            ("fast check", "quick_check"),
            ("why this is a necessary condition", "why_necessary"),
            ("what Lean still proves", "lean_still_needed"),
        ],
    )


def memory_digest_markdown(snapshot: dict[str, object]) -> str:
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
    return f"""# Memory Digest: {snapshot.get('task_id')} cycle {snapshot.get('cycle')}

Generated: `{snapshot.get('generated')}`

Run directory: `{snapshot.get('run_dir')}`

Task title: {snapshot.get('title')}

This is the compact retrieval packet for the next upper/middle cycle.  It keeps
the long log, paper-source map, typed verifier feedback, and Lean `sorry` scan
separate from the next lower-agent task package.

## Plain-language status

{plain_language_status_en()}

## Pre-Lean verifier candidates

These checks are necessary-condition filters, not proofs.  A failure is useful
because it usually means the current target, index map, or circuit transcript
is wrong.  A pass only says that the target survived this exact finite check;
Lean must still close the theorem or keep the dependency as an explicit
contract.

{prelean_verifier_table_en()}

## Lean theorem closure signal

{sorries_text}

## Active proof-DAG leaves

{dynamic_text}

## Open GHL contribution obligations

{markdown_table(snapshot.get('open_ghl_contribution_obligations', []), [
    ('id', 'id'),
    ('main.tex anchor', 'main_tex_anchor'),
    ('paper object', 'paper_object'),
    ('Lean/status', 'lean_status'),
    ('external lemma?', 'depends_on_external_technical_lemma'),
])}

## Open external technical lemma obligations

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


def todo_markdown(snapshot: dict[str, object]) -> str:
    return f"""# Next Todo Packet: {snapshot.get('task_id')} cycle {snapshot.get('cycle')}

Generated: `{snapshot.get('generated')}`

## Lower 1: Natural-language proof architect

1. Read the first open GHL contribution row below.
2. Write the exact source-proof translation: source anchor, local theorem goal,
   dependency DAG, external technical lemmas, and route rejected by verifier.
3. Do not change Lean code.

## Lower 2: Lean implementation worker

1. Pick one active proof-DAG leaf from the retrieval index.
2. Prove the smallest build-testable declaration; do not refactor the paper
   construction or change assumptions.
3. Log typed verifier feedback with `trial-log --feedback-field`.

## Open GHL contribution obligations

{markdown_table(snapshot.get('open_ghl_contribution_obligations', []), [
    ('id', 'id'),
    ('main.tex anchor', 'main_tex_anchor'),
    ('paper object', 'paper_object'),
    ('Lean/status', 'lean_status'),
], limit=8)}

## Open external technical lemma obligations

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
    if isinstance(ghl_rows, list):
        write_text(GHL_CONTRIBUTION_DIR / "index.md", ghl_contribution_index_markdown(ghl_rows))
        write_text(GHL_CONTRIBUTION_DIR / "source-map.md", ghl_contribution_index_markdown(ghl_rows))
        write_text(GHL_CONTRIBUTION_DIR / "todo.md", ghl_contribution_todo_markdown(ghl_rows))
    if isinstance(technical_rows, list):
        write_text(TECHNICAL_LEMMA_DIR / "index.md", technical_lemma_index_markdown(technical_rows))
        write_text(TECHNICAL_LEMMA_DIR / "todo.md", technical_lemma_todo_markdown(technical_rows))
    add_manifest("qbe.py memory-refresh", digest_path, "memory", f"Wrote memory digest for {task_id} cycle {cycle}")
    add_manifest("qbe.py memory-refresh", index_path, "memory", f"Wrote retrieval index for {task_id}")
    return digest_path, todo_path, index_path


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
    digest_path, todo_path, index_path = write_memory_refresh(args.id, args.cycle, run_dir)
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
    return sorted(runs, key=lambda path: path.stat().st_mtime, reverse=True)[:limit]


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


def ghl_failure_map_markdown(task_id: str, run_dir: Path) -> str:
    snapshot = memory_snapshot_state(task_id, 0, run_dir)
    sorries = snapshot.get("lean_sorries", [])
    sorry_text = "\n".join(f"- `{line}`" for line in sorries) if sorries else "- 当前没有检测到 `sorry`。"
    latest_summary = run_dir / "zh_summary.md"
    latest_memory = run_dir / "memory_digest.md"
    latest_todo = run_dir / "todo.md"
    text = """# GHL2025 未完成与失败原因中文地图

生成时间：`{now_stamp()}`

任务：`{task_id}`

对应 run：`{rel(run_dir)}`

这个文件回答一个很具体的问题：**GHL 原文里哪些地方还没有被成功翻译成 Lean code，失败原因是什么，失败记录在哪里？**

它不是正式论文证明，也不是 Lean 证明。它是给人类上层 agent、合作者和不熟悉 Lean 的读者看的导航页。正式可信状态仍以 `QuantumBlockEncoding/` 里的 Lean 编译和 `sorry` 数量为准。

## 先读结论

- GHL2025 的 one-term Robin block-encoding 还没有完整 Lean 复现完成。
- 当前没有完成的是 Fig. 4 / Eq. ROBIN clarified / one-term theorem 之间的最后矩阵条目桥接：论文说线路的 clean branch 会留下目标系数；Lean 需要我们把具体门矩阵相乘，并证明指定 entry 正好等于这个系数。
- 现在剩下的主要失败不是“论文没有写证明”，而是 ABEIS 当前 Lean 表达层级还差一个语义桥：不能继续强证 raw `Coeff` symbolic matrix 的构造子相等，应该在 `Coeff.evalWith` 后的矩阵语义层证明 entry equality。
- 外部 oracle、$H_W$ sparse-register preparation、$O_f$、QSVT 等还没有都从零 formalize；当前它们被明确记录为 contract 或 external technical lemma，不应冒充为已经由 GHL 本文贡献证明。

## 当前 Lean 明确未闭合处

{sorry_text}

这两个 `sorry` 是显式诊断 blocker，不是隐藏在文字里的假设。它们阻止我们声称 GHL one-term Robin theorem 已经闭合。

## GHL 原文到 Lean 失败地图

| GHL 原文位置 | 原文在说什么 | Lean/ABEIS 对应位置 | 当前状态 | 失败或未完成原因（普通话） | 失败记录在哪里 | 下一步 |
| --- | --- | --- | --- | --- | --- | --- |
| `main.tex:1098-1109` | one-term Robin block-encoding theorem：最终要证明 Fig. 4 的 circuit 是 $A_k=f(x)\\partial_x^m$ 的 block-encoding。 | `QuantumBlockEncoding/RobinMatrix.lean`；目标链包含 `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` 和 source-prepared theorem-facing wrapper。 | 未完成。 | 最后还没证明 active clean branch 的矩阵 entry 等于论文需要的 block-encoding 系数。已有很多局部 feeder，但最终 theorem 不能因为 feeder 编译就算完成。 | `{rel(latest_summary)}`；`{rel(latest_memory)}`；`proof-attempts/QBE-AUTO-002/post-lower2-evaluated-fold-semantic-bridge-middle-packet-20260611-2352.md` | 只攻击一个最小 leaf：`semantic_eval_product_bridge` 或 `evaluated_backend_fold_leaf`，证明 evalWith 后的矩阵乘积 entry 等于 backend fold。 |
| `main.tex:1111-1119` | Eq. ROBIN clarified：给出 $\\gamma_1,\\gamma_2,\\gamma_3$，其中关键 clean branch 是 $f(x_i)D_i^{(s)}/(N_DN_f\\kappa)$。 | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`；backend branch fold；selected slot `2`。 | 部分完成。 | backend 侧很多 branch vanish/support lemma 已编译，但还没把 active evaluated entry 和 backend fold 完全接上。也就是说，论文里的“这个分支留下目标系数”还没被 Lean 证明成最终等式。 | `verifier-feedback/QBE-AUTO-002/evaluated-backend-fold-lower2-20260611-2348.md`；`proof-attempts/QBE-AUTO-002/evaluated-backend-fold-lower2-blocked-20260611-2348.md` | 用 `Matrix.evalWith_mul_apply`、`Matrix.evalWith_mul_unique_path`、`Matrix.evalWith_mul_two_path` 这一类语义引理，不再走 raw constructor equality。 |
| `main.tex:1122-1164` | Fig. 4 circuit caption：完整线路顺序，包括左侧 $H_W^{(\\kappa)}$、`U_indic`、boundary $R_y$、$O_f$、SWAP、$(O_D^{BS})^\\dagger$、右侧 $H_W^T$。 | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`；另有 H-free active backend seven-gate component。 | 图的 transcript guard 已有；最终语义 theorem 未完成。 | ABEIS 已经把“图里应出现哪些门”守住了，但“这些门相乘后的目标 entry 正确”还没完全证明。七门 backend 是中间组件，不等于完整 Fig. 4 theorem。 | `{rel(latest_summary)}` 的 `FigRobin` 行；`conversion-windows/QBE-AUTO-002.md`；`proof-obligations/QBE-AUTO-002.md` | 保持图的门顺序不变；把 H-free 七门 backend 当作组件，不把它误报为完整线路。 |
| `main.tex:1077-1085` | Robin boundary 的 controlled $R_y$ 旋转，论文写 $\\theta_j^s=\\arccos(D_j^{(s)}/N_D)$。 | boundary rotation convention lemmas；`tl-ry-boundary-amplitude-convention`。 | 仍是 obligation。 | 标准量子计算里的 `R_y(\\theta)` 振幅常出现半角 $\\cos(\\theta/2)$。如果论文采用不同 convention 或隐含 doubled-angle，Lean 必须明确桥接，不能硬改公式。 | `research-wiki/technical-lemmas/todo.md`；`research-wiki/paper-contributions/GHL2025/todo.md` | 查论文定义和引用文献，确认 convention 后写成 Lean lemma；不能自己加新假设。 |
| `main.tex:948-955` | $H_W^{(\\kappa)}$ 制备 sparse register 的 uniform superposition。 | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`。 | contract-only。 | 这是论文引用的已有 state-preparation primitive，不是当前 GHL 自己新证明的核心。为了先复现 GHL 主线，可以把它作为显式 contract，但不能说 gate-level proof 已完成。 | `research-wiki/technical-lemmas/todo.md`；`{rel(latest_summary)}` 的 `HW` 行 | 先保持 theorem-facing contract；若以后做资源定理或完整 gate-level primitive，再 formalize 引用文献。 |
| `main.tex:784-798` | Lemma 1：banded-sparse-access oracle $\\hat O_D^{BS}$。 | `tl-ghl-lemma1-banded-sparse-access`；sparse-access oracle contract。 | contract/backlog。 | 论文引用前人 PDE block-encoding 构造；ABEIS 还没有从零证明 reversible extension、injectivity、dagger cleanup、unitarity。 | `research-wiki/technical-lemmas/todo.md`；`research-wiki/cited-results/GHL2025.md` | 保持为 external technical lemma；后续做 oracle library 时补完整证明。 |
| `main.tex:822-843` | Lemma 3：sparse-amplitude oracle $\\hat O^S_{D^T}$，clean branch 给出 $D^{(s)}/N_D$。 | `tl-ghl-lemma3-sparse-amplitude`。 | contract/backlog。 | clean branch contract 可用于 GHL 主 theorem；sqrt complement、normalizer、unitarity 还没完整形式化。 | `research-wiki/technical-lemmas/todo.md` | 不在 one-term theorem 阶段重做全部 oracle primitive；只保留明确 contract。 |
| `main.tex:870-908` | Theorem 5：piecewise-polynomial $O_f$ amplitude oracle，clean branch 给出 $f(x_i)/N_f$。 | `tl-ghl-theorem5-piecewise-polynomial-of`；$O_f$ clean branch contract。 | contract/backlog。 | 这是外部/前置 oracle construction；当前没有完整 formalize $N_f$ bound、workspace orthogonality、unitary completion。 | `research-wiki/technical-lemmas/todo.md`；`{rel(latest_summary)}` 的 `Of` 行 | 先用于 theorem-facing contract；不要把它和 GHL one-term proof 的完成混淆。 |
| `main.tex:1171-1278` | 1D Hamiltonian block-encoding，用 LCU 组合多个 one-term operator。 | planned module / proof obligations。 | 未开始主体证明。 | 它依赖 one-term Robin theorem。当前 one-term 没闭合，所以 1D Hamiltonian 不是本轮 blocker。 | `{rel(latest_summary)}` 的 `OneD` 行；`proof-obligations/QBE-AUTO-002.md` | one-term theorem 关闭后再启动 LCU abstraction。 |
| `main.tex:1596-1649` | 多维推广。 | planned。 | 未开始主体证明。 | 依赖 one-term、1D Hamiltonian 和 LCU generalization。 | `{rel(latest_summary)}` 的 `MultiD` 行 | 暂不分配 lower agent。 |
| `main.tex:1676-1694` | Hamiltonian simulation / QSVT 引用。 | `tl-qsvt-blockencoding-simulation`。 | paper-cited/backlog。 | 这是把 block-encoding 用于 simulation 的外部 theorem application，不是 Fig. 4 gate-level closure。 | `research-wiki/technical-lemmas/todo.md` | 等 block-encoding theorem 完成后再接 QSVT。 |

## 最近一次失败到底失败在哪里？

最近 lower2 试图证明：

```lean
oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3
```

它尝试用 `rfl` 或 definitional equality 证明“由 gate list 乘出来的矩阵”和“手写的 seven-gate matrix”完全相等。Lean 返回：

```text
maximum recursion depth has been reached
```

普通解释是：这不是单纯算不过去，而是路线不对。我们现在的 `Coeff` 是 symbolic expression tree；同一个数学矩阵乘法，如果括号嵌套不同，raw constructor 级别不一定长得完全一样。论文需要的是“矩阵语义相等”，不是“Lean 表达式树长得一模一样”。所以正确路线是先用 `Coeff.evalWith` 把 symbolic coefficient 解释成语义值，再证明对应 entry 相等。

对应失败记录：

- `proof-attempts/QBE-AUTO-002/evaluated-backend-fold-lower2-blocked-20260611-2348.md`
- `verifier-feedback/QBE-AUTO-002/evaluated-backend-fold-lower2-20260611-2348.md`
- `proof-attempts/QBE-AUTO-002/post-lower2-evaluated-fold-semantic-bridge-middle-packet-20260611-2352.md`

## 现在真正应该派给 lower agent 的任务

不要再派 raw `Coeff` matrix equality。下一步应该派一个更小、更符合论文证明含义的 leaf：

1. 目标：证明 active seven-gate evaluated entry 等于 backend branch fold。
2. 文件：`QuantumBlockEncoding/RobinMatrix.lean`。
3. 优先引理层级：`Coeff.evalWith` 后的语义矩阵 entry。
4. 可用工具：`Matrix.evalWith_mul_apply`、`Matrix.evalWith_mul_unique_path`、`Matrix.evalWith_mul_two_path`、`Matrix.evalWith_mul_eq_zero_of_all_paths_zero`。
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


def human_status_markdown(task_id: str, run_dir: Path) -> str:
    snapshot = memory_snapshot_state(task_id, 0, run_dir)
    title = snapshot.get("title", "")
    sorries = snapshot.get("lean_sorries", [])
    latest_runs = recent_task_run_dirs(task_id, limit=8)
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
    log_text = "\n".join(f"- {line}" for line in log_lines) if log_lines else "- No batch log signal found."
    dynamic_text = "\n".join(f"- {item}" for item in dynamic[:6]) if dynamic else "- No active proof-DAG leaf detected."
    return f"""# ABEIS Human Status

Generated: `{now_stamp()}`

Task: `{task_id}` — {title}

Latest run: `{rel(run_dir)}`

这个文件是人类入口。正常情况下，你只需要先看这个文件，再决定是否打开更细的 `zh_summary.md`、`memory_digest.md`、Lean 文件或 proof-attempt 文件。

## One-Page Verdict

- 6h batch 状态：最近日志显示 final audit 成功结束，Lean build gate 通过。
- GHL one-term Robin theorem：还没有完成。
- 当前 `sorry` 数量：{len(sorries)}。
- 当前主要卡点：把 Fig. 4 / gamma3 的 finite circuit entry 精确接到论文的 clean-branch 系数，并把剩余 branch 的 vanish/cancellation 证明成 Lean theorem。
- 不应声称完成的内容：oracle unitarity、`H_W` 完整 state-preparation、`R_y` convention bridge、LCU/QSVT、最终 block-correctness。

## Latest Links

- 最新中文总结：`{rel(run_dir / "zh_summary.md")}`
- 最新 memory digest：`{rel(run_dir / "memory_digest.md")}`
- 最新下一步 todo：`{rel(run_dir / "todo.md")}`
- 最新 dialogue：`{rel(run_dir / "dialogue.md")}`
- 最新技术报告 update：`{rel(run_dir / "article_update.md")}`
- GHL 未完成/失败原因中文地图：`{rel(GHL_FAILURE_MAP)}`
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
2. For a plain Chinese map of unfinished GHL source steps and failed Lean routes, read `{rel(GHL_FAILURE_MAP)}`.
3. For human-readable cycle details, read `{rel(run_dir / "zh_summary.md")}`.
4. For what the next agents should read, use `{rel(run_dir / "memory_digest.md")}` and `{rel(run_dir / "todo.md")}`.
5. For machine retrieval, use `research-wiki/retrieval-index/{slugify(task_id)}.json`.
6. For exact Lean blockers, open `QuantumBlockEncoding/RobinMatrix.lean` at the `sorry` lines above.

## Directory Map

| Directory | Human role | Agent role |
|---|---|---|
| `QuantumBlockEncoding/` | Formal Lean source. Only trust claims that compile here. | Lower agent edits/proves here. |
| `runs/<run-id>/` | One cycle's prompt, dialogue, summary, todo, and article packet. | Short-term local memory. |
| `paper-notes/GHL2025/markdown/cycle-summaries/latest.md` | Latest archived Chinese audit. | Middle keeps source correspondence readable. |
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


def write_human_status(task_id: str, run_dir: Path) -> Path:
    write_text(GHL_FAILURE_MAP, ghl_failure_map_markdown(task_id, run_dir))
    add_manifest("qbe.py human-status", GHL_FAILURE_MAP, "review", f"Wrote GHL failure map for {task_id}")
    write_text(HUMAN_STATUS, human_status_markdown(task_id, run_dir))
    add_manifest("qbe.py human-status", HUMAN_STATUS, "review", f"Wrote human status dashboard for {task_id}")
    return HUMAN_STATUS


def cmd_human_status(args: argparse.Namespace) -> int:
    cmd_init(argparse.Namespace())
    if args.run_id == "latest":
        run_dir = latest_run_dir()
        if run_dir is None:
            raise SystemExit("no run directories found")
    else:
        run_dir = ROOT / "runs" / args.run_id
    if not run_dir.exists():
        raise SystemExit(f"run directory not found: {display_path(run_dir)}")
    path = write_human_status(args.id, run_dir)
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

- Keep the main system claim: ABEIS is an auto-proof harness for turning
  quantum oracle assumptions into Lean-checked block-encoding/circuit
  certificates.
- Keep the first case study honest: Guseynov--Huang--Liu 2025 is the first
  faithful reproduction target, but final completion depends on the current
  Lean gate and `sorry` status below.
- If this cycle only changes proof-route memory or obstruction analysis, update
  the report's evidence/appendix status, not the headline contribution.
- If this cycle closes a named Lean theorem, middle should export the theorem
  to Markdown and LaTeX proof notes before strengthening the project-paper
  claim.

## Lean status signal

{sorry_text}

## Plain-language status for readers

{plain_language_status_en()}

## Pre-Lean verifier candidates

These checks are necessary-condition filters, not proofs.  They are useful
because a failing exact finite check usually means the Lean target, circuit
transcript, or index map is wrong.  A passing check only means the candidate
survived this cheaper test; the final claim still needs a Lean theorem.

{prelean_verifier_table_en()}

## Current proof-DAG frontier

{dynamic_text}

## Open obligation signal

{obligation_text}

## Open GHL contribution obligations

{open_ghl_text}

## Open external technical lemma obligations

{open_technical_text}

## Recent typed verifier feedback

{feedback_text}

## Recent proof-attempt memory

{attempts_text}

## Suggested project-paper edits

| Report location | Safe update |
|---|---|
| `main/evidence.tex` | Add only stable harness lessons from this cycle, with no stronger claim than the Lean gate supports. |
| `main/ghl_case_study.tex` | Update the case-study status if a theorem, source-contract correction, or obstruction was accepted by reviewer. |
| `appendix/generated_cycle_status.tex` | This file is overwritten automatically and can be included as the latest machine-generated status appendix. |
| Figures/tables | Add or revise a figure only if the cycle changed the system design, proof-DAG frontier, or article-facing evidence. |

## Do not claim

- Do not say the Guseynov--Huang--Liu one-term theorem is complete while any
  theorem-facing `sorry` or root block-extraction obligation remains.
- Do not present a cited oracle/state-preparation/LCU/QSVT primitive as proved
  unless a build-tested Lean declaration is named.
- Do not turn proof-search scores, agent self-assessments, or natural-language
  proof sketches into accepted mathematical claims.

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
        "the first-case-study source theorem and definition passages",
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
        ("GHL Fig.", "the first-case-study figure"),
        ("GHL one-term", "the first-case-study one-term"),
        ("GHL-style", "first-case-study-style"),
        ("Guseynov--Huang--Liu", "the first case study"),
    ]
    for old, new in replacements:
        text = text.replace(old, new)
    text = text.replace("the the first case study", "the first case study")
    return text


def project_article_public_markdown(markdown: str) -> str:
    """Normalize the mirrored Markdown copy that lives beside the public report."""
    return article_status_plain(markdown)


def project_article_update_latex(task_id: str, cycle: int, run_dir: Path) -> str:
    state = blueprint_status_state(task_id)
    memory = memory_snapshot_state(task_id, cycle, run_dir)
    sorry_lines = lean_sorry_lines(limit=12)
    dynamic = state.get("dynamic_leaf_queue", [])
    obligations = state.get("open_obligation_signals", [])
    proof_attempts = latest_proof_attempts(task_id, limit=5)
    if sorry_lines:
        sorry_items = "\n".join(f"  \\item \\texttt{{{latex_escape(line)}}}" for line in sorry_lines)
    else:
        sorry_items = "  \\item No \\texttt{sorry} was detected by the project scan."
    dynamic_items = "\n".join(
        f"  \\item {latex_escape(article_status_plain(item))}" for item in dynamic[:8]
    ) or "  \\item No dynamic proof leaf was detected; the next cycle should refresh the proof blueprint."
    obligation_items = "\n".join(
        f"  \\item {latex_escape(article_status_plain(item))}" for item in obligations[:8]
    ) or "  \\item No compact obligation signal was detected; inspect the proof-obligation ledger directly."
    attempt_items = "\n".join(
        f"  \\item \\texttt{{{latex_escape(item)}}}" for item in proof_attempts
    ) or "  \\item No task-specific proof-attempt file was detected."
    open_ghl_rows = memory.get("open_ghl_contribution_obligations", [])
    if isinstance(open_ghl_rows, list) and open_ghl_rows:
        open_ghl_items = "\n".join(
            "  \\item \\texttt{%s}: %s; status %s."
            % (
                latex_escape(row.get("id", "")),
                latex_escape(article_status_plain(row.get("english_object", row.get("paper_object", "")))),
                latex_escape(article_status_plain(row.get("english_status", row.get("lean_status", "")))),
            )
            for row in open_ghl_rows[:8]
        )
    else:
        open_ghl_items = "  \\item No open first-case-study contribution obligation was detected."
    open_technical_rows = memory.get("open_external_technical_lemma_obligations", [])
    if isinstance(open_technical_rows, list) and open_technical_rows:
        open_technical_items = "\n".join(
            "  \\item \\texttt{%s}: %s; next action %s."
            % (
                latex_escape(row.get("id", "")),
                latex_escape(article_status_plain(row.get("lean_status", ""))),
                latex_escape(article_status_plain(row.get("next_action", ""))),
            )
            for row in open_technical_rows[:8]
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
            for row in feedback_rows[:6]
        )
    else:
        feedback_items = "  \\item No typed verifier-feedback packet was detected."
    prelean_items = "\n".join(
        "  \\item \\textbf{%s.} Fast check: %s.  Necessary because %s.  Lean still must prove: %s."
        % (
            latex_escape(row["part"]),
            latex_escape(row["quick_check"]),
            latex_escape(row["why_necessary"]),
            latex_escape(row["lean_still_needed"]),
        )
        for row in prelean_verifier_rows_en()
    )
    return f"""% Auto-generated by tools/qbe.py project-article-update.
% Do not edit this file by hand; edit the proof artifacts or article sections instead.

\\section{{Generated Current Cycle Status}}
\\label{{app:generated-cycle-status}}

This appendix page is generated from the latest ABEIS proof cycle.  It is a
status bridge for article maintenance, not a polished theorem proof.  Stable
mathematical claims should be copied into the main text only after the
corresponding Lean declaration, source-paper anchor, and proof-note export are
available.

\\paragraph{{Cycle.}}
Task \\texttt{{{latex_escape(task_id)}}}, cycle \\texttt{{{cycle}}}, run
\\texttt{{{latex_escape(rel(run_dir))}}}.  Generated at
\\texttt{{{latex_escape(now_stamp())}}}.

\\paragraph{{Lean status signal.}}
\\begin{{itemize}}
{sorry_items}
\\end{{itemize}}

\\paragraph{{Plain-language status.}}
{latex_escape(plain_language_status_en())}

\\paragraph{{Pre-Lean verifier candidates.}}
These checks are necessary-condition filters, not proofs.  A failed exact
finite check usually indicates that the current Lean target, circuit
transcript, or index map is wrong.  A passing check only means the candidate
survived a cheaper diagnostic; the final claim still requires a named Lean
theorem or an explicit contract.
\\begin{{itemize}}
{prelean_items}
\\end{{itemize}}

\\paragraph{{Current proof-DAG frontier.}}
\\begin{{itemize}}
{dynamic_items}
\\end{{itemize}}

\\paragraph{{Open obligation signal.}}
\\begin{{itemize}}
{obligation_items}
\\end{{itemize}}

\\paragraph{{Open GHL contribution obligations.}}
\\begin{{itemize}}
{open_ghl_items}
\\end{{itemize}}

\\paragraph{{Open external technical lemma obligations.}}
\\begin{{itemize}}
{open_technical_items}
\\end{{itemize}}

\\paragraph{{Recent typed verifier feedback.}}
\\begin{{itemize}}
{feedback_items}
\\end{{itemize}}

\\paragraph{{Recent proof-attempt memory.}}
\\begin{{itemize}}
{attempt_items}
\\end{{itemize}}

\\paragraph{{Article-writing rule.}}
The project report may discuss this cycle as process evidence.  It must not
claim completion of the first case study \\citep{{guseynovHuangLiu2025}} unless
the final theorem-facing block-extraction statement is closed in Lean and the
Markdown/LaTeX proof map has been synchronized.
"""


def write_project_article_update(
    task_id: str,
    cycle: int,
    run_dir: Path,
    article_root: Path | None = None,
) -> tuple[Path, Path, Path, Path, list[Path]]:
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
    return run_md, archive_md, run_tex, archive_tex, external_written


def cmd_project_article_update(args: argparse.Namespace) -> int:
    if args.run_id == "latest":
        run_dir = latest_run_dir()
        if run_dir is None:
            raise SystemExit("no run directories found")
    else:
        run_dir = ROOT / "runs" / args.run_id
    if not run_dir.exists():
        raise SystemExit(f"run directory not found: {display_path(run_dir)}")
    article_root = Path(args.article_root).expanduser() if args.article_root else None
    run_md, archive_md, run_tex, archive_tex, external = write_project_article_update(
        args.id,
        args.cycle,
        run_dir,
        article_root,
    )
    print(f"article-update: {display_path(run_md)}")
    print(f"article-update-archive: {display_path(archive_md)}")
    print(f"article-update-tex: {display_path(run_tex)}")
    print(f"article-update-tex-archive: {display_path(archive_tex)}")
    for path in external:
        print(f"article-update-external: {display_path(path)}")
    return 0


def cmd_cycle_zh_summary(args: argparse.Namespace) -> int:
    if args.run_id == "latest":
        run_dir = latest_run_dir()
        if run_dir is None:
            raise SystemExit("no run directories found")
    else:
        run_dir = ROOT / "runs" / args.run_id
    if not run_dir.exists():
        raise SystemExit(f"run directory not found: {rel(run_dir)}")
    run_path, archive_path = write_cycle_zh_summary(args.id, args.cycle, run_dir)
    print(f"zh-summary: {display_path(run_path)}")
    print(f"zh-summary-archive: {display_path(archive_path)}")
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
                "notes": record.get("notes", ""),
            }
        )
    TRIAL_SUMMARY.parent.mkdir(parents=True, exist_ok=True)
    with TRIAL_SUMMARY.open("w", newline="", encoding="utf-8") as handle:
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
            "notes",
        ]
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)
    return rows


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
    rows = write_trial_summary(load_jsonl(TRIAL_LOG))
    add_manifest("qbe.py trial-log", TRIAL_LOG, "trial", f"Logged {trial_id}")
    print(f"logged {trial_id}")
    print(f"summary rows: {len(rows)} -> {rel(TRIAL_SUMMARY)}")
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
        if mode in {"faithfulPaper", "exploratoryConstruction", "unspecified"}:
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
    if any(marker in text for marker in faithful_markers):
        return "faithfulPaper"
    if any(marker in text for marker in exploratory_markers):
        return "exploratoryConstruction"
    return "unspecified"


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


def verifier_feedback_contract() -> str:
    return """Typed verifier-feedback contract:

- QBE borrows the useful shape of parser/unit-test/simulator feedback from
  non-Lean quantum-circuit systems, but Lean remains the final acceptance gate.
- Every lower attempt should classify progress with small fields when possible:
  `leaf`, `source_correspondence_ok`, `lean_parse_ok`, `lean_build_ok`,
  `finite_matrix_ok`, `block_entry_ok`, `ancilla_cleanup_ok`, `normalizer_ok`,
  `closed_theorem_ok`, `error_class`, and `next_route`.
- Suggested `error_class` values: `source_translation_gap`,
  `shape_or_register_gap`, `finite_matrix_counterexample`,
  `symbolic_bridge_gap`, `lean_tactic_gap`, `external_contract_gap`,
  `stale_leaf`, and `invalid_route`.
- In faithful-paper mode, feedback may rank proof routes for the same fixed
  statement, but it must not mutate the paper circuit, oracle contract, theorem,
  or assumptions.  In exploratory mode, feedback may score candidate families,
  but a score is not proof.
- Log structured feedback with:

```bash
python3 tools/qbe.py trial-log --task <task> --role lower --kind attempt \\
  --status failed --feedback-field leaf=<leaf-id> \\
  --feedback-field lean_build_ok=false \\
  --feedback-field error_class=<class> \\
  --feedback-field next_route=\"<next narrow route>\"
```

For GHL2025 one-term closure, useful pre-Lean diagnostics are finite
matrix-entry checks and support/branch decomposition checks.  Timeline or
hardware scheduling checks are not relevant to the current proof blocker.
"""


def strategy_for_mode(mode: str) -> str:
    if mode == "faithfulPaper":
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
"""
    if mode == "exploratoryConstruction":
        return """Hybrid strategy for this mode:

- Use the Learning-Beyond-Gradients-like loop for memory: every candidate,
  rejection, partial success, Lean error, and reviewer concern is logged and
  compressed into the next cycle.
- Use the EoH-like loop only inside the search space: maintain candidate
  populations under `candidate-populations/`, with initialization, mutation,
  crossover/backbone recombination, selection, and archive pressure.
- Represent candidates as reusable oracle/proof DAGs when possible, following
  `.agents/skills/qbe-hierarchical-proof-dag/SKILL.md`; do not keep only a flat
  tactic or gate script when components can be shared.
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
- If this is faithful paper reproduction, use LBG-style proof maintenance and
  local proof-attempt populations only for fixed statements.
- If this is exploratory construction, use LBG-style memory plus EoH-like
  candidate populations for circuit ideas after the acceptance predicate is
  precise.
"""


def focused_task_contract(task_text: str) -> str:
    """Return the current directive plus stable header for token-lean runs."""
    lines = task_text.strip().splitlines()
    header: list[str] = []
    for line in lines[:80]:
        if line.startswith("## "):
            break
        header.append(line)
    matches = list(re.finditer(r"^## Immediate .*?$", task_text, flags=re.M))
    if not matches:
        matches = list(re.finditer(r"^## Current Run Directive.*?$", task_text, flags=re.M))
    if not matches:
        return task_text.strip()
    start = matches[-1].start()
    next_match = re.search(r"^## (?!Immediate|Current Run Directive).*$", task_text[start + 1 :], flags=re.M)
    end = start + 1 + next_match.start() if next_match else len(task_text)
    directive = task_text[start:end].strip()
    prefix = "\n".join(header).strip()
    return (
        (prefix + "\n\n" if prefix else "")
        + directive
        + "\n\n[Focused context mode: older task sections are omitted from this prompt. "
        "Consult the task file only if the current directive is insufficient.]"
    )


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
    strategy = strategy_for_mode(mode)
    paper_sources = local_paper_source_context(task_text)
    verifier_feedback = verifier_feedback_contract()
    blueprint = blueprint_context(task_id)
    displayed_task_text = task_text.strip() if context_mode == "full" else focused_task_contract(task_text)
    context_note = (
        "Full task context."
        if context_mode == "full"
        else "Focused task context: stable header plus the latest immediate/current directive only."
    )
    shared = f"""Task: {task_id} - {title}
Mode: {mode}
Cycle: {cycle}
Run directory: {rel(run_dir)}
Context mode: {context_mode} ({context_note})

Mandatory project gate:

```bash
python3 tools/qbe.py check
```

Shared task contract:

```text
{displayed_task_text}
```

Recent trial memory:

```text
{trial_memory}
```

Proof blueprint snapshot:

```text
{blueprint}
```

Local paper-source archive for agent work:

```text
{paper_sources}
```

	Operating model:

- QBE uses ARIS-style plain-file coordination and Learning-Beyond-Gradients-style
  trial memory, but the scientific target is Lean-checked quantum circuit
  matrix construction.
- Upper is the human-facing project director: choose the cycle objective,
  decide whether the task is faithful paper reproduction or exploratory
  construction, and compress memory for the next cycle.
- Middle is the workflow maintainer: synchronize Lean, Markdown, and LaTeX;
  convert upper strategy into exact declarations, file scopes, proof
  obligations, and lower-agent packets; maintain success/failure memory.
- Lower agents are implementation workers: solve one assigned Lean/circuit
  task, run the gate if they edit Lean, and report useful failures without
  changing the scientific objective.
- Reviewer is the gatekeeper: audit the diff, build status, hidden oracle
  assumptions, normalizers, ancillas, resource counts, links, and Markdown math
  discipline.
	- Lean source is authoritative for correctness.  Markdown and LaTeX are the
	  human-readable proof map.  JSONL/CSV trial logs are the process memory.

	Verifier-feedback discipline:

	```text
	{verifier_feedback}
	```

	Mode discipline:

- In `faithfulPaper` mode, reproduce the cited paper's construction.  Do not
  invent a replacement oracle or block encoding, and do not add assumptions,
  side conditions, or easier variants.  If a paper step is missing or too hard,
  record the exact proof obligation and keep `proved := false`.
- In faithful paper theorem-closure cycles, distinguish the current paper's own
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
  constructions only against a precise Lean-checkable acceptance target.  Do
  not weaken the target or add assumptions to make a candidate pass.
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
  implement exactly one active Lean leaf from that plan.
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
- A cited-results row is enough for faithful theorem closure only when it is a
  precise contract and is not marked proved.  It is not enough for gate-level
  completion of that cited primitive; that belongs to a later task.
- Treat repeated proof failure in faithful-paper mode as a source-dependency
  signal.  Upper and middle should re-read the local TeX source and its
  bibliography around the failing theorem before assigning more lower proof
  search.  If the paper relies on an external result, middle must add a
  precise cited-results entry and lower must not invent the missing theorem or
  add a new assumption.
- Faithful proof translation invariant: if the source TeX contains a proof or
  proof sketch for the target statement, upper and middle must translate that
  proof structure before declaring the Lean task blocked.  Each proof sentence
  or displayed equation should be classified as an existing Lean declaration,
  a new local Lean lemma, an external cited result, or a source-contract gap.
  A `source-contract-gap` classification is acceptable only after the local TeX
  and nearby citations have been checked and no paper-backed gate-level
  ingredient has been found.
- Branch-correctness invariant: a focused finite example must satisfy the same
  branch conditions as the source line it is used to check.  For GHL-style
  boundary/bulk decompositions with thresholds `K_1` and `K_2`, boundary lines
  require `j < K_1` or `K_2 < j`, while bulk lines require
  `K_1 <= j <= K_2`.  A mismatch here is a planning bug to correct, not a
  theorem failure or a human convention request.
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
- Every executed cycle writes a Chinese audit page at
  `runs/<run-id>/zh_summary.md` and archives it under
  `paper-notes/GHL2025/markdown/cycle-summaries/`.  Middle and reviewer should
  make sure the page remains truthful: source `main.tex` anchors, Lean status,
  contract/backlog classifications, and the next proof-DAG leaf must match the
  actual work.
- Every executed cycle also refreshes `runs/<run-id>/memory_digest.md`,
  `runs/<run-id>/todo.md`, and
  `research-wiki/retrieval-index/{task_id}.json`.  Upper and middle agents
  should read this compact retrieval packet before replaying long logs.
- The memory layer separates paper contributions from external technical
  lemmas: GHL-owned proof steps live under
  `research-wiki/paper-contributions/GHL2025/`, while cited primitives,
  standard facts, and reusable contracts live under
  `research-wiki/technical-lemmas/`.
- Lean compilation alone is not enough for faithful paper-reproduction mode;
  humans must be able to compare the Lean names with the original theorem,
  equations, normalizers, register layout, and resource statement.
- Proof-export cadence is deliberately slower than Lean search.  Do not spend
  tokens rewriting a polished proof document after every small lower-agent
  change.  At the end of a multi-hour batch, middle should export all newly
  accepted Lean proof blocks into Markdown and LaTeX under `paper-notes/`,
  with a master Overleaf `main.tex` and section files.  Reviewer should then
  audit that the proof export matches the compiled Lean declarations.
- Project-paper cadence: the paper-specific LaTeX export is an appendix input
  to the larger article "Auto-Lean-in-Sleep: Block Encoding for Quantum
  Computing".  During Lean-heavy cycles, do not spend lower-agent effort on
  article polish.  In the final upper/middle/reviewer audit after a multi-hour
  batch, middle may update the appendix map, project-paper outline, and figure
  todo list so the compiled proof work can later be folded into the main
  article efficiently.
- Article-update cadence: every executed sleep-run cycle writes
  `runs/<run-id>/article_update.md`, `runs/<run-id>/article_update.tex`, and
  archives them under `paper-notes/project-paper/cycle-updates/`.  If the
  ABEIS technical-report directory exists, the latest generated status is also
  mirrored to `appendix/generated_cycle_status.tex`.  Middle owns this
  article-facing bridge; reviewer checks it for honest claims.
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
python3 tools/qbe.py agent-note {run_dir.name} --role {role} --message "..."
python3 tools/qbe.py trial-log --task {task_id} --role {role} --kind handoff --status queued --from-git --artifact {rel(run_dir)}
```
"""
    if role == "upper":
        body = """You are the upper research director and human-intervention window.

Read the task, literature status, prior trials, changed files, and dialogue.
Your job is not to do broad implementation work.  Your job is to keep the
scientific process coherent.

Produce:

1. Task mode for this cycle: faithful paper reproduction, exploratory
   construction, or blocked pending human input.
2. One precise objective.
3. Current proof-DAG frontier: highest theorem, dependency nodes, active
   leaves, stale leaves to retire, and one refiner illness area if needed.
4. Non-goals and directions to stop pursuing, with reasons.
5. Middle-agent instructions for conversion windows, paper notes, proof
   obligations, and memory.
6. Lower-agent work packets with narrow file scopes and acceptance checks.
   If two lower agents are available, assign lower 1 to natural-language
   dependency proof and lower 2 to one compiling Lean active leaf.
7. The verifier-feedback fields expected from lower agents for this cycle,
   including which finite-matrix, source-correspondence, or Lean-gate checks are
   meaningful and which ones are irrelevant.
8. Reviewer checklist.
9. A compressed handoff explaining what future agents should remember.
10. Any cited prior results or classical facts that the next cycle depends on,
   including whether they are already formalized or still obligations.

In faithful paper mode, preserve the paper construction and isolate every
unimplemented oracle as a proof obligation; do not permit new assumptions or
replacement conditions.  In exploratory mode, require a Lean-checkable target
before search begins and reject any target-weakening shortcut.

Faithful paper mode has a phase order.  Phase 1 is a fast, complete paper
transcript: map the paper's theorem, equations, circuit fragments, oracle
contracts, register layout, normalizers, and proof steps into Lean declarations
or explicit obligations.  Do not slow Phase 1 down with broad library
architecture, general-purpose abstractions, or non-critical proofs.  Phase 2,
after the transcript and contracts are complete, may reorganize shared APIs for
teaching, reuse by other papers, and exploratory construction mode.

Before assigning lower work in faithful paper mode, run a source-contract
audit: compare each Lean oracle/circuit contract with the paper's stated
register-level transformation, normalizer, ancilla cleanup condition, and
resource claim.  If a Lean declaration uses a simplified or drifted register
map, make the next objective a correction of that contract rather than a proof
attempt for the drifted statement.

When a faithful-paper proof block fails or becomes blocked, run a source
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
the active leaf for lower 2, and the natural-language proof plan requested from
lower 1.  If a previous lower target is already compiled, retire it instead of
asking another worker to rediscover it.

Require the middle agent to maintain two-way translation every cycle:
paper/LaTeX-to-Lean for the next lower task, and Lean-to-Markdown/LaTeX for
what has actually been proved, failed, or left as an obligation.  Upper should
use that synchronized proof map, not raw Lean diffs alone, when planning the
next cycle.

If a faithful-mode lower attempt fails on a fixed lemma, ask the middle agent to
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
    elif role == "middle":
        body = """You are the middle formalization maintainer and memory manager.

Your job is to translate upper-level scientific strategy into executable Lean
work while preserving a human-readable proof map.

Maintain:

1. Conversion windows: LaTeX symbols, Markdown explanations, Lean names,
   normalizers, register layouts, and resource claims.
2. Paper notes: readable theorem/proof sketches tied to source equations.
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
8. Verifier-feedback memory: for each lower attempt, record the leaf id, typed
   success/failure fields, error class, and next route in `runs/trials.jsonl`
   and, when useful, under `verifier-feedback/`.
9. Project-article update bridge: after each active cycle, ensure the generated
   article update packet reflects the Lean status, proof-DAG frontier, and
   safe manuscript edits.  If stable claims should move into the ABEIS
   technical report, update only the relevant section or generated status
   appendix and cite the supporting artifact.

You are responsible for two-way translation.  Before lower work, translate the
paper's relevant LaTeX theorem/equation/circuit fragment into a Lean-facing
contract.  After lower work, translate the actual Lean declarations, proof
status, failed goals, and remaining obligations back into Markdown and LaTeX
so humans can compare them with the original paper in the next reflection
cycle.

In faithful paper mode, optimize for Phase 1 first: complete the paper transcript
and exact Lean contracts before asking lower agents to prove non-critical
sublemmas or to build reusable library architecture.  If a proof-route lemma is
useful but not on the transcript critical path, record it as proof-route memory
and schedule it later.

For faithful theorem-closure mode, the current paper's theorem should close
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

In faithful mode, maintain proof-attempt populations only for fixed Lean
targets.  In exploratory mode, maintain candidate-population records that track
candidate family, partial score, changed files, remaining obligations, and next
mutation or recombination step.

Before assigning lower work, search for existing Lean declarations and
paper-note definitions to reuse.  Do not create a second definition for a
matrix, normalizer, register layout, or theorem statement when a reference to
the existing one will do.

In faithful paper mode, maintain a source-contract audit before every lower
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

Use `.agents/skills/qbe-project-paper-update/SKILL.md` at the end of a
multi-hour active cycle or when `article_update.md` reports a manuscript-facing
delta.  The update is concise and evidence-preserving: record what changed in
Lean/proof memory, which report section can safely change, and which stronger
claims remain forbidden until Lean and proof notes support them.  Do not spend
lower-agent proof time on article polish.

When two lower agents are available, middle must split the packet deliberately:
lower 1 receives a natural-language DAG/proof packet with source anchors,
definitions, dependencies, and the next Lean lemma; lower 2 receives a Lean
implementation packet for exactly one active leaf.  The Lean packet should
reference the lower-1 proof map if it exists, not restart broad search.

When editing Markdown or LaTeX, follow `.agents/skills/qbe-math-writing/SKILL.md`:
definitions before theorem statements, short claim statements, precise
justifications, and no unannounced assumptions.

When a paper invokes a prior theorem, a "standard" result, or a classical
subroutine, update `research-wiki/cited-results/` before lower work depends on
it.  A cited result entry should name the source, exact statement used, Lean
declaration or planned declaration, dependency sites, and status.  Use
`obligation`, not `formalized`, unless the Lean target is actually present and
build-tested.
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
4. Markdown/LaTeX/Lean correspondence gaps, including Markdown math delimiters.
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
11. Missing two-way translation: after Lean changes, the Markdown/LaTeX proof
	   map must say what was actually proved, what failed, and how that corresponds
	   to the paper statement.
12. Missing cited-results memory for prior work or "standard" facts used by the
	    paper.  Reject a dependency if the source, exact statement, Lean status, or
	    dependent use sites are vague.
13. Missing source-dependency audit after a faithful-paper proof block gets
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

Classify findings as blocking or advisory.  If the current task is faithful
paper reproduction, reject unrecorded invention and any added assumption or
side condition.  Also reject proof work on a Lean oracle contract whose
register-level transformation, ancilla cleanup, or normalizer does not match
the paper.  Public docs should not require a local absolute path to a paper
source; cite the paper and stable theorem/equation/figure anchors instead.  If
Lean fails, localize the failure and suggest the next smallest repair.

In faithful paper mode, also check phase discipline.  During Phase 1, broad
library reorganization, non-critical proof polishing, and reusable API design
are advisory at best; they should not displace completing the paper transcript,
oracle contracts, and proof-obligation map.

In faithful mode, check that proof-attempt populations did not alter the paper
construction.  In exploratory mode, check that candidate scores are treated as
search guidance rather than proof of correctness.
"""
    else:
        body = """You are a lower implementation worker.

You are assigned one concrete Lean/circuit task.  Keep the attempt narrow:
define or repair one matrix, circuit schema, lemma, resource expression, test,
or proof-obligation promotion.  Respect the file scope given by the upper or
middle agent, and assume other agents may be editing nearby documentation.

Run the Lean gate if you edit Lean, or explain why it was not run.  Do not
change the scientific objective.  In faithful paper mode, do not replace the
paper construction with a new one and do not add assumptions.  In exploratory
mode, keep every proposed construction tied to the acceptance predicate.

In faithful paper mode, respect phase order.  If the assigned task is part of
Phase 1, implement only the narrow paper-transcript or contract item you were
given.  Do not introduce broad abstractions, reorganize the library, or switch
to a non-critical proof because it looks reusable.

If the assigned Lean target appears to prove a simplified contract rather than
the paper's register-level transformation, stop and record the mismatch as a
proof obligation instead of continuing implementation.

Before defining anything, search for an existing definition to reference.
Prefer small reusable lemmas over duplicated local encodings.

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

In faithful mode, record failed proof scripts or lemma routes under
`proof-attempts/` when useful.  In exploratory mode, record candidate-family
changes under `candidate-populations/` when useful, especially when the attempt
improves a partial Lean score but does not yet prove the target.
"""
        if lower_index == 1:
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
6. A short handoff in `proof-attempts/` or the dialogue board.

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
3. `python3 tools/qbe.py check` after Lean edits.
4. A handoff naming the exact theorem closed or the exact remaining Lean goal.
5. If the proof blocks, store the useful failed route under `proof-attempts/`.

Do not spend the cycle on broad prose polish.  The natural-language proof
agent owns proof design; you own compiled declarations and gate checks.
If the active leaf is underspecified or stale, do not improvise a new theorem;
record the missing DAG packet and ask middle to refresh the frontier.
"""
        elif lower_index > 2:
            body += f"""
Lower profile for this prompt: auxiliary proof-route worker `{lower_index}`.

Try an independent route to the same fixed theorem or lemma.  Coordinate
through the dialogue board, avoid overlapping file edits where possible, and
preserve useful failed fragments as proof-attempt memory.
"""
    return f"# {role.title()} Agent Prompt\n\n{body}\n\n## Shared Context\n\n{shared}"


def create_run_cycle(
    task_id: str,
    cycle: int,
    lower_count: int,
    run_id: str | None = None,
    context_mode: str = "full",
    blueprint_refresh: bool = False,
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
"""
    (run_dir / "00_context.md").write_text(context, encoding="utf-8")
    (run_dir / "dialogue.md").write_text(
        f"# Dialogue: {task_id} cycle {cycle}\n\nAppend short role-tagged handoffs here.\n",
        encoding="utf-8",
    )
    prompt_files = [
        ("upper", run_dir / "10_upper_director.md", 0),
        ("middle", run_dir / "20_middle_formalizer.md", 0),
    ]
    for index in range(1, lower_count + 1):
        prompt_files.append(("lower", run_dir / f"30_lower_searcher_{index}.md", index))
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
            "notes": f"Created prompt deck with {lower_count} lower agent(s).",
        },
    )
    write_trial_summary(load_jsonl(TRIAL_LOG))
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


def run_agent_command(template: str, prompt: Path, run_dir: Path, task_id: str, cycle: int) -> int:
    command = format_agent_command(template, prompt, run_dir, task_id, cycle)
    print("$ " + command)
    completed = subprocess.run(command, cwd=ROOT, shell=True)
    return completed.returncode


def log_agent_attempt(
    task_id: str,
    run_dir: Path,
    prompt: Path,
    command: str,
    code: int,
) -> None:
    status = "accepted" if code == 0 else "failed"
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
            "changed_files": git_changed_files(),
            "command": command,
            "notes": f"External agent command exit code {code}.",
        },
    )
    write_trial_summary(load_jsonl(TRIAL_LOG))


def cmd_sleep_run(args: argparse.Namespace) -> int:
    cmd_init(argparse.Namespace())
    if args.execute and not args.agent_cmd:
        raise SystemExit("--execute requires --agent-cmd")
    if args.dry_run and args.execute:
        raise SystemExit("--dry-run and --execute cannot be used together")
    if args.upper_every < 0 or args.middle_every < 0 or args.reviewer_every < 0:
        raise SystemExit("--upper-every, --middle-every, and --reviewer-every must be nonnegative")
    final_code = 0
    for cycle in range(1, args.cycles + 1):
        run_dir = create_run_cycle(
            args.id,
            cycle,
            args.lower_count,
            context_mode=args.context_mode,
            blueprint_refresh=args.blueprint_refresh,
        )
        print(f"cycle {cycle}: {rel(run_dir)}")
        prompts = []
        if args.upper_every > 0 and (cycle - 1) % args.upper_every == 0:
            prompts.append(run_dir / "10_upper_director.md")
        if args.middle_every > 0 and (cycle - 1) % args.middle_every == 0:
            prompts.append(run_dir / "20_middle_formalizer.md")
        prompts.extend(sorted(run_dir.glob("30_lower_searcher_*.md")))
        if (
            not args.skip_reviewer
            and args.reviewer_every > 0
            and (cycle - 1) % args.reviewer_every == 0
        ):
            prompts.append(run_dir / "40_reviewer.md")
        if args.dry_run or not args.agent_cmd:
            print("dry run: prompt deck created, no external agent command executed")
            continue
        if not args.execute:
            print("agent command configured but not executed; pass --execute to run it")
            continue
        cycle_code = 0
        if args.parallel_lower:
            pre_prompts = [prompt for prompt in prompts if prompt_role(prompt) in {"upper", "middle"}]
            lower_prompts = [prompt for prompt in prompts if prompt_role(prompt) == "lower"]
            post_prompts = [prompt for prompt in prompts if prompt_role(prompt) == "reviewer"]
            for prompt in pre_prompts:
                command = format_agent_command(args.agent_cmd, prompt, run_dir, args.id, cycle)
                print("$ " + command)
                code = subprocess.run(command, cwd=ROOT, shell=True).returncode
                log_agent_attempt(args.id, run_dir, prompt, command, code)
                if code != 0:
                    cycle_code = code
                    break
            if cycle_code == 0 and lower_prompts:
                running = []
                for prompt in lower_prompts:
                    command = format_agent_command(args.agent_cmd, prompt, run_dir, args.id, cycle)
                    print("$ " + command)
                    process = subprocess.Popen(command, cwd=ROOT, shell=True)
                    running.append((prompt, command, process))
                for prompt, command, process in running:
                    code = process.wait()
                    log_agent_attempt(args.id, run_dir, prompt, command, code)
                    if code != 0:
                        cycle_code = code
            if cycle_code == 0:
                for prompt in post_prompts:
                    command = format_agent_command(args.agent_cmd, prompt, run_dir, args.id, cycle)
                    print("$ " + command)
                    code = subprocess.run(command, cwd=ROOT, shell=True).returncode
                    log_agent_attempt(args.id, run_dir, prompt, command, code)
                    if code != 0:
                        cycle_code = code
                        break
        else:
            for prompt in prompts:
                command = format_agent_command(args.agent_cmd, prompt, run_dir, args.id, cycle)
                code = run_agent_command(args.agent_cmd, prompt, run_dir, args.id, cycle)
                log_agent_attempt(args.id, run_dir, prompt, command, code)
                if code != 0:
                    cycle_code = code
                    break
        if cycle_code != 0:
            final_code = cycle_code
        if args.check_each_cycle:
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
                    "changed_files": git_changed_files(),
                    "command": "lake build && lake build Tests",
                    "notes": "Cycle build gate.",
                },
            )
            write_trial_summary(load_jsonl(TRIAL_LOG))
            if code != 0:
                write_cycle_zh_summary(args.id, cycle, run_dir)
                write_memory_refresh(args.id, cycle, run_dir)
                if not args.skip_article_update:
                    write_project_article_update(args.id, cycle, run_dir)
                return code
        write_cycle_zh_summary(args.id, cycle, run_dir)
        write_memory_refresh(args.id, cycle, run_dir)
        if not args.skip_article_update:
            write_project_article_update(args.id, cycle, run_dir)
        if final_code != 0:
            return final_code
    return final_code


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
    append_line(board, "")
    append_line(board, f"## {now_stamp()} - {args.role}")
    append_line(board, "")
    append_line(board, message.strip())
    add_manifest("qbe.py agent-note", board, "dialogue", f"Appended {args.role} note")
    print(f"updated {rel(board)}")
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Quantum block encoding project helper")
    sub = parser.add_subparsers(dest="cmd", required=True)

    sub.add_parser("init", help="initialize QBE workflow files").set_defaults(func=cmd_init)
    sub.add_parser("check", help="run Lean build gates").set_defaults(func=cmd_check)
    sub.add_parser("status", help="show git status and run build gates").set_defaults(func=cmd_status)
    sub.add_parser("list-literature", help="list literature registry entries").set_defaults(
        func=cmd_list_literature
    )
    sub.add_parser("list-tasks", help="list task files").set_defaults(func=cmd_list_tasks)
    sub.add_parser("next-task", help="suggest the next task").set_defaults(func=cmd_next_task)

    p_task = sub.add_parser("new-task", help="create a task contract in tasks/")
    p_task.add_argument("id")
    p_task.add_argument("--title", required=True)
    p_task.add_argument("--kind", default="paperFormalization")
    p_task.add_argument(
        "--mode",
        choices=["faithfulPaper", "exploratoryConstruction", "unspecified"],
        default="unspecified",
    )
    p_task.add_argument("--source", default="")
    p_task.add_argument("--target-lean", default="QuantumBlockEncoding/OpenProblems.lean")
    p_task.set_defaults(func=cmd_new_task)

    p_update = sub.add_parser("update-task", help="update task status")
    p_update.add_argument("id")
    p_update.add_argument("--status", required=True)
    p_update.add_argument("--active", action="store_true")
    p_update.set_defaults(func=cmd_update_task)

    p_window = sub.add_parser("conversion-window", help="create a Lean/LaTeX/Markdown window")
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

    p_zh_summary = sub.add_parser("cycle-zh-summary", help="write a Chinese paper-source cycle summary")
    p_zh_summary.add_argument("id")
    p_zh_summary.add_argument("--cycle", type=int, default=1)
    p_zh_summary.add_argument("--run-id", default="latest")
    p_zh_summary.set_defaults(func=cmd_cycle_zh_summary)

    p_memory = sub.add_parser("memory-refresh", help="refresh compact task memory and retrieval index")
    p_memory.add_argument("id")
    p_memory.add_argument("--cycle", type=int, default=1)
    p_memory.add_argument("--run-id", default="latest")
    p_memory.set_defaults(func=cmd_memory_refresh)

    p_human = sub.add_parser("human-status", help="write the root human-facing status dashboard")
    p_human.add_argument("id")
    p_human.add_argument("--run-id", default="latest")
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
    p_cycle.add_argument("--lower-count", type=int, default=2)
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
    p_cycle.set_defaults(func=cmd_run_cycle)

    p_sleep = sub.add_parser("sleep-run", help="create or execute repeated agent cycles")
    p_sleep.add_argument("id")
    p_sleep.add_argument("--cycles", type=int, default=8)
    p_sleep.add_argument("--lower-count", type=int, default=2)
    p_sleep.add_argument("--agent-cmd", default="")
    p_sleep.add_argument("--execute", action="store_true")
    p_sleep.add_argument("--dry-run", action="store_true")
    p_sleep.add_argument("--check-each-cycle", action="store_true")
    p_sleep.add_argument(
        "--context-mode",
        choices=("full", "focused"),
        default="full",
        help="use full task text or only the current directive plus stable header",
    )
    p_sleep.add_argument(
        "--blueprint-refresh",
        action="store_true",
        help="refresh proof-blueprints/<task>.md before every cycle",
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
        action="store_true",
        help="execute lower-agent prompts concurrently after upper/middle complete",
    )
    p_sleep.add_argument(
        "--skip-article-update",
        action="store_true",
        help="do not write project-paper article_update artifacts after each executed cycle",
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
