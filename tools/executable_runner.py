#!/usr/bin/env python3
"""Execute a schema-v2 check policy and independently write requested artifacts."""

from __future__ import annotations

import json
from pathlib import Path
from typing import Mapping, Sequence

import numpy as np

from tools.backends import internal_matrix_backend, openqasm3_backend, qiskit_backend
from tools.executable_ir import CircuitIR, angle_to_text, eval_angle
from tools.executable_manifest import validate_executable_policy


def _selected_backends(name: str) -> tuple[str, ...]:
    return {
        "none": (),
        "qiskitOperator": ("qiskitOperator",),
        "openqasm3RoundTrip": ("openqasm3RoundTrip",),
        "both": ("qiskitOperator", "openqasm3RoundTrip"),
    }[name]


def run_policy(
    ir: CircuitIR,
    policy: Mapping[str, object],
    *,
    target: np.ndarray | None = None,
    system_qubits: Sequence[int] = (),
    clean_qubits: Sequence[int] = (),
) -> dict[str, object]:
    """Run selected checks; unavailable required dependencies block the route."""

    validate_executable_policy(policy)
    check = policy["intermediateCheck"]
    backend_name = str(check["backend"])
    required = bool(check["required"])
    unitary_tolerance = float(check["unitarityTolerance"])
    block_tolerance = float(check["cleanBlockTolerance"])
    reports: dict[str, object] = {
        "internalCanonicalEvaluator": internal_matrix_backend.verify(
            ir, target=target, system_qubits=system_qubits, clean_qubits=clean_qubits
        )
    }
    selected = _selected_backends(backend_name)
    for backend in selected:
        try:
            if backend == "qiskitOperator":
                report = qiskit_backend.verify(
                    ir, target=target, system_qubits=system_qubits,
                    clean_qubits=clean_qubits,
                )
            else:
                _, report = openqasm3_backend.verify(
                    ir, target=target, system_qubits=system_qubits,
                    clean_qubits=clean_qubits, tolerance=unitary_tolerance,
                )
            matrix_errors = [float(report.get("unitarityError", 0.0))]
            if "fullOperatorError" in report:
                matrix_errors.append(float(report["fullOperatorError"]))
            block_errors = [float(report[key]) for key in (
                "cleanBlockMaxEntryError", "cleanBlockOperatorNormError"
            ) if key in report]
            passed = all(error <= unitary_tolerance for error in matrix_errors)
            passed = passed and all(error <= block_tolerance for error in block_errors)
            if backend == "openqasm3RoundTrip" and check["requireCanonicalRoundTrip"]:
                passed = passed and report.get("canonicalRoundTrip") is True
            report["status"] = "passed" if passed else "failed"
            reports[backend] = report
        except (ImportError, RuntimeError) as error:
            reports[backend] = {
                "backend": backend, "status": "unavailable", "reason": str(error),
                "evidenceClasses": [],
            }
    statuses = [str(reports[name]["status"]) for name in selected]  # type: ignore[index]
    passed = not selected or all(status == "passed" for status in statuses)
    unavailable = any(status == "unavailable" for status in statuses)
    blocked = required and unavailable
    return {
        "requestedBackend": backend_name,
        "required": required,
        "status": (
            "blocked" if blocked else "unavailable" if unavailable else
            "passed" if passed else "failed"
        ),
        "reports": reports,
        "circuitDigest": ir.circuit_digest,
        "targetDigest": ir.target_digest,
        "exactProofAuthority": False,
    }


def _qiskit_python(ir: CircuitIR) -> str:
    lines = [
        '\"\"\"Generated gate by gate from ASPBE canonical IR; numerical evidence only.\"\"\"',
        "from qiskit import QuantumCircuit",
        "from qiskit.quantum_info import Operator",
        "",
        f"circuit = QuantumCircuit({ir.qubit_count})",
        f"circuit.global_phase = {eval_angle(ir.global_phase)!r}",
    ]
    for instruction in ir.instructions:
        op = instruction["op"]
        if op in {"ry", "rz"}:
            lines.append(f"# exact angle: {angle_to_text(instruction['angle'])}")
            lines.append(f"circuit.{op}({eval_angle(instruction['angle'])!r}, {instruction['target']})")
        elif op == "x":
            lines.append(f"circuit.x({instruction['target']})")
        else:
            lines.append(f"circuit.cx({instruction['control']}, {instruction['target']})")
    lines.extend(["", "operator = Operator(circuit)", "print(circuit)"])
    return "\n".join(lines) + "\n"


def write_artifacts(
    root: Path,
    ir: CircuitIR,
    policy: Mapping[str, object],
    check_report: Mapping[str, object],
) -> list[str]:
    """Write only requested formats. Checking a backend does not imply export."""

    validate_executable_policy(policy)
    formats = policy["exports"]["formats"]
    written: list[str] = []

    def write(relative: str, content: str) -> None:
        path = root / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content, encoding="utf-8", newline="\n")
        written.append(relative)

    if "canonicalIrJson" in formats:
        write("canonical/circuit.json", json.dumps(ir.payload(), indent=2, sort_keys=True) + "\n")
    if "qiskitPython" in formats:
        write("qiskit/circuit.py", _qiskit_python(ir))
    if "openqasm3" in formats:
        write("openqasm3/circuit.qasm", openqasm3_backend.dumps(ir))
    if "metricsJson" in formats:
        write("reports/check.json", json.dumps(check_report, indent=2, sort_keys=True) + "\n")
    if "circuitText" in formats:
        rows = [f"{index:04d} {instruction['op']} {instruction}" for index, instruction in enumerate(ir.instructions)]
        write("circuit.txt", "\n".join(rows) + "\n")
    return written
