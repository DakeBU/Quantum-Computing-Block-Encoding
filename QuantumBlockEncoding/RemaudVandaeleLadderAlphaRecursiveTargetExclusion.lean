import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveOrder
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaTargetMembership
import Mathlib.Tactic

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaRecursiveTargetExclusion

open RemaudVandaeleLadderAlphaRecursiveOrder
open RemaudVandaeleLadderAlphaRecursiveParameters
open RemaudVandaeleLadderAlphaSelectedRegister
open RemaudVandaeleLadderAlphaTargetMembership

/-- The physical recursive-end source index is strictly before the final parent
source target `m-1`. -/
theorem recursiveEndOriginalIndex_lt_final
    (m : Nat) (large : 3 ≤ m + 1) :
    (recursiveEndOriginalIndex m large).val < m - 1 := by
  have mTwo : 2 ≤ m := by omega
  unfold recursiveEndOriginalIndex
  split_ifs with empty
  · change 0 < m - 1
    omega
  · have countPos : 0 < recursiveTargetCount m := Nat.pos_of_ne_zero empty
    let last : Fin (recursiveTargetCount m) :=
      ⟨recursiveTargetCount m - 1, by omega⟩
    have lastFinal : last.val + 1 = recursiveTargetCount m := by
      dsimp [last]
      omega
    change (recursiveOriginalTargetIndex m large last).val < m - 1
    by_cases special : isSpecialTail m last
    · rw [recursiveOriginalTargetIndex_special m large last special]
      omega
    · rw [recursiveOriginalTargetIndex_ordinary m large last special]
      have notEven : (m + 1) % 2 ≠ 0 := by
        intro even
        exact special ⟨even, lastFinal⟩
      unfold recursiveTargetCount RemaudVandaeleLadderAlphaResource.recursiveK at countPos
      unfold recursiveTargetCount RemaudVandaeleLadderAlphaResource.recursiveK at lastFinal
      omega

/-- Every recursive child target is strictly before the final parent source
target.  This Nat-valued form is the stable arithmetic API used by downstream
ordinary-target proofs; it avoids transporting a disequality between dependent
`Fin m` terms. -/
theorem recursiveOriginalTargetIndex_before_final
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    (recursiveOriginalTargetIndex m large j).val + 1 < m := by
  have atMostEnd := recursiveOriginalTargetIndex_le_end m large j
  have endBeforeFinal := recursiveEndOriginalIndex_lt_final m large
  have mTwo : 2 ≤ m := by omega
  omega

/-- No recursive child target maps to parent source target zero. -/
theorem recursiveOriginalTargetIndex_ne_zero
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    recursiveOriginalTargetIndex m large j ≠
      ⟨0, by omega⟩ := by
  intro equal
  have positive := recursiveOriginalTargetIndex_pos m large j
  have values := congrArg Fin.val equal
  simp at values
  omega

/-- No recursive child target maps to the final parent source target. -/
theorem recursiveOriginalTargetIndex_ne_final
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    recursiveOriginalTargetIndex m large j ≠
      ⟨m - 1, by omega⟩ := by
  intro equal
  have atMostEnd := recursiveOriginalTargetIndex_le_end m large j
  have endBeforeFinal := recursiveEndOriginalIndex_lt_final m large
  have values := congrArg Fin.val equal
  simp at values
  omega

/-- Any odd recursive child source index is exactly the special physical end. -/
theorem recursiveOriginalTargetIndex_odd_eq_end
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (odd : (recursiveOriginalTargetIndex m large j).val % 2 = 1) :
    recursiveOriginalTargetIndex m large j =
      recursiveEndOriginalIndex m large :=
  odd_recursiveTarget_eq_end m large j odd

/-- Therefore an ordinary odd parent source target strictly before the tail can
never be a recursive child target. -/
theorem recursiveOriginalTargetIndex_ne_ordinaryOdd
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (index : Fin m)
    (odd : index.val % 2 = 1)
    (beforeTail : index.val + 2 < m) :
    recursiveOriginalTargetIndex m large j ≠ index := by
  intro equal
  have recursiveOdd :
      (recursiveOriginalTargetIndex m large j).val % 2 = 1 := by
    rw [equal]
    exact odd
  have special := odd_originalIndex_is_special m large j recursiveOdd
  have specialValue := recursiveOriginalTargetIndex_special m large j special
  have values := congrArg Fin.val equal
  omega

end RemaudVandaeleLadderAlphaRecursiveTargetExclusion
end QuantumBlockEncoding
