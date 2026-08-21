import QuantumBlockEncoding.RemaudVandaeleLadder1WallSemantics
import Mathlib.Tactic

/-!
# Target-wire classification for Remaud--Vandaele Algorithm 1

The source proof expands `U_L`, the recursive `U_X'`, and `U_R` by parity of the
physical wire index.  This module isolates that integer geometry from the gate
semantics.

In the non-base regime `n >= 3`:

* the last physical wire `n-1` is the special last target of `C_L`;
* every nonlast odd wire is a target of `C_R` and is also selected into `X'`;
* an even nonlast wire different from `n-2` is a non-special target of `C_L`
  and is outside `X'`;
* when `n-2` is even (the even-width case), it is the final selected wire of
  `X'` and is not a `C_L` target.

These facts are the complete wire-index content needed by the arbitrary-width
correctness induction.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadder1TargetGeometry

open RemaudVandaeleLadder1AlgorithmPlan
open RemaudVandaeleLadder1WallSemantics

/-- Physical target wire corresponding to a public `L_1^(n-1)` target index. -/
def physicalTarget
    {n : Nat} (positive : 0 < n) (index : Fin (n - 1)) : Fin n :=
  ⟨index.val + 1, by omega⟩

/-- Its preceding physical wire. -/
def physicalPrevious
    {n : Nat} (positive : 0 < n) (index : Fin (n - 1)) : Fin n :=
  ⟨index.val, by omega⟩

@[simp] theorem physicalTarget_val
    {n : Nat} (positive : 0 < n) (index : Fin (n - 1)) :
    (physicalTarget positive index).val = index.val + 1 := rfl

@[simp] theorem physicalPrevious_val
    {n : Nat} (positive : 0 < n) (index : Fin (n - 1)) :
    (physicalPrevious positive index).val = index.val := rfl

/-- Outer walls are nonempty for `n>=3`. -/
theorem outerCount_pos {n : Nat} (large : 3 ≤ n) : 0 < outerCount n := by
  unfold outerCount
  omega

/-- Recursive register is nonempty for `n>=3`. -/
theorem recursiveWidth_pos {n : Nat} (large : 3 ≤ n) : 0 < recursiveWidth n := by
  unfold recursiveWidth
  omega

/-- Last source `C_L` gate really targets physical `n-1`. -/
def lastLeftIndex (n : Nat) (large : 3 ≤ n) : Fin (outerCount n) :=
  ⟨outerCount n - 1, by exact Nat.sub_lt (outerCount_pos large) (by omega)⟩

@[simp] theorem lastLeftIndex_is_last
    (n : Nat) (large : 3 ≤ n) :
    (lastLeftIndex n large).val + 1 = outerCount n := by
  simp [lastLeftIndex, Nat.sub_add_cancel (Nat.one_le_iff_ne_zero.mpr
    (Nat.ne_of_gt (outerCount_pos large)))]

/-- Special left target is the final physical wire. -/
theorem leftTarget_last
    (n : Nat) (large : 3 ≤ n) :
    leftTarget n (lastLeftIndex n large) = ⟨n - 1, by omega⟩ := by
  apply Fin.ext
  simp [leftTarget, lastLeftIndex_is_last n large]

/-- Its control is physical `n-2`. -/
theorem leftControl_last
    (n : Nat) (large : 3 ≤ n) :
    leftControl n (lastLeftIndex n large) = ⟨n - 2, by omega⟩ := by
  apply Fin.ext
  simp [leftControl, lastLeftIndex_is_last n large]

/-- Nonlast odd physical wire determines a right-wall gate index. -/
def rightIndexOfOdd
    {n : Nat} (large : 3 ≤ n)
    (wire : Fin n)
    (nonlast : wire.val ≠ n - 1)
    (odd : wire.val % 2 = 1) : Fin (outerCount n) :=
  ⟨wire.val / 2, by
    have division := Nat.mod_add_div wire.val 2
    have wireLt := wire.isLt
    unfold outerCount
    omega⟩

/-- That right-wall gate has exactly the supplied odd target. -/
theorem rightTarget_of_odd
    {n : Nat} (large : 3 ≤ n)
    (wire : Fin n)
    (nonlast : wire.val ≠ n - 1)
    (odd : wire.val % 2 = 1) :
    rightTarget n (rightIndexOfOdd large wire nonlast odd) = wire := by
  apply Fin.ext
  have division := Nat.mod_add_div wire.val 2
  simp [rightTarget, rightIndexOfOdd]
  omega

/-- The even right control is the physical predecessor of the odd target. -/
theorem rightControl_of_odd
    {n : Nat} (large : 3 ≤ n)
    (wire : Fin n)
    (nonlast : wire.val ≠ n - 1)
    (odd : wire.val % 2 = 1) :
    (rightControl n (rightIndexOfOdd large wire nonlast odd)).val =
      wire.val - 1 := by
  have division := Nat.mod_add_div wire.val 2
  simp [rightControl, rightIndexOfOdd]
  omega

/-- Every nonlast odd right target is one of the selected recursive wires. -/
theorem recursiveWire_of_odd
    {n : Nat} (large : 3 ≤ n)
    (wire : Fin n)
    (nonlast : wire.val ≠ n - 1)
    (odd : wire.val % 2 = 1) :
    recursiveWire n
      (rightRecursiveIndex n (rightIndexOfOdd large wire nonlast odd)) = wire := by
  rw [recursiveWire_rightRecursiveIndex]
  exact rightTarget_of_odd large wire nonlast odd

/-- Nonfirst odd target has the expected previous selected wire `wire-2`. -/
theorem previousRecursiveWire_of_odd
    {n : Nat} (large : 3 ≤ n)
    (wire : Fin n)
    (nonlast : wire.val ≠ n - 1)
    (odd : wire.val % 2 = 1)
    (notFirst : wire.val ≠ 1) :
    let j := rightIndexOfOdd large wire nonlast odd
    (recursiveWire n
      (rightPreviousRecursiveIndex n j (by
        have division := Nat.mod_add_div wire.val 2
        simp [j, rightIndexOfOdd]
        omega))).val = wire.val - 2 := by
  dsimp
  have division := Nat.mod_add_div wire.val 2
  have jNonzero : (rightIndexOfOdd large wire nonlast odd).val ≠ 0 := by
    simp [rightIndexOfOdd]
    omega
  have source := rightPreviousRecursiveWire_val n
    (rightIndexOfOdd large wire nonlast odd) jNonzero
  simp [rightIndexOfOdd] at source
  omega

/-- Index of a normal even `C_L` target. -/
def leftIndexOfEven
    {n : Nat} (large : 3 ≤ n)
    (wire : Fin n)
    (positiveWire : 0 < wire.val)
    (even : wire.val % 2 = 0)
    (notPenultimate : wire.val ≠ n - 2)
    (nonlast : wire.val ≠ n - 1) : Fin (outerCount n) :=
  ⟨wire.val / 2 - 1, by
    have division := Nat.mod_add_div wire.val 2
    have wireLt := wire.isLt
    unfold outerCount
    omega⟩

/-- A normal even target is not the special final left gate. -/
theorem leftIndexOfEven_not_last
    {n : Nat} (large : 3 ≤ n)
    (wire : Fin n)
    (positiveWire : 0 < wire.val)
    (even : wire.val % 2 = 0)
    (notPenultimate : wire.val ≠ n - 2)
    (nonlast : wire.val ≠ n - 1) :
    (leftIndexOfEven large wire positiveWire even notPenultimate nonlast).val + 1 ≠
      outerCount n := by
  have division := Nat.mod_add_div wire.val 2
  have wireLt := wire.isLt
  simp [leftIndexOfEven]
  unfold outerCount
  omega

/-- That non-special left gate has exactly the supplied even target. -/
theorem leftTarget_of_even
    {n : Nat} (large : 3 ≤ n)
    (wire : Fin n)
    (positiveWire : 0 < wire.val)
    (even : wire.val % 2 = 0)
    (notPenultimate : wire.val ≠ n - 2)
    (nonlast : wire.val ≠ n - 1) :
    leftTarget n
      (leftIndexOfEven large wire positiveWire even notPenultimate nonlast) = wire := by
  apply Fin.ext
  have notLast := leftIndexOfEven_not_last
    large wire positiveWire even notPenultimate nonlast
  have division := Nat.mod_add_div wire.val 2
  simp [leftTarget, leftIndexOfEven, notLast]
  omega

/-- Its control is exactly the preceding physical wire. -/
theorem leftControl_of_even
    {n : Nat} (large : 3 ≤ n)
    (wire : Fin n)
    (positiveWire : 0 < wire.val)
    (even : wire.val % 2 = 0)
    (notPenultimate : wire.val ≠ n - 2)
    (nonlast : wire.val ≠ n - 1) :
    (leftControl n
      (leftIndexOfEven large wire positiveWire even notPenultimate nonlast)).val =
      wire.val - 1 := by
  have notLast := leftIndexOfEven_not_last
    large wire positiveWire even notPenultimate nonlast
  have division := Nat.mod_add_div wire.val 2
  simp [leftControl, leftIndexOfEven, notLast]
  omega

/-- A normal even `C_L` target is outside the recursive selected register. -/
theorem even_not_recursive
    {n : Nat} (large : 3 ≤ n)
    (wire : Fin n)
    (positiveWire : 0 < wire.val)
    (even : wire.val % 2 = 0)
    (notPenultimate : wire.val ≠ n - 2)
    (recursive : Fin (recursiveWidth n)) :
    recursiveWire n recursive ≠ wire := by
  intro equal
  have values := congrArg Fin.val equal
  by_cases last : recursive.val + 1 = recursiveWidth n
  · simp [recursiveWire, last] at values
    exact notPenultimate values
  · simp [recursiveWire, last] at values
    have division := Nat.mod_add_div wire.val 2
    omega

/-- The final selected recursive index. -/
def lastRecursiveIndex (n : Nat) (large : 3 ≤ n) :
    Fin (recursiveWidth n) :=
  ⟨recursiveWidth n - 1, by
    exact Nat.sub_lt (recursiveWidth_pos large) (by omega)⟩

@[simp] theorem lastRecursiveIndex_is_last
    (n : Nat) (large : 3 ≤ n) :
    (lastRecursiveIndex n large).val + 1 = recursiveWidth n := by
  simp [lastRecursiveIndex, Nat.sub_add_cancel (Nat.one_le_iff_ne_zero.mpr
    (Nat.ne_of_gt (recursiveWidth_pos large)))]

/-- The final selected wire is physical `n-2`. -/
theorem recursiveWire_last
    (n : Nat) (large : 3 ≤ n) :
    recursiveWire n (lastRecursiveIndex n large) = ⟨n - 2, by omega⟩ := by
  apply Fin.ext
  simp [recursiveWire, lastRecursiveIndex_is_last n large]

/-- In the only case where physical `n-2` is even and nonlast, the preceding
selected wire is physical `n-3`. -/
theorem recursiveWire_before_last
    {n : Nat} (large : 4 ≤ n)
    (penultimateEven : (n - 2) % 2 = 0) :
    let last := lastRecursiveIndex n (by omega)
    let previous : Fin (recursiveWidth n) := ⟨last.val - 1, by
      have widthPos := recursiveWidth_pos (n := n) (by omega)
      have widthTwo : 2 ≤ recursiveWidth n := by
        unfold recursiveWidth
        omega
      simp [last, lastRecursiveIndex]
      omega⟩
    (recursiveWire n previous).val = n - 3 := by
  dsimp
  have widthTwo : 2 ≤ recursiveWidth n := by
    unfold recursiveWidth
    omega
  have notLast :
      (recursiveWidth n - 1 - 1) + 1 ≠ recursiveWidth n := by omega
  simp [recursiveWire, lastRecursiveIndex, notLast]
  unfold recursiveWidth
  have division := Nat.mod_add_div n 2
  omega

end RemaudVandaeleLadder1TargetGeometry
end QuantumBlockEncoding
