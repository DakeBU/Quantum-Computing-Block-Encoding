# Verifier Feedback: DIAG-EXP-ARITH-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Leaf: `DIAG-EXP-ARITH-001`

## Why This Leaf

The current proof-DAG frontier marks `DIAG-EXP-ARITH-001` as the active lower
leaf.  The already compiled `DIAG-RY-BRIDGE-001` theorem is only conditional on
a concrete backend witness of `expandedControlledRyBackendBridge`; that witness
is still open, so rebuilding the rotation bridge is stale for this pass.

This diagnostic is necessary for the arithmetic leaf because any honest backend
witness for `expandedArithmeticComputesCubicAmplitude n workspaceQubits` must
compute the same source value used by the diagonal target:

```text
a_j = (j / 2^n)^3 = CubicStatePreparation.cubicAmplitude n j.
```

If this finite arithmetic payload did not induce the target diagonal entries,
the Lean worker would be proving the wrong expanded route.

## Diagnostic

Executable diagnostic:

```bash
python3 verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/diag_exp_arith_check.py \
  --json-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-EXP-ARITH-001.lower-verifier-cycle01.feedback.json
```

The check uses exact rational arithmetic for `n = 1, 2, 3, 4, 5`.  It verifies:

- the arithmetic payload `j^3 / 2^(3*n)` equals `(j / 2^n)^3`;
- the induced matrix is diagonal with zero off-diagonal entries;
- every checked diagonal entry lies in `[0, 1]`, so `alpha = 1` remains valid;
- the modeled compute payload preserves the system index.

The diagnostic also records exact numerator bits needed by this payload shape:

| n | grid size | max numerator | numerator bits |
|---|---:|---:|---:|
| 1 | 2 | 1 | 1 |
| 2 | 4 | 27 | 5 |
| 3 | 8 | 343 | 9 |
| 4 | 16 | 3375 | 12 |
| 5 | 32 | 29791 | 15 |

This is not a lower-bound theorem for every possible arithmetic backend.  It is
a register-shape warning: the current Lean target has no concrete workspace
encoding or capacity witness, so the next Lean worker should introduce or
record such a backend obligation rather than prove the opaque predicate by
automation.

## Typed Feedback

```text
leaf=DIAG-EXP-ARITH-001
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=true
finite_arithmetic_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
closed_theorem_ok=false
workspace_representation_specified=false
workspace_capacity_checked=null
error_class=symbolic_bridge_gap
next_route=Introduce a concrete arithmetic backend witness for expandedArithmeticComputesCubicAmplitude with an explicit workspace representation/capacity, or keep it as an honest backend obligation; do not close the opaque predicate by trivial.
```

No Qiskit, QuantumKatas-style, or QASM3 export was prepared because no named
Lean certificate exists for `DIAG-ROOT-001`.
