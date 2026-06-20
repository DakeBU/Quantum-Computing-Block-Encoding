# QBE-OP-CUBIC-DIAGONAL-001 DIAG-ARITH-FIXED-DENOM-CAP-001 Proof Design

Updated: 2026-06-20 06:08 JST

Role: lower natural-language proof architect.

Post-gate synchronization, 2026-06-20 06:14 JST: the current Lean source now
contains compiled declarations `fixedDenomCubicPayload_lt_capacity` and
`fixedDenomCubicAmplitude_eq`.  This file remains the proof design for those
two leaves.  The next implementation leaf is
`DIAG-ARITH-FIXED-DENOM-BACKEND-001`, not another capacity or rational-algebra
attempt.

## Source Fragment

There is no paper-source archive for this user-provided operator task.  The
source fragment being translated is

$$
O = \sum_{j=0}^{2^n-1} f(x_j)|j\rangle\langle j|,
\qquad
f(x)=x^3,
\qquad
x_j=j/2^n.
$$

The Lean target remains the diagonal operator

$$
D_n[row,col] =
\begin{cases}
(row/2^n)^3, & row = col,\\
0, & row \ne col.
\end{cases}
$$

The active arithmetic value is
`CubicStatePreparation.cubicAmplitude n j`, not a normalized state vector.

## Definitions Before Claims

Fix `n : Nat` and `j : Fin (gridSize n)`.  Define

$$
g_n = gridSize(n)=2^n,
\qquad
Q_n = gridSize(3n)=2^{3n},
\qquad
Y_j=j.val^3.
$$

The fixed-denominator representation from `DIAG-ARITH-REP-001` uses a payload
workspace with basis `Fin (gridSize (3 * n))`.  The clean workspace value is
`0`.  The compute phase sends the clean workspace to payload `Y_j`; the
distinguished amplitude projection interprets a payload `y` as
`(y : Rat) / (gridSize (3 * n) : Rat)`.

The first local Lean theorem should prove that the payload is in range:

```lean
theorem fixedDenomCubicPayload_lt_capacity
    (n : Nat) (j : Fin (gridSize n)) :
    j.val ^ 3 < gridSize (3 * n)
```

The second local Lean theorem should prove that the projected payload equals
the source arithmetic amplitude:

```lean
theorem fixedDenomCubicAmplitude_eq
    (n : Nat) (j : Fin (gridSize n)) :
    (j.val : Rat) ^ 3 / (gridSize (3 * n) : Rat) =
      CubicStatePreparation.cubicAmplitude n j
```

These lemmas do not prove the opaque route predicate
`expandedArithmeticComputesCubicAmplitude`, clean uncompute, rotation backend
semantics, extraction, unitarity, a root certificate, or any executable export.

## Natural-Language Proof

The capacity proof starts from `j.isLt`, which gives
`j.val < gridSize n`.  Since the exponent `3` is nonzero, strict monotonicity
of natural-number powers gives

$$
j.val^3 < (gridSize n)^3.
$$

The compiled identity
`CubicStatePreparation.gridSize_three_mul_eq_cube n` rewrites the right-hand
side to `gridSize (3 * n)`.  Therefore `j.val ^ 3` is a valid payload value in
the `3 * n`-qubit workspace.  This argument also covers `n = 0`; the finite
index condition then forces `j.val = 0`, and the same strict power lemma proves
`0^3 < 1^3`.

The amplitude-equality proof uses the same denominator identity.  After
casting `gridSize_three_mul_eq_cube n` to `Rat`, the left side becomes

$$
\frac{(j.val)^3}{(gridSize n)^3}.
$$

By the definitions of `CubicStatePreparation.gridPoint` and
`CubicStatePreparation.cubicAmplitude`, the target right side is

$$
\left(\frac{j.val}{gridSize n}\right)^3.
$$

Expanding `Rat.div_def` and `Rat.pow_succ` reduces both expressions to the
same commutative product of three numerator factors and three inverse
denominator factors.  The existing style in
`CubicStatePreparation.rat_div_cube_div_eq` shows that `simp` plus `grind`
over `Rat.mul_comm` and `Rat.mul_assoc` is the intended local algebra route.

## Lean Worker Sketch

The first theorem was the assigned active leaf.  The current Lean declaration
uses this proof shape:

```lean
theorem fixedDenomCubicPayload_lt_capacity
    (n : Nat) (j : Fin (gridSize n)) :
    j.val ^ 3 < gridSize (3 * n) := by
  have hpow : j.val ^ 3 < gridSize n ^ 3 :=
    Nat.pow_lt_pow_left j.isLt (by decide : 3 ≠ 0)
  simpa [CubicStatePreparation.gridSize_three_mul_eq_cube] using hpow
```

The second theorem is also compiled in the current Lean source.  Its proof
uses the same rational cube algebra pattern:

```lean
theorem fixedDenomCubicAmplitude_eq
    (n : Nat) (j : Fin (gridSize n)) :
    (j.val : Rat) ^ 3 / (gridSize (3 * n) : Rat) =
      CubicStatePreparation.cubicAmplitude n j := by
  have hdenNat := CubicStatePreparation.gridSize_three_mul_eq_cube n
  have hdenRat :
      (gridSize (3 * n) : Rat) = ((gridSize n ^ 3 : Nat) : Rat) := by
    exact congrArg (fun m : Nat => (m : Rat)) hdenNat
  have hdenRat' :
      (gridSize (3 * n) : Rat) = (gridSize n : Rat) ^ 3 := by
    simpa using hdenRat
  rw [CubicStatePreparation.cubicAmplitude, CubicStatePreparation.gridPoint,
    hdenRat']
  simp [Rat.div_def, Rat.pow_succ, Rat.inv_mul_rev, Rat.mul_assoc]
  grind [Rat.mul_comm, Rat.mul_assoc]
```

If the final `simpa` or `rw` orientation differs, the Lean worker should keep
the theorem statement fixed and only adjust the local cast/algebra proof.  It
should not add positivity hypotheses, change the workspace size, or replace
the diagonal target.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-TGT-001` | Diagonal target $D_n[row,col]$. | none | existing Lean | `cubicDiagonalOperator`, `cubicDiagonalTarget` | conversion window | `python3 tools/qbe.py check` | proved |
| `DIAG-RANGE-001` | Range $0 \le a_j \le 1$. | `gridPoint_nonneg`, `gridPoint_le_one`, `rat_pow_le_one_of_nonneg_le_one` | existing Lean | `cubicAmplitude_nonneg`, `cubicAmplitude_le_one` | proof obligations | `python3 tools/qbe.py check` | proved |
| `DIAG-EXP-ARITH-BACKEND-001` | Symbolic compute backend preserves `j` and writes `a_j`. | expanded arithmetic interface | existing Lean | `symbolicExpandedCubicArithmeticBackend`, `symbolicExpandedCubicArithmeticBackend_computes` | conversion window | `python3 tools/qbe.py check` | compiled pointwise proof |
| `DIAG-ARITH-REP-001` | Fixed-denominator representation: workspace `Fin (gridSize (3 * n))`, payload `j.val ^ 3`, projection by `gridSize (3 * n)`. | `DIAG-EXP-ARITH-BACKEND-001` | lower proof architect | no Lean declaration yet | `proof-attempts/QBE-OP-CUBIC-DIAGONAL-001-DIAG-ARITH-REP-001-fixed-denom-architect-20260620-0526.md` | `python3 tools/qbe.py check` | representation specified; Lean declarations open |
| `DIAG-ARITH-FIXED-DENOM-CAP-001` | Prove `j.val ^ 3 < gridSize (3 * n)`. | `DIAG-ARITH-REP-001`, `j.isLt`, `CubicStatePreparation.gridSize_three_mul_eq_cube` | Lean worker | `fixedDenomCubicPayload_lt_capacity` | this file | `python3 tools/qbe.py check` | proved in current Lean source |
| `DIAG-ARITH-FIXED-DENOM-ALG-001` | Prove projected payload equals `CubicStatePreparation.cubicAmplitude n j`. | `DIAG-ARITH-FIXED-DENOM-CAP-001`, `gridPoint`, `cubicAmplitude`, rational cube algebra | Lean worker | `fixedDenomCubicAmplitude_eq` | this file | `python3 tools/qbe.py check` | proved in current Lean source |
| `DIAG-ARITH-FIXED-DENOM-BACKEND-001` | Define the fixed-denominator backend and prove its pointwise compute contract. | `DIAG-ARITH-FIXED-DENOM-CAP-001`, `DIAG-ARITH-FIXED-DENOM-ALG-001` | next Lean worker | planned `fixedDenomCubicArithmeticBackend`, planned compute theorem | this file | `python3 tools/qbe.py check` | next active leaf |
| `DIAG-ARITH-BACKEND-BRIDGE-001` | Bridge a concrete backend to the opaque expanded arithmetic route predicate. | fixed-denominator backend plus transparent or accepted route semantics | future Lean worker after interface revision | target `expandedArithmeticBackendBridge`; existing normal form `expandedArithmeticBackendBridge_iff_of_computes` | proof obligations | `python3 tools/qbe.py check` | blocked parent |
| `DIAG-ROOT-001` | Certified block encoding for the diagonal operator. | arithmetic, rotation, clean uncompute, extraction, unitarity, resources | future Lean worker | no unconditional expanded certificate | candidate population | `python3 tools/qbe.py check` | blocked |

The next active leaf is `DIAG-ARITH-FIXED-DENOM-BACKEND-001`.

## Ordered Lean Lemmas And Reuse

1. Reuse `j.isLt : j.val < gridSize n`.
2. Reuse `Nat.pow_lt_pow_left` with exponent `3` to get strict cubic capacity.
3. Reuse `CubicStatePreparation.gridSize_three_mul_eq_cube n` to rewrite the
   payload capacity.
4. Reuse the compiled theorem `fixedDenomCubicPayload_lt_capacity`.
5. Cast `gridSize_three_mul_eq_cube n` to `Rat` for the denominator equality.
6. Reuse `CubicStatePreparation.gridPoint` and
   `CubicStatePreparation.cubicAmplitude`.
7. Reuse the rational algebra pattern from
   `CubicStatePreparation.rat_div_cube_div_eq`.
8. Reuse the compiled theorem `fixedDenomCubicAmplitude_eq`.
9. Next define `fixedDenomCubicArithmeticBackend n :
   ExpandedCubicArithmeticBackend n (3 * n)` and prove its pointwise compute
   theorem.

## Failure Analysis And Reroute

The fixed diagonal target is mathematically consistent.  The current target is
not the rank-one state-preparation problem, and this proof map does not
normalize the diagonal vector.

The fixed-denominator representation is consistent with the source equation:
it stores the numerator `j.val ^ 3` and interprets it over denominator
`2^(3*n)`.  The only active risk is Lean proof engineering for the two local
arithmetic lemmas.

Directly attacking `DIAG-ARITH-BACKEND-BRIDGE-001` remains the wrong route for
this lower worker.  The theorem
`expandedArithmeticBackendBridge_iff_of_computes` shows that, once a pointwise
compute proof exists, a bridge proof is equivalent to proving the opaque route
predicate itself.  A worker should not close that predicate by `trivial`, by
promoting semantic flags, or by adding a hidden assumption.  The bridge should
remain blocked until a transparent backend-to-route semantics interface exists
or an explicit accepted bridge witness is supplied.

## Typed Verifier Feedback

```text
leaf=DIAG-ARITH-FIXED-DENOM-CAP-001
parent=DIAG-ARITH-REP-001
blocked_parent=DIAG-ARITH-BACKEND-BRIDGE-001
source_correspondence_ok=true
lean_edits=false
lean_parse_ok=true
lean_build_ok=true
scratch_lean_skeleton_ok=true
finite_matrix_ok=null
finite_arithmetic_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
closed_theorem_ok=true
workspace_representation_specified=true
lean_representation_declared=true
capacity_lemma_compiled=true
amplitude_equality_compiled=true
workspace_qubits=3*n
error_class=stale_leaf
next_route=Do not reattempt the capacity or rational-amplitude leaves; define fixedDenomCubicArithmeticBackend and prove its pointwise compute contract, while keeping expandedArithmeticBackendBridge blocked.
```

## Handoff

`DIAG-ARITH-FIXED-DENOM-CAP-001` and
`DIAG-ARITH-FIXED-DENOM-ALG-001` are now closed in the current Lean source as
`fixedDenomCubicPayload_lt_capacity` and `fixedDenomCubicAmplitude_eq`.  The
next Lean worker should define `fixedDenomCubicArithmeticBackend n :
ExpandedCubicArithmeticBackend n (3 * n)` and prove its pointwise compute
contract using the two compiled lemmas.  Do not open the bridge, rotation
backend, clean uncompute, extraction, root certificate, or executable exports
in the backend-compute leaf.
