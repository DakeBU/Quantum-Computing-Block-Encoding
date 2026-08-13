#!/usr/bin/env python3
"""Export the two textbook state-preparation circuits to Qiskit.

The corresponding state-action and unitarity claims are proved in Lean.  This
file is a user-facing circuit export; it is deliberately not an acceptance
test based on floating-point amplitudes.
"""

from __future__ import annotations

import argparse
import json

from qiskit import QuantumCircuit, qasm3


LEAN_ROOTS = {
    "pauli-x": "QuantumBlockEncoding.TextbookStatePreparation.pauliXCertificate_prepares_one",
    "hadamard": "QuantumBlockEncoding.TextbookStatePreparation.hadamardCertificate_prepares_plus",
}


def build(case: str) -> QuantumCircuit:
    circuit = QuantumCircuit(1, name=case)
    if case == "pauli-x":
        circuit.x(0)
    else:
        circuit.h(0)
    return circuit


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--case", choices=tuple(LEAN_ROOTS), default="hadamard")
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args()
    circuit = build(args.case)
    payload = {
        "case": args.case,
        "leanCertificate": LEAN_ROOTS[args.case],
        "qiskitRole": "executable export, not proof acceptance",
        "qasm3": qasm3.dumps(circuit),
    }
    if args.json:
        print(json.dumps(payload, indent=2))
    else:
        print(circuit.draw(output="text"))
        print(payload["qasm3"])
        print(f"Lean certificate: {payload['leanCertificate']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
