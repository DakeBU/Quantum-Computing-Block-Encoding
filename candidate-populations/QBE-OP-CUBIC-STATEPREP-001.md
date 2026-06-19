# Candidate Population: QBE-OP-CUBIC-STATEPREP-001

Target:

```text
O_n = |v_n><0^n|,  v_n[j] = (j / 2^n)^3,  epsilon = 1e-10.
```

## Certified Population

No full block-encoding candidate has been promoted yet.  The compiled Lean
surface currently certifies only the target declarations and small norm
diagnostics.

Retired non-candidates:

| Artifact | Reason |
|---|---|
| `cubicNormSq_n1`, `cubicNormSq_n2`, `cubicNormSq_n3` | Useful exact diagnostics, but they do not define a scalable candidate or a normalizer proof. |

## Insight Pool

| Candidate | Tier | Current role | Reason kept |
|---|---|---|---|
| dense table state preparation | finite executable baseline | fixed-instance evidence and debugging seed | passed local finite checks; simple for small `n`, but scales with `2^n` |
| universal block-matrix completion | mathematical seed | correctness seed | generic BE construction, not resource-competitive |
| reversible arithmetic cubic amplitude | symbolic/scalable route | primary Scenario 2 route | plausible `poly(n, log(1/epsilon))` construction |
| polynomial/Chebyshev approximation | symbolic/scalable route | alternate Scenario 2 route | may reduce rotation synthesis cost |
| arithmetic cubic amplitude transduction | symbolic/scalable route | compiled arithmetic middle block | Lean records the cubic arithmetic/transduction transcript, normalizer choice, and resource tuple; it is not by itself a rank-one clean block |
| rank-one wrapped arithmetic cubic transduction | symbolic/scalable route | compiled candidate interface plus clean-block contract bridge | Lean now records the zero-input filter and row-generation wrapper around the arithmetic middle block, and a pointwise bridge from the clean-block contract to `O_n`; semantic matrix, unitarity, clean-block, and error proofs remain open |
| Hadamard-sandwich cubic path counting | symbolic/scalable exact route | compiled interface plus shape-repair mutation | Lean records the layout, oracle-label transcript, normalizer, resource tuple, clean-block contract bridge, and conservative-normalizer bridge; semantic Hadamard/comparator proof remains open |

## Active Candidate Records

| Candidate family | Tier | Partial score fields | Current blocker | Next mutation or proof step |
|---|---|---|---|---|
| target-only norm bridge | diagnostic, not a BE candidate | `gateCount = 0`, `depth = 0`, `auxiliaryQubits = 0`, `oracleCalls = 0` only as a diagnostic artifact | no closed rational formula or normalizer proof yet | prove CUBIC-NORM-001 in Lean, or prove the direct CUBIC-ALPHA-001 conservative-normalizer bound, while candidate workers proceed independently |
| dense table state preparation | finite executable baseline | typed scaling feedback recorded in `verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic-ver-001-scaling.md`; local external comparison passed NumPy dense completion for `n = 1..6`, Qiskit `Operator` for `n = 1..4`, and Qiskit-QuantumKatas-style finite assertion for `n = 3`; dense unitary memory reaches 64 TiB at `n = 20` | no symbolic family certificate and no candidate block-entry theorem | keep as a verified finite seed, but do not promote to the certified population |
| reversible arithmetic cubic amplitude | symbolic/scalable route | middle-block interface `CubicStatePreparation.arithmeticCubicLayout`, `arithmeticCubicCircuit`, `arithmeticCubicNormalizer`, `arithmeticCubicResourceTuple`; wrapped interface `arithmeticRankOneCubicLayout`, `arithmeticRankOneCubicCircuit`, `arithmeticRankOneCubicResourceTuple`; target-shape bridge `rankOneCleanBlockContract_pointwise_eq`; proof audits in `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-CAND-001.md` and `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-CAND-SHAPE-001.md`; default precision `40`; wrapped default `n=2` tuple `(10, 10, 52, 10)` at the unexpanded-oracle tier | semantic matrix, unitarity, clean-block theorem, and finite wrapped verifier are still open | instantiate one finite `n=1` or `n=2` semantic matrix for `arithmeticRankOneCubicCircuit` or the Hadamard-counting interface and run clean-block, unitarity, and ancilla-cleanup necessary-condition checks |
| Hadamard-sandwich cubic path counting | exact reversible path-counting route | proof architecture recorded in `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-CAND-SHAPE-001.md`; Lean interface `hadamardCountingCubicLayout`, `hadamardCountingCubicCircuit`, `hadamardCountingCubicResourceTuple`, clean-block contract bridge, and normalizer bridge `cubicNormSq_le_hadamardCountingCubicNormalizer_sq`; default `n=2` tuple `(7, 7, 21, 7)` at the oracle-label tier | symbolic ratio lemma, finite clean-block diagnostics, unitarity, and Hadamard/comparator semantics remain open | prove `CUBIC-HCOUNT-RATIO-001`, or run finite `n=1`/`n=2` clean-block checks before attempting the symbolic Hadamard-sandwich theorem |
| universal block-matrix completion | mathematical seed | resource tuple open and expected noncompetitive | no candidate matrix completion theorem named | keep as fallback seed and name the clean-block theorem shape now rather than waiting for the norm leaf |

## Compiled Candidate Interface: CUBIC-CAND-001

Lean declarations added for the first scalable route:

| Declaration | Role | Status |
|---|---|---|
| `CubicStatePreparation.arithmeticCubicDefaultPrecision` | fixed first precision seed, `40` bits | compiled |
| `CubicStatePreparation.arithmeticCubicLayout` | one signal qubit and `3*n + precision + 2` pure arithmetic ancillas | compiled |
| `CubicStatePreparation.arithmeticCubicCircuit` | seven-label oracle transcript: load `j/2^n`, square, multiply by `x`, rotate/transduce, then uncompute | compiled |
| `CubicStatePreparation.arithmeticCubicNormalizer` | candidate normalizer, currently `conservativeNormalizer n` | compiled; conservative proof bridge compiled |
| `CubicStatePreparation.arithmeticCubicResourceTuple` | score tuple `(gateCount, depth, auxiliaryQubits, oracleCalls)` | compiled |
| `CubicStatePreparation.arithmeticCubicClaim` | human-facing construction claim for the search archive | compiled; not certified |
| `CubicStatePreparation.arithmeticRankOneCubicLayout` | wrapper layout with zero-input and row-generation workspace | compiled |
| `CubicStatePreparation.arithmeticRankOneCubicCircuit` | rank-one wrapper transcript around the seven-label arithmetic middle block | compiled |
| `CubicStatePreparation.arithmeticRankOneCubicNormalizer` | wrapper normalizer, reusing `arithmeticCubicNormalizer` | compiled; conservative bridge compiled |
| `CubicStatePreparation.arithmeticRankOneCubicResourceTuple` | wrapped score tuple `(gateCount, depth, auxiliaryQubits, oracleCalls)` | compiled |
| `CubicStatePreparation.arithmeticRankOneCubicClaim` | human-facing wrapped construction claim | compiled; not certified |
| `CubicStatePreparation.rankOneCleanBlockContract` | reusable semantic clean-block contract: scaled first column equals `v_n`, all other clean columns vanish | compiled |
| `CubicStatePreparation.arithmeticRankOneCubicCleanBlockContract` | candidate-specific instance of the clean-block contract for the wrapper normalizer | compiled |
| `CubicStatePreparation.rankOneCleanBlockContract_pointwise_eq` | proof that the reusable clean-block contract scales pointwise to `cubicOperator n` | compiled |
| `CubicStatePreparation.arithmeticRankOneCubicCleanBlockContract_pointwise_eq` | proof that the wrapper-specific contract scales pointwise to `cubicOperator n` | compiled |

This route preserves the target operator `O_n = |v_n><0^n|`.  It does not use a
normalized output-state shortcut: the clean block is intended to realize
`O_n / alpha`, with `alpha = conservativeNormalizer n`, and the Scenario 2
acceptance target remains the requested operator-norm inequality at
`epsilon = 1e-10`.

The contract bridge is reused by the separate Hadamard-counting route in
`proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-CAND-SHAPE-001.md`: that
route now has a compiled layout/circuit/resource interface and route-specific
normalizer bridge, but still needs semantic Hadamard-sandwich and
path-counting theorems before promotion.

## Compiled Candidate Interface: CUBIC-HCOUNT-IFACE-001

Lean declarations added for the exact path-counting mutation:

| Declaration | Role | Status |
|---|---|---|
| `CubicStatePreparation.hadamardCountingCubicWorkspace` | oracle-level reversible cube/comparator workspace reserve | compiled |
| `CubicStatePreparation.hadamardCountingCubicLayout` | reject signal, nonzero-input flag, `4*n` path qubits, and workspace | compiled |
| `CubicStatePreparation.hadamardCountingCubicCircuit` | seven-label Hadamard-counting transcript | compiled |
| `CubicStatePreparation.hadamardCountingCubicNormalizer` | route normalizer, reusing `conservativeNormalizer` | compiled |
| `CubicStatePreparation.hadamardCountingCubicResourceTuple` | score tuple `(gateCount, depth, auxiliaryQubits, oracleCalls)` | compiled |
| `CubicStatePreparation.hadamardCountingCubicResourceTuple_n2` | small default diagnostic tuple `(7, 7, 21, 7)` | compiled |
| `CubicStatePreparation.hadamardCountingCubicCleanBlockContract` | route-specific instance of the reusable clean-block contract | compiled |
| `CubicStatePreparation.hadamardCountingCubicCleanBlockContract_pointwise_eq` | route-specific target-shape bridge to `cubicOperator n` | compiled |
| `CubicStatePreparation.cubicNormSq_le_hadamardCountingCubicNormalizer_sq` | route-specific conservative normalizer bridge | compiled |

## Promotion Rule

A candidate can enter the certified population only after Lean proves:

1. the candidate is unitary at the advertised semantic tier;
2. its clean block approximates `O_n` with the stated `epsilon`;
3. its resource score is computed under the fixed metric order;
4. any Qiskit/QASM/QuantumKatas export is downstream of the Lean theorem, not a
   substitute for it.

## External Tool Boundary

The local external tools checked so far do not provide a direct generic
block-encoding constructor for the requested rank-one operator family.  Qiskit
and the Qiskit-QuantumKatas-style evaluator can verify small dense instances
after ABEIS or a baseline script produces a concrete unitary.  QASM-Eval,
QUASAR, and AI-Mandel are useful method references or typed-feedback sources,
but they are not promoted into the candidate population for this task.
