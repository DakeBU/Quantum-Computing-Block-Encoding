# Verifier Feedback: DIAG-EXP-ARITH-BACKEND-001 Middle Source Contract

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Leaf: `DIAG-EXP-ARITH-BACKEND-001`

Parent leaf: `DIAG-EXP-ARITH-001`

## Source Object

The source object is the user-provided diagonal operator
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise.  The
normalizer is $\alpha = 1$.

This child leaf concerns only the compute phase for the diagonal value
`CubicStatePreparation.cubicAmplitude n j`.  It does not include clean
uncompute, rotation semantics, clean-block extraction, unitarity, root
certificate packaging, or executable exports.

## Lean Contract

The parent route predicate is
`CubicDiagonalOracle.expandedArithmeticComputesCubicAmplitude n workspaceQubits`.
It is still opaque.

The compiled bridge is:

```lean
expandedArithmeticComputesCubicAmplitude_of_backendBridge
    (backend : ExpandedCubicArithmeticBackend n workspaceQubits)
    (hBackend : expandedArithmeticBackendComputesCubicAmplitude backend)
    (hBridge : expandedArithmeticBackendBridge backend) :
    expandedArithmeticComputesCubicAmplitude n workspaceQubits
```

The next Lean worker may close the parent route predicate only through this
bridge.  The packet therefore requires:

- `backend : ExpandedCubicArithmeticBackend n workspaceQubits`;
- `hBackend : expandedArithmeticBackendComputesCubicAmplitude backend`, proving
  that the compute phase preserves `j` and writes
  `CubicStatePreparation.cubicAmplitude n j`;
- `hBridge : expandedArithmeticBackendBridge backend`, connecting that backend
  semantics to the opaque route predicate.

If no concrete workspace representation or bridge witness is available, the
worker should record that as the blocker instead of proving an opaque
proposition by `trivial`, an untracked axiom, or a semantic proposition set to
`True`.

## Typed Feedback

```text
leaf=DIAG-EXP-ARITH-BACKEND-001
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
next_route=instantiate ExpandedCubicArithmeticBackend, prove expandedArithmeticBackendComputesCubicAmplitude, and supply expandedArithmeticBackendBridge, or record the missing concrete backend representation
```
