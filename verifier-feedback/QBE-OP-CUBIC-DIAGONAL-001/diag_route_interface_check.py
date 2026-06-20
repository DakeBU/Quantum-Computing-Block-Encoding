#!/usr/bin/env python3
"""Necessary-condition diagnostic for DIAG-ARITH-ROUTE-INTERFACE-001.

This check protects the route-interface leaf from drifting away from the
user-provided diagonal operator.  It verifies, on small exact-rational
instances, that the fixed-denominator backend representation still preserves
the system index and induces the diagonal entries

    D_n[row, col] = if row = col then (row / 2^n)^3 else 0.

It is not a block-encoding proof.  Block-entry extraction, unitarity,
clean-uncompute, and executable exports remain out of scope until a named Lean
route certificate exists.
"""

from __future__ import annotations

import argparse
import json
from fractions import Fraction
from pathlib import Path
from typing import Any


TASK_ID = "QBE-OP-CUBIC-DIAGONAL-001"
LEAF = "DIAG-ARITH-ROUTE-INTERFACE-001"
BLOCKED_PARENT = "DIAG-ARITH-BACKEND-BRIDGE-001"
CHECKED_NS = tuple(range(0, 7))
LEAN_FILE = Path("QuantumBlockEncoding/CubicStatePreparation.lean")


def rat_text(value: Fraction) -> str:
    if value.denominator == 1:
        return str(value.numerator)
    return f"{value.numerator}/{value.denominator}"


def nullable_bool(value: str) -> bool | None:
    if value == "true":
        return True
    if value == "false":
        return False
    return None


def grid_size(n: int) -> int:
    return 1 << n


def workspace_capacity(n: int) -> int:
    return 1 << (3 * n)


def source_amplitude(n: int, j: int) -> Fraction:
    return Fraction(j, grid_size(n)) ** 3


def source_matrix_entry(n: int, row: int, col: int) -> Fraction:
    if row == col:
        return source_amplitude(n, row)
    return Fraction(0)


def payload(_n: int, j: int) -> int:
    return j**3


def amplitude_projection(n: int, workspace_value: int) -> Fraction:
    return Fraction(workspace_value, workspace_capacity(n))


def compute(n: int, j: int, workspace_value: int) -> tuple[int, int]:
    del workspace_value
    return (j, payload(n, j))


def induced_entry_from_fixed_denom_backend(n: int, row: int, col: int) -> Fraction:
    if row != col:
        return Fraction(0)
    out_j, out_workspace = compute(n, row, 0)
    if out_j != row:
        return Fraction(-1)
    return amplitude_projection(n, out_workspace)


def lean_surface_flags(lean_file: Path) -> dict[str, bool]:
    text = lean_file.read_text(encoding="utf-8")
    return {
        "general_bridge_normal_form_compiled":
            "theorem expandedArithmeticBackendBridge_iff_of_computes" in text,
        "fixed_denom_backend_compiled":
            "def fixedDenomCubicArithmeticBackend" in text,
        "fixed_denom_backend_compute_compiled":
            "theorem fixedDenomCubicArithmeticBackend_computes" in text,
        "fixed_denom_bridge_normal_form_compiled":
            "fixedDenomCubicArithmeticBackend_bridge_iff" in text,
        "route_predicate_is_opaque":
            "opaque expandedArithmeticComputesCubicAmplitude" in text,
    }


def check_instance(n: int) -> dict[str, Any]:
    size = grid_size(n)
    capacity = workspace_capacity(n)
    rows = range(size)
    clean_workspace = 0
    compute_rows = [compute(n, j, clean_workspace) for j in rows]
    payloads = [out_workspace for _, out_workspace in compute_rows]
    amplitudes = [amplitude_projection(n, value) for value in payloads]

    workspace_shape_ok = capacity == grid_size(3 * n) and clean_workspace < capacity
    payload_capacity_ok = all(0 <= value < capacity for value in payloads)
    system_preservation_ok = all(out_j == j for j, (out_j, _) in enumerate(compute_rows))
    amplitude_projection_ok = all(
        amplitudes[j] == source_amplitude(n, j)
        for j in rows
    )
    finite_matrix_ok = all(
        induced_entry_from_fixed_denom_backend(n, row, col)
        == source_matrix_entry(n, row, col)
        for row in rows
        for col in rows
    )
    support_vanish_ok = all(
        induced_entry_from_fixed_denom_backend(n, row, col) == 0
        for row in rows
        for col in rows
        if row != col
    )
    normalizer_ok = all(0 <= value <= 1 for value in amplitudes)

    return {
        "n": n,
        "grid_size": size,
        "workspace_qubits": 3 * n,
        "workspace_capacity": capacity,
        "clean_workspace": clean_workspace,
        "max_payload_j_cubed": max(payloads),
        "payload_capacity_gap_at_max": capacity - 1 - max(payloads),
        "workspace_shape_ok": workspace_shape_ok,
        "payload_capacity_ok": payload_capacity_ok,
        "system_preservation_ok": system_preservation_ok,
        "amplitude_projection_ok": amplitude_projection_ok,
        "finite_matrix_ok": finite_matrix_ok,
        "support_vanish_ok": support_vanish_ok,
        "normalizer_ok": normalizer_ok,
        "diagonal_entries": [rat_text(value) for value in amplitudes],
    }


def build_feedback(
    lean_parse_ok: bool | None,
    lean_build_ok: bool | None,
) -> dict[str, Any]:
    instances = [check_instance(n) for n in CHECKED_NS]
    flags = lean_surface_flags(LEAN_FILE)
    finite_register_ok = all(
        item["workspace_shape_ok"] and item["payload_capacity_ok"]
        for item in instances
    )
    finite_arithmetic_ok = all(
        item["system_preservation_ok"] and item["amplitude_projection_ok"]
        for item in instances
    )
    finite_matrix_ok = all(item["finite_matrix_ok"] for item in instances)
    support_vanish_ok = all(item["support_vanish_ok"] for item in instances)
    normalizer_ok = all(item["normalizer_ok"] for item in instances)
    source_correspondence_ok = (
        finite_matrix_ok
        and support_vanish_ok
        and normalizer_ok
    )
    bridge_normal_form_available = (
        flags["general_bridge_normal_form_compiled"]
        and flags["fixed_denom_backend_compiled"]
        and flags["fixed_denom_backend_compute_compiled"]
        and flags["route_predicate_is_opaque"]
    )

    finite_ok = (
        source_correspondence_ok
        and finite_register_ok
        and finite_arithmetic_ok
    )
    if not finite_ok:
        error_class = "finite_matrix_counterexample"
        next_route = (
            "Reject the fixed-denominator route-interface packet and repair "
            "the source, register, or payload representation before Lean "
            "bridge work continues."
        )
    elif not bridge_normal_form_available:
        error_class = "shape_or_register_gap"
        next_route = (
            "Refresh the Lean surface for the fixed-denominator backend and "
            "the general bridge normal form before assigning bridge work."
        )
    elif flags["fixed_denom_bridge_normal_form_compiled"]:
        error_class = "symbolic_bridge_gap"
        next_route = (
            "The fixed-denominator bridge normal form already compiles; "
            "next introduce a transparent backend-to-route semantics witness "
            "for expandedArithmeticComputesCubicAmplitude n (3 * n), or an "
            "honest expandedArithmeticBackendBridge witness for "
            "fixedDenomCubicArithmeticBackend, before any root or export work."
        )
    else:
        error_class = "symbolic_bridge_gap"
        next_route = (
            "Prove the fixed-denominator bridge normal form "
            "fixedDenomCubicArithmeticBackend_bridge_iff, then introduce a "
            "transparent backend-to-route semantics witness before any "
            "bridge, root, or export work."
        )

    return {
        "task": TASK_ID,
        "leaf": LEAF,
        "blocked_parent": BLOCKED_PARENT,
        "role": "lower",
        "profile": "necessary-condition verifier",
        "source_correspondence_ok": source_correspondence_ok,
        "source_object": (
            "D_n[row,col] = if row = col then (row / 2^n)^3 else 0, "
            "alpha = 1"
        ),
        "necessary_condition": (
            "The route interface may only reuse the fixed-denominator "
            "backend if finite exact-rational instances preserve j, fit "
            "payload j^3 into Fin (gridSize (3*n)), and recover "
            "(j/2^n)^3 with zero off-diagonal support."
        ),
        "workspace_representation_specified": True,
        "workspace_qubits": "3 * n",
        "workspace": "Fin (gridSize (3 * n))",
        "clean_workspace": "0",
        "payload": "j.val ^ 3",
        "amplitude_projection": "payload / gridSize (3 * n)",
        "finite_register_ok": finite_register_ok,
        "finite_arithmetic_ok": finite_arithmetic_ok,
        "finite_matrix_ok": finite_matrix_ok,
        "finite_matrix_scope": (
            "source diagonal entries and backend-induced diagonal/support; "
            "not a unitary clean-block extraction"
        ),
        "support_vanish_ok": support_vanish_ok,
        "block_entry_ok": None,
        "ancilla_cleanup_ok": None,
        "normalizer_ok": normalizer_ok,
        "unitarity_ok": None,
        "route_predicate_closed": False,
        "executable_exports_created": False,
        "resource_score": None,
        "gate_count": None,
        "depth": None,
        "auxiliary_qubits": None,
        "oracle_calls": None,
        "lean_parse_ok": lean_parse_ok,
        "lean_build_ok": lean_build_ok,
        "closed_theorem_ok": False,
        "checked_ns": list(CHECKED_NS),
        "lean_surface": flags,
        "bridge_normal_form_available": bridge_normal_form_available,
        "fixed_denom_bridge_normal_form_status":
            "compiled" if flags["fixed_denom_bridge_normal_form_compiled"]
            else "not_compiled",
        "route_interface_normal_form_target": (
            "fixedDenomCubicArithmeticBackend_bridge_iff : "
            "expandedArithmeticBackendBridge "
            "(fixedDenomCubicArithmeticBackend n) <-> "
            "expandedArithmeticComputesCubicAmplitude n (3 * n)"
        ),
        "error_class": error_class,
        "next_route": next_route,
        "instances": instances,
    }


def field_text(value: Any) -> str:
    if value is True:
        return "true"
    if value is False:
        return "false"
    if value is None:
        return "null"
    return str(value)


def render_markdown(feedback: dict[str, Any]) -> str:
    checked = ", ".join(str(n) for n in feedback["checked_ns"])
    typed_fields = [
        "leaf",
        "blocked_parent",
        "source_correspondence_ok",
        "workspace_representation_specified",
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
        "error_class",
        "next_route",
    ]
    typed = "\n".join(
        f"{key}={field_text(feedback[key])}" for key in typed_fields
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
            "No finite source/register contradiction was found.  This supports "
            "the route-interface shape as a necessary condition, but it does "
            "not close the opaque expanded arithmetic route predicate."
        )
    else:
        verdict = (
            "The finite diagnostic contradicts the current route-interface "
            "shape.  The bridge/root/export route should be rejected until the "
            "source contract or register representation is repaired."
        )

    if feedback["fixed_denom_bridge_normal_form_status"] == "compiled":
        normal_form_note = (
            "The fixed-denominator normal-form target is already compiled.  "
            "The remaining route-interface work is a transparent semantics "
            "witness for the opaque expanded arithmetic route predicate."
        )
    else:
        normal_form_note = (
            "The first build-testable route-interface target remains the "
            "fixed-denominator normal-form theorem."
        )

    return "\n".join(
        [
            "# Verifier Feedback: DIAG-ARITH-ROUTE-INTERFACE-001",
            "",
            f"Task: `{feedback['task']}`",
            "",
            "## Active Leaf",
            "",
            "`DIAG-ARITH-ROUTE-INTERFACE-001` is the active source-contract",
            "leaf under the blocked parent `DIAG-ARITH-BACKEND-BRIDGE-001`.",
            "The diagnostic is necessary because the next Lean worker should",
            "only introduce a backend-to-route interface if the closed",
            "fixed-denominator backend still matches the user-provided",
            "diagonal operator and its register shape.",
            "",
            "## Executable Diagnostic",
            "",
            "Command:",
            "",
            "```bash",
            "python3 verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/diag_route_interface_check.py \\",
            "  --json-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-ARITH-ROUTE-INTERFACE-001.lower-necessary-20260620-074806.feedback.json \\",
            "  --md-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-ARITH-ROUTE-INTERFACE-001.lower-necessary-20260620-074806.md",
            "```",
            "",
            f"Checked finite instances: `{checked}`.  The `n = 0` case is",
            "included because current Lean declarations are over `Nat`; the",
            "source request still describes positive qubit counts.",
            "",
            "| n | grid | workspace qubits | max payload | capacity | workspace ok | payload ok | preserves j | amplitude ok | finite matrix ok | normalizer ok |",
            "|---|---:|---:|---:|---:|---|---|---|---|---|---|",
            *rows,
            "",
            "## Route-Interface Status",
            "",
            f"- general bridge normal form compiled: `{field_text(feedback['lean_surface']['general_bridge_normal_form_compiled'])}`",
            f"- fixed-denominator backend compiled: `{field_text(feedback['lean_surface']['fixed_denom_backend_compiled'])}`",
            f"- fixed-denominator compute proof compiled: `{field_text(feedback['lean_surface']['fixed_denom_backend_compute_compiled'])}`",
            f"- fixed-denominator bridge normal form compiled: `{field_text(feedback['lean_surface']['fixed_denom_bridge_normal_form_compiled'])}`",
            f"- route predicate is opaque: `{field_text(feedback['lean_surface']['route_predicate_is_opaque'])}`",
            "",
            normal_form_note,
            "",
            "```text",
            feedback["route_interface_normal_form_target"],
            "```",
            "",
            "This target is a normal-form diagnostic, not a route certificate.",
            "",
            "## Verdict",
            "",
            verdict,
            "",
            "Block-entry extraction, unitarity, clean uncompute, and executable",
            "exports remain `null` because no named Lean route certificate",
            "exists.",
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
        lean_parse_ok=nullable_bool(args.lean_parse_ok),
        lean_build_ok=nullable_bool(args.lean_build_ok),
    )
    encoded = json.dumps(feedback, indent=2, sort_keys=True)
    print(encoded)

    if args.json_out is not None:
        args.json_out.write_text(encoded + "\n", encoding="utf-8")
    if args.md_out is not None:
        args.md_out.write_text(render_markdown(feedback), encoding="utf-8")

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
