# Verifier Feedback: DIAG-ARITH-ROUTE-TRANSPARENT-001 Middle Source Correspondence

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Leaf: `DIAG-ARITH-ROUTE-TRANSPARENT-001`

Blocked parent: `DIAG-ARITH-BACKEND-BRIDGE-001`

## Source Object

The source object is the user-provided diagonal operator
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise.  The
normalizer is `alpha = 1`.

No paper source, figure, or cited theorem is active for this leaf.

## Lean Contract

The closed fixed-denominator backend is:

```lean
fixedDenomCubicArithmeticBackend n :
  ExpandedCubicArithmeticBackend n (3 * n)
```

The closed pointwise compute theorem is:

```lean
fixedDenomCubicArithmeticBackend_computes n :
  expandedArithmeticBackendComputesCubicAmplitude
    (fixedDenomCubicArithmeticBackend n)
```

The next transparent interface should be:

```lean
def expandedArithmeticComputesCubicAmplitudeTransparent
    (n workspaceQubits : Nat) : Prop :=
  Exists fun backend : ExpandedCubicArithmeticBackend n workspaceQubits =>
    expandedArithmeticBackendComputesCubicAmplitude backend

theorem fixedDenomCubicArithmeticRouteTransparent
    (n : Nat) :
    expandedArithmeticComputesCubicAmplitudeTransparent n (3 * n)
```

The theorem should use the witness `fixedDenomCubicArithmeticBackend n` and
the proof `fixedDenomCubicArithmeticBackend_computes n`.

## Classification

This is a QBE-local semantic bridge step.  The fixed-denominator arithmetic
payload and amplitude equality are compiled, but the existing route predicate
`expandedArithmeticComputesCubicAmplitude n (3 * n)` is still opaque.  The
transparent existential witness is a build-testable intermediate interface,
not a route certificate.

After this witness exists, upper or middle must decide whether to refactor the
expanded arithmetic contract to use the transparent predicate or to add a named
nontrivial bridge from the transparent predicate to the existing opaque
predicate.  Direct proof search on
`expandedArithmeticBackendBridge (fixedDenomCubicArithmeticBackend n)` remains
stale because `fixedDenomCubicArithmeticBackend_bridge_iff` reduces that
search to the opaque route predicate.

## Typed Feedback

```text
leaf=DIAG-ARITH-ROUTE-TRANSPARENT-001
blocked_parent=DIAG-ARITH-BACKEND-BRIDGE-001
source_correspondence_ok=true
workspace_representation_specified=true
capacity_lemma_compiled=true
amplitude_eq_lemma_compiled=true
backend_compute_compiled=true
normal_form_theorem=fixedDenomCubicArithmeticBackend_bridge_iff
finite_arithmetic_ok=true
finite_register_ok=true
block_entry_ok=null
normalizer_ok=true
unitarity_ok=null
ancilla_cleanup_ok=null
closed_theorem_ok=false
route_certificate_ok=false
error_class=symbolic_bridge_gap
next_route=compile expandedArithmeticComputesCubicAmplitudeTransparent and fixedDenomCubicArithmeticRouteTransparent; keep opaque bridge, root, and exports blocked
```
