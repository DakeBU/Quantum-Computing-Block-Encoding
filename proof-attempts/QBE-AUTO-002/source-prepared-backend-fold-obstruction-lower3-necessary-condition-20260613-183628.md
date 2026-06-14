# Lower3 Necessary-Condition Check: backend-fold obstruction

Task: `QBE-AUTO-002`
Run: `20260613-182230-QBE-AUTO-002-cycle01`
Leaf: `branch_correct_evaluated_backend_fold_obstruction`
Profile: necessary-condition verifier

## Active Leaf

Checked the obstruction retarget from
`proof-attempts/QBE-AUTO-002/source-prepared-backend-fold-obstruction-middle-packet-20260613-182230.md`.

The diagnostic is necessary because lower2 is now meant to formalize one
obstruction leaf, not spend proof search on the retired theorem

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

or on the retired direct row-`0` to selected slot-`2` feeder.  If the compiled
finite matrix normal form already forces selected-slot vanishing, then a
nonzero selected-slot witness is the right next proof object and the old root
must remain rejected.

## Lean-Local Diagnostics Used

No theorem-facing Lean declarations were edited.  Existing compiled diagnostics
are sufficient:

- `oneTermRobinGamma3BoundaryActiveEvalColumn0_zero_n3`: the H-free active
  row-`0` entry evaluates to `0`.
- `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3`:
  the evaluated seven-slot backend fold collapses to the selected slot-`2`
  contribution after nonselected branch vanish lemmas.
- `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_selectedSlotContributionEval_zero_n3`:
  the retired root fold is equivalent to selected-slot contribution vanishing.
- `oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3`: the active
  full index is `0`, while the selected slot-`2` contribution uses full index
  `32`; this keeps the direct feeder classified as a register-shape gap.
- `oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_n3`:
  the selected slot-`2` seven-gate entry evaluates to
  `(env "f_3_0" * env "N_f_inv") * env "boundary_cos_half_0_2"`.

## Finite/Support Shape

The proposed lower2 nonzero witness uses only

```lean
oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution
```

and not the H-free active row-`0` entry.  That is the correct obstruction
shape: it formalizes that the selected backend branch is a nonzero branch
contribution under a concrete environment, while the retired root would force
the same selected contribution to be zero.

For the old root fold:

- active side: H-free signal-zero row-`0` entry, evaluated to `0`;
- backend side: full seven-slot backend fold, evaluated to the selected
  slot-`2` contribution;
- normal form: a proof of the old all-env root fold implies
  `SelectedSlot(env) = 0`.

The `hUniform` clean-column contract remains downstream-only through source
prepared recovery.  It is not part of the H-free obstruction theorem and should
not be inserted into either the nonzero witness or the old fold normal form.

## Rejection

Reject any lower2 route that tries to prove the retired root fold directly, or
that revives

```lean
oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3
```

as a strict feeder.  The old root is a `finite_matrix_counterexample`; the
direct row-`0` to selected slot-`2` feeder remains a `shape_or_register_gap`.

The next narrow route is to formalize exactly one obstruction leaf:
prefer `oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3`;
use `oneTermRobinGamma3BoundaryEvaluatedBackendFold_forces_selectedSlotContribution_zero_n3`
only as the fallback route guard.

## Typed Feedback

```json
{
  "leaf": "branch_correct_evaluated_backend_fold_obstruction",
  "source_correspondence_ok": false,
  "finite_matrix_ok": false,
  "block_entry_ok": false,
  "preferred_lower2_leaf": "oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3",
  "fallback_lower2_leaf": "oneTermRobinGamma3BoundaryEvaluatedBackendFold_forces_selectedSlotContribution_zero_n3",
  "retired_root": "oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env",
  "retired_hfree_feeder": "shape_or_register_gap",
  "hUniform_position": "downstream_only",
  "error_class": "finite_matrix_counterexample",
  "next_route": "formalize one obstruction leaf, then restate the source-prepared target before any renewed fold proof search"
}
```
