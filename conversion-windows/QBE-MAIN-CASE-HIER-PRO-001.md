# Conversion Window: QBE-MAIN-CASE-HIER-PRO-001

## Source Anchor

The source object is the user-provided task packet in
`tasks/QBE-MAIN-CASE-HIER-PRO-001.md`, sections `Operator Contract`,
`Isolation Rule`, and `Pro Insight Packet`.  No local paper-source archive was
detected for this task.

The fixed target is

$$
E_1 = |0><1|_T \otimes |0><1|_{\tau} \otimes I_S.
$$

The reproducible benchmark has one time qubit, one type qubit, and one passive
state qubit.  The register order is `(T, tau, S)`.  The block selector is one
clean signal qubit at index `0`.  The normalizer is `1`, and the exact error
target is `0`.

## Route Decision

For $E_1$, the primary route is `BE.PartialPermutation.MatrixUnitTensorId`
with `BE.PermMatrix.CleanBlock` and `BE.Tensor.PassiveRegister`, because the
target is a matrix unit on `(T,tau)` tensored with identity on `S`.  LCU,
sparse-access, dilation, and QSVT are preserved only as background alternatives
for later mutation; they add machinery that is not needed for this exact
matrix-unit target.

The external Pro hint is translated into the task-local finite permutation
`mainCaseProCandidateImage`.  It is not allowed to inherit certification from
`OptimalControl.proEqTransfer...` or from the cold-start task names.

Current middle source-correspondence object: the Pro transcript
`CCX012; CX21; CX20; X2` under the full wire map
`S=0`, `tau=1`, `T=2`, `signal=3`.  The finite-permutation clean-block tier is
compiled.  Lower cycle 1 proved that this transcript does not realize
`mainCaseProCandidateImage`: the images differ exactly on dirty columns
`8`, `9`, `12`, and `13`.  The transcript is therefore split into its own
gate-derived candidate, `mainCaseProCircuitCandidate`.

## Symbol Map

| Source/user symbol | Lean name | Status |
|---|---|---|
| system basis `(T,tau,S)` | `mainCaseProSystemIndex` | compiled |
| target operator `E_1` | `mainCaseProTarget` | compiled |
| operator target metadata | `mainCaseProQueryTarget` | compiled |
| clean signal index | `mainCaseProSignalIndex` | compiled |
| clean embedding | `mainCaseProCleanEmbed` | compiled |
| clean block predicate | `mainCaseProBlockProjection` | compiled |
| normalizer `alpha = 1` | `mainCaseProExactNormalizer` | compiled |
| exact error `epsilon = 0` | `mainCaseProExactError` | compiled |
| layout, one signal and no pure ancilla | `mainCaseProSourceLayout` | compiled |
| Pro logical transcript | `mainCaseProCircuit`, `mainCaseProSchedule` | compiled metadata |
| high-level Pro transcript resource and score | `mainCaseProHighLevelResource`, `mainCaseProHighLevelSeedCost` | compiled with field certificates |
| candidate permutation | `mainCaseProCandidateImage`, `mainCaseProCandidatePreimage` | compiled |
| permutation certificate | `mainCaseProCandidateImage_permutation_certificate` | compiled finite-permutation tier |
| clean-entry bridge | `mainCaseProCandidate_cleanEntry` | compiled |
| exact clean-block package | `mainCaseProExactCleanBlockCertificate`, `mainCaseProExactCleanBlock_correct` | compiled |
| signal block theorem | `mainCaseProCandidate_blockProjection` | compiled |
| finite-permutation candidate package | `mainCaseProCandidate`, `mainCaseProVerified`, `mainCaseProCandidate_uses_matrix_table_metadata` | compiled as matrix-table incumbent with unresolved executable metadata; not export-facing for the Pro transcript |
| Pro transcript image and mismatch set | `mainCaseProCircuitImage`, `mainCaseProCircuitImage_candidate_mismatch_set`, `mainCaseProCircuitImage_not_pointwise_candidate` | compiled; equality with `mainCaseProCandidateImage` is false |
| Pro transcript candidate package | `mainCaseProCircuitMatrix`, `mainCaseProCircuitImage_permutation_certificate`, `mainCaseProCircuitMatrix_isRationalOrthogonal`, `mainCaseProCircuit_blockProjection`, `mainCaseProCircuitCandidate`, `mainCaseProCircuitVerified`, `mainCaseProCircuitCandidate_cost` | accepted export-facing semantic-tier object |
| matrix-orthogonality bridge | `BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective`, `mainCaseProCandidateMatrix_isRationalOrthogonal`, `mainCaseProCircuitMatrix_isRationalOrthogonal`, `mainCaseProRationalOrthogonalBridgeObligation` | compiled; obligation metadata marked proved |

## Lean Correspondence

The target matrix has two nonzero entries:

- `mainCaseProTarget (mainCaseProSystemIndex 0 0 0) (mainCaseProSystemIndex 1 1 0) = 1`, proved by `mainCaseProTarget_support_state0`.
- `mainCaseProTarget (mainCaseProSystemIndex 0 0 1) (mainCaseProSystemIndex 1 1 1) = 1`, proved by `mainCaseProTarget_support_state1`.

The block predicate is `mainCaseProBlockProjection U`.  It expands to
pointwise equality between
`signalSystemBlockProjection 2 8 8 U mainCaseProSignalIndex` and
`mainCaseProTarget`.

The reusable exact clean-block route is:

```lean
theorem mainCaseProCandidate_cleanEntry :
    forall row col : Fin 8,
      (if mainCaseProCleanEmbed row =
            mainCaseProCandidateImage (mainCaseProCleanEmbed col) then
          1
        else
          0) =
        mainCaseProTarget row col

def mainCaseProExactCleanBlockCertificate :
    BlockEncodingClassics.ExactCleanBlock 8 16

theorem mainCaseProExactCleanBlock_correct :
    Matrix.PointwiseEq
      (BlockEncodingClassics.ExactCleanBlock.clean
        mainCaseProExactCleanBlockCertificate)
      mainCaseProTarget
```

The signal-projection theorem is:

```lean
theorem mainCaseProCandidate_blockProjection :
    mainCaseProBlockProjection mainCaseProCandidateMatrix
```

The advertised Pro transcript has a separate compiled image:

```text
mainCaseProCircuitImage_candidate_mismatch_set:
  mismatch exactly on full inputs 8, 9, 12, and 13

mainCaseProCircuit_blockProjection:
  mainCaseProBlockProjection mainCaseProCircuitMatrix
```

Cycle 3 semantic-tier selection: Qiskit and QASM3 planning must use
`mainCaseProCircuitVerified` and `mainCaseProCircuitCandidate_cost`.  The
finite table candidate `mainCaseProVerified` remains a compiled clean-block
incumbent with `mainCaseProMatrixTableCircuit`,
`mainCaseProMatrixTableSchedule`, and `mainCaseProMatrixTableResource`, but it
is not the Pro transcript certificate because
`mainCaseProCircuitImage_candidate_mismatch_set` refutes equality with
`mainCaseProCandidateImage` on dirty inputs `8`, `9`, `12`, and `13`.

## Candidate Contract

Candidate `MAINCASE-PRO-PERM-001` is a 16-state permutation over
`(signal,T,tau,S)` that preserves `S`.  For each fixed `S = s`, its clean input
columns must satisfy:

| Clean input column `(T,tau,s)` | Output signal | Output `(T,tau,s)` |
|---|---:|---|
| `(1,1,s)` | `0` | `(0,0,s)` |
| `(0,0,s)` | `1` | dirty row, not in the clean block |
| `(0,1,s)` | `1` | dirty row, not in the clean block |
| `(1,0,s)` | `1` | dirty row, not in the clean block |

The concrete table in `mainCaseProCandidateImage` sends clean source columns
`6` and `7` to clean rows `0` and `1`.  The remaining clean columns are sent to
dirty rows, and the dirty columns complete the map to a bijection.

The high-level logical transcript is:

```text
CCX(type,time;signal)
CX(signal,time)
CX(signal,type)
X(signal)
```

The current score is `(gateCount=4, depth=4, auxiliaryQubits=1, oracleCalls=0)`
at this logical-library tier.  This does not claim hardware optimality,
primitive Toffoli decomposition, or export readiness.

## Source-Contract Audit

| Gate/source step | Full wires | Clean input/output requirement | Lean declaration | Status |
|---|---|---|---|---|
| source predicate `T=1` and `tau=1` | controls `2` and `1`, target `3` | set signal flag on the source subspace | `mainCaseProCircuit` first gate | metadata only |
| transfer `T=1` to `T=0` when signal is set | control `3`, target `2` | selected source reaches target time bit | `mainCaseProCircuit` second gate | metadata only |
| transfer `tau=1` to `tau=0` when signal is set | control `3`, target `1` | selected source reaches target type bit | `mainCaseProCircuit` third gate | metadata only |
| final signal flip | target `3` | selected source returns to clean signal and non-source clean inputs leave the clean block | `mainCaseProCircuit` fourth gate | metadata only |
| full transcript image | all 16 basis states | differs from `mainCaseProCandidateImage` exactly on dirty columns `8`, `9`, `12`, `13`; separate gate-derived candidate preserves the clean block | `mainCaseProCircuitImage_candidate_mismatch_set`, `mainCaseProCircuitVerified` | proved split |
| semantic-tier export selection | Qiskit/QASM3 planning | export must cite the aligned Pro transcript candidate, not the matrix-table incumbent | `mainCaseProCircuitVerified`, `mainCaseProCircuitCandidate_cost` | accepted; export implementation follows |

No external cited theorem is needed for this active leaf.  The relevant
textbook-memory cards are `BE.PartialPermutation.MatrixUnitTensorId`,
`BE.PermMatrix.CleanBlock`, and `BE.Tensor.PassiveRegister`; they justify the
route shape but do not certify the task-local transcript.

Cycle-1 lower implementation audit: the finite permutation table and the
advertised four-gate transcript are both compiled as clean-block candidates,
but they are different full permutations.  The mismatch is only on dirty
columns `8`, `9`, `12`, and `13`, so it does not refute either clean-block
certificate.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `MAINCASE-PRO-SOURCE-001` | Translate the fixed operator, register order, clean signal selector, normalizer, and exact error into Lean. | task packet | middle | `mainCaseProTarget`, `mainCaseProBlockProjection`, `mainCaseProQueryTarget` | this conversion window | `python3 tools/qbe.py check` | proved |
| `MAINCASE-PRO-SUPPORT-001` | Prove the two nonzero support entries of the target matrix. | `MAINCASE-PRO-SOURCE-001` | middle | `mainCaseProTarget_support_state0`, `mainCaseProTarget_support_state1` | proof-obligation ledger | `python3 tools/qbe.py check` | proved |
| `MAINCASE-PRO-PERM-IMAGE-001` | Define the task-local 16-state candidate image, matrix, and inverse image table. | `MAINCASE-PRO-SOURCE-001` | middle/lower 2 | `mainCaseProCandidateImage`, `mainCaseProCandidateMatrix`, `mainCaseProCandidatePreimage` | candidate population ledger | `python3 tools/qbe.py check` | proved |
| `MAINCASE-PRO-PERM-UNITARY-001` | Prove the candidate image is a finite bijection. | `MAINCASE-PRO-PERM-IMAGE-001` | middle/lower 2 | `mainCaseProCandidateImage_permutation_certificate` | this conversion window | `python3 tools/qbe.py check` | proved finite-permutation tier |
| `MAINCASE-PRO-CLEANENTRY-001` | Prove the clean-entry predicate used by `partialPermutationCertificate`. | `MAINCASE-PRO-PERM-IMAGE-001` | middle/lower 2 | `mainCaseProCandidate_cleanEntry` | this conversion window | `python3 tools/qbe.py check` | proved |
| `MAINCASE-PRO-BLOCK-001` | Prove the clean signal block of the candidate matrix equals `mainCaseProTarget`. | `MAINCASE-PRO-CLEANENTRY-001`, `MAINCASE-PRO-PERM-UNITARY-001` | middle/lower 2 | `mainCaseProExactCleanBlock_correct`, `mainCaseProCandidate_blockProjection` | this conversion window | `python3 tools/qbe.py check` | proved |
| `MAINCASE-PRO-RESOURCE-001` | Attach `(gateCount=4, depth=4, auxiliaryQubits=1, oracleCalls=0)` to the Pro transcript without claiming hardware optimality; mark the matrix-table incumbent with one unresolved oracle call. | `MAINCASE-PRO-BLOCK-001` | middle | `mainCaseProHighLevelSeedCost_*`, `mainCaseProCandidate_cost`, `mainCaseProCandidate_uses_matrix_table_metadata`, `mainCaseProCircuitCandidate_cost` | candidate population ledger | `python3 tools/qbe.py check` | proved |
| `MAINCASE-PRO-CIRCUIT-IMAGE-001` | Prove the Pro transcript realizes the current task-local image, or split the finite-permutation candidate from a corrected gate-derived candidate. | `MAINCASE-PRO-PERM-IMAGE-001`, `MAINCASE-PRO-RESOURCE-001`, Pro packet | lower 2/lower 3 | `mainCaseProCircuitImage_candidate_mismatch_set`, `mainCaseProCircuitVerified` | verifier-feedback packet | `python3 tools/qbe.py check` | proved split; equality theorem rejected |
| `MAINCASE-PRO-ORTHO-BRIDGE-001` | Promote the finite bijection certificate to a shared rational-orthogonality theorem for `permMatrix`. | `MAINCASE-PRO-PERM-UNITARY-001`, `MAINCASE-PRO-CIRCUIT-IMAGE-001` | lower 2/refiner | `BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective`, `mainCaseProCandidateMatrix_isRationalOrthogonal`, `mainCaseProCircuitMatrix_isRationalOrthogonal` | verifier-feedback packet | `python3 tools/qbe.py check`; `lake build && lake build Tests` | proved |
| `MAINCASE-PRO-SEMANTIC-TIER-001` | Select the export-facing certificate whose circuit, schedule, image, block theorem, orthogonality theorem, and cost are aligned. | `MAINCASE-PRO-CIRCUIT-IMAGE-001`, `MAINCASE-PRO-ORTHO-BRIDGE-001`, `MAINCASE-PRO-RESOURCE-001` | middle/reviewer/lower 3 | `mainCaseProCircuitVerified`, `mainCaseProCircuitCandidate_cost` | cycle-3 source contract | `python3 tools/qbe.py check`; `lake build && lake build Tests` | accepted semantic-tier gate |
| `MAINCASE-PRO-EXPORT-001` | Prepare Qiskit and QASM3 packets using only `mainCaseProCircuitVerified` as the Lean source declaration. | `MAINCASE-PRO-SEMANTIC-TIER-001` | export worker | none yet | `executable-exports/QBE-MAIN-CASE-HIER-PRO-001/export-plan.md` | export checker plus project gates | active export implementation pending |

## Upper Cycle-3 Override

The next lower cycle should not rediscover `MAINCASE-PRO-BLOCK-001`, retry
`mainCaseProCircuitImage_eq_candidate`, or reprove the rational-orthogonality
bridge; all three are settled.  The remaining work is export implementation and
checking from the accepted certificate `mainCaseProCircuitVerified`.

## Lower-Agent Packets

Cycle-3 packet object:
`MAINCASE-PRO-SEMANTIC-TIER-001 -> MAINCASE-PRO-EXPORT-001`.

The source-owned target is still the user task operator
`E_1 = |0><1|_T \otimes |0><1|_{\tau} \otimes I_S`, normalizer `1`,
clean signal `0`, exact error `0`, and resource tuple `(4,4,1,0)`.  The
external Pro input owns the transcript `CCX012; CX21; CX20; X2`.  QBE-local
semantic glue owns the finite transcript image `mainCaseProCircuitImage`, the
permutation matrix `mainCaseProCircuitMatrix`, the clean-block theorem
`mainCaseProCircuit_blockProjection`, the verified package
`mainCaseProCircuitVerified`, and the cost theorem
`mainCaseProCircuitCandidate_cost`.

Lower 1, source/export proof-map writer:

- Target leaf: `MAINCASE-PRO-SEMANTIC-TIER-001`.
- Read-only scope: `QuantumBlockEncoding/MainCase.lean`,
  `conversion-windows/QBE-MAIN-CASE-HIER-PRO-001.md`,
  `candidate-populations/QBE-MAIN-CASE-HIER-PRO-001.md`, and
  `executable-exports/QBE-MAIN-CASE-HIER-PRO-001/export-plan.md`.
- Deliverable: a short export-facing proof map that cites
  `mainCaseProCircuitVerified`, not `mainCaseProVerified`.
- Do not change `mainCaseProTarget`, `mainCaseProCandidateImage`,
  `mainCaseProCircuitImage`, or the Pro transcript score tuple.
- `mainCaseProCandidate_cost = (1,1,1,1)` records only the unresolved
  matrix-table placeholder metadata.

Lower 2, export implementation worker:

- Target leaf: `MAINCASE-PRO-EXPORT-001`; reviewer audits generated artifacts
  before export acceptance.
- Allowed write scope: `executable-exports/QBE-MAIN-CASE-HIER-PRO-001/` and
  focused export tests or check scripts under that root.
- Lean source declaration: `mainCaseProCircuitVerified`.
- Build expectation after generated files: run the export checker, then
  `python3 tools/qbe.py check` and `lake build && lake build Tests`.

Lower 3, necessary-condition verifier:

- Check that any generated Qiskit/QASM3 basis action matches the transcript
  image `mainCaseProCircuitImage` and the mismatch set against
  `mainCaseProCandidateImage` remains exactly `{8,9,12,13}`.
- Check the clean block against `mainCaseProTarget`, normalizer `1`, one clean
  signal qubit, and resource tuple `(4,4,1,0)`.
- Reject any export packet whose Lean source declaration is
  `mainCaseProVerified` or whose resource proof cites only
  `mainCaseProCandidate_cost`.

### Closed Cycle-2 Packet

The source-owned target is still the user task operator
`E_1 = |0><1|_T \otimes |0><1|_{\tau} \otimes I_S`, normalizer `1`,
clean signal `0`, and resource tuple `(4,4,1,0)`.  The external Pro input owns
only the gate transcript `CCX012; CX21; CX20; X2`.  QBE-local semantic glue
owns the finite permutation matrix, the clean-block projection, and the
optional rational-orthogonality matrix predicate.

No external cited theorem is needed for this packet.  The relevant local
precedent is the `OptimalControl.lean` shape of `columnInner`, `rowInner`, and
`IsRationalOrthogonal`; lower agents may reuse the idea, but must not import an
`OptimalControl` theorem as a certificate for this isolated task.

Lower 1, natural-language proof architect:

- Target leaf: `MAINCASE-PRO-ORTHO-BRIDGE-001`.
- Read-only scope: `QuantumBlockEncoding/BlockEncodingClassics.lean`,
  `QuantumBlockEncoding/MainCase.lean`, and the local-definition precedent in
  `QuantumBlockEncoding/OptimalControl.lean` around `columnInner`, `rowInner`,
  and `IsRationalOrthogonal`.
- Deliverable:
  `proof-attempts/QBE-MAIN-CASE-HIER-PRO-001-ortho-bridge-lower-architect-cycle02.md`.
- Proof map: for a permutation matrix `U row col = if row = p col then 1 else 0`,
  column Gram entries collapse by injectivity of `p`, and row Gram entries
  collapse by surjectivity of `p`.  For the first Lean attempt, a task-local
  finite theorem by `native_decide` is acceptable if the shared theorem is too
  broad.
- Do not change `mainCaseProTarget`, `mainCaseProSignalIndex`,
  `mainCaseProCandidateImage`, `mainCaseProCircuitImage`, or any resource tuple.

Lower 2, Lean implementation:

- Closed shared interface:
  `BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective`, after
  promoting `BlockEncodingClassics.columnInner`,
  `BlockEncodingClassics.rowInner`, and
  `BlockEncodingClassics.IsRationalOrthogonal`.
- Closed task-local interfaces:
  `mainCaseProCircuitMatrix_isRationalOrthogonal` for
  `mainCaseProCircuitMatrix`, plus
  `mainCaseProCandidateMatrix_isRationalOrthogonal` for the finite-permutation
  incumbent.
- Allowed write scope:
  `QuantumBlockEncoding/BlockEncodingClassics.lean`,
  `QuantumBlockEncoding/MainCase.lean`, and focused tests in
  `Tests/Basic.lean`.
- Build expectation: `python3 tools/qbe.py check`, then
  `lake build && lake build Tests`.
- Cycle-2 lower closed this proof route and set
  `mainCaseProRationalOrthogonalBridgeObligation.proved = true`; if a future
  reviewer rejects the bridge API, reopen it as `symbolic_bridge_gap` rather
  than changing the target operator.

Lower 3, necessary-condition verifier:

- Target diagnostics for `MAINCASE-PRO-ORTHO-BRIDGE-001`.
- Check finite column and row Gram values for `mainCaseProCircuitMatrix` and,
  if cheap, `mainCaseProCandidateMatrix`.
- Confirm the stale route remains retired:
  `mainCaseProCircuitImage_eq_candidate` is false on dirty columns `8`, `9`,
  `12`, and `13`.
- Record typed fields under
  `verifier-feedback/QBE-MAIN-CASE-HIER-PRO-001/`: `leaf`,
  `finite_matrix_ok`, `unitarity_ok`, `block_entry_ok`,
  `source_correspondence_ok`, `normalizer_ok`, `resource_score`,
  `error_class`, and `next_route`.

## Export Status

Post-Lean executable targets `qiskit` and `qasm3` have an export plan at
`executable-exports/QBE-MAIN-CASE-HIER-PRO-001/export-plan.md`.  The active
export worker must generate artifacts from `mainCaseProCircuitVerified` only,
then check the generated basis action against `mainCaseProCircuitImage`, the
clean block against `mainCaseProTarget`, and the stale dirty-column mismatch
against `mainCaseProCandidateImage`.
