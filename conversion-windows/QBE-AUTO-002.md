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
| O_DT^S paper rotation matrix | `GHL2025.sparseAmplitudeOracleDTRotationMatrix` | identity when the indicator bit is 0; controlled rotation on ancilla bit 0 when the indicator bit is 1 | active skeleton |
| Ry_boundary honest matrix | `GHL2025.oneTermRobinGate_Ry_boundary` | GateMatrix with controlled R_y rotation, proved := false | defined (cycle 8 update) |
| Ry_boundary paper register extraction | `GHL2025.BoundaryRotationPaperRegisters`, `GHL2025.boundaryRotationPaperRegisters` | extract ancilla bit, indicator bit, row register, sparse-index register, and non-ancilla bits for the boundary rotation | defined skeleton |
| Ry_boundary symbolic rotation entries | `GHL2025.boundaryRotationCosHalf`, `GHL2025.boundaryRotationSinHalf` | symbols for $\cos(\theta_j^s/2)$ and $\sin(\theta_j^s/2)$ | defined; angle relation unproved |
| Ry_boundary angle-normalizer contract | `GHL2025.BoundaryRotationAngleNormalizerContract`, `GHL2025.boundaryRotationAngleNormalizerContract`, `GHL2025.boundaryRotationAngleNormalizerObligation` | records $\theta_j^s=\arccos(D_j^{(s)}/N_D)$ and half-angle formulas as false proof obligations | typed contract recorded; proof flags false |
| O_D^BS active paper-image matrix | `GHL2025.oneTermRobinGate_O_D_BS` | GateMatrix using the Lemma 1 paper-image skeleton, proved := false | active skeleton (run 03 cycle 2 lower) |
| O_D^BS column map | `GHL2025.robinSparseColumnMap` | $\mathrm{col}(s,i)$ helper for Robin stencil entries, reused to compute the one-term value of $r_{si}$ | defined (cycle 4; helper only) |
| O_D^BS legacy helper matrix | `GHL2025.bandedSparseAccessMatrix` | old map $|s\rangle|i\rangle \to |s\rangle|\mathrm{col}(s,i)\rangle$; not the active paper oracle | defined (cycle 4; helper only) |
| O_f active gate matrix | `GHL2025.oneTermRobinGate_O_f` | GateMatrix wired to `functionOraclePaperMatrix`, proved := false | active paper-image skeleton; clean input branch wired |
| SWAP honest matrix | `GHL2025.oneTermRobinGate_SWAP` | GateMatrix with permutation matrix, `proved := false` | pending proof-DAG bit-slice lemmas |
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
| O_f active gate matrix | `GHL2025.oneTermRobinGate_O_f` | GateMatrix with paper-image matrix, proved := false | defined; no proof flags promoted |
| Ry_boundary honest matrix | `GHL2025.boundaryRotationMatrix` | controlled R_y on ancilla for boundary rows (indicator=0) | defined (cycle 8) |
| Ry_boundary gate matrix | `GHL2025.oneTermRobinGate_Ry_boundary` | GateMatrix with honest rotation matrix, proved := false | defined (cycle 8 update) |
| Ry_boundary source contract | `GHL2025.BoundaryRotationAngleNormalizerContract` | per-row/sparse-index contract for coefficient, $N_D$, symbolic entries, and false proof flags | defined |
| O_D^BS paper register contract | `GHL2025.BandedSparseAccessPaperContract` | source-contract record for Lemma 1 input/output registers and cleanup obligations | defined (run 03 cycle 1 middle) |
| O_D^BS default paper contract | `GHL2025.defaultBandedSparseAccessPaperContract` | for one-term Robin parameters: $|0\rangle^{n-l}|s\rangle^l|i\rangle^n \mapsto |r_{si}\rangle^n|i\rangle^n$ | defined; all correctness fields unproved |
| O_D^BS paper register extraction | `GHL2025.BandedSparseAccessPaperRegisters`, `GHL2025.bandedSparseAccessPaperRegisters` | extracts the full O_D register, padded-zero field, sparse index, and row value from the compound basis index | defined skeleton (run 03 cycle 1 middle) |
| O_D^BS clean input predicate | `GHL2025.bandedSparseAccessPaperCleanInput` | checks whether the padded-zero field is actually $0^{n-l}$ for the Lemma 1 source equation | defined; domain obligation unproved |
| O_D^BS per-column audit | `GHL2025.BandedSparseAccessPaperColumnContract`, `GHL2025.bandedSparseAccessPaperColumnContract` | records clean-domain flag, image index, row preservation, address write, address-range check, no-spill check, and false obligations for one basis column | defined skeleton |
| O_D^BS paper address | `GHL2025.bandedSparseAccessPaperAddress` | one-term Robin instance of $r_{si}$ from the extracted sparse index and row value | defined skeleton; correctness unproved |
| O_D^BS address-range check | `GHL2025.bandedSparseAccessPaperAddressInRange` | executable check that $r_{si}$ fits in the n-bit paper address register | defined; proof flag false |
| O_D^BS row range block | `GHL2025.bandedSparseAccessPaperRegisters_row_lt_gridSize` | extracted row register is an n-bit row value | proved |
| O_D^BS stencil range block | `GHL2025.robinSparseColumnMap_lt_gridSize_of_row_lt` | if $2 \le n$ and the row is n-bit, then the fourth-order column map is n-bit | proved under explicit side condition |
| O_D^BS address-range block | `GHL2025.bandedSparseAccessPaperAddress_lt_gridSize_of_two_le`, `GHL2025.bandedSparseAccessPaperAddressInRange_eq_true_of_two_le` | proves the executable address check for $2 \le n$ | proved under explicit side condition; semantic flag still false |
| O_D^BS paper image | `GHL2025.bandedSparseAccessPaperImage` | preserves the row register and replaces the O_D register with $r_{si}$ | active image skeleton; correctness unproved |
| O_D^BS image roundtrip block | `GHL2025.bandedSparseAccessPaperImage_lt_qubitDim_of_address_lt`, `GHL2025.bandedSparseAccessPaperImage_rowValue_eq`, `GHL2025.bandedSparseAccessPaperImage_odRegisterValue_eq` | proves finite-basis range plus row and written-address extraction for the executable image under the stated range hypotheses | proved as executable register block; semantic flags remain false |
| O_D^BS finite image index | `GHL2025.bandedSparseAccessPaperImageFin`, `GHL2025.bandedSparseAccessPaperImageFin_val` | turns the executable image into a `Fin` index only when the source column is in range and the written address is n-bit | proved bridge; semantic flags remain false |
| O_D^BS image entry bridge | `GHL2025.bandedSparseAccessPaperMatrix_imageFin_eq_one`, `GHL2025.bandedSparseAccessPaperDaggerMatrix_imageFin_eq_one`, `GHL2025.oneTermRobinGate_O_D_BS_imageFin_eq_one`, `GHL2025.oneTermRobinGate_O_D_BS_dagger_imageFin_eq_one` | proves the forward entry $M[\mathrm{image}(j),j]=1$ and transpose entry $M^\dagger[j,\mathrm{image}(j)]=1$ at the finite image index | proved entry bridge; injectivity, inverse, cleanup, and unitarity still unproved |
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
def signalSystemBlockProjection
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
def GHL2025.bandedSparseAccessPaperMatrix
def GHL2025.bandedSparseAccessPaperDaggerMatrix
theorem GHL2025.bandedSparseAccessPaperMatrix_imageFin_eq_one
theorem GHL2025.bandedSparseAccessPaperDaggerMatrix_imageFin_eq_one
theorem GHL2025.oneTermRobinGate_O_D_BS_imageFin_eq_one
theorem GHL2025.oneTermRobinGate_O_D_BS_dagger_imageFin_eq_one
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
- [ ] Prove or explicitly track unitarity of remaining 6 gate matrices (O_DT^S, Ry_boundary, O_D^BS, O_f, SWAP, O_D^BS_dagger).
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

This is a unitary permutation matrix (self-inverse), but the `unitary.proved` obligation remains `false` until a formal unitarity proof is supplied.

---

## Cycle 2 Lean Declaration Targets

| Declaration | File | Role | Status |
|---|---|---|---|
| `robinIndicatorBitPosition` | GHL2025.lean | indicator bit position = $1 + 2n$ | implemented |
| `indicatorOracleMatrix` | GHL2025.lean | honest U_indic permutation matrix | implemented |
| updated `oneTermRobinTotalQubits` | GHL2025.lean | uses register partition total | fixed |
| `effectiveRobinSignalQubits` | GHL2025.lean | signal dim including visible ancillas | implemented |
| updated `oneTermRobinGate_U_indic` | GHL2025.lean | uses honest matrix, proved := false | fixed |
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

In Lean this is recorded as `GHL2025.swapOracleMatrix`.  The `unitary.proved` obligation remains `false`.

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
| updated `oneTermRobinGate_SWAP` | GHL2025.lean | uses honest matrix, proved := false | updated |

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
| SWAP unitary.proved = false | n=3, κ=7 | rfl | proved |
| Placeholder match with honest SWAP | general p | theorem | proved |

---

## O_D^BS Banded Sparse Access Matrix (Cycle 4)

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
| $O_D^{BS}$ | Guseynov-Huang-Liu 2025, Lemma 1, arXiv:2506.20478 | padded sparse-index register $|0\rangle^{n-l}|s\rangle^l$ and row register $|i\rangle^n$ | address register $|r_{si}\rangle^n$ and preserved row register $|i\rangle^n$ | clean padded-zero domain, width compatibility, address range, no spill into higher signal bits, injectivity, full-unitary extension, and forward correctness recorded as obligations | `GHL2025.oneTermRobinGate_O_D_BS`, `GHL2025.bandedSparseAccessPaperMatrix`, `GHL2025.defaultBandedSparseAccessPaperContract`, `GHL2025.bandedSparseAccessPaperColumnContract` | active matrix skeleton; finite-image entry bridge proved under explicit hypotheses; obligations unproved |
| $(O_D^{BS})^\dagger$ | Fig. 1-term Robin and Lemma 1, arXiv:2506.20478 | post-SWAP address/row registers from the same paper layout | padded sparse-index register cleaned back to $|0\rangle^{n-l}|s\rangle^l$ where applicable | `daggerCleanup.proved = false`; inverse-on-range and unitarity unproved | `GHL2025.oneTermRobinGate_O_D_BS_dagger`, `GHL2025.bandedSparseAccessPaperDaggerMatrix` | active transpose-style skeleton; cleanup obligation only |
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
| `odbs_address_range` | check and then prove that the written $r_{si}$ value fits in the n-bit output address register | Lemma 1, arXiv:2506.20478 | `bandedSparseAccessPaperAddressInRange`, `.addressRange` | `odbs_extract_registers`, `bandedSparseAccessPaperAddress` | no-spill, forward image, unitarity route | executable check defined; proof flag false |
| `odbs_address_range_n_ge_2` | prove the executable address-range check once the paper parameter family supplies $2 \le n$ | Lemma 1, arXiv:2506.20478 | `bandedSparseAccessPaperAddressInRange_eq_true_of_two_le`, `bandedSparseAccessPaperAddress_lt_gridSize_of_two_le` | row extraction, `robinSparseColumnMap_lt_gridSize_of_row_lt` | no-spill, forward image, unitarity route | proved under explicit side condition; proof flag false |
| `odbs_no_spill` | check and then prove that the image only changes bits $[1+n,1+2n)$ and preserves indicator and $m_f$ bits above that register | Lemma 1 and Fig. 1-term Robin, arXiv:2506.20478 | `bandedSparseAccessPaperHighTail`, `bandedSparseAccessPaperImageNoSpill`, `bandedSparseAccessPaperImageNoSpill_iff`, `bandedSparseAccessPaperImage_highTail_eq_of_address_lt`, `bandedSparseAccessPaperImageNoSpill_eq_true_of_address_lt`, `bandedSparseAccessPaperImageNoSpill_eq_true_of_two_le`, `.noSpill` | `odbs_address_range`, `odbs_forward_image` | forward matrix, dagger cleanup, block extraction | executable no-spill proved from address range and $2 \le n$; semantic proof flag false |
| `odbs_forward_image` | map $|0\rangle^{n-l}|s\rangle^l|i\rangle^n$ to $|r_{si}\rangle^n|i\rangle^n$ and preserve the row register | Lemma 1, arXiv:2506.20478 | `bandedSparseAccessPaperAddress`, `bandedSparseAccessPaperImage`, and `.forwardCorrect` | `odbs_width_compatible`, `odbs_extract_registers` | paper matrix entries, dagger cleanup | defined skeleton; `.forwardCorrect.proved = false` |
| `odbs_forward_matrix` | build the permutation-style matrix from the paper image, not from `robinSparseColumnMap` on the system register | Lemma 1, arXiv:2506.20478 | `bandedSparseAccessPaperMatrix` | `odbs_forward_image` | `oneTermRobinGate_O_D_BS` | active skeleton; finite-image entry bridge proved under explicit hypotheses; injectivity unproved |
| `odbs_dagger_matrix` | build the transpose-style matrix paired with the paper image skeleton | Fig. 1-term Robin and Lemma 1, arXiv:2506.20478 | `bandedSparseAccessPaperDaggerMatrix` | `odbs_forward_image` | `oneTermRobinGate_O_D_BS_dagger` | active skeleton; inverse-on-range unproved |
| `odbs_image_fin_entry_bridge` | under source-column range and n-bit address hypotheses, build the finite image index and prove the forward and dagger entries at that index are $1$ | Lemma 1 and Fig. 1-term Robin, arXiv:2506.20478 | `bandedSparseAccessPaperImageFin`, `bandedSparseAccessPaperMatrix_imageFin_eq_one`, `bandedSparseAccessPaperDaggerMatrix_imageFin_eq_one`, `oneTermRobinGate_O_D_BS_imageFin_eq_one`, `oneTermRobinGate_O_D_BS_dagger_imageFin_eq_one` | `odbs_image_range_of_address_range`, active paper matrices | injectivity route, inverse-on-range route | proved as entry bridge; semantic flags false |
| `odbs_dagger_cleanup` | after SWAP, $(O_D^{BS})^\dagger$ restores the padded sparse-index register when the forward-image hypotheses hold | Fig. 1-term Robin and Lemma 1, arXiv:2506.20478 | `defaultBandedSparseAccessPaperContract p`.daggerCleanup | `odbs_forward_image`, SWAP register block lemmas | block extraction | unproved |
| `block_projection_normalizer` | extract the signal-index-zero system block of the composed circuit product and compare it with $A_k/(N_DN_f\kappa)$ | Theorem 1-term Robin and Fig. 1-term Robin, arXiv:2506.20478 | `Examples.RobinHeat.oneTermRobinBlockExtractionTarget`, `signalSystemBlockProjection`, `GHL2025.oneTermRobinNormalizer` | active gate matrices, dimension split, O_D^BS cleanup obligations | final block-correctness theorem | structural tests compiled; correctness unproved |

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

| Item | Contract |
|---|---|
| Paper anchor | Guseynov-Huang-Liu 2025, Theorem 1-term Robin and Fig. 1-term Robin, arXiv:2506.20478 |
| Full-space matrix | `Examples.RobinHeat.oneTermRobinCircuitSemantics n`.matrix is `evalGateMatrices (GHL2025.oneTermRobinGateMatrixPlaceholders (Examples.RobinHeat.oneTermParameters n))` |
| Dimension split | `Examples.RobinHeat.oneTermRobinCircuitDimCompat n` proves $2^q = 2^m \cdot 2^n$ using the current signal/system convention |
| Signal register | `qubitDim (GHL2025.effectiveRobinSignalQubits (Examples.RobinHeat.oneTermParameters n))` |
| System register | `gridSize n`, with target matrix `Examples.RobinHeat.robinDerivativeMatrix n` |
| Projection convention | `signalSystemBlockProjection` extracts the `(0,0)` signal block of the cast circuit matrix |
| Normalizer | `GHL2025.oneTermRobinNormalizer`, whose evaluation lemma is `GHL2025.oneTermRobinNormalizer_eval` |
| Clean ancilla status | O_D^BS dagger cleanup remains `(defaultBandedSparseAccessPaperContract p).daggerCleanup.proved = false` |
| Block obligations | `(oneTermRobinBlockExtractionTarget n).blockProjection.proved = false` and `(oneTermRobinBlockExtractionTarget n).blockCorrect.proved = false` |

The packet also pins `(defaultOneTermRobinCircuitBlockClaim n).target` to
`oneTermRobinBlockExtractionTarget n`, so downstream proof work cannot silently
replace the projection convention or normalizer.  It checks that
`(defaultBandedSparseAccessPaperContract (oneTermParameters n)).daggerCleanup`
remains false.  No new theorem claims were added to
`QuantumBlockEncoding/RobinMatrix.lean` or `QuantumBlockEncoding/CircuitSemantics.lean`.

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
| system grid register $i$ | Guseynov-Huang-Liu 2025, Lemma 4 and Fig. 1-term Robin, arXiv:2506.20478 | bits $[1,1+n)$ via `functionOraclePaperRegisters`; also used by `functionOracleMatrix` | defined skeleton; concrete tests pass |
| clean function workspace $|0\rangle^{m_f}$ | coordinate-oracle equation and theorem resource line, arXiv:2506.20478 | `FunctionOraclePaperRegisters.mfWorkspaceValue`, `cleanWorkspace` | defined skeleton; cleanup/action proof unproved |
| function value data | Lemma 4, arXiv:2506.20478 | `GHL2025.robinFunctionValue p.n i` | symbolic data source defined |
| normalized clean-branch amplitude $f(x_i)/N_f$ | Lemma 4, coordinate-oracle equation, arXiv:2506.20478 | `functionOracleNormalizedValue`, `FunctionOraclePaperImage.cleanBranchAmplitude` | symbolic contract defined; division and bound unproved |
| paper-image matrix | Lemma 4, coordinate-oracle equation, arXiv:2506.20478 | `functionOraclePaperMatrix`, `oneTermRobinGate_O_f` | active skeleton wired; clean-input branch matrix entry pinned |
| orthogonal component | Lemma 4, coordinate-oracle equation, arXiv:2506.20478 | `FunctionOraclePaperImage.orthogonalComponent`, `functionOracleOrthogonalEntry`, `orthogonalComponentCorrect` | symbolic non-clean rows recorded; orthogonality proof false |
| normalizer $N_f$ | Lemma 4 and theorem normalizer, arXiv:2506.20478 | `Coeff.symbol "N_f"` inside `GHL2025.oneTermRobinNormalizer` and `FunctionOracleContract.normalizerBound` | recorded; analytic bound unproved |
| legacy data helper | Fig. 1-term Robin, arXiv:2506.20478 | `GHL2025.functionOracleMatrix`, `FunctionOraclePaperImage.diagonalHelperIsolation` | helper retained; not the active gate |
| amplitude relation | Lemma 4, arXiv:2506.20478 | `FunctionOracleContract.amplitudeCorrect`, `RobinProofObligations.functionOracleCorrect` | unproved; must stay false |
| unitarity and clean workspace | Lemma 4, arXiv:2506.20478 | `oneTermRobinGate_O_f p`.unitary and a future $m_f$ workspace cleanup lemma | unproved; must stay false |

### O_f Proof-DAG Pane

The paper source for every row below is Guseynov-Huang-Liu 2025, Lemma 4,
Fig. 1-term Robin, and the coordinate-oracle equation, arXiv:2506.20478.

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `of_extract_registers` | extract the system grid index, $m_f$ workspace value, and all non-$m_f$ bits from a compound basis index | register layout, `defaultRobinRegisterPartition`, `robinIndicatorBitPosition` | `FunctionOraclePaperRegisters`, `functionOraclePaperRegisters` | paper image, tests | O_f | defined skeleton; concrete tests pass |
| `of_function_values` | provide one symbolic value $f(x_i)$ per grid point | `of_extract_registers` | `robinFunctionValue` | normalized amplitude, final target $A_k$ | O_f | defined symbolic data |
| `of_normalized_value` | record the clean-branch amplitude as $f(x_i)/N_f$ without proving division or bounds | `of_function_values`, `FunctionOracleContract.normalizerBound` | `functionOracleNormalizedValue` using symbolic `N_f_inv` | paper image, amplitude contract | O_f | defined symbolic contract; proof false |
| `of_paper_image` | record the clean-workspace branch $|0\rangle^{m_f}|i\rangle \mapsto (f(x_i)/N_f)|0\rangle^{m_f}|i\rangle + |\mathrm{orth}_f(i)\rangle$ | `of_extract_registers`, `of_normalized_value` | `FunctionOraclePaperImage`, `functionOraclePaperImage` | paper matrix skeleton, block extraction | O_f | defined contract; proof flags false |
| `of_paper_matrix` | expose the clean branch for clean input columns, zero other clean-workspace output rows, and leave non-clean input/completion rows symbolic | `of_paper_image`, `of_orthogonal_component` | `functionOracleOrthogonalEntry`, `functionOraclePaperMatrix`, `oneTermRobinGate_O_f` | circuit product, block extraction | O_f | active skeleton wired; completion unproved |
| `of_orthogonal_component` | state that the orthogonal component has zero clean-workspace overlap and preserves the system label required by the paper contract | `of_paper_image` | `FunctionOraclePaperImage.orthogonalComponentCorrect`, `systemPreserved`, `cleanWorkspaceBranch` | amplitude correctness, unitarity | O_f | recorded; orthogonality proof false |
| `of_normalizer_bound` | state and prove the $N_f$ bound needed for amplitudes | future coefficient/function semantics | `FunctionOracleContract.normalizerBound`, future bound theorem | amplitude relation, unitarity | O_f | recorded; proof missing |
| `of_diagonal_helper_isolation` | keep `functionOracleMatrix` helper-only so the diagonal data path is not mistaken for Lemma 4 | `of_paper_image`, current tests | `functionOracleMatrix`, `FunctionOraclePaperImage.diagonalHelperIsolation` | source-contract audit | O_f | helper isolated; proof flag false |
| `of_amplitude_contract` | prove the paper amplitude relation and clean $m_f$ workspace | `of_paper_image`, `of_orthogonal_component`, `of_normalizer_bound` | `FunctionOracleContract.amplitudeCorrect`, `RobinProofObligations.functionOracleCorrect` | final block extraction | O_f | unproved |

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
| `odts_coeff_normalizer` | prove the symbolic entries match $D_j^{(s)}/N_D$ and the complementary normalizer term from Eq. (20) | Lemma 3, Eq. (20), arXiv:2506.20478 | `sparseAmplitudeOracleDTCoefficientNormalizerContract`, `sparseAmplitudeOracleDTCoefficientNormalizerObligation` | `robinSparseAmplitudeValue`, future $N_D$ bound | `odts_rotation_unitary`, block extraction | typed contract recorded; analytic identities unproved |
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
| `ryb_angle_normalizer` | prove $\theta_j^s=\arccos(D_j^{(s)}/N_D)$ and the two half-angle formulas | Eq. angles for Ry, arXiv:2506.20478 | `BoundaryRotationAngleNormalizerContract`, `boundaryRotationAngleNormalizerObligation` | `robinSparseAmplitudeValue`, future $N_D$ bound | `ryb_rotation_unitary`, block extraction | typed contract recorded; proof flags false |
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
two vanishing facts needed by the later block-extraction proof.  It does not
change `oneTermRobinGate_SWAP.unitary.proved`, which remains `false`.

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `swap_diff_bounded` | `diff < 2^n` for the two extracted n-bit blocks | `Nat.xor_lt_two_pow`, `Nat.and_lt_two_pow` | `swapOracleDiff_lt_two_pow` | `swap_block1_image`, `swap_block2_image`, `swap_lt` | SWAP | proved |
| `swap_diff_shift_right_zero` | `diff >>> n = 0` | `swap_diff_bounded`, `Nat.shiftRight_eq_zero` | `swapOracleDiff_shiftRight_eq_zero` | `swap_block2_image` | SWAP | proved |
| `swap_diff_shift_left_mask_zero` | `(diff <<< n) &&& mask = 0` | `shiftLeft_land_mask_eq_zero` | `swapOracleDiff_shiftLeft_mask_eq_zero` | `swap_block1_image` | SWAP | proved |
| `swap_block1_image` | after `swapOracleImage`, the low block equals the old high block | bit-test proof over `swapOracleImage`, `Nat.testBit_xor`, `Nat.testBit_shiftLeft`, and mask facts | `swapOracleImage_block1_eq_block2` | `swap_diff_preserved` | SWAP | proved |
| `swap_block2_image` | after `swapOracleImage`, the high block equals the old low block | diff boundedness, shift-right lemmas | `swapOracleImage_block2_eq_block1` | `swap_diff_preserved` | SWAP | planned |

The source-contract audit introduced `BandedSparseAccessPaperContract`, and the
active O_D^BS gate pair now uses `bandedSparseAccessPaperMatrix` and
`bandedSparseAccessPaperDaggerMatrix`.  No lower worker should prove unitarity
for the legacy `bandedSparseAccessMatrix` or `bandedSparseAccessDaggerMatrix`
as if those helpers were the paper oracle.

The lower packet proved only `swapOracleImage_block1_eq_block2` in
`QuantumBlockEncoding/GHL2025.lean`.  The proof is general in `p` and `j`;
it is not a finite `native_decide` sample.  The SWAP unitarity obligation stays
unpromoted, so `oneTermRobinGate_SWAP.unitary.proved` remains `false`.

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

## Build Gate

```bash
python3 tools/qbe.py check
rg -n "Prop := True|:= trivial|sparseCorrect := True|amplitudeCorrect := True|lcuCorrect := True|\\bsorry\\b" QuantumBlockEncoding Tests -g '!QuantumBlockEncoding/Automation.lean' || true
```
