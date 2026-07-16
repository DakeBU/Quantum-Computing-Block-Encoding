# Hard case cubic diagonal oracle, cold isolated Hierarchical Harness

Task id: `QBE-HARD-CUBIC-DIAGONAL-HIER-COLD-001`
Kind: `operatorBlockEncoding`
Mode: `exploratoryConstruction`
Status: `complete`
Created: `2026-06-28`
Completed: `2026-07-16`

Route lock: `FD-`, `DIAG-`
Lean acceptance anchors: `CubicDiagonalOracle.cubicDiagonalHouseholderExactBEContract_complete`
Population gate: `required`
Executable acceptance command: `python3 tools/export_hard_cubic_householder.py --task QBE-HARD-CUBIC-DIAGONAL-HIER-COLD-001 --n 2`
Executable acceptance artifacts: `executable-exports/QBE-HARD-CUBIC-DIAGONAL-HIER-COLD-001/qiskit/acceptance.json`, `executable-exports/QBE-HARD-CUBIC-DIAGONAL-HIER-COLD-001/qasm3/cubic_householder_n2.qasm3`

The current compiled memory library may close this cold arm with the exact
rational diagonal Householder certificate.  After this anchor compiles in the
current source digest, older fixed-precision and induced-norm leaves are
superseded and must not be scheduled again.

The final isolated v5 run passed a fresh Lean build and the declared Qiskit/QASM3
gate.  Its machine state is retained under
`../abeis_isolated_runs/20260716-hard-acceptance-v5/HARD_COLD/runs/control/`.

## Clean-Start Rule

This is the cold hard-case arm.  Agents must not use previous cubic diagonal
attempts, previous ChatGPT Pro suggestions, previous hint packets, old
candidate names, or old run memory.  They may use the current compiled ABEIS
library, Mathlib, standard quantum-computing facts, and the block-encoding
memory/skill cards as inspiration and reusable Lean leaves.

## Raw User Problem

假设 `n` 为正整数，是量子比特数。构造一个 oracle/operator

$$
O_n = \sum_{j=0}^{2^n-1} f(x_j) |j\rangle\langle j|,
\qquad f(x)=x^3,
\qquad x_j = j/2^n.
$$

请构造这个 operator `O_n` 的 block-encoding `U_O`。

## Lean-Checkable Target

For `N = 2^n`, define

$$
D_n[j,j] = (j/N)^3,\qquad D_n[j,k]=0 \text{ for } j\ne k.
$$

Start with exact block encoding and normalizer `alpha = 1`.  If exact search
stalls under the configured patience budget, upper/reviewer must explicitly
open Scenario 2 approximate search:

1. start at `epsilon = 1e-10`;
2. record every epsilon relaxation in the memory digest, candidate population,
   selected-language summary, and Pro prompt;
3. plot only Lean-certified exact or approximate candidates as achieved
   solutions.

## Harness Policy

Use the Hierarchical Harness.  Upper and reviewer decide when stagnation
justifies increasing upper, middle, or lower parallelism.  More lower workers
are allowed only when upper/middle have produced independent proof leaves or
candidate families.  This hard case should spend substantial effort on upper
semantic planning, middle memory/rule management, candidate-population
maintenance, and exact-vs-approximate strategy before expanding lower proof
work.

## Candidate Score

First compare asymptotic tier.  Inside one tier, compare certified candidates
lexicographically by:

```text
(gateCount, depth, auxiliaryQubits, oracleCalls)
```

## Required Closeout Artifacts

- Lean theorem or explicit proof-DAG contract for the best exact/approximate
  candidate.
- Epsilon-ladder decisions if approximate search opens.
- Qiskit/QASM3 exports only after Lean certification.
- Final completion requires the declared executable acceptance command to pass
  against every declared artifact; Lean closure alone is `post_lean_export`.
- Circuit storyboard and selected-language summary.
- Self-contained ChatGPT Pro prompt if the target is not fully closed.
