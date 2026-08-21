import QuantumBlockEncoding.ReversibleProgramInverse
import QuantumBlockEncoding.ReversibleSchedule
import Mathlib.Tactic

/-!
# Reversing a proof-bearing reversible schedule

Every gate in the reversible IR is self-inverse.  The inverse of a scheduled
circuit is therefore obtained by reversing the layer order and reversing the
gate order inside each layer.  The latter does not alter parallel validity but
makes flattening definitionally agree with reversing the complete gate list.

Gate count and certified depth are preserved exactly.
-/

namespace QuantumBlockEncoding
namespace ReversibleScheduleReverse

open ReversibleProgramInverse

/-- Reverse one parallel layer. -/
def reverseLayer {q : Nat} (layer : ReversibleLayer q) : ReversibleLayer q :=
  layer.reverse

/-- Pairwise wire-disjointness is invariant under list reversal. -/
theorem reverseLayer_valid
    {q : Nat} (layer : ReversibleLayer q)
    (valid : ReversibleLayer.Valid layer) :
    ReversibleLayer.Valid (reverseLayer layer) := by
  unfold reverseLayer ReversibleLayer.Valid
  exact valid.reverse

/-- Reverse chronological layers and the internal gate order of every layer. -/
def reverseSchedule {q : Nat}
    (schedule : ReversibleSchedule q) : ReversibleSchedule q :=
  schedule.reverse.map reverseLayer

/-- Reversed schedule remains valid. -/
theorem reverseSchedule_valid
    {q : Nat} (schedule : ReversibleSchedule q)
    (valid : schedule.Valid) :
    (reverseSchedule schedule).Valid := by
  intro layer member
  simp [reverseSchedule] at member
  rcases member with ⟨source,sourceMember,rfl⟩
  exact reverseLayer_valid source (valid source (by simpa using sourceMember))

/-- Flattening the inverse schedule gives exact gate-list reversal. -/
theorem reverseSchedule_program
    {q : Nat} (schedule : ReversibleSchedule q) :
    (reverseSchedule schedule).program = schedule.program.reverse := by
  induction schedule with
  | nil => rfl
  | cons layer rest induction =>
      simp [reverseSchedule, reverseLayer, ReversibleSchedule.program,
        List.flatten_reverse, induction, List.reverse_append]

/-- Proof-bearing inverse schedule. -/
def reverse
    {q : Nat} (scheduled : ScheduledReversibleProgram q) :
    ScheduledReversibleProgram q where
  layers := reverseSchedule scheduled.layers
  valid := reverseSchedule_valid scheduled.layers scheduled.valid

@[simp] theorem reverse_program
    {q : Nat} (scheduled : ScheduledReversibleProgram q) :
    (reverse scheduled).program = scheduled.program.reverse := by
  exact reverseSchedule_program scheduled.layers

@[simp] theorem reverse_gateCount
    {q : Nat} (scheduled : ScheduledReversibleProgram q) :
    (reverse scheduled).gateCount = scheduled.gateCount := by
  unfold ScheduledReversibleProgram.gateCount ReversibleSchedule.gateCount
  rw [reverse_program, List.length_reverse]

@[simp] theorem reverse_depth
    {q : Nat} (scheduled : ScheduledReversibleProgram q) :
    (reverse scheduled).depth = scheduled.depth := by
  simp [reverse, reverseSchedule,
    ScheduledReversibleProgram.depth, ReversibleSchedule.depth]

/-- Semantic inverse. -/
theorem eval_reverse
    {q : Nat} (scheduled : ScheduledReversibleProgram q) :
    evalReversibleProgram (reverse scheduled).program =
      (evalReversibleProgram scheduled.program).symm := by
  rw [reverse_program]
  exact evalReversibleProgram_reverse scheduled.program

end ReversibleScheduleReverse
end QuantumBlockEncoding
