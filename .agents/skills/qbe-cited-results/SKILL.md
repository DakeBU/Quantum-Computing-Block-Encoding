---
name: qbe-cited-results
description: Track external theorem, lemma, circuit, arithmetic, and classical results that a QBE paper uses, without overstating their Lean status.
argument-hint: "[paper key or task id]"
---

# QBE Cited Results

Use this when a paper proof, oracle construction, or reviewer note invokes a
result from another paper or a "standard" theorem.

## Purpose

Many quantum-algorithm papers compress real dependencies into phrases such as
"by standard sparse-access oracles", "using state preparation", or "by LCU".
QBE must not treat those as implemented circuits unless the dependency is
actually formalized, contracted, or recorded as an obligation.

## Workflow

1. Identify the exact result being used.
2. If the result is used by a faithful-paper proof step, first inspect the
   local paper source and bibliography when available.  For GHL2025, the local
   TeX source is stored under
   `../outer_papers/quantum/GHL2025/`.
3. Record the source with a stable link, paper title, authors, arXiv version if
   available, theorem/lemma/equation/figure label, and the exact statement QBE
   needs.  Public artifacts should not cite local absolute paths.
4. Classify the status:
   - `paper-cited`: the current paper invokes it.
   - `classic-unformalized`: widely used but not yet formalized in QBE.
   - `obligation`: required before a dependent proof can close.
   - `contract-only`: QBE has a typed interface or `SemanticObligation`.
   - `formalized`: QBE has a build-tested Lean declaration for the used
     statement.
5. Add the Lean declaration if it exists, or a planned declaration if not.
6. Add dependent QBE tasks, gates, proof-DAG blocks, and proof obligations.
7. If a lower agent wants to use the result, check that its status is
   sufficient for the use.  Otherwise, record a blocking obligation.

## Entry Format

Use this table shape in `research-wiki/cited-results/*.md`:

| Result id | Source | Statement used | QBE status | Lean target | Used by | Reviewer note |
|---|---|---|---|---|---|---|

## Reviewer Rule

Reject a proof-map or Lean promotion if it relies on an unrecorded prior result,
or if the entry says `formalized` without a build-tested Lean declaration.
Do not accept "standard", "well-known", or "from the literature" as a source.
Do not accept a bibliography citation unless the exact statement used by QBE is
also recorded.

## Faithful Mode Rule

In faithful paper mode, cited results may explain why the source paper believes
an oracle exists, but they do not close QBE's gate-level circuit obligation
unless QBE has the corresponding Lean contract or proof.
