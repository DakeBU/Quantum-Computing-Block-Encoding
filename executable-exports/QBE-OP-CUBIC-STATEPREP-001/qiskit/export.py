#!/usr/bin/env python3
"""Finite Qiskit export baseline for QBE-OP-CUBIC-STATEPREP-001.

Target for a fixed small `n`:

    O_n = |v_n><0^n|,  (v_n)_j = (j / 2^n)^3.

This script constructs a dense one-auxiliary-qubit unitary whose clean block is
`O_n / alpha`, where `alpha = ||v_n||_2`.  The route is useful as a
fixed-instance executable check and as a correctness seed.  It is not a final
ABEIS result for the symbolic family, because the dense unitary description
scales as `2^(2n)`.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass

import numpy as np
from qiskit import QuantumCircuit
from qiskit.quantum_info import Operator


@dataclass
class CubicExportResult:
    task_id: str
    semantic_tier: str
    n: int
    N: int
    alpha: float
    qiskit_qubits: int
    auxiliary_qubits: int
    dense_unitary_bytes: int
    clean_block_error: float
    unitary_error: float
    passed: bool
    note: str


def cubic_vector(n: int) -> np.ndarray:
    N = 1 << n
    j = np.arange(N, dtype=np.float64)
    return (j / float(N)) ** 3


def gram_schmidt_complete(seed_columns: list[np.ndarray], dim: int) -> np.ndarray:
    cols: list[np.ndarray] = []
    for col in seed_columns:
        v = col.astype(np.complex128, copy=True)
        for q in cols:
            v -= np.vdot(q, v) * q
        norm = np.linalg.norm(v)
        if norm > 1e-10:
            cols.append(v / norm)

    for idx in range(dim):
        v = np.zeros(dim, dtype=np.complex128)
        v[idx] = 1.0
        for q in cols:
            v -= np.vdot(q, v) * q
        norm = np.linalg.norm(v)
        if norm > 1e-10:
            cols.append(v / norm)
        if len(cols) == dim:
            break

    if len(cols) != dim:
        raise RuntimeError(f"completed {len(cols)} columns, expected {dim}")
    return np.column_stack(cols)


def dense_cubic_block_encoding(n: int) -> tuple[float, np.ndarray]:
    N = 1 << n
    dim = 2 * N
    v = cubic_vector(n)
    alpha = float(np.linalg.norm(v))
    if alpha == 0.0:
        raise RuntimeError("zero target vector")
    normalized = v / alpha

    seed_columns: list[np.ndarray] = []
    first = np.zeros(dim, dtype=np.complex128)
    first[:N] = normalized
    seed_columns.append(first)
    for col_idx in range(1, N):
        col = np.zeros(dim, dtype=np.complex128)
        col[N + col_idx] = 1.0
        seed_columns.append(col)
    return alpha, gram_schmidt_complete(seed_columns, dim)


def target_operator(n: int) -> np.ndarray:
    N = 1 << n
    target = np.zeros((N, N), dtype=np.complex128)
    target[:, 0] = cubic_vector(n)
    return target


def build_circuit(n: int) -> tuple[float, QuantumCircuit]:
    alpha, unitary = dense_cubic_block_encoding(n)
    circuit = QuantumCircuit(n + 1, name=f"abeis_cubic_dense_n{n}")
    circuit.unitary(unitary, list(range(n + 1)), label=f"U_cubic_dense_n{n}")
    return alpha, circuit


def check_export(n: int, atol: float) -> CubicExportResult:
    alpha, circuit = build_circuit(n)
    data = np.asarray(Operator(circuit).data, dtype=np.complex128)
    N = 1 << n
    clean = alpha * data[:N, :N]
    ident = np.eye(2 * N, dtype=np.complex128)
    clean_error = float(np.linalg.norm(clean - target_operator(n), ord=2))
    unitary_error = float(np.linalg.norm(data.conj().T @ data - ident, ord=2))
    passed = clean_error <= atol and unitary_error <= max(atol, 1e-9)
    return CubicExportResult(
        task_id="QBE-OP-CUBIC-STATEPREP-001",
        semantic_tier="fixed-instance dense executable baseline, not symbolic Lean certificate",
        n=n,
        N=N,
        alpha=alpha,
        qiskit_qubits=n + 1,
        auxiliary_qubits=1,
        dense_unitary_bytes=(2 * N) ** 2 * 16,
        clean_block_error=clean_error,
        unitary_error=unitary_error,
        passed=passed,
        note="Use this only as a small-n finite check; ABEIS still needs a symbolic approximate BE family.",
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--n", type=int, default=3, help="system qubits for the finite instance")
    parser.add_argument("--atol", type=float, default=1e-10)
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args()

    if args.n < 1:
        raise SystemExit("--n must be positive")
    result = check_export(args.n, args.atol)
    if args.json:
        print(json.dumps(asdict(result), indent=2))
    else:
        status = "passed" if result.passed else "failed"
        print(f"{result.task_id} Qiskit finite export {status} for n={result.n}")
        print(f"alpha={result.alpha:.16g}")
        print(f"clean_block_error={result.clean_block_error:.3e}")
        print(f"unitary_error={result.unitary_error:.3e}")
        print(f"dense_unitary_bytes={result.dense_unitary_bytes}")
        print(result.note)
    if not result.passed:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
