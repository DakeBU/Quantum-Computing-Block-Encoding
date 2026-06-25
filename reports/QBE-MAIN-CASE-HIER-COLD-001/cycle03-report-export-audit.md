# Report/Export Audit: QBE-MAIN-CASE-HIER-COLD-001 Cycle 3

Generated: 2026-06-25 23:49 JST
Run: `runs/20260625-233740-QBE-MAIN-CASE-HIER-COLD-001-cycle03`

This middle-panel note is a report/export synchronization packet.  It does not
assign Lean work, rewrite polished manuscript prose, or create Qiskit/QASM3
exports during the inner proof-search cycle.

## Final-Audit Human Entry Points

The task is an English exploratory operator-construction run.  No separate
preferred-language page has been configured, so the final audit should update
an English status page first.

| Artifact | Final-audit role | Current status |
|---|---|---|
| `reports/QBE-MAIN-CASE-HIER-COLD-001/latest.md` | preferred-language status page | missing; create at closeout or when the run converges |
| `paper-notes/problem-exports/QBE-MAIN-CASE-HIER-COLD-001/latest.tex` | problem-specific LaTeX proof/status note | missing; defer until 6h or convergence closeout |
| `tasks/QBE-MAIN-CASE-HIER-COLD-001.md` | fixed operator target and export request | active source contract |
| `conversion-windows/QBE-MAIN-CASE-HIER-COLD-001.md` | Lean-to-natural-language correspondence and proof-DAG frontier | current through `mainCaseColdPartialPerm_clean_eq_target` and `mainCaseColdPartialPermImage_bijective`; needs cycle-3 packaging/resource refresh |
| `proof-obligations/QBE-MAIN-CASE-HIER-COLD-001.md` | open obligations and blocked downstream claims | current through finite bijection; needs cycle-3 packaging/resource refresh |
| `candidate-populations/QBE-MAIN-CASE-HIER-COLD-001.md` | certified, pending, and insight-pool separation | records partial score `(?, ?, 1, 0)`; needs update after resource field theorems compile |
| `proof-blueprints/QBE-MAIN-CASE-HIER-COLD-001.md` | proof-DAG control layer | still shows stale active `MAIN-EXPORT-001`; final audit should require export to remain blocked until a verified candidate and resource tuple compile |

At final audit, the status page should start with the target
$E_1 = |0><1|_T \otimes |0><1|_\tau \otimes I_S$, the register order
`(T,tau,S)`, clean signal `0`, normalizer `alpha = 1`, and exact error `0`.
It should then state only the Lean-supported facts:
`mainCaseColdTarget`, `mainCaseColdPartialPermMatrix`,
`mainCaseColdPartialPerm_clean_eq_target`, and
`mainCaseColdPartialPermImage_bijective` compile after the project gate.

The ABEIS technical-report appendix remains out of scope for this inner cycle.
Update it only under an explicit project-article update or wrapper closeout.

## Raw Logs And Generated Files

The following files are process memory or machine-readable diagnostics, not
primary human entry points:

| Artifact | Reason |
|---|---|
| `runs/20260625-233740-QBE-MAIN-CASE-HIER-COLD-001-cycle03/dialogue.md` | coordination board for agents |
| `runs/20260625-233740-QBE-MAIN-CASE-HIER-COLD-001-cycle03/*.md` except this audit's cited entry points | prompt shards and panel context, not polished status pages |
| `runs/trials.jsonl` and `runs/trials_summary.csv` | scheduler and trial memory |
| `research-wiki/retrieval-index/QBE-MAIN-CASE-HIER-COLD-001.json` | generated retrieval index for agents |
| `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/*.feedback.json` | typed verifier fields for automation |
| `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/*.py` | finite diagnostic scripts, not proof documents |

Markdown files under `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/` may be
linked as supporting evidence.  The final audit should summarize their typed
outcomes instead of sending readers through raw logs.

## Open Blocker

The clean-block layer is closed for the COLD candidate:
`mainCaseColdPartialPerm_clean_eq_target` proves that the clean block of the
task-local partial-permutation matrix equals the target matrix.  The finite
permutation layer is also closed at the table tier:
`mainCaseColdPartialPermImage_bijective` proves that the COLD image table is a
bijection.

The full task is still blocked because there is no COLD task-local
`OperatorBlockEncodingCandidate` or `VerifiedOperatorBlockEncoding` package,
and there are no compiled resource field theorems for
`(gateCount, depth, auxiliaryQubits, oracleCalls)`.  The honest current score
is only partial: `(?, ?, 1, 0)`.  Gate count and depth must remain unknown
unless a COLD-local circuit or high-level resource schema is declared and
build-tested.

## Forbidden Manuscript Claims

The final audit and any manuscript-facing note must not claim:

| Forbidden claim | Current reason |
|---|---|
| The COLD task has a complete Lean-certified block encoding. | No COLD `OperatorBlockEncodingCandidate` or `VerifiedOperatorBlockEncoding` exists yet. |
| The COLD candidate has a certified resource tuple. | `auxiliaryQubits = 1` and `oracleCalls = 0` are source-layout claims only until field theorems compile; gate count and depth are still unset. |
| The finite bijection alone proves the project-level matrix-unitary semantic tier. | The current proof closes the finite table tier; any stronger matrix-orthogonality bridge must be named if required. |
| Qiskit or QASM3 exports certify this construction. | No post-Lean export packet exists, and export is blocked by the Lean-first policy. |
| The COLD route uses or improves on Pro-isolated declarations. | The no-Pro isolation rule forbids using `mainCasePro*`, previous Pro answers, or previous Qiskit exports as COLD proof parents. |
| The construction is resource-optimal or dominates other tiers. | The resource tuple and comparison baseline are not fully certified. |

## Post-Lean Export Packet Status

No executable export packet should be created in this cycle.  The requested
targets are Qiskit and QASM3, but `MAIN-EXPORT-001` depends on a named COLD
verified candidate and a compiled resource tuple.

Once those Lean certificates close, create the export packet under
`executable-exports/QBE-MAIN-CASE-HIER-COLD-001/` with these fields:

| Field | Required value source |
|---|---|
| Lean certificate | the exact COLD theorem or `VerifiedOperatorBlockEncoding` declaration |
| concrete instantiation | `r = 1`, `k = 1`, `passiveQubits = 1` |
| register layout | system order `(T,tau,S)`, one clean signal qubit, and no pure ancillas unless Lean says otherwise |
| normalizer and projector | `alpha = 1` and clean signal `0` block projection |
| resource tuple | compiled field theorems for `(gateCount, depth, auxiliaryQubits, oracleCalls)` |
| target languages | Qiskit and QASM3 |
| export check | finite executable checks tied back to the named Lean certificate |

Until those fields are available, executable code may be used only as a
diagnostic artifact, not as the advertised proof.
