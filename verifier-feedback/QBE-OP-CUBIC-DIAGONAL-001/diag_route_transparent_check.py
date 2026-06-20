#!/usr/bin/env python3
"""Necessary-condition diagnostic for DIAG-ARITH-ROUTE-TRANSPARENT-001.

This wrapper reuses the exact-rational fixed-denominator checks from
``diag_route_interface_check.py`` but reports against the current transparent
route witness leaf.  It intentionally does not certify block-entry extraction,
unitarity, clean uncompute, or executable exports.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any

import diag_route_interface_check as base


LEAF = "DIAG-ARITH-ROUTE-TRANSPARENT-001"
BLOCKED_PARENT = "DIAG-ARITH-BACKEND-BRIDGE-001"
LEAN_FILE = Path("QuantumBlockEncoding/CubicStatePreparation.lean")


def transparent_surface_flags() -> dict[str, bool]:
    text = LEAN_FILE.read_text(encoding="utf-8")
    return {
        "transparent_predicate_compiled":
            "def expandedArithmeticComputesCubicAmplitudeTransparent" in text,
        "transparent_witness_compiled":
            "theorem fixedDenomCubicArithmeticRouteTransparent" in text,
        "opaque_route_predicate_still_present":
            "opaque expandedArithmeticComputesCubicAmplitude" in text,
        "fixed_denom_backend_compute_compiled":
            "theorem fixedDenomCubicArithmeticBackend_computes" in text,
    }


def build_feedback(
    lean_parse_ok: bool | None,
    lean_build_ok: bool | None,
) -> dict[str, Any]:
    feedback = base.build_feedback(
        lean_parse_ok=lean_parse_ok,
        lean_build_ok=lean_build_ok,
    )
    flags = transparent_surface_flags()
    closed_theorem_ok = (
        flags["transparent_witness_compiled"] and lean_build_ok is not False
    )

    if not feedback["finite_matrix_ok"]:
        error_class = "finite_matrix_counterexample"
        next_route = (
            "Reject the transparent route witness target until the "
            "fixed-denominator source/register representation is repaired."
        )
    elif not flags["fixed_denom_backend_compute_compiled"]:
        error_class = "shape_or_register_gap"
        next_route = (
            "Restore the compiled fixed-denominator backend compute theorem "
            "before assigning a transparent route witness."
        )
    elif not flags["transparent_witness_compiled"]:
        error_class = "symbolic_bridge_gap"
        next_route = (
            "Compile expandedArithmeticComputesCubicAmplitudeTransparent and "
            "fixedDenomCubicArithmeticRouteTransparent using "
            "fixedDenomCubicArithmeticBackend n and "
            "fixedDenomCubicArithmeticBackend_computes n; keep the opaque "
            "route predicate, clean block, unitarity, and exports blocked."
        )
    else:
        error_class = "symbolic_bridge_gap"
        next_route = (
            "Treat the transparent witness as closed only for this leaf; "
            "middle must choose a transparent-contract refactor or a named "
            "nontrivial bridge before the opaque route/root/export leaves move."
        )

    feedback.update(
        {
            "leaf": LEAF,
            "blocked_parent": BLOCKED_PARENT,
            "necessary_condition": (
                "The transparent existential witness may only use the "
                "fixed-denominator backend if finite exact-rational instances "
                "preserve j, fit payload j^3 in Fin (gridSize (3*n)), recover "
                "(j/2^n)^3, and maintain zero off-diagonal support."
            ),
            "transparent_surface": flags,
            "transparent_target": (
                "fixedDenomCubicArithmeticRouteTransparent : "
                "expandedArithmeticComputesCubicAmplitudeTransparent n (3 * n)"
            ),
            "closed_theorem_ok": closed_theorem_ok,
            "route_certificate_ok": False,
            "block_entry_ok": None,
            "ancilla_cleanup_ok": None,
            "unitarity_ok": None,
            "executable_exports_created": False,
            "error_class": error_class,
            "next_route": next_route,
        }
    )
    return feedback


def render_markdown(feedback: dict[str, Any], command: str) -> str:
    checked = ", ".join(str(n) for n in feedback["checked_ns"])
    typed_fields = [
        "leaf",
        "blocked_parent",
        "source_correspondence_ok",
        "finite_register_ok",
        "finite_arithmetic_ok",
        "finite_matrix_ok",
        "block_entry_ok",
        "ancilla_cleanup_ok",
        "normalizer_ok",
        "unitarity_ok",
        "lean_parse_ok",
        "lean_build_ok",
        "closed_theorem_ok",
        "route_certificate_ok",
        "error_class",
        "next_route",
    ]
    typed = "\n".join(
        f"{key}={base.field_text(feedback[key])}" for key in typed_fields
    )
    rows = [
        "| {n} | {grid_size} | {workspace_qubits} | {max_payload_j_cubed} | "
        "{workspace_capacity} | {workspace_shape_ok} | {payload_capacity_ok} | "
        "{system_preservation_ok} | {amplitude_projection_ok} | "
        "{finite_matrix_ok} | {normalizer_ok} |".format(**item)
        for item in feedback["instances"]
    ]
    if feedback["finite_matrix_ok"]:
        verdict = (
            "No finite source/register contradiction was found for the "
            "transparent witness shape.  This supports only the arithmetic "
            "witness leaf; it does not close the opaque expanded route."
        )
    else:
        verdict = (
            "The finite diagnostic contradicts the transparent witness target. "
            "Reject this route until the source/register representation is "
            "repaired."
        )

    flags = feedback["transparent_surface"]
    return "\n".join(
        [
            "# Verifier Feedback: DIAG-ARITH-ROUTE-TRANSPARENT-001",
            "",
            f"Task: `{feedback['task']}`",
            "",
            "## Active Leaf",
            "",
            "`DIAG-ARITH-ROUTE-TRANSPARENT-001` is the active leaf under",
            "`DIAG-ARITH-BACKEND-BRIDGE-001`.  The diagnostic is necessary",
            "because the proposed transparent existential witness may only",
            "reuse the fixed-denominator backend if that backend still matches",
            "the user-provided diagonal operator and register shape.",
            "",
            "## Executable Diagnostic",
            "",
            "Command:",
            "",
            "```bash",
            command,
            "```",
            "",
            f"Checked finite instances: `{checked}`.  The `n = 0` case is",
            "included because current Lean declarations are over `Nat`; the",
            "source request describes positive qubit counts.",
            "",
            "| n | grid | workspace qubits | max payload | capacity | workspace ok | payload ok | preserves j | amplitude ok | finite matrix ok | normalizer ok |",
            "|---|---:|---:|---:|---:|---|---|---|---|---|---|",
            *rows,
            "",
            "## Transparent Route Status",
            "",
            f"- transparent predicate compiled: `{base.field_text(flags['transparent_predicate_compiled'])}`",
            f"- transparent witness compiled: `{base.field_text(flags['transparent_witness_compiled'])}`",
            f"- fixed-denominator compute proof compiled: `{base.field_text(flags['fixed_denom_backend_compute_compiled'])}`",
            f"- opaque route predicate still present: `{base.field_text(flags['opaque_route_predicate_still_present'])}`",
            "",
            "```text",
            feedback["transparent_target"],
            "```",
            "",
            "This target is a transparent arithmetic witness only.  It is not",
            "a clean-block, unitarity, uncompute, or export certificate.",
            "",
            "## Verdict",
            "",
            verdict,
            "",
            "Block-entry extraction, unitarity, clean uncompute, and executable",
            "exports remain `null` until a named Lean route certificate exists.",
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
        lean_parse_ok=base.nullable_bool(args.lean_parse_ok),
        lean_build_ok=base.nullable_bool(args.lean_build_ok),
    )
    encoded = json.dumps(feedback, indent=2, sort_keys=True)
    print(encoded)

    if args.json_out is not None:
        args.json_out.write_text(encoded + "\n", encoding="utf-8")
    if args.md_out is not None:
        command = (
            "python3 "
            "verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/"
            "diag_route_transparent_check.py"
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
        and feedback["finite_register_ok"]
        and feedback["finite_arithmetic_ok"]
        and feedback["finite_matrix_ok"]
        and feedback["normalizer_ok"]
    )
    return 0 if passed else 1


if __name__ == "__main__":
    raise SystemExit(main())
