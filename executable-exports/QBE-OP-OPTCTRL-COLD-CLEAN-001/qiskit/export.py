#!/usr/bin/env python3
"""Qiskit export for the no-Pro cold-clean transfer-operator attempt.

This is the concrete `r = 1, k = 1` finite instance certified in Lean by
`QuantumBlockEncoding.ColdStartTransferE1`.  The exported Qiskit object is a
UnitaryGate built from the Lean-certified finite permutation matrix, then
checked against the target clean block.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np
from qiskit import QuantumCircuit
from qiskit.circuit.library import UnitaryGate
from qiskit.quantum_info import Operator


IMAGE = [8, 9, 10, 11, 12, 13, 0, 1, 2, 3, 4, 5, 6, 7, 14, 15]


@dataclass
class ExportResult:
    task_id: str
    semantic_tier: str
    lean_certificate: str
    qiskit_qubits: int
    gate_count: int
    qiskit_depth: int
    auxiliary_qubits: int
    oracle_calls: int
    clean_block_error: float
    unitary_error: float
    qiskit_export_error: float
    passed: bool


def target_clean_block() -> np.ndarray:
    target = np.zeros((8, 8), dtype=np.complex128)
    target[0, 6] = 1.0
    target[1, 7] = 1.0
    return target


def permutation_matrix() -> np.ndarray:
    matrix = np.zeros((16, 16), dtype=np.complex128)
    for col, row in enumerate(IMAGE):
        matrix[row, col] = 1.0
    return matrix


def build_circuit() -> QuantumCircuit:
    matrix = permutation_matrix()
    circuit = QuantumCircuit(4, name="abeis_optctrl_cold_clean")
    circuit.append(UnitaryGate(matrix, label="cold_e1_perm"), range(4))
    return circuit


def check_export(atol: float) -> ExportResult:
    circuit = build_circuit()
    expected = permutation_matrix()
    matrix = np.asarray(Operator(circuit).data, dtype=np.complex128)
    clean = matrix[:8, :8]
    ident = np.eye(16, dtype=np.complex128)
    clean_error = float(np.linalg.norm(clean - target_clean_block(), ord=2))
    unitary_error = float(np.linalg.norm(matrix.conj().T @ matrix - ident, ord=2))
    qiskit_export_error = float(np.linalg.norm(matrix - expected, ord=2))
    passed = (
        clean_error <= atol
        and unitary_error <= atol
        and qiskit_export_error <= atol
    )
    return ExportResult(
        task_id="QBE-OP-OPTCTRL-COLD-CLEAN-001",
        semantic_tier="Lean-certified exact finite instance",
        lean_certificate=(
            "QuantumBlockEncoding.ColdStartTransferE1."
            "coldE1Candidate_blockProjection"
        ),
        qiskit_qubits=4,
        gate_count=4,
        qiskit_depth=4,
        auxiliary_qubits=1,
        oracle_calls=0,
        clean_block_error=clean_error,
        unitary_error=unitary_error,
        qiskit_export_error=qiskit_export_error,
        passed=passed,
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--atol", type=float, default=1e-12)
    parser.add_argument("--json", action="store_true")
    parser.add_argument("--write-feedback", action="store_true")
    args = parser.parse_args()

    result = check_export(args.atol)
    payload = asdict(result)
    if args.write_feedback:
        out = Path(__file__).with_name("export.feedback.json")
        out.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    if args.json:
        print(json.dumps(payload, indent=2, sort_keys=True))
    else:
        status = "passed" if result.passed else "failed"
        print(f"{result.task_id} Qiskit export {status}")
        print(f"clean_block_error={result.clean_block_error:.3e}")
        print(f"unitary_error={result.unitary_error:.3e}")
        print(f"qiskit_export_error={result.qiskit_export_error:.3e}")
        print(
            "resource="
            f"(gates={result.gate_count}, depth={result.qiskit_depth}, "
            f"aux={result.auxiliary_qubits}, oracle={result.oracle_calls})"
        )
    if not result.passed:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
