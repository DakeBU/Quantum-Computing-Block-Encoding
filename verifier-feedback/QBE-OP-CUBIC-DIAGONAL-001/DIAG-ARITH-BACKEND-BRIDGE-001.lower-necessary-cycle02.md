# Verifier Feedback: DIAG-ARITH-BACKEND-BRIDGE-001 Lower Necessary Check

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Leaf: `DIAG-ARITH-BACKEND-BRIDGE-001`

Parent leaf: `DIAG-EXP-ARITH-001`

## Necessary Condition

The active leaf asks for
`expandedArithmeticBackendBridge
  (symbolicExpandedCubicArithmeticBackend n workspaceQubits)`,
or for a register-level backend replacement with the same pointwise compute
proof and bridge.  Before a Lean worker attacks that bridge, the finite payload
must still match the source diagonal operator:

```text
D_n[row,col] = if row = col then (row / 2^n)^3 else 0
```

The diagnostic is necessary because a bridge that computes a different payload,
changes the system index, or destroys diagonal support would prove the wrong
operator even if later opaque route predicates were closed.

## Diagnostic

I reran the existing scoped executable diagnostic:

```bash
python3 verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/diag_exp_arith_check.py \
  --json-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-ARITH-BACKEND-BRIDGE-001.lower-necessary-cycle02.raw.feedback.json
```

This checks exact rational instances for `n = 1, 2, 3, 4, 5`:

- `j^3 / 2^(3*n)` equals `(j / 2^n)^3`;
- the induced matrix is diagonal;
- off-diagonal entries vanish;
- all diagonal entries lie in `[0, 1]`, so `alpha = 1` is consistent;
- the compute model preserves the system index.

## Result

The finite/path/support check does not contradict the current diagonal target.
It also does not close the bridge leaf.  No concrete workspace representation,
capacity proof, reversible backend semantics, or
`expandedArithmeticBackendBridge` witness is present in this pass.

The rejection is against theorem closure only: proving
`expandedArithmeticComputesCubicAmplitude` from the symbolic pointwise compute
proof alone would still assert the opaque route predicate without a backend
semantics bridge.

No Qiskit, QuantumKatas-style, or QASM3 export was prepared because
`DIAG-ROOT-001` still lacks a named Lean certificate.

## Typed Feedback

```text
leaf=DIAG-ARITH-BACKEND-BRIDGE-001
parent_leaf=DIAG-EXP-ARITH-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
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
route_predicate_closed=false
error_class=symbolic_bridge_gap
next_route=Introduce a concrete workspace/backend representation and then supply expandedArithmeticBackendBridge for symbolicExpandedCubicArithmeticBackend, or replace it with a register-level backend carrying the same pointwise compute proof and bridge. Keep this leaf blocked otherwise.
```

Gate: `python3 tools/qbe.py check` passed.
