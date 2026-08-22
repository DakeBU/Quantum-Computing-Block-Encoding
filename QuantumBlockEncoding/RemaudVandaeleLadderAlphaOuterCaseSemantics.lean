import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOuterSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaSourceCaseClassification
import Mathlib.Tactic

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaOuterCaseSemantics

open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaOuterIndexCoverage
open RemaudVandaeleLadderAlphaOuterLayers
open RemaudVandaeleLadderAlphaOuterSemantics
open RemaudVandaeleLadderAlphaSourceCaseClassification

theorem rightScheduled_zero_target
    {q m : Nat} (plan : AlphaPlan q m) (large : 2 ≤ m)
    (state : PrimitiveBasis q) :
    (rightScheduled plan).eval state (plan.target ⟨0, by omega⟩) =
      if intervalActive plan state ⟨0, by omega⟩ then
        flipBit (state (plan.target ⟨0, by omega⟩))
      else state (plan.target ⟨0, by omega⟩) := by
  let slot := zeroRightSlot m large
  have source := rightScheduled_target plan slot state
  have slotEq : rightSourceIndex m slot = (⟨0, by omega⟩ : Fin m) := by
    simpa [slot] using rightSourceIndex_zeroRightSlot m large
  rw [slotEq] at source
  exact source

/-- The left wall never targets alpha_0 in the recursive regime. -/
theorem leftScheduled_preserves_zeroTarget
    {q m : Nat} (plan : AlphaPlan q m) (large : 2 ≤ m)
    (state : PrimitiveBasis q) :
    (leftScheduled plan).eval state (plan.target ⟨0, by omega⟩) =
      state (plan.target ⟨0, by omega⟩) := by
  apply leftScheduled_preserves_of_no_target
  intro slot equal
  have indexEq := target_injective plan equal
  have values := congrArg Fin.val indexEq
  by_cases final : slot.val + 1 = wallCount m
  · simp [leftSourceIndex, final] at values
    omega
  · simp [leftSourceIndex, final] at values
    omega

theorem rightScheduled_ordinaryEven_target
    {q m : Nat} (plan : AlphaPlan q m)
    (index : Fin m)
    (even : index.val % 2 = 0)
    (positive : 2 ≤ index.val)
    (beforeTail : index.val + 2 < m)
    (state : PrimitiveBasis q) :
    (rightScheduled plan).eval state (plan.target index) =
      if intervalActive plan state index then
        flipBit (state (plan.target index))
      else state (plan.target index) := by
  let slot := rightSlotOfEvenNonfinal index even (by omega)
  have source := rightScheduled_target plan slot state
  have slotEq : rightSourceIndex m slot = index := by
    simpa [slot] using
      rightSourceIndex_rightSlotOfEvenNonfinal index even (by omega)
  rw [slotEq] at source
  exact source

theorem leftScheduled_ordinaryOdd_target
    {q m : Nat} (plan : AlphaPlan q m)
    (index : Fin m)
    (odd : index.val % 2 = 1)
    (beforeTail : index.val + 2 < m)
    (state : PrimitiveBasis q) :
    (leftScheduled plan).eval state (plan.target index) =
      if intervalActive plan state index then
        flipBit (state (plan.target index))
      else state (plan.target index) := by
  let slot := leftSlotOfOddBeforeTail index odd beforeTail
  have source := leftScheduled_target plan slot state
  have slotEq : leftSourceIndex m slot = index := by
    simpa [slot] using
      leftSourceIndex_leftSlotOfOddBeforeTail index odd beforeTail
  rw [slotEq] at source
  exact source

/-- The right wall never targets an ordinary odd source target. -/
theorem rightScheduled_preserves_ordinaryOddTarget
    {q m : Nat} (plan : AlphaPlan q m)
    (index : Fin m)
    (odd : index.val % 2 = 1)
    (state : PrimitiveBasis q) :
    (rightScheduled plan).eval state (plan.target index) =
      state (plan.target index) := by
  apply rightScheduled_preserves_of_no_target
  intro slot equal
  have indexEq := target_injective plan equal
  have values := congrArg Fin.val indexEq
  simp [rightSourceIndex] at values
  omega

theorem leftScheduled_final_target
    {q m : Nat} (plan : AlphaPlan q m) (large : 2 ≤ m)
    (state : PrimitiveBasis q) :
    (leftScheduled plan).eval state (plan.target ⟨m - 1, by omega⟩) =
      if intervalActive plan state ⟨m - 1, by omega⟩ then
        flipBit (state (plan.target ⟨m - 1, by omega⟩))
      else state (plan.target ⟨m - 1, by omega⟩) := by
  let slot := finalWallSlot m large
  have source := leftScheduled_target plan slot state
  have slotEq : leftSourceIndex m slot = (⟨m - 1, by omega⟩ : Fin m) := by
    apply Fin.ext
    simpa [slot] using leftSourceIndex_finalWallSlot m large
  rw [slotEq] at source
  exact source

/-- The right wall never targets the final source target. -/
theorem rightScheduled_preserves_finalTarget
    {q m : Nat} (plan : AlphaPlan q m) (large : 2 ≤ m)
    (state : PrimitiveBasis q) :
    (rightScheduled plan).eval state (plan.target ⟨m - 1, by omega⟩) =
      state (plan.target ⟨m - 1, by omega⟩) := by
  apply rightScheduled_preserves_of_no_target
  intro slot equal
  have indexEq := target_injective plan equal
  have values := congrArg Fin.val indexEq
  exact rightSourceIndex_ne_final m large slot values

theorem leftScheduled_preserves_specialTail
    {q m : Nat} (plan : AlphaPlan q m)
    (large : 3 ≤ m) (oddM : m % 2 = 1)
    (state : PrimitiveBasis q) :
    (leftScheduled plan).eval state (plan.target ⟨m - 2, by omega⟩) =
      state (plan.target ⟨m - 2, by omega⟩) := by
  apply leftScheduled_preserves_of_no_target
  intro slot equal
  have indexEq := target_injective plan equal
  have values := congrArg Fin.val indexEq
  exact leftSourceIndex_ne_specialTail m large oddM slot values

theorem rightScheduled_preserves_specialTail
    {q m : Nat} (plan : AlphaPlan q m)
    (large : 3 ≤ m) (oddM : m % 2 = 1)
    (state : PrimitiveBasis q) :
    (rightScheduled plan).eval state (plan.target ⟨m - 2, by omega⟩) =
      state (plan.target ⟨m - 2, by omega⟩) := by
  apply rightScheduled_preserves_of_no_target
  intro slot equal
  have indexEq := target_injective plan equal
  have values := congrArg Fin.val indexEq
  exact rightSourceIndex_ne_specialTail m large oddM slot values

end RemaudVandaeleLadderAlphaOuterCaseSemantics
end QuantumBlockEncoding
