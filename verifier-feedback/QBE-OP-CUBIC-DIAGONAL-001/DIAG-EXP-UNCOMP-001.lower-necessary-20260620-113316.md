# DIAG-EXP-UNCOMP-001 lower necessary-condition feedback

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Role: lower necessary-condition verifier

## Active leaf

`DIAG-EXP-UNCOMP-001`: classify the clean-uncompute obligation for the
fixed-denominator expanded arithmetic/controlled-rotation route before a Lean
worker edits theorem-facing declarations.

This diagnostic is necessary because the current clean-block contract already
uses the transparent arithmetic and rotation route predicates, but it still
contains the open Lean obligation:

```lean
expandedWorkspaceCleanUncomputed n workspaceQubits
```

For the fixed-denominator route at `workspaceQubits = 3 * n`, clean uncompute
can only be plausible if the payload register can store `j^3`, the amplitude
projection is still `(j / 2^n)^3`, and a compute/uncompute skeleton restores
the workspace to zero on clean inputs.

## Diagnostic

Added and ran:

```bash
verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/diag_exp_uncomp_check.py \
  --lean-parse-ok true \
  --lean-build-ok true \
  --json-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-EXP-UNCOMP-001.lower-necessary-20260620-113316.feedback.json
```

The finite model checks `n = 1, 2, 3, 4` with a `3 * n`-qubit workspace:

- payload formula: `payload_j = j^3`
- capacity: `j^3 < 2^(3n)` for all tested `0 <= j < 2^n`
- amplitude projection: `payload_j / 2^(3n) = (j / 2^n)^3`
- clean compute/uncompute skeleton: `w -> w xor j^3 -> w`
- clean input support: workspace returns to `0`, and the system index is preserved

No contradiction was found.  This is not a proof of
`expandedWorkspaceCleanUncomputed`, not a clean-block extraction proof, not a
unitarity proof, not a root certificate, and not an export authorization.

## Typed verifier feedback

```text
leaf=DIAG-EXP-UNCOMP-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
fixed_denom_register_ok=true
finite_clean_uncompute_ok=true
normalizer_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
unitarity_ok=null
clean_block_extraction_ok=null
closed_theorem_ok=false
route_certificate_ok=false
executable_exports_created=false
error_class=symbolic_bridge_gap
next_route=Write a DIAG-EXP-UNCOMP-001 source contract or transparent clean-uncompute interface for the fixed-denominator compute/uncompute route; do not close expandedWorkspaceCleanUncomputed by trivial, by axiom, or by setting a semantic proposition to True.
```

## Rejection status

No finite/register rejection is issued for the fixed-denominator route.  The
remaining blocker is a symbolic bridge: middle still needs to state the
clean-uncompute contract/interface precisely before a Lean worker attempts one
small declaration.

Gate passed:

```bash
python3 tools/qbe.py check
```

This ran `lake build` and `lake build Tests`.
