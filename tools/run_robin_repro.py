#!/usr/bin/env python3
"""Prepare, run, and audit the isolated Robin cold/warm ASPBE benchmark."""

from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import shutil
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_SUITE = ROOT.parent / "abeis_isolated_runs" / "20260812-robin-v1"
ARMS = {
    "cold": "QBE-ROBIN-BE-COLD-001",
    "warm": "QBE-ROBIN-BE-WARM-001",
}
FORBIDDEN_COLD_SOURCES = (
    "QuantumBlockEncoding/GHL2025.lean",
    "QuantumBlockEncoding/Examples/RobinHeat.lean",
    "QuantumBlockEncoding/RobinMatrix.lean",
)
MASKED_COLD_PATHS = (
    "QuantumBlockEncoding/GHL2025.lean",
    "QuantumBlockEncoding/Examples/RobinHeat.lean",
    "QuantumBlockEncoding/RobinMatrix.lean",
    "QuantumBlockEncoding/Papers/GHL2025.lean",
    "ABEISBlueprint/Catalog/ExperimentalRobinMatrix.lean",
    "docs/blueprint-coverage.json",
    "research-wiki/block-encoding-library/compiled-lean-leaf-index.json",
    "research-wiki/block-encoding-library/compiled-lean-leaf-index.md",
)


def command(args: list[str], *, cwd: Path, check: bool = True) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        args,
        cwd=cwd,
        check=check,
        text=True,
        encoding="utf-8",
        errors="replace",
    )


def arm_root(suite: Path, arm: str) -> Path:
    return suite / arm.upper()


def prepare_arm(suite: Path, arm: str, *, force: bool) -> None:
    destination = arm_root(suite, arm)
    if destination.exists():
        if not force:
            print(f"kept existing worktree: {destination}")
            return
        command(["git", "worktree", "remove", "--force", str(destination)], cwd=ROOT)
    destination.parent.mkdir(parents=True, exist_ok=True)
    command(["git", "worktree", "add", "--detach", str(destination), "HEAD"], cwd=ROOT)

    task_id = ARMS[arm]
    shutil.copy2(ROOT / "tasks" / f"{task_id}.md", destination / "tasks" / f"{task_id}.md")
    # The benchmark may exercise uncommitted harness repairs under review.  Copy
    # their exact bytes into each detached worktree and record them as dirty
    # experiment inputs instead of silently falling back to the base commit.
    for relative in (
        "tools/qbe.py",
        "tools/qbe_control.py",
        "tools/qbe_codex_agent.sh",
        "tools/enforce_mutation_scope.py",
        "tools/test_qbe_control.py",
        "tools/test_enforce_mutation_scope.py",
        "scripts/build-all.sh",
    ):
        source = ROOT / relative
        destination_file = destination / relative
        destination_file.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, destination_file)
    experiment = destination / "experiments" / "robin-be"
    experiment.mkdir(parents=True, exist_ok=True)
    for name in ("README.md", "benchmark.json"):
        shutil.copy2(ROOT / "experiments" / "robin-be" / name, experiment / name)

    masked: list[str] = []
    if arm == "cold":
        root_imports = destination / "QuantumBlockEncoding.lean"
        root_text = root_imports.read_text(encoding="utf-8")
        for import_line in (
            "import QuantumBlockEncoding.Examples.RobinHeat\n",
            "import QuantumBlockEncoding.GHL2025\n",
            "import QuantumBlockEncoding.RobinMatrix\n",
        ):
            root_text = root_text.replace(import_line, "")
        root_imports.write_text(root_text, encoding="utf-8")

        open_problems = destination / "QuantumBlockEncoding" / "OpenProblems.lean"
        open_text = open_problems.read_text(encoding="utf-8").replace(
            "import QuantumBlockEncoding.GHL2025",
            "import QuantumBlockEncoding.BlockEncoding",
            1,
        )
        open_problems.write_text(open_text, encoding="utf-8")

        tests = destination / "ABEISTests" / "Basic.lean"
        test_text = tests.read_text(encoding="utf-8")
        test_text = test_text.replace(
            "example :\n"
            "    (GHL2025.oneTermRobinResource { n := 5, kappa := 7, functionPieces := 1, polynomialDegreeCost := 3 }).pureAncilla = 10 := rfl\n\n"
            "example : Examples.RobinHeat.fourthOrderSecondDerivative.width = 5 := rfl\n\n",
            "",
        )
        tests.write_text(test_text, encoding="utf-8")

        for relative in MASKED_COLD_PATHS:
            path = destination / relative
            if path.is_file() or path.is_symlink():
                path.unlink()
                masked.append(relative)
        for relative in (
            ".claude/worktrees",
            "paper-notes/GHL2025",
        ):
            path = destination / relative
            if path.is_dir():
                shutil.rmtree(path)
                masked.append(relative + "/")

    packages = ROOT / ".lake" / "packages"
    local_lake = destination / ".lake"
    local_lake.mkdir(exist_ok=True)
    package_link = local_lake / "packages"
    if packages.is_dir() and not package_link.exists():
        package_link.symlink_to(packages, target_is_directory=True)

    metadata = {
        "schema_version": 1,
        "arm": arm,
        "task": task_id,
        "prepared_at": dt.datetime.now(dt.timezone.utc).isoformat(),
        "source_commit": subprocess.check_output(
            ["git", "rev-parse", "HEAD"], cwd=ROOT, text=True
        ).strip(),
        "model": os.environ.get("CODEX_MODEL", "gpt-5.6-sol"),
        "cold_forbidden_sources": list(FORBIDDEN_COLD_SOURCES) if arm == "cold" else [],
        "masked_cold_paths": masked,
    }
    (experiment / "run-metadata.json").write_text(
        json.dumps(metadata, indent=2) + "\n", encoding="utf-8"
    )
    command(["git", "add", "-A"], cwd=destination)
    command(
        [
            "git",
            "-c",
            "user.name=ASPBE isolated benchmark",
            "-c",
            "user.email=isolated-benchmark@invalid.local",
            "commit",
            "-m",
            f"Prepare isolated Robin {arm} benchmark inputs",
        ],
        cwd=destination,
    )
    print(f"prepared {arm}: {destination}")


def run_arm(suite: Path, arm: str, cycles: int, minutes: int) -> int:
    root = arm_root(suite, arm)
    if not root.is_dir():
        raise SystemExit(f"missing worktree {root}; run prepare first")
    task_id = ARMS[arm]
    agent_cmd = "cd {root} && bash tools/qbe_codex_agent.sh {root} {prompt}"
    args = [
        sys.executable,
        "tools/qbe.py",
        "sleep-run",
        task_id,
        "--cycles",
        str(cycles),
        "--active-budget-minutes",
        str(minutes),
        "--agent-cmd",
        agent_cmd,
        "--execute",
        "--check-each-cycle",
        "--report-language",
        "en",
        "--context-mode",
        "focused",
        "--blueprint-refresh",
        "--adaptive-capacity",
        "--max-no-progress-cycles",
        "2",
        "--max-external-gap-cycles",
        "1",
        "--max-run-input-tokens",
        "220000",
        "--hierarchical-harness",
        "--upper-panel",
        "--middle-panel",
        "--lower-count",
        "2",
        "--parallel-lower",
    ]
    environment = os.environ.copy()
    environment.setdefault("CODEX_MODEL", "gpt-5.6-sol")
    shared_scope = [
        "QuantumBlockEncoding/RobinEvolution.lean",
        "QuantumBlockEncoding.lean",
        f"tasks/{task_id}.md",
        f"proof-obligations/{task_id}.md",
        f"proof-blueprints/{task_id}.md",
        f"proof-blueprints/{task_id}-*",
        f"conversion-windows/{task_id}.md",
        f"candidate-populations/{task_id}/",
        f"verifier-feedback/{task_id}/",
        f"proof-attempts/{task_id}/",
        f"proof-attempts/{task_id}-*",
        f"reviews/{task_id}-*",
        f"paper-notes/{task_id}/",
        f"paper-notes/problem-exports/{task_id}/",
        f"research-wiki/retrieval-index/{task_id}.json",
        f"research-wiki/block-encoding-library/insight-pool/{task_id}.md",
        f"executable-exports/{task_id}/",
        "experiments/robin-be/results/",
        "tools/export_robin_evolution.py",
        "runs/",
        "MANIFEST.md",
        "REPORTS.zh.md",
        "HUMAN_STATUS.md",
        "findings.md",
    ]
    if arm == "warm":
        shared_scope.extend(
            [
                "QuantumBlockEncoding/GHL2025.lean",
                "QuantumBlockEncoding/RobinMatrix.lean",
                "QuantumBlockEncoding/Examples/RobinHeat.lean",
            ]
        )
    environment["QBE_MUTATION_ALLOWLIST"] = ":".join(shared_scope)
    status_path = root / "experiments" / "robin-be" / "run-status.json"
    status = {
        "schema_version": 1,
        "arm": arm,
        "task": task_id,
        "state": "started",
        "model": environment["CODEX_MODEL"],
        "requested_cycles": cycles,
        "active_budget_minutes": minutes,
        "started_at": dt.datetime.now(dt.timezone.utc).isoformat(),
    }
    status_path.write_text(json.dumps(status, indent=2) + "\n", encoding="utf-8")
    try:
        completed = subprocess.run(args, cwd=root, env=environment, check=False)
    except KeyboardInterrupt:
        status.update(
            state="interrupted",
            stopped_at=dt.datetime.now(dt.timezone.utc).isoformat(),
            reason="operator_interrupt",
            returncode=130,
        )
        status_path.write_text(json.dumps(status, indent=2) + "\n", encoding="utf-8")
        return 130
    status.update(
        state="completed",
        stopped_at=dt.datetime.now(dt.timezone.utc).isoformat(),
        returncode=completed.returncode,
    )
    status_path.write_text(json.dumps(status, indent=2) + "\n", encoding="utf-8")
    return completed.returncode


def newest_run(root: Path, task_id: str) -> Path | None:
    candidates = sorted((root / "runs").glob(f"*{task_id}-cycle*"))
    return candidates[-1] if candidates else None


def audit_arm(suite: Path, arm: str) -> dict[str, object]:
    root = arm_root(suite, arm)
    task_id = ARMS[arm]
    control_path = root / "runs" / "control" / f"{task_id}.json"
    control = json.loads(control_path.read_text()) if control_path.is_file() else {}
    run = newest_run(root, task_id)
    diff_names = subprocess.run(
        ["git", "diff", "--name-only"], cwd=root, capture_output=True, text=True, check=False
    ).stdout.splitlines()

    contamination: list[str] = []
    if arm == "cold":
        for source in FORBIDDEN_COLD_SOURCES:
            if source in diff_names:
                contamination.append(f"modified forbidden source: {source}")
        inspect_roots = [root / "proof-attempts" / task_id, root / "reports" / task_id]
        if run:
            inspect_roots.append(run)
        for base in inspect_roots:
            if not base.exists():
                continue
            for path in base.rglob("*"):
                if not path.is_file() or path.suffix not in {".md", ".json", ".txt"}:
                    continue
                text = path.read_text(encoding="utf-8", errors="ignore")
                for source in FORBIDDEN_COLD_SOURCES:
                    # The task packet itself declares the forbidden list; generated
                    # prompts may quote it. Only agent-owned artifacts count here.
                    if source in text and "prompt" not in path.name.lower():
                        contamination.append(f"agent artifact cites {source}: {path.relative_to(root)}")

    population = root / "candidate-populations" / task_id / "population-state.json"
    population_data: dict[str, object] = {}
    if not population.is_file():
        legacy = root / "candidate-populations" / f"{task_id}.md"
        population_status = "legacy" if legacy.is_file() else "missing"
    else:
        population_status = "present"
        population_data = json.loads(population.read_text(encoding="utf-8"))
    metadata_path = root / "experiments" / "robin-be" / "run-metadata.json"
    metadata = json.loads(metadata_path.read_text(encoding="utf-8")) if metadata_path.is_file() else {}
    run_status_path = root / "experiments" / "robin-be" / "run-status.json"
    run_status = (
        json.loads(run_status_path.read_text(encoding="utf-8"))
        if run_status_path.is_file()
        else {}
    )
    controller_status = control.get("status", "not-started")
    if controller_status == "running" and run_status.get("state") == "interrupted":
        controller_status = "interrupted"
    attempted_cycles = len(list((root / "runs").glob(f"*{task_id}-cycle*")))
    completed_cycle_ids: set[str] = set()
    trials_path = root / "runs" / "trials.jsonl"
    if trials_path.is_file():
        for line in trials_path.read_text(encoding="utf-8", errors="replace").splitlines():
            try:
                trial = json.loads(line)
            except json.JSONDecodeError:
                continue
            trial_id = str(trial.get("trial_id", ""))
            if (
                trial.get("task_id") == task_id
                and trial.get("role") == "reviewer"
                and trial.get("status") == "compiled"
                and trial_id.endswith("-build-gate")
            ):
                completed_cycle_ids.add(trial_id.removesuffix("-build-gate"))
    result = {
        "arm": arm,
        "task": task_id,
        "worktree": arm.upper(),
        "model": metadata.get("model", "unknown"),
        "latest_run": str(run.relative_to(root)) if run else None,
        "controller_status": controller_status,
        "controller_mode": control.get("mode"),
        "runner_state": run_status.get("state", "unknown"),
        "runner_stop_reason": run_status.get("reason"),
        "attempted_cycles": attempted_cycles,
        "completed_cycles": len(completed_cycle_ids),
        "estimated_run_input_tokens": control.get("estimated_run_input_tokens", 0),
        "certified_root_anchors": control.get("certified_root_anchors", []),
        "population": population_status,
        "population_active_candidate_ids": population_data.get("active_candidate_ids", []),
        "population_selected_candidate_ids": population_data.get("selected_candidate_ids", []),
        "provider_blocked": control.get("status") == "provider-blocked",
        "cold_isolation_passed": arm != "cold" or not contamination,
        "contamination": sorted(set(contamination)),
    }
    return result


def write_audit(suite: Path, selected_arm: str | None = None) -> int:
    arms = (selected_arm,) if selected_arm else tuple(ARMS)
    results = [audit_arm(suite, arm) for arm in arms]
    output = ROOT / "experiments" / "robin-be" / "results"
    output.mkdir(parents=True, exist_ok=True)
    payload = {
        "schema_version": 1,
        "generated_at": dt.datetime.now(dt.timezone.utc).isoformat(),
        "suite": suite.name,
        "arms": results,
    }
    path = output / "audit-summary.json"
    path.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(payload, indent=2))
    return 0 if all(item["cold_isolation_passed"] for item in results) else 1


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=("prepare", "run", "audit"))
    parser.add_argument("--arm", choices=tuple(ARMS))
    parser.add_argument("--suite", type=Path, default=DEFAULT_SUITE)
    parser.add_argument("--force", action="store_true")
    parser.add_argument("--cycles", type=int, default=1)
    parser.add_argument("--minutes", type=int, default=90)
    args = parser.parse_args()
    suite = args.suite.resolve()
    if args.action == "prepare":
        arms = (args.arm,) if args.arm else tuple(ARMS)
        for arm in arms:
            prepare_arm(suite, arm, force=args.force)
        return 0
    if args.action == "run":
        if not args.arm:
            parser.error("run requires --arm")
        return run_arm(suite, args.arm, max(1, args.cycles), max(1, args.minutes))
    return write_audit(suite, args.arm)


if __name__ == "__main__":
    raise SystemExit(main())
