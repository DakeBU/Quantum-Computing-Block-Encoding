# 2026-06-13 Lower2 Attempt: Backend-Fold Obstruction Witness

Task: `QBE-AUTO-002`  
Run: `20260613-182230-QBE-AUTO-002-cycle01`  
Mode: `faithfulPaper`  
Leaf: `branch_correct_evaluated_backend_fold_obstruction`

## Compiled Lean Leaf

Closed:

```lean
oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3
```

The theorem proves that, under the concrete environment

```lean
fun name =>
  if name = "f_3_0" then 1
  else if name = "N_f_inv" then 1
  else if name = "boundary_cos_half_0_2" then 1
  else if name = "sqrt_kappa_inv" then 1
  else 0
```

the selected slot-`2` contribution evaluates to `1`.

The proof reuses:

- `oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_n3`
- `oneTermRobinGamma3BoundaryBranchEntrySelection_n3_transcript`

It does not prove the retired all-environment H-free backend fold, does not
revive the row-`0` to slot-`2` feeder, and does not add `hUniform` to the
H-free obstruction.

## Remaining Goal

The retired root

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

remains blocked as a finite-matrix counterexample in the current row/register
contract.  Middle/reviewer should restate the source-prepared target before
assigning more lower2 proof search.

## Gate

Passed:

```bash
python3 tools/qbe.py check
```

The check ran `lake build` and `lake build Tests`; both succeeded with only the
known diagnostic `sorry` warnings in `QuantumBlockEncoding/RobinMatrix.lean`.
