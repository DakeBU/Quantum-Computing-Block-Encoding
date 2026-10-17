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

## Uniform scalar completeness and saved rounding

The finite negative-exponential supplier now has a sufficient active degree
`4*T^2+2*T+1`, where `T` is its precision-dependent tail cutoff. Its checked
enclosure succeeds for every rational `q <= 0` and positive scalar tolerance.
This removes the previous unproved degree-allocation edge; it is neither an
optimal allocation nor a finite-bit runtime theorem.

The literal signed outward-rounding supplier also encloses chronological RY
updates on one fixed row pair and bounds the midpoint taken only at the end.
Both internal providers have distinct scoped review. Changing physical row
pairs, CX-interleaved full stages, dimension-aware operator transport, source
normalization and total finite-bit costs remain open.

The complete stored Gram module has an accepted source-blind decoder and a
distinct source-first reviewer. Its charged exact-real stored-data model does
not certify input production, machine caching, peak RAM or physical gates.
[Evidence and remaining obligations](../experiments/hermite-polynomial/precision/cycle15-staging-result.json).
No new certified population winner, full scientific root or main admission is
claimed. The efficient branch uses Lean 4.33.0; main migration still requires
the remaining changed-module, integration and reader gates.


## 18 October 2026 integration and finite-bit frontier

The contribution checkpoint `67b750fcf30ac988df0a66d7af8f27e51a0fb74d`
uses Lean 4.33.0. Fetched main remains
`af585d9cbbb299c1c8c48647627a2cb820ef536a`, Lean 4.29.1. Fifty current
whole-module source-correspondence records validate; RobinMatrix remains a
separately identified experimental-policy/integration obligation. This is not
main admission, deployment, or completion of the frozen scientific target.
See the [actual current evidence](../reports/lean-433-migration/c142-independent-freezes-and-async-cost-frontier.json).

The next Hermite work is actual consumption of the independently reviewed C23
source-coefficient cache in C22, and an explicit data-width bound for the
precision-dependent source degree. Both are unproved successor work at this
snapshot. Keep the C23 scalar/word bound distinct from rational bitlength/GCD,
full preprocessing, normalized error composition, circuit synthesis and the
independent executable-family gate. No new resource winner is selected.


### Subsequent local parameter proof and current full gate

The C147 allocated Taylor-index root subsequently compiled under Lean4.33.0
(31.844s), with its exact own-output definition/type/axiom audit passing
(23.328s). All4 new roots report only the ordinary3 axioms. This is
proved_locally, not the complete finite-bit resource/root certificate.
[Exact scope and evidence](../experiments/hermite-polynomial/precision/allocated-degree-budget-c147/README.md).

The PR merge snapshot b95220ce6ebe9b6b7a965b4437f43b26fb673c03 also completed
full library/Tests and original Hermite executable replay successfully; its
selected proof/replay Git inputs equal contribution67b750f. This is a real
current PR integration gate, not main merge, clean TCB, new finite-bit poly-SP
executable acceptance or resolution of the experimental publication conflict.
[Source association](../reports/lean-433-migration/c153-current-PRmerge-full-gate-association.json).


### Independent scalar review and actual cached-supplier type probe

The C147 arithmetic provider now has a separately frozen C151 independent
source-first mathematical/binder/definition review and C154 subsequent actual
runtime association review. Both support their bounded internal claims, with
inherited/dirty/transitive provenance limitations retained; neither grants
source-publication, clean-TCB or scientific ROOT credit.

C150 actual cache -> signed middle -> five-branch right table -> existing
stored-chain definitions typechecked in C155: three modules plus seventeen
candidate propositions, all exit0. Type formation is not a proof. C156 seals
their exact bodies/signatures before subsequent bounded proof search. The
400/816 proposed bounds and final cached same-run refinement remain OPEN.
Subsequently C159 actually compiled seven C157 primitive/right roots, including
rightEntry partial counter<=11, and a fresh-own-output exact-type/axiom consumer
(25.578s/24.531s), all seven ordinary-three axioms. This is proved_locally with
independent static review pending, not full producer/runtime/root acceptance.
[Exact compiled primitives](../experiments/hermite-polynomial/precision/cached-primitives-c157/README.md).
Kernel/left and captured-block setup/native/bit/GCD costs remain unaccounted.
[Exact original stages](../reviews/publication/migration-checkpoints-c158/README.md).

The asynchronous policy retains human choice for material unapproved trade-offs,
autonomous bounded same-contract work, typed immutable evidence, matched
acceptance endpoints and all observed failed/cancelled/stale cost. No measured
quantum proof-first/screen-first/dual-lane efficiency winner or production
scheduler change is claimed. Original finite-bit Hermite ROOT remains OPEN.
