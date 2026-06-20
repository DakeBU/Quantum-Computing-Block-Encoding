# Verifier Feedback: DIAG-ARITH-FIXED-DENOM-BACKEND-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

## Active Leaf

`DIAG-ARITH-FIXED-DENOM-BACKEND-001` is the active compute-phase
backend leaf.  The diagnostic is necessary because the planned
Lean theorem must show that the backend preserves the system index
and writes a workspace whose distinguished amplitude register is
`CubicStatePreparation.cubicAmplitude n j`.

The finite model uses workspace `Fin (gridSize (3 * n))`, clean
workspace `0`, payload `j^3`, and projection
`payload / gridSize (3 * n)`.  If this model failed on finite
instances, the Lean worker would be proving the wrong backend.

## Executable Diagnostic

Command:

```bash
python3 verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/diag_fixed_denom_backend_check.py \
  --json-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-ARITH-FIXED-DENOM-BACKEND-001.lower-necessary-20260620-065526.feedback.json \
  --md-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-ARITH-FIXED-DENOM-BACKEND-001.lower-necessary-20260620-065526.md
```

Checked finite instances: `0, 1, 2, 3, 4, 5, 6`.  The `n = 0` case is
included because current Lean declarations are over `Nat`; the
source request still describes positive qubit counts.

| n | grid | workspace qubits | max payload | capacity | workspace ok | payload ok | preserves j | amplitude ok | normalizer ok |
|---|---:|---:|---:|---:|---|---|---|---|---|
| 0 | 1 | 0 | 0 | 1 | True | True | True | True | True |
| 1 | 2 | 3 | 1 | 8 | True | True | True | True | True |
| 2 | 4 | 6 | 27 | 64 | True | True | True | True | True |
| 3 | 8 | 9 | 343 | 512 | True | True | True | True | True |
| 4 | 16 | 12 | 3375 | 4096 | True | True | True | True | True |
| 5 | 32 | 15 | 29791 | 32768 | True | True | True | True | True |
| 6 | 64 | 18 | 250047 | 262144 | True | True | True | True | True |

## Verdict

No finite contradiction was found for the active backend shape. The check is a necessary condition only; it does not close the Lean compute theorem or any block-encoding certificate.

Block-entry extraction, unitarity, clean uncompute, and executable
exports remain `null` because no named Lean route certificate exists.
`DIAG-ARITH-BACKEND-BRIDGE-001` remains blocked by the opaque route
predicate.

## Typed Feedback

```text
leaf=DIAG-ARITH-FIXED-DENOM-BACKEND-001
blocked_parent=DIAG-ARITH-BACKEND-BRIDGE-001
source_correspondence_ok=true
workspace_representation_specified=true
workspace_qubits=3 * n
finite_register_ok=true
finite_backend_compute_ok=true
finite_matrix_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
lean_parse_ok=null
lean_build_ok=null
closed_theorem_ok=false
error_class=lean_tactic_gap
next_route=Implement fixedDenomCubicArithmeticBackend and prove fixedDenomCubicArithmeticBackend_computes using fixedDenomCubicPayload_lt_capacity and fixedDenomCubicAmplitude_eq; keep the opaque backend bridge blocked.
```
