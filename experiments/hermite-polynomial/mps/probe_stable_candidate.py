"""Save stable-core finite discriminators and no-dense large-width costs."""
from decimal import Decimal, localcontext
import argparse
from fractions import Fraction
import hashlib
import json
import math
from pathlib import Path
import sys
import time
import numpy as np
from mps_core_probe import right_canonicalize, row_isometry_error
from mps_stable_cores import stable_hermite_tt
from mps_ry_compiler import compile_mps, prune_zero_paths

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "mass"))
from analytic_mass import HermiteMass


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output-dir", type=Path,
                        default=Path("_out/hermite-poly-search/reproduction/mps"))
    args = parser.parse_args()
    output = args.output_dir
    output.mkdir(parents=True, exist_ok=True)
    records = []
    cases = [(8, 4, "2"), (8, 8, "10"), (8, 2, "300"), (8, 8, "300"),
             (32, 2, "1"), (64, 2, "1"), (128, 2, "1"),
             (128, 8, "10"), (128, 8, "300")]
    for n, k, length in cases:
        start = time.perf_counter()
        raw, record = stable_hermite_tt(n, k, Fraction(length))
        canonical, norm = right_canonicalize(raw)
        record["core_and_qr_seconds"] = time.perf_counter()-start
        with localcontext() as context:
            context.prec = math.ceil(n*math.log10(2))+100
            model = HermiteMass(k, n, Decimal(length))
            independent_mass = model.high_prefix(0, 0)
            record["independent_norm_squared"] = str(independent_mass)
            record["norm_relative_error"] = float(abs(Decimal(norm)**2/independent_mass-1))
            if n <= 8:
                expected = np.array([float(model.value(j)) for j in range(1 << n)])
                record["max_amplitude_error"] = float(np.max(np.abs(raw.small_dense_diagnostic()-expected)))
                record["state_error_before_primitive_compile"] = float(np.linalg.norm(
                    canonical.small_dense_diagnostic()-expected/np.linalg.norm(expected)))
            else:
                record["selected_amplitude_max_error"] = max(abs(raw.amplitude(j)-float(model.value(j)))
                    for j in {0, int(record["left_cutoff"]), (1 << (n-1))-1, 1 << (n-1), (1 << n)-1})
            record["mass_reference_sample_calls"] = model.counters["sample_evaluations"]
        record["row_isometry_error"] = row_isometry_error(canonical)
        record["last_bond"] = canonical.cores[-1].shape[2]
        if n <= 8 or k == 2:
            plan_start = time.perf_counter()
            plan = compile_mps(raw)
            record["primitive_plan_seconds"] = time.perf_counter()-plan_start
            record["primitive_resources"] = plan.resource_counts
            record["plane_count"] = plan.plane_count
            record["active_bond_dimensions"] = plan.active_bonds
            record["final_active_input_dimension"] = plan.active_bonds[-2]
            record["final_active_output_dimension"] = plan.active_bonds[-1]
            record["small_completion_max_error"] = plan.max_completion_error
            record["global_dense_unitary_constructed"] = False
            record["pruned_bond"] = prune_zero_paths(raw).max_bond
            if (n, k, length) in {(8, 8, "10"), (8, 8, "300"), (128, 2, "1")}:
                name = f"mps02-n{n}-k{k}-L{length}.qasm"
                path = output/name
                export_start = time.perf_counter()
                plan.write_qasm2(path)
                record["qasm"] = name
                record["qasm_bytes"] = path.stat().st_size
                record["qasm_sha256"] = hashlib.sha256(path.read_bytes()).hexdigest()
                record["qasm_export_seconds"] = time.perf_counter()-export_start
        records.append(record)
        print(json.dumps(record, ensure_ascii=True), flush=True)
    report = {"task": "SP-HERMITE-POLY-002", "run": "hermite-poly-20260910-cycle01",
              "candidate": "MPS-02", "status": "screening_only_not_certified",
              "claims_excluded": ["uniform precision", "Lean stable TT certificate", "family gate certificate"],
              "records": records}
    (output/"stable-results.json").write_text(json.dumps(report, indent=2)+"\n", encoding="utf-8")


if __name__ == "__main__":
    main()
