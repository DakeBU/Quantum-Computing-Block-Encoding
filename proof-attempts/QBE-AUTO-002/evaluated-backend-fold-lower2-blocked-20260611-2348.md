# QBE-AUTO-002 Lower2 Blocked Route: Evaluated Backend Fold

## Leaf

`unitary_fold_leaf` / `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`

## Attempted Route

I tested the existing tail bridge
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` by replacing
its final `sorry` with `rfl` after the existing `simp only` expansion.

Lean rejected the route with:

```text
maximum recursion depth has been reached
```

The patch was reverted.  No persistent Lean declaration was changed by this
attempt.

## Diagnosis

The evaluated backend fold is equivalent to an H-free active `[0,0]`
`evalGateMatrices` entry compared with the backend fold.  Existing compiled
backend-side support collapses the evaluated backend fold to the selected
slot-`2` contribution, while the active seven-gate diagnostic for column `0`
uses the column-`0` support route.  Closing the current target by raw matrix
equality would require a semantic associativity/evaluation bridge for the
project-local syntactic `Coeff` matrices; raw `Matrix.mul` associativity is not
available as definitional equality.

## Typed Verifier Feedback

```text
leaf=unitary_fold_leaf
source_correspondence_ok=partial
lean_parse_ok=true_after_revert
lean_build_ok=true
finite_matrix_ok=partial_backend_fold_collapses_to_slot_2
block_entry_ok=false
ancilla_cleanup_ok=not_promoted
normalizer_ok=unchanged
closed_theorem_ok=false
error_class=shape_or_register_gap
next_route=middle should refresh the active leaf around a source-backed prepared projection theorem or supply a semantic evalWith associativity bridge before another lower proof attempt on the H-free active [0,0] fold
```
