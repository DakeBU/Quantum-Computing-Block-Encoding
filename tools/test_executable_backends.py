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
from tools.executable_ir import (
    CircuitIR, angle_scale, canonicalize_ir, evaluate_ir, pi_rational, rational,
    twice_arccos_sqrt_rational,
)
from tools.executable_manifest import (
    default_executable_policy, migrate_task_packet, validate_executable_policy,
)
from tools.executable_runner import run_policy, write_artifacts
from tools.export_robin_evolution import (
    M, _compile_reversible, _dagger, _figure4_dt_access, robin_figure4_ir,
    robin_paper_seven_ir, robin_xor_four_slot_ir,
)


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

    def test_exact_angle_extensions_and_nonzero_phase_round_trip(self) -> None:
        from tools.backends import openqasm3_backend

        payload = bell_ir().payload(include_digest=False)
        payload["instructions"][0]["angle"] = angle_scale(
            1, 2, twice_arccos_sqrt_rational(1, 4)
        )
        payload["globalPhase"] = pi_rational(1, 7)
        ir = CircuitIR.from_payload(payload)
        text, report = openqasm3_backend.verify(ir)
        self.assertIn("ASPBE_EXACT_GLOBAL_PHASE", text)
        self.assertIn("gphase(", text)
        self.assertTrue(report["canonicalRoundTrip"])
        qiskit_report = qiskit_backend.verify(ir)
        self.assertLess(float(qiskit_report["fullOperatorError"]), 1e-12)

    def test_robin_six_wire_register_order_all_64_basis_states(self) -> None:
        for flat in range(64):
            bits = tuple((flat >> wire) & 1 for wire in range(6))
            system = bits[0] + 2 * bits[1] + 4 * bits[2]
            selector = bits[3] + 2 * bits[4]
            coefficient = bits[5]
            self.assertEqual(flat, system + 8 * selector + 32 * coefficient)

    def test_robin_xor_t3_all_backends_and_mutations(self) -> None:
        ir = robin_xor_four_slot_ir("test")
        target = np.asarray(M, dtype=float) / 224.0
        policy = default_executable_policy()
        policy["intermediateCheck"]["backend"] = "both"
        report = run_policy(
            ir, policy, target=target,
            system_qubits=(0, 1, 2), clean_qubits=(3, 4, 5),
        )
        self.assertEqual(report["status"], "passed")
        self.assertLess(
            float(report["reports"]["qiskitOperator"]["fullOperatorError"]),
            1e-12,
        )
        self.assertTrue(
            report["reports"]["openqasm3RoundTrip"]["canonicalRoundTrip"]
        )

        reference = evaluate_ir(ir)
        mutations = []
        changed_angle = copy.deepcopy(ir.payload(include_digest=False))
        first_ry = next(
            index for index, gate in enumerate(changed_angle["instructions"])
            if gate["op"] == "ry"
        )
        changed_angle["instructions"][first_ry]["angle"] = pi_rational(-1, 3)
        mutations.append(CircuitIR.from_payload(changed_angle))

        deleted_cx = copy.deepcopy(ir.payload(include_digest=False))
        first_cx = next(
            index for index, gate in enumerate(deleted_cx["instructions"])
            if gate["op"] == "cx"
        )
        del deleted_cx["instructions"][first_cx]
        mutations.append(CircuitIR.from_payload(deleted_cx))

        changed_qubit_order = copy.deepcopy(ir.payload(include_digest=False))
        changed_qubit_order["instructions"][0] = {
            "op": "cx", "control": 2, "target": 0,
        }
        mutations.append(CircuitIR.from_payload(changed_qubit_order))
        for mutation in mutations:
            self.assertGreater(
                np.linalg.norm(evaluate_ir(mutation) - reference, ord=2), 1e-6
            )

        changed_endianness = copy.deepcopy(ir.payload(include_digest=False))
        changed_endianness["endianness"] = "big-endian"
        with self.assertRaisesRegex(ValueError, "endianness"):
            CircuitIR.from_payload(changed_endianness)

    def test_robin_source_t3_resources_match_lean_circuit_lists(self) -> None:
        from collections import Counter
        from tools.executable_ir import primitive_resource

        expected = (
            (robin_xor_four_slot_ir("test"), 106, 96, {"ry": 38, "cx": 68}),
            (
                robin_paper_seven_ir("test"), 312, 266,
                {"x": 4, "ry": 88, "rz": 45, "cx": 175},
            ),
            (
                robin_figure4_ir("test"), 881, 674,
                {"x": 16, "ry": 204, "rz": 207, "cx": 454},
            ),
        )
        for ir, gates, depth, counts in expected:
            self.assertEqual(
                primitive_resource(ir.instructions),
                {"gateCount": gates, "depth": depth, "oracleCalls": 0},
            )
            self.assertEqual(Counter(gate["op"] for gate in ir.instructions), counts)

    def test_robin_paper_and_figure4_all_backends(self) -> None:
        target = np.asarray(M, dtype=float) / 224.0
        policy = default_executable_policy()
        policy["intermediateCheck"]["backend"] = "both"
        cases = (
            (robin_paper_seven_ir("test"), (0, 1, 2), (3, 4, 5, 6, 7)),
            (robin_figure4_ir("test"), (3, 4, 5), (0, 1, 2, 6, 7, 8)),
        )
        for ir, system, clean in cases:
            report = run_policy(
                ir, policy, target=target,
                system_qubits=system, clean_qubits=clean,
            )
            self.assertEqual(report["status"], "passed")
            self.assertTrue(
                report["reports"]["openqasm3RoundTrip"]["canonicalRoundTrip"]
            )
            self.assertLess(
                float(report["reports"]["qiskitOperator"]["fullOperatorError"]),
                1e-12,
            )

    def test_figure4_source_mutations_fail_the_executable_gate(self) -> None:
        original = robin_figure4_ir("test")
        target = np.asarray(M, dtype=float) / 224.0
        policy = default_executable_policy()
        policy["intermediateCheck"]["backend"] = "none"
        policy["intermediateCheck"]["required"] = False

        def rebuild(instructions, *, phase=None):
            payload = copy.deepcopy(original.payload(include_digest=False))
            payload["instructions"] = instructions
            if phase is not None:
                payload["globalPhase"] = phase
            return CircuitIR.from_payload(payload)

        original_instructions = list(original.instructions)
        mutations = []

        changed_loader = copy.deepcopy(original_instructions)
        loader = next(
            index for index in range(15 + 108, len(changed_loader))
            if changed_loader[index]["op"] == "ry"
        )
        changed_loader[loader]["angle"] = pi_rational(1, 3)
        mutations.append(("loader-angle", rebuild(changed_loader)))

        deleted_cx = copy.deepcopy(original_instructions)
        del deleted_cx[next(
            index for index, gate in enumerate(deleted_cx) if gate["op"] == "cx"
        )]
        mutations.append(("deleted-cx", rebuild(deleted_cx)))

        # The first two gates of the D-transpose access encode XOR-with-three.
        dt_start = 15 + 108 + 46 + 382
        changed_offset = copy.deepcopy(original_instructions)
        changed_offset[dt_start] = {"op": "x", "target": 2}
        mutations.append(("dt-offset", rebuild(changed_offset)))

        # Reintroduce the historical row window (2..5) in both compute and
        # uncompute positions; it is wrong for the D-transpose column test.
        indicator_start = 15
        indicator_end = indicator_start + 108
        indicator_cleanup_start = dt_start + 90
        indicator_cleanup_end = indicator_cleanup_start + 108
        old_indicator = [
            {"op": "cx", "control": 4, "target": 7},
            {"op": "cx", "control": 5, "target": 7},
        ]
        old_window = (
            original_instructions[:indicator_start] + old_indicator
            + original_instructions[indicator_end:indicator_cleanup_start]
            + _dagger(old_indicator)
            + original_instructions[indicator_cleanup_end:]
        )
        mutations.append(("old-row-indicator", rebuild(old_window)))

        # After the register swap, cleanup must be D inverse, not D^T inverse.
        cleanup_start = indicator_cleanup_end + 9
        cleanup_end = cleanup_start + 108
        dt_instructions, _ = _compile_reversible(_figure4_dt_access())
        wrong_cleanup = (
            original_instructions[:cleanup_start] + _dagger(dt_instructions)
            + original_instructions[cleanup_end:]
        )
        wrong_cleanup_ir = rebuild(wrong_cleanup, phase=pi_rational(0))

        for name, mutation in mutations:
            with self.subTest(mutation=name):
                report = run_policy(
                    mutation, policy, target=target,
                    system_qubits=(3, 4, 5), clean_qubits=(0, 1, 2, 6, 7, 8),
                )
                self.assertEqual(report["status"], "failed")
                self.assertGreater(
                    float(report["reports"]["internalCanonicalEvaluator"]
                          ["cleanBlockOperatorNormError"]),
                    1e-6,
                )

        # This mutation preserves the clean projection but changes the chosen
        # full-space reversible extension on dirty work states.  It is rejected
        # against the frozen full operator rather than misreported as a block
        # error.
        self.assertGreater(
            np.linalg.norm(
                evaluate_ir(wrong_cleanup_ir) - evaluate_ir(original), ord=2
            ),
            1e-6,
        )
        self.assertNotEqual(
            canonicalize_ir(wrong_cleanup_ir), canonicalize_ir(original)
        )

        changed_endianness = copy.deepcopy(original.payload(include_digest=False))
        changed_endianness["endianness"] = "big-endian"
        with self.assertRaisesRegex(ValueError, "endianness"):
            CircuitIR.from_payload(changed_endianness)

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
