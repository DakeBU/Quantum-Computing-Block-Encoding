# Fixed Product-To-Coefficient Pre-Audit: Lower3 Postcompile Diagnostic

Task: `QBE-AUTO-002`  
Run: `20260617-041033-QBE-AUTO-002-cycle01`  
Role: lower3 necessary-condition verifier  
Mode: `paperBenchmark`  
Leaf: `fixed_product_to_coefficient_pre_audit`

## Active Leaf

The active wrapper is now compiled:

```lean
oneTermRobinGamma3BoundaryFixedProductToCoefficientPreAudit_n3
```

This postcompile packet supersedes the earlier lower3 precompile diagnostic
`verifier-feedback/QBE-AUTO-002/fixed-product-to-coefficient-preaudit-lower3-20260617-042237.json`.
That earlier packet was correct when written, but a concurrent lower2 completed
the wrapper before this verifier turn finished.

## Diagnostic

I ran a postcompile stdin check:

```lean
import QuantumBlockEncoding.RobinMatrix

open QuantumBlockEncoding
open QuantumBlockEncoding.Examples.RobinHeat

#check oneTermRobinGamma3BoundaryFixedProductToCoefficientPreAudit_n3
#check oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3
#check oneTermRobinGamma3BoundaryBlockExtractionBackendGap_n3_transcript
```

The same stdin file then invoked
`oneTermRobinGamma3BoundaryFixedProductToCoefficientPreAudit_n3` on the exact
pre-audit conjunction.  It passed.

## Necessary Conditions

The compiled wrapper satisfies the lower3 checks:

- `source_correspondence_ok=true`: source-prepared slot-`2` boundary `gamma_3`
  route for GHL2025 Theorem `theorem: 1 term robin`, Eq.
  `eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, and Definition
  `def:block-encoding`.
- `finite_matrix_ok=true`: typed `n=3` source-prepared route only; no
  normalized-block theorem is claimed.
- `block_entry_ok=true`: the source-prepared entry/product equality and finite
  normalizer equality are exposed by the wrapper.
- `normalizer_ok=true`: only under explicit `hND`, `hNF`, `hkappa`, and
  `hkappaSqrt`.
- `closed_theorem_ok=true`: the wrapper is now a named Lean theorem.
- `BackendGap` remains active: `backendFieldAvailable=false`,
  `projectionSummationProved=false`, and `productToCoefficientProved=false`.

## Rejection

Do not reassign lower2 to this leaf.  Reject any next route that assumes:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

Also reject using
`oneTermRobinGamma3BoundaryProjectionSummationProductBridge_leaf_n3` as closure
or marking `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` proved.

## Next Route

Retire `fixed_product_to_coefficient_pre_audit` as compiled route memory.  The
next narrow leaf should be `backend_sourced_sparse_summand_interface`: a
backend-sourced `Fin 7 -> Coeff` summand family for the signal/system `(0,0)`
entry, with the selected slot `2` and branch-sum predicates tied to
`BlockExtractionTarget`, before any root product-to-coefficient attempt.

## Typed Feedback

```json
{
  "leaf": "fixed_product_to_coefficient_pre_audit",
  "source_correspondence_ok": true,
  "finite_matrix_ok": true,
  "block_entry_ok": true,
  "normalizer_ok": true,
  "closed_theorem_ok": true,
  "error_class": "stale_leaf",
  "next_route": "Retire the wrapper and prepare backend_sourced_sparse_summand_interface while keeping BackendGap active."
}
```
