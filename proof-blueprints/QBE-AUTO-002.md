# Proof Blueprint: QBE-AUTO-002

Task id: `QBE-AUTO-002`
Title: Concrete Circuit Matrix Semantics Backend
Mode: `faithfulPaper`
Updated: `2026-06-10 01:35:20`
Blueprint stage: `Stage 2 DAG proof discharge, with faithful transcript checks still active`

This is QBE's compact system-of-record snapshot for long-horizon Lean proof
automation.  It follows a similar control pattern to LeanMarathon's evolving
blueprint, but QBE keeps the human-facing proof map split across Lean,
Markdown, LaTeX, proof obligations, and cited-results memory because
block-encoding papers require source notation, register conventions, and
oracle contracts to stay explicit.

## Current Directive

```text
## Current Run Directive: 2026-06-10 Branch-Sum Leaf Closure And Article-Facing Audit

This directive supersedes the 2026-06-09 branch-sum frontier.  The next
active-time batch should spend proof-search effort only on the remaining local
finite projection/backend branch-sum leaf for the first case study.  Do not
restart broad oracle formalization or project-wide refactoring.

Active Lean target:

```lean
oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_n3
```

Equivalent target, if it is easier through the compiled bridge:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

using:

```lean
oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3
```

Current compiled context:

| Declaration | Status |
|---|---|
| `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` | compiled theorem-facing transcript guard with both `H_W` sides and explicit `U_indic^dagger` role |
| `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | compiled bridge justifying that the dagger slot can use the indicator matrix while keeping the paper circuit role explicit |
| `oneTermRobinGamma3BoundarySourcePreparedCleanEntryEval_eq_backendFold_n3` | compiled safe alias for the prepared clean-entry backend fold route |
| `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3` | compiled equivalence between the branch-sum leaf and the backend-expansion formulation |

Lower-agent split:

| Lower profile | Required behavior |
|---|---|
| lower 1: natural-language proof architect | Write a narrow proof-DAG addendum for the branch-sum leaf only.  It should say which terms survive, which vanish, which existing Lean declarations justify each step, and whether each ingredient is GHL-internal, cited-contract, or QBE-local matrix semantics. |
| lower 2: Lean implementation worker | Edit only `QuantumBlockEncoding/RobinMatrix.lean`.  Prove the branch-sum leaf or one strictly smaller lemma that feeds it directly.  Do not change oracle contracts, theorem hypotheses, normalizers, or the paper circuit. |

Middle-agent duties for this batch:

1. Keep the conversion window and proof-obligation ledger synchronized with the
   branch-sum proof-DAG.  Retire stale lower targets explicitly.
2. Generate the Chinese human audit page at:

   ```text
   paper-notes/GHL2025/markdown/cycle-summaries/latest.md
   ```

   and archive it under:

   ```text
   paper-notes/GHL2025/markdown/cycle-summaries/<run-id>.md
   ```

   The Chinese audit page may mention local TeX source line ranges because it
   is an internal human-control artifact.
3. Update the project article bridge after the batch.  The generated status
   must be mirrored into:

   ```text
   ../Auto_Proof_Papers/ABEIS/appendix/generated_cycle_status.tex
   ```

   and included by the ABEIS `main.tex`.  If this batch closes a stable theorem
   or changes a stable system lesson, update only the relevant included report
   section, such as `main/ghl_case_study.tex`, `main/evidence.tex`, or
   `appendix/ghl_correspondence.tex`.
4. The public ABEIS report must be readable by the original paper authors and
   by non-agent-system readers.  Use citations, theorem/equation/figure names,
   and prose descriptions.  Do not write local source line anchors such as
   `main.tex:1098-1164` in the public report or its generated appendix.

Reviewer checklist:

- Reject any cycle that changes the target theorem, adds assumptions, changes
  the normalizer, or treats a cited oracle primitive as proved without a named
  Lean theorem and source/citation row.
- Reject any cycle that works on raw symbolic `Coeff` matrix equality as the
  main route instead of the `Coeff.evalWith`/branch-sum semantic route.
- Reject any claim that the first-case-study one-term block-encoding theorem is
  complete while the theorem-facing root or any corresponding `sorry` remains.
- Confirm that `python3 tools/qbe.py check`, `lake build`, and
  `lake build Tests` pass after Lean edits.
- Confirm that the Chinese summary path above and the ABEIS generated appendix
  are updated.  The Chinese summary may cite local TeX line ranges; the public
  article must not.

Success for this 6h active-time batch means one of:

1. the branch-sum leaf is proved and the root proof-DAG frontier advances to
   the next named dependency; or
2. a strictly smaller compiled lemma is produced, with a proof-DAG addendum
   showing exactly how it feeds the branch-sum leaf in the next cycle.

Do not spend lower-agent time on prose polish.  Article updates are a
middle/reviewer end-of-cycle synchronization task and must only report what the
Lean gates, proof notes, source anchors, and explicit obligations support.
```

## Dynamic Leaf Queue

These are the current local proof or repair candidates.  Lower agents should
work on one item at a time; if an item is stale, upper/middle must retire it
before spending more proof-search tokens.

| Leaf | Status |
|---|---|
| Latest handoff indicates at least one assigned lower target was already compiled; upper/middle should retire stale directives before more proof search. | stale-check |
| 1. Keep the conversion window and proof-obligation ledger synchronized with the branch-sum proof-DAG. Retire stale lower targets explicitly. | candidate |
| 2. Generate the Chinese human audit page at: | candidate |
| 3. Update the project article bridge after the batch. The generated status must be mirrored into: | candidate |
| 4. The public ABEIS report must be readable by the original paper authors and by non-agent-system readers. Use citations, theorem/equation/figure names, and prose descriptions. Do not write local source line anchors such as `main.tex:1098-1164` in the publi... | candidate |
| - Reject any cycle that changes the target theorem, adds assumptions, changes the normalizer, or treats a cited oracle primitive as proved without a named Lean theorem and source/citation row. | candidate |
| - Reject any cycle that works on raw symbolic `Coeff` matrix equality as the main route instead of the `Coeff.evalWith`/branch-sum semantic route. | candidate |
| - Reject any claim that the first-case-study one-term block-encoding theorem is complete while the theorem-facing root or any corresponding `sorry` remains. | candidate |
| - Confirm that `python3 tools/qbe.py check`, `lake build`, and `lake build Tests` pass after Lean edits. | candidate |
| - Confirm that the Chinese summary path above and the ABEIS generated appendix are updated. The Chinese summary may cite local TeX line ranges; the public article must not. | candidate |
| 1. the branch-sum leaf is proved and the root proof-DAG frontier advances to the next named dependency; or | candidate |
| 2. a strictly smaller compiled lemma is produced, with a proof-DAG addendum showing exactly how it feeds the branch-sum leaf in the next cycle. | candidate |

## Open Obligation Signals

```text
# Proof Obligations: QBE-AUTO-002 — Circuit Matrix Semantics Backend
This ledger tracks the unproved semantic claims introduced by the circuit
the remaining five gate unitarity claims remain explicit proof obligations.
| O_DT^S | `GHL2025.oneTermRobinGate_O_DT_S` | Lemma 3, Eq. (20), arXiv:2506.20478 | active controlled-rotation skeleton; coefficient-normalizer relation and unitarity unproved |
| Ry_boundary | `GHL2025.oneTermRobinGate_Ry_boundary` | Fig. 1-term Robin and Eq. angles for Ry, arXiv:2506.20478 | active symbolic controlled rotation matrix; angle-normalizer contract and unitarity unproved |
| O_D^BS | `GHL2025.oneTermRobinGate_O_D_BS` | Lemma 1, arXiv:2506.20478 | active global sparse-slot paper-image matrix skeleton; `bandedSparseAccessPaperGlobalSlotSource` now records the faithful clean source predicate as padded clean input plus sparse index $s<\kappa$; finite-image, entry-safety, finite-range cleanup wrapper, global-source image injectivity, post-SWAP unique preimage, and record-level inverse bridge proved under explicit hypotheses; `oneTermRobinGate_O_D_BS_globalSparseBoundaryNoCollision_n3` proves the corrected active image separates the old $n=3$ boundary columns, while `oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3` is retained as a rejected row-dependent-model regression; forward correctness, semantic cleanup, obligation-record flag promotion, and unitarity unproved |
| O_f | `GHL2025.oneTermRobinGate_O_f` | Theorem `Amplitude-oracle for piece-wise polynomial function`, Eq. `coordinate oracle`, and Fig. 1-term Robin, arXiv:2506.20478 | active paper-image matrix skeleton with clean $m_f$ branch wired; orthogonal completion, amplitude relation, normalizer bound, and unitarity unproved |
| (O_D^BS)^dagger | `GHL2025.oneTermRobinGate_O_D_BS_dagger` | Fig. 1-term Robin caption, arXiv:2506.20478 | active transpose-style paper-image matrix; conditional entry and register-cleanup witness available for the global-source candidate, and `bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge` identifies that candidate among active global-source preimages; semantic cleanup and unitarity unproved |
Therefore the active obligation is not to invent an unused-branch image for a
| Obligation | Declaration | Status |
| Obligation | Declaration | Status |
| Block projection extracts correct submatrix | `oneTermRobinBlockExtractionTarget.blockProjection` | unproved |
| Extracted block = targetMatrix / normalizer | `oneTermRobinBlockExtractionTarget.blockCorrect` | unproved |
| Obligation | Declaration | Status |
| Block correctness for Robin | `blockCorrect` field | unproved |
These obligations block completion of `QBE-AUTO-001`:
- Unitarity is proved for `U_indic` and SWAP; it remains unproved for the other five gate matrices.
- The active `O_D^BS` paper-image matrix has explicit clean-input, global-slot address-range, no-spill, finite-range, global-source injectivity, post-SWAP unique-preimage, and record-level inverse bridge checks.  Lemma 1 covers columns with padded register $|0\rangle^{n-l}$ and output address $|r_{si}\rangle^n$; the executable address/no-spill/range and finite preimage checks are proved under explicit hypotheses.  The former boundary collision is now a rejected row-dependent-model regression, and `oneTermRobinGate_O_D_BS_globalSparseBoundaryNoCollision_n3` checks that the corrected active image separates the old $n=3$ boundary columns.  Semantic cleanup, obligation-record flag promotion, and full unitary extension remain open.
- `O_{D^T}^S` now uses the controlled-rotation skeleton; the diagonal helper remains available only as data.  The next source-contract gap is the coefficient-normalizer relation for the symbolic rotation entries from Lemma 3, Eq. (20).
- `R_y^{boundary}` now has a typed angle-normalizer contract.  Its remaining gap is proving $\theta_j^s=\arccos(D_j^{(s)}/N_D)$, the half-angle identities, and the two-by-two unitarity relation under the paper's $N_D$ bound.
- The shared derivative normalizer contract `GHL2025.derivativeNormalizerNDContract` now records the common $D_j^{(s)}/N_D$ source for `O_{D^T}^S` and `R_y^{boundary}`.  Its nonzero, division, coefficient-bound, absolute-square, square-root, arccos, and two-by-two-unitary fields remain `proved := false`.
- The O_f cited-theorem dependency is now typed as `FunctionOracleExternalAmplitudeSourceContract` and `functionOracleExternalAmplitudeSourceContract`.  It records the GHL2025 coordinate-oracle theorem, the cited arXiv:2411.01131 source, the $N_f$ symbol, and false source-side obligations; it does not close any analytic O_f flag.
- The O_f $N_f$ amplitude route is now typed as `FunctionOracleAmplitudeProofRoute` and `functionOracleAmplitudeProofRoute`.  It ties `robinFunctionValue`, `functionOracleNormalizedValue`, `functionOraclePaperImage`, the external source transcript, and the theorem normalizer symbol together, but nonzero $N_f$, division semantics, the $N_f$ bound, orthogonal completion, unitary completion, and theorem-level amplitude correctness remain false.
| `prepared_clean_backend_eval` | prepared clean entry evaluates to backend fold under `hUniform` | $H_W^{(\kappa)}$ all-slot contract and prepared sparse matrix clean-entry lemmas | lower/middle | `oneTermRobinGamma3BoundarySourcePreparedCleanEntryEval_eq_backendFold_n3` | `proof-attempts/QBE-AUTO-002/source-prepared-branch-sum-dag-20260609-1835-lower1.md` | `python3 tools/qbe.py check` | compiled conditional |
```

## Lean Declaration Index

Recent task-relevant declarations:

| Kind | Lean name | File |
|---|---|---|
| structure | `OneTermRobinGamma3BoundaryBackendUnitaryEntryFoldSupportTarget` | `QuantumBlockEncoding/RobinMatrix.lean:16782` |
| def | `oneTermRobinGamma3BoundaryBackendUnitaryEntryFoldSupportTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16829` |
| theorem | `oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16953` |
| structure | `OneTermRobinGamma3BoundaryPreparedBranchExpansionTarget` | `QuantumBlockEncoding/RobinMatrix.lean:16975` |
| def | `oneTermRobinGamma3BoundaryPreparedBranchExpansionTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17030` |
| def | `oneTermRobinGamma3BoundarySparseCleanIndex_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17174` |
| def | `oneTermRobinGamma3BoundarySparseSlotIndex_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17178` |
| def | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17188` |
| def | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17203` |
| def | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17217` |
| structure | `OneTermRobinGamma3BoundaryPreparedProjectionSandwichBackendTarget` | `QuantumBlockEncoding/RobinMatrix.lean:17304` |
| def | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichBackendTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17345` |
| structure | `OneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField` | `QuantumBlockEncoding/RobinMatrix.lean:17476` |
| def | `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17510` |
| theorem | `oneTermRobinGamma3BoundaryRawUnitaryEntry_contractMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17711` |
| theorem | `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17727` |
| structure | `OneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap` | `QuantumBlockEncoding/RobinMatrix.lean:17746` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17780` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17879` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeGate_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17913` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeCircuit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17928` |
| theorem | `oneTermRobinGamma3BoundaryPreparedCompositeGateMatchesCircuit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17933` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17948` |
| structure | `OneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface` | `QuantumBlockEncoding/RobinMatrix.lean:18030` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18070` |
| abbrev | `oneTermRobinGamma3BoundaryActiveFullDim_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18197` |
| def | `oneTermRobinGamma3BoundaryActiveCleanIndex_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18202` |
| def | `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18429` |
| structure | `OneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:18510` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18547` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18897` |
| def | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18914` |
| def | `oneTermRobinGamma3BoundaryActivePreparedSparseEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19009` |
| def | `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19142` |
| theorem | `oneTermRobinGamma3BoundaryActivePreparedCircuitLabels_distinct_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19221` |
| structure | `OneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:19241` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19287` |
| structure | `OneTermRobinGamma3BoundarySourcePreparedProjectionTarget` | `QuantumBlockEncoding/RobinMatrix.lean:19515` |
| def | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19558` |
| def | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19980` |
| structure | `OneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:20798` |
| def | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20830` |
| theorem | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_diagnostic_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21657` |
| theorem | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21687` |
| theorem | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic` | `QuantumBlockEncoding/RobinMatrix.lean:21700` |
| theorem | `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21718` |
| def | `gateMatricesMatchCircuit` | `QuantumBlockEncoding/CircuitSemantics.lean:41` |
| structure | `CircuitMatrixSemantics` | `QuantumBlockEncoding/CircuitSemantics.lean:404` |
| structure | `PreparedCircuitEntryTarget` | `QuantumBlockEncoding/CircuitSemantics.lean:436` |
| structure | `BlockExtractionTarget` | `QuantumBlockEncoding/CircuitSemantics.lean:502` |
| structure | `BlockExtractionBranchContributionTarget` | `QuantumBlockEncoding/CircuitSemantics.lean:535` |
| structure | `CircuitBlockEncodingClaim` | `QuantumBlockEncoding/CircuitSemantics.lean:661` |
| structure | `FiniteBlockCompositionContract` | `QuantumBlockEncoding/CircuitSemantics.lean:676` |
| def | `signalSystemBlockRowIndex` | `QuantumBlockEncoding/CircuitSemantics.lean:696` |
| def | `signalSystemBlockColIndex` | `QuantumBlockEncoding/CircuitSemantics.lean:700` |
| theorem | `signalSystemBlockRowIndex_lt` | `QuantumBlockEncoding/CircuitSemantics.lean:712` |
| theorem | `signalSystemBlockColIndex_lt` | `QuantumBlockEncoding/CircuitSemantics.lean:727` |
| def | `signalSystemBlockProjection` | `QuantumBlockEncoding/CircuitSemantics.lean:753` |
| def | `totalCircuitQubits` | `QuantumBlockEncoding/CircuitSemantics.lean:778` |
| def | `CircuitMatrixSemantics.blockExtractionTarget` | `QuantumBlockEncoding/CircuitSemantics.lean:786` |

## Correspondence Artifacts

| Artifact | Role |
|---|---|
| `tasks/QBE-AUTO-002.md` | task/proof map |
| `conversion-windows/QBE-AUTO-002.md` | Lean/Markdown/LaTeX conversion |
| `proof-obligations/QBE-AUTO-002.md` | open obligations |
| `paper-notes/GHL2025_RobinOneTerm.tex` | human-readable proof export |
| `paper-notes/GHL2025/markdown/00_status.md` | human-readable proof export |
| `paper-notes/GHL2025/latex/sections/00_status.tex` | human-readable proof export |
| `research-wiki/cited-results/GHL2025.md` | external theorem memory |

## Latest Dialogue Signal

```text
ic dagger bridge, H_W contract row, slot2 gamma3 branch, prepared clean-entry backend eval, and backendExpansionStatement_of_activePreparedEntryTarget. Active lower leaf should be a narrow source-prepared projection/active-prepared entry field or proof-attempt record; retire U_indic dagger insertion, finite_active_to_prepared_composition, raw Coeff equality, H-free slot0 eval, and backendExpansion bridge rediscovery. No oracle, H_W, R_y, ODBS/ODTS/O_f, LCU, block, normalization, unitarity, or final flags may be promoted.

## 2026-06-09 18:31:32 - middle

Middle synced the 18:21 upper handoff into a source-prepared backend frontier. Added task directive, conversion/proof-obligation/status/cited-results sync, proof-attempt packet proof-attempts/QBE-AUTO-002/source-prepared-clean-entry-middle-packet-20260609-1822.md, refreshed blueprint/status, wrote run zh_summary and article_update. Next lower leaf is either the safe alias oneTermRobinGamma3BoundarySourcePreparedCleanEntryEval_eq_backendFold_n3 or the real finite entry target (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement; backendExpansionStatement_of_activePreparedEntryTarget_n3 is compiled conditional only. No oracle/H_W/R_y/LCU/block/product/normalization/unitarity/final flags promoted. Gates passed: python3 tools/qbe.py check; lake build && lake build Tests. Known diagnostic sorries remain at RobinMatrix.lean:21664 and 21695.

## 2026-06-09 18:37:26 - lower

Lower2 compiled the safe source-prepared alias leaf oneTermRobinGamma3BoundarySourcePreparedCleanEntryEval_eq_backendFold_n3 in QuantumBlockEncoding/RobinMatrix.lean. It directly reuses oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 under hUniform and promotes no oracle/H_W/R_y/LCU/product/block/normalization/unitarity/final flags. Synced conversion window, proof obligations, proof-attempt note, and Chinese summaries. Remaining mathematical leaf is (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement or a strict finite matrix-entry sublemma. Gates passed: lake env lean QuantumBlockEncoding/RobinMatrix.lean; python3 tools/qbe.py check; lake build && lake build Tests. Known diagnostic sorries remain at RobinMatrix.lean:21687 and 21718.

## 2026-06-09 18:38:48 - lower

Lower1 wrote proof-attempts/QBE-AUTO-002/source-prepared-branch-sum-dag-20260609-1835-lower1.md and synced proof-obligations/QBE-AUTO-002.md. Source anchors 948-955, 1098-1164, and 2027-2035 were re-read. Safe prepared clean-entry alias is already compiled, so the next real Lean leaf is the branch-sum equality signalBlockEntry = BranchContributionSum backendBranchContribution, routed through oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3. Do not reassign H-free eval, column0 slot0 diagnostics, raw Coeff equality, or compiled conditional bridges. Gates passed: python3 tools/qbe.py check; lake build; lake build Tests. Known diagnostic sorries remain in RobinMatrix.lean.
```

## Gate Policy

- Stage 1 target/transcript stabilization: upper and middle must verify that
  Lean statements, source-paper prose, register layouts, normalizers, and
  cited contracts match before broad lower proving.
- Stage 2 DAG proof discharge: lower agents work on dynamic leaves only;
  reviewer accepts progress only through `python3 tools/qbe.py check` and
  synchronized Markdown/LaTeX correspondence.
- Mixed lower-agent proof mode: when two lower agents are available, lower 1
  writes the natural-language dependency proof and active-leaf table; lower 2
  compiles exactly one ready Lean leaf from that table.
- Refiner behavior: when several failures share a dependency, repair the
  connected illness area once instead of stacking independent patches.
- No agent may mark a proof complete from self-assessment, partial score, or
  process memory.  Lean plus explicit proof-map correspondence is the gate.
