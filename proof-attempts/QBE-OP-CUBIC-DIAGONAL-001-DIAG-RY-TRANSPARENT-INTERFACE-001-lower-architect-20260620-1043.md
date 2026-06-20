# Lower Architect Packet: DIAG-RY-TRANSPARENT-INTERFACE-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Mode: `exploratoryConstruction`

Role: lower natural-language proof architect

Updated: 2026-06-20 10:43 JST

## Source Fragment

There is no paper-source archive for this task.  The source equation is the
user-provided diagonal operator

$$
O = \sum_{j=0}^{2^n-1} (j/2^n)^3 |j\rangle\langle j|.
$$

The Lean target remains the diagonal matrix whose entry is
$(row/2^n)^3$ when `row = col` and zero otherwise.  The normalizer remains
`exactNormalizer n = 1`.  This packet does not use the rank-one
state-preparation task and does not normalize the diagonal vector as a state.

## Definitions

For fixed `n : Nat` and `j : Fin (gridSize n)`, define
`a_j = CubicStatePreparation.cubicAmplitude n j`.  The closed range lemmas
`cubicAmplitude_nonneg` and `cubicAmplitude_le_one` state that
$0 \le a_j \le 1$.

For a standard `R_y` scalar tier, the intended signal rotation angle is

$$
theta_j = 2 * arccos(a_j).
$$

The closed scalar-tier theorem
`expandedRyCleanEntryForCubicAmplitudes_of_standardTier tier n` packages the
range lemmas and the standard clean-entry identity for every basis index `j`.

The transparent rotation predicate in the current Lean surface is:

```lean
def expandedControlledRyUsesCubicAngleTransparent
    (n workspaceQubits : Nat) : Prop :=
  forall tier : StandardRyCleanEntryScalarTier,
    expandedRyCleanEntryForCubicAmplitudes tier n
```

The fixed-denominator wrapper theorem in the current Lean surface is:

```lean
theorem fixedDenomControlledRyRouteTransparent
    (n : Nat) :
    expandedControlledRyUsesCubicAngleTransparent n (3 * n)
```

## Local Proof

Fix `n : Nat`.  To prove
`expandedControlledRyUsesCubicAngleTransparent n (3 * n)`, unfold only the
transparent predicate.  The goal becomes: for every
`tier : StandardRyCleanEntryScalarTier`, prove
`expandedRyCleanEntryForCubicAmplitudes tier n`.

Introduce an arbitrary `tier`.  The theorem
`expandedRyCleanEntryForCubicAmplitudes_of_standardTier tier n` is exactly the
required scalar-tier statement.  Therefore the proof is:

```lean
intro tier
exact expandedRyCleanEntryForCubicAmplitudes_of_standardTier tier n
```

The workspace value `3 * n` is used only to align this transparent rotation
wrapper with the fixed-denominator arithmetic route.  The predicate body is a
scalar angle-convention statement and does not claim workspace cleanup,
clean-block extraction, unitarity, or the root block-encoding certificate.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-TGT-001` | Diagonal cubic operator with alpha `1`. | source user equation | existing Lean | `cubicDiagonalOperator`, `exactNormalizer` | task and conversion window | `python3 tools/qbe.py check` | proved |
| `DIAG-RANGE-001` | Range $0 \le a_j \le 1$ for cubic amplitudes. | grid point range and cubic monotonicity lemmas | existing Lean | `cubicAmplitude_nonneg`, `cubicAmplitude_le_one` | conversion window | `python3 tools/qbe.py check` | proved |
| `DIAG-RY-SCALAR-001` | Standard `R_y(theta)` clean entry for `theta_j = 2 * arccos(a_j)`. | `DIAG-RANGE-001`, scalar-tier contract | existing Lean | `expandedRyCleanEntryForCubicAmplitudes_of_standardTier` | proof-obligation ledger | `python3 tools/qbe.py check` | proved |
| `DIAG-RY-BACKEND-WITNESS-001` | Concrete backend witness for `expandedControlledRyUsesCubicAngle`. | `DIAG-RY-SCALAR-001`, backend route semantics | future lower only after semantics object exists | `expandedControlledRyBackendBridge`; normal form `expandedControlledRyBackendBridge_iff_of_standardTier` | verifier feedback and proof obligations | `python3 tools/qbe.py check` | blocked symbolic bridge |
| `DIAG-RY-TRANSPARENT-INTERFACE-001` | Transparent rotation-angle predicate plus fixed-denominator wrapper. | `DIAG-RY-SCALAR-001` | current Lean surface; lower architect records proof | `expandedControlledRyUsesCubicAngleTransparent`, `fixedDenomControlledRyRouteTransparent` | this packet | `python3 tools/qbe.py check` | implemented in current Lean surface; gate passed for this lower pass |
| `DIAG-EXP-RY-TRANSPARENT-CONTRACT-001` | If middle approves, refactor the expanded clean-block contract to consume the transparent rotation predicate. | `DIAG-RY-TRANSPARENT-INTERFACE-001`, transparent arithmetic contract refactor | future lower Lean worker | possible edit to `expandedAmplitudeOracleCleanBlockContract` | next middle packet | `python3 tools/qbe.py check` | next proposed active leaf after approval |
| `DIAG-EXP-UNCOMP-001` | Prove arithmetic workspace is restored clean. | arithmetic route and rotation route boundary | future lower | `expandedWorkspaceCleanUncomputed` | proof obligations | `python3 tools/qbe.py check` | blocked downstream |
| `DIAG-ROOT-001` | Exact block-encoding certificate for the diagonal operator. | arithmetic, rotation, uncompute, extraction, unitarity | future lower and reviewer | planned expanded certificate or conditional primitive certificate | candidate population | full gate | blocked |

Next active leaf for a Lean worker, after middle approval, should be
`DIAG-EXP-RY-TRANSPARENT-CONTRACT-001`: change only the rotation conjunct of
`expandedAmplitudeOracleCleanBlockContract` from the opaque predicate to
`expandedControlledRyUsesCubicAngleTransparent n workspaceQubits`.  That route
must not add a theorem from the transparent predicate to
`expandedControlledRyUsesCubicAngle`.

## Ordered Lean Lemmas

1. Reuse `cubicAmplitude_nonneg n j` and `cubicAmplitude_le_one n j` through
   the existing scalar-tier theorem.
2. Reuse `expandedRyCleanEntryForCubicAmplitudes_of_standardTier tier n`.
3. Reuse the current definition
   `expandedControlledRyUsesCubicAngleTransparent n workspaceQubits`.
4. Reuse the current theorem
   `fixedDenomControlledRyRouteTransparent n`.
5. For a future contract refactor, reuse the current
   `expandedAmplitudeOracleCleanBlockContract` name and replace only its
   rotation conjunct after middle approves the boundary.

## Failure Analysis

The mathematical target is not wrong.  The stale route is a direct proof of

```lean
expandedControlledRyBackendBridge tier n (3 * n)
```

under the current Lean surface.  The normal form
`expandedControlledRyBackendBridge_iff_of_standardTier` shows that this bridge
is equivalent to the opaque route predicate
`expandedControlledRyUsesCubicAngle n (3 * n)`, because the scalar-tier premise
is already closed.  A direct proof would therefore hide the missing backend
semantics rather than supply it.

The current transparent interface is the correct narrow bookkeeping leaf, and
the corresponding Lean declarations are already present in the current source.
Repeating that implementation leaf is now stale.  The next useful route is
either a middle-approved contract refactor that consumes the transparent
rotation predicate, or a genuine backend-semantics object that makes a
nontrivial bridge proof possible.

Forbidden shortcuts remain invalid: no axiom, no `trivial` proof of an opaque
semantic predicate, no semantic proposition set to `True`, no rank-one
state-preparation replacement, and no executable export before `DIAG-ROOT-001`.

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
closed_theorem_ok=true
route_predicate_closed=false
root_certificate_ok=false
exports_ok=false
error_class=stale_leaf
next_route=ask middle to approve DIAG-EXP-RY-TRANSPARENT-CONTRACT-001, a narrow refactor of expandedAmplitudeOracleCleanBlockContract to consume expandedControlledRyUsesCubicAngleTransparent; keep opaque route predicate, uncompute, extraction, root, and exports blocked
```

For the old direct backend witness route, the primary verifier class remains
`symbolic_bridge_gap`.

## Handoff

This lower architect pass records the natural-language proof of the transparent
controlled-`R_y` interface and confirms that the interface is already in the
current Lean surface.  Do not reassign `DIAG-RY-TRANSPARENT-INTERFACE-001` as a
code edit.  The next route should be a middle-approved rotation contract
refactor, or a concrete backend-semantics witness if the project chooses the
opaque bridge route.  Clean uncompute, extraction, unitarity, root
certification, and executable exports remain blocked.  Gate passed:
`python3 tools/qbe.py check` ran `lake build` and `lake build Tests`.
