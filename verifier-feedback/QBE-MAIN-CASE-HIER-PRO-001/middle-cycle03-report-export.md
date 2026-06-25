# Cycle 3 Report/Export Feedback

This packet supersedes stale cycle-2 bridge-open wording for report/export
planning.  It does not rewrite the old diagnostic logs.

| Field | Value |
|---|---|
| `leaf` | `MAINCASE-PRO-SEMANTIC-TIER-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` after the cycle-3 gate |
| `finite_matrix_ok` | `true` for the clean-block candidates |
| `block_entry_ok` | `true` |
| `ancilla_cleanup_ok` | `true` for clean signal selector `mainCaseProSignalIndex = 0` |
| `normalizer_ok` | `true`; alpha is `mainCaseProExactNormalizer = 1` |
| `unitarity_ok` | `true` at finite-permutation tier; rational matrix bridge is compiled |
| `resource_score` | `(4,4,1,0)` |
| `auxiliary_qubits` | `1` |
| `gate_count` | `4` |
| `depth` | `4` |
| `oracle_calls` | `0` |
| `closed_theorem_ok` | `true` for `mainCaseProCircuitVerified` at the accepted finite-permutation clean-block tier |
| `error_class` | `stale_leaf` for any remaining bridge-open or all-state equality-export route |
| `next_route` | Create the Qiskit/QASM3 export packet only after reviewer accepts `mainCaseProCircuitVerified` / `mainCaseProCircuitCandidate` as the export-facing Pro transcript certificate. |

Reader-facing blocker: export claims must not cite `mainCaseProVerified` or
`mainCaseProCandidate_cost` as the advertised Pro transcript certificate.
