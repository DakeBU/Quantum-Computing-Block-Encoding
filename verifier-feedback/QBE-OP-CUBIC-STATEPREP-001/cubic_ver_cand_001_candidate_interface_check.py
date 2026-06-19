#!/usr/bin/env python3
"""Task-local necessary-condition check for CUBIC-VER-CAND-001.

This diagnostic protects the next Lean worker from trying to prove a block
entry before a candidate interface exists.  It also rechecks the finite target
shape for the rank-one cubic operator, but it does not certify a block encoding.
"""

from __future__ import annotations

from fractions import Fraction
from pathlib import Path


TASK_ID = "QBE-OP-CUBIC-STATEPREP-001"
ROOT = Path(__file__).resolve().parents[2]
TASK_FILE = ROOT / "tasks" / f"{TASK_ID}.md"
CANDIDATE_FILE = ROOT / "candidate-populations" / f"{TASK_ID}.md"
CHECK_NS = (1, 2, 3, 4)


def grid_size(n: int) -> int:
    return 1 << n


def cubic_amplitude(n: int, j: int) -> Fraction:
    n_grid = grid_size(n)
    return Fraction(j**3, n_grid**3)


def cubic_operator_entry(n: int, row: int, col: int) -> Fraction:
    return cubic_amplitude(n, row) if col == 0 else Fraction(0)


def finite_target_shape_ok(n: int) -> bool:
    n_grid = grid_size(n)
    return all(
        cubic_operator_entry(n, row, col)
        == (cubic_amplitude(n, row) if col == 0 else 0)
        for row in range(n_grid)
        for col in range(n_grid)
    )


def norm_sq(n: int) -> Fraction:
    n_grid = grid_size(n)
    return sum((cubic_amplitude(n, j) ** 2 for j in range(n_grid)), Fraction(0))


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def candidate_interface_status() -> tuple[bool, list[str]]:
    text = read_text(CANDIDATE_FILE)
    required_fields = {
        "candidate unitary family `U_n`": "candidate unitary family",
        "block projector": "block projector",
        "clean ancilla": "clean ancilla",
        "alpha": "alpha/normalizer",
        "epsilon budget": "epsilon budget",
        "resource tuple": "resource tuple",
    }
    still_missing = [
        label
        for needle, label in required_fields.items()
        if needle not in text or "missing concrete register interface" in text
    ]

    has_concrete_candidate = (
        "No full block-encoding candidate has been promoted yet" not in text
        and "missing concrete register interface" not in text
        and "Candidate unitary family `U_n` | open" not in text
    )
    return has_concrete_candidate and not still_missing, still_missing


def source_correspondence_ok() -> bool:
    text = read_text(TASK_FILE)
    return (
        "O_n = |v_n><0^n|" in text
        and "v_n[j] = (j / 2^n)^3" in text
        and "maps" in text
        and "all other computational basis inputs to zero" in text
    )


def main() -> int:
    source_ok = source_correspondence_ok()
    interface_present, missing = candidate_interface_status()
    finite_rows = []
    finite_ok = True

    for n in CHECK_NS:
        n_grid = grid_size(n)
        shape_ok = finite_target_shape_ok(n)
        unnormalized = norm_sq(n) != 1
        finite_rows.append((n, n_grid, shape_ok, unnormalized, norm_sq(n)))
        finite_ok = finite_ok and shape_ok and unnormalized

    print("# CUBIC-VER-CAND-001 candidate-interface diagnostic")
    print()
    print("| n | N | rank_one_target_shape_ok | unnormalized | norm_sq approx |")
    print("|---:|---:|---|---|---:|")
    for n, n_grid, shape_ok, unnormalized, nrm in finite_rows:
        print(
            f"| {n} | {n_grid} | {str(shape_ok).lower()} | "
            f"{str(unnormalized).lower()} | {float(nrm):.12g} |"
        )

    print()
    print(f"source_correspondence_ok={str(source_ok).lower()}")
    print(f"candidate_interface_present={str(interface_present).lower()}")
    print("missing_interface_fields=" + ",".join(missing))
    print(
        "typed_summary: leaf=CUBIC-VER-CAND-001; "
        f"source_correspondence_ok={str(source_ok).lower()}; "
        f"finite_matrix_ok={str(finite_ok).lower()}; "
        "block_entry_ok=null; "
        "error_class=shape_or_register_gap; "
        "blocker=candidate_interface_gap"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
