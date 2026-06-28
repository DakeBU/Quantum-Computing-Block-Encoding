# Report/Export Status: QBE-MAIN-CASE-HIER-COLD-001

Generated: 2026-06-28 15:03:22 JST

This is the current human-facing report/export status for the COLD main-case
transfer-operator task.

## Status

The Lean construction is closed at the finite-permutation semantic tier.  The
named evidence is `mainCaseColdPartialPermCandidate`,
`mainCaseColdPartialPermVerified`, and `mainCaseColdPartialPermCandidate_cost`.
The certified resource tuple is `(gateCount=5, depth=5, auxiliaryQubits=1,
oracleCalls=0)`.

The post-Lean executable export is also complete for the requested concrete
instance `r=1,k=1,passiveQubits=1`.  The generated Qiskit, QASM3, manifest, and
deterministic checker artifacts live under
`executable-exports/QBE-MAIN-CASE-HIER-COLD-001/`.  They use Lean bit weights
`S=0`, `tau=1`, `T=2`, `signal=3`, so the executable wire map is
`q[0]=S`, `q[1]=tau`, `q[2]=T`, `q[3]=signal` and the full index is
`8*signal + 4*T + 2*tau + S`.

The deterministic export checks pass: the exported basis action is
`[14,15,8,9,10,11,0,1,2,3,4,5,6,7,12,13]`, the clean support is
`{(0,6),(1,7)}`, passive `S` is preserved, `alpha=1`, `epsilon=0`, and the
resource tuple is `(5,5,1,0)`.

## Final-Audit Entry Points

| Artifact | Role |
|---|---|
| `reports/QBE-MAIN-CASE-HIER-COLD-001/cycle01-20260628-report-export-audit.md` | current report/export audit |
| `paper-notes/problem-exports/QBE-MAIN-CASE-HIER-COLD-001/latest.tex` | problem-specific LaTeX status note |
| `conversion-windows/QBE-MAIN-CASE-HIER-COLD-001.md` | Lean-to-natural-language correspondence |
| `proof-obligations/QBE-MAIN-CASE-HIER-COLD-001.md` | proof-DAG and obligation ledger |
| `candidate-populations/QBE-MAIN-CASE-HIER-COLD-001.md` | certified candidate and insight-pool separation |
| `executable-exports/QBE-MAIN-CASE-HIER-COLD-001/export-manifest.json` | post-Lean executable export manifest |

Raw `runs/`, JSONL/CSV trial logs, verifier `.feedback.json`, and diagnostic
Python scripts are not primary human entry points.  Use them only to audit the
summaries above.

## Open Blocker

There is no open blocker at the current exact finite-permutation/logical-export
tier.  Reopen work only if the target operator, semantic tier, resource metric,
wire map, or requested export language changes.

## Forbidden Manuscript Claims

Do not claim a generalized arbitrary-`r` or arbitrary-`k` construction,
hardware-gate optimality, global lower bounds, or Pro-arm evidence.  The safe
claim is the concrete COLD `r=1,k=1,passiveQubits=1` Lean certificate plus its
post-Lean Qiskit/QASM3 export checks.
