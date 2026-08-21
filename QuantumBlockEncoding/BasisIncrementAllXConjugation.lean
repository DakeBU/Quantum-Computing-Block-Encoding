import QuantumBlockEncoding.ComparatorIncrementerAllX
import QuantumBlockEncoding.PrimitiveBasisLENumeric
import QuantumBlockEncoding.ZModPrimitiveBasisBridge
import Mathlib.Tactic

/-!
# Basis-level Vandaele Equation (35)

The modular algebra layer proves `Xall ; Inc ; Xall = Inc^-1` in `ZMod`.
This file closes the representation layer on ASPBE's actual little-endian
computational basis.  The theorem is intentionally implementation-independent:
any basis permutation satisfying `IncrementerSpec n` obeys the same
all-X-conjugation identity.
-/

namespace QuantumBlockEncoding
namespace BasisIncrementAllXConjugation

open ComparatorIncrementerAllX
open ComparatorIncrementerGeneral
open PrimitiveBasisLENumeric

/-- Numeric all-X action through the public `basisNat` name. -/
theorem basisNat_allX
    (n : Nat) (state : PrimitiveBasis n) :
    basisNat n (allXBasisEquiv n state) =
      gridSize n - 1 - basisNat n state := by
  exact primitiveBasisLEEquiv_allX_value n state

/-- All-X / increment / all-X followed by one more increment is identity.  This
is the convenient cancellation form of Equation (35). -/
theorem allX_increment_allX_increment_action
    (n : Nat)
    (increment : PrimitiveBasis n ≃ PrimitiveBasis n)
    (correct : IncrementerSpec n increment)
    (state : PrimitiveBasis n) :
    increment (allXBasisEquiv n
      (increment (allXBasisEquiv n state))) = state := by
  apply eq_of_basisNat_eq
  let modulus := gridSize n
  let x := basisNat n state
  have modulusPositive : 0 < modulus := Nat.pow_pos (by decide)
  have xBound : x < modulus := by
    unfold x modulus basisNat
    exact (primitiveBasisLEEquiv n state).isLt
  have firstComplement :
      basisNat n (allXBasisEquiv n state) = modulus - 1 - x := by
    simpa [modulus, x] using basisNat_allX n state
  have firstIncrement := correct (allXBasisEquiv n state)
  have secondComplement := basisNat_allX n
    (increment (allXBasisEquiv n state))
  have secondIncrement := correct
    (allXBasisEquiv n (increment (allXBasisEquiv n state)))
  by_cases zero : x = 0
  · have firstIncrementValue :
        basisNat n (increment (allXBasisEquiv n state)) = 0 := by
      rw [firstIncrement, firstComplement]
      simp [modulus, zero]
    have secondComplementValue :
        basisNat n
            (allXBasisEquiv n (increment (allXBasisEquiv n state))) =
          modulus - 1 := by
      rw [secondComplement, firstIncrementValue]
      omega
    rw [secondIncrement, secondComplementValue]
    simp [modulus, zero]
  · have positiveX : 0 < x := by omega
    have firstStep : modulus - 1 - x + 1 = modulus - x := by
      omega
    have lessModulus : modulus - x < modulus := by
      omega
    have firstIncrementValue :
        basisNat n (increment (allXBasisEquiv n state)) = modulus - x := by
      rw [firstIncrement, firstComplement, firstStep,
        Nat.mod_eq_of_lt lessModulus]
    have secondComplementValue :
        basisNat n
            (allXBasisEquiv n (increment (allXBasisEquiv n state))) =
          x - 1 := by
      rw [secondComplement, firstIncrementValue]
      omega
    have predecessorStep : x - 1 + 1 = x := by
      omega
    rw [secondIncrement, secondComplementValue, predecessorStep,
      Nat.mod_eq_of_lt xBound]

/-- Exact Equiv identity: bitwise all-X conjugates any correct n-bit incrementer
into its inverse. -/
theorem allX_conjugates_increment_to_inverse
    (n : Nat)
    (increment : PrimitiveBasis n ≃ PrimitiveBasis n)
    (correct : IncrementerSpec n increment) :
    (allXBasisEquiv n).trans
        (increment.trans (allXBasisEquiv n)) = increment.symm := by
  apply Equiv.ext
  intro state
  apply increment.injective
  simp only [Equiv.trans_apply, Equiv.apply_symm_apply]
  exact allX_increment_allX_increment_action n increment correct state

/-- Canonical repository increment specialization. -/
theorem canonical_allX_conjugates_increment
    (n : Nat) :
    (allXBasisEquiv n).trans
        ((ZModPrimitiveBasisBridge.basisModularIncrementEquiv n).trans
          (allXBasisEquiv n)) =
      (ZModPrimitiveBasisBridge.basisModularIncrementEquiv n).symm := by
  exact allX_conjugates_increment_to_inverse
    n (ZModPrimitiveBasisBridge.basisModularIncrementEquiv n)
    (ZModPrimitiveBasisBridge.basisModularIncrement_satisfies_spec n)

end BasisIncrementAllXConjugation
end QuantumBlockEncoding