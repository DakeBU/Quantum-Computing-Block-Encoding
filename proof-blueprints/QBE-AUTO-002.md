# Proof Blueprint: QBE-AUTO-002

Task id: `QBE-AUTO-002`
Title: Concrete Circuit Matrix Semantics Backend
Mode: `faithfulPaper`
Updated: `2026-06-14 16:31:08`
Blueprint stage: `Stage 2 DAG proof discharge, with faithful transcript checks still active`

This is QBE's compact system-of-record snapshot for long-horizon Lean proof
automation.  It follows a similar control pattern to LeanMarathon's evolving
blueprint, but QBE keeps the human-facing proof map split across Lean,
Markdown, LaTeX, proof obligations, and cited-results memory because
block-encoding papers require source notation, register conventions, and
oracle contracts to stay explicit.

## Current Directive

````text
## Current Run Directive: 2026-06-14 Pro-Assessed Source-Prepared Target Repair For Next 6h

This directive supersedes the `2026-06-14 Source-Prepared Active-Field
Contract` directive below for the next 6h batch.  Full assessment:

```text
proof-attempts/QBE-AUTO-002/source-prepared-target-repair-plan-20260614-pro.md
```

ChatGPT Pro's response is directionally correct: the H-free evaluated backend
fold and direct row-`0` to selected sparse slot feeder are retired and must not
be revived.  The full Fig. `fig:1 term ROBIN` theorem-facing object must keep
both `H_W^(kappa)` side preparations.

Local correction: in the current Lean file, these names still compare the old
H-free active signal-zero entry with the prepared clean entry:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

Under

```lean
hUniform :
  oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

the existing compiled bridge routes that comparison back to the retired H-free
backend fold.  Therefore these names are diagnostic wrappers unless middle
first restates the theorem-facing left-hand side.  Do not make the whole next
batch prove this arbitrary-`H` active/prepared comparison.

The next source-faithful target is the prepared clean projection itself:

```lean
Coeff.evalWith env
  ((oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3)
=
Coeff.evalWith env
  (blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

Known compiled route material:

```lean
oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3
oneTermRobinGamma3BoundaryPreparedCleanEntryBackendEval_feedsFixedProductMap_n3
oneTermRobinGamma3BoundaryProductToCoefficientObligation_preparedCompositeCleanEntryBackendEval_n3
```

Next lower work:

1. lower1 writes the source-proof DAG showing that Fig. 4's clean block-entry
   object is the prepared composite clean projection, not the H-free seven-gate
   `[0,0]` entry alone.
2. lower3 checks the necessary condition for this prepared clean-entry route
   and confirms that the H-free fold/direct feeder remain retired.
3. lower2 may prove the selected-zero guard only as a quick diagnostic.  If the
   guard is not closed quickly, stop and restate the source-facing target.  The
   main Lean work is to add one theorem-facing prepared-projection route theorem
   that reuses the compiled prepared clean-entry backend bridge and keeps
   product, LCU, block-correctness, and final-extraction flags false.

Scheduling rule for this batch: run one upper director pass, middle
source-correspondence/memory refresh, lower1 and lower3 in parallel, lower2
after lower1/lower3 confirm the leaf, one reviewer pass after lower2, then one
Chinese summary and one ChatGPT Pro prompt at the end.  Avoid another
upper/middle/reviewer-only batch.
````

## Dynamic Leaf Queue

These are the current local proof or repair candidates.  Lower agents should
work on one item at a time; if an item is stale, upper/middle must retire it
before spending more proof-search tokens.

| Leaf | Status |
|---|---|
| prepared_projection_restatement_leaf: restate theorem-facing Fig. 4 clean projection as `PreparedCleanEntry(H, env) = BackendFold(env)` under `Uniform(H)`; status: active next leaf; Lean: `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`; `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`; ... | candidate |

## Open Obligation Signals

```text
selected-slot nonzero obstruction: Lean `oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3`; class QBE-local finite evaluator witness for the selected gamma3 branch; status proved; stale as lower work
H-free evaluated backend fold: Lean `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`; class compiled normal form plus nonzero selected-slot witness; status retired as active target; `finite_matrix_counterexample`
direct H-free selected-slot feeder: Lean proposed `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 env`; class active row `0` versus selected sparse slot `2` / full index `32`; status retired; `shape_or_register_gap`
source-prepared active-field contract: Lean `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement` and equivalents; class GHL Fig. `fig:1 term ROBIN` / Definition `def:block-encoding` source-correspondence audit; status active middle/lower1/lower3 contract leaf; not theorem closure
active field forces selected-zero guard: Lean proposed `oneTermRobinGamma3BoundarySourcePreparedActiveEval_forces_selectedSlotContribution_zero_n3 H env hUniform hActive`; class QBE-local diagnostic consequence of source-prepared-to-fold wiring plus selected-zero normal form; status active lower2 guard leaf
corrected source-prepared target: Lean restated theorem-facing clean projection after the guard/source audit; class source-contract audit plus finite branch/register diagnostics; status blocked until guard or reviewer restatement
all-slot sparse preparation: Lean `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; class external cited contract from GHL2025 Eq. `arbitrary sparcity` and Shukla--Vedula; status contract-only; downstream-only
```

## Lean Declaration Index

Recent task-relevant declarations:

| Kind | Lean name | File |
|---|---|---|
| theorem | `oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19361` |
| structure | `OneTermRobinGamma3BoundaryPreparedBranchExpansionTarget` | `QuantumBlockEncoding/RobinMatrix.lean:19383` |
| def | `oneTermRobinGamma3BoundaryPreparedBranchExpansionTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19438` |
| def | `oneTermRobinGamma3BoundarySparseCleanIndex_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19582` |
| def | `oneTermRobinGamma3BoundarySparseSlotIndex_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19586` |
| def | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19596` |
| def | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19611` |
| def | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19625` |
| structure | `OneTermRobinGamma3BoundaryPreparedProjectionSandwichBackendTarget` | `QuantumBlockEncoding/RobinMatrix.lean:19712` |
| def | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichBackendTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19753` |
| structure | `OneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField` | `QuantumBlockEncoding/RobinMatrix.lean:19884` |
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
| structure | `OneTermRobinGamma3BoundarySourcePreparedProjectionTarget` | `QuantumBlockEncoding/RobinMatrix.lean:22184` |
| def | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:22227` |
| def | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:22837` |
| theorem | `oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3` | `QuantumBlockEncoding/RobinMatrix.lean:23077` |
| theorem | `oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:23128` |
| structure | `OneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:23948` |
| def | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:23980` |
| theorem | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_diagnostic_n3` | `QuantumBlockEncoding/RobinMatrix.lean:24872` |
| theorem | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` | `QuantumBlockEncoding/RobinMatrix.lean:24902` |
| theorem | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic` | `QuantumBlockEncoding/RobinMatrix.lean:24915` |
| theorem | `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:24933` |
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
then let lower2 prove only the selected-zero guard. Gate passed: python3 tools/qbe.py check.

## 2026-06-14 01:17:37 - middle

Report/export sync complete: wrote runs/20260614-004100-QBE-AUTO-002-cycle01/23_middle_report_export_result.md. Final audit should refresh HUMAN_STATUS.md, REPORTS.zh.md, unresolved-failures.zh.md, paper-notes/GHL2025 markdown/latex status, and project-paper latest/generated status for this run; current project-paper latest still points at 20260613-182230 and no current-run article_update exists. Raw logs, JSON feedback, retrieval JSON, and prompt files are not human entry points. Open blocker: source-prepared active-field contract plus selected-zero guard; do not claim GHL theorem closure, H-free fold validity, arbitrary-H closure, or external primitive/block-correctness formalization. Gates passed: python3 tools/qbe.py check; lake build && lake build Tests, with known diagnostic sorry warnings.

## 2026-06-14 01:24:02 - middle

Middle coordinator sync complete: retired selected-slot witness and H-free fold routes remain recorded; active frontier is source_prepared_active_field_contract plus selected-zero guard. Refreshed GHL status export, project article update, human status, blueprint status, memory digest, todo, and ABEIS generated appendix. Next lower split: lower1 source map, lower3 branch/register verifier, lower2 only oneTermRobinGamma3BoundarySourcePreparedActiveEval_forces_selectedSlotContribution_zero_n3 after feedback.

## 2026-06-14 01:24:30 - middle

Gate after final middle sync passed: python3 tools/qbe.py check; lake build && lake build Tests. Only known diagnostic sorry warnings remain at QuantumBlockEncoding/RobinMatrix.lean:24867 and :24898. Active lower target remains the source-prepared selected-zero guard only.

## 2026-06-14 01:29:18 - reviewer

Reviewer audit complete. Gates passed: python3 tools/qbe.py check; lake build && lake build Tests, with only the known diagnostic sorry warnings at QuantumBlockEncoding/RobinMatrix.lean:24867 and :24898. No new hidden Prop/trivial/admit/axiom shortcuts or semantic proved-flag promotions were found in the diff. Source anchors for Eq. arbitrary sparcity, Eq. angles for Ry, Theorem theorem: 1 term robin, Eq. ROBIN clarified, Fig. fig:1 term ROBIN, and Definition def:block-encoding were verified in the local TeX. Active frontier is source_prepared_active_field_contract plus the proposed selected-zero guard; the selected-slot witness is compiled/stale, and the H-free fold/direct row0-to-slot2 feeder stay retired. Blocking for theorem closure: the two diagnostic sorries remain and the source-prepared selected-zero guard is not yet proved. Advisory/report gap: HUMAN_STATUS.md and unresolved-failures.zh.md link runs/20260614-004100-QBE-AUTO-002-cycle01/zh_summary.md, but that file is absent. Next lower work should run lower1/lower3 source and shape feedback, then lower2 only oneTermRobinGamma3BoundarySourcePreparedActiveEval_forces_selectedSlotContribution_zero_n3.
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
