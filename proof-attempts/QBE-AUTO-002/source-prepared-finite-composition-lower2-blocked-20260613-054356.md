# 2026-06-13 Lower2 Blocked Route: Source-Prepared Finite Composition

Task: `QBE-AUTO-002`  
Run: `20260613-052836-QBE-AUTO-002-cycle01`  
Leaf: `source_prepared_finite_composition_leaf`

## Target

The active lower2 target was the source-prepared field

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
```

with accepted equivalent forms

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

## Lean Route Tried

The viable wrapper removal is already compiled:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastActivePreparedCompositeEval_n3
  H env
```

and the exact unwrapped sparse-clean form is already compiled:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3
  H env
```

After those rewrites, the remaining goal is exactly:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders
      (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3) =
Coeff.evalWith env
  (oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3)
```

Unfolding the prepared side shows the selected clean-clean entry still contains
the arbitrary clean-column factors of `H`:

```lean
H (oneTermRobinGamma3BoundarySparseSlotIndex_n3 s)
  oneTermRobinGamma3BoundarySparseCleanIndex_n3
```

and, via `oneTermRobinGamma3BoundaryHWKappaDaggerTransposeMatrix_n3`, the same
clean-column factor on the bra side.  The compiled theorem

```lean
oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_congr_cleanColumn_n3
```

confirms dependence only on these seven clean-column entries, but does not make
the arbitrary-`H` prepared entry equal to the H-free active seven-gate entry.

## Block

The only existing route from the prepared clean entry to the backend fold uses

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

through

```lean
oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3
```

and downstream recovery through

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3
```

Adding that uniform-column contract to the current arbitrary-`H` active field
would change the assigned theorem shape.  The H-free evaluated-fold and
diagnostic raw `Coeff` routes remain non-frontier routes for this leaf.

## Feedback

| Field | Value |
|---|---|
| `leaf` | `source_prepared_finite_composition_leaf` |
| `source_correspondence_ok` | `false_for_arbitrary_H_closure_without_uniform_or_independence` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `finite_matrix_ok` | `prepared_clean_entry_depends_on_seven_H_clean_column_slots` |
| `block_entry_ok` | `false` |
| `ancilla_cleanup_ok` | `not_promoted` |
| `normalizer_ok` | `unchanged` |
| `closed_theorem_ok` | `false` |
| `error_class` | `source_translation_gap` |
| `next_route` | `Middle should either restate the source-prepared active field with Uniform(H) explicit, or assign a genuine finite composition/independence theorem that proves the arbitrary-H target without using the downstream hUniform bridge.` |

No Lean source was edited in this attempt.  Baseline gate passed:
`python3 tools/qbe.py check`.
