import QuantumBlockEncoding.ComparatorIncrementerAllX
import QuantumBlockEncoding.ComparatorIncrementerGeneral
import QuantumBlockEncoding.ZModPrimitiveBasisBridge
import Mathlib.Tactic

/-!
# Vandaele classical-quantum adder target and Equation (51)

Section 6 uses the n-bit classical-quantum adder

`|x> -> |(x+c) mod 2^n>`.

This module names that target as a canonical permutation, first on `ZMod(2^n)`
and then on the actual little-endian computational basis.

Corollary 8 relies on Equation (51): conjugating addition by bitwise X turns
addition by c into addition by -c.  This is the additive analogue of Equation
(35) for incrementers and is proved exactly here.
-/

namespace QuantumBlockEncoding
namespace VandaeleClassicalAdderTarget

open ComparatorIncrementerAllX
open ComparatorIncrementerGeneral
open ZModPrimitiveBasisBridge

/-- Addition by one modular constant. -/
def modularAddEquiv (n : Nat) (constant : ZMod (gridSize n)) :
    Equiv.Perm (ZMod (gridSize n)) where
  toFun value := value + constant
  invFun value := value - constant
  left_inv value := by simp
  right_inv value := by simp

@[simp] theorem modularAdd_apply
    (n : Nat) (constant value : ZMod (gridSize n)) :
    modularAddEquiv n constant value = value + constant := by
  rfl

/-- Transport modular addition to the repository's real basis register. -/
def basisModularAddEquiv
    (n : Nat) (constant : ZMod (gridSize n)) :
    Equiv.Perm (PrimitiveBasis n) :=
  transportZModPerm n (modularAddEquiv n constant)

/-- Exact basis/ZMod commuting square. -/
theorem basisModularAdd_commutes
    (n : Nat) (constant : ZMod (gridSize n))
    (state : PrimitiveBasis n) :
    basisZModEquiv n (basisModularAddEquiv n constant state) =
      basisZModEquiv n state + constant := by
  exact transportZModPerm_commutes n (modularAddEquiv n constant) state

/-- Source-facing basis contract for a classical constant represented in ZMod. -/
def ClassicalAdderSpec
    (n : Nat) (constant : ZMod (gridSize n))
    (implementation : Equiv.Perm (PrimitiveBasis n)) : Prop :=
  ∀ state,
    basisZModEquiv n (implementation state) =
      basisZModEquiv n state + constant

@[simp] theorem basisModularAdd_spec
    (n : Nat) (constant : ZMod (gridSize n)) :
    ClassicalAdderSpec n constant (basisModularAddEquiv n constant) := by
  intro state
  exact basisModularAdd_commutes n constant state

/-- Natural representative of a Nat-valued source constant. -/
def natConstant (n constant : Nat) : ZMod (gridSize n) := constant

/-- Reader-facing natural-value action. -/
theorem basisModularAdd_nat_value
    (n constant : Nat) (state : PrimitiveBasis n) :
    basisNat n (basisModularAddEquiv n (natConstant n constant) state) =
      (basisNat n state + constant) % gridSize n := by
  unfold basisNat natConstant
  have commuting := basisModularAdd_commutes n (constant : ZMod (gridSize n)) state
  have values := congrArg ZMod.val commuting
  rw [basisZModEquiv_apply_val, basisZModEquiv_apply_val] at values
  rw [ZMod.val_add, ZMod.val_natCast] at values
  have reduced : basisNat n state % gridSize n = basisNat n state := by
    exact Nat.mod_eq_of_lt (primitiveBasisLEEquiv n state).isLt
  rw [reduced] at values
  exact values

/-- Modular one's complement used by Equation (51). -/
def modularComplement (n : Nat) : Equiv.Perm (ZMod (gridSize n)) where
  toFun value := -value - 1
  invFun value := -value - 1
  left_inv value := by ring
  right_inv value := by ring

/-- One's-complement conjugation turns +c into -c. -/
theorem modularComplement_add_conjugation
    (n : Nat) (constant : ZMod (gridSize n)) :
    ((modularComplement n).trans (modularAddEquiv n constant)).trans
        (modularComplement n) =
      modularAddEquiv n (-constant) := by
  apply Equiv.ext
  intro value
  simp [modularComplement, modularAddEquiv]
  ring

/-- Bitwise all-X on the actual basis is the transport of modular one's
complement. -/
theorem basis_allX_eq_transportComplement (n : Nat) :
    allXBasisEquiv n = transportZModPerm n (modularComplement n) := by
  apply Equiv.ext
  intro state
  apply (basisZModEquiv n).injective
  rw [transportZModPerm_commutes]
  apply ZMod.val_injective (gridSize n)
  rw [basisZModEquiv_apply_val]
  rw [basisZModEquiv_apply_val]
  have source := primitiveBasisLEEquiv_allX_value n state
  have sizePositive : 0 < gridSize n := Nat.pow_pos (by decide)
  simp [modularComplement]
  rw [source]
  by_cases zero : (primitiveBasisLEEquiv n state).val = 0
  · simp [zero]
  · have positive : 0 < (primitiveBasisLEEquiv n state).val := Nat.pos_of_ne_zero zero
    have bound := (primitiveBasisLEEquiv n state).isLt
    simp
    omega

/-- Equation (51) on the actual computational-basis register. -/
theorem equationFiftyOne
    (n : Nat) (constant : ZMod (gridSize n)) :
    ((allXBasisEquiv n).trans (basisModularAddEquiv n constant)).trans
        (allXBasisEquiv n) =
      basisModularAddEquiv n (-constant) := by
  rw [basis_allX_eq_transportComplement]
  apply Equiv.ext
  intro state
  apply (basisZModEquiv n).injective
  simp [basisModularAddEquiv, transportZModPerm]
  have source := Equiv.congr_fun (modularComplement_add_conjugation n constant)
    (basisZModEquiv n state)
  exact source

end VandaeleClassicalAdderTarget
end QuantumBlockEncoding
