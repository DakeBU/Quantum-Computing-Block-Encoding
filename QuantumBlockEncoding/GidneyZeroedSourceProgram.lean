import QuantumBlockEncoding.ComparatorIncrementerGeneral
import QuantumBlockEncoding.PrimitiveBasisRegisterSplit
import QuantumBlockEncoding.ReversibleProgramInverse
import Mathlib.Tactic

/-!
# Gate-level Gidney zeroed-ancilla incrementer source program

Gidney's `n-2` zeroed-ancilla construction accumulates prefix carries into the
workspace and then sweeps back down, cleaning each carry immediately after it
has been consumed.  The ordering matters: changing every high target first and
only then uncomputing the carries would read modified controls and would not
restore the workspace.

For `carryCount = n-2`, this module writes the chronological source program over
exact `{CCX,CX,X}` gates:

1. compute the prefix-AND carry ladder into `carryCount` workspace wires;
2. descend from the highest carry to the lowest, applying
   `CX(carry_j -> x_{j+2})` and immediately repeating the corresponding CCX to
   restore `carry_j`;
3. finish with `CX(x_0 -> x_1)` and `X(x_0)`.

The arbitrary-width induction is the next proof layer.  This file already gives
an executable source family and exact finite certificates for the six-bit
Figure-8 benchmark: clean workspace produces modular increment, while arbitrary
workspace contents are restored exactly.
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

/-- One gate of the ascending carry ladder.  At j=0 it computes
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
        apply_fun Fin.val at equal
        simp only [workspaceWire_val] at equal
        omega)
      (by
        intro equal
        apply workspaceWire_injective carryCount equal
        apply Fin.ext
        omega)
      (by
        intro equal
        exact targetWire_ne_workspaceWire carryCount sourceBit j equal)

/-- Ascending carry computation. -/
def computeCarryProgram (carryCount : Nat) :
    ReversibleProgram (flatWidth carryCount) :=
  List.ofFn (computeCarryGate carryCount)

/-- Consume one computed carry to update the corresponding target bit, then
immediately repeat its compute gate so that this workspace bit is restored
before lower target bits are modified. -/
def consumeAndUncomputePair (carryCount : Nat) (j : Fin carryCount) :
    ReversibleProgram (flatWidth carryCount) :=
  [
    .cx
      (workspaceWire carryCount j)
      (targetWire carryCount
        ⟨j.val + 2, by unfold targetWidth; omega⟩)
      (by
        intro equal
        exact targetWire_ne_workspaceWire carryCount _ _ equal.symm),
    computeCarryGate carryCount j
  ]

/-- Descending consume/uncompute sweep. -/
def descendingSweepProgram (carryCount : Nat) :
    ReversibleProgram (flatWidth carryCount) :=
  ((List.ofFn (fun j : Fin carryCount =>
      consumeAndUncomputePair carryCount j)).reverse).flatten

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

/-- Complete gate-level zeroed-ancilla source program. -/
def sourceProgram (carryCount : Nat) :
    ReversibleProgram (flatWidth carryCount) :=
  computeCarryProgram carryCount ++
    descendingSweepProgram carryCount ++
    lowBitProgram carryCount

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
  native_decide

end GidneyZeroedSourceProgram
end QuantumBlockEncoding