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
| O_D^BS source-gate freeze guards | `oneTermRobinBlockEncodingProofRoute_sourceGateFreeze`; focused tests at source columns `8`, `0`, and `48` | active paper-image wiring and false flags pinned; row-dependent contract drift is rejected-model memory; no semantic flag promoted |
| O_D^BS source-decision freeze guard | `oneTermRobinBlockEncodingProofRoute_sourceDecisionOnlyFreeze_n3` | transcript identity, empty image slot, rejected row-dependent collision, active/legacy separation, signal-index-zero target, and false theorem flags synchronized for the $n=3,\kappa=7$ audit |
| O_D^BS wrapper-slot freeze guard | `oneTermRobinBlockEncodingProofRoute_sourceDecisionWrapperSlotsBlocked_n3` | direct and full clean-domain wrapper image slots for boundary column `48` remain `none`; image-specified, block-correctness, and LCU flags remain false |
| Seven-gate flag freeze guard | `oneTermRobinGateMatrixPlaceholders_unitaryFlags`, `oneTermRobinBlockEncodingProofRoute_gateUnitaryFlags` | active gate flags remain `[true, false, false, false, false, true, false]`; only $U_{\mathrm{indic}}$ and SWAP are locally proved, and theorem-level circuit-unitary/block flags remain false |
| Seven-gate order-and-flag freeze guard | `oneTermRobinGateMatrixPlaceholders_gateList`, `oneTermRobinBlockEncodingProofRoute_gateListAndFlags` | active matrix labels match Fig. `fig:1 term ROBIN` order while preserving the same flag vector and disabled O_D^BS source decision |
| One-term theorem route | `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute`, `oneTermRobinBlockEncodingProofRoute_flags_false`, `oneTermRobinBlockEncodingProofRoute_odbsSourceBlockers` | theorem-level wiring compiled; semantic blockers remain false |
| Theorem layout/projection audit | `defaultOneTermRobinTheoremData_signalQubits_eq_layout`, `defaultOneTermRobinTheoremData_pureAncillas_eq_resource`, `effectiveRobinSignalQubits_eq_layout_signal_plus_visibleWorkspace`, `oneTermRobinBlockEncodingProofRoute_layoutProjectionAudit` | theorem signal and $2n$ pure-ancilla counts are separated from the full non-system projection dimension; cleanup and block flags remain false |
| Block-projection claim guard | `oneTermRobinBlockEncodingProofRoute_claimBlockCorrectFalse`, `oneTermRobinBlockEncodingProofRoute_signalZeroBlockIndices` | circuit-claim block correctness, target projection, and target block equation remain false; signal-zero row/column offsets are pinned |

## Still Open

The following are still obligations, not proved theorems:

- O_D^BS injectivity, inverse-on-range, dagger cleanup, and gate unitarity. The current active source domain is `bandedSparseAccessPaperGlobalSlotSource`; `QBE.ODBS.UnusedZeroBranchExtension` is retained only as rejected-model memory for the old row-dependent helper.
- O_DT^S Eq. (20) coefficient-normalizer relation and rotation unitarity.
- Ry boundary arccos, half-angle, normalizer, and rotation unitarity.
- O_f nonzero $N_f$, division semantics, normalizer bound, orthogonal completion,
  theorem-level amplitude correctness, and unitary extension.
- Final block extraction of the full circuit with normalizer $N_D N_f \kappa$;
  the circuit-claim and target-level block flags are both explicitly false.

The latest O_D^BS guards are regression checks, not semantic closure.  Column
`8` separates the active Lemma 1 paper-image matrix from the legacy helper,
while columns `0` and `48` now witness the rejected row-dependent collision and
the corrected active global-slot separation.  The guard
`oneTermRobinBlockEncodingProofRoute_sourceDecisionOnlyFreeze_n3` packages
these facts with the empty unused-branch image slot and the false theorem flags.
The newer guard
`oneTermRobinBlockEncodingProofRoute_sourceDecisionWrapperSlotsBlocked_n3`
adds the wrapper-level check for the same column `48`: both the direct
image-rule contract and the full clean-domain wrapper still have
`proposedImageIndex = none`.
The cited-results active row is `QBE.ODBS.GlobalSparseSlotAddress`; the older
`QBE.ODBS.UnusedZeroBranchExtension` row is historical rejected-model memory.
The guard `oneTermRobinBlockEncodingProofRoute_gateListAndFlags` additionally
pins the active matrix order to `oneTermRobinCircuit`, so future source-contract
packets cannot silently reorder the seven gates while preserving the same
false-flag vector.
