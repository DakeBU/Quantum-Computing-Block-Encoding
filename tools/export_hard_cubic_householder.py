#!/usr/bin/env python3
"""Export the Lean-certified rational Householder hard cases to Qiskit/QASM3."""

from __future__ import annotations

import argparse
import json
import math
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np
import openqasm3
import qiskit
from qiskit import QuantumCircuit, qasm3, transpile
from qiskit.circuit.library import UnitaryGate
from qiskit.quantum_info import Operator


ROOT = Path(__file__).resolve().parents[1]
COLD_TASK = "QBE-HARD-CUBIC-DIAGONAL-HIER-COLD-001"
HINTED_TASK = "QBE-HARD-CUBIC-DIAGONAL-HIER-HINTED-001"


@dataclass(frozen=True)
class RouteResult:
    name: str
    lean_anchor: str
    power: int
    qiskit_qubits: int
    auxiliary_qubits: int
    exact_four_square_witnesses: bool
    clean_block_error: float
    unitary_error: float
    qiskit_operator_error: float
    qasm_operator_error: float
    qasm_parse_ok: bool
    qasm_gate_count: int
    qasm_depth: int
    qasm_path: str
    passed: bool


def four_squares(value: int) -> tuple[int, int, int, int]:
    """Return a deterministic Lagrange witness for a small nonnegative integer."""

    if value < 0:
        raise ValueError("four-square residual must be nonnegative")
    limit = math.isqrt(value)
    pairs: dict[int, tuple[int, int]] = {}
    for a in range(limit + 1):
        for b in range(limit + 1):
            total = a * a + b * b
            if total <= value and total not in pairs:
                pairs[total] = (a, b)
    for left in sorted(pairs):
        right = value - left
        if right in pairs:
            a, b = pairs[left]
            c, d = pairs[right]
            return a, b, c, d
    raise RuntimeError(f"no four-square witness found for {value}")


def branch_vector(n: int, j: int, power: int) -> tuple[np.ndarray, bool]:
    N = 1 << n
    denominator = N**power
    residual = denominator * denominator - j ** (2 * power)
    a, b, c, d = four_squares(residual)
    exact = j ** (2 * power) + a * a + b * b + c * c + d * d == denominator * denominator
    vector = np.zeros(8, dtype=np.float64)
    vector[:5] = np.asarray([j**power, a, b, c, d], dtype=np.float64) / float(denominator)
    return vector, exact


def householder(vector: np.ndarray) -> np.ndarray:
    e0 = np.zeros(8, dtype=np.float64)
    e0[0] = 1.0
    delta = e0 - vector
    denominator = float(delta @ delta)
    if denominator == 0.0:
        raise ValueError("the clean coordinate cannot equal one")
    return np.eye(8, dtype=np.float64) - 2.0 * np.outer(delta, delta) / denominator


def controlled_direct_sum(n: int, power: int) -> tuple[np.ndarray, bool]:
    """Match Lean's ancilla-major `productIndex a s = a * N + s`."""

    N = 1 << n
    unitary = np.zeros((8 * N, 8 * N), dtype=np.complex128)
    all_exact = True
    for system in range(N):
        vector, exact = branch_vector(n, system, power)
        all_exact = all_exact and exact
        block = householder(vector)
        for row_ancilla in range(8):
            for col_ancilla in range(8):
                unitary[row_ancilla * N + system, col_ancilla * N + system] = block[
                    row_ancilla, col_ancilla
                ]
    return unitary, all_exact


def target_diagonal(n: int, power: int) -> np.ndarray:
    N = 1 << n
    values = np.asarray([(j / N) ** power for j in range(N)], dtype=np.complex128)
    return np.diag(values)


def export_route(
    *,
    task_id: str,
    n: int,
    power: int,
    name: str,
    lean_anchor: str,
    atol: float,
) -> RouteResult:
    output_root = ROOT / "executable-exports" / task_id
    qasm_dir = output_root / "qasm3"
    qasm_dir.mkdir(parents=True, exist_ok=True)

    unitary, witnesses_exact = controlled_direct_sum(n, power)
    N = 1 << n
    target = target_diagonal(n, power)
    clean = unitary[:N, :N]
    identity = np.eye(8 * N, dtype=np.complex128)
    clean_error = float(np.linalg.norm(clean - target, ord=2))
    unitary_error = float(np.linalg.norm(unitary.conj().T @ unitary - identity, ord=2))

    circuit = QuantumCircuit(n + 3, name=f"abeis_{name}_n{n}")
    circuit.append(UnitaryGate(unitary, label=name), range(n + 3))
    qiskit_matrix = np.asarray(Operator(circuit).data, dtype=np.complex128)
    qiskit_error = float(np.linalg.norm(qiskit_matrix - unitary, ord=2))

    qasm_circuit = transpile(
        circuit,
        basis_gates=["u", "cx"],
        optimization_level=1,
        seed_transpiler=7,
    )
    qasm_matrix = np.asarray(Operator(qasm_circuit).data, dtype=np.complex128)
    qasm_error = float(np.linalg.norm(qasm_matrix - unitary, ord=2))
    qasm_text = qasm3.dumps(qasm_circuit)
    openqasm3.parse(qasm_text)
    qasm_path = qasm_dir / f"{name}_n{n}.qasm3"
    qasm_path.write_text(qasm_text, encoding="utf-8")

    passed = bool(
        witnesses_exact
        and clean_error <= atol
        and unitary_error <= atol
        and qiskit_error <= atol
        and qasm_error <= 1e-9
        and qasm_text.startswith("OPENQASM 3")
    )
    return RouteResult(
        name=name,
        lean_anchor=lean_anchor,
        power=power,
        qiskit_qubits=n + 3,
        auxiliary_qubits=3,
        exact_four_square_witnesses=witnesses_exact,
        clean_block_error=clean_error,
        unitary_error=unitary_error,
        qiskit_operator_error=qiskit_error,
        qasm_operator_error=qasm_error,
        qasm_parse_ok=True,
        qasm_gate_count=qasm_circuit.size(),
        qasm_depth=qasm_circuit.depth(),
        qasm_path=str(qasm_path.relative_to(ROOT)),
        passed=passed,
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--task", choices=(COLD_TASK, HINTED_TASK), required=True)
    parser.add_argument("--n", type=int, default=2)
    parser.add_argument("--atol", type=float, default=1e-10)
    args = parser.parse_args()
    if args.n < 1:
        raise SystemExit("--n must be positive")
    if args.n > 3:
        raise SystemExit("dense executable acceptance is intentionally limited to n <= 3")

    routes: list[RouteResult] = []
    if args.task == HINTED_TASK:
        routes.append(
            export_route(
                task_id=args.task,
                n=args.n,
                power=1,
                name="linear_householder",
                lean_anchor="CubicDiagonalOracle.linearDiagonalHouseholderInputBEContract_complete",
                atol=args.atol,
            )
        )
    routes.append(
        export_route(
            task_id=args.task,
            n=args.n,
            power=3,
            name="cubic_householder",
            lean_anchor="CubicDiagonalOracle.cubicDiagonalHouseholderExactBEContract_complete",
            atol=args.atol,
        )
    )

    N = 1 << args.n
    polynomial_error = float(
        np.linalg.norm(target_diagonal(args.n, 1) @ target_diagonal(args.n, 1) @ target_diagonal(args.n, 1) - target_diagonal(args.n, 3), ord=2)
    )
    passed = all(route.passed for route in routes) and polynomial_error <= args.atol
    output_root = ROOT / "executable-exports" / args.task
    acceptance_path = output_root / "qiskit" / "acceptance.json"
    acceptance_path.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "task_id": args.task,
        "semantic_tier": "finite post-Lean executable validation; symbolic family proof remains Lean",
        "n": args.n,
        "N": N,
        "normalizer": 1,
        "register_order": "system qubits are low-order; three Householder ancillas are high-order",
        "qiskit_version": qiskit.__version__,
        "openqasm3_version": getattr(openqasm3, "__version__", "unknown"),
        "hint_polynomial_identity": "diag(x)^3 = diag(x^3)",
        "hint_polynomial_identity_error": polynomial_error,
        "routes": [asdict(route) for route in routes],
        "passed": passed,
    }
    acceptance_path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(json.dumps(payload, indent=2, sort_keys=True))
    if not passed:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
