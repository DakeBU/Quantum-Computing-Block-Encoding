#!/usr/bin/env python3
"""Backend-neutral executable circuit IR and project-owned matrix semantics."""

from __future__ import annotations

import hashlib
import json
import math
from dataclasses import dataclass
from fractions import Fraction
from typing import Any, Iterable, Mapping, Sequence

import numpy as np


PRIMITIVE_BASIS = ("x", "ry", "rz", "cx")
ENDIANNESS = "little-endian: qubit 0 is the least-significant basis bit"


def _canonical_json(value: object) -> str:
    return json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=True)


def sha256_json(value: object) -> str:
    return hashlib.sha256(_canonical_json(value).encode("utf-8")).hexdigest()


def rational(numerator: int, denominator: int = 1) -> dict[str, object]:
    value = Fraction(numerator, denominator)
    return {"kind": "rational", "numerator": value.numerator, "denominator": value.denominator}


def pi_rational(numerator: int, denominator: int = 1) -> dict[str, object]:
    value = Fraction(numerator, denominator)
    return {"kind": "piRational", "numerator": value.numerator, "denominator": value.denominator}


def twice_arccos_rational(numerator: int, denominator: int = 1) -> dict[str, object]:
    value = Fraction(numerator, denominator)
    if abs(value) > 1:
        raise ValueError("twiceArccosRational requires a value in [-1,1]")
    return {
        "kind": "twiceArccosRational",
        "numerator": value.numerator,
        "denominator": value.denominator,
    }


def twice_arccos_sqrt_rational(
    numerator: int, denominator: int = 1
) -> dict[str, object]:
    value = Fraction(numerator, denominator)
    if not 0 <= value <= 1:
        raise ValueError("twiceArccosSqrtRational requires a value in [0,1]")
    return {
        "kind": "twiceArccosSqrtRational",
        "numerator": value.numerator,
        "denominator": value.denominator,
    }


def angle_neg(value: Mapping[str, object]) -> dict[str, object]:
    return {"kind": "neg", "value": dict(value)}


def angle_add(*terms: Mapping[str, object]) -> dict[str, object]:
    return {"kind": "add", "terms": [dict(term) for term in terms]}


def angle_scale(
    numerator: int, denominator: int, value: Mapping[str, object]
) -> dict[str, object]:
    factor = Fraction(numerator, denominator)
    return {
        "kind": "scale",
        "numerator": factor.numerator,
        "denominator": factor.denominator,
        "value": dict(value),
    }


def validate_angle(value: Mapping[str, object]) -> None:
    kind = value.get("kind")
    if kind in {
        "rational", "piRational", "twiceArccosRational",
        "twiceArccosSqrtRational",
    }:
        numerator = value.get("numerator")
        denominator = value.get("denominator")
        if not isinstance(numerator, int) or not isinstance(denominator, int) or denominator == 0:
            raise ValueError(f"invalid rational angle: {value!r}")
        if kind == "twiceArccosRational" and abs(Fraction(numerator, denominator)) > 1:
            raise ValueError("twiceArccosRational requires a value in [-1,1]")
        if kind == "twiceArccosSqrtRational" and not 0 <= Fraction(numerator, denominator) <= 1:
            raise ValueError("twiceArccosSqrtRational requires a value in [0,1]")
        return
    if kind == "neg" and isinstance(value.get("value"), Mapping):
        validate_angle(value["value"])  # type: ignore[arg-type]
        return
    if kind == "add" and isinstance(value.get("terms"), list) and value["terms"]:
        for term in value["terms"]:  # type: ignore[index]
            if not isinstance(term, Mapping):
                raise ValueError("angle add terms must be objects")
            validate_angle(term)
        return
    if kind == "scale" and isinstance(value.get("value"), Mapping):
        numerator = value.get("numerator")
        denominator = value.get("denominator")
        if not isinstance(numerator, int) or not isinstance(denominator, int) or denominator == 0:
            raise ValueError(f"invalid rational scale: {value!r}")
        validate_angle(value["value"])  # type: ignore[arg-type]
        return
    raise ValueError(f"unsupported exact angle expression: {value!r}")


def eval_angle(value: Mapping[str, object]) -> float:
    validate_angle(value)
    kind = value["kind"]
    if kind in {
        "rational", "piRational", "twiceArccosRational",
        "twiceArccosSqrtRational",
    }:
        q = float(Fraction(int(value["numerator"]), int(value["denominator"])))
        if kind == "rational":
            return q
        if kind == "piRational":
            return math.pi * q
        if kind == "twiceArccosSqrtRational":
            return 2.0 * math.acos(math.sqrt(q))
        return 2.0 * math.acos(q)
    if kind == "neg":
        return -eval_angle(value["value"])  # type: ignore[arg-type]
    if kind == "scale":
        factor = Fraction(int(value["numerator"]), int(value["denominator"]))
        return float(factor) * eval_angle(value["value"])  # type: ignore[arg-type]
    return sum(eval_angle(term) for term in value["terms"])  # type: ignore[arg-type]


def angle_to_text(value: Mapping[str, object]) -> str:
    validate_angle(value)
    kind = value["kind"]
    if kind == "rational":
        return f"{value['numerator']}/{value['denominator']}"
    if kind == "piRational":
        return f"pi*({value['numerator']}/{value['denominator']})"
    if kind == "twiceArccosRational":
        return f"2*arccos({value['numerator']}/{value['denominator']})"
    if kind == "twiceArccosSqrtRational":
        return f"2*arccos(sqrt({value['numerator']}/{value['denominator']}))"
    if kind == "neg":
        return f"-({angle_to_text(value['value'])})"  # type: ignore[arg-type]
    if kind == "scale":
        return (
            f"({value['numerator']}/{value['denominator']})*"
            f"({angle_to_text(value['value'])})"  # type: ignore[arg-type]
        )
    return " + ".join(angle_to_text(term) for term in value["terms"])  # type: ignore[arg-type]


@dataclass(frozen=True)
class CircuitIR:
    qubit_count: int
    registers: tuple[dict[str, object], ...]
    instructions: tuple[dict[str, object], ...]
    source_commit: str
    lean_roots: tuple[str, ...]
    target_digest: str
    global_phase: dict[str, object]
    metadata: dict[str, object]
    schema_version: int = 1

    def validate(self) -> None:
        if self.schema_version != 1 or self.qubit_count <= 0:
            raise ValueError("unsupported schema or qubit count")
        seen: set[int] = set()
        for register in self.registers:
            if not isinstance(register.get("name"), str) or not isinstance(register.get("qubits"), list):
                raise ValueError("each register needs a name and qubit list")
            for qubit in register["qubits"]:  # type: ignore[index]
                if not isinstance(qubit, int) or not 0 <= qubit < self.qubit_count or qubit in seen:
                    raise ValueError("register qubits must form a disjoint in-range set")
                seen.add(qubit)
        if seen != set(range(self.qubit_count)):
            raise ValueError("registers must cover every circuit qubit exactly once")
        validate_angle(self.global_phase)
        for instruction in self.instructions:
            operation = instruction.get("op")
            if operation not in PRIMITIVE_BASIS:
                raise ValueError(f"non-primitive instruction rejected: {operation!r}")
            qubits = instruction_qubits(instruction)
            if any(not 0 <= qubit < self.qubit_count for qubit in qubits):
                raise ValueError("instruction qubit is out of range")
            if len(set(qubits)) != len(qubits):
                raise ValueError("an instruction cannot use the same qubit twice")
            if operation in {"ry", "rz"}:
                angle = instruction.get("angle")
                if not isinstance(angle, Mapping):
                    raise ValueError("rotation requires a structured angle")
                validate_angle(angle)

    def payload(self, *, include_digest: bool = True) -> dict[str, object]:
        self.validate()
        payload: dict[str, object] = {
            "schemaVersion": self.schema_version,
            "qubitCount": self.qubit_count,
            "registers": list(self.registers),
            "endianness": ENDIANNESS,
            "primitiveBasis": list(PRIMITIVE_BASIS),
            "globalPhase": self.global_phase,
            "instructions": list(self.instructions),
            "sourceCommit": self.source_commit,
            "leanRoots": list(self.lean_roots),
            "targetDigest": self.target_digest,
            "metadata": self.metadata,
        }
        if include_digest:
            payload["circuitDigest"] = sha256_json(payload)
        return payload

    @property
    def circuit_digest(self) -> str:
        return str(self.payload()["circuitDigest"])

    @classmethod
    def from_payload(cls, payload: Mapping[str, object]) -> "CircuitIR":
        if payload.get("endianness") != ENDIANNESS:
            raise ValueError("unsupported or missing endianness")
        if tuple(payload.get("primitiveBasis", [])) != PRIMITIVE_BASIS:
            raise ValueError("primitive basis does not match ASPBE T3 basis")
        result = cls(
            schema_version=int(payload.get("schemaVersion", 0)),
            qubit_count=int(payload.get("qubitCount", 0)),
            registers=tuple(dict(value) for value in payload.get("registers", [])),  # type: ignore[arg-type]
            instructions=tuple(dict(value) for value in payload.get("instructions", [])),  # type: ignore[arg-type]
            source_commit=str(payload.get("sourceCommit", "")),
            lean_roots=tuple(str(value) for value in payload.get("leanRoots", [])),  # type: ignore[arg-type]
            target_digest=str(payload.get("targetDigest", "")),
            global_phase=dict(payload.get("globalPhase", {})),  # type: ignore[arg-type]
            metadata=dict(payload.get("metadata", {})),  # type: ignore[arg-type]
        )
        result.validate()
        supplied = payload.get("circuitDigest")
        if supplied is not None and supplied != result.circuit_digest:
            raise ValueError("canonical circuit digest mismatch")
        return result


def instruction_qubits(instruction: Mapping[str, object]) -> tuple[int, ...]:
    operation = instruction.get("op")
    if operation in {"x", "ry", "rz"}:
        return (int(instruction["target"]),)
    if operation == "cx":
        return (int(instruction["control"]), int(instruction["target"]))
    raise ValueError(f"unsupported instruction {operation!r}")


def canonicalize_ir(ir: CircuitIR) -> dict[str, object]:
    return ir.payload(include_digest=False)


def primitive_resource(instructions: Sequence[Mapping[str, object]]) -> dict[str, int]:
    last_layer = [-1] * (max((q for gate in instructions for q in instruction_qubits(gate)), default=-1) + 1)
    depth = 0
    for gate in instructions:
        qubits = instruction_qubits(gate)
        layer = max((last_layer[q] for q in qubits), default=-1) + 1
        for qubit in qubits:
            last_layer[qubit] = layer
        depth = max(depth, layer + 1)
    return {
        "gateCount": len(instructions),
        "depth": depth,
        "oracleCalls": 0,
    }


def compile_uniformly_controlled_ry(
    controls: Sequence[int],
    target: int,
    angles: Mapping[tuple[int, ...], Mapping[str, object]],
) -> list[dict[str, object]]:
    """Mirror Lean's reference UCRY compiler exactly.

    Control tuples are indexed low-to-high in ``controls``.  The returned
    instruction list is chronological and contains only ``ry`` and ``cx``.
    """
    controls = tuple(controls)
    expected = {
        tuple((flat >> wire) & 1 for wire in range(len(controls)))
        for flat in range(1 << len(controls))
    }
    if set(angles) != expected:
        raise ValueError("UCRY angle table must cover every control assignment")
    if target in controls or len(set(controls)) != len(controls):
        raise ValueError("UCRY controls must be distinct from each other and target")

    def recurse(
        wires: tuple[int, ...],
        table: Mapping[tuple[int, ...], Mapping[str, object]],
    ) -> list[dict[str, object]]:
        if not wires:
            return [{"op": "ry", "target": target, "angle": dict(table[()])}]
        additions: dict[tuple[int, ...], dict[str, object]] = {}
        subtractions: dict[tuple[int, ...], dict[str, object]] = {}
        for tail in {key[1:] for key in table}:
            additions[tail] = angle_scale(
                1, 2, angle_add(table[(0,) + tail], table[(1,) + tail])
            )
            subtractions[tail] = angle_scale(
                1, 2,
                angle_add(table[(0,) + tail], angle_neg(table[(1,) + tail])),
            )
        controlled = {"op": "cx", "control": wires[0], "target": target}
        return (
            recurse(wires[1:], additions)
            + [controlled]
            + recurse(wires[1:], subtractions)
            + [controlled]
        )

    return recurse(controls, angles)


def _one_qubit_full(qubits: int, target: int, gate: np.ndarray) -> np.ndarray:
    size = 1 << qubits
    result = np.zeros((size, size), dtype=np.complex128)
    mask = 1 << target
    for column in range(size):
        input_bit = 1 if column & mask else 0
        base = column & ~mask
        for output_bit in (0, 1):
            row = base | (output_bit << target)
            result[row, column] = gate[output_bit, input_bit]
    return result


def instruction_matrix(qubits: int, instruction: Mapping[str, object]) -> np.ndarray:
    operation = instruction["op"]
    target = int(instruction.get("target", 0))
    if operation == "x":
        return _one_qubit_full(qubits, target, np.array([[0, 1], [1, 0]], dtype=np.complex128))
    if operation in {"ry", "rz"}:
        theta = eval_angle(instruction["angle"])  # type: ignore[arg-type]
        if operation == "ry":
            gate = np.array(
                [[math.cos(theta / 2), -math.sin(theta / 2)],
                 [math.sin(theta / 2), math.cos(theta / 2)]],
                dtype=np.complex128,
            )
        else:
            gate = np.diag([np.exp(-0.5j * theta), np.exp(0.5j * theta)])
        return _one_qubit_full(qubits, target, gate)
    if operation == "cx":
        control = int(instruction["control"])
        size = 1 << qubits
        result = np.zeros((size, size), dtype=np.complex128)
        for column in range(size):
            row = column ^ (1 << target) if column & (1 << control) else column
            result[row, column] = 1
        return result
    raise ValueError(f"unsupported primitive instruction {operation!r}")


def evaluate_ir(ir: CircuitIR) -> np.ndarray:
    ir.validate()
    size = 1 << ir.qubit_count
    result = np.eye(size, dtype=np.complex128)
    for instruction in ir.instructions:
        operation = instruction["op"]
        target = int(instruction.get("target", 0))
        target_mask = 1 << target
        if operation == "x":
            permutation = np.arange(size) ^ target_mask
            result = result[permutation, :]
        elif operation == "cx":
            control_mask = 1 << int(instruction["control"])
            permutation = np.arange(size)
            active = (permutation & control_mask) != 0
            permutation[active] ^= target_mask
            result = result[permutation, :]
        elif operation == "rz":
            theta = eval_angle(instruction["angle"])  # type: ignore[arg-type]
            phases = np.where(
                (np.arange(size) & target_mask) == 0,
                np.exp(-0.5j * theta),
                np.exp(0.5j * theta),
            )
            result = phases[:, None] * result
        elif operation == "ry":
            theta = eval_angle(instruction["angle"])  # type: ignore[arg-type]
            cosine = math.cos(theta / 2)
            sine = math.sin(theta / 2)
            zero_rows = np.arange(size)[(np.arange(size) & target_mask) == 0]
            one_rows = zero_rows | target_mask
            old_zero = result[zero_rows, :].copy()
            old_one = result[one_rows, :].copy()
            result[zero_rows, :] = cosine * old_zero - sine * old_one
            result[one_rows, :] = sine * old_zero + cosine * old_one
        else:  # Guarded by CircuitIR.validate; retained for type checkers.
            raise ValueError(f"unsupported primitive instruction {operation!r}")
    phase = eval_angle(ir.global_phase)
    return np.exp(1j * phase) * result


def clean_block(matrix: np.ndarray, *, system_qubits: Sequence[int], clean_qubits: Sequence[int]) -> np.ndarray:
    qubits = int(round(math.log2(matrix.shape[0])))
    if matrix.shape != (1 << qubits, 1 << qubits):
        raise ValueError("matrix dimension is not a power-of-two square")
    if set(system_qubits) | set(clean_qubits) != set(range(qubits)):
        raise ValueError("system and clean qubits must partition the circuit")
    indices = []
    for system_value in range(1 << len(system_qubits)):
        basis = 0
        for offset, qubit in enumerate(system_qubits):
            basis |= ((system_value >> offset) & 1) << qubit
        indices.append(basis)
    return matrix[np.ix_(indices, indices)]


def max_entry_error(left: np.ndarray, right: np.ndarray) -> float:
    return float(np.max(np.abs(left - right)))


def operator_error(left: np.ndarray, right: np.ndarray) -> float:
    return float(np.linalg.norm(left - right, ord=2))


def unitarity_error(matrix: np.ndarray) -> float:
    return operator_error(matrix.conj().T @ matrix, np.eye(matrix.shape[0], dtype=np.complex128))
