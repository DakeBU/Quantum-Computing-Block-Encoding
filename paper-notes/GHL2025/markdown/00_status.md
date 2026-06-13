# GHL2025 Proof Export Status

Source paper: Nikita Guseynov, Xiajie Huang, Nana Liu, "Quantum framework for
simulating linear PDEs with Robin boundary conditions", arXiv:2506.20478.

Lean source: `QuantumBlockEncoding/GHL2025.lean`.

Build gate after this export:

```bash
python3 tools/qbe.py check
```

## Current Frontier: Finite Projection Feeder Under Explicit Uniform Contract

Definitions:

- `Uniform(H)` is
  `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.
- `EvaluatedBackendFold(env)` is
  `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`.
- `SourcePreparedField(H, env)` is
  `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement`.

The active export frontier is `finite_projection_feeder`: prove
`EvaluatedBackendFold(env)` or one strict finite theorem feeding it, then
consume the result through
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3
H env hUniform hFold`.

The arbitrary-`H` `SourcePreparedField(H, env)` target is retired as the
default lower target unless a true all-`H` composition or clean-column
independence theorem is assigned.  The compiled bridge
`oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3`
is route wiring only; it does not prove the active/prepared equality, the
evaluated backend fold, the final one-term Robin block-encoding theorem, or any
external sparse-preparation/oracle primitive.

| Item | Lean declaration or target | Status |
|---|---|---|
| finite projection feeder | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`, or one strict finite theorem feeding it | active lower2 leaf; open |
| source-prepared recovery | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3 H env hUniform hFold` | compiled conditional route; not closure without `hFold` |
| arbitrary-`H` source-prepared field | `SourcePreparedField(H, env)` | retired as default lower target |
| post-feeder sparse-clean to fold bridge | `oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3 H env hUniform` | compiled route wiring; retired as a lower target |
| external sparse preparation | `Uniform(H)` | contract-only; no Shukla--Vedula formalization here |

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

## 2026-05-26 Boundary Ry Corrected-Angle Decision

Upper and middle re-audited the boundary $R_y$ blocker against the local
GHL2025 source, the prior PDE block-encoding construction, and the companion
Robin heat implementation.  The local paper line Eq. `eq:angles for Ry` writes
`theta_j^s = arccos(D_j^(s) / N_D)`, while the standard $R_y(theta)$ gate used
by the companion implementation has clean entry $cos(theta/2)$.  The companion
Robin heat code computes boundary correction angles with `2 * np.arccos(...)`,
and the prior sparse-amplitude construction in arXiv:2405.12855 uses the same
factor-two pattern.

The faithful continuation is now recorded as a source-backed correction route:

$$
theta_j^s = 2 arccos(D_j^(s) / N_D).
$$

Lean declaration:
`Examples.RobinHeat.oneTermRobinGamma3BoundaryRyCorrectedAngleSourceDecision_n3`.
The transcript theorem compiles and records that lower product search may resume
through this corrected-angle route.  No semantic theorem has been promoted:
product-to-coefficient equality, LCU correctness, cleanup, unitarity, block
projection, block correctness, normalized equality, circuit unitarity, and final
extraction remain false until Lean proves them.

The corrected route now has a conditional coefficient interface:
`Examples.RobinHeat.oneTermRobinGamma3BoundaryCorrectedCoefficientInterface_n3`
and
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_correctedAngle_n3`.
These declarations rewrite the finite product through
`boundaryRotationNormalizedCoefficient (oneTermParameters 3) 0 2` under the
corrected-entry hypothesis.  The hypothesis and the focused
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remain false.

## 2026-05-27 Boundary Normalizer/Projection Audit

Middle re-read GHL2025 Theorem `theorem: 1 term robin`, Eq.
`eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, and Definition
`def:block-encoding`.  The corrected boundary branch now has two compiled
local facts:

$$
\text{product}_{32,32}
= (f_3(0)N_f^{-1})(D_0^{(2)}N_D^{-1}),
$$

and

$$
(A_k)_{0,0}=f_3(0)D_0^{(2)}.
$$

The remaining blocker is the theorem-level normalization convention.  Eq.
`eq: ROBIN clarified` gives the boundary gamma3 coefficient with denominator
$N_DN_f\kappa$, while the current Lean product uses symbolic factors
`N_D_inv` and `N_f_inv` and still needs a typed sparse-register
projection/summation convention for the $\kappa$ factor.

The active obstruction is
`oneTermRobinGamma3BoundaryProductToCoefficientObstruction_n3`.  Its fields
`normalizedQuotientConvention` and `sparseRegisterProjectionConvention` remain
`proved = false`.  The next lower packet should add a narrow convention record
or lemma, suggested as
`oneTermRobinGamma3BoundaryNormalizerProjectionConvention_n3`, reusing the
existing obstruction packet.  It must not promote product-to-coefficient, LCU,
cleanup, unitarity, block projection, block correctness, normalized equality,
circuit unitarity, or final extraction.

The lower convention packet now compiles as
`oneTermRobinGamma3BoundaryNormalizerProjectionConvention_n3`, and middle has
split it into the next proof target
`oneTermRobinGamma3BoundaryNormalizerSplitTarget_n3`.  This target keeps the
focused theorem obligation
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` fixed while separating
two sub-obligations:

| Sub-obligation | Lean field | Status |
|---|---|---|
| `N_D_inv` and `N_f_inv` supply the symbolic inverse factors for $N_DN_f$ | `symbolicInverseObligation.proved` | false |
| the sparse-register branch supplies the remaining $1/\kappa$ projection factor | `kappaProjectionObligation.proved` | false |
| finite normalized block equality | `finiteCompositionNormalizedEquality.proved` | false |
| focused product-to-coefficient theorem | `productObligation.proved` | false |

The transcript theorem
`oneTermRobinGamma3BoundaryNormalizerSplitTarget_n3_transcript` compiles and
checks that the split target reuses the existing convention.  It does not
upgrade LCU, block projection, block correctness, normalized equality, circuit
unitarity, or final extraction.

## 2026-05-27 Boundary Kappa-Projection Conditional Lemma

The lower algebra lemma
`Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionEval_n3`
compiles. For any coefficient environment satisfying the three explicit
right-inverse hypotheses

$$
\mathrm{env}(N_D^{-1})\mathrm{env}(N_D)=1,\quad
\mathrm{env}(N_f^{-1})\mathrm{env}(N_f)=1,\quad
\mathrm{env}(\kappa^{-1})\mathrm{env}(\kappa)=1,
$$

the projected branch product cancels against the theorem normalizer:

$$
\mathrm{eval}(\text{branchLocalProduct}\cdot\kappa^{-1})
\mathrm{eval}(N_DN_f\kappa)
=
\mathrm{eval}(\text{targetEntry}).
$$

The packet
`Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionSemantics_n3`
records this conditional algebra as part of the boundary route. The source
meaning of the inserted `Coeff.symbol "kappa_inv"` is still unproved. It must
come from the $H_W^{(\kappa)}$ sparse-register preparation in GHL2025 Eq.
`arbitrary sparcity`, the cited Shukla-Vedula uniform-superposition contract,
and the finite block-projection convention for the focused sparse slot.

| Proof block | Lean declaration | Status |
|---|---|---|
| symbolic cancellation of `kappa_inv` with the theorem normalizer | `oneTermRobinGamma3BoundaryKappaProjectionEval_n3` | compiled under explicit hypotheses |
| packet recording the projected branch product | `oneTermRobinGamma3BoundaryKappaProjectionSemantics_n3` | compiled; semantic fields false |
| uniform sparse-register preparation | `oneTermRobinGamma3BoundaryUniformSparseRegisterPreparationObligation_n3` | false |
| matching sparse-register projection | `oneTermRobinGamma3BoundaryKappaProjectionSemantics_n3.kappaProjectionObligation` | false |
| final normalized block equality | `oneTermRobinFiniteBlockCompositionContract.normalizedBlockEquality` | false |

The next Lean-facing target is a projection/source-contract packet that
connects the compiled `kappa_inv` algebra to the paper's $H_W^{(\kappa)}$
preparation and block projection. It must not promote product-to-coefficient,
LCU, cleanup, unitarity, block projection, block correctness, normalized
equality, circuit unitarity, or final extraction.

## 2026-05-27 Boundary Projection Source Contract

The projection/source contract now compiles as
`Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSourceContract_n3`.
It records that the intended source of `Coeff.symbol "kappa_inv"` is the
product of the $H_W^{(\kappa)}$ preparation amplitude
$1/\sqrt{\kappa}$ and the matching sparse-register projection amplitude
$1/\sqrt{\kappa}$ for focused slot `2`.

The transcript theorem
`Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSourceContract_n3_transcript`
checks the focused data $\kappa=7$, slot `2`, and basis index `32`. It leaves
the uniform-preparation obligation, matching-projection obligation,
projection-factor semantics, finite normalized equality, and focused
product-to-coefficient obligation false.

## 2026-05-27 Middle Post-Projection Packet

The next fixed Lean target is the projection-factor semantics field in
`Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSourceContract_n3`.
The source of the factor is now documented, but the finite projection theorem
is not proved.

| Item | Lean declaration | Status |
|---|---|---|
| source contract for `kappa_inv` | `oneTermRobinGamma3BoundaryProjectionSourceContract_n3` | compiled |
| uniform sparse-register preparation | `uniformPreparationObligation.proved` | false |
| matching projection onto slot `2` | `matchingProjectionObligation.proved` | false |
| product represented as `Coeff.symbol "kappa_inv"` | `projectionFactorSemantics.proved` | false |
| focused product theorem | `productObligation.proved` | false |

The lower packet should state a narrow finite projection-factor interface for
focused slot `2`, reusing the compiled source contract and
`oneTermRobinGamma3BoundaryKappaProjectionEval_n3`. It must not promote LCU,
block projection, block correctness, normalized equality, circuit unitarity, or
final extraction.

## 2026-05-27 Boundary Projection Factor Interface

The finite projection-factor interface now compiles as
`Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorSemantics_n3`,
with the index lemma
`Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorIndex_n3`.
The index lemma checks that the prepared sparse slot and projected sparse slot
are both slot `2`, and both sides use clean basis index `32`.

This is not yet the projection theorem.  The remaining source-facing statement
is that the $H_W^{(\kappa)}$ amplitude $1/\sqrt{\kappa}$ and the matching
sparse-slot projection amplitude $1/\sqrt{\kappa}$ multiply to the symbolic
factor `Coeff.symbol "kappa_inv"` used by the boundary product route.

| Item | Lean declaration | Status |
|---|---|---|
| finite slot and basis agreement | `oneTermRobinGamma3BoundaryProjectionFactorIndex_n3` | compiled |
| projection-factor interface | `oneTermRobinGamma3BoundaryProjectionFactorSemantics_n3` | compiled; semantic fields false |
| uniform sparse-register preparation | `uniformPreparationObligation.proved` | false |
| matching projection onto slot `2` | `matchingProjectionObligation.proved` | false |
| product represented as `Coeff.symbol "kappa_inv"` | `factorSemanticsObligation.proved` | false |
| focused product theorem | `productObligation.proved` | false |

The next lower target remains
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`, routed through this
projection-factor interface.  No LCU, block projection, block correctness,
normalized equality, circuit unitarity, or final extraction flag has been
promoted.

## 2026-05-27 Projection-Factor Obstruction Split

The obstruction packet now compiles as
`Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorObstruction_n3`.
It records that the remaining `kappa_inv` theorem has two inputs: the cited
$H_W^{(\kappa)}$ per-slot amplitude and QBE's matching sparse-slot projection
convention for slot `2`.

| Item | Lean declaration | Status |
|---|---|---|
| obstruction packet | `oneTermRobinGamma3BoundaryProjectionFactorObstruction_n3` | compiled; semantic fields false |
| cited uniform sparse-register amplitude | `uniformPreparationObligation.proved` | false; contract-only via `ShuklaVedula2024.HWkappaUniformSuperposition` |
| matching projection onto slot `2` | `matchingProjectionObligation.proved` | false |
| product represented as `Coeff.symbol "kappa_inv"` | `factorSemanticsObligation.proved` | false |
| focused product theorem | `productObligation.proved` | false |

Middle's next lower packet targets the local matching-projection convention,
not the Shukla-Vedula state-preparation implementation.  It should reuse the
obstruction packet, the finite slot-index lemma, and
`oneTermRobinGamma3BoundaryKappaProjectionEval_n3`, while leaving LCU, block
projection, block correctness, normalized equality, circuit unitarity, and
final extraction false.

## 2026-05-27 Matching Projection Convention

The matching-projection convention now compiles as
`Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionConvention_n3`.
It states the local projection side of the focused boundary route: the bra
selects sparse slot `2` at clean basis index `32`, matching the prepared branch
recorded by the finite index lemma.

This is still not the projection-amplitude theorem. The matching projection
obligation, the cited uniform-preparation obligation, the `kappa_inv` factor
semantics, finite normalized equality, and the focused product theorem all
remain false.

| Item | Lean declaration | Status |
|---|---|---|
| matching projection convention | `oneTermRobinGamma3BoundaryMatchingProjectionConvention_n3` | compiled; semantic fields false |
| transcript check | `oneTermRobinGamma3BoundaryMatchingProjectionConvention_n3_transcript` | compiled |
| matching projection amplitude | `matchingProjectionObligation.proved` | false |
| uniform sparse-register preparation | `uniformPreparationObligation.proved` | false; contract-only via `ShuklaVedula2024.HWkappaUniformSuperposition` |
| product represented as `Coeff.symbol "kappa_inv"` | `factorSemanticsObligation.proved` | false |
| focused product theorem | `productObligation.proved` | false |

The next lower target should prove or further classify the matching projection
amplitude for slot `2`; it should not promote product-to-coefficient, LCU,
block projection, block correctness, normalized equality, circuit unitarity, or
final extraction.

## 2026-05-27 Middle Post-Matching Projection Sync

The compiled matching-projection convention is
`Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionConvention_n3`.
It fixes the local projection bra to focused sparse slot `2` and clean basis
index `32`, matching the prepared branch in the finite index lemma. It is still
not the projection-amplitude theorem.

| Item | Lean declaration | Status |
|---|---|---|
| matching projection convention | `oneTermRobinGamma3BoundaryMatchingProjectionConvention_n3` | compiled; semantic fields false |
| transcript check | `oneTermRobinGamma3BoundaryMatchingProjectionConvention_n3_transcript` | compiled |
| ket-side sparse-register amplitude | `uniformPreparationObligation.proved` | false; contract-only via `ShuklaVedula2024.HWkappaUniformSuperposition` |
| bra-side matching projection amplitude | `matchingProjectionObligation.proved` | false |
| product represented as `Coeff.symbol "kappa_inv"` | `factorSemanticsObligation.proved` | false |
| focused product theorem | `productObligation.proved` | false |

The next lower packet should target the bra-side matching projection amplitude
or the smaller factor-semantics obstruction. It should reuse
`oneTermRobinGamma3BoundaryMatchingProjectionConvention_n3_transcript`,
`oneTermRobinGamma3BoundaryProjectionFactorIndex_n3`,
`oneTermRobinGamma3BoundaryProjectionSourceContract_n3_transcript`, and
`oneTermRobinGamma3BoundaryKappaProjectionEval_n3`. It must not recursively
formalize Shukla-Vedula or promote product-to-coefficient, LCU, block
projection, normalized equality, block correctness, circuit unitarity, or final
extraction.

## 2026-05-27 Matching Projection Amplitude Obstruction

The bra-side matching projection amplitude has been narrowed to a compiled
obstruction packet:
`Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeObstruction_n3`.
It reuses the matching-projection convention and records the two separate
amplitude inputs for the focused sparse slot `2`.

| Item | Lean declaration | Status |
|---|---|---|
| symbolic product algebra | `oneTermRobinGamma3BoundaryProjectionFactorProductEval_n3` | compiled under the explicit hypothesis `sqrt_kappa_inv * sqrt_kappa_inv = kappa_inv` |
| matching projection amplitude obstruction | `oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeObstruction_n3` | compiled; semantic fields false |
| transcript check | `oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeObstruction_n3_transcript` | compiled |
| ket-side sparse-register amplitude | `.uniformPreparationObligation.proved` | false; contract-only via `ShuklaVedula2024.HWkappaUniformSuperposition` |
| bra-side matching projection amplitude | `.matchingProjectionObligation.proved` | false |
| product represented as `Coeff.symbol "kappa_inv"` | `.factorSemanticsObligation.proved` | false |
| focused product theorem | `.productObligation.proved` | false |

This packet does not promote product-to-coefficient, LCU, block projection,
normalized equality, block correctness, circuit unitarity, or final extraction.
The next lower target is the actual bra-side projection amplitude theorem or a
source-backed QBE projection contract for that amplitude.

## 2026-05-27 Matching Projection Amplitude Contract

The focused bra-side projection amplitude now has a compiled contract:
`Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeContract_n3`.
It fixes the matching block-projection bra to sparse slot `2`, clean basis
index `32`, and expected factor `Coeff.symbol "sqrt_kappa_inv"`.

This is still a contract. The source split remains as follows: GHL2025 Eq.
`arbitrary sparcity` and the Shukla-Vedula cited result provide only the
ket-side $1/\sqrt{\kappa}$ contract, while Definition `def:block-encoding`
and Eq. `eq: ROBIN clarified` require QBE to justify the matching bra-side
$1/\sqrt{\kappa}$ projection factor.

| Item | Lean declaration | Status |
|---|---|---|
| bra-side amplitude contract | `oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeContract_n3` | compiled; semantic fields false |
| transcript check | `oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeContract_n3_transcript` | compiled |
| ket-side uniform preparation | `uniformPreparationProved` | false; contract-only via `ShuklaVedula2024.HWkappaUniformSuperposition` |
| bra-side matching projection amplitude | `amplitudeContractObligation.proved` | false |
| product represented as `Coeff.symbol "kappa_inv"` | `factorSemanticsObligation.proved` | false |
| symbolic product algebra | `oneTermRobinGamma3BoundaryProjectionFactorProductEval_n3` | compiled under an explicit coefficient-environment hypothesis |
| focused product theorem | `productObligation.proved` | false |

The next lower packet should start from
`oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeContract_n3_transcript`
and either prove the finite bra-side projection amplitude for sparse slot `2`
or state the exact local QBE projection contract needed to accept it. It must
not recursively formalize Shukla-Vedula or promote product-to-coefficient,
LCU composition, block projection, normalized equality, block correctness,
circuit unitarity, or final extraction.

## 2026-05-27 Projection-Amplitude Semantics Contract

The focused boundary route now has a compiled Phase-1 semantics packet:
`Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeSemantics_n3`.
It accepts the ket-side `H_W^(kappa)` amplitude and the bra-side matching
projection amplitude only as contracts, both represented by
`Coeff.symbol "sqrt_kappa_inv"`.

The compiled theorem
`oneTermRobinGamma3BoundaryProjectionAmplitudeContractProductEval_n3` proves
only the symbolic product step. It requires the explicit coefficient
hypothesis
`env "sqrt_kappa_inv" * env "sqrt_kappa_inv" = env "kappa_inv"`.
It does not prove the cited state-preparation circuit, the matching
block-projection amplitude, or the product-to-coefficient theorem.

| Item | Lean declaration | Status |
|---|---|---|
| projection-amplitude semantics packet | `oneTermRobinGamma3BoundaryProjectionAmplitudeSemantics_n3` | compiled; semantic fields false |
| transcript check | `oneTermRobinGamma3BoundaryProjectionAmplitudeSemantics_n3_transcript` | compiled |
| conditional product lemma | `oneTermRobinGamma3BoundaryProjectionAmplitudeContractProductEval_n3` | compiled under explicit product hypothesis |
| ket-side uniform preparation | `uniformPreparationObligation.proved` | false; contract-only via `ShuklaVedula2024.HWkappaUniformSuperposition` |
| bra-side matching projection amplitude | `braAmplitudeObligation.proved` | false |
| product represented as `Coeff.symbol "kappa_inv"` | `factorSemanticsObligation.proved` | false |
| finite normalized block equality | `finiteCompositionNormalizedEquality.proved` | false |
| focused product theorem | `productObligation.proved` | false |

The next lower packet should target `factorSemanticsObligation` for the fixed
slot `2` branch, starting from
`oneTermRobinGamma3BoundaryProjectionAmplitudeSemantics_n3_transcript`,
`oneTermRobinGamma3BoundaryProjectionAmplitudeContractProductEval_n3`, and
`oneTermRobinGamma3BoundaryKappaProjectionEval_n3`. It must not recursively
formalize Shukla-Vedula or promote product-to-coefficient, LCU composition,
block projection, normalized equality, block correctness, circuit unitarity, or
final extraction.

## 2026-05-27 Projection-Amplitude Factor Bridge

The focused boundary route now has a compiled conditional bridge:
`Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeFactorSemantics_n3`.
It records that the accepted ket and bra amplitude contracts can replace the
inserted `kappa_inv` factor only under explicit coefficient-environment
hypotheses.

The theorem
`oneTermRobinGamma3BoundaryProjectionAmplitudeFactorEval_n3` combines the
symbolic product lemma
`oneTermRobinGamma3BoundaryProjectionAmplitudeContractProductEval_n3` with the
normalizer cancellation lemma `oneTermRobinGamma3BoundaryKappaProjectionEval_n3`.
It does not prove the $H_W^{(\kappa)}$ amplitude, the matching projection
amplitude, or the product-to-coefficient statement.

| Item | Lean declaration | Status |
|---|---|---|
| conditional factor bridge | `oneTermRobinGamma3BoundaryProjectionAmplitudeFactorEval_n3` | compiled under explicit inverse and product hypotheses |
| factor-semantics packet | `oneTermRobinGamma3BoundaryProjectionAmplitudeFactorSemantics_n3` | compiled; semantic fields false |
| transcript check | `oneTermRobinGamma3BoundaryProjectionAmplitudeFactorSemantics_n3_transcript` | compiled |
| ket-side uniform preparation | `uniformPreparationObligation.proved` | false; contract-only via `ShuklaVedula2024.HWkappaUniformSuperposition` |
| bra-side matching projection amplitude | `braAmplitudeObligation.proved` | false |
| product represented as `Coeff.symbol "kappa_inv"` | `factorSemanticsObligation.proved` | false |
| finite normalized block equality | `finiteCompositionNormalizedEquality.proved` | false |
| focused product theorem | `productObligation.proved` | false |

No product-to-coefficient, LCU composition, block projection, normalized
equality, block correctness, circuit unitarity, or final extraction was
promoted.

## 2026-05-27 HW-Dagger Adjoint Convention

The focused boundary route now has a compiled local adjoint convention for the
symbolic sparse-register preparation matrix:
`Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerAdjointEntryConvention_n3`.
The local dagger is represented by the transpose-style matrix
`oneTermRobinGamma3BoundaryHWKappaDaggerTransposeMatrix_n3`, so the focused
entry satisfies
$H_W^{(\kappa)\dagger}[0,2] = H_W^{(\kappa)}[2,0]$.

The theorem
`oneTermRobinGamma3BoundaryHWKappaDaggerEntryFromTransposeUniformColumn_n3`
still assumes the external clean-column source
$H_W^{(\kappa)}[2,0] = 1/\sqrt{\kappa}$.  That source remains the
Shukla--Vedula contract used by GHL2025 Eq. `arbitrary sparcity`; it is not
proved in this packet.

| Item | Lean declaration or field | Status |
|---|---|---|
| transpose-style local dagger | `oneTermRobinGamma3BoundaryHWKappaDaggerTransposeMatrix_n3` | compiled |
| focused adjoint convention | `oneTermRobinGamma3BoundaryHWKappaDaggerTransposeEntryConvention_n3` | compiled |
| conditional dagger entry from clean column | `oneTermRobinGamma3BoundaryHWKappaDaggerEntryFromTransposeUniformColumn_n3` | compiled under the uniform-column hypothesis |
| adjoint convention packet | `oneTermRobinGamma3BoundaryHWKappaDaggerAdjointEntryConvention_n3` | compiled |
| local adjoint convention flag | `adjointEntryConventionObligation.proved` | true |
| clean-column uniform source | `uniformColumnObligation.proved` | false |
| full dagger entry and bra amplitude | `daggerEntryProved`, `braAmplitudeProved` | false |
| focused product theorem | `productObligation.proved` | false |

No product-to-coefficient, LCU composition, cleanup, unitarity, block
projection, normalized equality, block correctness, circuit unitarity, or
final extraction was promoted.

## 2026-05-27 Factor-Semantics Contract Map

The focused boundary route now has a compiled contract map:
`Examples.RobinHeat.oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3`.
It is downstream of
`oneTermRobinGamma3BoundaryProjectionAmplitudeFactorSemantics_n3` and maps the
remaining factor-semantics obligation to four explicit inputs: ket amplitude,
bra amplitude, square-root product identity, and finite normalized block
composition.

The theorem
`oneTermRobinGamma3BoundaryFactorSemanticsContractMapEval_n3` proves only the
conditional coefficient step through the contract-map fields. It assumes
`N_D_inv*N_D=1`, `N_f_inv*N_f=1`, `kappa_inv*kappa=1`, and
`sqrt_kappa_inv*sqrt_kappa_inv=kappa_inv`.

| Item | Lean declaration or field | Status |
|---|---|---|
| contract map | `oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3` | compiled; semantic fields false |
| conditional eval | `oneTermRobinGamma3BoundaryFactorSemanticsContractMapEval_n3` | compiled under explicit environment hypotheses |
| transcript check | `oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3_transcript` | compiled |
| ket-side uniform preparation | `ketAmplitudeObligation.proved` | false |
| bra-side matching projection amplitude | `braAmplitudeObligation.proved` | false |
| square-root product identity | `productHypothesisObligation.proved` | false |
| factor semantics | `factorSemanticsObligation.proved` | false |
| finite normalized block equality | `finiteCompositionNormalizedEquality.proved` | false |
| focused product theorem | `productObligation.proved` | false |

No product-to-coefficient, LCU composition, block projection, normalized
equality, block correctness, circuit unitarity, or final extraction was
promoted.

## 2026-05-27 Clean-Column To Bra-Route Handoff

The current compiled input is
`Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaCleanColumnContract_n3`.
It records $H_W^{(\kappa)}[2,0] = 1/\sqrt{\kappa}$ as a contract-only input
from GHL2025 Eq. `arbitrary sparcity` and the Shukla--Vedula cited row. The
conditional theorem
`oneTermRobinGamma3BoundaryHWKappaCleanColumnContract_feedsTransposeBridge_n3`
shows that this input feeds the local transpose-style dagger convention.

The next Lean task is to connect that bridge to
`oneTermRobinGamma3BoundaryBraProjectionAmplitudeSourceMap_n3` and
`oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3`. Until that route
map compiles, the bra amplitude, factor semantics, normalized equality, and
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remain false.

## 2026-05-27 Clean-Column To Bra-Route Contract

The route map now compiles as
`Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnBraRouteContract_n3`.
It connects the contract-only clean-column bridge to both active bra-amplitude
fields:
`oneTermRobinGamma3BoundaryBraProjectionAmplitudeSourceMap_n3.amplitudeContractObligation`
and `oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3.braAmplitudeObligation`.

The theorem
`oneTermRobinGamma3BoundaryCleanColumnBraRouteContract_feedsBraAmplitude_n3`
is still conditional on the external clean-column hypothesis
$H_W^{(\kappa)}[2,0] = 1/\sqrt{\kappa}$. It only rewrites that hypothesis
through the compiled transpose bridge to the expected `sqrt_kappa_inv` bra
factor.

No product-to-coefficient, LCU composition, block projection, normalized
equality, block correctness, circuit unitarity, or final extraction was
promoted.

## 2026-05-27 Current Factor-Semantics Route Packet

The current lower-facing target is the under-contract factor-semantics bridge.
It should use `oneTermRobinGamma3BoundaryCleanColumnBraRouteContract_n3` as
the bra-factor input to `oneTermRobinGamma3BoundaryFactorSemanticsContractMapEval_n3`.

The bridge may assume the external clean-column amplitude, the ket-side
sparse-register amplitude, the square-root product identity, and the finite
normalized block equality as explicit contracts. It must keep
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` and all downstream
block-encoding flags false.

## 2026-05-27 Clean-Column To Factor-Semantics Route

The current route now compiles as
`Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRoute_n3`.
It uses `oneTermRobinGamma3BoundaryCleanColumnBraRouteContract_n3` as the
bra-factor input to
`oneTermRobinGamma3BoundaryFactorSemanticsContractMapEval_n3`.

The theorem
`oneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRouteEval_n3` is
conditional on the external clean-column amplitude
$H_W^{(\kappa)}[2,0]=1/\sqrt{\kappa}$ and on coefficient-environment
identities for `N_D_inv`, `N_f_inv`, `kappa_inv`, and `sqrt_kappa_inv`.
It compiles the route into the factor-semantics calculation, but it does not
prove the cited state-preparation theorem, the ket-side amplitude, the
square-root product convention, finite LCU composition, or the focused
product-to-coefficient theorem.

| Item | Lean declaration or field | Status |
|---|---|---|
| clean-column factor route | `oneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRoute_n3` | compiled; semantic fields false |
| conditional route eval | `oneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRouteEval_n3` | compiled under external and coefficient hypotheses |
| transcript check | `oneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRoute_n3_transcript` | compiled |
| clean-column source contract | `uniformColumnObligation.proved` | false |
| ket-side sparse-register amplitude | `ketAmplitudeObligation.proved` | false |
| square-root product identity | `productHypothesisObligation.proved` | false |
| finite normalized block equality | `finiteCompositionNormalizedEquality.proved` | false |
| fixed product theorem | `productObligation.proved` | false |

The next lower packet should keep
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` fixed and use this
route to state a product-under-contracts interface, or record the smallest
missing field among ket amplitude, coefficient product convention, finite
normalized equality, and projection/product bridge.  No product-to-coefficient,
LCU composition, block projection, normalized equality, block correctness,
circuit unitarity, or final extraction flag has been promoted.

## 2026-05-27 Product Under Contracts Route

The current route now compiles as
`Examples.RobinHeat.oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3`.
It uses `oneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRoute_n3` as the
local coefficient engine and points to the fixed boundary obligation
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.

The theorem `oneTermRobinGamma3BoundaryProductUnderContractsEval_n3` is
conditional on the external clean-column amplitude
$H_W^{(\kappa)}[2,0]=1/\sqrt{\kappa}$ and on the coefficient-environment
identities for `N_D_inv`, `N_f_inv`, `kappa_inv`, and `sqrt_kappa_inv`.
It compiles only the local coefficient calculation.  It does not prove the
Shukla--Vedula uniform-preparation theorem, LCU composition, the finite
projection/product bridge, or the focused product-to-coefficient theorem.

| Item | Lean declaration or field | Status |
|---|---|---|
| product-under-contracts route | `oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3` | compiled; semantic fields false |
| conditional route eval | `oneTermRobinGamma3BoundaryProductUnderContractsEval_n3` | compiled under external and coefficient hypotheses |
| transcript check | `oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3_transcript` | compiled |
| clean-column source contract | `uniformColumnObligation.proved` | false |
| ket-side sparse-register amplitude | `ketAmplitudeObligation.proved` | false |
| square-root product identity | `productHypothesisObligation.proved` | false |
| projection/product bridge | `productBridgeObligation.proved` | false |
| finite normalized block equality | `finiteCompositionNormalizedEquality.proved` | false |
| fixed product theorem | `productObligation.proved` | false |

The next lower packet should keep
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` fixed and target the
finite projection/product bridge exposed by
`productBridgeObligation`.  The finite normalized equality remains
contract-only through `LCU.StandardBlockEncoding` unless an exact finite theorem
is added.  No product-to-coefficient, LCU composition, block projection,
normalized equality, block correctness, circuit unitarity, or final extraction
flag has been promoted.

## 2026-05-27 Finite Projection/Product Bridge

The current bridge compiles as
`Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3`.
It consumes the product-under-contracts route and records the finite
block-entry indices for the focused boundary case.  Definition
`def:block-encoding` selects the signal-zero block entry for system `(0,0)`,
which is the full matrix entry `[0,0]`.  The branch-correct sparse-slot route
from Eq. `ROBIN clarified` still lives at slot `2`, whose embedded basis index
is `32`.

| Item | Lean declaration or field | Status |
|---|---|---|
| finite block-entry index | `oneTermRobinGamma3BoundaryFiniteProjectionBlockEntryIndex_n3` | compiled |
| finite bridge record | `oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3` | compiled; semantic fields false |
| transcript check | `oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3_transcript` | compiled |
| branch basis equals signal block index | `branchBasisMatchesSignalBlockIndex` | false; `[32,32]` is not `[0,0]` |
| branch-decomposition/projection theorem | `branchDecompositionObligation`, `productBridgeObligation` | false |
| finite normalized block equality | `finiteCompositionNormalizedEquality` | false; contract-only through `LCU.StandardBlockEncoding` |
| fixed product theorem | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | false |

The next lower packet should define or prove the branch-decomposition interface
from the slot-`2` projected branch product to the signal-zero block entry.  It
must keep Shukla--Vedula and LCU as contract-only dependencies and must not
promote product-to-coefficient, block projection, normalized equality, block
correctness, circuit unitarity, or final extraction.

## 2026-05-28 Branch-Decomposition Packet

The active theorem-map object remains
`Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3`.
Middle re-audited GHL2025 Theorem `1 term robin`, Eq. `ROBIN clarified`,
Fig. `1 term ROBIN`, and Definition `def:block-encoding`.  The source fixes
the boundary branch data for system `(0,0)` and sparse slot `2`, while the
block-encoding definition fixes the signal-zero block entry.  It does not
state the finite QBE matrix theorem that expands the signal-zero block entry
as a branch sum and selects the slot-`2` product.

The next Lean packet should introduce a typed interface such as
`OneTermRobinGamma3BoundaryBranchDecompositionSlot2` and
`oneTermRobinGamma3BoundaryBranchDecompositionSlot2_n3`, or a smaller
obstruction record.  The interface must consume
`oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3`, preserve the
compiled facts `[0,0]` and `[32,32]`, and keep
`branchDecompositionObligation`, `productBridgeObligation`,
`finiteCompositionNormalizedEquality`, and
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` false unless a
build-tested theorem proves them.

## 2026-05-28 Branch-Decomposition Interface

The typed interface now compiles as
`Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchDecompositionSlot2_n3`.
It consumes
`oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3` and records the
focused index data: system entry `(0,0)`, sparse slot `2`, signal-zero block
entry `[0,0]`, and branch-local product entry `[32,32]`.

| Item | Lean declaration or field | Status |
|---|---|---|
| interface structure | `OneTermRobinGamma3BoundaryBranchDecompositionSlot2` | compiled |
| focused packet | `oneTermRobinGamma3BoundaryBranchDecompositionSlot2_n3` | compiled; semantic fields false |
| transcript check | `oneTermRobinGamma3BoundaryBranchDecompositionSlot2_n3_transcript` | compiled |
| signal block and branch entry equality | `signalBlockEntryMatchesBranchEntry` | false |
| projection-summation theorem | `projectionSummationObligation.proved` | false |
| product bridge | `productBridgeObligation.proved` | false |
| finite normalized block equality | `finiteCompositionNormalizedEquality.proved` | false |
| fixed product theorem | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | false |

The remaining theorem is QBE-local finite matrix bookkeeping: expand the
signal-zero block entry as a sparse-branch projection/summation and select the
slot-`2` contribution.  This is not supplied by Shukla--Vedula and is not the
standard LCU normalized block equality.

## 2026-05-28 Branch-Entry Selection Packet

The branch-entry side now compiles as
`Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchEntrySelection_n3`, with
the conditional theorem
`oneTermRobinGamma3BoundaryBranchEntrySelectionEval_n3`.  For an environment
satisfying the corrected boundary `Ry` entry hypothesis, the theorem evaluates
the selected seven-gate entry at `[32,32]` after multiplying by
`sqrt_kappa_inv * sqrt_kappa_inv`; the result is the route's
`projectedBranchProduct`.

| Item | Lean declaration or field | Status |
|---|---|---|
| branch-entry selection packet | `oneTermRobinGamma3BoundaryBranchEntrySelection_n3` | compiled; flags false |
| conditional coefficient theorem | `oneTermRobinGamma3BoundaryBranchEntrySelectionEval_n3` | compiled under corrected `Ry` hypothesis |
| transcript check | `oneTermRobinGamma3BoundaryBranchEntrySelection_n3_transcript` | compiled |
| corrected `Ry` source entry | `correctedEntryHypothesis` | false |
| sparse-register amplitudes | `ketAmplitudeObligation`, `braAmplitudeObligation` | false |
| signal-block projection/summation | `projectionSummationObligation`, `productBridgeObligation` | false |
| fixed product theorem | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | false |

The next finite theorem must expand the signal-zero block entry `[0,0]` as the
sparse-branch projection/summation and select the slot-`2` contribution.  This
step is QBE-local finite matrix bookkeeping; it is not the Shukla--Vedula
state-preparation theorem and not the standard LCU normalized block equality.

## 2026-05-28 Branch-Contribution Family Interface

The branch-sum interface now compiles as
`Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionFamily_n3`.
It introduces `branchContribution : Fin 7 -> Coeff`, the focused slot `2`, and
the project-local fold
`oneTermRobinGamma3BoundaryBranchContributionSum`.  Lean proves only that the
slot-`2` contribution is the selected branch product already accepted by the
projection-summation obstruction.

| Item | Lean declaration or field | Status |
|---|---|---|
| branch contribution family | `oneTermRobinGamma3BoundaryBranchContributionFamily_n3` | compiled; theorem-facing fields false |
| selected slot theorem | `oneTermRobinGamma3BoundaryBranchContribution_selectedSlot_n3` | compiled |
| obstruction transcript | `oneTermRobinGamma3BoundaryBranchContributionObstruction_n3_transcript` | compiled |
| signal-zero block entry as branch sum | `oneTermRobinGamma3BoundaryBranchContribution_sum_n3` | absent |
| fixed product theorem | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | false |

The remaining local theorem is
`oneTermRobinGamma3BoundaryBranchContribution_sum_n3`, whose target is
`oneTermRobinGamma3BoundaryBranchContributionFamily_n3.projectionSummationStatement`.
No product-to-coefficient, LCU composition, block projection, normalized
equality, block correctness, circuit unitarity, or final extraction flag has
been promoted.

## 2026-05-28 Backend Projection-Summation Field Target

The backend target now compiles as
`Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendProjectionSummationFieldTarget_n3`.
It records that the existing placeholder family is only a typed convenience:
it is not a branch expansion produced by the finite projection backend for
`contract.expectedTarget.blockMatrix[0,0]`.

| Item | Lean declaration or field | Status |
|---|---|---|
| acceptance predicate | `oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_n3` | typed |
| backend target | `oneTermRobinGamma3BoundaryBackendProjectionSummationFieldTarget_n3` | compiled; theorem-facing fields false |
| transcript check | `oneTermRobinGamma3BoundaryBackendProjectionSummationFieldTarget_n3_transcript` | compiled |
| placeholder guard | `placeholderFamilyIsBackendSourced = false` and `placeholderMayCloseProjectionSummation = false` | compiled |
| backend branch family | `branchContribution : Fin 7 -> Coeff` sourced from the signal-zero block entry | absent |
| fixed product theorem | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | false |

Middle classifies the remaining ingredient as QBE-local finite projection
bookkeeping.  It is not a Shukla--Vedula theorem and not standard LCU
composition.  The next lower target is a backend-sourced branch family
satisfying `oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_n3`,
or a smaller typed obstruction explaining why `BlockExtractionTarget` cannot
yet expose that field.

## 2026-05-28 Block-Extraction Backend Gap

The narrow backend gap now compiles as
`Examples.RobinHeat.oneTermRobinGamma3BoundaryBlockExtractionBackendGap_n3`.
It ties the obstruction to the actual `BlockExtractionTarget` fields: the
signal-zero block entry and its full-unitary entry are available and equal for
the focused entry, but the backend does not expose a sparse-slot summand family
for that entry.

| Item | Lean declaration or field | Status |
|---|---|---|
| backend gap | `oneTermRobinGamma3BoundaryBlockExtractionBackendGap_n3` | compiled; theorem-facing fields false |
| transcript check | `oneTermRobinGamma3BoundaryBlockExtractionBackendGap_n3_transcript` | compiled |
| block-entry bridge | `gap.signalBlockEntry = gap.unitaryEntry` | compiled |
| available backend fields | `exposesUnitaryMatrix`, `exposesBlockMatrix`, `exposesTargetMatrix`, `exposesSignalIndex` | true |
| sparse-slot summand family | `exposesBranchContributionField` | false |
| backend branch predicate | `oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_n3` | typed |
| fixed product theorem | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | false |

The next local interface is a backend-sourced
`branchContribution : Fin 7 -> Coeff` for `contract.expectedTarget.blockMatrix[0,0]`
that satisfies `oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_n3`.
This remains QBE-local projection bookkeeping, not a Shukla--Vedula theorem and
not standard LCU composition.

## 2026-05-28 Branch-Index Map Obstruction

The focused branch-index map now compiles as
`Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3`.
For the boundary system entry `(0,0)`, it maps each sparse slot `s : Fin 7` to
`oneTermRobinGamma3PaperBasisIndex (oneTermParameters 3) s 0`.  Lean proves
that slot $2$ maps to full basis index `32`.

| Item | Lean declaration or field | Status |
|---|---|---|
| branch-index map | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3` | compiled |
| selected slot index | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3` | compiled; slot $2$ maps to `32` |
| selected summand formula | `oneTermRobinGamma3BoundaryBackendSelectedBranchSummandFormula_n3` | compiled |
| obstruction packet | `oneTermRobinGamma3BoundaryBackendBranchIndexMapObstruction_n3` | compiled; theorem-facing fields false |
| all-slot summand formula | planned theorem computing `branchContribution s` for every `s : Fin 7` | absent |
| backend predicate closure | `oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_n3 backendBranchContribution` | absent |
| fixed product theorem | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | false |

The next local theorem must compute every sparse-slot summand from the finite
backend and then prove that the signal-zero block entry equals the folded
backend branch family.  This remains QBE-local projection bookkeeping; the
Shukla--Vedula and LCU rows stay contract-only.

## 2026-05-28 All-Slot Backend Summand Formula

The all-slot backend family now compiles as
`Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3 :
Fin 7 -> Coeff`.  For each sparse slot it reads the focused seven-gate matrix
at the clean full-basis branch index and attaches the two sparse-register
projection amplitudes.

| Item | Lean declaration or field | Status |
|---|---|---|
| all-slot family | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3` | compiled |
| selected slot theorem | `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | compiled; slot $2$ selected |
| backend target over this family | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3` | compiled; semantic flags false |
| selected contribution bridge | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_selectedContribution_eq_n3` | compiled |
| branch-sum theorem | `BlockExtractionBranchContributionTarget.projectionSummationStatement oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3` | absent |
| backend predicate closure | second conjunct of `oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_n3 oneTermRobinGamma3BoundaryBackendBranchContribution_n3` | absent |
| fixed product theorem | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | false |

The next lower target is the signal-zero branch-sum theorem.  This remains
QBE-local finite projection bookkeeping; it is not supplied by Shukla--Vedula
state preparation and not by standard LCU composition.  No product equality,
LCU composition, block projection, normalized equality, block correctness,
circuit unitarity, or final extraction flag has been promoted.

## 2026-05-28 Branch-Sum Closure Packet

The current closure packet compiles the selected slot-$2$ predicate clause and
keeps the remaining branch sum as a named obligation.

| Item | Lean declaration or field | Status |
|---|---|---|
| selected predicate clause | `oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_selectedClause_n3` | compiled |
| conditional predicate closure | `oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_of_branchSum_n3` | compiled |
| branch-sum closure packet | `oneTermRobinGamma3BoundaryBackendBranchSumClosure_n3` | compiled; semantic flags false |
| transcript check | `oneTermRobinGamma3BoundaryBackendBranchSumClosure_n3_transcript` | compiled |
| signal-zero branch-sum theorem | `signalBlockEntry = oneTermRobinGamma3BoundaryBranchContributionSum oneTermRobinGamma3BoundaryBackendBranchContribution_n3` | absent |
| block-extraction projection statement | `BlockExtractionBranchContributionTarget.projectionSummationStatement oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3` | typed but unproved |
| fixed product theorem | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | false |

This remains QBE-local finite projection bookkeeping.  The next lower target is
the signal-zero branch-sum equality, or a smaller typed obstruction identifying
the missing projection-backend field.  Shukla--Vedula and LCU stay
contract-only.

## 2026-06-05 Prepared Projection Route

The source-correct gamma3 route now selects the prepared singleton clean entry
as the theorem-facing projection entry. GHL2025 Eq. `arbitrary sparcity`
provides only the contract for $H_W^{(\kappa)}$ preparing the sparse register;
Fig. `fig:1 term ROBIN` acts after that preparation; Definition
`def:block-encoding` then projects the prepared clean output.

| Item | Lean declaration or field | Status |
|---|---|---|
| prepared singleton backend bridge | `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3` | compiled under `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` |
| theorem-facing prepared target field | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3` | compiled; theorem-facing flags false |
| product-route wiring | `oneTermRobinGamma3BoundaryProductUnderContractsRoute_preparedProjectionBackendEval_n3` | compiled; product, block, normalized equality, and final-extraction flags false |
| active/prepared selected-entry equality | `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement` | absent; next finite `CircuitMatrixSemantics` target |
| H-free active fold | `oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3` | diagnostic/backlog unless recovered through the prepared route |

The Shukla--Vedula dependency stays contract-only. No LCU, block-projection,
block-correctness, circuit-unitarity, normalized-equality, or final-extraction
claim is promoted by this route.

## 2026-06-05 Direct Prepared-Clean Product Route

The selected entry is the clean-clean entry of
`oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H` at
`oneTermRobinGamma3BoundarySparseCleanIndex_n3`.  Under the contract
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`, Lean
routes this exact prepared entry to the fixed product-obligation map.

| Item | Lean declaration or field | Status |
|---|---|---|
| focused prepared-clean bridge | `oneTermRobinGamma3BoundaryFocusedProductObligation_preparedCompositeCleanEntryBackendEval_n3` | compiled; theorem-facing flags false |
| product-obligation prepared-clean wrapper | `oneTermRobinGamma3BoundaryProductToCoefficientObligation_preparedCompositeCleanEntryBackendEval_n3` | compiled; product theorem false |
| remaining finite matrix target | `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement` | absent |
| H-free active fold | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` | diagnostic/recovery only |

The next Lean target is the active/prepared selected-entry equality, or the
equivalent active/prepared circuit-field statement.  The external
Shukla--Vedula dependency remains contract-only.

## 2026-06-05 Source-Prepared Target Product Map

The reusable prepared backend field is
`(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedSingletonToBackendEvalStatement`.
It evaluates the prepared singleton clean entry selected by Definition
`def:block-encoding` against the backend branch fold under the contract
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.

| Item | Lean declaration or field | Status |
|---|---|---|
| source-prepared product-map witness | `oneTermRobinGamma3BoundaryProductToCoefficientObligation_sourcePreparedTargetBackendEval_n3` | compiled; theorem-facing flags false |
| fixed product obligation | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | false |
| remaining active/prepared target | `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement` | absent |
| preferred reduced target | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env` | absent |
| H-free active fold | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` | diagnostic/recovery only |

The next lower packet should prove or strictly reduce the uncast
active/prepared selected-entry equality.  The Shukla--Vedula row stays
contract-only, and no product-to-coefficient, LCU, block-projection,
normalized-equality, block-correctness, circuit-unitarity, or final-extraction
claim is promoted.

## 2026-06-05 Raw-Field Active Route

The raw-entry prepared-sandwich field is
`(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement`.
It is the remaining finite projection theorem comparing the active signal-zero
entry with the prepared $H_W^{(\kappa)\dagger} U H_W^{(\kappa)}$ sandwich
fold.  The latest Lean route is conditional on that field.

| Item | Lean declaration or field | Status |
|---|---|---|
| raw field feeds uncast target | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_of_rawEntryPreparedSandwichField_n3` | compiled conditional route |
| raw field feeds source-prepared field | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_rawEntryPreparedSandwichField_n3` | compiled conditional route |
| raw prepared-sandwich field | `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` | absent |
| preferred reduced target | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env` | absent unconditionally |

The next lower packet should prove or strictly reduce the raw field or the
equivalent uncast active/prepared selected-entry equality.  The H-free backend
expansion remains diagnostic recovery only, the Shukla--Vedula row remains
contract-only, and no theorem-facing flag is promoted.

## 2026-06-05 Evaluated-Fold Active Route

Definition first: the reduced local theorem is
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`.  Under the
all-slot $H_W^{(\kappa)}$ clean-column contract, this statement now feeds the
preferred uncast active/prepared target, the source-prepared active field, and
the active/prepared circuit-field record.

| Item | Lean declaration or field | Status |
|---|---|---|
| evaluated fold feeds uncast target | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_of_evaluatedBackendFold_n3` | compiled conditional route |
| evaluated fold feeds source-prepared field | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3` | compiled conditional route |
| evaluated fold feeds active/prepared circuit field | `oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_activeEval_of_evaluatedBackendFold_n3` | compiled conditional route |
| evaluated finite projection fold | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` | absent |

The next lower packet should prove or strictly reduce the evaluated finite
projection fold.  The standalone H-free backend expansion remains
diagnostic/recovery only through the prepared route, and no product, LCU, block,
normalized-equality, unitarity, or final-extraction flag is promoted.

## 2026-06-09 Middle Lower-Packet Freeze After Prepared-Entry DAG

Definition first: `PreparedEntry(H, env)` means
`(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry`.
It is the theorem-facing clean entry of
`H_W^(kappa)^dagger * U_gamma3 * H_W^(kappa)`.  It is not the active
seven-gate `[0,0]` entry exposed by the current active field.

Lower 1 has already supplied the proof map from GHL2025 `main.tex:948-955`,
`1098-1164`, and `2027-2035` to `PreparedEntry(H, env)` in
`proof-attempts/QBE-AUTO-002/prepared-signal-entry-source-dag-20260609-lower1.md`.
The displayed slot `2` branch is mapped to full basis `[32,32]`; the all-slot
prepared entry evaluates to the backend fold under the external `H_W` clean
column contract by
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`.

| Item | Lean declaration or target | Status |
|---|---|---|
| lower-1 source proof map | `proof-attempts/QBE-AUTO-002/prepared-signal-entry-source-dag-20260609-lower1.md` | accepted proof map; no Lean edit |
| prepared entry backend bridge | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3 H env hUniform` | compiled conditional |
| active-field mismatch guard | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3`; `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesUncastSevenGate_n3` | compiled; active side remains H-free `[0,0]` |
| next target-shape leaf | theorem or record consuming `PreparedEntry(H, env)` and the compiled backend bridge | assign lower 2 |
| alternate finite-composition leaf | `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` | open |
| retired routes | `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3`; raw `Coeff` equality route | diagnostic/backlog only |

The next Lean worker should edit only `QuantumBlockEncoding/RobinMatrix.lean`
and compile one of the two active leaves above.  The worker must not use the
slot-`0` diagnostic as the displayed slot-`2` proof and must not promote
oracle, `H_W`, `R_y`, LCU, block-projection, block-correctness, unitarity,
normalized-equality, or final-extraction flags.

## 2026-06-09 Fig. 4 Transcript Correction And Active Frontier

The theorem-facing transcript now has a compiled Lean label list:
`GHL2025.oneTermRobinTheoremFacingFig4Circuit`.  It is the object to compare
with GHL2025 Theorem `theorem: 1 term robin`, Eq. `ROBIN clarified`, Eq.
`arbitrary sparcity`, Fig. `fig:1 term ROBIN`, and Definition
`def:block-encoding`.

| Source-facing slot | Lean name or label | Status |
|---|---|---|
| $H_W^{(\kappa)}$ preparation | `Gate.oracleCall "H_W^(kappa)"` in `oneTermRobinTheoremFacingFig4Circuit` | visible transcript slot; state-preparation proof remains contract-only |
| $U_{\mathrm{indic}}$ | `GHL2025.oneTermRobinGate_U_indic` | active matrix proved as a permutation |
| $U_{\mathrm{indic}}^\dagger$ cleanup | `GHL2025.oneTermRobinGate_U_indic_dagger`, `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | compiled transcript bridge; same matrix as `U_indic` by self-inverse image |
| pre-SWAP $O_{D^T}^{BS}$ | `Gate.oracleCall "O_DT^BS"` | theorem-facing label distinct from post-SWAP dagger; active backend still uses existing seven-gate skeleton |
| post-SWAP $(O_D^{BS})^\dagger$ | `Gate.oracleCall "(O_D^BS)^dagger"` | visible transcript slot; cleanup and unitarity remain unproved |
| $(H_W^{(\kappa)})^\dagger$ projection side | `Gate.oracleCall "(H_W^(kappa))^dagger"` | visible transcript slot; state-preparation proof remains contract-only |

The active finite backend is still guarded by
`GHL2025.oneTermRobinActiveBackendCircuit_gateList`, the seven-gate product
used by `evalGateMatrices`.  That backend must not be called the full Fig.
`1 term ROBIN` transcript.

The next lower target is unchanged after the transcript correction:
`oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`,
or a strictly smaller `Coeff.evalWith` selected-entry bridge feeding
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`.
The raw symbolic `Coeff` constructor-equality route is diagnostic/backlog.

No theorem-facing flag is promoted in this update.  Product-to-coefficient,
LCU, block projection, normalized equality, block correctness, circuit
unitarity, and final extraction remain false.

## 2026-06-09 Prefix Diagnostics And Branch-Correct Frontier

Definition first: the accepted column-`0` prefix facts are finite
`Coeff.evalWith` facts for the active seven-gate backend entry `[0,0]`.  They
are not the displayed $\gamma_3$ slot-`2` branch in Eq. `ROBIN clarified`.

| Item | Lean declaration or target | Status |
|---|---|---|
| column-`0` two-gate prefix entry | `oneTermRobinGamma3BoundaryDUPrefixCol0EntryEval_n3` | compiled |
| column-`0` `Ry_boundary` prefix entries | `oneTermRobinGamma3BoundaryRDUPrefixRow0Col0_eval_n3`, `oneTermRobinGamma3BoundaryRDUPrefixRow1Col0_eval_n3` | compiled slot-`0` diagnostics |
| column-`0` four-gate prefix entries | `oneTermRobinGamma3BoundaryPrefixRow96Col0_eval_n3`, `oneTermRobinGamma3BoundaryPrefixRow97Col0_eval_n3` | compiled slot-`0` diagnostics |
| displayed $\gamma_3$ slot-`2` path map | next proof-DAG packet | active natural-language leaf |
| raw-entry prepared-sandwich bridge | `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` | active Lean leaf; absent |

The next Lean worker should prove a branch-correct raw-entry/prepared-sandwich
bridge, or a smaller `Coeff.evalWith` lemma that directly feeds it.  The
column-`0` slot-`0` facts may be reused for active `[0,0]` diagnostics, but
they must not be used as a proof of the source displayed slot-`2` coefficient.
The raw symbolic `Coeff` constructor-equality and `Matrix.mul_assoc` routes
remain diagnostic/backlog.

## 2026-06-09 Source-Prepared Field Selection

Definition first: the theorem-facing prepared signal-entry target is
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env`.  Its
prepared entry is the clean entry of the local
`H_W^(kappa)^dagger * U_gamma3_boundary * H_W^(kappa)` singleton semantics.
The smaller missing field is
`(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement`,
which would connect the active signal-zero entry to the prepared sandwich
fold.

| Item | Lean declaration or target | Status |
|---|---|---|
| selected prepared projection field | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env` | compiled record; selected for the next frontier |
| conditional backend bridge | `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 H env hUniform` | compiled under the external $H_W^{(\kappa)}$ clean-column contract |
| raw-entry prepared-sandwich field | `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` | open active Lean leaf |
| column-`0` seven-gate expansion | `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` | proved diagnostic; retired from active lower work |

The next lower packet should not prove the seven-gate slot-`0` entry equal to
the all-slot prepared sandwich.  It should either feed the raw-entry
prepared-sandwich field through the selected source-prepared target, or record
a typed mismatch if the current active LHS is not theorem-facing prepared
semantics.  No oracle, $H_W$, LCU, block, normalized-equality, unitarity, or
final-extraction flag is promoted.

## 2026-06-09 Middle Target-Repair Frontier

The latest compiled mismatch witness is
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3`.
It records that the selected source-prepared active field still has the
seven-gate `[0,0]` entry on the left, while the active gate list omits both
`H_W^(kappa)` and `(H_W^(kappa))^dagger`.

The next theorem-facing target must therefore expose the prepared clean entry
itself:

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry
```

or an equivalent matrix entry of
`oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H`.  The
compiled bridge
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`
already evaluates that prepared entry to the backend fold under the external
$H_W^{(\kappa)}$ clean-column contract.

| Item | Lean declaration or target | Status |
|---|---|---|
| active field mismatch | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3` | compiled mismatch witness |
| prepared entry backend bridge | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3 H env hUniform` | compiled conditional |
| repaired prepared signal-entry LHS | new target-shape theorem or record consuming `preparedProjectionEntry` | next Lean leaf |
| finite active-to-prepared composition | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` or raw-entry prepared-sandwich field | still open |
| column-`0` seven-gate expansion | `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` | diagnostic only; retired |

This is a QBE-local finite projection/composition issue, not a new cited
subroutine.  No product, LCU, block-projection, block-correctness,
normalized-equality, unitarity, or final-extraction flag is promoted.

## 2026-06-09 Middle Frontier Sync After Prepared-Entry LHS Repair

Definition first: `PreparedEntry(H, env)` is
`(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry`.
It is the clean entry of the prepared singleton semantics for
`H_W^(kappa)^dagger * U_gamma3_boundary * H_W^(kappa)`.

The compiled theorem
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_preparedProjectionEntryBackendEval_n3`
now exposes `PreparedEntry(H, env)` as the left side of the backend evaluator
and consumes
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3 H env hUniform`.
This retires the prepared-entry target-shape leaf.

| Item | Lean declaration or target | Status |
|---|---|---|
| prepared-entry LHS repair | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_preparedProjectionEntryBackendEval_n3 H env hUniform` | compiled; theorem-facing flags false |
| active/prepared composition | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env` | open active Lean leaf |
| accepted smaller field | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | open |
| accepted raw prepared-sandwich field | `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` | open |
| next middle/lower packet | `proof-attempts/QBE-AUTO-002/finite-active-prepared-composition-middle-packet-20260609-154329.md` | active packet |
| retired diagnostics | `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3`; raw `Coeff` equality route | diagnostic/backlog only |

Source classification: the remaining blocker is QBE-local finite
`CircuitMatrixSemantics` composition.  It is not a new Shukla--Vedula,
Gilyen/LCU, sparse-oracle, function-oracle, or classical-theorem dependency.
No oracle, $H_W$, $R_y$, LCU, block-projection, block-correctness, unitarity,
normalized-equality, product-to-coefficient, or final-extraction flag is
promoted by this sync.

## 2026-06-09 Middle Frontier Sync To Uncast Eval Entry

Definition first: `ActiveEvalEntry(env)` is the evaluated uncast entry

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

and `BackendFold(env)` is

```lean
Coeff.evalWith env
  (blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

The next preferred Lean target is
`oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3 env`,
which states `ActiveEvalEntry(env) = BackendFold(env)`.  The compiled bridge
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env`
turns this leaf into the named evaluated backend-fold statement.

| Item | Lean declaration or target | Status |
|---|---|---|
| preferred active leaf | `oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3 env` | proposed; open |
| named evaluated fold | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` | active theorem; open |
| raw prepared-sandwich route bridge | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_rawEntryPreparedSandwichField_n3 H env hUniform hRaw` | compiled conditional; raw field still open |
| backend expansion stronger leaf | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` | allowed stronger leaf; open |
| raw prepared-sandwich stronger leaf | `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` | allowed stronger leaf; open |
| retired wrapper | `oneTermRobinGamma3BoundaryFiniteActivePreparedComposition_reducesToBackendFold_n3 H env hUniform` | compiled guard; not a smaller target |
| retired diagnostics | `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3`; raw `Coeff` constructor equality route | diagnostic/backlog only |

Source classification: this is a QBE-local `evalWith` finite matrix-semantics
obligation tied to `main.tex:2027-2035` after the Fig. 4 transcript and
gamma3 slot-`2` branch map are in place.  It does not prove ODBS, ODTS, `O_f`,
`H_W`, `R_y`, LCU, block projection, normalized equality, circuit unitarity,
block correctness, or final extraction.

## 2026-06-09 Middle Support-Partition Packet Sync

The compiled bridge
`oneTermRobinGamma3BoundaryEvaluatedBackendFold_of_backendExpansion_n3 env hexpansion`
has one role: if a future proof supplies
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`,
then the named evaluated backend fold follows.  The bridge does not prove the
backend expansion, the raw prepared-sandwich field, or the preferred uncast
`evalWith` entry equality.

| Item | Lean declaration or target | Status |
|---|---|---|
| conditional backend route | `oneTermRobinGamma3BoundaryEvaluatedBackendFold_of_backendExpansion_n3 env hexpansion` | compiled; not closure |
| next support subgoal | a support-partition lemma inside `QuantumBlockEncoding/RobinMatrix.lean` feeding `oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3 env` | next implementation subgoal |
| preferred active leaf | `oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3 env` | proposed; open |
| stronger backend leaf | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` | open |
| stronger prepared-sandwich leaf | `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` | open |
| middle packet | `proof-attempts/QBE-AUTO-002/uncast-eval-entry-support-partition-middle-packet-20260609-170218.md` | active lower packet |

This remains a QBE-local finite matrix/projection obligation tied to
`main.tex:2027-2035`.  It uses the existing source transcript and branch map
from `main.tex:1098-1164`; it does not promote any external oracle, `H_W`,
`R_y`, LCU, block-projection, product-to-coefficient, normalized-equality,
circuit-unitarity, block-correctness, or final-extraction flag.

## 2026-06-09 Middle Source-Prepared Active Frontier Sync

Definition first: `SourcePreparedActive(H, env)` is

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
```

and its uncast selected-entry form is

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
```

The H-free uncast backend equality is now diagnostic unless it is recovered
through the prepared route.  The compiled obstruction
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesExpandedSlotZeroFold_n3 H env`
exposes the active `[0,0]` entry against a weighted backend fold with slot `0`
carrying `projectionAmplitudeFactor` and slots `1` through `6` still visible.
This does not match the source-prepared Fig. `fig:1 term ROBIN` route by
itself.

| Item | Lean declaration or target | Status |
|---|---|---|
| source-prepared backend bridge | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3 H env hUniform` | compiled conditional under the external $H_W^{(\kappa)}$ clean-column contract |
| H-free expanded-fold obstruction | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesExpandedSlotZeroFold_n3 H env` | compiled diagnostic; not closure |
| preferred source-prepared leaf | `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env` | open active leaf |
| preferred uncast leaf | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env` | open smaller leaf |
| accepted generic entry leaf | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | open smaller leaf |
| accepted raw prepared-sandwich leaf | `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` | open stronger leaf |
| equivalent backend leaf | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` | open recovery leaf |
| retired source-closure leaf | proposed `oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3 env` | diagnostic/blocked unless all weighted slots are matched or eliminated |

The next packet is
`proof-attempts/QBE-AUTO-002/source-prepared-active-composition-middle-packet-20260609-1732.md`.
No oracle, $H_W$, $R_y$, LCU, block-projection, normalized-equality,
product-to-coefficient, circuit-unitarity, block-correctness, final-extraction,
ODBS, ODTS, or `O_f` flag is promoted.

## 2026-06-09 Middle Source-Prepared Branch-Sum Frontier Sync

Definition first: `SignalBlockEntry` is
`oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.signalBlockEntry`,
and `BranchSum` is
`oneTermRobinGamma3BoundaryBranchContributionSum
oneTermRobinGamma3BoundaryBackendBranchContribution_n3`.

The compiled theorem
`oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3`
identifies the backend-expansion statement with
`SignalBlockEntry = BranchSum`. The proposed leaf
`oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_n3` is still
open.

| Item | Lean declaration or target | Status |
|---|---|---|
| Fig. 4 transcript guard | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | compiled |
| prepared clean-entry alias | `oneTermRobinGamma3BoundarySourcePreparedCleanEntryEval_eq_backendFold_n3 H env hUniform` | compiled conditional; stale as lower target |
| branch-sum leaf | proposed `oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_n3` | next active leaf |
| backend-expansion equivalence | `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3` | compiled bridge; not closure |
| backend-expansion statement | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` | open equivalent recovery leaf |
| retired H-free and raw routes | `oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3 env`; raw `Coeff` equalities | diagnostic/backlog |

The next lower packet is
`proof-attempts/QBE-AUTO-002/source-prepared-branch-sum-middle-packet-20260609-1842.md`.
The one-term theorem remains open. No oracle, $H_W$, $R_y$, LCU,
block-projection, normalized-equality, product-to-coefficient,
circuit-unitarity, block-correctness, final-extraction, ODBS, ODTS, or `O_f`
flag is promoted.

## 2026-06-09 Middle Source-Prepared Backend Frontier Sync

Definition first: `PreparedCleanBackend(H, env)` is the prepared clean-entry
evaluation theorem
`oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 H env hUniform`,
where `hUniform` is the external $H_W^{(\kappa)}$ clean-column contract.

The latest compiled bridge
`oneTermRobinGamma3BoundaryBackendExpansionStatement_of_activePreparedEntryTarget_n3`
states that a future proof of
`(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`
will imply
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`.
It does not prove either statement.

| Item | Lean declaration or target | Status |
|---|---|---|
| Fig. 4 transcript guard | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | compiled |
| prepared clean-entry backend bridge | `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 H env hUniform` | compiled conditional |
| theorem-facing prepared target bridge | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3 H env hUniform` | compiled conditional |
| active mathematical leaf | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | open |
| conditional bridge to backend expansion | `oneTermRobinGamma3BoundaryBackendExpansionStatement_of_activePreparedEntryTarget_n3 H hUniform hEntry` | compiled; not closure |
| optional alias leaf | proposed `oneTermRobinGamma3BoundarySourcePreparedCleanEntryEval_eq_backendFold_n3` | safe naming leaf |
| retired H-free route | proposed `oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3 env` | diagnostic unless every weighted slot is matched |
| raw `Coeff` route | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | backlog |

The next lower packet is
`proof-attempts/QBE-AUTO-002/source-prepared-clean-entry-middle-packet-20260609-1822.md`.
No oracle, $H_W$, $R_y$, LCU, block-projection, normalized-equality,
product-to-coefficient, circuit-unitarity, block-correctness, final-extraction,
ODBS, ODTS, or `O_f` flag is promoted.

## 2026-06-09 Middle Backend-Expansion/Raw-Sandwich Packet Sync

Definition first: the active backend-expansion leaf is
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`.
It is the finite branch/projection theorem that expands the clean block entry
into the seven-slot backend branch fold. The raw prepared-sandwich field
`(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement`
and the generic prepared-entry target
`(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`
are allowed route-equivalent leaves under the existing `hUniform` contract.

| Item | Lean declaration or target | Status |
|---|---|---|
| active mathematical leaf | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` | open |
| equivalent raw prepared-sandwich leaf | `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` | open |
| equivalent generic prepared-entry leaf | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | open |
| route equivalence | `oneTermRobinGamma3BoundaryActivePreparedCompositeEval_iff_evaluatedBackendFold_n3 H env hUniform` | compiled conditional; neither side proved |
| retired H-free eval leaf | proposed `oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3 env` | diagnostic unless recovered through prepared/backend expansion |
| new middle packet | `proof-attempts/QBE-AUTO-002/backend-expansion-raw-sandwich-middle-packet-20260609-180111.md` | active lower packet |

Source audit: `main.tex:948-955` supplies the $H_W^{(\kappa)}$ clean-column
contract, `main.tex:1111-1119` supplies the gamma3 slot-`2` branch,
`main.tex:1122-1164` supplies the theorem-facing Fig. 4 transcript, and
`main.tex:2027-2035` supplies the clean block projection. The missing theorem
is QBE-local finite matrix/projection work. It is not a new external oracle,
LCU, `R_y`, or block-projection dependency.

No oracle, $H_W$, $R_y$, LCU, block-projection, normalized-equality,
product-to-coefficient, circuit-unitarity, block-correctness, final-extraction,
ODBS, ODTS, or `O_f` flag is promoted.

## 2026-06-09 Middle Branch-Sum Frontier Closeout

Latest frontier: the source-prepared clean-entry alias is compiled and stale as
a lower target. The next Lean leaf is the local branch-sum equality

```lean
oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.signalBlockEntry =
  oneTermRobinGamma3BoundaryBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

or the equivalent backend-expansion statement through
`oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3`.
The assigned middle packet is
`proof-attempts/QBE-AUTO-002/source-prepared-branch-sum-middle-packet-20260609-1842.md`.
The one-term theorem remains open, and no semantic flag is promoted.

## 2026-06-11 Post-Feeder Active/Prepared Frontier

The compiled Lean feeder
`oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_preparedSparseCleanEntry_n3`
rewrites the prepared-sandwich evaluated target to the clean-clean entry of
`oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H`. It is a route
lemma only.

The current open local leaf is the active/prepared composition field: after
`Coeff.evalWith`, the active seven-gate `[0,0]` entry must equal that prepared
sparse clean-clean entry. Equivalent Lean-facing targets are
`oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3 H env`,
`oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`,
or `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`.

All theorem-facing oracle, sparse-preparation, normalizer, LCU, block
projection, block-correctness, and final-extraction flags remain unproved. The
first-case-study one-term theorem is still open.
