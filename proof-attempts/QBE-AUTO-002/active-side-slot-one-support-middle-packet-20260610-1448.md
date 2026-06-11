# Active-Side Slot-One Support Middle Packet

Task: `QBE-AUTO-002`

Run: `20260610-144151-QBE-AUTO-002-cycle01`

Mode: `faithfulPaper`

## Definition First

`ActiveUncastToPreparedEntry` is the active-side equality

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3 =
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
```

The dependent theorem path remains:

```text
ActiveUncastToPreparedEntry
  -> SourcePreparedEntry
  -> FullUnitaryFold
  -> backendExpansionStatement
```

The external sparse-preparation contract remains explicit as

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

and is not formalized or promoted by this packet.

## New Compiled Support

Lower 2 compiled:

```lean
oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3
```

This theorem records a slot-`1` clean-path support mismatch.  The backend slot
maps to full index `16`; the forward sparse-access image is `112`; the SWAP
image is `14`; and the transpose-style dagger row for the original slot-`1`
index has zero entry at column `14`.

This is a support feeder only.  It is not a full slot-`1` branch vanish
theorem, does not prove `ActiveUncastToPreparedEntry`, and does not prove
`SourcePreparedEntry`, `FullUnitaryFold`, backend expansion, or the one-term
Robin block-encoding theorem.

## Source Contract Audit

| Source anchor | Current Lean interface | Dependency class | Status |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract | contract-only; no Shukla--Vedula formalization |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | GHL-internal plus QBE-local matrix semantics | slot `0` has evaluated vanish support, slot `1` has dagger-after-SWAP support, slot `2` is the selected displayed boundary branch, and slots `3` through `6` remain open |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | GHL-internal transcript | compiled guard; no gate labels or circuit order changed |
| `main.tex:2027-2035`, Definition `def:block-encoding` | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry` | QBE-local finite projection/backend bridge | still open through `SourcePreparedEntry` and `FullUnitaryFold` |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `slot0_vanish_support` | active column-`0` and backend slot-`0` contributions evaluate to zero | two-path active expansion; slot-`0` backend summand formula | none | `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3` | `active-side-slot-zero-support-middle-packet-20260610-1420.md` | already gated | compiled support; retired |
| `slot1_support_mismatch` | slot-`1` clean path has zero dagger-after-SWAP support at the focused backend row | backend full-index map; sparse-access image; SWAP image; dagger matrix entry | none | `oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3` | this packet | already gated | compiled support; not full slot-`1` vanish |
| `remaining_slot_support_leaf` | one strict support, vanish, or cancellation lemma for slot `1` as a full branch, or for slots `3`, `4`, `5`, or `6` | slot-`0` vanish; slot-`1` support mismatch; selected slot-`2` branch; all-slot fold expansion | lower 2/refiner | no selected Lean name yet | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | next acceptable smaller leaf |
| `active_uncast_to_prepared_entry_leaf` | uncast active seven-gate `[0,0]` entry equals the cached prepared entry | remaining slot support/cancellation facts; prepared cached entry; `HUniform` when comparing to the backend normal form | lower 2/refiner | target `ActiveUncastToPreparedEntry` | this packet | same gate | preferred active mathematical leaf |
| `source_prepared_entry_leaf` | `SourcePreparedEntry` | `active_uncast_to_prepared_entry_leaf`; active wrapper/cast bridge | lower 2/refiner after active leaf | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | this packet | same gate | open dependent target |
| `unitary_fold_leaf` | `FullUnitaryFold` | `SourcePreparedEntry`; `HUniform`; prepared-entry backend-fold feeder | lower 2/refiner after source-prepared entry | `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` consumes the future proof | this packet | same gate | open dependent root |

## Lower Packet

The next Lean worker should edit only `QuantumBlockEncoding/RobinMatrix.lean`
and prove one of:

1. `ActiveUncastToPreparedEntry`, with the existing `HUniform` contract visible
   when comparing the prepared side to the backend normal form; or
2. one strict support, vanish, or cancellation lemma that feeds that equality
   directly.

A smaller slot theorem is acceptable only if it names the exact slot and says
how it is used in the active/prepared equality.  Repeating the compiled
slot-`0` vanish, the slot-`1` dagger-after-SWAP support fact, the prepared-side
backend fold, the wrapper/cast bridge, raw `Coeff` constructor equality, or
compiled bridge rediscovery is stale work.

No ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$, $R_y$, LCU, block-projection,
normalized-equality, product-to-coefficient, circuit-unitarity,
block-correctness, final-extraction, oracle, or external primitive flag is
promoted by this packet.
