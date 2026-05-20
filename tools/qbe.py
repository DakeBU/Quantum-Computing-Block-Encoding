#!/usr/bin/env python3
"""QBE local workflow helper.

This file is adapted from the plain-file workflow philosophy of ARIS
(`wanshuiyin/Auto-claude-code-research-in-sleep`, MIT License), but all code in
this helper is QBE-specific.  It intentionally has no third-party dependencies.
It also adopts the trial JSONL / summary CSV pattern used in the public
Learning Beyond Gradients artifact repository.

The helper is not an AI agent.  It is the stable command surface an agent can
use while keeping all source-of-truth files in this Lean repository.
"""

from __future__ import annotations

import argparse
import csv
import datetime as _dt
import json
import re
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
STATE_DIR = ROOT / ".qbe"
STATE_FILE = STATE_DIR / "state.json"
MANIFEST = ROOT / "MANIFEST.md"
QBE_DASHBOARD = ROOT / "QBE.md"
FINDINGS = ROOT / "findings.md"
TRIAL_LOG = ROOT / "runs" / "trials.jsonl"
TRIAL_SUMMARY = ROOT / "runs" / "trials_summary.csv"

AGENT_ROLES = ("upper", "middle", "lower", "reviewer")
TRIAL_KINDS = ("plan", "attempt", "build", "review", "proposal", "compression", "handoff")
TRIAL_STATUSES = ("queued", "running", "blocked", "failed", "compiled", "accepted", "rejected")

WORK_DIRS = [
    "tasks",
    "conversion-windows",
    "paper-notes",
    "agent-briefs",
    "proof-attempts",
    "candidate-populations",
    "open-problem-proposals",
    "proof-obligations",
    "reviews",
    "runs",
    "research-wiki/papers",
    "research-wiki/ideas",
    "research-wiki/claims",
    "research-wiki/experiments",
    "research-wiki/graph",
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


def now_stamp() -> str:
    return _dt.datetime.now().strftime("%Y-%m-%d %H:%M:%S")


def file_stamp() -> str:
    return _dt.datetime.now().strftime("%Y%m%d-%H%M%S")


def slugify(value: str) -> str:
    value = re.sub(r"[^A-Za-z0-9_.-]+", "-", value).strip("-")
    return value or "untitled"


def rel(path: Path) -> str:
    return str(path.relative_to(ROOT))


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
    runs = [p for p in (ROOT / "runs").glob("*") if p.is_dir()]
    return sorted(runs)[-1] if runs else None


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
    rel = file.relative_to(ROOT) if file.is_absolute() else file
    append_line(MANIFEST, f"| {now_stamp()} | {tool} | `{rel}` | {stage} | {description} |")


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


def write_trial_summary(records: list[dict]) -> list[dict]:
    rows = []
    cumulative_by_task: dict[str, int] = {}
    compiled_by_task: dict[str, int] = {}
    for index, record in enumerate(records, start=1):
        task_id = str(record.get("task_id", "unknown"))
        cumulative_by_task[task_id] = cumulative_by_task.get(task_id, 0) + 1
        if record.get("status") == "compiled" or record.get("lean_gate") == "pass":
            compiled_by_task[task_id] = compiled_by_task.get(task_id, 0) + 1
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


def role_prompt(role: str, task_id: str, title: str, task_text: str, cycle: int, run_dir: Path) -> str:
    trial_memory = recent_trial_text(task_id, limit=12)
    mode = infer_task_mode(task_text)
    strategy = strategy_for_mode(mode)
    shared = f"""Task: {task_id} - {title}
Mode: {mode}
Cycle: {cycle}
Run directory: {rel(run_dir)}

Mandatory project gate:

```bash
python3 tools/qbe.py check
```

Shared task contract:

```text
{task_text.strip()}
```

Recent trial memory:

```text
{trial_memory}
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

Mode discipline:

- In `faithfulPaper` mode, reproduce the cited paper's construction.  Do not
  invent a replacement oracle or block encoding, and do not add assumptions,
  side conditions, or easier variants.  If a paper step is missing or too hard,
  record the exact proof obligation and keep `proved := false`.
- In `exploratoryConstruction` mode, propose new oracle/block-encoding
  constructions only against a precise Lean-checkable acceptance target.  Do
  not weaken the target or add assumptions to make a candidate pass.
- If the mode is `unspecified`, the upper agent must classify the task before
  lower agents perform broad code changes.
- Prefer referencing shared Lean declarations and existing paper-note
  definitions.  Do not duplicate a definition in another file when an existing
  declaration or notation table can be referenced.

{strategy}

Human-facing correspondence rule:

- If a cycle changes Lean declarations tied to a paper construction, update the
  conversion window, a `paper-notes/*.tex` note, or a `proof-obligations/`
  ledger in the same cycle.
- Lean compilation alone is not enough for faithful paper-reproduction mode;
  humans must be able to compare the Lean names with the original theorem,
  equations, normalizers, register layout, and resource statement.
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
3. Non-goals and directions to stop pursuing, with reasons.
4. Middle-agent instructions for conversion windows, paper notes, proof
   obligations, and memory.
5. Lower-agent work packets with narrow file scopes and acceptance checks.
6. Reviewer checklist.
7. A compressed handoff explaining what future agents should remember.

In faithful paper mode, preserve the paper construction and isolate every
unimplemented oracle as a proof obligation; do not permit new assumptions or
replacement conditions.  In exploratory mode, require a Lean-checkable target
before search begins and reject any target-weakening shortcut.

If a faithful-mode lower attempt fails on a fixed lemma, ask the middle agent to
start or update a `proof-attempts/` record rather than changing the theorem.  If
an exploratory-mode candidate family looks promising, assign separate lower
workers to mutation, recombination, and proof-obligation reduction in disjoint
file scopes.

When assigning documentation work, require the `qbe-math-writing` skill and
ask the reviewer to check definition ordering, citation precision, and whether
shared Lean definitions were referenced instead of duplicated.
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

When editing Markdown or LaTeX, follow `.agents/skills/qbe-math-writing/SKILL.md`:
definitions before theorem statements, short claim statements, precise
justifications, and no unannounced assumptions.
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

Classify findings as blocking or advisory.  If the current task is faithful
paper reproduction, reject unrecorded invention and any added assumption or
side condition.  If Lean fails, localize the failure and suggest the next
smallest repair.

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

Before defining anything, search for an existing definition to reference.
Prefer small reusable lemmas over duplicated local encodings.

Write failures clearly; a failed attempt is useful search data when it
identifies a blocked assumption, missing lemma, or impossible file scope.

In faithful mode, record failed proof scripts or lemma routes under
`proof-attempts/` when useful.  In exploratory mode, record candidate-family
changes under `candidate-populations/` when useful, especially when the attempt
improves a partial Lean score but does not yet prove the target.
"""
    return f"# {role.title()} Agent Prompt\n\n{body}\n\n## Shared Context\n\n{shared}"


def create_run_cycle(task_id: str, cycle: int, lower_count: int, run_id: str | None = None) -> Path:
    cmd_init(argparse.Namespace())
    title, task_text = task_context(task_id)
    run_name = run_id or f"{file_stamp()}-{slugify(task_id)}-cycle{cycle:02d}"
    run_dir = ROOT / "runs" / run_name
    run_dir.mkdir(parents=True, exist_ok=False)
    context = f"""# Run Context

Task id: `{task_id}`
Title: {title}
Cycle: `{cycle}`
Created: `{now_stamp()}`

Use this directory as the shared workspace for one upper/middle/lower/reviewer
cycle.  Agents converse through `dialogue.md`; durable results go into
`runs/trials.jsonl` and source files.

## Task Contract

{task_text}

## Recent Trial Memory

```text
{recent_trial_text(task_id, limit=12)}
```
"""
    (run_dir / "00_context.md").write_text(context, encoding="utf-8")
    (run_dir / "dialogue.md").write_text(
        f"# Dialogue: {task_id} cycle {cycle}\n\nAppend short role-tagged handoffs here.\n",
        encoding="utf-8",
    )
    prompt_files = [
        ("upper", run_dir / "10_upper_director.md"),
        ("middle", run_dir / "20_middle_formalizer.md"),
    ]
    for index in range(1, lower_count + 1):
        prompt_files.append(("lower", run_dir / f"30_lower_searcher_{index}.md"))
    prompt_files.append(("reviewer", run_dir / "40_reviewer.md"))
    for role, path in prompt_files:
        path.write_text(role_prompt(role, task_id, title, task_text, cycle, run_dir), encoding="utf-8")
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
            "changed_files": [rel(p) for _, p in prompt_files] + [rel(run_dir / "00_context.md"), rel(run_dir / "dialogue.md")],
            "command": "qbe.py run-cycle",
            "notes": f"Created prompt deck with {lower_count} lower agent(s).",
        },
    )
    write_trial_summary(load_jsonl(TRIAL_LOG))
    add_manifest("qbe.py run-cycle", run_dir, "run", f"Created run cycle for {task_id}")
    return run_dir


def cmd_run_cycle(args: argparse.Namespace) -> int:
    run_dir = create_run_cycle(args.id, args.cycle, args.lower_count, args.run_id)
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


def run_agent_command(template: str, prompt: Path, run_dir: Path, task_id: str, cycle: int) -> int:
    role = prompt_role(prompt)
    command = template.format(
        root=str(ROOT),
        prompt=str(prompt),
        run_dir=str(run_dir),
        task=task_id,
        cycle=cycle,
        role=role,
    )
    print("$ " + command)
    completed = subprocess.run(command, cwd=ROOT, shell=True)
    return completed.returncode


def cmd_sleep_run(args: argparse.Namespace) -> int:
    cmd_init(argparse.Namespace())
    if args.execute and not args.agent_cmd:
        raise SystemExit("--execute requires --agent-cmd")
    if args.dry_run and args.execute:
        raise SystemExit("--dry-run and --execute cannot be used together")
    final_code = 0
    for cycle in range(1, args.cycles + 1):
        run_dir = create_run_cycle(args.id, cycle, args.lower_count)
        print(f"cycle {cycle}: {rel(run_dir)}")
        prompts = [
            run_dir / "10_upper_director.md",
            run_dir / "20_middle_formalizer.md",
            *sorted(run_dir.glob("30_lower_searcher_*.md")),
            run_dir / "40_reviewer.md",
        ]
        if args.dry_run or not args.agent_cmd:
            print("dry run: prompt deck created, no external agent command executed")
            continue
        if not args.execute:
            print("agent command configured but not executed; pass --execute to run it")
            continue
        for prompt in prompts:
            code = run_agent_command(args.agent_cmd, prompt, run_dir, args.id, cycle)
            status = "accepted" if code == 0 else "failed"
            append_jsonl(
                TRIAL_LOG,
                {
                    "timestamp": now_stamp(),
                    "trial_id": f"{run_dir.name}-{prompt.stem}",
                    "task_id": args.id,
                    "role": prompt_role(prompt),
                    "kind": "attempt",
                    "status": status,
                    "score": "",
                    "lean_gate": "",
                    "artifact": rel(prompt),
                    "changed_files": git_changed_files(),
                    "command": args.agent_cmd,
                    "notes": f"External agent command exit code {code}.",
                },
            )
            write_trial_summary(load_jsonl(TRIAL_LOG))
            if code != 0:
                final_code = code
                break
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
                return code
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
    p_trial.set_defaults(func=cmd_trial_log)

    sub.add_parser("trial-summary", help="rewrite and print the trial summary").set_defaults(
        func=cmd_trial_summary
    )

    p_cycle = sub.add_parser("run-cycle", help="create one upper/middle/lower/reviewer prompt deck")
    p_cycle.add_argument("id")
    p_cycle.add_argument("--cycle", type=int, default=1)
    p_cycle.add_argument("--lower-count", type=int, default=2)
    p_cycle.add_argument("--run-id", default="")
    p_cycle.set_defaults(func=cmd_run_cycle)

    p_sleep = sub.add_parser("sleep-run", help="create or execute repeated agent cycles")
    p_sleep.add_argument("id")
    p_sleep.add_argument("--cycles", type=int, default=8)
    p_sleep.add_argument("--lower-count", type=int, default=2)
    p_sleep.add_argument("--agent-cmd", default="")
    p_sleep.add_argument("--execute", action="store_true")
    p_sleep.add_argument("--dry-run", action="store_true")
    p_sleep.add_argument("--check-each-cycle", action="store_true")
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
