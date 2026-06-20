# Lower Refiner Attempt: DIAG-EXP-UNCOMP-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`
Role: lower refiner/reducer
Mode: exploratory construction
Timestamp: 2026-06-20 11:35 JST

## Exact Failed Theorem / Route

No Lean theorem was attempted in this refiner pass.  The live dialogue has
already closed `DIAG-RY-TRANSPARENT-CONTRACT-001`, and the current next leaf is
`DIAG-EXP-UNCOMP-001`.

The rejected route is a lower-2/refiner edit that tries to close

```lean
expandedWorkspaceCleanUncomputed n workspaceQubits
```

directly, or to insert it into the expanded clean-block contract as if the
clean-uncompute semantics were already available.

There is no Lean parser or elaborator error from this pass.  The route is
rejected before editing because the latest middle handoff says lower 1 must
first write the clean-uncompute contract against the fixed-denominator expanded
route.  Closing the opaque semantic proposition by `trivial`, an axiom, or by
setting a proposition to `True` would be contract drift.

## Smaller Proof-Reduction Record

The smaller leaf is not a tactic repair.  It is the missing transparent
source/route interface for clean uncompute:

- define the exact register/workspace clean-uncompute condition for the
  fixed-denominator expanded route;
- keep the statement tied to the diagonal operator target and alpha `1`;
- do not prove `expandedWorkspaceCleanUncomputed` until that interface has a
  nontrivial route-semantics witness.

The existing compiled clean-block contract already consumes transparent
arithmetic and transparent controlled-`R_y` witnesses:

```lean
expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits
expandedControlledRyUsesCubicAngleTransparent n workspaceQubits
```

The next narrow route should therefore add or record the clean-uncompute
contract, not retry the closed rotation refactor or attack `DIAG-ROOT-001`.

## Feedback

- `leaf`: `DIAG-EXP-UNCOMP-001`
- `lean_parse_ok`: `true`
- `lean_build_ok`: `true` (`python3 tools/qbe.py check`)
- `closed_theorem_ok`: `false`
- `error_class`: `source_translation_gap`
- `next_route`: lower 1 writes the clean-uncompute source contract; after that,
  lower 2 may target one adjacent Lean declaration that consumes the transparent
  clean-uncompute interface without proving opaque semantics by shortcut.

## Keep / Retry / Reject

Keep this refiner record as a blocked-route guard.  Retry only after the
clean-uncompute source contract exists.  Reject any direct proof attempt that
sets `expandedWorkspaceCleanUncomputed` to `True`, adds an axiom, or changes the
diagonal block-encoding target.
