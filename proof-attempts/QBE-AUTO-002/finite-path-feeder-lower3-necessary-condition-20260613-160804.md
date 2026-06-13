# Lower3 Necessary-Condition Check: finite path feeder

Task: `QBE-AUTO-002`
Run: `20260613-155325-QBE-AUTO-002-cycle01`
Leaf: `finite_path_feeder`
Profile: necessary-condition verifier

## Active Leaf

Checked the proposed strict feeder:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders
      (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3) =
Coeff.evalWith env
  oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution
```

This is a necessary-condition check because lower2 would spend proof search
trying to identify the active signal-zero `[0,0]` entry with the selected
backend slot-`2` contribution.  The finite support shape must agree before any
large `evalWith` product proof is useful.

## Lean-Local Diagnostics Used

No theorem-facing Lean declaration was edited.  Existing diagnostics already
separate the two finite paths:

- `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`: selected
  backend branch is sparse slot `2`, full index `32`.
- `oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3_transcript`:
  `selectedSlotContribution` is
  `oneTermRobinGamma3BoundarySevenGateMatrix_n3[32,32] *
  sqrt_kappa_inv * sqrt_kappa_inv`.
- `oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_n3`:
  the explicit seven-gate `[32,32]` branch evaluates to
  `(f_3_0 * N_f_inv) * boundary_cos_half_0_2`.
- `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3`: the explicit
  seven-gate `[0,0]` branch is a slot-`0` two-path expression through
  `O_f[12,96]` and `O_f[12,97]`.
- `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3`: that explicit
  `[0,0]` seven-gate entry evaluates to `0`.
- `oneTermRobinGamma3BoundaryActiveSelectedSlotComparison_diagnosticSevenGateObstruction_n3`:
  if the active `evalGateMatrices` entry is forced through the diagnostic
  seven-gate matrix identity, the strict feeder forces the selected slot-`2`
  contribution to evaluate to `0`.

The last step must not be used as proof closure because
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` is still a
diagnostic/sorry bridge.  It is, however, enough to reject the current feeder
shape as the next lower2 target.

## Support Shape

For the source-selected boundary branch `[32,32]`, `R_y` is not a unique-column
step.  The compiled path uses a two-branch shape at rows `32` and `33`, with the
adjacent branch killed by downstream support when targeting row `32`.

For the active `[0,0]` branch, `R_y` is also two-path through rows `0` and `1`,
then `O_D^BS` maps those paths to rows `96` and `97`.  The suffix routes through
function-oracle entries `O_f[12,96]` and `O_f[12,97]`, both zero in the current
finite witness, so the explicit seven-gate `[0,0]` entry vanishes.

Thus the preferred strict feeder compares different branch indices:

```text
lhs: active/signal row 0, slot 0 diagnostic path, explicit seven-gate value 0
rhs: selected backend slot 2, full index 32, nonzero-formula branch product
```

## Rejection

Reject the strict feeder as currently stated for lower2.  It conflates the
active `[0,0]` diagonal entry with the selected slot-`2` branch contribution.
Middle should repair the source contract/proof-DAG leaf before assigning a
proof attempt.

Narrow next route: prove or restate the missing finite projection/summation
theorem that expands the signal-zero entry as the seven-slot fold, or route
through the source-prepared `hUniform` bridge.  Do not ask lower2 to prove
`evalGateMatrices[0,0] = selectedSlotContribution` directly.

## Gate

`python3 tools/qbe.py check` passed after this artifact was added, with the
known diagnostic `sorry` warnings in `QuantumBlockEncoding/RobinMatrix.lean`.
