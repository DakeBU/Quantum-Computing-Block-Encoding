import QuantumBlockEncoding.BinaryCarryTelescoping
import QuantumBlockEncoding.GidneyZeroedWorkspaceRestorationGlobal
import QuantumBlockEncoding.PrimitiveBasisRegisterSplit
import Mathlib.Tactic

/-!
# Clean carry semantics of the Gidney ascending ladder

On an all-zero workspace, the ascending Gidney CCX ladder computes exactly the
binary carry chain of the unchanged target register.  The proof uses one
inductive invariant at ladder position `start`:

* target wires still equal the source target;
* workspace wires below `start` contain the corresponding prefix carries;
* workspace wires at or above `start` are still zero.

One `computeCarryGate` advances this invariant by one position.  This file is
the clean-workspace counterpart of the arbitrary dirty-workspace restoration
proof.
-/

namespace QuantumBlockEncoding
namespace GidneyZeroedCarryCompute

open BinaryCarryTelescoping
open GidneyZeroedSourceProgram
open GidneyZeroedWorkspaceRestoration
open GidneyZeroedWorkspaceRestorationGlobal
open PrimitiveBasisRegisterSplit
open ReversibleProgramSupport

/-- Totalized target-bit stream used by the generic carry algebra. -/
def targetStream
    (carryCount : Nat)
    (target : PrimitiveBasis (targetWidth carryCount)) : Nat → Fin 2 :=
  fun i => if bound : i < targetWidth carryCount then target ⟨i, bound⟩ else 0

@[simp] theorem targetStream_of_lt
    (carryCount : Nat)
    (target : PrimitiveBasis (targetWidth carryCount))
    (i : Nat) (bound : i < targetWidth carryCount) :
    targetStream carryCount target i = target ⟨i, bound⟩ := by
  simp [targetStream, bound]

/-- Flat clean input state. -/
def cleanFlat
    (carryCount : Nat)
    (target : PrimitiveBasis (targetWidth carryCount)) :
    PrimitiveBasis (flatWidth carryCount) :=
  combineBasis (targetWidth carryCount) carryCount
    (target, zeroWorkspace carryCount)

@[simp] theorem cleanFlat_target
    (carryCount : Nat)
    (target : PrimitiveBasis (targetWidth carryCount))
    (wire : Fin (targetWidth carryCount)) :
    cleanFlat carryCount target (targetWire carryCount wire) = target wire := by
  change
    combineBasis (targetWidth carryCount) carryCount
      (target, zeroWorkspace carryCount)
      (lowWire (targetWidth carryCount) carryCount wire) = target wire
  exact combineBasis_lowWire _ _ _ _ _

@[simp] theorem cleanFlat_workspace
    (carryCount : Nat)
    (target : PrimitiveBasis (targetWidth carryCount))
    (wire : Fin carryCount) :
    cleanFlat carryCount target (workspaceWire carryCount wire) = 0 := by
  rw [workspaceWire_eq_highWire]
  change
    combineBasis (targetWidth carryCount) carryCount
      (target, zeroWorkspace carryCount)
      (highWire (targetWidth carryCount) carryCount wire) = 0
  simp [zeroWorkspace, combineBasis_highWire]

/-- Canonical invariant after computing carries with indices `< start`. -/
def ComputeInvariant
    (carryCount : Nat)
    (target : PrimitiveBasis (targetWidth carryCount))
    (start : Nat)
    (state : PrimitiveBasis (flatWidth carryCount)) : Prop :=
  (∀ wire : Fin (targetWidth carryCount),
      state (targetWire carryCount wire) = target wire) ∧
  (∀ workspace : Fin carryCount,
      workspace.val < start →
        state (workspaceWire carryCount workspace) =
          carryChain (targetStream carryCount target) (workspace.val + 2)) ∧
  (∀ workspace : Fin carryCount,
      start ≤ workspace.val →
        state (workspaceWire carryCount workspace) = 0)

/-- The clean input satisfies the invariant at position zero. -/
theorem cleanFlat_invariant_zero
    (carryCount : Nat)
    (target : PrimitiveBasis (targetWidth carryCount)) :
    ComputeInvariant carryCount target 0 (cleanFlat carryCount target) := by
  constructor
  · intro wire
    exact cleanFlat_target carryCount target wire
  · constructor
    · intro workspace lower
      omega
    · intro workspace _
      exact cleanFlat_workspace carryCount target workspace

/-- A CCX with a zero target computes the Boolean conjunction of its two control
bits into that target. -/
theorem ccx_zero_target_eq_andBit
    {qubits : Nat}
    (control0 control1 target : Fin qubits)
    (c0_ne_target : control0 ≠ target)
    (c1_ne_target : control1 ≠ target)
    (state : PrimitiveBasis qubits)
    (zeroTarget : state target = 0) :
    (ccxBasisAction control0 control1 target state) target =
      andBit (state control0) (state control1) := by
  rcases fin2_cases (state control0) with h0 | h0 <;>
    rcases fin2_cases (state control1) with h1 | h1 <;>
    simp [ccxBasisAction, xBasisAction, andBit,
      zeroTarget, h0, h1]

/-- One ascending source gate advances the carry invariant by exactly one
workspace position. -/
theorem computeCarryGate_advances_invariant
    (carryCount start : Nat)
    (bound : start < carryCount)
    (target : PrimitiveBasis (targetWidth carryCount))
    (state : PrimitiveBasis (flatWidth carryCount))
    (invariant : ComputeInvariant carryCount target start state) :
    ComputeInvariant carryCount target (start + 1)
      (evalReversibleGate
        (computeCarryGate carryCount ⟨start, bound⟩) state) := by
  rcases invariant with ⟨targetFixed, computedBelow, zeroFuture⟩
  let j : Fin carryCount := ⟨start, bound⟩
  constructor
  · intro wire
    calc
      evalReversibleGate (computeCarryGate carryCount j) state
          (targetWire carryCount wire) =
        state (targetWire carryCount wire) :=
          evalReversibleGate_apply_of_not_targets
            (computeCarryGate carryCount j)
            (targetWire carryCount wire) state
            (computeCarryGate_not_targets_target carryCount j wire)
      _ = target wire := targetFixed wire
  · constructor
    · intro workspace lower
      by_cases current : workspace.val = start
      · have workspaceEq : workspace = j := by
          apply Fin.ext
          simpa [j] using current
        subst workspace
        have targetZero : state (workspaceWire carryCount j) = 0 :=
          zeroFuture j (by simp [j])
        by_cases first : start = 0
        · subst start
          have control0 := targetFixed
            (⟨0, by unfold targetWidth; omega⟩ : Fin (targetWidth carryCount))
          have control1 := targetFixed
            (⟨1, by unfold targetWidth; omega⟩ : Fin (targetWidth carryCount))
          have ccxValue := ccx_zero_target_eq_andBit
            (targetWire carryCount ⟨0, by unfold targetWidth; omega⟩)
            (targetWire carryCount ⟨1, by unfold targetWidth; omega⟩)
            (workspaceWire carryCount j)
            (targetWire_ne_workspaceWire carryCount _ _)
            (targetWire_ne_workspaceWire carryCount _ _)
            state targetZero
          change
            evalReversibleGate (computeCarryGate carryCount j) state
                (workspaceWire carryCount j) =
              carryChain (targetStream carryCount target) (j.val + 2)
          rw [show computeCarryGate carryCount j =
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
                (targetWire_ne_workspaceWire carryCount _ _) by
              simp [computeCarryGate, j]]
          change
            ccxBasisAction
              (targetWire carryCount ⟨0, by unfold targetWidth; omega⟩)
              (targetWire carryCount ⟨1, by unfold targetWidth; omega⟩)
              (workspaceWire carryCount j) state
              (workspaceWire carryCount j) = _
          rw [ccxValue]
          rw [control0, control1]
          simp [j, carryChain, targetStream, andBit]
        · let previous : Fin carryCount := ⟨start - 1, by omega⟩
          let sourceBit : Fin (targetWidth carryCount) :=
            ⟨start + 1, by unfold targetWidth; omega⟩
          have previousValue :
              state (workspaceWire carryCount previous) =
                carryChain (targetStream carryCount target) (start + 1) := by
            have below : previous.val < start := by
              simp [previous]
              omega
            have source := computedBelow previous below
            simpa [previous] using source
          have sourceValue :
              state (targetWire carryCount sourceBit) = target sourceBit :=
            targetFixed sourceBit
          have ccxValue := ccx_zero_target_eq_andBit
            (workspaceWire carryCount previous)
            (targetWire carryCount sourceBit)
            (workspaceWire carryCount j)
            (by
              intro equal
              have values := congrArg Fin.val equal
              simp only [workspaceWire_val, targetWire_val] at values
              omega)
            (by
              intro equal
              exact workspaceWire_injective carryCount equal
                |>.elim (by omega))
            (targetWire_ne_workspaceWire carryCount sourceBit j)
            state targetZero
          change
            evalReversibleGate (computeCarryGate carryCount j) state
                (workspaceWire carryCount j) =
              carryChain (targetStream carryCount target) (j.val + 2)
          rw [show computeCarryGate carryCount j =
              .ccx
                (workspaceWire carryCount previous)
                (targetWire carryCount sourceBit)
                (workspaceWire carryCount j)
                (by
                  intro equal
                  have values := congrArg Fin.val equal
                  simp only [workspaceWire_val, targetWire_val] at values
                  omega)
                (by
                  intro equal
                  have indices := workspaceWire_injective carryCount equal
                  have values := congrArg Fin.val indices
                  simp [previous, j] at values
                  omega)
                (targetWire_ne_workspaceWire carryCount sourceBit j) by
              simp [computeCarryGate, j, previous, sourceBit, first]]
          change
            ccxBasisAction
              (workspaceWire carryCount previous)
              (targetWire carryCount sourceBit)
              (workspaceWire carryCount j) state
              (workspaceWire carryCount j) = _
          rw [ccxValue]
          rw [previousValue, sourceValue]
          have streamValue :
              targetStream carryCount target (start + 1) = target sourceBit := by
            simp [targetStream, sourceBit]
          rw [← streamValue]
          simp [j, carryChain]
      · have different : j ≠ workspace := by
          intro equal
          apply current
          have values := congrArg Fin.val equal
          simpa [j] using values
        calc
          evalReversibleGate (computeCarryGate carryCount j) state
              (workspaceWire carryCount workspace) =
            state (workspaceWire carryCount workspace) :=
              evalReversibleGate_apply_of_not_targets
                (computeCarryGate carryCount j)
                (workspaceWire carryCount workspace) state
                (computeCarryGate_not_targets_other_workspace
                  carryCount j workspace different)
          _ = carryChain (targetStream carryCount target) (workspace.val + 2) :=
            computedBelow workspace (by omega)
    · intro workspace future
      have different : j ≠ workspace := by
        intro equal
        have values := congrArg Fin.val equal
        have same : workspace.val = start := by
          simpa [j] using values.symm
        omega
      calc
        evalReversibleGate (computeCarryGate carryCount j) state
            (workspaceWire carryCount workspace) =
          state (workspaceWire carryCount workspace) :=
            evalReversibleGate_apply_of_not_targets
              (computeCarryGate carryCount j)
              (workspaceWire carryCount workspace) state
              (computeCarryGate_not_targets_other_workspace
                carryCount j workspace different)
        _ = 0 := zeroFuture workspace (by omega)

/-- Computing an arbitrary consecutive prefix advances the invariant by the
prefix length. -/
theorem computeCarryProgramFrom_advances_invariant
    (carryCount start count : Nat)
    (bound : start + count ≤ carryCount)
    (target : PrimitiveBasis (targetWidth carryCount))
    (state : PrimitiveBasis (flatWidth carryCount))
    (invariant : ComputeInvariant carryCount target start state) :
    ComputeInvariant carryCount target (start + count)
      (evalReversibleProgram
        (computeCarryProgramFrom carryCount start count bound) state) := by
  induction count generalizing start state with
  | zero =>
      simpa [computeCarryProgramFrom] using invariant
  | succ count induction =>
      let j : Fin carryCount := ⟨start, by omega⟩
      change
        ComputeInvariant carryCount target (start + (count + 1))
          (evalReversibleProgram
            (computeCarryProgramFrom carryCount (start + 1) count (by omega))
            (evalReversibleGate (computeCarryGate carryCount j) state))
      have advanced := computeCarryGate_advances_invariant
        carryCount start (by omega) target state invariant
      have recursive := induction
        (start := start + 1)
        (state := evalReversibleGate (computeCarryGate carryCount j) state)
        (bound := by omega)
        advanced
      simpa [Nat.add_assoc, Nat.add_left_comm, Nat.add_comm] using recursive

/-- Complete ascending carry computation on the zero workspace produces every
prefix carry and leaves the target unchanged. -/
theorem computeCarryProgram_clean_semantics
    (carryCount : Nat)
    (target : PrimitiveBasis (targetWidth carryCount)) :
    ComputeInvariant carryCount target carryCount
      (evalReversibleProgram (computeCarryProgram carryCount)
        (cleanFlat carryCount target)) := by
  unfold computeCarryProgram
  exact computeCarryProgramFrom_advances_invariant
    carryCount 0 carryCount (by omega) target
    (cleanFlat carryCount target)
    (cleanFlat_invariant_zero carryCount target)

/-- Explicit clean carry value after the full ascending ladder. -/
theorem computed_workspace_eq_carryChain
    (carryCount : Nat)
    (target : PrimitiveBasis (targetWidth carryCount))
    (workspace : Fin carryCount) :
    evalReversibleProgram (computeCarryProgram carryCount)
        (cleanFlat carryCount target)
        (workspaceWire carryCount workspace) =
      carryChain (targetStream carryCount target) (workspace.val + 2) := by
  have invariant := computeCarryProgram_clean_semantics carryCount target
  exact invariant.2.1 workspace workspace.isLt

end GidneyZeroedCarryCompute
end QuantumBlockEncoding