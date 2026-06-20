# Verifier Feedback: DIAG-PRIM-WITNESS-001 Rational One-Signal Check

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Active leaf: `DIAG-PRIM-WITNESS-001`

Why this is necessary: the active leaf asks for a proof or accepted primitive
source for `primitiveAmplitudeOracleSemanticContract n`.  The current Lean
candidate stores the primitive oracle matrix as `Matrix ... Rat` and uses one
signal qubit with no pure workspace, so a Lean worker might try to prove the
opaque primitive predicate as a standard exact rational block unitary.  Before
that proof route is attempted, the finite block shape must pass the standard
unitarity necessary condition.

Diagnostic:

```bash
python3 verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/primitive_signal_unitary_check.py \
  --json-out verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-PRIM-WITNESS-001.rat-one-signal.feedback.json
```

For a standard rational unitary with clean block $D = diag(a_j)$ and one signal
qubit, write the block matrix as

```text
U = [[D, B],
     [C, E]].
```

Column orthogonality for the clean-block columns implies
$C^T C = diag(1 - a_j^2)$.  Since one signal qubit and no pure workspace makes
`C` an `N x N` rational matrix, a necessary condition is that
$prod_j (1 - a_j^2) = det(C)^2$ is a rational square.

Finite results:

| n | grid size | clean block entries | determinant product | rational square |
|---|---:|---|---|---|
| 1 | 2 | `0, 1/8` | `63/64` | false |
| 2 | 4 | `0, 1/64, 1/8, 27/64` | `868635495/1073741824` | false |
| 3 | 8 | `0, 1/512, 1/64, 27/512, 1/8, 125/512, 27/64, 343/512` | `2120359779721693190230351176375/5070602400912917605986812821504` | false |

The diagonal target itself still passes: diagonal entries are exactly
`(j / 2^n)^3`, off-diagonal entries vanish, and normalizer `alpha = 1` is
unchanged.  The rejection is narrower: the current one-signal/no-workspace
primitive witness route cannot be proved as a standard exact rational unitary
with this clean block.

Typed feedback:

```json
{
  "leaf": "DIAG-PRIM-WITNESS-001",
  "source_correspondence_ok": true,
  "finite_matrix_ok": true,
  "block_entry_ok": true,
  "normalizer_ok": true,
  "unitarity_ok": false,
  "closed_theorem_ok": false,
  "error_class": "shape_or_register_gap",
  "next_route": "Do not ask Lean to prove primitiveAmplitudeOracleSemanticContract n as a standard Rat one-signal/no-workspace unitary; either retarget the primitive contract to an explicitly accepted Real/Complex amplitude-oracle semantics, or open the expanded arithmetic route with a source-backed unitary convention."
}
```

This diagnostic does not close or refute the opaque Lean proposition
`primitiveAmplitudeOracleSemanticContract n`.  It rejects only the exact
standard-rational one-signal/no-workspace interpretation of that proposition.
