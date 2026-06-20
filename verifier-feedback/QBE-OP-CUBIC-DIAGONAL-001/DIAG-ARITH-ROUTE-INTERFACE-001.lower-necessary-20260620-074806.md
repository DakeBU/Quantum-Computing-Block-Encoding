# Verifier Feedback: DIAG-ARITH-ROUTE-INTERFACE-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

## Active Leaf

`DIAG-ARITH-ROUTE-INTERFACE-001` is the active source-contract
leaf under the blocked parent `DIAG-ARITH-BACKEND-BRIDGE-001`.
The diagnostic is necessary because the next Lean worker should
only introduce a backend-to-route interface if the closed
fixed-denominator backend still matches the user-provided
diagonal operator and its register shape.

## Executable Diagnostic

Command:

```bash
python3 verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/diag_route_interface_check.py \
  --json-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-ARITH-ROUTE-INTERFACE-001.lower-necessary-20260620-074806.feedback.json \
  --md-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-ARITH-ROUTE-INTERFACE-001.lower-necessary-20260620-074806.md
```

Checked finite instances: `0, 1, 2, 3, 4, 5, 6`.  The `n = 0` case is
included because current Lean declarations are over `Nat`; the
source request still describes positive qubit counts.

| n | grid | workspace qubits | max payload | capacity | workspace ok | payload ok | preserves j | amplitude ok | finite matrix ok | normalizer ok |
|---|---:|---:|---:|---:|---|---|---|---|---|---|
| 0 | 1 | 0 | 0 | 1 | True | True | True | True | True | True |
| 1 | 2 | 3 | 1 | 8 | True | True | True | True | True | True |
| 2 | 4 | 6 | 27 | 64 | True | True | True | True | True | True |
| 3 | 8 | 9 | 343 | 512 | True | True | True | True | True | True |
| 4 | 16 | 12 | 3375 | 4096 | True | True | True | True | True | True |
| 5 | 32 | 15 | 29791 | 32768 | True | True | True | True | True | True |
| 6 | 64 | 18 | 250047 | 262144 | True | True | True | True | True | True |

## Route-Interface Status

- general bridge normal form compiled: `true`
- fixed-denominator backend compiled: `true`
- fixed-denominator compute proof compiled: `true`
- fixed-denominator bridge normal form compiled: `true`
- route predicate is opaque: `true`

The fixed-denominator normal-form target is already compiled.  The remaining route-interface work is a transparent semantics witness for the opaque expanded arithmetic route predicate.

```text
fixedDenomCubicArithmeticBackend_bridge_iff : expandedArithmeticBackendBridge (fixedDenomCubicArithmeticBackend n) <-> expandedArithmeticComputesCubicAmplitude n (3 * n)
```

This target is a normal-form diagnostic, not a route certificate.

## Verdict

No finite source/register contradiction was found.  This supports the route-interface shape as a necessary condition, but it does not close the opaque expanded arithmetic route predicate.

Block-entry extraction, unitarity, clean uncompute, and executable
exports remain `null` because no named Lean route certificate
exists.

## Typed Feedback

```text
leaf=DIAG-ARITH-ROUTE-INTERFACE-001
blocked_parent=DIAG-ARITH-BACKEND-BRIDGE-001
source_correspondence_ok=true
workspace_representation_specified=true
finite_register_ok=true
finite_arithmetic_ok=true
finite_matrix_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
lean_parse_ok=null
lean_build_ok=null
closed_theorem_ok=false
error_class=symbolic_bridge_gap
next_route=The fixed-denominator bridge normal form already compiles; next introduce a transparent backend-to-route semantics witness for expandedArithmeticComputesCubicAmplitude n (3 * n), or an honest expandedArithmeticBackendBridge witness for fixedDenomCubicArithmeticBackend, before any root or export work.
```
