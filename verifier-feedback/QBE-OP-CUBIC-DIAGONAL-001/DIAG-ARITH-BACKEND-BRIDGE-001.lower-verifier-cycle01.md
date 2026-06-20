# Verifier Feedback: DIAG-ARITH-BACKEND-BRIDGE-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Active leaf: `DIAG-ARITH-BACKEND-BRIDGE-001`

Parent leaf: `DIAG-EXP-ARITH-001`

Root leaf fed: `DIAG-ROOT-001`

## Necessary Condition

This leaf is the bridge from the already compiled symbolic compute backend to
the opaque expanded arithmetic route predicate.  Any valid bridge for
`expandedArithmeticComputesCubicAmplitude n workspaceQubits` must at least be
consistent with the source diagonal payload

```text
a_j = (j / 2^n)^3 = CubicStatePreparation.cubicAmplitude n j
```

and with the unchanged diagonal target

```text
D_n[row, col] = if row = col then (row / 2^n)^3 else 0.
```

This is a necessary condition because a mismatch here would mean the Lean worker
is proving an arithmetic route for the wrong operator, wrong normalizer, or a
rank-one state-preparation target instead of the requested diagonal oracle.

## Diagnostic

The existing finite arithmetic/register diagnostic was run:

```bash
python3 verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/diag_exp_arith_check.py \
  --json-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-ARITH-BACKEND-BRIDGE-001.lower-verifier-cycle01.raw.feedback.json
```

It checks exact rational instances for `n = 1, 2, 3, 4, 5`.  The pass verifies
that `j^3 / 2^(3*n)` equals `(j / 2^n)^3`, the induced target is diagonal, all
off-diagonal entries vanish, the system index is preserved in the finite
compute model, and all amplitudes lie in `[0, 1]` so `alpha = 1` is consistent.

## Result

The finite/path/support diagnostic does not contradict the current target.
It rejects only theorem closure from this evidence alone: no concrete workspace
encoding, reversible arithmetic semantics, workspace-capacity witness, or
`expandedArithmeticBackendBridge` witness has been supplied.  The next Lean
route must either provide that bridge honestly from a concrete backend
representation or keep the backend-representation gap explicit.

No Qiskit, QuantumKatas-style, or QASM3 export was prepared because
`DIAG-ROOT-001` still has no named Lean certificate.

## Typed Feedback

```text
leaf=DIAG-ARITH-BACKEND-BRIDGE-001
parent_leaf=DIAG-EXP-ARITH-001
root_leaf=DIAG-ROOT-001
source_correspondence_ok=true
finite_matrix_ok=true
finite_arithmetic_ok=true
support_vanish_ok=true
system_preservation_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
closed_theorem_ok=false
workspace_representation_specified=false
workspace_capacity_checked=null
executable_exports_created=false
error_class=symbolic_bridge_gap
next_route=Supply an honest expandedArithmeticBackendBridge for symbolicExpandedCubicArithmeticBackend only if a concrete workspace/backend semantics witness exists; otherwise replace the symbolic backend with a register-level backend carrying the same pointwise compute proof and bridge, or keep the missing concrete workspace/backend representation as the blocker.
```
