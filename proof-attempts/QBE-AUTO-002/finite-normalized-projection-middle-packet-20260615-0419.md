# Finite Normalized Projection Middle Packet

Task: `QBE-AUTO-002`
Run: `20260615-041049-QBE-AUTO-002-cycle01`
Role: middle coordinator synthesis
Mode: `faithfulPaper`
Created: `2026-06-15 04:19 JST`

## Source Fragment

The active source fragment is GHL2025 Theorem `theorem: 1 term robin`,
Eq. `ROBIN clarified` for the displayed gamma3 boundary branch, Eq.
`arbitrary sparcity`, Eq. `angles for Ry`, Fig. `fig:1 term ROBIN`, and
Definition `def:block-encoding`.

The local TeX source contains no separate external theorem for the focused
finite projection step.  It passes from the displayed gamma3 branch state and
the block-encoding definition to the selected signal-zero block entry.  In QBE
this is an internal paper step that needs a finite matrix/projection
interface.  The Shukla-Vedula uniform-preparation row remains contract-only
for the clean sparse-register amplitudes, and the standard LCU row remains a
downstream normalized block-composition contract.

## Definitions

`FixedProductObligation` is:

```lean
oneTermRobinGamma3ProductToCoefficientObligation 3
  ⟨0, by native_decide⟩ ⟨0, by native_decide⟩
```

`SourcePreparedProjection(H, env)` is:

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env)
  .preparedProjectionEntry
```

`ConditionalNormalizerBridge` is the compiled theorem:

```lean
oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3
```

It proves, under explicit `hUniform`, `hentry`, `hND`, `hNF`, `hkappa`, and
`hkappaSqrt` hypotheses, that:

```lean
Coeff.evalWith env SourcePreparedProjection(H, env) *
  Coeff.evalWith env
    oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3.theoremNormalizer =
Coeff.evalWith env
  oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3.expectedTargetEntry
```

It also keeps `FixedProductObligation.proved = false`.

`FiniteNormalizedProjectionBridge(H, env)` is the missing theorem-facing
bridge.  It must attach the source-prepared projection object above to the
finite block-composition target for system entry `(0,0)` without using the
refuted H-free raw fold.  The intended new Lean packet is:

```lean
OneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge
oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3
oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3_transcript
```

The packet should be route bookkeeping first.  It should not prove
`FixedProductObligation`, and it should not set normalized-block, LCU, block,
unitarity, final-extraction, oracle, or resource flags to true.

## Existing Declarations To Reuse

```lean
oneTermRobinGamma3BoundaryHWKappaUniformAllSlots_to_productRouteFocusedCleanColumn_n3
oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3
oneTermRobinGamma3BoundarySourcePreparedProjectionSlot2Product_feedsFixedProductMap_n3
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3
oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3
oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3_transcript
oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3
oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3_transcript
oneTermRobinGamma3BoundaryProductToCoefficientObligation_sourcePreparedTargetBackendEval_n3
oneTermRobinFiniteBlockCompositionContract 3
oneTermRobinGamma3ProductToCoefficientObligation 3
oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3
```

## Proof Translation Map

| Source step | Lean status | Classification |
|---|---|---|
| Eq. `arbitrary sparcity` gives the clean sparse-register amplitude for every sparse slot. | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` and the focused feeder are compiled under an explicit hypothesis. | external cited contract; not a lower2 theorem target |
| Eq. `angles for Ry` supplies the selected boundary entry convention. | `hentry` remains an explicit hypothesis of the conditional bridge. | source convention; not normalizer-free closure |
| Eq. `ROBIN clarified` gamma3 boundary branch supplies the slot-`2` coefficient route. | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` and the normalizer bridge are compiled route memory. | QBE-local coefficient bridge under explicit hypotheses |
| Definition `def:block-encoding` selects the signal-zero block entry for system `(0,0)`. | `oneTermRobinGamma3BoundaryFiniteProjectionBlockEntryIndex_n3` and `oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3` record the finite indices and false bridge flags. | internal paper step plus QBE finite projection interface |
| The theorem normalizer is `N_D*N_f*kappa`. | `oneTermRobinFiniteBlockCompositionContract 3` records `normalizer` and `normalizedBlockEquality.proved = false`. | downstream finite normalized block obligation |
| The unchanged raw fold would equate the H-free active `[0,0]` entry with a backend branch fold. | `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` refutes it. | forbidden route |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `conditional_normalizer_product_bridge` | source-prepared slot-`2` projection times theorem normalizer equals expected target entry under explicit hypotheses | source slot-`2` product equality; focused clean column; coefficient identities | none | `oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3` | product normalizer synthesis and lower1 post-lower packet | previous full gate | compiled route memory |
| `source_prepared_fixed_product_guard` | source-prepared slot-`2` equality is attached to `FixedProductObligation` while flags stay false | conditional bridge inputs | none | `oneTermRobinGamma3BoundarySourcePreparedProjectionSlot2Product_feedsFixedProductMap_n3` | retarget packet | previous full gate | compiled; stale |
| `finite_source_prepared_normalized_projection_bridge` | package the source-prepared projection object with the finite block-composition target and normalized equality obligation | compiled conditional normalizer bridge; finite projection product bridge; Definition `def:block-encoding` | lower2 after verifier | planned `oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3` plus transcript | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active planning leaf |
| `fixed_product_to_coefficient_3_0_0` | close the exact focused product-to-coefficient root | finite source-prepared normalized projection bridge plus later cited contract discharge | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 ⟨0,_⟩ ⟨0,_⟩` | proof-obligation ledger | full gate plus proof-map sync | open root; `proved = false` |
| `backend_expansion_raw_no_go` | raw backend expansion or any `SignalEntryFold`-equivalent proposition | compiled finite counterexample | none | `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` | backend-expansion correction packets | none | refuted; forbidden |

## Lower-Agent Split

lower1 should validate this proof map and keep the source branch fixed:
boundary branch, system entry `(0,0)`, sparse slot `2`, source-prepared
projection entry, and normalizer `N_D*N_f*kappa`.  It should not search for a
new raw backend fold.

lower2 may edit only `QuantumBlockEncoding/RobinMatrix.lean`.  Its exact
target, after lower3 checks the necessary conditions, is:

```lean
oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3
```

The target should be a compact packet and transcript theorem tying together
the compiled conditional normalizer bridge, the finite projection product
bridge, the source-prepared product/projection obligation, and
`oneTermRobinFiniteBlockCompositionContract 3`.  It must keep
`FixedProductObligation.proved = false` and every downstream semantic flag
false.  If this declaration already exists, lower2 should make no Lean edit and
log `error_class=stale_leaf`.

lower3 should verify the necessary conditions before lower2 edits Lean:

- `FiniteProjectionBlockEntryIndex` still gives signal block row and column
  `0`.
- The branch-local source basis for slot `2` is still `32`; it must not be
  identified directly with the signal-zero block index.
- `ConditionalNormalizerBridge` uses `SourcePreparedProjection(H, env)`, not
  the H-free active row-`0` entry.
- `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` still forbids
  raw backend-expansion and `SignalEntryFold` routes.
- `product_to_coefficient`, `normalized_block_equality`, `lcu_correct`,
  `block_projection`, `block_correct`, and `final_extraction` all stay false.

## Rejected Targets

Do not assign any of the following as lower2 theorem targets:

```lean
oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3
oneTermRobinGamma3BoundarySourcePreparedProjectionSlot2Product_feedsFixedProductMap_n3
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3
oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3
```

The first two are compiled route memory.  The remaining routes are diagnostic
or refuted for theorem-facing closure.

## Verifier Feedback

```text
leaf=finite_source_prepared_normalized_projection_bridge
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=indices_compiled_bridge_not_proved
block_entry_ok=pending_source_prepared_projection_bridge
ancilla_cleanup_ok=null
normalizer_ok=conditional_bridge_compiled_under_explicit_hypotheses
closed_theorem_ok=false
product_to_coefficient=false
error_class=symbolic_bridge_gap
next_route=verify necessary conditions, then implement oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3 as a non-promoting packet; do not revive backendExpansionStatement or SignalEntryFold
```

## Handoff

The compiled conditional normalizer bridge is route memory.  The next lower2
target is not the root product obligation and not the H-free raw fold.  It is a
source-prepared finite normalized projection packet that makes the remaining
block-composition/projection obligation explicit while preserving all false
semantic flags.
