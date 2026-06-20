# Verifier Feedback: DIAG-ARITH-FIXED-DENOM-CAP-001 Middle Source Contract

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Leaf: `DIAG-ARITH-FIXED-DENOM-CAP-001`

Blocked parent: `DIAG-ARITH-BACKEND-BRIDGE-001`

## Source Object

The source is the user-provided diagonal operator
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise, with
normalizer `alpha = 1`.  No paper-source archive or cited theorem is active.

## Lean-Facing Contract

The fixed-denominator representation from `DIAG-ARITH-REP-001` uses
workspaceQubits `3 * n`, workspace basis `Fin (gridSize (3 * n))`, clean
workspace value `0`, payload `j.val ^ 3`, and amplitude projection
`(payload : Rat) / (gridSize (3 * n) : Rat)`.

The next Lean leaf is:

```lean
fixedDenomCubicPayload_lt_capacity
```

It should prove, for `j : Fin (gridSize n)`, that `j.val ^ 3` is a valid
payload index:

```lean
j.val ^ 3 < gridSize (3 * n)
```

The planned dependency is `CubicStatePreparation.gridSize_three_mul_eq_cube n`,
together with the bound `j.isLt`.  After this lemma compiles, the next leaf is
`fixedDenomCubicAmplitude_eq`, proving the rational payload equals
`CubicStatePreparation.cubicAmplitude n j`.

## Route Boundary

This packet does not authorize a proof of `expandedArithmeticBackendBridge`,
`expandedArithmeticComputesCubicAmplitude`, controlled-`R_y` backend semantics,
clean uncompute, extraction, unitarity, a root certificate, or executable
exports.  Direct bridge proof search remains blocked until a fixed-denominator
backend compute proof and a transparent or accepted backend-to-route semantics
interface exist.

## Typed Feedback

```text
leaf=DIAG-ARITH-FIXED-DENOM-CAP-001
blocked_parent=DIAG-ARITH-BACKEND-BRIDGE-001
source_correspondence_ok=true
workspace_representation_specified=true
lean_representation_declared=false
workspace_qubits=3*n
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
next_route=prove fixedDenomCubicPayload_lt_capacity, then fixedDenomCubicAmplitude_eq
```
