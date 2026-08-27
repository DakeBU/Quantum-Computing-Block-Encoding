import QuantumBlockEncoding.VandaeleFigure5ComparatorSemantics
import Mathlib.Tactic

/-!
# Arithmetic direction of Vandaele Figure 5

The source-audit node identifies the exact Figure-5 flag with the outgoing
Takahashi carry after bitwise complementing the five-bit `b` register.  This
file performs the independent arithmetic interpretation of that carry.

The proof deliberately avoids a 2^10 input truth table.  Its two ingredients
are the ordinary unsigned identities

`value(NOT b) = 31 - value(b)`

and, for five-bit values `a,b < 32`,

`(a + (31 - b)) / 32 = 1  iff  b < a`.

Composing these facts with the already certified Figure-4 carry theorem proves
that the displayed Figure-5 source program toggles its flag by `b < a` on every
computational-basis input.  This is the universal arithmetic statement behind
the concrete source obstruction proved in the previous node.
-/

namespace QuantumBlockEncoding
namespace VandaeleFigure5ComparatorDirection

open VandaeleFigure4TakahashiSourceProgram
open VandaeleFigure4TakahashiCarryAlgebra
open VandaeleFigure5ComparatorSemantics

/-- Computational-basis bit for strict natural-number comparison. -/
def strictLtBit (left right : Nat) : Fin 2 :=
  if left < right then 1 else 0

@[simp] theorem strictLtBit_value (left right : Nat) :
    (strictLtBit left right).val = if left < right then 1 else 0 := by
  by_cases h : left < right <;> simp [strictLtBit, h]

/-- Numeric value of a complemented computational-basis bit. -/
@[simp] theorem flipBit_value (bit : Fin 2) :
    (flipBit bit).val = 1 - bit.val := by
  fin_cases bit <;> rfl

/-- Every unsigned five-bit value lies below 32. -/
theorem fiveValue_lt_32 (x0 x1 x2 x3 x4 : Fin 2) :
    fiveValue x0 x1 x2 x3 x4 < 32 := by
  unfold fiveValue
  have h0 := x0.isLt
  have h1 := x1.isLt
  have h2 := x2.isLt
  have h3 := x3.isLt
  have h4 := x4.isLt
  omega

/-- Bitwise complement on five little-endian bits is arithmetic complement
inside the interval `[0,31]`. -/
theorem fiveValue_flipBits
    (x0 x1 x2 x3 x4 : Fin 2) :
    fiveValue (flipBit x0) (flipBit x1) (flipBit x2)
        (flipBit x3) (flipBit x4) =
      31 - fiveValue x0 x1 x2 x3 x4 := by
  unfold fiveValue
  simp only [flipBit_value]
  have h0 := x0.isLt
  have h1 := x1.isLt
  have h2 := x2.isLt
  have h3 := x3.isLt
  have h4 := x4.isLt
  omega

/-- For two five-bit naturals, the outgoing carry of `a + NOT b` is exactly
`[b < a]`.  This is the arithmetic reason for the operand orientation exposed
by the source audit. -/
theorem complementedNat_carry_eq_ltBit
    (a b : Nat) (ha : a < 32) (hb : b < 32) :
    (a + (31 - b)) / 32 = if b < a then 1 else 0 := by
  by_cases h : b < a
  · simp [h]
    omega
  · simp [h]
    omega

/-- The Figure-4 five-bit carry recurrence, when fed complemented `b`, is the
strict comparison bit `b < a`. -/
theorem complementedB_c5_eq_strictLtBit
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 : Fin 2) :
    c5 a0 (flipBit b0)
        a1 (flipBit b1)
        a2 (flipBit b2)
        a3 (flipBit b3)
        a4 (flipBit b4) =
      strictLtBit
        (fiveValue b0 b1 b2 b3 b4)
        (fiveValue a0 a1 a2 a3 a4) := by
  apply Fin.ext
  have carry :
      (c5 a0 (flipBit b0)
          a1 (flipBit b1)
          a2 (flipBit b2)
          a3 (flipBit b3)
          a4 (flipBit b4)).val =
        (fiveValue a0 a1 a2 a3 a4 +
          fiveValue (flipBit b0) (flipBit b1) (flipBit b2)
            (flipBit b3) (flipBit b4)) / 32 := by
    exact (fiveBit_arithmetic_certificate
      a0 (flipBit b0)
      a1 (flipBit b1)
      a2 (flipBit b2)
      a3 (flipBit b3)
      a4 (flipBit b4)).2
  rw [fiveValue_flipBits] at carry
  rw [carry, strictLtBit_value]
  exact complementedNat_carry_eq_ltBit
    (fiveValue a0 a1 a2 a3 a4)
    (fiveValue b0 b1 b2 b3 b4)
    (fiveValue_lt_32 a0 a1 a2 a3 a4)
    (fiveValue_lt_32 b0 b1 b2 b3 b4)

/-- Universal flag theorem on the eleven explicitly displayed Figure-5 bits.
The printed diagram says `a < b`; the certified source program implements
`b < a`. -/
theorem figure5Program_toggles_b_lt_a_bits
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) :
    zValue
        (evalReversibleProgram figure5Program
          (sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z)) =
      (xorBit z
        (strictLtBit
          (fiveValue b0 b1 b2 b3 b4)
          (fiveValue a0 a1 a2 a3 a4))).val := by
  rw [figure5_flag_is_complementedB_carry]
  rw [complementedB_c5_eq_strictLtBit]
  rw [xorBit_comm]

/-- Reader-facing arbitrary-state form: the displayed Figure-5 program toggles
`z` exactly when the numeric `b` register is strictly smaller than `a`. -/
theorem figure5Program_toggles_b_lt_a (state : SourceBasis) :
    zValue (evalReversibleProgram figure5Program state) =
      (zValue state + (strictLtBit (bValue state) (aValue state)).val) % 2 := by
  simpa [aValue, bValue, zValue, sourceState, fiveValue, xorBit_value] using
    figure5Program_toggles_b_lt_a_bits
      (state 0) (state 1) (state 2) (state 3) (state 4) (state 5)
      (state 6) (state 7) (state 8) (state 9) (state 10)

end VandaeleFigure5ComparatorDirection
end QuantumBlockEncoding
