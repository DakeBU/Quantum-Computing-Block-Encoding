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

The shared Lean target file contains `mainCasePro*` declarations for a separate
Pro-isolated arm and independent `mainCaseCold*` declarations for this no-Pro
COLD arm.  The Pro declarations remain out of scope for COLD certificates; the
COLD clean-block theorem is discharged by the task-local COLD declarations.

## Cycle 2-3 Source-Correspondence Audit

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

The previous drift was Lean-surface drift, not mathematical drift in the
candidate table.  Cycle 2 repaired that drift for the clean-block layer by
adding independent `mainCaseCold*` names.

Cycle 2 Lean update: the COLD source surface, candidate table, and exact
clean-block theorem now compile under independent `mainCaseCold*` names in
`QuantumBlockEncoding/MainCase.lean`.  This closes the clean-block equality
layer for `MAIN-PARTIAL-PERM-001`.  It does not close the finite
permutation/unitarity bridge, circuit realization, resource tuple, or
Qiskit/QASM3 export obligations.

Cycle 2 lower Lean update: the finite bijection part of the
permutation/unitarity layer now compiles as
`mainCaseColdPartialPermImage_bijective`, with a task-local inverse table
`mainCaseColdPartialPermPreimage`.  This proves the candidate image is a
permutation at the finite-table tier; matrix-orthogonality bridge work,
resource scoring, and executable export remain later leaves.

Cycle 3 memory update: `MAIN-CLEAN-ENTRY-001` and the finite-bijection subleaf
of `MAIN-PERM-UNITARY-001` are stale lower targets and should be retired.  The
cycle-3 Lean update also closes `MAIN-BLOCK-PROJECTION-001` under task-local
COLD declarations.  The active proof-DAG leaf is now `MAIN-RESOURCE-001`:
derive or name an honest COLD-local circuit/resource schema before candidate
packaging.  Do not start Qiskit/QASM3 export until a named COLD verified
candidate and resource tuple compile.

Cycle 3 lower resource update: `MAIN-RESOURCE-001` now has a task-local logical
reversible circuit schema and compiled cost field theorems.  The reduced gate
transcript is `X_T; CCX_{\tau,T -> signal}; X_tau; CX_{signal -> T};
CX_{tau -> signal}`.  Lean proves
`mainCaseColdCircuitImage_eq_partialPermImage`, so the schema implements the
same finite table as `mainCaseColdPartialPermImage` while preserving passive
`S`.  The high-level logical resource tuple is `(gateCount, depth,
auxiliaryQubits, oracleCalls) = (5, 5, 1, 0)`, certified by
`mainCaseColdPartialPermCost_*`.  Candidate packaging remains a later leaf.

## Symbol Map

| Source/user symbol | Lean name for this task | Status |
|---|---|---|
| system basis `(T,tau,S)` | `mainCaseColdSystemIndex` | compiled |
| target operator `E_1` | `mainCaseColdTarget` | compiled |
| normalizer `alpha = 1` | `mainCaseColdExactNormalizer` | compiled |
| exact error `epsilon = 0` | `mainCaseColdExactError` | compiled |
| clean signal value `0` | `mainCaseColdCleanSignal` | compiled |
| clean embedding into signal-system basis | `mainCaseColdCleanEmbed` | compiled |
| candidate permutation | `mainCaseColdPartialPermImage` | compiled |
| permutation matrix candidate | `mainCaseColdPartialPermMatrix` | compiled |
| clean-entry proof | `mainCaseColdPartialPerm_entry` | proved |
| exact clean-block package | `mainCaseColdPartialPermExactCleanBlock` | compiled |
| clean block equals `E_1` | `mainCaseColdPartialPerm_clean_eq_target` | proved |
| finite permutation/bijection certificate | `mainCaseColdPartialPermImage_bijective` | proved |
| operator-first target metadata | `mainCaseColdQueryTarget` | compiled |
| project-local block projection predicate | `mainCaseColdBlockProjection`, `mainCaseColdPartialPerm_blockProjection` | proved |
| COLD source layout | `mainCaseColdSourceLayout`, `mainCaseColdSourceLayout_auxiliaryQubits` | compiled; proves `a = 1` at layout layer |
| COLD logical circuit/schema | `mainCaseColdCircuit`, `mainCaseColdSchedule`, `mainCaseColdReducedGateImages_eval`, `mainCaseColdCircuitImage_eq_partialPermImage` | compiled; implements the finite table |
| resource-schema obligation marker | `mainCaseColdResourceSchemaObligation` | historical open marker; not promoted by this lower worker |
| COLD candidate and verified package | `mainCaseColdPartialPermCandidate`, `mainCaseColdPartialPermVerified` | next active leaf after resource closure |
| resource tuple | `mainCaseColdPartialPermCost` and field theorems | proved as `(5, 5, 1, 0)` at the high-level logical tier |
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

The cycle-2 implementation made the active clean-block leaf compile in
`QuantumBlockEncoding/MainCase.lean` without referring to `mainCasePro*` as a
certificate.  The declarations use the COLD finite image table from this
conversion window.

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

Cycle 3 block-projection declarations now compile:

```lean
def mainCaseColdQueryTarget : QueryOperatorTarget Rat 8 8

def mainCaseColdBlockProjection
    (U : Matrix (2 * 8) (2 * 8) Rat) : Prop :=
  Matrix.PointwiseEq
    (signalSystemBlockProjection 2 8 8 U mainCaseColdCleanSignal)
    mainCaseColdTarget

theorem mainCaseColdPartialPerm_blockProjection :
    mainCaseColdBlockProjection mainCaseColdPartialPermMatrix
```

The cycle also adds:

```lean
def mainCaseColdSourceLayout : RegisterLayout

theorem mainCaseColdSourceLayout_auxiliaryQubits :
    mainCaseColdSourceLayout.auxiliaryQubits = 1

def mainCaseColdResourceSchemaObligation : SemanticObligation
```

Cycle 3 resource-schema declarations now compile:

```lean
def mainCaseColdCircuit : Circuit

def mainCaseColdSchedule : LayeredCircuit

theorem mainCaseColdCircuitImage_eq_partialPermImage :
    forall x : Fin 16,
      mainCaseColdCircuitImage x = mainCaseColdPartialPermImage x

def mainCaseColdHighLevelResource : Resource :=
  Resource.ofCountsWithDepth 2 3 0 0 5

def mainCaseColdPartialPermCost : BlockEncodingCost

theorem mainCaseColdPartialPermCost_gateCount :
    mainCaseColdPartialPermCost.gateCount = 5

theorem mainCaseColdPartialPermCost_depth :
    mainCaseColdPartialPermCost.depth = 5

theorem mainCaseColdPartialPermCost_auxiliaryQubits :
    mainCaseColdPartialPermCost.auxiliaryQubits = 1

theorem mainCaseColdPartialPermCost_oracleCalls :
    mainCaseColdPartialPermCost.oracleCalls = 0
```

The next lower worker may attempt COLD `OperatorBlockEncodingCandidate`
packaging, but must still prove the candidate record under `mainCaseCold*`
names and must not start Qiskit/QASM3 export before a named verified COLD
candidate compiles.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `MAIN-SOURCE-001` | Translate `E_1`, `(T,tau,S)`, clean signal, `alpha = 1`, and `epsilon = 0` into Lean declarations. | task packet | lower 2, guided by middle | `mainCaseColdSystemIndex`, `mainCaseColdTarget`, `mainCaseColdExactNormalizer`, `mainCaseColdExactError`, `mainCaseColdCleanEmbed` | this conversion window | `python3 tools/qbe.py check` | proved |
| `MAIN-CAND-IMAGE-001` | Define the `Fin 16` finite image for `MAIN-PARTIAL-PERM-001`. | `MAIN-SOURCE-001` | lower 2 | `mainCaseColdPartialPermImage`, `mainCaseColdPartialPermMatrix` | candidate-population ledger | `python3 tools/qbe.py check` | proved |
| `MAIN-FINITE-DIAG-001` | Exhaustively check bijection, clean-block support, normalizer, ancilla count, and resource placeholders before broad proof search. | candidate table | lower 3 | `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/main-case-cold-perm-unitary-cycle02.*` | verifier-feedback packet | diagnostic plus typed feedback | durable diagnostic passed |
| `MAIN-CLEAN-ENTRY-001` | Prove the clean block of the permutation matrix equals `mainCaseColdTarget` via `partialPermutationCertificate`. | `MAIN-SOURCE-001`, `MAIN-CAND-IMAGE-001` | lower 2 | `mainCaseColdPartialPerm_entry`, `mainCaseColdPartialPermExactCleanBlock`, `mainCaseColdPartialPerm_clean_eq_target` | this conversion window | `python3 tools/qbe.py check` | proved |
| `MAIN-PERM-UNITARY-001` | Prove the image is a bijection/permutation for the finite-permutation semantic tier. | `MAIN-CAND-IMAGE-001`, `MAIN-FINITE-DIAG-001` | lower 2 | `mainCaseColdPartialPermImage_bijective` | verifier-feedback packet | `python3 tools/qbe.py check` | proved at finite-permutation tier; stronger matrix predicate deferred if later required |
| `MAIN-BLOCK-PROJECTION-001` | Define COLD `QueryOperatorTarget` and `signalSystemBlockProjection` predicate, then prove the COLD permutation matrix satisfies that predicate. | `MAIN-CLEAN-ENTRY-001`, `MAIN-PERM-UNITARY-001` | lower 2 | `mainCaseColdQueryTarget`, `mainCaseColdBlockProjection`, `mainCaseColdPartialPerm_blockProjection` | this conversion window and cycle-3 source contract | `python3 tools/qbe.py check` | proved |
| `MAIN-RESOURCE-001` | Attach an honest resource tuple with certified field theorems. | `MAIN-BLOCK-PROJECTION-001` | lower 2 | `mainCaseColdCircuit`, `mainCaseColdCircuitImage_eq_partialPermImage`, `mainCaseColdPartialPermCost_*` | candidate-population ledger | `python3 tools/qbe.py check` | proved at high-level logical resource tier |
| `MAIN-CANDIDATE-PACKAGE-001` | Package the COLD candidate and verified certificate without changing the target or hiding resource assumptions. | `MAIN-BLOCK-PROJECTION-001`, `MAIN-RESOURCE-001` | lower 2/refiner | `mainCaseColdPartialPermCandidate`, `mainCaseColdPartialPermVerified` | proof-obligation ledger | `python3 tools/qbe.py check` | active leaf |
| `MAIN-EXPORT-001` | Create Qiskit and QASM3 exports for `r=1,k=1,passiveQubits=1`. | named Lean block, unitarity, and resource certificates | later export worker | export manifest and checks | export ledger | export check plus project gate | blocked until Lean certificate |

## Stale And Rejected Route Memory

- Do not import, copy, or rename declarations from previous main-case task
  files or prior Pro/Qiskit outputs.
- Do not route the first cycle through LCU, sparse-access, QSVT, or dilation
  unless `MAIN-PARTIAL-PERM-001` fails a necessary condition.
- Do not claim unitarity, a primitive circuit decomposition, hardware
  optimality, or a complete executable export until the corresponding named
  Lean or post-Lean artifact exists.
- Retire lower packets whose only goal is
  `mainCaseColdPartialPermImage_bijective`; that finite-bijection target now
  compiles.
- Retire lower packets whose only goal is
  `mainCaseColdPartialPerm_blockProjection`; that projection target now
  compiles.
- Keep the matrix-orthogonality bridge as a conditional symbolic bridge.  It is
  not the active leaf unless reviewer raises the semantic tier beyond the
  finite-permutation candidate record.

## Lower-Facing Packet

Cycle 2 source contract and implementation result:
`proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-middle-source-contract-cycle02.md`.

Cycle 2 lower architect packet for the next permutation/unitarity leaf:
`proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-lower-architect-cycle02-main-perm-unitary.md`.

Cycle 3 source-correspondence packet for the active block-projection leaf:
`proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-middle-source-contract-cycle03.md`.

Cycle 3 lower packet for the active resource/schema leaf:
`proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-middle-lower-packets-cycle03-main-resource.md`.

Cycle 3 lower architect packet for the active resource/schema leaf:
`proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-lower-architect-cycle03-main-resource.md`.

Cycle 1 split packet remains valid as background:
`proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-lower-packets-cycle01.md`.

Cycle 3 compact memory packet:
`runs/20260625-233740-QBE-MAIN-CASE-HIER-COLD-001-cycle03/memory_digest.md`.

Cycle 3 lower todo packet:
`runs/20260625-233740-QBE-MAIN-CASE-HIER-COLD-001-cycle03/todo.md`.

No LaTeX proof export is due in this inner cycle.
