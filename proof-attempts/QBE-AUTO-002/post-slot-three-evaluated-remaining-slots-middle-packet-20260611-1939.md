# Middle Packet: Post-Slot-Three Remaining-Slots Evaluated Frontier

Task id: `QBE-AUTO-002`
Run id: `20260611-193425-QBE-AUTO-002-cycle01`
Mode: faithful paper reproduction

This packet assigns the next fixed Lean frontier after the compiled slot-`3`
evaluated vanish feeder. It does not change the paper theorem, oracle
contracts, theorem hypotheses, normalizer, gate labels, or paper circuit.

## Source Fragment

| Source anchor | Paper role | Lean-facing contract | Dependency class |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}$ sparse-register preparation | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | all-slot $\gamma_3$ branch fold with selected slot `2` | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3` and selected branch lemmas | GHL-internal plus QBE-local matrix semantics |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | theorem-facing gate order with both $H_W$ sides and explicit `U_indic^dagger` | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` | GHL-internal transcript |
| `main.tex:2027-2035`, Definition `def:block-encoding` | clean signal-block projection | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry` | QBE-local projection/backend bridge |

## Current Compiled Facts

The following Lean declarations are compiled feeders and must not be reassigned
as lower targets:

| Leaf | Lean declaration | Status |
|---|---|---|
| slot `0` vanish | `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3 env` | compiled; retired |
| slot `1` vanish | `oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3 env` | compiled; retired |
| slot `3` vanish | `oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3 env` | compiled; retired |
| slots `3` through `6` support | `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3` | compiled support-only; retired |
| active/prepared bridge | `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3 H` | compiled conditional bridge; retired |
| prepared backend normal form | `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3 H hUniform` | compiled feeder; retired |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Local gate | Status |
|---|---|---|---|---|---|---|
| `active_uncast_to_prepared_entry_leaf` | uncast seven-gate `[0,0]` entry equals the cached prepared entry | slots `0`, `1`, `3` vanish; remaining slots `4` through `6`; cached prepared entry | lower 2/refiner | target `ActiveUncastToPreparedEntry` | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | preferred mathematical leaf |
| `slot4_full_vanish_leaf` | full evaluated backend branch contribution for slot `4` vanishes or cancels | support theorem for slots `3..6`; full-index map; diagonal branch expansion at full index `64` | lower 2/refiner | proposed `oneTermRobinGamma3BoundaryBackendBranchContribution_slotFourEval_zero_n3 env` | same gate | next smaller leaf |
| `slot4_diagonal_factor_leaf` | seven-gate diagonal factor at full index `64` evaluates to zero or cancels | prefix/suffix support chain following the slot-`3` proof pattern | lower 2/refiner | private helper feeding `slot4_full_vanish_leaf` | same gate | acceptable strict feeder |
| `source_prepared_entry_leaf` | `SourcePreparedEntry` | `active_uncast_to_prepared_entry_leaf`; cast bridge | later lower/refiner | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | same gate | open dependent target |
| `unitary_fold_leaf` | `FullUnitaryFold` | `SourcePreparedEntry`; `HUniform`; prepared backend normal form | later lower/refiner | target signal-unitary fold equality | same gate | open dependent root |

## Lower-Agent Split

Lower 1 receives the natural-language proof packet. Append only a narrow
Section 21.7 postscript to
`proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`.
The postscript should retire slot `3`, classify slots `4` through `6`
support-only facts as insufficient for closure, and outline the slot-`4`
route through full index `64`.

Lower 2 receives the Lean implementation packet. Edit only
`QuantumBlockEncoding/RobinMatrix.lean`. Prove exactly one of:

1. `ActiveUncastToPreparedEntry`;
2. `oneTermRobinGamma3BoundaryBackendBranchContribution_slotFourEval_zero_n3 env`;
3. one private full-index `64` diagonal-factor/support-chain lemma that feeds
   the slot-`4` theorem directly.

Lower 2 must not change oracle contracts, theorem hypotheses, normalizers,
gate labels, or the paper circuit.

## Verifier Feedback Template

If lower 2 closes the slot-`4` theorem, log:

```text
leaf=slot4_full_vanish_leaf
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
block_entry_ok=partial
ancilla_cleanup_ok=not_applicable
normalizer_ok=true
closed_theorem_ok=true
error_class=none
next_route=attempt slot5 evaluated branch vanish/cancellation or use slots 0/1/3/4 vanish toward ActiveUncastToPreparedEntry
```

If lower 2 only proves a strict full-index `64` feeder, set
`closed_theorem_ok=false`, `error_class=lean_tactic_gap`, and name the exact
public slot-`4` theorem as `next_route`.

No ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$, $R_y$, LCU, block-projection,
normalized-equality, product-to-coefficient, circuit-unitarity,
block-correctness, final-extraction, oracle, or external primitive flag is
promoted by this packet.
