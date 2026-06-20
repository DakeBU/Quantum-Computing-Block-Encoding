# Middle Source Contract: DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`  
Updated: 2026-06-20 12:44 JST

## Source Anchor

The only source anchor is the user-provided diagonal operator in
`tasks/QBE-OP-CUBIC-DIAGONAL-001.md`.

The translated object is
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise, with
`exactNormalizer n = 1`.

## Lean Status

The transparent cleanup interface is compiled:

```lean
ExpandedArithmeticCleanUncomputeWitness
expandedWorkspaceCleanUncomputedTransparent
expandedWorkspaceCleanUncomputedTransparent_of_witness
```

These declarations do not prove the opaque predicate
`expandedWorkspaceCleanUncomputed`, do not instantiate the fixed-denominator
route, and do not close extraction, unitarity, `DIAG-ROOT-001`, or exports.

## Lower-Facing Contract

Target file: `QuantumBlockEncoding/CubicStatePreparation.lean`.

Allowed write scope: declarations adjacent to
`ExpandedArithmeticCleanUncomputeWitness` and
`expandedWorkspaceCleanUncomputedTransparent`.

The next Lean leaf is to instantiate the transparent cleanup interface for the
fixed-denominator route:

```lean
-- name may be adjusted to local style
def fixedDenomExpandedArithmeticCleanUncomputeWitness
    (n : Nat) : ExpandedArithmeticCleanUncomputeWitness n (3 * n)

theorem fixedDenomWorkspaceCleanUncomputedTransparent
    (n : Nat) :
    expandedWorkspaceCleanUncomputedTransparent n (3 * n)
```

The intended compute and uncompute steps are:

```text
computeStep(j,w) = (j, (w + j.val ^ 3) mod gridSize (3 * n))
uncomputeStep(j,w) =
  (j, (w + gridSize (3 * n) - j.val ^ 3) mod gridSize (3 * n))
```

The proof should reuse the fixed-denominator backend declarations
`fixedDenomCubicArithmeticBackend`,
`fixedDenomCubicArithmeticBackend_computes`, and
`fixedDenomCubicPayload_lt_capacity`.

## Separate Dependency

`DIAG-RY-WORKSPACE-READONLY-001` remains separate.  The finite diagnostic
records read-only rotation behavior in an identity-read model, but there is no
named Lean statement yet.  Do not use the transparent cleanup witness as a
route-level cleanup certificate until the workspace-readonly rotation
semantics are stated or the clean-block contract is explicitly refactored.

## Forbidden Routes

Do not prove `expandedWorkspaceCleanUncomputed` by `trivial`, by an axiom, or
by setting a semantic proposition to `True`.  Do not refactor
`expandedAmplitudeOracleCleanBlockContract` in this leaf.  Do not switch to
rank-one state preparation and do not prepare Qiskit, QuantumKatas-style, or
QASM3 exports.
