import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveParameters
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaSelectedRegister
import Mathlib.Tactic

/-!
# Algorithm 2: order of recursive source targets

The compact recursive target list must preserve the source target order.  The
ordinary entries use original indices 2,4,6,...; only the final entry of an
even-k recursion may be the special source index k-3.  This module proves that
those original indices are strictly increasing and that every recursive target
is either even-indexed or is the final source target kept by X'.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaRecursiveOrder

open RemaudVandaeleLadderAlphaRecursiveParameters
open RemaudVandaeleLadderAlphaSelectedRegister

/-- Original source indices selected by Algorithm 2 are strictly increasing. -/
theorem recursiveOriginalTargetIndex_strict
    (m : Nat) (large : 3 ≤ m + 1)
    {i j : Fin (recursiveTargetCount m)} (order : i < j) :
    (recursiveOriginalTargetIndex m large i).val <
      (recursiveOriginalTargetIndex m large j).val := by
  by_cases specialJ : isSpecialTail m j
  · have jLast := specialJ.2
    have notSpecialI : ¬ isSpecialTail m i := by
      intro specialI
      have iLast := specialI.2
      omega
    rw [recursiveOriginalTargetIndex_ordinary m large i notSpecialI,
      recursiveOriginalTargetIndex_special m large j specialJ]
    have hi := i.isLt
    have evenK := specialJ.1
    unfold recursiveTargetCount RemaudVandaeleLadderAlphaResource.recursiveK at hi
    omega
  · have notSpecialI : ¬ isSpecialTail m i := by
      intro specialI
      have iLast := specialI.2
      have jLt := j.isLt
      omega
    rw [recursiveOriginalTargetIndex_ordinary m large i notSpecialI,
      recursiveOriginalTargetIndex_ordinary m large j specialJ]
    omega

/-- Hence the source-index map is injective. -/
theorem recursiveOriginalTargetIndex_injective
    (m : Nat) (large : 3 ≤ m + 1) :
    Function.Injective (recursiveOriginalTargetIndex m large) := by
  intro i j equal
  by_contra different
  rcases lt_or_gt_of_ne different with order | order
  · have strict := recursiveOriginalTargetIndex_strict m large order
    have values := congrArg Fin.val equal
    omega
  · have strict := recursiveOriginalTargetIndex_strict m large order
    have values := congrArg Fin.val equal
    omega

/-- Every ordinary recursive source target has even original index. -/
theorem ordinary_originalIndex_even
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (ordinary : ¬ isSpecialTail m j) :
    (recursiveOriginalTargetIndex m large j).val % 2 = 0 := by
  rw [recursiveOriginalTargetIndex_ordinary m large j ordinary]
  omega

/-- Any odd-indexed recursive source target must be the special final target. -/
theorem odd_originalIndex_is_special
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (odd : (recursiveOriginalTargetIndex m large j).val % 2 = 1) :
    isSpecialTail m j := by
  by_contra ordinary
  have even := ordinary_originalIndex_even m large j ordinary
  omega

/-- If the recursive target vector is nonempty, its final element maps to the
physical recursive-end source index. -/
theorem recursiveEnd_eq_last
    (m : Nat) (large : 3 ≤ m + 1)
    (nonempty : 0 < recursiveTargetCount m) :
    recursiveEndOriginalIndex m large =
      recursiveOriginalTargetIndex m large
        ⟨recursiveTargetCount m - 1, by omega⟩ := by
  unfold recursiveEndOriginalIndex
  simp [Nat.ne_of_gt nonempty]

/-- Every recursive source target is no later than the end source target. -/
theorem recursiveOriginalTargetIndex_le_end
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    (recursiveOriginalTargetIndex m large j).val ≤
      (recursiveEndOriginalIndex m large).val := by
  have nonempty : 0 < recursiveTargetCount m := Nat.zero_lt_of_lt j.isLt
  rw [recursiveEnd_eq_last m large nonempty]
  let last : Fin (recursiveTargetCount m) :=
    ⟨recursiveTargetCount m - 1, by omega⟩
  by_cases equal : j = last
  · subst j
    rfl
  · have order : j < last := by
      have hj := j.isLt
      simp [last]
      omega
    exact (recursiveOriginalTargetIndex_strict m large order).le

/-- An odd-indexed recursive source target is necessarily the physical end
source target and is therefore retained by the strict-before deletion rule. -/
theorem odd_recursiveTarget_eq_end
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (odd : (recursiveOriginalTargetIndex m large j).val % 2 = 1) :
    recursiveOriginalTargetIndex m large j =
      recursiveEndOriginalIndex m large := by
  have special := odd_originalIndex_is_special m large j odd
  have last := special.2
  have nonempty : 0 < recursiveTargetCount m := Nat.zero_lt_of_lt j.isLt
  rw [recursiveEnd_eq_last m large nonempty]
  apply recursiveOriginalTargetIndex_injective m large
  apply Fin.ext
  simp
  omega

end RemaudVandaeleLadderAlphaRecursiveOrder
end QuantumBlockEncoding
