# Lower3 Diagnostic: Source-Corrected Product Feeder

Task: `QBE-AUTO-002`  
Run: `20260617-044631-QBE-AUTO-002-cycle01`  
Leaf: `source_corrected_product_feeder`  
Role profile: necessary-condition verifier

## Necessary Condition

The active lower leaf must feed the fixed boundary `gamma_3`, system entry
`(0,0)`, sparse slot `2` product route into
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` without reviving the
refuted generic backend projection/summation statement.

This is necessary because the source-shaped route uses the prepared
`H_W^(kappa)` clean-column contract and the boundary rotation entry
hypothesis, while the unchanged generic backend projection surface is already
contradicted by the finite all-one selected-slot check.

## Executed Diagnostic

No Lean source was edited by this lower3 pass.  A Lean stdin diagnostic imported
`QuantumBlockEncoding.RobinMatrix` after `python3 tools/qbe.py check` rebuilt the
module, then checked:

1. `oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3` has slot domain
   `[0,1,2,3,4,5,6]`, focused sparse slot `2`, selected-slot typing and eval
   compiled, while branch-family/summation closure remains false.
2. `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3`
   rejects the generic projection route.
3. `oneTermRobinGamma3BoundarySourcePreparedProjectionSlot2Product_feedsFixedProductMap_n3`
   supplies the source-prepared slot-`2` projected product route and keeps the
   fixed product obligation false.
4. `oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3`
   supplies the normalizer product only under explicit `hND`, `hNF`, `hkappa`,
   and `hkappaSqrt`.
5. The current worktree contains compiled wrapper
   `oneTermRobinGamma3BoundarySourceCorrectedProductFeederAudit_n3`; lower3
   treats it as verified route wiring, not as root theorem closure.

## Gate

`python3 tools/qbe.py check` passed.  It ran `lake build` and `lake build Tests`
with only the known diagnostic `sorry` warnings in
`QuantumBlockEncoding/RobinMatrix.lean`.

## Typed Feedback

```text
leaf=source_corrected_product_feeder
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
block_entry_ok=prepared/product feeder only; signal block branch-sum closure rejected
normalizer_ok=true under explicit hND, hNF, hkappa, hkappaSqrt
closed_theorem_ok=false
compiled_wrapper_ok=true
error_class=symbolic_bridge_gap
next_route=review/accept the non-promoting source-corrected feeder wrapper, then lower1/middle must name the next source-backed finite normalized block/projection or product-to-coefficient leaf; do not revive generic backend projection/expansion.
```

Reject active/prepared all-env closure, generic backend projection/expansion,
root product-to-coefficient closure, semantic flag promotion, post-baseline
candidate search, and OPTCTRL.
