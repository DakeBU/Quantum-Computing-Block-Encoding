from fractions import Fraction
import math
import unittest
import numpy as np
from qiskit import QuantumCircuit
from qiskit.quantum_info import Operator, Statevector
from mps_core_probe import hermite_tt, source_value
from mps_ry_compiler import adjacent_gray_elimination, compile_mps, expand_edge_rotation, prune_zero_paths
from mps_stable_cores import stable_hermite_tt


def plane_matrix(qubits, first, second, angle):
    matrix = np.eye(1 << qubits)
    matrix[first, first] = matrix[second, second] = math.cos(angle)
    matrix[first, second] = -math.sin(angle)
    matrix[second, first] = math.sin(angle)
    return matrix


def gates_circuit(qubits, gates):
    circuit = QuantumCircuit(qubits)
    for gate in gates:
        if gate[0] == "ry":
            circuit.ry(gate[1], gate[2])
        else:
            circuit.cx(gate[1], gate[2])
    return circuit


class PrimitiveCompilerTests(unittest.TestCase):
    def test_stored_zero_pruning_preserves_all_small_amplitudes(self):
        for n, k, length in ((8, 8, "10"), (8, 8, "300"), (5, 2, "1")):
            raw, _ = stable_hermite_tt(n, k, Fraction(length))
            pruned = prune_zero_paths(raw)
            np.testing.assert_allclose(pruned.small_dense_diagnostic(), raw.small_dense_diagnostic(),
                                       atol=1e-15, rtol=1e-15)
            self.assertLessEqual(pruned.scalar_count, raw.scalar_count)

    def test_each_edge_and_orientation_small_register(self):
        for qubits in (1, 2, 3):
            for first in range(1 << qubits):
                for bit in range(qubits):
                    second = first ^ (1 << bit)
                    actual = Operator(gates_circuit(qubits, expand_edge_rotation(qubits, first, second, 0.37))).data
                    np.testing.assert_allclose(actual, plane_matrix(qubits, first, second, 0.37), atol=1e-14)

    def test_arbitrary_special_orthogonal_small_register(self):
        generator = np.random.default_rng(470021)
        for qubits in (1, 2, 3):
            matrix, _ = np.linalg.qr(generator.normal(size=(1 << qubits, 1 << qubits)))
            if np.linalg.det(matrix) < 0:
                matrix[:, -1] *= -1
            rotations, error = adjacent_gray_elimination(matrix)
            gates = (g for a, b, t in rotations for g in expand_edge_rotation(qubits, a, b, t))
            np.testing.assert_allclose(Operator(gates_circuit(qubits, gates)).data, matrix, atol=2e-13)
            self.assertLess(error, 1e-12)

    def test_reject_det_negative(self):
        matrix = np.eye(8)
        matrix[0, 0] = -1
        with self.assertRaises(ValueError):
            adjacent_gray_elimination(matrix)

    def test_actual_primitive_state_and_clean_ancillas(self):
        for n, k in ((1, 0), (3, 1), (4, 2)):
            raw, _ = hermite_tt(n, k, Fraction(1))
            plan = compile_mps(raw)
            self.assertEqual(plan.active_bonds[0], 1)
            self.assertEqual(plan.active_bonds[-1], 1)
            self.assertLessEqual(plan.active_bonds[-2], 2)
            circuit = plan.qiskit_circuit()
            actual = Statevector.from_instruction(circuit).data
            expected = np.array([source_value(k, -math.pi+2*math.pi*j/(1 << n)) for j in range(1 << n)])
            expected /= np.linalg.norm(expected)
            self.assertLess(np.linalg.norm(actual[:1 << n]-expected), 2e-10)
            self.assertLess(np.linalg.norm(actual[1 << n:]), 2e-10)
            self.assertLess(np.max(np.abs(actual.imag)), 1e-14)
            self.assertLessEqual(set(circuit.count_ops()), {"ry", "cx"})
            self.assertEqual(circuit.count_ops().get("ry", 0), plan.resource_counts["ry"])
            self.assertEqual(circuit.count_ops().get("cx", 0), plan.resource_counts["cx"])


if __name__ == "__main__":
    unittest.main()
