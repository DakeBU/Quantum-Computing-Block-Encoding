# Lower Verifier Feedback: Pro Export Guard Cycle 3

## Active Leaf

`MAINCASE-PRO-EXPORT-001`, guarded by `MAINCASE-PRO-SEMANTIC-TIER-001`.

This diagnostic is necessary because Qiskit/QASM3 export must cite the
gate-derived Pro transcript certificate.  The matrix-table incumbent
`mainCaseProVerified` is compiled, but it is not the transcript certificate:
`mainCaseProCircuitImage_candidate_mismatch_set` proves the full images differ
on dirty inputs `8`, `9`, `12`, and `13`.

## Executable Diagnostic

`verifier-feedback/QBE-MAIN-CASE-HIER-PRO-001/maincase_pro_export_guard_cycle03.py`
recomputes the 16-state lifted action for the reduced transcript
`CCX012; CX21; CX20; X2` under full wires `S=0`, `tau=1`, `T=2`,
`signal=3`.

It checks:

- the action is a permutation of all 16 basis states;
- the clean signal block equals `mainCaseProTarget`;
- the stale equality to `mainCaseProCandidateImage` is rejected exactly on
  `{8,9,12,13}`;
- `export-plan.md` names `mainCaseProCircuitVerified` and
  `mainCaseProCircuitCandidate_cost`;
- the plan rejects `mainCaseProVerified` / `mainCaseProCandidate_cost` as the
  export-facing transcript certificate.

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `MAINCASE-PRO-EXPORT-001` |
| `guards_semantic_leaf` | `MAINCASE-PRO-SEMANTIC-TIER-001` |
| `source_correspondence_ok` | `true` for the current export plan |
| `finite_matrix_ok` | `true` for the recomputed 16-state transcript action |
| `block_entry_ok` | `true` for the clean signal block against `mainCaseProTarget` |
| `ancilla_cleanup_ok` | `true`; clean signal index is `0` |
| `normalizer_ok` | `true`; plan cites `mainCaseProExactNormalizer = 1` |
| `resource_score` | `(4,4,1,0)` |
| `closed_theorem_ok` | `null`; this diagnostic does not close a theorem |
| `error_class` | `none` if the script exits `0`; otherwise `shape_or_register_gap` |
| `next_route` | Generate Qiskit/QASM3 artifacts from `mainCaseProCircuitVerified` only, then compare their 16-state basis action against this diagnostic. |

## Rejection

Reject any export packet whose Lean source declaration is `mainCaseProVerified`
or whose resource proof cites only `mainCaseProCandidate_cost`.  Those names
belong to the matrix-table incumbent, not the advertised Pro transcript.
