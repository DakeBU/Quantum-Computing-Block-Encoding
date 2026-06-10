# QBE-AUTO-002 Middle Packet: Evaluated Backend Fold

Created: 2026-06-09

This packet retires the previous prepared-LHS and finite active-to-prepared
targets after the latest lower guards.  The next lower worker should not repeat
source search or reassign those leaves.

## Source Contract

| Source anchor | Lean-facing contract | Dependency class | Status |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract | use as a typed obligation only |
| `main.tex:1098-1109`, Theorem `theorem: 1 term robin` | source-prepared route into one-term Robin block-encoding | GHL-internal theorem target | not closed |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | gamma3 boundary slot `2`, full basis `[32,32]` | GHL-internal branch plus QBE-local index bridge | branch map compiled |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | both `H_W` sides, explicit `U_indic^dagger`, pre-SWAP `O_DT^BS`, post-SWAP `(O_D^BS)^dagger` | GHL-internal transcript | transcript guard compiled |
| `main.tex:2027-2035`, Definition `def:block-encoding` | clean projection field selected before backend comparison | QBE-local semantic bridge | evaluated fold remains open |

## Active Leaf

Primary target:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

Allowed equivalent leaves:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement
```

The active/prepared composition target is no longer smaller:

```lean
oneTermRobinGamma3BoundaryFiniteActivePreparedComposition_reducesToBackendFold_n3 H env hUniform
```

This compiled guard shows that under `hUniform`, the uncast active/prepared
statement is equivalent to the evaluated backend fold.  A lower worker should
therefore attack the evaluated fold or an equivalent backend-expansion/raw
prepared-sandwich route, not the retired wrapper.

## Reusable Bridges

| Bridge | Role |
|---|---|
| `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3` | removes the block-extraction cast and exposes the active `[0,0]` `evalGateMatrices` entry |
| `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_activePreparedEval_n3` | identifies the evaluated fold with the source-prepared singleton field under `hUniform` |
| `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3` | connects backend expansion and the unitary-entry fold |
| `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_backendExpansion_n3` | connects the raw prepared-sandwich field to backend expansion under `hUniform` |
| `oneTermRobinGamma3BoundarySevenGateColumn0UsesSlot0_notGamma3Slot2_n3` | diagnostic guard showing the active column-`0` expansion is not the displayed gamma3 slot-`2` branch |

## Lower Packets

| Lower profile | Exact assignment |
|---|---|
| lower 1 proof architect | If needed, produce a narrow route-DAG addendum proving that the three allowed leaves above are the same active frontier under `hUniform`.  Reuse the accepted prepared-entry and finite-active packets. |
| lower 2 Lean worker | Edit only `QuantumBlockEncoding/RobinMatrix.lean`.  Prove exactly one active leaf: the evaluated fold, backend expansion, or raw prepared-sandwich field.  Run `python3 tools/qbe.py check`. |

## Forbidden Routes

- Do not use `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` as a
  proof of the displayed gamma3 slot-`2` branch.
- Do not revive `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` or
  `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` as the
  main theorem route.
- Do not promote ODBS, ODTS, `O_f`, `H_W`, `R_y`, LCU, block-projection,
  normalized-equality, product-to-coefficient, circuit-unitarity,
  block-correctness, or final-extraction flags.
