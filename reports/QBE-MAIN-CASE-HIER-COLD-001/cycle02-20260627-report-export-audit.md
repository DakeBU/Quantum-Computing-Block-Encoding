# Report/Export Audit: QBE-MAIN-CASE-HIER-COLD-001 Cycle 2

Generated: 2026-06-27 JST
Run: `runs/20260627-125940-QBE-MAIN-CASE-HIER-COLD-001-cycle02`

This middle-panel note is a report/export synchronization packet.  It records
human-facing entry points and export blockers only.  It does not assign Lean
work, rewrite manuscript prose, or create Qiskit/QASM3 artifacts during this
inner proof-search cycle.

## Final-Audit Human Entry Points

No `QBE_REPORT_LANGUAGE` value is configured in this shell, so the preferred
status language is English.

| Artifact | Final-audit role | Current status |
|---|---|---|
| `reports/QBE-MAIN-CASE-HIER-COLD-001/latest.md` | preferred-language status page | updated from this report/export audit |
| `paper-notes/problem-exports/QBE-MAIN-CASE-HIER-COLD-001/latest.tex` | problem-specific LaTeX proof/status note | stale; update only at 6h or convergence closeout |
| `paper-notes/problem-exports/QBE-MAIN-CASE-HIER-COLD-001/20260627-125940-QBE-MAIN-CASE-HIER-COLD-001-cycle02.tex` | run-specific LaTeX proof/status note | create at final audit if closeout/export is requested |
| `conversion-windows/QBE-MAIN-CASE-HIER-COLD-001.md` | Lean-to-natural-language proof map | current through `mainCaseColdPartialPermVerified` and resource theorem |
| `proof-obligations/QBE-MAIN-CASE-HIER-COLD-001.md` | obligation and proof-DAG frontier ledger | `MAIN-EXPORT-001` remains active; Lean proof leaves are retired |
| `executable-exports/QBE-MAIN-CASE-HIER-COLD-001/export-plan.md` | post-Lean export packet | Lean certificate named; wire map corrected; generated code pending |

The ABEIS technical-report appendix remains out of scope for this inner cycle.
Update it only under an explicit `project-article-update` or wrapper closeout.

## Non-Entry Artifacts

The following files are useful process memory, but they should not be the first
human entry points:

| Artifact | Reason |
|---|---|
| `runs/20260627-125940-QBE-MAIN-CASE-HIER-COLD-001-cycle02/dialogue.md` | coordination board for agents |
| `runs/20260627-125940-QBE-MAIN-CASE-HIER-COLD-001-cycle02/*.md` except `90_handoff.md` | prompt shards and panel context rather than polished status |
| `runs/trials.jsonl` and `runs/trials_summary.csv` | scheduler memory and typed trial history |
| `research-wiki/retrieval-index/QBE-MAIN-CASE-HIER-COLD-001.json` | generated retrieval index for agents |
| `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/*.feedback.json` | machine-readable feedback fields |
| `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/*.py` | diagnostic scripts, not proof documents |
| future `qiskit/` and `qasm3/` generated files | executable support artifacts; the manifest and status page should summarize them |

Markdown files under `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/` may be
linked as supporting evidence.  The final audit should summarize their typed
outcomes instead of requiring readers to inspect raw logs.

## Open Blocker

The Lean construction has closed at the task's finite-permutation semantic
tier.  The named evidence is `mainCaseColdPartialPermCandidate`,
`mainCaseColdPartialPermVerified`, and `mainCaseColdPartialPermCandidate_cost`,
with resource tuple `(gateCount=5, depth=5, auxiliaryQubits=1, oracleCalls=0)`.

The remaining blocker is post-Lean export.  The verifier feedback for
`MAIN-EXPORT-001` reports `source_translation_gap` because the export root still
contains only `export-plan.md`; there is no generated `qiskit/` implementation,
no `qasm3/` file, and no manifest for the checker to compare with
`mainCaseColdPartialPermVerified`.  This is not a counterexample to the Lean
certificate.

The export plan and feedback memory now require the Lean integer bit positions
`S=0`, `tau=1`, `T=2`, `signal=3`, with full index
`8*signal + 4*T + 2*tau + S`.  The stale map `T=0`, `tau=1`, `S=2`,
`signal=3` must not appear in generated export artifacts.

## Forbidden Manuscript Claims

Until the named artifact exists and its checker passes, the final audit and
manuscript-facing note must not claim:

| Forbidden claim | Current reason |
|---|---|
| Qiskit or QASM3 export is complete. | No generated Qiskit, QASM3, or manifest artifact exists. |
| Executable checks certify the theorem. | Lean is the theorem authority; executable checks only validate post-Lean translations. |
| The export covers parameters beyond `r=1`, `k=1`, `passiveQubits=1`. | The requested export instantiation is fixed to that concrete case. |
| The COLD construction uses Pro-arm evidence. | The no-Pro isolation rule forbids `mainCasePro*` declarations and previous Pro/Qiskit artifacts as evidence. |
| The construction is resource-optimal. | Lean certifies the reported tuple, not global optimality over all candidate families. |
| The finite-permutation tier proves any stronger matrix-unitary semantic tier not named in Lean. | The accepted package is the current task semantic tier; stronger bridges require their own declarations. |

## Required Post-Lean Export Packet

The Lean theorem has closed and the task requests Qiskit and QASM3 outputs, so
the export packet must contain these fields before executable export completion
can be claimed:

| Field | Required value |
|---|---|
| Lean certificate | `mainCaseColdPartialPermVerified` |
| Candidate record | `mainCaseColdPartialPermCandidate` |
| Resource theorem | `mainCaseColdPartialPermCandidate_cost` |
| Concrete instantiation | `r=1`, `k=1`, `passiveQubits=1` |
| Target | $E_1 = |0><1|_T \otimes |0><1|_\tau \otimes I_S$ |
| System index | `4*T + 2*tau + S` |
| Full index | `8*signal + 4*T + 2*tau + S` |
| Lean bit positions | `S=0`, `tau=1`, `T=2`, `signal=3` |
| Clean projector | signal qubit at value `0`, represented by `mainCaseColdBlockProjection` |
| Normalizer and error | `mainCaseColdExactNormalizer = 1`, `mainCaseColdExactError = 0` |
| Transcript | `X_T; CCX_tau,T->signal; X_tau; CX_signal->T; CX_tau->signal` |
| Resource tuple | `(5,5,1,0)` |
| Targets | `qiskit`, `qasm3` |
| Check command | export verifier plus `python3 tools/qbe.py check`, `lake build`, and `lake build Tests` |

The export check must compare the generated basis action against
`mainCaseColdPartialPermImage` on all 16 basis states, confirm clean support
`(0,6)` and `(1,7)`, preserve passive `S`, confirm normalizer `1`, exact error
`0`, resource tuple `(5,5,1,0)`, and reject any `mainCasePro*` evidence.
