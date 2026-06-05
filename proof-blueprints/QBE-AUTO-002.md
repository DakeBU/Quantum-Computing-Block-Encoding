# Proof Blueprint: QBE-AUTO-002

Task id: `QBE-AUTO-002`
Title: Concrete Circuit Matrix Semantics Backend
Mode: `faithfulPaper`
Updated: `2026-06-06 01:40:47`
Blueprint stage: `Stage 2 DAG proof discharge, with faithful transcript checks still active`

This is QBE's compact system-of-record snapshot for long-horizon Lean proof
automation.  It follows a similar control pattern to LeanMarathon's evolving
blueprint, but QBE keeps the human-facing proof map split across Lean,
Markdown, LaTeX, proof obligations, and cited-results memory because
block-encoding papers require source notation, register conventions, and
oracle contracts to stay explicit.

## Current Directive

```text
## Immediate 6h Focus: Source-Correct Prepared Projection Route

This directive supersedes the previous "prove the H-free active entry fold"
focus.  After re-reading the local source proof around Theorem
`theorem: 1 term robin`, Eq. `ROBIN clarified`, Eq. `arbitrary sparcity`, and
Fig. `fig:1 term ROBIN`, the correct faithful-paper route is:

1. `H_W^(kappa)` prepares the sparse register as in Eq. `arbitrary sparcity`.
2. The Fig. `1 term ROBIN` seven-gate product acts on the prepared sparse
   register and produces the `gamma_3` coefficient in Eq. `ROBIN clarified`.
3. The block-encoding projection from Definition `def:block-encoding` selects
   the prepared clean output, not the H-free seven-gate active entry by itself.

Therefore, the next batch must stop trying to prove the H-free active equality

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3)
=
Coeff.evalWith env
  (blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

as the primary theorem.  That equality is useful only as a diagnostic if the
active seven-gate matrix has already been source-prepared, which the current
Lean guard `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` shows is
not the case.

Primary target for this batch:

- Make the theorem-facing focused block/projection route use the prepared
  singleton clean entry
  `(oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3`
  or the equivalent prepared sparse-matrix clean entry.
- Use the already compiled bridge
  `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`
  under the explicit contract
  `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` to
  prove the source-correct evaluated backend fold.
- If possible, route the focused `gamma_3` product-to-coefficient statement
  through this prepared projection target.  If not possible, add only the
  smallest missing route lemma and keep all theorem-facing flags false.

Source/background classification for agents:

- GHL2025 own contribution: the Robin boundary seven-gate construction,
  `gamma_1`/`gamma_2`/`gamma_3` coefficient bookkeeping, normalizer
  `N_D * N_f * kappa`, ancilla ledger, and resource count.
- External contract: Shukla--Vedula uniform superposition gives only the
  clean-column amplitude shape and `O(log kappa)` cost for `H_W^(kappa)`.
  Do not recursively formalize it in this batch.
- External/standard contract: LCU and block-composition are downstream
  contracts.  Do not use them to prove the local prepared projection entry.
- QBE-local work: finite matrix/projection bookkeeping that connects the
  source-prepared singleton clean entry to the branch fold and then to the
  focused product route.

Upper agent:

- Start from the prepared projection route above, not from the H-free active
  equality.
- Treat `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` as a guard
  that prevents false closure of the active route.
- Assign lower work to change the theorem-facing route, not to add another
  obstruction record.

Middle agent:

- Update the conversion window so the active H-free equality is marked
  "diagnostic/backlog" and the prepared singleton clean-entry route is marked
  "source-correct active route".
- Keep Markdown/LaTeX notes minimal: definitions first, theorem statement,
  source-proof map, and remaining obligations.
- Do not polish the project paper during this Lean-heavy batch.

Lower agent:

- Prefer direct theorem declarations over new records.
- Work in `QuantumBlockEncoding/RobinMatrix.lean` and focused
  `Tests/Basic.lean`; touch `CircuitSemantics.lean` only for a genuinely
  reusable finite-matrix helper.
- First try to prove a theorem of the form:

```lean
theorem ... (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    Coeff.evalWith env
      ((oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix
        oneTermRobinGamma3BoundarySparseCleanIndex_n3
        oneTermRobinGamma3BoundarySparseCleanIndex_n3) =
    Coeff.evalWith env
      (blockExtractionBranchContributionSum
        oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

  if the exact theorem is already present, route it into the focused
  product-to-coefficient proof map instead of duplicating it.
- Keep `productToCoefficientProved`, `lcuCorrectProved`,
  `blockProjectionProved`, `blockCorrectProved`, `normalizedBlockEqualityProved`,
  `circuitUnitarityProved`, and `finalExtractionProved` false unless Lean
  directly proves the corresponding theorem.

Reviewer:

- Reject a cycle that again spends its main effort on proving the H-free active
  equality without explaining why this matches Eq. `arbitrary sparcity`.
- Accept if the theorem-facing route is corrected to the prepared singleton
  clean entry and the prepared backend fold is build-tested under the explicit
  `H_W^(kappa)` clean-column contract.
```

## Dynamic Leaf Queue

These are the current local proof or repair candidates.  Lower agents should
work on one item at a time; if an item is stale, upper/middle must retire it
before spending more proof-search tokens.

| Leaf | Status |
|---|---|
| Latest handoff indicates at least one assigned lower target was already compiled; upper/middle should retire stale directives before more proof search. | stale-check |
| 1. `H_W^(kappa)` prepares the sparse register as in Eq. `arbitrary sparcity`. | candidate |
| 2. The Fig. `1 term ROBIN` seven-gate product acts on the prepared sparse register and produces the `gamma_3` coefficient in Eq. `ROBIN clarified`. | candidate |
| 3. The block-encoding projection from Definition `def:block-encoding` selects the prepared clean output, not the H-free seven-gate active entry by itself. | candidate |
| - Make the theorem-facing focused block/projection route use the prepared singleton clean entry `(oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix oneTermRobinGamma3BoundarySparseCleanIndex_n3 oneTermRobinGamma3BoundarySparseCleanInd... | candidate |
| - Use the already compiled bridge `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3` under the explicit contract `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` to prove the source-correct evaluated backend fold. | candidate |
| - If possible, route the focused `gamma_3` product-to-coefficient statement through this prepared projection target. If not possible, add only the smallest missing route lemma and keep all theorem-facing flags false. | candidate |
| - GHL2025 own contribution: the Robin boundary seven-gate construction, `gamma_1`/`gamma_2`/`gamma_3` coefficient bookkeeping, normalizer `N_D * N_f * kappa`, ancilla ledger, and resource count. | candidate |
| - External contract: Shukla--Vedula uniform superposition gives only the clean-column amplitude shape and `O(log kappa)` cost for `H_W^(kappa)`. Do not recursively formalize it in this batch. | candidate |
| - External/standard contract: LCU and block-composition are downstream contracts. Do not use them to prove the local prepared projection entry. | candidate |
| - QBE-local work: finite matrix/projection bookkeeping that connects the source-prepared singleton clean entry to the branch fold and then to the focused product route. | candidate |
| - Start from the prepared projection route above, not from the H-free active equality. | candidate |

## Open Obligation Signals

```text
# Proof Obligations: QBE-AUTO-002 — Circuit Matrix Semantics Backend
This ledger tracks the unproved semantic claims introduced by the circuit
the remaining five gate unitarity claims remain explicit proof obligations.
| O_DT^S | `GHL2025.oneTermRobinGate_O_DT_S` | Lemma 3, Eq. (20), arXiv:2506.20478 | active controlled-rotation skeleton; coefficient-normalizer relation and unitarity unproved |
| Ry_boundary | `GHL2025.oneTermRobinGate_Ry_boundary` | Fig. 1-term Robin and Eq. angles for Ry, arXiv:2506.20478 | active symbolic controlled rotation matrix; angle-normalizer contract and unitarity unproved |
| O_D^BS | `GHL2025.oneTermRobinGate_O_D_BS` | Lemma 1, arXiv:2506.20478 | active global sparse-slot paper-image matrix skeleton; `bandedSparseAccessPaperGlobalSlotSource` now records the faithful clean source predicate as padded clean input plus sparse index $s<\kappa$; finite-image, entry-safety, finite-range cleanup wrapper, global-source image injectivity, post-SWAP unique preimage, and record-level inverse bridge proved under explicit hypotheses; `oneTermRobinGate_O_D_BS_globalSparseBoundaryNoCollision_n3` proves the corrected active image separates the old $n=3$ boundary columns, while `oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3` is retained as a rejected row-dependent-model regression; forward correctness, semantic cleanup, obligation-record flag promotion, and unitarity unproved |
| O_f | `GHL2025.oneTermRobinGate_O_f` | Theorem `Amplitude-oracle for piece-wise polynomial function`, Eq. `coordinate oracle`, and Fig. 1-term Robin, arXiv:2506.20478 | active paper-image matrix skeleton with clean $m_f$ branch wired; orthogonal completion, amplitude relation, normalizer bound, and unitarity unproved |
| (O_D^BS)^dagger | `GHL2025.oneTermRobinGate_O_D_BS_dagger` | Fig. 1-term Robin caption, arXiv:2506.20478 | active transpose-style paper-image matrix; conditional entry and register-cleanup witness available for the global-source candidate, and `bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge` identifies that candidate among active global-source preimages; semantic cleanup and unitarity unproved |
Therefore the active obligation is not to invent an unused-branch image for a
| Obligation | Declaration | Status |
| Obligation | Declaration | Status |
| Block projection extracts correct submatrix | `oneTermRobinBlockExtractionTarget.blockProjection` | unproved |
| Extracted block = targetMatrix / normalizer | `oneTermRobinBlockExtractionTarget.blockCorrect` | unproved |
| Obligation | Declaration | Status |
| Block correctness for Robin | `blockCorrect` field | unproved |
These obligations block completion of `QBE-AUTO-001`:
- Unitarity is proved for `U_indic` and SWAP; it remains unproved for the other five gate matrices.
- The active `O_D^BS` paper-image matrix has explicit clean-input, global-slot address-range, no-spill, finite-range, global-source injectivity, post-SWAP unique-preimage, and record-level inverse bridge checks.  Lemma 1 covers columns with padded register $|0\rangle^{n-l}$ and output address $|r_{si}\rangle^n$; the executable address/no-spill/range and finite preimage checks are proved under explicit hypotheses.  The former boundary collision is now a rejected row-dependent-model regression, and `oneTermRobinGate_O_D_BS_globalSparseBoundaryNoCollision_n3` checks that the corrected active image separates the old $n=3$ boundary columns.  Semantic cleanup, obligation-record flag promotion, and full unitary extension remain open.
- `O_{D^T}^S` now uses the controlled-rotation skeleton; the diagonal helper remains available only as data.  The next source-contract gap is the coefficient-normalizer relation for the symbolic rotation entries from Lemma 3, Eq. (20).
- `R_y^{boundary}` now has a typed angle-normalizer contract.  Its remaining gap is proving $\theta_j^s=\arccos(D_j^{(s)}/N_D)$, the half-angle identities, and the two-by-two unitarity relation under the paper's $N_D$ bound.
- The shared derivative normalizer contract `GHL2025.derivativeNormalizerNDContract` now records the common $D_j^{(s)}/N_D$ source for `O_{D^T}^S` and `R_y^{boundary}`.  Its nonzero, division, coefficient-bound, absolute-square, square-root, arccos, and two-by-two-unitary fields remain `proved := false`.
- The O_f cited-theorem dependency is now typed as `FunctionOracleExternalAmplitudeSourceContract` and `functionOracleExternalAmplitudeSourceContract`.  It records the GHL2025 coordinate-oracle theorem, the cited arXiv:2411.01131 source, the $N_f$ symbol, and false source-side obligations; it does not close any analytic O_f flag.
- The O_f $N_f$ amplitude route is now typed as `FunctionOracleAmplitudeProofRoute` and `functionOracleAmplitudeProofRoute`.  It ties `robinFunctionValue`, `functionOracleNormalizedValue`, `functionOraclePaperImage`, the external source transcript, and the theorem normalizer symbol together, but nonzero $N_f$, division semantics, the $N_f$ bound, orthogonal completion, unitary completion, and theorem-level amplitude correctness remain false.
Middle re-audited the O_D^BS source contract against GHL2025 Lemma
```

## Lean Declaration Index

Recent task-relevant declarations:

| Kind | Lean name | File |
|---|---|---|
| def | `oneTermRobinGamma3BoundaryBackendExpansionBridge_n3` | `QuantumBlockEncoding/RobinMatrix.lean:15497` |
| theorem | `oneTermRobinGamma3BoundaryBackendExpansionBridge_n3_transcript` | `QuantumBlockEncoding/RobinMatrix.lean:15550` |
| structure | `OneTermRobinGamma3BoundaryBackendUnitaryEntryFoldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:15672` |
| def | `oneTermRobinGamma3BoundaryBackendUnitaryEntryFoldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:15712` |
| structure | `OneTermRobinGamma3BoundaryBackendUnitaryEntryFoldSupportTarget` | `QuantumBlockEncoding/RobinMatrix.lean:15842` |
| def | `oneTermRobinGamma3BoundaryBackendUnitaryEntryFoldSupportTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:15889` |
| theorem | `oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16013` |
| structure | `OneTermRobinGamma3BoundaryPreparedBranchExpansionTarget` | `QuantumBlockEncoding/RobinMatrix.lean:16035` |
| def | `oneTermRobinGamma3BoundaryPreparedBranchExpansionTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16090` |
| def | `oneTermRobinGamma3BoundarySparseCleanIndex_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16234` |
| def | `oneTermRobinGamma3BoundarySparseSlotIndex_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16238` |
| def | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16248` |
| def | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16263` |
| def | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16277` |
| structure | `OneTermRobinGamma3BoundaryPreparedProjectionSandwichBackendTarget` | `QuantumBlockEncoding/RobinMatrix.lean:16364` |
| def | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichBackendTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16405` |
| structure | `OneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField` | `QuantumBlockEncoding/RobinMatrix.lean:16536` |
| def | `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16570` |
| theorem | `oneTermRobinGamma3BoundaryRawUnitaryEntry_contractMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16771` |
| theorem | `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16787` |
| structure | `OneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap` | `QuantumBlockEncoding/RobinMatrix.lean:16806` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16840` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16939` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeGate_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16973` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeCircuit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16988` |
| theorem | `oneTermRobinGamma3BoundaryPreparedCompositeGateMatchesCircuit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16993` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17008` |
| structure | `OneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface` | `QuantumBlockEncoding/RobinMatrix.lean:17090` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17130` |
| abbrev | `oneTermRobinGamma3BoundaryActiveFullDim_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17257` |
| def | `oneTermRobinGamma3BoundaryActiveCleanIndex_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17262` |
| def | `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17489` |
| structure | `OneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:17570` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17607` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17939` |
| def | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17956` |
| def | `oneTermRobinGamma3BoundaryActivePreparedSparseEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18051` |
| def | `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18184` |
| theorem | `oneTermRobinGamma3BoundaryActivePreparedCircuitLabels_distinct_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18263` |
| structure | `OneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:18283` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18329` |
| structure | `OneTermRobinGamma3BoundarySourcePreparedProjectionTarget` | `QuantumBlockEncoding/RobinMatrix.lean:18534` |
| def | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18577` |
| def | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18963` |
| structure | `OneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:19713` |
| def | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19745` |
| def | `gateMatricesMatchCircuit` | `QuantumBlockEncoding/CircuitSemantics.lean:41` |
| structure | `CircuitMatrixSemantics` | `QuantumBlockEncoding/CircuitSemantics.lean:305` |
| structure | `PreparedCircuitEntryTarget` | `QuantumBlockEncoding/CircuitSemantics.lean:337` |
| structure | `BlockExtractionTarget` | `QuantumBlockEncoding/CircuitSemantics.lean:403` |
| structure | `BlockExtractionBranchContributionTarget` | `QuantumBlockEncoding/CircuitSemantics.lean:436` |
| structure | `CircuitBlockEncodingClaim` | `QuantumBlockEncoding/CircuitSemantics.lean:562` |
| structure | `FiniteBlockCompositionContract` | `QuantumBlockEncoding/CircuitSemantics.lean:577` |
| def | `signalSystemBlockRowIndex` | `QuantumBlockEncoding/CircuitSemantics.lean:597` |
| def | `signalSystemBlockColIndex` | `QuantumBlockEncoding/CircuitSemantics.lean:601` |
| theorem | `signalSystemBlockRowIndex_lt` | `QuantumBlockEncoding/CircuitSemantics.lean:613` |
| theorem | `signalSystemBlockColIndex_lt` | `QuantumBlockEncoding/CircuitSemantics.lean:628` |
| def | `signalSystemBlockProjection` | `QuantumBlockEncoding/CircuitSemantics.lean:654` |
| def | `totalCircuitQubits` | `QuantumBlockEncoding/CircuitSemantics.lean:679` |
| def | `CircuitMatrixSemantics.blockExtractionTarget` | `QuantumBlockEncoding/CircuitSemantics.lean:687` |

## Correspondence Artifacts

| Artifact | Role |
|---|---|
| `tasks/QBE-AUTO-002.md` | task/proof map |
| `conversion-windows/QBE-AUTO-002.md` | Lean/Markdown/LaTeX conversion |
| `proof-obligations/QBE-AUTO-002.md` | open obligations |
| `paper-notes/GHL2025_RobinOneTerm.tex` | human-readable proof export |
| `paper-notes/GHL2025/markdown/00_status.md` | human-readable proof export |
| `paper-notes/GHL2025/latex/sections/00_status.tex` | human-readable proof export |
| `research-wiki/cited-results/GHL2025.md` | external theorem memory |

## Latest Dialogue Signal

```text
cePreparedTargetBackendEval_n3. I did not add a duplicate wrapper. Gate passed via python3 tools/qbe.py check. Remaining local target is the active/prepared finite-composition equality oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env / evaluated backend fold.

## 20260605-045718-QBE-AUTO-002-cycle01

# Dialogue: QBE-AUTO-002 cycle 1

Append short role-tagged handoffs here.

## 2026-06-05 05:00:04 - upper

Upper handoff: mode faithful paper. Source audit confirms the theorem-facing route is the prepared singleton clean entry, not standalone H-free active closure. Existing compiled bridges include oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3, oneTermRobinGamma3BoundaryProductToCoefficientObligation_sourcePreparedTargetBackendEval_n3, and oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_activePreparedEval_n3. Next objective: prove or strictly reduce oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env as the QBE-local finite projection block feeding the source-prepared active field. H-free backend expansion remains diagnostic/recovery only. Do not recurse into Shukla-Vedula, LCU, O_D^BS, or O_f; keep theorem-facing flags false unless the exact Lean theorem compiles.

## 2026-06-05 05:03:37 - middle

Middle sync: prepared singleton clean entry remains the source-correct theorem-facing route; H-free active fold is diagnostic/recovery only. Added paper-note, obligation, and cited-results sync for the evaluated-fold active route. Gate passed with python3 tools/qbe.py check (lake build and lake build Tests). Next lower target: prove or strictly reduce oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env, using H-free backend expansion only if it feeds the prepared route; all product/LCU/block/normalized/unitarity/final flags remain false.

## 2026-06-05 05:05:55 - lower

Verified the source-correct prepared singleton route is already compiled: oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 proves the clean-clean prepared entry backend fold under hUniform, and oneTermRobinGamma3BoundaryProductToCoefficientObligation_sourcePreparedTargetBackendEval_n3 feeds that field into the fixed product map with all theorem-facing flags false. No duplicate Lean declarations added. Gate python3 tools/qbe.py check passed.

## 2026-06-05 05:09:28 - reviewer

Reviewer handoff: accepted. Gate python3 tools/qbe.py check passed. No blocking findings. Prepared singleton clean-entry route is theorem-facing and build-tested under hUniform via oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 and oneTermRobinGamma3BoundaryProductToCoefficientObligation_sourcePreparedTargetBackendEval_n3; H-free active fold remains diagnostic/recovery only. Shortcut scan clean; semantic product/LCU/block/normalized/unitarity/final flags remain false; Shukla-Vedula stays contract-only. Next lower target: oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env.
```

## Gate Policy

- Stage 1 target/transcript stabilization: upper and middle must verify that
  Lean statements, source-paper prose, register layouts, normalizers, and
  cited contracts match before broad lower proving.
- Stage 2 DAG proof discharge: lower agents work on dynamic leaves only;
  reviewer accepts progress only through `python3 tools/qbe.py check` and
  synchronized Markdown/LaTeX correspondence.
- Refiner behavior: when several failures share a dependency, repair the
  connected illness area once instead of stacking independent patches.
- No agent may mark a proof complete from self-assessment, partial score, or
  process memory.  Lean plus explicit proof-map correspondence is the gate.
