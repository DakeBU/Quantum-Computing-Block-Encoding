---
name: qbe-conversion-window
description: Maintain synchronized Lean, LaTeX, and Markdown views for one block-encoding construction.
argument-hint: "[task id]"
---

# QBE Conversion Window

Use this whenever a construction must move between paper notation, Lean names,
and human explanation.

## Steps

1. Create a window with:
   `python3 tools/qbe.py conversion-window <task-id> --title "<title>"`.
2. In Phase 1 faithful-paper work, treat this window as a transcript first:
   prioritize exact paper-to-Lean mapping over library reorganization.
3. Fill the LaTeX statement exactly as used in the paper.
4. Map every symbol to a Lean declaration or planned declaration.
5. Add a source-contract audit pane for faithful-paper tasks.  For every
   oracle/gate, include the paper anchor, input registers, output registers,
   clean ancillas, normalizer, and the Lean declaration that should implement
   it.  Use public paper citations and stable theorem/lemma/equation/figure
   labels; do not make public artifacts depend on a machine-specific absolute
   path to a local source copy.
6. Add a proof-DAG/reuse map.  Inspired by
   Sonoda--Akiyama--Uezato, arXiv:2602.10512v2, the conversion window should
   expose shared proof blocks rather than flattening the same local argument
   many times.
7. Add a cited-results pane when the proof uses prior work or a standard fact.
   Link to `research-wiki/cited-results/` and distinguish `paper-cited`,
   `contract-only`, `obligation`, and `formalized` statuses.
8. Write a Markdown explanation of the construction.
9. Move verified Lean code into `QuantumBlockEncoding/`.
10. Run `python3 tools/qbe.py check`.

## Proof-DAG Pane

Add or maintain a table with these columns when the construction has repeated
subarguments:

| Block | Interface | Paper source | Lean declaration | Depends on | Reused by | Status |
|---|---|---|---|---|---|---|

Use it to track:

- graph-level choices: which intermediate lemma/block should exist;
- high-level dependencies: which blocks call which other blocks;
- low-level obligations: the local Lean proof or matrix calculation for each
  block;
- reuse sites: where the block is consumed without reproving it.

If a flat proof attempt repeats the same bit arithmetic, matrix-index
calculation, or projection lemma, promote it to a block in this table.

## Rule

If a symbol cannot be mapped to Lean, do not silently translate it.  Add a proof
obligation or a missing-definition task.

If a proof block cannot be mapped to Lean, record the exact missing interface
and dependency.  Do not replace the paper theorem with a weaker statement.

If a Lean declaration maps the wrong registers, uses a simplified oracle shape,
or omits the paper's clean-ancilla condition, mark it as contract drift and
assign a correction before proving unitarity or block extraction for it.

If a claim relies on prior work, do not paraphrase it as a local theorem unless
the cited result has a precise ledger entry and Lean status.  Missing prior
results become proof obligations, not implicit assumptions.

During Phase 1, do not expand the window into a general textbook or library
design document.  Keep it focused on faithful paper transcript, exact Lean
contracts, and explicit obligations.  Move general teaching/reuse material to
Phase 2 documentation after the transcript is complete.
