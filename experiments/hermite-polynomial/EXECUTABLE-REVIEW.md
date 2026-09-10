# Independent executable revalidation — 2026-09-10

Outcome: all five requested runs passed on current source and actual saved
QASM. MPS: 18/18 tests; MASS: 7/7 tests. Both n=8 replays passed. The n=128
artifact passed streaming structural inspection only, not state acceptance.

All paths below are relative to the repository root. Fresh output directory:
`_out/hermite-poly-search/givens/final-executable-20260910-01/`.
No production files, historical JSON, or QASM were changed. No large QASM was
regenerated. No historical success result was used as current-run evidence.

## Environment and commands

Interpreter: `.venv/Scripts/python.exe`, Python 3.12.14; NumPy 1.26.4;
Qiskit 2.4.2. Commands ran from the repository root with `-B`.

| Run | Actual process exit | Current result | Fresh log |
| --- | ---: | --- | --- |
| MPS unit tests | 0 | 18 tests, OK | `mps-tests.log` |
| MASS unit tests | 0 | 7 tests, OK | `mass-tests.log` |
| n8/k8/L10 QASM replay | 0 | `finite_diagnostic_pass` | `replay-L10.log` |
| n8/k8/L300 QASM replay | 0 | `finite_diagnostic_pass` | `replay-L300.log` |
| n128/k2/L1 streaming scan | 0 | `structural_scan_pass_not_state_acceptance` | `scan-n128.log` |
| Deliberately missing QASM replay | 1 | Expected `FileNotFoundError`, no fallback | `missing-replay.log` |
| Deliberately missing QASM scan | 1 | Expected `FileNotFoundError`, no fallback | `missing-scan.log` |

Log names in the table are within the fresh output directory. The full
commands, before the PowerShell log capture, were:

```text
.venv/Scripts/python.exe -B -m unittest discover -s experiments/hermite-polynomial/mps -p "test_mps*.py" -v
.venv/Scripts/python.exe -B -m unittest discover -s experiments/hermite-polynomial/mass -p "test_*.py" -v
.venv/Scripts/python.exe -B experiments/hermite-polynomial/mps/replay_mps_qasm.py _out/hermite-poly-search/reproduction/mps/mps02-n8-k8-L10.qasm --n 8 --k 8 --L 10 --output _out/hermite-poly-search/givens/final-executable-20260910-01/replay-n8-k8-L10.json
.venv/Scripts/python.exe -B experiments/hermite-polynomial/mps/replay_mps_qasm.py _out/hermite-poly-search/reproduction/mps/mps02-n8-k8-L300.qasm --n 8 --k 8 --L 300 --output _out/hermite-poly-search/givens/final-executable-20260910-01/replay-n8-k8-L300.json
.venv/Scripts/python.exe -B experiments/hermite-polynomial/mps/scan_qasm_primitives.py _out/hermite-poly-search/reproduction/mps/mps02-n128-k2-L1.qasm --output _out/hermite-poly-search/givens/final-executable-20260910-01/scan-n128-k2-L1.json
.venv/Scripts/python.exe -B experiments/hermite-polynomial/mps/replay_mps_qasm.py _out/hermite-poly-search/givens/final-executable-20260910-01/missing.qasm --n 8 --k 8 --L 10
.venv/Scripts/python.exe -B experiments/hermite-polynomial/mps/scan_qasm_primitives.py _out/hermite-poly-search/givens/final-executable-20260910-01/missing.qasm
```

PowerShell captured each stream with `2>&1 | Tee-Object -FilePath ...`, then
returned `exit $LASTEXITCODE`. Thus the recorded exits are the actual Python
process exits, not merely successful log creation. The intentionally absent
path was checked with `Test-Path` (False) before both fail-closed tests.

## Actual artifacts and measurements

All three requested artifacts were found before execution under
`_out/hermite-poly-search/reproduction/mps/`. These are the files actually
opened by the replay/scanner, not similarly named historical result JSON.

| Artifact | Bytes | Total qubits | RY | CX | State error | Ancilla garbage norm | Depth |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `mps02-n8-k8-L10.qasm` | 33908 | 10 | 764 | 764 | 2.539822508729777e-15 | 2.784768436797188e-16 | 1397 |
| `mps02-n8-k8-L300.qasm` | 4004 | 9 | 90 | 90 | 4.33721690601771e-15 | 0.0 | 180 |
| `mps02-n128-k2-L1.qasm` | 37333643 | 132 | 741936 | 741936 | Not simulated | Not simulated | Not measured |

Both finite replays reported global phase 0.0. Their two ancilla counts are
2 and 1. Their acceptance threshold is `max(state_error, garbage) < 1e-9`.
The expected state is evaluated independently using
`experiments/hermite-polynomial/mass/analytic_mass.py`; the replay imports no
MPS core or compiler module. Dense statevectors are used only for these small
finite replays (10 and 9 total qubits, below the replay's 16-qubit cap).

The n128 scan streamed bytes and verified the header, 132-qubit declaration,
only RY/CX statements, finite numeric angles, valid wire indices, distinct CX
wires, counts, and SHA256. It constructed no dense statevector. Its 1,483,872
primitive gates and four extra qubits are structural observations, not a
whole-state error certificate.

QASM SHA256 values returned by these fresh runs:

```text
7e923cde8e61a972232b62c1b6a03774ffbbf623bb2ddcb5347d9a7c790960bd  _out/hermite-poly-search/reproduction/mps/mps02-n8-k8-L10.qasm
1a9c616eb7021629ca6fcc2afb8589f6e17671f3fcf3d0e90b290644ac622909  _out/hermite-poly-search/reproduction/mps/mps02-n8-k8-L300.qasm
fdb68b55ccdbe24e3e2c3f2dd97825ca568245b437c496a834a5ca0084c95eb4  _out/hermite-poly-search/reproduction/mps/mps02-n128-k2-L1.qasm
```

The fresh replay JSON also retains the independent source mass, phase,
resource counts, and explicit `formal_or_uniform_error_certificate: false`.

## Scope of unit-test success

MPS tests include threshold/basis order, exact stored-zero pruning on small
instances, arbitrary small SO matrices, both edge orientations, actual
primitive state/cleanup, no-dense/no-SVD large-width constructors, and repaired
stable-core cases. The suite deliberately *retains* the old monomial
conditioning and exponential-overflow counterexamples. Passing those tests
means the expected failures remain observable, not that the original unstable
algorithm became correct.

MASS tests include power sums, independent small-grid sums, prefix partitions,
known difficult finite cases, large-width queries without sample evaluation,
invalid-input rejection, and insufficient-precision failure. These are finite
tests, not a uniform numerical or complexity theorem.

## Reproducibility anchors

Current relevant executable source SHA256 values:

```text
9936E544066119492310DA538D5D1AA4CE46B6952DDB3C22FCA2AED53E5BF665  experiments/hermite-polynomial/mps/replay_mps_qasm.py
8C97B683E289C6D9369C7B67666480EEDE5CF3D0E8AB5AD32555E0A9A1B42FEF  experiments/hermite-polynomial/mps/scan_qasm_primitives.py
EA494CC4A313EE080AB63E947D9D338FE3C761F0FDD7D9A6093E523EB3390AE0  experiments/hermite-polynomial/mps/mps_ry_compiler.py
416769C9EA346F62013C643B06C69CC780DFE496DEA6D837F8EEBDCBF3A62CD2  experiments/hermite-polynomial/mps/mps_stable_cores.py
E8C85834AA8F9F97E65611E0DDF96F13A8DC4BB63D00AFD5462C462CE58DC1EE  experiments/hermite-polynomial/mass/analytic_mass.py
```

## Certificate boundary

The Python numerical compiler uses cyclic Gray/Walsh controlled rotations.
The checked Lean `GrayGivensCompiler` uses the recursive selected-RY compiler.
Their primitive sequences and CX counts are not identical; these successful
Python runs are not an instruction-level replay of the Lean root. Connecting
the two requires an additional refinement/equivalence certificate.

This audit revalidates executable finite observations only. It neither
duplicates the parent's Lean build acceptance nor establishes uniform
floating-point error, finite-bit complexity, or polynomial classical
preprocessing from classical exact-real existence proofs.
