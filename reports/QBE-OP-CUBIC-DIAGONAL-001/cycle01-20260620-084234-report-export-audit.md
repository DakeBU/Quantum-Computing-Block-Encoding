# Report/Export Audit: QBE-OP-CUBIC-DIAGONAL-001 Cycle 1

Generated: 2026-06-20 09:09 JST
Run: `runs/20260620-084234-QBE-OP-CUBIC-DIAGONAL-001-cycle01`

This middle-panel note is a final-audit synchronization packet.  It records
human-readable entry points and export constraints; it does not assign Lean
work or create executable exports.

## Final-Audit Human Entry Points

The preferred-language status page is
`reports/QBE-OP-CUBIC-DIAGONAL-001/zh_status.md`, because the source prompt is
Chinese.  The English mirror is
`reports/QBE-OP-CUBIC-DIAGONAL-001/latest.md`.

The problem-specific LaTeX status note is
`paper-notes/problem-exports/QBE-OP-CUBIC-DIAGONAL-001/latest.tex`, with a
run-specific copy at
`paper-notes/problem-exports/QBE-OP-CUBIC-DIAGONAL-001/20260620-084234-QBE-OP-CUBIC-DIAGONAL-001-cycle01.tex`.
The note must remain a status note, not a proof of a root certificate.

The ABEIS technical-report appendix is maintainer-only for this task state.
Do not update it without an explicit `project-article-update` directive or a
wrapper closeout that requests the project article packet.

## Raw Logs And Generated Files

The following artifacts are not human entry points:

| Artifact | Reason |
|---|---|
| `runs/20260620-084234-QBE-OP-CUBIC-DIAGONAL-001-cycle01/dialogue.md` | coordination board for agents |
| `runs/20260620-084234-QBE-OP-CUBIC-DIAGONAL-001-cycle01/memory_digest.md` | compact retrieval packet for agents |
| `runs/20260620-084234-QBE-OP-CUBIC-DIAGONAL-001-cycle01/todo.md` | lower-agent task list |
| `runs/trials.jsonl` and `runs/trials_summary.csv` | scheduler and trial memory |
| `verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/*.feedback.json` | typed verifier fields for automation |
| `verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/*.raw.feedback.json` | raw finite-check output |
| `verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/*.py` | diagnostic scripts, not proof documents |
| `research-wiki/retrieval-index/QBE-OP-CUBIC-DIAGONAL-001.json` | generated retrieval index |

Markdown files under `verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/` may be
linked as supporting evidence.  The final audit should summarize their typed
outcomes rather than send readers through every attempt file.

## Open Blocker

The source target is still the diagonal operator $D_n$ with entry $(j/2^n)^3$
when `row = col` and zero otherwise, with normalizer `alpha = 1`.

The fixed-denominator route has closed its capacity, amplitude, backend, and
transparent arithmetic witness leaves.  The compiled declarations are
`fixedDenomCubicPayload_lt_capacity`, `fixedDenomCubicAmplitude_eq`,
`fixedDenomCubicArithmeticBackend`, `fixedDenomCubicArithmeticBackend_computes`,
`expandedArithmeticComputesCubicAmplitudeTransparent`, and
`fixedDenomCubicArithmeticRouteTransparent`.

The current blocker is `DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001`.  The expanded
clean-block contract should consume
`expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits`
directly.  The old opaque arithmetic route predicate is not proved, and direct
bridge search against it remains stale.

## Forbidden Manuscript Claims

The final audit and any manuscript-facing note must not claim:

| Forbidden claim | Current reason |
|---|---|
| The task has a Lean-certified exact block encoding. | `DIAG-ROOT-001` is blocked. |
| The primitive oracle-label candidate is semantically proved. | `primitiveAmplitudeOracleVerified n h` remains conditional on `h : primitiveAmplitudeOracleSemanticContract n`. |
| The exact standard `Rat` one-signal/no-workspace primitive witness works. | Determinant-square diagnostics rejected that witness shape. |
| The expanded arithmetic-gate circuit is fully proved unitary. | Rotation backend witness, clean uncompute, extraction, and unitarity remain open. |
| Qiskit, QuantumKatas-style, or QASM3 outputs certify the construction. | No post-Lean export packet may be created before a named Lean certificate. |
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
