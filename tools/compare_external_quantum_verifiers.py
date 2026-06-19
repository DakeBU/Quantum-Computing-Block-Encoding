#!/usr/bin/env python3
"""Survey external quantum-agent verifier repositories on the ABEIS main case.

The goal is not to force every external system to prove a block-encoding
theorem.  The goal is to make a fair, reproducible distinction:

* which repositories can directly run a same-task executable check;
* what semantic level that check has;
* what runtime was observed;
* what prevents a direct comparison when a repository targets a different
  workflow.

Run with optional dependencies, for example:

    python3 -m pip install qiskit 'openqasm3[parser]'
    python3 tools/compare_external_quantum_verifiers.py
"""

from __future__ import annotations

import csv
import importlib.util
import json
import py_compile
import statistics
import sys
import time
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Callable

ROOT = Path(__file__).resolve().parents[1]
REPOS_ROOT = ROOT.parent
OUTER = REPOS_ROOT / "outer_repos" / "quantum" / "llm_circuit_verifier_feedback"
REPORT_DIR = ROOT / "reports" / "external-quantum-verifier-comparison"


@dataclass
class ExternalRouteResult:
    system: str
    local_reference: str
    route_kind: str
    same_be_task: bool
    semantic_level: str
    status: str
    median_ms: float | None
    measured_repeats: int
    requires_api_key: bool
    requires_extra_dependencies: bool
    final_be_certificate: bool
    harness_comparison_role: str
    detail: str


def rel_external(path: Path) -> str:
    try:
        return str(path.relative_to(REPOS_ROOT))
    except ValueError:
        return str(path)


def time_repeated(fn: Callable[[], None], repeats: int) -> tuple[str, float | None, str]:
    timings: list[float] = []
    try:
        fn()
        for _ in range(repeats):
            start = time.perf_counter()
            fn()
            timings.append((time.perf_counter() - start) * 1000.0)
    except Exception as exc:
        return "failed", None, f"{type(exc).__name__}: {exc}"
    return "passed", statistics.median(timings), "passed"


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


QISKIT_KATA_CODE = """
from qiskit import QuantumCircuit

def build_circuit():
    qc = QuantumCircuit(4)
    qc.ccx(1, 2, 3)
    qc.x(1)
    qc.x(2)
    qc.x(3)
    return qc
"""

QISKIT_KATA_TEST = """
def test_build_circuit():
    import numpy as np
    from qiskit.quantum_info import Operator
    qc = build_circuit()
    data = np.asarray(Operator(qc).data)
    target = np.zeros((8, 8), dtype=complex)
    target[0, 6] = 1
    target[1, 7] = 1
    assert np.allclose(data[:8, :8], target, atol=1e-12)
"""


def qiskit_quantumkatas_route() -> ExternalRouteResult:
    repo = OUTER / "Qiskit-QuantumKatas"
    evaluator_path = repo / "benchmark" / "evaluator.py"

    def run_once() -> None:
        evaluator = load_module(evaluator_path, "qk_eval_for_abeis")
        result = evaluator.evaluate_solution(
            QISKIT_KATA_CODE,
            QISKIT_KATA_TEST,
            "build_circuit",
            timeout=10.0,
        )
        if not result.passed:
            raise RuntimeError(f"{result.error_type}: {result.error_message}")

    status, median_ms, detail = time_repeated(run_once, repeats=20)
    return ExternalRouteResult(
        system="Qiskit-QuantumKatas",
        local_reference=rel_external(repo),
        route_kind="custom kata evaluator",
        same_be_task=True,
        semantic_level="finite Qiskit Operator block equality inside Python test",
        status=status,
        median_ms=median_ms,
        measured_repeats=20 if median_ms is not None else 0,
        requires_api_key=False,
        requires_extra_dependencies=True,
        final_be_certificate=False,
        harness_comparison_role=(
            "Runnable executable-code route for the same finite E_1 task; useful for "
            "artifact-route ablation, not a reusable Lean theorem."
        ),
        detail=detail,
    )


QASM_GOLDEN = """OPENQASM 3;
include "stdgates.inc";
qubit[4] q;
bit[4] c;
// === CORE_TASK_START ===
ccx q[1], q[2], q[3];
x q[1];
x q[2];
x q[3];
// === CORE_TASK_END ===
c = measure q;
"""

QASM_COMPLETION = """ccx q[1], q[2], q[3];
x q[1];
x q[2];
x q[3];"""


def qasm_eval_route() -> ExternalRouteResult:
    repo = OUTER / "QASM-Eval"
    evaluator_path = repo / "scripts" / "evaluator.py"

    def run_once() -> None:
        scripts_dir = str(repo / "scripts")
        if scripts_dir not in sys.path:
            sys.path.insert(0, scripts_dir)
        evaluator = load_module(evaluator_path, "qasm_eval_for_abeis")
        result = evaluator.evaluate_qasm_completion(
            QASM_GOLDEN,
            QASM_COMPLETION,
            domain="classical",
            require_distribution=True,
            require_timeline=False,
        )
        if not result.ok:
            raise RuntimeError(result.detail or "QASM-Eval returned ok=False")

    status, median_ms, detail = time_repeated(run_once, repeats=5)
    if "openqasm3" in detail or "parse" in detail:
        status = "blocked-env"
    return ExternalRouteResult(
        system="QASM-Eval",
        local_reference=rel_external(repo),
        route_kind="OpenQASM completion evaluator",
        same_be_task=False,
        semantic_level=(
            "syntax/element/distribution/timeline evaluator; the smoke target is the same "
            "gate transcript but not block-entry equality over all basis states"
        ),
        status=status,
        median_ms=median_ms,
        measured_repeats=5 if median_ms is not None else 0,
        requires_api_key=False,
        requires_extra_dependencies=True,
        final_be_certificate=False,
        harness_comparison_role=(
            "Typed executable feedback and pass@k protocol; not directly a BE theorem verifier."
        ),
        detail=detail,
    )


def quasar_route() -> ExternalRouteResult:
    repo = OUTER / "QUASAR"
    readme = (repo / "README.md").read_text(encoding="utf-8") if (repo / "README.md").exists() else ""
    status = "not-runnable" if "to be released" in readme.lower() else "unknown"
    detail = "Repository README says code is to be released after acceptance." if status == "not-runnable" else "No runnable route identified."
    return ExternalRouteResult(
        system="QUASAR",
        local_reference=rel_external(repo),
        route_kind="tool-server / hierarchical reward system",
        same_be_task=False,
        semantic_level="not available locally",
        status=status,
        median_ms=None,
        measured_repeats=0,
        requires_api_key=True,
        requires_extra_dependencies=True,
        final_be_certificate=False,
        harness_comparison_role=(
            "Harness/reward-design comparison only until runnable code is available."
        ),
        detail=detail,
    )


def ai_mandel_route() -> ExternalRouteResult:
    repo = OUTER / "ai-mandel"
    scripts = [repo / "researchers.py", repo / "prep_expert.py", repo / "expert.py"]

    def run_once() -> None:
        for script in scripts:
            py_compile.compile(str(script), doraise=True)

    status, median_ms, detail = time_repeated(run_once, repeats=5)
    return ExternalRouteResult(
        system="AI-Mandel",
        local_reference=rel_external(repo),
        route_kind="idea-to-tool-executable quantum-physics loop",
        same_be_task=False,
        semantic_level="script compile smoke only; PyTheus execution is not a BE verifier",
        status=status,
        median_ms=median_ms,
        measured_repeats=5 if median_ms is not None else 0,
        requires_api_key=True,
        requires_extra_dependencies=True,
        final_be_certificate=False,
        harness_comparison_role=(
            "Research-loop and expert-tool staging comparison; not a direct circuit verifier for E_1."
        ),
        detail=detail,
    )


def write_json(rows: list[ExternalRouteResult], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps([asdict(row) for row in rows], indent=2), encoding="utf-8")


def write_csv(rows: list[ExternalRouteResult], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(asdict(rows[0]).keys()))
        writer.writeheader()
        for row in rows:
            writer.writerow(asdict(row))


def write_markdown(rows: list[ExternalRouteResult], path: Path) -> None:
    lines = [
        "# External Quantum Verifier/Harness Comparison",
        "",
        "This report compares locally downloaded external quantum-code systems against",
        "the ABEIS main transfer-operator task.  It separates two questions:",
        "",
        "1. Can the external repository directly check the same finite block-encoding",
        "   artifact?",
        "2. If not, what harness or feedback idea is still comparable?",
        "",
        "| System | Same finite BE task? | Status | Median ms | Semantic level | Role in fair comparison |",
        "| --- | --- | --- | ---: | --- | --- |",
    ]
    for row in rows:
        median = "" if row.median_ms is None else f"{row.median_ms:.3f}"
        lines.append(
            f"| {row.system} | {row.same_be_task} | {row.status} | {median} | "
            f"{row.semantic_level} | {row.harness_comparison_role} |"
        )
    lines += [
        "",
        "Interpretation:",
        "",
        "- Qiskit-QuantumKatas is the closest direct executable-code route.  We can",
        "  formulate the ABEIS `E_1` target as a kata-style Python/Qiskit task and",
        "  check it with a deterministic `Operator` assertion.",
        "- QASM-Eval is valuable for typed syntax, element, distribution, and timeline",
        "  feedback.  Its released evaluator is not a block-entry verifier over all",
        "  basis states.  If the matching `openqasm3` parser stack is available,",
        "  the local smoke route checks the same gate transcript through",
        "  QASM-Eval's distribution-style policy; otherwise it is recorded as",
        "  `blocked-env` rather than counted as a pass.",
        "- QUASAR's local repository does not yet expose runnable code, so it can only",
        "  be compared at the harness-design level for now.",
        "- AI-Mandel is a multi-agent idea-to-tool loop for quantum-physics discovery.",
        "  It is relevant to staging and external-tool execution, not as a direct BE",
        "  verifier for this task.",
        "",
        "A first route-total experiment has now run the same target through",
        "Qiskit-only, direct-Lean, and ABEIS multi-agent harnesses.  See",
        "`reports/route-ablation/QBE-OP-OPTCTRL-001/latest_results.md`.  Exact",
        "provider token counts remain wrapper-dependent; the current report",
        "records wall time, checker time, token proxies, semantic level, and",
        "whether ABEIS used real parallel lower agents.",
    ]
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    rows = [
        qiskit_quantumkatas_route(),
        qasm_eval_route(),
        quasar_route(),
        ai_mandel_route(),
    ]
    write_json(rows, REPORT_DIR / "latest.json")
    write_csv(rows, REPORT_DIR / "latest.csv")
    write_markdown(rows, REPORT_DIR / "latest.md")
    for row in rows:
        median = "n/a" if row.median_ms is None else f"{row.median_ms:.3f} ms"
        print(f"{row.system}: {row.status}, median={median}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
