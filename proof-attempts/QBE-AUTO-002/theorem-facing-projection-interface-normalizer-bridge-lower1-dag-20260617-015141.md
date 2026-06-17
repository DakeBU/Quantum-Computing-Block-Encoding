# Theorem-Facing Projection-Interface Normalizer Bridge Lower1 DAG

Task: `QBE-AUTO-002`

Run: `20260617-013501-QBE-AUTO-002-cycle01`

Role: lower1 natural-language proof architect

Prepared: `2026-06-17 01:51 JST`

## Source Fragment

The active paper object is GHL2025 Theorem `theorem: 1 term robin`, treated as
Theorem 3 for this run.  The exact source anchors used by this leaf are Eq.
`eq: arbitrary sparcity`, Eq. `eq:angles for Ry`, Eq. `eq: ROBIN clarified`,
Fig. `fig:1 term ROBIN`, and Definition `def:block-encoding`.

The local TeX archive path named in older packets,
`outer_papers/quantum/GHL2025/main.tex`, is not present in this checkout.  This
handoff therefore uses the maintained source map and proof-note anchors:
`research-wiki/paper-contributions/GHL2025/source-map.md`,
`paper-notes/GHL2025/markdown/00_status.md`, and
`QuantumBlockEncoding/GHL2025.lean`.

The translated equation fragment is the focused boundary `gamma_3` clean branch:

$$
\text{clean coefficient} =
\frac{f(x_i) D_i^{(s)}}{N_D N_f \kappa}.
$$

For the current finite instance, the fixed branch is system entry `(0,0)`,
sparse slot `2`, signal block `[0,0]`, branch basis `[32,32]`, and source-
prepared projection.  The present leaf does not prove the full coefficient
equation.  It only exposes the already compiled slot-`2` normalizer equality
through the theorem-facing projection-interface fields.

## Definitions

For fixed `H : Matrix 8 8 Coeff` and `env : String -> Rat`, define:

```lean
ProjectionInterface(H, env) :=
  oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3
    H env
```

```lean
NormalizerBridge(H, env) :=
  oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3
    H env hUniform hentry hND hNF hkappa hkappaSqrt
```

The explicit hypotheses are the same as the middle packet:

- `hUniform` is the sparse-register clean-column contract from Eq. `eq: arbitrary sparcity`.
- `hentry` is the focused boundary coefficient convention from Eq. `eq:angles for Ry`.
- `hND`, `hNF`, `hkappa`, and `hkappaSqrt` are the explicit coefficient-environment identities used by the compiled normalizer evaluator.

## Local Proof

The active local theorem is:

```lean
oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3
```

Let `interface := ProjectionInterface(H, env)`.  The desired equality is:

```lean
Coeff.evalWith env interface.sourcePreparedProjectionEntry *
    Coeff.evalWith env interface.normalizedProjectionBridge.theoremNormalizer =
  Coeff.evalWith env interface.normalizedProjectionBridge.expectedTargetEntry
```

The proof has no new mathematical content.  Invoke `NormalizerBridge(H, env)`.
Its first conjunct gives the same equality for the source-prepared packet:

```lean
Coeff.evalWith env packet.sourceTarget.preparedProjectionEntry *
    Coeff.evalWith env productRoute.theoremNormalizer =
  Coeff.evalWith env productRoute.expectedTargetEntry
```

Unfolding `ProjectionInterface(H, env)`,
`oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3`,
`oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3`, and
`oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3`
identifies:

- `interface.sourcePreparedProjectionEntry` with `packet.sourceTarget.preparedProjectionEntry`;
- `interface.normalizedProjectionBridge.theoremNormalizer` with `productRoute.theoremNormalizer`;
- `interface.normalizedProjectionBridge.expectedTargetEntry` with `productRoute.expectedTargetEntry`.

The first conjunct follows by the compiled normalizer equality.  Every
remaining conjunct is a false theorem-facing flag stored by the interface
definition, so each closes by definitional equality after the same unfolding.

This is a source-faithful interface glue lemma.  It does not prove the corrected
finite block/projection equality, product-to-coefficient obligation,
normalized-block equality, LCU correctness, block projection, block
correctness, final extraction, oracle correctness, unitarity, or resource
claim.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_uniform_contract` | clean-column amplitude for all sparse slots used by source preparation | GHL2025 Eq. `eq: arbitrary sparcity`; Shukla-Vedula row | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | `research-wiki/cited-results/GHL2025.md` | contract only | external obligation |
| `boundary_entry_contract` | focused boundary slot coefficient convention | GHL2025 Eq. `eq:angles for Ry` | none | `hentry` hypothesis | middle packet | explicit hypothesis | contract only |
| `source_slot2_projection_product` | source-prepared clean projection equals slot-`2` projected branch product | `source_uniform_contract`, `boundary_entry_contract` | compiled | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | `paper-notes/GHL2025/markdown/00_status.md` | prior gate | proved route memory |
| `product_under_contracts_eval` | projected branch product times theorem normalizer equals expected target entry | clean-column feeder plus coefficient identities | compiled | `oneTermRobinGamma3BoundaryProductUnderContractsEval_n3` | product-to-coefficient normalizer packet | prior gate | proved route memory |
| `source_slot2_normalizer_bridge` | source-prepared packet normalizer equality under explicit contracts | previous two nodes | compiled | `oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3` | `proof-attempts/QBE-AUTO-002/product-to-coefficient-normalizer-middle-packet-20260615-032327.md` | prior gate | proved route memory |
| `source_prepared_normalized_projection_bridge` | source-prepared normalized projection packet, false flags preserved | `source_slot2_normalizer_bridge` | compiled | `oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3` and transcript | finite normalized projection packet | prior gate | proved route memory |
| `theorem_facing_contract_audit` | records Fig. 4 transcript versus active seven-gate backend split | theorem-facing and active gate-list guards | compiled | `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3` and transcript | theorem-facing finite block audit packet | prior gate | proved route memory |
| `theorem_facing_projection_interface` | attaches source-prepared projection target to finite block contract without promoting flags | previous two nodes | compiled | `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3` and transcript | `proof-attempts/QBE-AUTO-002/theorem-facing-finite-block-projection-interface-middle-packet-20260615-0507.md` | prior gate | proved route memory |
| `theorem_facing_projection_interface_normalizer_bridge` | expose compiled normalizer equality through `ProjectionInterface(H, env)` fields and keep all theorem flags false | `source_slot2_normalizer_bridge`, `theorem_facing_projection_interface` | lower2 or stale check | `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3` | this file and middle packet `20260617-0145` | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | target exists in current worktree; gates passed with only known diagnostic `sorry` warnings |
| `fixed_gamma3_product_to_coefficient_root` | focused product-to-coefficient obligation for `(3,0,0)` | normalizer bridge plus corrected finite block/projection equality | middle after current leaf accepted | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | proof-obligation ledger | future gate | open; not a lower target here |

Next active leaf for a Lean worker: do not duplicate
`oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3`.
The gate passed, so record it as accepted route memory and let middle prepare
the next coefficient bridge.  If a later merge invalidates this declaration,
repair only this theorem and its immediate unfolding list in
`QuantumBlockEncoding/RobinMatrix.lean`.

## Intermediate Lean Lemmas To Reuse

1. `oneTermRobinGamma3BoundaryHWKappaUniformAllSlots_to_productRouteFocusedCleanColumn_n3`
2. `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`
3. `oneTermRobinGamma3BoundaryProductUnderContractsEval_n3`
4. `oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3`
5. `oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3_transcript`
6. `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3_transcript`
7. `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3_transcript`
8. `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`
9. `GHL2025.oneTermRobinActiveBackendCircuit_gateList`
10. `oneTermRobinFiniteBlockCompositionContract_transcript 3`

The proof should not reuse diagnostic `sorry` declarations:

```lean
oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3
oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3
```

## Failure Analysis

The local theorem is mathematically well-typed as interface glue.  It is not a
simplified replacement for the paper construction because the full Fig. 4
transcript remains distinct from the active seven-gate backend, and the
interface explicitly preserves that mismatch.  The theorem also does not add
hidden assumptions: the external sparse-preparation and coefficient facts are
visible hypotheses.

The only route risk was scheduling.  A narrow lookup found that the target now
exists in `QuantumBlockEncoding/RobinMatrix.lean` in the current uncommitted
worktree, and both gates passed.  Therefore lower2 should treat this leaf as
stale route memory.  If a later merge invalidates this declaration, the error
class is `lean_tactic_gap` and the next route is to repair the same
`dsimp`/field-unfolding proof, not to attack the root theorem or any diagnostic
H-free backend route.

## Typed Feedback

```text
leaf=theorem_facing_projection_interface_normalizer_bridge
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=not_applicable_interface_glue
block_entry_ok=pending_downstream_corrected_projection
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
closed_theorem_ok=true_for_local_leaf_false_for_root
error_class=stale_leaf
next_route=retire this local leaf as accepted route memory; middle should prepare the next coefficient bridge; lower2 should not duplicate oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3
```

Gate result: `python3 tools/qbe.py check` passed, and the explicit
`lake build && lake build Tests` gate passed.  Both reported only the known
diagnostic `sorry` warnings in `QuantumBlockEncoding/RobinMatrix.lean`.
