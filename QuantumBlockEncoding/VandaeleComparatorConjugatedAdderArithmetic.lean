import QuantumBlockEncoding.VandaeleComparatorBitArithmetic
import Mathlib.Tactic

/-!
# Arithmetic semantics of the X--adder--X comparator construction

Vandaele Figure 5 is obtained from the in-place adder of Figure 4 by placing X
layers on the register holding `b`.  The already admitted arithmetic frontier
proves that the raw outgoing carry of

`a + (~b)`

is present exactly when `b < a`.  This file strengthens that fact from a single
carry predicate to the complete unsigned-word arithmetic of the conjugated
construction.

For a modulus `m` and inputs `a,b < m`, write the low word of `a + (m-1-b)` as

* `a-b-1` when `b<a` (there is an outgoing carry), and
* `m-1-(b-a)` when `a<=b` (there is no outgoing carry).

Applying the final X layer complements this low word.  The resulting target
value is therefore

* `m-(a-b)` when `b<a`, and
* `b-a` when `a<=b`.

That is exactly wrapped subtraction `b-a (mod m)`, not wrapped subtraction
`a-b`.  The theorem is stated first for an abstract modulus so that its proof is
pure Presburger arithmetic, and then specialized to the actual `2^n` word
modulus and `BitRegister n` values used by Equation (17).

This module deliberately remains circuit-independent.  A later Figure-5
refinement only has to prove that its middle adder slice exposes the low-word and
carry quantities certified here.
-/

namespace QuantumBlockEncoding
namespace VandaeleComparatorConjugatedAdderArithmetic

open VandaeleComparatorContract
open VandaeleComparatorCarryArithmetic
open VandaeleComparatorBitArithmetic

/-- Low `m`-word produced by adding `a` to the ones-complement of `b`.
The definition is the quotient/remainder decomposition specialized to the fact
that `a,b<m`, hence the sum is strictly below `2m`. -/
def onesComplementLowValue (m a b : Nat) : Nat :=
  if b < a then
    a - b - 1
  else
    m - 1 - (b - a)

/-- Exact carry-plus-low-word decomposition of `a + (~b)` for an abstract word
modulus.  The high carry is one exactly in the branch `b<a`. -/
theorem onesComplement_sum_decomposition
    (m a b : Nat)
    (ha : a < m) (hb : b < m) :
    a + (m - 1 - b) =
      (if b < a then m else 0) + onesComplementLowValue m a b := by
  by_cases h : b < a
  · simp [onesComplementLowValue, h]
    omega
  · have hab : a ≤ b := Nat.le_of_not_gt h
    simp [onesComplementLowValue, h]
    omega

/-- The low word in the preceding decomposition is indeed a valid `m`-word. -/
theorem onesComplementLowValue_lt
    (m a b : Nat)
    (ha : a < m) (hb : b < m) :
    onesComplementLowValue m a b < m := by
  by_cases h : b < a
  · simp [onesComplementLowValue, h]
    omega
  · have hab : a ≤ b := Nat.le_of_not_gt h
    simp [onesComplementLowValue, h]
    omega

/-- Value after the final X layer of the X--adder--X construction. -/
def xAdderXTargetValue (m a b : Nat) : Nat :=
  m - 1 - onesComplementLowValue m a b

/-- Wrapped unsigned value of `b-a` modulo an `m`-word, written without `%` so
the source orientation is visible directly. -/
def wrappedReverseDifference (m a b : Nat) : Nat :=
  if b < a then
    m - (a - b)
  else
    b - a

/-- Wrapped unsigned value of `a-b` modulo an `m`-word. -/
def wrappedForwardDifference (m a b : Nat) : Nat :=
  if a < b then
    m - (b - a)
  else
    a - b

/-- The two names differ only by swapping the operands. -/
@[simp] theorem wrappedReverseDifference_eq_swappedForward
    (m a b : Nat) :
    wrappedReverseDifference m a b = wrappedForwardDifference m b a := by
  rfl

/-- Complete low-word orientation theorem: X on `b`, then the target-`b` adder,
then X on `b` computes wrapped `b-a` on the target register. -/
theorem xAdderXTargetValue_eq_wrappedReverseDifference
    (m a b : Nat)
    (ha : a < m) (hb : b < m) :
    xAdderXTargetValue m a b = wrappedReverseDifference m a b := by
  by_cases h : b < a
  · simp [xAdderXTargetValue, onesComplementLowValue,
      wrappedReverseDifference, h]
    omega
  · have hab : a ≤ b := Nat.le_of_not_gt h
    simp [xAdderXTargetValue, onesComplementLowValue,
      wrappedReverseDifference, h]
    omega

/-- Same theorem phrased explicitly as wrapped subtraction with swapped
operands. -/
theorem xAdderXTargetValue_eq_swapped_wrapped_subtraction
    (m a b : Nat)
    (ha : a < m) (hb : b < m) :
    xAdderXTargetValue m a b = wrappedForwardDifference m b a := by
  rw [← wrappedReverseDifference_eq_swappedForward]
  exact xAdderXTargetValue_eq_wrappedReverseDifference m a b ha hb

/-- Word-modulus specialization of the low value. -/
def wordOnesComplementLowValue (n a b : Nat) : Nat :=
  onesComplementLowValue (wordModulus n) a b

/-- Word-modulus specialization of the post-X target value. -/
def wordXAdderXTargetValue (n a b : Nat) : Nat :=
  onesComplementValue n (wordOnesComplementLowValue n a b)

/-- The post-X target value is exactly wrapped `b-a` for `n`-bit words. -/
theorem wordXAdderXTargetValue_eq_wrappedReverseDifference
    (n a b : Nat)
    (ha : a < wordModulus n) (hb : b < wordModulus n) :
    wordXAdderXTargetValue n a b =
      wrappedReverseDifference (wordModulus n) a b := by
  change
    wordModulus n - 1 -
        onesComplementLowValue (wordModulus n) a b =
      wrappedReverseDifference (wordModulus n) a b
  exact xAdderXTargetValue_eq_wrappedReverseDifference
    (wordModulus n) a b ha hb

/-- Joint arithmetic certificate for the conjugated adder: its outgoing carry
has the strict `b<a` orientation and its final target word is wrapped `b-a`. -/
theorem wordXAdderX_certificate
    (n a b : Nat)
    (ha : a < wordModulus n) (hb : b < wordModulus n) :
    (wordModulus n ≤ a + onesComplementValue n b ↔ b < a) ∧
      wordXAdderXTargetValue n a b =
        wrappedForwardDifference (wordModulus n) b a := by
  constructor
  · exact onesComplement_add_carry_iff n a b hb
  · rw [← wrappedReverseDifference_eq_swappedForward]
    exact wordXAdderXTargetValue_eq_wrappedReverseDifference n a b ha hb

/-- Register-level low word of the conjugated addition. -/
def bitRegisterXAdderXLowValue
    (n : Nat) (a b : BitRegister n) : Nat :=
  wordOnesComplementLowValue n (littleEndianValue a) (littleEndianValue b)

/-- Register-level value after the final X layer. -/
def bitRegisterXAdderXTargetValue
    (n : Nat) (a b : BitRegister n) : Nat :=
  wordXAdderXTargetValue n (littleEndianValue a) (littleEndianValue b)

/-- Exact decomposition of the arithmetic sum seen by the target-`b` adder after
the first X layer. -/
theorem bitRegister_onesComplement_sum_decomposition
    (n : Nat) (a b : BitRegister n) :
    littleEndianValue a + littleEndianValue (bitwiseNot b) =
      (if littleEndianValue b < littleEndianValue a then wordModulus n else 0) +
        bitRegisterXAdderXLowValue n a b := by
  rw [littleEndianValue_bitwiseNot]
  unfold bitRegisterXAdderXLowValue wordOnesComplementLowValue
  unfold onesComplementValue
  exact onesComplement_sum_decomposition
    (wordModulus n) (littleEndianValue a) (littleEndianValue b)
    (littleEndianValue_lt_wordModulus n a)
    (littleEndianValue_lt_wordModulus n b)

/-- The low word entering the final X layer is a valid `n`-bit unsigned value. -/
theorem bitRegisterXAdderXLowValue_lt
    (n : Nat) (a b : BitRegister n) :
    bitRegisterXAdderXLowValue n a b < wordModulus n := by
  unfold bitRegisterXAdderXLowValue wordOnesComplementLowValue
  exact onesComplementLowValue_lt
    (wordModulus n) (littleEndianValue a) (littleEndianValue b)
    (littleEndianValue_lt_wordModulus n a)
    (littleEndianValue_lt_wordModulus n b)

/-- Register-level target orientation: the complete X--adder--X arithmetic on
the `b` target register computes wrapped `b-a`. -/
theorem bitRegisterXAdderXTargetValue_eq_swapped_subtraction
    (n : Nat) (a b : BitRegister n) :
    bitRegisterXAdderXTargetValue n a b =
      wrappedForwardDifference (wordModulus n)
        (littleEndianValue b) (littleEndianValue a) := by
  unfold bitRegisterXAdderXTargetValue
  exact xAdderXTargetValue_eq_swapped_wrapped_subtraction
    (wordModulus n) (littleEndianValue a) (littleEndianValue b)
    (littleEndianValue_lt_wordModulus n a)
    (littleEndianValue_lt_wordModulus n b)

/-- Final register-level arithmetic boundary for Figure 5.  The raw carry and
final target register have the same reversed operand orientation: carry iff
`value(b)<value(a)`, target value `b-a mod 2^n`. -/
theorem bitRegisterXAdderX_certificate
    (n : Nat) (a b : BitRegister n) :
    (wordModulus n ≤
        littleEndianValue a + littleEndianValue (bitwiseNot b) ↔
      littleEndianValue b < littleEndianValue a) ∧
    bitRegisterXAdderXTargetValue n a b =
      wrappedForwardDifference (wordModulus n)
        (littleEndianValue b) (littleEndianValue a) := by
  constructor
  · exact bitwiseNot_right_add_carry_iff n a b
  · exact bitRegisterXAdderXTargetValue_eq_swapped_subtraction n a b

end VandaeleComparatorConjugatedAdderArithmetic
end QuantumBlockEncoding
