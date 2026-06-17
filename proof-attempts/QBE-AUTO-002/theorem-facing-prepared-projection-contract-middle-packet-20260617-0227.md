# Theorem-Facing Prepared Projection Contract Packet

Task: `QBE-AUTO-002`  
Run: `20260617-022209-QBE-AUTO-002-cycle01`  
Role: middle coordinator synthesis  
Mode: `paperBenchmark`  
Prepared: `2026-06-17 02:27 JST`

## Source Object

The active source object remains GHL2025 Theorem `theorem: 1 term robin`, the
one-term Robin block-encoding theorem treated as Theorem 3 for this run.  The
source audit uses the local TeX only as a working copy and records public
anchors as Eq. `eq: arbitrary sparcity`, Eq. `eq:angles for Ry`, Eq.
`eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, and Definition
`def:block-encoding`.

The source proof route is the clean projection of the Fig.
`fig:1 term ROBIN` prepared circuit, specialized to the boundary gamma3 slot
`2` branch in Eq. `eq: ROBIN clarified`.  It is not the universal equality
between the H-free active seven-gate entry and an arbitrary prepared matrix
`H`.

## Definitions

`ProjectionInterface(H, env)` is:

```lean
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3 H env
```

`SourcePreparedProjectionTarget(H, env)` is:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env
```

`PreparedProjectionEntry(H, env)` is:

```lean
(ProjectionInterface(H, env)).sourcePreparedProjectionEntry
```

`FixedProductObligation` is:

```lean
oneTermRobinGamma3ProductToCoefficientObligation 3 0 0
```

## Source-Dependency Classification

| Missing or tempting ingredient | Classification | Decision |
|---|---|---|
| Universal active/prepared field `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement` | `source_translation_gap` plus lower3 `finite_matrix_counterexample` for the unconstrained H-free route | retire as lower2 target unless upper/middle restate it with a source-backed prepared contract |
| Prepared clean projection to slot-`2` projected branch product | `internal-paper-step` plus QBE-local interface theorem | source-backed active leaf |
| `H_W^(kappa)` clean-column behavior | `external-cited-result` already represented by `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | use as explicit contract only |
| Normalizer and boundary coefficient identities | internal coefficient algebra under explicit hypotheses | compiled route memory through `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3` |
| Root product-to-coefficient theorem | final theorem-facing coefficient/block proof | still blocked; do not assign lower2 directly |

No new cited-result row is needed.  The existing `GHL2025` cited-results rows
remain contract-only where they are not build-tested Lean theorems.

## Proof Translation Map

| Paper step | Lean object | Status |
|---|---|---|
| Definition `def:block-encoding` selects the clean signal block. | `ProjectionInterface(H, env).sourcePreparedProjectionEntry` | prepared-projection side is the current contract surface |
| Fig. `fig:1 term ROBIN` includes the sparse-preparation side gates and cleanup. | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | compiled transcript guard |
| Eq. `eq: arbitrary sparcity` supplies `H_W^(kappa)|0> = kappa^{-1/2} sum_s |s>`. | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | explicit external contract |
| Eq. `eq:angles for Ry` supplies the boundary rotation coefficient for slot `2`. | `hentry` in the planned lower2 theorem | explicit hypothesis |
| Eq. `eq: ROBIN clarified` gives the gamma3 boundary branch with normalizer `N_D N_f kappa`. | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` and `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3` | compiled route memory |

## Current DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `projection_interface_normalizer_bridge` | source-prepared slot-`2` product times theorem normalizer exposed through `ProjectionInterface(H, env)` fields | source slot-`2` product bridge, normalizer identities | none | `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3` | previous normalizer packet | previous gate | compiled route memory |
| `rejected_universal_active_prepared_field` | H-free active seven-gate entry equals arbitrary prepared singleton clean entry | active/prepared field target, lower3 finite diagnostic | none | `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement` | lower1/lower3 feedback | previous gate only | rejected as current lower2 target |
| `prepared_projection_contract_leaf` | theorem-facing prepared projection entry equals the focused slot-`2` projected branch product while all theorem flags remain false | prepared projection target, slot-`2` product bridge, false-flag interface | lower2 | planned `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_preparedProjectionSlot2Product_n3` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | next active Lean leaf |
| `fixed_product_to_coefficient` | focused coefficient/product equality for `(n,i,j) = (3,0,0)` | prepared projection contract, compiled normalizer bridge, final coefficient algebra | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | proof-obligation ledger | full gate plus proof-map sync | blocked |
| `post_baseline_candidate_population` | candidates for the same operator scored by `(depth, gateCount, auxiliaryQubits, oracleCalls)` | GHL baseline root closed first | later middle | no active Lean target | task directive | not run | deferred |
| `fallback_optctrl_operator` | OPTCTRL rank-one time/type partial-isometry operator tensored with `I_n` | baseline closure plus stagnation in improvement search | later middle | planned `QuantumBlockEncoding/OptimalControl.lean` | `tasks/QBE-OP-OPTCTRL-001.md` | not run | deferred |

## Lower-Agent Split

| Lower role | Packet | Write scope | Acceptance |
|---|---|---|---|
| lower1 proof architect | Check that the prepared projection contract is exactly the source-prepared Fig. `fig:1 term ROBIN` clean projection and not the rejected H-free active/prepared field. | Markdown proof-attempt note only | source correspondence map with `source_correspondence_ok=true` for the prepared projection contract |
| lower2 Lean worker | Add exactly one theorem in `QuantumBlockEncoding/RobinMatrix.lean`: `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_preparedProjectionSlot2Product_n3`. | `QuantumBlockEncoding/RobinMatrix.lean` only | gate passes and every product/block/oracle/unitary/resource flag in the theorem statement remains false |
| lower3 verifier | Before lower2 spends tactic effort, check the theorem statement uses `interface.sourcePreparedProjectionEntry`, not `activeToPreparedSingletonEvalStatement`; check branch slot `2`, signal block `[0,0]`, false flags, and gate counts `10` versus `7`. | `verifier-feedback/QBE-AUTO-002/` | typed feedback with `finite_matrix_ok=true_for_prepared_projection_contract` or a concrete counterexample |

## Lower2 Lean Contract

The planned theorem should be a non-promoting wrapper over existing route
memory:

```lean
theorem
    oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_preparedProjectionSlot2Product_n3
    (H : Matrix 8 8 Coeff) (env : String -> Rat)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H)
    (hentry :
      env "boundary_cos_half_0_2" =
        Coeff.evalWith env
          (GHL2025.boundaryRotationNormalizedCoefficient
            (oneTermParameters 3) 0 2)) :
    let interface :=
      oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3
        H env
    Coeff.evalWith env interface.sourcePreparedProjectionEntry =
        Coeff.evalWith env
          oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct /\
      interface.sourcePreparedProjectionEntry =
        (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
          H env).preparedProjectionEntry /\
      interface.correctedFiniteBlockProjectionEquality.proved = false /\
      interface.correctedFiniteBlockProjectionEqualityProved = false /\
      interface.fixedProductObligation.proved = false /\
      interface.finiteBlockNormalizedEquality.proved = false /\
      interface.finiteBlockProjectionObligation.proved = false /\
      interface.finiteBlockLCUCompositionObligation.proved = false /\
      interface.finiteBlockFinalExtractionObligation.proved = false /\
      interface.normalizedBlockEqualityProved = false /\
      interface.productToCoefficientProved = false /\
      interface.lcuCorrectProved = false /\
      interface.blockProjectionProved = false /\
      interface.blockCorrectProved = false /\
      interface.finalExtractionProved = false /\
      interface.oracleCorrectProved = false /\
      interface.unitaryProved = false /\
      interface.resourceClaimProved = false := by
  -- expected route:
  -- use oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3
  -- then unfold the theorem-facing interface and close the false flags by rfl.
```

Lower2 must not prove or assume:

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
oneTermRobinGamma3ProductToCoefficientObligation 3 0 0
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
(oneTermRobinFiniteBlockCompositionContract 3).normalizedBlockEquality
```

## Deferred Ledgers

The post-baseline improvement population remains a placeholder only until the
GHL baseline root closes.  The fallback `QBE-OP-OPTCTRL-001` operator contract
exists and remains deferred.  No candidate score is recorded in this packet
because no improved candidate is Lean-checked.
