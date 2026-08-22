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

/-- Passing from `r` to `r+1` adds exactly the new endpoint `r` when `r` is
odd, and adds nothing when `r` is even. -/
theorem oddBelow_succ (r : Nat) :
    oddBelow (r + 1) =
      if r % 2 = 1 then insert r (oddBelow r) else oddBelow r := by
  by_cases odd : r % 2 = 1
  · rw [if_pos odd]
    ext i
    simp [oddBelow, odd]
    constructor
    · intro h
      rcases h with ⟨bound, parity⟩
      by_cases equal : i = r
      · exact Or.inl equal
      · exact Or.inr ⟨by omega, parity⟩
    · intro h
      rcases h with rfl | h
      · exact ⟨by omega, odd⟩
      · exact ⟨by omega, h.2⟩
  · rw [if_neg odd]
    have even : r % 2 = 0 := by omega
    ext i
    simp [oddBelow]
    constructor
    · intro h
      rcases h with ⟨bound, parity⟩
      refine ⟨?_, parity⟩
      by_contra notLt
      have equal : i = r := by omega
      subst i
      omega
    · intro h
      exact ⟨by omega, h.2⟩

/-- There are exactly floor(r/2) odd indices strictly below r. -/
theorem oddBelow_card (r : Nat) : (oddBelow r).card = r / 2 := by
  induction r with
  | zero => simp [oddBelow]
  | succ r induction =>
      rw [show r + 1 = Nat.succ r by omega, oddBelow_succ r]
      by_cases odd : r % 2 = 1
      · rw [if_pos odd, Finset.card_insert_of_notMem]
        · rw [induction]
          omega
        · simp [oddBelow]
      · rw [if_neg odd, induction]
        have even : r % 2 = 0 := by omega
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
