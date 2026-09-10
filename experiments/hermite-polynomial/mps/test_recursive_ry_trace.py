from fractions import Fraction
import json
import math
from pathlib import Path
import tempfile
import unittest

import numpy as np
from qiskit import QuantumCircuit
from qiskit.quantum_info import Operator, Statevector

from mps_ry_compiler import compile_mps
from mps_stable_cores import stable_hermite_tt
from recursive_ry_trace import (selected_trace, trace_json, expand_edge_rotation_recursive,
                                recursive_plan_gates, recursive_resource_counts,
                                write_recursive_qasm)
from check_selected_ry_traces import check


def circuit_from_gates(qubits, gates):
    result = QuantumCircuit(qubits)
    for gate in gates:
        if gate[0] == "ry":
            result.ry(gate[1], gate[2])
        else:
            result.cx(gate[1], gate[2])
    return result


class RecursiveTraceTests(unittest.TestCase):
    def test_trace_checker_rejects_missing_empty_and_corrupt_artifacts(self):
        cases = []
        for controls in range(5):
            qubits = controls + 1
            for target in range(qubits):
                wires = [q for q in range(qubits) if q != target]
                for pattern in range(1 << controls):
                    cases.append({"qubits": qubits, "target": target, "controls": wires,
                                  "pattern": pattern,
                                  "gates": trace_json(selected_trace(qubits, wires, target, pattern))})
        artifact = {"schema": "aspbe-selected-ry-traces-v1",
                    "lean_root": "QuantumBlockEncoding.SelectedRyTrace.selected_refines",
                    "cases": cases}
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "traces.json"
            with self.assertRaises(FileNotFoundError):
                check(path)
            path.write_text(json.dumps(artifact), encoding="utf-8")
            self.assertEqual(check(path)["cases"], 129)
            for mutated in ([], cases[:-1], cases + [cases[0]]):
                path.write_text(json.dumps({**artifact, "cases": mutated}), encoding="utf-8")
                with self.assertRaises(ValueError):
                    check(path)
            cases[0]["gates"][0]["numerator"] = True
            path.write_text(json.dumps(artifact), encoding="utf-8")
            with self.assertRaises(ValueError):
                check(path)
            cases[0]["gates"][0]["numerator"] = 2
            path.write_text(json.dumps(artifact), encoding="utf-8")
            with self.assertRaises(ValueError):
                check(path)

    def test_exact_signed_one_control_trace(self):
        self.assertEqual(list(selected_trace(2, [0], 1, 1)),
                         [("ry", Fraction(1, 2), 1), ("cx", 0, 1),
                          ("ry", Fraction(-1, 2), 1), ("cx", 0, 1)])
        self.assertEqual(list(selected_trace(1, [], 0, 0)), [("ry", Fraction(1), 0)])

    def test_local_counts_and_coefficient_mass(self):
        for controls in range(7):
            for pattern in (0, (1 << controls) - 1):
                gates = list(selected_trace(controls + 1, list(range(controls)), controls, pattern))
                ry = [g[1] for g in gates if g[0] == "ry"]
                self.assertEqual(len(ry), 1 << controls)
                self.assertEqual(len(gates) - len(ry), 2 * ((1 << controls) - 1))
                self.assertEqual(sum(map(abs, ry)), 1)
                self.assertTrue(all(abs(value) == Fraction(1, 1 << controls) for value in ry))

    def test_all_small_planes_and_orientations(self):
        for qubits in (1, 2, 3, 4):
            for first in range(1 << qubits):
                for bit in range(qubits):
                    second = first ^ (1 << bit)
                    for angle in (0.0, 0.37, -0.29):
                        target = np.eye(1 << qubits)
                        target[first, first] = target[second, second] = math.cos(angle)
                        target[first, second] = -math.sin(angle)
                        target[second, first] = math.sin(angle)
                        actual = Operator(circuit_from_gates(qubits,
                            expand_edge_rotation_recursive(qubits, first, second, angle))).data
                        np.testing.assert_allclose(actual, target, atol=2e-14, rtol=0)

    def test_physical_control_order_is_explicit(self):
        # Reordering the controls and the corresponding pattern changes the
        # trace, but not the selected physical subspace.
        def instantiate(wires, pattern):
            return (("ry", float(g[1]) * 0.42, g[2]) if g[0] == "ry" else g
                    for g in selected_trace(4, wires, 1, pattern))
        a = Operator(circuit_from_gates(4, instantiate([0, 2, 3], 1))).data
        b = Operator(circuit_from_gates(4, instantiate([3, 2, 0], 4))).data
        np.testing.assert_allclose(a, b, atol=1e-14, rtol=0)

    def test_invalid_input_fails(self):
        for args in ((0, [], 0, 0), (2, [0, 0], 1, 0), (2, [1], 1, 0),
                     (2, [2], 1, 0), (2, [0], 1, 2), (2, [-1], 1, 0)):
            with self.assertRaises(ValueError):
                list(selected_trace(*args))
        for args in ((2, 0, 3, 0.1), (2, 0, 0, 0.1), (2, 0, 4, 0.1),
                     (2, 0, 1, math.nan), (2, 0, 1, math.inf)):
            with self.assertRaises(ValueError):
                list(expand_edge_rotation_recursive(*args))

    def test_small_hermite_state_cleanup_and_counts(self):
        for n, k, length in ((1, 0, "1"), (3, 1, "1"), (4, 2, "2")):
            raw, _ = stable_hermite_tt(n, k, Fraction(length))
            plan = compile_mps(raw)
            circuit = circuit_from_gates(n + plan.ancillas, recursive_plan_gates(plan))
            actual = Statevector.from_instruction(circuit).data
            # End-to-end independent-source replay is a separate saved-QASM gate.
            expected = raw.small_dense_diagnostic()
            expected /= np.linalg.norm(expected)
            self.assertLess(np.linalg.norm(actual[:1 << n] - expected), 1e-11)
            self.assertLess(np.linalg.norm(actual[1 << n:]), 1e-11)
            counts = recursive_resource_counts(plan)
            for op in ("ry", "cx"):
                self.assertEqual(circuit.count_ops().get(op, 0), counts[op])

    def test_export_is_exclusive_and_primitive_only(self):
        raw, _ = stable_hermite_tt(3, 1, Fraction(1))
        plan = compile_mps(raw)
        with tempfile.TemporaryDirectory() as tmp:
            output = Path(tmp) / "recursive.qasm"
            write_recursive_qasm(plan, output)
            loaded = QuantumCircuit.from_qasm_file(str(output))
            self.assertLessEqual(set(loaded.count_ops()), {"ry", "cx"})
            before = output.read_bytes()
            with self.assertRaises(FileExistsError):
                write_recursive_qasm(plan, output)
            self.assertEqual(output.read_bytes(), before)


if __name__ == "__main__":
    unittest.main()
