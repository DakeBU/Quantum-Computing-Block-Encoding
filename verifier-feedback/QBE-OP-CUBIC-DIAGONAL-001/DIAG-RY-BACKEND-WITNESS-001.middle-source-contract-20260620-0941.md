# Verifier Feedback: DIAG-RY-BACKEND-WITNESS-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Leaf: `DIAG-RY-BACKEND-WITNESS-001`

This middle packet translates the next source-correspondence step after the
transparent arithmetic contract refactor.  It does not run a new finite
diagnostic and does not claim theorem closure.

## Source Object

The source anchor is the user-provided operator target in
`tasks/QBE-OP-CUBIC-DIAGONAL-001.md`.  The object is
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise, with
normalizer `exactNormalizer n = 1`.  The route remains a diagonal oracle block
encoding, not rank-one state preparation.

## Lean Status

The arithmetic side is synchronized with Lean.  The expanded clean-block
contract consumes `expandedArithmeticComputesCubicAmplitudeTransparent n
workspaceQubits`, and `fixedDenomCubicArithmeticRouteTransparent n` supplies
that arithmetic conjunct for `workspaceQubits = 3 * n`.

The scalar-tier rotation side has the compiled declarations:

```lean
StandardRyCleanEntryScalarTier
expandedRyCleanEntryForCubicAmplitudes_of_standardTier
expandedControlledRyBackendBridge
expandedControlledRyUsesCubicAngle_of_backendBridge
```

The open witness is:

```lean
hBridge : expandedControlledRyBackendBridge tier n (3 * n)
```

Supplying `hBridge` must justify that the controlled signal rotation in the
expanded route uses the same standard `R_y(theta)` clean-entry convention as
the scalar-tier theorem, with
`theta_j = 2 * arccos(CubicStatePreparation.cubicAmplitude n j)`.  The scalar
identity alone is already compiled; the missing part is backend semantics.

## Ownership

The user target owns the diagonal operator, the normalizer, and the requested
export languages.  No paper source or external cited result is active for this
leaf.  The controlled-`R_y` backend witness is QBE-local semantic glue.  Clean
uncompute, clean-block extraction, unitarity, root certification, and
executable exports remain downstream obligations.

## Typed Feedback

```text
leaf=DIAG-RY-BACKEND-WITNESS-001
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
route_predicate_closed=false
error_class=symbolic_bridge_gap
next_route=state a transparent backend-semantics interface for expandedControlledRyBackendBridge tier n (3 * n), or record the witness as blocked and keep DIAG-EXP-UNCOMP-001 downstream
```

Forbidden shortcuts: do not prove `expandedControlledRyUsesCubicAngle` by
`trivial`, by adding an axiom, or by changing a semantic proposition to `True`.
Do not switch to rank-one state preparation and do not prepare executable
exports before a named Lean certificate closes `DIAG-ROOT-001`.
