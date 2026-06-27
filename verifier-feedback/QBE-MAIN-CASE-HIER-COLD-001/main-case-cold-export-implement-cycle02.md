# Verifier Feedback: MAIN-EXPORT-VERIFY-001 Cycle 2

Task: `QBE-MAIN-CASE-HIER-COLD-001`

Run: `20260627-125940-QBE-MAIN-CASE-HIER-COLD-001-cycle02`

## Verdict

The post-Lean executable export artifacts now exist and pass deterministic
finite checks against the compiled COLD certificate
`mainCaseColdPartialPermVerified`.

Generated artifacts:

- `executable-exports/QBE-MAIN-CASE-HIER-COLD-001/qiskit/export.py`
- `executable-exports/QBE-MAIN-CASE-HIER-COLD-001/qasm3/main_case_cold_partial_perm.qasm3`
- `executable-exports/QBE-MAIN-CASE-HIER-COLD-001/export-manifest.json`
- `executable-exports/QBE-MAIN-CASE-HIER-COLD-001/main_case_cold_export_check.py`

## Checks

The export uses the repaired Lean/Qiskit wire convention
`q[0]=S`, `q[1]=tau`, `q[2]=T`, `q[3]=signal`, so the integer index is
`8*signal + 4*T + 2*tau + S`.

The exported transcript is:

```text
X_T; CCX_tau,T->signal; X_tau; CX_signal->T; CX_tau->signal
```

The deterministic basis action is
`[14,15,8,9,10,11,0,1,2,3,4,5,6,7,12,13]`, matching
`mainCaseColdPartialPermImage`.  The clean block has support `{(0,6),(1,7)}`,
passive `S` is preserved, the action is a permutation, normalizer is `1`,
epsilon is `0`, and the resource tuple is `(5,5,1,0)`.

## Commands

```bash
python3 executable-exports/QBE-MAIN-CASE-HIER-COLD-001/qiskit/export.py --json
python3 executable-exports/QBE-MAIN-CASE-HIER-COLD-001/main_case_cold_export_check.py
python3 verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/main-case-cold-export-cycle01.py
```

All three commands returned exit code `0`.

## Fields

| Field | Value |
|---|---|
| `leaf` | `MAIN-EXPORT-VERIFY-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `null`; no Lean edit in this leaf |
| `lean_build_ok` | `null`; checked by the final project gate |
| `finite_matrix_ok` | `true` |
| `block_entry_ok` | `true` |
| `ancilla_cleanup_ok` | `true` |
| `normalizer_ok` | `true` |
| `unitarity_ok` | `true` |
| `resource_score` | `(5,5,1,0)` |
| `closed_theorem_ok` | `false`; this leaf generated post-Lean artifacts and consumes the existing Lean certificate |
| `error_class` | `null` |
| `next_route` | Reviewer should audit the post-Lean executable artifacts against the named Lean certificate. |
