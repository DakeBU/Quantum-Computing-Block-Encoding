#!/usr/bin/env python3
"""Qiskit export for the Lean-certified QBE-OP-OPTCTRL-001 champion.

This is the concrete `r = 1, k = 1` transfer-operator instance certified in
Lean as `OptimalControl.evolvedEqFlipVerified`.  The Qiskit check is an
engineering export check: it verifies that this finite Python circuit has the
same clean block as the Lean-certified concrete matrix.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass

import numpy as np
from qiskit import QuantumCircuit
from qiskit.quantum_info import Operator


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
    passed: bool


def build_circuit() -> QuantumCircuit:
    """Return the four-qubit logical circuit used by the Lean champion.

    Qubit 3 is the block-encoding ancilla in this concrete Qiskit layout.
    The clean block is therefore the top-left 8 by 8 block of the unitary.
    """

    circuit = QuantumCircuit(4, name="abeis_optctrl_evolved_eq_flip")
    circuit.ccx(1, 2, 3)
    circuit.x(1)
    circuit.x(2)
    circuit.x(3)
    return circuit


def target_clean_block() -> np.ndarray:
    """Matrix for E_1 = |0><1|_time tensor |0><1|_type tensor I_state."""

    target = np.zeros((8, 8), dtype=np.complex128)
    target[0, 6] = 1.0
    target[1, 7] = 1.0
    return target


def check_export(atol: float) -> ExportResult:
    circuit = build_circuit()
    matrix = np.asarray(Operator(circuit).data, dtype=np.complex128)
    clean = matrix[:8, :8]
    ident = np.eye(matrix.shape[0], dtype=np.complex128)
    clean_error = float(np.linalg.norm(clean - target_clean_block(), ord=2))
    unitary_error = float(np.linalg.norm(matrix.conj().T @ matrix - ident, ord=2))
    return ExportResult(
        task_id="QBE-OP-OPTCTRL-001",
        semantic_tier="Lean-certified exact finite instance",
        lean_certificate="QuantumBlockEncoding.OptimalControl.evolvedEqFlipVerified",
        qiskit_qubits=4,
        gate_count=4,
        qiskit_depth=int(circuit.depth()),
        auxiliary_qubits=1,
        oracle_calls=0,
        clean_block_error=clean_error,
        unitary_error=unitary_error,
        passed=clean_error <= atol and unitary_error <= atol,
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--atol", type=float, default=1e-12)
    parser.add_argument("--json", action="store_true", help="print machine-readable result")
    args = parser.parse_args()

    result = check_export(args.atol)
    if args.json:
        print(json.dumps(asdict(result), indent=2))
    else:
        status = "passed" if result.passed else "failed"
        print(f"{result.task_id} Qiskit export {status}")
        print(f"clean_block_error={result.clean_block_error:.3e}")
        print(f"unitary_error={result.unitary_error:.3e}")
        print(f"resource=(gates={result.gate_count}, depth={result.qiskit_depth}, aux={result.auxiliary_qubits})")
    if not result.passed:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
