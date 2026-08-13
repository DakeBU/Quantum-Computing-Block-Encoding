#!/usr/bin/env python3
"""Contract and mutation tests for canonical IR and executable backends."""

from __future__ import annotations

import copy
import tempfile
import unittest
from pathlib import Path
from unittest import mock

import numpy as np

from tools.backends import internal_matrix_backend, qiskit_backend
from tools.executable_ir import CircuitIR, canonicalize_ir, evaluate_ir, pi_rational, rational
from tools.executable_manifest import (
    default_executable_policy, migrate_task_packet, validate_executable_policy,
)
from tools.executable_runner import run_policy, write_artifacts


def bell_ir() -> CircuitIR:
    return CircuitIR(
        qubit_count=2,
        registers=(
            {"name": "first", "qubits": [0]},
            {"name": "second", "qubits": [1]},
        ),
        instructions=(
            {"op": "ry", "target": 0, "angle": pi_rational(1, 2)},
            {"op": "cx", "control": 0, "target": 1},
        ),
        source_commit="test",
        lean_roots=("Test.root",),
        target_digest="0" * 64,
        global_phase=rational(0),
        metadata={"fixture": "bell"},
    )


class ExecutableBackendTests(unittest.TestCase):
    def test_internal_and_qiskit_gate_semantics_agree(self) -> None:
        ir = bell_ir()
        internal = internal_matrix_backend.verify(ir)
        qiskit = qiskit_backend.verify(ir)
        self.assertLess(float(internal["unitarityError"]), 1e-12)
        self.assertLess(float(qiskit["fullOperatorError"]), 1e-12)
        self.assertEqual(qiskit["gateCounts"], {"ry": 1, "cx": 1})

    def test_dense_or_opaque_instruction_is_rejected(self) -> None:
        ir = bell_ir()
        payload = ir.payload(include_digest=False)
        payload["instructions"] = [{"op": "unitary", "target": 0}]
        with self.assertRaisesRegex(ValueError, "non-primitive"):
            CircuitIR.from_payload(payload)

    def test_mutations_change_semantics(self) -> None:
        reference = evaluate_ir(bell_ir())
        mutations = []
        angle = copy.deepcopy(bell_ir().payload(include_digest=False))
        angle["instructions"][0]["angle"] = pi_rational(1, 3)
        mutations.append(CircuitIR.from_payload(angle))
        delete = copy.deepcopy(bell_ir().payload(include_digest=False))
        delete["instructions"] = delete["instructions"][:-1]
        mutations.append(CircuitIR.from_payload(delete))
        swap = copy.deepcopy(bell_ir().payload(include_digest=False))
        swap["instructions"][1] = {"op": "cx", "control": 1, "target": 0}
        mutations.append(CircuitIR.from_payload(swap))
        for mutation in mutations:
            self.assertGreater(np.linalg.norm(evaluate_ir(mutation) - reference, ord=2), 1e-6)

    def test_qiskit_screen_rejects_mutations_against_the_frozen_target(self) -> None:
        original = bell_ir()
        target = evaluate_ir(original)
        policy = default_executable_policy()
        policy["intermediateCheck"]["backend"] = "qiskitOperator"
        mutations = []

        changed_angle = copy.deepcopy(original.payload(include_digest=False))
        changed_angle["instructions"][0]["angle"] = pi_rational(1, 3)
        mutations.append(CircuitIR.from_payload(changed_angle))

        deleted_cx = copy.deepcopy(original.payload(include_digest=False))
        deleted_cx["instructions"] = deleted_cx["instructions"][:-1]
        mutations.append(CircuitIR.from_payload(deleted_cx))

        swapped_qubits = copy.deepcopy(original.payload(include_digest=False))
        swapped_qubits["instructions"][1] = {"op": "cx", "control": 1, "target": 0}
        mutations.append(CircuitIR.from_payload(swapped_qubits))

        for mutation in mutations:
            report = run_policy(
                mutation,
                policy,
                target=target,
                system_qubits=(0, 1),
                clean_qubits=(),
            )
            self.assertEqual(report["status"], "failed")
            self.assertGreater(
                float(report["reports"]["qiskitOperator"]["cleanBlockOperatorNormError"]),
                1e-6,
            )

    def test_schema_v1_packet_migrates_without_credentials(self) -> None:
        migrated = migrate_task_packet(
            {"schemaVersion": 1, "taskName": "sample", "exports": {"qiskit": True, "qasm3": False}}
        )
        self.assertEqual(migrated["schemaVersion"], 2)
        self.assertEqual(
            migrated["executablePolicy"]["intermediateCheck"]["backend"],
            "qiskitOperator",
        )
        self.assertIn("qiskitPython", migrated["executablePolicy"]["exports"]["formats"])
        validate_executable_policy(migrated["executablePolicy"])

    def test_canonicalization_is_stable(self) -> None:
        ir = bell_ir()
        restored = CircuitIR.from_payload(ir.payload())
        self.assertEqual(canonicalize_ir(restored), canonicalize_ir(ir))
        self.assertEqual(restored.circuit_digest, ir.circuit_digest)

    def test_check_backend_and_exports_are_independent(self) -> None:
        ir = bell_ir()
        policy = default_executable_policy()
        policy["intermediateCheck"]["backend"] = "qiskitOperator"
        policy["exports"]["formats"] = ["openqasm3", "metricsJson"]
        report = run_policy(ir, policy)
        self.assertEqual(report["status"], "passed")
        with tempfile.TemporaryDirectory() as directory:
            written = write_artifacts(Path(directory), ir, policy, report)
        self.assertEqual(written, ["openqasm3/circuit.qasm", "reports/check.json"])

    def test_export_only_mode_runs_no_optional_backend(self) -> None:
        ir = bell_ir()
        policy = default_executable_policy()
        policy["intermediateCheck"]["backend"] = "none"
        policy["intermediateCheck"]["required"] = False
        policy["exports"]["formats"] = ["qiskitPython", "openqasm3"]
        with mock.patch(
            "tools.executable_runner.qiskit_backend.verify"
        ) as qiskit_verify, mock.patch(
            "tools.executable_runner.openqasm3_backend.verify"
        ) as qasm_verify:
            report = run_policy(ir, policy)
        qiskit_verify.assert_not_called()
        qasm_verify.assert_not_called()
        self.assertEqual(report["status"], "passed")
        with tempfile.TemporaryDirectory() as directory:
            written = write_artifacts(Path(directory), ir, policy, report)
        self.assertEqual(written, ["qiskit/circuit.py", "openqasm3/circuit.qasm"])

    def test_required_unavailable_backend_blocks_but_optional_records_unavailable(self) -> None:
        ir = bell_ir()
        policy = default_executable_policy()
        policy["intermediateCheck"]["backend"] = "qiskitOperator"
        with mock.patch(
            "tools.executable_runner.qiskit_backend.verify",
            side_effect=RuntimeError("qiskit unavailable"),
        ):
            required = run_policy(ir, policy)
            self.assertEqual(required["status"], "blocked")
            policy["intermediateCheck"]["required"] = False
            optional = run_policy(ir, policy)
            self.assertEqual(optional["status"], "unavailable")
            self.assertEqual(
                optional["reports"]["qiskitOperator"]["status"], "unavailable"
            )

    def test_t3_sources_contain_no_opaque_or_dense_shortcuts(self) -> None:
        root = Path(__file__).resolve().parents[1]
        sources = "\n".join(
            path.read_text(encoding="utf-8")
            for path in (
                root / "QuantumBlockEncoding/PrimitiveCircuit.lean",
                root / "QuantumBlockEncoding/PrimitiveSemantics.lean",
                root / "QuantumBlockEncoding/PrimitiveRefinement.lean",
                root / "QuantumBlockEncoding/Robin/SymmetryFourSlotPrimitive.lean",
                root / "tools/backends/qiskit_backend.py",
            )
        )
        for forbidden in (
            "Gate.oracleCall", "QuantumCircuit.unitary(", "sorry", "axiom ",
            "upToGlobalPhase", '"op": "opaque"',
        ):
            self.assertNotIn(forbidden, sources)


if __name__ == "__main__":
    unittest.main()
