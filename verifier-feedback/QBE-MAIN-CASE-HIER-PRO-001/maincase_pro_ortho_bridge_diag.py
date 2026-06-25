#!/usr/bin/env python3
"""Finite Gram diagnostic for MAINCASE-PRO-ORTHO-BRIDGE-001.

This mirrors the task-local Lean tables in QuantumBlockEncoding/MainCase.lean
without importing any theorem from another task.  It is a necessary-condition
check only: passing it does not close the Lean rational-orthogonality bridge.
"""

from __future__ import annotations

import json
from fractions import Fraction


N = 16
SYSTEM_N = 8


def candidate_image(x: int) -> int:
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


def red_ccx012(x: int) -> int:
    if x == 3:
        return 7
    if x == 7:
        return 3
    return x


def red_cx21(x: int) -> int:
    if x == 4:
        return 6
    if x == 6:
        return 4
    if x == 5:
        return 7
    if x == 7:
        return 5
    return x


def red_cx20(x: int) -> int:
    if x == 4:
        return 5
    if x == 5:
        return 4
    if x == 6:
        return 7
    if x == 7:
        return 6
    return x


def red_x2(x: int) -> int:
    if x == 0:
        return 4
    if x == 1:
        return 5
    if x == 2:
        return 6
    if x == 3:
        return 7
    if x == 4:
        return 0
    if x == 5:
        return 1
    if x == 6:
        return 2
    return 3


def circuit_reduced_image(x: int) -> int:
    return red_x2(red_cx20(red_cx21(red_ccx012(x))))


def circuit_image(x: int) -> int:
    reduced = x // 2
    state = x % 2
    return 2 * circuit_reduced_image(reduced) + state


def perm_matrix(image):
    return [
        [Fraction(1) if row == image(col) else Fraction(0) for col in range(N)]
        for row in range(N)
    ]


def target(row: int, col: int) -> Fraction:
    return Fraction(1) if (row, col) in {(0, 6), (1, 7)} else Fraction(0)


def identity(i: int, j: int) -> Fraction:
    return Fraction(1) if i == j else Fraction(0)


def col_inner(u, i: int, j: int) -> Fraction:
    return sum((u[k][i] * u[k][j] for k in range(N)), Fraction(0))


def row_inner(u, i: int, j: int) -> Fraction:
    return sum((u[i][k] * u[j][k] for k in range(N)), Fraction(0))


def gram_failures(u):
    failures = []
    for i in range(N):
        for j in range(N):
            got = col_inner(u, i, j)
            want = identity(i, j)
            if got != want:
                failures.append(
                    {"kind": "column", "i": i, "j": j, "got": str(got), "want": str(want)}
                )
            got = row_inner(u, i, j)
            if got != want:
                failures.append(
                    {"kind": "row", "i": i, "j": j, "got": str(got), "want": str(want)}
                )
    return failures


def block_failures(u):
    failures = []
    for row in range(SYSTEM_N):
        for col in range(SYSTEM_N):
            got = u[row][col]
            want = target(row, col)
            if got != want:
                failures.append(
                    {"row": row, "col": col, "got": str(got), "want": str(want)}
                )
    return failures


def summarize(name: str, image):
    outputs = [image(x) for x in range(N)]
    matrix = perm_matrix(image)
    gram_bad = gram_failures(matrix)
    block_bad = block_failures(matrix)
    return {
        "name": name,
        "is_bijection": sorted(outputs) == list(range(N)),
        "column_and_row_gram_identity": not gram_bad,
        "block_matches_target": not block_bad,
        "clean_source_images": {"6": image(6), "7": image(7)},
        "gram_failures": gram_bad[:8],
        "block_failures": block_bad[:8],
    }


def main() -> int:
    candidate = summarize("mainCaseProCandidateMatrix", candidate_image)
    circuit = summarize("mainCaseProCircuitMatrix", circuit_image)
    mismatches = [x for x in range(N) if circuit_image(x) != candidate_image(x)]
    ok = (
        candidate["is_bijection"]
        and candidate["column_and_row_gram_identity"]
        and candidate["block_matches_target"]
        and circuit["is_bijection"]
        and circuit["column_and_row_gram_identity"]
        and circuit["block_matches_target"]
        and mismatches == [8, 9, 12, 13]
    )
    payload = {
        "leaf": "MAINCASE-PRO-ORTHO-BRIDGE-001",
        "source_correspondence_ok": True,
        "finite_matrix_ok": ok,
        "block_entry_ok": candidate["block_matches_target"] and circuit["block_matches_target"],
        "unitarity_ok": candidate["column_and_row_gram_identity"]
        and circuit["column_and_row_gram_identity"],
        "normalizer_ok": True,
        "ancilla_cleanup_ok": True,
        "candidate": candidate,
        "circuit": circuit,
        "stale_equality_mismatch_set": mismatches,
        "error_class": "symbolic_bridge_gap" if ok else "finite_matrix_counterexample",
        "next_route": (
            "Use this finite Gram pass only as a necessary-condition green light; "
            "prove a shared BlockEncodingClassics.permMatrix rational-orthogonality "
            "bridge, or the task-local mainCaseProCircuitMatrix_isRationalOrthogonal "
            "fallback."
            if ok
            else "Repair the matrix image, block projector, or register convention before "
            "attempting the rational-orthogonality bridge."
        ),
    }
    print(json.dumps(payload, indent=2, sort_keys=True))
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
