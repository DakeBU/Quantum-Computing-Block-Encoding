# Lower3 Diagnostic: Prepared-Circuit Contract Correction

Task: `QBE-AUTO-002`  
Run: `20260617-042830-QBE-AUTO-002-cycle01`  
Leaf: `source_prepared_active_field_contract`  
Alias: `prepared_circuit_contract_correction`

## Necessary Condition

The active lower2 wrapper is allowed to expose the source-prepared singleton
clean entry through the theorem-facing finite block/projection interface.  It
must not turn the active seven-gate backend contract into the full Fig. 4
prepared circuit, and it must not promote any downstream semantic proof flag.

This is necessary because the source theorem uses the prepared
`H_W^(kappa)^dagger * U_gamma3_boundary * H_W^(kappa)` route, while
`oneTermRobinFiniteBlockCompositionContract 3` is still wired to
`oneTermRobinCircuitSemantics 3`.  If the interface entry were not
`PreparedCompositeSemantics(H).matrix clean clean`, or if the active backend
contract were silently replaced, lower2 would be proving the wrong target.

## Executed Diagnostic

No Lean file was edited.  A Lean stdin diagnostic imported
`QuantumBlockEncoding.RobinMatrix` and checked two examples:

1. The theorem-facing interface exposes
   `interface.sourcePreparedProjectionEntry = prepared.matrix clean clean`,
   keeps `interface.contractClaimSemantics = oneTermRobinCircuitSemantics 3`,
   distinguishes the 10-gate theorem-facing circuit from the 7-gate active
   backend, and leaves all downstream flags false.
2. `sourceTarget.preparedSingletonToSparseEvalStatement` typechecks via
   `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3`.

The diagnostic passed.

## Gate

`python3 tools/qbe.py check` passed.  It ran `lake build` and
`lake build Tests` with only the known diagnostic `sorry` warnings in
`QuantumBlockEncoding/RobinMatrix.lean`.

## Typed Feedback

```text
leaf=source_prepared_active_field_contract
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
block_entry_ok=true
ancilla_cleanup_ok=null
normalizer_ok=null
unitarity_ok=null
closed_theorem_ok=false
error_class=symbolic_bridge_gap
next_route=Lower2 may compile the non-promoting prepared-circuit contract correction wrapper; then prove or reduce oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env or its uncast equivalent.
```

Reject root product-to-coefficient closure, backend expansion/projection
summation as full Fig. 4 closure, circuit mutation, theorem-facing contract
substitution, semantic flag promotion, post-baseline search, and OPTCTRL.
