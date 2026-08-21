import QuantumBlockEncoding.NieZiSunFigure3GateCorrectness
import QuantumBlockEncoding.NieZiSunFigure3FullGateCorrectness
import QuantumBlockEncoding.ReversibleParallelSchedule
import QuantumBlockEncoding.ReversibleScheduleReverse
import QuantumBlockEncoding.ScheduledDisjointEmbedding
import QuantumBlockEncoding.ScheduledWireEmbedding
import Mathlib.Tactic

/-!
# Proof-bearing low-depth schedule for the actual Nie--Zi--Sun gate family

The actual `{X,CX,CCX}` gate list and its semantics are already formalized.
This module gives the recursive *parallel* schedule required for logarithmic
depth.  The two child first-halves are embedded into disjoint physical registers
and zipped layer-by-layer, so their depth is the maximum rather than the sum.

All resource functions are read from the same scheduled objects used by the
semantic proof.
-/

namespace QuantumBlockEncoding
namespace NieZiSunFigure3ScheduledFamily

open NieZiSunFigure3ChildRefinement
open NieZiSunFigure3FlatCoordinates
open NieZiSunFigure3GateCorrectness
open NieZiSunFigure3LocalStepRefinement
open NieZiSunFigure3Protocol
open NieZiSunFigure3RecursiveFamily
open NieZiSunFigure3Resource
open NieZiSunFigure3ReversibleProgram
open ReversibleParallelSchedule
open ReversibleScheduleReverse
open ScheduledDisjointEmbedding
open ScheduledWireEmbedding

/-- Step 1 as a conservative constant-depth schedule. -/
def step1Scheduled (n : Nat) (large : 5 <= n) :
    ScheduledReversibleProgram (totalWidth n) :=
  ScheduledReversibleProgram.sequential (step1Program n large)

/-- The four head X gates form one valid parallel layer. -/
def headXScheduled (n : Nat) (large : 5 <= n) :
    ScheduledReversibleProgram (totalWidth n) where
  layers := [headXProgram n large]
  valid := by
    intro layer member
    simp at member
    subst layer
    simp [headXProgram, ReversibleLayer.Valid,
      ReversibleGate.WireDisjoint, ReversibleGate.touches]

@[simp] theorem headXScheduled_program
    (n : Nat) (large : 5 <= n) :
    (headXScheduled n large).program = headXProgram n large := by
  rfl

@[simp] theorem headXScheduled_gateCount
    (n : Nat) (large : 5 <= n) :
    (headXScheduled n large).gateCount = 4 := by
  rfl

@[simp] theorem headXScheduled_depth
    (n : Nat) (large : 5 <= n) :
    (headXScheduled n large).depth = 1 := by
  rfl

/-- Step 3 as a conservative constant-depth schedule. -/
def step3Scheduled (n : Nat) (large : 5 <= n) :
    ScheduledReversibleProgram (totalWidth n) :=
  ScheduledReversibleProgram.sequential (step3Program n large)

/-- Base schedules. -/
def smallScheduled (n : Nat) :
    ScheduledReversibleProgram (totalWidth n) :=
  ScheduledReversibleProgram.sequential (smallFirstHalf n)

/-- Recursive scheduled first half. -/
def firstHalfScheduled : (n : Nat) -> ScheduledReversibleProgram (totalWidth n)
  | 0 => smallScheduled 0
  | 1 => smallScheduled 1
  | 2 => smallScheduled 2
  | 3 => smallScheduled 3
  | 4 => smallScheduled 4
  | m + 5 =>
      let n := m + 5
      let large : 5 <= n := by omega
      let leftLocal := firstHalfScheduled (leftTailWidth n)
      let rightLocal := firstHalfScheduled (rightTailWidth n)
      let leftMapped := mapScheduledWires
        (leftEmbed n large) (leftEmbed_injective n large) leftLocal
      let rightMapped := mapScheduledWires
        (rightEmbed n large) (rightEmbed_injective n large) rightLocal
      let cross := mapped_schedules_disjoint
        (leftEmbed n large) (leftEmbed_injective n large)
        (rightEmbed n large) (rightEmbed_injective n large)
        (NieZiSunFigure3FlatCoordinates.childEmbeddings_disjoint n large)
        leftLocal rightLocal
      let children := parallel leftMapped rightMapped cross
      ScheduledReversibleProgram.seq (step1Scheduled n large)
        (ScheduledReversibleProgram.seq (headXScheduled n large)
          (ScheduledReversibleProgram.seq children (step3Scheduled n large)))
termination_by n => n

decreasing_by
  all_goals
    unfold leftTailWidth rightTailWidth
    omega

/-- Mapped child schedules used at one non-base level. -/
def leftChildScheduled
    (n : Nat) (large : 5 <= n) :
    ScheduledReversibleProgram (totalWidth n) :=
  mapScheduledWires (leftEmbed n large) (leftEmbed_injective n large)
    (firstHalfScheduled (leftTailWidth n))

def rightChildScheduled
    (n : Nat) (large : 5 <= n) :
    ScheduledReversibleProgram (totalWidth n) :=
  mapScheduledWires (rightEmbed n large) (rightEmbed_injective n large)
    (firstHalfScheduled (rightTailWidth n))

/-- Their schedules are cross-disjoint. -/
theorem childSchedules_disjoint
    (n : Nat) (large : 5 <= n) :
    SchedulesWireDisjoint
      (leftChildScheduled n large).layers
      (rightChildScheduled n large).layers := by
  exact mapped_schedules_disjoint
    (leftEmbed n large) (leftEmbed_injective n large)
    (rightEmbed n large) (rightEmbed_injective n large)
    (NieZiSunFigure3FlatCoordinates.childEmbeddings_disjoint n large)
    (firstHalfScheduled (leftTailWidth n))
    (firstHalfScheduled (rightTailWidth n))

/-- Parallel child stage. -/
def childrenScheduled
    (n : Nat) (large : 5 <= n) :
    ScheduledReversibleProgram (totalWidth n) :=
  parallel (leftChildScheduled n large) (rightChildScheduled n large)
    (childSchedules_disjoint n large)

/-- Complete scheduled Step 2. -/
def step2Scheduled
    (n : Nat) (large : 5 <= n) :
    ScheduledReversibleProgram (totalWidth n) :=
  ScheduledReversibleProgram.seq (headXScheduled n large)
    (childrenScheduled n large)

/-- Semantic Step-2 refinement of the scheduled parallel children. -/
theorem step2Scheduled_refines
    (n : Nat) (large : 5 <= n)
    (leftCorrect : ChildRefines (leftTailWidth n)
      (firstHalfScheduled (leftTailWidth n)).program
      (halfFamily (leftTailWidth n)))
    (rightCorrect : ChildRefines (rightTailWidth n)
      (firstHalfScheduled (rightTailWidth n)).program
      (halfFamily (rightTailWidth n)))
    (state : PrimitiveBasis (totalWidth n)) :
    flatFigure3Coordinate n large
      (evalReversibleProgram (step2Scheduled n large).program state) =
      step2 (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n))
        (flatFigure3Coordinate n large state) := by
  have parallelSem := eval_parallel
    (leftChildScheduled n large) (rightChildScheduled n large)
    (childSchedules_disjoint n large)
  have sequentialSource := actualStep2_refines
    n large
    (firstHalfScheduled (leftTailWidth n)).program
    (firstHalfScheduled (rightTailWidth n)).program
    (halfFamily (leftTailWidth n))
    (halfFamily (rightTailWidth n))
    leftCorrect rightCorrect state
  have step2Sem :
      evalReversibleProgram (step2Scheduled n large).program =
        evalReversibleProgram
          (actualStep2Program n large
            (firstHalfScheduled (leftTailWidth n)).program
            (firstHalfScheduled (rightTailWidth n)).program) := by
    rw [ScheduledReversibleProgram.eval_seq]
    rw [parallelSem]
    simp [leftChildScheduled, rightChildScheduled,
      mapScheduledWires_program, headXScheduled_program,
      actualStep2Program, evalReversibleProgram_append]
  rw [step2Sem]
  exact sequentialSource

/-- The recursive scheduled first half refines exactly the same semantic family
as the chronological gate list. -/
theorem firstHalfScheduled_refines :
    (n : Nat) -> ChildRefines n (firstHalfScheduled n).program (halfFamily n)
  | 0 => by
      simpa [firstHalfScheduled, smallScheduled] using
        (smallFirstHalf_refines (n := 0) (by omega))
  | 1 => by
      simpa [firstHalfScheduled, smallScheduled] using
        (smallFirstHalf_refines (n := 1) (by omega))
  | 2 => by
      simpa [firstHalfScheduled, smallScheduled] using
        (smallFirstHalf_refines (n := 2) (by omega))
  | 3 => by
      simpa [firstHalfScheduled, smallScheduled] using
        (smallFirstHalf_refines (n := 3) (by omega))
  | 4 => by
      simpa [firstHalfScheduled, smallScheduled] using
        (smallFirstHalf_refines (n := 4) (by omega))
  | m + 5 => by
      let n := m + 5
      let large : 5 <= n := by omega
      have leftCorrect := firstHalfScheduled_refines (leftTailWidth n)
      have rightCorrect := firstHalfScheduled_refines (rightTailWidth n)
      intro state
      let after1 := evalReversibleProgram (step1Scheduled n large).program state
      let after2 := evalReversibleProgram (step2Scheduled n large).program after1
      have h1 : flatFigure3Coordinate n large after1 =
          step1 (flatFigure3Coordinate n large state) := by
        simpa [after1, step1Scheduled] using step1_refines n large state
      have h2 := step2Scheduled_refines n large leftCorrect rightCorrect after1
      have h3 : flatFigure3Coordinate n large
          (evalReversibleProgram (step3Scheduled n large).program after2) =
          step3 (flatFigure3Coordinate n large after2) := by
        simpa [step3Scheduled] using step3_refines n large after2
      have figureCorrect :
          flatFigure3Coordinate n large
            (evalReversibleProgram (firstHalfScheduled n).program state) =
          NieZiSunFigure3FirstHalf.firstHalfEquiv
            (halfFamily (leftTailWidth n))
            (halfFamily (rightTailWidth n))
            (flatFigure3Coordinate n large state) := by
        simp [n, firstHalfScheduled, ScheduledReversibleProgram.eval_seq]
        change flatFigure3Coordinate n large
          (evalReversibleProgram (step3Scheduled n large).program after2) = _
        calc
          _ = step3 (flatFigure3Coordinate n large after2) := h3
          _ = step3 (step2 (halfFamily (leftTailWidth n))
              (halfFamily (rightTailWidth n))
              (flatFigure3Coordinate n large after1)) := by rw [h2]
          _ = step3 (step2 (halfFamily (leftTailWidth n))
              (halfFamily (rightTailWidth n))
              (step1 (flatFigure3Coordinate n large state))) := by rw [h1]
          _ = NieZiSunFigure3FirstHalf.firstHalfEquiv
              (halfFamily (leftTailWidth n))
              (halfFamily (rightTailWidth n))
              (flatFigure3Coordinate n large state) := rfl
      apply (fullCoordinate n (by omega)).injective
      change flatFigure3Coordinate n large
        (evalReversibleProgram (firstHalfScheduled n).program state) = _
      simpa [n, halfFamily, NieZiSunFigure3FirstHalf.asHalfComputation,
        flatFigure3Coordinate, flatProductCoordinate] using figureCorrect
termination_by n => n

decreasing_by
  all_goals
    unfold leftTailWidth rightTailWidth
    omega

/-- First-half gate-count recurrence read from the actual schedule. -/
theorem firstHalfScheduled_gateCount_step
    {n : Nat} (large : 5 <= n) :
    (firstHalfScheduled n).gateCount =
      18 + (firstHalfScheduled (leftTailWidth n)).gateCount +
        (firstHalfScheduled (rightTailWidth n)).gateCount := by
  obtain ⟨m,rfl⟩ : ∃ m, n = m + 5 := ⟨n-5, by omega⟩
  simp [firstHalfScheduled, step1Scheduled, step3Scheduled,
    childrenScheduled, leftChildScheduled, rightChildScheduled,
    childSchedules_disjoint, ScheduledReversibleProgram.sequential_gateCount,
    parallel_gateCount, ScheduledReversibleProgram.seq_gateCount]
  omega

/-- First-half depth recurrence from the merged schedule. -/
theorem firstHalfScheduled_depth_step
    {n : Nat} (large : 5 <= n) :
    (firstHalfScheduled n).depth =
      15 + max (firstHalfScheduled (leftTailWidth n)).depth
        (firstHalfScheduled (rightTailWidth n)).depth := by
  obtain ⟨m,rfl⟩ : ∃ m, n = m + 5 := ⟨n-5, by omega⟩
  simp [firstHalfScheduled, step1Scheduled, step3Scheduled,
    childrenScheduled, leftChildScheduled, rightChildScheduled,
    childSchedules_disjoint, ScheduledReversibleProgram.sequential_depth,
    parallel_depth, ScheduledReversibleProgram.seq_depth]
  omega

/-- Complete low-depth scheduled Figure-3 circuit. -/
def fullScheduled (n : Nat) : ScheduledReversibleProgram (totalWidth n) :=
  if large : 5 <= n then
    let s1 := step1Scheduled n large
    let s2 := step2Scheduled n large
    let s3 := step3Scheduled n large
    ScheduledReversibleProgram.seq s1
      (ScheduledReversibleProgram.seq s2
        (ScheduledReversibleProgram.seq s3
          (ScheduledReversibleProgram.seq
            (ReversibleScheduleReverse.reverse s2)
            (ReversibleScheduleReverse.reverse s1))))
  else smallScheduled n

/-- Complete schedule gate-count recurrence. -/
theorem fullScheduled_gateCount_step
    {n : Nat} (large : 5 <= n) :
    (fullScheduled n).gateCount =
      32 + 2 * (firstHalfScheduled (leftTailWidth n)).gateCount +
        2 * (firstHalfScheduled (rightTailWidth n)).gateCount := by
  simp [fullScheduled, large, step1Scheduled, step2Scheduled,
    step3Scheduled, childrenScheduled, leftChildScheduled,
    rightChildScheduled, childSchedules_disjoint,
    ReversibleScheduleReverse.reverse_gateCount]
  omega

/-- Complete schedule depth recurrence. -/
theorem fullScheduled_depth_step
    {n : Nat} (large : 5 <= n) :
    (fullScheduled n).depth =
      26 + 2 * max (firstHalfScheduled (leftTailWidth n)).depth
        (firstHalfScheduled (rightTailWidth n)).depth := by
  simp [fullScheduled, large, step1Scheduled, step2Scheduled,
    step3Scheduled, childrenScheduled, leftChildScheduled,
    rightChildScheduled, childSchedules_disjoint,
    ReversibleScheduleReverse.reverse_depth]
  omega

end NieZiSunFigure3ScheduledFamily
end QuantumBlockEncoding
