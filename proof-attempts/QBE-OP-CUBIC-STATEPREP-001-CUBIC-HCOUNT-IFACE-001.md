# CUBIC-HCOUNT-IFACE-001 Refiner Repair

Task: `QBE-OP-CUBIC-STATEPREP-001`
Leaf: `CUBIC-HCOUNT-IFACE-001`
Mode: exploratory construction
Author role: lower Lean refiner/reducer
Updated: `2026-06-19 15:34:00 JST`
Status: Hadamard-counting interface compiled; semantic block proof remains open.

## Failed Theorem And Rejected Route

Rejected theorem route:

```lean
-- Rejected shape: proving the Hadamard-counting clean-block theorem before
-- the candidate has a compiled layout/transcript/resource interface.
theorem hadamardCountingCubic_cleanBlock
    (n : Nat)
    (block : Matrix (gridSize n) (gridSize n) Rat) :
    hadamardCountingCubicCleanBlockContract n block := by
  -- no semantic Hadamard-sandwich matrix, comparator semantics, or path-count
  -- lemma is available yet
  admit
```

Verifier/error message from the previous route:

```text
leaf=CUBIC-HCOUNT-001
block_entry_ok=contract bridge compiled; finite candidate semantics not yet tested
closed_theorem_ok=false
error_class=symbolic_bridge_gap
next_route=Implement CUBIC-HCOUNT-IFACE-001 as layout/circuit/resource declarations, then run n=1 or n=2 clean-block finite diagnostics before attempting the Hadamard-sandwich semantic theorem.
```

In-cycle Lean error during this repair:

```text
error: QuantumBlockEncoding/CubicStatePreparation.lean:353:2:
  Unknown identifier `rankOneCleanBlockContract`
error: QuantumBlockEncoding/CubicStatePreparation.lean:365:2:
  Unknown identifier `rankOneCleanBlockContract_pointwise_eq`
```

That error came from placing the Hadamard-counting contract bridge before the
shared rank-one contract declarations.  The repair moved the bridge below the
shared theorem instead of duplicating the contract or changing the target.

## Repair Patch

The Lean repair adds the definition-level interface for the exact
Hadamard-counting mutation:

- `hadamardCountingCubicWorkspace`
- `hadamardCountingCubicLayout`
- `hadamardCountingCubicCircuit`
- `hadamardCountingCubicResource`
- `hadamardCountingCubicNormalizer`
- `hadamardCountingCubicCost`
- `hadamardCountingCubicResourceTuple`
- `hadamardCountingCubicResource_eq`
- `hadamardCountingCubicLayout_auxiliaryQubits`
- `hadamardCountingCubicResourceTuple_n2`
- `hadamardCountingCubicCleanBlockContract`
- `hadamardCountingCubicCleanBlockContract_pointwise_eq`
- `hadamardCountingCubicClaim`

The oracle-label transcript records seven unresolved calls:

```text
hcount-zero-input-flag
hcount-path-H-on-R-T
hcount-row-xor-R-into-system
hcount-cubic-threshold-compare
(hcount-cubic-threshold-compare)^dagger
hcount-path-H-on-R-T
(hcount-zero-input-flag)^dagger
```

The default small diagnostic tuple at `n = 2` is `(7, 7, 21, 7)`.

This is not a proof of unitarity or clean-block correctness.  It is a proof
route reduction: future semantic attempts can target a named candidate
interface and reuse `rankOneCleanBlockContract_pointwise_eq` rather than
attacking a full block theorem from prose.

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `CUBIC-HCOUNT-IFACE-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `finite_matrix_ok` | `null` |
| `block_entry_ok` | `contract bridge compiled; semantic clean-block matrix not yet instantiated` |
| `ancilla_cleanup_ok` | `null; cleanup labels recorded but semantics open` |
| `normalizer_ok` | `true for conservative normalizer reuse` |
| `unitarity_ok` | `null; no semantic unitary matrix yet` |
| `resource_score` | `oracle-label tier, n=2 tuple (7, 7, 21, 7)` |
| `auxiliary_qubits` | `1 + (1 + 4*n + hadamardCountingCubicWorkspace n)` |
| `gate_count` | `7` |
| `depth` | `7` |
| `oracle_calls` | `7` |
| `closed_theorem_ok` | `true for interface/resource/contract bridge; false for block encoding` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `Keep the interface; next run a finite n=1 or n=2 clean-block diagnostic or prove CUBIC-HCOUNT-RATIO-001 before symbolic Hadamard-sandwich closure.` |

Decision: keep the repair.  Retry should target finite clean-block diagnostics
or the ratio lemma, not a full `VerifiedApproximateOperatorBlockEncoding`.

Gate: `python3 tools/qbe.py check` passed after the Lean edit, including
`lake build` and `lake build Tests`.
