# Proof Obligations: QBE-OP-CUBIC-DIAGONAL-001

Updated: 2026-06-20 15:40 JST

The source is the user-provided diagonal operator
$D_n = \sum_{j=0}^{2^n-1} (j/2^n)^3 |j\rangle\langle j|$.
There is no paper-source dependency for this task.

Current obligation state:

| Obligation | Lean declaration or target | Dependency class | Status |
|---|---|---|---|
| Keep the target diagonal, not rank-one state preparation. | `CubicDiagonalOracle.cubicDiagonalOperator`, `cubicDiagonalTarget` | source/operator contract | compiled; reviewer must reject rank-one routes |
| Record exact normalizer $\alpha = 1$. | `CubicDiagonalOracle.exactNormalizer` | normalizer | compiled |
| Prove amplitude range $0 \le (j/2^n)^3 \le 1$. | `cubicAmplitude_nonneg`, `cubicAmplitude_le_one` | internal Lean lemma | compiled |
| Record one-signal primitive oracle-label resources. | `amplitudeOracleLayout`, `amplitudeOracleResourceTuple_eq`, `primitiveAmplitudeOracleCandidate_costTuple_eq` | resource equality | compiled |
| Bridge a clean-block contract to the target operator. | `CubicDiagonalOracle.primitiveOracleCleanBlock_eq_target` | internal Lean lemma | compiled; gate passed 2026-06-19 20:44 JST |
| State primitive one-signal oracle unitarity and clean-block extraction without hiding semantics. | `primitiveAmplitudeOracleUnitary`, `primitiveAmplitudeOracleIsUnitary`, `primitiveAmplitudeOracleCleanBlockExtracts`, `primitiveAmplitudeOracleSemanticContract`, `primitiveAmplitudeOracleSemanticContract_cleanBlock_eq_target` | oracle/circuit semantics | compiled conditional contract; does not prove the primitive semantics |
| Provide a proof or accepted primitive-tier source for the semantic contract. | `primitiveAmplitudeOracleSemanticContract n` | external primitive contract | blocked; not assigned this cycle without explicit primitive-tier acceptance |
| Retire the exact standard rational one-signal/no-workspace primitive witness subroute. | verifier packet `DIAG-PRIM-WITNESS-001.rat-one-signal.*` | necessary-condition rejection | rejected for `n = 1, 2, 3` by determinant-square obstruction; target diagonal still passes |
| State the expanded reversible-arithmetic plus controlled-rotation contract. | `expandedAmplitudeOracleLayout`, `expandedAmplitudeOracleCleanBlockContract`, `expandedAmplitudeOracleSemanticContract_cleanBlock_eq_target` | QBE-local semantic glue | compiled conditional interface; semantic obligations open |
| Prove or refine the standard `R_y` clean-entry identity for the expanded route. | scalar-tier interface `StandardRyCleanEntryScalarTier`, bridge `expandedRyCleanEntryForCubicAmplitudes_of_standardTier`; conditional bridge `expandedControlledRyUsesCubicAngle_of_backendBridge`; backend target `expandedControlledRyUsesCubicAngle` | classical/scalar-tier technical lemma | scalar range bridge compiled; conditional backend bridge compiled; concrete backend witness recorded as an open obligation |
| Prove or refine reversible cubic arithmetic into workspace. | `ExpandedCubicArithmeticBackend`, `symbolicExpandedCubicArithmeticBackend`, `symbolicExpandedCubicArithmeticBackend_computes`, `expandedArithmeticBackendBridge`, theorem `expandedArithmeticComputesCubicAmplitude_of_backendBridge`, theorem `expandedArithmeticBackendBridge_iff_of_computes`, theorem `expandedArithmeticComputesCubicAmplitude_of_symbolicBackendBridge`, theorem `symbolicExpandedCubicArithmeticBackend_bridge_iff`; compiled fixed-denominator lemmas `fixedDenomCubicPayload_lt_capacity`, `fixedDenomCubicAmplitude_eq`; compiled fixed-denominator backend `fixedDenomCubicArithmeticBackend` and `fixedDenomCubicArithmeticBackend_computes`; theorem `fixedDenomCubicArithmeticBackend_bridge_iff`; compiled transparent declarations `expandedArithmeticComputesCubicAmplitudeTransparent` and `fixedDenomCubicArithmeticRouteTransparent`; target `expandedArithmeticComputesCubicAmplitude` remains opaque | QBE-local arithmetic semantic glue | symbolic compute-phase backend, pointwise compute proof, general bridge normal form, symbolic-backend conditional closure, fixed-denominator capacity/algebra/backend compute proof, fixed-denominator bridge normal form, and transparent existential route witness compiled; `DIAG-ARITH-BACKEND-BRIDGE-001` remains blocked |
| Prove or refine clean uncompute for the arithmetic workspace. | target `expandedWorkspaceCleanUncomputed`; transparent witnesses `expandedWorkspaceCleanUncomputedTransparent`, `fixedDenomWorkspaceCleanUncomputedTransparent`; active readonly leaf `DIAG-RY-WORKSPACE-READONLY-001` | QBE-local workspace and rotation/register semantic glue | transparent cleanup interface and fixed-denominator cleanup witness compiled; opaque cleanup route remains blocked until readonly rotation semantics and a bridge or contract refactor are named |
| Produce an exact primitive block-encoding certificate or equivalent project-local certificate. | `primitiveAmplitudeOracleVerified n h` | root certificate | conditional transformer compiled; unconditional certificate blocked on `h : primitiveAmplitudeOracleSemanticContract n` |
| Prove the expanded route's clean-block bridge once the interface exists. | `expandedAmplitudeOracleCleanBlockContract_diagonal`, `expandedAmplitudeOracleCleanBlockContract_eq_target`, `expandedAmplitudeOracleSemanticContract_cleanBlock_eq_target` | internal Lean lemma after interface selection | compiled conditional bridge; root certificate still blocked |
| Create Qiskit, QuantumKatas-style, and QASM3 exports. | planned `executable-exports/QBE-OP-CUBIC-DIAGONAL-001/` packet | post-Lean export | blocked until a Lean certificate is named |

## Proof-DAG Nodes

The scheduling frontier is maintained in
`conversion-windows/QBE-OP-CUBIC-DIAGONAL-001.md`.  The active Lean leaf for
cycle 1, `DIAG-BLOCK-BRIDGE-001`, is closed.  The cycle 2 middle update
compiled the primitive semantic contract interface and the conditional bridge
to the target clean block.  This lower pass also compiled the candidate-specific
score theorem `primitiveAmplitudeOracleCandidate_costTuple_eq`.

The exact standard rational one-signal/no-workspace interpretation of
`DIAG-PRIM-WITNESS-001` is rejected by verifier feedback, and the primitive
opaque contract should not be assigned to a Lean worker without an explicit
primitive-tier acceptance source.  The expanded reversible-arithmetic plus
controlled-`R_y` route contract is now compiled.  The rotation
source-correspondence leaf `DIAG-EXP-RY-001` now has a compiled scalar-tier
range bridge: `expandedRyCleanEntryForCubicAmplitudes_of_standardTier`
specializes the standard `R_y(theta)` clean-entry contract to
`theta_j = 2 arccos((j/2^n)^3)`.  The conditional bridge
`expandedControlledRyUsesCubicAngle_of_backendBridge` now applies that
specialization to `expandedControlledRyUsesCubicAngle` only when an explicit
backend witness `expandedControlledRyBackendBridge` is supplied.  It does not
prove the backend predicate unconditionally.  The current coordinator pass
records that witness as an open backend obligation because no concrete witness
is present in the current Lean surface.  The independent arithmetic parent
leaf `DIAG-EXP-ARITH-001` has a compiled symbolic compute child
`DIAG-EXP-ARITH-BACKEND-001`; the fixed-denominator representation, capacity,
algebra, and backend-compute children are now compiled.  The active
source-contract child is `DIAG-ARITH-ROUTE-INTERFACE-001`, under the blocked
parent `DIAG-ARITH-BACKEND-BRIDGE-001`.

The current source-correspondence pass classifies `DIAG-ARITH-REP-001` as
represented by a fixed-denominator numerator workspace:
`workspaceQubits = 3 * n`, workspace basis `Fin (gridSize (3 * n))`, payload
`j.val ^ 3`, and amplitude projection
`(payload : Rat) / (gridSize (3 * n) : Rat)`.  The Lean declarations
`fixedDenomCubicPayload_lt_capacity` and `fixedDenomCubicAmplitude_eq` compile
for this representation.  The source operator and normalizer match the Lean
target, and the symbolic backend has a compiled pointwise compute proof.
The lower refiner also compiled `expandedArithmeticBackendBridge_iff_of_computes`,
with `symbolicExpandedCubicArithmeticBackend_bridge_iff` as its symbolic-backend
specialization and `fixedDenomCubicArithmeticBackend_bridge_iff` as its
fixed-denominator specialization.  These show that a direct bridge proof for
any backend whose pointwise compute contract is available is equivalent to the
opaque route predicate itself.  Since the fixed-denominator backend compute
proof now compiles, the remaining arithmetic parent is the honest
backend-to-route semantics bridge, not another backend definition.  This is not
an external cited result.

The 2026-06-20 07:26 JST middle refresh confirms the same source contract after
the upper cycle-1 synthesis: the active paper/user object is still only the
diagonal operator from `tasks/QBE-OP-CUBIC-DIAGONAL-001.md`, and no source
archive or cited result is active.  The capacity, algebra, and backend-compute
leaves are closed and stale for new lower work.  `DIAG-ARITH-BACKEND-BRIDGE-001`
remains blocked because the bridge normal forms reduce direct proof search to
the opaque expanded-route predicate.  The transparent route-semantics interface
is now compiled as the local leaf
`DIAG-ARITH-ROUTE-TRANSPARENT-001`.

The 2026-06-20 08:12 JST middle source-correspondence pass adopts the
transparent existential route interface as the next lower Lean target.  The
interface is:

```lean
def expandedArithmeticComputesCubicAmplitudeTransparent
    (n workspaceQubits : Nat) : Prop :=
  Exists fun backend : ExpandedCubicArithmeticBackend n workspaceQubits =>
    expandedArithmeticBackendComputesCubicAmplitude backend
```

The first witness theorem is:

```lean
theorem fixedDenomCubicArithmeticRouteTransparent
    (n : Nat) :
    expandedArithmeticComputesCubicAmplitudeTransparent n (3 * n)
```

The proof uses `fixedDenomCubicArithmeticBackend n` and
`fixedDenomCubicArithmeticBackend_computes n`.  This closes only the
transparent arithmetic route witness.  It does not prove the existing opaque
predicate `expandedArithmeticComputesCubicAmplitude n (3 * n)` unless a later
named bridge or contract refactor is explicitly adopted and compiled.

## Source-Correspondence Contract For Lower Work

The source object is the user-provided diagonal operator
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise.  The active
route must preserve `exactNormalizer n = 1`.

The arithmetic parent leaf `DIAG-EXP-ARITH-001` now has a compiled conditional
backend bridge.  The child leaf `DIAG-EXP-ARITH-BACKEND-001` has a symbolic
compute-phase backend,
`symbolicExpandedCubicArithmeticBackend n workspaceQubits`, and a compiled
pointwise proof
`symbolicExpandedCubicArithmeticBackend_computes n workspaceQubits`.  The
representation leaf `DIAG-ARITH-REP-001` is now specified by a
fixed-denominator numerator register.
The 2026-06-20 06:56 JST lower Lean update closes
`DIAG-ARITH-FIXED-DENOM-BACKEND-001` by adding
`fixedDenomCubicArithmeticBackend` and
`fixedDenomCubicArithmeticBackend_computes`.  This proves only the pointwise
compute contract for the fixed-denominator backend; it does not close the
opaque route predicate, rotation backend witness, clean uncompute, extraction,
unitarity, root certificate, or executable exports.

The Lean targets `fixedDenomCubicPayload_lt_capacity` and
`fixedDenomCubicAmplitude_eq` now prove, respectively,
`j.val ^ 3 < gridSize (3 * n)` and
`(j.val : Rat) ^ 3 / (gridSize (3 * n) : Rat) =
  CubicStatePreparation.cubicAmplitude n j`.  The fixed-denominator backend
compute proof is now closed.

The fixed-denominator backend leaf is now represented by
`fixedDenomCubicArithmeticBackend n :
  ExpandedCubicArithmeticBackend n (3 * n)` and
`fixedDenomCubicArithmeticBackend_computes n :
  expandedArithmeticBackendComputesCubicAmplitude
    (fixedDenomCubicArithmeticBackend n)`.  The bridge parent
`DIAG-ARITH-BACKEND-BRIDGE-001` remains blocked until there is a transparent
backend-to-route semantics interface or an explicit accepted bridge witness.
The only allowed closure of the opaque route predicate remains the existing
theorem
`expandedArithmeticComputesCubicAmplitude_of_backendBridge backend hBackend
hBridge`.  This still does not claim clean uncompute, rotation semantics,
extraction, unitarity, or a root certificate.

Repeating tactic search against the opaque route predicate after the
fixed-denominator backend exists but before the route-interface leaf exists
should be treated as a stale route with `error_class=symbolic_bridge_gap`.

After the 08:12 middle adoption, the route-interface leaf exists as a precise
contract-design target.  Repeating direct search against
`expandedArithmeticBackendBridge (fixedDenomCubicArithmeticBackend n)` remains
stale; the next allowed lower Lean edit is the transparent existential
predicate plus fixed-denominator witness theorem.

The last lower packet is now closed:

```text
closed leaf=DIAG-ARITH-FIXED-DENOM-BACKEND-001
source anchor=tasks/QBE-OP-CUBIC-DIAGONAL-001.md user-provided diagonal operator
source object=D_n[row,col] = if row = col then (row / 2^n)^3 else 0
normalizer=alpha = 1
workspaceQubits=3 * n
workspace basis=Fin (gridSize (3 * n))
payload=j.val ^ 3
closed dependencies=fixedDenomCubicPayload_lt_capacity,
  fixedDenomCubicAmplitude_eq
compiled declarations=fixedDenomCubicArithmeticBackend,
  fixedDenomCubicArithmeticBackend_computes
blocked parent=DIAG-ARITH-BACKEND-BRIDGE-001
gate=python3 tools/qbe.py check
```

The 2026-06-20 06:49 JST middle coordinator synthesis adds no new theorem
claim.  It only sharpens the lower-2 implementation packet: the planned backend
should use `Workspace := Fin (gridSize (3 * n))`, clean workspace `0`,
payload `j.val ^ 3`, and amplitude projection
`(payload.val : Rat) / (gridSize (3 * n) : Rat)`.  The compute proof should
reuse `fixedDenomCubicPayload_lt_capacity` and
`fixedDenomCubicAmplitude_eq`.  All bridge, rotation, uncompute, root, and
export obligations remain blocked.

The concrete rotation backend witness
`hBridge : expandedControlledRyBackendBridge tier n workspaceQubits` remains an
open backend obligation.  A lower worker may return to it only after a real
backend-semantics interface is introduced; it must not close
`expandedControlledRyUsesCubicAngle` by `trivial`.

No cited-result row is currently available for this user-provided construction.
The compiled rotation bridge still depends on the QBE-local technical lemma
`tl-cubic-diagonal-ry-clean-entry`, with its concrete backend witness left open.
The next lower route depends on the arithmetic technical lemma
`tl-cubic-diagonal-reversible-cube-arithmetic`.  Clean-workspace facts remain
separate obligations before any later extraction proof may depend on them.

## Technical-Lemma Obligations

These rows are QBE-local semantic glue for the user-provided target, not paper
citations and not certified theorems.

| id | Statement used | Lean target | Used by | Status |
|---|---|---|---|---|
| `tl-cubic-diagonal-ry-clean-entry` | For every scalar amplitude `a` with `0 <= a <= 1`, standard `R_y(theta)` with `theta = 2 * arccos a` has clean entry `cos(theta / 2) = a`. | `StandardRyCleanEntryScalarTier`; `expandedRyCleanEntryForCubicAmplitudes_of_standardTier`; `expandedControlledRyBackendBridge`; `expandedControlledRyUsesCubicAngle_of_backendBridge` | `DIAG-EXP-RY-001`, `DIAG-RY-BRIDGE-001` | scalar-tier specialization and conditional backend bridge compiled; concrete backend witness recorded as open |
| `tl-cubic-diagonal-reversible-cube-arithmetic` | Reversible arithmetic computes `CubicStatePreparation.cubicAmplitude n j` into route workspace while preserving system index `j`. | `ExpandedCubicArithmeticBackend`; `symbolicExpandedCubicArithmeticBackend`; `symbolicExpandedCubicArithmeticBackend_computes`; compiled `fixedDenomCubicPayload_lt_capacity`; compiled `fixedDenomCubicAmplitude_eq`; compiled `fixedDenomCubicArithmeticBackend`; compiled `fixedDenomCubicArithmeticBackend_computes`; compiled `expandedArithmeticComputesCubicAmplitudeTransparent`; compiled `fixedDenomCubicArithmeticRouteTransparent`; `expandedArithmeticBackendBridge`; `expandedArithmeticComputesCubicAmplitude`; `expandedArithmeticBackendBridge_iff_of_computes`; `expandedArithmeticComputesCubicAmplitude_of_symbolicBackendBridge`; `symbolicExpandedCubicArithmeticBackend_bridge_iff`; `fixedDenomCubicArithmeticBackend_bridge_iff` | `DIAG-EXP-ARITH-001`, representation child `DIAG-ARITH-REP-001`, fixed-denominator children, route-interface child, bridge child `DIAG-ARITH-BACKEND-BRIDGE-001` | symbolic compute witness, general/symbolic/fixed-denominator bridge normal forms, symbolic-backend conditional closure, fixed-denominator capacity/algebra lemmas, fixed-denominator backend compute proof, and transparent existential route witness compiled; opaque bridge remains blocked |
| `tl-cubic-diagonal-clean-uncompute` | Inverse arithmetic restores every workspace register to zero after the controlled rotation and preserves the system index. | `ExpandedArithmeticCleanUncomputeWitness`, `expandedWorkspaceCleanUncomputedTransparent`, `fixedDenomExpandedArithmeticCleanUncomputeWitness`, `fixedDenomWorkspaceCleanUncomputedTransparent`, active readonly interface `DIAG-RY-WORKSPACE-READONLY-001`, opaque route target `expandedWorkspaceCleanUncomputed` | `DIAG-EXP-UNCOMP-001` | transparent cleanup interface and fixed-denominator cleanup witness compile; readonly rotation statement is active; opaque route cleanup remains blocked |

## Expanded Route Sub-Obligations

The natural-language proof contract for this route is recorded in
`proof-attempts/QBE-OP-CUBIC-DIAGONAL-001-diag-amplitude-proof-dag.md`.
The next Lean work should keep these sub-obligations separate rather than
flattening them into one opaque theorem.

| Sub-obligation | Interface | Dependency | Status |
|---|---|---|---|
| `DIAG-EXP-REG-001` | Name the expanded layout: system register, one signal qubit, and arithmetic workspace size/register type. | `DIAG-TGT-001` | compiled as `expandedAmplitudeOracleLayout` |
| `DIAG-EXP-ARITH-001` | Prove reversible computation of $a_j = (j/2^n)^3$ as `CubicStatePreparation.cubicAmplitude n j`. | `DIAG-RANGE-001`, `DIAG-EXP-REG-001` | parent leaf; conditional backend bridge compiled as `expandedArithmeticComputesCubicAmplitude_of_backendBridge`; symbolic-backend specialization compiled as `expandedArithmeticComputesCubicAmplitude_of_symbolicBackendBridge` |
| `DIAG-EXP-ARITH-BACKEND-001` | Instantiate a compute-phase `ExpandedCubicArithmeticBackend` and prove its compute phase preserves `j` and writes `CubicStatePreparation.cubicAmplitude n j`. | `DIAG-EXP-ARITH-001`, finite arithmetic diagnostic for `n = 1..5` | symbolic backend plus pointwise compute proof compiled; no clean-uncompute, rotation, extraction, root certificate, or export claim |
| `DIAG-ARITH-REP-001` | Specify a concrete workspace/register/backend representation for the selected arithmetic route. | `DIAG-EXP-ARITH-BACKEND-001` | fixed-denominator proof-map candidate specified; capacity/algebra Lean declarations compiled |
| `DIAG-ARITH-FIXED-DENOM-CAP-001` | Prove `j.val ^ 3 < gridSize (3 * n)` for `j : Fin (gridSize n)`. | `DIAG-ARITH-REP-001`, `j.isLt`, `gridSize_three_mul_eq_cube` | proved by `fixedDenomCubicPayload_lt_capacity`; `python3 tools/qbe.py check` passed |
| `DIAG-ARITH-FIXED-DENOM-ALG-001` | Prove `(j.val : Rat) ^ 3 / (gridSize (3 * n) : Rat) = CubicStatePreparation.cubicAmplitude n j`. | `DIAG-ARITH-FIXED-DENOM-CAP-001`, `gridPoint`, `cubicAmplitude`, rational power/division algebra | proved by `fixedDenomCubicAmplitude_eq`; `python3 tools/qbe.py check` passed |
| `DIAG-ARITH-FIXED-DENOM-BACKEND-001` | Define a backend with workspace `Fin (gridSize (3 * n))` and prove its pointwise compute contract. | `DIAG-ARITH-FIXED-DENOM-CAP-001`, `DIAG-ARITH-FIXED-DENOM-ALG-001` | proved by `fixedDenomCubicArithmeticBackend` and `fixedDenomCubicArithmeticBackend_computes`; `python3 tools/qbe.py check` passed |
| `DIAG-ARITH-ROUTE-INTERFACE-001` | State the transparent route-semantics interface that makes the fixed-denominator pointwise compute backend usable by the expanded arithmetic route. | `DIAG-ARITH-FIXED-DENOM-BACKEND-001`, `expandedArithmeticBackendBridge_iff_of_computes`, route-semantics design | normal-form memory compiled as `fixedDenomCubicArithmeticBackend_bridge_iff`; transparent leaf compiled as `expandedArithmeticComputesCubicAmplitudeTransparent` and `fixedDenomCubicArithmeticRouteTransparent`; not a root or opaque-route certificate |
| `DIAG-ARITH-BACKEND-BRIDGE-001` | Supply `expandedArithmeticBackendBridge` for the concrete fixed-denominator backend, or replace it with a transparent backend-to-route interface. | `DIAG-ARITH-FIXED-DENOM-BACKEND-001`, `DIAG-ARITH-ROUTE-INTERFACE-001`, backend route semantics | blocked parent leaf; `fixedDenomCubicArithmeticBackend_bridge_iff` now records that direct bridge search for the concrete backend is equivalent to the opaque route predicate, so direct bridge search remains stale until a transparent or accepted route semantics witness exists |
| `DIAG-EXP-RY-001` | Prove standard $R_y(\theta)$ semantics with clean entry $\cos(\theta/2)$ and $\theta_j = 2 \arccos(a_j)$. | `DIAG-RANGE-001`, `DIAG-EXP-ARITH-001`, `tl-cubic-diagonal-ry-clean-entry` | scalar-tier range bridge compiled as `expandedRyCleanEntryForCubicAmplitudes_of_standardTier`; broad leaf retired |
| `DIAG-RY-BACKEND-WITNESS-001` | Supply a concrete backend-semantics witness `hBridge : expandedControlledRyBackendBridge tier n workspaceQubits`. | `DIAG-EXP-RY-001`, `tl-cubic-diagonal-ry-clean-entry`, backend rotation semantics | blocked backend obligation; no current Lean witness |
| `DIAG-RY-BRIDGE-001` | Connect the compiled scalar-tier statement to the route predicate `expandedControlledRyUsesCubicAngle`. | `DIAG-RY-BACKEND-WITNESS-001` | conditional bridge compiled as `expandedControlledRyUsesCubicAngle_of_backendBridge`; route predicate still unclosed without the witness |
| `DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001` | State the transparent cleanup witness interface. | `DIAG-EXP-ARITH-001`, fixed-denominator backend representation | proved by `ExpandedArithmeticCleanUncomputeWitness`, `expandedWorkspaceCleanUncomputedTransparent`, and `expandedWorkspaceCleanUncomputedTransparent_of_witness`; not a route certificate |
| `DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001` | Instantiate the transparent cleanup interface for modular add/sub over `Fin (gridSize (3 * n))`. | `DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001`, `fixedDenomCubicArithmeticBackend`, payload capacity | proved by `fixedDenomExpandedArithmeticCleanUncomputeWitness` and `fixedDenomWorkspaceCleanUncomputedTransparent`; not a route certificate |
| `DIAG-RY-WORKSPACE-READONLY-001` | State that the controlled signal rotation reads the payload and preserves system index and arithmetic workspace. | transparent rotation bookkeeping, fixed-denominator cleanup witness | active next dependency; no Lean declaration yet |
| `DIAG-EXP-UNCOMP-001` | Prove clean uncompute: workspace returns to zero and the system index is preserved. | fixed-denominator transparent cleanup witness plus `DIAG-RY-WORKSPACE-READONLY-001` | compiled opaque obligation `expandedWorkspaceCleanUncomputed`; proof open and not assigned directly |
| `DIAG-EXP-BLOCK-001` | Use arithmetic, rotation, and clean uncompute to prove the extracted block satisfies `diagonalCleanBlockContract n block`. | `DIAG-RY-BRIDGE-001`, `DIAG-EXP-UNCOMP-001` | conditional contract compiled; extraction proof open |
| `DIAG-EXP-BRIDGE-001` | From the expanded semantic contract, apply `primitiveOracleCleanBlock_eq_target n block` to obtain target clean-block equality. | `DIAG-EXP-BLOCK-001`, `DIAG-BLOCK-BRIDGE-001` | compiled conditional bridge |

The bridge must not claim that the expanded route is already a unitary
certificate.  It is conditional until unitarity, rotation semantics, arithmetic
correctness, clean uncompute, and extraction are proved or accepted as explicit
contracts.

## Verifier Feedback Route

Lower verifier or implementation work should log typed fields for the route
interface leaf and the blocked arithmetic bridge
without changing the target:

```bash
python3 tools/qbe.py trial-log --task QBE-OP-CUBIC-DIAGONAL-001 \
  --role lower --kind attempt --status blocked \
  --feedback-field leaf=DIAG-ARITH-ROUTE-TRANSPARENT-001 \
  --feedback-field source_correspondence_ok=true \
  --feedback-field finite_arithmetic_ok=true \
  --feedback-field finite_register_ok=true \
  --feedback-field block_entry_ok=null \
  --feedback-field normalizer_ok=true \
  --feedback-field blocked_parent=DIAG-ARITH-BACKEND-BRIDGE-001 \
  --feedback-field workspace_representation_specified=true \
  --feedback-field capacity_lemma_compiled=true \
  --feedback-field amplitude_eq_lemma_compiled=true \
  --feedback-field backend_compute_compiled=true \
  --feedback-field transparent_leaf_closed=true \
  --feedback-field closed_theorem_ok=true \
  --feedback-field error_class=symbolic_bridge_gap \
  --feedback-field next_route="choose a named bridge from the transparent predicate to the opaque route predicate, or refactor the expanded arithmetic contract to use the transparent predicate; keep root and exports blocked"
```

If a finite diagnostic contradicts the diagonal target, use
`error_class=finite_matrix_counterexample` and route back to this obligation
ledger before any Lean proof search continues.

## Middle Contract-Refactor Decision, 2026-06-20 08:57 JST

The transparent arithmetic witness leaf is closed:

```lean
expandedArithmeticComputesCubicAmplitudeTransparent n (3 * n)
```

with witness `fixedDenomCubicArithmeticBackend n` and proof
`fixedDenomCubicArithmeticBackend_computes n`, packaged by
`fixedDenomCubicArithmeticRouteTransparent n`.  This is still not a proof of
the opaque predicate `expandedArithmeticComputesCubicAmplitude n (3 * n)`.

The next active proof obligation is
`DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001`.  It is a QBE-local semantic-glue
refactor, not an external cited theorem and not a change to the user target.
The lower Lean worker should refactor the existing declaration
`expandedAmplitudeOracleCleanBlockContract` so its arithmetic conjunct is

```lean
expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits
```

instead of the opaque route predicate.  This reuses the existing contract name
and avoids duplicating the target matrix, normalizer, register layout, or
clean-block theorem.  The refactor may only move the arithmetic contract
boundary; it must not discharge `expandedControlledRyUsesCubicAngle`,
`expandedWorkspaceCleanUncomputed`, `expandedAmplitudeOracleCleanBlockExtracts`,
unitarity, or export obligations.

Updated obligation row:

| Obligation | Lean declaration or target | Dependency class | Status |
|---|---|---|---|
| Refactor the expanded clean-block contract to consume the transparent arithmetic witness. | `expandedAmplitudeOracleCleanBlockContract`; dependency `expandedArithmeticComputesCubicAmplitudeTransparent`; witness `fixedDenomCubicArithmeticRouteTransparent n` for `workspaceQubits = 3 * n` | QBE-local arithmetic contract refactor | proved 2026-06-20 09:17 JST by changing the arithmetic conjunct to the transparent predicate; `python3 tools/qbe.py check` passed; direct bridge search against `expandedArithmeticBackendBridge (fixedDenomCubicArithmeticBackend n)` remains stale |

After this refactor compiles, the next arithmetic dependency for the expanded
route is no longer `DIAG-ARITH-BACKEND-BRIDGE-001`.  The remaining active
parents are the rotation backend witness, clean uncompute, clean-block
extraction, unitarity/circuit semantics, and the root certificate.  Executable
exports remain blocked until a named Lean certificate closes `DIAG-ROOT-001`.

## Middle Rotation Backend Witness Packet, 2026-06-20 09:41 JST

The arithmetic contract-refactor leaf is closed and retired.  The current
source-correspondence leaf is `DIAG-RY-BACKEND-WITNESS-001`.

The source anchor is the user-provided operator target in
`tasks/QBE-OP-CUBIC-DIAGONAL-001.md`.  The object is
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise, with
`exactNormalizer n = 1`.

The corresponding Lean declarations are:

```lean
StandardRyCleanEntryScalarTier
expandedRyCleanEntryForCubicAmplitudes_of_standardTier
expandedControlledRyUsesCubicAngle
expandedControlledRyBackendBridge
expandedControlledRyUsesCubicAngle_of_backendBridge
expandedControlledRyBackendBridge_iff_of_standardTier
```

The compiled scalar-tier theorem handles the mathematical identity for the
standard `R_y(theta)` convention.  The open proof obligation is the backend
semantics witness:

```lean
hBridge : expandedControlledRyBackendBridge tier n (3 * n)
```

This witness must state that the controlled rotation substep used by the
expanded route implements the same clean-entry convention used by
`expandedRyCleanEntryForCubicAmplitudes_of_standardTier`.  If the current Lean
surface cannot state that witness transparently, lower work should record
`error_class=symbolic_bridge_gap` and keep the route predicate blocked.

Updated obligation rows:

| Obligation | Lean declaration or target | Dependency class | Status |
|---|---|---|---|
| Retire the transparent arithmetic contract refactor. | `expandedAmplitudeOracleCleanBlockContract`; `expandedArithmeticComputesCubicAmplitudeTransparent`; `fixedDenomCubicArithmeticRouteTransparent n` for `workspaceQubits = 3 * n` | QBE-local arithmetic semantic glue | proved and retired; direct opaque arithmetic bridge retry is stale |
| Provide the controlled-`R_y` backend witness, or classify the missing transparent backend semantics. | witness `hBridge : expandedControlledRyBackendBridge tier n (3 * n)`; closure theorem `expandedControlledRyUsesCubicAngle_of_backendBridge`; refiner normal form `expandedControlledRyBackendBridge_iff_of_standardTier` | QBE-local rotation backend semantics | active source-correspondence leaf; refiner normal form compiled 2026-06-20 10:04 JST showing direct bridge search is equivalent to the opaque route predicate; no current unconditional proof of `expandedControlledRyUsesCubicAngle` |
| Keep clean uncompute downstream. | `expandedWorkspaceCleanUncomputed` | QBE-local workspace semantic glue | blocked until the rotation backend witness is classified |
| Keep extraction, unitarity, root certificate, and exports downstream. | `expandedAmplitudeOracleCleanBlockExtracts`, planned expanded certificate, `executable-exports/QBE-OP-CUBIC-DIAGONAL-001/` | QBE-local route and post-Lean export obligations | blocked |

No external cited-result row is needed for this user/operator target.  The next
lower packet must not add a theorem that proves
`expandedControlledRyUsesCubicAngle` by `trivial`, by an axiom, or by setting a
semantic proposition to `True`.

Typed feedback for the next attempt should use:

```text
leaf=DIAG-RY-BACKEND-WITNESS-001
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=true
theta_convention_ok=true
normalizer_ok=true
block_entry_ok=null
unitarity_ok=null
ancilla_cleanup_ok=null
closed_theorem_ok=false
route_predicate_closed=false
error_class=symbolic_bridge_gap
next_route=state a transparent backend-semantics interface for
  expandedControlledRyBackendBridge tier n (3 * n), or record the witness as
  blocked and keep DIAG-EXP-UNCOMP-001 downstream
```

## Lower Refiner Normal Form, 2026-06-20 10:04 JST

The direct route

```lean
hBridge : expandedControlledRyBackendBridge tier n (3 * n)
```

was reduced by the compiled theorem

```lean
expandedControlledRyBackendBridge_iff_of_standardTier
```

For any `tier`, `n`, and `workspaceQubits`, this theorem proves that the
backend-bridge witness is equivalent to the opaque route predicate
`expandedControlledRyUsesCubicAngle n workspaceQubits`, because
`expandedRyCleanEntryForCubicAmplitudes_of_standardTier tier n` already supplies
the scalar-tier premise.  This is only a proof-reduction patch.  It does not
prove `expandedControlledRyUsesCubicAngle`, does not provide a concrete backend
semantics witness, and does not unblock clean uncompute, extraction, unitarity,
`DIAG-ROOT-001`, or executable exports.

## Middle Transparent Rotation Interface Packet, 2026-06-20 10:26 JST

The direct controlled-`R_y` backend witness remains blocked.  The next active
proof obligation is `DIAG-RY-TRANSPARENT-INTERFACE-001`, which records the
scalar angle convention in a transparent predicate analogous to the transparent
arithmetic predicate.  This is QBE-local semantic glue for the user/operator
target, not an external cited-result row.

The proposed Lean declarations are:

```lean
def expandedControlledRyUsesCubicAngleTransparent
    (n workspaceQubits : Nat) : Prop :=
  forall tier : StandardRyCleanEntryScalarTier,
    expandedRyCleanEntryForCubicAmplitudes tier n

theorem fixedDenomControlledRyRouteTransparent
    (n : Nat) :
    expandedControlledRyUsesCubicAngleTransparent n (3 * n)
```

The proof of the theorem should introduce `tier` and apply
`expandedRyCleanEntryForCubicAmplitudes_of_standardTier tier n`.  This closes
only transparent scalar-angle bookkeeping.  It does not prove the opaque
predicate `expandedControlledRyUsesCubicAngle`, does not provide a backend
witness, does not prove clean uncompute, and does not authorize executable
exports.

Updated obligation rows:

| Obligation | Lean declaration or target | Dependency class | Status |
|---|---|---|---|
| Retire direct controlled-`R_y` backend witness search. | normal form `expandedControlledRyBackendBridge_iff_of_standardTier`; stale target `expandedControlledRyBackendBridge tier n (3 * n)` | QBE-local rotation backend semantics | direct search is blocked because it is equivalent to the opaque route predicate |
| Add the transparent rotation-angle interface. | `expandedControlledRyUsesCubicAngleTransparent`; theorem `fixedDenomControlledRyRouteTransparent n` | QBE-local rotation semantic glue | proved 2026-06-20 10:43 JST; `python3 tools/qbe.py check` passed; this does not close the opaque route predicate |
| Decide whether to refactor the expanded clean-block contract for rotation. | possible future edit to `expandedAmplitudeOracleCleanBlockContract` | QBE-local route-contract refactor | next middle decision; do not assign until the contract boundary is explicit |
| Keep clean uncompute downstream. | `expandedWorkspaceCleanUncomputed` | QBE-local workspace semantic glue | blocked |
| Keep extraction, unitarity, root certificate, and exports downstream. | `expandedAmplitudeOracleCleanBlockExtracts`, planned expanded certificate, `executable-exports/QBE-OP-CUBIC-DIAGONAL-001/` | QBE-local route and post-Lean export obligations | blocked |

Typed feedback for the next lower implementation should use:

```text
leaf=DIAG-RY-TRANSPARENT-INTERFACE-001
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=true
theta_convention_ok=true
normalizer_ok=true
block_entry_ok=null
unitarity_ok=null
ancilla_cleanup_ok=null
closed_theorem_ok=false
transparent_rotation_leaf_expected=true
route_predicate_closed=false
error_class=symbolic_bridge_gap
next_route=add expandedControlledRyUsesCubicAngleTransparent and
  fixedDenomControlledRyRouteTransparent; do not refactor the clean-block
  contract or prove the opaque route predicate in this leaf
```

## Middle Rotation Contract-Refactor Decision, 2026-06-20 11:04 JST

The transparent controlled-`R_y` witness leaf is closed:

```lean
expandedControlledRyUsesCubicAngleTransparent n (3 * n)
```

with proof supplied by `fixedDenomControlledRyRouteTransparent n`.  This is
still not a proof of the opaque predicate
`expandedControlledRyUsesCubicAngle n (3 * n)` and not a backend witness for
`expandedControlledRyBackendBridge`.

The next active proof obligation is `DIAG-RY-TRANSPARENT-CONTRACT-001`.  It is
a QBE-local semantic-glue refactor, not an external cited theorem and not a
change to the user target.  The lower Lean worker should refactor the existing
declaration `expandedAmplitudeOracleCleanBlockContract` so its rotation
conjunct is:

```lean
expandedControlledRyUsesCubicAngleTransparent n workspaceQubits
```

instead of the opaque route predicate.  This reuses the existing contract name
and avoids duplicating the target matrix, normalizer, register layout, or
clean-block theorem.  The refactor may only move the rotation contract
boundary; it must not discharge `expandedWorkspaceCleanUncomputed`,
`expandedAmplitudeOracleCleanBlockExtracts`, unitarity, root certificate, or
export obligations.

Updated obligation rows:

| Obligation | Lean declaration or target | Dependency class | Status |
|---|---|---|---|
| Retire the transparent rotation-angle interface. | `expandedControlledRyUsesCubicAngleTransparent`; `fixedDenomControlledRyRouteTransparent n` for `workspaceQubits = 3 * n` | QBE-local rotation semantic glue | proved 2026-06-20 10:43 JST; `python3 tools/qbe.py check` passed; does not close the opaque route predicate |
| Refactor the expanded clean-block contract to consume the transparent rotation witness. | `expandedAmplitudeOracleCleanBlockContract`; dependency `expandedControlledRyUsesCubicAngleTransparent`; witness `fixedDenomControlledRyRouteTransparent n` for `workspaceQubits = 3 * n` | QBE-local rotation contract refactor | active lower leaf `DIAG-RY-TRANSPARENT-CONTRACT-001` |
| Keep the opaque controlled-`R_y` backend witness as a parked alternative. | possible witness `hBridge : expandedControlledRyBackendBridge tier n (3 * n)`; normal form `expandedControlledRyBackendBridge_iff_of_standardTier` | QBE-local rotation backend semantics | parked unless upper rejects the transparent refactor or introduces a real backend semantics bridge; direct proof search remains stale |
| Keep clean uncompute downstream. | `expandedWorkspaceCleanUncomputed` | QBE-local workspace semantic glue | blocked until the rotation contract refactor is compiled |
| Keep extraction, unitarity, root certificate, and exports downstream. | `expandedAmplitudeOracleCleanBlockExtracts`, planned expanded certificate, `executable-exports/QBE-OP-CUBIC-DIAGONAL-001/` | QBE-local route and post-Lean export obligations | blocked |

Typed feedback for the next lower implementation should use:

```text
leaf=DIAG-RY-TRANSPARENT-CONTRACT-001
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=true
theta_convention_ok=true
normalizer_ok=true
block_entry_ok=null
unitarity_ok=null
ancilla_cleanup_ok=null
closed_theorem_ok=false
transparent_rotation_leaf_closed=true
route_predicate_closed=false
contract_refactor_expected=true
error_class=symbolic_bridge_gap
next_route=refactor expandedAmplitudeOracleCleanBlockContract so the rotation
  conjunct uses expandedControlledRyUsesCubicAngleTransparent; do not prove the
  opaque route predicate, and keep clean uncompute, extraction, unitarity,
  root certificate, and exports blocked
```

## Lean Implementation Update, 2026-06-20 11:22 JST

`DIAG-RY-TRANSPARENT-CONTRACT-001` is now closed.  The clean-block contract
uses the transparent rotation predicate:

```lean
expandedControlledRyUsesCubicAngleTransparent n workspaceQubits
```

This is a contract refactor only.  It does not prove
`expandedControlledRyUsesCubicAngle`, does not supply
`expandedControlledRyBackendBridge`, and does not close clean uncompute,
clean-block extraction, unitarity, the root block-encoding certificate, or
post-Lean executable exports.

Updated obligation rows:

| Obligation | Lean declaration or target | Dependency class | Status |
|---|---|---|---|
| Retire the transparent rotation contract refactor. | `expandedAmplitudeOracleCleanBlockContract`; dependency `expandedControlledRyUsesCubicAngleTransparent`; witness `fixedDenomControlledRyRouteTransparent n` for `workspaceQubits = 3 * n` | QBE-local rotation contract refactor | proved 2026-06-20 11:22 JST by changing the rotation conjunct to the transparent predicate; `python3 tools/qbe.py check` passed |
| Keep the opaque controlled-`R_y` backend witness as a parked alternative. | possible witness `hBridge : expandedControlledRyBackendBridge tier n (3 * n)`; normal form `expandedControlledRyBackendBridge_iff_of_standardTier` | QBE-local rotation backend semantics | parked unless upper rejects the transparent refactor or introduces a real backend semantics bridge; direct proof search remains stale |
| Classify and then prove clean uncompute. | target `expandedWorkspaceCleanUncomputed`; possible future transparent clean-uncompute interface if no concrete backend witness exists | QBE-local workspace semantic glue | active next source-correspondence leaf `DIAG-EXP-UNCOMP-001`; lower 1 should write the contract before lower 2 edits Lean |
| Keep extraction, unitarity, root certificate, and exports downstream. | `expandedAmplitudeOracleCleanBlockExtracts`, planned expanded certificate, `executable-exports/QBE-OP-CUBIC-DIAGONAL-001/` | QBE-local route and post-Lean export obligations | blocked |

Typed feedback for the closed refactor should use:

```text
leaf=DIAG-RY-TRANSPARENT-CONTRACT-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
theta_convention_ok=true
normalizer_ok=true
block_entry_ok=null
unitarity_ok=null
ancilla_cleanup_ok=null
closed_leaf_ok=true
closed_theorem_ok=false
route_certificate_ok=false
contract_refactor_ok=true
route_predicate_closed=false
error_class=symbolic_bridge_gap
next_route=write the DIAG-EXP-UNCOMP-001 source contract; do not prove the
  opaque clean-uncompute predicate by trivial, by axiom, or by setting it to
  True; keep extraction, unitarity, root, and exports blocked
```

## Lower Architect Clean-Uncompute Packet, 2026-06-20 11:34 JST

The lower natural-language packet for `DIAG-EXP-UNCOMP-001` is recorded at
`proof-attempts/QBE-OP-CUBIC-DIAGONAL-001-DIAG-EXP-UNCOMP-001-lower-architect-20260620-1134.md`.

The packet classifies `expandedWorkspaceCleanUncomputed` as an opaque parent,
not a direct tactic target.  The implementation-sized subleaf is a transparent
fixed-denominator reversible-cleanup witness:

```text
computeStep(j,w) = (j, (w + j.val^3) mod gridSize (3 * n))
uncomputeStep(j,w) =
  (j, (w + gridSize (3 * n) - j.val^3) mod gridSize (3 * n))
```

The proof uses `fixedDenomCubicPayload_lt_capacity` for payload capacity and
`fixedDenomCubicAmplitude_eq` for the clean-input amplitude projection.  A
route-level cleanup proof still needs a statement that the controlled rotation
reads the arithmetic workspace without modifying it.  Clean-block extraction,
unitarity/circuit semantics, `DIAG-ROOT-001`, and executable exports remain
blocked.

Updated obligation rows:

| Obligation | Lean declaration or target | Dependency class | Status |
|---|---|---|---|
| Classify clean uncompute without trivializing the opaque predicate. | `expandedWorkspaceCleanUncomputed`; proof packet above | QBE-local workspace semantic glue | source-contract packet recorded; direct opaque proof remains blocked |
| Define a reversible fixed-denominator cleanup lift if middle accepts the interface. | proposed transparent witness adjacent to `expandedWorkspaceCleanUncomputed`; modular add/sub helper lemmas | QBE-local workspace semantic glue | renamed to active leaf `DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001` after the interface compiled |
| Record that controlled rotation leaves arithmetic workspace unchanged. | no current declaration | QBE-local rotation/register semantics | blocked internal dependency before route-level cleanup is used |

## Middle Clean-Uncompute Interface Decision, 2026-06-20 11:58 JST

Middle accepts the need for a transparent clean-uncompute interface before any
Lean worker attacks `expandedWorkspaceCleanUncomputed`.  The next lower-facing
leaf is `DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001`, not the opaque parent and
not the root theorem.

The finite feedback alignment is:

- `DIAG-EXP-UNCOMP-001.lower-necessary-20260620-113316.*` checked an xor
  skeleton and finite fixed-denominator payload facts for `n = 1, 2, 3, 4`.
- The lower architect packet proposes modular add/sub cleanup.  That proposal
  remains valid as a Lean route, but the xor finite diagnostic is only generic
  clean-workspace support and must not be cited as evidence for that exact
  modular add/sub interface.

Updated obligation rows:

| Obligation | Lean declaration or target | Dependency class | Status |
|---|---|---|---|
| Add the transparent cleanup interface. | `ExpandedArithmeticCleanUncomputeWitness`; `expandedWorkspaceCleanUncomputedTransparent`; `expandedWorkspaceCleanUncomputedTransparent_of_witness` | QBE-local workspace semantic glue | proved 2026-06-20 12:21 JST; not a route certificate |
| Instantiate the transparent cleanup interface for the fixed-denominator route. | possible future witness of `expandedWorkspaceCleanUncomputedTransparent n (3 * n)` using modular add/sub steps | QBE-local workspace semantic glue | active lower leaf `DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001`; requires Lean proof for the exact add/sub semantics |
| Keep the opaque route cleanup predicate blocked. | `expandedWorkspaceCleanUncomputed n workspaceQubits` | QBE-local route semantics | blocked until a nontrivial bridge or contract refactor is explicitly selected |
| Record rotation workspace-readonly semantics. | no current declaration | QBE-local rotation/register semantics | blocked internal dependency before route-level cleanup can close |
| Keep extraction, unitarity, root certificate, and exports downstream. | `expandedAmplitudeOracleCleanBlockExtracts`, planned expanded certificate, `executable-exports/QBE-OP-CUBIC-DIAGONAL-001/` | QBE-local route and post-Lean export obligations | blocked |

Typed feedback for the next lower implementation should use:

```text
leaf=DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001
blocked_parent=DIAG-EXP-UNCOMP-001
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=true
finite_uncompute_interface_ok=true
finite_xor_diagnostic_reused_for_mod_add_sub=false
normalizer_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
unitarity_ok=null
clean_block_extraction_ok=null
closed_theorem_ok=false
route_certificate_ok=false
error_class=symbolic_bridge_gap
next_route=instantiate the fixed-denominator transparent cleanup witness and
  separately state rotation workspace-readonly semantics; keep the opaque
  predicate, extraction, unitarity, root certificate, and exports blocked
```

## Middle Coordinator Synthesis, 2026-06-20 12:16 JST

The current active proof-DAG leaf is
`DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001`.  This is an interface leaf, not
the fixed-denominator modular add/sub witness and not the route-level cleanup
certificate.

Updated lower split:

| Role | Active work | Not allowed |
|---|---|---|
| lower 1 natural-language architect | Preserve the source map for the user diagonal operator and, if needed, refine the dependency edge from the transparent cleanup interface to the later modular add/sub witness and `DIAG-RY-WORKSPACE-READONLY-001`. | Do not redesign the arithmetic representation, change the target to rank-one state preparation, or attack `DIAG-ROOT-001`. |
| lower 2 Lean worker | Add only `ExpandedArithmeticCleanUncomputeWitness` and `expandedWorkspaceCleanUncomputedTransparent` adjacent to `expandedWorkspaceCleanUncomputed` in `QuantumBlockEncoding/CubicStatePreparation.lean`. | Do not prove `expandedWorkspaceCleanUncomputed`, add axioms, set semantic propositions to `True`, instantiate modular add/sub cleanup, or refactor `expandedAmplitudeOracleCleanBlockContract` in this leaf. |
| lower 3 necessary-condition verifier | Produce a diagnostic aligned with the modular add/sub cleanup route and record `finite_mod_add_sub_cleanup_ok` and `rotation_workspace_readonly_ok`. | Do not reuse the xor diagnostic as evidence for modular add/sub cleanup, and do not create executable exports before a named Lean root certificate. |

Downstream obligations remain unchanged: instantiate the transparent cleanup
interface for the fixed-denominator route, state rotation workspace-readonly
semantics, prove or refactor the route-level cleanup bridge, prove clean-block
extraction and unitarity/circuit semantics, close `DIAG-ROOT-001`, then prepare
post-Lean executable exports.

## Lower Cleanup Interface Close And Middle Refresh, 2026-06-20 12:44 JST

`DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001` is now closed as an interface leaf.
The Lean declarations
`ExpandedArithmeticCleanUncomputeWitness`,
`expandedWorkspaceCleanUncomputedTransparent`, and
`expandedWorkspaceCleanUncomputedTransparent_of_witness` compile.  This does
not prove `expandedWorkspaceCleanUncomputed`, does not instantiate the
fixed-denominator modular add/sub witness, and does not close extraction,
unitarity, `DIAG-ROOT-001`, or executable exports.

The finite modular add/sub diagnostic for `n = 1, 2, 3, 4` checked the intended
compute and uncompute shape:

```text
computeStep(j,w) = (j, (w + j^3) mod 2^(3n))
uncomputeStep(j,w) = (j, (w + 2^(3n) - j^3) mod 2^(3n))
```

It also records finite `rotation_workspace_readonly_ok=true` for an
identity-read model.  That is necessary-condition feedback, not a Lean
route-semantics certificate.  A named Lean statement for workspace-readonly
rotation remains a separate internal dependency.

Updated obligation rows:

| Obligation | Lean declaration or target | Dependency class | Status |
|---|---|---|---|
| Retire the transparent cleanup interface leaf. | `ExpandedArithmeticCleanUncomputeWitness`, `expandedWorkspaceCleanUncomputedTransparent`, `expandedWorkspaceCleanUncomputedTransparent_of_witness` | QBE-local workspace semantic glue | proved as interface only; `python3 tools/qbe.py check` passed 2026-06-20 12:21 JST |
| Instantiate the transparent cleanup interface for the fixed-denominator route. | planned witness of `ExpandedArithmeticCleanUncomputeWitness n (3 * n)` and theorem `expandedWorkspaceCleanUncomputedTransparent n (3 * n)` | QBE-local workspace semantic glue | active lower leaf `DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001`; finite modular add/sub checks pass, Lean witness not present yet |
| State rotation workspace-readonly semantics. | planned declaration for `DIAG-RY-WORKSPACE-READONLY-001` | QBE-local rotation/register semantics | blocked internal dependency; finite identity-read diagnostic exists but no Lean statement exists |
| Keep the opaque route cleanup predicate blocked. | `expandedWorkspaceCleanUncomputed n workspaceQubits` | QBE-local route semantics | blocked until a nontrivial bridge or contract refactor is explicitly selected |
| Keep extraction, unitarity, root certificate, and exports downstream. | `expandedAmplitudeOracleCleanBlockExtracts`, planned expanded certificate, `executable-exports/QBE-OP-CUBIC-DIAGONAL-001/` | QBE-local route and post-Lean export obligations | blocked |

Typed feedback for the next lower implementation should use:

```text
leaf=DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001
blocked_parent=DIAG-EXP-UNCOMP-001
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=true
finite_mod_add_sub_cleanup_ok=true
rotation_workspace_readonly_ok=true
lean_rotation_workspace_readonly_statement_present=false
normalizer_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
unitarity_ok=null
clean_block_extraction_ok=null
closed_theorem_ok=false
route_certificate_ok=false
error_class=symbolic_bridge_gap
next_route=instantiate the fixed-denominator transparent cleanup witness and
  separately state rotation workspace-readonly semantics; keep the opaque
  cleanup predicate, extraction, unitarity, root certificate, and exports
  blocked
```

## Lower Fixed-Denominator Cleanup Witness Close, 2026-06-20 13:07 JST

`DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001` is closed as a transparent witness
leaf.  The Lean declarations
`fixedDenomCubicComputeStep`, `fixedDenomCubicUncomputeStep`,
`fixedDenomCubicComputeStep_matches_backend_on_clean`,
`fixedDenomCubicUncomputeStep_after_compute`,
`fixedDenomExpandedArithmeticCleanUncomputeWitness`, and
`fixedDenomWorkspaceCleanUncomputedTransparent` compile in
`QuantumBlockEncoding/CubicStatePreparation.lean`.

The witness uses modular add/sub cleanup over the fixed-denominator workspace
`Fin (gridSize (3 * n))`:

```text
computeStep(j,w) = (j, (w + j.val ^ 3) mod gridSize (3 * n))
uncomputeStep(j,w) =
  (j, (w + gridSize (3 * n) - j.val ^ 3) mod gridSize (3 * n))
```

It proves that the compute step agrees with
`fixedDenomCubicArithmeticBackend n` on clean workspace and that uncompute
after compute returns every workspace value to its input.  This still does not
prove the opaque predicate `expandedWorkspaceCleanUncomputed`, because the
route-level statement also needs controlled-rotation workspace-readonly
semantics or an explicit contract refactor.

Updated obligation rows:

| Obligation | Lean declaration or target | Dependency class | Status |
|---|---|---|---|
| Retire the fixed-denominator transparent cleanup witness. | `fixedDenomExpandedArithmeticCleanUncomputeWitness`; `fixedDenomWorkspaceCleanUncomputedTransparent` | QBE-local workspace semantic glue | proved 2026-06-20 13:07 JST; `python3 tools/qbe.py check` passed |
| State rotation workspace-readonly semantics. | planned declaration for `DIAG-RY-WORKSPACE-READONLY-001` | QBE-local rotation/register semantics | active next dependency; finite identity-read diagnostic exists but no Lean statement exists |
| Keep the opaque route cleanup predicate blocked. | `expandedWorkspaceCleanUncomputed n workspaceQubits` | QBE-local route semantics | blocked until a nontrivial bridge or contract refactor is explicitly selected |
| Keep extraction, unitarity, root certificate, and exports downstream. | `expandedAmplitudeOracleCleanBlockExtracts`, planned expanded certificate, `executable-exports/QBE-OP-CUBIC-DIAGONAL-001/` | QBE-local route and post-Lean export obligations | blocked |

Typed feedback for the next lower implementation should use:

```text
leaf=DIAG-RY-WORKSPACE-READONLY-001
blocked_parent=DIAG-EXP-UNCOMP-001
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_rotation_workspace_readonly_ok=true
lean_rotation_workspace_readonly_statement_present=false
available_cleanup_witness=fixedDenomWorkspaceCleanUncomputedTransparent
block_entry_ok=null
ancilla_cleanup_ok=null
unitarity_ok=null
clean_block_extraction_ok=null
closed_theorem_ok=false
route_certificate_ok=false
error_class=symbolic_bridge_gap
next_route=state controlled-rotation workspace-readonly semantics; do not
  prove the opaque cleanup predicate, extraction, unitarity, root certificate,
  or exports
```

## Middle Rotation Workspace-Readonly Packet, 2026-06-20 15:40 JST

`DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001` is retired as closed transparent
cleanup memory.  The next proof obligation is `DIAG-RY-WORKSPACE-READONLY-001`.

The source anchor is the user-provided diagonal operator in
`tasks/QBE-OP-CUBIC-DIAGONAL-001.md`; no paper source or cited theorem is
active.  The translated object remains
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise, with
`exactNormalizer n = 1`.

The next lower Lean worker should state a transparent readonly-rotation
interface, not prove the opaque cleanup route.  The interface should record:

- an arithmetic backend for the chosen workspace size;
- the existing transparent angle convention
  `expandedControlledRyUsesCubicAngleTransparent n workspaceQubits`;
- a controlled-rotation step on system index, arithmetic workspace, and signal
  register;
- proofs that this step preserves the system index and arithmetic workspace.

The intended Lean names are:

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

Updated obligation rows:

| Obligation | Lean declaration or target | Dependency class | Status |
|---|---|---|---|
| Retire the fixed-denominator transparent cleanup witness. | `fixedDenomExpandedArithmeticCleanUncomputeWitness`; `fixedDenomWorkspaceCleanUncomputedTransparent` | QBE-local workspace semantic glue | proved 2026-06-20 13:07 JST; `python3 tools/qbe.py check` passed |
| State rotation workspace-readonly semantics. | planned `ExpandedControlledRyWorkspaceReadonlyWitness`; planned `expandedControlledRyWorkspaceReadonlyTransparent` | QBE-local rotation/register semantic glue | active next dependency; finite identity-read diagnostic exists but no Lean statement exists |
| Keep the opaque route cleanup predicate blocked. | `expandedWorkspaceCleanUncomputed n workspaceQubits` | QBE-local route semantics | blocked until a nontrivial bridge or contract refactor is explicitly selected |
| Keep extraction, unitarity, root certificate, and exports downstream. | `expandedAmplitudeOracleCleanBlockExtracts`, planned expanded certificate, `executable-exports/QBE-OP-CUBIC-DIAGONAL-001/` | QBE-local route and post-Lean export obligations | blocked |

Typed feedback for the next lower implementation should use:

```text
leaf=DIAG-RY-WORKSPACE-READONLY-001
blocked_parent=DIAG-EXP-UNCOMP-001
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_rotation_workspace_readonly_ok=true
lean_rotation_workspace_readonly_statement_present=false
available_cleanup_witness=fixedDenomWorkspaceCleanUncomputedTransparent
block_entry_ok=null
ancilla_cleanup_ok=null
unitarity_ok=null
clean_block_extraction_ok=null
closed_theorem_ok=false
route_certificate_ok=false
error_class=symbolic_bridge_gap
next_route=state the transparent controlled-rotation workspace-readonly
  interface; do not prove the opaque cleanup predicate, extraction, unitarity,
  root certificate, or exports
```
