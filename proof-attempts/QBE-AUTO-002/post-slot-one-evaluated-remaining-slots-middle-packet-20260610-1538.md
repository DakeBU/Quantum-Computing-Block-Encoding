# Post-Slot-One Evaluated Remaining-Slots Middle Packet

Task: `QBE-AUTO-002`

Run: `20260610-153222-QBE-AUTO-002-cycle01`

Mode: faithful paper reproduction.

## Definition First

`ActiveUncastToPreparedEntry` is the proposition

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3 =
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
```

`FullUnitaryFold` is the proposition

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

## Source-Contract Audit

| Source anchor | Lean interface | Dependency class | Status |
|---|---|---|---|
| `main.tex:948-955` | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract | contract-only |
| `main.tex:1111-1119` | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3` | GHL-internal plus QBE-local matrix semantics | slot `0` and slot `1` have evaluated vanish feeders; slot `2` is selected; slots `3` through `6` need full evaluated vanish or cancellation |
| `main.tex:1122-1164` | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | GHL-internal transcript | compiled guard |
| `main.tex:2027-2035` | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry` | QBE-local finite projection/backend bridge | open through `FullUnitaryFold` |

## Accepted Lean Evidence

`oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3 env`
is now compiled.  It is a full evaluated slot-`1` backend branch vanish feeder.
It retires slot `1` as a lower target.

The theorem does not prove `ActiveUncastToPreparedEntry`,
`SourcePreparedEntry`, `FullUnitaryFold`, backend expansion, the one-term Robin
theorem, or any external primitive.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `active_uncast_to_prepared_entry_leaf` | uncast seven-gate `[0,0]` entry equals the cached prepared entry | remaining evaluated branch vanish/cancellation facts; prepared-side backend fold; active wrapper/cast bridge | lower 2/refiner | target `ActiveUncastToPreparedEntry` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | preferred active mathematical leaf |
| `remaining_slots_evaluated_vanish_leaf` | one remaining backend slot contribution evaluates to zero or cancels | support-only facts for slots `3` through `6`; full-index map; slot diagonal expansion | lower 2/refiner | proposed `oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3 env`, or full-index `48` diagonal-factor feeder | this packet | same gate | next preferred smaller leaf |
| `slot1_full_vanish_leaf` | slot-`1` backend branch contribution evaluates to zero | column-`16` prefix support; suffix zeros; slot-`1` seven-gate diagonal zero | none | `oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3 env` | lower2 15:31 handoff | already gated | compiled; retired |
| `unitary_fold_leaf` | full signal-zero unitary entry equals the seven-slot backend branch fold | `SourcePreparedEntry`; `HUniform`; prepared-entry backend-fold feeder | lower 2/refiner after active leaf | target `FullUnitaryFold` | this packet | same gate | open dependent root |

## Lower Packets

Lower 1 should append a narrow Section 21 to
`proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`.
The postscript should retire slot `1`, state that slots `3` through `6` have
support-only facts but no full evaluated branch vanish/cancellation theorem,
and map the proposed slot-`3` theorem to the full-index `48` diagonal factor.

Lower 2 may edit only `QuantumBlockEncoding/RobinMatrix.lean`.  The preferred
small leaf is

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3
```

or a strict full-index `48` diagonal-factor lemma that directly feeds it.
Lower 2 may instead prove `ActiveUncastToPreparedEntry` directly.  Lower 2
must not change oracle contracts, theorem hypotheses, normalizers, gate labels,
or the paper circuit.

## Retired Targets

Do not reassign the direct branch-sum wrapper, source-prepared clean-entry
alias, H-free `evalWith` route, raw `Coeff` constructor route, compiled bridge
rediscovery, prepared-side backend fold, active wrapper/cast removal, all-slot
fold expansion, slot-`0` vanish, slot-`1` support mismatch, slot-`1` evaluated
vanish, or slots `3` through `6` support-only mismatch facts.
