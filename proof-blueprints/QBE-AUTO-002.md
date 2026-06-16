# Proof Blueprint: QBE-AUTO-002

Task id: `QBE-AUTO-002`
Title: Concrete Circuit Matrix Semantics Backend
Mode: `paperBenchmark`
Updated: `2026-06-17 01:35:01`
Blueprint stage: `Stage 2 DAG proof discharge, with source-transcript checks still active`

This is QBE's compact system-of-record snapshot for long-horizon Lean proof
automation.  It follows a similar control pattern to LeanMarathon's evolving
blueprint, but QBE keeps the human-facing proof map split across Lean,
Markdown, LaTeX, proof obligations, and cited-results memory because
block-encoding papers require source notation, register conventions, and
oracle contracts to stay explicit.

## Current Directive

````text
## Current Run Directive: 2026-06-17 GHL Theorem 3 Baseline Then BE Improvement

This directive supersedes older lower-level GHL directives for the next 6h
active run.  The upper agent must keep the task scientifically ordered:

1. **Close the GHL paper benchmark baseline first.**  Locate the paper theorem
   corresponding to the Guseynov--Huang--Liu block-encoding theorem
   (the run should treat this as Theorem 3 / the main BE construction theorem,
   using the local source map if numbering differs).  Prove the paper's own
   block-encoding construction in Lean without changing the paper construction,
   hidden assumptions, oracle contracts, normalizer, register layout, or gate
   order.
2. **After the baseline is Lean-closed, start improvement search for the same
   operator.**  Create or update a candidate population for the same target
   operator and compare candidates by the current QBE score order:
   `(depth, gateCount, auxiliaryQubits, oracleCalls)`.  Depth is first because
   parallel schedules are preferred; gate count breaks depth ties; auxiliary
   dimension `a` is optimized after that; unresolved oracle calls are minimized
   last.  Candidate mutations may use EoH-style population search and LBG-style
   middle-agent rule/memory updates, but they must not be confused with the
   source-fixed paper benchmark.
3. **If the GHL baseline is closed and improvement search stagnates for many
   generations, switch to the fallback operator-construction task**
   `QBE-OP-OPTCTRL-001`, titled `Operator of optimal control paper`.  Its
   target is the operator shown in the user's image:

   ```text
   E_k := |0><k|_time ⊗ |0><1|_type ⊗ I_n
   ```

   Treat it as an `operatorBlockEncoding` exploration task: define the operator
   contract, construct candidate block encodings, prove the block-entry and
   unitarity contracts, and evolve candidates by the same score order.

Required agent split for this run:

| Agent role | Required behavior |
|---|---|
| upper target/source panel | Verify the exact GHL theorem source location and decide whether the current active Lean leaf really feeds the paper's BE theorem.  If the theorem numbering in the local TeX differs from "Theorem 3", record the correct anchor but keep the target as the main GHL BE theorem. |
| middle correspondence/memory panel | Keep three ledgers synchronized: GHL baseline proof DAG, candidate-population/improvement ledger for the post-baseline phase, and fallback `QBE-OP-OPTCTRL-001` operator contract.  Do not spend tokens polishing writing until a Lean theorem, score change, or blocker changes. |
| lower 1 natural-language construction/proof architect | Produce the smallest source-backed proof DAG leaf that moves the GHL BE theorem toward closure.  After closure, propose a population schema for improved BE candidates. |
| lower 2 Lean worker | Edit only the assigned Lean leaf.  Do not attack root theorem or old H-free false routes unless upper/middle explicitly retarget them with a new source-backed theorem. |
| lower 3 verifier/resource scorer | Before lower2 spends a large proof attempt, check finite matrix entry, unitarity/block-entry necessary conditions, register shape, and the resource score `(depth, gateCount, auxiliaryQubits, oracleCalls)`.  After baseline closure, also check diversity and non-duplication in the candidate population. |
| reviewer | Reject any run that mutates the paper construction before the baseline closes, promotes a diagnostic score to theorem status, changes `A`, changes `alpha`, hides an oracle, or claims improvement without a Lean-checked candidate and explicit score. |

At the end of the 6h active run, write one Chinese summary and one ChatGPT Pro
prompt.  The Chinese summary must say which exact GHL theorem/source anchor is
still not closed, or else say the baseline closed and list the current best
candidate score.  The Pro prompt must be self-contained for an external model
that cannot read local files.
````

## Dynamic Leaf Queue

These are the current local proof or repair candidates.  Lower agents should
work on one item at a time; if an item is stale, upper/middle must retire it
before spending more proof-search tokens.

| Leaf | Status |
|---|---|
| 1. **Close the GHL paper benchmark baseline first.** Locate the paper theorem corresponding to the Guseynov--Huang--Liu block-encoding theorem (the run should treat this as Theorem 3 / the main BE construction theorem, using the local source map if numberin... | candidate |
| 2. **After the baseline is Lean-closed, start improvement search for the same operator.** Create or update a candidate population for the same target operator and compare candidates by the current QBE score order: `(depth, gateCount, auxiliaryQubits, oracle... | candidate |
| 3. **If the GHL baseline is closed and improvement search stagnates for many generations, switch to the fallback operator-construction task** `QBE-OP-OPTCTRL-001`, titled `Operator of optimal control paper`. Its target is the operator shown in the user's im... | candidate |

## Open Obligation Signals

```text
theorem-facing finite block/projection interface: Lean `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3`; class QBE-local non-promoting interface packet; status compiled; stale as lower work
source-prepared slot-`2` normalizer route: Lean `oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3`; class QBE-local semantic bridge under explicit source contracts; status compiled route memory
theorem-facing projection-interface normalizer bridge: Lean planned `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3`; class internal paper-step interface glue plus local coefficient normalizer bridge; status active lower2 leaf after lower1/lower3 checks
fixed product-to-coefficient theorem for `(0,0)`: Lean `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`; class coefficient equality plus corrected theorem-facing finite block/projection route; status open; blocked
finite block-composition closure: Lean `(oneTermRobinFiniteBlockCompositionContract 3).normalizedBlockEquality`, `.blockProjection`, `.lcuComposition`, `.finalExtraction`; class contract-only LCU/block composition background plus local finite projection theorem; status false; forbidden as this leaf
diagnostic raw equality route: Lean `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`; class existing diagnostic `sorry` route; status forbidden as dependency
```

## Lean Declaration Index

Recent task-relevant declarations:

| Kind | Lean name | File |
|---|---|---|
| def | `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19918` |
| theorem | `oneTermRobinGamma3BoundaryRawUnitaryEntry_contractMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20119` |
| theorem | `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20135` |
| structure | `OneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap` | `QuantumBlockEncoding/RobinMatrix.lean:20154` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20188` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20287` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeGate_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20369` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeCircuit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20384` |
| theorem | `oneTermRobinGamma3BoundaryPreparedCompositeGateMatchesCircuit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20389` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20404` |
| structure | `OneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface` | `QuantumBlockEncoding/RobinMatrix.lean:20486` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20526` |
| abbrev | `oneTermRobinGamma3BoundaryActiveFullDim_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20680` |
| def | `oneTermRobinGamma3BoundaryActiveCleanIndex_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20685` |
| def | `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20912` |
| structure | `OneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:21087` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21124` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21540` |
| def | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21557` |
| def | `oneTermRobinGamma3BoundaryActivePreparedSparseEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21652` |
| def | `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21785` |
| theorem | `oneTermRobinGamma3BoundaryActivePreparedCircuitLabels_distinct_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21890` |
| structure | `OneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:21910` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21956` |
| structure | `OneTermRobinGamma3BoundarySourcePreparedProjectionTarget` | `QuantumBlockEncoding/RobinMatrix.lean:22207` |
| def | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:22250` |
| theorem | `oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3` | `QuantumBlockEncoding/RobinMatrix.lean:22491` |
| theorem | `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3` | `QuantumBlockEncoding/RobinMatrix.lean:22514` |
| theorem | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | `QuantumBlockEncoding/RobinMatrix.lean:22549` |
| def | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:22956` |
| theorem | `oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3` | `QuantumBlockEncoding/RobinMatrix.lean:23196` |
| theorem | `oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:23247` |
| theorem | `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` | `QuantumBlockEncoding/RobinMatrix.lean:23637` |
| structure | `OneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:24108` |
| def | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:24140` |
| structure | `OneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation` | `QuantumBlockEncoding/RobinMatrix.lean:24913` |
| def | `oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3` | `QuantumBlockEncoding/RobinMatrix.lean:24937` |
| structure | `OneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge` | `QuantumBlockEncoding/RobinMatrix.lean:25201` |
| def | `oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3` | `QuantumBlockEncoding/RobinMatrix.lean:25251` |
| structure | `OneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit` | `QuantumBlockEncoding/RobinMatrix.lean:25408` |
| def | `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:25466` |
| def | `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3` | `QuantumBlockEncoding/RobinMatrix.lean:25708` |
| theorem | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_diagnostic_n3` | `QuantumBlockEncoding/RobinMatrix.lean:26091` |
| theorem | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` | `QuantumBlockEncoding/RobinMatrix.lean:26121` |
| theorem | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic` | `QuantumBlockEncoding/RobinMatrix.lean:26134` |
| theorem | `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:26152` |
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

````text
tic-flag routes; active leaf remains theorem_facing_projection_interface_normalizer_bridge with planned Lean target oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3; wrote 22_middle_memory_retrieval-output.md and middle-memory verifier JSON; refreshed blueprint status cards; gate passed via python3 tools/qbe.py check with only known RobinMatrix diagnostic sorry warnings.

## 2026-06-15 06:12:47 - middle

middle report/export maintainer complete: wrote runs/20260615-053748-QBE-AUTO-002-cycle01/23_middle_report_export-output.md. Final audit should refresh HUMAN_STATUS.md, REPORTS.zh.md, any zh_summary/article_update packets, GHL Markdown/LaTeX status exports, project-paper latest update, and ABEIS generated_cycle_status from the current run. Raw logs, verifier JSON, proof-attempt packets, machine retrieval JSON, trials files, and generated cycle updates are not primary human entry points. Human blocker: compiled ProjectionInterface is route memory; active blocker is oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3 before final coefficient/product bridge. Forbidden claims unchanged: no GHL theorem closure or oracle/H_W/R_y/LCU/block/final/unitary/resource/product promotion. Gate passed: python3 tools/qbe.py check with only known RobinMatrix diagnostic sorry warnings.

## 2026-06-15 06:18:03 - middle

middle coordinator synthesis complete: read source-correspondence, memory/retrieval, and report/export outputs; wrote 24_middle_coordinator_synthesis-output.md and theorem-facing projection-interface normalizer coordinator feedback JSON; active leaf remains theorem_facing_projection_interface_normalizer_bridge with planned lower2 target oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3; no Lean or article update edit; gate passed via python3 tools/qbe.py check with only the two known RobinMatrix diagnostic sorry warnings.

## 2026-06-15 06:22:50 - reviewer

reviewer gate: python3 tools/qbe.py check passed, running lake build and lake build Tests, with only the two known RobinMatrix diagnostic sorry warnings. Lean interface packet is compiled non-promoting route memory: source-prepared projection is attached, active backend contract remains oneTermRobinCircuitSemantics 3, Fig. 4 and active backend guards remain distinct, and theorem-facing product/LCU/block/final/oracle/unitary/resource flags remain false. Blocking review finding: human-facing proof exports and project-paper latest packet are stale relative to the current task/conversion/blueprint; paper-notes/GHL2025 markdown/latex status and project-paper latest still describe the retired projection-interface leaf instead of active theorem_facing_projection_interface_normalizer_bridge / planned oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3. Next route: refresh those exports, then lower1/lower3 validate source/normalizer guards before lower2 proves only the planned normalizer bridge theorem.
````

## Gate Policy

- Stage 1 target/transcript stabilization: upper and middle must verify that
  Lean statements, source-paper prose, register layouts, normalizers, and
  cited contracts match before broad lower proving.
- Stage 2 DAG proof discharge: lower agents work on dynamic leaves only;
  reviewer accepts progress only through `python3 tools/qbe.py check` and
  synchronized Markdown/LaTeX correspondence.
- Mixed lower-agent proof mode: lower 1 writes the natural-language dependency
  proof and active-leaf table; lower 2 compiles exactly one ready Lean leaf;
  lower 3, when available, runs necessary-condition diagnostics such as finite
  matrix/path/support checks and typed verifier-feedback packets before lower 2
  spends time on a large Lean proof.
- Refiner behavior: when several failures share a dependency, repair the
  connected illness area once instead of stacking independent patches.
- No agent may mark a proof complete from self-assessment, partial score, or
  process memory.  Lean plus explicit proof-map correspondence is the gate.
