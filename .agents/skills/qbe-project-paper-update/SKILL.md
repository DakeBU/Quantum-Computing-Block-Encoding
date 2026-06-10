---
name: qbe-project-paper-update
description: Maintain the ABEIS technical report from Lean/proof-cycle evidence without overclaiming theorem status.
argument-hint: "[task id or report path]"
---

# QBE Project Paper Update

Use this skill at the end of every multi-hour active proof cycle, or whenever
`tools/qbe.py project-article-update` reports a manuscript-facing delta.

The goal is not prose polish.  The goal is to keep the technical report aligned
with what the Lean project actually proves, what the paper-source audit says,
and what remains an explicit obligation.

## Similar Pattern

This skill adapts useful writing-loop discipline from the ARIS paper-writing
workflow:

- section-by-section writing rather than undirected polishing;
- claim-to-evidence checking;
- figure and narrative updates tied to real artifacts;
- review independence and explicit unsupported-claim handling.

QBE changes the evidence standard.  In this project, evidence is a Lean
declaration, a passing Lean gate, a source-paper/citation row, a proof-attempt
record, or an explicit proof obligation.  Agent confidence is not evidence.

## Inputs

Read these before changing the project paper:

1. `runs/<run-id>/article_update.md`
2. `runs/<run-id>/zh_summary.md`
3. `proof-blueprints/<task-id>.md`
4. `conversion-windows/<task-id>.md`
5. `proof-obligations/<task-id>.md`
6. relevant `paper-notes/` Markdown/LaTeX exports
7. relevant `research-wiki/cited-results/` entries
8. the ABEIS technical report under `../Auto_Proof_Papers/ABEIS`

## Cadence

Every executed `sleep-run` cycle should produce:

- `runs/<run-id>/article_update.md`
- `runs/<run-id>/article_update.tex`
- `paper-notes/project-paper/cycle-updates/<run-id>.md`
- `paper-notes/project-paper/cycle-updates/<run-id>.tex`
- `paper-notes/project-paper/cycle-updates/latest.md`
- `paper-notes/project-paper/cycle-updates/latest.tex`

If the external technical-report directory exists, the latest generated status
should also be mirrored to:

- `../Auto_Proof_Papers/ABEIS/appendix/generated_cycle_status.tex`

Manual article edits should be less frequent.  Update the main report only when
the cycle adds a stable system lesson, a stable proof status change, or a
figure/table update that improves human understanding.

## Allowed Article Updates

Good updates:

- tighten the system description after a harness rule has actually changed;
- add an evidence paragraph explaining a stable run-log lesson;
- update the case-study status after a Lean theorem, contract correction, or
  source audit is accepted;
- add a figure for a stable process concept, proof-DAG frontier, or
  Lean/Markdown/LaTeX conversion mechanism;
- update the generated status appendix with current `sorry` and obligation
  status.

Bad updates:

- claiming the Guseynov--Huang--Liu reproduction is complete while final
  theorem-facing obligations remain;
- presenting a cited external primitive as formalized without a named Lean
  declaration and passing gate;
- rewriting the paper around a failed proof route as if it were a positive
  theorem;
- adding a new scientific claim because it sounds like the system should do it;
- hiding a proof gap in vague prose.

## Claim-to-Evidence Rules

For every new or strengthened paper claim, record at least one support:

| Claim type | Required support |
|---|---|
| Lean theorem/proof status | Lean declaration name and passing gate or honest `sorry`/obligation status |
| Source-paper reproduction status | paper anchor plus conversion-window/proof-obligation row |
| External primitive | cited-results row with exact source and status |
| Harness design change | changed command/skill/doc file plus cycle update |
| Empirical run lesson | run log, trial summary, proof-attempt record, or reviewer finding |
| Figure update | source artifact or stable process rule represented by the figure |

If no support exists, do not write the claim into the report.  Add it to a
todo list or proof obligation instead.

## Writing Rules

- Keep the report readable for non-quantum and non-agent readers.
- Define terms before using them in theorem-like statements.
- Use `\citep{...}` or `\citet{...}` for every named paper, system, or
  repository discussed in the report.
- Do not write local absolute paths into article source.
- Do not use `GHL` as unexplained shorthand in the report.  Prefer
  "the first case study" after the full cited name is introduced.
- Keep generated status text separate from polished narrative.  Generated
  status can be overwritten every cycle; polished sections should change only
  after stable evidence appears.

## Reviewer Checklist

- Does the article update match `article_update.md` and `zh_summary.md`?
- Does every strengthened claim have Lean/source/citation/run evidence?
- Does the generated status appendix still say the case study is incomplete if
  theorem-facing `sorry` or root obligations remain?
- Did the update avoid local absolute paths?
- Did the update preserve citation discipline?
- Did the update avoid spending proof-worker effort on prose polish?
