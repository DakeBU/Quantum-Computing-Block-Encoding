# QBE-AUTO-002 Lower3 Necessary-Condition Diagnostic

Run: `20260613-050943-QBE-AUTO-002-cycle01`

Timestamp: `2026-06-13 05:25:20 JST`

Leaf: `source_prepared_finite_composition_leaf`

## Active Leaf

The checked leaf is:

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
```

Accepted equivalent source-shaped targets include:

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

This diagnostic is necessary because the leaf is source-correct only if the
right-hand side remains the prepared singleton/sparse clean entry for
`H_W^(kappa)^dagger * U * H_W^(kappa)`.  A proof route that silently replaces
that target by the standalone H-free active/backend fold is a register-shape
mistake, not theorem closure.

## Lean-Local Probe

The following stdin-only Lean probe passed:

```bash
lake env lean --stdin
```

The probe checked that:

- `SourcePreparedField(H, env)` is equivalent to the uncast active `[0,0]`
  evalWith equality against the prepared sparse clean-clean entry.
- The active gate list omits both `Gate.oracleCall "H_W^(kappa)"` and
  `Gate.oracleCall "(H_W^(kappa))^dagger"`.
- Under `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`,
  the uncast active/prepared target is equivalent to
  `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`.
- The source-prepared target flags still leave
  `activeProjectionBackendUsesPreparedEntry`,
  `activePreparedEntryEqualityProved`, `fullProductFoldProved`,
  `projectionSummationProved`, `productToCoefficientProved`,
  `lcuCorrectProved`, `blockProjectionProved`, `blockCorrectProved`, and
  `finalExtractionProved` as `false`.
- The active circuit and prepared singleton circuit are distinct.

## Rejection

Reject the standalone H-free evaluated backend fold as a proof of this leaf.
The active seven-gate list has no `H_W^(kappa)` side gates, while the
source-prepared target compares the active signal-zero entry to the prepared
singleton clean entry.  The backend fold is a downstream recovery after the
source-prepared field closes and the explicit `Uniform(H)` contract is
available.

The current arbitrary-`H` lower target should not be closed by adding
`hUniform` locally.  If the finite theorem only holds under the paper
clean-column contract, middle should restate the source-backed target with that
contract explicit or require an independence theorem.

## Typed Feedback Summary

```json
{
  "leaf": "source_prepared_finite_composition_leaf",
  "source_correspondence_ok": false,
  "finite_matrix_ok": "source_shape_checks_passed_but_arbitrary_H_not_closed",
  "block_entry_ok": false,
  "error_class": "source_translation_gap",
  "next_route": "prove the source-prepared active/prepared field by a strict finite composition theorem, prove an independence theorem for the arbitrary-H clean entry, or have middle restate the target with Uniform(H) explicit; do not reassign the standalone H-free evaluated fold"
}
```
