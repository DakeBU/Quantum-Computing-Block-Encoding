# Product-To-Coefficient Normalizer Lower1 Proof Architect Postscript

Task: `QBE-AUTO-002`  
Run: `20260615-032327-QBE-AUTO-002-cycle01`  
Role: lower1 natural-language proof architect  
Mode: `faithfulPaper`  
Created: `2026-06-15 03:46 JST`

## Source Fragment

The local TeX path from the run prompt,
`outer_papers/quantum/GHL2025/main.tex`, is absent in this checkout.  This
postscript therefore uses the maintained public source anchors and source-map
rows: GHL2025 Theorem `theorem: 1 term robin`, Eq. `ROBIN clarified`, Eq.
`arbitrary sparcity`, Eq. `angles for Ry`, Fig. `fig:1 term ROBIN`, Definition
`def:block-encoding`, and `research-wiki/cited-results/GHL2025.md`.

The translated fragment is the focused gamma3 boundary contribution for system
entry `(0,0)` and sparse slot `2`.  The current proof notes record the local
product calculation as

$$
\text{product}_{32,32}
= (f_3(0)N_f^{-1})(D_0^{(2)}N_D^{-1}),
$$

with target matrix entry

$$
(A_k)_{0,0}=f_3(0)D_0^{(2)}.
$$

Eq. `ROBIN clarified` supplies the denominator $N_DN_f\kappa$.  Eq.
`arbitrary sparcity` and the Shukla--Vedula cited row supply only a
contract-level clean-column input for $H_W^{(\kappa)}$, instantiated here as
the slot-`2` amplitude `sqrt_kappa_inv`.  The matching bra-side projection and
the identity `sqrt_kappa_inv * sqrt_kappa_inv = kappa_inv` are explicit
hypotheses in the next conditional bridge, not promoted theorem flags.

## Definitions

`FixedProductObligation` is

```lean
oneTermRobinGamma3ProductToCoefficientObligation 3
  ⟨0, by native_decide⟩ ⟨0, by native_decide⟩
```

`SourceSlot2Product(H, env)` is the compiled equality

```lean
oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3
  H env hUniform hentry
```

where `hUniform` is
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`, and
`hentry` identifies the selected boundary `R_y` entry
`boundary_cos_half_0_2` with
`GHL2025.boundaryRotationNormalizedCoefficient (oneTermParameters 3) 0 2`.

`FocusedCleanColumn(H)` is the single product-route hypothesis

```lean
H
  ⟨oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3.cleanColumnFactorRoute.uniformColumnRowIndex,
    by native_decide⟩
  ⟨oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3.cleanColumnFactorRoute.uniformColumnColIndex,
    by native_decide⟩ =
  oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3.cleanColumnFactorRoute.expectedUniformColumnEntry
```

The compiled transcript for the product route identifies these indices as row
`2`, column `0`, and expected entry `Coeff.symbol "sqrt_kappa_inv"`, so this
field should be obtained from `hUniform ⟨2, by native_decide⟩`.

`NormalizerEnv(env)` is the four explicit coefficient hypotheses:

```lean
hND : env "N_D_inv" * env "N_D" = 1
hNF : env "N_f_inv" * env "N_f" = 1
hkappa : env "kappa_inv" * env "kappa" = 1
hkappaSqrt :
  env "sqrt_kappa_inv" * env "sqrt_kappa_inv" =
    env "kappa_inv"
```

## Natural-Language Proof

The active theorem for a Lean worker is the conditional bridge proposed in the
middle packet:

```lean
oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3
```

The proof should first unfold only the local packets
`oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3` and
`oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3`.  It should not
unfold or rewrite the root `FixedProductObligation`, except to prove record
identity and false-flag fields by `rfl` or `dsimp`.

Use `SourceSlot2Product(H, env)` to replace
`packet.sourceTarget.preparedProjectionEntry` by
`oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct`
after applying `Coeff.evalWith env`.

Derive `FocusedCleanColumn(H)` from the all-slot contract by applying
`hUniform` to the sparse slot `⟨2, by native_decide⟩`.  The route transcript
and the definitions of `oneTermRobinGamma3BoundarySparseSlotIndex_n3` and
`oneTermRobinGamma3BoundarySparseCleanIndex_n3` reduce this to the product
route's row `2`, column `0`, and expected entry
`Coeff.symbol "sqrt_kappa_inv"`.

Apply
`oneTermRobinGamma3BoundaryProductUnderContractsEval_n3 env H hCleanColumn
hND hNF hkappa hkappaSqrt`.  Use the second conjunct of that theorem.  After
the source-product rewrite, this is exactly

```lean
Coeff.evalWith env packet.sourceTarget.preparedProjectionEntry *
  Coeff.evalWith env productRoute.theoremNormalizer =
Coeff.evalWith env productRoute.expectedTargetEntry
```

The remaining conjuncts in the proposed bridge are bookkeeping fields: the
fixed obligation is still `oneTermRobinGamma3ProductToCoefficientObligation 3
0 0`, its `proved` field is `false`, and every product, normalized-block, LCU,
block, and final-extraction flag remains false.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_sparse_uniform_contract` | all paper sparse slots have clean-column amplitude `sqrt_kappa_inv` | GHL2025 Eq. `arbitrary sparcity`; Shukla--Vedula cited row | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results ledger | contract only | external obligation |
| `source_slot2_product_fixed_map_guard` | source-prepared slot-`2` product feeds the fixed product map while downstream flags remain false | `source_sparse_uniform_contract`; boundary entry convention | none | `oneTermRobinGamma3BoundarySourcePreparedProjectionSlot2Product_feedsFixedProductMap_n3` | retarget packet | previous full gate | compiled; stale as lower target |
| `focused_clean_column_from_all_slots` | derive the product route's row-`2`, column-`0` clean-column hypothesis from `hUniform` | `source_sparse_uniform_contract`; product-route transcript | lower2 only if needed | proposed `oneTermRobinGamma3BoundaryHWKappaUniformAllSlots_to_productRouteFocusedCleanColumn_n3` | middle packet and this postscript | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | optional feeder |
| `conditional_normalizer_product_bridge` | source-prepared slot-`2` product times theorem normalizer equals the expected target entry under explicit coefficient hypotheses | `source_slot2_product_fixed_map_guard`; `focused_clean_column_from_all_slots`; `oneTermRobinGamma3BoundaryProductUnderContractsEval_n3` | lower2 | proposed `oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3` | middle packet and this postscript | same gate | next active leaf |
| `fixed_product_to_coefficient_3_0_0` | close the exact `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` root | conditional bridge plus finite normalized-block/projection bridge and accepted LCU contract | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 ⟨0,_⟩ ⟨0,_⟩` | proof-obligation ledger | same gate plus proof-map sync | open root |
| `backend_expansion_raw_no_go` | unchanged raw backend expansion and any `SignalEntryFold` equivalent proposition | compiled finite counterexample | none | `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` | correction packets | none | refuted; forbidden |

Next active leaf: `conditional_normalizer_product_bridge`.  If the clean-column
specialization is the only blocker, prove
`focused_clean_column_from_all_slots` first and use it immediately in the
bridge.

## Intermediate Lean Lemmas

1. Reuse
   `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`
   for the source-prepared projection rewrite.
2. If needed, add
   `oneTermRobinGamma3BoundaryHWKappaUniformAllSlots_to_productRouteFocusedCleanColumn_n3`.
   Its proof should be `hUniform ⟨2, by native_decide⟩` plus definitional
   simplification of the route indices.
3. Reuse
   `oneTermRobinGamma3BoundaryProductUnderContractsEval_n3` for the conditional
   product times normalizer equality.
4. Prove
   `oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3` by
   combining items 1 through 3 and closing all record fields with `rfl` or
   `dsimp`.

## Failure Analysis

The unchanged backend-expansion route is mathematically wrong as a theorem
target for this proof packet.  Lean already has
`oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3`, and the retarget
packet records it as a finite matrix counterexample/source-contract gap.

The guard
`oneTermRobinGamma3BoundarySourcePreparedProjectionSlot2Product_feedsFixedProductMap_n3`
is already present and compiled, so assigning it again is a stale leaf.  It is
valid route memory, not a current theorem-facing lower target.

The proposed conditional bridge is still not the root theorem.  It must leave
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` with `proved =
false`, and it must not promote normalized-block equality, LCU correctness,
block projection, block correctness, final extraction, oracle correctness,
unitarity, or resource claims.

## Typed Feedback

```text
leaf=source_slot2_product_fixed_map_guard
source_correspondence_ok=true
finite_matrix_ok=true
block_entry_ok=false
normalizer_ok=conditional_route_only
closed_theorem_ok=true
product_to_coefficient=false
error_class=stale_leaf
next_route=prove oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3, optionally through oneTermRobinGamma3BoundaryHWKappaUniformAllSlots_to_productRouteFocusedCleanColumn_n3; do not revive backendExpansionStatement
```

## Handoff

No Lean edit was made.  The retarget guard is compiled and stale as a lower
target.  The next Lean worker should prove only the conditional
normalizer/product bridge above, or the all-slots-to-focused-clean-column feeder
if that is the only missing dependency.  The root product-to-coefficient
obligation remains open and must not be marked proved by this bridge.
