# QBE Research Wiki

Persistent ASPBE project knowledge for State Preparation, Block Encoding,
reusable circuit constructions, papers, proof evidence, and formalization gaps.

## Retrieval order for agents and readers

1. **`construction-methodology/`** — decide whether the stated SP/BE task has a
   plausible constructive representation under its exact query/access model,
   identify the likely bottleneck, and choose which route library to retrieve.
2. **`state-preparation-library/`** — State Preparation routes, including dense,
   structured, sparse, arithmetic, and paper-grounded preparation patterns.
3. **`block-encoding-library/`** — Block Encoding routes for partial
   permutations, LCU, product/tensor arithmetic, sparse access, Gram/state-pair
   constructions, dilation, QSVT consumers, and structured operators.
4. **`technical-lemmas/`** — reusable proof/circuit memory cards such as
   state-action bridges, register conversions, sparse-access primitives, and
   comparator/incrementer-style reversible arithmetic.
5. **`paper-contributions/` and `cited-results/`** — what a source paper proves,
   what ASPBE has reproduced, and what remains source-only.
6. **`graph/`** — proof-network design and evidence-preserving graph analysis.
   The current public graph is not yet a theorem-level proof-term dependency
   graph; see `graph/proof-graph-compression.md` before proposing compression.
7. **`retrieval-index/`** — compact machine-readable summaries for upper/middle
   agents.

## Evidence discipline

A construction heuristic, a kernel-checked semantic theorem, an executable
finite circuit, a source-paper asymptotic theorem, and an optimality claim are
five different evidence classes. Memory retrieval must preserve those
boundaries rather than flatten them into a single “reproduced” label.
