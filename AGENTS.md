# Agent Guide for Quantum Block Encoding

This repository is a Lean-first proof and circuit-construction project.

## Mission

Replace abstract quantum oracle assumptions with concrete circuit matrices, then
prove in Lean that the circuit satisfies the requested block-encoding or oracle
condition.

## Non-Negotiable Gate

Every agent run must finish with:

```bash
lake build && lake build Tests
```

If the gate fails, the task is not done.

## Operating Loop

1. Pick one task from `tasks/`, `QuantumBlockEncoding/Literature.lean`, or
   `QuantumBlockEncoding/OpenProblems.lean`.
2. Create or update a conversion window in `conversion-windows/` when moving
   between Markdown, LaTeX, and Lean.
3. If working in an automated cycle, read `runs/<run-id>/dialogue.md` and append
   a handoff before stopping.
4. Keep the Lean source of truth in `QuantumBlockEncoding/`.
5. Keep human-readable derivations in `docs/` or `paper-notes/`.
6. Run the build gate.
7. Log the attempt with `tools/qbe.py trial-log`.
8. Update task status only after the build gate succeeds.

## Project Commands

```bash
python3 tools/qbe.py status
python3 tools/qbe.py list-literature
python3 tools/qbe.py new-task QBE-AUTO-004 --title "Formalize sparse access oracle"
python3 tools/qbe.py conversion-window QBE-AUTO-004 --title "Sparse access oracle"
python3 tools/qbe.py run-cycle QBE-AUTO-001 --cycle 1 --lower-count 2
python3 tools/qbe.py sleep-run QBE-AUTO-001 --cycles 8 --lower-count 3 --dry-run
python3 tools/qbe.py agent-note latest --role lower --message "handoff text"
python3 tools/qbe.py trial-log --task QBE-AUTO-001 --role lower --kind attempt --status blocked --notes "reason"
python3 tools/qbe.py trial-summary
```

## Role Protocol

- Upper agents choose the next objective and compress trial memory.
- Middle agents maintain conversion windows and proof obligations.
- Lower agents attempt one construction or proof repair each.
- Natural-language lower agents should write controlled proof packets rather
  than free-form essays: target, registers, assumptions, candidate unitary,
  clean-block statement, local lemmas, external contracts, resource tuple, and
  typed failure class.  Lean lower agents may work directly in Lean in parallel;
  the controlled packet is a shared exchange format for natural-language ideas,
  Lean-facing leaves, and human proof exports, not a required first stage.
  This follows a similar CNL-diagnostic discipline to Visored while keeping
  Lean as the acceptance gate.
- Reviewer agents check Lean build status, oracle assumptions, resources, and
  citations.
- Documentation-writing agents use `.agents/skills/qbe-math-writing/SKILL.md`:
  definitions before theorem statements, short claims, precise justifications,
  and no hidden assumptions.
- Agents should use `.agents/skills/qbe-hierarchical-proof-dag/SKILL.md` when
  a proof repeats local work.  Promote repeated bit arithmetic, matrix-index
  calculations, projection lemmas, and gate obligations to reusable Lean blocks
  instead of flattening them into repeated scripts.
- Upper and middle agents should use
  `.agents/skills/qbe-block-encoding-library/SKILL.md` before proposing a new
  block-encoding route.  Route the target through the shared memory cards in
  `research-wiki/block-encoding-library/` first, then assign lower agents a
  small proof-DAG leaf.  Typical first routes are partial permutation, passive
  tensor register, LCU, product/tensor arithmetic, sparse-access Gram
  construction, density/purification, dilation fallback, or QSVT consumer
  contract.

The shared conversation board is `runs/<run-id>/dialogue.md`; persistent memory
is `runs/trials.jsonl` plus `runs/trials_summary.csv`.

## Review Discipline

- Do not invent citations.  Add unknown papers as candidates, then verify.
- Do not hide a mathematical gap with prose.  Turn it into a proof obligation.
- In faithful paper-reproduction mode, do not add hypotheses, side conditions,
  replacement circuits, or easier theorem variants.
- Prefer referencing existing Lean declarations and notation tables over
  duplicating definitions across files.
- Do not mark a planned paper as formalized until the corresponding Lean
  declarations and tests compile.
- For new open problems, include an acceptance test precise enough that Lean can
  eventually check it.

## Lean-QuantumInfo Relationship

Use Lean-QuantumInfo as a style reference for finite-dimensional quantum
formalization.  Do not treat it as the project direction.  This project is about
gate-level oracle realization and block-encoding certificates.
