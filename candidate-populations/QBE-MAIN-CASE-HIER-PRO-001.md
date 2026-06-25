# Candidate Population: QBE-MAIN-CASE-HIER-PRO-001

All candidates target the same fixed operator `mainCaseProTarget` with
normalizer `mainCaseProExactNormalizer = 1`, exact error
`mainCaseProExactError = 0`, and clean projector `mainCaseProBlockProjection`.

Only Lean-certified candidates may enter the certified population.  External
Pro ideas remain in the insight pool until task-local Lean declarations prove
the block-entry, finite reversibility/unitarity tier, and resource claims.

## Certified And Active Candidates

| Candidate id | Family | Lean artifacts | Score | Status | Notes |
|---|---|---|---|---|---|
| `MAINCASE-PRO-PERM-001` | partial permutation / matrix unit tensor identity | `mainCaseProCandidateImage`, `mainCaseProCandidateImage_permutation_certificate`, `mainCaseProCandidate_cleanEntry`, `mainCaseProExactCleanBlock_correct`, `mainCaseProCandidate_blockProjection`, `mainCaseProCandidate_cost`, `mainCaseProCandidate_uses_matrix_table_metadata`, `mainCaseProVerified` | `(1, 1, 1, 1)` unresolved matrix-table metadata | certified as a matrix-table finite-permutation clean-block incumbent; not export-facing for the Pro transcript | Pro-isolated task-local names; no `OptimalControl` or cold-start certificates imported. The advertised transcript is not this full image; see `mainCaseProCircuitImage_candidate_mismatch_set`. Do not cite this row for Qiskit/QASM3 export unless `MAINCASE-PRO-PERM-CIRCUIT-ALIGN-001` supplies a separate circuit-realization and resource contract. |
| `MAINCASE-PRO-CIRCUIT-001` | Pro four-gate transcript `CCX012; CX21; CX20; X2` | `mainCaseProCircuitImage`, `mainCaseProCircuitImage_candidate_mismatch_set`, `mainCaseProCircuitImage_permutation_certificate`, `mainCaseProCircuitMatrix_isRationalOrthogonal`, `mainCaseProCircuit_blockProjection`, `mainCaseProCircuitCandidate_cost`, `mainCaseProCircuitVerified` | `(4, 4, 1, 0)` | accepted export-facing semantic-tier candidate | This is the aligned Pro transcript candidate. Its circuit field, schedule, resource tuple, matrix image, block theorem, and rational-orthogonality instance are task-local Lean declarations. |

## Insight Pool

| Idea | Route | Status | Reason to keep |
|---|---|---|---|
| Pro equality-flag transfer | partial permutation with final signal flip | split into `MAINCASE-PRO-PERM-001` and `MAINCASE-PRO-CIRCUIT-001` | both certified at finite-permutation clean-block tier |
| Pro four-gate transcript image | logical gate transcript `CCX012; CX21; CX20; X2` | promoted to `MAINCASE-PRO-CIRCUIT-001` after Lean mismatch and clean-block certificates compiled | dirty columns `8`, `9`, `12`, and `13` explain why it is not identical to `mainCaseProCandidateImage` |
| one-sparse support map | `BE.Sparse.OneSparsePermutation` | archived alternative | same support pattern, but unnecessary amplitude-oracle machinery for this matrix-unit target |
| one-term LCU | `BE.LCU.PrepareSelect` | archived alternative | normalizes to the same matrix but adds coefficient/preparation obligations |
| dilation fallback | `BE.Contraction.SVDDilation` | archived alternative | useful only if exact partial permutation is rejected |
| QSVT consumer | `BE.QSVT.ConsumerContract` | downstream only | requires an input block encoding first |

## Selection Notes

The matrix-table incumbent and the Pro transcript no longer share the same
resource layer: `MAINCASE-PRO-PERM-001` carries one unresolved oracle call,
while `MAINCASE-PRO-CIRCUIT-001` has the logical-library score `(4,4,1,0)`.
For executable exports, use
`MAINCASE-PRO-CIRCUIT-001` because its circuit field and unitary image are
aligned by task-local declarations.  `MAINCASE-PRO-PERM-001` remains useful as
a matrix-table clean-block incumbent and proof comparison point, but its
compiled candidate record must not be used as the Pro transcript certificate.

Cycle-2 bridge closure: `MAINCASE-PRO-ORTHO-BRIDGE-001` is closed by
`BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective` and the
task-local instances for both Pro-arm matrices.  It did not mutate either
candidate.

## Remaining Candidate Work

- Keep the accepted semantic-tier object for export as
  `mainCaseProCircuitVerified`.
- Create and check the post-Lean export implementation for
  `qiskit` and `qasm3` under
  `executable-exports/QBE-MAIN-CASE-HIER-PRO-001/`.
- Do not plot this candidate as a hardware-level achieved solution until the
  export packet and primitive-gate semantics are checked.
