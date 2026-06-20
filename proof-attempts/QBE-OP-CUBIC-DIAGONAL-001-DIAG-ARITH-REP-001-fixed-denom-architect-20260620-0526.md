# QBE-OP-CUBIC-DIAGONAL-001 DIAG-ARITH-REP-001 Fixed-Denominator Proof Design

Updated: 2026-06-20 05:26 JST

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

The Lean target remains the diagonal matrix

$$
D_n[row,col] =
\begin{cases}
(row/2^n)^3, & row = col,\\
0, & row \ne col.
\end{cases}
$$

The arithmetic payload for row `j` is
$a_j=(j/2^n)^3$, represented by
`CubicStatePreparation.cubicAmplitude n j`.

## Definitions For The Representation Candidate

Fix `n : Nat`.  The representation candidate for `DIAG-ARITH-REP-001` is a
fixed-denominator numerator workspace.

Define the payload denominator by

$$
Q_n = 2^{3n}.
$$

In Lean this should be represented as `gridSize (3 * n)`.  The existing theorem
`CubicStatePreparation.gridSize_three_mul_eq_cube n` identifies this with
`gridSize n ^ 3`.

Define the payload numerator for `j : Fin (gridSize n)` by

$$
Y_j = j^3.
$$

The concrete workspace register is a `3 * n`-qubit payload register with basis
`Fin (gridSize (3 * n))`.  The clean workspace value is `0`.  The distinguished
amplitude-register projection sends a payload `y` to

$$
\operatorname{amp}(y) = y/Q_n.
$$

The compute phase sends the clean input workspace to

$$
(j,0) \mapsto (j,Y_j).
$$

This is only the compute-phase representation.  It does not prove clean
uncompute, controlled-`R_y` backend semantics, clean-block extraction,
unitarity, a root block-encoding certificate, or an executable export.

The concrete workspace count for this representation is `3 * n`.  If a later
route wants extra padding, it should introduce a padding parameter and prove a
separate embedding lemma.  The immediate Lean route should not try to prove the
bridge for arbitrary `workspaceQubits` without a capacity relation.

## Natural-Language Proof Of The Local Representation Theorem

The local theorem for this leaf is that the fixed-denominator compute phase
preserves the system index and writes `CubicStatePreparation.cubicAmplitude n j`
into the distinguished payload projection.

For each `j : Fin (gridSize n)`, the bound `j.val < gridSize n` holds by
`j.isLt`.  Cubing both sides gives

$$
j^3 < (gridSize n)^3.
$$

The theorem `CubicStatePreparation.gridSize_three_mul_eq_cube n` rewrites the
right side as `gridSize (3 * n)`.  Therefore `j.val ^ 3` is a valid element of
the `3 * n`-qubit payload register.

The compute phase preserves the system index because its first component is
defined to be `j`.

The amplitude-register value after the compute phase is

$$
\frac{j^3}{gridSize(3n)}.
$$

Using `gridSize_three_mul_eq_cube`, this equals

$$
\frac{j^3}{(gridSize n)^3}.
$$

By the definitions of `CubicStatePreparation.gridPoint` and
`CubicStatePreparation.cubicAmplitude`, this is exactly

$$
\left(\frac{j}{gridSize n}\right)^3
=
CubicStatePreparation.cubicAmplitude\ n\ j.
$$

Thus the fixed-denominator backend can satisfy
`expandedArithmeticBackendComputesCubicAmplitude` after it is added to Lean.
This proof does not close `expandedArithmeticComputesCubicAmplitude n (3 * n)`,
because that route predicate is still opaque.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-TGT-001` | Diagonal target $D_n[row,col]$. | none | existing Lean | `cubicDiagonalOperator`, `cubicDiagonalTarget` | conversion window | `python3 tools/qbe.py check` | proved |
| `DIAG-RANGE-001` | Range $0 \le a_j \le 1$. | `gridPoint_nonneg`, `gridPoint_le_one` | existing Lean | `cubicAmplitude_nonneg`, `cubicAmplitude_le_one` | proof obligations | `python3 tools/qbe.py check` | proved |
| `DIAG-EXP-ARITH-BACKEND-001` | Symbolic compute backend preserves `j` and writes `a_j`. | expanded arithmetic interface | existing Lean | `symbolicExpandedCubicArithmeticBackend`, `symbolicExpandedCubicArithmeticBackend_computes` | verifier feedback | `python3 tools/qbe.py check` | compiled pointwise proof |
| `DIAG-ARITH-REP-001` | Name a concrete workspace/register/backend representation. | `DIAG-EXP-ARITH-BACKEND-001` | this lower architect | no Lean declaration yet | this file | `python3 tools/qbe.py check` | representation candidate specified; Lean declaration open |
| `DIAG-ARITH-FIXED-DENOM-CAP-001` | Prove `j.val ^ 3 < gridSize (3 * n)`. | `j.isLt`, `gridSize_three_mul_eq_cube` | next Lean worker | planned theorem | this file | `python3 tools/qbe.py check` | next active Lean leaf |
| `DIAG-ARITH-FIXED-DENOM-ALG-001` | Prove `(j.val : Rat)^3 / (gridSize (3 * n) : Rat) = CubicStatePreparation.cubicAmplitude n j`. | `DIAG-ARITH-FIXED-DENOM-CAP-001`, `gridPoint`, `cubicAmplitude`, rational division algebra | next Lean worker | planned theorem | this file | `python3 tools/qbe.py check` | pending |
| `DIAG-ARITH-FIXED-DENOM-BACKEND-001` | Define a backend with workspace `Fin (gridSize (3 * n))` and prove its pointwise compute contract. | capacity and algebra lemmas | next Lean worker | planned `fixedDenomCubicArithmeticBackend`, planned compute theorem | this file | `python3 tools/qbe.py check` | pending |
| `DIAG-ARITH-BACKEND-BRIDGE-001` | Bridge the backend compute proof to the route predicate. | a concrete backend plus a transparent or accepted backend-to-route semantics interface | future Lean worker after interface revision | current target `expandedArithmeticBackendBridge`; existing reduction `symbolicExpandedCubicArithmeticBackend_bridge_iff` | proof obligations | `python3 tools/qbe.py check` | blocked parent |
| `DIAG-EXP-ARITH-001` | Close `expandedArithmeticComputesCubicAmplitude`. | `DIAG-ARITH-BACKEND-BRIDGE-001` | future Lean worker | `expandedArithmeticComputesCubicAmplitude_of_backendBridge` | conversion window | `python3 tools/qbe.py check` | conditional closure compiled; route predicate unclosed |
| `DIAG-ROOT-001` | Certified block encoding for the diagonal operator. | arithmetic, rotation, uncompute, extraction, unitarity, resource proof | future Lean worker | no unconditional expanded certificate | candidate population | `python3 tools/qbe.py check` | blocked |

The next active Lean leaf is `DIAG-ARITH-FIXED-DENOM-CAP-001`, followed by
`DIAG-ARITH-FIXED-DENOM-ALG-001`.  A bridge worker should not attack
`DIAG-ARITH-BACKEND-BRIDGE-001` until the fixed-denominator backend is compiled
and the route predicate has an honest backend-to-route interface.

## Ordered Lean Lemmas And Reuse Plan

1. Reuse `CubicStatePreparation.cubicAmplitude n j` as the source value
   $a_j=(j/2^n)^3`.
2. Reuse `CubicStatePreparation.gridPoint n j` and `gridSize n` for the grid
   denominator.
3. Reuse `CubicStatePreparation.gridSize_three_mul_eq_cube n` to rewrite
   `gridSize (3 * n)` as `gridSize n ^ 3`.
4. Add `fixedDenomCubicPayload_lt_capacity`:
   for every `j : Fin (gridSize n)`, prove
   `j.val ^ 3 < gridSize (3 * n)`.
5. Add `fixedDenomCubicAmplitude_eq`:
   prove
   `(j.val : Rat) ^ 3 / (gridSize (3 * n) : Rat) =
    CubicStatePreparation.cubicAmplitude n j`.
6. Add `fixedDenomCubicArithmeticBackend n :
   ExpandedCubicArithmeticBackend n (3 * n)`.
7. Add `fixedDenomCubicArithmeticBackend_computes n :
   expandedArithmeticBackendComputesCubicAmplitude
     (fixedDenomCubicArithmeticBackend n)`.
8. Do not add a theorem of
   `expandedArithmeticBackendBridge (fixedDenomCubicArithmeticBackend n)` until
   `expandedArithmeticComputesCubicAmplitude` has a transparent constructor,
   an equivalent non-opaque route predicate, or an explicit accepted bridge
   interface.  The current opaque predicate cannot be proved from the compute
   proof alone.

## Failure Analysis And Reroute

The diagonal target is mathematically consistent.  The fixed-denominator
representation is also consistent with the source equation: it stores the exact
integer numerator `j^3` and uses the fixed denominator `2^(3*n)`.

The currently blocked parent target is not ready as a direct Lean theorem.  The
existing symbolic bridge normal form
`symbolicExpandedCubicArithmeticBackend_bridge_iff` shows that a bridge for the
symbolic backend is equivalent to the opaque route predicate itself.  A direct
proof would add an unstated semantic assumption.

The fixed-denominator representation should replace the arbitrary symbolic
`Rat` workspace for the concrete arithmetic route.  It also specializes the
workspace size to `3 * n`.  A theorem for arbitrary `workspaceQubits` would
need either a padding representation or a hypothesis such as `3 * n <=
workspaceQubits`; neither is part of the current target and should not be added
silently.

The correct next route is therefore:

1. compile the fixed-denominator capacity and algebra lemmas;
2. compile the fixed-denominator backend and its pointwise compute proof;
3. ask middle or the next Lean worker to replace the opaque route predicate by
   a transparent backend-semantics predicate, or to add an explicit accepted
   bridge interface;
4. keep `DIAG-ARITH-BACKEND-BRIDGE-001`, clean uncompute, rotation backend,
   root certification, and exports blocked until those interfaces exist.

## Typed Verifier Feedback

```text
leaf=DIAG-ARITH-REP-001
blocked_parent=DIAG-ARITH-BACKEND-BRIDGE-001
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
workspace_representation_specified=true
lean_representation_declared=false
workspace_qubits=3*n
error_class=symbolic_bridge_gap
next_route=compile fixed-denominator capacity and amplitude-equality lemmas, then a backend compute proof; keep the opaque bridge blocked until a transparent backend-to-route semantics interface exists
```

## Handoff

`DIAG-ARITH-REP-001` now has a concrete natural-language representation
candidate: a `3 * n`-qubit fixed-denominator numerator register storing `j^3`
and projecting it as `j^3 / 2^(3*n)`.  The next Lean worker should first prove
the capacity and rational-amplitude equality lemmas, then add a backend compute
proof for `ExpandedCubicArithmeticBackend n (3 * n)`.  Do not attempt the
opaque bridge, clean uncompute, rotation backend witness, root certificate, or
Qiskit/QuantumKatas/QASM3 exports in this leaf.
