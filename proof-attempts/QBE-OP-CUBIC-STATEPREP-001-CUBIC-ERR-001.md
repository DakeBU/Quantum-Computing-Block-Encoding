# CUBIC-ERR-001 Proof Design

Task: `QBE-OP-CUBIC-STATEPREP-001`
Leaf: `CUBIC-ERR-001`
Mode: exploratory construction
Author role: lower natural-language proof architect
Updated: `2026-06-19 12:49:03 JST`
Status: designed in prose; Lean closure blocked on `CUBIC-ALPHA-001` and a
concrete candidate clean-block interface.

## Source Fragment

There is no paper-source theorem for this task.  The source fragment is the
user/task contract:

$$
N = 2^n,\qquad x_j = j/N,\qquad v_n[j] = x_j^3,
$$

with the Lean-checkable operator target

$$
O_n = |v_n><0^n|,\qquad v_n[j] = (j/2^n)^3.
$$

A Scenario 2 candidate must eventually prove

$$
\left\|O_n -
  \alpha \left((<0^a| \otimes I) U_n (|0^a> \otimes I)\right)
\right\| \le \epsilon,
$$

where `epsilon = CubicStatePreparation.requestedEpsilon`.  This is a
block-encoding target for the unnormalized rank-one operator, not a claim that
`v_n` is a normalized output state.

## Definitions For The Local Error Theorem

Fix `n : Nat`, let `N = gridSize n`, and let
`A_n = CubicStatePreparation.cubicOperator n`.

Let `alpha_n` be a positive normalizer.  The current compiled placeholder is
`CubicStatePreparation.conservativeNormalizer n`; its compatibility with
`A_n` is the blocked node `CUBIC-ALPHA-001`.

For a future candidate unitary `U_n` using `a` auxiliary qubits, write

$$
B_n = (<0^a| \otimes I) U_n (|0^a> \otimes I)
$$

for its clean signal-system block.  The candidate must define this projection
before any Lean proof is attempted.

The intended clean-block conditions are:

1. For every row `j`, the first-column scaled amplitude has entry error

   $$
   \left|v_n[j]/\alpha_n - B_n[j,0]\right| \le \delta_n.
   $$

2. For every column `c` with `c != 0`, the clean block has exact zero columns:

   $$
   B_n[j,c] = 0.
   $$

3. The scalar budget satisfies

   $$
   \alpha_n \sqrt{N}\,\delta_n \le \epsilon.
   $$

If the final candidate cannot prove exact zero columns, replace condition 2 by
a separate leakage budget and route through a Frobenius-norm bound.  That is a
different leaf from this first-column route.

## Natural-Language Proof Of The Local Theorem

The local theorem is:

For fixed `n`, `alpha_n`, and candidate clean block `B_n`, conditions 1, 2,
and 3 imply

$$
\|A_n - \alpha_n B_n\| \le \epsilon.
$$

The proof uses only the rank-one shape of the target.  For a column `c != 0`,
`A_n[j,c] = 0` by `CubicStatePreparation.cubicOperator_only_first_column`.
Condition 2 gives `B_n[j,c] = 0`, so the difference matrix
`Delta_n = A_n - alpha_n B_n` has zero columns away from column `0`.

For column `0`, condition 1 gives

$$
\left|\Delta_n[j,0]\right|
  = \left|v_n[j] - \alpha_n B_n[j,0]\right|
  \le \alpha_n \delta_n.
$$

Therefore `Delta_n` is a one-column matrix.  For every unit vector `x`,

$$
\Delta_n x = x_0 \Delta_n e_0.
$$

Since `|x_0| <= 1`, the norm of `Delta_n x` is at most the Euclidean norm of
the first column.  The first-column norm satisfies

$$
\|\Delta_n e_0\|^2
  = \sum_{j=0}^{N-1} |\Delta_n[j,0]|^2
  \le N(\alpha_n\delta_n)^2.
$$

Taking square roots and using condition 3 proves

$$
\|\Delta_n x\| \le \alpha_n\sqrt{N}\,\delta_n \le \epsilon
$$

for every unit vector `x`.  Hence the operator-norm approximation bound holds.
No step normalizes `v_n`; the normalizer is only the block-encoding scale
`alpha_n`.

## Arithmetic And Transduction Error Budget

The scalable candidate route should prove the first-column entry bound by
splitting the clean-block amplitude error into independent components.

For each row `j`, let

$$
a_j = v_n[j]/\alpha_n.
$$

The arithmetic circuit should produce a fixed-point value `p_j` such that

$$
|p_j - a_j| \le \eta_{\mathrm{arith}}.
$$

The amplitude-transduction gadget should convert `p_j` to a clean-block
amplitude with analytic error at most `eta_trans`, and the finite gate
synthesis of the required rotations should add amplitude error at most
`eta_synth`.  If reversible uncomputation and the input-zero test are exact,
there is no leakage term in this leaf.  The entry error is then bounded by

$$
\left|a_j - B_n[j,0]\right|
  \le \eta_{\mathrm{arith}}
     + \eta_{\mathrm{trans}}
     + \eta_{\mathrm{synth}}.
$$

A uniform safe split is

$$
\eta_{\mathrm{arith}},
\eta_{\mathrm{trans}},
\eta_{\mathrm{synth}}
  \le {\epsilon \over 3\alpha_n\sqrt{N}}.
$$

If the candidate carries a nonzero leakage allowance `eta_leak`, use four
equal entry-level shares and prove the separate leakage contribution before
promoting the candidate.

For arithmetic precision, the cubic polynomial has a simple local stability
bound on `[0,1]`.  If `x` and `x_hat` both lie in `[0,1]` and
`|x - x_hat| <= rho <= 1`, then

$$
|x^3 - x_{\mathrm{hat}}^3|
  \le 3\rho + 3\rho^2 + \rho^3
  \le 7\rho.
$$

Thus a fixed-point grid approximation with
`rho <= alpha_n * eta_arith / 7` suffices when the implementation approximates
`x_j` before cubing.  If the implementation computes `j^3 / N^3` exactly as
integer arithmetic before truncating to fixed point, then the arithmetic error
is only the final fixed-point truncation error.

For rotation synthesis, use the Lipschitz bound
`|sin theta - sin theta_hat| <= |theta - theta_hat|`.  A future Lean route can
therefore prove `eta_synth` from an angle-synthesis error bound of the same
size.  The analytic source for `asin` or other amplitude-transduction
contracts must be recorded before the candidate is marked proved.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration or artifact | Human proof map | Local gate | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| CUBIC-TGT-001 | Target operator entries for `O_n = |v_n><0^n|`. | none | middle/Lean target | `cubicOperator`, `cubicOperator_only_first_column` | `conversion-windows/QBE-OP-CUBIC-STATEPREP-001.md` | `python3 tools/qbe.py check` | proved |
| CUBIC-NORM-001 | Closed rational form for `cubicNormSq n`. | CUBIC-TGT-001, `classical-sixth-power-sum` | lower Lean | planned `cubicNormSq_closedForm` | conversion window | `lake build && lake build Tests` | next active Lean leaf |
| CUBIC-ALPHA-001 | Prove the chosen `alpha_n` is compatible with the target norm. | CUBIC-NORM-001 or an entrywise norm bound | lower Lean | planned `cubicNormSq_le_conservativeNormalizer_sq` | proof obligations | `lake build && lake build Tests` | blocked internal |
| CUBIC-ERR-ENTRY-001 | First-column entrywise bound plus zero off-columns implies operator-norm approximation. | CUBIC-ALPHA-001, concrete clean-block definition, norm backend | lower Lean | planned theorem | this file | `python3 tools/qbe.py check` then Lean gate after Lean edits | designed, blocked |
| CUBIC-ERR-SPLIT-001 | Arithmetic, transduction, and rotation errors sum to the entry budget. | CUBIC-ERR-ENTRY-001, candidate arithmetic contracts | lower architect then lower Lean | planned theorem or candidate-specific proof | this file | `python3 tools/qbe.py check` | designed, blocked |
| CUBIC-CAND-001 | Candidate unitary/circuit transcript, unitarity, clean block, and resource tuple. | CUBIC-ALPHA-001, CUBIC-ERR-001 | future lower Lean | planned candidate declaration | candidate population | `lake build && lake build Tests` | open |

Next active leaf for a Lean worker remains `CUBIC-NORM-001`.  After it closes,
the next narrow Lean target is `CUBIC-ALPHA-001`; only then should a worker try
to encode `CUBIC-ERR-ENTRY-001`.

## Intermediate Lean Lemmas In Dependency Order

1. Reuse `gridSize`, `cubicAmplitude`, `cubicOperator`,
   `cubicOperator_only_first_column`, and `requestedEpsilon`.

2. Add a small target-shape lemma if useful:
   `cubicOperator_first_column (n row col) (h : col.val = 0) :
   cubicOperator n row col = cubicAmplitude n row`.

3. Prove `cubicNormSq_closedForm`, reusing the planned
   `classical-sixth-power-sum` helper.

4. Prove `conservativeNormalizer_pos` and
   `cubicNormSq_le_conservativeNormalizer_sq`, or replace the latter by a
   sharper candidate-specific alpha theorem.

5. Define or reuse a clean-block extraction expression for
   `(<0^a| tensor I) U_n (|0^a> tensor I)`.  No current declaration fixes this
   matrix.

6. Add `cleanBlock_zero_nonfirst_columns` for the candidate's exact input-zero
   test.  This should reuse `cubicOperator_only_first_column` on the target
   side.

7. Add `firstColumn_entry_error_to_operator_error`, once a concrete finite
   vector/operator norm backend is available.  Until then, the project can keep
   this as the proposition used in
   `ApproximateOperatorBlockEncodingCandidate.approximationBound`.

8. Add candidate-specific arithmetic lemmas:
   `cubic_fixedPoint_error`, `amplitude_transduction_error`, and
   `rotation_synthesis_amplitude_error`.  These are external contracts until
   their source or Lean implementation is named.

9. Add `component_error_budget_sums`, proving that the chosen eta values imply
   `alpha_n * sqrt N * delta_n <= requestedEpsilon`.  A rational squared form
   may be easier than a square-root statement in Lean.

10. Package the final proof in a future
    `VerifiedApproximateOperatorBlockEncoding` record, reusing
    `OperatorBlockEncodingCandidate.cost` and `BlockEncodingCost` for the
    resource tuple.

## Failure Analysis

The current target is mathematically consistent: it is the rank-one operator
`|v_n><0^n|`, not a normalized state-preparation unitary.  The current local
theorem should not be implemented as a full candidate proof yet.

The blockers are:

- `CUBIC-ALPHA-001` is not proved, so `alpha_n` is not yet tied to the target
  norm.
- No candidate `U_n`, clean-block matrix `B_n`, or block projector declaration
  exists.
- The current approximate-candidate structure stores `approximationBound` as a
  `Prop`; a concrete operator norm backend is not yet present in the local
  Lean surface.

The next route is not broad `U_n` proof search.  First prove
`CUBIC-NORM-001`, then `CUBIC-ALPHA-001`, then implement the conditional
entrywise-to-operator-error lemma or a squared finite-norm surrogate.

## Typed Verifier Feedback

| Field | Value |
| --- | --- |
| `leaf` | `CUBIC-ERR-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `null` |
| `lean_build_ok` | `null` |
| `finite_matrix_ok` | `null` |
| `block_entry_ok` | `false` |
| `ancilla_cleanup_ok` | `false` |
| `normalizer_ok` | `false` |
| `unitarity_ok` | `null` |
| `resource_score` | `open; candidate family not yet declared` |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `Close CUBIC-NORM-001 and CUBIC-ALPHA-001 before encoding the first-column entry-error-to-operator-error lemma.` |

