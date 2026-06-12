# Middle Packet: Generated Frontier Repair After Post-Feeder Sync

Task: `QBE-AUTO-002`

Run: `20260611-224727-QBE-AUTO-002-cycle01`

Mode: faithful paper reproduction.

## Fixed Objective

This middle pass does not change Lean. It repairs generated frontier artifacts
so the active leaf is `active_prepared_composition_leaf`, not the older
prepared-sandwich gap wrapper.

Definition first: `ActivePreparedCompositionLeaf` is the evaluated equality

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3) =
Coeff.evalWith env
  (oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3)
```

The compiled feeder
`oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_preparedSparseCleanEntry_n3 H env`
exposes this equality but does not prove it.

## Source Contract

| Source fragment | Lean interface | Dependency class | Status |
|---|---|---|---|
| Theorem 1 and Fig. 1-term Robin circuit | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | GHL-internal transcript plus QBE-local bridge | compiled guard |
| Sparse-register preparation | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract | contract-only |
| Gamma3 prepared clean coefficient | `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H`; `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3 H` | QBE-local matrix semantics | prepared side exposed |
| Block-extraction target | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env` | QBE-local projection bridge | dependent root open |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Status |
|---|---|---|---|---|---|---|
| `active_prepared_composition_leaf` | active seven-gate `[0,0]` evaluated entry equals the prepared sparse clean-clean entry | strict prepared-sparse feeder; prepared sparse clean-entry theorem; source-prepared circuit field record | lower 2 | RHS of `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_preparedSparseCleanEntry_n3 H env`; equivalent targets `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3 H env`, `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`, or `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | lower-1 Section 21.14 and this packet | active Lean leaf |
| `prepared_sandwich_gap_leaf` | broader prepared-sandwich semantics gap | `active_prepared_composition_leaf` | none until active leaf is tried | `oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3 H`; `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3 H env` | previous packet | reduced; not the current lower target |
| `source_prepared_entry_leaf` | theorem-facing active/prepared entry equality | `active_prepared_composition_leaf`; wrapper/cast bridges | lower 2 after active leaf | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`; source-prepared projection bridges | proof-obligation ledger | open dependent |
| `unitary_fold_leaf` | full signal-zero unitary entry equals the backend fold | `source_prepared_entry_leaf`; clean-column contract; prepared side backend bridge | later lower 2 | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry = blockExtractionBranchContributionSum oneTermRobinGamma3BoundaryBackendBranchContribution_n3` | proof blueprint | open dependent root |

## Lower Packets

Lower 1 should reuse Section 21.14 of
`proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`
and add only a narrow postscript if the theorem name changes.

Lower 2 may edit only `QuantumBlockEncoding/RobinMatrix.lean`. The accepted
target is exactly `active_prepared_composition_leaf`, one equivalent target
listed above, or one smaller theorem that directly feeds that equality.

Retired lower targets remain retired: the strict prepared-sparse feeder,
prepared clean-entry aliases, H-free active-selected diagnostics, backend slot
vanish/support work, raw `Coeff` constructor equalities, branch-sum wrappers,
and compiled bridge rediscovery.

Expected gate after any Lean edit:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```

No oracle, $H_W^{(\kappa)}$, $R_y$, LCU, projection, block-correctness,
final-extraction, normalizer, or external primitive flag is promoted by this
middle repair.
