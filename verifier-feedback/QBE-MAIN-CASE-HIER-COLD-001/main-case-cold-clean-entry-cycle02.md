# Verifier Feedback: COLD Clean-Entry Cycle 2

Task: `QBE-MAIN-CASE-HIER-COLD-001`

Leaf: `MAIN-CLEAN-ENTRY-001`

## Result

The Lean declarations for the no-Pro COLD source surface and clean-entry
certificate now compile in `QuantumBlockEncoding/MainCase.lean`.

Closed theorem:

```lean
theorem mainCaseColdPartialPerm_clean_eq_target :
    Matrix.PointwiseEq
      (BlockEncodingClassics.ExactCleanBlock.clean
        mainCaseColdPartialPermExactCleanBlock)
      mainCaseColdTarget
```

The theorem proves that the clean signal block of the COLD partial-permutation
candidate equals
$E_1 = |0><1|_T \otimes |0><1|_\tau \otimes I_S$ for the concrete
`r = 1`, `k = 1`, one-passive-qubit benchmark.

## Typed Fields

| Field | Value |
|---|---|
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `finite_matrix_ok` | `true` |
| `block_entry_ok` | `true` |
| `ancilla_cleanup_ok` | `true` |
| `normalizer_ok` | `true` |
| `unitarity_ok` | `null` |
| `auxiliary_qubits` | `1` |
| `gate_count` | `null` |
| `depth` | `null` |
| `oracle_calls` | `0` |
| `closed_theorem_ok` | `true` |
| `error_class` | `none` |

## Remaining Boundary

This packet certifies the exact clean-block equality layer only.  It does not
prove that `mainCaseColdPartialPermImage` is a bijection, does not connect the
permutation matrix to a full unitarity predicate, and does not certify the
resource tuple used for candidate ranking or executable export.

Next route: prove `MAIN-PERM-UNITARY-001` with a task-local
`mainCaseColdPartialPermImage_bijective` theorem, then schedule
`MAIN-RESOURCE-001`.
