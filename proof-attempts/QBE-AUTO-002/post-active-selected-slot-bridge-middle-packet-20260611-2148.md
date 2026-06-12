# Middle Packet: Post-Active-Selected-Slot Bridge Frontier

Task: `QBE-AUTO-002`
Run: `20260611-214323-QBE-AUTO-002-cycle01`
Mode: faithful paper reproduction

## Source-Facing Contract

The active source fragment remains Guseynov--Huang--Liu 2025, Theorem
`1 term robin`, Eq. `ROBIN clarified`, Fig. `1 term ROBIN`, the
$H_W^{(\kappa)}$ sparse-register preparation contract, and the block-encoding
projection definition. The theorem-facing transcript guard still keeps
`U_indic^dagger` and both $H_W^{(\kappa)}$ sides visible.

This packet does not promote ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$, $R_y$, LCU,
block-projection, normalizer, block-correctness, final-extraction, oracle, or
external primitive status.

## Current Lean Evidence

The evaluated backend fold has already collapsed to selected slot `2` through:

```lean
oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3
```

The route-packaging bridge is also compiled:

```lean
oneTermRobinGamma3BoundaryActiveSelectedSlotEvalComparison_iff_evaluatedBackendFold_n3
```

This bridge proves only an equivalence between the active selected-slot
comparison and the evaluated backend fold. It does not prove the active
comparison, `SourcePreparedEntry`, `FullUnitaryFold`, backend expansion, or the
one-term Robin theorem.

## Active Leaf

Definition first: `ActiveSelectedSlotEvalComparison` is

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3) =
Coeff.evalWith env
  oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution
```

Lower 2 should prove this theorem directly, or prove one strict active-side
feeder that directly implies it.

## Controlled Fallback

If the direct H-free active comparison collapses through
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` and the
diagnostic column-zero route, classify the attempt as `shape_or_register_gap`.
The next packet should then target the prepared-sandwich semantics gap for the
source-facing $H_W^{(\kappa)\dagger} U H_W^{(\kappa)}$ entry, using the existing
interfaces:

```lean
oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3
oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3
oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_evaluatedBackendFold_n3
```

Do not use the diagnostic zero route to claim theorem closure.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Gate | Status |
|---|---|---|---|---|---|---|
| `active_selected_slot_eval_comparison_leaf` | evaluated seven-gate `[0,0]` entry equals selected slot `2` | active finite product semantics; selected slot contribution; compiled backend-fold-to-selected-slot feeder; compiled equivalence bridge | lower 2 | target `ActiveSelectedSlotEvalComparison` | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active |
| `prepared_sandwich_gap_leaf` | source-prepared $H_W^\dagger U H_W$ entry supplies the prepared projection route | prepared-sandwich interfaces; all-slot `HUniform` contract; source Fig. `1 term ROBIN` gate order | lower 2 only after shape/register classification | `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3 H env` or a smaller feeder | same gate | controlled fallback |
| `active_selected_to_fold_bridge` | route active selected-slot comparison to evaluated backend fold | backend-fold-to-slot-`2` theorem; uncast active entry evaluation bridge | none | `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalComparison_iff_evaluatedBackendFold_n3 env` | already gated | proved; retired |
| `active_uncast_to_prepared_entry_leaf` | raw uncast `[0,0]` entry equals cached prepared entry | active selected-slot comparison plus prepared backend-fold route | lower 2 after active evaluated leaf | target `ActiveUncastToPreparedEntry` | same gate | open dependent |
| `source_prepared_entry_leaf` | source-prepared entry equality | active leaf plus compiled wrapper/cast bridge | later lower 2 | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | same gate | open dependent |
| `unitary_fold_leaf` | full signal-zero unitary entry equals backend branch fold | `SourcePreparedEntry`; `HUniform`; prepared backend-fold normal form | later lower 2 | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry = blockExtractionBranchContributionSum oneTermRobinGamma3BoundaryBackendBranchContribution_n3` | same gate | open dependent root |

## Retired Routes

Do not assign direct branch-sum wrapper work, source-prepared clean-entry alias
work, H-free `evalWith` rediscovery, raw `Coeff` constructor equality,
compiled bridge rediscovery, all-slot expansion rediscovery, selected-slot
backend-fold rediscovery, the active-selected-to-fold bridge, or any slot `0`,
`1`, `3`, `4`, `5`, or `6` vanish/support/diagonal-factor target.

## Verifier Feedback To Log

If lower 2 proves the active comparison, use:

```text
leaf=active_selected_slot_eval_comparison_leaf
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
block_entry_ok=partial
ancilla_cleanup_ok=not_applicable
normalizer_ok=true
closed_theorem_ok=true
error_class=none
next_route=recover evaluated backend fold through oneTermRobinGamma3BoundaryActiveSelectedSlotEvalComparison_iff_evaluatedBackendFold_n3, then continue toward SourcePreparedEntry
```

If the direct proof instead exposes the H-free active/prepared mismatch, log:

```text
leaf=active_selected_slot_eval_comparison_leaf
source_correspondence_ok=false_for_direct_H_free_active_to_prepared_slot2_comparison
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=partial
block_entry_ok=false_open_prepared_sandwich_projection_field
ancilla_cleanup_ok=not_promoted
normalizer_ok=unchanged
closed_theorem_ok=false
error_class=shape_or_register_gap
next_route=target the prepared-sandwich semantics gap for H_W^dagger * U * H_W
```
