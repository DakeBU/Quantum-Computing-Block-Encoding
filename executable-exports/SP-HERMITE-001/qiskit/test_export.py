"""Deterministic regressions, including independent full-matrix UCRY checks."""
import builtins
from fractions import Fraction
import hashlib
import json
import math
from pathlib import Path
import re
import tempfile
import unittest
from unittest.mock import patch

import numpy as np
import export as hermite
import replay as independent_replay


class HermiteTests(unittest.TestCase):
    def test_exact_endpoint_jets(self):
        for k in range(13):
            with self.subTest(k=k):
                evidence = hermite.endpoint_check(k)
                self.assertTrue(evidence["passed"])
                self.assertTrue(all(Fraction(c) > 0 for c in evidence["positive_coefficients"]))

    def test_independent_interpolation_and_cubic_not_c2(self):
        for k in range(7):
            points, expected = independent_replay.target_samples(k, 5, 1.0)
            np.testing.assert_allclose(hermite.hermite_values(points, k), expected, atol=2e-14)
        u, v = independent_replay.interpolate(1)
        u_second_at_one = sum(i*(i-1)*c for i, c in enumerate(u))
        v_second_at_one = sum(i*(i-1)*c for i, c in enumerate(v))
        self.assertEqual((u_second_at_one, v_second_at_one), (8, -10))
        self.assertNotAlmostEqual(8/math.e-10, 1)

    def test_k_zero_linear_interpolant(self):
        points = np.linspace(-1, 0, 11)
        expected = math.exp(-1)*(-points) + (points+1)
        np.testing.assert_allclose(hermite.hermite_values(points, 0), expected, atol=1e-15)

    def test_piecewise_endpoints_and_tails(self):
        points = np.array([-3, -1, 0, 2.0])
        for k in (0, 1, 3, 8):
            np.testing.assert_allclose(hermite.hermite_values(points, k),
                                       np.exp(-np.abs(points)), atol=1e-15)

    def test_ry_sign_and_little_endian(self):
        result = hermite.simulate([hermite.Gate("ry", 0, math.pi)], 2)
        np.testing.assert_allclose(result, [0, 1, 0, 0], atol=1e-15)
        result = hermite.simulate([hermite.Gate("ry", 1, math.pi)], 2)
        np.testing.assert_allclose(result, [0, 0, 1, 0], atol=1e-15)
        result = hermite.simulate([hermite.Gate("ry", 0, math.pi), hermite.Gate("ry", 0, math.pi)], 1)
        np.testing.assert_allclose(result, [-1, 0], atol=1e-15)

    def test_ucry_full_basis_action(self):
        """Independent block specification checks every column, including |1>."""
        rng = np.random.default_rng(20260909)
        for controls in ((), (0,), (0, 2), (2, 0, 3)):
            target = 1
            n = max((target,)+controls)+1
            angles = rng.uniform(-4*math.pi, 4*math.pi, 2**len(controls))
            gates = hermite.compile_ucry(controls, target, angles)
            self.assertEqual(sum(g.name == "ry" for g in gates), 2**len(controls))
            self.assertEqual(sum(g.name == "cx" for g in gates), 2*(2**len(controls)-1))
            for column in range(2**n):
                initial = np.eye(2**n)[column]
                assignment = sum(((column >> q)&1) << i for i, q in enumerate(controls))
                c, s = math.cos(angles[assignment]/2), math.sin(angles[assignment]/2)
                expected = np.zeros(2**n)
                expected[column] = c
                expected[column ^ (1 << target)] = -s if column & (1 << target) else s
                np.testing.assert_allclose(hermite.simulate(gates, n, initial), expected, atol=3e-15)

    def test_all_basis_targets_and_zero_mass_subtrees(self):
        for n in range(1, 5):
            for j in range(2**n):
                target = np.eye(2**n)[j]
                gates, rows = hermite.prepare(target)
                np.testing.assert_allclose(hermite.simulate(gates, n), target, atol=3e-15)
                self.assertTrue(all(r["angle"] == 0 for r in rows if r["zero_parent"]))

    def test_random_targets_resource_counts_and_scale_invariance(self):
        rng = np.random.default_rng(157)
        for n in range(1, 7):
            amplitudes = rng.uniform(0, 1, 2**n)
            amplitudes[::3] = 0
            gates, _ = hermite.prepare(amplitudes)
            scaled, _ = hermite.prepare(amplitudes*1e150)
            target = amplitudes/np.linalg.norm(amplitudes)
            np.testing.assert_allclose(hermite.simulate(gates, n), target, atol=2e-14)
            np.testing.assert_allclose(hermite.simulate(scaled, n), target, atol=2e-14)
            self.assertEqual(sum(g.name == "ry" for g in gates), 2**n-1)
            self.assertEqual(sum(g.name == "cx" for g in gates), 2*(2**n-1-n))

    def test_invalid_inputs_are_rejected(self):
        for a in ([], [0, 0], [-1, 2], [1, 2, 3], [1, float("nan")]):
            with self.assertRaises(ValueError):
                hermite.prepare(np.asarray(a))
        for controls, target, angles in (((0,), 0, [0, 1]), ((1, 1), 0, [0]*4), ((0,), 1, [0])):
            with self.assertRaises(ValueError):
                hermite.compile_ucry(controls, target, np.asarray(angles))

    def test_qiskit_and_qasm_round_trips(self):
        for n in range(1, 5):
            for k in (0, 1, 3):
                points = -math.pi + 2*math.pi*np.arange(2**n)/2**n
                samples = hermite.hermite_values(points, k)
                gates, _ = hermite.prepare(samples)
                evidence, circuit = hermite.qiskit_replay(gates, n, samples/np.linalg.norm(samples))
                self.assertTrue(evidence["passed"])
                self.assertLess(max(evidence["max_amplitude_errors"].values()), 1e-12)
                self.assertTrue(set(circuit.count_ops()) <= {"ry", "cx"})

    def test_missing_qiskit_fails_and_invalidates_stale_acceptance(self):
        real_import = builtins.__import__

        def without_qiskit(name, *args, **kwargs):
            if name == "qiskit" or name.startswith("qiskit."):
                raise ImportError("test injected missing dependency")
            return real_import(name, *args, **kwargs)

        with tempfile.TemporaryDirectory() as folder:
            output = Path(folder)
            (output/"acceptance.json").write_text('{"accepted": true}')
            with patch("builtins.__import__", side_effect=without_qiskit):
                with self.assertRaises(RuntimeError):
                    hermite.export_case(1, 2, 1.0, output)
            self.assertFalse(json.loads((output/"acceptance.json").read_text())["accepted"])

    def test_numpy_mode_is_not_acceptance(self):
        with tempfile.TemporaryDirectory() as folder:
            payload = hermite.export_case(3, 3, 1.0, Path(folder), numpy_only=True)
            self.assertFalse(payload["accepted"])
            self.assertFalse(payload["qiskit"]["passed"])
            for name, expected in payload["artifact_sha256"].items():
                self.assertEqual(hashlib.sha256((Path(folder)/name).read_bytes()).hexdigest(), expected)
            self.assertNotIn(folder, json.dumps(payload))

    def test_lf_artifacts_keep_cross_platform_hashes_stable(self):
        with tempfile.TemporaryDirectory() as folder:
            output = Path(folder)
            evidence = hermite.export_case(1, 3, 1.0, output)
            for name in ["acceptance.json", *evidence["artifact_sha256"]]:
                data = (output/name).read_bytes()
                self.assertNotIn(b"\r", data, name)
                self.assertTrue(data.endswith(b"\n"), name)

    def test_independent_saved_replay_and_missing_artifact(self):
        with tempfile.TemporaryDirectory() as folder:
            output = Path(folder)
            hermite.export_case(1, 3, 1.0, output)
            self.assertTrue(independent_replay.verify(output)["passed"])
            saved = (output/"circuit.qasm").read_text()
            (output/"circuit.qasm").unlink()
            with self.assertRaisesRegex(ValueError, "required artifact is missing"):
                independent_replay.verify(output)
            (output/"circuit.qasm").write_text(saved+"// altered\n")
            with self.assertRaisesRegex(ValueError, "artifact hash mismatch"):
                independent_replay.verify(output)

    def test_forged_success_and_updated_digest_do_not_bypass_replay(self):
        with tempfile.TemporaryDirectory() as folder:
            output = Path(folder)
            hermite.export_case(1, 3, 1.0, output)
            circuit = output/"circuit.qasm"
            circuit.write_text(re.sub(r"ry\([^)]*\)", "ry(0.123)", circuit.read_text(), count=1))
            evidence = json.loads((output/"acceptance.json").read_text())
            evidence["accepted"] = True
            evidence["artifact_sha256"]["circuit.qasm"] = hashlib.sha256(circuit.read_bytes()).hexdigest()
            (output/"acceptance.json").write_text(json.dumps(evidence))
            with self.assertRaisesRegex(ValueError, "independent QASM replay failed"):
                independent_replay.verify(output)


if __name__ == "__main__":
    unittest.main()
