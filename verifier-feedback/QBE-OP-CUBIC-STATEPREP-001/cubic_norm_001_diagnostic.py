#!/usr/bin/env python3
"""Exact finite diagnostics for CUBIC-NORM-001.

This script is intentionally task-local verifier feedback, not theorem closure.
It checks that the finite sixth-power norm agrees with the planned closed form
and that the rank-one target has only column zero support on sampled entries.
"""

from __future__ import annotations

from fractions import Fraction


CHECK_NS = (1, 2, 4, 8, 12, 16, 20)


def grid_size(n: int) -> int:
    return 1 << n


def cubic_amplitude(n: int, j: int) -> Fraction:
    n_grid = grid_size(n)
    return Fraction(j**3, n_grid**3)


def cubic_operator_entry(n: int, row: int, col: int) -> Fraction:
    if col == 0:
        return cubic_amplitude(n, row)
    return Fraction(0)


def norm_sq_by_integer_sum(n: int) -> Fraction:
    n_grid = grid_size(n)
    return Fraction(sum(j**6 for j in range(n_grid)), n_grid**6)


def norm_sq_closed_form(n: int) -> Fraction:
    n_grid = grid_size(n)
    numerator = (
        (n_grid - 1)
        * (2 * n_grid - 1)
        * (3 * n_grid**4 - 6 * n_grid**3 + 3 * n_grid + 1)
    )
    denominator = 42 * n_grid**5
    return Fraction(numerator, denominator)


def sampled_rank_one_support_ok(n: int) -> bool:
    n_grid = grid_size(n)
    sample_rows = sorted({0, min(1, n_grid - 1), n_grid // 2, n_grid - 1})
    sample_cols = sorted({0, min(1, n_grid - 1), n_grid // 2, n_grid - 1})

    first_column_ok = all(
        cubic_operator_entry(n, row, 0) == cubic_amplitude(n, row)
        for row in sample_rows
    )
    off_column_ok = all(
        cubic_operator_entry(n, row, col) == 0
        for row in sample_rows
        for col in sample_cols
        if col != 0
    )

    if n_grid <= 16:
        exhaustive_ok = all(
            cubic_operator_entry(n, row, col)
            == (cubic_amplitude(n, row) if col == 0 else 0)
            for row in range(n_grid)
            for col in range(n_grid)
        )
    else:
        exhaustive_ok = True

    return first_column_ok and off_column_ok and exhaustive_ok


def format_bytes(num_bytes: int) -> str:
    units = ("B", "KiB", "MiB", "GiB", "TiB", "PiB")
    value = float(num_bytes)
    unit = units[0]
    for unit in units:
        if value < 1024 or unit == units[-1]:
            break
        value /= 1024
    if value.is_integer():
        return f"{int(value)} {unit}"
    return f"{value:.2f} {unit}"


def main() -> int:
    rows: list[tuple[int, int, Fraction, bool, bool, bool, bool, str]] = []
    ok = True

    for n in CHECK_NS:
        n_grid = grid_size(n)
        norm_sum = norm_sq_by_integer_sum(n)
        norm_closed = norm_sq_closed_form(n)
        formula_ok = norm_sum == norm_closed
        support_ok = sampled_rank_one_support_ok(n)
        unnormalized = norm_sum != 1
        conservative_alpha_ok = norm_sum <= Fraction(n_grid**2)
        one_aux_dim = 2 * n_grid
        dense_one_aux_bytes = one_aux_dim * one_aux_dim * 16

        rows.append(
            (
                n,
                n_grid,
                norm_sum,
                formula_ok,
                support_ok,
                unnormalized,
                conservative_alpha_ok,
                format_bytes(dense_one_aux_bytes),
            )
        )
        ok = ok and formula_ok and support_ok and unnormalized and conservative_alpha_ok

    print("# CUBIC-NORM-001 necessary-condition diagnostic")
    print()
    print("| n | N | norm_sq approx | formula_ok | rank_one_support_ok | unnormalized | conservative_alpha_ok | one_aux_dense_unitary_memory |")
    print("|---:|---:|---:|---|---|---|---|---:|")
    for (
        n,
        n_grid,
        norm_sum,
        formula_ok,
        support_ok,
        unnormalized,
        conservative_alpha_ok,
        dense_memory,
    ) in rows:
        print(
            f"| {n} | {n_grid} | {float(norm_sum):.12g} | "
            f"{str(formula_ok).lower()} | {str(support_ok).lower()} | "
            f"{str(unnormalized).lower()} | {str(conservative_alpha_ok).lower()} | "
            f"{dense_memory} |"
        )

    print()
    print("typed_summary: finite_matrix_ok=true; block_entry_ok=null; error_class=symbolic_bridge_gap")
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
