# Lower Implementation Blocked: DIAG-EXP-UNCOMP-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`
Timestamp: 2026-06-20 11:33 JST
Role: lower Lean implementation worker

## Result

No Lean declaration was added in this attempt.

The latest task-local dialogue and conversion window show that
`DIAG-RY-TRANSPARENT-CONTRACT-001` is already closed: the expanded clean-block
contract now consumes both transparent arithmetic and transparent controlled-Ry
predicates.  The next frontier is `DIAG-EXP-UNCOMP-001`, but the current packet
assigns lower 1 to write the clean-uncompute source contract before lower 2
edits Lean.

## Blocking Goal

The existing Lean target is still the opaque obligation:

```lean
expandedWorkspaceCleanUncomputed n workspaceQubits
```

There is no current transparent fixed-denominator clean-uncompute interface or
source-facing statement that lower 2 can compile without setting an opaque
semantic proposition to `True`, using `trivial`, or adding an axiom.

## Useful Next Route

Middle/lower 1 should state a narrow contract for `DIAG-EXP-UNCOMP-001` against
the fixed-denominator expanded route:

- workspace size is `3 * n`;
- workspace basis is `Fin (gridSize (3 * n))`;
- clean workspace value is `0`;
- compute writes payload `j.val ^ 3`;
- the inverse arithmetic restores the workspace to clean value `0`;
- the system index `j : Fin (gridSize n)` is preserved through compute,
  controlled rotation, and uncompute.

After that packet exists, lower 2 can either compile a transparent
clean-uncompute predicate and fixed-denominator witness, or a nontrivial bridge
to `expandedWorkspaceCleanUncomputed`, depending on the middle-approved route.

## Feedback

```text
leaf=DIAG-EXP-UNCOMP-001
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=true
closed_theorem_ok=false
error_class=source_translation_gap
next_route=middle/lower 1 should write the clean-uncompute source contract for the fixed-denominator expanded route before lower 2 edits Lean
```
