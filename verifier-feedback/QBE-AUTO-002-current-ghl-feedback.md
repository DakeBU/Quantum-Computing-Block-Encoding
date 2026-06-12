# Verifier Feedback: QBE-AUTO-002 Current GHL Leaf

Task: `QBE-AUTO-002`

Mode: `faithfulPaper`

Scope: Guseynov--Huang--Liu 2025 one-term Robin block-encoding circuit
semantics, currently focused on the finite `n = 3` matrix-entry bridge needed
for the theorem-facing Fig. 4 route.

## Current Diagnosis

The current useful feedback layers are not hardware or timeline layers. The
active blocker is a source-prepared finite matrix-entry decomposition feeding
the one-term Robin route. The strict prepared-sparse feeder is already
compiled and retired. The latest lower success compiled
`oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3`,
which proves that the exact unwrapped active/prepared sparse-clean `evalWith`
equality is equivalent to
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` under the
existing `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`
contract.

This is route wiring, not theorem closure. The next useful feedback target is
`evaluated_backend_fold_leaf`, namely
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`.  The exact
unwrapped `active_prepared_composition_leaf` remains an equivalent route under
the explicit clean-column contract: the active seven-gate `[0,0]` evaluated
entry must equal the prepared sparse clean-clean entry. The H-free
active-selected diagnostic route, backend slot support/vanish work, raw
`Coeff` constructor equality, and compiled bridge rediscovery remain stale.

Typed status:

```json
{
  "task": "QBE-AUTO-002",
  "leaf": "evaluated_backend_fold_leaf",
  "mode": "faithfulPaper",
  "source_correspondence_ok": "true_for_evaluated_fold_under_post_feeder_bridge_false_for_unconditional_arbitrary_H_sparse_equality",
  "lean_parse_ok": true,
  "lean_build_ok": true,
  "finite_matrix_ok": "partial_bridge_compiled_evaluated_fold_open",
  "block_entry_ok": "false_evaluated_backend_fold_still_open",
  "ancilla_cleanup_ok": "not_promoted",
  "normalizer_ok": true,
  "closed_theorem_ok": false,
  "error_class": "symbolic_bridge_gap",
  "next_route": "prove oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env or a smaller evaluated matrix-entry lemma feeding it; keep hUniform explicit if using the sparse-clean route"
}
```

The latest accepted lower handoff records passing `python3 tools/qbe.py check`,
`lake build`, and `lake build Tests` with the known diagnostic `sorry` lines in
`QuantumBlockEncoding/RobinMatrix.lean`. The compiled bridges close only route
wiring; the current theorem-facing route remains open.

## Applicable Feedback Checks

| Check | Useful now? | Reason |
|---|---:|---|
| Lean parser/build | yes | catches new proof-script or declaration failures. |
| finite `n = 3` matrix-entry check | yes | current route is finite matrix semantics before general theorem reuse. |
| support/vanish/cancellation by backend slot | no | slots `0`, `1`, `3`, `4`, `5`, and `6` have compiled vanish/support feeders; repeating slot work is stale. |
| raw `Coeff` constructor equality | no | previous route showed this is not the right semantic equality level. |
| backend-fold-to-selected-slot feeder | no | `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3` is compiled and retired as a lower target. |
| active-selected to evaluated-fold bridge | no | `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalComparison_iff_evaluatedBackendFold_n3` is compiled route packaging; the comparison itself remains open. |
| active-side selected-slot `evalWith` bridge | no | latest diagnostic classified this default H-free route as a shape/register gap unless a new source-faithful path is supplied. |
| strict prepared-sparse clean-entry feeder | no | `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_preparedSparseCleanEntry_n3` is compiled and retired as a lower target. |
| post-feeder sparse-clean to fold bridge | no | `oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3` is compiled and retired as route wiring. |
| evaluated backend fold | yes | current fixed route may prove `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` directly. |
| active/prepared composition field | yes | equivalent fixed route should prove the active seven-gate evaluated entry equals the prepared sparse clean-clean entry. |
| output distribution test | no | block encoding requires operator entry equality, not only sampled output behavior. |
| timeline/pulse/hardware scheduling | no | GHL current blocker is not OpenQASM timing or hardware compilation. |
| reward score/pass@k | advisory only | can rank lower proof routes, but cannot close a theorem. |

## Lower-Agent Split

Natural-language proof architect:

- classify the prepared-sandwich and sparse-clean-to-fold bridges as retired and name the active equivalent leaf;
- produce a dependency table for the RHS of
  `oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3 H env hUniform`;
- record `ActiveSelectedSlotEvalComparison` as stale by default unless a new
  source-faithful active path avoids the diagnostic seven-gate zero route.

Lean implementation worker:

- edit only the narrow target file and one active leaf;
- prefer `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`, the
  exact unwrapped active/prepared sparse-clean equality, or one smaller theorem
  that directly proves one of these statements;
- run `python3 tools/qbe.py check` after Lean edits;
- log typed feedback with `trial-log --feedback-field ...`.

Reviewer:

- reject continued work on the raw `Coeff` constructor equality route as theorem
  closure;
- reject any handoff that does not classify the failure into one of the typed
  feedback classes;
- reject promotions of external primitives, oracle contracts, normalizers, or
  final block-encoding theorem status unless a named Lean declaration closes the
  exact target.

## 2026-06-11 Middle Lower2 Failure Normalization

Lower2's blocked attempt on
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` is now
normalized as a `symbolic_bridge_gap`. The raw matrix diagnostic
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` should not
be assigned as theorem closure after the `maxRecDepth` failure. The next route
is an evaluated finite product bridge using the matrix helpers in
`QuantumBlockEncoding/CircuitSemantics.lean`, or the source-prepared sparse
clean route with `hUniform` explicit.

```json
{
  "task": "QBE-AUTO-002",
  "run_id": "20260611-234445-QBE-AUTO-002-cycle01",
  "leaf": "evaluated_backend_fold_leaf",
  "source_correspondence_ok": "true_for_evaluated_fold_under_source_audit; sparse_clean_route_requires_hUniform",
  "lean_parse_ok": true,
  "lean_build_ok": "true_previous_gate",
  "finite_matrix_ok": "partial_backend_fold_collapses_to_slot_2; active_eval_product_bridge_absent",
  "block_entry_ok": false,
  "ancilla_cleanup_ok": "not_promoted",
  "normalizer_ok": "unchanged",
  "closed_theorem_ok": false,
  "error_class": "symbolic_bridge_gap",
  "secondary_error_class": "shape_or_register_gap_if_forced_through_H_free_selected_slot_diagnostic",
  "next_route": "prove an evalWith-level active product/backend fold bridge; keep hUniform explicit if using the source-prepared sparse-clean route"
}
```
