import QuantumBlockEncoding.ComparatorIncrementerRecurrence
import Mathlib.Tactic

/-!
# Linear gate upper bound from Vandaele Equation (45)

Theorem 4 derives the gate recurrence

`C(n) = Theta(n) + C(2 ceil(sqrt n))`.

This file formalizes the deterministic upper-bound implication behind that
sentence.  It does not assume the source circuit has the recurrence; Figure 10
must still supply the local linear gate bound.  Once that premise is available,
the theorem below converts it to a global linear bound.

The lower-bound half of `Theta(n)` is intentionally separate and must be tied to
the paper's reduction from multi-controlled X gates.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerTheorem4GateBound

open ComparatorIncrementerRecurrence

/-- Past the finite small-width regime, the recursive argument is at most half
of the current size up to the `+1` convention used by explicit linear bounds. -/
theorem alpha_half_contraction {n : Nat} (large : 21 ≤ n) :
    2 * (alpha n + 1) ≤ n + 1 := by
  have ceilingBound := ceilSqrt_le_sqrt_add_one n
  by_cases smallSqrt : Nat.sqrt n ≤ 4
  · unfold alpha
    omega
  · have sqrtAtLeastFive : 5 ≤ Nat.sqrt n := by omega
    have squareBelow : Nat.sqrt n ^ 2 ≤ n := Nat.sqrt_le' n
    unfold alpha
    nlinarith

/-- Explicit linear closure of the Vandaele gate-count recurrence.

`localConstant` certifies the Figure-10/nonrecursive work
`localConstant * (n+1)`. `baseConstant` certifies all widths below 21.  The
resulting global constant is deliberately simple rather than optimized. -/
theorem gate_recurrence_linear_upper
    (cost : Nat → Nat) (localConstant baseConstant : Nat)
    (base : ∀ n, n < 21 →
      cost n ≤ baseConstant * (n + 1))
    (step : ∀ n, 21 ≤ n →
      cost n ≤ localConstant * (n + 1) + cost (alpha n)) :
    ∀ n, cost n ≤
      (baseConstant + 2 * localConstant) * (n + 1) := by
  intro n
  induction n using Nat.strong_induction_on with
  | h n induction =>
      by_cases small : n < 21
      · have baseBound := base n small
        calc
          cost n ≤ baseConstant * (n + 1) := baseBound
          _ ≤ (baseConstant + 2 * localConstant) * (n + 1) := by
            apply Nat.mul_le_mul_right
            omega
      · have large : 21 ≤ n := by omega
        have recursiveLarge : 7 ≤ n := by omega
        have decreases : alpha n < n := alpha_lt_self recursiveLarge
        have recursiveBound := induction (alpha n) decreases
        have oneStep := step n large
        have combined :
            cost n ≤
              localConstant * (n + 1) +
                (baseConstant + 2 * localConstant) * (alpha n + 1) := by
          exact oneStep.trans (Nat.add_le_add_left recursiveBound _)
        have contraction := alpha_half_contraction large
        have scaledContraction :
            (baseConstant + 2 * localConstant) *
                (2 * (alpha n + 1)) ≤
              (baseConstant + 2 * localConstant) * (n + 1) :=
          Nat.mul_le_mul_left
            (baseConstant + 2 * localConstant) contraction
        have localConstantFits :
            2 * localConstant ≤ baseConstant + 2 * localConstant := by
          omega
        have scaledLocal :
            (2 * localConstant) * (n + 1) ≤
              (baseConstant + 2 * localConstant) * (n + 1) :=
          Nat.mul_le_mul_right (n + 1) localConstantFits
        have doubled := Nat.mul_le_mul_left 2 combined
        have rhsBound :
            2 *
                (localConstant * (n + 1) +
                  (baseConstant + 2 * localConstant) * (alpha n + 1)) ≤
              2 * ((baseConstant + 2 * localConstant) * (n + 1)) := by
          calc
            2 *
                (localConstant * (n + 1) +
                  (baseConstant + 2 * localConstant) * (alpha n + 1)) =
              (2 * localConstant) * (n + 1) +
                (baseConstant + 2 * localConstant) *
                  (2 * (alpha n + 1)) := by ring
            _ ≤
              (baseConstant + 2 * localConstant) * (n + 1) +
                (baseConstant + 2 * localConstant) * (n + 1) :=
              Nat.add_le_add scaledLocal scaledContraction
            _ = 2 * ((baseConstant + 2 * localConstant) * (n + 1)) := by
              ring
        have doubledFinal :
            2 * cost n ≤
              2 * ((baseConstant + 2 * localConstant) * (n + 1)) :=
          doubled.trans rhsBound
        exact Nat.le_of_mul_le_mul_left doubledFinal (by decide)

/-- Pack the same statement using the recurrence interface from the previous
layer. -/
theorem gate_recurrence_contract_linear_upper
    (cost : Nat → Nat) (localConstant baseConstant : Nat)
    (base : ∀ n, n < 21 →
      cost n ≤ baseConstant * (n + 1))
    (recurrence : GateRecurrenceUpper cost
      (fun n => localConstant * (n + 1))) :
    ∀ n, cost n ≤
      (baseConstant + 2 * localConstant) * (n + 1) := by
  apply gate_recurrence_linear_upper cost localConstant baseConstant base
  intro n large
  exact recurrence n (by omega)

end ComparatorIncrementerTheorem4GateBound
end QuantumBlockEncoding
