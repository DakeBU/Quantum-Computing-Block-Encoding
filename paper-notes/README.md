# Paper Notes

Optional LaTeX notes for paper-specific theorem statements and derivations.

These files are not the source of truth.  The checked source of truth is always
the Lean code under `QuantumBlockEncoding/`.

## Project Paper

The top-level article for this repository is planned as:

```text
Auto-Lean-in-Sleep: Block Encoding for Quantum Computing
```

Paper-specific exports, including the GHL2025 one-term Robin proof notes, are
case-study material for appendices of that article.  They should not evolve as
standalone polished papers during Lean-heavy proof runs.

Cadence:

- Lean-heavy runs update only the minimal proof map needed for correctness.
- The final audit of a multi-hour run may update appendix pointers and figure
  todos.
- Polished article writing and figure production happen in separate writing
  batches after the Lean proof state stabilizes.

Style references for later writing:

- `YuanheZ/lean-stat-learning-theory`: Lean theorem-paper organization and
  appendix style.
- `wanshuiyin/Auto-claude-code-research-in-sleep` and its ARIS paper:
  automation-system exposition and figure-rich presentation.
- `Trinkle23897/learning-beyond-gradients`: hierarchical iteration and memory
  loop framing.
