---
name: qbe-source-dependency-audit
description: Audit a blocked faithful-paper proof step against the local TeX source, bibliography, and cited-results ledger before assigning more Lean proof search.
argument-hint: "[paper key or task id]"
---

# QBE Source Dependency Audit

Use this when a faithful-paper proof block fails, becomes blocked, or appears
to need a theorem that is not already in Lean.

## Purpose

For faithful paper reproduction, a hard Lean proof is often hard because the
paper used an external theorem, a standard subroutine, or an implicit source
contract.  Do not let lower agents guess those ingredients.  Upper and middle
must classify the missing ingredient before more proof search.

## Local Source Archive

Agents may use local TeX sources from the sibling ARIS-style archive:

```text
../Auto-claude-code-research-in-sleep/paper-sources/
```

For GHL2025, the current local source is:

```text
../Auto-claude-code-research-in-sleep/paper-sources/GHL2025/main.tex
```

These paths are private working references.  Public Markdown, LaTeX, README,
and proof-obligation artifacts must cite stable paper anchors such as arXiv
links, theorem/lemma/equation/figure labels, or bundled paper-note sections.

## Audit Workflow

1. Identify the blocked Lean statement and the exact paper theorem, lemma,
   equation, circuit, or proof paragraph it is meant to reproduce.
2. Read the local TeX source around that anchor and inspect nearby citations.
   If needed, inspect `references.bib` and `main.bbl` for the cited source.
3. Classify the missing ingredient:
   - `internal-paper-step`: the paper proves or states it locally.
   - `external-cited-result`: the paper relies on another paper or named
     subroutine.
   - `classical-lean-lemma`: the missing item is ordinary arithmetic, linear
     algebra, or finite-map reasoning that should be a local Lean lemma.
   - `source-contract-gap`: the paper does not specify enough gate-level
     information to close QBE's stricter oracle contract.
4. Update the conversion window or proof-obligation ledger with the
   classification and the next allowed lower-agent packet.
5. If the ingredient is external or standard, update
   `research-wiki/cited-results/` before lower work depends on it.
6. If the ingredient is a source-contract gap, keep the relevant semantic flags
   false and either request human direction or record a precise contract-only
   extension target.

## Reviewer Rule

Reviewer must reject a lower proof packet that continues tactic search after a
blocked faithful-paper step unless middle has written this audit.  Reviewer
must also reject any external dependency whose cited-results entry lacks a
source, exact statement used, Lean status, or dependent use sites.

## Non-Goals

- Do not add hypotheses to match a proof attempt.
- Do not replace the paper circuit or oracle in faithful mode.
- Do not treat a bibliography entry as a Lean proof.
- Do not cite local absolute paths in public project artifacts.
