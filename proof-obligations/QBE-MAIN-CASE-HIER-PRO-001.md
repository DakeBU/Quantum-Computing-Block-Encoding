# Proof Obligations: QBE-MAIN-CASE-HIER-PRO-001

## Fixed Target

The target operator is

$$
E_1 = |0><1|_T \otimes |0><1|_{\tau} \otimes I_S
$$

on one-bit registers ordered as `(T, tau, S)`.  The normalizer is `1`, the
exact error is `0`, and the clean block selector is `mainCaseProSignalIndex = 0`.

## Status Ledger

| Obligation | Lean declaration or artifact | Status |
|---|---|---|
| matrix/operator target `A` is defined | `mainCaseProTarget` | proved target-side |
| operator metadata is explicit | `mainCaseProQueryTarget` | compiled |
| clean block predicate is stated | `mainCaseProBlockProjection` | compiled |
| candidate unitary/permutation family is defined | `mainCaseProCandidateImage`, `mainCaseProCandidateMatrix` | compiled |
| candidate image is bijective | `mainCaseProCandidateImage_permutation_certificate` | proved finite-permutation tier |
| clean-entry theorem is proved | `mainCaseProCandidate_cleanEntry` | proved |
| exact clean-block package is built | `mainCaseProExactCleanBlockCertificate`, `mainCaseProExactCleanBlock_correct` | proved |
| signal-block theorem is proved | `mainCaseProCandidate_blockProjection` | proved |
| normalizer `alpha = 1` is explicit | `mainCaseProExactNormalizer`, `mainCaseProQueryTarget_normalizer` | proved |
| auxiliary qubit count `a = 1` is explicit | `mainCaseProSourceLayout`, `mainCaseProSourceLayout_auxiliaryQubits` | proved |
| resource score is explicit | `mainCaseProHighLevelSeedCost_*`, `mainCaseProCandidate_cost` | proved at logical-library tier |
| Pro four-gate transcript realizes the advertised image/resource layer | no task-local theorem yet; proposed leaf `MAINCASE-PRO-CIRCUIT-IMAGE-001` | active contract-alignment obligation |
| full matrix rational-orthogonality bridge | `mainCaseProRationalOrthogonalBridgeObligation` | active obligation |
| post-Lean Qiskit/QASM3 export | no artifact yet | blocked on accepted Lean semantic tier |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `MAINCASE-PRO-SOURCE-001` | Fixed operator, layout, projector, alpha, and epsilon. | task packet | middle | `mainCaseProTarget`, `mainCaseProBlockProjection` | conversion window | `python3 tools/qbe.py check` | proved |
| `MAINCASE-PRO-PERM-IMAGE-001` | Task-local finite image and permutation matrix. | `MAINCASE-PRO-SOURCE-001` | middle/lower 2 | `mainCaseProCandidateImage`, `mainCaseProCandidateMatrix` | conversion window | `python3 tools/qbe.py check` | proved |
| `MAINCASE-PRO-PERM-UNITARY-001` | Bijection certificate for the image. | `MAINCASE-PRO-PERM-IMAGE-001` | middle/lower 2 | `mainCaseProCandidateImage_permutation_certificate` | conversion window | `python3 tools/qbe.py check` | proved finite-permutation tier |
| `MAINCASE-PRO-BLOCK-001` | Clean block equals `mainCaseProTarget`. | `MAINCASE-PRO-PERM-IMAGE-001`, `MAINCASE-PRO-PERM-UNITARY-001` | middle/lower 2 | `mainCaseProExactCleanBlock_correct`, `mainCaseProCandidate_blockProjection` | conversion window | `python3 tools/qbe.py check` | proved |
| `MAINCASE-PRO-RESOURCE-001` | Score tuple `(4,4,1,0)`. | `MAINCASE-PRO-BLOCK-001` | middle | `mainCaseProHighLevelSeedCost_*`, `mainCaseProCandidate_cost` | candidate population | `python3 tools/qbe.py check` | proved |
| `MAINCASE-PRO-CIRCUIT-IMAGE-001` | Prove the advertised Pro transcript `CCX012; CX21; CX20; X2` realizes the same image as the candidate, or record a corrected gate-derived image/candidate split. | `MAINCASE-PRO-PERM-IMAGE-001`, `MAINCASE-PRO-RESOURCE-001`, Pro packet | middle/lower 2/lower 3 | none yet | conversion window plus verifier feedback | `python3 tools/qbe.py check` | active leaf |
| `MAINCASE-PRO-ORTHO-BRIDGE-001` | Shared rational-orthogonality theorem for permutation matrices. | `MAINCASE-PRO-PERM-UNITARY-001` | lower 2/refiner | `mainCaseProRationalOrthogonalBridgeObligation` | verifier feedback | `python3 tools/qbe.py check` | queued after circuit-image alignment |

## Guardrails

- Do not change `mainCaseProTarget`, `mainCaseProSignalIndex`, or
  `mainCaseProExactNormalizer` to make a candidate pass.
- Do not import `OptimalControl.proEqTransfer...` or `coldE1...` declarations as
  certificates for this task.
- Do not start Qiskit or QASM3 export until the accepted Lean semantic tier is
  named in the export packet.
- Treat LCU, sparse-access, dilation, and QSVT routes as archived alternatives
  unless the partial-permutation route is falsified.

## Next Lean Leaf

The next useful implementation leaf is `MAINCASE-PRO-CIRCUIT-IMAGE-001`.
Lower 3 should first write a finite diagnostic comparing the current
`mainCaseProCandidateImage` with the image induced by the Pro transcript on all
16 states, with special attention to dirty columns `8`, `9`, `12`, and `13`.
Lower 2 should then either prove a task-local circuit-to-image theorem or split
the record into a finite-permutation clean-block candidate and a separate
gate-derived candidate.  Do not spend another lower-2 attempt on
`MAINCASE-PRO-ORTHO-BRIDGE-001` until the advertised circuit/resource layer is
aligned or explicitly demoted to a separate semantic tier.
