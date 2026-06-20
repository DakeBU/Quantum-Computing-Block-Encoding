# QBE-OP-CUBIC-DIAGONAL-001 DIAG-ARITH-BACKEND-BRIDGE-001 Lower Architect Handoff

Updated: 2026-06-20 JST

Role: lower natural-language proof architect.

Active leaf: `DIAG-ARITH-BACKEND-BRIDGE-001`.

## Source Fragment

There is no paper-source archive for this task.  The source fragment is the
user-provided diagonal operator:

$$
D_n = \sum_{j=0}^{2^n-1} (j/2^n)^3 |j\rangle\langle j|.
$$

Equivalently, for each row and column,

$$
D_n[row,col] =
\begin{cases}
(row/2^n)^3, & row = col,\\
0, & row \ne col.
\end{cases}
$$

The arithmetic leaf uses only the diagonal value

$$
a_j = (j/2^n)^3.
$$

In Lean this value is represented by
`CubicStatePreparation.cubicAmplitude n j`.  The normalizer remains
`CubicDiagonalOracle.exactNormalizer n = 1`.

## Definitions

Fix `n workspaceQubits : Nat`.

An arithmetic backend is a term

```lean
backend : ExpandedCubicArithmeticBackend n workspaceQubits
```

with a workspace type, a clean workspace element, a distinguished amplitude
register, and a compute map from a system index plus workspace to a system
index plus workspace.

The backend compute predicate is

```lean
expandedArithmeticBackendComputesCubicAmplitude backend
```

which means that the backend workspace count equals `workspaceQubits` and, for
every `j : Fin (gridSize n)`, compute from the clean workspace preserves the
system index and writes
`CubicStatePreparation.cubicAmplitude n j` into the distinguished amplitude
register.

The route bridge predicate is

```lean
expandedArithmeticBackendBridge backend
```

which means that the backend compute predicate is accepted as the semantics of
the opaque route predicate
`expandedArithmeticComputesCubicAmplitude n workspaceQubits`.

The current compiled symbolic backend is

```lean
symbolicExpandedCubicArithmeticBackend n workspaceQubits :
  ExpandedCubicArithmeticBackend n workspaceQubits
```

and its pointwise compute proof is

```lean
symbolicExpandedCubicArithmeticBackend_computes n workspaceQubits :
  expandedArithmeticBackendComputesCubicAmplitude
    (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
```

## Local Proof Design

The active local theorem is not the opaque parent predicate by itself.  The
safe closure shape is the already compiled conditional theorem:

```lean
expandedArithmeticComputesCubicAmplitude_of_backendBridge
  backend hBackend hBridge
```

where

```lean
hBackend :
  expandedArithmeticBackendComputesCubicAmplitude backend

hBridge :
  expandedArithmeticBackendBridge backend
```

Natural-language proof under these inputs: fix
`j : Fin (gridSize n)`.  The second component of `hBackend`, specialized to
`j`, gives two facts.  First, the compute phase maps the system index back to
`j`.  Second, the amplitude register of the computed workspace equals
`CubicStatePreparation.cubicAmplitude n j`, which is the source value
$a_j=(j/2^n)^3$.  The first component of `hBackend` ties the backend workspace
count to `workspaceQubits`.  The bridge term `hBridge` then states that these
backend-level facts are the semantics of the route predicate.  Applying
`hBridge` to `hBackend` proves
`expandedArithmeticComputesCubicAmplitude n workspaceQubits`.

For the current symbolic backend, the first input is already compiled as
`symbolicExpandedCubicArithmeticBackend_computes n workspaceQubits`.  The
missing input is a concrete

```lean
expandedArithmeticBackendBridge
  (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
```

or a replacement register-level backend carrying the same pointwise compute
proof and an honest bridge.  Without such a bridge, the parent route predicate
must remain open.

## Proof-DAG Table

| Node | Interface | Dependencies | Status | Owner | Next route |
|---|---|---|---|---|---|
| `DIAG-ARITH-VALUE-001` | Identify $a_j$ with `CubicStatePreparation.cubicAmplitude n j`. | `DIAG-TGT-001` | proved by existing definitions | existing Lean | reuse `gridPoint` and `cubicAmplitude` |
| `DIAG-ARITH-BACKEND-SHAPE-001` | Instantiate an `ExpandedCubicArithmeticBackend`. | `DIAG-ARITH-VALUE-001`, workspace parameter | compiled for symbolic backend | existing Lean | reuse `symbolicExpandedCubicArithmeticBackend` |
| `DIAG-ARITH-BACKEND-COMPUTE-001` | Prove compute preserves `j` and writes `cubicAmplitude n j`. | `DIAG-ARITH-BACKEND-SHAPE-001` | compiled for symbolic backend | existing Lean | reuse `symbolicExpandedCubicArithmeticBackend_computes` |
| `DIAG-ARITH-BACKEND-BRIDGE-001` | Supply the backend-to-route bridge for the selected backend. | `DIAG-ARITH-BACKEND-COMPUTE-001`, route semantics | active leaf; blocked without a concrete backend-semantics witness | next Lean worker or obligation recorder | provide `expandedArithmeticBackendBridge` for the symbolic backend, or replace it with a register-level backend and bridge |
| `DIAG-EXP-ARITH-001` | Derive `expandedArithmeticComputesCubicAmplitude n workspaceQubits`. | `DIAG-ARITH-BACKEND-BRIDGE-001` | conditional theorem compiled | next Lean worker after bridge | apply `expandedArithmeticComputesCubicAmplitude_of_backendBridge` |
| `DIAG-EXP-UNCOMP-001` | Prove clean uncompute for the workspace. | `DIAG-EXP-ARITH-001`, rotation bridge | later leaf | future lower worker | do not merge into this arithmetic bridge task |

Next active leaf for a Lean implementation worker:
`DIAG-ARITH-BACKEND-BRIDGE-001`.

## Ordered Lean Lemmas And Declarations

1. Reuse `CubicStatePreparation.gridPoint` and
   `CubicStatePreparation.cubicAmplitude` for the source value
   $a_j=(j/2^n)^3$.
2. Reuse `CubicDiagonalOracle.cubicAmplitude_nonneg` and
   `CubicDiagonalOracle.cubicAmplitude_le_one` only if the chosen backend needs
   range side conditions.  These lemmas do not prove the bridge.
3. Reuse `symbolicExpandedCubicArithmeticBackend n workspaceQubits` for the
   current symbolic backend shape.
4. Reuse
   `symbolicExpandedCubicArithmeticBackend_computes n workspaceQubits` for the
   pointwise compute proof.
5. Supply a new honest witness of
   `expandedArithmeticBackendBridge
     (symbolicExpandedCubicArithmeticBackend n workspaceQubits)`, or replace
   the symbolic backend with a register-level backend and prove the same bridge
   for that backend.
6. Apply
   `expandedArithmeticComputesCubicAmplitude_of_backendBridge backend hBackend
     hBridge`.

Downstream declarations `expandedControlledRyUsesCubicAngle`,
`expandedWorkspaceCleanUncomputed`, and
`expandedAmplitudeOracleCleanBlockExtracts` are out of scope for this leaf.

## Failure Analysis

The target is mathematically consistent: it remains the diagonal operator with
normalizer `alpha = 1`, not a rank-one state-preparation target.

The current implementation target cannot honestly be closed by unfolding the
symbolic backend.  The symbolic backend proves only the pointwise compute
contract.  The parent predicate
`expandedArithmeticComputesCubicAmplitude n workspaceQubits` is opaque, and the
bridge
`expandedArithmeticBackendBridge
  (symbolicExpandedCubicArithmeticBackend n workspaceQubits)`
requires route-semantics evidence that the symbolic backend is the arithmetic
backend used by the expanded construction.

The correct narrow route is therefore one of:

1. provide a concrete route-semantics witness for the symbolic backend;
2. replace the symbolic backend with a register-level backend whose workspace
   representation, compute semantics, and bridge are all explicit; or
3. record `workspace_representation_specified=false` as the blocker and leave
   `expandedArithmeticComputesCubicAmplitude` open.

It would be an invalid route to close the bridge by `trivial`, an untracked
axiom, or by redefining the opaque route predicate as `True`.

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `DIAG-ARITH-BACKEND-BRIDGE-001` |
| `source_correspondence_ok` | `true` |
| `finite_matrix_ok` | `true`, inherited from the previous arithmetic/register diagnostic because this pass does not change the backend |
| `block_entry_ok` | `null`, clean-block extraction is downstream |
| `ancilla_cleanup_ok` | `null`, clean uncompute is downstream |
| `normalizer_ok` | `true` |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `supply expandedArithmeticBackendBridge for symbolicExpandedCubicArithmeticBackend, or replace it with a register-level backend carrying the same pointwise compute proof and bridge` |

## Handoff

`DIAG-ARITH-BACKEND-BRIDGE-001` remains the active proof leaf.  The Lean worker
should use the compiled symbolic backend and pointwise compute proof, then
supply an honest `expandedArithmeticBackendBridge` witness or replace the
backend with a register-level one.  The parent predicate should close only via
`expandedArithmeticComputesCubicAmplitude_of_backendBridge`.  Rotation backend,
clean uncompute, extraction, root certificate, and executable exports remain
blocked downstream.
