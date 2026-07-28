# Technical Lemma Memory

This retrieval layer stores reusable external lemmas, standard quantum
primitives, classical facts, and source-paper dependencies used by ABEIS tasks.

Every memory card should expose the same fields:

- `id`
- `source`
- `statement`
- `lean_decl`
- `lean_status`
- `used_by`
- `dependencies`
- `next_action`
- `tags`

Promoted local declarations must also appear in `registry.json`.  The registry
records the fully qualified name, source file, required imports, exact
signature, semantic layer, compatible shapes, successful and failed uses,
license/attribution, Lean version, and both local-declaration and broader-route
status.  Validate it with:

```bash
python3 tools/check_technical_lemma_registry.py
```

Allowed statuses:

- `paper-cited`
- `classic-unformalized`
- `contract-only`
- `obligation`
- `formalized`

This directory is retrieval memory.  A result closes a theorem only when the
referenced Lean declaration is build-tested for the exact statement being used.
`local_declaration_status: complete` never implies that a parent construction
or benchmark route is complete.

For block-encoding construction templates, use
`research-wiki/block-encoding-library/` first.  Technical-lemma cards should
record dependencies that a chosen construction card needs, not replace the
route selector.
