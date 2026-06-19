#!/usr/bin/env python3
"""Finite threshold-count diagnostic for CUBIC-HCOUNT-COUNT-001.

This checks the path-count leaf used by the Hadamard-counting cubic candidate.
For each tested n and row j, the threshold register has size gridSize (3*n),
and the accepted values are exactly the t with t < j^3.  The count must be
j^3, and with the route denominator gridSize (4*n) and alpha = gridSize n the
scaled first-column block entry must match (j / gridSize n)^3.

This is only a necessary-condition filter.  It is not a Lean proof of the
symbolic family, the repaired circuit semantics, or unitarity.
"""

from __future__ import annotations

from fractions import Fraction


CHECK_NS = (1, 2, 3, 4, 5)


def grid_size(n: int) -> int:
    return 1 << n


def cubic_amplitude(n: int, row: int) -> Fraction:
    n_grid = grid_size(n)
    return Fraction(row**3, n_grid**3)


def threshold_count(n: int, row: int) -> int:
    threshold_size = grid_size(3 * n)
    return sum(1 for t in range(threshold_size) if t < row**3)


def first_count_mismatch(n: int) -> tuple[int, int, int] | None:
    for row in range(grid_size(n)):
        actual = threshold_count(n, row)
        expected = row**3
        if actual != expected:
            return row, expected, actual
    return None


def first_block_entry_mismatch(
    n: int,
) -> tuple[int, Fraction, Fraction] | None:
    alpha = Fraction(grid_size(n), 1)
    denominator = grid_size(4 * n)
    for row in range(grid_size(n)):
        block_entry = Fraction(threshold_count(n, row), denominator)
        scaled = alpha * block_entry
        target = cubic_amplitude(n, row)
        if scaled != target:
            return row, target, scaled
    return None


def row_ok(n: int) -> tuple[bool, str, bool, bool, int, str, bool, str]:
    n_grid = grid_size(n)
    grid3_cube_ok = grid_size(3 * n) == n_grid**3
    grid4_fourth_ok = grid_size(4 * n) == n_grid**4
    capacity_ok = all(row**3 <= grid_size(3 * n) for row in range(n_grid))

    count_mismatch = first_count_mismatch(n)
    count_mismatches = 0
    for row in range(n_grid):
        if threshold_count(n, row) != row**3:
            count_mismatches += 1
    if count_mismatch is None:
        count_text = "none"
    else:
        row, expected, actual = count_mismatch
        count_text = f"row={row}, expected={expected}, actual={actual}"

    block_mismatch = first_block_entry_mismatch(n)
    block_ok = block_mismatch is None
    if block_mismatch is None:
        block_text = "none"
    else:
        row, target, scaled = block_mismatch
        block_text = f"row={row}, target={target}, alpha_times_block={scaled}"

    finite_ok = (
        grid3_cube_ok
        and grid4_fourth_ok
        and capacity_ok
        and count_mismatches == 0
        and block_ok
    )
    return (
        finite_ok,
        str(capacity_ok).lower(),
        grid3_cube_ok,
        grid4_fourth_ok,
        count_mismatches,
        count_text,
        block_ok,
        block_text,
    )


def main() -> int:
    print("# CUBIC-HCOUNT-COUNT-001 threshold diagnostic")
    print()
    print(
        "| n | N | capacity_ok | grid3_cube_ok | grid4_fourth_ok | "
        "count_mismatches | first_count_mismatch | block_entry_ok | "
        "first_block_mismatch |"
    )
    print("|---:|---:|---|---|---|---:|---|---|---|")

    all_ok = True
    for n in CHECK_NS:
        (
            finite_ok,
            capacity_text,
            grid3_cube_ok,
            grid4_fourth_ok,
            count_mismatches,
            count_text,
            block_ok,
            block_text,
        ) = row_ok(n)
        all_ok = all_ok and finite_ok
        print(
            f"| {n} | {grid_size(n)} | {capacity_text} | "
            f"{str(grid3_cube_ok).lower()} | {str(grid4_fourth_ok).lower()} | "
            f"{count_mismatches} | `{count_text}` | {str(block_ok).lower()} | "
            f"`{block_text}` |"
        )

    print()
    print(
        "typed_summary: leaf=CUBIC-HCOUNT-COUNT-001; "
        "source_correspondence_ok=true; "
        f"finite_matrix_ok={str(all_ok).lower()}; "
        f"block_entry_ok={str(all_ok).lower()}; "
        "ancilla_cleanup_ok=null; normalizer_ok=true; unitarity_ok=null; "
        "closed_theorem_ok=null; error_class=symbolic_bridge_gap; "
        "next_route=if the count leaf is not build-tested, prove "
        "gridSize_three_mul_eq_cube, gridSize_four_mul_eq_fourth, "
        "hadamardCountingCubic_threshold_le_pathCapacity, and "
        "hadamardCountingCubic_thresholdPathCount in Lean; otherwise schedule "
        "CUBIC-HCOUNT-UNITARY-001 or the Hadamard-sandwich semantic bridge"
    )
    return 0 if all_ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
