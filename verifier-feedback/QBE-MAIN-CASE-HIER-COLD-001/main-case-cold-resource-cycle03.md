# Verifier Feedback: COLD Resource Readiness Cycle 3

Task: `QBE-MAIN-CASE-HIER-COLD-001`

Leaf: `MAIN-RESOURCE-001`

## Necessary Condition

This leaf serves the future COLD candidate package and executable-export route.
It is necessary because a verified block-encoding candidate cannot honestly
advertise a ranked resource tuple until the COLD arm has a task-local circuit or
resource model with certified field theorems.

The diagnostic rechecks the existing finite table before looking at resources:

- `mainCaseColdPartialPermImage` is a bijective table on `Fin 16`.
- The clean block has support exactly `(row,col) = (0,6)` and `(1,7)`.
- The clean signal and normalizer remain `0` and `1`.
- The resource layer is still open: `mainCaseColdResourceSchemaObligation.proved = false`.

## Result

No finite matrix or block-entry contradiction was found.  The block/projection
layer can stay closed under `mainCaseColdPartialPerm_blockProjection`.

The active resource leaf is not closed.  There is no COLD
`mainCaseColdPartialPermCost`, no cost field theorem set, no COLD
`OperatorBlockEncodingCandidate`, and no COLD `VerifiedOperatorBlockEncoding`.

Reject any route that packages `mainCaseColdPartialPermCandidate`,
`mainCaseColdPartialPermVerified`, or Qiskit/QASM3 exports before a COLD-local
circuit/resource schema and `mainCaseColdPartialPermCost_*` field theorems
compile.

## Typed Fields

| Field | Value |
|---|---|
| `leaf` | `MAIN-RESOURCE-001` |
| `source_correspondence_ok` | `true` |
| `finite_matrix_ok` | `true` |
| `block_entry_ok` | `true` |
| `ancilla_cleanup_ok` | `true` |
| `normalizer_ok` | `true` |
| `unitarity_ok` | `finite_permutation_tier_true` |
| `resource_score` | `{ "gate_count": null, "depth": null, "auxiliary_qubits": 1, "oracle_calls": null }` |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | Derive a COLD-local circuit/schedule or named resource model, then prove `mainCaseColdPartialPermCost_*` field theorems before candidate packaging or export. |
