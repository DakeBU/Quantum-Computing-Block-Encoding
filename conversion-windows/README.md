# Conversion Windows

Conversion windows synchronize three views of one construction:

- LaTeX: paper notation and theorem/proof text.
- Markdown: human explanation and design decisions.
- Lean: declaration names and checked code.

Create a window with:

```bash
python3 tools/qbe.py conversion-window QBE-AUTO-004 --title "Sparse access oracle"
```

If a LaTeX symbol cannot be mapped to Lean, add a missing-definition or
proof-obligation item instead of silently translating it.

For the full process, read `docs/article_to_lean_workflow.md`.
