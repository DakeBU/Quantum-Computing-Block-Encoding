# Hermite polynomial-resource construction experiment

Task: [`SP-HERMITE-POLY-002`](../../tasks/SP-HERMITE-POLY-002.md).
Status: **exact-real polynomial quantum-gate family proved; uniform executable certificate open**. This directory is
not connected to production acceptance. The reader-facing case page reports
the proved quantum-resource scope separately from the open classical and
finite-precision obligations. The correct exponential reference remains unchanged.

## What changed

MPS-01 discovered the target's small algebraic representation but failed
numerically. MPS-02 represents the polynomial only inside its active interval,
using positive Bernstein coefficients and shared subdivision states. Its
exponential factors never require evaluating a large positive exponent.
The change addresses recorded errors, not a guessed bottleneck.

Let `n` be the number of data qubits, `k` the smoothing order, and `D` the
largest tensor bond. The new construction proves `D <= 2*k+6`, independent
of `n` and `L`. Processing each bit updates only small matrices. A primitive
compiler acts on one data bit and a reused bond register of
`ceil(log2 D)` qubits. The compiled Lean root bounds every instruction by
`48*n*(2*k+6)^3`; this includes decomposing the small matrices into primitive
gates, full target action and complete bond cleanup.
This is a route for structured piecewise polynomial/exponential families,
not a polynomial preparation claim for arbitrary amplitude tables.

The tighter Bernstein representation, all-length canonicalization, local SO
compiler and complete quantum root now have compiled Lean proofs. These do
**not** certify the running time of the classical basis/angle choices or the
floating-point exporter. See the [formal result](FORMAL-RESULT.md) and
[live proof frontier](../../proof-obligations/SP-HERMITE-POLY-002.md).
The [cycle-03 result](CYCLE03-RESULT.md) adds the actual deterministic producer,
stored cost kernels and a checked recursive-emitter trace.

## Reproduce without changing historical evidence

Run from the repository root with its Python environment. Dependencies in the
recorded run: Python 3.12, NumPy 1.26.4, Qiskit 2.4.2. No provider/model calls
are needed for these deterministic tests.

```text
python -B -m unittest discover -s experiments/hermite-polynomial/mps -p "test_*.py" -v
python -B -m unittest discover -s experiments/hermite-polynomial/mass -p "test_*.py" -v
python -B experiments/hermite-polynomial/mps/probe_stable_candidate.py
python -B experiments/hermite-polynomial/mps/replay_mps_qasm.py _out/hermite-poly-search/reproduction/mps/mps02-n8-k8-L10.qasm --n 8 --k 8 --L 10
python -B experiments/hermite-polynomial/mps/replay_mps_qasm.py _out/hermite-poly-search/reproduction/mps/mps02-n8-k8-L300.qasm --n 8 --k 8 --L 300
python -B experiments/hermite-polynomial/mps/scan_qasm_primitives.py _out/hermite-poly-search/reproduction/mps/mps02-n128-k2-L1.qasm
lake build
lake build Tests
lake env lean experiments/hermite-polynomial/retrieval/Assets.lean
```

The probe writes to ignored `_out/` by default and accepts `--output-dir`.
It generates about 37 MB of large-width QASM; this is intentionally not
committed. The scan is a streaming syntax/count/hash check, **not state
acceptance**. The independent replay loads saved QASM and evaluates the source
with `mass/analytic_mass.py`, without importing MPS construction code. Dense
statevectors are restricted to at most 16 total qubits in that diagnostic.
Failing or missing QASM must raise an error, never inherit a stored success.

## Evidence and measured outcomes

The `evidence/cycle01-*.json` files preserve the original local observations;
do not overwrite them when rerunning. Timing and last-bit floating-point
results can vary across environments. They are not performance guarantees.

| Evidence | Outcome | What it does not establish |
| --- | --- | --- |
| `cycle01-mps01-failures.json` | target error about 1.529 at `n=8,k=8,L=10`; overflow for `L=300` | impossibility of the exact algebraic route |
| `cycle01-mps02-screening.json` | corrected small-target checks and non-enumerating 32/64/128-bit construction | all-parameter correctness or polynomial bit cost |
| `cycle01-replay-n8-k8-L10.json` | 764 RY + 764 CX, two ancillas; target error `2.54e-15` | uniform error outside this instance |
| `cycle01-replay-n8-k8-L300.json` | 90 RY + 90 CX, one ancilla; target error `4.34e-15` | exact symbolic root closure |
| `cycle01-independent-150-cases.json` | parent-side source check: no failures; maximum state error `1.44e-15` | independent synthesis benchmark/generalization |
| `cycle01-audit-before/after.json` | explicit target retrieval repaired | causal workflow speedup |

At `n=128,k=2,L=1`, the actual streamed circuit contains 741,936 RY and
741,936 CX gates with four ancillas. The constructor stores 25,240 core
scalars and never constructs the full target vector. Only the norm and five
selected amplitudes were compared independently, not the full output state.
Small instances can cost more than the reference: polynomial scaling does
not mean every finite point wins.

## Reliability boundaries

- The executable input type is positive rational `L`. The scientific Lean
  target still has arbitrary positive real `L`.
- The cutoff classifier uses rational enclosures of pi and fails if its
  bounded refinement cannot determine one integer cutoff. A uniform
  polynomial separation bound is not yet proved.
- Decimal coefficient preparation is followed by float64 cores/QR/angles.
  There is no uniform epsilon certificate. In particular, underflow can
  turn a mathematically nonzero path into a stored zero before pruning.
- Reduced QR uses shape, not a singular-value tolerance, to select active
  dimensions. The final active dimensions are at most two into one. Cleanup
  must be proved only on reachable input columns; padded unused columns
  are arbitrary unitary completion.
- The original numerical backend uses cyclic Gray/Walsh rotations and remains
  available. A separate recursive backend now has an all-width Lean symbolic
  trace refinement and a bounded exact-coefficient cross-language comparison.
  This does not prove whole Python compiler equivalence or uniform rounding;
  see [cycle-03 backend review](RECURSIVE-BACKEND-REVIEW.md).
- The archived cycle-1 JSON statuses remain screening/diagnostic statuses.
  The new exact-real root is a separate symbolic theorem, not retrospective
  certification of those files. No existing root theorem, executable
  acceptance anchor or production scoring rule was weakened.

## Attribution

The use of a reused finite-dimensional ancilla to generate an MPS follows
[Schön et al., sequential generation](https://arxiv.org/abs/quant-ph/0501096).
Gray-ordered decomposition follows the approach of
[Vartiainen, Möttönen and Salomaa](https://arxiv.org/abs/quant-ph/0312218), with
uniformly controlled rotations from
[Möttönen et al.](https://arxiv.org/abs/quant-ph/0404089).
[Iten et al.](https://arxiv.org/abs/1501.06911) provide general isometry
decomposition context; their optimized bounds are not claimed for this
conservative real-only implementation. The source Hermite target and its
citations remain defined by the existing Lean library.
