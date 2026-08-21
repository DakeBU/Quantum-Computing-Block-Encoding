import QuantumBlockEncoding.ComparatorIncrementerEq39BlockCascade

/-!
# Local activation semantics in Vandaele Equation (39)

The mixed-radix Equation-(39) theorem gives the complete modular successor.
Figure 10 additionally needs a local source interpretation: the increment on
block i+1 is active exactly when the carry into block i is still one and block i
is maximal.  On that active branch, block i itself becomes zero and can serve as
the clean promise register for the next controlled increment.

This file packages those statements in the power-of-two block language used by
the Vandaele formalization.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerEq39LocalActivation

open ComparatorIncrementerEq39BlockCascade
open MixedRadixIncrement

/-- Carry into the next block iff the current carry is active and the current
block is the all-ones / maximal radix value. -/
theorem nextCarry_eq_one_iff_active
    (width digit : Nat → Nat)
    (digitBound : ∀ i, digit i < blockBase width i)
    (i : Nat) :
    blockCarry width digit (i + 1) = 1 ↔
      blockCarry width digit i = 1 ∧
        digit i = blockBase width i - 1 := by
  exact carry_succ_eq_one_iff_active
    (blockBase width) digit
    (blockBase_pos width) digitBound i

/-- Active all-ones block becomes the zero block after its increment. -/
theorem activeBlock_output_zero
    (width digit : Nat → Nat)
    (i : Nat)
    (incoming : blockCarry width digit i = 1)
    (maximal : digit i = blockBase width i - 1) :
    blockOutput width digit i = 0 := by
  exact output_eq_zero_of_active
    (blockBase width) digit (blockBase_pos width)
    i incoming maximal

/-- Once the carry is inactive, the current block is unchanged. -/
theorem inactiveBlock_unchanged
    (width digit : Nat → Nat)
    (digitBound : ∀ i, digit i < blockBase width i)
    (i : Nat)
    (inactive : blockCarry width digit i = 0) :
    blockOutput width digit i = digit i := by
  exact output_eq_digit_of_no_carry
    (blockBase width) digit digitBound i inactive

/-- Reader-facing combination: an outgoing carry both certifies the all-ones
activation condition and certifies that the current output block is zero. -/
theorem nextCarry_implies_clean_current_block
    (width digit : Nat → Nat)
    (digitBound : ∀ i, digit i < blockBase width i)
    (i : Nat)
    (outgoing : blockCarry width digit (i + 1) = 1) :
    blockCarry width digit i = 1 ∧
      digit i = blockBase width i - 1 ∧
      blockOutput width digit i = 0 := by
  have active :=
    (nextCarry_eq_one_iff_active width digit digitBound i).1 outgoing
  exact ⟨active.1, active.2,
    activeBlock_output_zero width digit i active.1 active.2⟩

end ComparatorIncrementerEq39LocalActivation
end QuantumBlockEncoding
