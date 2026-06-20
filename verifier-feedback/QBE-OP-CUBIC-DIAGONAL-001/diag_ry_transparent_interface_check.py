#!/usr/bin/env python3
"""Necessary-condition diagnostic for DIAG-RY-TRANSPARENT-INTERFACE-001.

This check guards the transparent controlled-R_y interface leaf.  It verifies
that small finite instances still use the user-provided diagonal amplitudes
``(j / 2^n)^3`` with normalizer 1 and the standard half-angle convention
``theta_j = 2 arccos((j / 2^n)^3)``.

It does not certify the opaque route predicate, a backend witness, block-entry
extraction, unitarity, clean ancilla cleanup, or executable exports.
"""

from __future__ import annotations

import argparse
import json
import math
from fractions import Fraction
from pathlib import Path
from typing import Any


TASK_ID = "QBE-OP-CUBIC-DIAGONAL-001"
LEAF = "DIAG-RY-TRANSPARENT-INTERFACE-001"
BLOCKED_DIRECT_LEAF = "DIAG-RY-BACKEND-WITNESS-001"
CHECKED_NS = (1, 2, 3, 4, 5, 6)
TOLERANCE = 1.0e-12
LEAN_FILE = Path("QuantumBlockEncoding/CubicStatePreparation.lean")


def nullable_bool(text: str) -> bool | None:
    if text == "true":
        return True
    if text == "false":
        return False
    return None


def field_text(value: Any) -> str:
    if value is None:
        return "null"
    if value is True:
        return "true"
    if value is False:
        return "false"
    return str(value)


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


def check_instance(n: int) -> dict[str, Any]:
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


def contract_body(text: str) -> str:
    start = text.find("def expandedAmplitudeOracleCleanBlockContract")
    if start == -1:
        return ""
    end = text.find("theorem expandedAmplitudeOracleCleanBlockContract_diagonal", start)
    if end == -1:
        return text[start:]
    return text[start:end]


def lean_surface_flags(lean_file: Path) -> dict[str, bool]:
    text = lean_file.read_text(encoding="utf-8")
    body = contract_body(text)
    return {
        "scalar_tier_theorem_present":
            "theorem expandedRyCleanEntryForCubicAmplitudes_of_standardTier" in text,
        "opaque_route_predicate_present":
            "opaque expandedControlledRyUsesCubicAngle" in text,
        "backend_bridge_present":
            "def expandedControlledRyBackendBridge" in text,
        "backend_bridge_normal_form_present":
            "theorem expandedControlledRyBackendBridge_iff_of_standardTier" in text,
        "transparent_rotation_predicate_present":
            "def expandedControlledRyUsesCubicAngleTransparent" in text,
        "transparent_rotation_witness_present":
            "theorem fixedDenomControlledRyRouteTransparent" in text,
        "contract_still_uses_opaque_rotation":
            "expandedControlledRyUsesCubicAngle n workspaceQubits" in body,
        "contract_already_uses_transparent_rotation":
            "expandedControlledRyUsesCubicAngleTransparent n workspaceQubits" in body,
    }


def build_feedback(
    lean_parse_ok: bool | None,
    lean_build_ok: bool | None,
    lean_file: Path,
) -> dict[str, Any]:
    instances = [check_instance(n) for n in CHECKED_NS]
    surface = lean_surface_flags(lean_file)

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
    expected_surface_ok = (
        surface["scalar_tier_theorem_present"]
        and surface["opaque_route_predicate_present"]
        and surface["backend_bridge_present"]
        and surface["backend_bridge_normal_form_present"]
        and surface["contract_still_uses_opaque_rotation"]
    )
    transparent_declarations_present = (
        surface["transparent_rotation_predicate_present"]
        and surface["transparent_rotation_witness_present"]
    )
    transparent_leaf_closed = (
        transparent_declarations_present
        and lean_build_ok is True
    )

    if not finite_matrix_ok:
        error_class = "finite_matrix_counterexample"
        next_route = (
            "Reject the transparent rotation-interface route until the "
            "diagonal amplitude or standard R_y convention is repaired."
        )
        rejection = (
            "Finite scalar/support check contradicts the proposed transparent "
            "rotation interface."
        )
    elif not expected_surface_ok:
        error_class = "source_translation_gap"
        next_route = (
            "Refresh the Lean/source correspondence around "
            "expandedControlledRyUsesCubicAngle before assigning the "
            "transparent interface leaf."
        )
        rejection = (
            "Lean surface no longer exposes the expected opaque route, "
            "conditional backend bridge, normal form, and unchanged clean-block "
            "contract shape."
        )
    elif transparent_leaf_closed:
        error_class = "symbolic_bridge_gap"
        next_route = (
            "Treat DIAG-RY-TRANSPARENT-INTERFACE-001 as closed only for the "
            "transparent scalar-angle witness; wait for middle to assign a "
            "separate transparent-contract refactor or a nontrivial backend "
            "semantics bridge."
        )
        rejection = None
    elif transparent_declarations_present:
        error_class = "symbolic_bridge_gap"
        next_route = (
            "Run the project gate to confirm the transparent rotation "
            "predicate and fixed-denominator witness compile; after that, "
            "treat this leaf as closed only for the transparent scalar-angle "
            "witness."
        )
        rejection = None
    else:
        error_class = "symbolic_bridge_gap"
        next_route = (
            "Add expandedControlledRyUsesCubicAngleTransparent and "
            "fixedDenomControlledRyRouteTransparent using "
            "expandedRyCleanEntryForCubicAmplitudes_of_standardTier; do not "
            "prove the opaque route predicate or refactor the clean-block "
            "contract in this leaf."
        )
        rejection = None

    return {
        "task": TASK_ID,
        "leaf": LEAF,
        "blocked_direct_leaf": BLOCKED_DIRECT_LEAF,
        "active_leaf_reason": (
            "DIAG-RY-BACKEND-WITNESS-001 direct proof search reduces to the "
            "opaque expandedControlledRyUsesCubicAngle predicate.  The active "
            "leaf is therefore a transparent scalar-angle interface that must "
            "remain tied to the diagonal cubic amplitudes and standard R_y "
            "clean-entry convention."
        ),
        "source_correspondence_ok": finite_matrix_ok and expected_surface_ok,
        "source_correspondence_detail": (
            "Checks the user-provided diagonal target D_n[row,col] = if row = "
            "col then (row / 2^n)^3 else 0 with alpha = 1, not a rank-one or "
            "normalized state-preparation target."
        ),
        "lean_parse_ok": lean_parse_ok,
        "lean_build_ok": lean_build_ok,
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
        "closed_theorem_ok": transparent_leaf_closed,
        "opaque_route_predicate_closed": False,
        "backend_witness_certified_ok": False,
        "route_certificate_ok": False,
        "root_certificate_ok": False,
        "exports_ok": False,
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


def render_markdown(feedback: dict[str, Any], command: str) -> str:
    checked = ", ".join(str(n) for n in feedback["checked_ns"])
    typed_fields = [
        "leaf",
        "source_correspondence_ok",
        "lean_parse_ok",
        "lean_build_ok",
        "finite_matrix_ok",
        "block_entry_ok",
        "ancilla_cleanup_ok",
        "normalizer_ok",
        "unitarity_ok",
        "theta_convention_ok",
        "closed_theorem_ok",
        "opaque_route_predicate_closed",
        "backend_witness_certified_ok",
        "route_certificate_ok",
        "root_certificate_ok",
        "exports_ok",
        "error_class",
        "next_route",
    ]
    typed = "\n".join(
        f"{key}={field_text(feedback[key])}" for key in typed_fields
    )
    rows = [
        "| {n} | {grid_size} | {normalizer_ok} | "
        "{diagonal_source_formula_ok} | {off_diagonal_zero_ok} | "
        "{theta_range_ok} | {standard_ry_clean_entry_ok} | "
        "{max_abs_clean_entry_error:.3e} |".format(**item)
        for item in feedback["instances"]
    ]
    surface = feedback["lean_surface"]
    verdict = (
        "No finite scalar/support contradiction was found for the transparent "
        "rotation-interface shape."
        if feedback["finite_matrix_ok"]
        else "The finite diagnostic contradicts the transparent rotation interface."
    )

    return "\n".join(
        [
            "# Verifier Feedback: DIAG-RY-TRANSPARENT-INTERFACE-001",
            "",
            f"Task: `{feedback['task']}`",
            "",
            "## Active Leaf",
            "",
            "`DIAG-RY-TRANSPARENT-INTERFACE-001` is the active lower-facing",
            "leaf.  The diagnostic is necessary because this leaf may introduce",
            "only a transparent scalar-angle witness; it must not turn the",
            "diagonal operator into a rank-one state-preparation target or",
            "close the opaque route predicate by semantic-flag promotion.",
            "",
            "## Executable Diagnostic",
            "",
            "Command:",
            "",
            "```bash",
            command,
            "```",
            "",
            f"Checked finite instances: `{checked}`.",
            "",
            "| n | grid | normalizer ok | diagonal entries ok | off diagonal zero | theta range ok | clean entry ok | max error |",
            "|---|---:|---|---|---|---|---|---:|",
            *rows,
            "",
            "## Lean Surface",
            "",
            f"- scalar-tier theorem present: `{field_text(surface['scalar_tier_theorem_present'])}`",
            f"- opaque route predicate present: `{field_text(surface['opaque_route_predicate_present'])}`",
            f"- backend bridge normal form present: `{field_text(surface['backend_bridge_normal_form_present'])}`",
            f"- transparent predicate present: `{field_text(surface['transparent_rotation_predicate_present'])}`",
            f"- transparent witness present: `{field_text(surface['transparent_rotation_witness_present'])}`",
            f"- clean-block contract still uses opaque rotation: `{field_text(surface['contract_still_uses_opaque_rotation'])}`",
            f"- clean-block contract already uses transparent rotation: `{field_text(surface['contract_already_uses_transparent_rotation'])}`",
            "",
            "## Verdict",
            "",
            verdict,
            "",
            "The block-entry, unitarity, ancilla-cleanup, root-certificate, and",
            "export fields remain `null` or `false` because no named Lean route",
            "certificate exists for those obligations.",
            "",
            "## Typed Feedback",
            "",
            "```text",
            typed,
            "```",
            "",
        ]
    )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--json-out", type=Path)
    parser.add_argument("--md-out", type=Path)
    parser.add_argument("--lean-file", type=Path, default=LEAN_FILE)
    parser.add_argument(
        "--lean-parse-ok",
        choices=("true", "false", "null"),
        default="null",
    )
    parser.add_argument(
        "--lean-build-ok",
        choices=("true", "false", "null"),
        default="null",
    )
    args = parser.parse_args()

    feedback = build_feedback(
        lean_parse_ok=nullable_bool(args.lean_parse_ok),
        lean_build_ok=nullable_bool(args.lean_build_ok),
        lean_file=args.lean_file,
    )
    encoded = json.dumps(feedback, indent=2, sort_keys=True)
    print(encoded)

    if args.json_out is not None:
        args.json_out.write_text(encoded + "\n", encoding="utf-8")
    if args.md_out is not None:
        command = (
            "python3 "
            "verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/"
            "diag_ry_transparent_interface_check.py"
        )
        if args.json_out is not None:
            command += f" \\\n  --json-out {args.json_out}"
        if args.md_out is not None:
            command += f" \\\n  --md-out {args.md_out}"
        command += f" \\\n  --lean-parse-ok {args.lean_parse_ok}"
        command += f" \\\n  --lean-build-ok {args.lean_build_ok}"
        args.md_out.write_text(render_markdown(feedback, command), encoding="utf-8")

    passed = (
        feedback["source_correspondence_ok"]
        and feedback["finite_matrix_ok"]
        and feedback["normalizer_ok"]
        and feedback["theta_convention_ok"]
    )
    return 0 if passed else 1


if __name__ == "__main__":
    raise SystemExit(main())
