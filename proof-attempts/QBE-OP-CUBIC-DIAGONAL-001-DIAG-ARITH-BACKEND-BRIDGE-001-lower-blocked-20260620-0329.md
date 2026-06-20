# QBE-OP-CUBIC-DIAGONAL-001 DIAG-ARITH-BACKEND-BRIDGE-001 Lower Attempt

Timestamp: 2026-06-20 03:29 JST

Role: lower Lean implementation worker.

## Active Leaf

`DIAG-ARITH-BACKEND-BRIDGE-001`

Lean target shape:

```lean
expandedArithmeticBackendBridge
  (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
```

Parent closure theorem already compiled:

```lean
expandedArithmeticComputesCubicAmplitude_of_backendBridge
  (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
  (symbolicExpandedCubicArithmeticBackend_computes n workspaceQubits)
  hBridge
```

## Attempt

I checked the task-local proof obligations, proof-DAG frontier, and the current
Lean surface around `ExpandedCubicArithmeticBackend`.  The only backend in the
current module is the symbolic compute-phase backend:

```lean
symbolicExpandedCubicArithmeticBackend n workspaceQubits
symbolicExpandedCubicArithmeticBackend_computes n workspaceQubits
```

This proves the pointwise compute statement:

```lean
expandedArithmeticBackendComputesCubicAmplitude
  (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
```

It does not provide a concrete workspace/register representation or route-level
semantics witness for the opaque predicate:

```lean
expandedArithmeticComputesCubicAmplitude n workspaceQubits
```

## Result

No Lean theorem was added.  Closing the bridge from the symbolic compute proof
alone would amount to asserting the opaque route predicate without a concrete
backend witness.  That would violate the current proof-obligation ledger, which
records `workspace_representation_specified=false`.

## Remaining Goal

Supply one of:

```lean
hBridge :
  expandedArithmeticBackendBridge
    (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
```

or replace the symbolic backend with a register-level
`ExpandedCubicArithmeticBackend` that carries both:

```lean
expandedArithmeticBackendComputesCubicAmplitude backend
expandedArithmeticBackendBridge backend
```

Until then, `DIAG-EXP-ARITH-001` remains blocked by `symbolic_bridge_gap`.
