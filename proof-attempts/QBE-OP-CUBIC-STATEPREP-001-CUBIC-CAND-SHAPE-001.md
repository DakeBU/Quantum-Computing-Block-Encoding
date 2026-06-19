# CUBIC-CAND-SHAPE-001 Proof Architecture

Task: `QBE-OP-CUBIC-STATEPREP-001`
Leaf: `CUBIC-HCOUNT-001`, spawned from `CUBIC-CAND-SHAPE-001`
Mode: exploratory construction
Author role: lower natural-language proof architect
Updated: `2026-06-19 15:20:41 JST`
Status: concrete candidate route designed; shared clean-block contract bridge
compiled; Hadamard-counting Lean interface compiled; ratio/counting and
semantic proofs remain open.

## Source Fragment

There is no paper-source archive for this task.  The source fragment is the
user/task operator target:

$$
N = 2^n,\qquad x_j = j/N,\qquad v_n[j] = x_j^3.
$$

The Lean-checkable target is the unnormalized rank-one operator

$$
O_n = |v_n><0^n|,\qquad v_n[j] = (j/2^n)^3.
$$

The local equation translated by this candidate is the scaled clean-block
entry

$$
{v_n[j] \over \alpha_n}
  = {j^3 \over 2^{4n}},
\qquad \alpha_n = N = 2^n.
$$

The candidate below realizes this value by exact path counting instead of a
variable rotation.  It is a block-encoding route for `O_n`, not a normalized
state-preparation unitary.

## Definitions

Fix `n : Nat` and set `N = gridSize n`.  The normalizer is
`alpha_n = conservativeNormalizer n = N`, whose conservative norm bridge is
already compiled as `cubicNormSq_le_conservativeNormalizer_sq`.

Use a path register split as

$$
r \in \{0,\ldots,N-1\},\qquad
t \in \{0,\ldots,N^3-1\}.
$$

The path space has size `M = N^4 = 2^(4*n)`.  For a fixed row `j`, exactly
`j^3` values of `t` satisfy `t < j^3`.

The proposed candidate family `U_n^count` uses these auxiliary registers:

| Register | Size | Role | Clean value |
| --- | ---: | --- | --- |
| `S` | `n` qubits | system input/output register | not auxiliary |
| `reject` | `1` qubit | signal qubit; rejects paths not satisfying `t < r^3` | `0` |
| `nz` | `1` qubit | nonzero-input flag; rejects columns `c != 0` | `0` |
| `R` | `n` qubits | row path register `r` | `0^n` |
| `T` | `3*n` qubits | threshold path register `t` | `0^(3*n)` |
| `W` | `poly(n)` qubits | reversible cube/comparator workspace | `0` |

The clean block projects all auxiliary registers to zero:

$$
B_n =
(<0_{\mathrm{aux}}| \otimes I) U_n^{count}
(|0_{\mathrm{aux}}> \otimes I).
$$

The oracle-level transcript is:

1. Compute `nz := [S != 0^n]`.
2. Controlled on `nz = 0`, apply Hadamards to `R` and `T`.
3. Controlled on `nz = 0`, XOR `R` into `S`.  On the only clean accepted
   input column, this changes `S = 0` into the output row `r`.
4. Controlled on `nz = 0`, reversibly compute `r^3` and compare `t < r^3`.
   Flip `reject` exactly when the comparison fails.
5. Uncompute the cube and comparator workspace.
6. Controlled on `nz = 0`, apply Hadamards again to `R` and `T`.

The expanded arithmetic tier is polynomial in `n` using reversible
multiplication and comparison.  The oracle-label tier should record the row
Hadamard pair, zero-input flag, cubic comparator, and uncomputation labels.
The route uses no amplitude-transduction rotation and has exact error `0`
once the Hadamard and reversible-arithmetic semantics are proved.

## Natural-Language Proof Of The Active Local Theorem

The active local theorem is the clean-block entry statement:

$$
B_n[j,c] =
\begin{cases}
j^3 / 2^{4n}, & c = 0,\\
0, & c \ne 0.
\end{cases}
$$

For a nonzero input column `c`, the first step sets `nz = 1`.  The clean
projector requires `nz = 0` at the output, so every nonzero input column has
zero clean-block amplitude.  This proves the off-column branch required by
`cubicOperator_only_first_column`.

For input column `0`, the flag `nz` remains zero.  After the first Hadamard
layer on `R,T`, each path `(r,t)` has amplitude `1 / sqrt(M)`.  The XOR from
`R` to `S` makes the system output row equal to `r`.  The comparator leaves
`reject = 0` exactly for paths satisfying `t < r^3`, and all arithmetic
workspace is uncomputed before the final projection.

Fix an output row `j`.  A path contributes to the clean amplitude for row `j`
if and only if `r = j` and `t < j^3`.  There are exactly `j^3` such paths.
The final Hadamard layer contributes another factor `1 / sqrt(M)` to the
projection of `R,T` back to zero.  Thus

$$
B_n[j,0]
  = {j^3 \over M}
  = {j^3 \over N^4}
  = { (j/N)^3 \over N}
  = {cubicAmplitude(n,j) \over conservativeNormalizer(n)}.
$$

Multiplying by `alpha_n = conservativeNormalizer n` gives

$$
\alpha_n B_n[j,c] = cubicOperator(n)[j,c]
$$

for every row `j` and column `c`.  Therefore the exact block-entry error is
zero, and the Scenario 2 approximation proposition follows with
`0 <= requestedEpsilon`.

The proof uses the unnormalized vector.  It does not assert that `v_n` is a
unit vector.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| CUBIC-TGT-001 | Rank-one target entries for `O_n = |v_n><0^n|`. | none | middle/Lean target | `cubicOperator`, `cubicOperator_first_column`, `cubicOperator_only_first_column` | conversion window | `python3 tools/qbe.py check` | proved |
| CUBIC-ALPHA-001 | Conservative normalizer is sufficient for the target norm. | CUBIC-TGT-001 | lower Lean refiner | `cubicNormSq_le_conservativeNormalizer_sq` | proof obligations | `python3 tools/qbe.py check` | proved |
| CUBIC-RANKONE-CONTRACT-001 | Reusable clean-block contract implies the scaled block is pointwise `O_n`. | CUBIC-TGT-001 | lower worker 5 | `rankOneCleanBlockContract`, `rankOneCleanBlockContract_pointwise_eq`, `arithmeticRankOneCubicCleanBlockContract_pointwise_eq` | candidate population and proof obligations | `python3 tools/qbe.py check` | compiled bridge |
| CUBIC-HCOUNT-IFACE-001 | Define the Hadamard-counting layout, transcript, normalizer, resource tuple, clean-block contract bridge, and normalizer bridge. | CUBIC-TGT-001, CUBIC-ALPHA-001 | lower Lean worker | `hadamardCountingCubicLayout`, `hadamardCountingCubicCircuit`, `hadamardCountingCubicNormalizer`, `hadamardCountingCubicResourceTuple`, `hadamardCountingCubicCleanBlockContract_pointwise_eq`, `cubicNormSq_le_hadamardCountingCubicNormalizer_sq` | this file, candidate population | `python3 tools/qbe.py check` | compiled interface; not a certificate |
| CUBIC-HCOUNT-RATIO-001 | Prove `cubicAmplitude n j / conservativeNormalizer n = j.val^3 / (gridSize n)^4`. | CUBIC-HCOUNT-IFACE-001, `gridSize_rat_ne_zero` | lower Lean worker | planned ratio lemma | this file | `python3 tools/qbe.py check` | active Lean leaf |
| CUBIC-HCOUNT-COUNT-001 | Prove that exactly `j^3` threshold paths satisfy `t < j^3` in a `3*n`-qubit register. | CUBIC-HCOUNT-RATIO-001, `j.isLt`, `gridSize_pos` | lower Lean worker | planned finite-count lemma | this file | `python3 tools/qbe.py check` | open |
| CUBIC-HCOUNT-UNITARY-001 | Prove the transcript is unitary as a composition of Hadamards and reversible permutations. | CUBIC-HCOUNT-IFACE-001, Hadamard/permutation semantics | future Lean backend | planned semantic theorem | this file | `python3 tools/qbe.py check` | blocked internal |
| CUBIC-HCOUNT-BLOCK-001 | Prove the clean block satisfies `rankOneCleanBlockContract n (conservativeNormalizer n)`. | CUBIC-RANKONE-CONTRACT-001, CUBIC-HCOUNT-COUNT-001, CUBIC-HCOUNT-UNITARY-001 | future Lean worker | planned clean-block theorem | this file | `python3 tools/qbe.py check` | blocked internal |
| CUBIC-HCOUNT-APPROX-001 | Package exact error `0` as an approximate block encoding at requested epsilon. | CUBIC-HCOUNT-BLOCK-001, `requestedEpsilon` positivity | future Lean worker | planned `VerifiedApproximateOperatorBlockEncoding` | this file | `python3 tools/qbe.py check` | blocked internal |
| CUBIC-VER-CAND-001 | Instantiate `n = 1` or `n = 2` and test clean-block entries. | CUBIC-HCOUNT-IFACE-001 | verifier lower | planned verifier-feedback packet | verifier-feedback | finite script plus `python3 tools/qbe.py check` | next diagnostic after interface |

The next active leaf for a Lean worker is `CUBIC-HCOUNT-RATIO-001`.  It should
prove only the rational amplitude/normalizer identity and should not attempt
the full semantic matrix.

## Intermediate Lean Lemmas In Dependency Order

1. Reuse `gridSize`, `gridSize_pos`, `gridSize_rat_ne_zero`, `gridPoint`,
   `cubicAmplitude`, `cubicOperator`, `cubicOperator_first_column`,
   `cubicOperator_only_first_column`, `conservativeNormalizer`,
   `cubicNormSq_le_conservativeNormalizer_sq`, `rankOneCleanBlockContract`,
   `rankOneCleanBlockContract_pointwise_eq`, `RegisterLayout`,
   `BlockEncodingCost.fromLayoutAndResource`, `Circuit`, `Gate.oneQubit`, and
   `Gate.oracleCall`.

2. `hadamardCountingCubicLayout (n : Nat)` is compiled, with `systemQubits = n`,
   one signal qubit for `reject`, and pure ancillas for `nz`, `R`, `T`, and
   arithmetic workspace.

3. `hadamardCountingCubicCircuit (n : Nat)` is compiled at the oracle-label
   tier.  The current interface records the path Hadamard layers as semantic
   labels; a future backend can refine these labels to explicit `Gate.oneQubit`
   Hadamards when the matrix semantics are introduced.

4. `hadamardCountingCubicNormalizer (n : Nat) := conservativeNormalizer n` and
   `cubicNormSq_le_hadamardCountingCubicNormalizer_sq` are compiled.

5. The resource tuple and `hadamardCountingCubicResource_eq` are compiled for
   the oracle-label resource count.  The default `n=2` tuple is
   `(7, 7, 21, 7)`.

6. Prove the ratio lemma:

   ```lean
   cubicAmplitude n j / conservativeNormalizer n =
     (j.val : Rat) ^ 3 / (gridSize n : Rat) ^ 4
   ```

   The proof should unfold `cubicAmplitude`, `gridPoint`, and
   `conservativeNormalizer`, then use `gridSize_rat_ne_zero`.

7. Prove the path-size identities `gridSize (4*n) = gridSize n ^ 4` and
   `gridSize (3*n) = gridSize n ^ 3`, or state equivalent local lemmas over
   powers of two if that is easier in the current arithmetic library.

8. Prove `j.val ^ 3 <= gridSize n ^ 3`, using `j.isLt` and monotonicity of
   multiplication on natural numbers.  This justifies the `3*n` threshold
   register.

9. Prove the finite-count lemma for thresholds:
   the number of `t : Fin (gridSize (3*n))` with `t.val < j.val ^ 3` is
   `j.val ^ 3`.

10. Reuse `rankOneCleanBlockContract_pointwise_eq` as the target-shape bridge.
    The Hadamard-counting proof should show that its clean block satisfies the
    contract instead of restating the rank-one support target.

11. Add or reuse a Hadamard-sandwich semantics lemma:
    a uniform path register, a Boolean clean predicate, and a final Hadamard
    projection contribute `accepted_path_count / path_count` to the clean
    block entry.

12. Prove `hadamardCounting_zero_nonfirst_columns` from the `nz` flag.

13. Prove `hadamardCounting_first_column_entry` from the path-count and ratio
    lemmas.

14. Package the exact block relation as an approximate block-encoding
    proposition with `epsilon = requestedEpsilon`.

## Failure Analysis

The target is mathematically consistent.  The previous arithmetic-transduction
candidate was under-specified as a rank-one block because it computed an
amplitude for an already-present index and therefore looked like a diagonal
amplitude oracle.

The Hadamard-counting route repairs that shape gap.  It creates the output row
from path bits only on the `c = 0` branch, and it routes every `c != 0` input
to a non-clean auxiliary flag.  The clean block is therefore rank-one.

The remaining blocker is not a changed scientific target.  It is a symbolic
bridge gap: the current Lean surface has circuit labels and finite matrices,
but no compiled Hadamard-sandwich semantic theorem or reversible comparator
semantics.  Those should be introduced as small proof-DAG blocks before a
large `VerifiedApproximateOperatorBlockEncoding` attempt.

## Typed Verifier Feedback

| Field | Value |
| --- | --- |
| `leaf` | `CUBIC-HCOUNT-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` for the counting interface and shared contract bridge |
| `lean_build_ok` | `true` after module check; full gate recorded by the lower handoff |
| `finite_matrix_ok` | `null` |
| `block_entry_ok` | `contract bridge compiled; finite candidate semantics not yet tested` |
| `ancilla_cleanup_ok` | `designed: reject, nz, path, and workspace all projected to zero` |
| `normalizer_ok` | `true for conservativeNormalizer via cubicNormSq_le_conservativeNormalizer_sq` |
| `unitarity_ok` | `designed as Hadamards plus reversible permutations; not yet a Lean theorem` |
| `resource_score` | `exact reversible path-counting tier; oracle-label tuple compiled as `(7, 7, auxiliaryQubits, 7)` with `n=2` diagnostic `(7, 7, 21, 7)` |
| `auxiliary_qubits` | `1 signal + 1 nz flag + 4*n path qubits + workspace seed hadamardCountingCubicWorkspace n` |
| `gate_count` | `7 at the oracle-label tier; expanded reversible arithmetic tier open` |
| `depth` | `7 at the oracle-label tier; expanded reversible arithmetic tier open` |
| `oracle_calls` | `7 at the oracle-label tier` |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `Prove CUBIC-HCOUNT-RATIO-001, or run n=1/n=2 clean-block finite diagnostics before attempting the Hadamard-sandwich semantic theorem.` |
