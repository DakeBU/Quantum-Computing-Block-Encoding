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
| Hadamard-sandwich cubic path counting | symbolic/scalable exact route | compiled separate-reject interface plus repaired finite semantic pass | Lean records the layout, oracle-label transcript, normalizer, resource tuple, clean-block contract bridge, conservative-normalizer bridge, ratio bridge, and `CUBIC-HCOUNT-REJECT-REPAIR-001`; the old daggered nonzero-flag transcript remains rejected, and the repaired transcript passed finite `n = 1, 2` semantic feedback without certification |

## Active Candidate Records

| Candidate family | Tier | Partial score fields | Current blocker | Next mutation or proof step |
|---|---|---|---|---|
| target-only norm bridge | diagnostic, not a BE candidate | `gateCount = 0`, `depth = 0`, `auxiliaryQubits = 0`, `oracleCalls = 0` only as a diagnostic artifact | closed rational formula remains open; conservative normalizer bridge is compiled | keep `CUBIC-NORM-001` as a diagnostic backlog leaf while candidate workers proceed on Hadamard-counting semantics |
| dense table state preparation | finite executable baseline | typed scaling feedback recorded in `verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic-ver-001-scaling.md`; local external comparison passed NumPy dense completion for `n = 1..6`, Qiskit `Operator` for `n = 1..4`, and Qiskit-QuantumKatas-style finite assertion for `n = 3`; dense unitary memory reaches 64 TiB at `n = 20` | no symbolic family certificate and no candidate block-entry theorem | keep as a verified finite seed, but do not promote to the certified population |
| reversible arithmetic cubic amplitude | symbolic/scalable route | middle-block interface `CubicStatePreparation.arithmeticCubicLayout`, `arithmeticCubicCircuit`, `arithmeticCubicNormalizer`, `arithmeticCubicResourceTuple`; wrapped interface `arithmeticRankOneCubicLayout`, `arithmeticRankOneCubicCircuit`, `arithmeticRankOneCubicResourceTuple`; target-shape bridge `rankOneCleanBlockContract_pointwise_eq`; proof audits in `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-CAND-001.md` and `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-CAND-SHAPE-001.md`; default precision `40`; wrapped default `n=2` tuple `(10, 10, 52, 10)` at the unexpanded-oracle tier | semantic matrix, unitarity, clean-block theorem, and finite wrapped verifier are still open | keep as a backup route while Hadamard-counting symbolic semantics are active; do not spend this cycle on broad arithmetic-wrapper verifier work |
| Hadamard-sandwich cubic path counting | exact reversible path-counting route | proof architecture recorded in `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-CAND-SHAPE-001.md`; Lean interface `hadamardCountingCubicLayout`, repaired `hadamardCountingCubicCircuit`, `hadamardCountingCubicResourceTuple`, clean-block contract bridge, normalizer bridge `cubicNormSq_le_hadamardCountingCubicNormalizer_sq`, and ratio bridge `cubicAmplitude_div_conservativeNormalizer_eq`; default `n=2` tuple `(8, 8, 21, 8)` at the oracle-label tier; finite path/support formula passed for `n = 1..4`; finite semantic check for the old daggered transcript failed; repaired separate-reject finite check passed for `n = 1, 2` | symbolic family theorem still open: finite feedback is not a Lean clean-block or unitarity certificate | active next leaf is `CUBIC-HCOUNT-COUNT-001`, the symbolic threshold path-count lemma; after it compiles, schedule reversible/Hadamard semantics before `CUBIC-HCOUNT-BLOCK-001` |
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
route now has a compiled layout/circuit/resource interface, route-specific
normalizer bridge, and separate nonzero-column reject repair.  The old daggered
nonzero-flag cleanup failed the finite clean-block diagnostic.  The repaired
separate-reject transcript now passes the `n = 1, 2` finite semantic check, but
semantic Hadamard-sandwich and path-counting theorems remain open.

## Compiled Candidate Interface: CUBIC-HCOUNT-IFACE-001

Lean declarations added for the exact path-counting mutation:

| Declaration | Role | Status |
|---|---|---|
| `CubicStatePreparation.hadamardCountingCubicWorkspace` | oracle-level reversible cube/comparator workspace reserve | compiled |
| `CubicStatePreparation.hadamardCountingCubicLayout` | reject signal, nonzero-input flag, `4*n` path qubits, and workspace | compiled |
| `CubicStatePreparation.hadamardCountingCubicCircuit` | eight-label Hadamard-counting transcript with separate nonzero-column reject signal | compiled |
| `CubicStatePreparation.hadamardCountingCubicNormalizer` | route normalizer, reusing `conservativeNormalizer` | compiled |
| `CubicStatePreparation.hadamardCountingCubicResourceTuple` | score tuple `(gateCount, depth, auxiliaryQubits, oracleCalls)` | compiled |
| `CubicStatePreparation.hadamardCountingCubicResourceTuple_n2` | small default diagnostic tuple `(8, 8, 21, 8)` | compiled |
| `CubicStatePreparation.hadamardCountingCubicCleanBlockContract` | route-specific instance of the reusable clean-block contract | compiled |
| `CubicStatePreparation.hadamardCountingCubicCleanBlockContract_pointwise_eq` | route-specific target-shape bridge to `cubicOperator n` | compiled |
| `CubicStatePreparation.cubicNormSq_le_hadamardCountingCubicNormalizer_sq` | route-specific conservative normalizer bridge | compiled |
| `CubicStatePreparation.cubicAmplitude_div_conservativeNormalizer_eq` | exact ratio bridge from `v_n[j] / alpha` to `j^3 / (gridSize n)^4` | compiled |

Finite diagnostics:

- `verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic-ver-cand-001-hcount-semantic.md`
  tested the old daggered nonzero-flag transcript for `n = 1` and `n = 2`.
  It reports `finite_matrix_ok=false`, `block_entry_ok=false`, and
  `error_class=finite_matrix_counterexample`.
- The path Hadamard orthogonality and reversible-layer checks are not the
  old-transcript blocker.  The old blocker was clean-block support: nonzero
  input columns returned to clean ancillas and contributed identity entries.
- The same feedback file checks the repaired separate-reject convention for
  `n = 1` and `n = 2` with `finite_matrix_ok=true` and
  `block_entry_ok=true`.
- The route remains in the insight pool because the repaired Lean interface is
  still not a semantic certificate.  It is not in the certified population until
  a named Lean clean-block theorem and the required unitarity/reversibility
  leaves are build-tested.

Cycle 3 scheduling fixes the next symbolic bridge as
`CUBIC-HCOUNT-COUNT-001`.  The proof packet
`proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-HCOUNT-COUNT-001.md`
targets pure path-register arithmetic: `gridSize (3 * n) = gridSize n ^ 3`,
`gridSize (4 * n) = gridSize n ^ 4`, the capacity bound
`j.val ^ 3 <= gridSize (3 * n)`, and the filtered threshold-count equality.
This is still an insight-pool route until Lean later proves the clean-block and
unitarity leaves.

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
