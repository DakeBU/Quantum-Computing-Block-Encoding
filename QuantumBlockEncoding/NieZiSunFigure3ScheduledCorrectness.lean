import QuantumBlockEncoding.NieZiSunControlSplitAllOne
import QuantumBlockEncoding.NieZiSunFigure3ScheduledFamily
import QuantumBlockEncoding.PromiseGateOptimization
import QuantumBlockEncoding.VandaeleLemma1Contract
import Mathlib.Tactic

/-!
# Clean correctness of the proof-bearing low-depth Nie schedule

The parallel schedule has a different flattened gate order from the earlier
chronological proof list only inside pairs of physically disjoint child
registers.  `firstHalfScheduled_refines` already proves that its first half is
the same source `HalfComputation`.  This module closes the full scheduled
Figure-3 circuit and its one-clean-ancilla C^nX contract.
-/

namespace QuantumBlockEncoding
namespace NieZiSunFigure3ScheduledCorrectness

open NieZiSunFigure3FlatCoordinates
open NieZiSunFigure3Protocol
open NieZiSunFigure3RecursiveFamily
open NieZiSunFigure3Resource
open NieZiSunFigure3ReversibleProgram
open NieZiSunFigure3ScheduledFamily
open ReversibleScheduleReverse

/-- Scheduled Step 1 has the already-proved local source action. -/
theorem scheduled_step1_refines
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n)) :
    flatFigure3Coordinate n large
      (evalReversibleProgram (step1Scheduled n large).program state) =
      step1 (flatFigure3Coordinate n large state) := by
  simpa [step1Scheduled] using
    NieZiSunFigure3LocalStepRefinement.step1_refines n large state

/-- Scheduled Step 3 has the already-proved local source action. -/
theorem scheduled_step3_refines
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n)) :
    flatFigure3Coordinate n large
      (evalReversibleProgram (step3Scheduled n large).program state) =
      step3 (flatFigure3Coordinate n large state) := by
  simpa [step3Scheduled] using
    NieZiSunFigure3LocalStepRefinement.step3_refines n large state

/-- Inverse scheduled Step 2 realizes source Step 4. -/
theorem reverse_scheduled_step2_refines
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n)) :
    flatFigure3Coordinate n large
      (evalReversibleProgram
        (ReversibleScheduleReverse.reverse (step2Scheduled n large)).program state) =
      step4 (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n))
        (flatFigure3Coordinate n large state) := by
  let forwardEquiv := evalReversibleProgram (step2Scheduled n large).program
  let backward := evalReversibleProgram
    (ReversibleScheduleReverse.reverse (step2Scheduled n large)).program state
  have backwardEq : backward = forwardEquiv.symm state := by
    unfold backward forwardEquiv
    rw [ReversibleScheduleReverse.eval_reverse]
  have roundtrip : forwardEquiv backward = state := by
    rw [backwardEq]
    exact forwardEquiv.apply_symm_apply state
  have forward := step2Scheduled_refines n large
    (firstHalfScheduled_refines (leftTailWidth n))
    (firstHalfScheduled_refines (rightTailWidth n)) backward
  change flatFigure3Coordinate n large (forwardEquiv backward) = _ at forward
  rw [roundtrip] at forward
  have undo := NieZiSunFigure3FirstHalf.step4_step2
    (halfFamily (leftTailWidth n))
    (halfFamily (rightTailWidth n))
    (flatFigure3Coordinate n large backward)
  rw [← forward] at undo
  exact undo.symm

/-- Inverse scheduled Step 1 realizes Step 5. -/
theorem reverse_scheduled_step1_refines
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n)) :
    flatFigure3Coordinate n large
      (evalReversibleProgram
        (ReversibleScheduleReverse.reverse (step1Scheduled n large)).program state) =
      step5 (flatFigure3Coordinate n large state) := by
  let forwardEquiv := evalReversibleProgram (step1Scheduled n large).program
  let backward := evalReversibleProgram
    (ReversibleScheduleReverse.reverse (step1Scheduled n large)).program state
  have backwardEq : backward = forwardEquiv.symm state := by
    unfold backward forwardEquiv
    rw [ReversibleScheduleReverse.eval_reverse]
  have roundtrip : forwardEquiv backward = state := by
    rw [backwardEq]
    exact forwardEquiv.apply_symm_apply state
  have forward := scheduled_step1_refines n large backward
  change flatFigure3Coordinate n large (forwardEquiv backward) = _ at forward
  rw [roundtrip] at forward
  have undo := (@NieZiSunFigure3FirstHalf.step1_involutive
    (leftTailWidth n) (rightTailWidth n))
    (flatFigure3Coordinate n large backward)
  rw [← forward] at undo
  exact undo.symm

/-- Full non-base low-depth schedule refines the same five-step source protocol. -/
theorem fullScheduled_refines_protocol
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n)) :
    flatFigure3Coordinate n large
      (evalReversibleProgram (fullScheduled n).program state) =
      protocol
        (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n))
        (flatFigure3Coordinate n large state) := by
  let s1 := step1Scheduled n large
  let s2 := step2Scheduled n large
  let s3 := step3Scheduled n large
  let after1 := evalReversibleProgram s1.program state
  let after2 := evalReversibleProgram s2.program after1
  let after3 := evalReversibleProgram s3.program after2
  let after4 := evalReversibleProgram
    (ReversibleScheduleReverse.reverse s2).program after3
  have h1 := scheduled_step1_refines n large state
  have h2 := step2Scheduled_refines n large
    (firstHalfScheduled_refines (leftTailWidth n))
    (firstHalfScheduled_refines (rightTailWidth n)) after1
  have h3 := scheduled_step3_refines n large after2
  have h4 := reverse_scheduled_step2_refines n large after3
  have h5 := reverse_scheduled_step1_refines n large after4
  simp [fullScheduled, large, ScheduledReversibleProgram.eval_seq]
  change flatFigure3Coordinate n large
    (evalReversibleProgram (ReversibleScheduleReverse.reverse s1).program after4) = _
  calc
    _ = step5 (flatFigure3Coordinate n large after4) := h5
    _ = step5 (step4 (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n))
        (flatFigure3Coordinate n large after3)) := by rw [h4]
    _ = step5 (step4 (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n))
        (step3 (flatFigure3Coordinate n large after2))) := by rw [h3]
    _ = step5 (step4 (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n))
        (step3 (step2 (halfFamily (leftTailWidth n))
          (halfFamily (rightTailWidth n))
          (flatFigure3Coordinate n large after1)))) := by rw [h2]
    _ = step5 (step4 (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n))
        (step3 (step2 (halfFamily (leftTailWidth n))
          (halfFamily (rightTailWidth n))
          (step1 (flatFigure3Coordinate n large state))))) := by rw [h1]
    _ = protocol (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n))
        (flatFigure3Coordinate n large state) := rfl

/-- Clean-ancilla action of the scheduled family. -/
theorem fullScheduled_clean_action
    (n : Nat) (controls : PrimitiveBasis n) (target : Fin 2) :
    let input := (flatProductCoordinate n).symm (controls,0,target)
    let output := evalReversibleProgram (fullScheduled n).program input
    flatProductCoordinate n output =
      if allOne controls then (controls,0,flipBit target)
      else (controls,0,target) := by
  dsimp
  by_cases large : 5 <= n
  · let input := (flatProductCoordinate n).symm (controls,0,target)
    have refinement := fullScheduled_refines_protocol n large input
    let parts := NieZiSunControlSplit.splitControls n (by omega) controls
    have source := protocol_correct
      (halfFamily (leftTailWidth n))
      (halfFamily (rightTailWidth n))
      parts.1 parts.2.1 parts.2.2 target
    have activation := NieZiSunControlSplitAllOne.allOne_split_iff
      (n := n) (by omega) controls
    have inputCoord : flatFigure3Coordinate n large input =
        (parts.1,parts.2.1,parts.2.2,0,target) := by
      simp [input, flatFigure3Coordinate, flatProductCoordinate,
        fullCoordinate, parts]
    rw [inputCoord] at refinement
    rw [refinement]
    apply (fullCoordinate n (by omega)).injective
    simpa [fullActive, activation, flatFigure3Coordinate,
      flatProductCoordinate, fullCoordinate, parts] using source
  · have small : n < 5 := by omega
    have half := NieZiSunFigure3GateCorrectness.smallFirstHalf_refines
      (n := n) small
    have input := (flatProductCoordinate n).symm (controls,0,target)
    have source := half input
    rw [Equiv.apply_symm_apply] at source
    simpa [fullScheduled, large, smallScheduled,
      NieZiSunFigure3RecursiveFamily.directHalf,
      NieZiSunFigure3RecursiveFamily.directHalfAction] using source

/-- Actual proof-bearing one-clean implementation as a weak promise gate. -/
theorem scheduled_cleanAncilla_multiControlledX
    (n : Nat) :
    PromiseGateOptimization.WeakPromiseSpec
      (0 : Fin 2)
      (((flatProductCoordinate n).symm.trans
        (evalReversibleProgram (fullScheduled n).program)).trans
          (flatProductCoordinate n))
      (VandaeleLemma1Contract.multiControlledXEquiv n) := by
  intro state
  rcases state with ⟨controls,target⟩
  have source := fullScheduled_clean_action n controls target
  by_cases active : allOne controls
  · have sourceActive : VandaeleLemma1Contract.allControlsOne controls := active
    simpa [active, VandaeleLemma1Contract.multiControlledXEquiv,
      VandaeleLemma1Contract.multiControlledXAction, sourceActive] using source
  · have sourceInactive : ¬ VandaeleLemma1Contract.allControlsOne controls := by
      intro all
      exact active all
    simpa [active, VandaeleLemma1Contract.multiControlledXEquiv,
      VandaeleLemma1Contract.multiControlledXAction, sourceInactive] using source

end NieZiSunFigure3ScheduledCorrectness
end QuantumBlockEncoding
