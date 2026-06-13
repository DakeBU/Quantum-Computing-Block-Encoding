# QBE-AUTO-002 middle packet: evaluated backend fold current-run frontier

Run: `20260613-042537-QBE-AUTO-002-cycle01`

Mode: `faithfulPaper`

## Source Audit

The local source audit uses these stable GHL2025 anchors:

| Source anchor | Role in this packet |
|---|---|
| Eq. `arbitrary sparcity` | defines the clean-column action of $H_W^{(\kappa)}$ and cites Shukla--Vedula 2024 for preparation cost |
| Theorem `theorem: 1 term robin` | theorem-facing first-case-study block-encoding target |
| Eq. `ROBIN clarified` | boundary `gamma_3` coefficient fold that the finite backend branch contribution represents |
| Fig. `fig:1 term ROBIN` | theorem-facing register and gate transcript; the active seven-gate list is only the backend component |
| Definition `def:block-encoding` | clean signal block entry compared with the target operator |

The source-backed sparse-preparation fact is already represented only as the
contract

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

and remains contract-only.  This packet does not formalize Shukla--Vedula,
LCU, oracle unitarity, block projection, final extraction, or the theorem
normalizer.

## Definitions

For `env : String -> Rat`, define `ActiveEval(env)` as

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

Define `BackendFold(env)` as

```lean
Coeff.evalWith env
  (blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

Define `EvaluatedBackendFold(env)` as

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

By
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3
env`, `EvaluatedBackendFold(env)` is equivalent to
`ActiveEval(env) = BackendFold(env)`.

## Active Lean Contract

Lower2 should prove exactly:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

or one strict finite `Coeff.evalWith` product/projection theorem that feeds it
through the compiled uncast bridge above.

The exact active/prepared sparse-clean equality remains an allowed equivalent
route only under the existing clean-column contract:

```lean
oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3
  H env hUniform
```

This bridge is route wiring and is retired as a lower target.  Lower2 must not
add `hUniform` as a new hypothesis to an arbitrary-`H` theorem and must not
change the paper circuit.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Status | Next active leaf |
|---|---|---|---|---|---|---|
| `source_uniform_contract` | clean-column amplitudes for $H_W^{(\kappa)}$ | Eq. `arbitrary sparcity`; Shukla--Vedula cited row | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | contract-only | do not prove here |
| `evaluated_backend_fold_leaf` | `ActiveEval(env) = BackendFold(env)` | uncast active-entry bridge; backend branch contribution fold; source transcript guard | lower2 | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` | active leaf; open | prove this or a strict finite feeder |
| `active_prepared_sparse_clean_equivalent` | active evaluated entry equals prepared sparse clean-clean entry | sparse-clean-to-fold bridge and `Uniform(H)` | lower2 only if selected | left side of `oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3 H env hUniform` | alternate route; open | keep `hUniform` explicit through middle |
| `clean_column_congruence_support` | prepared clean entry ignores entries outside sparse clean-column slots | prepared clean-entry expansion | none | `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_congr_cleanColumn_n3` | compiled support | reuse only |
| `retired_diagnostics` | raw fold, raw constructor equality, selected-slot H-free bridge, backend slot support/vanish, feeder equivalences | stale or diagnostic support | none | diagnostic names near the end of `QuantumBlockEncoding/RobinMatrix.lean` | retired | do not assign |

## Ordered Lean Lemmas To Reuse

1. Use
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3
   env` to reduce the root to `ActiveEval(env) = BackendFold(env)`.
2. Reuse the backend fold definitions and compiled branch-support feeders only
   as simplification support.  Do not reassign backend slot vanish/support work.
3. If using the source-prepared route, reuse
   `oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3
   H env hUniform`; keep `hUniform` explicit and do not alter the target.
4. Use
   `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_congr_cleanColumn_n3`
   only as partial source-shape support.  It does not close the evaluated fold.
5. Do not use the `sorry` declarations
   `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` or
   `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` as
   theorem closure.

## Lower Packets

Lower1 may append only a narrow postscript to
`proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`
that names `evaluated_backend_fold_leaf` as active and retires arbitrary-`H`
direct active/prepared closure as the default target.

Lower2 edits only `QuantumBlockEncoding/RobinMatrix.lean`.  The accepted
output is a named theorem closing the evaluated fold or one strict feeder that
directly supplies it.  The required gate is:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```

Lower3 should record finite `n = 3` evaluated product/projection diagnostics.
Use `symbolic_bridge_gap` if the target is coherent but unproved,
`shape_or_register_gap` if the route falls back to a stale H-free selected-slot
target, and `source_translation_gap` if the route needs a new source-backed
contract restatement.

## Feedback Seed

| Field | Value |
|---|---|
| `leaf` | `evaluated_backend_fold_leaf` |
| `source_correspondence_ok` | `true_for_evaluated_backend_fold_under_GHL2025_ROBIN_clarified_and_block_encoding_definition; sparse_clean_route_requires_existing_hUniform_contract` |
| `lean_parse_ok` | `true_markdown_only_no_lean_edit` |
| `lean_build_ok` | `pending_current_middle_gate` |
| `finite_matrix_ok` | `partial_route_wiring_compiled; evaluated product/projection theorem still open` |
| `block_entry_ok` | `false` |
| `ancilla_cleanup_ok` | `not_promoted` |
| `normalizer_ok` | `unchanged` |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `prove oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env or a strict finite Coeff.evalWith product/projection lemma feeding it` |

The first-case-study one-term theorem remains open.
