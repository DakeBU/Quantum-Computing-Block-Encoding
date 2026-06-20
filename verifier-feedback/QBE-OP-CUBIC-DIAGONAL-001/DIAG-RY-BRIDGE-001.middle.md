# Verifier Feedback: DIAG-RY-BRIDGE-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Leaf: `DIAG-RY-BRIDGE-001`

This is a middle source-correspondence feedback card.  It does not run a new
finite diagnostic and does not claim theorem closure.  It retargets the
existing `DIAG-EXP-RY-001` necessary-condition evidence to the narrower bridge
leaf selected by the proof DAG.

## Source Object

The source object is the user-provided diagonal operator
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise, with
normalizer $\alpha = 1$.  The route remains a diagonal oracle block encoding,
not rank-one state preparation.

## Lean Status

The scalar-tier range specialization is compiled as
`CubicDiagonalOracle.expandedRyCleanEntryForCubicAmplitudes_of_standardTier`.
It uses `cubicAmplitude_nonneg` and `cubicAmplitude_le_one` to specialize the
standard `R_y(theta)` clean-entry interface to all cubic grid amplitudes.

The conditional bridge is also compiled as
`CubicDiagonalOracle.expandedControlledRyUsesCubicAngle_of_backendBridge`.
It consumes an explicit witness of
`CubicDiagonalOracle.expandedControlledRyBackendBridge`.  The route predicate
`CubicDiagonalOracle.expandedControlledRyUsesCubicAngle` is still opaque and
unproved without that witness.  The next lower worker must either supply the
concrete backend witness, or record that witness as a backend obligation and
move to `DIAG-EXP-ARITH-001`.

## Typed Feedback

```text
leaf=DIAG-RY-BRIDGE-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
block_entry_ok=true
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=true
closed_theorem_ok=false
closed_theorem=CubicDiagonalOracle.expandedControlledRyUsesCubicAngle_of_backendBridge
route_predicate_closed=false
error_class=symbolic_bridge_gap
next_route=Supply a concrete hBridge witness for expandedControlledRyBackendBridge, or record that witness as an explicit backend obligation and move to DIAG-EXP-ARITH-001.
```

Inherited finite support:
`verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-EXP-RY-001.leaf.feedback.json`.
That support remains necessary-condition evidence only.
