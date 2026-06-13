# QBE-AUTO-002 lower2 blocked attempt: active/prepared composition interface

Run: `20260613-033618-QBE-AUTO-002-cycle01`

Leaf: `active_prepared_composition_interface_leaf`

Target:

```lean
(oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3 H).activeEntryStatement
```

Equivalent unfolded target observed by Lean:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
```

## Attempt

I checked the current middle packet and probed the exact active interface leaf
with `lake env lean --stdin`. The already compiled theorem
`oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_interfaceStatement_n3`
does reduce the record field to the prepared clean-entry equality. After
unfolding `oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3`,
`PreparedCircuitEntryTarget.entryEqualityStatement`, and
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3`, Lean's remaining goal
is exactly the prepared clean-entry equality above.

No direct theorem closes that equality. The nearby compiled declarations are
route wiring only:

- `oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_interfaceStatement_n3`
- `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_preparedCleanEntry_n3`
- `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_preparedCleanEntry_n3`
- `oneTermRobinGamma3BoundaryActivePreparedCompositeEval_of_preparedCleanEntry_n3`

Those are retired by the current middle packet and would not prove the active
leaf.

I also tried a zero-matrix counterprobe for the arbitrary-`H` shape using
`Matrix.zero 8 8 Coeff`. The probe did not produce a certificate before it was
terminated; it reduced through the same large raw `Coeff` expression family
that earlier attempts identified as nonviable for direct `native_decide`.

## Blocker

Primary blocker: `symbolic_bridge_gap`.

The source-shaped target still needs a finite `CircuitMatrixSemantics`
composition theorem equating the active seven-gate signal-zero entry with the
prepared `H_W^(kappa)^dagger * U * H_W^(kappa)` clean entry. I found no
permitted smaller Lean theorem that directly proves this field. Adding another
equivalence wrapper or obstruction record would only duplicate compiled route
wiring, and adding an assumption would violate the lower packet.

Secondary route risk: if the target is read as an arbitrary-`H` equality rather
than the paper-backed prepared-state route under the existing clean-column
contract, the issue should be classified as `shape_or_register_gap`.

## Next Route

Middle should provide one source-shaped finite matrix composition lemma for the
active seven-gate entry to prepared singleton clean entry, or reassign the
evaluated backend fold leaf with an explicit product/path decomposition. Lower2
should not spend another cycle on wrappers around the active/prepared interface
or on the retired H-free diagnostic fold.

## Gate

Passed:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```

Known diagnostic sorries remain at `QuantumBlockEncoding/RobinMatrix.lean:24254`
and `QuantumBlockEncoding/RobinMatrix.lean:24285`; no new Lean source was edited
in this attempt.
