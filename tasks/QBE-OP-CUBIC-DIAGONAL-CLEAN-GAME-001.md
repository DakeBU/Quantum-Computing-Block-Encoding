# Cubic diagonal oracle block encoding, clean-start Game Harness

Task id: `QBE-OP-CUBIC-DIAGONAL-CLEAN-GAME-001`
Kind: `operatorBlockEncoding`
Mode: `exploratoryConstruction`
Status: `active`
Created: `2026-06-28`

## Clean-Start Rule

This is the Game Harness arm for the cubic diagonal benchmark.  Agents must not
use previous cubic diagonal attempts, previous ChatGPT Pro suggestions, old
candidate names, or old run memory.  They may use the current compiled ABEIS
library, Mathlib, standard quantum-computing facts, and the block-encoding
memory cards.

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
D_n[j,j] = (j/N)^3, \qquad D_n[j,k] = 0 \text{ for } j \ne k.
$$

The exact target starts with `alpha = 1`.  If exact search stalls under the
configured exact patience budget, the Game Council must open Scenario 2
approximate search at `epsilon = 1e-10` and record every epsilon-ladder
relaxation.

## Harness Profile

The Lean Hierarchical Team focuses on direct Lean constructions and proof
leaves.  The Natural-Language Hierarchical Team focuses on construction
families, QSVT/LCU/sparse-oracle intuitions, and proof sketches.  The Game
Council compares the teams, moves useful insight between them, and expands
upper/middle/lower capacity only when reviewer feedback shows a bottleneck.

## Candidate Score

First compare asymptotic tier.  Inside one tier, compare Lean-certified exact
or approximate candidates lexicographically by:

```text
(gateCount, depth, auxiliaryQubits, oracleCalls)
```

Only Lean-certified candidates may appear as achieved points in the final
evolution curve.

## Required Closeout Artifacts

- Lean theorem or explicit proof-DAG contract for the best exact/approximate
  candidate.
- Epsilon-ladder decisions if approximate search opens.
- Qiskit/QASM3 exports only after Lean certification.
- Circuit storyboard and selected-language summary.
- Self-contained ChatGPT Pro prompt if the target is not fully closed.

