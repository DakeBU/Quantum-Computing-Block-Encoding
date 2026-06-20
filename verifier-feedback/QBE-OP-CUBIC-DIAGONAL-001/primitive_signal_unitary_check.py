#!/usr/bin/env python3
"""Necessary-condition checks for DIAG-PRIM-WITNESS-001.

This diagnostic does not prove or disprove the opaque Lean predicate
`primitiveAmplitudeOracleIsUnitary`.  It checks a standard exact interpretation
that a Lean worker might otherwise try to prove: the current primitive
candidate is a one-signal/no-workspace block unitary over `Rat` whose clean
block is the diagonal matrix with entries `(j / 2^n)^3`.

For a rational standard unitary with block decomposition

    U = [[D, B],
         [C, E]]

and `D = diag(a_j)`, column orthogonality for the clean-block columns implies
`C^T C = diag(1 - a_j^2)`.  With one signal qubit and no pure workspace, `C` is
an `N x N` rational matrix, so `det(C)^2 = prod_j (1 - a_j^2)`.  Therefore that
product must be a rational square.  Failure is a necessary-condition rejection
for the exact rational one-signal/no-workspace witness route, not a rejection
of the target diagonal operator itself.
"""

from __future__ import annotations

import argparse
import json
from fractions import Fraction
from math import isqrt
from pathlib import Path


TASK_ID = "QBE-OP-CUBIC-DIAGONAL-001"
LEAF = "DIAG-PRIM-WITNESS-001"
CHECKED_NS = (1, 2, 3)


def rat_text(value: Fraction) -> str:
    if value.denominator == 1:
        return str(value.numerator)
    return f"{value.numerator}/{value.denominator}"


def is_square_nat(value: int) -> bool:
    if value < 0:
        return False
    root = isqrt(value)
    return root * root == value


def is_square_fraction(value: Fraction) -> bool:
    return is_square_nat(value.numerator) and is_square_nat(value.denominator)


def target_entry(n: int, row: int, col: int) -> Fraction:
    grid_size = 1 << n
    if row == col:
        return Fraction(row, grid_size) ** 3
    return Fraction(0)


def product(values: list[Fraction]) -> Fraction:
    acc = Fraction(1)
    for value in values:
        acc *= value
    return acc


def check_instance(n: int) -> dict[str, object]:
    grid_size = 1 << n
    diagonal_entries = [target_entry(n, j, j) for j in range(grid_size)]
    residual_norms = [Fraction(1) - entry * entry for entry in diagonal_entries]
    residual_product = product(residual_norms)

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
    block_entry_ok = diagonal_formula_ok and off_diagonal_zero_ok

    rational_per_index_rotation_possible = all(
        is_square_fraction(residual) for residual in residual_norms
    )
    determinant_square_ok = is_square_fraction(residual_product)
    determinant_obstruction = block_entry_ok and range_ok and not determinant_square_ok

    return {
        "n": n,
        "grid_size": grid_size,
        "full_unitary_dimension": 2 * grid_size,
        "clean_block_dimension": grid_size,
        "diagonal_formula_ok": diagonal_formula_ok,
        "off_diagonal_zero_ok": off_diagonal_zero_ok,
        "range_ok": range_ok,
        "block_entry_ok": block_entry_ok,
        "normalizer": "1",
        "normalizer_ok": True,
        "diagonal_entries": [rat_text(entry) for entry in diagonal_entries],
        "residual_norms_1_minus_a_sq": [
            rat_text(residual) for residual in residual_norms
        ],
        "real_two_by_two_rotation_possible": range_ok,
        "rational_per_index_two_by_two_rotation_possible": (
            rational_per_index_rotation_possible
        ),
        "rational_completion_determinant_product": rat_text(residual_product),
        "rational_completion_determinant_square_ok": determinant_square_ok,
        "rational_one_signal_no_workspace_rejected": determinant_obstruction,
    }


def build_feedback() -> dict[str, object]:
    instances = [check_instance(n) for n in CHECKED_NS]
    finite_matrix_ok = all(
        bool(instance["diagonal_formula_ok"])
        and bool(instance["off_diagonal_zero_ok"])
        and bool(instance["range_ok"])
        and bool(instance["normalizer_ok"])
        for instance in instances
    )
    rational_route_rejected = any(
        bool(instance["rational_one_signal_no_workspace_rejected"])
        for instance in instances
    )

    if not finite_matrix_ok:
        error_class = "finite_matrix_counterexample"
        next_route = (
            "Repair the source-to-Lean target matrix before proving a primitive "
            "oracle witness."
        )
    elif rational_route_rejected:
        error_class = "shape_or_register_gap"
        next_route = (
            "Do not ask Lean to prove primitiveAmplitudeOracleSemanticContract n "
            "as a standard Rat one-signal/no-workspace unitary; either retarget "
            "the primitive contract to an explicitly accepted Real/Complex "
            "amplitude-oracle semantics, or open the expanded arithmetic route "
            "with a source-backed unitary convention."
        )
    else:
        error_class = "external_contract_gap"
        next_route = (
            "Finite checks do not reject the primitive witness shape; still "
            "supply or explicitly accept a proof of "
            "primitiveAmplitudeOracleSemanticContract n."
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
        "unitarity_ok": False if rational_route_rejected else None,
        "resource_score": [1, 1, 1, 1],
        "auxiliary_qubits": 1,
        "gate_count": 1,
        "depth": 1,
        "oracle_calls": 1,
        "closed_theorem_ok": False,
        "rational_one_signal_no_workspace_rejected": rational_route_rejected,
        "error_class": error_class,
        "next_route": next_route,
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

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
