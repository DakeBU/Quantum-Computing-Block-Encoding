# Proof-backed teaching route closure

This audit records the bounded routes closed before promotion to `main`.  The
listed website cards may be labelled **Compiled** only while these declarations
remain in the generated inventory and the full Pages/Lean gate passes.

## Banded sparse access

The arbitrary-size semantic permutation remains in
`QuantumBlockEncoding.BandedSparseAccess`.  The finite compiler witness is the
three-bit, clean-workspace realization in
`QuantumBlockEncoding.BandedSparseAccessPrimitive`:

- `BandedSparseAccess.primitiveAccess3_cleanAction`
- `BandedSparseAccess.primitiveAccess3Program_eval`
- `BandedSparseAccess.primitiveAccess3Program_unitary`
- `BandedSparseAccess.primitiveAccess3Program_oracleCalls_eq_zero`

This does **not** claim the paper's arbitrary-width one-qubit/CNOT upper bound.

## Cubic amplitude oracle

The fixed two-system-qubit primitive realization is closed by:

- `CubicDiagonalOracle.cubicN2PrimitiveProgram_cleanEntry`
- `CubicDiagonalOracle.cubicN2PrimitiveFlatUnitary_unitary`
- `CubicDiagonalOracle.cubicN2PrimitiveFlatUnitary_cleanBlock`
- `CubicDiagonalOracle.cubicN2PrimitiveVerifiedBlockEncoding`
- `CubicDiagonalOracle.cubicN2Primitive_oracleCalls_eq_zero`

This does **not** claim scalable arithmetic synthesis or general QSVT phase
factor synthesis.

## Three-layer harness

The typed handoff route is closed by:

- `threeLayerCanonicalTrace_allValid`
- `threeLayerCanonicalTrace_reachesAccepted`
- `threeLayerAccepted_requiresLeanGate`
- `threeLayerAccepted_requiresReviewerApproval`
- `threeLayerFailedGateTrace_notAccepted`

External model execution, token use, and wall-clock efficiency remain
engineering evidence rather than Lean theorems.

## Open-problem registry

The registry itself is audited by:

- `openProblems_count`
- `openProblemIds_nodup`
- `openProblems_all_actionable`
- `openProblemRegistry_compiled`

The seven entries remain open mathematical or engineering problems.  Compiling
the registry does not mark those problems solved.

## Promotion rule

Promotion to `main` requires the same commit to pass the complete repository
workflow: library and `Tests` builds, harness tests, proof-trust checks,
executable case replay, generated-catalog check, Verso Blueprint build, unified
site checks, and Pages artifact validation.
