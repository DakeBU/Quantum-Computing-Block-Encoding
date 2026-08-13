#!/usr/bin/env python3
"""Replay the public ASPBE cases without invoking a synthesis model.

This command checks the current certificate and executable-acceptance surface.
It deliberately does not claim to repeat an isolated cold-start discovery run.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
import time
from pathlib import Path
from typing import Any

import numpy as np
import openqasm3
import qiskit
from qiskit import QuantumCircuit
from qiskit.quantum_info import Operator


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_OUTPUT = ROOT / "reports" / "public-case-replay" / "latest.json"
ROBIN_AUDIT = ROOT / "experiments" / "robin-be" / "results" / "audit-summary.json"

LEAN_MODULES = (
    "QuantumBlockEncoding.TextbookStatePreparation",
    "QuantumBlockEncoding.OptimalControl",
    "QuantumBlockEncoding.MainCase",
    "QuantumBlockEncoding.CubicStatePreparation",
    "QuantumBlockEncoding.GHL2025",
    "QuantumBlockEncoding.RobinMatrix",
    "QuantumBlockEncoding.RobinEvolution",
    "QuantumBlockEncoding.Robin.ResourceComparison",
    "QuantumBlockEncoding.Robin.ComplexLCU",
    "QuantumBlockEncoding.Robin.ComplexLCUProjection",
    "QuantumBlockEncoding.Robin.Hadamard8Verified",
    "QuantumBlockEncoding.Robin.Hadamard8BlockEncoding",
    "QuantumBlockEncoding.Robin.SixSlotOptimal",
    "QuantumBlockEncoding.Robin.SymmetryFourSlot",
    "QuantumBlockEncoding.Robin.SymmetryFourSlotLogicalUnitary",
    "QuantumBlockEncoding.Robin.SymmetryFourSlotBlockEncoding",
    "QuantumBlockEncoding.Robin.SystemConjugation",
    "QuantumBlockEncoding.Robin.SymmetryXorFourSlotLogicalUnitary",
    "QuantumBlockEncoding.Robin.SymmetryXorFourSlotPrimitive",
    "QuantumBlockEncoding.Robin.PaperSevenPrimitive",
    "QuantumBlockEncoding.Robin.Figure4Primitive",
)

HASHED_INPUTS = (
    "tools/qbe.py",
    "tools/qbe_control.py",
    "tools/audit_population_evolution.py",
    "tools/export_hard_cubic_householder.py",
    "requirements-executable.txt",
    "executable-exports/QBE-OP-OPTCTRL-001/qiskit/export.py",
    "executable-exports/QBE-MAIN-CASE-HIER-COLD-001/qiskit/export.py",
    "QuantumBlockEncoding/TextbookStatePreparation.lean",
    "QuantumBlockEncoding/OptimalControl.lean",
    "QuantumBlockEncoding/MainCase.lean",
    "QuantumBlockEncoding/CubicStatePreparation.lean",
    "QuantumBlockEncoding/GHL2025.lean",
    "QuantumBlockEncoding/RobinMatrix.lean",
    "QuantumBlockEncoding/RobinEvolution.lean",
    "QuantumBlockEncoding/Robin/FixedN3Data.lean",
    "QuantumBlockEncoding/Robin/SourceBaseline.lean",
    "QuantumBlockEncoding/Robin/WeightedPermutation.lean",
    "QuantumBlockEncoding/Robin/EvolvedCandidates.lean",
    "QuantumBlockEncoding/Robin/ResourceComparison.lean",
    "QuantumBlockEncoding/Robin/ComplexLCU.lean",
    "QuantumBlockEncoding/Robin/ComplexLCUProjection.lean",
    "QuantumBlockEncoding/Robin/Hadamard8Verified.lean",
    "QuantumBlockEncoding/Robin/Hadamard8BlockEncoding.lean",
    "QuantumBlockEncoding/Robin/SixSlotOptimal.lean",
    "QuantumBlockEncoding/Robin/SymmetryFourSlot.lean",
    "QuantumBlockEncoding/Robin/SymmetryFourSlotLogicalUnitary.lean",
    "QuantumBlockEncoding/Robin/SymmetryFourSlotBlockEncoding.lean",
    "QuantumBlockEncoding/Robin/SystemConjugation.lean",
    "QuantumBlockEncoding/Robin/SymmetryXorFourSlotLogicalUnitary.lean",
    "QuantumBlockEncoding/Robin/SymmetryXorFourSlotPrimitive.lean",
    "QuantumBlockEncoding/Robin/PaperSevenPrimitive.lean",
    "QuantumBlockEncoding/Robin/Figure4Primitive.lean",
    "tools/executable_ir.py",
    "tools/backends/internal_matrix_backend.py",
    "tools/backends/qiskit_backend.py",
    "tools/backends/openqasm3_backend.py",
    "tools/export_robin_evolution.py",
)


def run(command: list[str]) -> dict[str, Any]:
    started = time.monotonic()
    result = subprocess.run(
        command,
        cwd=ROOT,
        check=False,
        capture_output=True,
        text=True,
    )
    elapsed = time.monotonic() - started
    return {
        "command": command,
        "exit_code": result.returncode,
        "elapsed_seconds": round(elapsed, 6),
        "stdout": result.stdout.strip(),
        "stderr": result.stderr.strip(),
        "passed": result.returncode == 0,
    }


def parse_last_json(record: dict[str, Any]) -> dict[str, Any]:
    text = str(record["stdout"])
    start = text.find("{")
    if start < 0:
        return {}
    try:
        return json.loads(text[start:])
    except json.JSONDecodeError:
        return {}


def source_digest() -> str:
    digest = hashlib.sha256()
    for relative in HASHED_INPUTS:
        path = ROOT / relative
        digest.update(relative.encode())
        digest.update(b"\0")
        digest.update(path.read_bytes())
        digest.update(b"\0")
    return digest.hexdigest()


def git_value(*args: str) -> str:
    result = subprocess.run(
        ["git", *args],
        cwd=ROOT,
        check=False,
        capture_output=True,
        text=True,
    )
    return result.stdout.strip() if result.returncode == 0 else ""


def textbook_state_preparation_check(atol: float = 1e-12) -> dict[str, Any]:
    cases: list[dict[str, Any]] = []
    targets = {
        "pauli_x": np.asarray([0.0, 1.0], dtype=np.complex128),
        "hadamard": np.asarray([1.0, 1.0], dtype=np.complex128) / np.sqrt(2.0),
    }
    for name, target in targets.items():
        circuit = QuantumCircuit(1, name=name)
        if name == "pauli_x":
            circuit.x(0)
            lean_anchor = (
                "TextbookStatePreparation.pauliXCertificate_prepares_one"
            )
        else:
            circuit.h(0)
            lean_anchor = (
                "TextbookStatePreparation.hadamardCertificate_prepares_plus"
            )
        matrix = np.asarray(Operator(circuit).data, dtype=np.complex128)
        prepared = matrix @ np.asarray([1.0, 0.0], dtype=np.complex128)
        state_error = float(np.linalg.norm(prepared - target, ord=2))
        unitary_error = float(
            np.linalg.norm(
                matrix.conj().T @ matrix - np.eye(2, dtype=np.complex128),
                ord=2,
            )
        )
        cases.append(
            {
                "name": name,
                "lean_anchor": lean_anchor,
                "state_error": state_error,
                "unitary_error": unitary_error,
                "passed": state_error <= atol and unitary_error <= atol,
            }
        )
    return {
        "case": "Textbook state preparation",
        "semantic_tier": "exact one-qubit circuit",
        "cases": cases,
        "passed": all(item["passed"] for item in cases),
    }


def main() -> None:
    replay_started = time.monotonic()
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument(
        "--skip-lean",
        action="store_true",
        help="skip the module build; the report will not count as full acceptance",
    )
    args = parser.parse_args()

    checks: list[dict[str, Any]] = []
    if not args.skip_lean:
        checks.append(run(["lake", "build", *LEAN_MODULES]))

    controller = run(
        [
            "python3",
            "tools/audit_population_evolution.py",
            "--output",
            "reports/ABEIS-CONTROL-V5/cold-start-population-audit.json",
        ]
    )
    checks.append(controller)

    case_results: list[dict[str, Any]] = [textbook_state_preparation_check()]
    commands = (
        (
            "BE Case 1 champion",
            [
                "python3",
                "executable-exports/QBE-OP-OPTCTRL-001/qiskit/export.py",
                "--json",
            ],
        ),
        (
            "BE Case 1 isolated baseline",
            [
                "python3",
                "executable-exports/QBE-MAIN-CASE-HIER-COLD-001/qiskit/export.py",
                "--json",
            ],
        ),
        (
            "BE Case 2 cold",
            [
                "python3",
                "tools/export_hard_cubic_householder.py",
                "--task",
                "QBE-HARD-CUBIC-DIAGONAL-HIER-COLD-001",
                "--n",
                "2",
            ],
        ),
        (
            "BE Case 2 hinted",
            [
                "python3",
                "tools/export_hard_cubic_householder.py",
                "--task",
                "QBE-HARD-CUBIC-DIAGONAL-HIER-HINTED-001",
                "--n",
                "2",
            ],
        ),
        (
            "Robin XOR four-slot T3",
            [
                "python3", "tools/export_robin_evolution.py",
                "--task", "QBE-ROBIN-BE-WARM-001", "--arm", "warm",
            ],
        ),
    )
    for label, command in commands:
        record = run(command)
        checks.append(record)
        payload = parse_last_json(record)
        case_results.append(
            {
                "case": label,
                "passed": bool(record["passed"] and payload.get("passed")),
                "elapsed_seconds": record["elapsed_seconds"],
                "acceptance": payload,
            }
        )

    lean_passed = bool(not args.skip_lean and checks[0]["passed"])
    controller_payload = parse_last_json(controller)
    robin_audit: dict[str, Any] = {}
    if ROBIN_AUDIT.is_file():
        audit_payload = json.loads(ROBIN_AUDIT.read_text(encoding="utf-8"))
        audit_arms = audit_payload.get("arms", [])
        robin_audit = next(
            (arm for arm in audit_arms if arm.get("arm") == "warm"), {}
        )
    completed_robin_cycles = int(robin_audit.get("completed_cycles", 0) or 0)
    payload = {
        "schema_version": 1,
        "replay_scope": "certificate-and-executable acceptance; no synthesis model",
        "cold_start_claim": False,
        "figure_policy": (
            "Do not replace historical candidate or convergence figures from this "
            "replay. New figures require a fresh isolated search under a frozen "
            "model, budget, task contract, and memory policy."
        ),
        "git_commit": git_value("rev-parse", "HEAD"),
        "git_branch": git_value("branch", "--show-current"),
        "source_digest": source_digest(),
        "executable_dependencies": {
            "numpy": np.__version__,
            "openqasm3": getattr(openqasm3, "__version__", "unknown"),
            "qiskit": qiskit.__version__,
        },
        "lean_modules": list(LEAN_MODULES),
        "lean_passed": lean_passed,
        "controller_population_replay_passed": bool(
            controller["passed"] and controller_payload.get("passed")
        ),
        "certificate_replay_timings_seconds": {
            "lean_modules": (
                checks[0]["elapsed_seconds"] if not args.skip_lean else None
            ),
            "population_controller": controller["elapsed_seconds"],
            "total": round(time.monotonic() - replay_started, 6),
        },
        "cases": case_results,
        "robin": {
            "status": "XOR four-slot T3 exact primitive block encoding; source Figure-4 remains partial",
            "included_in_lean_gate": True,
            "evolution_replayed": completed_robin_cycles > 0,
            "reason": (
                f"The audited warm run completed {completed_robin_cycles} controller "
                "cycles and produced no verified block-encoding root or resource "
                "point. Deterministic proof completion after the run produced an "
                "exact XOR four-slot {X,RY,RZ,CX} refinement and verified block "
                "encoding. Gate-by-gate Qiskit and OpenQASM checks replay that "
                "Lean-owned artifact. Paper-seven and fixed Figure-4 primitive "
                "roots remain partial, so no source-level T3 winner is claimed."
                if robin_audit
                else "No audited warm evolution result is available."
            ),
            "audit": robin_audit,
        },
    }
    payload["passed"] = bool(
        lean_passed
        and payload["controller_population_replay_passed"]
        and all(case["passed"] for case in case_results)
    )
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    print(json.dumps(payload, indent=2, sort_keys=True))
    if not payload["passed"]:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
