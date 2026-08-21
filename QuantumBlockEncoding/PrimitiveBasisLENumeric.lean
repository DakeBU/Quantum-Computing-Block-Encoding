import QuantumBlockEncoding.ComparatorIncrementerGeneral
import QuantumBlockEncoding.PrimitiveBasisLE
import Mathlib.Tactic

/-!
# Arbitrary-width little-endian numeric expansion

`primitiveBasisLEEquiv` fixes ASPBE's register order recursively, but many
arithmetic proofs need the closed form

`value(bits) = sum_i bits[i] * 2^i`.

This module proves that identity once for every width.  It is a shared numeric
bridge for Gidney carry proofs, comparator arithmetic, and later SP/BE address
logic.
-/

namespace QuantumBlockEncoding
namespace PrimitiveBasisLENumeric

open scoped BigOperators
open ComparatorIncrementerGeneral

/-- Arbitrary-width binary-value formula for the canonical little-endian basis
encoding. -/
theorem primitiveBasisLEEquiv_value_eq_sum
    (n : Nat) (bits : PrimitiveBasis n) :
    (primitiveBasisLEEquiv n bits).val =
      ∑ wire : Fin n, (bits wire).val * 2 ^ wire.val := by
  induction n with
  | zero =>
      simp [primitiveBasisLEEquiv_zero_apply]
  | succ n induction =>
      rw [primitiveBasisLEEquiv_succ_value]
      rw [Fin.sum_univ_succ]
      have tail := induction (fun wire : Fin n => bits wire.succ)
      rw [tail]
      simp only [Fin.val_zero, pow_zero, Nat.mul_one, Fin.val_succ]
      congr 1
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro wire _
      rw [pow_succ]
      ring

/-- Same formula through the public `basisNat` name used by the arbitrary-width
incrementer/comparator contracts. -/
theorem basisNat_eq_sum
    (n : Nat) (bits : PrimitiveBasis n) :
    basisNat n bits =
      ∑ wire : Fin n, (bits wire).val * 2 ^ wire.val := by
  exact primitiveBasisLEEquiv_value_eq_sum n bits

/-- The all-zero basis has numeric value zero at every width. -/
@[simp] theorem basisNat_zero
    (n : Nat) :
    basisNat n (fun _ => 0) = 0 := by
  rw [basisNat_eq_sum]
  simp

/-- Two basis states are equal whenever their numeric little-endian values are
equal. -/
theorem eq_of_basisNat_eq
    {n : Nat} {left right : PrimitiveBasis n}
    (equal : basisNat n left = basisNat n right) : left = right := by
  apply (primitiveBasisLEEquiv n).injective
  apply Fin.ext
  exact equal

end PrimitiveBasisLENumeric
end QuantumBlockEncoding