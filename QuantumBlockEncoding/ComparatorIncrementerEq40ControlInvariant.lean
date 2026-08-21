import QuantumBlockEncoding.ComparatorIncrementerAllX
import QuantumBlockEncoding.ComparatorIncrementerGeneral
import Mathlib.Tactic

/-!
# Vandaele Eq. (40): the all-ones control invariant

The Figure 10 / Lemma 8 construction reuses an all-ones control condition across
an increment and an all-X layer.  The arithmetic reason is independent of the
particular gate implementation:

* an n-bit modular increment sends the all-ones word `2^n-1` to zero;
* all-X sends zero back to the all-ones word.

Thus the second multi-controlled gate can test the same all-ones condition after
the intervening increment/all-X transformation.  This file proves that invariant
for *any* basis permutation satisfying ASPBE's parameterized `IncrementerSpec`.
The later Figure 10 refinement therefore only needs to prove that its concrete
low-resource circuit satisfies that spec.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerEq40ControlInvariant

open ComparatorIncrementerAllX
open ComparatorIncrementerGeneral

/-- All-zero n-wire computational basis state. -/
def zeroBasisState (n : Nat) : PrimitiveBasis n :=
  fun _ => 0

/-- All-ones n-wire state, defined representation-independently by applying the
already-formalized all-X action to zero. -/
def allOnesBasisState (n : Nat) : PrimitiveBasis n :=
  allXBasisAction (zeroBasisState n)

@[simp] theorem zeroBasisState_apply
    (n : Nat) (wire : Fin n) : zeroBasisState n wire = 0 := by
  rfl

@[simp] theorem allOnesBasisState_apply
    (n : Nat) (wire : Fin n) : allOnesBasisState n wire = 1 := by
  simp [allOnesBasisState, allXBasisAction, zeroBasisState, flipBit]

/-- Little-endian value of the all-zero word. -/
theorem primitiveBasisLEEquiv_zeroBasis_value (n : Nat) :
    (primitiveBasisLEEquiv n (zeroBasisState n)).val = 0 := by
  induction n with
  | zero =>
      exact primitiveBasisLEEquiv_zero_apply (zeroBasisState 0)
  | succ n induction =>
      rw [primitiveBasisLEEquiv_succ_value]
      simp [zeroBasisState, induction]

/-- Little-endian value of the all-ones word. -/
theorem primitiveBasisLEEquiv_allOnes_value (n : Nat) :
    (primitiveBasisLEEquiv n (allOnesBasisState n)).val = gridSize n - 1 := by
  unfold allOnesBasisState
  rw [primitiveBasisLEEquiv_allX_value]
  rw [primitiveBasisLEEquiv_zeroBasis_value]
  omega

@[simp] theorem basisNat_zeroBasis (n : Nat) :
    basisNat n (zeroBasisState n) = 0 := by
  exact primitiveBasisLEEquiv_zeroBasis_value n

@[simp] theorem basisNat_allOnes (n : Nat) :
    basisNat n (allOnesBasisState n) = gridSize n - 1 := by
  exact primitiveBasisLEEquiv_allOnes_value n

/-- The modulus `2^n` is always positive. -/
theorem gridSize_pos (n : Nat) : 0 < gridSize n := by
  exact Nat.pow_pos (by decide)

/-- Any correct n-bit incrementer maps the all-ones word to all zero. -/
theorem incrementerSpec_allOnes_to_zero
    (n : Nat) (permutation : PrimitiveBasis n ≃ PrimitiveBasis n)
    (correct : IncrementerSpec n permutation) :
    permutation (allOnesBasisState n) = zeroBasisState n := by
  apply (primitiveBasisLEEquiv n).injective
  apply Fin.ext
  have action := correct (allOnesBasisState n)
  rw [basisNat_allOnes] at action
  change
    (primitiveBasisLEEquiv n
      (permutation (allOnesBasisState n))).val = 0
  rw [action]
  have positive := gridSize_pos n
  omega

/-- All-X restores all ones from zero. -/
theorem allX_zero_to_allOnes (n : Nat) :
    allXBasisEquiv n (zeroBasisState n) = allOnesBasisState n := by
  rfl

/-- Eq. (40) control invariant: after incrementing an all-ones block and then
applying all-X, the block is all ones again. -/
theorem increment_then_allX_restores_allOnes
    (n : Nat) (permutation : PrimitiveBasis n ≃ PrimitiveBasis n)
    (correct : IncrementerSpec n permutation) :
    allXBasisEquiv n (permutation (allOnesBasisState n)) =
      allOnesBasisState n := by
  rw [incrementerSpec_allOnes_to_zero n permutation correct]
  exact allX_zero_to_allOnes n

/-- Pointwise control form useful for multi-controlled X gates: every wire is
one after the increment/all-X transformation of an all-ones input. -/
theorem increment_then_allX_wire_is_one
    (n : Nat) (permutation : PrimitiveBasis n ≃ PrimitiveBasis n)
    (correct : IncrementerSpec n permutation)
    (wire : Fin n) :
    allXBasisEquiv n (permutation (allOnesBasisState n)) wire = 1 := by
  rw [increment_then_allX_restores_allOnes n permutation correct]
  exact allOnesBasisState_apply n wire

/-- Conversely, if the input block is not all ones then a correct incrementer
cannot map it to zero.  This prevents the Eq. (40) control argument from gaining
spurious active branches. -/
theorem incrementerSpec_maps_to_zero_iff_allOnes
    (n : Nat) (permutation : PrimitiveBasis n ≃ PrimitiveBasis n)
    (correct : IncrementerSpec n permutation)
    (state : PrimitiveBasis n) :
    permutation state = zeroBasisState n ↔ state = allOnesBasisState n := by
  constructor
  · intro outputZero
    have action := correct state
    rw [outputZero, basisNat_zeroBasis] at action
    have stateBound := (primitiveBasisLEEquiv n state).isLt
    have positive := gridSize_pos n
    have valueMax : basisNat n state = gridSize n - 1 := by
      unfold basisNat at action ⊢
      omega
    apply (primitiveBasisLEEquiv n).injective
    apply Fin.ext
    rw [basisNat_allOnes]
    exact valueMax
  · intro inputOnes
    subst state
    exact incrementerSpec_allOnes_to_zero n permutation correct

end ComparatorIncrementerEq40ControlInvariant
end QuantumBlockEncoding
