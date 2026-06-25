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
| resource score is explicit | `mainCaseProHighLevelSeedCost_*`, `mainCaseProCandidate_cost`, `mainCaseProCandidate_uses_matrix_table_metadata`, `mainCaseProCircuitCandidate_cost` | proved; matrix-table incumbent has unresolved executable metadata, Pro transcript has `(4,4,1,0)` |
| Pro four-gate transcript realizes the advertised image/resource layer | `mainCaseProCircuitImage_candidate_mismatch_set`, `mainCaseProCircuitVerified`, `mainCaseProCircuitCandidate_cost` | proved as candidate split; equality with `mainCaseProCandidateImage` is false |
| full matrix rational-orthogonality bridge | `BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective`, `mainCaseProCandidateMatrix_isRationalOrthogonal`, `mainCaseProCircuitMatrix_isRationalOrthogonal`, `mainCaseProRationalOrthogonalBridgeObligation` | proved |
| accepted semantic-tier object for export | `mainCaseProCircuitVerified`, `mainCaseProCircuitCandidate_cost` | named; `mainCaseProVerified` is matrix-table only with `mainCaseProMatrixTableResource` |
| post-Lean Qiskit/QASM3 export | `executable-exports/QBE-MAIN-CASE-HIER-PRO-001/export-plan.md` | export plan ready; executable implementation pending |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `MAINCASE-PRO-SOURCE-001` | Fixed operator, layout, projector, alpha, and epsilon. | task packet | middle | `mainCaseProTarget`, `mainCaseProBlockProjection` | conversion window | `python3 tools/qbe.py check` | proved |
| `MAINCASE-PRO-PERM-IMAGE-001` | Task-local finite image and permutation matrix. | `MAINCASE-PRO-SOURCE-001` | middle/lower 2 | `mainCaseProCandidateImage`, `mainCaseProCandidateMatrix` | conversion window | `python3 tools/qbe.py check` | proved |
| `MAINCASE-PRO-PERM-UNITARY-001` | Bijection certificate for the image. | `MAINCASE-PRO-PERM-IMAGE-001` | middle/lower 2 | `mainCaseProCandidateImage_permutation_certificate` | conversion window | `python3 tools/qbe.py check` | proved finite-permutation tier |
| `MAINCASE-PRO-BLOCK-001` | Clean block equals `mainCaseProTarget`. | `MAINCASE-PRO-PERM-IMAGE-001`, `MAINCASE-PRO-PERM-UNITARY-001` | middle/lower 2 | `mainCaseProExactCleanBlock_correct`, `mainCaseProCandidate_blockProjection` | conversion window | `python3 tools/qbe.py check` | proved |
| `MAINCASE-PRO-RESOURCE-001` | Score tuple `(4,4,1,0)` for the Pro transcript; matrix-table incumbent carries one unresolved oracle-call placeholder. | `MAINCASE-PRO-BLOCK-001` | middle | `mainCaseProHighLevelSeedCost_*`, `mainCaseProCandidate_cost`, `mainCaseProCandidate_uses_matrix_table_metadata`, `mainCaseProCircuitCandidate_cost` | candidate population | `python3 tools/qbe.py check` | proved |
| `MAINCASE-PRO-CIRCUIT-IMAGE-001` | Prove the advertised Pro transcript `CCX012; CX21; CX20; X2` realizes the same image as the candidate, or record a corrected gate-derived image/candidate split. | `MAINCASE-PRO-PERM-IMAGE-001`, `MAINCASE-PRO-RESOURCE-001`, Pro packet | middle/lower 2/lower 3 | `mainCaseProCircuitImage_candidate_mismatch_set`, `mainCaseProCircuitVerified` | conversion window plus verifier feedback | `python3 tools/qbe.py check` | proved split |
| `MAINCASE-PRO-ORTHO-BRIDGE-001` | Promote a bijective `BlockEncodingClassics.permMatrix` to the project-local rational Gram condition: column Gram from injectivity and row Gram from surjectivity. | `MAINCASE-PRO-PERM-UNITARY-001`, `MAINCASE-PRO-CIRCUIT-IMAGE-001` | lower 1/lower 2/lower 3 | `BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective`, `mainCaseProCandidateMatrix_isRationalOrthogonal`, `mainCaseProCircuitMatrix_isRationalOrthogonal` | conversion window plus verifier feedback | `python3 tools/qbe.py check` and `lake build && lake build Tests` | proved |
| `MAINCASE-PRO-SEMANTIC-TIER-001` | Select the export-facing Lean certificate whose circuit, schedule, unitary image, block theorem, and resource score refer to the same Pro transcript. | `MAINCASE-PRO-CIRCUIT-IMAGE-001`, `MAINCASE-PRO-ORTHO-BRIDGE-001`, `MAINCASE-PRO-RESOURCE-001` | middle/reviewer/lower 3 | `mainCaseProCircuitVerified`, `mainCaseProCircuitCandidate_cost` | `proof-attempts/QBE-MAIN-CASE-HIER-PRO-001-middle-source-contract-cycle03.md` | `python3 tools/qbe.py check`; `lake build && lake build Tests` | accepted semantic-tier gate; no new Lean theorem required |
| `MAINCASE-PRO-EXPORT-001` | Prepare Qiskit and QASM3 artifacts using only the accepted Pro transcript certificate. | `MAINCASE-PRO-SEMANTIC-TIER-001` | export worker | no executable declaration yet | `executable-exports/QBE-MAIN-CASE-HIER-PRO-001/export-plan.md` | export checker plus project gates | active export implementation pending |

## Guardrails

- Do not change `mainCaseProTarget`, `mainCaseProSignalIndex`, or
  `mainCaseProExactNormalizer` to make a candidate pass.
- Do not import `OptimalControl.proEqTransfer...` or `coldE1...` declarations as
  certificates for this task.
- Do not start Qiskit or QASM3 export until the accepted Lean semantic tier is
  named in the export packet.
- Treat LCU, sparse-access, dilation, and QSVT routes as archived alternatives
  unless the partial-permutation route is falsified.

## Active Source Contract

The current middle-facing object is the Pro transcript
`CCX012; CX21; CX20; X2` under the full wire map
`S=0`, `tau=1`, `T=2`, `signal=3`.  Lower cycle 1 proved the all-state mismatch
set against `mainCaseProCandidateImage`: the transcript differs exactly on
dirty inputs `8`, `9`, `12`, and `13`.  The fixed target, normalizer, and
compiled clean-block theorem were unchanged.

## Cycle-3 Semantic-Tier Leaf

`MAINCASE-PRO-ORTHO-BRIDGE-001` is closed by a shared `permMatrix`
rational-orthogonality bridge in `BlockEncodingClassics.lean` and task-local
instances for both Pro-arm matrices.  The active leaf is now
`MAINCASE-PRO-SEMANTIC-TIER-001`: use `mainCaseProCircuitVerified` and
`mainCaseProCircuitCandidate_cost` as the export-facing Pro transcript
certificate.  Do not retry `mainCaseProCircuitImage_eq_candidate`; it is
refuted by `mainCaseProCircuitImage_not_pointwise_candidate`.  Do not cite
`mainCaseProVerified` or `mainCaseProCandidate_cost` as the Pro transcript
export certificate.  `mainCaseProCandidate` now uses
`mainCaseProMatrixTableCircuit`, `mainCaseProMatrixTableSchedule`, and
`mainCaseProMatrixTableResource`, with cost `(1,1,1,1)` marking an unresolved
matrix-table realization.

## Lower Cycle-2 Ortho-Bridge Refinement

Lower proof architect packet:
`proof-attempts/QBE-MAIN-CASE-HIER-PRO-001-ortho-bridge-lower-architect-cycle02.md`.

The local theorem to translate is the rational Gram bridge for a bijective
permutation matrix:

$$
U_{r,c} =
\begin{cases}
1, & r = p(c),\\
0, & r \ne p(c),
\end{cases}
$$

where `p : Fin n -> Fin n` is injective and surjective.  The column Gram proof
uses injectivity to separate distinct columns.  The row Gram proof uses
surjectivity for row-diagonal existence and injectivity for uniqueness.

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `ORTHO-DEFS-001` | Promote shared rational Gram definitions. | `Matrix`, `Rat`, `List.finRange` | lower 2/refiner | `BlockEncodingClassics.columnInner`, `BlockEncodingClassics.rowInner`, `BlockEncodingClassics.IsRationalOrthogonal` | lower architect packet | `python3 tools/qbe.py check` | proved |
| `ORTHO-BRIDGE-001` | Prove bijective `permMatrix` has identity row and column Gram matrices. | `ORTHO-DEFS-001`, finite fold lemmas, `BlockEncodingClassics.permMatrix` | lower 2 | `BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective` | lower architect packet | `python3 tools/qbe.py check` | proved |
| `MAINCASE-PRO-CIRCUIT-ORTHO-001` | Instantiate the bridge for the gate-derived Pro transcript candidate. | `ORTHO-BRIDGE-001`, `mainCaseProCircuitImage_permutation_certificate` | lower 2 | `mainCaseProCircuitMatrix_isRationalOrthogonal` | lower architect packet | `python3 tools/qbe.py check`; `lake build && lake build Tests` | proved |

The fallback direct finite proof route was not needed.  The shared theorem is
closed and `mainCaseProRationalOrthogonalBridgeObligation.proved = true` is
backed by the named declarations above.

## Cycle-2 Verifier Diagnostic

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `MAINCASE-PRO-ORTHO-BRIDGE-001` | Finite row/column Gram necessary condition for the rational-orthogonality bridge. | `MAINCASE-PRO-PERM-UNITARY-001`, `MAINCASE-PRO-CIRCUIT-IMAGE-001`, compiled block/resource leaves | lower 3 | no new Lean declaration; `maincase_pro_ortho_bridge_diag.py` diagnostic only | `verifier-feedback/QBE-MAIN-CASE-HIER-PRO-001/maincase-pro-ortho-bridge-cycle02.md` | `python3 tools/qbe.py check` and `lake build && lake build Tests` | finite diagnostic passed; symbolic bridge now closed in Lean |
