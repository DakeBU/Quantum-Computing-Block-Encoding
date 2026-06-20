# Verifier Feedback: DIAG-EXP-ARITH-BACKEND-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Leaf: `DIAG-EXP-ARITH-BACKEND-001`

Parent leaf: `DIAG-EXP-ARITH-001`

## Necessary Condition

The active child leaf is the concrete backend witness for the arithmetic parent
route.  Any valid witness for
`expandedArithmeticComputesCubicAmplitude n workspaceQubits` must first compute
the source diagonal payload

```text
a_j = (j / 2^n)^3 = CubicStatePreparation.cubicAmplitude n j
```

while preserving the system index `j`.  If this finite arithmetic payload did
not induce the diagonal target, a Lean worker could close the wrong backend
contract.

## Diagnostic

The executable diagnostic already exists:

```bash
python3 verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/diag_exp_arith_check.py \
  --json-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-EXP-ARITH-001.lower-verifier-cycle02.raw.feedback.json
```

It checks exact rational instances for `n = 1, 2, 3, 4, 5`.  The pass verifies:

- `j^3 / 2^(3*n)` equals `(j / 2^n)^3`;
- the induced matrix is diagonal and all off-diagonal entries vanish;
- every checked diagonal entry lies in `[0, 1]`, so `alpha = 1` is consistent;
- the finite compute model preserves the system index.

The diagnostic also records the raw numerator width for this payload form:

| n | grid size | max raw numerator | numerator bits |
|---|---:|---:|---:|
| 1 | 2 | 1 | 1 |
| 2 | 4 | 27 | 5 |
| 3 | 8 | 343 | 9 |
| 4 | 16 | 3375 | 12 |
| 5 | 32 | 29791 | 15 |

## Result

The finite/path/support check does not contradict the current diagonal target.
It rejects theorem closure only: no concrete `ExpandedCubicArithmeticBackend`,
workspace representation, capacity witness, or
`expandedArithmeticBackendBridge` has been supplied.  The next Lean route must
instantiate those objects or keep the backend representation as an explicit
blocker.  It must not close the opaque route predicate by `trivial`, a hidden
axiom, or a semantic flag promoted to `True`.

No Qiskit, QuantumKatas-style, or QASM3 export was prepared because there is no
named Lean certificate for `DIAG-ROOT-001`.

## Typed Feedback

```text
leaf=DIAG-EXP-ARITH-BACKEND-001
parent_leaf=DIAG-EXP-ARITH-001
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
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
error_class=symbolic_bridge_gap
next_route=Instantiate a concrete ExpandedCubicArithmeticBackend, prove expandedArithmeticBackendComputesCubicAmplitude for it, and supply expandedArithmeticBackendBridge; otherwise keep the missing concrete workspace/backend representation as the blocker.
```
