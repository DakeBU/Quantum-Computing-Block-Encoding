import QuantumBlockEncoding.ParallelReversibleSchedule
import QuantumBlockEncoding.ReversibleDisjointCommutation
import Mathlib.Tactic

/-!
# Semantic correctness of parallel reversible schedules

`ParallelReversibleSchedule` proves the resource statement needed by the
Nie/Vandaele recursion: two cross-disjoint schedules can share time slices, so
gate count adds while depth takes a maximum.  This module closes the separate
semantic obligation.

The proof has three layers:

1. one gate commutes through a whole cross-disjoint reversible program;
2. two cross-disjoint programs commute exactly on every basis state;
3. the layer-wise merged schedule therefore has the same basis action as
   executing the complete left schedule followed by the complete right schedule.

Thus the low-depth schedule and the semantic circuit are the same proof-bearing
object; no numeric depth annotation is detached from correctness.
-/

namespace QuantumBlockEncoding

namespace ReversibleProgram

/-- Every gate of `left` is wire-disjoint from every gate of `right`. -/
def CrossWireDisjoint {qubits : Nat}
    (left right : ReversibleProgram qubits) : Prop :=
  ∀ leftGate ∈ left, ∀ rightGate ∈ right,
    ReversibleGate.WireDisjoint leftGate rightGate

/-- Program-level cross-disjointness is symmetric. -/
theorem crossWireDisjoint_symm {qubits : Nat}
    {left right : ReversibleProgram qubits}
    (cross : CrossWireDisjoint left right) :
    CrossWireDisjoint right left := by
  intro rightGate rightMember leftGate leftMember
  exact ReversibleGate.wireDisjoint_symm
    (cross leftGate leftMember rightGate rightMember)

end ReversibleProgram

/-- A gate commutes through an entire program when it is wire-disjoint from
all gates of that program. -/
theorem evalReversibleGate_commute_program_of_crossWireDisjoint
    {qubits : Nat}
    (gate : ReversibleGate qubits)
    (program : ReversibleProgram qubits)
    (cross : ∀ other ∈ program,
      ReversibleGate.WireDisjoint gate other)
    (state : PrimitiveBasis qubits) :
    evalReversibleProgram program (evalReversibleGate gate state) =
      evalReversibleGate gate (evalReversibleProgram program state) := by
  revert cross state
  induction program with
  | nil =>
      intro _ state
      rfl
  | cons head tail induction =>
      intro cross state
      have headCross : ReversibleGate.WireDisjoint gate head :=
        cross head (by simp)
      have tailCross : ∀ other ∈ tail,
          ReversibleGate.WireDisjoint gate other := by
        intro other member
        exact cross other (List.mem_cons_of_mem head member)
      change
        evalReversibleProgram tail
            (evalReversibleGate head (evalReversibleGate gate state)) =
          evalReversibleGate gate
            (evalReversibleProgram tail (evalReversibleGate head state))
      rw [← evalReversibleGate_commute_of_wireDisjoint headCross state]
      exact induction tailCross (evalReversibleGate head state)

/-- Two cross-disjoint reversible programs commute exactly on every
computational-basis state. -/
theorem evalReversibleProgram_commute_of_crossWireDisjoint
    {qubits : Nat}
    (left right : ReversibleProgram qubits)
    (cross : ReversibleProgram.CrossWireDisjoint left right)
    (state : PrimitiveBasis qubits) :
    evalReversibleProgram right (evalReversibleProgram left state) =
      evalReversibleProgram left (evalReversibleProgram right state) := by
  revert cross state
  induction left with
  | nil =>
      intro _ state
      rfl
  | cons gate rest induction =>
      intro cross state
      have gateCross : ∀ other ∈ right,
          ReversibleGate.WireDisjoint gate other := by
        intro other member
        exact cross gate (by simp) other member
      have restCross : ReversibleProgram.CrossWireDisjoint rest right := by
        intro leftGate leftMember rightGate rightMember
        exact cross leftGate
          (List.mem_cons_of_mem gate leftMember)
          rightGate rightMember
      change
        evalReversibleProgram right
            (evalReversibleProgram rest (evalReversibleGate gate state)) =
          evalReversibleProgram rest
            (evalReversibleGate gate (evalReversibleProgram right state))
      calc
        _ = evalReversibleProgram rest
              (evalReversibleProgram right
                (evalReversibleGate gate state)) :=
          induction restCross (evalReversibleGate gate state)
        _ = evalReversibleProgram rest
              (evalReversibleGate gate
                (evalReversibleProgram right state)) := by
          rw [evalReversibleGate_commute_program_of_crossWireDisjoint
            gate right gateCross state]

namespace ReversibleSchedule

/-- Membership in the authoritative flattened schedule program is exactly
membership in one of its layers.  Keeping this as an explicit helper avoids
fragile `List.flatten` elaboration in downstream schedule proofs. -/
theorem mem_program_iff {qubits : Nat}
    {gate : ReversibleGate qubits}
    {schedule : ReversibleSchedule qubits} :
    gate ∈ ReversibleSchedule.program schedule ↔
      ∃ layer ∈ schedule, gate ∈ layer := by
  induction schedule with
  | nil =>
      simp [ReversibleSchedule.program]
  | cons head tail induction =>
      simp [ReversibleSchedule.program, induction]

/-- Strong schedule cross-disjointness implies cross-disjointness of the exact
flattened programs used by the evaluator. -/
theorem programs_crossWireDisjoint {qubits : Nat}
    {left right : ReversibleSchedule qubits}
    (cross : CrossWireDisjoint left right) :
    ReversibleProgram.CrossWireDisjoint
      (ReversibleSchedule.program left)
      (ReversibleSchedule.program right) := by
  intro leftGate leftMember rightGate rightMember
  rcases mem_program_iff.mp leftMember with
    ⟨leftLayer, leftLayerMember, leftGateMember⟩
  rcases mem_program_iff.mp rightMember with
    ⟨rightLayer, rightLayerMember, rightGateMember⟩
  exact cross leftLayer leftLayerMember rightLayer rightLayerMember
    leftGate leftGateMember rightGate rightGateMember

/-- Basis-state semantics of the merged schedule.  Its interleaving is exactly
semantically equal to complete-left then complete-right execution. -/
theorem eval_parallelLayers_apply {qubits : Nat}
    (left right : ReversibleSchedule qubits)
    (cross : CrossWireDisjoint left right)
    (state : PrimitiveBasis qubits) :
    evalReversibleProgram
        (ReversibleSchedule.program (parallelLayers left right)) state =
      evalReversibleProgram (ReversibleSchedule.program right)
        (evalReversibleProgram (ReversibleSchedule.program left) state) := by
  revert right cross state
  induction left with
  | nil =>
      intro right _ state
      rfl
  | cons leftHead leftTail induction =>
      intro right cross state
      cases right with
      | nil =>
          rfl
      | cons rightHead rightTail =>
          have tailCross : CrossWireDisjoint leftTail rightTail := by
            intro leftLayer leftMember rightLayer rightMember
            exact cross leftLayer
              (List.mem_cons_of_mem leftHead leftMember)
              rightLayer
              (List.mem_cons_of_mem rightHead rightMember)
          have rightHeadLeftTailCross :
              ReversibleProgram.CrossWireDisjoint rightHead
                (ReversibleSchedule.program leftTail) := by
            intro rightGate rightGateMember leftGate leftGateMember
            rcases mem_program_iff.mp leftGateMember with
              ⟨leftLayer, leftLayerMember, leftGateMember⟩
            exact ReversibleGate.wireDisjoint_symm
              (cross leftLayer
                (List.mem_cons_of_mem leftHead leftLayerMember)
                rightHead (by simp)
                leftGate leftGateMember rightGate rightGateMember)
          have parallelProgram :
              ReversibleSchedule.program
                (parallelLayers
                  (leftHead :: leftTail)
                  (rightHead :: rightTail)) =
                (leftHead ++ rightHead) ++
                  ReversibleSchedule.program
                    (parallelLayers leftTail rightTail) := by
            rfl
          calc
            evalReversibleProgram
                (ReversibleSchedule.program
                  (parallelLayers
                    (leftHead :: leftTail)
                    (rightHead :: rightTail))) state =
              evalReversibleProgram
                (ReversibleSchedule.program
                  (parallelLayers leftTail rightTail))
                (evalReversibleProgram (leftHead ++ rightHead) state) := by
              rw [parallelProgram, evalReversibleProgram_append]
              rfl
            _ = evalReversibleProgram
                (ReversibleSchedule.program rightTail)
                (evalReversibleProgram
                  (ReversibleSchedule.program leftTail)
                  (evalReversibleProgram (leftHead ++ rightHead) state)) :=
              induction rightTail tailCross
                (evalReversibleProgram (leftHead ++ rightHead) state)
            _ = evalReversibleProgram
                (ReversibleSchedule.program rightTail)
                (evalReversibleProgram rightHead
                  (evalReversibleProgram
                    (ReversibleSchedule.program leftTail)
                    (evalReversibleProgram leftHead state))) := by
              rw [evalReversibleProgram_append]
              exact congrArg
                (fun next =>
                  evalReversibleProgram
                    (ReversibleSchedule.program rightTail) next)
                (evalReversibleProgram_commute_of_crossWireDisjoint
                  rightHead (ReversibleSchedule.program leftTail)
                  rightHeadLeftTailCross
                  (evalReversibleProgram leftHead state))
            _ = evalReversibleProgram
                (ReversibleSchedule.program (rightHead :: rightTail))
                (evalReversibleProgram
                  (ReversibleSchedule.program (leftHead :: leftTail)) state) := by
              change
                evalReversibleProgram (ReversibleSchedule.program rightTail)
                    (evalReversibleProgram rightHead
                      (evalReversibleProgram
                        (ReversibleSchedule.program leftTail)
                        (evalReversibleProgram leftHead state))) =
                  evalReversibleProgram
                    (rightHead ++ ReversibleSchedule.program rightTail)
                    (evalReversibleProgram
                      (leftHead ++ ReversibleSchedule.program leftTail) state)
              rw [evalReversibleProgram_append, evalReversibleProgram_append]
              rfl

/-- Equivalence-level form of `eval_parallelLayers_apply`. -/
theorem eval_parallelLayers {qubits : Nat}
    (left right : ReversibleSchedule qubits)
    (cross : CrossWireDisjoint left right) :
    evalReversibleProgram
        (ReversibleSchedule.program (parallelLayers left right)) =
      (evalReversibleProgram (ReversibleSchedule.program left)).trans
        (evalReversibleProgram (ReversibleSchedule.program right)) := by
  apply Equiv.ext
  intro state
  exact eval_parallelLayers_apply left right cross state

end ReversibleSchedule

namespace ScheduledReversibleProgram

/-- Semantic certificate for the proof-bearing parallel constructor. -/
theorem eval_parallel {qubits : Nat}
    (left right : ScheduledReversibleProgram qubits)
    (cross : ReversibleSchedule.CrossWireDisjoint left.layers right.layers) :
    evalReversibleProgram (parallel left right cross).program =
      (evalReversibleProgram left.program).trans
        (evalReversibleProgram right.program) := by
  exact ReversibleSchedule.eval_parallelLayers left.layers right.layers cross

/-- Parallel execution has exactly the same basis semantics as the existing
sequential composition, while retaining the smaller certified depth. -/
theorem eval_parallel_eq_seq {qubits : Nat}
    (left right : ScheduledReversibleProgram qubits)
    (cross : ReversibleSchedule.CrossWireDisjoint left.layers right.layers) :
    evalReversibleProgram (parallel left right cross).program =
      evalReversibleProgram (seq left right).program := by
  rw [eval_parallel left right cross, eval_seq left right]

end ScheduledReversibleProgram

end QuantumBlockEncoding
