# QBE-AUTO-002 Lower 2: Source-Prepared Clean-Entry Alias

Created: 2026-06-09 JST
Role: lower Lean implementation worker
Mode: faithfulPaper

## Closed Leaf

Compiled the safe alias requested by the source-prepared clean-entry packet:

```lean
oneTermRobinGamma3BoundarySourcePreparedCleanEntryEval_eq_backendFold_n3
```

The theorem states that, under
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`, the
prepared singleton clean entry

```lean
(oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix
  oneTermRobinGamma3BoundarySparseCleanIndex_n3
  oneTermRobinGamma3BoundarySparseCleanIndex_n3
```

evaluates to

```lean
blockExtractionBranchContributionSum
  oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

It is a theorem-facing naming bridge over the already compiled evaluator
`oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`.

## Proof Route

The proof is direct reuse:

```lean
oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3
  H env hUniform
```

No oracle, `H_W`, `R_y`, LCU, product, block-projection, normalized-equality,
unitarity, block-correctness, or final-extraction flag was promoted.

## Remaining Leaf

The exact remaining mathematical leaf is still

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

or a strictly smaller finite matrix-entry lemma feeding it.  The H-free raw
`Coeff` constructor-equality route remains diagnostic/backlog.

## Local Check

Focused check passed:

```bash
lake env lean QuantumBlockEncoding/RobinMatrix.lean
```

Known diagnostic `sorry` warnings remain in `QuantumBlockEncoding/RobinMatrix.lean`.
