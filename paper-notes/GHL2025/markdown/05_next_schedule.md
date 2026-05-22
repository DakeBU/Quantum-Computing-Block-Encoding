# Suggested Schedule After This Export

For the next runs, use fewer reviewer agent calls and keep the Lean build gate.

Recommended inner loop for a 5-hour batch:

- Run upper and middle every cycle.
- Run one lower agent per cycle.
- Skip reviewer agent for ordinary proof-DAG continuation cycles.
- Keep `python3 tools/qbe.py check` after each cycle.
- Run one full reviewer/proof-export cycle at the end of the batch.

Reason: the current work is mostly local Lean proof-DAG closure.  Full reviewer
LLM calls after every small lemma cost many tokens and have diminishing returns.
The build gate plus forbidden-pattern grep catches most immediate regressions.

Use full reviewer cycles when:

- a proof flag changes from `false` to `true`;
- an oracle contract changes;
- a cited result changes status;
- a final block-extraction or unitarity claim is promoted;
- Markdown/LaTeX proof export is updated.
