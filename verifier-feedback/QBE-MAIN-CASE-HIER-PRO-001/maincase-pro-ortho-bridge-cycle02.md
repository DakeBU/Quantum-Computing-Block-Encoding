# Verifier Feedback: Pro Ortho Bridge Cycle 2

## Active Leaf

`MAINCASE-PRO-ORTHO-BRIDGE-001`

This diagnostic protects the bridge from proving the wrong target.  The active
leaf is supposed to promote the already compiled bijective `permMatrix`
candidates to the project-local rational row/column Gram condition.  A necessary
condition is that the two task-local $16 \times 16$ permutation matrices have
identity column Gram and identity row Gram under the same convention as
`OptimalControl.columnInner`, `OptimalControl.rowInner`, and
`OptimalControl.IsRationalOrthogonal`.

## Executable Diagnostic

Command:

```bash
python3 verifier-feedback/QBE-MAIN-CASE-HIER-PRO-001/maincase_pro_ortho_bridge_diag.py
```

Result: exit code `0`.

The diagnostic checks:

- `mainCaseProCandidateMatrix` is a bijective permutation matrix, has identity
  column and row Gram matrices, and its clean block equals `mainCaseProTarget`.
- `mainCaseProCircuitMatrix` satisfies the same finite Gram and clean-block
  checks.
- The retired all-state equality route stays rejected: the transcript image and
  `mainCaseProCandidateImage` differ exactly on dirty inputs `8`, `9`, `12`,
  and `13`.

## Proof-DAG Check

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `MAINCASE-PRO-ORTHO-BRIDGE-001` | Finite row/column Gram necessary condition for promoting bijective `permMatrix` candidates to rational orthogonality. | `mainCaseProCandidateImage_permutation_certificate`, `mainCaseProCircuitImage_permutation_certificate`, compiled block/resource leaves | lower 3 | `BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective`, `mainCaseProCandidateMatrix_isRationalOrthogonal`, `mainCaseProCircuitMatrix_isRationalOrthogonal` | this verifier-feedback packet | `python3 tools/qbe.py check` and `lake build && lake build Tests` | finite diagnostic passed; symbolic bridge now closed in Lean |

Post-closure update: lower cycle 2 closed the symbolic bridge after this
finite diagnostic.  The packet is retained as the necessary-condition record,
but it should no longer schedule proof search for
`MAINCASE-PRO-ORTHO-BRIDGE-001`.

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `MAINCASE-PRO-ORTHO-BRIDGE-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `finite_matrix_ok` | `true` |
| `block_entry_ok` | `true` |
| `ancilla_cleanup_ok` | `true` |
| `normalizer_ok` | `true` |
| `unitarity_ok` | `true` for the finite Gram diagnostic |
| `resource_score` | `(4,4,1,0)` |
| `auxiliary_qubits` | `1` |
| `gate_count` | `4` |
| `depth` | `4` |
| `oracle_calls` | `0` |
| `closed_theorem_ok` | `true` |
| `error_class` | `none` |
| `next_route` | Retire this bridge leaf and use `mainCaseProCircuitVerified` for semantic-tier/export alignment. |

## Rejection Status

No finite/path/support contradiction rejects
`MAINCASE-PRO-ORTHO-BRIDGE-001`.  The finite diagnostic did not itself prove
the theorem; closure is now supplied by the named Lean declarations above.  The
stale route `mainCaseProCircuitImage_eq_candidate` remains rejected on dirty
inputs `8`, `9`, `12`, and `13`.
