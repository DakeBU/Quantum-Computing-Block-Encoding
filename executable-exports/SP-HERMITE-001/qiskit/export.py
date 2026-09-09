#!/usr/bin/env python3
"""Explicit Hermite sample preparation using only RY and CX gates.

Default acceptance requires Qiskit and OpenQASM round-trip replay. Numerical
exports are finite evidence; they do not themselves claim a Lean certificate.
"""
from __future__ import annotations

import argparse
import csv
from dataclasses import dataclass
from fractions import Fraction
import hashlib
import json
import math
from pathlib import Path
import sys
from xml.sax.saxutils import escape

import numpy as np


@dataclass(frozen=True)
class Gate:
    name: str
    target: int
    angle: float = 0.0
    control: int | None = None


def positive_coefficients(k: int) -> list[Fraction]:
    """A_k coefficients in increasing powers, using exact rational arithmetic."""
    if not isinstance(k, int) or k < 0:
        raise ValueError("k must be a nonnegative integer")
    return [sum((Fraction(math.comb(k + r - m, k), math.factorial(m))
                 for m in range(r + 1)), Fraction(0)) for r in range(k + 1)]


def _multiply(a: list[Fraction], b: list[Fraction]) -> list[Fraction]:
    out = [Fraction(0)] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            out[i + j] += x * y
    return out


def _reflect(a: list[Fraction]) -> list[Fraction]:
    out = [Fraction(0)] * len(a)
    for power, coefficient in enumerate(a):
        for r in range(power + 1):
            out[r] += coefficient * math.comb(power, r) * (-1) ** r
    return out


def endpoint_check(k: int) -> dict:
    """Check jets of both rational parts, without approximating exp(-1).

    P(t-1)=exp(-1)G(t)+G(1-t). Through order k, G^(r)(0)=1 and
    G^(r)(1)=0. Reflection gives the right endpoint jet (-1)^r.
    """
    a = positive_coefficients(k)
    g = _multiply([Fraction((-1) ** i * math.comb(k + 1, i))
                   for i in range(k + 2)], a)
    reflected = _reflect(g)

    def derivative_at(poly: list[Fraction], r: int, x: int) -> Fraction:
        return sum((c * Fraction(math.factorial(i), math.factorial(i - r))
                    * x ** (i - r) for i, c in enumerate(poly) if i >= r), Fraction(0))

    rows = []
    for r in range(k + 1):
        values = [derivative_at(g, r, 0), derivative_at(g, r, 1),
                  derivative_at(reflected, r, 0), derivative_at(reflected, r, 1)]
        if values != [Fraction(1), Fraction(0), Fraction(0), Fraction((-1) ** r)]:
            raise AssertionError(f"Hermite endpoint mismatch: k={k}, derivative={r}")
        rows.append(dict(order=r, G_at_0=str(values[0]), G_at_1=str(values[1]),
                         reflected_at_0=str(values[2]), reflected_at_1=str(values[3])))
    return dict(k=k, degree_bound=2*k+1, arithmetic="exact rational", passed=True,
                jets=rows, positive_coefficients=[str(x) for x in a])


def hermite_values(points: np.ndarray, k: int) -> np.ndarray:
    """Positive splice exp(p), P_k(p), exp(-p), with cuts at -1 and 0."""
    coefficients = [float(c) for c in positive_coefficients(k)]
    if any(not math.isfinite(c) for c in coefficients):
        raise ValueError("coefficient overflow; use a smaller k")

    def a(t: float) -> float:
        value = 0.0
        for c in reversed(coefficients):
            value = value * t + c
        return value

    values = []
    for p in points:
        if p <= -1:
            value = math.exp(float(p))
        elif p >= 0:
            value = math.exp(-float(p))
        else:
            t = float(p) + 1
            value = math.exp(-1)*(1-t)**(k+1)*a(t) + t**(k+1)*a(1-t)
        values.append(value)
    result = np.asarray(values)
    if not np.all(np.isfinite(result)) or np.any(result <= 0):
        raise ValueError("sample overflow or underflow: expected positive finite values")
    return result


def compile_ucry(controls: tuple[int, ...], target: int, angles: np.ndarray) -> list[Gate]:
    """Lowest supplied control first; chronological RY/CX reference compiler."""
    angles = np.asarray(angles, dtype=float)
    if len(set(controls)) != len(controls) or target in controls:
        raise ValueError("UCRY wires must be distinct")
    if min((target,) + controls) < 0:
        raise ValueError("wire indices must be nonnegative")
    if angles.shape != (2**len(controls),) or not np.all(np.isfinite(angles)):
        raise ValueError("expected one finite angle per control assignment")
    if not controls:
        return [Gate("ry", target, float(angles[0]))]
    head, *tail = controls
    half_add = (angles[0::2] + angles[1::2]) / 2
    half_sub = (angles[0::2] - angles[1::2]) / 2
    cx = Gate("cx", target, control=head)
    return (compile_ucry(tuple(tail), target, half_add) + [cx]
            + compile_ucry(tuple(tail), target, half_sub) + [cx])


def prepare(amplitudes: np.ndarray) -> tuple[list[Gate], list[dict]]:
    """Nonnegative vector preparation by low-bit-first conditional masses."""
    amplitudes = np.asarray(amplitudes, dtype=float)
    if (amplitudes.ndim != 1 or amplitudes.size == 0
            or amplitudes.size & (amplitudes.size - 1)
            or not np.all(np.isfinite(amplitudes)) or np.any(amplitudes < 0)):
        raise ValueError("expected a finite nonnegative vector of power-of-two length")
    maximum = float(np.max(amplitudes))
    if maximum == 0:
        raise ValueError("the all-zero target cannot be normalized")
    weights = (amplitudes / maximum)**2
    n = amplitudes.size.bit_length() - 1
    gates, rows = [], []
    for depth in range(n):
        angles = []
        for prefix in range(2**depth):
            m0 = math.fsum(weights[prefix::2**(depth+1)])
            m1 = math.fsum(weights[prefix+2**depth::2**(depth+1)])
            angle = 0.0 if m0+m1 == 0 else 2*math.atan2(math.sqrt(m1), math.sqrt(m0))
            angles.append(angle)
            rows.append(dict(depth=depth, low_bit_prefix=prefix,
                             mass_0_scaled=m0, mass_1_scaled=m1, angle=angle,
                             zero_parent=m0+m1 == 0))
        gates.extend(compile_ucry(tuple(range(depth)), depth, np.asarray(angles)))
    return gates, rows


def simulate(gates: list[Gate], n: int, initial: np.ndarray | None = None) -> np.ndarray:
    """Independent little-endian primitive statevector interpreter."""
    state = np.zeros(2**n, dtype=complex) if initial is None else np.array(initial, dtype=complex)
    if initial is None:
        state[0] = 1
    if state.shape != (2**n,):
        raise ValueError("initial state dimension mismatch")
    for gate in gates:
        if not 0 <= gate.target < n:
            raise ValueError("target out of range")
        mask = 1 << gate.target
        if gate.name == "ry":
            c, s = math.cos(gate.angle/2), math.sin(gate.angle/2)
            for j in range(2**n):
                if j & mask == 0:
                    x, y = state[j], state[j | mask]
                    state[j], state[j | mask] = c*x - s*y, s*x + c*y
        elif gate.name == "cx":
            if gate.control is None or not 0 <= gate.control < n or gate.control == gate.target:
                raise ValueError("invalid controlled-X")
            for j in range(2**n):
                if j & (1 << gate.control) and j & mask == 0:
                    state[j], state[j | mask] = state[j | mask], state[j]
        else:
            raise ValueError(f"unsupported primitive: {gate.name}")
    return state


def qasm_text(gates: list[Gate], n: int, version: int = 3) -> str:
    if n == 0:
        raise ValueError("OpenQASM export requires at least one qubit")
    if version == 3:
        lines = ['OPENQASM 3.0;', 'include "stdgates.inc";', f'qubit[{n}] q;']
    elif version == 2:
        lines = ['OPENQASM 2.0;', 'include "qelib1.inc";', f'qreg q[{n}];']
    else:
        raise ValueError("unsupported QASM version")
    lines += [f'ry({g.angle:.17g}) q[{g.target}];' if g.name == "ry"
              else f'cx q[{g.control}],q[{g.target}];' for g in gates]
    return "\n".join(lines) + "\n"


def qiskit_replay(gates: list[Gate], n: int, target: np.ndarray) -> tuple[dict, object]:
    try:
        import qiskit
        from qiskit import QuantumCircuit, qasm2, qasm3
        from qiskit.quantum_info import Statevector
    except ImportError as exc:
        raise RuntimeError("Qiskit is required for acceptance; install requirements-executable.txt. "
                           "--numpy-only produces diagnostic evidence only.") from exc
    circuit = QuantumCircuit(n)
    for gate in gates:
        if gate.name == "ry":
            circuit.ry(gate.angle, gate.target)
        elif gate.name == "cx":
            circuit.cx(gate.control, gate.target)
        else:
            raise ValueError("nonprimitive gate in export")
    states = {"qiskit": np.asarray(Statevector.from_instruction(circuit).data),
              "qasm2": np.asarray(Statevector.from_instruction(qasm2.loads(qasm_text(gates, n, 2))).data),
              "qasm3": np.asarray(Statevector.from_instruction(qasm3.loads(qasm_text(gates, n, 3))).data)}
    errors = {name: float(np.max(np.abs(state-target))) for name, state in states.items()}
    if max(errors.values()) > 1e-10:
        raise AssertionError(f"Qiskit/QASM replay failed: {errors}")
    return dict(passed=True, version=qiskit.__version__, max_amplitude_errors=errors,
                depth=circuit.depth(), basis=["ry", "cx"],
                round_trips=["OpenQASM 2", "OpenQASM 3"]), circuit


def _write_json(path: Path, payload: object) -> None:
    path.write_text(json.dumps(payload, indent=2, sort_keys=True, allow_nan=False)+"\n",
                    encoding="utf-8", newline="\n")


def circuit_svg(gates: list[Gate], n: int, k: int, length: float) -> str:
    """Self-contained vector circuit, drawn directly from the emitted primitives."""
    if n > 5:
        raise ValueError("readable inline circuit figure supports at most five qubits")
    column = 72
    width = max(1390, 245+column*len(gates))
    first_y, spacing = 233, 74
    lower = first_y+(n-1)*spacing+90
    height = lower+370
    svg = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}" role="img" aria-labelledby="title desc">',
           '<title id="title">Explicit Hermite sample preparation with RY and CNOT gates</title>',
           '<desc id="desc">Low-bit-first preparation on n data qubits. Every primitive is drawn in chronological order. No ancillary, flag, carry, or oracle register is used. The formula and Lean references appear below.</desc>',
           '<style>text{font-family:Inter,Segoe UI,Arial,sans-serif;fill:#163042}.title{font-size:31px;font-weight:700}.body{font-size:18px}.small{font-size:15px}.mono{font-family:Consolas,monospace;font-size:15px}.label{font-size:17px;font-weight:600}.wire{stroke:#64748b;stroke-width:2}.cx{stroke:#1d4ed8;stroke-width:2.3;fill:none}.ry{fill:#e4f5ed;stroke:#12704d;stroke-width:1.8}</style>',
           f'<rect width="{width}" height="{height}" fill="#f7fafb" rx="18"/>']

    def text(x, y, value, cls="body", extra=""):
        svg.append(f'<text x="{x}" y="{y}" class="{cls}" {extra}>{escape(str(value))}</text>')

    text(38, 54, 'Hermite samples → explicit quantum circuit', 'title')
    text(38, 88, f'k = {k}  ·  n = {n} qubits  ·  L = {length:g}  ·  {2**n} grid samples  ·  chronological order: left → right')
    text(38, 119, 'q₀ is the least-significant bit. Basis indices are read qₙ₋₁ … q₁q₀. RY and CNOT only; no ancillas or oracle calls.', 'small')
    offset = 0
    for d in range(n):
        count = 3*2**d-2
        start, end = 179+offset*column, 179+(offset+count)*column
        svg.append(f'<rect x="{start}" y="158" width="{end-start-5}" height="{lower-185}" fill="{("#ecf5f1", "#edf3fd", "#f3effb")[d%3]}" rx="8"/>')
        text((start+end-5)/2, 183, f'd={d}: ' + ('RY' if d == 0 else f'{d}-control UCRY'), 'small', 'text-anchor="middle"')
        offset += count
    for q in range(n):
        y = first_y+q*spacing
        text(34, y+6, f'q{q} : |0⟩', 'label')
        svg.append(f'<line x1="145" y1="{y}" x2="{width-35}" y2="{y}" class="wire"/>')
    for i, gate in enumerate(gates):
        x, y = 212+i*column, first_y+gate.target*spacing
        if gate.name == 'ry':
            svg.append(f'<rect x="{x-25}" y="{y-22}" width="50" height="44" rx="6" class="ry"/>')
            text(x, y+5, 'RY', 'label', 'text-anchor="middle"')
            text(x, y+39, f'{gate.angle/math.pi:.3f}π', 'small', 'text-anchor="middle"')
        else:
            cy = first_y+gate.control*spacing
            svg.append(f'<line x1="{x}" y1="{cy}" x2="{x}" y2="{y}" class="cx"/>')
            svg.append(f'<circle cx="{x}" cy="{cy}" r="5" fill="#1d4ed8"/>')
            svg.append(f'<circle cx="{x}" cy="{y}" r="13" fill="#f7fafb" stroke="#1d4ed8" stroke-width="2"/>')
            svg.append(f'<path d="M{x-8},{y}h16 M{x},{y-8}v16" class="cx"/>')
    text(38, lower, 'HOW THE CIRCUIT BUILDS THE STATE', 'label')
    text(38, lower+32, 'M_d(s) = sum of f_j² over j mod 2^d = s;  θ_d,s = 2 atan2(√M_{d+1}(s+2^d), √M_{d+1}(s)).')
    text(38, lower+60, 'After stage d, the lowest d+1 wires encode √(M_{d+1}(s)/M₀); all higher wires are still |0⟩.')
    text(38, lower+88, 'After the last stage: |0…0⟩ → Σ_j f_j / √(Σ_i f_i²) |j⟩. Each control is preserved by its controlled gate.')
    text(38, lower+126, 'READ THE GATES', 'label')
    text(38, lower+154, 'RY(θ)|0⟩ = cos(θ/2)|0⟩ + sin(θ/2)|1⟩. A filled dot controls the ⊕ target; it flips only for control bit 1.')
    text(38, lower+182, 'All wires are data outputs. There is no separate carry/flag path. Zero-mass branches use θ=0 and remain unreachable.')
    text(38, lower+220, 'NAMED FORMAL INTERFACE', 'label')
    text(38, lower+248, 'QuantumBlockEncoding.compileUniformlyControlledRy_eval_controlledRyBlockMatrix', 'mono')
    text(38, lower+274, 'This theorem certifies the exact recursive multiplexor. The full state-preparation theorem is linked from the case page.', 'small')
    text(38, lower+306, 'Numbers shown on this figure are rounded. OpenQASM retains 17 significant digits; finite NumPy/Qiskit replay checks the export.', 'small')
    text(38, lower+331, f'Reference counts: {2**n-1} RY + {2*(2**n-1-n)} CNOT. Exact symbolic claims require the separate repository Lean gate.', 'small')
    svg.append('</svg>')
    return '\n'.join(svg)+'\n'


def export_case(k: int, n: int, length: float, output: Path, numpy_only: bool = False) -> dict:
    output.mkdir(parents=True, exist_ok=True)
    _write_json(output/"acceptance.json", {"schema_version": 1, "task": "SP-HERMITE-001",
                "accepted": False, "evidence_class": "incomplete-run"})
    if not 1 <= n <= 10 or not math.isfinite(length) or length <= 0:
        raise ValueError("finite replay supports 1 <= n <= 10 and finite L > 0")
    endpoint = endpoint_check(k)
    grid = -math.pi*length + 2*math.pi*length*np.arange(2**n)/2**n
    samples = hermite_values(grid, k)
    target = samples/np.linalg.norm(samples)
    gates, tree = prepare(samples)
    independent = simulate(gates, n)
    error = float(np.max(np.abs(independent-target)))
    if error > 1e-10:
        raise AssertionError(f"independent primitive replay failed: {error}")
    ry = sum(g.name == "ry" for g in gates)
    cx = sum(g.name == "cx" for g in gates)
    if (ry, cx) != (2**n-1, 2*(2**n-1-n)):
        raise AssertionError("reference compiler resource mismatch")
    replay = dict(passed=False, reason="explicit numpy-only diagnostic mode")
    if not numpy_only:
        replay, _ = qiskit_replay(gates, n, target)
    output.mkdir(parents=True, exist_ok=True)
    _write_json(output/"endpoint-jets.json", endpoint)
    _write_json(output/"mass-tree.json", tree)
    for version in (2, 3):
        (output/f"circuit.qasm{version}").write_text(qasm_text(gates, n, version), encoding="utf-8", newline="\n")
    (output/"circuit.qasm").write_text(qasm_text(gates, n, 3), encoding="utf-8", newline="\n")
    if n <= 5:
        (output/"circuit.svg").write_text(circuit_svg(gates, n, k, length), encoding="utf-8", newline="\n")
    with (output/"samples.csv").open("w", newline="", encoding="utf-8") as stream:
        writer = csv.writer(stream, lineterminator="\n")
        writer.writerow(["index", "basis_q_high_to_low", "p", "f", "target_amplitude", "numpy_real", "numpy_imag"])
        for j, p in enumerate(grid):
            writer.writerow([j, format(j, f"0{n}b"), f"{p:.17g}", f"{samples[j]:.17g}",
                             f"{target[j]:.17g}", f"{independent[j].real:.17g}", f"{independent[j].imag:.17g}"])
    manifest = {
        "schema_version": 1, "task": "SP-HERMITE-001", "parameters": {"k": k, "n": n, "L": length},
        "source": "https://arxiv.org/abs/2403.19123", "source_anchor": "Section 4.3, equations 4.31-4.32 (v3)",
        "amplitude": "exp(p) for p<=-1; exp(-1)*(1-t)^(k+1)*A_k(t)+t^(k+1)*A_k(1-t) for -1<p<0, t=p+1; exp(-p) for p>=0",
        "A_coefficient": "a_(k,r)=sum_(m=0)^r choose(k+r-m,k)/m!; 0<=r<=k",
        "grid": "p_j=-pi*L+2*pi*L*j/2^n", "normalization": "f_j/sqrt(sum_i f_i^2)",
        "smoothness": "C^k splice; the k=1 cubic is not asserted to be C^2",
        "registers": [{"name": f"q[{q}]", "integer_bit_weight": 2**q, "input": "0", "output": "data amplitude"} for q in range(n)],
        "ancillas": [], "control_order": "low to high", "allowed_gates": ["ry", "cx"],
        "theorem_links": [{"declaration": "QuantumBlockEncoding.compileUniformlyControlledRy_eval_controlledRyBlockMatrix",
                           "source": "QuantumBlockEncoding/UniformlyControlledRy.lean", "scope": "exact primitive multiplexor compilation"}],
        "lean_gate": "separate repository build; this manifest is not build evidence",
        "checkBackends": {
            "internalCanonicalEvaluator": {"status": "passed", "method": "independent NumPy primitive statevector"},
            "qiskitOperator": {"status": "not-run" if numpy_only else "passed", "method": "Qiskit Statevector.from_instruction, not full Operator"},
            "openqasm3RoundTrip": {"status": "not-run" if numpy_only else "passed", "method": "Qiskit qasm3.loads followed by statevector replay"},
        },
        "exporter": "executable-exports/SP-HERMITE-001/qiskit/export.py",
        "executable_evidence": "acceptance.json", "circuit": "circuit.qasm", "samples": "samples.csv",
    }
    _write_json(output/"manifest.json", manifest)
    artifacts = ["endpoint-jets.json", "mass-tree.json", "circuit.qasm", "circuit.qasm2", "circuit.qasm3", "samples.csv", "manifest.json"]
    if n <= 5:
        artifacts.append("circuit.svg")
    payload = {
        "schema_version": 1, "task": "SP-HERMITE-001",
        "exporter_sha256": hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
        "evidence_class": "finite-executable-acceptance" if not numpy_only else "finite-numpy-diagnostic",
        "accepted": not numpy_only, "lean_certificate_claimed": False,
        "parameters": {"k": k, "n": n, "L": length},
        "grid": "p_j = -pi*L + 2*pi*L*j/2^n; 0 <= j < 2^n",
        "target": "normalized positive samples of exp(p), P_k(p), exp(-p) at cuts -1 and 0",
        "bit_order": "q[0] is the least-significant bit; preparation consumes low bits first",
        "rotation_convention": "RY(theta)|0> = cos(theta/2)|0> + sin(theta/2)|1>",
        "zero_parent_convention": "theta=0; unreachable subtree remains zero",
        "resource": {"qubits": n, "ancillas": 0, "ry": ry, "cx": cx, "oracle_calls": 0,
                     "reference_counts": "RY=2^n-1; CX=2*(2^n-1-n)", "optimized": False},
        "numpy": {"max_amplitude_error": error, "norm_error": float(abs(np.linalg.norm(independent)-1))},
        "qiskit": replay, "exact_endpoint_checks": endpoint["passed"],
        "limitations": ["Floating-point samples and rotations; not an arbitrary-width symbolic certificate.",
                        "Reference gate counts are exponential; no resource optimality claim.",
                        "The executable implementation is a mirror, not extracted from Lean."],
        "artifact_sha256": {name: hashlib.sha256((output/name).read_bytes()).hexdigest() for name in artifacts},
    }
    _write_json(output/"acceptance.json", payload)
    return payload


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--k", type=int, default=1)
    parser.add_argument("--n", type=int, default=3)
    parser.add_argument("--L", type=float, default=1.0)
    parser.add_argument("--out-dir", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--numpy-only", action="store_true")
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()
    if args.self_test:
        import unittest
        if not (Path(__file__).parent/"test_export.py").is_file():
            parser.error("required test_export.py is missing")
        suite = unittest.defaultTestLoader.discover(str(Path(__file__).parent), pattern="test_export.py")
        if suite.countTestCases() == 0:
            parser.error("no Hermite regression tests discovered")
        return 0 if unittest.TextTestRunner(verbosity=2).run(suite).wasSuccessful() else 1
    try:
        result = export_case(args.k, args.n, args.L, args.out_dir, args.numpy_only)
    except (ValueError, RuntimeError, AssertionError, ImportError) as exc:
        print(f"Hermite export failed: {exc}", file=sys.stderr)
        return 1
    print(json.dumps({key: result[key] for key in ("accepted", "evidence_class", "parameters", "resource", "numpy", "qiskit")}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
