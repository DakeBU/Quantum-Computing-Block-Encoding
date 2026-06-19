#!/usr/bin/env python3
"""Diagnostics for QBE-OP-CUBIC-STATEPREP-001.

This script does not certify a block encoding.  It records cheap exact
necessary-condition data and dense-verifier scaling forecasts for the cubic
state-preparation benchmark.
"""

from __future__ import annotations

import argparse
import csv
import json
import math
from fractions import Fraction
from pathlib import Path


def sum_sixth(m: int) -> int:
    """Return sum_{j=0}^m j^6."""

    return m * (m + 1) * (2 * m + 1) * (3 * m**4 + 6 * m**3 - 3 * m + 1) // 42


def norm_sq_fraction(n: int) -> Fraction:
    ngrid = 1 << n
    return Fraction(sum_sixth(ngrid - 1), ngrid**6)


def dense_unitary_bytes(n: int, auxiliary_qubits: int = 1) -> int:
    dim = 1 << (n + auxiliary_qubits)
    return dim * dim * 16


def human_bytes(num: int) -> str:
    units = ["B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB"]
    value = float(num)
    for unit in units:
        if value < 1024 or unit == units[-1]:
            return f"{value:.3g} {unit}"
        value /= 1024
    return f"{value:.3g} ZiB"


def row(n: int, epsilon: float) -> dict:
    ngrid = 1 << n
    norm_sq = norm_sq_fraction(n)
    precision_bits = math.ceil(math.log2(1 / epsilon))
    return {
        "n": n,
        "N": ngrid,
        "norm_sq_fraction": f"{norm_sq.numerator}/{norm_sq.denominator}",
        "norm_approx": math.sqrt(float(norm_sq)),
        "dense_vector_entries": ngrid,
        "dense_one_aux_unitary_memory": human_bytes(dense_unitary_bytes(n, 1)),
        "epsilon": epsilon,
        "precision_bits_floor": precision_bits,
        "abeis_expected_route": "symbolic arithmetic, then Lean family theorem",
        "dense_verifier_role": "small-instance fixed-instance executable check only",
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--epsilon", type=float, default=1e-10)
    parser.add_argument("--n", type=int, nargs="*", default=[1, 2, 4, 8, 12, 16, 20])
    parser.add_argument("--out-dir", default="reports/cubic-stateprep")
    args = parser.parse_args()

    rows = [row(n, args.epsilon) for n in args.n]
    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    (out_dir / "latest.json").write_text(json.dumps(rows, indent=2) + "\n", encoding="utf-8")

    with (out_dir / "latest.csv").open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(
            f,
            fieldnames=list(rows[0].keys()),
            lineterminator="\n",
        )
        writer.writeheader()
        writer.writerows(rows)

    lines = [
        "# Cubic State-Preparation Diagnostics",
        "",
        "These are necessary-condition diagnostics, not final block-encoding certificates.",
        "",
        "| n | N | norm^2 | norm approx | dense vector entries | dense one-aux unitary memory | precision bits floor |",
        "|---:|---:|---|---:|---:|---:|---:|",
    ]
    for item in rows:
        lines.append(
            "| {n} | {N} | `{norm_sq_fraction}` | {norm_approx:.6g} | {dense_vector_entries} | {dense_one_aux_unitary_memory} | {precision_bits_floor} |".format(
                **item
            )
        )
    lines.extend(
        [
            "",
            "Interpretation: dense executable verification is useful for small `n`, but it materializes data that grows exponentially.  The ABEIS route should use the cubic arithmetic structure and prove a symbolic family in Lean.",
            "",
        ]
    )
    (out_dir / "latest.md").write_text("\n".join(lines), encoding="utf-8")
    print(out_dir / "latest.md")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
