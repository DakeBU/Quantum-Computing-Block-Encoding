# Proof Blueprint: QBE-AUTO-002

Task id: `QBE-AUTO-002`
Title: Concrete Circuit Matrix Semantics Backend
Mode: `faithfulPaper`
Updated: `2026-06-13 13:18:49`
Blueprint stage: `Stage 2 DAG proof discharge, with faithful transcript checks still active`

This is QBE's compact system-of-record snapshot for long-horizon Lean proof
automation.  It follows a similar control pattern to LeanMarathon's evolving
blueprint, but QBE keeps the human-facing proof map split across Lean,
Markdown, LaTeX, proof obligations, and cited-results memory because
block-encoding papers require source notation, register conventions, and
oracle contracts to stay explicit.

## Current Directive

````text
## Current Run Directive: 2026-06-13 Final Finite Projection Feeder Frontier

This directive supersedes the 2026-06-13 source-prepared finite composition
frontier for the next lower proof batch.  The active lower2 target is
`finite_projection_feeder`: prove

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

or one strictly smaller finite `CircuitMatrixSemantics`/`Coeff.evalWith`
theorem in `QuantumBlockEncoding/RobinMatrix.lean` that directly feeds it.
The result is consumed through

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3
  H env hUniform hFold
```

where

```lean
hUniform :
  oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
hFold :
  oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

The arbitrary-`H` `SourcePreparedField(H, env)` target is retired as the
default lower target unless a true all-`H` finite composition theorem or
clean-column independence theorem is explicitly assigned.  Standalone H-free
evaluated-fold closure remains rejected as a default route with
`shape_or_register_gap`.  Do not change oracle contracts, the paper circuit,
normalizer, gate labels, or theorem assumptions, and do not use diagnostic
`sorry` declarations as closure.

The next lower packet is
`proof-attempts/QBE-AUTO-002/finite-projection-feeder-final-middle-packet-20260613-0624.md`.
The first-case-study one-term theorem remains open.  No oracle, `H_W`, `R_y`,
LCU, block-projection, normalized-equality, product-to-coefficient,
circuit-unitarity, block-correctness, final-extraction, normalizer, or external
primitive flag is promoted by this directive.
````

## Dynamic Leaf Queue

These are the current local proof or repair candidates.  Lower agents should
work on one item at a time; if an item is stale, upper/middle must retire it
before spending more proof-search tokens.

| Leaf | Status |
|---|---|
| finite_projection_feeder: prove the active clean projection equals the backend fold at evaluated level; status: active lower leaf; open; Lean: `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` or one strict finite theorem feeding it | candidate |
| source_contract_target_correction: source-prepared field is recovered only with `Uniform(H)` explicit and a finite projection feeder; status: active correction; compiled bridge reused; Lean: `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3 H env hUniform hFold`; `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_i... | candidate |

## Open Obligation Signals

```text
finite projection feeder: Lean `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`, or one strict finite `CircuitMatrixSemantics`/`Coeff.evalWith` theorem feeding it; class QBE-local finite projection/backend fold theorem tied to GHL2025 Eq. `ROBIN clarified`, Fig. `fig:1 term ROBIN`, and Definition `def:block-encoding`; status active lower2 target; open
source-prepared recovery under `Uniform(H)`: Lean `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3 H env hUniform hFold`; class compiled route consuming the finite feeder under the explicit external clean-column contract; status compiled conditional; not closure without `hFold`
arbitrary-`H` source-prepared field: Lean `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement`; `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env`; `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`; class needs a true all-`H` finite composition theorem or clean-column independence theorem; status retired as default lower target
all-slot sparse preparation: Lean `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; class external cited contract from GHL2025 Eq. `arbitrary sparcity` and Shukla--Vedula 2024; status contract-only; allowed only as explicit `hUniform`; not formalized here
direct H-free evaluated-fold route: Lean diagnostic `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`; class diagnostic route with register-shape drift risk; status rejected as default lower target; do not assign
```

## Lean Declaration Index

Recent task-relevant declarations:

| Kind | Lean name | File |
|---|---|---|
| structure | `OneTermRobinGamma3BoundaryBackendUnitaryEntryFoldSupportTarget` | `QuantumBlockEncoding/RobinMatrix.lean:18861` |
| def | `oneTermRobinGamma3BoundaryBackendUnitaryEntryFoldSupportTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18908` |
| theorem | `oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19032` |
| structure | `OneTermRobinGamma3BoundaryPreparedBranchExpansionTarget` | `QuantumBlockEncoding/RobinMatrix.lean:19054` |
| def | `oneTermRobinGamma3BoundaryPreparedBranchExpansionTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19109` |
| def | `oneTermRobinGamma3BoundarySparseCleanIndex_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19253` |
| def | `oneTermRobinGamma3BoundarySparseSlotIndex_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19257` |
| def | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19267` |
| def | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19282` |
| def | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19296` |
| structure | `OneTermRobinGamma3BoundaryPreparedProjectionSandwichBackendTarget` | `QuantumBlockEncoding/RobinMatrix.lean:19383` |
| def | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichBackendTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19424` |
| structure | `OneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField` | `QuantumBlockEncoding/RobinMatrix.lean:19555` |
| def | `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19589` |
| theorem | `oneTermRobinGamma3BoundaryRawUnitaryEntry_contractMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19790` |
| theorem | `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19806` |
| structure | `OneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap` | `QuantumBlockEncoding/RobinMatrix.lean:19825` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19859` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19958` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeGate_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20040` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeCircuit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20055` |
| theorem | `oneTermRobinGamma3BoundaryPreparedCompositeGateMatchesCircuit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20060` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20075` |
| structure | `OneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface` | `QuantumBlockEncoding/RobinMatrix.lean:20157` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20197` |
| abbrev | `oneTermRobinGamma3BoundaryActiveFullDim_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20351` |
| def | `oneTermRobinGamma3BoundaryActiveCleanIndex_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20356` |
| def | `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20583` |
| structure | `OneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:20758` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20795` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21211` |
| def | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21228` |
| def | `oneTermRobinGamma3BoundaryActivePreparedSparseEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21323` |
| def | `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21456` |
| theorem | `oneTermRobinGamma3BoundaryActivePreparedCircuitLabels_distinct_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21561` |
| structure | `OneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:21581` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21627` |
| structure | `OneTermRobinGamma3BoundarySourcePreparedProjectionTarget` | `QuantumBlockEncoding/RobinMatrix.lean:21855` |
| def | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21898` |
| def | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:22476` |
| structure | `OneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:23441` |
| def | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:23473` |
| theorem | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_diagnostic_n3` | `QuantumBlockEncoding/RobinMatrix.lean:24300` |
| theorem | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` | `QuantumBlockEncoding/RobinMatrix.lean:24330` |
| theorem | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic` | `QuantumBlockEncoding/RobinMatrix.lean:24343` |
| theorem | `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:24361` |
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
nce theorem is assigned. Raw run logs, panel prompt files, proof-attempt populations, verifier-feedback JSON, retrieval-index JSON, trials JSONL/CSV, and generated appendix packets are evidence/debug artifacts, not primary human entry points. Open blocker: the first case-study one-term theorem remains open because Lean still lacks the finite evaluated matrix/projection feeder connecting the clean active entry to the backend fold; gates pass with the two known diagnostic sorry warnings. Forbidden manuscript claims: no completion of GHL one-term theorem, no arbitrary-H source-prepared closure, no H-free seven-gate Fig. 4 closure, and no promotion of oracle/H_W/R_y/LCU/QSVT/block-projection/normalized-equality/product-to-coefficient/final-extraction/normalizer/external primitive flags.

## 2026-06-13 06:31:21 - middle

Final middle export sync complete: active leaf is finite_projection_feeder. Lower2 should prove oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env or one strict finite theorem feeding it in QuantumBlockEncoding/RobinMatrix.lean, then consume it through oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3 H env hUniform hFold. Arbitrary-H SourcePreparedField is retired as default unless a true all-H composition/independence theorem is assigned; standalone H-free closure remains shape_or_register_gap. Updated task directive, proof blueprint/status JSON, obligations, run memory/todo, human status, Chinese summary, article update, ABEIS generated appendix, proof-export status, final lower packet, and typed verifier feedback. First one-term theorem remains open; no semantic flags promoted. Gates passed: python3 tools/qbe.py check; lake build; lake build Tests, with known diagnostic sorries at RobinMatrix.lean:24330 and 24361.

## 2026-06-13 06:35:40 - reviewer

Reviewer gate passed: python3 tools/qbe.py check, lake build, and lake build Tests all pass with known diagnostic sorries at RobinMatrix.lean:24330 and 24361. Blocking scheduling finding: after blueprint-refresh, proof-blueprints/QBE-AUTO-002.md still names the stale source_prepared_finite_composition_leaf/current directive, while tasks, obligations, conversion window, run memory, and blueprint status artifacts name finite_projection_feeder. Do not assign lower from the blueprint md until it is refreshed from the top current task directive. No new semantic flag, oracle, normalizer, or theorem-completion promotion found; first one-term theorem remains open.

## 2026-06-13 13:18:37 - upper

Scheduling repair applied after reviewer finding: qbe.py now prefers the active top/current directive with finite_projection_feeder over stale later historical directives, current proof-DAG frontier extraction prioritizes finite_projection_feeder, obligation table extraction reads the latest table, and blueprint/retrieval/HUMAN_STATUS have been refreshed. Next lower target is finite_projection_feeder, not source_prepared_finite_composition_leaf.
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
