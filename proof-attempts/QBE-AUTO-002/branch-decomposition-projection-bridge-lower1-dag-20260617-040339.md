# Lower1 Proof DAG: Branch Decomposition Projection Bridge

Task: `QBE-AUTO-002`  
Run: `20260617-034830-QBE-AUTO-002-cycle01`  
Leaf: `branch_decomposition_projection_bridge`  
Profile: natural-language proof architect  
Mode: `paperBenchmark`

## Source Fragment

The active source theorem is GHL2025 Theorem `theorem: 1 term robin`, treated
by this run as the main one-term Robin block-encoding theorem.  The local source
map records the anchor as `main.tex:1098-1109`.  The exact TeX path named by
the focused prompt, `outer_papers/quantum/GHL2025/main.tex`, is not present in
this checkout, so this handoff uses the maintained source map and synchronized
proof notes as the local source transcript.

The proof fragment translated by this leaf is not the final coefficient
identity.  It is the projection interface around the boundary $\gamma_3$
branch:

- Eq. `ROBIN clarified`, source-map anchor `main.tex:1111-1119`, fixes the
  focused boundary branch for system entry `(0,0)` and sparse slot `2`.
- The maintained status note records the corresponding focused coefficient
  facts as
  $$\text{product}_{32,32} =
    (f_3(0)N_f^{-1})(D_0^{(2)}N_D^{-1})$$
  and
  $$(A_k)_{0,0}=f_3(0)D_0^{(2)}.$$
- The same source line uses the theorem denominator $N_DN_f\kappa$; that
  coefficient/normalizer step is not part of this leaf.
- Fig. `fig:1 term ROBIN`, source-map anchor `main.tex:1122-1164`, supplies
  the theorem-facing prepared circuit with both $H_W^{(\kappa)}$ sides.
- Definition `def:block-encoding`, source-map anchor `main.tex:2027-2035`,
  supplies the signal-zero clean projection convention.

Therefore this leaf may package the theorem-facing source-prepared projection
entry and the slot-`2` projected branch product.  It must not prove the raw
backend `projectionSummationStatement`, because that route is already refuted
by `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3`.

## Definitions

For fixed `H`, `env`, `hUniform`, and `hentry`, define

```lean
let interface :=
  oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3
    H env
```

The source-prepared projection entry is
`interface.sourcePreparedProjectionEntry`.  The theorem-facing normalized
projection product is
`interface.normalizedProjectionBridge.projectedBranchProduct`.  The branch
product named by the projection target is
`oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct`.

The source contracts used by this leaf are:

- `hUniform :
  oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`, the
  contract-only sparse-preparation clean-column input from Eq.
  `arbitrary sparcity`.
- `hentry : env "boundary_cos_half_0_2" =
  Coeff.evalWith env (GHL2025.boundaryRotationNormalizedCoefficient
  (oneTermParameters 3) 0 2)`, the selected boundary rotation entry for sparse
  slot `2`.

## Natural-Language Proof

Claim.  The planned wrapper
`oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_branchDecompositionProjectionBridge_n3`
follows from already compiled source-prepared projection bridges and the
compiled no-go guard, without promoting any semantic closure flag.

Proof.  Fix `H`, `env`, `hUniform`, and `hentry`, and let `interface` be the
theorem-facing finite block projection interface above.

First, apply
`oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_correctedPreparedProjectionEntry_n3`
to `H`, `env`, `hUniform`, and `hentry`.  Its first conjunct gives

```lean
Coeff.evalWith env interface.sourcePreparedProjectionEntry =
  Coeff.evalWith env interface.normalizedProjectionBridge.projectedBranchProduct
```

and its remaining conjuncts record that the corrected finite block/projection,
product-to-coefficient, LCU, block, oracle, unitary, final-extraction, and
resource flags are still false.

Second, apply
`oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_preparedProjectionSlot2Product_n3`
to the same inputs.  Its first conjunct gives

```lean
Coeff.evalWith env interface.sourcePreparedProjectionEntry =
  Coeff.evalWith env
    oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct
```

and its second conjunct gives the definitional field identity

```lean
interface.sourcePreparedProjectionEntry =
  (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
    H env).preparedProjectionEntry
```

Third, use the compiled theorem-facing interface transcript, or simply unfold
the interface record with `dsimp`, to prove

```lean
interface.theoremFacingCircuit != interface.activeBackendCircuit
```

This is the maintained distinction between the full Fig. `fig:1 term ROBIN`
source circuit and the active seven-gate backend component.

Fourth, use
`oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3` to prove
the negative guard

```lean
not oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3
  .projectionSummationStatement
```

This guard prevents lower2 from reviving the raw backend projection route.

Finally, unfold
`oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3` and
its attached records.  All requested false-flag equalities reduce by `rfl`.
The proof does not call `oneTermRobinGamma3ProductToCoefficientObligation 3 0
0`, does not use `backendExpansionStatement`, and does not change the paper
circuit, normalizer, oracle contract, register layout, or gate order.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Status | Owner | Lean declaration | Next action |
|---|---|---|---|---|---|---|
| `source_prepared_slot2_product` | source-prepared projection entry evaluates to slot-`2` projected product | `hUniform`, `hentry`, source-prepared target | proved | none | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | reuse only |
| `theorem_facing_corrected_prepared_projection_entry` | theorem-facing source entry equals normalized bridge projected branch product | `source_prepared_slot2_product`, theorem-facing interface | proved | none | `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_correctedPreparedProjectionEntry_n3` | reuse first conjunct |
| `theorem_facing_projection_slot2_product` | theorem-facing source entry equals projection target projected branch product | `source_prepared_slot2_product`, theorem-facing interface | proved | none | `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_preparedProjectionSlot2Product_n3` | reuse first two conjuncts |
| `generic_backend_projection_surface` | unchanged backend projection-summation target | raw backend branch contribution target | refuted; forbidden | none | `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3` | use as no-go guard |
| `branch_decomposition_projection_bridge` | package both source-prepared equalities plus no-go guard and false flags | three proved nodes above | active leaf | lower2 after lower3 guard | planned `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_branchDecompositionProjectionBridge_n3` | compile one wrapper theorem |
| `fixed_product_to_coefficient` | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | branch bridge, finite normalizer bridge, coefficient algebra | blocked | later | existing obligation | do not attack in this packet |

Next active Lean leaf: after lower3 confirms the no-go and false-flag shape,
lower2 should compile only
`oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_branchDecompositionProjectionBridge_n3`.

## Ordered Lean Lemmas To Reuse

1. `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`:
   source-prepared slot-`2` projection/product equality under `hUniform` and
   `hentry`.
2. `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_preparedProjectionSlot2Product_n3`:
   transports the slot-`2` equality into the theorem-facing projection
   interface and exposes
   `interface.sourcePreparedProjectionEntry =
   (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env)
   .preparedProjectionEntry`.
3. `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_correctedPreparedProjectionEntry_n3`:
   transports the same source entry to
   `interface.normalizedProjectionBridge.projectedBranchProduct`.
4. `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_finiteBlockNormalizerEval_n3`:
   compiled route memory for the future normalizer/coefficient packet.  It is
   not needed to prove the planned wrapper's two product equalities.
5. `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3`:
   proves the invalid generic backend projection route is unavailable.
6. `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3_transcript`:
   optional audit reference for circuit mismatch and false fields.  The wrapper
   proof can also obtain these by `dsimp` and `rfl`.

Suggested proof shape for lower2:

```lean
  have hNorm :=
    oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_correctedPreparedProjectionEntry_n3
      H env hUniform hentry
  have hSlot :=
    oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_preparedProjectionSlot2Product_n3
      H env hUniform hentry
  have hNoGo := oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3
  rcases hNorm with ...
  rcases hSlot with ...
  dsimp [
    oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3,
    oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3,
    oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3,
    oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3,
    oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3,
    oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3,
    GHL2025.oneTermRobinTheoremFacingFig4Circuit,
    GHL2025.oneTermRobinCircuit] at *
  exact ...
```

## Failure Analysis

The current target is mathematically valid only as a non-promoting wrapper.  It
would be wrong to reinterpret it as the raw branch-sum theorem or the final
product-to-coefficient theorem.

- `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement`
  is forbidden because `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3`
  refutes the unchanged generic backend route.
- The branch-correct slot path has embedded basis index `32`, while Definition
  `def:block-encoding` selects the signal-zero block entry for system `(0,0)`.
  A direct `[32,32] = [0,0]` finite-entry proof would be a register-shape
  error unless it is routed through the source-prepared projection interface.
- The coefficient/normalizer theorem
  `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains blocked.
  This leaf supplies route glue only; it does not close the GHL baseline.

## Handoff

Lower1 handoff: leaf=`branch_decomposition_projection_bridge`;
source_correspondence_ok=true for the prepared theorem-facing branch selected
by GHL2025 Theorem `theorem: 1 term robin`, Eq. `ROBIN clarified`, Fig.
`fig:1 term ROBIN`, and Definition `def:block-encoding`.  No Lean edit was
made.  error_class=`symbolic_bridge_gap`.  next_route=`lower3 shape/no-go
check, then lower2 compiles exactly one non-promoting wrapper theorem
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_branchDecompositionProjectionBridge_n3`.
Gates passed: `python3 tools/qbe.py check` and
`lake build && lake build Tests`, with only the known RobinMatrix diagnostic
`sorry` warnings.

Postscript after concurrent lower2 work: the dialogue board now records that
lower2 closed
`oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_branchDecompositionProjectionBridge_n3`
at `2026-06-17 04:06:17`.  Treat this lower1 document as route memory for how
that wrapper was source-justified.  The live next route is now to retire
`branch_decomposition_projection_bridge` and refresh the source-backed
`fixed_product_to_coefficient` frontier for
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.
