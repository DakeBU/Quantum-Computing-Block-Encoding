import QuantumBlockEncoding.GidneyZeroedSourceCorrectness
import QuantumBlockEncoding.GidneyZeroedWorkspaceRestorationGlobal
import QuantumBlockEncoding.PromiseGateOptimization
import QuantumBlockEncoding.ZModPrimitiveBasisBridge
import Mathlib.Tactic

/-!
# The actual Gidney source gate list is a strong promise incrementer

This theorem does not depend on the higher-level scheduled-family wrapper.  For
every carry count c, conjugate the exact `{CCX,CX,X}` source program into
promise-first coordinates

`workspace(c) × target(c+2)`.

The arbitrary-workspace restoration theorem supplies the unconditional promise
property.  The clean target theorem, together with injectivity of the canonical
little-endian encoding, upgrades numerical modular successor to exact equality
with `basisModularIncrementEquiv (c+2)`.
-/

namespace QuantumBlockEncoding
namespace GidneyZeroedSourceStrongPromise

open ComparatorIncrementerGeneral
open GidneyZeroedSourceCorrectness
open GidneyZeroedSourceProgram
open GidneyZeroedWorkspaceRestorationGlobal
open PromiseGateOptimization
open ZModPrimitiveBasisBridge

/-- Promise-first register view of the exact source permutation. -/
def promiseFirstEquiv (carryCount : Nat) :
    PrimitiveBasis (flatWidth carryCount) ≃
      PrimitiveBasis carryCount × PrimitiveBasis (targetWidth carryCount) :=
  (registerEquiv carryCount).trans
    (Equiv.prodComm
      (PrimitiveBasis (targetWidth carryCount))
      (PrimitiveBasis carryCount))

/-- Same gate-level source program, reindexed as promise × target. -/
def implementation (carryCount : Nat) :
    Equiv.Perm
      (PrimitiveBasis carryCount × PrimitiveBasis (targetWidth carryCount)) :=
  (promiseFirstEquiv carryCount).symm.trans
    ((evalReversibleProgram (sourceProgram carryCount)).trans
      (promiseFirstEquiv carryCount))

/-- Promise-first action is exactly `runSource` with its two product components
swapped. -/
theorem implementation_apply
    (carryCount : Nat)
    (workspace : PrimitiveBasis carryCount)
    (target : PrimitiveBasis (targetWidth carryCount)) :
    implementation carryCount (workspace, target) =
      let output := runSource carryCount (target, workspace)
      (output.2, output.1) := by
  rfl

/-- Clean target is exactly the canonical basis modular increment permutation,
not merely a numerical surrogate. -/
theorem clean_target_exact
    (carryCount : Nat)
    (target : PrimitiveBasis (targetWidth carryCount)) :
    (runSource carryCount (target, zeroWorkspace carryCount)).1 =
      basisModularIncrementEquiv (targetWidth carryCount) target := by
  apply (primitiveBasisLEEquiv (targetWidth carryCount)).injective
  apply Fin.ext
  have sourceValue := runSource_clean_correct carryCount target
  have canonicalValue := basisModularIncrement_satisfies_spec
    (targetWidth carryCount) target
  unfold ComparatorIncrementerGeneral.IncrementerSpec at canonicalValue
  unfold ComparatorIncrementerGeneral.basisNat at sourceValue canonicalValue ⊢
  exact sourceValue.trans canonicalValue.symm

/-- Main theorem: the actual arbitrary-width source gate list is a strong
promise gate for modular increment. -/
theorem strongPromiseSpec (carryCount : Nat) :
    StrongPromiseSpec
      (zeroWorkspace carryCount)
      (implementation carryCount)
      (basisModularIncrementEquiv (targetWidth carryCount)) := by
  constructor
  · intro target
    rw [implementation_apply]
    apply Prod.ext
    · exact runSource_restores_workspace
        carryCount target (zeroWorkspace carryCount)
    · exact clean_target_exact carryCount target
  · intro workspace target
    rw [implementation_apply]
    exact runSource_restores_workspace carryCount target workspace

/-- Matrix-level unitarity follows automatically because the implementation is
a basis permutation. -/
theorem implementation_unitary (carryCount : Nat) :
    Robin.ComplexLCU.equivPermutationMatrix (implementation carryCount) ∈
      _root_.Matrix.unitaryGroup
        (PrimitiveBasis carryCount × PrimitiveBasis (targetWidth carryCount)) ℂ :=
  Robin.ComplexLCU.equivPermutationMatrix_unitary _

end GidneyZeroedSourceStrongPromise
end QuantumBlockEncoding