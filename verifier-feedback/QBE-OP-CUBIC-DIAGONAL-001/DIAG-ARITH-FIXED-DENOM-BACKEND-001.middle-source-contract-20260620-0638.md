# Verifier Feedback: DIAG-ARITH-FIXED-DENOM-BACKEND-001 Middle Source Contract

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Leaf: `DIAG-ARITH-FIXED-DENOM-BACKEND-001`

Blocked parent: `DIAG-ARITH-BACKEND-BRIDGE-001`

## Source Object

The source is the user-provided diagonal operator
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise, with
normalizer `alpha = 1`.  No paper-source archive, figure, or cited theorem is
active.

## Lean-Facing Contract

The fixed-denominator representation from `DIAG-ARITH-REP-001` uses
workspaceQubits `3 * n`, workspace basis `Fin (gridSize (3 * n))`, clean
workspace value `0`, payload `j.val ^ 3`, and amplitude projection
`(payload : Rat) / (gridSize (3 * n) : Rat)`.

The closed dependencies are:

```lean
fixedDenomCubicPayload_lt_capacity
fixedDenomCubicAmplitude_eq
```

The next Lean leaf may add:

```lean
fixedDenomCubicArithmeticBackend n :
  ExpandedCubicArithmeticBackend n (3 * n)

fixedDenomCubicArithmeticBackend_computes n :
  expandedArithmeticBackendComputesCubicAmplitude
    (fixedDenomCubicArithmeticBackend n)
```

The backend compute proof must reuse the fixed-denominator capacity and
amplitude-equality lemmas.  It must not close the opaque route predicate by
`trivial`, set semantic propositions to `True`, or change the target into a
rank-one state-preparation problem.

## Route Boundary

This packet does not authorize a proof of `expandedArithmeticBackendBridge`,
`expandedArithmeticComputesCubicAmplitude`, controlled-`R_y` backend semantics,
clean uncompute, extraction, unitarity, root certification, or executable
exports.  Direct bridge proof search remains blocked until this backend compute
proof exists and a transparent or accepted backend-to-route semantics interface
is available.

## Typed Feedback

```text
leaf=DIAG-ARITH-FIXED-DENOM-BACKEND-001
blocked_parent=DIAG-ARITH-BACKEND-BRIDGE-001
source_correspondence_ok=true
workspace_representation_specified=true
workspace_qubits=3*n
capacity_lemma_compiled=true
amplitude_eq_lemma_compiled=true
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=null
finite_arithmetic_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
closed_theorem_ok=false
error_class=lean_tactic_gap
next_route=define fixedDenomCubicArithmeticBackend and prove its pointwise compute contract; keep the opaque bridge blocked
```
