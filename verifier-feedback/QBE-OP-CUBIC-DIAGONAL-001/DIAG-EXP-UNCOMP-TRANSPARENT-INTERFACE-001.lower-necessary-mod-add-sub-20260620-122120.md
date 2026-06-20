# DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001 lower necessary-condition feedback

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Role: lower necessary-condition verifier

## Active leaf

`DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001`, with checked subleaf
`DIAG-EXP-UNCOMP-REV-LIFT-001`.

This diagnostic is necessary for the clean-uncompute route because the expanded
contract already consumes transparent arithmetic and rotation bookkeeping, while
the cleanup path still needs a reversible fixed-denominator witness.  Before a
Lean worker proves or packages that witness, the modular add/sub route must at
least satisfy the finite register facts:

- `3 * n` workspace qubits give modulus `2^(3n)`;
- payload `p_j = j^3` fits in that workspace;
- `p_j / 2^(3n) = (j / 2^n)^3`, preserving the diagonal target and alpha `1`;
- compute by modular addition and uncompute by modular subtraction are inverse
  workspace permutations;
- the rotation step is only modeled as a read-only workspace access.

## Diagnostic

Added and ran:

```bash
verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/diag_exp_uncomp_mod_add_sub_check.py \
  --lean-parse-ok true \
  --lean-build-ok true \
  --json-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001.lower-necessary-mod-add-sub-20260620-122120.feedback.json
```

The checker exhaustively tests the workspace values for `n = 1, 2, 3, 4`.
For each tested `j` and workspace value `w`, it checks:

```text
compute(j, w) = (j, (w + j^3) mod 2^(3n))
uncompute(j, w) = (j, (w + 2^(3n) - j^3) mod 2^(3n))
uncompute(j, compute(j, w).2) = (j, w)
compute(j, uncompute(j, w).2) = (j, w)
```

It also checks clean-input compatibility with the current fixed-denominator
backend: `compute(j, 0) = (j, j^3)`, so the amplitude register reads
`j^3 / 2^(3n) = (j / 2^n)^3`.

## Result

No finite/register rejection is issued.

The modular add/sub cleanup route passes the finite necessary condition:

```text
finite_matrix_ok=true
fixed_denom_register_ok=true
finite_mod_add_sub_cleanup_ok=true
rotation_workspace_readonly_ok=true
normalizer_ok=true
```

The read-only rotation flag is finite-model feedback only.  The Lean surface has
the transparent cleanup interface, but this verifier found no named Lean
statement for rotation workspace-readonly semantics:

```text
transparent_uncompute_interface_present=true
lean_rotation_workspace_readonly_statement_present=false
```

No block-entry, clean-block extraction, unitarity, root certificate, or export
claim is made.

## Typed verifier feedback

```text
leaf=DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001
checked_subleaf=DIAG-EXP-UNCOMP-REV-LIFT-001
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
next_route=Instantiate the fixed-denominator modular add/sub witness for the
  transparent clean-uncompute interface and add a named workspace-readonly
  rotation statement; keep block-entry, extraction, unitarity, root certificate,
  and exports blocked.
```

Gate passed:

```bash
python3 tools/qbe.py check
```

This ran `lake build` and `lake build Tests`.
