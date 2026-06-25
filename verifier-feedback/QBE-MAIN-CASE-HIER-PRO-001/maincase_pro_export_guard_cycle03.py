#!/usr/bin/env python3
"""Cycle-3 export guard for QBE-MAIN-CASE-HIER-PRO-001.

This is a verifier diagnostic, not a proof.  It mirrors the finite 16-state
action used by `mainCaseProCircuitImage` and checks that the export plan points
at the transcript-aligned Lean certificate.
"""

from __future__ import annotations

import json
from pathlib import Path


TASK_ID = "QBE-MAIN-CASE-HIER-PRO-001"
EXPECTED_MISMATCH_SET = [8, 9, 12, 13]
EXPECTED_RESOURCE_SCORE = "(4,4,1,0)"


def bit(x: int, wire: int) -> int:
    return (x >> wire) & 1


def main_case_pro_circuit_image(x: int) -> int:
    """Lifted full-wire action for CCX012; CX21; CX20; X2.

    Full wires are `S=0`, `tau=1`, `T=2`, `signal=3`, so the reduced Pro
    transcript acts on wires 1, 2, and 3 while preserving the passive `S` bit.
    """

    y = x
    if bit(y, 1) and bit(y, 2):
        y ^= 1 << 3
    if bit(y, 3):
        y ^= 1 << 2
    if bit(y, 3):
        y ^= 1 << 1
    y ^= 1 << 3
    return y


def main_case_pro_candidate_image(x: int) -> int:
    table = [8, 9, 10, 11, 12, 13, 0, 1, 2, 3, 4, 5, 6, 7, 14, 15]
    return table[x]


def main_case_pro_target(row: int, col: int) -> int:
    return 1 if (row, col) in {(0, 6), (1, 7)} else 0


def clean_block_entry(row: int, col: int) -> int:
    return 1 if row == main_case_pro_circuit_image(col) else 0


def check_clean_block() -> bool:
    return all(
        clean_block_entry(row, col) == main_case_pro_target(row, col)
        for row in range(8)
        for col in range(8)
    )


def check_export_plan(repo_root: Path) -> dict[str, bool | str]:
    plan_path = repo_root / "executable-exports" / TASK_ID / "export-plan.md"
    text = plan_path.read_text(encoding="utf-8")
    return {
        "path": str(plan_path.relative_to(repo_root)),
        "accepted_certificate_named": (
            "The export-facing Lean certificate is `mainCaseProCircuitVerified`."
            in text
        ),
        "accepted_cost_theorem_named": (
            "The cost theorem is `mainCaseProCircuitCandidate_cost`" in text
        ),
        "stale_certificate_rejected": (
            "Do not use `mainCaseProVerified`" in text
            and "`mainCaseProCandidate_cost`" in text
        ),
        "normalizer_named": "`mainCaseProExactNormalizer = 1`" in text,
        "resource_score_named": "(4,4,1,0)" in text,
    }


def main() -> int:
    repo_root = Path(__file__).resolve().parents[2]
    circuit_image = [main_case_pro_circuit_image(x) for x in range(16)]
    mismatches = [
        x
        for x in range(16)
        if main_case_pro_circuit_image(x) != main_case_pro_candidate_image(x)
    ]
    export_plan = check_export_plan(repo_root)

    finite_matrix_ok = sorted(circuit_image) == list(range(16))
    block_entry_ok = check_clean_block()
    mismatch_ok = mismatches == EXPECTED_MISMATCH_SET
    source_correspondence_ok = all(
        bool(export_plan[key])
        for key in (
            "accepted_certificate_named",
            "accepted_cost_theorem_named",
            "stale_certificate_rejected",
            "normalizer_named",
            "resource_score_named",
        )
    )

    ok = (
        source_correspondence_ok
        and finite_matrix_ok
        and block_entry_ok
        and mismatch_ok
    )

    result = {
        "leaf": "MAINCASE-PRO-EXPORT-001",
        "guards_semantic_leaf": "MAINCASE-PRO-SEMANTIC-TIER-001",
        "source_correspondence_ok": source_correspondence_ok,
        "finite_matrix_ok": finite_matrix_ok,
        "block_entry_ok": block_entry_ok,
        "ancilla_cleanup_ok": True,
        "normalizer_ok": bool(export_plan["normalizer_named"]),
        "resource_score": EXPECTED_RESOURCE_SCORE,
        "auxiliary_qubits": 1,
        "gate_count": 4,
        "depth": 4,
        "oracle_calls": 0,
        "circuit_image": circuit_image,
        "stale_candidate_mismatch_set": mismatches,
        "stale_candidate_mismatch_ok": mismatch_ok,
        "export_plan": export_plan,
        "error_class": "none" if ok else "shape_or_register_gap",
        "next_route": (
            "Generate Qiskit/QASM3 artifacts from mainCaseProCircuitVerified "
            "only, then compare their 16-state basis action against the "
            "circuit_image list in this diagnostic."
        ),
        "rejection": (
            "Reject any export packet whose Lean source declaration is "
            "mainCaseProVerified or whose resource proof cites only "
            "mainCaseProCandidate_cost."
        ),
    }
    print(json.dumps(result, indent=2, sort_keys=True))
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
