"""Compare a freshly executed Lean trace artifact with the Python emitter.

Missing, empty, incomplete, duplicated or malformed artifacts fail closed.
This is a bounded cross-language regression, not a whole-state certificate.
"""
import argparse
import hashlib
import json
from pathlib import Path

from recursive_ry_trace import selected_trace, trace_json


def check(path: Path) -> dict:
    data = path.read_bytes()
    artifact = json.loads(data)
    if artifact.get("schema") != "aspbe-selected-ry-traces-v1":
        raise ValueError("wrong trace schema")
    if artifact.get("lean_root") != "QuantumBlockEncoding.SelectedRyTrace.selected_refines":
        raise ValueError("wrong Lean trace root")
    expected_keys = {(q + 1, target, pattern) for q in range(5)
                     for target in range(q + 1) for pattern in range(1 << q)}
    seen = set()
    instructions = 0
    for case in artifact.get("cases", []):
        qubits, target, pattern = case["qubits"], case["target"], case["pattern"]
        if any(type(value) is not int for value in (qubits, target, pattern)):
            raise ValueError("non-integer case index")
        key = qubits, target, pattern
        if key not in expected_keys or key in seen:
            raise ValueError("unexpected or duplicate trace case")
        seen.add(key)
        controls = [q for q in range(qubits) if q != target]
        if case["controls"] != controls or any(type(q) is not int for q in case["controls"]):
            raise ValueError("wrong physical control order")
        gates = case["gates"]
        for gate in gates:
            fields = {"op", "target", "numerator", "denominator"} if gate.get("op") == "ry" else {
                "op", "control", "target"}
            if set(gate) != fields or gate.get("op") not in {"ry", "cx"}:
                raise ValueError("malformed trace gate")
            if any(type(value) is not int for name, value in gate.items() if name != "op"):
                raise ValueError("non-integer exact gate field")
        if gates != trace_json(selected_trace(qubits, controls, target, pattern)):
            raise ValueError(f"instruction mismatch at {key}")
        instructions += len(gates)
    if seen != expected_keys:
        raise ValueError("incomplete Lean trace coverage")
    return {"status": "bounded_exact_trace_comparison_pass", "cases": len(seen),
            "instructions_compared": instructions, "artifact_sha256": hashlib.sha256(data).hexdigest(),
            "whole_state_certificate": False, "uniform_rounding_certificate": False}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("traces", type=Path)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    result = check(args.traces)
    text = json.dumps(result, indent=2) + "\n"
    if args.output:
        with args.output.open("x", encoding="utf-8") as stream:
            stream.write(text)
    print(text, end="")


if __name__ == "__main__":
    main()
