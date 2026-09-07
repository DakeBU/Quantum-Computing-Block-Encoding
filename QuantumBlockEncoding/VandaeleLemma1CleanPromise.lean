import QuantumBlockEncoding.VandaeleLemma1BorrowedNCTGadgets
import QuantumBlockEncoding.ReversibleComputeActionUncompute
import Mathlib.Tactic

/-!
# Promise-aware correctness contract for the clean Nie recursion

Nie Figure 3 is first proved with one clean ancilla.  The dirty-ancilla theorem
is obtained only afterwards by toggle detection.  Formalizing the recursive
proof therefore needs an explicit promise contract rather than silently treating
an arbitrary borrowed wire as initialized.

`CleanFlatSpec` is the source `C^k X` contract under the promise that the final
workspace wire starts at zero.  `ForwardComputesAnd` records the stronger
intermediate fact consumed by the parent Figure-3 node: when both the child
target and clean workspace start at zero, the exposed first half has already
stored the AND of all child controls on its target.

A `CleanSplitCertificate` ties both facts to the same proof-bearing
`ReversibleComputeActionUncompute`.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma1CleanPromise

open VandaeleLemma1ProgramFamily
open VandaeleLemma1PrimitiveBaseCases
open VandaeleLemma1BorrowedNCTGadgets
open ReversibleComputeActionUncompute

/-- Exact `C^k X` semantics under a clean-workspace input promise. -/
def CleanFlatSpec (k : Nat)
    (implementation : Equiv.Perm (PrimitiveBasis (lemmaOneFlatWidth k))) : Prop :=
  ∀ state,
    state (dirtyWire k) = 0 →
      (∀ wire : Fin k,
        implementation state (controlWire k wire) =
          state (controlWire k wire)) ∧
      implementation state (targetWire k) =
        (if allFlatControlsOne k state then
          flipBit (state (targetWire k))
        else state (targetWire k)) ∧
      implementation state (dirtyWire k) = 0

/-- The first exposed half has computed the child AND on a zero target.  Other
workspace/control wires may still contain reversible garbage; the second half
is responsible for restoring them. -/
def ForwardComputesAnd (k : Nat)
    (split : ReversibleComputeActionUncompute (lemmaOneFlatWidth k)) : Prop :=
  ∀ state,
    state (targetWire k) = 0 →
    state (dirtyWire k) = 0 →
      evalReversibleProgram split.forwardHalf.program state (targetWire k) =
        if allFlatControlsOne k state then 1 else 0

/-- Recursive correctness certificate consumed by the next Figure-3 level. -/
structure CleanSplitCertificate (k : Nat) where
  split : ReversibleComputeActionUncompute (lemmaOneFlatWidth k)
  fullClean : CleanFlatSpec k (evalReversibleProgram split.full.program)
  forwardAnd : ForwardComputesAnd k split

/-- A stronger arbitrary-dirty flat certificate immediately implies the clean
promise contract. -/
theorem flatSpec_implies_clean
    (k : Nat)
    (implementation : Equiv.Perm (PrimitiveBasis (lemmaOneFlatWidth k)))
    (spec : LemmaOneFlatSpec k implementation) :
    CleanFlatSpec k implementation := by
  intro state dirtyZero
  rcases spec state with ⟨controls, target, dirty⟩
  exact ⟨controls, target, dirty.trans dirtyZero⟩

/-- Empty scheduled computation. -/
def emptyScheduled (qubits : Nat) : ScheduledReversibleProgram qubits :=
  ScheduledReversibleProgram.sequential []

/-- Regard any already-certified complete scheduled circuit as an atomic split.
This is used only for the fixed base cases `k≤4`. -/
def atomicSplit {qubits : Nat}
    (scheduled : ScheduledReversibleProgram qubits) :
    ReversibleComputeActionUncompute qubits where
  prepare := emptyScheduled qubits
  commit := scheduled

@[simp] theorem emptyScheduled_program (qubits : Nat) :
    (emptyScheduled qubits).program = [] := by
  simp [emptyScheduled]

@[simp] theorem emptyScheduled_gateCount (qubits : Nat) :
    (emptyScheduled qubits).gateCount = 0 := by
  simp [emptyScheduled]

@[simp] theorem emptyScheduled_depth (qubits : Nat) :
    (emptyScheduled qubits).depth = 0 := by
  simp [emptyScheduled]

@[simp] theorem atomicSplit_forward_program {qubits : Nat}
    (scheduled : ScheduledReversibleProgram qubits) :
    (atomicSplit scheduled).forwardHalf.program = scheduled.program := by
  simp [atomicSplit, emptyScheduled, forwardHalf]

@[simp] theorem atomicSplit_full_program {qubits : Nat}
    (scheduled : ScheduledReversibleProgram qubits) :
    (atomicSplit scheduled).full.program = scheduled.program := by
  simp [atomicSplit, emptyScheduled, full, forwardHalf, cleanup]

@[simp] theorem atomicSplit_commit_gateCount {qubits : Nat}
    (scheduled : ScheduledReversibleProgram qubits) :
    (atomicSplit scheduled).commit.gateCount = scheduled.gateCount := by
  rfl

@[simp] theorem atomicSplit_commit_depth {qubits : Nat}
    (scheduled : ScheduledReversibleProgram qubits) :
    (atomicSplit scheduled).commit.depth = scheduled.depth := by
  rfl

/-- Every strong flat base-case certificate yields both the clean full theorem
and the intermediate AND theorem for its atomic split. -/
def atomicCertificate
    (k : Nat)
    (scheduled : ScheduledReversibleProgram (lemmaOneFlatWidth k))
    (spec : LemmaOneFlatSpec k (evalReversibleProgram scheduled.program)) :
    CleanSplitCertificate k where
  split := atomicSplit scheduled
  fullClean := by
    rw [atomicSplit_full_program]
    exact flatSpec_implies_clean k _ spec
  forwardAnd := by
    intro state targetZero _dirtyZero
    rw [atomicSplit_forward_program]
    have targetEq := (spec state).2.1
    by_cases active : allFlatControlsOne k state
    · simpa [active, targetZero, flipBit] using targetEq
    · simpa [active, targetZero] using targetEq

/-- Native / fixed-NCT base certificates for `k=0,...,4`. -/
def k0Certificate : CleanSplitCertificate 0 :=
  atomicCertificate 0 VandaeleLemma1PrimitiveBaseCases.k0Scheduled
    VandaeleLemma1PrimitiveBaseCases.k0_correct

def k1Certificate : CleanSplitCertificate 1 :=
  atomicCertificate 1 VandaeleLemma1PrimitiveBaseCases.k1Scheduled
    VandaeleLemma1PrimitiveBaseCases.k1_correct

def k2Certificate : CleanSplitCertificate 2 :=
  atomicCertificate 2 VandaeleLemma1PrimitiveBaseCases.k2Scheduled
    VandaeleLemma1PrimitiveBaseCases.k2_correct

def k3Certificate : CleanSplitCertificate 3 :=
  atomicCertificate 3 k3Scheduled k3_correct

def k4Certificate : CleanSplitCertificate 4 :=
  atomicCertificate 4 k4Scheduled k4_correct

/-- All base central commits have a uniform constant resource cap. -/
theorem base_commit_resource_bounds :
    k0Certificate.split.commit.gateCount ≤ 10 ∧
    k1Certificate.split.commit.gateCount ≤ 10 ∧
    k2Certificate.split.commit.gateCount ≤ 10 ∧
    k3Certificate.split.commit.gateCount ≤ 10 ∧
    k4Certificate.split.commit.gateCount ≤ 10 ∧
    k0Certificate.split.commit.depth ≤ 10 ∧
    k1Certificate.split.commit.depth ≤ 10 ∧
    k2Certificate.split.commit.depth ≤ 10 ∧
    k3Certificate.split.commit.depth ≤ 10 ∧
    k4Certificate.split.commit.depth ≤ 10 := by
  simp [k0Certificate, k1Certificate, k2Certificate, k3Certificate,
    k4Certificate, atomicCertificate]

end VandaeleLemma1CleanPromise
end QuantumBlockEncoding
