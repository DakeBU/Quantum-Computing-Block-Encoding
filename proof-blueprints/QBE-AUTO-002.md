# Proof Blueprint: QBE-AUTO-002

Task id: `QBE-AUTO-002`
Title: Concrete Circuit Matrix Semantics Backend
Mode: `paperBenchmark`
Updated: `2026-06-17 06:27:22`
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
| prepared_composite_source_projection_audit: non-promoting wrapper that exposes `PreparedCompositeSemantics(H)`, the rejected active/prepared field, lower3 finite obstruction, and false theorem flags; status: active audit-only leaf; Lean: planned `oneTermRobinGamma3BoundaryPreparedCompositeSourceProjectionAudit_n3` | candidate |
| source_contract_repair: restate the theorem-facing projection contract so it does not equate the H-free active backend entry with the prepared singleton clean entry; status: active source-contract repair; Lean: Markdown/Lean contract target not yet fixed | candidate |

## Open Obligation Signals

```text
prepared-composite source field: Lean `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env`; `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`; source target `activeToPreparedSingletonEvalStatement`; class direct active/prepared equality; status rejected by finite matrix counterexample; do not assign
prepared-composite source projection audit: Lean planned `oneTermRobinGamma3BoundaryPreparedCompositeSourceProjectionAudit_n3`; class QBE-local false-flag wrapper over source-prepared route memory and lower3 obstruction; status active audit-only leaf; no semantic promotion
source-contract repair: Lean corrected theorem-facing projection contract that avoids equating the H-free seven-gate entry with the prepared singleton clean entry; class internal GHL step plus QBE-local finite projection semantics; status active middle/lower1 route; no Lean proof search until exact contract is fixed
evaluated backend-fold source bridge audit: Lean `oneTermRobinGamma3BoundaryEvaluatedBackendFoldSourceBridgeAudit_n3`; class non-promoting route wrapper; status compiled; retired as lower target
direct H-free evaluated fold: Lean `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`; class active seven-gate backend shortcut; status rejected by finite matrix counterexample; do not assign
generic backend projection/expansion route: Lean `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3`; `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3`; class invalid route / no-go guard; status refuted; do not assign
`H_W^(kappa)` clean column: Lean `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; class external cited contract from GHL2025 Eq. `arbitrary sparcity` and Shukla--Vedula; status contract-only; do not mark formalized
fixed gamma3 product-to-coefficient root: Lean `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`; class coefficient equality plus finite normalized-block/projection bridge; status blocked; do not assign directly
product, normalized block, LCU, block projection, block correctness, final extraction, oracle, unitarity, and resources: Lean finite block contract fields and theorem-facing flags; class downstream theorem obligations; status false/unproved; no promotion
post-baseline candidate population: Lean score `(depth, gateCount, auxiliaryQubits, oracleCalls)` for the same operator; class baseline theorem must close first; status deferred
fallback `QBE-OP-OPTCTRL-001`: Lean rank-one time/type partial-isometry operator tensored with `I_n`; class fallback only after baseline closure and improvement stagnation; status planned; not active
```

## Lean Declaration Index

Recent task-relevant declarations:

| Kind | Lean name | File |
|---|---|---|
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
| theorem | `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3` | `QuantumBlockEncoding/RobinMatrix.lean:23681` |
| structure | `OneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:24126` |
| def | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:24158` |
| structure | `OneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation` | `QuantumBlockEncoding/RobinMatrix.lean:24931` |
| def | `oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3` | `QuantumBlockEncoding/RobinMatrix.lean:24955` |
| structure | `OneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge` | `QuantumBlockEncoding/RobinMatrix.lean:25219` |
| def | `oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3` | `QuantumBlockEncoding/RobinMatrix.lean:25269` |
| structure | `OneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit` | `QuantumBlockEncoding/RobinMatrix.lean:25426` |
| def | `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:25484` |
| def | `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3` | `QuantumBlockEncoding/RobinMatrix.lean:25726` |
| theorem | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_diagnostic_n3` | `QuantumBlockEncoding/RobinMatrix.lean:26934` |
| theorem | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` | `QuantumBlockEncoding/RobinMatrix.lean:26964` |
| theorem | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic` | `QuantumBlockEncoding/RobinMatrix.lean:26977` |
| theorem | `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:26995` |
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
. ROBIN clarified 1111-1119, Eq. arbitrary sparcity 948-955, Fig. fig:1 term ROBIN 1122-1164, def:block-encoding 2027-2035). Rejected-route memory to promote: source_prepared_prepared_composite_field / direct active-prepared equality is finite_matrix_counterexample under uniform H and all-one selected branch; evaluated H-free fold, raw prepared-sandwich promotion, generic backend expansion/projection, product/LCU/oracle/unitary/resource/post-baseline/OPTCTRL are forbidden. Next director objective: middle repairs the source contract/proof-translation packet or assigns only a non-promoting PreparedCompositeSourceProjectionAudit false-flag wrapper; lower2 must not solve new mathematics from the process-memory profile. Missing process artifacts in this run: memory_digest.md, todo.md, zh_summary.md, chatgpt_pro_prompt.md, article_update.md/.tex; final wrapper should generate them once. Harness adjustment: lower2 packets for this family must require a lower3 finite-matrix verdict before any Lean edit and auto-reject leaf ids matching evaluated_backend_fold_source_bridge/source_prepared_prepared_composite_field unless packet type is non-promoting audit.

## 2026-06-17 06:17:50 - upper

Upper synthesis: stay in paperBenchmark mode for GHL2025 label theorem: 1 term robin, the run Theorem 3 baseline. Source audit from ../outer_papers/quantum/GHL2025/main.tex confirms anchors eq: arbitrary sparcity 948-955, angles for Ry 1077-1085, theorem 1098-1109, eq: ROBIN clarified 1111-1119, fig:1 term ROBIN 1122-1164, and def:block-encoding 2027-2035. Retire source_prepared_prepared_composite_field, active/prepared equality, direct H-free evaluated fold, generic backend expansion/projection, and root/product/resource/post-baseline routes as lower2 targets after lower3 finite_matrix_counterexample; next objective is middle source-contract/proof-map repair plus, if a Lean increment is needed, only non-promoting oneTermRobinGamma3BoundaryPreparedCompositeSourceProjectionAudit_n3 with all theorem flags false. Lower1 writes the source-backed dependency packet, lower2 edits only RobinMatrix.lean for that audit wrapper, lower3 records finite witness/register/gate-list diagnostics; reviewer must reject any semantic promotion or improvement search before baseline closure.

## 2026-06-17 06:24:41 - middle

Middle source-correspondence update: source_prepared_prepared_composite_field is retired as a theorem target after lower3 finite_matrix_counterexample; prepared-composite source route remains audit-only memory. Updated conversion window, proof obligations, proof blueprint, memory digest, and packet proof-attempts/QBE-AUTO-002/prepared-composite-source-projection-audit-middle-packet-20260617-062017.md. Next lower2 may only compile non-promoting oneTermRobinGamma3BoundaryPreparedCompositeSourceProjectionAudit_n3 or wait for source-contract repair; no active/prepared, evaluated fold, product, normalized block, LCU, oracle, unitary, resource, post-baseline, or OPTCTRL promotion.
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
