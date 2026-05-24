# Proof Obligations: QBE-AUTO-002 — Circuit Matrix Semantics Backend

Task id: `QBE-AUTO-002`
Updated: `2026-05-24`

This ledger tracks the unproved semantic claims introduced by the circuit
matrix semantics backend layer.

## Gate Matrix Placeholders

Each of the 7 circuit gates has a `GateMatrix` record with a nonzero matrix
semantics.  `U_indic` and SWAP have proved permutation-matrix certificates;
the remaining five gate unitarity claims remain explicit proof obligations.

| Gate | Lean declaration | Paper source | Status |
|---|---|---|---|
| U_indic | `GHL2025.oneTermRobinGate_U_indic` | U_indic definition and Fig. 1-term Robin, arXiv:2506.20478 | honest permutation matrix, **unitary proved** (cycle 2 → run 02 cycle 12 bijection + run 02 cycle 02 permutation bridge) |
| O_DT^S | `GHL2025.oneTermRobinGate_O_DT_S` | Lemma 3, Eq. (20), arXiv:2506.20478 | active controlled-rotation skeleton; coefficient-normalizer relation and unitarity unproved |
| Ry_boundary | `GHL2025.oneTermRobinGate_Ry_boundary` | Fig. 1-term Robin and Eq. angles for Ry, arXiv:2506.20478 | active symbolic controlled rotation matrix; angle-normalizer contract and unitarity unproved |
| O_D^BS | `GHL2025.oneTermRobinGate_O_D_BS` | Lemma 1, arXiv:2506.20478 | active global sparse-slot paper-image matrix skeleton; `bandedSparseAccessPaperGlobalSlotSource` now records the faithful clean source predicate as padded clean input plus sparse index $s<\kappa$; finite-image, entry-safety, finite-range cleanup wrapper, global-source image injectivity, post-SWAP unique preimage, and record-level inverse bridge proved under explicit hypotheses; `oneTermRobinGate_O_D_BS_globalSparseBoundaryNoCollision_n3` proves the corrected active image separates the old $n=3$ boundary columns, while `oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3` is retained as a rejected row-dependent-model regression; forward correctness, semantic cleanup, obligation-record flag promotion, and unitarity unproved |
| O_f | `GHL2025.oneTermRobinGate_O_f` | Theorem `Amplitude-oracle for piece-wise polynomial function`, Eq. `coordinate oracle`, and Fig. 1-term Robin, arXiv:2506.20478 | active paper-image matrix skeleton with clean $m_f$ branch wired; orthogonal completion, amplitude relation, normalizer bound, and unitarity unproved |
| SWAP | `GHL2025.oneTermRobinGate_SWAP` | Fig. 1-term Robin SWAP operation, arXiv:2506.20478 | honest permutation matrix; finite-domain row/column uniqueness proved by `swapOracleMatrix_is_permutation`; `unitary.proved := true` |
| (O_D^BS)^dagger | `GHL2025.oneTermRobinGate_O_D_BS_dagger` | Fig. 1-term Robin caption, arXiv:2506.20478 | active transpose-style paper-image matrix; conditional entry and register-cleanup witness available for the global-source candidate, and `bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge` identifies that candidate among active global-source preimages; semantic cleanup and unitarity unproved |

## Critical Correction: O_D^BS Global Sparse Slots

The previous O_D^BS blocker has been reclassified before more proof search.
`oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3` is a valid compiled
witness about the rejected row-dependent Lean address model, but it should not
be treated as evidence that the GHL paper lacks a reversible image rule.

The source audit points to a different faithful target:

- Lemma `Diagonal sparsity` defines the sparse index $s$ as a band/diagonal
  slot derived from the first-row band pattern.
- Lemma `Banded-sparse-access-oracle` defines
  $r_{si}=r_{s0}+i \bmod 2^n$ and maps
  $|0\rangle^{n-l}|s\rangle^l|i\rangle^n$ to
  $|r_{si}\rangle^n|i\rangle^n$.
- Remark `sparsity maximum` says the Robin example has seven diagonal slots,
  including two boundary-effect diagonals.
- The one-term Robin construction then says zeros may be included and sums
  over $s=0,\dots,\kappa-1$.

Therefore the active obligation is not to invent an unused-branch image for a
row-dependent source domain.  The Lean `O_D^BS` address layer now uses a global
$\kappa=7$ sparse-slot offset table, while the boundary amplitude layer remains
responsible for zero coefficients where a slot has no nonzero matrix entry.
The historical collision theorem is retained as a rejected-model regression
test, and the corrected active image has a compiled no-collision regression for
the old columns `0` and `48`.

Lower implementation status:

| Target | Required action | Forbidden shortcut |
|---|---|---|
| `odbs_global_sparse_slots` | implemented `oneTermRobinGlobalSparseOffset` for the seven one-term Robin slots | do not use row-dependent validity to delete clean sparse-register slots |
| `odbs_global_address` | implemented `oneTermRobinGlobalSparseAddress` as $r_{s0}+i \bmod 2^n$ | do not map unused boundary slots to `i` unless the slot offset really gives `i` |
| `odbs_global_source_domain` | implemented `bandedSparseAccessPaperGlobalSlotSource` as clean padded input plus sparse index $s<\kappa$; old columns `0` and `48` are both active global sources | do not use `bandedSparseAccessPaperValidCleanSource` to delete zero-amplitude boundary slots |
| `odbs_rewire_active_image` | rewired `bandedSparseAccessPaperAddress`; `bandedSparseAccessPaperImage` now reads the corrected address | do not promote unitarity or cleanup in this step unless the finite permutation proof is complete |
| `odbs_rejected_model_memory` | added `bandedSparseAccessRowDependentPaperAddress` and `bandedSparseAccessRowDependentPaperImage`; kept the old collision witness as rejected-model memory | do not present the old witness as a paper-level source gap |

## Circuit Semantics

| Obligation | Declaration | Status |
|---|---|---|
| Gate list matches circuit | `GHL2025.oneTermRobinPlaceholdersMatch` | proved |
| Circuit matrix = product of gate matrices | `oneTermRobinCircuitSemantics.matrix_eq_eval` | proved (by rfl on gate matrices) |

## Block Extraction Target

| Obligation | Declaration | Status |
|---|---|---|
| Block projection extracts correct submatrix | `oneTermRobinBlockExtractionTarget.blockProjection` | unproved |
| Extracted block = targetMatrix / normalizer | `oneTermRobinBlockExtractionTarget.blockCorrect` | unproved |

## Dimension Bridge (Core.lean)

| Declaration | Role | Status |
|---|---|---|
| `clog2_gridSize` | `clog2 (gridSize n) = n` — arithmetic bridge from qubit counts to matrix dimensions | proved (by induction on n) |
| `log2_pred_two_pow_succ` | Supporting lemma: `log2 (2^(n+1) - 1) = n` | proved |

## Block Projection Infrastructure

| Declaration | Status |
|---|---|
| `signalSystemBlockRowIndex` | defined row offset `signalIdx * rows + i`; finite-bound lemma compiled |
| `signalSystemBlockColIndex` | defined column offset `signalIdx * cols + j`; finite-bound lemma compiled |
| `signalSystemBlockProjection` | defined (total, constructive) |
| `signalSystemBlockProjection_apply` | proved by `rfl`; projection reads the named row/column offsets |
| `totalCircuitQubits` | defined |
| `CircuitMatrixSemantics.blockExtractionTarget` | defined |

## Circuit Block Encoding Claim

| Declaration | Role | Status |
|---|---|---|
| `CircuitBlockEncodingClaim` | Schema: semantics + target + dimCompat + blockCorrect | defined |
| `Examples.RobinHeat.oneTermRobinCircuitBlockClaim` | Robin instance, takes `hDim` proof parameter | defined |
| `Examples.RobinHeat.oneTermRobinCircuitDimCompat` | Reusable proof that full dimension = signal dimension × system dimension | proved |
| `Examples.RobinHeat.defaultOneTermRobinCircuitBlockClaim` | Robin instance using the reusable dimension proof | defined |
| `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_claimBlockCorrectFalse` | Theorem-route guard tying the circuit-claim block flag to the target-level open block flags | proved; all three recorded flags are false |

| Obligation | Declaration | Status |
|---|---|---|
| Dimension compatibility for general `n` | `oneTermRobinCircuitDimCompat` using `clog2_gridSize` | proved |
| Block correctness for Robin | `blockCorrect` field | unproved |

## Downstream Dependencies

These obligations block completion of `QBE-AUTO-001`:
- Unitarity is proved for `U_indic` and SWAP; it remains unproved for the other five gate matrices.
- The composed circuit matrix is now nontrivial, but the extracted block has not yet been proved equal to $A_k/(N_DN_f\kappa)$.
- The active `O_D^BS` paper-image matrix has explicit clean-input, global-slot address-range, no-spill, finite-range, global-source injectivity, post-SWAP unique-preimage, and record-level inverse bridge checks.  Lemma 1 covers columns with padded register $|0\rangle^{n-l}$ and output address $|r_{si}\rangle^n$; the executable address/no-spill/range and finite preimage checks are proved under explicit hypotheses.  The former boundary collision is now a rejected row-dependent-model regression, and `oneTermRobinGate_O_D_BS_globalSparseBoundaryNoCollision_n3` checks that the corrected active image separates the old $n=3$ boundary columns.  Semantic cleanup, obligation-record flag promotion, and full unitary extension remain open.
- `O_{D^T}^S` now uses the controlled-rotation skeleton; the diagonal helper remains available only as data.  The next source-contract gap is the coefficient-normalizer relation for the symbolic rotation entries from Lemma 3, Eq. (20).
- `R_y^{boundary}` now has a typed angle-normalizer contract.  Its remaining gap is proving $\theta_j^s=\arccos(D_j^{(s)}/N_D)$, the half-angle identities, and the two-by-two unitarity relation under the paper's $N_D$ bound.
- The shared derivative normalizer contract `GHL2025.derivativeNormalizerNDContract` now records the common $D_j^{(s)}/N_D$ source for `O_{D^T}^S` and `R_y^{boundary}`.  Its nonzero, division, coefficient-bound, absolute-square, square-root, arccos, and two-by-two-unitary fields remain `proved := false`.
- `O_f` now uses the paper-image matrix skeleton.  The clean $m_f$ branch entry is `functionOracleNormalizedValue`; the symbolic non-clean rows are only an unresolved orthogonal completion, so the $N_f$ bound, amplitude correctness, orthogonality, and unitarity remain open.
- The O_f cited-theorem dependency is now typed as `FunctionOracleExternalAmplitudeSourceContract` and `functionOracleExternalAmplitudeSourceContract`.  It records the GHL2025 coordinate-oracle theorem, the cited arXiv:2411.01131 source, the $N_f$ symbol, and false source-side obligations; it does not close any analytic O_f flag.
- The O_f $N_f$ amplitude route is now typed as `FunctionOracleAmplitudeProofRoute` and `functionOracleAmplitudeProofRoute`.  It ties `robinFunctionValue`, `functionOracleNormalizedValue`, `functionOraclePaperImage`, the external source transcript, and the theorem normalizer symbol together, but nonzero $N_f$, division semantics, the $N_f$ bound, orthogonal completion, unitary completion, and theorem-level amplitude correctness remain false.

## 2026-05-24 Middle Global-Slot Correction Sync

Middle re-audited the O_D^BS source contract against GHL2025 Lemma
`Diagonal sparsity`, Lemma `Banded-sparse-access-oracle`, Remark `sparsity
maximum`, the zero-inclusion paragraph before Theorem `1 term robin`, and
Fig. `fig:1 term ROBIN`.  The current proof blocker is now classified as
`contract-drift` for the historical row-dependent helper: the active Lean
address has been rewired from `robinSparseColumnMap` to the global sparse-slot
formula $r_{si}=r_{s0}+i \bmod 2^n$.

The compiled theorem
`oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3` remains valuable,
but only as rejected-model memory.  It should not be used as evidence that the
paper lacks an image rule for zero-amplitude sparse slots.

| Obligation | Lean target | Status |
|---|---|---|
| global sparse-slot table | `oneTermRobinGlobalSparseOffset` | implemented for the seven one-term Robin slots |
| global address formula | `oneTermRobinGlobalSparseAddress` and corrected `bandedSparseAccessPaperAddress` | implements $r_{s0}+i \bmod 2^n$ |
| active image splice | `bandedSparseAccessPaperImage` through the corrected address | no semantic flag promoted yet |
| old collision witness | `oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3` plus row-dependent helpers | rejected-model regression only |
| zero boundary coefficient | existing or refined `robinSparseAmplitudeValue` | amplitude layer supplies coefficient value $0$; the sparse slot remains present |

Lower implementation packet result:

| Field | Requirement |
|---|---|
| allowed work | introduced the global slot-offset table, defined the global address, and rewired the active paper address/image |
| required regression | `oneTermRobinGate_O_D_BS_globalSparseBoundaryNoCollision_n3` shows old columns `0` and `48` no longer collide in the corrected active image for the $n=3,\kappa=7$ test case |
| retained regression | `oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3` now witnesses the historical row-dependent helper collision |
| forbidden promotion | O_D^BS forward correctness, dagger cleanup, unitarity, block projection, block correctness, and LCU correctness remain unproved |
| cited-results row | use `QBE.ODBS.GlobalSparseSlotAddress` as the active obligation; `QBE.ODBS.UnusedZeroBranchExtension` is historical rejected-model memory |

Follow-up lower result:

| Obligation | Lean target | Status |
|---|---|---|
| active global-source finite entry witness | `oneTermRobinGate_O_D_BS_globalSlotSource_entrySafety` | proved executable bridge from `bandedSparseAccessPaperGlobalSlotSource` and `2 <= p.n` to a finite image index, active forward entry, transpose-style dagger entry, row/address roundtrip, and no-spill Boolean |
| proof flags | active `O_D^BS` and `(O_D^BS)^\dagger` unitarity fields | remain `false`; no injectivity, inverse uniqueness, cleanup, LCU correctness, or block extraction was promoted |
| focused regression test | `Tests/Basic.lean`, column `48` for `n=3`, `kappa=7` | confirms the old boundary column is handled by the global-source entry witness rather than the rejected row-dependent source predicate |

Middle follow-up result:

| Obligation | Lean target | Status |
|---|---|---|
| active global-source cleanup-candidate wrapper | `bandedSparseAccessPostSwapCleanup_of_globalSlotSourceCandidate_noRange` | proved conditional bridge from `bandedSparseAccessPaperGlobalSlotSource` to the existing post-SWAP cleanup candidate witness |
| focused regression test | `Tests/Basic.lean`, column `48` for `n=3`, `kappa=7` | confirms the wrapper applies to an active global source that the rejected row-dependent valid-source predicate excludes |
| proof flags | active `O_D^BS`, `(O_D^BS)^\dagger`, LCU, circuit unitarity, block projection, and block correctness | remain `false`; the wrapper does not prove uniqueness, semantic dagger cleanup, or unitarity |

Latest inverse-route status:

| Obligation | Lean target | Status |
|---|---|---|
| active global-source image injectivity | `bandedSparseAccessPaperImage_injective_on_globalSlotSource` | compiled finite-map theorem; record flag `imageInjectiveOnGlobalSource.proved` remains `false` |
| post-SWAP candidate source and uniqueness | `bandedSparseAccessPaperPostSwapPreimageCandidate_globalSlotSource_of_globalSlotSource`, `bandedSparseAccessPaperPostSwapPreimageCandidate_unique_on_globalSlotSource` | compiled finite-register route; `uniquePreimage.proved` remains `false` |
| record-level inverse bridge | `bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge` | connects the finite theorem to `BandedSparseAccessGlobalSlotInverseOnRangeContract`; `inverseOnRange`, `uniquePreimage`, `imageInjectiveOnGlobalSource`, `daggerCleanup`, and `unitaryExtension` fields remain `false` |
| active global-source dagger cleanup witness bridge | `bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerCleanupBridge` | packages the contract post-SWAP target and candidate preimage into `BandedSparseAccessPostSwapCleanup`, exposing the transpose-style dagger entry and executable register checks; `daggerCleanup` and `unitaryExtension` fields remain `false` |
| next dagger-cleanup packet | planned reviewed cleanup contract map | classify as `classical-lean-lemma`: decide whether the compiled witness and uniqueness bridge are enough to state a narrower inverse-on-range obligation, without promoting semantic flags |

## Edge-Case Validation Tests (Cycle 1)

| Test | Parameters | Method | Status |
|---|---|---|---|
| n=1 dimension compatibility | `qubitDim total = signal * gridSize 1` | `native_decide` | proved |
| n=1 circuit block claim dim compat | `dimCompat` roundtrip | `rfl` | proved |
| 1×1 system block projection | `signalSystemBlockProjection 2 1 1` | `native_decide` | proved |
| n=2 field-access roundtrip | `targetMatrix` matches `robinDerivativeMatrix` | `rfl` | proved |
| n=2 circuit identity | `defaultClaim.semantics.circuit = oneTermRobinCircuit` | `rfl` | proved |

## Register Convention and F1 Fix (Cycle 2)

| Declaration | Role | Status |
|---|---|---|
| `oneTermRobinTotalQubits` | circuit-level total = register partition total | fixed (12 → 13 for n=3) |
| `effectiveRobinSignalQubits` | signal dim including visible ancillas | implemented |
| `robinIndicatorBitPosition` | indicator bit position = 1 + 2n | implemented |
| `indicatorOracleMatrix` | honest U_indic permutation matrix | implemented |
| `oneTermRobinGate_U_indic` | updated gate matrix with honest matrix | fixed |

### U_indic Matrix Obligations

| Obligation | Status |
|---|---|
| Matrix entries compute correctly for bulk rows | tested (native_decide) |
| Matrix entries compute correctly for boundary rows | tested (native_decide) |
| Unitarity of U_indic | **proved** (`unitary.proved := true`, via `indicatorOracleMatrix_is_permutation`) |
| No promoted obligations from cycle 1 | verified |

### Cycle 2 Tests Added

| Test | Parameters | Method | Status |
|---|---|---|---|
| Total qubits = 13 | n=3, κ=7 | rfl | proved |
| Total qubits = 7 | n=1, κ=1 | rfl | proved |
| Indicator bit = 7 | n=3, κ=7 | rfl | proved |
| Indicator bit = 3 | n=1, κ=1 | rfl | proved |
| Effective signal = 10 | n=3, κ=7 | rfl | proved |
| Effective signal = 6 | n=1, κ=1 | rfl | proved |
| U_indic bulk row → flips indicator | j=4 → image=132, n=3 | native_decide | proved |
| U_indic boundary row → identity | j=0 → image=0, n=3 | native_decide | proved |
| U_indic inverse mapping | j=132 → image=4, n=3 | native_decide | proved |
| U_indic off-diagonal = 0 | M(0,4)=0, n=3 | native_decide | proved |
| Dim compat n=3 | 2^13 = 2^10 × 8 | native_decide | proved |
| Dim compat n=1 | 2^7 = 2^6 × 2 | native_decide | proved |

## Cycle 3: SWAP Matrix and Finite-Domain Permutation Bridge

| Declaration | Role | Status |
|---|---|---|
| `swapOracleMatrix` | honest SWAP permutation matrix | implemented |
| updated `oneTermRobinGate_SWAP` | uses honest matrix | `unitary.proved := true` after finite permutation bridge |

### SWAP Matrix Obligations

| Obligation | Status |
|---|---|
| Matrix entries swap two n-qubit register blocks correctly | tested (native_decide, 2 swap pairs) |
| Equal blocks → identity | tested (native_decide) |
| Preserves bits outside swapped blocks | tested (native_decide) |
| Register block equations | proved by `swapOracleImage_block1_eq_block2` and `swapOracleImage_block2_eq_block1` |
| Finite-range preservation | proved by `swapOracleImage_lt_qubitDim` |
| Source-dependency classification | `classical-lean-lemma`; prove the XOR image route locally rather than relying on an external SWAP theorem |
| Self-inverse route | proved by `swapOracleDiff_preserved`, `xor_two_shifted_masks_cancel`, and `swapOracleImage_self_inverse` |
| Finite permutation bridge | proved by `swapOracleImage_injective`, `swapOracleImage_bijective`, row/column uniqueness lemmas, and `swapOracleMatrix_is_permutation` |
| Unitarity of SWAP | promoted (`unitary.proved := true`) after the finite permutation bridge compiled |
| No promoted obligations from cycle 2 | verified |

### Cycle 3 Tests Added

| Test | Parameters | Method | Status |
|---|---|---|---|
| Swap pair 86 ↔ 58 | n=3, κ=7 | native_decide | proved |
| Swap pair reverse 58 → 86 | n=3, κ=7 | native_decide | proved |
| Swap pair 2 ↔ 16 | n=3, κ=7 | native_decide | proved |
| Swap pair reverse 16 → 2 | n=3, κ=7 | native_decide | proved |
| Equal blocks → identity (j=54) | n=3, κ=7 | native_decide | proved |
| Preserves indicator bit (j=214 → 186) | n=3, κ=7 | native_decide | proved |
| Indicator bit of 186 = 1 | n=3, κ=7 | native_decide | proved |
| Ancilla bits preserved (even) | n=3, κ=7 | native_decide | proved |
| SWAP unitary.proved = true | n=3, κ=7 | rfl | proved |
| Placeholder match with honest SWAP | general p | theorem | proved |

### Completed Lower Packet: SWAP Self-Inverse Route

| Field | Result |
|---|---|
| fixed target | `swap_self_inverse` for the existing `GHL2025.swapOracleImage` |
| accepted declarations | `swapOracleDiff`, `swapOracleImage_eq_xor_diff`, `swapOracleDiff_preserved`, `xor_two_shifted_masks_cancel`, `swapOracleImage_self_inverse` |
| allowed write scope | `QuantumBlockEncoding/GHL2025.lean`, focused tests in `Tests/Basic.lean`, and synchronized SWAP notes |
| dependencies to reuse | `swapOracleImage_block1_eq_block2`, `swapOracleImage_block2_eq_block1`, `swapOracleImage_lt_qubitDim`, `swapOracleDiff_lt_two_pow`, `swapOracleDiff_shiftRight_eq_zero`, `swapOracleDiff_shiftLeft_mask_eq_zero`, and the existing U_indic self-inverse/bijection pattern |
| forbidden promotions | satisfied for this packet: no O_D^BS, O_f, LCU, circuit-unitary, block-projection, or block-correctness flags were promoted; SWAP promotion was left to the finite permutation bridge |
| acceptance | `python3 tools/qbe.py check` with the forbidden-pattern scan clean |

### Completed Lower Packet: SWAP Finite-Domain Permutation Bridge

| Field | Instruction |
|---|---|
| fixed target | finite-domain bijection and permutation-matrix certificate for the existing `GHL2025.swapOracleImage` and `GHL2025.swapOracleMatrix` |
| accepted declarations | `swapOracleImage_injective`, `swapOracleImage_bijective`, `swapOracleMatrix_col_has_one`, `swapOracleMatrix_col_unique`, `swapOracleMatrix_row_has_one`, `swapOracleMatrix_row_unique`, `swapOracleMatrix_is_permutation` |
| dependencies to reuse | `swapOracleImage_self_inverse`, `swapOracleImage_lt_qubitDim`, `swapOracleMatrix_eq_image`, and the accepted U_indic bijection-to-permutation bridge |
| forbidden promotions | no O_D^BS, O_f, LCU, circuit-unitary, block-projection, or block-correctness flag changed; `(GHL2025.oneTermRobinGate_SWAP p).unitary.proved = true` because the full SWAP permutation-matrix bridge compiles |
| acceptance | `python3 tools/qbe.py check` with the forbidden-pattern scan clean |

## Cycle 4: O_D^BS and (O_D^BS)^† Matrices

### Faithfulness Correction: 2026-05-22

The legacy Lean `bandedSparseAccessMatrix` is an interim column-map helper, not
the paper's full register-level sparse-access oracle.  The paper's Lemma 1
states:

$$
\hat O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n
=
|r_{si}\rangle^n|i\rangle^n.
$$

The legacy helper instead keeps the sparse-index register and overwrites the
system register using `robinSparseColumnMap`.  Its boundary non-injectivity
witness is evidence that this simplified contract should not be used as the
paper oracle's unitarity target.  The active gate pair now uses
`bandedSparseAccessPaperMatrix` and `bandedSparseAccessPaperDaggerMatrix`.
The next faithful-mode work is to validate the active contract and keep range,
injectivity, inverse-on-range, cleanup, and block-extraction gaps explicit
before any `O_D^BS` unitarity proof attempt.

### Source-Contract Audit Record

`GHL2025.BandedSparseAccessPaperContract` now records the paper target as data
separate from the interim helper.  The default one-term contract is
`GHL2025.defaultBandedSparseAccessPaperContract p`.

| Field / obligation | Paper source | Lean field | Status |
|---|---|---|---|
| input registers | Lemma 1, arXiv:2506.20478 | `inputKet = "|0>^(n-l)|s>^l|i>^n"` | recorded |
| output registers | Lemma 1, arXiv:2506.20478 | `outputKet = "|r_si>^n|i>^n"` | recorded |
| image formula | Lemma 1, arXiv:2506.20478 | `imageFormula = "r_si = r_s0 + i mod 2^n"` | recorded |
| clean-input domain | Lemma 1, arXiv:2506.20478 | `cleanInputDomain`, `bandedSparseAccessPaperCleanInput`, `bandedSparseAccessPaperColumnContract.cleanInput` | recorded; obligation unproved (`proved := false`) |
| padded width equation | Lemma 1, arXiv:2506.20478 | `widthCompatible` | unproved (`proved := false`) |
| address range | Lemma 1, arXiv:2506.20478 | `addressRange`, `bandedSparseAccessPaperAddressInRange`, `bandedSparseAccessPaperAddressInRange_eq_true_of_two_le`, `bandedSparseAccessPaperColumnContract.addressInRange` | executable check proved for $2 \le n$; semantic obligation still unproved (`proved := false`) |
| no spill above O_D register | Lemma 1 and Fig. 1-term Robin, arXiv:2506.20478 | `noSpill`, `bandedSparseAccessPaperHighTail`, `bandedSparseAccessPaperImageNoSpill`, `bandedSparseAccessPaperImageNoSpill_iff`, `bandedSparseAccessPaperImage_highTail_eq_of_address_lt`, `bandedSparseAccessPaperImageNoSpill_eq_true_of_address_lt`, `bandedSparseAccessPaperImageNoSpill_eq_true_of_two_le`, `bandedSparseAccessPaperColumnContract.imageNoSpill` | executable no-spill proved from an n-bit address and from $2 \le n$ via address range; semantic obligation unproved (`proved := false`) |
| forward oracle correctness | Lemma 1, arXiv:2506.20478 | `forwardCorrect` | unproved (`proved := false`) |
| dagger cleanup | Fig. 1-term Robin and Lemma 1, arXiv:2506.20478 | `daggerCleanup` | unproved (`proved := false`) |
| full unitary completion | Lemma 1, arXiv:2506.20478 | `unitaryExtension`, `bandedSparseAccessPaperColumnContract.unitaryExtension` | unproved (`proved := false`) |
| register extraction | Lemma 1 and Fig. 1-term Robin, arXiv:2506.20478 | `bandedSparseAccessPaperRegisters` | defined skeleton; concrete tests pass |
| executable paper image | Lemma 1, arXiv:2506.20478 | `bandedSparseAccessPaperAddress`, `bandedSparseAccessPaperImage` | active image skeleton; correctness unproved |
| paper-image matrix | Lemma 1, arXiv:2506.20478 | `bandedSparseAccessPaperMatrix` | active forward gate matrix skeleton |
| paper-image dagger matrix | Fig. 1-term Robin and Lemma 1, arXiv:2506.20478 | `bandedSparseAccessPaperDaggerMatrix` | active transpose-style skeleton; cleanup unproved |

### O_D^BS Register Proof-DAG

These blocks are the faithful-paper path for validating the active
paper-image gate pair.  They do not change any `proved` flag until the
corresponding Lean declaration compiles and matches Lemma 1.

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `odbs_width_compatible` | show that the padded sparse-index register has width $n$ | `clog2 p.kappa <= p.n` or a recorded parameter-family proof | `defaultBandedSparseAccessPaperContract p`.widthCompatible | register extraction, paper image | unproved |
| `odbs_extract_registers` | extract padded-zero, sparse-index, full O_D register, and row fields from the one-term compound index | `oneTermRobinTotalQubits`, `defaultRobinRegisterPartition` | `bandedSparseAccessPaperRegisters` | paper image, dagger cleanup | defined skeleton |
| `odbs_clean_domain` | check whether a basis column satisfies the clean padded-zero input required by Lemma 1, and keep non-clean columns in the unitary-extension obligation | `odbs_extract_registers` | `bandedSparseAccessPaperCleanInput`, `bandedSparseAccessPaperCleanInput_iff`, `bandedSparseAccessPaperColumnContract`, `bandedSparseAccessPaperColumnContract_cleanInput_iff`, `bandedSparseAccessPaperColumnContract_unitaryExtension_proved_eq_false` | paper image, forward matrix, unitarity route | executable guard proved; semantic proof flags false |
| `odbs_valid_sparse_branch_domain` | keep a row-dependent audit predicate for sparse branches that correspond to nonzero Robin stencil entries | `odbs_clean_domain`, `odbs_rejected_row_dependent_collision` | `robinSparseColumnBranchValid`, `robinSparseColumnBranchValid_boundaryUnused_n3`, `bandedSparseAccessPaperValidSparseBranch`, `bandedSparseAccessPaperValidCleanSource`, `bandedSparseAccessPaperValidCleanSource_separates_boundaryCollision_n3` | rejected-model memory and future source-domain audits | audit domain defined and tested; active address now uses global sparse slots; semantic flags false |
| `odbs_global_source_domain` | keep the faithful clean source as padded clean input plus encoded sparse slot $s<\kappa$ | Lemma `Banded-sparse-access-oracle`, zero-inclusion paragraph before Theorem `1 term robin`, `odbs_global_address` | `bandedSparseAccessPaperSparseIndexInKappa`, `bandedSparseAccessPaperGlobalSlotSource`, `bandedSparseAccessPaperGlobalSlotSource_boundaryColumns_n3`, `bandedSparseAccessPaperGlobalSlotSource_encodedOutOfRange_n3` | active image/injectivity route, lower-packet source-domain guard | proved executable predicate and $n=3,\kappa=7$ regressions; semantic cleanup and unitarity flags false |
| `odbs_unused_branch_extension_contract` | record obligations for clean padded-register branches that are outside the row-dependent valid sparse-branch classifier | `odbs_valid_sparse_branch_domain`, `odbs_boundary_unused_collision` | `bandedSparseAccessPaperUnusedSparseBranch`, `BandedSparseAccessUnusedBranchExtensionContract`, `bandedSparseAccessUnusedBranchExtensionContract`, `bandedSparseAccessUnusedBranchExtensionContract_boundaryCollision_n3` | future injectivity route, dagger cleanup, reversible-extension audit | contract slot defined; all extension proof flags false; active matrices unchanged |
| `odbs_unused_branch_image_rule` | record the missing reversible image-rule interface for clean invalid sparse branches without choosing a replacement construction | `odbs_unused_branch_extension_contract`, `odbs_valid_sparse_branch_domain` | `BandedSparseAccessUnusedBranchImageRuleContract`, `bandedSparseAccessUnusedBranchImageRuleContract`, `bandedSparseAccessUnusedBranchImageRuleContract_flags_false`, `bandedSparseAccessUnusedBranchImageRuleContract_of_unusedBranch` | future injectivity route, dagger cleanup, reversible-extension audit | interface defined with `proposedImageIndex = none`; image-rule proof flags false; active matrices unchanged |
| `odbs_full_clean_domain_extension_contract` | lift the per-column unused-branch image-rule interface into a paper-level full clean-domain extension contract | `odbs_unused_branch_image_rule`, `odbs_valid_sparse_branch_domain`, `odbs_boundary_unused_collision` | `BandedSparseAccessFullCleanDomainExtensionContract`, `bandedSparseAccessFullCleanDomainExtensionContract`, `bandedSparseAccessFullCleanDomainExtensionContract_flags_false`, `bandedSparseAccessFullCleanDomainExtensionContract_of_unusedBranch`, `bandedSparseAccessPaperCleanDomainSplit_iff`, `bandedSparseAccessPaperCleanDomainSplit_disjoint`, `bandedSparseAccessFullCleanDomainExtensionContract_localCleanDomainSplit` | future full clean-domain injectivity, dagger cleanup, and unitary-extension route | wrapper defined; local classifier split proved; no external reversible-completion theorem recorded; all semantic flags false |
| `odbs_address_range` | prove or keep explicit that the written $r_{si}$ value is an n-bit address | `odbs_extract_registers`, `bandedSparseAccessPaperAddress` | `bandedSparseAccessPaperAddressInRange`, `defaultBandedSparseAccessPaperContract p`.addressRange | no-spill, forward matrix, unitarity route | executable check defined; proof flag false |
| `odbs_address_range_n_ge_2` | prove the executable address check once the paper parameter family supplies $2 \le n$ | row extraction, `oneTermRobinGlobalSparseAddress_lt_gridSize` | `bandedSparseAccessPaperAddress_lt_gridSize_of_two_le`, `bandedSparseAccessPaperAddressInRange_eq_true_of_two_le` | no-spill, forward matrix, unitarity route | proved under explicit side condition; proof flag false |
| `odbs_no_spill` | prove or keep explicit that `bandedSparseAccessPaperImage` does not alter indicator or $m_f$ bits above the O_D register | `odbs_address_range`, `odbs_forward_image` | `bandedSparseAccessPaperHighTail`, `bandedSparseAccessPaperImageNoSpill`, `bandedSparseAccessPaperImageNoSpill_iff`, `bandedSparseAccessPaperImage_highTail_eq_of_address_lt`, `bandedSparseAccessPaperImageNoSpill_eq_true_of_address_lt`, `bandedSparseAccessPaperImageNoSpill_eq_true_of_two_le`, `defaultBandedSparseAccessPaperContract p`.noSpill | dagger cleanup, block extraction | executable no-spill proved from address range and $2 \le n$; semantic proof flag false |
| `odbs_forward_image` | preserve the row register and replace the padded sparse-index register by $r_{si}$ | `odbs_width_compatible`, `odbs_extract_registers` | `bandedSparseAccessPaperAddress`, `bandedSparseAccessPaperImage` | forward matrix, cleanup | defined skeleton; correctness unproved |
| `odbs_column_audit_safety` | for each fixed column, package the executable audit booleans `rowPreserved`, `addressWritten`, `addressInRange`, and `imageNoSpill` under the existing n-bit-address hypothesis | `odbs_forward_image`, `odbs_address_range`, `odbs_no_spill` | `bandedSparseAccessPaperColumnContract_rowPreserved_eq_true`, `bandedSparseAccessPaperColumnContract_addressWritten_eq_true_of_address_lt`, `bandedSparseAccessPaperColumnContract_addressInRange_eq_true_of_address_lt`, `bandedSparseAccessPaperColumnContract_imageNoSpill_eq_true_of_address_lt`, `bandedSparseAccessPaperColumnContract_registerSafety_of_address_lt` | entry-safety witness, inverse-on-range route, cleanup route | proved as executable contract bridge; semantic flags false |
| `odbs_forward_matrix` | define matrix entries from the paper image rather than the interim column-map helper | `odbs_forward_image` | `bandedSparseAccessPaperMatrix` | `oneTermRobinGate_O_D_BS` | active skeleton; finite-image entry bridge and global-source image-injectivity theorem proved under explicit hypotheses; semantic flags false |
| `odbs_rejected_row_dependent_collision` | preserve the concrete collision caused by unused sparse-index branches in the rejected row-dependent helper | `odbs_forward_image`, `odbs_clean_domain`, row-dependent helper image | `bandedSparseAccessRowDependentPaperAddress`, `bandedSparseAccessRowDependentPaperImage`, `oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3`, `robinSparseColumnBranchValid_boundaryUnused_n3` | source-contract correction memory, reviewer guard | proved rejected-model obstruction for $n=3,\kappa=7$; corrected active image no longer uses this address |
| `odbs_global_boundary_no_collision` | exhibit that the corrected active global-slot image separates the old boundary columns | `odbs_forward_image`, `oneTermRobinGlobalSparseAddress`, active forward matrix | `oneTermRobinGate_O_D_BS_globalSparseBoundaryNoCollision_n3` | source-contract correction, future injectivity route guard | proved active no-collision regression; no semantic proof flags promoted |
| `odbs_dagger_matrix` | define transpose-style matrix entries from the paper image skeleton | `odbs_forward_image` | `bandedSparseAccessPaperDaggerMatrix` | `oneTermRobinGate_O_D_BS_dagger` | active skeleton; inverse-on-range unproved |
| `odbs_image_fin_entry_bridge` | package the executable image as a finite basis index and prove the forward and dagger entries at that index under explicit range hypotheses | `odbs_forward_image`, `odbs_address_range`, image range theorem | `bandedSparseAccessPaperImageFin`, `bandedSparseAccessPaperMatrix_imageFin_eq_one`, `bandedSparseAccessPaperDaggerMatrix_imageFin_eq_one`, `oneTermRobinGate_O_D_BS_imageFin_eq_one`, `oneTermRobinGate_O_D_BS_dagger_imageFin_eq_one` | injectivity, inverse-on-range, cleanup route | proved as executable bridge; semantic flags false |
| `odbs_entry_safety_witness` | package the active forward entry, active dagger entry, row roundtrip, address roundtrip, and no-spill check under the n-bit address hypothesis | `odbs_image_fin_entry_bridge`, `odbs_image_row_roundtrip`, `odbs_image_address_roundtrip`, `odbs_no_spill` | `oneTermRobinGate_O_D_BS_imageFin_entrySafety` | inverse-on-range and cleanup route | proved as executable witness; semantic flags false |
| `odbs_post_swap_registers` | prove that SWAP applied to the paper image puts $r_{si}$ in the system register and the original row in the O_D register | `odbs_entry_safety_witness`, `swap_block1_image`, `swap_block2_image` | `bandedSparseAccessPaperPostSwap_rowValue_eq_address`, `bandedSparseAccessPaperPostSwap_odRegisterValue_eq_rowValue` | inverse-on-range and cleanup route | proved as register equations; semantic cleanup flag false |
| `odbs_reverse_sparse_index` | compute the sparse index that would make the post-SWAP row address the original source row | global sparse-slot table, Lemma 1 register interpretation | `oneTermRobinGlobalSparseInverseSlot`, `oneTermRobinGlobalSparseAddress_inverseSlot_address_eq`; old `robinSparseReverseColumnIndex` blocks remain helper memory | preimage candidate, inverse-on-range route | global reverse candidate defined and roundtrip proved for $3 \le n$, $s < 8$, and `i < gridSize n`; no uniqueness or semantic cleanup flag |
| `odbs_post_swap_preimage_candidate` | build a clean post-SWAP preimage candidate by splicing a clean reverse sparse register into the post-SWAP column and audit image/clean/address checks | `odbs_reverse_sparse_index`, `swapOracleImage`, `bandedSparseAccessPaperImage`, clean-domain audit | `bandedSparseAccessPaperSpliceODRegister`, `bandedSparseAccessPaperCleanODValue`, `bandedSparseAccessPaperPostSwapPreimageCandidate`, `bandedSparseAccessPaperPostSwapPreimageCandidateChecks`, `bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_cleanSource`, `bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_cleanSource` | supplied-preimage cleanup witness, inverse-on-range route | candidate Boolean audit and finite-range theorem proved under explicit one-term hypotheses using the global inverse slot; semantic cleanup flag unproved |
| `odbs_global_source_image_injective` | prove that the corrected active image is injective on the faithful global clean-source domain | global-slot address uniqueness, clean O_D reconstruction, image row/address roundtrip | `bandedSparseAccessPaperImage_injective_on_globalSlotSource` | post-SWAP unique-preimage route | compiled finite-map theorem; `imageInjectiveOnGlobalSource.proved` remains false |
| `odbs_post_swap_unique_preimage` | prove that any active global-source preimage of the post-SWAP target is the candidate | candidate global-source helper, candidate image audit, active image injectivity | `bandedSparseAccessPaperPostSwapPreimageCandidate_sparseIndex_eq`, `bandedSparseAccessPaperPostSwapPreimageCandidate_globalSlotSource_of_globalSlotSource`, `bandedSparseAccessPaperPostSwapPreimageCandidate_unique_on_globalSlotSource` | record-level inverse bridge | compiled finite-register theorem; `uniquePreimage.proved` remains false |
| `odbs_record_level_inverse_bridge` | reflect the post-SWAP unique-preimage theorem in `BandedSparseAccessGlobalSlotInverseOnRangeContract` without changing obligation flags | unique-preimage theorem, candidate checks, false-flag guard | `bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge` | dagger-cleanup entry bridge | compiled bridge; inverse, uniqueness, injectivity, cleanup, and unitary-extension fields remain false |
| `odbs_dagger_cleanup_entry_bridge` | package the contract candidate, transpose-style dagger entry, and cleanup witness for the post-SWAP image | record-level inverse bridge, candidate range/checks, active global-source cleanup wrapper | `bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerCleanupBridge` | cleanup contract and later O_D^BS unitary route | compiled bridge; semantic flags false |
| `odbs_dagger_cleanup` | prove or record that $(O_D^{BS})^\dagger$ cleans the padded sparse-index register after SWAP | `odbs_forward_image`, SWAP block lemmas, supplied preimage contract, preimage candidate audit, finite post/pre ranges | `BandedSparseAccessPostSwapCleanup`, `bandedSparseAccessPostSwapCleanup_of_preimage`, `bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate`, `bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate_noRange`, `bandedSparseAccessPostSwapCleanup_of_validCleanSourceCandidate_noRange`, `bandedSparseAccessPostSwapCleanup_of_globalSlotSourceCandidate_noRange`, `defaultBandedSparseAccessPaperContract p`.daggerCleanup | block extraction | no-extra-range conditional witness, global-source uniqueness bridge, and active global-source wrapper proved; semantic cleanup proof flag remains unproved |
| `block_projection_normalizer` | audit that the signal-index-zero projection target uses the composed circuit matrix, Robin matrix, and normalizer $N_DN_f\kappa$ | active gate list, dimension split, O_D^BS cleanup obligations | `Examples.RobinHeat.oneTermRobinBlockExtractionTarget`, `signalSystemBlockRowIndex`, `signalSystemBlockColIndex`, `signalSystemBlockProjection`, `GHL2025.oneTermRobinNormalizer` | final block-correctness theorem | structural target plus named row/column index helpers defined; correctness unproved |

### Completed Middle Packet: Register Extraction and Paper Image

Run 03 cycle 1 introduced `bandedSparseAccessPaperRegisters`,
`bandedSparseAccessPaperAddress`, and `bandedSparseAccessPaperImage`.  These
declarations implement the Lean-facing skeleton for Lemma 1 by preserving the
row register and replacing the O_D register block with $r_{si}$.

| Required item | Acceptance |
|---|---|
| `bandedSparseAccessPaperRegisters` | exposes the padded sparse-index register and row register used by Lemma 1 |
| `bandedSparseAccessPaperImage` | states the basis-image formula $|0\rangle^{n-l}|s\rangle^l|i\rangle^n \mapsto |r_{si}\rangle^n|i\rangle^n$ without changing `unitary.proved` |
| examples for `n = 3`, `kappa = 7` | row preservation and address-register replacement pass for one bulk row and one boundary row |

Do not change the paper contract, introduce side conditions silently, or promote
`oneTermRobinGate_O_D_BS.unitary.proved`,
`oneTermRobinGate_O_D_BS_dagger.unitary.proved`, `forwardCorrect`, or
`daggerCleanup`.

### Completed Lower Packets: Paper-Image Matrix and Active Gate Pair

Run 03 cycle 1 lower introduced `bandedSparseAccessPaperMatrix`.  The matrix is
defined directly from `bandedSparseAccessPaperImage` with entries
$M[\mathrm{image}(j),j]=1$ and zero elsewhere.  Run 03 cycle 2 lower introduced
`bandedSparseAccessPaperDaggerMatrix` and rewired the active O_D^BS gate pair
to the paper-image forward and dagger matrices.  No correctness or unitarity
flag was promoted.

Run 03 cycle 3 lower added the per-column audit bridge
`bandedSparseAccessPaperColumnContract_registerSafety_of_address_lt`.  For each
fixed column and under the same n-bit-address hypothesis used by the finite
image witness, Lean now proves that the executable audit booleans
`rowPreserved`, `addressWritten`, `addressInRange`, and `imageNoSpill` are all
true.  This is not a proof of injectivity, cleanup, or unitarity, and the
paper-level obligation flags remain false.

### Completed Lower Packet: O_D^BS Contract Validation

This implementation packet was contract validation, not a unitarity proof.  It
confirms that the active matrices are wired to the paper-image declarations and
separates the remaining mathematical gaps.

| Target | Required Lean status |
|---|---|
| forward active matrix equality | `oneTermRobinGate_O_D_BS p`.matrix is `bandedSparseAccessPaperMatrix p` by definitional equality |
| dagger active matrix equality | `oneTermRobinGate_O_D_BS_dagger p`.matrix is `bandedSparseAccessPaperDaggerMatrix p` by definitional equality |
| finite image bridge | `bandedSparseAccessPaperImageFin p j haddr` packages the paper image as a finite basis index under explicit source-column and n-bit address hypotheses |
| forward finite-image entry | `bandedSparseAccessPaperMatrix_imageFin_eq_one` and `oneTermRobinGate_O_D_BS_imageFin_eq_one` prove entry $1$ at the finite image row |
| dagger finite-image entry | `bandedSparseAccessPaperDaggerMatrix_imageFin_eq_one` and `oneTermRobinGate_O_D_BS_dagger_imageFin_eq_one` prove entry $1$ in the paired transpose-style position |
| focused forward entries | for `n = 3`, `kappa = 7`, active gate has $M[40,8]=1$ and $M[4,8]=0$ |
| focused dagger entry | for `n = 3`, `kappa = 7`, active dagger has $M^\dagger[8,40]=1$ |
| explicit remaining obligations | paper-level address range and no-spill flags, injectivity, inverse-on-range, dagger cleanup after SWAP, and block extraction stay unproved |
| clean-domain audit | `bandedSparseAccessPaperCleanInput` and `bandedSparseAccessPaperColumnContract` separate Lemma 1 clean inputs from non-clean columns requiring a unitary extension |
| gate-list alignment | `oneTermRobinPlaceholdersMatch` still compiles |

The packet stayed within `Tests/Basic.lean` and this ledger.  It did not promote
`forwardCorrect`, `daggerCleanup`, either gate-level unitarity flag, or the
block-correctness obligations.

For the concrete test parameters `n = 3`, `kappa = 7`, the recorded widths are
`paddedZeroQubits = 0` and `sparseIndexQubits = 3`.  This does not discharge
the general width obligation for arbitrary `OneTermRobinParameters`.

### Completed Lower Packet: Post-SWAP Preimage Cleanup Witness

This packet adds the conditional interface
`BandedSparseAccessPostSwapCleanup` and constructor
`bandedSparseAccessPostSwapCleanup_of_preimage`.  The witness assumes the
post-SWAP column equality, a supplied paper-image preimage, clean padded input
for that preimage, and the n-bit address bound for that preimage.  From those
inputs Lean proves:

| Item | Lean field / declaration | Status |
|---|---|---|
| post-SWAP column relation | `BandedSparseAccessPostSwapCleanup.postSwap` | assumed explicitly |
| supplied dagger preimage | `BandedSparseAccessPostSwapCleanup.preimage` | assumed explicitly |
| active dagger entry | `daggerEntry`, using `oneTermRobinGate_O_D_BS_dagger_postSwap_entry_of_preimage` | proved from the transpose-style paper-image matrix |
| clean padded source for the dagger output | `preCleanInput` | assumed explicitly, not derived |
| row/address/no-spill audit booleans for the preimage | `preRowPreserved`, `preAddressWritten`, `preAddressInRange`, `preImageNoSpill` | proved from `bandedSparseAccessPaperColumnContract_registerSafety_of_address_lt` |
| post column register extraction | `postRow_eq_preRow`, `postOd_eq_preAddress` | proved by rewriting the supplied preimage through the paper-image row/address roundtrip lemmas |

For the focused concrete check `n = 3`, `kappa = 7`, source column `8` maps
through `O_D^BS` and SWAP to post column `68`, and `68` is a clean supplied
preimage of the active paper-image skeleton.  This example only validates the
interface shape; it does not prove that every post-SWAP column has a unique
clean preimage.

No proof flag was promoted:
`(defaultBandedSparseAccessPaperContract p).daggerCleanup.proved`,
`oneTermRobinGate_O_D_BS.unitary.proved`,
`oneTermRobinGate_O_D_BS_dagger.unitary.proved`, and block correctness remain
false.

### Completed Lower Packet: O_D^BS Clean-Domain Guard

This packet proves the executable guard around Lemma 1 clean columns.  The
predicate `bandedSparseAccessPaperCleanInput p j` is now equivalent to the
statement that the extracted padded-zero field is zero, and
`bandedSparseAccessPaperColumnContract_cleanInput_iff` lifts the same
equivalence to the per-column contract.  The theorem
`bandedSparseAccessPaperColumnContract_unitaryExtension_proved_eq_false` records
that the full-space unitary extension remains an open obligation for every
column, including columns outside the clean padded-register domain.

These declarations do not promote `cleanInputDomain.proved`,
`unitaryExtension.proved`, forward correctness, dagger cleanup, or either
`O_D^BS` gate-level unitarity flag.

### 2026-05-22 Contract-Validation Tests

| Test | Parameters | Method | Status |
|---|---|---|---|
| Active forward gate matrix is definitionally `bandedSparseAccessPaperMatrix` | general `p` | `rfl` | proved |
| Active forward gate entries follow `bandedSparseAccessPaperImage` | general `p`, `i`, `j` | `rfl` | proved |
| Active dagger gate matrix is definitionally `bandedSparseAccessPaperDaggerMatrix` | general `p` | `rfl` | proved |
| Active dagger gate entries follow the transpose-style paper image | general `p`, `i`, `j` | `rfl` | proved |
| `bandedSparseAccessPaperImageFin` value bridge | general `p`, finite source `j`, n-bit address hypothesis | theorem example | proved |
| Forward finite-image entry | general `p`, finite source `j`, n-bit address hypothesis | theorem example | proved |
| Dagger finite-image entry | general `p`, finite source `j`, n-bit address hypothesis | theorem example | proved |
| `widthCompatible.proved = false` | general `p` | `rfl` | proved |
| `cleanInputDomain.proved = false` | general `p` | `rfl` | proved |
| `forwardCorrect.proved = false` | general `p` | `rfl` | proved |
| `daggerCleanup.proved = false` | general `p` | `rfl` | proved |
| `unitaryExtension.proved = false` | general `p` | `rfl` | proved |
| Clean input column 8 | n=3, κ=7 | native_decide | proved |
| Non-clean padded column 32 | n=4, κ=7 | native_decide | recorded; Lemma 1 domain false |

The address-range route now has a compiled theorem for the explicit
side condition $2 \le n$.  The paper-level obligation remains false until that
side condition is recorded for the parameter family.  The no-spill route now
has a compiled high-tail theorem from an n-bit written address, plus a Boolean
corollary under $2 \le n$.  The image-range route now packages the executable
image as a finite basis index under the explicit source-column and n-bit address
hypotheses, and proves the forward and transpose-style entries at that index.
The remaining O_D^BS gaps are: injectivity on the finite basis domain,
inverse-on-range for `bandedSparseAccessPaperDaggerMatrix`, cleanup after SWAP,
and the final block extraction equation.

### 2026-05-22 Middle Packet: O_D^BS Address Range and No-Spill

This packet adds fixed Lean targets for the cycle handoff's missing
register-safety contract.  It does not change `bandedSparseAccessPaperMatrix`,
`bandedSparseAccessPaperDaggerMatrix`, any active gate list, or any proof flag.

| Target | Required Lean status |
|---|---|
| address-range obligation | `defaultBandedSparseAccessPaperContract p`.addressRange.proved remains `false` |
| no-spill obligation | `defaultBandedSparseAccessPaperContract p`.noSpill.proved remains `false` |
| executable address-range check | `bandedSparseAccessPaperAddressInRange p j` is defined |
| executable high-tail check | `bandedSparseAccessPaperImageNoSpill p j` is defined using `bandedSparseAccessPaperHighTail` |
| row range lemma | `bandedSparseAccessPaperRegisters_row_lt_gridSize` proves the extracted row field is n-bit |
| address range lemma | `bandedSparseAccessPaperAddressInRange_eq_true_of_two_le` proves the executable check under $2 \le n$ |
| no-spill high-tail lemma | `bandedSparseAccessPaperImage_highTail_eq_of_address_lt` proves high-tail preservation from an n-bit address |
| no-spill Boolean lemma | `bandedSparseAccessPaperImageNoSpill_eq_true_of_two_le` proves the executable no-spill check under $2 \le n$ |
| no-spill Boolean bridge | `bandedSparseAccessPaperImageNoSpill_iff` rewrites the Boolean check as high-tail equality |
| per-column audit equality | `bandedSparseAccessPaperColumnContract_addressInRange_eq` and `bandedSparseAccessPaperColumnContract_imageNoSpill_eq` compile by `rfl` |
| focused clean bulk tests | for `n = 3`, `kappa = 7`, `j = 8`, both executable checks return `true` by `native_decide` |
| focused nonzero-tail test | for `n = 3`, `kappa = 7`, `j = 136`, the high tail is $1$ before and after the paper image |

### 2026-05-22 Middle Lower Packet: O_D^BS Image Range and Roundtrip

This packet is the next fixed Lean target from the upper-agent objective after
the executable address-range and no-spill blocks compiled.  It is not a
unitarity packet and does not change the active oracle construction.  The paper
source is Guseynov-Huang-Liu 2025, Lemma 1 and Fig. 1-term Robin,
arXiv:2506.20478.

| Field | Contract |
|---|---|
| Paper source equation | $O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n = |r_{si}\rangle^n|i\rangle^n$ |
| Active Lean image | `GHL2025.bandedSparseAccessPaperImage` |
| Active forward matrix | `GHL2025.bandedSparseAccessPaperMatrix` |
| Active dagger matrix | `GHL2025.bandedSparseAccessPaperDaggerMatrix` |
| Legacy helper status | `GHL2025.bandedSparseAccessMatrix` remains helper-only and must not be used as the unitarity target |
| Proof flags | all O_D^BS, dagger-cleanup, no-spill, and block-correctness flags remain `false` |

Allowed write scope for the lower packet is `QuantumBlockEncoding/GHL2025.lean`,
focused tests in `Tests/Basic.lean`, and synchronized proof-map updates.  The
packet should not edit `CircuitSemantics.lean`, `RobinMatrix.lean`, the gate
list, or the legacy helper matrices.

| Target | Lean declaration | Required result | Status |
|---|---|---|---|
| Full image range | `bandedSparseAccessPaperImage_lt_qubitDim_of_address_lt` | if `j < qubitDim (oneTermRobinTotalQubits p)` and `bandedSparseAccessPaperAddress p j < 2^p.n`, then `bandedSparseAccessPaperImage p j < qubitDim (oneTermRobinTotalQubits p)` | proved as executable range block; semantic flags false |
| Fin image bridge | `bandedSparseAccessPaperImageFin`, `bandedSparseAccessPaperImageFin_val` | under the same source-column and n-bit address hypotheses, `bandedSparseAccessPaperImage p j.val` is a finite basis index with the expected value | proved as executable bridge; semantic flags false |
| Forward entry bridge | `bandedSparseAccessPaperMatrix_imageFin_eq_one`, `oneTermRobinGate_O_D_BS_imageFin_eq_one` | the paper matrix and active forward gate have entry $1$ at row `bandedSparseAccessPaperImageFin p j haddr`, column `j` | proved; injectivity and unitarity unproved |
| Dagger entry bridge | `bandedSparseAccessPaperDaggerMatrix_imageFin_eq_one`, `oneTermRobinGate_O_D_BS_dagger_imageFin_eq_one` | the transpose-style paper matrix and active dagger gate have entry $1$ at row `j`, column `bandedSparseAccessPaperImageFin p j haddr` | proved; inverse-on-range and cleanup unproved |
| Row roundtrip | `bandedSparseAccessPaperImage_rowValue_eq` | extracting registers from the image reports the original row value | proved unconditionally for the executable splice |
| Address write roundtrip | `bandedSparseAccessPaperImage_odRegisterValue_eq` | under the n-bit address hypothesis, extracting registers from the image reports O_D register value `bandedSparseAccessPaperAddress p j` | proved as executable register block; semantic flags false |
| High-tail no-spill dependency | `bandedSparseAccessPaperImage_highTail_eq_of_address_lt`, `bandedSparseAccessPaperImageNoSpill_eq_true_of_address_lt`, `bandedSparseAccessPaperImageNoSpill_eq_true_of_two_le` | an n-bit `bandedSparseAccessPaperAddress p j` makes `bandedSparseAccessPaperHighTail p (bandedSparseAccessPaperImage p j) = bandedSparseAccessPaperHighTail p j` | proved as executable block; semantic flag false |
| Entry-safety witness | `oneTermRobinGate_O_D_BS_imageFin_entrySafety` | packages the active forward entry, active dagger entry, row roundtrip, address roundtrip, and no-spill Boolean under the n-bit address hypothesis | proved; inverse uniqueness, cleanup, and unitarity unproved |
| Clean-domain guard | `bandedSparseAccessPaperCleanInput` and `bandedSparseAccessPaperColumnContract.cleanInput` tests | columns with padded-zero value $0$ are the Lemma 1 source domain; non-clean columns remain under `unitaryExtension` | defined skeleton; add only focused tests if needed |
| Proof-flag guard | tests for O_D^BS contract fields and gate unitarity flags | `addressRange`, `noSpill`, `forwardCorrect`, `daggerCleanup`, and both gate unitarity flags remain `false` | required |

If any fixed theorem fails, record the failed theorem statement, attempted route,
remaining Lean goals, and any reusable intermediate lemma under
`proof-attempts/`.  A failed proof must not be replaced by finite sampled tests
unless the tests are explicitly marked as tests rather than semantic proofs.

### 2026-05-23 Middle Packet: O_D^BS Entry-Safety Witness

This packet completed the first cleanup-route proof-DAG package without
claiming cleanup.  The paper anchor is Guseynov-Huang-Liu 2025, Lemma 1 and
Fig. 1-term Robin, arXiv:2506.20478.  The source equation remains:

$$
O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n
=
|r_{si}\rangle^n|i\rangle^n .
$$

| Field | Lean status |
|---|---|
| source-column hypothesis | `j : Fin (qubitDim (oneTermRobinTotalQubits p))` |
| address hypothesis | `bandedSparseAccessPaperAddress p j.val < (1 <<< p.n)` |
| active forward entry | `(oneTermRobinGate_O_D_BS p).matrix (bandedSparseAccessPaperImageFin p j haddr) j = Coeff.rat 1` |
| active dagger entry | `(oneTermRobinGate_O_D_BS_dagger p).matrix j (bandedSparseAccessPaperImageFin p j haddr) = Coeff.rat 1` |
| row roundtrip | extracted row after `bandedSparseAccessPaperImage` equals the original extracted row |
| address roundtrip | extracted O_D register after `bandedSparseAccessPaperImage` equals `bandedSparseAccessPaperAddress p j.val` |
| no-spill | `bandedSparseAccessPaperImageNoSpill p j.val = true` |
| packaged declaration | `oneTermRobinGate_O_D_BS_imageFin_entrySafety` |

This theorem is an executable witness for the inverse-on-range route.  It does
not prove that the forward image is injective, that the transpose-style dagger
has a unique preimage, that post-SWAP cleanup holds, or that either O_D^BS gate
is unitary.  Cycle 9 later found a concrete collision in the current clean
domain, so the next fixed lower target must first correct or refine the
source-domain contract before any uniqueness theorem is attempted.

### 2026-05-23 Middle Lower Packet: Post-SWAP Dagger Cleanup Interface

This packet translates the paper cleanup claim for $(O_D^{BS})^\dagger$ into a
fixed Lean-facing interface.  It does not authorize broad unitarity search or
any proof against the legacy `bandedSparseAccessMatrix` helper.

The packet uses the active Lemma 1 source equation

$$
O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n
=
|r_{si}\rangle^n|i\rangle^n
$$

and the SWAP gate from Fig. 1-term Robin.  For
`source : Fin (qubitDim (oneTermRobinTotalQubits p))` and
`haddr : bandedSparseAccessPaperAddress p source.val < (1 <<< p.n)`, the
compiled witness `oneTermRobinGate_O_D_BS_imageFin_entrySafety` covers the
finite forward image.  After SWAP, the cleanup column is a post-SWAP column
`post`, and the dagger must be justified by a supplied paper-image preimage
`pre`.  Do not assume `pre = source`; after SWAP the system and $O_D^{BS}$
register blocks have exchanged roles.

The fixed lower theorem is:

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

This theorem only states the active dagger-matrix entry once a preimage has
been supplied.  The existence, uniqueness, clean-register shape, and final
`daggerCleanup` proof remain obligations.

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `odbs_post_swap_column` | prove `swapOracleImage p (bandedSparseAccessPaperImage p source.val)` is a finite column under the existing source and n-bit address hypotheses | `swapOracleImage_lt_qubitDim`, source-column range, forward image range | `bandedSparseAccessPaperPostSwapImage_lt_qubitDim_of_address_lt` | dagger entry route, cleanup witness | proved range block; no O_D^BS cleanup flag promotion |
| `odbs_post_swap_registers` | prove the post-SWAP system and O_D register values before choosing a dagger preimage | `swapOracleImage_block1_eq_block2`, `swapOracleImage_block2_eq_block1`, paper-image row/address roundtrip | `bandedSparseAccessPaperPostSwap_rowValue_eq_address`, `bandedSparseAccessPaperPostSwap_odRegisterValue_eq_rowValue` | cleanup-register proof | proved; no inverse/preimage existence claim |
| `odbs_dagger_entry_of_post_swap_preimage` | prove the active dagger entry from a supplied paper-image preimage equality | `bandedSparseAccessPaperDaggerMatrix`, `oneTermRobinGate_O_D_BS_dagger` | `oneTermRobinGate_O_D_BS_dagger_postSwap_entry_of_preimage` | cleanup-register proof | proved as a conditional entry bridge; existence, uniqueness, and cleanup registers remain obligations |
| `odbs_post_swap_cleanup_registers` | for a supplied clean preimage, package the active dagger entry and executable row/address/no-spill checks | source clean-domain audit, SWAP register relations, preimage equality, address range, finite post/pre ranges | `BandedSparseAccessPostSwapCleanup`, `bandedSparseAccessPostSwapCleanup_of_preimage`, `bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate_noRange` | block extraction | no-extra-range conditional witness proved; supplied uniqueness remains an obligation |
| `odbs_post_swap_cleanup_contract` | bundle the dagger entry and cleanup-register facts while keeping semantic flags false | previous post-SWAP blocks plus future uniqueness theorem | planned full cleanup contract; current witness is conditional | final block correctness | obligation; `daggerCleanup.proved` remains false |

Allowed lower write scope is `QuantumBlockEncoding/GHL2025.lean`,
`Tests/Basic.lean`, `proof-attempts/`, and synchronized updates to this ledger
or `conversion-windows/QBE-AUTO-002.md`.  The lower packet must not edit
`CircuitSemantics.lean`, `RobinMatrix.lean`, the circuit gate list, or the
legacy helper matrices.  If the fixed theorem fails, create
`proof-attempts/QBE-AUTO-002-odbs-post-swap-cleanup.md` with the exact failed
statement, attempted route, remaining Lean goals, and reusable lemma
candidates.

The acceptance guard is that both O_D^BS gate unitarity flags,
`(defaultBandedSparseAccessPaperContract p).daggerCleanup.proved`, and all
block-correctness flags remain `false`.

### Completed Lower Packet: Post-SWAP Dagger Entry

The fixed lower target now compiles as
`oneTermRobinGate_O_D_BS_dagger_postSwap_entry_of_preimage`.  It proves only
the active transpose-style dagger entry from a supplied preimage equality
`post.val = bandedSparseAccessPaperImage p pre.val`.  The post-SWAP relation is
kept in the theorem interface for the cleanup proof-DAG, but no existence,
uniqueness, register cleanup, or `daggerCleanup` flag was
proved.

### Completed Middle Packet: Post-SWAP Register Equations

This packet proves the register equations requested before reverse-index or
preimage search.  For any source column `j`, applying `swapOracleImage` to
`bandedSparseAccessPaperImage p j` exchanges the two n-bit blocks that Lemma 1
uses:

| Register equation | Lean declaration | Status |
|---|---|---|
| low/system register after SWAP is the paper address $r_{si}$ | `bandedSparseAccessPaperPostSwap_rowValue_eq_address` | proved under the explicit n-bit address hypothesis |
| high/O_D register after SWAP is the original row register | `bandedSparseAccessPaperPostSwap_odRegisterValue_eq_rowValue` | proved |
| symmetric SWAP block equation | `swapOracleImage_block2_eq_block1` | proved as a reusable bit-slice lemma |

These are register-position facts only.  They do not prove that a clean
paper-image preimage exists after SWAP, that it is unique, that
`(O_D^{BS})^\dagger` cleans the padded sparse-index register, or that SWAP or
either O_D^BS gate is unitary.

### Completed Lower Packet: Reverse-Index Preimage Candidate Audit

This packet adds the first Lean-facing candidate for the missing clean
post-SWAP preimage.  The definition
`robinSparseReverseColumnIndex n target row` computes the sparse index that
would make `row` address `target` in the executable Robin sparse-column map.
The Boolean `robinSparseReverseColumnRoundtripCheck n sparseBound` scans a
finite row/sparse-index domain for the roundtrip
`row -> r_si -> row`.

The post-SWAP candidate is
`bandedSparseAccessPaperPostSwapPreimageCandidate p source`.  It takes the
post-SWAP column `swapOracleImage p (bandedSparseAccessPaperImage p source)`,
preserves its low row block and high-tail bits, and splices in a clean
`O_D^BS` register built from the reverse sparse index.  The audit Boolean
`bandedSparseAccessPaperPostSwapPreimageCandidateChecks p source` checks that
this candidate maps to the post-SWAP column by the active paper-image skeleton,
is clean, and has an n-bit address.

`Tests/Basic.lean` now proves:

| Check | Status |
|---|---|
| `robinSparseReverseColumnRoundtripCheck 3 8 = true` | proved by `native_decide` |
| `robinSparseReverseColumnRoundtripCheck 4 8 = true` | proved by `native_decide` |
| `robinSparseReverseColumnIndex_lt_eight_of_columnMap` | proved for $3 \le n$, $s < 8$, and $i < 2^n$ |
| source column `8` at $n=3,\kappa=7$ has candidate preimage `68` | proved by `native_decide` |
| every finite source column for $n=3,\kappa=7$ passes `bandedSparseAccessPaperPostSwapPreimageCandidateChecks` | proved by `native_decide` |
| `bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_cleanSource` | proved for finite clean source columns with explicit $3 \le n$, $\kappa=7$, and $\lceil\log_2\kappa\rceil=3$ hypotheses |

These checks are executable evidence plus a clean-source Boolean theorem for
the inverse-on-range proof route.  They do not prove uniqueness, do not prove
general cleanup, and do not change
`(defaultBandedSparseAccessPaperContract p).daggerCleanup.proved` or either
O_D^BS gate unitarity flag.

### Completed Lower Packet: Block Projection and Normalizer Audit

This packet validates the fixed Lean target for the final one-term
block-extraction statement.  It did not prove block correctness or promote any
semantic flag.

| Item | Required Lean status |
|---|---|
| full circuit matrix | `oneTermRobinCircuitSemantics n`.matrix is `evalGateMatrices (oneTermRobinGateMatrixPlaceholders (oneTermParameters n))` |
| block full-space matrix | `oneTermRobinBlockExtractionTarget n`.unitaryMatrix is the cast circuit product from `oneTermRobinCircuitSemantics n` |
| projection convention | `oneTermRobinBlockExtractionTarget n`.blockMatrix is `signalSystemBlockProjection` at `signalIndex` |
| projection indices | `signalSystemBlockRowIndex` and `signalSystemBlockColIndex` name the row and column offsets used by `signalSystemBlockProjection` |
| signal index | `oneTermRobinBlockExtractionTarget n`.signalIndex.val = 0 |
| target matrix | `oneTermRobinBlockExtractionTarget n`.targetMatrix = `robinDerivativeMatrix n` |
| normalizer | `oneTermRobinBlockExtractionTarget n`.normalizer = `GHL2025.oneTermRobinNormalizer` |
| unproved block flags | `.blockProjection.proved = false` and `.blockCorrect.proved = false` |
| upstream cleanup flag | `defaultBandedSparseAccessPaperContract (oneTermParameters n)`.daggerCleanup.proved = false |

The new compiled tests additionally pin
`defaultOneTermRobinCircuitBlockClaim n`.target to
`oneTermRobinBlockExtractionTarget n`, so downstream proof work cannot silently
replace the signal-index-zero convention, the Robin target matrix, or the
normalizer $N_DN_f\kappa$.  The 2026-05-23 lower packet also added named
generic row and column index helpers in `CircuitSemantics.lean`; these helpers
make the backend convention explicit and do not change any block-extraction
obligation flag.

Full entry-level normalization of the composed $n=3$ product remains deferred
because the product is an $8192 \times 8192$ symbolic matrix.

### 2026-05-23 Lower Packet: O_D^BS No-Lower-Proof-Search Guard

This packet added the named theorem
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsNoLowerProofSearch`.
The theorem is source-contract capture only.  It ties
`lowerProofSearchAllowed = false` in the theorem-level route to the direct and
full-wrapper unused-branch image-rule slots still having
`proposedImageIndex = none`, and it keeps block correctness plus
`forwardCorrect`, `daggerCleanup`, and `unitaryExtension` false.

The packet did not change `bandedSparseAccessPaperImage`, either active
O_D^BS gate matrix, the signal-index-zero target, the normalizer, or any
semantic proof flag.  The focused test in `Tests/Basic.lean` consumes the new
guard for arbitrary `n` and source column `j`.

### 2026-05-23 Middle Packet: Block-Projection Index Audit

This packet fixes the next allowed lower-agent target after the SWAP
permutation bridge.  It is not a correctness proof.  It only audits that the
Lean block target still matches the one-term theorem's signal-index-zero block
statement.

Definitions before the target:

| Name | Lean declaration | Required state |
|---|---|---|
| system dimension $N$ | `gridSize n` | reused; no duplicate dimension convention |
| signal dimension $S$ | `qubitDim (GHL2025.effectiveRobinSignalQubits (oneTermParameters n))` | reused from the register partition |
| dimension split | `Examples.RobinHeat.oneTermRobinCircuitDimCompat n` | proved |
| full matrix | `(Examples.RobinHeat.oneTermRobinCircuitSemantics n).matrix` | `evalGateMatrices` over the active seven-gate list |
| projection function | `signalSystemBlockProjection S N N` | existing backend convention |
| row index function | `signalSystemBlockRowIndex N signalIndex.val i` | row offset for the selected signal block |
| column index function | `signalSystemBlockColIndex N signalIndex.val j` | column offset for the selected signal block |
| signal index | `(Examples.RobinHeat.oneTermRobinBlockExtractionTarget n).signalIndex.val` | `0` |
| target matrix | `(Examples.RobinHeat.oneTermRobinBlockExtractionTarget n).targetMatrix` | `Examples.RobinHeat.robinDerivativeMatrix n` |
| normalizer | `(Examples.RobinHeat.oneTermRobinBlockExtractionTarget n).normalizer` | `GHL2025.oneTermRobinNormalizer` |

Source-dependency classification:

| Step | Classification | Required action |
|---|---|---|
| block-index convention | `internal-paper-step` | pin the index convention with definitional bridges and tests |
| dimension arithmetic | `classical-lean-lemma` | reuse `oneTermRobinCircuitDimCompat`; do not introduce a second layout |
| final block equality | `internal-paper-step` with blocked oracle/composition dependencies | leave `blockProjection.proved = false` and `blockCorrect.proved = false` |
| O_D^BS cleanup dependency | `source-contract-gap` with the prior PDE sparse-access primitive recorded as `external-cited-result` | no lower proof search for injectivity, cleanup, unitarity, or final block extraction |

Lower packet:

| Field | Contract |
|---|---|
| fixed target | `Examples.RobinHeat.oneTermRobinBlockExtractionTarget` and `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute` |
| allowed edits | focused `rfl` bridge lemmas or tests in `QuantumBlockEncoding/RobinMatrix.lean` and `Tests/Basic.lean`; synchronized notes in this ledger or `conversion-windows/QBE-AUTO-002.md` |
| declarations to reuse | `oneTermRobinCircuitSemantics`, `oneTermRobinBlockExtractionTarget`, `defaultOneTermRobinCircuitBlockClaim`, `oneTermRobinBlockEncodingProofRoute`, `oneTermRobinBlockEncodingProofRoute_flags_false`, `oneTermRobinBlockEncodingProofRoute_odbsSourceBlockers`, `oneTermRobinBlockEncodingProofRoute_priorPDESourceTranscript` |
| forbidden edits | no active O_D^BS matrix rewrite, no O_f analytic closure, no LCU closure, no signal-index change, no target-matrix change, and no normalizer change |
| false flags to preserve | block projection, block correctness, O_D^BS forward correctness, O_D^BS dagger cleanup, O_D^BS unitary extension, O_f amplitude correctness, and LCU correctness |
| acceptance | `python3 tools/qbe.py check`, `lake build`, `lake build Tests`, and the forbidden-pattern scan pass |

Current audit result: the route and tests already pin the requested convention.
The 2026-05-23 lower packet added named generic row and column index helpers
plus two direct tests for the offsets.  Future lower work must not treat this
packet as permission to prove the block equation while O_D^BS, O_f, and LCU
dependencies remain open.

### 2026-05-22 Block-Projection Audit Tests

| Test | Parameters | Method | Status |
|---|---|---|---|
| Circuit matrix is the 7-gate product | general `n` | `rfl` | proved |
| Extraction target full matrix is the cast circuit product | general `n` | `rfl` | proved |
| Block matrix is `signalSystemBlockProjection` at the target signal index | general `n` | `rfl` | proved |
| Row index helper uses `signalIdx * rows + i` | `rows=2`, `signalIdx=1`, `i=1` | `rfl` | proved |
| Column index helper uses `signalIdx * cols + j` | `cols=3`, `signalIdx=1`, `j=2` | `rfl` | proved |
| Target matrix is `robinDerivativeMatrix n` | general `n` | `rfl` | proved |
| Normalizer is `GHL2025.oneTermRobinNormalizer` | general `n` | `rfl` | proved |
| Signal index value is `0` | general `n` | `rfl` | proved |
| Default block claim target is `oneTermRobinBlockExtractionTarget n` | general `n` | `rfl` | proved |
| Default block claim block correctness remains false | general `n` | `rfl` | proved |
| Target block projection and block correctness remain false | general `n` | `rfl` | proved |
| Upstream `O_D^BS` dagger cleanup remains false | general `n` | `rfl` | proved |

| Declaration | Role | Status |
|---|---|---|
| `BandedSparseAccessPaperContract` | faithful Lemma 1 source contract | defined; correctness fields unproved |
| `defaultBandedSparseAccessPaperContract` | instantiates the contract for one-term Robin parameters | defined; width and cleanup obligations explicit |
| `BandedSparseAccessPaperRegisters` | extracted O_D register, padded-zero field, sparse index, and row value | defined skeleton |
| `bandedSparseAccessPaperRegisters` | executable register extraction for Lemma 1 | defined skeleton; concrete tests pass |
| `bandedSparseAccessPaperAddress` | one-term Robin $r_{si}$ value from extracted sparse index and row | defined skeleton; correctness unproved |
| `bandedSparseAccessPaperImage` | preserves row register and replaces O_D register by $r_{si}$ | active image skeleton; correctness unproved |
| `bandedSparseAccessPaperMatrix` | matrix entries from `bandedSparseAccessPaperImage` | active forward gate matrix skeleton |
| `bandedSparseAccessPaperDaggerMatrix` | transpose-style entries from `bandedSparseAccessPaperImage` | active dagger gate matrix skeleton |
| `robinSparseColumnMap` | column mapping col(s,i) for Robin stencil | implemented; helper only |
| `bandedSparseAccessMatrix` | legacy sparse-access helper | implemented; not the active paper oracle |
| updated `oneTermRobinGate_O_D_BS` | uses paper-image matrix skeleton | updated; do not promote unitarity |
| `bandedSparseAccessDaggerMatrix` | transpose-style matrix for interim map | implemented; faithful inverse blocked |
| updated `oneTermRobinGate_O_D_BS_dagger` | uses paper-image dagger skeleton | updated; do not promote unitarity |

### O_D^BS Matrix Obligations

| Obligation | Status |
|---|---|
| Bulk row column mapping col(s,i) = i-2+s | tested (native_decide) |
| Left boundary rows (i=0: 3 entries, i=1: 4 entries) | tested (native_decide) |
| Right boundary rows (i=N-2, i=N-1) | tested (native_decide) |
| Unused sparse indices → identity | tested (native_decide) |
| Dagger matrix entry relation | tested on concrete entries; full inverse proof blocked |
| Unitarity of O_D^BS | unproved (`unitary.proved := false`) |
| Unitarity of (O_D^BS)^† | unproved (`unitary.proved := false`) |
| No promoted obligations from cycle 3 | verified |

Boundary non-injectivity witness for the current simplified Lean column-map contract:
`robinSparseColumnMap 3 0 0 = robinSparseColumnMap 3 0 1 =
robinSparseColumnMap 3 0 2 = 0`.  This prevents the permutation-matrix proof
route for the simplified helper.  It should now be treated as a reviewer
finding that the Lean contract must be reconciled with the paper's padded
sparse-index oracle, not as a claim that GHL's construction is missing.

### Cycle 4 Tests Added

| Test | Parameters | Method | Status |
|---|---|---|---|
| Bulk i=4, s=0 → col=2 | n=3, κ=7 | native_decide | proved |
| Bulk i=4, s=4 → col=6 | n=3, κ=7 | native_decide | proved |
| Diagonal i=3, s=2 → col=3 (identity) | n=3, κ=7 | native_decide | proved |
| Boundary i=0, s=0 → identity | n=3, κ=7 | native_decide | proved |
| Boundary i=0, s=5 unused → identity | n=3, κ=7 | native_decide | proved |
| Right boundary i=7, s=0 → col=5 | n=3, κ=7 | native_decide | proved |
| Dagger transpose (8,4) = 1 | n=3, κ=7 | native_decide | proved |
| O_D^BS unitary.proved = false | n=3, κ=7 | rfl | proved |
| (O_D^BS)^† unitary.proved = false | n=3, κ=7 | rfl | proved |
| Placeholder match with honest O_D^BS | general p | theorem | proved |

### Run 03 Cycle 1 Paper-Image and Matrix Tests

| Test | Parameters | Method | Status |
|---|---|---|---|
| Extract row value from compound index 8 | n=3, κ=7 | native_decide | proved |
| Extract sparse index from compound index 8 | n=3, κ=7 | native_decide | proved |
| Compute paper address $r_{0,4}=2$ | n=3, κ=7 | native_decide | proved |
| Bulk paper image 8 → 40 | n=3, κ=7 | native_decide | proved |
| Bulk image preserves row 4 | n=3, κ=7 | native_decide | proved |
| Bulk image replaces O_D register by 2 | n=3, κ=7 | native_decide | proved |
| Boundary paper image 14 → 94 | n=3, κ=7 | native_decide | proved |
| Boundary image preserves row 7 | n=3, κ=7 | native_decide | proved |
| Boundary image replaces O_D register by 5 | n=3, κ=7 | native_decide | proved |
| Bulk paper matrix entry M(40,8) = 1 | n=3, κ=7 | native_decide | proved |
| Bulk paper matrix excludes interim helper entry M(4,8) = 0 | n=3, κ=7 | native_decide | proved |
| Boundary paper matrix entry M(94,14) = 1 | n=3, κ=7 | native_decide | proved |

### Run 03 Cycle 2 Active Gate Tests

| Test | Parameters | Method | Status |
|---|---|---|---|
| Active O_D^BS gate entry M(40,8) = 1 | n=3, κ=7 | native_decide | proved |
| Active O_D^BS gate excludes old helper entry M(4,8) = 0 | n=3, κ=7 | native_decide | proved |
| Paper-image dagger matrix entry M^\dagger(8,40) = 1 | n=3, κ=7 | native_decide | proved |
| Active dagger gate entry M^\dagger(8,40) = 1 | n=3, κ=7 | native_decide | proved |
| (O_D^BS)^dagger unitary.proved = false | general p | rfl | proved |
| Placeholder match with active paper-image gate pair | general p | theorem | proved |

## Cycle 5: Sparse Amplitude Data Layer

| Declaration | Role | Status |
|---|---|---|
| `robinSparseAmplitudeValue` | s-th nonzero stencil coefficient per row, as Coeff | implemented (cycle 5) |

### Cycle 5 Obligations

| Obligation | Status |
|---|---|
| Bulk row amplitudes match stencil coefficients | tested (native_decide) |
| All 4 boundary row amplitudes match matrix entries with symbolic correction terms | tested (native_decide) |
| Unused sparse indices return Coeff.rat 0 | tested (native_decide) |
| Coherence: amplitude = matrix entry at column from robinSparseColumnMap | tested (native_decide, 5 instances covering bulk + all boundary types) |
| No promoted obligations | verified |

### Cycle 5 Tests Added

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

## Cycle 6 and 2026-05-22: O_f Function Oracle Contract

The stale Cycle 6 transcript said `functionOracleMatrix` used derivative
amplitude data.  That is no longer the active Lean contract.  The current
declaration extracts the system grid index from bits $[1,1+n)$ and places the
symbolic function value `robinFunctionValue p.n sysVal` on the diagonal.

The paper source for this gate is the function oracle $O_f$ in the
Guseynov-Huang-Liu 2025 theorem `Amplitude-oracle for piece-wise polynomial
function`, the coordinate-oracle equation, and Fig. 1-term Robin,
arXiv:2506.20478.  The paper normalizes the function values by $N_f$, and the
one-term theorem uses $\alpha=N_DN_f\kappa$.  The clean
workspace branch has the form

$$
  |0\rangle^{m_f}|i\rangle
  \mapsto
  \frac{f(x_i)}{N_f}|0\rangle^{m_f}|i\rangle
  + |\mathrm{orth}_f(i)\rangle .
$$

The legacy Lean diagonal matrix records the function-value data path.  Lean
now also records the paper clean-branch target as source-contract data through
`FunctionOraclePaperRegisters`, `functionOraclePaperRegisters`,
`functionOracleNormalizedValue`, `FunctionOraclePaperImage`, and
`functionOraclePaperImage`.  The active gate now uses
`functionOraclePaperMatrix`, which for clean $m_f$ input columns places the
clean-branch amplitude `functionOracleNormalizedValue p i` at the clean $m_f$
row, sets other clean-workspace output rows to zero, and fills non-clean output
rows with symbolic orthogonal-completion entries.  For non-clean input columns,
all entries remain symbolic.  This is a Phase 1 skeleton, not a proof of the
coordinate-oracle theorem: amplitude correctness, the $N_f$ bound, orthogonality, and
unitarity remain explicit false obligations.

| Declaration | Role | Status |
|---|---|---|
| `robinFunctionValue` | symbolic grid data $f(x_i)$ | defined |
| `functionOracleMatrix` | diagonal Phase 1 helper using `robinFunctionValue p.n sysVal` | implemented; not the full coordinate-oracle paper image |
| `FunctionOraclePaperRegisters`, `functionOraclePaperRegisters` | paper register extractor for system and $m_f$ workspace fields | defined skeleton; concrete tests pass |
| `functionOracleNormalizedValue` | symbolic clean-branch amplitude $f(x_i)/N_f$ using `N_f_inv` | defined; division and bound unproved |
| `FunctionOraclePaperImage`, `functionOraclePaperImage` | paper image record for clean branch, orthogonal component, and false obligations | defined contract; proof flags false |
| `functionOracleOrthogonalEntry` | symbolic placeholder for unresolved non-clean workspace completion entries | defined; orthogonality and unitarity unproved |
| `functionOraclePaperMatrix` | Phase 1 matrix skeleton from the paper image record | active skeleton; clean-input branch wired and completion unproved |
| `oneTermRobinGate_O_f` | active gate record for O_f | wired to `functionOraclePaperMatrix`; `unitary.proved = false` |
| `FunctionOracleContract.normalizerBound` | records $N_f$ for the function oracle | recorded as `Coeff.symbol "N_f"` in the Robin default composition |
| `FunctionOracleContract.amplitudeCorrect` | paper amplitude relation $f(x_i)/N_f$ plus workspace correctness | unproved; must stay false |
| `RobinProofObligations.functionOracleCorrect` | theorem-level O_f correctness obligation | unproved; must stay false |

### O_f Source-Contract Audit

| Field / obligation | Paper source | Lean declaration | Status |
|---|---|---|---|
| system grid register $i$ | Theorem `Amplitude-oracle for piece-wise polynomial function` and Fig. 1-term Robin, arXiv:2506.20478 | `functionOraclePaperRegisters`; also extraction inside `functionOracleMatrix` | defined skeleton; concrete tests pass |
| clean function workspace $|0\rangle^{m_f}$ | coordinate-oracle equation and theorem resource statement, arXiv:2506.20478 | `FunctionOraclePaperRegisters.mfWorkspaceValue` and `cleanWorkspace` | width recorded; action and cleanup unproved |
| function value $f(x_i)$ | Theorem `Amplitude-oracle for piece-wise polynomial function`, arXiv:2506.20478 | `robinFunctionValue` | symbolic data source defined |
| normalizer $N_f$ | Theorem `Amplitude-oracle for piece-wise polynomial function` and theorem normalizer, arXiv:2506.20478 | `oneTermRobinNormalizer`, `FunctionOracleContract.normalizerBound` | recorded; bound unproved |
| cited amplitude-oracle theorem | Theorem `Amplitude-oracle for piece-wise polynomial function`, Eq. `coordinate oracle`, and cited arXiv:2411.01131 | `FunctionOracleExternalAmplitudeSourceContract`, `functionOracleExternalAmplitudeSourceContract`, `functionOracleExternalAmplitudeSourceContract_flags_false` | typed source transcript; resource claim and analytic closure flags false |
| normalized clean-branch amplitude $f(x_i)/N_f$ | Theorem `Amplitude-oracle for piece-wise polynomial function` and coordinate-oracle equation, arXiv:2506.20478 | `functionOracleNormalizedValue`, `FunctionOraclePaperImage.cleanBranchAmplitude`; `FunctionOracleContract.amplitudeCorrect` | typed contract defined; proof false |
| paper-image matrix skeleton | Theorem `Amplitude-oracle for piece-wise polynomial function` and coordinate-oracle equation, arXiv:2506.20478 | `functionOraclePaperMatrix`, `oneTermRobinGate_O_f` | active matrix uses clean-input branch and symbolic non-clean completion; proof flags false |
| orthogonal branch | coordinate-oracle equation, arXiv:2506.20478 | `FunctionOraclePaperImage.orthogonalComponent`, `functionOracleOrthogonalEntry`, `orthogonalComponentCorrect` | component label and symbolic rows recorded; orthogonality proof false |
| unitarity / clean workspace | Theorem `Amplitude-oracle for piece-wise polynomial function`, arXiv:2506.20478 | `oneTermRobinGate_O_f p`.unitary and future cleanup lemma | unproved (`proved := false`) |

Source-dependency classification: `external-cited-result`.  The local paper
source states Theorem `Amplitude-oracle for piece-wise polynomial function`,
labels the displayed equation as `coordinate oracle`, and cites Guseynov--Liu,
"Efficient explicit circuit for quantum state preparation of piece-wise
continuous functions", arXiv:2411.01131.  QBE records this dependency in
`research-wiki/cited-results/GHL2025.md` as `GL2024.Thm5.AmplitudeOracle` with
status `obligation`.  The cited theorem is a source anchor for the transcript
only; it does not close nonzero $N_f$, division semantics, the normalizer bound,
orthogonality, unitarity, or theorem-level amplitude correctness.

### O_f Proof-DAG

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `of_extract_registers` | extract the system grid index, $m_f$ workspace value, and all non-$m_f$ bits from the compound index | register layout | `FunctionOraclePaperRegisters`, `functionOraclePaperRegisters` | paper image, tests | O_f | defined skeleton; concrete tests pass |
| `of_function_values` | provide symbolic values $f(x_i)$ | `of_extract_registers` | `robinFunctionValue` | normalized amplitude, final target | O_f | defined |
| `of_normalized_value` | record the clean-branch amplitude $f(x_i)/N_f$ without proving division or bounds | `of_function_values`, `FunctionOracleContract.normalizerBound` | `functionOracleNormalizedValue` | paper image, amplitude relation | O_f | defined symbolic contract; proof false |
| `of_paper_image` | record $|0\rangle^{m_f}|i\rangle \mapsto (f(x_i)/N_f)|0\rangle^{m_f}|i\rangle + |\mathrm{orth}_f(i)\rangle$ | `of_extract_registers`, `of_normalized_value` | `FunctionOraclePaperImage`, `functionOraclePaperImage` | paper matrix skeleton, block extraction | O_f | defined contract; proof flags false |
| `of_paper_matrix` | expose the clean-branch amplitude for clean input columns and keep symbolic non-clean input/completion entries unresolved | `of_paper_image`, `of_orthogonal_component` | `functionOracleOrthogonalEntry`, `functionOraclePaperMatrix`, `oneTermRobinGate_O_f` | circuit product, block extraction | O_f | active skeleton wired; completion and unitarity unproved |
| `of_external_amplitude_source` | record GHL2025 Theorem 5/Eq. `coordinate oracle`, cited arXiv:2411.01131, the $N_f$ symbol, and the source-side false obligations | source audit row `GL2024.Thm5.AmplitudeOracle` | `FunctionOracleExternalAmplitudeSourceContract`, `functionOracleExternalAmplitudeSourceContract`, `functionOracleExternalAmplitudeSourceContract_sourceAnchor`, `functionOracleExternalAmplitudeSourceContract_flags_false` | amplitude route, cited-result audit | O_f | typed transcript compiled; resource claim and all closure flags false |
| `of_nf_amplitude_route` | package $f(x_i)$, $N_f$, the symbolic normalized amplitude, clean-branch reuse, the Theorem 5/Eq. `coordinate oracle` source anchor, and theorem-level false obligations | `of_paper_image`, `of_normalized_value`, `of_normalizer_bound`, `of_external_amplitude_source`, source audit row `GL2024.Thm5.AmplitudeOracle` | `FunctionOracleAmplitudeProofRoute`, `functionOracleAmplitudeProofRoute`, `functionOracleAmplitudeProofRoute_sourceAnchor`, `functionOracleAmplitudeProofRoute_externalSourceContract`, `functionOracleAmplitudeProofRoute_flags_false` | amplitude contract, final theorem audit | O_f | typed route compiled; nonzero $N_f$, division, normalizer bound, orthogonality, unitary completion, and theorem amplitude correctness false |
| `of_orthogonal_component` | state zero overlap of the orthogonal branch with the clean workspace and preserve the system label | `of_paper_image` | `FunctionOraclePaperImage.orthogonalComponentCorrect`, `systemPreserved`, `cleanWorkspaceBranch` | amplitude correctness, unitarity | O_f | recorded; proof false |
| `of_normalizer_bound` | state and prove the $N_f$ bound needed for amplitudes | future coefficient/function semantics | `FunctionOracleContract.normalizerBound`, future bound theorem | amplitude relation, unitarity | O_f | recorded; proof missing |
| `of_diagonal_helper_isolation` | keep `functionOracleMatrix` helper-only so function-value data tests are not mistaken for the active paper oracle | `of_paper_image`, current matrix tests | `functionOracleMatrix`, `FunctionOraclePaperImage.diagonalHelperIsolation` | source-contract audit | O_f | helper isolated; proof flag false |
| `of_amplitude_contract` | prove the paper amplitude relation and clean $m_f$ workspace | `of_nf_amplitude_route`, `of_orthogonal_component`, `of_normalizer_bound` | `FunctionOracleContract.amplitudeCorrect`, `RobinProofObligations.functionOracleCorrect` | final block extraction | O_f | unproved |

### Completed Lower Packet: O_f Paper Image Contract

The packet introduced the paper-register and paper-image source contract for
O_f and, at that time, kept the active gate wired to the helper-only diagonal
matrix.  The
write scope was `QuantumBlockEncoding/GHL2025.lean` and focused tests in
`Tests/Basic.lean`.  It did not edit SWAP, O_D^BS, O_DT^S, Ry_boundary, the
circuit product, or block extraction.  It did not promote any O_f proof flag.

Declarations now present:

| Declaration | Required content |
|---|---|
| `FunctionOraclePaperRegisters` | `systemValue`, `mfWorkspaceValue`, non-$m_f$ preserved value, and a clean-workspace predicate or boolean |
| `functionOraclePaperRegisters` | extracts system bits $[1,1+n)$ and $m_f$ bits starting at `robinIndicatorBitPosition p + 1` |
| `functionOracleNormalizedValue` | records `robinFunctionValue p.n i` multiplied by a symbolic reciprocal of $N_f$ |
| `FunctionOraclePaperImage` | records the clean branch, normalized amplitude, orthogonal component, and false obligations |
| `functionOraclePaperImage` | builds the per-column paper-image contract from `functionOraclePaperRegisters` |

The tests pin one clean-workspace example for `n=3`, `kappa=7`, system value
`2`, the normalized-value expression, clean-system preservation, and all new
false proof flags.  `functionOracleMatrix` is explicitly marked helper-only
as the historical data helper.

### Completed Middle Packet: O_f Paper Matrix Rewire

This packet added `functionOracleOrthogonalEntry` and
`functionOraclePaperMatrix`, then rewired `oneTermRobinGate_O_f` to the paper
matrix skeleton.  The legacy `functionOracleMatrix` remains available as a data
helper for `robinFunctionValue`, but it is no longer the active O_f gate.

The clean branch is now matrix-level data:

$$
  M_f[\mathrm{clean}(j),j]
  =
  \texttt{functionOracleNormalizedValue}\;p\;i
  =
  f(x_i)N_f^{-1}.
$$

Rows with clean $m_f$ workspace outside the selected clean branch are zero.
Rows with non-clean $m_f$ workspace carry symbolic
`functionOracleOrthogonalEntry` entries.  Those symbols are not a proof of the
orthogonal completion.  The obligations
`normalizedAmplitudeCorrect`, `orthogonalComponentCorrect`, `normalizerBound`,
`unitaryCompletion`, `FunctionOracleContract.amplitudeCorrect`, and
`oneTermRobinGate_O_f.unitary` remain false.

### Cycle 9 and 2026-05-22 O_f Fix Tests

| Test | Parameters | Method | Status |
|---|---|---|---|
| Diagonal j=36 (sysVal=2) = f_3_2 | n=3, κ=7 | native_decide | proved |
| Diagonal j=0 (sysVal=0) = f_3_0 | n=3, κ=7 | native_decide | proved |
| Diagonal j=4 (sysVal=2) = f_3_2 (same as j=36) | n=3, κ=7 | native_decide | proved |
| Off-diagonal M(0,1) = 0 | n=3, κ=7 | native_decide | proved |
| Off-diagonal M(36,0) = 0 | n=3, κ=7 | native_decide | proved |
| Diagonal j=60 (sysVal=6) = f_3_6 | n=3, κ=7 | native_decide | proved |
| Diagonal j=14 (sysVal=7) = f_3_7 | n=3, κ=7 | native_decide | proved |
| robinFunctionValue 3 0 = f_3_0 | n=3 | native_decide | proved |
| robinFunctionValue 3 2 = f_3_2 | n=3 | native_decide | proved |
| robinFunctionValue 3 7 = f_3_7 | n=3 | native_decide | proved |
| O_f unitary.proved = false | general p | rfl | proved |
| Active O_f matrix is `functionOraclePaperMatrix p` | general p | rfl | proved |
| Diagonal O_f entries equal `robinFunctionValue p.n sysVal` for extracted `sysVal` | general p, j | simp | proved |
| O_f off-diagonal entries are zero when `i.val != j.val` | general p, i, j | simp | proved |
| Robin default function normalizer is `Coeff.symbol "N_f"` | general n | rfl | proved |
| Robin default O_f `amplitudeCorrect.proved = false` | general n | rfl | proved |
| Placeholder match with honest O_f | general p | theorem | proved |
| `functionOraclePaperRegisters p 36` extracts system value 2, clean workspace 0, non-$m_f$ value 36, and `cleanWorkspace = true` | n=3, κ=7 | native_decide | proved |
| nonclean `m_f` workspace extraction returns value 3 | n=3, κ=7 | native_decide | proved |
| `functionOracleNormalizedValue p 2` is `robinFunctionValue 3 2 * N_f_inv` | n=3, κ=7 | native_decide | proved |
| `functionOraclePaperImage p 36` preserves system value, clean basis index, workspace value, and clean-branch amplitude | n=3, κ=7 | native_decide | proved |
| `(functionOraclePaperImage p 36).systemPreserved` and `.cleanWorkspaceBranch` are true | n=3, κ=7 | native_decide | proved |
| all five `functionOraclePaperImage p j` obligations have `proved = false` | general p, j | rfl | proved |
| `functionOraclePaperImage_inputRegisters_eq` links the image record to `functionOraclePaperRegisters` | general p, j | theorem reuse | proved |
| `functionOraclePaperImage_cleanBranchBasisIndex_eq` links the clean branch basis to the non-$m_f$ basis index | general p, j | theorem reuse | proved |
| `functionOraclePaperImage_cleanBranchSystemValue_eq` links the clean branch system value to the extracted system value | general p, j | theorem reuse | proved |
| `functionOraclePaperImage_cleanBranchWorkspaceValue_eq` records zero clean-branch $m_f$ workspace | general p, j | theorem reuse | proved |
| `functionOraclePaperImage_cleanBranchAmplitude_eq` links the clean branch amplitude to `functionOracleNormalizedValue` at the extracted system value | general p, j | theorem reuse | proved |
| `functionOraclePaperImage_cleanWorkspaceBranch_eq` links the image clean-workspace flag to the extractor flag | general p, j | theorem reuse | proved |
| `functionOraclePaperMatrix p 36 36 = f_3_2 * N_f_inv` | n=3, κ=7 | native_decide | proved |
| active O_f gate exposes the same clean-branch entry | n=3, κ=7 | native_decide | proved |
| clean-workspace off-branch row 4 has zero entry against column 36 | n=3, κ=7 | native_decide | proved |
| non-clean row 772 against column 36 carries `orth_f_entry_3_2_772_36` | n=3, κ=7 | native_decide | proved |
| `functionOraclePaperMatrix_cleanBranch_entry` bridges clean-input matrix entry to `FunctionOraclePaperImage.cleanBranchAmplitude` | general p, i, j | theorem reuse | proved |
| `functionOraclePaperMatrix_cleanWorkspace_offBranch_zero` bridges non-branch clean-workspace rows to zero for clean input columns | general p, i, j | theorem reuse | proved |
| non-clean input column 772 at its clean-branch basis row 4 carries `orth_f_entry_3_2_4_772` | n=3, κ=7 | native_decide | proved |
| `functionOraclePaperMatrix_nonCleanInput_entry` bridges every non-clean input column to the symbolic completion branch | general p, i, j | theorem reuse | proved |
| `functionOracleExternalAmplitudeSourceContract_sourceAnchor` records GHL2025 Theorem 5, Eq. `coordinate oracle`, and the cited source arXiv:2411.01131 | global source contract | theorem reuse | proved |
| `functionOracleExternalAmplitudeSourceContract_flags_false` keeps the external theorem transcript and closure booleans false | global source contract | theorem reuse | proved |
| `functionOracleAmplitudeProofRoute_sourceAnchor` records GHL2025 Theorem 5, Eq. `coordinate oracle`, and the cited source arXiv:2411.01131 | general p, j | theorem reuse | proved |
| `functionOracleAmplitudeProofRoute_sourceFunctionValue` links the route to `robinFunctionValue` at the extracted system value | general p, j | theorem reuse | proved |
| `functionOracleAmplitudeProofRoute_normalizedAmplitude` links the route to `functionOracleNormalizedValue` at the extracted system value | general p, j | theorem reuse | proved |
| `functionOracleAmplitudeProofRoute_normalizerNf` records the $N_f$ symbol | general p, j | theorem reuse | proved |
| `functionOracleAmplitudeProofRoute_paperImage` and `functionOracleAmplitudeProofRoute_obligations_reuse_paperImage` reuse the paper-image data and obligations | general p, j | theorem reuse | proved |
| `functionOracleAmplitudeProofRoute_externalSourceContract` reuses the external source transcript for the source anchor, $N_f$ symbol, formula string, nonzero-normalizer obligation, division obligation, and theorem-amplitude obligation | general p, j | theorem reuse | proved |
| `functionOracleAmplitudeProofRoute_flags_false` keeps every O_f amplitude-route obligation false | general p, j | theorem reuse | proved |
| route `theoremNormalizer` equals the Robin default function-oracle normalizer | general n | rfl | proved |
| route for column 36 records `f_3_2` and `f_3_2 * N_f_inv` | n=3, κ=7 | native_decide | proved |

### Completed Lower Packet: O_f Bridge Validation

The lower bridge packet added only definitional `rfl` lemmas for the existing
`functionOraclePaperImage` contract and corresponding tests.  The lemmas expose
that the image record is built from `functionOraclePaperRegisters`, that the
clean branch uses the non-$m_f$ basis index and zero workspace value, and that
the clean branch amplitude is `functionOracleNormalizedValue` evaluated at the
extracted system value.  This historical packet did not rewire
`oneTermRobinGate_O_f`.  The later middle packet above rewired the gate to
`functionOraclePaperMatrix`; every `FunctionOraclePaperImage` obligation
remains false.

### Next Reviewer Packet: O_f Paper Matrix Audit

Review only the O_f rewire and the synchronized proof map.  The expected facts
are:

| Target | Expected status |
|---|---|
| active O_f matrix | `oneTermRobinGate_O_f p`.matrix is `functionOraclePaperMatrix p` |
| legacy helper | `functionOracleMatrix` remains available only as a function-value data helper |
| clean branch | `functionOraclePaperMatrix` uses `FunctionOraclePaperImage.cleanBranchAmplitude` on the clean branch for clean input columns |
| clean workspace orthogonality skeleton | non-branch clean workspace output rows are zero for clean input columns, but orthogonality proof remains false |
| unresolved completion | non-clean rows and non-clean input columns use symbolic `functionOracleOrthogonalEntry` |
| false obligations | no O_f proof flag is promoted |

### 2026-05-23 Middle Lower Packet: O_f $N_f$ Amplitude Route

The current `O_D^BS` route is blocked by
`QBE.ODBS.UnusedZeroBranchExtension`, and the shared $N_D$ source-bound bridges
for `O_{D^T}^S` and `R_y^{boundary}` are already present.  The next
nonblocked Phase 1 transcript target is therefore the function-oracle
amplitude route.  This packet is contract capture only; it must not prove the
$N_f$ bound, orthogonality, unitarity, or block extraction.

Definitions before the target:

| Object | Existing Lean anchor | Required status |
|---|---|---|
| function value $f(x_i)$ | `robinFunctionValue p.n i` | reuse existing symbolic data |
| clean $m_f$ branch | `functionOraclePaperImage p j` | reuse the existing paper-image record |
| normalized amplitude $f(x_i)/N_f$ | `functionOracleNormalizedValue p i` | symbolic `N_f_inv` stand-in; division unproved |
| paper normalizer $N_f$ | `(Examples.RobinHeat.robinOracleComposition n).functionOracle.normalizerBound` | `Coeff.symbol "N_f"` |
| amplitude correctness | `FunctionOraclePaperImage.normalizedAmplitudeCorrect`, `FunctionOracleContract.amplitudeCorrect` | `proved = false` |
| orthogonal completion | `FunctionOraclePaperImage.orthogonalComponentCorrect`, `unitaryCompletion` | `proved = false` |

Fixed lower block:

| Field | Instruction |
|---|---|
| target block | `of_nf_amplitude_route` |
| planned declarations | `FunctionOracleExternalAmplitudeSourceContract`, `functionOracleExternalAmplitudeSourceContract`, `FunctionOracleAmplitudeProofRoute`, `functionOracleAmplitudeProofRoute`, and bridge theorems tying the route source anchor to GHL2025 Theorem 5/Eq. `coordinate oracle`, the cited arXiv:2411.01131 transcript, `functionOraclePaperImage`, `functionOracleNormalizedValue`, and the existing `FunctionOracleContract` normalizer |
| write scope | `QuantumBlockEncoding/GHL2025.lean`, focused tests in `Tests/Basic.lean`, and synchronized note files |
| permitted additions | `rfl` or `simp` bridge lemmas and false-flag guard tests; a typed route record that reuses existing O_f records rather than defining a second function value or matrix |
| forbidden additions | analytic claims about nonzero $N_f$, division semantics, normalizer bounds, orthogonality, unitary completion, changes to `functionOraclePaperMatrix`, or any `O_D^BS` cleanup/injectivity work |
| acceptance | `python3 tools/qbe.py check`; all O_f amplitude, normalizer, orthogonality, and unitarity proof flags remain false |

#### Completed Middle Packet: O_f $N_f$ Amplitude Route

Lean now defines `FunctionOracleExternalAmplitudeSourceContract`,
`functionOracleExternalAmplitudeSourceContract`,
`FunctionOracleAmplitudeProofRoute`, and `functionOracleAmplitudeProofRoute`.
The source contract is a compiled transcript of the cited theorem, and the
route is a typed proof-DAG interface for the paper coordinate-oracle equation,
not a proof of the amplitude oracle.  The route reuses
`functionOraclePaperImage p j`, records `robinFunctionValue p.n i`, the
symbolic normalizer `Coeff.symbol "N_f"`, and the normalized stand-in
`functionOracleNormalizedValue p i`.

Accepted bridge declarations:

| Declaration | Status |
|---|---|
| `functionOracleExternalAmplitudeSourceContract_sourceAnchor` | compiled source-anchor guard for GHL2025 Theorem 5, Eq. `coordinate oracle`, and arXiv:2411.01131 |
| `functionOracleExternalAmplitudeSourceContract_flags_false` | proves the resource claim, external theorem formalization, nonzero $N_f$, division semantics, theorem amplitude correctness, and closure booleans remain false |
| `functionOracleAmplitudeProofRoute_sourceAnchor` | compiled source-anchor guard for GHL2025 Theorem 5, Eq. `coordinate oracle`, and arXiv:2411.01131 |
| `functionOracleAmplitudeProofRoute_sourceFunctionValue` | compiled source-value bridge |
| `functionOracleAmplitudeProofRoute_normalizerNf` | compiled normalizer-symbol bridge |
| `functionOracleAmplitudeProofRoute_normalizedAmplitude` | compiled normalized-amplitude bridge |
| `functionOracleAmplitudeProofRoute_paperImage` | compiled clean-branch reuse bridge |
| `functionOracleAmplitudeProofRoute_obligations_reuse_paperImage` | compiled obligation-reuse bridge |
| `functionOracleAmplitudeProofRoute_externalSourceContract` | compiled bridge from the per-column route to the external source transcript |
| `functionOracleAmplitudeProofRoute_flags_false` | proves nonzero $N_f$, division semantics, normalizer bound, orthogonality, unitary completion, and theorem amplitude correctness remain false |

Source-dependency classification: `external-cited-result`.  The GHL paper cites
the piece-wise-polynomial amplitude-oracle theorem for this gate.  QBE has a
typed contract only; it did not use the cited state-preparation/function-oracle
result to prove the $N_f$ bound, orthogonal completion, or unitary extension.
The cited-results status therefore remains `contract-only` for
`GHL2025.Lemma4.Of`, with `GL2024.Thm5.AmplitudeOracle` recorded as an
unproved external obligation.

## Cycle 7 and 2026-05-22: O_DT^S Rotation Skeleton

| Declaration | Role | Status |
|---|---|---|
| `sparseAmplitudeOracleDTMatrix` | legacy diagonal helper encoding amplitude data for bulk rows, identity for boundary rows | implemented (cycle 7), helper only |
| `SparseAmplitudeOracleDTPaperRegisters` | register extraction for Lemma 3: ancilla bit, indicator bit, row, sparse index, and non-ancilla value | defined skeleton |
| `sparseAmplitudeOracleDTPaperRegisters` | executable extraction from the compound basis index | defined skeleton; concrete tests pass |
| `sparseAmplitudeOracleDTCosHalf` | symbolic $|0\rangle$ entry in the active rotation block | defined; Eq. (20) relation unproved |
| `sparseAmplitudeOracleDTSinHalf` | symbolic complementary entry in the active rotation block | defined; Eq. (20) relation unproved |
| `sparseAmplitudeOracleDTCoefficientNormalizerObligation` | explicit obligation tying the symbols to $D^{(s)}/N_D$ and the complementary normalizer term | recorded, `proved := false` |
| `SparseAmplitudeOracleDTCoefficientNormalizerContract` | per-row Eq. (20) contract tying the coefficient, $N_D$, and symbolic entries to false proof flags | defined |
| `sparseAmplitudeOracleDTCoefficientNormalizerContract` | default per-row contract for `robinSparseAmplitudeValue p.n sparse row` | defined; concrete tests pass |
| `sparseAmplitudeOracleDTNormalizedCoefficient` | symbolic stand-in for $D_j^{(s)}/N_D$ using `N_D_inv` | defined; division semantics unproved |
| `SparseAmplitudeOracleDTCoefficientNormalizerProofRoute` | per-row proof-route record separating division, $N_D$ bound, absolute-square, square-root complement, and unitarity obligations | defined; proof flags false |
| `sparseAmplitudeOracleDTCoefficientNormalizerProofRoute` | default route built from the Eq. (20) contract | defined; concrete tests pass |
| `sparseAmplitudeOracleDTRotationMatrix` | active controlled-rotation skeleton for Lemma 3 | defined skeleton |
| updated `oneTermRobinGate_O_DT_S` | uses `sparseAmplitudeOracleDTRotationMatrix`, not the diagonal helper | updated; unitary unproved |

### O_DT^S Matrix Obligations

| Obligation | Status |
|---|---|
| Legacy helper boundary row (indicator=0): diagonal entry = Coeff.rat 1 | tested (native_decide) |
| Legacy helper bulk row (indicator=1): diagonal entry = robinSparseAmplitudeValue(n, s, i) | tested (native_decide) |
| Legacy helper off-diagonal entries are zero | tested (native_decide) |
| Unitarity of O_DT^S | unproved (`unitary.proved := false`) |
| Eq. (20) coefficient-normalizer relation for symbolic rotation entries | unproved (`sparseAmplitudeOracleDTCoefficientNormalizerObligation.proved := false`) |
| Paper uses controlled rotation on ancilla, not diagonal encoding | active gate rewired to rotation skeleton |
| Refined Eq. (20) proof route | normalized-coefficient stand-in defined; division, $N_D$ bound, absolute-square, square-root complement, and unitarity obligations false |
| No promoted obligations from cycle 6 | verified |

### Cycle 7 Tests Added

| Test | Parameters | Method | Status |
|---|---|---|---|
| Boundary row j=4 (indicator=0) = 1 | n=3, κ=7 | native_decide | proved |
| Bulk row j=132 (s=0, i=2) = -1/12 | n=3, κ=7 | native_decide | proved |
| Bulk diagonal j=164 (s=2, i=2) = -5/2 | n=3, κ=7 | native_decide | proved |
| Off-diagonal M(132,133) = 0 | n=3, κ=7 | native_decide | proved |
| Bulk indicator=1 with boundary data j=128 = -5/2 + 7/3·A1·dx | n=3, κ=7 | native_decide | proved |
| O_DT^S unitary.proved = false | general p | rfl | proved |
| Gate-list label match | general p | theorem | proved; active matrix changed later |

### Run 20260522 Middle: O_DT^S Controlled-Rotation Contract

The active gate `GHL2025.oneTermRobinGate_O_DT_S` now uses
`GHL2025.sparseAmplitudeOracleDTRotationMatrix`.  The diagonal matrix
`GHL2025.sparseAmplitudeOracleDTMatrix` remains a legacy/data helper for
`robinSparseAmplitudeValue`, not the active Lemma 3 oracle.  Lemma 3 of
Guseynov-Huang-Liu 2025, Eq. (20), arXiv:2506.20478, requires the
$|0\rangle$ amplitude to encode $D^{(s)}/N_D$ and the $|1\rangle$ amplitude
to encode the complementary square-root normalizer term.

#### Source-Contract Audit

| Field / obligation | Paper source | Lean target | Status |
|---|---|---|---|
| ancilla register | Lemma 3, arXiv:2506.20478 | bit 0 in the current compound index | defined extraction |
| row register $j$ | Lemma 3 and Fig. 1-term Robin, arXiv:2506.20478 | bits $[1,1+n)$ | defined extraction |
| sparse index $s$ | Lemma 3, arXiv:2506.20478 | high subfield of the padded O_D register | defined extraction |
| indicator control | Fig. 1-term Robin, arXiv:2506.20478 | `robinIndicatorBitPosition p` | defined extraction; identity when 0 tested |
| coefficient data | Lemma 3, arXiv:2506.20478 | `robinSparseAmplitudeValue p.n sparseVal rowVal` | defined data helper |
| symbolic rotation matrix | Lemma 3, arXiv:2506.20478 | `sparseAmplitudeOracleDTRotationMatrix` | active skeleton |
| coefficient-normalizer proof | Lemma 3, Eq. (20), arXiv:2506.20478 | `sparseAmplitudeOracleDTCoefficientNormalizerContract`, `sparseAmplitudeOracleDTCoefficientNormalizerObligation` | typed contract recorded; proof fields must stay false |
| active gate rewire | Fig. 1-term Robin, arXiv:2506.20478 | `oneTermRobinGate_O_DT_S.matrix = sparseAmplitudeOracleDTRotationMatrix p` | proved by `rfl` |
| unitarity proof | Lemma 3, Eq. (20), arXiv:2506.20478 | gate `unitary.proved` and future theorem | unproved; must stay false |

#### O_DT^S Proof-DAG

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `odts_extract_registers` | extract ancilla bit, indicator bit, row value, sparse-index value, and non-ancilla rest bits | `defaultRobinRegisterPartition`, `robinIndicatorBitPosition` | `SparseAmplitudeOracleDTPaperRegisters`, `sparseAmplitudeOracleDTPaperRegisters` | rotation entries, tests | O_DT^S | defined skeleton |
| `odts_rotation_entries` | define symbolic two-by-two ancilla rotation entries controlled by the sparse coefficient | `odts_extract_registers`, `robinSparseAmplitudeValue` | `sparseAmplitudeOracleDTCosHalf`, `sparseAmplitudeOracleDTSinHalf`, `sparseAmplitudeOracleDTRotationMatrix` | active gate, block extraction | O_DT^S | active skeleton; coefficient relation unproved |
| `odts_coeff_normalizer` | prove symbols match $D^{(s)}/N_D$ and the Eq. (20) complementary normalizer term | `robinSparseAmplitudeValue`, future $N_D$ bound, future absolute-square/square-root semantics | `sparseAmplitudeOracleDTCoefficientNormalizerContract`, `sparseAmplitudeOracleDTNormalizedCoefficient`, `sparseAmplitudeOracleDTCoefficientNormalizerProofRoute`, `sparseAmplitudeOracleDTCoefficientNormalizerObligation` | `odts_rotation_unitary`, block extraction | O_DT^S | typed contract and proof route recorded; analytic identities unproved |
| `odts_active_gate_rewire` | active gate matrix is definitionally the rotation skeleton, not the diagonal helper | `odts_rotation_entries` | `oneTermRobinGate_O_DT_S` | circuit product | O_DT^S | proved by `rfl` |
| `odts_rotation_unitary` | prove the symbolic entries satisfy the paper's unitary relation under the $N_D$ bound | `odts_rotation_entries`, `odts_coeff_normalizer` | future theorem or obligation | gate proof flag | O_DT^S | unproved |

#### Completed Lower Packet

Allowed write scope was `QuantumBlockEncoding/GHL2025.lean` and
`Tests/Basic.lean` only.  The packet added:

| Declaration | Role |
|---|---|
| `SparseAmplitudeOracleDTPaperRegisters` | stores extracted ancilla bit, indicator bit, row value, sparse-index value, and non-ancilla rest value |
| `sparseAmplitudeOracleDTPaperRegisters` | computes those fields from a compound basis index |
| `sparseAmplitudeOracleDTRotationMatrix` | identity when indicator bit is 0; symbolic ancilla rotation when indicator bit is 1 |
| `sparseAmplitudeOracleDTCoefficientNormalizerObligation` | records the unproved Eq. (20) coefficient-normalizer relation |
| `sparseAmplitudeOracleDTCoefficientNormalizerContract` | records the per-row coefficient, $N_D$ normalizer, symbolic entries, and false proof flags for Eq. (20) |

Completed tests:

| Test | Parameters | Method | Status |
|---|---|---|---|
| active gate equality | general `p` | `rfl` | proved |
| gate-list label match with active rotation matrix | general `p` | theorem | proved |
| bulk cos entry | `n=3`, `kappa=7`, column `132`, row `132` | `native_decide` | equals `Coeff.symbol "odts_cos_half_2_0"` |
| bulk sin entry | `n=3`, `kappa=7`, column `132`, row `133` | `native_decide` | equals `Coeff.symbol "odts_sin_half_2_0"` |
| boundary identity | `n=3`, `kappa=7`, column `4`, row `4` | `native_decide` | equals `Coeff.rat 1` |
| boundary no flip | `n=3`, `kappa=7`, column `4`, row `5` | `native_decide` | equals `Coeff.rat 0` |
| proof flag | general `p` | `rfl` | `(oneTermRobinGate_O_DT_S p).unitary.proved = false` |
| coefficient-normalizer flag | global obligation | `rfl` | `sparseAmplitudeOracleDTCoefficientNormalizerObligation.proved = false` |
| helper retained | concrete or general | compile check | `sparseAmplitudeOracleDTMatrix` remains available and is not the active gate |

Remaining non-goals: do not promote `unitary.proved`, do not assert the $N_D$
bound without a Lean statement, and do not replace the paper's controlled
rotation by a diagonal shortcut.

#### Completed Lower Packet: Eq. (20) Contract Promotion

This packet promoted the `odts_coeff_normalizer` obligation to a typed
per-row contract without proving the analytic identities.  The declaration
`GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerContract p row sparse`
binds the symbols used by `sparseAmplitudeOracleDTRotationMatrix` to the
coefficient source `robinSparseAmplitudeValue p.n sparse row` and the paper
normalizer symbol $N_D$.

| Contract field / test | Parameters | Method | Status |
|---|---|---|---|
| `coefficient = robinSparseAmplitudeValue p.n sparse row` | general declaration | definition | recorded |
| concrete coefficient is $-1/12$ | $n=3$, $\kappa=7$, row $2$, sparse $0$ | `native_decide` | proved |
| `normalizerND = Coeff.symbol "N_D"` | $n=3$, $\kappa=7$, row $2$, sparse $0$ | `rfl` | proved |
| `ketZeroEntry = odts_cos_half_2_0` | $n=3$, $\kappa=7$, row $2$, sparse $0$ | `native_decide` | proved |
| `ketOneEntry = odts_sin_half_2_0` | $n=3$, $\kappa=7$, row $2$, sparse $0$ | `native_decide` | proved |
| `coefficientRelation.proved = false` | general `p row sparse` | `rfl` | proved |
| `complementRelation.proved = false` | general `p row sparse` | `rfl` | proved |
| `twoByTwoUnitary.proved = false` | general `p row sparse` | `rfl` | proved |

The remaining mathematical obligations are unchanged: prove that the
$|0\rangle$ entry equals $D_j^{(s)}/N_D$, prove that the $|1\rangle$ entry
equals $\sqrt{1-|D_j^{(s)}|^2/N_D^2}$, and prove the two-by-two block is
unitary under the paper's $N_D$ bound.

#### Middle Packet: Eq. (20) Proof-Route Refinement

This packet added the route declaration
`GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse`
and the normalized coefficient stand-in
`GHL2025.sparseAmplitudeOracleDTNormalizedCoefficient p row sparse`.  The
stand-in is `robinSparseAmplitudeValue p.n sparse row * N_D_inv`; it records
the intended expression $D_j^{(s)}/N_D$ without proving division semantics or a
nonzero normalizer.

| Route field / test | Parameters | Method | Status |
|---|---|---|---|
| normalized coefficient equals `(-1/12) * N_D_inv` | $n=3$, $\kappa=7$, row $2$, sparse $0$ | `native_decide` | proved |
| route coefficient reuses the contract coefficient | general `p row sparse` | theorem | proved |
| route normalizer reuses the contract $N_D$ field | general `p row sparse` | theorem | proved |
| route normalized coefficient reuses the stand-in | general `p row sparse` | theorem | proved |
| route $|0\rangle$ entry reuses the contract symbolic entry | general `p row sparse` | theorem | proved |
| route $|1\rangle$ entry reuses the contract symbolic entry | general `p row sparse` | theorem | proved |
| `coefficientDivision.proved = false` | general `p row sparse` | `rfl` | proved |
| `normalizerBound.proved = false` | general `p row sparse` | `rfl` | proved |
| `absSquareSemantics.proved = false` | general `p row sparse` | `rfl` | proved |
| `sqrtComplementSemantics.proved = false` | general `p row sparse` | `rfl` | proved |
| `twoByTwoUnitary.proved = false` | general `p row sparse` | `rfl` | proved |

#### Cycle 16 Middle Packet: Shared $N_D$ Normalizer Contract

This packet added `GHL2025.DerivativeNormalizerNDContract` and
`GHL2025.derivativeNormalizerNDContract p row sparse` as the shared source for
the normalized derivative coefficient $D_j^{(s)}/N_D$.  Both `O_{D^T}^S` and
`R_y^{boundary}` use `robinSparseAmplitudeValue p.n sparse row` and the same
normalizer symbol `Coeff.symbol "N_D"`, so their division and coefficient-bound
obligations should not be duplicated.

| Shared field / test | Parameters | Method | Status |
|---|---|---|---|
| `coefficient` is `robinSparseAmplitudeValue p.n sparse row` | general declaration | theorem / definition | recorded |
| concrete coefficient is $-1/12$ | $n=3$, $\kappa=7$, row $2$, sparse $0$ | `native_decide` | proved |
| `normalizerND = Coeff.symbol "N_D"` | $n=3$, $\kappa=7$, row $2$, sparse $0$ | `rfl` | proved |
| `normalizedCoefficient = (-1/12) * N_D_inv` | $n=3$, $\kappa=7$, row $2$, sparse $0$ | `native_decide` | proved |
| nonzero, division, coefficient-bound, absolute-square, square-root, arccos, and two-by-two-unitary obligations | general `p row sparse` | `rfl` | all `proved := false` |
| `O_{D^T}^S` proof route uses the shared division, bound, absolute-square, and square-root fields | general `p row sparse` | `sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_sharedND` | proved bridge |
| `R_y^{boundary}` proof route uses the shared division, arccos-domain, and bound fields | general `p row sparse` | `boundaryRotationAngleNormalizerProofRoute_sharedND` | proved bridge |

This packet did not change `sparseAmplitudeOracleDTRotationMatrix`,
`boundaryRotationMatrix`, either active gate matrix, or any `unitary.proved`
flag.

#### Cycle 16 Lower Packet: Shared $N_D$ Source-Bound View

The declaration `GHL2025.derivativeNormalizerNDSourceBound p row sparse`
packages the fixed source coefficient and normalizer for the future bound
$|D_j^{(s)}| \le N_D$.  It is a view over
`GHL2025.derivativeNormalizerNDContract p row sparse`; it does not add an
analytic hypothesis and it keeps the bound obligation false.

| Source-bound field / test | Parameters | Method | Status |
|---|---|---|---|
| `sourceCoefficient = robinSparseAmplitudeValue p.n sparse row` | general `p row sparse` | `derivativeNormalizerNDSourceBound_sourceCoefficient` | proved bridge |
| concrete coefficient is $-1/12$ | $n=3$, $\kappa=7$, row $2$, sparse $0$ | `native_decide` | proved |
| `normalizerND = Coeff.symbol "N_D"` | general `p row sparse` | `derivativeNormalizerNDSourceBound_normalizerND` | proved bridge |
| bound formula is `|D_j^(s)| <= N_D` | general `p row sparse` | `derivativeNormalizerNDSourceBound_boundFormula` | recorded |
| bound obligation reuses the shared contract field | general `p row sparse` | `derivativeNormalizerNDSourceBound_coefficientBound` | proved bridge |
| `coefficientBound.proved = false` | general `p row sparse` | `derivativeNormalizerNDSourceBound_coefficientBound_false` | proved false flag |

This packet did not change the active matrices for `O_{D^T}^S` or
`R_y^{boundary}` and did not promote any normalizer, arccos, square-root, or
unitarity obligation.

#### Cycle 17 Middle Packet: Shared $N_D$ Normalizer Audit

The current source-contract decision keeps $O_D^{BS}$ injectivity, dagger
cleanup, unitarity, and block extraction blocked on the unused zero-branch
image rule.  The next executable packet should therefore stay on the shared
$N_D$ route used by $O_{D^T}^S$ and `Ry_boundary`.

Definitions before use:

| Object | Lean anchor | Status |
|---|---|---|
| coefficient source $D_j^{(s)}$ | `robinSparseAmplitudeValue p.n sparse row` | defined data source |
| shared normalizer $N_D$ | `(derivativeNormalizerNDContract p row sparse).normalizerND` | `Coeff.symbol "N_D"` |
| formal normalized coefficient $D_j^{(s)}/N_D$ | `(derivativeNormalizerNDContract p row sparse).normalizedCoefficient` | symbolic `N_D_inv` stand-in |
| source-bound view $|D_j^{(s)}| \le N_D$ | `DerivativeNormalizerNDSourceBound` | typed view; bound flag false |

Proof-DAG obligations:

| Block | Interface | Lean declaration | Reused by | Required status |
|---|---|---|---|---|
| `shared_nd_coefficient_source` | both normalizer routes use the same sparse derivative coefficient | `derivativeNormalizerNDContract_coefficient`, `derivativeNormalizerNDSourceBound_sourceCoefficient`, `sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_sourceBound`, `boundaryRotationAngleNormalizerProofRoute_sourceBound`, `derivativeNormalizerNDSourceBound_sharedRoutes` | `odts_coeff_normalizer`, `ryb_angle_normalizer` | definitional bridge |
| `shared_nd_division` | interpret the formal `N_D_inv` factor as division by nonzero $N_D$ | `DerivativeNormalizerNDContract.divisionSemantics` | Eq. (20) $|0\rangle$ entry, boundary arccos argument | `proved = false` |
| `shared_nd_bound` | prove the paper bound $|D_j^{(s)}| \le N_D$ | `DerivativeNormalizerNDSourceBound.coefficientBound` | square-root complement, arccos domain, unitarity | `proved = false` |
| `shared_nd_abs_sqrt` | interpret $|D_j^{(s)}|^2/N_D^2$ and the Eq. (20) square-root complement | `DerivativeNormalizerNDContract.absSquareSemantics`, `DerivativeNormalizerNDContract.sqrtComplementSemantics` | `O_{D^T}^S` | `proved = false` |
| `shared_nd_arccos` | place $D_j^{(s)}/N_D$ in the real arccos domain | `DerivativeNormalizerNDContract.arccosSemantics` | `Ry_boundary` | `proved = false` |

Lower packet for the next cycle:

| Field | Instruction |
|---|---|
| fixed target | bridge/tests only for the shared $N_D$ route |
| write scope | `QuantumBlockEncoding/GHL2025.lean`, `Tests/Basic.lean`, and synchronized note files if Lean changes |
| permitted additions | missing `rfl`-style field bridges or tests that show `O_{D^T}^S` and `Ry_boundary` reuse `DerivativeNormalizerNDContract` and `DerivativeNormalizerNDSourceBound` |
| forbidden additions | analytic proof claims, new hypotheses, replacement normalizers, gate-unitarity promotion, block extraction, and all $O_D^{BS}$ cleanup/injectivity work |
| gate | `python3 tools/qbe.py check`; all route and shared-normalizer proof flags must remain false |

#### Cycle 17 Lower Packet: Shared $N_D$ Source-Bound Route Bridges

This packet adds only definitional bridges for the fixed
`shared_nd_coefficient_source` block:

| Bridge / test | Parameters | Method | Status |
|---|---|---|---|
| `O_{D^T}^S` route reuses the source-bound coefficient, $N_D$ symbol, and bound obligation | general `p row sparse` | `sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_sourceBound` | proved bridge |
| `R_y^{boundary}` route reuses the source-bound coefficient, $N_D$ symbol, and bound obligation | general `p row sparse` | `boundaryRotationAngleNormalizerProofRoute_sourceBound` | proved bridge |
| the two proof routes share coefficient, $N_D$, and bound-obligation fields | general `p row sparse` | `derivativeNormalizerNDSourceBound_sharedRoutes` | proved bridge |

These bridges do not assert nonzero $N_D$, division semantics, the coefficient
bound, absolute-square semantics, square-root semantics, arccos semantics,
half-angle identities, or two-by-two unitarity.  All corresponding proof flags
remain false.

#### Current Middle Guard: Shared $N_D$ False Flags

Middle rechecked GHL2025 Lemma 3, Eq. (20), the boundary $R_y$ angle equation,
and Fig. 1-term Robin before assigning more lower work.  The missing
ingredient is classified as `classical-lean-lemma` for future analytic
semantics and `proof-state sync` for the present packet.  No external theorem
is accepted and no paper contract is changed.

The guard theorem
`GHL2025.derivativeNormalizerNDSharedRoute_flags_false` now packages the
current state of the fixed shared $N_D$ route:

| Guarded item | Lean anchor | Status |
|---|---|---|
| nonzero $N_D$ and formal division | `DerivativeNormalizerNDContract.nonzeroNormalizer`, `DerivativeNormalizerNDContract.divisionSemantics` | `proved = false` |
| coefficient bound | `DerivativeNormalizerNDSourceBound.coefficientBound` and shared route `normalizerBound` fields | `proved = false` |
| Eq. (20) absolute-square and square-root complement | `DerivativeNormalizerNDContract.absSquareSemantics`, `DerivativeNormalizerNDContract.sqrtComplementSemantics` | `proved = false` |
| boundary arccos and half-angle semantics | `DerivativeNormalizerNDContract.arccosSemantics`, `BoundaryRotationAngleNormalizerProofRoute.halfAngleSemantics` | `proved = false` |
| $O_{D^T}^S$ and `Ry_boundary` unitarity flags | `oneTermRobinGate_O_DT_S`, `oneTermRobinGate_Ry_boundary` | `unitary.proved = false` |

Next lower-agent packet:

| Field | Instruction |
|---|---|
| write scope | do not touch this block unless a reviewer asks for an additional false-flag guard |
| permitted follow-up | proceed only to a fixed Phase 1 transcript block chosen by upper |
| forbidden routes | no $O_D^{BS}$ cleanup/unitarity proof search; no analytic theorem, new hypothesis, replacement normalizer, or gate-unitarity promotion from the shared $N_D$ guard |

### O_f vs O_DT^S Double Encoding Audit (Resolved Cycle 9)

**Finding (cycle 7):** Both `functionOracleMatrix` (O_f) and `sparseAmplitudeOracleDTMatrix` (O_DT^S)
used `robinSparseAmplitudeValue` as their diagonal data source, encoding the same derivative data twice.

**Fix (cycle 9 and 2026-05-22 follow-up):** O_f now uses `robinFunctionValue`
(symbolic function values $f(x_j)$), while the O_DT^S data path continues to
use `robinSparseAmplitudeValue` (derivative stencil data).  The active O_DT^S
gate now uses the controlled-rotation skeleton, not the diagonal helper.  Both
gates carry `unitary.proved := false`; for O_DT^S the remaining gap is the
Eq. (20) coefficient-normalizer relation and the induced two-by-two unitarity
identity.

## Cycle 8: Ry_boundary Controlled Rotation Matrix

| Declaration | Role | Status |
|---|---|---|
| `boundaryRotationMatrix` | honest controlled R_y rotation on ancilla for boundary rows | implemented (cycle 8) |
| updated `oneTermRobinGate_Ry_boundary` | uses honest matrix instead of zero placeholder | updated (cycle 8) |
| `BoundaryRotationPaperRegisters` | register extraction for the boundary rotation: ancilla bit, indicator bit, row, sparse index, and non-ancilla value | defined skeleton |
| `boundaryRotationPaperRegisters` | executable extraction from the compound basis index | defined skeleton; concrete tests pass |
| `boundaryRotationCosHalf` | symbolic $\cos(\theta_j^s/2)$ entry | defined; angle relation unproved |
| `boundaryRotationSinHalf` | symbolic $\sin(\theta_j^s/2)$ entry | defined; angle relation unproved |
| `boundaryRotationAngleNormalizerObligation` | explicit obligation tying the symbols to $\theta_j^s=\arccos(D_j^{(s)}/N_D)$ and half-angle formulas | recorded, `proved := false` |
| `BoundaryRotationAngleNormalizerContract` | per-row contract tying coefficient, $N_D$, symbolic entries, and false proof flags to Eq. angles for Ry | defined |
| `boundaryRotationAngleNormalizerContract` | default per-row contract for `robinSparseAmplitudeValue p.n sparse row` | defined; concrete tests pass |

### Ry_boundary Matrix Obligations

| Obligation | Status |
|---|---|
| Bulk row (indicator=1): diagonal entry = Coeff.rat 1 (identity) | tested (native_decide) |
| Boundary row (indicator=0): diagonal cos entry = Coeff.symbol "boundary_cos_half_{i}_{s}" | tested (native_decide) |
| Boundary row: ancilla off-diagonal entries are sin/neg-sin | tested (native_decide) |
| Different boundary rows produce different symbols | tested (native_decide) |
| Off-diagonal between different rest bits is zero | tested (native_decide) |
| Unitarity of Ry_boundary | unproved (`unitary.proved := false`) |
| Paper uses rotation angles $\theta_j^s = \arccos(D_j^{(s)}/N_D)$, symbolic entries track cos/sin | typed contract recorded; proof flags false |
| Boundary-control relation | unproved (`boundaryControl.proved := false`) |
| Arccos argument relation | unproved (`arccosArgumentRelation.proved := false`) |
| Half-angle formulas | unproved (`cosHalfRelation.proved := false`, `sinHalfRelation.proved := false`) |
| Two-by-two unitarity relation | unproved (`twoByTwoUnitary.proved := false`) |
| No promoted obligations from cycle 7 | verified |

### Cycle 8 Tests Added

| Test | Parameters | Method | Status |
|---|---|---|---|
| Bulk identity M(132,132) = 1 | n=3, κ=7 | native_decide | proved |
| Bulk off-diagonal M(133,132) = 0 | n=3, κ=7 | native_decide | proved |
| Boundary cos M(0,0) = cos_half_0_0 | n=3, κ=7 | native_decide | proved |
| Boundary sin M(1,0) = sin_half_0_0 | n=3, κ=7 | native_decide | proved |
| Boundary neg-sin M(0,1) = -sin_half_0_0 | n=3, κ=7 | native_decide | proved |
| Boundary cos M(1,1) = cos_half_0_0 | n=3, κ=7 | native_decide | proved |
| Different sysVal: M(2,2) = cos_half_1_0 | n=3, κ=7 | native_decide | proved |
| Different sparseVal: M(16,16) = cos_half_0_1 | n=3, κ=7 | native_decide | proved |
| Off-diagonal M(0,2) = 0 | n=3, κ=7 | native_decide | proved |
| Ry_boundary unitary.proved = false | general p | rfl | proved |
| Placeholder match with honest Ry_boundary | general p | theorem | proved |

### Run 20260522 Middle: Ry_boundary Source Contract

This packet promoted the `Ry_boundary` angle/normalizer gap to a typed
per-row contract without proving the analytic identities.  The declaration
`GHL2025.boundaryRotationAngleNormalizerContract p row sparse` binds the
symbols used by `boundaryRotationMatrix` to the coefficient source
`robinSparseAmplitudeValue p.n sparse row` and the paper normalizer symbol
$N_D$.

#### Source-Contract Audit

| Field / obligation | Paper source | Lean target | Status |
|---|---|---|---|
| ancilla register | Fig. 1-term Robin, arXiv:2506.20478 | bit 0 in the current compound index | defined extraction |
| row register $j$ | Fig. 1-term Robin, arXiv:2506.20478 | bits $[1,1+n)$ | defined extraction |
| sparse index $s$ | Fig. 1-term Robin, arXiv:2506.20478 | high subfield of the padded O_D register | defined extraction |
| indicator control | Fig. 1-term Robin, arXiv:2506.20478 | `robinIndicatorBitPosition p` | defined extraction; identity when 1 tested |
| coefficient data | Eq. angles for Ry, arXiv:2506.20478 | `robinSparseAmplitudeValue p.n sparseVal rowVal` | defined data helper |
| symbolic rotation matrix | Fig. 1-term Robin and Eq. angles for Ry, arXiv:2506.20478 | `boundaryRotationMatrix` | active skeleton |
| angle-normalizer proof | Eq. angles for Ry, arXiv:2506.20478 | `BoundaryRotationAngleNormalizerContract`, `boundaryRotationAngleNormalizerObligation` | typed contract recorded; proof fields false |
| active gate equality | Fig. 1-term Robin, arXiv:2506.20478 | `oneTermRobinGate_Ry_boundary.matrix = boundaryRotationMatrix p` | proved by `rfl` |
| unitarity proof | Eq. angles for Ry, arXiv:2506.20478 | gate `unitary.proved` and future theorem | unproved; must stay false |

#### Ry_boundary Proof-DAG

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `ryb_extract_registers` | extract ancilla bit, indicator bit, row value, sparse-index value, and non-ancilla rest bits | `defaultRobinRegisterPartition`, `robinIndicatorBitPosition` | `BoundaryRotationPaperRegisters`, `boundaryRotationPaperRegisters` | rotation entries, tests | Ry_boundary | defined skeleton |
| `ryb_symbolic_entries` | define symbolic two-by-two boundary rotation entries controlled by the sparse coefficient | `ryb_extract_registers`, `robinSparseAmplitudeValue` | `boundaryRotationCosHalf`, `boundaryRotationSinHalf`, `boundaryRotationMatrix` | active gate, block extraction | Ry_boundary | active skeleton; angle relation unproved |
| `ryb_angle_normalizer` | prove symbols match $\theta_j^s=\arccos(D_j^{(s)}/N_D)$ and the displayed half-angle formulas | `robinSparseAmplitudeValue`, future $N_D$ bound | `BoundaryRotationAngleNormalizerContract`, `boundaryRotationAngleNormalizerObligation` | `ryb_rotation_unitary`, block extraction | Ry_boundary | typed contract recorded; analytic identities unproved |
| `ryb_active_gate_rewire` | active gate matrix is definitionally the boundary rotation matrix | `ryb_symbolic_entries` | `oneTermRobinGate_Ry_boundary` | circuit product | Ry_boundary | proved by `rfl` |
| `ryb_rotation_unitary` | prove the symbolic entries satisfy the paper's unitary relation under the $N_D$ bound | `ryb_symbolic_entries`, `ryb_angle_normalizer` | future theorem or obligation | gate proof flag | Ry_boundary | unproved |

#### 2026-05-22 Contract Tests

| Contract field / test | Parameters | Method | Status |
|---|---|---|---|
| extracted boundary indicator is 0 | $n=3$, $\kappa=7$, column $16$ | `native_decide` | proved |
| extracted row is 0 | $n=3$, $\kappa=7$, column $16$ | `native_decide` | proved |
| extracted sparse index is 1 | $n=3$, $\kappa=7$, column $16$ | `native_decide` | proved |
| extracted bulk indicator is 1 | $n=3$, $\kappa=7$, column $132$ | `native_decide` | proved |
| concrete coefficient is $-5/2+(7/3)A_1dx$ | $n=3$, $\kappa=7$, row $0$, sparse $0$ | `native_decide` | proved |
| `normalizerND = Coeff.symbol "N_D"` | $n=3$, $\kappa=7$, row $0$, sparse $0$ | `rfl` | proved |
| `cosHalfEntry = boundary_cos_half_0_0` | $n=3$, $\kappa=7$, row $0$, sparse $0$ | `native_decide` | proved |
| `sinHalfEntry = boundary_sin_half_0_0` | $n=3$, $\kappa=7$, row $0$, sparse $0$ | `native_decide` | proved |
| all five contract proof fields remain false | general `p row sparse` | `rfl` | proved |
| active gate matrix equality | general `p` | `rfl` | proved |

#### 2026-05-22 Lower Packet: Ry_boundary Angle-Normalizer Proof Route

Definition. `GHL2025.boundaryRotationNormalizedCoefficient p row sparse`
records the formal product of `robinSparseAmplitudeValue p.n sparse row` with
`Coeff.symbol "N_D_inv"`.  This is only a Phase 1 stand-in for
$D_j^{(s)}/N_D$; the division semantics and nonzero normalizer condition remain
unproved.

| Lean declaration | Purpose | Status |
|---|---|---|
| `boundaryRotationAngleNormalizerContract_coefficient` | proves the contract coefficient is definitionally `robinSparseAmplitudeValue p.n sparse row` | proved by `rfl` |
| `boundaryRotationNormalizedCoefficient` | records the intended $D_j^{(s)}/N_D$ argument as coefficient times formal `N_D_inv` | defined; division semantics unproved |
| `BoundaryRotationAngleNormalizerProofRoute` | separates the angle-normalizer gap into division, real-arccos, half-angle, $N_D$-bound, and two-by-two-unitary fields | defined |
| `boundaryRotationAngleNormalizerProofRoute` | default proof-route record for a row and sparse index | defined; all proof fields false |
| `boundaryRotationAngleNormalizerProofRoute_coefficient` | proves the route uses the existing contract coefficient | proved by `rfl` |
| `boundaryRotationAngleNormalizerProofRoute_arccosArgument` | proves the route uses `boundaryRotationNormalizedCoefficient` as its arccos argument | proved by `rfl` |

The route keeps `cosHalfRelation`, `sinHalfRelation`,
`coefficientDivision`, `realArccosSemantics`, `halfAngleSemantics`,
`normalizerBound`, and `twoByTwoUnitary` false.  It does not promote
`oneTermRobinGate_Ry_boundary.unitary.proved`.

Cycle 16 reuses `derivativeNormalizerNDContract` for the route's division,
arccos-domain, and $N_D$-bound fields.  The bridge theorem
`boundaryRotationAngleNormalizerProofRoute_sharedND` proves this reuse by
definitional equality.  The half-angle relation and the gate-level
two-by-two-unitarity proof remain local obligations and still have
`proved := false`.

Remaining non-goals: do not promote `unitary.proved`, do not assert the $N_D$
bound without a Lean statement, and do not replace the paper's boundary
rotation with a different oracle.

## Cycle 10: Product/Projection Pipeline Obligations

| Object | Lean status | Remaining obligation |
|---|---|---|
| Full circuit matrix | `oneTermRobinCircuitSemantics n`.matrix is `evalGateMatrices` over all seven gate matrices | prove the product matches the paper's intended $U$ |
| Dimension split | `oneTermRobinCircuitDimCompat n` proves $2^q = 2^m \cdot N$ | none for the arithmetic bridge |
| Block target | `oneTermRobinBlockExtractionTarget n` derives `unitaryMatrix` and `blockMatrix` from the product/projection API | prove the extracted block equals $A_k/(N_DN_f\kappa)$ |
| Runtime test policy | structural tests compile quickly | full $n=3$ entry-level product checks are deferred to focused proof attempts |

Concrete entry-level normalization of the full $n=3$ product is not a build-gate test. The matrix has dimension $8192 \times 8192$, so `native_decide` on composed entries is too expensive for routine CI. Future lower agents should introduce intermediate lemmas for individual gates, row support, and projection algebra before attempting product-entry proofs.

## Cycle 11: Coeff.rat Arithmetic Lemmas and U_indic Bijection Stepping Stone

### A. Coeff.rat Arithmetic Lemmas (Core.lean)

Added simplification lemmas enabling future matrix-multiplication normalization:

| Lemma | Role | Status |
|---|---|---|
| `Coeff.evalWith_rat_zero` | `evalWith env (Coeff.rat 0) = 0` | proved (rfl) |
| `Coeff.evalWith_rat_one` | `evalWith env (Coeff.rat 1) = 1` | proved (rfl) |
| `Coeff.evalWith_rat_add` | `evalWith env (Coeff.add (Coeff.rat a) (Coeff.rat b)) = a + b` | proved (simp) |
| `Coeff.evalWith_rat_mul` | `evalWith env (Coeff.mul (Coeff.rat a) (Coeff.rat b)) = a * b` | proved (simp) |
| `Coeff.evalWith_rat_neg` | `evalWith env (Coeff.neg (Coeff.rat a)) = -a` | proved (simp) |

These lemmas close the `Coeff.rat` → `Rat` evaluation gap for arithmetic compositions. They are prerequisites for proving that permutation-matrix products evaluate correctly under `evalWith`.

### B. U_indic Bijection Stepping Stone (GHL2025.lean)

| Declaration | Role | Status |
|---|---|---|
| `indicatorOracleImage` | Extracted image function: `j → expectedImage` for U_indic | implemented |
| `indicatorOracleMatrix_eq_image` | Matrix entry = `if i = image j then 1 else 0` | proved (by simp) |
| `indicatorOracleImage_self_inverse_n1` | Self-inverse for n=1: `image(image(j)) = j` | proved (native_decide) |
| `indicatorOracleImage_self_inverse_n3` | Self-inverse for n=3: `image(image(j)) = j` | proved (native_decide) |

The self-inverse property (`image ∘ image = id`) is the key stepping stone toward proving U_indic is a permutation matrix and hence unitary. A self-inverse function on a finite set is automatically a bijection, and a bijection matrix with 0/1 entries is unitary.

### Cycle 11 Tests Added

| Test | Parameters | Method | Status |
|---|---|---|---|
| Coeff.rat addition evaluates | `evalWith (add (rat 1) (rat 2)) = 3` | native_decide | proved |
| Coeff.rat multiplication evaluates | `evalWith (mul (rat 2) (rat 3)) = 6` | native_decide | proved |
| Coeff.rat negation evaluates | `evalWith (neg (rat 5)) = -5` | native_decide | proved |
| Coeff.rat compound evaluates | `evalWith (add (mul (rat 2) (rat 3)) (rat 1)) = 7` | native_decide | proved |
| Image boundary j=0 → 0 | n=3, κ=7 | native_decide | proved |
| Image bulk j=4 → 132 | n=3, κ=7 | native_decide | proved |
| Image round-trip 132 → 4 | n=3, κ=7 | native_decide | proved |
| Self-inverse n=3 | full space 2^13 | native_decide | proved |
| Self-inverse n=1 | full space 2^7 | native_decide | proved |

## Cycle 12: General U_indic Self-Inverse and Bijection

### Proof-DAG Block: Bit-Arithmetic Reusable Lemmas

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `shiftLeft_land_mask_eq_zero` | `(b <<< pos) &&& mask = 0` when `pos >= n` | none | `shiftLeft_land_mask_eq_zero` | `xor_shift_preserve_low`, SWAP/O_D^BS bijection | proved |
| `xor_shift_preserve_low` | XOR with high bit preserves low `n` bits | `shiftLeft_land_mask_eq_zero` | `xor_shift_preserve_low` | `systemVal_preserved` | proved |
| `xor_shift_preserve_shift_low` | Shifted variant: high-XOR preserves shifted low bits | none | `xor_shift_preserve_shift_low` | `systemVal_preserved` | proved |
| `robinIndicatorBitPosition_ge` | `robinIndicatorBitPosition >= 1 + p.n` | none | `robinIndicatorBitPosition_ge` | `systemVal_preserved` | proved |
| `systemVal_preserved` | `systemVal(image(j)) = systemVal(j)` for all `p` | `xor_shift_preserve_shift_low`, `robinIndicatorBitPosition_ge` | `indicatorOracleImage_systemVal_preserved` | `isBulk_preserved`, `self_inverse` | proved |
| `isBulk_preserved` | Bulk membership unchanged by image | `systemVal_preserved` | `indicatorOracleImage_isBulk_preserved` | `self_inverse` | proved |
| `self_inverse_gen` | `image(image(j)) = j` for all `p, j` | `isBulk_preserved` | `indicatorOracleImage_self_inverse` | `injective_gen`, `bijective` | proved |
| `injective_gen` | Injectivity from self-inverse | `self_inverse_gen` | `indicatorOracleImage_injective` | `bijective_gen` | proved |
| `lt_totalQubits` | Image preserves `qubitDim` bound | `robinIndicatorBitPosition_lt_totalQubits` | `indicatorOracleImage_lt` | `bijective_gen` | proved |
| `bijective_gen` | `image` is bijective on `Fin (qubitDim total)` | `self_inverse_gen`, `injective_gen`, `lt_totalQubits` | `indicatorOracleImage_bijective` | U_indic unitarity | proved |

### Remaining Obligations After Cycle 12

| Obligation | Status |
|---|---|
| U_indic full unitarity proof (bijection → permutation → unitary) | **proved** (run 02 cycle 02: `indicatorOracleMatrix_is_permutation`) |
| SWAP permutation unitarity | image self-inverse and range are proved; finite-domain row/column uniqueness and permutation-matrix certificate remain pending |
| O_D^BS permutation unitarity | active paper-image skeleton is wired and finite-image entries are bridged under explicit hypotheses; injectivity is still unproved |
| (O_D^BS)^† unitarity | active paper-image dagger skeleton is wired; inverse-on-range and cleanup after SWAP are still unproved |
| O_DT^S rotation unitarity | active rotation skeleton is wired; Eq. (20) coefficient-normalizer proof and unitarity remain unproved |
| Ry_boundary rotation unitarity | unproved; `ryb_angle_normalizer` contract records the missing arccos and half-angle identities |
| O_f diagonal unitarity | unproved, requires |f(x)| ≤ N_f bound |
| Block extraction correctness | unproved |
| No promoted obligations from cycle 11 | verified |

## Run 02 Cycle 02: U_indic Permutation-Matrix Unitarity Bridge

### New Theorems

| Declaration | Role | Status |
|---|---|---|
| `indicatorOracleMatrix_col_has_one` | For each column j, entry at row image(j) = 1 | proved |
| `indicatorOracleMatrix_col_unique` | For each column j, the 1-entry row is unique | proved |
| `indicatorOracleMatrix_row_has_one` | For each row i, there exists a column j with M[i][j] = 1 (surjectivity) | proved |
| `indicatorOracleMatrix_row_unique` | For each row i, the 1-entry column is unique (injectivity) | proved |
| `indicatorOracleMatrix_is_permutation` | Main theorem: exactly one 1 per row and per column | proved |

### Updated Gate Matrix

| Declaration | Change | Status |
|---|---|---|
| `oneTermRobinGate_U_indic` | `unitary.proved := true` | updated |

### Obligation Resolution

| Obligation | Previous Status | New Status |
|---|---|---|
| U_indic unitarity | `proved := false` | `proved := true` |

### Documentation Promotions

| Item | Previous Status | New Status |
|---|---|---|
| Cycle 12 proof-DAG block entries | "in progress" / "assigned to lower" | "proved" |
| Cycle 12 paper correspondence | "assigned to lower" | "proved" |

### No Promoted Paper-Oracle Obligations

Only the Lean-local SWAP gate flag is promoted in this route.  The paper-oracle
gate matrices remain `unitary.proved := false`, and the `RobinProofObligations`
defaults are unchanged.

## Cycle 1 (Run 03): SWAP Permutation-Matrix Unitarity via Proof-DAG

### Proof-DAG Block: SWAP Bit-Slice Reusable Lemmas

The SWAP oracle `swapOracleImage` exchanges two n-qubit register blocks at
positions `[1, 1+n)` and `[1+n, 1+2n)`.  The self-inverse proof decomposes into
bit-slice lemmas showing that after swap, block1' = block2 and block2' = block1,
hence diff' = diff and applying the XOR pattern twice cancels.

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `swap_diff_bounded` | `diff < 2^n` where `diff = block1 XOR block2` | `Nat.xor_lt_two_pow`, `Nat.and_lt_two_pow` | `swapOracleDiff_lt_two_pow` | `swap_block1_image`, `swap_block2_image`, `swap_lt` | proved |
| `swap_diff_shift_right_zero` | `diff >>> n = 0` for the SWAP block difference | `swap_diff_bounded`, `Nat.shiftRight_eq_zero` | `swapOracleDiff_shiftRight_eq_zero` | `swap_block2_image`, `swap_lt` | proved |
| `swap_diff_shift_left_mask_zero` | `(diff <<< n) &&& mask = 0` for `mask = 2^n - 1` | `shiftLeft_land_mask_eq_zero` | `swapOracleDiff_shiftLeft_mask_eq_zero` | `swap_block1_image` | proved |
| `shiftLeft_shiftRight_self` | optional cancellation lemma `(b <<< k) >>> k = b` when no bits are lost | none | no current declaration | future SWAP self-inverse route if needed | deferred; current `swap_block2_image` uses a direct bit-test proof |
| `swap_block1_image` | After swap, block1' = block2 | bit-test proof over `swapOracleImage` and mask facts | `swapOracleImage_block1_eq_block2` | `swap_diff_preserved` | proved |
| `swap_block2_image` | After swap, block2' = block1 | bit-test proof over `swapOracleImage` and mask facts | `swapOracleImage_block2_eq_block1` | `swap_diff_preserved`, O_D^BS post-SWAP register equations | proved |
| `swap_diff_named` | name the block difference used by the SWAP image formula | same block extraction as `swapOracleImage` | `swapOracleDiff`, `swapOracleImage_eq_xor_diff` | `swap_diff_preserved`, `swap_self_inverse` | proved by definition |
| `swap_diff_preserved` | diff' = diff after swap | `swap_block1_image`, `swap_block2_image` | `swapOracleDiff_preserved` | `swap_self_inverse` | proved |
| `swap_xor_cancel` | applying the two shifted XOR masks twice cancels bitwise | `Nat.testBit_xor` case split | `xor_two_shifted_masks_cancel` | `swap_self_inverse` | proved |
| `swap_self_inverse` | `image(image(j)) = j` for all `p, j` | `swap_diff_named`, `swap_diff_preserved`, `swap_xor_cancel` | `swapOracleImage_self_inverse` | `swap_injective`, `swap_bijective` | proved |
| `swap_injective` | Injectivity from self-inverse | `swap_self_inverse` | `swapOracleImage_injective` | `swap_bijective` | proved |
| `swap_lt` | Image preserves `qubitDim` bound | `swap_diff_bounded`, register-width inequality | `swapOracleImage_lt_qubitDim` | `swap_bijective`, post-SWAP cleanup range | proved |
| `swap_bijective` | Bijective on `Fin (qubitDim total)` | `swap_self_inverse`, `swap_injective`, `swap_lt` | `swapOracleImage_bijective` | permutation proof | proved |
| `swap_col_has_one` | For each column j, entry at row image(j) = 1 | `swap_bijective` | `swapOracleMatrix_col_has_one` | `swap_is_permutation` | proved |
| `swap_col_unique` | For each column j, the 1-entry row is unique | `swap_bijective` | `swapOracleMatrix_col_unique` | `swap_is_permutation` | proved |
| `swap_row_has_one` | For each row i, surjectivity: there exists j with M[i][j]=1 | `swap_bijective` | `swapOracleMatrix_row_has_one` | `swap_is_permutation` | proved |
| `swap_row_unique` | For each row i, the 1-entry column is unique | `swap_bijective` | `swapOracleMatrix_row_unique` | `swap_is_permutation` | proved |
| `swap_is_permutation` | Exactly one 1 per row and per column | all above | `swapOracleMatrix_is_permutation` | gate proved update | proved; SWAP unitary flag true |

### Key Bit-Arithmetic Facts

1. `(diff <<< n) &&& mask = 0` is now `swapOracleDiff_shiftLeft_mask_eq_zero`, reusing `shiftLeft_land_mask_eq_zero` from cycle 12 with `pos = n`.
2. `diff >>> n = 0` is now `swapOracleDiff_shiftRight_eq_zero`, derived from `swapOracleDiff_lt_two_pow` and `Nat.shiftRight_eq_zero`.
3. Right-shift distributes over XOR: `(a ^^^ b) >>> k = (a >>> k) ^^^ (b >>> k)` (Lean std `Nat.shiftRight_xor_distrib` or similar).
4. AND distributes over XOR: already used in `xor_shift_preserve_low` from cycle 12.
5. `(b <<< k) >>> k = b` when `b < 2^m` and no bits are lost: shift-left then shift-right cancels.

### Self-Inverse Proof Sketch

For `result = swapOracleImage p j`:
- `block1' = (result >>> 1) & mask = block2` (because `(diff <<< n) & mask = 0` and `diff & mask = diff`).
- `block2' = (result >>> (1+n)) & mask = block1` (because `diff >>> n = 0` and `diff & mask = diff`).
- `diff' = block1' XOR block2' = block2 XOR block1 = diff` (XOR is commutative).
- `swap(swap(j)) = j XOR (diff <<< 1) XOR (diff <<< (1+n)) XOR (diff <<< 1) XOR (diff <<< (1+n)) = j`.

### Non-Goals

- For this SWAP packet, do not touch O_D^BS, O_f, O_DT^S, Ry_boundary, or (O_D^BS)^†.
- Do not add assumptions, side conditions, or sorry.
- Do not change the paper's circuit or oracle construction.

### Middle Update: 2026-05-22

The first SWAP diff block is now Lean-proved without promoting the SWAP gate
obligation.  The paper source is the SWAP operation in Fig. 1-term Robin,
arXiv:2506.20478, and the Lean declarations only expose bit facts about the
existing `swapOracleImage` formula:

| Declaration | Claim | Status |
|---|---|---|
| `swapOracleDiff_lt_two_pow` | the XOR diff of the two extracted n-bit blocks is below $2^n$ | proved |
| `swapOracleDiff_shiftRight_eq_zero` | the diff has no bits at positions $\geq n$ | proved |
| `swapOracleDiff_shiftLeft_mask_eq_zero` | shifting the diff into the high block contributes zero under the low n-bit mask | proved |

The post-SWAP register packet now proves both `swapOracleImage_block1_eq_block2`
and `swapOracleImage_block2_eq_block1`.  The acceptance gate is
`python3 tools/qbe.py check`; `oneTermRobinGate_SWAP.unitary.proved` must
remain `false`.

## Cycle 5 Middle Handoff: Reverse-Index Generalization

The current reverse-index work is proof-route memory for the fixed Lemma 1
cleanup path.  Lean now has `robinSparseReverseColumnIndex`,
`robinSparseReverseColumnRoundtripCheck`,
`bandedSparseAccessPaperPostSwapPreimageCandidate`, and
`bandedSparseAccessPaperPostSwapPreimageCandidateChecks`.  The tests prove the
finite scans for $n=3$, $n=4$, and the full finite-source scan for
`n = 3`, `kappa = 7`.

These scans do not discharge `daggerCleanup`, inverse uniqueness, or any
unitarity claim.  The proof-attempt record is
`proof-attempts/QBE-AUTO-002-odbs-reverse-roundtrip.md`.

The next fixed Lean target is:

```lean
theorem robinSparseReverseColumnRoundtrip_of_lt_eight
    {n s i : Nat} (hn : 3 <= n) (hs : s < 8) (hi : i < gridSize n) :
    robinSparseColumnMap n
      (robinSparseReverseColumnIndex n i (robinSparseColumnMap n s i))
      (robinSparseColumnMap n s i) = i
```

The theorem is only an arithmetic block for the reverse sparse-index route.  If
it compiles, it may feed the post-SWAP preimage candidate proof.  It must not
change the source contract, the active gate list, or any proof flag.  If it
fails, append the failed branch goals and reusable arithmetic lemmas to the
same proof-attempt file instead of replacing the theorem by more finite tests.

## Cycle 7 Middle Sync: Clean-Source Candidate Audit Accepted

The fixed reverse-index theorem and the clean-source candidate audit now
compile.  This remains part of the GHL2025 Lemma 1 contract:

$$
O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n
=
|r_{si}\rangle^n|i\rangle^n .
$$

The accepted Lean target is:

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

The hypotheses are intentionally explicit.  The assumptions `hkappa` and
`hclog` identify the three-bit sparse-index range used by the current one-term
Robin parameter family; `hn` supplies the grid regime needed by the reverse
roundtrip and address-range blocks; `hclean` supplies the paper's padded-zero
domain condition.

### Proof-DAG Obligations

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `odbs_preimage_candidate_clean_source` | prove that the splice candidate maps back to the post-SWAP column, is clean, and has an n-bit address for every clean one-term source column | `robinSparseReverseColumnRoundtrip_of_lt_eight`, `robinSparseReverseColumnIndex_lt_eight_of_columnMap`, splice/clean-register bit lemmas, `bandedSparseAccessPaperAddressInRange_eq_true_of_two_le` | `bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_cleanSource` | supplied-preimage cleanup witness | proved executable audit; semantic flags false |
| `odbs_post_swap_range` | prove the post-SWAP column is a finite basis column when the source image is finite | SWAP range plus paper-image range | `swapOracleImage_lt_qubitDim`, `bandedSparseAccessPaperPostSwapImage_lt_qubitDim_of_address_lt` | finite `post` constructor for cleanup witness | proved as range block; independent of the later SWAP permutation bridge |
| `odbs_preimage_candidate_range` | prove the candidate is a finite basis column when the source is finite | splice range, reverse sparse-index bound, clean O_D value bound | `bandedSparseAccessPaperSpliceODRegister_lt_qubitDim_of_odValue_lt`, `bandedSparseAccessPaperPostSwapReverseSparse_lt_two_pow`, `bandedSparseAccessPaperPostSwapCleanODValue_lt_two_pow`, `bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_cleanSource` | finite `pre` constructor for cleanup witness | proved under explicit one-term hypotheses; semantic flags false |
| `odbs_cleanup_witness_instantiation` | instantiate `bandedSparseAccessPostSwapCleanup_of_preimage` from the candidate audit without proving uniqueness | clean-source candidate audit, finite `post` and `pre` range lemmas, conditional cleanup witness | `bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate`, `bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate_noRange` | block-extraction cleanup route | no-extra-range conditional wrapper proved; uniqueness and `daggerCleanup.proved` remain false |

The current tests for $n=3$, $n=4$, and all finite sources at $n=3,\kappa=7$
remain executable evidence for the fixed route.  The compiled clean-source
theorem supersedes the stale planned row for
`bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_cleanSource`, but it
still does not close uniqueness or cleanup obligations.

### Completed Lower Packet: Clean-Source Candidate Cleanup Wrapper

This packet adds
`bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate`.  The theorem takes
a finite clean source column in the one-term family, the accepted Boolean audit,
and explicit finite-range hypotheses for
`swapOracleImage p (bandedSparseAccessPaperImage p source.val)` and
`bandedSparseAccessPaperPostSwapPreimageCandidate p source.val`.  It packages
those columns as `Fin` values and feeds
`bandedSparseAccessPostSwapCleanup_of_preimage`.

The wrapper proves only the conditional witness fields already available from
the Boolean audit: active dagger entry, clean padded preimage, preimage address
bound, and the row/address/no-spill audit booleans.  The later no-extra-range
wrapper supplies the finite `post` and `pre` constructors.  Neither wrapper
proves inverse uniqueness, semantic dagger cleanup, or either `O_D^BS`
unitarity flag.

### Next Lower Packet: Range Premises for Candidate Cleanup

The next fixed proof target is not another cleanup record.  It is the range
input needed to call the compiled wrapper
`bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate` without external
`Fin` premises.

| Obligation | Planned declaration | Exact role | Status |
|---|---|---|---|
| post-SWAP finite range | `swapOracleImage_lt_qubitDim`, `bandedSparseAccessPaperPostSwapImage_lt_qubitDim_of_address_lt` | prove that `swapOracleImage p (bandedSparseAccessPaperImage p source.val)` is below `qubitDim (oneTermRobinTotalQubits p)` for a finite source and n-bit paper address | proved as range block; independent of the later SWAP permutation bridge |
| candidate finite range | `bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_cleanSource` | prove that the clean reverse-index candidate is below the same finite basis dimension under the explicit one-term hypotheses | proved |
| no-extra-range cleanup wrapper | `bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate_noRange` | instantiate `BandedSparseAccessPostSwapCleanup` using the two range lemmas, the clean-source Boolean audit, and the existing conditional witness | proved as conditional cleanup witness |
| active global-source cleanup wrapper | `bandedSparseAccessPostSwapCleanup_of_globalSlotSourceCandidate_noRange` | feed `bandedSparseAccessPaperGlobalSlotSource` into the no-extra-range wrapper by extracting the clean padded input field | proved as conditional active-source wrapper |

These range lemmas must not promote `daggerCleanup.proved`, either active
`O_D^BS` unitarity flag, or block correctness.

### Lower Result: Finite-Range Inputs Accepted

The post-SWAP range route is now Lean-checked.  `swapOracleImage_lt_qubitDim`
keeps the SWAP image inside the full finite basis using the existing SWAP diff
bound and the fact that the swapped register blocks end before
`oneTermRobinTotalQubits`.  The paper-specific wrapper
`bandedSparseAccessPaperPostSwapImage_lt_qubitDim_of_address_lt` composes this
with the active Lemma 1 image range theorem.

The candidate preimage range is also Lean-checked.
`bandedSparseAccessPaperSpliceODRegister_lt_qubitDim_of_odValue_lt` proves the
finite-basis range for an n-bit O_D splice, while
`bandedSparseAccessPaperPostSwapReverseSparse_lt_two_pow` and
`bandedSparseAccessPaperPostSwapCleanODValue_lt_two_pow` provide the one-term
reverse-index and clean-register bounds.  The wrapper
`bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate_noRange` now calls
the earlier conditional cleanup witness without external `Fin` premises.

No O_D^BS semantic flag changed: `daggerCleanup.proved`, both active O_D^BS
unitarity flags, and block correctness remain unproved.

### Cycle 9 Source-Contract Obstruction: Boundary Unused Sparse Collision

Historical note, superseded on 2026-05-24: Lean recorded the row-dependent
address blocker as:

```lean
theorem oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3
```

For $n=3,\kappa=7$, source column `0` has row value $0$ and sparse index $0$.
Source column `48` has the same row value and sparse index $3$.  Both columns
are clean according to `bandedSparseAccessPaperCleanInput`, because the padded
part of the $O_D^{BS}$ register has width $0$ in this parameter instance.
Boundary row $0$ has only three row-dependent stencil entries, so sparse index
$3$ was an unused branch for the old helper.  The old executable address map
sent both branches to address `0`.  The corrected active executable address now
uses the global sparse-slot formula and separates columns `0` and `48`.

This is regression memory for the rejected row-dependent helper.  The active
QBE contract now uses `bandedSparseAccessPaperGlobalSlotSource`; before any
lower agent attempts a permutation proof, QBE still needs one of the following
source-backed interfaces:

| Required correction | Lean-facing target | Status |
|---|---|---|
| global-source inverse-on-range | an injectivity or preimage uniqueness statement over `bandedSparseAccessPaperGlobalSlotSource` | next active target; semantic flags remain false |
| reversible unused-branch extension | a separate image rule for unused branches that agrees with Lemma 1 on valid branches and is injective on the full clean domain | obligation |

The next lower packet must not promote `forwardCorrect.proved`,
`daggerCleanup.proved`, either O_D^BS unitarity flag, or block correctness.
It should produce the source-contract correction or a precise proof obligation,
not another injectivity search over the colliding skeleton.

### Lower Update: Valid Sparse-Branch Domain Candidate

Lean now defines `robinSparseColumnBranchValid` for the row-dependent Robin
stencil domain.  The predicate follows the five row cases used by
`robinSparseColumnMap`: three valid branches at rows $0$ and $N-1$, four at
rows $1$ and $N-2$, and five in the bulk.

The lifted predicates `bandedSparseAccessPaperValidSparseBranch` and
`bandedSparseAccessPaperValidCleanSource` are not wired into the active matrix.
They record the first correction option as a checkable source-domain candidate.
The theorem
`bandedSparseAccessPaperValidCleanSource_separates_boundaryCollision_n3`
proves that columns `0` and `48` are both clean under the current padded-zero
predicate, but only column `0` is valid under the candidate corrected domain.

Remaining obligations:

| Obligation | Status |
|---|---|
| paper-source audit for row-dependent sparse-domain restriction | complete for cycle 10: as a standalone source-domain restriction this is contract drift, because the Robin construction keeps zero-amplitude sparse branches in the $\kappa$-wide register |
| replace or refine the active source-domain contract | open; no matrix or proof flag changed |
| reversible extension for unused branches if the paper does not restrict them | open |
| injectivity, dagger cleanup, and O_D^BS unitarity | open; do not attempt over the current colliding skeleton |

Acceptance for the next lower attempt:

```bash
python3 tools/qbe.py check
lake build && lake build Tests
rg -n "Prop := True|:= trivial|sparseCorrect := True|amplitudeCorrect := True|lcuCorrect := True|\\bsorry\\b" QuantumBlockEncoding Tests -g '!QuantumBlockEncoding/Automation.lean' || true
```

The attempt must leave all O_D^BS, SWAP, dagger-cleanup, and block-correctness
semantic flags unchanged unless a reviewer separately approves a proof-flag
promotion.

### 2026-05-23 Middle Source-Contract Audit: Unused Sparse Branches

The source audit checked GHL2025 arXiv:2506.20478v2 against the cycle 9 valid
branch candidate.  Lemma `Banded-sparse-access-oracle and resource cost` gives
the register equation

$$
\hat O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n
=
|r_{si}\rangle^n|i\rangle^n .
$$

The Robin one-term section then states that zeros can be included in the set of
nonzero elements and uses the diagonal sparsity $\kappa$.  Eq. `ROBIN
clarified` sums over $s=0,\dots,\kappa-1$.  Thus the faithful source contract
does not simply remove row-boundary sparse indices that carry zero amplitude.
The Lean predicate `bandedSparseAccessPaperValidCleanSource` remains useful for
classifying nonzero stencil branches, but using it alone as the domain of
`O_D^BS` would drop paper branches.

The concrete effect is:

| Item | Status after audit |
|---|---|
| `robinSparseColumnBranchValid` | keep as a nonzero-stencil branch classifier |
| `bandedSparseAccessPaperValidCleanSource` | keep as an audit predicate, not the active source domain |
| current `bandedSparseAccessPaperImage` on invalid zero branches | contract drift for unitarity, because it can collide on clean columns |
| faithful fix | define or record a reversible unused-branch extension that agrees with Lemma 1 on valid branches |

No semantic flag is promoted by this audit.  In particular,
`forwardCorrect.proved`, `daggerCleanup.proved`,
`oneTermRobinGate_O_D_BS.unitary.proved`,
`oneTermRobinGate_O_D_BS_dagger.unitary.proved`, and block
correctness remain false.

### Next Lower Packet: O_D^BS Unused-Branch Extension Contract

Target files:

| File | Scope |
|---|---|
| `QuantumBlockEncoding/GHL2025.lean` | add contract declarations for unused sparse branches; do not rewire active matrices |
| `Tests/Basic.lean` | focused false-flag and collision-classification tests |
| `conversion-windows/QBE-AUTO-002.md` and this ledger | synchronize the source-contract audit |
| `research-wiki/cited-results/GHL2025.md` | keep GHL2025 Lemma 1 at `contract-only`; record any new dependency as `obligation` |

Fixed Lean-facing targets:

| Target | Required shape |
|---|---|
| unused-branch predicate | `bandedSparseAccessPaperUnusedSparseBranch p j` should mean clean padded input plus invalid row-dependent sparse branch |
| extension contract | a record such as `BandedSparseAccessUnusedBranchExtensionContract` with fields for valid-branch agreement, unused-branch image rule, unused-branch injectivity, full clean-domain injectivity, dagger cleanup, and unitary extension |
| proof flags | every new semantic field starts with `proved := false` |
| collision classifier | for $n=3,\kappa=7$, column `0` is row-dependent-valid, column `48` is row-dependent-unused, both are clean, and the rejected row-dependent image collides while the corrected active image separates them |
| active-matrix guard | `oneTermRobinGate_O_D_BS` and `oneTermRobinGate_O_D_BS_dagger` remain definitionally the current paper-image matrix pair |

This packet must not prove or claim O_D^BS injectivity, unitarity, dagger
cleanup, or block correctness.  It only creates the faithful contract slot
needed before those fixed proofs can be attempted.

### Lower Result: Unused-Branch Extension Contract Accepted

Lean now defines the unused-branch classifier
`bandedSparseAccessPaperUnusedSparseBranch`.  It is true for clean padded
columns whose sparse index is outside the row-dependent nonzero-stencil
classifier.  The implications
`bandedSparseAccessPaperUnusedSparseBranch_cleanInput_eq_true` and
`bandedSparseAccessPaperUnusedSparseBranch_validSparseBranch_eq_false` expose
the two classifier facts needed by later extension work.

The record `BandedSparseAccessUnusedBranchExtensionContract` is the new
proof-obligation slot for the reversible completion on zero-amplitude branches.
Its fields for valid-branch agreement, unused-branch image rule, unused-branch
injectivity, full clean-domain injectivity, dagger cleanup, and unitary
extension all have `proved = false`; the theorem
`bandedSparseAccessUnusedBranchExtensionContract_flags_false` pins that status.

The historical collision classifier
`bandedSparseAccessUnusedBranchExtensionContract_boundaryCollision_n3` now
belongs to the rejected row-dependent source-domain audit.  For
$n=3,\kappa=7$, source column `0` is a valid clean source and source column
`48` is outside the row-dependent valid-source predicate, but the corrected
active global-slot image separates those columns.  This preserves the old
obstruction as regression memory instead of treating it as the active paper
blocker.

The wrappers
`bandedSparseAccessPostSwapCleanup_of_validCleanSourceCandidate_noRange` and
`bandedSparseAccessPostSwapCleanup_of_globalSlotSourceCandidate_noRange` feed
source predicates into the existing clean-source cleanup candidate by
extracting the clean-input proof.  The global-source wrapper is the active
faithful bridge; the valid-clean-source wrapper remains historical audit
memory.  Neither wrapper closes inverse uniqueness, semantic dagger cleanup,
O_D^BS unitarity, LCU correctness, or block correctness.

### Middle Update: Unused-Branch Classifier Bridge

The accepted Lean bridge
`bandedSparseAccessUnusedBranchExtensionContract_of_unusedBranch` packages the
contract facts needed before an unused-branch image rule is proposed.  For an
input satisfying `bandedSparseAccessPaperUnusedSparseBranch p j = true`, Lean
now proves that the extension contract has `cleanInput = true`,
`validSparseBranch = false`, `unusedSparseBranch = true`, and that the
`unusedBranchImageRule`, `unusedBranchInjective`,
`fullCleanDomainInjective`, `daggerCleanup`, and `unitaryExtension` fields all
remain `proved = false`.

This is an obligation bridge, not an image rule.  It does not repair the
boundary collision and does not change `bandedSparseAccessPaperImage`,
`bandedSparseAccessPaperMatrix`, or either active O_D^BS gate.

Next lower packet:

| Target | Lean-facing contract | Acceptance |
|---|---|---|
| unused-branch image-rule interface | add a declaration or successor contract field that represents the reversible image rule for clean invalid sparse branches, separate from the current active image | if no faithful paper-backed formula is available, leave the field as an explicit obligation with `proved = false` |
| valid-branch agreement | record that any extension must agree with `bandedSparseAccessPaperImage` on `bandedSparseAccessPaperValidCleanSource` columns | theorem or obligation field; no active matrix rewrite |
| guard tests | pin `bandedSparseAccessUnusedBranchExtensionContract_of_unusedBranch`, the $n=3,\kappa=7$ collision classifier, and false proof flags | `python3 tools/qbe.py check`, `lake build`, and `lake build Tests` pass |

Do not attempt injectivity or unitarity for the current colliding skeleton.
The next fixed proof target is the image-rule contract itself.

### Lower Result: Unused-Branch Image-Rule Interface Accepted

Lean now defines `BandedSparseAccessUnusedBranchImageRuleContract` and
`bandedSparseAccessUnusedBranchImageRuleContract`.  This record is the
image-rule interface requested by the classifier bridge: it stores the source
column, extracted paper registers, current active image, branch booleans, and a
`proposedImageIndex` field.

No faithful reversible image formula was introduced in this lower packet.
The default contract keeps `proposedImageIndex = none`, and the fields
`imageSpecified`, `imageFinite`, `separatesActiveCollision`, and
`validBranchAgreement` all remain `proved = false`.  The theorem
`bandedSparseAccessUnusedBranchImageRuleContract_flags_false` pins those
statuses, while
`bandedSparseAccessUnusedBranchImageRuleContract_of_unusedBranch` proves that a
column satisfying `bandedSparseAccessPaperUnusedSparseBranch p j = true` is
classified as clean, invalid, and unused inside the image-rule interface.

`BandedSparseAccessUnusedBranchExtensionContract` now contains the nested
image-rule contract, and its `unusedBranchImageRule` field is sourced from the
nested `imageSpecified` obligation.  This does not change
`bandedSparseAccessPaperImage`, `bandedSparseAccessPaperMatrix`,
`oneTermRobinGate_O_D_BS`, or `oneTermRobinGate_O_D_BS_dagger`; injectivity,
cleanup, and unitarity remain open.

### Middle Sync: Full Clean-Domain Extension Wrapper Packet

The next fixed lower target is a paper-level wrapper around the already
accepted per-column image-rule interface.  The goal is not to choose an image
for unused branches and not to prove injectivity.  It is to make the full
clean-domain proof obligation visible as a single Lean contract before later
proof search depends on it.

Source contract:

$$
O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n
=
|r_{si}\rangle^n|i\rangle^n .
$$

The one-term Robin source audit says zero-amplitude sparse branches stay in the
$\kappa$-wide sparse register.  Therefore a faithful full clean-domain route
must combine:

| Component | Existing Lean anchor | Status |
|---|---|---|
| clean padded input | `bandedSparseAccessPaperCleanInput` | executable predicate; proof flags false |
| valid nonzero-stencil branch classifier | `bandedSparseAccessPaperValidCleanSource` | audit predicate; not the full faithful domain |

## 2026-05-24 Middle Global-Source Predicate Sync

The active Lemma 1 source-domain predicate is now
`bandedSparseAccessPaperGlobalSlotSource`, defined as clean padded input and
sparse index $s<\kappa$.  The row-dependent predicates
`bandedSparseAccessPaperValidCleanSource` and
`bandedSparseAccessPaperUnusedSparseBranch` remain available only as
rejected-model or audit helpers.

| Obligation | Declaration | Status |
|---|---|---|
| global sparse slot range | `bandedSparseAccessPaperSparseIndexInKappa` | executable predicate; no semantic flag promoted |
| active global clean source | `bandedSparseAccessPaperGlobalSlotSource` | executable predicate; padded clean input plus $s<\kappa$ |
| old collision columns are active sources | `bandedSparseAccessPaperGlobalSlotSource_boundaryColumns_n3` | proved regression: columns `0` and `48` are both active global sources, while the row-dependent helper rejects `48` |
| encoded out-of-range slot | `bandedSparseAccessPaperGlobalSlotSource_encodedOutOfRange_n3` | proved regression: encoded `s=7` is outside the $\kappa=7$ source range |

Next lower work should target one finite-image or injectivity fact over
`bandedSparseAccessPaperGlobalSlotSource`.  Do not reopen
`QBE.ODBS.UnusedZeroBranchExtension` as the active blocker unless a reviewer
explicitly asks for a rejected-model audit.
| clean unused-branch classifier | `bandedSparseAccessPaperUnusedSparseBranch` | defined classifier for invalid zero-amplitude branches |
| unused-branch image-rule slot | `BandedSparseAccessUnusedBranchImageRuleContract` | `proposedImageIndex = none`; image-rule fields false |
| full clean-domain extension slot | `BandedSparseAccessFullCleanDomainExtensionContract` | wrapper defined; nested `proposedImageIndex = none`; all semantic fields false |

Lower packet result:

| Target | Required shape | Guard |
|---|---|---|
| full clean-domain contract record | `BandedSparseAccessFullCleanDomainExtensionContract` with source anchor, valid/unused branch predicate names, nested per-column contracts, and `ObligationRecord` fields for valid-branch agreement, unused-branch image specified/finite, unused-branch injectivity, full clean-domain injectivity, dagger cleanup, and unitary extension | no `Prop := True`, `trivial`, `sorry`, or proof-flag promotion |
| default contract value | `bandedSparseAccessFullCleanDomainExtensionContract (p : OneTermRobinParameters)` | uses existing per-column contract interfaces; nested unused-branch image remains unspecified unless a cited source is added |
| false-flag theorem | `bandedSparseAccessFullCleanDomainExtensionContract_flags_false` | every new semantic field has `proved = false`; nested image-rule status remains `proposedImageIndex = none` |
| active-matrix guard tests | tests in `Tests/Basic.lean` | active forward/dagger matrices remain `bandedSparseAccessPaperMatrix` and `bandedSparseAccessPaperDaggerMatrix`; O_D^BS unitarity, dagger cleanup, and block-correctness flags remain false |

No cited reversible-extension theorem is currently recorded.  If lower work
uses one, add a new `research-wiki/cited-results/GHL2025.md` row before using
it as a dependency.  Until then, the full clean-domain contract remains an
obligation map only.

### Middle Sync: Full Clean-Domain Wrapper Accepted

The accepted lower result compiles the paper-level wrapper requested above.
Lean declarations now present the full clean-domain extension as an obligation
map, not as a proof of the oracle:

| Item | Lean declaration | Status |
|---|---|---|
| wrapper record | `BandedSparseAccessFullCleanDomainExtensionContract` | defined |
| default wrapper | `bandedSparseAccessFullCleanDomainExtensionContract` | defined from existing clean, valid-branch, unused-branch, and image-rule contracts |
| false-flag theorem | `bandedSparseAccessFullCleanDomainExtensionContract_flags_false` | proves `cleanDomainSplit`, `validBranchAgreement`, unused-image, injectivity, cleanup, and unitary-extension obligations are false |
| unused-branch bridge | `bandedSparseAccessFullCleanDomainExtensionContract_of_unusedBranch` | exposes clean/invalid/unused classifier fields and keeps image and unitarity obligations false |
| local clean-domain split | `bandedSparseAccessPaperCleanDomainSplit_iff`, `bandedSparseAccessPaperCleanDomainSplit_disjoint`, `bandedSparseAccessFullCleanDomainExtensionContract_localCleanDomainSplit` | proves the executable clean padded-input classifier is partitioned into valid and unused branches, while the semantic `cleanDomainSplit` flag remains false |
| guard tests | `Tests/Basic.lean` | pin nested `proposedImageIndex = none`, false wrapper flags, and unchanged active O_D^BS matrices |

This is the end of the current source-contract audit packet.  The next fixed
target remains blocked on an actual unused-branch image formula or a cited
reversible-extension theorem.  Until such a source is recorded, do not promote
`forwardCorrect`, `daggerCleanup`, O_D^BS unitarity, or block
correctness flags.

### Middle Dependency Decision: Unused Zero-Amplitude Sparse Branches

The cycle-14 source-contract audit records a blocking dependency rather than a
new lower proof target.  GHL2025 Lemma 1 and Fig. 1-term Robin state the
register-level map

$$
O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n
=
|r_{si}\rangle^n|i\rangle^n .
$$

The QBE audit also records that the one-term Robin construction keeps
zero-amplitude sparse branches inside the $\kappa$-wide sparse register.  No
accepted paper formula or external reversible-extension theorem currently
specifies an injective image for those clean unused branches.  The cited-results
ledger therefore contains `QBE.ODBS.UnusedZeroBranchExtension` with status
`obligation`.

The imported sparse-access primitive itself is classified as
`external-cited-result`.  GHL2025 Lemma 1 cites the earlier PDE block-encoding
paper by Guseynov, Huang, and Liu, "Efficient explicit gate construction of
block-encoding for Hamiltonians needed for simulating partial differential
equations", arXiv:2405.12855v3 and Phys. Rev. Research 7, 033100 (2025).  The
cited-results row `GHL2024.PDE.Def6Lemma1.ODBS` records the prior paper's
Definition 6 and Lemma 1 for the same padded-register map and resource counts.
That prior-paper dependency is not a reversible-extension theorem for Robin
unused zero branches, so it does not change any required false flag below.

Required status until a human supplies or approves a source:

| Obligation | Lean anchor | Required status |
|---|---|---|
| unused zero-branch source decision | `bandedSparseAccessUnusedZeroBranchSourceDecision` | `lowerProofSearchAllowed = false` and `dependency.proved = false` |
| prior PDE source transcript | `bandedSparseAccessPriorPDESourceContract` | records arXiv:2405.12855v3 Definition 6, Lemma 1, and the appendix decomposition; `robinUnusedBranchImageRule = none`, `closesUnusedZeroBranchExtension = false` |
| unused zero-branch image choice | `BandedSparseAccessUnusedBranchImageRuleContract.proposedImageIndex` | `none` |
| image-rule proof-search guard | `bandedSparseAccessUnusedZeroBranchSourceDecision_keepsImageRuleUnspecified` | direct and full-wrapper image-rule slots stay `none`; image-specified and collision-separation obligations stay false |
| paper-contract proof-search guard | `bandedSparseAccessUnusedZeroBranchSourceDecision_keepsPaperContractFlagsFalse` | `defaultBandedSparseAccessPaperContract p`.forwardCorrect, `.daggerCleanup`, and `.unitaryExtension` stay `proved = false` while lower proof search is disabled |
| theorem-route source-obligation guard | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_sourceObligationsFalse` | unused-zero-branch dependency, Robin zero-inclusion image/reversible-extension obligations, prior PDE resource claim, block projection, and block correctness stay `proved = false` |
| unused-branch image specified | `BandedSparseAccessFullCleanDomainExtensionContract.unusedBranchImageSpecified` | `proved = false` |
| unused-branch finite image | `BandedSparseAccessFullCleanDomainExtensionContract.unusedBranchImageFinite` | `proved = false` |
| unused-branch injectivity | `BandedSparseAccessFullCleanDomainExtensionContract.unusedBranchInjective` | `proved = false` |
| full clean-domain injectivity | `BandedSparseAccessFullCleanDomainExtensionContract.fullCleanDomainInjective` | `proved = false` |
| dagger cleanup | `BandedSparseAccessFullCleanDomainExtensionContract.daggerCleanup`, `defaultBandedSparseAccessPaperContract p`.daggerCleanup | `proved = false` |
| unitary extension | `BandedSparseAccessFullCleanDomainExtensionContract.unitaryExtension`, `oneTermRobinGate_O_D_BS p`.unitary | `proved = false` |

Proof-DAG row:

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `odbs_unused_zero_branch_source_decision` | historical source-decision guard for the old row-dependent unused-branch route | `GHL2024.PDE.Def6Lemma1.ODBS`, `QBE.ODBS.UnusedZeroBranchExtension`, unused-branch classifier, full clean-domain wrapper | `BandedSparseAccessUnusedZeroBranchSourceDecision`, `bandedSparseAccessUnusedZeroBranchSourceDecision`, `bandedSparseAccessUnusedZeroBranchSourceDecision_flags_false`, `bandedSparseAccessUnusedZeroBranchSourceDecision_keepsImageRuleUnspecified`, `bandedSparseAccessUnusedZeroBranchSourceDecision_keepsPaperContractFlagsFalse`, `BandedSparseAccessPriorPDESourceContract`, `bandedSparseAccessPriorPDESourceContract`, `bandedSparseAccessPriorPDESourceContract_blocks_unusedZeroBranch`, `bandedSparseAccessUnusedBranchImageRuleContract`, `BandedSparseAccessFullCleanDomainExtensionContract` | rejected-model audit memory | superseded for active O_D^BS work by `odbs_global_source_domain`; the prior PDE Definition 6, Lemma 1, and appendix decomposition remain useful source transcripts but do not close global-source injectivity, dagger cleanup, or unitarity |

The next lower packet should be a source-contract packet only.  It may add an
exact cited theorem or a paper-backed image formula, but it must not attempt
injectivity, unitarity, dagger cleanup, or block correctness before this
obligation is resolved.

### Source Dependency Audit Rule for Next Cycles

For the O_D^BS blocker and any later faithful-paper blocker, middle must read
the local GHL2025 TeX source and bibliography before issuing more lower proof
search.  Public artifacts should cite arXiv:2506.20478 and stable paper
anchors rather than a private working-source path.

Each blocked proof block must be classified as one of:

| Classification | Meaning | Required action |
|---|---|---|
| `internal-paper-step` | the paper states/proves the needed fact locally | create a fixed Lean interface tied to the paper anchor |
| `external-cited-result` | the paper relies on another paper or named subroutine | add a precise `research-wiki/cited-results/GHL2025.md` row before lower work |
| `classical-lean-lemma` | the missing fact is arithmetic, finite-map, or matrix algebra | assign a local reusable Lean lemma/proof-DAG block |
| `source-contract-gap` | the paper does not specify enough gate-level data for QBE's stricter oracle contract | keep semantic flags false and request a source-backed contract or human decision |

Reviewer must reject lower packets that continue tactic search on a blocked
faithful-paper statement without this classification.

If the local TeX source contains a proof or proof sketch, the next middle
packet must also add a proof-translation map.  Each source proof step should be
classified as an existing Lean declaration, a new local Lean lemma target, an
external cited-results dependency, or a source-contract gap.  Upper should not
assign broad lower proof search until this map exists.

### Middle Contract: One-Term Theorem Route

This cycle adds a theorem-level route object for the one-term Robin
block-encoding statement.  The route packages existing declarations; it does
not prove the final block equation.

| Item | Lean declaration | Required status |
|---|---|---|
| route structure | `Examples.RobinHeat.OneTermRobinBlockEncodingProofRoute` | defined |
| default route | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n` | defined from existing theorem data, circuit semantics, block target, oracle composition, and cited blockers |
| normalizer bridge | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_normalizer` | theorem normalizer equals block-target normalizer |
| block-target bridge | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_blockTarget` | compiled guard that the route reuses `oneTermRobinBlockExtractionTarget n`, the same circuit semantics object, target `robinDerivativeMatrix n`, and signal index $0$ |
| false-flag guard | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_flags_false` | compiled guard that all listed semantic blockers remain false |
| O_D^BS source-blocker guard | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsSourceBlockers` | compiled guard that the unused-zero-branch decision disables lower proof search, the prior PDE transcript supplies no Robin unused-branch image rule, and O_D^BS contract flags remain false |
| prior PDE transcript guard | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_priorPDESourceTranscript` | compiled guard that the route only imports the prior sparse-access equation as a transcript, leaves the prior resource claim unproved, leaves the Robin unused-branch image rule unspecified, and keeps lower proof search disabled |
| active O_D^BS gate-pair guard | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairBlocked` | compiled guard that the route blocker leaves the active forward and dagger gate unitary fields false and leaves sparse-access cleanup/unitary contract fields false |

The route fixes these Lean-facing links:

| Link | Route field | Status |
|---|---|---|
| theorem tuple | `theoremData = defaultOneTermRobinTheoremData (oneTermParameters n)` | recorded |
| circuit matrix product | `circuitSemantics = oneTermRobinCircuitSemantics n` | recorded |
| block target | `blockClaim.target = oneTermRobinBlockExtractionTarget n` | recorded |
| target matrix | `targetMatrixMatchesSpec` | target is `robinDerivativeMatrix n` |
| signal projection | `signalIndexZero` | signal index is `0` |
| O_D^BS blocker | `unusedZeroBranchBlocked` | lower proof search remains disabled |
| prior sparse-access source | `priorSourceDoesNotCloseOdbs`, `oneTermRobinBlockEncodingProofRoute_priorPDESourceTranscript` | prior PDE transcript records only the padded sparse-access equation; its resource claim and Robin unused-branch extension remain open |
| O_f external theorem | `functionOracleExternalOpen` | cited theorem remains an obligation, not a Lean proof |

Remaining theorem-level obligations:

| Obligation | Lean anchor | Status |
|---|---|---|
| block projection | `oneTermRobinBlockEncodingProofRoute_flags_false` via `blockProjectionOpen` | false |
| block correctness | `oneTermRobinBlockEncodingProofRoute_flags_false` via `blockCorrectOpen` | false |
| full circuit unitarity | `oneTermRobinBlockEncodingProofRoute_flags_false` via `theoremCircuitUnitaryOpen` | false |
| O_D^BS cleanup/unitary extension | `sparseAccessCleanupOpen`, `sparseAccessUnitaryOpen` | false |
| O_f amplitude correctness | `functionOracleOpen` | false |
| LCU/block composition | `lcuOpen` | false |

This route is now the fixed theorem-level interface for future lower packets.
Future proof work should target one listed blocker at a time and must not use
this route to bypass the source-dependency audit.

### Middle Closeout: Source-Contract Gate

The current cycle is blocked on `QBE.ODBS.UnusedZeroBranchExtension`, not on
Lean tactic search.  GHL2025 Lemma 1 supplies the padded sparse-access map

$$
O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n
=
|r_{si}\rangle^n|i\rangle^n,
$$

and the Fig. 1-term Robin text requires cleanup by $(O_D^{BS})^\dagger$ back
to sparse-index form with the padded qubits restored to $|0\rangle$.  The
audit found no accepted paper-backed or external theorem that specifies an
injective reversible image for clean unused zero-amplitude sparse branches.

No lower packet is assigned for O_D^BS injectivity, dagger cleanup, unitarity,
LCU closure, or final block extraction.  The next allowed O_D^BS packet is only
a source-contract packet that records an exact cited theorem or image formula
first.  Until that source exists, these Lean anchors must remain false or
unspecified:

| Anchor | Required state |
|---|---|
| `bandedSparseAccessUnusedZeroBranchSourceDecision.lowerProofSearchAllowed` | `false` |
| `bandedSparseAccessUnusedZeroBranchSourceDecision.dependency.proved` | `false` |
| `BandedSparseAccessUnusedBranchImageRuleContract.proposedImageIndex` | `none` |
| `BandedSparseAccessFullCleanDomainExtensionContract.fullCleanDomainInjective.proved` | `false` |
| `(defaultBandedSparseAccessPaperContract p).forwardCorrect.proved` | `false` |
| `(defaultBandedSparseAccessPaperContract p).daggerCleanup.proved` | `false` |
| `(defaultBandedSparseAccessPaperContract p).unitaryExtension.proved` | `false` |
| `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_flags_false` | keeps block projection, block correctness, O_f amplitude correctness, and LCU correctness false |

Lower guard-only follow-up: `Tests/Basic.lean` now has a concrete `n = 3`,
`j = 48` source-contract guard tying
`bandedSparseAccessUnusedZeroBranchSourceDecision.lowerProofSearchAllowed =
false`, `BandedSparseAccessUnusedBranchImageRuleContract.proposedImageIndex =
none`, route-level `blockCorrect.proved = false`, and route-level
`sparseAccessContract.unitaryExtension.proved = false`.  This adds no new
paper source, chooses no unused-branch image, and promotes no `O_D^BS` proof
flag.

Lower index-audit follow-up: `QuantumBlockEncoding/RobinMatrix.lean` now has
`Examples.RobinHeat.oneTermRobinBlockExtractionTarget_signalZeroBlockIndices`
and
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_signalZeroBlockIndices`.
They record that the selected signal index is `0`, so the block-projection row
and column offsets are exactly the system indices.  The proofs use the target
or theorem-route signal-index-zero field, and the focused test consumes the
theorem-route guard.  This is only an indexing convention check; block
projection, block correctness, O_D^BS cleanup/unitarity, O_f amplitude
correctness, and LCU correctness remain false.

### 2026-05-23 Middle Audit Refresh: No Lower Packet

The source-dependency audit was refreshed against GHL2025 Lemma
`lemma: Banded-sparse-access`, Theorem `theorem: 1 term robin`, Eq.
`eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, and the bibliography entry
`guseynov2024efficientPDE`.  The classification remains unchanged:

| Blocked or audited step | Classification | Required status |
|---|---|---|
| clean unused zero-amplitude sparse branches for $O_D^{BS}$ | `source-contract-gap` | no image formula is selected; direct and wrapper image-rule slots stay `none` |
| prior PDE sparse-access primitive | `external-cited-result` | transcript and resource source only; does not close the Robin unused-branch extension |
| SWAP permutation matrix | `classical-lean-lemma` | compiled and reusable; unrelated to O_D^BS cleanup |
| final one-term block equation | `internal-paper-step` with open dependencies | block projection and block correctness flags stay false |

No lower proof-search packet is assigned for O_D^BS injectivity, dagger
cleanup, O_D^BS unitarity, LCU closure, or final block extraction.  A future
lower packet must first add either an exact source-backed image rule for the
unused branches or a cited reversible-extension theorem, and the cited-results
row must remain `obligation` unless a build-tested Lean declaration closes it.

### 2026-05-23 Middle Post-Lower Sync: Claim-Level Guard

The latest lower addendum is accepted as transcript and guard work only.  It
adds no new paper dependency and does not change the theorem, target matrix,
normalizer, active gate matrices, or signal index.  The Lean-facing result is
that the theorem route now pins both block-obligation layers:

| Layer | Lean guard | Required state |
|---|---|---|
| circuit claim | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_claimBlockCorrectFalse` | `blockClaim.blockCorrect.proved = false` |
| target projection | same guard | `blockClaim.target.blockProjection.proved = false` |
| target block equation | same guard | `blockClaim.target.blockCorrect.proved = false` |
| signal-zero index offsets | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_signalZeroBlockIndices` | row offset is `i`; column offset is `j` |

The source-dependency classification remains unchanged: the final block
equation is an `internal-paper-step` blocked by the recorded O_D^BS
`source-contract-gap`, the O_f external amplitude-oracle obligation, and the
unformalized LCU/block-composition obligation.  Do not assign lower proof
search for the final block equation until those dependencies are closed or
replaced by accepted source-backed contracts.

### 2026-05-23 Lower Addendum: Circuit Product Order Test

The lower pass added a focused backend test for `evalGateMatrices`.  Two
one-qubit test matrices `testDiagonalGateMatrix` and `testFlipGateMatrix` check
that a circuit list `[D, X]` evaluates as the matrix product $X D$, matching the
right-action convention documented in `CircuitSemantics.lean`.  These are test
matrices only; their `SemanticObligation.proved` fields remain `false`, and no
paper oracle, block-projection, or block-correctness flag was promoted.

### 2026-05-23 Lower Addendum: Route Circuit Product Guard

The lower pass added the structural theorem
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_circuitProduct`.  The
guard records that the theorem-level route still uses
`oneTermRobinCircuitSemantics n`, the active seven-gate placeholder list
`GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters n)`, the proved
gate-list match, and the `evalGateMatrices` product matrix.  A focused test in
`Tests/Basic.lean` consumes the guard.

This is only backend wiring.  It does not alter the gate list, rewrite any
active paper oracle matrix, change the signal-index-zero target, or promote
block projection, block correctness, O_D^BS cleanup, O_f amplitude correctness,
LCU correctness, or any gate unitarity flag.

### 2026-05-23 Lower Addendum: Active O_D^BS Gate Pair Guard

The lower pass added the structural theorem
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairBlocked`.
It records that the theorem route's unused-zero-branch source decision is still
blocking lower proof search and that both active `O_D^BS` gate records remain
obligation-only:

| Anchor | Required state |
|---|---|
| `unusedZeroBranchDecision.lowerProofSearchAllowed` | `false` |
| `oneTermRobinGate_O_D_BS.unitary.proved` | `false` |
| `oneTermRobinGate_O_D_BS_dagger.unitary.proved` | `false` |
| `sparseAccessContract.daggerCleanup.proved` | `false` |
| `sparseAccessContract.unitaryExtension.proved` | `false` |

This guard adds no paper dependency, selects no unused-branch image rule, and
does not change the active paper-image matrices.  The source-contract
classification remains `source-contract-gap` for
`QBE.ODBS.UnusedZeroBranchExtension`.

### 2026-05-23 Lower Addendum: Robin Zero-Inclusion Source Contract

Lean now has a source transcript for the one-term Robin statement that zeros
may be included in the sparse enumeration:
`GHL2025.BandedSparseAccessRobinZeroInclusionSourceContract` with default
`GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract`.

The transcript records the source-backed inclusion of zero-amplitude branches,
but it does not fill the missing reversible image rule.

| Obligation | Lean anchor | Required status |
|---|---|---|
| zero branches included in sparse enumeration | `bandedSparseAccessRobinZeroInclusionSourceContract.zerosIncludedInSparseEnumeration` | `true` as source transcript |
| unused-branch image rule | `bandedSparseAccessRobinZeroInclusionSourceContract.unusedBranchImageRule` | `none` |
| unused-branch image index | `bandedSparseAccessRobinZeroInclusionSourceContract.unusedBranchImageIndex` | `none` |
| reversible-extension theorem | `bandedSparseAccessRobinZeroInclusionSourceContract.reversibleExtensionTheorem` | `none` |
| source contract closes O_D^BS blocker | `bandedSparseAccessRobinZeroInclusionSourceContract.closesUnusedZeroBranchExtension` | `false` |
| lower proof search | `bandedSparseAccessRobinZeroInclusionSourceContract.lowerProofSearchAllowed` | `false` |

The compiled guards
`bandedSparseAccessRobinZeroInclusionSourceContract_blocks_unusedZeroBranch`
and
`bandedSparseAccessRobinZeroInclusionSourceContract_keepsImageRuleUnspecified`
tie this source transcript to the existing per-column image slot
`proposedImageIndex = none`.  They preserve all O_D^BS cleanup, injectivity,
unitarity, LCU, and block-extraction obligations as open.

### 2026-05-23 Lower Addendum: Route-Wired Zero-Inclusion Transcript

`Examples.RobinHeat.OneTermRobinBlockEncodingProofRoute` now carries the
zero-inclusion transcript as `robinZeroInclusionSource`.  The default route
uses `GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract`.

| Route guard | Role | Status |
|---|---|---|
| `oneTermRobinBlockEncodingProofRoute_robinZeroInclusionTranscript` | ties the route to the zero-inclusion source transcript and keeps lower proof search disabled | proved structural guard |
| `oneTermRobinBlockEncodingProofRoute_odbsSourceBlockers` | now also records that the route-level zero-inclusion source has no unused-branch image rule and does not enable proof search | proved structural guard |
| `oneTermRobinBlockEncodingProofRoute_flags_false` | now includes the route-level zero-inclusion blocker in the false-flag bundle | proved structural guard |

This addendum does not supply a reversible image rule for unused zero-amplitude
sparse branches.  The source-contract classification remains
`source-contract-gap` for `QBE.ODBS.UnusedZeroBranchExtension`.

### 2026-05-23 Middle Addendum: Theorem Layout/Projection Audit

This audit separates the paper theorem's block-encoding layout from the
matrix backend's projection layout.  The theorem states
$m_{\mathrm{theorem}}=\lceil\log_2 n\rceil+\lceil\log_2 G_f\rceil+
\lceil\log_2\kappa\rceil+4$ signal qubits and $2n$ pure ancillas.  The
backend projects all non-system wires, so its signal dimension uses
`GHL2025.effectiveRobinSignalQubits`.

| Obligation | Lean declaration | Status |
|---|---|---|
| theorem signal count equals the layout count | `GHL2025.defaultOneTermRobinTheoremData_signalQubits_eq_layout` | proved definitional bridge |
| theorem pure ancillas equal the layout count | `GHL2025.defaultOneTermRobinTheoremData_pureAncillas_eq_layout` | proved definitional bridge |
| theorem pure ancillas equal the concrete resource count | `GHL2025.defaultOneTermRobinTheoremData_pureAncillas_eq_resource` | proved definitional bridge |
| projection signal qubits equal theorem signal qubits plus the visible padded $O_D^{BS}$ block and one ancilla | `GHL2025.effectiveRobinSignalQubits_eq_layout_signal_plus_visibleWorkspace` | proved arithmetic bridge |
| projection signal qubits equal the theorem-data signal count plus the same visible workspace | `GHL2025.effectiveRobinSignalQubits_eq_theoremData_signal_plus_visibleWorkspace` | proved arithmetic bridge; no cleanup or block flag promoted |
| theorem route keeps resource cleanup and block flags false while recording both counts | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_layoutProjectionAudit` | proved guard; no semantic flag promoted |

The source-dependency classification is unchanged.  The layout tuple is an
`internal-paper-step`; the projection dimension is a `classical-lean-lemma`
over the explicit register partition; the pure-ancilla cleanup claim and final
block equation remain blocked by O_D^BS cleanup, O_f amplitude correctness,
and LCU/block-composition obligations.  Keep
`theoremData.obligations.resourceBound.proved`,
`theoremData.obligations.ancillaCleanup.proved`, `blockProjection.proved`, and
`blockCorrect.proved` equal to `false`.

### 2026-05-24 Middle Packet: Human/Source Decision Boundary

Middle did not issue a lower proof-search packet.  The current blocker is a
source-contract gap, not a failed Lean tactic route.

The fixed public anchors are GHL2025 Lemma `lemma: Banded-sparse-access`,
Theorem `theorem: 1 term robin`, Eq. `eq: ROBIN clarified`, Fig.
`fig:1 term ROBIN`, and the prior-paper cited-results row
`GHL2024.PDE.Def6Lemma1.ODBS`.  They justify the padded register map and the
existence of the sparse-access primitive as a transcript, but they do not give
a Robin-specific reversible image for clean unused zero-amplitude sparse
branches.

Decision boundary:

| Case | Required artifact before lower work | Lower permission |
|---|---|---|
| source-backed unused-branch image rule | exact paper equation, theorem, or author-approved statement | transcribe contract only; keep semantic flags false |
| source-backed reversible-extension theorem | cited-results row with exact theorem statement and Lean target | transcribe contract only; status starts as `obligation` |
| no new source | none | no O_D^BS injectivity, cleanup, unitarity, LCU, or final block-extraction proof search |
| exploratory construction | explicit human approval to leave faithful mode for this subproblem | create a separate exploratory task or open problem |

Required Lean guard state:

| Lean anchor | Required state |
|---|---|
| `bandedSparseAccessUnusedZeroBranchSourceDecision.lowerProofSearchAllowed` | `false` |
| `bandedSparseAccessUnusedZeroBranchSourceDecision.dependency.proved` | `false` |
| `bandedSparseAccessRobinZeroInclusionSourceContract.unusedBranchImageRule` | `none` |
| `bandedSparseAccessRobinZeroInclusionSourceContract.reversibleExtensionTheorem` | `none` |
| `BandedSparseAccessUnusedBranchImageRuleContract.proposedImageIndex` | `none` |
| `(defaultBandedSparseAccessPaperContract p).daggerCleanup.proved` | `false` |
| `(oneTermRobinGate_O_D_BS p).unitary.proved` | `false` |
| `(oneTermRobinGate_O_D_BS_dagger p).unitary.proved` | `false` |
| `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_flags_false` | preserves block, O_f, and LCU blockers |

Proof-DAG update:

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `odbs_human_source_decision` | decide whether faithful work has a source-backed image rule for clean unused branches | `GHL2025.RobinZeroInclusion.ODBS`, `GHL2024.PDE.Def6Lemma1.ODBS`, `QBE.ODBS.UnusedZeroBranchExtension` | existing guards `bandedSparseAccessUnusedZeroBranchSourceDecision_*`, `bandedSparseAccessRobinZeroInclusionSourceContract_*`, `oneTermRobinBlockEncodingProofRoute_robinZeroInclusionTranscript` | O_D^BS injectivity, dagger cleanup, unitary extension, final block extraction | human/source blocker; no lower proof search |

### 2026-05-24 Middle Cycle 1 Audit Refresh

Middle re-read the local TeX around GHL2025 Lemma
`lemma: Banded-sparse-access`, Theorem `theorem: 1 term robin`, Eq.
`eq: ROBIN clarified`, and Fig. `fig:1 term ROBIN`.  The source still gives
the padded register equation for $O_D^{BS}$ and still says zeros may be
included in the sparse enumeration, but it does not give a reversible image
for clean unused zero-amplitude sparse branches.

The source-dependency classification remains:

| Item | Classification | Current Lean anchor | Required state |
|---|---|---|---|
| Lemma 1 padded sparse-access equation | `external-cited-result` imported into GHL2025 | `BandedSparseAccessPaperContract`, `BandedSparseAccessPriorPDESourceContract` | transcript only; proof flags false |
| zero inclusion in the one-term sparse range | `internal-paper-step` | `BandedSparseAccessRobinZeroInclusionSourceContract` | `zerosIncludedInSparseEnumeration = true`; no image rule |
| clean unused zero-amplitude sparse branches | `source-contract-gap` | `QBE.ODBS.UnusedZeroBranchExtension`, `bandedSparseAccessUnusedZeroBranchSourceDecision` | `lowerProofSearchAllowed = false` |
| SWAP register movement | `classical-lean-lemma` | `swapOracleMatrix_is_permutation`, `bandedSparseAccessPaperPostSwap_*` | reusable local block already compiled |

Guard-only lower packet template:

| Field | Instruction |
|---|---|
| fixed Lean guards to reuse | `bandedSparseAccessUnusedZeroBranchSourceDecision_flags_false`, `bandedSparseAccessRobinZeroInclusionSourceContract_blocks_unusedZeroBranch`, `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsNoLowerProofSearch`, `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairBlocked` |
| allowed write scope | source-contract documentation, cited-results rows, and optional focused false-flag tests in `Tests/Basic.lean` |
| forbidden proof search | no O_D^BS injectivity, dagger cleanup, O_D^BS unitarity, LCU closure, or final block-extraction proof search |
| required status after work | `proposedImageIndex = none`, all O_D^BS semantic flags false, and `QBE.ODBS.UnusedZeroBranchExtension` still `obligation` unless a build-tested source-backed contract is accepted |

### 2026-05-24 Lower Guard: O_D^BS Gate-List Positions

Two focused `Tests/Basic.lean` examples now pin the active placeholder list:
`GHL2025.oneTermRobinGateMatrixPlaceholders p` has `O_D^BS` at index `3` and
`(O_D^BS)^dagger` at index `6`.  This guards the circuit-product wiring only.

An additional focused route-level test checks that
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n` carries those same
two active paper-image matrices through its `circuitSemantics.gateMatrices`
list, with both `unitary.proved` fields still `false`.

The test does not supply an unused-branch image rule, does not alter the active
matrices, and does not promote `forwardCorrect`, `daggerCleanup`,
`unitaryExtension`, block projection, block correctness, O_f amplitude, or LCU
flags.

### 2026-05-24 Lower Guard: Route Source-Transcript Identity

A focused `Tests/Basic.lean` example now pins that the theorem-level route
uses exactly the audited O_D^BS source records:

| Route field | Required record |
|---|---|
| `unusedZeroBranchDecision` | `GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision` |
| `priorSparseAccessSource` | `GHL2025.bandedSparseAccessPriorPDESourceContract` |
| `robinZeroInclusionSource` | `GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract` |

This is a guard-only lower packet.  It prevents an alternate theorem-route
source decision from silently bypassing the audited blocker.  It adds no source
equation, no unused-branch image index, no reversible-extension theorem, and no
proof of O_D^BS injectivity, dagger cleanup, unitarity, LCU closure, or final
block extraction.  The active source-contract state remains
`proposedImageIndex = none`, `lowerProofSearchAllowed = false`, and
`QBE.ODBS.UnusedZeroBranchExtension` as an obligation.

The source-transcript identity guard is now promoted to the named Lean theorem
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_sourceTranscriptIdentity`.
It also pins the route-level `lowerProofSearchAllowed = false` fields for the
unused-zero-branch decision and the Robin zero-inclusion transcript.  This is
still a structural guard only; it does not change active matrices or semantic
proof flags.

### 2026-05-24 Middle Maintainer Handoff

The cycle-1 middle source audit remains blocked at the same source-contract
gap.  GHL2025 Lemma `lemma: Banded-sparse-access` and the prior PDE primitive
record the padded sparse-access map, while Eq. `eq: ROBIN clarified` keeps
zeros in the sparse range $s=0,\dots,\kappa-1$.  Neither source gives the
injective reversible image rule needed for clean unused zero-amplitude sparse
branches.

| Obligation | Lean anchor | Required status |
|---|---|---|
| unused zero-branch extension | `QBE.ODBS.UnusedZeroBranchExtension` cited-results row | `obligation` |
| lower proof-search permission | `bandedSparseAccessUnusedZeroBranchSourceDecision.lowerProofSearchAllowed` | `false` |
| unused-branch image slot | `BandedSparseAccessUnusedBranchImageRuleContract.proposedImageIndex` | `none` |
| Robin zero-inclusion transcript | `bandedSparseAccessRobinZeroInclusionSourceContract` | no image rule, no reversible-extension theorem |
| active O_D^BS gate pair | `oneTermRobinGate_O_D_BS`, `oneTermRobinGate_O_D_BS_dagger` | matrices unchanged, unitarity flags false |
| block route guard | `oneTermRobinBlockEncodingProofRoute_odbsNoLowerProofSearch` | compiles and preserves the blocker |

No lower proof-search packet is authorized for O_D^BS injectivity, dagger
cleanup, O_D^BS unitarity, LCU closure, or final block extraction.  The only
permitted lower packet is guard-only: add source-backed transcript fields or
focused false-flag tests, then run `python3 tools/qbe.py check`, `lake build`,
`lake build Tests`, and the forbidden-pattern scan.

### 2026-05-24 Middle Cycle 1 Final Source-Dependency Audit

Middle re-read the source anchors before assigning any further lower work:
GHL2025 Lemma `lemma: Banded-sparse-access`, Theorem
`theorem: 1 term robin`, Eq. `eq: ROBIN clarified`, Fig.
`fig:1 term ROBIN`, and the cited prior sparse-access primitive.  No new
source-backed image rule was found for clean unused zero-amplitude sparse
branches.

| Proof block | Classification | Lean anchor | Required status |
|---|---|---|---|
| padded sparse-access equation | `external-cited-result` imported into GHL2025 | `BandedSparseAccessPaperContract`, `bandedSparseAccessPaperImage` | transcript only |
| zero inclusion in the Robin sparse range | `internal-paper-step` | `BandedSparseAccessRobinZeroInclusionSourceContract` | zeros included; no image rule |
| dagger cleanup in Fig. `fig:1 term ROBIN` | `internal-paper-step` blocked by oracle data | `(defaultBandedSparseAccessPaperContract p).daggerCleanup` | `proved = false` |
| unused zero-amplitude sparse branches | `source-contract-gap` | `QBE.ODBS.UnusedZeroBranchExtension`, `bandedSparseAccessUnusedZeroBranchSourceDecision` | `lowerProofSearchAllowed = false` |

The lower guard packet is accepted as wiring only.  It pins the active O_D^BS
placeholder positions and the theorem-route source transcript, but it does not
promote forward correctness, dagger cleanup, unitary extension, block
projection, block correctness, O_f amplitude correctness, or LCU composition.

Next lower work is restricted to guard-only source-contract maintenance unless
a new source supplies an exact unused-branch image rule or a named reversible
extension theorem.  O_D^BS injectivity, dagger cleanup, O_D^BS unitarity, LCU
closure, and final block extraction remain blocked.

### 2026-05-24 Lower Guard: Named Active Gate-Pair Wiring

Lower promoted the route-level active gate-pair wiring test to the named Lean
guard `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairWiring`.
The guard records that the theorem route carries `O_D^BS` at gate-list index
`3` with matrix `GHL2025.bandedSparseAccessPaperMatrix`, and
`(O_D^BS)^dagger` at gate-list index `6` with matrix
`GHL2025.bandedSparseAccessPaperDaggerMatrix`.

This guard is wiring only.  It also keeps both active gate unitarity flags
false and keeps
`unusedZeroBranchDecision.lowerProofSearchAllowed = false`.  It does not add
an unused-branch image rule, a reversible-extension theorem, an injectivity
claim, a dagger-cleanup proof, a unitary proof, an LCU proof, or a final
block-extraction proof.

### 2026-05-24 Lower Guard: Lemma 1 Paper Contract Transcript

Lower added the named theorem
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript`.
It checks that the theorem-level route still uses the Lemma 1 paper contract
for `O_D^BS`: input `|0>^(n-l)|s>^l|i>^n`, output
`|r_si>^n|i>^n`, image formula `r_si = r_s0 + i mod 2^n`, and the expected
row, padded-zero, sparse-index, and output-address widths from
`oneTermParameters n`.

The guard also keeps the paper-contract semantic flags false:
`cleanInputDomain`, `widthCompatible`, `addressRange`, `noSpill`,
`forwardCorrect`, `daggerCleanup`, and `unitaryExtension` all remain
`proved = false`.  It keeps
`unusedZeroBranchDecision.lowerProofSearchAllowed = false` and does not change
the active forward/dagger matrices.

| Guard | Lean declaration | Status |
|---|---|---|
| O_D^BS paper ket/register transcript | `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript` | compiled structural guard; no semantic flag promoted |
| O_D^BS contract object identity | `oneTermRobinBlockEncodingProofRoute_sparseAccessContractIdentity` | compiled structural guard; route uses `defaultBandedSparseAccessPaperContract`; `forwardCorrect`, `daggerCleanup`, `unitaryExtension`, and lower proof search remain false |

### 2026-05-24 Lower Guard: Robin Zero-Inclusion Keeps O_D^BS Blocked

Lower added the named guard
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_robinZeroInclusionKeepsOdbsBlocked`.
It ties the source transcript saying that zero-amplitude sparse branches remain
in the `s = 0, ..., kappa - 1` range to the existing blocker state:
`unusedBranchImageRule = none`, both lower-proof-search fields are false, the
paper-contract `forwardCorrect`, `daggerCleanup`, and `unitaryExtension` flags
are false, and both active O_D^BS gate unitarity flags are false.

This is a source-contract guard only.  It does not add a reversible image rule,
change either active matrix, or promote cleanup, unitarity, LCU, or block
extraction.

### 2026-05-24 Middle Guard Packet Closeout

This middle pass did not authorize new O_D^BS proof search.  Re-reading the
GHL2025 anchors left the blocker unchanged: Lemma `lemma:
Banded-sparse-access` and the prior PDE primitive give the padded register
map, while Eq. `eq: ROBIN clarified` keeps zero-amplitude sparse branches in
the range $s=0,\dots,\kappa-1$.  No accepted source gives the injective
reversible image required for clean unused branches.

| Obligation | Lean guard | Required status |
|---|---|---|
| source dependency remains open | `oneTermRobinBlockEncodingProofRoute_sourceObligationsFalse` | dependency and route-level block flags stay false |
| zero-inclusion keeps O_D^BS blocked | `oneTermRobinBlockEncodingProofRoute_robinZeroInclusionKeepsOdbsBlocked` | no image rule, no reversible-extension theorem, no lower proof search |
| Lemma 1 contract is unchanged | `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript` | paper ket/register transcript only; semantic flags false |
| active gate pair is unchanged | `oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairWiring` | paper-image forward and dagger matrices remain wired with unitary flags false |
| source blocker propagates to final flags | `oneTermRobinBlockEncodingProofRoute_sourceBlockerKeepsFinalFlagsFalse` | source dependency and Robin image-rule obligations unproved; lower proof search, active gate-pair unitarity, circuit-unitary, block-extraction, block-correctness, and LCU flags false |

Next lower work is restricted to guard-only source-contract maintenance unless
a new source supplies an exact unused-branch image formula or a named
reversible-extension theorem.  Do not attempt O_D^BS injectivity, dagger
cleanup, unitary extension, LCU closure, or final block extraction from the
current contract.

### 2026-05-24 Middle Audit: Lower Packet Boundary

Middle re-read GHL2025 Lemma `lemma: Banded-sparse-access`, Eq.
`eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, Theorem
`theorem: 1 term robin`, and the cited prior sparse-access primitive before
assigning further lower work.  The source-dependency classification remains a
`source-contract-gap` for clean unused zero-amplitude sparse branches.

| Obligation | Lean anchor | Required status |
|---|---|---|
| Lemma 1 padded sparse-access transcript | `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript` | transcript compiled; semantic proof flags false |
| route uses the default O_D^BS contract | `oneTermRobinBlockEncodingProofRoute_sparseAccessContractIdentity` | no alternate contract may replace it silently |
| unused-branch image slots | `oneTermRobinBlockEncodingProofRoute_sourceDecisionImageSlotsBlocked` | both direct and wrapper `proposedImageIndex` fields remain `none` |
| active gate pair | `oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairWiring`, `oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairBlocked` | paper-image matrices remain wired; both unitarity flags false |
| final theorem flags | `oneTermRobinBlockEncodingProofRoute_sourceBlockerKeepsFinalFlagsFalse` | circuit-unitary, block-extraction, block-correctness, and LCU flags false |

Lower agents may add only source-backed transcript fields or false-flag guard
tests unless a source supplies an exact unused-branch image formula or a named
reversible-extension theorem.  Any such source must first be entered in
`research-wiki/cited-results/GHL2025.md` with status `obligation` or
`contract-only`; it must not be marked `formalized` until a build-tested Lean
declaration exists.

### 2026-05-24 Lower Concrete Guard Test

Lower added one focused regression test in `Tests/Basic.lean` for the recorded
$n=3$ O_D^BS boundary unused-branch collision.  The test keeps the existing
paper-image equality for source columns `0` and `48` tied to the blocker:
`proposedImageIndex = none`, the unused-zero-branch dependency is unproved, and
the theorem-level `circuitUnitary`, `blockExtraction`, and `lcuCorrect` flags
remain `proved = false`.

This packet is guard-only.  It does not introduce an unused-branch image rule,
does not change the active forward or dagger matrices, and does not attempt
O_D^BS injectivity, dagger cleanup, unitary extension, LCU closure, or final
block extraction.

### 2026-05-24 Lower Source-Anchor Guard Test

Lower added a focused source-anchor regression test in `Tests/Basic.lean` for
`GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision`.  The test pins the
public anchor to GHL2025 Lemma 1 and Fig. `fig:1 term ROBIN`, the cited-result
key to `QBE.ODBS.UnusedZeroBranchExtension`, and the dependency source to the
project ledger `research-wiki/cited-results/GHL2025.md`.

The same test keeps `paperImageRuleSpecified = false`,
`externalExtensionTheoremAccepted = false`,
`lowerProofSearchAllowed = false`, and `dependency.proved = false`.  It is a
guard against silently turning the local source audit into a proof ticket.  It
does not add an unused-branch image rule, change either active matrix, or
promote O_D^BS cleanup, unitarity, LCU closure, or final block extraction.

### 2026-05-24 Middle Freeze Sync: O_D^BS Proof Search Disabled

Middle re-audited GHL2025 Lemma `lemma: Banded-sparse-access`, Eq.
`eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, Theorem
`theorem: 1 term robin`, and the cited prior sparse-access primitive after the
upper handoff.  The classification is unchanged: the missing reversible image
for clean unused zero-amplitude sparse branches is a `source-contract-gap`.

| Obligation | Current Lean guard | Required status |
|---|---|---|
| Lemma 1 padded sparse-access transcript | `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript` | transcript only; semantic flags false |
| zero-amplitude sparse branches remain in the paper range | `oneTermRobinBlockEncodingProofRoute_robinZeroInclusionKeepsOdbsBlocked` | no image rule supplied |
| unused-branch image slots | `oneTermRobinBlockEncodingProofRoute_sourceDecisionImageSlotsBlocked` | direct and wrapper `proposedImageIndex = none` |
| active gate pair | `oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairWiring`, `oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairBlocked` | paper-image matrices wired; both unitarity flags false |
| active gate-pair source anchors | `oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairPublicSources` | forward gate cites GHL2025 Lemma 1; dagger gate cites Fig. `fig:1 term ROBIN` and Lemma 1; both unitarity flags false |
| final theorem blockers | `oneTermRobinBlockEncodingProofRoute_sourceBlockerKeepsFinalFlagsFalse` | circuit-unitary, block-extraction, block-correctness, and LCU flags false |

Next lower work is guard-only unless a new source supplies an exact unused
branch image formula or a named reversible-extension theorem.  Do not attempt
$O_D^{BS}$ injectivity, dagger cleanup, unitary extension, LCU closure, or
final block extraction from the current colliding active image skeleton.

### 2026-05-24 Middle Cycle 1 Lower Packet Boundary

Middle re-audited GHL2025 Lemma `lemma: Banded-sparse-access`, Eq.
`eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, Theorem
`theorem: 1 term robin`, and the prior sparse-access citation before assigning
further lower work.  The blocked ingredient is still a `source-contract-gap`:
the paper transcript and prior primitive do not provide an injective reversible
image for clean unused zero-amplitude sparse branches.

The fixed guard declarations for the next lower packet are:

| Obligation | Lean guard | Required status |
|---|---|---|
| Lemma 1 padded sparse-access transcript | `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript` | transcript only; all `BandedSparseAccessPaperContract` semantic fields remain false |
| route uses the default paper contract | `oneTermRobinBlockEncodingProofRoute_sparseAccessContractIdentity` | no alternate O_D^BS contract may replace it silently |
| direct and wrapper image-rule slots | `oneTermRobinBlockEncodingProofRoute_sourceDecisionImageSlotsBlocked` | both `proposedImageIndex` fields remain `none` |
| active O_D^BS gate pair | `oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairWiring`, `oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairPublicSources`, `oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairBlocked` | forward and dagger matrices stay wired to the paper-image skeletons; both unitarity flags remain false |
| final theorem blockers | `oneTermRobinBlockEncodingProofRoute_sourceBlockerKeepsFinalFlagsFalse` | circuit-unitary, block-extraction, block-correctness, and LCU flags remain false |

Allowed lower work is limited to source-backed transcript maintenance,
cited-results synchronization, or false-flag regression tests that consume the
guards above.  Disallowed work is O_D^BS injectivity, dagger cleanup, unitary
extension, active matrix rewrites, O_f analytic closure, LCU composition, signal
index changes, or final block-extraction proof search.

If a new source is supplied, middle must first add an exact cited-results entry
with a source, statement, planned Lean declaration, dependent proof blocks, and
status `obligation` or `contract-only`.  Lower may not mark that dependency
`formalized` or use it to close semantic flags until a build-tested Lean
declaration exists.

### 2026-05-24 Lower Block-Projection Route Guard

Lower added the guard
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit`.
It packages the existing block-projection target facts into one theorem-route
contract:

| Field | Required status |
|---|---|
| route target | `blockClaim.target = oneTermRobinBlockExtractionTarget n` |
| full matrix | target `unitaryMatrix` is the cast matrix from `oneTermRobinCircuitSemantics n` |
| projection | target `blockMatrix` is `signalSystemBlockProjection` at the route signal index |
| signal index | target signal index has value `0` |
| target matrix | `robinDerivativeMatrix n` |
| normalizer | `GHL2025.oneTermRobinNormalizer`, the symbolic $N_DN_f\kappa$ normalizer |
| open flags | `blockProjection`, `blockCorrect`, O_D^BS dagger cleanup, and LCU correctness remain false |

This is a guard-only packet.  It does not change the signal-index-zero
convention, target matrix, normalizer, active O_D^BS matrices, or any semantic
`proved` flag.

### 2026-05-24 Middle Final Source-Gate Handoff

The middle source-dependency audit for this run re-read the GHL2025 anchors
for Lemma `lemma: Banded-sparse-access`, Eq. `eq: ROBIN clarified`, Fig.
`fig:1 term ROBIN`, Theorem `theorem: 1 term robin`, and the cited prior
sparse-access primitive.  The missing ingredient is still a
`source-contract-gap`: no inspected source fragment specifies an injective
reversible image for clean unused zero-amplitude sparse branches.

Proof-translation ledger:

| Source fragment | Lean-facing object | Classification | Required status |
|---|---|---|---|
| Lemma 1 padded map $O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n = |r_{si}\rangle^n|i\rangle^n$ | `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript`, `BandedSparseAccessPaperContract` | `external-cited-result` transcript through `GHL2024.PDE.Def6Lemma1.ODBS` | keep as transcript only; paper-contract semantic fields false |
| Eq. `eq: ROBIN clarified` sums over $s=0,\dots,\kappa-1$ | `BandedSparseAccessRobinZeroInclusionSourceContract`, `oneTermRobinBlockEncodingProofRoute_robinZeroInclusionKeepsOdbsBlocked` | `internal-paper-step` | zero-inclusion visible; no image rule |
| Fig. `fig:1 term ROBIN` says $(O_D^{BS})^\dagger$ restores the padded sparse register after SWAP | `defaultBandedSparseAccessPaperContract.daggerCleanup`, `oneTermRobinBlockEncodingProofRoute_sourceBlockerKeepsFinalFlagsFalse` | `internal-paper-step` blocked by missing oracle data | `daggerCleanup.proved = false` |
| No reversible image for clean unused zero-amplitude sparse branches | `QBE.ODBS.UnusedZeroBranchExtension`, `bandedSparseAccessUnusedZeroBranchSourceDecision` | `source-contract-gap` | lower proof search disabled |

Lower packet:

| Field | Instruction |
|---|---|
| fixed target | guard-only preservation of the O_D^BS source blocker and theorem-route false flags |
| allowed edits | cited-results/source-contract notes, this obligation ledger, conversion-window notes, or focused false-flag tests consuming existing guard declarations |
| declarations to reuse | `oneTermRobinBlockEncodingProofRoute_sourceDecisionImageSlotsBlocked`, `oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairWiring`, `oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairPublicSources`, `oneTermRobinBlockEncodingProofRoute_sparseAccessContractIdentity`, `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript`, `oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit`, `oneTermRobinBlockEncodingProofRoute_sourceBlockerKeepsFinalFlagsFalse` |
| forbidden promotions | O_D^BS injectivity, dagger cleanup, unitary extension, O_f amplitude correctness, LCU correctness, circuit unitarity, block projection, and block correctness |
| blocker exit condition | add a source-backed unused-branch image formula or named reversible-extension theorem to the cited-results ledger before proof work depends on it |

No Lean declaration changed in this middle pass.  The accepted guard state
remains: direct and wrapper `proposedImageIndex` fields are `none`;
`lowerProofSearchAllowed = false`; active forward/dagger O_D^BS matrices are
unchanged; final theorem flags remain false.

### 2026-05-24 Lower Guard Regression Test

Lower added a focused regression test in `Tests/Basic.lean` that combines the
existing block-projection and source-blocker guards:

| Obligation | Guard consumed | Required status |
|---|---|---|
| block projection convention | `oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit` | signal index $0$, normalizer $N_DN_f\kappa$, `blockProjection.proved = false`, and `blockCorrect.proved = false` |
| final theorem blockers | `oneTermRobinBlockEncodingProofRoute_sourceBlockerKeepsFinalFlagsFalse` | `lowerProofSearchAllowed = false`, circuit-unitary false, block-extraction false, and LCU correctness false |

This test is not a new source theorem.  It keeps
`QBE.ODBS.UnusedZeroBranchExtension` as a `source-contract-gap` and does not
close O_D^BS injectivity, dagger cleanup, unitary extension, LCU composition,
or final block extraction.

### 2026-05-24 Lower Source-Gate Freeze Guard

Lower added the guard
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_sourceGateFreeze` and a
matching `Tests/Basic.lean` regression.  The guard packages these existing
facts without changing their status:

| Obligation | Required status |
|---|---|
| unused-zero-branch source decision | `lowerProofSearchAllowed = false` |
| direct and full-wrapper image slots | `proposedImageIndex = none` |
| active O_D^BS gate pair | public GHL2025 anchors and paper-image matrices unchanged |
| block target | normalizer $N_DN_f\kappa$ and signal index $0$ |
| final theorem blockers | circuit-unitary, block-correctness, and LCU flags false |

This is a guard-only declaration.  It does not provide the missing reversible
image for clean unused zero-amplitude sparse branches and does not promote
O_D^BS injectivity, dagger cleanup, unitary extension, LCU closure, or final
block extraction.

### 2026-05-24 Lower Contract-Drift Entry Guard

Lower promoted the concrete regression test for the $n=3,\kappa=7$ source
column `8` to the named Lean guard
`oneTermRobinGate_O_D_BS_contractDrift_column8_n3`.  The active paper-image
gate `oneTermRobinGate_O_D_BS` records the Lemma 1 image entry `(40, 8) = 1`
and the legacy-helper row entry `(4, 8) = 0`; the old
`bandedSparseAccessMatrix` helper still records `(4, 8) = 1`.

The obligation status is unchanged.  This test separates the faithful paper
matrix from the legacy helper and keeps `QBE.ODBS.UnusedZeroBranchExtension`
as a source-contract gap.  It does not close O_D^BS injectivity, dagger
cleanup, unitary extension, LCU closure, or final block extraction.

### 2026-05-24 Lower Rejected-Collision Guard Test

Lower added a focused regression test for the recorded $n=3,\kappa=7$
row-dependent boundary collision and the corrected active-image separation.
The test pins that the old helper still collides on source columns `0` and
`48`, while the active global-slot paper-image matrix maps them to distinct
rows.  The theorem-route `daggerCleanup`, `unitaryExtension`, and
lower-proof-search flags remain false.

This is a regression witness only.  It does not prove injectivity or promote
O_D^BS cleanup, unitarity, LCU closure, or final block extraction.

### 2026-05-24 Middle Post-Lower Obligation Sync

Middle translated the latest lower guards back into the obligation ledger.  The
new compiled route guard is
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_sourceGateFreeze`; the
new focused tests consume that guard plus the existing contract-drift and
active-collision witnesses.  These are proof-state guards, not source theorems.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| active O_D^BS gate uses Lemma 1 image, not the legacy helper | `oneTermRobinGate_O_D_BS_contractDrift_column8_n3`: active paper-image entry `(40, 8) = 1`, active row-`4` entry is `0`, legacy helper row-`4` entry is `1` | active/legacy separation checked; no unitarity or cleanup flag promoted |
| rejected row-dependent image is not injective on the old audit branch | source-column regression: old helper collides on columns `0` and `48`, while the active global-slot image separates them | regression only; no global-source injectivity theorem yet |
| source gate remains frozen | `oneTermRobinBlockEncodingProofRoute_sourceGateFreeze` | `lowerProofSearchAllowed = false`, both image slots `none`, active matrices unchanged, normalizer $N_DN_f\kappa$, signal index $0$, final flags false |

The blocked ingredient is unchanged: a faithful O_D^BS proof needs either an
exact source-backed image rule for clean unused zero-amplitude sparse branches
or a named reversible-extension theorem recorded in the cited-results ledger.
Until then, lower work may add only source-backed transcript maintenance or
false-flag regression tests.

### 2026-05-24 Lower Route-Collision Guard

Lower added the named theorem-route guard
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_activeCollisionBlocked_n3`.
It now packages the $n=3,\kappa=7$ rejected row-dependent collision for source
columns `0` and `48` together with the active global-slot separation and the
route-level false fields.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| rejected row-dependent collision remains visible | `oneTermRobinBlockEncodingProofRoute_activeCollisionBlocked_n3` records the old row-dependent collision and active global-slot separation for columns `0` and `48` | regression witness only |
| unused-branch image rule | the same guard keeps the `proposedImageIndex` field for `bandedSparseAccessUnusedBranchImageRuleContract p 48` equal to `none` | no image selected |
| theorem-route closure flags | the same guard keeps lower proof search, `daggerCleanup`, `unitaryExtension`, and `lcuCorrect` false | no semantic flag promoted |

This guard is not a source theorem and is not an injectivity result.  It only
keeps the historical source-contract audit visible while active work moves to
`bandedSparseAccessPaperGlobalSlotSource`.

### 2026-05-24 Middle Post-Upper Obligation Handoff

Middle rechecked the same source anchors after the upper handoff: GHL2025
Lemma `lemma: Banded-sparse-access`, Eq. `eq: ROBIN clarified`, Fig.
`fig:1 term ROBIN`, Theorem `theorem: 1 term robin`, and the prior
sparse-access citation `guseynov2024efficientPDE`.  The obligation
classification is unchanged.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| rejected row-dependent collision is visible at theorem-route level | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_activeCollisionBlocked_n3` | regression witness only; active global-slot image separates the columns |
| source gate remains frozen | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_sourceGateFreeze` | `lowerProofSearchAllowed = false`, both image slots `none`, active matrices unchanged, final flags false |
| active/legacy O_D^BS separation is guarded | `GHL2025.oneTermRobinGate_O_D_BS_contractDrift_column8_n3` | paper-image gate remains distinct from the legacy helper; no semantic flag promoted |
| unused zero-amplitude branch image rule | `QBE.ODBS.UnusedZeroBranchExtension`, `bandedSparseAccessUnusedZeroBranchSourceDecision` | source-contract gap; no lower proof search |

Next lower work should target the active global-source predicate.  It may add
focused finite-image or injectivity lemmas for
`bandedSparseAccessPaperGlobalSlotSource`, but it must not promote O_D^BS
dagger cleanup, unitary extension, LCU closure, signal-index changes, or final
block extraction.

### 2026-05-24 Middle Global-Source Cleanup Wrapper

Middle added
`GHL2025.bandedSparseAccessPostSwapCleanup_of_globalSlotSourceCandidate_noRange`
after rechecking the source anchors named above.  This wrapper is the active
global-source version of the older row-dependent valid-clean-source bridge.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| active source feeds cleanup candidate | `bandedSparseAccessPostSwapCleanup_of_globalSlotSourceCandidate_noRange` extracts clean padded input from `bandedSparseAccessPaperGlobalSlotSource` and reuses `bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate_noRange` | conditional witness only |
| boundary regression | `Tests/Basic.lean` applies the wrapper at source column `48`, where global source is true and rejected valid-clean source is false | active-source route checked |
| semantic cleanup | `defaultBandedSparseAccessPaperContract.daggerCleanup.proved` and both O_D^BS unitarity fields | remain false |

The next lower packet should move from a per-source conditional cleanup witness
to a fixed global-source injectivity or inverse-on-range interface.  It must
still keep O_D^BS unitarity, LCU closure, and final block extraction out of
scope until that interface compiles.

### 2026-05-24 Lower Route Contract-Drift Guard

Lower added
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_contractDriftColumn8Blocked_n3`
and a matching `Tests/Basic.lean` regression.  The guard records the existing
source-column `8` separation at theorem-route level:

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| active gate uses the Lemma 1 paper image | route gate entry `(40, 8) = 1` for `oneTermRobinBlockEncodingProofRoute 3` | compiled guard only |
| legacy helper remains separate | `bandedSparseAccessMatrix` still has helper entry `(4, 8) = 1`, while the route active gate has `(4, 8) = 0` | active/legacy separation checked |
| theorem-route blockers | the same guard keeps `lowerProofSearchAllowed`, `daggerCleanup.proved`, and block correctness false | no semantic flag promoted |

This does not change the source-dependency classification.  The missing
ingredient remains a source-backed reversible image for clean unused
zero-amplitude sparse branches, recorded as
`QBE.ODBS.UnusedZeroBranchExtension`; lower proof search for $O_D^{BS}$
injectivity, dagger cleanup, unitary extension, LCU closure, and final block
extraction remains disabled.

### 2026-05-24 Lower Projection-Source Freeze Guard

Lower added
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_projectionSourceFreeze`
and pointed the existing projection/source false-flag regression test at that
named guard.  The guard packages the same status:

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| block projection convention | `oneTermRobinBlockEncodingProofRoute_projectionSourceFreeze` | signal index `0`, normalizer $N_DN_f\kappa$, `blockProjection.proved = false`, and `blockCorrect.proved = false` |
| theorem closure flags | `oneTermRobinBlockEncodingProofRoute_projectionSourceFreeze` | `circuitUnitary.proved = false`, `blockExtraction.proved = false`, and `lcuCorrect.proved = false` |
| source blocker | `oneTermRobinBlockEncodingProofRoute_projectionSourceFreeze` | `lowerProofSearchAllowed = false` |

This is a reusable guard block only.  It does not provide an unused-branch
image formula, change an active $O_D^{BS}$ matrix, or promote O_D^BS
injectivity, dagger cleanup, unitarity, LCU closure, or final block extraction.

### 2026-05-24 Middle Cycle-1 Closeout

Middle re-read the source anchors and synchronized the latest lower guards
with this obligation ledger.  The blocked ingredient is still classified as a
`source-contract-gap`: GHL2025 Lemma `lemma: Banded-sparse-access` gives the
padded map, Eq. `eq: ROBIN clarified` keeps $s=0,\dots,\kappa-1$, and Fig.
`fig:1 term ROBIN` asks for dagger cleanup, but no inspected source supplies a
reversible image rule for clean unused zero-amplitude sparse branches.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| active paper image remains distinct from the legacy helper | `oneTermRobinBlockEncodingProofRoute_contractDriftColumn8Blocked_n3` and `oneTermRobinGate_O_D_BS_contractDrift_column8_n3` | regression guard only; no cleanup or unitarity proof |
| rejected row-dependent collision remains visible | `oneTermRobinBlockEncodingProofRoute_activeCollisionBlocked_n3` | regression witness only; active global-slot image separates the columns; no injectivity theorem |
| block projection remains frozen with the source blocker | `oneTermRobinBlockEncodingProofRoute_projectionSourceFreeze` | signal index `0`, normalizer $N_DN_f\kappa$, and all theorem-level closure flags false |
| source transcript remains exact | `oneTermRobinBlockEncodingProofRoute_sourceTranscriptIdentity` and `oneTermRobinBlockEncodingProofRoute_sourceObligationsFalse` | source obligations false; lower proof search disabled |

Next lower packet:

| Field | Instruction |
|---|---|
| fixed target | guard-only preservation of the O_D^BS source blocker and theorem-route false flags |
| allowed edits | source-backed transcript notes, cited-results rows for a newly supplied exact source, conversion-window or obligation-ledger updates, and focused false-flag tests |
| declarations to reuse | `oneTermRobinBlockEncodingProofRoute_sourceGateFreeze`, `oneTermRobinBlockEncodingProofRoute_projectionSourceFreeze`, `oneTermRobinBlockEncodingProofRoute_contractDriftColumn8Blocked_n3`, `oneTermRobinBlockEncodingProofRoute_activeCollisionBlocked_n3`, `oneTermRobinBlockEncodingProofRoute_sourceTranscriptIdentity`, `oneTermRobinBlockEncodingProofRoute_sourceObligationsFalse` |
| forbidden promotions | O_D^BS injectivity, dagger cleanup, unitary extension, active matrix rewrites, O_f amplitude correctness, LCU correctness, circuit unitarity, block projection, and block correctness |
| blocker exit condition | add an exact unused-branch image formula or named reversible-extension theorem to `research-wiki/cited-results/GHL2025.md` before proof work depends on it |

### 2026-05-24 Middle Gate-Projection Source-Contract Sync

Middle translated `oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze`
back into the obligation ledger after re-reading GHL2025 Lemma
`lemma: Banded-sparse-access`, Eq. `eq: ROBIN clarified`, Fig.
`fig:1 term ROBIN`, Theorem `theorem: 1 term robin`, and the cited prior
sparse-access primitive.  The source-dependency classification is unchanged:
the missing reversible image rule for clean unused zero-amplitude sparse
branches remains a `source-contract-gap`.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| Fig. `fig:1 term ROBIN` gate order | `oneTermRobinBlockEncodingProofRoute_gateListAndFlags`, `oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze` | active matrix labels match `oneTermRobinCircuit`; no gate substitution |
| active proof-state vector | `oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze` | `[true, false, false, false, false, true, false]` |
| proved local gates | `indicatorOracleMatrix_is_permutation`, `swapOracleMatrix_is_permutation` | only $U_{\mathrm{indic}}$ and SWAP have true gate flags |
| projection target | `oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze` | signal index `0`, normalizer $N_DN_f\kappa$, `blockProjection.proved = false`, and `blockCorrect.proved = false` |
| theorem closure flags | `oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze` | circuit-unitary, block-extraction, block-correctness, and LCU flags remain false |
| O_D^BS source blocker | `bandedSparseAccessUnusedZeroBranchSourceDecision`, `QBE.ODBS.UnusedZeroBranchExtension` | `lowerProofSearchAllowed = false`; no image rule selected |

Paper-to-Lean proof-translation map for the guarded gate/projection route:

| Source step | Classification | Lean target | Remaining obligation |
|---|---|---|---|
| gate order in Fig. `fig:1 term ROBIN` | `internal-paper-step` | `oneTermRobinBlockEncodingProofRoute_gateListAndFlags` | none for order; structural guard only |
| theorem normalizer $N_DN_f\kappa$ and signal-zero block target | `internal-paper-step` plus final composition obligations | `oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit`, `oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze` | block projection and block correctness |
| $O_D^{BS}$ and $(O_D^{BS})^\dagger$ | `source-contract-gap` downstream of unused zero-amplitude sparse branches | `oneTermRobinGate_O_D_BS`, `oneTermRobinGate_O_D_BS_dagger`, `oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze` | unused-branch image rule, injectivity, cleanup, and unitarity |
| $O_f$ and LCU/block composition | `external-cited-result` and `classic-unformalized` obligations | `FunctionOracleAmplitudeProofRoute`, `oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze` | $N_f$ bound, orthogonal completion, LCU composition, and block correctness |

Next lower packet remains guard-only.

| Field | Instruction |
|---|---|
| fixed target | preserve `oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze` and the source-contract blocker |
| allowed edits | source-backed transcript notes, cited-results rows for a newly supplied exact source, proof-map updates, or focused false-flag tests |
| declarations to reuse | `oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze`, `oneTermRobinBlockEncodingProofRoute_gateListAndFlags`, `oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit`, `oneTermRobinBlockEncodingProofRoute_sourceDecisionWrapperSlotsBlocked_n3`, and `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript` |
| forbidden promotions | O_D^BS injectivity, dagger cleanup, unitary extension, active matrix rewrites, O_f amplitude correctness, LCU correctness, circuit unitarity, block projection, and block correctness |
| blocker exit condition | record an exact unused-branch image formula or named reversible-extension theorem in `research-wiki/cited-results/GHL2025.md` before proof work depends on it |

### 2026-05-24 Lower Gate-Projection Freeze Guard

Lower added `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze`
and a matching `Tests/Basic.lean` regression.  This guard only packages
existing evidence:

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| Fig. `fig:1 term ROBIN` gate order | `oneTermRobinBlockEncodingProofRoute_gateListAndFlags` | active matrix labels match `oneTermRobinCircuit` |
| active proof-state vector | `oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze` | `[true, false, false, false, false, true, false]` |
| block target convention | `oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze` | normalizer $N_DN_f\kappa$ and signal index `0` |
| source blocker | `bandedSparseAccessUnusedZeroBranchSourceDecision` | `lowerProofSearchAllowed = false` |
| theorem-route closure | `oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze` | circuit unitarity, block extraction, block projection, block correctness, and LCU remain false |

This is a guard-only packet.  It does not change the active $O_D^{BS}$ matrices,
select an unused-branch image rule, or promote O_D^BS injectivity, dagger
cleanup, unitary extension, LCU correctness, circuit unitarity, block
projection, or block correctness.

### 2026-05-24 Lower Source-Decision Freeze Guard

Lower added
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_sourceDecisionOnlyFreeze_n3`
with a matching `Tests/Basic.lean` regression.  The guard is a concrete
review checkpoint for the existing $n=3,\kappa=7$ O_D^BS blocker.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| source transcripts are unchanged | `oneTermRobinBlockEncodingProofRoute_sourceDecisionOnlyFreeze_n3` includes the audited unused-zero-branch decision, prior PDE source transcript, and Robin zero-inclusion transcript | exact transcript only |
| unused-branch image slot remains empty | the guard keeps the column-`48` image-rule slot equal to `none` | no image rule selected |
| rejected row-dependent collision remains visible | the guard includes the old row-dependent collision and active global-slot separation for columns `0` and `48` | regression witness only |
| active/legacy separation remains visible | the guard includes the column-`8` paper-image row `40` witness | regression guard only |
| theorem route remains blocked | the guard keeps source obligations, dagger cleanup, unitary extension, circuit unitarity, block extraction, block correctness, and LCU correctness false | no semantic flag promoted |

The missing ingredient remains a source-backed reversible image rule for clean
unused zero-amplitude sparse branches, recorded as
`QBE.ODBS.UnusedZeroBranchExtension`.  Lower proof search for $O_D^{BS}$
injectivity, dagger cleanup, unitary extension, LCU closure, and final block
extraction remains disabled.

### 2026-05-24 Middle Source-Decision Freeze Sync

Middle translated the latest lower guard back into the obligation ledger after
re-reading GHL2025 Lemma `lemma: Banded-sparse-access`, Eq.
`eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, Theorem
`theorem: 1 term robin`, and the cited prior sparse-access primitive.  The
classification is unchanged: the missing unused-branch image rule is a
`source-contract-gap`.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| source transcript identity | `oneTermRobinBlockEncodingProofRoute_sourceDecisionOnlyFreeze_n3` includes the audited unused-zero-branch decision, the prior PDE source transcript, and the Robin zero-inclusion transcript | exact transcript guard only |
| unused-branch image slot | the same guard keeps the column-`48` image-rule slot equal to `none` | no image rule selected |
| rejected row-dependent collision | the same guard includes the old row-dependent collision for columns `0` and `48`, plus active global-slot separation | regression witness only |
| active/legacy separation | the same guard includes the column-`8` paper-image row `40` witness | regression guard only |
| theorem-route closure | the same guard keeps O_D^BS cleanup, unitary extension, circuit unitarity, block extraction, block correctness, and LCU correctness false | no semantic flag promoted |

Next lower packet remains guard-only.  Allowed work is limited to
source-backed transcript maintenance, cited-results entries for a newly
supplied exact source, proof-map notes, or focused false-flag tests.  Lower work
must not attempt O_D^BS injectivity, dagger cleanup, unitary extension, active
matrix rewrites, O_f amplitude correctness, LCU correctness, circuit unitarity,
block projection, or block correctness until an exact unused-branch image
formula or named reversible-extension theorem is recorded first.

### 2026-05-24 Lower Wrapper-Slot Freeze Guard

Lower added
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_sourceDecisionWrapperSlotsBlocked_n3`
with a matching `Tests/Basic.lean` regression.  This is a focused false-flag
guard for the recorded $n=3,\kappa=7$ boundary column `48`: it keeps both the
direct unused-branch image-rule slot and the full clean-domain wrapper slot
empty while preserving the theorem-level closure blockers.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| source decision remains disabled | `oneTermRobinBlockEncodingProofRoute_sourceDecisionWrapperSlotsBlocked_n3` keeps `paperImageRuleSpecified = false`, `externalExtensionTheoremAccepted = false`, and `lowerProofSearchAllowed = false` | no lower proof search |
| direct image-rule slot | same guard, direct `BandedSparseAccessUnusedBranchImageRuleContract` at column `48` | `proposedImageIndex = none` and `imageSpecified.proved = false` |
| full clean-domain wrapper slot | same guard, wrapper `unusedBranchImageRuleContract 48` | `proposedImageIndex = none` and `imageSpecified.proved = false` |
| final route flags | same guard | `blockCorrect.proved = false` and `lcuCorrect.proved = false` |

This does not introduce an image formula for clean unused zero-amplitude
sparse branches and does not promote $O_D^{BS}$ injectivity, cleanup,
unitarity, LCU correctness, or block extraction.

### 2026-05-24 Middle Wrapper-Slot Source Sync

Middle translated the lower wrapper-slot guard back into this ledger after
re-reading GHL2025 Lemma `lemma: Banded-sparse-access`, Eq.
`eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, Theorem
`theorem: 1 term robin`, and the cited prior sparse-access primitive.  The
blocked ingredient is still a `source-contract-gap`: no inspected source gives
an injective reversible image for clean unused zero-amplitude sparse branches.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| direct unused-branch image slot for boundary column `48` | `oneTermRobinBlockEncodingProofRoute_sourceDecisionWrapperSlotsBlocked_n3` keeps `bandedSparseAccessUnusedBranchImageRuleContract p 48` at `proposedImageIndex = none` and `imageSpecified.proved = false` | no image rule selected |
| full clean-domain wrapper slot for boundary column `48` | the same guard keeps the wrapper slot at `proposedImageIndex = none` and `imageSpecified.proved = false` | no wrapper image rule selected |
| source decision | the same guard keeps `paperImageRuleSpecified = false`, `externalExtensionTheoremAccepted = false`, and `lowerProofSearchAllowed = false` | no lower proof search |
| theorem-route closure | the same guard keeps block correctness and LCU correctness false | no semantic flag promoted |

Next lower packet remains guard-only.  Allowed work is limited to
source-backed transcript maintenance, cited-results entries for a newly
supplied exact source, proof-map notes, or focused false-flag tests.  Lower
work must not attempt O_D^BS injectivity, dagger cleanup, unitary extension,
active matrix rewrites, O_f amplitude correctness, LCU correctness, circuit
unitarity, block projection, or block correctness until an exact unused-branch
image formula or named reversible-extension theorem is recorded first.

### 2026-05-24 Lower Prior-PDE Source-Anchor Guard

Lower added
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_priorPDESourceAnchorsTranscript`
with a matching `Tests/Basic.lean` regression.  This is a source-transcript
guard for the cited prior PDE sparse-access primitive used by GHL2025 Lemma
`lemma: Banded-sparse-access`.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| prior PDE public anchors | `oneTermRobinBlockEncodingProofRoute_priorPDESourceAnchorsTranscript` pins Definition 6, Lemma 1, and the appendix source anchor for arXiv:2405.12855v3 | transcript only |
| prior PDE decomposition text | the same guard pins `O_A^BS = U^SUM (U_A^(l) tensor I^n)` | source transcript; no new circuit proof |
| prior PDE resource and Robin unused branch | the same guard keeps `resourceClaim.proved = false`, `robinUnusedBranchImageRule = none`, and lower proof search false | no semantic flag promoted |

This does not add a reversible image rule for clean unused zero-amplitude
sparse branches and does not change either active $O_D^{BS}$ matrix.  The
blocking row remains `QBE.ODBS.UnusedZeroBranchExtension`.

### 2026-05-24 Middle Prior-PDE Source-Anchor Sync

Middle translated the latest prior-PDE source-anchor guard back into this
ledger after re-reading GHL2025 Lemma `lemma: Banded-sparse-access`, Eq.
`eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, Theorem
`theorem: 1 term robin`, and the cited primitive
`guseynov2024efficientPDE`.  The classification is unchanged: the missing
unused-branch image rule is still a `source-contract-gap`.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| prior sparse-access public anchors | `oneTermRobinBlockEncodingProofRoute_priorPDESourceAnchorsTranscript` pins arXiv:2405.12855v3 Definition 6, Lemma 1, appendix anchor, and decomposition text | transcript guard only |
| prior resource claim | the same guard keeps `priorSparseAccessSource.resourceClaim.proved = false` | external obligation; not a QBE proof |
| Robin unused branch | the same guard keeps `priorSparseAccessSource.robinUnusedBranchImageRule = none` and `unusedZeroBranchDecision.lowerProofSearchAllowed = false` | no image rule selected |
| theorem-route closure | existing source-freeze guards keep O_D^BS cleanup, unitarity, LCU correctness, block projection, and block correctness false | no semantic flag promoted |

Next lower packet remains guard-only.  Allowed work is limited to
source-backed transcript maintenance, cited-results rows for a newly supplied
exact source, proof-map notes, or focused false-flag tests.  Lower work must
not attempt O_D^BS injectivity, dagger cleanup, unitary extension, active
matrix rewrites, LCU correctness, circuit unitarity, block projection, or block
correctness until an exact unused-branch image formula or named
reversible-extension theorem is recorded first.

### 2026-05-24 Lower Seven-Gate Flag Freeze Guard

Lower added
`GHL2025.oneTermRobinGateMatrixPlaceholders_unitaryFlags` and
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gateUnitaryFlags`
with a matching `Tests/Basic.lean` regression.  The guards freeze the active
seven-gate circuit-product proof flags for Fig. `fig:1 term ROBIN`.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| active gate-list flags | `oneTermRobinGateMatrixPlaceholders_unitaryFlags` | `[true, false, false, false, false, true, false]` |
| theorem route uses the frozen flag vector | `oneTermRobinBlockEncodingProofRoute_gateUnitaryFlags` | only `U_indic` and SWAP are locally marked proved |
| source blocker | same route guard | `lowerProofSearchAllowed = false` |
| theorem closure | same route guard | `circuitUnitary.proved = false` and `blockCorrect.proved = false` |

This is a guard-only packet.  It does not promote `O_DT^S`, `Ry_boundary`,
`O_D^BS`, `O_f`, $(O_D^{BS})^\dagger$, LCU correctness, circuit unitarity,
block projection, or block correctness.

### 2026-05-24 Middle Seven-Gate Source-Contract Sync

Middle translated the seven-gate flag freeze back into the obligation ledger
after re-reading GHL2025 Lemma `lemma: Banded-sparse-access`, Eq.
`eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, Theorem
`theorem: 1 term robin`, and the cited prior sparse-access primitive.  The
source-dependency classification is unchanged: the missing reversible image
rule for clean unused zero-amplitude sparse branches remains a
`source-contract-gap`.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| active gate-list flags | `oneTermRobinGateMatrixPlaceholders_unitaryFlags` | `[true, false, false, false, false, true, false]` |
| theorem route gate flags | `oneTermRobinBlockEncodingProofRoute_gateUnitaryFlags` | same vector, with lower O_D^BS proof search disabled |
| proved local gates | `indicatorOracleMatrix_is_permutation`, `swapOracleMatrix_is_permutation` | only $U_{\mathrm{indic}}$ and SWAP have true gate flags |
| blocked paper-oracle gates | `oneTermRobinGate_O_DT_S`, `oneTermRobinGate_Ry_boundary`, `oneTermRobinGate_O_D_BS`, `oneTermRobinGate_O_f`, `oneTermRobinGate_O_D_BS_dagger` | all five gate flags remain false |
| theorem-route closure | `oneTermRobinBlockEncodingProofRoute_gateUnitaryFlags` | `circuitUnitary.proved = false` and `blockCorrect.proved = false` |
| O_D^BS source blocker | `bandedSparseAccessUnusedZeroBranchSourceDecision` and `QBE.ODBS.UnusedZeroBranchExtension` | no lower proof search until a source-backed image rule or named reversible-extension theorem is recorded |

Paper-to-Lean proof-translation map for the seven-gate product:

| Source step | Classification | Lean target | Remaining obligation |
|---|---|---|---|
| $U_{\mathrm{indic}}$ in Fig. `fig:1 term ROBIN` | `classical-lean-lemma` | `oneTermRobinGate_U_indic` | none for the current permutation flag |
| $O_{D^T}^{S}$ from Lemma 3 and Eq. (20) | `external-cited-result` plus local analytic obligations | `oneTermRobinGate_O_DT_S` | $N_D$ division, coefficient bound, square-root complement, and two-by-two unitarity |
| boundary $R_y$ rotations | `internal-paper-step` plus classical analytic obligations | `oneTermRobinGate_Ry_boundary` | arccos relation, half-angle identities, and two-by-two unitarity |
| $O_D^{BS}$ padded sparse-access map | `external-cited-result` with a `source-contract-gap` for unused branches | `oneTermRobinGate_O_D_BS` | unused-branch image rule, injectivity, cleanup, and unitarity |
| $O_f$ coordinate oracle | `external-cited-result` | `oneTermRobinGate_O_f` | nonzero $N_f$, division, normalizer bound, orthogonal completion, and unitarity |
| SWAP between the two $n$-qubit registers | `classical-lean-lemma` | `oneTermRobinGate_SWAP` | none for the current permutation flag |
| $(O_D^{BS})^\dagger$ after SWAP | `source-contract-gap` downstream of O_D^BS unused branches | `oneTermRobinGate_O_D_BS_dagger` | inverse-on-range, unique clean preimage, cleanup, and unitarity |

Next lower packet remains guard-only.

| Field | Instruction |
|---|---|
| fixed target | preserve the seven-gate flag vector and source-contract blocker |
| allowed edits | source-backed transcript notes, cited-results rows for a newly supplied exact source, proof-map updates, or focused false-flag tests |
| declarations to reuse | `oneTermRobinGateMatrixPlaceholders_unitaryFlags`, `oneTermRobinBlockEncodingProofRoute_gateUnitaryFlags`, `oneTermRobinBlockEncodingProofRoute_sourceDecisionWrapperSlotsBlocked_n3`, `oneTermRobinBlockEncodingProofRoute_priorPDESourceAnchorsTranscript`, and `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript` |
| forbidden promotions | O_D^BS injectivity, dagger cleanup, unitary extension, active matrix rewrites, O_f amplitude correctness, LCU correctness, circuit unitarity, block projection, and block correctness |
| blocker exit condition | add an exact unused-branch image formula or named reversible-extension theorem to `research-wiki/cited-results/GHL2025.md` before proof work depends on it |

### 2026-05-24 Lower Gate-List and Flag Freeze Guard

Lower added `GHL2025.oneTermRobinGateMatrixPlaceholders_gateList` and
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gateListAndFlags`,
with a matching `Tests/Basic.lean` regression.  This is a structural
source-contract guard for Fig. `fig:1 term ROBIN`: it keeps the route's
gate-list projection equal to `GHL2025.oneTermRobinCircuit` while reusing the
current flag vector

$$
[\text{true},\text{false},\text{false},\text{false},\text{false},\text{true},\text{false}].
$$

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| active gate order | `oneTermRobinGateMatrixPlaceholders_gateList` | gate placeholders map to `oneTermRobinCircuit` in Fig. `fig:1 term ROBIN` order |
| theorem-route order and flags | `oneTermRobinBlockEncodingProofRoute_gateListAndFlags` | gate order and flag vector stay synchronized |
| source blocker | same route guard | `unusedZeroBranchDecision.lowerProofSearchAllowed = false` |
| theorem closure | same route guard | `circuitUnitary.proved = false` and `blockCorrect.proved = false` |

This guard uses no new external source beyond the existing GHL2025 transcript
rows.  It does not select an unused-branch image rule and does not promote
O_D^BS injectivity, dagger cleanup, unitary extension, LCU correctness,
circuit unitarity, block projection, or block correctness.

### 2026-05-24 Middle Gate-List Source-Contract Sync

Middle translated the gate-list guard back into this ledger after re-reading
GHL2025 Lemma `lemma: Banded-sparse-access`, Eq. `eq: ROBIN clarified`, Fig.
`fig:1 term ROBIN`, Theorem `theorem: 1 term robin`, and the cited prior
sparse-access primitive.  The missing unused-branch image rule remains a
`source-contract-gap`; the gate-list guard is only a structural transcript
guard.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| Fig. `fig:1 term ROBIN` gate order | `oneTermRobinGateMatrixPlaceholders_gateList` and `oneTermRobinBlockEncodingProofRoute_gateListAndFlags` | active matrix labels match `oneTermRobinCircuit`; no gate substitution |
| active proof-state vector | `oneTermRobinBlockEncodingProofRoute_gateListAndFlags` | `[true, false, false, false, false, true, false]` |
| proved local gates | `indicatorOracleMatrix_is_permutation`, `swapOracleMatrix_is_permutation` | only $U_{\mathrm{indic}}$ and SWAP have true gate flags |
| O_D^BS source blocker | `bandedSparseAccessUnusedZeroBranchSourceDecision`, `QBE.ODBS.UnusedZeroBranchExtension` | `lowerProofSearchAllowed = false`; no image rule selected |
| theorem-route closure | `oneTermRobinBlockEncodingProofRoute_gateListAndFlags` | `circuitUnitary.proved = false` and `blockCorrect.proved = false` |

Paper-to-Lean proof-translation map for the guarded seven-gate route:

| Source step | Classification | Lean target | Remaining obligation |
|---|---|---|---|
| gate order in Fig. `fig:1 term ROBIN` | `internal-paper-step` | `oneTermRobinGateMatrixPlaceholders_gateList`, `oneTermRobinBlockEncodingProofRoute_gateListAndFlags` | none for order; structural guard only |
| $U_{\mathrm{indic}}$ | `classical-lean-lemma` | `oneTermRobinGate_U_indic` | none for the current permutation flag |
| $O_{D^T}^{S}$ | `external-cited-result` plus analytic obligations | `oneTermRobinGate_O_DT_S` | $N_D$ division, coefficient bound, square-root complement, and unitarity |
| boundary $R_y$ | `internal-paper-step` plus analytic obligations | `oneTermRobinGate_Ry_boundary` | arccos relation, half-angle identities, and unitarity |
| $O_D^{BS}$ and $(O_D^{BS})^\dagger$ | `source-contract-gap` downstream of unused zero-amplitude sparse branches | `oneTermRobinGate_O_D_BS`, `oneTermRobinGate_O_D_BS_dagger` | unused-branch image rule, injectivity, cleanup, and unitarity |
| $O_f$ | `external-cited-result` | `oneTermRobinGate_O_f` | nonzero $N_f$, division, normalizer bound, orthogonal completion, amplitude correctness, and unitarity |
| SWAP | `classical-lean-lemma` | `oneTermRobinGate_SWAP` | none for the current permutation flag |

Next lower packet remains guard-only.

| Field | Instruction |
|---|---|
| fixed target | preserve `oneTermRobinBlockEncodingProofRoute_gateListAndFlags` and the source-contract blocker |
| allowed edits | source-backed transcript notes, cited-results rows for a newly supplied exact source, proof-map updates, or focused false-flag tests |
| declarations to reuse | `oneTermRobinGateMatrixPlaceholders_gateList`, `oneTermRobinGateMatrixPlaceholders_unitaryFlags`, `oneTermRobinBlockEncodingProofRoute_gateListAndFlags`, `oneTermRobinBlockEncodingProofRoute_sourceDecisionWrapperSlotsBlocked_n3`, and `oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript` |
| forbidden promotions | O_D^BS injectivity, dagger cleanup, unitary extension, active matrix rewrites, O_f amplitude correctness, LCU correctness, circuit unitarity, block projection, and block correctness |
| blocker exit condition | add an exact unused-branch image formula or named reversible-extension theorem to `research-wiki/cited-results/GHL2025.md` before proof work depends on it |

### 2026-05-24 Lower Global-Source Inverse-On-Range Interface

Lower added an obligation interface for the corrected active global-source
route.  The interface is `BandedSparseAccessGlobalSlotInverseOnRangeContract`;
the default record is `bandedSparseAccessGlobalSlotInverseOnRangeContract`.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| active source predicate | `bandedSparseAccessGlobalSlotInverseOnRangeContract_of_globalSlotSource` records `sourceInGlobalDomain = true` when `bandedSparseAccessPaperGlobalSlotSource` holds | source predicate fixed to the global-slot model |
| executable candidate check | `bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_globalSlotSource` proves the Boolean check under finite source range and one-term parameter hypotheses | candidate check only |
| candidate finite range | `bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_globalSlotSource` | range premise for later finite inverse work |
| inverse-on-range and uniqueness | `bandedSparseAccessGlobalSlotInverseOnRangeContract_flags_false` | `inverseOnRange.proved = false` and `uniquePreimage.proved = false` |
| image injectivity, cleanup, and unitarity | same false-flag guard | `imageInjectiveOnGlobalSource.proved = false`, `daggerCleanup.proved = false`, and `unitaryExtension.proved = false` |

This packet does not change the active $O_D^{BS}$ or $(O_D^{BS})^\dagger$
matrices and does not promote LCU correctness, circuit unitarity, block
projection, or block correctness.

Source-dependency audit for the next lower packet:

| Item | Classification | Lean interface | Required next step |
|---|---|---|---|
| Lemma 1 global-source inverse route | `classical-lean-lemma` | `BandedSparseAccessGlobalSlotInverseOnRangeContract`, `bandedSparseAccessGlobalSlotInverseOnRangeContract_of_globalSlotSource` | prove one finite-map injectivity or unique-preimage lemma over `bandedSparseAccessPaperGlobalSlotSource` |
| rejected row-dependent unused-branch route | `contract-drift` for the historical helper | `QBE.ODBS.UnusedZeroBranchExtension`, `oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3` | keep as regression memory; do not assign active proof search here |

The GHL2025 source supplies the oracle equation
$|0\rangle^{n-l}|s\rangle^l|i\rangle^n \mapsto |r_{si}\rangle^n|i\rangle^n$
and the Fig. 1-term Robin use of $(O_D^{BS})^\dagger$ after SWAP.  It does not
state a separate finite injectivity proof for the QBE bit layout.  That proof
is now a Lean-local finite arithmetic obligation over the corrected global
sparse-slot address, not an external cited theorem.

### 2026-05-24 Lower Global-Address Unique Slot Block

Lower added the finite address uniqueness block for the corrected global-slot
route.  For fixed `n`, `s`, `t`, and `i`, the theorem
`oneTermRobinGlobalSparseAddress_inverseSlot_unique_of_lt_seven` proves that
if `3 <= n`, `s < 7`, `t < 7`, `i < gridSize n`, and applying slot `t` after
slot `s` returns `i`, then `t = oneTermRobinGlobalSparseInverseSlot s`.

| Item | Lean declaration | Status |
|---|---|---|
| active offset range | `oneTermRobinGlobalSparseOffset_lt_gridSize_of_lt_seven` | compiled local arithmetic |
| composed address reduction | `oneTermRobinGlobalSparseAddress_comp_eq_mod_offset_sum` | compiled local arithmetic |
| zero-offset slot uniqueness | `oneTermRobinGlobalSparseOffset_sum_mod_eq_zero_unique_of_lt_seven` | compiled local arithmetic |
| reverse-slot uniqueness target | `oneTermRobinGlobalSparseAddress_inverseSlot_unique_of_lt_seven` | compiled local arithmetic |
| tests | focused examples in `Tests/Basic.lean`, including the concrete `n=3`, `s=0`, `t=4`, `i=0` boundary-slot case | `lake build Tests` passed before final gate |
| semantic flags | `BandedSparseAccessGlobalSlotInverseOnRangeContract_flags_false` remains the active status guard | no inverse-on-range, unique-preimage, image-injectivity, dagger-cleanup, unitarity, LCU, circuit-unitary, block-projection, or block-correctness field was promoted |

### 2026-05-24 Current Middle Handoff: Global-Source Route Active

The source-contract correction supersedes the guard-only unused-branch packets
above as the active O_D^BS route.  The row-dependent unused-branch collision is
retained as rejected-model memory.  Active work now uses
`bandedSparseAccessPaperGlobalSlotSource`, which keeps zero-amplitude boundary
slots in the clean source domain and uses the global address
$r_{si}=r_{s0}+i \bmod 2^n$.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| active global source | `bandedSparseAccessPaperGlobalSlotSource` | padded clean input and sparse slot $s<\kappa$ |
| active finite entry bridge | `oneTermRobinGate_O_D_BS_globalSlotSource_entrySafety` | conditional entry witness only; no injectivity proof |
| active post-SWAP cleanup candidate | `bandedSparseAccessPostSwapCleanup_of_globalSlotSourceCandidate_noRange` | conditional cleanup witness only; no semantic `daggerCleanup` proof |
| rejected row-dependent collision | `oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3` and `oneTermRobinBlockEncodingProofRoute_activeCollisionBlocked_n3` | regression memory only |
| theorem closure | O_D^BS cleanup, O_D^BS unitarity, LCU correctness, circuit unitarity, block projection, and block correctness flags | all remain false |

Next lower packet: state or prove a fixed global-source inverse-on-range or
injectivity interface for `bandedSparseAccessPaperGlobalSlotSource`.  Do not
return to `QBE.ODBS.UnusedZeroBranchExtension` as the active blocker unless a
new source-backed reversible-extension theorem is recorded first.

### 2026-05-24 Middle Reverse-Slot Sync and Lower Packet

Middle re-read the GHL2025 source anchors around Lemma `Diagonal sparsity`,
Lemma `Banded-sparse-access-oracle`, Remark `sparsity maximum`, Eq.
`eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, and Theorem
`theorem: 1 term robin`.  The source supplies the global-slot oracle equation
and the cleanup use of $(O_D^{BS})^\dagger$, but it does not supply QBE's
finite bit-slice proof that the post-SWAP preimage is unique in the concrete
basis-index layout.

Accepted Lean evidence from the latest lower block:

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| reverse slot table is an involution on active slots | `oneTermRobinGlobalSparseInverseSlot_involutive_of_lt_seven` | compiled local arithmetic |
| reverse slot table is injective on active slots | `oneTermRobinGlobalSparseInverseSlot_injective_of_lt_seven` | compiled local arithmetic |
| active global sources inherit reverse-slot injectivity | `bandedSparseAccessPaperGlobalSlotSource_inverseSlot_injective` | compiled source-domain wrapper |
| inverse-on-range record remains honest | `bandedSparseAccessGlobalSlotInverseOnRangeContract_of_globalSlotSource` | candidate checks true; semantic fields false |

Current source-dependency classification:

| Item | Classification | Lean interface | Remaining obligation |
|---|---|---|---|
| global-slot post-SWAP preimage uniqueness | `classical-lean-lemma` | planned `oneTermRobinGlobalSparseAddress_inverseSlot_unique_of_lt_seven` | prove reverse-slot uniqueness for the seven-offset table |
| O_D^BS dagger cleanup | blocked downstream of the uniqueness lemma | `BandedSparseAccessGlobalSlotInverseOnRangeContract.uniquePreimage` and `.daggerCleanup` | both fields remain false |
| O_D^BS unitarity and block extraction | blocked downstream | `oneTermRobinGate_O_D_BS`, `oneTermRobinGate_O_D_BS_dagger`, final route records | no flag promotion |
| old unused-branch collision | `contract-drift` memory only | `oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3` | keep as rejected-model regression |

Next lower packet:

| Field | Instruction |
|---|---|
| fixed target | add `oneTermRobinGlobalSparseAddress_inverseSlot_unique_of_lt_seven` |
| target statement | for `3 <= n`, `s < 7`, `t < 7`, `i < gridSize n`, and `oneTermRobinGlobalSparseAddress n t (oneTermRobinGlobalSparseAddress n s i) = i`, prove `t = oneTermRobinGlobalSparseInverseSlot s` |
| allowed write scope | `QuantumBlockEncoding/GHL2025.lean` and focused examples in `Tests/Basic.lean`; update this ledger or `conversion-windows/QBE-AUTO-002.md` after adding the declaration |
| declarations to reuse | `oneTermRobinGlobalSparseAddress`, `oneTermRobinGlobalSparseOffset`, `oneTermRobinGlobalSparseInverseSlot`, `oneTermRobinGlobalSparseAddress_inverseSlot_address_eq`, `oneTermRobinGlobalSparseInverseSlot_involutive_of_lt_seven`, `oneTermRobinGlobalSparseInverseSlot_injective_of_lt_seven`, and `bandedSparseAccessPaperGlobalSlotSource_inverseSlot_injective` |
| proof route | finite seven-slot case split plus arithmetic from `3 <= n`; do not generalize into a new sparse-oracle API |
| required test | add a `Tests/Basic.lean` example for the theorem, including one boundary-effect slot such as `s = 5` or `s = 6` at `n = 3` |
| forbidden target | do not use `QBE.ODBS.UnusedZeroBranchExtension` or `bandedSparseAccessPaperValidCleanSource` as the active proof target |
| forbidden promotions | keep `inverseOnRange.proved`, `uniquePreimage.proved`, `imageInjectiveOnGlobalSource.proved`, `daggerCleanup.proved`, O_D^BS unitarity, LCU correctness, circuit unitarity, block projection, and block correctness false until a full theorem compiles |

### 2026-05-24 Middle Post-Unique-Address Obligation Sync

Middle synchronized the latest accepted lower result.  The theorem
`oneTermRobinGlobalSparseAddress_inverseSlot_unique_of_lt_seven` is now
compiled and tested, so the remaining active O_D^BS blocker has moved from
seven-slot arithmetic to the concrete basis-index inverse route.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| active reverse-slot uniqueness | `oneTermRobinGlobalSparseAddress_inverseSlot_unique_of_lt_seven` | compiled local arithmetic for the seven global slots |
| active source predicate | `bandedSparseAccessPaperGlobalSlotSource` | still the only active clean source domain for O_D^BS |
| inverse-on-range interface | `BandedSparseAccessGlobalSlotInverseOnRangeContract` and `bandedSparseAccessGlobalSlotInverseOnRangeContract_of_globalSlotSource` | candidate checks true under hypotheses; inverse, uniqueness, injectivity, cleanup, and unitary fields false |
| rejected row-dependent branch | `oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3` | regression memory only |
| theorem closure | O_D^BS cleanup, O_D^BS unitarity, LCU correctness, circuit unitarity, block projection, and block correctness flags | all remain false |

Source-dependency audit:

| Item | Classification | Lean interface | Remaining obligation |
|---|---|---|---|
| slot-level reverse uniqueness | `classical-lean-lemma` | `oneTermRobinGlobalSparseAddress_inverseSlot_unique_of_lt_seven` | discharged for the seven active slots |
| concrete post-SWAP preimage uniqueness | `classical-lean-lemma` | `bandedSparseAccessPaperPostSwapPreimageCandidate`, `BandedSparseAccessGlobalSlotInverseOnRangeContract` | lift the slot theorem through register extraction, SWAP register equations, and O_D splice arithmetic |
| image injectivity on the active global source | `classical-lean-lemma` | `bandedSparseAccessPaperImage`, `bandedSparseAccessPaperGlobalSlotSource` | prove finite-map injectivity or derive it from the unique-preimage route |
| O_D^BS dagger cleanup and unitarity | downstream blocker | `defaultBandedSparseAccessPaperContract p`.daggerCleanup, `oneTermRobinGate_O_D_BS`, `oneTermRobinGate_O_D_BS_dagger` | no proof flag promotion before the concrete inverse theorem compiles |

Next lower packet:

| Field | Instruction |
|---|---|
| fixed target | prove a concrete global-source unique-preimage or image-injectivity lemma that consumes `oneTermRobinGlobalSparseAddress_inverseSlot_unique_of_lt_seven` |
| preferred first lemma | if an active global-source column maps by O_D^BS, SWAP, and the candidate preimage check, then any active global-source preimage for the same post-SWAP column has sparse slot `oneTermRobinGlobalSparseInverseSlot s` |
| allowed files | `QuantumBlockEncoding/GHL2025.lean` plus focused examples in `Tests/Basic.lean`; documentation sync if a declaration is added |
| required guards | keep `bandedSparseAccessGlobalSlotInverseOnRangeContract_flags_false` and all final block-route false flags unchanged |
| forbidden route | do not revive `QBE.ODBS.UnusedZeroBranchExtension` or `bandedSparseAccessPaperValidCleanSource` as the active proof target |

### 2026-05-24 Lower Global-Source Image-Injectivity Block

Lower discharged one concrete basis-index injectivity block for the corrected
active image.  The declaration
`bandedSparseAccessPaperImage_injective_on_globalSlotSource` proves that the
active `bandedSparseAccessPaperImage` is injective on finite columns satisfying
`bandedSparseAccessPaperGlobalSlotSource`, under the one-term hypotheses
`3 <= p.n`, `p.kappa = 7`, and `clog2 p.kappa = 3`.

This is a compiled Lean-local theorem, not a promotion of the obligation
record.  The fields `inverseOnRange.proved`, `uniquePreimage.proved`,
`imageInjectiveOnGlobalSource.proved`, `daggerCleanup.proved`, and both
O_D^BS unitarity flags remain false.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| reverse slot remains active | `oneTermRobinGlobalSparseInverseSlot_lt_seven` | compiled local arithmetic |
| same-row global address injectivity | `oneTermRobinGlobalSparseAddress_same_row_injective_of_lt_seven` | compiled and consumes `oneTermRobinGlobalSparseAddress_inverseSlot_unique_of_lt_seven` |
| global-source same-row address lift | `bandedSparseAccessPaperAddress_same_row_injective_of_globalSlotSource` | compiled source-domain wrapper |
| clean O_D register reconstruction | `bandedSparseAccessPaperCleanInput_odRegisterValue_eq_cleanODValue` | compiled bit-slice block |
| active global-source image injectivity | `bandedSparseAccessPaperImage_injective_on_globalSlotSource` | compiled finite-map theorem; obligation-record flags still false |

Proof-DAG row:

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `odbs_global_source_image_injective` | if two active global-source finite columns have the same active paper image, then the columns are equal | low-prefix and high-tail preservation, address roundtrip, same-row address injectivity, clean O_D reconstruction | `bandedSparseAccessPaperImage_injective_on_globalSlotSource` | post-SWAP unique-preimage route and future dagger cleanup proof | compiled; no semantic flag promoted |

Next remaining O_D^BS blocker:

| Item | Classification | Lean interface | Remaining obligation |
|---|---|---|---|
| post-SWAP candidate unique preimage | `classical-lean-lemma` | `bandedSparseAccessPaperPostSwapPreimageCandidate`, `BandedSparseAccessGlobalSlotInverseOnRangeContract` | reuse image injectivity to prove the candidate is the unique active clean preimage for the post-SWAP column |
| record-level image injectivity flag | proof-state sync | `bandedSparseAccessGlobalSlotInverseOnRangeContract` | intentionally remains false until upper/middle choose to promote a reviewed record-level theorem |
| dagger cleanup and unitarity | downstream blocker | `oneTermRobinGate_O_D_BS_dagger`, `oneTermRobinGate_O_D_BS` | no flag promotion in this lower packet |

### 2026-05-24 Middle Post-Image-Injectivity Obligation Sync

Middle rechecked the GHL2025 anchors for the next $O_D^{BS}$ proof block:
Lemma `Diagonal sparsity`, Lemma `Banded-sparse-access-oracle`, Remark
`sparsity maximum`, the zero-inclusion paragraph before Theorem `1 term
robin`, Eq. `eq: ROBIN clarified`, and Fig. `fig:1 term ROBIN`.  The paper
supplies the global-slot address and the use of $(O_D^{BS})^\dagger$ after
SWAP.  The remaining uniqueness step is a QBE finite-register lemma, not a new
external theorem.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| active image injectivity | `bandedSparseAccessPaperImage_injective_on_globalSlotSource` | compiled finite-map theorem over the faithful global-slot source domain |
| candidate image and clean audit | `bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_globalSlotSource` | executable audit only |
| candidate finite range | `bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_globalSlotSource` | range premise for the next theorem |
| candidate active-source membership | planned `bandedSparseAccessPaperPostSwapPreimageCandidate_globalSlotSource_of_globalSlotSource` | prove the candidate has clean padded input and sparse slot below $\kappa=7$ |
| unique active clean preimage | planned `bandedSparseAccessPaperPostSwapPreimageCandidate_unique_on_globalSlotSource` | prove any active global-source preimage of the post-SWAP target equals the candidate |
| record-level fields | `bandedSparseAccessGlobalSlotInverseOnRangeContract_flags_false` | keep all inverse, uniqueness, cleanup, image-injectivity, and unitary fields false until reviewed promotion |

Proof-DAG row:

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `odbs_post_swap_candidate_global_source` | candidate is in the active global-source domain | candidate audit, reverse slot bound, clean O_D bit-slice lemmas | planned helper | unique-preimage theorem | pending |
| `odbs_post_swap_unique_preimage` | any active global-source preimage of the post-SWAP target is the candidate | `odbs_post_swap_candidate_global_source`, candidate image audit, `bandedSparseAccessPaperImage_injective_on_globalSlotSource` | planned theorem | cleanup contract and later record-level promotion | pending |

Next lower packet:

| Field | Instruction |
|---|---|
| fixed target | prove `bandedSparseAccessPaperPostSwapPreimageCandidate_unique_on_globalSlotSource` |
| allowed helper | `bandedSparseAccessPaperPostSwapPreimageCandidate_globalSlotSource_of_globalSlotSource` |
| allowed files | `QuantumBlockEncoding/GHL2025.lean` and focused examples in `Tests/Basic.lean`; update this ledger or `conversion-windows/QBE-AUTO-002.md` after adding declarations |
| source classification | `classical-lean-lemma` |
| forbidden route | do not revive `QBE.ODBS.UnusedZeroBranchExtension`, `bandedSparseAccessPaperValidCleanSource`, or row-dependent image helpers as the active proof target |
| forbidden promotions | do not set `inverseOnRange.proved`, `uniquePreimage.proved`, `imageInjectiveOnGlobalSource.proved`, `daggerCleanup.proved`, O_D^BS unitarity, LCU correctness, circuit unitarity, block projection, or block correctness to true |

### 2026-05-24 Lower Post-SWAP Unique-Preimage Block

Lower proved the next classical Lean finite-register step for the corrected
active $O_D^{BS}$ route.  The new theorem
`bandedSparseAccessPaperPostSwapPreimageCandidate_unique_on_globalSlotSource`
uses the compiled active-image injectivity block to show that an active
global-source preimage of
`swapOracleImage p (bandedSparseAccessPaperImage p source.val)` is exactly the
named post-SWAP preimage candidate.

No paper-level semantic flag was promoted.  The obligation record fields
`inverseOnRange.proved`, `uniquePreimage.proved`,
`imageInjectiveOnGlobalSource.proved`, `daggerCleanup.proved`, and
`unitaryExtension.proved` remain false.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| candidate reverse sparse slot | `bandedSparseAccessPaperPostSwapPreimageCandidate_sparseIndex_eq` | compiled bit-slice helper |
| candidate active-source membership | `bandedSparseAccessPaperPostSwapPreimageCandidate_globalSlotSource_of_globalSlotSource` | compiled wrapper over the global-slot source predicate |
| unique active global-source preimage | `bandedSparseAccessPaperPostSwapPreimageCandidate_unique_on_globalSlotSource` | compiled finite-map theorem; obligation-record flags still false |
| concrete boundary-source regression | `Tests/Basic.lean`, source column `48` for `n=3`, `kappa=7` | compiled post-SWAP unique-preimage example |

Next remaining blocker:

| Item | Classification | Lean interface | Remaining obligation |
|---|---|---|---|
| record-level inverse/unique-preimage promotion | proof-state sync | `BandedSparseAccessGlobalSlotInverseOnRangeContract` | reviewer/middle must decide how to reflect the compiled theorem without silently changing Phase 1 flags |
| dagger cleanup | downstream blocker | `oneTermRobinGate_O_D_BS_dagger`, `BandedSparseAccessPostSwapCleanup` | integrate the unique-preimage theorem with the matrix cleanup contract |
| full $O_D^{BS}$ unitarity and block extraction | downstream blocker | active forward/dagger matrices and LCU route | remains unproved |

### 2026-05-24 Middle Post-Unique-Preimage Obligation Sync

Middle re-audited the source contract after the lower unique-preimage theorem.
The controlling paper anchors remain GHL2025 Lemma `Diagonal sparsity`, Lemma
`Banded-sparse-access-oracle`, Remark `sparsity maximum`, the zero-inclusion
paragraph before Theorem `1 term robin`, Eq. `eq: ROBIN clarified`, and Fig.
`fig:1 term ROBIN`, all from arXiv:2506.20478.

The compiled theorem discharges the finite active-source uniqueness step for
the post-SWAP candidate.  It does not discharge the semantic cleanup or
unitarity obligations.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| candidate active-source membership | `bandedSparseAccessPaperPostSwapPreimageCandidate_globalSlotSource_of_globalSlotSource` | compiled |
| unique active clean preimage | `bandedSparseAccessPaperPostSwapPreimageCandidate_unique_on_globalSlotSource` | compiled finite-register theorem |
| record-level inverse evidence | `BandedSparseAccessGlobalSlotInverseOnRangeContract` | still stores false fields; needs a reviewed bridge before any field promotion |
| dagger cleanup | `oneTermRobinGate_O_D_BS_dagger`, existing post-SWAP cleanup witnesses | unproved semantic obligation |
| full $O_D^{BS}$ unitarity and block extraction | active forward/dagger matrices, LCU route, projection route | unproved downstream obligations |

Updated classification:

| Item | Classification | Reason |
|---|---|---|
| record-level bridge for unique preimage | proof-state sync | promote evidence only through an explicit bridge; do not silently edit obligation defaults |
| dagger cleanup matrix theorem | `classical-lean-lemma` | remaining work is finite basis-index matrix reasoning over the active global-source image and transpose-style dagger matrix |
| unitarity, LCU, and block extraction | downstream blocker | require cleanup integration plus independent unitary and composition obligations |
| old row-dependent helper | `contract-drift` memory | its collision tests remain regression evidence only |

Next lower packet:

| Field | Instruction |
|---|---|
| fixed target | bridge `bandedSparseAccessPaperPostSwapPreimageCandidate_unique_on_globalSlotSource` into the global-slot inverse route without proving cleanup or unitarity |
| allowed output | one guard theorem or evidence record tying the compiled theorem, candidate checks, and false flags together |
| allowed files | `QuantumBlockEncoding/GHL2025.lean`, focused tests in `Tests/Basic.lean`, and this ledger or the conversion window |
| forbidden promotions | keep `daggerCleanup.proved`, both $O_D^{BS}$ unitary fields, LCU correctness, circuit unitarity, block projection, and block correctness false |

### 2026-05-24 Lower Record-Level Inverse Bridge

Lower added
`bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge`.
For a fixed active global-source column `source`, the bridge says that any
active global-source `pre` whose active paper image is the contract's
`postSwapImageIndex` has
`pre.val = candidatePreimageIndex` for the same
`BandedSparseAccessGlobalSlotInverseOnRangeContract`.

This is a proof-state sync theorem, not a semantic flag promotion.  It reuses
the compiled post-SWAP unique-preimage theorem and the existing contract guard
for `sourceInGlobalDomain = true` and `candidateChecks = true`, while
`inverseOnRange.proved`, `uniquePreimage.proved`,
`imageInjectiveOnGlobalSource.proved`, `daggerCleanup.proved`, and
`unitaryExtension.proved` remain false.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| record-level candidate equality | `bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge` | compiled bridge from finite theorem to contract fields |
| candidate checks | same bridge plus `bandedSparseAccessGlobalSlotInverseOnRangeContract_of_globalSlotSource` | true under active global-source hypotheses |
| semantic cleanup and unitarity | `BandedSparseAccessGlobalSlotInverseOnRangeContract` flags | remain false |

Next remaining blocker:

| Item | Classification | Lean interface | Remaining obligation |
|---|---|---|---|
| dagger cleanup matrix theorem | `classical-lean-lemma` | `oneTermRobinGate_O_D_BS_dagger`, `BandedSparseAccessPostSwapCleanup`, `bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge` | integrate candidate equality with the transpose-style dagger matrix without promoting `daggerCleanup.proved` |
| full $O_D^{BS}$ unitarity and block extraction | downstream blocker | active forward/dagger matrices and LCU route | remains unproved |

### 2026-05-24 Middle Cleanup-Contract Packet

Middle re-audited the GHL2025 source anchors before the next lower packet:
Lemma `Diagonal sparsity`, Lemma `Banded-sparse-access-oracle`, Remark
`sparsity maximum`, the zero-inclusion paragraph before Theorem
`1 term robin`, Eq. `eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, and the
prior sparse-access citation.  The paper gives the global-slot image and the
circuit-level use of $(O_D^{BS})^\dagger$, but it does not provide a separate
QBE theorem that upgrades obligation flags.

The next packet is therefore a non-promoting cleanup-contract map.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| contract post-SWAP target and candidate | `bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerCleanupBridge` | compiled bridge; expose in one reviewed wrapper |
| active-source uniqueness for the candidate | `bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge` | compiled bridge; use only inside the wrapper |
| cleanup witness and dagger entry | `BandedSparseAccessPostSwapCleanup`, `oneTermRobinGate_O_D_BS_dagger_postSwap_entry_of_preimage` | compiled evidence; still not a semantic cleanup flag |
| semantic cleanup flag | `daggerCleanup.proved` in `BandedSparseAccessGlobalSlotInverseOnRangeContract` and `defaultBandedSparseAccessPaperContract` | must remain `false` |
| unitary and block-extraction flags | active $O_D^{BS}$ gates, LCU route, projection route | remain unproved |

Next lower target:

| Field | Instruction |
|---|---|
| fixed block | `odbs_cleanup_contract_map` |
| primary Lean declaration | `bandedSparseAccessGlobalSlotInverseOnRangeContract_cleanupContractMap` |
| theorem content | for active global-source `source`, return contract `post` and `pre`, a `BandedSparseAccessPostSwapCleanup` witness, uniqueness for active global-source preimages of `post.val`, the dagger matrix entry, and false cleanup/unitary-extension flags |
| allowed files | `QuantumBlockEncoding/GHL2025.lean`, focused examples in `Tests/Basic.lean`, and a short sync in this ledger or the conversion window |
| forbidden promotions | keep `inverseOnRange.proved`, `uniquePreimage.proved`, `imageInjectiveOnGlobalSource.proved`, `daggerCleanup.proved`, O_D^BS unitarity, LCU correctness, circuit unitarity, block projection, and block correctness false |
| forbidden routes | do not use `QBE.ODBS.UnusedZeroBranchExtension`, `bandedSparseAccessPaperValidCleanSource`, or row-dependent image helpers as the active route |

### 2026-05-24 Lower Cleanup-Contract Map

Lower added
`bandedSparseAccessGlobalSlotInverseOnRangeContract_cleanupContractMap`.
For an active global-source `source`, it returns the contract post-SWAP target
and candidate preimage, a `BandedSparseAccessPostSwapCleanup` witness, the
candidate's active global-source fact, uniqueness among active global-source
preimages of `post.val`, and the active transpose-style dagger entry.

This is only a reviewed wrapper over
`bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerCleanupBridge` and
`bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge`.
It does not promote `inverseOnRange.proved`, `uniquePreimage.proved`,
`imageInjectiveOnGlobalSource.proved`, `daggerCleanup.proved`,
`unitaryExtension.proved`, either $O_D^{BS}$ unitarity flag, LCU correctness,
circuit unitarity, block projection, or block correctness.

### 2026-05-24 Middle Default Paper-Contract Cleanup Bridge

Middle added the non-promoting bridge requested by the current source-contract
audit:
`defaultBandedSparseAccessPaperContract_cleanupRouteBridge`.
The theorem consumes
`bandedSparseAccessGlobalSlotInverseOnRangeContract_cleanupContractMap` and
re-exposes the cleanup witness through the default Lemma 1 paper contract.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| default paper-contract cleanup route | `defaultBandedSparseAccessPaperContract_cleanupRouteBridge` | compiled bridge; not a semantic cleanup proof |
| boundary-column regression | `defaultBandedSparseAccessPaperContract_cleanupRouteBridge_boundaryColumn_n3` | column `48` is active for `bandedSparseAccessPaperGlobalSlotSource`, rejected by `bandedSparseAccessPaperValidCleanSource`, and still keeps semantic flags false |
| post-SWAP cleanup witness | `BandedSparseAccessPostSwapCleanup` from `bandedSparseAccessGlobalSlotInverseOnRangeContract_cleanupContractMap` | compiled witness for active global-source columns |
| active-source unique preimage | uniqueness clause returned by `defaultBandedSparseAccessPaperContract_cleanupRouteBridge` | compiled over `bandedSparseAccessPaperGlobalSlotSource` |
| dagger matrix entry | `(oneTermRobinGate_O_D_BS_dagger p).matrix pre post = Coeff.rat 1` | compiled for the named post/pre pair |
| default paper-contract flags | `(defaultBandedSparseAccessPaperContract p).daggerCleanup.proved` and `.unitaryExtension.proved` | both remain `false` |
| gate unitarity flags | `(oneTermRobinGate_O_D_BS p).unitary.proved` and `(oneTermRobinGate_O_D_BS_dagger p).unitary.proved` | both remain `false` |

Source-dependency classification:

| Item | Classification | Lean interface | Remaining obligation |
|---|---|---|---|
| default-contract cleanup-route bridge | `classical-lean-lemma` | `defaultBandedSparseAccessPaperContract_cleanupRouteBridge` | discharged as record-level bookkeeping |
| semantic cleanup flag promotion | proof-state sync | `defaultBandedSparseAccessPaperContract.daggerCleanup` | blocked until a reviewed theorem proves the exact cleanup scope |
| full $O_D^{BS}$ unitarity and block extraction | downstream blocker | active forward/dagger matrices and LCU route | remains unproved |

Next packet:

| Field | Instruction |
|---|---|
| fixed block | semantic cleanup theorem scope decision |
| candidate target | a theorem about the transpose-style dagger matrix on the active global-source image, if reviewer accepts the clean-domain-only scope |
| required guard | state explicitly whether the theorem is clean-domain cleanup evidence or full unitary-extension evidence |
| forbidden promotions | keep default paper-contract cleanup/unitary, both O_D^BS gate unitarity flags, LCU correctness, circuit unitarity, block projection, and block correctness false unless a separate theorem proves the exact flag scope |

### 2026-05-24 Lower Off-Candidate Dagger-Zero Bridge

Lower added the active-domain matrix-entry bridge
`bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerOffCandidate_zero`.
For a fixed contract post-SWAP target, any active global-source column other
than the named candidate has zero entry in the transpose-style
$(O_D^{BS})^\dagger$ matrix.

This theorem uses the compiled active-source unique-preimage bridge.  It is
not a proof of full dagger cleanup, full inverse-on-range behavior, unitarity,
LCU correctness, circuit unitarity, block projection, or block correctness.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| off-candidate dagger column entry | `bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerOffCandidate_zero` | compiled only on `bandedSparseAccessPaperGlobalSlotSource` |
| unique-preimage dependency | `bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge` | rules out the off-candidate image equality |
| candidate entry dependency | `defaultBandedSparseAccessPaperContract_cleanupRouteBridge` and `bandedSparseAccessGlobalSlotInverseOnRangeContract_cleanupContractMap` | supplies the named candidate and entry `Coeff.rat 1` |
| semantic cleanup flag | `daggerCleanup.proved` in `BandedSparseAccessGlobalSlotInverseOnRangeContract` and `defaultBandedSparseAccessPaperContract` | remains `false` |
| unitary and theorem-route flags | active $O_D^{BS}$ gate unitarity, LCU correctness, circuit unitarity, block projection, and block correctness | remain `false` |

Source-dependency classification:

| Item | Classification | Lean interface | Remaining obligation |
|---|---|---|---|
| off-candidate zero entry | `classical-lean-lemma` | `bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerOffCandidate_zero` | discharged for active global-source rows only |
| restricted active-domain dagger column | `classical-lean-lemma` | planned `bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnCleanup` | combine candidate entry and off-candidate zero into one clean-domain column statement |
| full $O_D^{BS}$ unitary extension | downstream blocker | active forward/dagger matrices over the full basis | still requires full-space or paper-backed reversible-extension evidence |

Proof-DAG row:

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `odbs_dagger_off_candidate_zero` | show that every non-candidate active global-source row has zero dagger entry into the contract post-SWAP target | active-source unique-preimage bridge and transpose-style dagger matrix definition | `bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerOffCandidate_zero` | restricted active-domain dagger-column cleanup | compiled; semantic flags false |

Next lower packet:

| Field | Instruction |
|---|---|
| fixed block | `odbs_restricted_dagger_column_cleanup` |
| primary target | add `bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnCleanup` |
| target statement | for active global-source `source`, return the contract `post` and candidate `pre`, a `BandedSparseAccessPostSwapCleanup` witness, the candidate entry `(oneTermRobinGate_O_D_BS_dagger p).matrix pre post = Coeff.rat 1`, and an active-domain column rule: for every `other` with `bandedSparseAccessPaperGlobalSlotSource p other.val = true`, if `other.val ≠ pre.val` then `(oneTermRobinGate_O_D_BS_dagger p).matrix other post = Coeff.rat 0` |
| required status guard | include false fields for `daggerCleanup.proved`, `unitaryExtension.proved`, both active $O_D^{BS}$ gate unitarity flags, LCU correctness, circuit unitarity, block projection, and block correctness |
| declarations to reuse | `defaultBandedSparseAccessPaperContract_cleanupRouteBridge`, `bandedSparseAccessGlobalSlotInverseOnRangeContract_cleanupContractMap`, and `bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerOffCandidate_zero` |
| allowed files | `QuantumBlockEncoding/GHL2025.lean`, focused examples in `Tests/Basic.lean`, and a short sync in this ledger or the conversion window |
| forbidden routes | do not use `QBE.ODBS.UnusedZeroBranchExtension`, `bandedSparseAccessPaperValidCleanSource`, or row-dependent image helpers as the active proof route |
| forbidden promotions | do not set any semantic cleanup, unitarity, LCU, circuit-unitary, projection, or block-correctness flag to `true` in this packet |

### 2026-05-24 Lower Restricted Dagger-Column Cleanup

Lower added
`bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnCleanup`.
For an active global-source `source`, the theorem returns the contract
post-SWAP column and named candidate preimage, proves the candidate dagger
entry is `Coeff.rat 1`, and proves every other active global-source row has
dagger entry `Coeff.rat 0` into that column.

This is clean-domain-only matrix-entry evidence.  It is not a proof of full
dagger cleanup, inverse-on-range behavior over the full basis, full unitarity,
LCU correctness, circuit unitarity, block projection, block correctness, or
block extraction.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| restricted active-domain dagger column | `bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnCleanup` | compiled over `bandedSparseAccessPaperGlobalSlotSource` only |
| candidate dagger entry | `defaultBandedSparseAccessPaperContract_cleanupRouteBridge` | reused; entry `Coeff.rat 1` for the named preimage |
| off-candidate zero entries | `bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerOffCandidate_zero` | reused for every active global-source `other` with `other.val != pre.val` |
| semantic cleanup flag | `daggerCleanup.proved` in the inverse-on-range and default paper contracts | remains `false` |
| unitary and theorem-route flags | active $O_D^{BS}$ gate unitarity, LCU correctness, circuit unitarity, block projection, block correctness, and block extraction | remain `false` |

Proof-DAG row:

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `odbs_restricted_dagger_column_cleanup` | one candidate entry and zero off-candidate entries for the active global-source column of $(O_D^{BS})^\dagger$ | default cleanup-route bridge and off-candidate zero bridge | `bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnCleanup` | cleanup-scope audit; later semantic cleanup theorem design | compiled; semantic flags false |

### 2026-05-24 Middle Cleanup-Scope Audit and Next Packet

Middle re-read the GHL2025 source anchors for Lemma `Diagonal sparsity`,
Lemma `Banded-sparse-access-oracle`, Remark `sparsity maximum`, the
zero-inclusion paragraph before Theorem `1 term robin`, Eq. `eq: ROBIN
clarified`, Fig. `fig:1 term ROBIN`, and the prior sparse-access citation.
No new cited theorem is needed for the next step.

The accepted theorem
`bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnCleanup`
has the following exact scope.

| Field | Scope |
|---|---|
| dependency class | `classical-lean-lemma` |
| source domain | active global-source rows satisfying `bandedSparseAccessPaperGlobalSlotSource`; non-clean rows and encoded sparse values outside $s<\kappa$ are not covered |
| column | the post-SWAP target stored in `BandedSparseAccessGlobalSlotInverseOnRangeContract` |
| candidate row | the preimage candidate stored in `BandedSparseAccessGlobalSlotInverseOnRangeContract` |
| proved entries | candidate row entry is `Coeff.rat 1`; every other active global-source row entry is `Coeff.rat 0` |
| not proved | full-space inverse, non-active-row cleanup, full clean-domain reversible extension, semantic dagger cleanup, unitarity, LCU correctness, circuit unitarity, block projection, and block correctness |

Accepted lower result:

| Field | Result |
|---|---|
| fixed block | `odbs_restricted_dagger_column_indicator` |
| primary target | `bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnIndicator` |
| target statement | for active global-source `source`, returns the same `post` and `pre` as the restricted cleanup theorem and proves the active-domain indicator formula `(oneTermRobinGate_O_D_BS_dagger p).matrix other post = if other.val = pre.val then Coeff.rat 1 else Coeff.rat 0` for every active global-source `other` |
| proof route | derived from `bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnCleanup` by case-splitting on `other.val = pre.val` |
| tests | `Tests/Basic.lean` includes an abstract forwarding example and a concrete $n=3,\kappa=7$ source `48` regression |
| guards | `daggerCleanup.proved`, `unitaryExtension.proved`, both active $O_D^{BS}$ gate unitarity flags, LCU correctness, circuit unitarity, block projection, and block correctness remain `false` |
| forbidden routes | did not use `QBE.ODBS.UnusedZeroBranchExtension`, `bandedSparseAccessPaperValidCleanSource`, `bandedSparseAccessPaperUnusedSparseBranch`, or row-dependent image helpers as the active proof route |
| remaining obligation | the theorem is still restricted to `bandedSparseAccessPaperGlobalSlotSource`; full inverse-on-range, full semantic cleanup, unitarity, LCU, circuit-unitarity, projection, and block-correctness remain open |

### 2026-05-24 Middle Theorem-Route Indicator Bridge

Middle added
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsRestrictedDaggerColumnIndicator`.
For `n >= 3` and an active global-source column, this route-level theorem
reuses the compiled GHL restricted indicator theorem and exposes the same
post-SWAP cleanup witness, candidate preimage, and dagger-column indicator
through `oneTermRobinBlockEncodingProofRoute`.

This is still not a semantic cleanup proof.  It keeps the route sparse-access
contract tied to `defaultBandedSparseAccessPaperContract`, and it keeps
`daggerCleanup`, unitary extension, both active O_D^BS gate unitarity flags,
LCU correctness, circuit unitarity, block projection, block correctness, and
block extraction false.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| route-level active dagger column | `oneTermRobinBlockEncodingProofRoute_odbsRestrictedDaggerColumnIndicator` | compiled over `bandedSparseAccessPaperGlobalSlotSource` only |
| restricted indicator dependency | `bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnIndicator` | compiled; reused without changing scope |
| sparse-access route contract | `oneTermRobinBlockEncodingProofRoute_sparseAccessContractIdentity` | route uses `defaultBandedSparseAccessPaperContract`; cleanup/unitary fields false |
| theorem-route blockers | `oneTermRobinBlockEncodingProofRoute_flags_false` | block projection, block correctness, block extraction, circuit unitarity, and LCU remain false |

Source-dependency classification:

| Item | Classification | Lean interface | Remaining obligation |
|---|---|---|---|
| route-level indicator bridge | `classical-lean-lemma` | `oneTermRobinBlockEncodingProofRoute_odbsRestrictedDaggerColumnIndicator` | discharged as proof-DAG bookkeeping |
| semantic cleanup promotion | proof-state sync plus domain decision | proposed cleanup theorem must state clean-domain or full-space scope before proof search | still open |
| full $O_D^{BS}$ unitary extension and final block extraction | downstream blocker | active forward/dagger matrices and theorem-route LCU/block fields | still open |

### 2026-05-24 Lower Cleanup-Scope Decision

Lower pinned the next cleanup theorem domain as active global-source only.  Lean
now records this as `BandedSparseAccessCleanupScopeDecision` with default
`bandedSparseAccessCleanupScopeDecision`.  The selected predicate is
`bandedSparseAccessPaperGlobalSlotSource`, and the selected evidence is
`bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnIndicator`.

This is not semantic cleanup promotion.  The decision explicitly keeps
`fullCleanDomainSelected = false`, `fullSpaceSelected = false`, and
`semanticCleanupPromotionAllowed = false`.  The route wrapper
`oneTermRobinBlockEncodingProofRoute_odbsCleanupScopeDecision` synchronizes the
same decision with `oneTermRobinBlockEncodingProofRoute` while keeping
`daggerCleanup`, `unitaryExtension`, LCU correctness, and block correctness
false.

Proof-DAG update:

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `odbs_cleanup_scope_decision` | select the active global-source restricted indicator as the next cleanup theorem scope and forbid full-domain/full-space promotion in this packet | restricted indicator theorem, default paper contract, full clean-domain extension wrapper | `bandedSparseAccessCleanupScopeDecision`, `bandedSparseAccessCleanupScopeDecision_activeGlobalSource`, `oneTermRobinBlockEncodingProofRoute_odbsCleanupScopeDecision` | later semantic cleanup theorem design | compiled guard; semantic cleanup remains open |

Updated source-dependency classification:

| Item | Classification | Lean interface | Remaining obligation |
|---|---|---|---|
| cleanup theorem domain decision | `classical-lean-lemma` plus proof-state sync | `oneTermRobinBlockEncodingProofRoute_odbsCleanupScopeDecision` | domain decision discharged; proof remains active global-source only |
| semantic cleanup promotion | downstream blocker | `defaultBandedSparseAccessPaperContract.daggerCleanup` and route sparse-access cleanup field | still false; requires a theorem whose domain and promotion rule reviewer accepts |

### 2026-05-24 Middle Active-Global-Source Interface Packet

Middle accepts the lower cleanup-scope decision as a non-promoting guard:
the next cleanup theorem scope is active global-source only.  The selected
predicate is `bandedSparseAccessPaperGlobalSlotSource`, and the selected
evidence is
`bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnIndicator`.

This decision does not prove semantic cleanup.  It only permits a narrow
interface theorem that packages the selected scope together with the existing
route-level dagger-column indicator.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| cleanup-scope decision | `bandedSparseAccessCleanupScopeDecision_activeGlobalSource`, `oneTermRobinBlockEncodingProofRoute_odbsCleanupScopeDecision` | compiled guard; full clean-domain and full-space selected fields are false |
| active-domain dagger-column indicator | `bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnIndicator`, `oneTermRobinBlockEncodingProofRoute_odbsRestrictedDaggerColumnIndicator` | compiled over `bandedSparseAccessPaperGlobalSlotSource` only |
| active global-source cleanup interface | `oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupInterface` | compiled wrapper; no proof-flag promotion |
| full clean-domain cleanup | no active Lean theorem | remains a source-contract obligation until an exact image rule covers every clean branch |
| full-space unitary extension | no active Lean theorem | remains an external-cited-result or source-contract obligation before lower proof search may depend on it |
| row-dependent unused-branch route | `oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3` and rejected-model helpers | regression memory only; not an active proof target |

Source-dependency classification:

| Item | Classification | Lean interface | Remaining obligation |
|---|---|---|---|
| active global-source interface wrapper | `classical-lean-lemma` plus proof-state sync | `oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupInterface` | combines existing route theorems and keeps all semantic flags false |
| full clean-domain promotion | `source-contract-gap` | `bandedSparseAccessFullCleanDomainExtensionContract` | needs a precise image rule for non-active clean rows and encoded sparse values outside $s<\kappa$ if those rows are included |
| full-space reversible extension | `external-cited-result` if taken from the prior PDE oracle, otherwise `source-contract-gap` | `defaultBandedSparseAccessPaperContract.unitaryExtension` | requires a cited-results update or explicit QBE reversible-extension theorem |

Proof-DAG row:

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `odbs_active_global_source_cleanup_interface` | package active global-source cleanup evidence, selected scope, and false guards in one route-level theorem | `oneTermRobinBlockEncodingProofRoute_odbsRestrictedDaggerColumnIndicator`, `oneTermRobinBlockEncodingProofRoute_odbsCleanupScopeDecision` | `oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupInterface` | reviewer audit before any semantic cleanup design | compiled guard |

Completed lower packet:

| Field | Instruction |
|---|---|
| fixed block | `odbs_active_global_source_cleanup_interface` |
| target file | `QuantumBlockEncoding/RobinMatrix.lean`; add focused examples in `Tests/Basic.lean` |
| statement shape | for `n >= 3` and active global-source `source`, return `post`, `pre`, the `BandedSparseAccessPostSwapCleanup` witness, the active-domain indicator formula, cleanup-scope decision fields, and false guards for cleanup, unitary extension, LCU, circuit unitarity, projection, block correctness, and final extraction |
| documentation | update this ledger or `conversion-windows/QBE-AUTO-002.md` with the accepted Lean name and scope |
| forbidden routes | no row-dependent helper, no `bandedSparseAccessPaperValidCleanSource` as active source, no `QBE.ODBS.UnusedZeroBranchExtension` proof search |
| forbidden promotions | no proof flag may change from false to true in this packet |

Accepted lower update:
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupInterface`
is now the compiled route-level wrapper for the active global-source cleanup
interface.  It returns the post-SWAP cleanup witness, the active-domain
dagger-column indicator, the selected cleanup-scope fields, and false guards
for cleanup, unitary extension, LCU correctness, circuit unitarity, block
projection, block correctness, and final block extraction.  The full clean
domain and full-space reversible-extension obligations remain open.

### 2026-05-24 Middle Source-Dependency Closeout

Middle rechecked the O_D^BS anchors after the active-global-source interface
compiled: GHL2025 Lemma `Diagonal sparsity`, Lemma
`Banded-sparse-access-oracle`, Remark `sparsity maximum`, the zero-inclusion
paragraph before Theorem `1 term robin`, Eq. `eq: ROBIN clarified`, Fig.
`fig:1 term ROBIN`, and the prior sparse-access citation.

No new external theorem is accepted.  The interface
`oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupInterface`
is local proof-state packaging over the corrected global-slot source route.

| Item | Classification | Status |
|---|---|---|
| active global-source cleanup interface | `classical-lean-lemma` plus proof-state sync | compiled; no proof flag promoted |
| full clean-domain cleanup | `source-contract-gap` | needs an exact image rule for clean rows not covered by the active $s<\kappa$ source predicate |
| full-space reversible extension | `external-cited-result` if imported from the prior PDE sparse-access theorem, otherwise `source-contract-gap` | blocked before proof search |
| row-dependent unused-branch route | `contract-drift` memory | retained only as rejected-model regression |

Lower-agent packet for future O_D^BS cleanup work:

| Field | Requirement |
|---|---|
| allowed objective | source-contract or cited-results audit for full clean-domain/full-space extension; no tactic search for semantic cleanup |
| files | `conversion-windows/QBE-AUTO-002.md`, `proof-obligations/QBE-AUTO-002.md`, `research-wiki/cited-results/GHL2025.md`; Lean only if adding a false-flag guard or typed contract |
| forbidden routes | no row-dependent helper, no `bandedSparseAccessPaperValidCleanSource` as the active source, no proof search under `QBE.ODBS.UnusedZeroBranchExtension` |
| forbidden promotions | keep `daggerCleanup`, `unitaryExtension`, active O_D^BS gate unitarity, LCU correctness, circuit unitarity, block projection, block correctness, and final block extraction false |
| gate | run `python3 tools/qbe.py check` and the forbidden-pattern scan if any Lean file changes |

### 2026-05-24 Lower Prior-PDE Transcript Guard

The lower packet added a narrow Lean guard,
`GHL2025.bandedSparseAccessCleanupScopeDecision_priorPDESourceTranscriptGuard`.
It ties the selected cleanup scope to the prior sparse-access source transcript
without accepting that transcript as a full-space unitary-extension proof.

| Item | Lean evidence | Status |
|---|---|---|
| cleanup scope | `bandedSparseAccessCleanupScopeDecision_priorPDESourceTranscriptGuard` | selected scope remains `activeGlobalSource`; `fullSpaceSelected = false` |
| prior PDE source transcript | `bandedSparseAccessPriorPDESourceContract` | oracle equation recorded; resource proof remains false |
| Robin-specific reversible extension | `robinUnusedBranchImageRule = none`, `lowerProofSearchAllowed = false` | no image rule selected and no proof search enabled |
| paper unitary-extension field | `defaultBandedSparseAccessPaperContract p`.unitaryExtension | `proved = false` |

This packet did not edit `bandedSparseAccessPaperImage`,
`bandedSparseAccessPaperMatrix`, `bandedSparseAccessPaperDaggerMatrix`, or any
active $O_D^{BS}$ gate matrix.  It only makes explicit that importing the prior
PDE sparse-access equation is still transcript data unless a separate cited
result or QBE reversible-extension theorem is accepted.

### 2026-05-24 Middle Prior-PDE Guard Closeout

Middle rechecked the GHL2025 source anchors after the guard compiled: Lemma
`Diagonal sparsity`, Lemma `Banded-sparse-access-oracle`, Remark `sparsity
maximum`, the zero-inclusion paragraph before Theorem `1 term robin`,
Eq. `eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, and the prior
sparse-access citation.  These anchors justify the global-slot active source
contract and the placement of $(O_D^{BS})^\dagger$ after SWAP, but they do not
provide a full clean-domain image rule or a full-space unitary-extension proof.

| Obligation | Current Lean evidence | Required status |
|---|---|---|
| active global-source cleanup interface | `oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupInterface` | compiled wrapper over `bandedSparseAccessPaperGlobalSlotSource`; no semantic promotion |
| prior sparse-access transcript | `bandedSparseAccessPriorPDESourceContract`, `bandedSparseAccessCleanupScopeDecision_priorPDESourceTranscriptGuard` | external cited-result obligation only; resource claim and reversible-extension use remain false |
| full clean-domain cleanup | `bandedSparseAccessFullCleanDomainExtensionContract` | source-contract gap until an exact image rule covers every clean branch in the chosen domain |
| full-space reversible extension | no accepted Lean theorem | external cited-result or source-contract gap before any lower proof search may depend on it |
| row-dependent unused-branch route | rejected-model collision regression | contract-drift memory only |

Next lower packet discipline:

| Field | Requirement |
|---|---|
| O_D^BS proof search | blocked for cleanup, injectivity, unitarity, and block extraction until the full clean-domain/full-space contract is refined |
| allowed O_D^BS work | cited-results or source-contract refinement; Lean only for false-flag guards or typed contract records |
| allowed alternate work | a different fixed Phase 1 transcript block with existing source anchors |
| forbidden promotions | `daggerCleanup`, `unitaryExtension`, active O_D^BS gate unitarity, LCU correctness, circuit unitarity, block projection, block correctness, and final block extraction must remain false |

### 2026-05-24 Lower Full Clean-Domain Image-Rule Blocker

Lower added a guard-only refinement for the full clean-domain source-contract
gap:

| Item | Lean evidence | Status |
|---|---|---|
| cleanup scope | `GHL2025.bandedSparseAccessCleanupScopeDecision_fullCleanDomainImageRuleBlocked` | active global-source only; no full clean-domain selection |
| route-level wrapper | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsFullCleanDomainImageRuleBlocked` | theorem route exposes the same blocker with LCU and block-correctness flags false |
| direct unused-branch image rule | `bandedSparseAccessUnusedBranchImageRuleContract p j` | `proposedImageIndex = none` |
| full clean-domain wrapper slot | `(bandedSparseAccessFullCleanDomainExtensionContract p).unusedBranchImageRuleContract j` | `proposedImageIndex = none`, `imageSpecified.proved = false` |
| semantic fields | `unusedBranchImageSpecified`, `fullCleanDomainInjective`, `daggerCleanup`, `unitaryExtension` | all `proved = false` |

This does not supply an image for any unused branch and does not use the
row-dependent helper.  The remaining obligation is still a source-contract
gap: choose or cite an exact reversible image rule before assigning cleanup,
injectivity, unitarity, LCU, or block-extraction proof search.

### 2026-05-24 Lower Shared $N_D$ Packaged Guard

Lower added one guard-only theorem for the shared $N_D$ Phase 1 route:
`GHL2025.derivativeNormalizerNDSharedRoute_sourceBoundAndFlags`.

The theorem packages the existing source-bound bridges for
`O_DT^S` and `Ry_boundary` with the already accepted false-flag guard.  It
states that both routes reuse `DerivativeNormalizerNDSourceBound` for the
source coefficient, the `N_D` symbol, and the coefficient-bound obligation,
and it keeps the nonzero, division, coefficient-bound, absolute-square,
square-root, arccos, half-angle, two-by-two-unitarity, and affected gate
unitarity flags false.

This is a proof-state synchronization theorem only.  It does not prove
nonzero $N_D$, division semantics, the normalizer bound, square-root
semantics, arccos semantics, half-angle identities, `O_DT^S` unitarity,
`Ry_boundary` unitarity, LCU correctness, block projection, or block
correctness.

#### 2026-05-24 Middle Shared $N_D$ Proof-Translation Closeout

Middle re-read the source anchors for GHL2025 Lemma 3 Eq.
`amplitude_oracle_D`, Eq. `angles for Ry`, and Fig. `fig:1 term ROBIN` after
the accepted guard `GHL2025.derivativeNormalizerNDSharedRoute_sourceBoundAndFlags`.
No cited result status changes.  The rows `GHL2025.Lemma3.ODTS` and
`GHL2025.RyBoundary` remain `contract-only`.

| Source statement | Classification | Lean anchor | Obligation status |
|---|---|---|---|
| $D^{(s)}/N_D$ is the Lemma 3 $|0\rangle$ amplitude | `internal-paper-step` plus source contract | `sparseAmplitudeOracleDTCoefficientNormalizerProofRoute`, `DerivativeNormalizerNDContract.divisionSemantics` | division and nonzero $N_D$ false |
| $\sqrt{1-|D^{(s)}|^2/N_D^2}$ is the Lemma 3 complement | `classical-lean-lemma` | `DerivativeNormalizerNDContract.absSquareSemantics`, `DerivativeNormalizerNDContract.sqrtComplementSemantics` | false |
| $\theta_j^s=\arccos(D_j^{(s)}/N_D)$ is the boundary angle | `internal-paper-step` plus analytic contract | `boundaryRotationAngleNormalizerProofRoute`, `DerivativeNormalizerNDContract.arccosSemantics` | false |
| boundary cosine and sine entries follow from half-angle formulas | `classical-lean-lemma` | `BoundaryRotationAngleNormalizerProofRoute.halfAngleSemantics` | false |
| $N_D \geq \|D\|_{\max}$ bounds the coefficient source | `source-contract` plus later bound lemma | `DerivativeNormalizerNDSourceBound.coefficientBound` | false |
| $O_{D^T}^S$ and `Ry_boundary` are unitary | downstream semantic obligation | `derivativeNormalizerNDSharedRoute_sourceBoundAndFlags` | both gate flags false |

The next lower packet must not continue proof search on this shared $N_D$
block unless upper selects a narrower fixed analytic lemma and middle records
its source contract first.  This packet also does not reopen $O_D^{BS}$ cleanup
or unitarity work.

### 2026-05-24 Lower $O_f$ External-Source Guard

Lower added the guard-only theorem
`GHL2025.functionOracleAmplitudeProofRoute_externalSourceAndFlags`.
For each parameter record `p` and compound column `j`, the theorem combines
the per-column bridge to `functionOracleExternalAmplitudeSourceContract` with
the existing false-flag records for the cited source transcript and the
`FunctionOracleAmplitudeProofRoute`.

| Obligation group | Lean evidence | Status |
|---|---|---|
| cited amplitude-oracle theorem | `functionOracleExternalAmplitudeSourceContract_flags_false` | resource claim and external-theorem formalization false |
| clean branch $f(x_i)/N_f$ | `functionOracleAmplitudeProofRoute_externalSourceContract` | source bridge only |
| analytic O_f fields | `functionOracleAmplitudeProofRoute_flags_false` | nonzero $N_f$, division, normalizer bound, orthogonal completion, unitary completion, and theorem amplitude correctness false |

The focused `Tests/Basic.lean` examples consume the combined guard and check
that the external theorem formalization and theorem-level amplitude correctness
remain false.  This packet does not change the active O_f matrix, does not
promote `FunctionOracleContract.amplitudeCorrect`, and does not affect
`O_D^{BS}`, LCU correctness, block projection, block correctness, or final
block extraction.

#### 2026-05-24 Middle $O_f$ Source-Dependency Closeout

Middle rechecked GHL2025 Theorem `Amplitude-oracle for piece-wise polynomial
function`, Eq. `coordinate oracle`, Fig. `fig:1 term ROBIN`, and the cited
Guseynov--Liu 2024 amplitude-oracle theorem after the lower guard
`GHL2025.functionOracleAmplitudeProofRoute_externalSourceAndFlags` compiled.
The dependency classification remains `external-cited-result`; the cited
result row is `GL2024.Thm5.AmplitudeOracle` with QBE status `obligation`.

| Source item | Lean anchor | Classification | Required status |
|---|---|---|---|
| clean $O_f$ branch amplitude $f(x_i)/N_f$ | `functionOracleAmplitudeProofRoute_externalSourceAndFlags` | transcript bridge to an external cited theorem | does not prove amplitude correctness |
| $N_f$ normalizer and reciprocal semantics | `functionOracleExternalAmplitudeSourceContract.normalizerNf`, `functionOracleAmplitudeProofRoute_flags_false` | source contract plus future analytic lemma | nonzero, division, and bound flags remain false |
| orthogonal workspace component | `FunctionOraclePaperImage.orthogonalComponentCorrect`, `functionOracleOrthogonalEntry` | external cited theorem plus future local matrix lemma | orthogonality and unitary completion remain false |
| theorem-level $O_f$ correctness | `FunctionOracleContract.amplitudeCorrect`, `oneTermRobinBlockEncodingProofRoute` | downstream obligation | O_f correctness, LCU, projection, block correctness, and final extraction remain false |

Next lower packet:

| Field | Requirement |
|---|---|
| objective | add one theorem-route bridge for `functionOracleAmplitudeProofRoute_externalSourceAndFlags` |
| write scope | `QuantumBlockEncoding/RobinMatrix.lean`, focused tests in `Tests/Basic.lean`, and a short documentation sync |
| must preserve | external theorem formalization, $N_f$ nonzero, division semantics, normalizer bound, orthogonal completion, unitary completion, `FunctionOracleContract.amplitudeCorrect`, O_f gate unitarity, LCU correctness, block projection, block correctness, and final extraction all false |
| forbidden route | no analytic O_f proof from the source transcript, no edit to `functionOraclePaperMatrix`, and no O_D^BS cleanup or unitarity proof search |

### 2026-05-24 Lower $O_f$ Theorem-Route Bridge

Lower completed the requested theorem-route bridge:
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_ofExternalSourceAndFlags`.
The theorem is a guard-only package over the already accepted
`GHL2025.functionOracleAmplitudeProofRoute_externalSourceAndFlags` declaration.

| Obligation group | Lean evidence | Required status |
|---|---|---|
| cited GL2024 amplitude theorem | route field `functionOracleSource` equals `GHL2025.functionOracleExternalAmplitudeSourceContract` | external theorem formalization remains false |
| $N_f$ normalizer route | per-column `functionOracleAmplitudeProofRoute (oneTermParameters n) j` fields match the route source record | nonzero, division, and bound flags remain false |
| active $O_f$ gate slot | index `4` of the route gate list is `Gate.oracleCall "O_f"` with matrix `GHL2025.functionOraclePaperMatrix` | `oneTermRobinGate_O_f.unitary.proved = false` |
| theorem-level $O_f$ correctness | `oracleComposition.functionOracle.amplitudeCorrect.proved` | false |
| downstream theorem flags | route LCU, block projection, block correctness, and block extraction fields | false |

No image, matrix, normalizer, orthogonality, unitarity, LCU, projection,
block-correctness, or final block-extraction obligation was promoted.
The remaining O_f work is still an external cited-result and analytic-semantics
obligation, not a Lean proof.

### 2026-05-24 Middle One-Term Theorem Dependency Map

Middle re-read the GHL2025 one-term theorem region: the zero-inclusion
paragraph before Theorem `1 term robin`, Eq. `eq: ROBIN clarified`, Fig.
`fig:1 term ROBIN`, and the theorem statement with normalizer
$\mathcal{N}_D\mathcal{N}_f\kappa$.  The source gives a circuit transcript
and wavefunction slices but does not give a gate-level matrix proof of the
final block equation.  The current QBE status is therefore a theorem-route
contract, not a block-encoding proof.

| Obligation group | Paper source | Lean evidence | Status |
|---|---|---|---|
| theorem data and normalizer | Theorem `1 term robin` | `GHL2025.defaultOneTermRobinTheoremData`, `GHL2025.oneTermRobinNormalizer`, `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_normalizer` | route equality compiled; bounds and division semantics remain open |
| circuit order and active matrices | Fig. `fig:1 term ROBIN` | `GHL2025.oneTermRobinGateMatrixPlaceholders`, `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze` | gate order pinned; unproved gate flags remain false |
| O_D^BS sparse slots and cleanup | Lemma `Diagonal sparsity`, Lemma `Banded-sparse-access-oracle`, zero-inclusion paragraph, Fig. `fig:1 term ROBIN` | `bandedSparseAccessPaperGlobalSlotSource`, `bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnIndicator`, `oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupInterface` | active-source guards compiled; semantic cleanup, full-space unitarity, and final block extraction false |
| O_DT^S and boundary rotations | Lemma 3 Eq. `amplitude_oracle_D`, Eq. `angles for Ry` | `derivativeNormalizerNDSharedRoute_sourceBoundAndFlags` | transcript and shared $N_D$ guard compiled; analytic and unitary fields false |
| O_f | Theorem `Amplitude-oracle for piece-wise polynomial function`, Eq. `coordinate oracle`, cited arXiv:2411.01131 | `functionOracleAmplitudeProofRoute_externalSourceAndFlags`, `oneTermRobinBlockEncodingProofRoute_ofExternalSourceAndFlags` | external-source guard compiled; amplitude correctness and unitarity false |
| LCU and block closure | final theorem conclusion and later LCU discussion | `CircuitBlockEncodingClaim`, `BlockExtractionTarget`, cited row `LCU.StandardBlockEncoding` | no exact finite-dimensional QBE theorem yet |

Source-dependency classification:

| Source step | Classification | Next allowed work |
|---|---|---|
| zero sparse slots stay in $s=0,\dots,\kappa-1$ | `internal-paper-step` | keep global sparse slots active and zero coefficients in amplitude-layer obligations |
| prior sparse-access implementation and resource claim | `external-cited-result` | refine cited-result or source-contract rows before any full-space O_D^BS unitary proof |
| $O_f$ clean branch $f(x_i)/N_f$ | `external-cited-result` | use only transcript guards until the cited amplitude-oracle theorem is formalized or contracted |
| normalizer $N_DN_f\kappa$ | `internal-paper-step` plus `classical-lean-lemma` obligations | prove concrete bounds and inverse/division semantics separately |
| final block extraction and LCU closure | `external-cited-result` plus QBE-local theorem obligation | state and prove an exact finite-dimensional block-composition lemma before promoting route flags |

Next lower packet:

| Field | Instruction |
|---|---|
| fixed Lean target | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_theoremTranscriptDependencies` |
| allowed write scope | `QuantumBlockEncoding/RobinMatrix.lean`, focused tests in `Tests/Basic.lean`, and short doc sync |
| required content | expose source anchor, theorem normalizer equality, gate-list/order guard, block target normalizer, signal-index-zero, O_D^BS source records, O_f source record, and all current false final flags |
| reuse | `oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze`, `oneTermRobinBlockEncodingProofRoute_flags_false`, `oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupInterface`, and `oneTermRobinBlockEncodingProofRoute_ofExternalSourceAndFlags` |
| forbidden promotions | no `daggerCleanup`, `unitaryExtension`, O_D^BS unitarity, O_f amplitude correctness, O_f unitarity, LCU correctness, circuit unitarity, block projection, block correctness, resource-bound, ancilla-cleanup, or final block-extraction promotion |
