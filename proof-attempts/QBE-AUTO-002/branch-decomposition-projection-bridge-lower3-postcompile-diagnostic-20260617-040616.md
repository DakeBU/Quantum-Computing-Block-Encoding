# Branch Decomposition Projection Bridge: Lower3 Postcompile Diagnostic

Task: `QBE-AUTO-002`  
Run: `20260617-034830-QBE-AUTO-002-cycle01`  
Role: lower3 necessary-condition verifier  
Mode: `paperBenchmark`  
Leaf: `branch_decomposition_projection_bridge`

## Active Leaf

The active leaf checks the corrected theorem-facing source-prepared clean
projection route for GHL2025 boundary `gamma_3`, system entry `(0,0)`, sparse
slot `2`, and branch product `[32,32]`.

This diagnostic is necessary before the product-to-coefficient root because
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` must consume the
source-prepared slot-`2` branch product, not the refuted generic backend
projection-summation surface.

## Diagnostic

During the lower3 check, the planned lower2 theorem was already present in
`QuantumBlockEncoding/RobinMatrix.lean`:

```lean
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_branchDecompositionProjectionBridge_n3
```

I treated the leaf as postcompile/stale for further lower2 assignment and ran a
non-persistent Lean `example` over stdin with the same necessary-condition
shape.  The example checked:

- `interface.sourcePreparedProjectionEntry` evaluates to
  `interface.normalizedProjectionBridge.projectedBranchProduct`;
- the same source-prepared entry evaluates to
  `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct`;
- the source-prepared entry is the prepared projection target field;
- the theorem-facing circuit still differs from the active backend circuit;
- `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3`
  rejects the generic route;
- corrected finite block/projection, product, normalized block, LCU, block,
  final extraction, oracle, unitary, and resource flags remain false.

The stdin diagnostic passed after `lake build QuantumBlockEncoding.RobinMatrix`.
The module build produced only the known diagnostic `sorry` warnings in
`RobinMatrix.lean` around the H-free raw Coeff fold diagnostics.

## Rejection

No finite/path/support contradiction was found for the corrected source-prepared
slot-`2` branch bridge.  The rejected route remains:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement
```

and anything deriving from

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

for this leaf.  These are invalid routes for the paper benchmark baseline.

## Typed Feedback

```json
{
  "leaf": "branch_decomposition_projection_bridge",
  "source_correspondence_ok": true,
  "finite_matrix_ok": true,
  "block_entry_ok": true,
  "normalizer_ok": true,
  "invalid_generic_route_rejected": true,
  "semantic_promotion_ok": true,
  "closed_theorem_ok": true,
  "error_class": "stale_leaf",
  "next_route": "Retire branch_decomposition_projection_bridge as compiled; next diagnose fixed_product_to_coefficient before attempting oneTermRobinGamma3ProductToCoefficientObligation 3 0 0."
}
```
