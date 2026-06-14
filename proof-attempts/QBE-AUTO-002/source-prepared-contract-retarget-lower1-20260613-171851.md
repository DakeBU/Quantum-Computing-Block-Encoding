# 2026-06-13 Lower1 Proof Design: Source-Prepared Contract Retarget

Task: `QBE-AUTO-002`  
Run: `20260613-170242-QBE-AUTO-002-cycle01`  
Role: lower natural-language proof architect  
Mode: `faithfulPaper`

## Source Fragment

The source-paper fragment being translated is the prepared Robin one-term
block-encoding route:

| Source anchor | Translated content |
|---|---|
| GHL2025 Eq. `arbitrary sparcity` | The sparse register is prepared by $H_W^{(\kappa)}\ket{0} = \kappa^{-1/2}\sum_{s=0}^{\kappa-1}\ket{s}$. |
| GHL2025 Eq. `angles for Ry` | Boundary branches use controlled $R_y$ angles $\theta_j^s = \arccos(D_j^{(s)}/\mathcal{N}_D)$ for $j < K_1$ or $K_2 < j < 2^n$. |
| GHL2025 Eq. `ROBIN clarified` | The displayed $\gamma_3$ boundary branch carries $f(x_i)(D)_i^{(s)}\sigma^{(s)}/(\mathcal{N}_D\mathcal{N}_f\kappa)$ on the clean branch, summed over sparse slots and boundary indices. |
| GHL2025 Fig. `fig:1 term ROBIN` | The full source circuit has both $H_W^{(\kappa)}$ side gates, the backend branch gates, $O_f$, SWAP, sparse-access cleanup, and pure-ancilla cleanup. |
| GHL2025 Definition `def:block-encoding` | The theorem-facing claim is a clean projection of the prepared circuit output, not a standalone H-free backend entry. |

The Fig. 4 visual audit confirms that the seven-gate backend component is not
the full Fig. `fig:1 term ROBIN` transcript.  Lean records that split through:

```lean
GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList
GHL2025.oneTermRobinActiveBackendCircuit_gateList
oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3
```

## Definitions

Let `ActiveEval(env)` be the evaluated H-free active row-`0` entry:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders
      (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

Let `PreparedSparseClean(H, env)` be the evaluated prepared sparse-register
clean entry:

```lean
Coeff.evalWith env
  (oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3)
```

Let `PreparedSingletonClean(H, env)` be the evaluated singleton prepared
semantics clean entry:

```lean
Coeff.evalWith env
  ((oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3)
```

Let `SourcePreparedField(H, env)` be:

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
```

Let `Uniform(H)` be:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

## Local Proof Design

The paper-backed prepared projection path is the following statement:

```text
Uniform(H)
  -> PreparedSingletonClean(H, env)
     = evalWith backend branch fold
  -> clean projection target for the source-prepared Fig. 4 route
```

The natural-language proof is:

1. Eq. `arbitrary sparcity` supplies the clean-column contract for the sparse
   preparation matrix.  Lean names this contract as `Uniform(H)`.  It remains
   external and explicit.
2. The prepared sparse matrix
   `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H` is the local
   finite matrix for the $H_W^{(\kappa)\dagger} U H_W^{(\kappa)}$ sandwich on
   the sparse register.  Its clean-clean entry is the prepared sandwich fold by
   `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`.
3. Under `Uniform(H)`, each prepared sandwich summand specializes to the
   backend branch contribution by
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_eq_backend_n3`.
   Folding over the seven sparse slots gives
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`.
4. The singleton prepared semantics evaluates to the prepared sparse matrix at
   the clean-clean entry by
   `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3`.
5. Combining the previous two facts gives the compiled prepared-side bridge:

```lean
oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3
  H env hUniform
```

This is the correct theorem-facing prepared-entry path.  It does not prove
`ActiveEval(env) = PreparedSparseClean(H, env)`.

The current active-field wrapper has a remaining mismatch.  Lean exposes it as:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3
  H env
```

which reduces `SourcePreparedField(H, env)` to:

```lean
ActiveEval(env) = PreparedSparseClean(H, env)
```

That equality is not a branch-correct source theorem yet.  The left side is the
H-free seven-gate row-`0` entry.  Lean already proves:

```lean
oneTermRobinGamma3BoundaryActiveEvalColumn0_zero_n3 env
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3 H env
oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3
```

So a direct proof of `SourcePreparedField(H, env)` would have to explain why the
prepared sparse clean entry is zero for the same branch, or else replace the
left side by the source-prepared clean projection entry.  The paper fragment
supports the latter route, not a revival of the H-free selected-slot feeder.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Status | Owner | Lean declaration | Next action |
|---|---|---|---|---|---|---|
| `source_sparse_uniform_contract` | sparse clean-column amplitude for every paper sparse slot | Eq. `arbitrary sparcity`; Shukla--Vedula contract | contract-only | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | keep explicit as `hUniform` |
| `fig4_transcript_split` | distinguish full Fig. 4 from the H-free seven-gate backend | Fig. `fig:1 term ROBIN`; visual audit | proved transcript guard | none | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinActiveBackendCircuit_gateList` | reuse |
| `strict_hfree_feeder_retirement` | reject `ActiveEval(env) = selectedSlotContribution(env)` | active index `0`; selected slot `2`; selected full index `32` | retired; `shape_or_register_gap` | none | `oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3` | do not assign |
| `active_eval_zero_diagnostic` | classify H-free `ActiveEval(env)` as zero on column `0` | column-`0` bridge; tail-kill support | proved diagnostic-only | none | `oneTermRobinGamma3BoundaryActiveEvalColumn0_zero_n3` | use only as rejection evidence |
| `prepared_singleton_to_backend` | show prepared singleton clean entry evaluates to backend fold under `Uniform(H)` | prepared sparse clean entry; prepared sandwich fold | proved conditional bridge | none | `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`; `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3` | reuse |
| `source_prepared_active_field_unwrapped` | expose current source-prepared field as `ActiveEval = PreparedSparseClean` | active/prepared field wrappers | proved obstruction map | none | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3`; `oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_obstruction_n3` | do not treat as closure |
| `source_prepared_projection_restatement` | replace theorem-facing target by prepared projection clean entry before comparing to backend fold | source anchors; prepared singleton bridge | active lower1/middle node | middle | no new Lean target yet | next active leaf |
| `evaluated_backend_fold_recovery` | recover H-free evaluated backend fold from active/prepared equality | `SourcePreparedField`; `Uniform(H)` | blocked internal | later lower2 | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3` | blocked until branch-correct restatement |

Next active leaf for the Lean worker: none of the old H-free feeder leaves is
ready.  The next implementation step should be assigned only after middle
restates the theorem-facing source-prepared projection around
`preparedProjectionEntry` rather than `activeToPreparedSingletonEvalStatement`.

## Intermediate Lean Lemmas

Reuse these declarations in dependency order:

1. `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` and
   `GHL2025.oneTermRobinActiveBackendCircuit_gateList`.
2. `oneTermRobinGamma3BoundarySparseCleanIndex_n3` and
   `oneTermRobinGamma3BoundarySparseSlotIndex_n3`.
3. `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3`.
4. `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3`.
5. `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`.
6. `oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_eq_backend_n3`.
7. `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`.
8. `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3`.
9. `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`.
10. `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`.
11. `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3`, only as an obstruction map.
12. `oneTermRobinGamma3BoundaryActiveEvalColumn0_zero_n3`, only as diagnostic rejection evidence.
13. `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3`, only as the compiled mismatch witness.
14. `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`, only after a branch-correct active/prepared composition theorem is supplied.

If lower2 is asked for a Lean theorem before middle restates the target, the
least risky response is to mark the requested equality blocked rather than to
prove raw symbolic equality or add `hUniform` to an H-free feeder.

## Failure Analysis

The strict H-free selected-slot feeder is mathematically wrong for the source
fragment.  The active H-free entry uses full-basis index `0`; the selected
gamma3 sparse contribution uses sparse slot `2` and full index `32`.
`oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3` records this split.

The current source-prepared field is closer to the paper, but its left side
still exposes the same H-free seven-gate entry.  Lean records that both
`H_W^(kappa)` side gates are absent from the active gate list, and it also
proves `ActiveEval(env) = 0`.  Therefore the equality
`ActiveEval(env) = PreparedSparseClean(H, env)` should not be assigned as a
paper theorem unless middle supplies a source-backed finite composition theorem
for the full prepared circuit or changes the target to consume
`preparedProjectionEntry`.

The valid prepared-side theorem is already compiled:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3
  H env hUniform
```

The remaining source-translation gap is how the theorem-facing block-encoding
claim should consume that prepared projection entry without routing through the
retired H-free row-`0` equality.

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `source_prepared_contract_retarget` |
| `source_correspondence_ok` | `true_for_prepared_projection_entry`; `false_for_activeToPreparedSingleton_as_closure` |
| `lean_parse_ok` | `not_applicable_no_Lean_edit` |
| `lean_build_ok` | `not_applicable_no_Lean_edit` |
| `finite_matrix_ok` | `active_col0_zero_checked; prepared_composition_not_checked` |
| `block_entry_ok` | `false` |
| `ancilla_cleanup_ok` | `not_promoted` |
| `normalizer_ok` | `not_promoted` |
| `closed_theorem_ok` | `false` |
| `closed_theorem_scope` | `proof-design only; one-term Robin theorem remains open` |
| `error_class` | `shape_or_register_gap` |
| `next_route` | Retarget the theorem-facing source-prepared projection to `preparedProjectionEntry`; do not revive `ActiveEval = selectedSlotContribution` or use `ActiveEval = PreparedSparseClean` as closure. |

## Handoff

Lower1 proof design is complete.  The prepared singleton clean-entry route is
source-backed and already has a compiled conditional backend bridge under
explicit `Uniform(H)`.  The current `SourcePreparedField(H, env)` wrapper still
exposes the H-free row-`0` active entry, so it should be treated as a
proof-obligation mismatch, not as the next theorem-closure leaf.  Middle should
restate the source-prepared projection target around `preparedProjectionEntry`
before assigning another lower2 proof.
