import QuantumBlockEncoding.ComparatorIncrementerRecurrence
import Mathlib.Tactic

/-!
# Geometric closure of Vandaele Equation (46)

Equation (46) has the shape

`D(n) = Theta(log n) + D(alpha(n))`,
`alpha(n) = 2 ceil(sqrt n)`.

There are two logically separate facts behind the O(log n) conclusion:

1. a generic recurrence with a geometrically shrinking logarithmic potential
   sums to a constant multiple of its first potential;
2. the concrete potential `log2(n+1)+1` shrinks by a fixed factor under
   `alpha(n)` beyond a finite cutoff.

Both facts are proved here.  The deliberately generous cutoff `2047` keeps the
integer proof stable: once `logRank n >= 12`, the square-root recursion gives a
3/4 contraction of the logarithmic rank.  The finite range below the cutoff is
absorbed into the base constant of the recurrence theorem.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerTheorem4DepthBound

open ComparatorIncrementerRecurrence

/-- Generic geometric-potential closure.

The factor 3/4 is arbitrary but convenient: if
`4 * rank(alpha n) <= 3 * rank n`, then a local cost of
`A * rank n` sums to at most `4A * rank n`, plus a finite base constant. -/
theorem depth_recurrence_geometric_upper
    (depth rank : Nat → Nat)
    (localConstant baseConstant cutoff : Nat)
    (cutoffAtLeastSeven : 7 ≤ cutoff)
    (base : ∀ n, n < cutoff → depth n ≤ baseConstant)
    (step : ∀ n, cutoff ≤ n →
      depth n ≤ localConstant * rank n + depth (alpha n))
    (contraction : ∀ n, cutoff ≤ n →
      4 * rank (alpha n) ≤ 3 * rank n) :
    ∀ n, depth n ≤ baseConstant +
      (4 * localConstant) * rank n := by
  intro n
  induction n using Nat.strong_induction_on with
  | h n induction =>
      by_cases small : n < cutoff
      · have baseBound := base n small
        exact baseBound.trans (Nat.le_add_right _ _)
      · have large : cutoff ≤ n := by omega
        have recursiveRegime : 7 ≤ n := by omega
        have decreases : alpha n < n := alpha_lt_self recursiveRegime
        have recursiveBound := induction (alpha n) decreases
        have oneStep := step n large
        have composed :
            depth n ≤
              localConstant * rank n +
                (baseConstant +
                  (4 * localConstant) * rank (alpha n)) :=
          oneStep.trans (Nat.add_le_add_left recursiveBound _)
        have shrink := contraction n large
        have scaledShrink :
            (4 * localConstant) * rank (alpha n) ≤
              (3 * localConstant) * rank n := by
          have scaled := Nat.mul_le_mul_left localConstant shrink
          calc
            (4 * localConstant) * rank (alpha n) =
                localConstant * (4 * rank (alpha n)) := by ring
            _ ≤ localConstant * (3 * rank n) := scaled
            _ = (3 * localConstant) * rank n := by ring
        calc
          depth n ≤
              localConstant * rank n +
                (baseConstant +
                  (4 * localConstant) * rank (alpha n)) := composed
          _ ≤ localConstant * rank n +
                (baseConstant +
                  (3 * localConstant) * rank n) :=
            Nat.add_le_add_left
              (Nat.add_le_add_left scaledShrink baseConstant)
              (localConstant * rank n)
          _ = baseConstant +
                (4 * localConstant) * rank n := by ring

/-- Concrete logarithmic potential used for the source depth theorem. -/
def logRank (n : Nat) : Nat := Nat.log2 (n + 1) + 1

/-- Fixed-factor logarithmic contraction target. -/
def LogRankContraction (cutoff : Nat) : Prop :=
  ∀ n, cutoff ≤ n →
    4 * logRank (alpha n) ≤ 3 * logRank n

/-- Beyond 2047 the current logarithmic rank is at least 12. -/
theorem logRank_ge_twelve
    {n : Nat} (large : 2047 ≤ n) :
    12 ≤ logRank n := by
  have powerBound : 2 ^ 11 ≤ n + 1 := by
    norm_num
    omega
  have logBound : 11 ≤ Nat.log 2 (n + 1) :=
    Nat.le_log_of_pow_le Nat.one_lt_two powerBound
  unfold logRank
  rw [Nat.log2_eq_log_two]
  omega

/-- The defining property of floor binary logarithm, rewritten using `logRank`. -/
theorem succ_lt_two_pow_logRank (n : Nat) :
    n + 1 < 2 ^ logRank n := by
  have source := Nat.lt_pow_succ_log_self Nat.one_lt_two (n + 1)
  simpa [logRank, Nat.log2_eq_log_two, Nat.succ_eq_add_one] using source

/-- A deliberately simple square-root consequence of the binary logarithm:
`sqrt n` lies below the power with exponent `floor(logRank n / 2)+1`. -/
theorem sqrt_lt_halfRank_power (n : Nat) :
    Nat.sqrt n < 2 ^ (logRank n / 2 + 1) := by
  have nBelowRank : n < 2 ^ logRank n := by
    have source := succ_lt_two_pow_logRank n
    omega
  have exponentBound :
      logRank n ≤ 2 * (logRank n / 2 + 1) := by
    omega
  have powerMonotone :
      2 ^ logRank n ≤
        2 ^ (2 * (logRank n / 2 + 1)) :=
    Nat.pow_le_pow_right (by decide) exponentBound
  have nBelowDouble :
      n < 2 ^ (2 * (logRank n / 2 + 1)) :=
    nBelowRank.trans_le powerMonotone
  have powerDouble :
      2 ^ (2 * (logRank n / 2 + 1)) =
        2 ^ (logRank n / 2 + 1) *
          2 ^ (logRank n / 2 + 1) := by
    rw [show 2 * (logRank n / 2 + 1) =
        (logRank n / 2 + 1) + (logRank n / 2 + 1) by omega]
    rw [pow_add]
  rw [powerDouble] at nBelowDouble
  by_contra notStrict
  have powerLeSqrt :
      2 ^ (logRank n / 2 + 1) ≤ Nat.sqrt n :=
    Nat.le_of_not_gt notStrict
  have squareLe :
      2 ^ (logRank n / 2 + 1) *
          2 ^ (logRank n / 2 + 1) ≤
        Nat.sqrt n * Nat.sqrt n :=
    Nat.mul_le_mul powerLeSqrt powerLeSqrt
  have sqrtSquareLe : Nat.sqrt n * Nat.sqrt n ≤ n := by
    simpa [pow_two] using Nat.sqrt_le' n
  have impossible :
      2 ^ (logRank n / 2 + 1) *
          2 ^ (logRank n / 2 + 1) ≤ n :=
    squareLe.trans sqrtSquareLe
  exact (Nat.not_lt_of_ge impossible) nBelowDouble

/-- The recursive width has logarithmic rank at most half the current rank plus
three.  This intentionally trades a nonoptimal additive constant for a robust
integer proof. -/
theorem logRank_alpha_le_half_add_three (n : Nat) :
    logRank (alpha n) ≤ logRank n / 2 + 3 := by
  have sqrtBound := sqrt_lt_halfRank_power n
  have ceilingBound := ceilSqrt_le_sqrt_add_one n
  have ceilingPower :
      ceilSqrt n ≤ 2 ^ (logRank n / 2 + 1) := by
    omega
  have powerPositive :
      0 < 2 ^ (logRank n / 2 + 1) :=
    Nat.pow_pos (by decide)
  have alphaPower :
      alpha n + 1 < 2 ^ (logRank n / 2 + 3) := by
    have linear :
        2 * ceilSqrt n + 1 <
          4 * 2 ^ (logRank n / 2 + 1) := by
      omega
    have powerIdentity :
        2 ^ (logRank n / 2 + 3) =
          4 * 2 ^ (logRank n / 2 + 1) := by
      rw [show logRank n / 2 + 3 =
          2 + (logRank n / 2 + 1) by omega]
      rw [pow_add]
      norm_num
    unfold alpha
    rw [powerIdentity]
    exact linear
  have exponentNonzero : logRank n / 2 + 3 ≠ 0 := by omega
  have logUpper :
      Nat.log 2 (alpha n + 1) < logRank n / 2 + 3 :=
    Nat.log_lt_of_lt_pow' exponentNonzero alphaPower
  unfold logRank
  rw [Nat.log2_eq_log_two]
  omega

/-- Concrete witness discharging the arithmetic leaf in Equation (46). -/
theorem logRankContraction_2047 : LogRankContraction 2047 := by
  intro n large
  have rankLower := logRank_ge_twelve large
  have recursiveRank := logRank_alpha_le_half_add_three n
  have numeric :
      4 * (logRank n / 2 + 3) ≤ 3 * logRank n := by
    omega
  exact (Nat.mul_le_mul_left 4 recursiveRank).trans numeric

/-- Once the concrete log-rank contraction is supplied, the full recurrence
upper bound is immediate from the generic geometric theorem. -/
theorem depth_recurrence_log_upper
    (depth : Nat → Nat)
    (localConstant baseConstant cutoff : Nat)
    (cutoffAtLeastSeven : 7 ≤ cutoff)
    (base : ∀ n, n < cutoff → depth n ≤ baseConstant)
    (step : ∀ n, cutoff ≤ n →
      depth n ≤ localConstant * logRank n + depth (alpha n))
    (logContraction : LogRankContraction cutoff) :
    ∀ n, depth n ≤ baseConstant +
      (4 * localConstant) * logRank n := by
  exact depth_recurrence_geometric_upper
    depth logRank localConstant baseConstant cutoff
    cutoffAtLeastSeven base step logContraction

/-- Source-ready specialization: any Equation-(46) recurrence valid above the
finite cutoff 2047 has an explicit global logarithmic upper bound. -/
theorem depth_recurrence_log_upper_2047
    (depth : Nat → Nat)
    (localConstant baseConstant : Nat)
    (base : ∀ n, n < 2047 → depth n ≤ baseConstant)
    (step : ∀ n, 2047 ≤ n →
      depth n ≤ localConstant * logRank n + depth (alpha n)) :
    ∀ n, depth n ≤ baseConstant +
      (4 * localConstant) * logRank n := by
  exact depth_recurrence_log_upper
    depth localConstant baseConstant 2047
    (by norm_num) base step logRankContraction_2047

end ComparatorIncrementerTheorem4DepthBound
end QuantumBlockEncoding
