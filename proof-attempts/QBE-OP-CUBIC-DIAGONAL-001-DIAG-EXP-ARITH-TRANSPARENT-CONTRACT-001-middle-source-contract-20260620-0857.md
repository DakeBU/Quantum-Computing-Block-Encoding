# Lower Packet: DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Role: middle source-correspondence formalizer

## Source Object

The source anchor is the user-provided operator copied in
`tasks/QBE-OP-CUBIC-DIAGONAL-001.md`.  For `N = 2^n`, the target is the
diagonal matrix
$D_n[row,col] = (row/N)^3$ when `row = col` and zero otherwise.  The normalizer
is `exactNormalizer n = 1`.

This packet does not use a paper source, a cited theorem, or an external
construction hint.

## Current Lean Surface

The fixed-denominator arithmetic witness is compiled:

```lean
fixedDenomCubicArithmeticBackend (n : Nat) :
  ExpandedCubicArithmeticBackend n (3 * n)

fixedDenomCubicArithmeticBackend_computes (n : Nat) :
  expandedArithmeticBackendComputesCubicAmplitude
    (fixedDenomCubicArithmeticBackend n)

expandedArithmeticComputesCubicAmplitudeTransparent
    (n workspaceQubits : Nat) : Prop

fixedDenomCubicArithmeticRouteTransparent (n : Nat) :
  expandedArithmeticComputesCubicAmplitudeTransparent n (3 * n)
```

The existing expanded clean-block contract still begins with the opaque route
predicate:

```lean
expandedArithmeticComputesCubicAmplitude n workspaceQubits
```

The normal-form theorem `fixedDenomCubicArithmeticBackend_bridge_iff` shows
that direct bridge search for the fixed-denominator backend is equivalent to
the old opaque route predicate.  Direct search is therefore stale unless a
separate nontrivial route-semantics bridge is introduced.

## Next Lean Leaf

Lower 2 owns one small Lean edit in
`QuantumBlockEncoding/CubicStatePreparation.lean`: refactor the existing
declaration `expandedAmplitudeOracleCleanBlockContract` so its arithmetic
conjunct is

```lean
expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits
```

instead of

```lean
expandedArithmeticComputesCubicAmplitude n workspaceQubits
```

Do not create a second target operator, normalizer, matrix, or register layout.
Do not prove a theorem from the transparent predicate to the opaque predicate
unless a new nontrivial semantics bridge is stated.  Do not close the opaque
predicate by `trivial`, by an axiom, or by setting any semantic predicate to
`True`.

## Expected Result

After the refactor, the arithmetic conjunct for `workspaceQubits = 3 * n` can
be supplied by `fixedDenomCubicArithmeticRouteTransparent n`.  The refactor
does not prove `expandedControlledRyUsesCubicAngle`,
`expandedWorkspaceCleanUncomputed`,
`expandedAmplitudeOracleCleanBlockExtracts`, unitarity, the root certificate,
or executable exports.

## Gate

Run:

```bash
python3 tools/qbe.py check
```

The full project closeout gate remains:

```bash
lake build && lake build Tests
```
