# QBE-AUTO-002 Lower2 Blocked Attempt: Evaluated Backend Fold

Run: `20260613-042537-QBE-AUTO-002-cycle01`

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

No Lean declaration was edited.  The route is blocked as a register/shape
frontier, not as a local tactic gap.

The active side of the uncast evaluated fold is still the H-free active
seven-gate `[0,0]` entry.  Existing compiled diagnostics show this route exposes
the active column-`0` packet:

- `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesUncastSevenGate_n3`
- `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesExpandedSlotZeroFold_n3`
- `oneTermRobinGamma3BoundarySevenGateColumn0UsesSlot0_notGamma3Slot2_n3`

The backend/source-prepared side remains the selected slot-`2` prepared branch:

- `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3`
- `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`
- `oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3`

Thus a direct lower proof of the H-free evaluated fold would need a new
source-correct finite `CircuitMatrixSemantics` composition theorem that relates
the active signal-zero entry to the prepared singleton clean entry.  Reopening
the retired raw constructor route would only reuse the stale diagnostic
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` /
`oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`, which the current
packet forbids.

## Typed Verifier Feedback

```text
leaf=evaluated_backend_fold_leaf
source_correspondence_ok=conditional_source_prepared_route_requires_existing_hUniform_and_missing_active_prepared_composition_field
lean_parse_ok=true_no_lean_edit
lean_build_ok=true
finite_matrix_ok=partial_backend_fold_collapses_to_slot2; active_hfree_side_exposes_slot0_diagnostic
block_entry_ok=false
ancilla_cleanup_ok=not_promoted
normalizer_ok=unchanged
closed_theorem_ok=false
error_class=shape_or_register_gap
next_route=middle should supply or assign the source-correct active/prepared CircuitMatrixSemantics composition theorem; do not reassign raw constructor equality or H-free active-selected diagnostics
```

## Gate

Passed:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```

The known pre-existing diagnostic sorries remain at
`QuantumBlockEncoding/RobinMatrix.lean:24282` and
`QuantumBlockEncoding/RobinMatrix.lean:24313`.
