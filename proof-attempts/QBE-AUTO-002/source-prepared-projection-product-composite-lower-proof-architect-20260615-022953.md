# 2026-06-15 Lower Proof Architect: Source-Prepared Composite Stale Check

Task: `QBE-AUTO-002`
Run: `20260615-022953-QBE-AUTO-002-cycle01`
Role: lower natural-language proof architect
Mode: `faithfulPaper`
Leaf: `source_projection_slot2_product`

## Source Fragment

The local TeX path named by older focused prompts,
`outer_papers/quantum/GHL2025/main.tex`, is absent in this checkout.  This
handoff therefore uses the maintained source map and proof exports:
`research-wiki/paper-contributions/GHL2025/source-map.md`,
`paper-notes/GHL2025/markdown/00_status.md`, and
`paper-notes/GHL2025/latex/sections/00_status.tex`.

The translated source-paper fragment is the boundary `gamma_3` clean projection
of the full source-prepared Fig. `fig:1 term ROBIN` circuit:

1. GHL2025 Eq. `arbitrary sparcity`, source-map anchor `main.tex:948-955`,
   supplies the sparse-register clean-column contract

   $$
   H_W^{(\kappa)} |0\rangle =
   \kappa^{-1/2}\sum_{s=0}^{\kappa-1}|s\rangle .
   $$

2. GHL2025 Fig. `fig:1 term ROBIN`, source-map anchor `main.tex:1122-1164`,
   makes the theorem-facing circuit the prepared sandwich with both
   $H_W^{(\kappa)}$ sides.

3. GHL2025 Eq. `ROBIN clarified`, source-map anchor `main.tex:1111-1119`,
   supplies the focused boundary branch.  In this finite leaf the branch is the
   slot-`2` projected product feeding
   `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.

4. GHL2025 Eq. `angles for Ry`, source-map anchor `main.tex:1077-1085`,
   supplies the boundary entry convention used as the hypothesis `hentry`.

This fragment does not prove product-to-coefficient equality, normalizer
algebra, `R_y` unitarity, LCU composition, block correctness, or final
extraction.

## Definitions

Fix `H : Matrix 8 8 Coeff` and `env : String -> Rat`.

Define `SourceProjection(H, env)` as:

```lean
Coeff.evalWith env
  (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
    H env).preparedProjectionEntry
```

Define `BackendFold(env)` as:

```lean
Coeff.evalWith env
  (blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

Define `ProjectedBranchProduct(env)` as:

```lean
Coeff.evalWith env
  oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct
```

Define `hUniform` as:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

Define `hentry` as:

```lean
env "boundary_cos_half_0_2" =
  Coeff.evalWith env
    (GHL2025.boundaryRotationNormalizedCoefficient
      (oneTermParameters 3) 0 2)
```

## Natural-Language Proof

The local theorem states that `SourceProjection(H, env)` equals
`ProjectedBranchProduct(env)` under the two explicit bridge hypotheses.

First, apply
`oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3 H env
hUniform`.  This is the only step where the sparse-register clean-column
contract enters.  It rewrites the evaluated source-prepared clean projection to
the evaluated backend branch fold.

Second, apply
`oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3 env hentry`.
This is the only step where the boundary-entry convention enters.  It rewrites
the evaluated backend fold to the evaluated slot-`2` projected branch product.

The proof is therefore the calculation

```text
SourceProjection(H, env)
  = BackendFold(env)
  = ProjectedBranchProduct(env).
```

No matrix product is unfolded.  The proof does not use the refuted
backend-expansion parent, the H-free evaluated fold as the main route, the old
selected-slot feeder, or either diagnostic `sorry` declaration.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_sparse_uniform_contract` | Clean-column sparse preparation for $H_W^{(\kappa)}$. | Eq. `arbitrary sparcity`; cited sparse-preparation primitive. | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | source map; cited-results memory | contract only | external contract; not proved here |
| `fig4_source_prepared_projection` | Source-prepared clean projection of the Fig. `fig:1 term ROBIN` sandwich. | Fig. `fig:1 term ROBIN`; Definition `def:block-encoding`. | none | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` | conversion window; proof exports | previous full gate | compiled |
| `source_projection_to_backend_fold` | `SourceProjection(H, env)` equals `BackendFold(env)` under `hUniform`. | source-prepared target bridge. | none | `oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3` | composite packet | previous full gate | compiled; stale |
| `backend_fold_to_slot2_projected_product` | `BackendFold(env)` equals `ProjectedBranchProduct(env)` under `hentry`. | backend fold collapse; selected-slot evaluator. | none | `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3` | composite packet | previous full gate | compiled; stale |
| `source_projection_slot2_product` | `SourceProjection(H, env)` equals `ProjectedBranchProduct(env)`. | previous two bridge leaves. | none | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | this note; status export | previous full gate | compiled; stale as lower work |
| `product_to_coefficient_3_0_0` | Fixed product-to-coefficient equality. | projection/product bridge; boundary coefficient convention; normalizer algebra. | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | proof-obligations ledger | full gate | open; not assigned here |
| `backend_expansion_correction` | Corrected source-facing projection/backend branch-sum statement. | source audit; finite condition check; refuted raw backend expansion. | lower1/lower3 first | to be named after correction | `backend-expansion-correction-middle-packet-20260615-0233.md` | full gate | current correction frontier |

## Ordered Lean Lemmas

The composite leaf needs no new definitions and no intermediate theorem beyond
the compiled bridge leaves.

1. Reuse
   `oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3`.
2. Reuse
   `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3`.
3. Reuse the already compiled composite
   `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`.

The compiled proof shape in `QuantumBlockEncoding/RobinMatrix.lean` is the
expected two-line `calc`; a new lower2 Lean edit for this leaf would be stale.

## Failure And Route Analysis

The composite statement is mathematically well-scoped, but it is no longer an
active target in this checkout because the Lean declaration
`oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`
already compiles.  The correct lower response is to retire this leaf as route
memory and not edit `QuantumBlockEncoding/RobinMatrix.lean`.

The next current-run packet identifies a separate blocker:
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`
cannot be assigned unchanged, because
`oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` is compiled.  That
is a finite-matrix/source-correspondence failure for the raw backend-expansion
target, not a failure of the source-prepared composite.

The next route is for lower1/lower3 to name a corrected source-facing
projection/backend branch-sum leaf, or to record a source-contract gap.  Lower2
should not attempt the raw backend-expansion statement unchanged.

## Typed Feedback

```text
leaf=source_projection_slot2_product
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
block_entry_ok=true
ancilla_cleanup_ok=null
normalizer_ok=null
closed_theorem_ok=true
error_class=stale_leaf
next_route=retire composite as compiled route memory; lower1/lower3 refine the corrected source-facing projection/backend branch-sum target before lower2 edits Lean
```

## Handoff

This lower proof-architect pass made no Lean edits.  The requested composite is
already closed by the two compiled bridge leaves, with `hUniform` used only in
the source-prepared/backend-fold bridge and `hentry` used only in the
backend-fold/projected-product bridge.  The active work should move to the
backend-expansion correction frontier named by the current middle packet, with
no theorem-flag promotion and no proof attempt against the refuted raw target.
