# Polynomial-resource Hermite preparation frontier

Root acceptance target: the unchanged normalized Hermite sample state, an
explicit primitive circuit with clean ancillary output, and polynomial-in-data-
width resources with separately stated parameter/precision/preprocessing costs.
This is a live frontier, not a rewrite of historical trial results.

**Highest certified frontier:** the complete exact-real quantum circuit root
is closed. The all-parameter bound is `48*n_p*(2*k+6)^3` on the actual list
length, with `ceil(log2(2*k+6))` clean bond wires and zero oracle calls.
The full classical-cost and uniformly rounded executable gate remains open.
The original exponential reference remains unchanged.

| Node | Interface | Checked Lean evidence | Current status |
| --- | --- | --- | --- |
| H0 | Literal polynomial/splice, positivity, normalized reference | `HermitePolynomial`, `HermiteSmoothness`, `HermiteStatePreparation` | existing certified baseline |
| R1a | Exact sample cuts through width `8*k+12` | `HermiteSampleStructure.sampled_cut_factorization`, `normalized_cut_factorization` | compiled algebraic alternative; not needed as a free premise of the new root |
| R1b | Monomial polynomial transfer | `HermiteTransferCores.sourceInterpolant_transfer` | compiled reusable algebra; direct float implementation failed |
| R1c | Positive Bernstein coefficients, restriction and readout | `HermiteBernstein.sourceInterpolant_bernstein`, `sourceInterpolant_subdivision_readout` | compiled |
| R1d | Complete three-branch source kernel of width `2*k+6` | `HermiteBoundaryInjection.hermiteKernel_eq_sample`, `hermiteFiniteBond_card` | compiled for every path, not numerical rank |
| R2a | Thin real LQ, including rank deficiency | `ThinLQ.exists_thin_lq`; `ConstructiveThinLQ.factor_correct`; `StoredThinLQ.compile_R`, `compile_Q`, `compile_total_cost_le` | existence baseline retained; deterministic stored factor supplier and scoped exact-real cost compiled |
| R2b | Supported sequential action and terminal cleanup | `SequentialBondPreparation.run_eq_transfer_of_supported`, `run_terminal_clean` | compiled generic bridge |
| R2c | All-length canonicalization and no bond growth | `TensorTrainCanonical.exists_rightCanonical`; `ConstructiveTensorTrain.canonicalize_action`, `canonicalize_maxBond_le`, `stateBoundary_normalized` | actual deterministic producer compiled; baseline basis choices no longer needed by new quantum producer |
| R2d | Preserve active columns in SO completion | `ConstructiveIsometryCompletion.complete_spec`; `ConstructiveIsometryLocal.completeStage_spec` | actual deterministic completion compiled; finite swaps/parity, no determinant evaluation or chosen basis |
| R2e | Kernel to actual bounded normalized chain | `MatrixProductChain.ofKernel_contract`; `HermiteFiniteChain.sourceChain_contract`, `sourceChain_normalized`, `sourceChain_storage` | compiled; no assumed target-action oracle |
| R2f | Varying active ranks to one padded schedule | `TensorTrainSchedule.exists_normalized_preparation_schedule`, `paddedAt_active_isometry` | compiled |
| R3a | Selected real plane to actual recursive RY/CX list | `compileSelectedRy_eval_plane`, `compileSelectedRySteps_cubic_bound` | compiled |
| R3b | SO decomposition, Gray transport and actual local compiler | `AdjacentGivens.decomposeSO_matrix`; `GrayGivensCompiler.compileSO_eval`, `compileSO_cubic_bound`; `TensorTrainLocalCompiler.exists_local_circuit_with_resources` | compiled; all local instructions counted |
| R3c | Actual gate placement, public LE order, clean full state | `SequentialPrimitiveAssembly.publicCircuit_column`; `TensorTrainWord.sampleEquiv_public`; `TensorTrainPrimitivePreparation.publicCircuit_clean` | compiled; no uncharged arbitrary initial state |
| R3 | Complete source-derived polynomial-gate quantum root | `HermitePolynomialPreparation.exists_polynomial_preparation`; `ConstructiveHermitePreparation.prepare_spec` | both roots passed the full Lean gate, including every production/test module; publication integration recorded separately |
| C1 | Non-enumerating source norm | `TensorTrainNormEnvironment.gram_eq_sum`; `HermiteFiniteNorm.localSampleNorm_eq_sampleNorm`, `sourceChain_eq_local`, `norm_arithmetic_budget` | compiled; local schedule <=`9*n_p*D^3` add/multiply, plus one sqrt |
| C2 | Deterministic core/basis/angle computation and total real-operation cost | no complete implementation-level cost theorem | open; small matrices alone are not a runtime proof |
| C2a | Stored rectangular elimination and thin LQ | `StoredRectangularGivens.compile_total_cost_le`; `StoredThinLQ.compile_total_cost_le` | compiled cubic local bounds, including cached transforms and copying, in a declared exact-real model |
| C2b | Stored positive-coefficient interval restriction | `StoredBernstein.restrict_value`, `restrict_total_cost_le` | compiled actual producer, <=`20*d^3+42*d^2+32*d+13`; source coefficient/cutoff/exp generation not included |
| C2c | Stored all-length TT canonicalization | `StoredTensorTrain.canonicalize_refines`, `canonicalize_total_cost_le` | compiled equality to actual deterministic result and polynomial stored-operation bound; not a complete source compiler |
| C2d | Stored active-column completion | `StoredIsometryCompletion.complete_value`, `complete_total_cost_le` | compiled actual completion refinement and local polynomial cost; suppliers charged separately |
| C2e | Exact-comparison source cutoff | `HermiteBinaryCutoff.compute_value`, `compute_cost` | scoped compile passed: exactly `n_p` comparisons and `2*n_p` real field operations; finite-bit classification remains C3 |
| C2f | Explicit source-bond layout | `HermiteExplicitBond.bondEquiv`, `same_literal_source`, `rawSourceChain_norm` | scoped compile passed: executable layout and unchanged observable source, not old/new matrix-entry equality or complete core production |
| C2g | Stored source Bernstein coefficients | `StoredHermiteCoefficients.compile_value`, `compile_pos`, `compile_total_cost_le`, `compile_exponentialCalls` | scoped compile passed: ordinary counters <=`864*(k+1)^2`, plus one separate exp call; raw-chain assembly still open |
| C2h | Stored norm environments | `StoredTensorTrainNorm.gram_value`, `norm_value`, `norm_total_cost_le` | cached two-pass Gram supplier and signed/zero/internal-zero-bond tests passed; full cycle-04 Lean and website integration passed; whole compiler composition remains open |
| C2i | Stored recursive local rotation emission | `StoredSelectedRyTrace.compile_value`, `selected_value`, `selected_total_cost_le` | scoped compile passed: full ordered trace equality and local stored-operation ledger; angle evaluation, physical whole-pipeline placement and serialization excluded |
| C3 | Input representation, cutoff separation, rounding, bit complexity | no uniform epsilon/cost certificate | open; real scientific input and rational executable input remain distinct |
| C2j | Actual stored source from k,n,L | `StoredHermiteRawSource.raw_value`, `raw_contract`; `StoredHermiteRawCost.raw_certified` | full canonical Lean and local website integration passed; same actual raw chain, polynomial ordinary work and separately counted exp/integer operations |
| C3a | Actual RY and whole-circuit conditional error | `PrimitiveRyPerturbation.eval_ry_distance`; `PrimitiveCircuitPerturbation.prepare_conditional_clm_distance_le` | full canonical Lean and local website integration passed; supplied aligned circuit and angle accuracy, not a numerical backend |
| M1 | Interval masses and actual-grid `Z>=1` | `HermiteIntervalMass.hermite_polynomial_mass`, `exponentialMassClosed_eq`, `sampled_mass_ge_one` | compiled; independent target/norm validation reuse |
| M2 | Coherent mass/angle arithmetic with uncompute | no supplied circuit | inactive alternative, not combined into the MPS quantum circuit |
| K1 | Exact-signature retrieval and narrow instantiation | 32 checked signatures, 6 applications; context-pack regression | diagnostic; no claim of general workflow speedup |
| X1 | Saved-QASM replay and non-enumerating large-width construction | MPS-02 `n=8,k=8,L=10/300` finite replays; `n=128` original-backend streaming scan; cycle-03 recursive replay and 129-case exact trace comparison | finite numerical/cross-language evidence; not a uniform backend certificate |
| X2 | Rounded backend refinement and independent family acceptance | no uniform backend/rounding theorem | open |
| ROOT | Full frozen scientific and classical/executable resource contract | R3, C1, C2, C3, X2, integration gates | open; exact quantum sub-root closed |

## Next admissible work

1. Revalidate the cycle-05 supplier in the current Lean/toolchain context and
   retain its source/publication debt separately from compilation. Its actual
   raw-chain producer already exists; do not schedule a duplicate implementation.
2. Admit the staged same-run normalized canonical supplier below after genuine
   independent review, then extract stored active columns and compose completion
   and the local Gray emitter. Charge angle instantiation and final placement;
   local cost theorems still do not bound the whole classical compiler.
3. Relate one executable primitive backend to the proved backend, then budget
   input approximation, core rounding, orthogonalization and angle error.
4. Keep any approximate tolerance explicit; finite Qiskit checks never close a
   symbolic all-parameter certificate.

[Cycle-04 evidence and remaining composition work](../experiments/hermite-polynomial/CYCLE04-RESULT.md)
separates scoped checks from full publication acceptance. No C2/C3/X2/ROOT
status is promoted merely because a supplier compiles.

The five cycle-04 interfaces C2e--C2i also passed the complete local publication
pipeline with proof-input digest
`448914e875837c53a5b2a5d08260c9eab4009eb75fd6a9e60503b66aeaf1866a`.
This integration acceptance does not change the open C2/C3/X2/ROOT boundary.

The [cycle-05 source and accuracy packet](../experiments/hermite-polynomial/CYCLE05-RESULT.md)
records the new source composition, conditional angle bound, preserved
regressions and explicit operation-model omissions. Its proof inputs differ
from cycle 04 and require their own integration gate.

## Preserved falsifier

MPS-01's direct monomial/mask arithmetic had normalized state error about
`1.529` at `(n_p,k,L)=(8,8,10)` despite near-orthonormal QR, and overflowed
for `L=300`. MPS-02 changes the representation, not the target. Its float64
success does not prove a uniform precision bound. Do not repeat the failed
route unchanged or accept norms/isometries in place of actual source action.

Diagnostic nodes are not mathematical dependencies. A crossover must name
the shared verified interface; no lineage transfers an unearned certificate.

## 2026-10-08 bounded staging frontier (not production admission)

The current Lean 4.33.0 checkout passed a fresh exhaustive 202-module gate,
with proof-input digest
`5a8f47f8d0afd1d4f957e55babde52a9e9c01babf05c481b988e99ebca2f7758`.
New experimental files were checked separately; they are not silently covered
by that production-module inventory.

- `QuantumBlockEncoding.StagedNormalizedCanonical.compile_certified` now
  proves the same actual normalized/right-canonical chain, its literal Hermite
  contraction, bond bound and declared-model polynomial cost. With `N=n+1`
  and `D=2*k+6`, the ordinary bound is
  `rawBudget k n + N*(200*D^3+141*D^2+49*D+14)+10*D^2+44*D+100`.
  Raw exponential and selected integer counters are carried through unchanged.
  Signed residuals are read and absorbed, not replaced by positive norms.
- `QuantumBlockEncoding.HermiteExplicitControlsCandidate.selected_plane`
  removes choice-based control enumeration through an explicit increasing skip
  table. Its actual stored trace has cost at most
  `(16*q+12)*2^q+5*q^2+14*q`, including cached table/pattern traffic.
  Gray target discovery, input-word production and angle instantiation remain
  separate suppliers. This local `q` is not the data width; the Hermite caller
  must supply the existing logarithmic bond-width relation.
- The preserved float64 falsifier at `(n_p,k,L)=(1025,0,1/100)` motivated an
  isolated positive-scaling mutation. All 32 MPS tests passed after independent
  rerun, including old failure retention and large cache-only diagnostics.
  This is not an exporter replacement, uniform backward-error proof or family
  executable acceptance.

Evidence and exact scope: [staging result packet](../experiments/hermite-polynomial/stored/cycle06-staging-result.json).
The first two items are **PROVED_LOCAL**, not independently source-reviewed,
production-admitted, merged or purified. C2/C3/X2/ROOT remain open. In particular,
the bound omits complete primitive emission and finite-bit/transcendental/index
costs; those omissions cannot be hidden by summing unrelated supplier ledgers.

### Cycle 7 exact provider and scaling bridges

`HermiteGrayTargetCandidate.discover_step_target` now proves that an explicit
parity recursion returns the very same unique physical target as the existing
Gray compiler. Its actual returned record uses at most `2*w` quotients,
`w` remainders and `w` comparisons for local width `w`. The stored Gray-word
producer additionally proves exact bit equality and ordinary cost at most
`8*w*(w+9)`, including vector materialization. Its selected integer work is
explicitly overcharged under `field`, not reinterpreted as real arithmetic.
Evidence: [Gray target packet](../experiments/hermite-polynomial/stored/gray-target-result.json).
These close the target-discovery and stored-input-word subinterfaces locally;
angle instantiation, SO sweep/log composition and physical final placement
are still separate. Local width is bond width plus one, not `n_p`.

`ExperimentalScaledInvariant.hermite_target_public` now proves literal signed
Hermite amplitudes are unchanged by exact positive per-core scaling and
subsequent normalization. The removed product, compensating Gram norm,
signed boundaries, storage/bond invariance and scaled residual absorption
are proved with the existing TT semantics and explicit public LE adapter.
Evidence: [scaling invariant packet](../experiments/hermite-polynomial/precision/scaled-invariant-result.json).
The factors are supplied exact positive reals; this does **not** prove the
computed max-scales, QR, float contractions, underflow, mantissa/exponent
arithmetic or saved circuit. It supports the mathematical mechanism of
`MPS-02-SCALE-01`, not a certified numerical backend.

Both new files passed master focused checks under Lean 4.33.0 and use only
ordinary `propext`, `Classical.choice`, `Quot.sound` in the printed roots.
The production/test sources and proof-input digest are unchanged, and the
full `lake build` and `lake build Tests` passed again. Independent review,
production/reader integration and C2/C3/X2/ROOT remain open.

`StagedActiveColumns.hermiteStage_certified` additionally consumes the actual
returned normalized chain and supplies an actual stored local SO completion,
with physical column action and source-plus-stage cost. The stored matrix is
proved equal to `ConstructiveIsometryLocal.completeStage` under the explicit
bit/bond coordinates, not just an arbitrary existential completion. Extraction
costs at most `22*S*r+8*S+3*(t+1)`, prefix positions exactly `5*r`, and the
existing stored completion bound is charged separately (`S=2^q`, actual rank
`r`, stage `t`). The master recompiled the frozen normalized dependency into
an ignored relative cache, then independently checked every extraction,
completion and regression proof with exit zero.
Evidence: [active-column packet](../experiments/hermite-polynomial/stored/active-columns-result.json).
An all-stage compiler must bind the source once and call `completeAt` on that
cached chain; repeated `hermiteStage` calls rebuild the source. Traversing
from the root for each stage adds a quadratic classical traversal term.
This local provider is not complete C2 or primitive-emitter closure.

### Cycle 8 actual stored primitive-stage composition

`StagedStagePrimitive.compileAt_eval` now composes the actual cached chain's
`completeAt` matrix, a charged materialized Gray reindexer, and the actual
stored SO sweep/reversed-inverse log/selected-RY emitter. Its returned elementary
primitive circuit equals the existing named `completeStage` matrix exactly,
including signs, physical low-bond/high-data wire order and active-column action.
Generic SO premises are derived inside the composition, not added to Hermite's
public source contract. The same return has a checked sum-of-actual-run cost:
`ActiveColumns.stageBudget(q,rank,t) + 8*GrayTable.tableBudget(q) + LocalSOEmission.compilerBudget(q)`.
All three new files passed master focused compilation under Lean 4.33.0;
printed roots depend only on ordinary `propext`, `Classical.choice`, `Quot.sound`.
Evidence: [stage primitive packet](../experiments/hermite-polynomial/stored/stage-primitive-result.json).

With `H=2^(q+1)`, `E=H*(H-1)/2`, `G=2^q+2*(2^q-1)`, the actual local final
gate count is `E*G`. The emission ledger is separately `E*(1+2*G)`, because
it also charges intermediate sweep/template records. No optimization or
resource improvement is inferred from that difference. Selected natural
index operations remain explicit field-tag overcounts, not bounded-bit
arithmetic. The source must still be bound once across all stages; global
placement/copying, whole returned-circuit Hermite action, numerical/finite-bit
cost and independent serialized executable acceptance remain open. This is
a higher **PROVED_LOCAL** C2 subfrontier, not C2/C3/X2/ROOT closure or admission.

### Cycle 9 cached global return and precision discriminator

`StagedGlobalAssembly.compile` now binds the literal normalized source once,
collects every actual primitive-stage return and charges global placement,
padding, persistent list copying and final public reindexing. `compile_eval`
proves full operator refinement to the deterministic compiler on that same
cached chain. The legacy Hermite preparation comparison is deliberately only
its clean-input column, not whole-unitary equality across different chains.
All nonzero terminal bond sectors vanish; signed normalized Hermite amplitudes
are literal. For `N=n_p`, `D=2*k+6`, `q=ceil(log2 D)`, final gates are exactly
`N*K`, bounded by `48*N*D^3`. With `H=2^(q+1)`, `E=H*(H-1)/2`,
`G=2^q+2*(2^q-1)` and `K=E*G`, charged assembly is bounded by
`N^2*(32*K+6)+10*N*K+1`. Source production and every materialized stage are
charged additionally; `compile_total_polynomial` closes their explicit
polynomial envelope in the **declared exact-real/index-word model**.
It does not price arbitrary-precision arithmetic or physical angle synthesis.
Evidence: [global assembly](../experiments/hermite-polynomial/stored/global-assembly-result.json).

`ExperimentalNormalizationStability` proves source norm at least one from
the actual zero-grid sample and a Euclidean normalization/serialization bound
`2*F*delta + eta/(1-eta) + zeta`, for exact positive reference scale `F`
and `0<=eta<1`. The producer must still establish core/QR contraction error
`delta`, computed normalizer error `eta` and full serialized-action error
`zeta`, including ancilla/garbage embedding. Supplying these numbers is not
a numerical backend certificate. The independent dyadic witness shows that
max-core scaling can round the only surviving small branch to zero even for
a finite nonzero TT. This refutes **generic nonzero-TT totality only**;
reachability by the frozen Hermite producer is unproved. It is not a Hermite
impossibility result.
Evidence: [precision result](../experiments/hermite-polynomial/precision/normalization-stability-result.json).

Master focused source checks and production build/tests passed Lean4.33.0.
The general printed roots use the three ordinary logical axioms; finite
native regression proofs have their separately retained evaluator boundary.
Finite-bit complexity, source-reachable numerical stability, independent
full executable acceptance, source admission and C2/C3/X2/ROOT remain open.

### Cycle 10 actual dyadic return and source-reachable failure

`DyadicSupplier.compile` rounds the **actual cached global return**, preserving
physical targets, chronological instruction positions, list length and resource
bookkeeping. Constructor-level closure proves every actual returned instruction
is CX or RY with an integer-over-power-of-two rational angle. Internally proved
alignment, RY sensitivity and circuit telescoping yield full signed Euclidean
state error at most `A/2^b`, where `A=24*n_p*(2*k+6)^3`. The allocation
`b=clog2(max(1,ceil(A/epsilon)))` proves error at most positive `epsilon`.
This includes every garbage sector: approximate garbage is bounded, **not
asserted exactly zero**. The same return retains gate/depth bound
`48*n_p*(2*k+6)^3`, bond width `ceil(log2(2*k+6))` and zero oracle calls.
Its `pureAncilla=0` bookkeeping does not erase those physical bond wires.
Evidence: [dyadic supplier](../experiments/hermite-polynomial/precision/dyadic-supplier/result.json).

The numerator still uses a noncomputable exact-real floor. A finite enclosure
crossing a bin boundary need not determine that literal floor, as the compiled
`floor_boundary_discriminator` proves. This is an exact-refinement issue,
not an impossibility of safe approximate angle computation. Input representation,
computable angle enclosures, integer bit growth, preprocessing runtime,
finite-gate synthesis and saved-parser refinement remain open. Polynomial
dependence on both `n_p` and `k` does not itself provide a relation
`k(n_p,L,epsilon)` or a finite-bit polynomial route.

`ExperimentalHermiteSourcePrecision` adds exact Bernstein coefficient-error,
restriction and rounded-de-Casteljau residual propagation, linked to the literal
Hermite interpolant. Actual residual/coordinate bounds remain obligations.
The **unpatched frozen producer** fails for legal `n_p=2,k=0,L=1/10^100`:
91-digit affine coordinates near1 collapse a positive-width restriction to
`[1,1]`, before QR/normalization. Root and a distinct evidence auditor reproduced
the failure; its classification is `IMPLEMENTATION_FAILED`, not a Hermite
lower bound. Keep it as a successor-supplier regression.
Evidence: [source audit](../experiments/hermite-polynomial/precision/source-reachable/independent-audit.json),
[failure memory](../failure-memory/SP-HERMITE-POLY-002-tiny-L-coordinate-collapse.json).
Actual `n_p=2,k=0,L=1000` instead returns `[0,0,1,0]` with normalizer1 and
a finite exact-source tail-error derivation below `10^-300`; it is not all-zero
normalization failure. The human all-`k` Bernstein range derivation remains
unformalized and is not a uniform numerical backend certificate.

The new saved-QASM diagnostic separately measures exact decimal text,
binary64 reference and parsed-binary discrepancies. Missing files and
structural gate/wire mismatches fail closed; nonzero angle discrepancy is
reported, not disguised as exact identity. Two actual small saved source
circuits pass separate Qiskit replay, including signed state and garbage.
These are finite diagnostics, not the exact Lean producer, parser refinement
or symbolic family acceptance. An independently reproduced schema-type bug
has a versioned correction and regression; its rejected v1 evidence is retained.
Scientific C2/C3/X2/ROOT and production/source/reader integration remain open.

### Cycle 11 computable local suppliers without a substituted target

`SafeEnclosure.safeNumerator` computes a nearest dyadic integer from finite
rational endpoints, using rational midpoint rounding with ties toward positive
infinity. It does not evaluate a real floor or require a unique exact-floor
bin. Ordered intervals of width at most `2^-b` give absolute angle error at
most `2^-b` when they enclose the true angle. The literal list consumer rejects
invalid, missing and excess intervals; its completeness, full resource equality
and chronology theorem preserve actual constructors and ordered wires, not
merely wire footprints. `hermite_internal_supplier` composes this actual return
with the existing exact cached compiler and full signed/all-garbage error bound.
Here the formal parameter `n` means physical `n_p=n+1`.

The real-angle enclosure condition is an **unproved internal supplier edge**,
not a new public Hermite assumption. The exact input list is still noncomputable.
Output numerator and grid-denominator bit bounds are proved; endpoint denominator,
intermediate arithmetic, enclosure generation and total preprocessing runtime
are not. This removes a local exact-bin obstacle, not the finite-bit ROOT gap.
Evidence: [safe finite-data supplier](../experiments/hermite-polynomial/precision/safe-enclosure/result.json).

The separate `offset_hermite_tt` successor retains small rational offsets,
restricts reflected Bernstein coefficients, and reverses their order back to
the original increasing sample coordinate. `offset_grid_source_eval` certifies
the exact original grid expression, while interval-row and stored-dyadic
endpoint bounds provide local coefficient-error interfaces. The old supplier
and its tiny-L failure remain unchanged. The successor actually reaches scaled
normalization and RY/CX construction for `n_p=2,k=0,L=1/10^100`; fresh finite
full-state comparison measures error about `1.57e-16`, whereas its local
polynomial coefficient bound is about `1.986e-100`. These are different errors,
not a global tolerance certificate. No dense source vector enters construction.

A legal near-cutoff regression now refines a coarse pi enclosure rather than
immediately rejecting it. Insufficient retry caps and unattainable float64 local
tolerances fail honestly. No all-L totality or arbitrary-epsilon float64 claim
is made. The saved coefficient-endpoint bit statistic is not a maximum of all
intermediate operands. Pi/exp executable refinement, cutoff separation, float
subdivision/exponential errors, QR/absorption, computed normalizer and saved
circuit action remain open. The safe angle consumer and this numerical source
mutation have **not** been certified as one end-to-end pipeline.
Evidence: [actual offset successor](../experiments/hermite-polynomial/precision/offset-source/result.json).

Root fresh checks: both complete experimental Lean sources compile with ordinary
axioms at their printed roots; project-environment8 successor tests and five
witness records pass. Using an unrelated Python initially failed3 circuit imports
because Qiskit was absent; the existing project environment rerun passed without
skips or dependency installation. This was an environment failure, not a proof
or construction lower bound. C2/C3/X2/ROOT remain open.

Seal provenance is a separate debt: the offset worker amended the internal
interface inventory during proof development and did not retain its initial
snapshot. The final seal hash is not evidence that every signature preceded
proof search. Preserve the final bytes and the
[separate clarification](../experiments/hermite-polynomial/precision/offset-source/seal-clarification.json).
Do not issue a public ProofSeal from this packet. Future signature additions
need immutable versioned pre-proof packets rather than in-place inventory edits.

The distinct offset reviewer reproduced the finite witnesses and reconstructed
five coefficient injections from endpoint jets independently of the producer.
This is scoped numerical evidence, not a new rigorous scalar enclosure proof.
The reviewer also found that a zero-polynomial-injection branch bypasses the
entry's positive exact-Fraction tolerance check. No global epsilon certificate
was emitted. Preserve the frozen implementation and add uniform entry validation
with zero-injection regressions in a separately sealed successor.
See [independent audit](../experiments/hermite-polynomial/precision/offset-source/independent-audit.json)
and [cycle11 aggregate](../experiments/hermite-polynomial/precision/cycle11-staging-result.json).

### Cycle 12 exact rational budgets and stored TT error certificates

The all-`k` range node now has a compiled literal-source proof. With
`B=(k+1)^2*2^(3*k)`, source Bernstein coefficients and valid restrictions
lie in `[0,2*B]`. The actual factorial/binomial formula also has a proved
natural numerator and positive common denominator at valid indices, with
explicit power-of-two output envelopes polynomial in numeric `k` and supplied
scalar operand bits. These are output bounds, not a bound on all intermediate
integers, reduction/GCD, runtime or fixed-float conversion. Keep valid-index,
denominator and scalar-membership domains separate.
Evidence: [coefficient range audit](../experiments/hermite-polynomial/precision/coefficient-range/independent-audit.json).

`RationalBudget` computes the precision from an exact positive rational budget
using integer ceiling division and `Nat.clog`, then passes that actual result
to the unchanged finite angle-list consumer. Its same-return theorem preserves
chronology, ordered wires, resources and the conditional signed/all-garbage
error bound. Zero and negative budgets reject. True-angle containment remains
an internal supplier obligation: deliberately wrong point intervals can pass
width/arity validation but cannot satisfy `Sound`. The angle allocation spends
the entire budget on perturbing an exact list; a numerical source pipeline
must still allocate and compose its other errors.
Evidence: [rational budget audit](../experiments/hermite-polynomial/precision/rational-budget/independent-audit.json).

`QRResidual` uses the actual stored binary64 cores, the same returned QR train
and its literal mantissa/exponent normalizer. Three exact cross-Gram contractions
certify the signed residual and scale drift against the normalized **stored raw
TT**, without assuming exact QR, orthogonality or an exact accumulated scale.
Lean proves the full-word identities and a `27*n*B^3` certificate-contraction
field-operation bound. A 64-core instance used 1,081,560 such operations without
calling a dense amplitude method. This does not certify ideal Hermite source
conversion, repeated compiler QR, angles, circuit garbage, serialized action,
Python-to-Lean refinement or total bit-runtime. Certificate grid precision does
not eliminate backend error.
Evidence: [stored TT residual audit](../experiments/hermite-polynomial/precision/qr-residual/independent-audit.json).

The optional checked entry rejects invalid local coefficient budgets before
delegation, including the previously unchecked zero-injection branch. Valid
calls return the identical original object and preserve exceptions; the
frozen numerical supplier and production behavior are unchanged. Independently
reproduced tests also preserve a legal positive rational `L` for which all
64 fixed cutoff attempts from 8 through 512 terms fail. This is a fixed-cap
**implementation failure**, not a mathematical impossibility or an accepted
construction. Approximate-radius stability is the next source-linked route;
no successful generator or error certificate is inferred from this failure.
Evidence: [entry and cutoff audit](../experiments/hermite-polynomial/precision/offset-entry-v2/independent-audit.json),
[fixed-cap failure](../failure-memory/SP-HERMITE-POLY-002-fixed-cutoff-cap.json).

All three new complete Lean sources were recompiled by root and distinct scoped
reviewers with ordinary axioms at their 17, 12 and 9 printed roots. Context reuse
and upstream authorship are disclosed, not called clean-room review. Separate
immutable signature deltas are retained; the coefficient v3 delta names but
does not hash-pin its parent, while its final result binds all three files.
Earlier OffsetSource seal-history debt remains unchanged. C2/C3/X2/ROOT and
publication, reader, main-migration and deployment gates remain open.

#### Original source stability under radius approximation

`RadiusStability` proves a global bound for the actual `smoothInitial`, for
every natural `k`, including `k=0` and pairs crossing either splice. The
explicit coarse constant is
`C(k)=2^(5*k+2)*(k+1)^2*(2*k+2)*(2*k+1)`. Bernstein finite-power differences
bound the middle polynomial; exponential tail bounds and existing zero-order
endpoint jets join the pieces. No global differentiability or assumed
Lipschitz premise is introduced.

For physical `n_p=n+1`, replacing the internal radius `pi*L` by a positive
rational `Rhat` contributes at most
`2*sqrt(2^n_p)*C(k)*abs(Rhat-pi*L)` to the Euclidean normalized-state error
against the **original** target. The actual grid equality and midpoint norm
floor are reused. The square-root dimension factor is retained, not replaced
by a sup norm or constant dimension. Its logarithmic precision interpretation
adds `O(n_p+k+log(k+1))` bits, but is not a new compiled bit-runtime theorem.

Root freshly recompiled all 16 provider roots with ordinary axioms and all
six kernel consumer checks. Separate signature and consumer seals are retained.
This is a mathematical approximation interface: finite rational radius
generation, pi/exp refinement, input `L` multiplication costs, all numerical
error contributions and total runtime remain open. The fixed-cutoff failure
is unchanged, and no new source target or successful pipeline is substituted.
Evidence: [radius provider](../experiments/hermite-polynomial/precision/radius-stability/result.json).

The distinct radius reviewer independently recompiled all 16 roots and six
consumers, and added seven kernel discriminators for endpoints, Euclidean norm,
original normalization, arbitrary radii and an explicit conditional budget.
No hidden Lipschitz premise, metric substitution or target drift was found.
Reuse of upstream author/reviewer context is disclosed; this is not whole-chain
clean-room or publication review.
See [radius audit](../experiments/hermite-polynomial/precision/radius-stability/independent-audit.json)
and [cycle12 aggregate](../experiments/hermite-polynomial/precision/cycle12-staging-result.json).

#### Next saved circuit interface

The actual diagnostic compiler prunes stored-zero paths and performs another
legacy QR after the scaled return. Completion, `atan2`, Gray expansion and
decimal export then introduce further objects and interpretations; the
stored-TT residual is not a certificate for these stages. The older transport
fixtures also use a different source producer and cannot be relabelled.

The next bounded experiment should bind one actual plan, its saved gate order,
and a compact stage-action chain retaining **all** terminal bond labels. A
finite rational surrogate must have a sound trigonometric enclosure; because
it need not be unitary, its stage errors cannot simply be summed without an
amplification bound. Compare its full signed action to the literal returned
TT padded with zero ancillas, not to a freshly normalized replacement. This
is a design, with no new experiment, producer or theorem yet accepted.
Evidence: [next circuit design](../experiments/hermite-polynomial/precision/next-circuit-frontier-design.json).

### Cycle 13 finite suppliers and actual saved action

The radius approximation is now a computable Lean rational producer, not an
assumed interval around `pi`. `logRadius` uses finite Machin sums and a checked
logarithmic term allocation. It returns a positive rational with proved
membership around the original `pi*L` and error at most its requested **radius**
tolerance. The normalized consumer preserves the charge
`2*sqrt(2^n_p)*C(k)*radiusTolerance`. This tolerance is not automatically the
global state budget. Canonical input-size translation, every stored
intermediate, GCD/allocation/runtime and an external implementation refinement
remain open. [Radius supplier](../experiments/hermite-polynomial/precision/radius-supplier/result.json).

For every rational angle and natural degree, literal finite sin/cos Taylor
polynomials now enclose the exact trigonometric values with radius
`abs(q)^(degree+1)/(degree+1)!`. The bounded degree search either returns a
checked width or honestly fails at its cap. There is no magnitude hypothesis
or free transcendental evaluator. Parent replay compiled scalar, producer and
consumer sources and passed seven exact Python tests; those tests do not
prove Python, decimal parsing or outward-rounding refinement.
[Trigonometric supplier](../experiments/hermite-polynomial/precision/finite-trig/result.json).

The previously proposed saved-action experiment has been performed for the
actual OffsetSource `n_p=3,k=1,L=1` return. One compiler plan produced 456 saved
gates; the compact action chain retains all four terminal bond labels. Its
exact-rational candidate bound to the **literal**, unrenormalized stored
return is approximately `1.18153e-13`; the separate saved-Qiskit binary64
diagnostic observed approximately `2.00613e-15`. Fifteen regressions passed,
including missing artifacts and signed/order/readout discriminators. This is
one finite diagnostic, not a symbolic family certificate or ideal-source
error bound. Parser, interval/stage/readout and Python-to-Lean refinement remain
open. [Saved action](../experiments/hermite-polynomial/precision/saved-action/result-v1.json).

A separate kernel provider proves the required nonunitary-surrogate transport:
chronological product error is at most `product(1+eta_i)-1`. Its operator-action
consumer retains the input norm factor. Two scalar surrogates `11/10` already
give error `21/100`, greater than the naive summed `20/100`. The actual saved
stage interval-to-operator-norm bridge must still supply this provider's
internal local-error interface; no such condition is added to the scientific
Anchor. [Transport](../experiments/hermite-polynomial/precision/nonunitary-transport/result.json).

All four packages are contribution-branch research checkpoints, with distinct
scoped reviews pending at checkpoint time. Complete provider and consumer
compilations use ordinary foundational axioms. C2/C3/X2/ROOT, whole-module
publication, clean reader/CI and main admission remain open. Earlier frozen
packets and failures remain immutable. Checkpoints `667cc30`, `0fe774c` and
`fa5866a` were pushed and their exact remote heads verified; pushing is not
acceptance. Main remains at `305952f` with Lean 4.29.1, while these local proofs
use Lean 4.33.0. User-owned images and Robin artifacts were excluded.

The next root interfaces are a charged global rational precision allocation,
ideal source/scalar-to-stored-TT error, the actual full saved-action refinement,
and total finite-bit preprocessing/synthesis cost. New textbook slices and the
four bounded publication records retain their previous status; this cycle
does not claim whole-textbook or changed-module admission.

Distinct fresh-context reviewers subsequently accepted the three internal
proof providers and the narrow saved-action diagnostic, with independent
complete-source recompilation, exact word-Gram/readout and rebound-QASM
checks. Parent reproduced the six reviewer kernel discriminators, all five
exact-rational tests and the saved-action independent checker. Exciting a
terminal ancilla gives full error about `sqrt(2)`, rather than disappearing
under an accepted-sector projection. This is scoped internal review, not
source-blind approval of the complete Hermite construction.

Two additional small cases also show why the layers remain separate: binary64
Qiskit diagnostic errors can exceed their tiny exact-textual-decimal candidate
bounds. The latter do not bound simulator rounding; neither observation
certifies arbitrary-epsilon binary64 success. Logical matrix-cell copying
counts are not literal Python allocations, and a largest local matrix is not
total peak live memory. Full numerical-backend and bit-cost accounting remain
required. Frozen author records are retained unchanged, with these limitations
in the new independent audits.

### Cycle 14 dimension aware precision and finite exponential tails

The actual positive rational radius is now selected from the **global** state
budget. With physical width `n_p=n+1`, `N=2^n_p` and the already proved source
constant `C(k)`, the literal tolerance is `epsilon/(8*N*Cq(k))`, where `Cq`
casts exactly to `C`. Its original normalized signed-source error is proved
at most `epsilon/4`, rather than merely a radius error. This is a conservative
allocation using `sqrt(N)<=N`; its exponential-looking denominator charges
precision, not an exponential number of output samples. The actual Machin
term count has a checked threshold-size bound. Canonical input-size, all
intermediate integer/rational sizes and runtime are still open.
[Global radius allocation](../experiments/hermite-polynomial/precision/global-radius-budget/result.json).

A separate finite rational supplier now encloses literal `exp(q)` for `q<=0`
using a Taylor remainder with `(degree+1)!`. At `q<=-T`, it returns `[0,2^-T]`
without expanding powers of huge `|q|`; positive scalar-width epsilon supplies
a checked logarithmic cutoff. The clipped mass is **bounded**, not silently
discarded. Actual original Hermite left/right tails at rational coordinates,
and the middle polynomial's `exp(-1)` scalar, consume this enclosure. Active
Taylor degrees may fail the width check, and no uniform degree/runtime bound
or original irrational-grid-to-stored-TT refinement is claimed.
[Finite exponential supplier](../experiments/hermite-polynomial/precision/finite-exp/result.json).

These two immutable internal-provider packages are compiled research WIP,
with distinct review initially pending. Parent full focused replays and
`lake build` / `lake build Tests` pass under Lean 4.33.0. Scalar interval width
is not global state epsilon; the other source, QR, saved-circuit and physical
synthesis contributions remain charged and open. Scientific C2/C3/X2/ROOT,
complete-module source admission, reader/CI and main migration are unchanged.
Checkpoint `6d56dda` was pushed and its exact remote head verified. Existing
failures, user-owned files and unique branch histories remain preserved.

The concrete RY bridge now derives the signed half-angle Taylor matrix error
against `standardRyMatrix`: each entry is within delta, and its Euclidean
operator error, including an arbitrary named physical wire with unchanged
spectators, is at most `2*delta`. The proof decomposes the literal error into
cosine error times identity and sine error times `RY(pi)`. It does not assume
the surrogate is unitary. Kernel fixtures discriminate signs, half angles,
q0/q1/q2, spectator preservation and reused exact CX basis action; the actual
first saved decimal token also has a theorem instance.
[RY bridge](../experiments/hermite-polynomial/precision/saved-ry-interval/result-v2.json).

This supplier's exact Taylor midpoint is **not** identified with the existing
saved-action producer's outward-rounded completed stage midpoint. Stage
chronology, rounding, text decoding, full terminal readout and nonunitary
amplification still need a complete bridge. Initial unpublished path-bearing
metadata was quarantined unchanged; the safe successor has relative commands
and sanitized logs. No private output, Source Anchor approval or ROOT success
is promoted by that recovery.

The distinct fresh-context reviewer subsequently accepted all three scoped
internal packages, rebuilding the analytic suppliers and dependencies from
complete source and checking the RY source/consumer in a separate cache.
Parent repeated both reviewer kernel probe files and all five independent
exact blind-spot tests. A reviewer-only elaboration failure is explicitly
retained as a failed composite, followed by successful corrected probes; it
is not relabelled as a green run. These reviews do not approve the complete
scientific construction, source-blind publication or main admission.
[Cycle 14 evidence](../experiments/hermite-polynomial/precision/cycle14-staging-result.json).

The next scalar proposal uses a factorial-block estimate to obtain a
polynomial sufficient active Taylor degree. It remains **design only**;
neither completeness nor a finite-bit runtime bound is credited before Lean
proof and actual consumers. Radius has spent `epsilon/4`; a provisional
`3*epsilon/16` reserve for each other stage is accounting design, not four
closed bounds. Actual stage midpoint, source/storage and physical synthesis
are still separate obligations.
