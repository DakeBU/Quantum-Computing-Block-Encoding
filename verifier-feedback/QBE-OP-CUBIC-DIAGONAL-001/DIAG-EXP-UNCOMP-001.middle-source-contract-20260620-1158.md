# Middle Source Contract: DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Parent leaf: `DIAG-EXP-UNCOMP-001`

## Source Anchor

The source anchor is the user-provided operator target in
`tasks/QBE-OP-CUBIC-DIAGONAL-001.md`.  The operator is the diagonal matrix
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise.  The
normalizer is `exactNormalizer n = 1`.

No paper source, figure, or cited theorem is active.

## Lean Surface

The expanded clean-block contract already consumes the transparent arithmetic
and rotation predicates:

```lean
expandedArithmeticComputesCubicAmplitudeTransparent
expandedControlledRyUsesCubicAngleTransparent
```

For the fixed-denominator route, these are supplied by:

```lean
fixedDenomCubicArithmeticRouteTransparent
fixedDenomControlledRyRouteTransparent
```

The remaining cleanup obligation is still opaque:

```lean
expandedWorkspaceCleanUncomputed
```

The current backend `fixedDenomCubicArithmeticBackend` proves clean-input
compute behavior, but it does not record an inverse operation or a theorem that
the controlled rotation leaves arithmetic workspace unchanged.

## Diagnostic Alignment

The finite diagnostic
`DIAG-EXP-UNCOMP-001.lower-necessary-20260620-113316.*` checked an xor cleanup
skeleton.  The lower architect packet proposes modular add/sub cleanup.  The
xor result is useful generic support for clean workspace restoration, but it is
not evidence for the exact modular add/sub interface.

## Lower-Facing Contract

```text
leaf=DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001
target file=QuantumBlockEncoding/CubicStatePreparation.lean
allowed write scope=declarations and comments directly adjacent to
  expandedWorkspaceCleanUncomputed
exact Lean-facing declarations=
  structure ExpandedArithmeticCleanUncomputeWitness
      (n workspaceQubits : Nat) where
    backend : ExpandedCubicArithmeticBackend n workspaceQubits
    computes : expandedArithmeticBackendComputesCubicAmplitude backend
    computeStep :
      Fin (gridSize n) -> backend.Workspace ->
        Prod (Fin (gridSize n)) backend.Workspace
    uncomputeStep :
      Fin (gridSize n) -> backend.Workspace ->
        Prod (Fin (gridSize n)) backend.Workspace
    computeStep_matches_backend_on_clean :
      forall j,
        computeStep j backend.zeroWorkspace =
          backend.compute j backend.zeroWorkspace
    compute_preserves_index :
      forall j w, (computeStep j w).1 = j
    uncompute_preserves_index :
      forall j w, (uncomputeStep j w).1 = j
    uncompute_after_compute :
      forall j w, uncomputeStep j (computeStep j w).2 = (j, w)
  def expandedWorkspaceCleanUncomputedTransparent
      (n workspaceQubits : Nat) : Prop :=
    Nonempty (ExpandedArithmeticCleanUncomputeWitness n workspaceQubits)
```

This interface is stricter than a path-only cleanup check: it requires
`uncomputeStep` to invert `computeStep` for every workspace value, so a constant
workspace eraser is not an honest witness.

## Remaining Obligations

After this interface compiles, a later lower worker may instantiate it for the
fixed-denominator route using modular add/sub cleanup.  That instantiation
must have its own Lean proof or a matching finite diagnostic.  It still will
not prove `expandedWorkspaceCleanUncomputed`, clean-block extraction, unitarity,
`DIAG-ROOT-001`, or executable exports unless middle later selects a nontrivial
bridge or contract refactor.

## Typed Feedback Seed

```text
leaf=DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001
blocked_parent=DIAG-EXP-UNCOMP-001
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=true
finite_uncompute_interface_ok=null
finite_xor_diagnostic_reused_for_mod_add_sub=false
normalizer_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
unitarity_ok=null
clean_block_extraction_ok=null
closed_theorem_ok=false
route_certificate_ok=false
error_class=shape_or_register_gap
next_route=compile a transparent clean-uncompute witness interface adjacent to
  expandedWorkspaceCleanUncomputed; keep the opaque predicate, extraction,
  unitarity, root certificate, and exports blocked
```
