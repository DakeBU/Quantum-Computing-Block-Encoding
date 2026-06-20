# Verifier Feedback: DIAG-EXP-ARITH-001 Lower Architect

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Leaf: `DIAG-EXP-ARITH-001`

Timestamp: 2026-06-20 02:05 JST

This lower natural-language pass updated the proof map for the arithmetic
compute leaf.  It did not edit Lean and did not run a finite arithmetic
diagnostic.

## Source Correspondence

The source value for the arithmetic compute phase is the diagonal entry
$D_n[j,j] = (j/2^n)^3$.  In Lean this is
`CubicStatePreparation.cubicAmplitude n j`, defined from
`CubicStatePreparation.gridPoint n j`.

The route predicate
`CubicDiagonalOracle.expandedArithmeticComputesCubicAmplitude n workspaceQubits`
is still opaque.  The next Lean worker should prove it only from an honest
arithmetic backend witness, or introduce a conditional backend bridge that
keeps the compute semantics explicit.

## Typed Feedback

```text
leaf=DIAG-EXP-ARITH-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=null
block_entry_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
closed_theorem_ok=false
route_predicate_closed=false
error_class=symbolic_bridge_gap
next_route=prove expandedArithmeticComputesCubicAmplitude from an honest arithmetic backend witness, or introduce a conditional arithmetic backend bridge without closing opaque semantics by trivial
```
