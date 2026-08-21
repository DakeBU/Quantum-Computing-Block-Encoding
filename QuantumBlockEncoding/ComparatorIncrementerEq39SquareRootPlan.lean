import QuantumBlockEncoding.ComparatorIncrementerEq39BlockCascade
import Mathlib.Tactic

/-!
# Canonical square-root block plan for Vandaele Equation (39)

To avoid a separate ceiling-division API, use exactly
`s = ceil(sqrt n)` logical block slots and define cut points

`a_i = min(n, i*s)`.

The width of slot i is `a_{i+1}-a_i`.  Since `n <= s^2`, the first s slots cover
all n target bits.  Widths after the final nonempty block are zero; they do not
represent padded qubits because their radix is one.  The construction therefore
preserves the exact n-bit modulus while giving the source bounds

* number of slots <= s;
* every block width <= s;
* sum of block widths = n.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerEq39SquareRootPlan

open scoped BigOperators
open ComparatorIncrementerEq39BlockCascade
open ComparatorIncrementerLemma8Budget

/-- Truncated start index of square-root slot i. -/
def slotStart (n s i : Nat) : Nat := min n (i * s)

/-- Width of one truncated slot. -/
def slotWidth (n s i : Nat) : Nat :=
  slotStart n s (i + 1) - slotStart n s i

/-- Slot starts are monotone. -/
theorem slotStart_mono (n s i : Nat) :
    slotStart n s i ≤ slotStart n s (i + 1) := by
  unfold slotStart
  have mulLe : i * s ≤ (i + 1) * s := by
    nlinarith
  exact min_le_min (Nat.le_refl n) mulLe

/-- One slot advances by at most s target bits. -/
theorem slotStart_succ_le_add (n s i : Nat) :
    slotStart n s (i + 1) ≤ slotStart n s i + s := by
  unfold slotStart
  by_cases covered : n ≤ i * s
  · have current : min n (i * s) = n := min_eq_left covered
    rw [current]
    exact Nat.le_add_right n s
  · have before : i * s ≤ n := by omega
    have current : min n (i * s) = i * s := min_eq_right before
    have nextLe : min n ((i + 1) * s) ≤ (i + 1) * s := min_le_right _ _
    rw [current]
    calc
      min n ((i + 1) * s) ≤ (i + 1) * s := nextLe
      _ = i * s + s := by ring

/-- Consequently every slot width is at most s. -/
theorem slotWidth_le (n s i : Nat) : slotWidth n s i ≤ s := by
  have mono := slotStart_mono n s i
  have upper := slotStart_succ_le_add n s i
  unfold slotWidth
  omega

/-- Truncated slot widths telescope exactly to the final cut point. -/
theorem sum_slotWidth (n s : Nat) :
    ∀ blocks,
      (∑ i ∈ Finset.range blocks, slotWidth n s i) =
        slotStart n s blocks := by
  intro blocks
  induction blocks with
  | zero =>
      simp [slotStart]
  | succ blocks induction =>
      rw [Finset.sum_range_succ]
      rw [induction]
      have mono := slotStart_mono n s blocks
      unfold slotWidth
      omega

/-- With s=ceil(sqrt n), the final square-root cut reaches n exactly. -/
theorem final_slotStart_eq_n (n : Nat) :
    slotStart n (blockWidth n) (blockSlots n) = n := by
  have capacity := block_capacity n
  unfold slotStart blockWidth blockSlots
  exact min_eq_left capacity

/-- Canonical source width stream. -/
def canonicalWidth (n : Nat) (i : Nat) : Nat :=
  slotWidth n (blockWidth n) i

/-- The canonical widths sum to exactly n. -/
theorem canonicalWidth_partitions (n : Nat) :
    widthMass (canonicalWidth n) (blockSlots n) = n := by
  unfold widthMass canonicalWidth
  rw [sum_slotWidth]
  exact final_slotStart_eq_n n

/-- Every canonical block is no wider than ceil(sqrt n). -/
theorem canonicalWidth_le_blockWidth
    (n i : Nat) : canonicalWidth n i ≤ blockWidth n := by
  exact slotWidth_le n (blockWidth n) i

/-- Actual canonical plan inhabiting the source-facing Equation-(39) plan. -/
def canonicalPlan (n : Nat) : SquareRootBlockPlan n where
  blocks := blockSlots n
  width := canonicalWidth n
  partitions := canonicalWidth_partitions n
  blockWidthBound := by
    intro i _
    exact canonicalWidth_le_blockWidth n i
  blockCountBound := Nat.le_refl _

/-- The canonical square-root plan therefore inherits the exact n-bit modular
successor semantics. -/
theorem canonicalPlan_successor
    (n : Nat)
    (digit : Nat → Nat)
    (digitBound : ∀ i, digit i < blockBase (canonicalWidth n) i)
    (inputValue : Nat)
    (reconstructs :
      blockValue (canonicalWidth n) digit (blockSlots n) = inputValue) :
    blockValue (canonicalWidth n)
        (blockOutput (canonicalWidth n) digit) (blockSlots n) % gridSize n =
      (inputValue + 1) % gridSize n := by
  exact squareRootPlan_successor
    n (canonicalPlan n) digit digitBound inputValue reconstructs

end ComparatorIncrementerEq39SquareRootPlan
end QuantumBlockEncoding
