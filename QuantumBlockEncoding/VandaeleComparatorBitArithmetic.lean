import QuantumBlockEncoding.VandaeleComparatorCarryArithmetic
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Tactic

/-!
# Bit-register arithmetic for the Vandaele comparator audit

This file connects the pure `Nat` carry identities to the actual little-endian
`BitRegister` contract used for Equation (17).

The two structural facts are standard but source-critical here:

* every `n`-bit register has value strictly below `2^n`;
* applying X to every bit sends a word value `b` to `2^n - 1 - b`.

Combining them with `VandaeleComparatorCarryArithmetic` gives a generic register
statement: the outgoing carry of adding `a` to the bitwise-X image of `b` is
present exactly when `value(b) < value(a)`.  This is the arithmetic boundary a
future full Figure-5 circuit refinement should target.
-/

namespace QuantumBlockEncoding
namespace VandaeleComparatorBitArithmetic

open scoped BigOperators
open VandaeleComparatorContract
open VandaeleComparatorCarryArithmetic

/-- Drop the least-significant bit of a little-endian register. -/
def tailBits {n : Nat} (bits : BitRegister (n + 1)) : BitRegister n :=
  fun index => bits index.succ

/-- Apply the computational-basis X action to every bit of a register. -/
def bitwiseNot {n : Nat} (bits : BitRegister n) : BitRegister n :=
  fun index => flipFlag (bits index)

@[simp] theorem bitwiseNot_apply {n : Nat}
    (bits : BitRegister n) (index : Fin n) :
    bitwiseNot bits index = flipFlag (bits index) := by
  rfl

/-- Bitwise X is itself an involution, matching the two X-layers displayed
around the subtraction/comparator construction. -/
@[simp] theorem bitwiseNot_bitwiseNot {n : Nat}
    (bits : BitRegister n) :
    bitwiseNot (bitwiseNot bits) = bits := by
  funext index
  simp [bitwiseNot]

@[simp] theorem flipFlag_val (bit : Fin 2) :
    (flipFlag bit).val = 1 - bit.val := by
  fin_cases bit <;> rfl

@[simp] theorem tailBits_bitwiseNot {n : Nat}
    (bits : BitRegister (n + 1)) :
    tailBits (bitwiseNot bits) = bitwiseNot (tailBits bits) := by
  rfl

/-- Little-endian value decomposes into the least-significant bit plus twice the
value of the remaining tail. -/
theorem littleEndianValue_succ {n : Nat}
    (bits : BitRegister (n + 1)) :
    littleEndianValue bits =
      (bits 0).val + 2 * littleEndianValue (tailBits bits) := by
  unfold littleEndianValue
  rw [Fin.sum_univ_succ]
  simp only [Fin.val_zero, pow_zero, Nat.mul_one]
  congr 1
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro index _
  simp only [tailBits, Fin.val_succ, pow_succ]
  ac_rfl

/-- Every `n`-bit little-endian register denotes an integer in `[0,2^n)`. -/
theorem littleEndianValue_lt_wordModulus
    (n : Nat) (bits : BitRegister n) :
    littleEndianValue bits < wordModulus n := by
  induction n generalizing bits with
  | zero =>
      simp [littleEndianValue, wordModulus]
  | succ n induction =>
      rw [littleEndianValue_succ]
      have tailBound := induction (tailBits bits)
      have bitBound : (bits 0).val < 2 := (bits 0).isLt
      simp only [wordModulus, pow_succ] at tailBound ⊢
      omega

/-- Bitwise X is the usual ones-complement operation on unsigned word values. -/
theorem littleEndianValue_bitwiseNot
    (n : Nat) (bits : BitRegister n) :
    littleEndianValue (bitwiseNot bits) =
      onesComplementValue n (littleEndianValue bits) := by
  induction n generalizing bits with
  | zero =>
      simp [littleEndianValue, bitwiseNot, onesComplementValue, wordModulus]
  | succ n induction =>
      calc
        littleEndianValue (bitwiseNot bits) =
            (bitwiseNot bits 0).val +
              2 * littleEndianValue (tailBits (bitwiseNot bits)) :=
          littleEndianValue_succ (bitwiseNot bits)
        _ = (1 - (bits 0).val) +
              2 * littleEndianValue (bitwiseNot (tailBits bits)) := by
          simp only [bitwiseNot_apply, flipFlag_val, tailBits_bitwiseNot]
        _ = (1 - (bits 0).val) +
              2 * onesComplementValue n
                (littleEndianValue (tailBits bits)) := by
          rw [induction]
        _ = onesComplementValue (n + 1) (littleEndianValue bits) := by
          have tailBound :=
            littleEndianValue_lt_wordModulus n (tailBits bits)
          have bitBound : (bits 0).val < 2 := (bits 0).isLt
          rw [littleEndianValue_succ bits]
          simp only [onesComplementValue, wordModulus, pow_succ]
          omega

/-- Register-level form of the source-orientation identity: the raw outgoing
carry of `value(a) + value(X b)` is exactly `value(b) < value(a)`. -/
theorem bitwiseNot_right_add_carry_iff
    (n : Nat) (a b : BitRegister n) :
    wordModulus n ≤
        littleEndianValue a + littleEndianValue (bitwiseNot b) ↔
      littleEndianValue b < littleEndianValue a := by
  rw [littleEndianValue_bitwiseNot]
  exact onesComplement_add_carry_iff n
    (littleEndianValue a) (littleEndianValue b)
    (littleEndianValue_lt_wordModulus n b)

/-- If the complemented operand is instead `a`, the same raw carry has the
Equation-(17) orientation `value(a) < value(b)`. -/
theorem bitwiseNot_left_add_carry_iff
    (n : Nat) (a b : BitRegister n) :
    wordModulus n ≤
        littleEndianValue b + littleEndianValue (bitwiseNot a) ↔
      littleEndianValue a < littleEndianValue b := by
  rw [littleEndianValue_bitwiseNot]
  exact swapped_onesComplement_add_carry_iff n
    (littleEndianValue a) (littleEndianValue b)
    (littleEndianValue_lt_wordModulus n a)

/-- Genuine two's-complement subtraction `a-b` uses an additional carry-in one;
the complement of its outgoing carry is the Equation-(17) borrow predicate. -/
theorem bitwiseNot_right_add_one_borrow_iff
    (n : Nat) (a b : BitRegister n) :
    ¬ wordModulus n ≤
        littleEndianValue a + littleEndianValue (bitwiseNot b) + 1 ↔
      littleEndianValue a < littleEndianValue b := by
  rw [littleEndianValue_bitwiseNot]
  exact twosComplement_borrow_iff n
    (littleEndianValue a) (littleEndianValue b)
    (littleEndianValue_lt_wordModulus n b)

end VandaeleComparatorBitArithmetic
end QuantumBlockEncoding
