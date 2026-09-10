"""Read-only streaming structural check; explicitly not a state simulation."""
import argparse
import hashlib
import json
import math
from pathlib import Path
import re


def scan(path: Path):
    digest, counts = hashlib.sha256(), {"ry": 0, "cx": 0}
    with path.open("rb") as stream:
        header = [stream.readline() for _ in range(3)]
        for line in header:
            digest.update(line)
        if header[:2] != [b"OPENQASM 2.0;\n", b'include "qelib1.inc";\n']:
            raise ValueError("unexpected QASM header")
        match = re.fullmatch(rb"qreg q\[(\d+)\];\n", header[2])
        if not match:
            raise ValueError("missing qubit declaration")
        qubits = int(match[1])
        for line in stream:
            digest.update(line)
            rotation = re.fullmatch(rb"ry\(([^)]+)\) q\[(\d+)\];\n", line)
            cnot = re.fullmatch(rb"cx q\[(\d+)\],q\[(\d+)\];\n", line)
            if rotation:
                if not math.isfinite(float(rotation[1])) or not 0 <= int(rotation[2]) < qubits:
                    raise ValueError("invalid rotation")
                counts["ry"] += 1
            elif cnot:
                a, b = int(cnot[1]), int(cnot[2])
                if not 0 <= a < qubits or not 0 <= b < qubits or a == b:
                    raise ValueError("invalid CX")
                counts["cx"] += 1
            else:
                raise ValueError("unexpected nonprimitive statement")
    return {"status": "structural_scan_pass_not_state_acceptance", "qubits": qubits,
            "gate_counts": counts, "sha256": digest.hexdigest(),
            "dense_statevector_constructed": False, "bytes": path.stat().st_size}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("qasm", type=Path)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    text = json.dumps(scan(args.qasm), indent=2)+"\n"
    if args.output:
        args.output.write_text(text, encoding="utf-8")
    print(text)


if __name__ == "__main__":
    main()
