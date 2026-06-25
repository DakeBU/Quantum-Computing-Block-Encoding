# Verifier Feedback: Pro Semantic Tier Cycle 3

## Active Leaf

`MAINCASE-PRO-SEMANTIC-TIER-001`

The cycle-3 verifier object is not a new matrix proof.  It selects the Lean
certificate that is allowed to feed Qiskit and QASM3 export planning.

## Accepted Certificate

Use `mainCaseProCircuitVerified` as the export-facing Pro transcript
certificate.  Its corresponding cost theorem is
`mainCaseProCircuitCandidate_cost`.

The matrix-table incumbent `mainCaseProVerified` remains compiled, but it is
not the Pro transcript certificate.  The theorem
`mainCaseProCircuitImage_candidate_mismatch_set` proves that the transcript
image and `mainCaseProCandidateImage` differ exactly on dirty inputs `8`, `9`,
`12`, and `13`.

## Retired Routes

| Route | Status | Reason |
|---|---|---|
| `mainCaseProCircuitImage_eq_candidate` | retired | refuted by `mainCaseProCircuitImage_not_pointwise_candidate` |
| `MAINCASE-PRO-ORTHO-BRIDGE-001` | retired from proof search | closed by `BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective`, `mainCaseProCandidateMatrix_isRationalOrthogonal`, and `mainCaseProCircuitMatrix_isRationalOrthogonal` |

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `MAINCASE-PRO-SEMANTIC-TIER-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `finite_matrix_ok` | `true` |
| `block_entry_ok` | `true` |
| `ancilla_cleanup_ok` | `true` |
| `normalizer_ok` | `true` |
| `unitarity_ok` | `true` |
| `resource_score` | `(4,4,1,0)` |
| `closed_theorem_ok` | `true` |
| `error_class` | `none` |
| `next_route` | Generate Qiskit and QASM3 export artifacts from `mainCaseProCircuitVerified` only. |

## Export Rejection Rule

Reject any export packet whose Lean source declaration is `mainCaseProVerified`
or whose resource proof cites only `mainCaseProCandidate_cost`.
