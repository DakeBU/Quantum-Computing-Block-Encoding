# Lower Architect Packet: DIAG-RY-BACKEND-WITNESS-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Mode: `exploratoryConstruction`

Role: lower natural-language proof architect

Updated: 2026-06-20 10:05 JST

## Source Fragment

There is no paper-source archive for this task.  The source fragment is the
user-provided operator equation:

```text
O = sum_{j=0}^{2^n-1} f(x_j) |j><j|,
f(x) = x^3,
x_j = j / 2^n.
```

The translated target remains the diagonal matrix
$D_n[row,col] = (row/2^n)^3$ when `row = col` and $0$ otherwise.  The
normalizer remains `exactNormalizer n = 1`.  This packet does not introduce a
rank-one state-preparation target, a normalized diagonal vector, a primitive
oracle acceptance, or an executable export.

## Definitions

For fixed `n : Nat`, define the cubic grid amplitude at index
`j : Fin (gridSize n)` by the existing Lean term:

```lean
CubicStatePreparation.cubicAmplitude n j
```

The scalar rotation tier is already compiled as:

```lean
structure StandardRyCleanEntryScalarTier where
  Scalar : Type
  ratAmplitude : Rat -> Scalar
  thetaForAmplitude : Scalar -> Scalar
  cleanEntry : Scalar -> Scalar
  cleanEntry_of_range :
    forall a : Rat, 0 <= a -> a <= 1 ->
      cleanEntry (thetaForAmplitude (ratAmplitude a)) = ratAmplitude a
```

The compiled indexwise scalar statement is:

```lean
expandedRyCleanEntryForCubicAmplitudes tier n
```

It means that the standard `R_y` clean entry for
`theta_j = 2 * arccos(CubicStatePreparation.cubicAmplitude n j)` equals the
embedded amplitude for every grid index `j`.

The existing backend bridge target is:

```lean
expandedControlledRyBackendBridge tier n workspaceQubits :=
  expandedRyCleanEntryForCubicAmplitudes tier n ->
    expandedControlledRyUsesCubicAngle n workspaceQubits
```

The conclusion `expandedControlledRyUsesCubicAngle n workspaceQubits` is
opaque.  Therefore a direct proof of
`expandedControlledRyBackendBridge tier n (3 * n)` is not a tactic-search leaf
unless an independent backend-semantics witness for that opaque predicate has
already been introduced.

## Proposed Transparent Interface

The next Lean-facing leaf should introduce a transparent rotation-angle
predicate, parallel to the transparent arithmetic predicate already used by
`expandedAmplitudeOracleCleanBlockContract`:

```lean
def expandedControlledRyUsesCubicAngleTransparent
    (n workspaceQubits : Nat) : Prop :=
  forall tier : StandardRyCleanEntryScalarTier,
    expandedRyCleanEntryForCubicAmplitudes tier n
```

The smallest implementation-ready theorem is:

```lean
theorem expandedControlledRyUsesCubicAngleTransparent_of_standardTier
    (n workspaceQubits : Nat) :
    expandedControlledRyUsesCubicAngleTransparent n workspaceQubits := by
  intro tier
  exact expandedRyCleanEntryForCubicAmplitudes_of_standardTier tier n
```

For the current fixed-denominator expanded route, specialize
`workspaceQubits` to `3 * n`:

```lean
theorem fixedDenomControlledRyRouteTransparent
    (n : Nat) :
    expandedControlledRyUsesCubicAngleTransparent n (3 * n) := by
  exact expandedControlledRyUsesCubicAngleTransparent_of_standardTier n (3 * n)
```

This transparent predicate is not a proof of the existing opaque predicate
`expandedControlledRyUsesCubicAngle n (3 * n)`.  A future route can either:

1. refactor `expandedAmplitudeOracleCleanBlockContract` so its rotation conjunct
   consumes `expandedControlledRyUsesCubicAngleTransparent n workspaceQubits`;
   or
2. add a separate nontrivial bridge from the transparent predicate to the
   opaque backend predicate, backed by concrete route semantics.

The first route mirrors the accepted arithmetic refactor.  The second route is
blocked until a concrete controlled-`R_y` backend semantics object exists.

## Natural-Language Proof

Claim.  The transparent rotation-angle predicate holds for every `n` and
workspace count, and in particular for `workspaceQubits = 3 * n`.

Proof.  Fix `n`, `workspaceQubits`, and a scalar tier
`tier : StandardRyCleanEntryScalarTier`.  It remains to prove
`expandedRyCleanEntryForCubicAmplitudes tier n`.  Fix
`j : Fin (gridSize n)` and let
$a_j$ be `CubicStatePreparation.cubicAmplitude n j`.

The compiled range lemmas `cubicAmplitude_nonneg n j` and
`cubicAmplitude_le_one n j` give $0 \le a_j \le 1$.  The field
`tier.cleanEntry_of_range` applies to this rational amplitude and yields

```text
tier.cleanEntry
  (tier.thetaForAmplitude (tier.ratAmplitude a_j))
= tier.ratAmplitude a_j.
```

This is exactly the entrywise statement required by
`expandedRyCleanEntryForCubicAmplitudes tier n`.  The compiled theorem
`expandedRyCleanEntryForCubicAmplitudes_of_standardTier tier n` already
packages this argument.  Therefore the proposed transparent predicate follows
by introducing `tier` and applying that compiled theorem.  Specializing
`workspaceQubits` to `3 * n` gives the fixed-denominator rotation-angle
transparent witness.

This proof only certifies the scalar angle convention.  It does not prove
arithmetic computation, clean uncompute, clean-block extraction, unitarity, the
root block-encoding certificate, or an executable export.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-TGT-001` | Define the diagonal cubic target and alpha `1`. | none | existing Lean | `cubicDiagonalOperator`, `cubicDiagonalTarget`, `exactNormalizer` | task packet and conversion window | `python3 tools/qbe.py check` | proved |
| `DIAG-RANGE-001` | Prove $0 \le (j/2^n)^3 \le 1$ for every grid index. | target definitions | existing Lean | `cubicAmplitude_nonneg`, `cubicAmplitude_le_one` | proof-obligation ledger | `python3 tools/qbe.py check` | proved |
| `DIAG-ARITH-TRANSPARENT-CONTRACT-001` | Feed the fixed-denominator transparent arithmetic witness into the expanded clean-block contract. | fixed-denominator backend compute proof | existing Lean | `expandedArithmeticComputesCubicAmplitudeTransparent`, `fixedDenomCubicArithmeticRouteTransparent`, `expandedAmplitudeOracleCleanBlockContract` | `proof-attempts/...DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001...` | `python3 tools/qbe.py check` | proved; not a root certificate |
| `DIAG-RY-SCALAR-001` | Specialize the standard `R_y` clean-entry identity to cubic amplitudes. | `DIAG-RANGE-001`, scalar tier contract | existing Lean | `StandardRyCleanEntryScalarTier`, `expandedRyCleanEntryForCubicAmplitudes_of_standardTier` | verifier feedback `DIAG-EXP-RY-001.leaf.md` | `python3 tools/qbe.py check` | proved scalar-tier specialization |
| `DIAG-RY-BACKEND-WITNESS-001` | Supply `hBridge : expandedControlledRyBackendBridge tier n (3 * n)` or route to a transparent replacement. | `DIAG-RY-SCALAR-001`, backend semantics | current architect packet | existing target `expandedControlledRyBackendBridge`; proposed transparent predicate above | this packet | `python3 tools/qbe.py check` | blocked for direct opaque bridge; transparent subleaf is implementation-ready |
| `DIAG-RY-TRANSPARENT-INTERFACE-001` | Add the transparent rotation-angle predicate and fixed-denominator witness theorem. | `DIAG-RY-SCALAR-001` | next lower Lean worker | proposed `expandedControlledRyUsesCubicAngleTransparent`, `fixedDenomControlledRyRouteTransparent` | this packet | `python3 tools/qbe.py check` | next active leaf |
| `DIAG-RY-BRIDGE-001` | Derive the old opaque rotation route predicate only from a nontrivial backend bridge. | `DIAG-RY-BACKEND-WITNESS-001` | future lower after backend semantics | `expandedControlledRyUsesCubicAngle_of_backendBridge`; target `expandedControlledRyUsesCubicAngle` | verifier feedback `DIAG-RY-BRIDGE-001.*` | `python3 tools/qbe.py check` | conditional bridge compiled; opaque predicate unclosed |
| `DIAG-EXP-UNCOMP-001` | Prove workspace cleanup after rotation. | arithmetic route and rotation route | future lower | `expandedWorkspaceCleanUncomputed` | proof obligations | `python3 tools/qbe.py check` | blocked downstream |
| `DIAG-ROOT-001` | Package an exact block-encoding certificate for the diagonal operator. | arithmetic, rotation, uncompute, extraction, unitarity | future lower and reviewer | planned expanded certificate or conditional primitive certificate | candidate population and proof obligations | full project gate | blocked |

Next active leaf for a Lean worker:
`DIAG-RY-TRANSPARENT-INTERFACE-001`.  The Lean worker should add only the
transparent predicate and the two small theorem wrappers above, or ask middle
to approve the analogous contract refactor.  The Lean worker should not try to
prove `expandedControlledRyUsesCubicAngle` directly.

## Ordered Lean Lemmas

1. Reuse `CubicDiagonalOracle.cubicAmplitude_nonneg n j` and
   `CubicDiagonalOracle.cubicAmplitude_le_one n j` for the scalar range side
   conditions.
2. Reuse `StandardRyCleanEntryScalarTier.cleanEntry_of_range`, through the
   tier parameter, for the standard clean-entry identity.
3. Reuse `expandedRyCleanEntryForCubicAmplitudes_of_standardTier tier n`; this
   already packages the range lemmas and the scalar-tier identity.
4. Add `expandedControlledRyUsesCubicAngleTransparent n workspaceQubits` as the
   transparent predicate if middle accepts the route.
5. Prove `expandedControlledRyUsesCubicAngleTransparent_of_standardTier` by
   introducing `tier` and applying
   `expandedRyCleanEntryForCubicAmplitudes_of_standardTier tier n`.
6. Prove `fixedDenomControlledRyRouteTransparent n` by specializing the theorem
   to `workspaceQubits = 3 * n`.
7. Do not add a theorem from the transparent predicate to
   `expandedControlledRyUsesCubicAngle` unless a separate concrete backend
   semantics bridge is stated.

## Failure Analysis

The diagonal target is not mathematically wrong.  The stale route is to keep
attacking the old arithmetic bridge or the existing controlled-`R_y` opaque
bridge as a direct tactic goal.  The arithmetic side has already been refactored
to a transparent predicate, and the current direct rotation witness target
unfolds to a function whose conclusion is the opaque route predicate.

Therefore `DIAG-RY-BACKEND-WITNESS-001` is blocked as an implementation target
until one of the following happens:

1. middle accepts the transparent rotation predicate above and then refactors
   the expanded clean-block contract to consume it; or
2. a concrete controlled-`R_y` backend semantics object is introduced, making a
   nontrivial proof of `expandedControlledRyBackendBridge tier n (3 * n)`
   possible.

Forbidden shortcuts remain invalid: no `trivial` proof of an opaque semantic
predicate, no new axiom, no semantic proposition set to `True`, no switch to
rank-one state preparation, and no executable export before `DIAG-ROOT-001`.

## Typed Feedback

```text
leaf=DIAG-RY-BACKEND-WITNESS-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
theta_convention_ok=true
normalizer_ok=true
block_entry_ok=null
unitarity_ok=null
ancilla_cleanup_ok=null
closed_theorem_ok=false
route_predicate_closed=false
root_certificate_ok=false
exports_ok=false
error_class=symbolic_bridge_gap
next_route=implement DIAG-RY-TRANSPARENT-INTERFACE-001, or keep the opaque controlled-R_y backend witness blocked until concrete backend semantics exists
```

Gate: `python3 tools/qbe.py check` passed after this Markdown packet was added;
the command ran `lake build` and `lake build Tests`.

## Handoff

This lower architect packet routes `DIAG-RY-BACKEND-WITNESS-001` away from
direct opaque proof search.  The implementation-ready leaf is a transparent
rotation-angle predicate plus the fixed-denominator wrapper theorem.  It closes
only scalar angle bookkeeping for the expanded route; clean uncompute,
clean-block extraction, unitarity, root certification, and exports remain
blocked.
