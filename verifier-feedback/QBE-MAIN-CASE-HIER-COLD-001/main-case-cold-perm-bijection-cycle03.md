# Verifier Feedback: COLD Finite Bijection Cycle 3

Leaf: `MAIN-PERM-UNITARY-001`.

The finite-bijection subleaf is closed by the compiled Lean theorem
`mainCaseColdPartialPermImage_bijective`.  The theorem uses the task-local
inverse table `mainCaseColdPartialPermPreimage` and does not depend on
`mainCasePro*` declarations.

The clean-block layer is already closed by
`mainCaseColdPartialPerm_clean_eq_target`.  The finite diagnostic still agrees
with the target support `(0,6)` and `(1,7)`, clean signal `0`, normalizer `1`,
one auxiliary signal qubit, and no oracle calls.

This feedback accepts the finite-permutation semantic tier only.  It does not
claim a rational-orthogonal matrix theorem, a COLD
`OperatorBlockEncodingCandidate`, a COLD `VerifiedOperatorBlockEncoding`, a
gate/depth resource tuple, or any Qiskit/QASM3 export.

Next route: `MAIN-BLOCK-PROJECTION-001`.  Define
`mainCaseColdQueryTarget`, define `mainCaseColdBlockProjection` with
`signalSystemBlockProjection`, and prove
`mainCaseColdPartialPerm_blockProjection`.  After that, schedule
`MAIN-RESOURCE-001`.
