# QBE-AUTO-002 Middle Packet: Full-Unitary Fold Frontier

Created: 2026-06-10 11:44 JST

Scope: lower-agent packet for the next Lean worker.  Edit only
`QuantumBlockEncoding/RobinMatrix.lean`.

## Source Fragment

The active source fragment is still the one-term Robin theorem route from
Guseynov--Huang--Liu 2025: Eq. `ROBIN clarified`, Fig. `1 term ROBIN`, and
Definition `def:block-encoding`.  The sparse preparation $H_W^{(\kappa)}$
remains an external all-slot clean-column contract.  This packet does not
formalize Shukla--Vedula, sparse-access, amplitude-oracle, LCU, or QSVT
primitives.

## Active Lean Target

The compiled bridge

```lean
oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_iff_unitaryEntryFold_n3
```

turns the previous branch-sum wrapper into the raw full-unitary fold target:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

The theorem
`oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` has this statement
but still contains `sorry`; it is diagnostic memory, not an accepted proof.

## Allowed Smaller Leaf

A smaller lower target is allowed only if it directly feeds the full-unitary
fold.  Acceptable examples are named support, vanish, or cancellation lemmas
for the seven-slot backend fold.  Slots `1`, `3`, `4`, `5`, and `6` currently
have no compiled vanish/cancellation theorem.  Slot `2` is already identified
by `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`; slot `0`
has diagnostic expansion facts only.

## Dependencies To Reuse

| Role | Lean declaration | Status |
|---|---|---|
| theorem-facing transcript guard | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` | compiled |
| indicator dagger role | `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | compiled |
| signal block to unitary-entry bridge | `oneTermRobinGamma3BoundaryProjectionSummationObstruction_signalEntry_eq_unitary_n3` | compiled |
| branch-sum to unitary-fold bridge | `oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_iff_unitaryEntryFold_n3` | compiled |
| backend expansion to unitary-fold bridge | `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3` | compiled |
| selected slot fact | `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | compiled |
| backend contribution family | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3` | typed |

## Retired Targets

Do not spend lower proof time on:

- the branch-sum wrapper alone;
- conditional feeders such as
  `oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_of_activePreparedEntryTarget_n3`;
- the source-prepared clean-entry alias;
- rediscovering compiled equivalence bridges;
- raw `Coeff` constructor equality as a source-closure route;
- column-`0` slot-only diagnostics.

## Acceptance Gate

After any Lean edit, run:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```

The packet succeeds only if the Lean target or a strictly smaller named feeder
lemma compiles and the conversion window plus proof-obligation ledger remain
synchronized.
