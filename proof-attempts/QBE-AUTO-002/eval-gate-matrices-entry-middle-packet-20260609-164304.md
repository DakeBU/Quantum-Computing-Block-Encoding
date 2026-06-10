# QBE-AUTO-002 Middle Packet: Uncast EvalGateMatrices Entry Leaf

Created: 2026-06-09 16:43 JST

This packet consumes the lower-1 route addendum
`proof-attempts/QBE-AUTO-002/evaluated-backend-fold-route-dag-20260609-lower1.md`
and the lower-2 raw-field route bridge
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_rawEntryPreparedSandwichField_n3`.
It does not change the scientific target.

## Source Contract

| Source anchor | Lean-facing contract | Dependency class | Status |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract | use as typed contract only |
| `main.tex:1098-1109`, Theorem `theorem: 1 term robin` | one-term Robin block-encoding root | GHL-internal theorem target | not closed |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | gamma3 boundary slot `2`, full basis `[32,32]` | GHL-internal branch plus QBE-local index bridge | branch map compiled |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | both `H_W` sides, explicit `U_indic^dagger`, pre-SWAP `O_DT^BS`, post-SWAP `(O_D^BS)^dagger` | GHL-internal transcript | transcript guard compiled |
| `main.tex:2027-2035`, Definition `def:block-encoding` | clean projection entry semantics | QBE-local semantic bridge | current leaf is finite evaluated entry equality |

## Active Leaf

Primary target for lower 2:

```lean
theorem oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3
    (env : String -> Rat) :
    Coeff.evalWith env
      ((evalGateMatrices
        (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
        oneTermRobinGamma3BoundaryPrefixRow0_n3
        oneTermRobinGamma3BoundaryPrefixRow0_n3) =
    Coeff.evalWith env
      (blockExtractionBranchContributionSum
        oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

This theorem feeds the named target by
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env`.
It is preferred because it removes the block-entry record and dimension cast
from `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`.

## Reusable Declarations

| Declaration | Role |
|---|---|
| `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env` | rewrites the named evaluated fold to the uncast `evalGateMatrices` entry |
| `oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3` | expands the backend branch fold without raw full-product unfolding |
| `Matrix.evalWith_mul_unique_path` | isolates a single finite support path in an evaluated matrix product |
| `Matrix.evalWith_mul_two_path` | isolates a two-path evaluated matrix product when a slot splits |
| `oneTermRobinGamma3BoundarySevenGateColumn0UsesSlot0_notGamma3Slot2_n3` | diagnostic guard; prevents using the old column-`0` slot-`0` calculation as gamma3 slot `2` source closure |

## Allowed Stronger Leaves

Lower 2 may instead prove one stronger raw leaf only if it immediately adds a
one-way bridge to the evaluated fold:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement
```

The raw prepared-sandwich field and backend expansion are stronger than a
single fixed-environment evaluated equality.  Do not assume the reverse
direction without an all-environments or evaluation-injectivity theorem.

## Forbidden Routes

- Do not use `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` as a
  proof of the displayed gamma3 slot-`2` branch.
- Do not revive `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` or
  `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` as the
  main theorem route.
- Do not promote ODBS, ODTS, `O_f`, `H_W`, `R_y`, LCU, block-projection,
  normalized-equality, product-to-coefficient, circuit-unitarity,
  block-correctness, or final-extraction flags.

## Gate

After any Lean edit, lower 2 must run:

```bash
python3 tools/qbe.py check
lake build && lake build Tests
```
