import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOuterLayers
import Mathlib.Tactic

/-!
# Remaud--Vandaele Algorithm 2: outer-wall source-index coverage

The semantic induction repeatedly needs the exact source-index partition encoded
by the two depth-one walls.  This file turns the pseudocode arithmetic into a
small reusable API.

For a parent alpha vector of length `m = k-1`:

* every even nonfinal source index is represented in `C_R`;
* every odd index strictly before the last two source positions is represented
  in a nonfinal slot of `C_L`;
* the final source index `m-1` is always the final slot of `C_L`;
* when `m` is odd (equivalently k is even), the child special source index
  `m-2 = k-3` is in neither outer wall.

The last point separates the child special tail from the extra final left-wall
gate, which targets `m-1 = k-2`.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaOuterIndexCoverage

open RemaudVandaeleLadderAlphaOuterLayers

/-- Canonical final slot of either outer wall in the recursive regime. -/
def finalWallSlot (m : Nat) (large : 2 ≤ m) : Fin (wallCount m) :=
  ⟨wallCount m - 1, by
    rw [wallCount_eq]
    omega⟩

@[simp] theorem finalWallSlot_is_last
    (m : Nat) (large : 2 ≤ m) :
    (finalWallSlot m large).val + 1 = wallCount m := by
  change wallCount m - 1 + 1 = wallCount m
  have positive : 0 < wallCount m := by
    rw [wallCount_eq]
    omega
  omega

/-- The final left-wall slot is exactly source gate `m-1`. -/
theorem leftSourceIndex_finalWallSlot
    (m : Nat) (large : 2 ≤ m) :
    (leftSourceIndex m (finalWallSlot m large)).val = m - 1 := by
  simp [leftSourceIndex, finalWallSlot_is_last m large]

/-- Canonical right-wall slot for an even source index which is not the final
source index. -/
def rightSlotOfEvenNonfinal
    {m : Nat} (index : Fin m)
    (even : index.val % 2 = 0)
    (beforeFinal : index.val + 1 < m) : Fin (wallCount m) :=
  ⟨index.val / 2, by
    rw [wallCount_eq]
    omega⟩

/-- Every even nonfinal source index occurs in `C_R`. -/
theorem rightSourceIndex_rightSlotOfEvenNonfinal
    {m : Nat} (index : Fin m)
    (even : index.val % 2 = 0)
    (beforeFinal : index.val + 1 < m) :
    rightSourceIndex m
      (rightSlotOfEvenNonfinal index even beforeFinal) = index := by
  apply Fin.ext
  simp [rightSourceIndex, rightSlotOfEvenNonfinal]
  omega

/-- Canonical nonfinal left-wall slot for an odd source index which lies
strictly before the last two source positions. -/
def leftSlotOfOddBeforeTail
    {m : Nat} (index : Fin m)
    (odd : index.val % 2 = 1)
    (beforeTail : index.val + 2 < m) : Fin (wallCount m) :=
  ⟨index.val / 2, by
    rw [wallCount_eq]
    omega⟩

/-- Such an odd slot is not the special final left-wall slot. -/
theorem leftSlotOfOddBeforeTail_not_last
    {m : Nat} (index : Fin m)
    (odd : index.val % 2 = 1)
    (beforeTail : index.val + 2 < m) :
    (leftSlotOfOddBeforeTail index odd beforeTail).val + 1 ≠ wallCount m := by
  change index.val / 2 + 1 ≠ wallCount m
  have countEq : wallCount m = m / 2 := wallCount_eq m
  omega

/-- Every ordinary odd source index before the tail occurs in `C_L`. -/
theorem leftSourceIndex_leftSlotOfOddBeforeTail
    {m : Nat} (index : Fin m)
    (odd : index.val % 2 = 1)
    (beforeTail : index.val + 2 < m) :
    leftSourceIndex m
      (leftSlotOfOddBeforeTail index odd beforeTail) = index := by
  apply Fin.ext
  have nonfinal := leftSlotOfOddBeforeTail_not_last index odd beforeTail
  unfold leftSourceIndex
  split
  · next h => exact (nonfinal h).elim
  · simp [leftSlotOfOddBeforeTail]
    omega

/-- No right-wall gate targets the final source index. -/
theorem rightSourceIndex_ne_final
    (m : Nat) (large : 2 ≤ m)
    (j : Fin (wallCount m)) :
    (rightSourceIndex m j).val ≠ m - 1 := by
  have hjHalf : j.val < m / 2 := by
    simpa only [wallCount_eq] using j.isLt
  simp [rightSourceIndex]
  omega

/-- When m is odd (k even), the child special source target `m-2` is not a
right-wall target because every right-wall source index is even. -/
theorem rightSourceIndex_ne_specialTail
    (m : Nat) (large : 3 ≤ m)
    (oddM : m % 2 = 1)
    (j : Fin (wallCount m)) :
    (rightSourceIndex m j).val ≠ m - 2 := by
  simp [rightSourceIndex]
  omega

/-- When m is odd (k even), the child special source target `m-2` is also not a
left-wall target.  The would-be odd slot is precisely the last wall slot, and
Algorithm 2 replaces that slot by the final source gate `m-1`. -/
theorem leftSourceIndex_ne_specialTail
    (m : Nat) (large : 3 ≤ m)
    (oddM : m % 2 = 1)
    (j : Fin (wallCount m)) :
    (leftSourceIndex m j).val ≠ m - 2 := by
  have countEq : wallCount m = m / 2 := wallCount_eq m
  have hj := j.isLt
  unfold leftSourceIndex
  split
  · simp
    omega
  · simp
    omega

end RemaudVandaeleLadderAlphaOuterIndexCoverage
end QuantumBlockEncoding
