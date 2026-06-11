# Proof Blueprint: QBE-AUTO-002

Task id: `QBE-AUTO-002`
Title: Concrete Circuit Matrix Semantics Backend
Mode: `faithfulPaper`
Updated: `2026-06-10 17:55:13`
Blueprint stage: `Stage 2 DAG proof discharge, with faithful transcript checks still active`

This is QBE's compact system-of-record snapshot for long-horizon Lean proof
automation.  It follows a similar control pattern to LeanMarathon's evolving
blueprint, but QBE keeps the human-facing proof map split across Lean,
Markdown, LaTeX, proof obligations, and cited-results memory because
block-encoding papers require source notation, register conventions, and
oracle contracts to stay explicit.

## Current Directive

```text
## Current Run Directive: 2026-06-10 Post-Slot-One Evaluated Remaining-Slots Frontier

This directive supersedes the post-remaining-slots support packet for the next
lower proof attempt.  The active-side target is unchanged, but the latest Lean
evidence now includes the full evaluated slot-`1` backend branch vanish theorem:

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3
```

This theorem is compiled support only.  It retires slot `1` as the next smaller
lower target.  It does not prove `ActiveUncastToPreparedEntry`,
`SourcePreparedEntry`, `FullUnitaryFold`, backend expansion, the one-term Robin
theorem, or any oracle, $H_W^{(\kappa)}$, $R_y$, LCU, block-projection,
block-correctness, or final-extraction flag.

Compiled support to reuse:

| Declaration | Status |
|---|---|
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3` | compiled prepared-side normal form under `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; retired as a lower target |
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3` | compiled bridge rewriting `SourcePreparedEntry` to the uncast active `[0,0]` entry against the cached prepared entry; retired as a lower target |
| `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` | compiled conditional bridge from `SourcePreparedEntry` plus `HUniform` to `FullUnitaryFold`; do not rediscover |
| `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3` | compiled active column-`0` evaluated vanish support; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3` | compiled backend slot-`0` evaluated vanish support; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3` | compiled slot-`1` dagger-after-SWAP support mismatch; retired because full slot-`1` evaluated vanish is now compiled |
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3` | compiled full slot-`1` evaluated branch vanish; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3` | compiled dagger-after-SWAP support mismatch for backend slots `3`, `4`, `5`, and `6`; support-only, retired as a lower target |

The preferred local theorem remains the active-side uncast entry equality:

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3 =
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
```

The next preferred smaller leaf is a true evaluated branch
vanish/cancellation theorem for the remaining backend slots `3`, `4`, `5`, or
`6`.  Prefer slot `3` first:

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3
```

or a strict full-index `48` diagonal-factor lemma that directly feeds that
slot-`3` theorem.  Do not spend lower work on another support-only lemma for
slots `3`, `4`, `5`, or `6`.

Lower-agent split:

| Lower profile | Required behavior |
|---|---|
| lower 1: natural-language proof architect | Reuse `proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`; append only a narrow Section 21 postscript for the remaining-slots evaluated frontier.  The postscript must retire slot `1`, classify slots `3` through `6` support as support-only, and name the slot-`3` evaluated vanish theorem or full-index `48` feeder. |
| lower 2: Lean implementation worker | Edit only `QuantumBlockEncoding/RobinMatrix.lean`.  Prove the active-side uncast entry equality, the full slot-`3` evaluated branch vanish/cancellation theorem, or one strict full-index `48` diagonal-factor lemma feeding the slot-`3` theorem directly.  Do not change oracle contracts, theorem hypotheses, normalizers, gate labels, or the paper circuit. |

Retired lower targets remain retired: direct branch-sum wrapper,
source-prepared clean-entry alias, H-free `evalWith` route, raw `Coeff`
constructor route, compiled bridge rediscovery,
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3`,
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_injective_n3`,
`oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`,
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`,
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3`,
slot-`0` evaluated vanish support,
`oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3`,
`oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3`,
and `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3`.

The gate remains `python3 tools/qbe.py check`, then `lake build`, then
`lake build Tests`.

Middle must keep the Chinese summary, project article update, and ABEIS
generated appendix honest: the first-case-study one-term theorem is still
open; this packet adds only one full slot-`1` evaluated vanish feeder and
moves the proof-DAG frontier to remaining-slots evaluated vanish/cancellation
or the active-side uncast equality.  The public ABEIS report must use theorem,
equation, figure, citation, and Lean declaration names rather than local
source-line anchors.

No ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$, $R_y$, LCU, block-projection,
normalized-equality, product-to-coefficient, circuit-unitarity,
block-correctness, final-extraction, oracle, or external primitive flag is
promoted by this packet.
```

## Dynamic Leaf Queue

These are the current local proof or repair candidates.  Lower agents should
work on one item at a time; if an item is stale, upper/middle must retire it
before spending more proof-search tokens.

| Leaf | Status |
|---|---|
| active_uncast_to_prepared_entry_leaf: uncast seven-gate `[0,0]` entry equals the cached prepared entry; status: preferred active mathematical leaf; Lean: target `ActiveUncastToPreparedEntry` | candidate |
| remaining_slots_evaluated_vanish_leaf: full evaluated backend branch contribution vanishes or cancels for one remaining slot, starting with slot `3`; status: next preferred smaller leaf; Lean: proposed `oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3 env`, or a full-index `48` diagonal-factor lemma feeding it | candidate |
| source_prepared_entry_leaf: `SourcePreparedEntry`: active/prepared entry equality; status: open dependent target; Lean: `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`; `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3` | candidate |
| slot1_full_vanish_leaf: full evaluated slot-`1` backend branch contribution is zero; status: compiled support feeder; retired; Lean: `oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3 env` | candidate |
| unitary_fold_leaf: `FullUnitaryFold`: full signal-zero unitary entry equals the seven-slot backend branch fold; status: open dependent root; Lean: target `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry = blockExtractionBranchContributionSum oneTermRobinGamma3BoundaryBackendBranchContribution_n3` | candidate |
| backend_expansion_leaf: backend-expansion statement for the branch-contribution target; status: open equivalent endpoint; Lean: `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`; `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3` | candidate |
| slot0_vanish_support: active column-`0` and backend slot-`0` contributions evaluate to zero; status: compiled support; retired; Lean: `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3` | candidate |
| remaining_slots_support_mismatch: backend slots `3`, `4`, `5`, and `6` have zero dagger-after-SWAP support on the clean path; status: compiled support; retired; not full branch vanish; Lean: `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3` | candidate |

## Open Obligation Signals

```text
theorem-facing Fig. 4 transcript: Lean `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge`; class GHL-internal transcript plus QBE-local indicator bridge; status compiled guard; no full semantic proof
prepared entry backend-fold normal form: Lean `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3 H hUniform`; class QBE-local prepared-side semantic bridge under external `HUniform` contract; status compiled feeder; retired as next lower target
active wrapper/cast removal: Lean `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3 H`; class QBE-local finite matrix-entry bridge; status compiled feeder; retired as next lower target
slot-`0` active/backend vanish support: Lean `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3 env`; `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3 env`; class QBE-local finite support lemma; status compiled support; retired as next lower target
slot-`1` full evaluated branch vanish: Lean `oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3 env`; class QBE-local finite branch evaluation lemma; status compiled support feeder; retired as next lower target
slots `3` through `6` dagger-after-SWAP support: Lean `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3`; class QBE-local finite support lemma; status compiled support; retired; not a full branch vanish theorem
remaining-slots evaluated branch vanish/cancellation: Lean proposed `oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3 env`, or a full-index `48` diagonal-factor lemma feeding it directly; class QBE-local finite branch evaluation lemma; status next preferred smaller leaf
active-side uncast entry equality: Lean target `ActiveUncastToPreparedEntry`; class QBE-local finite seven-gate matrix semantics; status preferred active mathematical leaf
source-prepared active/prepared entry equality: Lean `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`; class QBE-local prepared circuit semantics under an external cited contract; status open dependent target; recover only after active-side leaf
active/prepared entry to fold bridge: Lean `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`; `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_unitaryEntryFold_n3`; class QBE-local bridge under `HUniform`; status compiled conditional; not closure
full signal-zero unitary fold: Lean `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry = blockExtractionBranchContributionSum oneTermRobinGamma3BoundaryBackendBranchContribution_n3`; class QBE-local finite projection/backend theorem; status open dependent root
external sparse preparation: Lean `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; class external cited contract; status contract-only; no Shukla--Vedula formalization in this packet
diagnostic raw constructor route: Lean `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`; class diagnostic/backlog; status still `sorry`-guarded; do not assign as source closure
```

## Lean Declaration Index

Recent task-relevant declarations:

| Kind | Lean name | File |
|---|---|---|
| structure | `OneTermRobinGamma3BoundaryBackendUnitaryEntryFoldSupportTarget` | `QuantumBlockEncoding/RobinMatrix.lean:17475` |
| def | `oneTermRobinGamma3BoundaryBackendUnitaryEntryFoldSupportTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17522` |
| theorem | `oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17646` |
| structure | `OneTermRobinGamma3BoundaryPreparedBranchExpansionTarget` | `QuantumBlockEncoding/RobinMatrix.lean:17668` |
| def | `oneTermRobinGamma3BoundaryPreparedBranchExpansionTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17723` |
| def | `oneTermRobinGamma3BoundarySparseCleanIndex_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17867` |
| def | `oneTermRobinGamma3BoundarySparseSlotIndex_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17871` |
| def | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17881` |
| def | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17896` |
| def | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3` | `QuantumBlockEncoding/RobinMatrix.lean:17910` |
| structure | `OneTermRobinGamma3BoundaryPreparedProjectionSandwichBackendTarget` | `QuantumBlockEncoding/RobinMatrix.lean:17997` |
| def | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichBackendTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18038` |
| structure | `OneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField` | `QuantumBlockEncoding/RobinMatrix.lean:18169` |
| def | `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18203` |
| theorem | `oneTermRobinGamma3BoundaryRawUnitaryEntry_contractMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18404` |
| theorem | `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18420` |
| structure | `OneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap` | `QuantumBlockEncoding/RobinMatrix.lean:18439` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18473` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18572` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeGate_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18606` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeCircuit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18621` |
| theorem | `oneTermRobinGamma3BoundaryPreparedCompositeGateMatchesCircuit_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18626` |
| def | `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18641` |
| structure | `OneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface` | `QuantumBlockEncoding/RobinMatrix.lean:18723` |
| def | `oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18763` |
| abbrev | `oneTermRobinGamma3BoundaryActiveFullDim_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18890` |
| def | `oneTermRobinGamma3BoundaryActiveCleanIndex_n3` | `QuantumBlockEncoding/RobinMatrix.lean:18895` |
| def | `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19122` |
| structure | `OneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:19297` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19334` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19729` |
| def | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19746` |
| def | `oneTermRobinGamma3BoundaryActivePreparedSparseEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19841` |
| def | `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:19974` |
| theorem | `oneTermRobinGamma3BoundaryActivePreparedCircuitLabels_distinct_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20053` |
| structure | `OneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:20073` |
| def | `oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20119` |
| structure | `OneTermRobinGamma3BoundarySourcePreparedProjectionTarget` | `QuantumBlockEncoding/RobinMatrix.lean:20347` |
| def | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20390` |
| def | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3` | `QuantumBlockEncoding/RobinMatrix.lean:20812` |
| structure | `OneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget` | `QuantumBlockEncoding/RobinMatrix.lean:21630` |
| def | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3` | `QuantumBlockEncoding/RobinMatrix.lean:21662` |
| theorem | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_diagnostic_n3` | `QuantumBlockEncoding/RobinMatrix.lean:22489` |
| theorem | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` | `QuantumBlockEncoding/RobinMatrix.lean:22519` |
| theorem | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic` | `QuantumBlockEncoding/RobinMatrix.lean:22532` |
| theorem | `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | `QuantumBlockEncoding/RobinMatrix.lean:22550` |
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
BE-AUTO-002 cycle 1

Append short role-tagged handoffs here.

## 20260610-155221-QBE-AUTO-002-cycle01

# Dialogue: QBE-AUTO-002 cycle 1

Append short role-tagged handoffs here.

## 20260610-154743-QBE-AUTO-002-cycle01

# Dialogue: QBE-AUTO-002 cycle 1

Append short role-tagged handoffs here.

## 20260610-153222-QBE-AUTO-002-cycle01

# Dialogue: QBE-AUTO-002 cycle 1

Append short role-tagged handoffs here.

## 2026-06-10 15:35:51 - upper

Upper handoff: faithful paper reproduction, Stage 2 DAG proof discharge. Source-contract audit against GHL2025 one-term theorem, Eq ROBIN clarified, Fig 1-term ROBIN, H_W preparation, and block-encoding definition finds no new contract drift: theorem-facing transcript guards remain compiled, H_W/ODBS/ODTS/O_f/R_y/LCU/block-composition stay contract-only. Latest Lean evidence retires oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3 as compiled full slot-1 evaluated vanish; generated frontier files are stale where they still present slot-1 as next. Next objective: advance ActiveUncastToPreparedEntry by proving a true evaluated branch vanish/cancellation for remaining backend slots 3-6, preferably a slot-3 theorem oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3 env or a strict full-index-48 diagonal factor lemma feeding it; lower may prove ActiveUncastToPreparedEntry directly if available. Do not assign more support-only lemmas for slots 3-6. Root path remains remaining slot vanish/cancellation -> ActiveUncastToPreparedEntry -> SourcePreparedEntry -> FullUnitaryFold -> backend expansion -> one-term theorem. Middle must repair conversion window, proof obligations, blueprint, Chinese summary, project article, and ABEIS generated status to retire slot1 and name the remaining-slots evaluated vanish frontier. Lower1 should append a narrow Section 21 to the existing unitary-fold DAG addendum; lower2 edits only QuantumBlockEncoding/RobinMatrix.lean. Reviewer requires python3 tools/qbe.py check, lake build, lake build Tests, rejects raw Coeff route and any oracle/H_W/R_y/LCU/block/final flag promotion.

## 2026-06-10 15:43:34 - middle

Middle sync repaired the generated frontier after slot-1 full evaluated vanish compiled. Retired oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3 as a lower target, selected remaining-slots evaluated vanish/cancellation starting with oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3 env or a full-index-48 diagonal-factor feeder, and kept ActiveUncastToPreparedEntry as the preferred active mathematical leaf. Updated task directive, conversion window, proof obligations, proof blueprint/status, Chinese summary, project article update, and ABEIS generated appendix. No oracle, H_W, R_y, LCU, block-projection, final-extraction, normalizer, gate-label, or theorem-completion flag was promoted. Gates passed: python3 tools/qbe.py check; lake build; lake build Tests, with known RobinMatrix diagnostic sorries.
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
