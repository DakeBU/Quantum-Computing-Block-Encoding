# Verifier Feedback: DIAG-RY-BACKEND-WITNESS-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Leaf: `DIAG-RY-BACKEND-WITNESS-001`

## Necessary-Condition Check

The active leaf is the controlled-`R_y` backend witness:

```lean
hBridge : expandedControlledRyBackendBridge tier n (3 * n)
```

This diagnostic is necessary because the backend witness can only be correct if
the route still uses the user-provided diagonal amplitudes
$a_j = (j / 2^n)^3$ and the same standard `R_y` clean-entry convention already
compiled by `expandedRyCleanEntryForCubicAmplitudes_of_standardTier`.

## Executable Diagnostic

Command run:

```bash
python3 verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/diag_ry_backend_witness_check.py --json-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-RY-BACKEND-WITNESS-001.lower-necessary-20260620-100420.feedback.json
```

Checked instances: `n = 1, 2, 3, 4, 5, 6`.

Result:

- source correspondence: diagonal target, not rank-one state preparation
- finite diagonal support: passed
- amplitude range and normalizer `alpha = 1`: passed
- standard half-angle convention `theta_j = 2 arccos((j / 2^n)^3)`: passed
- Lean surface shape: `expandedControlledRyUsesCubicAngle` remains opaque and the bridge remains conditional on `hBridge`

No finite scalar/support contradiction was found.  This does not prove
`expandedControlledRyUsesCubicAngle`, does not supply
`expandedControlledRyBackendBridge`, does not certify block entry, unitarity, or
clean ancilla cleanup, and does not authorize executable exports.

## Typed Feedback

```text
leaf=DIAG-RY-BACKEND-WITNESS-001
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
theta_convention_ok=true
closed_theorem_ok=false
route_predicate_closed=false
backend_witness_certified_ok=false
error_class=symbolic_bridge_gap
next_route=State or implement a transparent backend-semantics witness hBridge : expandedControlledRyBackendBridge tier n (3 * n); keep DIAG-EXP-UNCOMP-001, block extraction, unitarity, root, and exports downstream until that witness exists.
```
