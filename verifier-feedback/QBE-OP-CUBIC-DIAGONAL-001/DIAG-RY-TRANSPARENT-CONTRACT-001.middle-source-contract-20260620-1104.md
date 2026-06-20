# Middle Source Contract: DIAG-RY-TRANSPARENT-CONTRACT-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

## Source Anchor

The source anchor is the user-provided operator target in
`tasks/QBE-OP-CUBIC-DIAGONAL-001.md`.  The operator is the diagonal matrix
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise.  The
normalizer is `exactNormalizer n = 1`.

No paper source, figure, or cited theorem is active.

## Lean Surface

The transparent controlled-`R_y` interface now compiles:

```lean
expandedControlledRyUsesCubicAngleTransparent
fixedDenomControlledRyRouteTransparent
```

The opaque controlled-rotation predicate remains unproved:

```lean
expandedControlledRyUsesCubicAngle
```

The clean-block contract still consumes the opaque predicate.  The next lower
leaf should change only that contract boundary.

## Lower-Facing Contract

```text
leaf=DIAG-RY-TRANSPARENT-CONTRACT-001
target file=QuantumBlockEncoding/CubicStatePreparation.lean
allowed write scope=the definition and docstring of
  expandedAmplitudeOracleCleanBlockContract, plus directly adjacent comments
exact Lean-facing edit=replace the rotation conjunct
  expandedControlledRyUsesCubicAngle n workspaceQubits
with
  expandedControlledRyUsesCubicAngleTransparent n workspaceQubits
dependencies already compiled=expandedControlledRyUsesCubicAngleTransparent,
  fixedDenomControlledRyRouteTransparent,
  expandedRyCleanEntryForCubicAmplitudes_of_standardTier
expected post-edit status=for workspaceQubits = 3 * n, the rotation conjunct
  can be supplied by fixedDenomControlledRyRouteTransparent n
forbidden edits=do not prove expandedControlledRyUsesCubicAngle by trivial,
  do not add an axiom, do not set semantic propositions to True, do not switch
  to rank-one state preparation, and do not prepare executable exports
gate=python3 tools/qbe.py check
```

## Remaining Obligations

Clean uncompute, clean-block extraction, unitarity/circuit semantics,
`DIAG-ROOT-001`, and all executable exports remain blocked after this refactor.

## Typed Feedback Seed

```text
leaf=DIAG-RY-TRANSPARENT-CONTRACT-001
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
transparent_rotation_leaf_closed=true
route_predicate_closed=false
contract_refactor_expected=true
error_class=symbolic_bridge_gap
next_route=refactor expandedAmplitudeOracleCleanBlockContract so the rotation
  conjunct uses expandedControlledRyUsesCubicAngleTransparent; keep root and
  exports blocked
```
