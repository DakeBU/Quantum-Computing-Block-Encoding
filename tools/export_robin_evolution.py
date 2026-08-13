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


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--task", default="QBE-ROBIN-BE-WARM-001")
    parser.add_argument("--arm", choices=("warm",), default="warm")
    args = parser.parse_args()
    commit = subprocess.run(["git", "rev-parse", "HEAD"], cwd=ROOT, check=True, capture_output=True, text=True).stdout.strip()
    primitive_ir = robin_xor_four_slot_ir(commit)
    clean_target = np.asarray(M, dtype=float) / 224.0
    policy = default_executable_policy()
    policy["intermediateCheck"]["backend"] = "both"
    policy["exports"]["formats"] = [
        "canonicalIrJson", "qiskitPython", "openqasm3", "metricsJson",
        "circuitText",
    ]
    executable_report = run_policy(
        primitive_ir, policy, target=clean_target,
        system_qubits=(0, 1, 2), clean_qubits=(3, 4, 5),
    )
    if executable_report["status"] != "passed":
        raise AssertionError(f"Robin primitive backend gate failed: {executable_report}")
    export_root = ROOT / "executable-exports" / args.task
    written_artifacts = write_artifacts(
        export_root, primitive_ir, policy, executable_report
    )
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
        "identity": "source-standard-Ry-fixed-N8",
        "status": "partial",
        "leanSemanticTier": "T1 paper transcript and local finite contracts",
        "resource": None,
        "blockedContracts": [
            "source amplitude and sparse-access unitary semantics",
            "transported post-SWAP cleanup",
            "whole-circuit clean-block theorem",
            "common primitive expansion",
        ],
    }
    comparison = {
        "task": args.task,
        "alpha": "56/3",
        "target": "A=M/12; A/alpha=M/224",
        "semanticTierCompatible": True,
        "conclusion": "four-slot strictly better than Hadamard-8 at T2",
        "leanRoot": "QuantumBlockEncoding.Robin.warmRobinFourSlotT2Cost_betterThan_hadamard8",
        "baseline": {"identity": "hadamard-eight", "cost": [8, 4, 4, 2]},
        "candidate": {"identity": "symmetry-four-slot", "cost": [8, 4, 3, 2]},
        "reason": "gate count and depth tie; four-slot uses one fewer auxiliary qubit",
        "t3PrimitiveComparisonCertified": False,
    }
    result_root = ROOT / "experiments" / "robin-be" / "results"
    write_json(result_root / "baseline.json", baseline)
    write_json(result_root / "candidates.json", {"candidates": candidates})
    write_json(result_root / "comparison.json", comparison)
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
        "checkBackends": executable_report["reports"],
        "t3PrerequisiteRoots": [
            "QuantumBlockEncoding.Robin.warmRobinXorFourSlotAmplitudeProgram_eval",
            "QuantumBlockEncoding.Robin.warmRobinXorFourSlotPrimitiveMiddle_eval",
            "QuantumBlockEncoding.Robin.warmRobinXorFourSlotPrimitivePair_eval"
        ],
        "remainingT3Root": None,
        "verifiedBlockEncodingRoot": "QuantumBlockEncoding.Robin.warmRobinXorFourSlotPrimitiveVerifiedBlockEncoding",
        "primitiveResource": primitive_resource(primitive_ir.instructions),
        "circuitDigest": primitive_ir.circuit_digest,
        "writtenArtifacts": written_artifacts,
        "paperLevelWinnerCertified": False,
        "paperLevelComparisonBlockedBy": [
            "paper-seven T3 primitive root",
            "fixed-N Figure-4 T3 primitive root",
            "same-tier T3 comparison",
        ],
        "candidates": candidates,
    }
    write_json(export_root / "manifest.json", manifest)
    qiskit_report = executable_report["reports"]["qiskitOperator"]
    qasm_report = executable_report["reports"]["openqasm3RoundTrip"]
    print(json.dumps({
        "passed": True,
        "highestTier": "T3-exact-primitive-xor-four-slot",
        "certifiedExecutable": True,
        "qiskitFullOperatorError": qiskit_report["fullOperatorError"],
        "openqasmCanonicalRoundTrip": qasm_report["canonicalRoundTrip"],
        "paperLevelWinnerCertified": False,
    }))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
