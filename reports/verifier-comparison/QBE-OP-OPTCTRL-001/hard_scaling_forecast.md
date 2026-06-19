# Hard BE Dense-Unitary Forecast

This is not a runtime benchmark.  It is a memory forecast for the same
`E_k = |0><k|_time tensor |0><1|_type tensor I_state` block-encoding
family if a verifier insists on materializing the full dense complex
unitary matrix.  The candidate circuit itself is simple, but a dense
matrix verifier stores `dimension^2` complex entries.

| time qubits r | total qubits incl. ancilla | dense dimension | complex128 memory | interpretation |
| ---: | ---: | ---: | ---: | --- |
| 1 | 4 | 16 | 4.00 KiB | small finite smoke-check scale |
| 4 | 7 | 128 | 256.00 KiB | small finite smoke-check scale |
| 8 | 11 | 2,048 | 64.00 MiB | small finite smoke-check scale |
| 12 | 15 | 32,768 | 16.00 GiB | workstation-scale dense check |
| 16 | 19 | 524,288 | 4.00 TiB | large-memory dense check |
| 20 | 23 | 8,388,608 | 1.00 PiB | impractical for routine verifier feedback |
| 24 | 27 | 134,217,728 | 256.00 PiB | impractical for routine verifier feedback |
| 28 | 31 | 2,147,483,648 | 64.00 EiB | symbolic theorem route required in practice |
| 32 | 35 | 34,359,738,368 | 16.00 ZiB | symbolic theorem route required in practice |

Why this matters:

- Qiskit `Operator`, statevector, or NumPy dense-unitary checks are valuable
  and complete for fully instantiated small circuits.
- They are not a scalable replacement for proof when the intended theorem
  is a family over register size, because the dense verifier pays the
  Hilbert-space dimension directly.
- ABEIS therefore treats finite executable checks as counterexample and
  smoke-test layers, then asks Lean to certify the reusable block-encoding
  theorem and resource tuple.

The forecast plot is generated at
`docs/assets/verifier_hard_scaling_forecast.png`.
