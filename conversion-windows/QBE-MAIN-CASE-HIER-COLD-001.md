# Conversion Window: QBE-MAIN-CASE-HIER-COLD-001

## Source Anchor

The source object is the user/operator target in
`tasks/QBE-MAIN-CASE-HIER-COLD-001.md`, section `Operator Contract`.  No local
paper-source archive was detected for this task, so this cycle treats the task
packet as the source of truth.

The fixed target is

$$
E_1 = |0><1|_T \otimes |0><1|_\tau \otimes I_S.
$$

The benchmark instantiation has one qubit in each register `(T,tau,S)`.  The
system basis has dimension `8`, with flattening `4*T + 2*tau + S`.  The
candidate unitary uses one clean signal qubit, so the total basis has dimension
`16`, with flattening `8*signal + 4*T + 2*tau + S`.  The normalizer is
`alpha = 1`, and the exact error target is `0`.

## Route Decision

Partial permutation is the main route because the target is a matrix-unit
tensor identity.  The reusable cards are
`BE.PartialPermutation.MatrixUnitTensorId`, `BE.PermMatrix.CleanBlock`, and
`BE.Tensor.PassiveRegister`.  LCU, sparse-access, and QSVT are preserved only
as insight-pool alternatives; they add machinery that is not needed unless the
partial-permutation route is falsified.

The compiled Lean atoms to reuse are:

| Route role | Lean declaration |
|---|---|
| permutation matrix entries | `BlockEncodingClassics.permMatrix` |
| clean embedding | `BlockEncodingClassics.cleanBlockBy` |
| product clean entry bridge | `BlockEncodingClassics.cleanBlockBy_permMatrix_entry` |
| entrywise exact certificate | `BlockEncodingClassics.partialPermutationCertificate` |
| exact clean-block projection | `BlockEncodingClassics.ExactCleanBlock.clean_eq_target` |

The isolation rule forbids shortcutting through previous main-case candidate
names, previous Pro answers, or previous Qiskit exports.  Lower agents may use
the generic declarations above but must introduce this task under
`mainCaseCold*` names.

The shared Lean target file currently contains `mainCasePro*` declarations for
a separate Pro-isolated arm.  Those declarations are out of scope for this
no-Pro COLD arm.  Lower 2 should add independent `mainCaseCold*` declarations
in the same target file or an imported child file, and must not discharge a
COLD obligation by referring to a `mainCasePro*` theorem.

## Cycle 2 Source-Correspondence Audit

The active source anchor is still the task packet, not a paper TeX archive.
The object being translated is the concrete transfer operator at
`r = 1`, `k = 1`, and one passive `S` qubit:

$$
E_1 = |0><1|_T \otimes |0><1|_\tau \otimes I_S.
$$

The Lean target must preserve:

| Source field | Required value | Lean-facing contract |
|---|---|---|
| active registers | one-qubit `T` and one-qubit `tau` | `mainCaseColdSystemIndex` uses `4*T + 2*tau + S` |
| passive register | one-qubit `S`, unchanged by the target | `mainCaseColdTarget` has support `(0,6)` and `(1,7)` |
| clean signal | one block-encoding signal qubit at value `0` | `mainCaseColdCleanSignal : Fin 2 := 0` |
| normalizer | `alpha = 1` | `mainCaseColdExactNormalizer : Rat := 1` |
| exact error | `epsilon = 0` | `mainCaseColdExactError : Rat := 0` |
| candidate family | finite partial-permutation completion | `mainCaseColdPartialPermImage : Fin 16 -> Fin 16` |
| block theorem | clean block equals `E_1` | `mainCaseColdPartialPerm_clean_eq_target` |

Ownership classification:

| Item | Owner class | Status for next lower packet |
|---|---|---|
| `E_1`, register order, `alpha = 1`, clean signal `0`, exact target | active user/operator target | fixed; do not mutate |
| finite completion table `MAIN-PARTIAL-PERM-001` | QBE-local candidate glue | allowed free parameter; finite diagnostic passed |
| `BlockEncodingClassics.partialPermutationCertificate` and exact clean-block wrapper | QBE-local compiled semantic glue | reusable dependency |
| LCU, QSVT, sparse access, dilation | alternative route memory | not active unless partial permutation is falsified |
| external paper theorem or cited subroutine | external contract | none needed for this leaf |

The current drift is not mathematical drift in the candidate table.  It is a
Lean-surface drift: `QuantumBlockEncoding/MainCase.lean` exists but has only
`mainCasePro*` declarations for a different isolation arm.  The next lower
work is contract repair under independent `mainCaseCold*` names.

## Symbol Map

| Source/user symbol | Lean name for this task | Status |
|---|---|---|
| system basis `(T,tau,S)` | `mainCaseColdSystemIndex` | planned in `QuantumBlockEncoding/MainCase.lean` |
| target operator `E_1` | `mainCaseColdTarget` | planned |
| normalizer `alpha = 1` | `mainCaseColdExactNormalizer` | planned |
| exact error `epsilon = 0` | `mainCaseColdExactError` | planned |
| clean signal value `0` | `mainCaseColdCleanSignal` | planned |
| clean embedding into signal-system basis | `mainCaseColdCleanEmbed` | planned |
| candidate permutation | `mainCaseColdPartialPermImage` | planned |
| permutation matrix candidate | `mainCaseColdPartialPermMatrix` | planned |
| clean-entry proof | `mainCaseColdPartialPerm_entry` | active Lean leaf |
| exact clean-block package | `mainCaseColdPartialPermExactCleanBlock` | active Lean leaf |
| clean block equals `E_1` | `mainCaseColdPartialPerm_clean_eq_target` | active Lean leaf |
| finite permutation/bijection certificate | `mainCaseColdPartialPermImage_bijective` | obligation |
| resource tuple | `mainCaseColdPartialPermCost` and field theorems | obligation |
| post-Lean Qiskit/QASM export packet | `executable-exports/QBE-MAIN-CASE-HIER-COLD-001/` | blocked until Lean certificate |

## Candidate Contract

Candidate `MAIN-PARTIAL-PERM-001` is a finite permutation that preserves the
passive register `S`.  For each `S = s`, the active `(signal,T,tau)` component
is mapped as follows:

| Input `(signal,T,tau,s)` | Output `(signal,T,tau,s)` |
|---|---|
| `(0,0,0,s)` | `(1,1,1,s)` |
| `(0,0,1,s)` | `(1,0,0,s)` |
| `(0,1,0,s)` | `(1,0,1,s)` |
| `(0,1,1,s)` | `(0,0,0,s)` |
| `(1,0,0,s)` | `(0,0,1,s)` |
| `(1,0,1,s)` | `(0,1,0,s)` |
| `(1,1,0,s)` | `(0,1,1,s)` |
| `(1,1,1,s)` | `(1,1,0,s)` |

Equivalently, on full flattened indices the image is
`0 -> 14`, `1 -> 15`, `2 -> 8`, `3 -> 9`, `4 -> 10`, `5 -> 11`,
`6 -> 0`, `7 -> 1`, `8 -> 2`, `9 -> 3`, `10 -> 4`, `11 -> 5`,
`12 -> 6`, `13 -> 7`, `14 -> 12`, and `15 -> 13`.

For clean input columns, the only clean output branch is
`(signal,T,tau,S) = (0,1,1,s) -> (0,0,0,s)`.  Therefore the clean block has
entry `1` at row/column pairs `(0,6)` and `(1,7)` in the system flattening,
and it has entry `0` elsewhere.  This is exactly
`|0><1|_T \otimes |0><1|_\tau \otimes I_S`.

## Lean-Facing Contract

Lower 2 should make the active leaf compile in
`QuantumBlockEncoding/MainCase.lean` without importing or copying prior
task-specific main-case declarations.

The active endpoint theorem is:

```lean
theorem mainCaseColdPartialPerm_clean_eq_target :
    Matrix.PointwiseEq
      (BlockEncodingClassics.ExactCleanBlock.clean
        mainCaseColdPartialPermExactCleanBlock)
      mainCaseColdTarget
```

The intended package is:

```lean
def mainCaseColdPartialPermExactCleanBlock :
    BlockEncodingClassics.ExactCleanBlock 8 16 :=
  BlockEncodingClassics.partialPermutationCertificate
    mainCaseColdCleanEmbed
    mainCaseColdPartialPermImage
    mainCaseColdTarget
    mainCaseColdPartialPerm_entry
```

The proof of `mainCaseColdPartialPerm_entry` should be finite and task-local.  A
reasonable first proof shape is `intro row col; fin_cases row; fin_cases col;
native_decide` or an equivalent table proof, after the target matrix and image
function are defined.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `MAIN-SOURCE-001` | Translate `E_1`, `(T,tau,S)`, clean signal, `alpha = 1`, and `epsilon = 0` into Lean declarations. | task packet | lower 2, guided by middle | `mainCaseColdSystemIndex`, `mainCaseColdTarget`, `mainCaseColdExactNormalizer`, `mainCaseColdExactError`, `mainCaseColdCleanEmbed` | this conversion window | `python3 tools/qbe.py check` | active leaf prerequisite |
| `MAIN-CAND-IMAGE-001` | Define the `Fin 16` finite image for `MAIN-PARTIAL-PERM-001`. | `MAIN-SOURCE-001` | lower 2 | `mainCaseColdPartialPermImage`, `mainCaseColdPartialPermMatrix` | candidate-population ledger | `python3 tools/qbe.py check` | active leaf prerequisite |
| `MAIN-FINITE-DIAG-001` | Exhaustively check bijection, clean-block support, normalizer, ancilla count, and resource placeholders before broad proof search. | candidate table | lower 3 | verifier packet under `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/` | verifier-feedback packet | diagnostic plus typed feedback | preliminary middle diagnostic passed; durable lower-3 script optional |
| `MAIN-CLEAN-ENTRY-001` | Prove the clean block of the permutation matrix equals `mainCaseColdTarget` via `partialPermutationCertificate`. | `MAIN-SOURCE-001`, `MAIN-CAND-IMAGE-001` | lower 2 | `mainCaseColdPartialPerm_entry`, `mainCaseColdPartialPermExactCleanBlock`, `mainCaseColdPartialPerm_clean_eq_target` | this conversion window | `python3 tools/qbe.py check` | active Lean leaf |
| `MAIN-PERM-UNITARY-001` | Prove the image is a bijection/permutation and connect that to the unitary obligation for the semantic tier. | `MAIN-CAND-IMAGE-001`, `MAIN-FINITE-DIAG-001` | lower 2 or refiner after clean entry | `mainCaseColdPartialPermImage_bijective`, later unitary package | proof-obligation ledger | `python3 tools/qbe.py check` | obligation |
| `MAIN-RESOURCE-001` | Attach a resource tuple with certified field theorems.  At minimum `auxiliaryQubits = 1` and `oracleCalls = 0`; gate count and depth require a circuit schema. | `MAIN-CLEAN-ENTRY-001` | middle/lower 2 | `mainCaseColdPartialPermCost` and field theorems | candidate-population ledger | `python3 tools/qbe.py check` | obligation |
| `MAIN-EXPORT-001` | Create Qiskit and QASM3 exports for `r=1,k=1,passiveQubits=1`. | named Lean block, unitarity, and resource certificates | later export worker | export manifest and checks | export ledger | export check plus project gate | blocked until Lean certificate |

## Stale And Rejected Route Memory

- Do not import, copy, or rename declarations from previous main-case task
  files or prior Pro/Qiskit outputs.
- Do not route the first cycle through LCU, sparse-access, QSVT, or dilation
  unless `MAIN-PARTIAL-PERM-001` fails a necessary condition.
- Do not claim unitarity, a primitive circuit decomposition, hardware
  optimality, or a complete executable export until the corresponding named
  Lean or post-Lean artifact exists.

## Lower-Facing Packet

Cycle 2 source contract:
`proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-middle-source-contract-cycle02.md`.

Cycle 1 split packet remains valid as background:
`proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-lower-packets-cycle01.md`.

No LaTeX proof export is due in this inner cycle.
