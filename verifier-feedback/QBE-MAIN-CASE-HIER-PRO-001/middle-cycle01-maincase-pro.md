# Middle Verifier Feedback: QBE-MAIN-CASE-HIER-PRO-001 Cycle 1

## Leaf

`MAINCASE-PRO-BLOCK-001`

## Result

The task-local Pro candidate now compiles in `QuantumBlockEncoding/MainCase.lean`.
The clean block theorem is `mainCaseProCandidate_blockProjection`, and the
partial-permutation clean-block package is
`mainCaseProExactCleanBlockCertificate` with theorem
`mainCaseProExactCleanBlock_correct`.

The finite permutation certificate is
`mainCaseProCandidateImage_permutation_certificate`.  The high-level resource
tuple is certified by `mainCaseProHighLevelSeedCost_*` and
`mainCaseProCandidate_cost`.

## Typed Status

| Field | Value |
|---|---|
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `finite_matrix_ok` | `true` |
| `block_entry_ok` | `true` |
| `ancilla_cleanup_ok` | `true` |
| `normalizer_ok` | `true` |
| `unitarity_ok` | `false` for the full rational-orthogonality bridge |
| `resource_score` | `(4,4,1,0)` |
| `error_class` | `symbolic_bridge_gap` |

## Next Route

Prove `MAINCASE-PRO-ORTHO-BRIDGE-001`: a shared theorem that a bijective
finite image induces a rational orthogonal `BlockEncodingClassics.permMatrix`,
or a task-local instance for `mainCaseProCandidateMatrix` followed by a shared
generalization.
