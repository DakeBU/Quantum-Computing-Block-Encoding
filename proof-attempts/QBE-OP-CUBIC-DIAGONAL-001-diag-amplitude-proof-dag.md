# QBE-OP-CUBIC-DIAGONAL-001 Diagonal Amplitude Oracle Proof DAG

Updated: 2026-06-20 03:11 JST

Role: lower natural-language proof architect.

Status: `DIAG-BLOCK-BRIDGE-001` and `DIAG-PRIM-UNITARY-001` are no
longer active Lean leaves.  The compiled surface now names the primitive
oracle-label unitary, the unitarity predicate, the clean-block extraction
predicate, and the conditional bridge from that contract to the target.  The
exact standard `Rat` one-signal/no-workspace witness subroute for
`DIAG-PRIM-WITNESS-001` is rejected by verifier feedback.  The expanded route
interface is now compiled.  The scalar-tier portion of `DIAG-EXP-RY-001` and
the conditional bridge for `DIAG-RY-BRIDGE-001` are compiled.  No concrete
`DIAG-RY-BACKEND-WITNESS-001` witness is present in the current Lean surface, so
the bridge remains an open backend obligation.  `DIAG-EXP-ARITH-001` now has a
compiled conditional arithmetic backend bridge:
`ExpandedCubicArithmeticBackend`,
`expandedArithmeticBackendComputesCubicAmplitude`,
`expandedArithmeticBackendBridge`, and
`expandedArithmeticComputesCubicAmplitude_of_backendBridge`.  The symbolic
compute-phase backend `symbolicExpandedCubicArithmeticBackend` and its
pointwise proof `symbolicExpandedCubicArithmeticBackend_computes` are compiled.
The parent predicate remains opaque until a backend-to-route bridge is
supplied.  The active child leaf is now the bridge subgoal
`DIAG-ARITH-BACKEND-BRIDGE-001`.

## Source Fragment

There is no paper archive for this task.  The translated source fragment is
the user-provided operator request:

$$
O = \sum_{j=0}^{2^n-1} f(x_j)|j\rangle\langle j|,
\qquad
f(x) = x^3,
\qquad
x_j = j/2^n.
$$

Equivalently, with $N = 2^n$,

$$
D_n[row,col] =
\begin{cases}
(row/N)^3, & row = col,\\
0, & row \ne col.
\end{cases}
$$

The Lean source of truth for this fragment is
`CubicDiagonalOracle.cubicDiagonalOperator n`, and the exact normalizer is
`CubicDiagonalOracle.exactNormalizer n = 1`.

## Definitions

For a fixed `n : Nat`, `gridSize n` is the dimension of the system register.
For `j : Fin (gridSize n)`, the grid point is
`CubicStatePreparation.gridPoint n j`, and the cubic amplitude is
`CubicStatePreparation.cubicAmplitude n j`.

The target matrix is represented by:

```lean
CubicDiagonalOracle.cubicDiagonalOperator n row col =
  if row = col then CubicStatePreparation.cubicAmplitude n row else 0
```

The clean-block predicate for an oracle-supplied block is:

```lean
CubicDiagonalOracle.diagonalCleanBlockContract n block :=
  forall row col,
    block row col =
      if row = col then CubicStatePreparation.cubicAmplitude n row else 0
```

The primitive oracle-label semantic contract is:

```lean
CubicDiagonalOracle.primitiveAmplitudeOracleSemanticContract n :=
  CubicDiagonalOracle.primitiveAmplitudeOracleIsUnitary n
    (CubicDiagonalOracle.primitiveAmplitudeOracleUnitary n) ∧
  ∃ block,
    CubicDiagonalOracle.primitiveAmplitudeOracleCleanBlockExtracts n
      (CubicDiagonalOracle.primitiveAmplitudeOracleUnitary n) block ∧
    CubicDiagonalOracle.diagonalCleanBlockContract n block
```

The predicates
`primitiveAmplitudeOracleIsUnitary` and
`primitiveAmplitudeOracleCleanBlockExtracts` are opaque obligations.  They are
not definitions that can be unfolded into a proof script in the current Lean
surface.

## Parked Primitive Contract Design

The primitive local theorem is not a ready internal Lean theorem.  It is the
witness obligation:

```lean
h : CubicDiagonalOracle.primitiveAmplitudeOracleSemanticContract n
```

To prove this witness directly, a Lean worker would need two terms:

1. A proof that the named primitive matrix is unitary:
   `primitiveAmplitudeOracleIsUnitary n (primitiveAmplitudeOracleUnitary n)`.
2. A block `block : Matrix (gridSize n) (gridSize n) Rat` with proofs that
   the primitive matrix extracts that block and that the block satisfies
   `diagonalCleanBlockContract n block`.

Once such an `h` exists, the rest of the primitive route is already compiled.
The theorem
`primitiveAmplitudeOracleSemanticContract_cleanBlock_eq_target n h` extracts a
block whose entries equal the target operator, by applying
`primitiveOracleCleanBlock_eq_target` to the clean-block component of `h`.
The definition `primitiveAmplitudeOracleVerified n h` then packages the
candidate as a verified primitive-tier operator block encoding.

The natural-language proof from `h` is:

Fix `n` and assume
`h : primitiveAmplitudeOracleSemanticContract n`.  The first component of `h`
is exactly the unitarity predicate for the named primitive oracle-label matrix.
The second component gives an extracted block and two facts about it.  The
first fact says the primitive matrix extracts that block in the clean signal
subspace.  The second fact says every matrix entry of the extracted block is
the diagonal cubic entry when row and column agree and zero otherwise.  The
compiled theorem `primitiveOracleCleanBlock_eq_target` turns this entrywise
contract into `Matrix.PointwiseEq block (cubicDiagonalTarget n).operator`.
Therefore the primitive candidate is verified once the semantic contract
witness is supplied.

This is a conditional proof design.  It does not prove `h` from the current
opaque predicates.  It is parked for this cycle unless upper or the user
explicitly accepts the primitive oracle-label tier.

## Active Expanded Route Contract Design

The active local theorem design is a route-interface target, not a completed
unitary proof.  A concurrent Lean pass has now introduced the expanded-route
interface inside `namespace CubicDiagonalOracle`; the remaining work is to
prove or explicitly accept the semantic obligations named by that interface.

For fixed `n`, the route contract must name:

1. the `n`-qubit system index register;
2. one signal qubit whose clean projection supplies the diagonal entry;
3. arithmetic workspace large enough for the route, with a clean-uncompute
   obligation;
4. the computed amplitude $a_j = (j/2^n)^3$;
5. a controlled standard `R_y(theta_j)` convention with
   `theta_j = 2 arccos(a_j)`;
6. a clean-block extraction predicate that implies
   `CubicDiagonalOracle.diagonalCleanBlockContract n block`.

### Expanded Interface Contract

The source anchor for the expanded route is still only the user prompt:

$$
D_n = \sum_{j=0}^{2^n-1} (j/2^n)^3 |j\rangle\langle j|.
$$

No paper equation, citation, or external construction is being translated.
The expanded route is QBE-local semantic glue for the same operator target.

For fixed `n : Nat`, the Lean-facing interface should use the following
register layout.

| Register | Basis state | Role | Clean condition |
|---|---|---|---|
| system | `j : Fin (gridSize n)` | Stores the input/output index of the diagonal operator. | The expanded circuit must preserve `j`; no permutation of system indices is allowed. |
| signal | `b : Bool` or one qubit | The clean block is the `signal = 0` to `signal = 0` matrix element. | The clean projection uses input and output signal state `0`. |
| arithmetic workspace | a route-chosen tuple of work registers | Reversibly stores the numerator/denominator or fixed-point/real data needed to compute $a_j = (j/2^n)^3$ and the angle token $\theta_j$. | All workspace registers begin and end in the all-zero state. |
| scratch inside arithmetic | route-local temporary registers | May hold products such as $j^2$, $j^3$, denominator powers, comparisons, or angle-preparation data. | Scratch is part of the workspace and must be uncomputed before clean-block extraction. |

The arithmetic contract should state the reversible computation and
uncomputation as two separate obligations:

1. `expandedArithmeticComputesCubic`: for each system index `j`, the compute
   phase maps the clean workspace to data representing
   $a_j = (j/2^n)^3$, equivalently
   `CubicStatePreparation.cubicAmplitude n j`.  The compiled Lean shape is
   `ExpandedCubicArithmeticBackend`, with pointwise semantics
   `expandedArithmeticBackendComputesCubicAmplitude` and conditional bridge
   `expandedArithmeticComputesCubicAmplitude_of_backendBridge`.
2. `expandedArithmeticUncomputesClean`: after the controlled rotation has used
   the amplitude or angle data, the inverse arithmetic restores every
   workspace register to zero and leaves the system index unchanged.

The standard rotation convention must be recorded before any theorem uses it.
Use

$$
R_y(\theta) =
\begin{pmatrix}
\cos(\theta/2) & -\sin(\theta/2) \\
\sin(\theta/2) & \cos(\theta/2)
\end{pmatrix}.
$$

With this convention, the clean signal entry is
$\langle 0|R_y(\theta)|0\rangle = \cos(\theta/2)$.  Since the compiled range
lemmas give $0 \le a_j \le 1$, the selected angle is

$$
\theta_j = 2 \arccos(a_j),
\qquad
a_j = (j/2^n)^3.
$$

The rotation proof obligation is therefore:

```text
expandedRyCleanEntry:
  cos((2 * arccos(a_j)) / 2) = a_j
```

for every grid index `j`, using the interval condition from
`cubicAmplitude_nonneg` and `cubicAmplitude_le_one`.  This obligation lives in
a Real/Complex rotation semantics tier, not in the current exact `Rat` matrix
surface.  The project-local scalar-tier interface is now compiled as
`StandardRyCleanEntryScalarTier`, and the cubic range specialization is
compiled as `expandedRyCleanEntryForCubicAmplitudes_of_standardTier`.  This
does not prove `expandedControlledRyUsesCubicAngle`; it names the backend
bridge that remains to be supplied.

The clean-block extraction predicate is shaped so that the bridge to the
existing diagonal contract is immediate.  The current Lean surface uses these
compiled names:

```lean
def expandedAmplitudeOracleCleanBlockContract
    (n workspaceQubits : Nat)
    (block : Matrix (gridSize n) (gridSize n) Rat) : Prop :=
  expandedArithmeticComputesCubicAmplitude n workspaceQubits ∧
  expandedControlledRyUsesCubicAngle n workspaceQubits ∧
  expandedWorkspaceCleanUncomputed n workspaceQubits ∧
  expandedAmplitudeOracleCleanBlockExtracts n workspaceQubits block ∧
  diagonalCleanBlockContract n block

def expandedAmplitudeOracleSemanticContract
    (n workspaceQubits : Nat) : Prop :=
  ∃ block : Matrix (gridSize n) (gridSize n) Rat,
    expandedAmplitudeOracleCleanBlockContract n workspaceQubits block
```

The bridge theorem should not inspect arithmetic internals.  It should only
destructure the expanded semantic contract, retrieve
`diagonalCleanBlockContract n block`, and apply the existing theorem
`CubicDiagonalOracle.primitiveOracleCleanBlock_eq_target`.

The compiled conditional bridge has this Lean-facing shape:

```lean
theorem expandedAmplitudeOracleSemanticContract_cleanBlock_eq_target
    (n workspaceQubits : Nat)
    (h : expandedAmplitudeOracleSemanticContract n workspaceQubits) :
    exists block : Matrix (gridSize n) (gridSize n) Rat,
      expandedAmplitudeOracleCleanBlockExtracts n workspaceQubits block ∧
      Matrix.PointwiseEq block (CubicDiagonalOracle.cubicDiagonalTarget n).operator := ...
```

The proof of the conditional bridge should reuse
`CubicDiagonalOracle.primitiveOracleCleanBlock_eq_target` after the expanded
contract supplies `diagonalCleanBlockContract n block`.  If the scalar tier for
`arccos` and `R_y` cannot remain `Rat`, the interface must state the scalar
conversion or record a technical-lemma obligation before later proof work.

### Natural-Language Proof Of The Local Bridge

Fix `n : Nat` and assume the planned expanded semantic contract for `n`.  By
definition of that contract, there is a matrix
`block : Matrix (gridSize n) (gridSize n) Rat` extracted from the clean signal
and clean workspace projection of the expanded unitary.  The same contract
contains a proof that this `block` satisfies
`diagonalCleanBlockContract n block`.

The predicate `diagonalCleanBlockContract n block` states that for all
`row col : Fin (gridSize n)`, the entry of `block` is
`CubicStatePreparation.cubicAmplitude n row` when `row = col`, and `0`
otherwise.  The theorem
`CubicDiagonalOracle.primitiveOracleCleanBlock_eq_target` already turns this
entrywise contract into
`Matrix.PointwiseEq block (CubicDiagonalOracle.cubicDiagonalTarget n).operator`.
Therefore the expanded semantic contract implies the target clean-block
equality.

The arithmetic, uncompute, and rotation obligations are not consumed by this
bridge except through the supplied `diagonalCleanBlockContract` component.  A
later proof must use them to justify that the expanded clean-block extraction
really supplies that component.

### Expanded Sub-DAG

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-EXP-REG-001` | Define the expanded layout: system index register, one signal qubit, and route-chosen arithmetic workspace. | `DIAG-TGT-001` | concurrent Lean worker | `expandedAmplitudeOracleLayout`, `expandedAmplitudeOracleLayout_auxiliaryQubits`, `expandedAmplitudeOracleNormalizer_eq` | this section | `python3 tools/qbe.py check` | compiled |
| `DIAG-EXP-ARITH-001` | State that reversible arithmetic computes $a_j = (j/2^n)^3$ as `CubicStatePreparation.cubicAmplitude n j`. | `DIAG-RANGE-001`, `DIAG-EXP-REG-001` | lower Lean worker | `expandedArithmeticComputesCubicAmplitude`, `expandedArithmeticComputesCubicAmplitude_of_backendBridge` | this section and `DIAG-EXP-ARITH-BACKEND-001 Proof Design` | `python3 tools/qbe.py check` | parent leaf; conditional backend bridge compiled |
| `DIAG-EXP-ARITH-BACKEND-001` | Instantiate the compute-phase backend and prove it preserves `j` and writes `CubicStatePreparation.cubicAmplitude n j`. | `DIAG-EXP-ARITH-001`, `DIAG-ARITH-VALUE-001` | lower Lean worker | `ExpandedCubicArithmeticBackend`, `symbolicExpandedCubicArithmeticBackend`, `symbolicExpandedCubicArithmeticBackend_computes` | `DIAG-EXP-ARITH-BACKEND-001 Proof Design` | `python3 tools/qbe.py check` | symbolic compute portion compiled |
| `DIAG-ARITH-BACKEND-BRIDGE-001` | Supply the backend-to-route bridge for the selected arithmetic backend, or record the missing concrete workspace/backend representation as the blocker. | `DIAG-EXP-ARITH-BACKEND-001`, concrete backend semantics | next Lean worker | required witness of `expandedArithmeticBackendBridge`; closure theorem `expandedArithmeticComputesCubicAmplitude_of_backendBridge` | `DIAG-EXP-ARITH-BACKEND-001 Proof Design` | `python3 tools/qbe.py check` | active leaf |
| `DIAG-EXP-RY-001` | State the standard `R_y(theta)` convention and the identity for `theta_j = 2 arccos(a_j)`. | `DIAG-RANGE-001`, `DIAG-EXP-ARITH-001` | lower Lean worker | `StandardRyCleanEntryScalarTier`, `expandedRyCleanEntryForCubicAmplitudes_of_standardTier`; backend target `expandedControlledRyUsesCubicAngle` | this section | `python3 tools/qbe.py check` plus scalar-tier check | scalar-tier range bridge compiled; backend bridge open |
| `DIAG-EXP-UNCOMP-001` | State that arithmetic is cleanly uncomputed after the rotation: workspace returns to zero and system index is preserved. | `DIAG-EXP-ARITH-001`, `DIAG-RY-BRIDGE-001` | future Lean worker | `expandedWorkspaceCleanUncomputed` | this section | `python3 tools/qbe.py check` | compiled obligation; proof open |
| `DIAG-EXP-BLOCK-001` | Extract the clean block and prove it satisfies `diagonalCleanBlockContract n block`. | `DIAG-RY-BRIDGE-001`, `DIAG-EXP-UNCOMP-001` | future Lean worker | `expandedAmplitudeOracleCleanBlockExtracts`, `expandedAmplitudeOracleCleanBlockContract`, `expandedAmplitudeOracleCleanBlockContract_diagonal` | this section | `python3 tools/qbe.py check` | conditional interface compiled; extraction proof open |
| `DIAG-EXP-BRIDGE-001` | From the expanded semantic contract, return a block pointwise equal to `(cubicDiagonalTarget n).operator`. | `DIAG-EXP-BLOCK-001`, `DIAG-BLOCK-BRIDGE-001` | concurrent Lean worker | `expandedAmplitudeOracleCleanBlockContract_eq_target`, `expandedAmplitudeOracleSemanticContract_cleanBlock_eq_target` | Natural-Language Proof Of The Local Bridge | `python3 tools/qbe.py check` | compiled conditional bridge |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-TGT-001` | Define the diagonal cubic target matrix. | none | existing Lean | `cubicDiagonalOperator`, `cubicDiagonalTarget` | `conversion-windows/QBE-OP-CUBIC-DIAGONAL-001.md` | `python3 tools/qbe.py check` | proved |
| `DIAG-RANGE-001` | Prove $0 \le (j/2^n)^3 \le 1$ for every grid index. | `gridPoint_nonneg`, `gridPoint_le_one`, `rat_pow_le_one_of_nonneg_le_one` | existing Lean | `cubicAmplitude_nonneg`, `cubicAmplitude_le_one` | proof-obligation ledger | `python3 tools/qbe.py check` | proved |
| `DIAG-RESOURCE-001` | Record primitive oracle-label score `(1, 1, 1, 1)`. | `amplitudeOracleLayout`, `amplitudeOracleCircuit`, `Circuit.resource` | existing Lean | `amplitudeOracleResourceTuple_eq` | candidate-population ledger | `python3 tools/qbe.py check` | proved |
| `DIAG-BLOCK-BRIDGE-001` | Any clean block satisfying the diagonal contract equals the target operator. | `DIAG-TGT-001`, `diagonalCleanBlockContract_pointwise_eq` | lower Lean worker | `primitiveOracleCleanBlock_eq_target` | this file, closed bridge note | `python3 tools/qbe.py check` | proved |
| `DIAG-PRIM-UNITARY-001` | Name the primitive oracle-label matrix, unitarity predicate, extraction predicate, and conditional clean-block theorem. | `DIAG-RANGE-001`, `DIAG-BLOCK-BRIDGE-001` | middle Lean update | `primitiveAmplitudeOracleUnitary`, `primitiveAmplitudeOracleIsUnitary`, `primitiveAmplitudeOracleCleanBlockExtracts`, `primitiveAmplitudeOracleSemanticContract`, `primitiveAmplitudeOracleSemanticContract_cleanBlock_eq_target` | conversion window | `python3 tools/qbe.py check` | compiled conditional bridge |
| `DIAG-PRIM-WITNESS-001` | Supply or explicitly accept `h : primitiveAmplitudeOracleSemanticContract n`, excluding the rejected standard exact `Rat` one-signal/no-workspace completion. | `DIAG-PRIM-UNITARY-001`, source or project acceptance of primitive oracle tier | upper/user decision only | target proof of `primitiveAmplitudeOracleSemanticContract n` | this file, Parked Primitive Contract Design | `python3 tools/qbe.py check` | parked; external contract gap |
| `DIAG-EXPANDED-CONTRACT-001` | State the expanded reversible-arithmetic plus controlled-rotation route contract and its conditional clean-block bridge. | `DIAG-RANGE-001`, `DIAG-BLOCK-BRIDGE-001`, rejected rational primitive subroute | lower architect and concurrent Lean worker | `expandedAmplitudeOracleCleanBlockContract`, `expandedAmplitudeOracleSemanticContract_cleanBlock_eq_target` | this file, Active Expanded Route Contract Design and Expanded Sub-DAG | `python3 tools/qbe.py check` | compiled conditional interface; semantic obligations open |
| `DIAG-EXP-ARITH-BACKEND-001` | Provide the arithmetic compute backend witness: preserve `j` and write `CubicStatePreparation.cubicAmplitude n j`. | `DIAG-EXP-ARITH-001`, `DIAG-ARITH-VALUE-001` | lower Lean worker | `symbolicExpandedCubicArithmeticBackend`, `symbolicExpandedCubicArithmeticBackend_computes` | `DIAG-EXP-ARITH-BACKEND-001 Proof Design` | `python3 tools/qbe.py check` | symbolic compute portion compiled |
| `DIAG-ARITH-BACKEND-BRIDGE-001` | Provide the bridge from the selected arithmetic backend semantics to the opaque route predicate, or record the missing concrete backend representation. | `DIAG-EXP-ARITH-BACKEND-001`, route backend semantics | next Lean worker | required witness of `expandedArithmeticBackendBridge`; theorem `expandedArithmeticComputesCubicAmplitude_of_backendBridge` | `DIAG-EXP-ARITH-BACKEND-001 Proof Design` | `python3 tools/qbe.py check` | active leaf |
| `DIAG-ROOT-001` | Package an exact operator block-encoding certificate for the selected route. | `DIAG-RESOURCE-001` plus either `DIAG-PRIM-WITNESS-001` or the expanded route certificate | future Lean worker | `primitiveAmplitudeOracleVerified n h` for the primitive path, or planned expanded certificate | proof-obligation ledger | `python3 tools/qbe.py check` | blocked until a route certificate exists |
| `DIAG-EXPORT-001` | Export Qiskit, QuantumKatas-style, and QASM3 artifacts tied to a named Lean certificate. | `DIAG-ROOT-001` | future verifier/export worker | planned export packet | candidate-population ledger | Lean gate plus export checks | blocked downstream |

Next active leaf for a Lean worker:
`DIAG-ARITH-BACKEND-BRIDGE-001`.  The parent arithmetic predicate has only a
conditional bridge, so a Lean worker should not attack
`expandedArithmeticComputesCubicAmplitude n workspaceQubits` directly.  The
scalar-tier range specialization for `DIAG-EXP-RY-001` is compiled, and the
conditional `DIAG-RY-BRIDGE-001` theorem is compiled, but the concrete rotation
backend witness is still an open obligation.  `DIAG-EXP-UNCOMP-001` is a later
leaf, and `DIAG-PRIM-WITNESS-001` should be assigned only if the primitive
oracle-label tier is explicitly accepted as a contract.

## DIAG-EXP-RY-001 Proof Design

The exact source fragment for this retired scalar-tier leaf is the diagonal
entry equation from the user target:

$$
D_n[j,j] = (j/2^n)^3.
$$

Define $a_j = (j/2^n)^3$, represented in Lean by
`CubicStatePreparation.cubicAmplitude n j`.  The compiled range lemmas
`CubicDiagonalOracle.cubicAmplitude_nonneg` and
`CubicDiagonalOracle.cubicAmplitude_le_one` give
$0 \le a_j \le 1$ for each grid index.

Define the standard signal rotation convention before using it:

$$
R_y(\theta) =
\begin{pmatrix}
\cos(\theta/2) & -\sin(\theta/2) \\
\sin(\theta/2) & \cos(\theta/2)
\end{pmatrix}.
$$

The route chooses $\theta_j = 2\arccos(a_j)$.  The local scalar theorem needed
by the expanded route is:

$$
\langle 0|R_y(2\arccos(a_j))|0\rangle
= \cos((2\arccos(a_j))/2)
= a_j.
$$

Natural-language proof: fix `n` and `j : Fin (gridSize n)`.  Let
$a_j = \texttt{cubicAmplitude n j}$.  The compiled range lemmas place $a_j$ in
the domain of the standard inverse-cosine identity.  In a scalar tier with
`arccos` and `cos`, the algebraic half-angle step rewrites
$(2\arccos(a_j))/2$ to $\arccos(a_j)$.  The inverse-cosine identity on
$[0,1]$ then gives $\cos(\arccos(a_j)) = a_j$.  Therefore the clean
signal-entry of the selected standard `R_y` block is exactly the desired
diagonal entry.  This proof uses only the scalar rotation convention and the
range bounds; it does not prove reversible arithmetic, clean uncompute, or
full clean-block extraction.

The current Lean file imports only the project-local `Std`-based stack and
stores matrices over `Rat`.  It does not expose a concrete `Real`/`Complex`
backend with `cos` and `arccos`, but it now has an abstract project-local
scalar-tier interface.  The compiled local interface is:

```lean
structure StandardRyCleanEntryScalarTier where
  Scalar : Type
  ratAmplitude : Rat -> Scalar
  thetaForAmplitude : Scalar -> Scalar
  cleanEntry : Scalar -> Scalar
  cleanEntry_of_range :
    forall a : Rat, 0 <= a -> a <= 1 ->
      cleanEntry (thetaForAmplitude (ratAmplitude a)) = ratAmplitude a
```

and the compiled range specialization is:

```lean
theorem expandedRyCleanEntryForCubicAmplitudes_of_standardTier
    (tier : StandardRyCleanEntryScalarTier) (n : Nat) :
    expandedRyCleanEntryForCubicAmplitudes tier n
```

Therefore the next Lean worker should not claim
`expandedControlledRyUsesCubicAngle n workspaceQubits` by unfolding or by
`trivial`.  The compiled conditional bridge is now:

```lean
def expandedControlledRyBackendBridge
    (tier : StandardRyCleanEntryScalarTier)
    (n workspaceQubits : Nat) : Prop :=
  expandedRyCleanEntryForCubicAmplitudes tier n ->
    expandedControlledRyUsesCubicAngle n workspaceQubits

theorem expandedControlledRyUsesCubicAngle_of_backendBridge
    (tier : StandardRyCleanEntryScalarTier)
    (n workspaceQubits : Nat)
    (hBridge : expandedControlledRyBackendBridge tier n workspaceQubits) :
    expandedControlledRyUsesCubicAngle n workspaceQubits
```

The remaining honest implementation route is one of:

1. supply an accepted backend witness for `StandardRyCleanEntryScalarTier`,
   plus a concrete witness of `expandedControlledRyBackendBridge`; or
2. keep `expandedControlledRyUsesCubicAngle` as an explicit technical
   obligation and mark `DIAG-RY-BRIDGE-001` blocked on the backend bridge.

Lean-facing lemmas for this leaf, ordered by dependency:

1. Reuse `CubicDiagonalOracle.cubicAmplitude_nonneg n j` and
   `CubicDiagonalOracle.cubicAmplitude_le_one n j` to obtain the scalar range
   side conditions for $a_j$.
2. Reuse `StandardRyCleanEntryScalarTier.cleanEntry_of_range`, which packages
   the clean-entry identity for every rational amplitude in `[0,1]`.
3. Reuse `expandedRyCleanEntryForCubicAmplitudes_of_standardTier`, which
   specializes the scalar-tier clean-entry contract to all cubic grid
   amplitudes.
4. Apply `expandedControlledRyUsesCubicAngle_of_backendBridge` only after a
   concrete backend supplies `expandedControlledRyBackendBridge`.  If that
   predicate remains opaque, the bridge witness is an obligation, not a theorem
   to close by automation.
5. Leave `expandedArithmeticComputesCubicAmplitude`,
   `expandedWorkspaceCleanUncomputed`, and
   `expandedAmplitudeOracleCleanBlockExtracts` for their own leaves.

### DIAG-EXP-RY-001 DAG

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-RY-RANGE-001` | For each `j`, prove $0 \le a_j \le 1$ for $a_j=(j/2^n)^3$. | `DIAG-RANGE-001` | existing Lean | `cubicAmplitude_nonneg`, `cubicAmplitude_le_one` | this section | `python3 tools/qbe.py check` | proved |
| `DIAG-RY-SCALAR-001` | Prove the scalar identity $\cos((2\arccos a)/2)=a$ for $0 \le a \le 1$ under the selected `R_y` convention. | `DIAG-RY-RANGE-001`; scalar tier with `cos` and `arccos` | lower Lean worker | `StandardRyCleanEntryScalarTier`; `expandedRyCleanEntryForCubicAmplitudes_of_standardTier` | this section | `python3 tools/qbe.py check` plus scalar-tier import check | compiled project-local interface and range specialization |
| `DIAG-RY-BRIDGE-001` | Connect the scalar clean-entry lemma for each `j` to the expanded-route predicate. | `DIAG-RY-SCALAR-001`, `DIAG-EXPANDED-CONTRACT-001` | lower Lean worker | `expandedControlledRyBackendBridge`, `expandedControlledRyUsesCubicAngle_of_backendBridge`; route target `expandedControlledRyUsesCubicAngle` | this section | `python3 tools/qbe.py check` | conditional bridge compiled; concrete backend witness still open |
| `DIAG-EXP-BLOCK-001` | Use arithmetic, rotation, uncompute, and extraction to supply `diagonalCleanBlockContract n block`. | `DIAG-EXP-ARITH-001`, `DIAG-RY-BRIDGE-001`, `DIAG-EXP-UNCOMP-001` | future Lean worker | `expandedAmplitudeOracleCleanBlockExtracts`, `expandedAmplitudeOracleCleanBlockContract_diagonal` | Expanded Sub-DAG | `python3 tools/qbe.py check` | later leaf |

The next `DIAG-RY-BRIDGE-001` follow-up is no longer to restate the conditional
bridge.  It is to supply a concrete backend witness for
`expandedControlledRyBackendBridge`, or keep the route predicate as a backend
obligation and move to an independent expanded leaf.

## DIAG-RY-BRIDGE-001 Proof Design

The exact source fragment for the bridge is still the user-provided diagonal
entry equation:

$$
D_n[row,col] =
\begin{cases}
(row/2^n)^3, & row = col,\\
0, & row \ne col.
\end{cases}
$$

For the rotation subleaf, only the diagonal case is active.  Define
$a_j=(j/2^n)^3$, represented in Lean by
`CubicStatePreparation.cubicAmplitude n j`.  The already compiled scalar-tier
statement says that in any backend satisfying
`StandardRyCleanEntryScalarTier`, the standard `R_y` clean entry for
`theta_j = 2 arccos(a_j)` equals $a_j$ for every `j : Fin (gridSize n)`.

The remaining backend predicate is:

```lean
expandedControlledRyUsesCubicAngle n workspaceQubits
```

This predicate is currently opaque.  Therefore the following theorem is not a
definition-free consequence of the compiled scalar-tier theorem:

```lean
theorem expandedControlledRyUsesCubicAngle_of_standardTier
    (tier : StandardRyCleanEntryScalarTier) (n workspaceQubits : Nat) :
    expandedControlledRyUsesCubicAngle n workspaceQubits
```

Such a theorem would need a backend witness explaining that the controlled
rotation subcircuit used by the expanded route is interpreted by the same
scalar-tier `R_y` convention.  Without that witness, proving the opaque
predicate would amount to adding an unstated semantic assumption.

The current Lean-facing bridge wrapper is now compiled as
`expandedControlledRyBackendBridge`, with the theorem
`expandedControlledRyUsesCubicAngle_of_backendBridge`.  This is still
conditional: a concrete term
`hBridge : expandedControlledRyBackendBridge tier n workspaceQubits` is the
backend witness that remains open.  A minimal honest `hBridge` should be backed
by these semantic facts:

1. a `tier : StandardRyCleanEntryScalarTier`;
2. the compiled cubic specialization
   `expandedRyCleanEntryForCubicAmplitudes tier n`;
3. a backend-semantics fact stating that the route's controlled signal
   rotation for each system index `j` uses
   `tier.thetaForAmplitude (tier.ratAmplitude (cubicAmplitude n j))` and has
   clean entry `tier.cleanEntry` in the clean signal projection;
4. a statement that this rotation substep preserves the system index and does
   not claim arithmetic compute or clean uncompute.

Natural-language proof under such a witness: fix `n`, `workspaceQubits`, and
`j : Fin (gridSize n)`.  The backend witness identifies the clean signal entry
of the controlled rotation branch for `j` with

```text
tier.cleanEntry
  (tier.thetaForAmplitude
    (tier.ratAmplitude (CubicStatePreparation.cubicAmplitude n j))).
```

The theorem `expandedRyCleanEntryForCubicAmplitudes_of_standardTier` rewrites
this expression to
`tier.ratAmplitude (CubicStatePreparation.cubicAmplitude n j)`, using
`cubicAmplitude_nonneg n j` and `cubicAmplitude_le_one n j` through the
scalar-tier contract.  Since this is exactly the embedded diagonal amplitude
$a_j=(j/2^n)^3$, the controlled rotation uses the cubic angle convention
required by the expanded route.  This closes only the rotation backend bridge.
It does not prove reversible arithmetic, clean uncompute, clean-block
extraction, unitarity, resources, or `DIAG-ROOT-001`.

If no concrete `hBridge` with the above semantics is available in the current
Lean surface, the correct route is to keep
`expandedControlledRyBackendBridge tier n workspaceQubits` as the backend
obligation and move the next Lean worker to `DIAG-EXP-ARITH-001`.  The target
operator is not wrong; the gap is the absence of a backend-semantics witness
for the route-level rotation predicate.

### DIAG-RY-BRIDGE-001 DAG

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-RY-RANGE-001` | For each grid index, prove $0 \le a_j \le 1$ for $a_j=(j/2^n)^3$. | `DIAG-RANGE-001` | existing Lean | `cubicAmplitude_nonneg`, `cubicAmplitude_le_one` | `DIAG-EXP-RY-001 Proof Design` | `python3 tools/qbe.py check` | proved |
| `DIAG-RY-SCALAR-001` | Specialize the standard `R_y(theta)` clean-entry identity to all cubic grid amplitudes. | `DIAG-RY-RANGE-001`, `StandardRyCleanEntryScalarTier` | existing Lean | `expandedRyCleanEntryForCubicAmplitudes_of_standardTier` | `DIAG-EXP-RY-001 Proof Design` | `python3 tools/qbe.py check` | proved scalar-tier bridge |
| `DIAG-RY-BACKEND-WITNESS-001` | Supply a concrete witness that the expanded route's controlled rotation backend uses the same scalar-tier angle and clean-entry convention. | `DIAG-RY-SCALAR-001`, backend rotation semantics | future Lean worker if backend semantics are introduced | witness of `expandedControlledRyBackendBridge tier n workspaceQubits` | this section | `python3 tools/qbe.py check` | blocked backend obligation; no current witness |
| `DIAG-RY-BRIDGE-001` | Derive or explicitly record `expandedControlledRyUsesCubicAngle n workspaceQubits` from the backend witness. | `DIAG-RY-BACKEND-WITNESS-001` | future Lean worker after backend witness | `expandedControlledRyUsesCubicAngle_of_backendBridge`; target `expandedControlledRyUsesCubicAngle` | this section and verifier feedback `DIAG-RY-BRIDGE-001.middle.md` | `python3 tools/qbe.py check` | conditional bridge compiled; concrete backend witness open |
| `DIAG-EXP-ARITH-BACKEND-001` | Instantiate the compute backend and prove it preserves `j` and writes `CubicStatePreparation.cubicAmplitude n j`. | `DIAG-EXP-REG-001`, `DIAG-ARITH-VALUE-001` | lower Lean worker | `ExpandedCubicArithmeticBackend`, `symbolicExpandedCubicArithmeticBackend`, `symbolicExpandedCubicArithmeticBackend_computes` | proof-obligation ledger | `python3 tools/qbe.py check` | symbolic compute portion compiled |
| `DIAG-ARITH-BACKEND-BRIDGE-001` | Supply `expandedArithmeticBackendBridge` for the selected backend, or document the missing concrete backend representation. | `DIAG-EXP-ARITH-BACKEND-001` | next Lean worker | witness of `expandedArithmeticBackendBridge`; theorem `expandedArithmeticComputesCubicAmplitude_of_backendBridge` | proof-obligation ledger | `python3 tools/qbe.py check` | active leaf |

The next active leaf for the Lean worker is therefore
`DIAG-ARITH-BACKEND-BRIDGE-001`.  The rotation bridge witness remains open as a
backend obligation.  A future worker may return to
`DIAG-RY-BACKEND-WITNESS-001` only after a concrete backend-semantics interface
is available.  The arithmetic worker must not close the opaque arithmetic
predicate by `trivial`, an untracked axiom, or a semantic definition set to
`True`.

## DIAG-EXP-ARITH-BACKEND-001 Proof Design

The exact source fragment for this active leaf is the diagonal value in the
user-provided operator:

$$
D_n[j,j] = (j/2^n)^3.
$$

There is no paper-source archive for this task.  The Lean definitions already
name this value:

```lean
CubicStatePreparation.gridPoint n j =
  (j.val : Rat) / (gridSize n : Rat)

CubicStatePreparation.cubicAmplitude n j =
  (CubicStatePreparation.gridPoint n j) ^ 3
```

The route-level arithmetic predicate is:

```lean
CubicDiagonalOracle.expandedArithmeticComputesCubicAmplitude n workspaceQubits
```

This predicate is opaque in the current Lean surface.  It should be read as a
semantic obligation for the compute phase of the expanded route, not as a
definition that a tactic can unfold.

The current Lean surface already provides a backend interface:

```lean
structure ExpandedCubicArithmeticBackend (n workspaceQubits : Nat) where
  Workspace : Type
  workspaceQubitCount : Nat
  workspaceQubitCount_eq : workspaceQubitCount = workspaceQubits
  zeroWorkspace : Workspace
  amplitudeRegister : Workspace -> Rat
  compute : Fin (gridSize n) -> Workspace -> Fin (gridSize n) × Workspace
```

The pointwise compute predicate for such a backend is:

```lean
expandedArithmeticBackendComputesCubicAmplitude backend :=
  backend.workspaceQubitCount = workspaceQubits ∧
    ∀ j : Fin (gridSize n),
      (backend.compute j backend.zeroWorkspace).1 = j ∧
        backend.amplitudeRegister ((backend.compute j backend.zeroWorkspace).2) =
          CubicStatePreparation.cubicAmplitude n j
```

The route bridge is:

```lean
expandedArithmeticBackendBridge backend :=
  expandedArithmeticBackendComputesCubicAmplitude backend ->
    expandedArithmeticComputesCubicAmplitude n workspaceQubits
```

### Local Backend Claim

For fixed `n : Nat`, `workspaceQubits : Nat`, and
`backend : ExpandedCubicArithmeticBackend n workspaceQubits`, the backend
compute phase must preserve each system index `j` and write
`CubicStatePreparation.cubicAmplitude n j` into the distinguished amplitude
register of the output workspace.  In source notation, the value is

$$
a_j = (j/2^n)^3.
$$

The active local theorem for a Lean worker is not the opaque parent predicate
by itself.  It is the following dependency package:

```lean
backend : ExpandedCubicArithmeticBackend n workspaceQubits
hBackend : expandedArithmeticBackendComputesCubicAmplitude backend
hBridge : expandedArithmeticBackendBridge backend
```

With these three terms, the compiled theorem
`expandedArithmeticComputesCubicAmplitude_of_backendBridge backend hBackend
hBridge` closes the parent predicate.  Without them, the parent predicate
remains a backend obligation.

A concrete backend witness for this child leaf should provide the following
data before any theorem closes the opaque route predicate:

| Component | Required statement |
|---|---|
| workspace representation | a concrete type for `backend.Workspace`, a clean element `backend.zeroWorkspace`, and a declared distinguished amplitude register |
| workspace count | `backend.workspaceQubitCount = workspaceQubits`, matching `expandedAmplitudeOracleLayout n workspaceQubits` |
| value encoding | for every `j`, the computed workspace value has amplitude register `CubicStatePreparation.cubicAmplitude n j` |
| system preservation | the compute phase maps the system basis state indexed by `j` back to the same `j` |
| backend bridge | a term of `expandedArithmeticBackendBridge backend`, backed by the route's compute semantics rather than by `trivial` or an untracked axiom |
| reversibility hook | optional metadata for a later inverse on the clean-workspace image; this leaf does not prove `expandedWorkspaceCleanUncomputed` |
| no downstream claims | the arithmetic leaf does not prove the rotation backend, clean-block extraction, unitarity, or the root block-encoding certificate |

The current symbolic backend is:

```lean
symbolicExpandedCubicArithmeticBackend n workspaceQubits :
  ExpandedCubicArithmeticBackend n workspaceQubits

symbolicExpandedCubicArithmeticBackend_computes n workspaceQubits :
  expandedArithmeticBackendComputesCubicAmplitude
    (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
```

This closes the backend shape and pointwise compute subgoals only.  It does
not supply `expandedArithmeticBackendBridge` and does not close the opaque
route predicate.

Natural-language proof under such a backend witness: fix `n`,
`workspaceQubits`, `backend`, and `j : Fin (gridSize n)`.  The definition of
`gridPoint` identifies the source grid value with
`(j.val : Rat) / (gridSize n : Rat)`, and the definition of `cubicAmplitude`
takes its third power.  The first component of `hBackend` ties the backend's
workspace count to the route parameter `workspaceQubits`.  The second component
of `hBackend`, specialized to `j`, states both that
`(backend.compute j backend.zeroWorkspace).1 = j` and that the distinguished
amplitude register of the computed workspace equals
`CubicStatePreparation.cubicAmplitude n j`.  Therefore the compute phase
supplies exactly the value required for the diagonal entry $D_n[j,j]$ while
preserving the system index.  Applying `hBridge` to `hBackend`, equivalently
using `expandedArithmeticComputesCubicAmplitude_of_backendBridge`, yields the
parent predicate `expandedArithmeticComputesCubicAmplitude n workspaceQubits`.

This proof is intentionally local.  It does not use the standard `R_y`
clean-entry identity, and it does not prove that the workspace is clean after
the rotation.  It also does not construct a block extractor or a unitary
certificate.  Those facts remain `DIAG-RY-BRIDGE-001`,
`DIAG-EXP-UNCOMP-001`, `DIAG-EXP-BLOCK-001`, and `DIAG-ROOT-001`.

### DIAG-EXP-ARITH-BACKEND-001 DAG

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-ARITH-VALUE-001` | Identify the arithmetic value as `CubicStatePreparation.cubicAmplitude n j = ((j.val : Rat) / (gridSize n : Rat))^3`. | `DIAG-TGT-001` | existing Lean | `CubicStatePreparation.gridPoint`, `CubicStatePreparation.cubicAmplitude` | this section | `python3 tools/qbe.py check` | proved by existing definitions |
| `DIAG-ARITH-RANGE-001` | Reuse range facts for the computed amplitude when a backend needs bounded fixed-point or rotation-domain side conditions. | `DIAG-ARITH-VALUE-001`, `DIAG-RANGE-001` | existing Lean | `cubicAmplitude_nonneg`, `cubicAmplitude_le_one` | proof-obligation ledger | `python3 tools/qbe.py check` | proved |
| `DIAG-ARITH-BACKEND-SHAPE-001` | Instantiate `backend : ExpandedCubicArithmeticBackend n workspaceQubits`, including workspace type, zero state, amplitude register, compute map, and workspace-count equality. | `DIAG-EXP-REG-001`, `DIAG-ARITH-VALUE-001` | lower Lean worker | `symbolicExpandedCubicArithmeticBackend` | this section | `python3 tools/qbe.py check` | compiled for symbolic backend |
| `DIAG-ARITH-BACKEND-COMPUTE-001` | Prove `expandedArithmeticBackendComputesCubicAmplitude backend`: compute preserves `j` and writes `CubicStatePreparation.cubicAmplitude n j`. | `DIAG-ARITH-BACKEND-SHAPE-001`, `DIAG-ARITH-VALUE-001` | lower Lean worker | `symbolicExpandedCubicArithmeticBackend_computes` | this section | `python3 tools/qbe.py check` | compiled for symbolic backend |
| `DIAG-ARITH-BACKEND-BRIDGE-001` | Supply `expandedArithmeticBackendBridge backend`, linking the concrete backend semantics to the opaque route predicate. | `DIAG-ARITH-BACKEND-COMPUTE-001`, route backend semantics | next Lean worker or obligation recorder | `expandedArithmeticBackendBridge (symbolicExpandedCubicArithmeticBackend n workspaceQubits)` | this section | `python3 tools/qbe.py check` | active bridge subgoal; no route semantics witness yet |
| `DIAG-EXP-ARITH-001` | Derive `expandedArithmeticComputesCubicAmplitude n workspaceQubits` from `backend`, `hBackend`, and `hBridge`. | `DIAG-ARITH-BACKEND-BRIDGE-001` | next Lean worker after backend package | `expandedArithmeticComputesCubicAmplitude_of_backendBridge` | this section | `python3 tools/qbe.py check` | conditional closure available only after backend package |
| `DIAG-EXP-UNCOMP-001` | Prove clean uncompute after the rotation, using the same arithmetic backend and workspace layout. | `DIAG-EXP-ARITH-001`, `DIAG-RY-BRIDGE-001` | future Lean worker | `expandedWorkspaceCleanUncomputed` | proof-obligation ledger | `python3 tools/qbe.py check` | later leaf |

Next active Lean leaf: supply
`expandedArithmeticBackendBridge
  (symbolicExpandedCubicArithmeticBackend n workspaceQubits)`, or replace the
symbolic backend with a register-level backend carrying the same pointwise
compute proof and bridge.  The parent predicate should be closed only through
`expandedArithmeticComputesCubicAmplitude_of_backendBridge`.

### Lean Lemmas For The Arithmetic Leaf

The Lean worker should use these declarations in dependency order:

1. Reuse `CubicStatePreparation.gridPoint` and
   `CubicStatePreparation.cubicAmplitude` for the value equation.  Do not
   duplicate the grid encoding in a new file.
2. Reuse `expandedAmplitudeOracleLayout n workspaceQubits` and
   `expandedAmplitudeOracleLayout_auxiliaryQubits` to keep the workspace count
   tied to the expanded route.
3. Instantiate `ExpandedCubicArithmeticBackend n workspaceQubits` with an
   explicit `Workspace`, `zeroWorkspace`, `amplitudeRegister`, and `compute`.
4. Prove `expandedArithmeticBackendComputesCubicAmplitude backend`, using the
   definitions of `gridPoint` and `cubicAmplitude` for the value equation and
   proving system-index preservation for every `j : Fin (gridSize n)`.
5. Reuse `cubicAmplitude_nonneg n j` and `cubicAmplitude_le_one n j` only when
   the backend construction needs range side conditions.  These range lemmas do
   not by themselves prove arithmetic computation.
6. Supply `expandedArithmeticBackendBridge backend` from a real route-semantics
   witness, or record that this bridge is the missing obligation.
7. Derive `expandedArithmeticComputesCubicAmplitude n workspaceQubits` only
   through `expandedArithmeticComputesCubicAmplitude_of_backendBridge backend
   hBackend hBridge`.  Do not prove the opaque proposition by `trivial`, an
   untracked axiom, or a definition that hides the compute semantics.
8. Leave `expandedWorkspaceCleanUncomputed`,
   `expandedControlledRyUsesCubicAngle`, and
   `expandedAmplitudeOracleCleanBlockExtracts` to their own DAG leaves.

## Intermediate Lean Lemmas

1. Reuse `CubicDiagonalOracle.cubicAmplitude_nonneg` and
   `CubicDiagonalOracle.cubicAmplitude_le_one`.  These justify that the
   intended diagonal amplitudes lie in the scalar interval required by a
   one-signal amplitude oracle.

2. Reuse `CubicDiagonalOracle.diagonalCleanBlockContract_pointwise_eq`.  This
   converts the clean-block entry predicate into pointwise equality with
   `cubicDiagonalOperator n`.

3. Reuse `CubicDiagonalOracle.primitiveOracleCleanBlock_eq_target`.  This
   unfolds `cubicDiagonalTarget` and identifies any block satisfying
   `diagonalCleanBlockContract` with the target operator.

4. Reuse
   `CubicDiagonalOracle.primitiveAmplitudeOracleSemanticContract_unitary`.
   This extracts the unitary component from an already supplied primitive
   semantic contract witness.

5. Reuse
   `CubicDiagonalOracle.primitiveAmplitudeOracleSemanticContract_cleanBlock_eq_target`.
   This extracts the target clean block from the same witness.

6. Reuse
   `CubicDiagonalOracle.primitiveAmplitudeOracleCandidate_unitary_from_contract`
   and
   `CubicDiagonalOracle.primitiveAmplitudeOracleCandidate_block_from_contract`.
   These are the packaging lemmas for the primitive candidate once `h` exists.

7. Reuse `CubicDiagonalOracle.amplitudeOracleResourceTuple_eq`.  This records
   the unexpanded primitive oracle-label score and should be cited only inside
   the primitive semantic tier.

8. Reuse the expanded route layout interface
   `expandedAmplitudeOracleLayout n workspaceQubits`, together with
   `expandedAmplitudeOracleLayout_auxiliaryQubits` and
   `expandedAmplitudeOracleNormalizer_eq`.  This names the workspace count but
   does not prove arithmetic correctness.

9. For the active arithmetic child leaf, reuse
   `symbolicExpandedCubicArithmeticBackend n workspaceQubits` and
   `symbolicExpandedCubicArithmeticBackend_computes n workspaceQubits`, then
   supply `expandedArithmeticBackendBridge` for that backend.  If the symbolic
   backend is too weak for the route semantics, replace it with a register-level
   backend carrying the same pointwise compute proof and bridge.  Then use
   `expandedArithmeticComputesCubicAmplitude_of_backendBridge backend hBackend
   hBridge` to close the parent route predicate.  Reuse
   `cubicAmplitude_nonneg` and `cubicAmplitude_le_one` only for range side
   conditions instead of restating bounds.

10. Prove or refine `expandedControlledRyUsesCubicAngle n workspaceQubits` or
    a transparent backend witness for the standard `R_y(theta)` matrix.  The
    scalar identity is already packaged by `StandardRyCleanEntryScalarTier` and
    specialized by `expandedRyCleanEntryForCubicAmplitudes_of_standardTier`;
    the remaining dependency is the backend-semantics link from that scalar
    convention to the opaque route predicate.

11. Prove or refine `expandedWorkspaceCleanUncomputed n workspaceQubits`, which
    states that the inverse arithmetic restores every workspace register to
    zero and preserves the system index.  This lemma is what prevents
    off-diagonal system entries from appearing in the clean block.

12. Reuse `expandedAmplitudeOracleCleanBlockExtracts n workspaceQubits block`,
    `expandedAmplitudeOracleCleanBlockContract`, and
    `expandedAmplitudeOracleCleanBlockContract_diagonal`.  A later proof must
    justify the opaque extraction predicate from the arithmetic, rotation, and
    clean-uncompute obligations.

13. Reuse `expandedAmplitudeOracleCleanBlockContract_eq_target` and
    `expandedAmplitudeOracleSemanticContract_cleanBlock_eq_target`.  Their
    proofs destructure the expanded contract and apply
    `primitiveOracleCleanBlock_eq_target`; they do not redo the entrywise
    diagonal calculation.

No new definition-free Lean lemma is exposed by the parked primitive proof
design.  The current missing proofs are the expanded route's semantic
obligations: the arithmetic backend-to-route bridge, controlled-rotation
semantics, clean uncompute, and extraction.

## Failure Analysis

The current target is mathematically correct: it is a diagonal operator, not a
rank-one state-preparation map, and the normalizer $\alpha = 1$ is consistent
with the compiled range lemmas.

The parked primitive target `primitiveAmplitudeOracleSemanticContract n` is not
internally provable from the present definitions.  The named primitive unitary,
the unitarity predicate, and the clean-block extraction predicate are opaque.
The range lemmas show that the desired amplitudes are valid for a one-signal
amplitude oracle, but they do not construct a concrete matrix over `Rat`.

A direct exact two-dimensional rotation block for amplitude
$a = (j/2^n)^3$ would normally use a complementary amplitude such as
$\sqrt{1-a^2}$.  That value is not generally rational, so a gate-expanded exact
unitary over the current `Rat` matrix surface is not available by unfolding the
range lemmas.  A Lean worker should not close this leaf by setting the opaque
semantic predicates to `True` or by adding an untracked axiom.

The correct route split is:

1. If QBE accepts the unexpanded primitive oracle-label tier as an external
   primitive contract in a later cycle, record the accepted contract source and
   provide the witness `h : primitiveAmplitudeOracleSemanticContract n`.
2. For the current cycle, target `DIAG-EXP-ARITH-BACKEND-001` by supplying an
   honest `ExpandedCubicArithmeticBackend` witness, a proof of
   `expandedArithmeticBackendComputesCubicAmplitude backend`, and a route
   witness `expandedArithmeticBackendBridge backend`.  The compiled scalar-tier
   rotation bridge remains reusable but is parked until a concrete rotation
   backend witness exists.

## Typed Verifier Feedback

| Field | Value |
|---|---|
| `leaf` | `DIAG-ARITH-BACKEND-BRIDGE-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true`, no Lean edit in this pass |
| `lean_build_ok` | `true`, to be confirmed by the final project gate |
| `finite_matrix_ok` | `true`, inherited from the exact-rational arithmetic/register diagnostic for `DIAG-EXP-ARITH-BACKEND-001`; rerun only if the backend representation changes |
| `block_entry_ok` | `null`, clean-block extraction is a later leaf |
| `ancilla_cleanup_ok` | `null`, `expandedWorkspaceCleanUncomputed` is a compiled obligation, not a proof |
| `normalizer_ok` | `true`, `exactNormalizer n = 1` is compiled |
| `unitarity_ok` | `null`, arithmetic computation alone is not a unitary/circuit certificate |
| `resource_score` | `null`, expanded route not scored yet |
| `closed_theorem_ok` | `false`; the parent arithmetic predicate is still conditional on a concrete backend package |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `Supply expandedArithmeticBackendBridge for symbolicExpandedCubicArithmeticBackend, or replace it with a register-level backend carrying the same pointwise compute proof and bridge; otherwise record the missing workspace/backend representation.` |

## Handoff

`DIAG-ARITH-BACKEND-BRIDGE-001` is the active proof leaf.  The source fragment
is still the diagonal entry $D_n[j,j]=(j/2^n)^3$ with $\alpha=1$.  The compiled
symbolic backend and compute proof are
`symbolicExpandedCubicArithmeticBackend` and
`symbolicExpandedCubicArithmeticBackend_computes`.  The compiled parent bridge
is `expandedArithmeticComputesCubicAmplitude_of_backendBridge`, so the next
Lean worker should supply
`expandedArithmeticBackendBridge
  (symbolicExpandedCubicArithmeticBackend n workspaceQubits)`, or replace the
symbolic backend with a register-level backend carrying the same pointwise
compute proof and bridge; otherwise the correct failure is the missing
workspace/backend representation.  The compiled `DIAG-EXP-RY-001`
scalar-tier proof and the conditional `DIAG-RY-BRIDGE-001` theorem remain
reusable, but the concrete controlled-rotation backend witness is still an open
obligation.  Do not rebuild `DIAG-EXPANDED-CONTRACT-001`, do not tactic-search
the parked primitive opaque contract, do not close opaque semantics by
`trivial`, and do not create executable exports before `DIAG-ROOT-001` closes.
