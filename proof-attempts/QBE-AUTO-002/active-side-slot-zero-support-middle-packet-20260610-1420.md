# QBE-AUTO-002 Middle Packet: Active-Side Slot-Zero Support Accepted

Created: 2026-06-10 14:20 JST

Scope: middle proof-DAG synchronization and next lower-agent packet only.  This
packet changes no Lean source and promotes no theorem-facing semantic flag.

## Definitions Before Claims

Define `HUniform` as:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

Define `ActiveUncastToPreparedEntry` as:

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3 =
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
```

Define `SourcePreparedEntry` as:

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

Define `FullUnitaryFold` as:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

## Accepted Feeders

| Feeder | Role | Status |
|---|---|---|
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3` | cached prepared entry equals the seven-slot backend fold under `HUniform` | compiled; retired |
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3` | rewrites `SourcePreparedEntry` to `ActiveUncastToPreparedEntry` | compiled; retired |
| `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3` | active seven-gate column-`0` entry evaluates to zero | compiled support; retired |
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3` | slot-`0` backend contribution evaluates to zero | compiled support; retired |
| `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` | sends `HUniform` and `SourcePreparedEntry` to `FullUnitaryFold` | compiled conditional bridge; retired |

The slot-`0` facts reduce one support branch only.  They do not prove
`ActiveUncastToPreparedEntry`, do not prove `SourcePreparedEntry`, and do not
allow lower agents to erase slots `1` through `6` from the backend fold.

## Source Translation

| Source anchor | Proof step | Dependency class | Lean interface |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | The two $H_W^{(\kappa)}$ sides supply the clean-column contract used when the prepared entry is compared to the backend fold. | external-cited-contract | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | The $\gamma_3$ boundary coefficient is represented by a full seven-slot sparse-register sum; slot `2` is selected, but the other slots remain present until Lean proves their support status. | GHL-internal plus QBE-local matrix semantics | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3` |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | The theorem-facing circuit keeps both $H_W^{(\kappa)}$ sides and the explicit `U_indic^dagger` role; the active uncast product is only the inner seven-gate component. | GHL-internal transcript plus QBE-local guard | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge`; `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` |
| `main.tex:2027-2035`, Definition `def:block-encoding` | The signal-zero full-unitary entry must be connected to the prepared-entry route before theorem-facing closure. | QBE-local finite projection/backend bridge | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry`; `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` |

## Proof-DAG Frontier

| Node | Dependencies | Status | Owner | Next action |
|---|---|---|---|---|
| `fig4_transcript_guard` | source Fig. `1 term ROBIN`; indicator self-inverse bridge | compiled | middle/reviewer | Reuse the theorem-facing gate list and dagger bridge. |
| `prepared_entry_backend_fold_feeder` | `HUniform`; prepared clean-entry lemmas | compiled feeder; retired | none | Do not reprove. |
| `active_wrapper_cast_feeder` | active signal-zero entry; finite cast removal | compiled feeder; retired | none | Do not reprove. |
| `slot0_vanish_support` | two-path column-`0` expansion; slot-`0` backend summand formula | compiled support; retired | none | Do not reassign. |
| `active_uncast_to_prepared_entry_leaf` | remaining active support/cancellation facts; cached prepared entry | active mathematical leaf | lower 2/refiner | Prove the equality through the existing `HUniform`-visible route, or prove one strict support, vanish, or cancellation lemma that feeds it. |
| `source_prepared_entry_leaf` | active leaf; wrapper/cast bridge | open dependent target | lower 2/refiner after active leaf | Recover through `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3`. |
| `unitary_fold_leaf` | `SourcePreparedEntry`; `HUniform`; prepared-side backend normal form | open dependent root | lower 2/refiner after source-prepared entry | Use `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` only after `SourcePreparedEntry` is proved. |
| `retired_routes` | branch-sum wrapper, source-prepared clean alias, H-free `evalWith`, raw `Coeff`, all-slot feeders, slot-`0` support, and bridge rediscovery | stale | none | Do not assign as lower work. |

## Lower 1 Addendum Packet

Lower 1 should add only a short postscript to
`proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`.
The postscript should state:

- slot `0` is now a compiled evaluated vanish support branch;
- slots `1`, `3`, `4`, `5`, and `6` still require support, vanish, or
  cancellation analysis before the active-side equality can close;
- slot `2` remains the displayed boundary branch from Eq. `ROBIN clarified`;
- `HUniform` remains an external cited contract and is not formalized here;
- `ActiveUncastToPreparedEntry`, `SourcePreparedEntry`, `FullUnitaryFold`, and
  the one-term theorem remain open.

## Lower 2 Lean Packet

Allowed write scope: `QuantumBlockEncoding/RobinMatrix.lean` only.

Preferred target:

```lean
theorem <new_name>
    (H : Matrix 8 8 Coeff)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    (evalGateMatrices
      (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
      oneTermRobinGamma3BoundaryPrefixRow0_n3
      oneTermRobinGamma3BoundaryPrefixRow0_n3 =
        (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry := by
  -- active finite product proof using the existing HUniform route
```

A strictly smaller acceptable theorem is one named support, vanish, or
cancellation lemma for a remaining active/backend branch that directly feeds
the displayed equality.  Do not reprove slot `0`, the prepared-side backend
normal form, active wrapper/cast removal, all-slot fold expansion, or bridge
equivalence.

Existing declarations to reuse:

- `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3`
- `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3`
- `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3`
- `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`
- `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`
- `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`
- `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`

The worker must not change oracle contracts, theorem hypotheses, normalizers,
gate labels, the paper circuit, or any `proved` flag.  Required gate:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```
