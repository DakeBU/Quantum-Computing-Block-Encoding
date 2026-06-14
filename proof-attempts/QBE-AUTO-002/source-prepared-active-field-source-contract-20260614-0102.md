# 2026-06-14 Middle Source Contract: Source-Prepared Active Field

Task: `QBE-AUTO-002`  
Run: `20260614-004100-QBE-AUTO-002-cycle01`  
Mode: `faithfulPaper`  
Leaf: `source_prepared_active_field_contract`

## Verdict

The selected-slot obstruction leaf is closed:

```lean
oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3
```

Do not reassign that witness, the H-free evaluated backend fold, or the direct
row-`0` to selected slot-`2` feeder.  The current source-correspondence object
is the source-prepared clean projection from the full Fig. `fig:1 term ROBIN`
circuit.

## Source Anchors

| Anchor | Paper object translated | Lean-facing object |
|---|---|---|
| GHL2025 Eq. `arbitrary sparcity` | $H_W^{(\kappa)}\ket{0}$ prepares the sparse register uniformly. | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` |
| GHL2025 Eq. `angles for Ry` | boundary rows use controlled `R_y` rotations. | `GHL2025.RyBoundary` cited-results row; no flag promoted |
| GHL2025 Theorem `theorem: 1 term robin` | one-term Robin block-encoding claim. | theorem-facing QBE target remains open |
| GHL2025 Eq. `ROBIN clarified` | gamma3 boundary branch contains the selected contribution. | `oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3` |
| GHL2025 Fig. `fig:1 term ROBIN` and Fig. 4 visual audit | full prepared circuit with both `H_W` sides and cleanup. | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env` |
| GHL2025 Definition `def:block-encoding` | clean projection after the theorem-facing circuit. | `activeToPreparedSingletonEvalStatement` |

## Lean Contract

For fixed `H : Matrix 8 8 Coeff` and `env : String -> Rat`, the source-facing
field is:

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
```

The existing equivalent forms are:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

The useful compiled feeders are:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastActivePreparedCompositeEval_n3
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3
oneTermRobinGamma3BoundaryActivePreparedCompositeEval_of_uncastPreparedSparseCleanEntry_n3
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_backendEval_n3
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_selectedSlotContributionEval_zero_n3
```

These are route wiring or guard material.  They do not prove the
source-prepared active field.

## Ownership Split

| Object | Owner class | Status |
|---|---|---|
| Theorem `theorem: 1 term robin`, Eq. `ROBIN clarified`, and Fig. `fig:1 term ROBIN` transcript | GHL-owned | source object; theorem open |
| `H_W^(kappa)`, `O_D^{BS}`, `O_f`, boundary `R_y`, LCU/block composition, unitarity, normalizers | external contract or cited primitive | contract-only / obligation |
| `SourcePreparedProjectionTarget`, active/prepared equivalences, selected-slot witness, selected-zero guard | QBE-local semantic glue | compiled wiring plus one active guard |

No new cited-results row is needed for this packet.  Use the existing
`research-wiki/cited-results/GHL2025.md` rows and do not mark any of them
`formalized`.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Local gate | Status |
|---|---|---|---|---|---|---|
| `selected_slot_nonzero_counterexample` | `SelectedSlot(allOne) = 1` | selected product evaluator; projection factor transcript | none | `oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3` | already gated | proved; stale |
| `hfree_evaluated_backend_fold` | all-env H-free active/backend equality | selected-zero normal form; nonzero witness | none | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` | none | retired; `finite_matrix_counterexample` |
| `direct_hfree_selected_slot_feeder` | active row `0` equals selected slot `2` | finite path/register map | none | proposed `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3` | none | retired; `shape_or_register_gap` |
| `source_prepared_active_field_contract` | source-prepared clean projection object and dependencies | source anchors above; Fig. 4 audit | lower1/lower3 | `activeToPreparedSingletonEvalStatement` | no Lean edit | active contract audit |
| `source_prepared_active_field_forces_selected_zero_guard` | `Uniform(H)` and active field imply `SelectedSlot(env) = 0` | active/prepared-to-fold bridge; selected-zero normal form | lower2 | proposed theorem below | full gate | active guard |
| `corrected_source_prepared_target` | restated theorem-facing target after the guard/audit | contract audit and lower3 feedback | middle/later | none yet | none | blocked |

## Lower-Facing Contract

Lower1 writes no Lean.  It should map the six source anchors above to the
Lean fields and explain why the current active/prepared field cannot be used as
arbitrary-`H` theorem closure.

Lower3 writes typed feedback only.  It should check that the full prepared
Fig. 4 route remains distinct from the H-free seven-gate backend, that
`hUniform` is downstream-only, and that the all-one selected-slot witness stays
a finite counterexample to the retired H-free fold.

Lower2 may edit only `QuantumBlockEncoding/RobinMatrix.lean` and prove exactly
this guard:

```lean
theorem oneTermRobinGamma3BoundarySourcePreparedActiveEval_forces_selectedSlotContribution_zero_n3
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H)
    (hActive :
      oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env) :
    Coeff.evalWith env
      oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution = 0
```

Suggested proof route:

1. Use
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3
   H env hUniform hActive`.
2. Apply
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_selectedSlotContributionEval_zero_n3
   env`.

This guard only records that the current source-prepared field, with the
paper sparse-preparation contract, still routes to selected-slot vanishing.  It
does not close the source-prepared field or the paper theorem.

## Rejections

Reject any lower route that:

- proves `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` as an
  all-environment H-free root;
- revives `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3`;
- treats `oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3`
  as still open;
- adds assumptions to the paper theorem or changes gate order;
- promotes oracle, `H_W`, boundary `R_y`, LCU, unitarity, normalizer,
  block-projection, block-correctness, or final-extraction flags;
- uses raw `Coeff` constructor equality or sorry-guarded diagnostics as
  theorem closure.

## Gate

If lower2 edits Lean, it must run:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```

This middle packet changes proof-control memory only.
