import QuantumBlockEncoding.NieZiSunFigure3ExactRecurrence
import QuantumBlockEncoding.NieZiSunFigure3ScheduledFamily
import Mathlib.Data.Nat.Log
import Mathlib.Tactic

/-!
# Uniform resources of the actual scheduled Nie--Zi--Sun gate family

The schedule is now proof-bearing, so resource bounds are proved directly from
its exact gate-count/depth recurrences.  No source-macro cost function is used
in the final inequalities.
-/

namespace QuantumBlockEncoding
namespace NieZiSunFigure3ScheduledResources

open NieZiSunFigure3ExactRecurrence
open NieZiSunFigure3Resource
open NieZiSunFigure3ScheduledFamily

/-- First-half gate count is uniformly linear. -/
theorem firstHalf_gate_linear :
    ∀ n, (firstHalfScheduled n).gateCount <= 6 * (n + 1) := by
  intro n
  induction n using Nat.strong_induction_on with
  | h n induction =>
      by_cases small : n < 5
      · interval_cases n <;> native_decide
      · have large : 5 <= n := by omega
        have leftSmaller : leftTailWidth n < n := by
          unfold leftTailWidth
          omega
        have rightSmaller : rightTailWidth n < n := by
          unfold rightTailWidth leftTailWidth
          omega
        have leftBound := induction (leftTailWidth n) leftSmaller
        have rightBound := induction (rightTailWidth n) rightSmaller
        have partition := tailWidths_sum n
        rw [firstHalfScheduled_gateCount_step large]
        nlinarith

/-- First-half depth is uniformly logarithmic. -/
theorem firstHalf_depth_logarithmic :
    ∀ n, (firstHalfScheduled n).depth <=
      15 * (Nat.log2 (n + 1) + 1) := by
  intro n
  induction n using Nat.strong_induction_on with
  | h n induction =>
      by_cases small : n < 5
      · interval_cases n <;> native_decide
      · have large : 5 <= n := by omega
        have leftSmaller : leftTailWidth n < n := by
          unfold leftTailWidth
          omega
        have rightSmaller : rightTailWidth n < n := by
          unfold rightTailWidth leftTailWidth
          omega
        have leftBound := induction (leftTailWidth n) leftSmaller
        have rightBound := induction (rightTailWidth n) rightSmaller
        have rankDrop := tail_log_drop large
        have leftGlobal :
            (firstHalfScheduled (leftTailWidth n)).depth <=
              15 * Nat.log2 n :=
          leftBound.trans (Nat.mul_le_mul_left 15 rankDrop.1)
        have rightGlobal :
            (firstHalfScheduled (rightTailWidth n)).depth <=
              15 * Nat.log2 n :=
          rightBound.trans (Nat.mul_le_mul_left 15 rankDrop.2)
        have maxBound :
            max (firstHalfScheduled (leftTailWidth n)).depth
                (firstHalfScheduled (rightTailWidth n)).depth <=
              15 * Nat.log2 n :=
          max_le leftGlobal rightGlobal
        have logMono : Nat.log2 n <= Nat.log2 (n + 1) := by
          rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
          exact Nat.log_mono_right (by omega)
        rw [firstHalfScheduled_depth_step large]
        nlinarith

/-- Complete scheduled circuit has linear gate count. -/
theorem full_gate_linear :
    ∀ n, (fullScheduled n).gateCount <= 12 * (n + 1) := by
  intro n
  by_cases small : n < 5
  · interval_cases n <;> native_decide
  · have large : 5 <= n := by omega
    have leftBound := firstHalf_gate_linear (leftTailWidth n)
    have rightBound := firstHalf_gate_linear (rightTailWidth n)
    have partition := tailWidths_sum n
    rw [fullScheduled_gateCount_step large]
    nlinarith

/-- Complete scheduled circuit has logarithmic depth. -/
theorem full_depth_logarithmic :
    ∀ n, (fullScheduled n).depth <=
      30 * (Nat.log2 (n + 1) + 1) := by
  intro n
  by_cases small : n < 5
  · interval_cases n <;> native_decide
  · have large : 5 <= n := by omega
    have leftBound := firstHalf_depth_logarithmic (leftTailWidth n)
    have rightBound := firstHalf_depth_logarithmic (rightTailWidth n)
    have rankDrop := tail_log_drop large
    have leftGlobal :
        (firstHalfScheduled (leftTailWidth n)).depth <=
          15 * Nat.log2 n :=
      leftBound.trans (Nat.mul_le_mul_left 15 rankDrop.1)
    have rightGlobal :
        (firstHalfScheduled (rightTailWidth n)).depth <=
          15 * Nat.log2 n :=
      rightBound.trans (Nat.mul_le_mul_left 15 rankDrop.2)
    have maxBound :
        max (firstHalfScheduled (leftTailWidth n)).depth
            (firstHalfScheduled (rightTailWidth n)).depth <=
          15 * Nat.log2 n :=
      max_le leftGlobal rightGlobal
    have logMono : Nat.log2 n <= Nat.log2 (n + 1) := by
      rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
      exact Nat.log_mono_right (by omega)
    rw [fullScheduled_depth_step large]
    nlinarith

/-- Actual scheduled family closes the Nie source resource target. -/
theorem actual_schedule_resources :
    FigureThreeResourceTarget
      (fun n => (fullScheduled n).depth)
      (fun n => (fullScheduled n).gateCount) := by
  constructor
  · exact ⟨30, full_depth_logarithmic⟩
  · exact ⟨12, full_gate_linear⟩

/-- Explicit reader-facing pair of bounds. -/
theorem actual_schedule_explicit (n : Nat) :
    (fullScheduled n).gateCount <= 12 * (n + 1) ∧
    (fullScheduled n).depth <= 30 * (Nat.log2 (n + 1) + 1) :=
  ⟨full_gate_linear n, full_depth_logarithmic n⟩

end NieZiSunFigure3ScheduledResources
end QuantumBlockEncoding
