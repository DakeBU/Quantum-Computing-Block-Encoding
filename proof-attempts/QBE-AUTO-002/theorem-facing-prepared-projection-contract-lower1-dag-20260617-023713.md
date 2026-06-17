# Lower1 Proof Design: Theorem-Facing Prepared Projection Contract

Task: `QBE-AUTO-002`  
Run: `20260617-022209-QBE-AUTO-002-cycle01`  
Role: lower natural-language proof architect  
Mode: `paperBenchmark`  
Created: `2026-06-17 02:37 JST`

## Source Fragment

The local source check confirms that the active GHL anchor is Theorem
`theorem: 1 term robin`, the one-term Robin block-encoding theorem treated as
Theorem 3 for this run.  The exact source fragment translated by this leaf is
the clean projection of Fig. `fig:1 term ROBIN`, specialized to the boundary
`gamma3` branch in Eq. `eq: ROBIN clarified`.

The relevant source equations are:

| Source anchor | Paper object used by this leaf | Lean-facing object |
|---|---|---|
| Eq. `eq: arbitrary sparcity` | $H_W^{(\kappa)}|0> = \kappa^{-1/2}\sum_s |s>$ | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` |
| Eq. `eq:angles for Ry` | $\theta_j^s = \arccos(D_j^{(s)}/N_D)$ for Robin boundary entries | hypothesis `hentry` for `boundary_cos_half_0_2` |
| Eq. `eq: ROBIN clarified` | the boundary `gamma3` summand has normalizer $N_D N_f \kappa$ and slot sum over $s$ | slot-`2` projected branch product |
| Fig. `fig:1 term ROBIN` | theorem-facing prepared circuit includes both sparse-preparation side gates | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` |
| Definition `def:block-encoding` | read the clean block/projection entry | `interface.sourcePreparedProjectionEntry` |

This leaf does not translate the rejected universal equality between the
H-free active seven-gate entry and an arbitrary prepared matrix `H`.

## Definitions

For fixed `H : Matrix 8 8 Coeff` and `env : String -> Rat`, define:

| Name | Meaning | Lean expression |
|---|---|---|
| `ProjectionInterface(H, env)` | theorem-facing finite block/projection interface | `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3 H env` |
| `PreparedProjectionEntry(H, env)` | clean entry selected by the theorem-facing prepared route | `ProjectionInterface(H, env).sourcePreparedProjectionEntry` |
| `SourcePreparedTarget(H, env)` | source-prepared projection target record | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env` |
| `Slot2Product(env)` | focused gamma3 boundary slot-`2` projected branch product | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct` |
| `Uniform(H)` | explicit all-slot sparse-preparation clean-column contract | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` |
| `FixedProductObligation` | root product theorem still blocked after this leaf | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` |

## Natural-Language Proof

The local theorem to compile is:

```lean
oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_preparedProjectionSlot2Product_n3
```

It should state, under `Uniform(H)` and the boundary-entry hypothesis `hentry`,
that:

```lean
Coeff.evalWith env interface.sourcePreparedProjectionEntry =
  Coeff.evalWith env
    oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct
```

for

```lean
interface :=
  oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3 H env
```

The proof is a wrapper over compiled route memory.  First unfold
`ProjectionInterface(H, env)`.  Its field `sourcePreparedProjectionEntry` is
definitionally the field `preparedProjectionEntry` of
`SourcePreparedTarget(H, env)`.  The transcript theorem for the interface also
records this field equality, but the proof should only need `dsimp` and `rfl`.

Second apply:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3
  H env hUniform hentry
```

This theorem already composes the prepared projection-to-backend bridge with
the slot-`2` backend-fold-to-product bridge.  The sparse-preparation contract
enters only through `hUniform`, and the boundary rotation convention enters
only through `hentry`.

Third close the bookkeeping fields by definitional equality.  The theorem must
leave false:

```lean
interface.correctedFiniteBlockProjectionEquality.proved
interface.correctedFiniteBlockProjectionEqualityProved
interface.fixedProductObligation.proved
interface.finiteBlockNormalizedEquality.proved
interface.finiteBlockProjectionObligation.proved
interface.finiteBlockLCUCompositionObligation.proved
interface.finiteBlockFinalExtractionObligation.proved
interface.normalizedBlockEqualityProved
interface.productToCoefficientProved
interface.lcuCorrectProved
interface.blockProjectionProved
interface.blockCorrectProved
interface.finalExtractionProved
interface.oracleCorrectProved
interface.unitaryProved
interface.resourceClaimProved
```

This is an internal paper step plus QBE-local interface theorem.  It is not a
proof of the fixed product-to-coefficient theorem, not a proof of finite LCU
composition, and not a substitution of the theorem-facing Fig. `fig:1 term
ROBIN` circuit for the active backend contract.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_uniform_contract` | clean-column behavior of $H_W^{(\kappa)}$ on sparse slots | Eq. `eq: arbitrary sparcity`; Shukla--Vedula cited contract | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results `GHL2025.md` | contract only | explicit external contract |
| `boundary_entry_contract` | slot-`2` Robin boundary rotation coefficient convention | Eq. `eq:angles for Ry` | lower2 hypothesis | `hentry` | middle packet | theorem-local hypothesis | explicit hypothesis |
| `source_projection_slot2_product` | prepared projection entry evaluates to focused slot-`2` product | `source_uniform_contract`; `boundary_entry_contract` | none | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | source-prepared product/projection notes | previous gate | compiled route memory |
| `projection_interface_normalizer_bridge` | prepared entry times theorem normalizer exposed through interface fields | slot-`2` product bridge; normalizer hypotheses | none | `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3` | normalizer packet | previous gate | compiled route memory |
| `rejected_universal_active_prepared_field` | H-free active seven-gate entry equals arbitrary prepared singleton clean entry | active/backend route; lower3 finite diagnostic | none | `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement` | lower1/lower3 02:19 feedback | previous gate only | rejected current route |
| `prepared_projection_contract_leaf` | theorem-facing prepared projection entry equals slot-`2` product and preserves all false flags | `source_projection_slot2_product`; projection interface | lower3 shape check, then lower2 | planned `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_preparedProjectionSlot2Product_n3` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | next active Lean leaf |
| `fixed_product_to_coefficient` | coefficient/product equality for `(n,i,j) = (3,0,0)` | prepared projection contract; normalizer bridge; final coefficient algebra | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | proof-obligation ledger | full gate plus proof-map sync | blocked |

Next active leaf for the Lean worker: compile only
`oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_preparedProjectionSlot2Product_n3`
after lower3 confirms the theorem statement uses
`interface.sourcePreparedProjectionEntry` and preserves the false flags.

## Intermediate Lean Lemmas

Reuse these declarations in dependency order:

1. `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`.
2. `GHL2025.oneTermRobinActiveBackendCircuit_gateList`.
3. `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3_transcript`.
4. `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`.
5. `oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3`.
6. `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3`.
7. `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`.
8. `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3`.
9. `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3_transcript`.
10. `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3`.

Use these only as rejection or guard evidence:

- `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`.
- `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3`.
- `oneTermRobinGamma3BoundarySourcePreparedActiveEval_forces_selectedSlotContribution_zero_n3`.
- `oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3`.
- `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3`.

## Failure Analysis

The prepared projection contract is source-backed.  It names the clean prepared
projection entry of the Fig. `fig:1 term ROBIN` route and compares it with the
focused slot-`2` product already compiled from the source-prepared bridge.

The rejected universal active/prepared field remains mathematically wrong as a
current lower2 target.  It compares the H-free active seven-gate entry with a
prepared entry depending on free `H`.  Lower3's finite all-one diagnostic shows
that, under the existing clean-column contract, that route would force the
selected slot contribution to evaluate to `0`, while the selected-slot
diagnostic evaluates it to `1`.  This is a `source_translation_gap` plus a
`finite_matrix_counterexample` for the rejected route, not an invitation to add
assumptions or mutate the paper circuit.

If lower2 cannot close the prepared projection contract with `dsimp` plus the
compiled slot-`2` theorem, the likely issue is only a Lean field-unfolding or
theorem statement shape mismatch.  The next route should then be a smaller
field-unfolding lemma:

```lean
(oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3
  H env).sourcePreparedProjectionEntry =
  (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
    H env).preparedProjectionEntry
```

No product, LCU, block-projection, final-extraction, oracle, unitary, resource,
or theorem normalizer flag should be promoted by this leaf.

## Typed Feedback

```text
leaf=theorem_facing_prepared_projection_contract
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=pending_lower3_shape_check; rejected_universal_route_has_finite_counterexample
block_entry_ok=prepared_projection_route_compiled_as_route_memory_not_root_closure
ancilla_cleanup_ok=null
normalizer_ok=compiled_route_memory_not_required_for_this_entry_wrapper
unitarity_ok=null
resource_score=null
closed_theorem_ok=false
error_class=symbolic_bridge_gap
secondary_error_class=source_translation_gap_for_rejected_universal_active_prepared_field
next_route=lower3 checks preparedProjectionEntry shape and false flags, then lower2 compiles oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_preparedProjectionSlot2Product_n3 using oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3
```

## Handoff

Lower1 source map for `theorem_facing_prepared_projection_contract` is
complete.  The leaf matches the GHL prepared clean projection route and should
not use `activeToPreparedSingletonEvalStatement`.  Send lower3 to check the
prepared-entry shape and flags, then lower2 should compile the planned wrapper
theorem only.  The GHL baseline root and all post-baseline improvement work
remain deferred.
