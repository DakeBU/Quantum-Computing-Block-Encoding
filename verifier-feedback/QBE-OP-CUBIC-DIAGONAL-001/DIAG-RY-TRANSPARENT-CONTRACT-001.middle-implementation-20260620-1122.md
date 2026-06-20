# Middle Implementation Feedback: DIAG-RY-TRANSPARENT-CONTRACT-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

## Result

`DIAG-RY-TRANSPARENT-CONTRACT-001` is closed as a contract-boundary refactor.
The definition `expandedAmplitudeOracleCleanBlockContract` now consumes:

```lean
expandedControlledRyUsesCubicAngleTransparent n workspaceQubits
```

instead of the opaque rotation predicate.

## Scope

The source anchor remains the user-provided diagonal operator in
`tasks/QBE-OP-CUBIC-DIAGONAL-001.md`.  The operator is
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise, with
`exactNormalizer n = 1`.

This edit does not prove `expandedControlledRyUsesCubicAngle`, does not provide
`expandedControlledRyBackendBridge`, does not prove clean uncompute, does not
prove extraction or unitarity, and does not authorize executable exports.

## Gate

`python3 tools/qbe.py check` passed at 2026-06-20 11:22 JST.

## Next Route

The next source-correspondence leaf is `DIAG-EXP-UNCOMP-001`.  Lower 1 should
write the clean-uncompute contract against the fixed-denominator expanded route
before lower 2 edits Lean.  Lower 2 must not prove
`expandedWorkspaceCleanUncomputed` by `trivial`, by an axiom, or by setting a
semantic proposition to `True`.
