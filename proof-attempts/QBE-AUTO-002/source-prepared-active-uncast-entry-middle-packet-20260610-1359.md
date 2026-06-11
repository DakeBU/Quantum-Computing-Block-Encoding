# QBE-AUTO-002 Middle Packet: Active Uncast Entry After Wrapper Bridge

Created: 2026-06-10 13:59 JST

Scope: middle proof-DAG and lower-agent packet only.  This packet changes no
Lean source and promotes no semantic flag.

## Definitions Before Claims

Define `HUniform` as:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

Define `SourcePreparedEntry` as:

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

Define `ActiveUncastToPreparedEntry` as:

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3 =
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
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
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3` | rewrites the cached prepared entry to the backend branch fold under `HUniform` | compiled; prepared-side only; retired |
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3` | rewrites `SourcePreparedEntry` to `ActiveUncastToPreparedEntry` | compiled wrapper/cast bridge; retired |
| `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` | sends `HUniform` and `SourcePreparedEntry` to `FullUnitaryFold` | compiled conditional bridge; retired |

The remaining mathematical content is the active-side finite product entry.
The prepared side, wrapper removal, and conditional fold bridge should be
reused, not reproved.

## Source Translation

| Source anchor | Proof step | Dependency class | Lean interface |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}$ supplies the clean-column contract used after the active side is related to the prepared entry. | external-cited-contract | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | The backend fold keeps all seven sparse slots; lower must not collapse the fold to the displayed boundary branch only. | GHL-internal plus QBE-local matrix semantics | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`; `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | The theorem-facing circuit has both $H_W^{(\kappa)}$ sides and explicit `U_indic^dagger`; the active uncast product is the inner seven-gate entry. | GHL-internal transcript plus local guard | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge`; `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` |
| `main.tex:2027-2035`, Definition `def:block-encoding` | The signal-zero active entry must equal the source-prepared clean entry before the block-projection route can close. | QBE-local finite projection/backend bridge | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry` |

## Proof-DAG Frontier

| Node | Dependencies | Status | Owner | Next action |
|---|---|---|---|---|
| `fig4_transcript_guard` | Fig. `1 term ROBIN`; indicator self-inverse bridge | compiled | middle/reviewer | Reuse the theorem-facing gate list and dagger bridge. |
| `prepared_entry_backend_fold_feeder` | `HUniform`; prepared clean-entry lemmas | compiled feeder; retired | none | Reuse `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`; do not reprove it. |
| `active_wrapper_cast_feeder` | active signal-zero entry; finite cast removal | compiled feeder; retired | none | Reuse `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3`; do not reprove it. |
| `active_uncast_to_prepared_entry_leaf` | uncast seven-gate `[0,0]` entry; cached prepared entry | preferred active leaf | lower 2 | Prove `ActiveUncastToPreparedEntry`, or one support, vanish, or cancellation lemma feeding it directly. |
| `source_prepared_entry_leaf` | `active_uncast_to_prepared_entry_leaf`; wrapper bridge | open dependent target | lower 2/refiner | Recover `SourcePreparedEntry` through `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3`. |
| `unitary_fold_leaf` | `SourcePreparedEntry`; `HUniform`; prepared-side backend normal form | open dependent root | lower 2/refiner | Use `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` only after `SourcePreparedEntry` is proved. |
| `backend_expansion_leaf` | `unitary_fold_leaf`; compiled equivalence | open equivalent endpoint | lower 2/refiner | Use the compiled unitary-fold equivalence only after the fold is available. |
| `retired_routes` | branch-sum wrapper, source-prepared clean alias, H-free eval, column-`0` diagnostics, raw `Coeff`, all-slot feeders, and bridge rediscovery | stale | none | Do not assign as lower work. |

## Lower 1 Addendum Packet

Lower 1 should add only a short postscript to
`proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`.
The postscript should:

- state that the prepared side and wrapper/cast bridge are compiled and retired;
- classify `ActiveUncastToPreparedEntry` as the remaining QBE-local finite
  product entry leaf;
- say which seven-gate product terms are expected to survive, vanish, or cancel;
- keep `HUniform` as an external cited contract only;
- state that `SourcePreparedEntry`, `FullUnitaryFold`, and the one-term theorem
  remain open.

## Lower 2 Lean Packet

Allowed write scope: `QuantumBlockEncoding/RobinMatrix.lean` only.

Preferred theorem:

```lean
theorem <new_name>
    (H : Matrix 8 8 Coeff) :
    (evalGateMatrices
      (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
      oneTermRobinGamma3BoundaryPrefixRow0_n3
      oneTermRobinGamma3BoundaryPrefixRow0_n3 =
        (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry := by
  -- active finite product proof
```

Strictly smaller acceptable theorem:

```lean
theorem <new_name>
    (H : Matrix 8 8 Coeff) :
    -- one support, vanish, or cancellation fact that feeds the equality above
    True := by
  trivial
```

Replace the placeholder in the smaller theorem with a real finite matrix-entry
statement.  Do not add hypotheses to the preferred equality unless they are
already present in the active target.

Existing declarations to reuse:

- `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3`
- `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`
- `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`
- `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_unitaryEntryFold_n3`
- `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`
- `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`
- `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`

The worker must not change oracle contracts, theorem hypotheses, normalizers,
gate labels, the paper circuit, or any `proved` flag.  Required gate:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```
