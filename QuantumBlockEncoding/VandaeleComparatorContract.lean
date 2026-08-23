import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Fin.Basic
import Mathlib.Tactic

/-!
# Vandaele quantum--quantum comparator contract

This file formalizes the functional contract of Equation (17) in
Vandaele, *Asymptotically Optimal Quantum Circuits for Comparators and
Incrementers* (2026), independently of any particular circuit implementation.

We use the explicit little-endian convention `bit 0 = least significant bit`:

`value(a) = sum_i a_i * 2^i`.

The comparator preserves both input registers and toggles its flag exactly when
`value(a) < value(b)`.  Keeping this contract in a pure-Mathlib leaf separates
arithmetic correctness from the later Figure-5 circuit and resource proofs.
-/

namespace QuantumBlockEncoding
namespace VandaeleComparatorContract

open scoped BigOperators

/-- An `n`-bit computational-basis register. -/
abbrev BitRegister (n : Nat) := Fin n → Fin 2

/-- Natural-number value of a little-endian bit register. -/
def littleEndianValue {n : Nat} (bits : BitRegister n) : Nat :=
  ∑ i : Fin n, (bits i).val * 2 ^ i.val

/-- Structured basis state for the quantum--quantum comparator of Equation (17). -/
structure ComparatorState (n : Nat) where
  left : BitRegister n
  right : BitRegister n
  flag : Fin 2

/-- Toggle a computational-basis flag bit. -/
def flipFlag (bit : Fin 2) : Fin 2 :=
  if bit = 0 then 1 else 0

@[simp] theorem flipFlag_zero : flipFlag (0 : Fin 2) = 1 := by
  rfl

@[simp] theorem flipFlag_one : flipFlag (1 : Fin 2) = 0 := by
  rfl

@[simp] theorem flipFlag_flipFlag (bit : Fin 2) :
    flipFlag (flipFlag bit) = bit := by
  fin_cases bit <;> rfl

/-- Equation (17):

`|a>|b>|z> -> |a>|b>|z xor (a < b)>`.
-/
def equationSeventeenAction {n : Nat}
    (state : ComparatorState n) : ComparatorState n :=
  { left := state.left
    right := state.right
    flag := if littleEndianValue state.left < littleEndianValue state.right then
      flipFlag state.flag
    else
      state.flag }

@[simp] theorem equationSeventeenAction_left {n : Nat}
    (state : ComparatorState n) :
    (equationSeventeenAction state).left = state.left := by
  rfl

@[simp] theorem equationSeventeenAction_right {n : Nat}
    (state : ComparatorState n) :
    (equationSeventeenAction state).right = state.right := by
  rfl

@[simp] theorem equationSeventeenAction_flag {n : Nat}
    (state : ComparatorState n) :
    (equationSeventeenAction state).flag =
      if littleEndianValue state.left < littleEndianValue state.right then
        flipFlag state.flag
      else
        state.flag := by
  rfl

/-- The comparator predicate depends only on the two preserved input registers. -/
theorem comparison_preserved {n : Nat} (state : ComparatorState n) :
    (littleEndianValue (equationSeventeenAction state).left <
      littleEndianValue (equationSeventeenAction state).right) ↔
    (littleEndianValue state.left < littleEndianValue state.right) := by
  rfl

/-- Equation (17) is reversible: applying the same comparator twice restores
its input basis state. -/
theorem equationSeventeenAction_involutive {n : Nat} :
    Function.Involutive (@equationSeventeenAction n) := by
  intro state
  rcases state with ⟨left, right, flag⟩
  by_cases less : littleEndianValue left < littleEndianValue right
  · simp [equationSeventeenAction, less]
  · simp [equationSeventeenAction, less]

/-- Functional specification for any proposed implementation of Equation (17). -/
def ComparatorSpec {n : Nat}
    (implementation : ComparatorState n → ComparatorState n) : Prop :=
  ∀ state, implementation state = equationSeventeenAction state

/-- A convenient pointwise form of the comparator flag condition. -/
theorem comparatorSpec_flag {n : Nat}
    {implementation : ComparatorState n → ComparatorState n}
    (spec : ComparatorSpec implementation)
    (state : ComparatorState n) :
    (implementation state).flag =
      if littleEndianValue state.left < littleEndianValue state.right then
        flipFlag state.flag
      else
        state.flag := by
  rw [spec state]
  rfl

/-- A correct comparator preserves its left input register. -/
theorem comparatorSpec_left {n : Nat}
    {implementation : ComparatorState n → ComparatorState n}
    (spec : ComparatorSpec implementation)
    (state : ComparatorState n) :
    (implementation state).left = state.left := by
  rw [spec state]

/-- A correct comparator preserves its right input register. -/
theorem comparatorSpec_right {n : Nat}
    {implementation : ComparatorState n → ComparatorState n}
    (spec : ComparatorSpec implementation)
    (state : ComparatorState n) :
    (implementation state).right = state.right := by
  rw [spec state]

end VandaeleComparatorContract
end QuantumBlockEncoding
