# QBE-AUTO-002 Middle Packet: Uncast Eval Entry Support Partition

Created: 2026-06-09 17:07 JST
Role: middle formalization maintainer
Mode: faithfulPaper

## Source Contract

The source anchors remain:

| Source anchor | Lean-facing object | Dependency class | Status |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract | contract-only; not a lower target |
| `main.tex:1098-1109`, Theorem `theorem: 1 term robin` | root one-term Robin theorem route | GHL-internal theorem target | open |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | gamma3 boundary slot `2` backend branch | GHL-internal branch plus QBE-local index bridge | selected branch compiled |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | theorem-facing transcript with both `H_W` sides, explicit `U_indic^dagger`, pre-SWAP `O_DT^BS`, and post-SWAP `(O_D^BS)^dagger` | GHL-internal transcript | compiled transcript guard |
| `main.tex:2027-2035`, Definition `def:block-encoding` | clean signal-block projection | QBE-local semantic bridge | current evalWith leaf |

No cited external theorem is newly required by this packet.  The remaining
proof work is QBE-local finite matrix/projection bookkeeping.

## Definitions

Fix `env : String -> Rat`.

Define the active evaluated entry by

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

Define the evaluated backend fold by

```lean
Coeff.evalWith env
  (blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

The preferred active theorem is

```lean
oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3 env
```

with the statement that the active evaluated entry equals the evaluated
backend fold.

## Current DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `fig4_theorem_transcript_guard` | paper-facing Fig. 4 order with both `H_W` sides and explicit `U_indic^dagger` | source transcript; U-indic self-inverse bridge | middle/reviewer | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | conversion window | `python3 tools/qbe.py check` | compiled |
| `active_uncast_reduction` | reduce the named evaluated fold to an uncast `evalGateMatrices` entry equality | block-entry cast removal | lower/middle | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env` | lower-1 packet | `python3 tools/qbe.py check` | compiled |
| `backend_fold_expansion` | expose the seven backend branch summands | backend branch family | lower/middle | `oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3` | lower-1 packet | `python3 tools/qbe.py check` | compiled |
| `backend_expansion_to_evaluated_fold` | route a future backend-expansion proof into the evaluated fold | backend-expansion/unitary-fold equivalence | lower 2 | `oneTermRobinGamma3BoundaryEvaluatedBackendFold_of_backendExpansion_n3 env hexpansion` | lower2 bridge note | `python3 tools/qbe.py check` | compiled conditional; does not prove `hexpansion` |
| `active_eval_support_partition` | list surviving evaluated multiplication paths and prove every non-surviving path contributes zero | `Matrix.evalWith_mul_unique_path`; `Matrix.evalWith_mul_two_path`; branch-index lemmas | lower 2/refiner | new local support lemma in `QuantumBlockEncoding/RobinMatrix.lean` if needed | this packet | `python3 tools/qbe.py check` | next implementation subgoal |
| `uncast_eval_entry_leaf` | prove the active evaluated entry equals the backend fold | `active_uncast_reduction`; `backend_fold_expansion`; `active_eval_support_partition` | lower 2/refiner | proposed `oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3 env` | this packet | `python3 tools/qbe.py check`; then `lake build`; `lake build Tests` | preferred active Lean leaf |
| `backend_expansion_equivalent_leaf` | prove the stronger raw backend-expansion statement | branch contribution target | lower 2/refiner | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` | lower2 bridge note | same gates | allowed stronger leaf; open |
| `raw_prepared_sandwich_equivalent_leaf` | prove the source-prepared raw sandwich field under the clean-column contract | `H_W` contract; raw field/backend equivalence | lower 2/refiner | `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` | prepared-sandwich packet | same gates | allowed stronger leaf; open |
| `column0_slot0_guard` | block use of column-`0` slot-`0` diagnostics as source slot-`2` closure | two-path diagnostic; branch map | none | `oneTermRobinGamma3BoundarySevenGateColumn0UsesSlot0_notGamma3Slot2_n3` | guard notes | none | retired diagnostic |
| `raw_coeff_constructor_route` | raw symbolic `Coeff` constructor equality | old raw scripts | none | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | diagnostic/backlog | none | stale; do not assign |

## Lower Packets

| Lower profile | Packet |
|---|---|
| lower 1 proof architect | No broad source restart.  If needed, refine only the `active_eval_support_partition` row: name the surviving intermediate rows of the evaluated seven-gate product and classify each backend slot as matched or zero. |
| lower 2 Lean worker | Edit only `QuantumBlockEncoding/RobinMatrix.lean`.  First prove a support-partition lemma if the full theorem is too large; then prove `oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3 env`.  A stronger proof of `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` is accepted only if it immediately feeds `oneTermRobinGamma3BoundaryEvaluatedBackendFold_of_backendExpansion_n3`. |

The worker must stop and record contract drift if the proof reduces only to
`oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` or the slot-`0`
diagnostic branch.  That route does not match Eq. `ROBIN clarified` slot `2`.

No oracle, `H_W`, `R_y`, LCU, block-projection, normalized-equality,
product-to-coefficient, circuit-unitarity, block-correctness, final-extraction,
ODBS, ODTS, or `O_f` semantic flag is promoted by this packet.
