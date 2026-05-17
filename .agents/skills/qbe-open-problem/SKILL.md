---
name: qbe-open-problem
description: Propose or refine a new open block-encoding/oracle construction problem from current Lean artifacts and literature gaps.
argument-hint: "[gap or target oracle]"
---

# QBE Open Problem

Use this when a paper assumes an oracle but does not provide a gate-level
construction, or when current Lean artifacts expose a reusable construction gap.

## Required Output

Add or update an entry in `QuantumBlockEncoding/OpenProblems.lean` with:

- stable id,
- short title,
- precise statement,
- Lean-checkable acceptance test,
- references.

Also add a Markdown expansion in `docs/open_problems.md` if the problem is
important enough for human readers.

## Acceptance

- The new problem has a concrete target matrix/oracle/circuit condition.
- The acceptance test is not "write a proof"; it states what Lean artifact
  would certify success.
- `python3 tools/qbe.py check` succeeds.
