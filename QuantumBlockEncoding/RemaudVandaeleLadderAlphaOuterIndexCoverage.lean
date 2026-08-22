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

def finalWallSlot (m : Nat) (large : 2 ≤ m) : Fin (wallCount m) :=
  ⟨wallCount m - 1, by rw [wallCount_eq]; omega⟩

@[simp] theorem finalWallSlot_is_last
    (m : Nat) (large : 2 ≤ m) :
    (finalWallSlot m large).val + 1 = wallCount m := by
  have positive : 0 < wallCount m := by rw [wallCount_eq]; omega
  change wallCount m - 1 + 1 = wallCount m
  omega

theorem leftSourceIndex_finalWallSlot
    (m : Nat) (large : 2 ≤ m) :
    (leftSourceIndex m (finalWallSlot m large)).val = m - 1 := by
  simp [leftSourceIndex, finalWallSlot_is_last m large]

def rightSlotOfEvenNonfinal
    {m : Nat} (index : Fin m)
    (even : index.val % 2 = 0)
    (beforeFinal : index.val + 1 < m) : Fin (wallCount m) :=
  ⟨index.val / 2, by rw [wallCount_eq]; omega⟩

theorem rightSourceIndex_rightSlotOfEvenNonfinal
    {m : Nat} (index : Fin m)
    (even : index.val % 2 = 0)
    (beforeFinal : index.val + 1 < m) :
    rightSourceIndex m
      (rightSlotOfEvenNonfinal index even beforeFinal) = index := by
  apply Fin.ext
  simp [rightSourceIndex, rightSlotOfEvenNonfinal]
  omega

def leftSlotOfOddBeforeTail
    {m : Nat} (index : Fin m)
    (odd : index.val % 2 = 1)
    (beforeTail : index.val + 2 < m) : Fin (wallCount m) :=
  ⟨index.val / 2, by rw [wallCount_eq]; omega⟩

theorem leftSlotOfOddBeforeTail_not_last
    {m : Nat} (index : Fin m)
    (odd : index.val % 2 = 1)
    (beforeTail : index.val + 2 < m) :
    (leftSlotOfOddBeforeTail index odd beforeTail).val + 1 ≠ wallCount m := by
  change index.val / 2 + 1 ≠ wallCount m
  rw [wallCount_eq]
  omega

theorem leftSourceIndex_leftSlotOfOddBeforeTail
    {m : Nat} (index : Fin m)
    (odd : index.val % 2 = 1)
    (beforeTail : index.val + 2 < m) :
    leftSourceIndex m
      (leftSlotOfOddBeforeTail index odd beforeTail) = index := by
  have nonfinal := leftSlotOfOddBeforeTail_not_last index odd beforeTail
  unfold leftSourceIndex
  rw [dif_neg nonfinal]
  apply Fin.ext
  change 2 * (index.val / 2) + 1 = index.val
  omega

theorem rightSourceIndex_ne_final
    (m : Nat) (large : 2 ≤ m)
    (j : Fin (wallCount m)) :
    (rightSourceIndex m j).val ≠ m - 1 := by
  have hjHalf : j.val < m / 2 := by
    simpa only [wallCount_eq] using j.isLt
  simp [rightSourceIndex]
  omega

theorem rightSourceIndex_ne_specialTail
    (m : Nat) (large : 3 ≤ m)
    (oddM : m % 2 = 1)
    (j : Fin (wallCount m)) :
    (rightSourceIndex m j).val ≠ m - 2 := by
  simp [rightSourceIndex]
  omega

theorem leftSourceIndex_ne_specialTail
    (m : Nat) (large : 3 ≤ m)
    (oddM : m % 2 = 1)
    (j : Fin (wallCount m)) :
    (leftSourceIndex m j).val ≠ m - 2 := by
  intro equal
  by_cases final : j.val + 1 = wallCount m
  · have sourceVal : (leftSourceIndex m j).val = m - 1 := by
      unfold leftSourceIndex
      rw [dif_pos final]
    rw [sourceVal] at equal
    omega
  · have hjHalf : j.val < m / 2 := by
      simpa only [wallCount_eq] using j.isLt
    have sourceVal : (leftSourceIndex m j).val = 2 * j.val + 1 := by
      unfold leftSourceIndex
      rw [dif_neg final]
    rw [sourceVal] at equal
    have nonlastHalf : j.val + 1 ≠ m / 2 := by
      intro lastHalf
      apply final
      simpa only [wallCount_eq] using lastHalf
    omega

end RemaudVandaeleLadderAlphaOuterIndexCoverage
end QuantumBlockEncoding