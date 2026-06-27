# Report/Export Status: QBE-MAIN-CASE-HIER-COLD-001

Generated: 2026-06-27 JST

This is the current human-facing report/export status for the COLD main-case
transfer-operator task.

## Status

The Lean construction is closed at the finite-permutation semantic tier.  The
named evidence is `mainCaseColdPartialPermCandidate`,
`mainCaseColdPartialPermVerified`, and `mainCaseColdPartialPermCandidate_cost`.
The certified resource tuple is `(gateCount=5, depth=5, auxiliaryQubits=1,
oracleCalls=0)`.

The remaining blocker is executable export.  `MAIN-EXPORT-001` still has no
generated Qiskit implementation, QASM3 file, or manifest under
`executable-exports/QBE-MAIN-CASE-HIER-COLD-001/`.  The export packet must use
Lean bit positions `S=0`, `tau=1`, `T=2`, `signal=3` and full index
`8*signal + 4*T + 2*tau + S`.

## Final-Audit Entry Points

| Artifact | Role |
|---|---|
| `reports/QBE-MAIN-CASE-HIER-COLD-001/cycle02-20260627-report-export-audit.md` | detailed report/export audit |
| `paper-notes/problem-exports/QBE-MAIN-CASE-HIER-COLD-001/latest.tex` | closeout LaTeX proof/status note; currently stale |
| `conversion-windows/QBE-MAIN-CASE-HIER-COLD-001.md` | Lean-to-natural-language correspondence |
| `proof-obligations/QBE-MAIN-CASE-HIER-COLD-001.md` | active frontier and obligation ledger |
| `executable-exports/QBE-MAIN-CASE-HIER-COLD-001/export-plan.md` | post-Lean export packet |

Do not claim Qiskit/QASM3 completion, parameter ranges beyond
`r=1,k=1,passiveQubits=1`, Pro-arm evidence, or resource optimality until the
corresponding artifact and check exist.
