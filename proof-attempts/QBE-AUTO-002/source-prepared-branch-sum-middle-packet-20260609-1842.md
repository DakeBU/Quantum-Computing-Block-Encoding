# QBE-AUTO-002 Middle Packet: Source-Prepared Branch-Sum Frontier

Created: 2026-06-09 18:42 JST

Scope: middle synchronization and lower-agent packet. This packet supersedes
`proof-attempts/QBE-AUTO-002/source-prepared-clean-entry-middle-packet-20260609-1822.md`
because the source-prepared clean-entry alias is already compiled.

## Source Fragment

| Source anchor | Fragment | Lean declaration or target | Dependency class | Status |
|---|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}$ supplies the clean sparse-register column. | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract | contract-only |
| `main.tex:1098-1109`, Theorem `1 term robin` | one-term Robin block-encoding statement. | theorem-facing source-prepared route | GHL-internal root | open |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | boundary gamma3 branch and backend coefficient fold. | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3` | GHL-internal plus QBE-local branch map | typed; summation proof open |
| `main.tex:1122-1164`, Fig. `1 term ROBIN` | full theorem-facing circuit with both `H_W` sides, explicit `U_indic^dagger`, pre-SWAP `O_DT^BS`, and post-SWAP `(O_D^BS)^dagger`. | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | transcript guard | compiled |
| `main.tex:2027-2035`, Definition `def:block-encoding` | clean block projection of the signal-zero entry. | `oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.signalBlockEntry` | QBE-local projection bridge | active leaf open |

## Definitions

Let `SignalBlockEntry` be

```lean
oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.signalBlockEntry
```

Let `BranchSum` be

```lean
oneTermRobinGamma3BoundaryBranchContributionSum
  oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

The compiled theorem
`oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3`
identifies the generic backend-expansion statement with
`SignalBlockEntry = BranchSum`.

## Lower-Agent Split

| Lower profile | Packet |
|---|---|
| lower 1 natural-language architect | Reuse `proof-attempts/QBE-AUTO-002/source-prepared-branch-sum-dag-20260609-1835-lower1.md`. Add only a narrow addendum if the proposed theorem name changes. |
| lower 2 Lean worker | Edit only `QuantumBlockEncoding/RobinMatrix.lean`. Prove exactly the branch-sum leaf below, or the equivalent `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` through the compiled equivalence. |

Preferred Lean leaf:

```lean
theorem oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_n3 :
    oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.signalBlockEntry =
      oneTermRobinGamma3BoundaryBranchContributionSum
        oneTermRobinGamma3BoundaryBackendBranchContribution_n3 := by
  -- finite projection/backend branch-sum proof
```

Equivalent recovery leaf:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

The compiled bridge to reuse is

```lean
oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3
```

## Retired Targets

Do not reassign these in the next lower packet:

| Target | Reason |
|---|---|
| `oneTermRobinGamma3BoundarySourcePreparedCleanEntryEval_eq_backendFold_n3` | already compiled alias |
| `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` as an arbitrary-`H` theorem | route interface only under `hUniform`; branch sum is the fixed remaining content |
| `oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3 env` | H-free diagnostic unless recovered through source-prepared/backend expansion |
| `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` | column-0 slot-0 diagnostic, not the source gamma3 branch |
| `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | raw `Coeff` constructor route is backlog |
| already compiled conditional bridges | rediscovery is stale work |

## Required Gate

If Lean is edited, lower 2 must run:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```

No ODBS, ODTS, `O_f`, `H_W`, `R_y`, LCU, block-projection,
normalized-equality, product-to-coefficient, circuit-unitarity,
block-correctness, or final-extraction flag may be promoted by this packet.
