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
4. Write a Markdown explanation of the construction.
5. Move verified Lean code into `QuantumBlockEncoding/`.
6. Run `python3 tools/qbe.py check`.

## Rule

If a symbol cannot be mapped to Lean, do not silently translate it.  Add a proof
obligation or a missing-definition task.
