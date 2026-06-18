---
name: qbe-proof-export
description: Export accepted Lean proof blocks into human-readable Markdown during proof work and closeout LaTeX proof notes for user manuscripts.
argument-hint: "[task id or paper key]"
---

# QBE Proof Export

Use this at the end of a multi-hour batch, at convergence closeout, or when the
user asks for human-readable proof documents.  During ordinary inner cycles,
prefer concise Markdown/natural-language proof maps; LaTeX is a closeout
artifact.

## Purpose

Lean is the source of truth, but every accepted proof block must also have a
human-readable proof map.  Inner-cycle maps explain what Lean proved, what
failed, and what the next Lean task should be.  Closeout LaTeX is not a
changelog; it is a mathematical note that states definitions before theorems,
names the Lean declaration, and explains the proof without adding assumptions.

## Required Artifacts

For every active task, maintain:

- `paper-notes/problem-exports/<task-id>/latest.tex`
- `paper-notes/problem-exports/<task-id>/<run-id>.tex`

For paper key `GHL2025`, paper-benchmark exports may additionally maintain:

- `paper-notes/GHL2025/markdown/*.md`
- `paper-notes/GHL2025/latex/main.tex`
- `paper-notes/GHL2025/latex/sections/*.tex`

The LaTeX master file must compile in Overleaf with ordinary packages such as
`amsmath`, `amssymb`, `mathtools`, `hyperref`, and `longtable`.

## Cadence

Do not export LaTeX after every small lower-agent proof.  Export LaTeX once per
6h/convergence closeout, or when a major proof block is accepted and the user
asks for an immediate proof note.  This saves tokens while still keeping humans
able to audit progress through inner-cycle Markdown/natural-language maps.

## Export Rule

For each accepted Lean proof block, include:

1. Paper anchor and Lean declaration name.
2. Definitions used in the statement.
3. The exact theorem statement in mathematical notation.
4. Proof explanation matching the Lean proof route.
5. Dependencies on earlier exported proof blocks.
6. Remaining obligations that are not proved.

Do not label an obligation as proved unless the Lean declaration exists and the
project build gate passed after it was added.

## Review Rule

Reviewer must compare the proof export against:

- `QuantumBlockEncoding/*.lean`
- `Tests/Basic.lean`
- `conversion-windows/*.md`
- `proof-obligations/*.md`
- `research-wiki/cited-results/*.md`

If the export describes a stronger theorem than Lean proves, mark it blocking.
