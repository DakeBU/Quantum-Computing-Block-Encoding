# ChatGPT Pro Post-Cycle Prompt Policy

Every completed long ABEIS loop must leave two human-facing artifacts:

- `paper-notes/GHL2025/markdown/cycle-summaries/latest.md`: Chinese status for
  humans, with source-paper anchors and the reason each remaining Lean proof is
  still open.
- `runs/pro-prompts/QBE-AUTO-002-latest.md`: a self-contained prompt that can be
  pasted into ChatGPT Pro when the local agents did not close the target.

The Pro prompt assumes ChatGPT Pro cannot read local files.  It must therefore
include public paper links, the current theorem target, open GHL contribution
obligations, open external technical lemmas, recent verifier feedback, and the
exact kind of answer needed next.  Local file paths and Lean names may appear
only as labels for patching this repository later.

For faithful-paper mode, the prompt must say explicitly that Pro may not add
assumptions, change the oracle contract, reorder the circuit, or replace the
paper construction.  For exploratory mode, it must first state the acceptance
predicate and Lean-checkable target before asking for new constructions.

Manual regeneration:

```bash
python3 tools/qbe.py cycle-pro-prompt QBE-AUTO-002 --run-id latest --cycle <N>
```
