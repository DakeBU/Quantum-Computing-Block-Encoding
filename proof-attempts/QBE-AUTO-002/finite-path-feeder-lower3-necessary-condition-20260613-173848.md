# Lower3 Necessary-Condition Check: finite path feeder

Task: `QBE-AUTO-002`
Run: `20260613-172255-QBE-AUTO-002-cycle01`
Leaf: `finite_path_feeder`
Profile: necessary-condition verifier

## Active Leaf

Checked the proposed strict feeder:

```lean
theorem oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3
    (env : String -> Rat) :
    Coeff.evalWith env
      ((evalGateMatrices
        (GHL2025.oneTermRobinGateMatrixPlaceholders
          (oneTermParameters 3)))
        oneTermRobinGamma3BoundaryPrefixRow0_n3
        oneTermRobinGamma3BoundaryPrefixRow0_n3) =
    Coeff.evalWith env
      oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution
```

This is a necessary condition for the finite-path feeder leaf because lower2
would otherwise try to prove a direct all-environments equality between the
active signal-zero entry and the selected backend sparse-slot contribution.
The finite path and support shape must agree before a large `evalWith` proof is
useful.

## Lean-Local Diagnostics Used

No Lean declaration was edited. Existing compiled diagnostics are enough:

- `oneTermRobinGamma3BoundaryActiveEvalColumn0_zero_n3`: the active
  `evalGateMatrices[0,0]` entry evaluates to `0`.
- `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3`: the explicit
  active seven-gate `[0,0]` entry is a two-path expression through
  `O_f[12,96]` and `O_f[12,97]`.
- `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3`: both active tails
  vanish.
- `oneTermRobinGamma3BoundarySevenGateColumn0UsesSlot0_notGamma3Slot2_n3`: the
  active path uses slot-`0` symbols, not the displayed gamma3 slot-`2` symbols.
- `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`: selected
  sparse slot `2` maps to full index `32`.
- `oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3`: the selected
  contribution is `oneTermRobinGamma3BoundarySevenGateMatrix_n3[32,32] *
  sqrt_kappa_inv * sqrt_kappa_inv`.
- `oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_n3`: the
  slot-`2` branch entry `[32,32]` evaluates to
  `(f_3_0 * N_f_inv) * boundary_cos_half_0_2`.
- `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3`:
  the backend seven-slot fold collapses to the selected slot after the compiled
  nonselected-slot vanish lemmas.

## Finite Path Shape

`R_y` is not unique-column in the current implementation.

For the active `[0,0]` path, `R_y` has two rows, `0` and `1`; `O_D^BS` maps
them to rows `96` and `97`; the suffix then reaches the two function-oracle
entries `O_f[12,96]` and `O_f[12,97]`, both zero. Thus the active entry is a
two-path-with-tail-kill diagnostic and evaluates to `0`.

For the selected source/backend slot, sparse slot `2` maps to full index `32`.
The selected contribution is the `[32,32]` seven-gate branch with two
`sqrt_kappa_inv` projection factors. Its evaluated branch entry exposes
`(f_3_0 * N_f_inv) * boundary_cos_half_0_2`, not the active slot-`0` tail.

Consequently, the direct strict feeder compares different finite objects:

```text
lhs: active signal-zero full index 0, slot-0 two-path tail-kill, value 0
rhs: selected sparse slot 2, full index 32, branch product with projection factors
```

Under the all-one symbolic environment for `f_3_0`, `N_f_inv`,
`boundary_cos_half_0_2`, and `sqrt_kappa_inv`, the selected branch formula
evaluates to `1`, while the active side evaluates to `0`. This rejects the
direct all-env feeder as a lower2 theorem target.

## Rejection

Reject `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3` as currently
stated for direct lower2 proof search. The error is a `shape_or_register_gap`:
the target bypasses the missing finite projection/summation theorem that must
identify the signal-zero block entry with the seven-slot backend fold.

The source-prepared route itself is not rejected. It remains usable only after a
branch-correct theorem proves `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`,
which can then be consumed through
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3
H env hUniform hFold`.

## Typed Feedback

```json
{
  "leaf": "finite_path_feeder",
  "source_correspondence_ok": false,
  "finite_matrix_ok": false,
  "block_entry_ok": false,
  "path_indices_mapped": true,
  "ry_branch_shape": "two_path",
  "of_branch_shape": "two_path",
  "raw_coeff_route_rejected": true,
  "error_class": "shape_or_register_gap",
  "next_route": "prove the missing finite projection/summation bridge for signal-zero [0,0] as the seven-slot backend fold, or consume the source-prepared bridge only after evaluatedBackendFold is obtained by a branch-correct theorem"
}
```
