# Verifier Feedback: QBE-AUTO-002 Current GHL Leaf

Task: `QBE-AUTO-002`

Mode: `faithfulPaper`

Scope: Guseynov--Huang--Liu 2025 one-term Robin block-encoding circuit
semantics, currently focused on the finite `n = 3` matrix-entry bridge needed
for the theorem-facing Fig. 4 route.

## 2026-06-13 Middle Memory Retrieval Override

The current default lower target is `finite_projection_feeder`, not the
arbitrary-`H` source-prepared field.  Lower2 should prove
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` or one strict
finite theorem feeding it, and the result must be consumed through
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3
H env hUniform hFold`.

```json
{
  "task": "QBE-AUTO-002",
  "run_id": "20260613-054606-QBE-AUTO-002-cycle01",
  "leaf": "finite_projection_feeder",
  "supersedes_leaf": "arbitrary_H_source_prepared_finite_composition_leaf_as_default_lower_target",
  "source_correspondence_ok": true,
  "lean_parse_ok": null,
  "lean_build_ok": null,
  "finite_matrix_ok": "not_checked_by_middle",
  "block_entry_ok": false,
  "ancilla_cleanup_ok": "not_promoted",
  "normalizer_ok": "unchanged_not_promoted",
  "closed_theorem_ok": false,
  "error_class": "source_translation_gap",
  "secondary_error_class_if_hfree_route_reassigned": "shape_or_register_gap",
  "next_route": "Lower2 proves the finite projection feeder for oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env, or one strict theorem feeding it, and the result is consumed only through the explicit hUniform source-prepared bridge."
}
```

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

## 2026-06-13 Middle Current-Run Evaluated Fold Normalization

Run `20260613-042537-QBE-AUTO-002-cycle01` restores the evaluated backend fold
as the default active lower leaf after the source-translation correction.  The
arbitrary-`H` active/prepared interface is no longer the default target unless
a full finite constancy theorem is proved.  The source-prepared sparse-clean
route remains valid only with the existing clean-column contract kept
explicit.

```json
{
  "task": "QBE-AUTO-002",
  "run_id": "20260613-042537-QBE-AUTO-002-cycle01",
  "leaf": "evaluated_backend_fold_leaf",
  "source_correspondence_ok": "true_for_evaluated_backend_fold_under_GHL2025_ROBIN_clarified_and_def_block_encoding; sparse_clean_route_requires_existing_hUniform_contract",
  "lean_parse_ok": "true_markdown_only_no_lean_edit",
  "lean_build_ok": "true_current_middle_gate",
  "finite_matrix_ok": "partial_route_wiring_compiled; evaluated_product_projection_theorem_open",
  "block_entry_ok": false,
  "ancilla_cleanup_ok": "not_promoted",
  "normalizer_ok": "unchanged",
  "closed_theorem_ok": false,
  "error_class": "symbolic_bridge_gap",
  "secondary_error_class_if_hfree_selected_slot_reassigned": "shape_or_register_gap",
  "next_route": "prove oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env or a strict finite Coeff.evalWith product/projection lemma feeding it"
}
```

The durable packet is
`proof-attempts/QBE-AUTO-002/evaluated-backend-fold-current-run-middle-packet-20260613-0435.md`.

## 2026-06-13 Earlier Middle Assignment

The current run assigns the preferred smaller leaf
`semantic_eval_product_bridge`.  This is the evaluated product/projection
bridge feeding the right side of
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env`.
It should compare the active seven-gate `[0,0]` `evalGateMatrices` entry with
`blockExtractionBranchContributionSum oneTermRobinGamma3BoundaryBackendBranchContribution_n3`
after `Coeff.evalWith env`.

```json
{
  "task": "QBE-AUTO-002",
  "run_id": "20260613-014104-QBE-AUTO-002-cycle01",
  "leaf": "semantic_eval_product_bridge",
  "source_correspondence_ok": "true_for_evaluated_fold; sparse_clean_route_requires_hUniform",
  "lean_parse_ok": "true_markdown_only_no_lean_edit",
  "lean_build_ok": "true_current_middle_gate",
  "finite_matrix_ok": "partial_backend_fold_collapses_to_slot_2; active_eval_product_bridge_absent",
  "block_entry_ok": false,
  "ancilla_cleanup_ok": "not_promoted",
  "normalizer_ok": "unchanged",
  "closed_theorem_ok": false,
  "error_class": "symbolic_bridge_gap",
  "next_route": "prove an evalWith-level active product/backend fold bridge feeding oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env"
}
```

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

## 2026-06-13 Middle Source-Prepared Refiner Normalization

The run `20260613-020116-QBE-AUTO-002-cycle01` has a newer upper directive than
the post-bridge evaluated-fold packet.  The default H-free
`semantic_eval_product_bridge` lower assignment is now stale as a source-closure
target.  It may remain diagnostic or recovery memory, but lower2 should next
work on the source-prepared active-entry field or a strict feeder under the
existing `hUniform` route.

```json
{
  "task": "QBE-AUTO-002",
  "run_id": "20260613-020116-QBE-AUTO-002-cycle01",
  "leaf": "source_prepared_active_entry_leaf",
  "supersedes_leaf": "semantic_eval_product_bridge_as_default_next_target",
  "source_correspondence_ok": "true_for_source_prepared_route_with_hUniform; false_for_default_hfree_slot0_to_gamma3_slot2_closure",
  "lean_parse_ok": "true_markdown_only_no_lean_edit",
  "lean_build_ok": true,
  "finite_matrix_ok": "partial_lower3_found_backend_fold_to_slot2_and_rejected_raw_seven_gate_zero_route",
  "block_entry_ok": false,
  "ancilla_cleanup_ok": "not_promoted",
  "normalizer_ok": "unchanged",
  "closed_theorem_ok": false,
  "error_class": "shape_or_register_gap",
  "secondary_error_class_if_source_shaped_but_unproved": "symbolic_bridge_gap",
  "next_route": "prove a source-prepared active-entry theorem or raw prepared-sandwich feeder under the existing hUniform route; do not assign the H-free semantic_eval_product_bridge as the default lower target"
}
```

Useful checks now are branch/register shape checks for the source-prepared
target and Lean parser/build checks after a narrow `RobinMatrix.lean` edit.
Repeating backend slot vanish/support, selected-slot fold collapse, compiled
bridge rediscovery, and raw `Coeff` constructor equality remains stale.

Middle gate result: `python3 tools/qbe.py check`, `lake build`, and
`lake build Tests` passed, with the known diagnostic `sorry` declarations at
`QuantumBlockEncoding/RobinMatrix.lean:24186` and
`QuantumBlockEncoding/RobinMatrix.lean:24217`.

## 2026-06-13 Middle Post-Strict-Feeder Source-Prepared Normalization

The run `20260613-022313-QBE-AUTO-002-cycle01` accepts
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_rawEntryPreparedSandwichField_n3`
as compiled route wiring and retires it as a lower target.  The active theorem
content is still the source-prepared active-entry field.  The preferred
smaller leaf is the raw prepared-sandwich field or a strict source-shaped
feeder into it.

```json
{
  "task": "QBE-AUTO-002",
  "run_id": "20260613-022313-QBE-AUTO-002-cycle01",
  "leaf": "source_prepared_active_entry_leaf",
  "active_smaller_leaf": "raw_entry_to_source_prepared_sandwich_bridge",
  "source_correspondence_ok": "true_for_source_prepared_route_with_hUniform; false_for_default_hfree_slot0_to_gamma3_slot2_closure",
  "lean_parse_ok": "true_markdown_only_no_lean_edit",
  "lean_build_ok": "true_current_middle_gate",
  "finite_matrix_ok": "partial_route_wiring_compiled_raw_field_open",
  "block_entry_ok": false,
  "ancilla_cleanup_ok": "not_promoted",
  "normalizer_ok": "unchanged",
  "closed_theorem_ok": "true_for_strict_feeder_only_false_for_active_leaf",
  "error_class": "symbolic_bridge_gap",
  "secondary_error_class_if_hfree_route_reassigned": "shape_or_register_gap",
  "next_route": "prove the raw prepared-sandwich field or a strict source-shaped feeder; do not reassign compiled feeder or standalone H-free semantic_eval_product_bridge"
}
```

Useful checks now are Lean parser/build checks after a narrow
`RobinMatrix.lean` edit and branch/register checks for source-shaped raw
prepared-sandwich feeders.  Reassigning compiled feeders, standalone H-free
selected-slot routes, backend slot vanish/support, or raw `Coeff` constructor
equality remains stale.

## 2026-06-13 Middle Prepared Clean-Entry Normalization

The run `20260613-024914-QBE-AUTO-002-cycle01` accepts
`oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_preparedCleanEntry_n3`
as compiled source-shaped wiring.  The current active block-entry check is the
prepared clean-entry equality, or the cached active/prepared entry equality
equivalent to it.

```json
{
  "task": "QBE-AUTO-002",
  "run_id": "20260613-024914-QBE-AUTO-002-cycle01",
  "leaf": "prepared_clean_entry_leaf",
  "active_smaller_leaf": "prepared_clean_entry_equality_after_source_shaped_feeder",
  "source_correspondence_ok": "true_for_source_prepared_route_with_hUniform; false_for_standalone_hfree_slot0_to_gamma3_slot2_closure",
  "lean_parse_ok": "true_markdown_only_no_lean_edit",
  "lean_build_ok": "true_current_middle_gate",
  "finite_matrix_ok": "partial_existing_shape_diagnostics_compile; prepared clean-entry equality remains open",
  "block_entry_ok": false,
  "ancilla_cleanup_ok": "not_promoted",
  "normalizer_ok": "unchanged",
  "closed_theorem_ok": false,
  "error_class": "symbolic_bridge_gap",
  "secondary_error_class_if_hfree_route_reassigned": "shape_or_register_gap",
  "next_route": "prove the prepared clean-entry equality or cached active/prepared entry equality; do not reassign compiled source-shaped feeders or standalone H-free semantic_eval_product_bridge"
}
```

Useful checks now are Lean parser/build checks after a narrow
`RobinMatrix.lean` edit and source/register checks for prepared clean-entry
targets.  Reassigning compiled feeders, standalone H-free selected-slot routes,
backend slot vanish/support, branch-sum wrappers, or raw `Coeff` constructor
equality remains stale.

## 2026-06-13 Middle Post-Obstruction Prepared Clean-Entry Normalization

The run `20260613-031339-QBE-AUTO-002-cycle01` accepts
`oneTermRobinGamma3BoundaryPreparedCleanEntryLeaf_obstruction_n3` as a compiled
obstruction handle.  The theorem identifies the prepared interface field
`activeEntryToPreparedEntryStatement` with the prepared clean-entry equality
and records that the equality proof flag is still false.  It is not theorem
closure.

```json
{
  "task": "QBE-AUTO-002",
  "run_id": "20260613-031339-QBE-AUTO-002-cycle01",
  "leaf": "prepared_clean_entry_leaf",
  "active_smaller_leaf": "prepared_interface_activeEntryToPreparedEntryStatement",
  "compiled_obstruction_handle": "oneTermRobinGamma3BoundaryPreparedCleanEntryLeaf_obstruction_n3",
  "source_correspondence_ok": "true_for_source_prepared_prepared_clean_entry_route; false_for_standalone_hfree_slot0_to_gamma3_slot2_closure",
  "source_dependency_class": "internal_qbe_local_finite_circuit_matrix_composition",
  "lean_parse_ok": true,
  "lean_build_ok": true,
  "finite_matrix_ok": "partial_compiled_obstruction_handle; exact active_to_prepared clean-entry equality remains open",
  "block_entry_ok": false,
  "ancilla_cleanup_ok": "not_promoted",
  "normalizer_ok": "unchanged",
  "closed_theorem_ok": false,
  "error_class": "symbolic_bridge_gap",
  "secondary_error_class_if_hfree_route_reassigned": "shape_or_register_gap",
  "next_route": "prove PreparedCleanEntry(H), the interface activeEntryToPreparedEntryStatement, the cached active/prepared entry equality, or one strict source-shaped theorem feeding them"
}
```

Useful checks now are Lean parser/build checks after a narrow
`RobinMatrix.lean` edit and source/register checks for the prepared clean-entry
interface.  The Shukla-Vedula cited result remains contract-only through
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`;
reassigning compiled feeders, standalone H-free selected-slot routes, backend
slot vanish/support, branch-sum wrappers, or raw `Coeff` constructor equality
remains stale.

## 2026-06-13 Middle Active/Prepared Composition Interface Normalization

The run `20260613-033618-QBE-AUTO-002-cycle01` keeps the same source-prepared
mathematical leaf, but narrows the wording to the existing compiled interface
record. Lower2's latest blocked attempt made no Lean edit, found no
counterexample certificate, and reported that direct `rfl` on the prepared
clean-entry equality hits `maxRecDepth`. The useful next route is not another
feeder or obstruction handle; it is the finite active/prepared composition
field already named by Lean.

```json
{
  "task": "QBE-AUTO-002",
  "run_id": "20260613-033618-QBE-AUTO-002-cycle01",
  "leaf": "active_prepared_composition_interface_leaf",
  "supersedes_leaf": "prepared_clean_entry_leaf_as_broad_wording",
  "source_correspondence_ok": "true_for_source_prepared_route_with_hUniform_contract_only",
  "source_dependency_class": "internal_qbe_local_finite_circuit_matrix_composition",
  "lean_parse_ok": "markdown_only_no_lean_edit",
  "lean_build_ok": "true_current_middle_gate",
  "finite_matrix_ok": "not_closed_lower2_direct_rfl_hit_maxRecDepth_no_counterexample_certificate",
  "block_entry_ok": false,
  "ancilla_cleanup_ok": "not_promoted",
  "normalizer_ok": "unchanged",
  "closed_theorem_ok": false,
  "error_class": "symbolic_bridge_gap",
  "secondary_error_class_if_hfree_route_reassigned": "shape_or_register_gap",
  "next_route": "prove the existing active/prepared composition interface leaf: (oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3 H).activeEntryStatement, its interfaceStatement, or the equivalent cached PreparedCircuitEntryTarget equality; do not add another feeder or obstruction record"
}
```

Useful checks now are source-shaped finite active/prepared composition checks
and Lean parser/build checks after a narrow `RobinMatrix.lean` edit. The
compiled obstruction handle, cached feeder equivalences, standalone H-free
selected-slot route, backend slot vanish/support work, branch-sum wrappers, and
raw `Coeff` constructor equality remain stale. The Shukla-Vedula cited row
remains `contract-only` and does not prove the active/prepared equality.

## 2026-06-13 Middle Source-Translation Correction Normalization

The run `20260613-040302-QBE-AUTO-002-cycle01` accepts the latest upper source
audit and lower1 Section 21.21 failure analysis.  The active interface leaf is
still the named Lean target, but the failure class is sharpened: the
source-backed route is conditional on the paper's specific
$H_W^{(\kappa)}$ sparse-preparation operation, while the existing Lean target is
quantified over arbitrary `H`.  A lower worker must therefore prove either the
finite active/prepared composition equality itself or a strict finite
independence theorem justifying the arbitrary-`H` shape.  Otherwise the correct
classification is `source_translation_gap`.

```json
{
  "task": "QBE-AUTO-002",
  "run_id": "20260613-040302-QBE-AUTO-002-cycle01",
  "leaf": "active_prepared_composition_interface_leaf",
  "supersedes_leaf": "active_prepared_composition_interface_leaf_as_pure_symbolic_bridge",
  "source_correspondence_ok": "conditional_source_route_ok_for_H_W_contract; unconditional_arbitrary_H_not_source_justified_without_independence_theorem",
  "source_dependency_class": "qbe_local_finite_matrix_bridge_or_source_translation_gap",
  "lean_parse_ok": "markdown_only_no_lean_edit",
  "lean_build_ok": "true_current_middle_gate",
  "finite_matrix_ok": "not_closed; no H-independence theorem named",
  "block_entry_ok": false,
  "ancilla_cleanup_ok": "not_promoted",
  "normalizer_ok": "unchanged",
  "closed_theorem_ok": false,
  "error_class": "source_translation_gap",
  "secondary_error_class_if_source_shaped_finite_algebra_only": "symbolic_bridge_gap",
  "secondary_error_class_if_hfree_route_reassigned": "shape_or_register_gap",
  "next_route": "prove ActivePreparedInterface(H) by a strict finite matrix-entry theorem, prove an arbitrary-H independence lemma, or route the target back to middle for a contract-specific source-backed restatement; do not add wrappers or standalone H-free diagnostics"
}
```

Useful checks now are Lean parser/build checks after a narrow
`RobinMatrix.lean` edit, source-shaped active/prepared finite matrix checks,
and a focused independence check for the selected prepared clean entry.  The
Shukla--Vedula cited row remains `contract-only`; it supplies the clean-column
contract only and does not prove active/prepared equality, product equality,
LCU, block projection, normalized equality, circuit unitarity, block
correctness, or final extraction.

Middle gate result for this normalization: `python3 tools/qbe.py check`,
`lake build`, and `lake build Tests` passed.  The known diagnostic `sorry`
warnings remain at `QuantumBlockEncoding/RobinMatrix.lean:24254` and
`QuantumBlockEncoding/RobinMatrix.lean:24285`.

## 2026-06-13 Middle Source-Prepared Finite Composition Reassignment

The run `20260613-045026-QBE-AUTO-002-cycle01` accepts lower2/lower3 feedback
on `evaluated_backend_fold_leaf`: direct H-free evaluated backend-fold closure
is a `shape_or_register_gap` as the default route.  The active lower target is
the source-prepared finite composition field, with the evaluated fold recovered
only after that field closes through the existing `Uniform(H)` contract.

```json
{
  "task": "QBE-AUTO-002",
  "run_id": "20260613-045026-QBE-AUTO-002-cycle01",
  "leaf": "source_prepared_finite_composition_leaf",
  "supersedes_leaf": "direct_hfree_evaluated_backend_fold_as_default_lower_target",
  "source_correspondence_ok": "true_for_source_prepared_route_with_explicit_Uniform_contract",
  "source_dependency_class": "internal_qbe_local_finite_circuit_matrix_composition",
  "lean_parse_ok": "markdown_and_json_only_no_lean_edit",
  "lean_build_ok": true,
  "finite_matrix_ok": "partial_lower2_lower3_rejected_direct_hfree_slot_route",
  "block_entry_ok": false,
  "ancilla_cleanup_ok": "not_promoted",
  "normalizer_ok": "unchanged",
  "closed_theorem_ok": false,
  "error_class": "shape_or_register_gap",
  "error_class_context": "superseded_hfree_route_as_default_target",
  "next_error_class_if_source_shaped_but_unproved": "symbolic_bridge_gap",
  "next_error_class_if_arbitrary_H_shape_blocks": "source_translation_gap",
  "next_route": "prove SourcePreparedField(H, env), an equivalent active/prepared field, or one strict finite source-shaped feeder; recover evaluated backend fold only through existing hUniform bridges"
}
```

Useful checks now are source-shaped active/prepared finite matrix checks and
Lean parser/build checks after a narrow `RobinMatrix.lean` edit.  The
Shukla--Vedula cited row remains `contract-only`; it supplies the clean-column
contract only and does not prove active/prepared equality, product equality,
LCU, block projection, normalized equality, circuit unitarity, block
correctness, or final extraction.

Middle gate result for this reassignment: `python3 tools/qbe.py check`,
`lake build`, and `lake build Tests` passed, with only the known diagnostic
`sorry` warnings at `QuantumBlockEncoding/RobinMatrix.lean:24282` and
`QuantumBlockEncoding/RobinMatrix.lean:24313`.

## 2026-06-13 Middle Coordinator Feedback For Source-Prepared Finite Composition

Run `20260613-050943-QBE-AUTO-002-cycle01` keeps
`source_prepared_finite_composition_leaf` active.  The middle packet does not
edit Lean.  It records lower3's warning that arbitrary-`H` source-prepared
closure must be a genuine finite composition or independence theorem; if the
proof needs the paper clean-column contract, lower2 should stop with
`source_translation_gap` for a middle restatement instead of adding a local
hypothesis.

```json
{
  "task": "QBE-AUTO-002",
  "run_id": "20260613-050943-QBE-AUTO-002-cycle01",
  "leaf": "source_prepared_finite_composition_leaf",
  "supersedes_leaf": "direct_hfree_evaluated_backend_fold_as_default_lower_target",
  "source_correspondence_ok": "true_for_source_prepared_route_with_explicit_Uniform_contract; arbitrary_H_closure_requires_finite_independence_or_middle_restatement",
  "source_dependency_class": "qbe_local_finite_circuit_matrix_composition",
  "lean_parse_ok": "markdown_and_json_only_no_lean_edit",
  "lean_build_ok": "not_applicable_markdown_and_json_only_no_lean_edit; full_gate_required_for_run",
  "finite_matrix_ok": "partial_lower3_source_shape_checks_passed",
  "block_entry_ok": false,
  "ancilla_cleanup_ok": "not_promoted",
  "normalizer_ok": "unchanged_not_promoted",
  "closed_theorem_ok": false,
  "error_class": "symbolic_bridge_gap",
  "secondary_error_class_if_arbitrary_H_requires_uniform_contract": "source_translation_gap",
  "secondary_error_class_if_hfree_route_reassigned": "shape_or_register_gap",
  "next_route": "prove SourcePreparedField(H, env), an accepted equivalent active/prepared target, the cached PreparedCircuitEntryTarget equality, or one strict finite source-shaped theorem feeding those statements"
}
```

The next lower2 write scope remains only `QuantumBlockEncoding/RobinMatrix.lean`.
The direct H-free evaluated fold, raw `Coeff` equality, diagnostic `sorry`
route, obstruction handles, feeder equivalences, backend slot/support work,
branch-sum wrappers, and H-free selected-slot diagnostics remain retired.

Middle gate result for this coordinator packet: `python3 tools/qbe.py check`,
`lake build`, and `lake build Tests` passed, with only the known diagnostic
`sorry` warnings at `QuantumBlockEncoding/RobinMatrix.lean:24282` and
`QuantumBlockEncoding/RobinMatrix.lean:24313`.

## 2026-06-13 Middle Source-Prepared Contract Clarification

Run `20260613-052836-QBE-AUTO-002-cycle01` keeps
`source_prepared_finite_composition_leaf` active and records the current source
audit limitation: the configured local GHL2025 TeX archive was unavailable, so
middle used the checked-in conversion window, proof obligations, Fig. 4 audit,
and cited-results ledger as the contract source.  The active target remains
source-shaped; no theorem, oracle, normalizer, or semantic flag is promoted.

```json
{
  "task": "QBE-AUTO-002",
  "run_id": "20260613-052836-QBE-AUTO-002-cycle01",
  "leaf": "source_prepared_finite_composition_leaf",
  "source_archive_available": false,
  "source_correspondence_ok": "checked_against_repository_source_maps; no_fresh_local_tex_reread_available",
  "source_dependency_class": "qbe_local_finite_circuit_matrix_composition_with_external_clean_column_contract_downstream",
  "lean_parse_ok": "markdown_and_json_only_no_lean_edit",
  "lean_build_ok": "pending_current_middle_gate",
  "finite_matrix_ok": "not_closed; lower3_source_shape_checks_remain_partial",
  "block_entry_ok": false,
  "ancilla_cleanup_ok": "not_promoted",
  "normalizer_ok": "unchanged_not_promoted",
  "closed_theorem_ok": false,
  "error_class": "symbolic_bridge_gap",
  "secondary_error_class_if_uniform_required_for_arbitrary_H": "source_translation_gap",
  "secondary_error_class_if_hfree_route_reassigned": "shape_or_register_gap",
  "next_route": "lower2 proves SourcePreparedField(H, env), UncastActivePrepared(H, env), CachedPreparedEntry(H), or one strict finite source-shaped theorem feeding those statements without adding Uniform(H) to the arbitrary-H target"
}
```

Useful checks are Lean parser/build checks after a narrow
`QuantumBlockEncoding/RobinMatrix.lean` edit, plus source-shaped finite
active/prepared composition or clean-column-independence diagnostics.  If every
source-shaped route needs the paper clean-column contract, the target returns
to middle as `source_translation_gap`; lower2 must not add `Uniform(H)` to the
current arbitrary-`H` theorem.
