# Post-Remaining-Slots Support Middle Packet

Task: `QBE-AUTO-002`

Run: `20260610-150313-QBE-AUTO-002-cycle01`

Role: middle formalization maintainer

## Fixed Target

The preferred mathematical leaf remains `ActiveUncastToPreparedEntry`:

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3 =
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
```

The preferred smaller Lean leaf is a full evaluated slot-`1` branch
vanish/cancellation theorem, tentatively:

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3
```

A still smaller acceptable theorem is the diagonal-factor version at full
index `16`, but only if it directly feeds the slot-`1` backend contribution
vanish theorem.

## Reuse

| Ingredient | Lean declaration | Status |
|---|---|---|
| slot `0` evaluated vanish | `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3` | compiled support; retired |
| slot `1` support mismatch | `oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3` | compiled support; not full vanish |
| slots `3` through `6` support mismatch | `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3` | compiled support; retired |
| selected slot `2` branch | `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | compiled selected contribution |
| active wrapper recovery | `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3` | compiled bridge; retired |
| fold recovery | `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` | compiled bridge under `HUniform`; not closure |

## Lower 2 Scope

Allowed write scope: `QuantumBlockEncoding/RobinMatrix.lean` only.

Do not change oracle contracts, theorem hypotheses, normalizers, gate labels,
or the paper circuit.  Do not promote ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$,
$R_y$, LCU, block-projection, normalized-equality, product-to-coefficient,
circuit-unitarity, block-correctness, final-extraction, oracle, or external
primitive flags.

## Retired Targets

Do not reassign the branch-sum wrapper, source-prepared clean-entry alias,
H-free `evalWith` route, raw `Coeff` constructor route, prepared-side backend
fold, active wrapper/cast removal, all-slot fold expansion, slot-`0` vanish
support, slot-`1` support-only theorem, or slots `3` through `6` support-only
theorem.

## Gate

After any Lean edit, run:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```
