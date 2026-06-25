#!/usr/bin/env python3
"""Finite diagnostic for QBE-MAIN-CASE-HIER-PRO-001 circuit-image alignment.

The full basis index is

    signal * 8 + 4 * T + 2 * tau + S

so the wire map is S=0, tau=1, T=2, signal=3.  The diagnostic checks the
four-gate transcript CCX012; CX21; CX20; X2 against the task-local finite
candidate table.  It is verifier feedback only, not theorem closure.
"""

import json


TASK = "QBE-MAIN-CASE-HIER-PRO-001"
LEAF = "MAINCASE-PRO-CIRCUIT-IMAGE-001"


def flip_bit(x: int, bit: int) -> int:
    return x ^ (1 << bit)


def controlled_flip(x: int, control: int, target: int) -> int:
    if (x >> control) & 1:
        return flip_bit(x, target)
    return x


def ccx_type_time_signal(x: int) -> int:
    if ((x >> 1) & 1) and ((x >> 2) & 1):
        return flip_bit(x, 3)
    return x


def pro_transcript_image(x: int) -> int:
    x = ccx_type_time_signal(x)
    x = controlled_flip(x, 3, 2)
    x = controlled_flip(x, 3, 1)
    x = flip_bit(x, 3)
    return x


def task_candidate_image(x: int) -> int:
    table = {
        0: 8,
        1: 9,
        2: 10,
        3: 11,
        4: 12,
        5: 13,
        6: 0,
        7: 1,
        8: 2,
        9: 3,
        10: 4,
        11: 5,
        12: 6,
        13: 7,
        14: 14,
        15: 15,
    }
    return table[x]


def target_entry(row: int, col: int) -> int:
    return int((row, col) in {(0, 6), (1, 7)})


def clean_block_bad_entries() -> list[dict[str, int]]:
    bad = []
    for row in range(8):
        for col in range(8):
            actual = int(row == pro_transcript_image(col))
            expected = target_entry(row, col)
            if actual != expected:
                bad.append(
                    {
                        "row": row,
                        "col": col,
                        "actual": actual,
                        "expected": expected,
                    }
                )
    return bad


def main() -> None:
    rows = []
    mismatches = []
    for x in range(16):
        transcript = pro_transcript_image(x)
        candidate = task_candidate_image(x)
        row = {
            "input": x,
            "transcript": transcript,
            "candidate": candidate,
            "match": transcript == candidate,
        }
        rows.append(row)
        if not row["match"]:
            mismatches.append(row)

    bad_clean = clean_block_bad_entries()
    payload = {
        "task": TASK,
        "leaf": LEAF,
        "source_correspondence_ok": False,
        "finite_matrix_ok": len(mismatches) == 0,
        "block_entry_ok": len(bad_clean) == 0,
        "mismatch_inputs": [row["input"] for row in mismatches],
        "mismatches": mismatches,
        "clean_block_bad_entries": bad_clean,
        "normalizer_ok": True,
        "ancilla_cleanup_ok": True,
        "resource_score": "(4,4,1,0)",
        "auxiliary_qubits": 1,
        "gate_count": 4,
        "depth": 4,
        "oracle_calls": 0,
        "closed_theorem_ok": False,
        "error_class": "finite_matrix_counterexample",
        "next_route": (
            "Do not attempt mainCaseProCircuitImage_eq_candidate as stated; "
            "split the gate-derived Pro transcript image from "
            "mainCaseProCandidateImage or replace the candidate table only "
            "through a new Lean-checked candidate declaration."
        ),
        "all_rows": rows,
    }
    print(json.dumps(payload, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
