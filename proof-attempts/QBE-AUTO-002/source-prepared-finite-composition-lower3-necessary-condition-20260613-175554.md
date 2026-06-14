# Lower3 Necessary-Condition Check: source-prepared finite composition

Task: `QBE-AUTO-002`
Run: `20260613-174250-QBE-AUTO-002-cycle01`
Leaf: `source_prepared_finite_composition_leaf`
Profile: necessary-condition verifier

## Active Leaf

Checked the current source-prepared finite-composition leaf:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
```

with the uncast equivalent:

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
```

This is a necessary-condition check because lower2 should only prove an entry
comparison whose finite/register shape matches the source circuit: active
signal-zero entry on the left, prepared clean entry of the
`H_W^(kappa)^dagger * U_gamma3_boundary * H_W^(kappa)` source route on the
right. If the prepared route were only the H-free seven-gate backend component,
the active leaf would be the wrong theorem target.

## Lean-Local Diagnostics Used

No theorem-facing Lean declarations were edited. Existing compiled diagnostics
are sufficient:

- `oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3_transcript`:
  the active side is the seven-gate semantics, the prepared side is the
  singleton prepared composite, the active gate count is `7`, the prepared gate
  count is `1`, the circuits are distinct, and all theorem-facing flags remain
  false.
- `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3_transcript`:
  `preparedProjectionEntry` is the prepared singleton clean-clean entry; the
  uniform clean-column contract is explicit and unproved; the active/prepared
  equality remains false.
- `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3`:
  the active gate list has no `H_W^(kappa)` or `(H_W^(kappa))^dagger`, and the
  source field unfolds to the active `[0,0]` entry compared with the prepared
  sandwich.
- `oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_obstruction_n3`:
  the current leaf is exactly the uncast active entry compared with the
  prepared sparse clean-clean entry; the missing composition theorem and final
  proof flags remain unproved.
- `oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3` and
  `oneTermRobinGamma3BoundaryActiveSelectedSlotComparison_diagnosticSevenGateObstruction_n3`:
  the retired direct H-free row-`0` to selected slot-`2` feeder is still a
  shape/register mismatch, not the current source-prepared leaf.

## Finite/Support Shape

The source-prepared leaf passes the necessary shape guard:

- active side: signal-zero full-basis `[0,0]` entry of the H-free seven-gate
  `evalGateMatrices` product;
- prepared side: clean-clean entry of the prepared singleton semantics whose
  matrix is the sparse-register sandwich using `H` and
  `H_W^(kappa)^dagger`;
- downstream contract: `Uniform(H)` is only used to evaluate the prepared clean
  entry to the backend fold, not to prove the active/prepared finite field.

The check does not prove the block entry equality. It only confirms that the
current target is not the stale direct comparison between active full index `0`
and selected sparse slot `2` / full index `32`.

## Rejection

Reject any reassignment of lower2 back to:

```lean
oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 env
```

That feeder remains `shape_or_register_gap`. The active lower2 target should be
one source-prepared finite-composition leaf, preferably the uncast evaluated
statement or the cached `ActivePreparedEntryTarget` equality.

## Typed Feedback

```json
{
  "leaf": "source_prepared_finite_composition_leaf",
  "source_correspondence_ok": true,
  "finite_matrix_ok": true,
  "block_entry_ok": false,
  "prepared_projection_entry_selected": true,
  "prepared_route_contains_hw_sides": true,
  "active_seven_gate_hfree": true,
  "uniform_contract_downstream_only": true,
  "retired_hfree_feeder": "shape_or_register_gap",
  "error_class": "symbolic_bridge_gap",
  "next_route": "prove exactly one source-prepared active/prepared finite-composition leaf; do not revive the H-free row-0 to slot-2 feeder"
}
```
