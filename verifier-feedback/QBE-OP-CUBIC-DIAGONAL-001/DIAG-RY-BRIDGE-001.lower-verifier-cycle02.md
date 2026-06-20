# Verifier Feedback: DIAG-RY-BRIDGE-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Leaf: `DIAG-RY-BRIDGE-001`

## Necessary-Condition Check

The active leaf is the backend bridge from the compiled scalar-tier statement
`expandedRyCleanEntryForCubicAmplitudes_of_standardTier` to the route predicate
`expandedControlledRyUsesCubicAngle`.

The finite rotation/block-entry diagnostic is necessary for this leaf because
the bridge may only be valid if the backend convention still implements

```text
theta_j = 2 arccos((j / 2^n)^3)
clean entry = cos(theta_j / 2) = (j / 2^n)^3
```

and if the resulting clean block is diagonal with off-diagonal entries zero and
normalizer `alpha = 1`.  A failure here would reject the bridge route before a
Lean worker spends effort on the opaque backend predicate.

## Executable Diagnostic

Command run:

```bash
python3 verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/diag_exp_ry_leaf_check.py
```

Checked instances: `n = 1, 2, 3, 4`.

Result:

- source correspondence: diagonal target `D_n[row,col]`, not rank-one state preparation
- finite matrix and block entry: passed
- off-diagonal vanish: passed
- standard `R_y` half-angle convention: passed
- normalizer `alpha = 1`: passed
- finite rotation/full-route unitarity skeleton: passed

No finite/path/support contradiction was found.  This does not prove
`CubicDiagonalOracle.expandedControlledRyUsesCubicAngle`, does not close the
expanded route certificate, and does not authorize executable exports.

## Typed Feedback

```text
leaf=DIAG-RY-BRIDGE-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
block_entry_ok=true
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=true
theta_convention_ok=true
closed_scalar_tier_theorem_ok=true
closed_theorem_ok=false
route_predicate_closed=false
error_class=symbolic_bridge_gap
next_route=Supply a transparent backend bridge from expandedRyCleanEntryForCubicAmplitudes_of_standardTier to expandedControlledRyUsesCubicAngle, or record expandedControlledRyUsesCubicAngle as an explicit backend obligation and move to DIAG-EXP-ARITH-001.
```
