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
| high-level resource and score | `mainCaseProHighLevelResource`, `mainCaseProHighLevelSeedCost` | compiled with field certificates |
| candidate permutation | `mainCaseProCandidateImage`, `mainCaseProCandidatePreimage` | compiled |
| permutation certificate | `mainCaseProCandidateImage_permutation_certificate` | compiled finite-permutation tier |
| clean-entry bridge | `mainCaseProCandidate_cleanEntry` | compiled |
| exact clean-block package | `mainCaseProExactCleanBlockCertificate`, `mainCaseProExactCleanBlock_correct` | compiled |
| signal block theorem | `mainCaseProCandidate_blockProjection` | compiled |
| finite-permutation candidate package | `mainCaseProCandidate`, `mainCaseProVerified` | compiled |
| matrix-orthogonality bridge | `mainCaseProRationalOrthogonalBridgeObligation` | explicit open obligation |

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

Cycle-1 upper process audit: the finite permutation table and clean-block
proof are compiled, but the advertised four-gate transcript has not yet been
proved task-locally to realize `mainCaseProCandidateImage`.  The old
`OptimalControl` Pro transcript gives useful route memory, but it is not a
certificate for this isolated task and indicates a dirty-column mismatch against
the current task-local image on columns `8`, `9`, `12`, and `13`.  This is a
contract-alignment illness area at the circuit/resource layer, not a failure of
the already compiled clean-block entry theorem.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `MAINCASE-PRO-SOURCE-001` | Translate the fixed operator, register order, clean signal selector, normalizer, and exact error into Lean. | task packet | middle | `mainCaseProTarget`, `mainCaseProBlockProjection`, `mainCaseProQueryTarget` | this conversion window | `python3 tools/qbe.py check` | proved |
| `MAINCASE-PRO-SUPPORT-001` | Prove the two nonzero support entries of the target matrix. | `MAINCASE-PRO-SOURCE-001` | middle | `mainCaseProTarget_support_state0`, `mainCaseProTarget_support_state1` | proof-obligation ledger | `python3 tools/qbe.py check` | proved |
| `MAINCASE-PRO-PERM-IMAGE-001` | Define the task-local 16-state candidate image, matrix, and inverse image table. | `MAINCASE-PRO-SOURCE-001` | middle/lower 2 | `mainCaseProCandidateImage`, `mainCaseProCandidateMatrix`, `mainCaseProCandidatePreimage` | candidate population ledger | `python3 tools/qbe.py check` | proved |
| `MAINCASE-PRO-PERM-UNITARY-001` | Prove the candidate image is a finite bijection. | `MAINCASE-PRO-PERM-IMAGE-001` | middle/lower 2 | `mainCaseProCandidateImage_permutation_certificate` | this conversion window | `python3 tools/qbe.py check` | proved finite-permutation tier |
| `MAINCASE-PRO-CLEANENTRY-001` | Prove the clean-entry predicate used by `partialPermutationCertificate`. | `MAINCASE-PRO-PERM-IMAGE-001` | middle/lower 2 | `mainCaseProCandidate_cleanEntry` | this conversion window | `python3 tools/qbe.py check` | proved |
| `MAINCASE-PRO-BLOCK-001` | Prove the clean signal block of the candidate matrix equals `mainCaseProTarget`. | `MAINCASE-PRO-CLEANENTRY-001`, `MAINCASE-PRO-PERM-UNITARY-001` | middle/lower 2 | `mainCaseProExactCleanBlock_correct`, `mainCaseProCandidate_blockProjection` | this conversion window | `python3 tools/qbe.py check` | proved |
| `MAINCASE-PRO-RESOURCE-001` | Attach `(gateCount=4, depth=4, auxiliaryQubits=1, oracleCalls=0)` without claiming hardware optimality. | `MAINCASE-PRO-BLOCK-001` | middle | `mainCaseProHighLevelSeedCost_*`, `mainCaseProCandidate_cost` | candidate population ledger | `python3 tools/qbe.py check` | proved |
| `MAINCASE-PRO-CIRCUIT-IMAGE-001` | Prove the Pro transcript realizes the current task-local image, or split the finite-permutation candidate from a corrected gate-derived candidate. | `MAINCASE-PRO-PERM-IMAGE-001`, `MAINCASE-PRO-RESOURCE-001`, Pro packet | lower 2/lower 3 | none yet | verifier-feedback packet | `python3 tools/qbe.py check` | active leaf |
| `MAINCASE-PRO-ORTHO-BRIDGE-001` | Promote the finite bijection certificate to a shared rational-orthogonality theorem for `permMatrix`. | `MAINCASE-PRO-PERM-UNITARY-001` | lower 2/refiner | `mainCaseProRationalOrthogonalBridgeObligation` | verifier-feedback packet | `python3 tools/qbe.py check` | queued after circuit-image alignment |
| `MAINCASE-PRO-EXPORT-001` | Prepare Qiskit and QASM3 packets only after the accepted Lean semantic tier is named. | `MAINCASE-PRO-BLOCK-001`, `MAINCASE-PRO-ORTHO-BRIDGE-001`, `MAINCASE-PRO-RESOURCE-001` | export worker | none yet | export ledger later | export checker plus project gates | blocked on export policy |

## Upper Cycle-1 Override

The next lower cycle should not rediscover `MAINCASE-PRO-BLOCK-001`; it is
compiled.  The active repair is `MAINCASE-PRO-CIRCUIT-IMAGE-001`, because the
candidate record currently ties the finite permutation matrix to
`mainCaseProCircuit` and the `(4,4,1,0)` resource tuple without a task-local
circuit-to-image theorem.  `MAINCASE-PRO-ORTHO-BRIDGE-001` remains valuable
shared proof memory, but it is secondary until the advertised circuit/resource
layer is aligned or explicitly demoted to a finite-permutation-only semantic
tier.

## Lower-Agent Packets

Lower 1, natural-language proof architect:

- Target leaf: `MAINCASE-PRO-CIRCUIT-IMAGE-001`.
- Read-only scope: `QuantumBlockEncoding/MainCase.lean`, `QuantumBlockEncoding/OptimalControl.lean` around `proEqTransferImage`, `proEqTransferGateImages_eval`, `liftReducedImage`, and the reduced gate images.
- Deliverable: a proof-translation packet that states the Pro transcript image on the task-local `(signal,T,tau,S)` convention, compares it with `mainCaseProCandidateImage`, and recommends either a theorem goal or an explicit candidate split.
- Do not change `mainCaseProTarget`, `mainCaseProSignalIndex`, `mainCaseProCandidateImage`, or the resource tuple.

Lower 2, Lean implementation:

- Target file: `QuantumBlockEncoding/MainCase.lean`, with read-only comparison to `QuantumBlockEncoding/OptimalControl.lean`.
- Exact target: define a task-local gate-transcript image for `mainCaseProCircuit` or reuse a small local image evaluator, then prove or disprove equality with `mainCaseProCandidateImage`.
- Allowed write scope: one Lean file plus focused tests in `Tests/Basic.lean`.
- Gate: `python3 tools/qbe.py check`, then `lake build && lake build Tests`.

Lower 3, necessary-condition verifier:

- Target leaf: finite diagnostic for `MAINCASE-PRO-CIRCUIT-IMAGE-001`.
- Check fields: all-16-state image equality between the current candidate and the Pro transcript, dirty-column mismatch set, clean-block entries, normalizer, ancilla count, resource tuple, and whether exported Qiskit/QASM work is still blocked by policy.
- Write feedback under `verifier-feedback/QBE-MAIN-CASE-HIER-PRO-001/` and log with `trial-log --feedback-field`.

## Export Status

Post-Lean executable targets `qiskit` and `qasm3` remain deferred.  The current
named Lean artifacts are enough for the finite-permutation clean-block core,
but the export packet should wait until reviewer accepts the semantic tier or
`MAINCASE-PRO-ORTHO-BRIDGE-001` closes.
