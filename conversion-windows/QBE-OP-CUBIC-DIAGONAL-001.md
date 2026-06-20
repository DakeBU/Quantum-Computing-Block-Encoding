# Conversion Window: QBE-OP-CUBIC-DIAGONAL-001

Updated: 2026-06-20 15:40 JST
Mode: exploratoryConstruction
Source anchor: user-provided operator request in `tasks/QBE-OP-CUBIC-DIAGONAL-001.md`.

## Source And Lean Symbols

| Source/user symbol | Meaning | Lean name or artifact | Status |
|---|---|---|---|
| $n$ | number of system qubits | parameter `n : Nat`; positive-qubit condition is recorded in the task text, but current Lean declarations accept all `Nat` | target surface compiled |
| $N = 2^n$ | grid size | `gridSize n` | compiled |
| $x_j = j / 2^n$ | grid point for row index `j` | `CubicStatePreparation.gridPoint n j` | compiled |
| $f(x) = x^3$ | cubic amplitude | `CubicStatePreparation.cubicAmplitude n j` | compiled |
| $D_n$ | diagonal operator with entry $(j/2^n)^3$ on row `j` | `CubicDiagonalOracle.cubicDiagonalOperator n` | compiled |
| $\alpha = 1$ | exact primitive-oracle normalizer | `CubicDiagonalOracle.exactNormalizer n` | compiled |
| one-signal diagonal amplitude oracle | primitive oracle-label candidate, not expanded arithmetic | `amplitudeOracleLayout`, `amplitudeOracleCircuit`, `amplitudeOracleResourceTuple`, `primitiveAmplitudeOracleSemanticContract` | compiled interface and conditional contract; semantic proof open |
| expanded arithmetic plus controlled rotation | QBE-local backend route for the same diagonal target | `expandedAmplitudeOracleLayout`, `expandedAmplitudeOracleCleanBlockContract`, `expandedAmplitudeOracleSemanticContract_cleanBlock_eq_target` | compiled conditional interface; backend semantics open |

This task is a diagonal operator block-encoding task.  It must not be rewritten
as the rank-one state-preparation target from `QBE-OP-CUBIC-STATEPREP-001`, and
the diagonal vector must not be normalized as a quantum state.

## Lean-Facing Contract

The target operator is already represented by:

```lean
CubicDiagonalOracle.cubicDiagonalOperator (n : Nat) :
  Matrix (gridSize n) (gridSize n) Rat
```

Its entrywise contract is:

```lean
fun row col =>
  if row = col then CubicStatePreparation.cubicAmplitude n row else 0
```

The primitive oracle-label route uses one signal qubit and no pure workspace at
the unexpanded tier.  Its advertised score is compiled as:

```lean
CubicDiagonalOracle.amplitudeOracleResourceTuple_eq :
  CubicDiagonalOracle.amplitudeOracleResourceTuple n = (1, 1, 1, 1)
```

The candidate record itself now has the same compiled score:

```lean
CubicDiagonalOracle.primitiveAmplitudeOracleCandidate_costTuple_eq :
  ((CubicDiagonalOracle.primitiveAmplitudeOracleCandidate n).cost.gateCount,
   (CubicDiagonalOracle.primitiveAmplitudeOracleCandidate n).cost.depth,
   (CubicDiagonalOracle.primitiveAmplitudeOracleCandidate n).cost.auxiliaryQubits,
   (CubicDiagonalOracle.primitiveAmplitudeOracleCandidate n).cost.oracleCalls)
    = (1, 1, 1, 1)
```

The closed Lean-facing bridge is:

```lean
theorem CubicDiagonalOracle.primitiveOracleCleanBlock_eq_target
    (n : Nat) (block : Matrix (gridSize n) (gridSize n) Rat)
    (h : CubicDiagonalOracle.diagonalCleanBlockContract n block) :
    Matrix.PointwiseEq block (CubicDiagonalOracle.cubicDiagonalTarget n).operator
```

This theorem is not a unitary certificate.  It only says that once a primitive
oracle or an expanded circuit supplies a block satisfying
`diagonalCleanBlockContract`, the block is exactly the task target.

The primitive oracle-label semantic contract is now represented in Lean by:

```lean
opaque CubicDiagonalOracle.primitiveAmplitudeOracleUnitary
opaque CubicDiagonalOracle.primitiveAmplitudeOracleIsUnitary
opaque CubicDiagonalOracle.primitiveAmplitudeOracleCleanBlockExtracts

def CubicDiagonalOracle.primitiveAmplitudeOracleSemanticContract
    (n : Nat) : Prop := ...
```

The compiled bridge from that explicit contract to the target clean block is:

```lean
theorem CubicDiagonalOracle.primitiveAmplitudeOracleSemanticContract_cleanBlock_eq_target
    (n : Nat)
    (h : CubicDiagonalOracle.primitiveAmplitudeOracleSemanticContract n) :
    Exists fun block =>
      CubicDiagonalOracle.primitiveAmplitudeOracleCleanBlockExtracts n
        (CubicDiagonalOracle.primitiveAmplitudeOracleUnitary n) block ∧
        Matrix.PointwiseEq block
          (CubicDiagonalOracle.cubicDiagonalTarget n).operator
```

The conditional certificate transformer
`CubicDiagonalOracle.primitiveAmplitudeOracleVerified n h` is compiled, but it
requires the proof parameter
`h : CubicDiagonalOracle.primitiveAmplitudeOracleSemanticContract n`.  Therefore
it is not an unconditional certified candidate.

Verifier feedback rejects one specific interpretation of this contract:
a standard exact `Rat`-valued, one-signal, no-workspace unitary completion with
clean block $D_n$.  The obstruction is the determinant-square necessary
condition recorded in
`verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-PRIM-WITNESS-001.rat-one-signal.md`.
This does not refute the diagonal target and does not refute the opaque Lean
proposition by itself.  It means lower agents must not continue tactic search
for `primitiveAmplitudeOracleSemanticContract n` under that exact rational
completion semantics.  The next route must either retarget the primitive tier to
an explicitly accepted Real/Complex amplitude-oracle semantics, or open an
expanded arithmetic and controlled-rotation route.  The current upper
directive selects the expanded arithmetic and controlled-rotation route.

## Source-Contract Audit

There is no paper source archive for this task.  The authoritative source is
the user-provided operator requirement.

| Contract field | Current value | Lean representation | Status |
|---|---|---|---|
| input system register | `n`-qubit index register holding `j` | row/column indices of `Matrix (gridSize n) (gridSize n) Rat` | compiled |
| signal register | one clean signal qubit selecting the clean block | `amplitudeOracleLayout n` with `signalQubits := 1` | compiled interface |
| pure ancillas | none at the primitive oracle-label tier | `amplitudeOracleLayout n` with `pureAncillas := 0` | compiled |
| output operator | diagonal entries $(j/2^n)^3$ and zero off diagonal | `cubicDiagonalOperator n` | compiled |
| normalizer | $\alpha = 1$ | `exactNormalizer n` | compiled |
| range bound | $0 \le (j/2^n)^3 \le 1$ | `cubicAmplitude_nonneg`, `cubicAmplitude_le_one` | compiled |
| primitive unitary | one-signal amplitude oracle realizing the clean block | `primitiveAmplitudeOracleUnitary`, `primitiveAmplitudeOracleIsUnitary`, `primitiveAmplitudeOracleSemanticContract` | contract compiled; proof of the contract open |
| primitive clean-block extraction | extraction of an $n$-qubit clean block from the primitive matrix | `primitiveAmplitudeOracleCleanBlockExtracts`, `primitiveAmplitudeOracleSemanticContract_cleanBlock_eq_target` | conditional bridge compiled; extraction proof open |
| exact standard rational completion | one-signal, no-workspace `Rat` unitary whose clean block is $D_n$ | verifier packet `DIAG-PRIM-WITNESS-001.rat-one-signal.*` | rejected as a subroute by determinant-square obstruction for `n = 1, 2, 3` |
| Real/Complex primitive route | one-signal amplitude oracle over a scalar tier that supports $\sqrt{1-a^2}$ or rotations | no Lean declaration yet | parked alternative for this cycle |
| expanded arithmetic route | reversible arithmetic plus controlled rotations; for standard `R_y(theta)`, the clean entry is `cos(theta/2)`, so amplitude `a` uses `theta = 2 arccos(a)` | `expandedAmplitudeOracleLayout`, `expandedAmplitudeOracleCleanBlockContract`, `expandedAmplitudeOracleSemanticContract_cleanBlock_eq_target` | compiled conditional interface; concrete backend obligations open |
| standard `R_y` clean-entry lemma | for every amplitude `a` in `[0,1]`, prove the scalar-tier identity `cos((2 * arccos a) / 2) = a` | `StandardRyCleanEntryScalarTier`; `expandedRyCleanEntryForCubicAmplitudes`; `expandedRyCleanEntryForCubicAmplitudes_of_standardTier`; transparent route declarations `expandedControlledRyUsesCubicAngleTransparent` and `fixedDenomControlledRyRouteTransparent`; parked opaque bridge declarations `expandedControlledRyBackendBridge` and `expandedControlledRyUsesCubicAngle_of_backendBridge` | scalar-tier range bridge, transparent rotation witness, and transparent rotation contract refactor compile; opaque backend witness remains parked |
| reversible cubic arithmetic | compute `CubicStatePreparation.cubicAmplitude n j` into workspace without changing the system index | `ExpandedCubicArithmeticBackend`, `symbolicExpandedCubicArithmeticBackend`, `symbolicExpandedCubicArithmeticBackend_computes`, bridge normal forms, fixed-denominator declarations `fixedDenomCubicPayload_lt_capacity`, `fixedDenomCubicAmplitude_eq`, `fixedDenomCubicArithmeticBackend`, `fixedDenomCubicArithmeticBackend_computes`, `fixedDenomCubicArithmeticBackend_bridge_iff`, transparent route declarations `expandedArithmeticComputesCubicAmplitudeTransparent`, `fixedDenomCubicArithmeticRouteTransparent` | symbolic and fixed-denominator compute leaves compile; transparent arithmetic contract refactor compiles; opaque arithmetic route predicate remains parked |
| clean uncompute | inverse arithmetic restores every workspace register to zero after the rotation | `ExpandedArithmeticCleanUncomputeWitness`, `expandedWorkspaceCleanUncomputedTransparent`, `expandedWorkspaceCleanUncomputedTransparent_of_witness`, `fixedDenomCubicComputeStep`, `fixedDenomCubicUncomputeStep`, `fixedDenomExpandedArithmeticCleanUncomputeWitness`, `fixedDenomWorkspaceCleanUncomputedTransparent`; opaque target `expandedWorkspaceCleanUncomputed` | transparent interface and fixed-denominator cleanup witness compile; active missing dependency is `DIAG-RY-WORKSPACE-READONLY-001`; opaque cleanup route remains blocked |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-TGT-001` | Define the diagonal cubic target matrix. | none | existing Lean | `CubicDiagonalOracle.cubicDiagonalOperator`, `cubicDiagonalTarget` | this conversion window, Source And Lean Symbols | `python3 tools/qbe.py check` | proved |
| `DIAG-RANGE-001` | Prove each diagonal amplitude lies in `[0,1]`. | `gridPoint_nonneg`, `gridPoint_le_one`, `rat_pow_le_one_of_nonneg_le_one` | existing Lean | `cubicAmplitude_nonneg`, `cubicAmplitude_le_one` | Source-Contract Audit | `python3 tools/qbe.py check` | proved |
| `DIAG-RESOURCE-001` | Record one-signal oracle-label layout, candidate record, and score `(1, 1, 1, 1)`. | `amplitudeOracleLayout`, `amplitudeOracleCircuit` | existing Lean and lower 2 Lean worker | `amplitudeOracleResourceTuple_eq`, `primitiveAmplitudeOracleCandidate_costTuple_eq` | Lean-Facing Contract | `python3 tools/qbe.py check` passed 2026-06-19 21:08 JST | proved |
| `DIAG-BLOCK-BRIDGE-001` | Any block satisfying `diagonalCleanBlockContract` is pointwise equal to `(cubicDiagonalTarget n).operator`. | `DIAG-TGT-001`, `diagonalCleanBlockContract_pointwise_eq` | lower 2 Lean worker | `CubicDiagonalOracle.primitiveOracleCleanBlock_eq_target` | Lean-Facing Contract | `python3 tools/qbe.py check` passed 2026-06-19 20:44 JST | proved |
| `DIAG-PRIM-UNITARY-001` | Name the primitive oracle-label matrix, unitarity obligation, clean-block extraction obligation, and prove the contract implies target clean-block equality. | `DIAG-RANGE-001`, `DIAG-BLOCK-BRIDGE-001` | middle Lean update | `primitiveAmplitudeOracleSemanticContract`, `primitiveAmplitudeOracleSemanticContract_cleanBlock_eq_target` | Lean-Facing Contract | `lake build` passed 2026-06-19 20:59 JST | compiled conditional bridge |
| `DIAG-PRIM-WITNESS-001` | Supply or explicitly accept a proof of `primitiveAmplitudeOracleSemanticContract n`, but not as a standard exact `Rat` one-signal/no-workspace completion. | `DIAG-PRIM-UNITARY-001`, source/user acceptance of primitive oracle tier | upper decision only | target proof of `primitiveAmplitudeOracleSemanticContract n` | `DIAG-PRIM-WITNESS-001.rat-one-signal.md` | `python3 tools/qbe.py check` | blocked subroute; exact rational completion rejected and not assigned this cycle |
| `DIAG-ROUTE-CONTRACT-001` | Choose the next Lean-facing route contract after the rejected rational primitive subroute. | `DIAG-RANGE-001`, `DIAG-BLOCK-BRIDGE-001`, `DIAG-PRIM-WITNESS-001` verifier rejection | upper director synthesis | expanded route selected for cycle 1 | this conversion window, Lower-Agent Packets | `python3 tools/qbe.py check` | resolved for this cycle |
| `DIAG-REALAMP-CONTRACT-001` | If revived, define a scalar-tier amplitude-oracle contract that can express per-index rotations or $\sqrt{1-a^2}$ and whose clean block casts the target diagonal correctly. | `DIAG-ROUTE-CONTRACT-001` | future upper/lower only if selected | planned Real/Complex contract declarations | Source-Contract Audit | `python3 tools/qbe.py check` | parked alternative |
| `DIAG-EXPANDED-CONTRACT-001` | Define the expanded arithmetic route contract: compute $a_j=(j/2^n)^3$, apply the correct controlled rotation, uncompute workspace, and extract the diagonal clean block. | `DIAG-ROUTE-CONTRACT-001` | lower architect, concurrent Lean worker, verifier | `expandedAmplitudeOracleLayout`, `expandedAmplitudeOracleCleanBlockContract`, `expandedAmplitudeOracleSemanticContract_cleanBlock_eq_target` | `proof-attempts/QBE-OP-CUBIC-DIAGONAL-001-diag-amplitude-proof-dag.md`, Source-Contract Audit | `python3 tools/qbe.py check` | compiled conditional interface; interface rebuild is stale |
| `DIAG-EXP-RY-001` | Prove or transparently refine the standard `R_y(theta)` scalar-tier clean-entry obligation for `theta_j = 2 arccos((j/2^n)^3)`. | `DIAG-RANGE-001`, `DIAG-EXPANDED-CONTRACT-001`, technical lemma `tl-cubic-diagonal-ry-clean-entry` | lower Lean worker | `StandardRyCleanEntryScalarTier`, `expandedRyCleanEntryForCubicAmplitudes_of_standardTier` | Expanded Route Interface Contract, technical-lemma ledger | `python3 tools/qbe.py check` | scalar-tier range bridge compiled; broad leaf retired |
| `DIAG-RY-BACKEND-WITNESS-001` | Supply a concrete backend-semantics witness that the expanded route's controlled rotation uses the same scalar-tier angle and clean-entry convention. | `DIAG-EXP-RY-001`, backend rotation semantics | future lower Lean worker only if backend semantics are introduced | witness of `expandedControlledRyBackendBridge tier n workspaceQubits` | Lower-facing source contract, verifier feedback `DIAG-RY-BRIDGE-001.middle.md` | `python3 tools/qbe.py check` | blocked backend obligation; no current witness in the Lean surface |
| `DIAG-RY-BRIDGE-001` | Connect the compiled scalar-tier clean-entry specialization to the expanded backend predicate without trivializing opaque semantics. | `DIAG-RY-BACKEND-WITNESS-001`, `DIAG-EXPANDED-CONTRACT-001` | future lower Lean worker after backend witness | `expandedControlledRyBackendBridge`, `expandedControlledRyUsesCubicAngle_of_backendBridge`; route target `expandedControlledRyUsesCubicAngle` | Expanded Route Interface Contract, verifier feedback `DIAG-RY-BRIDGE-001.middle.md` | `python3 tools/qbe.py check` | conditional bridge compiled; route predicate remains unclosed without backend witness |
| `DIAG-EXP-ARITH-001` | Prove or refine reversible computation of `CubicStatePreparation.cubicAmplitude n j` into workspace. | `DIAG-RANGE-001`, `DIAG-EXPANDED-CONTRACT-001` | lower Lean worker | `ExpandedCubicArithmeticBackend`, `symbolicExpandedCubicArithmeticBackend`, `symbolicExpandedCubicArithmeticBackend_computes`, `expandedArithmeticBackendBridge`, `expandedArithmeticComputesCubicAmplitude_of_backendBridge`, `expandedArithmeticBackendBridge_iff_of_computes`, `expandedArithmeticComputesCubicAmplitude_of_symbolicBackendBridge`; target `expandedArithmeticComputesCubicAmplitude` | Expanded Route Interface Contract | `python3 tools/qbe.py check` | parent arithmetic leaf; pointwise compute plus bridge search now normalizes to the opaque route predicate; route predicate still needs a concrete representation-backed witness |
| `DIAG-EXP-ARITH-BACKEND-001` | Instantiate a compute-phase backend and prove it preserves `j` and writes `CubicStatePreparation.cubicAmplitude n j`. | `DIAG-EXP-ARITH-001` backend-shape declarations, finite arithmetic diagnostic for `n = 1..5` | lower Lean worker | `symbolicExpandedCubicArithmeticBackend`; proof `symbolicExpandedCubicArithmeticBackend_computes` | Lower-facing source contract; verifier feedback `DIAG-EXP-ARITH-BACKEND-001.lower-symbolic-backend.md` | `python3 tools/qbe.py check` | symbolic compute portion compiled; route bridge split into `DIAG-ARITH-BACKEND-BRIDGE-001` |
| `DIAG-ARITH-REP-001` | Specify the concrete workspace/register/backend representation for the selected arithmetic route. | `DIAG-EXP-ARITH-BACKEND-001` | lower 1 proof-map architect and lower refiner | capacity/algebra Lean declarations compiled; proof-map candidate is the fixed-denominator `3 * n`-qubit numerator workspace from `proof-attempts/QBE-OP-CUBIC-DIAGONAL-001-DIAG-ARITH-REP-001-fixed-denom-architect-20260620-0526.md` | Lower-facing source contract; verifier feedback `DIAG-ARITH-REP-001.fixed-denom-architect-20260620-0526.feedback.json` | `python3 tools/qbe.py check` | fixed-denominator representation selected; capacity, algebra, and backend compute leaves proved |
| `DIAG-ARITH-FIXED-DENOM-CAP-001` | Prove the fixed-denominator numerator `j.val ^ 3` fits in `Fin (gridSize (3 * n))`. | `DIAG-ARITH-REP-001`, `j.isLt`, `gridSize_three_mul_eq_cube` | lower Lean worker | `fixedDenomCubicPayload_lt_capacity` | fixed-denominator proof design | `python3 tools/qbe.py check` passed 2026-06-20 06:08 JST | proved |
| `DIAG-ARITH-FIXED-DENOM-ALG-001` | Prove `(j.val : Rat) ^ 3 / (gridSize (3 * n) : Rat) = CubicStatePreparation.cubicAmplitude n j`. | `DIAG-ARITH-FIXED-DENOM-CAP-001`, `gridPoint`, `cubicAmplitude`, rational power/division algebra | lower refiner | `fixedDenomCubicAmplitude_eq` | fixed-denominator proof design | `python3 tools/qbe.py check` passed 2026-06-20 06:11 JST | proved |
| `DIAG-ARITH-FIXED-DENOM-BACKEND-001` | Define the `3 * n`-workspace backend and prove its pointwise compute contract. | `DIAG-ARITH-FIXED-DENOM-CAP-001`, `DIAG-ARITH-FIXED-DENOM-ALG-001` | lower Lean worker | `fixedDenomCubicArithmeticBackend`, `fixedDenomCubicArithmeticBackend_computes` | fixed-denominator proof design | `python3 tools/qbe.py check` passed 2026-06-20 06:56 JST | proved |
| `DIAG-ARITH-ROUTE-INTERFACE-001` | State the transparent backend-to-route arithmetic semantics interface that turns the fixed-denominator pointwise compute theorem into a non-opaque arithmetic route witness without closing an opaque proposition by `trivial`. | `DIAG-ARITH-FIXED-DENOM-BACKEND-001`, `expandedArithmeticBackendBridge_iff_of_computes`, route-semantics design | lower Lean worker | `expandedArithmeticComputesCubicAmplitudeTransparent`, `fixedDenomCubicArithmeticRouteTransparent`; normal-form memory `fixedDenomCubicArithmeticBackend_bridge_iff` | lower packet `proof-attempts/QBE-OP-CUBIC-DIAGONAL-001-DIAG-ARITH-BACKEND-BRIDGE-001-route-interface.md` | `python3 tools/qbe.py check` passed 2026-06-20 08:33 JST | proved transparent witness; not a route certificate |
| `DIAG-ARITH-BACKEND-BRIDGE-001` | Supply `hBridge : expandedArithmeticBackendBridge backend` for a concrete backend, or explicitly replace the opaque route predicate with the transparent route-semantics interface. | `DIAG-ARITH-FIXED-DENOM-BACKEND-001`, `DIAG-ARITH-ROUTE-INTERFACE-001`, backend-to-route semantics | future lower Lean worker after the route-semantics interface exists | required witness of `expandedArithmeticBackendBridge`; closure theorem `expandedArithmeticComputesCubicAmplitude_of_backendBridge`; refiner normal forms `expandedArithmeticBackendBridge_iff_of_computes`, `symbolicExpandedCubicArithmeticBackend_bridge_iff`, and `fixedDenomCubicArithmeticBackend_bridge_iff` | Lower-facing source contract; verifier feedback `DIAG-ARITH-BACKEND-BRIDGE-001.middle-source-contract.md`, `DIAG-ARITH-BACKEND-BRIDGE-001.middle-cycle02-source-correspondence.md`, `DIAG-ARITH-BACKEND-BRIDGE-001.middle-representation-refresh-20260620-0428.md`, `DIAG-ARITH-BACKEND-BRIDGE-001.lower-refiner-20260620-0446.feedback.json`, `DIAG-ARITH-BACKEND-BRIDGE-001.lower-refiner-20260620-0524.feedback.json`, `DIAG-ARITH-ROUTE-INTERFACE-001.lower-refiner-20260620-074847.feedback.json`, and `DIAG-ARITH-ROUTE-TRANSPARENT-001.middle-source-correspondence-20260620-0812.feedback.json` | `python3 tools/qbe.py check` | blocked parent; direct bridge search for the fixed-denominator backend is now explicitly equivalent to the opaque route predicate |
| `DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001` | State a transparent cleanup witness interface without proving the opaque cleanup predicate. | `DIAG-EXP-ARITH-001`, fixed-denominator backend representation | lower Lean worker | `ExpandedArithmeticCleanUncomputeWitness`, `expandedWorkspaceCleanUncomputedTransparent`, `expandedWorkspaceCleanUncomputedTransparent_of_witness` | Expanded Route Interface Contract | `python3 tools/qbe.py check` passed 2026-06-20 12:21 JST | proved; not a route certificate |
| `DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001` | Instantiate the transparent cleanup interface with modular add/sub compute and uncompute steps over `Fin (gridSize (3 * n))`. | `DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001`, fixed-denominator backend compute, payload capacity | lower Lean worker | `fixedDenomCubicComputeStep`, `fixedDenomCubicUncomputeStep`, `fixedDenomExpandedArithmeticCleanUncomputeWitness`, `fixedDenomWorkspaceCleanUncomputedTransparent` | verifier feedback `DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001.lower-worker5-20260620-1307.feedback.json` | `python3 tools/qbe.py check` passed 2026-06-20 13:07 JST | proved transparent witness; not a route certificate |
| `DIAG-RY-WORKSPACE-READONLY-001` | State that the controlled signal rotation reads the arithmetic payload and preserves the system index and workspace. | transparent rotation bookkeeping, fixed-denominator cleanup witness | next lower source-contract and Lean-interface worker | planned `ExpandedControlledRyWorkspaceReadonlyWitness` and `expandedControlledRyWorkspaceReadonlyTransparent` | this conversion window; verifier feedback `DIAG-RY-WORKSPACE-READONLY-001.middle-source-contract-20260620-1540.*` | `python3 tools/qbe.py check` | active leaf |
| `DIAG-EXP-UNCOMP-001` | Prove or refactor route-level clean uncompute after arithmetic compute and controlled rotation. | fixed-denominator transparent cleanup witness plus `DIAG-RY-WORKSPACE-READONLY-001` | future lower worker after readonly interface | opaque target `expandedWorkspaceCleanUncomputed`, or a later explicit transparent contract boundary | Expanded Route Interface Contract | `python3 tools/qbe.py check` | blocked parent |
| `DIAG-ROOT-001` | Exact operator block-encoding certificate for the selected primitive or expanded route. | `DIAG-RESOURCE-001` plus either `DIAG-PRIM-WITNESS-001` or the expanded route certificate | future lower Lean | `primitiveAmplitudeOracleVerified n h` for the primitive path, or planned expanded certificate | Proof-DAG Frontier | `python3 tools/qbe.py check` | blocked until a route certificate exists |
| `DIAG-EXPORT-001` | Qiskit, QuantumKatas-style, and QASM3 export plan tied to the named Lean certificate. | `DIAG-ROOT-001` | future verifier/export lower | planned `executable-exports/QBE-OP-CUBIC-DIAGONAL-001/` packet | export bridge after Lean closure | `python3 tools/qbe.py check` plus export checks | blocked downstream |

## Middle Source-Correspondence Packet

Source anchors and object:

- The source anchor is the user prompt copied in `tasks/QBE-OP-CUBIC-DIAGONAL-001.md`; no paper archive or figure applies.
- The translated object is the diagonal operator $D_n$ with entries $(j/2^n)^3$ on the diagonal and zero off diagonal, with normalizer $\alpha = 1$.

Lean declarations and obligations:

- The target, range lemmas, resource tuple, and clean-block bridge are compiled as `cubicDiagonalOperator`, `exactNormalizer`, `cubicAmplitude_nonneg`, `cubicAmplitude_le_one`, `primitiveOracleCleanBlock_eq_target`, and `primitiveAmplitudeOracleCandidate_costTuple_eq`.
- The primitive opaque contract surface is compiled as `primitiveAmplitudeOracleSemanticContract`, but no proof of `primitiveAmplitudeOracleSemanticContract n` is available.
- The expanded-route interface and conditional bridges are compiled.  `DIAG-EXP-RY-001` now has a compiled scalar-tier range bridge, `expandedRyCleanEntryForCubicAmplitudes_of_standardTier`.  `DIAG-RY-BRIDGE-001` now has the conditional bridge `expandedControlledRyUsesCubicAngle_of_backendBridge`, which closes the route predicate only from an explicit backend witness and does not package a verified candidate.  `DIAG-EXP-ARITH-001` now has the backend-shape declarations `ExpandedCubicArithmeticBackend` and `expandedArithmeticBackendComputesCubicAmplitude`, the symbolic compute-phase witness `symbolicExpandedCubicArithmeticBackend`, its pointwise proof `symbolicExpandedCubicArithmeticBackend_computes`, the general conditional bridge `expandedArithmeticComputesCubicAmplitude_of_backendBridge`, the proof-reduction normal form `expandedArithmeticBackendBridge_iff_of_computes`, and the symbolic-backend specialization `expandedArithmeticComputesCubicAmplitude_of_symbolicBackendBridge`; the bridge witness from that backend to the opaque route predicate remains open.

External and local glue:

- There is no paper-cited external result for this user-provided target.
- Any reversible arithmetic, rotation, or clean-workspace theorem used by the expanded route must be introduced as QBE-local semantic glue or as a technical-lemma obligation before a later proof depends on it.
- The rotation convention is fixed for the next packet: standard `R_y(theta)` has clean entry `cos(theta/2)`, so amplitude $a_j$ uses `theta_j = 2 arccos(a_j)`.

Ownership:

- The active paper/user target owns only the diagonal operator, normalizer, and requested export languages.
- The primitive amplitude-oracle semantics are an external primitive contract unless explicitly accepted by upper or the user.
- The expanded arithmetic and rotation semantics are QBE-local construction obligations.

Current middle refresh, 2026-06-20 03:49 JST:

| Required correspondence item | Current record |
|---|---|
| source anchor and translated object | user-provided diagonal operator $D_n[row,col] = (row/2^n)^3$ when `row = col`, zero otherwise; no paper-source archive is available or needed |
| Lean declarations and theorem statements | target and range declarations are compiled; `expandedRyCleanEntryForCubicAmplitudes_of_standardTier` and `expandedControlledRyUsesCubicAngle_of_backendBridge` compile; `expandedControlledRyUsesCubicAngle` itself remains opaque and unproved |
| proof obligations | concrete witness `hBridge : expandedControlledRyBackendBridge tier n workspaceQubits` is recorded as an open backend obligation; arithmetic has a symbolic compute backend and pointwise proof.  This 03:49 row is superseded by the 05:48 fixed-denominator representation refresh, where `DIAG-ARITH-REP-001` is specified in proof memory and the next Lean leaf is `DIAG-ARITH-FIXED-DENOM-CAP-001`.  Later obligations are `expandedWorkspaceCleanUncomputed` and `expandedAmplitudeOracleCleanBlockExtracts`. |
| external technical lemma or cited-result row | none for the user operator target; the standard rotation identity is tracked as QBE-local technical lemma `tl-cubic-diagonal-ry-clean-entry`, with scalar-tier specialization compiled and backend semantics still open |
| ownership split | user target owns the diagonal operator, $\alpha=1$, and requested export languages; primitive oracle semantics are an external primitive contract unless accepted; expanded arithmetic, rotation backend, uncompute, and extraction are QBE-local semantic glue |
| next lower packet | lower 1 records the arithmetic representation contract for `DIAG-ARITH-REP-001`; lower 2 targets `DIAG-ARITH-BACKEND-BRIDGE-001` only after a representation is named; lower 3 only reruns arithmetic/register diagnostics if the proposed backend changes the representation |

Middle cycle-2 source-correspondence classification:

| Field | Classification |
|---|---|
| source anchor | user prompt in `tasks/QBE-OP-CUBIC-DIAGONAL-001.md`; no paper source or cited theorem is active |
| active paper/user object | diagonal operator $D_n[row,col] = (row/2^n)^3$ when `row = col`, zero otherwise, with $\alpha = 1$ |
| active Lean object | `symbolicExpandedCubicArithmeticBackend n workspaceQubits` plus `symbolicExpandedCubicArithmeticBackend_computes n workspaceQubits` |
| missing Lean interface | `expandedArithmeticBackendBridge (symbolicExpandedCubicArithmeticBackend n workspaceQubits)` |
| dependency class | QBE-local semantic glue, not an external cited-result obligation and not a source-translation gap |
| verifier class | historical `symbolic_bridge_gap` before the 05:26 fixed-denominator representation packet |
| next route | superseded by the 05:48 route: compile `fixedDenomCubicPayload_lt_capacity`, then `fixedDenomCubicAmplitude_eq`; keep the opaque bridge blocked |

Middle representation refresh, 2026-06-20 04:28 JST:

| Required item | Current source-correspondence state |
|---|---|
| source anchors and translated object | The only source anchor is the user prompt in `tasks/QBE-OP-CUBIC-DIAGONAL-001.md`; the translated object remains the diagonal operator $D_n[row,col] = (row/2^n)^3$ when `row = col`, zero otherwise, with $\alpha = 1$. |
| Lean declarations and theorem statements | The symbolic compute witness `symbolicExpandedCubicArithmeticBackend n workspaceQubits` and proof `symbolicExpandedCubicArithmeticBackend_computes n workspaceQubits` compile.  The closure theorem `expandedArithmeticComputesCubicAmplitude_of_symbolicBackendBridge n workspaceQubits hBridge` is conditional on `hBridge`. |
| proof obligation needed by the next lower packet | The immediate dependency is `DIAG-ARITH-REP-001`: a concrete workspace/register/backend representation for the arithmetic route.  Without that representation, `DIAG-ARITH-BACKEND-BRIDGE-001` must remain blocked rather than treated as a tactic-search leaf. |
| external technical lemma or cited-result row | None is active.  The missing bridge is QBE-local semantic glue, not a cited theorem and not a paper-source gap. |
| ownership split | The user target owns the diagonal operator, $\alpha = 1$, and requested export languages.  The primitive oracle contract is external unless accepted.  `DIAG-ARITH-REP-001`, `DIAG-ARITH-BACKEND-BRIDGE-001`, rotation backend semantics, clean uncompute, extraction, and unitarity are QBE-local construction obligations. |

Middle source-correspondence refresh, 2026-06-20 05:07 JST:

| Required item | Current source-correspondence state |
|---|---|
| source anchors and paper/user object | The only source anchor is the user prompt copied in `tasks/QBE-OP-CUBIC-DIAGONAL-001.md`.  The object is the diagonal operator $D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise, with $\alpha = 1$. |
| Lean declarations and theorem statements | The target, range lemmas, primitive conditional bridge, expanded clean-block conditional bridge, symbolic arithmetic backend, pointwise arithmetic proof, general bridge normal form, symbolic-backend conditional closure, and symbolic bridge normal form all compile.  The current arithmetic names are `symbolicExpandedCubicArithmeticBackend`, `symbolicExpandedCubicArithmeticBackend_computes`, `expandedArithmeticBackendBridge_iff_of_computes`, `expandedArithmeticComputesCubicAmplitude_of_symbolicBackendBridge`, and `symbolicExpandedCubicArithmeticBackend_bridge_iff`. |
| proof obligations | The next active lower objective is `DIAG-ARITH-REP-001`: name a concrete workspace/register/backend representation, or record that no such representation exists.  `DIAG-ARITH-BACKEND-BRIDGE-001` is a blocked parent until that representation exists. |
| external technical lemma or cited-result row | None is active.  This is a user/operator target; the missing representation and bridge are QBE-local semantic glue. |
| ownership split | The user target owns the diagonal operator, $\alpha = 1$, and requested export languages.  Primitive oracle semantics are an external primitive contract unless accepted.  Expanded arithmetic representation, arithmetic bridge, rotation backend semantics, clean uncompute, extraction, and unitarity are QBE-local construction obligations. |

Middle source-correspondence refresh, 2026-06-20 05:48 JST:

| Required item | Current source-correspondence state |
|---|---|
| source anchors and paper/user object | The only source anchor is the user prompt copied in `tasks/QBE-OP-CUBIC-DIAGONAL-001.md`.  The object remains the diagonal operator $D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise, with $\alpha = 1$. |
| Lean declarations and theorem statements | The target, range lemmas, primitive conditional bridge, expanded clean-block conditional bridge, symbolic arithmetic backend, pointwise symbolic compute proof, bridge normal forms, `fixedDenomCubicPayload_lt_capacity`, and `fixedDenomCubicAmplitude_eq` compile. |
| proof obligations | `DIAG-ARITH-REP-001` is no longer an unspecified-representation leaf.  It has the fixed-denominator proof-map candidate from `proof-attempts/QBE-OP-CUBIC-DIAGONAL-001-DIAG-ARITH-REP-001-fixed-denom-architect-20260620-0526.md`: workspace `Fin (gridSize (3 * n))`, clean value `0`, payload `j.val ^ 3`, and amplitude projection `payload / gridSize (3 * n)`.  The next active Lean leaf is `DIAG-ARITH-FIXED-DENOM-BACKEND-001`. |
| external technical lemma or cited-result row | None is active.  The fixed-denominator capacity and rational-amplitude equalities are QBE-local arithmetic lemmas, not cited external results. |
| ownership split | The user target owns the diagonal operator, $\alpha = 1$, and requested export languages.  Primitive oracle semantics are external unless accepted.  The fixed-denominator workspace, arithmetic backend, backend bridge, rotation backend, clean uncompute, extraction, and unitarity remain QBE-local construction obligations. |

Middle source-correspondence refresh, 2026-06-20 06:38 JST:

| Required item | Current source-correspondence state |
|---|---|
| source anchors and paper/user object | The only source anchor remains the user prompt copied in `tasks/QBE-OP-CUBIC-DIAGONAL-001.md`; no paper source, figure, or cited theorem is active.  The object is still the diagonal operator $D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise, with $\alpha = 1$. |
| Lean declarations and theorem statements | The target, range lemmas, primitive conditional bridge, expanded clean-block conditional bridge, symbolic arithmetic backend, pointwise symbolic compute proof, bridge normal forms, `fixedDenomCubicPayload_lt_capacity`, and `fixedDenomCubicAmplitude_eq` compile.  No declaration named `fixedDenomCubicArithmeticBackend` or `fixedDenomCubicArithmeticBackend_computes` is present yet. |
| proof obligations | The active lower leaf is `DIAG-ARITH-FIXED-DENOM-BACKEND-001`: define the fixed-denominator backend and prove its pointwise compute contract using the closed capacity and amplitude-equality lemmas.  `DIAG-ARITH-BACKEND-BRIDGE-001`, `DIAG-RY-BACKEND-WITNESS-001`, clean uncompute, root certificate, and executable exports remain blocked. |
| external technical lemma or cited-result row | None is active.  The next leaf is QBE-local arithmetic semantic glue, not an external cited theorem and not a paper-source gap. |
| ownership split | The user target owns the diagonal operator, $\alpha = 1$, and requested export languages.  Primitive oracle semantics are external unless accepted.  Fixed-denominator backend semantics, backend bridge, rotation backend, clean uncompute, extraction, unitarity, and export packets are QBE-local construction obligations. |

Lower Lean implementation update, 2026-06-20 06:56 JST:

| Required item | Current source-correspondence state |
|---|---|
| source anchors and paper/user object | The only source anchor remains the user prompt copied in `tasks/QBE-OP-CUBIC-DIAGONAL-001.md`; no paper source, figure, or cited theorem is active.  The object is still the diagonal operator $D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise, with $\alpha = 1$. |
| Lean declarations and theorem statements | Added `fixedDenomCubicArithmeticBackend n : ExpandedCubicArithmeticBackend n (3 * n)` and proved `fixedDenomCubicArithmeticBackend_computes n : expandedArithmeticBackendComputesCubicAmplitude (fixedDenomCubicArithmeticBackend n)`. |
| proof obligations | `DIAG-ARITH-FIXED-DENOM-BACKEND-001` is closed.  `DIAG-ARITH-BACKEND-BRIDGE-001`, `DIAG-RY-BACKEND-WITNESS-001`, clean uncompute, root certificate, and executable exports remain blocked. |
| external technical lemma or cited-result row | None is active.  The closed backend leaf is QBE-local arithmetic semantic glue, not an external cited theorem and not a paper-source gap. |
| ownership split | This update only certifies pointwise compute semantics for the fixed-denominator backend; it does not prove expanded route semantics, clean-block extraction, unitarity, or executable exports. |

Middle source-correspondence refresh, 2026-06-20 07:26 JST:

| Required item | Current source-correspondence state |
|---|---|
| source anchors and paper/user object | The only source anchor remains the user prompt copied in `tasks/QBE-OP-CUBIC-DIAGONAL-001.md`.  The object is the diagonal operator $D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise, with $\alpha = 1$. |
| Lean declarations and theorem statements | `fixedDenomCubicArithmeticBackend` and `fixedDenomCubicArithmeticBackend_computes` compile.  The theorem `expandedArithmeticBackendBridge_iff_of_computes` shows that a direct bridge proof from any pointwise compute backend reduces to the opaque route predicate. |
| proof obligations | The closed backend leaf is retired.  The active source-contract leaf is `DIAG-ARITH-ROUTE-INTERFACE-001`: define the transparent backend-to-route arithmetic semantics interface that would let `fixedDenomCubicArithmeticBackend_computes n` feed `expandedArithmeticComputesCubicAmplitude n (3 * n)` without adding an axiom, changing a semantic proposition to `True`, or using `trivial` to close an opaque predicate. |
| external technical lemma or cited-result row | None is active.  This is QBE-local semantic glue for a user/operator target, not a cited theorem and not a paper-source gap. |
| ownership split | The user target owns the diagonal operator, $\alpha = 1$, and requested export languages.  QBE owns the route-interface, arithmetic bridge, rotation backend witness, clean uncompute, extraction, unitarity, root certificate, and post-Lean export obligations. |

Middle source-correspondence refresh, 2026-06-20 08:12 JST:

| Required item | Current source-correspondence state |
|---|---|
| source anchors and paper/user object | The only source anchor remains the user prompt copied in `tasks/QBE-OP-CUBIC-DIAGONAL-001.md`.  No paper source, figure, visual audit, or cited theorem is active.  The object is still the diagonal operator $D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise, with $\alpha = 1$. |
| Lean declarations and theorem statements | The fixed-denominator capacity, algebra, backend compute, and bridge-normal-form declarations compile: `fixedDenomCubicPayload_lt_capacity`, `fixedDenomCubicAmplitude_eq`, `fixedDenomCubicArithmeticBackend`, `fixedDenomCubicArithmeticBackend_computes`, and `fixedDenomCubicArithmeticBackend_bridge_iff`.  The normal form shows that direct proof of `expandedArithmeticBackendBridge (fixedDenomCubicArithmeticBackend n)` is equivalent to the opaque predicate `expandedArithmeticComputesCubicAmplitude n (3 * n)`. |
| adopted transparent interface for lower work | The next build-testable Lean target is a transparent existential arithmetic predicate: `expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits := exists backend, expandedArithmeticBackendComputesCubicAmplitude backend`.  The fixed-denominator witness theorem should be `fixedDenomCubicArithmeticRouteTransparent (n : Nat) : expandedArithmeticComputesCubicAmplitudeTransparent n (3 * n)`, proved from `fixedDenomCubicArithmeticBackend n` and `fixedDenomCubicArithmeticBackend_computes n`. |
| proof obligations | This transparent witness is not a root certificate and does not prove the current opaque predicate.  After it compiles, upper or middle must explicitly choose either to refactor the expanded arithmetic contract to use the transparent predicate or to add a named nontrivial bridge from the transparent predicate to `expandedArithmeticComputesCubicAmplitude`.  `DIAG-RY-BACKEND-WITNESS-001`, clean uncompute, clean-block extraction, unitarity, and exports remain blocked. |
| external technical lemma or cited-result row | None is active.  The transparent interface is QBE-local semantic glue for a user/operator target, not an external cited result and not a paper-source dependency. |
| ownership split | The user target owns only the diagonal operator, $\alpha = 1$, and requested export languages.  QBE owns the transparent arithmetic route predicate, the later bridge or contract refactor, rotation backend semantics, clean uncompute, extraction, unitarity, root certificate, and post-Lean exports. |

Lower Lean implementation update, 2026-06-20 08:33 JST:

| Required item | Current source-correspondence state |
|---|---|
| Lean declarations and theorem statements | `expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits` and `fixedDenomCubicArithmeticRouteTransparent n` compile.  The witness theorem uses `fixedDenomCubicArithmeticBackend n` and `fixedDenomCubicArithmeticBackend_computes n`. |
| proof obligations | `DIAG-ARITH-ROUTE-TRANSPARENT-001` is closed as a transparent witness leaf.  It does not prove `expandedArithmeticComputesCubicAmplitude n (3 * n)`, does not supply `expandedArithmeticBackendBridge`, and does not close root, unitarity, clean-block extraction, clean uncompute, or exports. |
| next route | Upper or middle must choose either a named nontrivial bridge from the transparent predicate to the opaque route predicate, or a contract refactor that consumes the transparent predicate directly. |

Lower-facing source contract:

```text
Closed lower leaf: DIAG-ARITH-FIXED-DENOM-BACKEND-001
Closed arithmetic leaves: DIAG-ARITH-FIXED-DENOM-CAP-001 and
  DIAG-ARITH-FIXED-DENOM-ALG-001
Representation parent: DIAG-ARITH-REP-001
Blocked backend parent: DIAG-ARITH-BACKEND-BRIDGE-001, the bridge child of
  DIAG-EXP-ARITH-001
Source object: D_n[row,col] = if row = col then (row / 2^n)^3 else 0
Normalizer: alpha = 1
Register map: n-qubit system index j, one signal qubit, and a fixed-denominator
  arithmetic workspace `Fin (gridSize (3 * n))` whose clean value is `0`.
Current compiled compute witness:
  `symbolicExpandedCubicArithmeticBackend n workspaceQubits` with
  `symbolicExpandedCubicArithmeticBackend_computes n workspaceQubits`.
Fixed-denominator representation candidate:
  workspaceQubits = 3 * n;
  payload register basis = Fin (gridSize (3 * n));
  compute phase sends clean workspace to payload `j.val ^ 3`;
  amplitude projection is
    `(payload : Rat) / (gridSize (3 * n) : Rat)`;
  source equality target is
    `(j.val : Rat) ^ 3 / (gridSize (3 * n) : Rat) =
      CubicStatePreparation.cubicAmplitude n j`.
Closed Lean leaves:
  `fixedDenomCubicPayload_lt_capacity`, proving
    `j.val ^ 3 < gridSize (3 * n)` for `j : Fin (gridSize n)`,
  using `j.isLt` and `CubicStatePreparation.gridSize_three_mul_eq_cube n`;
  `fixedDenomCubicAmplitude_eq`, proving the fixed-denominator rational
    payload equals `CubicStatePreparation.cubicAmplitude n j`.
Lower proof-architecture refinement, 2026-06-20 06:08 JST:
  `proof-attempts/QBE-OP-CUBIC-DIAGONAL-001-DIAG-ARITH-FIXED-DENOM-CAP-001-lower-architect-20260620-0608.md`
  records the exact source fragment, definitions, natural proof, proof-DAG
  table, ordered Lean lemma list, and typed feedback for the active capacity
  leaf.  The recommended first theorem is
  `fixedDenomCubicPayload_lt_capacity`; the recommended second theorem is
  `fixedDenomCubicAmplitude_eq`.
Closed backend target:
  `fixedDenomCubicArithmeticBackend n :
    ExpandedCubicArithmeticBackend n (3 * n)` and
  `fixedDenomCubicArithmeticBackend_computes n :
    expandedArithmeticBackendComputesCubicAmplitude
      (fixedDenomCubicArithmeticBackend n)`.
Closed route-interface target:
  `DIAG-ARITH-ROUTE-INTERFACE-001`, a child of
    `DIAG-ARITH-BACKEND-BRIDGE-001`.
  Current natural-language artifact:
    `proof-attempts/QBE-OP-CUBIC-DIAGONAL-001-DIAG-ARITH-BACKEND-BRIDGE-001-route-interface.md`.
  Compiled Lean-facing content:
    `expandedArithmeticComputesCubicAmplitudeTransparent` and
    `fixedDenomCubicArithmeticRouteTransparent`.
  Rejected shortcuts:
    `axiom`, semantic target rewritten to `True`, `trivial` proof of an opaque
    proposition, root theorem attack, representation redesign, and vector
    normalization.
Middle-adopted transparent interface, 2026-06-20 08:12 JST:
  compiled declaration:
    `expandedArithmeticComputesCubicAmplitudeTransparent
        (n workspaceQubits : Nat) : Prop`
  definition:
    an existential over `ExpandedCubicArithmeticBackend n workspaceQubits`
    together with `expandedArithmeticBackendComputesCubicAmplitude backend`.
  compiled lower Lean theorem:
    `fixedDenomCubicArithmeticRouteTransparent (n : Nat) :
      expandedArithmeticComputesCubicAmplitudeTransparent n (3 * n)`.
  proof data:
    witness `fixedDenomCubicArithmeticBackend n`;
    proof `fixedDenomCubicArithmeticBackend_computes n`.
  boundary:
    this proves only the transparent arithmetic route witness.  It must not be
    counted as `expandedArithmeticComputesCubicAmplitude n (3 * n)` unless a
    later named bridge or contract refactor is accepted and compiled.
Blocked parent interface after backend compute exists:
  provide `hBridge : expandedArithmeticBackendBridge
    (fixedDenomCubicArithmeticBackend n)`, or replace the opaque route
  predicate with a transparent backend-to-route semantics interface.  The only
  allowed closure of the route predicate is
  `expandedArithmeticComputesCubicAmplitude_of_backendBridge backend hBackend hBridge`.
Current middle classification:
  workspace_representation_specified=true;
  capacity_lemma_compiled=true;
  amplitude_eq_lemma_compiled=true;
  backend_compute_compiled=true;
  transparent_route_witness_compiled=true;
  repeated attempts on `DIAG-ARITH-BACKEND-BRIDGE-001` before a transparent or
  accepted backend-to-route semantics bridge exists should return `stale_leaf`
  or `error_class=symbolic_bridge_gap`.
Out of scope: controlled-R_y backend witness, clean uncompute, clean-block
  extraction, unitarity certificate, root block-encoding certificate, and
  executable exports.
Forbidden routes: rank-one state preparation, normalized vector target,
  semantic propositions set to True, exact standard Rat one-signal/no-workspace
  witness, and executable export before a named Lean certificate
Gate: python3 tools/qbe.py check
```

## Expanded Route Interface Contract

The detailed natural-language contract for `DIAG-EXPANDED-CONTRACT-001` is in
`proof-attempts/QBE-OP-CUBIC-DIAGONAL-001-diag-amplitude-proof-dag.md`.
The Lean-facing interface should keep the following fields explicit:

| Field | Required contract |
|---|---|
| source anchor | User-provided diagonal operator $D_n = \sum_j (j/2^n)^3 |j\rangle\langle j|$; no paper source applies. |
| system register | `n`-qubit index register, basis `j : Fin (gridSize n)`, preserved by compute, rotation, and uncompute. |
| signal register | one qubit; the clean block is the `0 -> 0` signal projection. |
| arithmetic workspace | route-chosen work registers holding reversible data for $a_j = (j/2^n)^3$ and the angle token; all workspace starts and ends at zero. |
| clean uncompute | after the controlled rotation, inverse arithmetic restores every workspace bit/register and does not change the system index. |
| rotation convention | standard $R_y(\theta)$ with clean entry $\cos(\theta/2)$; use $\theta_j = 2 \arccos(a_j)$ and $a_j = (j/2^n)^3$. |
| scalar tier | `arccos` and `R_y` belong to a Real/Complex rotation semantics tier; a later Lean worker must record this interface or a technical-lemma obligation instead of pretending the gate matrix is exact `Rat`. |
| bridge | `expandedAmplitudeOracleCleanBlockContract n workspaceQubits block` supplies `diagonalCleanBlockContract n block`; then `expandedAmplitudeOracleCleanBlockContract_eq_target` and `expandedAmplitudeOracleSemanticContract_cleanBlock_eq_target` apply `primitiveOracleCleanBlock_eq_target`. |

The expanded layout and conditional bridges are now compiled.  The scalar-tier
range portion of `DIAG-EXP-RY-001` is compiled as
`expandedRyCleanEntryForCubicAmplitudes_of_standardTier`; the bridge leaf
`DIAG-RY-BRIDGE-001` has a compiled conditional bridge
`expandedControlledRyUsesCubicAngle_of_backendBridge`.  A concrete backend
witness for `expandedControlledRyBackendBridge` is recorded as an open backend
obligation before the route predicate can close.  The arithmetic leaf now has a
compiled backend-shape interface, symbolic compute witness, pointwise compute
proof, and conditional bridge; the backend-to-route bridge for
`expandedArithmeticComputesCubicAmplitude` remains open.  Later leaves are
`expandedWorkspaceCleanUncomputed` and
`expandedAmplitudeOracleCleanBlockExtracts`.

## Lower-Agent Packets

Middle coordinator synthesis, refreshed 2026-06-20 08:12 JST:

The active source object is still the user-provided diagonal operator with
$\alpha = 1$.  Lower 1 supplied a fixed-denominator representation for
`DIAG-ARITH-REP-001` in proof memory, the fixed-denominator capacity and
rational-amplitude lemmas compile as `fixedDenomCubicPayload_lt_capacity` and
`fixedDenomCubicAmplitude_eq`, and lower 2 closed the backend compute leaf as
`fixedDenomCubicArithmeticBackend` plus
`fixedDenomCubicArithmeticBackend_computes`.  The next proof work is not another
backend definition; it is the blocked route-semantics bridge.  The compiled
scalar-tier `R_y` bridge remains background memory, not the active leaf.

| Lower role | Exact packet |
|---|---|
| lower 1 natural-language architect | `DIAG-ARITH-ROUTE-TRANSPARENT-001` is closed.  Next route planning should decide whether to refactor the expanded arithmetic contract to consume `expandedArithmeticComputesCubicAmplitudeTransparent`, or introduce a named nontrivial bridge from the transparent predicate to the opaque route predicate. |
| lower 2 Lean worker | Do not reassign `expandedArithmeticComputesCubicAmplitudeTransparent`, `fixedDenomCubicArithmeticRouteTransparent`, `fixedDenomCubicArithmeticBackend`, `fixedDenomCubicArithmeticBackend_computes`, or `fixedDenomCubicArithmeticBackend_bridge_iff`.  Do not attack the opaque route predicate until upper/middle chooses a bridge or refactor target. |
| lower 3 verifier/export worker | If lower 2 changes the fixed-denominator representation, check only task-local arithmetic/register diagnostics: capacity, exact payload `j^3 / 2^(3*n)`, system-index preservation, range, and normalizer.  If the representation is unchanged, record `finite_arithmetic_ok=true` from the existing fixed-denominator diagnostics and keep `block_entry_ok`, `unitarity_ok`, `ancilla_cleanup_ok`, and export fields `null` until a concrete clean-block matrix or named Lean certificate exists.  Do not create Qiskit, QuantumKatas-style, or QASM3 exports in this cycle. |

Required gate for any edit is `python3 tools/qbe.py check`.

Typed feedback for the next implementation attempt should use:

```text
leaf=DIAG-ARITH-ROUTE-TRANSPARENT-001
blocked_parent=DIAG-ARITH-BACKEND-BRIDGE-001
source_correspondence_ok=true
workspace_representation_specified=true
capacity_lemma_compiled=true
amplitude_lemma_compiled=true
backend_compute_compiled=true
finite_arithmetic_ok=true
finite_register_ok=true
normalizer_ok=true
block_entry_ok=null
unitarity_ok=null
ancilla_cleanup_ok=null
closed_theorem_ok=true
error_class=symbolic_bridge_gap
transparent_leaf_closed=true
next_route=choose a named bridge from the transparent predicate to the opaque route predicate, or refactor the expanded arithmetic contract to use the transparent predicate
```

## Export Bridge Status

Requested executable exports are `qiskit`, `quantum-katas`, and `qasm3`.
They remain downstream obligations.  The export packet must wait until a Lean
certificate is named for `DIAG-ROOT-001`; finite diagonal checks may be used as
necessary-condition diagnostics but not as proof closure.

## Middle Source-Correspondence Refresh, 2026-06-20 09:41 JST

The source anchor remains the user prompt copied in
`tasks/QBE-OP-CUBIC-DIAGONAL-001.md`.  The paper object for this operator task
is the diagonal matrix
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise.  The
normalizer is still `exactNormalizer n = 1`.  There is no paper source,
figure, or cited theorem for the next lower packet.

The arithmetic side of the expanded route is no longer an active lower target.
The declarations
`expandedArithmeticComputesCubicAmplitudeTransparent`,
`fixedDenomCubicArithmeticRouteTransparent`, and the refactored
`expandedAmplitudeOracleCleanBlockContract` compile.  For
`workspaceQubits = 3 * n`, the arithmetic conjunct is supplied by
`fixedDenomCubicArithmeticRouteTransparent n`.  This does not prove the old
opaque predicate `expandedArithmeticComputesCubicAmplitude`, and direct bridge
search through `fixedDenomCubicArithmeticBackend_bridge_iff` remains stale.

The next source-correspondence leaf is `DIAG-RY-BACKEND-WITNESS-001`.  The
Lean declarations already available for this leaf are:

```lean
StandardRyCleanEntryScalarTier
expandedRyCleanEntryForCubicAmplitudes
expandedRyCleanEntryForCubicAmplitudes_of_standardTier
expandedControlledRyUsesCubicAngle
expandedControlledRyBackendBridge
expandedControlledRyUsesCubicAngle_of_backendBridge
expandedControlledRyBackendBridge_iff_of_standardTier
```

The scalar-tier theorem has already specialized the standard `R_y(theta)`
half-angle convention to every cubic grid amplitude.  The missing step is not
the scalar identity.  The missing step is a backend-semantics witness that the
controlled signal rotation used by the expanded route is interpreted by that
same scalar-tier convention.

No external cited-result row is active.  The rotation backend witness is
QBE-local semantic glue.  The active user target owns only the diagonal
operator, the normalizer, and the requested export languages.  Primitive oracle
semantics remain an external primitive contract unless explicitly accepted.
Expanded arithmetic, rotation backend semantics, clean uncompute, extraction,
unitarity, and executable export planning are QBE-local obligations.

Proof-DAG frontier update:

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001` | Refactor the expanded clean-block contract to consume the transparent arithmetic predicate. | `DIAG-ARITH-ROUTE-TRANSPARENT-001` | lower Lean worker | `expandedAmplitudeOracleCleanBlockContract` uses `expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits` | proof-obligation ledger | `python3 tools/qbe.py check` passed 2026-06-20 09:17 JST | proved; retired |
| `DIAG-ARITH-BACKEND-BRIDGE-001` | Direct bridge to the old opaque arithmetic predicate. | fixed-denominator backend compute proof, route-semantics bridge | future upper/middle only if the transparent contract refactor is rejected | possible witness of `expandedArithmeticBackendBridge (fixedDenomCubicArithmeticBackend n)` | proof-obligation ledger | `python3 tools/qbe.py check` | parked alternative; direct search is stale |
| `DIAG-RY-BACKEND-WITNESS-001` | Supply a backend witness that the expanded route's controlled rotation uses the compiled standard `R_y` clean-entry convention. | `DIAG-EXP-RY-001`, `expandedRyCleanEntryForCubicAmplitudes_of_standardTier` | lower refiner; next lower natural-language architect for actual backend semantics | witness of `expandedControlledRyBackendBridge tier n (3 * n)`, or a blocked backend-semantics packet; normal form `expandedControlledRyBackendBridge_iff_of_standardTier` | this section; verifier feedback `DIAG-RY-BACKEND-WITNESS-001.middle-source-contract-20260620-0941.*`; proof-attempt `QBE-OP-CUBIC-DIAGONAL-001-DIAG-RY-BACKEND-WITNESS-001-lower-refiner-20260620-1004.md` | `python3 tools/qbe.py check` | active source-correspondence leaf; proof-reduction normal form compiled, but concrete backend witness remains blocked |
| `DIAG-EXP-UNCOMP-001` | Prove clean uncompute for the arithmetic workspace. | transparent arithmetic contract, rotation backend witness | future lower worker | `expandedWorkspaceCleanUncomputed` | proof-obligation ledger | `python3 tools/qbe.py check` | blocked until the rotation backend witness is classified |
| `DIAG-ROOT-001` | Exact block-encoding certificate for the diagonal operator. | arithmetic contract, rotation witness, clean uncompute, extraction, unitarity | future lower/reviewer | planned expanded certificate or conditional primitive certificate | proof-obligation ledger | `python3 tools/qbe.py check`; final `lake build && lake build Tests` | blocked |

Lower-facing source contract:

```text
leaf=DIAG-RY-BACKEND-WITNESS-001
source anchor=tasks/QBE-OP-CUBIC-DIAGONAL-001.md user-provided operator
source object=D_n[row,col] = if row = col then (row / 2^n)^3 else 0
normalizer=exactNormalizer n = 1
workspaceQubits=3 * n
system register=j : Fin (gridSize n), preserved by the rotation substep
signal register=one clean signal qubit
rotation convention=standard R_y(theta) clean entry cos(theta / 2)
angle token=theta_j = 2 * arccos(CubicStatePreparation.cubicAmplitude n j)
closed scalar dependency=expandedRyCleanEntryForCubicAmplitudes_of_standardTier
target Lean witness=hBridge :
  expandedControlledRyBackendBridge tier n (3 * n)
closure theorem=expandedControlledRyUsesCubicAngle_of_backendBridge
proof-reduction theorem=expandedControlledRyBackendBridge_iff_of_standardTier
dependency class=QBE-local rotation backend semantics
allowed lower-1 work=write the backend-witness proof map and classify whether
  the current Lean surface has enough transparent route semantics to state a
  non-opaque witness
allowed lower-2 work=only after lower-1 gives a concrete transparent
  backend-semantics interface; edit at most the declarations adjacent to
  expandedControlledRyBackendBridge and expandedControlledRyUsesCubicAngle in
  QuantumBlockEncoding/CubicStatePreparation.lean
allowed lower-3 work=rerun or summarize task-local rotation convention and
  register diagnostics; keep block_entry_ok, unitarity_ok,
  ancilla_cleanup_ok, root_certificate_ok, and export fields null unless a
  named Lean route certificate appears
forbidden edits=do not close expandedControlledRyUsesCubicAngle by trivial,
  by axiom, or by setting a semantic proposition to True; do not switch to
  rank-one state preparation; do not prepare executable exports
gate=python3 tools/qbe.py check
```

## Lower Update, 2026-06-20 13:07 JST

`DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001` is closed as a transparent
fixed-denominator cleanup witness.  The Lean declarations
`fixedDenomCubicComputeStep`, `fixedDenomCubicUncomputeStep`,
`fixedDenomCubicComputeStep_matches_backend_on_clean`,
`fixedDenomCubicUncomputeStep_after_compute`,
`fixedDenomExpandedArithmeticCleanUncomputeWitness`, and
`fixedDenomWorkspaceCleanUncomputedTransparent` now compile.

The compute step is modular addition by `j.val ^ 3` on
`Fin (gridSize (3 * n))`; the uncompute step is modular subtraction by the
same payload.  The witness agrees with `fixedDenomCubicArithmeticBackend` on
clean workspace and proves the add/sub cleanup equation for every workspace
value.

This does not prove the opaque predicate
`expandedWorkspaceCleanUncomputed`, does not state controlled-rotation
workspace-readonly semantics, does not refactor
`expandedAmplitudeOracleCleanBlockContract`, and does not close extraction,
unitarity, `DIAG-ROOT-001`, or executable exports.

Next route:

```text
leaf=DIAG-RY-WORKSPACE-READONLY-001
blocked_parent=DIAG-EXP-UNCOMP-001
available_cleanup_witness=fixedDenomWorkspaceCleanUncomputedTransparent n
missing Lean statement=controlled rotation reads payload without modifying
  system index or arithmetic workspace
forbidden downstream shortcut=do not use the transparent cleanup witness as a
  route-level cleanup certificate until the workspace-readonly semantics or an
  explicit contract refactor is recorded
gate=python3 tools/qbe.py check
```

The full gate passed at 2026-06-20 13:07 JST.

## Middle Clean-Uncompute Interface Packet, 2026-06-20 11:58 JST

Source anchors and object:

- The source anchor remains the user prompt copied in
  `tasks/QBE-OP-CUBIC-DIAGONAL-001.md`.
- The translated object remains the diagonal operator
  $D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise.
- The normalizer remains `exactNormalizer n = 1`.
- No paper source, figure, visual audit, or cited theorem is active.

Lean declarations and theorem statements:

- The expanded clean-block contract already consumes
  `expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits` and
  `expandedControlledRyUsesCubicAngleTransparent n workspaceQubits`.
- For `workspaceQubits = 3 * n`, the closed witnesses are
  `fixedDenomCubicArithmeticRouteTransparent n` and
  `fixedDenomControlledRyRouteTransparent n`.
- The current clean-uncompute target is still the opaque obligation
  `expandedWorkspaceCleanUncomputed n workspaceQubits`.
- `fixedDenomCubicArithmeticBackend n` proves clean-input compute behavior, but
  it does not record an inverse arithmetic operation or a register-preservation
  theorem for the controlled rotation.

Verifier-feedback alignment:

- The lower finite diagnostic
  `DIAG-EXP-UNCOMP-001.lower-necessary-20260620-113316.*` checked an xor
  cleanup skeleton.  It supports only the generic claim that a
  fixed-denominator payload can be restored cleanly in finite samples.
- The lower architect packet proposes a modular add/sub cleanup lift.  That
  exact interface still needs either its own Lean proof or a matching finite
  diagnostic; the xor diagnostic must not be cited as evidence for modular
  add/sub semantics.

External and local glue:

- No cited-result row is needed.  Clean uncompute is QBE-local workspace
  semantic glue for the user/operator construction.
- The active user target owns the diagonal matrix, `alpha = 1`, and requested
  export languages.  QBE owns the transparent cleanup interface, any fixed
  reversible-arithmetic lift, rotation workspace-readonly semantics,
  extraction, unitarity, root certification, and post-Lean exports.

Proof-DAG frontier update:

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-EXP-UNCOMP-001` | Route-level clean uncompute after arithmetic compute and controlled rotation. | transparent arithmetic and rotation contracts; fixed-denominator representation; rotation workspace-readonly semantics | middle/source-correspondence; future lower after transparent witness | opaque target `expandedWorkspaceCleanUncomputed` | this section; proof-obligation ledger | `python3 tools/qbe.py check` | blocked parent; do not attack the opaque predicate directly |
| `DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001` | Introduce a transparent cleanup witness interface tied to an existing arithmetic backend, without proving the opaque route predicate. | `fixedDenomCubicArithmeticBackend`, `fixedDenomCubicArithmeticBackend_computes`, lower clean-uncompute packets | lower Lean worker | `ExpandedArithmeticCleanUncomputeWitness`, `expandedWorkspaceCleanUncomputedTransparent`, `expandedWorkspaceCleanUncomputedTransparent_of_witness` | verifier feedback `DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001.lower-worker5-20260620-1221.feedback.json` | `python3 tools/qbe.py check` passed 2026-06-20 12:21 JST | proved; not a route certificate |
| `DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001` | Instantiate the transparent interface with fixed-denominator modular add/sub cleanup. | transparent cleanup interface; `fixedDenomCubicPayload_lt_capacity`; `fixedDenomCubicAmplitude_eq`; modular arithmetic facts | next lower Lean worker | planned witness theorem for `expandedWorkspaceCleanUncomputedTransparent n (3 * n)` | verifier feedback `DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001.middle-source-contract-20260620-1244.md` | `python3 tools/qbe.py check` | active lower-facing leaf; matching finite modular add/sub diagnostic exists but no Lean witness yet |
| `DIAG-RY-WORKSPACE-READONLY-001` | State that controlled `R_y` reads the payload and does not modify the arithmetic workspace. | rotation route semantics | future middle/lower interface | no current declaration | lower clean-uncompute packets | `python3 tools/qbe.py check` | blocked internal dependency before route-level cleanup can close |
| `DIAG-EXP-BLOCK-001` | Prove extracted clean block satisfies `diagonalCleanBlockContract n block`. | clean uncompute, extraction semantics | future lower worker | `expandedAmplitudeOracleCleanBlockExtracts`; diagonal conjunct in `expandedAmplitudeOracleCleanBlockContract` | proof-obligation ledger | `python3 tools/qbe.py check` | blocked |
| `DIAG-ROOT-001` | Exact block-encoding certificate for the diagonal operator. | cleanup, extraction, unitarity/circuit semantics | future lower/reviewer | planned expanded certificate or conditional primitive certificate | candidate population | `python3 tools/qbe.py check`; final `lake build && lake build Tests` | blocked |

Lower-facing source contract:

```text
leaf=DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001
source anchor=tasks/QBE-OP-CUBIC-DIAGONAL-001.md user-provided diagonal operator
source object=D_n[row,col] = if row = col then (row / 2^n)^3 else 0
normalizer=exactNormalizer n = 1
target file=QuantumBlockEncoding/CubicStatePreparation.lean
allowed write scope=declarations adjacent to
  ExpandedArithmeticCleanUncomputeWitness and
  expandedWorkspaceCleanUncomputedTransparent
expected Lean target=instantiate
  ExpandedArithmeticCleanUncomputeWitness n (3 * n) for the
  fixed-denominator backend and derive
  expandedWorkspaceCleanUncomputedTransparent n (3 * n)
intended compute step=(j,w) -> (j, (w + j.val ^ 3) mod gridSize (3 * n))
intended uncompute step=(j,w) ->
  (j, (w + gridSize (3 * n) - j.val ^ 3) mod gridSize (3 * n))
closed dependencies=ExpandedArithmeticCleanUncomputeWitness,
  expandedWorkspaceCleanUncomputedTransparent,
  fixedDenomCubicArithmeticBackend,
  fixedDenomCubicArithmeticBackend_computes,
  fixedDenomCubicPayload_lt_capacity
separate dependency=DIAG-RY-WORKSPACE-READONLY-001 must state rotation
  workspace-readonly semantics before any route-level cleanup bridge or
  clean-block extraction proof depends on cleanup
forbidden edits=do not prove expandedWorkspaceCleanUncomputed by trivial,
  do not add an axiom, do not set semantic propositions to True, do not refactor
  expandedAmplitudeOracleCleanBlockContract in this leaf, do not switch to
  rank-one state preparation, and do not prepare executable exports
gate=python3 tools/qbe.py check
```

## Middle Rotation Workspace-Readonly Packet, 2026-06-20 15:40 JST

Source anchors and object:

- The source anchor remains the user prompt copied in
  `tasks/QBE-OP-CUBIC-DIAGONAL-001.md`.
- The translated object remains the diagonal operator
  $D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise.
- The normalizer remains `exactNormalizer n = 1`.
- No paper source, figure, visual audit, cited theorem, or external
  construction hint is active.

Lean declarations and theorem statements:

- The fixed-denominator cleanup witness is closed as
  `fixedDenomExpandedArithmeticCleanUncomputeWitness` and
  `fixedDenomWorkspaceCleanUncomputedTransparent`.
- This cleanup witness proves only the arithmetic add/sub part.  It does not
  prove that the controlled-`R_y` substep leaves the workspace and system index
  unchanged.
- The active leaf is `DIAG-RY-WORKSPACE-READONLY-001`.  The intended Lean
  interface should name a transparent readonly-rotation witness, for example a
  structure `ExpandedControlledRyWorkspaceReadonlyWitness n workspaceQubits`
  with a backend, the existing transparent angle convention, a `rotationStep`
  on system/workspace/signal registers, and fields proving that the step
  preserves the system index and workspace.  A wrapper predicate such as
  `expandedControlledRyWorkspaceReadonlyTransparent n workspaceQubits` should
  record the witness without proving the opaque cleanup predicate.

External and local glue:

- No cited-result row is active.  The readonly rotation statement is QBE-local
  route/register semantic glue for the user operator target.
- The user target owns only the diagonal matrix, normalizer, and requested
  executable languages.  QBE owns the readonly-rotation interface, route-level
  cleanup bridge or refactor, extraction, unitarity, root certificate, and
  post-Lean exports.

Proof-DAG frontier update:

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001` | Fixed-denominator modular add/sub cleanup witness. | transparent cleanup interface, fixed-denominator backend, payload capacity | lower Lean worker | `fixedDenomExpandedArithmeticCleanUncomputeWitness`, `fixedDenomWorkspaceCleanUncomputedTransparent` | verifier feedback `DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001.lower-worker5-20260620-1307.feedback.json` | `python3 tools/qbe.py check` passed 2026-06-20 13:07 JST | proved transparent witness; retired |
| `DIAG-RY-WORKSPACE-READONLY-001` | State that the controlled signal rotation reads the payload and preserves the system index and arithmetic workspace. | transparent rotation bookkeeping, fixed-denominator cleanup witness | next lower Lean worker | planned `ExpandedControlledRyWorkspaceReadonlyWitness`; planned `expandedControlledRyWorkspaceReadonlyTransparent` | this section; verifier feedback `DIAG-RY-WORKSPACE-READONLY-001.middle-source-contract-20260620-1540.md` | `python3 tools/qbe.py check` | active leaf |
| `DIAG-EXP-UNCOMP-001` | Route-level clean uncompute for the expanded contract. | fixed-denominator cleanup witness plus readonly rotation interface | future lower worker after the active leaf | opaque target `expandedWorkspaceCleanUncomputed`, or later transparent cleanup contract boundary | proof-obligation ledger | `python3 tools/qbe.py check` | blocked parent |
| `DIAG-EXP-BLOCK-001` | Prove the extracted clean block satisfies `diagonalCleanBlockContract n block`. | route-level cleanup and extraction semantics | future lower worker | `expandedAmplitudeOracleCleanBlockExtracts` plus `diagonalCleanBlockContract` in the clean-block contract | proof-obligation ledger | `python3 tools/qbe.py check` | blocked |
| `DIAG-ROOT-001` | Exact block-encoding certificate for the diagonal operator. | cleanup, extraction, unitarity/circuit semantics | future lower/reviewer | planned expanded certificate or conditional primitive certificate | proof-obligation ledger | `python3 tools/qbe.py check`; final `lake build && lake build Tests` | blocked |

Lower-facing source contract:

```text
leaf=DIAG-RY-WORKSPACE-READONLY-001
source anchor=tasks/QBE-OP-CUBIC-DIAGONAL-001.md user-provided diagonal operator
source object=D_n[row,col] = if row = col then (row / 2^n)^3 else 0
normalizer=exactNormalizer n = 1
target file=QuantumBlockEncoding/CubicStatePreparation.lean
allowed write scope=declarations adjacent to expandedControlledRyUsesCubicAngleTransparent,
  expandedControlledRyBackendBridge, and expandedWorkspaceCleanUncomputed
expected interface=state a transparent controlled-rotation workspace-readonly
  witness, with fields for an arithmetic backend, the transparent angle
  convention, a rotation step on system/workspace/signal registers, and proofs
  that the step preserves system index and arithmetic workspace
closed dependencies=fixedDenomControlledRyRouteTransparent,
  fixedDenomExpandedArithmeticCleanUncomputeWitness,
  fixedDenomWorkspaceCleanUncomputedTransparent
blocked parent=DIAG-EXP-UNCOMP-001
forbidden edits=do not prove expandedWorkspaceCleanUncomputed by trivial,
  do not add an axiom, do not set semantic propositions to True, do not refactor
  expandedAmplitudeOracleCleanBlockContract, do not switch to rank-one state
  preparation, and do not prepare executable exports
gate=python3 tools/qbe.py check
```

## Current Lower Packet Override, 2026-06-20 09:41 JST

The active lower-facing source contract is `DIAG-RY-BACKEND-WITNESS-001`.
The immediately preceding `DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001` packet is
closed historical memory and must not be reassigned.

## Current Middle Packet, 2026-06-20 09:41 JST

The current packet is `DIAG-RY-BACKEND-WITNESS-001`, recorded in the 09:41
source-correspondence refresh above.  The 08:57 arithmetic contract-refactor
packet is historical and closed.  Do not assign lower work to rebuild
`expandedArithmeticComputesCubicAmplitudeTransparent`,
`fixedDenomCubicArithmeticRouteTransparent`, or
`expandedAmplitudeOracleCleanBlockContract`; assign the next source-facing work
only to the controlled-`R_y` backend witness classification.

## Middle Source-Correspondence Refresh, 2026-06-20 08:57 JST

The source anchor remains the user prompt copied in
`tasks/QBE-OP-CUBIC-DIAGONAL-001.md`.  The translated object is the diagonal
operator
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise, with
`exactNormalizer n = 1`.  There is no paper source, figure, or cited theorem
for this cycle.

The fixed-denominator arithmetic route is synchronized with Lean as follows.
The representation uses `workspaceQubits = 3 * n`, workspace basis
`Fin (gridSize (3 * n))`, clean workspace `0`, payload `j.val ^ 3`, and
amplitude projection
`(payload.val : Rat) / (gridSize (3 * n) : Rat)`.  The compiled declarations
are `fixedDenomCubicPayload_lt_capacity`, `fixedDenomCubicAmplitude_eq`,
`fixedDenomCubicArithmeticBackend`,
`fixedDenomCubicArithmeticBackend_computes`,
`expandedArithmeticComputesCubicAmplitudeTransparent`, and
`fixedDenomCubicArithmeticRouteTransparent`.

Middle chooses the transparent-contract refactor route for the next Lean
packet.  A theorem from
`expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits` to the
opaque predicate `expandedArithmeticComputesCubicAmplitude n workspaceQubits`
would add no source-backed mathematical content unless a separate route
semantics bridge were introduced.  The next lower target should therefore reuse
the existing declaration `expandedAmplitudeOracleCleanBlockContract` and change
its arithmetic conjunct to consume
`expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits`
directly.  This keeps the fixed-denominator witness usable without proving the
opaque proposition by `trivial`, by an axiom, or by setting a semantic
proposition to `True`.

Proof-DAG frontier update:

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-ARITH-ROUTE-TRANSPARENT-001` | Package the fixed-denominator backend compute proof as a transparent existential arithmetic witness. | `DIAG-ARITH-FIXED-DENOM-BACKEND-001` | lower Lean worker | `expandedArithmeticComputesCubicAmplitudeTransparent`, `fixedDenomCubicArithmeticRouteTransparent` | this section; verifier feedback `DIAG-ARITH-ROUTE-TRANSPARENT-001.lower-implementation-20260620-0833.feedback.json` | `python3 tools/qbe.py check` passed 2026-06-20 08:33 JST | proved; not a route certificate |
| `DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001` | Refactor the expanded clean-block contract so its arithmetic conjunct uses the transparent predicate instead of the opaque route predicate. | `DIAG-ARITH-ROUTE-TRANSPARENT-001`, existing `expandedAmplitudeOracleCleanBlockContract` shape | lower Lean worker | `expandedAmplitudeOracleCleanBlockContract` now uses `expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits` | lower-facing source contract below | `python3 tools/qbe.py check` passed 2026-06-20 09:17 JST | proved; does not close rotation, uncompute, extraction, unitarity, root, or exports |
| `DIAG-ARITH-BACKEND-BRIDGE-001` | Supply a nontrivial bridge to the old opaque route predicate, only if upper later rejects the contract refactor. | `DIAG-ARITH-ROUTE-TRANSPARENT-001`, source-backed route-semantics bridge | future upper/middle decision | possible witness of `expandedArithmeticBackendBridge (fixedDenomCubicArithmeticBackend n)` | proof-obligation ledger | `python3 tools/qbe.py check` | parked alternative; direct bridge search is stale |
| `DIAG-RY-BACKEND-WITNESS-001` | Supply a concrete backend witness for the compiled standard `R_y` clean-entry convention. | `DIAG-EXP-RY-001` | future lower worker | witness of `expandedControlledRyBackendBridge tier n workspaceQubits` | proof-obligation ledger | `python3 tools/qbe.py check` | blocked |
| `DIAG-EXP-UNCOMP-001` | Prove clean uncompute for the arithmetic workspace. | arithmetic contract refactor, rotation backend witness | future lower worker | `expandedWorkspaceCleanUncomputed` | proof-obligation ledger | `python3 tools/qbe.py check` | blocked |
| `DIAG-ROOT-001` | Exact block-encoding certificate for the diagonal operator. | arithmetic contract, rotation witness, clean uncompute, extraction, unitarity | future lower/reviewer | planned expanded certificate or conditional primitive certificate | proof-obligation ledger | `python3 tools/qbe.py check`; final `lake build && lake build Tests` | blocked |

Lower-facing source contract:

```text
leaf=DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001
source anchor=tasks/QBE-OP-CUBIC-DIAGONAL-001.md user-provided operator
source object=D_n[row,col] = if row = col then (row / 2^n)^3 else 0
normalizer=exactNormalizer n = 1
target file=QuantumBlockEncoding/CubicStatePreparation.lean
allowed write scope=the definition and docstring of
  expandedAmplitudeOracleCleanBlockContract, plus directly adjacent comments
  if needed for build-readable wording
exact Lean-facing edit=replace the first conjunct
  expandedArithmeticComputesCubicAmplitude n workspaceQubits
with
  expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits
dependencies already compiled=expandedArithmeticComputesCubicAmplitudeTransparent,
  fixedDenomCubicArithmeticRouteTransparent,
  fixedDenomCubicArithmeticBackend,
  fixedDenomCubicArithmeticBackend_computes
expected post-edit status=for workspaceQubits = 3 * n, the arithmetic conjunct
  can be supplied by fixedDenomCubicArithmeticRouteTransparent n; rotation
  backend witness, clean uncompute, clean-block extraction, unitarity, root
  certificate, and exports remain blocked
forbidden edits=do not prove the opaque predicate by trivial, do not add an
  axiom, do not set semantic propositions to True, do not create a duplicate
  target operator, do not switch to rank-one state preparation, and do not
  prepare executable exports
gate=python3 tools/qbe.py check
```

## Current Lower Packet Override, 2026-06-20 09:41 JST

The active lower-facing source contract is `DIAG-RY-BACKEND-WITNESS-001`.
The `DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001` packet immediately above is
closed historical memory and must not be reassigned.

## Middle Source-Correspondence Refresh, 2026-06-20 10:26 JST

Source anchors and object:

- The source anchor remains the user prompt copied in
  `tasks/QBE-OP-CUBIC-DIAGONAL-001.md`.
- The paper/user object is the diagonal matrix
  $D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise.
- The normalizer remains `exactNormalizer n = 1`.
- No paper source archive, figure, or cited theorem is active.

Lean declarations and theorem statements:

- The scalar `R_y` range specialization is already compiled as
  `expandedRyCleanEntryForCubicAmplitudes_of_standardTier`.
- The conditional bridge is already compiled as
  `expandedControlledRyUsesCubicAngle_of_backendBridge`.
- The bridge normal form
  `expandedControlledRyBackendBridge_iff_of_standardTier` is compiled and
  shows that direct proof of
  `expandedControlledRyBackendBridge tier n workspaceQubits` is equivalent to
  the opaque route predicate `expandedControlledRyUsesCubicAngle n
  workspaceQubits`.
- The next Lean declaration target is a transparent rotation-angle predicate,
  not a proof of the opaque route predicate.

External and local glue:

- No cited-result row is needed.  The missing object is QBE-local rotation
  semantic glue for a user/operator construction.
- The transparent predicate records only the scalar angle convention already
  supported by the compiled standard-tier theorem.  It is not a unitary
  statement and not a clean-block extraction statement.

Ownership:

- The active user target owns the diagonal operator, `alpha = 1`, and the
  requested export languages.
- Primitive oracle semantics remain an external primitive contract unless
  explicitly accepted.
- QBE owns the transparent rotation interface, any later rotation contract
  refactor or backend bridge, clean uncompute, extraction, unitarity, root
  certificate, and post-Lean executable exports.

Proof-DAG frontier update:

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-RY-BACKEND-WITNESS-001` | Supply a concrete backend witness for the compiled standard `R_y` clean-entry convention. | `DIAG-EXP-RY-001`, backend rotation semantics | future lower only after a concrete backend semantics object exists | witness of `expandedControlledRyBackendBridge tier n (3 * n)`; normal form `expandedControlledRyBackendBridge_iff_of_standardTier` | verifier feedback `DIAG-RY-BACKEND-WITNESS-001.lower-worker5-20260620-1003.md` and lower architect packet `proof-attempts/QBE-OP-CUBIC-DIAGONAL-001-DIAG-RY-BACKEND-WITNESS-001-lower-architect-20260620-1005.md` | `python3 tools/qbe.py check` | blocked; direct witness search is stale symbolic-bridge work |
| `DIAG-RY-TRANSPARENT-INTERFACE-001` | Add a transparent rotation-angle predicate and fixed-denominator witness wrapper, without closing the opaque route predicate. | `DIAG-RY-SCALAR-001`, `expandedRyCleanEntryForCubicAmplitudes_of_standardTier` | lower Lean worker | `expandedControlledRyUsesCubicAngleTransparent`, `fixedDenomControlledRyRouteTransparent` | this section; verifier feedback `DIAG-RY-TRANSPARENT-INTERFACE-001.middle-source-contract-20260620-1026.*` | `python3 tools/qbe.py check` passed 2026-06-20 10:43 JST | proved transparent witness only |
| `DIAG-RY-TRANSPARENT-CONTRACT-001` | If middle later accepts the analogous refactor, change the expanded clean-block contract to consume the transparent rotation predicate. | `DIAG-RY-TRANSPARENT-INTERFACE-001` | future middle/lower packet only | possible future edit to `expandedAmplitudeOracleCleanBlockContract` | proof-obligation ledger | `python3 tools/qbe.py check` | next middle decision; not assigned in this packet |
| `DIAG-EXP-UNCOMP-001` | Prove clean uncompute for the arithmetic workspace. | transparent arithmetic contract plus accepted rotation route predicate | future lower worker | `expandedWorkspaceCleanUncomputed` | proof-obligation ledger | `python3 tools/qbe.py check` | blocked |
| `DIAG-ROOT-001` | Exact block-encoding certificate for the diagonal operator. | arithmetic, rotation, uncompute, extraction, unitarity | future lower/reviewer | planned expanded certificate or conditional primitive certificate | proof-obligation ledger | `python3 tools/qbe.py check`; final `lake build && lake build Tests` | blocked |

Lower-facing source contract:

```text
leaf=DIAG-RY-TRANSPARENT-INTERFACE-001
source anchor=tasks/QBE-OP-CUBIC-DIAGONAL-001.md user-provided operator
source object=D_n[row,col] = if row = col then (row / 2^n)^3 else 0
normalizer=exactNormalizer n = 1
target file=QuantumBlockEncoding/CubicStatePreparation.lean
allowed write scope=declarations and comments directly adjacent to
  expandedControlledRyUsesCubicAngle and expandedControlledRyBackendBridge
exact Lean-facing declarations=
  def expandedControlledRyUsesCubicAngleTransparent
      (n workspaceQubits : Nat) : Prop :=
    forall tier : StandardRyCleanEntryScalarTier,
      expandedRyCleanEntryForCubicAmplitudes tier n
  theorem fixedDenomControlledRyRouteTransparent
      (n : Nat) :
      expandedControlledRyUsesCubicAngleTransparent n (3 * n)
proof dependency=expandedRyCleanEntryForCubicAmplitudes_of_standardTier
expected proof shape=intro tier; exact
  expandedRyCleanEntryForCubicAmplitudes_of_standardTier tier n
expected post-edit status=transparent scalar-angle witness compiled only;
  expandedControlledRyUsesCubicAngle remains unproved and downstream route
  obligations remain blocked
forbidden edits=do not prove expandedControlledRyUsesCubicAngle by trivial,
  do not add an axiom, do not set semantic propositions to True, do not
  refactor expandedAmplitudeOracleCleanBlockContract in the same lower leaf,
  do not switch to rank-one state preparation, and do not prepare executable
  exports
gate=python3 tools/qbe.py check
```

## Current Lower Packet Override, 2026-06-20 10:26 JST

The active lower-facing source contract is
`DIAG-RY-TRANSPARENT-INTERFACE-001`.  The direct
`DIAG-RY-BACKEND-WITNESS-001` proof route is blocked by the compiled normal
form and should not be reassigned as tactic search against the opaque predicate.

## Middle Source-Correspondence Refresh, 2026-06-20 11:04 JST

Source anchors and object:

- The source anchor remains the user prompt copied in
  `tasks/QBE-OP-CUBIC-DIAGONAL-001.md`.
- The translated object remains the diagonal operator
  $D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise.
- The normalizer remains `exactNormalizer n = 1`.
- No paper source, figure, visual audit, or cited theorem is active.

Lean declarations and theorem statements:

- `expandedControlledRyUsesCubicAngleTransparent` and
  `fixedDenomControlledRyRouteTransparent` now compile.
- `fixedDenomControlledRyRouteTransparent n` supplies the transparent
  rotation-angle witness for `workspaceQubits = 3 * n`.
- `expandedControlledRyUsesCubicAngle` remains opaque and unproved.
- `expandedAmplitudeOracleCleanBlockContract` still consumes
  `expandedControlledRyUsesCubicAngle n workspaceQubits`, so the transparent
  witness is not yet part of the expanded clean-block contract.

Middle chooses the transparent rotation contract-refactor route.  A theorem
from
`expandedControlledRyUsesCubicAngleTransparent n workspaceQubits` to the opaque
predicate `expandedControlledRyUsesCubicAngle n workspaceQubits` would add no
source-backed route semantics unless a separate backend semantics bridge were
introduced.  The next lower Lean leaf should therefore reuse the existing
declaration `expandedAmplitudeOracleCleanBlockContract` and change only its
rotation conjunct to consume
`expandedControlledRyUsesCubicAngleTransparent n workspaceQubits`.

Proof-DAG frontier update:

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-RY-TRANSPARENT-INTERFACE-001` | Package the compiled scalar `R_y` clean-entry theorem as a transparent rotation-angle witness. | `expandedRyCleanEntryForCubicAmplitudes_of_standardTier` | lower Lean worker | `expandedControlledRyUsesCubicAngleTransparent`, `fixedDenomControlledRyRouteTransparent` | verifier feedback `DIAG-RY-TRANSPARENT-INTERFACE-001.lower-necessary-20260620-104234.md` | `python3 tools/qbe.py check` passed 2026-06-20 10:43 JST | proved; not a route certificate |
| `DIAG-RY-TRANSPARENT-CONTRACT-001` | Refactor the expanded clean-block contract so its rotation conjunct uses the transparent predicate instead of the opaque route predicate. | `DIAG-RY-TRANSPARENT-INTERFACE-001`, existing `expandedAmplitudeOracleCleanBlockContract` shape | lower Lean worker | edit `expandedAmplitudeOracleCleanBlockContract` | this section; verifier feedback `DIAG-RY-TRANSPARENT-CONTRACT-001.middle-source-contract-20260620-1104.*` | `python3 tools/qbe.py check` | active leaf |
| `DIAG-RY-BACKEND-WITNESS-001` | Supply a nontrivial backend witness to the old opaque rotation route predicate, only if upper later rejects the transparent contract refactor. | `DIAG-RY-TRANSPARENT-INTERFACE-001`, source-backed backend semantics | future upper/middle decision | possible witness of `expandedControlledRyBackendBridge tier n (3 * n)` | proof-obligation ledger | `python3 tools/qbe.py check` | parked alternative; direct bridge search is stale |
| `DIAG-EXP-UNCOMP-001` | Prove clean uncompute for the arithmetic workspace. | transparent arithmetic contract plus transparent rotation contract | future lower worker | `expandedWorkspaceCleanUncomputed` | proof-obligation ledger | `python3 tools/qbe.py check` | blocked |
| `DIAG-ROOT-001` | Exact block-encoding certificate for the diagonal operator. | arithmetic, rotation, uncompute, extraction, unitarity | future lower/reviewer | planned expanded certificate or conditional primitive certificate | proof-obligation ledger | `python3 tools/qbe.py check`; final `lake build && lake build Tests` | blocked |

Lower-facing source contract:

```text
leaf=DIAG-RY-TRANSPARENT-CONTRACT-001
source anchor=tasks/QBE-OP-CUBIC-DIAGONAL-001.md user-provided operator
source object=D_n[row,col] = if row = col then (row / 2^n)^3 else 0
normalizer=exactNormalizer n = 1
target file=QuantumBlockEncoding/CubicStatePreparation.lean
allowed write scope=the definition and docstring of
  expandedAmplitudeOracleCleanBlockContract, plus directly adjacent comments
  if needed for build-readable wording
exact Lean-facing edit=replace the rotation conjunct
  expandedControlledRyUsesCubicAngle n workspaceQubits
with
  expandedControlledRyUsesCubicAngleTransparent n workspaceQubits
dependencies already compiled=expandedControlledRyUsesCubicAngleTransparent,
  fixedDenomControlledRyRouteTransparent,
  expandedRyCleanEntryForCubicAmplitudes_of_standardTier
expected post-edit status=for workspaceQubits = 3 * n, the rotation conjunct
  can be supplied by fixedDenomControlledRyRouteTransparent n; clean uncompute,
  clean-block extraction, unitarity, root certificate, and exports remain
  blocked
forbidden edits=do not prove the opaque predicate by trivial, do not add an
  axiom, do not set semantic propositions to True, do not create a duplicate
  target operator, do not switch to rank-one state preparation, and do not
  prepare executable exports
gate=python3 tools/qbe.py check
```

## Current Lower Packet Override, 2026-06-20 11:04 JST

The active lower-facing source contract is now
`DIAG-RY-TRANSPARENT-CONTRACT-001`.  The preceding
`DIAG-RY-TRANSPARENT-INTERFACE-001` leaf is closed historical memory.  Direct
proof search for `expandedControlledRyBackendBridge tier n (3 * n)` remains a
parked alternative because the compiled normal form reduces it to the opaque
rotation route predicate.

## Lean Implementation Update, 2026-06-20 11:22 JST

`DIAG-RY-TRANSPARENT-CONTRACT-001` is closed as a contract-boundary refactor.
The definition `expandedAmplitudeOracleCleanBlockContract` now uses the
transparent rotation predicate:

```lean
expandedControlledRyUsesCubicAngleTransparent n workspaceQubits
```

The arithmetic conjunct already used
`expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits`.  Thus,
for the fixed-denominator route with `workspaceQubits = 3 * n`, the arithmetic
and rotation bookkeeping conjuncts can be supplied by
`fixedDenomCubicArithmeticRouteTransparent n` and
`fixedDenomControlledRyRouteTransparent n`.

This refactor does not prove the opaque predicate
`expandedControlledRyUsesCubicAngle`, does not provide a backend witness for
`expandedControlledRyBackendBridge`, and does not prove clean uncompute,
clean-block extraction, unitarity, `DIAG-ROOT-001`, or any executable export.

Proof-DAG frontier update:

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-RY-TRANSPARENT-CONTRACT-001` | Refactor the expanded clean-block contract to consume the transparent controlled-`R_y` predicate. | `DIAG-RY-TRANSPARENT-INTERFACE-001`, existing clean-block contract shape | current Lean edit | `expandedAmplitudeOracleCleanBlockContract` uses `expandedControlledRyUsesCubicAngleTransparent n workspaceQubits` | this section | `python3 tools/qbe.py check` passed 2026-06-20 11:22 JST | proved; not a route certificate |
| `DIAG-RY-BACKEND-WITNESS-001` | Direct bridge to the old opaque controlled-rotation predicate. | scalar-tier theorem plus backend semantics | future upper/middle only if transparent refactor is rejected | possible witness of `expandedControlledRyBackendBridge tier n (3 * n)` | previous rotation witness sections | `python3 tools/qbe.py check` | parked alternative; direct search remains stale |
| `DIAG-EXP-UNCOMP-001` | State and prove clean uncompute for the arithmetic workspace after the controlled rotation. | transparent arithmetic contract, transparent rotation contract, fixed-denominator backend representation | next lower source-contract packet before Lean implementation | target `expandedWorkspaceCleanUncomputed`; possible future transparent uncompute interface if a concrete backend witness is not available | proof-obligation ledger | `python3 tools/qbe.py check` | active next source-correspondence leaf |
| `DIAG-EXP-BLOCK-001` | Prove the extracted clean block satisfies `diagonalCleanBlockContract n block`. | `DIAG-EXP-UNCOMP-001`, extraction semantics | future lower worker | `expandedAmplitudeOracleCleanBlockExtracts` plus `diagonalCleanBlockContract` in `expandedAmplitudeOracleCleanBlockContract` | proof-obligation ledger | `python3 tools/qbe.py check` | blocked |
| `DIAG-ROOT-001` | Exact block-encoding certificate for the diagonal operator. | clean uncompute, extraction, unitarity/circuit semantics | future lower/reviewer | planned expanded certificate or conditional primitive certificate | proof-obligation ledger | `python3 tools/qbe.py check`; final `lake build && lake build Tests` | blocked |

Next lower-facing packet:

```text
leaf=DIAG-EXP-UNCOMP-001
source anchor=tasks/QBE-OP-CUBIC-DIAGONAL-001.md user-provided diagonal operator
source object=D_n[row,col] = if row = col then (row / 2^n)^3 else 0
normalizer=exactNormalizer n = 1
closed dependencies=expandedArithmeticComputesCubicAmplitudeTransparent,
  fixedDenomCubicArithmeticRouteTransparent,
  expandedControlledRyUsesCubicAngleTransparent,
  fixedDenomControlledRyRouteTransparent,
  expandedAmplitudeOracleCleanBlockContract refactor
target Lean obligation=expandedWorkspaceCleanUncomputedTransparent n (3 * n)
allowed lower-1 work=refine only the dependency map from the fixed-denominator
  witness to the separate rotation workspace-readonly statement if needed
allowed lower-2 work=instantiate ExpandedArithmeticCleanUncomputeWitness for
  the fixed-denominator modular add/sub route; do not prove the opaque
  clean-uncompute predicate by trivial, by axiom, or by setting it to True
blocked downstream=clean-block extraction, unitarity/circuit semantics,
  DIAG-ROOT-001, and qiskit/quantum-katas/qasm3 exports
gate=python3 tools/qbe.py check
```

## Current Lower Packet Override, 2026-06-20 11:58 JST

The active lower-facing source contract is now
`DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001`, recorded in the middle packet
above and in
`verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-EXP-UNCOMP-001.middle-source-contract-20260620-1158.md`.

`DIAG-EXP-UNCOMP-001` remains an opaque blocked parent.  The next Lean edit may
only introduce the transparent cleanup witness interface adjacent to
`expandedWorkspaceCleanUncomputed`.  The fixed-denominator modular add/sub
witness is a later subleaf after that interface compiles.  The xor finite
diagnostic must not be reused as evidence for the modular add/sub witness
without a matching diagnostic or Lean proof.

Clean-block extraction, unitarity/circuit semantics, `DIAG-ROOT-001`, and all
Qiskit, QuantumKatas-style, and QASM3 exports remain blocked.

## Middle Coordinator Synthesis, 2026-06-20 12:16 JST

The middle specialist handoffs are now synchronized.  Source correspondence
still points only to the user-provided diagonal operator
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise, with
`exactNormalizer n = 1`.  No paper source, cited theorem, or external
construction hint is active.

Current Lean status:

- The target, normalizer, fixed-denominator arithmetic transparent witness, and
  transparent controlled-`R_y` bookkeeping compile.
- `expandedAmplitudeOracleCleanBlockContract` consumes
  `expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits` and
  `expandedControlledRyUsesCubicAngleTransparent n workspaceQubits`.
- The cleanup parent `expandedWorkspaceCleanUncomputed n workspaceQubits` is
  still opaque and must not be attacked directly.
- The active lower-facing leaf is
  `DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001`.

Lower-agent packet:

| Lower role | Packet |
|---|---|
| lower 1 natural-language architect | Keep `DIAG-EXP-UNCOMP-001` as a blocked parent.  If more prose is needed, refine only the dependency map from the transparent cleanup interface to the later fixed-denominator modular add/sub witness and the separate `DIAG-RY-WORKSPACE-READONLY-001` dependency.  Do not rewrite the target, arithmetic representation, or root theorem. |
| lower 2 Lean worker | Edit only declarations adjacent to `expandedWorkspaceCleanUncomputed` in `QuantumBlockEncoding/CubicStatePreparation.lean`.  Compile `structure ExpandedArithmeticCleanUncomputeWitness` and `def expandedWorkspaceCleanUncomputedTransparent`.  Do not instantiate the fixed-denominator modular add/sub witness in this leaf, do not prove the opaque cleanup predicate, and do not refactor the clean-block contract. |
| lower 3 necessary-condition verifier | Add or prepare a matching diagnostic for the later modular add/sub witness and record `finite_mod_add_sub_cleanup_ok` plus `rotation_workspace_readonly_ok`.  The xor cleanup diagnostic remains generic support only; keep `block_entry_ok`, `clean_block_extraction_ok`, `unitarity_ok`, `route_certificate_ok`, and export fields `null` or blocked. |

Forbidden routes remain: rank-one or normalized state-preparation, exact
standard `Rat` one-signal/no-workspace primitive witness, proving opaque
semantic predicates by `trivial` or by axiom, using the xor diagnostic as
evidence for modular add/sub cleanup, and preparing Qiskit, QuantumKatas-style,
or QASM3 exports before `DIAG-ROOT-001` has a named Lean certificate.

## Lower Update, 2026-06-20 12:21 JST

`DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001` is closed as a transparent
interface only.  The Lean declarations
`ExpandedArithmeticCleanUncomputeWitness` and
`expandedWorkspaceCleanUncomputedTransparent` now compile adjacent to
`expandedWorkspaceCleanUncomputed`.

This update does not prove `expandedWorkspaceCleanUncomputed`, does not
instantiate the fixed-denominator modular add/sub witness, does not refactor
`expandedAmplitudeOracleCleanBlockContract`, and does not close clean-block
extraction, unitarity, `DIAG-ROOT-001`, or executable exports.

Next route:

```text
leaf=DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001
dependencies=ExpandedArithmeticCleanUncomputeWitness,
  fixedDenomCubicArithmeticBackend,
  fixedDenomCubicArithmeticBackend_computes,
  fixedDenomCubicPayload_lt_capacity
required separate check=controlled rotation is workspace-readonly
blocked parent=DIAG-EXP-UNCOMP-001
gate=python3 tools/qbe.py check
```

The full gate passed at 2026-06-20 12:21 JST.

## Middle Source-Correspondence Refresh, 2026-06-20 12:44 JST

Source anchors and object:

- The source anchor remains the user prompt copied in
  `tasks/QBE-OP-CUBIC-DIAGONAL-001.md`.
- The translated object remains the diagonal operator
  $D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise, with
  `exactNormalizer n = 1`.
- No paper source, figure, visual audit, cited theorem, or external
  construction hint is active.

Lean declarations and theorem statements:

- `ExpandedArithmeticCleanUncomputeWitness`,
  `expandedWorkspaceCleanUncomputedTransparent`, and
  `expandedWorkspaceCleanUncomputedTransparent_of_witness` now compile.
- These declarations close only the transparent cleanup interface.  They do
  not prove `expandedWorkspaceCleanUncomputed`, do not instantiate the
  fixed-denominator cleanup witness, and do not change
  `expandedAmplitudeOracleCleanBlockContract`.
- The finite modular add/sub diagnostic for `n = 1, 2, 3, 4` supports the
  proposed fixed-denominator witness shape, but the Lean route still lacks a
  named workspace-readonly rotation statement.

Proof-DAG frontier update:

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001` | State the transparent clean-uncompute witness interface without proving the opaque cleanup predicate. | `expandedWorkspaceCleanUncomputed`; fixed-denominator backend representation | lower Lean worker | `ExpandedArithmeticCleanUncomputeWitness`, `expandedWorkspaceCleanUncomputedTransparent`, `expandedWorkspaceCleanUncomputedTransparent_of_witness` | this section; verifier feedback `DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001.lower-worker5-20260620-1221.feedback.json` | `python3 tools/qbe.py check` passed 2026-06-20 12:21 JST | proved; not a route certificate |
| `DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001` | Instantiate `expandedWorkspaceCleanUncomputedTransparent n (3 * n)` for the fixed-denominator modular add/sub compute and uncompute steps. | `DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001`, `fixedDenomCubicArithmeticBackend`, `fixedDenomCubicArithmeticBackend_computes`, `fixedDenomCubicPayload_lt_capacity`, modular add/sub arithmetic | next lower Lean worker | planned witness of `ExpandedArithmeticCleanUncomputeWitness n (3 * n)` and theorem via `expandedWorkspaceCleanUncomputedTransparent_of_witness` | verifier feedback `DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001.middle-source-contract-20260620-1244.md` | `python3 tools/qbe.py check` | active leaf |
| `DIAG-RY-WORKSPACE-READONLY-001` | State that the controlled signal rotation reads the arithmetic workspace payload but does not modify workspace or system index. | transparent rotation bookkeeping, route register semantics | lower architect/verifier before route-level cleanup closure | no current Lean declaration | this section; modular add/sub finite diagnostic | `python3 tools/qbe.py check` | blocked internal dependency |
| `DIAG-EXP-UNCOMP-001` | Route-level clean uncompute for the expanded contract. | fixed-denominator transparent cleanup witness plus rotation workspace-readonly semantics | future lower worker after the two subleaves above | opaque target `expandedWorkspaceCleanUncomputed` or later explicit contract refactor | proof-obligation ledger | `python3 tools/qbe.py check` | blocked parent |
| `DIAG-EXP-BLOCK-001` | Prove the extracted clean block satisfies `diagonalCleanBlockContract n block`. | route-level cleanup and extraction semantics | future lower worker | `expandedAmplitudeOracleCleanBlockExtracts` plus `diagonalCleanBlockContract` in the clean-block contract | proof-obligation ledger | `python3 tools/qbe.py check` | blocked |
| `DIAG-ROOT-001` | Exact block-encoding certificate for the diagonal operator. | cleanup, extraction, unitarity/circuit semantics | future lower/reviewer | planned expanded certificate or conditional primitive certificate | proof-obligation ledger | `python3 tools/qbe.py check`; final `lake build && lake build Tests` | blocked |

Lower-facing source contract:

```text
leaf=DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001
source anchor=tasks/QBE-OP-CUBIC-DIAGONAL-001.md user-provided diagonal operator
source object=D_n[row,col] = if row = col then (row / 2^n)^3 else 0
normalizer=exactNormalizer n = 1
target file=QuantumBlockEncoding/CubicStatePreparation.lean
allowed write scope=declarations adjacent to
  ExpandedArithmeticCleanUncomputeWitness and
  expandedWorkspaceCleanUncomputedTransparent
expected Lean target=instantiate
  ExpandedArithmeticCleanUncomputeWitness n (3 * n) for the
  fixed-denominator backend and derive
  expandedWorkspaceCleanUncomputedTransparent n (3 * n)
intended compute step=(j,w) -> (j, (w + j.val ^ 3) mod gridSize (3 * n))
intended uncompute step=(j,w) ->
  (j, (w + gridSize (3 * n) - j.val ^ 3) mod gridSize (3 * n))
closed dependencies=ExpandedArithmeticCleanUncomputeWitness,
  expandedWorkspaceCleanUncomputedTransparent,
  fixedDenomCubicArithmeticBackend,
  fixedDenomCubicArithmeticBackend_computes,
  fixedDenomCubicPayload_lt_capacity
separate dependency=DIAG-RY-WORKSPACE-READONLY-001 must state rotation
  workspace-readonly semantics before any route-level cleanup bridge or
  clean-block extraction proof depends on cleanup
forbidden edits=do not prove expandedWorkspaceCleanUncomputed by trivial,
  do not add an axiom, do not set semantic propositions to True, do not
  refactor expandedAmplitudeOracleCleanBlockContract in this leaf, do not
  switch to rank-one state preparation, and do not prepare executable exports
gate=python3 tools/qbe.py check
```

## Current Middle Packet Override, 2026-06-20 15:40 JST

The active lower-facing source contract is now
`DIAG-RY-WORKSPACE-READONLY-001`.  The immediately preceding
`DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001` packet is closed historical memory.

Use the 15:40 verifier-feedback packet
`verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-RY-WORKSPACE-READONLY-001.middle-source-contract-20260620-1540.md`.
Lower work should state a transparent controlled-rotation workspace-readonly
interface, not prove `expandedWorkspaceCleanUncomputed`, not refactor
`expandedAmplitudeOracleCleanBlockContract`, and not prepare executable
exports.
