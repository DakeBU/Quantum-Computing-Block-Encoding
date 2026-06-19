# Cubic State-Preparation Benchmark

Task: `QBE-OP-CUBIC-STATEPREP-001`

This benchmark is intentionally harder than the current transfer-operator main
case.  The target vector is dense and non-normalized:

```text
v_j = (j / 2^n)^3.
```

ABEIS treats the requested object as the rank-one operator `|v><0^n|` and then
searches for a block encoding.  Exact finite synthesis is expected to stall;
the intended route is Scenario 2 approximate construction with
`epsilon = 1e-10`.

## What We Can Already Check

- The Lean target surface compiles.
- Small exact rational norm diagnostics compile for `n = 1` and `n = 2`.
- The task memory explicitly rejects the common mistake of treating the
  unnormalized vector as a unitary output state.
- External executable baselines have now been run on the same cubic target:
  see `external_comparison.md` and `external_comparison_scaling.png`.
  They pass finite dense checks for small `n`, but they do not provide a
  symbolic family certificate.

## Fair Comparison Protocol

The comparison against Qiskit, QASM-Eval, QuantumKatas-style tests, and other
public circuit-generation systems should be run in two layers.

1. **Code-writing/verifier layer.**  Give each system the same operator target,
   error tolerance, and resource metric.  Measure agent tokens, wall-clock
   time, whether a candidate is produced, and whether its own verifier passes.
2. **Scalability layer.**  For dense statevector/unitary verification, record
   memory and time growth with `n`.  For ABEIS, record whether the candidate is
   a symbolic family and whether Lean proves the family theorem.

Do not claim that another repository fails until its route has actually been
run under this protocol.

## Current External Run

The current local run found:

- NumPy dense completion passed for `n = 1..6`.
- Qiskit `Operator` passed for `n = 1..4`.
- Qiskit-QuantumKatas-style evaluator passed for `n = 3`.
- QASM-Eval now runs in the local environment after installing its OpenQASM
  parser dependency, but its released route is a typed QASM
  syntax/distribution/timeline verifier, not a direct clean-block verifier for
  this dense cubic rank-one BE target.
- QUASAR and AI-Mandel do not expose a direct same-task block-encoding verifier
  route in the local artifacts.

This is a fair finite baseline, not the final ABEIS goal.  ABEIS still needs a
symbolic approximate construction and a Lean theorem for arbitrary `n`.

## Expected Scaling Signal

Dense vector/state-preparation baselines have at least `O(2^n)` data movement
because the vector has `2^n` entries.  Dense unitary verification is worse.  A
successful ABEIS route should instead use arithmetic structure in `j/2^n` and
target a circuit family whose description is polynomial in `n` and
`log(1/epsilon)`.
