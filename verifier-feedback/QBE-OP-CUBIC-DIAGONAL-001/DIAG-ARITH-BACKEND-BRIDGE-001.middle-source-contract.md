# Verifier Feedback: DIAG-ARITH-BACKEND-BRIDGE-001 Middle Source Contract

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Leaf: `DIAG-ARITH-BACKEND-BRIDGE-001`

Parent leaf: `DIAG-EXP-ARITH-001`

## Source Object

The source object is the user-provided diagonal operator
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise.  The
normalizer is `alpha = 1`.

This bridge leaf concerns only the route-level interpretation of the compiled
arithmetic compute backend.  It does not include clean uncompute, rotation
semantics, clean-block extraction, unitarity, root certificate packaging, or
executable exports.

## Lean Contract

The compiled symbolic backend is:

```lean
symbolicExpandedCubicArithmeticBackend n workspaceQubits :
  ExpandedCubicArithmeticBackend n workspaceQubits
```

The compiled pointwise compute proof is:

```lean
symbolicExpandedCubicArithmeticBackend_computes n workspaceQubits :
  expandedArithmeticBackendComputesCubicAmplitude
    (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
```

The missing witness is:

```lean
expandedArithmeticBackendBridge
  (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
```

The parent route predicate may be closed only by applying:

```lean
expandedArithmeticComputesCubicAmplitude_of_backendBridge
  (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
  (symbolicExpandedCubicArithmeticBackend_computes n workspaceQubits)
  hBridge
```

If no concrete workspace representation or route-semantics witness justifies
`hBridge`, the lower worker should record a backend-representation blocker
instead of proving the opaque route predicate by `trivial`, an untracked axiom,
or a semantic proposition set to `True`.

## Typed Feedback

```text
leaf=DIAG-ARITH-BACKEND-BRIDGE-001
parent_leaf=DIAG-EXP-ARITH-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
finite_arithmetic_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
closed_theorem_ok=false
workspace_representation_specified=false
error_class=symbolic_bridge_gap
next_route=supply expandedArithmeticBackendBridge for symbolicExpandedCubicArithmeticBackend, or replace it with a register-level backend carrying the same pointwise compute proof and bridge; otherwise record the missing concrete workspace/backend representation
```
