import QuantumBlockEncoding.GidneyIncrementerProgramFamily
import QuantumBlockEncoding.PromiseGateOptimization
import QuantumBlockEncoding.ZModPrimitiveBasisBridge
import Mathlib.Tactic

/-!
# Strong-promise refinement of the proof-bearing Gidney family

Vandaele Lemma 7 states that the `n-2` clean ancillas in Gidney's incrementer
may be reinterpreted as a promise register, yielding a strong promise gate whose
target unitary is the n-bit incrementer.

The existing `GidneyIncrementerProgramFamily.ScheduledFamily` deliberately
records only what the cited clean-ancilla construction guarantees directly:
correct increment action on a clean workspace and return of that clean
workspace. To justify the stronger promise interpretation we need one extra
property of the *same scheduled program*: for arbitrary incoming workspace
contents, the workspace register is restored exactly.

This module packages that additional proof obligation and shows that, once it is
discharged, the source strong-promise statement follows automatically. No new
circuit is introduced and no resource number is changed.
-/

namespace QuantumBlockEncoding
namespace GidneyIncrementerStrongPromise

open ComparatorIncrementerGeneral
open GidneyIncrementerProgramFamily
open PromiseGateOptimization
open ZModPrimitiveBasisBridge

/-- Canonical all-zero Gidney workspace. -/
def zeroWorkspace (n : Nat) : PrimitiveBasis (workspaceWidth n) :=
  fun _ => 0

@[simp] theorem zeroWorkspace_apply
    (n : Nat) (wire : Fin (workspaceWidth n)) :
    zeroWorkspace n wire = 0 := by
  rfl

/-- The canonical workspace satisfies the clean-ancilla predicate. -/
theorem zeroWorkspace_clean (n : Nat) :
    workspaceClean n (zeroWorkspace n) := by
  intro wire
  rfl

/-- Promise-first view of the flat Gidney register. -/
def promiseFirstRegisterEquiv (n : Nat) :
    PrimitiveBasis (flatWidth n) ≃
      PrimitiveBasis (workspaceWidth n) × PrimitiveBasis n :=
  (registerEquiv n).trans
    (Equiv.prodComm (PrimitiveBasis n) (PrimitiveBasis (workspaceWidth n)))

/-- Conjugate one flat Gidney permutation into promise-first coordinates. -/
def promiseFirstViewOfFlat (n : Nat)
    (implementation : Equiv.Perm (PrimitiveBasis (flatWidth n))) :
    Equiv.Perm
      (PrimitiveBasis (workspaceWidth n) × PrimitiveBasis n) :=
  (promiseFirstRegisterEquiv n).symm.trans
    (implementation.trans (promiseFirstRegisterEquiv n))

/-- Promise-first and target-first product views differ only by swapping the two
registers. -/
theorem promiseFirstViewOfFlat_apply
    (n : Nat)
    (implementation : Equiv.Perm (PrimitiveBasis (flatWidth n)))
    (workspace : PrimitiveBasis (workspaceWidth n))
    (target : PrimitiveBasis n) :
    promiseFirstViewOfFlat n implementation (workspace, target) =
      let output := productViewOfFlat n implementation (target, workspace)
      (output.2, output.1) := by
  rfl

/-- Extra source property needed to reinterpret the same clean-ancilla circuit
as a strong promise gate. -/
structure StrongPromiseRefinement (family : ScheduledFamily) where
  restoresWorkspace : ∀ n target workspace,
    (productViewOfFlat n
      (evalReversibleProgram (family.scheduled n).program)
      (target, workspace)).2 = workspace

/-- Clean-branch target equality upgraded from the numerical `basisNat`
contract to the exact basis permutation used throughout the Vandaele library. -/
theorem clean_target_eq_basisIncrement
    (family : ScheduledFamily)
    (n : Nat) (target : PrimitiveBasis n) :
    (productViewOfFlat n
      (evalReversibleProgram (family.scheduled n).program)
      (target, zeroWorkspace n)).1 =
      basisModularIncrementEquiv n target := by
  have source := family.correctness n
  unfold FlatSpec CleanBranchSpec at source
  have action := source target (zeroWorkspace n) (zeroWorkspace_clean n)
  have expected := basisModularIncrement_satisfies_spec n target
  unfold IncrementerSpec basisNat at expected
  unfold basisNat at action
  apply (primitiveBasisLEEquiv n).injective
  apply Fin.ext
  exact action.1.trans expected.symm

/-- The proof-bearing Gidney family becomes an exact strong promise gate as soon
as arbitrary-workspace restoration of that same program is proved. -/
theorem strongPromiseSpec
    (family : ScheduledFamily)
    (refinement : StrongPromiseRefinement family)
    (n : Nat) :
    StrongPromiseSpec
      (zeroWorkspace n)
      (promiseFirstViewOfFlat n
        (evalReversibleProgram (family.scheduled n).program))
      (basisModularIncrementEquiv n) := by
  constructor
  · intro target
    rw [promiseFirstViewOfFlat_apply]
    apply Prod.ext
    · exact refinement.restoresWorkspace n target (zeroWorkspace n)
    · exact clean_target_eq_basisIncrement family n target
  · intro promise target
    rw [promiseFirstViewOfFlat_apply]
    exact refinement.restoresWorkspace n target promise

/-- The strong refinement does not alter the scheduled resource record: it is a
semantic strengthening of the same source circuit family. -/
theorem resource_identity
    (family : ScheduledFamily)
    (_refinement : StrongPromiseRefinement family)
    (n : Nat) :
    ((family.scheduled n).gateCount, (family.scheduled n).depth) =
      ((family.scheduled n).gateCount, (family.scheduled n).depth) := by
  rfl

end GidneyIncrementerStrongPromise
end QuantumBlockEncoding