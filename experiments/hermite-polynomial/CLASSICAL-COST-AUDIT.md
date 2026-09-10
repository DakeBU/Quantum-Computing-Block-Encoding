# Classical preprocessing cost audit

Date: 2026-09-10. Scope: read-only review of `ThinLQ`, `TensorTrainCanonical`,
`RealIsometryCompletion`, and `AdjacentGivens`, with their directly relevant
Mathlib/angle dependencies. All paths below are repository-relative. This
audit changes no production source and makes no bit-complexity claim.

## Verdict

The four modules do **not** currently prove a polynomial classical
preprocessing bound. They do prove the mathematical factorization, canonical
chain, completion, and finite rotation-list semantics used by the quantum
preparation root. Those results remain valid; this is a missing cost/refinement
layer, not a failure of their matrix equalities or quantum gate-count bounds.

It would also be inaccurate to label all four constructions merely arbitrary
choice: `AdjacentGivens.decomposeSO` is an explicit recursive mathematical
construction. Its exact list-length theorem is useful algorithmic structure,
but does not count the work to obtain its entries and angles. In contrast,
ThinLQ and isometry completion actually obtain basis-extension witnesses from
classical existence theorems. TT canonicalization structurally composes the
existential LQ witnesses.

Neither the keyword `noncomputable` nor an audit showing only the standard
axioms `propext`, `Classical.choice`, and `Quot.sound` decides arithmetic
complexity. Proof-level classical reasoning is not itself the issue; the
missing evidence is an explicit costed witness-producing procedure and its
refinement theorem.

## Evidence by component

| Component | Certified source evidence | Missing for an algorithm/cost claim |
| --- | --- | --- |
| Thin LQ | `QuantumBlockEncoding/ThinLQ.lean:38` constructs the wide-case factors from `gramSchmidtOrthonormalBasis`; `:81` covers every shape, with exactly `min m n` orthonormal rows and no rank assumption. The tall branch explicitly takes `R=A`, `Q=I`. | The wide-case basis is not supplied by an explicit bounded completion algorithm. There is no arithmetic operation counter or factor-producing executable interface with a cost theorem. |
| Right-canonical TT | `QuantumBlockEncoding/TensorTrainCanonical.lean:58` gives residual absorption as a finite sum; `:84` inducts on the actual chain, invoking LQ once per core after recursively processing the tail. `:104`, `:113`, and `:203` prove active-rank bounds and no maximal-bond growth. | Replace the existential LQ call by a costed result; materialize absorption outputs; lift the local correctness and cost bounds through this existing structural recursion. Current `exists_rightCanonical` is a theorem, not an exported costed canonicalizer. |
| Active-isometry SO completion | `QuantumBlockEncoding/RealIsometryCompletion.lean:20` preserves arbitrary prescribed active-column positions; `:83` corrects orientation at an unused column; `:107` derives an unused position from `r<N`. | Basis extension is existential. The finite inverse-image/spare-position selections can be bounded searches, but no such algorithm or bound is proved. The determinant case split is mathematical, not a certified efficient determinant evaluation. |
| Adjacent Givens | `QuantumBlockEncoding/AdjacentGivens.lean:222`, `:231`, `:527`, `:535`, and `:597` define concrete sweeps and the inverse list. `:248`, `:544`, `:602`, and `:644` prove actual action; `:611` proves exactly `N*(N-1)/2` rotations, including harmless zero-pivot rotations. | No evaluation/storage model or scalar operation count. The returned list length does not charge evaluation of any real angle, matrix entry, or intermediate matrix. |

The choice dependency is visible, not inferred from terminology:

- `.lake/packages/mathlib/Mathlib/Analysis/InnerProductSpace/GramSchmidtOrtho.lean:317`
  defines `gramSchmidtOrthonormalBasis` by `.choose` from
  `exists_orthonormalBasis_extension_of_card_eq`.
- `.lake/packages/mathlib/Mathlib/Analysis/InnerProductSpace/PiL2.lean:1022`
  obtains a maximal orthonormal extension; `:1035` then obtains a basis and an
  extending equivalence. `RealIsometryCompletion.lean:48` consumes this result.
- `RealIsometryCompletion.lean:36` also uses `h.choose` for inverse images of
  the finite injection. That small finite lookup is not the main obstruction:
  it can be replaced by a scan without solving basis completion.

## Evaluation and primitive-model gaps

1. **Intermediate matrices are functions, not cached tables.**
   `AdjacentGivens.lean:20` returns a function whose selected entries read the
   previous matrix; `TensorTrainCanonical.lean:58` does the same for a sum.
   There is no stated single-evaluation or memoization contract for these
   nested expressions. A cost proof must charge reads/writes and require
   materialized intermediate entries, or supply an equivalent shared-DAG
   evaluation semantics. Adding a `let` around a matrix-valued function alone
   does not prove caching of each entry. No particular exponential lower
   bound is asserted here; the current definitions simply specify no runtime.

2. **The current Givens list builder is not a fused sweep.**
   At `AdjacentGivens.lean:535`, each column separately builds
   `columnSweepSteps A ...` and computes `columnSweep A ...` for the next
   column. `columnSweepSteps` itself recursively carries updated matrices.
   At `:231`, the head angle and `eliminateEntry` also separately mention
   `eliminationAngle`. These are exact semantic definitions, but the length
   proofs at `:241` and `:556` count only the list spine, for arbitrary `A`.

3. **Exact angle generation is not just field arithmetic.**
   `QuantumBlockEncoding/RealAmplitudePreparation.lean:143` defines
   `pairNorm x y = sqrt (x^2+y^2)`; `:152` defines `splitAngle` using zero/sign
   tests, division, and `Real.arccos`. `AdjacentGivens.lean:99` negates that
   angle, and `:20` uses its sine/cosine. A model allowing only
   addition/subtraction/multiplication/division cannot silently count these
   operations as unit-cost arithmetic. State an extended exact-real model
   with square root, exact comparisons, and separately charged angle
   primitives, or separate coefficient computation from symbolic angle
   emission. This audit does not request numerical approximation machinery.

4. **Determinant notation is not an efficient evaluator.**
   The sign branch at `RealIsometryCompletion.lean:92` has no cost theorem.
   `.lake/packages/mathlib/Mathlib/LinearAlgebra/Matrix/Determinant/Basic.lean:62`
   gives the permutation-sum specification. A proposed implementation should
   track orientation through known elementary operations/permutations, or
   prove a polynomial determinant algorithm; it must not assume evaluating
   the specification is cheap. The existing one-column sign-flip semantics
   at `RealIsometryCompletion.lean:62` and `:77` can be reused directly.

5. **Amplitude specifications are not a preprocessing recipe.**
   `TensorTrainCanonical.lean:138` sums over all binary words to specify mass;
   `:161` identifies that mass with the small residual boundary. The proof
   need not enumerate all words, and an algorithm should not do so. A raw
   Hermite norm supplier addresses the source/normalization edge, not the
   missing LQ/completion/angle costs. Likewise a quantum `gateCount` bound is
   not an operation count for generating gate parameters.

## Smallest reusable next formalization

The following is a proposed implementation/proof plan, **not existing API**.
It avoids rebuilding general Hilbert-space basis-extension machinery and
reuses the already generic rectangular single-column sweep lemmas.

### A. One costed, fused rectangular Givens kernel

Choose the exact-real primitive model first. Represent a finite stored matrix
and a rotation log as data, not arbitrary entry callbacks. A result should
return the updated stored matrix, emitted rotations, and a cost record. Prove
that its two semantic projections agree with `columnSweep` and
`columnSweepSteps`, including the zero-pair branch. Then fuse the full sweep.

Read the two pivot entries once. For `rho = sqrt (x*x+y*y)`, use
`c=x/rho`, `s=-y/rho` when `rho` is nonzero, and `c=1`, `s=0` otherwise.
The update `(u,v) -> (c*u-s*v, s*u+c*v)` agrees with the existing elimination
angle. Derive that equality from `splitAngle_real_firstColumn` (`:84`) and
the zero-pair lemma (`:168`). Record the corresponding angle separately;
the numerical row update need not repeatedly evaluate trigonometric calls.

Required new theorems: coefficient normalization/zero handling; stored row
update refinement; fused sweep refinement; and a counter recurrence charging
each scalar operation and each angle emission once. Under this proposed
materialized model, a two-row update of an `N x M` matrix uses `6*M + O(1)`
field operations, plus one square root, comparisons, and a constant number of
angle operations. Summing over the already proved `N*(N-1)/2` rotations would
give a cubic square-matrix target. This bound is not yet Lean-certified.

### B. Derive both missing factor suppliers from that kernel

**Thin LQ:** for `A : m x n` with `m <= n`, apply the rectangular elimination
to `A.transpose`. Maintain a materialized orthogonal row-transform `E` while
zeroing entries below the first `m` pivots; the current single-column lemmas
already allow rectangular matrices and zero pivots. Prove the missing
multi-column upper-trapezoidal invariant. If `E*A.transpose = [B;0]`, take
`R=B.transpose` and `Q` equal to the first `m` rows of `E`. Then
`A=R*Q` and `Q*Q.transpose=I`, without any full-rank assumption. The existing
tall-case `R=A,Q=I` branch stays unchanged. No equality to the current
choice-selected factors is required: satisfy the same factor contract.

**Isometry completion:** for `V : N x r`, `r<N`, sweep its `r` orthonormal
columns to the first `r` coordinate vectors while accumulating `E`.
Every processed column has an available row below its pivot; its nonnegative
pivot and unit norm make it exactly a unit coordinate column. Thus the first
`r` columns of `E.transpose` are exactly `V`, and the row rotations already
give determinant one. For arbitrary physical positions `e`, construct a
finite permutation by retaining the prescribed images and filling the unused
positions in increasing order. Track its parity and, if necessary, negate an
unused column. Prove the label-permutation and parity invariants; this avoids
evaluating an arbitrary determinant or selecting a maximal basis.

The missing work is concrete: rectangular multi-column invariants,
accumulated-transform correctness, deterministic finite permutation extension,
and orientation tracking. Existing square-SO final-identity proofs do not by
themselves prove these new rectangular contracts. Empty matrices, `r=0`,
zero pivots, and deficient rows must remain supported. If only the local
compiler's specific active-position injection is needed first, specialize
the permutation proof to that injection before generalizing it.

With materialization, each rotation updates both the rectangular input and
the stored transform. At most `m*n` rotations for thin LQ gives the candidate
bound `O(m*n*(m+n))`; at most `N*r` rotations for isometry completion gives
`O(N*r*(N+r))`. These are proposed cost recurrences to prove, not consequences
of the present existence theorems.

### C. Lift the suppliers through the actual chain

Export a data-returning canonicalization result with the existing
`RightCanonical`, `RankReduced`, and all-word contraction certificates.
Prove its cost by the same induction as `exists_rightCanonical`. With `n`
cores and `maxBond <= D`, an absorbed core has shape at most `D x (2*D)`;
each absorption has at most `2*D^3` scalar products to accumulate. Combine
the new local LQ bound with `RankReduced.maxBond_le`. This yields a target
`O(n*D^3)` in the proposed model; no whole-state amplitude table is needed.
Materialized input-core access/source construction costs must be included or
explicitly supplied by a separate input-cost contract.

For padded local stages with bond capacity `S`, the completion and square
decomposition dimensions are `N=2*S`. Their corresponding target contribution
is `O(n*S^3)` under the same model. These four-module bounds still would not
alone close the entire preprocessing pipeline: source generation,
normalization, and actual primitive-list/angle emission must have compatible
cost contracts too. In particular, the Gray compiler's quantum output-size
bound must not substitute for a classical emitter-cost proof.

## Acceptance criteria for the next bounded worker

- The producer returns concrete data and a counted run; a wrapper choosing an
  existing existential witness plus a separately asserted polynomial is not
  sufficient. Counter definitions must charge every executed local step.
- Prove refinement to the present factor/column/action contracts, not to an
  assumed target-state equality or a supplied global circuit action.
- Cover repeated nonzero rows, all-zero matrices, zero dimensions, zero pairs,
  an isometry with negative orientation requiring an unused-column sign flip,
  and non-prefix active positions. Keep the `r=N` orientation obstruction
  explicit; the completion claim here requires `r<N`.
- Check the cost recurrence symbolically for all dimensions and audit the
  theorem axioms. Small examples and measured timings alone are not a bound.
- Do not count proof checking, dense `contract`/`chainMass` specification
  evaluation, or a real-number implementation's bit operations as covered by
  the proposed exact-real arithmetic theorem.

## Audit provenance and limits

The scoped source/flag scan found no `sorry`, `admit`, `unsafe`, custom axiom,
`implemented_by`, or kernel-check skipping flag. The `True` base case of
`RightCanonical` is the legitimate empty-chain predicate; occurrences of
`False.elim` discharge impossible finite-index cases, not semantic shortcuts.
The four files contain no arithmetic-cost counter or runtime-bound theorem.
This turn did not rebuild unchanged production modules; earlier semantic
tests/handoffs are recorded in this directory and
`_out/hermite-poly-search/givens/`. Full integration gates remain with the
parent task. The AdjacentGivens author supplied a read-only explanation of
the duplicate sweep/uncached entry issue; this audit independently checked
the cited definitions. No source was changed to make this assessment pass.

Audited SHA256 snapshots:

- `QuantumBlockEncoding/ThinLQ.lean`:
  `40C0C7680F93A7365D95C68E4C3607AB20F52D1E62771DC98D6A6D8C3F39C07A`
- `QuantumBlockEncoding/TensorTrainCanonical.lean`:
  `B8D1EB0651708AC2496BE306E2D4B6F3025F7EA4D35A8C6907DE02B89D1D981F`
- `QuantumBlockEncoding/RealIsometryCompletion.lean`:
  `2A38BFA0DDA457B563F5178E20DC2CCBB1281FF7D5F7357E4096A3C29FA2BB5D`
- `QuantumBlockEncoding/AdjacentGivens.lean`:
  `A43C3B4F543738CB317BE01FA664FD466BFA28E21C33D10C7A90E74037A58D9C`
