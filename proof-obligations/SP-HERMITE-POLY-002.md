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

1. Integrate the cycle-05 actual raw-chain producer and its same-returned-object
   cost theorem; keep the full gate separate from its scoped checks.
2. Consume the stored norm, LQ, canonicalization, completion and local trace
   interfaces through that same producer; local cost theorems do not yet bound
   the whole classical compiler. Keep zero pivots and rank deficiency covered.
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
