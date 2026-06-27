# Verifier Feedback: MAIN-CANDIDATE-PACKAGE-001

Task: `QBE-MAIN-CASE-HIER-COLD-001`

Run: `20260627-122318-QBE-MAIN-CASE-HIER-COLD-001-cycle01`

## Verdict

The package leaf closed.  Lean now contains the COLD-local candidate record
`mainCaseColdPartialPermCandidate`, the verified package
`mainCaseColdPartialPermVerified`, and the cost theorem
`mainCaseColdPartialPermCandidate_cost`.

## Fields

| Field | Value |
|---|---|
| `leaf` | `MAIN-CANDIDATE-PACKAGE-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `finite_matrix_ok` | `true` |
| `block_entry_ok` | `true` |
| `ancilla_cleanup_ok` | `true` |
| `normalizer_ok` | `true` |
| `unitarity_ok` | `true` at finite-permutation tier |
| `resource_score` | `(5,5,1,0)` |
| `auxiliary_qubits` | `1` |
| `gate_count` | `5` |
| `depth` | `5` |
| `oracle_calls` | `0` |
| `closed_theorem_ok` | `true` |
| `error_class` | `null` |
| `next_route` | `MAIN-EXPORT-001`: generate Qiskit/QASM3 artifacts from `mainCaseColdPartialPermVerified` and check them against the COLD finite image, clean block, normalizer, and resource tuple. |

## Lean Evidence

The package consumes:

| Role | Declaration |
|---|---|
| target metadata | `mainCaseColdQueryTarget` |
| unitary matrix | `mainCaseColdPartialPermMatrix` |
| finite-permutation proof | `mainCaseColdPartialPermImage_bijective` |
| clean-block projection proof | `mainCaseColdPartialPerm_blockProjection` |
| circuit transcript | `mainCaseColdCircuit`, `mainCaseColdSchedule` |
| circuit image bridge | `mainCaseColdCircuitImage_eq_partialPermImage` |
| resource tuple | `mainCaseColdHighLevelResource`, `mainCaseColdPartialPermCost_*` |

The package does not use the separate `mainCasePro*` arm, previous Qiskit
exports, QSVT, LCU, sparse-access, or dilation routes.
