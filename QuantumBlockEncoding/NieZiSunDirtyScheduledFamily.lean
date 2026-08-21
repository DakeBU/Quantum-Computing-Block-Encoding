import QuantumBlockEncoding.NieZiSunDirtyProtocol
import QuantumBlockEncoding.NieZiSunFigure3ScheduledCorrectness
import QuantumBlockEncoding.NieZiSunFigure3ScheduledFamily
import QuantumBlockEncoding.ReversibleScheduleReverse
import Mathlib.Tactic

/-!
# Proof-bearing one-dirty Nie--Zi--Sun schedule

For n>=5 the source Corollary-3 schedule is

`M ; S1 ; M ; S5`, where `M = S2 ; S3 ; S4` and `S4=S2^{-1}`.

The exact same proof-bearing Step-1/2/3 schedules from the clean construction
are reused.  For n<=4 the fixed direct X/CX/CCX/C^3X/C^4X programs already
restore their workspace for arbitrary incoming contents, so no special dirty
wrapper is needed.
-/

namespace QuantumBlockEncoding
namespace NieZiSunDirtyScheduledFamily

open NieZiSunDirtyProtocol
open NieZiSunFigure3FlatCoordinates
open NieZiSunFigure3Protocol
open NieZiSunFigure3RecursiveFamily
open NieZiSunFigure3Resource
open NieZiSunFigure3ReversibleProgram
open NieZiSunFigure3ScheduledCorrectness
open NieZiSunFigure3ScheduledFamily
open ReversibleScheduleReverse

/-- Scheduled source middle `S2 ; S3 ; S4`. -/
def middleScheduled (n : Nat) (large : 5 <= n) :
    ScheduledReversibleProgram (totalWidth n) :=
  let s2 := step2Scheduled n large
  ScheduledReversibleProgram.seq s2
    (ScheduledReversibleProgram.seq (step3Scheduled n large)
      (ReversibleScheduleReverse.reverse s2))

/-- Gate-level middle refines the source semantic middle. -/
theorem middleScheduled_refines
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n)) :
    flatFigure3Coordinate n large
      (evalReversibleProgram (middleScheduled n large).program state) =
      middle
        (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n))
        (flatFigure3Coordinate n large state) := by
  let s2 := step2Scheduled n large
  let after2 := evalReversibleProgram s2.program state
  let after3 := evalReversibleProgram (step3Scheduled n large).program after2
  have h2 := step2Scheduled_refines n large
    (firstHalfScheduled_refines (leftTailWidth n))
    (firstHalfScheduled_refines (rightTailWidth n)) state
  have h3 := scheduled_step3_refines n large after2
  have h4 := reverse_scheduled_step2_refines n large after3
  simp [middleScheduled, ScheduledReversibleProgram.eval_seq]
  change flatFigure3Coordinate n large
    (evalReversibleProgram (ReversibleScheduleReverse.reverse s2).program after3) = _
  calc
    _ = step4 (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n))
        (flatFigure3Coordinate n large after3) := h4
    _ = step4 (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n))
        (step3 (flatFigure3Coordinate n large after2)) := by rw [h3]
    _ = step4 (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n))
        (step3 (step2 (halfFamily (leftTailWidth n))
          (halfFamily (rightTailWidth n))
          (flatFigure3Coordinate n large state))) := by rw [h2]
    _ = middle (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n))
        (flatFigure3Coordinate n large state) := rfl

/-- Complete one-dirty schedule. -/
def dirtyScheduled (n : Nat) : ScheduledReversibleProgram (totalWidth n) :=
  if large : 5 <= n then
    let middle := middleScheduled n large
    let s1 := step1Scheduled n large
    ScheduledReversibleProgram.seq middle
      (ScheduledReversibleProgram.seq s1
        (ScheduledReversibleProgram.seq middle
          (ReversibleScheduleReverse.reverse s1)))
  else smallScheduled n

/-- Non-base dirty schedule refines the source Corollary-3 dirty protocol. -/
theorem dirtyScheduled_refines_protocol
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n)) :
    flatFigure3Coordinate n large
      (evalReversibleProgram (dirtyScheduled n).program state) =
      dirtyProtocol
        (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n))
        (flatFigure3Coordinate n large state) := by
  let middle := middleScheduled n large
  let s1 := step1Scheduled n large
  let afterM1 := evalReversibleProgram middle.program state
  let afterS1 := evalReversibleProgram s1.program afterM1
  let afterM2 := evalReversibleProgram middle.program afterS1
  have hM1 := middleScheduled_refines n large state
  have hS1 := scheduled_step1_refines n large afterM1
  have hM2 := middleScheduled_refines n large afterS1
  have hS5 := reverse_scheduled_step1_refines n large afterM2
  simp [dirtyScheduled, large, ScheduledReversibleProgram.eval_seq]
  change flatFigure3Coordinate n large
    (evalReversibleProgram (ReversibleScheduleReverse.reverse s1).program afterM2) = _
  calc
    _ = step5 (flatFigure3Coordinate n large afterM2) := hS5
    _ = step5 (middle (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n))
        (flatFigure3Coordinate n large afterS1)) := by rw [hM2]
    _ = step5 (middle (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n))
        (step1 (flatFigure3Coordinate n large afterM1))) := by rw [hS1]
    _ = step5 (middle (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n))
        (step1 (middle (halfFamily (leftTailWidth n))
          (halfFamily (rightTailWidth n))
          (flatFigure3Coordinate n large state)))) := by rw [hM1]
    _ = dirtyProtocol (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n))
        (flatFigure3Coordinate n large state) := rfl

/-- Actual dirty schedule: A may start arbitrarily and is restored, while T is
toggled iff all n controls are one. -/
theorem dirtyScheduled_action
    (n : Nat) (controls : PrimitiveBasis n)
    (dirty target : Fin 2) :
    let input := (flatProductCoordinate n).symm (controls,dirty,target)
    let output := evalReversibleProgram (dirtyScheduled n).program input
    flatProductCoordinate n output =
      if NieZiSunFigure3Protocol.allOne controls then
        (controls,dirty,flipBit target)
      else (controls,dirty,target) := by
  dsimp
  by_cases large : 5 <= n
  · let input := (flatProductCoordinate n).symm (controls,dirty,target)
    have refinement := dirtyScheduled_refines_protocol n large input
    let parts := NieZiSunControlSplit.splitControls n (by omega) controls
    have source := dirtyProtocol_correct
      (halfFamily (leftTailWidth n))
      (halfFamily (rightTailWidth n))
      parts.1 parts.2.1 parts.2.2 dirty target
    have activation := NieZiSunControlSplitAllOne.allOne_split_iff
      (n := n) (by omega) controls
    have inputCoord : flatFigure3Coordinate n large input =
        (parts.1,parts.2.1,parts.2.2,dirty,target) := by
      simp [input, flatFigure3Coordinate, flatProductCoordinate,
        fullCoordinate, parts]
    rw [inputCoord] at refinement
    rw [refinement]
    apply (fullCoordinate n (by omega)).injective
    simpa [NieZiSunFigure3Protocol.fullActive, activation,
      flatFigure3Coordinate, flatProductCoordinate, fullCoordinate, parts]
      using source
  · have small : n < 5 := by omega
    have refinement := NieZiSunFigure3GateCorrectness.smallFirstHalf_refines
      (n := n) small
    let input := (flatProductCoordinate n).symm (controls,dirty,target)
    have source := refinement input
    rw [Equiv.apply_symm_apply] at source
    simpa [dirtyScheduled, large, smallScheduled,
      NieZiSunFigure3RecursiveFamily.directHalf,
      NieZiSunFigure3RecursiveFamily.directHalfAction] using source

end NieZiSunDirtyScheduledFamily
end QuantumBlockEncoding
