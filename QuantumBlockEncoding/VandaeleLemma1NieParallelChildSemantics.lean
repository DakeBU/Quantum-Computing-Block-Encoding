import QuantumBlockEncoding.VandaeleLemma1NieRecursiveStep
import QuantumBlockEncoding.ReversibleEmbeddingNoninterference
import Mathlib.Tactic

/-!
# Logical-view semantics of the parallel Figure-3 children

The resource layer already proves that the two embedded child first-halves may
share time slices and that the merged schedule is semantically equal to their
sequential composition.  The recursive correctness proof needs a more local
API: what does each child *see* after that merged schedule?

This module proves that the left logical view is exactly the left child's own
`forwardHalf` action, and symmetrically for the right child.  It also proves
that neither child can touch the parent target `T` or the parent clean flag `A`.
Thus the correctness induction never needs to unfold `parallelLayers`.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma1NieParallelChildSemantics

open VandaeleLemma1ProgramFamily
open VandaeleLemma1NieLayout
open VandaeleLemma1NieRecursiveStep
open ReversibleWireEmbedding
open ScheduledWireEmbedding
open ReversibleEmbeddingDisjointness
open ReversibleEmbeddingNoninterference

private theorem four_le_of_five_le {k : Nat} (five_le : 5 ≤ k) : 4 ≤ k := by
  omega

/-- Every physical wire used by the left child is still a parent control wire,
so its numeric index is strictly below the parent target index `k`. -/
theorem leftChildEmbed_val_lt_k
    (k : Nat) (four_le : 4 ≤ k)
    (wire : Fin (lemmaOneFlatWidth (leftSize k))) :
    (leftChildEmbed k four_le wire).val < k := by
  by_cases control : wire.val < leftSize k
  · simp [leftChildEmbed, control]
    have partition := split_size k four_le
    omega
  · by_cases target : wire.val = leftSize k
    · simp [leftChildEmbed, control, target, controlWire]
    · simp [leftChildEmbed, control, target, controlWire]

/-- Symmetric physical-range fact for the right child. -/
theorem rightChildEmbed_val_lt_k
    (k : Nat) (four_le : 4 ≤ k)
    (wire : Fin (lemmaOneFlatWidth (rightSize k))) :
    (rightChildEmbed k four_le wire).val < k := by
  by_cases control : wire.val < rightSize k
  · simp [rightChildEmbed, control]
    have partition := split_size k four_le
    omega
  · by_cases target : wire.val = rightSize k
    · simp [rightChildEmbed, control, target, controlWire]
    · simp [rightChildEmbed, control, target, controlWire]

theorem leftChildEmbed_ne_parent_target
    (k : Nat) (four_le : 4 ≤ k)
    (wire : Fin (lemmaOneFlatWidth (leftSize k))) :
    leftChildEmbed k four_le wire ≠ targetWire k := by
  intro equal
  have values := congrArg Fin.val equal
  have below := leftChildEmbed_val_lt_k k four_le wire
  simp [targetWire] at values
  omega

theorem rightChildEmbed_ne_parent_target
    (k : Nat) (four_le : 4 ≤ k)
    (wire : Fin (lemmaOneFlatWidth (rightSize k))) :
    rightChildEmbed k four_le wire ≠ targetWire k := by
  intro equal
  have values := congrArg Fin.val equal
  have below := rightChildEmbed_val_lt_k k four_le wire
  simp [targetWire] at values
  omega

theorem leftChildEmbed_ne_parent_dirty
    (k : Nat) (four_le : 4 ≤ k)
    (wire : Fin (lemmaOneFlatWidth (leftSize k))) :
    leftChildEmbed k four_le wire ≠ dirtyWire k := by
  intro equal
  have values := congrArg Fin.val equal
  have below := leftChildEmbed_val_lt_k k four_le wire
  simp [dirtyWire] at values
  omega

theorem rightChildEmbed_ne_parent_dirty
    (k : Nat) (four_le : 4 ≤ k)
    (wire : Fin (lemmaOneFlatWidth (rightSize k))) :
    rightChildEmbed k four_le wire ≠ dirtyWire k := by
  intro equal
  have values := congrArg Fin.val equal
  have below := rightChildEmbed_val_lt_k k four_le wire
  simp [dirtyWire] at values
  omega

/-- One embedded left forward-half leaves the parent target untouched. -/
theorem leftForward_preserves_target {k : Nat} (five_le : 5 ≤ k)
    (left : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (leftSize k)))
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    evalReversibleProgram (leftForward five_le left).program state
        (targetWire k) = state (targetWire k) := by
  let four_le := four_le_of_five_le five_le
  rw [leftForward, mapScheduledWires_program]
  exact eval_mapProgramWires_outside
    (leftChildEmbed k four_le) (leftChildEmbed_injective k four_le)
    left.forwardHalf.program state (targetWire k)
    (fun logical => leftChildEmbed_ne_parent_target k four_le logical)

/-- One embedded right forward-half leaves the parent target untouched. -/
theorem rightForward_preserves_target {k : Nat} (five_le : 5 ≤ k)
    (right : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (rightSize k)))
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    evalReversibleProgram (rightForward five_le right).program state
        (targetWire k) = state (targetWire k) := by
  let four_le := four_le_of_five_le five_le
  rw [rightForward, mapScheduledWires_program]
  exact eval_mapProgramWires_outside
    (rightChildEmbed k four_le) (rightChildEmbed_injective k four_le)
    right.forwardHalf.program state (targetWire k)
    (fun logical => rightChildEmbed_ne_parent_target k four_le logical)

/-- The parent clean flag / final flat wire is also outside the left child. -/
theorem leftForward_preserves_dirty {k : Nat} (five_le : 5 ≤ k)
    (left : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (leftSize k)))
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    evalReversibleProgram (leftForward five_le left).program state
        (dirtyWire k) = state (dirtyWire k) := by
  let four_le := four_le_of_five_le five_le
  rw [leftForward, mapScheduledWires_program]
  exact eval_mapProgramWires_outside
    (leftChildEmbed k four_le) (leftChildEmbed_injective k four_le)
    left.forwardHalf.program state (dirtyWire k)
    (fun logical => leftChildEmbed_ne_parent_dirty k four_le logical)

/-- Symmetric flag preservation. -/
theorem rightForward_preserves_dirty {k : Nat} (five_le : 5 ≤ k)
    (right : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (rightSize k)))
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    evalReversibleProgram (rightForward five_le right).program state
        (dirtyWire k) = state (dirtyWire k) := by
  let four_le := four_le_of_five_le five_le
  rw [rightForward, mapScheduledWires_program]
  exact eval_mapProgramWires_outside
    (rightChildEmbed k four_le) (rightChildEmbed_injective k four_le)
    right.forwardHalf.program state (dirtyWire k)
    (fun logical => rightChildEmbed_ne_parent_dirty k four_le logical)

/-- The merged schedule presents exactly the left child's own logical output on
the left subregister. -/
theorem leftView_eval_parallelForward {k : Nat} (five_le : 5 ≤ k)
    (left : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (leftSize k)))
    (right : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (rightSize k)))
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    readEmbeddedState (leftChildEmbed k (four_le_of_five_le five_le))
        (evalReversibleProgram (parallelForward five_le left right).program state) =
      evalReversibleProgram left.forwardHalf.program
        (readEmbeddedState
          (leftChildEmbed k (four_le_of_five_le five_le)) state) := by
  let four_le := four_le_of_five_le five_le
  have parallelEq := congrArg
    (fun permutation : Equiv.Perm (PrimitiveBasis (lemmaOneFlatWidth k)) =>
      permutation state)
    (eval_parallelForward_eq_seq five_le left right)
  calc
    readEmbeddedState (leftChildEmbed k four_le)
        (evalReversibleProgram (parallelForward five_le left right).program state) =
      readEmbeddedState (leftChildEmbed k four_le)
        (evalReversibleProgram
          (ScheduledReversibleProgram.seq
            (leftForward five_le left) (rightForward five_le right)).program state) := by
        exact congrArg (readEmbeddedState (leftChildEmbed k four_le)) parallelEq
    _ = readEmbeddedState (leftChildEmbed k four_le)
        (evalReversibleProgram (rightForward five_le right).program
          (evalReversibleProgram (leftForward five_le left).program state)) := by
        rw [ScheduledReversibleProgram.eval_seq]
        rfl
    _ = readEmbeddedState (leftChildEmbed k four_le)
        (evalReversibleProgram (leftForward five_le left).program state) := by
        exact readEmbeddedState_eval_mapScheduledWires_other_symm
          (leftChildEmbed k four_le) (rightChildEmbed k four_le)
          (rightChildEmbed_injective k four_le)
          (childImagesDisjoint k four_le)
          right.forwardHalf
          (evalReversibleProgram (leftForward five_le left).program state)
    _ = evalReversibleProgram left.forwardHalf.program
        (readEmbeddedState (leftChildEmbed k four_le) state) := by
        exact readEmbeddedState_eval_mapScheduledWires
          (leftChildEmbed k four_le) (leftChildEmbed_injective k four_le)
          left.forwardHalf state

/-- Symmetric right logical-view theorem. -/
theorem rightView_eval_parallelForward {k : Nat} (five_le : 5 ≤ k)
    (left : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (leftSize k)))
    (right : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (rightSize k)))
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    readEmbeddedState (rightChildEmbed k (four_le_of_five_le five_le))
        (evalReversibleProgram (parallelForward five_le left right).program state) =
      evalReversibleProgram right.forwardHalf.program
        (readEmbeddedState
          (rightChildEmbed k (four_le_of_five_le five_le)) state) := by
  let four_le := four_le_of_five_le five_le
  have parallelEq := congrArg
    (fun permutation : Equiv.Perm (PrimitiveBasis (lemmaOneFlatWidth k)) =>
      permutation state)
    (eval_parallelForward_eq_seq five_le left right)
  calc
    readEmbeddedState (rightChildEmbed k four_le)
        (evalReversibleProgram (parallelForward five_le left right).program state) =
      readEmbeddedState (rightChildEmbed k four_le)
        (evalReversibleProgram
          (ScheduledReversibleProgram.seq
            (leftForward five_le left) (rightForward five_le right)).program state) := by
        exact congrArg (readEmbeddedState (rightChildEmbed k four_le)) parallelEq
    _ = readEmbeddedState (rightChildEmbed k four_le)
        (evalReversibleProgram (rightForward five_le right).program
          (evalReversibleProgram (leftForward five_le left).program state)) := by
        rw [ScheduledReversibleProgram.eval_seq]
        rfl
    _ = evalReversibleProgram right.forwardHalf.program
        (readEmbeddedState (rightChildEmbed k four_le)
          (evalReversibleProgram (leftForward five_le left).program state)) := by
        exact readEmbeddedState_eval_mapScheduledWires
          (rightChildEmbed k four_le) (rightChildEmbed_injective k four_le)
          right.forwardHalf
          (evalReversibleProgram (leftForward five_le left).program state)
    _ = evalReversibleProgram right.forwardHalf.program
        (readEmbeddedState (rightChildEmbed k four_le) state) := by
        have unchanged :
            readEmbeddedState (rightChildEmbed k four_le)
                (evalReversibleProgram (leftForward five_le left).program state) =
              readEmbeddedState (rightChildEmbed k four_le) state := by
          simpa [leftForward, four_le] using
            (readEmbeddedState_eval_mapScheduledWires_other
              (leftChildEmbed k four_le) (leftChildEmbed_injective k four_le)
              (rightChildEmbed k four_le) (childImagesDisjoint k four_le)
              left.forwardHalf state)
        rw [unchanged]

/-- The complete low-depth child merge leaves the parent target unchanged. -/
theorem parallelForward_preserves_target {k : Nat} (five_le : 5 ≤ k)
    (left : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (leftSize k)))
    (right : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (rightSize k)))
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    evalReversibleProgram (parallelForward five_le left right).program state
        (targetWire k) = state (targetWire k) := by
  have parallelEq := congrArg
    (fun permutation : Equiv.Perm (PrimitiveBasis (lemmaOneFlatWidth k)) =>
      permutation state)
    (eval_parallelForward_eq_seq five_le left right)
  calc
    evalReversibleProgram (parallelForward five_le left right).program state
        (targetWire k) =
      evalReversibleProgram
        (ScheduledReversibleProgram.seq
          (leftForward five_le left) (rightForward five_le right)).program state
        (targetWire k) := congrArg (fun s => s (targetWire k)) parallelEq
    _ = evalReversibleProgram (rightForward five_le right).program
        (evalReversibleProgram (leftForward five_le left).program state)
        (targetWire k) := by
      rw [ScheduledReversibleProgram.eval_seq]
      rfl
    _ = evalReversibleProgram (leftForward five_le left).program state
        (targetWire k) := rightForward_preserves_target five_le right _
    _ = state (targetWire k) := leftForward_preserves_target five_le left state

/-- The complete low-depth child merge likewise preserves the parent flag `A`. -/
theorem parallelForward_preserves_dirty {k : Nat} (five_le : 5 ≤ k)
    (left : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (leftSize k)))
    (right : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (rightSize k)))
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    evalReversibleProgram (parallelForward five_le left right).program state
        (dirtyWire k) = state (dirtyWire k) := by
  have parallelEq := congrArg
    (fun permutation : Equiv.Perm (PrimitiveBasis (lemmaOneFlatWidth k)) =>
      permutation state)
    (eval_parallelForward_eq_seq five_le left right)
  calc
    evalReversibleProgram (parallelForward five_le left right).program state
        (dirtyWire k) =
      evalReversibleProgram
        (ScheduledReversibleProgram.seq
          (leftForward five_le left) (rightForward five_le right)).program state
        (dirtyWire k) := congrArg (fun s => s (dirtyWire k)) parallelEq
    _ = evalReversibleProgram (rightForward five_le right).program
        (evalReversibleProgram (leftForward five_le left).program state)
        (dirtyWire k) := by
      rw [ScheduledReversibleProgram.eval_seq]
      rfl
    _ = evalReversibleProgram (leftForward five_le left).program state
        (dirtyWire k) := rightForward_preserves_dirty five_le right _
    _ = state (dirtyWire k) := leftForward_preserves_dirty five_le left state

end VandaeleLemma1NieParallelChildSemantics
end QuantumBlockEncoding