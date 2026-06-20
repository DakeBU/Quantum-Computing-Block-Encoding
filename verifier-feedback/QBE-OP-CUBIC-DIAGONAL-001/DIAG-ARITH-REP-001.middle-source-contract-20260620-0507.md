# Verifier Feedback: DIAG-ARITH-REP-001 Middle Source Contract

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Leaf: `DIAG-ARITH-REP-001`

Blocked parent: `DIAG-ARITH-BACKEND-BRIDGE-001`

## Source Object

The source object is the user-provided diagonal operator
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise.  The
normalizer is $\alpha = 1$.

No paper source, figure, or cited theorem is active for this leaf.

## Lean Surface

The compiled compute-phase backend is:

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

The compiled conditional closure is:

```lean
expandedArithmeticComputesCubicAmplitude_of_symbolicBackendBridge
  n workspaceQubits hBridge
```

The compiled normal form is:

```lean
symbolicExpandedCubicArithmeticBackend_bridge_iff n workspaceQubits :
  expandedArithmeticBackendBridge
    (symbolicExpandedCubicArithmeticBackend n workspaceQubits) <->
  expandedArithmeticComputesCubicAmplitude n workspaceQubits
```

This normal form is evidence against direct tactic search on the symbolic
bridge.  It does not provide a bridge witness.

## Lower-Facing Contract

The next lower packet should target `DIAG-ARITH-REP-001`.  It must name a
concrete workspace/register/backend representation for the expanded arithmetic
route, or explicitly record that no such representation is present.

The representation must preserve the system index `j` and expose an arithmetic
payload equal to `CubicStatePreparation.cubicAmplitude n j`.  It must not claim
clean uncompute, controlled-`R_y` backend semantics, clean-block extraction,
unitarity, a root block-encoding certificate, or executable exports.

After the representation exists, the parent leaf may target:

```lean
expandedArithmeticBackendBridge
  (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
```

or a replacement register-level backend carrying the same pointwise compute
proof and an honest bridge.

## Classification

This is QBE-local semantic glue.  It is not an external cited-result
obligation, not a paper-source gap, and not a Lean tactic gap.  The current
state is `workspace_representation_specified=false` and
`error_class=symbolic_bridge_gap`.

## Typed Feedback

```text
leaf=DIAG-ARITH-REP-001
blocked_parent=DIAG-ARITH-BACKEND-BRIDGE-001
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
next_route=name a concrete workspace/register/backend representation, or keep DIAG-ARITH-BACKEND-BRIDGE-001 blocked
```
