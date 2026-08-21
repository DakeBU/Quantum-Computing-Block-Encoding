import Mathlib.Tactic

/-!
# Mixed-radix increment carry calculus

Block decompositions of reversible incrementers are naturally mixed-radix: the
last block may be shorter than the others.  This module isolates the arithmetic
once and for all.

For positive radices `B_i`, digits `d_i < B_i`, and incoming carry `c_0 = 1`,
set

`c_{i+1} = 1[d_i + c_i = B_i]`,
`d'_i = (d_i + c_i) mod B_i`.

With positional weights `W_0=1`, `W_{i+1}=W_i B_i`, the local carry equation
telescopes exactly:

`sum d'_i W_i + c_m W_m = sum d_i W_i + 1`.

The theorem is independent of quantum circuits and is shared by the Vandaele
Equation-(39) block cascade and later arithmetic State Preparation / Block
Encoding constructions.
-/

namespace QuantumBlockEncoding
namespace MixedRadixIncrement

open scoped BigOperators

/-- Positional weight of digit `i`. -/
def weight (base : Nat → Nat) : Nat → Nat
  | 0 => 1
  | i + 1 => weight base i * base i

/-- Carry entering each digit. -/
def carry (base digit : Nat → Nat) : Nat → Nat
  | 0 => 1
  | i + 1 => if digit i + carry base digit i = base i then 1 else 0

/-- Output digit after adding the incoming carry. -/
def output (base digit : Nat → Nat) (i : Nat) : Nat :=
  (digit i + carry base digit i) % base i

/-- Finite mixed-radix value of the first `n` digits. -/
def prefixValue (base digit : Nat → Nat) (n : Nat) : Nat :=
  ∑ i ∈ Finset.range n, digit i * weight base i

@[simp] theorem weight_zero (base : Nat → Nat) : weight base 0 = 1 := by
  rfl

@[simp] theorem weight_succ (base : Nat → Nat) (i : Nat) :
    weight base (i + 1) = weight base i * base i := by
  rfl

@[simp] theorem carry_zero (base digit : Nat → Nat) :
    carry base digit 0 = 1 := by
  rfl

/-- Every carry bit is 0 or 1. -/
theorem carry_le_one (base digit : Nat → Nat) :
    ∀ i, carry base digit i ≤ 1 := by
  intro i
  cases i with
  | zero => simp
  | succ i =>
      simp [carry]
      split <;> omega

/-- The local digit plus outgoing carry is exactly the input digit plus incoming
carry.  No subtraction is needed. -/
theorem local_balance
    (base digit : Nat → Nat)
    (basePositive : ∀ i, 0 < base i)
    (digitBound : ∀ i, digit i < base i)
    (i : Nat) :
    output base digit i + base i * carry base digit (i + 1) =
      digit i + carry base digit i := by
  have carryBound := carry_le_one base digit i
  have sumLe : digit i + carry base digit i ≤ base i := by
    have bound := digitBound i
    omega
  by_cases overflow : digit i + carry base digit i = base i
  · simp [output, carry, overflow, Nat.mod_self]
  · have sumLt : digit i + carry base digit i < base i := by
      omega
    simp [output, carry, overflow, Nat.mod_eq_of_lt sumLt]

@[simp] theorem prefixValue_zero (base digit : Nat → Nat) :
    prefixValue base digit 0 = 0 := by
  simp [prefixValue]

/-- Extend one finite mixed-radix value by its next digit. -/
theorem prefixValue_succ (base digit : Nat → Nat) (n : Nat) :
    prefixValue base digit (n + 1) =
      prefixValue base digit n + digit n * weight base n := by
  simp [prefixValue, Finset.sum_range_succ]

/-- Main mixed-radix successor telescoping identity. -/
theorem weighted_increment
    (base digit : Nat → Nat)
    (basePositive : ∀ i, 0 < base i)
    (digitBound : ∀ i, digit i < base i) :
    ∀ n,
      prefixValue base (output base digit) n +
          carry base digit n * weight base n =
        prefixValue base digit n + 1 := by
  intro n
  induction n with
  | zero =>
      simp [prefixValue]
  | succ n induction =>
      have local := local_balance base digit basePositive digitBound n
      rw [prefixValue_succ, prefixValue_succ, weight_succ]
      calc
        prefixValue base (output base digit) n +
              output base digit n * weight base n +
              carry base digit (n + 1) *
                (weight base n * base n) =
            prefixValue base (output base digit) n +
              (output base digit n +
                base n * carry base digit (n + 1)) *
                weight base n := by ring
        _ = prefixValue base (output base digit) n +
              (digit n + carry base digit n) * weight base n := by
            rw [local]
        _ = (prefixValue base (output base digit) n +
              carry base digit n * weight base n) +
              digit n * weight base n := by ring
        _ = (prefixValue base digit n + 1) +
              digit n * weight base n := by rw [induction]
        _ = prefixValue base digit n +
              digit n * weight base n + 1 := by ring

end MixedRadixIncrement
end QuantumBlockEncoding
