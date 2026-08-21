import QuantumBlockEncoding.NieZiSunFigure3Resource
import Mathlib.Data.Nat.Log
import Mathlib.Tactic

/-!
# Exact source-macro recurrence for Nie--Zi--Sun Figure 3

The paper's asymptotic proof writes `D(n)=D(n/2)+O(1)` and says the size
analysis is analogous.  The actual Figure-3 tree is slightly more informative:
after reserving I1..I4, the remaining n-4 controls are split between two
parallel recursive branches.  The *complete* gate count therefore adds the two
subtrees, whereas depth takes their maximum.

This module fixes a source-macro cost model tied to that exact recursion.  One
small C^r X block and one X count as one macro instruction.  For n>=5 the local
Figure-3 work consists of eight X gates plus Step 1, Step 3 and Step 5, hence 11
constant-size macro instructions; the same local work fits in five constant
parallel layers around the two recursive halves.

This is not yet B2 elementary-gate counting.  Its purpose is to prove the
resource recursion of the *actual source tree* before constant-size C^3X/C^4X
macros are synthesized into the gate model used downstream.
-/

namespace QuantumBlockEncoding
namespace NieZiSunFigure3ExactRecurrence

open NieZiSunFigure3Resource

/-- The two recursive tails partition exactly the controls after I1..I4. -/
theorem tailWidths_sum (n : Nat) :
    leftTailWidth n + rightTailWidth n = n - 4 := by
  unfold leftTailWidth rightTailWidth
  omega

/-- Each branch is strictly smaller in every non-base Figure-3 instance. -/
theorem tailWidths_lt
    {n : Nat} (large : 5 <= n) :
    leftTailWidth n < n ∧ rightTailWidth n < n := by
  unfold leftTailWidth rightTailWidth
  omega

/-- Source-macro gate count of the complete recursive Figure-3 construction. -/
def macroSize : Nat -> Nat
  | 0 => 1
  | 1 => 1
  | 2 => 1
  | 3 => 1
  | 4 => 1
  | n + 5 =>
      macroSize (leftTailWidth (n + 5)) +
        macroSize (rightTailWidth (n + 5)) + 11
termination_by n => n

decreasing_by
  all_goals
    unfold leftTailWidth rightTailWidth
    omega

/-- Source-macro depth of the complete recursive Figure-3 construction.  The
two first-half calls run in parallel and their inverse halves occupy the
corresponding second halves, so only the larger recursive depth is paid. -/
def macroDepth : Nat -> Nat
  | 0 => 1
  | 1 => 1
  | 2 => 1
  | 3 => 1
  | 4 => 1
  | n + 5 =>
      max (macroDepth (leftTailWidth (n + 5)))
          (macroDepth (rightTailWidth (n + 5))) + 5
termination_by n => n

decreasing_by
  all_goals
    unfold leftTailWidth rightTailWidth
    omega

/-- Exact non-base size recurrence. -/
theorem macroSize_step
    {n : Nat} (large : 5 <= n) :
    macroSize n =
      macroSize (leftTailWidth n) + macroSize (rightTailWidth n) + 11 := by
  obtain ⟨m,rfl⟩ : ∃ m, n = m + 5 := by
    refine ⟨n - 5, by omega⟩
  rfl

/-- Exact non-base depth recurrence. -/
theorem macroDepth_step
    {n : Nat} (large : 5 <= n) :
    macroDepth n =
      max (macroDepth (leftTailWidth n))
          (macroDepth (rightTailWidth n)) + 5 := by
  obtain ⟨m,rfl⟩ : ∃ m, n = m + 5 := by
    refine ⟨n - 5, by omega⟩
  rfl

/-- The exact macro tree has linear size with an explicit uniform constant. -/
theorem macroSize_linear :
    ∀ n, macroSize n <= 11 * (n + 1) := by
  intro n
  induction n using Nat.strong_induction_on with
  | h n induction =>
      by_cases small : n < 5
      · interval_cases n <;> native_decide
      · have large : 5 <= n := by omega
        have tails := tailWidths_lt large
        have leftBound := induction (leftTailWidth n) tails.1
        have rightBound := induction (rightTailWidth n) tails.2
        rw [macroSize_step large]
        have partition := tailWidths_sum n
        nlinarith

/-- Both recursive branch ranks lose at least one binary-log level. -/
theorem tail_log_drop
    {n : Nat} (large : 5 <= n) :
    Nat.log2 (leftTailWidth n + 1) + 1 <= Nat.log2 n ∧
      Nat.log2 (rightTailWidth n + 1) + 1 <= Nat.log2 n := by
  have envelope := tails_le_recursive n
  have sourceDrop := recursive_log_drop large
  constructor
  · have mono : Nat.log2 (leftTailWidth n + 1) <=
        Nat.log2 (recursiveWidth n + 1) := by
      rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
      exact Nat.log_mono_right (Nat.add_le_add_right envelope.1 1)
    omega
  · have mono : Nat.log2 (rightTailWidth n + 1) <=
        Nat.log2 (recursiveWidth n + 1) := by
      rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
      exact Nat.log_mono_right (Nat.add_le_add_right envelope.2 1)
    omega

/-- The exact macro tree has logarithmic depth with an explicit constant. -/
theorem macroDepth_logarithmic :
    ∀ n, macroDepth n <= 5 * (Nat.log2 (n + 1) + 1) := by
  intro n
  induction n using Nat.strong_induction_on with
  | h n induction =>
      by_cases small : n < 5
      · interval_cases n <;> native_decide
      · have large : 5 <= n := by omega
        have tails := tailWidths_lt large
        have leftBound := induction (leftTailWidth n) tails.1
        have rightBound := induction (rightTailWidth n) tails.2
        have rankDrop := tail_log_drop large
        have nMono : Nat.log2 n <= Nat.log2 (n + 1) := by
          rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
          exact Nat.log_mono_right (by omega)
        rw [macroDepth_step large]
        have maxBound :
            max (macroDepth (leftTailWidth n))
                (macroDepth (rightTailWidth n)) <=
              5 * Nat.log2 n := by
          apply max_le
          · exact leftBound.trans
              (Nat.mul_le_mul_left 5 rankDrop.1)
          · exact rightBound.trans
              (Nat.mul_le_mul_left 5 rankDrop.2)
        nlinarith

/-- Reader-facing exact source-tree resource closure. -/
theorem exact_tree_resources :
    (∀ n, macroSize n <= 11 * (n + 1)) ∧
    (∀ n, macroDepth n <= 5 * (Nat.log2 (n + 1) + 1)) :=
  ⟨macroSize_linear, macroDepth_logarithmic⟩

end NieZiSunFigure3ExactRecurrence
end QuantumBlockEncoding
