import QuantumBlockEncoding.ComparatorIncrementerGeneral
import QuantumBlockEncoding.PrimitiveBasisLENumeric
import Mathlib.Tactic

/-!
# Subtraction semantics behind the Vandaele quantum comparator

Section 4.1 obtains the quantum-quantum comparison bit from the high bit of an
(n+1)-bit modular subtraction.  This module isolates that arithmetic statement
before any Figure-5/V2 gate decomposition is considered.

For a,b in `[0,2^n)`, the canonical `(n+1)`-bit representative of `a-b` is

* `a-b` when `a>=b`;
* `2^(n+1)-(b-a)` when `a<b`.

Its high bit (threshold `2^n`) is one exactly in the second case.  We also prove
that the repository's `qqLeftValue` and `qqRightValue` are exactly the
little-endian values of their extracted basis registers.
-/

namespace QuantumBlockEncoding
namespace ComparatorSubtractionSemantics

open scoped BigOperators
open ComparatorIncrementerGeneral
open PrimitiveBasisLENumeric

/-- Extract the left n-bit comparator register. -/
def qqLeftBasis (n : Nat)
    (state : PrimitiveBasis (2 * n + 1)) : PrimitiveBasis n :=
  fun wire => state (qqLeftWire n wire)

/-- Extract the right n-bit comparator register. -/
def qqRightBasis (n : Nat)
    (state : PrimitiveBasis (2 * n + 1)) : PrimitiveBasis n :=
  fun wire => state (qqRightWire n wire)

/-- Repository sums agree with the canonical little-endian basis values. -/
theorem qqLeftValue_eq_basisNat
    (n : Nat) (state : PrimitiveBasis (2 * n + 1)) :
    qqLeftValue n state = basisNat n (qqLeftBasis n state) := by
  unfold qqLeftValue basisNat qqLeftBasis
  rw [primitiveBasisLEEquiv_value_eq_sum]
  apply Finset.sum_congr rfl
  intro wire _
  rfl

theorem qqRightValue_eq_basisNat
    (n : Nat) (state : PrimitiveBasis (2 * n + 1)) :
    qqRightValue n state = basisNat n (qqRightBasis n state) := by
  unfold qqRightValue basisNat qqRightBasis
  rw [primitiveBasisLEEquiv_value_eq_sum]
  apply Finset.sum_congr rfl
  intro wire _
  rfl

/-- Both extracted register values lie below `2^n`. -/
theorem qqLeftValue_lt_gridSize
    (n : Nat) (state : PrimitiveBasis (2 * n + 1)) :
    qqLeftValue n state < gridSize n := by
  rw [qqLeftValue_eq_basisNat]
  unfold basisNat
  exact (primitiveBasisLEEquiv n (qqLeftBasis n state)).isLt

theorem qqRightValue_lt_gridSize
    (n : Nat) (state : PrimitiveBasis (2 * n + 1)) :
    qqRightValue n state < gridSize n := by
  rw [qqRightValue_eq_basisNat]
  unfold basisNat
  exact (primitiveBasisLEEquiv n (qqRightBasis n state)).isLt

/-- Canonical `(n+1)`-bit modular representative of `a-b`. -/
def signedSubValue
    (n : Nat) (a b : Fin (gridSize n)) : Nat :=
  if a.val < b.val then
    gridSize (n + 1) - (b.val - a.val)
  else
    a.val - b.val

/-- Doubling identity for the high-bit threshold. -/
theorem gridSize_succ (n : Nat) :
    gridSize (n + 1) = 2 * gridSize n := by
  unfold gridSize
  rw [pow_succ]
  ring

/-- The modular representative always lies inside the `(n+1)`-bit word. -/
theorem signedSubValue_lt
    (n : Nat) (a b : Fin (gridSize n)) :
    signedSubValue n a b < gridSize (n + 1) := by
  have aBound := a.isLt
  have bBound := b.isLt
  have sizePositive : 0 < gridSize n := Nat.pow_pos (by decide)
  rw [gridSize_succ]
  unfold signedSubValue
  by_cases less : a.val < b.val
  · rw [if_pos less]
    omega
  · rw [if_neg less]
    omega

/-- High bit of the `(n+1)`-bit subtraction result is one iff `a<b`. -/
theorem highBit_iff_lt
    (n : Nat) (a b : Fin (gridSize n)) :
    gridSize n ≤ signedSubValue n a b ↔ a.val < b.val := by
  have aBound := a.isLt
  have bBound := b.isLt
  have sizePositive : 0 < gridSize n := Nat.pow_pos (by decide)
  unfold signedSubValue
  by_cases less : a.val < b.val
  · rw [if_pos less]
    rw [gridSize_succ]
    constructor
    · intro _
      exact less
    · intro _
      omega
  · rw [if_neg less]
    constructor
    · intro high
      omega
    · intro impossible
      exact (less impossible).elim

/-- State-level form consumed by the Figure-5 comparator refinement. -/
theorem state_highBit_iff_comparison
    (n : Nat) (state : PrimitiveBasis (2 * n + 1)) :
    gridSize n ≤
        signedSubValue n
          ⟨qqLeftValue n state, qqLeftValue_lt_gridSize n state⟩
          ⟨qqRightValue n state, qqRightValue_lt_gridSize n state⟩ ↔
      qqLeftValue n state < qqRightValue n state := by
  exact highBit_iff_lt n _ _

end ComparatorSubtractionSemantics
end QuantumBlockEncoding
