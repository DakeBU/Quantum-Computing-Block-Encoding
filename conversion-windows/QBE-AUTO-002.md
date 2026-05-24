# Conversion Window: Circuit Matrix Semantics Backend

Task id: `QBE-AUTO-002`
Created: `2026-05-18`

This window connects the paper-level block-encoding equation to the Lean
matrix-semantics backend needed by `QBE-AUTO-001`.

---

## LaTeX Input

The GHL2025 Robin theorem ultimately requires a circuit matrix $U$ such that

$$
  (\langle 0^a| \otimes I) U (|0^a\rangle \otimes I)
  =
  \frac{A_k}{\alpha},
  \qquad
  \alpha = N_D N_f \kappa .
$$

The paper draws $U$ as a composition of labeled gates and oracle calls:

$$
  U
  =
  (O_D^{BS})^\dagger
  \cdot \mathrm{SWAP}
  \cdot O_f
  \cdot O_D^{BS}
  \cdot R_y^{\mathrm{boundary}}
  \cdot O_{D^T}^{S}
  \cdot U_{\mathrm{indic}}.
$$

The first semantics backend target is not to prove each oracle correct, but to
give this product a Lean matrix object once each labeled gate has a matrix.

---

## Markdown Explanation

The previous faithful-mode cycles represented the Robin circuit as Lean data:

- target matrix: `Examples.RobinHeat.robinDerivativeMatrix`
- circuit labels: `GHL2025.oneTermRobinCircuit`
- theorem tuple: `GHL2025.OneTermRobinTheoremData`
- obligations: `GHL2025.RobinProofObligations`

The missing layer was a way to say:

1. each circuit gate has a full-space matrix,
2. the list of matrices corresponds to the list of circuit labels,
3. the full circuit matrix is their ordered product,
4. a block projection of that full matrix should equal the target matrix divided
   by the normalizer.

`CircuitSemantics.lean` now starts this layer without pretending that oracle
correctness is already solved.

---

## Symbol Map

| LaTeX / paper object | Lean declaration | Type / role | Status |
|---|---|---|---|
| `clog2 (gridSize n) = n` | `clog2_gridSize` | proved dimension bridge (Core.lean) | proved |
| `log2 (2^(n+1) - 1) = n` | `log2_pred_two_pow_succ` | supporting arithmetic lemma | proved |
| $2^q$ Hilbert-space dimension | `qubitDim q` | `Nat` | defined |
| Gate matrix $U_g$ | `GateMatrix α q` | gate label + full-space matrix + unitary obligation | defined |
| Gate/matrix alignment | `gateMatricesMatchCircuit` | `Circuit → List GateMatrix → Bool` | defined |
| Matrix product $U_k\cdots U_1$ | `evalGateMatrices` | folds gate matrices into a circuit matrix | defined |
| Circuit semantics | `CircuitMatrixSemantics α q` | circuit + gate matrices + product matrix | defined |
| Block extraction target | `BlockExtractionTarget α rows cols signalDim` | matrix-level statement container | defined |
| Unproved semantic claim | `SemanticObligation` | description/source/proved bool | defined |
| Block projection $(\langle 0^a| \otimes I)M(|0^a\rangle \otimes I)$ | `signalSystemBlockProjection` | extracts signal×system block | defined |
| Block-projection row index | `signalSystemBlockRowIndex rows signalIdx i` | row offset `signalIdx * rows + i` inside a signal×system matrix | defined and bounded |
| Block-projection column index | `signalSystemBlockColIndex cols signalIdx j` | column offset `signalIdx * cols + j` inside a signal×system matrix | defined and bounded |
| Total circuit qubits | `totalCircuitQubits` | system + signal qubit count | defined |
| Circuit semantics builder | `CircuitMatrixSemantics.blockExtractionTarget` | builds BlockExtractionTarget from semantics | defined |
| Total Robin circuit qubits | `GHL2025.oneTermRobinTotalQubits` | register partition total = $2n + \lceil\log_2 n\rceil + \lceil\log_2 G_f\rceil + 5$ | defined (cycle 2 fix) |
| Effective signal qubits | `GHL2025.effectiveRobinSignalQubits` | totalQubits $- n$ | defined (cycle 2) |
| Indicator bit position | `GHL2025.robinIndicatorBitPosition` | bit position $= 1 + 2n$ | defined (cycle 2) |
| U_indic honest matrix | `GHL2025.indicatorOracleMatrix` | controlled-X permutation on indicator bit | defined (cycle 2) |
| U_indic gate matrix | `GHL2025.oneTermRobinGate_U_indic` | GateMatrix with honest matrix, **proved := true** | proved (run 02 cycle 02) |
| U_indic permutation proof | `GHL2025.indicatorOracleMatrix_is_permutation` | exactly one 1 per row and column | proved (run 02 cycle 02) |
| O_DT^S diagonal helper | `GHL2025.sparseAmplitudeOracleDTMatrix` | legacy/data helper for `robinSparseAmplitudeValue`; not the active Lemma 3 oracle | defined (cycle 7), helper only |
| O_DT^S active gate matrix | `GHL2025.oneTermRobinGate_O_DT_S` | wired to the Lemma 3 controlled-rotation skeleton on ancilla bit 0 | active skeleton, `proved := false` |
| O_DT^S paper register extraction | `GHL2025.SparseAmplitudeOracleDTPaperRegisters`, `GHL2025.sparseAmplitudeOracleDTPaperRegisters` | extract ancilla bit, indicator bit, row register, sparse-index register, and non-ancilla bits for Lemma 3 | defined skeleton |
| O_DT^S symbolic rotation entries | `GHL2025.sparseAmplitudeOracleDTCosHalf`, `GHL2025.sparseAmplitudeOracleDTSinHalf` | symbols for the two entries in the ancilla rotation block | defined; coefficient-normalizer relation unproved |
| O_DT^S coefficient-normalizer contract | `GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerContract`, `GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerObligation` | Eq. (20) requires the $|0\rangle$ amplitude to be $D^{(s)}/N_D$ with a complementary normalizer term | typed contract recorded; proof flags false |
| O_DT^S coefficient-normalizer proof route | `GHL2025.sparseAmplitudeOracleDTNormalizedCoefficient`, `GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute` | separates the $D_j^{(s)}/N_D$ stand-in from the $N_D$ bound, absolute-square, square-root complement, and two-by-two unitarity obligations | typed proof-route record; proof flags false |
| Shared derivative $N_D$ contract | `GHL2025.DerivativeNormalizerNDContract`, `GHL2025.derivativeNormalizerNDContract` | common source for normalized coefficient $D_j^{(s)}/N_D$ used by Lemma 3 Eq. (20) and boundary $R_y$ angles | typed shared contract; nonzero, division, coefficient-bound, absolute-square, square-root, arccos, and two-by-two-unitary flags false |
| O_DT^S paper rotation matrix | `GHL2025.sparseAmplitudeOracleDTRotationMatrix` | identity when the indicator bit is 0; controlled rotation on ancilla bit 0 when the indicator bit is 1 | active skeleton |
| Ry_boundary honest matrix | `GHL2025.oneTermRobinGate_Ry_boundary` | GateMatrix with controlled R_y rotation, proved := false | defined (cycle 8 update) |
| Ry_boundary paper register extraction | `GHL2025.BoundaryRotationPaperRegisters`, `GHL2025.boundaryRotationPaperRegisters` | extract ancilla bit, indicator bit, row register, sparse-index register, and non-ancilla bits for the boundary rotation | defined skeleton |
| Ry_boundary symbolic rotation entries | `GHL2025.boundaryRotationCosHalf`, `GHL2025.boundaryRotationSinHalf` | symbols for $\cos(\theta_j^s/2)$ and $\sin(\theta_j^s/2)$ | defined; angle relation unproved |
| Ry_boundary angle-normalizer contract | `GHL2025.BoundaryRotationAngleNormalizerContract`, `GHL2025.boundaryRotationAngleNormalizerContract`, `GHL2025.boundaryRotationAngleNormalizerObligation` | records $\theta_j^s=\arccos(D_j^{(s)}/N_D)$ and half-angle formulas as false proof obligations | typed contract recorded; proof flags false |
| Ry_boundary angle-normalizer proof route | `GHL2025.boundaryRotationNormalizedCoefficient`, `GHL2025.boundaryRotationAngleNormalizerProofRoute` | separates the $D_j^{(s)}/N_D$ stand-in from division, arccos, half-angle, $N_D$-bound, and two-by-two-unitary obligations | typed proof-route record; shared $N_D$ fields linked; proof flags false |
| O_D^BS active paper-image matrix | `GHL2025.oneTermRobinGate_O_D_BS` | GateMatrix using the Lemma 1 global sparse-slot paper-image skeleton, proved := false | active skeleton with corrected global-slot address |
| O_D^BS column map | `GHL2025.robinSparseColumnMap` | $\mathrm{col}(s,i)$ helper for Robin stencil entries and rejected row-dependent-model memory; not the active paper address | defined (cycle 4; helper only) |
| O_D^BS valid sparse branch | `GHL2025.robinSparseColumnBranchValid`, `GHL2025.bandedSparseAccessPaperValidSparseBranch`, `GHL2025.bandedSparseAccessPaperValidCleanSource` | row-dependent predicate for sparse indices that correspond to nonzero stencil entries; now a rejected-model/domain-audit helper rather than the active address rule | defined audit helper; active matrix uses global sparse slots; proof flags unchanged |
| O_D^BS unused-branch extension contract | `GHL2025.bandedSparseAccessPaperUnusedSparseBranch`, `GHL2025.BandedSparseAccessUnusedBranchExtensionContract`, `GHL2025.bandedSparseAccessUnusedBranchExtensionContract` | classifies clean padded-register branches outside the row-dependent nonzero-stencil predicate and records the missing reversible extension obligations | defined contract slot; all extension proof flags false; active matrix and gate list unchanged |
| O_D^BS unused-branch image-rule interface | `GHL2025.BandedSparseAccessUnusedBranchImageRuleContract`, `GHL2025.bandedSparseAccessUnusedBranchImageRuleContract` | records that no faithful reversible image has been selected yet for clean invalid sparse branches | defined with `proposedImageIndex = none`; image-rule, finite-image, collision-separation, and valid-branch-agreement flags false |
| O_D^BS full clean-domain extension wrapper | `GHL2025.BandedSparseAccessFullCleanDomainExtensionContract`, `GHL2025.bandedSparseAccessFullCleanDomainExtensionContract`, `GHL2025.bandedSparseAccessPaperCleanDomainSplit_iff`, `GHL2025.bandedSparseAccessPaperCleanDomainSplit_disjoint`, `GHL2025.bandedSparseAccessFullCleanDomainExtensionContract_localCleanDomainSplit` | paper-level wrapper that combines valid-branch agreement, the unused-branch image-rule interface, full clean-domain injectivity, dagger cleanup, and unitary extension; local Boolean split partitions clean padded input into valid or unused branches | wrapper defined as an obligation map; local classifier split proved; nested `proposedImageIndex = none`; every semantic field false; active matrices unchanged |
| O_D^BS legacy helper matrix | `GHL2025.bandedSparseAccessMatrix` | old map $|s\rangle|i\rangle \to |s\rangle|\mathrm{col}(s,i)\rangle$; not the active paper oracle | defined (cycle 4; helper only) |
| O_f active gate matrix | `GHL2025.oneTermRobinGate_O_f` | GateMatrix wired to `functionOraclePaperMatrix`, proved := false | active paper-image skeleton; clean input branch wired |
| SWAP honest matrix | `GHL2025.oneTermRobinGate_SWAP` | GateMatrix with permutation matrix, `proved := true` | finite-domain permutation bridge proved by `GHL2025.swapOracleMatrix_is_permutation` |
| SWAP honest matrix | `GHL2025.swapOracleMatrix` | Permutation swapping system/O_D^BS blocks | defined (cycle 3) |
| (O_D^BS)^† active gate matrix | `GHL2025.oneTermRobinGate_O_D_BS_dagger` | GateMatrix using the paper-image transpose matrix, proved := false | active skeleton (run 03 cycle 2 lower) |
| (O_D^BS)^† legacy helper matrix | `GHL2025.bandedSparseAccessDaggerMatrix` | transpose-style matrix for the old sparse-access helper | defined (cycle 4; helper only) |
| All 7 gate matrices | `GHL2025.oneTermRobinGateMatrixPlaceholders` | List GateMatrix | defined |
| Gate-list alignment theorem | `GHL2025.oneTermRobinPlaceholdersMatch` | gateMatricesMatchCircuit = true | proved |
| Robin circuit semantics | `Examples.RobinHeat.oneTermRobinCircuitSemantics` | CircuitMatrixSemantics for the Robin circuit | defined |
| Robin block extraction target | `Examples.RobinHeat.oneTermRobinBlockExtractionTarget` | BlockExtractionTarget with unproved obligations | defined |
| Circuit block encoding claim | `CircuitBlockEncodingClaim` | Schema bundling semantics + target + dim proof + obligation | defined |
| Robin circuit block claim | `Examples.RobinHeat.oneTermRobinCircuitBlockClaim` | CircuitBlockEncodingClaim for Robin, takes dim proof parameter | defined |
| Robin dimension theorem | `Examples.RobinHeat.oneTermRobinCircuitDimCompat` | full dimension = effective signal dim × system dim | proved (cycle 2 update) |
| Default Robin block claim | `Examples.RobinHeat.defaultOneTermRobinCircuitBlockClaim` | Robin claim using reusable dimension theorem | defined |
| Sparse amplitude value | `GHL2025.robinSparseAmplitudeValue` | s-th nonzero stencil coefficient for each row, as Coeff | defined (cycle 5) |
| Function value data | `GHL2025.robinFunctionValue` | symbolic f(x_j) = Coeff.symbol "f_{n}_{j}" for each grid point | defined (cycle 9) |
| O_f diagonal matrix | `GHL2025.functionOracleMatrix` | diagonal matrix encoding f(x_j) function values on the diagonal | defined (cycle 6, fixed cycle 9) |
| O_f paper register extraction | `GHL2025.FunctionOraclePaperRegisters`, `GHL2025.functionOraclePaperRegisters` | extracts system value, $m_f$ workspace value, non-$m_f$ basis index, and clean-workspace flag | defined skeleton |
| O_f normalized clean-branch value | `GHL2025.functionOracleNormalizedValue` | records `robinFunctionValue p.n i` times symbolic `N_f_inv` | defined; division and bound unproved |
| O_f paper-image contract | `GHL2025.FunctionOraclePaperImage`, `GHL2025.functionOraclePaperImage` | records clean branch, orthogonal component label, and false paper-image obligations | defined contract; proof flags false |
| O_f paper-image matrix | `GHL2025.functionOraclePaperMatrix` | matrix skeleton with clean-input branch amplitude and symbolic non-clean completion | active skeleton; completion unproved |
| O_f external amplitude source transcript | `GHL2025.FunctionOracleExternalAmplitudeSourceContract`, `GHL2025.functionOracleExternalAmplitudeSourceContract`, `GHL2025.functionOracleExternalAmplitudeSourceContract_flags_false` | typed transcript of GHL2025 Theorem `Amplitude-oracle for piece-wise polynomial function`, Eq. `coordinate oracle`, and cited arXiv:2411.01131 | source contract compiled; no analytic proof flags promoted |
| O_f $N_f$ amplitude proof route | `GHL2025.FunctionOracleAmplitudeProofRoute`, `GHL2025.functionOracleAmplitudeProofRoute`, `GHL2025.functionOracleAmplitudeProofRoute_sourceAnchor`, `GHL2025.functionOracleAmplitudeProofRoute_externalSourceContract`, `GHL2025.functionOracleAmplitudeProofRoute_flags_false` | packages $f(x_i)$, `N_f`, `functionOracleNormalizedValue`, clean-branch amplitude, the Theorem 5/Eq. `coordinate oracle` source anchor, the cited-source transcript, and false theorem-level amplitude obligations | typed route compiled; division, nonzero $N_f$, normalizer bound, orthogonality, unitary completion, and theorem amplitude correctness remain false |
| O_f active gate matrix | `GHL2025.oneTermRobinGate_O_f` | GateMatrix with paper-image matrix, proved := false | defined; no proof flags promoted |
| Ry_boundary honest matrix | `GHL2025.boundaryRotationMatrix` | controlled R_y on ancilla for boundary rows (indicator=0) | defined (cycle 8) |
| Ry_boundary gate matrix | `GHL2025.oneTermRobinGate_Ry_boundary` | GateMatrix with honest rotation matrix, proved := false | defined (cycle 8 update) |
| Ry_boundary source contract | `GHL2025.BoundaryRotationAngleNormalizerContract` | per-row/sparse-index contract for coefficient, $N_D$, symbolic entries, and false proof flags | defined |
| O_D^BS paper register contract | `GHL2025.BandedSparseAccessPaperContract` | source-contract record for Lemma 1 input/output registers and cleanup obligations | defined (run 03 cycle 1 middle) |
| O_D^BS default paper contract | `GHL2025.defaultBandedSparseAccessPaperContract` | for one-term Robin parameters: $|0\rangle^{n-l}|s\rangle^l|i\rangle^n \mapsto |r_{si}\rangle^n|i\rangle^n$ | defined; all correctness fields unproved |
| O_D^BS paper register extraction | `GHL2025.BandedSparseAccessPaperRegisters`, `GHL2025.bandedSparseAccessPaperRegisters` | extracts the full O_D register, padded-zero field, sparse index, and row value from the compound basis index | defined skeleton (run 03 cycle 1 middle) |
| O_D^BS clean input predicate | `GHL2025.bandedSparseAccessPaperCleanInput` | checks whether the padded-zero field is actually $0^{n-l}$ for the Lemma 1 source equation | defined; domain obligation unproved |
| O_D^BS global slot source | `GHL2025.bandedSparseAccessPaperSparseIndexInKappa`, `GHL2025.bandedSparseAccessPaperGlobalSlotSource`, `GHL2025.bandedSparseAccessPaperGlobalSlotSource_boundaryColumns_n3`, `GHL2025.bandedSparseAccessPaperGlobalSlotSource_encodedOutOfRange_n3` | faithful active source predicate: padded clean input and sparse index $s<\kappa$; old columns `0` and `48` are both in the active global source, while encoded `s=7` is out of range for $\kappa=7$ | defined and tested; semantic cleanup and unitarity unproved |
| O_D^BS per-column audit | `GHL2025.BandedSparseAccessPaperColumnContract`, `GHL2025.bandedSparseAccessPaperColumnContract` | records clean-domain flag, image index, row preservation, address write, address-range check, no-spill check, and false obligations for one basis column | defined skeleton |
| O_D^BS per-column audit bridge | `GHL2025.bandedSparseAccessPaperColumnContract_registerSafety_of_address_lt` | packages the executable row-preservation, address-write, address-range, and no-spill booleans under the existing n-bit-address hypothesis | proved bridge; semantic flags remain false |
| O_D^BS paper address | `GHL2025.bandedSparseAccessPaperAddress` | one-term Robin instance of $r_{si}=r_{s0}+i \bmod 2^n$ from the extracted sparse index and row value | defined through `oneTermRobinGlobalSparseAddress`; correctness flags unproved |
| O_D^BS address-range check | `GHL2025.bandedSparseAccessPaperAddressInRange` | executable check that $r_{si}$ fits in the n-bit paper address register | defined; proof flag false |
| O_D^BS row range block | `GHL2025.bandedSparseAccessPaperRegisters_row_lt_gridSize` | extracted row register is an n-bit row value | proved |
| O_D^BS stencil range block | `GHL2025.robinSparseColumnMap_lt_gridSize_of_row_lt` | if $2 \le n$ and the row is n-bit, then the old fourth-order row-dependent helper is n-bit | proved under explicit side condition; helper only |
| O_D^BS address-range block | `GHL2025.oneTermRobinGlobalSparseAddress_lt_gridSize`, `GHL2025.bandedSparseAccessPaperAddress_lt_gridSize_of_two_le`, `GHL2025.bandedSparseAccessPaperAddressInRange_eq_true_of_two_le` | proves the executable global-slot address check | proved under explicit side condition; semantic flag still false |
| O_D^BS paper image | `GHL2025.bandedSparseAccessPaperImage` | preserves the row register and replaces the O_D register with $r_{si}$ | active image skeleton; correctness unproved |
| O_D^BS image roundtrip block | `GHL2025.bandedSparseAccessPaperImage_lt_qubitDim_of_address_lt`, `GHL2025.bandedSparseAccessPaperImage_rowValue_eq`, `GHL2025.bandedSparseAccessPaperImage_odRegisterValue_eq` | proves finite-basis range plus row and written-address extraction for the executable image under the stated range hypotheses | proved as executable register block; semantic flags remain false |
| O_D^BS finite image index | `GHL2025.bandedSparseAccessPaperImageFin`, `GHL2025.bandedSparseAccessPaperImageFin_val` | turns the executable image into a `Fin` index only when the source column is in range and the written address is n-bit | proved bridge; semantic flags remain false |
| O_D^BS image entry bridge | `GHL2025.bandedSparseAccessPaperMatrix_imageFin_eq_one`, `GHL2025.bandedSparseAccessPaperDaggerMatrix_imageFin_eq_one`, `GHL2025.oneTermRobinGate_O_D_BS_imageFin_eq_one`, `GHL2025.oneTermRobinGate_O_D_BS_dagger_imageFin_eq_one` | proves the forward entry $M[\mathrm{image}(j),j]=1$ and transpose entry $M^\dagger[j,\mathrm{image}(j)]=1$ at the finite image index | proved entry bridge; injectivity, inverse, cleanup, and unitarity still unproved |
| O_D^BS entry-safety witness | `GHL2025.oneTermRobinGate_O_D_BS_imageFin_entrySafety` | packages the active forward entry, active dagger entry, row roundtrip, address roundtrip, and no-spill check under the explicit n-bit address hypothesis | proved executable witness; inverse uniqueness, cleanup, and unitarity still unproved |
| O_D^BS rejected row-dependent collision | `GHL2025.oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3` | Lean-checked rejected-model regression: for $n=3,\kappa=7$, row $0$ with sparse indices $0$ and $3$ collide under `bandedSparseAccessRowDependentPaperImage` | retained as historical helper memory; not an active paper-level blocker |
| O_D^BS active global-slot no-collision | `GHL2025.oneTermRobinGate_O_D_BS_globalSparseBoundaryNoCollision_n3` | Lean-checked corrected active-image regression: the same $n=3$ columns map to distinct active images `96` and `16` | proved regression; semantic proof flags still false |
| O_D^BS post-SWAP register equations | `GHL2025.bandedSparseAccessPaperPostSwap_rowValue_eq_address`, `GHL2025.bandedSparseAccessPaperPostSwap_odRegisterValue_eq_rowValue` | after applying SWAP to the paper image, the system register contains $r_{si}$ and the O_D register contains the original row | proved register block; source-domain uniqueness, cleanup, and unitarity still unproved |
| O_D^BS post-SWAP cleanup witness | `GHL2025.BandedSparseAccessPostSwapCleanup`, `GHL2025.bandedSparseAccessPostSwapCleanup_of_preimage`, `GHL2025.bandedSparseAccessPostSwapCleanup_of_validCleanSourceCandidate_noRange`, `GHL2025.bandedSparseAccessPostSwapCleanup_of_globalSlotSourceCandidate_noRange` | packages a supplied post-SWAP preimage, clean-input hypothesis, n-bit address bound, active dagger entry, and executable row/address/no-spill cleanup checks | conditional witness, historical valid-clean-source wrapper, and active global-source wrapper proved; source-domain uniqueness and `daggerCleanup` still unproved |
| O_D^BS post-SWAP preimage candidate check | `GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_cleanSource` | proves the candidate maps to the post-SWAP column and is clean/address-in-range for finite clean sources with $3 \le n$, $\kappa=7$, and $\lceil\log_2\kappa\rceil=3$ | proved executable audit; uniqueness, dagger cleanup, and unitarity still unproved |
| O_D^BS no-spill check | `GHL2025.bandedSparseAccessPaperHighTail`, `GHL2025.bandedSparseAccessPaperImageNoSpill` | executable check that the paper image preserves bits above the O_D register | defined; proof flag false |
| O_D^BS no-spill proof block | `GHL2025.bandedSparseAccessPaperImage_highTail_eq_of_address_lt`, `GHL2025.bandedSparseAccessPaperImageNoSpill_eq_true_of_address_lt`, `GHL2025.bandedSparseAccessPaperImageNoSpill_eq_true_of_two_le` | proves the executable high-tail/no-spill check from an n-bit written address, and from $2 \le n$ via the address-range block | proved as register-safety block; semantic `noSpill.proved` flag remains false |
| O_D^BS no-spill Boolean bridge | `GHL2025.bandedSparseAccessPaperImageNoSpill_iff` | rewrites the Boolean no-spill check as equality of high tails | proved |
| O_D^BS paper matrix | `GHL2025.bandedSparseAccessPaperMatrix` | matrix entries $M[\mathrm{image}(j),j]=1$ from `bandedSparseAccessPaperImage` | active forward gate matrix skeleton |
| O_D^BS paper dagger matrix | `GHL2025.bandedSparseAccessPaperDaggerMatrix` | transpose-style matrix for the paper image skeleton | active dagger gate matrix skeleton; cleanup unproved |

---

## Lean Declaration Plan

Already implemented:

```lean
def qubitDim (qubits : Nat) : Nat
structure SemanticObligation
structure GateMatrix (α : Type u) (qubits : Nat)
def gateMatricesMatchCircuit
def evalGateMatrices
structure CircuitMatrixSemantics
def CircuitMatrixSemantics.ofGateMatrices
structure BlockExtractionTarget
def signalSystemBlockRowIndex
def signalSystemBlockColIndex
theorem signalSystemBlockRowIndex_lt
theorem signalSystemBlockColIndex_lt
def signalSystemBlockProjection
theorem signalSystemBlockProjection_apply
def totalCircuitQubits
def CircuitMatrixSemantics.blockExtractionTarget
def GHL2025.oneTermRobinTotalQubits
def GHL2025.oneTermRobinGate_U_indic
def GHL2025.oneTermRobinGate_O_DT_S
def GHL2025.oneTermRobinGate_Ry_boundary
structure GHL2025.BoundaryRotationPaperRegisters
def GHL2025.boundaryRotationPaperRegisters
def GHL2025.boundaryRotationCosHalf
def GHL2025.boundaryRotationSinHalf
def GHL2025.boundaryRotationAngleNormalizerObligation
structure GHL2025.BoundaryRotationAngleNormalizerContract
def GHL2025.boundaryRotationAngleNormalizerContract
def GHL2025.oneTermRobinGate_O_D_BS
def GHL2025.oneTermRobinGate_O_f
def GHL2025.oneTermRobinGate_SWAP
def GHL2025.oneTermRobinGate_O_D_BS_dagger
def GHL2025.oneTermRobinGateMatrixPlaceholders
theorem GHL2025.oneTermRobinPlaceholdersMatch
def Examples.RobinHeat.oneTermRobinCircuitSemantics
def Examples.RobinHeat.oneTermRobinBlockExtractionTarget
structure CircuitBlockEncodingClaim
def Examples.RobinHeat.oneTermRobinCircuitBlockClaim
theorem Examples.RobinHeat.oneTermRobinCircuitDimCompat
def Examples.RobinHeat.defaultOneTermRobinCircuitBlockClaim
def GHL2025.robinSparseAmplitudeValue
def GHL2025.robinFunctionValue
structure GHL2025.FunctionOraclePaperRegisters
def GHL2025.functionOraclePaperRegisters
def GHL2025.functionOracleNormalizedValue
structure GHL2025.FunctionOraclePaperImage
def GHL2025.functionOraclePaperImage
structure GHL2025.FunctionOracleExternalAmplitudeSourceContract
def GHL2025.functionOracleExternalAmplitudeSourceContract
theorem GHL2025.functionOracleExternalAmplitudeSourceContract_sourceAnchor
theorem GHL2025.functionOracleExternalAmplitudeSourceContract_flags_false
structure GHL2025.FunctionOracleAmplitudeProofRoute
def GHL2025.functionOracleAmplitudeProofRoute
theorem GHL2025.functionOracleAmplitudeProofRoute_sourceAnchor
theorem GHL2025.functionOracleAmplitudeProofRoute_sourceFunctionValue
theorem GHL2025.functionOracleAmplitudeProofRoute_normalizerNf
theorem GHL2025.functionOracleAmplitudeProofRoute_normalizedAmplitude
theorem GHL2025.functionOracleAmplitudeProofRoute_paperImage
theorem GHL2025.functionOracleAmplitudeProofRoute_obligations_reuse_paperImage
theorem GHL2025.functionOracleAmplitudeProofRoute_externalSourceContract
theorem GHL2025.functionOracleAmplitudeProofRoute_flags_false
theorem GHL2025.indicatorOracleMatrix_col_has_one
theorem GHL2025.indicatorOracleMatrix_col_unique
theorem GHL2025.indicatorOracleMatrix_row_has_one
theorem GHL2025.indicatorOracleMatrix_row_unique
theorem GHL2025.indicatorOracleMatrix_is_permutation
structure GHL2025.BandedSparseAccessPaperContract
def GHL2025.defaultBandedSparseAccessPaperContract
structure GHL2025.BandedSparseAccessPaperRegisters
def GHL2025.bandedSparseAccessPaperRegisters
def GHL2025.bandedSparseAccessPaperCleanInput
def GHL2025.bandedSparseAccessPaperSparseIndexInKappa
def GHL2025.bandedSparseAccessPaperGlobalSlotSource
theorem GHL2025.bandedSparseAccessPaperGlobalSlotSource_cleanInput_eq_true
theorem GHL2025.bandedSparseAccessPaperGlobalSlotSource_sparseIndex_lt_kappa
theorem GHL2025.bandedSparseAccessPaperGlobalSlotSource_boundaryColumns_n3
theorem GHL2025.bandedSparseAccessPaperGlobalSlotSource_encodedOutOfRange_n3
def GHL2025.robinSparseColumnBranchValid
theorem GHL2025.robinSparseColumnBranchValid_boundaryUnused_n3
def GHL2025.bandedSparseAccessPaperValidSparseBranch
def GHL2025.bandedSparseAccessPaperValidCleanSource
theorem GHL2025.bandedSparseAccessPaperValidCleanSource_cleanInput_eq_true
theorem GHL2025.bandedSparseAccessPaperValidCleanSource_validSparseBranch_eq_true
theorem GHL2025.bandedSparseAccessPaperValidCleanSource_separates_boundaryCollision_n3
def GHL2025.bandedSparseAccessPaperUnusedSparseBranch
theorem GHL2025.bandedSparseAccessPaperUnusedSparseBranch_cleanInput_eq_true
theorem GHL2025.bandedSparseAccessPaperUnusedSparseBranch_validSparseBranch_eq_false
theorem GHL2025.bandedSparseAccessPaperCleanDomainSplit_iff
theorem GHL2025.bandedSparseAccessPaperCleanDomainSplit_disjoint
structure GHL2025.BandedSparseAccessUnusedBranchImageRuleContract
def GHL2025.bandedSparseAccessUnusedBranchImageRuleContract
theorem GHL2025.bandedSparseAccessUnusedBranchImageRuleContract_flags_false
theorem GHL2025.bandedSparseAccessUnusedBranchImageRuleContract_of_unusedBranch
structure GHL2025.BandedSparseAccessUnusedBranchExtensionContract
def GHL2025.bandedSparseAccessUnusedBranchExtensionContract
theorem GHL2025.bandedSparseAccessUnusedBranchExtensionContract_flags_false
theorem GHL2025.bandedSparseAccessUnusedBranchExtensionContract_boundaryCollision_n3
theorem GHL2025.bandedSparseAccessUnusedBranchExtensionContract_of_unusedBranch
structure GHL2025.BandedSparseAccessFullCleanDomainExtensionContract
def GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
theorem GHL2025.bandedSparseAccessFullCleanDomainExtensionContract_flags_false
theorem GHL2025.bandedSparseAccessFullCleanDomainExtensionContract_of_unusedBranch
theorem GHL2025.bandedSparseAccessFullCleanDomainExtensionContract_localCleanDomainSplit
structure GHL2025.BandedSparseAccessPaperColumnContract
def GHL2025.bandedSparseAccessPaperColumnContract
theorem GHL2025.robinSparseColumnMap_lt_gridSize_of_row_lt
theorem GHL2025.bandedSparseAccessPaperRegisters_row_lt_gridSize
def GHL2025.bandedSparseAccessPaperAddress
def GHL2025.bandedSparseAccessPaperAddressInRange
theorem GHL2025.bandedSparseAccessPaperAddressInRange_iff
theorem GHL2025.bandedSparseAccessPaperAddress_lt_gridSize_of_two_le
theorem GHL2025.bandedSparseAccessPaperAddressInRange_eq_true_of_two_le
def GHL2025.bandedSparseAccessPaperImage
theorem GHL2025.bandedSparseAccessPaperRegisterValue_eq_mod
theorem GHL2025.bandedSparseAccessPaperHighWidth_le_totalQubits
theorem GHL2025.bandedSparseAccessPaperImage_lowBlock_lt_highBase_of_address_lt
theorem GHL2025.bandedSparseAccessPaperImage_mod_lowBase
theorem GHL2025.bandedSparseAccessPaperImage_div_lowBase_mod_eq
theorem GHL2025.bandedSparseAccessPaperImage_lt_qubitDim_of_address_lt
def GHL2025.bandedSparseAccessPaperImageFin
theorem GHL2025.bandedSparseAccessPaperImageFin_val
theorem GHL2025.bandedSparseAccessPaperImage_rowValue_eq
theorem GHL2025.bandedSparseAccessPaperImage_odRegisterValue_eq
def GHL2025.bandedSparseAccessPaperHighTail
def GHL2025.bandedSparseAccessPaperImageNoSpill
theorem GHL2025.bandedSparseAccessPaperImageNoSpill_iff
theorem GHL2025.bandedSparseAccessPaperImage_highTail_eq_of_address_lt
theorem GHL2025.bandedSparseAccessPaperImageNoSpill_eq_true_of_address_lt
theorem GHL2025.bandedSparseAccessPaperImageNoSpill_eq_true_of_two_le
theorem GHL2025.bandedSparseAccessPaperColumnContract_rowPreserved_eq_true
theorem GHL2025.bandedSparseAccessPaperColumnContract_addressWritten_eq_true_of_address_lt
theorem GHL2025.bandedSparseAccessPaperColumnContract_addressInRange_eq_true_of_address_lt
theorem GHL2025.bandedSparseAccessPaperColumnContract_imageNoSpill_eq_true_of_address_lt
theorem GHL2025.bandedSparseAccessPaperColumnContract_registerSafety_of_address_lt
def GHL2025.bandedSparseAccessPaperMatrix
def GHL2025.bandedSparseAccessPaperDaggerMatrix
theorem GHL2025.bandedSparseAccessPaperMatrix_imageFin_eq_one
theorem GHL2025.bandedSparseAccessPaperDaggerMatrix_imageFin_eq_one
theorem GHL2025.oneTermRobinGate_O_D_BS_imageFin_eq_one
theorem GHL2025.oneTermRobinGate_O_D_BS_dagger_imageFin_eq_one
theorem GHL2025.oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3
theorem GHL2025.shiftLeft_lt_two_pow_of_lt
theorem GHL2025.swapOracleImage_block1_eq_block2
theorem GHL2025.swapOracleImage_block2_eq_block1
theorem GHL2025.swapOracleImage_lt_qubitDim
theorem GHL2025.bandedSparseAccessPaperPostSwap_rowValue_eq_address
theorem GHL2025.bandedSparseAccessPaperPostSwap_odRegisterValue_eq_rowValue
theorem GHL2025.bandedSparseAccessPaperPostSwapImage_lt_qubitDim_of_address_lt
theorem GHL2025.oneTermRobinGate_O_D_BS_dagger_postSwap_entry_of_preimage
structure GHL2025.BandedSparseAccessPostSwapCleanup
def GHL2025.bandedSparseAccessPostSwapCleanup_of_preimage
def GHL2025.robinSparseReverseColumnIndex
theorem GHL2025.robinSparseColumnMap_zero
theorem GHL2025.robinSparseColumnMap_one
theorem GHL2025.robinSparseColumnMap_bulk
theorem GHL2025.robinSparseColumnMap_rightBoundaryPrev
theorem GHL2025.robinSparseColumnMap_rightBoundaryLast
theorem GHL2025.robinSparseReverseColumnRoundtrip_of_lt_eight
theorem GHL2025.robinSparseReverseColumnIndex_lt_eight_of_columnMap
def GHL2025.robinSparseReverseColumnRoundtripCheck
def GHL2025.bandedSparseAccessPaperSpliceODRegister
theorem GHL2025.bandedSparseAccessPaperSpliceODRegister_lt_qubitDim_of_odValue_lt
def GHL2025.bandedSparseAccessPaperCleanODValue
theorem GHL2025.bandedSparseAccessPaperCleanODValue_paddedZero_eq_zero
theorem GHL2025.bandedSparseAccessPaperCleanODValue_lt_two_pow_of_sparse_lt
theorem GHL2025.bandedSparseAccessPaperCleanODValue_sparseIndex_eq
theorem GHL2025.bandedSparseAccessPaperPostSwapReverseSparse_lt_two_pow
theorem GHL2025.bandedSparseAccessPaperPostSwapCleanODValue_lt_two_pow
def GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate
def GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidateChecks
theorem GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_cleanSource
theorem GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_cleanSource
theorem GHL2025.bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate
theorem GHL2025.bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate_noRange
structure GHL2025.SparseAmplitudeOracleDTPaperRegisters
def GHL2025.sparseAmplitudeOracleDTPaperRegisters
def GHL2025.sparseAmplitudeOracleDTCosHalf
def GHL2025.sparseAmplitudeOracleDTSinHalf
def GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerObligation
structure GHL2025.SparseAmplitudeOracleDTCoefficientNormalizerContract
def GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerContract
def GHL2025.sparseAmplitudeOracleDTRotationMatrix
```

Current oracle matrix declarations:

```lean
def GHL2025.indicatorOracleMatrix ...
def GHL2025.swapOracleMatrix ...
def GHL2025.bandedSparseAccessMatrix ...
def GHL2025.bandedSparseAccessPaperMatrix ...
def GHL2025.bandedSparseAccessPaperDaggerMatrix ...
def GHL2025.sparseAmplitudeOracleDTMatrix ...
def GHL2025.sparseAmplitudeOracleDTRotationMatrix ...
def GHL2025.functionOracleMatrix ...
def GHL2025.boundaryRotationMatrix ...
```

Do not fill these with fake proofs. If the matrix equality is not proved, store
it as `SemanticObligation` or `ObligationRecord` with `proved := false`.

---

## Proof Obligations

- [x] Define the signal/system block projection indexing convention.
- [x] Define `CircuitBlockEncodingClaim` schema to bundle semantics + target.
- [x] Wire Robin circuit semantics to block extraction target via `oneTermRobinCircuitBlockClaim`.
- [x] Prove dimension compatibility `clog2(gridSize n) = n` for general `n`.
- [x] Assign gate matrices to `U_indic`, `O_DT^S`, `Ry_boundary`, `O_D^BS`,
  `O_f`, `SWAP`, and `(O_D^BS)^†` (all seven now have nonzero matrix
  semantics; U_indic unitarity proved, others `proved := false`).
- [x] Prove U_indic unitarity via bijection→permutation bridge (`indicatorOracleMatrix_is_permutation`).
- [ ] Prove or explicitly track unitarity of remaining 5 gate matrices
  (O_DT^S, Ry_boundary, O_D^BS, O_f, O_D^BS_dagger).  U_indic and SWAP are
  proved permutation matrices.
- [x] Prove or explicitly track that the matrix product matches the paper
  circuit order (gate-list match by construction, theorem proved).
- [ ] Prove or explicitly track block correctness:
  $(\langle 0^a| \otimes I) U (|0^a\rangle \otimes I)=A_k/\alpha$.
- [x] Replace placeholder zero matrices with real oracle matrices.
- [x] Update `paper-notes/GHL2025_RobinOneTerm.tex` whenever the Lean semantics
  statement changes.
- [x] Edge-case tests for n=1 dim compat, n=1 circuit block claim, 1×1 block
  projection, n=2 field roundtrip, n=2 circuit identity (cycle 1 lower).
- [x] Define `robinSparseAmplitudeValue` sparse amplitude data layer (cycle 5).
- [x] Replace O_f placeholder with honest diagonal matrix (cycle 6).
- [x] Replace O_DT^S placeholder with honest diagonal matrix conditioned on indicator bit (cycle 7).
- [x] Audit and correct O_f: should encode $f(x_j)/N_f$, not derivative amplitude data. (Fixed cycle 9: O_f now uses `robinFunctionValue`)
- [x] Record the O_f paper-register and paper-image source contract without promoting the active gate or amplitude-correctness proof flags.
- [x] Implement Ry_boundary with honest nonzero matrix (cycle 8: controlled R_y rotation).
- [x] Define the faithful O_D^BS paper register extraction and executable paper-image skeleton without promoting correctness flags (run 03 cycle 1 middle).
- [x] Define `bandedSparseAccessPaperMatrix` from the faithful O_D^BS paper image before rewiring the active gate matrix (run 03 cycle 1 lower).
- [x] Activate the paper-image O_D^BS gate pair using `bandedSparseAccessPaperMatrix` and `bandedSparseAccessPaperDaggerMatrix` without promoting proof flags (run 03 cycle 2 lower).
- [x] Record the O_D^BS clean-input domain and per-column image audit so non-clean padded-register columns are not mistaken for the paper Lemma 1 equation.
- [x] Rewire `O_DT^S` from the diagonal helper to the paper controlled-rotation skeleton on ancilla bit 0; keep `sparseAmplitudeOracleDTMatrix` as legacy/data helper.
- [x] Record the O_DT^S coefficient-normalizer obligation and typed per-row contract for the symbolic rotation entries from Lemma 3, Eq. (20).
- [x] Record the Ry_boundary source-contract and typed angle-normalizer obligations without promoting the gate unitarity flag.
- [ ] Prove the O_DT^S coefficient-normalizer relation: the symbolic $|0\rangle$ entry represents $D^{(s)}/N_D$, the complementary entry matches the paper normalizer term, and the two-by-two block is unitary.
- [ ] Prove the Ry_boundary angle-normalizer relation: $\theta_j^s=\arccos(D_j^{(s)}/N_D)$, the half-angle formulas match the symbolic entries, and each two-by-two block is unitary under the $N_D$ bound.

---

## Edge-Case Tests (Cycle 1)

Five tests validating boundary conditions of the matrix-semantics backend:

1. **n=1 dimension compatibility**: `qubitDim` of total qubits equals signal dim × gridSize 1, checked by `native_decide`.
2. **n=1 circuit block claim dim compat**: `oneTermRobinCircuitDimCompat 1` composes correctly with `CircuitBlockEncodingClaim`, checked by `rfl`.
3. **1×1 system block projection**: `signalSystemBlockProjection` on a trivial 1×1 system returns the single entry, checked by `native_decide`.
4. **n=2 field-access roundtrip**: `targetMatrix` field of `CircuitBlockEncodingClaim` matches `robinDerivativeMatrix` at a bulk diagonal entry, checked by `rfl`.
5. **n=2 circuit identity**: `defaultOneTermRobinCircuitBlockClaim` preserves `oneTermRobinCircuit`, checked by `rfl`.

---

## Register Bit Layout (Cycle 2)

The Robin circuit operates on the qubit registers defined by
`RobinRegisterPartition`.  The bit-position convention (LSB = bit 0) is:

| Register | Bit range (LSB) | Width | Field |
|---|---|---|---|
| ancilla | [0] | 1 | `ancillaQubit` |
| system ($j$) | [1, 1+n) | n | `systemQubits` |
| od_pure_ancilla | [1+n, 1+n+odPure) | $n - \lceil\log_2\kappa\rceil$ | `odPureAncillaQubits` |
| sparse_index ($s$) | [1+n+odPure, 1+n+odPure+sparse) | $\lceil\log_2\kappa\rceil$ | `sparseIndexQubits` |
| indicator (ind) | [1+n+odPure+sparse] | 1 | `indicatorQubit` |
| mf | [2+n+odPure+sparse, totalQubits) | $\lceil\log_2 n\rceil + \lceil\log_2 G_f\rceil + 3$ | `mfQubits` |

Key bit positions:

$$\text{indicator\_pos} = 1 + n + (n - \lceil\log_2\kappa\rceil) + \lceil\log_2\kappa\rceil = 1 + 2n$$

$$\text{system\_start} = 1 \quad\text{(ancilla width)}$$

For $n=3, \kappa=7$ (odPure = 0, sparse = 3): indicator at bit 7, system at bits [1,4), total = 13 qubits.

### Total Qubits Fix (F1)

`oneTermRobinTotalQubits` must equal `RobinRegisterPartition.totalQubits`, which includes the `ancillaQubit` visible in the circuit diagram:

$$\text{totalQubits} = m_f + 1 + \lceil\log_2\kappa\rceil + (n - \lceil\log_2\kappa\rceil) + n + 1 = 2n + \lceil\log_2 n\rceil + \lceil\log_2 G_f\rceil + 5$$

For $n=3, G_f=1, \kappa=7$: $6 + 2 + 0 + 5 = 13$ (previously 12, which omitted the ancilla qubit).

### Effective Signal Dimension

The block extraction projects all non-system registers onto $|0\rangle$:

$$\text{effectiveSignalQubits} = \text{totalQubits} - n$$

For $n=3$: $13 - 3 = 10$ signal qubits, signal dim $= 2^{10} = 1024$.

The dimension compatibility theorem becomes:

$$2^{\text{totalQubits}} = 2^{\text{effectiveSignalQubits}} \cdot 2^n$$

---

## U_indic Indicator Oracle Matrix (Cycle 2)

The indicator oracle $U_{\mathrm{indic}}(K_1, K_2)$ is a permutation matrix on the full $2^{\text{totalQubits}}$-dimensional Hilbert space. It acts as a controlled-X on the indicator qubit, conditioned on the system register value being in the bulk window $[K_1, K_2]$:

$$U_{\mathrm{indic}} |mf\rangle|ind\rangle|s\rangle|od\rangle|j\rangle|anc\rangle = |mf\rangle|ind \oplus \mathrm{isBulk}(K_1, K_2, j)\rangle|s\rangle|od\rangle|j\rangle|anc\rangle$$

where $\mathrm{isBulk}(K_1, K_2, j) = 1$ iff $K_1 \leq j \leq K_2$, else $0$.

The matrix entries are:

$$M[i][j] = \begin{cases} 1 & \text{if } i = \mathrm{perm}(j) \\ 0 & \text{otherwise} \end{cases}$$

where the permutation $\mathrm{perm}$ extracts the system register value from the compound index $j$, determines if it is bulk, and flips the indicator bit at position $1 + 2n$:

```text
system_val = (j >> 1) & ((1 << n) - 1)
isBulk     = (K1 <= system_val) && (system_val <= K2)
perm(j)    = j XOR (isBulk << (1 + 2*n))
```

Current Lean status: the formal permutation proof has been supplied, and
`oneTermRobinGate_U_indic.unitary.proved = true`.  This historical Cycle 2
section is retained only as the original construction transcript; the active
status is the symbol map and proof-obligation ledger above.

---

## Cycle 2 Lean Declaration Targets

| Declaration | File | Role | Status |
|---|---|---|---|
| `robinIndicatorBitPosition` | GHL2025.lean | indicator bit position = $1 + 2n$ | implemented |
| `indicatorOracleMatrix` | GHL2025.lean | honest U_indic permutation matrix | implemented |
| updated `oneTermRobinTotalQubits` | GHL2025.lean | uses register partition total | fixed |
| `effectiveRobinSignalQubits` | GHL2025.lean | signal dim including visible ancillas | implemented |
| updated `oneTermRobinGate_U_indic` | GHL2025.lean | uses honest matrix, `unitary.proved = true` | proved |
| updated `oneTermRobinCircuitDimCompat` | RobinMatrix.lean | uses effectiveRobinSignalQubits | fixed |
| updated downstream declarations | RobinMatrix.lean | block claim etc. | fixed |

---

## Cycle 2 Boundary Tests

1. **F1 fix**: `oneTermRobinTotalQubits { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 } = 13` (was 12)
2. **F1 fix n=1**: `oneTermRobinTotalQubits { n := 1, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }` = register partition total
3. **Indicator bit position**: `robinIndicatorBitPosition { n := 3, ... } = 7`
4. **U_indic non-zero**: for a concrete bulk row (e.g. system j=2, K1=2, K2=5), the matrix entry `indicatorOracleMatrix ⟨image, h⟩ ⟨input, h⟩ = Coeff.rat 1` by `native_decide` or `decide`
5. **U_indic boundary**: for a boundary row (e.g. j=0), `indicatorOracleMatrix ⟨j, h⟩ ⟨j, h⟩ = Coeff.rat 1` (identity, indicator not flipped)
6. **Dim compat**: `qubitDim (oneTermRobinTotalQubits p) = qubitDim (effectiveRobinSignalQubits p) * gridSize n` for n=3, n=1
7. **No promoted obligations**: all `unitary.proved` fields remain `false`

---

## SWAP Oracle Matrix (Cycle 3)

The SWAP gate exchanges two n-qubit register blocks in the compound index:

$$\text{system register: bits } [1, 1+n), \quad \text{O\_D}^{BS}\text{ register: bits } [1+n, 1+2n)$$

The permutation uses an XOR construction that avoids masking issues with unsigned Nat:

```text
block1 = (j >>> 1) & ((1 <<< n) - 1)
block2 = (j >>> (1 + n)) & ((1 <<< n) - 1)
diff   = block1 XOR block2
swap(j) = j XOR (diff <<< 1) XOR (diff <<< (1 + n))
```

When `block1 = block2` the SWAP is the identity.  All bits outside the two n-qubit blocks (ancilla bit 0, indicator bit $1+2n$, mf MSBs) are preserved.

In Lean this is recorded as `GHL2025.swapOracleMatrix`.  The SWAP gate-level
flag is now `unitary.proved := true`, justified by
`GHL2025.swapOracleMatrix_is_permutation`.

Source-dependency classification: `classical-lean-lemma`.  The paper figure
uses the standard two-register SWAP operation, but QBE is not relying on an
external SWAP theorem to close this gate.  The Lean route is a local bit-vector
proof over `swapOracleImage`, followed by a finite-domain permutation-matrix
bridge.  No cited-results status changes for this route.

Current proof-DAG blocks:

| Block | Interface | Paper source | Lean declaration | Depends on | Reused by | Status |
|---|---|---|---|---|---|---|
| `swap_diff_bound` | the XOR difference between the two $n$-bit blocks is itself $n$-bit | Fig. 1-term Robin SWAP, arXiv:2506.20478 | `swapOracleDiff_lt_two_pow` | masked block extraction | block equations, range | proved |
| `swap_diff_shift_zero` | right-shifting the bounded difference by $n$ gives zero | Fig. 1-term Robin SWAP, arXiv:2506.20478 | `swapOracleDiff_shiftRight_eq_zero` | `swap_diff_bound` | self-inverse route | proved |
| `swap_diff_shift_mask_zero` | the shifted high-block difference has zero low-block mask | Fig. 1-term Robin SWAP, arXiv:2506.20478 | `swapOracleDiff_shiftLeft_mask_eq_zero` | `shiftLeft_land_mask_eq_zero` | block equations, self-inverse route | proved |
| `swap_image_range` | the image of an in-range full basis index remains in range | Fig. 1-term Robin SWAP, arXiv:2506.20478 | `shiftLeft_lt_two_pow_of_lt`, `swapOracleImage_lt_qubitDim` | `swap_diff_bound`, total-register width bounds | finite-domain bijection route, post-SWAP cleanup witnesses | proved |
| `swap_register_blocks` | after SWAP, the low block is the old high block and the high block is the old low block | Fig. 1-term Robin SWAP, arXiv:2506.20478 | `swapOracleImage_block1_eq_block2`, `swapOracleImage_block2_eq_block1` | `swap_diff_shift_zero`, `swap_diff_shift_mask_zero`, bit extensionality | post-SWAP O_D^BS register equations, self-inverse route | proved |
| `swap_diff_preserved` | the named block difference is unchanged after one SWAP | Fig. 1-term Robin SWAP, arXiv:2506.20478 | `swapOracleDiff`, `swapOracleDiff_preserved` | `swap_register_blocks` | self-inverse route | proved |
| `swap_xor_cancel` | XORing the same two shifted masks twice returns the original index | local Boolean XOR arithmetic | `xor_two_shifted_masks_cancel` | bitwise cancellation | self-inverse route | proved |
| `swap_self_inverse` | prove `swapOracleImage p (swapOracleImage p j) = j` | Fig. 1-term Robin SWAP, arXiv:2506.20478 | `swapOracleImage_self_inverse` | `swap_diff_preserved`, `swap_xor_cancel` | injectivity, finite bijection, permutation matrix | proved |
| `swap_finite_bijection` | prove injectivity and surjectivity on `Fin (qubitDim total)` | Fig. 1-term Robin SWAP, arXiv:2506.20478 | `swapOracleImage_injective`, `swapOracleImage_bijective` | `swap_self_inverse`, `swap_image_range` | row/column uniqueness | proved |
| `swap_matrix_permutation` | prove exactly one `1` entry in each row and column | Fig. 1-term Robin SWAP, arXiv:2506.20478 | `swapOracleMatrix_col_has_one`, `swapOracleMatrix_col_unique`, `swapOracleMatrix_row_has_one`, `swapOracleMatrix_row_unique`, `swapOracleMatrix_is_permutation` | `swap_finite_bijection`, `swapOracleMatrix_eq_image` | SWAP gate flag | proved; SWAP unitary flag true |

### Concrete Example ($n=3, \kappa=7$)

For $j = 86$:

$$\text{block1} = (86 \gg 1) \,\&\, 7 = 3, \quad \text{block2} = (86 \gg 4) \,\&\, 7 = 5$$

$$\text{diff} = 3 \oplus 5 = 6, \quad \text{swap}(86) = 86 \oplus 12 \oplus 96 = 58$$

Self-inverse confirmed by pair: $M(58, 86) = 1$ and $M(86, 58) = 1$.

---

## K1/K2 Derivation from Stencil (R1)

The bulk window bounds $K_1$ and $K_2$ are derived from the finite-difference stencil's radius:

$$K_1 = \text{stencil.leftRadius}, \quad K_2 = \text{gridSize}(n) - \text{stencil.rightRadius} - 1$$

For the fourth-order central second-derivative stencil (`fourthOrderSecondDerivative`):

- `leftRadius = 2`, `rightRadius = 2`
- $K_1 = 2$ (first bulk row after the left boundary)
- $K_2 = 2^n - 3$ (last bulk row before the right boundary)

The stencil requires `leftRadius` boundary rows on the left and `rightRadius` boundary rows on the right to handle non-standard entries near the domain edges.

This matches `defaultRobinCircuitSkeleton` and `defaultRobinWavefunctionDecomposition`, which hardcode `K1 := 2` and `K2 := gridSize p.n - 3`.

---

## gridSize Underflow Precondition (R2)

The bulk window upper bound $K_2 = \text{gridSize}(n) - 3 = 2^n - 3$ requires:

$$K_2 \geq K_1 \iff 2^n - 3 \geq 2 \iff 2^n \geq 5 \iff n \geq 3$$

The fourth-order stencil assumes $n \geq 3$.  For $n < 3$ the bulk window would be empty or inverted.  The Lean code does not enforce this as a type-level precondition; it is an implicit assumption carried by the stencil choice.

---

## Two Signal-Qubit Counts (R3)

The project uses two different signal-qubit counts that must not be conflated:

### Theorem-level signal qubits (from `oneTermRobinLayout`)

$$m_{\text{theorem}} = \lceil\log_2 n\rceil + \lceil\log_2 G_f\rceil + \lceil\log_2 \kappa\rceil + 4$$

This is the signal-qubit count from the one-term Robin theorem in
Guseynov-Huang-Liu 2025, arXiv:2506.20478.  It counts only the signal ancilla
qubits that appear in the block-encoding statement, excluding visible ancilla
workspace qubits.

### Circuit-level signal qubits (from `effectiveRobinSignalQubits`)

$$m_{\text{circuit}} = \text{totalQubits} - n$$

This counts all non-system qubits in the register partition, including:
- the 1-qubit ancilla register (bit 0)
- the $n - \lceil\log_2\kappa\rceil$ pure ancilla qubits for the O_D^BS register
- the indicator qubit
- the $m_f$ function oracle qubits
- the $\lceil\log_2\kappa\rceil$ sparse index qubits

The block extraction uses $m_{\text{circuit}}$ because the projection $(\langle 0^a| \otimes I)$ must zero out all non-system registers, not just the theorem's signal ancillas.

For $n=3, G_f=1, \kappa=7$: $m_{\text{theorem}} = 2 + 0 + 3 + 4 = 9$, $m_{\text{circuit}} = 13 - 3 = 10$.

---

## Cycle 3 Lean Declaration Targets

| Declaration | File | Role | Status |
|---|---|---|---|
| `swapOracleMatrix` | GHL2025.lean | honest SWAP permutation matrix | implemented |
| updated `oneTermRobinGate_SWAP` | GHL2025.lean | uses honest matrix, proved := true | updated after finite permutation bridge |

---

## Cycle 3 SWAP Tests

| Test | Parameters | Method | Status |
|---|---|---|---|
| Block swap pair (86 ↔ 58) | n=3, κ=7 | native_decide | proved |
| Block swap reverse (58 → 86) | n=3, κ=7 | native_decide | proved |
| Second swap pair (2 ↔ 16) | n=3, κ=7 | native_decide | proved |
| Round-trip (16 → 2) | n=3, κ=7 | native_decide | proved |
| Equal blocks → identity (j=54) | n=3, κ=7 | native_decide | proved |
| Preserves outside bits (j=214 → 186) | n=3, κ=7 | native_decide | proved |
| Indicator bit preserved (bit 7 of 186 = 1) | n=3, κ=7 | native_decide | proved |
| Ancilla bit preserved (214, 186 both even) | n=3, κ=7 | native_decide | proved |
| SWAP unitary.proved = true | n=3, κ=7 | rfl | proved |
| Placeholder match with honest SWAP | general p | theorem | proved |

---

## O_D^BS Banded Sparse Access Matrix (Cycle 4)

**Critical correction, 2026-05-24.**  The active O_D^BS work must now repair
the Lean address model before more unitarity or dagger-cleanup proof search.
The previously compiled collision witness is real for the current
row-dependent helper, but it should be treated as a rejected-model regression
test rather than a paper-level source gap.

The relevant source chain is:

- Lemma `Diagonal sparsity`: the sparse index $s$ names a global band/diagonal
  slot derived from the first-row pattern.
- Lemma `Banded-sparse-access-oracle`: the address is
  $r_{si}=r_{s0}+i \bmod 2^n$.
- Remark `sparsity maximum`: the Robin example has $\kappa=7$ diagonal slots,
  including two boundary-effect diagonals.
- The one-term Robin theorem setup says zeros can be included and then uses
  $s=0,\dots,\kappa-1$.

Faithful Lean target: keep all sparse slots in the clean source register and
put zero boundary values in the amplitude/coefficient layer.  Do not delete
boundary slots or fold them to an identity address in `O_D^BS`.  The next lower
packet should introduce a global $\kappa=7$ sparse-slot offset table, define
the active paper address from it, rewire `bandedSparseAccessPaperAddress`, and
then add no-collision tests for the corrected active image.

**Faithfulness correction, 2026-05-22.**  The paper's Lemma 1 defines the
banded sparse access oracle at the register level as

$$
\hat O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n
=
|r_{si}\rangle^n|i\rangle^n,
$$

where $r_{si}=r_{s0}+i \bmod 2^n$ is the $s$-th banded-sparse matrix index.
For the Robin one-term circuit, Fig. 1-term Robin and Theorem 1 reuse this
oracle for $D$ or $D^T$ together with SWAP and $(O_D^{BS})^\dagger$ to clean the
padded sparse-index register.

The legacy Lean declaration `bandedSparseAccessMatrix` is an interim helper:
it preserves the sparse-index register and overwrites the system register with
`robinSparseColumnMap n s i`.  That map is still useful for testing Robin
stencil columns, but the active `oneTermRobinGate_O_D_BS` no longer uses this
simplified contract.  The active gate pair now uses the paper-image skeleton
`bandedSparseAccessPaperMatrix` and its transpose-style dagger
`bandedSparseAccessPaperDaggerMatrix`.  Do not try to prove unitarity or block
extraction for the legacy helper as if it were the paper theorem.

### Source-Contract Audit Pane

The Lean source now has a separate paper-contract record so the faithful target
is no longer only prose:

| Oracle / gate | Paper anchor | Input registers | Output registers | Clean ancillas / cleanup | Lean declaration | Status |
|---|---|---|---|---|---|---|
| $O_D^{BS}$ | Guseynov-Huang-Liu 2025, Lemma 1, arXiv:2506.20478 | padded sparse-index register $|0\rangle^{n-l}|s\rangle^l$ and row register $|i\rangle^n$ | address register $|r_{si}\rangle^n$ and preserved row register $|i\rangle^n$ | clean padded-zero domain, width compatibility, address range, no spill into higher signal bits, injectivity, full-unitary extension, and forward correctness recorded as obligations | `GHL2025.oneTermRobinGate_O_D_BS`, `GHL2025.bandedSparseAccessPaperMatrix`, `GHL2025.defaultBandedSparseAccessPaperContract`, `GHL2025.bandedSparseAccessPaperColumnContract` | active matrix skeleton; finite-image entry bridge, entry-safety witness, post-SWAP register equations, reverse-index theorem, clean-source candidate audit, finite-range cleanup wrapper, and boundary unused-sparse collision witness proved under explicit hypotheses; semantic obligations unproved |
| $(O_D^{BS})^\dagger$ | Fig. 1-term Robin and Lemma 1, arXiv:2506.20478 | post-SWAP address/row registers from the same paper layout | padded sparse-index register cleaned back to $|0\rangle^{n-l}|s\rangle^l$ where applicable | `daggerCleanup.proved = false`; inverse-on-range existence, uniqueness, and unitarity unproved | `GHL2025.oneTermRobinGate_O_D_BS_dagger`, `GHL2025.bandedSparseAccessPaperDaggerMatrix`, `GHL2025.BandedSparseAccessPostSwapCleanup` | active transpose-style skeleton; conditional supplied-preimage cleanup witness proved, but full cleanup obligation remains false |
| Current Lean helper | implementation aid, not a paper source | sparse index plus system row in the current bit layout | sparse index preserved, system overwritten by `robinSparseColumnMap` | no faithful cleanup theorem | `GHL2025.bandedSparseAccessMatrix` | contract drift; helper only |

The default contract uses `paddedZeroQubits = p.n - clog2 p.kappa` and
`sparseIndexQubits = clog2 p.kappa`.  Because `OneTermRobinParameters` does
not enforce `clog2 p.kappa <= p.n`, the width equation is an explicit
`widthCompatible` obligation rather than an assumption.  The same contract now
records two narrower Lemma 1 image obligations: `addressRange`, which requires
`bandedSparseAccessPaperAddress p j < 2^p.n`, and `noSpill`, which requires
`bandedSparseAccessPaperImage p j` to leave the high tail above the n-bit
$O_D^{BS}$ register unchanged.  The executable address check is now proved
under the explicit side condition $2 \le n$; the contract flag remains false
until that side condition is part of the paper parameter family.  The no-spill
Boolean is bridged to high-tail equality, and the executable high-tail equality
is now proved from an n-bit written address.  The paper-level `noSpill` flag
still remains false because the source contract has not yet bundled the
parameter-family side condition.

The post-SWAP route now has a proved Boolean clean-source audit
`bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_cleanSource`, finite
post/pre range inputs, and a no-extra-range conditional witness
`bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate_noRange`.  These
declarations still do not prove uniqueness, do not provide a full unitary
extension, and do not set `daggerCleanup.proved`.

Historical row-dependent audit: the predicate
`bandedSparseAccessPaperValidCleanSource` also admitted a rejected helper route
that deleted zero-amplitude sparse slots at boundary rows.  Lean preserves the
concrete collision theorem
`oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3`: for $n=3$ and
$\kappa=7$, the old row-dependent helper collides on source columns `0` and
`48`.  This is now regression memory for the rejected helper, not an active
paper-level source gap.  The active source predicate is
`bandedSparseAccessPaperGlobalSlotSource`; both columns are active global
sources, and `oneTermRobinGate_O_D_BS_globalSparseBoundaryNoCollision_n3`
checks that the corrected paper image separates them.

The interim helper maps $|s\rangle|i\rangle \to
|s\rangle|\mathrm{col}(s,i)\rangle$, where $\mathrm{col}(s,i)$ is the column
index of the $s$-th nonzero entry in row $i$ of the Robin derivative matrix.

### O_D^BS Proof-DAG Pane

The faithful paper target factors into reusable register blocks before any
unitarity search.  The active Lean gate pair now points at the paper-image
skeletons, so the remaining rows are either compiled declarations or unproved
obligations for parameter-family address/no-spill facts, injectivity, cleanup,
and block extraction.

| Block | Interface | Paper source | Lean declaration | Depends on | Reused by | Status |
|---|---|---|---|---|---|---|
| `odbs_width_compatible` | the padded zero register and sparse-index register have total width $n$ | Lemma 1, arXiv:2506.20478 | `defaultBandedSparseAccessPaperContract p`.widthCompatible | parameter-family width fact for `clog2 p.kappa <= p.n` | register extraction, paper image | unproved |
| `odbs_extract_registers` | extract padded-zero, sparse-index, full O_D register, and row values from the current compound basis index | Lemma 1 and Fig. 1-term Robin, arXiv:2506.20478 | `bandedSparseAccessPaperRegisters` | layout fields in `defaultRobinRegisterPartition`, `oneTermRobinTotalQubits` | paper image, cleanup | defined skeleton; concrete tests pass |
| `odbs_clean_domain` | distinguish columns satisfying the paper input $|0\rangle^{n-l}|s\rangle^l|i\rangle^n$ from non-clean padded-register columns requiring a unitary completion | Lemma 1, arXiv:2506.20478 | `bandedSparseAccessPaperCleanInput`, `bandedSparseAccessPaperColumnContract`, `.cleanInputDomain`, `.unitaryExtension` | `odbs_extract_registers` | paper image, forward matrix, unitarity route | defined skeleton; proof flags false |
| `odbs_valid_sparse_branch_domain` | retain the row-dependent nonzero-stencil predicate only as rejected-model audit memory | Lemma 1, arXiv:2506.20478; row counts from the Robin one-term stencil transcript | `robinSparseColumnBranchValid`, `bandedSparseAccessPaperValidSparseBranch`, `bandedSparseAccessPaperValidCleanSource`, `bandedSparseAccessPaperValidCleanSource_separates_boundaryCollision_n3` | `odbs_clean_domain`, rejected row-dependent collision witness | regression tests and paper-drift audits | audit helper retained; not the active source domain |
| `odbs_global_source_domain` | active Lemma 1 source domain: padded clean input and global sparse slot $s<\kappa$ | Lemma 1, Remark `sparsity maximum`, and zero-inclusion paragraph before Theorem `1 term robin`, arXiv:2506.20478 | `bandedSparseAccessPaperSparseIndexInKappa`, `bandedSparseAccessPaperGlobalSlotSource`, `bandedSparseAccessPaperGlobalSlotSource_boundaryColumns_n3`, `bandedSparseAccessPaperGlobalSlotSource_encodedOutOfRange_n3` | `odbs_clean_domain`, `odbs_global_address` | active image, cleanup route, injectivity route | implemented; semantic cleanup and unitarity flags false |
| `odbs_unused_branch_extension_contract` | preserve the old row-dependent unused-branch contract as rejected-model memory | Lemma 1 and one-term Robin zero-branch audit, arXiv:2506.20478 | `bandedSparseAccessPaperUnusedSparseBranch`, `BandedSparseAccessUnusedBranchExtensionContract`, `bandedSparseAccessUnusedBranchExtensionContract`, `bandedSparseAccessUnusedBranchExtensionContract_boundaryCollision_n3` | `odbs_valid_sparse_branch_domain`, rejected row-dependent collision witness | reviewer audit and historical proof memory | contract slot defined; all extension proof flags false; active global-slot image unchanged |
| `odbs_unused_branch_image_rule` | specify, or explicitly leave missing, the reversible image rule for clean invalid sparse branches | Lemma 1 and one-term Robin zero-branch audit, arXiv:2506.20478 | `BandedSparseAccessUnusedBranchImageRuleContract`, `bandedSparseAccessUnusedBranchImageRuleContract`, `bandedSparseAccessUnusedBranchImageRuleContract_flags_false`, `bandedSparseAccessUnusedBranchImageRuleContract_of_unusedBranch` | `odbs_unused_branch_extension_contract`, `odbs_valid_sparse_branch_domain` | full clean-domain injectivity, dagger cleanup, and unitary-extension routes | interface defined with no proposed image; all image-rule proof flags false; active matrices unchanged |
| `odbs_full_clean_domain_extension_contract` | lift the per-column unused-branch image-rule interface into a paper-level full clean-domain contract | Lemma 1 and the one-term Robin zero-branch audit, arXiv:2506.20478; no external reversible-completion theorem recorded | `BandedSparseAccessFullCleanDomainExtensionContract`, `bandedSparseAccessFullCleanDomainExtensionContract`, `bandedSparseAccessFullCleanDomainExtensionContract_flags_false`, `bandedSparseAccessFullCleanDomainExtensionContract_of_unusedBranch`, `bandedSparseAccessPaperCleanDomainSplit_iff`, `bandedSparseAccessPaperCleanDomainSplit_disjoint`, `bandedSparseAccessFullCleanDomainExtensionContract_localCleanDomainSplit` | `odbs_unused_branch_image_rule`, `odbs_valid_sparse_branch_domain`, `odbs_boundary_unused_collision` | injectivity, dagger cleanup, and unitary-extension routes | wrapper defined; local clean-domain classifier split proved; nested `proposedImageIndex = none`; all semantic flags false; active matrices unchanged |
| `odbs_address_range` | check and then prove that the written $r_{si}$ value fits in the n-bit output address register | Lemma 1, arXiv:2506.20478 | `bandedSparseAccessPaperAddressInRange`, `.addressRange` | `odbs_extract_registers`, `bandedSparseAccessPaperAddress` | no-spill, forward image, unitarity route | executable check defined; proof flag false |
| `odbs_address_range_n_ge_2` | prove the executable address-range check once the paper parameter family supplies $2 \le n$ | Lemma 1, arXiv:2506.20478 | `oneTermRobinGlobalSparseAddress_lt_gridSize`, `bandedSparseAccessPaperAddressInRange_eq_true_of_two_le`, `bandedSparseAccessPaperAddress_lt_gridSize_of_two_le` | row extraction, global sparse-slot address | no-spill, forward image, unitarity route | proved under explicit side condition; proof flag false |
| `odbs_no_spill` | check and then prove that the image only changes bits $[1+n,1+2n)$ and preserves indicator and $m_f$ bits above that register | Lemma 1 and Fig. 1-term Robin, arXiv:2506.20478 | `bandedSparseAccessPaperHighTail`, `bandedSparseAccessPaperImageNoSpill`, `bandedSparseAccessPaperImageNoSpill_iff`, `bandedSparseAccessPaperImage_highTail_eq_of_address_lt`, `bandedSparseAccessPaperImageNoSpill_eq_true_of_address_lt`, `bandedSparseAccessPaperImageNoSpill_eq_true_of_two_le`, `.noSpill` | `odbs_address_range`, `odbs_forward_image` | forward matrix, dagger cleanup, block extraction | executable no-spill proved from address range and $2 \le n$; semantic proof flag false |
| `odbs_forward_image` | map $|0\rangle^{n-l}|s\rangle^l|i\rangle^n$ to $|r_{si}\rangle^n|i\rangle^n$ and preserve the row register | Lemma 1, arXiv:2506.20478 | `bandedSparseAccessPaperAddress`, `bandedSparseAccessPaperImage`, and `.forwardCorrect` | `odbs_width_compatible`, `odbs_extract_registers` | paper matrix entries, dagger cleanup | defined skeleton; `.forwardCorrect.proved = false` |
| `odbs_forward_matrix` | build the permutation-style matrix from the paper image, not from `robinSparseColumnMap` on the system register | Lemma 1, arXiv:2506.20478 | `bandedSparseAccessPaperMatrix` | `odbs_forward_image` | `oneTermRobinGate_O_D_BS` | active skeleton; finite-image entry bridge proved under explicit hypotheses; injectivity unproved |
| `odbs_rejected_row_dependent_collision` | preserve the old boundary collision for the rejected row-dependent address helper | Lemma 1, arXiv:2506.20478 and Robin boundary stencil row counts | `bandedSparseAccessRowDependentPaperAddress`, `bandedSparseAccessRowDependentPaperImage`, `oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3`, `robinSparseColumnBranchValid_boundaryUnused_n3` | old `robinSparseColumnMap` helper | source-contract correction memory, reviewer guard | proved rejected-model obstruction for $n=3,\kappa=7$; corrected active image separates the columns |
| `odbs_dagger_matrix` | build the transpose-style matrix paired with the paper image skeleton | Fig. 1-term Robin and Lemma 1, arXiv:2506.20478 | `bandedSparseAccessPaperDaggerMatrix` | `odbs_forward_image` | `oneTermRobinGate_O_D_BS_dagger` | active skeleton; inverse-on-range unproved |
| `odbs_image_fin_entry_bridge` | under source-column range and n-bit address hypotheses, build the finite image index and prove the forward and dagger entries at that index are $1$ | Lemma 1 and Fig. 1-term Robin, arXiv:2506.20478 | `bandedSparseAccessPaperImageFin`, `bandedSparseAccessPaperMatrix_imageFin_eq_one`, `bandedSparseAccessPaperDaggerMatrix_imageFin_eq_one`, `oneTermRobinGate_O_D_BS_imageFin_eq_one`, `oneTermRobinGate_O_D_BS_dagger_imageFin_eq_one` | `odbs_image_range_of_address_range`, active paper matrices | injectivity route, inverse-on-range route | proved as entry bridge; semantic flags false |
| `odbs_entry_safety_witness` | package active forward/dagger entries, row/address roundtrip, and no-spill facts under the n-bit address hypothesis | Lemma 1 and Fig. 1-term Robin, arXiv:2506.20478 | `oneTermRobinGate_O_D_BS_imageFin_entrySafety` | `odbs_image_fin_entry_bridge`, row/address/no-spill blocks | inverse-on-range and cleanup route | proved executable witness; semantic flags false |
| `odbs_post_swap_registers` | after `swapOracleImage (bandedSparseAccessPaperImage p j)`, prove the system row register is $r_{si}$ and the O_D register is the original row | Lemma 1 and Fig. 1-term Robin, arXiv:2506.20478 | `swapOracleImage_block2_eq_block1`, `bandedSparseAccessPaperPostSwap_rowValue_eq_address`, `bandedSparseAccessPaperPostSwap_odRegisterValue_eq_rowValue` | `odbs_image_row_roundtrip`, `odbs_image_address_roundtrip`, SWAP block equations | dagger cleanup route, inverse-on-range route | proved as register equations; semantic cleanup flag false |
| `odbs_post_swap_range` | prove the post-SWAP column is still inside the finite full basis | Fig. 1-term Robin SWAP and Lemma 1, arXiv:2506.20478 | `shiftLeft_lt_two_pow_of_lt`, `swapOracleImage_lt_qubitDim`, `bandedSparseAccessPaperPostSwapImage_lt_qubitDim_of_address_lt` | SWAP diff bound, paper-image range | finite post constructor for cleanup witness | proved range block; independent of the later SWAP permutation bridge |
| `odbs_reverse_sparse_index` | recover a three-bit sparse index that maps the post-SWAP row back to the source row in the corrected global-slot family | Lemma 1, arXiv:2506.20478 | `oneTermRobinGlobalSparseInverseSlot`, `oneTermRobinGlobalSparseAddress_inverseSlot_address_eq`; old `robinSparseReverseColumnIndex` blocks remain helper memory | global slot table, row normalizers, and $3 \le n$, $s < 8$ bounds | global-source preimage candidate | proved arithmetic block; no uniqueness or cleanup flag |
| `odbs_preimage_candidate_clean_source` | prove the Boolean image, clean-domain, and address-range audit for the spliced post-SWAP candidate | Lemma 1 and Fig. 1-term Robin, arXiv:2506.20478 | `bandedSparseAccessPaperPostSwapPreimageCandidate`, `bandedSparseAccessPaperPostSwapPreimageCandidateChecks`, `bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_cleanSource` | reverse-index block, splice lemmas, clean O_D value lemmas | supplied-preimage cleanup witness | proved under explicit $3 \le n$, $\kappa=7$, `clog2 p.kappa = 3`, finite-source, and clean-input hypotheses; semantic flags false |
| `odbs_preimage_candidate_range` | prove the spliced clean reverse-index candidate is inside the finite full basis | Lemma 1 and Fig. 1-term Robin, arXiv:2506.20478 | `bandedSparseAccessPaperSpliceODRegister_lt_qubitDim_of_odValue_lt`, `bandedSparseAccessPaperPostSwapReverseSparse_lt_two_pow`, `bandedSparseAccessPaperPostSwapCleanODValue_lt_two_pow`, `bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_cleanSource` | post-SWAP range, reverse-index bound, clean O_D bound | finite pre constructor for cleanup witness | proved under explicit $3 \le n$, $\kappa=7$, `clog2 p.kappa = 3`, and clean-source hypotheses; semantic flags false |
| `odbs_global_source_inverse_interface` | package the active global-source preimage candidate and keep inverse, uniqueness, injectivity, cleanup, and unitary-extension fields false | Lemma 1 and Fig. 1-term Robin, arXiv:2506.20478 | `BandedSparseAccessGlobalSlotInverseOnRangeContract`, `bandedSparseAccessGlobalSlotInverseOnRangeContract`, `bandedSparseAccessGlobalSlotInverseOnRangeContract_flags_false`, `bandedSparseAccessGlobalSlotInverseOnRangeContract_of_globalSlotSource`, `bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_globalSlotSource`, `bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_globalSlotSource` | `odbs_global_source_domain`, global reverse-index block, preimage candidate audit | next injectivity or unique-preimage packet | interface compiled; semantic flags false |
| `odbs_dagger_cleanup_entry_bridge` | construct the finite post-SWAP target and candidate preimage from the active global-source contract, then expose the transpose-style dagger entry and executable register checks | Lemma 1 and Fig. 1-term Robin, arXiv:2506.20478 | `bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerCleanupBridge` | `odbs_global_source_inverse_interface`, `odbs_dagger_cleanup`, finite post/pre range blocks | reviewed inverse-on-range and cleanup-contract map | proved bridge; `daggerCleanup` and `unitaryExtension` flags remain false |
| `odbs_cleanup_contract_map` | expose the contract post-SWAP target, candidate preimage, active-source uniqueness, cleanup witness, and transpose-style dagger entry in one reviewed wrapper | Lemma 1 and Fig. 1-term Robin, arXiv:2506.20478 | `bandedSparseAccessGlobalSlotInverseOnRangeContract_cleanupContractMap` | `bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerCleanupBridge`, `bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge` | later cleanup contract and O_D^BS unitarity route | proved wrapper; inverse, uniqueness, injectivity, cleanup, and unitary-extension flags remain false |
| `odbs_dagger_cleanup` | after SWAP, $(O_D^{BS})^\dagger$ restores the padded sparse-index register when the forward-image hypotheses hold | Fig. 1-term Robin and Lemma 1, arXiv:2506.20478 | `BandedSparseAccessPostSwapCleanup`, `bandedSparseAccessPostSwapCleanup_of_preimage`, `bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate`, `bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate_noRange`, `bandedSparseAccessPostSwapCleanup_of_validCleanSourceCandidate_noRange`, `bandedSparseAccessPostSwapCleanup_of_globalSlotSourceCandidate_noRange`, `defaultBandedSparseAccessPaperContract p`.daggerCleanup | `odbs_forward_image`, SWAP register block lemmas, clean-source candidate audit, finite post/pre range, valid-clean-source bridge, global-slot source bridge | block extraction | no-extra-range conditional witness proved; historical valid-clean-source wrapper and active global-source wrapper proved; uniqueness, full cleanup, and semantic flag remain unproved |
| `block_projection_normalizer` | extract the signal-index-zero system block of the composed circuit product and compare it with $A_k/(N_DN_f\kappa)$ | Theorem 1-term Robin and Fig. 1-term Robin, arXiv:2506.20478 | `Examples.RobinHeat.oneTermRobinBlockExtractionTarget`, `signalSystemBlockRowIndex`, `signalSystemBlockColIndex`, `signalSystemBlockProjection`, `GHL2025.oneTermRobinNormalizer` | active gate matrices, dimension split, O_D^BS cleanup obligations | final block-correctness theorem | row/column index helpers and structural tests compiled; correctness unproved |

### Lower Packet Results

Run 03 cycle 1 added `odbs_extract_registers` and the first executable
`odbs_forward_image` skeleton.  The lower packet added
`bandedSparseAccessPaperMatrix`, whose column entries are governed by
`bandedSparseAccessPaperImage`.  Run 03 cycle 2 then activated the gate pair:
`oneTermRobinGate_O_D_BS.matrix` is now `bandedSparseAccessPaperMatrix p`, and
`oneTermRobinGate_O_D_BS_dagger.matrix` is now
`bandedSparseAccessPaperDaggerMatrix p`.  None of these packets changed
`oneTermRobinGate_O_D_BS.unitary.proved`,
`oneTermRobinGate_O_D_BS_dagger.unitary.proved`, or any block-correctness
record.

| Declaration | Contract |
|---|---|
| `bandedSparseAccessPaperRegisters` | expose the padded sparse-index register and row register used by Lemma 1 |
| `bandedSparseAccessPaperImage` | encode the basis-image formula $|0\rangle^{n-l}|s\rangle^l|i\rangle^n \mapsto |r_{si}\rangle^n|i\rangle^n$ while preserving row bits |
| focused tests | for `n = 3`, `kappa = 7`, row preservation and address-register replacement pass for one bulk row and one boundary row |
| `bandedSparseAccessPaperMatrix` | set $M[\mathrm{image}(j),j]=1$ and all other entries in the tested columns to zero |
| focused matrix tests | for `n = 3`, `kappa = 7`, paper-image entries pass for one bulk column and one boundary column |
| `bandedSparseAccessPaperDaggerMatrix` | set $M^\dagger[i,j]=1$ exactly when $j=\mathrm{image}(i)$ |
| `bandedSparseAccessPaperImageFin` | packages the executable image as a finite basis index from an in-range source column and an n-bit written address |
| `bandedSparseAccessPaperMatrix_imageFin_eq_one` and `oneTermRobinGate_O_D_BS_imageFin_eq_one` | prove the forward matrix and active forward gate have entry $1$ at the finite image index |
| `bandedSparseAccessPaperDaggerMatrix_imageFin_eq_one` and `oneTermRobinGate_O_D_BS_dagger_imageFin_eq_one` | prove the transpose-style matrix and active dagger gate have entry $1$ in the paired row/column position |
| `bandedSparseAccessPaperAddressInRange_eq_true_of_two_le` | proves the executable address-range check for $2 \le n$ without promoting `addressRange.proved` |
| `bandedSparseAccessPaperImage_highTail_eq_of_address_lt` | proves high-tail preservation for `bandedSparseAccessPaperImage` from the n-bit address hypothesis |
| `bandedSparseAccessPaperImageNoSpill_eq_true_of_address_lt` | turns the high-tail equality into the executable no-spill Boolean |
| `bandedSparseAccessPaperImageNoSpill_eq_true_of_two_le` | combines the address-range block with no-spill under $2 \le n$ |
| `bandedSparseAccessPaperImageNoSpill_iff` | rewrites the no-spill Boolean as equality of high tails |
| focused no-spill tests | for `n = 3`, `kappa = 7`, a column with high tail $1$ keeps the same high tail after the paper image |
| active gate tests | for `n = 3`, `kappa = 7`, the forward gate has $M[40,8]=1$ and $M[4,8]=0$, and the dagger gate has $M^\dagger[8,40]=1$ |
| `bandedSparseAccessPaperCleanInput` | checks whether the padded-zero field in a basis column is actually clean, as required by Lemma 1 |
| `bandedSparseAccessPaperAddressInRange` | checks that the executable $r_{si}$ value fits in the n-bit paper address register |
| `bandedSparseAccessPaperImageNoSpill` | checks that the image preserves the high tail above the paper address register |
| `bandedSparseAccessPaperColumnContract` | records one column's clean-domain flag, image index, row-preservation check, address-write check, address-range check, no-spill check, and false obligations |

### Next Coordination Note

The wiring-level contract drift is resolved for the active O_D^BS gate pair.
The remaining gap is mathematical: Lean has not proved that the paper address
is always n-bit, that the image never spills into higher signal bits, that the
paper-image map is injective on the clean-input domain, that it extends
unitarily on non-clean padded-register columns, or that it is cleaned by the
dagger after SWAP.  The finite-image and entry bridge is proved only under the
explicit source-column and n-bit address hypotheses.  Keep the remaining claims
as explicit obligations before any block-extraction proof search.

Acceptance remains `python3 tools/qbe.py check` plus the semantic-gap grep from
the task contract.  The remaining parameter-family address/no-spill,
injectivity, forward correctness, and dagger cleanup claims stay as proof
obligations rather than hidden hypotheses.

### Completed Lower Packet: O_D^BS Contract Validation

The O_D^BS contract-validation packet is complete.  Compiled tests now confirm
that the active forward and dagger gates use the paper-image matrix
declarations by definitional equality, that the focused entries
$M[40,8]=1$, $M[4,8]=0$, and $M^\dagger[8,40]=1$ hold for $n=3$ and
$\kappa=7$, and that the paper-contract proof flags remain false.

| Item | Contract |
|---|---|
| Paper anchor | Guseynov-Huang-Liu 2025, Lemma 1 and Fig. 1-term Robin, arXiv:2506.20478 |
| Forward input registers | $|0\rangle^{n-l}|s\rangle^l|i\rangle^n$ inside the current O_D register block and row register |
| Forward output registers | $|r_{si}\rangle^n|i\rangle^n$ with the row register preserved |
| Clean ancilla condition | cleanup by $(O_D^{BS})^\dagger$ after SWAP remains unproved and must stay recorded as `daggerCleanup.proved = false` |
| Active forward matrix | `GHL2025.bandedSparseAccessPaperMatrix` |
| Active dagger matrix | `GHL2025.bandedSparseAccessPaperDaggerMatrix`, the transpose-style matrix using `bandedSparseAccessPaperImage` |
| Active forward gate | `GHL2025.oneTermRobinGate_O_D_BS.matrix = bandedSparseAccessPaperMatrix p` by definitional equality |
| Active dagger gate | `GHL2025.oneTermRobinGate_O_D_BS_dagger.matrix = bandedSparseAccessPaperDaggerMatrix p` by definitional equality |
| Remaining obligations | paper-level address-range and no-spill flags, injectivity on the finite domain, inverse-on-range for the dagger, and post-SWAP cleanup |

### Completed Middle Packet: O_D^BS Address Range and No-Spill Contract

This packet adds the missing Lean-facing contract requested by the cycle
handoff without changing the active matrices or promoting any proof flag.
`BandedSparseAccessPaperContract` now has `addressRange` and `noSpill`
obligations.  `BandedSparseAccessPaperColumnContract` records the executable
checks `addressInRange` and `imageNoSpill` for each basis column.  Focused
tests at $n=3$ and $\kappa=7$ confirm that the clean bulk column `j = 8`
passes both checks, while the corresponding obligations remain false.

| Item | Contract |
|---|---|
| Address range check | `GHL2025.bandedSparseAccessPaperAddressInRange p j` checks `bandedSparseAccessPaperAddress p j < 2^p.n` |
| High-tail extractor | `GHL2025.bandedSparseAccessPaperHighTail p j` is the signal/workspace tail above bits $[1+n,1+2n)$ |
| No-spill check | `GHL2025.bandedSparseAccessPaperImageNoSpill p j` checks that the high tail is preserved by `bandedSparseAccessPaperImage` |
| Contract fields | `addressRange.proved = false` and `noSpill.proved = false` in `defaultBandedSparseAccessPaperContract p` |
| Per-column audit | `(bandedSparseAccessPaperColumnContract p j).addressInRange` and `.imageNoSpill` mirror the executable checks by theorem |

### Completed Lower Packet: Block Projection and Normalizer Audit

The `block_projection_normalizer` packet is a structural contract audit for the
final one-term block-extraction target, not a proof of the block equation.
Compiled tests verify that the target uses the composed circuit product, signal
index $0$, system matrix `Examples.RobinHeat.robinDerivativeMatrix n`, and
normalizer `GHL2025.oneTermRobinNormalizer = N_DN_f\kappa`, with both block
obligations still unproved.

Cycle 1 lower added nonpromoting index-convention tests for
`signalSystemBlockProjection`.  The tests check that a nonzero signal index
shifts both the row and column by the selected signal block, and that
rectangular `rows` and `cols` use separate strides.  The 2026-05-23 lower
packet then named this convention in `CircuitSemantics.lean` as
`signalSystemBlockRowIndex` and `signalSystemBlockColIndex`, with finite-bound
lemmas used by `signalSystemBlockProjection_apply`.  These declarations record
the backend indexing convention only; they do not prove the Robin block
equation or promote `blockProjection` or `blockCorrect`.

| Item | Contract |
|---|---|
| Paper anchor | Guseynov-Huang-Liu 2025, Theorem 1-term Robin and Fig. 1-term Robin, arXiv:2506.20478 |
| Full-space matrix | `Examples.RobinHeat.oneTermRobinCircuitSemantics n`.matrix is `evalGateMatrices (GHL2025.oneTermRobinGateMatrixPlaceholders (Examples.RobinHeat.oneTermParameters n))` |
| Dimension split | `Examples.RobinHeat.oneTermRobinCircuitDimCompat n` proves $2^q = 2^m \cdot 2^n$ using the current signal/system convention |
| Signal register | `qubitDim (GHL2025.effectiveRobinSignalQubits (Examples.RobinHeat.oneTermParameters n))` |
| System register | `gridSize n`, with target matrix `Examples.RobinHeat.robinDerivativeMatrix n` |
| Projection convention | `signalSystemBlockProjection` extracts the `(0,0)` signal block of the cast circuit matrix using `signalSystemBlockRowIndex` and `signalSystemBlockColIndex` |
| Normalizer | `GHL2025.oneTermRobinNormalizer`, whose evaluation lemma is `GHL2025.oneTermRobinNormalizer_eval` |
| Clean ancilla status | O_D^BS dagger cleanup remains `(defaultBandedSparseAccessPaperContract p).daggerCleanup.proved = false` |
| Block obligations | `(oneTermRobinBlockExtractionTarget n).blockProjection.proved = false` and `(oneTermRobinBlockExtractionTarget n).blockCorrect.proved = false` |

The packet also pins `(defaultOneTermRobinCircuitBlockClaim n).target` to
`oneTermRobinBlockExtractionTarget n`, so downstream proof work cannot silently
replace the projection convention or normalizer.  It checks that
`(defaultBandedSparseAccessPaperContract (oneTermParameters n)).daggerCleanup`
remains false.  The only new theorem claims in
`QuantumBlockEncoding/CircuitSemantics.lean` are the finite-bound/apply lemmas
for the named projection indices; no semantic correctness flag changed.

Do not attempt full $n=3$ entry normalization of the composed
$8192 \times 8192$ product in routine tests.

**Column mapping** (fourth-order stencil, half-bandwidth $l=2$):

$$\mathrm{col}(s, i) = \begin{cases} i - 2 + s & K_1 \leq i \leq K_2 \text{ and } s < 5 \\ s & i = 0 \text{ and } s < 3 \\ s & i = 1 \text{ and } s < 4 \\ N - 4 + s & i = N - 2 \text{ and } s < 4 \\ N - 3 + s & i = N - 1 \text{ and } s < 3 \\ i & \text{otherwise (unused sparse index, identity)} \end{cases}$$

where $K_1 = 2$, $K_2 = 2^n - 3$, $N = 2^n$.

**Legacy helper matrix form**: the old helper is a permutation-style candidate on
$2^{\text{totalQubits}}$-dimensional space:

$$M[\text{image}(j)][j] = 1, \quad M[\text{other}][j] = 0$$

The image is computed by extracting system register (bits $[1, 1+n)$) and sparse index (bits $[1+n+\text{odPure}, 1+n+\text{odPure}+\text{clog2}(\kappa))$) from compound index $j$, computing $\mathrm{col}(s, i)$, and replacing the system register bits:

```text
image = j - (j & sysMask_shifted) + (col << 1)
```

**Concrete example** ($n=3, \kappa=7$, totalQubits=13):
- Bulk row $i=4$, $s=0$: col $= 2$. System register changes from 4 to 2.
- Bulk row $i=4$, $s=4$: col $= 6$. System register changes from 4 to 6.
- Boundary row $i=0$, $s=0$: col $= 0$ (identity).
- Boundary row $i=0$, $s=5$: unused, identity.

---

## (O_D^BS)^† Inverse Matrix (Cycle 4, Updated 2026-05-22)

For a permutation matrix $P$ where $P[\text{image}(j)][j] = 1$, the Hermitian
conjugate is the transpose: $P^\dagger[j][\text{image}(j)] = 1$.  The active
Lean implementation now applies this transpose-style construction to the
paper-image skeleton `bandedSparseAccessPaperImage`:
`bandedSparseAccessPaperDaggerMatrix p i j = 1` exactly when
`j.val = bandedSparseAccessPaperImage p i.val`.

This is an active matrix skeleton, not a proved inverse theorem.  The faithful
inverse-on-range statement, unitarity, and the cleanup condition for
$(O_D^{BS})^\dagger$ after SWAP remain proof obligations.

The legacy helper transpose `bandedSparseAccessDaggerMatrix` remains in Lean as
an implementation aid for old tests.  It is not the active paper-contract
dagger gate.

## Cycle 4 O_D^BS Tests

| Test | Parameters | Method | Status |
|---|---|---|---|
| Bulk row i=4, s=0 → col=2 | n=3, κ=7 | native_decide | proved |
| Bulk row i=4, s=4 → col=6 | n=3, κ=7 | native_decide | proved |
| Diagonal bulk i=3, s=2 → col=3 (identity) | n=3, κ=7 | native_decide | proved |
| Boundary row 0, s=0 → identity | n=3, κ=7 | native_decide | proved |
| Boundary row 0, s=5 unused → identity | n=3, κ=7 | native_decide | proved |
| Right boundary i=7, s=0 → col=5 | n=3, κ=7 | native_decide | proved |
| Dagger transpose (8,4) = 1 (inverse of forward (4,8)) | n=3, κ=7 | native_decide | proved |
| O_D^BS unitary.proved = false | n=3, κ=7 | rfl | proved |
| (O_D^BS)^† unitary.proved = false | n=3, κ=7 | rfl | proved |
| Placeholder match with honest O_D^BS | general p | theorem | proved |

---

## Sparse Amplitude Data Layer (Cycle 5)

The function `robinSparseAmplitudeValue` provides the s-th nonzero stencil coefficient for each row of the Robin derivative matrix as a `Coeff` value. This is the data layer shared by both O_DT^S (sparse amplitude oracle, Lemma 3) and Ry_boundary (boundary-controlled rotations).

The function mirrors the case structure of `robinSparseColumnMap` but returns coefficient values instead of column indices:

$$\text{amplitude}(s, i) = \begin{cases}
D_{i,i-2} = -1/12 & \text{bulk, } s=0 \\
D_{i,i-1} = 4/3 & \text{bulk, } s=1 \\
D_{i,i} = -5/2 & \text{bulk, } s=2 \\
D_{i,i+1} = 4/3 & \text{bulk, } s=3 \\
D_{i,i+2} = -1/12 & \text{bulk, } s=4 \\
0 & \text{bulk, } s \geq 5 \\
\text{boundary Coeff} & \text{boundary rows } 0, 1, N{-}2, N{-}1 \\
0 & \text{unused sparse index}
\end{cases}$$

Boundary row amplitudes include the Robin correction terms:
- Row 0, s=0: $-5/2 + (7/3) \cdot A_1 \Delta x$
- Row 1, s=0: $4/3 - (1/6) \cdot A_1 \Delta x$
- Row $N{-}2$, s=3: $4/3 + (1/6) \cdot B_1 \Delta x$
- Row $N{-}1$, s=2: $-5/2 - (7/3) \cdot B_1 \Delta x$

**Coherence property**: for all valid $n$, $s$, $i$:

$$\texttt{robinSparseAmplitudeValue}(n, s, i) = \texttt{robinDerivativeMatrix}(n)[i][\texttt{robinSparseColumnMap}(n, s, i)]$$

This is tested with `native_decide` for concrete instances.

## O_f Function Oracle Contract Audit

The paper's function oracle $O_f$ is the coefficient-function oracle for the
grid values $f(x_i)$, with normalization by $N_f$.  In the one-term Robin
normalizer this factor appears in

$$
\alpha = N_D N_f \kappa.
$$

The legacy Lean matrix declaration `GHL2025.functionOracleMatrix` is a Phase 1
function-value data helper.  For each compound basis state $|j\rangle$, it
extracts only the system register value $i$ and places the symbolic function
value on the diagonal:

```text
sysVal   = (j >>> 1) &&& ((1 <<< n) - 1)
M(j, j)  = robinFunctionValue n sysVal
M(i, j)  = 0  for i != j
```

This corrected the stale Cycle 6 transcript: `functionOracleMatrix` no longer
uses `robinSparseAmplitudeValue` and does not depend on the sparse-index
register.  It uses `robinFunctionValue n i = Coeff.symbol s!"f_{n}_{i}"`.

This helper matrix is not the paper's amplitude-oracle semantics.  The paper
coordinate-oracle contract maps the clean workspace branch as

$$
  |0\rangle^{m_f}|i\rangle
  \longmapsto
  \frac{f(x_i)}{N_f}|0\rangle^{m_f}|i\rangle
  + |\mathrm{orth}_f(i)\rangle,
$$

where the orthogonal component has zero overlap with the clean
$|0\rangle^{m_f}$ workspace branch.  Lean now records this paper-level target
as data in `FunctionOraclePaperRegisters`, `functionOraclePaperRegisters`,
`functionOracleNormalizedValue`, `FunctionOraclePaperImage`, and
`functionOraclePaperImage`.  The active gate now uses
`functionOraclePaperMatrix`: for clean $m_f$ input columns, it writes the
clean-branch amplitude `functionOracleNormalizedValue p i` at the clean $m_f$
branch row, sets other clean-workspace output rows to zero, and uses symbolic
`functionOracleOrthogonalEntry` entries for non-clean output rows.  For
non-clean input columns, all entries remain symbolic.  This is still a Phase 1
matrix skeleton, not a proof of the paper oracle.  Lean therefore keeps
`GHL2025.oneTermRobinGate_O_f.unitary.proved = false`, and the older
`FunctionOracleContract.amplitudeCorrect` obligation remains false in
`Examples.RobinHeat.robinOracleComposition`.

### O_f Source-Contract Audit Pane

| Field / obligation | Paper source | Lean target | Status |
|---|---|---|---|
| system grid register $i$ | Guseynov-Huang-Liu 2025, Theorem `Amplitude-oracle for piece-wise polynomial function` and Fig. 1-term Robin, arXiv:2506.20478 | bits $[1,1+n)$ via `functionOraclePaperRegisters`; also used by `functionOracleMatrix` | defined skeleton; concrete tests pass |
| clean function workspace $|0\rangle^{m_f}$ | coordinate-oracle equation and theorem resource line, arXiv:2506.20478 | `FunctionOraclePaperRegisters.mfWorkspaceValue`, `cleanWorkspace` | defined skeleton; cleanup/action proof unproved |
| function value data | Theorem `Amplitude-oracle for piece-wise polynomial function`, arXiv:2506.20478 | `GHL2025.robinFunctionValue p.n i` | symbolic data source defined |
| normalized clean-branch amplitude $f(x_i)/N_f$ | Theorem `Amplitude-oracle for piece-wise polynomial function`, coordinate-oracle equation, arXiv:2506.20478 | `functionOracleNormalizedValue`, `FunctionOraclePaperImage.cleanBranchAmplitude` | symbolic contract defined; division and bound unproved |
| paper-image matrix | Theorem `Amplitude-oracle for piece-wise polynomial function`, coordinate-oracle equation, arXiv:2506.20478 | `functionOraclePaperMatrix`, `oneTermRobinGate_O_f` | active skeleton wired; clean-input branch matrix entry pinned |
| orthogonal component | Theorem `Amplitude-oracle for piece-wise polynomial function`, coordinate-oracle equation, arXiv:2506.20478 | `FunctionOraclePaperImage.orthogonalComponent`, `functionOracleOrthogonalEntry`, `orthogonalComponentCorrect` | symbolic non-clean rows recorded; orthogonality proof false |
| normalizer $N_f$ | Theorem `Amplitude-oracle for piece-wise polynomial function` and theorem normalizer, arXiv:2506.20478 | `Coeff.symbol "N_f"` inside `GHL2025.oneTermRobinNormalizer` and `FunctionOracleContract.normalizerBound` | recorded; analytic bound unproved |
| legacy data helper | Fig. 1-term Robin, arXiv:2506.20478 | `GHL2025.functionOracleMatrix`, `FunctionOraclePaperImage.diagonalHelperIsolation` | helper retained; not the active gate |
| amplitude relation | Theorem `Amplitude-oracle for piece-wise polynomial function`, arXiv:2506.20478 | `FunctionOracleContract.amplitudeCorrect`, `RobinProofObligations.functionOracleCorrect` | unproved; must stay false |
| unitarity and clean workspace | Theorem `Amplitude-oracle for piece-wise polynomial function`, arXiv:2506.20478 | `oneTermRobinGate_O_f p`.unitary and a future $m_f$ workspace cleanup lemma | unproved; must stay false |

### O_f Proof-DAG Pane

The paper source for every row below is Guseynov-Huang-Liu 2025, Theorem
`Amplitude-oracle for piece-wise polynomial function`, Fig. 1-term Robin, and
the coordinate-oracle equation, arXiv:2506.20478.

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `of_extract_registers` | extract the system grid index, $m_f$ workspace value, and all non-$m_f$ bits from a compound basis index | register layout, `defaultRobinRegisterPartition`, `robinIndicatorBitPosition` | `FunctionOraclePaperRegisters`, `functionOraclePaperRegisters` | paper image, tests | O_f | defined skeleton; concrete tests pass |
| `of_function_values` | provide one symbolic value $f(x_i)$ per grid point | `of_extract_registers` | `robinFunctionValue` | normalized amplitude, final target $A_k$ | O_f | defined symbolic data |
| `of_normalized_value` | record the clean-branch amplitude as $f(x_i)/N_f$ without proving division or bounds | `of_function_values`, `FunctionOracleContract.normalizerBound` | `functionOracleNormalizedValue` using symbolic `N_f_inv` | paper image, amplitude contract | O_f | defined symbolic contract; proof false |
| `of_paper_image` | record the clean-workspace branch $|0\rangle^{m_f}|i\rangle \mapsto (f(x_i)/N_f)|0\rangle^{m_f}|i\rangle + |\mathrm{orth}_f(i)\rangle$ | `of_extract_registers`, `of_normalized_value` | `FunctionOraclePaperImage`, `functionOraclePaperImage` | paper matrix skeleton, block extraction | O_f | defined contract; proof flags false |
| `of_paper_matrix` | expose the clean branch for clean input columns, zero other clean-workspace output rows, and leave non-clean input/completion rows symbolic | `of_paper_image`, `of_orthogonal_component` | `functionOracleOrthogonalEntry`, `functionOraclePaperMatrix`, `oneTermRobinGate_O_f` | circuit product, block extraction | O_f | active skeleton wired; completion unproved |
| `of_external_amplitude_source` | record the cited GHL2025 theorem, Eq. `coordinate oracle`, arXiv:2411.01131 source, $N_f$ symbol, resource claim, and source-side false obligations | source audit row `GL2024.Thm5.AmplitudeOracle` | `FunctionOracleExternalAmplitudeSourceContract`, `functionOracleExternalAmplitudeSourceContract`, `functionOracleExternalAmplitudeSourceContract_sourceAnchor`, `functionOracleExternalAmplitudeSourceContract_flags_false` | amplitude route, cited-results audit | O_f | typed transcript compiled; no analytic flags promoted |
| `of_nf_amplitude_route` | package the source value $f(x_i)$, normalizer symbol $N_f$, clean-branch amplitude, exact Theorem 5/Eq. `coordinate oracle` source anchor, and theorem-level false obligations without proving analytic semantics | `of_paper_image`, `of_normalized_value`, `of_normalizer_bound`, `of_external_amplitude_source` | `FunctionOracleAmplitudeProofRoute`, `functionOracleAmplitudeProofRoute`, route bridge lemmas, `functionOracleAmplitudeProofRoute_sourceAnchor`, `functionOracleAmplitudeProofRoute_externalSourceContract`, `functionOracleAmplitudeProofRoute_flags_false` | `of_amplitude_contract`, final theorem audit | O_f | typed route compiled; all amplitude, division, normalizer, orthogonality, and unitarity flags false |
| `of_orthogonal_component` | state that the orthogonal component has zero clean-workspace overlap and preserves the system label required by the paper contract | `of_paper_image` | `FunctionOraclePaperImage.orthogonalComponentCorrect`, `systemPreserved`, `cleanWorkspaceBranch` | amplitude correctness, unitarity | O_f | recorded; orthogonality proof false |
| `of_normalizer_bound` | state and prove the $N_f$ bound needed for amplitudes | future coefficient/function semantics | `FunctionOracleContract.normalizerBound`, future bound theorem | amplitude relation, unitarity | O_f | recorded; proof missing |
| `of_diagonal_helper_isolation` | keep `functionOracleMatrix` helper-only so the diagonal data path is not mistaken for the coordinate-oracle theorem | `of_paper_image`, current tests | `functionOracleMatrix`, `FunctionOraclePaperImage.diagonalHelperIsolation` | source-contract audit | O_f | helper isolated; proof flag false |
| `of_amplitude_contract` | prove the paper amplitude relation and clean $m_f$ workspace | `of_nf_amplitude_route`, `of_orthogonal_component`, `of_normalizer_bound` | `FunctionOracleContract.amplitudeCorrect`, `RobinProofObligations.functionOracleCorrect` | final block extraction | O_f | unproved |

### Current O_f Tests

| Test | Parameters | Method | Status |
|---|---|---|---|
| Diagonal j=36 with sysVal=2 gives `Coeff.symbol "f_3_2"` | n=3, κ=7 | native_decide | proved |
| Diagonal j=0 with sysVal=0 gives `Coeff.symbol "f_3_0"` | n=3, κ=7 | native_decide | proved |
| Diagonal j=4 with the same sysVal=2 gives `Coeff.symbol "f_3_2"` | n=3, κ=7 | native_decide | proved |
| Off-diagonal entries are zero | n=3, κ=7 | native_decide | proved |
| `robinFunctionValue 3 i` yields the expected symbol for tested grid points | n=3 | native_decide | proved |
| `oneTermRobinGate_O_f p`.unitary.proved remains false | general p | rfl | proved |
| `oneTermRobinGate_O_f p`.matrix is `functionOraclePaperMatrix p` | general p | rfl | proved |
| `functionOracleMatrix p j j` equals `robinFunctionValue p.n sysVal` for extracted `sysVal` | general p, j | simp | proved |
| `functionOracleMatrix p i j = 0` when `i.val != j.val` | general p, i, j | simp | proved |
| `robinOracleComposition n`.functionOracle.normalizerBound is `Coeff.symbol "N_f"` | general n | rfl | proved |
| `robinOracleComposition n`.functionOracle.amplitudeCorrect.proved remains false | general n | rfl | proved |
| gate-list alignment still compiles with the active O_f skeleton | general p | theorem | proved |
| `functionOraclePaperRegisters p 36` extracts system value 2, clean $m_f$ workspace 0, and non-$m_f$ value 36 | n=3, κ=7 | native_decide | proved |
| nonclean `m_f` workspace extraction returns value 3 | n=3, κ=7 | native_decide | proved |
| `functionOracleNormalizedValue p 2` is `robinFunctionValue 3 2 * N_f_inv` | n=3, κ=7 | native_decide | proved |
| `functionOraclePaperImage p 36` preserves system value and clean branch basis index | n=3, κ=7 | native_decide | proved |
| `functionOraclePaperImage p j` paper-image obligations remain false | general p, j | rfl | proved |
| `functionOraclePaperImage_*_eq` bridge lemmas expose input registers, clean branch basis, system value, workspace value, amplitude, and clean-workspace flag | general p, j | rfl theorem reuse | proved |
| `functionOraclePaperMatrix p 36 36 = f_3_2 * N_f_inv` | n=3, κ=7 | native_decide | proved |
| active O_f gate exposes the same clean-branch entry | n=3, κ=7 | native_decide | proved |
| clean-workspace off-branch row 4 has zero entry against column 36 | n=3, κ=7 | native_decide | proved |
| non-clean row 772 against column 36 carries `orth_f_entry_3_2_772_36` | n=3, κ=7 | native_decide | proved |
| non-clean input column 772 at its clean-branch basis row 4 still carries `orth_f_entry_3_2_4_772` | n=3, κ=7 | native_decide | proved |
| `functionOraclePaperMatrix_*` bridge lemmas pin clean-input branch, clean-workspace zero rows, and non-clean input symbolic entries | general p, i, j | theorem reuse | proved |
| `functionOracleExternalAmplitudeSourceContract_*` bridge lemmas pin the cited theorem source anchor and source-side false flags | global contract | theorem reuse | proved |
| `functionOracleAmplitudeProofRoute_*` bridge lemmas pin the Theorem 5/Eq. `coordinate oracle` source anchor, source value, normalized amplitude, $N_f$, clean-branch reuse, external-source reuse, and obligation reuse | general p, j | theorem reuse | proved |
| `functionOracleAmplitudeProofRoute_flags_false` keeps route flags false | general p, j | theorem reuse | proved |
| route `theoremNormalizer` equals Robin default `functionOracle.normalizerBound` | general n | rfl | proved |
| route for column 36 records `f_3_2` and `f_3_2 * N_f_inv` | n=3, κ=7 | native_decide | proved |

### Completed Lower Packet: O_f Paper Image Contract

The fixed block `of_paper_image` plus `of_diagonal_helper_isolation` has now
been captured in Lean.  The implementation stayed in
`QuantumBlockEncoding/GHL2025.lean` with focused tests in `Tests/Basic.lean`.
It did not edit SWAP, O_D^BS, O_DT^S, Ry_boundary, the circuit product, or
block extraction.  It did not promote `oneTermRobinGate_O_f.unitary`,
`FunctionOracleContract.amplitudeCorrect`, or
`RobinProofObligations.functionOracleCorrect`.

The synchronized Lean declarations are:

```lean
structure FunctionOraclePaperRegisters where
def functionOraclePaperRegisters (p : OneTermRobinParameters) (j : Nat) :
  FunctionOraclePaperRegisters
def functionOracleNormalizedValue (p : OneTermRobinParameters) (i : Nat) : Coeff
structure FunctionOraclePaperImage where
def functionOraclePaperImage (p : OneTermRobinParameters) (j : Nat) :
  FunctionOraclePaperImage
theorem functionOraclePaperImage_inputRegisters_eq
theorem functionOraclePaperImage_cleanBranchBasisIndex_eq
theorem functionOraclePaperImage_cleanBranchSystemValue_eq
theorem functionOraclePaperImage_cleanBranchWorkspaceValue_eq
theorem functionOraclePaperImage_cleanBranchAmplitude_eq
theorem functionOraclePaperImage_cleanWorkspaceBranch_eq
def functionOracleOrthogonalEntry
def functionOraclePaperMatrix
theorem functionOraclePaperMatrix_cleanBranch_entry
theorem functionOraclePaperMatrix_cleanWorkspace_offBranch_zero
theorem functionOraclePaperMatrix_nonCleanInput_entry
```

The register extractor should use system bits $[1,1+n)$ and $m_f$ bits starting
at `robinIndicatorBitPosition p + 1`.  The normalized value records
`robinFunctionValue p.n i` times a symbolic reciprocal for $N_f$; this is a
contract placeholder, not a proof that $N_f$ is nonzero.  The paper image
record includes the clean-workspace branch amplitude, an orthogonal-component
label, and false obligations for the $f(x_i)/N_f$ relation, orthogonality to
the clean workspace, normalizer bound, unitary completion, and diagonal helper
isolation.

Completed tests:

| Target | Expected result |
|---|---|
| register extraction | for `n=3`, `kappa=7`, a clean-workspace column with system value `2` extracts system `2` and `mfWorkspaceValue = 0` |
| normalized value | the same row records `Coeff.mul (robinFunctionValue 3 2) (Coeff.symbol "N_f_inv")`, or the exact symbol chosen by the new declaration |
| paper image | clean branch preserves the system value and records the normalized clean-branch amplitude |
| false obligations | every new `FunctionOraclePaperImage` obligation has `proved = false` |
| diagonal helper isolation | `functionOracleMatrix` is explicitly documented in Lean as helper-only and is no longer the active gate |
| active paper matrix | `oneTermRobinGate_O_f` is definitionally wired to `functionOraclePaperMatrix` |
| clean branch matrix entry | `functionOraclePaperMatrix` returns `functionOracleNormalizedValue` on the clean branch for clean input columns |
| unresolved completion | non-clean rows use symbolic `functionOracleOrthogonalEntry` entries |
| non-clean input guard | `functionOraclePaperMatrix_nonCleanInput_entry` keeps every non-clean input column symbolic, even at the clean-branch basis row |
| no proof search | no SWAP, O_D^BS, O_DT^S, Ry_boundary, or block-product proof work in this packet |
| bridge validation | the paper-image record fields reduce definitionally to the register extractor and normalized-value declarations |

### Completed Lower Packet: O_f Bridge Validation

This lower packet added only `rfl` bridge lemmas in
`QuantumBlockEncoding/GHL2025.lean` plus tests in `Tests/Basic.lean`.  The
bridge lemmas state that, for every parameter record and basis column, the
paper-image record reuses `functionOraclePaperRegisters`, sets the clean branch
basis to the non-$m_f$ index, preserves the extracted system value, sets the
clean branch workspace value to zero, and uses `functionOracleNormalizedValue`
at the extracted system value.  The packet did not rewire
`oneTermRobinGate_O_f`, did not change `functionOracleMatrix`, and did not
promote any `FunctionOraclePaperImage` obligation.  The later middle packet
above rewired `oneTermRobinGate_O_f` to `functionOraclePaperMatrix`; all O_f
proof flags remain false.

### Next Reviewer Packet

Audit only the O_f paper-matrix rewire and the synchronized proof map:

| Target | Expected result |
|---|---|
| active gate | `oneTermRobinGate_O_f` uses `functionOraclePaperMatrix` |
| clean branch | clean branch entry is `FunctionOraclePaperImage.cleanBranchAmplitude` for clean input columns |
| clean workspace zero rows | non-branch output rows with clean $m_f$ workspace are zero for clean input columns |
| unresolved completion | non-clean rows and non-clean input columns remain symbolic through `functionOracleOrthogonalEntry` |
| proof flags | no amplitude, normalizer, orthogonality, or unitarity obligation was promoted |

### 2026-05-23 Middle Lower Packet: O_f $N_f$ Amplitude Route

The source-contract audit now blocks `O_D^BS` proof search on the unused
zero-amplitude sparse branches, while the shared $N_D$ source-bound bridges for
`O_{D^T}^S` and `R_y^{boundary}` have been added.  The next faithful Phase 1
packet should stay on the O_f transcript and record the $N_f$ amplitude route
without changing the active matrix.

Definitions to reuse:

| Paper object | Lean anchor | Status |
|---|---|---|
| $f(x_i)$ | `robinFunctionValue p.n i` | symbolic function-value source |
| $f(x_i)/N_f$ | `functionOracleNormalizedValue p i` | symbolic `N_f_inv` stand-in |
| clean branch | `functionOraclePaperImage p j` | paper-image record already wired |
| active O_f matrix | `functionOraclePaperMatrix p` | do not change |
| paper normalizer $N_f$ | `(Examples.RobinHeat.robinOracleComposition n).functionOracle.normalizerBound` | `Coeff.symbol "N_f"` |
| amplitude and completion flags | `normalizedAmplitudeCorrect`, `orthogonalComponentCorrect`, `normalizerBound`, `unitaryCompletion`, `FunctionOracleContract.amplitudeCorrect` | all remain false |

Lower-facing contract:

| Field | Contract |
|---|---|
| block interface | `of_nf_amplitude_route` records how the clean-branch amplitude, normalizer symbol, and false obligations flow from the O_f paper image into the theorem-level function-oracle obligation |
| planned Lean names | `FunctionOracleExternalAmplitudeSourceContract`, `functionOracleExternalAmplitudeSourceContract`, `FunctionOracleAmplitudeProofRoute`, `functionOracleAmplitudeProofRoute`, and bridge theorems to the existing O_f declarations |
| allowed edits | `QuantumBlockEncoding/GHL2025.lean`, focused tests in `Tests/Basic.lean`, and this proof map if Lean declarations are added |
| forbidden edits | no new function-value source, no replacement O_f matrix, no proof of $N_f$ nonzero/division/bounds, no orthogonality or unitarity promotion, and no `O_D^BS` proof search |
| build gate | `python3 tools/qbe.py check` with all O_f proof flags still false |

### Completed Middle Packet: O_f $N_f$ Amplitude Route

This cycle compiled the fixed `of_nf_amplitude_route` interface without
changing `functionOraclePaperMatrix` or any active gate.  The route reuses the
paper-image record and packages the exact data needed for the future
amplitude-correctness proof:

| Accepted item | Lean declaration | Status |
|---|---|---|
| external source transcript | `FunctionOracleExternalAmplitudeSourceContract`, `functionOracleExternalAmplitudeSourceContract` | records GHL2025 Theorem `Amplitude-oracle for piece-wise polynomial function`, Eq. `coordinate oracle`, the cited source arXiv:2411.01131, the $N_f$ symbol, the clean-branch formula, the resource claim, and false source-side obligations |
| source transcript guard | `functionOracleExternalAmplitudeSourceContract_sourceAnchor`, `functionOracleExternalAmplitudeSourceContract_flags_false` | pins the source anchor and keeps the cited resource claim, external theorem formalization, nonzero $N_f$, division semantics, theorem amplitude correctness, and all closure booleans false |
| route record | `FunctionOracleAmplitudeProofRoute` | defined |
| default route | `functionOracleAmplitudeProofRoute p j` | reuses `functionOraclePaperImage p j`, `robinFunctionValue`, `functionOracleNormalizedValue`, the `N_f` symbol, and the exact Theorem 5/Eq. `coordinate oracle` source anchor |
| source-anchor guard | `functionOracleAmplitudeProofRoute_sourceAnchor` | proved by definitional equality; records the cited source arXiv:2411.01131 without using it to close a proof flag |
| source-value bridge | `functionOracleAmplitudeProofRoute_sourceFunctionValue` | proved by definitional equality |
| normalized-amplitude bridge | `functionOracleAmplitudeProofRoute_normalizedAmplitude` | proved by definitional equality |
| normalizer bridge | `functionOracleAmplitudeProofRoute_normalizerNf` and test against `(Examples.RobinHeat.robinOracleComposition n).functionOracle.normalizerBound` | proved |
| paper-image reuse | `functionOracleAmplitudeProofRoute_paperImage`, `functionOracleAmplitudeProofRoute_obligations_reuse_paperImage` | proved; no duplicated O_f image contract |
| external-source reuse | `functionOracleAmplitudeProofRoute_externalSourceContract` | proved; route source anchor, $N_f$ symbol, normalized-amplitude formula, nonzero-normalizer obligation, division obligation, and theorem-amplitude obligation come from the external source transcript |
| false-flag guard | `functionOracleAmplitudeProofRoute_flags_false` | proves nonzero $N_f$, division semantics, normalizer bound, orthogonality, unitary completion, and theorem amplitude correctness remain false |

Source-dependency classification: `external-cited-result` for the
piece-wise-polynomial amplitude-oracle theorem cited by GHL2025, with QBE
status still `contract-only` through `GHL2025.Lemma4.Of` and
`obligation` through `GL2024.Thm5.AmplitudeOracle`.  No state-preparation
theorem, function-oracle bound, or orthogonal-completion theorem is used to
close a Lean proof flag in this packet.

---

### Cycle 5 Tests

| Test | Parameters | Method | Status |
|---|---|---|---|
| Bulk diagonal s=2, i=2 = -5/2 | n=3 | native_decide | proved |
| Bulk off-diagonal s=0, i=2 = -1/12 | n=3 | native_decide | proved |
| Bulk off-diagonal s=1, i=3 = 4/3 | n=3 | native_decide | proved |
| Left boundary row 0, s=0 = -5/2 + 7/3·A1·dx | n=3 | native_decide | proved |
| Left boundary row 0, s=1 = 8/3 | n=3 | native_decide | proved |
| Left boundary row 1, s=0 = 4/3 - 1/6·A1·dx | n=3 | native_decide | proved |
| Left boundary row 1, s=1 = -31/12 | n=3 | native_decide | proved |
| Right boundary row 6, s=3 = 4/3 + 1/6·B1·dx | n=3 | native_decide | proved |
| Right boundary row 7, s=2 = -5/2 - 7/3·B1·dx | n=3 | native_decide | proved |
| Unused sparse index s=5, i=2 = 0 | n=3 | native_decide | proved |
| Unused sparse index s=3, i=0 = 0 | n=3 | native_decide | proved |
| Coherence: bulk s=2, i=2 | n=3 | native_decide | proved |
| Coherence: left boundary s=0, i=0 | n=3 | native_decide | proved |
| Coherence: right boundary s=2, i=7 | n=3 | native_decide | proved |
| Coherence: left boundary s=0, i=1 | n=3 | native_decide | proved |
| Coherence: right boundary s=3, i=6 | n=3 | native_decide | proved |

---

## O_DT^S Controlled-Rotation Skeleton and Legacy Diagonal Helper

Cycle 7 introduced `GHL2025.sparseAmplitudeOracleDTMatrix`, a diagonal helper
that exercises the sparse-amplitude data path:

```text
indBit = (j >>> (1 + 2*n)) & 1
if indBit == 0: M(j, j) = 1
if indBit == 1: M(j, j) = robinSparseAmplitudeValue n sparseVal sysVal
M(i, j) = 0 for i != j
```

That helper remains available for coefficient-data tests, but it is no longer
the active `O_DT^S` gate matrix.  The active gate now uses
`GHL2025.sparseAmplitudeOracleDTRotationMatrix`, which preserves all
non-ancilla bits and applies a symbolic two-by-two block on ancilla bit 0 when
the indicator bit is 1.

Lemma 3 of Guseynov-Huang-Liu 2025, Eq. (20), states the sparse-amplitude
oracle contract in the form

$$
\hat O_D^S |0\rangle |s\rangle
=
\frac{D^{(s)}}{N_D}|0\rangle |s\rangle
+
\sqrt{1-\frac{|D^{(s)}|^2}{N_D^2}}|1\rangle |s\rangle.
$$

For the one-term Robin circuit, the same contract is used for $D^T$ and the
row-dependent coefficient source is
`GHL2025.robinSparseAmplitudeValue p.n sparseVal rowVal`.

### Source-Contract Audit

| Register / value | Lean extraction | Required action | Status |
|---|---|---|---|
| ancilla bit | bit 0 of the compound index | only this bit may change under the active rotation skeleton | defined in `sparseAmplitudeOracleDTPaperRegisters` |
| system row $j$ | bits $[1,1+n)$ | supplies the derivative row index | defined in `sparseAmplitudeOracleDTPaperRegisters` |
| padded sparse register | bits $[1+n,1+2n)$, with sparse index in the high `clog2 p.kappa` subfield | supplies $s$ | defined in `sparseAmplitudeOracleDTPaperRegisters` |
| indicator bit | `GHL2025.robinIndicatorBitPosition p` | if 0, act as identity; if 1, apply the sparse-amplitude rotation | defined and tested |
| derivative coefficient | `GHL2025.robinSparseAmplitudeValue p.n sparseVal rowVal` | symbolic value for $D_j^{(s)}$ before the $N_D$ normalizer is discharged | data helper defined |
| rotation entries | `sparseAmplitudeOracleDTCosHalf`, `sparseAmplitudeOracleDTSinHalf` | represent the two symbolic entries of the ancilla rotation block | defined; Eq. (20) relation unproved |
| coefficient-normalizer contract | `GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerContract`, `GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerObligation` | bind the symbolic entries to `robinSparseAmplitudeValue`, $N_D$, $D_j^{(s)}/N_D$, and the complementary normalizer term from Eq. (20) | typed contract recorded; proof fields remain `proved := false` |
| coefficient-normalizer proof route | `GHL2025.sparseAmplitudeOracleDTNormalizedCoefficient`, `GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute` | expose the formal $D_j^{(s)}/N_D$ stand-in and the remaining $N_D$-bound, absolute-square, square-root complement, and unitarity proof blocks | typed route recorded; proof fields remain `proved := false` |
| active gate matrix | `GHL2025.oneTermRobinGate_O_DT_S` | use `sparseAmplitudeOracleDTRotationMatrix` instead of the diagonal helper | rewired by definitional equality |

The symbol names `odts_cos_half_{row}_{sparse}` and
`odts_sin_half_{row}_{sparse}` are implementation placeholders.  They do not
prove that the $|0\rangle$ amplitude is $D_j^{(s)}/N_D$, that the
complementary amplitude is the square-root term from Eq. (20), or that the
completed two-by-two block is unitary.

### O_DT^S Proof-DAG Pane

| Block | Interface | Paper source | Lean declaration | Depends on | Reused by | Status |
|---|---|---|---|---|---|---|
| `odts_extract_registers` | extract ancilla bit, indicator bit, row value, sparse-index value, and non-ancilla rest bits from a compound basis index | Lemma 3 and Fig. 1-term Robin, arXiv:2506.20478 | `SparseAmplitudeOracleDTPaperRegisters`, `sparseAmplitudeOracleDTPaperRegisters` | `defaultRobinRegisterPartition`, `robinIndicatorBitPosition` | rotation matrix entries, active gate tests | defined skeleton; concrete tests pass |
| `odts_rotation_entries` | define symbolic rotation entries controlled by the sparse coefficient while preserving all non-ancilla bits | Lemma 3, Eq. (20), arXiv:2506.20478 | `sparseAmplitudeOracleDTCosHalf`, `sparseAmplitudeOracleDTSinHalf`, `sparseAmplitudeOracleDTRotationMatrix` | `odts_extract_registers`, `robinSparseAmplitudeValue` | `oneTermRobinGate_O_DT_S`, block extraction | active skeleton; coefficient relation unproved |
| `shared_nd_normalizer` | record the shared normalized coefficient $D_j^{(s)}/N_D$ and the common nonzero, division, coefficient-bound, absolute-square, square-root, arccos, and two-by-two-unitary obligations | Lemma 3, Eq. (20), and boundary Ry equations, arXiv:2506.20478 | `DerivativeNormalizerNDContract`, `derivativeNormalizerNDContract`, `DerivativeNormalizerNDSourceBound`, `derivativeNormalizerNDSourceBound` | `robinSparseAmplitudeValue` | `odts_coeff_normalizer`, `ryb_angle_normalizer` | typed contract recorded; source-bound view proved by definitional bridges; all analytic proof flags false |
| `odts_coeff_normalizer` | prove the symbolic entries match $D_j^{(s)}/N_D$ and the complementary normalizer term from Eq. (20) | Lemma 3, Eq. (20), arXiv:2506.20478 | `sparseAmplitudeOracleDTCoefficientNormalizerContract`, `sparseAmplitudeOracleDTNormalizedCoefficient`, `sparseAmplitudeOracleDTCoefficientNormalizerProofRoute`, `sparseAmplitudeOracleDTCoefficientNormalizerObligation` | `shared_nd_normalizer`, future absolute-square/square-root semantics | `odts_rotation_unitary`, block extraction | typed contract and proof route recorded; shared $N_D$ bridges proved; analytic identities unproved |
| `odts_active_gate_rewire` | active gate matrix is definitionally equal to the rotation skeleton, not the diagonal helper | Fig. 1-term Robin, arXiv:2506.20478 | `oneTermRobinGate_O_DT_S` | `odts_rotation_entries` | circuit product, block target | proved by `rfl` |
| `odts_rotation_unitary` | prove the symbolic two-by-two blocks are unitary under the paper normalizer bound | Lemma 3, Eq. (20), arXiv:2506.20478 | gate `unitary` field and future theorem | `odts_coeff_normalizer` | final gate unitarity | unproved; `unitary.proved = false` |

### Completed Lower Packet: O_DT^S Controlled-Rotation Skeleton

The lower packet added the register extraction, symbolic entry helpers, and
rotation matrix in `QuantumBlockEncoding/GHL2025.lean`, with focused examples
in `Tests/Basic.lean`.  It did not change `unitary.proved`.

| Test | Parameters | Method | Status |
|---|---|---|---|
| legacy diagonal helper still computes boundary identity | `n=3`, `kappa=7`, column 4 | `native_decide` | proved |
| legacy diagonal helper still computes bulk coefficient | `n=3`, `kappa=7`, column 132 | `native_decide` | proved |
| active gate equality | general `p` | `rfl` | proved |
| register extraction: indicator, row, sparse index | `n=3`, `kappa=7`, column 132 | `native_decide` | proved |
| bulk symbolic $|0\rangle$ entry | `n=3`, `kappa=7`, row 132, column 132 | `native_decide` | `odts_cos_half_2_0` |
| bulk symbolic $|1\rangle$ entry | `n=3`, `kappa=7`, row 133, column 132 | `native_decide` | `odts_sin_half_2_0` |
| boundary identity | `n=3`, `kappa=7`, row 4, column 4 | `native_decide` | `Coeff.rat 1` |
| boundary no ancilla flip | `n=3`, `kappa=7`, row 5, column 4 | `native_decide` | `Coeff.rat 0` |
| active proof flag | general `p` | `rfl` | `(oneTermRobinGate_O_DT_S p).unitary.proved = false` |
| coefficient-normalizer proof flag | global obligation | `rfl` | `sparseAmplitudeOracleDTCoefficientNormalizerObligation.proved = false` |

### Lower Packet: Eq. (20) Contract Promotion

This packet promoted `odts_coeff_normalizer` from a single global flag to a
typed per-row contract.  The new
`GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerContract p row sparse`
records the sparse derivative coefficient, the $N_D$ normalizer symbol, the
two active rotation entries, and three unproved obligations:

| Field | Meaning | Status |
|---|---|---|
| `coefficient` | `robinSparseAmplitudeValue p.n sparse row`, the Lean source for $D_j^{(s)}$ | defined |
| `normalizerND` | the paper normalizer symbol $N_D$ | defined |
| `ketZeroEntry` | `sparseAmplitudeOracleDTCosHalf row sparse`, intended to encode $D_j^{(s)}/N_D$ | defined; relation unproved |
| `ketOneEntry` | `sparseAmplitudeOracleDTSinHalf row sparse`, intended to encode the Eq. (20) square-root term | defined; relation unproved |
| `coefficientRelation` | prove the $|0\rangle$ entry equals $D_j^{(s)}/N_D$ | `proved := false` |
| `complementRelation` | prove the $|1\rangle$ entry equals $\sqrt{1-|D_j^{(s)}|^2/N_D^2}$ | `proved := false` |
| `twoByTwoUnitary` | prove the resulting two-by-two block is unitary under the $N_D$ bound | `proved := false` |

Focused tests pin the contract at $n=3$, $\kappa=7$, row $2$, sparse index
$0$: the coefficient is $-1/12$, the normalizer is `N_D`, and the active
symbols are `odts_cos_half_2_0` and `odts_sin_half_2_0`.

Do not promote the O_DT^S gate unitarity flag until `odts_coeff_normalizer` is
replaced by a Lean theorem or a finer obligation record that states the paper's
$N_D$ bound and Eq. (20) amplitude identities.

### Middle Packet: Eq. (20) Proof-Route Refinement

The refined route keeps the same paper contract and adds no new gate behavior.
The declaration
`GHL2025.sparseAmplitudeOracleDTNormalizedCoefficient p row sparse` records the
formal stand-in
`robinSparseAmplitudeValue p.n sparse row * N_D_inv` for $D_j^{(s)}/N_D$.
The declaration
`GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse`
then splits the remaining analytic work into fixed proof blocks:

| Field | Meaning | Status |
|---|---|---|
| `normalizedCoefficient` | symbolic stand-in for $D_j^{(s)}/N_D$ | defined |
| `coefficientDivision` | interpret the stand-in as division by $N_D$ | `proved := false` |
| `normalizerBound` | prove the $N_D$ bound needed by Eq. (20) | `proved := false` |
| `absSquareSemantics` | interpret $|D_j^{(s)}|^2/N_D^2$ | `proved := false` |
| `sqrtComplementSemantics` | prove the $|1\rangle$ entry equals $\sqrt{1-|D_j^{(s)}|^2/N_D^2}$ | `proved := false` |
| `twoByTwoUnitary` | reuse the contract's two-by-two unitarity obligation | `proved := false` |

Focused tests pin the normalized coefficient at $n=3$, $\kappa=7$, row $2$,
sparse index $0$ to
`Coeff.mul (Coeff.rat (-1/12)) (Coeff.symbol "N_D_inv")` and check each new
proof-route flag is false.

Lower cycle 15 added field-alignment lemmas showing that the proof route
reuses the per-row contract's `normalizerND`, `ketZeroEntry`, and
`ketOneEntry` fields.  These are definitional bridges only; the division,
$N_D$ bound, square-root complement, and unitarity flags remain false.

Cycle 16 added the shared declaration
`GHL2025.derivativeNormalizerNDContract p row sparse`.  The `O_DT^S` proof
route now takes its division, $N_D$-bound, absolute-square, and square-root
obligation records from that shared contract.  The bridge theorem
`GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_sharedND`
checks this reuse without promoting any analytic proof flag.

Lower cycle 16 added the source-bound view
`GHL2025.derivativeNormalizerNDSourceBound p row sparse`.  It records the
future bound formula $|D_j^{(s)}| \le N_D$ using source coefficient
`robinSparseAmplitudeValue p.n sparse row` and normalizer `Coeff.symbol "N_D"`.
The Lean bridge
`GHL2025.derivativeNormalizerNDSourceBound_coefficientBound` proves that the
view reuses the shared `coefficientBound` obligation, and
`GHL2025.derivativeNormalizerNDSourceBound_coefficientBound_false` keeps the
bound flag false.

### Cycle 17 Middle Packet: Shared $N_D$ Source-Contract Audit

The current upper decision blocks more $O_D^{BS}$ cleanup proof search until a
paper-backed unused-branch image rule or an exact reversible-extension theorem
is supplied.  The active Phase 1 target therefore moves to the shared
normalizer transcript used by $O_{D^T}^S$ and
$R_y^{\mathrm{boundary}}$.

Definition.  The shared coefficient source for both routes is
`GHL2025.robinSparseAmplitudeValue p.n sparse row`.  The shared normalizer
symbol is `Coeff.symbol "N_D"`, and the shared normalized-coefficient stand-in
is the formal `N_D_inv` product used by
`GHL2025.derivativeNormalizerNDContract p row sparse`.

The audit fixes the source-to-Lean contract as follows.

| Proof-DAG block | Paper anchor | Lean declaration | Consumers | Required status |
|---|---|---|---|---|
| `shared_nd_coefficient_source` | Lemma 3, Eq. (20), and boundary $R_y$ equations, arXiv:2506.20478 | `derivativeNormalizerNDContract_coefficient`, `derivativeNormalizerNDSourceBound_sourceCoefficient`, `sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_sourceBound`, `boundaryRotationAngleNormalizerProofRoute_sourceBound`, `derivativeNormalizerNDSourceBound_sharedRoutes` | `odts_coeff_normalizer`, `ryb_angle_normalizer` | definitional bridge only |
| `shared_nd_formal_division` | Lemma 3, Eq. (20), arXiv:2506.20478 | `DerivativeNormalizerNDContract.divisionSemantics`, `sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_sharedND`, `boundaryRotationAngleNormalizerProofRoute_sharedND` | Eq. (20) $|0\rangle$ entry and boundary arccos argument | `proved = false` |
| `shared_nd_bound` | Lemma 3, Eq. (20), and boundary $R_y$ equations, arXiv:2506.20478 | `DerivativeNormalizerNDSourceBound`, `derivativeNormalizerNDSourceBound_coefficientBound_false` | square-root complement, arccos domain, two-by-two unitarity | `proved = false` |
| `shared_nd_abs_sqrt` | Lemma 3, Eq. (20), arXiv:2506.20478 | `DerivativeNormalizerNDContract.absSquareSemantics`, `DerivativeNormalizerNDContract.sqrtComplementSemantics` | `O_{D^T}^S` complementary amplitude | `proved = false` |
| `shared_nd_arccos` | boundary $R_y$ angle equations, arXiv:2506.20478 | `DerivativeNormalizerNDContract.arccosSemantics` | `Ry_boundary` arccos argument | `proved = false` |

Lower cycle 17 packet:

| Item | Instruction |
|---|---|
| Target block | one bridge/test packet for `shared_nd_coefficient_source` and false-flag preservation |
| Allowed Lean files | `QuantumBlockEncoding/GHL2025.lean`, `Tests/Basic.lean` |
| Allowed docs | `conversion-windows/QBE-AUTO-002.md`, `proof-obligations/QBE-AUTO-002.md`, `paper-notes/GHL2025_RobinOneTerm.tex`, `research-wiki/cited-results/GHL2025.md` |
| Required bridges | add only definitional field bridges tying `DerivativeNormalizerNDContract` and `DerivativeNormalizerNDSourceBound` to the existing $O_{D^T}^S$ and $R_y$ proof-route records, if a bridge is missing |
| Forbidden work | no analytic proof of nonzero $N_D$, division, coefficient bounds, absolute-square, square-root, arccos, half-angle, two-by-two unitarity, and no $O_D^{BS}$ cleanup or block-extraction work |
| Acceptance | `python3 tools/qbe.py check`; grep guard from the task contract; all shared normalizer and route proof flags remain `proved = false` |

Lower cycle 17 adds the missing source-bound bridges
`sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_sourceBound`,
`boundaryRotationAngleNormalizerProofRoute_sourceBound`, and
`derivativeNormalizerNDSourceBound_sharedRoutes`.  They prove only definitional
field reuse for the coefficient, $N_D$ symbol, and shared bound-obligation
record; the analytic proof flags remain false.

### Current Middle Sync: Shared $N_D$ Guard

Middle re-read the source anchors for GHL2025 Lemma 3, Eq. (20), the
boundary-angle equation for $R_y$, and Fig. 1-term Robin.  The source contains
the same normalizer symbol $N_D$ in both routes and states the bound
$N_D \geq \|D\|_{\max}$, but it does not by itself provide Lean semantics for
nonzero division, absolute values, square roots, arccos, or two-by-two
unitarity.

The new Lean guard
`GHL2025.derivativeNormalizerNDSharedRoute_flags_false` packages the existing
route synchronization and proves that every shared analytic flag remains
`false`.  It also records that both
`GHL2025.oneTermRobinGate_O_DT_S.unitary.proved` and
`GHL2025.oneTermRobinGate_Ry_boundary.unitary.proved` remain `false`.

Proof-translation map:

| Source step | Classification | Lean anchor | Status |
|---|---|---|---|
| Eq. (20) $|0\rangle$ amplitude is $D^{(s)}/N_D$ | internal-paper-step plus symbolic contract | `sparseAmplitudeOracleDTCoefficientNormalizerProofRoute`, `derivativeNormalizerNDContract` | route typed; division flag false |
| Eq. (20) complementary term is $\sqrt{1-|D^{(s)}|^2/N_D^2}$ | classical analytic lemma needed later | `DerivativeNormalizerNDContract.absSquareSemantics`, `DerivativeNormalizerNDContract.sqrtComplementSemantics` | `proved = false` |
| Boundary angle $\theta_j^s=\arccos(D_j^{(s)}/N_D)$ | internal-paper-step plus classical analytic lemma | `boundaryRotationAngleNormalizerProofRoute`, `DerivativeNormalizerNDContract.arccosSemantics` | route typed; arccos flag false |
| Shared bound $N_D \geq \|D\|_{\max}$ | source-bound obligation | `DerivativeNormalizerNDSourceBound.coefficientBound` | `proved = false` |
| Gate unitarity for $O_{D^T}^S$ and $R_y^{\mathrm{boundary}}$ | downstream proof obligation | `derivativeNormalizerNDSharedRoute_flags_false` | gate flags false |

Lower-agent packet:

| Field | Instruction |
|---|---|
| fixed target | no further Lean proof search on this shared $N_D$ packet unless a reviewer requests another guard theorem |
| allowed follow-up | move to the next Phase 1 transcript block selected by upper, with the same false-flag discipline |
| forbidden work | no $O_D^{BS}$ cleanup/unitarity search; no analytic proof of division, bounds, square roots, arccos, half-angle identities, or gate unitarity from this guard |

### O_f vs O_DT^S Double Encoding Audit (Resolved in Cycle 9)

**Finding (cycle 7):** Both `functionOracleMatrix` (O_f, cycle 6) and `sparseAmplitudeOracleDTMatrix` (O_DT^S, cycle 7) were using `robinSparseAmplitudeValue` as their diagonal data source. In the paper, these encode completely different quantities.

**Fix (cycle 9 and 2026-05-22 follow-up):** O_f now uses `robinFunctionValue`
(symbolic $f(x_j)$), while the O_DT^S data path continues to use
`robinSparseAmplitudeValue` (derivative stencil data).  The active O_DT^S gate
now uses the controlled-rotation skeleton, not the diagonal helper.  Both gates
still carry `unitary.proved := false`; for O_DT^S the remaining gap is the
Eq. (20) coefficient-normalizer relation and the induced two-by-two unitarity
identity.

---

## Ry_boundary Controlled Rotation Matrix (Cycle 8)

The `Ry_boundary` gate from Fig. 1-term Robin applies controlled
$R_y(\theta_j^s)$ rotations on ancilla bit 0 for boundary rows.  The paper's
angle relation is

$$
\theta_j^s=\arccos(D_j^{(s)}/N_D).
$$

Bulk rows have indicator bit $1$, so the active matrix is the identity on those
columns.  Boundary rows have indicator bit $0$, so the active matrix preserves
all non-ancilla bits and applies the two-by-two block

$$
R_y(\theta)=
\begin{pmatrix}
\cos(\theta/2) & -\sin(\theta/2)\\
\sin(\theta/2) & \cos(\theta/2)
\end{pmatrix}.
$$

The half-angle obligations are

$$
\cos(\theta_j^s/2)=\sqrt{\frac{1+D_j^{(s)}/N_D}{2}},
\qquad
\sin(\theta_j^s/2)=\sqrt{\frac{1-D_j^{(s)}/N_D}{2}}.
$$

Lean records these entries symbolically:

- `GHL2025.boundaryRotationCosHalf row sparse` represents $\cos(\theta_j^s/2)$.
- `GHL2025.boundaryRotationSinHalf row sparse` represents $\sin(\theta_j^s/2)$.

The coefficient source is `GHL2025.robinSparseAmplitudeValue p.n sparse row`.
The symbolic entries are not proof terms.  The typed source contract
`GHL2025.boundaryRotationAngleNormalizerContract p row sparse` binds the
coefficient, the normalizer symbol $N_D$, the two symbolic entries, and the
four false proof flags for boundary control, arccos relation, half-angle
relations, and two-by-two unitarity.

### Source-Contract Audit

| Register / value | Lean extraction | Required action | Status |
|---|---|---|---|
| ancilla bit | bit 0 of the compound index | only this bit may change when boundary control is active | defined in `boundaryRotationPaperRegisters` |
| system row $j$ | bits $[1,1+n)$ | supplies the boundary row index | defined in `boundaryRotationPaperRegisters` |
| sparse index $s$ | high subfield of the padded O_D register | selects $D_j^{(s)}$ | defined in `boundaryRotationPaperRegisters` |
| indicator bit | `GHL2025.robinIndicatorBitPosition p` | if 1, act as identity; if 0, apply the boundary rotation | defined and tested |
| derivative coefficient | `GHL2025.robinSparseAmplitudeValue p.n sparseVal rowVal` | Lean source for $D_j^{(s)}$ | data helper defined |
| symbolic entries | `boundaryRotationCosHalf`, `boundaryRotationSinHalf` | represent the two half-angle entries | defined; angle relation unproved |
| angle-normalizer contract | `BoundaryRotationAngleNormalizerContract`, `boundaryRotationAngleNormalizerObligation` | record $\theta_j^s=\arccos(D_j^{(s)}/N_D)$ and half-angle formulas | typed contract recorded; proof fields false |
| active gate matrix | `GHL2025.oneTermRobinGate_Ry_boundary` | uses `boundaryRotationMatrix` | proved by `rfl`; unitary flag false |

**Concrete example** ($n=3, \kappa=7$, totalQubits=13):
- $j=0$: boundary row, $\text{sysVal}=0$, $\text{sparseVal}=0$, $\text{anc}=0$
  - $M(0, 0) = \texttt{boundary\_cos\_half\_0\_0}$ (cos entry)
  - $M(1, 0) = \texttt{boundary\_sin\_half\_0\_0}$ (sin entry)
  - $M(0, 1) = -\texttt{boundary\_sin\_half\_0\_0}$ (neg-sin entry)
  - $M(1, 1) = \texttt{boundary\_cos\_half\_0\_0}$ (cos entry)
- $j=132$: bulk row (indicator=1), $M(132, 132) = 1$ (identity)

### Ry_boundary Proof-DAG Pane

| Block | Interface | Paper source | Lean declaration | Depends on | Reused by | Status |
|---|---|---|---|---|---|---|
| `ryb_extract_registers` | extract ancilla bit, indicator bit, row value, sparse-index value, and non-ancilla rest bits | Fig. 1-term Robin, arXiv:2506.20478 | `BoundaryRotationPaperRegisters`, `boundaryRotationPaperRegisters` | `defaultRobinRegisterPartition`, `robinIndicatorBitPosition` | rotation matrix entries, contract tests | defined skeleton; concrete tests pass |
| `ryb_symbolic_entries` | define the symbolic half-angle entries used by the active matrix | Eq. angles for Ry, arXiv:2506.20478 | `boundaryRotationCosHalf`, `boundaryRotationSinHalf`, `boundaryRotationMatrix` | `ryb_extract_registers`, `robinSparseAmplitudeValue` | `oneTermRobinGate_Ry_boundary`, block extraction | active skeleton; angle relation unproved |
| `shared_nd_normalizer` | record the shared normalized coefficient $D_j^{(s)}/N_D$ and the common nonzero, division, coefficient-bound, absolute-square, square-root, arccos, and two-by-two-unitary obligations | Lemma 3, Eq. (20), and boundary Ry equations, arXiv:2506.20478 | `DerivativeNormalizerNDContract`, `derivativeNormalizerNDContract`, `DerivativeNormalizerNDSourceBound`, `derivativeNormalizerNDSourceBound` | `robinSparseAmplitudeValue` | `odts_coeff_normalizer`, `ryb_angle_normalizer` | typed contract recorded; source-bound view proved by definitional bridges; all analytic proof flags false |
| `ryb_angle_normalizer` | prove $\theta_j^s=\arccos(D_j^{(s)}/N_D)$ and the two half-angle formulas | Eq. angles for Ry, arXiv:2506.20478 | `BoundaryRotationAngleNormalizerContract`, `boundaryRotationAngleNormalizerObligation`, `boundaryRotationAngleNormalizerProofRoute` | `shared_nd_normalizer`, future half-angle theorem | `ryb_rotation_unitary`, block extraction | typed contract recorded; shared $N_D$ bridges proved; proof flags false |
| `ryb_active_gate_rewire` | active gate matrix is definitionally the boundary rotation matrix | Fig. 1-term Robin, arXiv:2506.20478 | `oneTermRobinGate_Ry_boundary` | `ryb_symbolic_entries` | circuit product | proved by `rfl` |
| `ryb_rotation_unitary` | prove each two-by-two boundary block is unitary under the paper normalizer bound | Eq. angles for Ry, arXiv:2506.20478 | future theorem or obligation | `ryb_angle_normalizer` | final gate unitarity | unproved; `unitary.proved = false` |

### Completed Middle Packet: Ry_boundary Contract Promotion

This packet added only contract structure and tests.  It did not promote
`oneTermRobinGate_Ry_boundary.unitary.proved`.

| Declaration | Role |
|---|---|
| `BoundaryRotationPaperRegisters` | stores the register fields used by the active boundary rotation matrix |
| `boundaryRotationPaperRegisters` | extracts those fields from a compound basis index |
| `boundaryRotationCosHalf`, `boundaryRotationSinHalf` | shared names for the symbolic half-angle entries |
| `boundaryRotationAngleNormalizerObligation` | global false proof flag for the angle-normalizer relation |
| `BoundaryRotationAngleNormalizerContract` | per-row/sparse-index contract for coefficient, $N_D$, symbolic entries, and false proof flags |
| `boundaryRotationAngleNormalizerContract` | default contract populated from `robinSparseAmplitudeValue p.n sparse row` |

Focused tests pin the contract at $n=3$, $\kappa=7$, row $0$, sparse index
$0$: the coefficient is the left boundary value
$-5/2+(7/3)A_1dx$, the normalizer is `N_D`, and the symbolic entries are
`boundary_cos_half_0_0` and `boundary_sin_half_0_0`.  The tests also check that
all five proof flags stay false.

### Lower Packet: Ry_boundary Angle-Normalizer Proof Route

Target one block: `ryb_angle_normalizer`.  Allowed write scope is
`QuantumBlockEncoding/GHL2025.lean` and focused tests in `Tests/Basic.lean`.
Do not touch `O_D^BS`, `O_DT^S`, `O_f`, SWAP, or block extraction.  Do not
change `oneTermRobinGate_Ry_boundary.unitary.proved`.

Acceptance for the lower packet:

| Required item | Acceptance |
|---|---|
| coefficient contract | keep `boundaryRotationAngleNormalizerContract p row sparse`.coefficient definitionally tied to `robinSparseAmplitudeValue p.n sparse row` |
| angle relation | add a theorem or a finer obligation for $\theta_j^s=\arccos(D_j^{(s)}/N_D)$ without adding hidden hypotheses |
| half-angle formulas | either prove the symbolic entries match the displayed half-angle formulas or leave `cosHalfRelation` and `sinHalfRelation` false with a more precise obstruction |
| unitarity route | do not prove gate unitarity until the two half-angle identities and $N_D$ bound are available |
| tests | preserve the existing concrete `n=3`, `kappa=7` matrix-entry tests and the false proof-flag tests |

### Completed Lower Packet: Ry_boundary Angle-Normalizer Proof Route

Definition. `GHL2025.boundaryRotationNormalizedCoefficient p row sparse`
records the formal normalized coefficient
`robinSparseAmplitudeValue p.n sparse row * Coeff.symbol "N_D_inv"`.  This is a
symbolic stand-in for $D_j^{(s)}/N_D$, not a proof that $N_D$ is invertible.

The lower packet added
`GHL2025.BoundaryRotationAngleNormalizerProofRoute` and
`GHL2025.boundaryRotationAngleNormalizerProofRoute`.  The route references the
existing `BoundaryRotationAngleNormalizerContract` fields and splits the
remaining analytic gap into explicit obligations:

| Proof-route field | Meaning | Status |
|---|---|---|
| `coefficientDivision` | interpret the formal `N_D_inv` factor as division by $N_D$ | `proved := false` |
| `realArccosSemantics` | connect $\theta_j^s$ to real $\arccos(D_j^{(s)}/N_D)$ | `proved := false` |
| `halfAngleSemantics` | derive the displayed cosine and sine half-angle formulas | `proved := false` |
| `normalizerBound` | prove the $N_D$ bound that places $D_j^{(s)}/N_D$ in the arccos domain | `proved := false` |
| `twoByTwoUnitary` | reuse the contract's two-by-two unitarity obligation | `proved := false` |

Two named Lean bridges were added:
`GHL2025.boundaryRotationAngleNormalizerContract_coefficient` proves that the
contract coefficient is definitionally `robinSparseAmplitudeValue p.n sparse
row`, and
`GHL2025.boundaryRotationAngleNormalizerProofRoute_arccosArgument` proves that
the route's arccos argument is the normalized-coefficient stand-in.  This
packet does not change `GHL2025.oneTermRobinGate_Ry_boundary.unitary.proved`.

Cycle 16 links this route to the same
`GHL2025.derivativeNormalizerNDContract p row sparse` used by `O_DT^S`.  The
route obtains its division, arccos-domain, and $N_D$-bound obligation records
from the shared contract, and
`GHL2025.boundaryRotationAngleNormalizerProofRoute_sharedND` records that
bridge.  The half-angle and gate-unitarity obligations remain local to the
boundary rotation route and are still false.

---

## Cycle 10 Circuit Product and Block Extraction Pipeline

Cycle 10 connects the faithful one-term Robin circuit matrix semantics to the block-extraction target without pretending that block correctness has been proved.

| Paper object | Lean object | Status |
|---|---|---|
| Full circuit product $U$ | `Examples.RobinHeat.oneTermRobinCircuitSemantics n` | implemented as `evalGateMatrices` over all seven gate matrices |
| Dimension factorization $2^{q}=2^{m}\cdot N$ | `Examples.RobinHeat.oneTermRobinCircuitDimCompat n` | proved from `clog2_gridSize` and register arithmetic |
| Signal-zero block extraction | `CircuitMatrixSemantics.blockExtractionTarget` | reused generic API |
| Robin block target | `Examples.RobinHeat.oneTermRobinBlockExtractionTarget n` | derives `unitaryMatrix` and `blockMatrix` from the circuit product |
| Final theorem $U$ block equals $A_k/(N_DN_f\kappa)$ | `blockCorrect.proved` | still false |

### Cycle 10 Test Strategy

The compiled tests now check the wiring structurally:

- `oneTermRobinCircuitSemantics n`.matrix is definitionally `evalGateMatrices`.
- `oneTermRobinBlockExtractionTarget n`.unitaryMatrix is the cast circuit product.
- `oneTermRobinBlockExtractionTarget n`.blockMatrix is `signalSystemBlockProjection` at signal index 0.
- Existing target matrix, normalizer, signal index, and unproved-obligation tests still pass.

Concrete entry-level tests of the full $n=3$ product were removed from the build gate because they force Lean to normalize entries of a $8192 \times 8192$ symbolic matrix product. Those entry checks should return as focused lemmas or proof attempts once the block-correctness proof is decomposed, not as routine CI tests.

---

## Cycle 12: General U_indic Self-Inverse and Bijection

Cycle 12 targets the general proof that `indicatorOracleImage` is self-inverse
for arbitrary `p : OneTermRobinParameters`, upgrading the concrete `native_decide`
proofs for n=1 and n=3 from cycle 11.

### Proof-DAG Block: Bit-Arithmetic Reusable Lemma

The key reusable lemma is `xor_high_bits_preserve_low`:

For `pos >= 1 + n` and `mask = (1 <<< n) - 1`:
$(x \oplus (b \ll \text{pos})) \mathbin{\&} \text{mask} = x \mathbin{\&} \text{mask}$

This is because $b \ll \text{pos}$ has zeros in all bit positions below `pos`,
so XOR with it leaves bits `[0, pos)` unchanged.

This block is reused by all four permutation-gate bijection proofs
(U_indic, SWAP, O_D^BS, O_D^BS_dagger).

### Paper Correspondence

The indicator oracle U_indic, cited from the U_indic definition and Fig. 1-term
Robin in Guseynov-Huang-Liu 2025, arXiv:2506.20478, flips a single ancilla
qubit when the system register value is in the bulk window.  Self-inverse
follows from the fact that the indicator bit is in a disjoint register from the
system value, so the bulk test returns the same result after the flip.

| Paper step | Lean declaration | Status |
|---|---|---|
| U_indic preserves system register | `indicatorOracleImage_systemVal_preserved` | proved |
| U_indic preserves bulk membership | `indicatorOracleImage_isBulk_preserved` | proved |
| U_indic is self-inverse (general n) | `indicatorOracleImage_self_inverse` | proved |
| U_indic is injective (general n) | `indicatorOracleImage_injective` | proved |
| U_indic is bijective (Fin domain) | `indicatorOracleImage_bijective` | proved |
| Reusable bit-arithmetic lemma | `shiftLeft_land_mask_eq_zero`, `xor_shift_preserve_low`, `xor_shift_preserve_shift_low` | proved |

---

## Run 03 Cycle 1: SWAP Diff Proof-DAG Block

The SWAP gate in Fig. 1-term Robin, arXiv:2506.20478, uses the existing Lean
image formula `swapOracleImage`.  For a basis index $j$, define the n-bit mask
and blocks by the same expressions used in Lean:

$$
\begin{aligned}
\mathrm{mask} &= 2^n - 1,\\
\mathrm{block}_1 &= (j \gg 1)\mathbin{\&}\mathrm{mask},\\
\mathrm{block}_2 &= (j \gg (1+n))\mathbin{\&}\mathrm{mask},\\
\mathrm{diff} &= \mathrm{block}_1 \oplus \mathrm{block}_2.
\end{aligned}
$$

The first reusable block proves that `diff` is an n-bit value and records the
two vanishing facts needed by the later block-extraction proof.  The subsequent
finite permutation bridge promotes `oneTermRobinGate_SWAP.unitary.proved` to
`true`.

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `swap_diff_bounded` | `diff < 2^n` for the two extracted n-bit blocks | `Nat.xor_lt_two_pow`, `Nat.and_lt_two_pow` | `swapOracleDiff_lt_two_pow` | `swap_block1_image`, `swap_block2_image`, `swap_lt` | SWAP | proved |
| `swap_diff_shift_right_zero` | `diff >>> n = 0` | `swap_diff_bounded`, `Nat.shiftRight_eq_zero` | `swapOracleDiff_shiftRight_eq_zero` | `swap_block2_image` | SWAP | proved |
| `swap_diff_shift_left_mask_zero` | `(diff <<< n) &&& mask = 0` | `shiftLeft_land_mask_eq_zero` | `swapOracleDiff_shiftLeft_mask_eq_zero` | `swap_block1_image` | SWAP | proved |
| `swap_block1_image` | after `swapOracleImage`, the low block equals the old high block | bit-test proof over `swapOracleImage`, `Nat.testBit_xor`, `Nat.testBit_shiftLeft`, and mask facts | `swapOracleImage_block1_eq_block2` | `swap_diff_preserved` | SWAP | proved |
| `swap_block2_image` | after `swapOracleImage`, the high block equals the old low block | bit-test proof over `swapOracleImage`, n-bit mask facts | `swapOracleImage_block2_eq_block1` | `swap_diff_preserved`, O_D^BS post-SWAP register equations | SWAP | proved |
| `swap_lt` | image preserves the full `qubitDim` bound | `swap_diff_bounded`, register-width inequality | `swapOracleImage_lt_qubitDim` | post-SWAP finite range, finite bijection | SWAP | proved |
| `swap_diff_named` | expose the reusable block difference used by `swapOracleImage` | same register extraction as `swapOracleImage` | `swapOracleDiff`, `swapOracleImage_eq_xor_diff` | `swap_diff_preserved`, `swap_self_inverse` | SWAP | proved by definition |
| `swap_diff_preserved` | the named difference is unchanged after one SWAP | `swap_block1_image`, `swap_block2_image`, XOR commutativity | `swapOracleDiff_preserved` | `swap_self_inverse` | SWAP | proved |
| `swap_xor_cancel` | applying the two shifted XOR masks twice cancels bitwise | `Nat.testBit_xor` case split | `xor_two_shifted_masks_cancel` | `swap_self_inverse` | SWAP | proved |
| `swap_self_inverse` | `swapOracleImage p (swapOracleImage p j) = j` for all parameters and indices | `swap_diff_named`, `swap_diff_preserved`, `swap_xor_cancel` | `swapOracleImage_self_inverse` | `swap_injective`, `swap_bijective` | SWAP | proved |
| `swap_injective` | injectivity from self-inverse | `swap_self_inverse` | `swapOracleImage_injective` | `swap_bijective` | SWAP | proved |
| `swap_bijective` | bijectivity on `Fin (qubitDim total)` | `swap_self_inverse`, `swap_injective`, `swap_lt` | `swapOracleImage_bijective` | permutation proof | SWAP | proved |
| `swap_matrix_permutation` | exactly one `1` entry in each row and column | `swap_bijective`, `swapOracleMatrix_eq_image` | `swapOracleMatrix_col_has_one`, `swapOracleMatrix_col_unique`, `swapOracleMatrix_row_has_one`, `swapOracleMatrix_row_unique`, `swapOracleMatrix_is_permutation` | SWAP gate flag | SWAP | proved; `unitary.proved := true` |

The source-contract audit introduced `BandedSparseAccessPaperContract`, and the
active O_D^BS gate pair now uses `bandedSparseAccessPaperMatrix` and
`bandedSparseAccessPaperDaggerMatrix`.  No lower worker should prove unitarity
for the legacy `bandedSparseAccessMatrix` or `bandedSparseAccessDaggerMatrix`
as if those helpers were the paper oracle.

The post-SWAP register packet proves both `swapOracleImage_block1_eq_block2`
and `swapOracleImage_block2_eq_block1` in `QuantumBlockEncoding/GHL2025.lean`.
Both proofs are general in `p` and `j`; they are not finite `native_decide`
samples.  The later finite permutation bridge proves
`swapOracleMatrix_is_permutation` and promotes
`oneTermRobinGate_SWAP.unitary.proved` to `true`.

The lower SWAP self-inverse packet is now accepted as an image-level arithmetic
block.  `swapOracleDiff` names the XOR difference already used by
`swapOracleImage`; `swapOracleDiff_preserved` proves that this difference is the
same after one SWAP by reusing the two block equations; and
`xor_two_shifted_masks_cancel` proves the bitwise cancellation of the two
shifted XOR masks.  The finite bridge adds `swapOracleImage_bijective` and
`swapOracleMatrix_is_permutation`.

---

## 2026-05-22 Middle Handoff: O_D^BS Image-Fin Entry Packet

This faithful packet targets the active Lemma 1 paper-image skeleton only,
after the executable address-range, no-spill, image-range, and roundtrip blocks.
The paper anchor is Guseynov-Huang-Liu 2025, Lemma 1 and Fig. 1-term Robin,
arXiv:2506.20478.  The source equation remains

$$
  O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n
  =
  |r_{si}\rangle^n|i\rangle^n .
$$

The current Lean image is `GHL2025.bandedSparseAccessPaperImage`.  It replaces
only the current O_D register block at bits $[1+n,1+2n)$ with
`GHL2025.bandedSparseAccessPaperAddress p j`, and it must not be confused with
the legacy helper `GHL2025.bandedSparseAccessMatrix`.

### Source-Contract Audit

| Gate | Paper anchor | Input registers | Output registers | Clean ancillas | Lean target | Status |
|---|---|---|---|---|---|---|
| $O_D^{BS}$ | Lemma 1, arXiv:2506.20478 | clean padded sparse register $|0\rangle^{n-l}|s\rangle^l$ and row $|i\rangle^n$ | address $|r_{si}\rangle^n$ and preserved row $|i\rangle^n$ | clean-domain predicate must separate columns outside Lemma 1; full unitary extension remains open | `bandedSparseAccessPaperImage`, `bandedSparseAccessPaperColumnContract` | fixed target; proof flags false |
| $(O_D^{BS})^\dagger$ | Fig. 1-term Robin and Lemma 1, arXiv:2506.20478 | post-SWAP paper image range | padded sparse register cleaned back on the valid range | cleanup by dagger remains `daggerCleanup.proved = false` | `bandedSparseAccessPaperDaggerMatrix` | no proof search in this packet |

### Fixed Lean Targets

Allowed write scope:

- `QuantumBlockEncoding/GHL2025.lean`
- focused tests in `Tests/Basic.lean`
- synchronized notes in `conversion-windows/QBE-AUTO-002.md`,
  `paper-notes/GHL2025_RobinOneTerm.tex`, or
  `proof-obligations/QBE-AUTO-002.md`

Do not edit `CircuitSemantics.lean`, `RobinMatrix.lean`, the circuit gate list,
or the legacy helper matrices for this packet.

| Target block | Lean declaration to add or refine | Required statement | Acceptance |
|---|---|---|---|
| `odbs_image_range_of_address_range` | `bandedSparseAccessPaperImage_lt_qubitDim_of_address_lt` | if `j < qubitDim (oneTermRobinTotalQubits p)` and `bandedSparseAccessPaperAddress p j < 2^p.n`, then `bandedSparseAccessPaperImage p j < qubitDim (oneTermRobinTotalQubits p)` | proved as executable range block; needed next for finite-domain injectivity or dagger inverse work |
| `odbs_image_fin` | `bandedSparseAccessPaperImageFin`, `bandedSparseAccessPaperImageFin_val` | under the same source-column and n-bit address hypotheses, package `bandedSparseAccessPaperImage p j.val` as a `Fin (qubitDim (oneTermRobinTotalQubits p))` and expose its value | proved as executable finite-index bridge |
| `odbs_forward_entry_at_image` | `bandedSparseAccessPaperMatrix_imageFin_eq_one`, `oneTermRobinGate_O_D_BS_imageFin_eq_one` | the forward paper matrix and active forward gate have entry $1$ at row `bandedSparseAccessPaperImageFin p j haddr`, column `j` | proved; no injectivity or unitarity promoted |
| `odbs_dagger_entry_at_image` | `bandedSparseAccessPaperDaggerMatrix_imageFin_eq_one`, `oneTermRobinGate_O_D_BS_dagger_imageFin_eq_one` | the transpose-style paper matrix and active dagger gate have entry $1$ at row `j`, column `bandedSparseAccessPaperImageFin p j haddr` | proved; inverse-on-range and cleanup remain obligations |
| `odbs_image_row_roundtrip` | `bandedSparseAccessPaperImage_rowValue_eq` | extracting registers from `bandedSparseAccessPaperImage p j` reports the original row value | proved unconditionally for the executable splice |
| `odbs_image_address_roundtrip` | `bandedSparseAccessPaperImage_odRegisterValue_eq` | under the n-bit address hypothesis, extracting registers from `bandedSparseAccessPaperImage p j` reports O_D register value `bandedSparseAccessPaperAddress p j` | proved as executable register block |
| `odbs_clean_domain_guard` | focused tests or a bridge around `bandedSparseAccessPaperCleanInput` and `bandedSparseAccessPaperColumnContract.cleanInput` | clean columns are exactly those whose padded-zero field is zero; non-clean columns remain routed to `unitaryExtension` | guard only; no proof flags promoted |

This packet did not silently add $2 \le n$ to the paper theorem.  The range
and entry lemmas use the explicit n-bit address hypothesis, while
`bandedSparseAccessPaperAddressInRange_eq_true_of_two_le` remains only a route
for parameter families that separately provide $2 \le n$.  The semantic
contract fields `addressRange.proved`, `noSpill.proved`, `forwardCorrect.proved`,
and `daggerCleanup.proved` remain false.

### Proof-DAG Update

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `odbs_clean_domain_separation` | identify the Lemma 1 clean-input columns and keep non-clean columns under unitary-extension obligation | `bandedSparseAccessPaperRegisters` | `bandedSparseAccessPaperCleanInput`, `bandedSparseAccessPaperCleanInput_iff`, `bandedSparseAccessPaperColumnContract_cleanInput_eq`, `bandedSparseAccessPaperColumnContract_cleanInput_iff`, `bandedSparseAccessPaperColumnContract_unitaryExtension_proved_eq_false` | forward image, unitary extension | O_D^BS | executable guard proved; semantic proof flags false |
| `odbs_image_no_spill_of_address_range` | prove high-tail preservation for `bandedSparseAccessPaperImage` from the n-bit address hypothesis | `bandedSparseAccessPaperImageNoSpill_iff`, address range | `bandedSparseAccessPaperImage_highTail_eq_of_address_lt`, `bandedSparseAccessPaperImageNoSpill_eq_true_of_address_lt`, `bandedSparseAccessPaperImageNoSpill_eq_true_of_two_le` | forward matrix, dagger cleanup, block extraction | O_D^BS | proved as executable block; semantic flag false |
| `odbs_image_range_of_address_range` | show the paper image stays inside the full finite basis dimension | original column bound, n-bit address range, `bandedSparseAccessPaperHighWidth_le_totalQubits`, `bandedSparseAccessPaperImage_lowBlock_lt_highBase_of_address_lt` | `bandedSparseAccessPaperImage_lt_qubitDim_of_address_lt` | matrix finite-domain route, injectivity | O_D^BS | proved as executable range block; semantic flags false |
| `odbs_image_fin_entry_bridge` | construct the finite image index and prove the forward and dagger entries at that index | `odbs_image_range_of_address_range`, active matrix definitions | `bandedSparseAccessPaperImageFin`, `bandedSparseAccessPaperMatrix_imageFin_eq_one`, `bandedSparseAccessPaperDaggerMatrix_imageFin_eq_one`, `oneTermRobinGate_O_D_BS_imageFin_eq_one`, `oneTermRobinGate_O_D_BS_dagger_imageFin_eq_one` | injectivity, inverse-on-range, cleanup route | O_D^BS | proved as executable entry bridge; semantic flags false |
| `odbs_column_audit_safety` | package the per-column audit booleans for row preservation, address write, address range, and no-spill | `odbs_image_row_roundtrip`, `odbs_image_address_roundtrip`, `odbs_image_no_spill_of_address_range` | `bandedSparseAccessPaperColumnContract_rowPreserved_eq_true`, `bandedSparseAccessPaperColumnContract_addressWritten_eq_true_of_address_lt`, `bandedSparseAccessPaperColumnContract_addressInRange_eq_true_of_address_lt`, `bandedSparseAccessPaperColumnContract_imageNoSpill_eq_true_of_address_lt`, `bandedSparseAccessPaperColumnContract_registerSafety_of_address_lt` | inverse-on-range route, cleanup packet | O_D^BS | proved executable audit bridge; semantic flags false |
| `odbs_entry_safety_witness` | package the paired active-gate entries with row/address roundtrip and no-spill facts under the n-bit address hypothesis | `odbs_image_fin_entry_bridge`, `odbs_image_row_roundtrip`, `odbs_image_address_roundtrip`, `odbs_image_no_spill_of_address_range` | `oneTermRobinGate_O_D_BS_imageFin_entrySafety` | inverse-on-range route, cleanup packet | O_D^BS | proved executable witness; semantic flags false |
| `odbs_post_swap_column` | prove the column reached by applying SWAP to the finite forward image is still in the full finite basis | `bandedSparseAccessPaperImage_lt_qubitDim_of_address_lt`, `swapOracleImage_lt_qubitDim` | `bandedSparseAccessPaperPostSwapImage_lt_qubitDim_of_address_lt` | finite post constructor, dagger inverse packet | O_D^BS + SWAP | proved range block; no O_D^BS flag promotion |
| `odbs_post_swap_registers` | prove that the post-SWAP system register contains $r_{si}$ and the post-SWAP O_D register contains the original row | `swapOracleImage_block1_eq_block2`, `swapOracleImage_block2_eq_block1`, `odbs_image_row_roundtrip`, `odbs_image_address_roundtrip` | `bandedSparseAccessPaperPostSwap_rowValue_eq_address`, `bandedSparseAccessPaperPostSwap_odRegisterValue_eq_rowValue` | cleanup-register proof, inverse-on-range route | O_D^BS + SWAP | proved register equations; no preimage or cleanup flag promotion |
| `odbs_reverse_sparse_index` | compute the sparse index that would make the post-SWAP row address the original source row | `robinSparseColumnMap`, Lemma 1 register interpretation | `robinSparseColumnMap_zero`, `robinSparseColumnMap_one`, `robinSparseColumnMap_bulk`, `robinSparseColumnMap_rightBoundaryPrev`, `robinSparseColumnMap_rightBoundaryLast`, `robinSparseReverseColumnIndex`, `robinSparseReverseColumnRoundtrip_of_lt_eight`, `robinSparseReverseColumnRoundtripCheck` | preimage candidate, inverse-on-range route | O_D^BS + SWAP | reverse candidate defined; general arithmetic roundtrip proved for $3 \le n$, $s < 8$, and $i < 2^n$; no uniqueness or cleanup flag |
| `odbs_post_swap_preimage_candidate` | splice a clean reverse sparse register into the post-SWAP column and audit image, clean-domain, address-range, and finite-range checks | `odbs_reverse_sparse_index`, `swapOracleImage`, `bandedSparseAccessPaperImage`, clean-domain audit, splice range | `bandedSparseAccessPaperSpliceODRegister`, `bandedSparseAccessPaperCleanODValue`, `bandedSparseAccessPaperPostSwapPreimageCandidate`, `bandedSparseAccessPaperPostSwapPreimageCandidateChecks`, `bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_cleanSource`, `bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_cleanSource` | supplied-preimage cleanup witness, inverse-on-range route | O_D^BS + SWAP | clean-source Boolean audit and finite range proved under explicit one-term hypotheses; all finite columns for $n=3,\kappa=7$ still pass in tests; uniqueness and semantic cleanup remain unproved |
| `odbs_dagger_entry_of_post_swap_preimage` | if a cleanup candidate `pre` satisfies `post.val = bandedSparseAccessPaperImage p pre.val`, then the active dagger has entry $1$ from post-SWAP column `post` to `pre` | `bandedSparseAccessPaperDaggerMatrix`, `oneTermRobinGate_O_D_BS_dagger` | `oneTermRobinGate_O_D_BS_dagger_postSwap_entry_of_preimage` | cleanup-register proof | (O_D^BS)^† | proved as a conditional entry bridge; existence, uniqueness, and cleanup registers remain obligations |
| `odbs_post_swap_cleanup_registers` | for a supplied clean preimage, package the active dagger entry and executable row/address/no-spill cleanup checks | `odbs_dagger_entry_of_post_swap_preimage`, clean-domain audit, address-range audit | `BandedSparseAccessPostSwapCleanup`, `bandedSparseAccessPostSwapCleanup_of_preimage`, `bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate_noRange` | block extraction | (O_D^BS)^† | no-extra-range conditional witness proved for the candidate; source-domain uniqueness and full cleanup remain obligations |
| `odbs_post_swap_cleanup_contract` | bundle the dagger entry, cleanup registers, and false semantic flags into the source-contract audit | previous three post-SWAP blocks plus a future source-domain uniqueness theorem | future full cleanup contract; current `BandedSparseAccessPostSwapCleanup` is only conditional | final block-correctness theorem | (O_D^BS)^† | obligation; `daggerCleanup.proved` remains false |
| `odbs_image_row_roundtrip` | show image extraction reports the preserved row | `bandedSparseAccessPaperRegisterValue_eq_mod`, `bandedSparseAccessPaperImage_mod_lowBase` | `bandedSparseAccessPaperImage_rowValue_eq` | forward correctness, cleanup route | O_D^BS | proved unconditionally for the executable splice |
| `odbs_image_address_roundtrip` | show image extraction reports the written address under the n-bit address hypothesis | `bandedSparseAccessPaperRegisterValue_eq_mod`, `bandedSparseAccessPaperImage_div_lowBase_mod_eq` | `bandedSparseAccessPaperImage_odRegisterValue_eq` | forward correctness, cleanup route | O_D^BS | proved as executable register block; semantic flags false |

Acceptance for the packet:

```bash
python3 tools/qbe.py check
rg -n "Prop := True|:= trivial|sparseCorrect := True|amplitudeCorrect := True|lcuCorrect := True|\\bsorry\\b" QuantumBlockEncoding Tests -g '!QuantumBlockEncoding/Automation.lean' || true
```

The packet must leave `oneTermRobinGate_O_D_BS.unitary.proved`,
`oneTermRobinGate_O_D_BS_dagger.unitary.proved`,
`defaultBandedSparseAccessPaperContract p`.forwardCorrect.proved,
`.daggerCleanup.proved`, `.noSpill.proved`, and all block-correctness flags
equal to `false`.

---

## 2026-05-23 Middle Update: O_D^BS Entry-Safety Witness

The current cycle adds one reusable proof-DAG block for the active Lemma 1 gate
pair.  The paper-to-Lean contract is unchanged: the source equation is still
represented by
`bandedSparseAccessPaperImage` and the active matrices
`bandedSparseAccessPaperMatrix` and `bandedSparseAccessPaperDaggerMatrix`:

$$
O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n
=
|r_{si}\rangle^n|i\rangle^n .
$$

The Lean-to-paper status is:

| Item | Lean declaration | Status |
|---|---|---|
| paired active entries | `oneTermRobinGate_O_D_BS_imageFin_entrySafety` | proves the active forward entry and active dagger entry at the finite image index under the explicit n-bit address hypothesis |
| register roundtrip | same theorem, using `bandedSparseAccessPaperImage_rowValue_eq` and `bandedSparseAccessPaperImage_odRegisterValue_eq` | records that the executable image preserves the row and writes the intended O_D address |
| no-spill bridge | same theorem, using `bandedSparseAccessPaperImageNoSpill_eq_true_of_address_lt` | records high-tail preservation under the explicit n-bit address hypothesis |
| remaining cleanup gap | `defaultBandedSparseAccessPaperContract p`.daggerCleanup | still `proved := false`; the witness does not prove inverse uniqueness or post-SWAP cleanup |

This earlier inverse-on-range packet is superseded by the cycle 9 collision
audit.  The next lower packet should not attempt uniqueness over the current
clean-domain skeleton.  It should first state a corrected valid sparse-branch
domain or a reversible unused-branch extension, then leave the semantic proof
flags false until that source contract is reviewed.

---

## 2026-05-23 Middle Update: Post-SWAP Register Equations

The upper cycle requested register equations before reverse-index or preimage
search.  The paper-to-Lean contract is still Lemma 1 followed by the SWAP gate
from Fig. 1-term Robin:

$$
O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n
=
|r_{si}\rangle^n|i\rangle^n,
\qquad
\mathrm{SWAP}(|r_{si}\rangle^n|i\rangle^n)
=
|i\rangle^n|r_{si}\rangle^n .
$$

With the current bit order, the system row register is the low n-bit block and
the O_D register is the high n-bit block.  Lean now proves:

| Claim | Lean declaration | Status |
|---|---|---|
| SWAP sends the high n-bit block to the low n-bit block | `swapOracleImage_block1_eq_block2` | proved |
| SWAP sends the low n-bit block to the high n-bit block | `swapOracleImage_block2_eq_block1` | proved |
| after SWAP of the paper image, the system row value is $r_{si}$ | `bandedSparseAccessPaperPostSwap_rowValue_eq_address` | proved under `bandedSparseAccessPaperAddress p j < (1 <<< p.n)` |
| after SWAP of the paper image, the O_D register value is the original row | `bandedSparseAccessPaperPostSwap_odRegisterValue_eq_rowValue` | proved |

These declarations do not construct a clean dagger preimage and do not promote
`daggerCleanup.proved` or either O_D^BS gate unitarity flag.

---

## 2026-05-23 Middle Lower Packet: Post-SWAP Dagger Cleanup Interface

This packet fixes the Lean-facing contract for the next lower worker.  It does
not ask for broad unitarity of $O_D^{BS}$, SWAP, or $(O_D^{BS})^\dagger$.
It only isolates the inverse-on-range step needed before the paper cleanup
claim can be attempted.

Definitions for the packet:

- `source : Fin (qubitDim (oneTermRobinTotalQubits p))` is a clean Lemma 1
  input column.
- `haddr : bandedSparseAccessPaperAddress p source.val < (1 <<< p.n)` is the
  explicit n-bit address hypothesis.
- `forward = bandedSparseAccessPaperImageFin p source haddr` is the finite
  forward image already covered by `oneTermRobinGate_O_D_BS_imageFin_entrySafety`.
- `post` is the finite column whose value is
  `swapOracleImage p forward.val`.
- `pre` is the cleanup-source candidate for the dagger.  The packet must not
  assume `pre = source`; after SWAP the system and $O_D^{BS}$ registers have
  exchanged roles.

The fixed lower target is:

```lean
theorem oneTermRobinGate_O_D_BS_dagger_postSwap_entry_of_preimage
    (p : OneTermRobinParameters)
    (source post pre : Fin (qubitDim (oneTermRobinTotalQubits p)))
    (hpost : post.val =
      swapOracleImage p
        (bandedSparseAccessPaperImage p source.val))
    (hpre : post.val = bandedSparseAccessPaperImage p pre.val) :
    (oneTermRobinGate_O_D_BS_dagger p).matrix pre post = Coeff.rat 1
```

This theorem is intentionally conditional.  It says that the active
transpose-style dagger uses the paper-image preimage supplied by `hpre`.
It does not prove that such a `pre` exists, that it is unique, or that its
registers have been cleaned.  Those are the next proof-DAG blocks.

The lower packet may add only focused support needed by that theorem:

| Target | Required declaration | Acceptance |
|---|---|---|
| post-SWAP column packaging | `bandedSparseAccessPaperPostSwapImageFin` only if the theorem needs a finite `post` constructor | local range proof for one SWAP output; no SWAP bijection or unitarity proof |
| dagger entry from supplied preimage | `oneTermRobinGate_O_D_BS_dagger_postSwap_entry_of_preimage` | proved from the active `bandedSparseAccessPaperDaggerMatrix`; no semantic flag promoted |
| proof-attempt record | `proof-attempts/QBE-AUTO-002-odbs-post-swap-cleanup.md` if the theorem or range packaging fails | include the exact failed statement, Lean goals, and reusable lemma candidates |

Allowed write scope is `QuantumBlockEncoding/GHL2025.lean`,
`Tests/Basic.lean`, `proof-attempts/`, and synchronized proof-map updates in
this file or `proof-obligations/QBE-AUTO-002.md`.  Do not edit the legacy
`bandedSparseAccessMatrix`, the circuit gate list, `CircuitSemantics.lean`,
or `RobinMatrix.lean` for this packet.

Acceptance guard:

- `oneTermRobinGate_O_D_BS.unitary.proved = false`
- `oneTermRobinGate_O_D_BS_dagger.unitary.proved = false`
- `(defaultBandedSparseAccessPaperContract p).daggerCleanup.proved = false`
- block-correctness flags remain `false`

### 2026-05-23 Lower Update: Post-SWAP Dagger Entry

Lean now contains
`GHL2025.oneTermRobinGate_O_D_BS_dagger_postSwap_entry_of_preimage`.  The theorem
uses the supplied preimage equality
`post.val = bandedSparseAccessPaperImage p pre.val` to prove the active
transpose-style dagger entry
`(oneTermRobinGate_O_D_BS_dagger p).matrix pre post = Coeff.rat 1`.

This is deliberately weaker than cleanup.  The existence and uniqueness of
`pre`, the post-SWAP register-cleanup statement, and
`(defaultBandedSparseAccessPaperContract p).daggerCleanup.proved` remain open.

### 2026-05-23 Lower Update: Conditional Post-SWAP Cleanup Witness

Lean now also contains `GHL2025.BandedSparseAccessPostSwapCleanup` and
`GHL2025.bandedSparseAccessPostSwapCleanup_of_preimage`.  This is still a
conditional interface: it assumes the post-SWAP column equality, a supplied
paper-image preimage, clean padded input for that preimage, and the n-bit
address bound for that preimage.

Under those explicit hypotheses, the witness proves the active dagger matrix
entry, the executable per-column row/address/no-spill audit booleans, and the
post column register extraction facts obtained by rewriting through
`bandedSparseAccessPaperImage`.  It does not construct `pre`, prove uniqueness,
prove an O_D^BS inverse uniqueness theorem, or promote
`(defaultBandedSparseAccessPaperContract p).daggerCleanup.proved`.

For the concrete check `n = 3`, `kappa = 7`, source column `8` reaches post
column `68` after `O_D^BS` and SWAP, and `68` is a clean supplied preimage for
the active paper-image skeleton.  This validates the interface on one focused
column without changing the paper contract.

### 2026-05-23 Lower Update: Reverse-Index Candidate Audit

Lean now contains the reverse-index candidate
`GHL2025.robinSparseReverseColumnIndex`.  For a target row and a post-SWAP row,
it returns the sparse index that would make the executable Robin sparse-column
map address the target.  The finite audit
`GHL2025.robinSparseReverseColumnRoundtripCheck` checks this roundtrip over a
bounded sparse-index domain and all rows of the selected grid.

Lean also contains a post-SWAP preimage candidate:
`GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate`.  It preserves the
post-SWAP low row block and high-tail bits, then writes a clean padded
`O_D^BS` register whose sparse field is the reverse-index candidate.  The
Boolean `GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidateChecks`
verifies that this candidate maps to the post-SWAP column under
`bandedSparseAccessPaperImage`, is clean, and has an n-bit address.

`Tests/Basic.lean` proves the reverse-index scan for $n=3$ and $n=4$ with
three-bit sparse indices, the source `8` candidate `68` at $n=3,\kappa=7$, and
the full finite-source candidate scan for $n=3,\kappa=7$.  These are executable
checks for the inverse-on-range route only.  They do not prove uniqueness,
general cleanup, or either O_D^BS unitary flag, and
`(defaultBandedSparseAccessPaperContract p).daggerCleanup.proved` remains
false.

### 2026-05-23 Middle Update: Reverse-Index Generalization Handoff

The lower packet produced a useful candidate population, but the general
reverse-index theorem has not been proved.  The finite scans stay recorded as
tests, not semantic cleanup.  The proof-route memory is now
`proof-attempts/QBE-AUTO-002-odbs-reverse-roundtrip.md`.

The next lower target is one fixed theorem:

```lean
theorem robinSparseReverseColumnRoundtrip_of_lt_eight
    {n s i : Nat} (hn : 3 <= n) (hs : s < 8) (hi : i < gridSize n) :
    robinSparseColumnMap n
      (robinSparseReverseColumnIndex n i (robinSparseColumnMap n s i))
      (robinSparseColumnMap n s i) = i
```

The source contract for this theorem is still Lemma 1:

$$
O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n
=
|r_{si}\rangle^n|i\rangle^n .
$$

The theorem only targets the Robin sparse-column arithmetic needed to construct
a post-SWAP clean preimage candidate.  It must not promote
`(defaultBandedSparseAccessPaperContract p).daggerCleanup.proved`,
`oneTermRobinGate_O_D_BS.unitary.proved`,
`oneTermRobinGate_O_D_BS_dagger.unitary.proved`, or block
correctness.

Allowed lower write scope is `QuantumBlockEncoding/GHL2025.lean`,
`Tests/Basic.lean`, `proof-attempts/`, and synchronized updates to this
conversion window or `proof-obligations/QBE-AUTO-002.md`.  The lower packet
should case split on the five branches of `robinSparseColumnMap` and reuse
`robinSparseColumnMap_lt_gridSize_of_row_lt` where it helps, but it should not
rewrite the active paper-image contract or the legacy helper matrices.

### 2026-05-23 Lower Update: Reverse-Index Roundtrip Proved

Lean now proves the fixed arithmetic target:

```lean
theorem robinSparseReverseColumnRoundtrip_of_lt_eight
    {n s i : Nat} (hn : 3 <= n) (hs : s < 8) (hi : i < gridSize n) :
    robinSparseColumnMap n
      (robinSparseReverseColumnIndex n i (robinSparseColumnMap n s i))
      (robinSparseColumnMap n s i) = i
```

The proof adds row-normalization blocks for the five executable
`robinSparseColumnMap` regions and the matching `robinSparseReverseColumnIndex`
regions.  This discharges only the reverse sparse-index arithmetic for the
three-bit sparse-index range used by the current one-term Robin parameter
family.  It does not prove preimage uniqueness, clean-preimage existence,
dagger cleanup, either $O_D^{BS}$ unitary flag, or block
correctness.

---

## 2026-05-23 Middle Lower Packet: Clean-Source Preimage Candidate Audit

The next lower packet should use the proved reverse-index theorem to replace
the finite candidate scans by one fixed clean-source theorem for the one-term
Robin parameter family.  The source anchor is still GHL2025, Lemma 1 and
Fig. 1-term Robin, arXiv:2506.20478:

$$
O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n
=
|r_{si}\rangle^n|i\rangle^n .
$$

The packet must keep the one-term assumptions explicit.  The current Robin
family has $\kappa=7$ and `clog2 kappa = 3`, so the sparse-index field has the
same $s < 8$ range used by
`robinSparseReverseColumnRoundtrip_of_lt_eight`.

The fixed Lean target is:

```lean
theorem bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_cleanSource
    (p : OneTermRobinParameters) (source : Nat)
    (hn : 3 <= p.n)
    (hkappa : p.kappa = 7)
    (hclog : clog2 p.kappa = 3)
    (hsource : source < qubitDim (oneTermRobinTotalQubits p))
    (hclean : bandedSparseAccessPaperCleanInput p source = true) :
    bandedSparseAccessPaperPostSwapPreimageCandidateChecks p source = true
```

Definitions for the packet:

- `source` is a finite basis column satisfying the Lemma 1 clean padded-input
  condition.
- `post = swapOracleImage p (bandedSparseAccessPaperImage p source)` is the
  column reached after the active paper-image skeleton and SWAP.
- `pre = bandedSparseAccessPaperPostSwapPreimageCandidate p source` is the
  candidate obtained by splicing a clean $O_D^{BS}$ register whose sparse field
  is `robinSparseReverseColumnIndex p.n sourceRow postRow`.

The theorem should prove exactly the three Boolean checks already present in
`bandedSparseAccessPaperPostSwapPreimageCandidateChecks`: candidate image
equality, clean padded input, and n-bit address range.  It must not prove
uniqueness, dagger unitarity, or the semantic field
`(defaultBandedSparseAccessPaperContract p).daggerCleanup.proved`.

### Proof-DAG Update

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `odbs_reverse_sparse_index` | recover a sparse index that maps the post-SWAP row back to the original source row for the three-bit one-term family | row-normalization lemmas, `3 <= n`, `s < 8`, row range | `robinSparseReverseColumnRoundtrip_of_lt_eight` | preimage candidate theorem | O_D^BS + SWAP | proved |
| `odbs_preimage_candidate_clean_source` | prove the Boolean candidate audit for every clean source column in the one-term family | `odbs_reverse_sparse_index`, `bandedSparseAccessPaperSpliceODRegister`, `bandedSparseAccessPaperCleanODValue`, address-range theorem | `bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_cleanSource` | cleanup witness instantiation | O_D^BS + SWAP + $(O_D^{BS})^\dagger$ | proved executable audit; no flag promotion |
| `odbs_cleanup_witness_instantiation` | convert the Boolean audit into a finite supplied preimage and feed `bandedSparseAccessPostSwapCleanup_of_preimage` | clean-source candidate audit, explicit finite range for `post` and `pre`, conditional cleanup witness | `bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate`, `bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate_noRange` | block extraction cleanup route | $(O_D^{BS})^\dagger$ | no-extra-range conditional wrapper proved; uniqueness and semantic cleanup flag remain open |

Allowed lower write scope is `QuantumBlockEncoding/GHL2025.lean`,
`Tests/Basic.lean`, `proof-attempts/`, and synchronized updates to this
conversion window or `proof-obligations/QBE-AUTO-002.md`.  The worker may add
local bit-splice lemmas for `bandedSparseAccessPaperSpliceODRegister` and
`bandedSparseAccessPaperCleanODValue`.  Do not edit the legacy
`bandedSparseAccessMatrix`, the active gate list, `CircuitSemantics.lean`,
`RobinMatrix.lean`, or any proof flag.

If the theorem fails, append
`proof-attempts/QBE-AUTO-002-odbs-clean-preimage-candidate.md` with the exact
failed statement, the remaining Lean goals, and the smallest reusable
bit-slice lemma candidates.  Do not replace the target by another finite
`native_decide` scan.

---

### 2026-05-23 Middle Sync: Clean-Source Candidate Audit Accepted

The lower result now compiles as
`bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_cleanSource`.  The
Lean theorem proves the executable Boolean audit for finite clean source
columns in the one-term family:

- the candidate maps to `swapOracleImage p (bandedSparseAccessPaperImage p source)`;
- the candidate padded $O_D^{BS}$ register is clean;
- the candidate address passes `bandedSparseAccessPaperAddressInRange`.

The theorem uses only the Lemma 1 source contract plus Lean-local arithmetic
blocks.  It does not construct a `Fin` value for the candidate preimage, does
not prove uniqueness, and does not promote `daggerCleanup.proved`.

The follow-up lower packet now adds the interface that turns this Boolean audit
into the existing conditional witness once finite post and pre columns are
available:

```lean
theorem bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate
    (p : OneTermRobinParameters)
    (source : Fin (qubitDim (oneTermRobinTotalQubits p)))
    (hn : 3 <= p.n) (hkappa : p.kappa = 7) (hclog : clog2 p.kappa = 3)
    (hclean : bandedSparseAccessPaperCleanInput p source.val = true)
    (hpostRange :
      swapOracleImage p (bandedSparseAccessPaperImage p source.val) <
        qubitDim (oneTermRobinTotalQubits p))
    (hpreRange :
      bandedSparseAccessPaperPostSwapPreimageCandidate p source.val <
        qubitDim (oneTermRobinTotalQubits p)) :
    BandedSparseAccessPostSwapCleanup p source
      ⟨swapOracleImage p (bandedSparseAccessPaperImage p source.val), hpostRange⟩
      ⟨bandedSparseAccessPaperPostSwapPreimageCandidate p source.val, hpreRange⟩
```

If the post-SWAP range proof is the blocker, split it out as
`bandedSparseAccessPaperPostSwapImage_lt_qubitDim_of_address_lt`.  If the
candidate range proof is the blocker, split it out as
`bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_cleanSource`.
Both support lemmas must keep the hypotheses explicit and must not change any
oracle matrix or proof flag.

### 2026-05-23 Lower Update: Conditional Candidate Witness

`bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate` now compiles with
the signature above.  It keeps the finite-range facts as inputs and uses
`bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_cleanSource` to
extract:

- the candidate preimage equality;
- the candidate clean padded-register condition;
- the candidate n-bit address bound.

The theorem then invokes `bandedSparseAccessPostSwapCleanup_of_preimage`.
This is a typed conditional witness only: `daggerCleanup.proved`, SWAP
unitarity, both `O_D^BS` unitarity flags, and inverse uniqueness remain open.

### 2026-05-23 Middle Handoff: Finite-Range Cleanup Inputs

The cleanup wrapper is now synchronized with Lean, so the next fixed lower
packet should remove the two remaining external `Fin` range premises needed to
instantiate it.  The source contract remains GHL2025 Lemma 1 and Fig. 1-term
Robin, arXiv:2506.20478; no oracle matrix or proof flag should change.

Target the following interfaces, in this order:

| Block | Lean declaration | Required statement | Dependencies | Status |
|---|---|---|---|---|
| `odbs_post_swap_range` | `swapOracleImage_lt_qubitDim`, `bandedSparseAccessPaperPostSwapImage_lt_qubitDim_of_address_lt` | for a finite clean source and an n-bit `O_D^BS` address, `swapOracleImage p (bandedSparseAccessPaperImage p source.val)` is still below `qubitDim (oneTermRobinTotalQubits p)` | `bandedSparseAccessPaperImage_lt_qubitDim_of_address_lt`, SWAP bit-slice range lemmas | proved range block; independent of the later SWAP permutation bridge |
| `odbs_preimage_candidate_range` | `bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_cleanSource` | for a finite clean source in the one-term family, the clean reverse-index preimage candidate is below `qubitDim (oneTermRobinTotalQubits p)` | post-SWAP range, splice high-tail preservation, `bandedSparseAccessPaperCleanODValue_lt_two_pow_of_sparse_lt` | proved under explicit one-term hypotheses |
| `odbs_cleanup_witness_without_external_ranges` | `bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate_noRange` | instantiate the accepted cleanup witness without caller-supplied `hpostRange` and `hpreRange` | the two range lemmas above plus the accepted clean-source candidate audit | proved as a conditional witness; uniqueness and semantic cleanup remain open |

The lower packet must keep `daggerCleanup.proved`, both `O_D^BS` unitarity
flags, and block-correctness flags false.  If the SWAP range
lemma fails, record the exact failed bit-slice statement under
`proof-attempts/` and do not replace the target by another finite scan.

### 2026-05-23 Lower Update: Finite-Range Cleanup Inputs

Lean now proves the two range inputs needed by the clean-source candidate
cleanup witness.  `swapOracleImage_lt_qubitDim` proves that the SWAP image
preserves the full finite basis bound using the existing SWAP diff bound and
the register-width inequality.  Combining it with
`bandedSparseAccessPaperImage_lt_qubitDim_of_address_lt` gives
`bandedSparseAccessPaperPostSwapImage_lt_qubitDim_of_address_lt`.

For the candidate preimage, `bandedSparseAccessPaperSpliceODRegister_lt_qubitDim_of_odValue_lt`
packages the finite-range arithmetic for replacing the O_D register.  The
one-term reverse sparse index and clean O_D value are bounded by
`bandedSparseAccessPaperPostSwapReverseSparse_lt_two_pow` and
`bandedSparseAccessPaperPostSwapCleanODValue_lt_two_pow`; together they prove
`bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_cleanSource`.
The wrapper `bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate_noRange`
uses these range lemmas to call the prior conditional cleanup witness without
external `Fin` premises.  It still does not prove uniqueness, full
`daggerCleanup`, either O_D^BS unitarity flag, or block
correctness.

### 2026-05-23 Middle Sync: Boundary Unused Sparse Collision

Historical note, superseded on 2026-05-24: the earlier injectivity route was
blocked by a Lean-checked collision in the row-dependent address model:

```lean
theorem GHL2025.oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3
```

For the one-term parameters $n=3$ and $\kappa=7$, the source columns $0$ and
$48$ both satisfy `bandedSparseAccessPaperCleanInput`.  They have the same row
value $0$, but sparse indices $0$ and $3$.  Boundary row $0$ has only three
Robin stencil entries, so sparse index $3$ is an unused row-dependent branch
and the old `robinSparseColumnMap` helper returned address $0$ for both
branches.  The corrected active `bandedSparseAccessPaperImage` now uses the
global sparse-slot formula and sends those columns to distinct images.

This theorem remains regression memory for the rejected helper, not an active
paper-level blocker.  The active route must use
`bandedSparseAccessPaperGlobalSlotSource` and should next target a
global-source inverse-on-range or injectivity interface, with no proof-flag
promotion:

| Option | Lean-facing contract | Required audit |
|---|---|---|
| global-source inverse-on-range | prove a preimage/injectivity interface whose hypotheses use `bandedSparseAccessPaperGlobalSlotSource` | keep the row-dependent collision only as rejected-model memory |
| reversible extension outside encoded slot range | if needed, specify behavior for encoded sparse values with $s\ge\kappa$ | keep `forwardCorrect`, `daggerCleanup`, and unitarity flags false until the full finite permutation proof compiles |

The accepted lower packet must update this conversion window and
`proof-obligations/QBE-AUTO-002.md`, and it must keep
`oneTermRobinGate_O_D_BS.unitary.proved`,
`oneTermRobinGate_O_D_BS_dagger.unitary.proved`, and
`(defaultBandedSparseAccessPaperContract p).daggerCleanup.proved` false.

### 2026-05-23 Lower Update: Valid Sparse-Branch Domain Candidate

Lean now contains the row-dependent predicate
`GHL2025.robinSparseColumnBranchValid`.  It follows the five one-term Robin
stencil regions already used by `GHL2025.robinSparseColumnMap`: row $0$ has
three valid sparse branches, row $1$ has four, bulk rows have five, row
$N-2$ has four, and row $N-1$ has three.

The paper-column predicates
`GHL2025.bandedSparseAccessPaperValidSparseBranch` and
`GHL2025.bandedSparseAccessPaperValidCleanSource` lift this row-dependent
branch check to the Lemma 1 register extractor.  They are contract-audit
predicates only.  The active `bandedSparseAccessPaperMatrix`, dagger matrix,
gate list, and all semantic proof flags are unchanged.

The audit theorem
`GHL2025.bandedSparseAccessPaperValidCleanSource_separates_boundaryCollision_n3`
shows that the earlier collision columns `0` and `48` remain clean under
`bandedSparseAccessPaperCleanInput`, but the candidate corrected source domain
accepts column `0` and rejects column `48`.  This supports the
row-dependent-domain correction option.  It does not prove that the paper
states this restriction for all rows, and it does not prove injectivity,
cleanup, or unitarity.

### 2026-05-23 Middle Source-Contract Audit: Unused Branches

The paper source does not support using `bandedSparseAccessPaperValidCleanSource`
as the full faithful source domain by itself.  The relevant anchors are:

| Paper anchor | Contract effect |
|---|---|
| GHL2025, Lemma `Banded-sparse-access-oracle and resource cost`, arXiv:2506.20478v2 | Defines $\hat O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n = |r_{si}\rangle^n|i\rangle^n$ for a $2^l$-sparse banded matrix, with $s$ living in the padded sparse-index register. |
| GHL2025, Remark `sparsity maximum`, arXiv:2506.20478v2 | Uses the largest diagonal sparsity index for the Robin example. |
| GHL2025, one-term Robin construction before Theorem `One-term block-encoding`, arXiv:2506.20478v2 | States that zeros can be included in the set of nonzero elements, so the construction uses diagonal sparsity $\kappa$. |
| GHL2025, Eq. `ROBIN clarified`, arXiv:2506.20478v2 | Sums over $s=0,\dots,\kappa-1$ in the boundary and bulk wavefunction slices. |

Therefore the row-dependent valid-branch predicate is useful as an audit of
which branches carry nonzero Robin stencil data, but treating it as a hard
domain restriction would drop zero-amplitude sparse branches that the paper
keeps in the $\kappa$-wide register.  In faithful mode this is contract drift.

The current Lean state should be read as follows:

| Lean item | Faithful status |
|---|---|
| `robinSparseColumnBranchValid` | classifies nonzero row-dependent stencil branches; it is not the full Lemma 1 source domain |
| `bandedSparseAccessPaperValidCleanSource` | audit predicate, not wired into the active matrix |
| `oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3` | proves the current full clean-domain skeleton is not injective |
| `bandedSparseAccessPaperImage` | active Lemma 1 image skeleton on all clean padded sparse-register branches, but its unused-branch behavior is not yet a faithful unitary extension |

The next lower work should introduce a contract for the unused-branch extension
instead of proving injectivity for the current colliding skeleton.  The
extension must agree with Lemma 1 on branches represented by
`robinSparseColumnBranchValid`; for invalid zero-amplitude branches it must
record a separate injective, reversible image rule or keep that rule as an
explicit `proved := false` obligation.  It must not change
`oneTermRobinGate_O_D_BS`, `oneTermRobinGate_O_D_BS_dagger`, the gate list, or
any unitarity, dagger-cleanup, or block-correctness flag.

### Next Lower Packet: O_D^BS Unused-Branch Extension Contract

Allowed write scope:

| Path | Allowed edits |
|---|---|
| `QuantumBlockEncoding/GHL2025.lean` | add source-domain and unused-branch extension contract declarations only |
| `Tests/Basic.lean` | focused tests for the new contract fields and false proof flags |
| `conversion-windows/QBE-AUTO-002.md` and `proof-obligations/QBE-AUTO-002.md` | synchronize the contract map |
| `research-wiki/cited-results/GHL2025.md` | keep the cited-result status at `contract-only` or `obligation` |
| `proof-attempts/` | record failed fixed theorem attempts |

Do not edit `CircuitSemantics.lean`, `RobinMatrix.lean`, the active gate list,
or the legacy helper matrices in this packet.

Target declarations:

| Target | Required interface | Acceptance |
|---|---|---|
| unused-branch classifier | `bandedSparseAccessPaperUnusedSparseBranch p j` or equivalent | true exactly when the padded input is clean and the row-dependent sparse branch is invalid |
| extension contract record | `BandedSparseAccessUnusedBranchExtensionContract` or equivalent | records paper agreement on valid branches, unused-branch injectivity, full clean-domain injectivity, dagger cleanup, and unitary extension as `ObligationRecord` fields with `proved := false` |
| collision classification theorem | theorem over the $n=3,\kappa=7$ collision columns | column `0` is valid, column `48` is unused, both remain clean under `bandedSparseAccessPaperCleanInput`, and no proof flag changes |
| active-matrix guard tests | tests by `rfl` or `native_decide` | active forward/dagger matrices and all O_D^BS, SWAP, dagger-cleanup, and block-correctness flags remain unchanged |

The lower packet succeeds only if `python3 tools/qbe.py check`, `lake build`,
and `lake build Tests` pass.  It should also run the semantic-gap grep from the
task contract and report any hits without hiding them.

### 2026-05-23 Lower Update: Unused-Branch Extension Contract

Lean now has the first contract slot for the faithful unused-branch extension:
`bandedSparseAccessPaperUnusedSparseBranch` classifies columns that satisfy the
clean padded-register condition but fail the row-dependent nonzero-stencil
predicate.  The record `BandedSparseAccessUnusedBranchExtensionContract` stores
the current active image index plus false obligations for valid-branch
agreement, the unused-branch image rule, unused-branch injectivity, full
clean-domain injectivity, dagger cleanup, and unitary extension.

The theorem
`bandedSparseAccessUnusedBranchExtensionContract_boundaryCollision_n3` is now
historical rejected-model memory: for $n=3,\kappa=7$, column `0` is valid and
column `48` is excluded by the row-dependent valid-source predicate.  The
corrected active global-slot image separates those columns, so the old
collision must not be assigned as the active paper blocker.  The active forward
and dagger gate matrices, `daggerCleanup.proved`, both O_D^BS unitarity flags,
and block correctness remain unchanged and false where previously false.

The cleanup route also has narrow bridges
`bandedSparseAccessPostSwapCleanup_of_validCleanSourceCandidate_noRange` and
`bandedSparseAccessPostSwapCleanup_of_globalSlotSourceCandidate_noRange`.
The first is historical row-dependent audit memory.  The second is the active
global-source wrapper: it extracts the clean padded-register hypothesis from
`bandedSparseAccessPaperGlobalSlotSource` and reuses the existing cleanup
candidate wrapper.  It does not prove inverse uniqueness, semantic cleanup, or
O_D^BS unitarity.

### 2026-05-23 Middle Update: Unused-Branch Contract Bridge

Lean now also has
`bandedSparseAccessUnusedBranchExtensionContract_of_unusedBranch`.  This is a
small proof-DAG bridge for the next reversible-extension packet.  For any
column satisfying `bandedSparseAccessPaperUnusedSparseBranch p j = true`, it
packages the following facts:

| Fact | Status |
|---|---|
| the column is still in the clean padded-input domain | proved by the classifier bridge |
| the row-dependent valid sparse-branch classifier is false | proved by the classifier bridge |
| the contract marks this column as an unused sparse branch | proved by unfolding the contract |
| `unusedBranchImageRule`, `unusedBranchInjective`, `fullCleanDomainInjective`, `daggerCleanup`, and `unitaryExtension` | all remain `proved := false` |

This bridge does not choose a reversible image for the unused branch.  It only
prevents later work from treating an unused clean branch as either non-clean or
already handled by the valid-branch cleanup route.

### Superseded Lower Packet: O_D^BS Unused-Branch Image Rule

This lower packet is superseded by the 2026-05-24 global sparse-slot audit.  The
old row-dependent image collided on unused boundary branches, but the corrected
active image uses the global slot formula $r_{si}=r_{s0}+i \bmod 2^n$ and
separates the recorded boundary columns.  Future work should not select a
row-dependent unused-branch image rule as the active paper route.  If an image
rule is needed outside the encoded paper slot range $s<\kappa$, it must be
recorded separately from the global-source Lean contract.

Allowed write scope:

| Path | Allowed edits |
|---|---|
| `QuantumBlockEncoding/GHL2025.lean` | add only declarations for the unused-branch image-rule interface and its false obligations |
| `Tests/Basic.lean` | add focused classifier, false-flag, and active-matrix guard tests |
| `conversion-windows/QBE-AUTO-002.md`, `proof-obligations/QBE-AUTO-002.md`, and `research-wiki/cited-results/GHL2025.md` | synchronize the contract map and cited-results status |
| `proof-attempts/` | record a failed fixed image-rule theorem if Lean exposes an obstruction |

Required contract shape:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `odbs_unused_branch_classifier_bridge` | expose clean-input, invalid-branch, unused-branch, and false extension fields from the unused classifier | `bandedSparseAccessPaperUnusedSparseBranch` | `bandedSparseAccessUnusedBranchExtensionContract_of_unusedBranch` | unused image rule, injectivity audit | O_D^BS | proved contract bridge; no flag promotion |
| `odbs_unused_branch_image_rule` | specify or leave explicit the reversible image rule for clean invalid sparse branches | classifier bridge, source audit for zero-amplitude branches | `BandedSparseAccessUnusedBranchImageRuleContract`, `bandedSparseAccessUnusedBranchImageRuleContract` | full clean-domain injectivity, dagger cleanup | O_D^BS | interface defined with `proposedImageIndex = none`; proof flags false; no active matrix rewrite |
| `odbs_valid_branch_agreement` | prove the extension agrees with Lemma 1 on valid sparse branches | `bandedSparseAccessPaperValidCleanSource`, active paper image | planned agreement theorem or obligation field | final O_D^BS cleanup route | O_D^BS | obligation |

The lower packet must not prove injectivity, unitarity, dagger cleanup, or block
correctness by using the current colliding active image.  If no faithful image
rule can be justified from the paper, record that as an obligation rather than
choosing a replacement construction.

### Lower Update: Unused-Branch Image-Rule Interface

Lean now defines `BandedSparseAccessUnusedBranchImageRuleContract` and
`bandedSparseAccessUnusedBranchImageRuleContract`.  The contract exposes the
source column, extracted registers, current active image, and branch
classification, but keeps `proposedImageIndex = none` because this cycle did
not identify a paper-backed reversible image for unused branches.

The theorem `bandedSparseAccessUnusedBranchImageRuleContract_flags_false`
pins the image-rule, finite-image, collision-separation, and valid-branch
agreement fields at `proved = false`.  The theorem
`bandedSparseAccessUnusedBranchImageRuleContract_of_unusedBranch` bridges the
unused-branch classifier into this image-rule interface.  The existing
`BandedSparseAccessUnusedBranchExtensionContract` now carries this nested
image-rule contract, while `bandedSparseAccessPaperImage`,
`bandedSparseAccessPaperMatrix`, and both active O_D^BS gates are unchanged.

### 2026-05-23 Middle Sync: Full Clean-Domain Contract Packet

The per-column image-rule interface is now synchronized.  The next lower packet
should lift it into a paper-level full clean-domain contract, not into a proof
of injectivity.  The source contract remains GHL2025 Lemma 1:

$$
O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n
=
|r_{si}\rangle^n|i\rangle^n .
$$

The paper also keeps zero-amplitude sparse branches inside the $\kappa$-wide
register in the one-term Robin construction, so the wrapper must track both
valid row-dependent branches and clean unused branches.  No cited sparse-oracle
completion theorem has been recorded.  Therefore the wrapper must keep the
unused-branch image formula unspecified and all semantic fields false.

Allowed write scope for lower:

| Path | Allowed edits |
|---|---|
| `QuantumBlockEncoding/GHL2025.lean` | add a paper-level full clean-domain extension contract wrapper only; do not rewrite `bandedSparseAccessPaperImage`, matrices, gates, or proof flags |
| `Tests/Basic.lean` | add focused false-flag, nested-contract, and active-matrix guard tests |
| `conversion-windows/QBE-AUTO-002.md`, `proof-obligations/QBE-AUTO-002.md`, `paper-notes/GHL2025_RobinOneTerm.tex`, `research-wiki/cited-results/GHL2025.md` | synchronize the contract map and cited-results status |
| `proof-attempts/` | record any failed fixed theorem attempt if the wrapper proof exposes a reusable subgoal |

Accepted Lean-facing contract:

| Target | Required interface | Acceptance |
|---|---|---|
| full clean-domain wrapper record | `structure BandedSparseAccessFullCleanDomainExtensionContract` | fields include the Lemma 1 source anchor, classifier names for `cleanInput`, `validSparseBranch`, `validCleanSource`, `unusedSparseBranch`, per-column nested contracts, and `ObligationRecord` fields for valid-branch agreement, unused-branch image specified/finite, unused-branch injectivity, full clean-domain injectivity, dagger cleanup, and unitary extension |
| default wrapper | `def bandedSparseAccessFullCleanDomainExtensionContract (p : OneTermRobinParameters)` | reuses the existing per-column classifiers and contracts; keeps every unused-branch image unspecified through nested `proposedImageIndex = none`; active O_D^BS matrix declarations are unchanged |
| false-flag theorem | `theorem bandedSparseAccessFullCleanDomainExtensionContract_flags_false` | proves every new semantic obligation has `proved = false`; also exposes that the nested image-rule contract still has `proposedImageIndex = none` and false image-rule flags |
| guard theorem or tests | focused tests in `Tests/Basic.lean` | pin `(oneTermRobinGate_O_D_BS p).unitary.proved = false`, `(oneTermRobinGate_O_D_BS_dagger p).unitary.proved = false`, `(defaultBandedSparseAccessPaperContract p).daggerCleanup.proved = false`, and that active matrices still use `bandedSparseAccessPaperMatrix` and `bandedSparseAccessPaperDaggerMatrix` |

If the lower packet wants to use a general reversible-extension theorem to fill
the unused branches, it must first add a new cited-results ledger entry with
status `paper-cited`, `classic-unformalized`, or `obligation`.  Without that
source, the full clean-domain wrapper is only an explicit obligation map.

### 2026-05-23 Middle Sync: Full Clean-Domain Wrapper Accepted

The lower result now matches the requested Phase 1 contract shape.  Lean defines
`BandedSparseAccessFullCleanDomainExtensionContract` and
`bandedSparseAccessFullCleanDomainExtensionContract`; the wrapper combines the
clean padded-input predicate, the valid nonzero-stencil branch classifier, the
unused-branch classifier, the nested unused-branch image-rule contract, and
paper-level obligations for agreement, finite images, injectivity, dagger
cleanup, and unitary extension.

The accepted wrapper does not choose an image for unused zero-amplitude sparse
branches.  The nested image-rule contract still has
`proposedImageIndex = none`, and
`bandedSparseAccessFullCleanDomainExtensionContract_flags_false` proves that
all new semantic fields remain `proved = false`.  The bridge
`bandedSparseAccessFullCleanDomainExtensionContract_of_unusedBranch` only
translates an unused-branch classifier proof into the wrapper interface; it
does not repair the active-image collision.

| Accepted item | Lean declaration | Status |
|---|---|---|
| full clean-domain wrapper | `BandedSparseAccessFullCleanDomainExtensionContract`, `bandedSparseAccessFullCleanDomainExtensionContract` | defined obligation map |
| false-flag guard | `bandedSparseAccessFullCleanDomainExtensionContract_flags_false` | proved; no proof-flag promotion |
| unused-branch wrapper bridge | `bandedSparseAccessFullCleanDomainExtensionContract_of_unusedBranch` | proved classifier bridge; no image formula |
| local clean-domain split | `bandedSparseAccessPaperCleanDomainSplit_iff`, `bandedSparseAccessPaperCleanDomainSplit_disjoint`, `bandedSparseAccessFullCleanDomainExtensionContract_localCleanDomainSplit` | clean padded input splits into valid or unused branches; semantic `cleanDomainSplit.proved` remains false |
| active matrix guard | tests in `Tests/Basic.lean` | forward/dagger matrices still use `bandedSparseAccessPaperMatrix` and `bandedSparseAccessPaperDaggerMatrix` |

Next lower work should not attempt O_D^BS injectivity, unitarity, dagger cleanup,
or block correctness until a paper-backed unused-branch image formula or a
recorded external reversible-extension result exists in
`research-wiki/cited-results/GHL2025.md`.

---

## 2026-05-23 Middle Dependency Decision: Unused Zero-Amplitude Branches

This cycle performs the source-contract audit requested by upper.  The
decision is a human-blocking obligation, not a proof-search packet.  The
current public source anchors are GHL2025 Lemma 1 and Fig. 1-term Robin,
arXiv:2506.20478, plus the QBE source-domain audit that zero-amplitude sparse
branches remain inside the $\kappa$-wide sparse register in the one-term Robin
construction.

The accepted dependency status is recorded in
`research-wiki/cited-results/GHL2025.md` as
`QBE.ODBS.UnusedZeroBranchExtension` with status `obligation`.  No external
reversible-extension theorem is accepted for this step.  Therefore no lower
agent should use a generic completion theorem, injectivity argument, or
permutation-matrix route to close O_D^BS until a human supplies an exact source
or approves a new cited result.

The source-dependency classification for the imported sparse-access primitive is
`external-cited-result`.  GHL2025 Lemma 1 cites the prior PDE block-encoding
paper by Guseynov, Huang, and Liu, "Efficient explicit gate construction of
block-encoding for Hamiltonians needed for simulating partial differential
equations", arXiv:2405.12855v3 and Phys. Rev. Research 7, 033100 (2025).  The
ledger row `GHL2024.PDE.Def6Lemma1.ODBS` records that Definition 6 and Lemma 1
of the prior paper supply the same padded-register map and resource-count
primitive.  That prior result still does not supply a Robin-specific reversible
image for clean unused zero-amplitude sparse branches, so it does not change the
blocked status of `QBE.ODBS.UnusedZeroBranchExtension`.

Required Lean-facing state:

| Item | Required state |
|---|---|
| source decision record | `bandedSparseAccessUnusedZeroBranchSourceDecision.lowerProofSearchAllowed = false` and `dependency.proved = false` |
| prior PDE source transcript | `bandedSparseAccessPriorPDESourceContract` records arXiv:2405.12855v3 Definition 6, Lemma 1, and the appendix decomposition; `robinUnusedBranchImageRule = none` |
| active forward matrix | `oneTermRobinGate_O_D_BS p`.matrix remains `bandedSparseAccessPaperMatrix p` |
| active dagger matrix | `oneTermRobinGate_O_D_BS_dagger p`.matrix remains `bandedSparseAccessPaperDaggerMatrix p` |
| unused-branch image choice | `BandedSparseAccessUnusedBranchImageRuleContract.proposedImageIndex = none` |
| image-rule proof-search guard | `bandedSparseAccessUnusedZeroBranchSourceDecision_keepsImageRuleUnspecified` ties `lowerProofSearchAllowed = false` to the direct and wrapper image-rule slots remaining `none` with false image obligations |
| paper-contract proof-search guard | `bandedSparseAccessUnusedZeroBranchSourceDecision_keepsPaperContractFlagsFalse` ties `lowerProofSearchAllowed = false` to `forwardCorrect`, `daggerCleanup`, and `unitaryExtension` staying false in `defaultBandedSparseAccessPaperContract p` |
| theorem-route proof-search guard | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsNoLowerProofSearch` ties the theorem route to the direct and wrapper image-rule slots remaining `none`, while block correctness and O_D^BS contract flags remain false |
| full clean-domain wrapper | all semantic fields in `BandedSparseAccessFullCleanDomainExtensionContract` remain `proved = false` |
| O_D^BS flags | forward correctness, dagger cleanup, and both O_D^BS unitarity flags remain `false` |
| block extraction | `blockProjection.proved` and `blockCorrect.proved` remain `false` |

Proof-DAG dependency row:

| Block | Interface | Paper source | Lean declaration | Depends on | Reused by | Status |
|---|---|---|---|---|---|---|
| `odbs_unused_zero_branch_source_decision` | decide whether clean zero-amplitude sparse branches have a faithful reversible image rule, or mark the dependency as human-blocking | GHL2025 Lemma 1 and Fig. 1-term Robin, arXiv:2506.20478; prior-paper row `GHL2024.PDE.Def6Lemma1.ODBS`; cited-results row `QBE.ODBS.UnusedZeroBranchExtension` | `BandedSparseAccessUnusedZeroBranchSourceDecision`, `bandedSparseAccessUnusedZeroBranchSourceDecision`, `bandedSparseAccessUnusedZeroBranchSourceDecision_flags_false`, `bandedSparseAccessUnusedZeroBranchSourceDecision_keepsImageRuleUnspecified`, `bandedSparseAccessUnusedZeroBranchSourceDecision_keepsPaperContractFlagsFalse`, `BandedSparseAccessPriorPDESourceContract`, `bandedSparseAccessPriorPDESourceContract`, `bandedSparseAccessPriorPDESourceContract_blocks_unusedZeroBranch`, `BandedSparseAccessUnusedBranchImageRuleContract.proposedImageIndex`, `BandedSparseAccessFullCleanDomainExtensionContract.unusedBranchImageSpecified`, `BandedSparseAccessFullCleanDomainExtensionContract.fullCleanDomainInjective`, `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsNoLowerProofSearch` | source-domain audit, unused-branch classifier, full clean-domain wrapper | O_D^BS injectivity, dagger cleanup, unitary extension, final block extraction | obligation; prior PDE Definition 6, Lemma 1, and appendix decomposition are now compiled as a source transcript for the sparse-access primitive; the transcript has `robinUnusedBranchImageRule = none`, so compiled guards keep `lowerProofSearchAllowed = false`, direct/wrapper image-rule slots unspecified, and paper-level `forwardCorrect`, `daggerCleanup`, and `unitaryExtension` flags false |

Lower-agent packet status:

| Scope | Instruction |
|---|---|
| Lean edits | none assigned for injectivity, dagger cleanup, unitarity, or block extraction |
| Allowed future source packet | add only a cited-results-backed image-rule contract for unused zero-amplitude sparse branches, then keep all proof flags false until reviewer accepts the source contract |
| Disallowed route | do not prove a permutation/unitarity theorem over the current colliding active image; `oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3` remains the guard |
| Required gate for any future Lean packet | `python3 tools/qbe.py check` plus `lake build && lake build Tests` |

This resolves the cycle-14 middle responsibility: the current state is
synchronized as a blocked dependency decision rather than an executable lower
proof target.

---

## 2026-05-23 Middle Contract: Theorem-Level Proof Route

This cycle adds a Phase 1 theorem-level route record.  The record is a
transcript object: it ties existing Lean declarations together and keeps the
block-encoding theorem in obligation mode.  It does not change any active gate
matrix, source decision, normalizer, or proof flag.

Definitions used by the route:

| Paper object | Lean declaration | Status |
|---|---|---|
| one-term theorem tuple $(\alpha,m,0)$ | `GHL2025.defaultOneTermRobinTheoremData (oneTermParameters n)` | recorded; theorem obligations false |
| normalizer $\alpha=N_DN_f\kappa$ | `GHL2025.oneTermRobinNormalizer` | wired to theorem data and block target |
| seven-gate circuit product | `Examples.RobinHeat.oneTermRobinCircuitSemantics n` | compiled circuit matrix product |
| signal-index-zero block target | `Examples.RobinHeat.oneTermRobinBlockExtractionTarget n` | target matrix and normalizer wired; block flags false |
| circuit block claim | `Examples.RobinHeat.defaultOneTermRobinCircuitBlockClaim n` | dimension split proved; block correctness false |
| theorem proof-route contract | `Examples.RobinHeat.OneTermRobinBlockEncodingProofRoute` | defined |
| default route | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n` | defined |
| normalizer bridge | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_normalizer` | proved by stored route field |
| block-target bridge | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_blockTarget` | proves the route reuses `oneTermRobinBlockExtractionTarget n`, the same circuit semantics object, target `robinDerivativeMatrix n`, and signal index $0$ |
| false-flag guard | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_flags_false` | proved; no semantic flag promoted |
| O_D^BS source-blocker guard | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsSourceBlockers` | proved; packages the unused-branch source decision, prior PDE transcript, and false O_D^BS contract flags |
| O_D^BS route source-transcript identity | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_sourceTranscriptIdentity` | proved; route uses exactly the audited unused-zero-branch decision, prior PDE transcript, and Robin zero-inclusion transcript, with lower proof search disabled |
| prior PDE transcript guard | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_priorPDESourceTranscript` | proved; uses the prior PDE source only for the padded sparse-access equation, keeps its resource claim unproved, keeps `robinUnusedBranchImageRule = none`, and keeps lower proof search disabled |
| O_D^BS no-lower-proof-search guard | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsNoLowerProofSearch` | proved; ties the disabled source decision to direct and wrapper `proposedImageIndex = none`, while block correctness and O_D^BS contract flags remain false |

The route records the active dependency blockers:

| Dependency | Lean field in the route | Required state |
|---|---|---|
| O_D^BS paper contract | `sparseAccessContract` | `forwardCorrect`, `daggerCleanup`, and `unitaryExtension` stay false |
| unused zero-amplitude sparse branches | `unusedZeroBranchDecision` | `lowerProofSearchAllowed = false` |
| prior PDE sparse-access source | `priorSparseAccessSource` | only the padded sparse-access equation is imported; `resourceClaim.proved = false`, `robinUnusedBranchImageRule = none`, and `closesUnusedZeroBranchExtension = false` |
| O_f cited amplitude theorem | `functionOracleSource` | `closesFunctionOracleContract = false` |
| function-oracle contract | `oracleComposition.functionOracle.amplitudeCorrect` | `proved = false` |
| LCU/block composition | `oracleComposition.lcuCorrect` | `proved = false` |
| theorem-level block extraction | `theoremData.obligations.blockExtraction` | `proved = false` |
| matrix block target | `blockClaim.target.blockProjection`, `blockClaim.target.blockCorrect` | both `proved = false` |

Proof-DAG row:

| Block | Interface | Paper source | Lean declaration | Depends on | Reused by | Status |
|---|---|---|---|---|---|---|
| `one_term_robin_theorem_route` | package the theorem tuple, circuit product, block target, normalizer, active oracle contracts, and cited blockers into one Lean route | GHL2025 one-term theorem and Fig. 1-term Robin, arXiv:2506.20478; cited-results rows `GHL2025.Lemma1.ODBS`, `GHL2024.PDE.Def6Lemma1.ODBS`, `QBE.ODBS.UnusedZeroBranchExtension`, `GL2024.Thm5.AmplitudeOracle`, `LCU.StandardBlockEncoding` | `OneTermRobinBlockEncodingProofRoute`, `oneTermRobinBlockEncodingProofRoute`, `oneTermRobinBlockEncodingProofRoute_normalizer`, `oneTermRobinBlockEncodingProofRoute_blockTarget`, `oneTermRobinBlockEncodingProofRoute_flags_false`, `oneTermRobinBlockEncodingProofRoute_odbsSourceBlockers`, `oneTermRobinBlockEncodingProofRoute_sourceTranscriptIdentity`, `oneTermRobinBlockEncodingProofRoute_priorPDESourceTranscript`, `oneTermRobinBlockEncodingProofRoute_odbsNoLowerProofSearch` | circuit semantics, block extraction target, O_D^BS source decision, O_f source contract, oracle composition | final one-term block-extraction proof and reviewer audit | compiled contract; all semantic blockers remain false |

Lower-agent packet status:

| Scope | Instruction |
|---|---|
| Completed Lean scope | `QuantumBlockEncoding/RobinMatrix.lean` and focused tests in `Tests/Basic.lean` |
| Disallowed promotion | no O_D^BS, O_f, LCU, circuit-unitary, block-projection, or block-correctness flag may be flipped from this route |
| Next lower proof target | none for O_D^BS injectivity, cleanup, unitarity, or final block extraction until the unused zero-branch source decision changes |
| Allowed O_D^BS follow-up | source-contract packet only: add a cited-results-backed unused-branch image rule or exact reversible-extension theorem, with all semantic flags still false pending reviewer acceptance |
| Allowed nonblocked follow-up | completed SWAP proof-DAG packet below, or a block-projection source-contract packet that only records indices and false flags |

### Completed Lower Packet: SWAP Self-Inverse Proof-DAG

This accepted Phase 1 wiring task is independent of the
blocked O_D^BS unused-branch source decision and independent of the O_f
amplitude theorem.

| Field | Contract |
|---|---|
| target block | `swap_self_inverse` |
| accepted Lean names | `GHL2025.swapOracleDiff`, `GHL2025.swapOracleImage_eq_xor_diff`, `GHL2025.swapOracleDiff_preserved`, `GHL2025.xor_two_shifted_masks_cancel`, `GHL2025.swapOracleImage_self_inverse` |
| allowed edits | `QuantumBlockEncoding/GHL2025.lean`, focused tests in `Tests/Basic.lean`, and synchronized SWAP notes if declarations are added |
| reusable inputs | `swapOracleImage_block1_eq_block2`, `swapOracleImage_block2_eq_block1`, `swapOracleImage_lt_qubitDim`, `swapOracleDiff_lt_two_pow`, `swapOracleDiff_shiftRight_eq_zero`, `swapOracleDiff_shiftLeft_mask_eq_zero`, and the U_indic self-inverse/bijection proof pattern |
| forbidden edits | no O_D^BS injectivity, cleanup, unitary extension, final block extraction, O_f analytic closure, LCU closure, or cited-result status upgrades |
| proof-flag policy | satisfied for this packet: the self-inverse block did not promote the SWAP flag; the later finite permutation bridge is the promotion point |
| build gate | `python3 tools/qbe.py check`; forbidden-pattern scan unchanged |

### Completed Lower Packet: SWAP Finite-Domain Permutation Bridge

This nonblocked Phase 1 wiring task is a Lean-local `classical-lean-lemma`
route over the existing SWAP image function and matrix.  It does not use an
external SWAP theorem and does not modify any oracle contract.

| Field | Contract |
|---|---|
| target block | `swap_finite_permutation_bridge` for `GHL2025.swapOracleImage` and `GHL2025.swapOracleMatrix` |
| accepted Lean names | `GHL2025.swapOracleImage_injective`, `GHL2025.swapOracleImage_bijective`, `GHL2025.swapOracleMatrix_col_has_one`, `GHL2025.swapOracleMatrix_col_unique`, `GHL2025.swapOracleMatrix_row_has_one`, `GHL2025.swapOracleMatrix_row_unique`, `GHL2025.swapOracleMatrix_is_permutation` |
| reusable inputs | `swapOracleImage_self_inverse`, `swapOracleImage_lt_qubitDim`, `swapOracleMatrix_eq_image`, `swapOracleDiff_preserved`, `xor_two_shifted_masks_cancel`, and the accepted U_indic bijection-to-permutation bridge |
| allowed edits | `QuantumBlockEncoding/GHL2025.lean`, focused tests in `Tests/Basic.lean`, and synchronized SWAP notes if declarations are added |
| forbidden edits | no O_D^BS injectivity, cleanup, unitary extension, final block extraction, O_f analytic closure, LCU closure, or cited-result status upgrades |
| proof-flag policy | row/column uniqueness and `swapOracleMatrix_is_permutation` compile, so `(GHL2025.oneTermRobinGate_SWAP p).unitary.proved = true`; O_D^BS, O_f, LCU, block-projection, and block-correctness flags remain false |
| build gate | `python3 tools/qbe.py check`; forbidden-pattern scan unchanged |

### Middle Cycle 1 Handoff: Source-Contract Gate After SWAP

The current Lean-to-paper translation is synchronized as follows.

| Item | Current state |
|---|---|
| SWAP | `swapOracleMatrix_is_permutation` is compiled and `(oneTermRobinGate_SWAP p).unitary.proved = true` |
| O_D^BS paper map | GHL2025 Lemma 1 is represented by `BandedSparseAccessPaperContract`, `bandedSparseAccessPaperImage`, and `bandedSparseAccessPaperMatrix` |
| O_D^BS cleanup | Fig. 1-term Robin cleanup by `(O_D^BS)^\dagger` remains `daggerCleanup.proved = false` |
| unused zero-amplitude sparse branches | `bandedSparseAccessUnusedZeroBranchSourceDecision.lowerProofSearchAllowed = false`; the image rule is still `proposedImageIndex = none` |
| prior sparse-access primitive | `GHL2024.PDE.Def6Lemma1.ODBS` is recorded as `external-cited-result`/`obligation`; it does not close the Robin unused-branch extension |
| theorem-level route | `oneTermRobinBlockEncodingProofRoute_flags_false` keeps block projection, block correctness, O_D^BS cleanup/unitarity, O_f amplitude correctness, and LCU composition false |

Source-dependency classification:

| Blocked step | Classification | Reason | Next allowed packet |
|---|---|---|---|
| O_D^BS unused zero-amplitude branch image | `source-contract-gap` with an `external-cited-result` dependency already recorded | GHL2025 Lemma 1 and the cited PDE primitive state the padded-register map but do not specify a Robin-specific reversible image rule for clean invalid sparse branches | source-backed contract only; no injectivity, cleanup, unitarity, or final block-extraction proof search |
| SWAP permutation | `classical-lean-lemma` | the proof is local finite-domain bit arithmetic over the existing SWAP image | complete |
| theorem-level block extraction | `internal-paper-step` plus unclosed oracle/composition obligations | the paper theorem depends on O_D^BS cleanup, O_f amplitude correctness, and LCU/block composition | block-projection index audit may proceed with false flags; correctness proof may not |

The next lower packet should therefore either add a precise cited source for an
unused-branch image rule, or audit the existing block-projection indices and
normalizer wiring without promoting any semantic flags.  No lower agent should
continue proof search for O_D^BS injectivity, dagger cleanup, gate unitarity, or
final block extraction while the source decision keeps proof search disabled.

---

## 2026-05-23 Middle Packet: Block-Projection Index Audit

This packet translates the upper cycle instruction into a fixed Lean-facing
contract.  It is a source-contract and indexing audit only.  It must not prove
the block equation or change any oracle semantic flag.

Definitions for the audit:

| Object | Lean declaration | Meaning |
|---|---|---|
| system dimension $N$ | `gridSize n` | row and column dimension of the Robin matrix |
| signal dimension $S$ | `qubitDim (GHL2025.effectiveRobinSignalQubits (oneTermParameters n))` | all non-system qubits in the one-term circuit |
| full circuit matrix | `(Examples.RobinHeat.oneTermRobinCircuitSemantics n).matrix` | product of the seven active gate matrices |
| signal index | `(Examples.RobinHeat.oneTermRobinBlockExtractionTarget n).signalIndex` | fixed to value `0` |
| block row index | `signalSystemBlockRowIndex N signalIndex.val i` | reads the row at offset `signalIndex.val * N + i` |
| block column index | `signalSystemBlockColIndex N signalIndex.val j` | reads the column at offset `signalIndex.val * N + j` |
| block projection | `signalSystemBlockProjection S N N` | uses the row and column index helpers for the selected signal block |
| target matrix | `Examples.RobinHeat.robinDerivativeMatrix n` | the one-term Robin derivative matrix |
| normalizer | `GHL2025.oneTermRobinNormalizer` | symbolic $N_DN_f\kappa$ |

Source-dependency classification:

| Blocked or audited step | Classification | Reason | Next action |
|---|---|---|---|
| block-index convention | `internal-paper-step` | the one-term theorem and Fig. 1-term Robin specify a signal-state block of the composed circuit | keep the signal-index-zero convention pinned by definitional Lean bridges and tests |
| dimension factorization | `classical-lean-lemma` | it is arithmetic over `qubitDim`, `gridSize`, and the register partition | reuse `Examples.RobinHeat.oneTermRobinCircuitDimCompat`; do not create a second dimension convention |
| final block equality | `internal-paper-step` with unclosed dependencies | the equality depends on O_D^BS cleanup, O_f amplitude correctness, and LCU/block-composition obligations | keep `blockProjection.proved = false` and `blockCorrect.proved = false` |
| O_D^BS cleanup needed by the block proof | `source-contract-gap` plus recorded `external-cited-result` | the unused zero-amplitude branch image rule remains unspecified | do not assign injectivity, cleanup, unitarity, or block-extraction proof search |

Lower-agent packet:

| Field | Instruction |
|---|---|
| fixed target | audit `Examples.RobinHeat.oneTermRobinBlockExtractionTarget` and `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute` |
| allowed write scope | `QuantumBlockEncoding/RobinMatrix.lean`, `Tests/Basic.lean`, `conversion-windows/QBE-AUTO-002.md`, `proof-obligations/QBE-AUTO-002.md` |
| preferred Lean additions | only missing `rfl` bridge lemmas or focused tests showing the full matrix, block matrix, signal index, target matrix, normalizer, and false flags are wired to the existing declarations |
| declarations to reuse | `oneTermRobinCircuitSemantics`, `oneTermRobinCircuitDimCompat`, `oneTermRobinBlockExtractionTarget`, `defaultOneTermRobinCircuitBlockClaim`, `oneTermRobinBlockEncodingProofRoute`, `oneTermRobinBlockEncodingProofRoute_flags_false`, `oneTermRobinBlockEncodingProofRoute_odbsSourceBlockers` |
| forbidden edits | no changes to `bandedSparseAccessPaperImage`, active O_D^BS matrices, O_f analytic contracts, LCU contracts, signal-index convention, target matrix, or normalizer |
| forbidden promotions | keep block projection, block correctness, O_D^BS forward/cleanup/unitary extension, O_f amplitude correctness, and LCU correctness false |
| acceptance | `python3 tools/qbe.py check`, `lake build`, `lake build Tests`, and the forbidden-pattern scan pass |

Current middle audit result: the requested bridge shape is already present in
Lean through `oneTermRobinBlockEncodingProofRoute` and the focused tests in
`Tests/Basic.lean`.  The 2026-05-23 lower packet added named generic row and
column index helpers in `CircuitSemantics.lean` so this convention has a
direct Lean declaration.  It may not continue from this packet into correctness
proof search.

---

## 2026-05-23 Middle Closeout: Source-Contract Gate

The cycle closes as a blocked faithful-paper source-contract state.  The local
TeX audit confirms the public anchors already used in this window: GHL2025
Lemma 1 states the padded sparse-access map

$$
O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n
=
|r_{si}\rangle^n|i\rangle^n,
$$

and the Fig. 1-term Robin discussion says that $(O_D^{BS})^\dagger$ returns
the upper register to sparse-index form and restores the
$n-\lceil\log_2\kappa\rceil$ padded qubits to $|0\rangle$.  Neither GHL2025
nor the cited prior PDE primitive currently supplies a Robin-specific
reversible image rule for clean unused zero-amplitude sparse branches.

No lower proof-search packet is assigned for O_D^BS injectivity, dagger
cleanup, unitarity, LCU closure, or final block extraction.  The only allowed
future O_D^BS packet is a source-contract packet that first adds an exact
cited theorem or paper-backed image formula for the unused branches, with all
semantic flags still false until reviewer acceptance.

Required synchronized state:

| Item | Lean/public anchor | Required state |
|---|---|---|
| unused-branch blocker | `research-wiki/cited-results/GHL2025.md` row `QBE.ODBS.UnusedZeroBranchExtension` | `obligation` |
| proof-search gate | `bandedSparseAccessUnusedZeroBranchSourceDecision` | `lowerProofSearchAllowed = false` |
| image-rule choice | `BandedSparseAccessUnusedBranchImageRuleContract.proposedImageIndex` | `none` |
| theorem route | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_flags_false`, `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsNoLowerProofSearch` | block projection, block correctness, O_D^BS cleanup/unitarity, O_f amplitude, and LCU flags false; direct and wrapper unused-branch image choices remain `none` |
| active O_D^BS matrices | `oneTermRobinGate_O_D_BS`, `oneTermRobinGate_O_D_BS_dagger` | still use `bandedSparseAccessPaperMatrix` and `bandedSparseAccessPaperDaggerMatrix` |

This is a source-contract gap with an external cited-result transcript already
recorded.  It is not a `classical-lean-lemma` target, so repeating tactic
search on the current colliding active image would be contract drift.

## 2026-05-23 Middle Audit Refresh: No Lower Packet

Middle refreshed the source audit against GHL2025 Lemma
`lemma: Banded-sparse-access`, Theorem `theorem: 1 term robin`, Eq.
`eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, and bibliography key
`guseynov2024efficientPDE` before assigning any further lower work.  The public
source contract remains:

$$
O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n
=
|r_{si}\rangle^n|i\rangle^n .
$$

The Robin figure requires $(O_D^{BS})^\dagger$ to restore the sparse-index
form and the padded zero ancillas, but neither GHL2025 nor the cited PDE
primitive gives an image rule for clean unused zero-amplitude sparse branches.

Source-dependency classification:

| Blocked proof block | Classification | Recorded dependency | Next action |
|---|---|---|---|
| O_D^BS unused-branch image rule | `source-contract-gap` | `QBE.ODBS.UnusedZeroBranchExtension` | keep proof search disabled until an exact source-backed image rule or reversible-extension theorem is added |
| imported sparse-access primitive | `external-cited-result` | `GHL2024.PDE.Def6Lemma1.ODBS` | use only as the padded-register transcript and resource source |
| SWAP/unit-index arithmetic | `classical-lean-lemma` | local Lean blocks such as `swapOracleMatrix_is_permutation` | complete for this cycle |

No new lower packet is issued from this refresh.  The next lower assignment may
only audit source text or add a cited-results-backed contract; it must not try
O_D^BS injectivity, dagger cleanup, unitarity, LCU closure, or final block
extraction while `bandedSparseAccessUnusedZeroBranchSourceDecision` keeps
`lowerProofSearchAllowed = false`.

## 2026-05-23 Lower Addendum: Claim-Level Block Guard

The lower audit added one structural guard for the block-projection route.  The
paper theorem route already pinned the target object
`oneTermRobinBlockExtractionTarget n`; the new guard also pins the separate
`CircuitBlockEncodingClaim.blockCorrect` field, so the route cannot silently
promote the circuit-level block claim while the target-level projection and
block equation remain open.

| Item | Lean declaration | Status |
|---|---|---|
| circuit-claim block flag | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_claimBlockCorrectFalse` | proved by route fields and `rfl`; records `blockClaim.blockCorrect.proved = false` |
| target block projection | same guard | remains `blockProjection.proved = false` |
| target block equation | same guard | remains `blockCorrect.proved = false` |
| focused test | `Tests/Basic.lean` theorem-route example | checks the three false flags together |
| signal-zero row/column offsets | `Examples.RobinHeat.oneTermRobinBlockExtractionTarget_signalZeroBlockIndices`, `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_signalZeroBlockIndices` | proved from the signal-index-zero route field; the selected signal block uses row offset `i` and column offset `j` |

This addendum does not change the signal-index convention, target matrix,
normalizer, active gate matrices, O_D^BS contract, O_f contract, LCU contract,
or any semantic proof flag.

---

## 2026-05-23 Middle Final Audit: O_D^BS Source Gate

Middle re-read the GHL2025 source anchors for the current blocker before
issuing any lower work: Lemma `lemma: Banded-sparse-access`, Theorem
`theorem: 1 term robin`, Eq. `eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`,
and bibliography key `guseynov2024efficientPDE`.  The public source contract is
still the Lemma 1 padded-register equation

$$
O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n
=
|r_{si}\rangle^n|i\rangle^n.
$$

The Robin figure text requires $(O_D^{BS})^\dagger$ to return the upper
register to sparse-index form and restore the $n-\lceil\log_2\kappa\rceil$
padded qubits to $|0\rangle$.  The source does not give an image formula for
clean unused zero-amplitude sparse branches, and the cited prior PDE primitive
only supplies the same padded-register sparse-access transcript and resource
claim.

Source-dependency classification:

| Blocked proof block | Classification | Recorded dependency | Middle decision |
|---|---|---|---|
| unused zero-amplitude sparse-branch image rule | `source-contract-gap` | `QBE.ODBS.UnusedZeroBranchExtension` | no lower proof search |
| imported banded sparse-access primitive | `external-cited-result` | `GHL2024.PDE.Def6Lemma1.ODBS` | transcript only; does not close Robin unused branches |
| block-projection index convention | `internal-paper-step` plus local arithmetic | existing signal-zero route guards | may be audited with false flags only |

No lower packet is issued for $O_D^{BS}$ injectivity, dagger cleanup, unitarity,
LCU closure, or final block extraction.  A future lower packet may only add a
source-backed unused-branch image-rule contract or a cited reversible-extension
theorem, and it must keep the active semantic flags false until reviewer
accepts the source contract.

## 2026-05-23 Lower Addendum: Route Circuit Product Guard

The lower audit added
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_circuitProduct`.  The
guard pins the theorem-level route to the active circuit-semantics object:
`GHL2025.oneTermRobinCircuit`, the seven-gate matrix list
`GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters n)`, the
compiled gate-list match, and the matrix product computed by
`evalGateMatrices`.

This is a structural correspondence check for the product side of the block
target.  It does not prove the extracted block equation, and it leaves all
O_D^BS, O_f, LCU, block-projection, block-correctness, and gate-unitarity
obligations in their previous false or open state.

## 2026-05-23 Lower Addendum: Active O_D^BS Gate Pair Guard

The lower pass added
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairBlocked`.
The guard ties the theorem route's source-decision blocker to the active
forward and dagger `O_D^BS` gate records used by the circuit product.

| Lean guard | Recorded state |
|---|---|
| `unusedZeroBranchDecision.lowerProofSearchAllowed` | `false` |
| `(GHL2025.oneTermRobinGate_O_D_BS (oneTermParameters n)).unitary.proved` | `false` |
| `(GHL2025.oneTermRobinGate_O_D_BS_dagger (oneTermParameters n)).unitary.proved` | `false` |
| `sparseAccessContract.daggerCleanup.proved` | `false` |
| `sparseAccessContract.unitaryExtension.proved` | `false` |

This is only a route-level guard.  It chooses no image for clean unused
zero-amplitude sparse branches, changes no active matrix, and promotes no
cleanup, injectivity, unitarity, LCU, or block-extraction obligation.

## 2026-05-23 Lower Addendum: Robin Zero-Inclusion Source Contract

The lower source-contract pass added
`GHL2025.BandedSparseAccessRobinZeroInclusionSourceContract` and the default
`GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract`.  This record
transcribes the source sentence before the one-term Robin theorem that zeros
can be included in the sparse enumeration, together with Eq. `ROBIN clarified`
using $s=0,\dots,\kappa-1$ and Lemma 1's padded-register map.

The contract is deliberately not an image rule.  It records that the source
keeps zero-amplitude sparse branches in the clean padded domain, but it leaves
the missing data as absent:

| Field | Recorded value |
|---|---|
| `zerosIncludedInSparseEnumeration` | `true` |
| `unusedBranchImageRule` | `none` |
| `unusedBranchImageIndex` | `none` |
| `reversibleExtensionTheorem` | `none` |
| `closesUnusedZeroBranchExtension` | `false` |
| `lowerProofSearchAllowed` | `false` |

The guards
`GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract_blocks_unusedZeroBranch`
and
`GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract_keepsImageRuleUnspecified`
pin the transcript to the existing source decision and the per-column
`BandedSparseAccessUnusedBranchImageRuleContract.proposedImageIndex = none`.
No active matrix, O_D^BS proof flag, LCU flag, or block-extraction flag changes.

## 2026-05-23 Lower Addendum: Route-Wired Zero-Inclusion Transcript

The theorem route now carries the zero-inclusion transcript directly through
`Examples.RobinHeat.OneTermRobinBlockEncodingProofRoute.robinZeroInclusionSource`.
The default route sets this field to
`GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract`.

The guard
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_robinZeroInclusionTranscript`
records that the source includes zero-amplitude sparse branches while the
unused-branch image rule, image index, and reversible-extension theorem remain
absent.  It also ties the transcript to
`unusedZeroBranchDecision.lowerProofSearchAllowed = false`.

| Route field or guard | Recorded state |
|---|---|
| `robinZeroInclusionSource.zerosIncludedInSparseEnumeration` | `true` |
| `robinZeroInclusionSource.unusedBranchImageRule` | `none` |
| `robinZeroInclusionSource.unusedBranchImageIndex` | `none` |
| `robinZeroInclusionSource.reversibleExtensionTheorem` | `none` |
| `robinZeroInclusionSource.closesUnusedZeroBranchExtension` | `false` |
| `robinZeroInclusionSource.lowerProofSearchAllowed` | `false` |

This route wiring changes no active O_D^BS matrix and promotes no cleanup,
injectivity, unitarity, LCU, block-projection, or block-correctness flag.

## 2026-05-23 Middle Addendum: Theorem Layout vs Projection Layout

Middle re-read GHL2025 Theorem `theorem: 1 term robin`, Eq.
`eq: ROBIN clarified`, and Fig. `fig:1 term ROBIN` before assigning any
block-extraction work.  The theorem-level block-encoding tuple uses

$$
m_{\mathrm{theorem}}
= \lceil\log_2 n\rceil+\lceil\log_2 G_f\rceil
  +\lceil\log_2\kappa\rceil+4
$$

signal qubits and $2n$ pure ancillas.  The matrix backend must project a
larger concrete signal space, because it zeros every non-system wire in the
explicit register partition:

$$
m_{\mathrm{projection}}
= \mathrm{effectiveRobinSignalQubits}
= m_{\mathrm{theorem}}
  + (n-\lceil\log_2\kappa\rceil) + 1 .
$$

The added Lean bridges are definitional and arithmetic only:

| Lean declaration | Meaning | Status |
|---|---|---|
| `GHL2025.defaultOneTermRobinTheoremData_signalQubits_eq_layout` | theorem tuple signal count equals `oneTermRobinLayout.signalQubits` | proved |
| `GHL2025.defaultOneTermRobinTheoremData_pureAncillas_eq_layout` | theorem tuple pure-ancilla count equals layout pure ancillas | proved |
| `GHL2025.defaultOneTermRobinTheoremData_pureAncillas_eq_resource` | theorem tuple pure-ancilla count equals concrete resource pure ancillas | proved |
| `GHL2025.effectiveRobinSignalQubits_eq_layout_signal_plus_visibleWorkspace` | projection signal qubits equal theorem signal qubits plus the padded $O_D^{BS}$ pure block and one visible ancilla | proved arithmetic bridge |
| `GHL2025.effectiveRobinSignalQubits_eq_theoremData_signal_plus_visibleWorkspace` | same projection bridge stated directly against the theorem-data signal count | proved arithmetic bridge |
| `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_layoutProjectionAudit` | theorem route records both counts while keeping resource cleanup, block projection, and block correctness false | proved guard |

Source-dependency classification:

| Step | Classification | Reason | Next action |
|---|---|---|---|
| theorem signal and $2n$ pure-ancilla tuple | `internal-paper-step` | stated in GHL2025 Theorem `theorem: 1 term robin` | keep as theorem-layout bridge |
| projection signal dimension | `classical-lean-lemma` plus register audit | arithmetic over the explicit register partition and `clog2_gridSize` | reuse `effectiveRobinSignalQubits`; do not introduce a second projection convention |
| pure-ancilla cleanup claim | `internal-paper-step` blocked by oracle cleanup dependencies | Fig. `fig:1 term ROBIN` requires cleanup, but O_D^BS cleanup remains blocked | keep `ancillaCleanup.proved = false` |
| final block equation | `internal-paper-step` with open dependencies | needs O_D^BS cleanup, O_f amplitude correctness, and LCU/block composition | keep block flags false |

Proof-DAG row:

| Block | Interface | Paper source | Lean declaration | Depends on | Reused by | Status |
|---|---|---|---|---|---|---|
| `theorem_layout_projection_audit` | distinguish theorem signal/pure-ancilla counts from the concrete signal dimension used by matrix block projection | GHL2025 Theorem `theorem: 1 term robin`, Eq. `eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, arXiv:2506.20478 | `defaultOneTermRobinTheoremData_signalQubits_eq_layout`, `defaultOneTermRobinTheoremData_pureAncillas_eq_layout`, `defaultOneTermRobinTheoremData_pureAncillas_eq_resource`, `effectiveRobinSignalQubits_eq_layout_signal_plus_visibleWorkspace`, `effectiveRobinSignalQubits_eq_theoremData_signal_plus_visibleWorkspace`, `oneTermRobinBlockEncodingProofRoute_layoutProjectionAudit` | `oneTermRobinLayout`, `defaultRobinRegisterPartition`, `defaultOneTermRobinTheoremData`, `effectiveRobinSignalQubits`, `oneTermRobinBlockEncodingProofRoute` | block-projection audit, theorem route, reviewer resource audit | proved wiring; `resourceBound`, `ancillaCleanup`, `blockProjection`, and `blockCorrect` remain false |

Lower packet status:

| Field | Instruction |
|---|---|
| Completed Lean scope | `QuantumBlockEncoding/GHL2025.lean`, `QuantumBlockEncoding/RobinMatrix.lean`, focused tests in `Tests/Basic.lean` |
| Allowed next work | only source-backed unused-branch image-rule contract work, or further theorem-route false-flag audit if a reviewer asks for it |
| Disallowed route | no O_D^BS injectivity, cleanup, unitarity, LCU closure, or final block-extraction proof search |
| Acceptance guard | `python3 tools/qbe.py check`, `lake build`, `lake build Tests`, and forbidden-pattern scan |

## 2026-05-24 Middle Human/Source Decision Packet

This packet is a source-contract handoff, not a lower proof-search packet.
Middle rechecked the same public anchors: GHL2025 Lemma
`lemma: Banded-sparse-access`, Theorem `theorem: 1 term robin`, Eq.
`eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, and cited prior-paper row
`GHL2024.PDE.Def6Lemma1.ODBS`.  The source still gives the padded map

$$
O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n
=
|r_{si}\rangle^n|i\rangle^n,
$$

and it still requires $(O_D^{BS})^\dagger$ to restore the padded sparse-index
register after SWAP.  The source does not specify an injective image for clean
unused zero-amplitude sparse branches.

Human/source decision needed:

| Option | Required source | Lean action | Status effect |
|---|---|---|---|
| Faithful source image | a paper equation, theorem, or author-approved statement that gives the unused-branch image rule | fill a new source-contract field before changing `proposedImageIndex` | keep all semantic proof flags false until reviewer accepts the contract |
| External reversible-extension theorem | a named theorem with an exact statement and applicability conditions | add a new cited-results row before lower uses it | status starts as `obligation`, not `formalized` |
| Exploratory branch | explicit human approval to leave faithful-paper mode for this subproblem | create a separate exploratory task/open problem | do not change the faithful route |
| No source | no new source supplied | keep the current blocker | `lowerProofSearchAllowed = false` |

Proof-translation map for the blocked paragraph:

| Source step | Classification | Current Lean anchor | Next action |
|---|---|---|---|
| Lemma 1 padded sparse-access equation | `external-cited-result` imported into GHL2025 | `BandedSparseAccessPaperContract`, `bandedSparseAccessPaperImage`, `bandedSparseAccessPriorPDESourceContract` | transcript complete; no unitarity claim |
| Eq. `ROBIN clarified` uses $s=0,\dots,\kappa-1$ | `internal-paper-step` | `BandedSparseAccessRobinZeroInclusionSourceContract` | transcript complete; zeros stay in the sparse enumeration |
| Fig. `fig:1 term ROBIN` asks the dagger to restore padded zeros | `internal-paper-step` blocked by missing oracle data | `(defaultBandedSparseAccessPaperContract p).daggerCleanup` | keep `proved = false` |
| image for clean unused zero-amplitude branches | `source-contract-gap` | `QBE.ODBS.UnusedZeroBranchExtension`, `bandedSparseAccessUnusedZeroBranchSourceDecision` | no lower proof search |
| SWAP register movement after the forward image | `classical-lean-lemma` | `swapOracleMatrix_is_permutation`, `bandedSparseAccessPaperPostSwap_*` lemmas | reusable local block already compiled |

Next lower packet: none for O_D^BS injectivity, dagger cleanup, unitarity,
LCU closure, or final block extraction.  The only permitted lower work is a
source-backed contract transcription that leaves `proposedImageIndex = none`
until the source is reviewed, or a guard-only test requested by reviewer.

### 2026-05-24 Middle Cycle 1 Source-Contract Sync

The cycle-1 middle audit found no new source-backed image rule.  The local TeX
anchors still support only this proof-translation map:

| Source fragment | Lean-facing contract | Classification | Lower action |
|---|---|---|---|
| Lemma `Banded-sparse-access` states $O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n = |r_{si}\rangle^n|i\rangle^n$ | `BandedSparseAccessPaperContract`, `bandedSparseAccessPaperImage` | `external-cited-result` imported into GHL2025 | reuse transcript; do not promote unitarity |
| Eq. `ROBIN clarified` ranges over $s=0,\dots,\kappa-1$ after the zero-inclusion sentence | `BandedSparseAccessRobinZeroInclusionSourceContract` | `internal-paper-step` | keep zero branches in the transcript |
| Fig. `fig:1 term ROBIN` expects $(O_D^{BS})^\dagger$ to restore the padded sparse register | `defaultBandedSparseAccessPaperContract.daggerCleanup` | `internal-paper-step` blocked by oracle data | keep `proved = false` |
| clean unused zero-amplitude sparse branches need an injective image | `QBE.ODBS.UnusedZeroBranchExtension` | `source-contract-gap` | no proof search |

Lower packet boundary:

| Field | Instruction |
|---|---|
| target declarations | only guard or transcript declarations tied to `bandedSparseAccessUnusedZeroBranchSourceDecision`, `bandedSparseAccessRobinZeroInclusionSourceContract`, or `oneTermRobinBlockEncodingProofRoute_odbsNoLowerProofSearch` |
| allowed files | `QuantumBlockEncoding/GHL2025.lean`, `QuantumBlockEncoding/RobinMatrix.lean`, `Tests/Basic.lean`, and synchronized documentation, but only for source-contract guards |
| disallowed files or edits | no changes to active O_D^BS matrices, the seven-gate list, `CircuitSemantics.lean`, or the final block-extraction target |
| acceptance | `python3 tools/qbe.py check`, `lake build`, `lake build Tests`, and false-flag guards still compiling |
| stop condition | if no paper equation or exact reversible-extension theorem is supplied, stop after the transcript or guard update and leave `lowerProofSearchAllowed = false` |

### 2026-05-24 Lower Guard: Active O_D^BS Placeholder Positions

Lower added focused tests in `Tests/Basic.lean` for the active seven-gate
matrix list.  The tests pin that `GHL2025.oneTermRobinGateMatrixPlaceholders p`
has `O_D^BS` at list position `3` and `(O_D^BS)^dagger` at list position `6`,
matching Fig. `fig:1 term ROBIN` and the existing circuit product route.

This is only a guard against accidental rewiring.  It does not change
`oneTermRobinGateMatrixPlaceholders`, the active matrices, the final
block-extraction target, or any semantic proof flag.  The source-contract
state remains `lowerProofSearchAllowed = false`, `proposedImageIndex = none`,
and `QBE.ODBS.UnusedZeroBranchExtension` is still the blocking obligation.

### 2026-05-24 Middle Maintainer Closeout

Middle re-read the source anchors for the current blocker before issuing any
new lower packet: GHL2025 Lemma `lemma: Banded-sparse-access`, Theorem
`theorem: 1 term robin`, Eq. `eq: ROBIN clarified`, Fig.
`fig:1 term ROBIN`, and the cited prior PDE primitive recorded as
`GHL2024.PDE.Def6Lemma1.ODBS`.  The source transcript still supports only the
padded sparse-access equation

$$
O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n
=
|r_{si}\rangle^n|i\rangle^n.
$$

It does not specify an injective reversible image for clean unused
zero-amplitude sparse branches.  Therefore the fixed Lean contract for the next
cycle is a guard contract, not a proof-search target.

| Contract item | Lean anchor | Required state |
|---|---|---|
| active forward image | `bandedSparseAccessPaperImage` | unchanged paper-image skeleton |
| active forward gate | `oneTermRobinGate_O_D_BS` | uses `bandedSparseAccessPaperMatrix`; `unitary.proved = false` |
| active dagger gate | `oneTermRobinGate_O_D_BS_dagger` | uses `bandedSparseAccessPaperDaggerMatrix`; `unitary.proved = false` |
| unused-branch source decision | `bandedSparseAccessUnusedZeroBranchSourceDecision` | `lowerProofSearchAllowed = false` and dependency not proved |
| zero-inclusion transcript | `bandedSparseAccessRobinZeroInclusionSourceContract` | zeros included, but no unused-branch image rule or reversible-extension theorem |
| image-rule slot | `BandedSparseAccessUnusedBranchImageRuleContract.proposedImageIndex` | `none` |
| final theorem route | `oneTermRobinBlockEncodingProofRoute_odbsNoLowerProofSearch` | preserves the O_D^BS blocker |

Lower-agent packet for the next cycle:

| Field | Instruction |
|---|---|
| fixed target | guard-only transcript or tests for the existing O_D^BS blocker |
| allowed declarations | `bandedSparseAccessUnusedZeroBranchSourceDecision_*`, `bandedSparseAccessRobinZeroInclusionSourceContract_*`, `oneTermRobinBlockEncodingProofRoute_odbsNoLowerProofSearch`, `oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairBlocked` |
| allowed files | `QuantumBlockEncoding/GHL2025.lean`, `QuantumBlockEncoding/RobinMatrix.lean`, `Tests/Basic.lean`, and synchronized documentation |
| forbidden work | no injectivity, dagger-cleanup, O_D^BS unitarity, LCU closure, active matrix rewrite, gate-list rewrite, signal-index change, or final block-extraction proof search |
| source precondition for new proof work | a paper-backed unused-branch image rule or an exact cited reversible-extension theorem with a cited-results row |
| acceptance | `python3 tools/qbe.py check`, `lake build`, `lake build Tests`, and the forbidden-pattern scan |

### 2026-05-24 Middle Cycle 1 Final Audit

Middle re-read the source anchors before closing the cycle.  The public audit
anchors remain GHL2025 Lemma `lemma: Banded-sparse-access`, Theorem
`theorem: 1 term robin`, Eq. `eq: ROBIN clarified`, Fig.
`fig:1 term ROBIN`, and the cited prior sparse-access primitive recorded in
`research-wiki/cited-results/GHL2025.md`.

The paper-to-Lean contract is unchanged:

| Source fragment | Lean contract | Classification | Cycle-1 status |
|---|---|---|---|
| Lemma 1 gives $O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n = |r_{si}\rangle^n|i\rangle^n$ | `BandedSparseAccessPaperContract`, `bandedSparseAccessPaperImage`, `bandedSparseAccessPaperMatrix` | `external-cited-result` imported into GHL2025 | transcript only; no unitarity or cleanup proof |
| Eq. `ROBIN clarified` sums over $s=0,\dots,\kappa-1$ after the zero-inclusion sentence | `BandedSparseAccessRobinZeroInclusionSourceContract` | `internal-paper-step` | zero-amplitude sparse branches remain in scope |
| Fig. `fig:1 term ROBIN` uses $(O_D^{BS})^\dagger$ to restore the padded register | `(defaultBandedSparseAccessPaperContract p).daggerCleanup` | `internal-paper-step` blocked by oracle data | `proved = false` |
| clean unused zero-amplitude sparse branches need a reversible image | `QBE.ODBS.UnusedZeroBranchExtension`, `bandedSparseAccessUnusedZeroBranchSourceDecision` | `source-contract-gap` | no lower proof search |

Cycle-1 lower output is therefore accepted only as guard wiring.  The route
tests pin that the theorem-level circuit product still uses the active
`O_D^BS` and `(O_D^BS)^dagger` paper-image matrices at the Fig.
`fig:1 term ROBIN` positions, with both unitary flags false.  The tests also
pin that `oneTermRobinBlockEncodingProofRoute` consumes exactly the audited
unused-zero-branch source decision, prior sparse-access source transcript, and
Robin zero-inclusion transcript.

Updated proof-DAG row:

| Block | Interface | Paper source | Lean declaration | Depends on | Reused by | Status |
|---|---|---|---|---|---|---|
| `odbs_source_gate_guard` | preserve the faithful O_D^BS source gate and theorem-route blockers until a source-backed unused-branch image rule exists | GHL2025 Lemma `lemma: Banded-sparse-access`, Eq. `eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, arXiv:2506.20478; cited row `GHL2024.PDE.Def6Lemma1.ODBS` | `bandedSparseAccessUnusedZeroBranchSourceDecision_*`, `bandedSparseAccessRobinZeroInclusionSourceContract_*`, `oneTermRobinBlockEncodingProofRoute_sourceTranscriptIdentity`, `oneTermRobinBlockEncodingProofRoute_odbsNoLowerProofSearch`, `oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairBlocked` | source audit, unused-branch image-rule slot, active O_D^BS gate pair | reviewer guard, next lower source-contract packet | guard compiled; `proposedImageIndex = none`, `lowerProofSearchAllowed = false`, O_D^BS cleanup/unitarity and block flags false |

Next lower packet:

| Field | Instruction |
|---|---|
| allowed work | source-backed transcript or guard tests for the existing O_D^BS blocker |
| allowed Lean anchors | `bandedSparseAccessUnusedZeroBranchSourceDecision_*`, `bandedSparseAccessRobinZeroInclusionSourceContract_*`, `oneTermRobinBlockEncodingProofRoute_sourceTranscriptIdentity`, `oneTermRobinBlockEncodingProofRoute_odbsNoLowerProofSearch`, `oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairBlocked` |
| required source precondition for proof work | exact unused-branch image formula or named reversible-extension theorem with a cited-results entry |
| forbidden work | no O_D^BS injectivity, dagger cleanup, unitarity, LCU closure, active matrix rewrite, signal-index rewrite, or final block-extraction proof search |

### 2026-05-24 Lower Guard: Named Active Gate-Pair Wiring

The route-level gate-pair wiring guard is now a named Lean declaration:
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairWiring`.
It packages the existing Fig. `fig:1 term ROBIN` gate-list checks into one
compiled theorem.  The forward `O_D^BS` gate remains at index `3` with matrix
`GHL2025.bandedSparseAccessPaperMatrix`; the dagger gate remains at index `6`
with matrix `GHL2025.bandedSparseAccessPaperDaggerMatrix`.

The same guard also records that both active gate unitarity flags are false and
that `unusedZeroBranchDecision.lowerProofSearchAllowed = false`.  It is not a
semantic proof of the paper oracle.  The unused-branch image slot remains
`none`, and `QBE.ODBS.UnusedZeroBranchExtension` remains the blocking
obligation.

### 2026-05-24 Lower Guard: Sparse-Access Contract Identity

The theorem route now has the named guard
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_sparseAccessContractIdentity`.
It pins
`(oneTermRobinBlockEncodingProofRoute n).sparseAccessContract` to the default
GHL2025 Lemma 1 contract object
`GHL2025.defaultBandedSparseAccessPaperContract (oneTermParameters n)`.

This is a contract-drift guard only.  It keeps `forwardCorrect`,
`daggerCleanup`, and `unitaryExtension` false, and also keeps
`unusedZeroBranchDecision.lowerProofSearchAllowed = false`.  It does not add
an unused-branch image rule, change either active `O_D^BS` matrix, or promote
cleanup, unitarity, LCU closure, or block extraction.

### 2026-05-24 Lower Guard: Lemma 1 Paper Contract Transcript

The theorem route now has the named source-transcript guard
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript`.
It pins that the route's `sparseAccessContract` still carries the GHL2025
Lemma 1 register contract:

| Contract field | Required value |
|---|---|
| source anchor | GHL2025 Lemma 1, arXiv:2506.20478 |
| input ket | `|0>^(n-l)|s>^l|i>^n` |
| output ket | `|r_si>^n|i>^n` |
| image formula | `r_si = r_s0 + i mod 2^n` |
| row/output address widths | `(oneTermParameters n).n` |
| sparse-index width | `clog2 (oneTermParameters n).kappa` |
| padded-zero width | `(oneTermParameters n).n - clog2 (oneTermParameters n).kappa` |

The same guard keeps `cleanInputDomain`, `widthCompatible`, `addressRange`,
`noSpill`, `forwardCorrect`, `daggerCleanup`, and `unitaryExtension` proof
flags false, and keeps
`unusedZeroBranchDecision.lowerProofSearchAllowed = false`.  It is a
contract-drift guard only; it does not alter active matrices or add a
reversible image rule for clean unused branches.

### 2026-05-24 Lower Guard: Source Obligations Still False

The theorem route now has the named guard
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_sourceObligationsFalse`.
It exposes the source-dependency blockers already carried by the route:
`unusedZeroBranchDecision.dependency.proved = false`,
`robinZeroInclusionSource.imageRuleObligation.proved = false`,
`robinZeroInclusionSource.reversibleExtensionObligation.proved = false`, and
`priorSparseAccessSource.resourceClaim.proved = false`.

The same guard also keeps `lowerProofSearchAllowed = false`,
`blockProjection.proved = false`, and `blockCorrect.proved = false`.  It is a
guard-only source-contract packet.  It does not add an unused-branch image
rule, change either active `O_D^BS` matrix, change the gate list, or promote
cleanup, unitarity, LCU, or block-extraction flags.

### 2026-05-24 Middle Guard Packet Closeout

Middle rechecked the source anchors and the current Lean route guards after the
lower guard packet.  The public anchors remain GHL2025 Lemma
`lemma: Banded-sparse-access`, Eq. `eq: ROBIN clarified`, Fig.
`fig:1 term ROBIN`, Theorem `theorem: 1 term robin`, and the cited prior sparse
access row `GHL2024.PDE.Def6Lemma1.ODBS`.

No new source-backed image rule was found for clean unused zero-amplitude
sparse branches.  The next proof-DAG block is therefore a guard block, not a
semantic proof block.

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `odbs_source_obligation_guard` | expose the source obligations and keep all O_D^BS theorem-route blockers false | `GHL2025.Lemma1.ODBS`, `GHL2024.PDE.Def6Lemma1.ODBS`, `GHL2025.RobinZeroInclusion.ODBS`, `QBE.ODBS.UnusedZeroBranchExtension` | `oneTermRobinBlockEncodingProofRoute_sourceObligationsFalse`, `oneTermRobinBlockEncodingProofRoute_robinZeroInclusionKeepsOdbsBlocked`, `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript` | reviewer gate, next source-contract-only packet | guard compiled; no semantic flag promoted |

Lower-agent boundary:

| Field | Instruction |
|---|---|
| allowed work | focused guard tests or source-contract transcript fields for the existing O_D^BS blocker |
| fixed Lean anchors | `bandedSparseAccessUnusedZeroBranchSourceDecision_*`, `bandedSparseAccessRobinZeroInclusionSourceContract_*`, `oneTermRobinBlockEncodingProofRoute_sourceObligationsFalse`, `oneTermRobinBlockEncodingProofRoute_robinZeroInclusionKeepsOdbsBlocked`, `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript` |
| forbidden work | no O_D^BS injectivity, dagger cleanup, unitary extension, active matrix rewrite, LCU closure, signal-index rewrite, or final block-extraction proof search |
| source precondition | an exact unused-branch image formula or named reversible-extension theorem, recorded in the cited-results ledger before lower proof work depends on it |

### 2026-05-24 Lower Guard: Source Blocker Keeps Final Flags False

Lower added the named guard
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_sourceBlockerKeepsFinalFlagsFalse`.
It ties the audited `QBE.ODBS.UnusedZeroBranchExtension` blocker to the
theorem-level closure flags: the source dependency and Robin zero-inclusion
image-rule obligations remain unproved, lower proof search remains disabled,
both active $O_D^{BS}$ gate-pair unitarity flags remain false, and the
circuit-unitary, block-extraction, block-correctness, and LCU flags remain
false.

This is a guard-only Phase 1 declaration.  It does not add an unused-branch
image rule, change either active matrix, or prove injectivity, dagger cleanup,
unitarity, LCU composition, or final block extraction.

### 2026-05-24 Lower Guard: Source Decision Image Slots

Lower added the named guard
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_sourceDecisionImageSlotsBlocked`.
It ties the theorem route's `QBE.ODBS.UnusedZeroBranchExtension` source
decision to the two unused-branch image-rule slots used by the direct
per-column contract and the full clean-domain wrapper.

The guard keeps `paperImageRuleSpecified = false`,
`externalExtensionTheoremAccepted = false`,
`lowerProofSearchAllowed = false`, both `proposedImageIndex` fields equal to
`none`, and the $O_D^{BS}$ `forwardCorrect`, `daggerCleanup`, and
`unitaryExtension` flags false.  It is a guard-only source-contract declaration:
it does not select an unused-branch image, change either active matrix, or
promote injectivity, dagger cleanup, unitarity, LCU closure, or final block
extraction.

## Build Gate

```bash
python3 tools/qbe.py check
rg -n "Prop := True|:= trivial|sparseCorrect := True|amplitudeCorrect := True|lcuCorrect := True|\\bsorry\\b" QuantumBlockEncoding Tests -g '!QuantumBlockEncoding/Automation.lean' || true
```

### 2026-05-24 Middle Audit: O_D^BS Source Gate

Middle re-read the local GHL2025 source before issuing any lower proof-search
packet.  The public anchors are Lemma `lemma: Banded-sparse-access`, Eq.
`eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, Theorem
`theorem: 1 term robin`, and bibliography key `guseynov2024efficientPDE`.
The audit does not change any cited-result status.

Source-to-Lean proof translation:

| Source proof fragment | Lean-facing object | Classification | Lower action |
|---|---|---|---|
| Lemma 1 states $O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n = |r_{si}\rangle^n|i\rangle^n$ | `BandedSparseAccessPaperContract`, `bandedSparseAccessPaperImage`, `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript` | `external-cited-result` imported by GHL2025 from the prior PDE primitive | keep as transcript; do not promote cleanup or unitarity |
| The Robin theorem text says zeros can be included in the sparse enumeration and Eq. `eq: ROBIN clarified` sums over $s=0,\dots,\kappa-1$ | `BandedSparseAccessRobinZeroInclusionSourceContract`, `oneTermRobinBlockEncodingProofRoute_robinZeroInclusionKeepsOdbsBlocked` | `internal-paper-step` | keep zero-inclusion visible with no image rule |
| Fig. `fig:1 term ROBIN` asks $(O_D^{BS})^\dagger$ to restore the padded sparse-index register after SWAP | `defaultBandedSparseAccessPaperContract.daggerCleanup`, `oneTermRobinBlockEncodingProofRoute_sourceBlockerKeepsFinalFlagsFalse` | `internal-paper-step` blocked by missing oracle data | keep `daggerCleanup.proved = false` |
| No source fragment specifies an injective reversible image for clean unused zero-amplitude sparse branches | `QBE.ODBS.UnusedZeroBranchExtension`, `bandedSparseAccessUnusedZeroBranchSourceDecision`, `oneTermRobinBlockEncodingProofRoute_sourceDecisionImageSlotsBlocked` | `source-contract-gap` | lower proof search remains disabled |

Lower packet boundary:

| Field | Instruction |
|---|---|
| fixed declarations to reuse | `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript`, `oneTermRobinBlockEncodingProofRoute_sparseAccessContractIdentity`, `oneTermRobinBlockEncodingProofRoute_sourceDecisionImageSlotsBlocked`, `oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairWiring`, `oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairBlocked`, `oneTermRobinBlockEncodingProofRoute_sourceBlockerKeepsFinalFlagsFalse` |
| allowed write scope | source-contract docs, cited-results notes, focused false-flag tests in `Tests/Basic.lean`, or guard-only Lean declarations in `RobinMatrix.lean` |
| forbidden work | no O_D^BS injectivity, dagger cleanup, unitary extension, active matrix rewrite, LCU closure, signal-index rewrite, or final block-extraction proof search |
| required acceptance | `python3 tools/qbe.py check`, `lake build`, `lake build Tests`, and the forbidden-pattern scan |

### 2026-05-24 Lower Guard: Source-Anchor Test

Lower added a focused `Tests/Basic.lean` regression test for
`GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision`.  It pins the source
decision to public anchors only: GHL2025 Lemma 1 and Fig. `fig:1 term ROBIN`,
the cited-result key `QBE.ODBS.UnusedZeroBranchExtension`, and the project
ledger entry `research-wiki/cited-results/GHL2025.md`.

The test keeps `paperImageRuleSpecified = false`,
`externalExtensionTheoremAccepted = false`,
`lowerProofSearchAllowed = false`, and `dependency.proved = false`.  It is a
guard-only source-contract test; it does not choose an unused-branch image,
change either active `O_D^BS` matrix, or promote dagger cleanup, unitarity, LCU
composition, or final block extraction.

### 2026-05-24 Middle Freeze Sync: O_D^BS Source Decision

Middle re-read the local source after the upper handoff and kept the public
contract boundary unchanged.  Lemma `lemma: Banded-sparse-access` states
$$
O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n
  = |r_{si}\rangle^n|i\rangle^n,
$$
Eq. `eq: ROBIN clarified` keeps the sparse range $s=0,\dots,\kappa-1$, and
Fig. `fig:1 term ROBIN` says $(O_D^{BS})^\dagger$ restores the padded sparse
register.  The source still does not specify a reversible image for clean
unused zero-amplitude sparse branches.

Proof-translation status:

| Source fragment | Lean-facing object | Classification | Lower packet |
|---|---|---|---|
| Lemma `lemma: Banded-sparse-access` padded map | `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript`, `BandedSparseAccessPaperContract` | `external-cited-result` transcript through the prior PDE primitive | reuse transcript only |
| Eq. `eq: ROBIN clarified` sums over $s=0,\dots,\kappa-1$ | `BandedSparseAccessRobinZeroInclusionSourceContract`, `oneTermRobinBlockEncodingProofRoute_robinZeroInclusionKeepsOdbsBlocked` | `internal-paper-step` | keep zero inclusion visible |
| Fig. `fig:1 term ROBIN` dagger cleanup sentence | `defaultBandedSparseAccessPaperContract.daggerCleanup`, `oneTermRobinBlockEncodingProofRoute_sourceBlockerKeepsFinalFlagsFalse` | `internal-paper-step` blocked by oracle data | keep `proved = false` |
| Missing unused-branch reversible image | `QBE.ODBS.UnusedZeroBranchExtension`, `bandedSparseAccessUnusedZeroBranchSourceDecision` | `source-contract-gap` | no proof search |

Proof-DAG freeze:

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `odbs_source_decision_freeze` | preserve the audited source blocker and all false semantic flags until a source-backed image rule is recorded | GHL2025 Lemma `lemma: Banded-sparse-access`, Eq. `eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`; `QBE.ODBS.UnusedZeroBranchExtension` | `oneTermRobinBlockEncodingProofRoute_sourceDecisionImageSlotsBlocked`, `oneTermRobinBlockEncodingProofRoute_sourceBlockerKeepsFinalFlagsFalse`, `oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairWiring` | reviewer guard and future source-contract packets | compiled guard route; no active matrix or proof flag changed |

No lower packet is authorized for $O_D^{BS}$ injectivity, dagger cleanup,
unitary extension, LCU closure, or final block extraction.  The only allowed
work is source-backed transcript maintenance or false-flag guard tests, and any
new source must first be entered in `research-wiki/cited-results/GHL2025.md`
without marking it `formalized`.

### 2026-05-24 Middle Cycle 1 Re-Audit: Guard-Only Lower Boundary

Middle re-read the GHL2025 source anchors after the latest upper handoff:
Lemma `lemma: Banded-sparse-access`, Eq. `eq: ROBIN clarified`, Fig.
`fig:1 term ROBIN`, Theorem `theorem: 1 term robin`, and the prior sparse-access
citation `guseynov2024efficientPDE`.  The source contract remains unchanged.
Lemma 1 states the padded map

$$
O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n
  = |r_{si}\rangle^n|i\rangle^n,
$$

Eq. `eq: ROBIN clarified` keeps $s=0,\dots,\kappa-1$ in the Robin wavefunction
transcript, and Fig. `fig:1 term ROBIN` requires $(O_D^{BS})^\dagger$ cleanup
after SWAP.  No inspected source fragment specifies a reversible image for
clean unused zero-amplitude sparse branches.

Source proof translation:

| Source fragment | Lean-facing object | Classification | Lower action |
|---|---|---|---|
| Lemma 1 padded sparse-access equation | `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript`, `BandedSparseAccessPaperContract` | `external-cited-result` transcript through `GHL2024.PDE.Def6Lemma1.ODBS` | reuse transcript only |
| Eq. `eq: ROBIN clarified` sparse range $s=0,\dots,\kappa-1$ | `BandedSparseAccessRobinZeroInclusionSourceContract`, `oneTermRobinBlockEncodingProofRoute_robinZeroInclusionKeepsOdbsBlocked` | `internal-paper-step` | preserve zero-inclusion transcript with no image rule |
| Fig. `fig:1 term ROBIN` dagger-cleanup sentence | `defaultBandedSparseAccessPaperContract.daggerCleanup`, `oneTermRobinBlockEncodingProofRoute_sourceBlockerKeepsFinalFlagsFalse` | `internal-paper-step` blocked by missing oracle data | keep `proved = false` |
| Missing reversible image for clean unused zero-amplitude sparse branches | `QBE.ODBS.UnusedZeroBranchExtension`, `bandedSparseAccessUnusedZeroBranchSourceDecision` | `source-contract-gap` | no proof search |

Proof-DAG freeze:

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `odbs_cycle01_source_gate` | keep the audited O_D^BS source blocker, direct image-rule slot, full clean-domain wrapper slot, active gate-pair wiring, and final theorem flags synchronized | GHL2025 Lemma `lemma: Banded-sparse-access`, Eq. `eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`; cited rows `GHL2024.PDE.Def6Lemma1.ODBS` and `QBE.ODBS.UnusedZeroBranchExtension` | `oneTermRobinBlockEncodingProofRoute_sourceDecisionImageSlotsBlocked`, `oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairWiring`, `oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairPublicSources`, `oneTermRobinBlockEncodingProofRoute_sparseAccessContractIdentity`, `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript`, `oneTermRobinBlockEncodingProofRoute_sourceBlockerKeepsFinalFlagsFalse` | reviewer source audit, future source-contract packets | compiled guard route; no semantic flag promoted |

The next lower packet is guard-only.  Allowed edits are source-contract docs,
cited-results notes, focused false-flag tests in `Tests/Basic.lean`, or
guard-only Lean declarations in `QuantumBlockEncoding/RobinMatrix.lean` that
reuse the declarations named above.  Forbidden work remains O_D^BS injectivity,
dagger cleanup, unitary extension, active matrix rewrite, LCU closure,
signal-index rewrite, and final block-extraction proof search.

### 2026-05-24 Middle Final Sync: Source Gate and Lower Packet

Middle re-read the GHL2025 source anchors after the upper handoff for this run:
Lemma `lemma: Banded-sparse-access`, Eq. `eq: ROBIN clarified`, Fig.
`fig:1 term ROBIN`, Theorem `theorem: 1 term robin`, and the prior sparse
access citation `guseynov2024efficientPDE`.  The source contract is unchanged.
The paper-backed register equation is still

$$
O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n
  = |r_{si}\rangle^n|i\rangle^n,
$$

and the Robin wavefunction transcript still ranges over
$s=0,\dots,\kappa-1$.  The inspected source does not give an injective
reversible image rule for clean unused zero-amplitude sparse branches.  This
keeps `QBE.ODBS.UnusedZeroBranchExtension` classified as a
`source-contract-gap`.

Current Lean-to-paper translation:

| Lean guard | Paper-facing meaning | Status |
|---|---|---|
| `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript` | the theorem route carries Lemma 1's padded input/output ket transcript | compiled guard; semantic fields false |
| `oneTermRobinBlockEncodingProofRoute_sourceDecisionImageSlotsBlocked` | direct and full-wrapper unused-branch image slots have no proposed image | compiled guard; no image rule selected |
| `oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairWiring` and `oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairPublicSources` | the active forward/dagger matrices remain the paper-image skeletons with public anchors | compiled guard; both unitarity flags false |
| `oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit` | the block target still uses signal index $0$, `robinDerivativeMatrix n`, and normalizer $N_DN_f\kappa$ | compiled guard; block flags false |
| `oneTermRobinBlockEncodingProofRoute_sourceBlockerKeepsFinalFlagsFalse` | the source blocker propagates to circuit-unitary, block-extraction, block-correctness, and LCU closure flags | compiled guard; final flags false |

Next lower packet:

| Field | Instruction |
|---|---|
| allowed write scope | source-backed transcript updates in this conversion window, `proof-obligations/QBE-AUTO-002.md`, `research-wiki/cited-results/GHL2025.md`, or focused false-flag tests in `Tests/Basic.lean` |
| fixed declarations to reuse | `oneTermRobinBlockEncodingProofRoute_sourceDecisionImageSlotsBlocked`, `oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairWiring`, `oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairPublicSources`, `oneTermRobinBlockEncodingProofRoute_sparseAccessContractIdentity`, `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript`, `oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit`, `oneTermRobinBlockEncodingProofRoute_sourceBlockerKeepsFinalFlagsFalse` |
| forbidden work | no O_D^BS injectivity, dagger cleanup, unitary extension, active matrix rewrite, O_f analytic closure, LCU closure, signal-index change, or final block-extraction proof search |
| source precondition | before any semantic O_D^BS proof work, add an exact unused-branch image formula or a named reversible-extension theorem to `research-wiki/cited-results/GHL2025.md` with status `obligation` or `contract-only` |
| required acceptance | `python3 tools/qbe.py check`, `lake build`, `lake build Tests`, and the forbidden-pattern scan |

### 2026-05-24 Lower Guard Regression Test

Lower added one focused test in `Tests/Basic.lean` that consumes
`oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit` and
`oneTermRobinBlockEncodingProofRoute_sourceBlockerKeepsFinalFlagsFalse`
together.  The test checks that the theorem route still uses signal index $0$,
the symbolic normalizer $N_DN_f\kappa$, false block-projection and
block-correctness flags, false circuit-unitary and block-extraction flags,
false LCU correctness, and `lowerProofSearchAllowed = false`.

This is guard-only maintenance for the existing source-contract gap
`QBE.ODBS.UnusedZeroBranchExtension`.  It does not introduce an unused-branch
image rule, change either active $O_D^{BS}$ matrix, or promote any semantic
`proved` flag.

### 2026-05-24 Lower Source-Gate Freeze Guard

Lower added `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_sourceGateFreeze`
as a reviewer-facing bundle over the existing source-decision and theorem-route
guards.  It reuses the audited declarations rather than proving a new oracle
fact:

| Field | Guarded status |
|---|---|
| proof-search decision | `lowerProofSearchAllowed = false` |
| unused-branch image slots | direct and full-wrapper `proposedImageIndex = none` |
| active gate sources | forward gate cites GHL2025 Lemma 1; dagger gate cites Fig. `fig:1 term ROBIN` and Lemma 1 |
| active matrices | forward/dagger gates remain wired to `bandedSparseAccessPaperMatrix` and `bandedSparseAccessPaperDaggerMatrix` |
| block target | normalizer is $N_DN_f\kappa$ and signal index is $0$ |
| final theorem flags | circuit-unitary, block-correctness, and LCU correctness remain false |

This guard does not choose an unused-branch image rule, rewrite either active
$O_D^{BS}$ matrix, or promote any semantic proof flag.  It preserves the current
source-contract-gap classification for `QBE.ODBS.UnusedZeroBranchExtension`.

### 2026-05-24 Lower Contract-Drift Entry Guard

Lower promoted the focused source-column `8` regression to the named Lean guard
`GHL2025.oneTermRobinGate_O_D_BS_contractDrift_column8_n3` and keeps
`Tests/Basic.lean` pointed at that declaration.  For the concrete
$n=3,\kappa=7$ case, the Lemma 1 paper-image skeleton sends the source column
to row `40`, so the active `oneTermRobinGate_O_D_BS` matrix has entry
`(40, 8) = 1` and entry `(4, 8) = 0`.  The legacy
`bandedSparseAccessMatrix` helper still has its historical helper entry
`(4, 8) = 1`, because that helper overwrites the system register with
`robinSparseColumnMap`.

This is a contract-drift guard only.  It confirms that the active gate uses
`bandedSparseAccessPaperMatrix` rather than the legacy helper, but it does not
change either matrix, select an unused-branch image rule, or promote
$O_D^{BS}$ injectivity, dagger cleanup, unitarity, LCU closure, or final block
extraction.

### 2026-05-24 Lower Active-Collision Guard Test

Lower added a second focused regression for the same blocked source-contract
state.  It pins the active paper-image collision at the matrix-entry level:
for the $n=3,\kappa=7$ boundary columns `0` and `48`,
`oneTermRobinGate_O_D_BS` has row-`0` entries equal to `1` for both columns.

The same test keeps the unused-branch image slot equal to `none` and keeps
the theorem-route lower-proof-search, `daggerCleanup`, and `unitaryExtension`
flags false.  This is a blocker witness only; it does not select a reversible
image rule or prove injectivity, cleanup, unitarity, LCU closure, or final
block extraction.

### 2026-05-24 Middle Post-Lower Sync: Source-Gate Freeze

Middle rechecked the latest lower guard declarations against the GHL2025 source
anchors.  No cited-result status changes.  Lemma
`lemma: Banded-sparse-access` still supplies only the padded sparse-access
transcript, Eq. `eq: ROBIN clarified` still keeps
$s=0,\dots,\kappa-1$, and Fig. `fig:1 term ROBIN` still asks the dagger to
restore the padded sparse-index register after SWAP.  The source gap is still
the missing reversible image for clean unused zero-amplitude sparse branches.

Lean-to-paper translation for the accepted guards:

| Lean guard/test | Paper-facing meaning | Status |
|---|---|---|
| `oneTermRobinBlockEncodingProofRoute_sourceGateFreeze` | packages the source-decision blocker, direct and wrapper image slots, active gate-pair wiring, signal-index-zero block target, and theorem-level false flags | compiled guard; no semantic flag promoted |
| contract-drift regression at source column `8` | `oneTermRobinGate_O_D_BS_contractDrift_column8_n3`: active `oneTermRobinGate_O_D_BS` uses the Lemma 1 paper-image row `40`, while the legacy helper still has its row-`4` entry | compiled guard and test; confirms active/legacy separation only |
| active-collision regression at source columns `0` and `48` | the current paper-image skeleton collides on clean boundary branches while the unused image slot remains `none` | compiled blocker witness; no image rule selected |

Proof-DAG status:

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `odbs_source_gate_freeze` | keep the O_D^BS source blocker, image-rule slots, active gate-pair wiring, signal-index-zero projection target, and final theorem flags synchronized | GHL2025 Lemma `lemma: Banded-sparse-access`, Eq. `eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`; rows `GHL2025.Lemma1.ODBS`, `GHL2025.RobinZeroInclusion.ODBS`, `QBE.ODBS.UnusedZeroBranchExtension` | `oneTermRobinBlockEncodingProofRoute_sourceGateFreeze`; focused tests in `Tests/Basic.lean` | reviewer source gate; future lower packets | compiled guard route; direct and wrapper `proposedImageIndex = none`; active matrices unchanged; semantic flags false |

The next lower packet remains guard-only unless a source-backed unused-branch
image formula or a named reversible-extension theorem is entered in
`research-wiki/cited-results/GHL2025.md` first.  Do not assign O_D^BS
dagger cleanup, unitary extension, LCU closure, or final block-extraction
proof search against the old row-dependent image skeleton.

### 2026-05-24 Lower Route-Collision Guard

Lower promoted the active-collision regression into the named theorem-route
guard `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_activeCollisionBlocked_n3`.
It reuses the existing $n=3,\kappa=7$ boundary columns `0` and `48`: the active
paper-image matrix has row-`0` entries equal to `1` for both columns, while the
unused-branch image slot remains `none`.

The guard ties that concrete blocker to the theorem route by keeping
`lowerProofSearchAllowed = false`, `daggerCleanup.proved = false`,
`unitaryExtension.proved = false`, and `lcuCorrect.proved = false`.  It does
not select an unused-branch image rule, change either active $O_D^{BS}$ matrix,
or promote injectivity, cleanup, unitarity, LCU closure, or final block
extraction.

Updated proof-DAG row:

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `odbs_rejected_collision_route_guard` | keep the old row-dependent boundary collision and corrected active-image separation tied to the disabled theorem-route flags | GHL2025 Lemma `lemma: Banded-sparse-access`, Eq. `eq: ROBIN clarified`, `QBE.ODBS.GlobalSparseSlotAddress` | `oneTermRobinBlockEncodingProofRoute_activeCollisionBlocked_n3` | reviewer source-gate audit, future guard-only lower packets | compiled guard; active global-slot image separates the columns and all semantic flags remain false |

### 2026-05-24 Middle Post-Upper Source-Gate Handoff

Middle re-read the GHL2025 source anchors after the latest upper handoff:
Lemma `lemma: Banded-sparse-access`, Eq. `eq: ROBIN clarified`, Fig.
`fig:1 term ROBIN`, Theorem `theorem: 1 term robin`, and the prior
sparse-access citation `guseynov2024efficientPDE`.  The source-dependency
classification remains unchanged.  Lemma 1 supplies the padded sparse-access
transcript, Eq. `eq: ROBIN clarified` keeps $s=0,\dots,\kappa-1$ in the Robin
wavefunction transcript, and Fig. `fig:1 term ROBIN` requires dagger cleanup
after SWAP.  No inspected source fragment supplies a reversible image rule for
clean unused zero-amplitude sparse branches.

The accepted lower route-collision guard is therefore a freeze guard, not a
proof route:

| Lean guard | Paper-facing meaning | Required status |
|---|---|---|
| `oneTermRobinBlockEncodingProofRoute_activeCollisionBlocked_n3` | the rejected row-dependent helper still collides on clean boundary columns `0` and `48`, while the corrected active global-slot image separates them | regression witness only; no injectivity result |
| `oneTermRobinBlockEncodingProofRoute_sourceGateFreeze` | the theorem route still carries the source decision, image slots, active gate-pair wiring, signal-index-zero target, and final false flags | compiled guard; no semantic flag promoted |
| `oneTermRobinGate_O_D_BS_contractDrift_column8_n3` | the active gate uses the Lemma 1 paper-image row for source column `8`, while the legacy helper remains separate | contract-drift regression only |

Source proof translation for the next cycle:

| Source fragment | Lean-facing object | Classification | Lower action |
|---|---|---|---|
| Lemma 1 padded sparse-access equation | `BandedSparseAccessPaperContract`, `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript` | `external-cited-result` through the prior PDE primitive | reuse transcript only |
| Eq. `eq: ROBIN clarified` sparse range $s=0,\dots,\kappa-1$ | `BandedSparseAccessRobinZeroInclusionSourceContract` | `internal-paper-step` | preserve zero-inclusion transcript |
| Fig. `fig:1 term ROBIN` dagger-cleanup sentence | `defaultBandedSparseAccessPaperContract.daggerCleanup` | `internal-paper-step` blocked by missing oracle data | keep `proved = false` |
| missing reversible image for clean unused zero-amplitude branches | `QBE.ODBS.UnusedZeroBranchExtension`, `bandedSparseAccessUnusedZeroBranchSourceDecision` | `source-contract-gap` | no proof search |

Next lower packet boundary:

| Field | Instruction |
|---|---|
| allowed work | source-contract transcript maintenance, cited-results updates for a newly supplied exact source, or focused false-flag guard tests |
| fixed declarations to reuse | `oneTermRobinBlockEncodingProofRoute_activeCollisionBlocked_n3`, `oneTermRobinBlockEncodingProofRoute_sourceGateFreeze`, `oneTermRobinBlockEncodingProofRoute_sourceDecisionImageSlotsBlocked`, `oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairWiring`, `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript`, and `oneTermRobinBlockEncodingProofRoute_sourceBlockerKeepsFinalFlagsFalse` |
| forbidden work | no O_D^BS injectivity, dagger cleanup, unitary extension, active matrix rewrite, O_f analytic closure, LCU closure, signal-index change, or final block-extraction proof search |
| source precondition | before semantic O_D^BS proof work, record an exact unused-branch image formula or a named reversible-extension theorem in `research-wiki/cited-results/GHL2025.md` with status `obligation` or `contract-only` |
| acceptance | `python3 tools/qbe.py check`, `lake build`, `lake build Tests`, and the forbidden-pattern scan |

### 2026-05-24 Lower Route Contract-Drift Guard

Lower added
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_contractDriftColumn8Blocked_n3`.
This theorem-route guard lifts the existing column-`8` active-vs-legacy
regression into the final one-term route.  For the concrete $n=3,\kappa=7$
case, the route's active `O_D^BS` gate has the Lemma 1 paper-image entry
`(40, 8) = 1` and no row-`4` active entry, while the legacy
`bandedSparseAccessMatrix` helper still has `(4, 8) = 1`.

The guard also keeps
`unusedZeroBranchDecision.lowerProofSearchAllowed = false`,
`sparseAccessContract.daggerCleanup.proved = false`, and
`blockClaim.target.blockCorrect.proved = false`.  It is only a regression
guard for the source-contract freeze.  It does not select an unused-branch
image rule, rewrite either active $O_D^{BS}$ matrix, or promote injectivity,
dagger cleanup, unitarity, LCU closure, or final block extraction.

Updated proof-DAG row:

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `odbs_route_contract_drift_column8_guard` | keep the theorem-route active `O_D^BS` matrix separated from the legacy helper at source column `8` | GHL2025 Lemma `lemma: Banded-sparse-access`; existing guard `oneTermRobinGate_O_D_BS_contractDrift_column8_n3`; blocker row `QBE.ODBS.UnusedZeroBranchExtension` | `oneTermRobinBlockEncodingProofRoute_contractDriftColumn8Blocked_n3`; focused test in `Tests/Basic.lean` | reviewer source-gate audit; guard-only lower packets | compiled guard; lower proof search, dagger cleanup, and block correctness remain false |

### 2026-05-24 Lower Projection-Source Freeze Guard

Lower promoted the repeated test-only combination of the block-projection audit
and the source-blocker audit into the named Lean guard
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_projectionSourceFreeze`.
The guard records that the theorem route still uses signal index `0`, the
normalizer $N_DN_f\kappa$, open block-projection and block-correctness flags,
open circuit-unitary and block-extraction flags, open LCU correctness, and
`lowerProofSearchAllowed = false`.

This is a proof-DAG cleanup for reviewer checks only.  It does not choose an
unused-branch image rule, change the active $O_D^{BS}$ matrices, or promote
O_D^BS injectivity, dagger cleanup, unitarity, LCU closure, or final block
extraction.

Updated proof-DAG row:

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `odbs_projection_source_freeze` | keep the signal-index-zero projection target and theorem-level false flags synchronized with the disabled O_D^BS source decision | `oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit`; `oneTermRobinBlockEncodingProofRoute_sourceBlockerKeepsFinalFlagsFalse`; blocker row `QBE.ODBS.UnusedZeroBranchExtension` | `oneTermRobinBlockEncodingProofRoute_projectionSourceFreeze`; focused test in `Tests/Basic.lean` | reviewer source-gate audit; guard-only lower packets | compiled guard; no semantic flag promoted |

### 2026-05-24 Middle Cycle-1 Closeout

Middle rechecked the lower route guards against the source transcript and the
cited-results ledger.  No cited-result status changed.  The paper-to-Lean map
for the current blocker is:

| Source fragment | Lean-facing guard | Classification | Status |
|---|---|---|---|
| GHL2025 Lemma `lemma: Banded-sparse-access` padded map $O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n = |r_{si}\rangle^n|i\rangle^n$ | `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript`, `oneTermRobinGate_O_D_BS_contractDrift_column8_n3`, `oneTermRobinBlockEncodingProofRoute_contractDriftColumn8Blocked_n3` | `external-cited-result` transcript through the prior PDE primitive | active paper-image matrix guarded; no injectivity or cleanup proof |
| Eq. `eq: ROBIN clarified` sparse range $s=0,\dots,\kappa-1$ | `BandedSparseAccessRobinZeroInclusionSourceContract`, `oneTermRobinBlockEncodingProofRoute_sourceTranscriptIdentity` | `internal-paper-step` | zero-inclusion remains visible; no unused-branch image rule |
| Fig. `fig:1 term ROBIN` dagger-cleanup intent | `oneTermRobinBlockEncodingProofRoute_sourceGateFreeze`, `oneTermRobinBlockEncodingProofRoute_projectionSourceFreeze` | `internal-paper-step` blocked by missing oracle data | signal index $0$, normalizer $N_DN_f\kappa$, and final false flags stay synchronized |
| missing reversible image for clean unused zero-amplitude sparse branches | `QBE.ODBS.UnusedZeroBranchExtension`, `bandedSparseAccessUnusedZeroBranchSourceDecision` | `source-contract-gap` | lower proof search remains disabled |

Lean-to-paper translation of the accepted lower guards:

| Guard | Translation | Status |
|---|---|---|
| `oneTermRobinBlockEncodingProofRoute_contractDriftColumn8Blocked_n3` | the theorem route uses the Lemma 1 paper-image row `40` for source column `8`, while the legacy helper remains separated at row `4` | regression guard only |
| `oneTermRobinBlockEncodingProofRoute_activeCollisionBlocked_n3` | the current paper-image skeleton still collides on clean boundary columns `0` and `48` for $n=3,\kappa=7$ | blocker witness only |
| `oneTermRobinBlockEncodingProofRoute_projectionSourceFreeze` | the block-projection target remains signal index `0` with normalizer $N_DN_f\kappa$, and circuit-unitary, block-extraction, block-correctness, LCU, and O_D^BS lower-search flags remain false | proof-DAG guard; no semantic flag promoted |

Next lower packet:

| Field | Instruction |
|---|---|
| fixed target | preserve the current O_D^BS source-contract blocker and theorem-route false flags |
| allowed write scope | source-backed transcript updates, cited-results entries for a newly supplied exact source, conversion-window or proof-obligation notes, and focused false-flag tests |
| declarations to reuse | `oneTermRobinBlockEncodingProofRoute_sourceGateFreeze`, `oneTermRobinBlockEncodingProofRoute_projectionSourceFreeze`, `oneTermRobinBlockEncodingProofRoute_contractDriftColumn8Blocked_n3`, `oneTermRobinBlockEncodingProofRoute_activeCollisionBlocked_n3`, `oneTermRobinBlockEncodingProofRoute_sourceTranscriptIdentity`, `oneTermRobinBlockEncodingProofRoute_sourceObligationsFalse` |
| forbidden work | no O_D^BS injectivity, dagger cleanup, unitary extension, active matrix rewrite, O_f analytic closure, LCU closure, signal-index change, or final block-extraction proof search |
| source precondition | before semantic O_D^BS proof work, record an exact unused-branch image formula or named reversible-extension theorem in `research-wiki/cited-results/GHL2025.md` with status `obligation` or `contract-only` |

### 2026-05-24 Lower Prior-PDE Source-Anchor Guard

Lower added the route-level guard
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_priorPDESourceAnchorsTranscript`.
The guard keeps the prior PDE sparse-access source transcript tied to the
theorem route without changing the GHL2025 $O_D^{BS}$ source blocker.

Paper-to-Lean source-dependency map:

| Source fragment | Lean-facing guard or contract | Classification | Status |
|---|---|---|---|
| arXiv:2405.12855v3 Definition 6 and Lemma 1 for the banded sparse-access primitive | `oneTermRobinBlockEncodingProofRoute_priorPDESourceAnchorsTranscript` | `external-cited-result` | public anchors pinned; resource claim still false |
| appendix decomposition for the prior primitive | `priorSparseAccessSource.circuitDecomposition` in the same guard | `external-cited-result` transcript | records `O_A^BS = U^SUM (U_A^(l) tensor I^n)`; no new circuit proof |
| Robin unused zero-amplitude sparse branches | `QBE.ODBS.UnusedZeroBranchExtension` and `bandedSparseAccessUnusedZeroBranchSourceDecision` | `source-contract-gap` | `robinUnusedBranchImageRule = none` and lower proof search remains disabled |

Updated proof-DAG row:

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `odbs_prior_pde_source_anchor_guard` | keep the prior PDE source anchors and decomposition visible while preserving the unused-branch blocker | cited row `GHL2024.PDE.Def6Lemma1.ODBS`; blocker row `QBE.ODBS.UnusedZeroBranchExtension` | `oneTermRobinBlockEncodingProofRoute_priorPDESourceAnchorsTranscript`; focused test in `Tests/Basic.lean` | reviewer source-gate audit; guard-only lower packets | transcript guard; no image rule selected and no semantic flag promoted |

Next lower work remains guard-only unless an exact unused-branch image formula
or named reversible-extension theorem is added to
`research-wiki/cited-results/GHL2025.md`.
| acceptance | `python3 tools/qbe.py check` and the forbidden-pattern scan |

### 2026-05-24 Middle Prior-PDE Source-Anchor Sync

Middle re-read the same source anchors after the lower
`oneTermRobinBlockEncodingProofRoute_priorPDESourceAnchorsTranscript` guard:
GHL2025 Lemma `lemma: Banded-sparse-access`, Eq.
`eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, Theorem
`theorem: 1 term robin`, and the cited prior sparse-access primitive
`guseynov2024efficientPDE`.  The lower guard is an exact source-transcript
checkpoint, not a reversible-extension theorem.

Paper-to-Lean source-dependency map:

| Source fragment | Lean-facing guard or contract | Classification | Status |
|---|---|---|---|
| arXiv:2405.12855v3 Definition 6 and Lemma 1 padded sparse-access primitive | `oneTermRobinBlockEncodingProofRoute_priorPDESourceAnchorsTranscript`, `bandedSparseAccessPriorPDESourceContract` | `external-cited-result` | public anchors and resource transcript preserved; resource proof flag false |
| prior primitive decomposition $O_A^{BS} = U^{SUM}(U_A^{(l)} \otimes I^n)$ | `priorSparseAccessSource.circuitDecomposition` | `external-cited-result` transcript | decomposition text recorded; no gate-level Lean proof of a Robin unused branch |
| GHL2025 Robin zero-inclusion sentence and Eq. `eq: ROBIN clarified` | `BandedSparseAccessRobinZeroInclusionSourceContract` | `internal-paper-step` | zero-amplitude sparse branches remain in the faithful sparse range |
| clean unused zero-amplitude sparse branches | `QBE.ODBS.UnusedZeroBranchExtension`, `bandedSparseAccessUnusedZeroBranchSourceDecision` | `source-contract-gap` | no image rule selected; lower proof search remains disabled |

Lean-to-paper translation of the accepted source-anchor guard:

| Lean component | Paper-facing meaning | Status |
|---|---|---|
| `priorSparseAccessSource.sourceAnchor`, `definitionAnchor`, `lemmaAnchor`, `appendixAnchor` | the theorem route cites the prior PDE source for the imported banded sparse-access primitive | transcript guard only |
| `priorSparseAccessSource.circuitDecomposition` | the prior source decomposes the primitive as a first-row index unitary followed by modular addition | source text recorded; not a Robin unused-branch image |
| `priorSparseAccessSource.resourceClaim.proved = false` | QBE has not formalized the prior resource bound | obligation |
| `priorSparseAccessSource.robinUnusedBranchImageRule = none` and `lowerProofSearchAllowed = false` | the prior source does not close the Robin unused-zero-branch blocker | no semantic flag promoted |

Next lower packet remains guard-only.  Allowed work is source-backed transcript
maintenance, cited-results entries for a newly supplied exact image formula or
named reversible-extension theorem, proof-map notes, or focused false-flag
tests.  Forbidden work remains O_D^BS injectivity, dagger cleanup, unitary
extension, active matrix rewrites, LCU closure, signal-index changes, and final
block extraction until the missing source contract is recorded first.

### 2026-05-24 Lower Source-Decision Freeze Guard

Lower added
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_sourceDecisionOnlyFreeze_n3`
and a matching focused test.  The guard packages the existing source transcript,
rejected row-dependent collision witness, column-`8` contract-drift witness, projection-source
freeze, and source-obligation false flags for the concrete $n=3,\kappa=7$
source-contract blocker.

Lean-to-paper translation:

| Lean guard component | Paper-facing meaning | Status |
|---|---|---|
| `oneTermRobinBlockEncodingProofRoute_sourceTranscriptIdentity` | the theorem route uses the audited unused-zero-branch decision, prior PDE transcript, and Robin zero-inclusion transcript | exact transcript guard |
| `oneTermRobinBlockEncodingProofRoute_activeCollisionBlocked_n3` | the current paper-image skeleton still collides on clean boundary columns `0` and `48` | blocker witness only |
| `oneTermRobinBlockEncodingProofRoute_contractDriftColumn8Blocked_n3` | the route active gate uses paper-image row `40` for source column `8`, while the legacy helper remains separated | active/legacy regression guard |
| `oneTermRobinBlockEncodingProofRoute_projectionSourceFreeze` | signal index `0`, normalizer $N_DN_f\kappa$, and theorem-level closure flags remain false | projection-source guard |
| `oneTermRobinBlockEncodingProofRoute_sourceObligationsFalse` | the unused-branch dependency, Robin zero-inclusion image-rule obligation, reversible-extension obligation, and prior PDE resource claim remain unproved | source-obligation guard |

Updated proof-DAG row:

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `odbs_source_decision_only_freeze_n3` | keep the concrete $n=3,\kappa=7$ O_D^BS source blocker, collision witness, projection target, and final false flags synchronized | GHL2025 Lemma `lemma: Banded-sparse-access`; Eq. `eq: ROBIN clarified`; Fig. `fig:1 term ROBIN`; cited rows `GHL2025.Lemma1.ODBS`, `GHL2025.RobinZeroInclusion.ODBS`, `QBE.ODBS.UnusedZeroBranchExtension` | `oneTermRobinBlockEncodingProofRoute_sourceDecisionOnlyFreeze_n3`; focused test in `Tests/Basic.lean` | reviewer source-gate audit; next guard-only lower packet | compiled guard pending this cycle gate; no image rule selected and no semantic flag promoted |

This guard does not change either active $O_D^{BS}$ matrix and does not prove
injectivity, dagger cleanup, unitarity, LCU correctness, or block extraction.

### 2026-05-24 Middle Source-Decision Freeze Sync

Middle re-read the source anchors after the lower
`oneTermRobinBlockEncodingProofRoute_sourceDecisionOnlyFreeze_n3` guard:
GHL2025 Lemma `lemma: Banded-sparse-access`, Eq. `eq: ROBIN clarified`,
Fig. `fig:1 term ROBIN`, Theorem `theorem: 1 term robin`, and the cited
prior sparse-access primitive.  No cited-result status changes.  The new guard
is a route checkpoint for the existing source-contract gap, not a proof of the
gap.

Paper-to-Lean source-dependency map for the current blocker:

| Source fragment | Lean-facing guard or contract | Classification | Status |
|---|---|---|---|
| Lemma `lemma: Banded-sparse-access` padded map $O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n = |r_{si}\rangle^n|i\rangle^n$ | `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript`, `oneTermRobinBlockEncodingProofRoute_sourceDecisionOnlyFreeze_n3` | `external-cited-result` through the prior PDE primitive | transcript preserved; no unused-branch image rule |
| Eq. `eq: ROBIN clarified` sparse range $s=0,\dots,\kappa-1$ | `BandedSparseAccessRobinZeroInclusionSourceContract`, `oneTermRobinBlockEncodingProofRoute_sourceTranscriptIdentity` | `internal-paper-step` | zero-inclusion transcript preserved |
| Fig. `fig:1 term ROBIN` dagger-cleanup sentence | `defaultBandedSparseAccessPaperContract.daggerCleanup`, `oneTermRobinBlockEncodingProofRoute_projectionSourceFreeze` | `internal-paper-step` blocked by missing oracle data | cleanup flag remains false |
| clean unused zero-amplitude sparse branches | `QBE.ODBS.UnusedZeroBranchExtension`, `bandedSparseAccessUnusedZeroBranchSourceDecision` | `source-contract-gap` | lower proof search remains disabled |

Lean-to-paper translation of the accepted source-decision freeze:

| Guard component | Paper-facing meaning | Status |
|---|---|---|
| source transcript identity | the route uses the audited unused-zero-branch decision, prior PDE transcript, and Robin zero-inclusion transcript | exact transcript guard |
| column `48` image-rule slot | the unused-branch image remains `none` | no image rule selected |
| columns `0` and `48` | the active paper-image skeleton still has the concrete $n=3,\kappa=7$ clean-domain collision | blocker witness only |
| column `8` | the active paper-image row `40` remains separated from the legacy helper row `4` | active/legacy regression guard |
| projection and closure flags | signal index `0`, normalizer $N_DN_f\kappa$, O_D^BS cleanup, circuit unitarity, block extraction, block correctness, and LCU flags remain false | no semantic flag promoted |

Next lower packet:

| Field | Instruction |
|---|---|
| fixed target | preserve `oneTermRobinBlockEncodingProofRoute_sourceDecisionOnlyFreeze_n3` and the source-contract blocker |
| allowed edits | source-backed transcript maintenance, cited-results rows for a newly supplied exact source, proof-obligation or conversion-window notes, and focused false-flag regression tests |
| declarations to reuse | `oneTermRobinBlockEncodingProofRoute_sourceDecisionOnlyFreeze_n3`, `oneTermRobinBlockEncodingProofRoute_sourceGateFreeze`, `oneTermRobinBlockEncodingProofRoute_projectionSourceFreeze`, `oneTermRobinBlockEncodingProofRoute_contractDriftColumn8Blocked_n3`, `oneTermRobinBlockEncodingProofRoute_activeCollisionBlocked_n3`, `oneTermRobinBlockEncodingProofRoute_sourceTranscriptIdentity`, and `oneTermRobinBlockEncodingProofRoute_sourceObligationsFalse` |
| forbidden work | no O_D^BS injectivity, dagger cleanup, unitary extension, active matrix rewrite, O_f analytic closure, LCU closure, signal-index change, or final block-extraction proof search |
| source precondition | before semantic O_D^BS proof work, record an exact unused-branch image formula or named reversible-extension theorem in `research-wiki/cited-results/GHL2025.md` with status `obligation` or `contract-only` |

Updated proof-DAG row:

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `odbs_middle_source_decision_freeze_sync` | keep the latest concrete $n=3,\kappa=7$ O_D^BS blocker synchronized with the source transcript, cited-results rows, projection target, and final false flags | GHL2025 Lemma `lemma: Banded-sparse-access`; Eq. `eq: ROBIN clarified`; Fig. `fig:1 term ROBIN`; cited rows `GHL2025.Lemma1.ODBS`, `GHL2024.PDE.Def6Lemma1.ODBS`, `GHL2025.RobinZeroInclusion.ODBS`, `QBE.ODBS.UnusedZeroBranchExtension` | `oneTermRobinBlockEncodingProofRoute_sourceDecisionOnlyFreeze_n3`; synchronized notes in `proof-obligations/QBE-AUTO-002.md` and `research-wiki/cited-results/GHL2025.md` | reviewer source-gate audit; guard-only lower packets | guard-only transcript sync; no image rule selected and no semantic flag promoted |

### 2026-05-24 Middle Wrapper-Slot Source Sync

Middle re-read the source anchors after the lower
`oneTermRobinBlockEncodingProofRoute_sourceDecisionWrapperSlotsBlocked_n3`
guard: GHL2025 Lemma `lemma: Banded-sparse-access`, Eq.
`eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, Theorem
`theorem: 1 term robin`, and the cited prior sparse-access primitive
`guseynov2024efficientPDE`.  The dependency classification is unchanged.
The new guard only packages the direct per-column unused-branch image-rule
slot and the full clean-domain wrapper slot for the recorded boundary column
`48`.

Paper-to-Lean source-dependency map:

| Source fragment | Lean-facing guard or contract | Classification | Status |
|---|---|---|---|
| Lemma `lemma: Banded-sparse-access` padded map $O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n = |r_{si}\rangle^n|i\rangle^n$ | `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript` | `external-cited-result` through the prior PDE primitive | transcript preserved; no unused-branch image rule |
| Eq. `eq: ROBIN clarified` sparse range $s=0,\dots,\kappa-1$ | `BandedSparseAccessRobinZeroInclusionSourceContract` | `internal-paper-step` | zero-inclusion transcript preserved |
| Fig. `fig:1 term ROBIN` dagger-cleanup sentence | `defaultBandedSparseAccessPaperContract.daggerCleanup` | `internal-paper-step` blocked by missing oracle data | cleanup flag remains false |
| direct and wrapper slots for clean unused boundary column `48` | `oneTermRobinBlockEncodingProofRoute_sourceDecisionWrapperSlotsBlocked_n3` | `source-contract-gap` | both `proposedImageIndex` fields are `none`; both image-specified flags are false |

Lean-to-paper translation of the accepted wrapper guard:

| Lean component | Paper-facing meaning | Status |
|---|---|---|
| `unusedZeroBranchDecision.paperImageRuleSpecified = false` | no paper formula has been accepted for unused zero-amplitude sparse branches | source blocker |
| direct `bandedSparseAccessUnusedBranchImageRuleContract p 48` | the per-column image-rule interface for the concrete collision branch remains empty | `proposedImageIndex = none`, `imageSpecified.proved = false` |
| wrapper `bandedSparseAccessFullCleanDomainExtensionContract p` slot at `48` | the full clean-domain wrapper also has no image rule for the same branch | `proposedImageIndex = none`, `imageSpecified.proved = false` |
| route flags | block correctness and LCU correctness remain false | no semantic flag promoted |

Updated proof-DAG row:

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `odbs_source_decision_wrapper_slots_blocked_n3` | keep the concrete boundary unused-branch direct image slot and full clean-domain wrapper slot empty while preserving final false flags | GHL2025 Lemma `lemma: Banded-sparse-access`; Eq. `eq: ROBIN clarified`; Fig. `fig:1 term ROBIN`; cited rows `GHL2025.Lemma1.ODBS`, `GHL2024.PDE.Def6Lemma1.ODBS`, `GHL2025.RobinZeroInclusion.ODBS`, `QBE.ODBS.UnusedZeroBranchExtension` | `oneTermRobinBlockEncodingProofRoute_sourceDecisionWrapperSlotsBlocked_n3`; focused test in `Tests/Basic.lean` | reviewer source-gate audit; guard-only lower packets | compiled guard; no image rule selected and no semantic flag promoted |

Next lower packet:

| Field | Instruction |
|---|---|
| fixed target | preserve `oneTermRobinBlockEncodingProofRoute_sourceDecisionWrapperSlotsBlocked_n3` and the O_D^BS source-contract blocker |
| allowed edits | source-backed transcript notes, cited-results rows for a newly supplied exact source, proof-obligation or conversion-window notes, and focused false-flag regression tests |
| declarations to reuse | `oneTermRobinBlockEncodingProofRoute_sourceDecisionWrapperSlotsBlocked_n3`, `oneTermRobinBlockEncodingProofRoute_sourceDecisionOnlyFreeze_n3`, `oneTermRobinBlockEncodingProofRoute_sourceGateFreeze`, `oneTermRobinBlockEncodingProofRoute_projectionSourceFreeze`, `oneTermRobinBlockEncodingProofRoute_contractDriftColumn8Blocked_n3`, and `oneTermRobinBlockEncodingProofRoute_activeCollisionBlocked_n3` |
| forbidden work | no O_D^BS injectivity, dagger cleanup, unitary extension, active matrix rewrite, O_f analytic closure, LCU closure, signal-index change, or final block-extraction proof search |
| source precondition | before semantic O_D^BS proof work, record an exact unused-branch image formula or named reversible-extension theorem in `research-wiki/cited-results/GHL2025.md` with status `obligation` or `contract-only` |

### 2026-05-24 Lower Seven-Gate Flag Freeze Guard

Lower added `GHL2025.oneTermRobinGateMatrixPlaceholders_unitaryFlags` and
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gateUnitaryFlags`.
These guards pin the active Fig. `fig:1 term ROBIN` gate-matrix list to the
current proof-flag vector:

$$
[\text{true},\text{false},\text{false},\text{false},\text{false},\text{true},\text{false}].
$$

The two `true` entries are the locally compiled `U_indic` and SWAP matrix
bridges.  The `false` entries remain `O_DT^S`, `Ry_boundary`, `O_D^{BS}`,
`O_f`, and $(O_D^{BS})^\dagger$.  The route-level guard also keeps
`lowerProofSearchAllowed = false`, `circuitUnitary.proved = false`, and
`blockCorrect.proved = false`.

Updated proof-DAG row:

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `seven_gate_unitary_flag_freeze` | keep the active circuit-product gate flags synchronized with the source-contract blocker | Fig. `fig:1 term ROBIN`; existing compiled `U_indic` and SWAP proof blocks; blocker row `QBE.ODBS.UnusedZeroBranchExtension` | `oneTermRobinGateMatrixPlaceholders_unitaryFlags`, `oneTermRobinBlockEncodingProofRoute_gateUnitaryFlags`; focused test in `Tests/Basic.lean` | reviewer matrix-semantics audit; guard-only lower packets | guard added; no O_D^BS, O_f, LCU, circuit-unitary, block-projection, or block-correctness flag promoted |

### 2026-05-24 Middle Seven-Gate Source-Contract Sync

Middle re-read the source anchors for the seven-gate product after the lower
flag-freeze guard: GHL2025 Lemma `lemma: Banded-sparse-access`, Eq.
`eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, Theorem
`theorem: 1 term robin`, and the cited prior sparse-access primitive.  The
new guard is a proof-state synchronization block, not a new source theorem.

Definitions before the current theorem-route claim:

| Object | Lean declaration | Required state |
|---|---|---|
| active gate list | `GHL2025.oneTermRobinGateMatrixPlaceholders` | seven gates in Fig. `fig:1 term ROBIN` order |
| unitary flag vector | `GHL2025.oneTermRobinGateMatrixPlaceholders_unitaryFlags` | `[true, false, false, false, false, true, false]` |
| theorem route gate flags | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gateUnitaryFlags` | same vector, with source proof search disabled |
| O_D^BS source blocker | `bandedSparseAccessUnusedZeroBranchSourceDecision` | `lowerProofSearchAllowed = false` |
| block target | `Examples.RobinHeat.oneTermRobinBlockExtractionTarget` | signal index `0`, normalizer $N_DN_f\kappa$, block flags false |

Paper-to-Lean source-dependency map:

| Source step | Lean-facing contract | Classification | Status |
|---|---|---|---|
| $U_{\mathrm{indic}}$ in Fig. `fig:1 term ROBIN` | `oneTermRobinGate_U_indic`, `indicatorOracleMatrix_is_permutation` | `classical-lean-lemma` | proved local permutation; flag true |
| $O_{D^T}^{S}$ from Lemma 3 and Eq. (20) | `oneTermRobinGate_O_DT_S`, `sparseAmplitudeOracleDTCoefficientNormalizerProofRoute` | `external-cited-result` plus local contract route | active skeleton; analytic and unitarity flags false |
| boundary $R_y$ rotations | `oneTermRobinGate_Ry_boundary`, `boundaryRotationAngleNormalizerProofRoute` | `internal-paper-step` plus classical analytic obligations | active skeleton; angle and unitarity flags false |
| $O_D^{BS}$ padded map | `oneTermRobinGate_O_D_BS`, `defaultBandedSparseAccessPaperContract` | `external-cited-result` through prior sparse-access primitive | active paper-image skeleton; cleanup and unitarity false |
| $O_f$ coordinate oracle | `oneTermRobinGate_O_f`, `FunctionOracleAmplitudeProofRoute` | `external-cited-result` | active clean-branch skeleton; amplitude and unitarity false |
| SWAP in Fig. `fig:1 term ROBIN` | `oneTermRobinGate_SWAP`, `swapOracleMatrix_is_permutation` | `classical-lean-lemma` | proved local permutation; flag true |
| $(O_D^{BS})^\dagger$ cleanup sentence | `oneTermRobinGate_O_D_BS_dagger`, `BandedSparseAccessPostSwapCleanup` | `source-contract-gap` downstream of unused zero branches | conditional entry witness only; cleanup and unitarity false |

Lean-to-paper translation of the accepted lower guard:

| Lean guard component | Paper-facing meaning | Status |
|---|---|---|
| `oneTermRobinGateMatrixPlaceholders_unitaryFlags` | only $U_{\mathrm{indic}}$ and SWAP currently have compiled local permutation certificates | gate-list flag vector frozen |
| `oneTermRobinBlockEncodingProofRoute_gateUnitaryFlags` | the theorem route uses that same active seven-gate vector | no silent gate substitution |
| `unusedZeroBranchDecision.lowerProofSearchAllowed = false` | O_D^BS proof search is still blocked by the missing unused-branch image rule | source-contract blocker |
| `circuitUnitary.proved = false` and `blockCorrect.proved = false` | the final theorem remains a transcript and obligation map | no semantic flag promoted |

Next lower packet:

| Field | Instruction |
|---|---|
| fixed target | preserve `oneTermRobinBlockEncodingProofRoute_gateUnitaryFlags` and the O_D^BS source-contract blocker |
| allowed edits | source-backed transcript notes, cited-results rows for a newly supplied exact source, proof-obligation or conversion-window notes, and focused false-flag regression tests |
| declarations to reuse | `oneTermRobinGateMatrixPlaceholders_unitaryFlags`, `oneTermRobinBlockEncodingProofRoute_gateUnitaryFlags`, `oneTermRobinBlockEncodingProofRoute_sourceDecisionWrapperSlotsBlocked_n3`, `oneTermRobinBlockEncodingProofRoute_priorPDESourceAnchorsTranscript`, and `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript` |
| forbidden work | no O_D^BS injectivity, dagger cleanup, unitary extension, active matrix rewrite, O_f analytic closure, LCU correctness, circuit unitarity, block projection, or block-correctness proof search |
| source precondition | before semantic O_D^BS proof work, record an exact unused-branch image formula or named reversible-extension theorem in `research-wiki/cited-results/GHL2025.md` with status `obligation` or `contract-only` |

Updated proof-DAG row:

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `seven_gate_source_contract_freeze` | keep the active Fig. `fig:1 term ROBIN` gate flags, O_D^BS source blocker, and final theorem false flags synchronized | GHL2025 Fig. `fig:1 term ROBIN`; Lemma `lemma: Banded-sparse-access`; Eq. `eq: ROBIN clarified`; cited rows `GHL2025.Lemma1.ODBS`, `GHL2024.PDE.Def6Lemma1.ODBS`, `GHL2025.RobinZeroInclusion.ODBS`, `QBE.ODBS.UnusedZeroBranchExtension`, `GL2024.Thm5.AmplitudeOracle` | `oneTermRobinGateMatrixPlaceholders_unitaryFlags`, `oneTermRobinBlockEncodingProofRoute_gateUnitaryFlags`; synchronized notes in this window and `proof-obligations/QBE-AUTO-002.md` | reviewer matrix-semantics audit; guard-only lower packets | guard-only source-contract sync; no image rule selected and no semantic flag promoted |

### 2026-05-24 Lower Gate-List and Flag Freeze Guard

Lower added a structural gate-list guard for the active Fig. `fig:1 term
ROBIN` matrix placeholders.

Definitions before the guard claim:

| Object | Lean declaration | Required state |
|---|---|---|
| circuit labels | `GHL2025.oneTermRobinCircuit` | Fig. `fig:1 term ROBIN` gate order |
| gate placeholders | `GHL2025.oneTermRobinGateMatrixPlaceholders` | one full-space matrix per circuit label |
| gate-list projection | `GHL2025.oneTermRobinGateMatrixPlaceholders_gateList` | placeholder gates map back to `oneTermRobinCircuit` |
| theorem route gate-list and flags | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gateListAndFlags` | gate order and current proof-state vector stay synchronized |

The proof-state vector remains

$$
[\text{true},\text{false},\text{false},\text{false},\text{false},\text{true},\text{false}].
$$

The two true entries are still only $U_{\mathrm{indic}}$ and SWAP.  The
new route guard also keeps `lowerProofSearchAllowed = false`,
`circuitUnitary.proved = false`, and `blockCorrect.proved = false`.  This is
a proof-map guard only: it does not change the active O_D^BS matrices, choose
an unused-branch image rule, or promote any oracle, LCU, circuit-unitary,
block-projection, or block-correctness obligation.

Updated proof-DAG row:

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `seven_gate_order_and_flag_freeze` | keep Fig. `fig:1 term ROBIN` gate order and the active proof-state vector synchronized with the O_D^BS source blocker | Fig. `fig:1 term ROBIN`; existing source rows `GHL2025.Lemma1.ODBS`, `GHL2024.PDE.Def6Lemma1.ODBS`, `QBE.ODBS.UnusedZeroBranchExtension` | `oneTermRobinGateMatrixPlaceholders_gateList`, `oneTermRobinBlockEncodingProofRoute_gateListAndFlags`; focused test in `Tests/Basic.lean` | reviewer matrix-semantics audit; guard-only lower packets | compiled guard; no semantic flag promoted |

### 2026-05-24 Middle Gate-List Source-Contract Sync

Middle re-read the GHL2025 source anchors after the lower gate-list guard:
Lemma `lemma: Banded-sparse-access`, Eq. `eq: ROBIN clarified`, Fig.
`fig:1 term ROBIN`, Theorem `theorem: 1 term robin`, and the cited prior
sparse-access primitive `guseynov2024efficientPDE`.  The source-dependency
classification is unchanged.  The lower guard synchronizes the transcript and
the active Lean gate list; it is not a new theorem about any paper oracle.

Definitions before the current guard claim:

| Object | Lean declaration | Required state |
|---|---|---|
| paper circuit order | `GHL2025.oneTermRobinCircuit` | Fig. `fig:1 term ROBIN` order |
| active full-space matrices | `GHL2025.oneTermRobinGateMatrixPlaceholders` | seven matrices, one per paper gate label |
| gate-order guard | `GHL2025.oneTermRobinGateMatrixPlaceholders_gateList` | maps the active matrices back to `oneTermRobinCircuit` |
| theorem-route gate guard | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gateListAndFlags` | gate order, unitary flag vector, disabled source decision, and final false flags stay synchronized |
| O_D^BS source blocker | `GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision` | `lowerProofSearchAllowed = false` |

Paper-to-Lean proof-translation map for the fixed seven-gate route:

| Source step | Classification | Lean guard or contract | Remaining obligation |
|---|---|---|---|
| gate order in Fig. `fig:1 term ROBIN` | `internal-paper-step` | `oneTermRobinGateMatrixPlaceholders_gateList`, `oneTermRobinBlockEncodingProofRoute_gateListAndFlags` | none for order; only a structural guard |
| $U_{\mathrm{indic}}$ | `classical-lean-lemma` | `oneTermRobinGate_U_indic`, `indicatorOracleMatrix_is_permutation` | none for the current permutation flag |
| $O_{D^T}^{S}$ | `external-cited-result` plus analytic obligations | `oneTermRobinGate_O_DT_S` | coefficient normalizer, square-root complement, and unitarity |
| boundary $R_y$ | `internal-paper-step` plus analytic obligations | `oneTermRobinGate_Ry_boundary` | arccos relation, half-angle identities, and unitarity |
| $O_D^{BS}$ and $(O_D^{BS})^\dagger$ | `contract-drift` for the historical row-dependent helper; active global-source inverse work is a `classical-lean-lemma` over the finite address map | `oneTermRobinGate_O_D_BS`, `oneTermRobinGate_O_D_BS_dagger`, `BandedSparseAccessGlobalSlotInverseOnRangeContract`, `QBE.ODBS.GlobalSparseSlotAddress` | global-source injectivity, unique preimage, cleanup, and unitarity |
| $O_f$ | `external-cited-result` | `oneTermRobinGate_O_f`, `FunctionOracleAmplitudeProofRoute` | $N_f$ bound, orthogonal completion, amplitude correctness, and unitarity |
| SWAP | `classical-lean-lemma` | `oneTermRobinGate_SWAP`, `swapOracleMatrix_is_permutation` | none for the current permutation flag |

Lean-to-paper translation of the accepted guard:

| Lean component | Paper-facing meaning | Status |
|---|---|---|
| `oneTermRobinGateMatrixPlaceholders_gateList` | the active matrix list has the same gate labels as Fig. `fig:1 term ROBIN` | order guard compiled |
| `oneTermRobinBlockEncodingProofRoute_gateListAndFlags` | the theorem route uses that order and the flag vector `[true, false, false, false, false, true, false]` | only $U_{\mathrm{indic}}$ and SWAP are proved locally |
| `unusedZeroBranchDecision.lowerProofSearchAllowed = false` | O_D^BS proof search remains blocked by the missing unused-branch image rule | source-contract blocker |
| `circuitUnitary.proved = false` and `blockCorrect.proved = false` | the final theorem is still a transcript and obligation map | no semantic flag promoted |

Next lower packet:

| Field | Instruction |
|---|---|
| fixed target | preserve `oneTermRobinBlockEncodingProofRoute_gateListAndFlags` and the O_D^BS source-contract blocker |
| allowed edits | source-backed transcript notes, cited-results rows for a newly supplied exact source, proof-map updates, or focused false-flag tests |
| declarations to reuse | `oneTermRobinGateMatrixPlaceholders_gateList`, `oneTermRobinGateMatrixPlaceholders_unitaryFlags`, `oneTermRobinBlockEncodingProofRoute_gateListAndFlags`, `oneTermRobinBlockEncodingProofRoute_sourceDecisionWrapperSlotsBlocked_n3`, and `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript` |
| forbidden work | no O_D^BS injectivity, dagger cleanup, unitary extension, active matrix rewrite, O_f analytic closure, LCU correctness, circuit unitarity, block projection, or block-correctness proof search |
| source precondition | before semantic O_D^BS proof work, record an exact unused-branch image formula or named reversible-extension theorem in `research-wiki/cited-results/GHL2025.md` with status `obligation` or `contract-only` |

Updated proof-DAG row:

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `seven_gate_order_source_contract_freeze` | keep Fig. `fig:1 term ROBIN` gate order, active proof-state vector, O_D^BS source blocker, and final false flags synchronized | Fig. `fig:1 term ROBIN`; Lemma `lemma: Banded-sparse-access`; Eq. `eq: ROBIN clarified`; cited rows `GHL2025.Lemma1.ODBS`, `GHL2024.PDE.Def6Lemma1.ODBS`, `GHL2025.RobinZeroInclusion.ODBS`, `QBE.ODBS.UnusedZeroBranchExtension`, `GL2024.Thm5.AmplitudeOracle` | `oneTermRobinGateMatrixPlaceholders_gateList`, `oneTermRobinBlockEncodingProofRoute_gateListAndFlags`; synchronized notes in this window, `proof-obligations/QBE-AUTO-002.md`, and `research-wiki/cited-results/GHL2025.md` | reviewer matrix-semantics audit; guard-only lower packets | guard-only source-contract sync; no image rule selected and no semantic flag promoted |

### 2026-05-24 Lower Gate-Projection Freeze Guard

Lower added `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze`,
a wrapper guard over the existing seven-gate order freeze and block-projection
normalizer audit.

Definitions before the guard claim:

| Object | Lean declaration | Required state |
|---|---|---|
| active gate order | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gateListAndFlags` | Fig. `fig:1 term ROBIN` labels and the proof-state vector stay synchronized |
| projection target | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit` | target normalizer is $N_DN_f\kappa$ and signal index is `0` |
| theorem closure flags | `Examples.RobinHeat.OneTermRobinBlockEncodingProofRoute` fields | circuit unitarity, block extraction, block projection, block correctness, and LCU remain false |
| source blocker | `GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision` | `lowerProofSearchAllowed = false` |

The new guard is a proof-DAG packaging lemma for reviewer checks.  It does not
choose an unused-branch image rule, change the active $O_D^{BS}$ matrices, or
promote any oracle, LCU, circuit-unitary, block-projection, or block-correctness
obligation.

Updated proof-DAG row:

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `seven_gate_projection_freeze` | keep Fig. `fig:1 term ROBIN` gate order, proof-state vector, signal-index-zero target, and final false flags synchronized | `oneTermRobinBlockEncodingProofRoute_gateListAndFlags`; `oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit`; blocker row `QBE.ODBS.UnusedZeroBranchExtension` | `oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze`; focused regression in `Tests/Basic.lean` | reviewer matrix-semantics audit; guard-only lower packets | compiled guard; no semantic flag promoted |

### 2026-05-24 Middle Gate-Projection Source-Contract Sync

Middle re-read the GHL2025 source anchors after the lower gate-projection
freeze guard: Lemma `lemma: Banded-sparse-access`, Eq.
`eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, Theorem
`theorem: 1 term robin`, and the cited prior sparse-access primitive
`guseynov2024efficientPDE`.  The classification is unchanged.  The new guard
is proof-state packaging for reviewer checks; it is not a source theorem and
does not supply an unused-branch image rule.

Definitions before the current guard claim:

| Object | Lean declaration | Required state |
|---|---|---|
| active gate order | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gateListAndFlags` | gate labels match Fig. `fig:1 term ROBIN` |
| active proof-state vector | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze` | `[true, false, false, false, false, true, false]` |
| projection target | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit` | signal index `0` and normalizer $N_DN_f\kappa$ |
| source blocker | `GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision` | `lowerProofSearchAllowed = false` |
| theorem closure flags | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze` | circuit-unitary, block-extraction, block-projection, block-correctness, and LCU flags remain false |

Paper-to-Lean proof-translation map:

| Source step | Classification | Lean guard or contract | Remaining obligation |
|---|---|---|---|
| gate order in Fig. `fig:1 term ROBIN` | `internal-paper-step` | `oneTermRobinBlockEncodingProofRoute_gateListAndFlags` | none for order; structural guard only |
| block tuple and normalizer in Theorem `theorem: 1 term robin` | `internal-paper-step` plus final composition obligations | `oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit`, `oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze` | block projection and block correctness remain false |
| Lemma `lemma: Banded-sparse-access` padded sparse-access map | `external-cited-result` through the prior PDE primitive | `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript` | unused-branch image rule, injectivity, dagger cleanup, and unitarity |
| Eq. `eq: ROBIN clarified` sparse range $s=0,\dots,\kappa-1$ | `internal-paper-step` | `BandedSparseAccessRobinZeroInclusionSourceContract` | zero-amplitude branches stay in the sparse range but have no image rule |
| Fig. `fig:1 term ROBIN` dagger-cleanup sentence | `source-contract-gap` downstream of unused branches | `oneTermRobinBlockEncodingProofRoute_projectionSourceFreeze`, `oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze` | cleanup flag remains false |

Lean-to-paper translation of the accepted guard:

| Lean component | Paper-facing meaning | Status |
|---|---|---|
| `oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze` gate-list field | the theorem route still uses the active Fig. `fig:1 term ROBIN` gate order | no gate substitution |
| `oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze` flag vector | only $U_{\mathrm{indic}}$ and SWAP are locally proved permutation gates | five paper-oracle flags false |
| signal index and normalizer fields | the matrix backend target is the signal-zero block with normalizer $N_DN_f\kappa$ | target synchronized; correctness false |
| source decision field | O_D^BS proof search remains disabled | no image rule selected |
| final false fields | circuit unitarity, block extraction, block projection, block correctness, and LCU remain obligations | no semantic flag promoted |

Next lower packet remains guard-only.

| Field | Instruction |
|---|---|
| fixed target | preserve `oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze` and the O_D^BS source-contract blocker |
| allowed edits | source-backed transcript notes, cited-results rows for a newly supplied exact source, proof-map updates, or focused false-flag tests |
| declarations to reuse | `oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze`, `oneTermRobinBlockEncodingProofRoute_gateListAndFlags`, `oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit`, `oneTermRobinBlockEncodingProofRoute_sourceDecisionWrapperSlotsBlocked_n3`, and `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript` |
| forbidden promotions | O_D^BS injectivity, dagger cleanup, unitary extension, active matrix rewrites, O_f amplitude correctness, LCU correctness, circuit unitarity, block projection, and block correctness |
| blocker exit condition | add an exact unused-branch image formula or named reversible-extension theorem to `research-wiki/cited-results/GHL2025.md` before proof work depends on it |

Updated proof-DAG row:

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `seven_gate_projection_source_contract_freeze` | keep Fig. `fig:1 term ROBIN` gate order, proof-state vector, signal-zero target, source blocker, and final false flags synchronized | Fig. `fig:1 term ROBIN`; Theorem `theorem: 1 term robin`; Lemma `lemma: Banded-sparse-access`; Eq. `eq: ROBIN clarified`; cited rows `GHL2025.Lemma1.ODBS`, `GHL2024.PDE.Def6Lemma1.ODBS`, `GHL2025.RobinZeroInclusion.ODBS`, `QBE.ODBS.UnusedZeroBranchExtension`, `GL2024.Thm5.AmplitudeOracle`, `LCU.StandardBlockEncoding` | `oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze`; synchronized notes in this window, `proof-obligations/QBE-AUTO-002.md`, and `research-wiki/cited-results/GHL2025.md` | reviewer matrix-semantics audit; guard-only lower packets | guard-only source-contract sync; no image rule selected and no semantic flag promoted |

### 2026-05-24 Middle Global-Slot O_D^BS Source-Contract Audit

Middle re-read the local GHL2025 source around Lemma `Lemma: Diagonal
sparsity`, Lemma `lemma: Banded-sparse-access`, Remark `remark: sparsity
maximum`, the zero-inclusion paragraph before Theorem `theorem: 1 term robin`,
and Fig. `fig:1 term ROBIN`.  This audit supersedes the earlier lower packets
that treated the concrete collision
`oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3` as an active
paper-level unused-branch image gap.

Definitions for the corrected source contract:

| Object | Paper source | Lean-facing declaration |
|---|---|---|
| sparse slot $s$ | Lemma `Diagonal sparsity` and Remark `sparsity maximum` | `oneTermRobinGlobalSparseOffset`; keep `robinSparseColumnMap` as rejected-model or amplitude-entry helper only |
| clean O_D^BS input | Lemma `Banded-sparse-access-oracle` | existing `bandedSparseAccessPaperRegisters` and `bandedSparseAccessPaperCleanInput` |
| address rule | Lemma `Banded-sparse-access-oracle` formula $r_{si}=r_{s0}+i \bmod 2^n$ | `oneTermRobinGlobalSparseAddress`; corrected `bandedSparseAccessPaperAddress` |
| active image splice | Lemma `Banded-sparse-access-oracle` output $|r_{si}\rangle^n|i\rangle^n$ | `bandedSparseAccessPaperImage` through the corrected active address |
| zero-amplitude boundary slot | zero-inclusion paragraph before Theorem `1 term robin` and Eq. `eq: ROBIN clarified` | amplitude layer via `robinSparseAmplitudeValue`; do not delete the sparse-register slot |

Source-dependency classification:

| Failing Lean fact | Classification | Reason | Next action |
|---|---|---|---|
| `oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3` | rejected-model regression | the old row-dependent helper folds unused boundary sparse slots to the row address | keep as rejected-model regression after the active address correction |
| older `QBE.ODBS.UnusedZeroBranchExtension` packets | rejected active target | they try to repair the row-dependent model rather than implementing $r_{s0}+i \bmod 2^n$ | stop assigning more proof search against this target |
| corrected O_D^BS address | `internal-paper-step` plus local Lean arithmetic | the paper states the global-slot formula; Lean now has the table, modulo-address proof block, and active address rewrite | resume only targeted image/injectivity work after no-collision regression review |
| O_D^BS unitarity and dagger cleanup | blocked after correction | these depend on the corrected image being injective on the clean source domain and compatible with SWAP cleanup | resume only after corrected no-collision and image-entry tests compile |

Proof-DAG update:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `odbs_global_sparse_slot_table` | define the seven paper sparse slots as global offsets $r_{s0}$ for the one-term Robin construction | Lemma `Diagonal sparsity`; Remark `sparsity maximum`; Eq. `Eq.matirxA` | `oneTermRobinGlobalSparseOffset` | corrected O_D^BS address and amplitude-zero audit | $O_D^{BS}$ | implemented |
| `odbs_global_address` | prove the active address is $(r_{s0}+i) \bmod 2^n$ for extracted sparse slot and row | `odbs_global_sparse_slot_table`; existing register extractor | `oneTermRobinGlobalSparseAddress`, `oneTermRobinGlobalSparseAddress_inverseSlot_address_eq`, corrected `bandedSparseAccessPaperAddress` | active image, finite-image, no-spill, SWAP cleanup | $O_D^{BS}$ | implemented for the address layer |
| `odbs_rejected_row_dependent_model` | preserve old row-dependent collision as a regression against `robinSparseColumnMap`-based addressing | existing collision theorem | `bandedSparseAccessRowDependentPaperAddress`, `bandedSparseAccessRowDependentPaperImage`, `oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3` | reviewer audit | helper only | retained, but not active blocker |

Lower implementation result:

| Field | Instruction |
|---|---|
| fixed target | implemented `odbs_global_sparse_slot_table` and `odbs_global_address` without proving unitarity or cleanup |
| allowed edits | used `QuantumBlockEncoding/GHL2025.lean`, focused tests in `Tests/Basic.lean`, downstream route guards in `QuantumBlockEncoding/RobinMatrix.lean`, and synchronized notes in this window plus `proof-obligations/QBE-AUTO-002.md` |
| declarations to reuse | `BandedSparseAccessPaperRegisters`, `bandedSparseAccessPaperCleanInput`, `bandedSparseAccessPaperImage`, `bandedSparseAccessPaperMatrix`, `oneTermRobinGate_O_D_BS`, `robinSparseAmplitudeValue`, and the existing collision theorem as rejected-model memory |
| required tests | `oneTermRobinGate_O_D_BS_globalSparseBoundaryNoCollision_n3` and `Tests/Basic.lean` show corrected active-image no-collision for the old $n=3,\kappa=7$ columns `0` and `48`; the old row-dependent helper still has the rejected-model collision |
| forbidden work | no O_D^BS injectivity, dagger cleanup, unitary extension, active block extraction, O_f analytic closure, or LCU correctness proof search was performed in this packet |
| cited-results row | use `research-wiki/cited-results/GHL2025.md` row `QBE.ODBS.GlobalSparseSlotAddress`; do not use `QBE.ODBS.UnusedZeroBranchExtension` as the active lower target |

### 2026-05-24 Middle Global-Source Predicate Sync

The active source-domain predicate is now named in Lean.  The paper source
domain for Lemma `Banded-sparse-access-oracle` is the clean padded input with
encoded sparse slot $s<\kappa$.  It is not the row-dependent predicate that
keeps only nonzero Robin stencil entries.

Definitions:

| Object | Lean declaration | Source anchor | Status |
|---|---|---|---|
| sparse-index range | `bandedSparseAccessPaperSparseIndexInKappa` | Lemma `Banded-sparse-access-oracle`; zero-inclusion paragraph before Theorem `1 term robin` | executable predicate |
| active clean source | `bandedSparseAccessPaperGlobalSlotSource` | same anchors plus Remark `sparsity maximum` | executable predicate |
| old boundary columns remain active sources | `bandedSparseAccessPaperGlobalSlotSource_boundaryColumns_n3` | global slot range $s=0,\dots,\kappa-1$ | proved regression; no semantic flag promoted |
| first encoded out-of-range slot | `bandedSparseAccessPaperGlobalSlotSource_encodedOutOfRange_n3` | sparse register has three encoded bits when $\kappa=7$ | proved regression; out-of-range source remains outside the active paper slot range |

Proof-DAG update:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `odbs_global_source_domain` | define the active Lemma 1 source domain as padded clean input and $s<\kappa$ | `odbs_extract_registers`, `odbs_global_address`, GHL2025 zero-inclusion paragraph | `bandedSparseAccessPaperSparseIndexInKappa`, `bandedSparseAccessPaperGlobalSlotSource`, `bandedSparseAccessPaperGlobalSlotSource_boundaryColumns_n3`, `bandedSparseAccessPaperGlobalSlotSource_encodedOutOfRange_n3` | corrected image injectivity, dagger cleanup route, lower source-domain packet | $O_D^{BS}$ | implemented; cleanup and unitarity flags false |
| `odbs_row_dependent_audit_helper` | keep nonzero-stencil branch predicates only as rejected-model/audit memory | old `robinSparseColumnMap` helper and collision theorem | `bandedSparseAccessPaperValidSparseBranch`, `bandedSparseAccessPaperValidCleanSource`, `bandedSparseAccessPaperUnusedSparseBranch` | regression tests and paper-drift audits | helper only | retained; not active source domain |

Next lower packet:

| Field | Instruction |
|---|---|
| fixed target | prove or test one finite-image/injectivity fact for the active `bandedSparseAccessPaperGlobalSlotSource`, not for `bandedSparseAccessPaperValidCleanSource` |
| allowed write scope | `QuantumBlockEncoding/GHL2025.lean` and focused tests in `Tests/Basic.lean`; update this window or `proof-obligations/QBE-AUTO-002.md` if a declaration is added |
| declarations to reuse | `bandedSparseAccessPaperGlobalSlotSource`, `bandedSparseAccessPaperAddress`, `bandedSparseAccessPaperImage`, `oneTermRobinGlobalSparseAddress_inverseSlot_address_eq`, `bandedSparseAccessPaperImageFin`, and the existing no-collision regression |
| forbidden target | do not assign proof search against `QBE.ODBS.UnusedZeroBranchExtension` or the row-dependent clean-source split as the active blocker |
| forbidden promotions | no O_D^BS unitarity, dagger cleanup, LCU correctness, circuit unitarity, block projection, or block correctness promotion until the corrected global-source finite-permutation route compiles |

Lower result:

| Field | Lean status |
|---|---|
| compiled declaration | `oneTermRobinGate_O_D_BS_globalSlotSource_entrySafety` |
| source predicate used | `bandedSparseAccessPaperGlobalSlotSource p j.val = true` |
| parameter-family hypothesis | `2 <= p.n` supplies the n-bit address bound through `bandedSparseAccessPaperAddress_lt_gridSize_of_two_le` |
| finite image | produces `image : Fin (qubitDim (oneTermRobinTotalQubits p))` with `image.val = bandedSparseAccessPaperImage p j.val` |
| entry facts | proves the active forward and transpose-style dagger entries at that finite image |
| retained limits | injectivity, inverse uniqueness, dagger cleanup, and both gate unitarity flags remain unproved |
| focused test | `Tests/Basic.lean` checks the theorem on the old boundary column `48`, which is now an active global-slot source |

Middle follow-up:

| Field | Lean status |
|---|---|
| compiled declaration | `bandedSparseAccessPostSwapCleanup_of_globalSlotSourceCandidate_noRange` |
| source predicate used | `bandedSparseAccessPaperGlobalSlotSource p source.val = true` |
| bridge reused | extracts `bandedSparseAccessPaperCleanInput p source.val = true` and calls `bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate_noRange` |
| focused regression | `Tests/Basic.lean` uses source column `48`, where the active global-source predicate is true and the rejected row-dependent valid-source predicate is false |
| retained limits | preimage uniqueness, semantic `daggerCleanup`, both O_D^BS unitarity flags, LCU correctness, circuit unitarity, block projection, and block correctness remain unproved |

### 2026-05-24 Lower Global-Source Inverse-On-Range Interface

Lower added a fixed Lean interface for the active global-source inverse route.
The interface uses the corrected Lemma `Banded-sparse-access-oracle` source
domain: the padded $O_D^{BS}$ input is clean and the encoded sparse slot
satisfies $s<\kappa$.  The source columns still use the global address
$r_{si}=r_{s0}+i \bmod 2^n$.

Definitions:

| Object | Lean declaration | Status |
|---|---|---|
| global-source candidate audit | `bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_globalSlotSource` | proves the existing executable candidate check from `bandedSparseAccessPaperGlobalSlotSource`, finite source range, and the one-term parameter hypotheses |
| candidate finite range | `bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_globalSlotSource` | proves the candidate is a finite basis index under the same active source predicate |
| inverse-on-range obligation interface | `BandedSparseAccessGlobalSlotInverseOnRangeContract` and `bandedSparseAccessGlobalSlotInverseOnRangeContract` | fixes the source predicate, image function, post-SWAP target, and candidate preimage |
| false-flag guard | `bandedSparseAccessGlobalSlotInverseOnRangeContract_of_globalSlotSource` | records that candidate checks are true while inverse-on-range, uniqueness, injectivity, dagger cleanup, and unitary extension remain false |

Proof-DAG update:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `odbs_global_source_inverse_interface` | package the active global-source preimage candidate and keep semantic inverse obligations explicit | `bandedSparseAccessPaperGlobalSlotSource`, `bandedSparseAccessPaperPostSwapPreimageCandidate`, `oneTermRobinGlobalSparseAddress_inverseSlot_address_eq` | `BandedSparseAccessGlobalSlotInverseOnRangeContract`; candidate-check and finite-range wrappers above | next inverse uniqueness or injectivity lower packet | $O_D^{BS}$ and $(O_D^{BS})^\dagger$ | interface compiled; semantic flags false |

The new interface does not prove that `bandedSparseAccessPaperImage` is
injective on the global clean source domain.  It also does not promote
`daggerCleanup`, either $O_D^{BS}$ unitary flag, LCU correctness, circuit
unitarity, block projection, or block correctness.

Source-dependency audit: the local GHL2025 source gives the Lemma 1 oracle
equation and Fig. 1-term Robin cleanup use, but it does not give a separate
finite-domain proof that the corrected global-slot image is injective or that
the post-SWAP candidate is the unique clean preimage.  After the global-slot
correction, the missing ingredient is classified as `classical-lean-lemma`:
finite bit-slice arithmetic and finite-map injectivity for
`bandedSparseAccessPaperImage` on `bandedSparseAccessPaperGlobalSlotSource`.
It is not an `external-cited-result`, and it is not permission to revive the
old row-dependent unused-branch packet as the active target.

Next lower packet:

| Field | Instruction |
|---|---|
| fixed target | prove one injectivity or unique-preimage lemma that uses `bandedSparseAccessPaperGlobalSlotSource` and feeds `BandedSparseAccessGlobalSlotInverseOnRangeContract` |
| allowed write scope | `QuantumBlockEncoding/GHL2025.lean`, focused examples in `Tests/Basic.lean`, and a short sync in this window or `proof-obligations/QBE-AUTO-002.md` |
| declarations to reuse | `bandedSparseAccessPaperGlobalSlotSource`, `oneTermRobinGlobalSparseAddress_inverseSlot_address_eq`, `bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_globalSlotSource`, `bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_globalSlotSource`, and `bandedSparseAccessGlobalSlotInverseOnRangeContract_of_globalSlotSource` |
| forbidden target | no proof search against `QBE.ODBS.UnusedZeroBranchExtension` or the row-dependent valid-source predicate as the active blocker |
| forbidden promotions | keep `inverseOnRange.proved`, `uniquePreimage.proved`, `imageInjectiveOnGlobalSource.proved`, `daggerCleanup.proved`, both O_D^BS unitary flags, LCU correctness, circuit unitarity, block projection, and block correctness false until a full theorem compiles |

### 2026-05-24 Lower Global-Source Inverse-Slot Injectivity

Lower accepted one finite-table block for the active global-slot route.  The
definition `oneTermRobinGlobalSparseInverseSlot` is the reverse sparse slot used
by the post-SWAP preimage candidate.  On the active one-term Robin slot set
$s<7$, Lean now proves that this table is an involution and injective.

The global-source wrapper uses `bandedSparseAccessPaperGlobalSlotSource` and
the one-term hypothesis $\kappa=7$: if two active source columns have the same
reverse sparse slot, then their extracted sparse slots are equal.  This is a
local source-domain lemma for the future unique-preimage proof.  It does not
prove `inverseOnRange`, `uniquePreimage`,
`imageInjectiveOnGlobalSource`, `daggerCleanup`, or either $O_D^{BS}$ unitarity
flag.

Accepted declarations:

| Lean declaration | Role | Status |
|---|---|---|
| `oneTermRobinGlobalSparseInverseSlot_involutive_of_lt_seven` | proves the reverse-slot table is an involution for $s<7$ | compiled |
| `oneTermRobinGlobalSparseInverseSlot_injective_of_lt_seven` | derives injectivity of the reverse-slot table for active slots | compiled |
| `bandedSparseAccessPaperGlobalSlotSource_inverseSlot_injective` | applies reverse-slot injectivity to extracted sparse slots from active global-source columns when $\kappa=7$ | compiled |

Proof-DAG update:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `odbs_global_reverse_slot_injective` | recover equality of active sparse slots from equality of reverse sparse slots | `bandedSparseAccessPaperGlobalSlotSource`, `oneTermRobinGlobalSparseInverseSlot`, one-term $\kappa=7$ range | `bandedSparseAccessPaperGlobalSlotSource_inverseSlot_injective` | next unique-clean-preimage or image-injectivity packet | $O_D^{BS}$ and $(O_D^{BS})^\dagger$ | compiled source-domain arithmetic block; semantic flags false |

### 2026-05-24 Middle Reverse-Slot Sync and Unique-Preimage Packet

Middle translated the accepted reverse-slot Lean block back into the faithful
GHL2025 proof map.  The paper source anchors are Lemma `Diagonal sparsity`,
Lemma `Banded-sparse-access-oracle`, Remark `sparsity maximum`, Eq.
`eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, and Theorem
`theorem: 1 term robin`, all from arXiv:2506.20478.  The local source gives
the oracle equation and the circuit-caption cleanup claim, but it does not give
a separate finite bit-slice proof for QBE's concrete basis-index splice.

Definitions for the next proof step:

| Object | Paper-facing role | Lean declaration |
|---|---|---|
| global sparse slot | the slot $s$ selected from the first-row band pattern | `oneTermRobinGlobalSparseOffset` |
| active O_D^BS address | $r_{si}=r_{s0}+i \bmod 2^n$ | `oneTermRobinGlobalSparseAddress`, `bandedSparseAccessPaperAddress` |
| active clean source | $|0\rangle^{n-l}|s\rangle^l|i\rangle^n$ with $s<\kappa$ | `bandedSparseAccessPaperGlobalSlotSource` |
| post-SWAP candidate slot | the slot that should undo the source slot after SWAP | `oneTermRobinGlobalSparseInverseSlot` |
| fixed obligation record | inverse-on-range, unique preimage, image injectivity, cleanup, and unitarity remain false | `BandedSparseAccessGlobalSlotInverseOnRangeContract` |

Lean-to-paper sync for the accepted lower block:

| Lean declaration | Paper comparison | Status |
|---|---|---|
| `oneTermRobinGlobalSparseInverseSlot_involutive_of_lt_seven` | the seven Robin slots have a finite reverse-slot table | compiled local arithmetic |
| `oneTermRobinGlobalSparseInverseSlot_injective_of_lt_seven` | the reverse-slot table does not identify two active slots | compiled local arithmetic |
| `bandedSparseAccessPaperGlobalSlotSource_inverseSlot_injective` | the same reverse-slot injectivity applies to extracted sparse slots from active clean sources when $\kappa=7$ | compiled source-domain wrapper |
| `bandedSparseAccessGlobalSlotInverseOnRangeContract_of_globalSlotSource` | the candidate audit is true while inverse, uniqueness, cleanup, and unitary fields stay false | compiled false-flag guard |

Source-dependency classification:

| Missing ingredient | Classification | Reason |
|---|---|---|
| uniqueness of the post-SWAP clean preimage | `classical-lean-lemma` | after the global-slot correction, this is finite arithmetic for the seven offsets and the concrete register splice |
| O_D^BS dagger cleanup | blocked on the uniqueness lemma | Fig. `fig:1 term ROBIN` claims cleanup, but QBE still needs the basis-index proof |
| O_D^BS unitarity and block extraction | blocked downstream | no semantic flag can be promoted until the inverse-on-range and cleanup fields compile |
| row-dependent collision packet | `contract-drift` memory only | it tests the rejected `robinSparseColumnMap` address model and is not the active source target |

Proof-translation map for the next lower packet:

| Source step | Lean status | Next Lean target |
|---|---|---|
| Lemma `Banded-sparse-access-oracle` maps $|0\rangle^{n-l}|s\rangle^l|i\rangle^n$ to $|r_{si}\rangle^n|i\rangle^n$ | active image uses `bandedSparseAccessPaperImage` with `bandedSparseAccessPaperAddress` | reuse existing image and register extraction lemmas |
| Fig. `fig:1 term ROBIN` applies SWAP after O_D^BS | row/address register equations are already named | reuse `bandedSparseAccessPaperPostSwap_rowValue_eq_address` and `bandedSparseAccessPaperPostSwap_odRegisterValue_eq_rowValue` |
| Fig. `fig:1 term ROBIN` then applies $(O_D^{BS})^\dagger$ to clean the padded sparse register | candidate exists and passes Boolean checks, but uniqueness is false | prove one finite global-address uniqueness lemma |
| Theorem `1 term robin` uses this cleanup in the block-encoding route | final route flags remain false | do not promote `daggerCleanup`, unitarity, LCU, circuit unitarity, block projection, or block correctness |

Updated proof-DAG row:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `odbs_global_reverse_slot_injective` | recover equality of active sparse slots from equality of reverse sparse slots | global-source predicate; one-term $\kappa=7$ range | `bandedSparseAccessPaperGlobalSlotSource_inverseSlot_injective` | unique-preimage packet | $O_D^{BS}$ and $(O_D^{BS})^\dagger$ | compiled |
| `odbs_global_inverse_slot_unique_address` | if $t<7$ and `oneTermRobinGlobalSparseAddress n t (oneTermRobinGlobalSparseAddress n s i) = i`, then $t$ is the reverse slot of $s$ | `oneTermRobinGlobalSparseAddress_comp_eq_mod_offset_sum`, `oneTermRobinGlobalSparseOffset_sum_mod_eq_zero_unique_of_lt_seven`, finite seven-slot table | `oneTermRobinGlobalSparseAddress_inverseSlot_unique_of_lt_seven` | `BandedSparseAccessGlobalSlotInverseOnRangeContract.uniquePreimage` route | $O_D^{BS}$ and $(O_D^{BS})^\dagger$ | compiled local arithmetic |

Completed lower packet:

| Field | Instruction |
|---|---|
| fixed Lean target | `oneTermRobinGlobalSparseAddress_inverseSlot_unique_of_lt_seven` now proves: for `3 <= n`, `s < 7`, `t < 7`, `i < gridSize n`, and `oneTermRobinGlobalSparseAddress n t (oneTermRobinGlobalSparseAddress n s i) = i`, `t = oneTermRobinGlobalSparseInverseSlot s` |
| allowed write scope | `QuantumBlockEncoding/GHL2025.lean` and focused examples in `Tests/Basic.lean`; update this window or `proof-obligations/QBE-AUTO-002.md` if the declaration is added |
| declarations added | `oneTermRobinGlobalSparseOffset_lt_gridSize_of_lt_seven`, `oneTermRobinGlobalSparseAddress_comp_eq_mod_offset_sum`, `oneTermRobinGlobalSparseOffset_sum_mod_eq_zero_unique_of_lt_seven`, and `oneTermRobinGlobalSparseAddress_inverseSlot_unique_of_lt_seven` |
| proof method | finite case split over the seven active slots, with `gridSize n >= 8` from `3 <= n`; the fixed-row equation is reduced to a zero offset modulo `gridSize n` |
| required test | `Tests/Basic.lean` now has a general example using the new theorem and a concrete `n=3`, `s=0`, `t=4`, `i=0` boundary-slot example |
| forbidden target | do not work on `QBE.ODBS.UnusedZeroBranchExtension` or the row-dependent valid-source predicate as the active route |
| forbidden promotions | keep `inverseOnRange.proved`, `uniquePreimage.proved`, `imageInjectiveOnGlobalSource.proved`, `daggerCleanup.proved`, both O_D^BS unitary flags, LCU correctness, circuit unitarity, block projection, and block correctness false |

### 2026-05-24 Middle Post-Unique-Address Handoff

Middle rechecked the source anchors after the unique-address block compiled.
The relevant GHL2025 source remains Lemma `Diagonal sparsity`, Lemma
`Banded-sparse-access-oracle`, Remark `sparsity maximum`, the zero-inclusion
paragraph before Theorem `1 term robin`, Eq. `eq: ROBIN clarified`, and Fig.
`fig:1 term ROBIN`, all from arXiv:2506.20478.  The paper gives the
global-slot address equation and uses $(O_D^{BS})^\dagger$ after SWAP, but it
does not spell out QBE's concrete finite basis-index uniqueness proof.

Lean-to-paper sync for the latest accepted block:

| Lean declaration | Paper-facing meaning | Status |
|---|---|---|
| `oneTermRobinGlobalSparseOffset_lt_gridSize_of_lt_seven` | every active one-term Robin slot offset is an $n$-bit address when `3 <= n` | compiled local arithmetic |
| `oneTermRobinGlobalSparseAddress_comp_eq_mod_offset_sum` | composing two global-slot addresses adds their offsets modulo $2^n$ | compiled local arithmetic |
| `oneTermRobinGlobalSparseOffset_sum_mod_eq_zero_unique_of_lt_seven` | a zero offset sum identifies the reverse slot in the seven-slot table | compiled local arithmetic |
| `oneTermRobinGlobalSparseAddress_inverseSlot_unique_of_lt_seven` | if slot `t` undoes slot `s` on an in-range row, then `t = oneTermRobinGlobalSparseInverseSlot s` | compiled local arithmetic |
| `bandedSparseAccessGlobalSlotInverseOnRangeContract_flags_false` | inverse-on-range, unique preimage, image injectivity, cleanup, and unitary extension remain false | compiled status guard |

Updated source-dependency classification:

| Remaining proof step | Classification | Reason |
|---|---|---|
| lift slot uniqueness to a concrete `bandedSparseAccessPaperPostSwapPreimageCandidate` theorem | `classical-lean-lemma` | the source equation is fixed; the remaining work is register extraction, SWAP register equations, and finite splice arithmetic |
| image injectivity on `bandedSparseAccessPaperGlobalSlotSource` | `classical-lean-lemma` | this is finite-map reasoning for the corrected active image, not an external sparse-oracle theorem |
| `daggerCleanup.proved`, O_D^BS unitarity, LCU correctness, and final block extraction | blocked downstream | no semantic flag can be promoted until the basis-index inverse or injectivity theorem compiles |
| row-dependent unused-branch repair | `contract-drift` memory only | the old helper is retained as a regression; it is not the active paper address |

Next lower packet:

| Field | Instruction |
|---|---|
| fixed target | prove a concrete basis-index unique-preimage or image-injectivity lemma over `bandedSparseAccessPaperGlobalSlotSource`, using `oneTermRobinGlobalSparseAddress_inverseSlot_unique_of_lt_seven` |
| preferred Lean shape | show that the `bandedSparseAccessPaperPostSwapPreimageCandidate` sparse slot is the only active slot that can map the post-SWAP column back through `bandedSparseAccessPaperImage` |
| declarations to reuse | `bandedSparseAccessPaperGlobalSlotSource`, `bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_globalSlotSource`, `bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_globalSlotSource`, `bandedSparseAccessPaperPostSwap_rowValue_eq_address`, `bandedSparseAccessPaperPostSwap_odRegisterValue_eq_rowValue`, `oneTermRobinGlobalSparseAddress_inverseSlot_unique_of_lt_seven`, and `bandedSparseAccessGlobalSlotInverseOnRangeContract_of_globalSlotSource` |
| allowed write scope | `QuantumBlockEncoding/GHL2025.lean` and focused examples in `Tests/Basic.lean`; update this window or `proof-obligations/QBE-AUTO-002.md` if a declaration is added |
| forbidden targets | do not assign active proof search to `QBE.ODBS.UnusedZeroBranchExtension`, `bandedSparseAccessPaperValidCleanSource`, or the row-dependent image helpers |
| forbidden promotions | keep `inverseOnRange.proved`, `uniquePreimage.proved`, `imageInjectiveOnGlobalSource.proved`, `daggerCleanup.proved`, O_D^BS unitarity, LCU correctness, circuit unitarity, block projection, and block correctness false until a full theorem compiles |

### 2026-05-24 Lower Global-Source Image Injectivity

Lower proved the first concrete finite-map injectivity block for the corrected
active `O_D^BS` paper image.  The theorem
`bandedSparseAccessPaperImage_injective_on_globalSlotSource` says that, for the
one-term family hypotheses `3 <= p.n`, `p.kappa = 7`, and
`clog2 p.kappa = 3`, two finite columns in
`bandedSparseAccessPaperGlobalSlotSource` are equal whenever their active
paper images are equal.

This is a Lean-local basis-index proof block.  It does not set
`imageInjectiveOnGlobalSource.proved`, `uniquePreimage.proved`,
`daggerCleanup.proved`, or either $O_D^{BS}$ unitarity flag to true.

Accepted declarations:

| Lean declaration | Paper-facing meaning | Status |
|---|---|---|
| `oneTermRobinGlobalSparseInverseSlot_lt_seven` | the reverse slot stays in the seven active Robin slots | compiled local arithmetic |
| `oneTermRobinGlobalSparseAddress_same_row_injective_of_lt_seven` | for a fixed row, the seven-slot global address is injective in the sparse slot | compiled; reuses `oneTermRobinGlobalSparseAddress_inverseSlot_unique_of_lt_seven` |
| `bandedSparseAccessPaperRegisters_odRegisterValue_lt` | the extracted O_D register is an $n$-bit block | compiled bit-slice bound |
| `bandedSparseAccessPaperAddress_same_row_injective_of_globalSlotSource` | same-row address equality on active global sources forces sparse-slot equality | compiled source-domain lift |
| `bandedSparseAccessPaperCleanInput_odRegisterValue_eq_cleanODValue` | a clean source column's O_D register is reconstructed from its sparse slot | compiled clean-register reconstruction |
| `bandedSparseAccessPaperImage_injective_on_globalSlotSource` | active paper image is injective on the faithful global-slot source domain | compiled finite-map block; semantic flags false |

Proof-DAG update:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `odbs_global_address_same_row_injective` | fixed-row equality of corrected global addresses implies equality of sparse slots | `odbs_global_inverse_slot_unique_address`, reverse-slot table bounds | `oneTermRobinGlobalSparseAddress_same_row_injective_of_lt_seven` | source-domain image injectivity | $O_D^{BS}$ | compiled local arithmetic |
| `odbs_clean_od_reconstruct` | clean padded O_D register equals the canonical clean sparse-register encoding | clean-input Boolean, O_D bit slices, `clog2 p.kappa <= p.n` | `bandedSparseAccessPaperCleanInput_odRegisterValue_eq_cleanODValue` | source-domain image injectivity and future preimage uniqueness | $O_D^{BS}$ | compiled bit-slice block |
| `odbs_global_source_image_injective` | active paper image is injective on `bandedSparseAccessPaperGlobalSlotSource` | low-prefix preservation, high-tail no-spill, address roundtrip, same-row address injectivity, clean O_D reconstruction | `bandedSparseAccessPaperImage_injective_on_globalSlotSource` | inverse-on-range route and future cleanup proof | $O_D^{BS}$ and $(O_D^{BS})^\dagger$ | compiled theorem; obligation-record flags remain false |

Next proof step:

| Field | Instruction |
|---|---|
| fixed target | lift the image-injectivity block into the post-SWAP candidate route, or prove a unique-clean-preimage theorem for `bandedSparseAccessPaperPostSwapPreimageCandidate` |
| declarations to reuse | `bandedSparseAccessPaperImage_injective_on_globalSlotSource`, `bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_globalSlotSource`, `BandedSparseAccessGlobalSlotInverseOnRangeContract`, and `bandedSparseAccessPostSwapCleanup_of_globalSlotSourceCandidate_noRange` |
| forbidden promotions | keep every obligation-record flag false until the corresponding record-level theorem is intentionally updated and reviewed |

### 2026-05-24 Middle Post-Image-Injectivity Source Sync and Packet

Middle re-read the local GHL2025 source around Lemma `Diagonal sparsity`,
Lemma `Banded-sparse-access-oracle`, Remark `sparsity maximum`, the
zero-inclusion paragraph before Theorem `1 term robin`, Eq.
`eq: ROBIN clarified`, and Fig. `fig:1 term ROBIN`.  Public proof maps should
cite arXiv:2506.20478 and these stable anchors.  The source gives the global
address rule $r_{si}=r_{s0}+i \bmod 2^n$, keeps the full slot range
$s=0,\dots,\kappa-1$, applies SWAP after the sparse-access oracle, and then
uses $(O_D^{BS})^\dagger$ to restore the padded sparse-index register.  It
does not include QBE's finite basis-index proof that the post-SWAP candidate is
the unique active clean preimage.

Definitions for the next block:

| Object | Lean declaration | Role |
|---|---|---|
| active clean source | `bandedSparseAccessPaperGlobalSlotSource` | padded clean input plus global slot condition $s<\kappa$ |
| active image | `bandedSparseAccessPaperImage` | corrected paper image using the global address table |
| post-SWAP target | `swapOracleImage p (bandedSparseAccessPaperImage p source.val)` | the target column before applying $(O_D^{BS})^\dagger$ |
| candidate preimage | `bandedSparseAccessPaperPostSwapPreimageCandidate` | splices the reverse global sparse slot into the post-SWAP column |
| image-injectivity block | `bandedSparseAccessPaperImage_injective_on_globalSlotSource` | proves uniqueness once both columns are active global sources and have the same active image |
| obligation record | `BandedSparseAccessGlobalSlotInverseOnRangeContract` | still records inverse, uniqueness, cleanup, and unitarity fields as false |

Lean-to-paper sync:

| Lean declaration | Paper-facing meaning | Status |
|---|---|---|
| `bandedSparseAccessPaperImage_injective_on_globalSlotSource` | the corrected active image is injective on the faithful global-slot source domain | compiled finite-map block |
| `bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_globalSlotSource` | the chosen candidate maps to the post-SWAP column and is clean/address-in-range under the active source predicate | compiled executable audit |
| `bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_globalSlotSource` | the candidate is a finite basis index | compiled range block |
| `bandedSparseAccessGlobalSlotInverseOnRangeContract_flags_false` | record-level inverse, uniqueness, cleanup, and unitarity flags remain false | compiled status guard |

Source-dependency classification:

| Remaining step | Classification | Reason |
|---|---|---|
| candidate is an active global source | `classical-lean-lemma` | follows from clean candidate audit, reverse slot bound, clean O_D value reconstruction, and $s<\kappa=7$ |
| post-SWAP candidate is the unique active preimage | `classical-lean-lemma` | follows from the candidate image audit plus `bandedSparseAccessPaperImage_injective_on_globalSlotSource` |
| record-level promotion of `imageInjectiveOnGlobalSource` or `uniquePreimage` | proof-state sync | requires a reviewed record-level theorem, not just the finite-map lemma |
| `daggerCleanup.proved`, O_D^BS unitarity, LCU correctness, and final block extraction | downstream blocker | no semantic flag can be promoted until the unique-preimage route is integrated into the cleanup contract |
| row-dependent unused-branch repair | `contract-drift` memory only | the old helper remains a regression for the rejected model and is not the active address route |

Proof-DAG update:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `odbs_global_source_image_injective` | if two active global-source finite columns have the same active image, then they are equal | low-prefix and high-tail preservation, same-row address injectivity, clean O_D reconstruction | `bandedSparseAccessPaperImage_injective_on_globalSlotSource` | post-SWAP unique-preimage route | $O_D^{BS}$ and $(O_D^{BS})^\dagger$ | compiled; semantic flags false |
| `odbs_post_swap_candidate_global_source` | prove the post-SWAP preimage candidate itself satisfies `bandedSparseAccessPaperGlobalSlotSource` | candidate audit, `oneTermRobinGlobalSparseInverseSlot_lt_seven`, clean O_D value bit-slice lemmas | planned helper | unique-preimage theorem | $(O_D^{BS})^\dagger$ | next lower target helper |
| `odbs_post_swap_unique_preimage` | prove any active global-source preimage for the post-SWAP target equals the candidate | candidate global-source helper, candidate image audit, active image injectivity | planned theorem | record-level inverse/cleanup route | $(O_D^{BS})^\dagger$ | next lower target |

Next lower packet:

| Field | Instruction |
|---|---|
| fixed block | `odbs_post_swap_unique_preimage` |
| primary Lean target | add `bandedSparseAccessPaperPostSwapPreimageCandidate_unique_on_globalSlotSource` |
| allowed helper | if needed, first add `bandedSparseAccessPaperPostSwapPreimageCandidate_globalSlotSource_of_globalSlotSource` for the same source and hypotheses |
| target files | `QuantumBlockEncoding/GHL2025.lean` and focused examples in `Tests/Basic.lean`; update this window or `proof-obligations/QBE-AUTO-002.md` if a declaration is added |
| declarations to reuse | `bandedSparseAccessPaperImage_injective_on_globalSlotSource`, `bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_globalSlotSource`, `bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_globalSlotSource`, `oneTermRobinGlobalSparseInverseSlot_lt_seven`, `bandedSparseAccessPaperCleanODValue_sparseIndex_eq`, and `bandedSparseAccessGlobalSlotInverseOnRangeContract_flags_false` |
| proof route | prove the candidate is an active global-source finite column, extract the candidate image equality from the Boolean audit, then apply `bandedSparseAccessPaperImage_injective_on_globalSlotSource` to the competing preimage and the candidate |
| required test | add one general `Tests/Basic.lean` example for the new theorem and one concrete $n=3,\kappa=7$ post-SWAP boundary-source example |
| forbidden targets | do not use `QBE.ODBS.UnusedZeroBranchExtension`, `bandedSparseAccessPaperValidCleanSource`, or row-dependent image helpers as the active route |
| forbidden promotions | keep `inverseOnRange.proved`, `uniquePreimage.proved`, `imageInjectiveOnGlobalSource.proved`, `daggerCleanup.proved`, O_D^BS unitarity, LCU correctness, circuit unitarity, block projection, and block correctness false |

Preferred theorem shape:

```lean
theorem bandedSparseAccessPaperPostSwapPreimageCandidate_unique_on_globalSlotSource
    (p : OneTermRobinParameters)
    (source pre : Fin (qubitDim (oneTermRobinTotalQubits p)))
    (hn : 3 <= p.n) (hkappa : p.kappa = 7)
    (hκbits : clog2 p.kappa = 3)
    (hsource :
      bandedSparseAccessPaperGlobalSlotSource p source.val = true)
    (hpreSource :
      bandedSparseAccessPaperGlobalSlotSource p pre.val = true)
    (hpreImage :
      bandedSparseAccessPaperImage p pre.val =
        swapOracleImage p (bandedSparseAccessPaperImage p source.val)) :
    pre.val =
      bandedSparseAccessPaperPostSwapPreimageCandidate p source.val
```

### 2026-05-24 Lower Post-SWAP Unique Preimage

Lower compiled the next finite-register block for the corrected active
$O_D^{BS}$ route.  The candidate preimage is now shown to be an active
global-slot source, and any active global-source preimage of the post-SWAP
target is equal to that candidate.

This is still a Lean-local basis-index theorem.  It does not set
`inverseOnRange.proved`, `uniquePreimage.proved`,
`imageInjectiveOnGlobalSource.proved`, `daggerCleanup.proved`, or either
$O_D^{BS}$ unitarity flag to true.

Accepted declarations:

| Lean declaration | Paper-facing meaning | Status |
|---|---|---|
| `bandedSparseAccessPaperPostSwapPreimageCandidate_sparseIndex_eq` | the candidate's extracted sparse slot is the reverse global slot of the source slot | compiled bit-slice helper |
| `bandedSparseAccessPaperPostSwapPreimageCandidate_globalSlotSource_of_globalSlotSource` | the post-SWAP candidate remains in the active clean global-slot source domain | compiled source-domain helper |
| `bandedSparseAccessPaperPostSwapPreimageCandidate_unique_on_globalSlotSource` | any active global-source preimage of the post-SWAP target equals the candidate | compiled finite-map theorem; semantic flags false |

Proof-DAG update:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `odbs_post_swap_candidate_sparse_slot` | extract the reverse sparse slot from the candidate's clean O_D splice | clean O_D value bounds, sparse-slice equation | `bandedSparseAccessPaperPostSwapPreimageCandidate_sparseIndex_eq` | candidate global-source proof | $(O_D^{BS})^\dagger$ | compiled |
| `odbs_post_swap_candidate_global_source` | prove the candidate satisfies `bandedSparseAccessPaperGlobalSlotSource` | candidate audit, reverse slot bound, candidate sparse slot helper | `bandedSparseAccessPaperPostSwapPreimageCandidate_globalSlotSource_of_globalSlotSource` | unique-preimage theorem | $(O_D^{BS})^\dagger$ | compiled |
| `odbs_post_swap_unique_preimage` | any active global-source preimage of the post-SWAP target is the candidate | candidate global-source helper, candidate image audit, active image injectivity | `bandedSparseAccessPaperPostSwapPreimageCandidate_unique_on_globalSlotSource` | cleanup contract and later record-level promotion | $(O_D^{BS})^\dagger$ | compiled; obligation-record flags remain false |

Focused tests:

| Test | Role | Status |
|---|---|---|
| general theorem wrapper in `Tests/Basic.lean` | exposes the unique-preimage theorem with abstract one-term parameters | compiled |
| concrete `n=3`, `kappa=7`, source column `48` | checks the boundary global-slot source uses the unique-preimage route | compiled |

Next remaining blocker:

| Item | Classification | Reason |
|---|---|---|
| record-level inverse/unique-preimage promotion | proof-state sync | the compiled theorem is available, but the Phase 1 obligation record still intentionally stores `proved := false` |
| dagger cleanup and unitarity | downstream blocker | the cleanup theorem must be integrated with the transpose-style matrix contract before any $O_D^{BS}$ semantic flag changes |

### 2026-05-24 Middle Post-Unique-Preimage Source Sync

Middle re-read the GHL2025 source anchors after the post-SWAP unique-preimage
block compiled: Lemma `Diagonal sparsity`, Lemma
`Banded-sparse-access-oracle`, Remark `sparsity maximum`, the zero-inclusion
paragraph before Theorem `1 term robin`, Eq. `eq: ROBIN clarified`, and Fig.
`fig:1 term ROBIN`, all from arXiv:2506.20478.  These anchors give the
global sparse-slot rule $r_{si}=r_{s0}+i \bmod 2^n$, keep all slots
$s=0,\dots,\kappa-1$ in the source domain, apply SWAP, and then call
$(O_D^{BS})^\dagger$ to restore the padded sparse-index register.

The new Lean theorem is a QBE finite-register proof block that the paper does
not spell out as a separate lemma.  No external sparse-access theorem or
unused-branch reversible-extension theorem was added.

Lean-to-paper sync:

| Lean declaration | Paper-facing meaning | Status |
|---|---|---|
| `bandedSparseAccessPaperPostSwapPreimageCandidate_sparseIndex_eq` | the candidate writes the reverse seven-slot sparse index into the clean padded $O_D^{BS}$ register | compiled bit-slice block |
| `bandedSparseAccessPaperPostSwapPreimageCandidate_globalSlotSource_of_globalSlotSource` | the candidate is still a clean source for the corrected global-slot oracle | compiled source-domain block |
| `bandedSparseAccessPaperPostSwapPreimageCandidate_unique_on_globalSlotSource` | any active global-source preimage of the post-SWAP target is the candidate | compiled finite-map theorem |
| `bandedSparseAccessGlobalSlotInverseOnRangeContract_flags_false` | inverse, unique-preimage, image-injectivity, cleanup, and unitary-extension fields remain false | compiled guard |

Source-dependency classification:

| Remaining step | Classification | Reason |
|---|---|---|
| record-level `uniquePreimage` or `imageInjectiveOnGlobalSource` promotion | proof-state sync | the finite theorem exists, but the Phase 1 record still stores false flags until a reviewed bridge states exactly what is being promoted |
| $(O_D^{BS})^\dagger$ cleanup entry theorem | `classical-lean-lemma` | integrate the unique-preimage theorem with the transpose-style dagger matrix and existing post-SWAP cleanup witness |
| $O_D^{BS}$ unitarity and final block extraction | downstream blocker | still require cleanup integration, unitary-extension reasoning, LCU composition, and block-projection proof |
| row-dependent unused-branch route | `contract-drift` memory | retained only as regression evidence for `robinSparseColumnMap`; it is not the active paper address |

Proof-DAG status:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `odbs_post_swap_unique_preimage` | any active global-source preimage of the post-SWAP target is the candidate | candidate global-source helper, candidate image audit, active image injectivity | `bandedSparseAccessPaperPostSwapPreimageCandidate_unique_on_globalSlotSource` | cleanup-contract bridge | $(O_D^{BS})^\dagger$ | compiled; semantic flags false |
| `odbs_record_level_inverse_bridge` | decide how the compiled finite theorem is reflected in `BandedSparseAccessGlobalSlotInverseOnRangeContract` without overclaiming cleanup or unitarity | unique-preimage theorem, false-flag guard, source-contract audit | planned bridge | dagger-cleanup integration | $(O_D^{BS})^\dagger$ | next lower target |
| `odbs_dagger_cleanup_contract` | prove the transpose-style dagger matrix cleans the active post-SWAP global-source image | record-level inverse bridge, candidate range, dagger entry facts | planned theorem | $O_D^{BS}$ unitarity and block route | $(O_D^{BS})^\dagger$ | blocked downstream |

Next lower packet:

| Field | Instruction |
|---|---|
| fixed block | `odbs_record_level_inverse_bridge` |
| primary target | add a reviewed bridge theorem that connects `bandedSparseAccessPaperPostSwapPreimageCandidate_unique_on_globalSlotSource` to `BandedSparseAccessGlobalSlotInverseOnRangeContract`, while explicitly keeping `daggerCleanup.proved` and `unitaryExtension.proved` false |
| allowed helper | a theorem that packages the finite theorem and candidate checks into a non-semantic evidence record or guard; do not mutate the record defaults unless upper requests a flag promotion |
| target files | `QuantumBlockEncoding/GHL2025.lean`, focused tests in `Tests/Basic.lean`, and a short sync in this window or `proof-obligations/QBE-AUTO-002.md` |
| declarations to reuse | `bandedSparseAccessPaperPostSwapPreimageCandidate_unique_on_globalSlotSource`, `bandedSparseAccessPaperPostSwapPreimageCandidate_globalSlotSource_of_globalSlotSource`, `bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_globalSlotSource`, `bandedSparseAccessGlobalSlotInverseOnRangeContract_flags_false`, and the existing dagger-entry cleanup wrappers |
| forbidden promotions | do not set `daggerCleanup.proved`, either $O_D^{BS}$ unitary flag, LCU correctness, circuit unitarity, block projection, or block correctness to true |
| forbidden routes | do not revive `QBE.ODBS.UnusedZeroBranchExtension`, `bandedSparseAccessPaperValidCleanSource`, or `robinSparseColumnMap` as the active proof route |

### 2026-05-24 Lower Record-Level Inverse Bridge

Lower added the reviewed bridge theorem
`bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge`.
For a fixed active global-source column `source`, and for any active
global-source column `pre` whose active paper image is the contract field
`postSwapImageIndex`, Lean proves that `pre.val` is exactly the contract field
`candidatePreimageIndex`.

The bridge reuses
`bandedSparseAccessPaperPostSwapPreimageCandidate_unique_on_globalSlotSource`
and `bandedSparseAccessGlobalSlotInverseOnRangeContract_of_globalSlotSource`.
It also records that `sourceInGlobalDomain = true` and `candidateChecks = true`
for the same contract.  It does not promote any semantic obligation: the
`inverseOnRange`, `uniquePreimage`, `imageInjectiveOnGlobalSource`,
`daggerCleanup`, and `unitaryExtension` fields remain false.

Proof-DAG status:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `odbs_record_level_inverse_bridge` | reflect the compiled post-SWAP unique-preimage theorem in `BandedSparseAccessGlobalSlotInverseOnRangeContract` without changing obligation flags | `bandedSparseAccessPaperPostSwapPreimageCandidate_unique_on_globalSlotSource`, candidate checks, false-flag guard | `bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge` | dagger-cleanup integration | $(O_D^{BS})^\dagger$ | compiled; semantic flags false |
| `odbs_dagger_cleanup_contract` | prove the transpose-style dagger matrix cleans the active post-SWAP global-source image | record-level bridge, candidate range, dagger-entry witness | planned theorem | $O_D^{BS}$ unitarity and block route | $(O_D^{BS})^\dagger$ | next lower target |

Focused tests:

| Test | Role | Status |
|---|---|---|
| general record-level bridge wrapper in `Tests/Basic.lean` | exposes the bridge for abstract one-term parameters | compiled |
| concrete `n=3`, `kappa=7`, source column `48` | checks the boundary global-slot source feeds the bridge while all contract flags stay false | compiled |

### 2026-05-24 Middle Record-Level Bridge Source Sync

Middle re-read the GHL2025 source anchors after the record-level bridge
compiled: Lemma `Diagonal sparsity`, Lemma `Banded-sparse-access-oracle`,
Remark `sparsity maximum`, the zero-inclusion paragraph before Theorem
`1 term robin`, Eq. `eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, and the
cited prior sparse-access primitive.  Public artifacts cite arXiv:2506.20478
and those paper anchors rather than local source paths.

Definition for the next block.  The post-SWAP target is
`(bandedSparseAccessGlobalSlotInverseOnRangeContract p source).postSwapImageIndex`.
The candidate preimage is
`(bandedSparseAccessGlobalSlotInverseOnRangeContract p source).candidatePreimageIndex`.
The bridge theorem
`bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge`
states uniqueness relative to the active global-source predicate, while the
contract fields `inverseOnRange`, `uniquePreimage`,
`imageInjectiveOnGlobalSource`, `daggerCleanup`, and `unitaryExtension` remain
`proved := false`.

Lean-to-paper sync:

| Lean declaration | Paper-facing meaning | Status |
|---|---|---|
| `bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge` | reflects the compiled post-SWAP unique-preimage theorem in the fixed O_D^BS inverse-on-range contract | compiled bridge; semantic flags false |
| `bandedSparseAccessPaperPostSwapPreimageCandidate_unique_on_globalSlotSource` | any active global-source preimage of the post-SWAP target is the candidate | compiled finite-map theorem |
| `bandedSparseAccessPostSwapCleanup_of_globalSlotSourceCandidate_noRange` | given the candidate, the existing cleanup witness supplies the active dagger entry and register-audit booleans | compiled conditional witness; does not prove semantic cleanup |

Proof-translation map for the next lower packet:

| Source step | Lean status | Next Lean target |
|---|---|---|
| Lemma `Banded-sparse-access-oracle` gives the global-slot image $|0\rangle^{n-l}|s\rangle^l|i\rangle^n \mapsto |r_{si}\rangle^n|i\rangle^n$ | active image and global-source uniqueness route compile | reuse `bandedSparseAccessPaperImage` and the record-level bridge |
| Fig. `fig:1 term ROBIN` applies SWAP after O_D^BS | post-SWAP register equations and candidate checks compile | reuse `bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_globalSlotSource` |
| Fig. `fig:1 term ROBIN` applies $(O_D^{BS})^\dagger$ to restore the padded sparse-index register | conditional cleanup witness, unique active-source candidate, and contract-level dagger-entry bridge compile | review the narrower cleanup-contract scope without setting record flags true |
| Theorem `1 term robin` uses cleanup inside the full block-encoding route | final route flags remain false | do not promote unitarity, LCU, circuit unitarity, block projection, or block correctness |

Source-dependency classification:

| Remaining step | Classification | Reason |
|---|---|---|
| narrow dagger-cleanup bridge from the record-level inverse evidence to the existing transpose-style dagger entry | `classical-lean-lemma`, discharged locally | `bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerCleanupBridge` packages the finite post-SWAP target, candidate preimage, dagger entry, and executable cleanup checks |
| record-level flag promotion | proof-state sync | Phase 1 keeps the obligation records false until reviewer accepts an explicit semantic theorem and its scope |
| O_D^BS unitarity and final block extraction | downstream blocker | still require full clean-domain or full-space unitary-extension reasoning plus LCU/block-composition proof |
| row-dependent unused-branch route | `contract-drift` memory | retained only as regression evidence for `robinSparseColumnMap`; it is not the active paper address |

Proof-DAG status:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `odbs_record_level_inverse_bridge` | reflect active global-source unique-preimage evidence in the fixed inverse contract without changing obligation flags | post-SWAP unique-preimage theorem, candidate checks, false-flag guard | `bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge` | dagger-cleanup bridge | $(O_D^{BS})^\dagger$ | compiled; semantic flags false |
| `odbs_dagger_cleanup_entry_bridge` | package the contract candidate, dagger entry, and cleanup witness for the post-SWAP image | record-level bridge, candidate range/checks, `bandedSparseAccessPostSwapCleanup_of_globalSlotSourceCandidate_noRange` | `bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerCleanupBridge` | later cleanup contract | $(O_D^{BS})^\dagger$ | compiled; semantic flags false |
| `odbs_dagger_cleanup_contract` | turn the entry bridge into a reviewed semantic cleanup theorem only after its exact scope is accepted | entry bridge, source-domain audit, obligation-record policy | planned theorem | O_D^BS unitarity and block route | $(O_D^{BS})^\dagger$ | blocked downstream |

Next lower packet:

| Field | Instruction |
|---|---|
| fixed block | reviewed cleanup-contract map after `odbs_dagger_cleanup_entry_bridge` |
| primary Lean target | decide the exact non-promoting theorem statement that should consume `bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerCleanupBridge` |
| allowed helper | a wrapper that states the compiled cleanup witness and uniqueness bridge side by side, if reviewer wants a narrower inverse-on-range theorem |
| target files | `QuantumBlockEncoding/GHL2025.lean` and focused examples in `Tests/Basic.lean`; update this window or `proof-obligations/QBE-AUTO-002.md` if a declaration is added |
| declarations to reuse | `bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge`, `bandedSparseAccessGlobalSlotInverseOnRangeContract_of_globalSlotSource`, `bandedSparseAccessPostSwapCleanup_of_globalSlotSourceCandidate_noRange`, `bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_globalSlotSource`, and `oneTermRobinGate_O_D_BS_dagger_postSwap_entry_of_preimage` |
| completed test coverage | `Tests/Basic.lean` has an abstract wrapper example and a concrete $n=3,\kappa=7$ boundary-source example showing the dagger-entry bridge applies while contract flags remain false |
| forbidden promotions | keep `inverseOnRange.proved`, `uniquePreimage.proved`, `imageInjectiveOnGlobalSource.proved`, `daggerCleanup.proved`, O_D^BS unitarity, LCU correctness, circuit unitarity, block projection, and block correctness false |
| forbidden routes | do not use `QBE.ODBS.UnusedZeroBranchExtension`, `bandedSparseAccessPaperValidCleanSource`, or row-dependent image helpers as the active route |

### 2026-05-24 Middle Cleanup-Contract Proof Map

Middle re-audited the source anchors before assigning the next lower packet:
GHL2025 Lemma `Diagonal sparsity`, Lemma `Banded-sparse-access-oracle`,
Remark `sparsity maximum`, the zero-inclusion paragraph before Theorem
`1 term robin`, Eq. `eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, and the
prior sparse-access citation.  The paper source supplies the padded-register
oracle equation $|0\rangle^{n-l}|s\rangle^l|i\rangle^n \mapsto
|r_{si}\rangle^n|i\rangle^n$, the global-slot rule
$r_{si}=r_{s0}+i \bmod 2^n$, and the circuit-level cleanup use of
$(O_D^{BS})^\dagger$.  It does not give a separate QBE basis-index theorem
that upgrades the existing obligation flags.

Definitions for the next block:

| Object | Lean declaration | Role |
|---|---|---|
| active source predicate | `bandedSparseAccessPaperGlobalSlotSource` | clean padded input with encoded sparse slot $s<\kappa$ |
| post-SWAP target | `(bandedSparseAccessGlobalSlotInverseOnRangeContract p source.val).postSwapImageIndex` | the column reached after $O_D^{BS}$ and SWAP |
| named preimage | `(bandedSparseAccessGlobalSlotInverseOnRangeContract p source.val).candidatePreimageIndex` | the global reverse-slot candidate used by $(O_D^{BS})^\dagger$ |
| cleanup witness | `BandedSparseAccessPostSwapCleanup` | packages the transpose-style dagger entry and executable register checks |
| existing bridge | `bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerCleanupBridge` | gives `post`, `pre`, cleanup witness, dagger entry, and false cleanup/unitary flags |
| uniqueness bridge | `bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge` | identifies any active global-source preimage of the contract post-SWAP target with the named candidate |

Proof-translation map:

| Source step | Current Lean evidence | Remaining Lean statement |
|---|---|---|
| Lemma `Banded-sparse-access-oracle` maps the clean padded sparse-index source to the global-slot address | active `bandedSparseAccessPaperImage` and global-source injectivity route compile | reuse the current active image; do not use row-dependent helpers |
| Fig. `fig:1 term ROBIN` applies SWAP after $O_D^{BS}$ | post-SWAP target and candidate checks compile | reuse the contract fields and `BandedSparseAccessPostSwapCleanup` |
| Fig. `fig:1 term ROBIN` applies $(O_D^{BS})^\dagger$ to restore the padded sparse-index register | dagger-entry bridge and active-source uniqueness compile | `bandedSparseAccessGlobalSlotInverseOnRangeContract_cleanupContractMap` places these facts side by side without flag promotion |
| Theorem `1 term robin` uses cleanup inside the final block-encoding route | final route flags are still false | no `daggerCleanup`, unitarity, LCU, circuit unitarity, block projection, or block-correctness promotion |

Source-dependency classification:

| Remaining step | Classification | Reason |
|---|---|---|
| cleanup-contract map consuming the dagger-entry bridge | `classical-lean-lemma`, compiled | all ingredients are finite-register statements already in `GHL2025.lean` |
| promotion of `daggerCleanup.proved` | proof-state sync, not allowed in this packet | Phase 1 needs a reviewed semantic theorem before changing obligation records |
| $O_D^{BS}$ unitarity and block extraction | downstream blocker | requires full clean-domain or full-space unitary-extension reasoning and LCU/block-composition work |
| row-dependent unused-branch packet | `contract-drift` memory | retained only as regression evidence for `robinSparseColumnMap` |

Updated proof-DAG rows:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `odbs_dagger_cleanup_entry_bridge` | package the contract post-SWAP target, candidate preimage, dagger entry, and executable cleanup checks | record-level bridge, candidate range, active global-source cleanup wrapper | `bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerCleanupBridge` | cleanup-contract wrapper | $(O_D^{BS})^\dagger$ | compiled; semantic flags false |
| `odbs_cleanup_contract_map` | state the cleanup witness, active-source uniqueness, dagger entry, and false obligation flags in one reviewed theorem | `bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerCleanupBridge`; `bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge` | `bandedSparseAccessGlobalSlotInverseOnRangeContract_cleanupContractMap` | reviewer cleanup audit; later semantic cleanup theorem | $(O_D^{BS})^\dagger$ | compiled wrapper; semantic flags false |

Lower packet result:

| Field | Instruction |
|---|---|
| fixed block | `odbs_cleanup_contract_map` |
| primary Lean declaration | added `bandedSparseAccessGlobalSlotInverseOnRangeContract_cleanupContractMap` |
| target files | updated `QuantumBlockEncoding/GHL2025.lean`, focused examples in `Tests/Basic.lean`, this window, `proof-obligations/QBE-AUTO-002.md`, and `paper-notes/GHL2025_RobinOneTerm.tex` |
| declarations reused | `bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerCleanupBridge`, `bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge`, `bandedSparseAccessGlobalSlotInverseOnRangeContract_of_globalSlotSource`, `bandedSparseAccessPostSwapCleanup_of_globalSlotSourceCandidate_noRange`, and `oneTermRobinGate_O_D_BS_dagger_postSwap_entry_of_preimage` |
| theorem scope | for an active global-source `source`, produces the contract `post` and `pre`, a `BandedSparseAccessPostSwapCleanup` witness, the candidate active-source fact, the dagger matrix entry, a uniqueness clause for active global-source preimages of `post.val`, and false inverse/cleanup/unitary flags |
| tests | added one abstract wrapper example and one concrete $n=3,\kappa=7$ source-column `48` example, both checking that the theorem applies while contract flags remain false |
| forbidden promotions | `inverseOnRange.proved`, `uniquePreimage.proved`, `imageInjectiveOnGlobalSource.proved`, `daggerCleanup.proved`, O_D^BS unitarity, LCU correctness, circuit unitarity, block projection, and block correctness remain false |
| forbidden routes | no `QBE.ODBS.UnusedZeroBranchExtension`, `bandedSparseAccessPaperValidCleanSource`, or row-dependent image helper was used as the active route |

Compiled theorem shape excerpt:

```lean
theorem bandedSparseAccessGlobalSlotInverseOnRangeContract_cleanupContractMap
    (p : OneTermRobinParameters)
    (source : Fin (qubitDim (oneTermRobinTotalQubits p)))
    (hn : 3 <= p.n) (hkappa : p.kappa = 7) (hκbits : clog2 p.kappa = 3)
    (hsource : bandedSparseAccessPaperGlobalSlotSource p source.val = true) :
    ∃ (post pre : Fin (qubitDim (oneTermRobinTotalQubits p))),
      BandedSparseAccessPostSwapCleanup p source post pre ∧
        post.val =
          (bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).postSwapImageIndex ∧
        pre.val =
          (bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).candidatePreimageIndex ∧
        (∀ pre' : Fin (qubitDim (oneTermRobinTotalQubits p)),
          bandedSparseAccessPaperGlobalSlotSource p pre'.val = true →
            bandedSparseAccessPaperImage p pre'.val = post.val →
              pre'.val = pre.val) ∧
        (oneTermRobinGate_O_D_BS_dagger p).matrix pre post = Coeff.rat 1 ∧
        (bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).daggerCleanup.proved = false ∧
        (bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).unitaryExtension.proved = false
```

### 2026-05-24 Middle Default Paper-Contract Cleanup Bridge

Middle re-used the same source-contract audit as the cleanup-contract map:
GHL2025 Lemma `Diagonal sparsity`, Lemma
`Banded-sparse-access-oracle`, Remark `sparsity maximum`, the zero-inclusion
paragraph before Theorem `1 term robin`, Eq. `eq: ROBIN clarified`, and
Fig. `fig:1 term ROBIN`, all from arXiv:2506.20478.  These anchors justify
the active global-slot address and the use of $(O_D^{BS})^\dagger$ after
SWAP.  They still do not supply a separate QBE theorem that promotes semantic
cleanup or unitarity flags.

Lean-to-paper sync:

| Lean declaration | Paper-facing meaning | Status |
|---|---|---|
| `defaultBandedSparseAccessPaperContract_cleanupRouteBridge` | ties the compiled active global-source cleanup route back to `defaultBandedSparseAccessPaperContract p` | compiled bridge; semantic flags false |
| `defaultBandedSparseAccessPaperContract_cleanupRouteBridge_boundaryColumn_n3` | specializes the default bridge to the old boundary column `48`, which is active for the global-slot source and rejected by the row-dependent source classifier | compiled regression; semantic flags false |
| `bandedSparseAccessGlobalSlotInverseOnRangeContract_cleanupContractMap` | supplies the post-SWAP target, candidate preimage, cleanup witness, active-source uniqueness, and dagger entry | compiled input to the default-contract bridge |
| `defaultBandedSparseAccessPaperContract p` | Lemma 1 paper transcript for the padded sparse-access oracle | contract-only; `daggerCleanup.proved` and `unitaryExtension.proved` remain false |

Source-dependency classification:

| Remaining step | Classification | Reason |
|---|---|---|
| default-paper-contract cleanup-route bridge | `classical-lean-lemma`, compiled | it is record-level bookkeeping over already compiled finite-register witnesses |
| promotion of `(defaultBandedSparseAccessPaperContract p).daggerCleanup.proved` | proof-state sync, not allowed in this packet | Phase 1 needs a reviewed semantic cleanup theorem before any obligation record changes |
| $O_D^{BS}$ unitarity and final block extraction | downstream blocker | require full clean-domain or full-space unitary-extension reasoning plus LCU/block-composition work |

Proof-DAG update:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `odbs_cleanup_contract_map` | state the cleanup witness, active-source uniqueness, dagger entry, and inverse-contract false flags in one reviewed theorem | dagger-cleanup bridge and unique-preimage bridge | `bandedSparseAccessGlobalSlotInverseOnRangeContract_cleanupContractMap` | default paper-contract bridge | $(O_D^{BS})^\dagger$ | compiled; semantic flags false |
| `odbs_default_contract_cleanup_bridge` | expose the same cleanup route through `defaultBandedSparseAccessPaperContract p` while keeping default cleanup/unitary and gate-unitary flags false | cleanup-contract map, paper-contract defaults, active gate records | `defaultBandedSparseAccessPaperContract_cleanupRouteBridge` | reviewer audit; later semantic cleanup theorem | $(O_D^{BS})^\dagger$ | compiled; default paper-contract flags false |

Lower packet result:

| Field | Result |
|---|---|
| fixed block | `odbs_default_contract_cleanup_bridge` |
| primary Lean declaration | `defaultBandedSparseAccessPaperContract_cleanupRouteBridge`; boundary regression `defaultBandedSparseAccessPaperContract_cleanupRouteBridge_boundaryColumn_n3` |
| target files | updated `QuantumBlockEncoding/GHL2025.lean`, focused examples in `Tests/Basic.lean`, this window, `proof-obligations/QBE-AUTO-002.md`, `research-wiki/cited-results/GHL2025.md`, and `paper-notes/GHL2025_RobinOneTerm.tex` |
| theorem scope | for an active global-source `source`, returns `post`, `pre`, a `BandedSparseAccessPostSwapCleanup` witness, active-source uniqueness for preimages of `post`, the dagger matrix entry, and false flags for the default paper-contract cleanup/unitary fields and both active $O_D^{BS}$ gate unitarity fields |
| tests | added one abstract wrapper example and one concrete $n=3,\kappa=7$ source-column `48` example |
| forbidden promotions | no `daggerCleanup`, `unitaryExtension`, O_D^BS unitarity, LCU correctness, circuit unitarity, block projection, or block correctness flag was promoted |

Next lower packet:

| Field | Instruction |
|---|---|
| fixed block | reviewer-scoped semantic cleanup theorem design |
| primary target | decide whether the next Lean target should be a theorem about the transpose-style dagger matrix on the active global-source image, or whether more source-domain/full-space extension data is required first |
| required audit | before proof search, record the exact domain of the proposed cleanup theorem and whether it is clean-domain-only or full-space unitary evidence |
| allowed files | `QuantumBlockEncoding/GHL2025.lean`, focused examples in `Tests/Basic.lean`, and this conversion window or `proof-obligations/QBE-AUTO-002.md` |
| forbidden route | do not use `QBE.ODBS.UnusedZeroBranchExtension`, `bandedSparseAccessPaperValidCleanSource`, or row-dependent image helpers as the active route |
| forbidden promotions | keep all semantic cleanup, unitarity, LCU, circuit-unitary, projection, and block-correctness flags false unless a separately reviewed theorem proves the exact flag scope |

### 2026-05-24 Lower Off-Candidate Dagger-Zero Bridge

This lower packet keeps the same source-contract audit: GHL2025 Lemma
`Banded-sparse-access-oracle` gives the global-slot address
$r_{si}=r_{s0}+i \bmod 2^n$, and Fig. `fig:1 term ROBIN` applies
$(O_D^{BS})^\dagger$ after SWAP.  The new Lean theorem is only an
active-domain matrix-entry bridge.  It does not prove full dagger cleanup,
unitarity, LCU correctness, or block extraction.

Lean-to-paper sync:

| Lean declaration | Paper-facing meaning | Status |
|---|---|---|
| `bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerOffCandidate_zero` | for the fixed contract post-SWAP target, an active global-source index other than the named candidate has zero entry in the active transpose-style $(O_D^{BS})^\dagger$ matrix | compiled bridge; `daggerCleanup.proved` and `unitaryExtension.proved` remain false |
| `bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge` | supplies the active-source uniqueness fact used to rule out the off-candidate image equality | compiled dependency; semantic flags false |
| `bandedSparseAccessPaperDaggerMatrix` | the active transpose-style matrix skeleton for the Lemma 1 paper image | active skeleton; full inverse/unitary evidence unproved |

Proof-DAG update:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `odbs_dagger_off_candidate_zero` | show that a non-candidate active global-source preimage has zero dagger entry into the contract post-SWAP target | active-source unique-preimage bridge, transpose-style dagger matrix definition, inverse-on-range false-flag guard | `bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerOffCandidate_zero` | reviewer off-branch audit; later semantic cleanup theorem design | $(O_D^{BS})^\dagger$ | compiled; cleanup and unitarity flags false |

Lower packet result:

| Field | Result |
|---|---|
| fixed block | `odbs_dagger_off_candidate_zero` |
| primary Lean declaration | `bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerOffCandidate_zero` |
| target files | updated `QuantumBlockEncoding/GHL2025.lean`, focused examples in `Tests/Basic.lean`, and this conversion window |
| tests | added one abstract theorem-forwarding example and one concrete $n=3,\kappa=7$ source-column `48` regression where the source column itself is off-candidate for its post-SWAP target |
| forbidden promotions | no `daggerCleanup`, `unitaryExtension`, O_D^BS unitarity, LCU correctness, circuit unitarity, block projection, or block-correctness flag was promoted |

Middle sync after lower:

| Field | Status |
|---|---|
| source-dependency classification | `classical-lean-lemma`; the bridge is finite-register and matrix-entry bookkeeping over the active global-slot contract |
| source-contract scope | clean-domain only, restricted to `bandedSparseAccessPaperGlobalSlotSource` rows and the contract post-SWAP target |
| semantic status | not a proof of full dagger cleanup, inverse-on-range, full-space unitarity, LCU correctness, or block extraction |
| cited-results status | `QBE.ODBS.GlobalSparseSlotAddress` remains `contract-only`; no cited result is promoted to `formalized` |

Next lower packet:

| Field | Instruction |
|---|---|
| fixed block | `odbs_restricted_dagger_column_cleanup` |
| primary Lean declaration | `bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnCleanup` |
| target statement | for an active global-source `source`, return the contract `post` and candidate `pre`, a `BandedSparseAccessPostSwapCleanup` witness, the candidate dagger entry equal to `Coeff.rat 1`, and a restricted column rule saying every active global-source `other` with `other.val ≠ pre.val` has dagger entry `Coeff.rat 0` into `post` |
| required reuse | use `defaultBandedSparseAccessPaperContract_cleanupRouteBridge` for the candidate and one-entry, then use `bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerOffCandidate_zero` for the zero entries |
| required guard | state in the theorem result that `daggerCleanup.proved`, `unitaryExtension.proved`, both active O_D^BS gate unitarity flags, LCU correctness, circuit unitarity, block projection, and block correctness remain false |
| allowed files | `QuantumBlockEncoding/GHL2025.lean`, focused examples in `Tests/Basic.lean`, and a short doc sync in this window or `proof-obligations/QBE-AUTO-002.md` |
| forbidden route | do not use `bandedSparseAccessPaperValidCleanSource`, `bandedSparseAccessPaperUnusedSparseBranch`, `bandedSparseAccessRowDependentPaperImage`, or `QBE.ODBS.UnusedZeroBranchExtension` as the active route |
| forbidden promotion | do not promote full dagger cleanup or any unitarity/block-extraction flag from this restricted active-domain column theorem |

### 2026-05-24 Lower Restricted Dagger-Column Cleanup

This lower packet discharges the planned clean-domain-only column statement.
For an active global-source `source`, the Lean theorem returns the contract
post-SWAP column, the named candidate preimage, the existing
`BandedSparseAccessPostSwapCleanup` witness, the candidate dagger entry
`Coeff.rat 1`, and a restricted column rule: every other
`bandedSparseAccessPaperGlobalSlotSource` row has dagger entry `Coeff.rat 0`
into that post-SWAP column.

Lean-to-paper sync:

| Lean declaration | Paper-facing meaning | Status |
|---|---|---|
| `bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnCleanup` | packages the candidate and off-candidate entries for the transpose-style $(O_D^{BS})^\dagger$ matrix on the active global-slot source domain | compiled; restricted active-domain evidence only |
| `defaultBandedSparseAccessPaperContract_cleanupRouteBridge` | supplies the named candidate, cleanup witness, and candidate entry `Coeff.rat 1` | reused; default cleanup and unitary-extension flags remain false |
| `bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerOffCandidate_zero` | supplies zero entries for non-candidate active global-source rows | reused; full inverse and unitarity still unproved |

Proof-DAG update:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `odbs_restricted_dagger_column_cleanup` | state the active-domain dagger column has one candidate entry and zero entries on all other active global-source rows | default cleanup-route bridge, off-candidate zero bridge, inverse-contract false-flag guard | `bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnCleanup` | reviewer cleanup-scope audit; later semantic cleanup theorem design | $(O_D^{BS})^\dagger$ | compiled; semantic cleanup, unitarity, LCU, circuit-unitarity, block projection, and block correctness remain false |

Lower packet result:

| Field | Result |
|---|---|
| fixed block | `odbs_restricted_dagger_column_cleanup` |
| primary Lean declaration | `bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnCleanup` |
| target files | updated `QuantumBlockEncoding/GHL2025.lean`, focused examples in `Tests/Basic.lean`, this window, and `proof-obligations/QBE-AUTO-002.md` |
| tests | added an abstract forwarding example and a concrete $n=3,\kappa=7$ column `48` regression that also checks theorem-route LCU, circuit-unitarity, block-projection, and block-correctness flags remain false |
| forbidden promotions | no `daggerCleanup`, `unitaryExtension`, O_D^BS unitarity, LCU correctness, circuit unitarity, block projection, block correctness, or block extraction flag was promoted |

Middle cleanup-scope audit:

| Field | Scope |
|---|---|
| source-dependency classification | `classical-lean-lemma`; no new external theorem or prior-paper result is used |
| active source domain | only rows satisfying `bandedSparseAccessPaperGlobalSlotSource`; the theorem does not cover non-clean padded-register rows or encoded sparse values outside $s<\kappa$ |
| fixed column | the contract post-SWAP target `post.val = (bandedSparseAccessGlobalSlotInverseOnRangeContract p source.val).postSwapImageIndex` |
| candidate row | `pre.val = (bandedSparseAccessGlobalSlotInverseOnRangeContract p source.val).candidatePreimageIndex` |
| compiled entry statement | candidate row has entry `Coeff.rat 1`; every other active global-source row has entry `Coeff.rat 0` into the fixed post-SWAP column |
| not proved | full-space inverse, cleanup for non-active rows, full clean-domain reversible extension, semantic dagger cleanup, unitarity, LCU correctness, circuit unitarity, block projection, and block correctness |
| cited-results status | `QBE.ODBS.GlobalSparseSlotAddress` stays `contract-only`; `GHL2025.Lemma1.ODBS` stays a source contract; `QBE.ODBS.UnusedZeroBranchExtension` stays rejected-model memory |

Lower result:

| Field | Result |
|---|---|
| fixed block | `odbs_restricted_dagger_column_indicator` |
| primary Lean declaration | `bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnIndicator` |
| target statement | for active global-source `source`, returns the same contract `post` and `pre` as the restricted cleanup theorem and proves, for every active global-source `other`, `(oneTermRobinGate_O_D_BS_dagger p).matrix other post = if other.val = pre.val then Coeff.rat 1 else Coeff.rat 0` |
| proof route | reuses `bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnCleanup`; the proof splits on `other.val = pre.val` and reuses the candidate entry and off-candidate zero clause |
| tests | added an abstract consumer example and a concrete $n=3,\kappa=7$ source `48` regression in `Tests/Basic.lean` |
| guards kept false | inverse-on-range, unique-preimage, image-injectivity, cleanup, unitary extension, both active $O_D^{BS}$ gate unitarity flags, theorem circuit-unitarity, theorem block-extraction, route LCU correctness, route block projection, and route block correctness |
| forbidden routes avoided | no use of `bandedSparseAccessPaperValidCleanSource`, `bandedSparseAccessPaperUnusedSparseBranch`, `bandedSparseAccessRowDependentPaperImage`, or `QBE.ODBS.UnusedZeroBranchExtension` as the active route |
| remaining scope limit | active global-source rows only; no full-space inverse, full clean-domain reversible extension, semantic dagger cleanup, unitarity, LCU, circuit-unitarity, projection, or block-correctness theorem was promoted |

### 2026-05-24 Middle Theorem-Route Indicator Bridge

Middle synchronized the accepted restricted dagger-column indicator with the
theorem-level proof route.  The source anchors are unchanged: GHL2025 Lemma
`Diagonal sparsity`, Lemma `Banded-sparse-access-oracle`, Remark `sparsity
maximum`, the zero-inclusion paragraph before Theorem `1 term robin`,
Eq. `eq: ROBIN clarified`, and Fig. `fig:1 term ROBIN`.  No external theorem
or new paper assumption is used.

Lean-to-paper sync:

| Lean declaration | Paper-facing meaning | Status |
|---|---|---|
| `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsRestrictedDaggerColumnIndicator` | exposes the active global-source $(O_D^{BS})^\dagger$ indicator column through `oneTermRobinBlockEncodingProofRoute` for `n >= 3` | compiled route bridge; non-promoting |
| `GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnIndicator` | supplies the clean-domain indicator formula for the contract post-SWAP target | reused dependency |
| `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_flags_false` | keeps theorem circuit-unitarity, block-extraction, projection, block-correctness, and LCU flags false | reused guard |
| `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_sparseAccessContractIdentity` | ties the route's sparse-access contract to `defaultBandedSparseAccessPaperContract` | reused guard |

Proof-DAG update:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `odbs_route_restricted_dagger_column_indicator` | route-level wrapper for the active-domain dagger-column indicator, with all theorem-route flags frozen false | restricted indicator theorem, route false-flag guard, sparse-access contract identity | `oneTermRobinBlockEncodingProofRoute_odbsRestrictedDaggerColumnIndicator` | theorem-route cleanup-scope audit; later semantic cleanup theorem design | $(O_D^{BS})^\dagger$ | compiled; no semantic flag promoted |

Scope audit:

| Field | Scope |
|---|---|
| source-dependency classification | `classical-lean-lemma` |
| covered rows | only `bandedSparseAccessPaperGlobalSlotSource` rows for the fixed contract post-SWAP target |
| covered statement | the dagger entry is `Coeff.rat 1` at the named candidate row and `Coeff.rat 0` at every other active global-source row |
| route status | `daggerCleanup`, unitary extension, O_D^BS gate unitarity, LCU correctness, circuit unitarity, block projection, block correctness, and final block extraction remain false |

### 2026-05-24 Lower Cleanup-Scope Decision

Lean now has an explicit cleanup-scope decision object:
`GHL2025.BandedSparseAccessCleanupScopeDecision`.  Its default value
`GHL2025.bandedSparseAccessCleanupScopeDecision` selects
`BandedSparseAccessCleanupScope.activeGlobalSource`, uses
`bandedSparseAccessPaperGlobalSlotSource` as the theorem domain, and points to
`bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnIndicator`
as the current compiled evidence.

The theorem-route guard
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsCleanupScopeDecision`
copies this decision into `oneTermRobinBlockEncodingProofRoute`.  It also
records that `fullCleanDomainSelected`, `fullSpaceSelected`, and
`semanticCleanupPromotionAllowed` are all `false`; the paper cleanup field,
full clean-domain cleanup field, full-space unitary-extension field, route
cleanup field, route unitary-extension field, LCU correctness, and block
correctness all remain false.

Proof-DAG update:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `odbs_cleanup_scope_decision` | choose the active global-source restricted indicator as the next cleanup theorem scope, without semantic promotion | restricted indicator theorem, default paper contract, full clean-domain wrapper, theorem-route false flags | `bandedSparseAccessCleanupScopeDecision_activeGlobalSource`, `oneTermRobinBlockEncodingProofRoute_odbsCleanupScopeDecision` | semantic cleanup theorem design; reviewer scope audit | $(O_D^{BS})^\dagger$ | compiled guard; full clean-domain and full-space cleanup remain obligations |
| rejected route | row-dependent helpers and `QBE.ODBS.UnusedZeroBranchExtension` remain regression memory only |

Next lower packet:

| Field | Instruction |
|---|---|
| fixed block | cleanup-scope decision for `O_D^BS` |
| primary target | decide whether to state a clean-domain-only semantic cleanup interface from the route indicator bridge, or whether a full-space reversible-extension theorem must be recorded first |
| required audit | name the exact domain of any proposed cleanup theorem before proof search |
| forbidden promotions | keep every semantic, unitarity, LCU, projection, and block-correctness flag false unless the exact flag scope is separately proved and reviewed |

### 2026-05-24 Middle Active-Global-Source Cleanup Interface Packet

Middle re-audited the source anchors after the cleanup-scope decision:
GHL2025 Lemma `Diagonal sparsity`, Lemma `Banded-sparse-access-oracle`,
Remark `sparsity maximum`, the zero-inclusion paragraph before Theorem
`1 term robin`, Eq. `ROBIN clarified`, Fig. `1 term ROBIN`, and the
prior sparse-access citation to `guseynov2024efficientPDE`.

The domain decision is now fixed for the next lower packet: use the
active global-source predicate only.  The allowed theorem may package
the compiled restricted dagger-column indicator as a cleanup interface
for rows satisfying `bandedSparseAccessPaperGlobalSlotSource`, but it
must keep `semanticCleanupPromotionAllowed = false` and must not mark
`daggerCleanup`, unitarity, LCU, projection, or block-correctness flags
as proved.

Paper-to-Lean proof-translation map:

| Paper step | Lean interface | Classification | Remaining obligation |
|---|---|---|---|
| Lemma `Banded-sparse-access-oracle` maps $|0\rangle^{n-l}|s\rangle^l|i\rangle^n$ to $|r_{si}\rangle^n|i\rangle^n$ with $r_{si}=r_{s0}+i \bmod 2^n$ | `bandedSparseAccessPaperAddress`, `bandedSparseAccessPaperImage`, `bandedSparseAccessPaperGlobalSlotSource` | compiled contract-only transcript | full oracle unitarity remains false |
| The Robin zero-inclusion paragraph keeps $s=0,\dots,\kappa-1$ even when an amplitude is zero | `oneTermRobinGlobalSparseAddress`, `bandedSparseAccessPaperGlobalSlotSource`, `BandedSparseAccessRobinZeroInclusionSourceContract` | contract-drift correction complete | zero coefficient semantics remain in the amplitude layer |
| Fig. `1 term ROBIN` applies SWAP after $O_D^{BS}$ | `swapOracleImage`, post-SWAP index fields in `BandedSparseAccessGlobalSlotInverseOnRangeContract` | compiled finite-index bookkeeping | no block-projection theorem yet |
| Fig. `1 term ROBIN` applies $(O_D^{BS})^\dagger$ to restore the padded sparse-index register | `bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnIndicator` | `classical-lean-lemma` on active global-source rows | semantic cleanup over the full clean domain and full-space unitary extension remain open |
| Theorem `1 term robin` claims the final normalized block encoding | `oneTermRobinBlockEncodingProofRoute_odbsCleanupScopeDecision` plus planned active-source interface | downstream theorem route | final LCU, block projection, and block correctness remain false |

Source-dependency classification for the next lower packet:

| Item | Classification | Action |
|---|---|---|
| Active global-source cleanup interface | `classical-lean-lemma` plus proof-state sync | combine the route cleanup-scope decision with the route restricted dagger-column indicator |
| Full clean-domain cleanup | `source-contract-gap` unless a precise image rule for every non-active clean branch is supplied | record a proof obligation before proof search |
| Full-space reversible extension or unitarity | `external-cited-result` if taken from the prior PDE construction, otherwise `source-contract-gap` | update `research-wiki/cited-results/GHL2025.md` before relying on it |
| Row-dependent unused-branch repair | `contract-drift` memory only | do not assign active proof search to this route |

Proof-DAG update:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `odbs_cleanup_scope_decision` | select active global-source only and forbid full-domain/full-space promotion | restricted indicator theorem, default paper contract, theorem-route false flags | `bandedSparseAccessCleanupScopeDecision_activeGlobalSource`, `oneTermRobinBlockEncodingProofRoute_odbsCleanupScopeDecision` | next interface packet | $(O_D^{BS})^\dagger$ | compiled guard |
| `odbs_active_global_source_cleanup_interface` | exposes the selected active global-source cleanup evidence through one route-level theorem while keeping all semantic flags false | cleanup-scope decision, route restricted indicator theorem, route false-flag guards | `oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupInterface` | reviewer audit before any cleanup promotion | $(O_D^{BS})^\dagger$ | compiled guard |
| full clean-domain cleanup | prove cleanup for every clean padded sparse-register source, including encoded sparse values outside $s<\kappa$ if they are in scope | exact image rule or reversible-extension contract | no active Lean declaration yet | semantic cleanup promotion | $O_D^{BS}$ and $(O_D^{BS})^\dagger$ | obligation |
| full-space unitary extension | prove the forward and dagger matrices form a full-space unitary pair | external theorem or explicit reversible extension | no active Lean declaration yet | O_D^BS unitarity and block extraction | $O_D^{BS}$ | obligation |

Completed lower packet:

| Field | Instruction |
|---|---|
| fixed block | `odbs_active_global_source_cleanup_interface` |
| primary target | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupInterface` added as an active-source-only interface wrapper |
| target statement | for `n >= 3` and active global-source `source`, return the post-SWAP target, candidate preimage, `BandedSparseAccessPostSwapCleanup` witness, the active-domain dagger-column indicator, the selected cleanup scope, the selected predicate/evidence strings, and false guards for cleanup, unitary extension, LCU correctness, block projection, and block correctness |
| required reuse | `oneTermRobinBlockEncodingProofRoute_odbsRestrictedDaggerColumnIndicator` and `oneTermRobinBlockEncodingProofRoute_odbsCleanupScopeDecision` |
| allowed files | `QuantumBlockEncoding/RobinMatrix.lean`, focused examples in `Tests/Basic.lean`, and a short sync in this window or `proof-obligations/QBE-AUTO-002.md` |
| forbidden routes | do not use `bandedSparseAccessPaperValidCleanSource`, `bandedSparseAccessPaperUnusedSparseBranch`, row-dependent image helpers, or `QBE.ODBS.UnusedZeroBranchExtension` as the active route |
| forbidden promotions | do not promote `daggerCleanup`, `unitaryExtension`, active O_D^BS gate unitarity, LCU correctness, circuit unitarity, block projection, block correctness, or final block extraction |

Lower acceptance update:
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupInterface`
now packages the post-SWAP cleanup witness, active-domain dagger-column
indicator, cleanup-scope decision fields, and false guards for cleanup,
unitarity, LCU correctness, circuit unitarity, block projection, block
correctness, and final block extraction.  Its source predicate remains
`bandedSparseAccessPaperGlobalSlotSource`; it does not promote the paper
`daggerCleanup` or full-space unitarity obligations.

### 2026-05-24 Middle Post-Interface Source Sync

Middle re-read the GHL2025 source anchors for Lemma `Diagonal sparsity`,
Lemma `Banded-sparse-access-oracle`, Remark `sparsity maximum`, the
zero-inclusion paragraph before Theorem `1 term robin`, Eq. `eq: ROBIN
clarified`, Fig. `fig:1 term ROBIN`, and the prior sparse-access citation.
No source sentence upgrades the restricted active global-source interface to
full clean-domain cleanup or full-space unitarity.

The accepted Lean declaration
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupInterface`
is therefore classified as `classical-lean-lemma` plus proof-state sync.  It
combines the already compiled route-level restricted dagger-column indicator
with the cleanup-scope decision.  It is not an external cited theorem, not an
unused-branch image rule, and not a semantic cleanup promotion.

Proof-translation map:

| Source step | Lean status | Classification | Remaining obligation |
|---|---|---|---|
| Lemma `Banded-sparse-access-oracle` maps $|0\rangle^{n-l}|s\rangle^l|i\rangle^n$ to $|r_{si}\rangle^n|i\rangle^n$ | `bandedSparseAccessPaperAddress`, `bandedSparseAccessPaperImage`, and `bandedSparseAccessPaperGlobalSlotSource` implement the active global-slot source route | contract transcript plus local finite-register lemmas | semantic forward correctness and full unitary extension remain false |
| Fig. `fig:1 term ROBIN` applies SWAP and then $(O_D^{BS})^\dagger$ to restore the padded sparse-index register | `oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupInterface` exposes the post-SWAP cleanup witness and active-source dagger indicator | `classical-lean-lemma` on active global-source rows | full clean-domain cleanup and full-space cleanup are not covered |
| The zero-inclusion paragraph keeps $s=0,\dots,\kappa-1$ in the sparse sum | `QBE.ODBS.GlobalSparseSlotAddress` remains the active cited-results row | source-contract guard | zero coefficients stay in the amplitude layer; no row-dependent deletion route is allowed |
| The theorem claims a final block encoding with normalizer $N_DN_f\kappa$ | route false guards keep LCU, circuit unitarity, block projection, and block correctness false | downstream theorem obligation | requires separate LCU/block-composition and oracle-correctness work |

Decision for the next lower packet:

| Candidate next work | Decision | Reason |
|---|---|---|
| another active global-source theorem-route wrapper | complete for this cycle | `oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupInterface` already packages the selected scope and false guards |
| full clean-domain `O_D^BS` cleanup | blocked | QBE still lacks an exact paper-backed image rule for clean encoded sparse values outside the active $s<\kappa$ source range |
| full-space `O_D^BS` unitarity | blocked | using the prior PDE sparse-access construction as a reversible-extension theorem would require a precise cited-results update and a matching Lean contract first |
| row-dependent unused-branch proof search | forbidden | the collision witness is rejected-model memory, not the active paper target |

Next lower work should either move to a different Phase 1 transcript block or
open a source-contract packet for the full clean-domain/full-space extension.
Such a packet may update the cited-results ledger and obligation records, but
it must not promote `daggerCleanup`, either active $O_D^{BS}$ unitarity flag,
LCU correctness, circuit unitarity, block projection, block correctness, or
final block extraction.

### 2026-05-24 Lower Prior-PDE Transcript Guard

Lower opened the source-contract packet with a typed guard rather than proof
search.  The new Lean declaration is
`GHL2025.bandedSparseAccessCleanupScopeDecision_priorPDESourceTranscriptGuard`.
It packages three facts for any one-term parameter record:

| Source-contract item | Lean field or declaration | Status |
|---|---|---|
| active cleanup scope | `bandedSparseAccessCleanupScopeDecision p` | `selectedScope = activeGlobalSource`, `fullSpaceSelected = false` |
| prior sparse-access source | `bandedSparseAccessPriorPDESourceContract` | equation transcript recorded; resource claim unproved |
| Robin-specific extension from the prior source | `robinUnusedBranchImageRule`, `closesUnusedZeroBranchExtension`, `lowerProofSearchAllowed` | `none`, `false`, and `false` |
| paper unitary-extension obligation | `(defaultBandedSparseAccessPaperContract p).unitaryExtension.proved` | remains `false` |

Proof-DAG update:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `odbs_prior_pde_transcript_guard` | prevent the prior PDE transcript from being treated as full-space cleanup or unitarity evidence | cleanup-scope decision, prior PDE source transcript, default paper contract | `bandedSparseAccessCleanupScopeDecision_priorPDESourceTranscriptGuard` | reviewer source-contract audit before full-space proof search | $O_D^{BS}$ | compiled guard; no image rule selected and no semantic flag promoted |

No active image, matrix, dagger, cleanup, unitarity, LCU, circuit-unitarity,
projection, block-correctness, or final block-extraction flag was promoted.

### 2026-05-24 Middle Prior-PDE Guard Closeout

Middle re-read the GHL2025 source anchors after the prior-PDE transcript guard:
Lemma `Diagonal sparsity`, Lemma `Banded-sparse-access-oracle`, Remark
`sparsity maximum`, the zero-inclusion paragraph before Theorem
`1 term robin`, Eq. `eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, and the
prior sparse-access citation to `guseynov2024efficientPDE`.  The public source
contract remains the paper anchors above plus arXiv:2506.20478 and
arXiv:2405.12855v3; no public artifact depends on the local TeX path.

The accepted guard
`bandedSparseAccessCleanupScopeDecision_priorPDESourceTranscriptGuard` is a
negative source-contract result.  It records the prior sparse-access equation
as transcript data while keeping `(defaultBandedSparseAccessPaperContract p)`.
`unitaryExtension.proved = false`, the prior resource claim false, and
`lowerProofSearchAllowed = false`.

Source-dependency closeout:

| Item | Classification | Lean interface | Next action |
|---|---|---|---|
| active global-source cleanup interface | `classical-lean-lemma` plus proof-state sync | `oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupInterface` | may be reused only over `bandedSparseAccessPaperGlobalSlotSource` |
| prior PDE sparse-access transcript | `external-cited-result` with status `obligation` | `bandedSparseAccessPriorPDESourceContract`, `bandedSparseAccessCleanupScopeDecision_priorPDESourceTranscriptGuard` | do not use as full-space unitarity or cleanup evidence without a new exact cited-results contract |
| full clean-domain cleanup | `source-contract-gap` | `bandedSparseAccessFullCleanDomainExtensionContract` keeps false fields | record an exact image rule for every clean non-active branch before proof search |
| full-space reversible extension | `external-cited-result` if imported from the prior PDE theorem, otherwise `source-contract-gap` | no accepted Lean theorem | add a cited-results row or a typed QBE extension contract before lower work depends on it |
| row-dependent unused-branch route | `contract-drift` memory | rejected-model helpers and collision regression | do not assign as active paper proof search |

Proof-DAG/reuse status:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `odbs_active_global_source_cleanup_interface` | package the selected active-source indicator and false guards | restricted indicator, cleanup-scope decision | `oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupInterface` | reviewer audit and later cleanup design | $(O_D^{BS})^\dagger$ | compiled; active-source only |
| `odbs_prior_pde_transcript_guard` | freeze the prior sparse-access source as transcript-only data | cleanup-scope decision, prior PDE source contract | `bandedSparseAccessCleanupScopeDecision_priorPDESourceTranscriptGuard` | source-contract audit before any full-space packet | $O_D^{BS}$ | compiled; no semantic flag promoted |
| full clean-domain cleanup | cover every clean padded branch, including non-active branches if in scope | exact image rule or reversible extension | no accepted theorem | possible semantic cleanup promotion | $O_D^{BS}$ and $(O_D^{BS})^\dagger$ | obligation |
| full-space unitary extension | prove the forward/dagger matrices are a full-space unitary pair | exact cited theorem or explicit reversible-extension proof | no accepted theorem | O_D^BS unitarity and block extraction | $O_D^{BS}$ | obligation |

Lower-agent packet boundary:

| Field | Requirement |
|---|---|
| allowed next O_D^BS work | source-contract or cited-results refinement for full clean-domain/full-space extension only |
| allowed alternate Phase 1 work | move to another fixed transcript block, such as O_DT^S normalizer or O_f source contracts |
| forbidden O_D^BS work | tactic search for cleanup, injectivity, or unitarity using row-dependent helpers, `bandedSparseAccessPaperValidCleanSource` as the active source, or `QBE.ODBS.UnusedZeroBranchExtension` |
| forbidden promotions | keep `daggerCleanup`, `unitaryExtension`, both active O_D^BS gate unitarity flags, LCU correctness, circuit unitarity, block projection, block correctness, and final block extraction false |

### 2026-05-24 Lower Full Clean-Domain Image-Rule Blocker

Lower added a narrow source-contract guard instead of proof search.  The new
Lean declarations are
`GHL2025.bandedSparseAccessCleanupScopeDecision_fullCleanDomainImageRuleBlocked`
and
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsFullCleanDomainImageRuleBlocked`.

The guard ties the selected cleanup scope to the full clean-domain wrapper.
The selected scope is still `activeGlobalSource`,
`fullCleanDomainSelected = false`, and `semanticCleanupPromotionAllowed =
false`.  The direct unused-branch image rule and the full clean-domain wrapper
both keep `proposedImageIndex = none`.  The wrapper fields for image
specification, full clean-domain injectivity, dagger cleanup, and unitary
extension all remain `proved = false`.

Proof-DAG update:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `odbs_full_clean_domain_image_rule_blocker` | keep the full clean-domain wrapper blocked while the active cleanup scope is global-source only | cleanup-scope decision, unused-branch image-rule contract, full clean-domain extension wrapper, route false flags | `bandedSparseAccessCleanupScopeDecision_fullCleanDomainImageRuleBlocked`, `oneTermRobinBlockEncodingProofRoute_odbsFullCleanDomainImageRuleBlocked` | reviewer source-contract audit before any full clean-domain packet | $O_D^{BS}$ | compiled guard; no image rule selected and no semantic flag promoted |

This packet did not edit the active address, image, matrix, dagger matrix, or
gate list.  It only records that full clean-domain cleanup remains a
source-contract gap until an exact image rule is supplied for every clean
branch in the chosen domain.

### 2026-05-24 Lower Shared $N_D$ Packaged Guard

Lean now also exposes
`GHL2025.derivativeNormalizerNDSharedRoute_sourceBoundAndFlags`.
This theorem combines the existing source-bound bridges
`sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_sourceBound`,
`boundaryRotationAngleNormalizerProofRoute_sourceBound`, and
`derivativeNormalizerNDSourceBound_sharedRoutes` with the false-flag guard
`derivativeNormalizerNDSharedRoute_flags_false`.

Paper-to-Lean scope:

| Paper item | Lean package | Status |
|---|---|---|
| Lemma 3 Eq. (20) uses $D_j^{(s)}/N_D$ for `O_DT^S` | `derivativeNormalizerNDSharedRoute_sourceBoundAndFlags` includes the `O_DT^S` source-bound bridge | definitional bridge only |
| Boundary $R_y$ uses the same $D_j^{(s)}/N_D$ source | the same theorem includes the `Ry_boundary` source-bound bridge | definitional bridge only |
| $N_D$ bound and analytic semantics | false-flag tail of the theorem | obligations remain false |
| Gate unitarity for `O_DT^S` and `Ry_boundary` | false-flag tail of the theorem | obligations remain false |

The theorem is not a new analytic proof and does not change any gate matrix,
normalizer, LCU, block-projection, or block-correctness flag.

### 2026-05-24 Middle Shared $N_D$ Proof-Translation Closeout

Middle re-audited the shared normalizer route after the accepted guard
`GHL2025.derivativeNormalizerNDSharedRoute_sourceBoundAndFlags`.  The public
source anchors are GHL2025 Lemma 3 Eq. `amplitude_oracle_D`, Eq.
`angles for Ry`, and Fig. `fig:1 term ROBIN`, arXiv:2506.20478.

Definition.  For each fixed row $j$ and sparse slot $s$, the Lean coefficient
source remains `robinSparseAmplitudeValue p.n sparse row`.  The shared
normalizer symbol is `Coeff.symbol "N_D"`.  The formal quotient
$D_j^{(s)}/N_D$ is represented only as the symbolic stand-in inside
`DerivativeNormalizerNDContract`; it is not a proof that division by $N_D$ is
defined or bounded.

Proof-translation map:

| Source step | Classification | Current Lean declaration | Remaining obligation |
|---|---|---|---|
| Lemma 3 Eq. `amplitude_oracle_D` gives the $|0\rangle$ amplitude $D^{(s)}/N_D$ | `internal-paper-step` plus typed contract | `sparseAmplitudeOracleDTCoefficientNormalizerProofRoute`, `derivativeNormalizerNDSharedRoute_sourceBoundAndFlags` | nonzero $N_D$ and division semantics |
| Lemma 3 Eq. `amplitude_oracle_D` gives $\sqrt{1-|D^{(s)}|^2/N_D^2}$ | `classical-lean-lemma` for analytic semantics | `DerivativeNormalizerNDContract.absSquareSemantics`, `DerivativeNormalizerNDContract.sqrtComplementSemantics` | absolute-value, square, square-root, and complement identities |
| Eq. `angles for Ry` gives $\theta_j^s=\arccos(D_j^{(s)}/N_D)$ | `internal-paper-step` plus analytic contract | `boundaryRotationAngleNormalizerProofRoute`, `DerivativeNormalizerNDContract.arccosSemantics` | real arccos domain and semantics |
| Eq. `angles for Ry` induces cosine and sine half-angle entries | `classical-lean-lemma` | `BoundaryRotationAngleNormalizerProofRoute.halfAngleSemantics` | half-angle formulas and square-root signs |
| The source states $N_D \geq \|D\|_{\max}$ | `source-contract` plus later classical bound lemma | `DerivativeNormalizerNDSourceBound.coefficientBound` | prove the bound against the concrete coefficient data |
| The two affected gates are unitary | downstream semantic obligation | `derivativeNormalizerNDSharedRoute_sourceBoundAndFlags` keeps both gate flags false | prove the two-by-two unitary blocks before any gate-unitarity promotion |

Proof-DAG update:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `shared_nd_packaged_guard` | package the shared coefficient source, $N_D$ symbol, source-bound obligation, and false analytic flags for both derivative routes | `shared_nd_coefficient_source`, `shared_nd_bound`, `odts_coeff_normalizer`, `ryb_angle_normalizer` | `derivativeNormalizerNDSharedRoute_sourceBoundAndFlags` | reviewer audit; next fixed transcript block | $O_{D^T}^S$, $R_y^{boundary}$ | compiled guard; no analytic, unitary, LCU, projection, or block-correctness flag promoted |

Lower-agent packet boundary:

| Field | Instruction |
|---|---|
| fixed target | the shared $N_D$ guard is closed for this cycle |
| allowed next work | proceed only to the next fixed Phase 1 transcript block selected by upper |
| blocked work | do not prove or promote nonzero $N_D$, division, coefficient bounds, absolute-square, square-root, arccos, half-angle, two-by-two unitarity, `O_DT^S` unitarity, `Ry_boundary` unitarity, LCU correctness, block projection, or block correctness from this guard |
| O_D^BS discipline | keep cleanup, injectivity, unitarity, and final block extraction blocked until the full clean-domain or full-space contract is sharpened |

### 2026-05-24 Lower $O_f$ External-Source Guard

Definition.  For each one-term parameter record `p` and compound column `j`,
`GHL2025.functionOracleAmplitudeProofRoute_externalSourceAndFlags` packages the
existing bridge
`functionOracleAmplitudeProofRoute_externalSourceContract` together with
`functionOracleExternalAmplitudeSourceContract_flags_false` and
`functionOracleAmplitudeProofRoute_flags_false`.

The public source anchors are GHL2025 Theorem `Amplitude-oracle for
piece-wise polynomial function`, Eq. `coordinate oracle`, and the cited
Guseynov--Liu 2024 Theorem 5, recorded in the cited-results row
`GL2024.Thm5.AmplitudeOracle`.

Proof-map update:

| Source item | Lean package | Status |
|---|---|---|
| Coordinate-oracle clean branch $f(x_i)/N_f$ | `functionOracleAmplitudeProofRoute_externalSourceAndFlags` reuses `functionOracleAmplitudeProofRoute_externalSourceContract` | transcript bridge only |
| Cited GL2024 amplitude-oracle theorem | `functionOracleExternalAmplitudeSourceContract_flags_false` remains part of the package | external theorem formalization false |
| O_f route obligations | `functionOracleAmplitudeProofRoute_flags_false` remains part of the package | nonzero $N_f$, division, $N_f$ bound, orthogonal completion, unitary completion, and theorem amplitude correctness all false |

This guard does not edit `functionOraclePaperMatrix` or `oneTermRobinGate_O_f`.
It does not promote amplitude correctness, the $N_f$ bound, orthogonality,
unitarity, LCU correctness, block projection, block correctness, or final block
extraction.

### 2026-05-24 Middle $O_f$ External-Source Closeout

Middle re-read the GHL2025 source anchors for Theorem `Amplitude-oracle for
piece-wise polynomial function`, Eq. `coordinate oracle`, Fig. `fig:1 term
ROBIN`, and the cited Guseynov--Liu 2024 amplitude-oracle result.  The local
TeX source states the clean branch
$f(x_i)/N_f$ and the orthogonal workspace component, but QBE has only accepted
this as a typed source transcript.

Definition.  For a one-term parameter record `p` and compound column `j`,
`functionOracleAmplitudeProofRoute_externalSourceAndFlags p j` is the current
Lean-facing contract for the $O_f$ external source.  It packages the bridge from
`FunctionOracleAmplitudeProofRoute` to
`functionOracleExternalAmplitudeSourceContract` and records that the cited
source theorem, $N_f$ nonzero condition, division semantics, $N_f$ bound,
orthogonal completion, unitary completion, and theorem-level amplitude
correctness all remain false obligations.

Proof-translation map:

| Source step | Classification | Current Lean declaration | Remaining obligation |
|---|---|---|---|
| The coordinate-oracle theorem maps the clean workspace branch to amplitude $f(x_i)/N_f$ | `external-cited-result` plus GHL transcript | `FunctionOracleExternalAmplitudeSourceContract`, `functionOracleAmplitudeProofRoute_externalSourceAndFlags` | formalize or contract the cited arXiv:2411.01131 theorem before promoting amplitude correctness |
| Eq. `coordinate oracle` names the $N_f$ normalizer | source contract plus later analytic lemma | `functionOracleExternalAmplitudeSourceContract.normalizerNf`, `functionOracleAmplitudeProofRoute_normalizerNf` | prove nonzero $N_f$, inverse semantics, and the concrete normalizer bound |
| Eq. `coordinate oracle` includes an orthogonal component to the clean workspace | `external-cited-result` plus future local matrix lemma | `FunctionOraclePaperImage.orthogonalComponentCorrect`, `functionOracleOrthogonalEntry` | prove orthogonality and unitary completion for the active matrix skeleton |
| Fig. `fig:1 term ROBIN` inserts $O_f$ after the derivative-address and amplitude layers | downstream theorem obligation | `oneTermRobinGate_O_f`, `oneTermRobinBlockEncodingProofRoute` | keep LCU correctness, block projection, block correctness, and final extraction false |

Proof-DAG update:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `of_external_source_and_flags` | package the cited theorem transcript and all false analytic flags for one $O_f$ route column | `of_external_amplitude_source`, `of_nf_amplitude_route` | `functionOracleAmplitudeProofRoute_externalSourceAndFlags` | theorem-route source audit and next fixed false-flag bridge | $O_f$ | compiled guard; no analytic, unitary, LCU, projection, or block-correctness flag promoted |
| `of_route_false_flag_bridge` | expose the $O_f$ external-source guard through `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute` while keeping theorem flags false | `of_external_source_and_flags`, route-level O_f source fields | planned declaration in `QuantumBlockEncoding/RobinMatrix.lean` | reviewer audit before any O_f analytic work | $O_f$ | lower packet |

Lower-agent packet boundary:

| Field | Instruction |
|---|---|
| fixed target | add a theorem-route bridge for the existing `functionOracleAmplitudeProofRoute_externalSourceAndFlags` guard |
| allowed files | `QuantumBlockEncoding/RobinMatrix.lean`, focused tests in `Tests/Basic.lean`, and a short sync entry in this window or `proof-obligations/QBE-AUTO-002.md` |
| required behavior | show that the route still points to `functionOracleExternalAmplitudeSourceContract` and that `FunctionOracleContract.amplitudeCorrect`, source formalization, $N_f$ obligations, orthogonal completion, unitary completion, LCU correctness, block projection, block correctness, and final extraction stay false |
| forbidden work | do not edit `functionOraclePaperMatrix`, do not promote `oneTermRobinGate_O_f.unitary`, do not close the $N_f$ bound or amplitude theorem from the transcript, and do not reopen $O_D^{BS}$ cleanup or unitarity proof search |

### 2026-05-24 Lower $O_f$ Theorem-Route Bridge

Lower added the route-level bridge
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_ofExternalSourceAndFlags`.
For each `n` and compound column `j`, it exposes the existing
`GHL2025.functionOracleAmplitudeProofRoute_externalSourceAndFlags
(oneTermParameters n) j` guard through `oneTermRobinBlockEncodingProofRoute`.

Definitions used by the bridge:

| Item | Lean declaration | Status |
|---|---|---|
| route source record | `oneTermRobinBlockEncodingProofRoute n`.functionOracleSource | definitional identity with `GHL2025.functionOracleExternalAmplitudeSourceContract` |
| per-column $O_f$ source route | `GHL2025.functionOracleAmplitudeProofRoute (oneTermParameters n) j` | transcript bridge only |
| active $O_f$ gate slot | index `4` of `oneTermRobinBlockEncodingProofRoute n`.circuitSemantics.gateMatrices | gate label and matrix pinned to `Gate.oracleCall "O_f"` and `GHL2025.functionOraclePaperMatrix` |

Proof-DAG update:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `of_route_false_flag_bridge` | expose the cited $O_f$ source transcript and every theorem-route false flag at the one-term route level | `functionOracleAmplitudeProofRoute_externalSourceAndFlags`, route false flags, active gate slot | `oneTermRobinBlockEncodingProofRoute_ofExternalSourceAndFlags` | reviewer audit before any $O_f$ analytic proof packet | $O_f$ | compiled guard; no amplitude, normalizer, orthogonality, unitary, LCU, projection, or block-correctness flag promoted |

The bridge keeps the external theorem formalization, nonzero $N_f$, division
semantics, normalizer bound, orthogonal completion, unitary completion,
`FunctionOracleContract.amplitudeCorrect`, `oneTermRobinGate_O_f.unitary`,
LCU correctness, block projection, block correctness, and final block
extraction all false.  It does not edit `functionOraclePaperMatrix` and does
not reopen any $O_D^{BS}$ cleanup or unitarity route.

### 2026-05-24 Middle One-Term Theorem Proof-Translation Map

Definitions for this map:

| Object | Paper anchor | Lean declaration | Status |
|---|---|---|---|
| theorem transcript | Theorem `1 term robin`, arXiv:2506.20478 | `GHL2025.defaultOneTermRobinTheoremData` | typed theorem data; theorem-level obligations false |
| circuit transcript | Fig. `fig:1 term ROBIN` | `GHL2025.oneTermRobinCircuit`, `GHL2025.oneTermRobinGateMatrixPlaceholders`, `Examples.RobinHeat.oneTermRobinCircuitSemantics` | seven-gate order and active matrices pinned |
| wavefunction transcript | Eq. `eq: ROBIN clarified` | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute` | route object ties gate contracts to block target; no amplitude algebra proved |
| block target | Theorem `1 term robin` normalizer and target matrix | `Examples.RobinHeat.oneTermRobinBlockExtractionTarget`, `Examples.RobinHeat.defaultOneTermRobinCircuitBlockClaim` | target matrix and signal-index-zero projection recorded; `blockProjection` and `blockCorrect` false |
| normalizer | Theorem `1 term robin` uses $\mathcal{N}_D\mathcal{N}_f\kappa$ | `GHL2025.oneTermRobinNormalizer`, `GHL2025.oneTermRobinNormalizer_eval`, `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_normalizer` | symbolic and route-linked; analytic bounds false |

Proof-translation map from the paper transcript:

| Source step | Classification | Lean-facing contract | Remaining obligation |
|---|---|---|---|
| The paragraph before the theorem includes zero sparse slots and fixes $s=0,\dots,\kappa-1$. | `internal-paper-step` plus O_D^BS source-contract audit | `GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract`, `GHL2025.bandedSparseAccessPaperGlobalSlotSource` | amplitude layer must supply zero coefficients for zero slots; no deletion of sparse slots |
| Fig. `fig:1 term ROBIN` applies `U_indic`. | `classical-lean-lemma` already discharged for this route | `GHL2025.oneTermRobinGate_U_indic` | none for the current gate flag; theorem-level circuit unitarity still false |
| Fig. `fig:1 term ROBIN` applies $O_{D^T}^S$ and boundary $R_y$ to form the $\gamma_2$ coefficient source. | `internal-paper-step` plus analytic obligations | `GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute`, `GHL2025.boundaryRotationAngleNormalizerProofRoute`, `GHL2025.derivativeNormalizerNDSharedRoute_sourceBoundAndFlags` | nonzero $N_D$, division semantics, coefficient bound, square-root complement, arccos and half-angle semantics, and two-by-two unitarity |
| Fig. `fig:1 term ROBIN` applies $O_D^{BS}$, SWAP, and $(O_D^{BS})^\dagger$ to move from sparse slots to addressed system columns and back to clean padded sparse-index ancillas. | `internal-paper-step` for the register formula; `external-cited-result` for the prior sparse-access construction; `classical-lean-lemma` for the accepted active-source finite-index blocks | `GHL2025.defaultBandedSparseAccessPaperContract`, `GHL2025.bandedSparseAccessPriorPDESourceContract`, `GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnIndicator`, `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupInterface` | full clean-domain cleanup, full-space unitary extension, and semantic `daggerCleanup` remain false |
| Fig. `fig:1 term ROBIN` applies $O_f$ so the clean branch carries $f(x_i)/N_f$. | `external-cited-result` plus GHL transcript | `GHL2025.FunctionOracleExternalAmplitudeSourceContract`, `GHL2025.functionOracleAmplitudeProofRoute_externalSourceAndFlags`, `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_ofExternalSourceAndFlags` | formalize or contract the cited arXiv:2411.01131 theorem; prove nonzero $N_f$, division, $N_f$ bound, orthogonal completion, and unitary completion |
| Eq. `eq: ROBIN clarified` displays the $\gamma_3$ clean branch with factor $1/(\mathcal{N}_D\mathcal{N}_f\kappa)$. | transcript-to-block target map | `GHL2025.oneTermRobinNormalizer`, `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit` | prove the actual signal-zero block matrix equals the Robin derivative matrix divided by the normalizer |
| The theorem concludes a block-encoding and resource claim. | `external-cited-result` plus downstream local proof obligations | cited row `LCU.StandardBlockEncoding`, `CircuitBlockEncodingClaim`, `BlockExtractionTarget` | exact finite-dimensional LCU/block-composition theorem, circuit unitarity, block extraction, resource bound, and pure-ancilla cleanup |

Source-dependency audit:

| Dependency site | Classification | Cited-results row | Current action |
|---|---|---|---|
| sparse access $O_D^{BS}$ | `external-cited-result` plus active global-slot source contract | `GHL2024.PDE.Def6Lemma1.ODBS`, `QBE.ODBS.GlobalSparseSlotAddress`, `GHL2025.RobinZeroInclusion.ODBS` | continue only with source-contract refinement or false-flag guards until a full cleanup/unitary theorem is accepted |
| function oracle $O_f$ | `external-cited-result` | `GL2024.Thm5.AmplitudeOracle` | no analytic promotion from transcript-only guards |
| LCU/block-composition closure | `external-cited-result` and future QBE theorem | `LCU.StandardBlockEncoding` | do not close `lcuCorrect`, `blockProjection`, or `blockCorrect` without an exact finite-dimensional Lean statement |
| normalizer algebra $N_DN_f\kappa$ | `internal-paper-step` plus `classical-lean-lemma` obligations | `GHL2025.Theorem1.BlockEncoding` | route-level equality compiled; bounds and division semantics remain false |

Proof-DAG update:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `one_term_theorem_transcript_route` | expose Theorem `1 term robin`, Fig. `1 term ROBIN`, Eq. `ROBIN clarified`, the normalizer $N_DN_f\kappa$, and every cited dependency at the theorem-route level | active gate-list guards, O_D^BS source route, O_f route bridge, block-projection normalizer audit, cited-results rows | planned lower theorem over `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute` | reviewer audit before any final theorem proof packet | full route | planned guard only; all semantic, unitary, LCU, projection, and block-correctness flags must stay false |
| `one_term_lcu_block_closure` | prove the exact finite-dimensional block extraction and LCU composition theorem | full gate unitarity, O_D^BS cleanup/unitary, O_f amplitude/unitary, $N_D$ and $N_f$ bounds | no active Lean declaration | final one-term theorem | full route | obligation |

Lower-agent packet:

| Field | Instruction |
|---|---|
| fixed target | add a guard-only theorem named `oneTermRobinBlockEncodingProofRoute_theoremTranscriptDependencies` unless an equivalent name already exists |
| allowed files | `QuantumBlockEncoding/RobinMatrix.lean`, focused examples in `Tests/Basic.lean`, and a short sync entry in this window or `proof-obligations/QBE-AUTO-002.md` |
| statement shape | for all `n`, expose the route source anchor, theorem normalizer equality, gate-list/order guard, block target normalizer and signal-index-zero fields, the O_D^BS source records, the O_f source record, and false guards for O_D^BS cleanup/unitary, O_f amplitude correctness, LCU correctness, circuit unitarity, block projection, block correctness, and block extraction |
| required dependencies | reuse `oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze`, `oneTermRobinBlockEncodingProofRoute_flags_false`, `oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupInterface` only as a source-domain guard, and `oneTermRobinBlockEncodingProofRoute_ofExternalSourceAndFlags` only as an O_f transcript guard |
| forbidden work | do not edit active matrices, do not change `oneTermRobinNormalizer`, do not promote `daggerCleanup`, `unitaryExtension`, any active gate unitary flag except already-proved `U_indic` and SWAP, `FunctionOracleContract.amplitudeCorrect`, `lcuCorrect`, `blockProjection`, `blockCorrect`, circuit unitarity, resource bounds, or final block extraction |
