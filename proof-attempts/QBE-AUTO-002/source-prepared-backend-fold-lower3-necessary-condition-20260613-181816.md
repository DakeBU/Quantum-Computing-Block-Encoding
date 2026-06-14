# Lower3 Necessary-Condition Check: source-prepared backend fold

Task: `QBE-AUTO-002`
Run: `20260613-180059-QBE-AUTO-002-cycle01`
Leaf: `branch_correct_evaluated_backend_fold`
Profile: necessary-condition verifier

## Active Leaf

Checked the current branch-correct backend-fold target:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

with the uncast form:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders
      (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3) =
Coeff.evalWith env
  (blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

This diagnostic is a necessary condition for the leaf because lower2 should
not try to prove an all-environments equality if the finite path/support
semantics already reduce it to a contradictory scalar condition.

## Lean-Local Diagnostics Used

No theorem-facing Lean declarations were edited. Existing compiled diagnostics
are sufficient:

- `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3`:
  the fold target is the uncast active row-`0` entry against the full backend
  branch fold.
- `oneTermRobinGamma3BoundaryActiveEvalColumn0_zero_n3`: the active H-free
  row-`0` entry evaluates to `0`.
- `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3`:
  the evaluated full seven-slot backend fold collapses to the selected slot-`2`
  contribution after the compiled nonselected vanish lemmas.
- `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_selectedSlotContributionEval_zero_n3`:
  the current evaluated fold is equivalent to
  `selectedSlotContribution(env) = 0`.
- `oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3`: active full
  index `0` and selected slot-`2` full index `32` are distinct.
- `oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_n3`:
  the selected slot-`2` seven-gate entry evaluates to
  `(env "f_3_0" * env "N_f_inv") * env "boundary_cos_half_0_2"`.

## Finite/Support Shape

The target has the right high-level source name, because it uses the full
backend branch fold rather than only `selectedSlotContribution`.  The finite
matrix check still fails in the current Lean instance:

- active side: H-free signal-zero full index `0`, a row-`0` two-path tail-kill
  diagnostic with evaluation `0`;
- backend side: full seven-slot fold, but the compiled support lemmas collapse
  it to selected sparse slot `2` at full index `32`;
- normal form: proving the fold for every `env` is equivalent to proving the
  selected slot-`2` contribution evaluates to `0` for every `env`.

Under the all-one symbolic environment for `f_3_0`, `N_f_inv`,
`boundary_cos_half_0_2`, and `sqrt_kappa_inv`, the selected slot-`2` branch
formula evaluates to `1`, while the active side evaluates to `0`.  This
contradicts the current all-env target.

## Rejection

Reject the current lower2 assignment if it is literally:

```lean
theorem ... (env : String -> Rat) :
  oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env := ...
```

or the uncast `ActiveEntry(env) = BackendFold(env)` theorem with no additional
source-backed repair.  This is a `finite_matrix_counterexample`, not a tactic
gap.

The already retired direct row-`0` to selected slot-`2` feeder remains a
`shape_or_register_gap`.  An arbitrary-`H` active/prepared closure without a
concrete source-prepared bridge should also stay rejected as
`source_translation_gap`.

## Typed Feedback

```json
{
  "leaf": "branch_correct_evaluated_backend_fold",
  "source_correspondence_ok": false,
  "finite_matrix_ok": false,
  "block_entry_ok": false,
  "active_entry_eval": "0",
  "backend_fold_eval": "selectedSlotContribution",
  "fold_equivalence_guard": "oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_selectedSlotContributionEval_zero_n3",
  "retired_hfree_feeder": "shape_or_register_gap",
  "error_class": "finite_matrix_counterexample",
  "next_route": "repair the source contract or proof-DAG leaf before lower2 proof search; do not prove the current all-env row-0/full-fold theorem"
}
```
