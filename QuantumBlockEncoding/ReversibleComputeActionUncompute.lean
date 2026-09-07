import QuantumBlockEncoding.ReversibleSchedule
import Mathlib.Tactic

/-!
# Proof-bearing compute/action/uncompute splits

Nie's logarithmic-depth multi-controlled-X recursion does not recursively place
a complete child circuit in both Step 2 and Step 4.  It places the child's
compute-plus-central-action first half in Step 2 and only the cleanup suffix in
Step 4.  Together those pieces have exactly the depth of one complete child
circuit.

This module captures that reusable pattern for reversible schedules.  The
cleanup schedule is obtained by reversing both layer order and gate order inside
each layer.  Because X, CX and CCX are self-inverse, this is an exact inverse
basis action while preserving gate count and parallel depth.
-/

namespace QuantumBlockEncoding

namespace ReversibleLayer

/-- Reverse chronological gate order inside one layer. -/
def reverseLayer {qubits : Nat}
    (layer : ReversibleLayer qubits) : ReversibleLayer qubits :=
  layer.reverse

/-- Reversing a valid layer preserves validity because wire-disjointness is
symmetric. -/
theorem valid_reverse {qubits : Nat}
    {layer : ReversibleLayer qubits}
    (valid : layer.Valid) :
    (reverseLayer layer).Valid := by
  unfold Valid at valid ⊢
  unfold reverseLayer
  rw [List.pairwise_reverse]
  exact valid.imp ReversibleGate.wireDisjoint_symm

end ReversibleLayer

namespace ReversibleSchedule

/-- Reverse a schedule as a circuit: reverse the gate order inside each layer,
then reverse the layer order.  This presentation is extensionally the same as
`schedule.reverse.map reverseLayer`, but its recursive normal form exposes the
induction hypothesis directly. -/
def reverseSchedule {qubits : Nat}
    (schedule : ReversibleSchedule qubits) : ReversibleSchedule qubits :=
  (schedule.map ReversibleLayer.reverseLayer).reverse

/-- The reversed schedule remains proof-bearing valid. -/
theorem reverseSchedule_valid {qubits : Nat}
    {schedule : ReversibleSchedule qubits}
    (valid : schedule.Valid) :
    (reverseSchedule schedule).Valid := by
  intro layer member
  have mappedMember :
      layer ∈ schedule.map ReversibleLayer.reverseLayer := by
    simpa [reverseSchedule] using member
  simp only [List.mem_map] at mappedMember
  rcases mappedMember with ⟨source, sourceMember, rfl⟩
  exact ReversibleLayer.valid_reverse (valid source sourceMember)

/-- Flattening the reversed schedule gives exactly the reversed flat program. -/
theorem reverseSchedule_program {qubits : Nat}
    (schedule : ReversibleSchedule qubits) :
    (reverseSchedule schedule).program = schedule.program.reverse := by
  induction schedule with
  | nil => rfl
  | cons layer rest induction =>
      have restReverse :
          (rest.map ReversibleLayer.reverseLayer).reverse.flatten =
            rest.flatten.reverse := by
        simpa [reverseSchedule, program] using induction
      simp [reverseSchedule, program, ReversibleLayer.reverseLayer, restReverse]

@[simp] theorem reverseSchedule_length {qubits : Nat}
    (schedule : ReversibleSchedule qubits) :
    (reverseSchedule schedule).length = schedule.length := by
  simp [reverseSchedule]

end ReversibleSchedule

/-- Each primitive reversible gate is an involution on computational-basis
states. -/
theorem evalReversibleGate_involutive {qubits : Nat}
    (gate : ReversibleGate qubits) :
    Function.Involutive (evalReversibleGate gate) := by
  intro state
  cases gate with
  | x target =>
      exact xBasisAction_involutive target state
  | cx control target distinct =>
      exact cxBasisAction_involutive control target distinct state
  | ccx control0 control1 target c0_ne_c1 c0_ne_target c1_ne_target =>
      exact ccxBasisAction_involutive control0 control1 target
        c0_ne_target c1_ne_target state

/-- Executing a program and then its reverse restores the complete basis state. -/
theorem evalReversibleProgram_reverse_after {qubits : Nat}
    (program : ReversibleProgram qubits)
    (state : PrimitiveBasis qubits) :
    evalReversibleProgram program.reverse
        (evalReversibleProgram program state) = state := by
  induction program generalizing state with
  | nil => rfl
  | cons gate rest induction =>
      rw [List.reverse_cons, evalReversibleProgram_append]
      change
        evalReversibleGate gate
          (evalReversibleProgram rest.reverse
            (evalReversibleProgram rest
              (evalReversibleGate gate state))) = state
      rw [induction (evalReversibleGate gate state)]
      exact evalReversibleGate_involutive gate state

namespace ScheduledReversibleProgram

/-- Exact inverse schedule with the same layer structure reversed. -/
def reverse {qubits : Nat}
    (scheduled : ScheduledReversibleProgram qubits) :
    ScheduledReversibleProgram qubits where
  layers := ReversibleSchedule.reverseSchedule scheduled.layers
  valid := ReversibleSchedule.reverseSchedule_valid scheduled.valid

@[simp] theorem reverse_program {qubits : Nat}
    (scheduled : ScheduledReversibleProgram qubits) :
    scheduled.reverse.program = scheduled.program.reverse := by
  exact ReversibleSchedule.reverseSchedule_program scheduled.layers

@[simp] theorem reverse_gateCount {qubits : Nat}
    (scheduled : ScheduledReversibleProgram qubits) :
    scheduled.reverse.gateCount = scheduled.gateCount := by
  unfold reverse gateCount ReversibleSchedule.gateCount
  rw [ReversibleSchedule.reverseSchedule_program]
  simp

@[simp] theorem reverse_depth {qubits : Nat}
    (scheduled : ScheduledReversibleProgram qubits) :
    scheduled.reverse.depth = scheduled.depth := by
  unfold reverse depth ReversibleSchedule.depth
  exact ReversibleSchedule.reverseSchedule_length scheduled.layers

/-- Schedule-level cleanup theorem: reverse execution restores every wire. -/
theorem eval_reverse_after {qubits : Nat}
    (scheduled : ScheduledReversibleProgram qubits)
    (state : PrimitiveBasis qubits) :
    evalReversibleProgram scheduled.reverse.program
        (evalReversibleProgram scheduled.program state) = state := by
  rw [reverse_program]
  exact evalReversibleProgram_reverse_after scheduled.program state

end ScheduledReversibleProgram

/-- A reversible compute/action/uncompute object.  `forwardHalf` is exactly the
piece that a parent Nie recursion may consume before its own central action;
`cleanup` is delayed until after the parent's central action. -/
structure ReversibleComputeActionUncompute (qubits : Nat) where
  prepare : ScheduledReversibleProgram qubits
  commit : ScheduledReversibleProgram qubits

namespace ReversibleComputeActionUncompute

/-- The first recursive half used in Nie Step 2: prepare, then perform the
child's persistent central action. -/
def forwardHalf {qubits : Nat}
    (split : ReversibleComputeActionUncompute qubits) :
    ScheduledReversibleProgram qubits :=
  ScheduledReversibleProgram.seq split.prepare split.commit

/-- The delayed cleanup used in Nie Step 4. -/
def cleanup {qubits : Nat}
    (split : ReversibleComputeActionUncompute qubits) :
    ScheduledReversibleProgram qubits :=
  split.prepare.reverse

/-- Complete child circuit: first half followed by delayed cleanup. -/
def full {qubits : Nat}
    (split : ReversibleComputeActionUncompute qubits) :
    ScheduledReversibleProgram qubits :=
  ScheduledReversibleProgram.seq split.forwardHalf split.cleanup

@[simp] theorem forwardHalf_gateCount {qubits : Nat}
    (split : ReversibleComputeActionUncompute qubits) :
    split.forwardHalf.gateCount =
      split.prepare.gateCount + split.commit.gateCount := by
  simp [forwardHalf]

@[simp] theorem forwardHalf_depth {qubits : Nat}
    (split : ReversibleComputeActionUncompute qubits) :
    split.forwardHalf.depth = split.prepare.depth + split.commit.depth := by
  simp [forwardHalf]

@[simp] theorem cleanup_gateCount {qubits : Nat}
    (split : ReversibleComputeActionUncompute qubits) :
    split.cleanup.gateCount = split.prepare.gateCount := by
  simp [cleanup]

@[simp] theorem cleanup_depth {qubits : Nat}
    (split : ReversibleComputeActionUncompute qubits) :
    split.cleanup.depth = split.prepare.depth := by
  simp [cleanup]

@[simp] theorem full_gateCount {qubits : Nat}
    (split : ReversibleComputeActionUncompute qubits) :
    split.full.gateCount =
      2 * split.prepare.gateCount + split.commit.gateCount := by
  simp [full, forwardHalf, cleanup]
  omega

@[simp] theorem full_depth {qubits : Nat}
    (split : ReversibleComputeActionUncompute qubits) :
    split.full.depth = 2 * split.prepare.depth + split.commit.depth := by
  simp [full, forwardHalf, cleanup]
  omega

/-- The key recurrence accounting identity: the Step-2 first half plus Step-4
cleanup costs exactly one complete child depth, not two complete child depths. -/
theorem forwardHalf_depth_add_cleanup_depth {qubits : Nat}
    (split : ReversibleComputeActionUncompute qubits) :
    split.forwardHalf.depth + split.cleanup.depth = split.full.depth := by
  simp [full, forwardHalf, cleanup]

/-- Likewise, the two delayed pieces contain exactly the gates of one full child
circuit. -/
theorem forwardHalf_gateCount_add_cleanup_gateCount {qubits : Nat}
    (split : ReversibleComputeActionUncompute qubits) :
    split.forwardHalf.gateCount + split.cleanup.gateCount =
      split.full.gateCount := by
  simp [full, forwardHalf, cleanup]

/-- Cleanup really is the inverse of the preparation state transformation. -/
theorem cleanup_restores_prepare {qubits : Nat}
    (split : ReversibleComputeActionUncompute qubits)
    (state : PrimitiveBasis qubits) :
    evalReversibleProgram split.cleanup.program
        (evalReversibleProgram split.prepare.program state) = state := by
  exact ScheduledReversibleProgram.eval_reverse_after split.prepare state

end ReversibleComputeActionUncompute

end QuantumBlockEncoding
