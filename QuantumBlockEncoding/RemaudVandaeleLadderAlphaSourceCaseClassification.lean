import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOuterIndexCoverage
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveParameters
import Mathlib.Tactic

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaSourceCaseClassification

open RemaudVandaeleLadderAlphaOuterIndexCoverage
open RemaudVandaeleLadderAlphaOuterLayers
open RemaudVandaeleLadderAlphaRecursiveParameters

theorem sourceIndex_cases
    (m : Nat) (large : 2 ≤ m) (index : Fin m) :
    index.val = 0 ∨
    index.val = m - 1 ∨
    (m % 2 = 1 ∧ index.val = m - 2) ∨
    (index.val % 2 = 0 ∧ 2 ≤ index.val ∧ index.val + 1 < m) ∨
    (index.val % 2 = 1 ∧ index.val + 2 < m) := by
  have indexLt := index.isLt
  omega

def ordinaryEvenChildSlot
    {m : Nat} (index : Fin m)
    (even : index.val % 2 = 0)
    (positive : 2 ≤ index.val)
    (beforeFinal : index.val + 1 < m) :
    Fin (recursiveTargetCount m) :=
  ⟨index.val / 2 - 1, by
    unfold recursiveTargetCount RemaudVandaeleLadderAlphaResource.recursiveK
    omega⟩

theorem ordinaryEvenChildSlot_not_special
    {m : Nat} (large : 3 ≤ m + 1) (index : Fin m)
    (even : index.val % 2 = 0)
    (positive : 2 ≤ index.val)
    (beforeFinal : index.val + 1 < m) :
    ¬ isSpecialTail m
      (ordinaryEvenChildSlot index even positive beforeFinal) := by
  intro special
  rcases special with ⟨evenK,last⟩
  simp [ordinaryEvenChildSlot] at last
  unfold recursiveTargetCount RemaudVandaeleLadderAlphaResource.recursiveK at last
  omega

theorem recursiveOriginalTargetIndex_ordinaryEvenChildSlot
    {m : Nat} (large : 3 ≤ m + 1) (index : Fin m)
    (even : index.val % 2 = 0)
    (positive : 2 ≤ index.val)
    (beforeFinal : index.val + 1 < m) :
    recursiveOriginalTargetIndex m large
      (ordinaryEvenChildSlot index even positive beforeFinal) = index := by
  let child := ordinaryEvenChildSlot index even positive beforeFinal
  have ordinary : ¬ isSpecialTail m child :=
    ordinaryEvenChildSlot_not_special large index even positive beforeFinal
  apply Fin.ext
  rw [recursiveOriginalTargetIndex_ordinary m large child ordinary]
  simp [child, ordinaryEvenChildSlot]
  omega

def specialChildSlot
    (m : Nat) (large : 3 ≤ m)
    (oddM : m % 2 = 1) : Fin (recursiveTargetCount m) :=
  ⟨recursiveTargetCount m - 1, by
    unfold recursiveTargetCount RemaudVandaeleLadderAlphaResource.recursiveK
    omega⟩

theorem specialChildSlot_isSpecialTail
    (m : Nat) (large : 3 ≤ m)
    (oddM : m % 2 = 1) :
    isSpecialTail m (specialChildSlot m large oddM) := by
  constructor
  · omega
  · simp [specialChildSlot]
    unfold recursiveTargetCount RemaudVandaeleLadderAlphaResource.recursiveK
    omega

theorem recursiveOriginalTargetIndex_specialChildSlot
    (m : Nat) (large : 3 ≤ m)
    (oddM : m % 2 = 1) :
    (recursiveOriginalTargetIndex m (by omega)
      (specialChildSlot m large oddM)).val = m - 2 := by
  exact recursiveOriginalTargetIndex_special m (by omega)
    (specialChildSlot m large oddM)
    (specialChildSlot_isSpecialTail m large oddM)

def zeroRightSlot
    (m : Nat) (large : 2 ≤ m) : Fin (wallCount m) :=
  let zero : Fin m := ⟨0, by omega⟩
  rightSlotOfEvenNonfinal zero (by simp [zero]) (by simp [zero]; omega)

@[simp] theorem rightSourceIndex_zeroRightSlot
    (m : Nat) (large : 2 ≤ m) :
    rightSourceIndex m (zeroRightSlot m large) = ⟨0, by omega⟩ := by
  let zero : Fin m := ⟨0, by omega⟩
  have source := rightSourceIndex_rightSlotOfEvenNonfinal
    zero (by simp [zero]) (by simp [zero]; omega)
  simpa [zeroRightSlot, zero] using source

end RemaudVandaeleLadderAlphaSourceCaseClassification
end QuantumBlockEncoding
