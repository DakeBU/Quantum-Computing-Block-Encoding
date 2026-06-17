# Theorem-Facing Corrected Prepared Projection Entry Middle Packet

Task: `QBE-AUTO-002`  
Run: `20260617-030416-QBE-AUTO-002-cycle01`  
Role: middle correspondence/memory  
Mode: `paperBenchmark`  
Leaf: `theorem_facing_corrected_prepared_projection_entry`

## Source-Contract Audit

The baseline target is still GHL2025 Theorem `theorem: 1 term robin`, recorded
in the source map as `RobinTheorem` at `main.tex:1098-1109`.  The active local
fragment is the boundary `gamma_3` branch from Eq. `ROBIN clarified`
(`main.tex:1111-1119`), Fig. `fig:1 term ROBIN` (`main.tex:1122-1164`), and
Definition `def:block-encoding` (`main.tex:2027-2035`).

The source-prepared route is the only faithful route for this leaf.  Eq.
`arbitrary sparcity` supplies the clean sparse-register column through the
contract
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.  The
boundary rotation convention for slot `2` enters only as the explicit
hypothesis `hentry` for `boundary_cos_half_0_2`.  Neither contract is promoted
to a proved oracle, state-preparation, or rotation theorem in this packet.

The current generic target
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement`
is retired.  It is equivalent to the already refuted
`backendExpansionStatement`, and lower2 compiled
`oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3`.
Any lower packet that targets that generic statement again is an invalid route.

## Definitions

`ProjectionInterface(H, env)` is
`oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3 H env`.

`PreparedEntry(H, env)` is
`(ProjectionInterface(H, env)).sourcePreparedProjectionEntry`.

`ProjectedSlot2Product` is
`(ProjectionInterface(H, env)).normalizedProjectionBridge.projectedBranchProduct`.

`ForbiddenGenericProjection` is
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement`.

## Proof Translation Map

| Source step | Lean object | Classification | Status |
|---|---|---|---|
| Theorem `theorem: 1 term robin` | fixed GHL baseline theorem route | root theorem | open |
| Eq. `arbitrary sparcity` | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited/external contract | contract only |
| Eq. `angles for Ry` boundary slot `2` | `hentry : env "boundary_cos_half_0_2" = ...` | source convention hypothesis | explicit, not hidden |
| Fig. `fig:1 term ROBIN` prepared route | `oneTermRobinTheoremFacingFig4Circuit`; source-prepared target | transcript and local matrix route | compiled guards |
| Definition `def:block-encoding` clean projection | `ProjectionInterface(H, env).sourcePreparedProjectionEntry` | QBE-local finite projection interface | active leaf |
| Slot-`2` projected product | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | compiled theorem reused by wrapper | proved conditional |
| Generic backend projection | `ForbiddenGenericProjection` | contract drift / finite counterexample | forbidden |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_prepared_slot2_product` | prepared projection entry evaluates to the slot-`2` projected product | `hUniform`, `hentry`, source-prepared target | none | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | this packet and lower1 03:02 DAG | already gated | compiled route memory |
| `generic_branch_sum_projection` | raw backend target projection-summation statement | backend branch target | none | `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3` | lower2 invalid-route packet | already gated | refuted; do not assign |
| `theorem_facing_corrected_prepared_projection_entry` | expose `PreparedEntry(H, env) = ProjectedSlot2Product` at the theorem-facing interface layer | compiled source-prepared slot-`2` theorem; theorem-facing finite block interface | lower2 after lower3 recheck | planned `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_correctedPreparedProjectionEntry_n3` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active leaf |
| `fixed_product_to_coefficient` | close `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | corrected prepared projection entry, normalizer bridge, finite normalized-block/projection theorem | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | conversion window and proof obligations | not run | blocked |
| `post_baseline_population` | same operator candidate population scored by `(depth, gateCount, auxiliaryQubits, oracleCalls)` | baseline theorem closed first | later middle | none | task directive | not run | deferred |
| `fallback_optctrl_operator` | `E_k := |0><k|_time \otimes |0><1|_type \otimes I_n` | baseline closure and improvement stagnation | later middle | planned OPTCTRL task | `tasks/QBE-OP-OPTCTRL-001.md` | not run | deferred |

## Lower Packets

Lower1 natural-language packet:
Map the proof paragraph above to the source-prepared route only.  Do not
reinterpret the branch-sum leaf as `ForbiddenGenericProjection`.  The proof map
should cite Theorem `theorem: 1 term robin`, Eq. `ROBIN clarified`, Eq.
`arbitrary sparcity`, Eq. `angles for Ry`, Fig. `fig:1 term ROBIN`, Definition
`def:block-encoding`, and the Fig. 4 visual audit.

Lower3 verifier packet:
Before lower2 edits Lean, check that the planned statement unfolds to
`ProjectionInterface(H, env).sourcePreparedProjectionEntry` on the left and
`ProjectionInterface(H, env).normalizedProjectionBridge.projectedBranchProduct`
on the right.  Record `source_correspondence_ok=true`,
`register_shape_ok=true`, `finite_matrix_ok=true_for_shape_only`, and
`closed_theorem_ok=false` unless the Lean declaration has been added and gated.
Reject any target whose RHS is
`ForbiddenGenericProjection` or whose proof path invokes
`backendExpansionStatement`.

Lower2 Lean packet:
Edit only `QuantumBlockEncoding/RobinMatrix.lean`.  Add exactly the following
non-promoting theorem near
`oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_preparedProjectionSlot2Product_n3`.
Do not edit the root theorem, do not revive the generic backend projection
statement, and keep every product, LCU, block, oracle, unitary, final, and
resource flag false.

```lean
theorem
    oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_correctedPreparedProjectionEntry_n3
    (H : Matrix 8 8 Coeff) (env : String → Rat)
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
        Coeff.evalWith env interface.normalizedProjectionBridge.projectedBranchProduct ∧
      interface.sourcePreparedProjectionEntry =
        (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
          H env).preparedProjectionEntry ∧
      interface.correctedFiniteBlockProjectionEquality.proved = false ∧
      interface.correctedFiniteBlockProjectionEqualityProved = false ∧
      interface.fixedProductObligation.proved = false ∧
      interface.finiteBlockProjectionObligation.proved = false ∧
      interface.productToCoefficientProved = false ∧
      interface.lcuCorrectProved = false ∧
      interface.blockProjectionProved = false ∧
      interface.blockCorrectProved = false ∧
      interface.finalExtractionProved = false ∧
      interface.oracleCorrectProved = false ∧
      interface.unitaryProved = false ∧
      interface.resourceClaimProved = false := by
  have hSlot :=
    oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3
      H env hUniform hentry
  dsimp [
    oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3,
    oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3,
    oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3,
    oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3,
    oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3,
    oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3]
    at hSlot ⊢
  exact ⟨hSlot, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl,
    rfl, rfl, rfl, rfl, rfl⟩
```

Middle stdin diagnostic:
This exact theorem shape was checked with `lake env lean --stdin` on
2026-06-17 03:15 JST.  The diagnostic passed without editing Lean.

## Verifier Feedback

| Field | Value |
|---|---|
| `leaf` | `theorem_facing_corrected_prepared_projection_entry` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` for stdin diagnostic |
| `lean_build_ok` | `null` until lower2 inserts the declaration |
| `finite_matrix_ok` | `shape reuses lower3 register check; no new root finite theorem` |
| `block_entry_ok` | `prepared interface wrapper only` |
| `ancilla_cleanup_ok` | `null` |
| `normalizer_ok` | `unchanged; normalizer bridge remains compiled conditional memory` |
| `closed_theorem_ok` | `false` until lower2 adds and gates the declaration |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `lower3 verifies the theorem-facing prepared-entry shape, then lower2 adds exactly the wrapper theorem above` |

No product-to-coefficient, normalized-block, LCU, block-projection,
block-correctness, final-extraction, oracle, unitary, resource, post-baseline
candidate, or OPTCTRL fallback claim is promoted by this middle packet.
