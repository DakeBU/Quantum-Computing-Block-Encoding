# Hermite polynomial-resource search population

Contract: [`SP-HERMITE-POLY-002`](../tasks/SP-HERMITE-POLY-002.md).
Initial refresh: 2026-09-10. The exact-real quantum tier is now closed for
MPS-02; the full classical/compiler/export acceptance gate remains open.

## Certified baseline (not a resource-goal success)

| ID | Evidence | Resources | Role |
| --- | --- | --- | --- |
| BASE-EXP | `HermiteStatePreparation.hermiteStatePreparation_complete`; public parent commit `129bc2ad38c8` | RY `2^n-1`; CX `2*(2^n-1-n)`; ancilla/oracle `0` | Exact correctness and replay baseline; fails new polynomial-resource target |

## Insight pool

| ID | Origin | Distinguishing mechanism | Required discriminator | Current status |
| --- | --- | --- | --- | --- |
| MPS-01 | Cycle 1 independent proposal | Polynomial translation cores, geometric-product tails and threshold automata; sequential small-register isometries | Explicit cores and dimension bound; no dense-vector SVD; cleanup and primitive compilation | numerical implementation failed; exact algebraic leaves retained |
| MASS-01 | Cycle 1 independent proposal | Closed-form sums of squared amplitudes on prefix intervals; coherent compute/rotate/uncompute | Polynomial *coherent* cost, stable precision and no exponentially enumerated angle table | exploratory; unverified |
| MPS-02 | Mutation of MPS-01; MASS-01 supplies independent norm/target checks | One undecided threshold state injects positive Bernstein coefficients into shared subdivision states; bounded exponential tail factors | Repair recorded failures; full target/cleanup; charged compiler; classical/precision boundary | exact-real quantum-gate family proved; finite screening passes; full acceptance open |

An insight may inform a new proposal without being promoted into the certified
population. Its child retains the unverified obligations and may not inherit
the baseline's certificate. Record mutation/crossover lineage, exact changed
mechanism, failed predicates, reusable theorem names and an evidence digest.

## Selection discipline

Hard contract and evidence gates precede resources. Compare exact candidates
only at the same gate/input model, and approximate candidates only at the same
explicit tolerance. Keep a small set that covers genuinely different unresolved
interfaces or parameter regimes; mean performance is not sufficient.

Observed finite performance, predicted asymptotics, proved asymptotics and Lean
certification are different fields. Missing timing/token measurements remain
unknown. Do not reward file count, agent count or gratuitous lemma count.

## Initial falsified success claims

- BASE-EXP is not polynomial in `n`, regardless of its valid proof.
- Replacing the full amplitude tree with classically computed prefix masses
  does not improve quantum complexity if all prefix rotations are still emitted.
- A small numerical tensor rank computed from all `2^n` amplitudes does not
  establish polynomial classical preparation or exact rank.

## Generation updates

Append evidence-backed deltas here at bounded synchronization points. Preserve
failed mechanisms rather than silently rewriting earlier outcomes.

### Cycle 1: measured outcomes, 2026-09-10

- **MPS-01 / A3 failure.** Direct monomial translation and subtraction of
  masked polynomials are algebraically motivated but numerically unstable:
  target error `5.8e-6` at `(n,k,L)=(8,4,2)`, about `1.529` at `(8,8,10)`,
  and raw exponential overflow for `L=300`. These are implementation failures,
  not disproofs of the exact low-rank factorization. Retain `results.json`.
- **MASS-01 / M1 advance.** Fourteen interval-mass/degree/normalization
  statements compiled; independent checks used four examples, eight axiom
  queries, and seven Python tests. Non-enumerating mass queries supplied the
  normalizer and source values for MPS-02's independent verifier. No coherent
  mass/angle circuit is certified.
- **Master / R1a advance.** Exact Hermite affine cuts have factor width
  `8*k+12`; the actual little-endian sample API and normalization preserve
  that bound. `ABEISTests.HermiteStructure` compiled. Import shadowing and a
  reserved identifier caused an integration failure, repaired by a separate
  sample bridge and explicit matrix namespace; this was proof integration,
  not a new construction trial.
- **MPS-02 / A5 finite advance.** The changed mechanism eliminates the
  high-order cancellation in the tested cases. Saved RY/CX QASM replay used
  the independently implemented MASS source, not the MPS cores. At
  `(8,8,10)`: 764 RY, 764 CX, two ancillas, state error `2.54e-15`, garbage
  norm `2.78e-16`. At `(8,8,300)`: 90 RY, 90 CX, one ancilla, state error
  `4.34e-15`, garbage norm zero. These are measured floating-point results
  with tolerance `1e-9`, not exact acceptance or a uniform error theorem.
- **Large-width construction check.** At `(128,2,1)`, 25,240 core scalars
  produced a streamed 37,333,643-byte RY/CX QASM file with 741,936 gates of
  each type and four ancillas. There was no full statevector simulation.
  Independent norm relative error was `2.55e-15`; five amplitude spot checks
  do not establish all-amplitude correctness. Counts at `n=32/64/128` are
  observations, not a fitted complexity proof.
- **AUDIT-01 / K1 advance.** Exact target retrieval previously returned no
  Hermite names in its 80-row window; bounded explicit-anchor prioritization
  now returns the named root first. A reversible patch passes 95 Harness
  tests with one pre-existing platform skip. Natural-language-first versus
  Lean-first has no paired held-out comparison, so no winner is declared.

Raw evidence: `_out/hermite-poly-search/{mps,mass,audit}/` and the append-only
task trial log. MPS-02 is an insight-pool mutation, **not** a certified
population child. MASS-to-MPS transfer is validation-interface reuse; no
claim is made that MASS's coherent arithmetic route has been combined into
the MPS circuit.

### Resource-model boundary

For the proposed exact MPS construction let `D` be its maximum bond and
`S=2^ceil(log2 D)` the padded bond size. A stage acts on dimension `2*S`.
The numerical adjacent-plane compiler uses at most `2*S^2-S` planes per stage,
with `S` RY and (when controls exist) `S` CX per plane. This gives a proposed
`O(n*D^3)` primitive count and `ceil(log2 D)` clean-bond wires. The separate
Lean backend now proves the all-parameter core/compiler/cleanup chain and
the conservative full-instruction bound `48*n*(2*k+6)^3`. It is not `O(n*D^2)`.
The existing Lean uniformly-controlled compiler is an alternative with
`S` RY and `2*(S-1)` CX per plane; do not equate the two implementations.
Bit complexity, cutoff comparison, coefficient construction and precision
remain explicit obligations. Fixed float64 is not a universal epsilon model.

### Cycle 2: proof-bearing integration, 2026-09-10

- The middle Bernstein component now has a source-derived finite matrix
  realization with exactly `2*k+3` shared states. Every path matches the
  literal public sampled amplitude on the middle interval. Complete three-
  branch assembly remains a distinct frontier node; no numerical rank test
  substitutes for it.
- `TensorTrainCanonical` closes all-length exact canonicalization, source
  mass preservation, and maximal-bond nonincrease, including deficient and
  zero ranks. Its basis choices are classical existence, not a proved
  preprocessing algorithm.
- `RealIsometryCompletion` preserves prescribed active columns while
  correcting orientation on an unused column. The independent test includes
  a counterexample showing why that unused-column condition matters.
- `AdjacentGivens` supplies a constructed SO decomposition, including the
  terminal sign argument and exact `N*(N-1)/2` step count. It no longer
  assumes that a partially eliminated matrix becomes identity.
- `MatrixProductChain` builds actual chains from small kernels and two
  boundary vectors, with every contraction preserved and at most
  `2*n*max(D,1)^2` stored local entries. This storage bound does not certify
  the cost of computing each entry.
- `SequentialPrimitiveAssembly` closes the actual finite-list action of
  successive stages, and charges an actual initial bond-preparation circuit.
  Source/action adapters and final root acceptance remain explicit; these
  generic results do not promote MPS-02 to the certified population.
- The stable first integration passed both complete Lean gates. Subsequent
  local tests cover all-length contracts, non-prefix columns, negative
  orientation, empty ranks, zero-sized registers, and nontrivial wire
  placement. Only standard Lean axioms occur in audited roots. See the
  append-only trial log for each gate's exact scope.
- Harness context/prompt regression reached 98 tests with one platform skip.
  No paired timing/token experiment supports a universal NL-first or
  Lean-first winner. The observed useful crossover is mathematical:
  MASS normalization validates MPS, Bernstein fixes monomial conditioning,
  and canonical/Givens/placement proofs share checked local-column interfaces.

### Cycle 2: complete exact-real quantum tier and audit

- `HermitePolynomialPreparation.exists_polynomial_preparation` now supplies
  the literal normalized source, actual full primitive list, unitarity,
  every output bond sector, public LE order, zero oracle calls, and
  `48*n_p*(2*k+6)^3` total gates. Its resource corollary additionally bounds
  actual scheduled depth by the same quantity. Allocated clean bond wires
  number `ceil(log2(2*k+6))`. This supersedes the earlier *current-frontier*
  statements above; historical intermediate test/trial outcomes stay intact.
- `HermiteFiniteNorm` derives the source norm from raw local cores and proves
  equality to the full sample sum, with a `9*n_p*D^3` add/multiply schedule
  plus one square root. It is not a whole-classical-compiler cost theorem.
- Complete root integration passed both full Lean gates. Independent current
  executable revalidation passed 18 MPS and 7 MASS tests, both saved small
  QASM replays, and the large-width structural scan. Deliberately missing
  QASM produced errors, not inherited success.
- `MPS-02 / exact-real-quantum` is a proved scoped result. Full candidate
  acceptance remains open because deterministic classical factor/angle cost,
  finite-input/rounding bounds and Python-to-Lean backend refinement have not
  been certified. Do not attach these missing certificates to the mutation.
- Evidence and exact boundaries: `experiments/hermite-polynomial/FORMAL-RESULT.md`.

### Cycle 3: deterministic producer and bounded stored refinements

- `ConstructiveHermitePreparation.prepare_spec` certifies the actual named
  producer, with the same target, all-word clean output, zero oracles and
  `48*n_p*(2*k+6)^3` gate/depth bounds. All 162 production and test modules
  passed the full integration Lean gate, not only selected worker builds.
- Stored LQ, canonicalization and SO completion refine the actual deterministic
  factor/core/completion outputs. Stored Bernstein restriction has its own
  charged cubic bound. Their declared exact-real counters do not yet compose
  into an entire classical compiler or bit-complexity certificate.
- A rational-coefficient recursive-emitter trace has all-width Lean refinement;
  Python matches 129 exported cases exactly. Both saved eight-data-qubit
  recursive QASM examples pass independent replay. The L=10 recursive route
  uses more CX gates than the retained Walsh route, so it is not promoted as
  a resource winner. The 128-bit observation still belongs to Walsh.
- The strict audit found no target weakening or unearned full acceptance.
  The classical and uniform-precision nodes remain open. See
  `experiments/hermite-polynomial/CYCLE03-RESULT.md` for scope, review and reuse.
