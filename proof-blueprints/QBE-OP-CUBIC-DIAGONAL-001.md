# Proof Blueprint: QBE-OP-CUBIC-DIAGONAL-001

Task id: `QBE-OP-CUBIC-DIAGONAL-001`
Title: Cubic diagonal oracle block encoding
Mode: `exploratoryConstruction`
Updated: `2026-06-19 20:40:54`
Blueprint stage: `Stage 2 DAG proof discharge, with source-transcript checks still active`

This is QBE's compact system-of-record snapshot for long-horizon Lean proof
automation.  It follows a similar control pattern to LeanMarathon's evolving
blueprint, but QBE keeps the human-facing proof map split across Lean,
Markdown, LaTeX, proof obligations, and cited-results memory because
block-encoding papers require source notation, register conventions, and
oracle contracts to stay explicit.

## Current Directive

````text
# Cubic diagonal oracle block encoding

Task id: `QBE-OP-CUBIC-DIAGONAL-001`
Kind: `operatorBlockEncoding`
Mode: `exploratoryConstruction`
Status: `active`

## Source Input

- Raw user language: `zh`
- Raw input artifact: `task-inbox/QBE-OP-CUBIC-DIAGONAL-001/user_prompt.zh.md`
- Source: `user-provided`
- Requested executable exports: `qiskit,quantum-katas,qasm3`

## Raw User Problem

假设n为正整数是量子比特数，我现在想要构造一个oracle
`O=sum_{j=0}^{2^n-1} f(x_j)|j><j|`，其中函数 `f(x)=x^3`,
`x_j = j/(2^n)`. 请构造这个 operator `O` 的 block-encoding `U_O`.

## Lean-Checkable Target

For `N = 2^n`, define

```text
D_n = sum_{j=0}^{N-1} (j/N)^3 |j><j|.
```

Equivalently, in matrix entries:

```text
D_n[row, col] = if row = col then (row / 2^n)^3 else 0.
```

This task is a **diagonal oracle** problem, not the rank-one state-preparation
problem from `QBE-OP-CUBIC-STATEPREP-001`. Lower agents must not replace it by
`|v><0^n|` and must not normalize the diagonal vector as a quantum state.

The initial exact normalizer is

```text
alpha = 1.
```

Reason: for every grid point `0 <= j/2^n < 1`, the diagonal entry
`(j/2^n)^3` lies in `[0,1]`. The first candidate is therefore a one-signal
amplitude-oracle block encoding whose clean block is exactly `D_n`.

## Current Lean Surface

Compiled declarations live in `QuantumBlockEncoding.CubicDiagonalOracle`:

```lean
taskId
cubicDiagonalOperator
exactNormalizer
cubicDiagonalTarget
amplitudeOracleLayout
amplitudeOracleCircuit
amplitudeOracleResource
amplitudeOracleResourceTuple
amplitudeOracleResource_eq
amplitudeOracleResourceTuple_eq
diagonalCleanBlockContract
diagonalCleanBlockContract_pointwise_eq
cubicAmplitude_le_one
cubicAmplitude_nonneg
amplitudeOracleClaim
```

These declarations fix the target and the oracle-label candidate interface.
They do **not** yet prove a fully expanded gate-level unitary. The next cycle
should either:

1. certify the amplitude oracle as a primitive contract with exact clean-block
   theorem; or
2. expand the amplitude oracle into reversible arithmetic plus controlled
   rotations and then prove the clean block.

## Candidate Score

The oracle-label candidate currently has

```text
(gateCount, depth, auxiliaryQubits, oracleCalls) = (1, 1, 1, 1).
```

Inside one asymptotic/backend tier, QBE ranks candidates by

```text
(gateCount, depth, auxiliaryQubits, oracleCalls).
```

Do not compare an unexpanded oracle-label candidate against a fully expanded
arithmetic-gate candidate without first recording the tier.

## Hard Mode And Escalation Policy

This simpler diagonal task should normally start in L0:

| Level | Trigger | Agent allocation | Search action |
|---|---|---|---|
| L0 | task starts | upper=1, middle=1, lower=3 | prove exact oracle-label contract or name the precise expansion leaf |
| L1 | no closed Lean leaf or no finite/certified improvement after one cycle | upper panel, middle coordinator, lower=5 | increase mutation/crossover/repair budget and decide whether primitive-oracle contract is acceptable |
| L2 | L1 still has no improving candidate after one cycle | upper panel, middle panel, lower=8 | switch to approximate expanded arithmetic/rotation route if exact expanded proof is not closing |

The system must keep separate populations:

- certified population: Lean-proved candidates only;
- finite executable population: Qiskit/NumPy/QuantumKatas checks only;
- insight pool: useful but unproved routes.

Only certified candidates may be plotted as achieved BE solutions.

## Next Agent Packet

- upper: keep the target diagonal. Do not import rank-one state-prep logic.
- middle: maintain the two-way Lean/natural-language map and retire any stale
  state-prep wording.
- lower 1 natural-language architect: write the exact diagonal amplitude-oracle
  proof DAG: range bound, one-signal unitary contract, clean-block equality,
  resource tuple, and downstream executable export.
- lower 2 Lean worker: close one named leaf, preferably a primitive-contract
  theorem for `diagonalCleanBlockContract` or a small reusable lemma needed for
  the diagonal amplitude oracle.
- lower 3 verifier/export worker: run finite diagonal matrix checks for small
  `n` and prepare Qiskit export only after the target/operator semantics are
  fixed.
- reviewer: reject any proof route that turns this diagonal operator into the
  previous rank-one target or a normalized state-preparation task.
````

## Dynamic Leaf Queue

These are the current local proof or repair candidates.  Lower agents should
work on one item at a time; if an item is stale, upper/middle must retire it
before spending more proof-search tokens.

| Leaf | Status |
|---|---|
| DIAG-BLOCK-BRIDGE-001: Any block satisfying `diagonalCleanBlockContract` is pointwise equal to `(cubicDiagonalTarget n).operator`.; status: active leaf; Lean: planned `CubicDiagonalOracle.primitiveOracleCleanBlock_eq_target` | candidate |
| DIAG-PRIM-UNITARY-001: State and certify the primitive one-signal amplitude-oracle unitary and clean-block extraction without expanding arithmetic.; status: blocked internal obligation; Lean: planned primitive semantic contract; exact name to be chosen after `DIAG-BLOCK-BRIDGE-001` | candidate |
| DIAG-ROOT-001: Exact primitive operator block-encoding certificate, or an equivalent project-local certificate that keeps unitarity and block correctness explicit.; status: blocked internal obligation; Lean: planned `VerifiedOperatorBlockEncoding`-compatible artifact | candidate |
| DIAG-EXPORT-001: Qiskit, QuantumKatas-style, and QASM3 export plan tied to the named Lean certificate.; status: blocked downstream; Lean: planned `executable-exports/QBE-OP-CUBIC-DIAGONAL-001/` packet | candidate |

## Open Obligation Signals

```text
Keep the target diagonal, not rank-one state preparation.: Lean `CubicDiagonalOracle.cubicDiagonalOperator`, `cubicDiagonalTarget`; class source/operator contract; status compiled; reviewer must reject rank-one routes
Record exact normalizer $\alpha = 1$.: Lean `CubicDiagonalOracle.exactNormalizer`; class normalizer; status compiled
Prove amplitude range $0 \le (j/2^n)^3 \le 1$.: Lean `cubicAmplitude_nonneg`, `cubicAmplitude_le_one`; class internal Lean lemma; status compiled
Record one-signal primitive oracle-label resources.: Lean `amplitudeOracleLayout`, `amplitudeOracleResourceTuple_eq`; class resource equality; status compiled
Bridge a clean-block contract to the target operator.: Lean planned `CubicDiagonalOracle.primitiveOracleCleanBlock_eq_target`; class internal Lean lemma; status active leaf / planned next
State primitive one-signal oracle unitarity and clean-block extraction without hiding semantics.: Lean planned primitive semantic contract; class oracle/circuit semantics; status open obligation; do not encode as `True`
Produce an exact primitive block-encoding certificate or equivalent project-local certificate.: Lean planned `VerifiedOperatorBlockEncoding`-compatible artifact; class root certificate; status blocked on primitive oracle semantics
If primitive oracle contract is rejected, expand arithmetic and controlled rotations with a correct `R_y` convention.: Lean planned expanded route; class alternative circuit construction; status backlog
Create Qiskit, QuantumKatas-style, and QASM3 exports.: Lean planned `executable-exports/QBE-OP-CUBIC-DIAGONAL-001/` packet; class post-Lean export; status blocked until a Lean certificate is named
```

## Lean Declaration Index

Recent task-relevant declarations:

| Kind | Lean name | File |
|---|---|---|
| theorem | `rat_cube_sq_eq_sixth` | `QuantumBlockEncoding/CubicStatePreparation.lean:530` |
| theorem | `cubicAmplitude_sq_eq_gridPoint_sixth` | `QuantumBlockEncoding/CubicStatePreparation.lean:537` |
| theorem | `cubicNormSq_sixthPowerFold` | `QuantumBlockEncoding/CubicStatePreparation.lean:542` |
| theorem | `gridSize_rat_ne_zero` | `QuantumBlockEncoding/CubicStatePreparation.lean:549` |
| theorem | `gridSize_rat_pos` | `QuantumBlockEncoding/CubicStatePreparation.lean:554` |
| theorem | `rat_div_cube_div_eq` | `QuantumBlockEncoding/CubicStatePreparation.lean:559` |
| theorem | `cubicAmplitude_div_conservativeNormalizer_eq` | `QuantumBlockEncoding/CubicStatePreparation.lean:570` |
| theorem | `gridSize_three_mul_eq_cube` | `QuantumBlockEncoding/CubicStatePreparation.lean:578` |
| theorem | `gridSize_four_mul_eq_fourth` | `QuantumBlockEncoding/CubicStatePreparation.lean:584` |
| theorem | `hadamardCountingCubic_thresholdCountP_finRange` | `QuantumBlockEncoding/CubicStatePreparation.lean:595` |
| theorem | `hadamardCountingCubic_thresholdFilterLength` | `QuantumBlockEncoding/CubicStatePreparation.lean:624` |
| theorem | `hadamardCountingCubic_threshold_le_pathCapacity` | `QuantumBlockEncoding/CubicStatePreparation.lean:631` |
| theorem | `hadamardCountingCubic_thresholdPathCount` | `QuantumBlockEncoding/CubicStatePreparation.lean:644` |
| theorem | `gridPoint_nonneg` | `QuantumBlockEncoding/CubicStatePreparation.lean:652` |
| theorem | `gridPoint_lt_one` | `QuantumBlockEncoding/CubicStatePreparation.lean:661` |
| theorem | `gridPoint_le_one` | `QuantumBlockEncoding/CubicStatePreparation.lean:668` |
| theorem | `rat_pow_le_one_of_nonneg_le_one` | `QuantumBlockEncoding/CubicStatePreparation.lean:672` |
| theorem | `cubicAmplitude_sq_le_one` | `QuantumBlockEncoding/CubicStatePreparation.lean:686` |
| theorem | `foldl_add_le_add_length` | `QuantumBlockEncoding/CubicStatePreparation.lean:692` |
| theorem | `cubicNormSq_le_gridSize` | `QuantumBlockEncoding/CubicStatePreparation.lean:718` |
| theorem | `gridSize_rat_le_sq` | `QuantumBlockEncoding/CubicStatePreparation.lean:730` |
| theorem | `cubicNormSq_le_conservativeNormalizer_sq` | `QuantumBlockEncoding/CubicStatePreparation.lean:742` |
| theorem | `cubicNormSq_le_arithmeticCubicNormalizer_sq` | `QuantumBlockEncoding/CubicStatePreparation.lean:753` |
| theorem | `cubicNormSq_le_hadamardCountingCubicNormalizer_sq` | `QuantumBlockEncoding/CubicStatePreparation.lean:763` |
| theorem | `cubicNormSq_n1` | `QuantumBlockEncoding/CubicStatePreparation.lean:768` |
| theorem | `cubicNormSq_n2` | `QuantumBlockEncoding/CubicStatePreparation.lean:772` |
| theorem | `cubicNormSq_n3` | `QuantumBlockEncoding/CubicStatePreparation.lean:776` |
| def | `taskId` | `QuantumBlockEncoding/CubicStatePreparation.lean:785` |
| def | `cubicDiagonalOperator` | `QuantumBlockEncoding/CubicStatePreparation.lean:788` |
| def | `exactNormalizer` | `QuantumBlockEncoding/CubicStatePreparation.lean:794` |
| def | `cubicDiagonalTarget` | `QuantumBlockEncoding/CubicStatePreparation.lean:797` |
| def | `amplitudeOracleLayout` | `QuantumBlockEncoding/CubicStatePreparation.lean:812` |
| def | `amplitudeOracleCircuit` | `QuantumBlockEncoding/CubicStatePreparation.lean:818` |
| def | `amplitudeOracleResource` | `QuantumBlockEncoding/CubicStatePreparation.lean:822` |
| def | `amplitudeOracleCost` | `QuantumBlockEncoding/CubicStatePreparation.lean:826` |
| def | `amplitudeOracleResourceTuple` | `QuantumBlockEncoding/CubicStatePreparation.lean:831` |
| theorem | `amplitudeOracleResource_eq` | `QuantumBlockEncoding/CubicStatePreparation.lean:838` |
| theorem | `amplitudeOracleResourceTuple_eq` | `QuantumBlockEncoding/CubicStatePreparation.lean:842` |
| def | `diagonalCleanBlockContract` | `QuantumBlockEncoding/CubicStatePreparation.lean:849` |
| theorem | `diagonalCleanBlockContract_pointwise_eq` | `QuantumBlockEncoding/CubicStatePreparation.lean:855` |
| theorem | `cubicAmplitude_le_one` | `QuantumBlockEncoding/CubicStatePreparation.lean:863` |
| theorem | `cubicAmplitude_nonneg` | `QuantumBlockEncoding/CubicStatePreparation.lean:870` |
| def | `amplitudeOracleClaim` | `QuantumBlockEncoding/CubicStatePreparation.lean:877` |
| structure | `RegisterLayout` | `QuantumBlockEncoding/BlockEncoding.lean:14` |
| structure | `BlockEncodingSpec` | `QuantumBlockEncoding/BlockEncoding.lean:33` |
| structure | `BlockEncodingCost` | `QuantumBlockEncoding/BlockEncoding.lean:50` |
| def | `fromLayoutAndResource` | `QuantumBlockEncoding/BlockEncoding.lean:59` |
| structure | `QueryOperatorTarget` | `QuantumBlockEncoding/BlockEncoding.lean:90` |
| structure | `OperatorBlockEncodingCandidate` | `QuantumBlockEncoding/BlockEncoding.lean:103` |
| structure | `VerifiedOperatorBlockEncoding` | `QuantumBlockEncoding/BlockEncoding.lean:131` |
| structure | `ApproximateOperatorBlockEncodingCandidate` | `QuantumBlockEncoding/BlockEncoding.lean:148` |
| structure | `VerifiedApproximateOperatorBlockEncoding` | `QuantumBlockEncoding/BlockEncoding.lean:159` |
| structure | `AdaptiveBlockEncodingPolicy` | `QuantumBlockEncoding/BlockEncoding.lean:195` |
| inductive | `BlockEncodingSearchPhase` | `QuantumBlockEncoding/BlockEncoding.lean:207` |
| structure | `VerifiedBlockEncoding` | `QuantumBlockEncoding/BlockEncoding.lean:220` |
| abbrev | `Matrix` | `QuantumBlockEncoding/Core.lean:15` |
| def | `gridSize` | `QuantumBlockEncoding/Core.lean:44` |
| abbrev | `Circuit` | `QuantumBlockEncoding/Circuit.lean:23` |
| abbrev | `CircuitLayer` | `QuantumBlockEncoding/Circuit.lean:50` |
| abbrev | `LayeredCircuit` | `QuantumBlockEncoding/Circuit.lean:60` |

## Correspondence Artifacts

| Artifact | Role |
|---|---|
| `tasks/QBE-OP-CUBIC-DIAGONAL-001.md` | task/proof map |
| `conversion-windows/QBE-OP-CUBIC-DIAGONAL-001.md` | Lean/natural-language conversion |
| `proof-obligations/QBE-OP-CUBIC-DIAGONAL-001.md` | open obligations |

## Latest Dialogue Signal

````text
## 20260619-203248-QBE-OP-CUBIC-DIAGONAL-001-cycle01

# Dialogue: QBE-OP-CUBIC-DIAGONAL-001 cycle 1

Append short role-tagged handoffs here.

## 2026-06-19 20:34:37 - upper

Mode exploratory construction/operator construction. Objective: certify the primitive one-signal diagonal amplitude-oracle candidate for D_n with alpha=1, preserving the diagonal matrix target. Frontier: root should be a VerifiedOperatorBlockEncoding or equivalent exact primitive certificate; dependencies are cubicDiagonalOperator/target, amplitudeOracleLayout/resource tuple, cubicAmplitude range bounds, diagonalCleanBlockContract pointwise equality, and an explicit primitive oracle unitary/block contract. Active Lean leaf: introduce one compiling primitive-certificate node linking the oracle-label clean block to cubicDiagonalOperator, without expanding arithmetic. Lower 1 writes the proof DAG, lower 2 compiles one leaf, lower 3 runs finite diagonal/block checks. Stop rank-one state-prep, normalized-vector, and Qiskit export routes until Lean semantics are fixed.
````

## Gate Policy

- Stage 1 target/transcript stabilization: upper and middle must verify that
  Lean statements, source-paper prose, register layouts, normalizers, and
  cited contracts match before broad lower proving.
- Stage 2 DAG proof discharge: lower agents work on dynamic leaves only;
  reviewer accepts inner-cycle progress only through `python3 tools/qbe.py check`
  and synchronized Lean-to-natural-language proof status.  LaTeX exports are
  checked at 6h/convergence closeout.
- Mixed lower-agent proof mode: lower 1 writes the natural-language dependency
  proof and active-leaf table; lower 2 compiles exactly one ready Lean leaf;
  lower 3, when available, runs necessary-condition diagnostics such as finite
  matrix/path/support checks and typed verifier-feedback packets before lower 2
  spends time on a large Lean proof.
- Refiner behavior: when several failures share a dependency, repair the
  connected illness area once instead of stacking independent patches.
- No agent may mark a proof complete from self-assessment, partial score, or
  process memory.  Lean plus explicit proof-map correspondence is the gate.
