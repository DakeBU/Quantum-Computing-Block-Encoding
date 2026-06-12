# Middle Packet: Post-Slot-Six Active-Uncast Frontier

Task: `QBE-AUTO-002`  
Run: `20260611-203233-QBE-AUTO-002-cycle01`  
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
`1`, `3`, `4`, `5`, and `6`. The selected slot is slot `2`. The latest new
retired feeder is:

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_slotSixEval_zero_n3
```

The slot-`6` full-index `96` diagonal-factor route is now stale as a lower
target. Treat lower-1 Section 21.9 as the proof map for the compiled slot-`6`
leaf, not as the active next leaf.

## Active Leaf

Definition first: `ActiveUncastToPreparedEntry` is

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3 =
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
```

This is now the preferred local theorem. A smaller theorem is acceptable only
if it directly feeds this equality, such as a selected-slot-`2` evaluated entry
comparison or an active-side cancellation lemma using the compiled vanish
facts for slots `0`, `1`, `3`, `4`, `5`, and `6`.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Gate | Status |
|---|---|---|---|---|---|---|
| `active_uncast_to_prepared_entry_leaf` | uncast seven-gate `[0,0]` entry equals cached prepared entry | slot vanish facts `0`, `1`, `3`, `4`, `5`, `6`; selected slot `2`; cached prepared entry | lower 2 | target `ActiveUncastToPreparedEntry` | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active |
| `selected_slot2_feeder` | selected backend branch contributes the cached prepared entry part needed by the active leaf | selected branch declarations and prepared-entry backend normal form | lower 2 if the full active leaf is too large | new local lemma only if it feeds `ActiveUncastToPreparedEntry` directly | same gate | optional strict feeder |
| `source_prepared_entry_leaf` | source-prepared entry equality | active leaf plus compiled wrapper/cast bridge | later lower 2 | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`; `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3` | same gate | open dependent |
| `unitary_fold_leaf` | full signal-zero unitary entry equals backend branch fold | `SourcePreparedEntry`; `HUniform`; prepared backend-fold normal form | later lower 2 | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry = blockExtractionBranchContributionSum oneTermRobinGamma3BoundaryBackendBranchContribution_n3` | same gate | open dependent root |
| `slot6_full_vanish_leaf` | evaluated slot-`6` backend branch contribution is zero | full-index `96` route | none | `oneTermRobinGamma3BoundaryBackendBranchContribution_slotSixEval_zero_n3 env` | already gated | proved; retired |

## Lower-Agent Split

Lower 1 should append only a Section 21.10 postscript to
`proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`.
The postscript should retire slots `0`, `1`, `3`, `4`, `5`, and `6`, identify
slot `2` as the selected contribution, and map the active equality to existing
Lean declarations or one strict new feeder.

Lower 2 may edit only `QuantumBlockEncoding/RobinMatrix.lean`. Lower 2 should
prove `ActiveUncastToPreparedEntry` or one strict selected-slot/active-side
feeder that directly feeds it. Lower 2 must not change oracle contracts,
theorem hypotheses, normalizers, gate labels, or the paper circuit.

## Retired Routes

Do not assign direct branch-sum wrapper work, source-prepared clean-entry alias
work, H-free `evalWith` rediscovery, raw `Coeff` constructor equality,
compiled bridge rediscovery, all-slot expansion rediscovery, or any slot
`0`, `1`, `3`, `4`, `5`, or `6` vanish/support/diagonal-factor target.

## Verifier Feedback To Log

If a lower worker proves the active leaf, use:

```text
leaf=active_uncast_to_prepared_entry_leaf
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
block_entry_ok=true
ancilla_cleanup_ok=not_applicable
normalizer_ok=true
closed_theorem_ok=true
error_class=none
next_route=recover SourcePreparedEntry through oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3
```

If a smaller feeder is proved, set `closed_theorem_ok=true` only for the feeder
and keep `block_entry_ok=partial`, with the next route naming
`ActiveUncastToPreparedEntry`.
