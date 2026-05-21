---
name: qbe-math-writing
description: Write and review QBE Markdown/LaTeX proof maps with concise mathematical exposition, explicit definitions before theorem statements, precise citations, and no hidden assumptions.
argument-hint: "[Markdown or LaTeX file]"
---

# QBE Math Writing

Use this when editing or reviewing `conversion-windows/*.md`,
`paper-notes/*.tex`, `proof-obligations/*.md`, README proof sketches, or
agent-facing mathematical handoffs.

This skill is a compact project adaptation of Bjorn Poonen's mathematical
writing advice in the local source file `Math Writing Tips.pdf`.

## Core Rules

1. State definitions before the theorem or claim that uses them.
2. Keep theorem statements short.  Move notation, hypotheses, and setup into
   preceding definitions or paragraphs.
3. Make every justification explicit.  If a claim follows from a lemma, a
   paper equation, a Lean declaration, or a previous line, name that source.
4. Do not write "clearly", "obviously", or similar phrases.  Give the reason
   or create a proof obligation.
5. Make quantifiers unambiguous: write "for all", "there exists", "for fixed",
   or "for each"; do not rely on trailing informal clauses.
6. When a proof uses hypotheses, say where they enter.
7. Break long arguments into named lemmas, obligations, or bullets so that the
   reader never has to remember many moving parts at once.
8. Avoid "where ..." clauses that define notation after use.  Introduce the
   symbol first, then use it.
9. Do not start a sentence with a mathematical symbol.
10. Avoid blackboard abbreviations such as "WLOG", "iff", and "s.t." in prose.

## QBE-Specific Rules

1. In faithful-paper mode, do not add hypotheses, side conditions, replacement
   circuits, or new oracle assumptions.  If the paper step is missing in Lean,
   record a proof obligation instead.
2. In exploratory mode, do not weaken the target or add assumptions to make a
   candidate work.  Reject the candidate or record the exact remaining
   obstruction.
3. Lean names, paper symbols, normalizers, dimensions, register layouts, and
   resource claims must be synchronized across Lean, Markdown, and LaTeX.
4. Every paper citation should be precise enough for a reader to find the
   statement: use equation, lemma, theorem, page, section, line range, arXiv
   version/date, or URL as available.
5. If Lean uses an approximation, symbolic placeholder, diagonal stand-in, or
   unproved semantic record, say so plainly and keep `proved := false`.
6. Keep reusable definitions in shared files and reference them.  Do not
   duplicate the same definition in multiple notes or Lean modules.
7. When a proof uses repeated local arguments, present them as reusable blocks
   or lemmas.  The motivation is the hierarchical-prover separation of
   Sonoda--Akiyama--Uezato, arXiv:2602.10512v2: a shared proof DAG can avoid
   repeatedly learning and rediscovering the same subproof.

## Markdown Rules

1. Use `$...$` for inline math and `$$...$$` for display math.
2. Do not use `\(...\)` or `\[...\]` in Markdown files.
3. Prefer tables for symbol maps and obligation ledgers; prefer short prose for
   proof explanations.
4. Put definitions and notation before claim statements.
5. When documenting a failed attempt, distinguish Lean failure, paper-gap
   failure, and search failure.

## LaTeX Rules

1. Definitions must appear before theorem statements.
2. Use `\colon` for maps, such as `$f \colon X \to Y$`.
3. Punctuate displayed equations as part of the surrounding sentence.
4. Use `align*` or a table when each equality in a chain has a different
   reason.
5. Use `\DeclareMathOperator`-style operators in reusable paper notes when the
   operator recurs.

## DAG-Aware Writing

For proof maps and paper notes, prefer the following order:

1. Define the reusable objects and interfaces.
2. State the local lemma or proof block.
3. State where the block is reused.
4. State the final theorem or block-encoding claim.

Avoid repeating the same proof paragraph for each reuse site.  Refer to the
named block instead, and add a proof obligation if the block is not yet proved
in Lean.

## Reviewer Checklist

- Are all definitions introduced before use?
- Are all theorem statements short enough to read without scanning later text?
- Does every nontrivial claim cite a paper equation, Lean declaration, or proof
  obligation?
- Are any assumptions added beyond the paper or the stated Lean target?
- Is there duplicated notation or duplicated definitions that should be
  referenced instead?
- Is a repeated local proof flattened in prose when it should be a named Lean
  lemma or proof-DAG block?
- Do Markdown math delimiters follow QBE style?
- Is the prose readable as mathematics rather than a changelog?
