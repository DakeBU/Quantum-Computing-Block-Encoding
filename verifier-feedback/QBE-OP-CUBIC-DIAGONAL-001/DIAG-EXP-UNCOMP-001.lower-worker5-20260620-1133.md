# Verifier Feedback: DIAG-EXP-UNCOMP-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Leaf: `DIAG-EXP-UNCOMP-001`

Role: lower auxiliary proof-route worker 5

Timestamp: 2026-06-20 11:33 JST

## Attempt Summary

I classified the clean-uncompute leaf against the current Lean surface and
wrote the source-contract packet:

```text
proof-attempts/QBE-OP-CUBIC-DIAGONAL-001-DIAG-EXP-UNCOMP-001-lower-worker5-20260620-1133.md
```

No Lean code was changed.  The current fixed-denominator backend proves only
the compute phase and amplitude projection.  It does not expose an inverse
arithmetic map, a register-level no-touch statement for the controlled
rotation, or a reversible circuit semantics proof.  Therefore direct proof
search for `expandedWorkspaceCleanUncomputed n (3 * n)` is not a ready lower
Lean leaf.

## Typed Feedback

```text
leaf=DIAG-EXP-UNCOMP-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=null
block_entry_ok=null
unitarity_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
closed_theorem_ok=false
clean_uncompute_contract_ok=true
current_lean_surface_sufficient=false
route_certificate_ok=false
exports_ok=false
error_class=shape_or_register_gap
next_route=middle should introduce a transparent clean-uncompute interface, or a concrete reversible arithmetic circuit semantics with rotation workspace-preservation, before lower 2 attempts a Lean proof; keep extraction, unitarity, root certificate, and exports blocked
```

## Gate

`python3 tools/qbe.py check` passed for this documentation-only attempt.
