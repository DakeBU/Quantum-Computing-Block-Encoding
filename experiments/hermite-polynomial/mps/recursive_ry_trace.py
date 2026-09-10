"""Portable rational trace of the Lean recursive selected-RY backend.

Coefficients are exact Fractions; conversion of a supplied base angle to a
float occurs only during numerical gate emission. Lean SelectedRyTrace proves
the corresponding rational algorithm's matrix semantics. Cross-language trace
tests are executable evidence, not a proof of Python semantics or angle error.
The existing Walsh exporter is left unchanged as a comparison baseline.
"""
from __future__ import annotations

from fractions import Fraction
import math
from pathlib import Path
from typing import Iterator, Sequence


def _natural(value: int, name: str) -> None:
    if type(value) is not int or value < 0:
        raise ValueError(f"{name} must be a nonnegative integer")


def selected_trace(qubits: int, controls: Sequence[int], target: int,
                   pattern: int) -> Iterator[tuple]:
    """Use the first control as the pattern's least significant bit.

    There are only 2**len(controls) local coefficients, not 2**data_qubits
    amplitudes. All zero rotations are retained, as in the Lean recurrence.
    """
    _natural(qubits, "qubits")
    _natural(target, "target")
    _natural(pattern, "pattern")
    if target >= qubits:
        raise ValueError("target outside register")
    wires = tuple(controls)
    for wire in wires:
        _natural(wire, "control")
        if wire >= qubits or wire == target:
            raise ValueError("invalid control wire")
    if len(set(wires)) != len(wires):
        raise ValueError("duplicate control wires")
    if pattern >= 1 << len(wires):
        raise ValueError("pattern outside control register")
    coefficients = [Fraction(int(i == pattern)) for i in range(1 << len(wires))]

    def compile_tail(offset: int, values: list[Fraction]) -> Iterator[tuple]:
        if offset == len(wires):
            yield ("ry", values[0], target)
            return
        plus = [(a + b) / 2 for a, b in zip(values[0::2], values[1::2])]
        minus = [(a - b) / 2 for a, b in zip(values[0::2], values[1::2])]
        yield from compile_tail(offset + 1, plus)
        yield ("cx", wires[offset], target)
        yield from compile_tail(offset + 1, minus)
        yield ("cx", wires[offset], target)

    yield from compile_tail(0, coefficients)


def trace_json(trace: Iterator[tuple]) -> list[dict]:
    result = []
    for gate in trace:
        if gate[0] == "ry":
            value = gate[1]
            result.append({"op": "ry", "target": gate[2],
                           "numerator": value.numerator, "denominator": value.denominator})
        else:
            result.append({"op": "cx", "control": gate[1], "target": gate[2]})
    return result


def expand_edge_rotation_recursive(local_qubits: int, first: int, second: int,
                                   half_angle: float) -> Iterator[tuple]:
    for value, name in ((local_qubits, "local_qubits"), (first, "first"), (second, "second")):
        _natural(value, name)
    if max(first, second) >= 1 << local_qubits:
        raise ValueError("basis index outside local register")
    if not math.isfinite(half_angle):
        raise ValueError("base angle is not finite")
    difference = first ^ second
    if difference == 0 or difference & (difference - 1):
        raise ValueError("plane endpoints must differ on exactly one wire")
    target = difference.bit_length() - 1
    controls = [wire for wire in range(local_qubits) if wire != target]
    pattern = sum(((first >> wire) & 1) << i for i, wire in enumerate(controls))
    angle = 2 * half_angle * (-1 if (first >> target) & 1 else 1)
    if not math.isfinite(angle):
        raise ValueError("scaled base angle is not finite")
    for gate in selected_trace(local_qubits, controls, target, pattern):
        if gate[0] == "ry":
            yield ("ry", float(gate[1]) * angle, gate[2])
        else:
            yield gate


def recursive_plan_gates(plan) -> Iterator[tuple]:
    """Use the existing numerical MPS plane plan with the recursive emitter.

    This changes no source cores or completion algorithm and certifies none
    of their floating-point choices. The physical output stays little-endian.
    """
    for offset, planes in enumerate(plan.planes):
        wires = list(range(plan.n, plan.n + plan.ancillas)) + [plan.n - 1 - offset]
        for first, second, half_angle in planes:
            for gate in expand_edge_rotation_recursive(plan.ancillas + 1, first, second, half_angle):
                if gate[0] == "ry":
                    yield ("ry", gate[1], wires[gate[2]])
                else:
                    yield ("cx", wires[gate[1]], wires[gate[2]])


def recursive_resource_counts(plan) -> dict:
    size = 1 << plan.ancillas
    return {"ry": plan.plane_count * size,
            "cx": plan.plane_count * 2 * (size - 1),
            "ancillas": plan.ancillas, "data_qubits": plan.n,
            "oracle_calls": 0, "postselection": False}


def write_recursive_qasm(plan, output: Path) -> None:
    """Stream a numerical diagnostic; never overwrite the Walsh baseline."""
    with output.open("x", encoding="utf-8", newline="\n") as stream:
        stream.write('OPENQASM 2.0;\ninclude "qelib1.inc";\n')
        stream.write(f"qreg q[{plan.n + plan.ancillas}];\n")
        for gate in recursive_plan_gates(plan):
            if gate[0] == "ry":
                stream.write(f"ry({gate[1]:.17g}) q[{gate[2]}];\n")
            else:
                stream.write(f"cx q[{gate[1]}],q[{gate[2]}];\n")
