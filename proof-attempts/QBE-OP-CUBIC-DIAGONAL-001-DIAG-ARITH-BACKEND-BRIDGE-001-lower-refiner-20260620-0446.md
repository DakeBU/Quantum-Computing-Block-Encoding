# QBE-OP-CUBIC-DIAGONAL-001 DIAG-ARITH-BACKEND-BRIDGE-001 Lower Refiner Attempt

Timestamp: 2026-06-20 04:46 JST

Role: lower Lean refiner/reducer.

## Active Leaf

`DIAG-ARITH-BACKEND-BRIDGE-001`

Assigned target:

```lean
expandedArithmeticBackendBridge
  (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
```

or a register-level backend replacement carrying the same pointwise compute
proof and bridge.

## Exact Failed Route

Rejected direct theorem:

```lean
theorem rejected_symbolicArithmeticBackendBridge
    (n workspaceQubits : Nat) :
    expandedArithmeticBackendBridge
      (symbolicExpandedCubicArithmeticBackend n workspaceQubits) := by
  intro _hBackend
```

Lean error from stdin check:

```text
<stdin>:7:68: error: unsolved goals
n workspaceQubits : Nat
_hBackend : expandedArithmeticBackendComputesCubicAmplitude (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
|- expandedArithmeticComputesCubicAmplitude n workspaceQubits
```

This route is rejected because the remaining goal is the opaque route predicate
itself.  Filling it by `trivial`, an axiom, or a proposition set to `True`
would change the semantic objective.

## Lean Patch

Added one proof-reduction lemma:

```lean
theorem CubicDiagonalOracle.symbolicExpandedCubicArithmeticBackend_bridge_iff
    (n workspaceQubits : Nat) :
    expandedArithmeticBackendBridge
        (symbolicExpandedCubicArithmeticBackend n workspaceQubits) ↔
      expandedArithmeticComputesCubicAmplitude n workspaceQubits
```

The forward direction reuses
`expandedArithmeticComputesCubicAmplitude_of_symbolicBackendBridge`.  The
reverse direction is only the logical fact that an already-proved route
predicate supplies the bridge function; it does not prove the route predicate.

## Result

Keep the reduction lemma.  It shrinks future bridge proof search to the exact
missing semantic object and confirms that direct bridge attempts are stale
unless `DIAG-ARITH-REP-001` first supplies a concrete route representation.

## Feedback

```text
leaf=DIAG-ARITH-BACKEND-BRIDGE-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=null
block_entry_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
closed_theorem_ok=false
reduction_lemma=symbolicExpandedCubicArithmeticBackend_bridge_iff
workspace_representation_specified=false
error_class=symbolic_bridge_gap
next_route=introduce DIAG-ARITH-REP-001 as a concrete workspace/backend representation, then prove the opaque route predicate or keep the leaf blocked
```
