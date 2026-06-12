# Middle Packet: Post-Bridge Evaluated Backend Fold Frontier

Task: `QBE-AUTO-002`

Run: `20260611-230354-QBE-AUTO-002-cycle01`

Mode: faithful paper reproduction.

## Fixed Source Contract

Use the GHL2025 source anchors by theorem, equation, and figure name:

| Source anchor | Role |
|---|---|
| Theorem `theorem: 1 term robin` | theorem-facing block-encoding target |
| Eq. `ROBIN clarified` | gamma3 clean coefficient and sparse-register summation |
| Fig. `fig:1 term ROBIN` | theorem-facing gate order, cleanup roles, and prepared $H_W^{(\kappa)}$ sides |
| Eq. `arbitrary sparcity` | $H_W^{(\kappa)}$ clean-column contract, cited to Shukla--Vedula |
| Definition `def:block-encoding` | clean signal-system block projection target |

Do not change the paper circuit, oracle contracts, theorem hypotheses,
normalizer, gate labels, or the `H_W` clean-column contract.

## Latest Compiled Bridge

Lower 2 compiled:

```lean
oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3
```

For fixed `H : Matrix 8 8 Coeff`, `env : String -> Rat`, and
`hUniform : oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`,
this theorem proves that the exact unwrapped active/prepared sparse-clean
`evalWith` equality is equivalent to:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

The bridge is compiled route wiring. It does not prove either side.

## Active Leaf

The next lower Lean worker should prove exactly one of:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

or the equivalent unwrapped equality:

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

A strictly smaller accepted target must directly feed one of these statements.
Examples include a finite matrix-entry expansion lemma for the evaluated fold
or a source-backed active/prepared composition theorem for the concrete
prepared sandwich. A smaller lemma must not revive raw constructor equality as
the main route.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Status |
|---|---|---|---|
| `post_feeder_sparse_clean_to_fold_bridge` | sparse-clean active/prepared equality is equivalent to the evaluated backend fold under `hUniform` | strict prepared-sparse feeder; prepared-side backend bridge | compiled; retired |
| `active_prepared_composition_leaf` | active seven-gate `[0,0]` evaluated entry equals the prepared sparse clean-clean entry | source-prepared circuit semantics; clean-column contract for recovery | active; not proved |
| `evaluated_backend_fold_leaf` | evaluated signal-zero entry equals the backend branch fold | finite projection/backend expansion | active equivalent leaf; not proved |
| `source_prepared_entry_leaf` | theorem-facing source-prepared projection active field | active/prepared leaf; source projection wrappers | open dependent |
| `unitary_fold_leaf` | raw full signal-zero unitary fold | evaluated fold or backend expansion bridge | open dependent root |

## Lower Split

Lower 1 may append only a narrow Section 21.16 postscript to
`proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`.
It should reference the compiled bridge above, retire the bridge as a target,
and state whether the next proof attempt is the evaluated fold or the
unwrapped sparse-clean equality.

Lower 2 edits only `QuantumBlockEncoding/RobinMatrix.lean`. It should prove
one active leaf or one smaller direct feeder, then run:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```

## Retired Targets

Do not assign the strict prepared-sparse feeder, finite active/prepared
reduction guard, H-free active-selected diagnostics, backend slot
vanish/support feeders, raw `Coeff` constructor equalities, branch-sum
wrappers, or compiled bridge rediscovery.

No external primitive is formalized by this packet. The first-case-study
one-term theorem remains open.
