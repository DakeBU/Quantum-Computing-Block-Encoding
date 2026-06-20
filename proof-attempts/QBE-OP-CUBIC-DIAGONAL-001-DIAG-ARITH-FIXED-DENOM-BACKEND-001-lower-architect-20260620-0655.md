# QBE-OP-CUBIC-DIAGONAL-001 DIAG-ARITH-FIXED-DENOM-BACKEND-001 Proof Design

Updated: 2026-06-20 06:55 JST

Role: lower natural-language proof architect.

## Source Fragment

There is no paper-source archive for this user-provided operator task.  The
source equation being translated is

$$
O = \sum_{j=0}^{2^n-1} f(x_j)|j\rangle\langle j|,
\qquad
f(x)=x^3,
\qquad
x_j=j/2^n.
$$

The Lean target is the diagonal operator

$$
D_n[row,col] =
\begin{cases}
(row/2^n)^3, & row = col,\\
0, & row \ne col.
\end{cases}
$$

This leaf concerns only the arithmetic compute backend for the expanded route.
It does not certify the clean block, unitarity, clean uncompute, rotation
semantics, a root block encoding, or executable exports.

## Definitions Before The Claim

Fix `n : Nat` and `j : Fin (gridSize n)`.

The fixed-denominator representation uses a payload workspace
`Fin (gridSize (3 * n))`.  The clean workspace value is `0`.  The payload
written for system index `j` is `j.val ^ 3`.  The distinguished amplitude
projection maps a payload `y` to

$$
\operatorname{amp}(y) =
\frac{y}{gridSize(3n)}.
$$

The local backend should therefore be the record

```lean
def fixedDenomCubicArithmeticBackend (n : Nat) :
    ExpandedCubicArithmeticBackend n (3 * n) where
  Workspace := Fin (gridSize (3 * n))
  workspaceQubitCount := 3 * n
  workspaceQubitCount_eq := rfl
  zeroWorkspace := 0
  amplitudeRegister := fun y =>
    (y.val : Rat) / (gridSize (3 * n) : Rat)
  compute := fun j _workspace =>
    (j, ⟨j.val ^ 3, fixedDenomCubicPayload_lt_capacity n j⟩)
```

The local theorem should be

```lean
theorem fixedDenomCubicArithmeticBackend_computes (n : Nat) :
    expandedArithmeticBackendComputesCubicAmplitude
      (fixedDenomCubicArithmeticBackend n)
```

## Natural-Language Proof

The field `workspaceQubitCount_eq` proves the first conjunct of
`expandedArithmeticBackendComputesCubicAmplitude`, because the backend is
declared with `workspaceQubitCount := 3 * n` and target workspace size
`3 * n`.

For the pointwise conjunct, fix `j : Fin (gridSize n)`.  The compute phase is
defined to return

$$
(j, \langle j^3,\; fixedDenomCubicPayload\_lt\_capacity(n,j)\rangle).
$$

The first component is definitionally `j`, so the preservation proof is `rfl`.

The second component is a valid payload because
`fixedDenomCubicPayload_lt_capacity n j` proves

$$
j.val^3 < gridSize(3n).
$$

After the compute phase, the amplitude projection is

$$
\frac{j.val^3}{gridSize(3n)}.
$$

The compiled theorem `fixedDenomCubicAmplitude_eq n j` states exactly that this
quantity is `CubicStatePreparation.cubicAmplitude n j`.  Hence the worker can
close the amplitude-register equality by simplifying the backend definition and
applying that theorem, for example with:

```lean
simpa [fixedDenomCubicArithmeticBackend] using
  fixedDenomCubicAmplitude_eq n j
```

This proof does not imply `expandedArithmeticComputesCubicAmplitude n (3 * n)`.
The existing bridge normal forms show that the route predicate still needs an
honest backend-to-route semantics witness.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-TGT-001` | User diagonal target $D_n$. | none | existing Lean | `cubicDiagonalOperator`, `cubicDiagonalTarget` | conversion window | `python3 tools/qbe.py check` | proved |
| `DIAG-ARITH-REP-001` | Fixed-denominator representation: workspace `Fin (gridSize (3 * n))`, payload `j.val ^ 3`, projection by `gridSize (3 * n)`. | `DIAG-EXP-ARITH-BACKEND-001` | previous lower architect | proof-attempt representation packet | fixed-denom representation note | `python3 tools/qbe.py check` | specified |
| `DIAG-ARITH-FIXED-DENOM-CAP-001` | Payload fits in the `3 * n`-qubit workspace. | `j.isLt`, `gridSize_three_mul_eq_cube` | previous Lean worker | `fixedDenomCubicPayload_lt_capacity` | proof obligations | `python3 tools/qbe.py check` | proved |
| `DIAG-ARITH-FIXED-DENOM-ALG-001` | Payload projection equals `CubicStatePreparation.cubicAmplitude n j`. | capacity lemma, `gridPoint`, `cubicAmplitude`, rational algebra | previous Lean worker | `fixedDenomCubicAmplitude_eq` | proof obligations | `python3 tools/qbe.py check` | proved |
| `DIAG-ARITH-FIXED-DENOM-BACKEND-001` | Define the fixed-denominator backend and prove its pointwise compute contract. | CAP and ALG leaves | next Lean worker | planned `fixedDenomCubicArithmeticBackend`, planned `fixedDenomCubicArithmeticBackend_computes` | this file | `python3 tools/qbe.py check` | active leaf |
| `DIAG-ARITH-BACKEND-BRIDGE-001` | Connect the backend compute contract to the opaque expanded-route predicate. | fixed-denom backend plus transparent or accepted route semantics | future lower or middle worker | `expandedArithmeticBackendBridge`; normal form `expandedArithmeticBackendBridge_iff_of_computes` | proof obligations | `python3 tools/qbe.py check` | blocked internal |
| `DIAG-RY-BACKEND-WITNESS-001` | Provide concrete backend semantics for the controlled `R_y` angle convention. | scalar-tier bridge and backend rotation semantics | future worker | `expandedControlledRyBackendBridge` witness | conversion window | `python3 tools/qbe.py check` | blocked internal |
| `DIAG-ROOT-001` | Certified block encoding for the diagonal operator. | arithmetic bridge, rotation backend, clean uncompute, extraction, unitarity, resources | future worker | no unconditional expanded certificate yet | candidate population | `python3 tools/qbe.py check` | blocked |

The next active leaf for the Lean worker is exactly
`DIAG-ARITH-FIXED-DENOM-BACKEND-001`.

## Ordered Lean Lemmas And Reuse Plan

1. Reuse `ExpandedCubicArithmeticBackend` for the backend record shape.
2. Reuse `expandedArithmeticBackendComputesCubicAmplitude` for the pointwise
   compute contract.
3. Reuse `fixedDenomCubicPayload_lt_capacity n j` to construct the workspace
   element `⟨j.val ^ 3, _⟩`.
4. Reuse `fixedDenomCubicAmplitude_eq n j` to close the amplitude projection
   equality.
5. Add `fixedDenomCubicArithmeticBackend n :
   ExpandedCubicArithmeticBackend n (3 * n)`.
6. Add `fixedDenomCubicArithmeticBackend_computes n :
   expandedArithmeticBackendComputesCubicAmplitude
     (fixedDenomCubicArithmeticBackend n)`.
7. Do not attempt `expandedArithmeticBackendBridge
   (fixedDenomCubicArithmeticBackend n)` until a transparent or accepted
   backend-to-route semantics bridge exists.

## Failure Analysis And Reroute Boundary

The target is mathematically consistent: storing `j.val ^ 3` and dividing by
`gridSize (3 * n)` gives
`CubicStatePreparation.cubicAmplitude n j` by the compiled algebra lemma.

The mathematically wrong route would be to treat this compute proof as a proof
of the full expanded route.  The theorem
`expandedArithmeticBackendBridge_iff_of_computes` shows that, once a pointwise
compute proof is available, proving the bridge is equivalent to proving the
opaque route predicate itself.  Therefore a direct bridge attack would hide a
semantic assumption unless middle first introduces a transparent route
semantics interface or an accepted bridge witness.

The worker must also keep this as a diagonal operator task.  No rank-one
state-preparation target, normalized diagonal vector, arbitrary
`workspaceQubits` theorem, primitive oracle proof, or executable export belongs
to this leaf.

## Typed Verifier Feedback

```text
leaf=DIAG-ARITH-FIXED-DENOM-BACKEND-001
blocked_parent=DIAG-ARITH-BACKEND-BRIDGE-001
source_correspondence_ok=true
workspace_representation_specified=true
capacity_lemma_compiled=true
amplitude_eq_lemma_compiled=true
lean_parse_ok=null
lean_build_ok=null
qbe_check_ok=null
finite_arithmetic_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
closed_theorem_ok=false
error_class=lean_tactic_gap
next_route=add fixedDenomCubicArithmeticBackend and fixedDenomCubicArithmeticBackend_computes; keep the opaque backend bridge blocked
```

## Handoff

`DIAG-ARITH-FIXED-DENOM-BACKEND-001` is ready for a narrow Lean worker.  Add the
record `fixedDenomCubicArithmeticBackend n` with workspace
`Fin (gridSize (3 * n))`, clean value `0`, payload `j.val ^ 3`, and projection
`payload.val / gridSize (3 * n)`.  Then prove
`fixedDenomCubicArithmeticBackend_computes n` by `rfl` for index preservation
and `fixedDenomCubicAmplitude_eq n j` for the amplitude projection.  Keep
`DIAG-ARITH-BACKEND-BRIDGE-001`, rotation backend, clean uncompute, root
certificate, and executable exports blocked.
