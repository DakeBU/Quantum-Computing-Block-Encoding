#!/usr/bin/env python3
"""Compare verifier layers on the ABEIS optimal-control main case.

This benchmark is intentionally small and honest:

* the NumPy verifier is an exact finite-matrix check for the concrete
  `E_1 = |0><1|_time tensor |0><1|_type tensor I_state` task;
* the Qiskit verifier is optional and only runs when `qiskit` is installed;
* the Lean verifier runs the repository gate `lake build Tests`.

The timing numbers are wall-clock verifier/checker times.  They do not include
the human/agent time needed to invent the candidate, write Qiskit code, write
Lean code, repair failures, or spend tokens.  Those harness-level metrics are
stored separately when available.
"""

from __future__ import annotations

import argparse
import csv
import json
import statistics
import subprocess
import sys
import time
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Callable

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
REPORT_DIR = ROOT / "reports" / "verifier-comparison" / "QBE-OP-OPTCTRL-001"
DOC_ASSETS = ROOT / "docs" / "assets"


@dataclass
class VerifierTiming:
    verifier: str
    semantic_level: str
    status: str
    repeats: int
    median_ms: float | None
    mean_ms: float | None
    min_ms: float | None
    max_ms: float | None
    complete_for_main_case: bool
    final_acceptance_gate: bool
    detail: str


@dataclass
class HarnessMetric:
    route: str
    artifact: str
    measured: bool
    agent_wall_time_s: float | None
    input_tokens: int | None
    output_tokens: int | None
    total_tokens: int | None
    checker_wall_time_ms: float | None
    compile_or_parse_time_ms: float | None
    detail: str


@dataclass
class ScalingTiming:
    verifier: str
    time_qubits: int
    total_qubits_with_ancilla: int
    matrix_dimension: int
    status: str
    median_ms: float | None
    detail: str


@dataclass
class ScalingForecast:
    time_qubits: int
    total_qubits_with_ancilla: int
    dense_dimension: int
    dense_unitary_entries: int
    dense_complex128_bytes: int
    dense_complex128_human: str
    interpretation: str


def bit(index: int, i: int) -> int:
    return (index >> i) & 1


def flip(index: int, i: int) -> int:
    return index ^ (1 << i)


def evolved_image(index: int) -> int:
    """Full 4-bit evolved circuit image.

    Bit order follows `QuantumBlockEncoding/OptimalControl.lean`:
    bit 0 = passive state, bit 1 = type, bit 2 = time, bit 3 = block ancilla.
    The circuit is CCX(type,time -> aux), then parallel X on type/time/aux.
    """

    out = index
    if bit(out, 1) and bit(out, 2):
        out = flip(out, 3)
    out = flip(out, 1)
    out = flip(out, 2)
    out = flip(out, 3)
    return out


def evolved_image_r(index: int, time_qubits: int) -> int:
    """Generalized equality-flag-and-flip image for `k = 2^r - 1`.

    Bit order:
    bit 0 = passive state,
    bit 1 = type,
    bits 2..r+1 = time,
    bit r+2 = block ancilla.
    """

    out = index
    all_time_one = all(bit(out, 2 + j) for j in range(time_qubits))
    if bit(out, 1) and all_time_one:
        out = flip(out, time_qubits + 2)
    out = flip(out, 1)
    for j in range(time_qubits):
        out = flip(out, 2 + j)
    out = flip(out, time_qubits + 2)
    return out


def permutation_matrix(image: Callable[[int], int], size: int) -> np.ndarray:
    mat = np.zeros((size, size), dtype=np.int8)
    for col in range(size):
        mat[image(col), col] = 1
    return mat


def target_e1() -> np.ndarray:
    mat = np.zeros((8, 8), dtype=np.int8)
    mat[0, 6] = 1
    mat[1, 7] = 1
    return mat


def target_ek(time_qubits: int) -> np.ndarray:
    """Target block for `|0><(2^r-1)|_time tensor |0><1|_type tensor I_state`."""

    system_dimension = 1 << (time_qubits + 2)
    target = np.zeros((system_dimension, system_dimension), dtype=np.int8)
    selected_time = (1 << time_qubits) - 1
    for state in (0, 1):
        source = state | (1 << 1) | (selected_time << 2)
        dest = state
        target[dest, source] = 1
    return target


def numpy_exact_check() -> None:
    unitary = permutation_matrix(evolved_image, 16)
    target = target_e1()
    if not np.array_equal(unitary.T @ unitary, np.eye(16, dtype=np.int8)):
        raise AssertionError("NumPy finite verifier: U^T U != I")
    if not np.array_equal(unitary @ unitary.T, np.eye(16, dtype=np.int8)):
        raise AssertionError("NumPy finite verifier: U U^T != I")
    if not np.array_equal(unitary[:8, :8], target):
        raise AssertionError("NumPy finite verifier: clean block != E_1")


def qiskit_operator_check() -> None:
    try:
        from qiskit import QuantumCircuit
        from qiskit.quantum_info import Operator
    except Exception as exc:  # pragma: no cover - depends on optional install.
        raise RuntimeError(f"qiskit unavailable: {exc}") from exc

    qc = QuantumCircuit(4)
    qc.ccx(1, 2, 3)
    qc.x(1)
    qc.x(2)
    qc.x(3)
    data = np.asarray(Operator(qc).data)
    expected = permutation_matrix(evolved_image, 16).astype(complex)
    target = target_e1().astype(complex)
    if not np.allclose(data.conj().T @ data, np.eye(16), atol=1e-12):
        raise AssertionError("Qiskit Operator verifier: U^dagger U != I")
    if not np.allclose(data, expected, atol=1e-12):
        raise AssertionError("Qiskit Operator verifier: operator convention mismatch")
    if not np.allclose(data[:8, :8], target, atol=1e-12):
        raise AssertionError("Qiskit Operator verifier: clean block != E_1")


def dense_numpy_block_check_r(time_qubits: int) -> None:
    total_dimension = 1 << (time_qubits + 3)
    system_dimension = 1 << (time_qubits + 2)
    unitary = permutation_matrix(lambda index: evolved_image_r(index, time_qubits), total_dimension)
    target = target_ek(time_qubits)
    if not np.array_equal(unitary[:system_dimension, :system_dimension], target):
        raise AssertionError(f"dense NumPy block check failed for r={time_qubits}")


def qiskit_operator_check_r(time_qubits: int) -> None:
    try:
        from qiskit import QuantumCircuit
        from qiskit.quantum_info import Operator
    except Exception as exc:  # pragma: no cover - depends on optional install.
        raise RuntimeError(f"qiskit unavailable: {exc}") from exc

    aux = time_qubits + 2
    qc = QuantumCircuit(time_qubits + 3)
    controls = [1] + [2 + j for j in range(time_qubits)]
    qc.mcx(controls, aux)
    qc.x(1)
    for j in range(time_qubits):
        qc.x(2 + j)
    qc.x(aux)
    data = np.asarray(Operator(qc).data)
    system_dimension = 1 << (time_qubits + 2)
    target = target_ek(time_qubits).astype(complex)
    if not np.allclose(data[:system_dimension, :system_dimension], target, atol=1e-12):
        raise AssertionError(f"Qiskit Operator block check failed for r={time_qubits}")


def time_repeated(name: str, repeats: int, fn: Callable[[], None], **meta: object) -> VerifierTiming:
    timings: list[float] = []
    try:
        fn()  # warm-up imports/cache construction; not included in steady-state timing.
        for _ in range(repeats):
            start = time.perf_counter()
            fn()
            timings.append((time.perf_counter() - start) * 1000.0)
    except Exception as exc:
        return VerifierTiming(
            verifier=name,
            status="unavailable" if name.startswith("qiskit") else "failed",
            repeats=0,
            median_ms=None,
            mean_ms=None,
            min_ms=None,
            max_ms=None,
            detail=str(exc),
            **meta,
        )
    return VerifierTiming(
        verifier=name,
        status="passed",
        repeats=repeats,
        median_ms=statistics.median(timings),
        mean_ms=statistics.mean(timings),
        min_ms=min(timings),
        max_ms=max(timings),
        detail="passed exact finite check",
        **meta,
    )


def time_scaling(verifier: str, time_qubits: int, repeats: int, fn: Callable[[], None]) -> ScalingTiming:
    timings: list[float] = []
    try:
        fn()
        for _ in range(repeats):
            start = time.perf_counter()
            fn()
            timings.append((time.perf_counter() - start) * 1000.0)
        status = "passed"
        median = statistics.median(timings)
        detail = "passed dense finite block check"
    except Exception as exc:
        status = "unavailable" if "qiskit" in verifier and "unavailable" in str(exc).lower() else "failed"
        median = None
        detail = str(exc)
    return ScalingTiming(
        verifier=verifier,
        time_qubits=time_qubits,
        total_qubits_with_ancilla=time_qubits + 3,
        matrix_dimension=1 << (time_qubits + 3),
        status=status,
        median_ms=median,
        detail=detail,
    )


def lean_gate_check(timeout: int) -> VerifierTiming:
    start = time.perf_counter()
    proc = subprocess.run(
        ["lake", "build", "Tests"],
        cwd=ROOT,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        timeout=timeout,
    )
    elapsed = (time.perf_counter() - start) * 1000.0
    status = "passed" if proc.returncode == 0 else "failed"
    tail = "\n".join(proc.stdout.splitlines()[-8:])
    return VerifierTiming(
        verifier="lean_lake_build_tests",
        semantic_level="formal theorem/proof gate",
        status=status,
        repeats=1,
        median_ms=elapsed,
        mean_ms=elapsed,
        min_ms=elapsed,
        max_ms=elapsed,
        complete_for_main_case=True,
        final_acceptance_gate=True,
        detail=tail,
    )


def write_csv(rows: list[VerifierTiming], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(asdict(rows[0]).keys()))
        writer.writeheader()
        for row in rows:
            writer.writerow(asdict(row))


def write_scaling_csv(rows: list[ScalingTiming], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(asdict(rows[0]).keys()))
        writer.writeheader()
        for row in rows:
            writer.writerow(asdict(row))


def write_json(rows: list[VerifierTiming], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps([asdict(row) for row in rows], indent=2), encoding="utf-8")


def write_scaling_json(rows: list[ScalingTiming], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps([asdict(row) for row in rows], indent=2), encoding="utf-8")


def write_forecast_json(rows: list[ScalingForecast], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps([asdict(row) for row in rows], indent=2), encoding="utf-8")


def write_forecast_csv(rows: list[ScalingForecast], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(asdict(rows[0]).keys()))
        writer.writeheader()
        for row in rows:
            writer.writerow(asdict(row))


def write_markdown(rows: list[VerifierTiming], path: Path) -> None:
    lines = [
        "# Verifier Comparison: QBE-OP-OPTCTRL-001",
        "",
        "This report compares verifier layers on the concrete main-case operator",
        "`E_1 = |0><1|_time tensor |0><1|_type tensor I_state`.",
        "",
        "Important interpretation:",
        "",
        "- NumPy and Qiskit `Operator` checks are complete for this finite 4-qubit",
        "  matrix instance when the circuit and target are both fully instantiated;",
        "  Qiskit is compared with a `1e-12` numerical tolerance.",
        "- QASM-Eval-style distribution/timeline/pulse checks are not used here;",
        "  those checks are useful diagnostics but are not general proof closure for",
        "  ABEIS block-encoding theorems.",
        "- Lean remains the final repository acceptance gate because it stores the",
        "  reusable theorem, definitions, resource tuple, and future dependencies.",
        "",
        "| Verifier | Semantic level | Status | Median ms | Complete for this case | Final gate |",
        "| --- | --- | --- | ---: | --- | --- |",
    ]
    for row in rows:
        median = "" if row.median_ms is None else f"{row.median_ms:.3f}"
        lines.append(
            f"| `{row.verifier}` | {row.semantic_level} | {row.status} | {median} | "
            f"{row.complete_for_main_case} | {row.final_acceptance_gate} |"
        )
    lines += [
        "",
        "## What this does not measure",
        "",
        "The table above measures only checker wall time.  It does not measure the",
        "time or tokens needed for an AI agent to write the candidate Qiskit code,",
        "write the Lean declarations and proofs, repair failures, or coordinate",
        "multiple agents.  A fair harness comparison needs three layers:",
        "",
        "1. checker time: parser/simulator/Lean build time;",
        "2. artifact-production time: agent wall time to write and repair code;",
        "3. token throughput: input, output, and total tokens per accepted candidate.",
        "",
        "ABEIS records checker time here.  Route-total ablations are recorded",
        "separately under `reports/route-ablation/QBE-OP-OPTCTRL-001/` because",
        "they include AI writing, repair, coordination, and model-wrapper token",
        "accounting where available.  The current route-total rows compare a",
        "Qiskit-only agent route, a Lean-only agent route, and an ABEIS",
        "multi-agent route on the same target.",
        "",
        "The timing plot is generated at `docs/assets/verifier_time_comparison.png`.",
        "Treat the plot as verification wall-clock evidence, not as a token-cost",
        "measurement of the multi-agent harness.",
    ]
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_scaling_markdown(rows: list[ScalingTiming], path: Path) -> None:
    lines = [
        "# Dense Verifier Scaling: QBE-OP-OPTCTRL-001 Family",
        "",
        "This scaling check uses the same transfer-operator family",
        "`E_k = |0><k|_time tensor |0><1|_type tensor I_state` with `k = 2^r - 1`.",
        "It intentionally measures dense finite verifiers, not Lean symbolic proof",
        "checking for a general theorem.",
        "",
        "| Verifier | time qubits r | total qubits incl. ancilla | dense dimension | status | median ms |",
        "| --- | ---: | ---: | ---: | --- | ---: |",
    ]
    for row in rows:
        median = "" if row.median_ms is None else f"{row.median_ms:.3f}"
        lines.append(
            f"| `{row.verifier}` | {row.time_qubits} | {row.total_qubits_with_ancilla} | "
            f"{row.matrix_dimension} | {row.status} | {median} |"
        )
    lines += [
        "",
        "Interpretation:",
        "",
        "- Dense NumPy and Qiskit `Operator` checks become expensive because they",
        "  materialize matrices of dimension `2^(r+3)` for this one-state-register",
        "  family.  This is the same exponential bottleneck that prevents ordinary",
        "  simulation from validating large quantum circuits by brute force.",
        "- ABEIS should use these checks for small finite instances, counterexamples,",
        "  and fixed-instance executable checks.  The intended large-register route is a symbolic Lean",
        "  theorem about registers and gate semantics, whose checking cost should",
        "  scale with proof size rather than dense Hilbert-space dimension.",
        "- The current concrete main case is already Lean-certified for `r = 1`.",
        "  A parametric Lean theorem for all `r` is a future strengthening, so this",
        "  scaling plot is a motivation for that direction, not a claim that it is",
        "  already complete.",
        "",
        "The scaling plot is generated at `docs/assets/verifier_scaling_comparison.png`.",
    ]
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def human_bytes(value: int) -> str:
    units = ["B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB"]
    x = float(value)
    for unit in units:
        if x < 1024.0 or unit == units[-1]:
            return f"{x:.2f} {unit}"
        x /= 1024.0
    return f"{value} B"


def forecast_dense_unitary_rows(time_qubits: list[int]) -> list[ScalingForecast]:
    rows: list[ScalingForecast] = []
    for r in time_qubits:
        total_qubits = r + 3
        dimension = 1 << total_qubits
        entries = dimension * dimension
        bytes_complex128 = entries * 16
        if bytes_complex128 < 2**30:
            interpretation = "small finite quick executable check scale"
        elif bytes_complex128 < 2**40:
            interpretation = "workstation-scale dense check"
        elif bytes_complex128 < 2**50:
            interpretation = "large-memory dense check"
        elif bytes_complex128 < 2**60:
            interpretation = "impractical for routine verifier feedback"
        else:
            interpretation = "symbolic theorem route required in practice"
        rows.append(
            ScalingForecast(
                time_qubits=r,
                total_qubits_with_ancilla=total_qubits,
                dense_dimension=dimension,
                dense_unitary_entries=entries,
                dense_complex128_bytes=bytes_complex128,
                dense_complex128_human=human_bytes(bytes_complex128),
                interpretation=interpretation,
            )
        )
    return rows


def write_forecast_markdown(rows: list[ScalingForecast], path: Path) -> None:
    lines = [
        "# Hard BE Dense-Unitary Forecast",
        "",
        "This is not a runtime benchmark.  It is a memory forecast for the same",
        "`E_k = |0><k|_time tensor |0><1|_type tensor I_state` block-encoding",
        "family if a verifier insists on materializing the full dense complex",
        "unitary matrix.  The candidate circuit itself is simple, but a dense",
        "matrix verifier stores `dimension^2` complex entries.",
        "",
        "| time qubits r | total qubits incl. ancilla | dense dimension | complex128 memory | interpretation |",
        "| ---: | ---: | ---: | ---: | --- |",
    ]
    for row in rows:
        lines.append(
            f"| {row.time_qubits} | {row.total_qubits_with_ancilla} | "
            f"{row.dense_dimension:,} | {row.dense_complex128_human} | "
            f"{row.interpretation} |"
        )
    lines += [
        "",
        "Why this matters:",
        "",
        "- Qiskit `Operator`, statevector, or NumPy dense-unitary checks are valuable",
        "  and complete for fully instantiated small circuits.",
        "- They are not a scalable replacement for proof when the intended theorem",
        "  is a family over register size, because the dense verifier pays the",
        "  Hilbert-space dimension directly.",
        "- ABEIS therefore treats finite executable checks as counterexample and",
        "  fixed-instance executable-check layers, then asks Lean to certify the reusable block-encoding",
        "  theorem and resource tuple.",
        "",
        "The forecast plot is generated at",
        "`docs/assets/verifier_hard_scaling_forecast.png`.",
    ]
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_ablation_protocol(path: Path) -> None:
    lines = [
        "# Controlled Agent Ablation Protocol",
        "",
        "The verifier timing plot answers only one question: how long does a finished",
        "artifact take to check?  It does not answer whether agents write Qiskit,",
        "Lean, or ABEIS artifacts faster.  That requires a controlled ablation.",
        "",
        "Run the same operator target through three routes with the same model, budget,",
        "and prompt envelope:",
        "",
        "1. `qiskit_operator_route`: ask the agent to produce Qiskit code and a",
        "   `qiskit.quantum_info.Operator` equality check for the finite instance.",
        "2. `lean_route`: ask the agent to produce the Lean declarations and proofs",
        "   directly, without ABEIS multi-agent memory or candidate populations.",
        "3. `abeis_multi_agent_route`: use the full upper/middle/lower/reviewer",
        "   harness with candidate population, typed verifier feedback, and Lean gate.",
        "",
        "For each route, record:",
        "",
        "- artifact-production wall time: agent runtime from prompt dispatch to final",
        "  accepted artifact;",
        "- checker/compile wall time: parser, simulator, Qiskit Operator, `lake build`,",
        "  or equivalent verifier time;",
        "- input tokens, output tokens, total tokens, and number of repair iterations;",
        "- final semantic level: finite executable check, Lean concrete theorem, or",
        "  Lean parametric theorem;",
        "- whether the result is reusable as a future dependency.",
        "",
        "Do not compare Qiskit checker time against Lean total agent time.  The fair",
        "comparison is route-total time and tokens, with checker time reported as a",
        "separate component.",
    ]
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_harness_metric_template(rows: list[VerifierTiming], path: Path) -> None:
    by_name = {row.verifier: row for row in rows}
    qiskit = by_name.get("qiskit_operator")
    lean = by_name.get("lean_lake_build_tests")
    metrics = [
        HarnessMetric(
            route="qiskit_operator_route",
            artifact="Python/Qiskit circuit plus Operator equality check",
            measured=False,
            agent_wall_time_s=None,
            input_tokens=None,
            output_tokens=None,
            total_tokens=None,
            checker_wall_time_ms=qiskit.median_ms if qiskit else None,
            compile_or_parse_time_ms=None,
            detail=(
                "Only checker timing is measured. Need a controlled agent run "
                "that writes the Qiskit artifact from the same prompt."
            ),
        ),
        HarnessMetric(
            route="lean_route",
            artifact="Lean definitions, theorem statements, proofs, and lake build",
            measured=False,
            agent_wall_time_s=None,
            input_tokens=None,
            output_tokens=None,
            total_tokens=None,
            checker_wall_time_ms=lean.median_ms if lean else None,
            compile_or_parse_time_ms=lean.median_ms if lean else None,
            detail=(
                "Only cached build timing is measured here. Existing run logs "
                "include agent work but were not produced under a controlled "
                "Qiskit-vs-Lean ablation."
            ),
        ),
        HarnessMetric(
            route="abeis_multi_agent_route",
            artifact="candidate population, Lean proof, verifier feedback, reports",
            measured=False,
            agent_wall_time_s=None,
            input_tokens=None,
            output_tokens=None,
            total_tokens=None,
            checker_wall_time_ms=lean.median_ms if lean else None,
            compile_or_parse_time_ms=lean.median_ms if lean else None,
            detail=(
                "Requires a controlled sleep-run or manual multi-agent run with "
                "token accounting enabled. Do not infer this from checker time."
            ),
        ),
    ]
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps([asdict(row) for row in metrics], indent=2), encoding="utf-8")


def render_plot(rows: list[VerifierTiming], path: Path) -> None:
    import matplotlib

    matplotlib.use("Agg")
    import matplotlib.pyplot as plt

    passed = [row for row in rows if row.median_ms is not None]
    labels = [row.verifier.replace("_", "\n") for row in passed]
    values = [row.median_ms for row in passed]
    colors = ["#2563eb" if "numpy" in row.verifier else "#16a34a" if "qiskit" in row.verifier else "#7c3aed" for row in passed]

    fig, ax = plt.subplots(figsize=(10.8, 5.4), dpi=170)
    fig.patch.set_facecolor("white")
    ax.bar(labels, values, color=colors)
    ax.set_yscale("log")
    ax.set_ylabel("Median verifier time, ms (log scale)", fontsize=12, weight="bold")
    ax.set_title("Main Case Verifier Timing: Finite/Qiskit vs Lean Gate", fontsize=15, weight="bold")
    ax.grid(axis="y", linestyle="--", alpha=0.35)
    ax.tick_params(axis="x", labelsize=10)
    for tick in ax.get_xticklabels() + ax.get_yticklabels():
        tick.set_fontweight("bold")
    for idx, value in enumerate(values):
        ax.text(idx, value * 1.12, f"{value:.2f} ms", ha="center", va="bottom", fontsize=9, weight="bold")
    unavailable = [row.verifier for row in rows if row.median_ms is None]
    if unavailable:
        ax.text(
            0.02,
            0.03,
            "Unavailable in this environment: " + ", ".join(unavailable),
            transform=ax.transAxes,
            fontsize=9,
            color="#475569",
            bbox=dict(facecolor="white", edgecolor="none", alpha=0.85, pad=2.0),
        )
    path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(path, bbox_inches="tight", pad_inches=0.08)
    plt.close(fig)


def render_scaling_plot(rows: list[ScalingTiming], path: Path) -> None:
    import matplotlib

    matplotlib.use("Agg")
    import matplotlib.pyplot as plt

    fig, ax = plt.subplots(figsize=(10.8, 5.8), dpi=170)
    fig.patch.set_facecolor("white")
    colors = {"dense_numpy_block": "#2563eb", "qiskit_operator_dense": "#16a34a"}
    markers = {"dense_numpy_block": "o", "qiskit_operator_dense": "s"}
    for verifier in sorted({row.verifier for row in rows}):
        passed = [row for row in rows if row.verifier == verifier and row.median_ms is not None]
        if not passed:
            continue
        ax.plot(
            [row.time_qubits for row in passed],
            [row.median_ms for row in passed],
            marker=markers.get(verifier, "o"),
            linewidth=2.8,
            markersize=7,
            label=verifier.replace("_", " "),
            color=colors.get(verifier),
        )
    ax.set_yscale("log")
    ax.set_xlabel("time-register qubits r", fontsize=13, weight="bold")
    ax.set_ylabel("Median dense verifier time, ms (log scale)", fontsize=13, weight="bold")
    ax.set_title("Dense Finite Verifier Scaling for the E_k Family", fontsize=15, weight="bold")
    ax.grid(axis="both", linestyle="--", alpha=0.35)
    ax.legend(fontsize=11)
    for tick in ax.get_xticklabels() + ax.get_yticklabels():
        tick.set_fontweight("bold")
    path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(path, bbox_inches="tight", pad_inches=0.08)
    plt.close(fig)


def render_forecast_plot(rows: list[ScalingForecast], path: Path) -> None:
    import matplotlib

    matplotlib.use("Agg")
    import matplotlib.pyplot as plt

    xs = [row.time_qubits for row in rows]
    ys = [row.dense_complex128_bytes / (1024.0**3) for row in rows]
    fig, ax = plt.subplots(figsize=(11.0, 5.8), dpi=170)
    fig.patch.set_facecolor("white")
    ax.plot(xs, ys, marker="o", linewidth=3.0, markersize=7, color="#dc2626")
    ax.set_yscale("log")
    ax.set_xlabel("time-register qubits r", fontsize=13, weight="bold")
    ax.set_ylabel("Dense complex128 unitary memory, GiB (log scale)", fontsize=13, weight="bold")
    ax.set_title("Why Dense Quantum-Circuit Verification Stops Scaling", fontsize=15, weight="bold")
    ax.grid(axis="both", linestyle="--", alpha=0.35)
    for tick in ax.get_xticklabels() + ax.get_yticklabels():
        tick.set_fontweight("bold")
    for row, y in zip(rows, ys):
        if row.time_qubits in {1, 8, 16, 24, 32}:
            ax.text(
                row.time_qubits,
                y * 1.25,
                row.dense_complex128_human,
                ha="center",
                va="bottom",
                fontsize=8.5,
                weight="bold",
                color="#7f1d1d",
            )
    path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(path, bbox_inches="tight", pad_inches=0.08)
    plt.close(fig)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--numpy-repeats", type=int, default=2000)
    parser.add_argument("--qiskit-repeats", type=int, default=100)
    parser.add_argument("--lean-timeout", type=int, default=180)
    parser.add_argument("--scaling-max-r", type=int, default=7)
    parser.add_argument("--scaling-repeats", type=int, default=5)
    parser.add_argument(
        "--forecast-r",
        default="1,4,8,12,16,20,24,28,32",
        help="comma-separated time-register sizes for dense-unitary memory forecast",
    )
    parser.add_argument(
        "--skip-scaling",
        action="store_true",
        help="skip dense verifier scaling outputs",
    )
    args = parser.parse_args()

    rows = [
        time_repeated(
            "numpy_exact_matrix",
            args.numpy_repeats,
            numpy_exact_check,
            semantic_level="exact finite matrix check",
            complete_for_main_case=True,
            final_acceptance_gate=False,
        ),
        time_repeated(
            "qiskit_operator",
            args.qiskit_repeats,
            qiskit_operator_check,
            semantic_level="exact finite Qiskit Operator check",
            complete_for_main_case=True,
            final_acceptance_gate=False,
        ),
        lean_gate_check(args.lean_timeout),
    ]

    write_json(rows, REPORT_DIR / "latest.json")
    write_csv(rows, REPORT_DIR / "latest.csv")
    write_harness_metric_template(rows, REPORT_DIR / "harness_metrics_template.json")
    write_markdown(rows, REPORT_DIR / "latest.md")
    write_ablation_protocol(REPORT_DIR / "agent_ablation_protocol.md")
    render_plot(rows, DOC_ASSETS / "verifier_time_comparison.png")
    if not args.skip_scaling:
        scaling_rows: list[ScalingTiming] = []
        for r in range(1, args.scaling_max_r + 1):
            scaling_rows.append(
                time_scaling(
                    "dense_numpy_block",
                    r,
                    args.scaling_repeats,
                    lambda r=r: dense_numpy_block_check_r(r),
                )
            )
            scaling_rows.append(
                time_scaling(
                    "qiskit_operator_dense",
                    r,
                    max(1, min(args.scaling_repeats, 3)),
                    lambda r=r: qiskit_operator_check_r(r),
                )
            )
        write_scaling_json(scaling_rows, REPORT_DIR / "scaling.json")
        write_scaling_csv(scaling_rows, REPORT_DIR / "scaling.csv")
        write_scaling_markdown(scaling_rows, REPORT_DIR / "scaling.md")
        render_scaling_plot(scaling_rows, DOC_ASSETS / "verifier_scaling_comparison.png")
    forecast_rs = [int(part.strip()) for part in args.forecast_r.split(",") if part.strip()]
    forecast_rows = forecast_dense_unitary_rows(forecast_rs)
    write_forecast_json(forecast_rows, REPORT_DIR / "hard_scaling_forecast.json")
    write_forecast_csv(forecast_rows, REPORT_DIR / "hard_scaling_forecast.csv")
    write_forecast_markdown(forecast_rows, REPORT_DIR / "hard_scaling_forecast.md")
    render_forecast_plot(forecast_rows, DOC_ASSETS / "verifier_hard_scaling_forecast.png")
    for row in rows:
        median = "n/a" if row.median_ms is None else f"{row.median_ms:.3f} ms"
        print(f"{row.verifier}: {row.status}, median={median}")
    if not args.skip_scaling:
        print(f"scaling: wrote {REPORT_DIR / 'scaling.md'}")
    print(f"forecast: wrote {REPORT_DIR / 'hard_scaling_forecast.md'}")
    return 0 if all(row.status in {"passed", "unavailable"} for row in rows) else 1


if __name__ == "__main__":
    raise SystemExit(main())
