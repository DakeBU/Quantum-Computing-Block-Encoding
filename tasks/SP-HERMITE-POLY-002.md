# Structure-exploiting polynomial-resource Hermite state preparation

Task id: `SP-HERMITE-POLY-002`
Kind: `statePreparation`
Mode: `exploratoryConstruction`
Evaluation mode: `full-abeis`
Status: `exact-real polynomial quantum-gate root compiled; classical compiler cost and uniform finite-precision export remain open`
Parent baseline: `SP-HERMITE-001`, public commit `129bc2ad38c8e82d259459607ef0aae601af3212`.

## Frozen scientific and resource target

Preserve the exact function, normalization and little-endian output of
`QuantumBlockEncoding.HermiteStatePreparation`:

$$
p_j=-\pi L+2\pi L j/2^n,\qquad
|\psi_{k,n,L}\rangle=Z^{-1/2}\sum_{j=0}^{2^n-1}g_k(p_j)|j\rangle,
\quad Z=\sum_j g_k(p_j)^2.
$$

Here `k` is natural, the physical family has `n >= 1` and `L > 0`, and
`g_k` is `exp(p)` for `p < -1`, the source's degree-at-most `2*k+1`
Hermite polynomial on `[-1,0]`, and `exp(-p)` for `p > 0`. The amplitudes
are function values, not their square roots. `q0` remains the least
significant output bit even if an implementation processes bits in another order.

The new objective is an explicit, deterministic gate family whose gate count,
depth, clean ancillary space and classical construction work are polynomial
in `n`, with all dependence on `k`, `L` and precision separately exposed.
An `O(2^n)` algorithm is correctness evidence only, not a search success.
Prove the family and resource bound; fitting finite resource points is not
an asymptotic certificate. No claim of optimality is requested.

Primary tier: exact ideal real-angle circuit semantics, with zero final
ancilla garbage and no postselection or unresolved preparation/value oracle.
Separately account for how the real parameters are obtained. A polynomial
real-arithmetic count is not automatically polynomial bit complexity.

Approximate variants remain separate proposals until a tolerance rung is
explicitly recorded. Their target stays the same state; report Euclidean
state error at most `epsilon`, all rounding/truncation/normalization errors,
gate-synthesis error, and the input representation of `L`. A small finite
floating-point error never authorizes an exact or uniform-error claim.

## Highest certified frontier and rejection rules

The new exact-real quantum tier is now proved by
`QuantumBlockEncoding.HermitePolynomialPreparation.exists_polynomial_preparation`:
for `n >= 1`, all `k` and `L > 0`, an actual primitive circuit has at most
`48*n*(2*k+6)^3` instructions, `ceil(log2(2*k+6))` reusable clean bond wires,
zero oracle calls, and the literal normalized target in the public
little-endian order. Every nonzero output bond sector is proved zero.
This is not acceptance of the full classical/finite-precision task.
`ConstructiveHermitePreparation.prepare_spec` now certifies a named
deterministic producer of this same circuit contract. See the
[cycle-03 result and remaining costs](../experiments/hermite-polynomial/CYCLE03-RESULT.md);
the earlier existence-result snapshot is retained separately.

`HermiteFiniteNorm.localSampleNorm_eq_sampleNorm` additionally supplies the
normalizer by local Gram contraction; no full amplitude table is needed for
this supplier. Its stated add/multiply schedule is bounded by `9*n*(2*k+6)^3`,
plus one square root. Computing core entries, basis choices and real angles
still requires separate classical cost accounting.

The reference circuit has `2^n-1` RY gates and `2*(2^n-1-n)` CX gates,
zero ancillas and zero oracle calls. Its exact root is
`QuantumBlockEncoding.HermiteStatePreparation.hermiteStatePreparation_complete`.
It is retained unchanged. Its proof of correctness does not meet this task's
new resource objective.

Reject as a polynomial construction: a hidden full amplitude/angle table;
a dense `2^n`-dimensional SVD/unitary completion; an uncharged arbitrary
controlled rotation; exponential offline preprocessing; a free oracle;
unaccounted postselection/amplification; dirty discarded workspace; or
relabeling numerical rank as an exact rank theorem.

## Cycle 1 independent forks

1. `MPS-01`: explicit finite-state/low-rank representation of piecewise
   polynomial and exponential samples; sequential isometries; small-register
   primitive compilation. No dense-vector input to the construction algorithm.
2. `MASS-01`: closed-form prefix interval masses from polynomial power sums
   and geometric tails; coherent arithmetic, rotations and uncompute.
3. `AUDIT-01`: exact-signature library retrieval and independent accounting of
   hidden exponential work, evidence stages and integration obligations.

These are insight-pool proposals, not certified parents or accepted solutions.
Recombination requires a named shared interface and explicit source lineage.
Read the candidate ledger and proof frontier before launching a successor.

## Evidence gates

- Source/formula agreement and basis/register convention.
- Finite discriminators over multiple `n,k,L`, used only for screening.
- Named Lean state-action, unitarity, cleanup and resource roots, followed by
  `lake build && lake build Tests` and complete-module publication checks.
- Executable construction without dense fallback, with independently saved
  QASM replay and precise resource/precision accounting.
- Classical scaling probes beyond statevector-simulable `n`, separately from
  the finite statevector correctness set.
- Website promotion only after the documentation gate; do not replace the
  public baseline with an unproved efficient claim.

## Durable search memory

- Population: `candidate-populations/SP-HERMITE-POLY-002.md`.
- Frontier: `proof-obligations/SP-HERMITE-POLY-002.md`.
- Raw cycles, worker packets and metrics: task-scoped `runs/` records.
- Append substantive attempts through `tools/qbe.py trial-log`; do not edit
  historical trial rows or acceptance records.

No-progress policy: one unchanged failed route is classified; a second attempt
must change a concrete mechanism or test a new discriminator. Repeated
controller-only cycles cannot count as mathematical advances. The master
reallocates work to a distinct unresolved interface instead of enlarging the
same prompt or introducing another orchestration layer.
