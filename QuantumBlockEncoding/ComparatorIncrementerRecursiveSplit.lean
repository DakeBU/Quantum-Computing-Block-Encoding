import QuantumBlockEncoding.ComparatorIncrementerGeneral
import Mathlib.Tactic

/-!
# Recursive register split for comparator / incrementer arithmetic

This module formalizes the arithmetic content behind the incrementer recursion
in arXiv:2603.12917 Eq. (34), before committing to one concrete gate
implementation.  An `(n+k)`-bit little-endian word is split into a low `n`-bit
block and a high `k`-bit block.  Incrementing the whole word increments the low
block modulo `2^n` and sends exactly one carry bit into the high block.

This is an exact semantic lemma.  The paper's recursive circuit family,
promise-gate implementation, dirty-ancilla discipline, and asymptotic resource
recurrences remain separate proof obligations.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerRecursiveSplit

open ComparatorIncrementerGeneral

/-- The low block after incrementing a full `(n+k)`-bit word. -/
def incrementLowValue (n k : Nat)
    (word : Fin (gridSize (n + k))) : Nat :=
  (word.val + 1) % gridSize n

/-- Carry out of the low `n`-bit block.  `Nat.succ_div` shows this is exactly
the correction added to the high quotient. -/
def incrementCarry (n k : Nat)
    (word : Fin (gridSize (n + k))) : Nat :=
  if gridSize n ∣ word.val + 1 then 1 else 0

/-- The high block after receiving the low-block carry and wrapping modulo
`2^k`. -/
def incrementHighValue (n k : Nat)
    (word : Fin (gridSize (n + k))) : Nat :=
  (word.val / gridSize n + incrementCarry n k word) % gridSize k

@[simp] theorem incrementCarry_eq_one_iff (n k : Nat)
    (word : Fin (gridSize (n + k))) :
    incrementCarry n k word = 1 ↔ gridSize n ∣ word.val + 1 := by
  simp [incrementCarry]

@[simp] theorem incrementCarry_le_one (n k : Nat)
    (word : Fin (gridSize (n + k))) :
    incrementCarry n k word ≤ 1 := by
  simp [incrementCarry]

/-- `Nat.succ_div` is exactly the carry equation required by the recursive
incrementer: the quotient changes by one iff the lower block overflows. -/
theorem incrementHighValue_eq_successor_div (n k : Nat)
    (word : Fin (gridSize (n + k))) :
    incrementHighValue n k word =
      ((word.val + 1) / gridSize n) % gridSize k := by
  unfold incrementHighValue incrementCarry
  rw [Nat.succ_div]

/-- Exact Eq. (34)-style numeric decomposition.  The successor modulo
`2^(n+k)` is the incremented low block plus `2^n` times the carry-updated high
block. -/
theorem increment_eq_low_plus_high (n k : Nat)
    (word : Fin (gridSize (n + k))) :
    (word.val + 1) % gridSize (n + k) =
      incrementLowValue n k word +
        gridSize n * incrementHighValue n k word := by
  have sizeSplit : gridSize (n + k) = gridSize n * gridSize k := by
    simp [gridSize, pow_add]
  rw [sizeSplit, Nat.mod_mul]
  unfold incrementLowValue
  rw [incrementHighValue_eq_successor_div]

/-- Reading the low part of the incremented full word agrees with the low
successor in the recursive split. -/
theorem increment_low_projection (n k : Nat)
    (word : Fin (gridSize (n + k))) :
    ((word.val + 1) % gridSize (n + k)) % gridSize n =
      incrementLowValue n k word := by
  have sizeSplit : gridSize (n + k) = gridSize n * gridSize k := by
    simp [gridSize, pow_add]
  rw [sizeSplit, Nat.mod_mul_right_mod]
  rfl

/-- Reading the high part of the incremented full word agrees with the high
block after receiving the low carry. -/
theorem increment_high_projection (n k : Nat)
    (word : Fin (gridSize (n + k))) :
    ((word.val + 1) % gridSize (n + k)) / gridSize n =
      incrementHighValue n k word := by
  have sizeSplit : gridSize (n + k) = gridSize n * gridSize k := by
    simp [gridSize, pow_add]
  rw [sizeSplit, Nat.mod_mul_right_div_self]
  exact (incrementHighValue_eq_successor_div n k word).symm

/-- The high block prior to increment is in its declared `k`-bit range.  This
keeps the later circuit induction tied to a real register rather than an
unbounded natural-number surrogate. -/
theorem old_high_lt_gridSize (n k : Nat)
    (word : Fin (gridSize (n + k))) :
    word.val / gridSize n < gridSize k := by
  apply Nat.div_lt_of_lt_mul
  simpa [gridSize, pow_add] using word.isLt

/-- The post-carry high block is also in its declared register range. -/
theorem incrementHighValue_lt_gridSize (n k : Nat)
    (word : Fin (gridSize (n + k))) :
    incrementHighValue n k word < gridSize k := by
  unfold incrementHighValue
  exact Nat.mod_lt _ (Nat.pow_pos (by decide))

/-- The post-increment low block is in its declared register range. -/
theorem incrementLowValue_lt_gridSize (n k : Nat)
    (word : Fin (gridSize (n + k))) :
    incrementLowValue n k word < gridSize n := by
  unfold incrementLowValue
  exact Nat.mod_lt _ (Nat.pow_pos (by decide))

end ComparatorIncrementerRecursiveSplit
end QuantumBlockEncoding
