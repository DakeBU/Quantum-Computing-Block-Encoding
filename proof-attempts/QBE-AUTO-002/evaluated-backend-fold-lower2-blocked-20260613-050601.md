# QBE-AUTO-002 Lower2 Blocked Attempt: Evaluated Backend Fold

Run: `20260613-045026-QBE-AUTO-002-cycle01`

Leaf: `evaluated_backend_fold_leaf`

Target:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

Equivalent uncast target exposed by
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env`:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3) =
Coeff.evalWith env
  (blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

## Result

No Lean declaration was edited.  I did not add a wrapper theorem because the
nearby file already contains the direct evaluated-fold bridges and expanded
slot-zero exposure:

- `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3`
- `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesExpandedSlotZeroFold_n3`
- `oneTermRobinGamma3BoundaryEvaluatedBackendFold_of_backendExpansion_n3`
- `oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3`

The open theorem is not a local tactic gap in these wrappers.  The remaining
equality is the finite product/projection theorem equating the active H-free
signal-zero entry with the backend/prepared seven-slot fold.  The active side
still exposes the seven-gate `[0,0]` entry without `H_W^(kappa)` side gates,
while the source-prepared route needs the existing all-slot clean-column
contract before the prepared clean entry specializes to the backend fold.

The retired route through
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` and
`oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` remains
`sorry`-guarded diagnostic memory and was not used.

## Typed Verifier Feedback

```text
leaf=evaluated_backend_fold_leaf
source_correspondence_ok=true_for_current_evaluated_fold_leaf
lean_parse_ok=true_no_lean_edit
lean_build_ok=true
finite_matrix_ok=partial_backend_fold_collapses_to_slot2; active_hfree_side_exposes_expanded_slot0_shape
block_entry_ok=false
ancilla_cleanup_ok=not_promoted
normalizer_ok=unchanged
closed_theorem_ok=false
error_class=shape_or_register_gap
next_route=prove the source-correct finite product/projection theorem, preferably oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement or a strict Coeff.evalWith product/projection lemma that directly implies oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env; do not reassign the diagnostic raw Coeff constructor route
```

## Gate

Passed after this artifact was written:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```

Known pre-existing diagnostic sorries remain at
`QuantumBlockEncoding/RobinMatrix.lean:24282` and
`QuantumBlockEncoding/RobinMatrix.lean:24313`.
