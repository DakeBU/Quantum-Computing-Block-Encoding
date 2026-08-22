import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveParameters
import Mathlib.Tactic

/-!
# Algorithm 2: recursive child endpoint source indices

The recursive alpha-prime target arithmetic already identifies the *upper*
parent source target of each child gate.  The final Equation-(7) proof also
needs the parent source index represented by the preceding child target.

This file isolates that arithmetic from physical-wire geometry:

* for an ordinary child target j, the upper source index is 2j+2 and, when
  j>0, the preceding child target maps to source index 2j;
* for the even-k special tail, the upper source index is m-2=k-3 and, when
  j>0, the preceding child target maps to m-3=k-4;
* a special tail at child coordinate zero can occur only in the smallest
  even-k recursive instance m=3 (k=4).
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaRecursiveEndpointArithmetic

open RemaudVandaeleLadderAlphaRecursiveParameters

/-- The child coordinate immediately preceding a nonzero child target. -/
def previousChild
    (m : Nat) (j : Fin (recursiveTargetCount m)) (nonzero : j.val ≠ 0) :
    Fin (recursiveTargetCount m) :=
  ⟨j.val - 1, by omega⟩

/-- A predecessor of an ordinary child target cannot itself be the special
final child target. -/
theorem previousChild_not_special_of_current_ordinary
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (nonzero : j.val ≠ 0)
    (_ordinary : ¬ isSpecialTail m j) :
    ¬ isSpecialTail m (previousChild m j nonzero) := by
  intro specialPrevious
  have previousLast := specialPrevious.2
  have currentLt := j.isLt
  simp [previousChild] at previousLast
  omega

/-- Ordinary child target j has preceding parent source target 2j. -/
theorem previousOriginalTargetIndex_ordinary
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (nonzero : j.val ≠ 0)
    (ordinary : ¬ isSpecialTail m j) :
    (recursiveOriginalTargetIndex m large
      (previousChild m j nonzero)).val = 2 * j.val := by
  have previousOrdinary :=
    previousChild_not_special_of_current_ordinary
      m large j nonzero ordinary
  rw [recursiveOriginalTargetIndex_ordinary
    m large (previousChild m j nonzero) previousOrdinary]
  simp [previousChild]
  omega

/-- A predecessor of the special final child target is ordinary. -/
theorem previousChild_not_special_of_current_special
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (nonzero : j.val ≠ 0)
    (special : isSpecialTail m j) :
    ¬ isSpecialTail m (previousChild m j nonzero) := by
  intro specialPrevious
  have currentLast := special.2
  have previousLast := specialPrevious.2
  simp [previousChild] at previousLast
  omega

/-- For a nonzero even-k special tail, the preceding child target maps to
parent source index m-3=k-4. -/
theorem previousOriginalTargetIndex_special
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (nonzero : j.val ≠ 0)
    (special : isSpecialTail m j) :
    (recursiveOriginalTargetIndex m large
      (previousChild m j nonzero)).val = m - 3 := by
  have previousOrdinary :=
    previousChild_not_special_of_current_special
      m large j nonzero special
  rw [recursiveOriginalTargetIndex_ordinary
    m large (previousChild m j nonzero) previousOrdinary]
  have jValue := specialTail_index_value m large j special
  have evenK := special.1
  simp [previousChild]
  omega

/-- A special tail at child coordinate zero is precisely the smallest even-k
recursive instance m=3 (equivalently k=4). -/
theorem specialTail_zero_forces_m_three
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (special : isSpecialTail m j)
    (zero : j.val = 0) :
    m = 3 := by
  have jValue := specialTail_index_value m large j special
  have evenK := special.1
  have last := special.2
  unfold recursiveTargetCount RemaudVandaeleLadderAlphaResource.recursiveK at last
  omega

end RemaudVandaeleLadderAlphaRecursiveEndpointArithmetic
end QuantumBlockEncoding
