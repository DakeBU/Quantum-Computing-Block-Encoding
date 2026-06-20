# Lower Architect Packet: DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Role: lower natural-language proof architect

Updated: 2026-06-20 09:17 JST

## Source Fragment

There is no source-paper proof fragment for this leaf.  The source is the
user-provided operator equation:

```text
O = sum_{j=0}^{2^n-1} f(x_j) |j><j|,
f(x) = x^3,
x_j = j / 2^n.
```

The translated Lean-checkable target remains the diagonal operator
$D_n[row,col] = (row/2^n)^3$ when `row = col` and $0$ otherwise.  The
normalizer remains `exactNormalizer n = 1`.

This packet does not introduce a paper source, external theorem, rank-one
state-preparation target, normalized diagonal vector, or executable export.

## Definitions

For fixed `n`, the selected arithmetic backend is
`fixedDenomCubicArithmeticBackend n`.  It uses workspace
`Fin (gridSize (3 * n))`, clean workspace `0`, payload `j.val ^ 3`, and
amplitude projection
`(payload.val : Rat) / (gridSize (3 * n) : Rat)`.

The compiled pointwise compute theorem is:

```lean
fixedDenomCubicArithmeticBackend_computes (n : Nat) :
  expandedArithmeticBackendComputesCubicAmplitude
    (fixedDenomCubicArithmeticBackend n)
```

The compiled transparent arithmetic route predicate is:

```lean
expandedArithmeticComputesCubicAmplitudeTransparent
    (n workspaceQubits : Nat) : Prop
```

with the fixed-denominator witness:

```lean
fixedDenomCubicArithmeticRouteTransparent (n : Nat) :
  expandedArithmeticComputesCubicAmplitudeTransparent n (3 * n)
```

The existing expanded clean-block contract is the only declaration that should
change for this leaf.  Its arithmetic conjunct currently uses the opaque
predicate:

```lean
expandedArithmeticComputesCubicAmplitude n workspaceQubits
```

The target refactor replaces that conjunct by:

```lean
expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits
```

All later conjuncts should remain in the same order:

```lean
expandedControlledRyUsesCubicAngle n workspaceQubits
expandedWorkspaceCleanUncomputed n workspaceQubits
expandedAmplitudeOracleCleanBlockExtracts n workspaceQubits block
diagonalCleanBlockContract n block
```

## Natural-Language Proof

Claim.  The refactored contract is a faithful arithmetic-contract boundary for
the current expanded route.

Proof.  The source equation only requires the clean block to be the diagonal
operator with entries $(j/2^n)^3$ and normalizer $1$.  The fixed-denominator
arithmetic backend already proves the transparent statement that there exists
an explicit backend computing `CubicStatePreparation.cubicAmplitude n j` for
each basis index `j`.  Therefore the arithmetic part of the expanded
clean-block contract should consume
`expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits`, not
the old opaque route predicate.

For `workspaceQubits = 3 * n`, the arithmetic conjunct is supplied directly by
`fixedDenomCubicArithmeticRouteTransparent n`.  This does not prove
`expandedArithmeticComputesCubicAmplitude n (3 * n)` and does not supply
`expandedArithmeticBackendBridge (fixedDenomCubicArithmeticBackend n)`.  The
normal-form theorem `fixedDenomCubicArithmeticBackend_bridge_iff` records why
direct bridge search is stale: for this backend, the bridge is equivalent to
the opaque route predicate itself.

The downstream diagonal theorem should remain valid after the refactor.  If
`h : expandedAmplitudeOracleCleanBlockContract n workspaceQubits block`, then
the fifth conjunct of `h` is still `diagonalCleanBlockContract n block`.
Hence `expandedAmplitudeOracleCleanBlockContract_diagonal` can continue to
project `h.2.2.2.2`.  Applying `primitiveOracleCleanBlock_eq_target` to this
diagonal contract still proves that `block` is pointwise equal to
`(cubicDiagonalTarget n).operator`.

The semantic-contract bridge should also remain valid.  From
`hContract : expandedAmplitudeOracleCleanBlockContract n workspaceQubits block`,
the fourth conjunct is still
`expandedAmplitudeOracleCleanBlockExtracts n workspaceQubits block`, projected
as `hContract.2.2.2.1`.  Together with
`expandedAmplitudeOracleCleanBlockContract_eq_target`, this gives the same
existential clean-block statement as before.

The refactor does not close the controlled-`R_y` backend witness, clean
uncompute, clean-block extraction, unitarity, circuit semantics, root
certificate, or executable exports.  Those remain separate DAG nodes.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-TGT-001` | Define the diagonal cubic target and alpha `1`. | none | existing Lean | `cubicDiagonalOperator`, `cubicDiagonalTarget`, `exactNormalizer` | task packet and conversion window | `python3 tools/qbe.py check` | proved |
| `DIAG-ARITH-FIXED-DENOM-BACKEND-001` | Define the fixed-denominator backend and prove pointwise compute semantics. | capacity and algebra leaves | existing Lean | `fixedDenomCubicArithmeticBackend`, `fixedDenomCubicArithmeticBackend_computes` | fixed-denominator proof packets | `python3 tools/qbe.py check` | proved |
| `DIAG-ARITH-ROUTE-TRANSPARENT-001` | Package the fixed-denominator backend as a transparent arithmetic route witness. | `DIAG-ARITH-FIXED-DENOM-BACKEND-001` | existing Lean | `expandedArithmeticComputesCubicAmplitudeTransparent`, `fixedDenomCubicArithmeticRouteTransparent` | route-transparent proof packets | `python3 tools/qbe.py check` | proved; not an opaque route certificate |
| `DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001` | Refactor the expanded clean-block contract so its arithmetic conjunct consumes the transparent predicate. | `DIAG-ARITH-ROUTE-TRANSPARENT-001`, existing contract shape | next lower Lean worker | edit `expandedAmplitudeOracleCleanBlockContract` | this packet | `python3 tools/qbe.py check` | next active leaf |
| `DIAG-ARITH-BACKEND-BRIDGE-001` | Supply a nontrivial bridge to the old opaque arithmetic route predicate only if the transparent refactor is rejected. | route normal form plus accepted bridge semantics | future upper or middle decision | possible witness of `expandedArithmeticBackendBridge` | proof-obligation ledger | `python3 tools/qbe.py check` | parked; direct search is stale |
| `DIAG-RY-BACKEND-WITNESS-001` | Supply concrete controlled-`R_y` backend semantics. | scalar-tier `R_y` range bridge | future lower Lean worker | witness of `expandedControlledRyBackendBridge tier n workspaceQubits` | proof-obligation ledger | `python3 tools/qbe.py check` | blocked |
| `DIAG-EXP-UNCOMP-001` | Prove arithmetic workspace cleanup after rotation. | arithmetic contract and rotation backend witness | future lower Lean worker | `expandedWorkspaceCleanUncomputed` | proof-obligation ledger | `python3 tools/qbe.py check` | blocked |
| `DIAG-ROOT-001` | Package an exact block-encoding certificate for the diagonal operator. | arithmetic contract, rotation, uncompute, extraction, unitarity | future lower and reviewer | planned expanded certificate or conditional primitive certificate | candidate population and proof obligations | full project gate | blocked |

Next active leaf for the Lean worker:
`DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001`.

## Ordered Lean Work

1. Reuse `expandedArithmeticComputesCubicAmplitudeTransparent` and
   `fixedDenomCubicArithmeticRouteTransparent`; do not redefine them.
2. In `QuantumBlockEncoding/CubicStatePreparation.lean`, edit only the
   definition and nearby docstring of `expandedAmplitudeOracleCleanBlockContract`.
3. Replace the first conjunct
   `expandedArithmeticComputesCubicAmplitude n workspaceQubits` by
   `expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits`.
4. Keep the remaining conjunct order unchanged so
   `expandedAmplitudeOracleCleanBlockContract_diagonal`,
   `expandedAmplitudeOracleCleanBlockContract_eq_target`, and
   `expandedAmplitudeOracleSemanticContract_cleanBlock_eq_target` can continue
   to use the same projections.
5. Run `python3 tools/qbe.py check`.  For final closeout, also run
   `lake build && lake build Tests`.

No new Lean theorem is required for the refactor.  If a helper theorem is
useful after the edit, it should only expose the arithmetic conjunct for
`workspaceQubits = 3 * n` from
`fixedDenomCubicArithmeticRouteTransparent n`; it must not bridge to the
opaque predicate.

## Failure Analysis

The current diagonal target is mathematically consistent with the user source.
The wrong route would be to keep attacking
`expandedArithmeticBackendBridge (fixedDenomCubicArithmeticBackend n)` as a
fresh tactic problem.  The compiled normal form shows that this is equivalent
to the opaque route predicate and adds no new arithmetic information.

The refactor would be invalid if it changed the target operator, changed
`exactNormalizer n = 1`, removed the rotation or uncompute obligations, claimed
unitarity, created an executable export, or introduced a theorem from the
transparent predicate to the opaque predicate without a named nontrivial
route-semantics bridge.

If the Lean edit causes projection failures, the expected repair is local:
confirm the conjunction order after the arithmetic conjunct is unchanged.
Do not rewrite the downstream clean-block target or the diagonal operator.

## Typed Feedback

```text
leaf=DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=null
block_entry_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
closed_theorem_ok=false
route_certificate_ok=false
error_class=symbolic_bridge_gap
next_route=lower Lean worker should refactor expandedAmplitudeOracleCleanBlockContract to consume expandedArithmeticComputesCubicAmplitudeTransparent; keep rotation, uncompute, extraction, root, and exports blocked
```

## Handoff

This packet makes `DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001` implementation-ready
for a Lean worker.  The only proposed Lean change is replacing the arithmetic
conjunct of `expandedAmplitudeOracleCleanBlockContract` with
`expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits`.  The
fixed-denominator witness supplies that conjunct for `workspaceQubits = 3 * n`;
all rotation, uncompute, extraction, unitarity, root certificate, and export
obligations remain open.
