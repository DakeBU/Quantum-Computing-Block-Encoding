# Middle Packet: Post-Slot-4 Remaining-Slots Evaluated Frontier

Task: `QBE-AUTO-002`  
Run: `20260611-195209-QBE-AUTO-002-cycle01`  
Mode: faithful paper reproduction

This packet fixes the next lower work after the compiled theorem
`oneTermRobinGamma3BoundaryBackendBranchContribution_slotFourEval_zero_n3 env`.
It does not change the paper theorem, circuit, oracle contracts, normalizer,
gate labels, or hypotheses.

## Source Contract

| Source anchor | Paper fragment | Lean-facing object | Dependency class |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}$ supplies the all-slot sparse-register clean-column contract. | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | The $\gamma_3$ boundary contribution is an all-slot sum; slot `2` is selected and nonselected slots must vanish or cancel. | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3` | GHL-internal plus QBE-local matrix semantics |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | The active seven-gate backend component remains the same; theorem-facing $H_W^{(\kappa)}$ sides and `U_indic^\dagger` are transcript guards. | `oneTermRobinGamma3BoundarySevenGateMatrix_n3`; `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` | GHL-internal transcript plus QBE-local matrix semantics |
| `main.tex:2027-2035`, Definition `def:block-encoding` | The clean signal block is still recovered only after `SourcePreparedEntry` and `FullUnitaryFold`. | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry` | QBE-local projection/backend bridge |

## Current Proof-DAG

| Node | Interface | Status | Next route |
|---|---|---|---|
| `active_uncast_to_prepared_entry_leaf` | Active seven-gate `[0,0]` entry equals the cached prepared entry. | preferred active mathematical leaf | Prove directly only if the prepared cached-entry route is usable without changing contracts. |
| `slot4_full_vanish_leaf` | Slot `4` backend branch contribution evaluates to zero. | proved; retired | Reuse as a proof pattern only. |
| `remaining_slots_support_mismatch` | Slots `5` and `6` have support-only dagger-after-SWAP information from the slots `3..6` support theorem. | proved support; retired | Do not assign support-only work as closure. |
| `slot5_full_vanish_leaf` | Slot `5` backend branch contribution evaluates to zero or cancels. | next preferred smaller leaf | Prove `oneTermRobinGamma3BoundaryBackendBranchContribution_slotFiveEval_zero_n3 env`, or a strict full-index `80` feeder. |
| `source_prepared_entry_leaf` | Active/prepared entry equality. | open dependent target | Recover only after `ActiveUncastToPreparedEntry` through the compiled wrapper/cast bridge. |
| `unitary_fold_leaf` | Full signal-zero unitary entry equals the seven-slot backend branch fold. | open dependent root | Recover only through `SourcePreparedEntry` plus the explicit `HUniform` contract. |

## Lower 1 Packet

Append only Section 21.8 to
`proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`.

Required content:

1. Retire slot `4` and the full-index `64` route.
2. Classify slots `5` and `6` support as support-only, not branch vanish.
3. Name the active smaller theorem
   `oneTermRobinGamma3BoundaryBackendBranchContribution_slotFiveEval_zero_n3 env`
   and the strict full-index `80` diagonal-factor feeder if needed.
4. Keep all external primitives contract-only.

## Lower 2 Packet

Allowed write scope: `QuantumBlockEncoding/RobinMatrix.lean` only.

Primary target:

```lean
theorem oneTermRobinGamma3BoundaryBackendBranchContribution_slotFiveEval_zero_n3
    (env : String -> Rat) :
    Coeff.evalWith env
      (oneTermRobinGamma3BoundaryBackendBranchContribution_n3
        ⟨5, by native_decide⟩) = 0
```

Acceptable strict feeder:

```lean
private theorem oneTermRobinGamma3BoundarySevenGateSlotFiveEval_zero_n3
    (env : String -> Rat) :
    Coeff.evalWith env
      (oneTermRobinGamma3BoundarySevenGateMatrix_n3 row80 row80) = 0
```

The feeder must directly feed the public slot-`5` theorem. Do not add
hypotheses, change the theorem target, change the normalizer, change gate
labels, or promote oracle/$H_W^{(\kappa)}$/$R_y$/LCU/block-projection flags.

## Verification Contract

Any Lean edit must finish with:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```

Typed verifier feedback for a lower attempt should include:

| Field | Value |
|---|---|
| `leaf` | `slot5_full_vanish_leaf` or a strict full-index `80` feeder |
| `source_correspondence_ok` | `true` if the route keeps Eq. `ROBIN clarified` all-slot semantics |
| `lean_parse_ok` | `true` only after Lean parses |
| `lean_build_ok` | `true` only after the gate passes |
| `finite_matrix_ok` | `true`, `partial`, or the concrete obstruction |
| `block_entry_ok` | `partial` until `ActiveUncastToPreparedEntry` closes |
| `ancilla_cleanup_ok` | `not_applicable` for this local finite branch feeder |
| `normalizer_ok` | `true` if unchanged |
| `closed_theorem_ok` | `true` only if the named Lean theorem closes |
| `error_class` | `none`, `lean_tactic_gap`, `symbolic_bridge_gap`, or `invalid_route` |
| `next_route` | Slot `6` vanish/cancellation or use slots `0/1/3/4/5` toward `ActiveUncastToPreparedEntry` |
