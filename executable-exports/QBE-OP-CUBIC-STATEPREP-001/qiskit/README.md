# QBE-OP-CUBIC-STATEPREP-001 Qiskit Export

This directory contains a finite Qiskit baseline for the hard cubic benchmark:

```text
O_n = |v_n><0^n|,      (v_n)_j = (j / 2^n)^3.
```

It constructs a dense one-auxiliary-qubit unitary for a chosen small `n`, with
normalizer `alpha = ||v_n||_2`, and checks

```text
alpha * (<0| tensor I) U_n (|0> tensor I) = O_n.
```

Run the default finite instance:

```bash
python executable-exports/QBE-OP-CUBIC-STATEPREP-001/qiskit/export.py --n 3
```

This export is intentionally labeled as a fixed-instance dense baseline.  It
is useful for debugging and for comparing finite executable verifiers, but it
is not the final ABEIS goal.  The final goal is a symbolic approximate
block-encoding family whose proof and resource score close in Lean.
