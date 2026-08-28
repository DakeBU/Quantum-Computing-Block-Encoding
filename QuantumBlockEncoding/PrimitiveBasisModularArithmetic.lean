import QuantumBlockEncoding.PrimitiveBasisLE
import Mathlib.Tactic

/-!
# Pure modular arithmetic on little-endian primitive basis states

This file isolates representation-level arithmetic that was historically
buried under comparator/incrementer circuit modules.  Nothing here depends on a
particular reversible implementation: it only relates `PrimitiveBasis n`, its
little-endian natural value, and `ZMod (2^n)`.

Keeping this layer independent lets State Preparation, Block Encoding, and
source-facing arithmetic contracts reuse modular basis permutations without
pulling in unrelated comparator resource proofs.
-/

namespace QuantumBlockEncoding
namespace PrimitiveBasisModularArithmetic

/-- Canonical little-endian natural value of an `n`-wire primitive basis. -/
def basisNat (n : Nat) (state : PrimitiveBasis n) : Nat :=
  (primitiveBasisLEEquiv n state).val

/-- Grid sizes are positive, so their `ZMod` representatives have canonical
finite values. -/
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

@[simp] theorem basisZModEquiv_apply_val
    (n : Nat) (state : PrimitiveBasis n) :
    (basisZModEquiv n state).val = basisNat n state := by
  unfold basisZModEquiv basisNat
  simp

@[simp] theorem basisZModEquiv_symm_value
    (n : Nat) (value : ZMod (gridSize n)) :
    basisNat n ((basisZModEquiv n).symm value) = value.val := by
  unfold basisZModEquiv basisNat
  simp

/-- Conjugate an arbitrary modular permutation into the n-wire basis. -/
def transportZModPerm (n : Nat)
    (permutation : Equiv.Perm (ZMod (gridSize n))) :
    Equiv.Perm (PrimitiveBasis n) :=
  (basisZModEquiv n).trans
    (permutation.trans (basisZModEquiv n).symm)

@[simp] theorem transportZModPerm_commutes
    (n : Nat) (permutation : Equiv.Perm (ZMod (gridSize n)))
    (state : PrimitiveBasis n) :
    basisZModEquiv n (transportZModPerm n permutation state) =
      permutation (basisZModEquiv n state) := by
  simp [transportZModPerm]

/-- Addition by a natural constant on `ZMod (2^n)`. -/
def modularAddNatEquiv (n constant : Nat) :
    Equiv.Perm (ZMod (gridSize n)) where
  toFun value := value + constant
  invFun value := value - constant
  left_inv value := by simp
  right_inv value := by simp

@[simp] theorem modularAddNat_apply
    (n constant : Nat) (value : ZMod (gridSize n)) :
    modularAddNatEquiv n constant value = value + constant := by
  rfl

/-- Natural modular addition transported to the real n-wire basis. -/
def basisModularAddNatEquiv (n constant : Nat) :
    Equiv.Perm (PrimitiveBasis n) :=
  transportZModPerm n (modularAddNatEquiv n constant)

/-- Exact commuting square for natural modular addition. -/
theorem basisModularAddNat_commutes
    (n constant : Nat) (state : PrimitiveBasis n) :
    basisZModEquiv n (basisModularAddNatEquiv n constant state) =
      basisZModEquiv n state + constant := by
  exact transportZModPerm_commutes n (modularAddNatEquiv n constant) state

/-- Reader-facing natural-value action: add `constant` modulo `2^n`. -/
theorem basisModularAddNat_value
    (n constant : Nat) (state : PrimitiveBasis n) :
    basisNat n (basisModularAddNatEquiv n constant state) =
      (basisNat n state + constant) % gridSize n := by
  have commuting := basisModularAddNat_commutes n constant state
  have values := congrArg ZMod.val commuting
  rw [ZMod.val_add, ZMod.val_natCast] at values
  simp only [basisZModEquiv_apply_val] at values
  have reduced : basisNat n state % gridSize n = basisNat n state := by
    exact Nat.mod_eq_of_lt (primitiveBasisLEEquiv n state).isLt
  calc
    basisNat n (basisModularAddNatEquiv n constant state) =
        (basisNat n state + constant % gridSize n) % gridSize n := values
    _ = (basisNat n state % gridSize n + constant % gridSize n) % gridSize n := by
      rw [reduced]
    _ = (basisNat n state + constant) % gridSize n :=
      (Nat.add_mod (basisNat n state) constant (gridSize n)).symm

end PrimitiveBasisModularArithmetic
end QuantumBlockEncoding
