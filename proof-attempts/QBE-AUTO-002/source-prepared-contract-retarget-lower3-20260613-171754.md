# Lower3 Necessary-Condition Diagnostic: Source-Prepared Contract Retarget

Task: `QBE-AUTO-002`  
Run: `20260613-170242-QBE-AUTO-002-cycle01`  
Leaf: `source_prepared_contract_retarget`

## Active Leaf

The active leaf is the source-prepared retarget from the full GHL2025 Fig.
`fig:1 term ROBIN` route to the prepared singleton clean-entry interface.  The
necessary condition is finite-path separation: the theorem-facing route must
not identify the H-free active full index `0` entry with the selected sparse
slot `2` branch at full index `32`.

This check protects the next Lean worker from proving the retired strict feeder

```lean
ActiveEval(env) =
  Coeff.evalWith env
    oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution
```

as if it were the source-prepared projection target.

## Executable/Lean-Local Diagnostic

No new Lean declaration was needed.  The diagnostic uses existing compiled
facts:

- `oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3`: active full
  index `0`, selected sparse slot `2`, selected full index `32`, and
  `active != selected`.
- `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` and
  `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3`: active column `0`
  follows a two-path `R_y` tail and both `O_f` tails vanish.
- `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`: the H-free
  seven-gate backend list omits both `H_W^(kappa)` side gates.
- `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3`:
  the current source-prepared field still exposes the H-free active side and
  the prepared sandwich side as an obligation, not a theorem closure.

## Verdict

The source-prepared retarget is shape-valid as a proof-DAG leaf: it keeps
`Uniform(H)` explicit and selects the prepared singleton clean entry as the
theorem-facing object.  The H-free row0-to-slot2 route remains rejected as
`shape_or_register_gap`.

Typed feedback:
`verifier-feedback/QBE-AUTO-002/source-prepared-contract-retarget-lower3-20260613-171754.json`.

Next lower2 route: prove exactly one small leaf, either
`oneTermRobinGamma3BoundaryActiveEvalColumn0_zero_n3 env` as a diagnostic
guard or one branch-correct source-prepared sparse-clean feeder exposed by
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3 H env`.
