import QuantumBlockEncoding.ComparatorIncrementerModularConjugation
import QuantumBlockEncoding.PrimitiveBasisLE
import Mathlib.Tactic

/-!
# Arbitrary-width all-X complement semantics

Vandaele Eq. (35) uses X on every target-register wire.  The modular algebra
layer already proved that `x ↦ -x-1` conjugates successor into predecessor.
This module connects that arithmetic description to ASPBE's actual
little-endian computational basis for arbitrary width.

The result here is representation-level: flipping every basis bit sends the
flat integer `x` to `2^n - 1 - x`.  The subsequent gate-level leaf will compile
this pointwise all-X action to a concrete `ReversibleProgram n` / primitive
circuit and account for its controlled fan-out cost.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerAllX

/-- Flip every wire of an n-qubit computational-basis state. -/
def allXBasisAction {n : Nat} (state : PrimitiveBasis n) : PrimitiveBasis n :=
  fun wire => flipBit (state wire)

@[simp] theorem allXBasisAction_apply {n : Nat}
    (state : PrimitiveBasis n) (wire : Fin n) :
    allXBasisAction state wire = flipBit (state wire) := by
  rfl

/-- All-X is self-inverse. -/
theorem allXBasisAction_involutive {n : Nat} :
    Function.Involutive (@allXBasisAction n) := by
  intro state
  funext wire
  simp [allXBasisAction]

/-- All-X as a basis permutation. -/
def allXBasisEquiv (n : Nat) : PrimitiveBasis n ≃ PrimitiveBasis n where
  toFun := allXBasisAction
  invFun := allXBasisAction
  left_inv := allXBasisAction_involutive
  right_inv := allXBasisAction_involutive

@[simp] theorem allXBasisEquiv_apply (n : Nat) (state : PrimitiveBasis n) :
    allXBasisEquiv n state = allXBasisAction state := by
  rfl

/-- Numeric effect of one flipped bit. -/
theorem flipBit_val_eq_one_sub (bit : Fin 2) :
    (flipBit bit).val = 1 - bit.val := by
  fin_cases bit <;> rfl

/-- Exact arbitrary-width little-endian complement identity.

This is the basis-level meaning of the all-X fan-out used in Vandaele
Eq. (35): `x ↦ (2^n-1)-x`. -/
theorem primitiveBasisLEEquiv_allX_value
    (n : Nat) (state : PrimitiveBasis n) :
    (primitiveBasisLEEquiv n (allXBasisAction state)).val =
      gridSize n - 1 - (primitiveBasisLEEquiv n state).val := by
  induction n with
  | zero =>
      simp [allXBasisAction, gridSize, primitiveBasisLEEquiv_zero_apply]
  | succ n induction =>
      rw [primitiveBasisLEEquiv_succ_value,
        primitiveBasisLEEquiv_succ_value]
      have tailIdentity := induction (fun wire => state wire.succ)
      change
        (primitiveBasisLEEquiv n
            (fun wire => flipBit (state wire.succ))).val =
          gridSize n - 1 -
            (primitiveBasisLEEquiv n
              (fun wire => state wire.succ)).val at tailIdentity
      have tailBound :
          (primitiveBasisLEEquiv n
            (fun wire => state wire.succ)).val < gridSize n :=
        (primitiveBasisLEEquiv n (fun wire => state wire.succ)).isLt
      have bitBound : (state 0).val < 2 := (state 0).isLt
      have sizeSucc : gridSize (n + 1) = 2 * gridSize n := by
        simp [gridSize, pow_succ, Nat.mul_comm]
      rw [tailIdentity, flipBit_val_eq_one_sub, sizeSucc]
      omega

/-- Transport all-X to the flat little-endian finite-index representation. -/
def allXFlatEquiv (n : Nat) :
    Fin (gridSize n) ≃ Fin (gridSize n) :=
  (primitiveBasisLEEquiv n).symm.trans
    ((allXBasisEquiv n).trans (primitiveBasisLEEquiv n))

/-- Flat-index form of the same complement identity. -/
@[simp] theorem allXFlatEquiv_value
    (n : Nat) (index : Fin (gridSize n)) :
    (allXFlatEquiv n index).val = gridSize n - 1 - index.val := by
  have basisIdentity := primitiveBasisLEEquiv_allX_value n
    ((primitiveBasisLEEquiv n).symm index)
  simpa [allXFlatEquiv, allXBasisEquiv] using basisIdentity

/-- The transported all-X operation is still involutory. -/
theorem allXFlatEquiv_involutive (n : Nat) :
    Function.Involutive (allXFlatEquiv n) := by
  intro index
  apply Fin.ext
  simp only [allXFlatEquiv_value]
  have indexBound := index.isLt
  have sizePos : 0 < gridSize n := Nat.pow_pos (by decide)
  omega

end ComparatorIncrementerAllX
end QuantumBlockEncoding
