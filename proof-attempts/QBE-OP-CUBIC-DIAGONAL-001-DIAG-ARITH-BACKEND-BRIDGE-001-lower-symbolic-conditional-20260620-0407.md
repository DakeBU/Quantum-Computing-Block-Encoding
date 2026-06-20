# QBE-OP-CUBIC-DIAGONAL-001 DIAG-ARITH-BACKEND-BRIDGE-001 Lower Attempt

Timestamp: 2026-06-20 04:07 JST

Role: lower Lean implementation worker.

## Active Leaf

`DIAG-ARITH-BACKEND-BRIDGE-001`

Assigned target:

```lean
expandedArithmeticBackendBridge
  (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
```

or a register-level backend replacement carrying the same pointwise compute
proof and bridge.

## Lean Change

Added the conditional closure theorem:

```lean
CubicDiagonalOracle.expandedArithmeticComputesCubicAmplitude_of_symbolicBackendBridge
```

Statement shape:

```lean
theorem expandedArithmeticComputesCubicAmplitude_of_symbolicBackendBridge
    (n workspaceQubits : Nat)
    (hBridge :
      expandedArithmeticBackendBridge
        (symbolicExpandedCubicArithmeticBackend n workspaceQubits)) :
    expandedArithmeticComputesCubicAmplitude n workspaceQubits
```

The proof applies the already compiled pointwise compute proof
`symbolicExpandedCubicArithmeticBackend_computes n workspaceQubits` through the
general conditional theorem
`expandedArithmeticComputesCubicAmplitude_of_backendBridge`.

## Result

This is useful Lean routing progress, but it does not close the active bridge
witness.  The remaining exact goal is still:

```lean
hBridge :
  expandedArithmeticBackendBridge
    (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
```

or a register-level backend replacement with an honest bridge witness.

## Feedback

```text
leaf=DIAG-ARITH-BACKEND-BRIDGE-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=null
block_entry_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
closed_theorem_ok=false
conditional_theorem_closed=expandedArithmeticComputesCubicAmplitude_of_symbolicBackendBridge
workspace_representation_specified=false
error_class=symbolic_bridge_gap
next_route=introduce a concrete workspace/backend representation and then supply expandedArithmeticBackendBridge, or keep this leaf blocked
```
