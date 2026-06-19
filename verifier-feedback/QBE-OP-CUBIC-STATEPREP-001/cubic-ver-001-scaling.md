# Verifier Feedback: CUBIC-VER-001 Dense Scaling Diagnostic

Task: `QBE-OP-CUBIC-STATEPREP-001`
Leaf: `CUBIC-VER-001`
Generated from: `reports/cubic-stateprep/latest.md`,
`reports/cubic-stateprep/latest.csv`, and
`reports/cubic-stateprep/latest.json`.  The same-task external executable
comparison is recorded in
`reports/cubic-stateprep/external_comparison.md`.

## Scope

This packet records necessary-condition diagnostics for dense
statevector/unitary verification against the symbolic ABEIS route.  It does
not certify a block encoding and does not promote any candidate.

The checked instances are `n = 4, 8, 12, 16, 20`, with `n = 1, 2` retained as
compiled exact norm fixed-instance executable checks matching `cubicNormSq_n1` and
`cubicNormSq_n2`.

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `CUBIC-VER-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `null` |
| `finite_matrix_ok` | `true` |
| `block_entry_ok` | `null` |
| `ancilla_cleanup_ok` | `null` |
| `normalizer_ok` | `false` |
| `unitarity_ok` | `null` |
| `resource_score` | `dense vector entries: 16, 256, 4096, 65536, 1048576; dense one-aux unitary memory: 16 KiB, 4 MiB, 1 GiB, 256 GiB, 64 TiB` |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `Use finite Qiskit/QuantumKatas checks only after a concrete small-n candidate exists.  Keep lower Lean time on CUBIC-NORM-001, CUBIC-ALPHA-001, and then the symbolic approximate candidate family.` |

## Diagnostic Rows

| n | Dense vector entries | Dense one-aux unitary memory | Role |
|---:|---:|---:|---|
| 4 | 16 | 16 KiB | small finite check |
| 8 | 256 | 4 MiB | small finite check |
| 12 | 4096 | 1 GiB | upper edge of practical dense unitary materialization |
| 16 | 65536 | 256 GiB | dense unitary verifier is not a routine inner-loop check |
| 20 | 1048576 | 64 TiB | dense unitary verifier is a scaling witness only |

## Interpretation

Dense executable verification remains useful for small instances and for
catching target-semantics mistakes.  It is not a scalable certificate for the
family theorem because the dense vector has `2^n` entries and dense unitary
materialization grows quadratically in the full Hilbert-space dimension.

The next Lean-relevant route is the symbolic norm/normalizer bridge
`CUBIC-NORM-001`; these diagnostics only justify keeping dense methods as a
finite executable baseline.

## External Executable Verifier Run

We also ran the cubic target through locally available external executable
routes.  The finite dense route constructs a one-auxiliary-qubit dense unitary
whose clean block is exactly `O_n / ||v_n||` for the selected small `n`.

| Route | Same cubic BE task? | Result | Scope |
|---|---|---|---|
| NumPy dense completion | yes | passed for `n = 1..6` | finite matrix fixed-instance executable check only |
| Qiskit `Operator` | yes | passed for `n = 1..4` | finite dense unitary materialization |
| Qiskit-QuantumKatas evaluator | yes | passed for `n = 3` | finite kata-style assertion |
| QASM-Eval | no direct route | parser route available, not same-task BE | typed QASM syntax/distribution/timeline feedback, not this BE clean-block verifier |
| QUASAR | no direct route | not-runnable locally | harness idea comparison only |
| AI-Mandel | no direct route | compile check passed | idea/tool loop comparison only |

The plot `reports/cubic-stateprep/external_comparison_scaling.png` shows the
local finite-runtime and dense-memory signal.  This is useful evidence that
executable circuit verifiers can validate small instances, but the dense
matrix route is not a scalable symbolic certificate for arbitrary `n`.
