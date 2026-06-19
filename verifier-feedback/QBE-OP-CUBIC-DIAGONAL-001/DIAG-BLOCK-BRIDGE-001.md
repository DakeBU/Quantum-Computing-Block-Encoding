# Verifier Feedback: DIAG-BLOCK-BRIDGE-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Active leaf: `DIAG-BLOCK-BRIDGE-001`

Why this is necessary: the planned Lean bridge says that any block satisfying
`diagonalCleanBlockContract n block` is pointwise equal to
`(cubicDiagonalTarget n).operator`. Before spending Lean proof effort, the
finite target must agree with the user source matrix
`D_n[row,col] = if row = col then (row / 2^n)^3 else 0`, with alpha `1`, and it
must not have the stale first-column support shape from the rank-one
state-preparation task.

Diagnostic:

```bash
python3 verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/finite_diagonal_check.py \
  --json-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-BLOCK-BRIDGE-001.feedback.json
```

Finite results:

| n | grid size | diagonal entries | off diagonal zero | alpha |
|---|---:|---|---|---|
| 1 | 2 | `0, 1/8` | true | `1` |
| 2 | 4 | `0, 1/64, 1/8, 27/64` | true | `1` |
| 3 | 8 | `0, 1/512, 1/64, 27/512, 1/8, 125/512, 27/64, 343/512` | true | `1` |

The checked matrices also have nonzero support outside column zero, so the
rank-one state-preparation shape is not a valid replacement route.

Typed feedback:

```json
{
  "leaf": "DIAG-BLOCK-BRIDGE-001",
  "source_correspondence_ok": true,
  "finite_matrix_ok": true,
  "block_entry_ok": true,
  "normalizer_ok": true,
  "closed_theorem_ok": false,
  "error_class": "symbolic_bridge_gap",
  "next_route": "implement primitiveOracleCleanBlock_eq_target from diagonalCleanBlockContract_pointwise_eq and cubicDiagonalTarget"
}
```

No contradiction was found. This diagnostic does not certify a unitary or close
the Lean theorem.
