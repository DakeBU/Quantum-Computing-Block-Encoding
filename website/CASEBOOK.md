# QuantumComputinglib casebook contract

The generated Example Cases are teaching pages first and proof dashboards second.
Every public case must preserve the following reading order:

1. explain why a quantum algorithm needs the state, operator, or access model;
2. explain the circuit registers and the left-to-right flow before presenting raw gate data;
3. state the mathematical theorem/contract explicitly;
4. give a human-readable proof story in dependency order;
5. expose the matching compiled Lean declarations behind an optional disclosure;
6. only after correctness, state any resource-improvement theorem and its comparison convention;
7. keep transcription choices, backend conventions, and source-fidelity audits in an advanced optional panel.

For source-paper cases, source theorem identifiers and displayed mathematical formulas must be distinguished from QuantumComputinglib paraphrase. Short direct quotations must be attributed and remain short; surrounding explanation is original site prose.

The Robin/GHL case is the reference implementation of this policy. It also teaches the distinction among state preparation, a digital matrix-entry query oracle, and a block encoding before presenting Theorems 3 and 4 or the evolved XOR four-slot circuit.

The machine-readable teaching records live in `website/case-teaching.json`. The rendering and regression checks live in `website/scripts/enrich_casebook.py`, `website/scripts/polish_casebook.py`, and their tests. The normal site build must fail if a named Lean checkpoint is absent from the declaration inventory. Public navigation fragments introduced by the enrichment layer must also be unique; source-fidelity disclosures retain one stable fragment target rather than duplicating the same `id` on nested elements.
