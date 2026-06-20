# Middle Coordinator Packet: DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Updated: 2026-06-20 12:16 JST

## Source Correspondence

The source anchor is the user-provided diagonal operator in
`tasks/QBE-OP-CUBIC-DIAGONAL-001.md`.  The target remains
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise, with
`exactNormalizer n = 1`.

No paper source, cited theorem, or executable export certificate is active.

## Active Leaf

The active lower-facing leaf is
`DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001`.  It should expose reversible
cleanup data through a transparent interface adjacent to the opaque obligation
`expandedWorkspaceCleanUncomputed`.

This leaf is not the modular add/sub fixed-denominator witness, not a proof of
`expandedWorkspaceCleanUncomputed`, not clean-block extraction, not unitarity,
not `DIAG-ROOT-001`, and not an executable export.

## Lower Packets

| Role | Packet |
|---|---|
| lower 1 natural-language architect | Keep `DIAG-EXP-UNCOMP-001` as a blocked parent.  Refine only the dependency map from the transparent cleanup interface to the later fixed-denominator modular add/sub witness and separate rotation workspace-readonly dependency. |
| lower 2 Lean worker | Edit only declarations adjacent to `expandedWorkspaceCleanUncomputed` in `QuantumBlockEncoding/CubicStatePreparation.lean`.  Add `ExpandedArithmeticCleanUncomputeWitness` and `expandedWorkspaceCleanUncomputedTransparent`; do not instantiate a witness in this leaf. |
| lower 3 necessary-condition verifier | Prepare a diagnostic for the modular add/sub cleanup route and record `finite_mod_add_sub_cleanup_ok` and `rotation_workspace_readonly_ok`.  Keep block-entry, extraction, unitarity, route certificate, and export fields blocked or `null`. |

## Typed Feedback

```text
leaf=DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001
blocked_parent=DIAG-EXP-UNCOMP-001
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=true
finite_mod_add_sub_cleanup_ok=null
rotation_workspace_readonly_ok=null
finite_xor_diagnostic_reused_for_mod_add_sub=false
normalizer_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
unitarity_ok=null
clean_block_extraction_ok=null
closed_theorem_ok=false
route_certificate_ok=false
error_class=shape_or_register_gap
next_route=compile the transparent cleanup interface only; then separately
  instantiate modular add/sub cleanup and check rotation workspace-readonly
```
