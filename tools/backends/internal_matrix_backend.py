#!/usr/bin/env python3
"""Project-owned reference evaluator for canonical executable circuits."""

from __future__ import annotations

from typing import Sequence

import numpy as np

from tools.executable_ir import (
    CircuitIR,
    clean_block,
    evaluate_ir,
    max_entry_error,
    operator_error,
    primitive_resource,
    unitarity_error,
)


def verify(
    ir: CircuitIR,
    *,
    target: np.ndarray | None = None,
    system_qubits: Sequence[int] = (),
    clean_qubits: Sequence[int] = (),
) -> dict[str, object]:
    matrix = evaluate_ir(ir)
    result: dict[str, object] = {
        "backend": "internalCanonicalMatrix",
        "status": "passed",
        "evidenceClasses": ["numericUnitary"],
        "unitarityError": unitarity_error(matrix),
        "fullOperatorError": 0.0,
        "qubitCount": ir.qubit_count,
        "circuitDigest": ir.circuit_digest,
        "resource": primitive_resource(ir.instructions),
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

