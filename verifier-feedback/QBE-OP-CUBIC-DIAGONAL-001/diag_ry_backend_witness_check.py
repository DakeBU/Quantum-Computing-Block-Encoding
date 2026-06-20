#!/usr/bin/env python3
"""Necessary-condition diagnostic for DIAG-RY-BACKEND-WITNESS-001.

This check is deliberately narrower than an expanded block-entry simulator.  It
checks that the active rotation backend witness leaf is still pointed at the
user's diagonal cubic amplitudes and at the standard R_y half-angle convention.
It does not certify the backend witness, the route predicate, unitarity,
ancilla cleanup, block extraction, or executable exports.
"""

from __future__ import annotations

import argparse
import json
import math
from fractions import Fraction
from pathlib import Path


TASK_ID = "QBE-OP-CUBIC-DIAGONAL-001"
LEAF = "DIAG-RY-BACKEND-WITNESS-001"
CHECKED_NS = (1, 2, 3, 4, 5, 6)
TOLERANCE = 1.0e-12
LEAN_FILE = Path("QuantumBlockEncoding/CubicStatePreparation.lean")


def rat_text(value: Fraction) -> str:
    if value.denominator == 1:
        return str(value.numerator)
    return f"{value.numerator}/{value.denominator}"


def cubic_amplitude(n: int, j: int) -> Fraction:
    return Fraction(j, 1 << n) ** 3


def target_entry(n: int, row: int, col: int) -> Fraction:
    if row == col:
        return cubic_amplitude(n, row)
    return Fraction(0)


def check_instance(n: int) -> dict[str, object]:
    grid_size = 1 << n
    amplitudes = [cubic_amplitude(n, j) for j in range(grid_size)]

    range_ok = all(Fraction(0) <= amplitude <= Fraction(1) for amplitude in amplitudes)
    diagonal_formula_ok = all(
        target_entry(n, j, j) == cubic_amplitude(n, j) for j in range(grid_size)
    )
    off_diagonal_zero_ok = all(
        target_entry(n, row, col) == 0
        for row in range(grid_size)
        for col in range(grid_size)
        if row != col
    )

    max_clean_entry_error = 0.0
    theta_range_ok = True
    clean_entry_ok = True
    for amplitude in amplitudes:
        amplitude_float = float(amplitude)
        theta = 2.0 * math.acos(amplitude_float)
        clean_entry = math.cos(theta / 2.0)
        max_clean_entry_error = max(
            max_clean_entry_error, abs(clean_entry - amplitude_float)
        )
        theta_range_ok = theta_range_ok and 0.0 <= theta <= math.pi
        clean_entry_ok = clean_entry_ok and (
            abs(clean_entry - amplitude_float) <= TOLERANCE
        )

    return {
        "n": n,
        "grid_size": grid_size,
        "diagonal_entries": [rat_text(amplitude) for amplitude in amplitudes],
        "range_ok": range_ok,
        "normalizer": "1",
        "normalizer_ok": range_ok,
        "diagonal_source_formula_ok": diagonal_formula_ok,
        "off_diagonal_zero_ok": off_diagonal_zero_ok,
        "theta_formula": "theta_j = 2 arccos((j / 2^n)^3)",
        "theta_range_ok": theta_range_ok,
        "standard_ry_clean_entry_ok": clean_entry_ok,
        "max_abs_clean_entry_error": max_clean_entry_error,
    }


def lean_surface_checks(lean_file: Path) -> dict[str, object]:
    text = lean_file.read_text(encoding="utf-8")
    route_predicate_is_opaque = "opaque expandedControlledRyUsesCubicAngle" in text
    backend_bridge_decl_present = "def expandedControlledRyBackendBridge" in text
    conditional_bridge_decl_present = (
        "theorem expandedControlledRyUsesCubicAngle_of_backendBridge" in text
    )
    bridge_requires_hbridge = (
        "hBridge : expandedControlledRyBackendBridge tier n workspaceQubits" in text
    )
    scalar_tier_theorem_present = (
        "theorem expandedRyCleanEntryForCubicAmplitudes_of_standardTier" in text
    )

    return {
        "lean_file": str(lean_file),
        "route_predicate_is_opaque": route_predicate_is_opaque,
        "backend_bridge_decl_present": backend_bridge_decl_present,
        "conditional_bridge_decl_present": conditional_bridge_decl_present,
        "bridge_requires_hbridge": bridge_requires_hbridge,
        "scalar_tier_theorem_present": scalar_tier_theorem_present,
        "lean_surface_ok": all(
            [
                route_predicate_is_opaque,
                backend_bridge_decl_present,
                conditional_bridge_decl_present,
                bridge_requires_hbridge,
                scalar_tier_theorem_present,
            ]
        ),
    }


def build_feedback(lean_file: Path) -> dict[str, object]:
    instances = [check_instance(n) for n in CHECKED_NS]
    surface = lean_surface_checks(lean_file)

    finite_matrix_ok = all(
        bool(instance["range_ok"])
        and bool(instance["diagonal_source_formula_ok"])
        and bool(instance["off_diagonal_zero_ok"])
        and bool(instance["theta_range_ok"])
        and bool(instance["standard_ry_clean_entry_ok"])
        for instance in instances
    )
    normalizer_ok = all(bool(instance["normalizer_ok"]) for instance in instances)
    theta_convention_ok = all(
        bool(instance["standard_ry_clean_entry_ok"]) for instance in instances
    )

    if not finite_matrix_ok:
        error_class = "finite_matrix_counterexample"
        next_route = (
            "Repair the scalar R_y convention or diagonal target support before "
            "assigning any backend-witness proof."
        )
        rejection = (
            "Finite scalar/support check contradicts the current rotation "
            "backend witness target."
        )
    elif not bool(surface["lean_surface_ok"]):
        error_class = "source_translation_gap"
        next_route = (
            "Refresh the Lean/source correspondence for "
            "expandedControlledRyBackendBridge before assigning proof search."
        )
        rejection = (
            "Lean surface no longer exposes the expected conditional backend "
            "witness interface."
        )
    else:
        error_class = "symbolic_bridge_gap"
        next_route = (
            "State or implement a transparent backend-semantics witness "
            "hBridge : expandedControlledRyBackendBridge tier n (3 * n); keep "
            "DIAG-EXP-UNCOMP-001, block extraction, unitarity, root, and "
            "exports downstream until that witness exists."
        )
        rejection = None

    return {
        "task": TASK_ID,
        "leaf": LEAF,
        "active_leaf_reason": (
            "The arithmetic transparent contract refactor is closed.  The next "
            "route dependency is the controlled-R_y backend witness connecting "
            "the compiled scalar-tier theorem to expandedControlledRyUsesCubicAngle."
        ),
        "source_correspondence_ok": finite_matrix_ok and bool(surface["lean_surface_ok"]),
        "source_correspondence_detail": (
            "Checks the user-provided diagonal target D_n[row,col] = if row = "
            "col then (row / 2^n)^3 else 0 with alpha = 1, not a rank-one or "
            "normalized state-preparation target."
        ),
        "lean_parse_ok": None,
        "lean_build_ok": None,
        "finite_matrix_ok": finite_matrix_ok,
        "finite_scalar_clean_entry_ok": theta_convention_ok,
        "finite_diagonal_support_ok": all(
            bool(instance["off_diagonal_zero_ok"]) for instance in instances
        ),
        "block_entry_ok": None,
        "ancilla_cleanup_ok": None,
        "normalizer_ok": normalizer_ok,
        "unitarity_ok": None,
        "theta_convention_ok": theta_convention_ok,
        "closed_theorem_ok": False,
        "route_predicate_closed": False,
        "backend_witness_certified_ok": False,
        "executable_exports_created": False,
        "resource_score": None,
        "gate_count": None,
        "depth": None,
        "auxiliary_qubits": None,
        "oracle_calls": None,
        "checked_ns": list(CHECKED_NS),
        "standard_ry_convention": (
            "[[cos(theta/2), -sin(theta/2)], "
            "[sin(theta/2), cos(theta/2)]]"
        ),
        "theta_formula": "theta_j = 2 arccos((j / 2^n)^3)",
        "lean_surface": surface,
        "instances": instances,
        "rejection": rejection,
        "error_class": error_class,
        "next_route": next_route,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--json-out", type=Path)
    parser.add_argument("--lean-file", type=Path, default=LEAN_FILE)
    args = parser.parse_args()

    feedback = build_feedback(args.lean_file)
    encoded = json.dumps(feedback, indent=2, sort_keys=True)
    print(encoded)

    if args.json_out is not None:
        args.json_out.write_text(encoded + "\n", encoding="utf-8")

    failed = feedback["error_class"] != "symbolic_bridge_gap"
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
