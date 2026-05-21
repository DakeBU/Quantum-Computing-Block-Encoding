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
2. Fill the LaTeX statement exactly as used in the paper.
3. Map every symbol to a Lean declaration or planned declaration.
4. Add a proof-DAG/reuse map.  Inspired by
   Sonoda--Akiyama--Uezato, arXiv:2602.10512v2, the conversion window should
   expose shared proof blocks rather than flattening the same local argument
   many times.
5. Write a Markdown explanation of the construction.
6. Move verified Lean code into `QuantumBlockEncoding/`.
7. Run `python3 tools/qbe.py check`.

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
