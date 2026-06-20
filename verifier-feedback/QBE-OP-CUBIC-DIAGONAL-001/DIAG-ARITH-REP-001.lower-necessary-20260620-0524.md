# Verifier Feedback: DIAG-ARITH-REP-001 Lower Necessary Check

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Leaf: `DIAG-ARITH-REP-001`

Blocked parent: `DIAG-ARITH-BACKEND-BRIDGE-001`

## Active Leaf

`DIAG-ARITH-REP-001` is the active leaf because the parent bridge cannot be
checked until a concrete workspace/register/backend representation is named.
The necessary condition for any such representation is that its compute phase
preserves the system index `j` and exposes the payload
`CubicStatePreparation.cubicAmplitude n j = (j / 2^n)^3`.  If this condition
fails, the later clean-block relation would target the wrong diagonal entries.

## Diagnostic

I reran the existing task-local executable diagnostic:

```bash
python3 verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/diag_exp_arith_check.py --json-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-ARITH-REP-001.lower-necessary-20260620-0525.raw.feedback.json
```

The check covers `n = 1, 2, 3, 4, 5`.  It confirms the exact rational payload
`j^3 / 2^(3*n)`, diagonal support, off-diagonal vanishing, range in `[0,1]`,
normalizer `alpha = 1`, and system-index preservation for those finite
instances.

No concrete workspace representation changed in this pass, so the diagnostic
does not certify workspace capacity, clean uncompute, unitarity, controlled
`R_y` semantics, block-entry extraction, or a root certificate.

## Conclusion

There is no finite/path/support contradiction to the current diagonal target.
The rejection is narrower: direct proof search on
`DIAG-ARITH-BACKEND-BRIDGE-001` is still stale because
`workspace_representation_specified=false`.

## Typed Feedback

```text
leaf=DIAG-ARITH-REP-001
blocked_parent=DIAG-ARITH-BACKEND-BRIDGE-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
finite_arithmetic_ok=true
support_vanish_ok=true
system_preservation_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
closed_theorem_ok=false
workspace_representation_specified=false
workspace_capacity_checked=null
route_predicate_closed=false
checked_ns=[1,2,3,4,5]
error_class=symbolic_bridge_gap
next_route=name a concrete workspace/register/backend representation for DIAG-ARITH-REP-001, or keep DIAG-ARITH-BACKEND-BRIDGE-001 blocked
```
