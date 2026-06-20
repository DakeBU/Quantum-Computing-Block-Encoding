# Verifier Feedback: DIAG-ARITH-BACKEND-BRIDGE-001 Cycle 2 Middle Source Correspondence

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Leaf: `DIAG-ARITH-BACKEND-BRIDGE-001`

Parent leaf: `DIAG-EXP-ARITH-001`

## Source Object

The source object is the user-provided diagonal operator
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise.  The
normalizer is `alpha = 1`.

No paper source, figure, or cited theorem is active for this leaf.

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

The missing bridge is:

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

## Classification

This is a QBE-local semantic bridge gap.  The symbolic backend is a useful
compute-phase witness, but it is not a concrete route-semantics backend.  Until
a concrete workspace/backend representation is introduced, the field
`workspace_representation_specified` remains `false` and the primary
`error_class` is `symbolic_bridge_gap`.

Lower workers should not continue tactic search on the opaque route predicate
without a new representation or bridge witness.  They should not close the
predicate by `trivial`, an untracked axiom, or a semantic proposition set to
`True`.

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
next_route=introduce a concrete workspace/backend representation and then supply expandedArithmeticBackendBridge, or keep this leaf blocked
```
