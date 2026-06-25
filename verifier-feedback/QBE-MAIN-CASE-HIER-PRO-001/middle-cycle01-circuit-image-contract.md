# Middle Verifier Feedback: Circuit-Image Source Contract

## Leaf

`MAINCASE-PRO-CIRCUIT-IMAGE-001`

## Result

The source correspondence for the target operator is stable:
`mainCaseProTarget`, `mainCaseProBlockProjection`,
`mainCaseProCandidateImage`, `mainCaseProCandidate_blockProjection`, and
`mainCaseProCandidate_cost` compile at the finite-permutation clean-block tier.

The active gap is narrower than the old orthogonality leaf.  The task-local
candidate record still names `mainCaseProCircuit`, `mainCaseProSchedule`, and
the resource tuple `(4,4,1,0)`, but there is no task-local theorem proving that
the transcript `CCX012; CX21; CX20; X2` realizes
`mainCaseProCandidateImage`.

## Typed Status

| Field | Value |
|---|---|
| `leaf` | `MAINCASE-PRO-CIRCUIT-IMAGE-001` |
| `source_correspondence_ok` | `false` until transcript-image equality is proved or the candidate is split |
| `lean_parse_ok` | `true` for existing files before this lower leaf |
| `lean_build_ok` | `true` for existing finite-permutation tier before this lower leaf |
| `finite_matrix_ok` | `null`; lower 3 must check all 16 states |
| `block_entry_ok` | `true` for `mainCaseProCandidate_blockProjection` |
| `ancilla_cleanup_ok` | `true` for the compiled finite-permutation clean block; transcript cleanup still unproved |
| `normalizer_ok` | `true` |
| `unitarity_ok` | `true` at finite-bijection tier; rational-orthogonality bridge remains queued |
| `resource_score` | `(4,4,1,0)` |
| `auxiliary_qubits` | `1` |
| `gate_count` | `4` |
| `depth` | `4` |
| `oracle_calls` | `0` |
| `closed_theorem_ok` | `false` for the circuit-image source contract |
| `error_class` | `source_translation_gap` |

## Next Route

Define a task-local gate-image evaluator for full wires
`S=0`, `tau=1`, `T=2`, `signal=3`, then prove
`mainCaseProCircuitImage_eq_candidate` or record the all-state mismatch set and
split the finite-permutation candidate from the gate-derived transcript.
