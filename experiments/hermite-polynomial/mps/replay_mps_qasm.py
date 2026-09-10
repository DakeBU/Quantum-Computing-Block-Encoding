"""Independent finite QASM replay: never imports an MPS/core/compiler module."""
import argparse
from decimal import Decimal, localcontext
import hashlib
import json
import math
from pathlib import Path
import sys
import numpy as np
from qiskit import qasm2
from qiskit.quantum_info import Statevector

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "mass"))
from analytic_mass import HermiteMass


def replay(path: Path, n: int, k: int, length: str, max_qubits: int = 16):
    circuit = qasm2.load(path)
    if circuit.num_qubits > max_qubits:
        raise ValueError("finite replay width budget exceeded")
    if set(circuit.count_ops()) - {"ry", "cx"}:
        raise ValueError("QASM is not primitive RY/CX")
    with localcontext() as context:
        context.prec = math.ceil(n*math.log10(2))+100
        model = HermiteMass(k, n, Decimal(length))
        mass = model.high_prefix(0, 0)
        expected = np.array([float(model.value(j)/mass.sqrt()) for j in range(1 << n)])
    actual = Statevector.from_instruction(circuit).data
    state_error = float(np.linalg.norm(actual[:1 << n]-expected))
    garbage = float(np.linalg.norm(actual[1 << n:]))
    result = {"status": "finite_diagnostic_pass" if max(state_error, garbage) < 1e-9 else "finite_diagnostic_fail",
              "n": n, "k": k, "L": length, "ancillas": circuit.num_qubits-n,
              "source_norm_squared": str(mass), "state_error": state_error,
              "ancilla_garbage_norm": garbage, "global_phase": float(circuit.global_phase),
              "gate_counts": dict(circuit.count_ops()), "depth": circuit.depth(),
              "qasm_sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
              "dense_statevector_used_only_for_finite_replay": True,
              "formal_or_uniform_error_certificate": False}
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("qasm", type=Path)
    parser.add_argument("--n", type=int, required=True)
    parser.add_argument("--k", type=int, required=True)
    parser.add_argument("--L", required=True)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    result = replay(args.qasm, args.n, args.k, args.L)
    text = json.dumps(result, indent=2)+"\n"
    if args.output:
        args.output.write_text(text, encoding="utf-8")
    print(text)
    return 0 if result["status"] == "finite_diagnostic_pass" else 1


if __name__ == "__main__":
    raise SystemExit(main())
