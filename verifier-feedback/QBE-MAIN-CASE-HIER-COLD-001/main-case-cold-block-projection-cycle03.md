# Verifier Feedback: COLD Block Projection Cycle 3

Leaf: `MAIN-BLOCK-PROJECTION-001`.

The block-projection leaf is closed by the compiled Lean declarations
`mainCaseColdQueryTarget`, `mainCaseColdBlockProjection`, and
`mainCaseColdPartialPerm_blockProjection` in
`QuantumBlockEncoding/MainCase.lean`.  The proof is task-local to the
`mainCaseCold*` namespace and does not use `mainCasePro*` as a certificate.

This accepts the operator-metadata and project-local block-projection layer
only.  It reuses the already compiled clean-block theorem
`mainCaseColdPartialPerm_clean_eq_target` and finite-bijection theorem
`mainCaseColdPartialPermImage_bijective`.  It does not claim a COLD
`OperatorBlockEncodingCandidate`, a COLD `VerifiedOperatorBlockEncoding`, a
gate/depth resource tuple, or any Qiskit/QASM3 export.

The cycle also names the remaining resource gap as
`mainCaseColdResourceSchemaObligation`, with `proved = false`.

Next route: `MAIN-RESOURCE-001`.  Derive a COLD-local circuit or schedule and
honest resource tuple, then prove the corresponding cost field theorems before
candidate packaging.
