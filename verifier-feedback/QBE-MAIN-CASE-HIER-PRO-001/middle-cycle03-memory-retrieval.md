# Middle Memory Retrieval: Cycle 3

## Stale Lower Targets To Retire

- `mainCaseProCircuitImage_eq_candidate`: false on dirty columns `8`, `9`,
  `12`, and `13`.
- `MAINCASE-PRO-CIRCUIT-IMAGE-001` as broad proof search: closed by the
  candidate split and `mainCaseProCircuitVerified`.
- `MAINCASE-PRO-ORTHO-BRIDGE-001`: closed by
  `BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective`,
  `mainCaseProCandidateMatrix_isRationalOrthogonal`, and
  `mainCaseProCircuitMatrix_isRationalOrthogonal`.

## Rejected Routes To Remember

- Do not export from `mainCaseProVerified` or `mainCaseProCandidate_cost` as the
  advertised Pro transcript certificate.
- Do not retry full equality between `mainCaseProCircuitImage` and
  `mainCaseProCandidateImage`.
- Do not claim hardware optimality or primitive-gate decomposition from the
  logical-library score `(4,4,1,0)`.

## Active Proof-DAG Leaf

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `MAINCASE-PRO-SEMANTIC-TIER-001` | Name `MAINCASE-PRO-CIRCUIT-001` as the export-facing semantic-tier candidate and keep `MAINCASE-PRO-PERM-001` matrix-only unless separately aligned. | `MAINCASE-PRO-CIRCUIT-IMAGE-001`, `MAINCASE-PRO-ORTHO-BRIDGE-001`, `MAINCASE-PRO-RESOURCE-001` | middle/reviewer | `mainCaseProCircuitVerified`, `mainCaseProCircuitCandidate`, `mainCaseProCircuitCandidate_cost`, `mainCaseProCircuitMatrix_isRationalOrthogonal` | candidate population and retrieval index | `python3 tools/qbe.py check` | active memory/export leaf |
| `MAINCASE-PRO-EXPORT-001` | Build Qiskit and QASM3 packets from the named Lean certificate. | `MAINCASE-PRO-SEMANTIC-TIER-001` | export worker | none yet | `executable-exports/QBE-MAIN-CASE-HIER-PRO-001/` | export checks plus project gates | implementation pending |

## Missing Fields Or Memory Updates

- Retrieval index is now cycle 3 and points at `MAINCASE-PRO-SEMANTIC-TIER-001`.
- The cycle-3 semantic-tier feedback card supplies the typed fields for the
  active node with `closed_theorem_ok=true` and `error_class=none`.
- Old cycle-2 bridge-open cards are historical diagnostics; use the cycle-3
  report/export and semantic-tier cards as the current status.
- The cycle-3 run directory needed compact `memory_digest.md` and `todo.md`;
  this pass adds them.

## Next-Cycle Retrieval Packet

Use `mainCaseProCircuitVerified` plus `mainCaseProCircuitCandidate_cost` as the
certificate and resource tuple for export work.  The export packet must record
register order `S=0`, `tau=1`, `T=2`, `signal=3`, normalizer `1`, clean signal
projector, score `(4,4,1,0)`, target languages `qiskit` and `qasm3`, and the
export check command.
