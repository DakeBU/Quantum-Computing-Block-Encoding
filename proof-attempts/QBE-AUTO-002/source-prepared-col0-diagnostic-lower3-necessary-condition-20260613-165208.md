# Lower3 Necessary-Condition Check: source-prepared column-0 diagnostic

Task: `QBE-AUTO-002`  
Run: `20260613-163714-QBE-AUTO-002-cycle01`  
Leaf: `active_eval_gate_matrices_column0_bridge`  
Profile: necessary-condition verifier

## Active Leaf

Checked the guard leaf:

```lean
oneTermRobinGamma3BoundaryEvalGateMatricesColumn0Entry_eq_sevenGateMatrix_n3
```

This diagnostic is necessary because the active side of the current
source-prepared frontier still exposes the H-free active `evalGateMatrices`
entry at full-basis `[0,0]`.  Before any worker uses that entry in a
source-shaped proof, lower2 needs the narrow evaluated bridge from
`evalGateMatrices[0,0]` to the explicit seven-gate `[0,0]` matrix entry.

## Existing Lean-Local Evidence

No theorem-facing Lean declaration was edited.  Existing compiled declarations
already give the finite support shape:

- `oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3` separates the
  active full-basis index `0` from the selected full-basis index `32`.
- `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3` maps selected
  sparse slot `2` to full index `32`.
- `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` shows the explicit
  seven-gate `[0,0]` entry has two `R_y` branches through `O_f[12,96]` and
  `O_f[12,97]`.
- `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3` and
  `oneTermRobinGamma3BoundaryActiveColumn0TailKillNormalForm_n3` show both
  active column-`0` tails vanish in the current finite witness.
- `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3`
  collapses the backend fold to the selected slot-`2` contribution, not to the
  active slot-`0` entry.
- `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3`
  exposes the source-shaped active/prepared comparison that remains open.

## Necessary-Condition Verdict

Reject any revived proof of
`ActiveEval(env) = selectedSlotContribution(env)` as the next lower2 target.
It compares different finite paths:

```text
left:  active H-free full-basis [0,0], slot 0, explicit seven-gate value 0
right: selected sparse slot 2, full index 32, projection-weighted backend branch
```

The next narrow route is only the guard
`ActiveEval[0,0] = explicitSevenGate[0,0]` at `Coeff.evalWith` level, without
using the sorry-guarded raw matrix equality
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`.  Passing
that guard must not be used as proof closure; it should force middle to route
the theorem-facing statement through the prepared active/prepared field under
the explicit `Uniform(H)` contract.

## Typed Feedback

```json
{
  "leaf": "active_eval_gate_matrices_column0_bridge",
  "source_correspondence_ok": true,
  "finite_matrix_ok": "checked",
  "block_entry_ok": false,
  "error_class": "shape_or_register_gap",
  "next_route": "prove only the evalWith-level ActiveEval[0,0] to explicit sevenGateMatrix[0,0] guard, then retarget through the source-prepared active/prepared field under explicit Uniform(H)"
}
```
