# Candidate Population: QBE-OP-CUBIC-DIAGONAL-001

Updated: 2026-06-20 15:40 JST

Target:

```text
D_n[row, col] = if row = col then (row / 2^n)^3 else 0,
alpha = 1.
```

The search is in `exploratoryConstruction` mode, but the target operator is
fixed.  Candidate scores are compared only inside the same semantic tier, using
`(gateCount, depth, auxiliaryQubits, oracleCalls)`.

## Certified Population

No candidate has entered the certified population yet.  The compiled Lean
surface currently certifies the target matrix, normalizer value, amplitude
range, clean-block contract bridge to `cubicDiagonalOperator`, the oracle-label
resource tuple, the primitive candidate score tuple, a conditional primitive
semantic contract bridge, and a conditional expanded-route bridge.  It does
not yet certify a unitary primitive oracle or an expanded gate-level circuit.

## Active Candidate Records

| Candidate family | Tier | Current score | Lean surface | Remaining obligations | Next route |
|---|---|---|---|---|---|
| diagonal primitive amplitude oracle | unexpanded primitive oracle-label tier | `(1, 1, 1, 1)` via `amplitudeOracleResourceTuple_eq` and `primitiveAmplitudeOracleCandidate_costTuple_eq` | `cubicDiagonalOperator`, `exactNormalizer`, `amplitudeOracleLayout`, `amplitudeOracleCircuit`, `diagonalCleanBlockContract`, `primitiveAmplitudeOracleSemanticContract`, `primitiveAmplitudeOracleCandidate`, `primitiveAmplitudeOracleCandidate_costTuple_eq`, `primitiveAmplitudeOracleVerified` | proof of `primitiveAmplitudeOracleSemanticContract n` remains open; exact standard `Rat` one-signal/no-workspace witness subroute rejected; `primitiveAmplitudeOracleVerified n h` is conditional on `h` | parked unless upper or user explicitly accepts a primitive oracle-label semantics |
| reversible arithmetic plus controlled rotation | expanded arithmetic-gate tier | not scored yet | `expandedAmplitudeOracleLayout`, `expandedAmplitudeOracleLayout_auxiliaryQubits`, `expandedAmplitudeOracleNormalizer_eq`, `expandedArithmeticComputesCubicAmplitude`, `ExpandedCubicArithmeticBackend`, `expandedArithmeticBackendComputesCubicAmplitude`, `symbolicExpandedCubicArithmeticBackend`, `symbolicExpandedCubicArithmeticBackend_computes`, `expandedArithmeticBackendBridge`, `expandedArithmeticComputesCubicAmplitude_of_backendBridge`, `expandedArithmeticComputesCubicAmplitude_of_symbolicBackendBridge`, `symbolicExpandedCubicArithmeticBackend_bridge_iff`, `fixedDenomCubicPayload_lt_capacity`, `fixedDenomCubicAmplitude_eq`, `fixedDenomCubicArithmeticBackend`, `fixedDenomCubicArithmeticBackend_computes`, `fixedDenomCubicArithmeticBackend_bridge_iff`, `expandedArithmeticComputesCubicAmplitudeTransparent`, `fixedDenomCubicArithmeticRouteTransparent`, `expandedControlledRyUsesCubicAngle`, `expandedControlledRyUsesCubicAngleTransparent`, `fixedDenomControlledRyRouteTransparent`, `expandedControlledRyBackendBridge`, `expandedControlledRyUsesCubicAngle_of_backendBridge`, `expandedControlledRyBackendBridge_iff_of_standardTier`, `expandedWorkspaceCleanUncomputed`, `expandedAmplitudeOracleCleanBlockExtracts`, `expandedAmplitudeOracleCleanBlockContract`, `expandedAmplitudeOracleCleanBlockContract_eq_target`, `expandedAmplitudeOracleSemanticContract_cleanBlock_eq_target` | clean uncompute, clean-block extraction, unitarity/circuit semantics, resources; opaque arithmetic and rotation backend witnesses remain parked alternatives | transparent arithmetic and rotation contract refactors are closed; direct arithmetic and rotation bridge retries are stale unless upper introduces a nontrivial semantics bridge; next active route is clean-uncompute source-contract classification |

Current selection note: `DIAG-ARITH-REP-001` is no longer an unspecified
representation search.  It has a fixed-denominator proof-map candidate with
workspaceQubits `3 * n`, payload `j.val ^ 3`, and denominator
`gridSize (3 * n)`.  The capacity, algebra, and backend-compute leaves now
compile as `fixedDenomCubicPayload_lt_capacity`,
`fixedDenomCubicAmplitude_eq`, `fixedDenomCubicArithmeticBackend`,
`fixedDenomCubicArithmeticBackend_computes`, and
`fixedDenomCubicArithmeticBackend_bridge_iff`.  The next arithmetic work is not
another backend definition or bridge-normal-form lemma.  The bridge parent
`DIAG-ARITH-BACKEND-BRIDGE-001` remains blocked because the normal forms show
direct bridge search reduces to the opaque expanded-route predicate.  The
active lower target is `DIAG-ARITH-ROUTE-TRANSPARENT-001`, using the source
contract recorded in
`proof-attempts/QBE-OP-CUBIC-DIAGONAL-001-DIAG-ARITH-BACKEND-BRIDGE-001-route-interface.md`;
the fixed-denominator bridge normal form is compiled, but it is not a route
certificate.

Middle source-correspondence refresh at 2026-06-20 07:49 JST left the certified
population unchanged, and the latest lower Lean surface records the
fixed-denominator bridge normal form.  There is still no certified
block-encoding candidate.  Bridge, rotation backend, clean uncompute, root
certificate, and executable export records remain blocked downstream.

Middle source-correspondence refresh at 2026-06-20 08:12 JST adopts
`DIAG-ARITH-ROUTE-TRANSPARENT-001` as the next expanded arithmetic-gate tier
target.  The transparent witness is not a certified candidate and does not
promote the expanded route into the certified population.  It only gives lower
2 a build-testable declaration that packages the already proved
fixed-denominator backend compute theorem as a transparent arithmetic route
witness.

Middle source-correspondence refresh at 2026-06-20 08:57 JST retires
`DIAG-ARITH-ROUTE-TRANSPARENT-001` as closed and chooses the contract-refactor
route for the next expanded arithmetic-gate tier leaf.  The next active leaf is
`DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001`: refactor the existing
`expandedAmplitudeOracleCleanBlockContract` arithmetic conjunct to consume
`expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits`
directly.  This keeps the fixed-denominator witness available for
`workspaceQubits = 3 * n` without proving the old opaque route predicate.  It
does not enter the certified population and does not close rotation backend
semantics, clean uncompute, clean-block extraction, unitarity, root, or export
obligations.

Lower Lean update at 2026-06-20 09:17 JST closes
`DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001`: the existing
`expandedAmplitudeOracleCleanBlockContract` now consumes
`expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits` as its
arithmetic conjunct.  This keeps the candidate in the insight pool, not the
certified population, because rotation backend semantics, clean uncompute,
clean-block extraction, unitarity, root certification, and exports remain
open.

Middle source-correspondence refresh at 2026-06-20 09:41 JST retires
`DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001` and the closed arithmetic leaves from
new lower assignment.  The next active source-correspondence leaf for the
expanded arithmetic-gate tier is `DIAG-RY-BACKEND-WITNESS-001`: state a
backend-semantics witness
`expandedControlledRyBackendBridge tier n (3 * n)`, or record the missing
transparent backend interface as a blocked `symbolic_bridge_gap`.  This does
not promote the expanded route into the certified population.  It only
prevents stale arithmetic leaves from being reused as if they were root route
certificates.

Lower refiner update at 2026-06-20 10:04 JST adds
`expandedControlledRyBackendBridge_iff_of_standardTier`.  This is a normal-form
lemma, not a backend witness: after the scalar-tier theorem is available, direct
proof of `expandedControlledRyBackendBridge tier n workspaceQubits` is
equivalent to proving the opaque predicate
`expandedControlledRyUsesCubicAngle n workspaceQubits`.  The route remains in
the insight pool and the active blocker stays the missing transparent backend
semantics.

Middle source-correspondence refresh at 2026-06-20 10:26 JST promotes
`DIAG-RY-TRANSPARENT-INTERFACE-001` as the next expanded arithmetic-gate tier
leaf.  This leaf is allowed to add a transparent predicate
`expandedControlledRyUsesCubicAngleTransparent` and the fixed-denominator
witness theorem `fixedDenomControlledRyRouteTransparent`.  It does not certify
the controlled-rotation route, does not close
`expandedControlledRyUsesCubicAngle`, and does not move the candidate into the
certified population.

Lower Lean update at 2026-06-20 10:43 JST closes
`DIAG-RY-TRANSPARENT-INTERFACE-001`: the transparent predicate and
fixed-denominator witness theorem now compile.  The expanded route remains in
the insight pool because the opaque rotation predicate, backend witness, clean
uncompute, extraction, unitarity, root certificate, and exports remain open.

Middle source-correspondence refresh at 2026-06-20 11:04 JST chooses
`DIAG-RY-TRANSPARENT-CONTRACT-001` as the next expanded arithmetic-gate tier
leaf.  The clean-block contract should be refactored to consume
`expandedControlledRyUsesCubicAngleTransparent n workspaceQubits` directly.
This does not certify the route and does not move the candidate into the
certified population.

Lean implementation update at 2026-06-20 11:22 JST closes
`DIAG-RY-TRANSPARENT-CONTRACT-001`: `expandedAmplitudeOracleCleanBlockContract`
now consumes `expandedControlledRyUsesCubicAngleTransparent n workspaceQubits`
as its rotation conjunct.  This keeps the route in the insight pool, not the
certified population, because clean uncompute, clean-block extraction,
unitarity/circuit semantics, `DIAG-ROOT-001`, and exports remain open.

Current active-leaf selection:

| Candidate family | Active leaf | Certified status | Next route |
|---|---|---|---|
| reversible arithmetic plus controlled rotation | `DIAG-RY-WORKSPACE-READONLY-001` | not certified | State a transparent controlled-rotation workspace-readonly interface; keep the opaque cleanup predicate, extraction, unitarity, root certificate, and exports blocked. |

Middle source-correspondence refresh at 2026-06-20 11:58 JST keeps the expanded
route in the insight pool.  The lower clean-uncompute diagnostics are aligned
as follows: the finite xor skeleton supports only generic clean-workspace
plausibility, while the proposed modular add/sub cleanup witness still needs
its own Lean proof or matching diagnostic.  No candidate moves into the
certified population.

Lower and middle cleanup refresh at 2026-06-20 12:44 JST retires
`DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001` as closed interface memory:
`ExpandedArithmeticCleanUncomputeWitness`,
`expandedWorkspaceCleanUncomputedTransparent`, and
`expandedWorkspaceCleanUncomputedTransparent_of_witness` now compile.  The
expanded route remains in the insight pool because there is still no Lean
witness for `expandedWorkspaceCleanUncomputedTransparent n (3 * n)`, no
route-level proof of `expandedWorkspaceCleanUncomputed`, no extraction proof,
no unitarity/circuit semantics, no root certificate, and no executable export
authorization.

Lower cleanup closeout at 2026-06-20 13:07 JST closes
`DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001` as a transparent witness:
`fixedDenomExpandedArithmeticCleanUncomputeWitness` and
`fixedDenomWorkspaceCleanUncomputedTransparent` now compile.  This does not
move the candidate into the certified population.  The next active leaf is
`DIAG-RY-WORKSPACE-READONLY-001`, which must state that the controlled
rotation reads the payload without modifying the system index or arithmetic
workspace before any route-level cleanup bridge or contract refactor is used.

Middle parliament reconciliation at 2026-06-20 16:02 JST keeps the certified
population empty.  The expanded arithmetic-gate route stays in the insight pool
with a reusable proof-DAG spine: transparent arithmetic, transparent rotation
bookkeeping, transparent cleanup interface, and fixed-denominator cleanup
witness are compiled, but the route has no readonly-rotation interface, no
route-level cleanup proof, no clean-block extraction proof, no unitarity proof,
and no `DIAG-ROOT-001` certificate.  The primitive oracle-label route remains a
parked insight, not a certified candidate.  The approximate polynomial or
QSVT-style route remains insight-only and is not activated this cycle.

The shared insight population update for the next lower pass is:

| Route | Parliament action | Reason |
|---|---|---|
| expanded arithmetic plus controlled `R_y` | preserve and continue | it is the only active route with compiled transparent subinterfaces; the next bottleneck is a narrow readonly-rotation interface |
| primitive oracle-label amplitude oracle | preserve but park | it has a conditional contract and minimal primitive score, but no accepted primitive semantics; the exact rational subroute is rejected |
| approximate diagonal route | preserve as dormant | exact search has not stalled at the current active leaf, so the approximate phase is not opened |
| stale bridge and export routes | retire from lower assignment | direct opaque bridge retries and executable exports before `DIAG-ROOT-001` would bypass the current proof-DAG dependencies |

## Finite Executable Population

No finite executable candidate is promoted.  Lower 3 has checked the expanded
controlled-`R_y` route for `n = 1, 2, 3, 4` with source correspondence, block
entries, unitarity of the finite skeleton, clean-workspace restoration, and
normalizer all passing as necessary conditions.  Those checks are not
certified block encodings and are not parents for the certified population.

## Insight Pool

| Route | Reason kept | Status |
|---|---|---|
| primitive one-signal amplitude oracle | directly matches the diagonal target with $\alpha = 1$ and minimal unexpanded score; now has a compiled conditional contract bridge | parked unless primitive semantics are explicitly accepted |
| arithmetic exact cube with controlled `R_y` | gate-level expansion route selected after the rational primitive witness rejection | compiled conditional interface; symbolic arithmetic compute witness compiled; fixed-denominator representation candidate specified for `DIAG-ARITH-REP-001`; capacity, algebra, fixed-denominator backend compute, fixed-denominator bridge normal-form, transparent arithmetic witness, transparent arithmetic clean-block contract refactor, controlled-`R_y` bridge normal-form, transparent rotation predicate, transparent rotation witness, transparent rotation clean-block contract refactor, transparent clean-uncompute interface, and fixed-denominator transparent cleanup witness compiled; direct bridge retry is stale unless a named nontrivial semantics bridge is introduced; active next leaf is the transparent rotation workspace-readonly interface |
| approximate polynomial or QSVT-style diagonal function route | possible later approximate route for hardware-facing expansion | insight only |

## Rejected Or Retired Routes

| Route | Reason |
|---|---|
| rank-one cubic state-preparation target | wrong operator; it encodes `|v><0^n|`, not the diagonal `D_n` |
| normalized cubic vector state preparation | changes the normalizer and target semantics |
| exact standard `Rat` one-signal/no-workspace primitive witness | determinant-square necessary-condition check rejects this witness shape for `n = 1, 2, 3`; the diagonal target itself still passes |
| rebuilding `DIAG-EXPANDED-CONTRACT-001` | stale route; the expanded layout, clean-block contract, and conditional bridge already compile |
| rebuilding `DIAG-EXP-RY-001` scalar-tier specialization | stale route; `expandedRyCleanEntryForCubicAmplitudes_of_standardTier` already compiles |
| direct bridge retry for `fixedDenomCubicArithmeticBackend` | stale route after `fixedDenomCubicArithmeticBackend_bridge_iff`; direct search is equivalent to the opaque route predicate unless a separate nontrivial semantics bridge is introduced |
| direct controlled-`R_y` backend witness retry before a transparent interface | stale route after `expandedControlledRyBackendBridge_iff_of_standardTier`; direct search is equivalent to the opaque route predicate unless a separate backend-semantics bridge is introduced |
| executable export before Lean certificate | violates the post-Lean export cadence; finite code may diagnose but not certify |

## Promotion Rule

A candidate may enter the certified population only after Lean proves:

1. the advertised unitary or primitive oracle contract at the declared tier;
2. the clean block is pointwise equal to `cubicDiagonalOperator n` with
   `exactNormalizer n = 1`;
3. the resource tuple is build-tested under the fixed score order; and
4. any executable export cites the named Lean certificate instead of replacing
   it.

The declaration `primitiveAmplitudeOracleVerified n h` satisfies the packaging
shape only after a proof parameter
`h : primitiveAmplitudeOracleSemanticContract n` is supplied.  It must not be
counted as a certified population member without that proof or an explicitly
accepted primitive-tier contract.
