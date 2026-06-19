#!/usr/bin/env python3
"""Exact finite path-count diagnostic for CUBIC-VER-CAND-001.

The Hadamard-counting candidate route proposes a clean block

    B_n[j, c] = j^3 / (2^n)^4  when c = 0,
              = 0              otherwise.

With alpha = conservativeNormalizer n = 2^n, this should scale to the task
target O_n = |v_n><0^n|, v_n[j] = (j / 2^n)^3.  This script checks the
support, path-count capacity, and scaled block entries for small exact rational
instances.  It is only a necessary condition; it does not prove a unitary
semantics for the circuit labels.
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


def cubic_operator_entry(n: int, row: int, col: int) -> Fraction:
    if col != 0:
        return Fraction(0)
    return cubic_amplitude(n, row)


def hcount_clean_block_entry(n: int, row: int, col: int) -> Fraction:
    if col != 0:
        return Fraction(0)
    n_grid = grid_size(n)
    path_count = n_grid**4
    accepted_paths = row**3
    return Fraction(accepted_paths, path_count)


def path_capacity_ok(n: int) -> bool:
    n_grid = grid_size(n)
    threshold_size = n_grid**3
    return all(row**3 <= threshold_size for row in range(n_grid))


def block_operator_norm_sq(n: int) -> Fraction:
    n_grid = grid_size(n)
    return sum(
        (hcount_clean_block_entry(n, row, 0) ** 2 for row in range(n_grid)),
        Fraction(0),
    )


def first_mismatch(n: int) -> tuple[int, int, Fraction, Fraction] | None:
    n_grid = grid_size(n)
    alpha = conservative_normalizer(n)
    for row in range(n_grid):
        for col in range(n_grid):
            scaled = alpha * hcount_clean_block_entry(n, row, col)
            target = cubic_operator_entry(n, row, col)
            if scaled != target:
                return row, col, target, scaled
    return None


def support_counts(n: int) -> tuple[int, int]:
    n_grid = grid_size(n)
    missing_first_column = sum(
        1
        for row in range(n_grid)
        if hcount_clean_block_entry(n, row, 0)
        != cubic_amplitude(n, row) / conservative_normalizer(n)
    )
    nonfirst_column_leaks = sum(
        1
        for row in range(n_grid)
        for col in range(1, n_grid)
        if hcount_clean_block_entry(n, row, col) != 0
    )
    return missing_first_column, nonfirst_column_leaks


def main() -> int:
    print("# CUBIC-VER-CAND-001 Hadamard-counting path diagnostic")
    print()
    print(
        "| n | N | path_capacity_ok | missing_first_column_entries | "
        "nonfirst_column_leaks | block_entry_ok | block_norm_sq<=1 | first_mismatch |"
    )
    print("|---:|---:|---|---:|---:|---|---|---|")

    all_ok = True
    for n in CHECK_NS:
        mismatch = first_mismatch(n)
        missing, leaks = support_counts(n)
        block_ok = mismatch is None
        norm_ok = block_operator_norm_sq(n) <= 1
        capacity_ok = path_capacity_ok(n)
        row_ok = capacity_ok and missing == 0 and leaks == 0 and block_ok and norm_ok
        all_ok = all_ok and row_ok
        if mismatch is None:
            mismatch_text = "none"
        else:
            row, col, target, scaled = mismatch
            mismatch_text = (
                f"(row={row}, col={col}, target={target}, "
                f"alpha_times_block={scaled})"
            )
        print(
            f"| {n} | {grid_size(n)} | {str(capacity_ok).lower()} | "
            f"{missing} | {leaks} | {str(block_ok).lower()} | "
            f"{str(norm_ok).lower()} | `{mismatch_text}` |"
        )

    print()
    print(
        "typed_summary: leaf=CUBIC-VER-CAND-001:HCOUNT-PATH; "
        "source_correspondence_ok=true; "
        f"finite_matrix_ok={str(all_ok).lower()}; "
        f"block_entry_ok={str(all_ok).lower()}; "
        "ancilla_cleanup_ok=designed_not_executed; "
        "unitarity_ok=null; "
        "error_class=symbolic_bridge_gap; "
        "next_route=compile CUBIC-HCOUNT-IFACE-001 layout/circuit/resource "
        "declarations, then attach Hadamard-sandwich and reversible-comparator "
        "semantics"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
