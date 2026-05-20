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
- Reviewer agents check Lean build status, oracle assumptions, resources, and
  citations.
- Documentation-writing agents use `.agents/skills/qbe-math-writing/SKILL.md`:
  definitions before theorem statements, short claims, precise justifications,
  and no hidden assumptions.

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
