# CUBIC-HCOUNT-REJECT-REPAIR-001 Refiner Attempt

Task: `QBE-OP-CUBIC-STATEPREP-001`
Mode: exploratory construction
Updated: `2026-06-19 17:07:29 JST`

## Failed Route

Exact failed route: `CUBIC-VER-CAND-001:HCOUNT-SEMANTIC` checked the
Hadamard-counting transcript where `hcount-zero-input-flag` computes
`nz := [S != 0]` and `(hcount-zero-input-flag)^dagger` later uncomputes that
same flag with no independent rejection witness.

Rejected theorem route: do not attempt `CUBIC-HCOUNT-BLOCK-001` from the old
seven-call daggered `nz` transcript.

Error message from the finite diagnostic:

```text
n = 1: first mismatch (row=1, col=1, target=0, current=1)
n = 2: first mismatch (row=1, col=1, target=0, current=1)
finite_matrix_ok=false; block_entry_ok=false; error_class=finite_matrix_counterexample
```

Reason: every nonzero input column skips the path work, then the final dagger
clears `nz`, so the clean block leaks identity entries on columns `c != 0`.
This contradicts the rank-one support condition in `rankOneCleanBlockContract`.

## Repair Patch

Chosen repair: add a separate `hcount-nonzero-column-reject` oracle-label step
immediately after `hcount-zero-input-flag`, then keep the existing final
`(hcount-zero-input-flag)^dagger` cleanup.

This is narrower than the sticky-`nz` convention because it keeps the pure
`nz` ancilla clean while leaving the signal reject qubit set for nonzero input
columns.  The target operator, normalizer, ratio lemma, and clean-block
contract statements are unchanged.

Lean surface changed:

- `hadamardCountingCubicCircuit` now has eight oracle-label steps.
- `hadamardCountingCubicCircuit_rejectSignalRepair` pins the repaired
  transcript as a named Lean theorem.
- `hadamardCountingCubicResource_eq` now states
  `Resource.ofCountsWithDepth 0 0 8 0 8`.
- `hadamardCountingCubicResourceTuple_n2` now states `(8, 8, 21, 8)`.
- `Tests/Basic.lean` pins the repaired transcript and resource theorem.

Finite diagnostic after repair:

```text
n = 1: repaired_block_entry_ok=true; repaired_first_mismatch=none
n = 2: repaired_block_entry_ok=true; repaired_first_mismatch=none
finite_matrix_ok=true; block_entry_ok=true; ancilla_cleanup_ok=true; unitarity_ok=true
```

## Verdict

Keep the repair.  It removes the concrete finite counterexample without
changing the scientific target or adding assumptions.

Remaining route: prove a symbolic semantic bridge for the separate-reject
Hadamard-counting transcript before attempting `CUBIC-HCOUNT-BLOCK-001`.
The next narrow leaf should be either `CUBIC-HCOUNT-COUNT-001` or a named
semantic lemma that states nonzero columns set the reject signal and therefore
vanish under the clean projection.

## Typed Feedback

| Field | Value |
| --- | --- |
| `leaf` | `CUBIC-HCOUNT-REJECT-REPAIR-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` after `python3 tools/qbe.py check` |
| `finite_matrix_ok` | `true` for repaired finite `n = 1, 2` semantic check |
| `block_entry_ok` | `true` for repaired finite `n = 1, 2` clean block |
| `ancilla_cleanup_ok` | `true` for this interface diagnostic: pure `nz` is cleaned and nonzero columns are rejected by the signal qubit |
| `normalizer_ok` | `true`; unchanged via `cubicNormSq_le_hadamardCountingCubicNormalizer_sq` |
| `unitarity_ok` | `true` for finite reversible layers plus path-Hadamard orthogonality checked by the diagnostic |
| `resource_score` | `oracle-label tier; n=2 tuple is now (8, 8, 21, 8)` |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `Promote the separate-reject convention into symbolic Hadamard-counting semantics before attempting CUBIC-HCOUNT-BLOCK-001.` |
