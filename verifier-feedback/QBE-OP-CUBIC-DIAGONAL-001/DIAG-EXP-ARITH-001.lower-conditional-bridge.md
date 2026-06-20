# DIAG-EXP-ARITH-001 Lower Conditional Bridge Feedback

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Leaf: `DIAG-EXP-ARITH-001`

Result: compiled conditional bridge, not theorem closure.

Lean declarations added in `QuantumBlockEncoding.CubicDiagonalOracle`:

- `ExpandedCubicArithmeticBackend`
- `expandedArithmeticBackendComputesCubicAmplitude`
- `expandedArithmeticBackendBridge`
- `expandedArithmeticComputesCubicAmplitude_of_backendBridge`

The theorem
`expandedArithmeticComputesCubicAmplitude_of_backendBridge` closes only from a
backend object satisfying the pointwise compute predicate and an explicit bridge
from that predicate to the opaque route predicate
`expandedArithmeticComputesCubicAmplitude`.  It does not prove the opaque
arithmetic semantics unconditionally.

Typed feedback:

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
error_class=symbolic_bridge_gap
next_route=Instantiate ExpandedCubicArithmeticBackend and expandedArithmeticBackendBridge for a concrete reversible arithmetic backend, or run a finite arithmetic backend diagnostic before another Lean proof attempt.
```
