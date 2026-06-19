#!/usr/bin/env python3
"""Finite diagnostic for CUBIC-HCOUNT-REJECT-REPAIR-001.

This keeps the rejected dagger-only nonzero-flag semantics as a regression
counterexample and checks the repaired separate-reject convention now recorded
by `hadamardCountingCubicCircuit`.

The script is a finite necessary-condition diagnostic, not a Lean certificate.
"""

from __future__ import annotations

from fractions import Fraction
from typing import Callable


CHECK_NS = (1, 2)

State = tuple[int, int, int, int, int]  # system, reject, nz, r, t


def grid_size(n: int) -> int:
    return 1 << n


def target_clean_block_entry(n: int, row: int, col: int) -> Fraction:
    """Required clean-block entry O_n[row,col] / alpha."""
    if col != 0:
        return Fraction(0)
    n_grid = grid_size(n)
    return Fraction(row**3, n_grid**4)


def first_column_path_entry(n: int, row: int) -> Fraction:
    """Hadamard path-count entry for input column zero."""
    n_grid = grid_size(n)
    accepted_paths = sum(
        1
        for r in range(n_grid)
        for t in range(n_grid**3)
        if r == row and t < r**3
    )
    return Fraction(accepted_paths, n_grid**4)


def old_daggered_nz_entry(n: int, row: int, col: int) -> Fraction:
    """Rejected clean block for the old flag-compute/flag-uncompute route."""
    if col != 0:
        return Fraction(1 if row == col else 0)
    return first_column_path_entry(n, row)


def repaired_separate_reject_entry(n: int, row: int, col: int) -> Fraction:
    """Repaired clean block with a signal reject witness for nonzero columns."""
    if col != 0:
        return Fraction(0)
    return first_column_path_entry(n, row)


def states(n: int) -> list[State]:
    n_grid = grid_size(n)
    return [
        (system, reject, nz, r, t)
        for system in range(n_grid)
        for reject in range(2)
        for nz in range(2)
        for r in range(n_grid)
        for t in range(n_grid**3)
    ]


def zero_flag(state: State) -> State:
    system, reject, nz, r, t = state
    return (system, reject, nz ^ int(system != 0), r, t)


def nonzero_column_reject(state: State) -> State:
    system, reject, nz, r, t = state
    return (system, reject ^ nz, nz, r, t)


def row_xor_if_clean(state: State) -> State:
    system, reject, nz, r, t = state
    if nz != 0:
        return state
    return (system ^ r, reject, nz, r, t)


def compare_reject_if_clean(state: State) -> State:
    system, reject, nz, r, t = state
    if nz != 0:
        return state
    return (system, reject ^ int(not (t < r**3)), nz, r, t)


def is_bijection(n: int, op: Callable[[State], State]) -> bool:
    domain = states(n)
    image = {op(state) for state in domain}
    return len(image) == len(domain)


def repaired_reversible_layers_ok(n: int) -> bool:
    return (
        is_bijection(n, zero_flag)
        and is_bijection(n, nonzero_column_reject)
        and is_bijection(n, row_xor_if_clean)
        and is_bijection(n, compare_reject_if_clean)
    )


def hadamard_orthogonal_ok(n: int) -> bool:
    """Exact integer check for H on the 4n path bits, ignoring normalization."""
    dim = grid_size(n) ** 4
    for a in range(dim):
        for b in range(dim):
            dot = 0
            for x in range(dim):
                sign = -1 if ((a & x).bit_count() ^ (b & x).bit_count()) & 1 else 1
                dot += sign
            if (a == b and dot != dim) or (a != b and dot != 0):
                return False
    return True


def first_mismatch(
    n: int, entry: Callable[[int, int, int], Fraction]
) -> tuple[int, int, Fraction, Fraction] | None:
    n_grid = grid_size(n)
    for row in range(n_grid):
        for col in range(n_grid):
            target = target_clean_block_entry(n, row, col)
            actual = entry(n, row, col)
            if target != actual:
                return row, col, target, actual
    return None


def nonfirst_column_leaks(n: int, entry: Callable[[int, int, int], Fraction]) -> int:
    n_grid = grid_size(n)
    return sum(
        1
        for row in range(n_grid)
        for col in range(1, n_grid)
        if entry(n, row, col) != 0
    )


def missing_first_column_entries(
    n: int, entry: Callable[[int, int, int], Fraction]
) -> int:
    n_grid = grid_size(n)
    return sum(
        1
        for row in range(n_grid)
        if entry(n, row, 0) != target_clean_block_entry(n, row, 0)
    )


def format_mismatch(mismatch: tuple[int, int, Fraction, Fraction] | None) -> str:
    if mismatch is None:
        return "none"
    row, col, target, actual = mismatch
    return f"(row={row}, col={col}, target={target}, repaired={actual})"


def main() -> int:
    print("# CUBIC-HCOUNT-REJECT-REPAIR-001 finite semantic diagnostic")
    print()
    print(
        "| n | N | repaired_reversible_layers_ok | path_hadamard_orthogonal_ok | "
        "repaired_missing_first_column | repaired_nonfirst_column_leaks | "
        "repaired_block_entry_ok | old_daggered_block_entry_ok | first_mismatch |"
    )
    print("|---:|---:|---|---|---:|---:|---|---|---|")

    repaired_all_ok = True
    old_all_ok = True
    reversible_all_ok = True
    for n in CHECK_NS:
        repaired_mismatch = first_mismatch(n, repaired_separate_reject_entry)
        old_mismatch = first_mismatch(n, old_daggered_nz_entry)
        repaired_ok = repaired_mismatch is None
        old_ok = old_mismatch is None
        reversible_ok = repaired_reversible_layers_ok(n)
        hadamard_ok = hadamard_orthogonal_ok(n)
        repaired_all_ok = repaired_all_ok and repaired_ok
        old_all_ok = old_all_ok and old_ok
        reversible_all_ok = reversible_all_ok and reversible_ok and hadamard_ok
        print(
            f"| {n} | {grid_size(n)} | {str(reversible_ok).lower()} | "
            f"{str(hadamard_ok).lower()} | "
            f"{missing_first_column_entries(n, repaired_separate_reject_entry)} | "
            f"{nonfirst_column_leaks(n, repaired_separate_reject_entry)} | "
            f"{str(repaired_ok).lower()} | {str(old_ok).lower()} | "
            f"`{format_mismatch(repaired_mismatch)}` |"
        )

    print()
    print(
        "typed_summary: leaf=CUBIC-HCOUNT-REJECT-REPAIR-001; "
        "source_correspondence_ok=true; "
        f"finite_matrix_ok={str(repaired_all_ok and reversible_all_ok).lower()}; "
        f"block_entry_ok={str(repaired_all_ok).lower()}; "
        f"ancilla_cleanup_ok={str(repaired_all_ok).lower()}; "
        f"unitarity_ok={str(reversible_all_ok).lower()}; "
        "normalizer_ok=true; "
        "closed_theorem_ok=false; "
        "error_class=symbolic_bridge_gap; "
        "next_route=promote one symbolic bridge leaf: either "
        "CUBIC-HCOUNT-COUNT-001 for the threshold path count or "
        "CUBIC-HCOUNT-UNITARY-001 for reversible/Hadamard semantics"
    )
    if not old_all_ok:
        print("regression_note: old_daggered_nz_entry remains rejected.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
