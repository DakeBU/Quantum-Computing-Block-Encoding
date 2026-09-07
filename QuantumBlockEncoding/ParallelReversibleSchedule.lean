import QuantumBlockEncoding.ReversibleSchedule
import Mathlib.Tactic

/-!
# Parallel composition of reversible schedules

The recursive constructions used by comparator/incrementer and by the
Nie/Vandaele multi-controlled-X proof need a resource statement stronger than
"two calls happen in parallel".  The two recursive schedules must be tied to
one proof-bearing layer schedule, with wire non-overlap justifying each merged
layer.

This module provides that resource-level combinator.  Given two valid schedules
whose gates are pairwise wire-disjoint *across* the two schedules, it merges
corresponding layers.  The resulting schedule has exactly the sum of the gate
counts and the maximum of the two depths.

This file intentionally proves only schedule validity and resource accounting.
The semantic theorem that disjoint gates commute, and hence that the interleaved
parallel schedule has the same basis action as either sequential ordering, is a
separate downstream obligation.  Keeping those facts separate prevents a depth
certificate from silently assuming semantic commutativity.
-/

namespace QuantumBlockEncoding

namespace ReversibleLayer

/-- Every gate in `left` is wire-disjoint from every gate in `right`. -/
def CrossWireDisjoint {qubits : Nat}
    (left right : ReversibleLayer qubits) : Prop :=
  ∀ leftGate ∈ left, ∀ rightGate ∈ right,
    ReversibleGate.WireDisjoint leftGate rightGate

/-- Cross-disjointness is symmetric. -/
theorem crossWireDisjoint_symm {qubits : Nat}
    {left right : ReversibleLayer qubits}
    (cross : CrossWireDisjoint left right) :
    CrossWireDisjoint right left := by
  intro rightGate rightMember leftGate leftMember
  exact ReversibleGate.wireDisjoint_symm
    (cross leftGate leftMember rightGate rightMember)

/-- Appending two internally valid, cross-disjoint layers gives one valid
parallel layer. -/
theorem valid_append {qubits : Nat}
    {left right : ReversibleLayer qubits}
    (leftValid : Valid left)
    (rightValid : Valid right)
    (cross : CrossWireDisjoint left right) :
    Valid (left ++ right) := by
  unfold Valid at leftValid rightValid ⊢
  induction left with
  | nil =>
      simpa using rightValid
  | cons gate rest induction =>
      rw [List.pairwise_cons] at leftValid
      rcases leftValid with ⟨gateRest, restValid⟩
      apply List.Pairwise.cons
      · intro other member
        rcases List.mem_append.mp member with member | member
        · exact gateRest other member
        · exact cross gate (by simp) other member
      · apply induction restValid
        intro leftGate leftMember rightGate rightMember
        exact cross leftGate
          (List.mem_cons_of_mem gate leftMember)
          rightGate rightMember

end ReversibleLayer

namespace ReversibleSchedule

/-- Every gate from every layer of `left` is wire-disjoint from every gate from
every layer of `right`.  This deliberately strong schedule-level condition is
easy to establish for recursive calls embedded into disjoint wire images. -/
def CrossWireDisjoint {qubits : Nat}
    (left right : ReversibleSchedule qubits) : Prop :=
  ∀ leftLayer ∈ left, ∀ rightLayer ∈ right,
    ReversibleLayer.CrossWireDisjoint leftLayer rightLayer

/-- Schedule-level cross-disjointness is symmetric. -/
theorem crossWireDisjoint_symm {qubits : Nat}
    {left right : ReversibleSchedule qubits}
    (cross : CrossWireDisjoint left right) :
    CrossWireDisjoint right left := by
  intro rightLayer rightMember leftLayer leftMember
  exact ReversibleLayer.crossWireDisjoint_symm
    (cross leftLayer leftMember rightLayer rightMember)

/-- Merge corresponding layers, keeping the remaining suffix of the longer
schedule unchanged. -/
def parallelLayers {qubits : Nat} :
    ReversibleSchedule qubits → ReversibleSchedule qubits →
      ReversibleSchedule qubits
  | [], right => right
  | left, [] => left
  | leftHead :: leftTail, rightHead :: rightTail =>
      (leftHead ++ rightHead) :: parallelLayers leftTail rightTail

/-- Parallel layer merging preserves schedule validity under the explicit
cross-wire-disjointness certificate. -/
theorem parallelLayers_valid {qubits : Nat}
    {left right : ReversibleSchedule qubits}
    (leftValid : left.Valid)
    (rightValid : right.Valid)
    (cross : CrossWireDisjoint left right) :
    (parallelLayers left right).Valid := by
  induction left generalizing right with
  | nil =>
      simpa [parallelLayers] using rightValid
  | cons leftHead leftTail induction =>
      cases right with
      | nil =>
          simpa [parallelLayers] using leftValid
      | cons rightHead rightTail =>
          intro layer member
          simp only [parallelLayers, List.mem_cons] at member
          rcases member with rfl | member
          · exact ReversibleLayer.valid_append
              (leftValid leftHead (by simp))
              (rightValid rightHead (by simp))
              (cross leftHead (by simp) rightHead (by simp))
          · apply induction
            · intro tailLayer tailMember
              exact leftValid tailLayer
                (List.mem_cons_of_mem leftHead tailMember)
            · intro tailLayer tailMember
              exact rightValid tailLayer
                (List.mem_cons_of_mem rightHead tailMember)
            · intro leftLayer leftMember rightLayer rightMember
              exact cross leftLayer
                (List.mem_cons_of_mem leftHead leftMember)
                rightLayer
                (List.mem_cons_of_mem rightHead rightMember)
            · exact member

/-- The merged schedule has the maximum, not the sum, of the two depths. -/
@[simp] theorem parallelLayers_length {qubits : Nat}
    (left right : ReversibleSchedule qubits) :
    (parallelLayers left right).length = max left.length right.length := by
  induction left generalizing right with
  | nil => simp [parallelLayers]
  | cons leftHead leftTail induction =>
      cases right with
      | nil => simp [parallelLayers]
      | cons rightHead rightTail =>
          simp [parallelLayers, induction, Nat.succ_max_succ]

/-- Flattened logical gate count is additive under parallel layer merging. -/
theorem parallelLayers_program_length {qubits : Nat}
    (left right : ReversibleSchedule qubits) :
    (parallelLayers left right).program.length =
      left.program.length + right.program.length := by
  induction left generalizing right with
  | nil =>
      simp [parallelLayers, program]
  | cons leftHead leftTail induction =>
      cases right with
      | nil =>
          simp [parallelLayers, program]
      | cons rightHead rightTail =>
          have tail :
              (List.map List.length (parallelLayers leftTail rightTail)).sum =
                (List.map List.length leftTail).sum +
                  (List.map List.length rightTail).sum := by
            simpa [program] using induction rightTail
          simp [parallelLayers, program, tail,
            Nat.add_assoc, Nat.add_left_comm, Nat.add_comm]

end ReversibleSchedule

namespace ScheduledReversibleProgram

/-- Proof-bearing parallel composition.  The resulting `program` is the
chronological flattening of the merged layers; no semantic reordering theorem
is smuggled into this constructor. -/
def parallel {qubits : Nat}
    (left right : ScheduledReversibleProgram qubits)
    (cross : ReversibleSchedule.CrossWireDisjoint left.layers right.layers) :
    ScheduledReversibleProgram qubits where
  layers := ReversibleSchedule.parallelLayers left.layers right.layers
  valid := ReversibleSchedule.parallelLayers_valid left.valid right.valid cross

/-- Exact logical gate count of parallel composition. -/
@[simp] theorem parallel_gateCount {qubits : Nat}
    (left right : ScheduledReversibleProgram qubits)
    (cross : ReversibleSchedule.CrossWireDisjoint left.layers right.layers) :
    (parallel left right cross).gateCount = left.gateCount + right.gateCount := by
  unfold parallel gateCount ReversibleSchedule.gateCount
  exact ReversibleSchedule.parallelLayers_program_length left.layers right.layers

/-- Certified depth of parallel composition is exactly the maximum of the two
input depths. -/
@[simp] theorem parallel_depth {qubits : Nat}
    (left right : ScheduledReversibleProgram qubits)
    (cross : ReversibleSchedule.CrossWireDisjoint left.layers right.layers) :
    (parallel left right cross).depth = max left.depth right.depth := by
  unfold parallel depth ReversibleSchedule.depth
  exact ReversibleSchedule.parallelLayers_length left.layers right.layers

end ScheduledReversibleProgram

end QuantumBlockEncoding
