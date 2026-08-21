import QuantumBlockEncoding.ComparatorIncrementerGeneral
import QuantumBlockEncoding.PrimitiveBasisLE
import Mathlib.Tactic

/-!
# Restrict a quantum-quantum comparator to a classical constant

The lower-bound argument after Equation (3) also applies to the quantum-quantum
comparator.  Fixing its left n-bit input register to a classical constant c
turns the canonical `a<b` comparator into the Equation-(29) classical-quantum
comparator `c<a` on the remaining quantum register and flag.

This module proves that semantic reduction in product coordinates.  The resource
transfer remains separate because the fixed classical register is allowed to be
supplied as ancilla/input workspace in the source lower-bound argument.
-/

namespace QuantumBlockEncoding
namespace ComparatorQuantumToClassicalRestriction

open ComparatorIncrementerGeneral

/-- Canonical n-bit basis representation of an in-range classical constant. -/
def constantBasis (n : Nat) (constant : Fin (gridSize n)) : PrimitiveBasis n :=
  (primitiveBasisLEEquiv n).symm constant

@[simp] theorem basisNat_constantBasis
    (n : Nat) (constant : Fin (gridSize n)) :
    basisNat n (constantBasis n constant) = constant.val := by
  unfold basisNat constantBasis
  simp

/-- Product-coordinate QQ comparator target. -/
def qqProductAction (n : Nat)
    (state : PrimitiveBasis n × PrimitiveBasis n × Fin 2) :
    PrimitiveBasis n × PrimitiveBasis n × Fin 2 :=
  if basisNat n state.1 < basisNat n state.2.1 then
    (state.1, state.2.1, flipBit state.2.2)
  else state

/-- The product action is involutory because only the flag changes. -/
theorem qqProductAction_involutive (n : Nat) :
    Function.Involutive (qqProductAction n) := by
  intro state
  rcases state with ⟨left, right, flag⟩
  by_cases active : basisNat n left < basisNat n right
  · simp [qqProductAction, active, flipBit_flipBit]
  · simp [qqProductAction, active]

/-- Product-coordinate QQ permutation. -/
def qqProductEquiv (n : Nat) :
    Equiv.Perm (PrimitiveBasis n × PrimitiveBasis n × Fin 2) where
  toFun := qqProductAction n
  invFun := qqProductAction n
  left_inv := qqProductAction_involutive n
  right_inv := qqProductAction_involutive n

/-- Equation-(29) CQ target directly in address×flag coordinates. -/
def cqProductAction
    (n : Nat) (constant : Fin (gridSize n))
    (state : PrimitiveBasis n × Fin 2) : PrimitiveBasis n × Fin 2 :=
  if constant.val < basisNat n state.1 then
    (state.1, flipBit state.2)
  else state

/-- Restrict the QQ action to a fixed classical left register and discard that
unchanged register afterwards. -/
def restrictQQToConstant
    (n : Nat) (constant : Fin (gridSize n))
    (state : PrimitiveBasis n × Fin 2) : PrimitiveBasis n × Fin 2 :=
  let output := qqProductEquiv n (constantBasis n constant, state.1, state.2)
  (output.2.1, output.2.2)

/-- Exact semantic reduction: fixing the left QQ register to c gives the strict
Equation-(29) `c < address` comparator. -/
theorem restrictQQToConstant_eq_cqProductAction
    (n : Nat) (constant : Fin (gridSize n))
    (state : PrimitiveBasis n × Fin 2) :
    restrictQQToConstant n constant state =
      cqProductAction n constant state := by
  rcases state with ⟨address, flag⟩
  unfold restrictQQToConstant qqProductEquiv qqProductAction cqProductAction
  simp [basisNat_constantBasis]

/-- The fixed left register is indeed preserved by the QQ target. -/
theorem qqProduct_preserves_fixed_constant
    (n : Nat) (constant : Fin (gridSize n))
    (address : PrimitiveBasis n) (flag : Fin 2) :
    (qqProductEquiv n (constantBasis n constant, address, flag)).1 =
      constantBasis n constant := by
  by_cases active : constant.val < basisNat n address <;>
    simp [qqProductEquiv, qqProductAction, basisNat_constantBasis, active]

/-- Reader-facing flag equation of the restricted comparator. -/
theorem restrictQQToConstant_flag
    (n : Nat) (constant : Fin (gridSize n))
    (address : PrimitiveBasis n) (flag : Fin 2) :
    (restrictQQToConstant n constant (address, flag)).2 =
      if constant.val < basisNat n address then flipBit flag else flag := by
  rw [restrictQQToConstant_eq_cqProductAction]
  by_cases active : constant.val < basisNat n address <;>
    simp [cqProductAction, active]

end ComparatorQuantumToClassicalRestriction
end QuantumBlockEncoding
