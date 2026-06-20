# DIAG-RY-WORKSPACE-READONLY-001 Middle Source Contract

Task: `QBE-OP-CUBIC-DIAGONAL-001`.

The source anchor is the user-provided diagonal operator in
`tasks/QBE-OP-CUBIC-DIAGONAL-001.md`.  The object is
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise, with
`exactNormalizer n = 1`.  No paper source, figure, or cited theorem is active.

The fixed-denominator transparent cleanup witness is closed:
`fixedDenomExpandedArithmeticCleanUncomputeWitness` and
`fixedDenomWorkspaceCleanUncomputedTransparent` compile.  This witness only
handles modular add/sub cleanup for the arithmetic workspace.  It does not
state that the controlled-`R_y` step leaves the workspace unchanged.

The next lower-facing Lean leaf is to state a transparent readonly-rotation
interface.  One acceptable Lean shape is:

```lean
structure ExpandedControlledRyWorkspaceReadonlyWitness
    (n workspaceQubits : Nat) where
  backend : ExpandedCubicArithmeticBackend n workspaceQubits
  angleConvention :
    expandedControlledRyUsesCubicAngleTransparent n workspaceQubits
  rotationStep :
    Fin (gridSize n) -> backend.Workspace -> Fin 2 ->
      Prod (Prod (Fin (gridSize n)) backend.Workspace) (Fin 2)
  preserves_index :
    forall j w signal, (rotationStep j w signal).1.1 = j
  preserves_workspace :
    forall j w signal, (rotationStep j w signal).1.2 = w

def expandedControlledRyWorkspaceReadonlyTransparent
    (n workspaceQubits : Nat) : Prop :=
  Nonempty (ExpandedControlledRyWorkspaceReadonlyWitness n workspaceQubits)
```

This packet authorizes only that interface statement.  It does not authorize a
proof of `expandedWorkspaceCleanUncomputed`, a refactor of
`expandedAmplitudeOracleCleanBlockContract`, any axiom, any semantic
proposition set to `True`, a rank-one state-preparation route, or executable
exports.

Typed feedback:

```text
leaf=DIAG-RY-WORKSPACE-READONLY-001
blocked_parent=DIAG-EXP-UNCOMP-001
source_correspondence_ok=true
finite_rotation_workspace_readonly_ok=true
lean_rotation_workspace_readonly_statement_present=false
available_cleanup_witness=fixedDenomWorkspaceCleanUncomputedTransparent
block_entry_ok=null
ancilla_cleanup_ok=null
unitarity_ok=null
clean_block_extraction_ok=null
closed_theorem_ok=false
route_certificate_ok=false
error_class=symbolic_bridge_gap
next_route=state the transparent controlled-rotation workspace-readonly
  interface; keep cleanup bridge, extraction, unitarity, root, and exports
  blocked
```
