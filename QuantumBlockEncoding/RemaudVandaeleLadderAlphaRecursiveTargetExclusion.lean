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
  unfold recursiveEndOriginalIndex
  split_ifs with empty
  · omega
  · let last : Fin (recursiveTargetCount m) :=
      ⟨recursiveTargetCount m - 1, by omega⟩
    change (recursiveOriginalTargetIndex m large last).val < m - 1
    by_cases special : isSpecialTail m last
    · rw [recursiveOriginalTargetIndex_special m large last special]
      omega
    · rw [recursiveOriginalTargetIndex_ordinary m large last special]
      have lastLt := last.isLt
      unfold recursiveTargetCount RemaudVandaeleLadderAlphaResource.recursiveK at lastLt
      omega

/-- No recursive child target maps to parent source target zero. -/
theorem recursiveOriginalTargetIndex_ne_zero
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    recursiveOriginalTargetIndex m large j ≠ ⟨0, by omega⟩ := by
  intro equal
  have positive := recursiveOriginalTargetIndex_pos m large j
  have values := congrArg Fin.val equal
  omega

/-- No recursive child target maps to the final parent source target. -/
theorem recursiveOriginalTargetIndex_ne_final
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    recursiveOriginalTargetIndex m large j ≠ ⟨m - 1, by omega⟩ := by
  intro equal
  have atMostEnd := recursiveOriginalTargetIndex_le_end m large j
  have endBeforeFinal := recursiveEndOriginalIndex_lt_final m large
  have values := congrArg Fin.val equal
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
  have endEq := recursiveOriginalTargetIndex_odd_eq_end m large j recursiveOdd
  have endBeforeFinal := recursiveEndOriginalIndex_lt_final m large
  have values := congrArg Fin.val (equal.symm.trans endEq)
  omega

end RemaudVandaeleLadderAlphaRecursiveTargetExclusion
end QuantumBlockEncoding
