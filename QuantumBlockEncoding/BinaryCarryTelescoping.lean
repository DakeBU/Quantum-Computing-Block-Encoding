import QuantumBlockEncoding.PrimitiveSemantics
import Mathlib.Tactic

/-!
# Binary carry telescoping

Ripple-style increment proofs repeatedly use the same elementary algebra.  Let
`b_i` be input bits, `c_i` the carry entering bit i, and `y_i` the output bit.
If

`y_i = b_i + c_i - 2 c_{i+1}`,

then the weighted binary sum telescopes:

`sum_{i<n} y_i 2^i = sum_{i<n} b_i 2^i + c_0 - c_n 2^n`.

For an increment, `c_0=1` and `c_{i+1}=c_i*b_i`; the last term is exactly the
wraparound overflow.  This lemma is circuit-independent and is shared by the
Gidney source proof and later arithmetic components.
-/

namespace QuantumBlockEncoding
namespace BinaryCarryTelescoping

open scoped BigOperators

/-- Pure integer telescoping identity for any sequences satisfying the local
binary-carry update equation. -/
theorem weighted_sum_telescopes
    (input carry output : Nat → ℤ)
    (n : Nat)
    (local : ∀ i, i < n →
      output i = input i + carry i - 2 * carry (i + 1)) :
    (∑ i ∈ Finset.range n, output i * (2 : ℤ) ^ i) =
      (∑ i ∈ Finset.range n, input i * (2 : ℤ) ^ i) +
        carry 0 - carry n * (2 : ℤ) ^ n := by
  induction n with
  | zero =>
      simp
  | succ n induction =>
      rw [Finset.sum_range_succ, Finset.sum_range_succ]
      have previous : ∀ i, i < n →
          output i = input i + carry i - 2 * carry (i + 1) := by
        intro i bound
        exact local i (by omega)
      rw [induction previous]
      rw [local n (by omega)]
      rw [pow_succ]
      ring

/-- Toggle one computational-basis bit exactly when a carry bit is one. -/
def applyCarry (carry bit : Fin 2) : Fin 2 :=
  if carry = 1 then flipBit bit else bit

/-- Local bit arithmetic in integer form. -/
theorem applyCarry_value
    (carry bit : Fin 2) :
    ((applyCarry carry bit).val : ℤ) =
      (bit.val : ℤ) + (carry.val : ℤ) -
        2 * ((carry.val : ℤ) * (bit.val : ℤ)) := by
  fin_cases carry <;> fin_cases bit <;>
    norm_num [applyCarry, flipBit]

/-- If the outgoing carry is the conjunction of incoming carry and input bit,
the local update has the exact telescoping form. -/
theorem applyCarry_value_of_next
    (carry bit nextCarry : Fin 2)
    (next : nextCarry.val = carry.val * bit.val) :
    ((applyCarry carry bit).val : ℤ) =
      (bit.val : ℤ) + (carry.val : ℤ) -
        2 * (nextCarry.val : ℤ) := by
  rw [applyCarry_value]
  norm_num at next ⊢
  omega

/-- Boolean conjunction as a `Fin 2` bit. -/
def andBit (left right : Fin 2) : Fin 2 :=
  if left = 1 ∧ right = 1 then 1 else 0

@[simp] theorem andBit_value
    (left right : Fin 2) :
    (andBit left right).val = left.val * right.val := by
  fin_cases left <;> fin_cases right <;>
    rfl

/-- Carry-chain recurrence used by binary increment. -/
def carryChain (input : Nat → Fin 2) : Nat → Fin 2
  | 0 => 1
  | i + 1 => andBit (carryChain input i) (input i)

@[simp] theorem carryChain_zero (input : Nat → Fin 2) :
    carryChain input 0 = 1 := by
  rfl

@[simp] theorem carryChain_succ_value
    (input : Nat → Fin 2) (i : Nat) :
    (carryChain input (i + 1)).val =
      (carryChain input i).val * (input i).val := by
  simp [carryChain]

/-- Infinite output-bit stream of an increment carry chain. -/
def incrementOutput (input : Nat → Fin 2) (i : Nat) : Fin 2 :=
  applyCarry (carryChain input i) (input i)

/-- Local carry equation for the canonical increment stream. -/
theorem incrementOutput_local
    (input : Nat → Fin 2) (i : Nat) :
    ((incrementOutput input i).val : ℤ) =
      (input i).val + (carryChain input i).val -
        2 * (carryChain input (i + 1)).val := by
  exact applyCarry_value_of_next
    (carryChain input i) (input i) (carryChain input (i + 1))
    (carryChain_succ_value input i)

/-- Weighted finite-prefix identity for canonical increment carries. -/
theorem increment_weighted_sum
    (input : Nat → Fin 2) (n : Nat) :
    (∑ i ∈ Finset.range n,
        ((incrementOutput input i).val : ℤ) * (2 : ℤ) ^ i) =
      (∑ i ∈ Finset.range n,
        ((input i).val : ℤ) * (2 : ℤ) ^ i) + 1 -
          ((carryChain input n).val : ℤ) * (2 : ℤ) ^ n := by
  apply weighted_sum_telescopes
    (fun i => (input i).val)
    (fun i => (carryChain input i).val)
    (fun i => (incrementOutput input i).val)
  intro i _
  exact incrementOutput_local input i

end BinaryCarryTelescoping
end QuantumBlockEncoding