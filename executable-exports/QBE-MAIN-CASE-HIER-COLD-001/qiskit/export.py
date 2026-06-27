#!/usr/bin/env python3
"""Qiskit export for QBE-MAIN-CASE-HIER-COLD-001.

The Lean certificate is
`QuantumBlockEncoding.MainCase.mainCaseColdPartialPermVerified`.  This file
uses the same concrete wire convention as Lean:

    index = 8 * signal + 4 * T + 2 * tau + S

For Qiskit integer-basis checks the qubit order is therefore
`q[0]=S`, `q[1]=tau`, `q[2]=T`, and `q[3]=signal`.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from typing import Any


TASK_ID = "QBE-MAIN-CASE-HIER-COLD-001"
LEAN_CERTIFICATE = "QuantumBlockEncoding.MainCase.mainCaseColdPartialPermVerified"
LEAN_COST_THEOREM = "QuantumBlockEncoding.MainCase.mainCaseColdPartialPermCandidate_cost"
QUBIT_ORDER = ["S", "tau", "T", "signal"]
RESOURCE_SCORE = {
    "gateCount": 5,
    "depth": 5,
    "auxiliaryQubits": 1,
    "oracleCalls": 0,
}

BASIS_ACTION = [
    14,
    15,
    8,
    9,
    10,
    11,
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    12,
    13,
]


@dataclass(frozen=True)
class ExportCheck:
    task_id: str
    lean_certificate: str
    qiskit_qubits: int
    basis_action_matches_lean: bool
    clean_block_support: list[list[int]]
    clean_block_ok: bool
    passive_s_preserved: bool
    permutation_ok: bool
    normalizer: int
    epsilon: int
    resource_score: dict[str, int]
    passed: bool


def basis_action(index: int) -> int:
    """Return the exported action on Lean/Qiskit integer basis states."""
    if not 0 <= index < len(BASIS_ACTION):
        raise ValueError(f"basis index out of range: {index}")
    return BASIS_ACTION[index]


def apply_transcript(index: int) -> int:
    """Evaluate the five logical reversible gates on one basis index."""
    if not 0 <= index < 16:
        raise ValueError(f"basis index out of range: {index}")

    value = index
    value ^= 1 << 2
    if ((value >> 1) & 1) and ((value >> 2) & 1):
        value ^= 1 << 3
    value ^= 1 << 1
    if (value >> 3) & 1:
        value ^= 1 << 2
    if (value >> 1) & 1:
        value ^= 1 << 3
    return value


def build_circuit() -> Any:
    """Build the Qiskit circuit when Qiskit is installed."""
    try:
        from qiskit import QuantumCircuit
    except ImportError as exc:
        raise RuntimeError("Qiskit is required for build_circuit().") from exc

    circuit = QuantumCircuit(4, name="main_case_cold_partial_perm")
    circuit.x(2)
    circuit.ccx(1, 2, 3)
    circuit.x(1)
    circuit.cx(3, 2)
    circuit.cx(1, 3)
    return circuit


def system_index(t_bit: int, tau_bit: int, s_bit: int) -> int:
    return 4 * t_bit + 2 * tau_bit + s_bit


def target_entry(row: int, col: int) -> int:
    return int(
        (row == system_index(0, 0, 0) and col == system_index(1, 1, 0))
        or (row == system_index(0, 0, 1) and col == system_index(1, 1, 1))
    )


def clean_support() -> set[tuple[int, int]]:
    return {
        (row, col)
        for row in range(8)
        for col in range(8)
        if row == basis_action(col)
    }


def target_support() -> set[tuple[int, int]]:
    return {
        (row, col)
        for row in range(8)
        for col in range(8)
        if target_entry(row, col) == 1
    }


def check_export() -> ExportCheck:
    transcript_action = [apply_transcript(index) for index in range(16)]
    action_matches_lean = transcript_action == BASIS_ACTION
    support = clean_support()
    clean_block_ok = support == target_support()
    passive_s_preserved = all((basis_action(index) % 2) == (index % 2) for index in range(16))
    permutation_ok = sorted(BASIS_ACTION) == list(range(16))
    passed = action_matches_lean and clean_block_ok and passive_s_preserved and permutation_ok
    return ExportCheck(
        task_id=TASK_ID,
        lean_certificate=LEAN_CERTIFICATE,
        qiskit_qubits=4,
        basis_action_matches_lean=action_matches_lean,
        clean_block_support=[list(pair) for pair in sorted(support)],
        clean_block_ok=clean_block_ok,
        passive_s_preserved=passive_s_preserved,
        permutation_ok=permutation_ok,
        normalizer=1,
        epsilon=0,
        resource_score=RESOURCE_SCORE,
        passed=passed,
    )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--json", action="store_true")
    parser.add_argument("--show-circuit", action="store_true")
    args = parser.parse_args()

    result = check_export()
    if args.show_circuit:
        print(build_circuit())
    elif args.json:
        print(json.dumps(asdict(result), indent=2, sort_keys=True))
    else:
        status = "passed" if result.passed else "failed"
        print(f"{TASK_ID} Qiskit export {status}")
        print(f"lean_certificate={result.lean_certificate}")
        print(f"basis_action_matches_lean={result.basis_action_matches_lean}")
        print(f"clean_block_support={result.clean_block_support}")
        print(f"resource=(5,5,1,0)")
    return 0 if result.passed else 1


if __name__ == "__main__":
    raise SystemExit(main())
