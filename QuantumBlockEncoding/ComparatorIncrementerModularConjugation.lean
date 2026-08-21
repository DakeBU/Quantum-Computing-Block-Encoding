import QuantumBlockEncoding.ComparatorIncrementerControlledConjugation
import Mathlib.Data.ZMod.Basic
import Mathlib.Tactic

/-!
# Modular successor / complement instance of Vandaele Eq. (35)-(36)

The previous files isolate the dirty-ancilla protocol abstractly.  Here we
discharge its central algebraic hypothesis for modular arithmetic itself.

On a word interpreted in `ZMod N`, let

* `Inc(x) = x + 1`;
* `Dec(x) = x - 1 = Inc⁻¹(x)`;
* `Xall(x) = -x - 1`.

For `N = 2^n`, `Xall` is exactly the integer action of bitwise X on all n
bits.  Algebraically,

`Xall ; Inc ; Xall = Dec`,

which is Vandaele Eq. (35).  This file proves that identity for arbitrary
modulus and instantiates the Eq. (36) dirty protocol.  The next representation
bridge must prove that the repository's actual all-X n-wire circuit transports
to `Xall` under the little-endian basis/value equivalence.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerModularConjugation

open ComparatorIncrementerDirtyAncilla
open ComparatorIncrementerControlledConjugation

/-- Modular successor. -/
def modularIncrementEquiv (modulus : Nat) : Equiv.Perm (ZMod modulus) where
  toFun value := value + 1
  invFun value := value - 1
  left_inv value := by simp
  right_inv value := by simp

/-- Arithmetic form of bitwise complement: `x ↦ -x-1`.  At modulus `2^n`
this equals `(2^n-1)-x`, hence flips every n-bit digit. -/
def modularComplementEquiv (modulus : Nat) : Equiv.Perm (ZMod modulus) where
  toFun value := -value - 1
  invFun value := -value - 1
  left_inv value := by ring
  right_inv value := by ring

@[simp] theorem modularIncrement_apply (modulus : Nat) (value : ZMod modulus) :
    modularIncrementEquiv modulus value = value + 1 := by
  rfl

@[simp] theorem modularIncrement_symm_apply
    (modulus : Nat) (value : ZMod modulus) :
    (modularIncrementEquiv modulus).symm value = value - 1 := by
  rfl

@[simp] theorem modularComplement_apply
    (modulus : Nat) (value : ZMod modulus) :
    modularComplementEquiv modulus value = -value - 1 := by
  rfl

/-- All-bit complement is an involution. -/
theorem modularComplement_involutive (modulus : Nat) :
    InvolutiveConjugator (modularComplementEquiv modulus) := by
  intro value
  change -(-value - 1) - 1 = value
  ring

/-- Exact algebraic content of Vandaele Eq. (35): all-X conjugates increment
into decrement. -/
theorem modularComplement_increment_inverse (modulus : Nat) :
    InverseByConjugation
      (modularComplementEquiv modulus)
      (modularIncrementEquiv modulus) := by
  apply Equiv.ext
  intro value
  change -((-value - 1) + 1) - 1 = value - 1
  ring

/-- Consequently the four-stage Eq. (35) cancellation is exactly identity. -/
theorem increment_complement_increment_complement_eq_refl (modulus : Nat) :
    (modularIncrementEquiv modulus).trans
        ((modularComplementEquiv modulus).trans
          ((modularIncrementEquiv modulus).trans
            (modularComplementEquiv modulus))) =
      Equiv.refl (ZMod modulus) := by
  exact forward_conjugator_forward_conjugator_eq_refl
    (modularComplementEquiv modulus)
    (modularIncrementEquiv modulus)
    (modularComplement_increment_inverse modulus)

/-- Source-style Eq. (36) specialized to modular increment/decrement.  The
unknown dirty bit is restored and one modular increment is applied iff the
external control predicate holds. -/
theorem dirtyControlledModularIncrement_action
    {κ : Type*} (modulus : Nat) (control : κ → Bool)
    (key : κ) (dirty : Bool) (value : ZMod modulus) :
    dirtyControlledConjugationProtocolEquiv
        control
        (modularComplementEquiv modulus)
        (modularIncrementEquiv modulus)
        (modularIncrementEquiv modulus).symm
        (key, dirty, value) =
      (key, dirty,
        if control key then modularIncrementEquiv modulus value else value) := by
  exact dirtyControlledConjugationProtocol_action
    control
    (modularComplementEquiv modulus)
    (modularIncrementEquiv modulus)
    (modularIncrementEquiv modulus).symm
    (modularComplement_involutive modulus)
    (modularComplement_increment_inverse modulus)
    rfl key dirty value

/-- The specialized protocol restores the dirty ancilla for every input. -/
theorem dirtyControlledModularIncrement_restoresFlag
    {κ : Type*} (modulus : Nat) (control : κ → Bool)
    (key : κ) (dirty : Bool) (value : ZMod modulus) :
    (dirtyControlledConjugationProtocolEquiv
        control
        (modularComplementEquiv modulus)
        (modularIncrementEquiv modulus)
        (modularIncrementEquiv modulus).symm
        (key, dirty, value)).2.1 = dirty := by
  exact dirtyControlledConjugationProtocol_restoresFlag
    control
    (modularComplementEquiv modulus)
    (modularIncrementEquiv modulus)
    (modularIncrementEquiv modulus).symm
    (modularComplement_involutive modulus)
    (modularComplement_increment_inverse modulus)
    rfl key dirty value

end ComparatorIncrementerModularConjugation
end QuantumBlockEncoding
