# Middle Memory Retrieval: DIAG-ARITH-ROUTE-TRANSPARENT-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`
Timestamp: 2026-06-20 08:23 JST
Profile: middle memory/retrieval curator

## Retire

The following lower targets are stale for the next packet:

| Target | Reason |
|---|---|
| `DIAG-ARITH-FIXED-DENOM-CAP-001` | Closed by `fixedDenomCubicPayload_lt_capacity`. |
| `DIAG-ARITH-FIXED-DENOM-ALG-001` | Closed by `fixedDenomCubicAmplitude_eq`. |
| `DIAG-ARITH-FIXED-DENOM-BACKEND-001` | Closed by `fixedDenomCubicArithmeticBackend` and `fixedDenomCubicArithmeticBackend_computes`. |
| `DIAG-ARITH-ROUTE-NF-001` | Closed as normal-form memory by `fixedDenomCubicArithmeticBackend_bridge_iff`; it is not a route certificate. |
| `DIAG-EXPANDED-CONTRACT-001` | The expanded conditional interface already compiles. |
| `DIAG-EXP-RY-001` | The scalar-tier specialization `expandedRyCleanEntryForCubicAmplitudes_of_standardTier` already compiles. |

## Remember Rejections

The target remains the diagonal operator $D_n$ with normalizer $\alpha = 1$.
Do not revive these routes without an explicit upper or user decision:

| Route | Stored outcome |
|---|---|
| rank-one cubic state preparation | Invalid route: it changes the operator to a state-preparation target. |
| normalized cubic vector | Invalid route: it changes the diagonal operator and normalizer. |
| exact standard `Rat` one-signal/no-workspace primitive witness | Rejected by determinant-square diagnostics for `n = 1, 2, 3`; this rejects only that witness shape. |
| direct bridge search for `expandedArithmeticBackendBridge (fixedDenomCubicArithmeticBackend n)` | Stale symbolic route: `fixedDenomCubicArithmeticBackend_bridge_iff` reduces it to the opaque route predicate. |
| executable export before `DIAG-ROOT-001` closes | Invalid cadence: requested exports remain blocked until a named Lean certificate exists. |

## Active Leaf

The active lower-facing leaf is `DIAG-ARITH-ROUTE-TRANSPARENT-001`.

Dependencies:

- `fixedDenomCubicPayload_lt_capacity`
- `fixedDenomCubicAmplitude_eq`
- `fixedDenomCubicArithmeticBackend`
- `fixedDenomCubicArithmeticBackend_computes`
- normal-form memory `fixedDenomCubicArithmeticBackend_bridge_iff`

Lean target recommendation:

```lean
def expandedArithmeticComputesCubicAmplitudeTransparent
    (n workspaceQubits : Nat) : Prop :=
  Exists fun backend : ExpandedCubicArithmeticBackend n workspaceQubits =>
    expandedArithmeticBackendComputesCubicAmplitude backend

theorem fixedDenomCubicArithmeticRouteTransparent
    (n : Nat) :
    expandedArithmeticComputesCubicAmplitudeTransparent n (3 * n)
```

The witness should be `fixedDenomCubicArithmeticBackend n` with
`fixedDenomCubicArithmeticBackend_computes n`.  This proves only the
transparent arithmetic witness, not the existing opaque predicate
`expandedArithmeticComputesCubicAmplitude n (3 * n)`, not a clean block, not
unitarity, and not an export.

## Feedback Gaps

The next lower attempt should fill these typed fields:

| Field | Required next value |
|---|---|
| `leaf` | `DIAG-ARITH-ROUTE-TRANSPARENT-001` |
| `lean_parse_ok` | `true` or `false` after the Lean edit |
| `lean_build_ok` | `true` or `false` after the local gate |
| `closed_theorem_ok` | `true` only for `fixedDenomCubicArithmeticRouteTransparent`; this is not a root certificate |
| `route_certificate_ok` | `false` until an accepted bridge or contract refactor closes the expanded route |
| `block_entry_ok` | `null` until a named route certificate exists |
| `unitarity_ok` | `null` until a named route certificate exists |
| `ancilla_cleanup_ok` | `null` until a named route certificate exists |
| `normalizer_ok` | `true` for the unchanged target |
| `error_class` | `symbolic_bridge_gap` for direct opaque bridge retries; `none` only if the transparent witness theorem compiles |

## Retrieval Packet

For the next cycle, read only:

- `proof-attempts/QBE-OP-CUBIC-DIAGONAL-001-DIAG-ARITH-BACKEND-BRIDGE-001-route-interface.md`
- `verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-ARITH-ROUTE-TRANSPARENT-001.middle-source-correspondence-20260620-0812.feedback.json`
- this memory card
- `proof-blueprints/QBE-OP-CUBIC-DIAGONAL-001.md`
- `proof-obligations/QBE-OP-CUBIC-DIAGONAL-001.md`
- `candidate-populations/QBE-OP-CUBIC-DIAGONAL-001.md`
- `research-wiki/retrieval-index/QBE-OP-CUBIC-DIAGONAL-001.json`

The next lower packet should not reopen source proof translation, rank-one
state preparation, the primitive witness, root certification, `R_y` backend
semantics, clean uncompute, or executable exports.
