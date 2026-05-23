# Proof Obligations: QBE-AUTO-002 — Circuit Matrix Semantics Backend

Task id: `QBE-AUTO-002`
Updated: `2026-05-23`

This ledger tracks the unproved semantic claims introduced by the circuit
matrix semantics backend layer.

## Gate Matrix Placeholders

Each of the 7 circuit gates has a `GateMatrix` record with a nonzero matrix
semantics.  `U_indic` has a proved permutation-matrix certificate; the other
gate unitarity claims remain explicit proof obligations.

| Gate | Lean declaration | Paper source | Status |
|---|---|---|---|
| U_indic | `GHL2025.oneTermRobinGate_U_indic` | U_indic definition and Fig. 1-term Robin, arXiv:2506.20478 | honest permutation matrix, **unitary proved** (cycle 2 → run 02 cycle 12 bijection + run 02 cycle 02 permutation bridge) |
| O_DT^S | `GHL2025.oneTermRobinGate_O_DT_S` | Lemma 3, Eq. (20), arXiv:2506.20478 | active controlled-rotation skeleton; coefficient-normalizer relation and unitarity unproved |
| Ry_boundary | `GHL2025.oneTermRobinGate_Ry_boundary` | Fig. 1-term Robin and Eq. angles for Ry, arXiv:2506.20478 | active symbolic controlled rotation matrix; angle-normalizer contract and unitarity unproved |
| O_D^BS | `GHL2025.oneTermRobinGate_O_D_BS` | Lemma 1, arXiv:2506.20478 | active paper-image matrix skeleton; finite-image, entry-safety, finite-range cleanup wrapper, and conditional post-SWAP preimage witnesses proved under explicit hypotheses; `oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3` proves a current clean-domain collision; forward correctness, source-domain reconciliation, cleanup, and unitarity unproved |
| O_f | `GHL2025.oneTermRobinGate_O_f` | Lemma 4 and Fig. 1-term Robin, arXiv:2506.20478 | active paper-image matrix skeleton with clean $m_f$ branch wired; orthogonal completion, amplitude relation, normalizer bound, and unitarity unproved |
| SWAP | `GHL2025.oneTermRobinGate_SWAP` | Fig. 1-term Robin SWAP operation, arXiv:2506.20478 | honest permutation matrix, unitarity pending proof-DAG bit-slice lemmas |
| (O_D^BS)^dagger | `GHL2025.oneTermRobinGate_O_D_BS_dagger` | Fig. 1-term Robin caption, arXiv:2506.20478 | active transpose-style paper-image matrix; conditional entry and register-cleanup witness available for a supplied clean preimage; inverse-on-range existence/uniqueness, cleanup, and unitarity unproved |

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
| `signalSystemBlockProjection` | defined (total, constructive) |
| `totalCircuitQubits` | defined |
| `CircuitMatrixSemantics.blockExtractionTarget` | defined |

## Circuit Block Encoding Claim

| Declaration | Role | Status |
|---|---|---|
| `CircuitBlockEncodingClaim` | Schema: semantics + target + dimCompat + blockCorrect | defined |
| `Examples.RobinHeat.oneTermRobinCircuitBlockClaim` | Robin instance, takes `hDim` proof parameter | defined |
| `Examples.RobinHeat.oneTermRobinCircuitDimCompat` | Reusable proof that full dimension = signal dimension × system dimension | proved |
| `Examples.RobinHeat.defaultOneTermRobinCircuitBlockClaim` | Robin instance using the reusable dimension proof | defined |

| Obligation | Declaration | Status |
|---|---|---|
| Dimension compatibility for general `n` | `oneTermRobinCircuitDimCompat` using `clog2_gridSize` | proved |
| Block correctness for Robin | `blockCorrect` field | unproved |

## Downstream Dependencies

These obligations block completion of `QBE-AUTO-001`:
- Unitarity is proved for `U_indic` and still unproved for the remaining six gate matrices.
- The composed circuit matrix is now nontrivial, but the extracted block has not yet been proved equal to $A_k/(N_DN_f\kappa)$.
- The active `O_D^BS` paper-image matrix now has explicit clean-input, address-range, no-spill, finite-range, and conditional post-SWAP preimage cleanup checks.  Lemma 1 covers columns with padded register $|0\rangle^{n-l}$ and output address $|r_{si}\rangle^n$; the executable address/no-spill/range checks and supplied-preimage cleanup witness are proved under explicit hypotheses.  The current clean-domain skeleton also has a Lean-checked boundary unused-sparse collision, so source-domain reconciliation, inverse uniqueness, the paper-level flags, and full unitary extension remain unproved.
- `O_{D^T}^S` now uses the controlled-rotation skeleton; the diagonal helper remains available only as data.  The next source-contract gap is the coefficient-normalizer relation for the symbolic rotation entries from Lemma 3, Eq. (20).
- `R_y^{boundary}` now has a typed angle-normalizer contract.  Its remaining gap is proving $\theta_j^s=\arccos(D_j^{(s)}/N_D)$, the half-angle identities, and the two-by-two unitarity relation under the paper's $N_D$ bound.
- The shared derivative normalizer contract `GHL2025.derivativeNormalizerNDContract` now records the common $D_j^{(s)}/N_D$ source for `O_{D^T}^S` and `R_y^{boundary}`.  Its nonzero, division, coefficient-bound, absolute-square, square-root, arccos, and two-by-two-unitary fields remain `proved := false`.
- `O_f` now uses the paper-image matrix skeleton.  The clean $m_f$ branch entry is `functionOracleNormalizedValue`; the symbolic non-clean rows are only an unresolved orthogonal completion, so the $N_f$ bound, amplitude correctness, orthogonality, and unitarity remain open.

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

## Cycle 3: SWAP Matrix (unitarity pending proof-DAG bit-slice lemmas)

| Declaration | Role | Status |
|---|---|---|
| `swapOracleMatrix` | honest SWAP permutation matrix | implemented |
| updated `oneTermRobinGate_SWAP` | uses honest matrix | updated |

### SWAP Matrix Obligations

| Obligation | Status |
|---|---|
| Matrix entries swap two n-qubit register blocks correctly | tested (native_decide, 2 swap pairs) |
| Equal blocks → identity | tested (native_decide) |
| Preserves bits outside swapped blocks | tested (native_decide) |
| Unitarity of SWAP | unproved (`unitary.proved := false`); previous flat proof attempt was demoted to a proof-DAG obligation |
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
| SWAP unitary.proved = false | n=3, κ=7 | rfl | proved |
| Placeholder match with honest SWAP | general p | theorem | proved |

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
| `odbs_valid_sparse_branch_domain` | add a row-dependent candidate source-domain predicate for sparse branches that correspond to nonzero Robin stencil entries | `odbs_clean_domain`, `odbs_boundary_unused_collision` | `robinSparseColumnBranchValid`, `robinSparseColumnBranchValid_boundaryUnused_n3`, `bandedSparseAccessPaperValidSparseBranch`, `bandedSparseAccessPaperValidCleanSource`, `bandedSparseAccessPaperValidCleanSource_separates_boundaryCollision_n3` | source-domain reconciliation, future injectivity route or reversible-extension audit | candidate domain defined and tested; paper-source status and full correction remain obligations; semantic flags false |
| `odbs_unused_branch_extension_contract` | record obligations for clean padded-register branches that are outside the row-dependent valid sparse-branch classifier | `odbs_valid_sparse_branch_domain`, `odbs_boundary_unused_collision` | `bandedSparseAccessPaperUnusedSparseBranch`, `BandedSparseAccessUnusedBranchExtensionContract`, `bandedSparseAccessUnusedBranchExtensionContract`, `bandedSparseAccessUnusedBranchExtensionContract_boundaryCollision_n3` | future injectivity route, dagger cleanup, reversible-extension audit | contract slot defined; all extension proof flags false; active matrices unchanged |
| `odbs_unused_branch_image_rule` | record the missing reversible image-rule interface for clean invalid sparse branches without choosing a replacement construction | `odbs_unused_branch_extension_contract`, `odbs_valid_sparse_branch_domain` | `BandedSparseAccessUnusedBranchImageRuleContract`, `bandedSparseAccessUnusedBranchImageRuleContract`, `bandedSparseAccessUnusedBranchImageRuleContract_flags_false`, `bandedSparseAccessUnusedBranchImageRuleContract_of_unusedBranch` | future injectivity route, dagger cleanup, reversible-extension audit | interface defined with `proposedImageIndex = none`; image-rule proof flags false; active matrices unchanged |
| `odbs_full_clean_domain_extension_contract` | lift the per-column unused-branch image-rule interface into a paper-level full clean-domain extension contract | `odbs_unused_branch_image_rule`, `odbs_valid_sparse_branch_domain`, `odbs_boundary_unused_collision` | `BandedSparseAccessFullCleanDomainExtensionContract`, `bandedSparseAccessFullCleanDomainExtensionContract`, `bandedSparseAccessFullCleanDomainExtensionContract_flags_false`, `bandedSparseAccessFullCleanDomainExtensionContract_of_unusedBranch`, `bandedSparseAccessPaperCleanDomainSplit_iff`, `bandedSparseAccessPaperCleanDomainSplit_disjoint`, `bandedSparseAccessFullCleanDomainExtensionContract_localCleanDomainSplit` | future full clean-domain injectivity, dagger cleanup, and unitary-extension route | wrapper defined; local classifier split proved; no external reversible-completion theorem recorded; all semantic flags false |
| `odbs_address_range` | prove or keep explicit that the written $r_{si}$ value is an n-bit address | `odbs_extract_registers`, `bandedSparseAccessPaperAddress` | `bandedSparseAccessPaperAddressInRange`, `defaultBandedSparseAccessPaperContract p`.addressRange | no-spill, forward matrix, unitarity route | executable check defined; proof flag false |
| `odbs_address_range_n_ge_2` | prove the executable address check once the paper parameter family supplies $2 \le n$ | row extraction, `robinSparseColumnMap_lt_gridSize_of_row_lt` | `bandedSparseAccessPaperAddress_lt_gridSize_of_two_le`, `bandedSparseAccessPaperAddressInRange_eq_true_of_two_le` | no-spill, forward matrix, unitarity route | proved under explicit side condition; proof flag false |
| `odbs_no_spill` | prove or keep explicit that `bandedSparseAccessPaperImage` does not alter indicator or $m_f$ bits above the O_D register | `odbs_address_range`, `odbs_forward_image` | `bandedSparseAccessPaperHighTail`, `bandedSparseAccessPaperImageNoSpill`, `bandedSparseAccessPaperImageNoSpill_iff`, `bandedSparseAccessPaperImage_highTail_eq_of_address_lt`, `bandedSparseAccessPaperImageNoSpill_eq_true_of_address_lt`, `bandedSparseAccessPaperImageNoSpill_eq_true_of_two_le`, `defaultBandedSparseAccessPaperContract p`.noSpill | dagger cleanup, block extraction | executable no-spill proved from address range and $2 \le n$; semantic proof flag false |
| `odbs_forward_image` | preserve the row register and replace the padded sparse-index register by $r_{si}$ | `odbs_width_compatible`, `odbs_extract_registers` | `bandedSparseAccessPaperAddress`, `bandedSparseAccessPaperImage` | forward matrix, cleanup | defined skeleton; correctness unproved |
| `odbs_column_audit_safety` | for each fixed column, package the executable audit booleans `rowPreserved`, `addressWritten`, `addressInRange`, and `imageNoSpill` under the existing n-bit-address hypothesis | `odbs_forward_image`, `odbs_address_range`, `odbs_no_spill` | `bandedSparseAccessPaperColumnContract_rowPreserved_eq_true`, `bandedSparseAccessPaperColumnContract_addressWritten_eq_true_of_address_lt`, `bandedSparseAccessPaperColumnContract_addressInRange_eq_true_of_address_lt`, `bandedSparseAccessPaperColumnContract_imageNoSpill_eq_true_of_address_lt`, `bandedSparseAccessPaperColumnContract_registerSafety_of_address_lt` | entry-safety witness, inverse-on-range route, cleanup route | proved as executable contract bridge; semantic flags false |
| `odbs_forward_matrix` | define matrix entries from the paper image rather than the interim column-map helper | `odbs_forward_image` | `bandedSparseAccessPaperMatrix` | `oneTermRobinGate_O_D_BS` | active skeleton; finite-image entry bridge proved under explicit hypotheses; injectivity unproved |
| `odbs_boundary_unused_collision` | exhibit a concrete collision caused by unused sparse-index branches at a boundary row in the current clean-domain skeleton | `odbs_forward_image`, `odbs_clean_domain`, active forward matrix | `oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3`, `robinSparseColumnBranchValid_boundaryUnused_n3` | source-contract correction, injectivity guard | proved concrete obstruction for $n=3,\kappa=7$; valid-branch predicate separates the collision; no proof flags promoted |
| `odbs_dagger_matrix` | define transpose-style matrix entries from the paper image skeleton | `odbs_forward_image` | `bandedSparseAccessPaperDaggerMatrix` | `oneTermRobinGate_O_D_BS_dagger` | active skeleton; inverse-on-range unproved |
| `odbs_image_fin_entry_bridge` | package the executable image as a finite basis index and prove the forward and dagger entries at that index under explicit range hypotheses | `odbs_forward_image`, `odbs_address_range`, image range theorem | `bandedSparseAccessPaperImageFin`, `bandedSparseAccessPaperMatrix_imageFin_eq_one`, `bandedSparseAccessPaperDaggerMatrix_imageFin_eq_one`, `oneTermRobinGate_O_D_BS_imageFin_eq_one`, `oneTermRobinGate_O_D_BS_dagger_imageFin_eq_one` | injectivity, inverse-on-range, cleanup route | proved as executable bridge; semantic flags false |
| `odbs_entry_safety_witness` | package the active forward entry, active dagger entry, row roundtrip, address roundtrip, and no-spill check under the n-bit address hypothesis | `odbs_image_fin_entry_bridge`, `odbs_image_row_roundtrip`, `odbs_image_address_roundtrip`, `odbs_no_spill` | `oneTermRobinGate_O_D_BS_imageFin_entrySafety` | inverse-on-range and cleanup route | proved as executable witness; semantic flags false |
| `odbs_post_swap_registers` | prove that SWAP applied to the paper image puts $r_{si}$ in the system register and the original row in the O_D register | `odbs_entry_safety_witness`, `swap_block1_image`, `swap_block2_image` | `bandedSparseAccessPaperPostSwap_rowValue_eq_address`, `bandedSparseAccessPaperPostSwap_odRegisterValue_eq_rowValue` | inverse-on-range and cleanup route | proved as register equations; semantic cleanup flag false |
| `odbs_reverse_sparse_index` | compute the sparse index that would make the post-SWAP row address the original source row | `robinSparseColumnMap`, Lemma 1 register interpretation | `robinSparseColumnMap_zero`, `robinSparseColumnMap_one`, `robinSparseColumnMap_bulk`, `robinSparseColumnMap_rightBoundaryPrev`, `robinSparseColumnMap_rightBoundaryLast`, `robinSparseReverseColumnIndex`, `robinSparseReverseColumnRoundtrip_of_lt_eight`, `robinSparseReverseColumnIndex_lt_eight_of_columnMap`, `robinSparseReverseColumnRoundtripCheck` | preimage candidate, inverse-on-range route | reverse candidate defined; general arithmetic roundtrip and three-bit bound proved for $3 \le n$, $s < 8$, and $i < 2^n$; finite scans remain tests; no uniqueness or semantic cleanup flag |
| `odbs_post_swap_preimage_candidate` | build a clean post-SWAP preimage candidate by splicing a clean reverse sparse register into the post-SWAP column and audit image/clean/address checks | `odbs_reverse_sparse_index`, `swapOracleImage`, `bandedSparseAccessPaperImage`, clean-domain audit | `bandedSparseAccessPaperSpliceODRegister`, `bandedSparseAccessPaperCleanODValue`, `bandedSparseAccessPaperPostSwapPreimageCandidate`, `bandedSparseAccessPaperPostSwapPreimageCandidateChecks`, `bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_cleanSource`, `bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_cleanSource` | supplied-preimage cleanup witness, inverse-on-range route | candidate Boolean audit and finite-range theorem proved under explicit one-term hypotheses; all finite columns for $n=3,\kappa=7$ still pass in `Tests/Basic.lean`; source-domain reconciliation, uniqueness, and semantic cleanup flag unproved |
| `odbs_dagger_cleanup` | prove or record that $(O_D^{BS})^\dagger$ cleans the padded sparse-index register after SWAP | `odbs_forward_image`, SWAP block lemmas, supplied preimage contract, preimage candidate audit, finite post/pre ranges | `BandedSparseAccessPostSwapCleanup`, `bandedSparseAccessPostSwapCleanup_of_preimage`, `bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate`, `bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate_noRange`, `bandedSparseAccessPostSwapCleanup_of_validCleanSourceCandidate_noRange`, `defaultBandedSparseAccessPaperContract p`.daggerCleanup | block extraction | no-extra-range conditional witness and valid-clean-source wrapper proved; source-domain reconciliation, uniqueness, and semantic proof flag remain unproved |
| `block_projection_normalizer` | audit that the signal-index-zero projection target uses the composed circuit matrix, Robin matrix, and normalizer $N_DN_f\kappa$ | active gate list, dimension split, O_D^BS cleanup obligations | `Examples.RobinHeat.oneTermRobinBlockExtractionTarget`, `signalSystemBlockProjection`, `GHL2025.oneTermRobinNormalizer` | final block-correctness theorem | structural target defined; correctness unproved |

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
| `odbs_post_swap_column` | prove `swapOracleImage p (bandedSparseAccessPaperImage p source.val)` is a finite column under the existing source and n-bit address hypotheses | `swapOracleImage_lt_qubitDim`, source-column range, forward image range | `bandedSparseAccessPaperPostSwapImage_lt_qubitDim_of_address_lt` | dagger entry route, cleanup witness | proved range block; no SWAP unitarity |
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
uniqueness, register cleanup, SWAP unitarity, or `daggerCleanup` flag was
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
| signal index | `oneTermRobinBlockExtractionTarget n`.signalIndex.val = 0 |
| target matrix | `oneTermRobinBlockExtractionTarget n`.targetMatrix = `robinDerivativeMatrix n` |
| normalizer | `oneTermRobinBlockExtractionTarget n`.normalizer = `GHL2025.oneTermRobinNormalizer` |
| unproved block flags | `.blockProjection.proved = false` and `.blockCorrect.proved = false` |
| upstream cleanup flag | `defaultBandedSparseAccessPaperContract (oneTermParameters n)`.daggerCleanup.proved = false |

The new compiled tests additionally pin
`defaultOneTermRobinCircuitBlockClaim n`.target to
`oneTermRobinBlockExtractionTarget n`, so downstream proof work cannot silently
replace the signal-index-zero convention, the Robin target matrix, or the
normalizer $N_DN_f\kappa$.

Full entry-level normalization of the composed $n=3$ product remains deferred
because the product is an $8192 \times 8192$ symbolic matrix.

### 2026-05-22 Block-Projection Audit Tests

| Test | Parameters | Method | Status |
|---|---|---|---|
| Circuit matrix is the 7-gate product | general `n` | `rfl` | proved |
| Extraction target full matrix is the cast circuit product | general `n` | `rfl` | proved |
| Block matrix is `signalSystemBlockProjection` at the target signal index | general `n` | `rfl` | proved |
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

The paper source for this gate is the function oracle $O_f$ in
Guseynov-Huang-Liu 2025, Lemma 4, the coordinate-oracle equation, and Fig.
1-term Robin, arXiv:2506.20478.  The paper normalizes the function values by
$N_f$, and the one-term theorem uses $\alpha=N_DN_f\kappa$.  The clean
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
Lemma 4 oracle: amplitude correctness, the $N_f$ bound, orthogonality, and
unitarity remain explicit false obligations.

| Declaration | Role | Status |
|---|---|---|
| `robinFunctionValue` | symbolic grid data $f(x_i)$ | defined |
| `functionOracleMatrix` | diagonal Phase 1 helper using `robinFunctionValue p.n sysVal` | implemented; not the full Lemma 4 paper image |
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
| system grid register $i$ | Lemma 4 and Fig. 1-term Robin, arXiv:2506.20478 | `functionOraclePaperRegisters`; also extraction inside `functionOracleMatrix` | defined skeleton; concrete tests pass |
| clean function workspace $|0\rangle^{m_f}$ | coordinate-oracle equation and theorem resource statement, arXiv:2506.20478 | `FunctionOraclePaperRegisters.mfWorkspaceValue` and `cleanWorkspace` | width recorded; action and cleanup unproved |
| function value $f(x_i)$ | Lemma 4, arXiv:2506.20478 | `robinFunctionValue` | symbolic data source defined |
| normalizer $N_f$ | Lemma 4 and theorem normalizer, arXiv:2506.20478 | `oneTermRobinNormalizer`, `FunctionOracleContract.normalizerBound` | recorded; bound unproved |
| normalized clean-branch amplitude $f(x_i)/N_f$ | Lemma 4 and coordinate-oracle equation, arXiv:2506.20478 | `functionOracleNormalizedValue`, `FunctionOraclePaperImage.cleanBranchAmplitude`; `FunctionOracleContract.amplitudeCorrect` | typed contract defined; proof false |
| paper-image matrix skeleton | Lemma 4 and coordinate-oracle equation, arXiv:2506.20478 | `functionOraclePaperMatrix`, `oneTermRobinGate_O_f` | active matrix uses clean-input branch and symbolic non-clean completion; proof flags false |
| orthogonal branch | coordinate-oracle equation, arXiv:2506.20478 | `FunctionOraclePaperImage.orthogonalComponent`, `functionOracleOrthogonalEntry`, `orthogonalComponentCorrect` | component label and symbolic rows recorded; orthogonality proof false |
| unitarity / clean workspace | Lemma 4, arXiv:2506.20478 | `oneTermRobinGate_O_f p`.unitary and future cleanup lemma | unproved (`proved := false`) |

### O_f Proof-DAG

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|
| `of_extract_registers` | extract the system grid index, $m_f$ workspace value, and all non-$m_f$ bits from the compound index | register layout | `FunctionOraclePaperRegisters`, `functionOraclePaperRegisters` | paper image, tests | O_f | defined skeleton; concrete tests pass |
| `of_function_values` | provide symbolic values $f(x_i)$ | `of_extract_registers` | `robinFunctionValue` | normalized amplitude, final target | O_f | defined |
| `of_normalized_value` | record the clean-branch amplitude $f(x_i)/N_f$ without proving division or bounds | `of_function_values`, `FunctionOracleContract.normalizerBound` | `functionOracleNormalizedValue` | paper image, amplitude relation | O_f | defined symbolic contract; proof false |
| `of_paper_image` | record $|0\rangle^{m_f}|i\rangle \mapsto (f(x_i)/N_f)|0\rangle^{m_f}|i\rangle + |\mathrm{orth}_f(i)\rangle$ | `of_extract_registers`, `of_normalized_value` | `FunctionOraclePaperImage`, `functionOraclePaperImage` | paper matrix skeleton, block extraction | O_f | defined contract; proof flags false |
| `of_paper_matrix` | expose the clean-branch amplitude for clean input columns and keep symbolic non-clean input/completion entries unresolved | `of_paper_image`, `of_orthogonal_component` | `functionOracleOrthogonalEntry`, `functionOraclePaperMatrix`, `oneTermRobinGate_O_f` | circuit product, block extraction | O_f | active skeleton wired; completion and unitarity unproved |
| `of_orthogonal_component` | state zero overlap of the orthogonal branch with the clean workspace and preserve the system label | `of_paper_image` | `FunctionOraclePaperImage.orthogonalComponentCorrect`, `systemPreserved`, `cleanWorkspaceBranch` | amplitude correctness, unitarity | O_f | recorded; proof false |
| `of_normalizer_bound` | state and prove the $N_f$ bound needed for amplitudes | future coefficient/function semantics | `FunctionOracleContract.normalizerBound`, future bound theorem | amplitude relation, unitarity | O_f | recorded; proof missing |
| `of_diagonal_helper_isolation` | keep `functionOracleMatrix` helper-only so function-value data tests are not mistaken for the active paper oracle | `of_paper_image`, current matrix tests | `functionOracleMatrix`, `FunctionOraclePaperImage.diagonalHelperIsolation` | source-contract audit | O_f | helper isolated; proof flag false |
| `of_amplitude_contract` | prove the paper amplitude relation and clean $m_f$ workspace | `of_paper_image`, `of_orthogonal_component`, `of_normalizer_bound` | `FunctionOracleContract.amplitudeCorrect`, `RobinProofObligations.functionOracleCorrect` | final block extraction | O_f | unproved |

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
| planned declarations | `FunctionOracleAmplitudeProofRoute`, `functionOracleAmplitudeProofRoute`, and bridge theorems tying the route to `functionOraclePaperImage`, `functionOracleNormalizedValue`, and the existing `FunctionOracleContract` normalizer |
| write scope | `QuantumBlockEncoding/GHL2025.lean`, focused tests in `Tests/Basic.lean`, and synchronized note files |
| permitted additions | `rfl` or `simp` bridge lemmas and false-flag guard tests; a typed route record that reuses existing O_f records rather than defining a second function value or matrix |
| forbidden additions | analytic claims about nonzero $N_f$, division semantics, normalizer bounds, orthogonality, unitary completion, changes to `functionOraclePaperMatrix`, or any `O_D^BS` cleanup/injectivity work |
| acceptance | `python3 tools/qbe.py check`; all O_f amplitude, normalizer, orthogonality, and unitarity proof flags remain false |

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
| SWAP permutation unitarity | pending proof-DAG bit-slice lemmas; previous flat proof attempt was demoted |
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

### No Promoted Obligations

All other gate matrices remain `unitary.proved := false`. The `RobinProofObligations` defaults are unchanged.

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
| `swap_diff_preserved` | diff' = diff after swap | `swap_block1_image`, `swap_block2_image` | `swapOracleImage_diff_preserved` | `swap_self_inverse` | planned |
| `swap_self_inverse` | `image(image(j)) = j` for all `p, j` | `swap_diff_preserved` | `swapOracleImage_self_inverse` | `swap_injective`, `swap_bijective` | planned |
| `swap_injective` | Injectivity from self-inverse | `swap_self_inverse` | `swapOracleImage_injective` | `swap_bijective` | planned |
| `swap_lt` | Image preserves `qubitDim` bound | `swap_diff_bounded`, register-width inequality | `swapOracleImage_lt_qubitDim` | `swap_bijective`, post-SWAP cleanup range | proved; SWAP unitarity flag false |
| `swap_bijective` | Bijective on `Fin (qubitDim total)` | `swap_self_inverse`, `swap_injective`, `swap_lt` | `swapOracleImage_bijective` | permutation proof | planned |
| `swap_col_has_one` | For each column j, entry at row image(j) = 1 | `swap_bijective` | `swapOracleMatrix_col_has_one` | `swap_is_permutation` | planned |
| `swap_col_unique` | For each column j, the 1-entry row is unique | `swap_bijective` | `swapOracleMatrix_col_unique` | `swap_is_permutation` | planned |
| `swap_row_has_one` | For each row i, surjectivity: ∃j with M[i][j]=1 | `swap_bijective` | `swapOracleMatrix_row_has_one` | `swap_is_permutation` | planned |
| `swap_row_unique` | For each row i, the 1-entry column is unique | `swap_bijective` | `swapOracleMatrix_row_unique` | `swap_is_permutation` | planned |
| `swap_is_permutation` | Exactly one 1 per row and per column | all above | `swapOracleMatrix_is_permutation` | gate proved update | planned |

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
| `odbs_post_swap_range` | prove the post-SWAP column is a finite basis column when the source image is finite | SWAP range plus paper-image range | `swapOracleImage_lt_qubitDim`, `bandedSparseAccessPaperPostSwapImage_lt_qubitDim_of_address_lt` | finite `post` constructor for cleanup witness | proved; SWAP unitarity flag false |
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
proves inverse uniqueness, semantic dagger cleanup, SWAP unitarity, or either
`O_D^BS` unitarity flag.

### Next Lower Packet: Range Premises for Candidate Cleanup

The next fixed proof target is not another cleanup record.  It is the range
input needed to call the compiled wrapper
`bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate` without external
`Fin` premises.

| Obligation | Planned declaration | Exact role | Status |
|---|---|---|---|
| post-SWAP finite range | `swapOracleImage_lt_qubitDim`, `bandedSparseAccessPaperPostSwapImage_lt_qubitDim_of_address_lt` | prove that `swapOracleImage p (bandedSparseAccessPaperImage p source.val)` is below `qubitDim (oneTermRobinTotalQubits p)` for a finite source and n-bit paper address | proved; SWAP unitarity still false |
| candidate finite range | `bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_cleanSource` | prove that the clean reverse-index candidate is below the same finite basis dimension under the explicit one-term hypotheses | proved |
| no-extra-range cleanup wrapper | `bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate_noRange` | instantiate `BandedSparseAccessPostSwapCleanup` using the two range lemmas, the clean-source Boolean audit, and the existing conditional witness | proved as conditional cleanup witness |

These range lemmas must not promote `daggerCleanup.proved`, SWAP unitarity,
either active `O_D^BS` unitarity flag, or block correctness.

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

No semantic flag changed: `daggerCleanup.proved`, SWAP unitarity, both active
O_D^BS unitarity flags, and block correctness remain unproved.

### Cycle 9 Source-Contract Obstruction: Boundary Unused Sparse Collision

Lean now records the current injectivity blocker as:

```lean
theorem oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3
```

For $n=3,\kappa=7$, source column `0` has row value $0$ and sparse index $0$.
Source column `48` has the same row value and sparse index $3$.  Both columns
are clean according to `bandedSparseAccessPaperCleanInput`, because the padded
part of the $O_D^{BS}$ register has width $0$ in this parameter instance.
Boundary row $0$ has only three stencil entries, so sparse index $3$ is an
unused branch.  The current executable address map sends both branches to
address $0$, and the active gate matrix has a $1$ in row `0` for both source
columns.

This is a source-contract obstruction for the current skeleton's injectivity
and unitarity route.  It does not prove that the paper construction is wrong.
It means the QBE contract must choose and audit one of the following before any
lower agent attempts a permutation proof:

| Required correction | Lean-facing target | Status |
|---|---|---|
| valid sparse-branch domain | a row-dependent predicate distinguishing the sparse indices used by Lemma 1 from unused zero-amplitude branches | candidate defined as `robinSparseColumnBranchValid` and lifted by `bandedSparseAccessPaperValidCleanSource`; paper-source status and full correction remain obligations |
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
`oneTermRobinGate_O_D_BS_dagger.unitary.proved`, SWAP unitarity, and block
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
| collision classifier | for $n=3,\kappa=7$, column `0` is valid, column `48` is unused, both are clean, and the active image still collides |
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

The collision classifier
`bandedSparseAccessUnusedBranchExtensionContract_boundaryCollision_n3` proves
that, for $n=3,\kappa=7$, source column `0` is a valid clean source, source
column `48` is an unused sparse branch, and the active image still maps them to
the same row.  This preserves the obstruction as an explicit contract gap
instead of hiding it inside an injectivity proof search.

The wrapper
`bandedSparseAccessPostSwapCleanup_of_validCleanSourceCandidate_noRange` only
feeds `bandedSparseAccessPaperValidCleanSource` into the existing clean-source
cleanup candidate by extracting the clean-input proof.  It does not make the
valid-clean-source predicate the faithful full domain and does not close
unused-branch extension, uniqueness, semantic dagger cleanup, unitarity, SWAP,
or block-correctness obligations.

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
| clean unused-branch classifier | `bandedSparseAccessPaperUnusedSparseBranch` | defined classifier for invalid zero-amplitude branches |
| unused-branch image-rule slot | `BandedSparseAccessUnusedBranchImageRuleContract` | `proposedImageIndex = none`; image-rule fields false |
| full clean-domain extension slot | `BandedSparseAccessFullCleanDomainExtensionContract` | wrapper defined; nested `proposedImageIndex = none`; all semantic fields false |

Lower packet result:

| Target | Required shape | Guard |
|---|---|---|
| full clean-domain contract record | `BandedSparseAccessFullCleanDomainExtensionContract` with source anchor, valid/unused branch predicate names, nested per-column contracts, and `ObligationRecord` fields for valid-branch agreement, unused-branch image specified/finite, unused-branch injectivity, full clean-domain injectivity, dagger cleanup, and unitary extension | no `Prop := True`, `trivial`, `sorry`, or proof-flag promotion |
| default contract value | `bandedSparseAccessFullCleanDomainExtensionContract (p : OneTermRobinParameters)` | uses existing per-column contract interfaces; nested unused-branch image remains unspecified unless a cited source is added |
| false-flag theorem | `bandedSparseAccessFullCleanDomainExtensionContract_flags_false` | every new semantic field has `proved = false`; nested image-rule status remains `proposedImageIndex = none` |
| active-matrix guard tests | tests in `Tests/Basic.lean` | active forward/dagger matrices remain `bandedSparseAccessPaperMatrix` and `bandedSparseAccessPaperDaggerMatrix`; O_D^BS unitarity, dagger cleanup, SWAP unitarity, and block-correctness flags remain false |

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
`forwardCorrect`, `daggerCleanup`, O_D^BS unitarity, SWAP unitarity, or block
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

Required status until a human supplies or approves a source:

| Obligation | Lean anchor | Required status |
|---|---|---|
| unused zero-branch source decision | `bandedSparseAccessUnusedZeroBranchSourceDecision` | `lowerProofSearchAllowed = false` and `dependency.proved = false` |
| unused zero-branch image choice | `BandedSparseAccessUnusedBranchImageRuleContract.proposedImageIndex` | `none` |
| unused-branch image specified | `BandedSparseAccessFullCleanDomainExtensionContract.unusedBranchImageSpecified` | `proved = false` |
| unused-branch finite image | `BandedSparseAccessFullCleanDomainExtensionContract.unusedBranchImageFinite` | `proved = false` |
| unused-branch injectivity | `BandedSparseAccessFullCleanDomainExtensionContract.unusedBranchInjective` | `proved = false` |
| full clean-domain injectivity | `BandedSparseAccessFullCleanDomainExtensionContract.fullCleanDomainInjective` | `proved = false` |
| dagger cleanup | `BandedSparseAccessFullCleanDomainExtensionContract.daggerCleanup`, `defaultBandedSparseAccessPaperContract p`.daggerCleanup | `proved = false` |
| unitary extension | `BandedSparseAccessFullCleanDomainExtensionContract.unitaryExtension`, `oneTermRobinGate_O_D_BS p`.unitary | `proved = false` |

Proof-DAG row:

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `odbs_unused_zero_branch_source_decision` | either identify a source-backed reversible image rule for clean unused branches, or keep the full clean-domain route blocked | `QBE.ODBS.UnusedZeroBranchExtension`, unused-branch classifier, full clean-domain wrapper | `BandedSparseAccessUnusedZeroBranchSourceDecision`, `bandedSparseAccessUnusedZeroBranchSourceDecision`, `bandedSparseAccessUnusedZeroBranchSourceDecision_flags_false`, `bandedSparseAccessUnusedBranchImageRuleContract`, `BandedSparseAccessFullCleanDomainExtensionContract` | O_D^BS injectivity, dagger cleanup, unitary extension, final block extraction | human-blocking obligation; compiled guard keeps lower proof search disabled for the current colliding image |

The next lower packet should be a source-contract packet only.  It may add an
exact cited theorem or a paper-backed image formula, but it must not attempt
injectivity, unitarity, dagger cleanup, or block correctness before this
obligation is resolved.

### Source Dependency Audit Rule for Next Cycles

For the O_D^BS blocker and any later faithful-paper blocker, middle must read
the local GHL2025 TeX source and bibliography before issuing more lower proof
search.  The local working source is archived outside the public QBE repo at
`../Auto-claude-code-research-in-sleep/paper-sources/GHL2025/main.tex`.
Public artifacts should cite arXiv:2506.20478 and stable paper anchors rather
than this local path.

Each blocked proof block must be classified as one of:

| Classification | Meaning | Required action |
|---|---|---|
| `internal-paper-step` | the paper states/proves the needed fact locally | create a fixed Lean interface tied to the paper anchor |
| `external-cited-result` | the paper relies on another paper or named subroutine | add a precise `research-wiki/cited-results/GHL2025.md` row before lower work |
| `classical-lean-lemma` | the missing fact is arithmetic, finite-map, or matrix algebra | assign a local reusable Lean lemma/proof-DAG block |
| `source-contract-gap` | the paper does not specify enough gate-level data for QBE's stricter oracle contract | keep semantic flags false and request a source-backed contract or human decision |

Reviewer must reject lower packets that continue tactic search on a blocked
faithful-paper statement without this classification.
