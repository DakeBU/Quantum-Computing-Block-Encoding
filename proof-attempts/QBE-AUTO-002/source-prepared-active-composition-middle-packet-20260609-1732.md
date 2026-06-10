# QBE-AUTO-002 Middle Packet: Source-Prepared Active Composition

Created: 2026-06-09 17:32 JST
Role: middle formalization maintainer
Mode: faithfulPaper

This packet supersedes
`proof-attempts/QBE-AUTO-002/uncast-eval-entry-support-partition-middle-packet-20260609-170218.md`
for lower scheduling.  The 17:18 lower proof-DAG and 17:19 Lean obstruction
showed that the H-free uncast `evalWith` route is not source closure unless it
matches or eliminates the weighted backend slots and the projection amplitude
factor.  The source-faithful next target is therefore the prepared
active/prepared composition field.

## Source-Contract Audit

| Source anchor | Paper fragment | Lean-facing object | Dependency class | Status |
|---|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}$ prepares the sparse register with all-slot amplitude $1/\sqrt{\kappa}$. | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract | contract-only; do not prove Shukla--Vedula here |
| `main.tex:1098-1109`, Theorem `theorem: 1 term robin` | one-term Robin block-encoding with normalizer $\mathcal{N}_D\mathcal{N}_f\kappa$. | root theorem route through source-prepared projection | GHL-internal theorem target | open |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | displayed gamma3 boundary branch uses sparse slot `2` in the focused instance. | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | GHL-internal plus QBE-local branch map | compiled selected-slot bridge |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | full circuit has both $H_W^{(\kappa)}$ sides, explicit `U_indic^dagger`, pre-SWAP `O_DT^BS`, and post-SWAP `(O_D^BS)^dagger`. | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | GHL-internal transcript | compiled guard |
| `main.tex:2027-2035`, Definition `def:block-encoding` | clean projection compares the active signal block with the encoded operator. | source-prepared active/prepared evaluation field | QBE-local semantic bridge | active leaf |

The blocked ingredient is classified as a QBE-local finite
`CircuitMatrixSemantics` composition field.  It is not a new external oracle,
state-preparation, LCU, block-projection, or classical theorem dependency.

## Definitions

Fix `H : Matrix 8 8 Coeff` and `env : String -> Rat`.

The source-prepared active field is:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
```

The smaller uncast form is:

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
```

The generic entry target is:

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

The stronger raw field is:

```lean
(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H)
  .rawEntryPreparedSandwichStatement
```

Existing route bridges:

| Bridge | Role |
|---|---|
| `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastActivePreparedCompositeEval_n3 H env` | reduces the theorem-facing source-prepared active field to the uncast active/prepared comparison |
| `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3 H env hUniform` | evaluates the prepared clean entry to the backend fold under the existing `H_W` clean-column contract |
| `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_activePreparedEval_n3 H env hUniform` | aligns the evaluated backend fold with the source-prepared active field; it proves neither side |
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_backendExpansion_n3 H hUniform` | shows the generic prepared-entry target is equivalent to the backend-expansion leaf under `hUniform` |
| `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_backendExpansion_n3 H hUniform` | shows the raw prepared-sandwich field is also equivalent to backend expansion under `hUniform` |
| `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesExpandedSlotZeroFold_n3 H env` | compiled obstruction: the H-free uncast route exposes a weighted slot-`0` fold and leaves slots `1` through `6` visible |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `fig4_transcript_guard` | source-facing Fig. 4 order with both `H_W` sides and explicit `U_indic^dagger` | source transcript; U-indic self-inverse bridge | middle/reviewer | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | conversion window | `python3 tools/qbe.py check` | compiled |
| `source_prepared_backend_eval` | prepared clean entry evaluates to backend fold under `hUniform` | all-slot `H_W` contract; prepared singleton semantics | lower/middle | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3 H env hUniform` | status notes | same gates | compiled conditional |
| `h_free_uncast_obstruction` | evaluated backend-fold target exposes H-free `[0,0]` entry against weighted expanded backend fold | absence of `H_W` gates; backend fold expansion | lower 2 | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesExpandedSlotZeroFold_n3 H env` | `eval-entry-expanded-slot0-fold-20260609-lower2.md` | same gates | compiled obstruction; not closure |
| `active_prepared_composition_field` | active signal-zero entry equals prepared singleton clean entry | source-prepared target; active/prepared circuit field | lower 2/refiner | `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env` | this packet | `python3 tools/qbe.py check`; then `lake build`; `lake build Tests` | preferred active leaf |
| `uncast_active_prepared_leaf` | uncast `evalGateMatrices` entry equals prepared singleton clean entry | active/prepared equivalence | lower 2/refiner | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env` | this packet | same gates | preferred smaller leaf |
| `generic_entry_leaf` | generic prepared-entry target equality | prepared entry target matrix statement | lower 2/refiner | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | this packet | same gates | accepted smaller leaf |
| `raw_prepared_sandwich_leaf` | raw signal-zero entry equals prepared sandwich fold | raw field/backend equivalence; `hUniform` only for downstream backend equivalence | lower 2/refiner | `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` | prepared-sandwich packets | same gates | accepted stronger leaf |
| `backend_expansion_leaf` | raw backend-expansion statement | branch contribution target; projection summation target | lower 2/refiner | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` | backend bridge note | same gates | equivalent recovery leaf; open |
| `uncast_eval_entry_leaf` | H-free active entry equals weighted backend fold after `evalWith` | support partition plus weighted slot matching | none unless explicitly reassigned | proposed `oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3 env` | 17:18 route check | none | diagnostic/blocked as source closure |
| `column0_slot0_guard` | prevent column-`0` slot-`0` diagnostics from proving displayed gamma3 slot `2` | two-path diagnostic; selected branch map | none | `oneTermRobinGamma3BoundarySevenGateColumn0UsesSlot0_notGamma3Slot2_n3` | guard notes | none | retired diagnostic |
| `raw_coeff_constructor_route` | raw symbolic constructor equality for H-free fold | old raw scripts and diagnostic sorries | none | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | diagnostic/backlog | none | stale; do not assign |

## Lower Packets

| Lower profile | Packet |
|---|---|
| lower 1 proof architect | Write only a narrow addendum if needed.  Map the source slot-`2` branch, the prepared singleton clean entry, and the equivalences among `activePreparedCompositeEvalStatement`, `entryEqualityStatement`, `rawEntryPreparedSandwichStatement`, and `backendExpansionStatement`.  Do not restart broad source search. |
| lower 2 Lean worker | Edit only `QuantumBlockEncoding/RobinMatrix.lean`.  Prove one ready leaf: preferably `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`, `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`, or the stronger raw prepared-sandwich field.  Do not use `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` or the H-free uncast backend equality as source closure. |

If lower 2 can only prove another H-free expanded-fold guard, record it as an
obstruction note and keep the source-prepared active leaf open.

No oracle, `H_W`, `R_y`, LCU, block-projection, normalized-equality,
product-to-coefficient, circuit-unitarity, block-correctness, final-extraction,
ODBS, ODTS, or `O_f` semantic flag is promoted by this packet.
