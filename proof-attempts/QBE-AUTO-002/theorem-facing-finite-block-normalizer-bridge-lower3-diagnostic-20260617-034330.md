# Lower3 Diagnostic: Finite Block Normalizer Bridge

Task: `QBE-AUTO-002`  
Run: `20260617-032739-QBE-AUTO-002-cycle01`  
Role: lower3 necessary-condition verifier  
Time: `2026-06-17 03:43:30 JST`

## Active Leaf

The active leaf checked here is
`theorem_facing_finite_block_normalizer_bridge`.  Middle named the planned
Lean surface as:

```lean
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_finiteBlockNormalizerEval_n3
```

This diagnostic is necessary because the wrapper should only replace
`interface.normalizedProjectionBridge.theoremNormalizer` with
`interface.finiteBlockNormalizer`.  If those two fields do not unfold to the
same normalizer, lower2 would be proving the wrong interface equality before
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.

## Lean-Local Diagnostic

A temporary `lake env lean --stdin` theorem passed.  It checked:

```text
interface.finiteBlockNormalizer = GHL2025.oneTermRobinNormalizer
interface.normalizedProjectionBridge.theoremNormalizer = GHL2025.oneTermRobinNormalizer
interface.finiteBlockNormalizer = interface.normalizedProjectionBridge.theoremNormalizer
focusedSystemRow = 0
focusedSystemColumn = 0
focusedSparseSlot = 2
signalBlockRowIndex = 0
signalBlockColumnIndex = 0
branchBasisIndex = 32
theoremFacingGateCount = 10
activeBackendGateCount = 7
fixedProductObligation = oneTermRobinGamma3ProductToCoefficientObligation 3 0 0
all downstream product/block/oracle/unitary/resource flags remain false
```

This is a shape and symbolic-normalizer check only.  It does not assert that
the slot-`2` projected branch product is the finite signal-zero block entry.
That branch-decomposition/projection bridge remains a separate blocked leaf.

## Verdict

No contradiction was found for the active normalizer-only wrapper.  Lower2 may
compile exactly one non-promoting wrapper theorem named
`oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_finiteBlockNormalizerEval_n3`.

Reject any route that treats this diagnostic as closure of normalized-block
equality, branch decomposition, product-to-coefficient, LCU correctness, block
correctness, oracle correctness, unitarity, resource scoring, post-baseline
search, or the OPTCTRL fallback.

## Typed Feedback

```json
{
  "leaf": "theorem_facing_finite_block_normalizer_bridge",
  "source_correspondence_ok": true,
  "finite_matrix_ok": true,
  "block_entry_ok": "normalizer_bridge_only",
  "normalizer_ok": true,
  "error_class": "symbolic_bridge_gap",
  "next_route": "lower2 may compile exactly one non-promoting finiteBlockNormalizerEval wrapper; do not assign product-to-coefficient or normalized-block equality from this diagnostic."
}
```
