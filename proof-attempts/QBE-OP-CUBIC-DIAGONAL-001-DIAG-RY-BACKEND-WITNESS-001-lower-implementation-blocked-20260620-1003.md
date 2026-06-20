# DIAG-RY-BACKEND-WITNESS-001 Lower Implementation Blocked

Task: `QBE-OP-CUBIC-DIAGONAL-001`
Mode: `exploratoryConstruction`
Timestamp: 2026-06-20 10:03 JST
Role: lower Lean implementation worker

## Active Leaf

`DIAG-RY-BACKEND-WITNESS-001`

The current lower-facing target is a witness

```lean
hBridge : expandedControlledRyBackendBridge tier n (3 * n)
```

which would let the already compiled theorem

```lean
expandedControlledRyUsesCubicAngle_of_backendBridge
```

close `expandedControlledRyUsesCubicAngle n (3 * n)`.

## Existing Dependencies

The scalar convention side is already compiled:

```lean
StandardRyCleanEntryScalarTier
expandedRyCleanEntryForCubicAmplitudes
expandedRyCleanEntryForCubicAmplitudes_of_standardTier
expandedControlledRyBackendBridge
expandedControlledRyUsesCubicAngle_of_backendBridge
```

The arithmetic side is also no longer active lower work:

```lean
expandedArithmeticComputesCubicAmplitudeTransparent
fixedDenomCubicArithmeticRouteTransparent
expandedAmplitudeOracleCleanBlockContract
```

The diagonal target remains the user-provided operator
`D_n[row,col] = if row = col then (row / 2^n)^3 else 0`, with
`exactNormalizer n = 1`.

## Blocked Route

No transparent backend-semantics interface currently states that the expanded
route's controlled signal rotation is interpreted by the same standard
`R_y(theta)` clean-entry convention used by
`expandedRyCleanEntryForCubicAmplitudes_of_standardTier`.

Because `expandedControlledRyUsesCubicAngle` is opaque, a Lean implementation
worker cannot honestly prove `expandedControlledRyBackendBridge tier n (3 * n)`
from the current declarations without one of the forbidden shortcuts:

- proving an opaque semantic proposition by `trivial`;
- adding an axiom;
- setting the semantic proposition to `True`;
- switching to the rank-one state-preparation target.

## Remaining Lean Goal

Middle or lower 1 must first state a transparent backend-semantics interface
for the controlled-`R_y` substep.  After that interface exists, lower 2 can
attempt one adjacent declaration around
`expandedControlledRyBackendBridge` / `expandedControlledRyUsesCubicAngle`.

Until then, keep `DIAG-EXP-UNCOMP-001`, clean-block extraction, unitarity,
`DIAG-ROOT-001`, and executable exports blocked.

## Gate

`python3 tools/qbe.py check` passed at 2026-06-20 10:03 JST:

```text
lake build
lake build Tests
```

