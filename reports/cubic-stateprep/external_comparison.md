# Cubic Benchmark External Verifier Comparison

Task: `QBE-OP-CUBIC-STATEPREP-001`.

This is a real local run on the cubic state-preparation target.  A pass here
means the finite executable verifier accepted a concrete small-`n` artifact.
It does **not** mean the symbolic Lean family theorem is complete.

| System | n | Same BE task? | Status | Construct ms | Verify ms | Dense memory | Block error | Unitarity error | Symbolic family? | Interpretation |
|---|---:|---|---|---:|---:|---:|---:|---:|---|---|
| NumPy dense completion | 1 | True | passed | 0.099 | 0.000 | 256 B | 0.000e+00 | 0.000e+00 | False | Valid finite executable check for this n; resource and memory grow exponentially, so it is not the scalable ABEIS target. |
| Qiskit Operator | 1 | True | passed | 0.099 | 0.414 | 256 B | 0.000e+00 | 0.000e+00 | False | Executable finite BE evidence.  Useful after ABEIS proposes a concrete candidate, but not a proof for all n. |
| NumPy dense completion | 2 | True | passed | 0.127 | 0.000 | 1 KiB | 6.216e-17 | 2.449e-16 | False | Valid finite executable check for this n; resource and memory grow exponentially, so it is not the scalable ABEIS target. |
| Qiskit Operator | 2 | True | passed | 0.127 | 0.400 | 1 KiB | 6.216e-17 | 2.449e-16 | False | Executable finite BE evidence.  Useful after ABEIS proposes a concrete candidate, but not a proof for all n. |
| NumPy dense completion | 3 | True | passed | 0.341 | 0.000 | 4 KiB | 2.776e-17 | 3.331e-16 | False | Valid finite executable check for this n; resource and memory grow exponentially, so it is not the scalable ABEIS target. |
| Qiskit Operator | 3 | True | passed | 0.341 | 0.443 | 4 KiB | 2.776e-17 | 3.331e-16 | False | Executable finite BE evidence.  Useful after ABEIS proposes a concrete candidate, but not a proof for all n. |
| NumPy dense completion | 4 | True | passed | 1.135 | 0.000 | 16 KiB | 0.000e+00 | 2.636e-16 | False | Valid finite executable check for this n; resource and memory grow exponentially, so it is not the scalable ABEIS target. |
| Qiskit Operator | 4 | True | passed | 1.135 | 0.633 | 16 KiB | 0.000e+00 | 2.636e-16 | False | Executable finite BE evidence.  Useful after ABEIS proposes a concrete candidate, but not a proof for all n. |
| NumPy dense completion | 5 | True | passed | 4.239 | 0.000 | 64 KiB | 0.000e+00 | 4.441e-16 | False | Valid finite executable check for this n; resource and memory grow exponentially, so it is not the scalable ABEIS target. |
| NumPy dense completion | 6 | True | passed | 16.916 | 0.000 | 256 KiB | 1.784e-16 | 8.240e-16 | False | Valid finite executable check for this n; resource and memory grow exponentially, so it is not the scalable ABEIS target. |
| Qiskit-QuantumKatas evaluator | 3 | True | passed |  | 10.962 | 4 KiB | 0.000e+00 | 0.000e+00 | False | The kata harness can check a finite dense construction, but it does not produce the symbolic block-encoding theorem that ABEIS targets. |
| QASM-Eval |  | False | generic-runnable-not-direct |  |  |  |  |  | False | Useful design analogue for typed verifier feedback; this local route does not directly certify the cubic BE semantics. |
| QUASAR |  | False | not-runnable |  |  |  |  |  | False | Harness idea comparison only; no local same-task verifier route is available. |
| AI-Mandel |  | False | compile-check-passed |  |  |  |  |  | False | Relevant to ABEIS natural-language architect/tool-feedback staging, not a direct competitor verifier. |

Takeaway:

- Qiskit-style finite checks are useful after a candidate exists, and they
  are close to necessary/sufficient for the **fixed dense matrix** being
  checked.
- They materialize a dense `2N x 2N` unitary in this baseline, so memory
  grows exponentially in the number of system qubits.
- ABEIS therefore treats this route as finite executable evidence and keeps
  the final acceptance criterion as a Lean theorem for a symbolic family.
