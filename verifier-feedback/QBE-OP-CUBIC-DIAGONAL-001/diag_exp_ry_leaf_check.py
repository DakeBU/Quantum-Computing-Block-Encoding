#!/usr/bin/env python3
"""Leaf-specific finite check for DIAG-EXP-RY-001.

This wrapper reuses the contract-level expanded-route finite model from
``expanded_controlled_ry_check.py`` and retargets the typed feedback to the
current proof-DAG leaf:

  standard R_y(theta), theta_j = 2 arccos((j / 2^n)^3), has clean entry
  cos(theta_j / 2) = (j / 2^n)^3.

The check is only necessary-condition feedback.  It does not close the Lean
theorem ``expandedControlledRyUsesCubicAngle`` and does not promote the
expanded route to a certified block encoding.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import expanded_controlled_ry_check as base


TASK_ID = "QBE-OP-CUBIC-DIAGONAL-001"
LEAF = "DIAG-EXP-RY-001"
LEAN_TARGET = "CubicDiagonalOracle.expandedControlledRyUsesCubicAngle"
TECHNICAL_LEMMA = "tl-cubic-diagonal-ry-clean-entry"
NEXT_ROUTE = (
    "Prove the scalar clean-entry lemma cos((2 * arccos a) / 2) = a "
    "for 0 <= a <= 1, then connect it to "
    "expandedControlledRyUsesCubicAngle while keeping arithmetic and "
    "clean-uncompute leaves separate."
)


def build_feedback() -> dict[str, object]:
    instances = [base.check_instance(n) for n in base.CHECKED_NS]

    scalar_clean_entry_ok = all(
        bool(instance["range_ok"])
        and bool(instance["theta_range_ok"])
        and bool(instance["half_angle_convention_ok"])
        for instance in instances
    )
    finite_matrix_ok = scalar_clean_entry_ok and all(
        bool(instance["diagonal_formula_ok"])
        and bool(instance["off_diagonal_zero_ok"])
        for instance in instances
    )
    block_entry_ok = finite_matrix_ok and all(
        bool(instance["block_entry_ok"]) for instance in instances
    )
    normalizer_ok = all(bool(instance["normalizer_ok"]) for instance in instances)
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

    if not scalar_clean_entry_ok or not finite_matrix_ok or not block_entry_ok:
        error_class = "finite_matrix_counterexample"
        next_route = (
            "Repair the DIAG-EXP-RY-001 rotation convention or the target "
            "block-entry contract before assigning another Lean proof attempt."
        )
    elif not unitarity_ok or not ancilla_cleanup_ok:
        error_class = "shape_or_register_gap"
        next_route = (
            "Repair the expanded register/workspace shape before assigning "
            "DIAG-EXP-RY-001 to a Lean worker."
        )
    else:
        error_class = "symbolic_bridge_gap"
        next_route = NEXT_ROUTE

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
        "block_entry_ok": block_entry_ok,
        "ancilla_cleanup_ok": ancilla_cleanup_ok,
        "normalizer_ok": normalizer_ok,
        "unitarity_ok": unitarity_ok,
        "theta_convention_ok": scalar_clean_entry_ok,
        "scalar_clean_entry_ok": scalar_clean_entry_ok,
        "closed_theorem_ok": False,
        "checked_ns": list(base.CHECKED_NS),
        "standard_ry_convention": (
            "[[cos(theta/2), -sin(theta/2)], "
            "[sin(theta/2), cos(theta/2)]]"
        ),
        "theta_formula": "theta_j = 2 arccos((j / 2^n)^3)",
        "uses_existing_diagnostic_model": (
            "verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/"
            "expanded_controlled_ry_check.py"
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

    failed = not (
        feedback["finite_matrix_ok"]
        and feedback["block_entry_ok"]
        and feedback["theta_convention_ok"]
        and feedback["normalizer_ok"]
        and feedback["unitarity_ok"]
        and feedback["ancilla_cleanup_ok"]
    )
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
