# Verifier Feedback: MAIN-EXPORT-VERIFY-001 Cycle 2

> Superseded status: this packet records the first failed export-verification pass.
> The current cycle-2 export implementation passed later in
> `main-case-cold-export-implement-cycle02.md` with generated Qiskit, QASM3,
> manifest, and deterministic basis-action checks.

Task: `QBE-MAIN-CASE-HIER-COLD-001`

Run: `20260627-125940-QBE-MAIN-CASE-HIER-COLD-001-cycle02`

## Current Resolution

This packet is historical and must not be used as the current export status.
The export implementation later generated
`executable-exports/QBE-MAIN-CASE-HIER-COLD-001/qiskit/export.py`,
`executable-exports/QBE-MAIN-CASE-HIER-COLD-001/qasm3/main_case_cold_partial_perm.qasm3`,
`executable-exports/QBE-MAIN-CASE-HIER-COLD-001/export-manifest.json`, and
`executable-exports/QBE-MAIN-CASE-HIER-COLD-001/main_case_cold_export_check.py`.
The accepted packet is
`verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/main-case-cold-export-implement-cycle02.md`.
It records passing finite-matrix, clean-block, passive-`S`, normalizer, QASM3,
resource, and forbidden-reference checks against `mainCaseColdPartialPermVerified`.

## Active Leaf

`MAIN-EXPORT-VERIFY-001` checks the post-Lean executable export leaf.  This is
a necessary condition because any Qiskit/QASM3 artifact must expose a concrete
16-state basis action matching `mainCaseColdPartialPermImage` before it can be
accepted as a faithful translation of `mainCaseColdPartialPermVerified`.

## Diagnostic

Added current-cycle executable checker:

```bash
python3 verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/main-case-cold-export-verify-cycle02.py
```

The checker reuses the cycle-1 deterministic export-check helpers and records
the cycle-2 leaf.  It checks for generated `qiskit/`, `qasm3/`, and manifest
artifacts, then compares any exported `basis_action` or `BASIS_ACTION` table
against the COLD finite table, clean support `(0,6),(1,7)`, passive `S`
preservation, normalizer/resource metadata, QASM3 syntax marker, and absence
of `mainCasePro*` evidence.

## Historical Verdict

Reject export verification for this pass.  The Lean reference finite table
still satisfies the local support/permutation/passive-bit sanity check, and
the corrected map is `q[0]=S`, `q[1]=tau`, `q[2]=T`, `q[3]=signal` for
`8*signal + 4*T + 2*tau + S`.  However, the export root contains only
`export-plan.md` plus empty `qiskit/` and `qasm3/` directories; there is no
generated Qiskit basis-action file, QASM3 file, or manifest to compare against
`mainCaseColdPartialPermVerified`.

This is not a counterexample to the COLD Lean theorem.  It is a
`source_translation_gap` at the post-Lean export implementation layer.

## Fields

| Field | Value |
|---|---|
| `leaf` | `MAIN-EXPORT-VERIFY-001` |
| `source_correspondence_ok` | `false` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `finite_matrix_ok` | `false` for generated artifacts; reference COLD table check is `true` |
| `block_entry_ok` | `false` for generated artifacts; expected clean support is `{(0,6),(1,7)}` |
| `ancilla_cleanup_ok` | `false`; no exported action exists to check passive `S` |
| `normalizer_ok` | `false`; no manifest exists |
| `unitarity_ok` | `false`; no exported basis action exists |
| `resource_score` | expected `(5,5,1,0)` |
| `closed_theorem_ok` | `false`; this is post-Lean artifact verification |
| `error_class` | `source_translation_gap` |
| `next_route` | Generate `qiskit/`, `qasm3/`, and manifest artifacts from `mainCaseColdPartialPermVerified` using `q[0]=S`, `q[1]=tau`, `q[2]=T`, `q[3]=signal`, then rerun this verifier. |

## Rejection

Do not advance executable export review from `export-plan.md` alone.  The next
narrow route is `MAIN-EXPORT-IMPLEMENT-001`: generate the Qiskit/QASM3/manifest
artifacts for the certified transcript
`X_T; CCX_tau,T->signal; X_tau; CX_signal->T; CX_tau->signal`, expose a
deterministic 16-state basis-action table or function, and rerun this checker.

This rejection is now retired because `MAIN-EXPORT-IMPLEMENT-001` and
`MAIN-EXPORT-VERIFY-001` completed in the later accepted packet named above.
