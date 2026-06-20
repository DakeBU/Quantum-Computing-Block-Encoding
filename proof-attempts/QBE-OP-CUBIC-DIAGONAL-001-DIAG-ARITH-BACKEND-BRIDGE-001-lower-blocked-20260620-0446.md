# Proof Attempt: DIAG-ARITH-BACKEND-BRIDGE-001 Lower Blocked

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Leaf: `DIAG-ARITH-BACKEND-BRIDGE-001`

Timestamp: `2026-06-20 04:46 JST`

## Target

The assigned Lean target is a witness of:

```lean
expandedArithmeticBackendBridge
  (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
```

or a register-level replacement backend carrying the same pointwise compute
proof and bridge.

## Existing Dependencies

- `symbolicExpandedCubicArithmeticBackend n workspaceQubits` is compiled.
- `symbolicExpandedCubicArithmeticBackend_computes n workspaceQubits` is
  compiled and proves the pointwise compute predicate.
- `expandedArithmeticComputesCubicAmplitude_of_symbolicBackendBridge` is
  compiled and closes the route predicate only after an honest `hBridge`.

## Blocker

The bridge definition is:

```lean
def expandedArithmeticBackendBridge
    {n workspaceQubits : Nat}
    (backend : ExpandedCubicArithmeticBackend n workspaceQubits) : Prop :=
  expandedArithmeticBackendComputesCubicAmplitude backend ->
    expandedArithmeticComputesCubicAmplitude n workspaceQubits
```

The consequent `expandedArithmeticComputesCubicAmplitude n workspaceQubits` is
an opaque route predicate.  The current task-local proof map explicitly records
that `DIAG-ARITH-REP-001` has not yet supplied a concrete workspace/register
semantics explaining why the symbolic backend realizes that opaque predicate.

Therefore a direct proof of the bridge would require one of the disallowed
routes:

- assuming the opaque route predicate;
- adding an axiom;
- changing the route predicate to `True`;
- closing the bridge by a vacuous or irrelevant theorem.

No Lean source was edited in this attempt.

## Typed Outcome

```text
leaf=DIAG-ARITH-BACKEND-BRIDGE-001
immediate_dependency=DIAG-ARITH-REP-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
closed_theorem_ok=false
workspace_representation_specified=false
error_class=symbolic_bridge_gap
next_route=name a concrete workspace/register/backend representation for DIAG-ARITH-REP-001, then supply expandedArithmeticBackendBridge; otherwise keep this leaf blocked
```

