# Verifier Feedback: DIAG-ARITH-FIXED-DENOM-CAP-001 Lower Necessary

Task: `QBE-OP-CUBIC-DIAGONAL-001`

## Active Leaf

`DIAG-ARITH-FIXED-DENOM-CAP-001` checks that the payload
`j.val ^ 3` fits in the fixed workspace `Fin (gridSize (3 * n))`.
This is necessary for the representation parent
`DIAG-ARITH-REP-001`: without the capacity bound, the planned
fixed-denominator backend cannot even name its payload register.

The same finite diagnostic also checks the next algebra leaf:
`j^3 / 2^(3*n) = (j / 2^n)^3`, so the representation still
matches the diagonal source operator and the normalizer `alpha = 1`.

## Executable Diagnostic

Command:

```bash
python3 verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/diag_fixed_denom_check.py \
  --json-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-ARITH-FIXED-DENOM-CAP-001.lower-necessary-20260620-0550.feedback.json \
  --md-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-ARITH-FIXED-DENOM-CAP-001.lower-necessary-20260620-0550.md
```

Checked finite instances: `0, 1, 2, 3, 4, 5, 6`.  The `n = 0` case is
included because the current Lean declarations are over `Nat`;
the user-facing source still asks for positive `n`.

| n | grid | workspace qubits | max payload | capacity | capacity ok | algebra ok | normalizer ok |
|---|---:|---:|---:|---:|---|---|---|
| 0 | 1 | 0 | 0 | 1 | True | True | True |
| 1 | 2 | 3 | 1 | 8 | True | True | True |
| 2 | 4 | 6 | 27 | 64 | True | True | True |
| 3 | 8 | 9 | 343 | 512 | True | True | True |
| 4 | 16 | 12 | 3375 | 4096 | True | True | True |
| 5 | 32 | 15 | 29791 | 32768 | True | True | True |
| 6 | 64 | 18 | 250047 | 262144 | True | True | True |

## Verdict

No finite contradiction was found.  The diagnostic supports the fixed-denominator representation as a necessary condition, but it does not close any Lean theorem or certify a block encoding.

Block-entry extraction, unitarity, clean uncompute, and executable
exports remain `null` because no named Lean route certificate exists.
Direct proof search for `DIAG-ARITH-BACKEND-BRIDGE-001` remains
blocked by the opaque route predicate.

## Typed Feedback

```text
leaf=DIAG-ARITH-FIXED-DENOM-CAP-001
blocked_parent=DIAG-ARITH-BACKEND-BRIDGE-001
source_correspondence_ok=true
workspace_representation_specified=true
lean_representation_declared=false
workspace_qubits=3 * n
payload_capacity_ok=true
finite_arithmetic_ok=true
finite_matrix_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
lean_parse_ok=null
lean_build_ok=null
closed_theorem_ok=false
error_class=lean_tactic_gap
next_route=Prove fixedDenomCubicPayload_lt_capacity, then fixedDenomCubicAmplitude_eq; keep block-entry, unitarity, exports, and the opaque backend bridge blocked.
```
