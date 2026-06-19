# Verifier Feedback: CUBIC-HCOUNT-REJECT-REPAIR-001

Task: `QBE-OP-CUBIC-STATEPREP-001`

Leaf checked: `CUBIC-HCOUNT-REJECT-REPAIR-001`, the repair after the rejected
`CUBIC-VER-CAND-001:HCOUNT-SEMANTIC` daggered nonzero-flag diagnostic.

Executable diagnostic:
`verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic_hcount_reject_repair_check.py`

## Repair

The repaired Lean transcript adds a separate
`hcount-nonzero-column-reject` oracle label before the final
`(hcount-zero-input-flag)^dagger`.  Nonzero input columns may have `nz`
uncomputed, but the signal reject bit remains set, so the clean projection
cannot admit identity leakage from columns `c != 0`.

The compiled Lean surface is:

- `CubicStatePreparation.hadamardCountingCubicCircuit_rejectSignalRepair`
- `CubicStatePreparation.hadamardCountingCubicResource_eq`
- `CubicStatePreparation.hadamardCountingCubicResourceTuple_n2`

The oracle-label resource tuple for `n = 2` is now `(8, 8, 21, 8)`.

## Command

```bash
python3 verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic_hcount_reject_repair_check.py
```

## Diagnostic Rows

| n | N | repaired_reversible_layers_ok | path_hadamard_orthogonal_ok | repaired_missing_first_column | repaired_nonfirst_column_leaks | repaired_block_entry_ok | old_daggered_block_entry_ok | first_mismatch |
|---:|---:|---|---|---:|---:|---|---|---|
| 1 | 2 | true | true | 0 | 0 | true | false | `none` |
| 2 | 4 | true | true | 0 | 0 | true | false | `none` |

The repaired finite model clears the necessary clean-block support check for
`n = 1` and `n = 2`.  The old daggered-only route remains rejected.

## Gate

```text
python3 tools/qbe.py check
lake build
lake build Tests
```

The gate passed after the repair and focused tests.

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `CUBIC-HCOUNT-REJECT-REPAIR-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `finite_matrix_ok` | `true` |
| `block_entry_ok` | `true` for this finite necessary-condition check |
| `ancilla_cleanup_ok` | `true` for clean-block support; nonzero columns retain a reject witness |
| `normalizer_ok` | `true` for `alpha = conservativeNormalizer n` |
| `unitarity_ok` | `true` for the checked reversible labels plus path-Hadamard orthogonality |
| `resource_score` | `oracle-label tier; n=2 tuple (8, 8, 21, 8)` |
| `auxiliary_qubits` | `21` for `n = 2` |
| `gate_count` | `8` at the oracle-label tier |
| `depth` | `8` at the oracle-label tier |
| `oracle_calls` | `8` |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `Promote one symbolic bridge leaf: either CUBIC-HCOUNT-COUNT-001 for the threshold path count or CUBIC-HCOUNT-UNITARY-001 for reversible/Hadamard semantics before CUBIC-HCOUNT-BLOCK-001.` |

## Non-Promotion Rule

This finite diagnostic is not a block-encoding certificate.  The candidate
stays out of the certified population until a named Lean clean-block theorem
and the required unitarity/reversibility leaves are proved and build-tested.
