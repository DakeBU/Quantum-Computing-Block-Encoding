#!/usr/bin/env python3
"""Finite support diagnostic for CUBIC-VER-CAND-001.

The compiled arithmetic transcript computes an amplitude from the current
system index and then uncomputes the workspace.  If that middle transcript is
treated as the whole clean block, its natural support is diagonal.  The task
target is instead the rank-one first-column operator |v><0|.  This script
checks the necessary support/vanish condition on small exact rational matrices.
"""

from __future__ import annotations

from fractions import Fraction


CHECK_NS = (1, 2, 3, 4)


def grid_size(n: int) -> int:
    return 1 << n


def cubic_amplitude(n: int, j: int) -> Fraction:
    n_grid = grid_size(n)
    return Fraction(j**3, n_grid**3)


def conservative_normalizer(n: int) -> Fraction:
    return Fraction(grid_size(n), 1)


def target_clean_block_entry(n: int, row: int, col: int) -> Fraction:
    """Required clean block entry O_n[row,col] / alpha."""
    if col != 0:
        return Fraction(0)
    return cubic_amplitude(n, row) / conservative_normalizer(n)


def arithmetic_middle_diagonal_entry(n: int, row: int, col: int) -> Fraction:
    """Natural clean block if the current arithmetic middle block is unwrapped."""
    if row != col:
        return Fraction(0)
    return cubic_amplitude(n, col) / conservative_normalizer(n)


def first_mismatch(n: int) -> tuple[int, int, Fraction, Fraction] | None:
    n_grid = grid_size(n)
    for row in range(n_grid):
        for col in range(n_grid):
            target = target_clean_block_entry(n, row, col)
            middle = arithmetic_middle_diagonal_entry(n, row, col)
            if target != middle:
                return row, col, target, middle
    return None


def support_counts(n: int) -> tuple[int, int]:
    n_grid = grid_size(n)
    missing_first_column = sum(
        1
        for row in range(n_grid)
        if target_clean_block_entry(n, row, 0) != arithmetic_middle_diagonal_entry(n, row, 0)
    )
    nonfirst_column_leaks = sum(
        1
        for row in range(n_grid)
        for col in range(1, n_grid)
        if arithmetic_middle_diagonal_entry(n, row, col) != 0
    )
    return missing_first_column, nonfirst_column_leaks


def main() -> int:
    print("# CUBIC-VER-CAND-001 rank-one support diagnostic")
    print()
    print(
        "| n | N | missing_first_column_entries | nonfirst_column_leaks | "
        "block_entry_ok | first_mismatch |"
    )
    print("|---:|---:|---:|---:|---|---|")

    all_ok = True
    for n in CHECK_NS:
        mismatch = first_mismatch(n)
        missing, leaks = support_counts(n)
        block_ok = mismatch is None
        all_ok = all_ok and block_ok
        if mismatch is None:
            mismatch_text = "none"
        else:
            row, col, target, middle = mismatch
            mismatch_text = (
                f"(row={row}, col={col}, target={target}, "
                f"unwrapped_middle={middle})"
            )
        print(
            f"| {n} | {grid_size(n)} | {missing} | {leaks} | "
            f"{str(block_ok).lower()} | `{mismatch_text}` |"
        )

    print()
    print(
        "typed_summary: leaf=CUBIC-VER-CAND-001; "
        "source_correspondence_ok=false; "
        f"finite_matrix_ok={str(all_ok).lower()}; "
        f"block_entry_ok={str(all_ok).lower()}; "
        "error_class=finite_matrix_counterexample; "
        "next_route=add zero-input filter plus row-generation wrapper before "
        "rerunning block-entry verifier"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
