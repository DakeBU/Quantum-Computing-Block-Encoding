# CUBIC-HCOUNT-RATIO-001 Proof Architecture And Refiner Repair

Task: `QBE-OP-CUBIC-STATEPREP-001`
Leaf: `CUBIC-HCOUNT-RATIO-001`
Mode: exploratory construction
Author role: lower natural-language proof architect / lower Lean refiner
Updated: `2026-06-19 16:44:39 JST`
Status: Lean ratio bridge compiled; full Hadamard-counting block certificate
remains open.

## Source Fragment

There is no paper-source archive for this task.  The source anchor is the
user/task operator target

$$
N = 2^n,\qquad x_j = j/N,\qquad v_n[j] = x_j^3,
$$

with Lean target

$$
O_n = |v_n><0^n|.
$$

The Hadamard-counting route needs the local scaled-entry equation

$$
{v_n[j] \over \alpha_n}
  = {j^3 \over N^4},
\qquad \alpha_n = N.
$$

In Lean names this is the intended theorem

```lean
theorem cubicAmplitude_div_conservativeNormalizer_eq
    (n : Nat) (j : Fin (gridSize n)) :
    cubicAmplitude n j / conservativeNormalizer n =
      (j.val : Rat) ^ 3 / (gridSize n : Rat) ^ 4 := by
  ...
```

This equation is only the arithmetic ratio bridge.  It is not a Hadamard
semantics theorem, a unitarity theorem, or a block-encoding certificate.

## Failed Route And Error

Rejected theorem route:

```lean
-- This skips the active arithmetic bridge and still lacks a compiled
-- Hadamard-sandwich/comparator semantic matrix.
theorem hadamardCountingCubic_semanticCleanBlock
    (n : Nat) (block : Matrix (gridSize n) (gridSize n) Rat) :
    hadamardCountingCubicCleanBlockContract n block := by
  admit
```

Reported verifier failure before this repair:

```text
leaf=CUBIC-VER-CAND-001:HCOUNT-PATH
block_entry_ok=true for the exact path-count formula, not for a compiled circuit semantic matrix
normalizer_ok=true for alpha = conservativeNormalizer n in the checked entries
closed_theorem_ok=false
error_class=symbolic_bridge_gap
next_route=Prove CUBIC-HCOUNT-RATIO-001 and run finite n=1/n=2 Hadamard-counting semantic clean-block, unitarity, and ancilla-cleanup diagnostics before theorem promotion.
```

Rejected in-cycle tactic route for the ratio theorem:

```lean
unfold cubicAmplitude gridPoint conservativeNormalizer
field_simp [gridSize_rat_ne_zero n]
```

Lean error:

```text
error: unknown tactic
```

The same direct normalization route with `ring_nf` failed with
`error: unknown tactic`.  The repair therefore uses core `Rat` lemmas and
`grind`, which are available under the current project imports.

## Definitions

Fix `n : Nat` and set `N = gridSize n`.  For each
`j : Fin (gridSize n)`, the compiled definitions give

$$
gridPoint(n,j) = {j \over N},
\qquad
cubicAmplitude(n,j) = gridPoint(n,j)^3,
\qquad
conservativeNormalizer(n) = N.
$$

The denominator fact already compiled in Lean is
`gridSize_rat_ne_zero n : (gridSize n : Rat) != 0`.

The Hadamard-counting path space has size $N^4$.  A clean first-column
amplitude of $j^3/N^4$ is therefore the path-count value that must match
`cubicAmplitude n j / conservativeNormalizer n`.

## Natural-Language Proof

The active local theorem is the ratio identity

$$
{cubicAmplitude(n,j) \over conservativeNormalizer(n)}
  = {j^3 \over N^4}.
$$

Unfold `cubicAmplitude`.  The numerator becomes `gridPoint n j ^ 3`.  Unfold
`gridPoint`; this is $(j/N)^3$.  Unfold `conservativeNormalizer`; the extra
division is by `N`.  Thus the left hand side is

$$
\left({j \over N}\right)^3 {1 \over N}.
$$

Since `gridSize_rat_ne_zero n` proves $N \ne 0$ in `Rat`, rational field
arithmetic may collect the four denominator factors.  The result is

$$
{j^3 \over N^3}{1 \over N}
  = {j^3 \over N^4}.
$$

Substituting back `N = gridSize n` gives the Lean target.  This proof uses only
the compiled target definitions and does not normalize the vector `v_n`.

This leaf feeds the later Hadamard-counting clean-block proof as follows.  The
path-counting argument is expected to prove that the clean block has
first-column entry $j^3/N^4$.  The ratio lemma then rewrites that entry as
`cubicAmplitude n j / conservativeNormalizer n`, which is the first conjunct
of `rankOneCleanBlockContract` for alpha `conservativeNormalizer n`.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| CUBIC-TGT-001 | Rank-one target entries for `O_n = |v_n><0^n|`. | none | middle/Lean target | `cubicOperator`, `cubicOperator_first_column`, `cubicOperator_only_first_column` | conversion window | `python3 tools/qbe.py check` | proved |
| CUBIC-ALPHA-001 | Conservative normalizer is sufficient for the target norm. | CUBIC-TGT-001 | lower Lean | `cubicNormSq_le_conservativeNormalizer_sq`, `cubicNormSq_le_hadamardCountingCubicNormalizer_sq` | proof obligations | `python3 tools/qbe.py check` | proved |
| CUBIC-HCOUNT-IFACE-001 | Hadamard-counting layout, transcript, normalizer, resource tuple, and clean-block contract bridge. | CUBIC-TGT-001, CUBIC-ALPHA-001 | lower Lean | `hadamardCountingCubicLayout`, `hadamardCountingCubicCircuit`, `hadamardCountingCubicNormalizer`, `hadamardCountingCubicResourceTuple`, `hadamardCountingCubicCleanBlockContract_pointwise_eq` | candidate population | `python3 tools/qbe.py check` | compiled interface; not a certificate |
| CUBIC-HCOUNT-RATIO-001 | Prove `cubicAmplitude n j / conservativeNormalizer n = j.val^3 / (gridSize n)^4`. | CUBIC-HCOUNT-IFACE-001, rational division algebra | lower Lean refiner | `rat_div_cube_div_eq`, `cubicAmplitude_div_conservativeNormalizer_eq` | this file | `python3 tools/qbe.py check` | compiled arithmetic bridge; not a block certificate |
| CUBIC-HCOUNT-COUNT-001 | Prove exactly `j.val^3` accepted threshold paths in the `3*n`-qubit `T` register. | CUBIC-HCOUNT-RATIO-001, `j.isLt`, path-size lemmas | future Lean worker | planned finite-count lemma | CUBIC-HCOUNT proof notes | `python3 tools/qbe.py check` | open |
| CUBIC-HCOUNT-UNITARY-001 | Prove the transcript is unitary as Hadamards plus reversible permutations/comparators. | CUBIC-HCOUNT-IFACE-001, semantic gate contracts | future Lean backend | planned semantic theorem | CUBIC-HCOUNT proof notes | `python3 tools/qbe.py check` | blocked internal |
| CUBIC-HCOUNT-BLOCK-001 | Prove the clean block satisfies `rankOneCleanBlockContract n (conservativeNormalizer n)`. | CUBIC-HCOUNT-RATIO-001, CUBIC-HCOUNT-COUNT-001, CUBIC-HCOUNT-UNITARY-001 | future Lean worker | planned clean-block theorem | conversion window | `python3 tools/qbe.py check` | blocked internal |
| CUBIC-HCOUNT-APPROX-001 | Package exact block equality as zero approximation error at requested epsilon. | CUBIC-HCOUNT-BLOCK-001, `requestedEpsilon` nonnegativity | future Lean worker | planned approximate certificate | candidate population | `python3 tools/qbe.py check` | blocked internal |

The ratio leaf is now closed.  The next active lower leaf is the finite
Hadamard-counting semantic diagnostic; future Lean workers should still not
attempt `CUBIC-HCOUNT-BLOCK-001` until the path-count, unitarity, and cleanup
dependencies are available.

## Intermediate Lean Lemmas

1. Reuse `gridSize`, `gridPoint`, `cubicAmplitude`,
   `conservativeNormalizer`, and `gridSize_rat_ne_zero` from
   `QuantumBlockEncoding.CubicStatePreparation`.

2. Compiled local helper:

   ```lean
   theorem rat_div_cube_div_eq (a b : Rat) :
       (a / b) ^ 3 / b = a ^ 3 / b ^ 4 := by
     simp [Rat.div_def, Rat.pow_succ, Rat.inv_mul_rev, Rat.mul_assoc]
     grind [Rat.mul_comm, Rat.mul_assoc]
   ```

   This helper is definition-free and reusable for later dyadic amplitude
   ratios.  It does not need a nonzero-denominator assumption because `Rat`
   division is total in Lean.

3. Compiled direct target:

   ```lean
   theorem cubicAmplitude_div_conservativeNormalizer_eq
       (n : Nat) (j : Fin (gridSize n)) :
       cubicAmplitude n j / conservativeNormalizer n =
         (j.val : Rat) ^ 3 / (gridSize n : Rat) ^ 4 := by
     simpa [cubicAmplitude, gridPoint, conservativeNormalizer] using
       rat_div_cube_div_eq (j.val : Rat) (gridSize n : Rat)
   ```

   Earlier `field_simp` and `ring_nf` probes failed because those Mathlib
   tactics are not available in this minimal `Std`-based module.  A focused
   `Tests/Basic.lean` example checks the theorem at `n = 2`, `j = 3`.

4. After the ratio leaf compiles, keep the next arithmetic/counting leaves
   separate:

   - `gridSize (4*n) = gridSize n ^ 4`, or an equivalent path-space
     cardinality statement.
   - `gridSize (3*n) = gridSize n ^ 3`, or an equivalent threshold-register
     capacity statement.
   - `j.val ^ 3 <= gridSize n ^ 3`, using `j.isLt`.
   - a finite-count lemma: the number of `t : Fin (gridSize (3*n))` with
     `t.val < j.val ^ 3` is `j.val ^ 3`.

5. Reuse `rankOneCleanBlockContract` and
   `rankOneCleanBlockContract_pointwise_eq` for the final target-shape bridge.
   Do not restate the rank-one support theorem locally in the Hadamard-counting
   proof.

## Failure Analysis

The ratio target is mathematically correct and matches the task operator.  It
does not change the normalizer, does not normalize `v_n`, and does not mutate
the Hadamard-counting route.

The known failure mode is not the ratio equation.  The remaining blocker is
the symbolic bridge from oracle-label transcript to a semantic matrix:
Hadamard-sandwich amplitudes, reversible comparator semantics, path counting,
unitarity, and clean-ancilla cleanup are not yet compiled.  A proof of the
ratio lemma alone must not promote the candidate into the certified
population.

The stale route remains rejected: do not rerun
`candidate_interface_gap`, because the Hadamard-counting layout, normalizer,
projector contract, and resource tuple now compile.

## Typed Feedback

| Field | Value |
| --- | --- |
| `leaf` | `CUBIC-HCOUNT-RATIO-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `finite_matrix_ok` | `null` |
| `block_entry_ok` | `true for the symbolic ratio bridge only` |
| `ancilla_cleanup_ok` | `null` |
| `normalizer_ok` | `true for alpha = conservativeNormalizer n` |
| `unitarity_ok` | `null` |
| `resource_score` | `oracle-label tier; unchanged n=2 tuple (7, 7, 21, 7)` |
| `closed_theorem_ok` | `true for cubicAmplitude_div_conservativeNormalizer_eq; false for the full block certificate` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `Run finite n=1/n=2 Hadamard-counting semantic clean-block, unitarity, and ancilla-cleanup diagnostics before attempting CUBIC-HCOUNT-BLOCK-001.` |

Decision: keep the refiner repair.  It closes the active arithmetic bridge
without changing the theorem statement, normalizer, candidate circuit, or
operator target.
