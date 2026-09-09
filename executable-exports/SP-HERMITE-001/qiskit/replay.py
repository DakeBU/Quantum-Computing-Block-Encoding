#!/usr/bin/env python3
"""Replay saved artifacts using an independent rational Hermite interpolator.

No exporter functions are imported. Endpoint interpolation reconstructs the
target, while Qiskit parses and simulates the saved OpenQASM circuit.
"""
from __future__ import annotations

import argparse
import csv
from decimal import Decimal, localcontext
from fractions import Fraction
import hashlib
import json
import math
from pathlib import Path
import sys

import numpy as np


def interpolate(k: int) -> tuple[list[Fraction], list[Fraction]]:
    """Solve endpoint equations for P=exp(-1)*u+v by exact elimination."""
    if not isinstance(k, int) or not 0 <= k <= 30:
        raise ValueError("independent replay supports 0 <= k <= 30")
    size = 2*k+2
    matrix = []
    for endpoint in (0, 1):
        for order in range(k+1):
            row = [Fraction(math.factorial(i), math.factorial(i-order))*endpoint**(i-order)
                   if i >= order else Fraction(0) for i in range(size)]
            row.extend([Fraction(1), Fraction(0)] if endpoint == 0
                       else [Fraction(0), Fraction((-1)**order)])
            matrix.append(row)
    for col in range(size):
        pivot = next(i for i in range(col, size) if matrix[i][col])
        matrix[col], matrix[pivot] = matrix[pivot], matrix[col]
        divisor = matrix[col][col]
        matrix[col] = [x/divisor for x in matrix[col]]
        for row in range(size):
            if row != col and matrix[row][col]:
                factor = matrix[row][col]
                matrix[row] = [a-factor*b for a, b in zip(matrix[row], matrix[col])]
    return [row[size] for row in matrix], [row[size+1] for row in matrix]


def target_samples(k: int, n: int, length: float) -> tuple[np.ndarray, np.ndarray]:
    u, v = interpolate(k)
    points = -math.pi*length + 2*math.pi*length*np.arange(2**n)/2**n
    with localcontext() as context:
        context.prec = 100
        minus_one_exp = Decimal(-1).exp()
        coefficients = [minus_one_exp*Decimal(a.numerator)/Decimal(a.denominator)
                        + Decimal(b.numerator)/Decimal(b.denominator) for a, b in zip(u, v)]
        values = []
        for p in points:
            decimal_p = Decimal(str(p))
            if p <= -1:
                value = decimal_p.exp()
            elif p >= 0:
                value = (-decimal_p).exp()
            else:
                t = decimal_p+1
                value = Decimal(0)
                for coefficient in reversed(coefficients):
                    value = value*t+coefficient
            values.append(float(value))
    return points, np.asarray(values)


def verify(directory: Path) -> dict:
    from qiskit import qasm2, qasm3
    from qiskit.quantum_info import Statevector

    required = ["acceptance.json", "manifest.json", "circuit.qasm", "circuit.qasm2",
                "circuit.qasm3", "samples.csv", "mass-tree.json", "endpoint-jets.json"]
    for name in required:
        if not (directory/name).is_file():
            raise ValueError(f"required artifact is missing: {name}")
    acceptance = json.loads((directory/"acceptance.json").read_text(encoding="utf-8"))
    manifest = json.loads((directory/"manifest.json").read_text(encoding="utf-8"))
    if acceptance.get("accepted") is not True or acceptance.get("evidence_class") != "finite-executable-acceptance":
        raise ValueError("artifact does not claim completed executable acceptance")
    if acceptance.get("parameters") != manifest.get("parameters"):
        raise ValueError("manifest and acceptance parameters disagree")
    parameters = manifest["parameters"]
    k, n, length = parameters["k"], parameters["n"], parameters["L"]
    if not isinstance(n, int) or not 1 <= n <= 10 or not math.isfinite(length) or length <= 0:
        raise ValueError("invalid finite replay parameters")
    if n <= 5:
        required.append("circuit.svg")
    digests = acceptance.get("artifact_sha256", {})
    for name in required:
        if name == "acceptance.json":
            continue
        if not (directory/name).is_file():
            raise ValueError(f"required artifact is missing: {name}")
        actual = hashlib.sha256((directory/name).read_bytes()).hexdigest()
        if digests.get(name) != actual:
            raise ValueError(f"artifact hash mismatch: {name}")
    exporter = Path(__file__).with_name("export.py")
    if not exporter.is_file() or acceptance.get("exporter_sha256") != hashlib.sha256(exporter.read_bytes()).hexdigest():
        raise ValueError("exporter source changed after artifact acceptance")
    points, samples = target_samples(k, n, length)
    target = samples/np.linalg.norm(samples)
    with (directory/"samples.csv").open(encoding="utf-8", newline="") as stream:
        rows = list(csv.DictReader(stream))
    if len(rows) != 2**n:
        raise ValueError("wrong sample count")
    for j, row in enumerate(rows):
        if int(row["index"]) != j or row["basis_q_high_to_low"] != format(j, f"0{n}b"):
            raise ValueError("sample index or bit order mismatch")
    sample_error = max(float(np.max(np.abs(np.asarray([float(r[field]) for r in rows])-expected)))
                       for field, expected in (("p", points), ("f", samples), ("target_amplitude", target)))
    if sample_error > 1e-12:
        raise ValueError(f"independent endpoint interpolation disagrees with samples: {sample_error}")
    errors = {}
    for name, loader in (("circuit.qasm", qasm3.loads), ("circuit.qasm3", qasm3.loads), ("circuit.qasm2", qasm2.loads)):
        circuit = loader((directory/name).read_text(encoding="utf-8"))
        counts = circuit.count_ops()
        if circuit.num_qubits != n or set(counts) - {"ry", "cx"}:
            raise ValueError(f"unexpected wires or gates: {name}")
        if (counts.get("ry", 0), counts.get("cx", 0)) != (2**n-1, 2*(2**n-1-n)):
            raise ValueError(f"reference resource counts changed: {name}")
        state = np.asarray(Statevector.from_instruction(circuit).data)
        errors[name] = float(np.max(np.abs(state-target)))
    if max(errors.values()) > 1e-10:
        raise ValueError(f"independent QASM replay failed: {errors}")
    return {"passed": True, "evidence_class": "independent-finite-replay", "parameters": parameters,
            "target_method": "exact rational endpoint interpolation, evaluated at 100 decimal digits",
            "sample_max_error": sample_error, "qasm_max_amplitude_errors": errors,
            "checked_artifacts": required, "lean_certificate_claimed": False}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--directory", type=Path, default=Path(__file__).resolve().parents[1])
    args = parser.parse_args()
    try:
        result = verify(args.directory)
    except (ValueError, KeyError, OSError, ImportError) as exc:
        print(f"Hermite independent replay failed: {exc}", file=sys.stderr)
        return 1
    print(json.dumps(result, indent=2, sort_keys=True, allow_nan=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
