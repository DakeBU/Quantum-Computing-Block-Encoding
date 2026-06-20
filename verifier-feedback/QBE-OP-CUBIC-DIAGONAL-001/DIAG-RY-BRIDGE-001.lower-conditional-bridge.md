# Verifier Feedback: DIAG-RY-BRIDGE-001 Conditional Bridge

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Leaf: `DIAG-RY-BRIDGE-001`

This lower Lean attempt added a transparent conditional bridge from the
compiled scalar-tier clean-entry theorem to the expanded route predicate.  It
does not prove `expandedControlledRyUsesCubicAngle` unconditionally.

Closed Lean declarations:

```lean
CubicDiagonalOracle.expandedControlledRyBackendBridge
CubicDiagonalOracle.expandedControlledRyUsesCubicAngle_of_backendBridge
```

The theorem consumes an explicit backend witness
`expandedControlledRyBackendBridge tier n workspaceQubits` and applies the
already-compiled scalar theorem
`expandedRyCleanEntryForCubicAmplitudes_of_standardTier tier n`.

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
unitarity_ok=null
closed_theorem_ok=false
closed_theorem=CubicDiagonalOracle.expandedControlledRyUsesCubicAngle_of_backendBridge
route_predicate_closed=false
error_class=symbolic_bridge_gap
next_route=Supply a concrete backend witness for expandedControlledRyBackendBridge, or keep expandedControlledRyUsesCubicAngle as an explicit backend obligation and move to DIAG-EXP-ARITH-001.
```

Gate: `python3 tools/qbe.py check` passed.
