#!/usr/bin/env python3
"""Gate-by-gate Qiskit adapter for the canonical ASPBE primitive IR."""

from __future__ import annotations

from typing import Sequence

import numpy as np

from tools.executable_ir import (
    CircuitIR,
    clean_block,
    eval_angle,
    evaluate_ir,
    max_entry_error,
    operator_error,
    unitarity_error,
)


def build_circuit(ir: CircuitIR):
    try:
        import qiskit
        from qiskit import QuantumCircuit
    except ImportError as error:
        raise RuntimeError(f"qiskit unavailable: {error}") from error
    ir.validate()
    circuit = QuantumCircuit(ir.qubit_count)
    phase = eval_angle(ir.global_phase)
    circuit.global_phase = phase
    for instruction in ir.instructions:
        operation = instruction["op"]
        if operation == "x":
            circuit.x(int(instruction["target"]))
        elif operation == "ry":
            circuit.ry(eval_angle(instruction["angle"]), int(instruction["target"]))
        elif operation == "rz":
            circuit.rz(eval_angle(instruction["angle"]), int(instruction["target"]))
        elif operation == "cx":
            circuit.cx(int(instruction["control"]), int(instruction["target"]))
        else:
            raise ValueError(f"Qiskit primitive checker rejects {operation!r}")
    return qiskit, circuit


def verify(
    ir: CircuitIR,
    *,
    target: np.ndarray | None = None,
    system_qubits: Sequence[int] = (),
    clean_qubits: Sequence[int] = (),
) -> dict[str, object]:
    qiskit, circuit = build_circuit(ir)
    from qiskit.quantum_info import Operator

    matrix = np.asarray(Operator(circuit).data, dtype=np.complex128)
    reference = evaluate_ir(ir)
    counts = {str(key): int(value) for key, value in circuit.count_ops().items()}
    result: dict[str, object] = {
        "backend": "qiskitOperator",
        "status": "passed",
        "evidenceClasses": ["numericUnitary"],
        "qiskitVersion": qiskit.__version__,
        "unitarityError": unitarity_error(matrix),
        "fullOperatorError": operator_error(matrix, reference),
        "gateCounts": counts,
        "gateCount": int(sum(counts.values())),
        "depth": int(circuit.depth()),
        "qubitCount": circuit.num_qubits,
        "targetDigest": ir.target_digest,
        "circuitDigest": ir.circuit_digest,
        "globalPhasePolicy": "exact-zero-or-explicitly-corrected",
    }
    if target is not None:
        projected = clean_block(matrix, system_qubits=system_qubits, clean_qubits=clean_qubits)
        result.update(
            {
                "evidenceClasses": ["numericUnitary", "numericCleanBlock"],
                "cleanBlockMaxEntryError": max_entry_error(projected, target),
                "cleanBlockOperatorNormError": operator_error(projected, target),
            }
        )
    return result

