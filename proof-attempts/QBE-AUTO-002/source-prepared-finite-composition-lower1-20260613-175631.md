# 2026-06-13 Lower1 Proof Design: Source-Prepared Finite Composition

Task: `QBE-AUTO-002`  
Run: `20260613-174250-QBE-AUTO-002-cycle01`  
Role: lower natural-language proof architect  
Mode: `faithfulPaper`

## Source Fragment

The local TeX path advertised in older prompts is not present in this checkout.
This packet therefore uses the bundled source map in
`paper-notes/GHL2025_RobinOneTerm.tex` and the Fig. 4 visual audit as the
working source archive.

The paper fragment being translated is the clean-entry route for the one-term
Robin circuit:

| Source anchor | Paper content used here | Lean-facing object |
|---|---|---|
| GHL2025 Eq. `arbitrary sparcity` | $H_W^{(\kappa)}$ prepares the sparse register clean column as the uniform slot superposition. | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` |
| GHL2025 Eq. `ROBIN clarified` | The gamma3 boundary branch contributes the selected sparse-slot amplitude, later represented by the backend branch fold. | `blockExtractionBranchContributionSum oneTermRobinGamma3BoundaryBackendBranchContribution_n3` |
| GHL2025 Fig. `fig:1 term ROBIN` | The theorem-facing route contains both $H_W^{(\kappa)}$ sides around the seven-gate backend component. | `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H` |
| GHL2025 Definition `def:block-encoding` | The block claim selects a clean projection entry after the source-prepared circuit. | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env` |
| Fig. 4 visual audit | The active seven-gate backend is not the full prepared Fig. 4 transcript. | `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` |

## Definitions

For fixed `H : Matrix 8 8 Coeff` and `env : String -> Rat`, define
`ActiveEntry(env)` to be:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders
      (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

Define `PreparedSingleton(H, env)` to be:

```lean
Coeff.evalWith env
  ((oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3)
```

Define `PreparedSparse(H, env)` to be:

```lean
Coeff.evalWith env
  (oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3)
```

Define `Uniform(H)` to be:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

The active lower statement is the finite composition field

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
```

with the preferred uncast form

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
```

which states `ActiveEntry(env) = PreparedSingleton(H, env)`.

## Natural-Language Proof Design

The source-prepared route has two separate parts.

First, the prepared side is already compiled.  The singleton prepared
semantics clean entry evaluates to the prepared sparse matrix clean entry by
`oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3`.
The prepared sparse matrix clean entry is the prepared sandwich sum by
`oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`.  Under
`Uniform(H)`, that sandwich sum evaluates to the backend branch fold by
`oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`.  Lean
packages the result as
`oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3` and
as the source target field theorem
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`.

Second, the active/prepared finite composition field is still open.  The paper
route requires the signal-zero active entry from Definition `def:block-encoding`
to be compared with the clean entry of the prepared
$H_W^{(\kappa)\dagger} U_{\gamma3,boundary} H_W^{(\kappa)}$ singleton
semantics.  Lean names that comparison by
`oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env` and
removes casts through
`oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_iff_uncast_n3`.

The useful proof path for a Lean worker is therefore:

1. Start from the uncast active/prepared statement, not from the retired
   selected-slot feeder.
2. Rewrite the prepared singleton side to the prepared sparse clean entry with
   `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3`
   only after entering `Coeff.evalWith`.
3. If `Uniform(H)` is available in a route theorem, use it only to connect the
   prepared side to the backend fold.  Do not add `Uniform(H)` as a hypothesis
   to the active/prepared field itself.
4. Close the evaluated backend fold later through
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`.

This is a proof design, not a proof of the open field.  A bare theorem
asserting the uncast active/prepared equality for arbitrary `H` should be
treated carefully: the right-hand side depends on the prepared sparse-register
matrix.  A Lean worker should stop and record `source_translation_gap` if the
goal reduces to an arbitrary-`H` equality with no source-backed clean-column or
finite-composition bridge.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_sparse_uniform_contract` | clean-column behavior of $H_W^{(\kappa)}$ over the seven sparse slots | Eq. `arbitrary sparcity`; cited sparse-preparation contract | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results GHL2025 row | contract only | contract-only; keep explicit |
| `fig4_transcript_split` | distinguish full prepared Fig. 4 from the H-free seven-gate backend | Fig. `fig:1 term ROBIN`; Fig. 4 visual audit | none | `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`; transcript gate-list declarations | Fig. 4 audit | project gate | proved guard; reuse |
| `strict_hfree_feeder` | direct `ActiveEntry(env) = selectedSlotContribution` | active full index `0`; selected slot `2` / full index `32` | none | proposed `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3` | finite-path lower1/lower3 packets | none | retired; `shape_or_register_gap` |
| `prepared_singleton_to_backend` | prepared singleton clean entry evaluates to backend fold under `Uniform(H)` | prepared singleton eval; prepared sandwich fold; uniform contract | none | `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`; `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3` | source-prepared route witness | project gate | compiled conditional bridge |
| `active_prepared_entry_field` | cached active entry equals prepared sparse clean entry | `PreparedCircuitEntryTarget`; prepared matrix interface | lower2 | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | current middle packet | full gate after Lean edit | open theorem-facing field |
| `uncast_active_prepared_eval_leaf` | `ActiveEntry(env) = PreparedSingleton(H, env)` | active/prepared field; cast-removal lemma | lower2 | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env` | this packet | full gate after Lean edit | recommended next active leaf |
| `source_projection_active_field` | source target's active field is the same uncast active/prepared statement | source projection target wrappers | none | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastActivePreparedCompositeEval_n3` | current middle packet | project gate | compiled route wiring |
| `backend_fold_recovery` | recover evaluated backend fold from active/prepared equality and `Uniform(H)` | active/prepared field; prepared backend bridge | later | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3` | proof blueprint | full gate after Lean edit | blocked on active field |
| `prepared_projection_restatement` | active/prepared projection-entry equality plus `Uniform(H)` implies evaluated backend fold | prepared projection target | none | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedProjectionEntryEval_n3` | prior lower2 packet | already gated | compiled; stale lower target |

Next active leaf for the Lean worker: attempt one strict reduction or proof of
`oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`.
The worker should not prove a route theorem already listed above and should not
revive `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3`.

## Intermediate Lean Lemmas

Reuse the following declarations in dependency order:

1. `CircuitMatrixSemantics.ofGateMatrices`.
2. `PreparedCircuitEntryTarget.entryEqualityStatement_iff_matrixEntryEqualityStatement`.
3. `oneTermRobinGamma3BoundarySparseCleanIndex_n3`.
4. `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3`.
5. `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`.
6. `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3`.
7. `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3`.
8. `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3`.
9. `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_preparedCleanEntry_n3`.
10. `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3`.
11. `oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3`.
12. `oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_iff_uncast_n3`.
13. `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_iff_uncast_n3`.
14. `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_iff_preparedSandwichStatement_n3`.
15. `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3`.
16. `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastActivePreparedCompositeEval_n3`.
17. `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3`, only for downstream prepared-to-backend recovery.
18. `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`.
19. `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`.

Diagnostic-only declarations to reuse only for rejection evidence:

- `oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3`.
- `oneTermRobinGamma3BoundaryEvalGateMatricesColumn0Entry_eq_sevenGateMatrix_n3`.
- `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3`.
- `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3`.
- `oneTermRobinGamma3BoundaryActiveEvalColumn0_zero_n3`.

## Failure Analysis

The H-free selected-slot feeder is not the current source-paper theorem.  It
compares the active full-basis row `0` entry with the selected gamma3 sparse
slot `2` contribution at full index `32`.  Existing lower3 feedback and
`oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3` classify that
shortcut as `shape_or_register_gap`.

The source-prepared finite composition route remains source-faithful because
it uses the full prepared Fig. 4 path and keeps `Uniform(H)` explicit for the
prepared backend bridge.  The risk is narrower: proving the active/prepared
field directly for arbitrary `H` may be overstrong unless the proof supplies a
finite composition theorem or routes through a source-backed concrete
preparation matrix.  If Lean exposes arbitrary entries of `H` on the prepared
side with no contract or concrete matrix choice, the correct classification is
`source_translation_gap`, not a new assumption.

No oracle, `H_W`, `R_y`, LCU, unitarity, block-projection, normalizer,
product-to-coefficient, block-correctness, final-extraction, or theorem-final
flag is promoted by this packet.

## Handoff

Lower1 proof design complete.  The next lower2 target is the uncast
source-prepared finite composition leaf
`oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`,
or a strict finite reduction feeding that exact statement.  The compiled
prepared-projection restatement is stale as a lower target, and the H-free
row-`0` to selected slot-`2` feeder remains retired as `shape_or_register_gap`.

Gate passed after this Markdown-only lower1 edit:

```bash
python3 tools/qbe.py check
lake build && lake build Tests
```

Both Lean builds completed successfully with only the existing diagnostic
`sorry` warnings in `QuantumBlockEncoding/RobinMatrix.lean`.
