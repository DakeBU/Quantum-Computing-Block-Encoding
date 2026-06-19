#!/usr/bin/env python3
import numpy as np
from qiskit import QuantumCircuit
from qiskit.quantum_info import Operator

def build_circuit():
    qc = QuantumCircuit(4)
    qc.ccx(1, 2, 3)
    qc.x(1)
    qc.x(2)
    qc.x(3)
    return qc

def main():
    data = np.asarray(Operator(build_circuit()).data)
    target = np.zeros((8, 8), dtype=complex)
    target[0, 6] = 1
    target[1, 7] = 1
    if not np.allclose(data[:8, :8], target, atol=1e-12):
        raise SystemExit("clean block does not equal E_1")
    print("reference qiskit clean-block check passed")

if __name__ == "__main__":
    main()
