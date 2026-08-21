import QuantumBlockEncoding.BasisIncrementAllXConjugation
import QuantumBlockEncoding.GidneyZeroedSourceDecrement
import QuantumBlockEncoding.GidneyZeroedSourceStrongPromise
import Mathlib.Tactic

/-!
# Equation (35) on the actual Gidney strong-promise source circuit

At target level, bitwise all-X conjugates increment into decrement exactly.
The actual Gidney source permutation additionally carries a promise/workspace
register.  All-X acts only on the target, so conjugating the source increment by
this target operation preserves every promise fibre and performs decrement on
the clean promise branch.

Important evidence boundary: `StrongPromiseSpec` does not constrain target
behavior on non-clean promise fibres.  Therefore this file proves that the
all-X-conjugated implementation and the exact inverse source implementation are
both strong-promise decrement gates and agree on the clean branch; it does NOT
claim equality of the two full permutations away from that branch.
-/

namespace QuantumBlockEncoding
namespace GidneyZeroedEq35Promise

open BasisIncrementAllXConjugation
open GidneyZeroedSourceDecrement
open GidneyZeroedSourceProgram
open GidneyZeroedSourceStrongPromise
open PromiseGateOptimization
open ZModPrimitiveBasisBridge

/-- Apply all-X to the target register while preserving the promise register. -/
def promiseTargetAllX (carryCount : Nat) :
    Equiv.Perm
      (PrimitiveBasis carryCount × PrimitiveBasis (targetWidth carryCount)) :=
  Equiv.prodCongr (Equiv.refl (PrimitiveBasis carryCount))
    (ComparatorIncrementerAllX.allXBasisEquiv (targetWidth carryCount))

/-- Target-all-X conjugation of the actual Gidney source increment permutation. -/
def conjugatedImplementation (carryCount : Nat) :
    Equiv.Perm
      (PrimitiveBasis carryCount × PrimitiveBasis (targetWidth carryCount)) :=
  (promiseTargetAllX carryCount).trans
    ((GidneyZeroedSourceStrongPromise.implementation carryCount).trans
      (promiseTargetAllX carryCount))

/-- The target-only all-X layer preserves every promise value. -/
theorem promiseTargetAllX_preserves_promise
    (carryCount : Nat)
    (promise : PrimitiveBasis carryCount)
    (target : PrimitiveBasis (targetWidth carryCount)) :
    (promiseTargetAllX carryCount (promise, target)).1 = promise := by
  rfl

/-- The conjugated actual source permutation is a strong-promise decrement gate. -/
theorem conjugated_strongPromiseSpec (carryCount : Nat) :
    StrongPromiseSpec
      (zeroWorkspace carryCount)
      (conjugatedImplementation carryCount)
      (basisModularIncrementEquiv (targetWidth carryCount)).symm := by
  have sourceStrong := GidneyZeroedSourceStrongPromise.strongPromiseSpec carryCount
  constructor
  · intro target
    change
      promiseTargetAllX carryCount
        (GidneyZeroedSourceStrongPromise.implementation carryCount
          (zeroWorkspace carryCount,
            ComparatorIncrementerAllX.allXBasisEquiv
              (targetWidth carryCount) target)) =
        (zeroWorkspace carryCount,
          (basisModularIncrementEquiv (targetWidth carryCount)).symm target)
    rw [sourceStrong.1]
    apply Prod.ext
    · rfl
    · exact congrFun
        (allX_conjugates_increment_to_inverse
          (targetWidth carryCount)
          (basisModularIncrementEquiv (targetWidth carryCount))
          (basisModularIncrement_satisfies_spec (targetWidth carryCount)))
        target
  · intro promise target
    change
      (promiseTargetAllX carryCount
        (GidneyZeroedSourceStrongPromise.implementation carryCount
          (promise,
            ComparatorIncrementerAllX.allXBasisEquiv
              (targetWidth carryCount) target))).1 = promise
    rw [promiseTargetAllX_preserves_promise]
    exact sourceStrong.2 promise
      (ComparatorIncrementerAllX.allXBasisEquiv
        (targetWidth carryCount) target)

/-- The target-all-X construction and exact inverse source circuit agree on the
clean promise branch. -/
theorem conjugated_eq_inverse_on_clean
    (carryCount : Nat)
    (target : PrimitiveBasis (targetWidth carryCount)) :
    conjugatedImplementation carryCount (zeroWorkspace carryCount, target) =
      GidneyZeroedSourceDecrement.implementation carryCount
        (zeroWorkspace carryCount, target) := by
  rw [(conjugated_strongPromiseSpec carryCount).1]
  rw [(GidneyZeroedSourceDecrement.strongPromiseSpec carryCount).1]

end GidneyZeroedEq35Promise
end QuantumBlockEncoding