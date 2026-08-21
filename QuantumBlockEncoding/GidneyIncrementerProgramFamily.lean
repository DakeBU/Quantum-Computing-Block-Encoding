import QuantumBlockEncoding.ComparatorIncrementerGeneral
import QuantumBlockEncoding.PrimitiveBasisRegisterSplit
import QuantumBlockEncoding.ReversibleSchedule
import Mathlib.Tactic

/-!
# Proof-bearing source interface for the Gidney incrementer used by Lemma 7

Vandaele Lemma 7 starts from an external Gidney-style n-bit incrementer with
O(n) gates, O(n) depth, and `n-2` clean ancillas.  ASPBE does not turn that
citation into an axiom.  Instead, this module fixes the exact proof-bearing
interface that an imported/re-proved construction must inhabit.

Flat wire order is

`[ n target wires | n-2 clean workspace wires ]`.

The scheduled reversible program, its semantic increment theorem, workspace
restoration, gate count, and depth all refer to the same circuit object.
-/

namespace QuantumBlockEncoding
namespace GidneyIncrementerProgramFamily

open ComparatorIncrementerGeneral
open PrimitiveBasisRegisterSplit

/-- Source clean-workspace width. -/
def workspaceWidth (n : Nat) : Nat := n - 2

/-- Complete flat width. -/
def flatWidth (n : Nat) : Nat := n + workspaceWidth n

/-- Canonical target/workspace register view. -/
def registerEquiv (n : Nat) :
    PrimitiveBasis (flatWidth n) ≃
      PrimitiveBasis n × PrimitiveBasis (workspaceWidth n) := by
  unfold flatWidth
  exact basisSplitEquiv n (workspaceWidth n)

/-- All workspace qubits are clean. -/
def workspaceClean (n : Nat) (workspace : PrimitiveBasis (workspaceWidth n)) : Prop :=
  ∀ wire, workspace wire = 0

/-- Logical target permutation induced on the clean-workspace branch. -/
def CleanBranchIncrementSpec (n : Nat)
    (implementation : Equiv.Perm
      (PrimitiveBasis n × PrimitiveBasis (workspaceWidth n))) : Prop :=
  ∀ target workspace, workspaceClean n workspace →
    IncrementerSpec n (Equiv.refl (PrimitiveBasis n)) → False ∨
      (basisNat n (implementation (target, workspace)).1 =
          (basisNat n target + 1) % gridSize n ∧
       workspaceClean n (implementation (target, workspace)).2)

/-- Equivalent direct formulation without introducing a fake target Equiv.
This is the actual contract used below. -/
def CleanBranchSpec (n : Nat)
    (implementation : Equiv.Perm
      (PrimitiveBasis n × PrimitiveBasis (workspaceWidth n))) : Prop :=
  ∀ target workspace, workspaceClean n workspace →
    basisNat n (implementation (target, workspace)).1 =
        (basisNat n target + 1) % gridSize n ∧
    workspaceClean n (implementation (target, workspace)).2

/-- Open a flat circuit in target/workspace coordinates. -/
def productViewOfFlat (n : Nat)
    (implementation : Equiv.Perm (PrimitiveBasis (flatWidth n))) :
    Equiv.Perm
      (PrimitiveBasis n × PrimitiveBasis (workspaceWidth n)) :=
  (registerEquiv n).symm.trans
    (implementation.trans (registerEquiv n))

/-- Exact flat source contract. -/
def FlatSpec (n : Nat)
    (implementation : Equiv.Perm (PrimitiveBasis (flatWidth n))) : Prop :=
  CleanBranchSpec n (productViewOfFlat n implementation)

/-- Uniform source resource target.  Constants are fixed once for the entire
family. -/
def UniformResourceTarget
    (gateCount depth : Nat → Nat) : Prop :=
  ∃ gateConstant depthConstant : Nat,
    ∀ n,
      gateCount n ≤ gateConstant * (n + 1) ∧
      depth n ≤ depthConstant * (n + 1)

/-- Final proof-bearing external component expected by the Vandaele Lemma-7
constructor. -/
structure ScheduledFamily where
  scheduled : (n : Nat) → ScheduledReversibleProgram (flatWidth n)
  correctness : ∀ n,
    FlatSpec n (evalReversibleProgram (scheduled n).program)
  resources :
    UniformResourceTarget
      (fun n => (scheduled n).gateCount)
      (fun n => (scheduled n).depth)

/-- Workspace count is definitionally the cited `n-2`. -/
@[simp] theorem workspaceWidth_eq (n : Nat) : workspaceWidth n = n - 2 := by
  rfl

end GidneyIncrementerProgramFamily
end QuantumBlockEncoding
