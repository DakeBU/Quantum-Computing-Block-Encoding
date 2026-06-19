#!/usr/bin/env python3
"""Run or record controlled route-ablation measurements.

There are two evidence levels:

* `reference_qiskit` and `reference_lean` measure checker baselines for known
  correct artifacts.  They do not measure AI writing time.
* `qiskit_only`, `lean_only`, and `abeis_multi_agent` measure route-total
  agent attempts when an `--agent-cmd` or ABEIS execution command is supplied.

The ABEIS route refuses to run without real parallel lower-agent execution.
"""

from __future__ import annotations

import argparse
import json
import os
import signal
import subprocess
import time
from dataclasses import asdict, dataclass
from datetime import datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ABLATION_DIR = ROOT / "reports" / "route-ablation" / "QBE-OP-OPTCTRL-001"
RUNS_DIR = ABLATION_DIR / "runs"

TARGET_SUMMARY = """Target: QBE-OP-OPTCTRL-001

Operator:
  E_1 = |0><1|_time tensor |0><1|_type tensor I_state

Concrete register convention:
  bit 0 = state, bit 1 = type, bit 2 = time, bit 3 = block ancilla.
  The clean block is the top-left auxiliary block.

Expected 8x8 clean block:
  target[0, 6] = 1
  target[1, 7] = 1
  all other entries are 0.

Known candidate transcript:
  CCX(type, time -> aux);
  X(type);
  X(time);
  X(aux)

Required resource tuple order:
  (gateCount, depth, auxiliaryQubits, oracleCalls)
"""


@dataclass
class RouteRun:
    run_id: str
    route: str
    evidence_level: str
    status: str
    prompt: str | None
    agent_command: str | None
    checker_command: str | None
    agent_wall_time_s: float | None
    checker_wall_time_s: float | None
    input_tokens_proxy: int | None
    output_tokens_proxy: int | None
    exact_provider_tokens_available: bool
    repair_iterations: int | None
    final_semantic_level: str
    reusable_as_lean_dependency: bool
    accepted: bool
    parallel_lower_required: bool
    parallel_lower_used: bool
    lower_count: int | None
    agent_profile: str | None
    parallel_claim_valid: bool | None
    detail: str


REFERENCE_QISKIT = """#!/usr/bin/env python3
import numpy as np
from qiskit import QuantumCircuit
from qiskit.quantum_info import Operator

def build_circuit():
    qc = QuantumCircuit(4)
    qc.ccx(1, 2, 3)
    qc.x(1)
    qc.x(2)
    qc.x(3)
    return qc

def main():
    data = np.asarray(Operator(build_circuit()).data)
    target = np.zeros((8, 8), dtype=complex)
    target[0, 6] = 1
    target[1, 7] = 1
    if not np.allclose(data[:8, :8], target, atol=1e-12):
        raise SystemExit("clean block does not equal E_1")
    print("reference qiskit clean-block check passed")

if __name__ == "__main__":
    main()
"""


def now_id(route: str) -> str:
    return datetime.now().strftime("%Y%m%d-%H%M%S") + f"-{route}"


def approx_tokens(text: str) -> int:
    return max(1, (len(text) + 3) // 4) if text else 0


def sanitize_for_report(text: str | None) -> str | None:
    if text is None:
        return None
    return text.replace(str(ROOT), "<repo-root>")


def run_capture(
    command: str,
    cwd: Path,
    out_dir: Path,
    prefix: str,
    env_extra: dict[str, str] | None = None,
    timeout_s: int | None = None,
) -> tuple[int, float, str]:
    env = os.environ.copy()
    if env_extra:
        env.update(env_extra)
    start = time.perf_counter()
    proc = subprocess.Popen(
        command,
        cwd=cwd,
        shell=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        env=env,
        start_new_session=True,
    )
    timed_out = False
    try:
        output, _ = proc.communicate(timeout=timeout_s)
    except subprocess.TimeoutExpired:
        timed_out = True
        try:
            os.killpg(proc.pid, signal.SIGTERM)
            output, _ = proc.communicate(timeout=5)
        except Exception:
            try:
                os.killpg(proc.pid, signal.SIGKILL)
            except Exception:
                pass
            output, _ = proc.communicate()
    elapsed = time.perf_counter() - start
    output = output or ""
    if timed_out:
        output = (output or "") + f"\n[TIMEOUT] command exceeded {timeout_s} seconds\n"
    (out_dir / f"{prefix}.log").write_text(output, encoding="utf-8")
    return (124 if timed_out else (proc.returncode or 0)), elapsed, output


def write_reference_qiskit() -> Path:
    path = ABLATION_DIR / "reference_qiskit_check.py"
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(REFERENCE_QISKIT, encoding="utf-8")
    path.chmod(0o755)
    return path


def prompt_path(route: str) -> Path:
    return ABLATION_DIR / f"{route}.prompt.md"


def record_run(record: RouteRun, run_dir: Path) -> None:
    run_dir.mkdir(parents=True, exist_ok=True)
    (run_dir / "metrics.json").write_text(json.dumps(asdict(record), indent=2), encoding="utf-8")
    records = []
    latest_json = ABLATION_DIR / "latest_results.json"
    if latest_json.exists():
        records = json.loads(latest_json.read_text(encoding="utf-8"))
    records.append(asdict(record))
    latest_json.write_text(json.dumps(records, indent=2), encoding="utf-8")
    write_latest_markdown(records)


def write_latest_markdown(records: list[dict]) -> None:
    lines = [
        "# Route-Ablation Results",
        "",
        "| Run | Route | Evidence | Status | Agent s | Checker s | Accepted | Parallel audit | Semantic level |",
        "| --- | --- | --- | --- | ---: | ---: | --- | --- | --- |",
    ]
    for row in records:
        agent = "" if row.get("agent_wall_time_s") is None else f"{row['agent_wall_time_s']:.3f}"
        checker = "" if row.get("checker_wall_time_s") is None else f"{row['checker_wall_time_s']:.3f}"
        if row.get("parallel_lower_required"):
            parallel = (
                f"used={row.get('parallel_lower_used')}, "
                f"lower_count={row.get('lower_count')}, "
                f"valid={row.get('parallel_claim_valid')}"
            )
        else:
            parallel = "n/a"
        lines.append(
            f"| `{row['run_id']}` | `{row['route']}` | {row['evidence_level']} | "
            f"{row['status']} | {agent} | {checker} | {row['accepted']} | "
            f"{parallel} | {row['final_semantic_level']} |"
        )
    lines += [
        "",
        "Evidence levels:",
        "",
        "- `checker-baseline`: finished-artifact verifier timing only; no AI writing",
        "  or repair time is measured.",
        "- `harness-selftest`: deterministic local script proving that the runner",
        "  enforces executable artifacts; not an AI route-total comparison.",
        "- `agent-route-total`: real model route with prompt dispatch, artifact",
        "  production, checker time, and token accounting where available.",
        "",
        "AI route-total runs must use the same prompt envelope and model budget,",
        "and exact provider tokens must be filled from the model wrapper when",
        "available.",
    ]
    (ABLATION_DIR / "latest_results.md").write_text("\n".join(lines) + "\n", encoding="utf-8")


def load_agent_profile(profile: str) -> dict[str, str]:
    path = Path(profile)
    if not path.exists():
        path = ROOT / "agent-profiles" / profile
    data = json.loads(path.read_text(encoding="utf-8"))
    commands = data.get("commands", {})
    if not isinstance(commands, dict):
        raise SystemExit(f"agent profile has no commands mapping: {path}")
    return {str(k): str(v) for k, v in commands.items()}


def command_for_role(commands: dict[str, str], role: str, prompt: Path) -> str:
    template = commands.get(role) or commands.get("lower" if role.startswith("lower") else role) or commands.get("default")
    if not template:
        raise SystemExit(f"agent profile has no command for role {role}")
    return template.format(root=str(ROOT), prompt=str(prompt))


def write_abeis_mini_prompts(run_dir: Path, lower_count: int) -> dict[str, Path]:
    prompts: dict[str, Path] = {}
    common = TARGET_SUMMARY + """
This is a route-ablation mini-harness, not a full sleep-run.  Keep the answer
short, write requested notes into QBE_ABLATION_RUN_DIR, and do not expand into
general project planning.
"""
    prompt_texts = {
        "upper": common
        + """
Role: upper target auditor.
Confirm the task mode, fixed target, accepted semantic tier, and lower-agent
division.  Write `upper_handoff.md` in QBE_ABLATION_RUN_DIR.  Do not edit Lean.
""",
        "middle": common
        + """
Role: middle correspondence maintainer.
Map the target to existing Lean declarations in QuantumBlockEncoding/OptimalControl.lean.
Write `middle_handoff.md` with Lean names, missing obligations, and the exact
lower packets.  Do not edit Lean unless only route notes are missing.
""",
        "reviewer": common
        + """
Role: reviewer.
Inspect the route notes and current git diff.  Reject hidden oracle assumptions,
wrong resource tuples, non-executable Qiskit artifacts, and fake parallelism.
Write `reviewer_handoff.md`.  Do not edit Lean.
""",
    }
    lower_prompts = [
        common
        + """
Role: lower1 natural-language proof architect.
Write `lower1_proof_plan.md`: step-by-step proof that the CCX/X/X/X transcript
is a one-ancilla exact block encoding of E_1, referring to existing Lean names
when possible.  Do not edit Lean.
""",
        common
        + """
Role: lower2 Lean implementation worker.
Ensure the direct route has named Lean declarations for the target block,
candidate unitary/circuit, clean-block theorem, and resource tuple.  Prefer
reusing existing OptimalControl declarations.  If edits are needed, keep them
scoped to QuantumBlockEncoding/OptimalControl.lean and Tests/Basic.lean.
Run `lake build Tests` if you edit Lean.  Write `lower2_lean_notes.md`.
""",
        common
        + """
Role: lower3 necessary-condition verifier.
Run or write a finite checker for the same clean block, preferably using the
existing verifier scripts.  Record finite_matrix_ok, block_entry_ok,
resource_score, and semantic limitations in `lower3_verifier_notes.md`.
Do not edit Lean.
""",
    ]
    for i in range(max(0, lower_count)):
        prompt_texts[f"lower{i + 1}"] = lower_prompts[min(i, len(lower_prompts) - 1)]
    for role, text in prompt_texts.items():
        path = run_dir / f"abeis_{role}.prompt.md"
        path.write_text(text, encoding="utf-8")
        prompts[role] = path
    return prompts


def run_parallel_commands(
    jobs: list[tuple[str, str]],
    cwd: Path,
    out_dir: Path,
    env_extra: dict[str, str],
    timeout_s: int | None,
) -> tuple[int, float, str]:
    start = time.perf_counter()
    processes: list[tuple[str, subprocess.Popen[str]]] = []
    env = os.environ.copy()
    env.update(env_extra)
    for role, command in jobs:
        proc = subprocess.Popen(
            command,
            cwd=cwd,
            shell=True,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            env=env,
            start_new_session=True,
        )
        processes.append((role, proc))
    outputs: list[str] = []
    deadline = None if timeout_s is None else start + timeout_s
    status = 0
    for role, proc in processes:
        remaining = None if deadline is None else max(0.0, deadline - time.perf_counter())
        timed_out = False
        try:
            output, _ = proc.communicate(timeout=remaining)
        except subprocess.TimeoutExpired:
            timed_out = True
            try:
                os.killpg(proc.pid, signal.SIGTERM)
                output, _ = proc.communicate(timeout=5)
            except Exception:
                try:
                    os.killpg(proc.pid, signal.SIGKILL)
                except Exception:
                    pass
                output, _ = proc.communicate()
        output = output or ""
        if timed_out:
            output += f"\n[TIMEOUT] parallel role {role} exceeded {timeout_s} seconds\n"
        (out_dir / f"{role}.log").write_text(output, encoding="utf-8")
        outputs.append(f"===== {role} =====\n{output}")
        if timed_out or (proc.returncode or 0) != 0:
            status = 124 if timed_out else (proc.returncode or 1)
    return status, time.perf_counter() - start, "\n".join(outputs)


def run_reference_qiskit(args: argparse.Namespace) -> RouteRun:
    script = write_reference_qiskit()
    command = f"{args.python} {script.relative_to(ROOT)}"
    run_id = now_id("reference_qiskit")
    run_dir = RUNS_DIR / run_id
    run_dir.mkdir(parents=True, exist_ok=True)
    code, elapsed, output = run_capture(command, ROOT, run_dir, "checker")
    return RouteRun(
        run_id=run_id,
        route="reference_qiskit",
        evidence_level="checker-baseline",
        status="passed" if code == 0 else "failed",
        prompt=None,
        agent_command=None,
        checker_command=command,
        agent_wall_time_s=None,
        checker_wall_time_s=elapsed,
        input_tokens_proxy=None,
        output_tokens_proxy=None,
        exact_provider_tokens_available=False,
        repair_iterations=0,
        final_semantic_level="finite Qiskit Operator equality",
        reusable_as_lean_dependency=False,
        accepted=code == 0,
        parallel_lower_required=False,
        parallel_lower_used=False,
        lower_count=None,
        agent_profile=None,
        parallel_claim_valid=None,
        detail=output.strip(),
    )


def run_reference_lean(args: argparse.Namespace) -> RouteRun:
    command = "lake build Tests"
    run_id = now_id("reference_lean")
    run_dir = RUNS_DIR / run_id
    run_dir.mkdir(parents=True, exist_ok=True)
    code, elapsed, output = run_capture(command, ROOT, run_dir, "checker")
    return RouteRun(
        run_id=run_id,
        route="reference_lean",
        evidence_level="checker-baseline",
        status="passed" if code == 0 else "failed",
        prompt=None,
        agent_command=None,
        checker_command=command,
        agent_wall_time_s=None,
        checker_wall_time_s=elapsed,
        input_tokens_proxy=None,
        output_tokens_proxy=None,
        exact_provider_tokens_available=False,
        repair_iterations=0,
        final_semantic_level="Lean existing Tests gate",
        reusable_as_lean_dependency=True,
        accepted=code == 0,
        parallel_lower_required=False,
        parallel_lower_used=False,
        lower_count=None,
        agent_profile=None,
        parallel_claim_valid=None,
        detail="\n".join(output.splitlines()[-8:]),
    )


def run_abeis_mini_route(
    args: argparse.Namespace,
    run_id: str,
    run_dir: Path,
    env_extra: dict[str, str],
) -> RouteRun:
    if not args.execute_abeis:
        raise SystemExit("abeis_multi_agent requires --execute-abeis; this prevents fake parallel-agent evidence")
    route = "abeis_multi_agent"
    route_prompt = prompt_path(route)
    prompt_text = route_prompt.read_text(encoding="utf-8") if route_prompt.exists() else ""
    (run_dir / "prompt.md").write_text(prompt_text, encoding="utf-8")
    prompts = write_abeis_mini_prompts(run_dir, args.lower_count)
    commands = load_agent_profile(args.agent_profile)
    agent_start = time.perf_counter()
    all_output: list[str] = []
    status = 0

    for role in ("upper", "middle"):
        command = command_for_role(commands, role, prompts[role])
        code, elapsed, output = run_capture(
            command,
            ROOT,
            run_dir,
            role,
            env_extra=env_extra,
            timeout_s=args.agent_timeout_s,
        )
        all_output.append(f"===== {role} ({elapsed:.3f}s) =====\n{output}")
        if code != 0:
            status = code
            break

    if status == 0:
        lower_jobs = [
            (f"lower{i}", command_for_role(commands, f"lower{i}", prompts[f"lower{i}"]))
            for i in range(1, args.lower_count + 1)
        ]
        code, elapsed, output = run_parallel_commands(
            lower_jobs,
            ROOT,
            run_dir,
            env_extra=env_extra,
            timeout_s=args.agent_timeout_s,
        )
        all_output.append(f"===== parallel lower ({elapsed:.3f}s) =====\n{output}")
        if code != 0:
            status = code

    if status == 0:
        command = command_for_role(commands, "reviewer", prompts["reviewer"])
        code, elapsed, output = run_capture(
            command,
            ROOT,
            run_dir,
            "reviewer",
            env_extra=env_extra,
            timeout_s=args.agent_timeout_s,
        )
        all_output.append(f"===== reviewer ({elapsed:.3f}s) =====\n{output}")
        if code != 0:
            status = code

    agent_elapsed = time.perf_counter() - agent_start
    checker_command = (args.checker_cmd or "lake build Tests").format(
        root=str(ROOT),
        prompt=str(route_prompt),
        route=route,
        run_dir=str(run_dir),
    )
    checker_code, checker_elapsed, checker_output = run_capture(
        checker_command,
        ROOT,
        run_dir,
        "checker",
        env_extra=env_extra,
        timeout_s=args.checker_timeout_s,
    )
    accepted = status == 0 and checker_code == 0
    combined_output = "\n".join(all_output) + "\n" + checker_output
    mini_prompt_text = prompt_text + "\n" + "\n".join(path.read_text(encoding="utf-8") for path in prompts.values())
    return RouteRun(
        run_id=run_id,
        route=route,
        evidence_level=args.evidence_level,
        status="passed" if accepted else "failed",
        prompt=str(route_prompt.relative_to(ROOT)),
        agent_command=sanitize_for_report(
            f"abeis-mini-harness profile={args.agent_profile} lower_count={args.lower_count}"
        ),
        checker_command=sanitize_for_report(checker_command),
        agent_wall_time_s=agent_elapsed,
        checker_wall_time_s=checker_elapsed,
        input_tokens_proxy=approx_tokens(mini_prompt_text),
        output_tokens_proxy=approx_tokens(combined_output),
        exact_provider_tokens_available=False,
        repair_iterations=None,
        final_semantic_level="Lean-certified ABEIS candidate population route",
        reusable_as_lean_dependency=True,
        accepted=accepted,
        parallel_lower_required=True,
        parallel_lower_used=True,
        lower_count=args.lower_count,
        agent_profile=args.agent_profile,
        parallel_claim_valid=args.lower_count >= 2,
        detail="Mini-harness logs are stored next to metrics.json.",
    )


def run_agent_route(args: argparse.Namespace) -> RouteRun:
    route = args.route
    run_id = now_id(route)
    run_dir = RUNS_DIR / run_id
    run_dir.mkdir(parents=True, exist_ok=True)
    route_artifact = run_dir / ("qiskit_artifact.py" if route == "qiskit_only" else "route_notes.md")
    env_extra = {
        "QBE_ROOT": str(ROOT),
        "QBE_ROUTE": route,
        "QBE_ABLATION_RUN_DIR": str(run_dir),
        "QBE_ROUTE_ARTIFACT": str(route_artifact),
    }
    if route == "abeis_multi_agent":
        return run_abeis_mini_route(args, run_id, run_dir, env_extra)
    else:
        if not args.agent_cmd:
            raise SystemExit(f"{route} requires --agent-cmd")
        prompt = prompt_path(route)
        if not prompt.exists():
            raise SystemExit(f"prompt not found: {prompt.relative_to(ROOT)}; run prepare_route_ablation.py first")
        env_extra["QBE_PROMPT"] = str(prompt)
        command = args.agent_cmd.format(root=str(ROOT), prompt=str(prompt), route=route, run_dir=str(run_dir))
        parallel_lower_required = False
        parallel_lower_used = False
        lower_count = None
        agent_profile = None
        parallel_claim_valid = None
    prompt_text = prompt.read_text(encoding="utf-8") if prompt.exists() else ""
    (run_dir / "prompt.md").write_text(prompt_text, encoding="utf-8")
    code, agent_elapsed, output = run_capture(
        command,
        ROOT,
        run_dir,
        "agent",
        env_extra=env_extra,
        timeout_s=args.agent_timeout_s,
    )
    checker_command = args.checker_cmd
    if not checker_command:
        checker_command = f"{args.python} \"$QBE_ROUTE_ARTIFACT\"" if route == "qiskit_only" else "lake build Tests"
    checker_command = checker_command.format(root=str(ROOT), prompt=str(prompt), route=route, run_dir=str(run_dir))
    checker_elapsed = None
    checker_code = 0
    checker_output = ""
    if checker_command:
        checker_code, checker_elapsed, checker_output = run_capture(
            checker_command,
            ROOT,
            run_dir,
            "checker",
            env_extra=env_extra,
            timeout_s=args.checker_timeout_s,
        )
    accepted = code == 0 and checker_code == 0
    semantic = {
        "qiskit_only": "finite executable artifact, checker supplied by route",
        "lean_only": "direct Lean theorem route",
        "abeis_multi_agent": "Lean-certified ABEIS candidate population route",
    }[route]
    return RouteRun(
        run_id=run_id,
        route=route,
        evidence_level=args.evidence_level,
        status="passed" if accepted else "failed",
        prompt=str(prompt.relative_to(ROOT)),
        agent_command=sanitize_for_report(command),
        checker_command=sanitize_for_report(checker_command or None),
        agent_wall_time_s=agent_elapsed,
        checker_wall_time_s=checker_elapsed,
        input_tokens_proxy=approx_tokens(prompt_text),
        output_tokens_proxy=approx_tokens(output + checker_output),
        exact_provider_tokens_available=False,
        repair_iterations=None,
        final_semantic_level=semantic,
        reusable_as_lean_dependency=route != "qiskit_only",
        accepted=accepted,
        parallel_lower_required=parallel_lower_required,
        parallel_lower_used=parallel_lower_used,
        lower_count=lower_count,
        agent_profile=agent_profile,
        parallel_claim_valid=parallel_claim_valid,
        detail="Agent/checker logs are stored next to metrics.json.",
    )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "route",
        choices=("reference_qiskit", "reference_lean", "qiskit_only", "lean_only", "abeis_multi_agent"),
    )
    parser.add_argument("--python", default="python3")
    parser.add_argument("--agent-cmd", default="")
    parser.add_argument("--checker-cmd", default="")
    parser.add_argument("--execute-abeis", action="store_true")
    parser.add_argument("--cycles", type=int, default=1)
    parser.add_argument("--lower-count", type=int, default=3)
    parser.add_argument("--agent-profile", default="codex-parallel.example.json")
    parser.add_argument("--context-mode", choices=("full", "focused"), default="focused")
    parser.add_argument("--agent-timeout-s", type=int, default=None)
    parser.add_argument("--checker-timeout-s", type=int, default=240)
    parser.add_argument(
        "--evidence-level",
        default="agent-route-total",
        help="label for non-reference runs; use harness-selftest for deterministic local scripts",
    )
    args = parser.parse_args()

    ABLATION_DIR.mkdir(parents=True, exist_ok=True)
    if args.route == "reference_qiskit":
        record = run_reference_qiskit(args)
    elif args.route == "reference_lean":
        record = run_reference_lean(args)
    else:
        record = run_agent_route(args)
    record_run(record, RUNS_DIR / record.run_id)
    print(f"{record.route}: {record.status} -> {ABLATION_DIR / 'latest_results.md'}")
    return 0 if record.status == "passed" else 1


if __name__ == "__main__":
    raise SystemExit(main())
