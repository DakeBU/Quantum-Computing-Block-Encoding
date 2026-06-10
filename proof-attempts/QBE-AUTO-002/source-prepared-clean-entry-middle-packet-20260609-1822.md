# QBE-AUTO-002 Middle Packet: Source-Prepared Clean-Entry Frontier

Created: 2026-06-09 18:22 JST

Scope: lower packet and proof-DAG memory.  This packet assigns one local Lean
leaf and records which older routes are retired.

## Source Fragment

| Source anchor | Fragment | Lean contract | Dependency class | Status |
|---|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}$ prepares the uniform sparse-register column | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract | typed contract only |
| `main.tex:1098-1109`, Theorem `1 term robin` | one-term Robin block-encoding claim | route through prepared clean entry and final projection map | GHL-internal root | open |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | boundary $\gamma_3$ coefficient and backend branch fold | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3` | GHL-internal plus QBE-local branch map | compiled branch data |
| `main.tex:1122-1164`, Fig. `1 term ROBIN` | full theorem-facing circuit with both `H_W` sides and explicit `U_indic^dagger` | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` | GHL-internal transcript | compiled guard |
| `main.tex:2027-2035`, Definition `def:block-encoding` | clean projection entry | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env` | QBE-local semantic bridge | active field open |

## Definitions

Fix `H : Matrix 8 8 Coeff`, `env : String -> Rat`, and

```lean
hUniform :
  oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

Let `clean` be `oneTermRobinGamma3BoundarySparseCleanIndex_n3`.  Let
`PreparedCleanEntry(H)` be

```lean
(oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix
  clean clean
```

and let `BackendFold` be

```lean
blockExtractionBranchContributionSum
  oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

The compiled theorem
`oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`
proves that `Coeff.evalWith env PreparedCleanEntry(H)` equals
`Coeff.evalWith env BackendFold` under `hUniform`.

## Assigned Leaf

Lower 2 should choose exactly one of the following.

| Priority | Lean target | Why |
|---|---|---|
| safe alias | `oneTermRobinGamma3BoundarySourcePreparedCleanEntryEval_eq_backendFold_n3` | gives the theorem-facing prepared clean-entry route a stable name by reusing the compiled bridge |
| active math | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | proves the finite matrix-entry equality that the route still lacks |
| smaller active math | a lemma directly feeding the generic prepared-entry equality | acceptable only if the statement is named and its bridge to the generic entry is recorded |

Suggested safe alias statement:

```lean
theorem oneTermRobinGamma3BoundarySourcePreparedCleanEntryEval_eq_backendFold_n3
    (H : Matrix 8 8 Coeff) (env : String -> Rat)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    Coeff.evalWith env
      ((oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix
        oneTermRobinGamma3BoundarySparseCleanIndex_n3
        oneTermRobinGamma3BoundarySparseCleanIndex_n3)
      =
    Coeff.evalWith env
      (blockExtractionBranchContributionSum
        oneTermRobinGamma3BoundaryBackendBranchContribution_n3) :=
  oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3
    H env hUniform
```

## Compiled Route To Reuse

The latest lower2 theorem

```lean
oneTermRobinGamma3BoundaryBackendExpansionStatement_of_activePreparedEntryTarget_n3
```

has the route

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
  -> oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

under `hUniform`.  It does not prove the generic prepared-entry equality or
backend expansion.

## Retired Targets

Do not assign these as lower targets in the next packet:

| Target | Reason |
|---|---|
| `oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3 env` | H-free route is diagnostic unless every weighted backend slot is matched or eliminated |
| `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` | column-0 slot-0 diagnostic cannot replace the source gamma3 slot-2 prepared route |
| `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` | raw `Coeff` constructor equality is backlog |
| `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | raw product equality is backlog |
| `oneTermRobinGamma3BoundaryFiniteActivePreparedComposition_reducesToBackendFold_n3` | compiled guard only; retired as a lower target |
| `oneTermRobinGamma3BoundaryEvaluatedBackendFold_of_backendExpansion_n3` | compiled conditional; rediscovery is not progress |

## Required Gate

If lower 2 edits Lean, run:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```

No ODBS, ODTS, `O_f`, `H_W`, `R_y`, LCU, block-projection,
normalized-equality, product-to-coefficient, circuit-unitarity,
block-correctness, or final-extraction flag may be promoted by this packet.
