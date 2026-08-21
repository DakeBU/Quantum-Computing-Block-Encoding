import QuantumBlockEncoding.ReversibleCommutation
import QuantumBlockEncoding.ReversibleSchedule
import Mathlib.Tactic

/-!
# Layerwise merging of disjoint reversible schedules

Two source subcircuits on disjoint physical registers may run in parallel.  The
proof IR represents a schedule as a list of valid layers, so the canonical
parallel composition zips the layer lists, appending the two disjoint layers at
each time step and keeping the remainder of the longer schedule.

The resulting proof-bearing schedule has:

* gate count equal to the sum;
* depth equal to the maximum;
* semantics equal to executing the left and right schedules sequentially.

The semantic statement uses the exact commutation theorem for disjoint programs,
not an informal scheduling argument.
-/

namespace QuantumBlockEncoding
namespace ReversibleParallelSchedule

open ReversibleCommutation

/-- Every gate in the left schedule is wire-disjoint from every gate in the
right schedule. -/
def SchedulesWireDisjoint {q : Nat}
    (left right : ReversibleSchedule q) : Prop :=
  ∀ leftLayer ∈ left, ∀ rightLayer ∈ right,
    ∀ leftGate ∈ leftLayer, ∀ rightGate ∈ rightLayer,
      ReversibleGate.WireDisjoint leftGate rightGate

/-- Layerwise zip/append. -/
def mergeLayers {q : Nat} :
    ReversibleSchedule q -> ReversibleSchedule q -> ReversibleSchedule q
  | [], right => right
  | left, [] => left
  | leftLayer :: leftRest, rightLayer :: rightRest =>
      (leftLayer ++ rightLayer) :: mergeLayers leftRest rightRest

/-- Length of the merged schedule is the maximum of the two depths. -/
@[simp] theorem mergeLayers_length
    {q : Nat} (left right : ReversibleSchedule q) :
    (mergeLayers left right).length = max left.length right.length := by
  induction left generalizing right with
  | nil => simp [mergeLayers]
  | cons leftLayer leftRest induction =>
      cases right with
      | nil => simp [mergeLayers]
      | cons rightLayer rightRest =>
          simp [mergeLayers, induction, Nat.succ_max_succ]

/-- Flattened gate count is additive. -/
theorem mergeLayers_program_length
    {q : Nat} (left right : ReversibleSchedule q) :
    (mergeLayers left right).program.length =
      left.program.length + right.program.length := by
  induction left generalizing right with
  | nil => simp [mergeLayers, ReversibleSchedule.program]
  | cons leftLayer leftRest induction =>
      cases right with
      | nil => simp [mergeLayers, ReversibleSchedule.program]
      | cons rightLayer rightRest =>
          simp [mergeLayers, ReversibleSchedule.program, induction,
            List.length_append, Nat.add_assoc, Nat.add_left_comm,
            Nat.add_comm]

/-- Cross-disjointness descends to schedule tails. -/
theorem tails_disjoint
    {q : Nat} {leftLayer rightLayer : ReversibleLayer q}
    {leftRest rightRest : ReversibleSchedule q}
    (disjoint : SchedulesWireDisjoint
      (leftLayer :: leftRest) (rightLayer :: rightRest)) :
    SchedulesWireDisjoint leftRest rightRest := by
  intro ll llm rr rrm lg lgm rg rgm
  exact disjoint ll (by simp [llm]) rr (by simp [rrm]) lg lgm rg rgm

/-- One pair of current layers is cross-disjoint. -/
theorem current_layers_disjoint
    {q : Nat} {leftLayer rightLayer : ReversibleLayer q}
    {leftRest rightRest : ReversibleSchedule q}
    (disjoint : SchedulesWireDisjoint
      (leftLayer :: leftRest) (rightLayer :: rightRest)) :
    ∀ leftGate ∈ leftLayer, ∀ rightGate ∈ rightLayer,
      ReversibleGate.WireDisjoint leftGate rightGate := by
  intro lg lgm rg rgm
  exact disjoint leftLayer (by simp) rightLayer (by simp) lg lgm rg rgm

/-- Appending two valid cross-disjoint layers is valid. -/
theorem valid_append_layer
    {q : Nat} (left right : ReversibleLayer q)
    (leftValid : ReversibleLayer.Valid left)
    (rightValid : ReversibleLayer.Valid right)
    (cross : ∀ leftGate ∈ left, ∀ rightGate ∈ right,
      ReversibleGate.WireDisjoint leftGate rightGate) :
    ReversibleLayer.Valid (left ++ right) := by
  unfold ReversibleLayer.Valid at *
  rw [List.pairwise_append]
  exact ⟨leftValid,rightValid,cross⟩

/-- Validity of two schedules plus global cross-disjointness implies validity of
the merged schedule. -/
theorem mergeLayers_valid
    {q : Nat} (left right : ReversibleSchedule q)
    (leftValid : left.Valid)
    (rightValid : right.Valid)
    (disjoint : SchedulesWireDisjoint left right) :
    (mergeLayers left right).Valid := by
  induction left generalizing right with
  | nil => simpa [mergeLayers] using rightValid
  | cons leftLayer leftRest induction =>
      cases right with
      | nil => simpa [mergeLayers] using leftValid
      | cons rightLayer rightRest =>
          intro layer member
          simp [mergeLayers] at member
          rcases member with rfl | member
          · apply valid_append_layer leftLayer rightLayer
            · exact leftValid leftLayer (by simp)
            · exact rightValid rightLayer (by simp)
            · exact current_layers_disjoint disjoint
          · have leftTailValid : leftRest.Valid := by
              intro l lm
              exact leftValid l (by simp [lm])
            have rightTailValid : rightRest.Valid := by
              intro r rm
              exact rightValid r (by simp [rm])
            exact induction rightRest leftTailValid rightTailValid
              (tails_disjoint disjoint) layer member

/-- Cross-disjoint schedules flatten to cross-disjoint programs. -/
theorem programs_disjoint_of_schedules
    {q : Nat} (left right : ReversibleSchedule q)
    (disjoint : SchedulesWireDisjoint left right) :
    ProgramsWireDisjoint left.program right.program := by
  intro leftGate leftMember rightGate rightMember
  simp only [ReversibleSchedule.program, List.mem_flatten] at leftMember rightMember
  rcases leftMember with ⟨leftLayer,leftLayerMem,leftGateMem⟩
  rcases rightMember with ⟨rightLayer,rightLayerMem,rightGateMem⟩
  exact disjoint leftLayer leftLayerMem rightLayer rightLayerMem
    leftGate leftGateMem rightGate rightGateMem

/-- Semantic content of the merged schedule. -/
theorem eval_mergeLayers
    {q : Nat} (left right : ReversibleSchedule q)
    (disjoint : SchedulesWireDisjoint left right) :
    evalReversibleProgram (mergeLayers left right).program =
      (evalReversibleProgram left.program).trans
        (evalReversibleProgram right.program) := by
  induction left generalizing right with
  | nil => rfl
  | cons leftLayer leftRest induction =>
      cases right with
      | nil =>
          apply Equiv.ext
          intro state
          rfl
      | cons rightLayer rightRest =>
          have tailDisjoint := tails_disjoint disjoint
          have ih := induction rightRest tailDisjoint
          have rightHead_leftTail :
              ProgramsWireDisjoint rightLayer leftRest.program := by
            intro rg rgm lg lgm
            simp only [ReversibleSchedule.program, List.mem_flatten] at lgm
            rcases lgm with ⟨ll,llm,lgm⟩
            exact ReversibleGate.wireDisjoint_symm
              (disjoint ll (by simp [llm]) rightLayer (by simp) lg lgm rg rgm)
          change
            evalReversibleProgram
              ((leftLayer ++ rightLayer) ++
                (mergeLayers leftRest rightRest).program) = _
          rw [evalReversibleProgram_append,
            evalReversibleProgram_append, ih]
          change
            ((evalReversibleProgram leftLayer).trans
              (evalReversibleProgram rightLayer)).trans
                ((evalReversibleProgram leftRest.program).trans
                  (evalReversibleProgram rightRest.program)) =
              ((evalReversibleProgram leftLayer).trans
                (evalReversibleProgram leftRest.program)).trans
                  ((evalReversibleProgram rightLayer).trans
                    (evalReversibleProgram rightRest.program))
          rw [Equiv.trans_assoc]
          rw [← Equiv.trans_assoc
            (evalReversibleProgram rightLayer)
            (evalReversibleProgram leftRest.program)
            (evalReversibleProgram rightRest.program)]
          rw [eval_programs_commute rightLayer leftRest.program rightHead_leftTail]
          rw [Equiv.trans_assoc, ← Equiv.trans_assoc]

/-- Proof-bearing parallel composition. -/
def parallel
    {q : Nat}
    (left right : ScheduledReversibleProgram q)
    (disjoint : SchedulesWireDisjoint left.layers right.layers) :
    ScheduledReversibleProgram q where
  layers := mergeLayers left.layers right.layers
  valid := mergeLayers_valid left.layers right.layers
    left.valid right.valid disjoint

@[simp] theorem parallel_gateCount
    {q : Nat} (left right : ScheduledReversibleProgram q)
    (disjoint : SchedulesWireDisjoint left.layers right.layers) :
    (parallel left right disjoint).gateCount = left.gateCount + right.gateCount := by
  unfold parallel ScheduledReversibleProgram.gateCount ReversibleSchedule.gateCount
  exact mergeLayers_program_length left.layers right.layers

@[simp] theorem parallel_depth
    {q : Nat} (left right : ScheduledReversibleProgram q)
    (disjoint : SchedulesWireDisjoint left.layers right.layers) :
    (parallel left right disjoint).depth = max left.depth right.depth := by
  simp [parallel, ScheduledReversibleProgram.depth, ReversibleSchedule.depth]

/-- Parallel schedule semantics equals sequential left-then-right execution. -/
theorem eval_parallel
    {q : Nat} (left right : ScheduledReversibleProgram q)
    (disjoint : SchedulesWireDisjoint left.layers right.layers) :
    evalReversibleProgram (parallel left right disjoint).program =
      (evalReversibleProgram left.program).trans
        (evalReversibleProgram right.program) :=
  eval_mergeLayers left.layers right.layers disjoint

end ReversibleParallelSchedule
end QuantumBlockEncoding
