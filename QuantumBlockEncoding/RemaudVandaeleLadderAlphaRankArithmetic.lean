import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveParameters
import Mathlib.Data.Finset.Card
import Mathlib.Tactic

/-!
# Algorithm 2: alpha-prime is physical rank after deleting odd targets

The selected recursive register removes exactly odd-numbered intermediate alpha
targets.  Before original source target r there are therefore `floor(r/2)`
deleted wires.  This gives one uniform compact-rank formula

`alpha_r - alpha_0 - floor(r/2)`.

The two pseudocode formulas (ordinary even target and even-k special tail) are
specializations of this single count identity.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaRankArithmetic

open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaRecursiveParameters

/-- Odd natural indices below r. -/
def oddBelow (r : Nat) : Finset Nat :=
  (Finset.range r).filter (fun i => i % 2 = 1)

/-- There are exactly floor(r/2) odd indices strictly below r. -/
theorem oddBelow_card (r : Nat) : (oddBelow r).card = r / 2 := by
  induction r using Nat.twoStepInduction with
  | zero => simp [oddBelow]
  | one => simp [oddBelow]
  | more r induction =>
      have parity : (r + 1) % 2 = 1 ↔ r % 2 = 0 := by omega
      rw [show oddBelow (r + 2) =
          insert (r + 1) (oddBelow r) by
        ext i
        simp [oddBelow]
        constructor
        · intro h
          rcases h with ⟨lt,odd⟩
          by_cases equal : i = r + 1
          · exact Or.inl equal
          · right
            constructor <;> omega
        · intro h
          rcases h with rfl | h
          · constructor <;> omega
          · rcases h with ⟨lt,odd⟩
            exact ⟨by omega,odd⟩]
      have fresh : r + 1 ∉ oddBelow r := by
        simp [oddBelow]
      rw [Finset.card_insert_of_not_mem fresh, induction]
      omega

/-- Number of deleted targets before one recursive source target is exactly half
its original target index. -/
theorem deletedTargetCount_eq_halfOriginalIndex
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    deletedTargetCount m j =
      (recursiveOriginalTargetIndex m large j).val / 2 := by
  by_cases special : isSpecialTail m j
  · have jValue := specialTail_index_value m large j special
    have evenK := special.1
    simp [deletedTargetCount, special,
      recursiveOriginalTargetIndex, jValue]
    omega
  · simp [deletedTargetCount, special,
      recursiveOriginalTargetIndex]

/-- Uniform compact rank formula before proving the list-level `idxOf` theorem. -/
def compactRank
    {q m : Nat} (plan : AlphaPlan q m)
    (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) : Nat :=
  let original := recursiveOriginalTargetIndex m large j
  (plan.target original).val -
    (plan.target ⟨0, by omega⟩).val - original.val / 2

/-- Source alpha-prime arithmetic is exactly the compact rank obtained by
subtracting deleted odd targets. -/
theorem recursiveAlphaValue_eq_compactRank
    {q m : Nat} (plan : AlphaPlan q m)
    (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    recursiveAlphaValue plan large j = compactRank plan large j := by
  unfold recursiveAlphaValue compactRank
  rw [deletedTargetCount_eq_halfOriginalIndex m large j]

/-- Reader-facing deleted-wire count at one recursive target. -/
theorem deleted_before_recursive_target
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    (oddBelow (recursiveOriginalTargetIndex m large j).val).card =
      deletedTargetCount m j := by
  rw [oddBelow_card, deletedTargetCount_eq_halfOriginalIndex m large j]

end RemaudVandaeleLadderAlphaRankArithmetic
end QuantumBlockEncoding
