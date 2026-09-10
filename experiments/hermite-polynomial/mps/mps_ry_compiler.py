"""Small-register real-isometry compiler, using only explicit RY/CX.

QR elimination follows adjacent Gray-ordered rows, so every plane rotation
already differs on one bit.  A sparse uniformly controlled RY is expanded by
the cyclic Gray/Walsh identity.  Neither arbitrary unitaries nor control gates
are counted as free.  Finite precision remains diagnostic, not certified.
"""
from __future__ import annotations
from dataclasses import dataclass
import math
from typing import Iterator
import numpy as np
from mps_core_probe import TT, right_canonicalize


def prune_zero_paths(tt: TT) -> TT:
    """Remove unreachable/co-unreachable bonds using exact stored zero tests.

    No SVD, tolerance, singular-value cutoff, or nonzero entry is discarded.
    """
    cores, previous = [], np.array([0])
    for original in tt.cores:
        core = original[previous, :, :]
        following = np.flatnonzero(np.any(core != 0, axis=(0, 1)))
        if not len(following):
            raise ValueError("zero tensor has no normalized state")
        cores.append(core[:, :, following])
        previous = following
    following = np.array([0])
    for offset in range(len(cores)-1, -1, -1):
        core = cores[offset][:, :, following]
        previous = np.flatnonzero(np.any(core != 0, axis=(1, 2)))
        cores[offset] = core[previous, :, :]
        following = previous
    return TT(cores)


def complete_isometry(core: np.ndarray, bond_size: int) -> np.ndarray:
    left, _, right = core.shape
    if max(left, right) > bond_size:
        raise ValueError("bond padding too small")
    columns = np.zeros((2*bond_size, left))
    for bit in range(2):
        columns[bit*bond_size:bit*bond_size+right, :] = core[:, bit, :].T
    if np.linalg.norm(columns.T @ columns-np.eye(left), ord=2) > 1e-10:
        raise ValueError("input is not an isometry")
    q, _ = np.linalg.qr(columns, mode="complete")
    # Retain the prescribed columns exactly. QR supplies only their complement.
    q[:, :left] = columns
    if np.linalg.det(q) < 0:
        q[:, -1] *= -1  # This column is outside the prescribed input subspace.
    if np.linalg.norm(q.T @ q-np.eye(2*bond_size), ord=2) > 1e-9:
        raise ValueError("orthogonal completion failed")
    return q


def adjacent_gray_elimination(unitary: np.ndarray) -> tuple[list[tuple[int, int, float]], float]:
    """Return plane rotations in CIRCUIT order, not algebraic product order."""
    size = unitary.shape[0]
    if unitary.shape != (size, size) or size & (size-1):
        raise ValueError("power-of-two square matrix required")
    if np.linalg.norm(unitary.T @ unitary-np.eye(size), ord=2) > 1e-9:
        raise ValueError("orthogonal matrix required")
    if np.linalg.det(unitary) < 0:
        raise ValueError("det-negative completion cannot use only RY/CX here")
    gray = [j ^ (j >> 1) for j in range(size)]
    work = unitary[np.ix_(gray, gray)].copy()
    inverses = []
    for column in range(size-1):
        for row in range(size-1, column, -1):
            x, y = work[row-1, column], work[row, column]
            if y == 0 and x >= 0:
                continue
            radius = math.hypot(x, y)
            if radius == 0:
                continue
            cosine, sine = x/radius, y/radius
            first, second = work[row-1, :].copy(), work[row, :].copy()
            work[row-1, :] = cosine*first+sine*second
            work[row, :] = -sine*first+cosine*second
            inverses.append((gray[row-1], gray[row], math.atan2(y, x)))
    residual = float(np.linalg.norm(work-np.eye(size), ord=2))
    if residual > 1e-8:
        raise ArithmeticError("Givens elimination failed to reach identity")
    return list(reversed(inverses)), residual


def expand_edge_rotation(local_qubits: int, first: int, second: int,
                         half_angle: float) -> Iterator[tuple]:
    """Exact real-arithmetic RY/CX identity for a two-level rotation."""
    difference = first ^ second
    if difference == 0 or difference & (difference-1):
        raise ValueError("plane basis states must differ on exactly one bit")
    target = difference.bit_length()-1
    controls = [q for q in range(local_qubits) if q != target]
    pattern = sum(((first >> q) & 1) << i for i, q in enumerate(controls))
    angle = 2*half_angle*(-1 if (first >> target) & 1 else 1)
    count = 1 << len(controls)
    for j in range(count):
        gray = j ^ (j >> 1)
        sign = -1 if (pattern & gray).bit_count() & 1 else 1
        yield ("ry", sign*angle/count, target)
        if controls:
            next_j = (j+1) % count
            next_gray = next_j ^ (next_j >> 1)
            changed = (gray ^ next_gray).bit_length()-1
            yield ("cx", controls[changed], target)


@dataclass
class MPSPlan:
    n: int
    ancillas: int
    planes: list[list[tuple[int, int, float]]]
    max_completion_error: float
    norm: float
    active_bonds: list[int]

    @property
    def plane_count(self):
        return sum(len(p) for p in self.planes)

    @property
    def resource_counts(self):
        per_plane = 1 << self.ancillas
        return {"ry": self.plane_count*per_plane,
                "cx": self.plane_count*per_plane if self.ancillas else 0,
                "ancillas": self.ancillas, "data_qubits": self.n,
                "oracle_calls": 0, "postselection": False}

    def gates(self):
        for offset, planes in enumerate(self.planes):
            # Local data qubit is highest; bond ancillas are low local bits.
            wires = list(range(self.n, self.n+self.ancillas))+[self.n-1-offset]
            for first, second, angle in planes:
                for gate in expand_edge_rotation(self.ancillas+1, first, second, angle):
                    if gate[0] == "ry":
                        yield ("ry", gate[1], wires[gate[2]])
                    else:
                        yield ("cx", wires[gate[1]], wires[gate[2]])

    def qiskit_circuit(self):
        from qiskit import QuantumCircuit
        circuit = QuantumCircuit(self.n+self.ancillas)
        for gate in self.gates():
            if gate[0] == "ry":
                circuit.ry(gate[1], gate[2])
            else:
                circuit.cx(gate[1], gate[2])
        return circuit

    def write_qasm2(self, path):
        """Stream only primitive gates: memory never scales with 2^n."""
        with path.open("w", encoding="utf-8", newline="\n") as stream:
            stream.write('OPENQASM 2.0;\ninclude "qelib1.inc";\n')
            stream.write(f"qreg q[{self.n+self.ancillas}];\n")
            for gate in self.gates():
                if gate[0] == "ry":
                    stream.write(f"ry({gate[1]:.17g}) q[{gate[2]}];\n")
                else:
                    stream.write(f"cx q[{gate[1]}],q[{gate[2]}];\n")


def compile_mps(raw: TT) -> MPSPlan:
    canonical, norm = right_canonicalize(prune_zero_paths(raw))
    ancillas = (canonical.max_bond-1).bit_length()
    bond_size = 1 << ancillas
    planes, residual = [], 0.
    for core in canonical.cores:
        unitary = complete_isometry(core, bond_size)
        rotations, error = adjacent_gray_elimination(unitary)
        planes.append(rotations)
        residual = max(residual, error)
    active_bonds = [canonical.cores[0].shape[0]]+[core.shape[2] for core in canonical.cores]
    return MPSPlan(raw.n, ancillas, planes, residual, norm, active_bonds)
