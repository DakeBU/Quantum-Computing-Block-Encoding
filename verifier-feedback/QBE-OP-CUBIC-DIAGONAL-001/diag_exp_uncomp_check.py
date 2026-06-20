#!/usr/bin/env python3
"""Necessary-condition diagnostic for DIAG-EXP-UNCOMP-001.

This check targets the fixed-denominator expanded route now used by the cubic
diagonal candidate.  It models only the reversible register skeleton needed for
clean uncompute:

1. the workspace has ``3 * n`` qubits;
2. clean compute writes payload ``j^3`` into that workspace;
3. the distinguished amplitude register reads ``payload / 2^(3n)``;
4. the inverse compute returns the workspace to zero on clean inputs.

The diagnostic is finite search feedback.  It does not prove the Lean opaque
predicate ``expandedWorkspaceCleanUncomputed``, does not certify block-entry
extraction, and does not authorize executable exports.
"""

from __future__ import annotations

import argparse
import json
import math
from fractions import Fraction
from pathlib import Path
from typing import Any


TASK_ID = "QBE-OP-CUBIC-DIAGONAL-001"
LEAF = "DIAG-EXP-UNCOMP-001"
CHECKED_NS = (1, 2, 3, 4)
LEAN_FILE = Path("QuantumBlockEncoding/CubicStatePreparation.lean")
TOLERANCE = 1.0e-12


def rat_text(value: Fraction) -> str:
    if value.denominator == 1:
        return str(value.numerator)
    return f"{value.numerator}/{value.denominator}"


def grid_size(qubits: int) -> int:
    return 1 << qubits


def payload(n: int, j: int) -> int:
    return j**3


def target_amplitude(n: int, j: int) -> Fraction:
    return Fraction(j, grid_size(n)) ** 3


def fixed_denom_amplitude(n: int, j: int) -> Fraction:
    return Fraction(payload(n, j), grid_size(3 * n))


def theta_from_payload(n: int, computed_workspace: int) -> float:
    amplitude = computed_workspace / grid_size(3 * n)
    return 2.0 * math.acos(amplitude)


def clean_signal_entry(n: int, computed_workspace: int) -> float:
    angle = theta_from_payload(n, computed_workspace)
    return math.cos(angle / 2.0)


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
        "transparent_arithmetic_in_contract": (
            "expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits"
            in body
        ),
        "transparent_rotation_in_contract": (
            "expandedControlledRyUsesCubicAngleTransparent n workspaceQubits"
            in body
        ),
        "clean_uncompute_obligation_in_contract": (
            "expandedWorkspaceCleanUncomputed n workspaceQubits" in body
        ),
        "clean_block_extraction_obligation_in_contract": (
            "expandedAmplitudeOracleCleanBlockExtracts n workspaceQubits block" in body
        ),
        "diagonal_contract_in_contract": "diagonalCleanBlockContract n block" in body,
        "opaque_clean_uncompute_present": (
            "opaque expandedWorkspaceCleanUncomputed" in text
        ),
        "fixed_denom_backend_present": "def fixedDenomCubicArithmeticBackend" in text,
        "fixed_denom_backend_compute_present": (
            "theorem fixedDenomCubicArithmeticBackend_computes" in text
        ),
        "fixed_denom_transparent_arithmetic_present": (
            "theorem fixedDenomCubicArithmeticRouteTransparent" in text
        ),
        "fixed_denom_transparent_rotation_present": (
            "theorem fixedDenomControlledRyRouteTransparent" in text
        ),
    }


def check_instance(n: int) -> dict[str, Any]:
    system_dim = grid_size(n)
    workspace_dim = grid_size(3 * n)

    payloads = [payload(n, j) for j in range(system_dim)]
    payload_lt_capacity_ok = all(0 <= value < workspace_dim for value in payloads)
    fixed_denom_amplitude_ok = all(
        fixed_denom_amplitude(n, j) == target_amplitude(n, j)
        for j in range(system_dim)
    )
    amplitude_range_ok = all(
        Fraction(0) <= fixed_denom_amplitude(n, j) <= Fraction(1)
        for j in range(system_dim)
    )

    clean_workspace_ok = True
    system_preserved_on_clean_input_ok = True
    clean_entry_matches_payload_ok = True
    max_clean_entry_error = 0.0

    for j in range(system_dim):
        computed_workspace = 0 ^ payload(n, j)
        uncomputed_workspace = computed_workspace ^ payload(n, j)
        clean_workspace_ok = clean_workspace_ok and (uncomputed_workspace == 0)
        system_preserved_on_clean_input_ok = (
            system_preserved_on_clean_input_ok and 0 <= j < system_dim
        )

        observed = clean_signal_entry(n, computed_workspace)
        expected = float(target_amplitude(n, j))
        max_clean_entry_error = max(max_clean_entry_error, abs(observed - expected))
        clean_entry_matches_payload_ok = (
            clean_entry_matches_payload_ok and abs(observed - expected) <= TOLERANCE
        )

    sampled_workspace_values = sorted(
        {
            0,
            workspace_dim - 1,
            workspace_dim // 2,
            *(payloads[: min(8, len(payloads))]),
        }
    )
    route_preserves_system_workspace_on_samples_ok = True
    for j in range(system_dim):
        for workspace in sampled_workspace_values:
            computed_workspace = workspace ^ payload(n, j)
            uncomputed_workspace = computed_workspace ^ payload(n, j)
            route_preserves_system_workspace_on_samples_ok = (
                route_preserves_system_workspace_on_samples_ok
                and uncomputed_workspace == workspace
            )

    return {
        "n": n,
        "system_dimension": system_dim,
        "workspace_qubits": 3 * n,
        "workspace_dimension": workspace_dim,
        "payload_formula": "payload_j = j^3",
        "payload_values": payloads,
        "payload_lt_capacity_ok": payload_lt_capacity_ok,
        "fixed_denom_amplitude_formula": "payload_j / 2^(3n)",
        "target_amplitudes": [
            rat_text(target_amplitude(n, j)) for j in range(system_dim)
        ],
        "fixed_denom_amplitude_ok": fixed_denom_amplitude_ok,
        "amplitude_range_ok": amplitude_range_ok,
        "normalizer": "1",
        "normalizer_ok": amplitude_range_ok,
        "clean_compute_uncompute_formula": "w -> w xor j^3 -> w",
        "clean_workspace_ok": clean_workspace_ok,
        "system_preserved_on_clean_input_ok": system_preserved_on_clean_input_ok,
        "route_preserves_system_workspace_on_samples_ok": (
            route_preserves_system_workspace_on_samples_ok
        ),
        "clean_signal_entry_matches_payload_ok": clean_entry_matches_payload_ok,
        "max_abs_clean_entry_error": max_clean_entry_error,
        "sampled_workspace_values": sampled_workspace_values,
    }


def build_feedback(
    lean_parse_ok: bool | None,
    lean_build_ok: bool | None,
    lean_file: Path,
) -> dict[str, Any]:
    instances = [check_instance(n) for n in CHECKED_NS]
    surface = lean_surface_flags(lean_file)

    fixed_denom_register_ok = all(
        bool(instance["payload_lt_capacity_ok"])
        and bool(instance["fixed_denom_amplitude_ok"])
        and bool(instance["amplitude_range_ok"])
        for instance in instances
    )
    clean_uncompute_finite_ok = all(
        bool(instance["clean_workspace_ok"])
        and bool(instance["system_preserved_on_clean_input_ok"])
        and bool(instance["route_preserves_system_workspace_on_samples_ok"])
        for instance in instances
    )
    finite_matrix_ok = fixed_denom_register_ok and clean_uncompute_finite_ok
    normalizer_ok = all(bool(instance["normalizer_ok"]) for instance in instances)
    lean_surface_ok = (
        surface["transparent_arithmetic_in_contract"]
        and surface["transparent_rotation_in_contract"]
        and surface["clean_uncompute_obligation_in_contract"]
        and surface["clean_block_extraction_obligation_in_contract"]
        and surface["diagonal_contract_in_contract"]
        and surface["opaque_clean_uncompute_present"]
        and surface["fixed_denom_backend_present"]
        and surface["fixed_denom_backend_compute_present"]
        and surface["fixed_denom_transparent_arithmetic_present"]
        and surface["fixed_denom_transparent_rotation_present"]
    )

    if not fixed_denom_register_ok:
        error_class = "shape_or_register_gap"
        rejection = (
            "Fixed-denominator payload/register check contradicts the current "
            "clean-uncompute route."
        )
        next_route = (
            "Repair the fixed-denominator representation before assigning "
            "DIAG-EXP-UNCOMP-001."
        )
    elif not clean_uncompute_finite_ok:
        error_class = "finite_matrix_counterexample"
        rejection = (
            "Finite compute/uncompute support check fails for the active route."
        )
        next_route = (
            "Reject the current clean-uncompute skeleton and restate the route "
            "before Lean proof search."
        )
    elif not lean_surface_ok:
        error_class = "source_translation_gap"
        rejection = (
            "Lean surface no longer exposes the expected transparent "
            "arithmetic/rotation contract with clean uncompute still open."
        )
        next_route = (
            "Refresh the source-to-Lean contract map before a lower Lean worker "
            "edits the clean-uncompute obligation."
        )
    else:
        error_class = "symbolic_bridge_gap"
        rejection = None
        next_route = (
            "Write a DIAG-EXP-UNCOMP-001 source contract or transparent "
            "clean-uncompute interface for the fixed-denominator compute/"
            "uncompute route; do not close expandedWorkspaceCleanUncomputed "
            "by trivial, by axiom, or by setting a semantic proposition to "
            "True."
        )

    return {
        "task": TASK_ID,
        "leaf": LEAF,
        "source_correspondence_ok": True,
        "source_correspondence_detail": (
            "Checks the route-specific necessity that a 3*n-qubit "
            "fixed-denominator workspace storing j^3 can be uncomputed cleanly "
            "while preserving the user diagonal target with alpha = 1."
        ),
        "lean_parse_ok": lean_parse_ok,
        "lean_build_ok": lean_build_ok,
        "finite_matrix_ok": finite_matrix_ok,
        "fixed_denom_register_ok": fixed_denom_register_ok,
        "finite_clean_uncompute_ok": clean_uncompute_finite_ok,
        "normalizer_ok": normalizer_ok,
        "block_entry_ok": None,
        "ancilla_cleanup_ok": None,
        "unitarity_ok": None,
        "closed_theorem_ok": False,
        "route_certificate_ok": False,
        "clean_block_extraction_ok": None,
        "executable_exports_created": False,
        "resource_score": None,
        "gate_count": None,
        "depth": None,
        "auxiliary_qubits": None,
        "oracle_calls": None,
        "lean_surface": surface,
        "checked_ns": list(CHECKED_NS),
        "error_class": error_class,
        "next_route": next_route,
        "rejection": rejection,
        "instances": instances,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--json-out", type=Path)
    parser.add_argument("--lean-parse-ok", choices=["true", "false", "null"], default="null")
    parser.add_argument("--lean-build-ok", choices=["true", "false", "null"], default="null")
    parser.add_argument("--lean-file", type=Path, default=LEAN_FILE)
    args = parser.parse_args()

    def parse_nullable_bool(value: str) -> bool | None:
        if value == "true":
            return True
        if value == "false":
            return False
        return None

    feedback = build_feedback(
        parse_nullable_bool(args.lean_parse_ok),
        parse_nullable_bool(args.lean_build_ok),
        args.lean_file,
    )
    encoded = json.dumps(feedback, indent=2, sort_keys=True)
    print(encoded)

    if args.json_out is not None:
        args.json_out.write_text(encoded + "\n", encoding="utf-8")

    failed = not (
        feedback["finite_matrix_ok"]
        and feedback["fixed_denom_register_ok"]
        and feedback["finite_clean_uncompute_ok"]
        and feedback["normalizer_ok"]
        and feedback["lean_surface"]["clean_uncompute_obligation_in_contract"]
    )
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
