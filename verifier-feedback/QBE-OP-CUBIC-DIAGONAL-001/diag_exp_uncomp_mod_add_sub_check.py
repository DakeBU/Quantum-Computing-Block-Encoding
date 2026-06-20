#!/usr/bin/env python3
"""Finite diagnostic for the modular add/sub clean-uncompute route.

This checker targets the current clean-uncompute frontier for
QBE-OP-CUBIC-DIAGONAL-001.  It tests the fixed-denominator arithmetic route
proposed for the transparent cleanup interface:

* workspace size is ``2^(3*n)``;
* payload is ``p_j = j^3``;
* compute is modular addition by ``p_j``;
* uncompute is modular subtraction by ``p_j``;
* the controlled-rotation step is modeled only as a read-only workspace use.

The result is verifier feedback, not theorem closure.  It does not prove the
opaque Lean predicate ``expandedWorkspaceCleanUncomputed`` and does not certify
block-entry extraction, unitarity, or executable exports.
"""

from __future__ import annotations

import argparse
import json
from fractions import Fraction
from pathlib import Path
from typing import Any


TASK_ID = "QBE-OP-CUBIC-DIAGONAL-001"
LEAF = "DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001"
CHECKED_SUBLEAF = "DIAG-EXP-UNCOMP-REV-LIFT-001"
BLOCKED_PARENT = "DIAG-EXP-UNCOMP-001"
CHECKED_NS = (1, 2, 3, 4)
LEAN_FILE = Path("QuantumBlockEncoding/CubicStatePreparation.lean")


def rat_text(value: Fraction) -> str:
    if value.denominator == 1:
        return str(value.numerator)
    return f"{value.numerator}/{value.denominator}"


def grid_size(qubits: int) -> int:
    return 1 << qubits


def payload(j: int) -> int:
    return j**3


def target_amplitude(n: int, j: int) -> Fraction:
    return Fraction(j, grid_size(n)) ** 3


def fixed_denom_amplitude(n: int, j: int) -> Fraction:
    return Fraction(payload(j), grid_size(3 * n))


def compute_step(n: int, j: int, workspace: int) -> tuple[int, int]:
    modulus = grid_size(3 * n)
    return (j, (workspace + payload(j)) % modulus)


def uncompute_step(n: int, j: int, workspace: int) -> tuple[int, int]:
    modulus = grid_size(3 * n)
    return (j, (workspace + modulus - payload(j)) % modulus)


def rotation_read_step(_n: int, j: int, workspace: int) -> tuple[int, int]:
    """Finite model of a controlled rotation that reads but does not write."""
    return (j, workspace)


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
        "opaque_clean_uncompute_present": (
            "opaque expandedWorkspaceCleanUncomputed" in text
        ),
        "clean_uncompute_obligation_in_contract": (
            "expandedWorkspaceCleanUncomputed n workspaceQubits" in body
        ),
        "clean_block_extraction_obligation_in_contract": (
            "expandedAmplitudeOracleCleanBlockExtracts n workspaceQubits block"
            in body
        ),
        "diagonal_contract_in_contract": "diagonalCleanBlockContract n block" in body,
        "fixed_denom_backend_present": "def fixedDenomCubicArithmeticBackend" in text,
        "fixed_denom_backend_compute_present": (
            "theorem fixedDenomCubicArithmeticBackend_computes" in text
        ),
        "transparent_uncompute_interface_present": (
            "ExpandedArithmeticCleanUncomputeWitness" in text
            and "expandedWorkspaceCleanUncomputedTransparent" in text
        ),
        "rotation_workspace_readonly_statement_present": (
            "WorkspaceReadOnly" in text
            or "workspaceReadOnly" in text
            or "rotationWorkspaceReadOnly" in text
        ),
    }


def check_instance(n: int) -> dict[str, Any]:
    system_dim = grid_size(n)
    workspace_dim = grid_size(3 * n)

    payloads = [payload(j) for j in range(system_dim)]
    payload_lt_capacity_ok = all(0 <= value < workspace_dim for value in payloads)
    fixed_denom_amplitude_ok = all(
        fixed_denom_amplitude(n, j) == target_amplitude(n, j)
        for j in range(system_dim)
    )
    normalizer_ok = all(
        Fraction(0) <= fixed_denom_amplitude(n, j) <= Fraction(1)
        for j in range(system_dim)
    )

    compute_clean_matches_backend_ok = all(
        compute_step(n, j, 0) == (j, payload(j))
        for j in range(system_dim)
    )
    compute_preserves_index_ok = True
    uncompute_preserves_index_ok = True
    uncompute_after_compute_all_workspace_ok = True
    compute_after_uncompute_all_workspace_ok = True
    compute_step_bijection_per_index_ok = True

    for j in range(system_dim):
        image = set()
        for workspace in range(workspace_dim):
            computed = compute_step(n, j, workspace)
            uncomputed = uncompute_step(n, j, computed[1])
            subtracted = uncompute_step(n, j, workspace)
            recomputed = compute_step(n, j, subtracted[1])

            compute_preserves_index_ok = compute_preserves_index_ok and computed[0] == j
            uncompute_preserves_index_ok = (
                uncompute_preserves_index_ok
                and uncomputed[0] == j
                and subtracted[0] == j
            )
            uncompute_after_compute_all_workspace_ok = (
                uncompute_after_compute_all_workspace_ok
                and uncomputed == (j, workspace)
            )
            compute_after_uncompute_all_workspace_ok = (
                compute_after_uncompute_all_workspace_ok
                and recomputed == (j, workspace)
            )
            image.add(computed[1])
        compute_step_bijection_per_index_ok = (
            compute_step_bijection_per_index_ok and len(image) == workspace_dim
        )

    rotation_workspace_readonly_ok = True
    clean_compute_rotation_uncompute_ok = True
    for j in range(system_dim):
        computed = compute_step(n, j, 0)
        rotated = rotation_read_step(n, computed[0], computed[1])
        rotation_workspace_readonly_ok = (
            rotation_workspace_readonly_ok and rotated == computed
        )
        final = uncompute_step(n, rotated[0], rotated[1])
        clean_compute_rotation_uncompute_ok = (
            clean_compute_rotation_uncompute_ok and final == (j, 0)
        )

    finite_mod_add_sub_cleanup_ok = (
        payload_lt_capacity_ok
        and compute_clean_matches_backend_ok
        and compute_preserves_index_ok
        and uncompute_preserves_index_ok
        and uncompute_after_compute_all_workspace_ok
        and compute_after_uncompute_all_workspace_ok
        and compute_step_bijection_per_index_ok
        and rotation_workspace_readonly_ok
        and clean_compute_rotation_uncompute_ok
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
        "normalizer": "1",
        "normalizer_ok": normalizer_ok,
        "compute_formula": "w -> (w + j^3) mod 2^(3n)",
        "uncompute_formula": "w -> (w + 2^(3n) - j^3) mod 2^(3n)",
        "compute_clean_matches_backend_ok": compute_clean_matches_backend_ok,
        "compute_preserves_index_ok": compute_preserves_index_ok,
        "uncompute_preserves_index_ok": uncompute_preserves_index_ok,
        "uncompute_after_compute_all_workspace_ok": (
            uncompute_after_compute_all_workspace_ok
        ),
        "compute_after_uncompute_all_workspace_ok": (
            compute_after_uncompute_all_workspace_ok
        ),
        "compute_step_bijection_per_index_ok": compute_step_bijection_per_index_ok,
        "rotation_workspace_readonly_ok": rotation_workspace_readonly_ok,
        "clean_compute_rotation_uncompute_ok": clean_compute_rotation_uncompute_ok,
        "finite_mod_add_sub_cleanup_ok": finite_mod_add_sub_cleanup_ok,
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
        and bool(instance["normalizer_ok"])
        for instance in instances
    )
    finite_mod_add_sub_cleanup_ok = all(
        bool(instance["finite_mod_add_sub_cleanup_ok"]) for instance in instances
    )
    rotation_workspace_readonly_ok = all(
        bool(instance["rotation_workspace_readonly_ok"]) for instance in instances
    )
    finite_matrix_ok = (
        fixed_denom_register_ok
        and finite_mod_add_sub_cleanup_ok
        and rotation_workspace_readonly_ok
    )
    source_correspondence_ok = (
        surface["transparent_arithmetic_in_contract"]
        and surface["transparent_rotation_in_contract"]
        and surface["opaque_clean_uncompute_present"]
        and surface["clean_uncompute_obligation_in_contract"]
        and surface["fixed_denom_backend_present"]
        and surface["fixed_denom_backend_compute_present"]
    )

    if not fixed_denom_register_ok:
        error_class = "shape_or_register_gap"
        rejection = (
            "The fixed-denominator payload/register check contradicts the "
            "current modular add/sub cleanup route."
        )
        next_route = (
            "Repair the fixed-denominator workspace representation before "
            "assigning the clean-uncompute interface or witness."
        )
    elif not finite_mod_add_sub_cleanup_ok or not rotation_workspace_readonly_ok:
        error_class = "finite_matrix_counterexample"
        rejection = (
            "The finite modular add/sub cleanup route fails the necessary "
            "compute-read-uncompute support check."
        )
        next_route = (
            "Reject the modular add/sub cleanup route and restate the "
            "clean-uncompute proof leaf before Lean proof search."
        )
    elif not source_correspondence_ok:
        error_class = "source_translation_gap"
        rejection = (
            "The Lean surface no longer matches the expected expanded-route "
            "contract boundary for this diagnostic."
        )
        next_route = (
            "Refresh the source-to-Lean map before using the modular add/sub "
            "diagnostic as evidence for a Lean leaf."
        )
    else:
        error_class = "symbolic_bridge_gap"
        rejection = None
        if surface["transparent_uncompute_interface_present"]:
            next_route = (
                "Instantiate the fixed-denominator modular add/sub witness for "
                "the transparent clean-uncompute interface and add a named "
                "workspace-readonly rotation statement; keep block-entry, "
                "extraction, unitarity, root certificate, and exports blocked."
            )
        else:
            next_route = (
                "Compile the transparent clean-uncompute interface, then "
                "instantiate the fixed-denominator modular add/sub witness and "
                "add a named workspace-readonly rotation statement; keep "
                "block-entry, extraction, unitarity, root certificate, and "
                "exports blocked."
            )

    return {
        "task": TASK_ID,
        "leaf": LEAF,
        "checked_subleaf": CHECKED_SUBLEAF,
        "blocked_parent": BLOCKED_PARENT,
        "source_correspondence_ok": source_correspondence_ok,
        "source_correspondence_detail": (
            "Checks a necessary finite/register condition for the diagonal "
            "expanded route: modular addition of j^3 into a 3*n-qubit "
            "workspace, read-only rotation use, and modular subtraction back "
            "to the clean workspace, while preserving alpha = 1."
        ),
        "lean_parse_ok": lean_parse_ok,
        "lean_build_ok": lean_build_ok,
        "finite_matrix_ok": finite_matrix_ok,
        "fixed_denom_register_ok": fixed_denom_register_ok,
        "finite_mod_add_sub_cleanup_ok": finite_mod_add_sub_cleanup_ok,
        "rotation_workspace_readonly_ok": rotation_workspace_readonly_ok,
        "rotation_workspace_readonly_scope": (
            "finite identity-read model only; no Lean route-semantics "
            "certificate is claimed"
        ),
        "transparent_uncompute_interface_present": surface[
            "transparent_uncompute_interface_present"
        ],
        "lean_rotation_workspace_readonly_statement_present": surface[
            "rotation_workspace_readonly_statement_present"
        ],
        "normalizer_ok": all(bool(instance["normalizer_ok"]) for instance in instances),
        "block_entry_ok": None,
        "ancilla_cleanup_ok": None,
        "unitarity_ok": None,
        "clean_block_extraction_ok": None,
        "closed_theorem_ok": False,
        "route_certificate_ok": False,
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


def parse_nullable_bool(value: str) -> bool | None:
    if value == "true":
        return True
    if value == "false":
        return False
    return None


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--json-out", type=Path)
    parser.add_argument("--lean-parse-ok", choices=["true", "false", "null"], default="null")
    parser.add_argument("--lean-build-ok", choices=["true", "false", "null"], default="null")
    parser.add_argument("--lean-file", type=Path, default=LEAN_FILE)
    args = parser.parse_args()

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
        and feedback["finite_mod_add_sub_cleanup_ok"]
        and feedback["rotation_workspace_readonly_ok"]
        and feedback["normalizer_ok"]
        and feedback["source_correspondence_ok"]
    )
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
