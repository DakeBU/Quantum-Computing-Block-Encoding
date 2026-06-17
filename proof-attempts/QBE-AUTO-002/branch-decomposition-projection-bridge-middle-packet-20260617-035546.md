# Middle Packet: Branch Decomposition Projection Bridge

Task: `QBE-AUTO-002`  
Run: `20260617-034830-QBE-AUTO-002-cycle01`  
Leaf: `branch_decomposition_projection_bridge`  
Mode: `paperBenchmark`

## Source Contract

The active source anchor remains GHL2025 Theorem `theorem: 1 term robin`, with Eq. `ROBIN clarified`, Fig. `fig:1 term ROBIN`, Eq. `arbitrary sparcity`, and Definition `def:block-encoding`. The target is still the paper baseline, not an improved circuit.

The corrected source-facing block is the prepared clean projection entry selected by
`oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3 H env`.
The compiled route from that entry to the boundary slot-`2` projected product is:

```lean
oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_preparedProjectionSlot2Product_n3
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_correctedPreparedProjectionEntry_n3
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_finiteBlockNormalizerEval_n3
```

The invalid generic backend route is compiled as a no-go guard:

```lean
oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3
oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3
```

Do not prove, assume, or route through
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`
or
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement`.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `theorem_facing_finite_block_normalizer_bridge` | expose source-prepared projection entry through `interface.finiteBlockNormalizer` | compiled normalizer bridge | none | `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_finiteBlockNormalizerEval_n3` | finite-normalizer packet | full gate already passed | compiled; retired |
| `generic_backend_projection_surface` | unchanged generic projection-summation route | backend expansion target | none | `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3` | invalid-route packets | full gate already passed | refuted; forbidden |
| `branch_decomposition_projection_bridge` | identify the theorem-facing source-prepared clean projection field with the slot-`2` projected branch product, while recording the no-go guard | source-prepared slot-`2` bridge, finite block projection interface, no-go guard | lower2 after lower1/lower3 | planned `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_branchDecompositionProjectionBridge_n3` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | queued |
| `fixed_product_to_coefficient` | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | branch bridge, finite normalizer bridge, coefficient algebra | later | existing obligation | proof-obligation ledger | not run | blocked |

## Lower 1 Packet

Write the natural-language proof map for the queued lower2 theorem.

1. The source theorem uses the theorem-facing prepared projection, not the active raw seven-gate entry. Map this to `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3`.
2. The boundary `gamma_3` slot is sparse slot `2`; the compiled source-prepared route to the projected branch product is `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`.
3. The finite block interface records the theorem-facing circuit and active backend mismatch; use `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3_transcript`.
4. The unchanged generic projection route is refuted by `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3`. Mark this as an invalid route, not as a source theorem failure.
5. The lower2 theorem must be a non-promoting wrapper. It may mention false flags, but it must not set `correctedFiniteBlockProjectionEquality.proved`, product-to-coefficient, normalized-block, LCU, block, oracle, unitary, final-extraction, or resource flags to true.

## Lower 2 Packet

Allowed write scope: `QuantumBlockEncoding/RobinMatrix.lean` only.

Implement exactly one theorem:

```lean
theorem
    oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_branchDecompositionProjectionBridge_n3
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
          interface.normalizedProjectionBridge.projectedBranchProduct ∧
      Coeff.evalWith env interface.sourcePreparedProjectionEntry =
        Coeff.evalWith env
          oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct ∧
      interface.sourcePreparedProjectionEntry =
        (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
          H env).preparedProjectionEntry ∧
      interface.theoremFacingCircuit ≠ interface.activeBackendCircuit ∧
      ¬ oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement ∧
      interface.correctedFiniteBlockProjectionEquality.proved = false ∧
      interface.correctedFiniteBlockProjectionEqualityProved = false ∧
      interface.fixedProductObligation.proved = false ∧
      interface.finiteBlockNormalizedEquality.proved = false ∧
      interface.finiteBlockProjectionObligation.proved = false ∧
      interface.finiteBlockLCUCompositionObligation.proved = false ∧
      interface.finiteBlockFinalExtractionObligation.proved = false ∧
      interface.normalizedBlockEqualityProved = false ∧
      interface.productToCoefficientProved = false ∧
      interface.lcuCorrectProved = false ∧
      interface.blockProjectionProved = false ∧
      interface.blockCorrectProved = false ∧
      interface.finalExtractionProved = false ∧
      interface.oracleCorrectProved = false ∧
      interface.unitaryProved = false ∧
      interface.resourceClaimProved = false
```

Expected proof route:

- Reuse `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_correctedPreparedProjectionEntry_n3` for the normalized-projection product equality.
- Reuse `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_preparedProjectionSlot2Product_n3` for the direct projection target equality.
- Reuse `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3` for the invalid generic route guard.
- Use `dsimp` on `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3` for false flags and circuit inequality, following the compiled transcript theorem.

Do not touch `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.

## Lower 3 Packet

Before lower2 edits, verify:

| Check | Expected result |
|---|---|
| source branch | boundary `gamma_3`, system `(0,0)`, sparse slot `2` |
| theorem-facing entry | `interface.sourcePreparedProjectionEntry`, not active raw `[0,0]` |
| invalid generic route | `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3` remains compiled |
| no semantic promotion | finite normalized block, product, LCU, block, oracle, unitary, final extraction, and resource flags remain false |
| post-baseline search | deferred until the GHL baseline closes |

Typed feedback should use:

```text
leaf=branch_decomposition_projection_bridge
error_class=symbolic_bridge_gap
next_route=lower2 compiles one non-promoting theorem-facing wrapper over the source-prepared slot-2 bridge and no-go guard
```

If lower2 attempts `backendExpansionStatement` or generic `projectionSummationStatement`, record `error_class=invalid_route`.

## Middle Validation

Middle checked the planned theorem statement with `lake env lean --stdin` under
`import QuantumBlockEncoding.RobinMatrix`; it parsed with only the expected
`sorry` warning from the temporary stdin proof. The declaration is not already
present in `QuantumBlockEncoding/RobinMatrix.lean` at packet release time.
