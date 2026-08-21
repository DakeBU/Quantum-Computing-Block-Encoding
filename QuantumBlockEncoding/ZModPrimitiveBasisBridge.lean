import QuantumBlockEncoding.ComparatorIncrementerGeneral
import QuantumBlockEncoding.ComparatorIncrementerModularConjugation
import QuantumBlockEncoding.PrimitiveBasisLE
import Mathlib.Tactic

/-!
# `ZMod (2^n)` / flat-index / primitive-basis bridge

The Vandaele arithmetic layers are naturally stated in `ZMod (2^n)`, while the
actual reversible circuit IR acts on `PrimitiveBasis n`.  This module gives one
lossless bridge between those representations.

The bridge is deliberately general: any modular basis permutation can be
transported to the n-wire little-endian basis.  The modular incrementer is only
the first consumer.  Future modular adders and arithmetic block-encoding routes
can reuse the same node instead of rebuilding representation lemmas.
-/

namespace QuantumBlockEncoding
namespace ZModPrimitiveBasisBridge

open ComparatorIncrementerGeneral
open ComparatorIncrementerModularConjugation

/-- Every ASPBE grid size `2^n` is nonzero, as required by the finite `ZMod`
value API. -/
instance gridSizeNeZero (n : Nat) : NeZero (gridSize n) where
  out := by
    have positive : 0 < gridSize n := Nat.pow_pos (by decide)
    omega

/-- Canonical finite representative of a modular value. -/
def zmodFinEquiv (n : Nat) :
    ZMod (gridSize n) ≃ Fin (gridSize n) where
  toFun value := ⟨value.val, ZMod.val_lt value⟩
  invFun index := (index.val : ZMod (gridSize n))
  left_inv value := by
    apply ZMod.val_injective (gridSize n)
    exact ZMod.val_natCast_of_lt (ZMod.val_lt value)
  right_inv index := by
    apply Fin.ext
    exact ZMod.val_natCast_of_lt index.isLt

@[simp] theorem zmodFinEquiv_apply_val
    (n : Nat) (value : ZMod (gridSize n)) :
    (zmodFinEquiv n value).val = value.val := by
  rfl

@[simp] theorem zmodFinEquiv_symm_apply_val
    (n : Nat) (index : Fin (gridSize n)) :
    ((zmodFinEquiv n).symm index).val = index.val := by
  exact ZMod.val_natCast_of_lt index.isLt

/-- Little-endian computational basis interpreted as a modular integer. -/
def basisZModEquiv (n : Nat) :
    PrimitiveBasis n ≃ ZMod (gridSize n) :=
  (primitiveBasisLEEquiv n).trans (zmodFinEquiv n).symm

/-- The bridge preserves the canonical little-endian natural value exactly. -/
@[simp] theorem basisZModEquiv_apply_val
    (n : Nat) (state : PrimitiveBasis n) :
    (basisZModEquiv n state).val =
      (primitiveBasisLEEquiv n state).val := by
  unfold basisZModEquiv
  simp

/-- Conversely, transporting a modular value to the basis preserves its
canonical representative. -/
@[simp] theorem basisZModEquiv_symm_value
    (n : Nat) (value : ZMod (gridSize n)) :
    (primitiveBasisLEEquiv n ((basisZModEquiv n).symm value)).val =
      value.val := by
  unfold basisZModEquiv
  simp

/-- Conjugate an arbitrary modular permutation into the n-wire basis. -/
def transportZModPerm (n : Nat)
    (permutation : Equiv.Perm (ZMod (gridSize n))) :
    Equiv.Perm (PrimitiveBasis n) :=
  (basisZModEquiv n).trans
    (permutation.trans (basisZModEquiv n).symm)

/-- Exact commuting square for the representation transport. -/
@[simp] theorem transportZModPerm_commutes
    (n : Nat) (permutation : Equiv.Perm (ZMod (gridSize n)))
    (state : PrimitiveBasis n) :
    basisZModEquiv n (transportZModPerm n permutation state) =
      permutation (basisZModEquiv n state) := by
  simp [transportZModPerm]

/-- Natural representative of one modular successor. -/
theorem modularIncrement_val
    (n : Nat) (value : ZMod (gridSize n)) :
    (modularIncrementEquiv (gridSize n) value).val =
      (value.val + 1) % gridSize n := by
  rw [modularIncrement_apply, ZMod.val_add]
  rw [ZMod.val_natCast]
  have valueReduced : value.val % gridSize n = value.val :=
    Nat.mod_eq_of_lt (ZMod.val_lt value)
  calc
    (value.val + 1 % gridSize n) % gridSize n =
        (value.val % gridSize n + 1 % gridSize n) % gridSize n := by
      rw [valueReduced]
    _ = (value.val + 1) % gridSize n := by
      exact (Nat.add_mod value.val 1 (gridSize n)).symm

/-- The modular incrementer transported through the canonical bridge is an
actual n-wire basis permutation. -/
def basisModularIncrementEquiv (n : Nat) :
    Equiv.Perm (PrimitiveBasis n) :=
  transportZModPerm n (modularIncrementEquiv (gridSize n))

/-- This representation-level transport satisfies the same parameterized
`IncrementerSpec` used by the real reversible gate IR.  Thus a future circuit
refinement can target `basisModularIncrementEquiv` without any remaining
`ZMod`/little-endian semantic ambiguity. -/
theorem basisModularIncrement_satisfies_spec (n : Nat) :
    IncrementerSpec n (basisModularIncrementEquiv n) := by
  intro state
  unfold IncrementerSpec basisNat
  have commuting := transportZModPerm_commutes
    n (modularIncrementEquiv (gridSize n)) state
  have valueCommuting := congrArg ZMod.val commuting
  rw [basisZModEquiv_apply_val] at valueCommuting
  rw [modularIncrement_val] at valueCommuting
  exact valueCommuting

end ZModPrimitiveBasisBridge
end QuantumBlockEncoding
