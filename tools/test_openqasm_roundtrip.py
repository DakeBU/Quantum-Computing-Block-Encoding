#!/usr/bin/env python3
"""Strict OpenQASM 3 serialization and semantic round-trip tests."""

from __future__ import annotations

import unittest

import numpy as np

from tools.backends import openqasm3_backend
from tools.executable_ir import canonicalize_ir, evaluate_ir
from tools.test_executable_backends import bell_ir


class OpenQasmRoundTripTests(unittest.TestCase):
    def test_exact_angle_metadata_round_trips(self) -> None:
        ir = bell_ir()
        text, report = openqasm3_backend.verify(ir)
        restored = openqasm3_backend.loads(text, ir)
        self.assertTrue(report["canonicalRoundTrip"])
        self.assertEqual(canonicalize_ir(restored), canonicalize_ir(ir))
        self.assertLess(float(report["fullOperatorError"]), 1e-12)
        self.assertIn("ASPBE_EXACT_ANGLE", text)

    def test_deleted_cx_fails_canonical_and_semantic_round_trip(self) -> None:
        ir = bell_ir()
        text = openqasm3_backend.dumps(ir)
        mutated = text.replace("cx q[0], q[1];\n", "")
        restored = openqasm3_backend.loads(mutated, ir)
        self.assertNotEqual(canonicalize_ir(restored), canonicalize_ir(ir))
        self.assertGreater(np.linalg.norm(evaluate_ir(restored) - evaluate_ir(ir), ord=2), 1e-6)

    def test_qubit_index_mutation_changes_semantics(self) -> None:
        ir = bell_ir()
        text = openqasm3_backend.dumps(ir)
        mutated = text.replace("cx q[0], q[1];", "cx q[1], q[0];")
        restored = openqasm3_backend.loads(mutated, ir)
        self.assertNotEqual(canonicalize_ir(restored), canonicalize_ir(ir))
        self.assertGreater(np.linalg.norm(evaluate_ir(restored) - evaluate_ir(ir), ord=2), 1e-6)

    def test_changed_angle_decimal_is_rejected(self) -> None:
        ir = bell_ir()
        text = openqasm3_backend.dumps(ir)
        mutated = text.replace("1.5707963267948966", "1.2")
        with self.assertRaisesRegex(ValueError, "does not match"):
            openqasm3_backend.loads(mutated, ir)

    def test_endianness_change_is_rejected(self) -> None:
        payload = bell_ir().payload(include_digest=False)
        payload["endianness"] = "big-endian"
        from tools.executable_ir import CircuitIR
        with self.assertRaisesRegex(ValueError, "endianness"):
            CircuitIR.from_payload(payload)

    def test_measurement_is_rejected(self) -> None:
        ir = bell_ir()
        text = openqasm3_backend.dumps(ir) + "bit[2] c;\nc = measure q;\n"
        with self.assertRaisesRegex(ValueError, "unsupported OpenQASM statement"):
            openqasm3_backend.loads(text, ir)


if __name__ == "__main__":
    unittest.main()

