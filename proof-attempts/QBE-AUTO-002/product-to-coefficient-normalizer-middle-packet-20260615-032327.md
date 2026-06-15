# Product-To-Coefficient/Normalizer Middle Packet

Task id: `QBE-AUTO-002`
Run: `20260615-032327-QBE-AUTO-002-cycle01`
Mode: `faithfulPaper`
Created: `2026-06-15 03:32 JST`

## Source Status

The local TeX archive named by the run context is not present in this
workspace. Public source correspondence for this packet therefore uses the
maintained GHL2025 proof notes, conversion window, proof-obligation ledger, and
`research-wiki/cited-results/GHL2025.md`, not a machine-specific path.

No cited-result row is upgraded by this packet. `H_W^(kappa)` preparation,
boundary `R_y`, function oracle, LCU/block composition, cleanup, unitarity, and
final extraction remain contract-only or open obligations unless a compiled
Lean declaration already states the exact local fact used below.

## Definitions

`FixedProductObligation` means:

```lean
oneTermRobinGamma3ProductToCoefficientObligation 3
  ⟨0, by native_decide⟩ ⟨0, by native_decide⟩
```

`SourceSlot2Product(H, env)` means the compiled source-prepared slot-`2`
projection/product equality:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3
  H env hUniform hentry
```

where

```lean
hUniform :
  oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
hentry :
  env "boundary_cos_half_0_2" =
    Coeff.evalWith env
      (GHL2025.boundaryRotationNormalizedCoefficient
        (oneTermParameters 3) 0 2)
```

`FocusedCleanColumn(H)` is the single clean-column entry needed by the compiled
product route:

```lean
H
  ⟨oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3.cleanColumnFactorRoute.uniformColumnRowIndex,
    by native_decide⟩
  ⟨oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3.cleanColumnFactorRoute.uniformColumnColIndex,
    by native_decide⟩ =
  oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3.cleanColumnFactorRoute.expectedUniformColumnEntry
```

It should be derived from `hUniform` at sparse slot `⟨2, by native_decide⟩`;
it is not a new source assumption.

`NormalizerEnv(env)` means the explicit coefficient hypotheses:

```lean
hND : env "N_D_inv" * env "N_D" = 1
hNF : env "N_f_inv" * env "N_f" = 1
hkappa : env "kappa_inv" * env "kappa" = 1
hkappaSqrt :
  env "sqrt_kappa_inv" * env "sqrt_kappa_inv" =
    env "kappa_inv"
```

## Proof Translation Map

| Source anchor | Proof step | Lean status |
|---|---|---|
| GHL2025 Theorem `theorem: 1 term robin` | focused gamma3 boundary contribution must feed the one-term block-encoding coefficient statement | root obligation remains `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`, with `proved = false` |
| Eq. `ROBIN clarified` | focused `(0,0)` gamma3 coefficient uses sparse slot `2` and the boundary factor product | compiled conditional algebra in `oneTermRobinGamma3BoundaryProductUnderContractsEval_n3`; active bridge still conditional |
| Eq. `arbitrary sparcity` | sparse preparation supplies the clean-column amplitude for every sparse slot | contract-only `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; cited-results row remains an obligation |
| Eq. `angles for Ry` | boundary branch uses the source-supported `boundary_cos_half_0_2` entry convention | explicit hypothesis `hentry`; no boundary rotation theorem is promoted |
| Fig. `fig:1 term ROBIN` | source-prepared clean projection is the source-facing route, while the seven-gate backend is only an inner component | compiled `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`; raw backend expansion remains forbidden |
| Definition `def:block-encoding` | clean projection must eventually be compared with the normalized block target | normalized-block equality, LCU, block projection/correctness, and final extraction flags remain false |
| Cited LCU/block-composition result | final theorem may use a precise contract later | `LCU.StandardBlockEncoding` remains a cited-results obligation, not a local proof in this packet |

## Active Lean Leaf

Lower2 may edit only `QuantumBlockEncoding/RobinMatrix.lean`. The next
theorem-facing Lean leaf is:

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

Expected proof route:

1. Use
   `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3
   H env hUniform hentry` to rewrite the source-prepared projection entry to
   `projectedBranchProduct`.
2. Derive the focused clean-column hypothesis from
   `hUniform ⟨2, by native_decide⟩`.
3. Use
   `oneTermRobinGamma3BoundaryProductUnderContractsEval_n3 env H hCleanColumn
   hND hNF hkappa hkappaSqrt` and take the product equality component.
4. Close all record-field false flags by `rfl` or `dsimp` only.

If step 2 is the only blocker, lower2 may first prove this smaller feeder in
the same file:

```lean
theorem oneTermRobinGamma3BoundaryHWKappaUniformAllSlots_to_productRouteFocusedCleanColumn_n3
    (H : Matrix 8 8 Coeff)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    H
      ⟨oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3.cleanColumnFactorRoute.uniformColumnRowIndex,
        by native_decide⟩
      ⟨oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3.cleanColumnFactorRoute.uniformColumnColIndex,
        by native_decide⟩ =
      oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3.cleanColumnFactorRoute.expectedUniformColumnEntry
```

That feeder is allowed only as a direct dependency of
`oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3`.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_sparse_uniform_contract` | all sparse slots have clean-column amplitude `sqrt_kappa_inv` | GHL2025 Eq. `arbitrary sparcity`; Shukla--Vedula cited row | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | `research-wiki/cited-results/GHL2025.md` | contract only | external obligation |
| `source_slot2_product_fixed_map_guard` | source-prepared slot-`2` entry feeds the fixed product map | source uniform contract; boundary entry convention | none | `oneTermRobinGamma3BoundarySourcePreparedProjectionSlot2Product_feedsFixedProductMap_n3` | retarget packet `backend-expansion-route-retarget-middle-packet-20260615-030358.md` | already compiled | retired as lower target |
| `focused_clean_column_from_all_slots` | derive the focused route clean-column hypothesis from the all-slot contract | `source_sparse_uniform_contract` | lower2 only if needed | proposed `oneTermRobinGamma3BoundaryHWKappaUniformAllSlots_to_productRouteFocusedCleanColumn_n3` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | optional feeder |
| `conditional_normalizer_product_bridge` | source-prepared slot-`2` product times theorem normalizer equals the expected target entry under explicit coefficient hypotheses | slot-`2` bridge; focused clean column; compiled product-under-contracts eval | lower2 | proposed `oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3` | this packet | same gate | active leaf |
| `fixed_product_to_coefficient_3_0_0` | close `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | conditional normalizer bridge plus finite normalized-block/projection bridge and cited LCU contract | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 ⟨0,_⟩ ⟨0,_⟩` | proof obligations ledger | same gate plus proof-map sync | open root |
| `backend_expansion_raw_no_go` | unchanged raw backend expansion or any `SignalEntryFold`-equivalent proposition | compiled finite counterexample | none | `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` | verifier feedback | none | refuted; forbidden |

## Lower-Agent Packets

lower1 natural-language proof architect:
Append a narrow postscript that validates the proof map above. Do not search
for another raw backend-expansion target. Confirm that
`conditional_normalizer_product_bridge` uses only the source-prepared slot-`2`
product equality, the all-slot clean-column contract, and explicit coefficient
hypotheses.

lower2 Lean implementation worker:
Edit only `QuantumBlockEncoding/RobinMatrix.lean`. Prove exactly
`oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3`, or
the smaller all-slots-to-focused-clean-column feeder if that feeder is the only
blocker. Do not promote `oneTermRobinGamma3ProductToCoefficientObligation 3 0
0`, normalized-block equality, LCU correctness, block correctness, final
extraction, oracle correctness, unitarity, or resource claims.

lower3 necessary-condition verifier:
Check the source-prepared route, slot/register shape, focused slot `2`, clean
index `0`, boundary entry convention, and false downstream flags. The finite
matrix shape for the guard is accepted, but the root product-to-coefficient
theorem remains open.

## Verifier Feedback Template

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
error_class=symbolic_bridge_gap
next_route=prove oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3; do not revive backendExpansionStatement
```

No oracle, `H_W`, boundary `R_y`, LCU/block composition, oracle correctness,
unitarity, normalized block equality, block correctness, final extraction,
resource, normalizer-free, or product-to-coefficient flag is promoted by this
middle packet.
