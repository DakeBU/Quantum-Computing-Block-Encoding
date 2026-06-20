#!/usr/bin/env python3
"""Finite fixed-denominator diagnostic for DIAG-ARITH-FIXED-DENOM-CAP-001.

This is a necessary-condition check for the proposed arithmetic representation:
store the payload ``j^3`` in a ``3*n``-qubit register and read the amplitude as
``j^3 / 2^(3*n)``.  It does not prove a Lean theorem, certify a block encoding,
or authorize executable exports.
"""

from __future__ import annotations

import argparse
import json
from fractions import Fraction
from pathlib import Path
from typing import Any


TASK_ID = "QBE-OP-CUBIC-DIAGONAL-001"
LEAF = "DIAG-ARITH-FIXED-DENOM-CAP-001"
NEXT_LEAF = "DIAG-ARITH-FIXED-DENOM-ALG-001"
BLOCKED_PARENT = "DIAG-ARITH-BACKEND-BRIDGE-001"
CHECKED_NS = tuple(range(0, 7))


def rat_text(value: Fraction) -> str:
    if value.denominator == 1:
        return str(value.numerator)
    return f"{value.numerator}/{value.denominator}"


def grid_size(n: int) -> int:
    return 1 << n


def payload_capacity(n: int) -> int:
    return 1 << (3 * n)


def source_amplitude(n: int, j: int) -> Fraction:
    return Fraction(j, grid_size(n)) ** 3


def fixed_denom_amplitude(n: int, j: int) -> Fraction:
    return Fraction(j**3, payload_capacity(n))


def target_entry(n: int, row: int, col: int) -> Fraction:
    return fixed_denom_amplitude(n, row) if row == col else Fraction(0)


def check_instance(n: int) -> dict[str, Any]:
    size = grid_size(n)
    capacity = payload_capacity(n)
    payloads = [j**3 for j in range(size)]
    entries = [fixed_denom_amplitude(n, j) for j in range(size)]
    max_payload = max(payloads)

    capacity_ok = all(payload < capacity for payload in payloads)
    algebra_ok = all(
        fixed_denom_amplitude(n, j) == source_amplitude(n, j)
        for j in range(size)
    )
    diagonal_formula_ok = all(
        target_entry(n, j, j) == source_amplitude(n, j)
        for j in range(size)
    )
    off_diagonal_zero_ok = all(
        target_entry(n, row, col) == 0
        for row in range(size)
        for col in range(size)
        if row != col
    )
    normalizer_ok = all(0 <= entry <= 1 for entry in entries)

    return {
        "n": n,
        "grid_size": size,
        "workspace_qubits": 3 * n,
        "payload_capacity": capacity,
        "max_payload_j_cubed": max_payload,
        "max_payload_bits": max_payload.bit_length(),
        "payload_capacity_ok": capacity_ok,
        "payload_capacity_gap_at_max": capacity - 1 - max_payload,
        "fixed_denominator": capacity,
        "amplitude_formula": "j^3 / 2^(3*n)",
        "algebra_matches_cubic_amplitude": algebra_ok,
        "diagonal_formula_ok": diagonal_formula_ok,
        "off_diagonal_zero_ok": off_diagonal_zero_ok,
        "normalizer_ok": normalizer_ok,
        "diagonal_entries": [rat_text(entry) for entry in entries],
    }


def build_feedback() -> dict[str, Any]:
    instances = [check_instance(n) for n in CHECKED_NS]
    capacity_ok = all(bool(item["payload_capacity_ok"]) for item in instances)
    algebra_ok = all(
        bool(item["algebra_matches_cubic_amplitude"]) for item in instances
    )
    finite_matrix_ok = all(
        bool(item["diagonal_formula_ok"])
        and bool(item["off_diagonal_zero_ok"])
        and bool(item["normalizer_ok"])
        for item in instances
    )
    normalizer_ok = all(bool(item["normalizer_ok"]) for item in instances)
    finite_arithmetic_ok = capacity_ok and algebra_ok

    if not finite_matrix_ok or not finite_arithmetic_ok:
        error_class = "finite_matrix_counterexample"
        next_route = (
            "Repair the fixed-denominator representation before assigning "
            "fixedDenomCubicPayload_lt_capacity or fixedDenomCubicAmplitude_eq."
        )
    else:
        error_class = "lean_tactic_gap"
        next_route = (
            "Prove fixedDenomCubicPayload_lt_capacity, then "
            "fixedDenomCubicAmplitude_eq; keep block-entry, unitarity, "
            "exports, and the opaque backend bridge blocked."
        )

    return {
        "task": TASK_ID,
        "leaf": LEAF,
        "next_leaf": NEXT_LEAF,
        "blocked_parent": BLOCKED_PARENT,
        "role": "lower",
        "profile": "necessary-condition verifier",
        "source_correspondence_ok": True,
        "source_object": (
            "D_n[row,col] = if row = col then (row / 2^n)^3 else 0, "
            "alpha = 1"
        ),
        "workspace_representation_specified": True,
        "lean_representation_declared": False,
        "workspace_qubits": "3 * n",
        "payload": "j.val ^ 3",
        "payload_register": "Fin (gridSize (3 * n))",
        "payload_capacity_ok": capacity_ok,
        "finite_arithmetic_ok": finite_arithmetic_ok,
        "finite_matrix_ok": finite_matrix_ok,
        "block_entry_ok": None,
        "ancilla_cleanup_ok": None,
        "normalizer_ok": normalizer_ok,
        "unitarity_ok": None,
        "lean_parse_ok": None,
        "lean_build_ok": None,
        "closed_theorem_ok": False,
        "executable_exports_created": False,
        "checked_ns": list(CHECKED_NS),
        "lean_nat_edge_n0_checked": 0 in CHECKED_NS,
        "source_positive_ns_checked": [n for n in CHECKED_NS if n > 0],
        "error_class": error_class,
        "next_route": next_route,
        "instances": instances,
    }


def render_markdown(feedback: dict[str, Any]) -> str:
    def field_text(value: Any) -> str:
        if value is True:
            return "true"
        if value is False:
            return "false"
        if value is None:
            return "null"
        return str(value)

    typed_fields = [
        "leaf",
        "blocked_parent",
        "source_correspondence_ok",
        "workspace_representation_specified",
        "lean_representation_declared",
        "workspace_qubits",
        "payload_capacity_ok",
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
    checked = ", ".join(str(n) for n in feedback["checked_ns"])

    if feedback["finite_matrix_ok"] and feedback["finite_arithmetic_ok"]:
        verdict = (
            "No finite contradiction was found.  The diagnostic supports the "
            "fixed-denominator representation as a necessary condition, but it "
            "does not close any Lean theorem or certify a block encoding."
        )
    else:
        verdict = (
            "The finite diagnostic contradicts the current representation.  "
            "Middle should repair the source contract before Lean proof search."
        )

    instance_lines = []
    for item in feedback["instances"]:
        instance_lines.append(
            "| {n} | {grid_size} | {workspace_qubits} | {max_payload_j_cubed} | "
            "{payload_capacity} | {payload_capacity_ok} | "
            "{algebra_matches_cubic_amplitude} | {normalizer_ok} |".format(**item)
        )

    return "\n".join(
        [
            "# Verifier Feedback: DIAG-ARITH-FIXED-DENOM-CAP-001 Lower Necessary",
            "",
            f"Task: `{feedback['task']}`",
            "",
            "## Active Leaf",
            "",
            "`DIAG-ARITH-FIXED-DENOM-CAP-001` checks that the payload",
            "`j.val ^ 3` fits in the fixed workspace `Fin (gridSize (3 * n))`.",
            "This is necessary for the representation parent",
            "`DIAG-ARITH-REP-001`: without the capacity bound, the planned",
            "fixed-denominator backend cannot even name its payload register.",
            "",
            "The same finite diagnostic also checks the next algebra leaf:",
            "`j^3 / 2^(3*n) = (j / 2^n)^3`, so the representation still",
            "matches the diagonal source operator and the normalizer `alpha = 1`.",
            "",
            "## Executable Diagnostic",
            "",
            "Command:",
            "",
            "```bash",
            "python3 verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/diag_fixed_denom_check.py \\",
            "  --json-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-ARITH-FIXED-DENOM-CAP-001.lower-necessary-20260620-0550.feedback.json \\",
            "  --md-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-ARITH-FIXED-DENOM-CAP-001.lower-necessary-20260620-0550.md",
            "```",
            "",
            f"Checked finite instances: `{checked}`.  The `n = 0` case is",
            "included because the current Lean declarations are over `Nat`;",
            "the user-facing source still asks for positive `n`.",
            "",
            "| n | grid | workspace qubits | max payload | capacity | capacity ok | algebra ok | normalizer ok |",
            "|---|---:|---:|---:|---:|---|---|---|",
            *instance_lines,
            "",
            "## Verdict",
            "",
            verdict,
            "",
            "Block-entry extraction, unitarity, clean uncompute, and executable",
            "exports remain `null` because no named Lean route certificate exists.",
            "Direct proof search for `DIAG-ARITH-BACKEND-BRIDGE-001` remains",
            "blocked by the opaque route predicate.",
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
    args = parser.parse_args()

    feedback = build_feedback()
    encoded = json.dumps(feedback, indent=2, sort_keys=True)
    print(encoded)

    if args.json_out is not None:
        args.json_out.write_text(encoded + "\n", encoding="utf-8")
    if args.md_out is not None:
        args.md_out.write_text(render_markdown(feedback), encoding="utf-8")

    return 0 if feedback["finite_matrix_ok"] and feedback["finite_arithmetic_ok"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
