# Lower Refiner Attempt: DIAG-ARITH-ROUTE-INTERFACE-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`
Timestamp: `2026-06-20 07:48:47 JST`
Role: lower refiner/reducer

## Reported Failure

Failed parent theorem/route:

```lean
expandedArithmeticBackendBridge (fixedDenomCubicArithmeticBackend n)
```

Rejected direct route:

```lean
intro hBackend
-- residual goal:
-- expandedArithmeticComputesCubicAmplitude n (3 * n)
```

The reported error class is `symbolic_bridge_gap`, not a new Lean parser
failure.  The previous normal form
`expandedArithmeticBackendBridge_iff_of_computes` shows that, once
`fixedDenomCubicArithmeticBackend_computes n` is available, direct bridge proof
search is equivalent to proving the opaque route predicate
`expandedArithmeticComputesCubicAmplitude n (3 * n)`.  There is no transparent
route-semantics witness yet, so closing the bridge directly would be stale.

## Patch

Added the fixed-denominator bridge normal form:

```lean
theorem fixedDenomCubicArithmeticBackend_bridge_iff
    (n : Nat) :
    expandedArithmeticBackendBridge (fixedDenomCubicArithmeticBackend n) ↔
      expandedArithmeticComputesCubicAmplitude n (3 * n)
```

This is a proof-reduction patch only.  It does not prove
`expandedArithmeticComputesCubicAmplitude`, does not supply
`expandedArithmeticBackendBridge`, and does not modify the diagonal target,
normalizer, or fixed-denominator backend.

## Verifier Feedback

```text
leaf=DIAG-ARITH-ROUTE-INTERFACE-001
blocked_parent=DIAG-ARITH-BACKEND-BRIDGE-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=null
block_entry_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
normal_form_theorem_ok=true
closed_theorem_ok=false
error_class=symbolic_bridge_gap
next_route=supply a transparent route-semantics witness for expandedArithmeticComputesCubicAmplitude n (3 * n), or an honest fixed-denominator backend bridge; keep root and exports blocked
```

## Gate

`python3 tools/qbe.py check` passed after the Lean edit.

