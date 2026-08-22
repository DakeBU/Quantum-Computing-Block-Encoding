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

/-- Source target zero is implemented by the right wall. -/
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

/-- Every ordinary even parent target is implemented by its right-wall slot. -/
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

/-- Every ordinary odd parent target before the tail is implemented by a
nonfinal left-wall slot. -/
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

/-- The final parent source target `m-1` is always the final left-wall slot. -/
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

/-- In the even-k regime (m odd), neither outer wall targets the child special
source target `m-2`. -/
theorem leftScheduled_preserves_specialTail
    {q m : Nat} (plan : AlphaPlan q m)
    (large : 3 ≤ m) (oddM : m % 2 = 1)
    (state : PrimitiveBasis q) :
    (leftScheduled plan).eval state (plan.target ⟨m - 2, by omega⟩) =
      state (plan.target ⟨m - 2, by omega⟩) := by
  apply leftScheduled_preserves_of_no_target
  intro slot
  intro equal
  have indexEq := target_injective plan equal
  have values := congrArg Fin.val indexEq
  exact leftSourceIndex_ne_specialTail m large oddM slot values

/-- Right-wall companion of special-tail preservation. -/
theorem rightScheduled_preserves_specialTail
    {q m : Nat} (plan : AlphaPlan q m)
    (large : 3 ≤ m) (oddM : m % 2 = 1)
    (state : PrimitiveBasis q) :
    (rightScheduled plan).eval state (plan.target ⟨m - 2, by omega⟩) =
      state (plan.target ⟨m - 2, by omega⟩) := by
  apply rightScheduled_preserves_of_no_target
  intro slot
  intro equal
  have indexEq := target_injective plan equal
  have values := congrArg Fin.val indexEq
  exact rightSourceIndex_ne_specialTail m large oddM slot values

end RemaudVandaeleLadderAlphaOuterCaseSemantics
end QuantumBlockEncoding
