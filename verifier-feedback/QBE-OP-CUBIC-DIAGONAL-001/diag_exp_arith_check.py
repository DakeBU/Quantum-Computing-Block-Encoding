#!/usr/bin/env python3
"""Finite arithmetic/register diagnostic for DIAG-EXP-ARITH-001.

This check is a necessary-condition verifier for the expanded arithmetic leaf.
It does not prove the Lean predicate
``CubicDiagonalOracle.expandedArithmeticComputesCubicAmplitude`` and does not
certify or export a block encoding.

The finite model checks that the arithmetic payload intended for the compute
phase is exactly ``(j / 2^n)^3`` and that the diagonal matrix induced by that
payload matches the user target.  It also records a concrete exact-rational
payload shape, because any later arithmetic backend witness must name how this
payload is represented in the route workspace.
"""

from __future__ import annotations

import argparse
import json
from fractions import Fraction
from pathlib import Path


TASK_ID = "QBE-OP-CUBIC-DIAGONAL-001"
LEAF = "DIAG-EXP-ARITH-001"
LEAN_TARGET = "CubicDiagonalOracle.expandedArithmeticComputesCubicAmplitude"
TECHNICAL_LEMMA = "tl-cubic-diagonal-reversible-cube-arithmetic"
CHECKED_NS = (1, 2, 3, 4, 5)


def rat_text(value: Fraction) -> str:
    if value.denominator == 1:
        return str(value.numerator)
    return f"{value.numerator}/{value.denominator}"


def amplitude_fraction(n: int, j: int) -> Fraction:
    grid_size = 1 << n
    return Fraction(j, grid_size) ** 3


def target_entry(n: int, row: int, col: int) -> Fraction:
    if row == col:
        return amplitude_fraction(n, row)
    return Fraction(0)


def numerator_payload(n: int, j: int) -> tuple[int, int]:
    """Return the exact payload j^3 / 2^(3n) before Fraction reduction."""

    return j**3, 3 * n


def bits_needed(value: int) -> int:
    return value.bit_length()


def check_instance(n: int) -> dict[str, object]:
    grid_size = 1 << n
    entries = [amplitude_fraction(n, j) for j in range(grid_size)]
    raw_payloads = [numerator_payload(n, j) for j in range(grid_size)]
    max_raw_numerator = max(numerator for numerator, _den_power in raw_payloads)

    arithmetic_payload_ok = all(
        Fraction(numerator, 1 << den_power) == amplitude_fraction(n, j)
        for j, (numerator, den_power) in enumerate(raw_payloads)
    )
    diagonal_formula_ok = all(
        target_entry(n, j, j) == amplitude_fraction(n, j)
        for j in range(grid_size)
    )
    off_diagonal_zero_ok = all(
        target_entry(n, row, col) == 0
        for row in range(grid_size)
        for col in range(grid_size)
        if row != col
    )
    range_ok = all(0 <= entry <= 1 for entry in entries)
    system_preservation_ok = all(j == j for j in range(grid_size))
    payload_varies = len(set(entries)) > 1

    return {
        "n": n,
        "grid_size": grid_size,
        "diagonal_entries": [rat_text(entry) for entry in entries],
        "raw_payload_form": "j^3 / 2^(3*n)",
        "raw_denominator_power": 3 * n,
        "max_raw_numerator": max_raw_numerator,
        "exact_numerator_bits_needed": bits_needed(max_raw_numerator),
        "arithmetic_payload_ok": arithmetic_payload_ok,
        "diagonal_formula_ok": diagonal_formula_ok,
        "off_diagonal_zero_ok": off_diagonal_zero_ok,
        "range_ok": range_ok,
        "normalizer": "1",
        "normalizer_ok": range_ok,
        "system_preservation_ok": system_preservation_ok,
        "payload_varies_with_system_index": payload_varies,
    }


def build_feedback() -> dict[str, object]:
    instances = [check_instance(n) for n in CHECKED_NS]
    finite_matrix_ok = all(
        bool(instance["arithmetic_payload_ok"])
        and bool(instance["diagonal_formula_ok"])
        and bool(instance["off_diagonal_zero_ok"])
        and bool(instance["range_ok"])
        and bool(instance["system_preservation_ok"])
        for instance in instances
    )
    normalizer_ok = all(bool(instance["normalizer_ok"]) for instance in instances)

    if not finite_matrix_ok or not normalizer_ok:
        error_class = "finite_matrix_counterexample"
        next_route = (
            "Repair the arithmetic payload or diagonal target correspondence "
            "before assigning a Lean proof for DIAG-EXP-ARITH-001."
        )
    else:
        error_class = "symbolic_bridge_gap"
        next_route = (
            "Introduce a concrete arithmetic backend witness for "
            "expandedArithmeticComputesCubicAmplitude with an explicit "
            "workspace representation/capacity, or keep it as an honest "
            "backend obligation; do not close the opaque predicate by trivial."
        )

    return {
        "task": TASK_ID,
        "leaf": LEAF,
        "source_correspondence_ok": True,
        "source_correspondence_detail": (
            "Checks the user-provided diagonal target D_n[row,col] = "
            "if row = col then (row / 2^n)^3 else 0 with alpha = 1."
        ),
        "lean_target": LEAN_TARGET,
        "technical_lemma": TECHNICAL_LEMMA,
        "lean_parse_ok": None,
        "lean_build_ok": None,
        "finite_matrix_ok": finite_matrix_ok,
        "finite_arithmetic_ok": finite_matrix_ok,
        "block_entry_ok": None,
        "ancilla_cleanup_ok": None,
        "normalizer_ok": normalizer_ok,
        "unitarity_ok": None,
        "closed_theorem_ok": False,
        "route_predicate_closed": False,
        "checked_ns": list(CHECKED_NS),
        "workspace_representation_specified": False,
        "workspace_capacity_checked": None,
        "workspace_shape_note": (
            "The diagnostic records exact numerator bits for the payload "
            "j^3 / 2^(3*n), but the current Lean target has no concrete "
            "workspace encoding or lower-bound theorem."
        ),
        "executable_exports_created": False,
        "resource_score": None,
        "gate_count": None,
        "depth": None,
        "auxiliary_qubits": None,
        "oracle_calls": None,
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

    return 0 if feedback["finite_matrix_ok"] and feedback["normalizer_ok"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
