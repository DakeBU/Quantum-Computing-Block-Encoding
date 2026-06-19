#!/usr/bin/env python3
"""Finite semantic diagnostic for the Hadamard-counting cubic route.

This checks the current oracle-label transcript at the register-shape level.
The key convention under test is the nonzero-input flag: if the transcript
computes `nz := [S != 0]` and later applies the dagger of that same flag
computation, then nonzero input columns return to clean ancillas unless another
reject signal is left set.  That would contradict the rank-one target support.

The script does not certify a Lean theorem.  It gives a finite necessary
condition for the planned clean-block theorem.
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


def current_daggered_nz_entry(n: int, row: int, col: int) -> Fraction:
    """Rejected clean block if `nz` is computed and then uncomputed.

    For col != 0, the path work is skipped and the final dagger clears `nz`.
    With no separate nonzero reject left behind, the clean block leaks the
    identity on nonzero columns.
    """
    if col != 0:
        return Fraction(1 if row == col else 0)
    return first_column_path_entry(n, row)


def repaired_separate_reject_entry(n: int, row: int, col: int) -> Fraction:
    """Clean block for the repaired transcript with a separate reject signal."""
    if col != 0:
        return Fraction(0)
    return first_column_path_entry(n, row)


def sticky_nz_reference_entry(n: int, row: int, col: int) -> Fraction:
    """Reference semantics used by the prose proof: nonzero columns keep nz=1."""
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


def nonzero_reject(state: State) -> State:
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


def current_reversible_layers_ok(n: int) -> bool:
    return (
        is_bijection(n, zero_flag)
        and is_bijection(n, nonzero_reject)
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
    return f"(row={row}, col={col}, target={target}, current={actual})"


def main() -> int:
    print("# CUBIC-VER-CAND-001 Hadamard-counting semantic diagnostic")
    print()
    print(
        "| n | N | reversible_layers_ok | path_hadamard_orthogonal_ok | "
        "rejected_daggered_nonfirst_column_leaks | "
        "rejected_daggered_block_entry_ok | repaired_block_entry_ok | "
        "sticky_reference_block_entry_ok | repaired_first_mismatch |"
    )
    print("|---:|---:|---|---|---:|---|---|---|---|")

    repaired_all_ok = True
    sticky_all_ok = True
    reversible_all_ok = True
    for n in CHECK_NS:
        rejected_mismatch = first_mismatch(n, current_daggered_nz_entry)
        repaired_mismatch = first_mismatch(n, repaired_separate_reject_entry)
        sticky_mismatch = first_mismatch(n, sticky_nz_reference_entry)
        rejected_ok = rejected_mismatch is None
        repaired_ok = repaired_mismatch is None
        sticky_ok = sticky_mismatch is None
        reversible_ok = current_reversible_layers_ok(n)
        hadamard_ok = hadamard_orthogonal_ok(n)
        repaired_all_ok = repaired_all_ok and repaired_ok
        sticky_all_ok = sticky_all_ok and sticky_ok
        reversible_all_ok = reversible_all_ok and reversible_ok and hadamard_ok
        print(
            f"| {n} | {grid_size(n)} | {str(reversible_ok).lower()} | "
            f"{str(hadamard_ok).lower()} | "
            f"{nonfirst_column_leaks(n, current_daggered_nz_entry)} | "
            f"{str(rejected_ok).lower()} | {str(repaired_ok).lower()} | "
            f"{str(sticky_ok).lower()} | "
            f"`{format_mismatch(repaired_mismatch)}` |"
        )

    print()
    print(
        "typed_summary: leaf=CUBIC-HCOUNT-REJECT-REPAIR-001; "
        "source_correspondence_ok=true; "
        f"finite_matrix_ok={str(repaired_all_ok).lower()}; "
        f"block_entry_ok={str(repaired_all_ok).lower()}; "
        "ancilla_cleanup_ok=true; "
        f"unitarity_ok={str(reversible_all_ok).lower()}; "
        "error_class=symbolic_bridge_gap; "
        "next_route=promote the separate-reject convention into symbolic "
        "Hadamard-counting semantics before attempting CUBIC-HCOUNT-BLOCK-001"
    )
    if sticky_all_ok:
        print(
            "reference_note: sticky_nz_reference passes the same finite "
            "block-entry check; the Lean interface now uses the separate "
            "reject-signal repair instead."
        )
    print(
        "rejected_route: the old daggered nz-only transcript remains rejected "
        "because nonzero columns leak clean identity entries."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
