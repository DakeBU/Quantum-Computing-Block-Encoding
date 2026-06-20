# DIAG-ARITH-BACKEND-BRIDGE-001 necessary-condition check

Active leaf: `DIAG-ARITH-BACKEND-BRIDGE-001`.

This verifier pass checks a necessary condition for the bridge

```lean
expandedArithmeticBackendBridge
  (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
```

The bridge can only be a valid route to
`expandedArithmeticComputesCubicAmplitude n workspaceQubits` if the arithmetic
compute phase preserves the system index `j` and exposes the exact payload
`CubicStatePreparation.cubicAmplitude n j = (j / 2^n)^3`.  This is necessary
for the later controlled-rotation and diagonal clean-block obligations; it is
not itself a proof of the opaque expanded route predicate.

## Diagnostic

Reran:

```bash
python3 verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/diag_exp_arith_check.py \
  --json-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-ARITH-BACKEND-BRIDGE-001.lower-necessary-cycle03.raw.feedback.json
```

The finite exact-rational diagnostic passed for `n = 1..5`:

- `finite_matrix_ok=true`
- `finite_arithmetic_ok=true`
- `support_vanish_ok=true`
- `system_preservation_ok=true`
- `normalizer_ok=true`

There is no finite/path/support contradiction against the current target.  The
diagnostic does reject using the symbolic payload check as theorem closure:
`block_entry_ok=null` because no concrete expanded-route unitary or clean-block
matrix was supplied, and `closed_theorem_ok=false` because the bridge witness is
still missing.

## Typed Feedback

```json
{
  "leaf": "DIAG-ARITH-BACKEND-BRIDGE-001",
  "source_correspondence_ok": true,
  "finite_matrix_ok": true,
  "block_entry_ok": null,
  "normalizer_ok": true,
  "workspace_representation_specified": false,
  "closed_theorem_ok": false,
  "error_class": "symbolic_bridge_gap",
  "next_route": "First close or explicitly document DIAG-ARITH-REP-001 by naming a concrete workspace/register/backend representation. Then supply expandedArithmeticBackendBridge for symbolicExpandedCubicArithmeticBackend, or replace it with a register-level backend carrying the same pointwise compute proof and bridge. Keep DIAG-ARITH-BACKEND-BRIDGE-001 blocked otherwise."
}
```
