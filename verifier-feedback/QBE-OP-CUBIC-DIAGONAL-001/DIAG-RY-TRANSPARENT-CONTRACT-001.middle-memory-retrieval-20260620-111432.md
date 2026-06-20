# Middle Memory/Retrieval Packet: DIAG-RY-TRANSPARENT-CONTRACT-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`
Generated: `2026-06-20 11:14:32 JST`

## Stale Lower Targets To Retire

| Leaf or route | Reason to retire for the next lower packet |
|---|---|
| `DIAG-RY-TRANSPARENT-INTERFACE-001` | Closed as `expandedControlledRyUsesCubicAngleTransparent` plus `fixedDenomControlledRyRouteTransparent`; rebuilding it is stale. |
| `DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001` | Closed; the arithmetic conjunct of `expandedAmplitudeOracleCleanBlockContract` already uses `expandedArithmeticComputesCubicAmplitudeTransparent`. |
| `DIAG-ARITH-ROUTE-TRANSPARENT-001` | Closed transparent arithmetic witness only; it is not the next route. |
| `DIAG-ARITH-FIXED-DENOM-*` leaves | Capacity, algebra, backend compute, and bridge normal-form memory are compiled; do not reassign them. |
| direct `DIAG-RY-BACKEND-WITNESS-001` proof search | Stale until a nontrivial backend-semantics bridge exists; `expandedControlledRyBackendBridge_iff_of_standardTier` reduces the direct witness to the opaque route predicate. |
| direct `DIAG-ARITH-BACKEND-BRIDGE-001` proof search | Stale until a nontrivial route-semantics bridge exists; fixed-denominator bridge search reduces to the opaque arithmetic route predicate. |

## Rejected Routes To Remember

| Route | Memory status |
|---|---|
| rank-one cubic state preparation | Invalid route: wrong operator and wrong block target. |
| normalized cubic vector state preparation | Invalid route: changes the diagonal oracle target and normalizer. |
| exact standard `Rat` one-signal/no-workspace primitive witness | Rejected by determinant-square finite diagnostics; target diagonal remains valid. |
| executable exports before root Lean certificate | Blocked by post-Lean export cadence. |
| proving opaque semantic predicates by `trivial`, `True`, or axioms | Invalid route; semantic gaps must remain explicit. |

## Current Active Proof-DAG Leaf

| Field | Current value |
|---|---|
| active leaf | `DIAG-RY-TRANSPARENT-CONTRACT-001` |
| owner | lower 2 Lean implementation worker |
| target file | `QuantumBlockEncoding/CubicStatePreparation.lean` |
| allowed write scope | `expandedAmplitudeOracleCleanBlockContract` and directly adjacent comments/docstring |
| exact edit | replace the rotation conjunct `expandedControlledRyUsesCubicAngle n workspaceQubits` with `expandedControlledRyUsesCubicAngleTransparent n workspaceQubits` |
| dependencies | `expandedControlledRyUsesCubicAngleTransparent`, `fixedDenomControlledRyRouteTransparent`, `expandedRyCleanEntryForCubicAmplitudes_of_standardTier`, closed transparent arithmetic contract |
| not closed by this leaf | opaque `expandedControlledRyUsesCubicAngle`, backend witness, clean uncompute, extraction, unitarity, `DIAG-ROOT-001`, and exports |
| local gate | `python3 tools/qbe.py check` |

## Missing Typed Feedback Fields

The source-contract packet already seeds feedback for this leaf.  After lower 2
edits Lean, the lower log should fill:

| Field | Required next value |
|---|---|
| `leaf` | `DIAG-RY-TRANSPARENT-CONTRACT-001` |
| `lean_parse_ok` | `true` or `false` after the Lean edit |
| `lean_build_ok` | `true` only if `python3 tools/qbe.py check` passes |
| `closed_theorem_ok` | `true` only for the contract refactor, not for the root theorem |
| `block_entry_ok` | `null` until extraction/root certificate work starts |
| `unitarity_ok` | `null` until circuit/unitary semantics work starts |
| `ancilla_cleanup_ok` | `null` until `DIAG-EXP-UNCOMP-001` starts |
| `next_route` | if the refactor compiles, move to `DIAG-EXP-UNCOMP-001` or an explicit extraction/semantic-interface packet chosen by middle; keep exports blocked |

## Next-Cycle Retrieval Recommendation

Read, in this order:

1. `runs/20260620-105053-QBE-OP-CUBIC-DIAGONAL-001-cycle02/memory_digest.md`
2. `runs/20260620-105053-QBE-OP-CUBIC-DIAGONAL-001-cycle02/todo.md`
3. `verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-RY-TRANSPARENT-CONTRACT-001.middle-source-contract-20260620-1104.md`
4. this packet
5. `QuantumBlockEncoding/CubicStatePreparation.lean` around `expandedControlledRyUsesCubicAngleTransparent` and `expandedAmplitudeOracleCleanBlockContract`

Do not open unrelated paper memories or literature indexes for this operator
task.  No cited-result row is active.
