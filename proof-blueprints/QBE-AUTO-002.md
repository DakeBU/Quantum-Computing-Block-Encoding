# Proof Blueprint: QBE-AUTO-002

Task id: `QBE-AUTO-002`
Title: Concrete Circuit Matrix Semantics Backend
Mode: `faithfulPaper`
Updated: `2026-06-12 00:03:59`
Blueprint stage: `Stage 2 DAG proof discharge, with faithful transcript checks still active`

This is QBE's compact system-of-record snapshot for long-horizon Lean proof
automation.  It follows a similar control pattern to LeanMarathon's evolving
blueprint, but QBE keeps the human-facing proof map split across Lean,
Markdown, LaTeX, proof obligations, and cited-results memory because
block-encoding papers require source notation, register conventions, and
oracle contracts to stay explicit.

## Current Directive

```text
## Current Run Directive: 2026-06-11 Post-Bridge Evaluated Backend Fold Frontier

This directive supersedes the post-feeder active/prepared composition packet
for the next lower proof attempt. Lower 2 has compiled the post-feeder bridge

```lean
oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3
```

which proves that, under
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`, the
exact unwrapped active/prepared sparse-clean `evalWith` equality is equivalent
to:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

The bridge is now stale as a lower target. The first-case-study one-term
theorem remains open.

Next lower work:

1. Lower 1 may append only a narrow postscript to Section 21.15 of
   `proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`,
   naming the compiled bridge above and retiring it as a target.
2. Lower 2 edits only `QuantumBlockEncoding/RobinMatrix.lean`.
3. Lower 2 should prove exactly
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`, the
   exact unwrapped active/prepared sparse-clean equality exposed by the
   bridge, or one strictly smaller theorem that directly feeds one of these
   statements.
4. Retire the strict prepared-sparse feeder, the new sparse-clean-to-fold
   bridge, finite active/prepared reduction guards, H-free active-selected
   diagnostics, backend slot vanish/support work, raw `Coeff` constructor
   equalities, branch-sum wrappers, and compiled bridge rediscovery.
5. If the obstacle is the arbitrary-`H` route shape rather than a tactic gap,
   record typed verifier feedback as `source_translation_gap` or
   `shape_or_register_gap`; do not add hypotheses or change the paper circuit.

The gate remains `python3 tools/qbe.py check`, then `lake build`, then
`lake build Tests`.

Generated Chinese summaries, the project article update, and the ABEIS
generated appendix must say that the first-case-study one-term theorem is
still open. This packet only narrows the source-prepared matrix-entry frontier
after one compiled equivalence bridge.

No oracle, `H_W`, `R_y`, LCU, block-projection, normalized-equality,
product-to-coefficient, circuit-unitarity, block-correctness,
final-extraction, normalizer, or external primitive flag is promoted by this
packet.
```

## Dynamic Leaf Queue

These are the current local proof or repair candidates.  Lower agents should
work on one item at a time; if an item is stale, upper/middle must retire it
before spending more proof-search tokens.

| Leaf | Status |
|---|---|
| source_prepared_entry_leaf: theorem-facing source-prepared active field follows after the evaluated fold; status: open dependent target; Lean: `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement` | candidate |
| evaluated_backend_fold_leaf: prove the evaluated signal-zero entry equals the backend branch fold; status: active leaf; Lean: `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` | candidate |
| semantic_eval_product_bridge: prove a smaller evaluated matrix-product bridge feeding the evaluated fold; status: active smaller leaf; preferred; Lean: new local theorem in `QuantumBlockEncoding/RobinMatrix.lean` feeding the right side of `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_... | candidate |

## Open Obligation Signals

```text
evaluated backend fold: Lean `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`; class QBE-local finite projection/backend theorem; status active Lean leaf; not proved
active/prepared sparse-clean equality: Lean left side of `oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3 H env hUniform`; class QBE-local finite matrix semantics plus explicit clean-column contract for recovery; status active equivalent leaf; not proved
post-feeder sparse-clean to fold bridge: Lean `oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3 H env hUniform`; class QBE-local evalWith bridge under external clean-column contract; status compiled bridge; retired as lower target
source-prepared projection active field: Lean `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement`; class QBE-local theorem-facing projection bridge; status open dependent target
diagnostic raw constructor route: Lean `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`; class diagnostic/backlog; status still `sorry`-guarded; do not assign as source closure
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
| def | `oneTermRobinGamma3BoundaryPreparedCompositeGate_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19992` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeCircuit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20007` |
| theorem | `oneTermRobinGamma3BoundaryPreparedCompositeGateMatchesCircuit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20012` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20027` |
| structure | `OneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface` | `QuantumBlockEncoding/RobinMatrix.lean:20109` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20149` |
| abbrev | `oneTermRobinGamma3BoundaryActiveFullDim_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20276` |
| def | `oneTermRobinGamma3BoundaryActiveCleanIndex_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20281` |
| def | `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20508` |
| structure | `OneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:20683` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20720` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21115` |
| def | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21132` |
| def | `oneTermRobinGamma3BoundaryActivePreparedSparseEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21227` |
| def | `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21360` |
| theorem | `oneTermRobinGamma3BoundaryActivePreparedCircuitLabels_distinct_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21465` |
| structure | `OneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:21485` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21531` |
| structure | `OneTermRobinGamma3BoundarySourcePreparedProjectionTarget` | `QuantumBlockEncoding/RobinMatrix.lean:21759` |
| def | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21802` |
| def | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:22332` |
| structure | `OneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:23297` |
| def | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:23329` |
| theorem | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_diagnostic_n3` | `QuantumBlockEncoding/RobinMatrix.lean:24156` |
| theorem | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` | `QuantumBlockEncoding/RobinMatrix.lean:24186` |
| theorem | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic` | `QuantumBlockEncoding/RobinMatrix.lean:24199` |
| theorem | `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:24217` |
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
21.15.7 post-bridge retirement postscript to proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md. It names oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3 as compiled route wiring and retires active_prepared_composition_leaf as the preferred target. Next active leaf is evaluated_backend_fold_leaf: prove oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env or a direct evaluated active-entry/backend-fold feeder. During final clean rebuild, QuantumBlockEncoding/RobinMatrix.lean hit maxRecDepth in the already sorry-guarded diagnostic theorem oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3; lower1 removed only the expensive pre-sorry simplification, leaving the theorem diagnostic and unclosed. No oracle contract, theorem hypothesis, normalizer, gate label, paper circuit, or semantic flag changed. Verifier feedback: leaf=evaluated_backend_fold_leaf; source_correspondence_ok=true_for_evaluated_backend_fold_false_for_unconditional_arbitrary_H_sparse_equality; lean_parse_ok=true_after_minimal_diagnostic_lean_repair; lean_build_ok=true; finite_matrix_ok=partial_compiled_bridge_reduces_sparse_clean_leaf_to_evaluated_fold; block_entry_ok=false_evaluated_backend_fold_still_open; ancilla_cleanup_ok=not_promoted; normalizer_ok=unchanged; closed_theorem_ok=false; error_class=symbolic_bridge_gap; next_route=prove oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env or a direct evaluated active-entry/backend-fold lemma, keeping hUniform explicit if using sparse-clean equality. Gates passed after repair: python3 tools/qbe.py check; lake build; lake build Tests, with known diagnostic sorries at RobinMatrix.lean:24186 and 24217.

## 2026-06-11 23:43:44 - lower

Lower2 did not close oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env. I tested the existing raw matrix bridge oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3 by replacing its final sorry with rfl after the existing simp-only expansion; Lean rejected it with maxRecDepth, confirming this route needs a semantic evalWith associativity/product bridge rather than a local tactic tweak. The patch was reverted. I recorded proof-attempts/QBE-AUTO-002/evaluated-backend-fold-lower2-blocked-20260611-2348.md. Verifier feedback: leaf=unitary_fold_leaf; source_correspondence_ok=partial; lean_parse_ok=true_after_revert; lean_build_ok=true; finite_matrix_ok=partial_backend_fold_collapses_to_slot_2; block_entry_ok=false; ancilla_cleanup_ok=not_promoted; normalizer_ok=unchanged; closed_theorem_ok=false; error_class=shape_or_register_gap; next_route=middle should refresh the active leaf around a source-backed prepared projection theorem or supply a semantic evalWith associativity bridge before another lower proof attempt on the H-free active [0,0] fold. Gates passed: python3 tools/qbe.py check; lake build; lake build Tests, with known pre-existing RobinMatrix sorries at lines 24186 and 24217.
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
