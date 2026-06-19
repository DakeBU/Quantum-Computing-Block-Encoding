# Proof Obligations: QBE-OP-CUBIC-STATEPREP-001

## Target Obligations

| Obligation | Lean declaration or artifact | Status |
|---|---|---|
| Define grid point `x_j = j / 2^n` | `CubicStatePreparation.gridPoint` | compiled |
| Define cubic amplitude `x_j^3` | `CubicStatePreparation.cubicAmplitude` | compiled |
| Define rank-one operator `O_n = |v><0^n|` | `CubicStatePreparation.cubicOperator` | compiled |
| Record user tolerance `epsilon = 1e-10` | `CubicStatePreparation.requestedEpsilon` | compiled |
| Record adaptive Scenario 2 policy | `CubicStatePreparation.defaultPolicy` | compiled |
| Retire small norm diagnostics for `n = 1, 2, 3` | `CubicStatePreparation.cubicNormSq_n1`, `CubicStatePreparation.cubicNormSq_n2`, `CubicStatePreparation.cubicNormSq_n3` | compiled, retired |
| Prove closed form for `sum_j (j/2^n)^6` | planned `CubicStatePreparation.cubicNormSq_closedForm`; DAG node CUBIC-NORM-001 | active leaf |
| Prove placeholder normalizer is sufficient | planned `CubicStatePreparation.cubicNormSq_le_conservativeNormalizer_sq`; DAG node CUBIC-ALPHA-001 | blocked on norm bridge |
| Choose sharper normalizer `alpha` for final candidate, if useful | planned candidate-specific declaration | open |
| State block projector and clean-ancilla convention for first candidate | planned candidate contract | open |
| Decompose approximation error budget for arithmetic and rotation/transduction | `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-ERR-001.md`; Lean theorem later | designed, Lean open |

## Candidate Obligations

| Obligation | Status |
|---|---|
| Candidate unitary family `U_n` | open |
| Gate/circuit transcript for `U_n` | open |
| Block-entry theorem for `O_n` | open |
| Approximation theorem with `epsilon <= 1e-10` or explicit relaxation | open |
| Unitarity theorem for `U_n` | open |
| Resource score `(gateCount, depth, auxiliaryQubits, oracleCalls)` | open |
| Qiskit/QASM/QuantumKatas export after Lean closure | open |

## Proof-DAG Active Frontier

| Node | Interface | Dependencies | Owner | Lean declaration or artifact | Status |
|---|---|---|---|---|---|
| CUBIC-TGT-001 | Rank-one target entries for `O_n`. | none | middle/Lean target | `cubicOperator`, `cubicOperator_only_first_column` | compiled |
| CUBIC-DIAG-001 | Small exact norm diagnostics. | CUBIC-TGT-001 | historical lower | `cubicNormSq_n1`, `cubicNormSq_n2`, `cubicNormSq_n3` | compiled, retired |
| CUBIC-NORM-001 | Closed rational formula for `cubicNormSq n`. | CUBIC-TGT-001, `classical-sixth-power-sum` | lower Lean | planned `cubicNormSq_closedForm` | active leaf |
| CUBIC-ALPHA-001 | Relate normalizer to target norm. | CUBIC-NORM-001 or entrywise norm bound | lower Lean | planned `cubicNormSq_le_conservativeNormalizer_sq` | blocked internal |
| CUBIC-ERR-001 | Scenario 2 arithmetic/rotation error budget. | CUBIC-ALPHA-001 | lower architect | `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-ERR-001.md` | designed, blocked on alpha/candidate interface |
| CUBIC-VER-001 | Dense-vs-symbolic verifier scaling for `n = 4, 8, 12, 16, 20`. | CUBIC-TGT-001 | verifier lower | `verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic-ver-001-scaling.md` | diagnostic complete, not a certificate |

## Necessary-Condition Diagnostics

Diagnostics may reject candidates but cannot prove the final family theorem.

| Diagnostic | Role |
|---|---|
| vector norm check | catches accidental "unnormalized vector is a state" mistakes |
| small `n` statevector/unitary check | smoke test for candidate circuit instances |
| dense verifier scaling forecast | shows when statevector/unitary materialization stops being useful |
| exact amplitude synthesis audit | decides when to switch from exact search to Scenario 2 |

Completed diagnostic:

- `CUBIC-VER-001` records dense vector entries and one-auxiliary dense-unitary
  memory for `n = 4, 8, 12, 16, 20` in
  `verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic-ver-001-scaling.md`.
  The result keeps dense verification as a smoke-test baseline and leaves
  `CUBIC-NORM-001` as the active Lean proof leaf.
