import QuantumBlockEncoding.GidneyZeroedSourceProgram
import QuantumBlockEncoding.ReversibleProgramSupport
import Mathlib.Tactic

/-!
# Arbitrary-workspace restoration for the Gidney source core

The nested Gidney carry core has the shape

`G_j ; higherCore ; CX(a_j -> x_{j+2}) ; G_j`.

The second `G_j` restores `a_j` even when `a_j` was initially dirty. The reason
is structural: the intervening higher core and target update do not write any
wire touched by `G_j`, so the second self-inverse CCX sees exactly the same
local state produced by the first one.

This module proves those support facts and the local restoration equation.  The
next theorem lifts the local equation through the nested core to all workspace
wires.  No clean-workspace assumption is used.
-/

namespace QuantumBlockEncoding
namespace GidneyZeroedWorkspaceRestoration

open GidneyZeroedSourceProgram
open ReversibleProgramInverse
open ReversibleProgramSupport

/-- A singleton program preserves a wire when its only gate does not target it. -/
theorem preservesWire_singleton_of_not_target
    {qubits : Nat} (gate : ReversibleGate qubits) (wire : Fin qubits)
    (notTarget : ¬ targetsWire gate wire) :
    PreservesWire [gate] wire := by
  intro candidate member
  simp only [List.mem_singleton] at member
  subst candidate
  exact notTarget

/-- A compute-carry gate writes only its designated workspace wire. -/
theorem computeCarryGate_not_targets_target
    (carryCount : Nat) (j : Fin carryCount)
    (target : Fin (targetWidth carryCount)) :
    ¬ targetsWire (computeCarryGate carryCount j)
      (targetWire carryCount target) := by
  by_cases first : j.val = 0
  · simp [computeCarryGate, first, targetsWire,
      targetWire_ne_workspaceWire]
  · simp [computeCarryGate, first, targetsWire,
      targetWire_ne_workspaceWire]

/-- Distinct carry gates write distinct workspace wires. -/
theorem computeCarryGate_not_targets_other_workspace
    (carryCount : Nat) (j other : Fin carryCount)
    (different : j ≠ other) :
    ¬ targetsWire (computeCarryGate carryCount j)
      (workspaceWire carryCount other) := by
  by_cases first : j.val = 0
  · simp [computeCarryGate, first, targetsWire]
    intro equal
    exact different (workspaceWire_injective carryCount equal)
  · simp [computeCarryGate, first, targetsWire]
    intro equal
    exact different (workspaceWire_injective carryCount equal)

/-- A carry-consumption CX writes a target-register bit, never workspace. -/
theorem consumeCarryGate_not_targets_workspace
    (carryCount : Nat) (j workspace : Fin carryCount) :
    ¬ targetsWire (consumeCarryGate carryCount j)
      (workspaceWire carryCount workspace) := by
  simp [consumeCarryGate, targetsWire,
    targetWire_ne_workspaceWire]

/-- A carry-consumption gate at j writes exactly target bit j+2. -/
theorem consumeCarryGate_not_targets_other_target
    (carryCount : Nat) (j : Fin carryCount)
    (target : Fin (targetWidth carryCount))
    (different : target.val ≠ j.val + 2) :
    ¬ targetsWire (consumeCarryGate carryCount j)
      (targetWire carryCount target) := by
  simp [consumeCarryGate, targetsWire]
  intro equal
  have values := congrArg Fin.val equal
  simp only [targetWire_val] at values
  exact different values.symm

/-- The nested core starting at `start` cannot write target bits below
`start+2`. -/
theorem carryCore_preserves_low_target
    (carryCount start count : Nat)
    (bound : start + count ≤ carryCount)
    (target : Fin (targetWidth carryCount))
    (low : target.val < start + 2) :
    PreservesWire
      (carryCoreProgramFrom carryCount start count bound)
      (targetWire carryCount target) := by
  induction count generalizing start with
  | zero =>
      simp [PreservesWire, carryCoreProgramFrom]
  | succ count induction =>
      let j : Fin carryCount := ⟨start, by omega⟩
      have headPreserves :
          PreservesWire [computeCarryGate carryCount j]
            (targetWire carryCount target) :=
        preservesWire_singleton_of_not_target _ _
          (computeCarryGate_not_targets_target carryCount j target)
      have innerPreserves :
          PreservesWire
            (carryCoreProgramFrom carryCount (start + 1) count (by omega))
            (targetWire carryCount target) := by
        apply induction (start := start + 1)
        omega
      have consumePreserves :
          PreservesWire [consumeCarryGate carryCount j]
            (targetWire carryCount target) := by
        apply preservesWire_singleton_of_not_target
        apply consumeCarryGate_not_targets_other_target
        omega
      have tailComputePreserves :
          PreservesWire [computeCarryGate carryCount j]
            (targetWire carryCount target) := headPreserves
      simpa [carryCoreProgramFrom, consumeAndUncomputePair,
        List.append_assoc] using
        preservesWire_append
          ([computeCarryGate carryCount j] ++
            carryCoreProgramFrom carryCount (start + 1) count (by omega))
          ([consumeCarryGate carryCount j] ++ [computeCarryGate carryCount j])
          (targetWire carryCount target)
          (preservesWire_append _ _ _ headPreserves innerPreserves)
          (preservesWire_append _ _ _ consumePreserves tailComputePreserves)

/-- The nested core starting at `start` cannot write workspace wires below
`start`. -/
theorem carryCore_preserves_lower_workspace
    (carryCount start count : Nat)
    (bound : start + count ≤ carryCount)
    (workspace : Fin carryCount)
    (lower : workspace.val < start) :
    PreservesWire
      (carryCoreProgramFrom carryCount start count bound)
      (workspaceWire carryCount workspace) := by
  induction count generalizing start with
  | zero =>
      simp [PreservesWire, carryCoreProgramFrom]
  | succ count induction =>
      let j : Fin carryCount := ⟨start, by omega⟩
      have different : j ≠ workspace := by
        intro equal
        have values := congrArg Fin.val equal
        change start = workspace.val at values
        omega
      have headPreserves :
          PreservesWire [computeCarryGate carryCount j]
            (workspaceWire carryCount workspace) :=
        preservesWire_singleton_of_not_target _ _
          (computeCarryGate_not_targets_other_workspace
            carryCount j workspace different)
      have innerPreserves :
          PreservesWire
            (carryCoreProgramFrom carryCount (start + 1) count (by omega))
            (workspaceWire carryCount workspace) := by
        apply induction (start := start + 1)
        omega
      have consumePreserves :
          PreservesWire [consumeCarryGate carryCount j]
            (workspaceWire carryCount workspace) :=
        preservesWire_singleton_of_not_target _ _
          (consumeCarryGate_not_targets_workspace carryCount j workspace)
      have tailComputePreserves :
          PreservesWire [computeCarryGate carryCount j]
            (workspaceWire carryCount workspace) := headPreserves
      simpa [carryCoreProgramFrom, consumeAndUncomputePair,
        List.append_assoc] using
        preservesWire_append
          ([computeCarryGate carryCount j] ++
            carryCoreProgramFrom carryCount (start + 1) count (by omega))
          ([consumeCarryGate carryCount j] ++ [computeCarryGate carryCount j])
          (workspaceWire carryCount workspace)
          (preservesWire_append _ _ _ headPreserves innerPreserves)
          (preservesWire_append _ _ _ consumePreserves tailComputePreserves)

/-- The carry-consumption CX does not write any wire touched by the matching
compute gate. -/
theorem consume_preserves_compute_touched
    (carryCount : Nat) (j : Fin carryCount)
    (wire : Fin (flatWidth carryCount))
    (touched : (computeCarryGate carryCount j).touches wire) :
    ¬ targetsWire (consumeCarryGate carryCount j) wire := by
  by_cases first : j.val = 0
  · simp [computeCarryGate, first, ReversibleGate.touches] at touched
    rcases touched with rfl | rfl | rfl
    · apply consumeCarryGate_not_targets_other_target
      omega
    · apply consumeCarryGate_not_targets_other_target
      omega
    · exact consumeCarryGate_not_targets_workspace carryCount j j
  · simp [computeCarryGate, first, ReversibleGate.touches] at touched
    rcases touched with rfl | rfl | rfl
    · exact consumeCarryGate_not_targets_workspace carryCount j
        ⟨j.val - 1, by omega⟩
    · apply consumeCarryGate_not_targets_other_target
      omega
    · exact consumeCarryGate_not_targets_workspace carryCount j j

/-- The higher nested core preserves every wire touched by the current carry
compute gate. -/
theorem higherCore_preserves_compute_touched
    (carryCount start count : Nat)
    (bound : start + (count + 1) ≤ carryCount)
    (wire : Fin (flatWidth carryCount))
    (touched :
      (computeCarryGate carryCount ⟨start, by omega⟩).touches wire) :
    PreservesWire
      (carryCoreProgramFrom carryCount (start + 1) count (by omega)) wire := by
  let j : Fin carryCount := ⟨start, by omega⟩
  by_cases first : j.val = 0
  · have startZero : start = 0 := by
      simpa [j] using first
    simp [computeCarryGate, first, ReversibleGate.touches] at touched
    rcases touched with rfl | rfl | rfl
    · apply carryCore_preserves_low_target
      omega
    · apply carryCore_preserves_low_target
      omega
    · apply carryCore_preserves_lower_workspace
      simp [j]
  · have startNonzero : start ≠ 0 := by
      intro zero
      apply first
      simp [j, zero]
    simp [computeCarryGate, first, ReversibleGate.touches] at touched
    rcases touched with rfl | rfl | rfl
    · apply carryCore_preserves_lower_workspace
      simp [j]
      omega
    · apply carryCore_preserves_low_target
      omega
    · apply carryCore_preserves_lower_workspace
      simp [j]

/-- The complete middle section between the two matching compute gates preserves
every wire touched by the compute gate. -/
theorem carryLayerMiddle_preserves_compute_touched
    (carryCount start count : Nat)
    (bound : start + (count + 1) ≤ carryCount)
    (wire : Fin (flatWidth carryCount))
    (touched :
      (computeCarryGate carryCount ⟨start, by omega⟩).touches wire) :
    PreservesWire
      (carryCoreProgramFrom carryCount (start + 1) count (by omega) ++
        [consumeCarryGate carryCount ⟨start, by omega⟩]) wire := by
  apply preservesWire_append
  · exact higherCore_preserves_compute_touched
      carryCount start count bound wire touched
  · exact preservesWire_singleton_of_not_target _ _
      (consume_preserves_compute_touched
        carryCount ⟨start, by omega⟩ wire touched)

/-- One nested carry layer restores its own workspace bit for every basis state,
with no cleanliness assumption. -/
theorem carryLayer_restores_current_workspace
    (carryCount start count : Nat)
    (bound : start + (count + 1) ≤ carryCount)
    (state : PrimitiveBasis (flatWidth carryCount)) :
    evalReversibleProgram
        (carryCoreProgramFrom carryCount start (count + 1) bound)
        state
        (workspaceWire carryCount ⟨start, by omega⟩) =
      state (workspaceWire carryCount ⟨start, by omega⟩) := by
  let j : Fin carryCount := ⟨start, by omega⟩
  let gate := computeCarryGate carryCount j
  let inner := carryCoreProgramFrom carryCount (start + 1) count (by omega)
  let middle := inner ++ [consumeCarryGate carryCount j]
  have decomposition :
      carryCoreProgramFrom carryCount start (count + 1) bound =
        [gate] ++ middle ++ [gate] := by
    simp [carryCoreProgramFrom, consumeAndUncomputePair,
      gate, inner, middle, j, List.append_assoc]
  rw [decomposition, evalReversibleProgram_append,
    evalReversibleProgram_append]
  simp only [Equiv.trans_apply, evalReversibleProgram_singleton]
  let afterFirst := evalReversibleGate gate state
  let afterMiddle := evalReversibleProgram middle afterFirst
  have middlePreserves : ∀ wire, gate.touches wire →
      afterMiddle wire = afterFirst wire := by
    intro wire touched
    exact evalReversibleProgram_apply_of_preservesWire
      middle wire afterFirst
      (by
        simpa [gate, inner, middle, j] using
          carryLayerMiddle_preserves_compute_touched
            carryCount start count bound wire (by simpa [gate, j] using touched))
  have targetTouched : gate.touches (workspaceWire carryCount j) := by
    by_cases first : j.val = 0 <;>
      simp [gate, computeCarryGate, first, ReversibleGate.touches]
  have congruent := evalReversibleGate_congr_on_touches
    gate afterMiddle afterFirst middlePreserves
    (workspaceWire carryCount j) targetTouched
  have double := congrFun (evalReversibleGate_involutive gate state)
    (workspaceWire carryCount j)
  change
    evalReversibleGate gate afterMiddle (workspaceWire carryCount j) =
      state (workspaceWire carryCount j)
  exact congruent.trans double

end GidneyZeroedWorkspaceRestoration
end QuantumBlockEncoding