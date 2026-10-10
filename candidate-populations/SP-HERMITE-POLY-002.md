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

### Cycle 6: bounded staging, 2026-10-08

- **MPS-02 normalized compiler crossover.** The actual raw supplier is composed
  with the existing stored norm/canonicalization and `closeLeft` boundary
  mechanism. `StagedNormalizedCanonical.compile_certified` proves one returned
  normalized right-canonical chain and its ordinary polynomial cost. This is a
  compiler-interface advance, not a new complete scientific candidate or
  inherited executable certificate. Independent source/publication admission
  remains pending.
- **MPS-02-SCALE-01 numerical mutation.** Parent: MPS-02. Changed mechanism:
  positive scaling before QR residual absorption and afterward, with an explicit
  binary mantissa/exponent normalizer. The old backend still fails its recorded
  `(1025,0,1/100)` discriminator; the isolated candidate passes that bracket and
  additional cache-only checks. Small literal source-action tests, signed and
  deficient cases are retained. No gate-resource improvement, uniform precision
  bound, large-state action certificate or certified-population promotion is
  claimed.
- **Stored emitter adapter.** Explicit non-target wire enumeration and cached
  bit reads now feed the proved selected-RY trace with a checked cost bound.
  This is not yet the complete stored Gray/SO emitter or a globally optimal
  resource champion.

The [cycle-06 packet](../experiments/hermite-polynomial/stored/cycle06-staging-result.json)
binds source hashes, checks and remaining interfaces. Unknown token/model-call
telemetry remains unknown; this cycle provides no workflow-efficiency claim.

### Cycle 7 complementary interface refinements

- The explicit Gray target/word supplier refines the same physical target and
  bit assignment used by the prior exact-real compiler. This is a stored
  emitter prerequisite with local polynomial index/storage work, not a new
  quantum route or a certified resource winner.
- Actual stored active columns, counted prefix labels and completion now
  consume the returned normalized chain. This extends the compiler crossover
  through the exact local SO matrix, without inheriting a full primitive-list
  or finite-bit certificate. Global integration must cache the source once.
- `MPS-02-SCALE-01` now has a local exact mathematical mechanism certificate:
  positive per-core and residual scaling preserve the literal signed normalized
  Hermite action. The numerical implementation still has no uniform backward
  error, underflow, Python refinement or serialized-circuit certificate.
  Supplied-factor correctness is not transferred to computed floating factors.
- The companion diagonal textbook slice supplies an actual source circuit's
  accepted branch and normalization, not a Hermite construction candidate.
  Its finite success proof and source-phase discriminator are reusable ideas,
  not an improvement of this population's gates or root acceptance.

The canonical [frontier](../proof-obligations/SP-HERMITE-POLY-002.md) retains
C2/C3/X2/ROOT as open. The exponential baseline and all previous failures remain
visible. These refinements do not count as independently admitted candidates
or establish a workflow-speed comparison.

### Cycle 8 same-run primitive compiler crossover

The normalized-chain/active-column supplier now connects through a materialized
Gray-table mutation to the actual stored SO emitter. The composed return is
proved equal to the same named local stage matrix and its exact padded-core
column action, with charged indexing, copying, sweep/log reversal and angle
instantiation. This is an actual interface crossover, not concatenated route
descriptions or inherited executable evidence. The local final gate count and
intermediate emission counters are separately proved.

Evidence: [stage primitive packet](../experiments/hermite-polynomial/stored/stage-primitive-result.json),
[Gray-table packet](../experiments/hermite-polynomial/stored/gray-table-result.json),
[SO emission packet](../experiments/hermite-polynomial/stored/local-so-emission-result.json).
The cached all-stage compiler/global placement and finite-bit/error/export
contracts remain open, as do independent scientific/source/reader admission.
No new full certified candidate, resource winner or harness-efficiency result
is claimed. Exponential baseline, MPS-01 failures and float64 falsifier stay intact.

### Cycle 9 source-once global composition and numerical counterexample

The same-run compiler crossover now includes the entire actual returned
primitive list: source generation once, all stages, global wire placement,
padding, copying and the public LE adapter. Its full operator refinement and
literal clean Hermite column are proved separately. Final gate bound remains
`48*n_p*(2*k+6)^3`; this is stronger implementation/cost coverage, **not a new
resource winner**. A subtraction-free polynomial envelope accounts for the
declared exact-real/index-word source and consumer work.

The precision mutation supplies an exact norm floor and error propagation
bridge, not computed floating-point error bounds. Its dyadic underflow
discriminator rejects unconditional reliability of the generic max-core
strategy on all nonzero finite TT inputs. It has not been proved reachable
from this Hermite source, so neither the exact Hermite invariant nor the
entire polynomial route is rejected. Preserve the failed strategy witness
and investigate source-reachable dynamic range or a different representation.

Evidence: [cycle09 packet](../experiments/hermite-polynomial/stored/cycle09-staging-result.json).
No new root/executable-certified population selection, optimization gain,
novelty or worker-efficiency claim. Exponential baseline and all failures
remain retained; source review and finite-bit/export boundaries remain open.

### Cycle 10 precision mutation and exact-error crossover

The cached full-return compiler now crosses with shared primitive RY/circuit
perturbation assets through an **actual** positional dyadic-rounding producer.
Constructor closure excludes arbitrary unrounded RZ/X instructions from this
Hermite return. The same rounded list has a full signed/all-garbage error
certificate and logarithmic fractional-precision allocation; its quantum
gate bound is unchanged. This is a locally compiled mathematical mutation,
not a new finite-bit/resource winner: determining its exact-floor numerators,
preprocessing and implementing finite gate synthesis are unpriced/unrefined.

The source-numeric direction found a source-reachable implementation failure,
not merely the earlier generic-TT max-scaling counterexample. Tiny positive
`L=1/10^100` invalidates the frozen supplier's unrestricted totality. A separate
large-`L` tail-underflow instance is benign at a rigorously derived finite
tolerance. Neither result discards the exact mathematical route. Keep both
scoped observations, the exponential baseline and previous failures.

The transport direction adds an independent exact representation diagnostic,
and separate replay of two actual saved small circuits. It does not transfer
finite floating-producer evidence to the Lean exact compiler or whole family.
Independent review found a schema-type acceptance bug; v1 was retained as
requiring repair and a sealed v2 adds fail-closed type checks and regressions.
This is an audited bounded diagnostic improvement, not a Harness rewrite.

Evidence: [dyadic supplier](../experiments/hermite-polynomial/precision/dyadic-supplier/result.json),
[source-reachable audit](../experiments/hermite-polynomial/precision/source-reachable/independent-audit.json),
[transport v2 contract](../experiments/hermite-polynomial/precision/transport/contract-v2.json).
No scientific population promotion or workflow-efficiency measurement is
claimed. Genuine Gray-module local review is a separate migration asset,
not a new quantum candidate. Next crossover requires certified computable
source/angle enclosures and an actual saved-parser semantic bridge.

### Cycle 11 safe-interval crossover and source-coordinate mutation

The finite rational nearest-dyadic consumer crosses the frozen cached compiler,
primitive perturbation and full signed target interfaces. Its actual returned
list preserves constructor order, ordered wire arguments and non-RY instructions;
valid finite data produce a return without deciding an exact-real floor bin.
Conditional soundness is still an internal upstream obligation. Same-list resource
equality and input-dependent output bit bounds do not certify that upstream
generator, preprocessing runtime or physical synthesis.

The independent source-numeric mutation changes the failed affine-near-one
coordinate mechanism to rational reflected offsets. The actual old tiny-L
failure remains reproducible, while the successor reaches normalized TT and
full RY/CX simulation against an independent source reference. Local coefficient
budgets are lossless rationals, with bounded near-cutoff refinement and honest
retry/tolerance failure. The numerical source still uses uncertified exponential,
subdivision, QR and normalizer operations; its local budgets do not imply global
epsilon. Generic signed-library tests are labelled separately from the unchanged
Hermite target.

These two mutations are not yet one source-to-angle certified executable.
Neither enters the root-certified/resource-winner selection lane. Gate bounds
are inherited, not a newly measured optimization improvement. Keep all previous
failures and the exponential baseline. Current lineage and scoped checks:
[finite-data angle supplier](../experiments/hermite-polynomial/precision/safe-enclosure/result.json),
[offset source successor](../experiments/hermite-polynomial/precision/offset-source/result.json).

### Cycle 12 rational input crossover and a posteriori QR certificates

The precision mutation now computes its actual dyadic width from rational
`epsilon` and feeds that value to the existing finite-data angle consumer.
The coefficient direction separately closes coarse all-`k` literal value and
input-dependent rational output envelopes. Neither mutation supplies the
missing analytic enclosure generator, arbitrary-precision numerical backend
or total preprocessing bit cost.

The QR mutation certifies the **actual returned** train against the normalized
stored raw train by exact cross-Gram contractions and literal scale drift.
It is independent of an exact-QR assumption and avoids dense construction.
Its `27*n*B^3` field-operation envelope is certificate-only; QR, integer/GCD,
source conversion and circuit work remain separate. The numerical checker may
return a large honest bound and does not promise success for every `epsilon`.
This is a reusable internal error interface, not a root-certified candidate
or a newly selected resource winner.

An optional uniform entry validator fixes the preserved zero-injection local
budget bypass without changing valid numerical returns. A legal rational
near-cutoff witness defeats the existing fixed 512-term cap and remains a
recorded implementation failure. It motivates a source-linked approximate
radius route, not target substitution or a Hermite impossibility claim.
The exponential baseline, earlier failures, immutable sources and distinct
scoped review disclosures remain intact. Scientific C2/C3/X2/ROOT stay open.

Evidence: [coefficient audit](../experiments/hermite-polynomial/precision/coefficient-range/independent-audit.json),
[budget audit](../experiments/hermite-polynomial/precision/rational-budget/independent-audit.json),
[QR audit](../experiments/hermite-polynomial/precision/qr-residual/independent-audit.json),
[entry and failure audit](../experiments/hermite-polynomial/precision/offset-entry-v2/independent-audit.json).

The additional radius crossover consumes the actual coefficient range,
Bernstein expansion, exponential tails, endpoint jets and normalization
floor. It proves all-`k` original-source stability under rational radius
approximation, with full Euclidean dimension dependence and the original
`pi*L` target retained. Root freshly compiled the 16 providers and six kernel
instances. This supports a different precision strategy, not an implemented
radius generator or unconditional finite-bit candidate.
Evidence: [radius packet](../experiments/hermite-polynomial/precision/radius-stability/result.json).

Distinct scoped review reproduced all 16 roots, six consumers and seven
additional formal discriminators without finding source, metric or target
drift. It does not promote the radius route into certified selection.
[Audit](../experiments/hermite-polynomial/precision/radius-stability/independent-audit.json),
[cycle12 aggregate](../experiments/hermite-polynomial/precision/cycle12-staging-result.json).

The next saved-action proposal explicitly includes repeated compiler QR,
local completion, angle interpretation and every terminal bond sector.
It compares a rational stage surrogate with the literal returned TT, keeping
nonunitary-surrogate amplification and source errors separate. It is
`DESIGN_ONLY`, not a performed experiment, successful crossover or resource
selection. [Design](../experiments/hermite-polynomial/precision/next-circuit-frontier-design.json).

### Cycle 13 finite supplier crossover and saved diagnostic

The radius candidate now has an actual kernel-checked finite rational Machin
producer with logarithmic term allocation. It consumes the previous original
source stability interface without changing the target. The exact normalized
error still carries `2*sqrt(2^n_p)*C(k)`; a radius tolerance is not silently
treated as global state epsilon. Total stored bit/GCD/runtime and downstream
precision composition remain open.

An independent direction supplies all-rational finite Taylor sin/cos
enclosures and a bounded executable degree search. The actual saved-action
diagnostic crosschecks its 26 half-angles against these formulas, with outward
rounding kept in the interval budget. Neither formula reuse nor finite tests
certify the Python/Lean decoder and stage-action bridge.

The same OffsetSource/QR return and single compiler plan now have a compact
full-garbage saved-action candidate for `n_p=3,k=1,L=1`: 456 saved gates,
four terminal bond labels and no renormalized target replacement. Its bound
to literal stored D is approximately `1.18153e-13`. The separate Qiskit
diagnostic and 15 regressions are finite supporting evidence, not a new
certified family or selected resource winner.

Kernel product transport separately retains possible surrogate amplification
as `product(1+eta_i)-1`; nominal stage contraction and actual local operator
error must still be proved by the concrete stage producer. These new nodes
advance internal analytic and executable frontiers, not C2/C3/X2/ROOT. The
exponential baseline, prior failed implementations, candidate lineage and
immutable seals remain retained. Distinct review was pending when the local
packages were checkpointed and pushed to the contribution branch.

Evidence: [radius](../experiments/hermite-polynomial/precision/radius-supplier/result.json),
[finite trig](../experiments/hermite-polynomial/precision/finite-trig/result.json),
[saved action](../experiments/hermite-polynomial/precision/saved-action/result-v1.json),
[nonunitary transport](../experiments/hermite-polynomial/precision/nonunitary-transport/result.json).

The later distinct scoped reviews accept the internal provider mathematics
and narrow exact-decimal saved residual, not a resource winner. Independent
terminal-excitation and order/sign/angle mutants discriminate full-garbage
error. Some additional Qiskit binary64 errors exceed tiny exact-decimal
candidate bounds: parser/simulator rounding, physical synthesis and ideal
source error remain separate charged edges. Local matrix-cell counts do not
establish total Python peak RAM or GCD/runtime costs.

### Cycle 14 actual global radius reserve and clipped scalar supplier

The radius crossover now selects its actual positive rational Machin radius
from global epsilon, physical dimension and the frozen all-k source constant.
The unchanged normalized signed target has a proved radius contribution at
most `epsilon/4`. Other stage errors are not zeroed. This is precision-budget
progress, not a new circuit resource tuple or certified population winner.
[Allocation](../experiments/hermite-polynomial/precision/global-radius-budget/result.json).

The independent scalar direction supplies finite rational enclosures for
negative-argument exponentials. A sound `[0,2^-T]` tail branch avoids huge
Taylor powers, while the active branch retains a checked width and may fail.
Original rational-coordinate source tails and `exp(-1)` have actual consumers;
source grid/storage refinement and uniform degree/bit/runtime bounds remain
open. Scalar-width epsilon does not replace global normalized-state error.
[Supplier](../experiments/hermite-polynomial/precision/finite-exp/result.json).

Both packages were checkpointed to the contribution branch as locally proved,
pending distinct review. They advance independent metric-allocation and
finite-scalar uncertainties; no source Anchor, public graph, main merge,
deployment or complete family acceptance follows from the checkpoint.

The RY direction closes a different uncertainty: the literal signed rational
half-angle Taylor midpoint has a derived Euclidean operator error at most
twice its scalar radius, even after lifting to an arbitrary named physical
wire. Existing exact CX semantics are reused, not counted as new mathematics.
This enables later nonunitary transport but does not identify the saved
outward-rounded stage with a product of these primitive centers. Full stage,
readout/garbage and parser refinement remain open. A privacy-safe versioned
packet replaces unpublished metadata; the original remains quarantined, not
retroactively accepted.
[RY packet](../experiments/hermite-polynomial/precision/saved-ry-interval/result-v2.json).

Distinct scoped review now accepts all three providers with complete fresh
source/consumer compilation and independent discriminators. Parent repeated
the reviewer probes and exact blind-spot tests. This resolves local review
uncertainty, not scientific population selection: four non-radius stages,
complete saved-word/rounding/garbage refinement and total finite-bit resources
remain open. The separate sufficient-degree proposal is unproved design only.
[Cycle 14 aggregate](../experiments/hermite-polynomial/precision/cycle14-staging-result.json).

### Sufficient degree and actual outward-rounded row semantics

The scalar mutation now proves a sufficient precision-dependent Taylor
degree, rather than searching under a fixed cap. It consumes the existing
sound checker and preserves enclosed clipped-tail mass. The rounded-row
mutation proves the actual signed floor/ceil and interval update rules,
including end-only midpoint extraction, on a fixed row pair. Both are
independently reviewed internal providers, not scientific population parents.

The proposed crossover combines these suppliers with the proved radius
allocation to build a finite rational source, then a stored tensor train.
It remains design only until coefficient refinement, global error, actual
stored cores and all charged costs are proved. The original exact-real bond
and gate bound cannot be silently reused for a precision-dependent polynomial.
[Next source-stage design](../experiments/hermite-polynomial/precision/next-source-stage-design-c15.json).

Variable-target RY/CX full stages and operator-error transport are a separate
construction uncertainty. Fixed-pair interval closure and finite 4x4 tests do
not supply it. No new resource tuple or winner replaces the retained baseline.
[Reviewed evidence](../experiments/hermite-polynomial/precision/cycle15-staging-result.json).

### Reviewed rational middle and full-stage semantic mutations

The finite-middle mutation now supplies literal rational coefficients,
the actual complete exponential midpoint, exact central value 1 and the
all-k scalar error amplification. The full-stage mutation supplies arbitrary
physical changing-target RY/CX enclosure and a real Euclidean eta from the
completed outward-rounded matrix. Both have distinct accepted internal
reviews; retained implementation failures are not relabelled green.

These are dependency-ready proof assets, not new scientific population
winners. No improved complete resource tuple or executable family acceptance
is asserted. The source-to-stored-TT/global-normalization fork and the
nominal-contraction/actual-product-transport fork are separate uncertainties.
No source norm, contraction, free oracle or projected garbage is assumed.
Dense materialization remains exponential when width grows with n_p; the
symbolic full-matrix bound is not a scalable implementation certificate.
The original baseline and failure records remain available.
[Cycle 16 aggregate](../experiments/hermite-polynomial/precision/cycle16-staging-result.json).

### Cycle 17 source/stage crossover, locally proved and under review

The source crossover now composes actual clipped tails, the rational middle,
the produced rational-radius grid and dimension-aware normalization. Its
locally compiled original-target error is at most `epsilon/2` for positive
rational L,epsilon, all k and `n_p>=1`; the source and radius contributions
are each at most `epsilon/4`. No norm-floor or approximation oracle is an
input premise. The whole original grid and clipped mass remain in the target.

Independently, the stage mutation removes the contraction/`Valid` assumptions:
literal signed real RY/CX words preserve the full Euclidean norm, actual
outward-stage centers and eta supply `Valid`, and chronological products match
the literal flattened word. Parent actual consumer checks and nine diagnostic
tests pass. Distinct full-source review is still running; these assets are not
scientific population winners or public purified results.
[Checkpoint](../experiments/hermite-polynomial/precision/cycle17-author-checkpoint.json).

The next source mutation must build actual nondense cores for precision-degree
tails and all +/-T/-1/0 masks. A masked-polynomial comparator route and a
multi-boundary injection alternative remain explicit OR-routes; neither may
inherit the old `2k+6` exponential-source bond or treat comparator generation
as a free oracle. Proposed dimensions are design only. The separate real-to-
complex primitive adapter preserves canonical q0-LSB, signs, chronology and
all spectators rather than replacing the circuit semantics.
[Next source design](../experiments/hermite-polynomial/precision/piecewise-tt-next-design-c17.json).

No new complete resource tuple, certified winner, family export acceptance or
main deployment is asserted. The exponential baseline, exact-real route and
failed attempts remain preserved, with full finite-bit costs independently open.

### Cycle 18 admission checkpoint: reviewed source/stage, literal complex bridge staged

The distinct internal source/stage review now accepts the original normalized
target `epsilon/2` source budget and the literal real nominal/product transport.
Its own fresh selected-source replays cover seventeen source modules and nine
stage modules, with 162 printed roots using only the ordinary three axioms.
The reviewer retains dependency-review lineage and saw author scope statements:
this is not a source-blind public decoder or whole scientific-family approval.
Earlier failed and pending records remain frozen, not relabelled green.
[Independent scoped review](../experiments/hermite-polynomial/precision/source-stage-review-c17/independent-audit.json).

The next semantic crossover is locally proved: the whole real RY/CX word,
including nonidentity matrix inputs, agrees exactly with the existing complex
primitive evaluator under the canonical `primitiveBasisLEEquiv`. Signed
half-angles, q0-LSB, chronological multiplication, spectators and width zero
are retained; no phase quotient or garbage projection is used. The adapter's
fresh nine-module author gate and five diagnostics pass. Distinct review is
still active, so it remains `proved_locally`, not a certified population parent.
[Staged adapter](../experiments/hermite-polynomial/precision/literal-complex-adapter/result-v1.json).

Parent consumer replays and immutable source/cache bindings are recorded in
[the focused checkpoint](../experiments/hermite-polynomial/precision/cycle18-parent-checkpoint.json).
These checks reuse explicitly pinned private caches and do not claim a fresh
transitive build. Actual saved-action diagnostics use twelve local 8-by-8
matrices at `n_p=12,a=2`, not a global dense matrix; this finite routine check
does not certify scalable runtime or physical local-to-global support.

The separate stored-matrix chain has completed exact whole-module source-blind
decoding and distinct source-first comparison. Seven publication records now
validate; 44 of 51 changed production modules still lack admission records.
Full main admission remains fail-closed. Source graph gaps G01/G02/G03 remain
visible. Precision-aware stored cores, comparator/mask contraction, finite-bit
QR/GCD/copy/storage/synthesis, complex operator error, full terminal readout,
C2/C3/X2/ROOT and the independent family executable gate remain open.

### Cycle 19 internal successor (not a certified construction winner)

The canonical complex evaluator adapter has a completed distinct internal
review. The actual precision-aware source's five-component identity is proved;
its concrete generated rational tables and same returned boundary-closed chain
pass finite exact diagnostics, including cut0/N and T0/T1 coincidences. No
uniform Python-to-Lean producer, finite-bit complexity or scientific-family
acceptance follows. The proposed precision-dependent envelope
`18*(d+1)+9*(m+1)+18`, where `d=4*T^2+2*T+1` and `m=2k+1`, remains a concrete
producer dimension rather than an admitted uniform rank/resource certificate.

[Parent focused replay](../experiments/hermite-polynomial/precision/cycle19-parent-checkpoint-v2.json)
passes with 44 ordinary/axiom-free reports and thirteen non-skipped finite
tests. StoredTensorTrain source-blind elaboration passes but its extracted
`absorption` signature collides with `absorptionEntry`; distinct publication
admission remains blocked pending a separately versioned artifact correction.
The unchanged exponential baseline, failed attempts and open C2/C3/X2/ROOT
are retained. No new resource winner or main proof deployment is claimed.

### Cycle 20 integrated internal dependency advances

The actual generated comparison chain has an arbitrary-width source-mask
contract, no supplied mask/Window premise, maximum bond3 and stored-scalar
bound `18*width`. It charges local table/boundary generation and assembly for
the SAME returned object, with division/remainder calls separately visible.
The generic rational polynomial contraction is proved; complete actual source
coefficients, five-term products/directsum and full-chain generation remain open.
[Uniform result](../experiments/hermite-polynomial/precision/piecewise-kernel-uniform-c20/result.json).

The actual complex stage supplies its own contraction/error/Valid and later-left
flattened evaluator bound for arbitrary complex vectors. This is author-only
local evidence pending distinct review, not a scientific population parent.
[Complex result](../experiments/hermite-polynomial/precision/complex-stage-transport-c20/result-v1.json).
Parent focused replays pass37 reports plus7 finite diagnostics; the local Lean
and Tests integration gate passes. Full finite-bit cost, QR, local/global
support, allocated error budget, independent family acceptance and ROOT remain
open, and no new resource winner is selected. Retained failed attempts and
versioned decoder corrections do not alter the scientific target.

### Cycle 21 independent internal transport review

The actual C20 complex-stage interface is now accepted by a distinct internal
reviewer: literal primitive nominal, actual saved interval center/error,
internally derived contraction and `Valid`, full complex terminal carrier and
later-left flattening are preserved. Parent replay passes18 ordinary-axiom
reports and35 independent finite discriminators with unchanged bound inputs.
[Review](../experiments/hermite-polynomial/precision/complex-stage-review-c21/review-result-v1.json)
and [parent replay](../experiments/hermite-polynomial/precision/cycle21-review-parent-checkpoint.json).
Inherited cache/source correspondence remains explicitly partial. This evidence
removes self-review debt at the internal operator interface, not scientific
population acceptance, finite-bit closure, main admission or PURIFIED status.
No resource winner is selected; the exponential baseline and all failures remain.

### Cycle 21 full actual-source algebraic crossover

The c19 five-term source decomposition and c20 arbitrary-width masks/polynomial
translation now supply one actual chain with source-derived middle coefficients.
Every q0-LSB word contracts to the actual finite `piecewiseValue` on the actual
rational grid. The same object has bond envelope
`18*(sourceDegree(delta)+1)+9*(2*k+1+1)+18` and corresponding scalar-address
bound. Parent replay passes13 ordinary-axiom reports; no full stored-data/runtime
producer, finite-bit closure or distinct source review is inferred.
[Source chain](../experiments/hermite-polynomial/precision/piecewise-kernel-assembly-c21/result.json)
and [parent replay](../experiments/hermite-polynomial/precision/cycle21-assembly-parent-checkpoint.json).
The next mutation must materialize this SAME chain's actual tables and charge
all generation/copy/assembly costs, not replace it with an easier existence
witness. Original launcher and search failures remain retained. No new scientific
winner is selected, and the exponential baseline is unchanged.

StoredTensorTrain whole-module source/decoder review is admitted only in the
local retrospective exact-real registry lane (8 reviewed,43 missing of51).
It does not close input generation, finite-bit resources, executable acceptance,
physical cleanup, main migration or ROOT.

### Cycle 22 stored-source implementation refinement

The C21 full-source algebraic chain now has an actual rational local-table and
boundary producer. `produceStored` casts those generated vectors and calls the
canonical stored assembler; its SAME returned chain denotes C21 `actualChain`
and contracts to the full signed q0-LSB finite piecewise source. This is an
implementation refinement of the existing source route, not a new scientific
population winner or a change of target. Source-derived radius/precision and
strict/inclusive/T0/T1 boundary conventions are preserved.
[Producer and remaining costs](../experiments/hermite-polynomial/precision/piecewise-kernel-stored-c22/result.json)
and [parent replay](../experiments/hermite-polynomial/precision/piecewise-kernel-stored-c22/parent-verification-v1.json).

Four parent source re-elaborations pass14 ordinary-axiom reports with215 input
pins unchanged. Only materialization, stored-data casts/copies and assembly are
charged; scalar setup and entry/boundary arithmetic remain unaccounted, not
constant-time oracles. Coefficient caches, cuts, binomial/factorial/power work,
index operations, rational bitlength/GCD, numerical extraction and physical
synthesis remain required. Independent internal semantic review is separate;
public whole-module admission, original-state error composition, family
executable acceptance and ROOT are not inferred. The exponential baseline and
all failed attempts remain retained. No champion/resource scoring changes.

C22's distinct internal semantic review subsequently passes, as does the
parent's fresh consumer replay (seven ordinary reports,70 unchanged pins).
[Review](../reviews/internal/c22-stored-supplier-review/review.md) and
[parent evidence](../reviews/internal/c22-stored-supplier-review/parent-replay-v1.json).
The review explicitly distinguishes finite rational source equality from the
original normalized-state target and proves the partial generation ledger
omits field/comparison charges. This is not a full runtime or population
acceptance upgrade; scientific winner selection remains unchanged.
