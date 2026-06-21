# Task: QBE-OP-CUBIC-DIAGONAL-CLEAN-001

Kind: `operatorBlockEncoding`
Mode: `exploratoryConstruction`
Status: `active`

## Clean-Start Rule

This task is a clean harness-comparison benchmark. Agents must not use previous cubic diagonal attempts, previous ChatGPT Pro suggestions, old candidate names, or old run memory. Use only this task packet, the current Lean environment, and standard ABEIS rules.

## Raw User Problem

假设 `n` 为正整数，是量子比特数。构造一个 oracle/operator

$$
O_n = \sum_{j=0}^{2^n-1} f(x_j) |j\rangle\langle j|,
\qquad f(x)=x^3,
\qquad x_j = j/2^n.
$$

请构造这个 operator `O_n` 的 block-encoding `U_O`。

## Lean-Checkable Target

For `N = 2^n`, define the diagonal operator

$$
D_n[j,j] = (j/N)^3, \qquad D_n[j,k] = 0 \text{ for } j \ne k.
$$

The exact normalizer target is initially `alpha = 1`, since `0 <= (j/2^n)^3 < 1` for all grid points.

Default adaptive policy for this hard benchmark:

- spend only a short exact-search patience budget before broad expansion;
- with the default `sleep-run --exact-stall-cycles 2`, if no Lean-certified exact candidate exists after that budget and upper/reviewer memory records stagnation or a blocked proof route, open Scenario 2 approximate-BE search;
- initialize Scenario 2 at `epsilon = 1e-10`;
- if no candidate can meet `1e-10` within the next bounded generation budget, upper may relax epsilon, but every relaxation must be recorded as an explicit epsilon-ladder decision in the memory digest, candidate population, selected-language summary, and Pro prompt.

## Resource Order

Inside the same asymptotic tier, rank Lean-certified candidates lexicographically by:

1. gate count,
2. depth,
3. auxiliary qubits,
4. unresolved oracle calls.

Asymptotic tier must be recorded before constant-factor comparisons. Only Lean-certified exact or approximate candidates may be plotted as achieved solutions.

## Adaptive Capacity Rule

There is no user-visible easy/hard preset. Upper reads the logs and may increase upper, middle, or lower parallelism when the bottleneck justifies it:

- increase upper capacity for semantic-tier choice, exact-vs-approx strategy, or candidate-family strategy;
- increase middle capacity for Lean/natural-language translation, stale memory, or candidate-population bookkeeping;
- increase lower capacity when several independent proof leaves or candidate families are ready.

Every increase receives a fixed generation budget and must report whether it improved the certified population, finite verifier population, or insight pool.

## Required Closeout Artifacts

If unresolved, write a selected-language summary and a self-contained ChatGPT Pro prompt. If resolved or partially resolved, write:

- a step-by-step LaTeX proof note for the best Lean-certified exact/approximate candidate;
- certified exact/approximate evolution curves;
- circuit storyboards for Lean-certified candidates only;
- Qiskit export and finite executable checks for each exported certified construction.
