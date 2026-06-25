# Middle Source Contract: QBE-MAIN-CASE-HIER-PRO-001 Cycle 3

## Source Anchors

The active source object is the user task packet for
`QBE-MAIN-CASE-HIER-PRO-001`, specifically the fixed operator contract

$$
E_1 = |0><1|_T \otimes |0><1|_{\tau} \otimes I_S
$$

and the external Pro transcript `CCX012; CX21; CX20; X2`.  No local paper-source
archive was detected, so this contract uses the task packet and Pro packet as
the source anchors.

## Lean Correspondence

The fixed operator, projector, and normalizer are represented by
`mainCaseProTarget`, `mainCaseProBlockProjection`,
`mainCaseProSignalIndex`, `mainCaseProExactNormalizer`, and
`mainCaseProQueryTarget_normalizer`.

The export-facing Pro transcript candidate is represented by
`mainCaseProCircuitImage`, `mainCaseProCircuitMatrix`,
`mainCaseProCircuitImage_permutation_certificate`,
`mainCaseProCircuitMatrix_isRationalOrthogonal`,
`mainCaseProCircuit_blockProjection`, `mainCaseProCircuitCandidate`,
`mainCaseProCircuitVerified`, and `mainCaseProCircuitCandidate_cost`.

The matrix-table incumbent `mainCaseProCandidateImage` remains a compiled
partial-permutation clean-block candidate, but it is not the Pro transcript
certificate.  The theorem `mainCaseProCircuitImage_candidate_mismatch_set`
proves that the transcript image differs from `mainCaseProCandidateImage`
exactly on dirty inputs `8`, `9`, `12`, and `13`.

## Ownership Split

The active task owns the operator $E_1$, clean signal `0`, normalizer `1`,
exact error `0`, and benchmark instantiation `r=1`, `k=1`,
`passiveQubits=1`.

The external Pro packet owns only the transcript
`CCX012; CX21; CX20; X2` under the full wire map
`S=0`, `tau=1`, `T=2`, `signal=3`.

QBE-local semantic glue owns the finite transcript image, permutation matrix,
clean-block theorem, rational-orthogonality bridge, and resource tuple
`(gateCount=4, depth=4, auxiliaryQubits=1, oracleCalls=0)`.

No external cited result is needed for this cycle.  The textbook route remains
`BE.PartialPermutation.MatrixUnitTensorId` with `BE.PermMatrix.CleanBlock` and
`BE.Tensor.PassiveRegister`; LCU, sparse-access, dilation, and QSVT stay
archived alternatives.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `MAINCASE-PRO-CIRCUIT-IMAGE-001` | Gate-derived Pro transcript image preserves the clean block and is not the matrix-table image on dirty inputs. | Pro packet, fixed target | lower 2/lower 3 | `mainCaseProCircuitImage_candidate_mismatch_set`, `mainCaseProCircuitVerified` | verifier feedback cycle 1 | `python3 tools/qbe.py check` | proved split |
| `MAINCASE-PRO-ORTHO-BRIDGE-001` | Promote bijective `permMatrix` candidates to rational row/column Gram orthogonality. | finite permutation certificates | lower 2/refiner | `BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective`, `mainCaseProCircuitMatrix_isRationalOrthogonal` | verifier feedback cycle 2 | `python3 tools/qbe.py check`; `lake build && lake build Tests` | proved |
| `MAINCASE-PRO-SEMANTIC-TIER-001` | Select the export-facing certificate whose circuit, schedule, matrix image, block theorem, and cost are aligned. | circuit image, orthogonality bridge, resource theorem | middle/reviewer/lower 3 | `mainCaseProCircuitVerified`, `mainCaseProCircuitCandidate_cost` | this packet | `python3 tools/qbe.py check`; `lake build && lake build Tests` | accepted semantic-tier gate |
| `MAINCASE-PRO-EXPORT-001` | Generate Qiskit and QASM3 artifacts from the accepted Pro transcript certificate. | `MAINCASE-PRO-SEMANTIC-TIER-001` | export worker | none yet | `executable-exports/QBE-MAIN-CASE-HIER-PRO-001/export-plan.md` | export checker plus project gates | active export implementation pending |

## Lower-Facing Source Contract

Use `mainCaseProCircuitVerified` as the sole Lean certificate for Qiskit/QASM3
planning.  The export packet must record:

- Lean source declaration: `mainCaseProCircuitVerified`.
- Cost theorem: `mainCaseProCircuitCandidate_cost`.
- Register sizes: one clean signal qubit and three system qubits `(T,tau,S)`.
- Concrete instantiation: `r=1`, `k=1`, `passiveQubits=1`.
- Normalizer: `mainCaseProExactNormalizer = 1`.
- Projector: clean signal index `mainCaseProSignalIndex = 0`.
- Transcript: `CCX012; CX21; CX20; X2`, with bit order
  `bit 0 = tau`, `bit 1 = T`, `bit 2 = signal` in the reduced transcript and
  full wire map `S=0`, `tau=1`, `T=2`, `signal=3`.
- Resource tuple: `(4,4,1,0)`.
- Export check: generated basis action equals `mainCaseProCircuitImage`; clean
  block equals `mainCaseProTarget`; stale equality to
  `mainCaseProCandidateImage` remains rejected on dirty inputs `8`, `9`,
  `12`, and `13`.

Reject any export that cites `mainCaseProVerified` or
`mainCaseProCandidate_cost` as the Pro transcript certificate.
