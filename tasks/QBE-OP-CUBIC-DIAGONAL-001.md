# Cubic diagonal oracle block encoding

Task id: `QBE-OP-CUBIC-DIAGONAL-001`
Kind: `operatorBlockEncoding`
Mode: `exploratoryConstruction`
Status: `active`

## Continuation Directive: No External Knowledge Injection

This continuation must run as an internal ABEIS loop.  Do not consume new
ChatGPT Pro suggestions, human-supplied construction hints, or out-of-band
mathematical shortcuts.  Upper and middle may use only the task packet, current
Lean source, trial memory, verifier feedback, candidate populations, and
standard ABEIS retrieval artifacts.

If exact certification stalls under the default budget, upper should record the
stall reason and move the task into the approximate Scenario 2 route using the
configured epsilon and resource constraints.  Any increase in upper, middle, or
lower parallelism must be justified from the logs, proof-DAG frontier, and
population diversity, not from external advice.


## Source Input

- Raw user language: `zh`
- Raw input artifact: `task-inbox/QBE-OP-CUBIC-DIAGONAL-001/user_prompt.zh.md`
- Source: `user-provided`
- Requested executable exports: `qiskit,quantum-katas,qasm3`

## Raw User Problem

假设n为正整数是量子比特数，我现在想要构造一个oracle
`O=sum_{j=0}^{2^n-1} f(x_j)|j><j|`，其中函数 `f(x)=x^3`,
`x_j = j/(2^n)`. 请构造这个 operator `O` 的 block-encoding `U_O`.

## Lean-Checkable Target

For `N = 2^n`, define

```text
D_n = sum_{j=0}^{N-1} (j/N)^3 |j><j|.
```

Equivalently, in matrix entries:

```text
D_n[row, col] = if row = col then (row / 2^n)^3 else 0.
```

This task is a **diagonal oracle** problem, not the rank-one state-preparation
problem from `QBE-OP-CUBIC-STATEPREP-001`. Lower agents must not replace it by
`|v><0^n|` and must not normalize the diagonal vector as a quantum state.

The initial exact normalizer is

```text
alpha = 1.
```

Reason: for every grid point `0 <= j/2^n < 1`, the diagonal entry
`(j/2^n)^3` lies in `[0,1]`. The first candidate is therefore a one-signal
amplitude-oracle block encoding whose clean block is exactly `D_n`.

## Current Lean Surface

Compiled declarations live in `QuantumBlockEncoding.CubicDiagonalOracle`:

```lean
taskId
cubicDiagonalOperator
exactNormalizer
cubicDiagonalTarget
amplitudeOracleLayout
amplitudeOracleCircuit
amplitudeOracleResource
amplitudeOracleResourceTuple
amplitudeOracleResource_eq
amplitudeOracleResourceTuple_eq
diagonalCleanBlockContract
diagonalCleanBlockContract_pointwise_eq
primitiveOracleCleanBlock_eq_target
cubicAmplitude_le_one
cubicAmplitude_nonneg
primitiveAmplitudeOracleDimension
primitiveAmplitudeOracleUnitary
primitiveAmplitudeOracleIsUnitary
primitiveAmplitudeOracleCleanBlockExtracts
primitiveAmplitudeOracleSemanticContract
primitiveAmplitudeOracleSemanticContract_unitary
primitiveAmplitudeOracleSemanticContract_cleanBlock_eq_target
primitiveAmplitudeOracleCandidate
primitiveAmplitudeOracleCandidate_costTuple_eq
primitiveAmplitudeOracleCandidate_unitary_from_contract
primitiveAmplitudeOracleCandidate_block_from_contract
primitiveAmplitudeOracleVerified
amplitudeOracleClaim
expandedAmplitudeOracleLayout
expandedAmplitudeOracleLayout_auxiliaryQubits
expandedAmplitudeOracleNormalizer_eq
StandardRyCleanEntryScalarTier
expandedRyCleanEntryForCubicAmplitudes
expandedRyCleanEntryForCubicAmplitudes_of_standardTier
ExpandedCubicArithmeticBackend
expandedArithmeticBackendComputesCubicAmplitude
expandedArithmeticComputesCubicAmplitude
symbolicExpandedCubicArithmeticBackend
symbolicExpandedCubicArithmeticBackend_computes
expandedArithmeticBackendBridge
expandedArithmeticComputesCubicAmplitude_of_backendBridge
expandedArithmeticBackendBridge_iff_of_computes
expandedArithmeticComputesCubicAmplitude_of_symbolicBackendBridge
symbolicExpandedCubicArithmeticBackend_bridge_iff
fixedDenomCubicPayload_lt_capacity
fixedDenomCubicAmplitude_eq
fixedDenomCubicArithmeticBackend
fixedDenomCubicArithmeticBackend_computes
fixedDenomCubicArithmeticBackend_bridge_iff
expandedControlledRyUsesCubicAngle
expandedControlledRyBackendBridge
expandedControlledRyUsesCubicAngle_of_backendBridge
expandedWorkspaceCleanUncomputed
expandedAmplitudeOracleCleanBlockExtracts
expandedAmplitudeOracleCleanBlockContract
expandedAmplitudeOracleCleanBlockContract_diagonal
expandedAmplitudeOracleCleanBlockContract_eq_target
expandedAmplitudeOracleSemanticContract
expandedAmplitudeOracleSemanticContract_cleanBlock_eq_target
```

These declarations fix the target and the oracle-label candidate interface.
They also compile a conditional primitive-oracle contract bridge: if
`h : primitiveAmplitudeOracleSemanticContract n` is supplied, then
`primitiveAmplitudeOracleVerified n h` packages the primitive oracle-label
candidate without setting semantic propositions to `True`.

They do **not** yet prove the primitive semantic contract itself, and they do
not prove a fully expanded gate-level unitary.  The exact standard `Rat`
one-signal/no-workspace interpretation of the primitive witness has been
rejected by finite determinant-square diagnostics, so the current cycle routes
to the expanded arithmetic/controlled-rotation contract.  A later cycle may
return to the primitive oracle-label tier only if upper or the user explicitly
accepts that primitive semantics.

The expanded reversible-arithmetic plus controlled-`R_y` route contract is now
compiled as a conditional interface.  It does not yet prove the concrete route
semantics.  The scalar-tier range bridge for `DIAG-EXP-RY-001` is now compiled
as `expandedRyCleanEntryForCubicAmplitudes_of_standardTier`; the conditional
backend bridge for `DIAG-RY-BRIDGE-001` is compiled as
`expandedControlledRyUsesCubicAngle_of_backendBridge`.  A concrete witness of
`expandedControlledRyBackendBridge` is still required before the opaque backend
predicate `expandedControlledRyUsesCubicAngle` is closed.  The arithmetic
representation leaf `DIAG-ARITH-REP-001` has a fixed-denominator
representation: a `3 * n`-qubit payload register stores `j.val ^ 3`, and the
distinguished amplitude projection is
`(j.val : Rat) ^ 3 / (gridSize (3 * n) : Rat)`.  The Lean leaves
`fixedDenomCubicPayload_lt_capacity`, `fixedDenomCubicAmplitude_eq`,
`fixedDenomCubicArithmeticBackend`,
`fixedDenomCubicArithmeticBackend_computes`, and
`fixedDenomCubicArithmeticBackend_bridge_iff` now compile.  The bridge normal
form records the remaining route-semantics gap; it is not a route certificate.
The next route should:

1. retire stale work that rebuilds `DIAG-EXPANDED-CONTRACT-001`;
2. keep `DIAG-RY-BACKEND-WITNESS-001` blocked until a concrete backend witness
   exists, and retire `DIAG-ARITH-FIXED-DENOM-BACKEND-001` as closed; and
3. keep `DIAG-ROOT-001` and all executable exports blocked until the expanded
   route has a named Lean certificate.

The active arithmetic frontier is now `DIAG-ARITH-BACKEND-BRIDGE-001`, but not
as a direct tactic-search leaf: the existing normal-form lemmas reduce bridge
search to the opaque route predicate.  The next cycle must first introduce or
accept a transparent backend-to-route semantics interface before another lower
worker attempts to close `expandedArithmeticComputesCubicAmplitude`.

## Candidate Score

The oracle-label candidate currently has

```text
(gateCount, depth, auxiliaryQubits, oracleCalls) = (1, 1, 1, 1).
```

Inside one asymptotic/backend tier, QBE ranks candidates by

```text
(gateCount, depth, auxiliaryQubits, oracleCalls).
```

Do not compare an unexpanded oracle-label candidate against a fully expanded
arithmetic-gate candidate without first recording the tier.

## Adaptive Scaling Policy

This diagonal task uses the repository default harness: an upper specialist
panel, a middle specialist panel, three complementary lower roles, and a
reviewer gate.  There are no fixed difficulty presets for users.  After each cycle,
the upper panel must decide from the dialogue, trial log, verifier feedback,
proof-DAG frontier, and candidate-population diversity whether more capacity is
needed and which layer should receive it.

Increase upper capacity only when the bottleneck is target interpretation,
semantic tier, primitive-vs-expanded route choice, or candidate-family strategy.
Increase middle capacity only when the bottleneck is retrieval, stale memory,
Lean/natural-language translation, or population bookkeeping.  Increase lower
capacity only when there are multiple independent proof leaves or candidate
families ready to test.  Every increase must state the expected marginal gain,
the fixed generation budget, and whether the result improved the certified
population, finite verifier population, or only the insight pool.

The system must keep separate populations:

- certified population: Lean-proved candidates only;
- finite executable population: Qiskit/NumPy/QuantumKatas checks only;
- insight pool: useful but unproved routes.

Only certified candidates may be plotted as achieved BE solutions.

## Next Agent Packet

- upper: keep the target diagonal. Do not import rank-one state-prep logic.
- middle: maintain the two-way Lean/natural-language map and retire any stale
  state-prep wording.
- lower 1 natural-language architect: write a route-semantics interface packet
  for `DIAG-ARITH-BACKEND-BRIDGE-001`.  Reuse the fixed-denominator
  representation packet and state exactly what transparent Lean proposition
  would let the compiled backend compute theorem imply
  `expandedArithmeticComputesCubicAmplitude n (3 * n)`.  Do not rewrite the
  representation or attack the root theorem.
- lower 2 Lean worker: do not reassign
  `fixedDenomCubicArithmeticBackend` or
  `fixedDenomCubicArithmeticBackend_computes`; they are closed.  Do not
  reassign `fixedDenomCubicArithmeticBackend_bridge_iff`; it is the compiled
  fixed-denominator bridge normal form.  After middle records the next
  transparent route-semantics interface, target one small declaration in
  `QuantumBlockEncoding/CubicStatePreparation.lean` that connects the
  fixed-denominator compute witness to the expanded arithmetic route without
  setting an opaque proposition to `True`, adding an axiom, or proving it by
  `trivial`.
- lower 3 verifier/export worker: finite arithmetic/register diagnostics may
  continue to check the fixed-denominator representation and payload capacity,
  but must keep block-entry, unitarity, ancilla-cleanup, and export fields
  `null` until a named Lean certificate exists.  Do not prepare Qiskit,
  QuantumKatas-style, or QASM3 exports in this cycle.
- reviewer: reject any proof route that turns this diagonal operator into the
  previous rank-one target or a normalized state-preparation task.

## Middle Update: Transparent Contract Refactor Packet

Updated: 2026-06-20 08:57 JST.

`DIAG-ARITH-ROUTE-TRANSPARENT-001` is closed as a transparent arithmetic
witness only.  The compiled declarations are
`expandedArithmeticComputesCubicAmplitudeTransparent` and
`fixedDenomCubicArithmeticRouteTransparent`, using
`fixedDenomCubicArithmeticBackend` and
`fixedDenomCubicArithmeticBackend_computes`.  This is not a proof of
`expandedArithmeticComputesCubicAmplitude`, not a backend-bridge witness, and
not a root block-encoding certificate.

The next lower-facing Lean leaf is
`DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001`.  Lower 2 should refactor the
existing declaration `expandedAmplitudeOracleCleanBlockContract` in
`QuantumBlockEncoding/CubicStatePreparation.lean` so the arithmetic conjunct
uses
`expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits`
instead of the opaque predicate.  Do not add a theorem from the transparent
predicate to the opaque predicate unless a separate nontrivial route-semantics
bridge is stated.  Do not set semantic propositions to `True`, add axioms,
switch to rank-one state preparation, or prepare executable exports.

After the refactor, the remaining blockers are the controlled-`R_y` backend
witness, clean uncompute, clean-block extraction, unitarity/circuit semantics,
the root certificate, and post-Lean exports.

## Lower Update: Transparent Contract Refactor Closed

Updated: 2026-06-20 09:17 JST.

`DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001` is closed.  The existing
`expandedAmplitudeOracleCleanBlockContract` now uses
`expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits` as its
arithmetic conjunct, so the `workspaceQubits = 3 * n` arithmetic conjunct can
be supplied by `fixedDenomCubicArithmeticRouteTransparent n`.

This is still not a proof of the old opaque predicate
`expandedArithmeticComputesCubicAmplitude`, not a controlled-`R_y` backend
witness, not a clean-uncompute or extraction proof, not a unitarity proof, and
not a root block-encoding certificate.  Executable exports remain blocked.

## Middle Update: Rotation Backend Witness Packet

Updated: 2026-06-20 09:41 JST.

`DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001` and the fixed-denominator arithmetic
children are retired as closed.  Direct proof search for
`expandedArithmeticBackendBridge (fixedDenomCubicArithmeticBackend n)` remains
stale because `fixedDenomCubicArithmeticBackend_bridge_iff` reduces that search
to the old opaque route predicate.

The next source-correspondence leaf is `DIAG-RY-BACKEND-WITNESS-001`.  The
source anchor is still only the user-provided diagonal operator
`D_n[row,col] = if row = col then (row / 2^n)^3 else 0`, with
`exactNormalizer n = 1`.  The relevant Lean declarations are
`StandardRyCleanEntryScalarTier`,
`expandedRyCleanEntryForCubicAmplitudes_of_standardTier`,
`expandedControlledRyBackendBridge`, and
`expandedControlledRyUsesCubicAngle_of_backendBridge`.

The lower-facing contract is to state a concrete backend-semantics witness for

```lean
expandedControlledRyBackendBridge tier n (3 * n)
```

or to record that the witness is still blocked.  The witness must explain that
the expanded route's controlled signal rotation uses the same standard
`R_y(theta)` convention already specialized by
`expandedRyCleanEntryForCubicAmplitudes_of_standardTier`, with
`theta_j = 2 * arccos((j / 2^n)^3)`.  A lower worker must not close
`expandedControlledRyUsesCubicAngle` by `trivial`, by an axiom, or by setting
an opaque semantic proposition to `True`.

`DIAG-EXP-UNCOMP-001`, clean-block extraction, unitarity/circuit semantics,
`DIAG-ROOT-001`, and all executable exports remain blocked until the rotation
backend witness and the later route obligations have named Lean certificates.

## Middle Update: Transparent Rotation Interface Packet

Updated: 2026-06-20 10:26 JST.

The source anchor is still only the user-provided diagonal operator
`D_n[row,col] = if row = col then (row / 2^n)^3 else 0`, with
`exactNormalizer n = 1`.  No paper source, figure, or cited theorem is active.

Lower feedback showed that direct proof of

```lean
expandedControlledRyBackendBridge tier n (3 * n)
```

is stale under the current Lean surface: the compiled normal form
`expandedControlledRyBackendBridge_iff_of_standardTier` reduces that witness to
the opaque predicate `expandedControlledRyUsesCubicAngle n (3 * n)`.  The next
lower-facing Lean leaf is therefore `DIAG-RY-TRANSPARENT-INTERFACE-001`.

Lower 2 may add only the transparent rotation-angle interface adjacent to
`expandedControlledRyUsesCubicAngle` in
`QuantumBlockEncoding/CubicStatePreparation.lean`:

```lean
def expandedControlledRyUsesCubicAngleTransparent
    (n workspaceQubits : Nat) : Prop :=
  forall tier : StandardRyCleanEntryScalarTier,
    expandedRyCleanEntryForCubicAmplitudes tier n

theorem fixedDenomControlledRyRouteTransparent
    (n : Nat) :
    expandedControlledRyUsesCubicAngleTransparent n (3 * n)
```

The proof should reuse
`expandedRyCleanEntryForCubicAmplitudes_of_standardTier`.  This transparent
leaf is not a proof of `expandedControlledRyUsesCubicAngle`, not a backend
witness, not clean uncompute, not a root block-encoding certificate, and not an
export authorization.  A later middle packet must separately choose whether to
refactor `expandedAmplitudeOracleCleanBlockContract` to consume the transparent
rotation predicate or to introduce a nontrivial backend-semantics bridge.

## Lower Update: Transparent Rotation Interface Closed

Updated: 2026-06-20 10:43 JST.

`DIAG-RY-TRANSPARENT-INTERFACE-001` is closed.  The Lean declarations
`expandedControlledRyUsesCubicAngleTransparent` and
`fixedDenomControlledRyRouteTransparent` now compile in
`QuantumBlockEncoding/CubicStatePreparation.lean`, using
`expandedRyCleanEntryForCubicAmplitudes_of_standardTier`.

This is still not a proof of the opaque predicate
`expandedControlledRyUsesCubicAngle`, not a backend witness, not clean
uncompute, not extraction, not unitarity, not a root block-encoding
certificate, and not an export authorization.  The next route is for middle to
choose either a transparent rotation contract refactor or a nontrivial
backend-semantics bridge.

## Middle Update: Transparent Rotation Contract Refactor Packet

Updated: 2026-06-20 11:04 JST.

Middle chooses the transparent rotation contract-refactor route.  The source
anchor is still the user-provided diagonal operator
`D_n[row,col] = if row = col then (row / 2^n)^3 else 0`, with
`exactNormalizer n = 1`.  No paper source, figure, or cited theorem is active.

`DIAG-RY-TRANSPARENT-INTERFACE-001` is closed only as transparent scalar-angle
bookkeeping.  The compiled declarations are
`expandedControlledRyUsesCubicAngleTransparent` and
`fixedDenomControlledRyRouteTransparent`.  They do not prove
`expandedControlledRyUsesCubicAngle`, do not supply
`expandedControlledRyBackendBridge`, and do not close clean uncompute,
extraction, unitarity, `DIAG-ROOT-001`, or exports.

The next lower-facing Lean leaf is `DIAG-RY-TRANSPARENT-CONTRACT-001`.  Lower 2
should refactor the existing declaration
`expandedAmplitudeOracleCleanBlockContract` in
`QuantumBlockEncoding/CubicStatePreparation.lean` so the rotation conjunct uses
`expandedControlledRyUsesCubicAngleTransparent n workspaceQubits` instead of
the opaque predicate.  Do not add a theorem from the transparent predicate to
the opaque predicate unless a separate nontrivial backend-semantics bridge is
stated.  Do not set semantic propositions to `True`, add axioms, switch to
rank-one state preparation, or prepare executable exports.

## Middle/Lean Update: Transparent Rotation Contract Refactor Closed

Updated: 2026-06-20 11:22 JST.

`DIAG-RY-TRANSPARENT-CONTRACT-001` is closed.  The existing declaration
`expandedAmplitudeOracleCleanBlockContract` now uses
`expandedControlledRyUsesCubicAngleTransparent n workspaceQubits` as its
rotation conjunct, so for `workspaceQubits = 3 * n` the rotation bookkeeping
conjunct can be supplied by `fixedDenomControlledRyRouteTransparent n`.

This is still not a proof of `expandedControlledRyUsesCubicAngle`, not a
backend witness for `expandedControlledRyBackendBridge`, not a clean-uncompute
or extraction proof, not a unitarity proof, not a root block-encoding
certificate, and not an export authorization.  Executable exports remain
blocked.

The next source-correspondence leaf is `DIAG-EXP-UNCOMP-001`.  Middle should
first write the clean-uncompute contract against the fixed-denominator expanded
route and the transparent arithmetic/rotation witnesses.  Lower 2 must not
prove `expandedWorkspaceCleanUncomputed` by `trivial`, by an axiom, or by
setting a semantic proposition to `True`.

## Middle Update: Clean-Uncompute Transparent Interface Packet

Updated: 2026-06-20 11:58 JST.

`DIAG-EXP-UNCOMP-001` is classified as an opaque parent, not a direct Lean
tactic target.  Lower clean-uncompute feedback found a shape/register gap:
the fixed-denominator backend proves clean-input compute behavior, but it does
not expose an inverse arithmetic operation or a controlled-rotation
workspace-readonly theorem.

The next lower-facing Lean leaf is
`DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001`.  Lower 2 may add only a transparent
cleanup witness interface adjacent to `expandedWorkspaceCleanUncomputed` in
`QuantumBlockEncoding/CubicStatePreparation.lean`, tying a reversible
`computeStep`/`uncomputeStep` pair to an `ExpandedCubicArithmeticBackend`.
This leaf must not prove `expandedWorkspaceCleanUncomputed`, must not refactor
`expandedAmplitudeOracleCleanBlockContract`, and must not prepare executable
exports.

The lower finite diagnostic for `DIAG-EXP-UNCOMP-001` checked an xor cleanup
skeleton.  The lower architect's modular add/sub cleanup is a valid proposed
subleaf, but the xor diagnostic is not evidence for that exact add/sub
interface; the add/sub witness needs its own Lean proof or matching diagnostic.

`DIAG-EXP-BLOCK-001`, unitarity/circuit semantics, `DIAG-ROOT-001`, and the
requested Qiskit, QuantumKatas-style, and QASM3 exports remain blocked.

## Lower Update: Transparent Clean-Uncompute Interface Closed

Updated: 2026-06-20 12:21 JST.

`DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001` is closed as a transparent
interface only.  The Lean declarations `ExpandedArithmeticCleanUncomputeWitness`,
`expandedWorkspaceCleanUncomputedTransparent`, and
`expandedWorkspaceCleanUncomputedTransparent_of_witness` now compile adjacent
to `expandedWorkspaceCleanUncomputed`.

This does not prove `expandedWorkspaceCleanUncomputed`, does not instantiate
the fixed-denominator modular add/sub witness, does not refactor
`expandedAmplitudeOracleCleanBlockContract`, and does not close extraction,
unitarity, `DIAG-ROOT-001`, or executable exports.

## Middle Update: Fixed-Denom Cleanup Witness Packet

Updated: 2026-06-20 12:44 JST.

The next lower-facing Lean leaf is
`DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001`.  Lower 2 may instantiate the
transparent cleanup witness for `workspaceQubits = 3 * n` using the
fixed-denominator backend and modular add/sub compute steps:

```text
computeStep(j,w) = (j, (w + j^3) mod 2^(3n))
uncomputeStep(j,w) = (j, (w + 2^(3n) - j^3) mod 2^(3n))
```

The expected Lean target is a witness of
`ExpandedArithmeticCleanUncomputeWitness n (3 * n)` and a derived proof of
`expandedWorkspaceCleanUncomputedTransparent n (3 * n)`.  This leaf must not
prove the opaque predicate `expandedWorkspaceCleanUncomputed`, add an axiom,
set a semantic proposition to `True`, refactor
`expandedAmplitudeOracleCleanBlockContract`, switch to rank-one state
preparation, or prepare executable exports.

`DIAG-RY-WORKSPACE-READONLY-001` is a separate dependency: the finite modular
add/sub diagnostic records workspace-readonly rotation in an identity-read
model, but there is no named Lean statement yet.  `DIAG-EXP-UNCOMP-001`,
clean-block extraction, unitarity/circuit semantics, `DIAG-ROOT-001`, and all
requested executable exports remain blocked.

## Lower Update: Fixed-Denom Cleanup Witness Closed

Updated: 2026-06-20 13:07 JST.

`DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001` is closed as a transparent
fixed-denominator cleanup witness.  The compiled declarations are
`fixedDenomCubicComputeStep`, `fixedDenomCubicUncomputeStep`,
`fixedDenomCubicComputeStep_matches_backend_on_clean`,
`fixedDenomCubicUncomputeStep_after_compute`,
`fixedDenomExpandedArithmeticCleanUncomputeWitness`, and
`fixedDenomWorkspaceCleanUncomputedTransparent`.

This is not a proof of `expandedWorkspaceCleanUncomputed`, not a
controlled-rotation workspace-readonly statement, not extraction, not
unitarity, not `DIAG-ROOT-001`, and not an export authorization.

## Middle Update: Rotation Workspace-Readonly Packet

Updated: 2026-06-20 15:40 JST.

The next source-correspondence leaf is `DIAG-RY-WORKSPACE-READONLY-001`.
The source anchor is still only the user-provided diagonal operator
`D_n[row,col] = if row = col then (row / 2^n)^3 else 0`, with
`exactNormalizer n = 1`.  No paper source, figure, or cited theorem is active.

The lower-facing contract is to state a transparent readonly-rotation
interface adjacent to the controlled-`R_y` route declarations in
`QuantumBlockEncoding/CubicStatePreparation.lean`.  A suitable interface should
tie the existing transparent angle convention
`expandedControlledRyUsesCubicAngleTransparent n workspaceQubits` to a rotation
step that preserves the system index and arithmetic workspace.  One acceptable
shape is a witness record with fields:

```lean
structure ExpandedControlledRyWorkspaceReadonlyWitness
    (n workspaceQubits : Nat) where
  backend : ExpandedCubicArithmeticBackend n workspaceQubits
  angleConvention :
    expandedControlledRyUsesCubicAngleTransparent n workspaceQubits
  rotationStep :
    Fin (gridSize n) -> backend.Workspace -> Fin 2 ->
      Prod (Prod (Fin (gridSize n)) backend.Workspace) (Fin 2)
  preserves_index :
    forall j w signal, (rotationStep j w signal).1.1 = j
  preserves_workspace :
    forall j w signal, (rotationStep j w signal).1.2 = w

def expandedControlledRyWorkspaceReadonlyTransparent
    (n workspaceQubits : Nat) : Prop :=
  Nonempty (ExpandedControlledRyWorkspaceReadonlyWitness n workspaceQubits)
```

This leaf must not prove `expandedWorkspaceCleanUncomputed`, must not refactor
`expandedAmplitudeOracleCleanBlockContract`, must not set any semantic
proposition to `True`, must not add an axiom, must not switch to rank-one
state preparation, and must not prepare executable exports.  After the
readonly interface is named, middle can choose a transparent cleanup contract
refactor or a nontrivial bridge for the route-level cleanup parent
`DIAG-EXP-UNCOMP-001`.
