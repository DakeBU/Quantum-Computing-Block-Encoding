# Dense Verifier Scaling: QBE-OP-OPTCTRL-001 Family

This scaling check uses the same transfer-operator family
`E_k = |0><k|_time tensor |0><1|_type tensor I_state` with `k = 2^r - 1`.
It intentionally measures dense finite verifiers, not Lean symbolic proof
checking for a general theorem.

| Verifier | time qubits r | total qubits incl. ancilla | dense dimension | status | median ms |
| --- | ---: | ---: | ---: | --- | ---: |
| `dense_numpy_block` | 1 | 4 | 16 | passed | 0.026 |
| `qiskit_operator_dense` | 1 | 4 | 16 | passed | 0.426 |
| `dense_numpy_block` | 2 | 5 | 32 | passed | 0.080 |
| `qiskit_operator_dense` | 2 | 5 | 32 | passed | 2.178 |
| `dense_numpy_block` | 3 | 6 | 64 | passed | 0.072 |
| `qiskit_operator_dense` | 3 | 6 | 64 | passed | 6.509 |
| `dense_numpy_block` | 4 | 7 | 128 | passed | 0.141 |
| `qiskit_operator_dense` | 4 | 7 | 128 | passed | 38.673 |
| `dense_numpy_block` | 5 | 8 | 256 | passed | 0.297 |
| `qiskit_operator_dense` | 5 | 8 | 256 | passed | 230.344 |
| `dense_numpy_block` | 6 | 9 | 512 | passed | 0.633 |
| `qiskit_operator_dense` | 6 | 9 | 512 | passed | 1425.881 |

Interpretation:

- Dense NumPy and Qiskit `Operator` checks become expensive because they
  materialize matrices of dimension `2^(r+3)` for this one-state-register
  family.  This is the same exponential bottleneck that prevents ordinary
  simulation from validating large quantum circuits by brute force.
- ABEIS should use these checks for small finite instances, counterexamples,
  and fixed-instance executable checks.  The intended large-register route is a symbolic Lean
  theorem about registers and gate semantics, whose checking cost should
  scale with proof size rather than dense Hilbert-space dimension.
- The current concrete main case is already Lean-certified for `r = 1`.
  A parametric Lean theorem for all `r` is a future strengthening, so this
  scaling plot is a motivation for that direction, not a claim that it is
  already complete.

The scaling plot is generated at `docs/assets/verifier_scaling_comparison.png`.
