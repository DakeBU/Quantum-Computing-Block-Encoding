# Lower3 Diagnostic: Evaluated Backend-Fold Source Bridge

Task: `QBE-AUTO-002`  
Run: `20260617-051350-QBE-AUTO-002-cycle01`  
Leaf: `evaluated_backend_fold_source_bridge`  
Role profile: necessary-condition verifier

## Necessary Condition

The active leaf was proposed as the finite evaluated active `[0,0]` equality
exposed by
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesExpandedSlotZeroFold_n3`.
This is a necessary condition for feeding the source-prepared bridge because a
proof of `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` would
be consumed by
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3`
under the explicit `hUniform` clean-column contract.

The diagnostic checks whether that H-free evaluated fold can be a valid lower2
target before any theorem-facing Lean edit.

## Executed Diagnostic

No Lean source was edited.  A Lean stdin diagnostic imported
`QuantumBlockEncoding.RobinMatrix` and checked:

1. `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesExpandedSlotZeroFold_n3`
   exposes the H-free seven-gate active entry, confirms both `H_W^(kappa)` side
   gates are absent from the active gate list, and keeps
   `evaluatedBackendFoldProved`, `rawCoeffFoldProved`,
   `productToCoefficientProved`, and `finalExtractionProved` false.
2. `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_selectedSlotContributionEval_zero_n3`
   reduces the direct evaluated fold statement to vanishing of the selected
   slot-`2` contribution.
3. `oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3`
   gives a concrete all-one selected-branch environment where that selected
   slot contribution evaluates to `1`.
4. Combining 2 and 3 proves
   `not oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` for that
   environment.
5. The generic backend expansion and projection/summation surfaces remain
   rejected by
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` and
   `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3`.

## Rejection

The direct H-free target
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` is contradicted
by the finite all-one selected-slot witness.  Lower2 should not try to prove
that statement, the raw backend-expansion parent, or the generic projection
surface in this cycle.

This does not reject the source-prepared route itself.  It rejects the current
direct H-free fold target as the active lower2 leaf.  Middle should repair the
leaf to a source-prepared field such as the raw prepared-sandwich statement or
the uncast prepared sparse-clean entry comparison, or record a source/register
contract gap before assigning another Lean edit.

## Gate

`python3 tools/qbe.py check` is run after this artifact is written.  This lower3
pass made no Lean edit.

## Typed Feedback

```text
leaf=evaluated_backend_fold_source_bridge
source_correspondence_ok=false
source_anchor_cited_ok=true
lean_parse_ok=true
finite_matrix_ok=false
block_entry_ok=false
normalizer_ok=conditional only through explicit hUniform/hND/hNF/hkappa/hkappaSqrt feeder route
closed_theorem_ok=false
error_class=finite_matrix_counterexample
next_route=lower2 should make no Lean edit for the direct H-free evaluated fold; middle/lower1 should retarget to a source-prepared finite field or record the source/register gap.
```
