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

Allowed statuses:

- `paper-cited`
- `classic-unformalized`
- `contract-only`
- `obligation`
- `formalized`

This directory is retrieval memory.  A result closes a theorem only when the
referenced Lean declaration is build-tested for the exact statement being used.

For block-encoding construction templates, use
`research-wiki/block-encoding-library/` first.  Technical-lemma cards should
record dependencies that a chosen construction card needs, not replace the
route selector.
