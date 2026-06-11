# QBE-AUTO-002 Middle Packet: Active Side After Prepared-Side Feeder

Created: 2026-06-10 13:42 JST

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

Define `FullUnitaryFold` as:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

The dependent fold remains conditional.  The compiled theorem
`oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`
sends `HUniform` and a future proof of `SourcePreparedEntry` to
`FullUnitaryFold`.

## Accepted Feeders

The prepared side is now normalized by compiled Lean declarations:

| Feeder | Statement role | Status |
|---|---|---|
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_preparedCleanEntry_n3` | identifies `SourcePreparedEntry` with the prepared sparse-matrix clean-entry equality | compiled; proof-DAG alignment only |
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3` | under `HUniform`, rewrites the target's cached prepared entry as `blockExtractionBranchContributionSum oneTermRobinGamma3BoundaryBackendBranchContribution_n3` | compiled prepared-side normal form |

These feeders do not prove the active signal-zero entry equality.  They do not
formalize $H_W^{(\kappa)}$, prove `FullUnitaryFold`, prove the backend
expansion endpoint, or close the Guseynov--Huang--Liu one-term theorem.

## Source Translation

| Source anchor | Proof step | Dependency class | Lean interface |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | The $H_W^{(\kappa)}$ clean-column behavior supplies the prepared sparse-register averaging contract. | external-cited-contract | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | The backend fold keeps all seven sparse slots; the displayed $\gamma_3$ branch is one selected contribution, not a license to delete other slots. | GHL-internal plus QBE-local matrix semantics | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`; `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | The theorem-facing transcript has both $H_W^{(\kappa)}$ sides and explicit `U_indic^dagger`; the active seven-gate backend is only the inner H-free component. | GHL-internal transcript | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge`; `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` |
| `main.tex:2027-2035`, Definition `def:block-encoding` | The clean signal-zero entry must match the prepared clean entry before the prepared backend fold can close the projection route. | QBE-local finite projection/backend bridge | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry` |

## Proof-DAG Frontier

| Node | Dependencies | Status | Owner | Next action |
|---|---|---|---|---|
| `fig4_transcript_guard` | Fig. `1 term ROBIN`; indicator self-inverse bridge | compiled | middle/reviewer | Reuse the theorem-facing gate list and dagger bridge. |
| `prepared_entry_backend_fold_feeder` | `HUniform`; prepared clean-entry lemmas | compiled feeder; retired | none | Reuse `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`; do not reprove it. |
| `active_prepared_entry_feeder` | active signal-zero entry; prepared entry normal form; `HUniform` | preferred active leaf | lower 2 | Prove `SourcePreparedEntry`, or prove one strictly smaller active-side finite-composition lemma that feeds it directly. |
| `unitary_fold_leaf` | `active_prepared_entry_feeder`; prepared-side backend normal form | open dependent root | lower 2/refiner | Close through `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` only after `SourcePreparedEntry` is proved. |
| `backend_expansion_leaf` | `unitary_fold_leaf`; compiled equivalence | open equivalent endpoint | lower 2/refiner | Use `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3` only after the fold is available. |
| `retired_routes` | branch-sum wrapper, source-prepared clean alias, H-free eval, column-`0` diagnostics, raw `Coeff`, all-slot/feeders, and bridge rediscovery | stale | none | Do not assign as lower work. |

## Lower 1 Addendum Packet

Lower 1 should add only a short postscript if the theorem name changes.  The
postscript should say:

- The prepared side is already normalized by
  `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`.
- The remaining mathematical content is active side: the signal-zero active
  entry must equal the source-prepared clean entry.
- `HUniform` remains an external cited contract and no $H_W^{(\kappa)}$ flag is
  promoted.
- `SourcePreparedEntry` and `FullUnitaryFold` remain open.

## Lower 2 Lean Packet

Allowed write scope: `QuantumBlockEncoding/RobinMatrix.lean` only.

Preferred theorem:

```lean
theorem <new_name>
    (H : Matrix 8 8 Coeff)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement := by
  -- active finite-composition proof
```

Strictly smaller acceptable theorem:

```lean
theorem <new_name>
    (H : Matrix 8 8 Coeff)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
      (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry := by
  -- active side proof against the cached prepared entry
```

Existing declarations to reuse:

- `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_matrixStatement_n3`
- `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_preparedCleanEntry_n3`
- `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`
- `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`
- `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_unitaryEntryFold_n3`
- `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`
- `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`

The worker must not change oracle contracts, theorem hypotheses, normalizers,
gate labels, the paper circuit, or any `proved` flag.  Required gate:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```
