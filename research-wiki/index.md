# QBE Research Wiki

Persistent ASPBE project knowledge for State Preparation, Block Encoding,
reusable circuit constructions, papers, proof evidence, and formalization gaps.

## Retrieval order for agents and readers

1. **`construction-methodology/`** — decide whether the stated SP/BE task has a
   plausible constructive representation under its exact query/access model and
   identify the likely bottleneck before circuit search.
2. **`state-preparation-library/`** — State Preparation routes, including dense,
   structured, sparse, arithmetic, and paper-grounded preparation patterns.
3. **`block-encoding-library/`** — Block Encoding routes for partial
   permutations, LCU, product/tensor arithmetic, sparse access, Gram/state-pair
   constructions, dilation, QSVT consumers, and structured operators.
4. **`technical-lemmas/`** — reusable proof/circuit memory cards and external
   technical results consumed by active proof tasks.
5. **`paper-contributions/` and `cited-results/`** — what a source paper proves,
   what ASPBE has reproduced, and what remains source-only.
6. **`graph/`** — evidence-preserving graph analysis. In particular,
   `graph/library-factorization-profile.md` defines the long-term structural
   sharing metrics used on the public Underlying Lean Graph page. The current
   numbers are explicitly a module-import proxy, not theorem-level proof
   compression.
7. **`retrieval-index/`** — compact machine-readable summaries for upper/middle
   agents.

## Evidence discipline

A construction heuristic, a kernel-checked semantic theorem, an executable
finite circuit, a source-paper asymptotic theorem, and an optimality claim are
different evidence classes. Memory retrieval must preserve those boundaries
rather than flatten them into a single “reproduced” label.

Graph metrics obey the same rule: every snapshot records its evidence layer and
target-selection policy. A smaller graph or larger fan-out is never, by itself,
a proof of better mathematics.
