# Verifier Feedback: CUBIC-HCOUNT-IFACE-001

Task: `QBE-OP-CUBIC-STATEPREP-001`

Leaf: `CUBIC-HCOUNT-IFACE-001`

## Attempt

This lower refiner implemented the Hadamard-counting candidate interface named
by the previous `symbolic_bridge_gap` feedback:

- `CubicStatePreparation.hadamardCountingCubicLayout`
- `CubicStatePreparation.hadamardCountingCubicCircuit`
- `CubicStatePreparation.hadamardCountingCubicNormalizer`
- `CubicStatePreparation.hadamardCountingCubicResourceTuple`
- `CubicStatePreparation.hadamardCountingCubicCleanBlockContract`
- `CubicStatePreparation.hadamardCountingCubicCleanBlockContract_pointwise_eq`
- `CubicStatePreparation.cubicNormSq_le_hadamardCountingCubicNormalizer_sq`

The patch fixes the immediate route gap by giving the Hadamard-counting
mutation a compiled layout, transcript, normalizer, resource tuple, and
candidate-specific target-shape bridge.  It does not prove comparator
semantics, Hadamard-sandwich amplitudes, unitarity, or the final approximation
claim.

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
| `leaf` | `CUBIC-HCOUNT-IFACE-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `finite_matrix_ok` | `null` |
| `block_entry_ok` | `target-shape bridge compiled; concrete clean-block semantics not yet tested` |
| `ancilla_cleanup_ok` | `null` |
| `normalizer_ok` | `true` via `cubicNormSq_le_hadamardCountingCubicNormalizer_sq` |
| `unitarity_ok` | `false` |
| `resource_score` | `oracle-label tier; n=2 tuple (7, 7, 21, 7)` |
| `auxiliary_qubits` | `21` for `n = 2` |
| `gate_count` | `7` at the unexpanded-oracle tier |
| `depth` | `7` at the unexpanded-oracle tier |
| `oracle_calls` | `7` |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `Run finite n=1 or n=2 clean-block checks for the Hadamard-counting labels, or prove CUBIC-HCOUNT-RATIO-001 as the next symbolic bridge.` |
