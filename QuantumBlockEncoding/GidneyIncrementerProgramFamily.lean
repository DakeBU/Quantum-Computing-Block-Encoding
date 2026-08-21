import QuantumBlockEncoding.ComparatorIncrementerGeneral
import QuantumBlockEncoding.PrimitiveBasisRegisterSplit
import QuantumBlockEncoding.ReversibleSchedule
import Mathlib.Tactic

/-!
# Proof-bearing source interface for the Gidney incrementer used by Lemma 7

Vandaele Lemma 7 starts from an external Gidney-style n-bit incrementer with
O(n) gates, O(n) depth, and `n-2` clean ancillas. ASPBE does not turn that
citation into an axiom. Instead, this module fixes the exact proof-bearing
interface that an imported/re-proved construction must inhabit.

Flat wire order is

`[ n target wires | n-2 clean workspace wires ]`.

The scheduled reversible program, its semantic increment theorem, workspace
restoration, gate count, and depth all refer to the same circuit object.

Figure 9 additionally needs the source incrementer split into four chronological
slices.  The second half of this module records that decomposition as a
refinement of the *same* proof-bearing Gidney family: composing the four slice
programs must reproduce the original Gidney program exactly.
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
def workspaceClean (n : Nat)
    (workspace : PrimitiveBasis (workspaceWidth n)) : Prop :=
  ∀ wire, workspace wire = 0

/-- Direct clean-branch source contract: increment the target modulo `2^n` and
return every clean workspace qubit to zero. -/
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

/-- Direct action theorem for a flat implementation satisfying `FlatSpec`. It
removes the product-conjugation boilerplate for later wire embeddings. -/
theorem flatSpec_action
    (n : Nat)
    (implementation : Equiv.Perm (PrimitiveBasis (flatWidth n)))
    (spec : FlatSpec n implementation)
    (state : PrimitiveBasis (flatWidth n))
    (clean : workspaceClean n (registerEquiv n state).2) :
    basisNat n (registerEquiv n (implementation state)).1 =
        (basisNat n (registerEquiv n state).1 + 1) % gridSize n ∧
    workspaceClean n (registerEquiv n (implementation state)).2 := by
  unfold FlatSpec CleanBranchSpec at spec
  have action := spec
    (registerEquiv n state).1
    (registerEquiv n state).2 clean
  simpa [productViewOfFlat] using action

/-- Uniform source resource target. Constants are fixed once for the entire
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

/-! ## Figure-9 four-slice refinement -/

/-- Chronological composition of the four Gidney slices used in Figure 9. -/
def composeFourSlices {qubits : Nat}
    (slice1 slice2 slice3 slice4 : ScheduledReversibleProgram qubits) :
    ScheduledReversibleProgram qubits :=
  ScheduledReversibleProgram.seq
    (ScheduledReversibleProgram.seq
      (ScheduledReversibleProgram.seq slice1 slice2) slice3)
    slice4

@[simp] theorem composeFourSlices_program {qubits : Nat}
    (slice1 slice2 slice3 slice4 : ScheduledReversibleProgram qubits) :
    (composeFourSlices slice1 slice2 slice3 slice4).program =
      ((slice1.program ++ slice2.program) ++ slice3.program) ++ slice4.program := by
  simp [composeFourSlices]

@[simp] theorem composeFourSlices_gateCount {qubits : Nat}
    (slice1 slice2 slice3 slice4 : ScheduledReversibleProgram qubits) :
    (composeFourSlices slice1 slice2 slice3 slice4).gateCount =
      ((slice1.gateCount + slice2.gateCount) + slice3.gateCount) +
        slice4.gateCount := by
  simp [composeFourSlices]

@[simp] theorem composeFourSlices_depth {qubits : Nat}
    (slice1 slice2 slice3 slice4 : ScheduledReversibleProgram qubits) :
    (composeFourSlices slice1 slice2 slice3 slice4).depth =
      ((slice1.depth + slice2.depth) + slice3.depth) + slice4.depth := by
  simp [composeFourSlices]

/-- Proof-bearing Figure-9 decomposition.  It is not enough for four arbitrary
programs to have plausible gate classes: their chronological composition must
be the exact Gidney program whose increment semantics were certified above. -/
structure FourSliceDecomposition (family : ScheduledFamily) where
  slice1 : (n : Nat) → ScheduledReversibleProgram (flatWidth n)
  slice2 : (n : Nat) → ScheduledReversibleProgram (flatWidth n)
  slice3 : (n : Nat) → ScheduledReversibleProgram (flatWidth n)
  slice4 : (n : Nat) → ScheduledReversibleProgram (flatWidth n)
  reconstructsProgram : ∀ n,
    (composeFourSlices (slice1 n) (slice2 n) (slice3 n) (slice4 n)).program =
      (family.scheduled n).program

namespace FourSliceDecomposition

/-- The four-slice program inherits the certified Gidney increment semantics
because it is extensionally the same reversible program. -/
theorem correctness
    (family : ScheduledFamily)
    (decomposition : FourSliceDecomposition family)
    (n : Nat) :
    FlatSpec n
      (evalReversibleProgram
        (composeFourSlices
          (decomposition.slice1 n)
          (decomposition.slice2 n)
          (decomposition.slice3 n)
          (decomposition.slice4 n)).program) := by
  rw [decomposition.reconstructsProgram n]
  exact family.correctness n

/-- Exact gate count of the source decomposition, derived from the same four
scheduled slices used by its semantic theorem. -/
theorem gateCount_eq_sum
    (family : ScheduledFamily)
    (decomposition : FourSliceDecomposition family)
    (n : Nat) :
    (composeFourSlices
      (decomposition.slice1 n)
      (decomposition.slice2 n)
      (decomposition.slice3 n)
      (decomposition.slice4 n)).gateCount =
      ((decomposition.slice1 n).gateCount +
        (decomposition.slice2 n).gateCount +
        (decomposition.slice3 n).gateCount) +
        (decomposition.slice4 n).gateCount := by
  simp [Nat.add_assoc]

/-- The conservative chronological depth is likewise the exact sum of the four
certified slice depths.  Later controlled replacements may reschedule *inside*
one slice, but cannot silently use a different semantic gate list. -/
theorem depth_eq_sum
    (family : ScheduledFamily)
    (decomposition : FourSliceDecomposition family)
    (n : Nat) :
    (composeFourSlices
      (decomposition.slice1 n)
      (decomposition.slice2 n)
      (decomposition.slice3 n)
      (decomposition.slice4 n)).depth =
      ((decomposition.slice1 n).depth +
        (decomposition.slice2 n).depth +
        (decomposition.slice3 n).depth) +
        (decomposition.slice4 n).depth := by
  simp [Nat.add_assoc]

end FourSliceDecomposition

end GidneyIncrementerProgramFamily
end QuantumBlockEncoding