#!/usr/bin/env python3
"""Executable mirrors for the representative state-preparation teaching cases.

These circuits are numerical debugging/inspection artifacts.  Their angles and
wire order mirror the proof-bearing Lean primitive routes; Lean remains the
exact proof authority.
"""

from __future__ import annotations

import argparse
import json
import math

from qiskit import QuantumCircuit
from qiskit.quantum_info import Statevector


def ucry_one_control(qc: QuantumCircuit, control: int, target: int, angle0: float, angle1: float) -> None:
    """One-control RY multiplexor matching the reference Lean UCRY decomposition."""
    qc.ry((angle0 + angle1) / 2.0, target)
    qc.cx(control, target)
    qc.ry((angle0 - angle1) / 2.0, target)
    qc.cx(control, target)


def bell() -> QuantumCircuit:
    """Proof-route mirror: RY(pi/2) followed by CX prepares (|00>+|11>)/sqrt(2)."""
    qc = QuantumCircuit(2)
    qc.ry(math.pi / 2.0, 0)
    qc.cx(0, 1)
    return qc


def mottonen_dense() -> QuantumCircuit:
    """Exact Lean target amplitudes (39,52,60,144)/169."""
    qc = QuantumCircuit(2)
    theta_root = 2.0 * math.atan2(12.0, 5.0)
    theta0 = 2.0 * math.atan2(4.0, 3.0)
    theta1 = 2.0 * math.atan2(12.0, 5.0)
    qc.ry(theta_root, 1)
    ucry_one_control(qc, 1, 0, theta0, theta1)
    return qc


def grover_rudolph_product() -> QuantumCircuit:
    """Factorized exact target amplitudes (9,12,12,16)/25."""
    qc = QuantumCircuit(2)
    theta = 2.0 * math.atan2(4.0, 3.0)
    qc.ry(theta, 0)
    qc.ry(theta, 1)
    return qc


def sparse_pruned() -> QuantumCircuit:
    """Pruned exact target amplitudes 3/13,4/13,12/13 on indices 0,2,4."""
    qc = QuantumCircuit(3)
    theta_root = 2.0 * math.atan2(12.0, 5.0)
    theta_q2_zero = 2.0 * math.atan2(4.0, 3.0)
    qc.ry(theta_root, 2)
    ucry_one_control(qc, 2, 1, theta_q2_zero, 0.0)
    return qc


BUILDERS = {
    "bell": bell,
    "mottonen": mottonen_dense,
    "grover-rudolph": grover_rudolph_product,
    "sparse": sparse_pruned,
}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--case", choices=sorted(BUILDERS), required=True)
    args = parser.parse_args()
    circuit = BUILDERS[args.case]()
    state = Statevector.from_instruction(circuit)
    payload = {
        "case": args.case,
        "qubits": circuit.num_qubits,
        "depth": circuit.depth(),
        "size": circuit.size(),
        "amplitudes": [[float(value.real), float(value.imag)] for value in state.data],
    }
    print(circuit.draw(output="text"))
    print(json.dumps(payload, indent=2))


if __name__ == "__main__":
    main()
