# Cited Results: Classical Power Sums

This ledger records classical arithmetic identities that QBE uses as external
or local technical obligations.  It does not claim a paper-specific citation or
a Lean proof unless the corresponding Lean declaration is named and build-tested.

| Result id | Source | Statement used | QBE status | Lean target | Used by | Reviewer note |
|---|---|---|---|---|---|---|
| `classical-sixth-power-sum` | Classical finite power-sum identity, to be formalized locally rather than cited as a paper contribution. | For `m : Nat`, the rational sum of sixth powers satisfies `sum_{j=0}^m j^6 = m(m+1)(2m+1)(3m^4+6m^3-3m+1)/42`. | obligation | planned helper for `QuantumBlockEncoding.CubicStatePreparation.cubicNormSq_closedForm` | `QBE-OP-CUBIC-STATEPREP-001`, node CUBIC-NORM-001 | Do not mark `formalized` until `python3 tools/qbe.py check` and `lake build && lake build Tests` pass with the helper declaration. |
