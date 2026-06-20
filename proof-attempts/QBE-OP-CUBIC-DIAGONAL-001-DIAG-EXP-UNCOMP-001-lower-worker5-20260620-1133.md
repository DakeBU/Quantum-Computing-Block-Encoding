# Lower Worker 5 Packet: DIAG-EXP-UNCOMP-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`
Role: lower auxiliary proof-route worker 5
Timestamp: 2026-06-20 11:33 JST

## Source Object

The source anchor is the user prompt copied in
`tasks/QBE-OP-CUBIC-DIAGONAL-001.md`.  The fixed target remains the diagonal
operator

$$
D_n[row,col] =
\begin{cases}
(row/2^n)^3, & row = col,\\
0, & row \ne col,
\end{cases}
$$

with normalizer `exactNormalizer n = 1`.  This packet does not use rank-one
state preparation, does not normalize the diagonal vector, and does not add a
paper or cited-result dependency.

## Current Lean Boundary

The closed fixed-denominator arithmetic route has:

```lean
fixedDenomCubicArithmeticBackend :
  (n : Nat) -> ExpandedCubicArithmeticBackend n (3 * n)

fixedDenomCubicArithmeticBackend_computes :
  (n : Nat) ->
    expandedArithmeticBackendComputesCubicAmplitude
      (fixedDenomCubicArithmeticBackend n)

fixedDenomCubicArithmeticRouteTransparent :
  (n : Nat) ->
    expandedArithmeticComputesCubicAmplitudeTransparent n (3 * n)
```

The closed transparent rotation route has:

```lean
fixedDenomControlledRyRouteTransparent :
  (n : Nat) ->
    expandedControlledRyUsesCubicAngleTransparent n (3 * n)
```

The expanded clean-block contract now consumes the transparent arithmetic and
rotation predicates.  The next open route obligation is still opaque:

```lean
opaque expandedWorkspaceCleanUncomputed
    (n workspaceQubits : Nat) : Prop
```

## Clean-Uncompute Source Contract

For the selected fixed-denominator route, clean uncompute should state a path
property of the expanded circuit:

1. The system register starts at `j : Fin (gridSize n)` and is preserved.
2. The arithmetic workspace starts at
   `(fixedDenomCubicArithmeticBackend n).zeroWorkspace`.
3. The compute phase maps the clean workspace to the payload workspace that
   stores `j.val ^ 3` in `Fin (gridSize (3 * n))`.
4. The controlled `R_y` signal operation uses that payload only as a control or
   angle source and does not modify the system or arithmetic workspace.
5. The inverse arithmetic phase maps the post-rotation workspace back to the
   clean workspace, again preserving `j`.

The current `ExpandedCubicArithmeticBackend` structure records the compute map
and amplitude projection, but it does not record an inverse arithmetic map, a
permutation/reversibility proof, or a statement that the rotation layer leaves
the arithmetic workspace unchanged.  Therefore the current Lean surface is not
enough to prove `expandedWorkspaceCleanUncomputed n (3 * n)` honestly.

## Suggested Transparent Interface

A later lower Lean worker should not prove the opaque cleanup predicate by
`trivial`, by an axiom, or by replacing it with `True`.  The smallest honest
next interface is a transparent cleanup predicate that exposes the missing
route data before any bridge to the opaque predicate is considered.  One
Lean-facing shape is:

```lean
def expandedArithmeticBackendCleanUncomputes
    {n workspaceQubits : Nat}
    (backend : ExpandedCubicArithmeticBackend n workspaceQubits)
    (uncompute :
      Fin (gridSize n) -> backend.Workspace ->
        Prod (Fin (gridSize n)) backend.Workspace) : Prop :=
  forall j : Fin (gridSize n),
    uncompute (backend.compute j backend.zeroWorkspace).1
      (backend.compute j backend.zeroWorkspace).2 =
        (j, backend.zeroWorkspace)

def expandedWorkspaceCleanUncomputedTransparent
    (n workspaceQubits : Nat) : Prop :=
  Exists fun backend : ExpandedCubicArithmeticBackend n workspaceQubits =>
    And (expandedArithmeticBackendComputesCubicAmplitude backend)
      (Exists fun uncompute :
        Fin (gridSize n) -> backend.Workspace ->
          Prod (Fin (gridSize n)) backend.Workspace =>
        expandedArithmeticBackendCleanUncomputes backend uncompute)
```

This is only a contract sketch, not an edit made in this run.

If middle wants the statement to represent an actual gate-level inverse rather
than a path-cleanup certificate, the interface must also require that the
compute/uncompute pair is a permutation on the joint system-workspace basis, or
must point to a separate reversible arithmetic circuit semantics declaration.
In both versions, the rotation layer still needs an explicit no-touch
register-preservation fact, because
`expandedControlledRyUsesCubicAngleTransparent` currently records only scalar
clean-entry behavior.

## Fixed-Denominator Route Dependencies

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-TGT-001` | Diagonal target with normalizer `1`. | none | existing Lean | `cubicDiagonalOperator`, `cubicDiagonalTarget`, `exactNormalizer` | task packet | `python3 tools/qbe.py check` | proved |
| `DIAG-ARITH-FIXED-DENOM-BACKEND-001` | Compute payload `j.val ^ 3` in workspace `Fin (gridSize (3 * n))`. | capacity and amplitude algebra leaves | existing Lean | `fixedDenomCubicArithmeticBackend`, `fixedDenomCubicArithmeticBackend_computes` | fixed-denominator proof packets | `python3 tools/qbe.py check` | proved compute phase only |
| `DIAG-ARITH-TRANSPARENT-CONTRACT-001` | Consume transparent arithmetic compute witness in the clean-block contract. | fixed-denominator backend compute | existing Lean | `expandedArithmeticComputesCubicAmplitudeTransparent`, `fixedDenomCubicArithmeticRouteTransparent`, `expandedAmplitudeOracleCleanBlockContract` | contract refactor packet | `python3 tools/qbe.py check` | proved transparent bookkeeping |
| `DIAG-RY-TRANSPARENT-CONTRACT-001` | Consume transparent controlled-`R_y` scalar-angle witness in the clean-block contract. | scalar-tier clean-entry theorem | existing Lean | `expandedControlledRyUsesCubicAngleTransparent`, `fixedDenomControlledRyRouteTransparent`, `expandedAmplitudeOracleCleanBlockContract` | rotation contract packet | `python3 tools/qbe.py check` | proved transparent bookkeeping |
| `DIAG-EXP-UNCOMP-001` | State clean uncompute for the arithmetic workspace after rotation. | compute backend, rotation no-touch semantics, inverse arithmetic semantics | current packet | target `expandedWorkspaceCleanUncomputed`; proposed transparent cleanup interface | this packet | `python3 tools/qbe.py check` | active source-contract classified; Lean proof blocked by missing register semantics |
| `DIAG-EXP-BLOCK-001` | Extract the clean block and prove `diagonalCleanBlockContract n block`. | `DIAG-EXP-UNCOMP-001`, extraction semantics | future lower | `expandedAmplitudeOracleCleanBlockExtracts`, `expandedAmplitudeOracleCleanBlockContract_diagonal` | proof-obligation ledger | `python3 tools/qbe.py check` | blocked |
| `DIAG-ROOT-001` | Package an exact block-encoding certificate for the diagonal operator. | cleanup, extraction, unitarity/circuit semantics, resource score | future lower/reviewer | planned expanded certificate | candidate population | `python3 tools/qbe.py check` | blocked |

## Rejected Shortcuts

- Do not prove `expandedWorkspaceCleanUncomputed n (3 * n)` directly by
  `trivial`, by an axiom, or by changing its meaning.
- Do not reuse the primitive one-signal witness route; that belongs to a
  different semantic tier and its exact `Rat` no-workspace witness is already
  rejected.
- Do not turn the diagonal operator into rank-one state preparation.
- Do not claim block-entry extraction, unitarity, root certification, or
  executable exports from this cleanup source contract.

## Handoff

`DIAG-EXP-UNCOMP-001` should remain a shape/register semantics leaf until
middle chooses a transparent cleanup interface or introduces a concrete
reversible arithmetic circuit semantics.  The current fixed-denominator backend
is enough for compute values, but not enough by itself to prove that inverse
arithmetic restores the workspace after the controlled rotation.
