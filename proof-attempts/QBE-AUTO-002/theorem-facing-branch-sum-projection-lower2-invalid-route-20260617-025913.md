# Theorem-Facing Branch-Sum Projection Lower2 Invalid Route

Task: `QBE-AUTO-002`
Run: `20260617-024407-QBE-AUTO-002-cycle01`
Role: lower2 Lean worker
Mode: `paperBenchmark`
Timestamp: `2026-06-17 02:59 JST`

## Leaf

`theorem_facing_branch_sum_projection_leaf`

Middle released the preferred target as either:

```lean
oneTermRobinGamma3BoundaryBranchContribution_sum_n3
```

or the equivalent generic surface:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement
```

## Lean Result

Lower2 did not prove the released generic projection-summation statement.  The
statement is equivalent to the unchanged backend-expansion route, and that
route is already refuted by the finite no-go guard.

Compiled declaration added in `QuantumBlockEncoding/RobinMatrix.lean`:

```lean
theorem oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3 :
    ¬ oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement
```

The proof transports any generic projection-summation proof through:

```lean
BlockExtractionBranchContributionTarget.backendExpansionStatement_of_projectionSummationStatement
```

and closes the contradiction with:

```lean
oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3
```

## Classification

The exact generic target is an invalid lower2 route.  It is not a tactic gap:
closing it would contradict the already compiled finite counterexample for the
unchanged H-free backend expansion.

Typed feedback:

```text
leaf=theorem_facing_branch_sum_projection_leaf
source_correspondence_ok=false
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=false
block_entry_ok=false
closed_theorem_ok=false
error_class=invalid_route
next_route=middle/lower1 must restate a corrected source-backed branch statement that is not definitionally equivalent to the refuted backendExpansionStatement; lower3 should recheck finite branch conditions before lower2 edits again
```

No product-to-coefficient, normalized-block, LCU, block projection,
block-correctness, final-extraction, oracle, unitarity, or resource flag was
promoted.
