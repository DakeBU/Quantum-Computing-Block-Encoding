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
| `MAINCASE-PRO-PERM-001` | partial permutation / matrix unit tensor identity | `mainCaseProCandidateImage`, `mainCaseProCandidateImage_permutation_certificate`, `mainCaseProCandidate_cleanEntry`, `mainCaseProExactCleanBlock_correct`, `mainCaseProCandidate_blockProjection`, `mainCaseProCandidate_cost`, `mainCaseProVerified` | `(4, 4, 1, 0)` | certified at finite-permutation clean-block tier; circuit-image alignment and rational-orthogonality bridge active | Pro-isolated task-local names; no `OptimalControl` or cold-start certificates imported. Do not treat `mainCaseProCircuit` as implementing this image until `MAINCASE-PRO-CIRCUIT-IMAGE-001` closes. |

## Insight Pool

| Idea | Route | Status | Reason to keep |
|---|---|---|---|
| Pro equality-flag transfer | partial permutation with final signal flip | promoted to `MAINCASE-PRO-PERM-001` after task-local Lean block and permutation certificates compiled | current incumbent |
| Pro four-gate transcript image | logical gate transcript `CCX012; CX21; CX20; X2` | active validation target | needed to connect the resource tuple and circuit field to the finite image candidate; old route memory suggests dirty columns `8`, `9`, `12`, and `13` must be audited |
| one-sparse support map | `BE.Sparse.OneSparsePermutation` | archived alternative | same support pattern, but unnecessary amplitude-oracle machinery for this matrix-unit target |
| one-term LCU | `BE.LCU.PrepareSelect` | archived alternative | normalizes to the same matrix but adds coefficient/preparation obligations |
| dilation fallback | `BE.Contraction.SVDDilation` | archived alternative | useful only if exact partial permutation is rejected |
| QSVT consumer | `BE.QSVT.ConsumerContract` | downstream only | requires an input block encoding first |

## Selection Notes

The current incumbent is selected by source/operator faithfulness first and
then by the logical-library score.  The score is not a proof of exportability
or hardware optimality.  It records the high-level transcript
`CCX; CX; CX; X` as `(gateCount=4, depth=4, auxiliaryQubits=1, oracleCalls=0)`.

## Remaining Candidate Work

- Close `MAINCASE-PRO-CIRCUIT-IMAGE-001` before using the four-gate transcript
  as the implementation of `mainCaseProCandidateImage` or as an export source.
- Then close `MAINCASE-PRO-ORTHO-BRIDGE-001` or explicitly accept the
  finite-permutation semantic tier as the advertised tier for this cycle.
- After reviewer acceptance, create the post-Lean export packet for
  `qiskit` and `qasm3` under
  `executable-exports/QBE-MAIN-CASE-HIER-PRO-001/`.
- Do not plot this candidate as a hardware-level achieved solution until the
  export packet and primitive-gate semantics are checked.
