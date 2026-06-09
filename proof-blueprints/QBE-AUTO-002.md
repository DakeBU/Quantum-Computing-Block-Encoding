# Proof Blueprint: QBE-AUTO-002

Task id: `QBE-AUTO-002`
Title: Concrete Circuit Matrix Semantics Backend
Mode: `faithfulPaper`
Updated: `2026-06-09 12:38:53`
Blueprint stage: `Stage 2 DAG proof discharge, with faithful transcript checks still active`

This is QBE's compact system-of-record snapshot for long-horizon Lean proof
automation.  It follows a similar control pattern to LeanMarathon's evolving
blueprint, but QBE keeps the human-facing proof map split across Lean,
Markdown, LaTeX, proof obligations, and cited-results memory because
block-encoding papers require source notation, register conventions, and
oracle contracts to stay explicit.

## Current Directive

```text
## Immediate 6h Focus: Source-Faithful Fig. 4 Transcript And EvalWith Bridge (2026-06-08 Active)

This is the active directive for the next active-time theorem-closure run.  It
supersedes the 2026-06-07 active/prepared directive above.

The current blocker is source transcript fidelity plus one semantic entry
bridge, not broad external-oracle formalization.  The source anchors are:

| Source | Role |
|---|---|
| `main.tex:1098-1109` | Theorem `1 term robin`, target block-encoding claim |
| `main.tex:1111-1119` | Eq. `ROBIN clarified`, especially the `gamma_3` clean coefficient |
| `main.tex:1122-1164` | Fig. `1 term ROBIN`, full theorem-facing gate order and cleanup |
| `main.tex:948-955` | `H_W^(kappa)` sparse-register preparation contract |
| `main.tex:2027-2035` | block-encoding projection definition |

Objective for this batch:

1. Correct the theorem-facing Fig. 4 transcript before further proof search.
   Add an explicit `U_indic^dagger` gate slot.  If the matrix is equal to
   `U_indic` because the indicator permutation is self-inverse, record that as
   a Lean lemma or explicit bridge, but keep the gate label and circuit role
   faithful to the paper.
2. Keep the two `H_W^(kappa)` sides visible as theorem-facing boundary gates
   or as a clearly named prepared-sandwich contract.  Do not claim the full
   Fig. 4 circuit from a seven-gate active product that omits those sides.
3. Distinguish pre-SWAP `O_{D^T}^{BS}` from post-SWAP `(O_D^{BS})^dagger` in
   the conversion window, proof notes, and any Lean labels introduced this
   batch.
4. Demote the raw symbolic `Coeff` constructor-equality route to
   diagnostic/backlog.  The active proof route is an `evalWith` semantic entry
   bridge.

After the transcript correction, lower agents may target one of:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
```

or a strictly smaller theorem that directly feeds
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`.

Lower-agent split:

| Lower profile | Required behavior |
|---|---|
| lower 1: natural-language proof architect | Produce a proof-DAG packet translating `main.tex:1098-1164` into source line, Lean declaration, existing lemma, missing lemma, and dependency class (`GHL-internal`, `external-cited-contract`, `QBE-local semantic bridge`). |
| lower 2: Lean implementation worker | Implement exactly one ready Lean leaf from that packet: preferably `U_indic^dagger` transcript correction, `H_W` prepared-boundary naming, or the smallest `evalWith` bridge. |

Reviewer checklist:

- Reject any cycle that keeps the old raw `Coeff` equality as the main theorem.
- Reject any claim that the full GHL Fig. 4 circuit is formalized while
  explicit `U_indic^dagger` or the two `H_W^(kappa)` sides are absent from the
  theorem-facing transcript.
- Reject promotion of ODBS/ODTS/O_f/H_W/R_y contract flags without a Lean theorem
  and source/citation row.
- Require the generated Chinese cycle summary at
  `paper-notes/GHL2025/markdown/cycle-summaries/latest.md` to expose source
  lines, Lean status, and remaining obligations.

Non-goals:

- Do not recursively formalize Shukla--Vedula, Gilyén et al., LCU, or the prior
  PDE sparse-access paper in this batch.
- Do not work on the 1D Hamiltonian theorem, multidimensional theorem, QSVT, or
  project article polish until the one-term Robin theorem-facing route is
  closed under cited contracts.
- Do not add assumptions, weaken the target, or replace the paper oracle.
```

## Dynamic Leaf Queue

These are the current local proof or repair candidates.  Lower agents should
work on one item at a time; if an item is stale, upper/middle must retire it
before spending more proof-search tokens.

| Leaf | Status |
|---|---|
| Latest handoff indicates at least one assigned lower target was already compiled; upper/middle should retire stale directives before more proof search. | stale-check |
| 1. Correct the theorem-facing Fig. 4 transcript before further proof search. Add an explicit `U_indic^dagger` gate slot. If the matrix is equal to `U_indic` because the indicator permutation is self-inverse, record that as a Lean lemma or explicit bridge, b... | candidate |
| 2. Keep the two `H_W^(kappa)` sides visible as theorem-facing boundary gates or as a clearly named prepared-sandwich contract. Do not claim the full Fig. 4 circuit from a seven-gate active product that omits those sides. | candidate |
| 3. Distinguish pre-SWAP `O_{D^T}^{BS}` from post-SWAP `(O_D^{BS})^dagger` in the conversion window, proof notes, and any Lean labels introduced this batch. | candidate |
| 4. Demote the raw symbolic `Coeff` constructor-equality route to diagnostic/backlog. The active proof route is an `evalWith` semantic entry bridge. | candidate |
| - Reject any cycle that keeps the old raw `Coeff` equality as the main theorem. | candidate |
| - Reject any claim that the full GHL Fig. 4 circuit is formalized while explicit `U_indic^dagger` or the two `H_W^(kappa)` sides are absent from the theorem-facing transcript. | candidate |
| - Reject promotion of ODBS/ODTS/O_f/H_W/R_y contract flags without a Lean theorem and source/citation row. | candidate |
| - Require the generated Chinese cycle summary at `paper-notes/GHL2025/markdown/cycle-summaries/latest.md` to expose source lines, Lean status, and remaining obligations. | candidate |
| - Do not recursively formalize Shukla--Vedula, Gilyén et al., LCU, or the prior PDE sparse-access paper in this batch. | candidate |
| - Do not work on the 1D Hamiltonian theorem, multidimensional theorem, QSVT, or project article polish until the one-term Robin theorem-facing route is closed under cited contracts. | candidate |
| - Do not add assumptions, weaken the target, or replace the paper oracle. | candidate |

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
| structure | `OneTermRobinGamma3BoundaryBackendUnitaryEntryFoldSupportTarget` | `QuantumBlockEncoding/RobinMatrix.lean:16430` |
| def | `oneTermRobinGamma3BoundaryBackendUnitaryEntryFoldSupportTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16477` |
| theorem | `oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16601` |
| structure | `OneTermRobinGamma3BoundaryPreparedBranchExpansionTarget` | `QuantumBlockEncoding/RobinMatrix.lean:16623` |
| def | `oneTermRobinGamma3BoundaryPreparedBranchExpansionTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16678` |
| def | `oneTermRobinGamma3BoundarySparseCleanIndex_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16822` |
| def | `oneTermRobinGamma3BoundarySparseSlotIndex_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16826` |
| def | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16836` |
| def | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16851` |
| def | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16865` |
| structure | `OneTermRobinGamma3BoundaryPreparedProjectionSandwichBackendTarget` | `QuantumBlockEncoding/RobinMatrix.lean:16952` |
| def | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichBackendTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:16993` |
| structure | `OneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField` | `QuantumBlockEncoding/RobinMatrix.lean:17124` |
| def | `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17158` |
| theorem | `oneTermRobinGamma3BoundaryRawUnitaryEntry_contractMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17359` |
| theorem | `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17375` |
| structure | `OneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap` | `QuantumBlockEncoding/RobinMatrix.lean:17394` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17428` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17527` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeGate_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17561` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeCircuit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17576` |
| theorem | `oneTermRobinGamma3BoundaryPreparedCompositeGateMatchesCircuit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17581` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17596` |
| structure | `OneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface` | `QuantumBlockEncoding/RobinMatrix.lean:17678` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17718` |
| abbrev | `oneTermRobinGamma3BoundaryActiveFullDim_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17845` |
| def | `oneTermRobinGamma3BoundaryActiveCleanIndex_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17850` |
| def | `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18077` |
| structure | `OneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:18158` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18195` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18527` |
| def | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18544` |
| def | `oneTermRobinGamma3BoundaryActivePreparedSparseEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18639` |
| def | `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18772` |
| theorem | `oneTermRobinGamma3BoundaryActivePreparedCircuitLabels_distinct_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18851` |
| structure | `OneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:18871` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18917` |
| structure | `OneTermRobinGamma3BoundarySourcePreparedProjectionTarget` | `QuantumBlockEncoding/RobinMatrix.lean:19122` |
| def | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19165` |
| def | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19551` |
| structure | `OneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:20301` |
| def | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20333` |
| theorem | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_diagnostic_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20988` |
| theorem | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21018` |
| theorem | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic` | `QuantumBlockEncoding/RobinMatrix.lean:21031` |
| theorem | `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21049` |
| def | `gateMatricesMatchCircuit` | `QuantumBlockEncoding/CircuitSemantics.lean:41` |
| structure | `CircuitMatrixSemantics` | `QuantumBlockEncoding/CircuitSemantics.lean:404` |
| structure | `PreparedCircuitEntryTarget` | `QuantumBlockEncoding/CircuitSemantics.lean:436` |
| structure | `BlockExtractionTarget` | `QuantumBlockEncoding/CircuitSemantics.lean:502` |
| structure | `BlockExtractionBranchContributionTarget` | `QuantumBlockEncoding/CircuitSemantics.lean:535` |
| structure | `CircuitBlockEncodingClaim` | `QuantumBlockEncoding/CircuitSemantics.lean:661` |
| structure | `FiniteBlockCompositionContract` | `QuantumBlockEncoding/CircuitSemantics.lean:676` |
| def | `signalSystemBlockRowIndex` | `QuantumBlockEncoding/CircuitSemantics.lean:696` |
| def | `signalSystemBlockColIndex` | `QuantumBlockEncoding/CircuitSemantics.lean:700` |
| theorem | `signalSystemBlockRowIndex_lt` | `QuantumBlockEncoding/CircuitSemantics.lean:712` |
| theorem | `signalSystemBlockColIndex_lt` | `QuantumBlockEncoding/CircuitSemantics.lean:727` |
| def | `signalSystemBlockProjection` | `QuantumBlockEncoding/CircuitSemantics.lean:753` |
| def | `totalCircuitQubits` | `QuantumBlockEncoding/CircuitSemantics.lean:778` |
| def | `CircuitMatrixSemantics.blockExtractionTarget` | `QuantumBlockEncoding/CircuitSemantics.lean:786` |

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
th`. The two-path expression is now `O_f[12,96]*prefix[96,0] +
O_f[12,97]*prefix[97,0]` where prefix entries trace through O_D^BS (unique
path) and Ry rotation (cosHalf/sinHalf). Next cycle: (1) prove `Matrix.mul_assoc`
for the custom Matrix type to close the associativity bridge sorry, (2) compile
prefix entry evaluation lemmas, (3) attempt the expanded entry equality and
backend fold comparison. No external results needed; the gap is entirely
internal finite matrix computation.

### 9. Cited Prior Results

| Result | Source | Used at | Lean status |
|---|---|---|---|
| `evalWith_mul_unique_path` | CircuitSemantics.lean | suffix eval lemmas | proved |
| `evalWith_mul_two_path` | CircuitSemantics.lean:328 | SevenGateTwoPath_n3 | proved this cycle |
| `PrefixCol0Support_n3` | RobinMatrix.lean:7445 | SevenGateTwoPath_n3 | proved |
| `PreparedCompositeCleanEntryEval_eq_backend_n3` | RobinMatrix.lean:18866 | prepared→backend bridge | proved |
| `EvalGateMatrices_eq_sevenGateMatrix_n3` | RobinMatrix.lean:21049 | associativity bridge | sorry-guarded, needs `Matrix.mul_assoc` |
| `Matrix.mul_assoc` | Core.lean (custom Matrix) | associativity bridge | obligation, not yet formalized |

No external paper results need formalization this cycle. All use sites reference
compiled QBE lemmas or the internal `Matrix.mul_assoc` obligation.

## 2026-06-07 21:09:43 - upper

Cycle 1 upper assessment: faithfulPaper mode continues. Target reduces to EvaluatedBackendFoldStatement_n3 env. Two-path infrastructure compiled: SevenGateTwoPath_n3, SuffixRow0Col96/97_eval_n3. Next: (1) prove Matrix.mul_assoc for custom Matrix type (close sorry at line 21049), (2) compile prefix entry eval lemmas (prefix[96,0] = cosHalf, prefix[97,0] = sinHalf via O_D^BS unique path), (3) attempt expanded entry equality. No external results needed. Build passes with 2 pre-existing sorries.

## 2026-06-07 21:18:38 - middle

Dispatched 2 lower agents: (1) architect writing phase2 plan for EvaluatedBackendFoldStatement_n3 route through prefix evaluation and backend fold comparison, (2) Lean worker attempting to close EvalGateMatrices_eq_sevenGateMatrix_n3 sorry via Matrix.mul_assoc. Build gate passed with 2 pre-existing sorries.

## 2026-06-07 21:39:46 - middle

Phase 2 complete. Key finding: sorry EvalGateMatrices_eq_sevenGateMatrix_n3 is UNPROVABLE as stated (raw Coeff-level matrix equality between differently-parenthesized products). Coeff is symbolic; equality only holds under evalWith. Failure record at proof-attempts/QBE-AUTO-002/evalGateMatrices-associativity-attempt.md. Architect identified prefix[96,0] = boundary_cos_half_0_2, prefix[97,0] = boundary_sin_half_0_2, and diagonal uniformity as critical gap. Corrected route: replace raw-Coeff sorry with evalWith-level bridge for [0,0] entry. Iff chain is valid (proved without sorry). Proof-obligations ledger updated. Next cycle: (1) prove evalWith-level bridge, (2) compute prefix entries, (3) attempt EvaluatedBackendFoldStatement_n3 directly.
```

## Gate Policy

- Stage 1 target/transcript stabilization: upper and middle must verify that
  Lean statements, source-paper prose, register layouts, normalizers, and
  cited contracts match before broad lower proving.
- Stage 2 DAG proof discharge: lower agents work on dynamic leaves only;
  reviewer accepts progress only through `python3 tools/qbe.py check` and
  synchronized Markdown/LaTeX correspondence.
- Mixed lower-agent proof mode: when two lower agents are available, lower 1
  writes the natural-language dependency proof and active-leaf table; lower 2
  compiles exactly one ready Lean leaf from that table.
- Refiner behavior: when several failures share a dependency, repair the
  connected illness area once instead of stacking independent patches.
- No agent may mark a proof complete from self-assessment, partial score, or
  process memory.  Lean plus explicit proof-map correspondence is the gate.
