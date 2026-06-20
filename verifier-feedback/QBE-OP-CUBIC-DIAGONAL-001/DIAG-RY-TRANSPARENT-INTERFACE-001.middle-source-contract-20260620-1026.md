# Verifier Feedback: DIAG-RY-TRANSPARENT-INTERFACE-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Leaf: `DIAG-RY-TRANSPARENT-INTERFACE-001`

Role: middle source-correspondence formalizer

## Source Contract

The source anchor is the user-provided diagonal operator in
`tasks/QBE-OP-CUBIC-DIAGONAL-001.md`.  The object is
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise, with
`exactNormalizer n = 1`.

The previous direct witness target

```lean
expandedControlledRyBackendBridge tier n (3 * n)
```

is not a ready proof-search leaf.  The compiled normal form
`expandedControlledRyBackendBridge_iff_of_standardTier` reduces that witness to
the opaque route predicate `expandedControlledRyUsesCubicAngle n (3 * n)`.

The next lower Lean leaf is to add only:

```lean
def expandedControlledRyUsesCubicAngleTransparent
    (n workspaceQubits : Nat) : Prop :=
  forall tier : StandardRyCleanEntryScalarTier,
    expandedRyCleanEntryForCubicAmplitudes tier n

theorem fixedDenomControlledRyRouteTransparent
    (n : Nat) :
    expandedControlledRyUsesCubicAngleTransparent n (3 * n)
```

The proof should reuse
`expandedRyCleanEntryForCubicAmplitudes_of_standardTier`.  This leaf does not
prove the opaque predicate, does not supply a backend witness, and does not
unblock clean uncompute, extraction, unitarity, root certification, or exports.

## Typed Feedback

```text
leaf=DIAG-RY-TRANSPARENT-INTERFACE-001
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=true
theta_convention_ok=true
normalizer_ok=true
block_entry_ok=null
unitarity_ok=null
ancilla_cleanup_ok=null
closed_theorem_ok=false
transparent_rotation_leaf_expected=true
route_predicate_closed=false
root_certificate_ok=false
exports_ok=false
error_class=symbolic_bridge_gap
next_route=add expandedControlledRyUsesCubicAngleTransparent and fixedDenomControlledRyRouteTransparent; do not refactor the clean-block contract or prove the opaque route predicate in this leaf
```
