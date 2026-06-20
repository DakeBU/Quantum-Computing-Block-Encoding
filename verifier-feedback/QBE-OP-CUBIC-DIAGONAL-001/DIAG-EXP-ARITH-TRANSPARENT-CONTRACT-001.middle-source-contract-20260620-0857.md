# Verifier Feedback: DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

## Classification

This middle packet classifies the next leaf after the lower transparent
arithmetic witness closed.  The source correspondence is still the
user-provided diagonal operator with normalizer `1`.

The lower result is useful but partial:

- `expandedArithmeticComputesCubicAmplitudeTransparent` compiles.
- `fixedDenomCubicArithmeticRouteTransparent` compiles.
- The old opaque predicate `expandedArithmeticComputesCubicAmplitude` remains
  unproved.
- Direct bridge retry is stale because
  `fixedDenomCubicArithmeticBackend_bridge_iff` reduces it to the opaque
  predicate.

## Next Route

The next route is a contract refactor: make
`expandedAmplitudeOracleCleanBlockContract` consume
`expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits` as its
arithmetic conjunct.  Keep rotation, clean uncompute, extraction, unitarity,
root, and export fields open.

## Typed Feedback

```text
leaf=DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001
blocked_parent=DIAG-ROOT-001
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=null
block_entry_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
closed_theorem_ok=false
route_certificate_ok=false
error_class=symbolic_bridge_gap
next_route=refactor expandedAmplitudeOracleCleanBlockContract to consume expandedArithmeticComputesCubicAmplitudeTransparent; keep rotation, uncompute, extraction, root, and exports blocked
```
