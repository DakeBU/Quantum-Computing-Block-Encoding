# Middle Packet: Post-Selected-Slot Active-Uncast Frontier

Task: `QBE-AUTO-002`  
Run: `20260611-211850-QBE-AUTO-002-cycle01`  
Mode: faithful paper reproduction

## Source-Facing Contract

The active source fragment is still Guseynov--Huang--Liu 2025, Theorem
`1 term robin`, Eq. `ROBIN clarified`, Fig. `1 term ROBIN`, the
$H_W^{(\kappa)}$ sparse-register preparation contract, and the block-encoding
projection definition. The theorem-facing transcript guard remains compiled
with explicit $U_{\mathrm{indic}}^\dagger$ and both $H_W^{(\kappa)}$ sides.

This packet does not promote ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$, $R_y$, LCU,
block-projection, normalizer, block-correctness, final-extraction, oracle, or
external primitive status.

## Current Lean Evidence

The full evaluated backend branch vanish feeders are compiled for slots `0`,
`1`, `3`, `4`, `5`, and `6`. The evaluated backend fold now collapses to the
selected slot-`2` contribution:

```lean
oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3
```

This theorem is a feeder only. It does not prove the active/prepared equality,
the source-prepared route, the full unitary fold, backend expansion, or the
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

This is now the preferred local theorem. A smaller theorem is acceptable only
if it directly feeds this equality, such as an active-side support or
cancellation lemma for the `[0,0]` entry.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Gate | Status |
|---|---|---|---|---|---|---|
| `active_selected_slot_eval_comparison_leaf` | evaluated seven-gate `[0,0]` entry equals selected slot `2` | active finite product semantics; selected slot contribution; compiled backend-fold-to-selected-slot feeder | lower 2 | target `ActiveSelectedSlotEvalComparison` | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active |
| `active_uncast_to_prepared_entry_leaf` | raw uncast `[0,0]` entry equals cached prepared entry | active selected-slot comparison plus prepared backend-fold route or a raw fold route | lower 2 after active evaluated leaf | target `ActiveUncastToPreparedEntry` | same gate | open dependent |
| `source_prepared_entry_leaf` | source-prepared entry equality | active leaf plus compiled wrapper/cast bridge | later lower 2 | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`; `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3` | same gate | open dependent |
| `unitary_fold_leaf` | full signal-zero unitary entry equals backend branch fold | `SourcePreparedEntry`; `HUniform`; prepared backend-fold normal form | later lower 2 | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry = blockExtractionBranchContributionSum oneTermRobinGamma3BoundaryBackendBranchContribution_n3` | same gate | open dependent root |
| `backend_fold_eval_to_slot2_leaf` | evaluated backend fold equals selected slot `2` | slot vanish facts `0`, `1`, `3`, `4`, `5`, `6`; selected slot identity | none | `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3 env` | already gated | proved; retired |

## Lower-Agent Split

Lower 1 should reuse
`proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`.
Append only a Section 21.11 postscript if the active-side selected-slot theorem
name changes. The postscript must treat slots `0`, `1`, `3`, `4`, `5`, `6`,
and `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3`
as compiled and retired.

Lower 2 may edit only `QuantumBlockEncoding/RobinMatrix.lean`. Lower 2 should
prove `ActiveSelectedSlotEvalComparison` or one strict active-side feeder that
directly proves it. Lower 2 must not change oracle contracts, theorem
hypotheses, normalizers, gate labels, or the paper circuit.

## Retired Routes

Do not assign direct branch-sum wrapper work, source-prepared clean-entry alias
work, H-free `evalWith` rediscovery, raw `Coeff` constructor equality,
compiled bridge rediscovery, all-slot expansion rediscovery, selected-slot
backend-fold rediscovery, or any slot `0`, `1`, `3`, `4`, `5`, or `6`
vanish/support/diagonal-factor target.

## Verifier Feedback To Log

If a lower worker proves the active evaluated comparison, use:

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
next_route=recover ActiveUncastToPreparedEntry or SourcePreparedEntry through the compiled active/prepared bridges
```

If a smaller active-side feeder is proved, set `closed_theorem_ok=true` only
for that feeder and keep `block_entry_ok=partial`, with the next route naming
`ActiveSelectedSlotEvalComparison`.
