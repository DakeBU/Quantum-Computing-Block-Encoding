# BE Case 2 Frozen Acceptance

`frozen-acceptance.json` is the machine-readable evidence snapshot for the two
isolated cubic-diagonal arms completed on 2026-07-16. It records the cold-start
boundary, relevant source hashes, Lean roots, executable versions, and finite
acceptance metrics.

The cold-start claim is intentionally scoped to run state: the cold arm does
not read an earlier cubic run, population, hint packet, or conversation. It may
retrieve the current compiled ABEIS library and Mathlib. This demonstrates
replay-safe retrieval and acceptance, not synthesis from an empty theorem
library.

Regenerate the finite artifacts with:

```bash
python3 tools/export_hard_cubic_householder.py \
  --task QBE-HARD-CUBIC-DIAGONAL-HIER-COLD-001 --n 2
python3 tools/export_hard_cubic_householder.py \
  --task QBE-HARD-CUBIC-DIAGONAL-HIER-HINTED-001 --n 2
```
