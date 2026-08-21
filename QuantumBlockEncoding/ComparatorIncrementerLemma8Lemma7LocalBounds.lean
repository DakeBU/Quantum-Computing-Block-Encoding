import QuantumBlockEncoding.ComparatorIncrementerLemma7Contract
import QuantumBlockEncoding.ComparatorIncrementerLemma8Composition
import QuantumBlockEncoding.ComparatorIncrementerTheorem4DepthBound
import Mathlib.Tactic

/-!
# Lemma-7 local resource bounds inside Vandaele Lemma 8

Lemma 8 invokes Lemma 7 on block targets of width at most
`s = ceil(sqrt n)` with one external control.  The source proof then treats each
such promise increment/decrement as O(s) gates and O(log n) depth.

This file performs that substitution explicitly from the uniform Lemma-7
resource target.  No new circuit is assumed: the gate/depth functions are the
same functions certified by Lemma 7.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma8Lemma7LocalBounds

open ComparatorIncrementerLemma7Contract
open ComparatorIncrementerLemma8Budget
open ComparatorIncrementerLemma8Composition
open ComparatorIncrementerTheorem4DepthBound

/-- Positive target width gives a positive square-root block width. -/
theorem blockWidth_pos {n : Nat} (positive : 0 < n) : 0 < blockWidth n := by
  have capacity := block_capacity n
  nlinarith

/-- The square-root block width is at most n+1, a convenient totalized bound for
logarithmic comparison. -/
theorem blockWidth_le_succ (n : Nat) : blockWidth n ≤ n + 1 := by
  have ceiling := ComparatorIncrementerRecurrence.ceilSqrt_le_sqrt_add_one n
  have sqrtBound := Nat.sqrt_le_self n
  unfold blockWidth
  omega

/-- One-control Lemma-7 logarithmic argument for a block width w is bounded by a
constant multiple of the ambient Lemma-8 logarithmic scale. -/
theorem oneControl_logScale_le
    {n width : Nat} (positive : 0 < n)
    (widthBound : width ≤ blockWidth n) :
    Nat.log2 ((1 + 1) * (width + 1)) + 1 ≤
      3 * logScale n := by
  let rank := logScale n
  have widthGlobal : width ≤ n + 1 :=
    widthBound.trans (blockWidth_le_succ n)
  have argumentBound :
      2 * (width + 1) ≤ 4 * (n + 1) := by
    omega
  have nBelow : n + 1 < 2 ^ rank := by
    simpa [rank, logScale, ComparatorIncrementerTheorem4DepthBound.logRank] using
      succ_lt_two_pow_logRank n
  have fourBelow : 4 * (n + 1) < 2 ^ (rank + 2) := by
    have scaled : 4 * (n + 1) < 4 * 2 ^ rank :=
      Nat.mul_lt_mul_of_pos_left nBelow (by decide)
    have powerIdentity : 2 ^ (rank + 2) = 4 * 2 ^ rank := by
      rw [pow_add]
      norm_num
    rwa [powerIdentity]
  have argumentBelow :
      2 * (width + 1) < 2 ^ (rank + 2) :=
    argumentBound.trans_lt fourBelow
  have exponentNonzero : rank + 2 ≠ 0 := by omega
  have logUpper :
      Nat.log 2 (2 * (width + 1)) < rank + 2 :=
    Nat.log_lt_of_lt_pow' exponentNonzero argumentBelow
  rw [Nat.log2_eq_log_two]
  unfold rank logScale at logUpper ⊢
  omega

/-- Uniform Lemma-7 evidence implies one fixed gate/depth constant for every
one-controlled local block used by Lemma 8. -/
theorem oneControl_local_bounds
    (gateCount depth : Nat → Nat → Nat)
    (resources : LemmaSevenResourceTarget gateCount depth) :
    ∃ gateConstant depthConstant : Nat,
      ∀ n width,
        0 < n → width ≤ blockWidth n →
          gateCount 1 width ≤ gateConstant * blockWidth n ∧
          depth 1 width ≤ depthConstant * logScale n := by
  rcases resources with
    ⟨⟨sourceGateConstant, gateBound⟩,
      ⟨sourceDepthConstant, depthBound⟩⟩
  refine ⟨3 * sourceGateConstant, 3 * sourceDepthConstant, ?_⟩
  intro n width positive widthBound
  have blockPositive := blockWidth_pos positive
  have widthLinear : 1 + width + 1 ≤ 3 * blockWidth n := by
    omega
  have gateLocal := gateBound 1 width
  have gateScaled :
      gateCount 1 width ≤
        sourceGateConstant * (3 * blockWidth n) :=
    gateLocal.trans
      (Nat.mul_le_mul_left sourceGateConstant widthLinear)
  have depthLocal := depthBound 1 width
  have logBound := oneControl_logScale_le positive widthBound
  have depthScaled :
      depth 1 width ≤
        sourceDepthConstant * (3 * logScale n) :=
    depthLocal.trans
      (Nat.mul_le_mul_left sourceDepthConstant logBound)
  constructor
  · calc
      gateCount 1 width ≤
          sourceGateConstant * (3 * blockWidth n) := gateScaled
      _ = (3 * sourceGateConstant) * blockWidth n := by ring
  · calc
      depth 1 width ≤
          sourceDepthConstant * (3 * logScale n) := depthScaled
      _ = (3 * sourceDepthConstant) * logScale n := by ring

end ComparatorIncrementerLemma8Lemma7LocalBounds
end QuantumBlockEncoding
