import QuantumBlockEncoding.GidneyZeroedSourceStrongPromise
import QuantumBlockEncoding.StrongPromiseInverse

/-!
# Gate-level Gidney decrement from the inverse source permutation

The arbitrary-width Gidney source gate list is now an exact strong-promise
incrementer.  Its inverse permutation therefore gives decrement on the clean
promise branch while restoring arbitrary promise/workspace contents.

This construction reuses the same source circuit in reverse chronological order
at the semantic level; no independent decrement oracle is assumed.
-/

namespace QuantumBlockEncoding
namespace GidneyZeroedSourceDecrement

open GidneyZeroedSourceProgram
open GidneyZeroedSourceStrongPromise
open StrongPromiseInverse
open ZModPrimitiveBasisBridge

/-- Exact inverse of the proved gate-level source permutation in promise-first
coordinates. -/
def implementation (carryCount : Nat) :
    Equiv.Perm
      (PrimitiveBasis carryCount × PrimitiveBasis (targetWidth carryCount)) :=
  (GidneyZeroedSourceStrongPromise.implementation carryCount).symm

/-- The inverse source circuit is a strong promise decrement gate. -/
theorem strongPromiseSpec (carryCount : Nat) :
    PromiseGateOptimization.StrongPromiseSpec
      (zeroWorkspace carryCount)
      (implementation carryCount)
      (basisModularIncrementEquiv (targetWidth carryCount)).symm := by
  exact StrongPromiseInverse.strongPromise_symm
    (zeroWorkspace carryCount)
    (GidneyZeroedSourceStrongPromise.implementation carryCount)
    (basisModularIncrementEquiv (targetWidth carryCount))
    (GidneyZeroedSourceStrongPromise.strongPromiseSpec carryCount)

/-- Clean branch action of the gate-level decrement. -/
theorem clean_action
    (carryCount : Nat)
    (target : PrimitiveBasis (targetWidth carryCount)) :
    implementation carryCount (zeroWorkspace carryCount, target) =
      (zeroWorkspace carryCount,
        (basisModularIncrementEquiv (targetWidth carryCount)).symm target) :=
  (strongPromiseSpec carryCount).1 target

/-- Promise/workspace restoration remains unconditional. -/
theorem restores_workspace
    (carryCount : Nat)
    (workspace : PrimitiveBasis carryCount)
    (target : PrimitiveBasis (targetWidth carryCount)) :
    (implementation carryCount (workspace, target)).1 = workspace :=
  (strongPromiseSpec carryCount).2 workspace target

end GidneyZeroedSourceDecrement
end QuantumBlockEncoding