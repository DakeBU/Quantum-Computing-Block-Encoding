#!/usr/bin/env python3
"""Current-leaf finite diagnostic for fixed-denominator clean uncompute.

This wrapper reuses the modular add/sub checker and retargets its typed
feedback to `DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001`.  It is verifier
feedback only: it does not prove the opaque cleanup predicate, extraction,
unitarity, the root block-encoding certificate, or executable exports.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import diag_exp_uncomp_mod_add_sub_check as base


LEAF = "DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001"
CHECKED_SUBLEAF = "DIAG-EXP-UNCOMP-REV-LIFT-001"
SEPARATE_DEPENDENCY = "DIAG-RY-WORKSPACE-READONLY-001"
BLOCKED_PARENT = "DIAG-EXP-UNCOMP-001"


def build_feedback(
    lean_parse_ok: bool | None,
    lean_build_ok: bool | None,
    lean_file: Path,
) -> dict[str, object]:
    feedback = base.build_feedback(lean_parse_ok, lean_build_ok, lean_file)
    feedback.update(
        {
            "leaf": LEAF,
            "checked_subleaf": CHECKED_SUBLEAF,
            "separate_dependency": SEPARATE_DEPENDENCY,
            "blocked_parent": BLOCKED_PARENT,
            "source_correspondence_detail": (
                "Checks the active fixed-denominator cleanup witness route: "
                "modular addition of j^3 into a 3*n-qubit workspace, "
                "finite identity-read rotation behavior, and modular "
                "subtraction back to clean workspace, while preserving the "
                "diagonal target and alpha = 1."
            ),
        }
    )

    if feedback.get("error_class") == "symbolic_bridge_gap":
        feedback["next_route"] = (
            "Implement the fixed-denominator modular add/sub witness for "
            "expandedWorkspaceCleanUncomputedTransparent n (3 * n), and "
            "separately state DIAG-RY-WORKSPACE-READONLY-001 before using "
            "cleanup evidence for any route-level clean-uncompute, block-entry, "
            "unitarity, root, or export claim."
        )
    return feedback


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--json-out", type=Path)
    parser.add_argument("--lean-parse-ok", choices=["true", "false", "null"], default="null")
    parser.add_argument("--lean-build-ok", choices=["true", "false", "null"], default="null")
    parser.add_argument("--lean-file", type=Path, default=base.LEAN_FILE)
    args = parser.parse_args()

    feedback = build_feedback(
        base.parse_nullable_bool(args.lean_parse_ok),
        base.parse_nullable_bool(args.lean_build_ok),
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
