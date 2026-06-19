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
