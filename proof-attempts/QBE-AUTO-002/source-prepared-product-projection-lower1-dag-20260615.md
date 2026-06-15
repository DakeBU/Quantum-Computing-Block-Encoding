# 2026-06-15 Lower1 DAG: Source-Prepared Product/Projection Packet

Task: `QBE-AUTO-002`  
Run: `20260615-010153-QBE-AUTO-002-cycle01`  
Role: lower1 natural-language proof architect  
Mode: `faithfulPaper`  
Leaf: `source_prepared_product_projection_packet`

## Source Fragment

The translated source fragment is GHL2025 Eq. `arbitrary sparcity`, Eq.
`angles for Ry`, Theorem `theorem: 1 term robin`, Eq. `ROBIN clarified`, Fig.
`fig:1 term ROBIN`, Definition `def:block-encoding`, and the Fig. 4 visual
audit in `paper-notes/GHL2025/markdown/fig4-visual-audit.zh.md`.

Equation `arbitrary sparcity` supplies only the clean-column sparse
preparation contract:

$$
H_W^{(\kappa)} |0\rangle^{\lceil \log_2 \kappa \rceil}
= \frac{1}{\sqrt{\kappa}}
  \sum_{s=0}^{\kappa - 1}|s\rangle^{\lceil \log_2 \kappa \rceil}.
$$

Equation `angles for Ry` defines the boundary controlled rotation convention
for $s = 0,\dots,\kappa-1$ and boundary indices
$0 \leq j < K_1$ or $K_2 < j < 2^n$.  It is not consumed by the bookkeeping
packet, but it is a later coefficient-normalization dependency.

Equation `ROBIN clarified` supplies the boundary part of $|\gamma_3\rangle$:

$$
|\gamma_3\rangle =
\frac{1}{\mathcal{N}_D\mathcal{N}_f\kappa}
\sum_{\substack{s=0,\dots,\kappa-1 \\
0 \leq j < K_1 \cup K_2 < j < 2^n}}
f(x_i)(D)_i^{(s)}\sigma^{(s)}
|0\rangle^{m_f+1}|s\rangle
|0\rangle^{n-\lceil \log_2\kappa\rceil}|j\rangle^n|0\rangle
+ \cdots .
$$

Fig. `fig:1 term ROBIN` is the full prepared sandwich.  Its theorem-facing
object has the form

```text
(H_W^(kappa))^dagger * U_gamma3_boundary * H_W^(kappa)
```

with the seven-gate backend as an internal component.  The Fig. 4 visual audit
records that `GHL2025.oneTermRobinCircuit` or
`GHL2025.oneTermRobinGateMatrixPlaceholders` is only the H-free seven-gate
backend component, not the full Fig. 4 source object.

Definition `def:block-encoding` selects the clean ancilla and clean signal
projection.  In this packet that clean projection is represented by the clean
entry of the prepared composite semantics, not by the H-free active row-`0`
entry.

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

Define `PreparedBackendField(H, env)` as:

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env)
  .preparedSingletonToBackendEvalStatement
```

Define `BackendFold` as:

```lean
blockExtractionBranchContributionSum
  oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

Define `Uniform(H)` as:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

Define `FixedProductObligation` as:

```lean
oneTermRobinGamma3ProductToCoefficientObligation
  3 ⟨0, by native_decide⟩ ⟨0, by native_decide⟩
```

Define `ProductRoute` as:

```lean
oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3
```

Define `FiniteProductBridge` as:

```lean
oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3
```

## Local Theorem Design

The active lower2 theorem is the packet instance:

```lean
oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3
```

Its structure should be:

```lean
OneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation
```

The packet should record these fields exactly:

```lean
sourceTarget :=
  oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env

productRoute :=
  oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3

productBridge :=
  oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3

preparedBackendEvalStatement :=
  (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env)
    .preparedSingletonToBackendEvalStatement

fixedProductObligation :=
  oneTermRobinGamma3ProductToCoefficientObligation
    3 ⟨0, by native_decide⟩ ⟨0, by native_decide⟩

forbiddenBackendExpansionParent := true
preparedBackendEvalCompiled := true
productRouteConsumed := false
normalizedBlockEqualityProved := false
productToCoefficientProved := false
lcuCorrectProved := false
blockProjectionProved := false
blockCorrectProved := false
finalExtractionProved := false
```

Natural-language proof of the packet:

First, `SourcePreparedTarget(H, env)` already selects the clean entry of
`oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H` at
`oneTermRobinGamma3BoundarySparseCleanIndex_n3`.  This is the source-facing
prepared projection for the full sandwich from Fig. `fig:1 term ROBIN`.

Second, under `Uniform(H)`, the prepared clean entry evaluates to `BackendFold`.
The compiled bridge is
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`,
with the lower-level evaluator
`oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`.
The packet should name this prepared backend field, but it should not consume
it to prove the product coefficient theorem.

Third, `ProductRoute` and `FiniteProductBridge` already point at the fixed
system entry `(0,0)`, sparse slot `2`, full branch basis index `32`, and
`FixedProductObligation`.  Their transcript theorems keep the product,
branch-decomposition, normalized block equality, LCU, block, and final flags
false.

Therefore the packet is a definitional proof-DAG leaf: lower2 should be able
to close its transcript by `rfl`, `dsimp`, existing transcript lemmas, and
`native_decide`, without unfolding large matrix products and without adding a
new mathematical assumption.

## Source-to-Lean Dependency Table

| Source anchor | Source content used | Lean object or target | Dependency class | Status |
|---|---|---|---|---|
| GHL2025 Eq. `arbitrary sparcity` | clean-column preparation by $H_W^{(\kappa)}$ | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external cited contract | contract-only; keep explicit |
| GHL2025 Eq. `angles for Ry` | boundary $R_y$ angle convention | later coefficient leaf after product/projection | source coefficient convention | not consumed by this packet |
| GHL2025 Theorem `theorem: 1 term robin` | theorem root, normalizer, resource claim | final one-term block-encoding route | theorem root | open |
| GHL2025 Eq. `ROBIN clarified` | gamma3 boundary branch and normalizer factors | `BackendFold`; `ProductRoute`; `FixedProductObligation` | GHL-internal branch algebra plus QBE semantics | route typed; coefficient theorem false |
| GHL2025 Fig. `fig:1 term ROBIN` | full prepared sandwich with both `H_W` sides | `SourcePreparedTarget(H, env)` | source transcript and QBE prepared semantics | compiled target |
| GHL2025 Definition `def:block-encoding` | clean signal/system projection | `PreparedProjectionEntry(H, env)` and finite block entry `(0,0)` | QBE-local projection interface | target compiled; projection/product bridge open |
| Fig. 4 visual audit | full Fig. 4 differs from H-free seven-gate backend | reject H-free active fold as packet root | route guard | checked; use as reviewer evidence |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_sparse_uniform_contract` | all-slot sparse clean column for $H_W^{(\kappa)}$ | Eq. `arbitrary sparcity`; Shukla--Vedula contract row | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results and conversion window | contract only | external contract; not proved here |
| `fig4_prepared_projection_target` | clean entry of full prepared sandwich | Fig. `fig:1 term ROBIN`; Definition `def:block-encoding`; Fig. 4 audit | none | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` and transcript | conversion window; proof obligations | project gate | compiled |
| `prepared_projection_backend_eval` | `PreparedProjectionEntry(H, env)` evaluates to `BackendFold` under `Uniform(H)` | prepared singleton semantics; prepared sandwich sum; uniform contract | none | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`; `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3` | proof-obligations ledger | project gate | compiled conditional bridge |
| `fixed_product_route` | route to `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | gamma3 boundary branch; clean-column factor contracts; coefficient hypotheses | none | `oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3`; transcript theorem | product-route packets | project gate | compiled route; flags false |
| `finite_product_projection_bridge` | finite interface separating signal block `[0,0]` from branch basis `[32,32]` | `fixed_product_route`; Definition `def:block-encoding`; finite index lemma | none | `oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3`; transcript theorem | proof-obligations ledger | project gate | compiled interface; flags false |
| `backend_expansion_no_go` | forbid the stale backend-expansion parent | selected-slot nonzero witness; H-free fold implication | none | `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` | 2026-06-14 obstruction packets | project gate | proved no-go guard |
| `source_prepared_product_packet` | package the prepared projection target, product route, finite bridge, fixed product obligation, and false flags | all nodes above except no-go as guard evidence | lower2 | `OneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation`; `oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | ready active leaf |
| `source_projection_to_backend_fold` | direct wrapper from prepared projection entry to backend fold under `Uniform(H)` | `prepared_projection_backend_eval` | lower2 optional after packet | `oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3` | this packet | same gate | optional small wrapper |
| `backend_fold_to_slot2_projected_product` | identify backend fold with the slot-`2` projected branch product | finite branch/projection theorem; no backend-expansion parent | later lower2 | `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3` | future packet | same gate | open mathematical leaf |
| `source_projection_slot2_product` | compose the prepared projection with slot-`2` projected product | two previous nodes | later lower2 | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | future packet | same gate | first mathematical leaf after packet |
| `product_to_coefficient_3_0_0` | prove the fixed coefficient obligation | slot-`2` projection/product bridge; normalizer algebra; boundary coefficient convention | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | theorem proof map | same gate | open; not assigned |
| `one_term_robin_root` | final one-term Robin block-encoding claim | product coefficient, LCU/block composition, resource and cleanup contracts | later | theorem-facing block-extraction route | paper notes | full gate | open |

The next lower2 target is exactly:

```lean
oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3
```

The first mathematical leaf after that packet is:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3
```

A safer split is:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3
oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3
```

The first split theorem should be only a wrapper over the compiled prepared
projection bridge.  The second split theorem is the real finite
projection/product bridge and must not use
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`.

## Ordered Lean Lemmas For Lower2

Lower2 should reuse or create declarations in this order:

1. Reuse `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` and
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3_transcript` to
   select the source-prepared clean projection.
2. Reuse `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`
   for the evaluated prepared clean entry under `Uniform(H)`.
3. Reuse
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`
   as the theorem-facing prepared-projection backend bridge.
4. Reuse `oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3` and
   `oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3_transcript` to
   name the fixed product route.
5. Reuse `oneTermRobinGamma3BoundaryFiniteProjectionBlockEntryIndex_n3`,
   `oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3`, and
   `oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3_transcript` to
   keep signal block index `0` separate from branch basis index `32`.
6. Reuse
   `oneTermRobinGamma3BoundaryPreparedCleanEntryBackendEval_feedsFixedProductMap_n3`,
   `oneTermRobinGamma3BoundaryProductToCoefficientObligation_preparedCompositeCleanEntryBackendEval_n3`,
   and
   `oneTermRobinGamma3BoundaryProductToCoefficientObligation_sourcePreparedTargetBackendEval_n3`
   only as route witnesses that keep the product theorem false.
7. Create `OneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation`
   with the fields listed in the middle packet.
8. Create `oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3`
   with `sourceTarget`, `productRoute`, `productBridge`,
   `preparedBackendEvalStatement`, and `fixedProductObligation` set exactly as
   listed above.
9. Create a transcript theorem for the new packet.  It should check
   `forbiddenBackendExpansionParent = true`,
   `preparedBackendEvalCompiled = true`, `productRouteConsumed = false`, and
   every downstream proof flag is false.
10. Optional only after the packet compiles: create
    `oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3` as
    a direct wrapper over
    `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`.
11. Defer
    `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3` and
    `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`
    to the first mathematical proof leaf after the bookkeeping packet.

## Failure Analysis

The packet target is mathematically well routed.  It is only a proof-DAG
bookkeeping object, so it should not assert product-to-coefficient correctness,
LCU correctness, normalized block equality, block projection, block
correctness, final extraction, or circuit unitarity.

The stale `backendExpansionStatement` route is forbidden.  Lean already proves

```lean
oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3
```

because the backend-expansion parent forces a selected-slot vanish condition,
while the compiled all-one environment witness evaluates the selected boundary
slot to `1`.  A lower2 proof that depends on
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`
is therefore an invalid route, not a hard tactic goal.

The H-free evaluated fold

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

is also not the packet root.  It exposes the seven-gate active `[0,0]` entry
without the two $H_W^{(\kappa)}$ side gates.  The source route starts from the
prepared clean projection of
`(H_W^(kappa))^dagger * U_gamma3_boundary * H_W^(kappa)`.

The active/prepared diagnostic names

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

should not be assigned as this batch's main lower2 target.  Under `Uniform(H)`,
the current compiled wiring can route them back to the retired H-free fold.
They remain useful diagnostics but not theorem closure.

The direct row-`0` to selected-slot feeder is still a `shape_or_register_gap`.
The finite bridge records the theorem-facing block entry at signal block
`[0,0]`, while the focused branch-local product is attached to sparse slot `2`
and full basis entry `[32,32]`.  The missing theorem must be a
projection/summation bridge, not an equality that identifies those indices
directly.

## Typed Feedback

```text
leaf=source_prepared_product_projection_packet
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=null
block_entry_ok=true
ancilla_cleanup_ok=null
normalizer_ok=null
closed_theorem_ok=false
error_class=symbolic_bridge_gap
next_route=oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3
```

## Handoff

Lower1 proof design complete.  The ready lower2 target is
`oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3`.
Lower2 should add only the packet record, the `n = 3` instance, and a transcript
checking the field pointers and false proof flags.  The first mathematical leaf
after the packet is
`oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`,
preferably split through
`oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3` and
`oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3`.

No Lean edits were made by this lower1 attempt.  No new assumptions, theorem
flags, oracle contracts, or paper-circuit changes are introduced by this
packet.
