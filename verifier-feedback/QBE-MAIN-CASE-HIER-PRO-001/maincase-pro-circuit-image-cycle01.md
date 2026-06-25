# Lower Verifier Feedback: Pro Circuit Image

## Active Leaf

`MAINCASE-PRO-CIRCUIT-IMAGE-001`

This diagnostic is necessary because the next proposed Lean theorem would state
that the advertised transcript `CCX012; CX21; CX20; X2` realizes
`mainCaseProCandidateImage` on all 16 full basis states.  A single finite
counterexample is enough to reject that theorem target before a Lean worker
spends proof effort on it.

## Diagnostic

Executable diagnostic:
`verifier-feedback/QBE-MAIN-CASE-HIER-PRO-001/maincase_pro_circuit_image_diag.py`

Lean-local diagnostic:
`QuantumBlockEncoding/MainCase.lean` contains the task-local declarations
`mainCaseProCircuitImage`, `mainCaseProCircuitImage_candidate_mismatch_set`,
`mainCaseProCircuitImage_not_pointwise_candidate`,
`mainCaseProCircuit_blockProjection`, and `mainCaseProCircuitVerified`;
`Tests/Basic.lean` contains focused examples checking those declarations.

- the all-state equality with `mainCaseProCandidateImage` is false;
- dirty inputs `8`, `9`, `12`, and `13` are the mismatch set;
- the clean columns that feed the block-entry theorem still match the target
  source branch.

The full index convention is `signal * 8 + 4*T + 2*tau + S`, so the full wire
map is `S=0`, `tau=1`, `T=2`, `signal=3`.

## Finite Results

| Input | Pro transcript image | Current candidate image |
|---:|---:|---:|
| 8 | 6 | 2 |
| 9 | 7 | 3 |
| 12 | 2 | 6 |
| 13 | 3 | 7 |

All other inputs agree.  The clean input columns `0..7` agree with the current
candidate, and the extracted clean block has no bad entries against
`mainCaseProTarget`.

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `MAINCASE-PRO-CIRCUIT-IMAGE-001` |
| `source_correspondence_ok` | `false` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `finite_matrix_ok` | `true` for the split candidate; `false` for equality with `mainCaseProCandidateImage` |
| `block_entry_ok` | `true` |
| `ancilla_cleanup_ok` | `true` for the clean-block diagnostic |
| `normalizer_ok` | `true` |
| `resource_score` | `(4,4,1,0)` |
| `auxiliary_qubits` | `1` |
| `gate_count` | `4` |
| `depth` | `4` |
| `oracle_calls` | `0` |
| `closed_theorem_ok` | `true` for `mainCaseProCircuitImage_candidate_mismatch_set` and `mainCaseProCircuitVerified`; `false` for rejected equality theorem |
| `error_class` | `finite_matrix_counterexample` |
| `next_route` | Do not retry `mainCaseProCircuitImage_eq_candidate`. Next Lean leaf is the rational-orthogonality bridge, unless reviewer asks for export-policy alignment first. |

## Rejection

The theorem target

```lean
theorem mainCaseProCircuitImage_eq_candidate :
    forall x : Fin 16,
      mainCaseProCircuitImage x = mainCaseProCandidateImage x
```

is false for the current candidate table.  The mismatch is only on dirty input
columns, so this does not refute the clean-block theorem already compiled for
`mainCaseProCandidateMatrix`.  It refutes the stronger source-correspondence
claim that the four-gate transcript and the current finite candidate are the
same permutation.

## Compiled Split

The separate gate-derived transcript candidate is now named by:

- `mainCaseProCircuitImage_candidate_mismatch_set`
- `mainCaseProCircuitImage_permutation_certificate`
- `mainCaseProCircuit_blockProjection`
- `mainCaseProCircuitCandidate_cost`
- `mainCaseProCircuitVerified`

Gate results: `python3 tools/qbe.py check` passed; `lake build && lake build Tests`
passed.
