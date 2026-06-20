# Verifier Feedback: DIAG-ARITH-BACKEND-BRIDGE-001 Middle Representation Refresh

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Leaf: `DIAG-ARITH-BACKEND-BRIDGE-001`

Immediate dependency: `DIAG-ARITH-REP-001`

## Source Object

The source object is the user-provided diagonal operator
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise.  The
normalizer is $\alpha = 1$.

There is no paper source, figure, or cited theorem for this leaf.

## Lean Contract

The compiled compute-phase backend is:

```lean
symbolicExpandedCubicArithmeticBackend n workspaceQubits :
  ExpandedCubicArithmeticBackend n workspaceQubits
```

The compiled pointwise proof is:

```lean
symbolicExpandedCubicArithmeticBackend_computes n workspaceQubits :
  expandedArithmeticBackendComputesCubicAmplitude
    (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
```

The bridge needed by the active parent leaf is:

```lean
expandedArithmeticBackendBridge
  (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
```

The route predicate may be closed from this backend only through:

```lean
expandedArithmeticComputesCubicAmplitude_of_symbolicBackendBridge
  n workspaceQubits hBridge
```

## Classification

The missing piece is `DIAG-ARITH-REP-001`: a concrete
workspace/register/backend representation that explains why the pointwise
compute predicate is the semantics used by the opaque route predicate
`expandedArithmeticComputesCubicAmplitude`.

This is QBE-local semantic glue.  It is not an external cited result, not a
paper-source gap, and not a Lean tactic gap.  A lower worker should not try to
close the opaque predicate by `trivial`, a new axiom, or a proposition set to
`True`.

## Typed Feedback

```text
leaf=DIAG-ARITH-BACKEND-BRIDGE-001
immediate_dependency=DIAG-ARITH-REP-001
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
next_route=name a concrete workspace/register/backend representation for DIAG-ARITH-REP-001, then supply expandedArithmeticBackendBridge; otherwise keep the leaf blocked
```
