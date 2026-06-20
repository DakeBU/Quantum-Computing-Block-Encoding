# Proof Attempt: DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`
Role: lower worker 5
Timestamp: 2026-06-20 13:07 JST

## Leaf

The active leaf was the fixed-denominator transparent cleanup witness:

```lean
expandedWorkspaceCleanUncomputedTransparent n (3 * n)
```

The source target remains the diagonal operator
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise, with
`exactNormalizer n = 1`.  No paper source, cited theorem, or executable export
certificate is active.

## Patch

Added the modular add/sub cleanup lift adjacent to
`ExpandedArithmeticCleanUncomputeWitness`:

```lean
fixedDenomCubicComputeStep
fixedDenomCubicUncomputeStep
fixedDenomCubicComputeStep_matches_backend_on_clean
fixedDenomCubicUncomputeStep_after_compute
fixedDenomExpandedArithmeticCleanUncomputeWitness
fixedDenomWorkspaceCleanUncomputedTransparent
```

The compute step maps `(j,w)` to
`(j, (w + j.val ^ 3) % gridSize (3 * n))`.  The uncompute step maps `(j,w)` to
`(j, (w + gridSize (3 * n) - j.val ^ 3) % gridSize (3 * n))`.

The proof reuses `fixedDenomCubicPayload_lt_capacity` to keep the payload
inside the workspace modulus and proves the modular add/sub inverse equation
for every workspace value.  It also proves that the modular-add step agrees
with `fixedDenomCubicArithmeticBackend` on clean workspace.

## Boundary

This is still not a proof of `expandedWorkspaceCleanUncomputed`, not a
controlled-rotation workspace-readonly theorem, not a clean-block extraction
proof, not a unitarity proof, not a root block-encoding certificate, and not
an export authorization.

## Gate

Targeted file check passed:

```bash
lake env lean QuantumBlockEncoding/CubicStatePreparation.lean
```

Full project gate passed:

```bash
python3 tools/qbe.py check
```

The full gate ran `lake build` and `lake build Tests`.

## Typed Feedback

```text
leaf=DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001
blocked_parent=DIAG-EXP-UNCOMP-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
finite_mod_add_sub_cleanup_ok=true
finite_rotation_workspace_readonly_ok=true
lean_rotation_workspace_readonly_statement_present=false
normalizer_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
unitarity_ok=null
clean_block_extraction_ok=null
closed_theorem_ok=true
opaque_cleanup_predicate_closed=false
route_certificate_ok=false
exports_ok=false
error_class=symbolic_bridge_gap
next_route=state DIAG-RY-WORKSPACE-READONLY-001, then choose a nontrivial
  cleanup bridge or transparent contract refactor; keep extraction, unitarity,
  root, and exports blocked
```
