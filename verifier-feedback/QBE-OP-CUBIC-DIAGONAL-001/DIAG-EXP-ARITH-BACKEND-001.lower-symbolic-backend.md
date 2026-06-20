# DIAG-EXP-ARITH-BACKEND-001 Lower Feedback

Status: compiled partial leaf.

The Lean pass added `symbolicExpandedCubicArithmeticBackend` and proved
`symbolicExpandedCubicArithmeticBackend_computes`.  This closes the backend
shape and pointwise compute predicate for the symbolic compute phase: the
system index is preserved and the amplitude register contains
`CubicStatePreparation.cubicAmplitude n j`.

This does not close `expandedArithmeticComputesCubicAmplitude n workspaceQubits`.
The remaining active subleaf is `DIAG-ARITH-BACKEND-BRIDGE-001`: supply
`expandedArithmeticBackendBridge` for the symbolic backend, or replace it with
a register-level backend carrying the same pointwise compute proof and bridge.

Typed fields:

| Field | Value |
|---|---|
| `leaf` | `DIAG-EXP-ARITH-BACKEND-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `normalizer_ok` | `true` |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | supply `expandedArithmeticBackendBridge` for `symbolicExpandedCubicArithmeticBackend`, or replace it with a register-level backend carrying the same route bridge |
