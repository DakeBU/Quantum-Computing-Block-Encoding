#!/usr/bin/env python3
"""Fail closed on missing Hermite inputs; this is not a Lean success certificate."""

from __future__ import annotations

import argparse
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REQUIRED_FILES = (
    "QuantumBlockEncoding/HermitePolynomial.lean",
    "QuantumBlockEncoding/HermiteSmoothness.lean",
    "QuantumBlockEncoding/RealAmplitudePreparation.lean",
    "QuantumBlockEncoding/HermiteStatePreparation.lean",
    "ABEISTests/Hermite.lean",
    "ABEISTests/HermitePolynomial.lean",
    "ABEISTests/HermiteSmoothness.lean",
    "ABEISTests/RealAmplitudePreparation.lean",
    "executable-exports/SP-HERMITE-001/qiskit/export.py",
    "executable-exports/SP-HERMITE-001/qiskit/replay.py",
    "executable-exports/SP-HERMITE-001/qiskit/test_export.py",
    "executable-exports/SP-HERMITE-001/acceptance.json",
    "executable-exports/SP-HERMITE-001/manifest.json",
    "executable-exports/SP-HERMITE-001/circuit.svg",
    "executable-exports/SP-HERMITE-001/circuit.qasm2",
    "executable-exports/SP-HERMITE-001/circuit.qasm3",
    "executable-exports/SP-HERMITE-001/samples.csv",
    "website/hermite-case.json",
    "docs/hermite-state-preparation.tex",
    "docs/assets/hermite-proof-flow.svg",
)


def missing_inputs(root: Path) -> list[str]:
    """Directories, zero-byte placeholders, and external symlinks do not qualify."""
    root = root.resolve()
    absent = []
    for name in REQUIRED_FILES:
        path = root / name
        if (
            not path.is_file()
            or not path.resolve().is_relative_to(root)
            or path.stat().st_size == 0
        ):
            absent.append(name)
    return absent


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=ROOT)
    args = parser.parse_args()
    absent = missing_inputs(args.root)
    if absent:
        print("Hermite input gate FAILED; required nonempty files are missing:")
        for name in absent:
            print(f"  {name}")
        return 1
    print("Hermite inputs present. Lean compilation and executable replay are still required.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
