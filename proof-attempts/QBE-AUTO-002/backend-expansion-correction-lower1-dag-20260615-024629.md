# Backend-Expansion Correction Lower1 DAG

Task: `QBE-AUTO-002`
Run: `20260615-024629-QBE-AUTO-002-cycle01`
Role: `lower1-natural-language-proof-architect`
Mode: `faithfulPaper`
Created: `2026-06-15`

## Source Status

The local TeX source `outer_papers/quantum/GHL2025/main.tex` is absent in
this checkout.  This packet therefore uses the checked-in public anchors only:
GHL2025 Eq. `ROBIN clarified`, Fig. `fig:1 term ROBIN`, Definition
`def:block-encoding`, Theorem `theorem: 1 term robin`, the maintained
GHL2025 proof notes, and `research-wiki/cited-results/GHL2025.md`.

## Definitions

`SourceProjection(H, env)` is
`Coeff.evalWith env (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry`.

`PreparedSandwich(H)` is
`oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3 H`.

`BackendFold(env)` is
`Coeff.evalWith env (blockExtractionBranchContributionSum oneTermRobinGamma3BoundaryBackendBranchContribution_n3)`.

`ProjectedBranchProduct(env)` is
`Coeff.evalWith env oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct`.

`BackendExpansionRaw` is
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`.

`SignalEntryFold` is the symbolic equality

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

`hUniform` is
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.

`hentry` is

```lean
env "boundary_cos_half_0_2" =
  Coeff.evalWith env
    (GHL2025.boundaryRotationNormalizedCoefficient
      (oneTermParameters 3) 0 2)
```

## Source Fragment

The source fragment being translated is the boundary $\gamma_3$ branch of
Eq. `ROBIN clarified` for the focused finite instance
`n = 3`, system entry `(0,0)`, and sparse slot `2`, together with the clean
block-entry projection required by Definition `def:block-encoding` and the
prepared sparse-register sides shown in Fig. `fig:1 term ROBIN`.

The paper-backed statement is not the H-free raw seven-gate signal entry by
itself.  The source-facing object is the clean projection after the sparse
register has been prepared and projected.  In Lean, the already compiled
source-facing route is:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3
```

This theorem states that, under `hUniform` and `hentry`, the source-prepared
clean projection evaluates to the slot-`2` projected branch product.  It is the
current checked translation of the source branch/product step.

## Natural-Language Proof

The source-prepared clean entry is the clean entry of the prepared composite
semantics for the Fig. `fig:1 term ROBIN` route.  Under `hUniform`, Lean proves
that this entry evaluates to the backend seven-slot fold:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3
```

The backend fold then collapses to the focused slot-`2` selected contribution.
Under `hentry`, that selected contribution evaluates to the route's
`projectedBranchProduct`:

```lean
oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3
```

Composing the two equalities gives the source-prepared projection/product
equality:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3
```

This is a valid paper-backed local proof block.  It does not prove
`BackendExpansionRaw`, and it does not identify the H-free raw signal entry
with the backend fold.

The raw backend-expansion proposition is already refuted:

```lean
oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3 :
  ¬ oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

It is also equivalent to `SignalEntryFold`:

```lean
oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3
```

Therefore no lower2 worker should try to prove `BackendExpansionRaw` or an
equivalent signal-entry fold.  The paper supports the prepared projection route
already compiled above.  It does not, from the checked-in anchors available in
this checkout, support the current raw H-free backend-expansion proposition as
a theorem-facing branch-sum statement.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_projection_to_backend_fold` | `SourceProjection(H, env) = BackendFold(env)` under `hUniform` | prepared clean-entry evaluator; `H_W^(kappa)` clean-column contract | none | `oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3` | source-prepared product/projection packets | previous full gate | proved; route memory |
| `backend_fold_to_slot2_projected_product` | `BackendFold(env) = ProjectedBranchProduct(env)` under `hentry` | selected-slot fold collapse; corrected boundary entry evaluator | none | `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3` | source-prepared product/projection packets | previous full gate | proved; route memory |
| `source_projection_slot2_product` | `SourceProjection(H, env) = ProjectedBranchProduct(env)` under `hUniform` and `hentry` | previous two nodes | none | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | previous lower1/lower2 composite packets | previous full gate | proved; stale as lower2 target |
| `backend_expansion_raw` | raw H-free backend expansion, equivalent to `SignalEntryFold` | generic backend-expansion bridge | none | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` | middle correction packet; lower3 no-go packet | none | refuted; do not assign |
| `prepared_projection_contract_gap` | state that theorem-facing projection/backend work must consume the prepared projection route, not the raw H-free fold | source anchors above; compiled source-prepared route; compiled no-go guard | middle or upper | no new Lean declaration named by lower1 | this packet | `python3 tools/qbe.py check` | active source-contract correction |
| `backend_expansion_corrected_lean_leaf` | one future corrected Lean leaf, only if middle restates the paper-backed target without equivalence to `BackendExpansionRaw` | `prepared_projection_contract_gap`; lower3 finite-shape check | lower2 after retarget only | not named in this packet | future packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | blocked |
| `product_to_coefficient_3_0_0` | fixed product-to-coefficient equality for `(3,0,0)` | compiled source projection/product route; normalizer algebra; source projection convention | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | proof-obligation ledger | full gate | open; do not promote |

Next active leaf for a Lean worker: none.  Lower2 should make no Lean edit
until middle either retargets the theorem-facing route to the compiled
source-prepared projection/product theorem or names a corrected proposition
that is not equivalent to the refuted `BackendExpansionRaw`.

## Intermediate Lean Lemmas

1. Reuse `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`.
   This evaluates the prepared clean entry as the backend fold under
   `hUniform`.

2. Reuse
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`.
   This exposes the same equality through the source-prepared projection
   target.

3. Reuse `oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3`.
   This is the named source projection to backend fold bridge.

4. Reuse
   `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3`
   and
   `oneTermRobinGamma3BoundaryProjectionSummationObstruction_selectedSlotEval_n3`.
   These are the backend fold collapse and selected slot evaluator.

5. Reuse `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3`.
   This connects the backend fold to the slot-`2` projected product under
   `hentry`.

6. Reuse
   `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`.
   This is the compiled paper-backed branch/product composite.

7. Treat
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`
   only as route memory.  Do not use it to assign an equivalent theorem target.

8. Treat `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` as a
   no-go guard for the raw target and every statement still equivalent to it.

## Failure Analysis

The current raw target is mathematically wrong as a theorem-facing lower2
goal.  If `BackendExpansionRaw` held, Lean would derive the evaluated backend
fold and then force the selected slot contribution to evaluate to `0`.  The
compiled all-one selected-branch witness evaluates the same selected slot
contribution to `1`.  This proves the negation of the raw target.

The checked-in source anchors support the prepared projection route, not an
H-free signal-entry branch-sum theorem over arbitrary coefficient
environments.  Thus the correction is a `source-contract-gap` for the current
Lean interface, with the finite counterexample as the concrete verifier
evidence.

Do not repair this by adding hypotheses to `BackendExpansionRaw`.  The next
valid repair is a middle-level retarget: either consume the compiled
source-prepared projection/product theorem in the product route, or state a
new source-facing projection/backend proposition whose left-hand side is the
prepared clean projection and whose hypotheses include the existing
source-contract fields.

## Typed Feedback

```text
leaf=backend_expansion_correction_source_audit
source_correspondence_ok=false
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=false
block_entry_ok=false
ancilla_cleanup_ok=null
normalizer_ok=null
closed_theorem_ok=false
error_class=source_contract_gap
counterexample_class=finite_matrix_counterexample
next_route=middle must retarget through the compiled source-prepared projection/product route or record the source-contract gap; lower2 has no Lean edit
```

## Handoff

Lower1 correction packet complete.  The paper-backed source-facing route is the
compiled source-prepared projection/product theorem
`oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`.
The raw backend-expansion proposition and every statement still equivalent to
`SignalEntryFold` remain refuted by
`oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3`.  Lower2 should
not edit Lean until middle names a non-refuted corrected leaf or retargets the
product route to consume the compiled source-prepared theorem.
