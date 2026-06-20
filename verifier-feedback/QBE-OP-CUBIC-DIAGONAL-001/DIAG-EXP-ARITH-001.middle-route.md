# Verifier Feedback: DIAG-EXP-ARITH-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Leaf: `DIAG-EXP-ARITH-001`

This middle route card records the coordinator decision after the compiled
conditional `DIAG-RY-BRIDGE-001` theorem.  It does not run a new finite
diagnostic and does not claim theorem closure.

## Source Object

The source object is the user-provided diagonal operator
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise, with
normalizer $\alpha = 1$.  The arithmetic leaf concerns only the compute phase
for the diagonal value
`CubicStatePreparation.cubicAmplitude n j`, equivalently $(j/2^n)^3$.

## Lean Status

The expanded route names the arithmetic obligation as
`CubicDiagonalOracle.expandedArithmeticComputesCubicAmplitude n workspaceQubits`.
This proposition is still opaque.  The next lower worker must either prove it
from an honest arithmetic backend already present in the Lean surface, or
record a concrete arithmetic backend obligation.  The worker must not close
the proposition by `trivial`, an untracked axiom, or a semantic proposition set
to `True`.

The rotation backend witness
`CubicDiagonalOracle.expandedControlledRyBackendBridge tier n workspaceQubits`
is recorded as a separate open backend obligation.

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
next_route=prove expandedArithmeticComputesCubicAmplitude from an honest arithmetic backend, or record a concrete arithmetic backend obligation without closing opaque semantics by trivial
```
