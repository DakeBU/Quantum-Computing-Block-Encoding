# Mathlib Lemma Retrieval Cards

This directory stores reusable Mathlib findings for ABEIS agents.

Use the local search command before inventing a generic lemma:

```bash
python3 tools/qbe.py mathlib-search "Matrix.mul_apply"
```

Card template:

```yaml
id:
query:
mathlib_module:
mathlib_declaration:
statement:
qbe_use_site:
direct_import_status: imported | adapter-needed | dependency-blocked | not-usable
adapter_decl:
notes:
```

Agent rule:

- If Mathlib already proves the generic fact, prefer importing/reusing it.
- If direct import is blocked by dependency/version policy, record the exact
  Mathlib theorem and write only the smallest QBE adapter.
- If repeated search finds nothing, record the failed queries so future agents
  do not pay the same token/search cost.
