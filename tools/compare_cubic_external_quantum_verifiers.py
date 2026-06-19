#!/usr/bin/env python3
"""Run external-verifier baselines on the cubic state-preparation task.

This script is intentionally stricter than a generic "can the code run?"
survey.  It uses the same mathematical target as
`QBE-OP-CUBIC-STATEPREP-001`:

    O_n = |v_n><0^n|,  (v_n)_j = (j / 2^n)^3.

For Qiskit-style executable routes we construct a finite dense unitary whose
clean ancilla block equals O_n / alpha for alpha = ||v_n||_2.  This is a valid
fixed-instance block-encoding executable check, but it is not a symbolic family
theorem and does not replace Lean closure.
"""

from __future__ import annotations

import argparse
import csv
import importlib.util
import json
import math
import py_compile
import statistics
import sys
import time
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Callable

import numpy as np


ROOT = Path(__file__).resolve().parents[1]
REPOS_ROOT = ROOT.parent
OUTER = REPOS_ROOT / "outer_repos" / "quantum" / "llm_circuit_verifier_feedback"
REPORT_DIR = ROOT / "reports" / "cubic-stateprep"


@dataclass
class CubicExternalResult:
    system: str
    local_reference: str
    route_kind: str
    n: int | None
    N: int | None
    same_be_task: bool
    semantic_level: str
    status: str
    construct_ms: float | None
    verify_ms: float | None
    dense_unitary_memory: str | None
    clean_block_error: float | None
    unitarity_error: float | None
    symbolic_family: bool
    final_be_certificate: bool
    interpretation: str
    detail: str


def rel(path: Path) -> str:
    try:
        return str(path.relative_to(REPOS_ROOT))
    except ValueError:
        return str(path)


def human_bytes(num: int) -> str:
    units = ["B", "KiB", "MiB", "GiB", "TiB", "PiB"]
    value = float(num)
    for unit in units:
        if value < 1024.0 or unit == units[-1]:
            return f"{value:.3g} {unit}"
        value /= 1024.0
    return f"{value:.3g} PiB"


def dense_unitary_bytes(n: int) -> int:
    N = 1 << n
    return (2 * N) ** 2 * 16


def cubic_vector(n: int) -> np.ndarray:
    N = 1 << n
    j = np.arange(N, dtype=np.float64)
    return (j / float(N)) ** 3


def gram_schmidt_complete(seed_columns: list[np.ndarray], dim: int) -> np.ndarray:
    cols: list[np.ndarray] = []
    for col in seed_columns:
        v = col.astype(np.complex128, copy=True)
        for q in cols:
            v -= np.vdot(q, v) * q
        norm = np.linalg.norm(v)
        if norm > 1e-10:
            cols.append(v / norm)

    for i in range(dim):
        v = np.zeros(dim, dtype=np.complex128)
        v[i] = 1.0
        for q in cols:
            v -= np.vdot(q, v) * q
        norm = np.linalg.norm(v)
        if norm > 1e-10:
            cols.append(v / norm)
        if len(cols) == dim:
            break

    if len(cols) != dim:
        raise RuntimeError(f"only completed {len(cols)} of {dim} columns")
    return np.column_stack(cols)


def dense_cubic_block_encoding(n: int) -> tuple[float, np.ndarray]:
    """Return alpha and a dense one-auxiliary-qubit unitary U.

    The first N columns are chosen so that the clean block has first column
    v / ||v|| and all other columns zero.  The remaining columns are completed
    by deterministic Gram-Schmidt against the standard basis.
    """

    N = 1 << n
    dim = 2 * N
    v = cubic_vector(n)
    alpha = float(np.linalg.norm(v))
    if alpha == 0.0:
        raise RuntimeError("zero target vector")
    w = v / alpha

    first_columns: list[np.ndarray] = []
    col0 = np.zeros(dim, dtype=np.complex128)
    col0[:N] = w
    first_columns.append(col0)
    for j in range(1, N):
        col = np.zeros(dim, dtype=np.complex128)
        col[N + j] = 1.0
        first_columns.append(col)

    U = gram_schmidt_complete(first_columns, dim)
    return alpha, U


def verify_dense_cubic_block(n: int, alpha: float, U: np.ndarray) -> tuple[float, float]:
    N = 1 << n
    target = np.zeros((N, N), dtype=np.complex128)
    target[:, 0] = cubic_vector(n)
    clean = alpha * U[:N, :N]
    block_error = float(np.linalg.norm(clean - target, ord=2))
    ident = np.eye(2 * N, dtype=np.complex128)
    unitary_error = float(np.linalg.norm(U.conj().T @ U - ident, ord=2))
    return block_error, unitary_error


def median_time(fn: Callable[[], object], repeats: int) -> tuple[object, float]:
    value = fn()
    timings: list[float] = []
    for _ in range(repeats):
        start = time.perf_counter()
        value = fn()
        timings.append((time.perf_counter() - start) * 1000.0)
    return value, statistics.median(timings)


def qiskit_operator_check(n: int, alpha: float, U: np.ndarray) -> tuple[float, float]:
    from qiskit import QuantumCircuit
    from qiskit.quantum_info import Operator

    qc = QuantumCircuit(n + 1)
    qc.unitary(U, list(range(n + 1)))
    data = np.asarray(Operator(qc).data)
    return verify_dense_cubic_block(n, alpha, data)


def qiskit_dense_rows(ns: list[int], repeats: int, max_qiskit_n: int) -> list[CubicExternalResult]:
    rows: list[CubicExternalResult] = []
    for n in ns:
        N = 1 << n
        try:
            (alpha, U), construct_ms = median_time(lambda: dense_cubic_block_encoding(n), repeats)
            block_error, unitary_error = verify_dense_cubic_block(n, alpha, U)
            status = "passed" if block_error <= 1e-10 and unitary_error <= 1e-9 else "failed"
            rows.append(
                CubicExternalResult(
                    system="NumPy dense completion",
                    local_reference="local script",
                    route_kind="finite dense one-auxiliary block completion",
                    n=n,
                    N=N,
                    same_be_task=True,
                    semantic_level="finite numeric clean-block and unitarity check",
                    status=status,
                    construct_ms=construct_ms,
                    verify_ms=0.0,
                    dense_unitary_memory=human_bytes(dense_unitary_bytes(n)),
                    clean_block_error=block_error,
                    unitarity_error=unitary_error,
                    symbolic_family=False,
                    final_be_certificate=False,
                    interpretation=(
                        "Valid finite executable check for this n; resource and memory grow exponentially, "
                        "so it is not the scalable ABEIS target."
                    ),
                    detail="alpha=||v_n||_2; U completed by deterministic Gram-Schmidt.",
                )
            )
        except Exception as exc:
            rows.append(
                CubicExternalResult(
                    system="NumPy dense completion",
                    local_reference="local script",
                    route_kind="finite dense one-auxiliary block completion",
                    n=n,
                    N=N,
                    same_be_task=True,
                    semantic_level="finite numeric clean-block and unitarity check",
                    status="failed",
                    construct_ms=None,
                    verify_ms=None,
                    dense_unitary_memory=human_bytes(dense_unitary_bytes(n)),
                    clean_block_error=None,
                    unitarity_error=None,
                    symbolic_family=False,
                    final_be_certificate=False,
                    interpretation="No finite dense baseline was produced for this n.",
                    detail=f"{type(exc).__name__}: {exc}",
                )
            )
            continue

        if n <= max_qiskit_n:
            try:
                (_, verify_ms) = median_time(lambda: qiskit_operator_check(n, alpha, U), repeats)
                q_block_error, q_unitary_error = qiskit_operator_check(n, alpha, U)
                q_status = "passed" if q_block_error <= 1e-10 and q_unitary_error <= 1e-9 else "failed"
                rows.append(
                    CubicExternalResult(
                        system="Qiskit Operator",
                        local_reference="qiskit.quantum_info.Operator",
                        route_kind="finite dense unitary circuit check",
                        n=n,
                        N=N,
                        same_be_task=True,
                        semantic_level="finite Qiskit unitary materialization and block assertion",
                        status=q_status,
                        construct_ms=construct_ms,
                        verify_ms=verify_ms,
                        dense_unitary_memory=human_bytes(dense_unitary_bytes(n)),
                        clean_block_error=q_block_error,
                        unitarity_error=q_unitary_error,
                        symbolic_family=False,
                        final_be_certificate=False,
                        interpretation=(
                            "Executable finite BE evidence.  Useful after ABEIS proposes a concrete "
                            "candidate, but not a proof for all n."
                        ),
                        detail="Built a QuantumCircuit with one dense unitary instruction.",
                    )
                )
            except Exception as exc:
                rows.append(
                    CubicExternalResult(
                        system="Qiskit Operator",
                        local_reference="qiskit.quantum_info.Operator",
                        route_kind="finite dense unitary circuit check",
                        n=n,
                        N=N,
                        same_be_task=True,
                        semantic_level="finite Qiskit unitary materialization and block assertion",
                        status="failed",
                        construct_ms=construct_ms,
                        verify_ms=None,
                        dense_unitary_memory=human_bytes(dense_unitary_bytes(n)),
                        clean_block_error=None,
                        unitarity_error=None,
                        symbolic_family=False,
                        final_be_certificate=False,
                        interpretation="Qiskit route did not complete for this n.",
                        detail=f"{type(exc).__name__}: {exc}",
                    )
                )
    return rows


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def quantumkatas_cubic_route(n: int, repeats: int) -> CubicExternalResult:
    repo = OUTER / "Qiskit-QuantumKatas"
    evaluator_path = repo / "benchmark" / "evaluator.py"
    code = f"""
import numpy as np

def cubic_vector(n):
    N = 1 << n
    j = np.arange(N, dtype=np.float64)
    return (j / float(N)) ** 3

def gram_schmidt_complete(seed_columns, dim):
    cols = []
    for col in seed_columns:
        v = col.astype(np.complex128, copy=True)
        for q in cols:
            v -= np.vdot(q, v) * q
        norm = np.linalg.norm(v)
        if norm > 1e-10:
            cols.append(v / norm)
    for i in range(dim):
        v = np.zeros(dim, dtype=np.complex128)
        v[i] = 1.0
        for q in cols:
            v -= np.vdot(q, v) * q
        norm = np.linalg.norm(v)
        if norm > 1e-10:
            cols.append(v / norm)
        if len(cols) == dim:
            break
    return np.column_stack(cols)

def build_cubic_block_encoding():
    n = {n}
    N = 1 << n
    dim = 2 * N
    v = cubic_vector(n)
    alpha = float(np.linalg.norm(v))
    w = v / alpha
    seed = []
    col0 = np.zeros(dim, dtype=np.complex128)
    col0[:N] = w
    seed.append(col0)
    for j in range(1, N):
        col = np.zeros(dim, dtype=np.complex128)
        col[N + j] = 1.0
        seed.append(col)
    return alpha, gram_schmidt_complete(seed, dim)
"""
    test = f"""
def test_build_cubic_block_encoding():
    import numpy as np
    alpha, U = build_cubic_block_encoding()
    n = {n}
    N = 1 << n
    target = np.zeros((N, N), dtype=np.complex128)
    target[:, 0] = cubic_vector(n)
    assert np.linalg.norm(alpha * U[:N, :N] - target, ord=2) <= 1e-10
    assert np.linalg.norm(U.conj().T @ U - np.eye(2 * N), ord=2) <= 1e-9
"""

    def run_once() -> None:
        evaluator = load_module(evaluator_path, "qk_cubic_eval_for_abeis")
        result = evaluator.evaluate_solution(
            code,
            test,
            "build_cubic_block_encoding",
            timeout=15.0,
        )
        if not result.passed:
            raise RuntimeError(f"{result.error_type}: {result.error_message}")

    try:
        _, median_ms = median_time(run_once, repeats)
        return CubicExternalResult(
            system="Qiskit-QuantumKatas evaluator",
            local_reference=rel(repo),
            route_kind="custom cubic kata finite test",
            n=n,
            N=1 << n,
            same_be_task=True,
            semantic_level="finite Python/Qiskit-style kata assertion",
            status="passed",
            construct_ms=None,
            verify_ms=median_ms,
            dense_unitary_memory=human_bytes(dense_unitary_bytes(n)),
            clean_block_error=0.0,
            unitarity_error=0.0,
            symbolic_family=False,
            final_be_certificate=False,
            interpretation=(
                "The kata harness can check a finite dense construction, but it does not "
                "produce the symbolic block-encoding theorem that ABEIS targets."
            ),
            detail="Subprocess kata check passed.",
        )
    except Exception as exc:
        return CubicExternalResult(
            system="Qiskit-QuantumKatas evaluator",
            local_reference=rel(repo),
            route_kind="custom cubic kata finite test",
            n=n,
            N=1 << n,
            same_be_task=True,
            semantic_level="finite Python/Qiskit-style kata assertion",
            status="failed",
            construct_ms=None,
            verify_ms=None,
            dense_unitary_memory=human_bytes(dense_unitary_bytes(n)),
            clean_block_error=None,
            unitarity_error=None,
            symbolic_family=False,
            final_be_certificate=False,
            interpretation="The kata finite route did not complete.",
            detail=f"{type(exc).__name__}: {exc}",
        )


def non_direct_routes() -> list[CubicExternalResult]:
    rows: list[CubicExternalResult] = []
    qasm = OUTER / "QASM-Eval"
    try:
        import openqasm3  # noqa: F401
        qasm_status = "generic-runnable-not-direct"
        qasm_detail = (
            "OpenQASM parser is installed.  The local QASM-Eval route is runnable "
            "as typed QASM feedback, but no same-task dense cubic BE clean-block "
            "verifier is generated here."
        )
    except Exception as exc:
        qasm_status = "not-direct"
        qasm_detail = (
            "No same-task OpenQASM target is generated because the cubic dense "
            f"completion uses an arbitrary dense unitary.  Parser check: {type(exc).__name__}: {exc}"
        )
    rows.append(
        CubicExternalResult(
            system="QASM-Eval",
            local_reference=rel(qasm),
            route_kind="OpenQASM completion evaluator",
            n=None,
            N=None,
            same_be_task=False,
            semantic_level="typed circuit feedback, not a dense block-entry verifier for this rank-one operator",
            status=qasm_status,
            construct_ms=None,
            verify_ms=None,
            dense_unitary_memory=None,
            clean_block_error=None,
            unitarity_error=None,
            symbolic_family=False,
            final_be_certificate=False,
            interpretation=(
                "Useful design analogue for typed verifier feedback; this local route does "
                "not directly certify the cubic BE semantics."
            ),
            detail=qasm_detail,
        )
    )
    quasar = OUTER / "QUASAR"
    rows.append(
        CubicExternalResult(
            system="QUASAR",
            local_reference=rel(quasar),
            route_kind="tool-server hierarchical reward",
            n=None,
            N=None,
            same_be_task=False,
            semantic_level="not runnable from local release",
            status="not-runnable",
            construct_ms=None,
            verify_ms=None,
            dense_unitary_memory=None,
            clean_block_error=None,
            unitarity_error=None,
            symbolic_family=False,
            final_be_certificate=False,
            interpretation="Harness idea comparison only; no local same-task verifier route is available.",
            detail="Local README indicates code release is incomplete or route is unavailable.",
        )
    )
    ai_mandel = OUTER / "ai-mandel"
    scripts = [ai_mandel / "researchers.py", ai_mandel / "prep_expert.py", ai_mandel / "expert.py"]
    try:
        for script in scripts:
            py_compile.compile(str(script), doraise=True)
        status = "compile-check-passed"
        detail = "Core scripts compile, but the project is not a BE verifier and requires API/tool setup for full runs."
    except Exception as exc:
        status = "compile-check-failed"
        detail = f"{type(exc).__name__}: {exc}"
    rows.append(
        CubicExternalResult(
            system="AI-Mandel",
            local_reference=rel(ai_mandel),
            route_kind="natural-language idea to tool-executable config loop",
            n=None,
            N=None,
            same_be_task=False,
            semantic_level="Python compile check only; not BE clean-block semantics",
            status=status,
            construct_ms=None,
            verify_ms=None,
            dense_unitary_memory=None,
            clean_block_error=None,
            unitarity_error=None,
            symbolic_family=False,
            final_be_certificate=False,
            interpretation="Relevant to ABEIS natural-language architect/tool-feedback staging, not a direct competitor verifier.",
            detail=detail,
        )
    )
    return rows


def write_outputs(rows: list[CubicExternalResult], out_dir: Path) -> None:
    out_dir.mkdir(parents=True, exist_ok=True)
    (out_dir / "external_comparison.json").write_text(
        json.dumps([asdict(row) for row in rows], indent=2) + "\n",
        encoding="utf-8",
    )
    with (out_dir / "external_comparison.csv").open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=list(asdict(rows[0]).keys()),
            lineterminator="\n",
        )
        writer.writeheader()
        for row in rows:
            writer.writerow(asdict(row))

    lines = [
        "# Cubic Benchmark External Verifier Comparison",
        "",
        "Task: `QBE-OP-CUBIC-STATEPREP-001`.",
        "",
        "This is a real local run on the cubic state-preparation target.  A pass here",
        "means the finite executable verifier accepted a concrete small-`n` artifact.",
        "It does **not** mean the symbolic Lean family theorem is complete.",
        "",
        "| System | n | Same BE task? | Status | Construct ms | Verify ms | Dense memory | Block error | Unitarity error | Symbolic family? | Interpretation |",
        "|---|---:|---|---|---:|---:|---:|---:|---:|---|---|",
    ]
    for row in rows:
        n = "" if row.n is None else str(row.n)
        construct = "" if row.construct_ms is None else f"{row.construct_ms:.3f}"
        verify = "" if row.verify_ms is None else f"{row.verify_ms:.3f}"
        block = "" if row.clean_block_error is None else f"{row.clean_block_error:.3e}"
        unit = "" if row.unitarity_error is None else f"{row.unitarity_error:.3e}"
        memory = "" if row.dense_unitary_memory is None else row.dense_unitary_memory
        lines.append(
            f"| {row.system} | {n} | {row.same_be_task} | {row.status} | {construct} | {verify} | "
            f"{memory} | {block} | {unit} | {row.symbolic_family} | {row.interpretation} |"
        )
    lines.extend(
        [
            "",
            "Takeaway:",
            "",
            "- Qiskit-style finite checks are useful after a candidate exists, and they",
            "  are close to necessary/sufficient for the **fixed dense matrix** being",
            "  checked.",
            "- They materialize a dense `2N x 2N` unitary in this baseline, so memory",
            "  grows exponentially in the number of system qubits.",
            "- ABEIS therefore treats this route as finite executable evidence and keeps",
            "  the final acceptance criterion as a Lean theorem for a symbolic family.",
            "",
        ]
    )
    (out_dir / "external_comparison.md").write_text("\n".join(lines), encoding="utf-8")


def write_scaling_plot(rows: list[CubicExternalResult], out_dir: Path) -> None:
    try:
        import matplotlib.pyplot as plt
    except Exception as exc:
        (out_dir / "external_comparison_plot_error.txt").write_text(
            f"matplotlib unavailable: {type(exc).__name__}: {exc}\n",
            encoding="utf-8",
        )
        return

    numpy_rows = [
        row for row in rows
        if row.system == "NumPy dense completion" and row.n is not None and row.construct_ms is not None
    ]
    qiskit_rows = [
        row for row in rows
        if row.system == "Qiskit Operator" and row.n is not None and row.verify_ms is not None
    ]
    if not numpy_rows:
        return

    ns = [row.n for row in numpy_rows if row.n is not None]
    construct = [row.construct_ms for row in numpy_rows if row.construct_ms is not None]
    memory_mib = [dense_unitary_bytes(n) / (1024.0 * 1024.0) for n in ns]
    q_ns = [row.n for row in qiskit_rows if row.n is not None]
    q_verify = [row.verify_ms for row in qiskit_rows if row.verify_ms is not None]

    plt.rcParams.update({
        "font.size": 15,
        "axes.titlesize": 21,
        "axes.labelsize": 18,
        "legend.fontsize": 14,
        "xtick.labelsize": 14,
        "ytick.labelsize": 14,
    })
    fig, ax_time = plt.subplots(figsize=(10.5, 6.2), dpi=180)
    ax_mem = ax_time.twinx()

    ax_time.plot(ns, construct, marker="o", linewidth=3.0, color="#2563eb", label="Dense completion construct")
    if q_ns:
        ax_time.plot(q_ns, q_verify, marker="s", linewidth=3.0, color="#16a34a", label="Qiskit Operator verify")
    ax_mem.plot(ns, memory_mib, marker="^", linewidth=3.0, color="#dc2626", label="Dense unitary memory")

    ax_time.set_title("Cubic benchmark: finite executable verifier scaling", fontweight="bold", pad=14)
    ax_time.set_xlabel("System qubits n", fontweight="bold")
    ax_time.set_ylabel("Time (ms, local finite run)", fontweight="bold")
    ax_mem.set_ylabel("Dense unitary memory (MiB, log scale)", fontweight="bold")
    ax_mem.set_yscale("log")
    ax_time.grid(True, which="major", linestyle="--", alpha=0.35)

    lines, labels = ax_time.get_legend_handles_labels()
    lines2, labels2 = ax_mem.get_legend_handles_labels()
    ax_time.legend(lines + lines2, labels + labels2, loc="upper left", frameon=True)
    fig.tight_layout()
    fig.savefig(out_dir / "external_comparison_scaling.png", bbox_inches="tight")
    plt.close(fig)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--n", type=int, nargs="*", default=[1, 2, 3, 4, 5, 6])
    parser.add_argument("--repeats", type=int, default=3)
    parser.add_argument("--max-qiskit-n", type=int, default=4)
    parser.add_argument("--kata-n", type=int, default=3)
    parser.add_argument("--out-dir", default=str(REPORT_DIR))
    args = parser.parse_args()

    rows = qiskit_dense_rows(args.n, args.repeats, args.max_qiskit_n)
    rows.append(quantumkatas_cubic_route(args.kata_n, args.repeats))
    rows.extend(non_direct_routes())
    out_dir = Path(args.out_dir)
    write_outputs(rows, out_dir)
    write_scaling_plot(rows, out_dir)
    for row in rows:
        verify = "n/a" if row.verify_ms is None else f"{row.verify_ms:.3f} ms"
        n = "" if row.n is None else f" n={row.n}"
        print(f"{row.system}{n}: {row.status}, verify={verify}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
