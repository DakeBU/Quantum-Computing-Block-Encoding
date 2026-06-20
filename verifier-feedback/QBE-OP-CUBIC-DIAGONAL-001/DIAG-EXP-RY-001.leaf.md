# Verifier Feedback: DIAG-EXP-RY-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Leaf: `DIAG-EXP-RY-001`

## Necessary-Condition Check

The active leaf is the scalar rotation convention for the expanded arithmetic
route.  It is a necessary condition because the later clean-block extraction
can equal the diagonal target only if the selected signal rotation has clean
entry

```text
cos(theta_j / 2) = (j / 2^n)^3
```

for `theta_j = 2 arccos((j / 2^n)^3)`.  If this scalar convention failed, the
expanded route could not supply `expandedControlledRyUsesCubicAngle` without
changing the target operator.

## Executable Diagnostic

Command:

```bash
python3 verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/diag_exp_ry_leaf_check.py --json-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-EXP-RY-001.leaf.feedback.json
```

The diagnostic reuses the finite expanded-route model in
`expanded_controlled_ry_check.py` but records typed feedback for the active
leaf rather than the retired interface leaf.

Checked instances: `n = 1, 2, 3, 4`.

Result:

- source correspondence: diagonal operator with entries `(j / 2^n)^3` and
  alpha `1`
- scalar clean entry: passed
- finite matrix and block entry: passed
- off-diagonal vanish: passed
- normalizer: passed
- rotation/full-route unitarity in the finite skeleton: passed
- clean workspace in the abstract compute/uncompute skeleton: passed

No finite/path/support contradiction was found.  This does not prove
`CubicDiagonalOracle.expandedControlledRyUsesCubicAngle`, and it does not close
the expanded route certificate.

## Typed Feedback

```text
leaf=DIAG-EXP-RY-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
block_entry_ok=true
ancilla_cleanup_ok=true
normalizer_ok=true
unitarity_ok=true
theta_convention_ok=true
scalar_clean_entry_ok=true
closed_theorem_ok=false
error_class=symbolic_bridge_gap
next_route=Prove the scalar clean-entry lemma cos((2 * arccos a) / 2) = a for 0 <= a <= 1, then connect it to expandedControlledRyUsesCubicAngle while keeping arithmetic and clean-uncompute leaves separate.
```
