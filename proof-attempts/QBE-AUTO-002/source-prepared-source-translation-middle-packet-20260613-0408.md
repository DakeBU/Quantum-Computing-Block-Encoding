# QBE-AUTO-002 middle packet: source-translation correction for active/prepared interface

Run: `20260613-040302-QBE-AUTO-002-cycle01`

Mode: `faithfulPaper`

## Source Audit

GHL2025 Eq. `arbitrary sparcity` defines the sparse-preparation operation
$H_W^{(\kappa)}$ by its clean-column action and cites Shukla--Vedula for an
$O(\log \kappa)$ implementation.  GHL2025 Fig. `fig:1 term ROBIN` keeps the
left and right sparse-preparation sides in the theorem-facing circuit.  The
cited result is already represented in Lean only as the contract

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

and remains contract-only.  It does not prove active/prepared equality, product
equality, LCU composition, block projection, normalized equality, circuit
unitarity, block correctness, or final extraction.

## Lean-Facing Contract

Definition first: the active interface leaf is

```lean
(oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3 H).activeEntryStatement
```

and it is equivalent to:

```lean
(oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3 H).interfaceStatement
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

The unfolded equality is:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
```

This is the current active proposition, but the source-backed route uses the
specific $H_W^{(\kappa)}$ contract.  An unconditional arbitrary-`H` proof needs
one additional finite fact: the selected prepared clean entry must be shown to
be independent of all unconstrained entries of `H`, or middle must replace the
next target by a contract-specific source statement before more broad proof
search.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Local gate | Status |
|---|---|---|---|---|---|---|
| `source_uniform_contract` | clean-column amplitudes for $H_W^{(\kappa)}$ | GHL2025 Eq. `arbitrary sparcity`; Shukla--Vedula 2024 | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | contract only | external obligation |
| `active_entry_source` | active side is the signal-zero seven-gate entry | active circuit semantics | none | `oneTermRobinGamma3BoundarySignalUnitaryEntry_evalGateMatrices_n3` | previous gate | compiled |
| `prepared_clean_unfold` | prepared clean-clean entry unfolds through the prepared sparse matrix | prepared sparse matrix definition | none | `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3 H` | previous gate | compiled |
| `active_prepared_composition_interface_leaf` | active signal-zero entry equals prepared clean-clean entry | active source; prepared clean unfold; source contract audit | lower2 | `(oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3 H).activeEntryStatement` | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active leaf; open |
| `arbitrary_H_independence_leaf` | selected prepared clean entry is independent of unconstrained entries of `H` | prepared matrix definition and sparse-clean index | lower2/refiner | planned strict finite theorem | same gate | absent |
| `contract_specific_restatement` | source-backed active/prepared target with clean-column contract explicit | source audit and cited-results row | middle | planned only if needed | documentation gate first | pending route |
| `retired_hfree_product_route` | standalone H-free seven-gate/backend selected-slot route | diagnostic `sorry` declarations | none | diagnostic declarations only | none | stale |

## Lower Packets

Lower1 should reuse Section 21.21 of
`proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`.
Do not rewrite the proof map.  If a note is needed, append only that
arbitrary-`H` closure now requires a finite independence theorem or a
contract-specific middle restatement.

Lower2 edits only `QuantumBlockEncoding/RobinMatrix.lean`.  Acceptable targets:

```lean
(oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3 H).activeEntryStatement
(oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3 H).interfaceStatement
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

or one strict finite matrix-entry theorem that directly proves one of those
statements or proves the required arbitrary-`H` independence fact.  Lower2 must
not add `hUniform` to the existing target, add a theorem hypothesis, change the
paper circuit, or create another wrapper or obstruction handle.

Lower3, if scheduled, should test only source-shaped active/prepared or
independence routes.  It should record `symbolic_bridge_gap` if the source
shape is accepted but finite algebra remains open, `source_translation_gap` if
the arbitrary-`H` target lacks a source-backed bridge, and
`shape_or_register_gap` for standalone H-free reassignment.

## Verifier Fields For The Next Attempt

| Field | Expected value if no theorem closes |
|---|---|
| `leaf` | `active_prepared_composition_interface_leaf` |
| `source_correspondence_ok` | `conditional_source_route_ok_for_H_W_contract; unconditional_arbitrary_H_requires_independence_theorem` |
| `lean_parse_ok` | `true` after any Lean edit, or `true_no_lean_edit` |
| `lean_build_ok` | result of the gate |
| `finite_matrix_ok` | state whether active/prepared equality or independence was checked |
| `block_entry_ok` | `false` unless the exact equality is proved |
| `ancilla_cleanup_ok` | `not_promoted` |
| `normalizer_ok` | `unchanged` |
| `closed_theorem_ok` | `false` unless a named theorem closes |
| `error_class` | `source_translation_gap`, `symbolic_bridge_gap`, or `shape_or_register_gap` |
| `next_route` | one finite theorem or a middle restatement, not broad search |

The first-case-study one-term theorem remains open.
