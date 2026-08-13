#!/usr/bin/env python3
"""Export the Lean-refined fixed-N Robin XOR circuit gate by gate."""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from fractions import Fraction
from pathlib import Path

import numpy as np
import qiskit
from qiskit import QuantumCircuit
from qiskit.quantum_info import Operator

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from tools.backends import internal_matrix_backend, openqasm3_backend, qiskit_backend
from tools.executable_ir import (
    CircuitIR, angle_neg, compile_uniformly_controlled_ry, pi_rational,
    primitive_resource, rational, sha256_json, twice_arccos_rational,
    twice_arccos_sqrt_rational,
)
from tools.executable_manifest import default_executable_policy
from tools.executable_runner import run_policy, write_artifacts


N = 8
ALPHA = Fraction(56, 3)
M = (
    (-30, 32, -2, 0, 0, 0, 0, 0),
    (16, -31, 16, -1, 0, 0, 0, 0),
    (-1, 16, -30, 16, -1, 0, 0, 0),
    (0, -1, 16, -30, 16, -1, 0, 0),
    (0, 0, -1, 16, -30, 16, -1, 0),
    (0, 0, 0, -1, 16, -30, 16, -1),
    (0, 0, 0, 0, -1, 16, -31, 16),
    (0, 0, 0, 0, 0, -2, 32, -30),
)


def five_perm(slot: int, column: int) -> int:
    return (column + (0, -1, 1, -2, 2)[slot]) % N


def five_weight(slot: int, column: int) -> int:
    if slot == 0:
        return -31 if column in (1, 6) else -30
    if slot == 1:
        return 0 if column == 0 else 32 if column == 1 else 16
    if slot == 2:
        return 0 if column == 7 else 32 if column == 6 else 16
    if slot == 3:
        return 0 if column < 2 else -2 if column == 2 else -1
    return 0 if column >= 6 else -2 if column == 5 else -1


def eight_perm(slot: int, column: int) -> int:
    if slot < 2:
        return column
    if slot < 6:
        return (column + (-1, 1, -2, 2)[slot - 2]) % N
    swaps = ({0: 1, 1: 0, 6: 7, 7: 6}, {0: 2, 2: 0, 5: 7, 7: 5})
    return swaps[slot - 6].get(column, column)


def eight_weight(slot: int, column: int) -> int:
    if slot == 0:
        return -15
    if slot == 1:
        return -16 if column in (1, 6) else -15
    if slot == 2:
        return 0 if column == 0 else 16
    if slot == 3:
        return 0 if column == 7 else 16
    if slot == 4:
        return 0 if column < 2 else -1
    if slot == 5:
        return -1 if column <= 5 else 0
    if slot == 6:
        return 16 if column in (1, 6) else 0
    return -1 if column in (2, 5) else 0


def exact_decomposition(slots: int, perm, weight) -> list[list[Fraction]]:
    matrix = [[Fraction(0) for _ in range(N)] for _ in range(N)]
    for column in range(N):
        for slot in range(slots):
            matrix[perm(slot, column)][column] += Fraction(weight(slot, column), 224)
    expected = [[Fraction(M[row][column], 224) for column in range(N)] for row in range(N)]
    if matrix != expected:
        raise AssertionError(f"{slots}-slot exact decomposition differs from M/224")
    return matrix


def selector_prepare(slots: int) -> np.ndarray:
    if slots == 8:
        hadamard = np.array([[1, 1], [1, -1]], dtype=float) / np.sqrt(2)
        return np.kron(np.kron(hadamard, hadamard), hadamard)
    target = np.zeros(8)
    target[:slots] = 1 / np.sqrt(slots)
    e0 = np.eye(8)[:, 0]
    delta = e0 - target
    return np.eye(8) - 2 * np.outer(delta, delta) / np.dot(delta, delta)


def full_candidate(slots: int, perm, weight, denominator: int) -> tuple[np.ndarray, np.ndarray]:
    dimension = 8 * 2 * 8
    prepare = selector_prepare(slots)
    prepare_full = np.kron(np.kron(prepare, np.eye(2)), np.eye(8))
    amplitude = np.zeros((dimension, dimension))
    select = np.zeros((dimension, dimension))
    for selector in range(8):
        for coefficient in range(2):
            for system in range(8):
                column = (selector * 2 + coefficient) * 8 + system
                target_system = perm(selector, system) if selector < slots else system
                row = (selector * 2 + coefficient) * 8 + target_system
                select[row, column] = 1
        for system in range(8):
            c = weight(selector, system) / denominator if selector < slots else 1.0
            s = np.sqrt(max(0.0, 1.0 - c * c))
            rotation = np.array([[c, -s], [s, c]])
            for out_coeff in range(2):
                for in_coeff in range(2):
                    row = (selector * 2 + out_coeff) * 8 + system
                    column = (selector * 2 + in_coeff) * 8 + system
                    amplitude[row, column] = rotation[out_coeff, in_coeff]
    unitary = prepare_full.T @ select @ amplitude @ prepare_full
    clean = unitary[np.arange(8), :][:, np.arange(8)]
    return unitary, clean


def candidate_result(
    name: str,
    slots: int,
    perm,
    weight,
    denominator: int,
    root: str,
    logical_unitary_root: str | None = None,
    verified_block_root: str | None = None,
) -> dict:
    exact_decomposition(slots, perm, weight)
    unitary, clean = full_candidate(slots, perm, weight, denominator)
    target = np.asarray(M, dtype=float) / 224.0
    identity_error = float(np.linalg.norm(unitary.T @ unitary - np.eye(unitary.shape[0]), ord=2))
    entry_error = float(np.max(np.abs(clean - target)))
    operator_error = float(np.linalg.norm(clean - target, ord=2))
    circuit = QuantumCircuit(7, name=name)
    circuit.unitary(unitary, range(7), label=f"legacy-dense-diagnostic-{name}")
    qiskit_operator_error = float(np.linalg.norm(Operator(circuit).data - unitary, ord=2))
    if identity_error > 1e-12 or entry_error > 1e-12 or qiskit_operator_error > 1e-12:
        raise AssertionError(f"{name} executable check failed")
    return {
        "identity": name,
        "leanRoot": root,
        "leanLogicalUnitaryRoot": logical_unitary_root,
        "leanVerifiedBlockEncodingRoot": verified_block_root,
        "leanSemanticTier": (
            "T2 exact logical-unitary block encoding"
            if verified_block_root
            else "T1 exact finite structural LCU"
        ),
        "executableSemanticTier": "legacyDenseDiagnostic",
        "primitive": False,
        "t3": False,
        "selectorSlots": slots,
        "qiskitPrimitiveResource": None,
        "unitaryError": identity_error,
        "cleanBlockMaxEntryError": entry_error,
        "cleanBlockOperatorNormError": operator_error,
        "qiskitOperatorError": qiskit_operator_error,
        "qiskitVersion": qiskit.__version__,
        "basisPermutationChecks": slots * N,
        "promotionBlockedBy": (
            "primitive circuit refinement"
            if verified_block_root
            else "Robin-specific clean-block promotion and primitive circuit refinement"
        ),
    }


def write_json(path: Path, payload: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def symmetry_xor_weight(sector: int, slot: int, column: int) -> int:
    row = column ^ slot
    reflected = 7 - column
    return M[row][column] + (1 if sector == 0 else -1) * M[row][reflected]


def robin_xor_four_slot_ir(commit: str) -> CircuitIR:
    amplitude_angles = {}
    for flat in range(32):
        bits = tuple((flat >> wire) & 1 for wire in range(5))
        pair = bits[0] + 2 * bits[1]
        sector = bits[2]
        slot = bits[3] + 2 * bits[4]
        amplitude_angles[bits] = twice_arccos_rational(
            symmetry_xor_weight(sector, slot, pair), 56
        )
    instructions: list[dict[str, object]] = [
        {"op": "cx", "control": 2, "target": 1},
        {"op": "cx", "control": 2, "target": 0},
        {"op": "ry", "target": 2, "angle": pi_rational(-1, 2)},
        {"op": "ry", "target": 3, "angle": pi_rational(1, 2)},
        {"op": "ry", "target": 4, "angle": pi_rational(1, 2)},
    ]
    instructions.extend(
        compile_uniformly_controlled_ry((0, 1, 2, 3, 4), 5, amplitude_angles)
    )
    instructions.extend([
        {"op": "cx", "control": 3, "target": 0},
        {"op": "cx", "control": 4, "target": 1},
        {"op": "ry", "target": 4, "angle": pi_rational(-1, 2)},
        {"op": "ry", "target": 3, "angle": pi_rational(-1, 2)},
        {"op": "ry", "target": 2, "angle": pi_rational(1, 2)},
        {"op": "cx", "control": 2, "target": 1},
        {"op": "cx", "control": 2, "target": 0},
    ])
    target_payload = {
        "matrix": M, "operator": "A=M/12", "normalizer": "56/3",
        "cleanBlock": "M/224",
    }
    return CircuitIR(
        qubit_count=6,
        registers=(
            {"name": "system", "qubits": [0, 1, 2]},
            {"name": "selector", "qubits": [3, 4]},
            {"name": "coefficient", "qubits": [5]},
        ),
        instructions=tuple(instructions),
        source_commit=commit,
        lean_roots=(
            "QuantumBlockEncoding.Robin.warmRobinXorFourSlotPrimitive_eval_eq_flatUnitary",
            "QuantumBlockEncoding.Robin.warmRobinXorFourSlotPrimitive_cleanBlock",
            "QuantumBlockEncoding.Robin.warmRobinXorFourSlotPrimitiveVerifiedBlockEncoding",
        ),
        target_digest=sha256_json(target_payload),
        global_phase=rational(0),
        metadata={
            "artifact": "warm-robin-xor-four-slot-t3",
            "target": target_payload,
            "chronology": "matches SymmetryXorFourSlotPrimitive.lean",
        },
    )


def _dagger(instructions: list[dict[str, object]]) -> list[dict[str, object]]:
    result: list[dict[str, object]] = []
    for gate in reversed(instructions):
        copied = dict(gate)
        if copied["op"] in {"ry", "rz"}:
            copied["angle"] = angle_neg(copied["angle"])  # type: ignore[arg-type]
        result.append(copied)
    return result


def _ccx(control0: int, control1: int, target: int) -> list[dict[str, object]]:
    """Exact chronology of Lean's primitiveCCXProgram."""
    h = lambda: [
        {"op": "rz", "target": target, "angle": pi_rational(1)},
        {"op": "ry", "target": target, "angle": pi_rational(1, 2)},
    ]
    return h() + [
        {"op": "cx", "control": control1, "target": target},
        {"op": "rz", "target": target, "angle": pi_rational(-1, 4)},
        {"op": "cx", "control": control0, "target": target},
        {"op": "rz", "target": target, "angle": pi_rational(1, 4)},
        {"op": "cx", "control": control1, "target": target},
        {"op": "rz", "target": target, "angle": pi_rational(-1, 4)},
        {"op": "cx", "control": control0, "target": target},
        {"op": "rz", "target": control1, "angle": pi_rational(1, 4)},
        {"op": "rz", "target": target, "angle": pi_rational(1, 4)},
        {"op": "cx", "control": control0, "target": control1},
        {"op": "rz", "target": control0, "angle": pi_rational(1, 4)},
        {"op": "rz", "target": control1, "angle": pi_rational(-1, 4)},
        {"op": "cx", "control": control0, "target": control1},
    ] + h()


def _compile_reversible(
    program: list[tuple[str, int, int | None, int | None]],
) -> tuple[list[dict[str, object]], Fraction]:
    instructions: list[dict[str, object]] = []
    ccx_count = 0
    for operation, first, second, third in program:
        if operation == "x":
            instructions.append({"op": "x", "target": first})
        elif operation == "cx":
            instructions.append({"op": "cx", "control": first, "target": second})
        elif operation == "ccx":
            instructions.extend(_ccx(first, int(second), int(third)))
            ccx_count += 1
        else:
            raise ValueError(f"unsupported reversible operation {operation}")
    # Each exact CCX macro carries two H phases plus its T/Tdg phase sum.
    return instructions, Fraction(9 * ccx_count, 8)


def _uniform_seven_prepare(wires: tuple[int, int, int]) -> list[dict[str, object]]:
    low, middle, high = wires
    middle_angles = {
        (0,): pi_rational(1, 2),
        (1,): twice_arccos_sqrt_rational(2, 3),
    }
    low_angles = {
        (low_bit, middle_bit):
            rational(0) if low_bit == 1 and middle_bit == 1 else pi_rational(1, 2)
        for low_bit in (0, 1) for middle_bit in (0, 1)
    }
    return (
        [{"op": "ry", "target": high,
          "angle": twice_arccos_sqrt_rational(4, 7)}]
        + compile_uniformly_controlled_ry((high,), middle, middle_angles)
        + compile_uniformly_controlled_ry((middle, high), low, low_angles)
    )


def _source_dt_row(slot: int, column: int) -> int:
    return (column + (slot ^ 3)) % N


def _source_coefficient(slot: int, column: int) -> Fraction:
    if slot == 7:
        return Fraction(1)
    return Fraction(M[_source_dt_row(slot, column)][column], 32)


def robin_paper_seven_ir(commit: str) -> CircuitIR:
    prepare = _uniform_seven_prepare((3, 4, 5))
    amplitude_angles = {
        tuple((flat >> wire) & 1 for wire in range(6)):
            twice_arccos_rational(
                _source_coefficient((flat >> 3) & 7, flat & 7).numerator,
                _source_coefficient((flat >> 3) & 7, flat & 7).denominator,
            )
        for flat in range(64)
    }
    amplitude = compile_uniformly_controlled_ry(tuple(range(6)), 6, amplitude_angles)
    select_reversible = [
        ("x", 3, None, None), ("x", 4, None, None),
        ("ccx", 3, 0, 7), ("ccx", 7, 1, 2), ("ccx", 3, 0, 7),
        ("ccx", 3, 0, 1), ("cx", 3, 0, None),
        ("ccx", 4, 1, 2), ("cx", 4, 1, None), ("cx", 5, 2, None),
        ("x", 3, None, None), ("x", 4, None, None),
    ]
    select, phase = _compile_reversible(select_reversible)
    instructions = prepare + amplitude + select + _dagger(prepare)
    target_payload = {
        "matrix": M, "operator": "A=M/12", "normalizer": "56/3",
        "cleanBlock": "M/224",
    }
    return CircuitIR(
        qubit_count=8,
        registers=(
            {"name": "system", "qubits": [0, 1, 2]},
            {"name": "selector", "qubits": [3, 4, 5]},
            {"name": "coefficient", "qubits": [6]},
            {"name": "adder-workspace", "qubits": [7]},
        ),
        instructions=tuple(instructions), source_commit=commit,
        lean_roots=(
            "QuantumBlockEncoding.Robin.warmRobinPaperSevenPrimitive_eval_eq_logical",
            "QuantumBlockEncoding.Robin.warmRobinPaperSevenPrimitive_cleanBlock",
            "QuantumBlockEncoding.Robin.warmRobinPaperSevenPrimitiveVerifiedBlockEncoding",
        ),
        target_digest=sha256_json(target_payload), global_phase=pi_rational(phase.numerator, phase.denominator),
        metadata={
            "artifact": "warm-robin-paper-seven-t3",
            "target": target_payload,
            "sourceConvention": "true padded-seven sparse source; slot 7 has zero PREPARE probability",
            "wireOrder": "q0-q2 system; q3-q5 selector; q6 coefficient; q7 clean adder workspace",
        },
    )


def _clean_c3x(control0: int, control1: int, control2: int,
                target: int, work: int) -> list[tuple[str, int, int | None, int | None]]:
    return [
        ("ccx", control0, control1, work),
        ("ccx", work, control2, target),
        ("ccx", control0, control1, work),
    ]


def _figure4_indicator() -> list[tuple[str, int, int | None, int | None]]:
    return (
        [("x", 5, None, None)] + _clean_c3x(3, 4, 5, 7, 8)
        + [("x", 5, None, None), ("x", 3, None, None), ("x", 4, None, None)]
        + _clean_c3x(3, 4, 5, 7, 8)
        + [("x", 4, None, None), ("x", 3, None, None)]
    )


def _figure4_dt_access() -> list[tuple[str, int, int | None, int | None]]:
    return [
        ("x", 0, None, None), ("x", 1, None, None),
        ("ccx", 3, 0, 8), ("ccx", 8, 1, 2), ("ccx", 3, 0, 8),
        ("ccx", 3, 0, 1), ("cx", 3, 0, None),
        ("ccx", 4, 1, 2), ("cx", 4, 1, None), ("cx", 5, 2, None),
    ]


def _figure4_d_access() -> list[tuple[str, int, int | None, int | None]]:
    return [
        ("ccx", 0, 1, 2), ("cx", 0, 1, None),
        ("x", 0, None, None), ("x", 2, None, None),
        ("ccx", 3, 0, 8), ("ccx", 8, 1, 2), ("ccx", 3, 0, 8),
        ("ccx", 3, 0, 1), ("cx", 3, 0, None),
        ("ccx", 4, 1, 2), ("cx", 4, 1, None), ("cx", 5, 2, None),
    ]


def robin_figure4_ir(commit: str) -> CircuitIR:
    prepare = _uniform_seven_prepare((0, 1, 2))
    indicator, indicator_phase = _compile_reversible(_figure4_indicator())
    bulk_values = (0, -1, 16, -30, 16, -1, 0, 0)
    bulk_angles = {}
    for flat in range(16):
        bits = tuple((flat >> wire) & 1 for wire in range(4))
        value = Fraction(bulk_values[flat & 7], 32)
        bulk_angles[bits] = (
            twice_arccos_rational(value.numerator, value.denominator)
            if bits[3] == 1 else rational(0)
        )
    bulk = compile_uniformly_controlled_ry((0, 1, 2, 7), 6, bulk_angles)
    boundary_angles = {}
    for flat in range(128):
        bits = tuple((flat >> wire) & 1 for wire in range(7))
        slot = flat & 7
        column = (flat >> 3) & 7
        active = bits[6] == 0 and column not in (3, 4)
        value = Fraction(M[_source_dt_row(slot, column)][column], 32)
        boundary_angles[bits] = (
            twice_arccos_rational(value.numerator, value.denominator)
            if active else rational(0)
        )
    boundary = compile_uniformly_controlled_ry(
        (0, 1, 2, 3, 4, 5, 7), 6, boundary_angles
    )
    dt_access, dt_phase = _compile_reversible(_figure4_dt_access())
    d_access, d_phase = _compile_reversible(_figure4_d_access())
    swap = [
        {"op": "cx", "control": 0, "target": 3},
        {"op": "cx", "control": 3, "target": 0},
        {"op": "cx", "control": 0, "target": 3},
        {"op": "cx", "control": 1, "target": 4},
        {"op": "cx", "control": 4, "target": 1},
        {"op": "cx", "control": 1, "target": 4},
        {"op": "cx", "control": 2, "target": 5},
        {"op": "cx", "control": 5, "target": 2},
        {"op": "cx", "control": 2, "target": 5},
    ]
    instructions = (
        prepare + indicator + bulk + boundary + dt_access + _dagger(indicator)
        + swap + _dagger(d_access) + _dagger(prepare)
    )
    phase = indicator_phase + dt_phase - indicator_phase - d_phase
    target_payload = {
        "matrix": M, "operator": "A=M/12", "normalizer": "56/3",
        "cleanBlock": "M/224",
    }
    return CircuitIR(
        qubit_count=9,
        registers=(
            {"name": "address", "qubits": [0, 1, 2]},
            {"name": "system", "qubits": [3, 4, 5]},
            {"name": "coefficient", "qubits": [6]},
            {"name": "dt-bulk-indicator", "qubits": [7]},
            {"name": "reversible-workspace", "qubits": [8]},
        ),
        instructions=tuple(instructions), source_commit=commit,
        lean_roots=(
            "QuantumBlockEncoding.Robin.warmRobinFigure4Primitive_eval_eq_logical",
            "QuantumBlockEncoding.Robin.warmRobinFigure4PrimitiveCircuit_cleanBlock",
            "QuantumBlockEncoding.Robin.warmRobinFigure4PrimitiveVerifiedBlockEncoding",
        ),
        target_digest=sha256_json(target_payload), global_phase=pi_rational(phase.numerator, phase.denominator),
        metadata={
            "artifact": "warm-robin-figure4-fixed-n8-t3",
            "target": target_payload,
            "sourceConvention": "fixed-N8, f=1, standard-RY-corrected Figure-4 realization",
            "wireOrder": "q0-q2 address; q3-q5 system; q6 coefficient; q7 D-transpose bulk indicator; q8 clean workspace",
        },
    )
def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--task", default="QBE-ROBIN-BE-WARM-001")
    parser.add_argument("--arm", choices=("warm",), default="warm")
    args = parser.parse_args()
    commit = subprocess.run(["git", "rev-parse", "HEAD"], cwd=ROOT, check=True, capture_output=True, text=True).stdout.strip()
    clean_target = np.asarray(M, dtype=float) / 224.0
    policy = default_executable_policy()
    policy["intermediateCheck"]["backend"] = "both"
    policy["exports"]["formats"] = [
        "canonicalIrJson", "qiskitPython", "openqasm3", "metricsJson",
        "circuitText",
    ]
    export_root = ROOT / "executable-exports" / args.task
    artifact_specs = (
        (
            "xorFourSlot", robin_xor_four_slot_ir(commit), export_root,
            (0, 1, 2), (3, 4, 5),
        ),
        (
            "paperSeven", robin_paper_seven_ir(commit), export_root / "paper-seven",
            (0, 1, 2), (3, 4, 5, 6, 7),
        ),
        (
            "figure4FixedN8", robin_figure4_ir(commit), export_root / "figure4-fixed-n8",
            (3, 4, 5), (0, 1, 2, 6, 7, 8),
        ),
    )
    artifact_reports: dict[str, dict[str, object]] = {}
    for identity, primitive_ir, artifact_root, system_qubits, clean_qubits in artifact_specs:
        executable_report = run_policy(
            primitive_ir, policy, target=clean_target,
            system_qubits=system_qubits, clean_qubits=clean_qubits,
        )
        if executable_report["status"] != "passed":
            raise AssertionError(
                f"Robin {identity} primitive backend gate failed: {executable_report}"
            )
        written = write_artifacts(
            artifact_root, primitive_ir, policy, executable_report
        )
        artifact_reports[identity] = {
            "identity": primitive_ir.metadata["artifact"],
            "leanRoots": list(primitive_ir.lean_roots),
            "sourceConvention": primitive_ir.metadata.get("sourceConvention"),
            "wireOrder": primitive_ir.metadata.get("wireOrder"),
            "globalPhase": primitive_ir.global_phase,
            "primitiveResource": primitive_resource(primitive_ir.instructions),
            "circuitDigest": primitive_ir.circuit_digest,
            "targetDigest": primitive_ir.target_digest,
            "artifactRoot": str(artifact_root.relative_to(ROOT)),
            "writtenArtifacts": written,
            "checkBackends": executable_report["reports"],
        }
    candidates = [
        candidate_result("five-shift-weighted-permutation", 5, five_perm, five_weight, 224 / 5, "QuantumBlockEncoding.Robin.warmRobinFiveShiftCleanFormula_eq_target"),
        candidate_result(
            "hadamard-eight-weighted-permutation",
            8,
            eight_perm,
            eight_weight,
            28,
            "QuantumBlockEncoding.Robin.warmRobinHadamard8CleanFormula_eq_target",
            "QuantumBlockEncoding.Robin.warmRobinHadamard8LogicalUnitary_unitary",
            "QuantumBlockEncoding.Robin.warmRobinHadamard8VerifiedBlockEncoding",
        ),
    ]
    baseline = {
        "identity": "fixed-N8-f1-standard-Ry-corrected-Figure-4",
        "status": "complete",
        "leanSemanticTier": "T3 exact primitive verified block encoding",
        "resource": artifact_reports["figure4FixedN8"]["primitiveResource"],
        "leanRoot": "QuantumBlockEncoding.Robin.warmRobinFigure4PrimitiveVerifiedBlockEncoding",
        "blockedContracts": [],
    }
    comparison = {
        "task": args.task,
        "alpha": "56/3",
        "target": "A=M/12; A/alpha=M/224",
        "semanticTierCompatible": True,
        "conclusion": "XOR four-slot is strictly better than both formalized source realizations under the declared exact primitive compiler",
        "leanRoots": [
            "QuantumBlockEncoding.Robin.warmRobinFourSlotT3Cost_betterThan_paperSeven",
            "QuantumBlockEncoding.Robin.warmRobinFourSlotT3Cost_betterThan_figure4",
        ],
        "paperSeven": {"identity": "paper-seven", "cost": [312, 266, 5, 0]},
        "figure4": {"identity": "fixed-N8-Figure-4", "cost": [881, 674, 6, 0]},
        "candidate": {"identity": "XOR-four-slot", "cost": [106, 96, 3, 0]},
        "reason": "the candidate has fewer gates, the first lexicographic score field",
        "t3PrimitiveComparisonCertified": True,
    }
    result_root = ROOT / "experiments" / "robin-be" / "results"
    write_json(result_root / "baseline.json", baseline)
    write_json(result_root / "candidates.json", {"candidates": candidates})
    write_json(result_root / "comparison.json", comparison)
    xor_report = artifact_reports["xorFourSlot"]
    manifest = {
        "schemaVersion": 2,
        "task": args.task,
        "sourceCommit": commit,
        "registerOrder": "q0-q2 system, q3-q4 selector, q5 coefficient; flat = system + 8*selector + 32*coefficient",
        "systemQubits": 3,
        "cleanQubits": {"selector": 0, "coefficient": 0},
        "alpha": "56/3",
        "conventionVersion": "robin-fixed-n3-xor-t3-v1",
        "certifiedExecutable": True,
        "leanSemanticTier": "T3 exact primitive XOR four-slot block encoding",
        "leanRefinementRoot": "QuantumBlockEncoding.Robin.warmRobinXorFourSlotPrimitive_eval_eq_flatUnitary",
        "primitiveBasis": ["x", "ry", "rz", "cx"],
        "connectivity": "all-to-all",
        "globalPhasePolicy": "exp-plus-i-phase-shared-with-lean-qiskit-openqasm",
        "checkBackends": xor_report["checkBackends"],
        "t3PrerequisiteRoots": [
            "QuantumBlockEncoding.Robin.warmRobinXorFourSlotAmplitudeProgram_eval",
            "QuantumBlockEncoding.Robin.warmRobinXorFourSlotPrimitiveMiddle_eval",
            "QuantumBlockEncoding.Robin.warmRobinXorFourSlotPrimitivePair_eval"
        ],
        "remainingT3Root": None,
        "verifiedBlockEncodingRoot": "QuantumBlockEncoding.Robin.warmRobinXorFourSlotPrimitiveVerifiedBlockEncoding",
        "primitiveResource": xor_report["primitiveResource"],
        "circuitDigest": xor_report["circuitDigest"],
        "writtenArtifacts": xor_report["writtenArtifacts"],
        "artifacts": artifact_reports,
        "paperLevelWinnerCertified": True,
        "paperLevelWinnerRoot": "QuantumBlockEncoding.Robin.warmRobinBestVerified",
        "sameTierComparisonRoots": comparison["leanRoots"],
        "paperLevelComparisonBlockedBy": [],
        "candidates": candidates,
    }
    write_json(export_root / "manifest.json", manifest)
    print(json.dumps({
        "passed": True,
        "highestTier": "T3-exact-primitive-same-tier-comparison",
        "certifiedExecutable": True,
        "artifacts": {
            identity: {
                "qiskitFullOperatorError": report["checkBackends"]["qiskitOperator"]["fullOperatorError"],
                "openqasmCanonicalRoundTrip": report["checkBackends"]["openqasm3RoundTrip"]["canonicalRoundTrip"],
                "resource": report["primitiveResource"],
            }
            for identity, report in artifact_reports.items()
        },
        "paperLevelWinnerCertified": True,
    }))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
