# QBE-OP-CUBIC-DIAGONAL-001 DIAG-ARITH-BACKEND-BRIDGE-001 Lower Refiner Attempt

Timestamp: 2026-06-20 05:24 JST

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

Current Lean error from `/dev/stdin` check:

```text
/dev/stdin:9:68: error: unsolved goals
n workspaceQubits : Nat
_hBackend : expandedArithmeticBackendComputesCubicAmplitude (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
⊢ expandedArithmeticComputesCubicAmplitude n workspaceQubits
```

Rejected route: direct proof search for the symbolic backend bridge by
introducing the already-available pointwise compute proof.  The remaining goal
is the opaque expanded arithmetic route predicate itself.  Closing that goal by
`trivial`, an axiom, or a proposition set to `True` would change the semantic
objective.

## Lean Patch

Added one general proof-reduction lemma:

```lean
theorem CubicDiagonalOracle.expandedArithmeticBackendBridge_iff_of_computes
    {n workspaceQubits : Nat}
    (backend : ExpandedCubicArithmeticBackend n workspaceQubits)
    (hBackend : expandedArithmeticBackendComputesCubicAmplitude backend) :
    expandedArithmeticBackendBridge backend ↔
      expandedArithmeticComputesCubicAmplitude n workspaceQubits
```

Then rewrote the existing symbolic specialization
`symbolicExpandedCubicArithmeticBackend_bridge_iff` through the general lemma.

The forward direction applies
`expandedArithmeticComputesCubicAmplitude_of_backendBridge`.  The reverse
direction only packages an already-proved route predicate as a bridge function;
it does not prove the route predicate.

## Result

Keep the reduction lemma.  It shrinks future bridge proof search to the exact
missing semantic object for any backend that already has a pointwise compute
proof.  It also confirms that `DIAG-ARITH-BACKEND-BRIDGE-001` remains blocked
until `DIAG-ARITH-REP-001` names a concrete workspace/register/backend
representation or a route-semantics witness.

Gate passed before this record: `python3 tools/qbe.py check`.

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
reduction_lemma=expandedArithmeticBackendBridge_iff_of_computes
symbolic_specialization=symbolicExpandedCubicArithmeticBackend_bridge_iff
workspace_representation_specified=false
error_class=symbolic_bridge_gap
next_route=return to DIAG-ARITH-REP-001 and name a concrete workspace/backend representation; retry this bridge only after that representation exists
```
