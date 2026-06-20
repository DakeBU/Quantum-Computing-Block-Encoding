# Cubic Diagonal Oracle Block Encoding Status

Generated: 2026-06-20 15:40 JST

## Target

For `N = 2^n`, the target operator is the diagonal matrix $D_n$ with entry
$(j/N)^3$ on basis state `j` and zero off the diagonal.  The normalizer is
`alpha = 1`.  This task is not the rank-one cubic state-preparation problem.

## Lean-Supported Status

Lean has synchronized the target and normalizer through
`cubicDiagonalOperator`, `cubicDiagonalTarget`, and `exactNormalizer`.

The fixed-denominator arithmetic route has closed pointwise arithmetic leaves:
`fixedDenomCubicPayload_lt_capacity`, `fixedDenomCubicAmplitude_eq`,
`fixedDenomCubicArithmeticBackend`, `fixedDenomCubicArithmeticBackend_computes`,
`expandedArithmeticComputesCubicAmplitudeTransparent`, and
`fixedDenomCubicArithmeticRouteTransparent`.

The transparent controlled-`R_y` bookkeeping has also closed:
`expandedControlledRyUsesCubicAngleTransparent`,
`fixedDenomControlledRyRouteTransparent`, and the contract refactor that makes
`expandedAmplitudeOracleCleanBlockContract` consume the transparent rotation
predicate.  These declarations are route-interface evidence, not a proof of
the old opaque predicates and not a block-encoding certificate.

The transparent clean-uncompute interface is compiled:
`ExpandedArithmeticCleanUncomputeWitness`,
`expandedWorkspaceCleanUncomputedTransparent`, and
`expandedWorkspaceCleanUncomputedTransparent_of_witness`.  The fixed-denominator
transparent cleanup witness is also compiled as
`fixedDenomExpandedArithmeticCleanUncomputeWitness` and
`fixedDenomWorkspaceCleanUncomputedTransparent`.  These are interface and
cleanup-witness evidence only.  They do not prove the opaque cleanup predicate
and do not certify the route.

The active proof-DAG leaf is now
`DIAG-RY-WORKSPACE-READONLY-001`.  The intended next Lean work is to state a
transparent controlled-rotation workspace-readonly interface, tying the
existing transparent angle convention to a rotation step that preserves the
system index and arithmetic workspace.  Route-level cleanup or extraction must
not depend on the cleanup witness until this readonly statement and a later
bridge or contract refactor are recorded.

Clean-block extraction, unitarity/circuit semantics, the root certificate
`DIAG-ROOT-001`, and executable exports remain blocked.

## Human Entry Points

| Artifact | Role |
|---|---|
| `tasks/QBE-OP-CUBIC-DIAGONAL-001.md` | operator target and contract |
| `conversion-windows/QBE-OP-CUBIC-DIAGONAL-001.md` | Lean and natural-language correspondence |
| `proof-obligations/QBE-OP-CUBIC-DIAGONAL-001.md` | open obligations |
| `candidate-populations/QBE-OP-CUBIC-DIAGONAL-001.md` | certified, finite-executable, and insight-pool separation |
| `reports/QBE-OP-CUBIC-DIAGONAL-001/zh_status.md` | preferred-language status page |
| `reports/QBE-OP-CUBIC-DIAGONAL-001/latest.md` | English status mirror |
| `paper-notes/problem-exports/QBE-OP-CUBIC-DIAGONAL-001/latest.tex` | closeout LaTeX proof/status note |

## Blocker

The expanded route has transparent arithmetic, transparent rotation
bookkeeping, a transparent cleanup interface, and a fixed-denominator cleanup
witness.  It does not yet have a Lean workspace-readonly rotation statement.
Later work still needs route-level cleanup, clean-block extraction, and
unitarity before the root certificate can close.

## Claims Not Yet Allowed

Do not claim a Lean-certified exact block encoding, a proved primitive oracle
semantics, a fully unitary expanded gate circuit, a certified Qiskit,
QuantumKatas-style, or QASM3 export, resource optimality, or any replacement of
the diagonal target by a rank-one state-preparation construction.

## Executable Exports

The requested Qiskit, QuantumKatas-style, and QASM3 outputs remain blocked.
Create `executable-exports/QBE-OP-CUBIC-DIAGONAL-001/` only after a named Lean
certificate closes `DIAG-ROOT-001`.
