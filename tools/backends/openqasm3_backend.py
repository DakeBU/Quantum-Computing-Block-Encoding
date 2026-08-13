#!/usr/bin/env python3
"""Strict OpenQASM 3 writer, parser, importer, and semantic round-trip check."""

from __future__ import annotations

import base64
import json
from typing import Mapping, Sequence

import numpy as np

from tools.executable_ir import (
    CircuitIR,
    canonicalize_ir,
    clean_block,
    eval_angle,
    evaluate_ir,
    max_entry_error,
    operator_error,
    unitarity_error,
)


ANGLE_PREFIX = "// ASPBE_EXACT_ANGLE "


def _encoded_angle(value: Mapping[str, object]) -> str:
    raw = json.dumps(value, sort_keys=True, separators=(",", ":")).encode("utf-8")
    return base64.urlsafe_b64encode(raw).decode("ascii")


def _decoded_angle(value: str) -> dict[str, object]:
    return json.loads(base64.urlsafe_b64decode(value.encode("ascii")).decode("utf-8"))


def dumps(ir: CircuitIR, *, precision: int = 17) -> str:
    ir.validate()
    lines = [
        "OPENQASM 3.0;",
        'include "stdgates.inc";',
        f"qubit[{ir.qubit_count}] q;",
        f"// ASPBE_ENDIANNESS {json.dumps('little-endian: qubit 0 is the least-significant basis bit')}",
    ]
    phase = eval_angle(ir.global_phase)
    if abs(phase) > 0:
        raise ValueError("OpenQASM strict subset currently requires explicit zero global phase")
    for index, instruction in enumerate(ir.instructions):
        operation = instruction["op"]
        if operation in {"ry", "rz"}:
            angle = instruction["angle"]
            lines.append(f"{ANGLE_PREFIX}{index} {_encoded_angle(angle)}")
            decimal = format(eval_angle(angle), f".{precision}g")
            lines.append(f"{operation}({decimal}) q[{instruction['target']}];")
        elif operation == "x":
            lines.append(f"x q[{instruction['target']}];")
        elif operation == "cx":
            lines.append(f"cx q[{instruction['control']}], q[{instruction['target']}];")
        else:
            raise ValueError(f"OpenQASM primitive checker rejects {operation!r}")
    return "\n".join(lines) + "\n"


def _angle_comments(text: str) -> dict[int, dict[str, object]]:
    result: dict[int, dict[str, object]] = {}
    for line in text.splitlines():
        if line.startswith(ANGLE_PREFIX):
            _, _, index, encoded = line.split(maxsplit=3)
            result[int(index)] = _decoded_angle(encoded)
    return result


def loads(text: str, template: CircuitIR, *, tolerance: float = 1e-12) -> CircuitIR:
    try:
        import openqasm3
        from openqasm3 import ast
    except ImportError as error:
        raise RuntimeError(f"openqasm3 unavailable: {error}") from error
    program = openqasm3.parse(text)
    exact_angles = _angle_comments(text)
    qubit_count: int | None = None
    instructions: list[dict[str, object]] = []

    def qubit_index(node) -> int:
        if not isinstance(node, ast.IndexedIdentifier) or node.name.name != "q":
            raise ValueError("strict importer accepts only q[index]")
        if len(node.indices) != 1 or len(node.indices[0]) != 1 or not isinstance(node.indices[0][0], ast.IntegerLiteral):
            raise ValueError("strict importer requires one literal qubit index")
        return int(node.indices[0][0].value)

    for statement in program.statements:
        if isinstance(statement, ast.Include):
            if statement.filename != "stdgates.inc":
                raise ValueError("only stdgates.inc may be included")
        elif isinstance(statement, ast.QubitDeclaration):
            if statement.qubit.name != "q" or not isinstance(statement.size, ast.IntegerLiteral):
                raise ValueError("strict importer requires one sized q register")
            qubit_count = int(statement.size.value)
        elif isinstance(statement, ast.QuantumGate):
            if statement.modifiers or statement.duration is not None:
                raise ValueError("gate modifiers and durations are unsupported")
            name = statement.name.name
            index = len(instructions)
            if name in {"x"} and not statement.arguments and len(statement.qubits) == 1:
                instructions.append({"op": name, "target": qubit_index(statement.qubits[0])})
            elif name == "cx" and not statement.arguments and len(statement.qubits) == 2:
                instructions.append({"op": "cx", "control": qubit_index(statement.qubits[0]), "target": qubit_index(statement.qubits[1])})
            elif name in {"ry", "rz"} and len(statement.arguments) == 1 and len(statement.qubits) == 1:
                if index not in exact_angles:
                    raise ValueError("rotation is missing its exact ASPBE angle record")
                argument = statement.arguments[0]
                if not isinstance(argument, (ast.FloatLiteral, ast.IntegerLiteral)):
                    raise ValueError("strict importer requires a deterministic numeric rotation literal")
                if abs(float(argument.value) - eval_angle(exact_angles[index])) > tolerance:
                    raise ValueError("OpenQASM decimal does not match its exact source expression")
                instructions.append({"op": name, "target": qubit_index(statement.qubits[0]), "angle": exact_angles[index]})
            else:
                raise ValueError(f"unsupported OpenQASM statement or gate: {name}")
        else:
            raise ValueError(f"unsupported OpenQASM statement: {type(statement).__name__}")
    if qubit_count != template.qubit_count:
        raise ValueError("round-tripped qubit count changed")
    result = CircuitIR(
        qubit_count=qubit_count,
        registers=template.registers,
        instructions=tuple(instructions),
        source_commit=template.source_commit,
        lean_roots=template.lean_roots,
        target_digest=template.target_digest,
        global_phase=template.global_phase,
        metadata=template.metadata,
    )
    result.validate()
    return result


def verify(
    ir: CircuitIR,
    *,
    target: np.ndarray | None = None,
    system_qubits: Sequence[int] = (),
    clean_qubits: Sequence[int] = (),
    tolerance: float = 1e-10,
) -> tuple[str, dict[str, object]]:
    import openqasm3

    text = dumps(ir)
    round_tripped = loads(text, ir, tolerance=tolerance)
    canonical_equal = canonicalize_ir(round_tripped) == canonicalize_ir(ir)
    reference = evaluate_ir(ir)
    actual = evaluate_ir(round_tripped)
    result: dict[str, object] = {
        "backend": "openqasm3RoundTrip",
        "status": "passed" if canonical_equal else "failed",
        "evidenceClasses": ["syntaxOnly", "roundTrip", "numericUnitary"],
        "openqasm3Version": getattr(openqasm3, "__version__", "unknown"),
        "canonicalRoundTrip": canonical_equal,
        "unitarityError": unitarity_error(actual),
        "fullOperatorError": operator_error(actual, reference),
        "qubitCount": ir.qubit_count,
        "targetDigest": ir.target_digest,
        "circuitDigest": ir.circuit_digest,
        "decimalPrecisionDigits": 17,
        "roundingMode": "Python format round-to-nearest",
        "globalPhasePolicy": "exact-zero-or-explicitly-corrected",
    }
    if target is not None:
        projected = clean_block(actual, system_qubits=system_qubits, clean_qubits=clean_qubits)
        result.update(
            {
                "evidenceClasses": ["syntaxOnly", "roundTrip", "numericUnitary", "numericCleanBlock"],
                "cleanBlockMaxEntryError": max_entry_error(projected, target),
                "cleanBlockOperatorNormError": operator_error(projected, target),
            }
        )
    return text, result
