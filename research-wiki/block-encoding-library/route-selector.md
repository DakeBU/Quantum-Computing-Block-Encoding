# Block-Encoding Route Selector

Block Encoding asks for a unitary \(U\), normalization \(\alpha>0\), and a
specified clean projector \(\Pi\) such that

\[
\left\|A-\alpha\,\Pi U\Pi^\dagger\right\|\le \varepsilon.
\]

For an exact block encoding, \(\varepsilon=0\). Register order, the clean
ancilla convention, oracle interfaces, and \(\alpha\) are part of the theorem,
not implementation notes.

This page selects a construction route. For the more general question “should
this task be constructible under the stated access model?”, first read
`../construction-methodology/index.md`.

## The main diagnostic

A classically simple matrix is not automatically cheap to block encode. Ask what
representation of \(A\) is available **coherently**:

- positions and values of nonzero entries;
- a short weighted decomposition;
- preparable row/column states;
- a Gram/isometry representation;
- a product, tensor product, sum, or polynomial of already encoded operators;
- reversible formulas for entries or range predicates;
- a purification or density-operator preparation route.

The access model determines which construction theorem is applicable and which
cost is meaningful.

## Route matrix

| Matrix/access structure | First route to retrieve | Core obligations | Typical bottleneck |
| --- | --- | --- | --- |
| unitary/permutation | direct embedding | exact unitary/permutation action | register convention |
| partial permutation / transfer | unitary dilation / routed permutation | clean block + filler unitarity | auxiliary space |
| \(s\)-sparse position + value oracles | sparse-access construction | oracle correctness, normalization, clean projection | oracle/query cost, \(s\) |
| short sum \(A=\sum_j \alpha_j U_j\) | LCU | PREPARE, SELECT, coefficient normalization | \(\sum_j|\alpha_j|\), SELECT cost |
| preparable state pairs | state-pair / Gram construction | preparation correctness, overlap identity | state-preparation cost |
| low-rank factors \(A=LR^\dagger\) | factor/Gram route | factor state preparation + contraction | rank and normalization |
| tensor/product structure | tensor block encodings | factor certificates + register layout | product normalization |
| composition \(A=BC\) | product of block encodings | ancilla composition + error/normalization propagation | \(\alpha_B\alpha_C\), depth |
| polynomial/function of encoded operator | QSVT/QSP consumer | typed block-encoding input + polynomial conditions | degree and approximation error |
| Hermitian target from non-Hermitian data | Hermitian dilation | dilation identity + source encoding | dimension/ancilla overhead |
| density matrix / purification available | purification route | preparation + partial projection | state-preparation cost |
| arithmetic/piecewise matrix entries | reversible arithmetic + controlled rotations/routing | exact predicate/value action, uncompute, precision | comparator/addition/value arithmetic |

## Construction patterns

### Sparse access

A statement such as “\(A\) is sparse” is incomplete for circuit synthesis. The
contract should identify coherent position and value interfaces, for example an
oracle that maps a row and sparse slot to a column label and another that
returns or loads the corresponding value. The block-encoding proof must consume
those exact interfaces.

### LCU

For

\[
A=\sum_{j=0}^{m-1} \alpha_j U_j,
\]

LCU is attractive when the index state and SELECT operation are cheaper than a
direct entrywise construction. The coefficient normalization contributes to
\(\alpha\), so a smaller gate count with a much worse normalization is not an
unqualified improvement.

### State-pair / Gram routes

If coherent maps prepare states whose overlaps reproduce entries of \(A\), then
the matrix may be encoded through an isometry/Gram identity. This moves the
hard part into State Preparation, so the dependency should be visible in the
proof graph rather than hidden inside one block-encoding theorem.

### Arithmetic structure

Toeplitz-like shifts, interval masks, banded patterns, finite-difference
operators, and piecewise coefficients often need the same reversible arithmetic:
comparison, increment/decrement, modular addition, and clean flag management.
Those are shared technical memory cards and should be proven once at the
permutation layer, refined once to primitive gates, and reused by SP and BE.

## What “likely constructible” means here

The selector is a planner rule, not a complete mathematical classification.
ASPBE treats a route as promising when the required representation can be
coherently evaluated with explicit normalization, precision, and uncomputation.
A failed route may mean the **access model** is weak, not that the matrix admits
no efficient block encoding under another representation.

## Comparing candidates

Only compare candidates under the same target and access assumptions. Track at
least

\[
(\text{queries},\;\text{gates},\;\text{depth},\;\text{ancillas},\;
\alpha,\;\varepsilon),
\]

and add T/Toffoli/T-depth when the primitive basis makes those meaningful.
“Optimal” must name its model and lower bound; otherwise use “best certified in
this search tier” or “Pareto-better under the frozen contract.”
