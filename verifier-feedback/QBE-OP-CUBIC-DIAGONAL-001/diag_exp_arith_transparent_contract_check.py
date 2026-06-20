#!/usr/bin/env python3
"""Necessary-condition diagnostic for DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001.

The active leaf is a contract refactor: the expanded clean-block contract should
consume ``expandedArithmeticComputesCubicAmplitudeTransparent`` instead of
retrying the old opaque arithmetic route predicate.  This diagnostic reuses the
exact-rational fixed-denominator checks from the transparent route witness and
adds a Lean-surface check for the current contract shape.

It is not a block-encoding proof.  Block-entry extraction, unitarity,
clean-uncompute, and executable exports remain out of scope until a named Lean
route certificate exists.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any

import diag_route_interface_check as common
import diag_route_transparent_check as base


LEAF = "DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001"
BLOCKED_PARENT = "DIAG-ROOT-001"
LEAN_FILE = Path("QuantumBlockEncoding/CubicStatePreparation.lean")


def contract_body() -> str:
    text = LEAN_FILE.read_text(encoding="utf-8")
    start = text.find("def expandedAmplitudeOracleCleanBlockContract")
    if start == -1:
        return ""
    end = text.find("theorem expandedAmplitudeOracleCleanBlockContract_diagonal", start)
    if end == -1:
        return text[start:]
    return text[start:end]


def contract_surface_flags() -> dict[str, bool]:
    text = LEAN_FILE.read_text(encoding="utf-8")
    body = contract_body()
    return {
        "transparent_predicate_compiled":
            "def expandedArithmeticComputesCubicAmplitudeTransparent" in text,
        "transparent_witness_compiled":
            "theorem fixedDenomCubicArithmeticRouteTransparent" in text,
        "fixed_denom_backend_compute_compiled":
            "theorem fixedDenomCubicArithmeticBackend_computes" in text,
        "opaque_route_predicate_still_present":
            "opaque expandedArithmeticComputesCubicAmplitude" in text,
        "expanded_contract_present":
            "def expandedAmplitudeOracleCleanBlockContract" in text,
        "contract_uses_transparent_arithmetic":
            "expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits"
            in body,
        "contract_uses_opaque_arithmetic":
            "expandedArithmeticComputesCubicAmplitude n workspaceQubits"
            in body,
    }


def build_feedback(
    lean_parse_ok: bool | None,
    lean_build_ok: bool | None,
) -> dict[str, Any]:
    feedback = base.build_feedback(
        lean_parse_ok=lean_parse_ok,
        lean_build_ok=lean_build_ok,
    )
    flags = contract_surface_flags()
    refactor_ready = (
        feedback["finite_matrix_ok"]
        and flags["transparent_predicate_compiled"]
        and flags["transparent_witness_compiled"]
        and flags["fixed_denom_backend_compute_compiled"]
        and flags["expanded_contract_present"]
    )
    contract_refactor_present = (
        flags["contract_uses_transparent_arithmetic"]
        and not flags["contract_uses_opaque_arithmetic"]
    )
    closed_theorem_ok = (
        contract_refactor_present
        and flags["transparent_witness_compiled"]
        and lean_build_ok is True
    )

    if not feedback["finite_matrix_ok"]:
        error_class = "finite_matrix_counterexample"
        next_route = (
            "Reject the transparent-contract refactor until the "
            "fixed-denominator arithmetic/register representation is repaired."
        )
    elif not refactor_ready:
        error_class = "shape_or_register_gap"
        next_route = (
            "Restore the compiled transparent arithmetic witness and expanded "
            "clean-block contract before refactoring the arithmetic conjunct."
        )
    elif not contract_refactor_present:
        error_class = "symbolic_bridge_gap"
        next_route = (
            "Refactor expandedAmplitudeOracleCleanBlockContract so its "
            "arithmetic conjunct is "
            "expandedArithmeticComputesCubicAmplitudeTransparent n "
            "workspaceQubits; do not prove the old opaque predicate by "
            "trivial, axiom, or semantic-flag promotion."
        )
    else:
        error_class = "symbolic_bridge_gap"
        next_route = (
            "Treat only the transparent arithmetic conjunct as refactored; "
            "keep rotation backend, clean uncompute, extraction, unitarity, "
            "root certificate, and exports blocked."
        )

    feedback.update(
        {
            "leaf": LEAF,
            "blocked_parent": BLOCKED_PARENT,
            "necessary_condition": (
                "The expanded clean-block contract can safely consume the "
                "transparent arithmetic predicate only if finite "
                "exact-rational instances still preserve j, fit payload j^3 "
                "in Fin (gridSize (3*n)), recover (j/2^n)^3, and keep "
                "off-diagonal support zero."
            ),
            "active_contract_target": (
                "expandedAmplitudeOracleCleanBlockContract arithmetic conjunct"
            ),
            "contract_surface": flags,
            "contract_refactor_ready": refactor_ready,
            "contract_refactor_present": contract_refactor_present,
            "closed_theorem_ok": closed_theorem_ok,
            "route_certificate_ok": False,
            "block_entry_ok": None,
            "ancilla_cleanup_ok": None,
            "unitarity_ok": None,
            "resource_score": None,
            "gate_count": None,
            "depth": None,
            "auxiliary_qubits": None,
            "oracle_calls": None,
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
        "contract_refactor_ready",
        "contract_refactor_present",
        "error_class",
        "next_route",
    ]
    typed = "\n".join(
        f"{key}={common.field_text(feedback[key])}" for key in typed_fields
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
            "No finite arithmetic/register contradiction was found.  The "
            "transparent-contract refactor remains source-compatible as a "
            "necessary condition, but it is not a block-entry or route "
            "certificate."
        )
    else:
        verdict = (
            "The finite diagnostic contradicts the contract-refactor route. "
            "Reject this leaf until the arithmetic/register representation is "
            "repaired."
        )

    flags = feedback["contract_surface"]
    return "\n".join(
        [
            "# Verifier Feedback: DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001",
            "",
            f"Task: `{feedback['task']}`",
            "",
            "## Active Leaf",
            "",
            "`DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001` is the active leaf",
            "under `DIAG-ROOT-001`.  The diagnostic is necessary because the",
            "next Lean refactor should only replace the arithmetic conjunct",
            "with the transparent predicate if the closed fixed-denominator",
            "arithmetic witness still matches the user-provided diagonal",
            "operator and register shape.",
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
            "## Contract Surface",
            "",
            f"- transparent predicate compiled: `{common.field_text(flags['transparent_predicate_compiled'])}`",
            f"- transparent witness compiled: `{common.field_text(flags['transparent_witness_compiled'])}`",
            f"- fixed-denominator compute proof compiled: `{common.field_text(flags['fixed_denom_backend_compute_compiled'])}`",
            f"- expanded contract present: `{common.field_text(flags['expanded_contract_present'])}`",
            f"- contract uses transparent arithmetic: `{common.field_text(flags['contract_uses_transparent_arithmetic'])}`",
            f"- contract uses opaque arithmetic: `{common.field_text(flags['contract_uses_opaque_arithmetic'])}`",
            f"- old opaque route predicate still present: `{common.field_text(flags['opaque_route_predicate_still_present'])}`",
            "",
            "The old opaque predicate may remain declared, but this leaf expects",
            "the expanded clean-block contract to consume the transparent",
            "arithmetic predicate instead of retrying a direct bridge proof.",
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
        lean_parse_ok=common.nullable_bool(args.lean_parse_ok),
        lean_build_ok=common.nullable_bool(args.lean_build_ok),
    )
    encoded = json.dumps(feedback, indent=2, sort_keys=True)
    print(encoded)

    if args.json_out is not None:
        args.json_out.write_text(encoded + "\n", encoding="utf-8")
    if args.md_out is not None:
        command = (
            "python3 "
            "verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/"
            "diag_exp_arith_transparent_contract_check.py"
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
