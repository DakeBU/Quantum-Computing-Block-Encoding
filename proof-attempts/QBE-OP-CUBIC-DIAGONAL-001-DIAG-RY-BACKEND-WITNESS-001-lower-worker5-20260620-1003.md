# Lower Worker 5 Packet: DIAG-RY-BACKEND-WITNESS-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`
Role: lower auxiliary proof-route worker 5
Timestamp: 2026-06-20 10:03 JST

## Source Object

The source anchor is the user prompt copied in
`tasks/QBE-OP-CUBIC-DIAGONAL-001.md`.  For `N = 2^n`, the target is the
diagonal operator $D_n$ with entry $(row/N)^3$ when `row = col` and zero
otherwise.  The normalizer remains `exactNormalizer n = 1`.

This route keeps the target diagonal.  It does not use rank-one state
preparation, a normalized diagonal vector, a paper source, or an external
cited theorem.

## Current Lean Facts

The scalar clean-entry portion of the controlled-`R_y` route is already
compiled:

```lean
StandardRyCleanEntryScalarTier
expandedRyCleanEntryForCubicAmplitudes
expandedRyCleanEntryForCubicAmplitudes_of_standardTier
```

The current route predicate and bridge are:

```lean
opaque expandedControlledRyUsesCubicAngle
    (n workspaceQubits : Nat) : Prop

def expandedControlledRyBackendBridge
    (tier : StandardRyCleanEntryScalarTier)
    (n workspaceQubits : Nat) : Prop :=
  expandedRyCleanEntryForCubicAmplitudes tier n ->
    expandedControlledRyUsesCubicAngle n workspaceQubits
```

The current Lean surface also contains the normal-form theorem:

```lean
theorem expandedControlledRyBackendBridge_iff_of_standardTier
    (tier : StandardRyCleanEntryScalarTier)
    (n workspaceQubits : Nat) :
    Iff
      (expandedControlledRyBackendBridge tier n workspaceQubits)
      (expandedControlledRyUsesCubicAngle n workspaceQubits)
```

This theorem is a proof-reduction result.  It does not supply a witness of
`expandedControlledRyBackendBridge`, and it does not close
`expandedControlledRyUsesCubicAngle`.

## Route Analysis

The active leaf asks for a witness

```lean
hBridge : expandedControlledRyBackendBridge tier n (3 * n)
```

for the fixed-denominator workspace size selected by the arithmetic route.
Because `expandedRyCleanEntryForCubicAmplitudes_of_standardTier tier n` is
already compiled, such a bridge witness is equivalent to proving the opaque
route predicate

```lean
expandedControlledRyUsesCubicAngle n (3 * n)
```

itself.  A direct proof of `hBridge` is therefore not an independent local
Lean leaf under the current interface.  It would require exactly the backend
semantics that the opaque route predicate represents.

The honest next interface is a transparent controlled-rotation backend
predicate, analogous to the transparent arithmetic predicate already adopted.
One Lean-facing shape would be a small backend record whose pointwise field
states that for each `j : Fin (gridSize n)`, the controlled signal rotation
uses

```lean
tier.thetaForAmplitude
  (tier.ratAmplitude (CubicStatePreparation.cubicAmplitude n j))
```

and whose clean signal entry is the corresponding `tier.cleanEntry`.  A
transparent route predicate would existentially package such a backend together
with the pointwise clean-entry theorem.  That predicate should not imply the
opaque `expandedControlledRyUsesCubicAngle` unless a separate nontrivial
route-semantics bridge is later introduced.

This route packet therefore classifies `DIAG-RY-BACKEND-WITNESS-001` as a
`symbolic_bridge_gap`, not as a theorem-closure failure.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-TGT-001` | Define the diagonal cubic target with normalizer `1`. | none | existing Lean | `cubicDiagonalOperator`, `cubicDiagonalTarget`, `exactNormalizer` | task packet | `python3 tools/qbe.py check` | proved |
| `DIAG-EXP-RY-001` | Specialize the standard `R_y` clean-entry convention to every cubic grid amplitude. | `DIAG-RANGE-001`, scalar-tier contract | existing Lean | `expandedRyCleanEntryForCubicAmplitudes_of_standardTier` | verifier feedback `DIAG-EXP-RY-001.leaf.*` | `python3 tools/qbe.py check` | scalar-tier specialization proved |
| `DIAG-RY-BRIDGE-NF-001` | Record that direct controlled-`R_y` bridge search is equivalent to the opaque route predicate. | `DIAG-EXP-RY-001`, `expandedControlledRyBackendBridge` | existing Lean | `expandedControlledRyBackendBridge_iff_of_standardTier` | this packet | `python3 tools/qbe.py check` | proved normal-form memory, not a route certificate |
| `DIAG-RY-BACKEND-WITNESS-001` | Supply a concrete controlled-rotation backend witness for workspace `3 * n`, or introduce a transparent backend predicate. | `DIAG-RY-BRIDGE-NF-001`, backend rotation semantics | next middle/lower packet | target witness of `expandedControlledRyBackendBridge tier n (3 * n)` | this packet | `python3 tools/qbe.py check` | blocked internal symbolic bridge gap |
| `DIAG-EXP-UNCOMP-001` | Prove clean uncompute for the arithmetic workspace. | accepted rotation backend semantics | future lower worker | `expandedWorkspaceCleanUncomputed` | proof-obligation ledger | `python3 tools/qbe.py check` | downstream blocked |
| `DIAG-ROOT-001` | Package an exact block-encoding certificate for the diagonal operator. | arithmetic, rotation backend, clean uncompute, extraction, unitarity | future lower/reviewer | planned expanded certificate | candidate population | `python3 tools/qbe.py check` and final lake gate | blocked |

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
normal_form_theorem=expandedControlledRyBackendBridge_iff_of_standardTier
closed_normal_form_ok=true
closed_theorem_ok=false
route_predicate_closed=false
root_certificate_ok=false
exports_ok=false
error_class=symbolic_bridge_gap
next_route=introduce a transparent controlled-R_y backend predicate analogous
  to expandedArithmeticComputesCubicAmplitudeTransparent, or keep
  DIAG-EXP-UNCOMP-001 blocked until an accepted backend-semantics witness exists
```

## Handoff

Lower worker 5 handoff: do not assign another direct proof search for
`expandedControlledRyBackendBridge tier n (3 * n)`.  The compiled normal form
shows that direct bridge search is equivalent to the opaque predicate
`expandedControlledRyUsesCubicAngle n (3 * n)`.  The next useful route is to
state a transparent controlled-rotation backend interface, then decide whether
the expanded clean-block contract should consume that transparent predicate or
whether a separate nontrivial bridge to the opaque predicate will be supplied.
Clean uncompute, extraction, unitarity, root certification, and executable
exports remain blocked.
