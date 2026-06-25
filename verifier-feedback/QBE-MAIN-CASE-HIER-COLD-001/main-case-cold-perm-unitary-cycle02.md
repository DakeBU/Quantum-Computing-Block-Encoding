# Verifier Feedback: COLD Permutation/Unitarity Cycle 2

Task: `QBE-MAIN-CASE-HIER-COLD-001`

Leaf: `MAIN-PERM-UNITARY-001`

## Why This Check Is Necessary

The clean-block theorem `mainCaseColdPartialPerm_clean_eq_target` is already
closed, but the next block-encoding layer still needs a task-local proof that
`mainCaseColdPartialPermImage` is a finite permutation.  If the 16-state image
table is not bijective, the permutation-matrix route cannot supply the intended
unitary candidate.  If its clean signal block differs from the source support
`(0,6)` and `(1,7)`, then the Lean worker would be proving the wrong target.

## Executable Diagnostic

Run:

```bash
python3 verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/main-case-cold-perm-unitary-cycle02.py
```

The script parses `mainCaseColdPartialPermImage` directly from
`QuantumBlockEncoding/MainCase.lean`, then checks:

- the image table is a bijection on `Fin 16`;
- the passive `S` bit is preserved by every table entry;
- the clean block on signal `0` has exactly the support
  `{(0,6), (1,7)}`;
- the target normalizer is `1`, with one clean signal qubit and no oracle calls.

Result: the finite necessary conditions pass.  There is no finite-matrix
counterexample to `MAIN-PERM-UNITARY-001`.

The inverse table implied by the diagnostic is:

```text
0 <- 6, 1 <- 7, 2 <- 8, 3 <- 9,
4 <- 10, 5 <- 11, 6 <- 12, 7 <- 13,
8 <- 2, 9 <- 3, 10 <- 4, 11 <- 5,
12 <- 14, 13 <- 15, 14 <- 0, 15 <- 1
```

## Typed Fields

| Field | Value |
|---|---|
| `leaf` | `MAIN-PERM-UNITARY-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `finite_matrix_ok` | `true` |
| `finite_bijection_ok` | `true` |
| `block_entry_ok` | `true` |
| `ancilla_cleanup_ok` | `true` |
| `normalizer_ok` | `true` |
| `unitarity_ok` | `null` |
| `auxiliary_qubits` | `1` |
| `gate_count` | `null` |
| `depth` | `null` |
| `oracle_calls` | `0` |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |

## Next Route

Prove `mainCaseColdPartialPermImage_bijective` by finite
`native_decide`/case split over `Fin 16`, then connect that task-local
permutation certificate to the project unitary or verified-candidate layer.
Do not reopen the clean-entry proof, resource tuple, or Qiskit/QASM3 export
until this permutation/unitarity layer is closed.
