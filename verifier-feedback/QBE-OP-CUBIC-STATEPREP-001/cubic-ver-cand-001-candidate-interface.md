# Verifier Feedback: CUBIC-VER-CAND-001 Candidate Interface

Task: `QBE-OP-CUBIC-STATEPREP-001`
Leaf: `CUBIC-VER-CAND-001`
Executable diagnostic:
`verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic_ver_cand_001_candidate_interface_check.py`

## Scope

This packet checks whether a block-entry verifier can run for the first
candidate family.  The active target is the unnormalized rank-one operator

$$
O_n = |v_n\rangle\langle 0^n|,\qquad v_n[j] = (j/2^n)^3.
$$

For `CUBIC-VER-CAND-001`, a concrete candidate interface is a necessary
condition: the verifier needs a named `U_n`, ancilla count, clean-block
projector, normalizer `alpha`, and error budget before any finite block-entry
or unitarity check can correspond to the Lean target.

## Command

```bash
python3 verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic_ver_cand_001_candidate_interface_check.py
```

## Diagnostic Rows

| n | N | rank_one_target_shape_ok | unnormalized | norm_sq approx |
|---:|---:|---|---|---:|
| 1 | 2 | true | true | 0.015625 |
| 2 | 4 | true | true | 0.19384765625 |
| 3 | 8 | true | true | 0.705032348633 |
| 4 | 16 | true | true | 1.81692361832 |

The finite rows are a target-shape guard only.  They confirm that the current
diagnostic is still checking the unnormalized rank-one operator and not a
normalized state-preparation shortcut.

## Interface Check

Current task-local candidate records do not yet provide a concrete block
encoding interface.  The missing pieces are:

| Required candidate field | Status |
|---|---|
| `U_n` family | missing |
| register layout and ancilla count | missing |
| clean-block projector | missing |
| normalizer `alpha` | missing |
| approximation/error budget | missing |
| resource tuple | missing |

This is a `candidate_interface_gap`.  It is a necessary-condition rejection for
starting a block-entry proof attempt, not a rejection of the cubic target.

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `CUBIC-VER-CAND-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `null` |
| `lean_build_ok` | `null` |
| `finite_matrix_ok` | `true` |
| `block_entry_ok` | `null` |
| `ancilla_cleanup_ok` | `null` |
| `normalizer_ok` | `null` |
| `unitarity_ok` | `null` |
| `resource_score` | `null` |
| `closed_theorem_ok` | `false` |
| `blocker` | `candidate_interface_gap` |
| `error_class` | `shape_or_register_gap` |
| `next_route` | `Assign CUBIC-CAND-001 to name one concrete U_n/register-layout/projector/alpha/error-budget interface, then rerun this finite block-entry verifier on n = 1..4 before a Lean worker attempts the candidate theorem.` |

## Rejection

Reject any lower proof route that starts a candidate block-entry theorem before
`CUBIC-CAND-001` supplies the concrete interface above.  Also reject any route
that replaces the target with a normalized output state: the checked norms are
not equal to `1`.
