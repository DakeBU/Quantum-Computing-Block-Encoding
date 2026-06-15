# 2026-06-15 Lower1 DAG: Source-Prepared Projection/Product Bridge

Task: `QBE-AUTO-002`  
Run: `20260615-013025-QBE-AUTO-002-cycle01`  
Role: lower1 natural-language proof architect  
Mode: `faithfulPaper`  
Leaf: `source_prepared_projection_to_projected_branch_product`

## Source Fragment

The intended paper fragment is the source-prepared clean projection of the
full GHL2025 Fig. `fig:1 term ROBIN` object, not the H-free seven-gate entry by
itself.  The prompt's local source archive path
`outer_papers/quantum/GHL2025/main.tex` is absent in this checkout, so this
packet uses the maintained source map
`research-wiki/paper-contributions/GHL2025/source-map.md`, the Fig. 4 visual
audit, and the compiled Lean transcript records for exact anchor names.

The source anchors are:

| Anchor | Paper fragment translated here | Lean interface |
|---|---|---|
| GHL2025 Eq. `arbitrary sparcity` | $H_W^{(\kappa)}$ prepares the clean sparse-register column uniformly. | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` |
| GHL2025 Fig. `fig:1 term ROBIN` | The theorem-facing object is the prepared sandwich $(H_W^{(\kappa)})^\dagger U_{\gamma_3,\mathrm{boundary}} H_W^{(\kappa)}$. | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env` |
| GHL2025 Definition `def:block-encoding` | The block encoding is read from the clean signal/system projection. | `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry` |
| GHL2025 Eq. `ROBIN clarified` | The focused boundary $\gamma_3$ branch supplies the slot-`2` projected product for the fixed `(0,0)` entry. | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct` |
| GHL2025 Eq. `angles for Ry` | The selected boundary rotation entry must match the normalized boundary coefficient. | `hentry` below |

Equation `arbitrary sparcity` contributes only the explicit clean-column
contract:

$$
H_W^{(\kappa)} |0\rangle =
\frac{1}{\sqrt{\kappa}}\sum_{s=0}^{\kappa-1}|s\rangle .
$$

Equation `ROBIN clarified` contributes the boundary branch factor in which the
selected sparse slot is multiplied by the two sparse-register projection
amplitudes and the boundary coefficient.  In Lean this selected branch is
already represented by the typed object
`oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution`,
and its evaluated form is related to
`oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct`
by `oneTermRobinGamma3BoundaryProjectionSummationObstruction_selectedSlotEval_n3`.

## Definitions

Fix `H : Matrix 8 8 Coeff` and `env : String -> Rat`.

Define `SourcePreparedTarget(H, env)` as:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env
```

Define `PreparedProjectionEntry(H, env)` as:

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env)
  .preparedProjectionEntry
```

Define `BackendFold` as:

```lean
blockExtractionBranchContributionSum
  oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

Define `ProjectedBranchProduct` as:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct
```

Define `Uniform(H)` as:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

Define `hentry` as the selected boundary-entry convention:

```lean
env "boundary_cos_half_0_2" =
  Coeff.evalWith env
    (GHL2025.boundaryRotationNormalizedCoefficient
      (oneTermParameters 3) 0 2)
```

## Local Proof Design

The source-prepared product/projection packet is compiled and is now stale as a
lower2 target:

```lean
OneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation
oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3
oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3_transcript
```

It remains route memory only: it ties the full Fig. `fig:1 term ROBIN` clean
projection, the fixed product obligation
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`, and false downstream
semantic flags into one compiled record.  It is not the product-to-coefficient
proof and not the slot-`2` projection/product bridge.

The first split bridge is already present in Lean:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3
```

Natural-language proof: for fixed `H`, `env`, and `hUniform`, unfold the
source-prepared projection target only far enough to expose
`preparedProjectionEntry` and `backendBranchFold`.  Then apply the compiled
target-level bridge
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3
H env hUniform`.  The hypothesis `hUniform` enters only here.

The next active lower2 leaf is:

```lean
theorem oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3
    (env : String → Rat)
    (hentry :
      env "boundary_cos_half_0_2" =
        Coeff.evalWith env
          (GHL2025.boundaryRotationNormalizedCoefficient
            (oneTermParameters 3) 0 2)) :
    Coeff.evalWith env
      (blockExtractionBranchContributionSum
        oneTermRobinGamma3BoundaryBackendBranchContribution_n3) =
    Coeff.evalWith env
      oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct
```

Natural-language proof: first use
`oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3`
to collapse the evaluated seven-slot backend fold to the selected slot-`2`
contribution.  Then use
`oneTermRobinGamma3BoundaryProjectionSummationObstruction_selectedSlotEval_n3
env hentry` to identify that selected contribution with the projected branch
product.  The hypothesis `hentry` enters only in this second step.

The composite theorem after that leaf is:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3
```

Its proof is the two-link calculation:

```text
PreparedProjectionEntry(H, env)
  -- hUniform and source projection wrapper
= BackendFold
  -- hentry and selected-slot evaluator
= ProjectedBranchProduct.
```

This composite still does not prove `oneTermRobinGamma3ProductToCoefficientObligation
3 0 0`; it only supplies the evaluated projection/product bridge needed before
the later coefficient and normalizer obligations.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_sparse_uniform_contract` | Clean-column sparse preparation for $H_W^{(\kappa)}$. | Eq. `arbitrary sparcity`; sparse-preparation cited row. | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | conversion window; cited-results memory | contract only | external contract; not proved here |
| `fig4_source_prepared_projection` | Select the prepared clean projection of the full Fig. 4 sandwich. | Fig. `fig:1 term ROBIN`; Definition `def:block-encoding`; Fig. 4 audit. | none | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3`; transcript theorem | conversion window | project gate | compiled |
| `source_prepared_product_packet` | Package source target, fixed product `3 0 0`, finite bridge, and false flags. | source-prepared target; product route; finite product bridge. | none | `oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3`; transcript theorem | previous lower1/lower2/lower3 packets | previous full gate | compiled; stale as lower2 work |
| `source_projection_to_backend_fold` | `PreparedProjectionEntry(H, env)` evaluates to `BackendFold` under `hUniform`. | compiled target-level source-prepared backend bridge. | none | `oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3` | this packet; middle packet | project gate | proved wrapper |
| `backend_fold_to_slot2_projected_product` | `BackendFold` evaluates to `ProjectedBranchProduct` under `hentry`. | backend fold collapse; selected-slot evaluator. | lower2 | proposed `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | next active leaf |
| `source_projection_slot2_product` | Compose prepared projection to slot-`2` projected product. | `source_projection_to_backend_fold`; `backend_fold_to_slot2_projected_product`. | lower2 after active leaf | proposed `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | this packet | same gate | open composite |
| `product_to_coefficient_3_0_0` | Prove the fixed product-to-coefficient equality. | projection/product bridge; boundary coefficient convention; normalizer algebra. | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | proof-obligations ledger | same gate | open; not assigned |
| `backend_expansion_parent` | H-free backend-expansion parent. | refuted by selected-slot nonzero obstruction. | none | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` | obstruction packets | none | forbidden |

## Ordered Lean Lemmas For Lower2

1. Reuse `oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3`.
   This theorem is already present in `QuantumBlockEncoding/RobinMatrix.lean`.
2. Reuse `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3`
   to collapse the evaluated backend fold to
   `oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution`.
3. Reuse `oneTermRobinGamma3BoundaryProjectionSummationObstruction_selectedSlotEval_n3`
   with `hentry` to rewrite the selected contribution to
   `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct`.
4. Add `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3`
   as the next single Lean leaf.
5. After that builds, add
   `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`
   by composing the existing source-prepared wrapper with the new backend-fold
   bridge.

The proof script for the next leaf should be a `calc` chain using only the two
compiled evaluated lemmas above.  It should not unfold the seven-gate matrix,
use raw `Coeff` constructor equality, or introduce a new branch-contribution
family.

## Failure Analysis And Route Guard

The 2026-06-13 strict finite feeder route is stale for the current run.  Its
preferred target,
`oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3`, starts from the
H-free active row-`0` entry and routes through
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`.  The current
blueprint and proof-obligation ledger retire that route because the theorem
facing object is now the source-prepared clean projection, and because the
backend-expansion parent is refuted by
`oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3`.

The current bridge does not need the forbidden parent
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`.
It also does not depend on the diagnostic `sorry` declarations
`oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` or
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`.

The active theorem is mathematically well-scoped but narrow.  It proves only
an evaluated backend-fold-to-selected-product bridge.  It does not prove the
signal-block projection/summation theorem, the fixed coefficient equality,
normalizer algebra, oracle correctness, unitarity, LCU composition, block
projection, block correctness, or final extraction.

## Typed Feedback

```text
leaf=source_prepared_projection_to_projected_branch_product
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=null
block_entry_ok=true
ancilla_cleanup_ok=null
normalizer_ok=null
closed_theorem_ok=false
error_class=symbolic_bridge_gap
next_route=oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3
```

Gate result for this lower1 attempt:

```text
python3 tools/qbe.py check: pass
warnings: existing diagnostic sorry warnings in QuantumBlockEncoding/RobinMatrix.lean
```

## Handoff

Lower1 proof design complete.  No Lean edits were made, and
`python3 tools/qbe.py check` passed.  The compiled wrapper
`oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3` is no
longer a lower2 target.  The next lower2 target is exactly
`oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3`; after it
builds, lower2 may compose it with the wrapper in
`oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`.

Do not revive the H-free selected-slot feeder, the evaluated backend fold as a
main theorem, or the refuted backend-expansion parent.  No new assumptions,
semantic flags, oracle contracts, or paper-circuit changes are introduced by
this packet.
