# QBE-OP-CUBIC-DIAGONAL-001 Lower Implementation Block

Timestamp: 2026-06-20 05:24 JST

Leaf inspected: `DIAG-ARITH-BACKEND-BRIDGE-001`

Assigned Lean-facing target:

```lean
expandedArithmeticBackendBridge
  (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
```

Current compiled dependencies:

- `symbolicExpandedCubicArithmeticBackend n workspaceQubits`
- `symbolicExpandedCubicArithmeticBackend_computes n workspaceQubits`
- `expandedArithmeticComputesCubicAmplitude_of_symbolicBackendBridge`
- `symbolicExpandedCubicArithmeticBackend_bridge_iff`

Result: blocked before Lean edit.

Reason: the latest task-local proof map and middle feedback classify
`DIAG-ARITH-REP-001` as the active dependency with
`workspace_representation_specified=false`.  The symbolic bridge normal form
already shows that a direct proof of the bridge for
`symbolicExpandedCubicArithmeticBackend` reduces to the opaque route predicate
`expandedArithmeticComputesCubicAmplitude n workspaceQubits`.  Proving that
opaque predicate by `trivial`, by a new assumption, or by setting a semantic
proposition to `True` would violate the task packet.

Exact remaining Lean goal after the missing dependency is supplied:

```lean
expandedArithmeticBackendBridge
  (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
```

or a replacement register-level backend with:

```lean
expandedArithmeticBackendComputesCubicAmplitude backend
```

and an honest bridge:

```lean
expandedArithmeticBackendBridge backend
```

Next route: lower 1 or middle must first resolve `DIAG-ARITH-REP-001` by
naming a concrete workspace/register/backend representation, or keep the
arithmetic bridge parent blocked.  No Lean theorem was added in this attempt.
