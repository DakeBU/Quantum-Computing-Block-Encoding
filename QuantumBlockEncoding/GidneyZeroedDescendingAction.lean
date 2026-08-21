import QuantumBlockEncoding.BinaryCarryTelescoping
import QuantumBlockEncoding.GidneyZeroedWorkspaceRestoration
import Mathlib.Tactic

/-!
# Target action of the Gidney descending carry sweep

After the ascending ladder has computed carry bits, the source sweep processes
workspace indices from high to low.  For each j it performs exactly one target
update

`CX(a_j -> x_{j+2})`

and then uncomputes `a_j`.  Higher sweep layers do not alter `a_j` or
`x_{j+2}` before that update, and lower layers do not target `x_{j+2}` after it.

Consequently the complete descending sweep toggles each high target bit exactly
by the workspace bit present at the start of the sweep.  This theorem is valid
for arbitrary workspace contents; the clean carry semantics are substituted in
a later layer.
-/

namespace QuantumBlockEncoding
namespace GidneyZeroedDescendingAction

open BinaryCarryTelescoping
open GidneyZeroedSourceProgram
open GidneyZeroedWorkspaceRestoration
open ReversibleProgramSupport

/-- A descending sweep over indices starting at `start` cannot write workspace
wires below `start`. -/
theorem descendingSweep_preserves_lower_workspace
    (carryCount start count : Nat)
    (bound : start + count ≤ carryCount)
    (workspace : Fin carryCount)
    (lower : workspace.val < start) :
    PreservesWire
      (descendingSweepProgramFrom carryCount start count bound)
      (workspaceWire carryCount workspace) := by
  induction count generalizing start with
  | zero =>
      simp [PreservesWire, descendingSweepProgramFrom]
  | succ count induction =>
      let j : Fin carryCount := ⟨start, by omega⟩
      have innerPreserves :
          PreservesWire
            (descendingSweepProgramFrom carryCount (start + 1) count (by omega))
            (workspaceWire carryCount workspace) := by
        apply induction (start := start + 1)
        omega
      have consumePreserves :
          PreservesWire [consumeCarryGate carryCount j]
            (workspaceWire carryCount workspace) :=
        preservesWire_singleton_of_not_target _ _
          (consumeCarryGate_not_targets_workspace carryCount j workspace)
      have different : j ≠ workspace := by
        intro equal
        have values := congrArg Fin.val equal
        change start = workspace.val at values
        omega
      have computePreserves :
          PreservesWire [computeCarryGate carryCount j]
            (workspaceWire carryCount workspace) :=
        preservesWire_singleton_of_not_target _ _
          (computeCarryGate_not_targets_other_workspace
            carryCount j workspace different)
      simpa [descendingSweepProgramFrom, consumeAndUncomputePair,
        List.append_assoc] using
        preservesWire_append
          (descendingSweepProgramFrom carryCount (start + 1) count (by omega))
          ([consumeCarryGate carryCount j] ++ [computeCarryGate carryCount j])
          (workspaceWire carryCount workspace)
          innerPreserves
          (preservesWire_append _ _ _ consumePreserves computePreserves)

/-- A descending sweep over indices starting at `start` cannot write target
bits below `start+2`. -/
theorem descendingSweep_preserves_low_target
    (carryCount start count : Nat)
    (bound : start + count ≤ carryCount)
    (target : Fin (targetWidth carryCount))
    (low : target.val < start + 2) :
    PreservesWire
      (descendingSweepProgramFrom carryCount start count bound)
      (targetWire carryCount target) := by
  induction count generalizing start with
  | zero =>
      simp [PreservesWire, descendingSweepProgramFrom]
  | succ count induction =>
      let j : Fin carryCount := ⟨start, by omega⟩
      have innerPreserves :
          PreservesWire
            (descendingSweepProgramFrom carryCount (start + 1) count (by omega))
            (targetWire carryCount target) := by
        apply induction (start := start + 1)
        omega
      have consumePreserves :
          PreservesWire [consumeCarryGate carryCount j]
            (targetWire carryCount target) := by
        apply preservesWire_singleton_of_not_target
        apply consumeCarryGate_not_targets_other_target
        omega
      have computePreserves :
          PreservesWire [computeCarryGate carryCount j]
            (targetWire carryCount target) :=
        preservesWire_singleton_of_not_target _ _
          (computeCarryGate_not_targets_target carryCount j target)
      simpa [descendingSweepProgramFrom, consumeAndUncomputePair,
        List.append_assoc] using
        preservesWire_append
          (descendingSweepProgramFrom carryCount (start + 1) count (by omega))
          ([consumeCarryGate carryCount j] ++ [computeCarryGate carryCount j])
          (targetWire carryCount target)
          innerPreserves
          (preservesWire_append _ _ _ consumePreserves computePreserves)

/-- One carry-consumption gate implements `applyCarry` on its target bit. -/
theorem consumeCarryGate_target_action
    (carryCount : Nat) (j : Fin carryCount)
    (state : PrimitiveBasis (flatWidth carryCount)) :
    evalReversibleGate (consumeCarryGate carryCount j) state
        (targetWire carryCount
          ⟨j.val + 2, by unfold targetWidth; omega⟩) =
      applyCarry (state (workspaceWire carryCount j))
        (state (targetWire carryCount
          ⟨j.val + 2, by unfold targetWidth; omega⟩)) := by
  rcases GidneyZeroedCarryCompute.fin2_cases
      (state (workspaceWire carryCount j)) with controlZero | controlOne
  · simp [consumeCarryGate, evalReversibleGate, cxBasisEquiv,
      cxBasisAction, applyCarry, controlZero]
  · simp [consumeCarryGate, evalReversibleGate, cxBasisEquiv,
      cxBasisAction, xBasisAction, applyCarry, controlOne]

/-- Main arbitrary-state target theorem.  For every workspace index in the
sweep range, the corresponding high target bit is toggled exactly by the
workspace value that existed at the beginning of the sweep. -/
theorem descendingSweep_target_action
    (carryCount start count : Nat)
    (bound : start + count ≤ carryCount)
    (state : PrimitiveBasis (flatWidth carryCount))
    (workspace : Fin carryCount)
    (inRangeLow : start ≤ workspace.val)
    (inRangeHigh : workspace.val < start + count) :
    evalReversibleProgram
        (descendingSweepProgramFrom carryCount start count bound)
        state
        (targetWire carryCount
          ⟨workspace.val + 2, by unfold targetWidth; omega⟩) =
      applyCarry (state (workspaceWire carryCount workspace))
        (state (targetWire carryCount
          ⟨workspace.val + 2, by unfold targetWidth; omega⟩)) := by
  induction count generalizing start state with
  | zero =>
      omega
  | succ count induction =>
      let j : Fin carryCount := ⟨start, by omega⟩
      rw [show descendingSweepProgramFrom carryCount start (count + 1) bound =
          descendingSweepProgramFrom carryCount (start + 1) count (by omega) ++
            consumeAndUncomputePair carryCount j by
        simp [descendingSweepProgramFrom, j]]
      rw [evalReversibleProgram_append]
      simp only [Equiv.trans_apply]
      by_cases current : workspace.val = start
      · have workspaceEq : workspace = j := by
          apply Fin.ext
          simpa [j] using current
        subst workspace
        let higher :=
          descendingSweepProgramFrom carryCount (start + 1) count (by omega)
        let afterHigher := evalReversibleProgram higher state
        have workspacePreserved :
            afterHigher (workspaceWire carryCount j) =
              state (workspaceWire carryCount j) := by
          exact evalReversibleProgram_apply_of_preservesWire
            higher (workspaceWire carryCount j) state
            (by
              simpa [higher, j] using
                descendingSweep_preserves_lower_workspace
                  carryCount (start + 1) count (by omega) j (by simp [j]))
        have targetPreserved :
            afterHigher
                (targetWire carryCount
                  ⟨j.val + 2, by unfold targetWidth; omega⟩) =
              state
                (targetWire carryCount
                  ⟨j.val + 2, by unfold targetWidth; omega⟩) := by
          exact evalReversibleProgram_apply_of_preservesWire
            higher
            (targetWire carryCount
              ⟨j.val + 2, by unfold targetWidth; omega⟩)
            state
            (by
              simpa [higher, j] using
                descendingSweep_preserves_low_target
                  carryCount (start + 1) count (by omega)
                  ⟨j.val + 2, by unfold targetWidth; omega⟩ (by simp [j]))
        unfold consumeAndUncomputePair
        simp only [evalReversibleProgram, Equiv.trans_apply]
        have consumeAction := consumeCarryGate_target_action
          carryCount j afterHigher
        have computeDoesNotWriteTarget :=
          evalReversibleGate_apply_of_not_targets
            (computeCarryGate carryCount j)
            (targetWire carryCount
              ⟨j.val + 2, by unfold targetWidth; omega⟩)
            (evalReversibleGate (consumeCarryGate carryCount j) afterHigher)
            (computeCarryGate_not_targets_target carryCount j _)
        rw [computeDoesNotWriteTarget, consumeAction,
          workspacePreserved, targetPreserved]
      · have nextLow : start + 1 ≤ workspace.val := by omega
        have nextHigh : workspace.val < (start + 1) + count := by omega
        let afterHigher :=
          evalReversibleProgram
            (descendingSweepProgramFrom carryCount (start + 1) count (by omega))
            state
        have innerAction := induction
          (start := start + 1) (state := state)
          (bound := by omega) nextLow nextHigh
        have pairPreservesTarget :
            PreservesWire (consumeAndUncomputePair carryCount j)
              (targetWire carryCount
                ⟨workspace.val + 2, by unfold targetWidth; omega⟩) := by
          have consumePreserves :
              PreservesWire [consumeCarryGate carryCount j]
                (targetWire carryCount
                  ⟨workspace.val + 2, by unfold targetWidth; omega⟩) := by
            apply preservesWire_singleton_of_not_target
            apply consumeCarryGate_not_targets_other_target
            omega
          have computePreserves :
              PreservesWire [computeCarryGate carryCount j]
                (targetWire carryCount
                  ⟨workspace.val + 2, by unfold targetWidth; omega⟩) :=
            preservesWire_singleton_of_not_target _ _
              (computeCarryGate_not_targets_target carryCount j _)
          simpa [consumeAndUncomputePair] using
            preservesWire_append
              [consumeCarryGate carryCount j]
              [computeCarryGate carryCount j]
              (targetWire carryCount
                ⟨workspace.val + 2, by unfold targetWidth; omega⟩)
              consumePreserves computePreserves
        have pairPreservesWorkspace :
            PreservesWire (consumeAndUncomputePair carryCount j)
              (workspaceWire carryCount workspace) := by
          have different : j ≠ workspace := by
            intro equal
            have values := congrArg Fin.val equal
            apply current
            simpa [j] using values.symm
          have consumePreserves :
              PreservesWire [consumeCarryGate carryCount j]
                (workspaceWire carryCount workspace) :=
            preservesWire_singleton_of_not_target _ _
              (consumeCarryGate_not_targets_workspace carryCount j workspace)
          have computePreserves :
              PreservesWire [computeCarryGate carryCount j]
                (workspaceWire carryCount workspace) :=
            preservesWire_singleton_of_not_target _ _
              (computeCarryGate_not_targets_other_workspace
                carryCount j workspace different)
          simpa [consumeAndUncomputePair] using
            preservesWire_append
              [consumeCarryGate carryCount j]
              [computeCarryGate carryCount j]
              (workspaceWire carryCount workspace)
              consumePreserves computePreserves
        calc
          evalReversibleProgram (consumeAndUncomputePair carryCount j)
              afterHigher
              (targetWire carryCount
                ⟨workspace.val + 2, by unfold targetWidth; omega⟩) =
            afterHigher
              (targetWire carryCount
                ⟨workspace.val + 2, by unfold targetWidth; omega⟩) :=
              evalReversibleProgram_apply_of_preservesWire
                (consumeAndUncomputePair carryCount j)
                (targetWire carryCount
                  ⟨workspace.val + 2, by unfold targetWidth; omega⟩)
                afterHigher pairPreservesTarget
          _ = applyCarry (state (workspaceWire carryCount workspace))
              (state (targetWire carryCount
                ⟨workspace.val + 2, by unfold targetWidth; omega⟩)) :=
              innerAction

/-- Full-sweep specialization. -/
theorem fullDescendingSweep_target_action
    (carryCount : Nat)
    (state : PrimitiveBasis (flatWidth carryCount))
    (workspace : Fin carryCount) :
    evalReversibleProgram (descendingSweepProgram carryCount) state
        (targetWire carryCount
          ⟨workspace.val + 2, by unfold targetWidth; omega⟩) =
      applyCarry (state (workspaceWire carryCount workspace))
        (state (targetWire carryCount
          ⟨workspace.val + 2, by unfold targetWidth; omega⟩)) := by
  unfold descendingSweepProgram
  exact descendingSweep_target_action
    carryCount 0 carryCount (by omega) state workspace
    (by omega) workspace.isLt

end GidneyZeroedDescendingAction
end QuantumBlockEncoding