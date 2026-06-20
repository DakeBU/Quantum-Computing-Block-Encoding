# Lower Refiner Attempt: DIAG-ARITH-ROUTE-TRANSPARENT-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`
Timestamp: `2026-06-20 08:33:05 JST`
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

The current failure class is `symbolic_bridge_gap`.  The prior theorem
`fixedDenomCubicArithmeticBackend_bridge_iff` shows that direct bridge search
for the fixed-denominator backend is equivalent to proving the opaque expanded
route predicate itself.  That route is still not available as a transparent
semantic witness.

## Patch

Added the transparent route interface:

```lean
def expandedArithmeticComputesCubicAmplitudeTransparent
    (n workspaceQubits : Nat) : Prop :=
  Exists fun backend : ExpandedCubicArithmeticBackend n workspaceQubits =>
    expandedArithmeticBackendComputesCubicAmplitude backend
```

Added the fixed-denominator witness:

```lean
theorem fixedDenomCubicArithmeticRouteTransparent
    (n : Nat) :
    expandedArithmeticComputesCubicAmplitudeTransparent n (3 * n)
```

The proof uses the existing witness
`fixedDenomCubicArithmeticBackend n` and the existing theorem
`fixedDenomCubicArithmeticBackend_computes n`.

## Scope

This closes only the transparent arithmetic-route leaf.  It does not prove
`expandedArithmeticComputesCubicAmplitude n (3 * n)`, does not supply
`expandedArithmeticBackendBridge`, and does not certify rotation semantics,
clean uncompute, clean-block extraction, unitarity, the root block encoding, or
any executable export.

## Verifier Feedback

```text
leaf=DIAG-ARITH-ROUTE-TRANSPARENT-001
blocked_parent=DIAG-ARITH-BACKEND-BRIDGE-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=null
block_entry_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
transparent_leaf_closed=true
closed_theorem_ok=true
opaque_route_certificate_ok=false
root_certificate_ok=false
error_class=symbolic_bridge_gap
next_route=upper or middle must choose a named bridge from the transparent existential predicate to the opaque route predicate, or refactor the expanded arithmetic contract to use the transparent predicate; keep root and exports blocked
```

## Gate

`python3 tools/qbe.py check` passed after the Lean edit.

## Keep, Retry, Or Reject

Keep this patch as the compiled transparent witness.  Do not retry direct
bridge tactic search on `expandedArithmeticBackendBridge
(fixedDenomCubicArithmeticBackend n)` until a named bridge or contract refactor
has been adopted.
