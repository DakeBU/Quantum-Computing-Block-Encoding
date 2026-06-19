# CUBIC-CAND-SHAPE-001 Refiner Repair

Task: `QBE-OP-CUBIC-STATEPREP-001`
Leaf: `CUBIC-CAND-SHAPE-001`
Mode: exploratory construction
Author role: lower Lean refiner/reducer
Updated: `2026-06-19 15:20:00 JST`
Status: arithmetic rank-one wrapper interface compiled and gate-checked;
semantic block proof still open.

## Failed Theorem And Rejected Route

Rejected theorem route:

```lean
-- Rejected shape: proving a rank-one clean-block theorem directly from
-- `arithmeticCubicCircuit`.
theorem arithmeticCubic_cleanBlock_rankOne
    (n precision : Nat) :
    -- intended block entry of the clean projection equals
    -- cubicOperator n / arithmeticCubicNormalizer n
    True := by
  trivial
```

Verifier/error message:

```text
leaf=CUBIC-CAND-001
block_entry_ok=false
closed_theorem_ok=false
error_class=shape_or_register_gap
next_route=Repair CUBIC-CAND-001 by adding zero-input filtering and row-generation wrapper declarations, then refresh CUBIC-VER-CAND-001 on n = 1 or n = 2 before attempting a symbolic clean-block theorem.
```

The rejected route treats the seven-call `arithmeticCubicCircuit` as the full
candidate unitary.  That transcript only computes and transduces a cubic
amplitude for a row value already present in the system register, so it is
compatible with a diagonal value-oracle shape.  It does not by itself realize
the rank-one first-column target `O_n = |v_n><0^n|`.

## Repair Patch

The Lean repair adds the arithmetic rank-one wrapper interface without
changing the operator target:

- `arithmeticRankOneCubicLayout`
- `arithmeticRankOneCubicCircuit`
- `arithmeticRankOneCubicResource`
- `arithmeticRankOneCubicNormalizer`
- `arithmeticRankOneCubicCost`
- `arithmeticRankOneCubicResourceTuple`
- `arithmeticRankOneCubicResource_eq`
- `arithmeticRankOneCubicLayout_auxiliaryQubits`
- `arithmeticRankOneCubicResourceTuple_n2_default`
- `arithmeticRankOneCubicClaim`

The wrapper adds three oracle-level calls around the arithmetic middle block:

```text
rank-one-zero-input-clean-filter
rank-one-row-generation-on-zero-input
arithmeticCubicCircuit
rank-one-zero-input-filter-cleanup
```

The row-generation call is intentionally not uncomputed, because the generated
row is the output system register for the rank-one operator.  The compiled
resource tuple for the default small diagnostic `n = 2`, `precision = 40` is
`(10, 10, 52, 10)`.

This is not a theorem of unitarity or block correctness.  It is a proof-route
reduction: future clean-block attempts should target the wrapped transcript or
another explicitly rank-one route, not the arithmetic middle block alone.

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `CUBIC-CAND-SHAPE-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `finite_matrix_ok` | `null` |
| `block_entry_ok` | `false; semantic clean-block theorem not attempted` |
| `ancilla_cleanup_ok` | `null; cleanup label recorded but semantics open` |
| `normalizer_ok` | `true for conservative alpha bridge; wrapped route reuses it` |
| `unitarity_ok` | `null; no semantic unitary matrix yet` |
| `resource_score` | `oracle-label tier, default n=2 p=40 tuple (10, 10, 52, 10)` |
| `auxiliary_qubits` | `1 + ((arithmeticCubicLayout n precision).pureAncillas + n + 1)` |
| `gate_count` | `10` |
| `depth` | `10` |
| `oracle_calls` | `10` |
| `closed_theorem_ok` | `true for wrapper resource lemmas; false for block encoding` |
| `error_class` | `shape_or_register_gap` |
| `next_route` | `Keep the wrapper interface.  Next instantiate a small semantic matrix or finite verifier for n = 1 or n = 2 before attempting symbolic clean-block or unitarity proofs.` |

Decision: keep the repair as the next arithmetic wrapper interface.  Reject
direct block-entry proofs over `arithmeticCubicCircuit` unless they explicitly
state a diagonal value-oracle target rather than the task's rank-one operator.

Gate: `python3 tools/qbe.py check` passed after the Lean edit, including
`lake build` and `lake build Tests`.
