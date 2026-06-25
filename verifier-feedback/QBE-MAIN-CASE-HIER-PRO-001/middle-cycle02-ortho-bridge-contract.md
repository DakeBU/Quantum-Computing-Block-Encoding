# Middle Verifier Feedback: Ortho Bridge Contract

## Leaf

`MAINCASE-PRO-ORTHO-BRIDGE-001`

## Result

Middle source correspondence accepts the cycle-1 Pro transcript split and
retires `mainCaseProCircuitImage_eq_candidate`.  The clean-block theorem and
resource tuple remain compiled for both `mainCaseProVerified` and
`mainCaseProCircuitVerified`.

The next lower packet is not a new circuit search.  It is a semantic bridge
from a bijective `BlockEncodingClassics.permMatrix` to a rational
Gram/orthogonality predicate.  The preferred proof is shared in
`BlockEncodingClassics.lean`; the fallback is a finite task-local theorem for
`mainCaseProCircuitMatrix`.

## Typed Status

| Field | Value |
|---|---|
| `leaf` | `MAINCASE-PRO-ORTHO-BRIDGE-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `not_run` |
| `finite_matrix_ok` | `true` from prior clean-block and permutation certificates |
| `block_entry_ok` | `true` |
| `ancilla_cleanup_ok` | `true` |
| `normalizer_ok` | `true` |
| `unitarity_ok` | `false` for the stronger rational-orthogonality predicate |
| `resource_score` | `(4,4,1,0)` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | Prove a shared `permMatrix` rational-orthogonality bridge, or a finite task-local fallback for `mainCaseProCircuitMatrix`. |

## Guardrail

Do not import an `OptimalControl.lean` theorem as a certificate for this
isolated task.  Local definitions may be promoted to the shared library if the
existing references are updated coherently.
