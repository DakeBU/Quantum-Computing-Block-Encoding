# Verifier Feedback: Lower Candidate Cost

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Updated: 2026-06-19 21:08 JST

| Field | Value |
|---|---|
| `leaf` | `DIAG-CANDIDATE-SCORE-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true`, `python3 tools/qbe.py check` passed |
| `finite_matrix_ok` | `null`, not rerun by this lower Lean pass |
| `block_entry_ok` | `null`, this pass only closed the candidate score theorem |
| `ancilla_cleanup_ok` | `null`, primitive clean-block extraction remains part of the open contract |
| `normalizer_ok` | `true` |
| `unitarity_ok` | `null`, unitarity remains an explicit primitive contract field |
| `resource_score` | `(1, 1, 1, 1)` |
| `auxiliary_qubits` | `1` |
| `gate_count` | `1` |
| `depth` | `1` |
| `oracle_calls` | `1` |
| `closed_theorem_ok` | `true`, `CubicDiagonalOracle.primitiveAmplitudeOracleCandidate_costTuple_eq` |
| `error_class` | `external_contract_gap` |
| `next_route` | `DIAG-PRIM-WITNESS-001: provide or explicitly accept h : primitiveAmplitudeOracleSemanticContract n; otherwise route to expanded arithmetic.` |

This lower pass did not try to prove the opaque primitive semantic witness.
It only connected the already-defined primitive candidate record to the
advertised oracle-label score.
