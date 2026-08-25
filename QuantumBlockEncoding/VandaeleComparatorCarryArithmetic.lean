import QuantumBlockEncoding.VandaeleComparatorContract
import Mathlib.Tactic

/-!
# Carry arithmetic behind the Vandaele comparator source audit

Figure 4 of Vandaele (arXiv:2603.12917v1) is an in-place adder that preserves
`a`, writes `a + b` into the `b` register, and exposes the outgoing carry on the
flag wire.  Figure 5 is described as obtaining subtraction by conjugating the
register holding `b` with X gates.

Before formalizing the entire Figure-5 wiring, this file isolates the arithmetic
fact that is independent of every circuit decomposition.  For `n`-bit unsigned
values, bitwise X on `b` replaces its value by

`2^n - 1 - b`.

Consequently the outgoing carry of adding `a` to that ones-complement value is
present exactly when `b < a`.  By contrast, genuine two's-complement subtraction
adds the extra `+1`; its carry is present exactly when `b ≤ a`, so the borrow
predicate (the complement of carry) is exactly `a < b`.

These lemmas are deliberately pure arithmetic.  A downstream Figure-5 circuit
refinement only has to prove which of these carry expressions its displayed
slices realize.
-/

namespace QuantumBlockEncoding
namespace VandaeleComparatorCarryArithmetic

/-- Modulus of an `n`-bit unsigned register. -/
def wordModulus (n : Nat) : Nat := 2 ^ n

/-- Natural-number value obtained by applying X to every bit of an `n`-bit word,
provided the original value lies in the word range. -/
def onesComplementValue (n b : Nat) : Nat :=
  wordModulus n - 1 - b

/-- Pure modulus form of the ones-complement carry identity.  Stating the lemma
with an abstract `m` keeps the proof in Presburger arithmetic; the word modulus
`2^n` can then be substituted without asking `omega` to reason about powers. -/
theorem onesComplement_add_carry_iff_modulus
    (m a b : Nat)
    (hb : b < m) :
    m ≤ a + (m - 1 - b) ↔ b < a := by
  omega

/-- The carry produced by `a + (~b)` is exactly the strict predicate `b < a`.
This is the arithmetic orientation visible in the literal Figure-5 construction
when the adder's target register is `b`. -/
theorem onesComplement_add_carry_iff
    (n a b : Nat)
    (hb : b < wordModulus n) :
    wordModulus n ≤ a + onesComplementValue n b ↔ b < a := by
  simpa [onesComplementValue] using
    (onesComplement_add_carry_iff_modulus (wordModulus n) a b hb)

/-- Pure modulus form of the two's-complement carry identity. -/
theorem twosComplement_add_carry_iff_modulus
    (m a b : Nat)
    (hb : b < m) :
    m ≤ a + (m - 1 - b) + 1 ↔ b ≤ a := by
  omega

/-- Adding the missing two's-complement `+1` changes the carry predicate from
`b < a` to `b ≤ a`. -/
theorem twosComplement_add_carry_iff
    (n a b : Nat)
    (hb : b < wordModulus n) :
    wordModulus n ≤ a + onesComplementValue n b + 1 ↔ b ≤ a := by
  simpa [onesComplementValue] using
    (twosComplement_add_carry_iff_modulus (wordModulus n) a b hb)

/-- Therefore the borrow bit of genuine `a - b` is exactly `a < b`. -/
theorem twosComplement_borrow_iff
    (n a b : Nat)
    (hb : b < wordModulus n) :
    ¬ wordModulus n ≤ a + onesComplementValue n b + 1 ↔ a < b := by
  rw [twosComplement_add_carry_iff n a b hb]
  omega

/-- Swapping the addend roles also reverses the strict ones-complement carry
orientation.  This is the alternate convention bridge that would make the raw
carry itself represent `a < b`. -/
theorem swapped_onesComplement_add_carry_iff
    (n a b : Nat)
    (ha : a < wordModulus n) :
    wordModulus n ≤ b + onesComplementValue n a ↔ a < b := by
  exact onesComplement_add_carry_iff n b a ha

end VandaeleComparatorCarryArithmetic
end QuantumBlockEncoding
