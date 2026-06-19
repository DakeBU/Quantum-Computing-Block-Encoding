#!/usr/bin/env python3
"""Prepare controlled route-ablation prompts for the ABEIS main case.

This tool does not run an LLM by default.  It creates the same target envelope
for three routes:

* qiskit-only executable route,
* direct Lean route,
* full ABEIS multi-agent route.

The generated metrics schema is intentionally explicit about wall time,
checker time, exact provider tokens, repair iterations, and final semantic
level.  A later executor can fill those fields after running each route with
the same model and budget.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = ROOT / "reports" / "route-ablation" / "QBE-OP-OPTCTRL-001"


@dataclass
class RouteMetricTemplate:
    route: str
    prompt: str
    output_contract: str
    execute_command: str
    measured: bool
    agent_wall_time_s: float | None
    checker_wall_time_s: float | None
    input_tokens: int | None
    output_tokens: int | None
    total_tokens: int | None
    repair_iterations: int | None
    final_semantic_level: str | None
    reusable_as_lean_dependency: bool | None
    accepted: bool | None
    parallel_lower_required: bool
    parallel_lower_used: bool | None
    lower_count: int | None
    agent_profile: str | None
    parallel_claim_valid: bool | None
    notes: str


TARGET_ENVELOPE = """# Controlled route ablation target: QBE-OP-OPTCTRL-001

Target operator:

```text
E_1 = |0><1|_time tensor |0><1|_type tensor I_state
```

Concrete register convention:

- state bit: bit 0;
- type bit: bit 1;
- time bit: bit 2;
- block-encoding auxiliary bit: bit 3;
- clean block is the top-left block where the auxiliary input and output are 0.

Expected target block:

```text
target[0, 6] = 1
target[1, 7] = 1
all other 8 x 8 entries are 0
```

Candidate circuit used by the current ABEIS champion:

```text
CCX(type, time -> aux);
X(type);
X(time);
X(aux)
```

Resource tuple order:

```text
(gateCount, depth, auxiliaryQubits, oracleCalls)
```

The first comparison is semantic acceptance.  The second comparison is route
cost: agent wall time, checker time, exact provider tokens, repair iterations,
and final semantic level.
"""


PROMPTS = {
    "qiskit_only": TARGET_ENVELOPE
    + """
## Route

Write a self-contained Python/Qiskit artifact that defines:

```python
def build_circuit():
    ...
```

Then verify with `qiskit.quantum_info.Operator` that the clean auxiliary block
equals the target block above, using tolerance `1e-12`.

If this prompt is run by `tools/run_route_ablation.py`, write the complete
executable Python artifact to the path in the environment variable
`QBE_ROUTE_ARTIFACT`.  The default checker will run that file.

Do not mention Lean.  Do not assume a hidden oracle.  Report the circuit, the
checker code, the resource tuple, and any limitations.
""",
    "lean_only": TARGET_ENVELOPE
    + """
## Route

Write or repair Lean declarations for the same target directly, without using
ABEIS candidate-population or multi-agent memory.  The final artifact must be a
named Lean theorem proving the clean-block equality and a named declaration for
the resource tuple.

Do not use `sorry`, `axiom`, hidden constants, or an oracle assumption.  Report
which Lean declarations compile and which checker command was used.

If this prompt is run by `tools/run_route_ablation.py`, the environment
variable `QBE_ABLATION_RUN_DIR` names the run directory.  Write any route notes
there, but committed Lean changes must still be checked by `lake build Tests`.
""",
    "abeis_multi_agent": TARGET_ENVELOPE
    + """
## Route

Use the full ABEIS harness: upper target audit, middle correspondence/memory,
parallel lower roles, reviewer, typed verifier feedback, candidate population,
and Lean gate.  If lower agents run in parallel, they must be actually invoked
with `--parallel-lower` or an equivalent scheduler; do not describe a single
chat interaction as parallel lower-agent evidence.

The route succeeds only if the candidate enters the certified population with
named Lean declarations and a resource tuple.
""",
}


def approx_tokens(text: str) -> int:
    return max(1, (len(text) + 3) // 4)


def write_prompts() -> list[RouteMetricTemplate]:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    templates: list[RouteMetricTemplate] = []
    for route, text in PROMPTS.items():
        prompt_path = OUT_DIR / f"{route}.prompt.md"
        prompt_path.write_text(text, encoding="utf-8")
        if route == "abeis_multi_agent":
            command = (
                "python3 tools/qbe.py sleep-run QBE-OP-OPTCTRL-001 "
                "--cycles 1 --lower-count 3 --parallel-lower "
                "--agent-profile codex-parallel.example.json --context-mode focused "
                "--execute --check-each-cycle"
            )
            semantic = "Lean-certified ABEIS candidate population entry"
            reusable = True
        elif route == "lean_only":
            command = "<agent command on lean_only.prompt.md> && lake build && lake build Tests"
            semantic = "direct Lean theorem"
            reusable = True
        else:
            command = "<agent command on qiskit_only.prompt.md> && python3 $QBE_ROUTE_ARTIFACT"
            semantic = "finite Qiskit Operator equality"
            reusable = False
        templates.append(
            RouteMetricTemplate(
                route=route,
                prompt=str(prompt_path.relative_to(ROOT)),
                output_contract="same target envelope; route-specific artifact described in prompt",
                execute_command=command,
                measured=False,
                agent_wall_time_s=None,
                checker_wall_time_s=None,
                input_tokens=approx_tokens(text),
                output_tokens=None,
                total_tokens=None,
                repair_iterations=None,
                final_semantic_level=semantic,
                reusable_as_lean_dependency=reusable,
                accepted=None,
                parallel_lower_required=route == "abeis_multi_agent",
                parallel_lower_used=None,
                lower_count=3 if route == "abeis_multi_agent" else None,
                agent_profile="codex-parallel.example.json" if route == "abeis_multi_agent" else None,
                parallel_claim_valid=None,
                notes="Template only. Fill exact provider tokens after running the route.",
            )
        )
    (OUT_DIR / "metrics_template.json").write_text(
        json.dumps([asdict(row) for row in templates], indent=2),
        encoding="utf-8",
    )
    return templates


def write_readme(templates: list[RouteMetricTemplate]) -> None:
    lines = [
        "# Route Ablation: QBE-OP-OPTCTRL-001",
        "",
        "This directory contains controlled prompts for comparing three artifact",
        "routes on the same block-encoding target:",
        "",
        "- Qiskit-only finite executable check;",
        "- direct Lean theorem route;",
        "- full ABEIS hierarchical multi-agent route.",
        "",
        "All routes use the same target envelope.  A fair run must use the same",
        "model family, budget, and temperature policy where possible.",
        "",
        "| Route | Prompt | Initial input-token proxy | Final semantic level |",
        "| --- | --- | ---: | --- |",
    ]
    for item in templates:
        lines.append(
            f"| `{item.route}` | `{item.prompt}` | {item.input_tokens} | "
            f"{item.final_semantic_level} |"
        )
    lines += [
        "",
        "Required measurements:",
        "",
        "- agent wall time from prompt dispatch to accepted artifact;",
        "- checker/compile time;",
        "- exact provider input/output/total tokens;",
        "- repair iterations;",
        "- final semantic level;",
        "- whether the artifact is reusable as a Lean dependency.",
        "- for ABEIS route: whether real `--parallel-lower` execution was used,",
        "  lower-count, agent profile, and whether the parallelism claim is valid.",
        "",
        "Checker-only reference baselines:",
        "",
        "```bash",
        "python3 -m pip install qiskit",
        "python3 tools/run_route_ablation.py reference_qiskit",
        "python3 tools/run_route_ablation.py reference_lean",
        "```",
        "",
        "Actual route-total runs:",
        "",
        "```bash",
        "python3 tools/run_route_ablation.py qiskit_only --agent-cmd '<same model wrapper on {prompt}>'",
        "python3 tools/run_route_ablation.py lean_only --agent-cmd '<same model wrapper on {prompt}>'",
        "python3 tools/run_route_ablation.py abeis_multi_agent \\",
        "  --execute-abeis \\",
        "  --lower-count 3 \\",
        "  --agent-profile codex-parallel.example.json \\",
        "  --agent-timeout-s 900",
        "```",
        "",
        "For `qiskit_only`, the runner sets `QBE_ROUTE_ARTIFACT` and the default",
        "checker runs that file.  The agent command must therefore create a complete",
        "Python/Qiskit script at that path, not just print code in chat.",
        "",
        "The ABEIS route refuses to run without `--execute-abeis`.  It uses a",
        "route-ablation mini-harness: compact upper/middle handoffs, parallel",
        "lower roles, reviewer, and `lake build Tests`.  This prevents a single",
        "chat session from being recorded as parallel lower-agent evidence.",
        "",
        "The first completed Codex route-total run passed all three routes, with",
        "`abeis_multi_agent` using `lower_count = 3` real parallel lower agents.",
        "It also exposed high coordination/log overhead in the current Codex",
        "profile, so future runs should use low-token coordination roles.",
        "",
        "Do not compare Qiskit checker time against Lean agent-writing time.  The",
        "whole point is to compare route-total time and tokens separately from",
        "checker time.",
    ]
    (OUT_DIR / "README.md").write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--print-paths", action="store_true")
    args = parser.parse_args()
    templates = write_prompts()
    write_readme(templates)
    if args.print_paths:
        for path in sorted(OUT_DIR.glob("*")):
            print(path.relative_to(ROOT))
    else:
        print(f"wrote {OUT_DIR.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
