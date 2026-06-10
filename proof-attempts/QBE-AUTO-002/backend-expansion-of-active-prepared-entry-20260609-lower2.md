# QBE-AUTO-002 Lower2 Attempt: Backend Expansion From Active/Prepared Entry

Created: 2026-06-09 18:15 JST

## Closed Lean Leaf

`QuantumBlockEncoding/RobinMatrix.lean` now contains:

```lean
oneTermRobinGamma3BoundaryBackendExpansionStatement_of_activePreparedEntryTarget_n3
```

The theorem proves the direct bridge:

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
  -> oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

under the existing clean-column contract
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.

Dependencies used:

| Dependency | Role |
|---|---|
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_backendExpansion_n3 H hUniform` | existing equivalence between the generic prepared-entry leaf and the preferred backend-expansion leaf |

## Remaining Goal

This does not prove the generic prepared-entry equality and does not prove
`backendExpansionStatement` unconditionally.  The remaining active mathematical
leaf is still the QBE-local finite projection/backend theorem equating the
signal-zero entry with the seven-slot branch fold.

No oracle, `H_W`, `R_y`, LCU, block-projection, normalized-equality,
product-to-coefficient, circuit-unitarity, block-correctness,
final-extraction, ODBS, ODTS, or `O_f` flag was promoted.

## Gate

Gates passed:

```bash
lake env lean QuantumBlockEncoding/RobinMatrix.lean
python3 tools/qbe.py check
lake build && lake build Tests
```

Known diagnostic sorries remain in `RobinMatrix.lean`; no new `sorry` was
introduced.
