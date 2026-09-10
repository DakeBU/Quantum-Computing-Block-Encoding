"""Create fresh recursive-backend QASM for independent Hermite replay.

Only the local emitter changes; core generation and the numerical plane plan
are the existing experimental code. Every output is exclusive-create.
"""
import argparse
from fractions import Fraction
import hashlib
import json
from pathlib import Path

from mps_ry_compiler import compile_mps
from mps_stable_cores import stable_hermite_tt
from recursive_ry_trace import recursive_resource_counts, write_recursive_qasm


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output-dir", type=Path, required=True)
    args = parser.parse_args()
    args.output_dir.mkdir(parents=True, exist_ok=False)
    records = []
    for length in ("10", "300"):
        raw, _ = stable_hermite_tt(8, 8, Fraction(length))
        plan = compile_mps(raw)
        output = args.output_dir / f"recursive-n8-k8-L{length}.qasm"
        write_recursive_qasm(plan, output)
        records.append({"n": 8, "k": 8, "L": length, "file": output.name,
                        "resources": recursive_resource_counts(plan), "planes": plan.plane_count,
                        "bytes": output.stat().st_size,
                        "sha256": hashlib.sha256(output.read_bytes()).hexdigest()})
    result = {"status": "constructed_not_replayed", "records": records,
              "backend": "rational_recursive_selected_ry",
              "whole_classical_compiler_certified": False, "uniform_error_certified": False}
    text = json.dumps(result, indent=2) + "\n"
    with (args.output_dir / "construction.json").open("x", encoding="utf-8") as stream:
        stream.write(text)
    print(text, end="")


if __name__ == "__main__":
    main()
