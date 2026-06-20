#!/usr/bin/env python3
"""Finite backend-shape diagnostic for DIAG-ARITH-FIXED-DENOM-BACKEND-001.

This checks the intended fixed-denominator compute-phase backend:

* workspace qubits are ``3 * n``;
* the clean workspace is the zero basis state;
* compute preserves the system index ``j``;
* compute writes payload ``j^3`` into ``Fin (gridSize (3 * n))``;
* the distinguished amplitude projection ``payload / 2^(3*n)`` equals
  ``(j / 2^n)^3``.

It is only a necessary-condition diagnostic.  It does not prove the Lean
backend theorem, close the opaque route bridge, certify block entries, prove
unitarity, or authorize executable exports.
"""

from __future__ import annotations

import argparse
import json
from fractions import Fraction
from pathlib import Path
from typing import Any


TASK_ID = "QBE-OP-CUBIC-DIAGONAL-001"
LEAF = "DIAG-ARITH-FIXED-DENOM-BACKEND-001"
BLOCKED_PARENT = "DIAG-ARITH-BACKEND-BRIDGE-001"
CHECKED_NS = tuple(range(0, 7))


def rat_text(value: Fraction) -> str:
    if value.denominator == 1:
        return str(value.numerator)
    return f"{value.numerator}/{value.denominator}"


def grid_size(n: int) -> int:
    return 1 << n


def workspace_capacity(n: int) -> int:
    return 1 << (3 * n)


def source_amplitude(n: int, j: int) -> Fraction:
    return Fraction(j, grid_size(n)) ** 3


def payload(n: int, j: int) -> int:
    del n
    return j**3


def amplitude_register(n: int, workspace_value: int) -> Fraction:
    return Fraction(workspace_value, workspace_capacity(n))


def compute(n: int, j: int, workspace_value: int) -> tuple[int, int]:
    del workspace_value
    return (j, payload(n, j))


def induced_diagonal_entry(n: int, row: int, col: int) -> Fraction:
    if row != col:
        return Fraction(0)
    out_j, out_workspace = compute(n, row, 0)
    if out_j != row:
        return Fraction(-1)
    return amplitude_register(n, out_workspace)


def check_instance(n: int) -> dict[str, Any]:
    size = grid_size(n)
    capacity = workspace_capacity(n)
    clean_workspace = 0
    rows = range(size)

    compute_rows = [compute(n, j, clean_workspace) for j in rows]
    payloads = [out_workspace for _, out_workspace in compute_rows]
    amplitudes = [amplitude_register(n, value) for value in payloads]

    workspace_shape_ok = capacity == grid_size(3 * n) and 0 <= clean_workspace < capacity
    payload_capacity_ok = all(0 <= value < capacity for value in payloads)
    system_preserved_ok = all(out_j == j for j, (out_j, _) in enumerate(compute_rows))
    amplitude_register_ok = all(
        amplitudes[j] == source_amplitude(n, j)
        for j in rows
    )
    induced_diagonal_ok = all(
        induced_diagonal_entry(n, j, j) == source_amplitude(n, j)
        for j in rows
    )
    induced_off_diagonal_zero_ok = all(
        induced_diagonal_entry(n, row, col) == 0
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
        "system_preserved_ok": system_preserved_ok,
        "amplitude_register_ok": amplitude_register_ok,
        "induced_diagonal_ok": induced_diagonal_ok,
        "induced_off_diagonal_zero_ok": induced_off_diagonal_zero_ok,
        "normalizer_ok": normalizer_ok,
        "amplitudes": [rat_text(value) for value in amplitudes],
    }


def build_feedback() -> dict[str, Any]:
    instances = [check_instance(n) for n in CHECKED_NS]
    finite_register_ok = all(
        item["workspace_shape_ok"] and item["payload_capacity_ok"]
        for item in instances
    )
    finite_backend_compute_ok = all(
        item["system_preserved_ok"] and item["amplitude_register_ok"]
        for item in instances
    )
    finite_matrix_ok = all(
        item["induced_diagonal_ok"] and item["induced_off_diagonal_zero_ok"]
        for item in instances
    )
    normalizer_ok = all(item["normalizer_ok"] for item in instances)

    passed = (
        finite_register_ok
        and finite_backend_compute_ok
        and finite_matrix_ok
        and normalizer_ok
    )
    if passed:
        error_class = "lean_tactic_gap"
        next_route = (
            "Implement fixedDenomCubicArithmeticBackend and prove "
            "fixedDenomCubicArithmeticBackend_computes using "
            "fixedDenomCubicPayload_lt_capacity and fixedDenomCubicAmplitude_eq; "
            "keep the opaque backend bridge blocked."
        )
    else:
        error_class = "finite_matrix_counterexample"
        next_route = (
            "Reject the fixed-denominator backend shape and repair the "
            "workspace payload or source contract before assigning Lean proof."
        )

    return {
        "task": TASK_ID,
        "leaf": LEAF,
        "blocked_parent": BLOCKED_PARENT,
        "role": "lower",
        "profile": "necessary-condition verifier",
        "source_correspondence_ok": True,
        "source_object": (
            "D_n[row,col] = if row = col then (row / 2^n)^3 else 0, "
            "alpha = 1"
        ),
        "workspace_representation_specified": True,
        "workspace_qubits": "3 * n",
        "workspace": "Fin (gridSize (3 * n))",
        "clean_workspace": "0",
        "payload": "j.val ^ 3",
        "amplitude_projection": "payload / gridSize (3 * n)",
        "finite_register_ok": finite_register_ok,
        "finite_backend_compute_ok": finite_backend_compute_ok,
        "finite_matrix_ok": finite_matrix_ok,
        "block_entry_ok": None,
        "ancilla_cleanup_ok": None,
        "normalizer_ok": normalizer_ok,
        "unitarity_ok": None,
        "executable_exports_created": False,
        "lean_parse_ok": None,
        "lean_build_ok": None,
        "closed_theorem_ok": False,
        "checked_ns": list(CHECKED_NS),
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
        "workspace_qubits",
        "finite_register_ok",
        "finite_backend_compute_ok",
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

    if feedback["finite_matrix_ok"] and feedback["finite_backend_compute_ok"]:
        verdict = (
            "No finite contradiction was found for the active backend shape. "
            "The check is a necessary condition only; it does not close the "
            "Lean compute theorem or any block-encoding certificate."
        )
    else:
        verdict = (
            "The finite diagnostic contradicts the current backend shape. "
            "Middle should reject this representation before more Lean proof "
            "search."
        )

    instance_lines = []
    for item in feedback["instances"]:
        instance_lines.append(
            "| {n} | {grid_size} | {workspace_qubits} | {max_payload_j_cubed} | "
            "{workspace_capacity} | {workspace_shape_ok} | {payload_capacity_ok} | "
            "{system_preserved_ok} | {amplitude_register_ok} | {normalizer_ok} |".format(**item)
        )

    return "\n".join(
        [
            "# Verifier Feedback: DIAG-ARITH-FIXED-DENOM-BACKEND-001",
            "",
            f"Task: `{feedback['task']}`",
            "",
            "## Active Leaf",
            "",
            "`DIAG-ARITH-FIXED-DENOM-BACKEND-001` is the active compute-phase",
            "backend leaf.  The diagnostic is necessary because the planned",
            "Lean theorem must show that the backend preserves the system index",
            "and writes a workspace whose distinguished amplitude register is",
            "`CubicStatePreparation.cubicAmplitude n j`.",
            "",
            "The finite model uses workspace `Fin (gridSize (3 * n))`, clean",
            "workspace `0`, payload `j^3`, and projection",
            "`payload / gridSize (3 * n)`.  If this model failed on finite",
            "instances, the Lean worker would be proving the wrong backend.",
            "",
            "## Executable Diagnostic",
            "",
            "Command:",
            "",
            "```bash",
            "python3 verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/diag_fixed_denom_backend_check.py \\",
            "  --json-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-ARITH-FIXED-DENOM-BACKEND-001.lower-necessary-20260620-065526.feedback.json \\",
            "  --md-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-ARITH-FIXED-DENOM-BACKEND-001.lower-necessary-20260620-065526.md",
            "```",
            "",
            f"Checked finite instances: `{checked}`.  The `n = 0` case is",
            "included because current Lean declarations are over `Nat`; the",
            "source request still describes positive qubit counts.",
            "",
            "| n | grid | workspace qubits | max payload | capacity | workspace ok | payload ok | preserves j | amplitude ok | normalizer ok |",
            "|---|---:|---:|---:|---:|---|---|---|---|---|",
            *instance_lines,
            "",
            "## Verdict",
            "",
            verdict,
            "",
            "Block-entry extraction, unitarity, clean uncompute, and executable",
            "exports remain `null` because no named Lean route certificate exists.",
            "`DIAG-ARITH-BACKEND-BRIDGE-001` remains blocked by the opaque route",
            "predicate.",
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

    passed = (
        feedback["finite_register_ok"]
        and feedback["finite_backend_compute_ok"]
        and feedback["finite_matrix_ok"]
        and feedback["normalizer_ok"]
    )
    return 0 if passed else 1


if __name__ == "__main__":
    raise SystemExit(main())
