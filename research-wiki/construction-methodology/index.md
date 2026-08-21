# Constructability and Construction-Route Guide

This directory is the **decision layer** of ASPBE memory. It does not replace the
State Preparation, Block Encoding, or technical-lemma libraries. Instead, it
answers the question that should be asked *before* circuit search begins:

> Under the stated access model, is this State Preparation or Block Encoding
> task structurally constructible, which route should be tried first, and which
> missing ingredient is likely to dominate the cost?

The answer is always evidence-scoped. ASPBE distinguishes:

1. **kernel-verified rule** — a reusable Lean theorem already closes the stated
   local transformation;
2. **source-backed theorem** — a paper proves the stated construction or bound,
   but ASPBE may not yet reproduce the whole result in Lean;
3. **planner heuristic** — a route-selection rule inferred from repeated proof
   structure and successful cases;
4. **research conjecture** — a possible higher-level principle that is not used
   as a theorem or pruning rule.

## The common test: coherent computability, normalization, uncomputation

Classical matrix structure alone is not enough. A useful first approximation is
that a quantum construction becomes plausible when the structure needed by the
algorithm can be

\[
\text{computed coherently} \;\longrightarrow\; \text{used with controlled precision}
\;\longrightarrow\; \text{uncomputed},
\]

while normalization and ancilla restoration remain explicit obligations.

For a target state

\[
|\psi\rangle=\frac{1}{\|a\|_2}\sum_x a_x|x\rangle,
\]

ask whether ASPBE can coherently obtain enough information about the amplitudes,
partial masses, phases, sparse support, or product factors to synthesize the
required rotations. For a block encoding of \(A\), ask whether ASPBE has a
coherent representation of entries, nonzero positions, LCU coefficients,
row/column states, Gram factors, or already-certified block encodings from which
\(A\) can be composed.

This is a **route-selection principle**, not a completeness theorem. Failure of
one access model does not prove that no quantum circuit exists.

## Decision flow

### 1. Freeze the mathematical contract

Record the target, register order, allowed oracle/query interfaces, clean/dirty
ancillas, normalization convention, error tolerance, and resource priority.
Never compare circuits before these are fixed.

### 2. Identify a constructive representation

State Preparation candidates are organized in
`../state-preparation-library/route-selector.md`. Block Encoding candidates are
organized in `../block-encoding-library/route-selector.md`.

Typical reusable representations are:

| Structure available coherently | First route to retrieve |
| --- | --- |
| tensor/product state factors | independent local preparation |
| computable prefix/interval masses | recursive split / interval-tree preparation |
| explicit small dense vector | exact unitary completion / UCRY |
| sparse support + values | sparse/pruned preparation |
| coherent lookup table | SELECT/SWAP-style loading |
| sparse matrix position + value oracles | sparse-access block encoding |
| short weighted operator sum | LCU |
| preparable row/column states or Gram factors | state-pair / Gram route |
| product or composition of known operators | block-encoding product/composition |
| arithmetic predicate / interval structure | reversible comparator/incrementer memory card |

### 3. Locate the real bottleneck

The target matrix may be simple while the access implementation is expensive.
The planner therefore tracks separately

\[
\alpha,\qquad \varepsilon,\qquad \kappa,\qquad
\text{data loading},\qquad \text{reversible arithmetic},\qquad
\text{ancilla restoration}.
\]

For State Preparation, the corresponding bottlenecks include normalization,
partial-mass evaluation, rotation precision, phase loading, and workspace
uncomputation.

### 4. Retrieve technical memory cards

Reusable low-level facts live under `../technical-lemmas/`. A memory card is
admitted only when its evidence boundary is explicit: semantic correctness,
primitive compilation, resource theorem, and source-paper optimality are
separate fields.

The comparator/incrementer line is particularly important because coherent
interval tests, prefix trees, sparse-address routing, and arithmetic matrix
access repeatedly reduce to the same reversible primitives.

### 5. Compare only inside one semantic fibre

Resource search begins only after candidates implement the same contract.
Useful resource vectors include query count, primitive gate count, Toffoli/T
count, depth/T-depth, clean/dirty ancillas, normalization \(\alpha\), and error
\(\varepsilon\). A smaller number under a changed access model is not an
improvement of the original construction.

## What this guide does not claim

ASPBE does **not** currently claim a complete classification of constructible SP
or BE tasks, an approximation ratio to an unknown globally optimal circuit, or a
proof that the above decision tree is necessary. The purpose of the formal
proof graph is precisely to turn these recurring construction patterns into
increasingly sharp, auditable mathematical statements over time.
