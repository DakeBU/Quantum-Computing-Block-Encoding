# DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001 lower necessary-condition feedback

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Role: lower necessary-condition verifier

## Active Leaf

`DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001`, with checked subleaf
`DIAG-EXP-UNCOMP-REV-LIFT-001`.

This diagnostic is necessary for the active leaf because the proposed witness
for `expandedWorkspaceCleanUncomputedTransparent n (3 * n)` uses fixed
denominator arithmetic with payload `j^3`.  Before a Lean worker packages that
witness, the finite register behavior must satisfy:

- `3 * n` workspace qubits give modulus `2^(3*n)`;
- payload `p_j = j^3` fits in the workspace;
- `p_j / 2^(3*n) = (j / 2^n)^3`, preserving the diagonal target and alpha `1`;
- compute by modular addition and uncompute by modular subtraction are inverse
  workspace permutations;
- the rotation step is modeled only as a read-only workspace access.

## Diagnostic

Added and ran the current-leaf wrapper:

```bash
python3 verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/diag_exp_uncomp_fixed_denom_witness_check.py --lean-parse-ok true --lean-build-ok true --json-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001.lower-necessary-mod-add-sub-20260620-130446.feedback.json
```

The checker reuses the existing modular add/sub finite diagnostic and
retargets its typed feedback to the active fixed-denominator witness leaf.  It
exhaustively checks all workspace values for `n = 1, 2, 3, 4`.

For each tested `j` and workspace value `w`, it checks:

```text
compute(j, w) = (j, (w + j^3) mod 2^(3*n))
uncompute(j, w) = (j, (w + 2^(3*n) - j^3) mod 2^(3*n))
uncompute(j, compute(j, w).2) = (j, w)
compute(j, uncompute(j, w).2) = (j, w)
```

It also checks clean-input compatibility with the current fixed-denominator
backend: `compute(j, 0) = (j, j^3)`, so the amplitude register reads
`j^3 / 2^(3*n) = (j / 2^n)^3`.

## Result

No finite/register rejection is issued for the active cleanup-witness route.

```text
finite_matrix_ok=true
fixed_denom_register_ok=true
finite_mod_add_sub_cleanup_ok=true
rotation_workspace_readonly_ok=true
normalizer_ok=true
```

The read-only rotation flag is finite-model feedback only.  The Lean surface
still has no named rotation workspace-readonly statement:

```text
lean_rotation_workspace_readonly_statement_present=false
```

No block-entry, clean-block extraction, unitarity, root certificate, or export
claim is made.

## Typed Verifier Feedback

```text
leaf=DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001
checked_subleaf=DIAG-EXP-UNCOMP-REV-LIFT-001
separate_dependency=DIAG-RY-WORKSPACE-READONLY-001
blocked_parent=DIAG-EXP-UNCOMP-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
fixed_denom_register_ok=true
finite_mod_add_sub_cleanup_ok=true
rotation_workspace_readonly_ok=true
transparent_uncompute_interface_present=true
lean_rotation_workspace_readonly_statement_present=false
normalizer_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
unitarity_ok=null
clean_block_extraction_ok=null
closed_theorem_ok=false
route_certificate_ok=false
error_class=symbolic_bridge_gap
next_route=Implement the fixed-denominator modular add/sub witness for
  expandedWorkspaceCleanUncomputedTransparent n (3 * n), and separately state
  DIAG-RY-WORKSPACE-READONLY-001 before using cleanup evidence for any
  route-level clean-uncompute, block-entry, unitarity, root, or export claim.
```

Gate passed:

```bash
python3 tools/qbe.py check
```

This ran `lake build` and `lake build Tests`.
