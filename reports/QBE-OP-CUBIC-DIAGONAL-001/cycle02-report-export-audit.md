# Report/Export Audit: QBE-OP-CUBIC-DIAGONAL-001 Cycle 2

Generated: 2026-06-20 12:58 JST
Middle refresh: 2026-06-20 12:58 JST
Run: `runs/20260620-123024-QBE-OP-CUBIC-DIAGONAL-001-cycle02`

This middle-panel note is a report/export synchronization packet.  It does not
assign Lean work, rewrite polished prose for the main technical report, or
create executable exports during the inner proof-search cycle.

## Final-Audit Human Entry Points

The preferred-language status page for this task is Chinese, matching the raw
user prompt.  The current human-facing entry points are:

| Artifact | Final-audit role | Current status |
|---|---|---|
| `reports/QBE-OP-CUBIC-DIAGONAL-001/zh_status.md` | preferred-language status page | refreshed at 2026-06-20 12:44 JST |
| `reports/QBE-OP-CUBIC-DIAGONAL-001/latest.md` | English status mirror | refreshed at 2026-06-20 12:44 JST |
| `paper-notes/problem-exports/QBE-OP-CUBIC-DIAGONAL-001/latest.tex` | problem-specific LaTeX proof/status note | refreshed at 2026-06-20 12:44 JST; keep as closeout/status note, not a certificate |
| `tasks/QBE-OP-CUBIC-DIAGONAL-001.md` | source operator target and contract | current through the fixed-denominator cleanup witness packet |
| `conversion-windows/QBE-OP-CUBIC-DIAGONAL-001.md` | Lean-to-natural-language correspondence and proof-DAG frontier | current through `DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001` |
| `proof-obligations/QBE-OP-CUBIC-DIAGONAL-001.md` | open obligations and blocked downstream claims | current at 2026-06-20 12:44 JST |
| `candidate-populations/QBE-OP-CUBIC-DIAGONAL-001.md` | certified, finite-executable, and insight-pool separation | current at 2026-06-20 12:44 JST |

At the final audit, the status page should first state the target diagonal
operator
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise, with
`exactNormalizer n = 1`.  It should then state that the current expanded route
has compiled transparent arithmetic, transparent rotation, and transparent
clean-uncompute interfaces, but no root block-encoding certificate.

The ABEIS technical-report appendix remains maintainer-only in this inner
cycle.  Update it only under an explicit `project-article-update` directive or
under a wrapper closeout that requests the project article packet.

## Raw Logs And Generated Files

The following files are process memory or machine-readable diagnostics, not
primary human entry points:

| Artifact | Reason |
|---|---|
| `runs/20260620-123024-QBE-OP-CUBIC-DIAGONAL-001-cycle02/dialogue.md` | coordination board for agents |
| `runs/20260620-123024-QBE-OP-CUBIC-DIAGONAL-001-cycle02/memory_digest.md` | compact retrieval packet for agents |
| `runs/20260620-123024-QBE-OP-CUBIC-DIAGONAL-001-cycle02/todo.md` | execution checklist for agents |
| `runs/trials.jsonl` and `runs/trials_summary.csv` | scheduler and trial memory |
| `research-wiki/retrieval-index/QBE-OP-CUBIC-DIAGONAL-001.json` | generated retrieval index |
| `verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/*.feedback.json` | typed verifier fields for automation |
| `verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/*.raw.feedback.json` | raw finite-check output |
| `verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/*.py` | diagnostic scripts, not proof documents |

Markdown files under `verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/` may be
linked as supporting evidence.  The final audit should summarize their typed
outcomes instead of sending readers through every attempt file.

## Open Blocker

The transparent clean-uncompute interface is compiled:
`ExpandedArithmeticCleanUncomputeWitness`,
`expandedWorkspaceCleanUncomputedTransparent`, and
`expandedWorkspaceCleanUncomputedTransparent_of_witness`.  These declarations
do not prove `expandedWorkspaceCleanUncomputed`, do not instantiate the
fixed-denominator cleanup route, and do not close clean-block extraction,
unitarity, `DIAG-ROOT-001`, or exports.

The active blocker is `DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001`: instantiate
the transparent cleanup witness for `workspaceQubits = 3 * n` using the
fixed-denominator modular add/sub steps

```text
computeStep(j,w) = (j, (w + j^3) mod 2^(3n))
uncomputeStep(j,w) = (j, (w + 2^(3n) - j^3) mod 2^(3n)).
```

The separate dependency `DIAG-RY-WORKSPACE-READONLY-001` still needs a named
Lean statement.  The finite diagnostic supports read-only rotation only in an
identity-read model, so route-level cleanup and extraction must not depend on
that fact until the Lean statement or an explicit contract refactor exists.

## Forbidden Manuscript Claims

The final audit and any manuscript-facing note must not claim:

| Forbidden claim | Current reason |
|---|---|
| The task has a Lean-certified exact block encoding. | `DIAG-ROOT-001` is blocked. |
| The primitive oracle-label candidate is semantically proved. | `primitiveAmplitudeOracleVerified n h` remains conditional on `h : primitiveAmplitudeOracleSemanticContract n`. |
| The exact standard `Rat` one-signal/no-workspace primitive witness works. | Determinant-square diagnostics rejected that witness shape. |
| The expanded arithmetic-gate circuit is fully proved unitary. | Fixed-denominator cleanup witness, workspace-readonly rotation statement, route-level cleanup, extraction, and unitarity remain open. |
| Qiskit, QuantumKatas-style, or QASM3 outputs certify the construction. | No post-Lean export packet should be created before a named Lean certificate. |
| The construction is resource-optimal or dominates across semantic tiers. | The expanded tier is not certified or scored, and cross-tier comparison is not permitted without a tier record. |
| The diagonal target can be replaced by rank-one cubic state preparation. | That changes the operator and is rejected by the task contract. |

## Post-Lean Export Packet Status

No executable export packet should be created in this cycle.  The requested
targets are Qiskit, QuantumKatas-style tests, and QASM3, but `DIAG-EXPORT-001`
depends on a closed `DIAG-ROOT-001` certificate.

Once a Lean certificate closes, create the export packet under
`executable-exports/QBE-OP-CUBIC-DIAGONAL-001/` with these fields:

| Field | Required value source |
|---|---|
| Lean certificate | exact theorem or verified candidate closing `DIAG-ROOT-001` |
| concrete instantiation | chosen `n`, scalar tier, and certified backend route |
| register layout | system register, signal qubit, workspace registers, and clean-state convention |
| normalizer and projector | `exactNormalizer n = 1` and the clean-block projection used by the Lean proof |
| resource tuple | compiled tuple for the certified tier, not a finite diagnostic score |
| target languages | Qiskit, QuantumKatas-style tests, and QASM3 |
| export check | finite executable checks tied back to the named Lean certificate |

Until those fields are available, executable code may be used only as a
diagnostic artifact, not as the advertised block-encoding proof.
