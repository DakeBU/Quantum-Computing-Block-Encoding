# Backend-Expansion Route-Retarget Middle Packet

Task: `QBE-AUTO-002`
Run: `20260615-030358-QBE-AUTO-002-cycle01`
Role: middle coordinator synthesis
Mode: `faithfulPaper`
Created: `2026-06-15 03:16 JST`

## Source Status

The local TeX source named in the prompt is absent in this checkout, so this
packet cites only checked-in and public anchors: GHL2025 Eq. `ROBIN
clarified`, Fig. `fig:1 term ROBIN`, Definition `def:block-encoding`,
Theorem `theorem: 1 term robin`, the maintained proof notes, and
`research-wiki/cited-results/GHL2025.md`.

Lower1 and lower3 have already classified the unchanged raw
`backendExpansionStatement` as a source-contract gap with a finite selected-slot
counterexample.  That target remains route memory only.

## Definitions

`SourceSlot2Product(H, env)` is the evaluated source-prepared equality:

```lean
Coeff.evalWith env
  (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
    H env).preparedProjectionEntry =
Coeff.evalWith env
  oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct
```

`FixedProductObligation` is:

```lean
oneTermRobinGamma3ProductToCoefficientObligation 3
  ⟨0, by native_decide⟩ ⟨0, by native_decide⟩
```

`BackendExpansionRaw` is:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

## Accepted Retarget

The paper-backed source-prepared route is already compiled:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3
```

Middle added the narrow retarget guard:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionSlot2Product_feedsFixedProductMap_n3
```

The guard consumes `SourceSlot2Product(H, env)`, attaches it to
`FixedProductObligation`, and checks that the product, branch-decomposition,
normalized-block, LCU, block, and final-extraction flags remain false.  It
does not prove the fixed product-to-coefficient theorem.

## Source-Dependency Classification

| Missing ingredient | Classification | Evidence | Next route |
|---|---|---|---|
| unchanged raw backend expansion | source-contract gap plus finite counterexample | `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3`; lower3 JSON | never assign unchanged |
| source-prepared slot-`2` bridge | internal GHL branch/product step plus QBE-local route wiring | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | compiled route memory |
| fixed product-map retarget | QBE-local guard | `oneTermRobinGamma3BoundarySourcePreparedProjectionSlot2Product_feedsFixedProductMap_n3` | compiled in this packet |
| coefficient equality for `(3,0,0)` | internal paper step plus local normalizer/coefficient algebra | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | future packet |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `backend_expansion_raw_no_go` | raw H-free backend expansion equivalent to `SignalEntryFold` | selected-slot all-one counterexample | none | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` | lower1/lower3 correction packets | no-go theorem compiled | refuted |
| `source_projection_slot2_product` | source-prepared projection evaluates to the slot-`2` projected product | source projection/backend fold bridge; selected-slot evaluator | none | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | composite route memory | previous full gate | compiled |
| `source_slot2_product_fixed_map_guard` | fixed product map consumes the source-prepared slot-`2` equality while flags stay false | source slot-`2` product theorem; finite product bridge | middle/lower2 guard | `oneTermRobinGamma3BoundarySourcePreparedProjectionSlot2Product_feedsFixedProductMap_n3` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | compiled |
| `product_to_coefficient_3_0_0` | prove exact coefficient equality and normalizer algebra | retarget guard; boundary coefficient convention; coefficient contracts | future upper/middle packet | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | proof-obligation ledger | same gate | open |

## Lower Packets

Lower1 natural-language proof architect:

- Reuse this packet as the source-dependency map.
- Do not search for a corrected raw backend-expansion proposition.
- If adding a postscript, state that the next theorem-facing packet is the
  coefficient/normalizer route for `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.

Lower2 Lean implementation worker:

- If the guard is absent, edit only `QuantumBlockEncoding/RobinMatrix.lean`.
- Prove exactly
  `oneTermRobinGamma3BoundarySourcePreparedProjectionSlot2Product_feedsFixedProductMap_n3`.
- Use only
  `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`
  and existing false-flag records.
- If the guard is present, make no Lean edit and log `error_class=stale_leaf`.

Lower3 necessary-condition verifier:

- Check clean projection index `0`, focused sparse slot `2`, branch basis
  index `32`, fixed product route `3 0 0`, and false downstream flags.
- Record `closed_theorem_ok=true` for the guard and keep
  `product_to_coefficient=false` in notes.

## Forbidden Routes

Do not prove `BackendExpansionRaw` unchanged.  Do not use the two diagnostic
`sorry` declarations as dependencies.  Do not revive the old H-free evaluated
fold as theorem-facing closure.  Do not promote product-to-coefficient,
normalizer, LCU/block composition, oracle correctness, unitarity, block
correctness, or final block-extraction flags.

## Typed Feedback

```text
leaf=source_slot2_product_fixed_map_guard
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
block_entry_ok=true
ancilla_cleanup_ok=null
normalizer_ok=false
closed_theorem_ok=true
error_class=null
next_route=prepare a coefficient/normalizer packet for oneTermRobinGamma3ProductToCoefficientObligation 3 0 0; do not revive backendExpansionStatement
```
