# Product-To-Coefficient Normalizer Lower1 Proof Architect

Task: `QBE-AUTO-002`
Run: `20260615-034853-QBE-AUTO-002-cycle01`
Role: lower1 natural-language proof architect
Mode: `faithfulPaper`
Created: `2026-06-15 03:48 JST`

## Source Correspondence

The local TeX archive path named by the run context,
`outer_papers/quantum/GHL2025/main.tex`, is absent in this checkout. This
artifact therefore validates the active source correspondence through the
maintained source-map artifacts and the current run synthesis:
`proof-attempts/QBE-AUTO-002/product-to-coefficient-normalizer-middle-packet-20260615-032327.md`,
`proof-attempts/QBE-AUTO-002/product-to-coefficient-normalizer-lower1-proof-architect-20260615-034610.md`,
`runs/20260615-034853-QBE-AUTO-002-cycle01/dialogue.md`, the conversion window,
the proof-obligation ledger, and `research-wiki/cited-results/GHL2025.md`.

The active source fragment is the focused gamma3 boundary contribution for
system entry `(0,0)` and sparse slot `2`. The source anchors remain GHL2025
Theorem `theorem: 1 term robin`, Eq. `ROBIN clarified`, Eq.
`arbitrary sparcity`, Eq. `angles for Ry`, Fig. `fig:1 term ROBIN`,
Definition `def:block-encoding`, and the cited LCU/block-composition row.

The current lower-facing proof route is source-prepared and conditional. It
uses the compiled slot-`2` source-prepared product equality, the all-slot
clean-column contract specialized to slot `2`, and explicit coefficient
normalizer hypotheses. It does not use, search for, or assign the raw
`backendExpansionStatement` or any `SignalEntryFold`-equivalent target. Those
routes remain forbidden by
`oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3`.

## Active Lean Target

The exact active lower2 target is:

```lean
theorem oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H)
    (hentry :
      env "boundary_cos_half_0_2" =
        Coeff.evalWith env
          (GHL2025.boundaryRotationNormalizedCoefficient
            (oneTermParameters 3) 0 2))
    (hND : env "N_D_inv" * env "N_D" = 1)
    (hNF : env "N_f_inv" * env "N_f" = 1)
    (hkappa : env "kappa_inv" * env "kappa" = 1)
    (hkappaSqrt :
      env "sqrt_kappa_inv" * env "sqrt_kappa_inv" =
        env "kappa_inv") :
    let packet :=
      oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3
        H env
    let productRoute :=
      oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3
    Coeff.evalWith env packet.sourceTarget.preparedProjectionEntry *
        Coeff.evalWith env productRoute.theoremNormalizer =
      Coeff.evalWith env productRoute.expectedTargetEntry ∧
    packet.fixedProductObligation =
      oneTermRobinGamma3ProductToCoefficientObligation 3
        ⟨0, by native_decide⟩ ⟨0, by native_decide⟩ ∧
    packet.fixedProductObligation.proved = false ∧
    productRoute.productObligation.proved = false ∧
    productRoute.productToCoefficientProved = false ∧
    productRoute.normalizedBlockEqualityProved = false ∧
    productRoute.lcuCorrectProved = false ∧
    productRoute.blockProjectionProved = false ∧
    productRoute.blockCorrectProved = false ∧
    productRoute.finalExtractionProved = false
```

The displayed signature is the Lean-facing contract from the middle packet.

If and only if the all-slot-to-focused-clean-column rewrite is the direct
blocker, the permitted feeder is:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformAllSlots_to_productRouteFocusedCleanColumn_n3
```

## Dependencies

The active bridge depends on these existing declarations or contracts:

| Dependency | Role | Status |
|---|---|---|
| `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | rewrites the source-prepared clean projection entry to the focused slot-`2` projected branch product | compiled |
| `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | contract-level all-slot clean-column source input from Eq. `arbitrary sparcity` | external/source contract |
| `oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3` | names the route normalizer, expected target entry, clean-column indices, and false downstream flags | compiled packet |
| `oneTermRobinGamma3BoundaryProductUnderContractsEval_n3` | gives the conditional product-times-normalizer equality under the focused clean-column and coefficient hypotheses | compiled |
| `oneTermRobinGamma3BoundaryHWKappaUniformAllSlots_to_productRouteFocusedCleanColumn_n3` | optional feeder specializing `hUniform` to the product route's focused clean column | proposed only if needed |
| `oneTermRobinGamma3ProductToCoefficientObligation 3 ⟨0,_⟩ ⟨0,_⟩` | fixed root obligation that this bridge points to but must leave unproved | open |
| `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` | finite counterexample forbidding raw backend expansion and `SignalEntryFold` routes | compiled no-go |

The expected proof shape is unchanged from the middle packet: rewrite the
prepared projection entry by the compiled slot-`2` source-prepared product
equality, specialize the all-slot contract to the product route's focused clean
column, apply
`oneTermRobinGamma3BoundaryProductUnderContractsEval_n3`, and close only the
bookkeeping false-flag conjuncts by definitional reduction.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_sparse_uniform_contract` | all sparse slots have the clean-column amplitude required by the source preparation | GHL2025 Eq. `arbitrary sparcity`; cited sparse-preparation row | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results ledger and middle packet | contract only | external obligation |
| `source_slot2_product_fixed_map_guard` | source-prepared slot-`2` product feeds the fixed product map while downstream flags remain false | source uniform contract; boundary `R_y` entry convention | none | `oneTermRobinGamma3BoundarySourcePreparedProjectionSlot2Product_feedsFixedProductMap_n3` | retarget packet and lower1 03:46 postscript | full gate already passed earlier | compiled; stale as lower target |
| `focused_clean_column_from_all_slots` | derive the product route focused clean-column hypothesis from `hUniform` at sparse slot `2` | `source_sparse_uniform_contract`; product-route transcript | lower2 only if needed | proposed `oneTermRobinGamma3BoundaryHWKappaUniformAllSlots_to_productRouteFocusedCleanColumn_n3` | middle packet and this artifact | `lake build && lake build Tests` | optional feeder |
| `conditional_normalizer_product_bridge` | source-prepared slot-`2` product times theorem normalizer equals the expected target entry under explicit normalizer hypotheses | source slot-`2` product equality; focused clean column; `oneTermRobinGamma3BoundaryProductUnderContractsEval_n3` | lower2 | proposed `oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3` | middle packet and this artifact | `lake build && lake build Tests` | active leaf |
| `fixed_product_to_coefficient_3_0_0` | close `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | conditional bridge plus finite normalized-block/projection bridge and cited LCU contract | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 ⟨0,_⟩ ⟨0,_⟩` | proof-obligation ledger | full gate plus proof-map sync | open root |
| `backend_expansion_raw_no_go` | raw backend expansion and any `SignalEntryFold`-equivalent route | compiled finite counterexample | none | `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` | verifier feedback and correction packets | none | refuted; forbidden |

## Typed Feedback

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
next_route=prove oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3, optionally through oneTermRobinGamma3BoundaryHWKappaUniformAllSlots_to_productRouteFocusedCleanColumn_n3 only if the focused clean-column specialization blocks the bridge; do not revive backendExpansionStatement or SignalEntryFold
```

## Changed File Paths

```text
proof-attempts/QBE-AUTO-002/product-to-coefficient-normalizer-lower1-proof-architect-20260615-034853.md
```

No Lean file, verifier-feedback JSON, dialogue note, or trial log was edited by
this lower1 artifact.
