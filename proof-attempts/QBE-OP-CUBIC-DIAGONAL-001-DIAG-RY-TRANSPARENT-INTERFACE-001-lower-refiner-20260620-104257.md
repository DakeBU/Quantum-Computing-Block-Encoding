# Proof Attempt: DIAG-RY-TRANSPARENT-INTERFACE-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`
Role: lower Lean refiner/reducer
Timestamp: 2026-06-20 10:42 JST

## Failed Route Being Repaired

Failed theorem or route:

```lean
expandedControlledRyBackendBridge tier n (3 * n)
```

Rejected direct proof script:

```lean
theorem rejected_ry_backend_bridge_route
    (tier : StandardRyCleanEntryScalarTier)
    (n : Nat) :
    expandedControlledRyBackendBridge tier n (3 * n) := by
  intro _hScalar
```

Lean error from the rejected route:

```text
error: unsolved goals
tier : StandardRyCleanEntryScalarTier
n : Nat
_hScalar : expandedRyCleanEntryForCubicAmplitudes tier n
|- expandedControlledRyUsesCubicAngle n (3 * n)
```

The rejected route tries to convert the scalar-tier clean-entry theorem directly
into the controlled-rotation backend route.  The compiled normal form
`expandedControlledRyBackendBridge_iff_of_standardTier` shows this is
equivalent to proving the opaque predicate
`expandedControlledRyUsesCubicAngle n (3 * n)`.

## Refiner Patch

Added the transparent rotation-angle interface:

```lean
def expandedControlledRyUsesCubicAngleTransparent
    (n _workspaceQubits : Nat) : Prop :=
  forall tier : StandardRyCleanEntryScalarTier,
    expandedRyCleanEntryForCubicAmplitudes tier n
```

Added the fixed-denominator wrapper theorem:

```lean
theorem fixedDenomControlledRyRouteTransparent
    (n : Nat) :
    expandedControlledRyUsesCubicAngleTransparent n (3 * n)
```

The proof introduces `tier` and applies
`expandedRyCleanEntryForCubicAmplitudes_of_standardTier tier n`.  This closes
only the transparent scalar-angle bookkeeping leaf.  It does not prove
`expandedControlledRyUsesCubicAngle`, does not supply
`expandedControlledRyBackendBridge`, does not refactor
`expandedAmplitudeOracleCleanBlockContract`, and does not affect uncompute,
extraction, unitarity, the root certificate, or exports.

## Gate

`python3 tools/qbe.py check` passed.  The command ran `lake build` and
`lake build Tests`.

## Verdict

Keep the transparent-interface patch.  The next lower route should wait for
middle approval before any contract refactor.  The opaque controlled-`R_y`
route predicate remains blocked as a symbolic bridge gap.

## Typed Feedback

```text
leaf=DIAG-RY-TRANSPARENT-INTERFACE-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
theta_convention_ok=true
normalizer_ok=true
block_entry_ok=null
unitarity_ok=null
ancilla_cleanup_ok=null
closed_theorem=fixedDenomControlledRyRouteTransparent
closed_theorem_ok=true
transparent_rotation_leaf_closed=true
route_predicate_closed=false
root_certificate_ok=false
exports_ok=false
error_class=symbolic_bridge_gap
next_route=with middle approval, decide whether the expanded clean-block contract should consume expandedControlledRyUsesCubicAngleTransparent; keep opaque route predicate, uncompute, extraction, root, and exports blocked
```
