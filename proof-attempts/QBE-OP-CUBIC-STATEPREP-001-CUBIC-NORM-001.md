# CUBIC-NORM-001 Proof Design

Task: `QBE-OP-CUBIC-STATEPREP-001`
Leaf: `CUBIC-NORM-001`
Mode: exploratory construction
Author role: lower natural-language proof architect
Updated: `2026-06-19 14:39:41 JST`
Status: proof design recorded; Lean theorem still open.

## Source Fragment

There is no paper-source theorem for this task.  The source fragment is the
user/task operator equation:

$$
N = 2^n,\qquad x_j = j/N,\qquad v_n[j] = x_j^3.
$$

The Lean-checkable operator is

$$
O_n = |v_n><0^n|,\qquad v_n[j] = (j/2^n)^3.
$$

The active local equation translates the squared norm of the first column:

$$
\|v_n\|^2
  = \sum_{j=0}^{N-1} (j/N)^6.
$$

For the closed-form route, the target expression is

$$
\sum_{j=0}^{N-1} (j/N)^6
 =
{(N-1)(2N-1)(3N^4 - 6N^3 + 3N + 1)\over 42N^5}.
$$

This is a norm/normalizer bridge only.  It is not a candidate unitary, a clean
block, or a normalized state-preparation claim.

## Definitions

Fix `n : Nat` and let `N = gridSize n = 2^n`.  The existing Lean declaration
`gridPoint n j` is `(j.val : Rat) / (N : Rat)`.  The existing declaration
`cubicAmplitude n j` is `(gridPoint n j)^3`.

The existing declaration `cubicNormSq n` is the `List.finRange N` fold

$$
\sum_{j : \mathrm{Fin}\ N} (cubicAmplitude\ n\ j)^2.
$$

The existing declaration `conservativeNormalizer n` is `(N : Rat)`.

## Natural-Language Proof Of The Closed Form

The local theorem is `cubicNormSq_closedForm`.  For fixed `n`, set
`N = gridSize n`.  Since `gridSize n = 2^n`, `N` is positive.

Unfolding `cubicNormSq`, `cubicAmplitude`, and `gridPoint` gives

$$
cubicNormSq(n)
  = \sum_{j=0}^{N-1} \left((j/N)^3\right)^2
  = \sum_{j=0}^{N-1} (j/N)^6.
$$

The denominator `(N : Rat)^6` is nonzero, so it can be factored out:

$$
\sum_{j=0}^{N-1} (j/N)^6
  = {1\over N^6}\sum_{j=0}^{N-1} j^6.
$$

Apply the recorded classical sixth-power sum identity with `m = N - 1`:

$$
\sum_{j=0}^{m} j^6
  =
{m(m+1)(2m+1)(3m^4+6m^3-3m+1)\over 42}.
$$

Substituting `m = N - 1` gives

$$
\sum_{j=0}^{N-1} j^6
  =
{(N-1)N(2N-1)
  (3(N-1)^4+6(N-1)^3-3(N-1)+1)\over 42}.
$$

The polynomial factor simplifies as

$$
3(N-1)^4+6(N-1)^3-3(N-1)+1
  = 3N^4 - 6N^3 + 3N + 1.
$$

Dividing by `N^6` and cancelling the single factor `N` proves

$$
cubicNormSq(n)
 =
{(N-1)(2N-1)(3N^4 - 6N^3 + 3N + 1)\over 42N^5}.
$$

The proof uses only the unnormalized vector entries.  No step changes
`O_n = |v_n><0^n|` into a normalized state-preparation target.

## Direct Normalizer Proof Route

The shortest route to `CUBIC-ALPHA-001` does not require the closed form.
For each `j : Fin N`, the inequality `j.val < N` and positivity of `N` imply

$$
0 \le j/N \le 1.
$$

Therefore

$$
0 \le (j/N)^6 \le 1.
$$

The fold defining `cubicNormSq n` has exactly `N` nonnegative summands, each at
most `1`, so

$$
cubicNormSq(n) \le N.
$$

Since `N >= 1`, also `N <= N^2`.  Because `conservativeNormalizer n = N`, this
proves

$$
cubicNormSq(n) \le (conservativeNormalizer(n))^2.
$$

This direct proof is a valid normalizer bridge.  It leaves the exact closed
form as a useful diagnostic theorem, but it can unblock candidate alpha work if
the sixth-power identity becomes a Lean arithmetic bottleneck.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| CUBIC-TGT-001 | Rank-one target entries for `O_n = |v_n><0^n|`. | none | middle/Lean target | `cubicOperator`, `cubicOperator_only_first_column` | `conversion-windows/QBE-OP-CUBIC-STATEPREP-001.md` | `python3 tools/qbe.py check` | proved |
| CUBIC-NORM-DEF-001 | Expand `cubicNormSq n` to the finite sum of `(j / gridSize n)^6`. | CUBIC-TGT-001, `gridSize`, `gridPoint`, `cubicAmplitude`, `cubicNormSq` | lower Lean | planned helper or first block of `cubicNormSq_closedForm` | this file | `lake build && lake build Tests` | next active leaf |
| CUBIC-NORM-SUM-001 | Formalize or import the sixth-power sum for `sum_{j=0}^{m} j^6`. | CUBIC-NORM-DEF-001, `classical-sixth-power-sum` ledger row | lower Lean | planned local helper | `research-wiki/cited-results/classical-power-sums.md` | `lake build && lake build Tests` | blocked external until proved locally |
| CUBIC-NORM-POLY-001 | Substitute `m = N - 1`, simplify the polynomial factor, and cancel one `N`. | CUBIC-NORM-SUM-001, `gridSize_pos` | lower Lean | planned helper inside `cubicNormSq_closedForm` | this file | `lake build && lake build Tests` | blocked internal |
| CUBIC-NORM-001 | Closed rational formula for `cubicNormSq n`. | CUBIC-NORM-DEF-001, CUBIC-NORM-SUM-001, CUBIC-NORM-POLY-001 | lower Lean | planned `cubicNormSq_closedForm` | conversion window, this file | `lake build && lake build Tests` | open |
| CUBIC-ALPHA-DIRECT-001 | Prove every summand of `cubicNormSq n` is at most `1`, so the norm square is at most `gridSize n`. | CUBIC-NORM-DEF-001, `Fin.isLt`, `gridSize_pos` | lower Lean | planned helper for `cubicNormSq_le_conservativeNormalizer_sq` | this file | `lake build && lake build Tests` | ready alternative leaf |
| CUBIC-ALPHA-001 | Prove `cubicNormSq n <= conservativeNormalizer n ^ 2`. | CUBIC-ALPHA-DIRECT-001 or CUBIC-NORM-001 | lower Lean | planned `cubicNormSq_le_conservativeNormalizer_sq` | proof obligations | `lake build && lake build Tests` | open |
| CUBIC-ERR-001 | Scenario 2 arithmetic, rotation, and block-entry error budget. | CUBIC-ALPHA-001 | lower architect/Lean later | `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-ERR-001.md` plus future Lean targets | proof attempt note | `python3 tools/qbe.py check` | designed, blocked |
| CUBIC-CAND-001 | Candidate unitary/circuit transcript and clean-block theorem. | CUBIC-ALPHA-001, CUBIC-ERR-001 | future lower Lean | planned candidate declaration | candidate population | `lake build && lake build Tests` | open |

The next active Lean leaf is `CUBIC-NORM-DEF-001`.  If the worker's goal is to
unblock candidate search rather than close the exact diagnostic formula, the
next route is `CUBIC-ALPHA-DIRECT-001`; that route preserves the target and
does not add assumptions.

## Intermediate Lean Lemmas In Dependency Order

1. Reuse `gridSize`, `gridPoint`, `cubicAmplitude`, `cubicNormSq`,
   `conservativeNormalizer`, `cubicNormSq_n1`, `cubicNormSq_n2`, and
   `cubicNormSq_n3`.

2. Add `gridSize_pos (n : Nat) : 0 < gridSize n`, proved from
   `gridSize` and `Nat.pow_pos`.

3. Add a rational nonzero denominator helper, for example
   `gridSize_rat_ne_zero (n : Nat) : not ((gridSize n : Rat) = 0)`.

4. Add `cubicAmplitude_sq_eq_sixth`, stating that
   `cubicAmplitude n j ^ 2 = ((j.val : Rat) / (gridSize n : Rat)) ^ 6`.

5. Add `cubicNormSq_eq_sixthPowerFold`, stating that the existing fold is the
   finite sixth-power sum over `List.finRange (gridSize n)`.

6. For the closed-form route, add `sum_finRange_sixth_power` or a task-local
   helper equivalent to `classical-sixth-power-sum`.  This helper remains an
   obligation until it builds.

7. Add the polynomial simplification helper for the substitution `m = N - 1`:
   `3*(N-1)^4 + 6*(N-1)^3 - 3*(N-1) + 1 =
   3*N^4 - 6*N^3 + 3*N + 1`, over `Rat` or over `Nat` followed by casting.

8. Prove `cubicNormSq_closedForm` from items 2 through 7.

9. For the direct normalizer route, add `gridPoint_nonneg` and
   `gridPoint_le_one`, using `j.val < gridSize n` and `gridSize_pos`.

10. Add `cubicAmplitude_sq_le_one`, using the previous item and monotonicity
    of powers on nonnegative rationals.

11. Add a fold bound lemma specialized to this list:
    if every term in `List.finRange (gridSize n)` is between `0` and `1`, then
    the fold sum is at most `(gridSize n : Rat)`.

12. Prove `cubicNormSq_le_conservativeNormalizer_sq` from the fold bound,
    `conservativeNormalizer`, and `(1 : Rat) <= (gridSize n : Rat)`.

## Failure Analysis

The current mathematical target is correct.  The planned norm formula matches
the rank-one operator with entries `(j/2^n)^3`, and the finite diagnostic found
no counterexample.

The main risk is not source mismatch.  The risk is a symbolic bridge gap in
the current Lean surface, because the project imports `Std` and does not yet
expose a broad algebra or finite-sum library.  If the closed-form proof stalls,
the next route should be the direct conservative-normalizer bound
`CUBIC-ALPHA-DIRECT-001`, not a candidate unitary proof and not a normalized
state-preparation shortcut.

No candidate `U_n`, block projector, clean-ancilla condition, or resource
tuple should be assigned until `CUBIC-ALPHA-001` is closed.

## Typed Verifier Feedback

| Field | Value |
| --- | --- |
| `leaf` | `CUBIC-NORM-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `null` |
| `lean_build_ok` | `null` |
| `finite_matrix_ok` | `true` |
| `block_entry_ok` | `null` |
| `ancilla_cleanup_ok` | `null` |
| `normalizer_ok` | `false` |
| `unitarity_ok` | `null` |
| `resource_score` | `not a candidate; diagnostic route only` |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `Implement CUBIC-NORM-DEF-001 as the smallest Lean leaf, then choose either the sixth-power closed form or the direct conservative-normalizer bound. Do not start U_n or block-entry proofs before CUBIC-ALPHA-001 closes.` |
