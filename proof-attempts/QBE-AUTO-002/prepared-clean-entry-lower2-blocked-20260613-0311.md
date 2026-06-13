# QBE-AUTO-002 Lower2 Attempt: Prepared Clean-Entry Leaf

Run: `20260613-024914-QBE-AUTO-002-cycle01`

Leaf: `prepared_clean_entry_leaf`

Target:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
```

## Attempt

I searched the current `QuantumBlockEncoding/RobinMatrix.lean` route before
adding a theorem.  The exact clean-entry equality is carried by
`oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3 H`, and the
prepared sparse matrix clean entry unfolds to
`oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3 H`.

The direct theorem is still blocked: for arbitrary `H`, the right-hand side is
the source-prepared sandwich entry, while the active left-hand side is the
seven-gate signal-zero entry.  The available
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` contract
specializes the prepared side to the backend fold, but it does not by itself
prove the active seven-gate entry equals the prepared sandwich entry.  Proving
through `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` would use the
known diagnostic `sorry` route, so I did not use it for theorem closure.

## Compiled Output

Added:

```lean
oneTermRobinGamma3BoundaryPreparedCleanEntryLeaf_obstruction_n3
```

This theorem compiles and records that the exact `PreparedCleanEntry(H)` leaf
is the interface field
`(oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3 H).activeEntryToPreparedEntryStatement`,
while `activePreparedEntryEqualityProved = false`.  It is an obstruction handle,
not a proof of the equality.

## Remaining Lean Goal

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
```

or equivalently:

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

## Verifier Feedback

```text
leaf=prepared_clean_entry_leaf
source_correspondence_ok=true_source_prepared_route
lean_parse_ok=true
lean_build_ok=true_local_file
finite_matrix_ok=not_closed_exact_active_prepared_composition
block_entry_ok=false
ancilla_cleanup_ok=not_promoted
normalizer_ok=unchanged
closed_theorem_ok=false
error_class=symbolic_bridge_gap
next_route=prove the finite CircuitMatrixSemantics composition theorem connecting the active seven-gate signal-zero entry to the prepared H_W^(kappa)^dagger * U * H_W^(kappa) clean entry; do not use the diagnostic H-free sorry route
```
