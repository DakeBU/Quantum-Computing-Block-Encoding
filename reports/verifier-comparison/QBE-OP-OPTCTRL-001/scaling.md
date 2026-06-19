# Dense Verifier Scaling: QBE-OP-OPTCTRL-001 Family

This scaling check uses the same transfer-operator family
`E_k = |0><k|_time tensor |0><1|_type tensor I_state` with `k = 2^r - 1`.
It intentionally measures dense finite verifiers, not Lean symbolic proof
checking for a general theorem.

| Verifier | time qubits r | total qubits incl. ancilla | dense dimension | status | median ms |
| --- | ---: | ---: | ---: | --- | ---: |
| `dense_numpy_block` | 1 | 4 | 16 | passed | 0.020 |
| `qiskit_operator_dense` | 1 | 4 | 16 | passed | 0.408 |
| `dense_numpy_block` | 2 | 5 | 32 | passed | 0.038 |
| `qiskit_operator_dense` | 2 | 5 | 32 | passed | 2.096 |
| `dense_numpy_block` | 3 | 6 | 64 | passed | 0.068 |
| `qiskit_operator_dense` | 3 | 6 | 64 | passed | 6.033 |
| `dense_numpy_block` | 4 | 7 | 128 | passed | 0.139 |
| `qiskit_operator_dense` | 4 | 7 | 128 | passed | 39.071 |
| `dense_numpy_block` | 5 | 8 | 256 | passed | 0.288 |
| `qiskit_operator_dense` | 5 | 8 | 256 | passed | 196.544 |
| `dense_numpy_block` | 6 | 9 | 512 | passed | 0.637 |
| `qiskit_operator_dense` | 6 | 9 | 512 | passed | 1214.416 |
| `dense_numpy_block` | 7 | 10 | 1024 | passed | 1.453 |
| `qiskit_operator_dense` | 7 | 10 | 1024 | passed | 8219.175 |

Interpretation:

- Dense NumPy and Qiskit `Operator` checks become expensive because they
  materialize matrices of dimension `2^(r+3)` for this one-state-register
  family.  This is the same exponential bottleneck that prevents ordinary
  simulation from validating large quantum circuits by brute force.
- ABEIS should use these checks for small finite instances, counterexamples,
  and smoke tests.  The intended large-register route is a symbolic Lean
  theorem about registers and gate semantics, whose checking cost should
  scale with proof size rather than dense Hilbert-space dimension.
- The current concrete main case is already Lean-certified for `r = 1`.
  A parametric Lean theorem for all `r` is a future strengthening, so this
  scaling plot is a motivation for that direction, not a claim that it is
  already complete.

The scaling plot is generated at `docs/assets/verifier_scaling_comparison.png`.
