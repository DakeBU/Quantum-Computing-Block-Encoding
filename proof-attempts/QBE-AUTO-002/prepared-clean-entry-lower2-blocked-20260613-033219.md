# QBE-AUTO-002 Lower2 Attempt: Prepared Clean-Entry Source Leaf

Run: `20260613-031339-QBE-AUTO-002-cycle01`

Leaf: `prepared_clean_entry_leaf`

## Target

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
```

Equivalent active target:

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

## Attempt

I searched the current source-prepared route in
`QuantumBlockEncoding/RobinMatrix.lean` before editing.  The exact target is
already exposed by these compiled handles:

- `oneTermRobinGamma3BoundaryPreparedCleanEntryLeaf_obstruction_n3 H`
- `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_preparedCleanEntry_n3 H`
- `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_preparedCleanEntry_n3 H`
- `oneTermRobinGamma3BoundaryActivePreparedCompositeEval_of_preparedCleanEntry_n3 H env`

Those are route wiring or obstruction handles, and the latest middle packet has
retired them as lower targets.  Adding another projection of one of these
equivalences would duplicate a retired feeder rather than close a new source
leaf.

I also tested the direct definitional route in a temporary Lean probe:

```lean
example (H : Matrix 8 8 Coeff) :
    oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
      oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
        oneTermRobinGamma3BoundarySparseCleanIndex_n3
        oneTermRobinGamma3BoundarySparseCleanIndex_n3 := by
  rfl
```

Lean rejected this with `maximum recursion depth has been reached`.  This
matches the existing obstruction: the left side is the active signal-zero
seven-gate entry, while the right side is the source-prepared
`H_W^(kappa)^dagger * U * H_W^(kappa)` clean entry.  The available
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` contract
only specializes the prepared side to the backend fold; it does not prove the
finite active/prepared `CircuitMatrixSemantics` composition theorem.

A syntactic zero-`H` counterprobe was started but terminated because decidable
equality expansion did not finish quickly.  It produced no theorem and no
counterexample certificate, so it is not used as evidence.

## Result

No Lean edit was made.  I did not add a wrapper theorem because every
compilable wrapper I found is already present and retired by the current
middle packet.  I also did not use the diagnostic H-free
`oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` route, since it is
`sorry`-guarded and explicitly stale for source-prepared closure.

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
lean_build_ok=true
finite_matrix_ok=not_closed; direct decidable counterprobe did not finish
block_entry_ok=false
ancilla_cleanup_ok=not_promoted
normalizer_ok=unchanged
closed_theorem_ok=false
error_class=symbolic_bridge_gap
next_route=prove the finite CircuitMatrixSemantics composition theorem equating the active seven-gate signal-zero entry with the prepared H_W^(kappa)^dagger * U * H_W^(kappa) clean entry; do not add another feeder around the retired equivalences
```

## Gate

Passed:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```

All three commands reported the pre-existing diagnostic `sorry` declarations
at `QuantumBlockEncoding/RobinMatrix.lean:24254` and `:24285`.
