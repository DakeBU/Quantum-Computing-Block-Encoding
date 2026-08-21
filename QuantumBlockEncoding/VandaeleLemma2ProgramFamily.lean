import QuantumBlockEncoding.ComparatorIncrementerFanoutSource
import QuantumBlockEncoding.ReversibleSchedule
import Mathlib.Tactic

/-!
# Proof-bearing scheduled program target for Vandaele Lemma 2

Lemma 2 supplies the low-depth first- and second-order fan-out families used
throughout the paper.  This file binds its exact basis semantics and uniform
resource theorem to one scheduled reversible circuit family.

Flat wire order for `F_order^(blocks)` is

`[ global | block 0 local controls | block 0 target | ... ]`.

The family interface is defined for arbitrary order, while the resource theorem
is required only for the source-covered orders 1 and 2.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma2ProgramFamily

open ComparatorIncrementerFanoutSource

/-- Total wire count of one flat source fan-out instance. -/
def fanoutFlatWidth (order blocks : Nat) : Nat :=
  1 + blocks * (order + 1)

/-- Global fan-out control. -/
def globalWire (order blocks : Nat) : Fin (fanoutFlatWidth order blocks) :=
  ⟨0, by unfold fanoutFlatWidth; omega⟩

/-- Local control j in block i. -/
def localWire (order blocks : Nat)
    (block : Fin blocks) (wire : Fin order) :
    Fin (fanoutFlatWidth order blocks) :=
  ⟨1 + block.val * (order + 1) + wire.val, by
    have blockLt := Nat.mul_lt_mul_of_pos_right
      block.isLt (Nat.succ_pos order)
    have wireLt : wire.val < order + 1 := by omega
    unfold fanoutFlatWidth
    omega⟩

/-- Target of block i. -/
def targetWire (order blocks : Nat) (block : Fin blocks) :
    Fin (fanoutFlatWidth order blocks) :=
  ⟨1 + block.val * (order + 1) + order, by
    have blockLt := Nat.mul_lt_mul_of_pos_right
      block.isLt (Nat.succ_pos order)
    unfold fanoutFlatWidth
    omega⟩

/-- Flat activation predicate matching Definition 2.2. -/
def flatFanoutActive (order blocks : Nat)
    (state : PrimitiveBasis (fanoutFlatWidth order blocks))
    (block : Fin blocks) : Prop :=
  state (globalWire order blocks) = 1 ∧
    ∀ wire : Fin order, state (localWire order blocks block wire) = 1

/-- Exact flat basis contract for one source fan-out. -/
def FanoutFlatSpec (order blocks : Nat)
    (implementation : Equiv.Perm
      (PrimitiveBasis (fanoutFlatWidth order blocks))) : Prop :=
  ∀ state,
    implementation state (globalWire order blocks) =
        state (globalWire order blocks) ∧
    (∀ block : Fin blocks, ∀ wire : Fin order,
      implementation state (localWire order blocks block wire) =
        state (localWire order blocks block wire)) ∧
    ∀ block : Fin blocks,
      implementation state (targetWire order blocks block) =
        (if flatFanoutActive order blocks state block then
          flipBit (state (targetWire order blocks block))
        else state (targetWire order blocks block))

/-- Every local-control position is strictly before its block target. -/
theorem localWire_lt_targetWire
    (order blocks : Nat) (block : Fin blocks) (wire : Fin order) :
    (localWire order blocks block wire).val <
      (targetWire order blocks block).val := by
  unfold localWire targetWire
  simp only
  omega

/-- For positive order, the next block begins immediately after the current
target. -/
theorem next_block_local_start
    (order blocks : Nat) (positiveOrder : 0 < order)
    (block : Fin blocks) (next : block.val + 1 < blocks) :
    (localWire order blocks
      ⟨block.val + 1, next⟩
      ⟨0, positiveOrder⟩).val =
      (targetWire order blocks block).val + 1 := by
  simp [localWire, targetWire]
  ring

/-- Final proof-bearing implementation family for Definition 2.2 / Lemma 2. -/
structure LemmaTwoScheduledFamily where
  scheduled : (order blocks : Nat) →
    ScheduledReversibleProgram (fanoutFlatWidth order blocks)
  correctness : ∀ order blocks,
    lemmaTwoCoveredOrder order →
      FanoutFlatSpec order blocks
        (evalReversibleProgram (scheduled order blocks).program)
  resources :
    LemmaTwoUniformResourceTarget
      (fun order blocks => (scheduled order blocks).gateCount)
      (fun order blocks => (scheduled order blocks).depth)

/-- First-order resource family extracted directly from the same scheduled
programs, ready for Lemma 5 and Equation (37). -/
theorem firstOrder_resources
    (family : LemmaTwoScheduledFamily) :
    FirstOrderFanoutUniformResourceTarget
      (fun blocks => (family.scheduled 1 blocks).gateCount)
      (fun blocks => (family.scheduled 1 blocks).depth) := by
  exact lemmaTwo_implies_firstOrder
    (fun order blocks => (family.scheduled order blocks).gateCount)
    (fun order blocks => (family.scheduled order blocks).depth)
    family.resources

end VandaeleLemma2ProgramFamily
end QuantumBlockEncoding
