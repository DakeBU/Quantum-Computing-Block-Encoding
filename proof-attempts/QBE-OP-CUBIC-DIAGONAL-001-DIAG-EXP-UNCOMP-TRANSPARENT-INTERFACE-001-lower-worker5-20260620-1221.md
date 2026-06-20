# Proof Attempt: DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`
Role: lower worker 5
Timestamp: 2026-06-20 12:21 JST

## Leaf

The active leaf was the transparent cleanup interface adjacent to the opaque
obligation:

```lean
expandedWorkspaceCleanUncomputed
```

The source target remains the diagonal operator
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise, with
`exactNormalizer n = 1`.  No paper source, cited theorem, or executable export
certificate is active.

## Patch

Added:

```lean
structure ExpandedArithmeticCleanUncomputeWitness
    (n workspaceQubits : Nat)
```

The witness records a backend, its pointwise compute proof, a `computeStep`, an
`uncomputeStep`, index-preservation for both steps, agreement with the backend
on clean workspace, and the cleanup equation:

```lean
forall j w, uncomputeStep j (computeStep j w).2 = (j, w)
```

Added:

```lean
def expandedWorkspaceCleanUncomputedTransparent
    (n workspaceQubits : Nat) : Prop :=
  Nonempty (ExpandedArithmeticCleanUncomputeWitness n workspaceQubits)
```

This is only a transparent interface.  It does not instantiate the
fixed-denominator modular add/sub witness, does not prove
`expandedWorkspaceCleanUncomputed`, does not refactor
`expandedAmplitudeOracleCleanBlockContract`, and does not close extraction,
unitarity, `DIAG-ROOT-001`, or exports.

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
leaf=DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001
blocked_parent=DIAG-EXP-UNCOMP-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=null
finite_mod_add_sub_cleanup_ok=null
rotation_workspace_readonly_ok=null
finite_xor_diagnostic_reused_for_mod_add_sub=false
normalizer_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
unitarity_ok=null
clean_block_extraction_ok=null
closed_declarations=ExpandedArithmeticCleanUncomputeWitness,expandedWorkspaceCleanUncomputedTransparent
closed_theorem_ok=true
opaque_cleanup_predicate_closed=false
route_certificate_ok=false
exports_ok=false
error_class=shape_or_register_gap
next_route=instantiate the transparent cleanup witness for the fixed-denominator modular add/sub route and separately check that the controlled rotation is workspace-readonly
```

