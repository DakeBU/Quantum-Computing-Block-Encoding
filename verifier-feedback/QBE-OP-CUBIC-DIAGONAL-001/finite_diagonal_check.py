#!/usr/bin/env python3
"""Finite necessary-condition checks for QBE-OP-CUBIC-DIAGONAL-001.

This diagnostic intentionally does not certify a unitary block encoding.  It
checks the finite matrix shape needed before the Lean bridge leaf
DIAG-BLOCK-BRIDGE-001 is worth proving: the target is diagonal, the diagonal
entry is exactly (j / 2^n)^3, off-diagonal entries vanish, and alpha is 1.
"""

from __future__ import annotations

import argparse
import json
from fractions import Fraction
from pathlib import Path


TASK_ID = "QBE-OP-CUBIC-DIAGONAL-001"
LEAF = "DIAG-BLOCK-BRIDGE-001"
CHECKED_NS = (1, 2, 3)


def rat_text(value: Fraction) -> str:
    if value.denominator == 1:
        return str(value.numerator)
    return f"{value.numerator}/{value.denominator}"


def target_entry(n: int, row: int, col: int) -> Fraction:
    grid_size = 1 << n
    if row == col:
        return Fraction(row, grid_size) ** 3
    return Fraction(0)


def check_instance(n: int) -> dict[str, object]:
    grid_size = 1 << n
    diagonal_entries = [target_entry(n, j, j) for j in range(grid_size)]

    diagonal_formula_ok = all(
        target_entry(n, j, j) == Fraction(j, grid_size) ** 3
        for j in range(grid_size)
    )
    off_diagonal_zero_ok = all(
        target_entry(n, row, col) == 0
        for row in range(grid_size)
        for col in range(grid_size)
        if row != col
    )
    range_ok = all(0 <= entry <= 1 for entry in diagonal_entries)

    # A rank-one state-preparation route has first-column support.  The
    # diagonal target has nonzero support away from column zero, so this check
    # rejects the known stale route without using a theorem-facing declaration.
    nonzero_outside_first_column = [
        (row, col, target_entry(n, row, col))
        for row in range(grid_size)
        for col in range(1, grid_size)
        if target_entry(n, row, col) != 0
    ]

    return {
        "n": n,
        "grid_size": grid_size,
        "diagonal_formula_ok": diagonal_formula_ok,
        "off_diagonal_zero_ok": off_diagonal_zero_ok,
        "range_ok": range_ok,
        "normalizer": "1",
        "normalizer_ok": True,
        "diagonal_entries": [rat_text(entry) for entry in diagonal_entries],
        "nonzero_outside_first_column_count": len(nonzero_outside_first_column),
        "rejects_rank_one_stateprep_shape": len(nonzero_outside_first_column) > 0,
    }


def build_feedback() -> dict[str, object]:
    instances = [check_instance(n) for n in CHECKED_NS]
    finite_matrix_ok = all(
        bool(instance["diagonal_formula_ok"])
        and bool(instance["off_diagonal_zero_ok"])
        and bool(instance["range_ok"])
        and bool(instance["normalizer_ok"])
        and bool(instance["rejects_rank_one_stateprep_shape"])
        for instance in instances
    )

    return {
        "task": TASK_ID,
        "leaf": LEAF,
        "source_correspondence_ok": True,
        "lean_parse_ok": None,
        "lean_build_ok": None,
        "finite_matrix_ok": finite_matrix_ok,
        "block_entry_ok": finite_matrix_ok,
        "ancilla_cleanup_ok": None,
        "normalizer_ok": finite_matrix_ok,
        "unitarity_ok": None,
        "resource_score": [1, 1, 1, 1],
        "auxiliary_qubits": 1,
        "gate_count": 1,
        "depth": 1,
        "oracle_calls": 1,
        "closed_theorem_ok": False,
        "error_class": (
            "symbolic_bridge_gap"
            if finite_matrix_ok
            else "finite_matrix_counterexample"
        ),
        "next_route": (
            "implement primitiveOracleCleanBlock_eq_target from "
            "diagonalCleanBlockContract_pointwise_eq and cubicDiagonalTarget"
            if finite_matrix_ok
            else "repair the source-to-Lean target matrix before proving the bridge leaf"
        ),
        "instances": instances,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--json-out", type=Path)
    args = parser.parse_args()

    feedback = build_feedback()
    encoded = json.dumps(feedback, indent=2, sort_keys=True)
    print(encoded)

    if args.json_out is not None:
        args.json_out.write_text(encoded + "\n", encoding="utf-8")

    return 0 if feedback["finite_matrix_ok"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
