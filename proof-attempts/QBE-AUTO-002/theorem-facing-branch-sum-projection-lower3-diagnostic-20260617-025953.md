# Lower3 Diagnostic: Branch-Sum Projection Leaf

Task: `QBE-AUTO-002`
Run: `20260617-024407-QBE-AUTO-002-cycle01`
Role: lower3 necessary-condition verifier
Time: `2026-06-17 02:59:53 JST`

## Active Leaf

The active leaf checked here is `theorem_facing_branch_sum_projection_leaf`.
Middle named the preferred Lean surface as:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement
```

This diagnostic is necessary because `CircuitSemantics` proves that a
`BlockExtractionBranchContributionTarget.projectionSummationStatement` is
equivalent to its `backendExpansionStatement`.  For the current Robin target,
that backend expansion is already guarded by the compiled no-go theorem:

```lean
oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3
```

Therefore lower2 must not spend proof search on the currently named branch-sum
surface unless middle changes the target to a source-correct projection field.

## Lean-Local Diagnostic

The following temporary stdin diagnostic passed after rebuilding
`QuantumBlockEncoding.RobinMatrix` and opening
`QuantumBlockEncoding.Examples.RobinHeat`:

```lean
import QuantumBlockEncoding.RobinMatrix

open QuantumBlockEncoding
open QuantumBlockEncoding.Examples.RobinHeat

#check oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3
#check BlockExtractionBranchContributionTarget.backendExpansionStatement_of_projectionSummationStatement
#check oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3
#check oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3

example :
    ¬ oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement := by
  intro hprojection
  exact oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3
    (BlockExtractionBranchContributionTarget.backendExpansionStatement_of_projectionSummationStatement
      oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3 hprojection)

example :
    let active := oneTermRobinGamma3BoundaryPrefixRow0_n3
    let selected :=
      oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3
        oneTermRobinGamma3BoundaryBranchContributionFocusedSlot
    active.val = 0 ∧ selected.val = 32 ∧ active ≠ selected := by
  have h := oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3
  dsimp at h ⊢
  exact ⟨h.1, h.2.1, h.2.2.1⟩
```

The second example only calibrates the finite register shape: active full index
`0`, selected branch full index `32`, and different active/selected indices.
It does not rescue the target equality, because the first example refutes the
named projection-summation statement through the existing no-go guard.

## Verdict

Reject the current lower2 target
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement`.
The finite/path check contradicts it: proving this statement would prove the
forbidden H-free backend expansion.

The source object remains valid, but the Lean surface should be repaired.  The
next route is a source-correct theorem-facing projection/summation statement
whose block entry is the prepared singleton or active/prepared projection
field, or a smaller typed obstruction naming the missing finite
active/prepared composition bridge.

## Typed Feedback

```json
{
  "leaf": "theorem_facing_branch_sum_projection_leaf",
  "source_correspondence_ok": false,
  "finite_matrix_ok": false,
  "block_entry_ok": false,
  "register_shape_ok": true,
  "error_class": "finite_matrix_counterexample",
  "next_route": "Retarget away from BackendBranchTarget.projectionSummationStatement/backendExpansionStatement to a source-correct theorem-facing prepared or active-prepared projection field."
}
```
