import QuantumBlockEncoding.ComparatorIncrementerLemma7Figure9SourceAssembly
import QuantumBlockEncoding.GidneyIncrementerStrongPromise
import QuantumBlockEncoding.PredicateControlledStrongPromise
import Mathlib.Tactic

/-!
# Transport the optimized Figure-9 circuit to the strong-promise register view

The source-optimized Figure-9 identity is most naturally stated on

`key × flat-Gidney-register`,

while the public Lemma-7 promise contract uses

`key × promise × target`.

This module proves that the canonical promise-first reindexing commutes with
predicate control. Combining that representation theorem with

* the source inverse-ladder condition for slices 1/3; and
* arbitrary-workspace restoration of the same Gidney program

gives the exact predicate-controlled strong-promise semantics of optimized
Figure 9.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma7Figure9StrongPromiseBridge

open ComparatorIncrementerLemma7Contract
open ComparatorIncrementerLemma7Figure9Assembly
open ComparatorIncrementerLemma7Figure9SourceAssembly
open GidneyIncrementerProgramFamily
open GidneyIncrementerStrongPromise
open PredicateControlledConjugation
open PredicateControlledStrongPromise
open ZModPrimitiveBasisBridge

/-- Reindex the target part of a key/flat state into promise-first coordinates. -/
def keyPromiseFirstEquiv (k n : Nat) :
    PrimitiveBasis k × PrimitiveBasis (flatWidth n) ≃
      PrimitiveBasis k ×
        (PrimitiveBasis (workspaceWidth n) × PrimitiveBasis n) :=
  Equiv.prodCongr (Equiv.refl (PrimitiveBasis k))
    (promiseFirstRegisterEquiv n)

/-- Transport a permutation on `key × flat` into `key × promise × target`. -/
def promiseFirstViewOfKeyFlat (k n : Nat)
    (implementation :
      Equiv.Perm (PrimitiveBasis k × PrimitiveBasis (flatWidth n))) :
    Equiv.Perm
      (PrimitiveBasis k ×
        PrimitiveBasis (workspaceWidth n) × PrimitiveBasis n) :=
  (keyPromiseFirstEquiv k n).symm.trans
    (implementation.trans (keyPromiseFirstEquiv k n))

/-- Predicate control commutes exactly with the promise-first representation
transport. -/
theorem promiseFirstView_predicateControlled
    (k n : Nat)
    (implementation : Equiv.Perm (PrimitiveBasis (flatWidth n))) :
    promiseFirstViewOfKeyFlat k n
        (predicateControlledTargetEquiv
          allControlsActive implementation) =
      predicateControlledPromiseEquiv
        allControlsActive
        (promiseFirstViewOfFlat n implementation) := by
  apply Equiv.ext
  intro state
  rcases state with ⟨controls, promise, target⟩
  cases condition : allControlsActive controls <;>
    simp [promiseFirstViewOfKeyFlat, keyPromiseFirstEquiv,
      predicateControlledTargetEquiv, predicateControlledPromiseEquiv,
      promiseFirstViewOfFlat, promiseFirstRegisterEquiv, condition]

/-- The optimized Figure-9 control pattern, when viewed as
`key × promise × target`, is exactly predicate control of the complete
promise-first Gidney implementation. -/
theorem source_optimized_promise_view
    (family : ScheduledFamily)
    (decomposition : FourSliceDecomposition family)
    (k n : Nat)
    (source : SourceFigureNineDecomposition family decomposition n) :
    promiseFirstViewOfKeyFlat k n
      (optimizedFigureNineImplementation
        allControlsActive
        (evalReversibleProgram (decomposition.slice1 n).program)
        (evalReversibleProgram (decomposition.slice2 n).program)
        (evalReversibleProgram (decomposition.slice4 n).program)) =
      predicateControlledPromiseEquiv
        allControlsActive
        (promiseFirstViewOfFlat n
          (evalReversibleProgram (family.scheduled n).program)) := by
  rw [source_optimized_eq_controlledGidney
    family decomposition k n source]
  simpa [controlledGidneyTarget] using
    (promiseFirstView_predicateControlled
      k n (evalReversibleProgram (family.scheduled n).program))

/-- Main semantic bridge for the source Figure-9 construction. Once the same
Gidney family has an arbitrary-workspace restoration proof and the source
four-slice decomposition has its inverse-ladder proof, optimized Figure 9 is an
exact k-controlled strong promise gate whose target is the n-bit incrementer. -/
theorem source_optimized_strongPromise
    (family : ScheduledFamily)
    (decomposition : FourSliceDecomposition family)
    (k n : Nat)
    (source : SourceFigureNineDecomposition family decomposition n)
    (strongGidney : StrongPromiseRefinement family) :
    PredicateControlledStrongPromiseSpec
      allControlsActive
      (zeroWorkspace n)
      (promiseFirstViewOfKeyFlat k n
        (optimizedFigureNineImplementation
          allControlsActive
          (evalReversibleProgram (decomposition.slice1 n).program)
          (evalReversibleProgram (decomposition.slice2 n).program)
          (evalReversibleProgram (decomposition.slice4 n).program)))
      (basisModularIncrementEquiv n) := by
  rw [source_optimized_promise_view family decomposition k n source]
  exact predicateControlledPromise_of_strong
    allControlsActive
    (zeroWorkspace n)
    (promiseFirstViewOfFlat n
      (evalReversibleProgram (family.scheduled n).program))
    (basisModularIncrementEquiv n)
    (strongPromiseSpec family strongGidney n)

end ComparatorIncrementerLemma7Figure9StrongPromiseBridge
end QuantumBlockEncoding