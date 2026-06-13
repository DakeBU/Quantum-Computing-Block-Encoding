# QBE-AUTO-002 lower2 blocked attempt: semantic eval product bridge

Run: `20260613-014104-QBE-AUTO-002-cycle01`

Leaf: `semantic_eval_product_bridge`

Target attempted:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3) =
Coeff.evalWith env
  (blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

This is the right-hand side of
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env`.

## Reused Compiled Facts

- `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3`
  exposes the active `evalGateMatrices` `[0,0]` entry against the backend fold.
- `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesUncastSevenGate_n3`
  records that the target has no `H_W^(kappa)` or dagger preparation gates on
  the active side.
- `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesExpandedSlotZeroFold_n3`
  expands the backend fold shape and exposes the slot-`0` weighted summand.
- `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3`
  collapses the evaluated backend fold to the selected slot-`2` contribution.
- `oneTermRobinGamma3BoundarySevenGateColumn0UsesSlot0_notGamma3Slot2_n3`
  records that the explicit seven-gate column-`0` analysis uses the slot-`0`
  half-angle symbols, not the gamma3 slot-`2` symbols.

## Failed Route

The direct proof route would need an evaluated associativity/product bridge
from the generic circuit fold

```lean
evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3))
```

to the explicit `oneTermRobinGamma3BoundarySevenGateMatrix_n3` entry at
`[0,0]`, without using the sorry-guarded raw constructor theorem
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`.

That bridge is not currently available.  The raw constructor route is also not
valid lower work for this packet: `evalGateMatrices` includes the identity seed
and a different syntactic nesting of project-local `Coeff` matrix products, so
the missing piece is an evaluated product/associativity theorem, not a local
`rfl` or `simp` tweak.

I did not add a Lean theorem because any available one-step closure would either
reuse the sorry-dependent diagnostic route or restate an already compiled
wrapper.  The H-free active `[0,0]` side is still shape-mismatched with the
source-prepared slot-`2` branch unless middle supplies a source-correct prepared
active-entry theorem or a new evaluated product bridge.

## Verifier Feedback

```text
leaf=semantic_eval_product_bridge
source_correspondence_ok=partial_h_free_target_exposes_active_slot0_while_source_prepared_route_uses_gamma3_slot2
lean_parse_ok=true_no_lean_edit
lean_build_ok=pending_gate
finite_matrix_ok=partial_existing_slot0_and_slot2_diagnostics_compile
block_entry_ok=false
ancilla_cleanup_ok=not_promoted
normalizer_ok=unchanged
closed_theorem_ok=false
error_class=shape_or_register_gap
next_route=middle should either supply a source-correct prepared active-entry theorem with H_W side gates, or assign a new evaluated associativity/product bridge for evalGateMatrices entries before another lower proof attempt on the H-free fold
```
