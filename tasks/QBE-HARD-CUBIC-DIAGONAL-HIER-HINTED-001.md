# Hard case cubic diagonal oracle, hinted isolated Hierarchical Harness

Task id: `QBE-HARD-CUBIC-DIAGONAL-HIER-HINTED-001`
Kind: `operatorBlockEncoding`
Mode: `exploratoryConstruction`
Status: `active`
Created: `2026-06-28`

## Clean-Start Rule

This is the hinted hard-case arm.  Agents must not use previous cubic diagonal
attempts, old candidate names, or old run memory.  They may use the current
compiled ABEIS library, Mathlib, standard quantum-computing facts, and the
block-encoding memory/skill cards.

## Raw User Problem

假设 `n` 为正整数，是量子比特数。构造一个 oracle/operator

$$
O_n = \sum_{j=0}^{2^n-1} f(x_j) |j\rangle\langle j|,
\qquad f(x)=x^3,
\qquad x_j = j/2^n.
$$

请构造这个 operator `O_n` 的 block-encoding `U_O`。

## Human Hint

The human expert suggests trying the route:

```text
first construct a block encoding of O_0 = sum_j x_j |j><j|,
then use QSVT or another polynomial-transform route to obtain x^3.
```

The hint is an input to the harness, not a proof.  Upper may use it as a
candidate-family seed, middle must translate it into proof-DAG contracts, and
reviewer must reject any route that treats QSVT or a polynomial transform as
Lean-certified before the necessary contract is named and audited.

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
justifies increasing upper, middle, or lower parallelism.  Because the hint is
semantic, capacity should initially favor upper/middle planning and proof-DAG
translation before expanding lower implementation work.

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
- Circuit storyboard and selected-language summary.
- Self-contained ChatGPT Pro prompt if the target is not fully closed.

