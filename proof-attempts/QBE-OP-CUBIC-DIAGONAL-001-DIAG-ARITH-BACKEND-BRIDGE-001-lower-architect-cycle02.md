# QBE-OP-CUBIC-DIAGONAL-001 DIAG-ARITH-BACKEND-BRIDGE-001 Proof Design

Updated: 2026-06-20 04:07 JST

Role: lower natural-language proof architect.

## Source Fragment

There is no paper-source archive for this user-provided operator task.  The
source fragment being translated is the diagonal oracle equation:

$$
O = \sum_{j=0}^{2^n-1} f(x_j)|j\rangle\langle j|,
\qquad
f(x)=x^3,
\qquad
x_j=j/2^n.
$$

Equivalently, the target matrix is

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

For fixed `n workspaceQubits : Nat`, an expanded arithmetic backend is a value

```lean
backend : ExpandedCubicArithmeticBackend n workspaceQubits
```

with a workspace type, a clean workspace, a distinguished amplitude register,
and a compute map

```lean
backend.compute :
  Fin (gridSize n) -> backend.Workspace -> Fin (gridSize n) × backend.Workspace
```

The pointwise compute predicate is

```lean
expandedArithmeticBackendComputesCubicAmplitude backend
```

which states that the backend has the declared workspace-qubit count and, for
every system index `j`, the compute phase starts from `backend.zeroWorkspace`,
preserves `j`, and writes
`CubicStatePreparation.cubicAmplitude n j` into `backend.amplitudeRegister`.

The selected compiled symbolic backend is

```lean
symbolicExpandedCubicArithmeticBackend n workspaceQubits
```

and the compiled pointwise proof is

```lean
symbolicExpandedCubicArithmeticBackend_computes n workspaceQubits :
  expandedArithmeticBackendComputesCubicAmplitude
    (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
```

The route-level arithmetic predicate is opaque:

```lean
expandedArithmeticComputesCubicAmplitude n workspaceQubits
```

The bridge predicate is the missing semantic implication:

```lean
expandedArithmeticBackendBridge
  (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
```

After such a bridge is supplied, the compiled closure theorem is

```lean
expandedArithmeticComputesCubicAmplitude_of_backendBridge
```

## Natural-Language Proof Of The Local Theorem

The local theorem that can be proved from the current interface is conditional.
Fix `n` and `workspaceQubits`.  Let

```lean
B := symbolicExpandedCubicArithmeticBackend n workspaceQubits
```

The theorem `symbolicExpandedCubicArithmeticBackend_computes` proves
`expandedArithmeticBackendComputesCubicAmplitude B`.  This proof unfolds the
symbolic backend: its workspace is `Rat`, its clean workspace is `0`, its
amplitude register is the identity function, and its compute map returns

```lean
(j, CubicStatePreparation.cubicAmplitude n j)
```

for every `j`.  Therefore the system index is preserved and the distinguished
register contains exactly $a_j=(j/2^n)^3$.

Assume an additional bridge witness

```lean
hBridge : expandedArithmeticBackendBridge B
```

By definition, `hBridge` is a function from the pointwise compute predicate for
`B` to the opaque route predicate
`expandedArithmeticComputesCubicAmplitude n workspaceQubits`.  Applying
`hBridge` to `symbolicExpandedCubicArithmeticBackend_computes n
workspaceQubits` proves the route predicate.  This is exactly the compiled
theorem
`expandedArithmeticComputesCubicAmplitude_of_backendBridge B hBackend hBridge`.

This proof does not prove `hBridge`.  A proof of `hBridge` must identify a
concrete route-semantics representation that explains why the pointwise
compute predicate for the selected backend is the semantics used by the opaque
expanded route.  The current symbolic backend does not provide reversible-gate
semantics, an explicit workspace-register encoding, clean uncompute, rotation
semantics, clean-block extraction, unitarity, or root block-encoding
certification.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-TGT-001` | Define the diagonal operator $D_n[row,col]$. | none | existing Lean | `cubicDiagonalOperator`, `cubicDiagonalTarget` | `conversion-windows/QBE-OP-CUBIC-DIAGONAL-001.md` | `python3 tools/qbe.py check` | proved |
| `DIAG-RANGE-001` | Prove $0 \le a_j \le 1$ for each cubic grid amplitude. | `gridPoint_nonneg`, `gridPoint_le_one`, `rat_pow_le_one_of_nonneg_le_one` | existing Lean | `cubicAmplitude_nonneg`, `cubicAmplitude_le_one` | proof-obligation ledger | `python3 tools/qbe.py check` | proved |
| `DIAG-EXP-REG-001` | Name the expanded layout and workspace-qubit parameter. | `DIAG-TGT-001` | existing Lean | `expandedAmplitudeOracleLayout`, `expandedAmplitudeOracleLayout_auxiliaryQubits`, `expandedAmplitudeOracleNormalizer_eq` | conversion window | `python3 tools/qbe.py check` | proved |
| `DIAG-EXP-ARITH-BACKEND-001` | Instantiate a compute-phase backend and prove it preserves `j` and writes `a_j`. | `DIAG-EXP-REG-001` | existing Lean | `ExpandedCubicArithmeticBackend`, `symbolicExpandedCubicArithmeticBackend`, `symbolicExpandedCubicArithmeticBackend_computes` | this file | `python3 tools/qbe.py check` | compiled pointwise compute proof |
| `DIAG-ARITH-REP-001` | Specify a concrete workspace/register/backend semantics for the selected arithmetic route, or state that none is present. | `DIAG-EXP-ARITH-BACKEND-001` | next Lean worker or middle refiner | no declaration yet | this file | `python3 tools/qbe.py check` | blocked internal representation leaf |
| `DIAG-ARITH-BACKEND-BRIDGE-001` | Supply `expandedArithmeticBackendBridge (symbolicExpandedCubicArithmeticBackend n workspaceQubits)`, or replace the backend with a register-level backend carrying the same pointwise proof and bridge. | `DIAG-EXP-ARITH-BACKEND-001`, `DIAG-ARITH-REP-001` | next Lean worker | required witness of `expandedArithmeticBackendBridge`; closure theorem `expandedArithmeticComputesCubicAmplitude_of_backendBridge` | this file and proof-obligation ledger | `python3 tools/qbe.py check` | active leaf blocked by `symbolic_bridge_gap` |
| `DIAG-EXP-ARITH-001` | Close `expandedArithmeticComputesCubicAmplitude n workspaceQubits`. | `DIAG-ARITH-BACKEND-BRIDGE-001` | future Lean worker | `expandedArithmeticComputesCubicAmplitude_of_backendBridge` | this file | `python3 tools/qbe.py check` | conditional bridge compiled; route predicate unclosed |
| `DIAG-RY-BACKEND-WITNESS-001` | Supply the controlled-rotation backend witness. | scalar-tier bridge and backend rotation semantics | future Lean worker | `expandedControlledRyBackendBridge` | conversion window | `python3 tools/qbe.py check` | blocked backend obligation |
| `DIAG-EXP-UNCOMP-001` | Prove clean uncompute after rotation. | arithmetic route and rotation route | future Lean worker | `expandedWorkspaceCleanUncomputed` | proof-obligation ledger | `python3 tools/qbe.py check` | later obligation |
| `DIAG-ROOT-001` | Package a certified block encoding of the diagonal operator. | arithmetic, rotation, uncompute, extraction, unitarity, resource proof | future Lean worker | no unconditional expanded certificate yet | candidate population ledger | `python3 tools/qbe.py check` | blocked |

The next Lean worker should treat `DIAG-ARITH-BACKEND-BRIDGE-001` as the active
parent leaf, with `DIAG-ARITH-REP-001` as the missing immediate dependency.  If
no concrete representation is introduced, the correct result is a blocked
handoff, not another tactic attempt against the opaque predicate.

## Ordered Lean Lemmas And Reuse Plan

1. Reuse `CubicStatePreparation.cubicAmplitude n j` as the unique arithmetic
   value for the source amplitude $a_j=(j/2^n)^3$.
2. Reuse `symbolicExpandedCubicArithmeticBackend n workspaceQubits` as the
   current compute-phase backend.
3. Reuse `symbolicExpandedCubicArithmeticBackend_computes n workspaceQubits` to
   obtain `expandedArithmeticBackendComputesCubicAmplitude` for the symbolic
   backend.
4. If a concrete route representation is introduced, prove a new witness
   `hBridge : expandedArithmeticBackendBridge backend`.  The proof must cite
   that representation; it must not unfold the opaque route predicate.
5. Apply `expandedArithmeticComputesCubicAmplitude_of_backendBridge backend
   hBackend hBridge` to close `expandedArithmeticComputesCubicAmplitude`.
6. Leave `expandedControlledRyUsesCubicAngle`,
   `expandedWorkspaceCleanUncomputed`,
   `expandedAmplitudeOracleCleanBlockExtracts`, and any root certificate for
   later DAG leaves.

## Failure Analysis

The current target is not mathematically wrong, but it is not theorem-ready
from the symbolic compute proof alone.  The proposition
`expandedArithmeticBackendBridge B` asserts that the pointwise compute predicate
for `B` implies the opaque expanded-route predicate.  Since
`expandedArithmeticComputesCubicAmplitude` is opaque, there is no definition to
unfold and no matrix/register semantics to evaluate.

The symbolic backend is therefore a useful compute witness, not a concrete
route-semantics backend.  Closing the bridge without a route representation
would add an unstated semantic assumption.  The correct classification is
`symbolic_bridge_gap` with
`workspace_representation_specified=false`.

## Typed Verifier Feedback

```text
leaf=DIAG-ARITH-BACKEND-BRIDGE-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
closed_theorem_ok=false
workspace_representation_specified=false
error_class=symbolic_bridge_gap
next_route=introduce a concrete workspace/backend representation and then supply expandedArithmeticBackendBridge, or keep this leaf blocked
```

## Handoff

The proof map for `DIAG-ARITH-BACKEND-BRIDGE-001` is now narrowed to the missing
backend-semantics representation.  The compiled symbolic backend and pointwise
compute proof should be reused.  The next Lean worker should either introduce a
concrete workspace/register backend that justifies `expandedArithmeticBackendBridge`
or return the leaf as blocked with `workspace_representation_specified=false`.
Root certification and executable exports remain downstream.  Gate passed:
`python3 tools/qbe.py check`.
