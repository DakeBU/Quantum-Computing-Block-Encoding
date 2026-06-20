# Verifier Feedback: DIAG-ARITH-ROUTE-TRANSPARENT-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

## Active Leaf

`DIAG-ARITH-ROUTE-TRANSPARENT-001` is the active leaf under
`DIAG-ARITH-BACKEND-BRIDGE-001`.  The diagnostic is necessary
because the proposed transparent existential witness may only
reuse the fixed-denominator backend if that backend still matches
the user-provided diagonal operator and register shape.

## Executable Diagnostic

Command:

```bash
python3 verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/diag_route_transparent_check.py \
  --json-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-ARITH-ROUTE-TRANSPARENT-001.lower-necessary-20260620-083259.feedback.json \
  --md-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-ARITH-ROUTE-TRANSPARENT-001.lower-necessary-20260620-083259.md \
  --lean-parse-ok true \
  --lean-build-ok true
```

Checked finite instances: `0, 1, 2, 3, 4, 5, 6`.  The `n = 0` case is
included because current Lean declarations are over `Nat`; the
source request describes positive qubit counts.

| n | grid | workspace qubits | max payload | capacity | workspace ok | payload ok | preserves j | amplitude ok | finite matrix ok | normalizer ok |
|---|---:|---:|---:|---:|---|---|---|---|---|---|
| 0 | 1 | 0 | 0 | 1 | True | True | True | True | True | True |
| 1 | 2 | 3 | 1 | 8 | True | True | True | True | True | True |
| 2 | 4 | 6 | 27 | 64 | True | True | True | True | True | True |
| 3 | 8 | 9 | 343 | 512 | True | True | True | True | True | True |
| 4 | 16 | 12 | 3375 | 4096 | True | True | True | True | True | True |
| 5 | 32 | 15 | 29791 | 32768 | True | True | True | True | True | True |
| 6 | 64 | 18 | 250047 | 262144 | True | True | True | True | True | True |

## Transparent Route Status

- transparent predicate compiled: `true`
- transparent witness compiled: `true`
- fixed-denominator compute proof compiled: `true`
- opaque route predicate still present: `true`

```text
fixedDenomCubicArithmeticRouteTransparent : expandedArithmeticComputesCubicAmplitudeTransparent n (3 * n)
```

This target is a transparent arithmetic witness only.  It is not
a clean-block, unitarity, uncompute, or export certificate.

## Verdict

No finite source/register contradiction was found for the transparent witness shape.  This supports only the arithmetic witness leaf; it does not close the opaque expanded route.

Block-entry extraction, unitarity, clean uncompute, and executable
exports remain `null` until a named Lean route certificate exists.

## Typed Feedback

```text
leaf=DIAG-ARITH-ROUTE-TRANSPARENT-001
blocked_parent=DIAG-ARITH-BACKEND-BRIDGE-001
source_correspondence_ok=true
finite_register_ok=true
finite_arithmetic_ok=true
finite_matrix_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
lean_parse_ok=true
lean_build_ok=true
closed_theorem_ok=true
route_certificate_ok=false
error_class=symbolic_bridge_gap
next_route=Treat the transparent witness as closed only for this leaf; middle must choose a transparent-contract refactor or a named nontrivial bridge before the opaque route/root/export leaves move.
```
