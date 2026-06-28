# Report/Export Audit: QBE-MAIN-CASE-HIER-COLD-001 Cycle 1

Generated: 2026-06-28 15:03:22 JST
Run: `runs/20260628-145035-QBE-MAIN-CASE-HIER-COLD-001-cycle01`

This middle-panel note synchronizes human-facing report/export memory only.  It
does not assign Lean work or introduce a new construction.

## Final-Audit Human Entry Points

No `QBE_REPORT_LANGUAGE` value is configured in this shell, so the preferred
status language is English.

| Artifact | Final-audit role | Current status |
|---|---|---|
| `reports/QBE-MAIN-CASE-HIER-COLD-001/latest.md` | preferred-language status page | updated to show export completion |
| `paper-notes/problem-exports/QBE-MAIN-CASE-HIER-COLD-001/latest.tex` | problem-specific LaTeX status note | updated to the COLD certificate/export status |
| `conversion-windows/QBE-MAIN-CASE-HIER-COLD-001.md` | Lean-to-natural-language proof map | current through verified candidate and export map |
| `proof-obligations/QBE-MAIN-CASE-HIER-COLD-001.md` | obligation and proof-DAG frontier ledger | no active proof/export leaf at current tier |
| `candidate-populations/QBE-MAIN-CASE-HIER-COLD-001.md` | certified candidate and insight-pool separation | certified exact COLD candidate with export checked |
| `executable-exports/QBE-MAIN-CASE-HIER-COLD-001/export-manifest.json` | post-Lean export packet | Qiskit/QASM3/checker artifacts generated and checked |

The ABEIS technical-report appendix remains out of scope for this pass.  Update
it only under an explicit project-article update or wrapper closeout.

## Non-Entry Artifacts

The following files are process memory or machine-readable diagnostics, not
first human entry points:

| Artifact | Reason |
|---|---|
| `runs/20260628-145035-QBE-MAIN-CASE-HIER-COLD-001-cycle01/dialogue.md` | coordination board for agents |
| `runs/trials.jsonl` and `runs/trials_summary.csv` | scheduler memory and typed trial history |
| `research-wiki/retrieval-index/QBE-MAIN-CASE-HIER-COLD-001.json` | compact retrieval packet for agents |
| `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/*.feedback.json` | machine-readable verifier fields |
| `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/*.py` | diagnostic scripts, not proof documents |

## Open Blocker

There is no current blocker at the exact finite-permutation/logical-export
tier.  The Lean certificate is `mainCaseColdPartialPermVerified`, with resource
theorem `mainCaseColdPartialPermCandidate_cost`.  The post-Lean export
artifacts pass deterministic checks against the COLD table with basis action
`[14,15,8,9,10,11,0,1,2,3,4,5,6,7,12,13]`, clean support `{(0,6),(1,7)}`,
passive `S` preserved, `alpha=1`, `epsilon=0`, and resource tuple `(5,5,1,0)`.

The earlier `MAIN-EXPORT-VERIFY-001` failure packet is historical.  It is
superseded by
`verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/main-case-cold-export-implement-cycle02.md`.

## Forbidden Manuscript Claims

| Forbidden claim | Current reason |
|---|---|
| The result is an arbitrary-`r` or arbitrary-`k` theorem. | The certificate is for `r=1,k=1,passiveQubits=1`. |
| The result is hardware-gate optimal. | The certified tuple is at the project high-level logical tier. |
| The result proves a global lower bound. | No Lean lower-bound theorem is named. |
| The COLD construction uses Pro-arm evidence. | The no-Pro isolation rule keeps `mainCasePro*` and previous Pro/Qiskit artifacts out of evidence. |
| Qiskit/QASM3 checks replace Lean proof. | Executable checks validate post-Lean translations; Lean remains theorem authority. |

## Post-Lean Export Packet

| Field | Value |
|---|---|
| Lean certificate | `mainCaseColdPartialPermVerified` |
| Candidate record | `mainCaseColdPartialPermCandidate` |
| Resource theorem | `mainCaseColdPartialPermCandidate_cost` |
| Concrete instantiation | `r=1`, `k=1`, `passiveQubits=1` |
| Target | $E_1 = |0><1|_T \otimes |0><1|_\tau \otimes I_S$ |
| System index | `4*T + 2*tau + S` |
| Full index | `8*signal + 4*T + 2*tau + S` |
| Qiskit wire map | `q[0]=S`, `q[1]=tau`, `q[2]=T`, `q[3]=signal` |
| Clean projector | signal qubit at value `0`, represented by `mainCaseColdBlockProjection` |
| Normalizer and error | `mainCaseColdExactNormalizer = 1`, `mainCaseColdExactError = 0` |
| Transcript | `X_T; CCX_tau,T->signal; X_tau; CX_signal->T; CX_tau->signal` |
| Resource tuple | `(5,5,1,0)` |
| Targets | `qiskit`, `qasm3` |
| Check commands | `python3 executable-exports/QBE-MAIN-CASE-HIER-COLD-001/qiskit/export.py --json`; `python3 executable-exports/QBE-MAIN-CASE-HIER-COLD-001/main_case_cold_export_check.py`; `python3 verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/main-case-cold-export-cycle01.py` |
