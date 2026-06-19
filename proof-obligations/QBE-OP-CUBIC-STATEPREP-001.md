# Proof Obligations: QBE-OP-CUBIC-STATEPREP-001

## Target Obligations

| Obligation | Lean declaration or artifact | Status |
|---|---|---|
| Define grid point `x_j = j / 2^n` | `CubicStatePreparation.gridPoint` | compiled |
| Define cubic amplitude `x_j^3` | `CubicStatePreparation.cubicAmplitude` | compiled |
| Define rank-one operator `O_n = |v><0^n|` | `CubicStatePreparation.cubicOperator`, `CubicStatePreparation.gridSize_pos`, `CubicStatePreparation.cubicOperator_first_column`, `CubicStatePreparation.cubicOperator_only_first_column` | compiled |
| Record user tolerance `epsilon = 1e-10` | `CubicStatePreparation.requestedEpsilon` | compiled |
| Record adaptive Scenario 2 policy | `CubicStatePreparation.defaultPolicy` | compiled |
| Retire small norm diagnostics for `n = 1, 2, 3` | `CubicStatePreparation.cubicNormSq_n1`, `CubicStatePreparation.cubicNormSq_n2`, `CubicStatePreparation.cubicNormSq_n3` | compiled, retired |
| Normalize the norm summand from `(x^3)^2` to `x^6` | `CubicStatePreparation.rat_cube_sq_eq_sixth`, `CubicStatePreparation.cubicAmplitude_sq_eq_gridPoint_sixth`, `CubicStatePreparation.cubicNormSq_sixthPowerFold`; DAG node CUBIC-NORM-001A | compiled |
| Prove closed form for `sum_j (j/2^n)^6` | planned `CubicStatePreparation.cubicNormSq_closedForm`; DAG node CUBIC-NORM-001; proof design in `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-NORM-001.md` | proof design recorded; active Lean leaf |
| Prove placeholder normalizer is sufficient | `CubicStatePreparation.cubicNormSq_le_conservativeNormalizer_sq`; DAG node CUBIC-ALPHA-001 | compiled via direct entrywise bound |
| Choose sharper normalizer `alpha` for final candidate, if useful | planned candidate-specific declaration | open |
| State block projector and clean-ancilla convention for first candidate | `CubicStatePreparation.rankOneCleanBlockContract`, `CubicStatePreparation.arithmeticRankOneCubicCleanBlockContract`, `CubicStatePreparation.rankOneCleanBlockContract_pointwise_eq`, `CubicStatePreparation.arithmeticRankOneCubicCleanBlockContract_pointwise_eq` | compiled contract bridge; semantic clean-block proof open |
| Decompose approximation error budget for arithmetic and rotation/transduction | `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-ERR-001.md`; Lean theorem later | designed, Lean open |

## Candidate Obligations

| Obligation | Status |
|---|---|
| Candidate unitary family `U_n` | interface seeded by `CubicStatePreparation.arithmeticCubicClaim` and rank-one wrapper claim `CubicStatePreparation.arithmeticRankOneCubicClaim`; shape audit in `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-CAND-001.md`; semantic unitary matrix still open |
| Gate/circuit transcript for `U_n` | middle arithmetic transcript compiled as `CubicStatePreparation.arithmeticCubicCircuit`; rank-one wrapper transcript compiled as `CubicStatePreparation.arithmeticRankOneCubicCircuit` |
| Exact Hadamard-counting candidate transcript | proof architecture in `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-CAND-SHAPE-001.md`; Lean interface open |
| Block-entry theorem for `O_n` | target-shape bridge compiled: `rankOneCleanBlockContract_pointwise_eq`; semantic zero-filter, row-generation, amplitude, and unitarity proofs remain open |
| Approximation theorem with `epsilon <= 1e-10` or explicit relaxation | open |
| Unitarity theorem for `U_n` | open |
| Resource score `(gateCount, depth, auxiliaryQubits, oracleCalls)` | compiled for the unexpanded-oracle tier as `CubicStatePreparation.arithmeticCubicResourceTuple` and wrapper tuple `CubicStatePreparation.arithmeticRankOneCubicResourceTuple`; semantic expansion score open |
| Finite external verifier comparison on the same target | complete for dense small-`n` baselines; see `reports/cubic-stateprep/external_comparison.md` |
| Qiskit finite dense baseline export | complete for selected small `n`; see `executable-exports/QBE-OP-CUBIC-STATEPREP-001/qiskit/export.py` |
| Qiskit/QASM/QuantumKatas export of the final symbolic candidate after Lean closure | open |

## Proof-DAG Active Frontier

| Node | Interface | Dependencies | Owner | Lean declaration or artifact | Status |
|---|---|---|---|---|---|
| CUBIC-TGT-001 | Rank-one target entries for `O_n`. | none | middle/Lean target | `cubicOperator`, `gridSize_pos`, `cubicOperator_first_column`, `cubicOperator_only_first_column` | compiled |
| CUBIC-DIAG-001 | Small exact norm diagnostics. | CUBIC-TGT-001 | historical lower | `cubicNormSq_n1`, `cubicNormSq_n2`, `cubicNormSq_n3` | compiled, retired |
| CUBIC-NORM-001A | Rewrite `cubicNormSq n` as a fold over `gridPoint n j ^ 6`. | CUBIC-TGT-001 | lower Lean refiner | `rat_cube_sq_eq_sixth`, `cubicAmplitude_sq_eq_gridPoint_sixth`, `cubicNormSq_sixthPowerFold` | compiled |
| CUBIC-NORM-001 | Closed rational formula for `cubicNormSq n`. | CUBIC-NORM-001A, `classical-sixth-power-sum` | lower Lean | planned `cubicNormSq_closedForm`; `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-NORM-001.md` | proof design recorded; active Lean leaf |
| CUBIC-ALPHA-001 | Relate normalizer to target norm. | Direct entrywise norm bound | lower Lean | `cubicNormSq_le_conservativeNormalizer_sq` | compiled |
| CUBIC-ERR-001 | Scenario 2 arithmetic/rotation error budget. | CUBIC-ALPHA-001 | lower architect | `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-ERR-001.md` | designed, blocked on alpha/candidate interface |
| CUBIC-VER-001 | Dense-vs-symbolic verifier scaling for `n = 4, 8, 12, 16, 20`. | CUBIC-TGT-001 | verifier lower | `verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic-ver-001-scaling.md` | diagnostic complete, not a certificate |
| CUBIC-CAND-001 | Arithmetic cubic amplitude-transduction interface plus rank-one wrapper shape audit. | CUBIC-TGT-001 | lower worker 5 / lower proof architect | `arithmeticCubicLayout`, `arithmeticCubicCircuit`, `arithmeticCubicNormalizer`, `arithmeticCubicResourceTuple`, `arithmeticCubicClaim`; `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-CAND-001.md` | compiled middle interface; semantic block proof open |
| CUBIC-CAND-SHAPE-001 | Rank-one wrapper transcript, resource tuple, clean-block contract, and target-shape bridge. | CUBIC-CAND-001, CUBIC-TGT-001 | lower worker 5 / lower Lean | `arithmeticRankOneCubicLayout`, `arithmeticRankOneCubicCircuit`, `arithmeticRankOneCubicResourceTuple`, `arithmeticRankOneCubicClaim`, `rankOneCleanBlockContract_pointwise_eq`, `arithmeticRankOneCubicCleanBlockContract_pointwise_eq` | compiled interface and pointwise bridge; zero-filter/row-generation semantics open |
| CUBIC-HCOUNT-001 | Exact Hadamard-sandwich path-counting route for the rank-one block. | CUBIC-CAND-SHAPE-001, CUBIC-ALPHA-001 | lower proof architect / future Lean | `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-CAND-SHAPE-001.md`; `hadamardCountingCubicClaim` | designed; interface compiled; semantic proof open |
| CUBIC-HCOUNT-IFACE-001 | Hadamard-counting layout, transcript, normalizer, resource tuple, clean-block contract bridge, and normalizer bridge. | CUBIC-TGT-001, CUBIC-ALPHA-001 | lower Lean | `hadamardCountingCubicLayout`, `hadamardCountingCubicCircuit`, `hadamardCountingCubicNormalizer`, `hadamardCountingCubicResourceTuple`, `hadamardCountingCubicCleanBlockContract_pointwise_eq`, `cubicNormSq_le_hadamardCountingCubicNormalizer_sq` | compiled interface; not a certificate |
| CUBIC-HCOUNT-RATIO-001 | Prove `cubicAmplitude n j / conservativeNormalizer n = j.val^3 / (gridSize n)^4`. | CUBIC-HCOUNT-IFACE-001, `gridSize_rat_ne_zero` | future lower Lean | planned ratio lemma | active Lean leaf |
| CUBIC-VER-CAND-001 | Necessary-condition checks for a concrete finite instance of the rank-one wrapper or Hadamard-counting transcript. | CUBIC-CAND-SHAPE-001, CUBIC-HCOUNT-IFACE-001 | future verifier lower | planned verifier-feedback artifact | active next diagnostic |

## Source-Correspondence Contract

| Field | Current value |
|---|---|
| Source anchor | User/task contract in `tasks/QBE-OP-CUBIC-STATEPREP-001.md`; no paper archive is active. |
| Object translated | Unnormalized rank-one operator `O_n = |v_n><0^n|`, where `v_n[j] = (j / 2^n)^3`. |
| Lean target surface | `gridPoint`, `cubicAmplitude`, `cubicOperator`, `cubicNormSq`, `conservativeNormalizer`, `cubicTarget`. |
| Active lower leaves | Parallel frontier: `CUBIC-NORM-001` closed-form diagnostic, `CUBIC-HCOUNT-RATIO-001` arithmetic bridge, and `CUBIC-VER-CAND-001` finite candidate diagnostics. |
| External technical lemma | `classical-sixth-power-sum` in `research-wiki/cited-results/classical-power-sums.md`, status `obligation` unless a Lean helper builds. |
| Owned by task | Target vector, rank-one operator interpretation, exact norm diagnostic, requested epsilon, and adaptive policy. |
| QBE-local glue | Block-encoding records, clean-block projector convention, normalizer bookkeeping, resource tuple, verifier-feedback fields. |
| Not allowed in next lower packet | No normalized state-preparation shortcut and no certification claim for an unproved candidate. Candidate theorem shapes are allowed and expected; Lean closure is required before promotion. |

## Necessary-Condition Diagnostics

Diagnostics may reject candidates but cannot prove the final family theorem.

| Diagnostic | Role |
|---|---|
| vector norm check | catches accidental "unnormalized vector is a state" mistakes |
| small `n` statevector/unitary check | fixed-instance executable check for candidate circuit instances |
| dense verifier scaling forecast | shows when statevector/unitary materialization stops being useful |
| exact amplitude synthesis audit | decides when to switch from exact search to Scenario 2 |

Completed diagnostic:

- `CUBIC-NORM-001` necessary-condition feedback in
  `verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic-norm-001-necessary-condition.md`
  found no finite counterexample to the planned sixth-power closed form or the
  unnormalized rank-one support shape.  Its error class remains
  `symbolic_bridge_gap` because the Lean proof is still open.
- `CUBIC-NORM-001A` compiled the local symbolic bridge from the definition of
  `cubicNormSq` to a sixth-power fold.  The closed rational formula is still
  open; future proof search should start from `cubicNormSq_sixthPowerFold`
  rather than expanding `(cubicAmplitude n j)^2` directly.
- `CUBIC-ALPHA-001` compiled the direct conservative-normalizer bridge:
  `cubicNormSq_le_conservativeNormalizer_sq`.  This proves each norm summand is
  at most `1`, bounds the fold by `gridSize n`, and then uses
  `gridSize n <= (gridSize n)^2`.
- `CUBIC-VER-001` records dense vector entries and one-auxiliary dense-unitary
  memory for `n = 4, 8, 12, 16, 20` in
  `verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic-ver-001-scaling.md`.
  The result keeps dense verification as a executable-check baseline and leaves
  `CUBIC-NORM-001` as the active Lean proof leaf.

Current scheduling note:

- `CUBIC-NORM-001` remains active for the exact closed-form diagnostic.
  `CUBIC-ALPHA-001` is closed for the conservative normalizer.
- `CUBIC-CAND-001` is no longer blocked behind the norm leaf: the first
  arithmetic-transduction candidate interface is compiled.
- `CUBIC-CAND-SHAPE-001` now has a compiled rank-one wrapper transcript,
  wrapper resource tuple, and pointwise bridge from the clean-block contract to
  `O_n`.  The remaining blocker is semantic: choose finite matrices/contracts
  for the zero-input filter, row-generation, amplitude transduction, and
  unitarity obligations.
- `CUBIC-HCOUNT-001` is an exact path-counting mutation recorded under
  `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-CAND-SHAPE-001.md`.  It
  now has compiled layout/circuit/resource declarations, a clean-block contract
  bridge, and a conservative-normalizer bridge.  It keeps the same target and
  normalizer; the next Lean leaf is the ratio lemma connecting
  `cubicAmplitude n j / conservativeNormalizer n` to `j^3 / (gridSize n)^4`.
- Verifier workers can now instantiate one finite `n=1` or `n=2` semantic
  matrix for the wrapper labels or the Hadamard-counting labels and test
  clean-block, unitarity, and ancilla cleanup necessary conditions before a
  large symbolic proof attempt.

Completed external same-target finite comparison:

- `reports/cubic-stateprep/external_comparison.md` records NumPy dense
  completion, Qiskit `Operator`, and Qiskit-QuantumKatas-style checks on small
  `n`.
- These rows are finite executable evidence, not symbolic family certificates.
  They may reject concrete candidates later, but they do not close
  `CUBIC-CAND-001`.
