import QuantumBlockEncoding.ComparatorIncrementerLemma7Contract
import QuantumBlockEncoding.GidneyZeroedSourceStrongPromise
import QuantumBlockEncoding.PredicateControlledStrongPromise

/-!
# Predicate-controlled strong-promise Gidney source semantics

The actual gate-level Gidney source family is now a strong promise incrementer.
This module adds the k-control all-ones predicate at the semantic level and
proves the exact controlled strong-promise contract.

This is not yet the low-resource Lemma-7 circuit: abstract predicate control can
be expensive.  Equations (36)-(38), the promise-register budget, and Figure 9
are the source mechanisms that refine this semantic object to the claimed
O(k+n) / O(log(kn)) circuit.
-/

namespace QuantumBlockEncoding
namespace GidneyZeroedControlledStrongPromise

open ComparatorIncrementerLemma7Contract
open GidneyZeroedSourceProgram
open GidneyZeroedSourceStrongPromise
open PredicateControlledStrongPromise
open ZModPrimitiveBasisBridge

/-- Add k external controls to the actual source strong-promise permutation. -/
def implementation (k carryCount : Nat) :
    Equiv.Perm
      (PrimitiveBasis k ×
        PrimitiveBasis carryCount × PrimitiveBasis (targetWidth carryCount)) :=
  predicateControlledPromiseEquiv
    allControlsActive
    (GidneyZeroedSourceStrongPromise.implementation carryCount)

/-- Exact controlled strong-promise theorem for every k and source width. -/
theorem controlledStrongPromiseSpec
    (k carryCount : Nat) :
    PredicateControlledStrongPromiseSpec
      allControlsActive
      (zeroWorkspace carryCount)
      (implementation k carryCount)
      (basisModularIncrementEquiv (targetWidth carryCount)) := by
  exact predicateControlledPromise_of_strong
    allControlsActive
    (zeroWorkspace carryCount)
    (GidneyZeroedSourceStrongPromise.implementation carryCount)
    (basisModularIncrementEquiv (targetWidth carryCount))
    (GidneyZeroedSourceStrongPromise.strongPromiseSpec carryCount)

/-- Reader-facing action on the clean promise branch. -/
theorem clean_action
    (k carryCount : Nat)
    (controls : PrimitiveBasis k)
    (target : PrimitiveBasis (targetWidth carryCount)) :
    implementation k carryCount
        (controls, zeroWorkspace carryCount, target) =
      if allControlsActive controls then
        (controls, zeroWorkspace carryCount,
          basisModularIncrementEquiv (targetWidth carryCount) target)
      else
        (controls, zeroWorkspace carryCount, target) := by
  cases condition : allControlsActive controls <;>
    simp [implementation, predicateControlledPromiseEquiv,
      condition,
      GidneyZeroedSourceStrongPromise.strongPromiseSpec]

end GidneyZeroedControlledStrongPromise
end QuantumBlockEncoding