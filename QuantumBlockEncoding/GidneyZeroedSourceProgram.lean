import QuantumBlockEncoding.ComparatorIncrementerGeneral
import QuantumBlockEncoding.PrimitiveBasisRegisterSplit
import QuantumBlockEncoding.ReversibleProgramInverse
import QuantumBlockEncoding.ReversibleSchedule
import Mathlib.Tactic

/-!
# Gate-level Gidney zeroed-ancilla incrementer source program

Gidney's `n-2` zeroed-ancilla construction accumulates prefix carries into the
workspace and then sweeps back down, cleaning each carry immediately after it
has been consumed. The ordering matters: changing every high target first and
only then uncomputing the carries would read modified controls and would not
restore the workspace.

For `carryCount = n-2`, this module writes the chronological source program over
exact `{CCX,CX,X}` gates.  Two equivalent views of the same gate list are kept:

* `computeCarryProgram ++ descendingSweepProgram` is the source-readable
  ascending-compute / descending-consume-uncompute view;
* `carryCoreProgramFrom` is the nested proof view
  `G_j ; higherCore ; CX_j ; G_j`.

The equality of these views is proved exactly.  The authoritative
`sourceProgram` uses the nested form so arbitrary-width correctness follows the
same compute/use/uncompute induction that the circuit performs.
-/

namespace QuantumBlockEncoding
namespace GidneyZeroedSourceProgram

open ComparatorIncrementerGeneral
open PrimitiveBasisRegisterSplit

/-- Target width represented by a given number of prefix-carry work bits. -/
def targetWidth (carryCount : Nat) : Nat := carryCount + 2

/-- Flat source width: target register followed by the workspace register. -/
def flatWidth (carryCount : Nat) : Nat := targetWidth carryCount + carryCount

/-- Embed one target-register wire into the flat source register. -/
def targetWire (carryCount : Nat)
    (wire : Fin (targetWidth carryCount)) : Fin (flatWidth carryCount) :=
  ⟨wire.val, by
    unfold flatWidth targetWidth
    omega⟩

/-- Embed one workspace wire after the target register. -/
def workspaceWire (carryCount : Nat)
    (wire : Fin carryCount) : Fin (flatWidth carryCount) :=
  ⟨targetWidth carryCount + wire.val, by
    unfold flatWidth
    omega⟩

@[simp] theorem targetWire_val (carryCount : Nat)
    (wire : Fin (targetWidth carryCount)) :
    (targetWire carryCount wire).val = wire.val := by
  rfl

@[simp] theorem workspaceWire_val (carryCount : Nat)
    (wire : Fin carryCount) :
    (workspaceWire carryCount wire).val =
      targetWidth carryCount + wire.val := by
  rfl

/-- Target and workspace embeddings are disjoint. -/
theorem targetWire_ne_workspaceWire
    (carryCount : Nat)
    (target : Fin (targetWidth carryCount))
    (workspace : Fin carryCount) :
    targetWire carryCount target ≠ workspaceWire carryCount workspace := by
  intro equal
  have values := congrArg Fin.val equal
  simp only [targetWire_val, workspaceWire_val] at values
  have targetBound := target.isLt
  omega

/-- Workspace embedding is injective. -/
theorem workspaceWire_injective
    (carryCount : Nat) : Function.Injective (workspaceWire carryCount) := by
  intro left right equal
  apply Fin.ext
  have values := congrArg Fin.val equal
  simp only [workspaceWire_val] at values
  omega

/-- One gate of the ascending carry ladder. At j=0 it computes
`x_0 AND x_1`; later gates extend the prefix with `x_{j+1}`. -/
def computeCarryGate (carryCount : Nat) (j : Fin carryCount) :
    ReversibleGate (flatWidth carryCount) :=
  if first : j.val = 0 then
    .ccx
      (targetWire carryCount ⟨0, by unfold targetWidth; omega⟩)
      (targetWire carryCount ⟨1, by unfold targetWidth; omega⟩)
      (workspaceWire carryCount j)
      (by
        intro equal
        have values := congrArg Fin.val equal
        simp only [targetWire_val] at values
        omega)
      (targetWire_ne_workspaceWire carryCount _ _)
      (targetWire_ne_workspaceWire carryCount _ _)
  else
    let previous : Fin carryCount := ⟨j.val - 1, by omega⟩
    let sourceBit : Fin (targetWidth carryCount) :=
      ⟨j.val + 1, by unfold targetWidth; omega⟩
    .ccx
      (workspaceWire carryCount previous)
      (targetWire carryCount sourceBit)
      (workspaceWire carryCount j)
      (by
        intro equal
        have values := congrArg Fin.val equal
        simp only [workspaceWire_val, targetWire_val] at values
        have sourceBound := sourceBit.isLt
        omega)
      (by
        intro equal
        have indices := workspaceWire_injective carryCount equal
        have values := congrArg Fin.val indices
        change j.val - 1 = j.val at values
        omega)
      (by
        intro equal
        exact targetWire_ne_workspaceWire carryCount sourceBit j equal)

/-- Structural recursion producing the ascending compute gates with indices
`start, ..., start+count-1`. -/
def computeCarryProgramFrom (carryCount : Nat) :
    (start count : Nat) → start + count ≤ carryCount →
      ReversibleProgram (flatWidth carryCount)
  | _, 0, _ => []
  | start, count + 1, bound =>
      computeCarryGate carryCount ⟨start, by omega⟩ ::
        computeCarryProgramFrom carryCount (start + 1) count (by omega)

/-- Complete ascending carry computation. -/
def computeCarryProgram (carryCount : Nat) :
    ReversibleProgram (flatWidth carryCount) :=
  computeCarryProgramFrom carryCount 0 carryCount (by omega)

/-- High-target update controlled by one computed carry. -/
def consumeCarryGate (carryCount : Nat) (j : Fin carryCount) :
    ReversibleGate (flatWidth carryCount) :=
  .cx
    (workspaceWire carryCount j)
    (targetWire carryCount
      ⟨j.val + 2, by unfold targetWidth; omega⟩)
    (by
      intro equal
      exact targetWire_ne_workspaceWire carryCount _ _ equal.symm)

/-- Consume one computed carry, then immediately repeat its compute gate to
restore that workspace bit before lower target bits are modified. -/
def consumeAndUncomputePair (carryCount : Nat) (j : Fin carryCount) :
    ReversibleProgram (flatWidth carryCount) :=
  [consumeCarryGate carryCount j, computeCarryGate carryCount j]

/-- Low-end recursion whose *output order* is descending:
`start+count-1, ..., start`. -/
def descendingSweepProgramFrom (carryCount : Nat) :
    (start count : Nat) → start + count ≤ carryCount →
      ReversibleProgram (flatWidth carryCount)
  | _, 0, _ => []
  | start, count + 1, bound =>
      descendingSweepProgramFrom carryCount (start + 1) count (by omega) ++
        consumeAndUncomputePair carryCount ⟨start, by omega⟩

/-- Complete descending consume/uncompute sweep. -/
def descendingSweepProgram (carryCount : Nat) :
    ReversibleProgram (flatWidth carryCount) :=
  descendingSweepProgramFrom carryCount 0 carryCount (by omega)

/-- Nested compute/use/uncompute view of exactly the same carry core. -/
def carryCoreProgramFrom (carryCount : Nat) :
    (start count : Nat) → start + count ≤ carryCount →
      ReversibleProgram (flatWidth carryCount)
  | _, 0, _ => []
  | start, count + 1, bound =>
      [computeCarryGate carryCount ⟨start, by omega⟩] ++
        carryCoreProgramFrom carryCount (start + 1) count (by omega) ++
        consumeAndUncomputePair carryCount ⟨start, by omega⟩

/-- Complete nested carry core. -/
def carryCoreProgram (carryCount : Nat) :
    ReversibleProgram (flatWidth carryCount) :=
  carryCoreProgramFrom carryCount 0 carryCount (by omega)

/-- Final updates of the two lowest target bits. -/
def lowBitProgram (carryCount : Nat) :
    ReversibleProgram (flatWidth carryCount) :=
  [
    .cx
      (targetWire carryCount ⟨0, by unfold targetWidth; omega⟩)
      (targetWire carryCount ⟨1, by unfold targetWidth; omega⟩)
      (by
        intro equal
        have values := congrArg Fin.val equal
        simp only [targetWire_val] at values
        omega),
    .x (targetWire carryCount ⟨0, by unfold targetWidth; omega⟩)
  ]

/-- Complete gate-level zeroed-ancilla source program in induction-friendly
nested form. -/
def sourceProgram (carryCount : Nat) :
    ReversibleProgram (flatWidth carryCount) :=
  carryCoreProgram carryCount ++ lowBitProgram carryCount

/-- Length of one recursive ascending prefix. -/
theorem computeCarryProgramFrom_length
    (carryCount start count : Nat)
    (bound : start + count ≤ carryCount) :
    (computeCarryProgramFrom carryCount start count bound).length = count := by
  induction count generalizing start with
  | zero =>
      rfl
  | succ count induction =>
      simp [computeCarryProgramFrom,
        induction (start := start + 1)]

@[simp] theorem computeCarryProgram_length (carryCount : Nat) :
    (computeCarryProgram carryCount).length = carryCount := by
  unfold computeCarryProgram
  exact computeCarryProgramFrom_length carryCount 0 carryCount (by omega)

@[simp] theorem consumeAndUncomputePair_length
    (carryCount : Nat) (j : Fin carryCount) :
    (consumeAndUncomputePair carryCount j).length = 2 := by
  rfl

/-- Length of one recursive descending range. -/
theorem descendingSweepProgramFrom_length
    (carryCount start count : Nat)
    (bound : start + count ≤ carryCount) :
    (descendingSweepProgramFrom carryCount start count bound).length =
      2 * count := by
  induction count generalizing start with
  | zero =>
      rfl
  | succ count induction =>
      simp [descendingSweepProgramFrom,
        induction (start := start + 1)]
      ring

@[simp] theorem descendingSweepProgram_length (carryCount : Nat) :
    (descendingSweepProgram carryCount).length = 2 * carryCount := by
  unfold descendingSweepProgram
  exact descendingSweepProgramFrom_length carryCount 0 carryCount (by omega)

/-- Length of the nested carry core. -/
theorem carryCoreProgramFrom_length
    (carryCount start count : Nat)
    (bound : start + count ≤ carryCount) :
    (carryCoreProgramFrom carryCount start count bound).length =
      3 * count := by
  induction count generalizing start with
  | zero =>
      rfl
  | succ count induction =>
      simp [carryCoreProgramFrom,
        induction (start := start + 1)]
      ring

@[simp] theorem carryCoreProgram_length (carryCount : Nat) :
    (carryCoreProgram carryCount).length = 3 * carryCount := by
  unfold carryCoreProgram
  exact carryCoreProgramFrom_length carryCount 0 carryCount (by omega)

/-- Source-readable and induction-friendly carry views are exactly the same gate
list. -/
theorem compute_append_sweep_eq_core
    (carryCount start count : Nat)
    (bound : start + count ≤ carryCount) :
    computeCarryProgramFrom carryCount start count bound ++
        descendingSweepProgramFrom carryCount start count bound =
      carryCoreProgramFrom carryCount start count bound := by
  induction count generalizing start with
  | zero =>
      rfl
  | succ count induction =>
      simp [computeCarryProgramFrom, descendingSweepProgramFrom,
        carryCoreProgramFrom, induction (start := start + 1),
        List.append_assoc]

/-- Public equality between the two complete source presentations. -/
theorem compute_append_sweep_eq_carryCore (carryCount : Nat) :
    computeCarryProgram carryCount ++ descendingSweepProgram carryCount =
      carryCoreProgram carryCount := by
  exact compute_append_sweep_eq_core carryCount 0 carryCount (by omega)

@[simp] theorem lowBitProgram_length (carryCount : Nat) :
    (lowBitProgram carryCount).length = 2 := by
  rfl

/-- Exact arbitrary-width logical gate count of the serial source program. -/
theorem sourceProgram_length (carryCount : Nat) :
    (sourceProgram carryCount).length = 3 * carryCount + 2 := by
  simp [sourceProgram]

/-- The nested authoritative program is definitionally the same source-readable
compute/sweep sequence followed by the low-bit tail. -/
theorem sourceProgram_eq_compute_sweep_low (carryCount : Nat) :
    sourceProgram carryCount =
      computeCarryProgram carryCount ++
        descendingSweepProgram carryCount ++ lowBitProgram carryCount := by
  unfold sourceProgram
  rw [← compute_append_sweep_eq_carryCore]
  simp [List.append_assoc]

/-- Conservative proof-bearing schedule of the exact source gate list. -/
def sourceScheduled (carryCount : Nat) :
    ScheduledReversibleProgram (flatWidth carryCount) :=
  ScheduledReversibleProgram.sequential (sourceProgram carryCount)

@[simp] theorem sourceScheduled_program (carryCount : Nat) :
    (sourceScheduled carryCount).program = sourceProgram carryCount := by
  simp [sourceScheduled]

@[simp] theorem sourceScheduled_gateCount (carryCount : Nat) :
    (sourceScheduled carryCount).gateCount = 3 * carryCount + 2 := by
  simp [sourceScheduled, sourceProgram_length]

/-- The conservative source schedule has one gate per layer; Figure-9
replacement is responsible for lowering this depth without changing the source
semantics. -/
@[simp] theorem sourceScheduled_depth (carryCount : Nat) :
    (sourceScheduled carryCount).depth = 3 * carryCount + 2 := by
  simp [sourceScheduled, sourceProgram_length]

/-- Canonical target/workspace view of the flat source register. -/
def registerEquiv (carryCount : Nat) :
    PrimitiveBasis (flatWidth carryCount) ≃
      PrimitiveBasis (targetWidth carryCount) × PrimitiveBasis carryCount := by
  unfold flatWidth
  exact basisSplitEquiv (targetWidth carryCount) carryCount

/-- Run the exact source program in target/workspace coordinates. -/
def runSource (carryCount : Nat)
    (state : PrimitiveBasis (targetWidth carryCount) × PrimitiveBasis carryCount) :
    PrimitiveBasis (targetWidth carryCount) × PrimitiveBasis carryCount :=
  registerEquiv carryCount
    (evalReversibleProgram (sourceProgram carryCount)
      ((registerEquiv carryCount).symm state))

/-- All-zero workspace. -/
def zeroWorkspace (carryCount : Nat) : PrimitiveBasis carryCount :=
  fun _ => 0

/-- Figure 8(b) uses six target bits and four zeroed workspace bits. -/
abbrev figureEightCarryCount : Nat := 4

/-- Finite gate-level source check: on the clean workspace branch, the six-bit
target is incremented modulo 64 and the workspace returns to zero. -/
theorem figureEightSixBit_clean_correct :
    ∀ target : PrimitiveBasis 6,
      basisNat 6
          (runSource figureEightCarryCount
            (target, zeroWorkspace figureEightCarryCount)).1 =
        (basisNat 6 target + 1) % gridSize 6 ∧
      (runSource figureEightCarryCount
        (target, zeroWorkspace figureEightCarryCount)).2 =
          zeroWorkspace figureEightCarryCount := by
  native_decide

/-- Strong-promise sanity check on the exact Figure-8 gate list: even for an
arbitrary incoming four-bit workspace, the source sweep returns it exactly.
The target action is intentionally unconstrained away from the clean branch. -/
theorem figureEightSixBit_restores_arbitrary_workspace :
    ∀ target : PrimitiveBasis 6,
      ∀ workspace : PrimitiveBasis 4,
        (runSource figureEightCarryCount (target, workspace)).2 = workspace := by
  native_decide

/-- The six-bit source program has the expected linear-size finite gate count. -/
theorem figureEightSixBit_gateCount :
    (sourceProgram figureEightCarryCount).length = 14 := by
  simpa using sourceProgram_length figureEightCarryCount

end GidneyZeroedSourceProgram
end QuantumBlockEncoding