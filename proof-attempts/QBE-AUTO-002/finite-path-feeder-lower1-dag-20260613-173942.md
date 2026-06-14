# 2026-06-13 Lower1 DAG: Finite Feeder Conflict And Prepared Projection Route

Task: `QBE-AUTO-002`  
Run: `20260613-172255-QBE-AUTO-002-cycle01`  
Role: lower natural-language proof architect  
Mode: `faithfulPaper`

## Scope Resolution

The task-file EOF override points to
`proof-attempts/QBE-AUTO-002/chatgpt-pro-finite-path-feeder-deployment-20260613.md`
and asks lower1 to map the finite-path feeder route.  The current run dialogue
at `runs/20260613-172255-QBE-AUTO-002-cycle01/dialogue.md`, the conversion
window, and the proof-obligation ledger are newer than that task-file edit.
They retire the strict H-free feeder and move the active proof route to the
prepared projection entry.  This packet records both facts so lower2 does not
spend a proof attempt on a stale shape.

## Source Fragment

The local path advertised for the TeX archive,
`outer_papers/quantum/GHL2025/main.tex`, is not present in this checkout.  I
therefore use the public GHL2025 anchors as recorded in bundled proof notes and
the Fig. 4 visual audit:

| Source anchor | Source-paper content being translated | Local source-facing evidence |
|---|---|---|
| Eq. `arbitrary sparcity` / `main.tex:948-955` | $H_W^{(\kappa)}$ prepares the sparse register as a uniform superposition over the $\kappa$ sparse slots. | `paper-notes/GHL2025_RobinOneTerm.tex` and `research-wiki/cited-results/GHL2025.md` record this as `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`. |
| Eq. `ROBIN clarified` / `main.tex:1111-1119` | The $\gamma_3$ clean branch carries the coefficient $f(x_i)D_i^{(s)}/(N_DN_f\kappa)$, summed over sparse slots. | `paper-notes/GHL2025_RobinOneTerm.tex` records the gamma3 coefficient and the remaining projection/product bridge. |
| Fig. `fig:1 term ROBIN` / `main.tex:1122-1164` | The full circuit includes left and right $H_W^{(\kappa)}$ preparation/cleanup around the seven-gate backend component. | `paper-notes/GHL2025/markdown/fig4-visual-audit.zh.md` separates the full prepared route from the H-free seven-gate backend. |
| Definition `def:block-encoding` / `main.tex:2027-2035` | The theorem-facing object is a clean projection entry of the prepared circuit. | `paper-notes/GHL2025_RobinOneTerm.tex` records the finite composition contract and keeps block flags false. |

The translated local theorem should therefore use the prepared clean projection
entry first, then the backend fold under the explicit `Uniform(H)` contract.

## Definitions

Let `ActiveEval(env)` be:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders
      (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

Let `SelectedContribution(env)` be:

```lean
Coeff.evalWith env
  oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution
```

Let `PreparedProjectionEntry(H, env)` be:

```lean
Coeff.evalWith env
  (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry
```

Let `ActiveSignalEntry(env)` be:

```lean
Coeff.evalWith env
  oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry
```

Let `Uniform(H)` be:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

## ChatGPT Pro Name Map

| Illustrative name | Existing Lean declaration or status | Source role |
|---|---|---|
| `p0` | `oneTermRobinGamma3BoundaryPrefixRow0_n3` | active H-free input/output row for the current seven-gate diagnostic entry |
| `p_selected` | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3 oneTermRobinGamma3BoundaryBranchContributionFocusedSlot` | selected backend sparse branch full index |
| `G_UIndic` | gate slot inside `GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)` and full transcript guard `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` | indicator branch gate in Fig. 4 |
| `TailAfterRy` | no single ready alias; existing evidence is the two-path column-0 tail kill in `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` and `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3` | warns that `R_y`/`O_f` must be treated as two-path-with-tail-kill, not unique-column, on the active column-0 diagnostic route |
| `FocusedPathEval` | no source-faithful H-free normal form is ready for the preferred strict feeder as written | should be replaced by `PreparedProjectionEntry(H, env)` for the theorem-facing route, or by a new source-backed selected active entry if middle changes the active index |
| backend selected contribution | `oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution`; `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`; `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3` | selected $\gamma_3$ backend contribution from Eq. `ROBIN clarified` |
| strict feeder | proposed `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 env` | retired in the newer run dialogue because it compares active full index `0` with selected full index `32` |

## Natural-Language Proof Of The Prepared Projection Route

The active local route theorem already present in Lean is:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedProjectionEntryEval_n3
```

It states that for every `H`, `env`, and explicit `hUniform : Uniform(H)`, an
entry equality

```lean
ActiveSignalEntry(env) = PreparedProjectionEntry(H, env)
```

implies `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`.

Proof in words:

1. The hypothesis `hEntry` uses the theorem-facing
   `preparedProjectionEntry` field of
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env`.
2. Unfolding that target identifies `preparedProjectionEntry` with the clean
   entry of
   `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H` at
   `oneTermRobinGamma3BoundarySparseCleanIndex_n3`.
3. This turns `hEntry` into
   `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env`.
4. The compiled bridge
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3
   H env hUniform` consumes that active/prepared composite statement.
5. That bridge uses
   `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3
   H env hUniform`, which is exactly where Eq. `arbitrary sparcity` enters via
   `Uniform(H)`.

This proof does not prove the active/prepared equality.  It only proves that
the equality is the right theorem-facing input to the evaluated backend fold.
The exact route theorem is already compiled, so it is now a stale lower2
target.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_sparse_uniform_contract` | clean-column behavior of $H_W^{(\kappa)}$ over all sparse slots | Eq. `arbitrary sparcity`; Shukla--Vedula contract | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results ledger | project gate | contract-only; keep explicit |
| `fig4_transcript_split` | distinguish full prepared Fig. 4 from H-free seven-gate backend | Fig. `fig:1 term ROBIN`; visual audit | none | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinActiveBackendCircuit_gateList` | Fig. 4 audit | project gate | compiled transcript guard |
| `strict_hfree_feeder` | `ActiveEval(env) = SelectedContribution(env)` | active row `0`; selected sparse slot `2`; selected full index `32` | none | proposed `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3` | deployment packet plus newer run dialogue | project gate | stale; `shape_or_register_gap` |
| `selected_backend_fold` | backend branch fold evaluates to selected contribution | branch fold and selected slot contribution | none | `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3 env` | deployment packet | project gate | proved |
| `prepared_projection_backend_bridge` | `PreparedProjectionEntry(H, env)` evaluates to backend fold under `Uniform(H)` | prepared singleton clean entry; prepared sandwich fold | none | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3 H env hUniform` | source-prepared packet | project gate | proved conditional bridge |
| `prepared_projection_restatement_leaf` | `ActiveSignalEntry(env) = PreparedProjectionEntry(H, env)` plus `Uniform(H)` implies evaluated backend fold | prepared bridge; active/prepared wrapper | none | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedProjectionEntryEval_n3 H env hUniform hEntry` | newest middle packet | project gate | proved; stale as lower2 target |
| `active_prepared_entry_field` | prove active signal entry equals prepared clean entry | source-prepared target; prepared matrix interface | lower2 after lower3 check | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` or `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env` | this packet | project gate | next active leaf |
| `active_prepared_uncast_eval` | evaluated uncast active `[0,0]` entry equals prepared singleton clean entry | active/prepared field equivalences | lower2 | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env` | this packet | project gate | recommended smaller eval-level leaf |

Next active leaf for a Lean worker:

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
```

or the equivalent cached field:

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

The already compiled route lemma
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedProjectionEntryEval_n3`
should not be reassigned.

## Intermediate Lean Lemmas To Reuse

Use these in dependency order:

1. `oneTermRobinGamma3BoundaryPrefixRow0_n3`.
2. `oneTermRobinGamma3BoundaryBranchContributionFocusedSlot`.
3. `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`.
4. `oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3`.
5. `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3`.
6. `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3`.
7. `oneTermRobinGamma3BoundaryActiveEvalColumn0_zero_n3`, only as diagnostic rejection evidence.
8. `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`.
9. `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3`.
10. `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3`.
11. `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`.
12. `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`.
13. `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`.
14. `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`.
15. `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_iff_uncast_n3`.
16. `oneTermRobinGamma3BoundaryActivePreparedCompositeEval_iff_sparseEval_n3`.
17. `oneTermRobinGamma3BoundaryActivePreparedCompositeEval_of_entryTarget_n3`.
18. `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`.
19. `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedProjectionEntryEval_n3`.

The Lean worker should not use
`oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` or
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` as theorem
closure because those are raw diagnostic routes.

## Failure Analysis

The strict H-free feeder from the deployment packet is not a ready faithful
paper theorem in the current run.  Lean records:

```lean
oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3
```

The left side of the proposed feeder is the active full-basis entry at index
`0`.  The right side is the selected backend sparse slot `2`, whose selected
full index is `32`.  The current diagnostic column-0 branch is also known to
evaluate to zero through:

```lean
oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3
oneTermRobinGamma3BoundaryActiveEvalColumn0_zero_n3
```

Therefore a proof of the strict feeder as written would either prove a
surprising zero result for the selected contribution or would have to replace
the left-hand active row by a different source-backed selected active entry.
That replacement is not in the current Lean interface and should be assigned
by middle before lower2 tries it.

The source-faithful route is the prepared projection route.  It keeps both
`H_W^(kappa)` sides visible, uses `Uniform(H)` only at the prepared backend
bridge, and leaves oracle, `H_W`, `R_y`, LCU, block-projection, unitarity,
normalizer, and final block-correctness flags unpromoted.

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `finite_path_feeder_resolved_to_active_prepared_entry` |
| `source_correspondence_ok` | `false_for_strict_hfree_feeder; true_for_preparedProjectionEntry_route` |
| `lean_parse_ok` | `not_applicable_no_Lean_edit` |
| `lean_build_ok` | `pending_gate_at_write_time` |
| `finite_matrix_ok` | `active_col0_zero_checked; prepared_active_entry_pending` |
| `block_entry_ok` | `false` |
| `closed_theorem_ok` | `false_for_one_term_Robin; route_wrapper_already_compiled` |
| `error_class` | `shape_or_register_gap` |
| `next_route` | `lower2 proves one active/prepared entry leaf, preferably the uncast eval statement; do not revive the H-free row-0 selected-slot feeder` |

## Handoff

Lower1 resolved the finite-path feeder packet against the newer run dialogue.
The ChatGPT-style names map to existing declarations, but the strict feeder
as written is stale because it compares active index `0` with selected full
index `32`.  The prepared projection restatement route is already compiled;
the next useful lower2 target is the actual active/prepared entry field or its
uncast eval form.
