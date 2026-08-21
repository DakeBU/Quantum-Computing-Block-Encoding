import QuantumBlockEncoding.GidneyZeroedWorkspaceRestoration
import QuantumBlockEncoding.PrimitiveBasisRegisterSplit
import Mathlib.Tactic

/-!
# Global arbitrary-workspace restoration for the Gidney source program

The local compute/use/uncompute lemma proves that one nested layer restores its
own dirty workspace bit.  This module lifts that fact through the entire nested
carry core and then through the final low-bit tail.

The resulting theorem is source-significant: for every width and every incoming
workspace contents, the exact gate-level Gidney source program returns the
workspace register bit-for-bit.  This is the missing semantic ingredient needed
to reinterpret the same zeroed-ancilla circuit as a strong promise gate.
-/

namespace QuantumBlockEncoding
namespace GidneyZeroedWorkspaceRestorationGlobal

open GidneyZeroedSourceProgram
open GidneyZeroedWorkspaceRestoration
open PrimitiveBasisRegisterSplit
open ReversibleProgramSupport

/-- Every workspace wire in the active nested range is restored exactly. -/
theorem carryCoreProgramFrom_restores_workspace
    (carryCount start count : Nat)
    (bound : start + count ≤ carryCount)
    (state : PrimitiveBasis (flatWidth carryCount))
    (workspace : Fin carryCount)
    (inRangeLow : start ≤ workspace.val)
    (inRangeHigh : workspace.val < start + count) :
    evalReversibleProgram
        (carryCoreProgramFrom carryCount start count bound)
        state (workspaceWire carryCount workspace) =
      state (workspaceWire carryCount workspace) := by
  induction count generalizing start state with
  | zero =>
      omega
  | succ count induction =>
      let j : Fin carryCount := ⟨start, by omega⟩
      by_cases current : workspace.val = start
      · have workspaceEq : workspace = j := by
          apply Fin.ext
          simpa [j] using current
        subst workspace
        exact carryLayer_restores_current_workspace
          carryCount start count bound state
      · have different : j ≠ workspace := by
          intro equal
          apply current
          have values := congrArg Fin.val equal
          simpa [j] using values
        let gate := computeCarryGate carryCount j
        let inner :=
          carryCoreProgramFrom carryCount (start + 1) count (by omega)
        let pair := consumeAndUncomputePair carryCount j
        have decomposition :
            carryCoreProgramFrom carryCount start (count + 1) bound =
              [gate] ++ inner ++ pair := by
          simp [carryCoreProgramFrom, gate, inner, pair, j,
            List.append_assoc]
        have firstPreserves :
            ¬ targetsWire gate (workspaceWire carryCount workspace) := by
          simpa [gate, j] using
            computeCarryGate_not_targets_other_workspace
              carryCount j workspace different
        have pairPreserves :
            PreservesWire pair (workspaceWire carryCount workspace) := by
          have consumePreserves :
              PreservesWire [consumeCarryGate carryCount j]
                (workspaceWire carryCount workspace) :=
            preservesWire_singleton_of_not_target _ _
              (consumeCarryGate_not_targets_workspace
                carryCount j workspace)
          have computePreserves :
              PreservesWire [computeCarryGate carryCount j]
                (workspaceWire carryCount workspace) :=
            preservesWire_singleton_of_not_target _ _
              (computeCarryGate_not_targets_other_workspace
                carryCount j workspace different)
          simpa [pair, consumeAndUncomputePair] using
            preservesWire_append
              [consumeCarryGate carryCount j]
              [computeCarryGate carryCount j]
              (workspaceWire carryCount workspace)
              consumePreserves computePreserves
        have nextLow : start + 1 ≤ workspace.val := by
          omega
        have nextHigh : workspace.val < (start + 1) + count := by
          omega
        rw [decomposition, evalReversibleProgram_append,
          evalReversibleProgram_append]
        simp only [Equiv.trans_apply, evalReversibleProgram_singleton]
        calc
          evalReversibleProgram pair
              (evalReversibleProgram inner
                (evalReversibleGate gate state))
              (workspaceWire carryCount workspace) =
            evalReversibleProgram inner
                (evalReversibleGate gate state)
                (workspaceWire carryCount workspace) :=
              evalReversibleProgram_apply_of_preservesWire
                pair (workspaceWire carryCount workspace)
                (evalReversibleProgram inner
                  (evalReversibleGate gate state)) pairPreserves
          _ = evalReversibleGate gate state
                (workspaceWire carryCount workspace) := by
              exact induction
                (start := start + 1)
                (state := evalReversibleGate gate state)
                (bound := by omega)
                nextLow nextHigh
          _ = state (workspaceWire carryCount workspace) :=
              evalReversibleGate_apply_of_not_targets
                gate (workspaceWire carryCount workspace)
                state firstPreserves

/-- The complete carry core restores every workspace wire, regardless of its
initial value. -/
theorem carryCoreProgram_restores_workspace
    (carryCount : Nat)
    (state : PrimitiveBasis (flatWidth carryCount))
    (workspace : Fin carryCount) :
    evalReversibleProgram (carryCoreProgram carryCount) state
        (workspaceWire carryCount workspace) =
      state (workspaceWire carryCount workspace) := by
  unfold carryCoreProgram
  exact carryCoreProgramFrom_restores_workspace
    carryCount 0 carryCount (by omega) state workspace
    (by omega) workspace.isLt

/-- The low-bit tail writes only target-register wires. -/
theorem lowBitProgram_preserves_workspace
    (carryCount : Nat) (workspace : Fin carryCount) :
    PreservesWire (lowBitProgram carryCount)
      (workspaceWire carryCount workspace) := by
  intro gate member
  simp [lowBitProgram] at member
  rcases member with rfl | rfl
  · simp [targetsWire, targetWire_ne_workspaceWire]
  · simp [targetsWire, targetWire_ne_workspaceWire]

/-- Full flat source program restores every workspace wire. -/
theorem sourceProgram_restores_workspace_wire
    (carryCount : Nat)
    (state : PrimitiveBasis (flatWidth carryCount))
    (workspace : Fin carryCount) :
    evalReversibleProgram (sourceProgram carryCount) state
        (workspaceWire carryCount workspace) =
      state (workspaceWire carryCount workspace) := by
  unfold sourceProgram
  rw [evalReversibleProgram_append]
  simp only [Equiv.trans_apply]
  calc
    evalReversibleProgram (lowBitProgram carryCount)
        (evalReversibleProgram (carryCoreProgram carryCount) state)
        (workspaceWire carryCount workspace) =
      evalReversibleProgram (carryCoreProgram carryCount) state
        (workspaceWire carryCount workspace) :=
      evalReversibleProgram_apply_of_preservesWire
        (lowBitProgram carryCount)
        (workspaceWire carryCount workspace)
        (evalReversibleProgram (carryCoreProgram carryCount) state)
        (lowBitProgram_preserves_workspace carryCount workspace)
    _ = state (workspaceWire carryCount workspace) :=
      carryCoreProgram_restores_workspace carryCount state workspace

/-- Gidney's explicit workspace embedding is the generic high-register wire of
`basisSplitEquiv`. -/
theorem workspaceWire_eq_highWire
    (carryCount : Nat) (workspace : Fin carryCount) :
    workspaceWire carryCount workspace =
      highWire (targetWidth carryCount) carryCount workspace := by
  apply Fin.ext
  rfl

/-- Workspace projection through the canonical register view. -/
@[simp] theorem registerEquiv_workspace_apply
    (carryCount : Nat)
    (state : PrimitiveBasis (flatWidth carryCount))
    (workspace : Fin carryCount) :
    (registerEquiv carryCount state).2 workspace =
      state (workspaceWire carryCount workspace) := by
  rw [workspaceWire_eq_highWire]
  rfl

/-- Recombining target/workspace registers recovers each workspace bit at the
flat workspace embedding. -/
@[simp] theorem registerEquiv_symm_workspace_apply
    (carryCount : Nat)
    (target : PrimitiveBasis (targetWidth carryCount))
    (workspace : PrimitiveBasis carryCount)
    (wire : Fin carryCount) :
    ((registerEquiv carryCount).symm (target, workspace))
        (workspaceWire carryCount wire) = workspace wire := by
  rw [workspaceWire_eq_highWire]
  change
    combineBasis (targetWidth carryCount) carryCount (target, workspace)
        (highWire (targetWidth carryCount) carryCount wire) = workspace wire
  exact combineBasis_highWire
    (targetWidth carryCount) carryCount target workspace wire

/-- Reader-facing arbitrary-width theorem: the exact source circuit restores
an arbitrary workspace register bit-for-bit. -/
theorem runSource_restores_workspace
    (carryCount : Nat)
    (target : PrimitiveBasis (targetWidth carryCount))
    (workspace : PrimitiveBasis carryCount) :
    (runSource carryCount (target, workspace)).2 = workspace := by
  funext wire
  unfold runSource
  rw [registerEquiv_workspace_apply]
  rw [sourceProgram_restores_workspace_wire]
  exact registerEquiv_symm_workspace_apply
    carryCount target workspace wire

end GidneyZeroedWorkspaceRestorationGlobal
end QuantumBlockEncoding