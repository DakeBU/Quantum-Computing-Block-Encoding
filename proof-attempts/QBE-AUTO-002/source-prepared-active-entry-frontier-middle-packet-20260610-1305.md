# QBE-AUTO-002 Middle Packet: Source-Prepared Active/Prepared Entry Frontier

Created: 2026-06-10 13:05 JST

Scope: middle proof-DAG and lower-agent packet only.  This packet changes no
Lean source and promotes no semantic flag.

## Freshness Note

The expanded all-slot feeders
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3`,
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_injective_n3`, and
`oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` are compiled
support.  They are retired as lower targets.  The next preferred proof leaf is
the source-prepared active/prepared entry equality under the existing
$H_W^{(\kappa)}$ clean-column contract.

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

The compiled bridge
`oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`
sends `HUniform` and `SourcePreparedEntry` to `FullUnitaryFold`.  The bridge is
conditional and does not prove the external sparse-preparation primitive.

Current-run compiled feeder:

```lean
oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_preparedCleanEntry_n3
```

This theorem states that `SourcePreparedEntry` is equivalent to the clean-entry
equality for `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H`.
Reuse it to target the prepared clean entry directly.  It is not a proof of
`SourcePreparedEntry` and it promotes no theorem-facing flag.

## Source Translation

| Source anchor | Proof step | Dependency class | Lean interface |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | Both $H_W^{(\kappa)}$ sides give the clean-column sparse-register averaging contract. | external-cited-contract | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | The clean $\gamma_3$ boundary coefficient is represented inside the seven-slot backend contribution family. | GHL-internal plus QBE-local matrix semantics | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`; `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | The theorem-facing route has both $H_W^{(\kappa)}$ sides, explicit `U_indic^dagger`, and the inner active seven-gate backend. | GHL-internal transcript | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` |
| `main.tex:2027-2035`, Definition `def:block-encoding` | The clean signal-zero entry is the quantity that must match the prepared clean-entry route and then the backend fold. | QBE-local finite projection/backend bridge | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry` |

## Proof-DAG Frontier

| Node | Dependencies | Status | Owner | Next action |
|---|---|---|---|---|
| `fig4_transcript_guard` | Fig. `1 term ROBIN`; indicator self-inverse bridge | compiled | middle/reviewer | Reuse the theorem-facing gate list and dagger bridge. |
| `prepared_clean_backend_bridge` | `HUniform`; prepared sparse matrix clean-entry lemmas | compiled conditional | lower/middle | Reuse `oneTermRobinGamma3BoundarySourcePreparedCleanEntryEval_eq_backendFold_n3`; do not reassign as lower target. |
| `prepared_clean_entry_equivalence` | prepared sparse matrix interface; active/prepared entry target | compiled feeder | lower/middle | Reuse `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_preparedCleanEntry_n3`; do not reassign as lower target. |
| `active_prepared_entry_feeder` | active signal-zero entry; prepared sparse matrix clean entry; `HUniform` | preferred active leaf | lower 2 | Prove `SourcePreparedEntry` under `HUniform`, or a smaller prepared-circuit semantics lemma feeding it. |
| `unitary_fold_leaf` | `active_prepared_entry_feeder`; backend fold bridge | open dependent root | lower 2/refiner | Close through `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` after `SourcePreparedEntry` is proved. |
| `backend_expansion_leaf` | `unitary_fold_leaf`; compiled equivalence | open equivalent endpoint | lower 2/refiner | Use `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3` only after the fold is available. |
| `expanded_uncast_recovery_leaf` | all-slot backend fold expansion; active `[0,0]` entry | recovery only | lower 2 only if reassigned | Use `oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3` only if it returns through the prepared-entry or fold bridges. |
| `raw_coeff_constructor_route` | symbolic `Coeff` constructor equality | diagnostic `sorry` | none | Do not assign as source closure. |

## Lower 1 Addendum Packet

Lower 1 should append a narrow addendum to
`proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`.
The addendum should record:

- `SourcePreparedEntry` is the preferred active leaf.
- `HUniform` is an external cited contract and remains explicit.
- `FullUnitaryFold` is the dependent root, not a proved theorem.
- The expanded all-slot feeders are compiled and retired.
- No sparse slot may be deleted without a named Lean theorem.

## Lower 2 Lean Packet

Allowed write scope: `QuantumBlockEncoding/RobinMatrix.lean` only.

Preferred theorem shape:

```lean
theorem <new_name>
    (H : Matrix 8 8 Coeff)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement := by
  -- prepared-circuit semantics proof
```

Strictly smaller acceptable leaf:

```lean
theorem <new_name>
    (H : Matrix 8 8 Coeff)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    (oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3 H).activeEntryToPreparedEntryStatement := by
  -- equivalent prepared interface proof
```

Existing declarations to reuse:

- `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_interfaceStatement_n3`
- `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_matrixStatement_n3`
- `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_unitaryEntryFold_n3`
- `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`
- `oneTermRobinGamma3BoundaryBackendExpansionStatement_of_activePreparedEntryTarget_n3`
- `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_entryTarget_n3`
- `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastActivePreparedCompositeEval_n3`

The worker must not change oracle contracts, theorem hypotheses, normalizers,
gate labels, the paper circuit, or any `proved` flag.  The required gate is:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```
