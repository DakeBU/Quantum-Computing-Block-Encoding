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
2. the concrete potential `log2(n+1)+1` really shrinks by a fixed factor under
   `alpha(n)` beyond a finite cutoff.

This file proves (1) and names (2) as an explicit proposition.  It does not
assume or axiomatically discharge the concrete logarithmic contraction.
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

/-- Remaining arithmetic leaf for the source Eq. (46): beyond some finite
cutoff, `alpha(n)=2 ceil(sqrt n)` contracts the logarithmic rank by at least a
3/4 factor.  This is a proposition to prove, not an assumed theorem. -/
def LogRankContraction (cutoff : Nat) : Prop :=
  ∀ n, cutoff ≤ n →
    4 * logRank (alpha n) ≤ 3 * logRank n

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

end ComparatorIncrementerTheorem4DepthBound
end QuantumBlockEncoding
