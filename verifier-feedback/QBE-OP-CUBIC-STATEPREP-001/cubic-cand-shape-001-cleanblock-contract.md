# Verifier Feedback: CUBIC-CAND-SHAPE-001 Clean-Block Contract Bridge

Task: `QBE-OP-CUBIC-STATEPREP-001`

Leaf: `CUBIC-CAND-SHAPE-001`

## Attempt

This lower attempt added a reusable Lean clean-block contract for rank-one
cubic candidates:

- `CubicStatePreparation.rankOneCleanBlockContract`
- `CubicStatePreparation.arithmeticRankOneCubicCleanBlockContract`
- `CubicStatePreparation.rankOneCleanBlockContract_pointwise_eq`
- `CubicStatePreparation.arithmeticRankOneCubicCleanBlockContract_pointwise_eq`

The contract states that a candidate clean block has scaled first column
`cubicAmplitude n row` and zero clean entries in every nonfirst input column.
The pointwise theorem proves that any block satisfying this contract scales to
`CubicStatePreparation.cubicOperator n`.

This is a target-shape bridge only.  It does not certify a unitary, a concrete
clean-block matrix, finite candidate semantics, or the final operator-norm
approximation inequality.

## Gate

```text
python3 tools/qbe.py check
lake build
lake build Tests
```

The gate passed.

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `CUBIC-CAND-SHAPE-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `finite_matrix_ok` | `null` |
| `block_entry_ok` | `contract bridge compiled; concrete candidate clean-block semantics not yet tested` |
| `ancilla_cleanup_ok` | `null` |
| `normalizer_ok` | `true` for the current conservative-normalizer route, via existing compiled bound |
| `unitarity_ok` | `false` |
| `resource_score` | wrapper tuple remains `(10, 10, 52, 10)` for default `n = 2`, precision `40`; no expanded semantic resource score |
| `auxiliary_qubits` | `52` for default `n = 2`, precision `40` in the wrapper interface |
| `gate_count` | `10` at the unexpanded-oracle wrapper tier |
| `depth` | `10` at the unexpanded-oracle wrapper tier |
| `oracle_calls` | `10` at the unexpanded-oracle wrapper tier |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `Instantiate a finite semantic clean-block matrix for the rank-one wrapper or implement CUBIC-HCOUNT-IFACE-001, then test the clean-block contract on n = 1 or n = 2 before symbolic unitary/block proof search.` |
