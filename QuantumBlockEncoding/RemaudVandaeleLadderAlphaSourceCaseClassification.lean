import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOuterIndexCoverage
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveParameters
import Mathlib.Tactic

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaSourceCaseClassification

open RemaudVandaeleLadderAlphaOuterIndexCoverage
open RemaudVandaeleLadderAlphaOuterLayers
open RemaudVandaeleLadderAlphaRecursiveParameters

/-- Exhaustive arithmetic classification of parent source-target indices in the
recursive regime `m ≥ 2`.

An ordinary even target may be the penultimate source target when `m` is even;
it therefore only needs to be nonfinal. Ordinary odd targets use the stronger
`index+2<m` condition because the odd penultimate target for odd `m` is exactly
the even-k special child tail. -/
theorem sourceIndex_cases
    (m : Nat) (large : 2 ≤ m) (index : Fin m) :
    index.val = 0 ∨
    index.val = m - 1 ∨
    (m % 2 = 1 ∧ index.val = m - 2) ∨
    (index.val % 2 = 0 ∧ 2 ≤ index.val ∧ index.val + 1 < m) ∨
    (index.val % 2 = 1 ∧ index.val + 2 < m) := by
  have indexLt := index.isLt
  omega

/-- Canonical recursive child slot corresponding to an ordinary even parent
source target `r`. -/
def ordinaryEvenChildSlot
    {m : Nat} (index : Fin m)
    (even : index.val % 2 = 0)
    (positive : 2 ≤ index.val)
    (beforeFinal : index.val + 1 < m) :
    Fin (recursiveTargetCount m) :=
  ⟨index.val / 2 - 1, by
    unfold recursiveTargetCount RemaudVandaeleLadderAlphaResource.recursiveK
    omega⟩

/-- The ordinary-even child slot is not the even-k special final child slot. -/
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

/-- Its recursive source target is exactly the requested ordinary even parent
source target. -/
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

/-- Canonical child slot of the even-k special parent source target `m-2`. -/
def specialChildSlot
    (m : Nat) (large : 3 ≤ m)
    (oddM : m % 2 = 1) : Fin (recursiveTargetCount m) :=
  ⟨recursiveTargetCount m - 1, by
    unfold recursiveTargetCount RemaudVandaeleLadderAlphaResource.recursiveK
    omega⟩

/-- This canonical final child slot satisfies the Algorithm-2 special-tail
predicate. -/
theorem specialChildSlot_isSpecialTail
    (m : Nat) (large : 3 ≤ m)
    (oddM : m % 2 = 1) :
    isSpecialTail m (specialChildSlot m large oddM) := by
  constructor
  · omega
  · simp [specialChildSlot]
    unfold recursiveTargetCount RemaudVandaeleLadderAlphaResource.recursiveK
    omega

/-- The special child slot maps to parent source target `m-2=k-3`. -/
theorem recursiveOriginalTargetIndex_specialChildSlot
    (m : Nat) (large : 3 ≤ m)
    (oddM : m % 2 = 1) :
    (recursiveOriginalTargetIndex m (by omega)
      (specialChildSlot m large oddM)).val = m - 2 := by
  exact recursiveOriginalTargetIndex_special m (by omega)
    (specialChildSlot m large oddM)
    (specialChildSlot_isSpecialTail m large oddM)

/-- Source target zero occurs in the right wall. -/
def zeroRightSlot
    (m : Nat) (large : 2 ≤ m) : Fin (wallCount m) :=
  rightSlotOfEvenNonfinal
    (⟨0, by omega⟩ : Fin m)
    (by change 0 % 2 = 0; rfl)
    (by change 0 + 1 < m; omega)

@[simp] theorem rightSourceIndex_zeroRightSlot
    (m : Nat) (large : 2 ≤ m) :
    rightSourceIndex m (zeroRightSlot m large) = ⟨0, by omega⟩ := by
  exact rightSourceIndex_rightSlotOfEvenNonfinal
    (⟨0, by omega⟩ : Fin m)
    (by change 0 % 2 = 0; rfl)
    (by change 0 + 1 < m; omega)

end RemaudVandaeleLadderAlphaSourceCaseClassification
end QuantumBlockEncoding
