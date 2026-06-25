# Lower Proof Architect Packet: Export Semantic Tier

Task: `QBE-MAIN-CASE-HIER-PRO-001`  
Leaf: `MAINCASE-PRO-EXPORT-001`  
Run: `20260626-001055-QBE-MAIN-CASE-HIER-PRO-001-cycle03`  
Role: lower natural-language proof architect  
Timestamp: `2026-06-26 00:35 JST`

## Source Fragment

No local paper-source archive was detected for this task.  The source fragment
being translated is the task packet plus the external Pro packet
`task-inbox/QBE-MAIN-CASE-HIER-PRO-001/pro_construction_packet.md`.

The fixed operator is

$$
E_1 = |0><1|_T \otimes |0><1|_{\tau} \otimes I_S.
$$

The required clean-block equation is

$$
(<0|_a \otimes I) U (|0>_a \otimes I) = E_1.
$$

The Pro packet supplies the transcript

```text
CCX012; CX21; CX20; X2
```

with reduced bits `0 = tau`, `1 = T`, `2 = signal`.  The task-local full wire
map is `S=0`, `tau=1`, `T=2`, `signal=3`, and the full basis index convention
is `signal * 8 + 4*T + 2*tau + S`.

Cycle 3 already accepted the semantic-tier split.  The export-facing certificate
is `mainCaseProCircuitVerified` with cost theorem
`mainCaseProCircuitCandidate_cost`.  The compiled matrix-table incumbent
`mainCaseProVerified` is not the Pro transcript certificate, because
`mainCaseProCircuitImage_candidate_mismatch_set` proves dirty-column mismatch
against `mainCaseProCandidateImage` on exactly `8`, `9`, `12`, and `13`.

## Definitions

Define the target matrix `A` to be `mainCaseProTarget`, the Lean name for
$E_1$.  It has nonzero entries only from source columns
`mainCaseProSystemIndex 1 1 s` to target rows
`mainCaseProSystemIndex 0 0 s` for `s : Fin 2`.

Define the clean projector by `mainCaseProSignalIndex = 0` and
`mainCaseProBlockProjection`.  This predicate expands to pointwise equality
between the signal-system block projection of a `16 x 16` matrix and
`mainCaseProTarget`.

Define the export-facing unitary candidate by the Pro transcript image
`mainCaseProCircuitImage` and matrix `mainCaseProCircuitMatrix`.  The candidate
record is `mainCaseProCircuitCandidate`, and the verified package is
`mainCaseProCircuitVerified`.

Define the export checker contract as follows.  A Qiskit or QASM3 artifact is
acceptable only if its computational-basis action on the 16 full states equals
`mainCaseProCircuitImage`.  Once this equality is checked, the exported circuit
inherits the Lean block-entry, finite-permutation, and resource claims through
the accepted Lean declarations listed below; the executable artifact itself is
not a substitute for those declarations.

## Natural-Language Proof

Claim.  Any executable export whose basis action is exactly
`mainCaseProCircuitImage` realizes the same clean block as
`mainCaseProCircuitVerified` and therefore block-encodes `mainCaseProTarget`
with normalizer `1`.

Proof.  The Lean declaration `mainCaseProCircuitImage_permutation_certificate`
proves that `mainCaseProCircuitImage` is a bijection on `Fin 16`.  The matrix
`mainCaseProCircuitMatrix` is `BlockEncodingClassics.permMatrix
mainCaseProCircuitImage`, so the candidate is a finite permutation matrix.
The declaration `mainCaseProCircuitMatrix_isRationalOrthogonal` records the
project-local rational row and column Gram condition for that matrix.

The declaration `mainCaseProCircuit_blockProjection` proves
`mainCaseProBlockProjection mainCaseProCircuitMatrix`.  By the definition of
`mainCaseProBlockProjection`, the clean signal block selected by
`mainCaseProSignalIndex = 0` equals `mainCaseProTarget` pointwise.  The theorem
`mainCaseProQueryTarget_normalizer` identifies the normalizer with
`mainCaseProExactNormalizer = 1`, and `mainCaseProSourceLayout_auxiliaryQubits`
identifies the single clean signal qubit.

The declaration `mainCaseProCircuitVerified` packages the permutation proof and
the block-projection proof for `mainCaseProCircuitCandidate`.  The declaration
`mainCaseProCircuitCandidate_cost` proves that the logical-library score is
`(gateCount=4, depth=4, auxiliaryQubits=1, oracleCalls=0)`.

Now suppose an exported Qiskit or QASM3 circuit has basis action
`mainCaseProCircuitImage` on all full inputs.  Its induced permutation matrix
is entrywise the same permutation matrix as `mainCaseProCircuitMatrix`, because
both send each computational-basis column `c` to the row
`mainCaseProCircuitImage c`.  Therefore the exported circuit has the same clean
block as `mainCaseProCircuitMatrix`, hence the same pointwise equality with
`mainCaseProTarget`.  The resource tuple is the source-level transcript tuple
already certified by `mainCaseProCircuitCandidate_cost`; the export checker may
also count the four logical operations in the generated artifact as a
consistency diagnostic.

The proof does not require the all-state equality
`mainCaseProCircuitImage = mainCaseProCandidateImage`.  That equality is false,
and the mismatch is confined to dirty columns, so it is irrelevant to the clean
block but decisive for export provenance.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `MAINCASE-PRO-SOURCE-001` | Fixed operator, clean signal, normalizer, exact error, and layout. | task packet, Pro packet | middle | `mainCaseProTarget`, `mainCaseProBlockProjection`, `mainCaseProQueryTarget_normalizer`, `mainCaseProSourceLayout_auxiliaryQubits` | conversion window | `python3 tools/qbe.py check` | proved |
| `MAINCASE-PRO-CIRCUIT-IMAGE-001` | Gate-derived Pro transcript image and dirty-column split from the matrix-table image. | Pro packet, source target | lower 2/lower 3 | `mainCaseProCircuitImage`, `mainCaseProCircuitImage_candidate_mismatch_set`, `mainCaseProCircuitImage_not_pointwise_candidate` | circuit-image proof packet | `python3 tools/qbe.py check` | proved split |
| `MAINCASE-PRO-CIRCUIT-PERM-001` | Pro transcript image is a finite permutation. | `MAINCASE-PRO-CIRCUIT-IMAGE-001` | lower 2 | `mainCaseProCircuitImage_permutation_certificate` | conversion window | `python3 tools/qbe.py check` | proved |
| `MAINCASE-PRO-CIRCUIT-BLOCK-001` | Clean block of the Pro transcript matrix equals `mainCaseProTarget`. | `MAINCASE-PRO-CIRCUIT-IMAGE-001`, source target | lower 2 | `mainCaseProCircuit_cleanEntry`, `mainCaseProCircuit_blockProjection` | conversion window | `python3 tools/qbe.py check` | proved |
| `MAINCASE-PRO-ORTHO-BRIDGE-001` | Bijective `permMatrix` gives rational row and column Gram orthogonality. | permutation certificate | lower 2/refiner | `BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective`, `mainCaseProCircuitMatrix_isRationalOrthogonal` | ortho-bridge proof packet | `python3 tools/qbe.py check`; `lake build && lake build Tests` | proved |
| `MAINCASE-PRO-RESOURCE-001` | Logical-library resource tuple is `(4,4,1,0)`. | transcript metadata, layout | middle/lower 2 | `mainCaseProHighLevelSeedCost_*`, `mainCaseProCircuitCandidate_cost` | candidate population | `python3 tools/qbe.py check` | proved |
| `MAINCASE-PRO-SEMANTIC-TIER-001` | Select the aligned export-facing certificate, not the matrix-table incumbent. | circuit image, block theorem, orthogonality bridge, resource theorem | middle/reviewer | `mainCaseProCircuitVerified`, `mainCaseProCircuitCandidate_cost` | middle source contract cycle 3 | `python3 tools/qbe.py check`; `lake build && lake build Tests` | accepted |
| `MAINCASE-PRO-EXPORT-001` | Generate Qiskit and QASM3 artifacts and check basis action against `mainCaseProCircuitImage`. | `MAINCASE-PRO-SEMANTIC-TIER-001` | export worker/lower 3 | no Lean declaration expected | this packet and `executable-exports/QBE-MAIN-CASE-HIER-PRO-001/export-plan.md` | export checker; `python3 tools/qbe.py check`; `lake build && lake build Tests` | next active leaf |

The next active leaf for a Lean or export worker is `MAINCASE-PRO-EXPORT-001`.
No new Lean theorem is required unless the export checker exposes a mismatch
between generated basis action and `mainCaseProCircuitImage`.

## Ordered Lean Declarations To Reuse

1. `mainCaseProTarget`: target matrix for
   $|0><1|_T \otimes |0><1|_{\tau} \otimes I_S$.
2. `mainCaseProSignalIndex` and `mainCaseProBlockProjection`: exact clean-block
   selector and predicate.
3. `mainCaseProCircuit`: transcript metadata for
   `CCX012; CX21; CX20; X2`.
4. `mainCaseProCircuitImage`: basis action induced by that transcript under
   the task-local wire map.
5. `mainCaseProCircuitImage_candidate_mismatch_set` and
   `mainCaseProCircuitImage_not_pointwise_candidate`: stale-route rejection
   against `mainCaseProCandidateImage`.
6. `mainCaseProCircuitImage_permutation_certificate`: finite reversibility
   certificate for the transcript image.
7. `mainCaseProCircuitMatrix` and
   `mainCaseProCircuitMatrix_isRationalOrthogonal`: matrix and rational
   orthogonality bridge.
8. `mainCaseProCircuit_cleanEntry` and `mainCaseProCircuit_blockProjection`:
   clean-entry and clean-block equality for the transcript matrix.
9. `mainCaseProCircuitCandidate` and `mainCaseProCircuitVerified`: accepted
   export-facing package.
10. `mainCaseProCircuitCandidate_cost`: score tuple
    `(gateCount=4, depth=4, auxiliaryQubits=1, oracleCalls=0)`.

The export worker should not reuse `mainCaseProVerified` or
`mainCaseProCandidate_cost` as the Pro transcript certificate.  Those
declarations certify the matrix-table incumbent `MAINCASE-PRO-PERM-001`.

## Failure Analysis

The current target is mathematically sound.  The active problem is not a new
block-encoding proof; it is export provenance.  An export rooted at
`mainCaseProCircuitVerified` is aligned because its circuit field, schedule,
matrix image, block theorem, orthogonality instance, and cost theorem all refer
to the Pro transcript route.

The mathematically wrong route is to export from `mainCaseProVerified` or to
cite `mainCaseProCandidate_cost` as the Pro transcript score.  That route
silently switches to the finite matrix-table completion
`mainCaseProCandidateImage`, whose full image differs from the transcript image
on dirty columns `8`, `9`, `12`, and `13`.  The mismatch does not break the
clean block, but it breaks the claim that the generated Qiskit/QASM3 artifact
is certified by the named Lean candidate.

Do not change `mainCaseProTarget`, `mainCaseProExactNormalizer`,
`mainCaseProSignalIndex`, either image table, or the score tuple.  If the
export checker finds a basis-action mismatch, record it as
`finite_matrix_counterexample` and repair the export artifact, not the Lean
target.

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `MAINCASE-PRO-EXPORT-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `not_applicable_no_lean_edit` |
| `lean_build_ok` | `not_applicable_no_lean_edit`; project gate must still pass for the run |
| `finite_matrix_ok` | `true_for_existing_lean_certificate`; export check pending |
| `block_entry_ok` | `true` |
| `ancilla_cleanup_ok` | `true` |
| `normalizer_ok` | `true` |
| `unitarity_ok` | `true` |
| `resource_score` | `(4,4,1,0)` |
| `gate_count` | `4` |
| `depth` | `4` |
| `auxiliary_qubits` | `1` |
| `oracle_calls` | `0` |
| `closed_theorem_ok` | `true_for_semantic_tier`; executable export pending |
| `error_class` | `none` |
| `next_route` | Generate Qiskit and QASM3 artifacts from `mainCaseProCircuitVerified`, then check basis action against `mainCaseProCircuitImage`. |

## Handoff

Export worker should generate Qiskit and QASM3 artifacts under
`executable-exports/QBE-MAIN-CASE-HIER-PRO-001/` using
`mainCaseProCircuitVerified` as the Lean source declaration.  The checker must
verify all 16 basis images against `mainCaseProCircuitImage`, verify the clean
block against `mainCaseProTarget`, preserve normalizer `1`, preserve the score
`(4,4,1,0)`, and reject any export rooted at `mainCaseProVerified`.
