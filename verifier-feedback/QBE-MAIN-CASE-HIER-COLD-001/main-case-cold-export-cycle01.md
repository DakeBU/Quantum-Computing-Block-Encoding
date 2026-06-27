# Verifier Feedback: MAIN-EXPORT-001

Task: `QBE-MAIN-CASE-HIER-COLD-001`

Run: `20260627-122318-QBE-MAIN-CASE-HIER-COLD-001-cycle01`

## Active Leaf

`MAIN-EXPORT-001` is the current frontier after
`mainCaseColdPartialPermCandidate`, `mainCaseColdPartialPermVerified`, and
`mainCaseColdPartialPermCandidate_cost` compiled.  The diagnostic is a
necessary condition because any Qiskit/QASM3 export must preserve the exact
finite action certified by `mainCaseColdPartialPermImage` before it can be
reviewed as a faithful post-Lean artifact.

## Diagnostic

Added executable checker:

```bash
python3 verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/main-case-cold-export-cycle01.py
```

The checker compares an exported deterministic `basis_action` or
`BASIS_ACTION` table against the COLD finite table on all 16 basis states,
then checks clean-block support, passive `S` preservation, normalizer/resource
metadata, QASM3 presence, and absence of generated `mainCasePro*` evidence.

## Verdict

Reject export review for this cycle.  The Lean-certified reference table passes
the local support/permutation/passive-bit sanity check, but the export root
currently contains only `export-plan.md`; there is no `qiskit/` implementation,
no `qasm3/` file, and no generated manifest to compare against
`mainCaseColdPartialPermVerified`.

This is not a counterexample to the COLD Lean target.  It is a post-Lean
source-translation gap for `MAIN-EXPORT-001`.

## Fields

| Field | Value |
|---|---|
| `leaf` | `MAIN-EXPORT-001` |
| `source_correspondence_ok` | `false` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `finite_matrix_ok` | `false` for exported artifacts; reference COLD table check is `true` |
| `block_entry_ok` | `false` for exported artifacts; reference clean support is `{(0,6),(1,7)}` |
| `ancilla_cleanup_ok` | `false` for exported artifacts; no exported basis action exists |
| `normalizer_ok` | `false` for exported artifacts; no manifest exists |
| `unitarity_ok` | `false` for exported artifacts; no exported basis action exists |
| `resource_score` | expected `(5,5,1,0)` |
| `closed_theorem_ok` | `false` because this is an export verifier, not a Lean theorem |
| `error_class` | `source_translation_gap` |
| `next_route` | Generate `qiskit/`, `qasm3/`, and manifest artifacts from `mainCaseColdPartialPermVerified`, then rerun the checker. |

## Rejection

Do not advance Qiskit/QASM3 export review or claim executable export completion
from the plan file alone.  The next implementation pass should create the
export artifacts with a deterministic basis-action checker, preserving the Lean
integer bit positions `S=0`, `tau=1`, `T=2`, `signal=3` and full index
convention `8*signal + 4*T + 2*tau + S`.  For Qiskit integer-basis checks, use
`q[0]=S`, `q[1]=tau`, `q[2]=T`, and `q[3]=signal`.  The earlier export packet
sentence using `T=0`, `tau=1`, `S=2`, `signal=3` as integer wire weights is
stale and must not guide generated artifacts.
