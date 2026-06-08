# Proof Blueprint: QBE-AUTO-002

Task id: `QBE-AUTO-002`
Title: Concrete Circuit Matrix Semantics Backend
Mode: `faithfulPaper`
Updated: `2026-06-07 21:06:16`
Blueprint stage: `Stage 2 DAG proof discharge, with faithful transcript checks still active`

This is QBE's compact system-of-record snapshot for long-horizon Lean proof
automation.  It follows a similar control pattern to LeanMarathon's evolving
blueprint, but QBE keeps the human-facing proof map split across Lean,
Markdown, LaTeX, proof obligations, and cited-results memory because
block-encoding papers require source notation, register conventions, and
oracle contracts to stay explicit.

## Current Directive

```text
## Immediate 6h Focus: Active/Prepared Composition Closure (2026-06-07)

This is the active directive for the next active-time theorem-closure run.  It
supersedes all earlier `Immediate 6h Focus` sections in this task file.

Target exactly one theorem family:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
```

preferably through the equivalent reduced target:

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
```

This is the missing active/prepared selected-entry equality needed by the
already compiled source-correct route
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`.

Use a two-lower-agent population:

- lower 1 is the natural-language proof architect.  It should translate the GHL
  source proof and the current Lean DAG into a dependency-ordered proof plan,
  naming existing declarations and the smallest new intermediate lemma.
- lower 2 is the Lean implementation worker.  It should implement that smallest
  theorem/lemma, run `python3 tools/qbe.py check`, and record useful failed
  routes under `proof-attempts/`.

Allowed mathematical route:

1. Reduce the active/prepared statement to the uncast form using the compiled
   equivalence.
2. Compare the raw active seven-gate selected entry with the prepared sandwich
   clean entry under `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.
3. Reuse the prepared clean-entry backend bridge already compiled in
   `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`.
4. If direct HWKappa use is blocked, use the column-0 support lemmas as a
   fallback, but do not restart the frozen H-free raw fold as the main route.

Non-goals:

- Do not prove `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` as a
  standalone H-free theorem this batch; it is diagnostic/backlog unless routed
  through the prepared projection target.
- Do not recursively formalize Shukla--Vedula, LCU, or block-composition.
- Do not add assumptions, replace the paper circuit, or promote semantic flags.
- Do not spend the cycle on project-paper polish or broad library refactors.

Success means a sorry-free proof of the active/prepared theorem or a strictly
smaller compiled theorem that the next Lean worker can use directly.
```

## Dynamic Leaf Queue

These are the current local proof or repair candidates.  Lower agents should
work on one item at a time; if an item is stale, upper/middle must retire it
before spending more proof-search tokens.

| Leaf | Status |
|---|---|
| - lower 1 is the natural-language proof architect. It should translate the GHL source proof and the current Lean DAG into a dependency-ordered proof plan, naming existing declarations and the smallest new intermediate lemma. | candidate |
| - lower 2 is the Lean implementation worker. It should implement that smallest theorem/lemma, run `python3 tools/qbe.py check`, and record useful failed routes under `proof-attempts/`. | candidate |
| 1. Reduce the active/prepared statement to the uncast form using the compiled equivalence. | candidate |
| 2. Compare the raw active seven-gate selected entry with the prepared sandwich clean entry under `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`. | candidate |
| 3. Reuse the prepared clean-entry backend bridge already compiled in `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`. | candidate |
| 4. If direct HWKappa use is blocked, use the column-0 support lemmas as a fallback, but do not restart the frozen H-free raw fold as the main route. | candidate |
| - Do not prove `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` as a standalone H-free theorem this batch; it is diagnostic/backlog unless routed through the prepared projection target. | candidate |
| - Do not recursively formalize Shukla--Vedula, LCU, or block-composition. | candidate |
| - Do not add assumptions, replace the paper circuit, or promote semantic flags. | candidate |
| - Do not spend the cycle on project-paper polish or broad library refactors. | candidate |
| # Proof Obligations: QBE-AUTO-002 — Circuit Matrix Semantics Backend | candidate |
| This ledger tracks the unproved semantic claims introduced by the circuit | candidate |

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
Middle re-audited the O_D^BS source contract against GHL2025 Lemma
```

## Lean Declaration Index

Recent task-relevant declarations:

| Kind | Lean name | File |
|---|---|---|
| structure | `OneTermRobinGamma3BoundaryBackendUnitaryEntryFoldSupportTarget` | `QuantumBlockEncoding/RobinMatrix.lean:16430` |
| def | `oneTermRobinGamma3BoundaryBackendUnitaryEntryFoldSupportTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16477` |
| theorem | `oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16601` |
| structure | `OneTermRobinGamma3BoundaryPreparedBranchExpansionTarget` | `QuantumBlockEncoding/RobinMatrix.lean:16623` |
| def | `oneTermRobinGamma3BoundaryPreparedBranchExpansionTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16678` |
| def | `oneTermRobinGamma3BoundarySparseCleanIndex_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16822` |
| def | `oneTermRobinGamma3BoundarySparseSlotIndex_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16826` |
| def | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16836` |
| def | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16851` |
| def | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16865` |
| structure | `OneTermRobinGamma3BoundaryPreparedProjectionSandwichBackendTarget` | `QuantumBlockEncoding/RobinMatrix.lean:16952` |
| def | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichBackendTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16993` |
| structure | `OneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField` | `QuantumBlockEncoding/RobinMatrix.lean:17124` |
| def | `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17158` |
| theorem | `oneTermRobinGamma3BoundaryRawUnitaryEntry_contractMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17359` |
| theorem | `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17375` |
| structure | `OneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap` | `QuantumBlockEncoding/RobinMatrix.lean:17394` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17428` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17527` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeGate_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17561` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeCircuit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17576` |
| theorem | `oneTermRobinGamma3BoundaryPreparedCompositeGateMatchesCircuit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17581` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17596` |
| structure | `OneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface` | `QuantumBlockEncoding/RobinMatrix.lean:17678` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17718` |
| abbrev | `oneTermRobinGamma3BoundaryActiveFullDim_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17845` |
| def | `oneTermRobinGamma3BoundaryActiveCleanIndex_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17850` |
| def | `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18077` |
| structure | `OneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:18158` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18195` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18527` |
| def | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18544` |
| def | `oneTermRobinGamma3BoundaryActivePreparedSparseEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18639` |
| def | `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18772` |
| theorem | `oneTermRobinGamma3BoundaryActivePreparedCircuitLabels_distinct_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18851` |
| structure | `OneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:18871` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18917` |
| structure | `OneTermRobinGamma3BoundarySourcePreparedProjectionTarget` | `QuantumBlockEncoding/RobinMatrix.lean:19122` |
| def | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19165` |
| def | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19551` |
| structure | `OneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:20301` |
| def | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20333` |
| theorem | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_diagnostic_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20988` |
| theorem | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21018` |
| theorem | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic` | `QuantumBlockEncoding/RobinMatrix.lean:21031` |
| theorem | `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21049` |
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
aperImage(0) = 96` | QBE n=3 finite, `ODBSCol0_support_n3` | Proved (native_decide) | Dagger row-0 support |
| `bandedSparseAccessPaperImage(1) = 97` | QBE n=3 finite, `ODBSCol1_support_n3` | Proved (native_decide) | Prefix column-0 support |

No external results need formalization this cycle. All use sites reference compiled QBE lemmas or external GHL2025 contracts at the operator level.

## 2026-06-07 20:34:28 - middle

Proof-obligations ledger updated with suffix-side row-0 obligations and compiled column-0 support status. Two lower agents dispatched: (1) proof architect writing suffix-row0-plan.md, (2) Lean worker implementing evalWith_mul_two_path infrastructure and two-path decomposition. Build gate passes with 2 pre-existing sorries.

## 2026-06-07 20:40:44 - middle

Proof architect completed. Plan at suffix-row0-plan.md. Key insight: two-path sparsity from prefix side only, suffix at row 0 = O_f[12,:]. 8 lemmas in dependency order. Lean worker still running on evalWith_mul_two_path infrastructure.

## 2026-06-07 20:51:25 - middle

Both lower agents completed. Two-path infrastructure compiled: evalWith_mul_two_path (CircuitSemantics.lean:328), foldl_add_two_of_nodup (CircuitSemantics.lean:235), DaggerRow0_support_n3 (RobinMatrix.lean:7546), SwapRow96_image_n3 (RobinMatrix.lean:7574), SevenGateTwoPath_n3 (RobinMatrix.lean:7590). Build passes with 2 pre-existing sorries, 0 new. Next: suffix entry evaluation lemmas (suffix[0,96] = O_f[12,96], suffix[0,97] = O_f[12,97]), then attempt EvaluatedBackendFoldStatement.

## 2026-06-07 21:00:05 - lower

Proof architect plan updated. Key finding: the target UncastActivePreparedCompositeEvalStatement_n3 reduces entirely to proving EvaluatedBackendFoldStatement_n3 (evalGateMatrices[0,0] evalWith = backendFold evalWith), via the reverse of the compiled prepared-bridge under HWKappa. This is the same as the frozen H-free fold at the evaluation level. Recommended route: compute sevenGateMatrix[0,0] through the compiled two-path decomposition + suffix entry evaluation (O_f[12,k] entries), then compare with the backend fold. New lemmas needed: SwapRow96_support_n3 (~15 lines), SuffixRow0Col_eval_n3 (~20 lines), sevenGateEntry00_expanded_n3 (~10 lines). Plan written to proof-attempts/QBE-AUTO-002/active-prepared-architect-plan-cycle01-update.md with full dependency graph.

## 2026-06-07 21:05:55 - lower

Compiled 3 new private lemmas: (1) oneTermRobinGamma3BoundarySwapRow96_support_n3: SWAP at row 96 has support only at column 12. (2) oneTermRobinGamma3BoundarySuffixRow0Col96_eval_n3: suffix[0,96] = O_f[12,96] via double unique-path (dagger→col 96, SWAP→col 12). (3) oneTermRobinGamma3BoundarySuffixRow0Col97_eval_n3: suffix[0,97] = O_f[12,97] via same double unique-path. Gate passes: 2 pre-existing sorries, 0 new. Next step: evaluate the four terms in the two-path decomposition (suffix[0,96], suffix[0,97], prefix[96,0], prefix[97,0]) to concrete Coeff/Rat values, then attempt the EvaluatedBackendFoldStatement.
```

## Gate Policy

- Stage 1 target/transcript stabilization: upper and middle must verify that
  Lean statements, source-paper prose, register layouts, normalizers, and
  cited contracts match before broad lower proving.
- Stage 2 DAG proof discharge: lower agents work on dynamic leaves only;
  reviewer accepts progress only through `python3 tools/qbe.py check` and
  synchronized Markdown/LaTeX correspondence.
- Refiner behavior: when several failures share a dependency, repair the
  connected illness area once instead of stacking independent patches.
- No agent may mark a proof complete from self-assessment, partial score, or
  process memory.  Lean plus explicit proof-map correspondence is the gate.
