import QuantumBlockEncoding.GidneyIncrementerProgramFamily
import QuantumBlockEncoding.GidneyIncrementerStrongPromise
import QuantumBlockEncoding.GidneyZeroedSourceCorrectness
import QuantumBlockEncoding.GidneyZeroedWorkspaceRestorationGlobal
import Mathlib.Tactic

/-!
# Concrete proof-bearing Gidney scheduled family

The previous modules now prove the actual gate-level zeroed-ancilla source
program at every width >= 2.  This file plugs that circuit into the repository's
pre-existing `GidneyIncrementerProgramFamily.ScheduledFamily` interface rather
than creating a parallel family abstraction.

The two totalized boundary widths are real circuits as well:

* n=0: the empty program, which is the unique increment modulo 1;
* n=1: one X gate.

For n=c+2, the family uses `GidneyZeroedSourceProgram.sourceScheduled c`.
The conservative sequential schedule gives exactly `3c+2 = 3n-4` gates/depth,
so the single constants 3,3 certify the existing uniform linear resource target
for all widths.
-/

namespace QuantumBlockEncoding
namespace GidneyZeroedScheduledFamily

open ComparatorIncrementerGeneral
open GidneyIncrementerProgramFamily
open GidneyIncrementerStrongPromise
open GidneyZeroedSourceCorrectness
open GidneyZeroedSourceProgram
open GidneyZeroedWorkspaceRestorationGlobal

/-- Boundary n=0 source circuit. -/
def zeroScheduled : ScheduledReversibleProgram (GidneyIncrementerProgramFamily.flatWidth 0) :=
  ScheduledReversibleProgram.sequential []

/-- Boundary n=1 source circuit. -/
def oneScheduled : ScheduledReversibleProgram (GidneyIncrementerProgramFamily.flatWidth 1) :=
  ScheduledReversibleProgram.sequential
    [.x ⟨0, by simp [GidneyIncrementerProgramFamily.flatWidth,
      GidneyIncrementerProgramFamily.workspaceWidth]⟩]

/-- One scheduled source circuit for every target width. -/
def scheduled : (n : Nat) →
    ScheduledReversibleProgram (GidneyIncrementerProgramFamily.flatWidth n)
  | 0 => zeroScheduled
  | 1 => oneScheduled
  | c + 2 => sourceScheduled c

@[simp] theorem scheduled_zero : scheduled 0 = zeroScheduled := by
  rfl

@[simp] theorem scheduled_one : scheduled 1 = oneScheduled := by
  rfl

@[simp] theorem scheduled_succ_succ (c : Nat) :
    scheduled (c + 2) = sourceScheduled c := by
  rfl

/-- The product-register view of the large-width family is exactly the `runSource`
semantics already proved for the source gate list. -/
theorem productView_large_eq_runSource
    (c : Nat)
    (state : PrimitiveBasis (c + 2) × PrimitiveBasis c) :
    GidneyIncrementerProgramFamily.productViewOfFlat (c + 2)
        (evalReversibleProgram (scheduled (c + 2)).program) state =
      runSource c state := by
  rfl

/-- The n=0 boundary circuit satisfies the existing flat source contract. -/
theorem zero_correct :
    GidneyIncrementerProgramFamily.FlatSpec 0
      (evalReversibleProgram (scheduled 0).program) := by
  native_decide

/-- The n=1 boundary circuit satisfies the existing flat source contract. -/
theorem one_correct :
    GidneyIncrementerProgramFamily.FlatSpec 1
      (evalReversibleProgram (scheduled 1).program) := by
  native_decide

/-- Every n>=2 source circuit satisfies the exact pre-existing clean-branch
Gidney contract. -/
theorem large_correct (c : Nat) :
    GidneyIncrementerProgramFamily.FlatSpec (c + 2)
      (evalReversibleProgram (scheduled (c + 2)).program) := by
  unfold GidneyIncrementerProgramFamily.FlatSpec
  unfold GidneyIncrementerProgramFamily.CleanBranchSpec
  intro target workspace clean
  have workspaceEq : workspace = zeroWorkspace c := by
    funext wire
    have zero := clean wire
    simpa [GidneyIncrementerProgramFamily.workspaceClean,
      GidneyIncrementerProgramFamily.workspaceWidth,
      zeroWorkspace] using zero
  subst workspace
  constructor
  · rw [productView_large_eq_runSource]
    exact runSource_clean_correct c target
  · have restored :=
      runSource_restores_workspace c target (zeroWorkspace c)
    rw [productView_large_eq_runSource]
    rw [restored]
    intro wire
    rfl

/-- Uniform semantic correctness for every target width. -/
theorem correctness : ∀ n,
    GidneyIncrementerProgramFamily.FlatSpec n
      (evalReversibleProgram (scheduled n).program)
  | 0 => zero_correct
  | 1 => one_correct
  | c + 2 => large_correct c

/-- Exact scheduled gate count for large widths. -/
@[simp] theorem scheduled_large_gateCount (c : Nat) :
    (scheduled (c + 2)).gateCount = 3 * c + 2 := by
  simp [scheduled, sourceScheduled_gateCount]

/-- Exact conservative scheduled depth for large widths. -/
@[simp] theorem scheduled_large_depth (c : Nat) :
    (scheduled (c + 2)).depth = 3 * c + 2 := by
  simp [scheduled, sourceScheduled_depth]

/-- One uniform linear resource certificate for the concrete source family. -/
theorem resources :
    GidneyIncrementerProgramFamily.UniformResourceTarget
      (fun n => (scheduled n).gateCount)
      (fun n => (scheduled n).depth) := by
  refine ⟨3, 3, ?_⟩
  intro n
  cases n with
  | zero =>
      simp [scheduled, zeroScheduled]
  | succ n =>
      cases n with
      | zero =>
          simp [scheduled, oneScheduled]
      | succ c =>
          constructor <;>
            simp [scheduled, sourceScheduled_gateCount,
              sourceScheduled_depth] <;> omega

/-- The actual arbitrary-width gate-level source family inhabits the existing
proof-bearing Gidney interface. -/
def family : GidneyIncrementerProgramFamily.ScheduledFamily where
  scheduled := scheduled
  correctness := correctness
  resources := resources

/-- The same concrete source program restores arbitrary workspace at every
large width.  Boundary widths have empty workspace. -/
theorem restoresWorkspace : ∀ n target workspace,
    (GidneyIncrementerProgramFamily.productViewOfFlat n
      (evalReversibleProgram (family.scheduled n).program)
      (target, workspace)).2 = workspace
  | 0, target, workspace => by
      native_decide
  | 1, target, workspace => by
      native_decide
  | c + 2, target, workspace => by
      rw [show family.scheduled (c + 2) = scheduled (c + 2) by rfl]
      rw [productView_large_eq_runSource]
      exact runSource_restores_workspace c target workspace

/-- Therefore the concrete family satisfies the source's strong-promise
workspace-restoration refinement, not merely the clean-ancilla contract. -/
def strongPromiseRefinement :
    GidneyIncrementerStrongPromise.StrongPromiseRefinement family where
  restoresWorkspace := restoresWorkspace

/-- Public strong-promise theorem for the concrete gate-level Gidney source
family. -/
theorem strongPromiseSpec (n : Nat) :
    PromiseGateOptimization.StrongPromiseSpec
      (GidneyIncrementerStrongPromise.zeroWorkspace n)
      (GidneyIncrementerStrongPromise.promiseFirstViewOfFlat n
        (evalReversibleProgram (family.scheduled n).program))
      (ZModPrimitiveBasisBridge.basisModularIncrementEquiv n) :=
  GidneyIncrementerStrongPromise.strongPromiseSpec
    family strongPromiseRefinement n

end GidneyZeroedScheduledFamily
end QuantumBlockEncoding