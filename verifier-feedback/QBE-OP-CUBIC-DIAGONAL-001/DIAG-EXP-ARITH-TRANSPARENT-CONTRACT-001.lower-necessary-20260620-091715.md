# Verifier Feedback: DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

## Active Leaf

`DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001` is the active leaf
under `DIAG-ROOT-001`.  The diagnostic is necessary because the
next Lean refactor should only replace the arithmetic conjunct
with the transparent predicate if the closed fixed-denominator
arithmetic witness still matches the user-provided diagonal
operator and register shape.

## Executable Diagnostic

Command:

```bash
python3 verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/diag_exp_arith_transparent_contract_check.py \
  --json-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001.lower-necessary-20260620-091715.feedback.json \
  --md-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001.lower-necessary-20260620-091715.md \
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

## Contract Surface

- transparent predicate compiled: `true`
- transparent witness compiled: `true`
- fixed-denominator compute proof compiled: `true`
- expanded contract present: `true`
- contract uses transparent arithmetic: `true`
- contract uses opaque arithmetic: `false`
- old opaque route predicate still present: `true`

The old opaque predicate may remain declared, but this leaf expects
the expanded clean-block contract to consume the transparent
arithmetic predicate instead of retrying a direct bridge proof.

## Verdict

No finite arithmetic/register contradiction was found.  The transparent-contract refactor remains source-compatible as a necessary condition, but it is not a block-entry or route certificate.

Block-entry extraction, unitarity, clean uncompute, and executable
exports remain `null` until a named Lean route certificate exists.

## Typed Feedback

```text
leaf=DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001
blocked_parent=DIAG-ROOT-001
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
contract_refactor_ready=true
contract_refactor_present=true
error_class=symbolic_bridge_gap
next_route=Treat only the transparent arithmetic conjunct as refactored; keep rotation backend, clean uncompute, extraction, unitarity, root certificate, and exports blocked.
```
