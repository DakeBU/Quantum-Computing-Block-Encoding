# Product-To-Coefficient Normalizer Middle Synthesis

Task id: `QBE-AUTO-002`
Run: `20260615-034853-QBE-AUTO-002-cycle01`
Role: middle coordinator synthesis
Mode: `faithfulPaper`
Created: `2026-06-15 03:55 JST`

## Source Status

The run-provided repo-relative TeX path
`outer_papers/quantum/GHL2025/main.tex` is absent in this checkout. The parent
source archive `../outer_papers/quantum/GHL2025/main.tex` is present and was
inspected after lower completion. Public source correspondence still cites the
stable source anchors already recorded in the conversion window,
proof-obligation ledger, proof notes, and `research-wiki/cited-results/GHL2025.md`,
not a machine-specific local path.

The active source anchors are GHL2025 Theorem `theorem: 1 term robin`, Eq.
`ROBIN clarified`, Eq. `arbitrary sparcity`, Eq. `angles for Ry`, Fig.
`fig:1 term ROBIN`, Definition `def:block-encoding`, and the cited
LCU/block-composition row. No cited-result row is upgraded by this synthesis.

## Definitions

`FixedProductObligation` denotes:

```lean
oneTermRobinGamma3ProductToCoefficientObligation 3
  ⟨0, by native_decide⟩ ⟨0, by native_decide⟩
```

`SourceSlot2Product(H, env)` denotes the compiled source-prepared slot-`2`
projection/product equality:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3
  H env hUniform hentry
```

`FocusedCleanColumn(H)` denotes the single clean-column hypothesis consumed by
`oneTermRobinGamma3BoundaryProductUnderContractsEval_n3`. It should come from
`hUniform ⟨2, by native_decide⟩`; it is not a new source assumption.

`NormalizerEnv(env)` denotes the four explicit coefficient identities:

```lean
hND : env "N_D_inv" * env "N_D" = 1
hNF : env "N_f_inv" * env "N_f" = 1
hkappa : env "kappa_inv" * env "kappa" = 1
hkappaSqrt :
  env "sqrt_kappa_inv" * env "sqrt_kappa_inv" =
    env "kappa_inv"
```

## Active Theorem

The only current lower2 theorem target is:

```lean
oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3
```

This theorem is a non-promoting conditional bridge. It combines the compiled
source slot-`2` product equality with
`oneTermRobinGamma3BoundaryProductUnderContractsEval_n3` under explicit
normalizer hypotheses. It must leave `FixedProductObligation.proved = false`
and must not set any normalized-block, LCU, block, final-extraction, oracle,
unitarity, resource, or product-to-coefficient flag to true.

If the clean-column specialization is the only blocker, lower2 may first prove:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformAllSlots_to_productRouteFocusedCleanColumn_n3
```

This feeder is allowed only as a direct dependency of the active theorem.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_sparse_uniform_contract` | all sparse slots have clean-column amplitude `sqrt_kappa_inv` | GHL2025 Eq. `arbitrary sparcity`; Shukla--Vedula cited row | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results ledger | contract only | external obligation |
| `source_slot2_product_fixed_map_guard` | source-prepared slot-`2` product feeds the fixed product map while flags stay false | source uniform contract; boundary entry convention | none | `oneTermRobinGamma3BoundarySourcePreparedProjectionSlot2Product_feedsFixedProductMap_n3` | retarget packets and lower1 03:46 postscript | previous full gate | compiled; stale as lower target |
| `focused_clean_column_from_all_slots` | derive the product route clean-column hypothesis from the all-slot contract | source uniform contract; product-route transcript | lower2 only if needed | proposed `oneTermRobinGamma3BoundaryHWKappaUniformAllSlots_to_productRouteFocusedCleanColumn_n3` | middle packet and this synthesis | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | optional feeder |
| `conditional_normalizer_product_bridge` | source-prepared slot-`2` product times theorem normalizer equals the expected target entry under explicit hypotheses | source slot-`2` product; focused clean column; `oneTermRobinGamma3BoundaryProductUnderContractsEval_n3` | lower2 | proposed `oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3` | this synthesis and `product-to-coefficient-normalizer-middle-packet-20260615-032327.md` | same gate | active leaf |
| `fixed_product_to_coefficient_3_0_0` | close the exact focused root obligation | conditional bridge plus later finite normalized-block/projection bridge and cited LCU contract | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 ⟨0,_⟩ ⟨0,_⟩` | proof-obligation ledger | same gate plus proof-map sync | open root |
| `backend_expansion_raw_no_go` | unchanged raw backend expansion and any `SignalEntryFold`-equivalent proposition | compiled finite counterexample | none | `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` | backend-expansion correction packets | none | refuted; forbidden |

## Lower Packets

lower1 should validate the source correspondence and proof-DAG map above. It
must not search for another raw branch-sum target.

lower2 may edit only `QuantumBlockEncoding/RobinMatrix.lean`. It must prove
exactly `oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3`,
or the optional feeder only if that feeder is the direct blocker.

lower3 should record typed feedback for `conditional_normalizer_product_bridge`
with `source_correspondence_ok=true`, `finite_matrix_ok=true`,
`normalizer_ok=conditional_under_explicit_hypotheses`,
`closed_theorem_ok=false`, `product_to_coefficient=false`, and
`error_class=symbolic_bridge_gap` unless lower2 closes the exact active theorem.

## Verifier Feedback

```text
leaf=conditional_normalizer_product_bridge
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=true
block_entry_ok=false
ancilla_cleanup_ok=null
normalizer_ok=conditional_under_explicit_hypotheses
closed_theorem_ok=false
product_to_coefficient=false
error_class=symbolic_bridge_gap
next_route=prove oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3, optionally through oneTermRobinGamma3BoundaryHWKappaUniformAllSlots_to_productRouteFocusedCleanColumn_n3; do not revive backendExpansionStatement
```

## Handoff

This synthesis retires the compiled guard as route memory for the current run
and keeps the active lower2 target fixed on the conditional normalizer/product
bridge. The root `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`
remains open.

## Post-Lower Lean Status

Lower2 closed the assigned active leaf in `QuantumBlockEncoding/RobinMatrix.lean`:

```lean
oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3
```

Lower2 also added the allowed direct feeder:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformAllSlots_to_productRouteFocusedCleanColumn_n3
```

The compiled bridge keeps `packet.fixedProductObligation.proved = false` and
keeps the product, normalized-block, LCU, block-projection, block-correctness,
and final-extraction flags false. The root
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains open.

Accepted feedback after lower2:

```text
leaf=conditional_normalizer_product_bridge
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
block_entry_ok=true
normalizer_ok=compiled_conditional_under_explicit_hypotheses
closed_theorem_ok=true
product_to_coefficient=false
error_class=null
next_route=use the compiled conditional bridge as route memory; next proof work must target the remaining finite normalized-block/projection bridge for oneTermRobinGamma3ProductToCoefficientObligation 3 0 0, not the retired backendExpansionStatement
```
