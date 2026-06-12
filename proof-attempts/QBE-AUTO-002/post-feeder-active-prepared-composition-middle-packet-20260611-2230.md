# Middle Packet: Post-Feeder Active/Prepared Composition Leaf

Task: `QBE-AUTO-002`

Run: `20260611-222311-QBE-AUTO-002-cycle01`

Mode: faithful paper reproduction.

## Fixed Objective

The compiled feeder
`oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_preparedSparseCleanEntry_n3`
is retired as a lower target. The next lower proof should close or strictly
reduce the unwrapped active/prepared equality

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3) =
Coeff.evalWith env
  (oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3)
```

Equivalent acceptable targets are
`oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3 H env`,
`oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`,
or `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`.

## Source Map

| Source fragment | Lean interface | Dependency class | Status |
|---|---|---|---|
| Eq. `arbitrary sparcity` | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract | contract-only |
| Eq. `ROBIN clarified`, gamma3 boundary branch | `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3 H` and backend branch declarations | GHL-internal plus QBE-local semantics | prepared side exposed |
| Fig. `1 term ROBIN` | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3 H env` | GHL-internal transcript plus QBE-local field | transcript compiled; active/prepared field open |
| Definition `def:block-encoding` | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env` | QBE-local projection bridge | dependent root open |

## Lower 1 Packet

Append only a narrow postscript to
`proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`.
State that the strict prepared-sparse feeder is proved and retired, then map
the active/prepared composition leaf to the existing declarations above.

## Lower 2 Packet

Allowed write scope: `QuantumBlockEncoding/RobinMatrix.lean` only.

Implement exactly one ready leaf:

- preferred: the unwrapped equality displayed in this packet;
- equivalent: `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3 H env`;
- equivalent: `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`;
- stronger: `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`.

Do not edit oracle contracts, theorem hypotheses, normalizers, gate labels,
the paper circuit, or the `H_W` clean-column contract. Do not reassign the
strict prepared-sparse feeder, slot vanish/support lemmas, H-free
active-selected diagnostic route, raw `Coeff` route, branch-sum wrapper, or
compiled bridge rediscovery.

Expected gate after any Lean edit:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```

Expected verifier feedback:

| Field | Value |
|---|---|
| `leaf` | `active_prepared_composition_leaf` |
| `source_correspondence_ok` | `true` only for the source-prepared route |
| `lean_parse_ok` | `true` after a parsing Lean attempt |
| `lean_build_ok` | `true` only after the gate passes |
| `finite_matrix_ok` | `partial` until the active/prepared equality closes |
| `block_entry_ok` | `open` until a named theorem closes the leaf |
| `ancilla_cleanup_ok` | `not_promoted` |
| `normalizer_ok` | `true` |
| `closed_theorem_ok` | `true` only for the exact selected leaf |
| `error_class` | `none`, `lean_tactic_gap`, `symbolic_bridge_gap`, or `source_translation_gap` |
| `next_route` | the smallest named theorem feeding the active/prepared composition field |
