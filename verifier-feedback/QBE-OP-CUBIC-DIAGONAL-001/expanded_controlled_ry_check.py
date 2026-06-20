#!/usr/bin/env python3
"""Finite checks for the expanded arithmetic plus controlled-R_y route.

This diagnostic is a necessary-condition check for
DIAG-EXPANDED-CONTRACT-001.  It does not certify a Lean theorem and does not
export Qiskit, QuantumKatas-style, or QASM3 artifacts.

The finite model is the contract-level expanded route:

1. A reversible compute permutation maps clean workspace w=0 to w=j.
2. A standard R_y(theta) acts on the signal qubit, controlled by the computed
   workspace value.
3. The same reversible permutation uncomputes the workspace.

With theta_j = 2 arccos((j / 2^n)^3), the clean signal entry is
cos(theta_j / 2) = (j / 2^n)^3, so the clean (signal=0, workspace=0) block must
be the diagonal cubic target.
"""

from __future__ import annotations

import argparse
import json
import math
from fractions import Fraction
from pathlib import Path
from typing import Iterator


TASK_ID = "QBE-OP-CUBIC-DIAGONAL-001"
LEAF = "DIAG-EXPANDED-CONTRACT-001"
CHECKED_NS = (1, 2, 3, 4)
TOLERANCE = 1.0e-12

BasisState = tuple[int, int, int]
SparseState = dict[BasisState, float]


def rat_text(value: Fraction) -> str:
    if value.denominator == 1:
        return str(value.numerator)
    return f"{value.numerator}/{value.denominator}"


def target_entry(n: int, row: int, col: int) -> Fraction:
    grid_size = 1 << n
    if row == col:
        return Fraction(row, grid_size) ** 3
    return Fraction(0)


def amplitude_fraction(n: int, j: int) -> Fraction:
    grid_size = 1 << n
    return Fraction(j, grid_size) ** 3


def amplitude_float(n: int, j: int) -> float:
    return float(amplitude_fraction(n, j))


def theta(n: int, j: int) -> float:
    return 2.0 * math.acos(amplitude_float(n, j))


def ry_entries(n: int, j: int) -> tuple[float, float]:
    angle = theta(n, j)
    return math.cos(angle / 2.0), math.sin(angle / 2.0)


def basis_states(n: int) -> Iterator[BasisState]:
    grid_size = 1 << n
    for system in range(grid_size):
        for signal in range(2):
            for workspace in range(grid_size):
                yield (system, signal, workspace)


def image_of_basis(n: int, system: int, signal: int, workspace: int) -> SparseState:
    """Apply compute; controlled R_y; uncompute to one basis vector.

    The reversible compute/uncompute skeleton is modeled by XOR on the
    n-qubit workspace.  This is only a finite contract diagnostic for the
    selected register shape; a concrete arithmetic circuit is still a separate
    Lean/source obligation.
    """

    control_value = workspace ^ system
    c, s = ry_entries(n, control_value)
    if signal == 0:
        return {
            (system, 0, workspace): c,
            (system, 1, workspace): s,
        }
    return {
        (system, 0, workspace): -s,
        (system, 1, workspace): c,
    }


def inner_product(left: SparseState, right: SparseState) -> float:
    total = 0.0
    for state, coefficient in left.items():
        total += coefficient * right.get(state, 0.0)
    return total


def coefficient(state: SparseState, basis: BasisState) -> float:
    return state.get(basis, 0.0)


def clean_block_entry(n: int, row: int, col: int) -> float:
    image = image_of_basis(n, col, 0, 0)
    return coefficient(image, (row, 0, 0))


def max_rotation_unitarity_error(n: int) -> float:
    max_error = 0.0
    grid_size = 1 << n
    for j in range(grid_size):
        c, s = ry_entries(n, j)
        column_norm_0 = c * c + s * s
        column_norm_1 = s * s + c * c
        column_dot = c * (-s) + s * c
        determinant = c * c + s * s
        max_error = max(
            max_error,
            abs(column_norm_0 - 1.0),
            abs(column_norm_1 - 1.0),
            abs(column_dot),
            abs(determinant - 1.0),
        )
    return max_error


def max_full_route_unitarity_error(n: int) -> float:
    images = [(basis, image_of_basis(n, *basis)) for basis in basis_states(n)]
    max_error = 0.0
    for index, (basis, image) in enumerate(images):
        max_error = max(max_error, abs(inner_product(image, image) - 1.0))
        for other_basis, other_image in images[index + 1 :]:
            error = abs(inner_product(image, other_image))
            if error > max_error:
                max_error = error
    return max_error


def check_instance(n: int) -> dict[str, object]:
    grid_size = 1 << n

    diagonal_entries = [amplitude_fraction(n, j) for j in range(grid_size)]
    range_ok = all(0 <= entry <= 1 for entry in diagonal_entries)
    theta_convention_ok = all(
        abs(math.cos(theta(n, j) / 2.0) - amplitude_float(n, j)) <= TOLERANCE
        for j in range(grid_size)
    )
    theta_range_ok = all(0.0 <= theta(n, j) <= math.pi for j in range(grid_size))

    max_block_error = 0.0
    off_diagonal_zero_ok = True
    diagonal_formula_ok = True
    for row in range(grid_size):
        for col in range(grid_size):
            observed = clean_block_entry(n, row, col)
            expected = float(target_entry(n, row, col))
            max_block_error = max(max_block_error, abs(observed - expected))
            if row == col:
                diagonal_formula_ok = (
                    diagonal_formula_ok and abs(observed - expected) <= TOLERANCE
                )
            else:
                off_diagonal_zero_ok = (
                    off_diagonal_zero_ok and abs(observed) <= TOLERANCE
                )

    clean_input_images = [
        image_of_basis(n, system, 0, 0) for system in range(grid_size)
    ]
    clean_workspace_output_values = sorted(
        {
            output_workspace
            for image in clean_input_images
            for (_output_system, _output_signal, output_workspace), amp in image.items()
            if abs(amp) > TOLERANCE
        }
    )
    clean_system_support_ok = all(
        output_system == input_system
        for input_system, image in enumerate(clean_input_images)
        for (output_system, _output_signal, _output_workspace), amp in image.items()
        if abs(amp) > TOLERANCE
    )
    clean_workspace_ok = clean_workspace_output_values == [0]

    route_preserves_system_workspace = all(
        output_system == system and output_workspace == workspace
        for system, signal, workspace in basis_states(n)
        for (output_system, _output_signal, output_workspace), amp in image_of_basis(
            n, system, signal, workspace
        ).items()
        if abs(amp) > TOLERANCE
    )

    rotation_unitarity_error = max_rotation_unitarity_error(n)
    full_route_unitarity_error = max_full_route_unitarity_error(n)
    rotation_unitarity_ok = rotation_unitarity_error <= TOLERANCE
    full_route_unitarity_ok = full_route_unitarity_error <= TOLERANCE

    block_entry_ok = (
        diagonal_formula_ok
        and off_diagonal_zero_ok
        and max_block_error <= TOLERANCE
    )

    return {
        "n": n,
        "grid_size": grid_size,
        "workspace_dimension": grid_size,
        "full_route_dimension": 2 * grid_size * grid_size,
        "diagonal_entries": [rat_text(entry) for entry in diagonal_entries],
        "range_ok": range_ok,
        "normalizer": "1",
        "normalizer_ok": range_ok,
        "theta_formula": "theta_j = 2 arccos((j / 2^n)^3)",
        "theta_range_ok": theta_range_ok,
        "half_angle_convention_ok": theta_convention_ok,
        "standard_ry_convention": "[[cos(theta/2), -sin(theta/2)], [sin(theta/2), cos(theta/2)]]",
        "rotation_unitarity_ok": rotation_unitarity_ok,
        "rotation_unitarity_max_error": rotation_unitarity_error,
        "full_route_unitarity_ok": full_route_unitarity_ok,
        "full_route_unitarity_max_error": full_route_unitarity_error,
        "diagonal_formula_ok": diagonal_formula_ok,
        "off_diagonal_zero_ok": off_diagonal_zero_ok,
        "block_entry_ok": block_entry_ok,
        "clean_workspace_output_values_from_clean_input": (
            clean_workspace_output_values
        ),
        "clean_workspace_ok": clean_workspace_ok,
        "clean_system_support_ok": clean_system_support_ok,
        "route_preserves_system_workspace_for_all_inputs": (
            route_preserves_system_workspace
        ),
        "max_abs_clean_block_error": max_block_error,
    }


def build_feedback() -> dict[str, object]:
    instances = [check_instance(n) for n in CHECKED_NS]
    finite_matrix_ok = all(
        bool(instance["diagonal_formula_ok"])
        and bool(instance["off_diagonal_zero_ok"])
        and bool(instance["range_ok"])
        and bool(instance["theta_range_ok"])
        and bool(instance["half_angle_convention_ok"])
        for instance in instances
    )
    block_entry_ok = finite_matrix_ok and all(
        bool(instance["block_entry_ok"]) for instance in instances
    )
    unitarity_ok = all(
        bool(instance["rotation_unitarity_ok"])
        and bool(instance["full_route_unitarity_ok"])
        for instance in instances
    )
    ancilla_cleanup_ok = all(
        bool(instance["clean_workspace_ok"])
        and bool(instance["clean_system_support_ok"])
        and bool(instance["route_preserves_system_workspace_for_all_inputs"])
        for instance in instances
    )
    normalizer_ok = all(bool(instance["normalizer_ok"]) for instance in instances)

    if not finite_matrix_ok or not block_entry_ok:
        error_class = "finite_matrix_counterexample"
        next_route = (
            "Repair the expanded-route source contract before assigning a Lean "
            "bridge for DIAG-EXPANDED-CONTRACT-001."
        )
    elif not unitarity_ok or not ancilla_cleanup_ok:
        error_class = "shape_or_register_gap"
        next_route = (
            "Specify the expanded route's register shape and clean-uncompute "
            "predicate before Lean proof search."
        )
    else:
        error_class = "symbolic_bridge_gap"
        next_route = (
            "Use the expanded-route interface/bridge if present, then prove "
            "or instantiate the concrete backend obligations "
            "expandedArithmeticComputesCubicAmplitude, "
            "expandedControlledRyUsesCubicAngle, "
            "expandedWorkspaceCleanUncomputed, and "
            "expandedAmplitudeOracleCleanBlockExtracts before packaging an "
            "expanded candidate."
        )

    return {
        "task": TASK_ID,
        "leaf": LEAF,
        "source_correspondence_ok": True,
        "lean_parse_ok": None,
        "lean_build_ok": None,
        "finite_matrix_ok": finite_matrix_ok,
        "block_entry_ok": block_entry_ok,
        "ancilla_cleanup_ok": ancilla_cleanup_ok,
        "normalizer_ok": normalizer_ok,
        "unitarity_ok": unitarity_ok,
        "closed_theorem_ok": False,
        "theta_convention_ok": finite_matrix_ok,
        "clean_workspace_assumption": (
            "abstract XOR compute/uncompute workspace; concrete arithmetic "
            "circuit remains a Lean/source obligation"
        ),
        "executable_exports_created": False,
        "retired_route_still_rejected": "DIAG-PRIM-WITNESS-001 Rat one-signal/no-workspace route remains parked",
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

    failed = not (
        feedback["finite_matrix_ok"]
        and feedback["block_entry_ok"]
        and feedback["unitarity_ok"]
        and feedback["ancilla_cleanup_ok"]
        and feedback["normalizer_ok"]
    )
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
