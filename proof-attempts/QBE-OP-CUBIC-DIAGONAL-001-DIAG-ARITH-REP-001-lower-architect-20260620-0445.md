# QBE-OP-CUBIC-DIAGONAL-001 DIAG-ARITH-REP-001 Proof Design

Updated: 2026-06-20 04:45 JST

Role: lower natural-language proof architect.

## Source Fragment

There is no paper-source archive for this user-provided operator task.  The
translated source equation is

$$
O = \sum_{j=0}^{2^n-1} f(x_j)|j\rangle\langle j|,
\qquad
f(x)=x^3,
\qquad
x_j=j/2^n.
$$

Thus the Lean target operator is the diagonal matrix

$$
D_n[row,col] =
\begin{cases}
(row/2^n)^3, & row = col,\\
0, & row \ne col.
\end{cases}
$$

The active arithmetic value is
$a_j=(j/2^n)^3$, represented in Lean by
`CubicStatePreparation.cubicAmplitude n j`.

## Definitions

Fix `n workspaceQubits : Nat`.

The current compute-phase carrier is

```lean
symbolicExpandedCubicArithmeticBackend n workspaceQubits :
  ExpandedCubicArithmeticBackend n workspaceQubits
```

An `ExpandedCubicArithmeticBackend n workspaceQubits` contains a workspace
type, a clean workspace value, an amplitude-register projection, and a compute
map from a system index and workspace to a new system index and workspace.

The pointwise compute predicate is

```lean
expandedArithmeticBackendComputesCubicAmplitude backend
```

For every system index `j`, it states that the compute phase starts from
`backend.zeroWorkspace`, preserves `j`, and writes
`CubicStatePreparation.cubicAmplitude n j` into the distinguished amplitude
register.

The route-level arithmetic predicate is opaque:

```lean
expandedArithmeticComputesCubicAmplitude n workspaceQubits
```

The bridge predicate for a backend is

```lean
expandedArithmeticBackendBridge backend
```

By definition, this bridge is the implication from the pointwise backend
predicate to the opaque route-level predicate.

The immediate representation dependency is `DIAG-ARITH-REP-001`: a concrete
workspace/register/backend representation explaining why the selected backend's
pointwise compute semantics are the semantics of the route predicate.

## Natural-Language Proof Of The Active Local Theorem

The active local theorem that is currently derivable is conditional, not
unconditional.

Let

```lean
B := symbolicExpandedCubicArithmeticBackend n workspaceQubits
```

The compiled theorem

```lean
symbolicExpandedCubicArithmeticBackend_computes n workspaceQubits
```

proves `expandedArithmeticBackendComputesCubicAmplitude B`.  This follows by
unfolding the symbolic backend: the workspace is `Rat`, the clean workspace is
`0`, the amplitude register is the identity function, and the compute map sends
each `j` to

```lean
(j, CubicStatePreparation.cubicAmplitude n j)
```

The system index is therefore preserved, and the distinguished register holds
exactly $a_j=(j/2^n)^3$.

Assume a bridge witness

```lean
hBridge : expandedArithmeticBackendBridge B
```

The definition of `expandedArithmeticBackendBridge` makes `hBridge` a function
from `expandedArithmeticBackendComputesCubicAmplitude B` to
`expandedArithmeticComputesCubicAmplitude n workspaceQubits`.  Applying
`hBridge` to the compiled pointwise proof closes the route predicate.  This is
the existing theorem

```lean
expandedArithmeticComputesCubicAmplitude_of_symbolicBackendBridge
```

The proof above does not construct `hBridge`.  A proof of `hBridge` needs the
missing representation dependency: a concrete statement that the backend's
workspace, amplitude register, and compute phase are the semantics intended by
`expandedArithmeticComputesCubicAmplitude`.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-TGT-001` | Define the diagonal operator $D_n[row,col]$. | none | existing Lean | `cubicDiagonalOperator`, `cubicDiagonalTarget` | conversion window | `python3 tools/qbe.py check` | proved |
| `DIAG-RANGE-001` | Prove $0 \le a_j \le 1$ for each cubic grid amplitude. | `gridPoint_nonneg`, `gridPoint_le_one`, `rat_pow_le_one_of_nonneg_le_one` | existing Lean | `cubicAmplitude_nonneg`, `cubicAmplitude_le_one` | proof-obligation ledger | `python3 tools/qbe.py check` | proved |
| `DIAG-EXP-REG-001` | Name the expanded route layout and workspace-qubit parameter. | `DIAG-TGT-001` | existing Lean | `expandedAmplitudeOracleLayout`, `expandedAmplitudeOracleLayout_auxiliaryQubits`, `expandedAmplitudeOracleNormalizer_eq` | conversion window | `python3 tools/qbe.py check` | proved |
| `DIAG-EXP-ARITH-BACKEND-001` | Instantiate a compute-phase backend and prove it preserves `j` and writes $a_j$. | `DIAG-EXP-REG-001` | existing Lean | `ExpandedCubicArithmeticBackend`, `symbolicExpandedCubicArithmeticBackend`, `symbolicExpandedCubicArithmeticBackend_computes` | prior proof attempts | `python3 tools/qbe.py check` | compiled pointwise compute proof |
| `DIAG-ARITH-REP-001` | Specify a concrete workspace/register/backend representation for the selected arithmetic route, or state that none is present. | `DIAG-EXP-ARITH-BACKEND-001`; current circuit IR surface | next Lean or middle refiner | no declaration yet | this file | `python3 tools/qbe.py check` | next active leaf; currently blocked with `workspace_representation_specified=false` |
| `DIAG-ARITH-BACKEND-BRIDGE-001` | Supply `expandedArithmeticBackendBridge (symbolicExpandedCubicArithmeticBackend n workspaceQubits)`, or replace the symbolic backend with a register-level backend carrying the same pointwise proof and bridge. | `DIAG-EXP-ARITH-BACKEND-001`, `DIAG-ARITH-REP-001` | future Lean worker after representation exists | required witness of `expandedArithmeticBackendBridge`; closures `expandedArithmeticComputesCubicAmplitude_of_backendBridge`, `expandedArithmeticComputesCubicAmplitude_of_symbolicBackendBridge` | this file and proof-obligation ledger | `python3 tools/qbe.py check` | parent leaf blocked by `symbolic_bridge_gap` |
| `DIAG-EXP-ARITH-001` | Close `expandedArithmeticComputesCubicAmplitude n workspaceQubits`. | `DIAG-ARITH-BACKEND-BRIDGE-001` | future Lean worker | `expandedArithmeticComputesCubicAmplitude_of_backendBridge` | conversion window | `python3 tools/qbe.py check` | conditional closure compiled; route predicate unclosed |
| `DIAG-RY-BACKEND-WITNESS-001` | Supply the controlled-rotation backend witness. | scalar-tier bridge and backend rotation semantics | future Lean worker | `expandedControlledRyBackendBridge` | conversion window | `python3 tools/qbe.py check` | blocked backend obligation |
| `DIAG-EXP-UNCOMP-001` | Prove clean uncompute after rotation. | arithmetic route and rotation route | future Lean worker | `expandedWorkspaceCleanUncomputed` | proof-obligation ledger | `python3 tools/qbe.py check` | later obligation |
| `DIAG-ROOT-001` | Package a certified block encoding of the diagonal operator. | arithmetic, rotation, uncompute, extraction, unitarity, resource proof | future Lean worker | no unconditional expanded certificate yet | candidate population ledger | `python3 tools/qbe.py check` | blocked |

The next active leaf for a Lean worker is `DIAG-ARITH-REP-001`, not a direct
tactic attack on `expandedArithmeticComputesCubicAmplitude`.

## Ordered Lean Lemmas And Reuse Plan

1. Reuse `CubicStatePreparation.cubicAmplitude n j` for the source arithmetic
   value $a_j=(j/2^n)^3$.
2. Reuse `ExpandedCubicArithmeticBackend` for the compute-phase backend shape.
3. Reuse `symbolicExpandedCubicArithmeticBackend n workspaceQubits` only as the
   current pointwise compute witness.
4. Reuse `symbolicExpandedCubicArithmeticBackend_computes n workspaceQubits` to
   obtain `expandedArithmeticBackendComputesCubicAmplitude` for the symbolic
   backend.
5. Before proving any bridge, introduce or locate a concrete representation
   interface for `DIAG-ARITH-REP-001`.  The current `Circuit` and
   `LayeredCircuit` declarations provide a gate/resource IR, but no arithmetic
   matrix or register semantics for this bridge.
6. After a representation exists, prove a witness
   `hBridge : expandedArithmeticBackendBridge backend` by citing that
   representation.  The proof must not unfold an opaque predicate, add an
   axiom, or set a semantic proposition to `True`.
7. Apply `expandedArithmeticComputesCubicAmplitude_of_backendBridge backend
   hBackend hBridge`, or the symbolic specialization, to close the parent
   route predicate.
8. Keep `expandedControlledRyUsesCubicAngle`,
   `expandedWorkspaceCleanUncomputed`,
   `expandedAmplitudeOracleCleanBlockExtracts`, unitarity, and root
   certification as later DAG leaves.

## Failure Analysis

The diagonal target and cubic arithmetic value are mathematically consistent.
The current bridge target is not theorem-ready from the symbolic compute proof
alone.

The reason is structural.  The proposition
`expandedArithmeticComputesCubicAmplitude n workspaceQubits` is opaque, and the
current Lean surface contains no constructor or semantic definition connecting
it to `expandedArithmeticBackendComputesCubicAmplitude B`.  The bridge
predicate is exactly the missing implication to that opaque proposition.  A
proof of the bridge without a representation would be an unstated semantic
assumption.

The current local circuit IR records gates and resources, but it does not yet
provide register-level arithmetic semantics or a matrix interpretation for the
compute phase.  Therefore the honest classification remains
`symbolic_bridge_gap` with `workspace_representation_specified=false`.

## Typed Verifier Feedback

```text
leaf=DIAG-ARITH-BACKEND-BRIDGE-001
immediate_dependency=DIAG-ARITH-REP-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
finite_arithmetic_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
closed_theorem_ok=false
workspace_representation_specified=false
error_class=symbolic_bridge_gap
next_route=name a concrete workspace/register/backend representation for DIAG-ARITH-REP-001, then supply expandedArithmeticBackendBridge; otherwise keep the parent bridge blocked
```

## Handoff

The proof design confirms that the symbolic backend and pointwise compute proof
are reusable, but they do not justify the opaque route predicate.  Send the
next Lean worker to `DIAG-ARITH-REP-001`: either introduce a concrete
workspace/register/backend representation tied to the current route, or keep
`DIAG-ARITH-BACKEND-BRIDGE-001` blocked with
`workspace_representation_specified=false`.  Do not reopen the controlled-`R_y`
backend witness, clean uncompute, root certificate, or executable exports in
this leaf.
