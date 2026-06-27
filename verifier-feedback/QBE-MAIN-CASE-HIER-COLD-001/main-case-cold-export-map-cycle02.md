# Verifier Feedback: MAIN-EXPORT-MAP-001 Cycle 2

Task: `QBE-MAIN-CASE-HIER-COLD-001`

Run: `20260627-125940-QBE-MAIN-CASE-HIER-COLD-001-cycle02`

## Verdict

The export-map source contract is repaired.  The export plan and lower packet
now use Lean integer bit weights `S=0`, `tau=1`, `T=2`, and `signal=3` for the
full index `8*signal + 4*T + 2*tau + S`.  This retires the stale map
`T=0`, `tau=1`, `S=2`, `signal=3`.

No Qiskit/QASM3 implementation is accepted by this packet.  The next route is
to generate `qiskit/`, `qasm3/`, and manifest artifacts from
`mainCaseColdPartialPermVerified`, then rerun deterministic export verification.

## Fields

| Field | Value |
|---|---|
| `leaf` | `MAIN-EXPORT-MAP-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `finite_matrix_ok` | `null`; no generated executable artifacts exist yet |
| `block_entry_ok` | `null`; deferred to `MAIN-EXPORT-VERIFY-001` |
| `ancilla_cleanup_ok` | `true` for metadata; deferred for generated action |
| `normalizer_ok` | `true` |
| `unitarity_ok` | `true` at the compiled finite-permutation tier |
| `resource_score` | `(5,5,1,0)` |
| `auxiliary_qubits` | `1` |
| `gate_count` | `5` |
| `depth` | `5` |
| `oracle_calls` | `0` |
| `closed_theorem_ok` | `false`; this is a post-Lean export-map repair, not a new Lean theorem |
| `error_class` | `null` |
| `next_route` | `MAIN-EXPORT-IMPLEMENT-001`: generate Qiskit/QASM3/manifest artifacts using `q[0]=S`, `q[1]=tau`, `q[2]=T`, `q[3]=signal`, then rerun the export verifier. |

## Reuse

The repaired packet consumes `mainCaseColdPartialPermVerified`,
`mainCaseColdPartialPermCandidate_cost`, `mainCaseColdCircuitImage_eq_partialPermImage`,
and `mainCaseColdPartialPermImage`.  It does not use `mainCasePro*` declarations,
previous executable exports, LCU, QSVT, sparse access, or dilation routes.
