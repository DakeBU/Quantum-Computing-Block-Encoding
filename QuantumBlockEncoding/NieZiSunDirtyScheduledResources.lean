import QuantumBlockEncoding.NieZiSunDirtyScheduledFamily
import QuantumBlockEncoding.NieZiSunFigure3ExactRecurrence
import QuantumBlockEncoding.NieZiSunFigure3ScheduledResources
import QuantumBlockEncoding.VandaeleLemma1Contract
import Mathlib.Tactic

/-!
# Uniform resources of the actual one-dirty Nie schedule

This closes the resource half needed by Vandaele Lemma 1 in ASPBE's reversible
gate model.  The constants are intentionally conservative and are derived from
the exact scheduled circuit, not from the earlier source-macro recurrence.
-/

namespace QuantumBlockEncoding
namespace NieZiSunDirtyScheduledResources

open NieZiSunDirtyScheduledFamily
open NieZiSunFigure3ExactRecurrence
open NieZiSunFigure3Resource
open NieZiSunFigure3ScheduledFamily
open NieZiSunFigure3ScheduledResources
open VandaeleLemma1Contract

/-- Scheduled Step 2 gate count. -/
theorem step2Scheduled_gateCount
    (n : Nat) (large : 5 <= n) :
    (step2Scheduled n large).gateCount =
      4 + (firstHalfScheduled (leftTailWidth n)).gateCount +
        (firstHalfScheduled (rightTailWidth n)).gateCount := by
  simp [step2Scheduled, childrenScheduled,
    leftChildScheduled, rightChildScheduled,
    childSchedules_disjoint]
  omega

/-- Scheduled Step 2 depth. -/
theorem step2Scheduled_depth
    (n : Nat) (large : 5 <= n) :
    (step2Scheduled n large).depth =
      1 + max (firstHalfScheduled (leftTailWidth n)).depth
        (firstHalfScheduled (rightTailWidth n)).depth := by
  simp [step2Scheduled, childrenScheduled,
    leftChildScheduled, rightChildScheduled,
    childSchedules_disjoint]
  omega

/-- Source middle gate count. -/
theorem middleScheduled_gateCount
    (n : Nat) (large : 5 <= n) :
    (middleScheduled n large).gateCount =
      12 + 2 * (firstHalfScheduled (leftTailWidth n)).gateCount +
        2 * (firstHalfScheduled (rightTailWidth n)).gateCount := by
  simp [middleScheduled, step2Scheduled_gateCount n large]
  omega

/-- Source middle depth. -/
theorem middleScheduled_depth
    (n : Nat) (large : 5 <= n) :
    (middleScheduled n large).depth =
      6 + 2 * max (firstHalfScheduled (leftTailWidth n)).depth
        (firstHalfScheduled (rightTailWidth n)).depth := by
  simp [middleScheduled, step2Scheduled_depth n large]
  omega

/-- Exact non-base dirty gate-count recurrence. -/
theorem dirtyScheduled_gateCount_step
    {n : Nat} (large : 5 <= n) :
    (dirtyScheduled n).gateCount =
      44 + 4 * (firstHalfScheduled (leftTailWidth n)).gateCount +
        4 * (firstHalfScheduled (rightTailWidth n)).gateCount := by
  simp [dirtyScheduled, large, middleScheduled_gateCount n large,
    step1Scheduled]
  omega

/-- Exact non-base dirty depth recurrence. -/
theorem dirtyScheduled_depth_step
    {n : Nat} (large : 5 <= n) :
    (dirtyScheduled n).depth =
      32 + 4 * max (firstHalfScheduled (leftTailWidth n)).depth
        (firstHalfScheduled (rightTailWidth n)).depth := by
  simp [dirtyScheduled, large, middleScheduled_depth n large,
    step1Scheduled]
  omega

/-- Dirty family has a uniform linear gate bound. -/
theorem dirty_gate_linear :
    ∀ n, (dirtyScheduled n).gateCount <= 24 * (n + 1) := by
  intro n
  by_cases small : n < 5
  · interval_cases n <;> native_decide
  · have large : 5 <= n := by omega
    have leftBound := firstHalf_gate_linear (leftTailWidth n)
    have rightBound := firstHalf_gate_linear (rightTailWidth n)
    have partition := tailWidths_sum n
    rw [dirtyScheduled_gateCount_step large]
    nlinarith

/-- Dirty family has a uniform logarithmic depth bound. -/
theorem dirty_depth_logarithmic :
    ∀ n, (dirtyScheduled n).depth <=
      60 * (Nat.log2 (n + 1) + 1) := by
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
    rw [dirtyScheduled_depth_step large]
    nlinarith

/-- The actual dirty schedule directly closes Vandaele's uniform Lemma-1
resource target. -/
theorem vandaele_resource_target :
    LemmaOneUniformResourceTarget
      (fun n => (dirtyScheduled n).gateCount)
      (fun n => (dirtyScheduled n).depth)
      (fun _ => 1) := by
  refine ⟨24,60,?_⟩
  intro n
  exact ⟨dirty_gate_linear n,dirty_depth_logarithmic n,by omega⟩

end NieZiSunDirtyScheduledResources
end QuantumBlockEncoding
