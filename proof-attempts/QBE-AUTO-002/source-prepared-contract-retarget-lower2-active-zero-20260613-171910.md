# 2026-06-13 Lower2 Attempt: Active Column-0 Zero Diagnostic

Task: `QBE-AUTO-002`
Run: `20260613-170242-QBE-AUTO-002-cycle01`
Mode: `faithfulPaper`
Leaf: `active_eval_zero_diagnostic`

## Closed Lean Declaration

```lean
oneTermRobinGamma3BoundaryActiveEvalColumn0_zero_n3
```

The theorem proves the evaluated active H-free column-`0` entry is zero:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders
      (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3) = 0
```

Proof route:

- rewrite by `oneTermRobinGamma3BoundaryEvalGateMatricesColumn0Entry_eq_sevenGateMatrix_n3 env`;
- close with `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3 env`.

This is diagnostic-only.  It does not prove the source-prepared sparse-clean
feeder, does not revive the retired H-free selected-slot feeder, and does not
promote oracle, `H_W`, `R_y`, product, LCU, block, final-extraction, or
normalizer flags.

## Remaining Lean Goal

The theorem-facing leaf remains the branch-correct source-prepared field:

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
```

or the equivalent uncast prepared sparse-clean comparison exposed by

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3
  H env
```

under the explicit source contract
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.

## Gate

Passed before this note was written:

```bash
python3 tools/qbe.py check
```

The check rebuilt `lake build` and `lake build Tests` with only the known
diagnostic `sorry` warnings in the raw H-free declarations.
