# Recursive primitive-backend refinement: cycle 03

Date: 2026-09-10. Frozen task: `SP-HERMITE-POLY-002`. No source target,
acceptance anchor, historical artifact or scoring rule is changed.

## What is now checked

`QuantumBlockEncoding/SelectedRyTrace.lean` defines a computable instruction
trace containing physical wire indices and exact rational multipliers of one
symbolic angle. `compile_refines` proves its instantiated matrix equals the
existing recursive uniformly controlled RY compiler for every control width;
`selected_refines` specializes this to one selected control pattern. The
actual trace length is `2^q + 2*(2^q-1)`, including zero-angle instructions.
Here `q` counts local controls, not all data qubits. Its exponential factor is
the bounded local bond capacity, not a full `2^n_p` amplitude table.

The Lean driver `mps/EmitSelectedRyTraces.lean` executes that definition for
0 through 4 controls, every target position, and every control pattern.
`mps/check_selected_ry_traces.py` compares the resulting integer numerators,
denominators, instruction tags and physical wires exactly against the new
Python `Fraction` implementation. The recorded run checked 129 cases and
4,521 instructions. Missing, empty, incomplete, duplicate or malformed
records fail closed; booleans cannot masquerade as integer coefficients.
This bounded cross-language check is not a proof of Python semantics for
unbounded inputs. The all-width mathematical refinement theorem is in Lean.

The separate `mps/recursive_ry_trace.py` emitter substitutes this backend into
the existing numerical plane plan, preserving the earlier Walsh emitter.
New QASM output uses exclusive creation so a rerun cannot silently overwrite
an earlier circuit. `mps/replay_mps_qasm.py` independently reloads the saved
QASM and obtains its target from the analytic-mass source evaluator; it does
not import the MPS constructor or either emitter.

| Instance | RY | CX | Depth | State error | Non-clean bond norm |
| --- | ---: | ---: | ---: | ---: | ---: |
| n_p=8, k=8, L=10 | 764 | 1,146 | 1,878 | 2.6299469e-15 | 3.6591472e-16 |
| n_p=8, k=8, L=300 | 90 | 90 | 180 | 4.3372169e-15 | 0 |

Evidence is in `evidence/cycle03-selected-ry-comparison.json` and the two
`cycle03-recursive-replay-*.json` files. Their hashes identify the actual
trace/QASM inputs; they are observations, not success attestations trusted
without rerunning the checker. The 26-test MPS suite passed after adding eight
recursive-backend tests, including both orientations of every small adjacent
plane, control ordering, finite state action, cleanup, counts and rejection
paths. The unchanged mass suite is a separate test target.

## What is deliberately not claimed

- The new recursive backend is not uniformly cheaper: at L=10 it emits 382
  more CX gates than the earlier Walsh backend, while agreeing with the
  already formalized recursive design. Both candidates remain available.
- The recorded n_p=128 export still belongs to the earlier Walsh backend;
  it was not regenerated or relabeled as a recursive-backend result.
- Float64 QR, real-angle evaluation, source coefficient rounding and
  underflow pruning have not acquired a uniform error certificate from this
  local trace comparison. No whole Python-to-Lean compiler equivalence is
  inferred from equal finite output states.
- These finite replays do not close the scientific family's executable or
  finite-bit complexity gate. No `full_frozen_task_accepted` flag is set.

## Reproduction

Use the repository environment and a fresh output name/directory:

```text
python -c "from pathlib import Path; Path('_out/hermite-poly-search').mkdir(parents=True, exist_ok=True)"
lake build QuantumBlockEncoding.SelectedRyTrace
lake env lean ABEISTests/SelectedRyTrace.lean
lake env lean --run experiments/hermite-polynomial/mps/EmitSelectedRyTraces.lean _out/hermite-poly-search/new-selected-ry-traces.json
python -B experiments/hermite-polynomial/mps/check_selected_ry_traces.py _out/hermite-poly-search/new-selected-ry-traces.json
python -B -m unittest discover -s experiments/hermite-polynomial/mps -p "test_*.py" -v
python -B experiments/hermite-polynomial/mps/probe_recursive_backend.py --output-dir _out/hermite-poly-search/new-recursive-replay
python -B experiments/hermite-polynomial/mps/replay_mps_qasm.py _out/hermite-poly-search/new-recursive-replay/recursive-n8-k8-L10.qasm --n 8 --k 8 --L 10
python -B experiments/hermite-polynomial/mps/replay_mps_qasm.py _out/hermite-poly-search/new-recursive-replay/recursive-n8-k8-L300.qasm --n 8 --k 8 --L 300
```

No model calls, account credentials or machine-specific paths are required.
The first command creates the parent needed by the Lean trace exporter; that
exporter does not implicitly create a missing output directory.
The checker and replay commands return nonzero on failure; site generation
must never replace these commands with a check that the JSON file exists.
