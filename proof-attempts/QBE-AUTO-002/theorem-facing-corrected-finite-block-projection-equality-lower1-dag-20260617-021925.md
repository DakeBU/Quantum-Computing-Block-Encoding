# Lower1 Proof Design: Corrected Finite Block/Projection Equality

Task: `QBE-AUTO-002`  
Run: `20260617-015528-QBE-AUTO-002-cycle01`  
Role: lower natural-language proof architect  
Mode: `paperBenchmark`  
Created: `2026-06-17 02:19 JST`

## Source Fragment

The advertised local TeX file `outer_papers/quantum/GHL2025/main.tex` is not
present in this checkout.  This packet therefore uses the maintained source
map in `paper-notes/GHL2025_RobinOneTerm.tex`,
`paper-notes/GHL2025/markdown/00_status.md`, the conversion window, and the
proof-obligation ledger.

The source fragment being translated is the GHL2025 one-term Robin
block-encoding theorem, anchored as Theorem `theorem: 1 term robin` and
treated as Theorem 3 for this run.  The relevant paper steps are:

| Source anchor | Paper role in this leaf | Lean-facing object |
|---|---|---|
| Definition `def:block-encoding` | select the clean signal block after the theorem-facing circuit | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env` |
| Fig. `fig:1 term ROBIN` | use the full source-prepared sandwich with the `H_W^(kappa)` side gates | `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H` |
| Eq. `arbitrary sparcity` | supply the clean-column contract for `H_W^(kappa)` | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` |
| Eq. `ROBIN clarified` | select the focused boundary gamma3 slot `2` branch | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` |
| Eq. `angles for Ry` | identify the slot-`2` boundary rotation coefficient | `hentry` in the compiled slot-`2` product route |

The exact source-paper fragment is the clean prepared projection from
Definition `def:block-encoding` applied to the Fig. `fig:1 term ROBIN`
prepared route, then specialized to the displayed boundary gamma3 slot `2`
branch from Eq. `ROBIN clarified`.  It is not the H-free active seven-gate
`[0,0]` entry by itself.

## Definitions

For fixed `H : Matrix 8 8 Coeff` and `env : String -> Rat`, define:

| Name | Meaning | Lean expression |
|---|---|---|
| `Uniform(H)` | the explicit clean-column contract for `H_W^(kappa)` | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` |
| `PreparedEntry(H, env)` | theorem-facing prepared clean projection entry | `Coeff.evalWith env (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry` |
| `PreparedBackend(H, env)` | prepared entry evaluated as the backend fold under `Uniform(H)` | `oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3 H env` |
| `Slot2Product(env)` | focused projected branch product for the gamma3 boundary slot | `Coeff.evalWith env oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct` |
| `ActivePreparedField(H, env)` | current audit-gated field comparing the H-free active entry to the prepared singleton entry | `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement` |
| `FixedProductObligation` | blocked theorem-facing product root | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` |

## Natural-Language Proof

The prepared side is already source-aligned and compiled.  The clean entry of
the prepared singleton circuit evaluates to the prepared sparse matrix clean
entry, and under `Uniform(H)` that clean entry evaluates to the backend branch
fold.  Lean exposes this as
`oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3` and
through the theorem-facing target field as
`oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3`.

The focused branch product is also already compiled.  Under the boundary entry
contract from Eq. `angles for Ry`, the backend fold evaluates to the slot-`2`
projected branch product by
`oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3`.  Composing
the prepared projection-to-backend bridge with this branch step gives
`oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`.
This is the source-backed local theorem fragment currently feeding the fixed
product route.

The current audit-gated target
`ActivePreparedField(H, env)` should not be sent directly to a Lean worker as a
standalone theorem.  Its left-hand side is the H-free active seven-gate
`[0,0]` entry, while its right-hand side depends on a free preparation matrix
`H`.  The compiled guard
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3`
shows that both `H_W^(kappa)` side gates are absent from the active gate list.
The no-go theorem
`oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` rejects the raw
H-free backend expansion route.  Therefore a direct proof of the current
unconstrained active/prepared field would be a source-translation error, not a
paper-backed block/projection theorem.

The next source-backed proof block should instead be a non-promoting corrected
prepared-projection contract.  Its interface should consume the compiled
prepared projection/product route and the compiled normalizer bridge, keep
`FixedProductObligation.proved = false`, and avoid equating the H-free active
entry with the prepared entry.  After that corrected contract is compiled, the
next mathematical leaf is the coefficient/product bridge for
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_uniform_contract` | clean-column behavior of `H_W^(kappa)` over the seven sparse slots | Eq. `arbitrary sparcity`; cited Shukla-Vedula contract | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results GHL2025 row | contract only | explicit external contract |
| `prepared_projection_to_backend_fold` | prepared clean projection evaluates to backend fold under `Uniform(H)` | prepared singleton evaluator; uniform clean-column contract | none | `oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3` | source-prepared packets | previous gate | proved route memory |
| `backend_fold_to_slot2_product` | backend fold evaluates to focused slot-`2` projected product under `hentry` | boundary rotation entry contract | none | `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3` | source-prepared packets | previous gate | proved route memory |
| `source_projection_slot2_product` | prepared projection entry evaluates to focused slot-`2` product | previous two nodes | none | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | source-prepared product/projection map | previous gate | proved route memory |
| `projection_interface_normalizer_bridge` | source slot-`2` product times theorem normalizer is exposed through theorem-facing fields | projection interface; normalizer algebra | none | `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3` | normalizer packet | previous gate | proved route memory |
| `raw_active_prepared_field` | H-free active `[0,0]` entry equals prepared singleton clean entry for free `H` | active seven-gate entry; prepared singleton entry | none | `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement` | current middle packet | no Lean edit | contract drift if assigned directly |
| `corrected_prepared_projection_contract` | non-promoting theorem-facing contract using `preparedProjectionEntry`, compiled slot-`2` product, and compiled normalizer bridge | source projection/product route; normalizer bridge; false-flag audit | middle then lower2 | not yet named | this packet and conversion window | `python3 tools/qbe.py check` after Lean edit | next active leaf |
| `fixed_product_to_coefficient` | coefficient/product equality for `(n,i,j) = (3,0,0)` | corrected prepared-projection contract; final coefficient algebra | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | proof-obligation ledger | full gate plus proof-map sync | blocked |

Next active leaf for the Lean worker: do not prove
`ActivePreparedField(H, env)` directly.  Middle should name a corrected
prepared-projection contract whose left side is
`(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry`
or a field of the theorem-facing projection interface equal to that prepared
entry.  Lower2 can then compile that one non-promoting contract.

## Intermediate Lean Lemmas

Reuse these declarations in dependency order:

1. `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`.
2. `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3_transcript`.
3. `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3`.
4. `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`.
5. `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`.
6. `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`.
7. `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`.
8. `oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3`.
9. `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3`.
10. `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`.
11. `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3`.
12. `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3`.

Use these declarations only as rejection or guard evidence:

- `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3`.
- `oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_obstruction_n3`.
- `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3`.
- `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`.
- `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`.

## Failure Analysis

The current raw active/prepared field is not a safe theorem-facing target in
its unconstrained form.  It compares an H-free active seven-gate entry with a
prepared singleton entry that depends on a free matrix `H`.  The source paper
does not claim this arbitrary-`H` equality.  It claims the clean block entry of
the full prepared Fig. `fig:1 term ROBIN` route under the sparse preparation
contract and the boundary coefficient conventions.

This is a `source_translation_gap` for the current lower2 assignment, not a new
external theorem dependency.  Do not repair it by adding a new assumption to
the GHL theorem, changing the paper circuit, or promoting LCU, oracle,
unitarity, block-projection, final-extraction, resource, or product flags.  The
correct repair is a source-shaped theorem-facing contract over the already
compiled prepared projection/product route.

## Typed Feedback

```text
leaf=theorem_facing_corrected_finite_block_projection_equality
source_correspondence_ok=false_for_unconstrained_active_prepared_field; true_for_prepared_projection_route
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=false_for_unchanged_hfree_backend_route
block_entry_ok=false
normalizer_ok=compiled_route_memory
closed_theorem_ok=false
error_class=source_translation_gap
next_route=middle names a corrected prepared-projection contract consuming oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3 and oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3; lower2 compiles only that non-promoting leaf
```

## Handoff

Lower1 proof design complete.  Retire direct lower2 proof search on
`(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement`
unless middle first constrains or replaces the target so it represents the
paper's prepared projection.  The source-backed route already compiled is the
prepared projection-to-slot-`2` product bridge plus the theorem-facing
normalizer bridge.  The next Lean leaf should be a corrected, non-promoting
prepared-projection contract feeding the fixed product obligation.
