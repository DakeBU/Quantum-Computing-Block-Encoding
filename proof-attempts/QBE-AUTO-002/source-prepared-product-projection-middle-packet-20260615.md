# Source-Prepared Product/Projection Middle Packet

Task: `QBE-AUTO-002`
Run: `20260615-010153-QBE-AUTO-002-cycle01`
Mode: `faithfulPaper`

## Directive

Use the 2026-06-15 source-prepared product/projection directive in
`tasks/QBE-AUTO-002.md` and
`runs/20260615-010153-QBE-AUTO-002-cycle01/11_upper_director_synthesis.md`.
The stale 2026-06-13 finite-path feeder snippet in generated lower prompts is
retired.

The active Lean target is a packet, not theorem closure:

```lean
OneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation
oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3
```

The packet must start from the source-prepared clean projection of the full
Fig. `fig:1 term ROBIN` object:

```text
(H_W^(kappa))^dagger * U_gamma3_boundary * H_W^(kappa)
```

## Definitions

`SourcePreparedTarget(H, env)` means:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env
```

`FixedProductObligation` means:

```lean
oneTermRobinGamma3ProductToCoefficientObligation
  3 ⟨0, by native_decide⟩ ⟨0, by native_decide⟩
```

`ProductRoute` means:

```lean
oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3
```

`FiniteProductBridge` means:

```lean
oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3
```

`Uniform(H)` means:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

## Source Anchors

| Anchor | Packet role | Lean status |
|---|---|---|
| GHL2025 Eq. `arbitrary sparcity` | supplies only the clean-column contract for `H_W^(kappa)` | `Uniform(H)` is contract-only |
| GHL2025 Eq. `angles for Ry` | later boundary coefficient convention | not part of this packet |
| GHL2025 Theorem `theorem: 1 term robin` | theorem root and normalizer/resource claim | root remains open |
| GHL2025 Eq. `ROBIN clarified` | gamma3 boundary branch and fixed `(0,0)` coefficient route | product/coefficient obligation remains false |
| GHL2025 Fig. `fig:1 term ROBIN` | full prepared sandwich with both `H_W` sides | represented by `SourcePreparedTarget(H, env)` |
| GHL2025 Definition `def:block-encoding` | clean signal/system projection | represented by `PreparedProjectionEntry(H, env)` feeding `FixedProductObligation` |
| `paper-notes/GHL2025/markdown/fig4-visual-audit.zh.md` | separates full Fig. 4 from the H-free seven-gate backend component | must be cited by lower1/lower3 |

## Existing Lean Material To Reuse

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3
oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3
oneTermRobinGamma3BoundaryPreparedCleanEntryBackendEval_feedsFixedProductMap_n3
oneTermRobinGamma3BoundaryProductToCoefficientObligation_sourcePreparedTargetBackendEval_n3
oneTermRobinGamma3BoundaryProductToCoefficientObligation_preparedCompositeCleanEntryBackendEval_n3
oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3
oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3
oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3_transcript
oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3
```

## Required Packet Fields

The new Lean record should include at least:

```lean
sourceTarget
productRoute
productBridge
preparedBackendEvalStatement
fixedProductObligation
forbiddenBackendExpansionParent
preparedBackendEvalCompiled
productRouteConsumed
normalizedBlockEqualityProved
productToCoefficientProved
lcuCorrectProved
blockProjectionProved
blockCorrectProved
finalExtractionProved
exactRemainingObstruction
```

Required values:

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

Suggested `exactRemainingObstruction`:

```text
Need source-prepared slot-2 projection/product bridge, then normalizer algebra.
```

## Lower 1 Packet

Role: natural-language proof architect.

Write scope:
`proof-attempts/QBE-AUTO-002/source-prepared-product-projection-lower1-dag-20260615.md`.

Task:

1. Define the objects above before stating claims.
2. Translate the source anchors into a dependency table.
3. Explain why the packet is the next proof-DAG leaf and why
   `backendExpansionStatement` is forbidden.
4. Name the ready lower2 target exactly:
   `oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3`.
5. Name the first mathematical leaf after the packet:
   `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`,
   or the two-step split through
   `oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3` and
   `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3`.

Acceptance:
no Lean edits, no new assumptions, and no theorem-flag promotion.

## Lower 2 Packet

Role: Lean implementation worker.

Write scope:
`QuantumBlockEncoding/RobinMatrix.lean` only.

Primary target:
add the record, the `n = 3` instance, and a transcript theorem checking every
field listed above.  The theorem should close by `rfl`, `dsimp`, existing
transcript lemmas, or `native_decide`; it must not unfold giant matrix
products.

Optional follow-up only if the packet compiles quickly:

```lean
theorem oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    Coeff.evalWith env
      (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env)
        .preparedProjectionEntry =
    Coeff.evalWith env
      (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env)
        .backendBranchFold
```

This optional theorem should be a direct wrapper over
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`.

Acceptance:

- `python3 tools/qbe.py check`;
- `lake build`;
- `lake build Tests`;
- no new `sorry`, `admit`, axiom, or hidden semantic flag;
- no dependency on
  `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`,
  `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`, or
  `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`;
- all downstream product, LCU, block, unitarity, normalizer, and final flags
  remain false.

## Lower 3 Packet

Role: necessary-condition verifier.

Write scope:
`verifier-feedback/QBE-AUTO-002/source-prepared-product-projection-lower3-20260615.json`
and optional proof-attempt note.

Checks:

1. The route is source-prepared, not H-free.
2. The prepared clean entry is the full Fig. 4 clean projection.
3. The focused branch keeps sparse slot `2` and full basis index `32`.
4. The fixed product obligation is exactly `3 0 0`.
5. The packet has no dependency on the refuted backend-expansion parent.
6. The packet does not consume either diagnostic `sorry` theorem.
7. No product, LCU, block, unitarity, normalizer, or final flag is promoted.

Typed feedback should use:

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

Use `stale_leaf` instead if a lower attempt revives the H-free fold, selected
slot feeder, active/prepared diagnostic guard, or
`oneTermRobinGamma3BoundaryProjectionSummationProductBridge_leaf_n3` as a
closure route.  Use `invalid_route` if the attempt adds assumptions or changes
the paper construction.

## Forbidden Routes

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic
oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 env
oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3
oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3
```

The active/prepared diagnostic names are not main lower2 targets:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

They remain diagnostic route memory because, under `hUniform`, the current
compiled wiring routes them back to the retired H-free fold.

## Current Status

The packet is ready for lower2.  The one-term Robin theorem remains open.
No oracle, `H_W`, boundary `R_y`, LCU, block-projection, normalized-equality,
product-to-coefficient, circuit-unitarity, block-correctness, normalizer, final
extraction, or external primitive flag is promoted by this middle packet.
