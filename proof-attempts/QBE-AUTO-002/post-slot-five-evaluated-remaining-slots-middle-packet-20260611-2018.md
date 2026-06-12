# Post-Slot-5 Evaluated Remaining-Slots Middle Packet

Task: `QBE-AUTO-002`

Run: `20260611-201223-QBE-AUTO-002-cycle01`

Created: 2026-06-11 20:18 JST

Mode: faithful paper reproduction.

This packet supersedes
`proof-attempts/QBE-AUTO-002/post-slot-four-evaluated-remaining-slots-middle-packet-20260611-1959.md`
for the next lower work item. It does not change the GHL2025 theorem, Fig. 4
gate order, oracle contracts, normalizer, hypotheses, or source-paper circuit.

## Accepted Lean Evidence

The latest compiled local feeder is:

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_slotFiveEval_zero_n3
```

It proves the evaluated backend slot-`5` branch contribution is zero in the
focused finite matrix-semantics backend. It is not a theorem-facing
block-encoding proof and it does not promote any oracle, $H_W^{(\kappa)}$,
$R_y$, LCU, block-projection, block-correctness, or final-extraction flag.

Retired evaluated feeders:

| Slot | Lean declaration | Status |
|---|---|---|
| `0` | `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3 env` | compiled support; retired |
| `1` | `oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3 env` | compiled feeder; retired |
| `3` | `oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3 env` | compiled feeder; retired |
| `4` | `oneTermRobinGamma3BoundaryBackendBranchContribution_slotFourEval_zero_n3 env` | compiled feeder; retired |
| `5` | `oneTermRobinGamma3BoundaryBackendBranchContribution_slotFiveEval_zero_n3 env` | compiled feeder; retired |

Slot `2` remains the selected boundary branch. Slot `6` is the only remaining
backend slot with support memory but no full evaluated vanish or cancellation
theorem.

## Definitions Before Claims

`ActiveUncastToPreparedEntry` is the active-side equality:

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3 =
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
```

The smaller slot-`6` target is:

```lean
theorem oneTermRobinGamma3BoundaryBackendBranchContribution_slotSixEval_zero_n3
    (env : String -> Rat) :
    Coeff.evalWith env
      (oneTermRobinGamma3BoundaryBackendBranchContribution_n3
        ⟨6, by native_decide⟩) = 0
```

An acceptable strict feeder is a private full-index `96` diagonal-factor lemma
that directly feeds this public theorem.

## Source Contract Audit

| Source anchor | Source role | Lean interface | Dependency class | Status |
|---|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | sparse-register preparation by $H_W^{(\kappa)}$ | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract | contract-only |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | $\gamma_3$ backend coefficient over sparse slots | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`; selected slot interface | GHL-internal plus QBE-local finite semantics | slots `0`, `1`, `3`, `4`, and `5` eliminated; slot `6` still open |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | theorem-facing gate order and cleanup | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | GHL-internal transcript | compiled guard; unchanged |
| `main.tex:2027-2035`, Definition `def:block-encoding` | clean block projection target | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry` | QBE-local projection/backend bridge | still open through `SourcePreparedEntry` and `FullUnitaryFold` |

## Lower-Agent Split

| Lower profile | Write scope | Required output |
|---|---|---|
| lower 1: natural-language proof architect | Markdown only, preferably `proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md` | Append a narrow Section 21.9 postscript. Retire slot `5`; classify slot `6` support as support-only; name the slot-`6` evaluated vanish theorem or full-index `96` feeder; list which path terms survive and which vanish. |
| lower 2: Lean implementation worker | `QuantumBlockEncoding/RobinMatrix.lean` only | Prove `ActiveUncastToPreparedEntry`, or prove `oneTermRobinGamma3BoundaryBackendBranchContribution_slotSixEval_zero_n3 env`, or prove one strict full-index `96` diagonal-factor lemma that feeds that slot-`6` theorem directly. |

Lower 2 must not change oracle contracts, theorem hypotheses, normalizers,
gate labels, or the paper circuit. Lower 2 must run:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Status |
|---|---|---|---|---|---|
| `active_uncast_to_prepared_entry_leaf` | uncast seven-gate `[0,0]` entry equals the cached prepared entry | compiled evaluated branch feeders; cached prepared entry; existing `HUniform` route | lower 2/refiner | target `ActiveUncastToPreparedEntry` | preferred active mathematical leaf |
| `slot6_full_vanish_leaf` | evaluated slot-`6` backend branch contribution is zero or cancels | full-index `96` map; slot-`6` prefix/suffix support; `Matrix.evalWith_mul_eq_zero_of_all_paths_zero` | lower 2/refiner | proposed `oneTermRobinGamma3BoundaryBackendBranchContribution_slotSixEval_zero_n3 env` | next preferred smaller leaf |
| `source_prepared_entry_leaf` | active/prepared entry equality | `active_uncast_to_prepared_entry_leaf`; wrapper/cast bridge | later lower 2 | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | open dependent target |
| `unitary_fold_leaf` | signal-zero unitary entry equals backend branch fold | `source_prepared_entry_leaf`; `HUniform`; prepared-entry backend-fold feeder | later lower 2 | `FullUnitaryFold` statement | open dependent root |
| `slot5_full_vanish_leaf` | evaluated slot-`5` backend branch contribution is zero | full-index `80` proof chain | none | `oneTermRobinGamma3BoundaryBackendBranchContribution_slotFiveEval_zero_n3 env` | proved; retired |
| `slot6_support_mismatch_memory` | slot-`6` dagger-after-SWAP support mismatch | `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3` | none | same support theorem | support-only; retired as a lower target |

## Verifier Feedback Template

If lower 2 closes the slot-`6` theorem, log:

```bash
python3 tools/qbe.py trial-log --task QBE-AUTO-002 --role lower --kind attempt \
  --status accepted \
  --feedback-field leaf=slot6_full_vanish_leaf \
  --feedback-field source_correspondence_ok=true \
  --feedback-field lean_parse_ok=true \
  --feedback-field lean_build_ok=true \
  --feedback-field finite_matrix_ok=true \
  --feedback-field block_entry_ok=partial \
  --feedback-field ancilla_cleanup_ok=not_applicable \
  --feedback-field normalizer_ok=true \
  --feedback-field closed_theorem_ok=true \
  --feedback-field error_class=none \
  --feedback-field next_route="use slots 0/1/3/4/5/6 toward ActiveUncastToPreparedEntry"
```

If the attempt stops at a strict full-index `96` feeder, use
`closed_theorem_ok=false`, `error_class=lean_tactic_gap` only if the public
slot-`6` theorem remains unproved, and name the exact feeder in `leaf`.

## Retired Routes

Do not assign raw symbolic `Coeff` constructor equality, the branch-sum
wrapper, source-prepared clean-entry alias, H-free `evalWith` route, all-slot
fold expansion, compiled bridge rediscovery, slot-`5` vanish, or slot-`6`
support-only mismatch as lower work.
