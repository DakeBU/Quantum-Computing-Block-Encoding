# GHL2025 Proof Export Status

Source paper: Nikita Guseynov, Xiajie Huang, Nana Liu, "Quantum framework for
simulating linear PDEs with Robin boundary conditions", arXiv:2506.20478.

Lean source: `QuantumBlockEncoding/GHL2025.lean`.

Build gate after this export:

```bash
python3 tools/qbe.py check
```

## Compiled Blocks Exported Here

| Block | Main Lean declarations | Status |
|---|---|---|
| Circuit gate-list alignment | `oneTermRobinPlaceholdersMatch` | proved |
| Dimension compatibility | `Examples.RobinHeat.oneTermRobinCircuitDimCompat` | proved |
| Indicator oracle permutation route | `indicatorOracleImage_self_inverse`, `indicatorOracleImage_bijective`, `indicatorOracleMatrix_is_permutation` | proved |
| SWAP permutation route | `swapOracleImage_self_inverse`, `swapOracleImage_bijective`, `swapOracleMatrix_is_permutation` | proved; SWAP `unitary.proved := true` |
| O_D^BS register-safety route | `bandedSparseAccessPaperAddressInRange_eq_true_of_two_le`, `bandedSparseAccessPaperImage_lt_qubitDim_of_address_lt`, `bandedSparseAccessPaperImage_rowValue_eq`, `bandedSparseAccessPaperImage_odRegisterValue_eq`, `bandedSparseAccessPaperImageNoSpill_eq_true_of_address_lt` | proved executable blocks |
| O_D^BS matrix-entry bridge | `bandedSparseAccessPaperMatrix_imageFin_eq_one`, `bandedSparseAccessPaperDaggerMatrix_imageFin_eq_one`, active gate entry bridge lemmas | proved under explicit hypotheses |
| O_f clean-branch matrix skeleton | `functionOraclePaperMatrix_cleanBranch_entry`, `functionOraclePaperMatrix_cleanWorkspace_offBranch_zero`, `functionOraclePaperMatrix_nonCleanInput_entry` | proved skeleton entries |
| O_f cited amplitude source transcript | `FunctionOracleExternalAmplitudeSourceContract`, `functionOracleExternalAmplitudeSourceContract`, `functionOracleExternalAmplitudeSourceContract_flags_false` | typed transcript; source-side flags false |
| O_f $N_f$ amplitude route | `FunctionOracleAmplitudeProofRoute`, `functionOracleAmplitudeProofRoute`, `functionOracleAmplitudeProofRoute_sourceAnchor`, `functionOracleAmplitudeProofRoute_externalSourceContract`, `functionOracleAmplitudeProofRoute_flags_false` | typed contract route; analytic flags false |
| O_f cited amplitude theorem | `research-wiki/cited-results/GHL2025.md` row `GL2024.Thm5.AmplitudeOracle` | external cited-result recorded as an obligation |
| O_D^BS cited prior primitive | `research-wiki/cited-results/GHL2025.md` row `GHL2024.PDE.Def6Lemma1.ODBS` | external cited-result recorded; it does not close cleanup, unitarity, or final block obligations |
| O_D^BS global-slot source predicate | `bandedSparseAccessPaperSparseIndexInKappa`, `bandedSparseAccessPaperGlobalSlotSource`, `bandedSparseAccessPaperGlobalSlotSource_boundaryColumns_n3`, `bandedSparseAccessPaperGlobalSlotSource_encodedOutOfRange_n3` | active source is padded clean input with $s<\kappa$; old columns `0` and `48` are both active global sources; encoded `s=7` is out of range when $\kappa=7$ |
| O_D^BS active global-slot route guards | `oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSlotBlockers`, `oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSlotGateFreeze`, `oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairBlocked` | active paper-image wiring is pinned to `bandedSparseAccessPaperGlobalSlotSource`; full clean-domain cleanup, full-space unitarity, and semantic promotion remain false |
| O_D^BS rejected row-dependent regression | `oneTermRobinBlockEncodingProofRoute_rejectedRowDependentCollisionRegression_n3` | old row-dependent collision is retained only as regression memory; it is not an active blocker |
| O_D^BS encoded out-of-range guard | `oneTermRobinBlockEncodingProofRoute_encodedOutOfRangeSparseSlot_n3` | clean encoded sparse value $s=7$ is outside the active source range when $\kappa=7$; cleanup and unitarity remain false |
| Seven-gate flag freeze guard | `oneTermRobinGateMatrixPlaceholders_unitaryFlags`, `oneTermRobinBlockEncodingProofRoute_gateUnitaryFlags` | active gate flags remain `[true, false, false, false, false, true, false]`; only $U_{\mathrm{indic}}$ and SWAP are locally proved, and theorem-level circuit-unitary/block flags remain false |
| Seven-gate order-and-flag freeze guard | `oneTermRobinGateMatrixPlaceholders_gateList`, `oneTermRobinBlockEncodingProofRoute_gateListAndFlags` | active matrix labels match Fig. `fig:1 term ROBIN` order while preserving the same flag vector and active global-source cleanup scope |
| Derivative and boundary route bridge | `oneTermRobinBlockEncodingProofRoute_derivativeBoundaryContractMap` | `O_DT^S` and `Ry_boundary` share the same $D_j^{(s)}/N_D$ source route in gate slots 1 and 2; analytic and gate-unitarity flags remain false |
| One-term theorem route | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute`, `oneTermRobinBlockEncodingProofRoute_flags_false`, `oneTermRobinBlockEncodingProofRoute_theoremTranscriptDependencies`, `oneTermRobinBlockEncodingProofRoute_theoremTranscriptActiveCleanupMap` | theorem-level transcript and active-source cleanup evidence are compiled; semantic blockers remain false |
| Theorem layout/projection audit | `defaultOneTermRobinTheoremData_signalQubits_eq_layout`, `defaultOneTermRobinTheoremData_pureAncillas_eq_resource`, `effectiveRobinSignalQubits_eq_layout_signal_plus_visibleWorkspace`, `oneTermRobinBlockEncodingProofRoute_layoutProjectionAudit` | theorem signal and $2n$ pure-ancilla counts are separated from the full non-system projection dimension; cleanup and block flags remain false |
| Block-projection claim guard | `oneTermRobinBlockEncodingProofRoute_claimBlockCorrectFalse`, `oneTermRobinBlockEncodingProofRoute_signalZeroBlockIndices` | circuit-claim block correctness, target projection, and target block equation remain false; signal-zero row/column offsets are pinned |
| Ak target matrix | `Examples.RobinHeat.oneTermRobinAkMatrix`, `oneTermRobinAkMatrix_apply` | theorem target entries are now $f(x_i)D_{ij}$; the derivative matrix remains the derivative-oracle factor |
| Finite composition contract | `FiniteBlockCompositionContract`, `Examples.RobinHeat.oneTermRobinFiniteBlockCompositionContract`, `oneTermRobinBlockEncodingProofRoute_finiteBlockCompositionContractMap` | theorem target, `oneTermRobinAkMatrix`, and normalizer are wired; circuit unitarity, LCU, projection, normalized block equality, and final extraction remain false |
| Gamma3 factor-entry ledger | `oneTermRobinBlockEncodingProofRoute_gamma3FactorEntryLedger` | target entry, clean $O_f$ entry, `O_DT^S` ket-zero entry, `Ry_boundary` ket-zero entry, and active global-source `O_D^BS` dagger entry are packaged for the future signal-block theorem; semantic flags remain false |
| Gamma3 product-entry bridge | `oneTermRobinBlockEncodingProofRoute_gamma3SignalBlockProductEntry` | the signal-zero block entry is identified with the seven-gate `evalGateMatrices` product entry; coefficient equality to the Ak target remains false |
| Gamma3 Ak coefficient-entry contract | `oneTermRobinBlockEncodingProofRoute_gamma3AkCoefficientEntryContract` | the product entry, Ak target entry, expanded $f(x_i)D_{ij}$ entry, and factor-entry ledger are synchronized; semantic flags remain false |
| Gamma3 product-to-coefficient interface | `oneTermRobinBlockEncodingProofRoute_gamma3ProductToCoefficientInterface`, `oneTermRobinGamma3ProductToCoefficientObligation` | the remaining exact entry theorem is named; the obligation is compiled with `proved = false` |
| Gamma3 projection path audit | `oneTermRobinBlockEncodingProofRoute_gamma3ProjectionPathAudit_n3` | current signal-zero helper maps `(2,5)` to full `(2,5)`, but the executable path does not match the clean gamma3 ledger; no semantic flag is promoted |
| Gamma3 paper-basis layout | `oneTermRobinGamma3PaperBasisIndex`, `oneTermRobinBlockEncodingProofRoute_gamma3PaperBasisLayout_n3` | Eq. `ROBIN clarified` clean ket order is mapped to full endpoints `(4,10)` for the focused sparse-slot-zero branch; no semantic flag is promoted |
| Gamma3 paper-basis path audit | `oneTermRobinBlockEncodingProofRoute_gamma3PaperBasisPathAudit_n3` | the slot-zero path from column `10` reaches row `198`, not row `4`; the first mismatch is the `O_D^BS` address writing `3` for row `5`, slot `0` |
| Gamma3 sparse-slot alignment | `oneTermRobinBlockEncodingProofRoute_gamma3SparseSlotAlignment_n3` | the coefficient $D_{2,5}$ uses global sparse slot `5`, with clean endpoints `90` and `84`; semantic flags remain false |
| Gamma3 projection-slot convention map | `oneTermRobinGamma3ProjectionSlotConventionObligation`, `oneTermRobinBlockEncodingProofRoute_gamma3ProjectionSlotConventionMap_n3` | the source-contract gap is named with `proved = false`; generic projection endpoints remain `(2,5)` while slot-`5` clean endpoints are `(84,90)` |
| Gamma3 slot-5 path audit | `oneTermRobinBlockEncodingProofRoute_gamma3Slot5PathAudit_n3` | the full circuit path from column `90` reaches row `228`, not clean row `84`; the next blocker is a projection/register convention |
| Gamma3 projection/register convention decision | `oneTermRobinBlockEncodingProofRoute_gamma3Slot5ProjectionRegisterAudit_n3`, `oneTermRobinGamma3ProjectionRegisterConventionDecision_n3`, `oneTermRobinGamma3ProjectionRegisterConventionDecision_n3_transcript` | endpoint `228` differs from clean endpoint `84` first in the indicator bit and also in sparse index; product search is blocked until a convention is stated |

## Still Open

The following are still obligations, not proved theorems:

- O_D^BS injectivity, inverse-on-range, dagger cleanup, and gate unitarity. The current active source domain is `bandedSparseAccessPaperGlobalSlotSource`; `QBE.ODBS.UnusedZeroBranchExtension` is retained only as rejected-model memory for the old row-dependent helper.
- O_DT^S Eq. (20) coefficient-normalizer relation and rotation unitarity.
- Ry boundary arccos, half-angle, normalizer, and rotation unitarity.
- O_f nonzero $N_f$, division semantics, normalizer bound, orthogonal completion,
  theorem-level amplitude correctness, and unitary extension.
- Final block extraction of the full circuit with normalizer $N_D N_f \kappa$;
  the circuit-claim and target-level block flags are both explicitly false.
- Finite matrix composition for Theorem `1 term robin`; the paper gives the
  theorem statement, Eq. `ROBIN clarified`, Fig. `1 term ROBIN`, and the
  block-encoding definition, but QBE still needs an exact finite theorem before
  any LCU or final-extraction flag can be promoted.
- The gamma3 factor-entry ledger, product-entry bridge, Ak coefficient-entry
  contract, and product-to-coefficient interface are synchronized dependency
  maps.  They do not prove the coefficient equality to `oneTermRobinAkMatrix`
  divided by $N_DN_f\kappa$, nor do they close normalized block equality.
- Target-matrix drift has been corrected at the transcript level:
  `oneTermRobinBlockExtractionTarget`, `oneTermRobinFiniteBlockCompositionContract`,
  and `oneTermRobinBlockEncodingProofRoute` now target
  `oneTermRobinAkMatrix n`, whose entries are $f(x_i)D_{ij}$.
- The Robin-specific projection/layout bridge is now compiled as
  `oneTermRobinBlockEncodingProofRoute_gamma3PaperBasisLayout_n3`.
  Eq. `ROBIN clarified` puts the trailing ancilla at Lean bit `0` and the
  system register in bits `[1,1+n)`, so the clean paper-basis index is
  `(s <<< (1+n+odPure)) + (j <<< 1)`. For `n=3`, `kappa=7`, this is
  `(s <<< 4) + (j <<< 1)`, giving full endpoints `(4,10)` for the focused
  sparse-slot-zero system entry `(2,5)`.
- The paper-basis path audit is now compiled as
  `oneTermRobinBlockEncodingProofRoute_gamma3PaperBasisPathAudit_n3`.  The
  slot-zero path from column `10` reaches row `198`, not row `4`, because
  `O_D^BS` writes address `3` for row `5`, slot `0`.
- The sparse-slot alignment and projection-slot convention map are now
  compiled as `oneTermRobinBlockEncodingProofRoute_gamma3SparseSlotAlignment_n3`
  and `oneTermRobinBlockEncodingProofRoute_gamma3ProjectionSlotConventionMap_n3`.
  They record that $D_{2,5}$ uses slot `5`, with clean endpoints `90` and
  `84`, while the generic signal-zero projection endpoints remain `5` and `2`.
- The slot-`5` path audit is now compiled as
  `oneTermRobinBlockEncodingProofRoute_gamma3Slot5PathAudit_n3`.  The full
  Fig. `1 term ROBIN` path from column `90` reaches row `228`, not row `84`;
  the field-level audit and middle decision now compile as
  `oneTermRobinBlockEncodingProofRoute_gamma3Slot5ProjectionRegisterAudit_n3`
  and `oneTermRobinGamma3ProjectionRegisterConventionDecision_n3`.  The first
  endpoint mismatch is the indicator bit, and the sparse index also differs.
  Product-to-coefficient proof search is blocked until a precise
  projection/register convention is stated.  Normalized-block equality, LCU
  correctness, cleanup, unitarity, block correctness, and final extraction
  remain false.

The latest O_D^BS guards are regression checks, not semantic closure.  The
active theorem route no longer carries unused-zero-branch source fields; it
uses `cleanupScopeDecision` with selected predicate
`bandedSparseAccessPaperGlobalSlotSource`.  Column `8` separates the active
Lemma 1 paper-image matrix from the legacy helper, columns `0` and `48`
record the rejected row-dependent collision only as regression memory, and
`oneTermRobinBlockEncodingProofRoute_encodedOutOfRangeSparseSlot_n3` records
the encoded $s=7$ out-of-range guard for $\kappa=7$.
The cited-results active row is `QBE.ODBS.GlobalSparseSlotAddress`; the older
`QBE.ODBS.UnusedZeroBranchExtension` row is historical rejected-model memory.
The guard `oneTermRobinBlockEncodingProofRoute_gateListAndFlags` additionally
pins the active matrix order to `oneTermRobinCircuit`, so future source-contract
packets cannot silently reorder the seven gates while preserving the same
false-flag vector.

The 2026-05-25 middle source-dependency audit classifies the remaining
full-domain $O_D^{BS}$ cleanup gap as a source-contract gap, not as a Lean
tactic target.  The compiled active-source cleanup map may be reused for
columns satisfying `bandedSparseAccessPaperGlobalSlotSource`, but clean encoded
sparse values outside $s<\kappa$ still need an exact image rule, and full-space
unitarity still needs a precise reversible-extension theorem or cited-results
entry.

The 2026-05-25 middle gamma3 equality audit classifies the remaining focused
product-to-coefficient step as a QBE-local finite matrix/projection attempt.
The source paper gives the theorem, Eq. `ROBIN clarified`, Fig.
`1 term ROBIN`, and the block-encoding definition, but no separate finite
entry proof.  Cited oracle and LCU rows remain contract-only.

The 2026-05-25 projection path audit refines that blocker: the current generic
signal-zero helper treats the system as the low-order `n` bits, while the paper
ket order and Lean Robin extractors place a clean trailing ancilla below the
system register. This is projection contract drift, not an oracle gap.  The
compiled paper-basis bridge fixes the slot-zero endpoints to `(4,10)`, and the
compiled path audit shows that this slot-zero path reaches row `198`, not row
`4`.  The next finite obligation is sparse-slot alignment for the target
coefficient, not unique-path multiplication.

The 2026-05-25 projection-slot convention map is now compiled as
`oneTermRobinBlockEncodingProofRoute_gamma3ProjectionSlotConventionMap_n3`.
It records that the coefficient $D_{2,5}$ uses global sparse slot `5`, with
slot-specific clean endpoints `90` and `84`, while the generic signal-zero
projection endpoints remain `5` and `2`.  The source-contract obligation
`oneTermRobinGamma3ProjectionSlotConventionObligation` remains false.

The 2026-05-25 slot-`5` path audit is now compiled as
`oneTermRobinBlockEncodingProofRoute_gamma3Slot5PathAudit_n3`.  It records that
the clean subchain `90 -> 42 -> 84` is not the full seven-gate path; the actual
path is `90 -> 218 -> 218 -> 218 -> 170 -> 170 -> 212 -> 228`.  Row `228` has
the final dagger entry, while row `84` has zero at that column.  The next finite
target is a projection/register field audit, not product multiplication; no
oracle, LCU, projection, block-correctness, or final-extraction flag has been
promoted.

The 2026-05-25 projection/register decision is now compiled as
`oneTermRobinGamma3ProjectionRegisterConventionDecision_n3`.  It records that
row `228` and row `84` agree on the system row, padded-zero field, trailing
ancilla bit, `m_f` cleanliness, and active-source predicate, but the indicator
bit is `1` versus `0` and the sparse index is `6` versus `5`.  The required
convention remains a source-contract gap with `proved = false`, and
`productSearchBlocked = true`.

Middle selected sparse-register summation as the next convention target,
because Eq. `eq: ROBIN clarified` writes the $\gamma_3$ branch as a sum over
$s=0,\dots,\kappa-1$.  The planned Lean target is
`oneTermRobinGamma3SparseRegisterSummationConvention_n3`.  It must reuse the
compiled endpoint audit, keep the indicator mismatch explicit, and must not
promote product-to-coefficient, LCU, cleanup, unitarity, projection,
block-correctness, normalized equality, or final-extraction flags.

The sparse-register summation convention now compiles as
`oneTermRobinGamma3SparseRegisterSummationConvention_n3`, with transcript
theorem `oneTermRobinGamma3SparseRegisterSummationConvention_n3_transcript`.
It records sparse-register summation as the chosen source-backed convention for
the focused $n=3$, system-entry $(2,5)$ gamma3 audit.  The record keeps the
clean Eq. `eq: ROBIN clarified` endpoint `84` and the full Fig.
`1 term ROBIN` endpoint `228` separate: both have system row `2`, but the clean
endpoint has indicator `0` and sparse index `5`, while the full endpoint has
indicator `1` and sparse index `6`.

This compiled convention is still a contract map.  It does not prove that the
current block projection implements sparse-register summation, and it does not
handle the indicator mismatch.  The field
`indicatorMismatchObligation.proved = false` remains the next explicit
projection/register obligation before any gamma3 product-to-coefficient proof
search resumes.

The indicator-field gap is now compiled as
`oneTermRobinGamma3SparseRegisterSummation_indicatorGap_n3`.  It confirms that
sparse-register summation alone leaves the endpoint indicators different:
the clean endpoint `84` has indicator `0`, while the full endpoint `228` has
indicator `1`.  The next proof-map target is an exact indicator
projection/register convention.  Until that convention is stated, product
search, LCU correctness, block projection, block correctness, normalized
equality, and final extraction remain false.

The indicator projection convention is now also compiled as
`oneTermRobinGamma3IndicatorProjectionConvention_n3`, with transcript theorem
`oneTermRobinGamma3IndicatorProjectionConvention_n3_transcript`.  The source
audit around Eq. `eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, Definition
`def:block-encoding`, and the $U_{\mathrm{indic}}$ paragraph found no stated
rule that resets, ignores, sums over, or permutes the indicator field after the
seven-gate path.  The Lean record therefore keeps
`indicatorRelationSpecifiedBySource = false`, `humanInputRequired = true`, and
`conventionObligation.proved = false`.

This is the active theorem-facing blocker for the focused $n=3$,
system-entry $(2,5)$ gamma3 route.  Product-to-coefficient search must remain
parked until a source-backed indicator projection/register rule replaces that
false obligation.  The LCU, cleanup, unitarity, block projection, block
correctness, normalized equality, and final-extraction flags remain false.

The bulk-indicator source audit now compiles as
`oneTermRobinGamma3BulkIndicatorSourceAudit_n3`, with transcript theorem
`oneTermRobinGamma3BulkIndicatorSourceAudit_n3_transcript`.  For the focused
column $j=5$, the paper's $U_{\mathrm{indic}}$ rule applies because
$K_1=2$ and $K_2=5$, so the source-backed indicator value is `1`.  Lean records
that endpoint `228` matches this source value, while clean endpoint `84` has
indicator `0`.

This does not close the projection/register gap.  It makes the gap sharper:
a future convention must explain how the theorem-level block treats the
source-backed indicator `1` at endpoint `228`; it must not silently reset that
field to `0`.  Product-to-coefficient equality, LCU correctness, cleanup,
unitarity, block projection, block correctness, normalized equality, and final
extraction remain false.
