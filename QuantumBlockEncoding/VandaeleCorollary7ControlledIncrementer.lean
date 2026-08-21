import QuantumBlockEncoding.ComparatorIncrementerTheorem4DepthBound
import QuantumBlockEncoding.ComparatorIncrementerGeneral
import QuantumBlockEncoding.PrimitiveBasisRegisterSplit
import Mathlib.Tactic

/-!
# Vandaele Corollary 7: k-controlled incrementer

Equation (47) generalizes the lower-bound identity from Equation (2).  Treat the
k control bits as the low block of a `(k+n)`-bit word and the n-bit target as the
high block.  Increment the whole word, then decrement the low k-bit block.

If the controls are not all ones, the whole-word increment changes only the low
block and the decrement cancels it.  If the controls are all ones, the increment
wraps the low block to zero and carries +1 into the n-bit target; the decrement
then restores the all-ones controls.

Thus the composite is exactly the k-controlled n-bit increment.  The source
resource theorem follows by composing one `(k+n)`-bit incrementer and one k-bit
decrementer, reusing a single dirty ancilla from the target register.
-/

namespace QuantumBlockEncoding
namespace VandaeleCorollary7ControlledIncrementer

open ComparatorIncrementerGeneral
open ComparatorIncrementerTheorem4DepthBound
open PrimitiveBasisRegisterSplit

/-- Maximum k-bit control word. -/
def maxControl (k : Nat) : Fin (gridSize k) :=
  ⟨gridSize k - 1, by
    have positive : 0 < gridSize k := Nat.pow_pos (by decide)
    omega⟩

/-- Low-block decrement. -/
def decrementControl (k : Nat) (word : Fin (gridSize k)) : Fin (gridSize k) :=
  if zero : word.val = 0 then maxControl k
  else ⟨word.val - 1, by have bound := word.isLt; omega⟩

/-- Whole `(k+n)` successor written in low-control/high-target coordinates. -/
def incrementCombined
    (k n : Nat)
    (state : Fin (gridSize k) × Fin (gridSize n)) :
    Fin (gridSize k) × Fin (gridSize n) :=
  let lowValue := (state.1.val + 1) % gridSize k
  let carry := if state.1.val + 1 = gridSize k then 1 else 0
  let highValue := (state.2.val + carry) % gridSize n
  (⟨lowValue, Nat.mod_lt _ (Nat.pow_pos (by decide))⟩,
   ⟨highValue, Nat.mod_lt _ (Nat.pow_pos (by decide))⟩)

/-- Equation-(47) composite: whole increment followed by low decrement. -/
def equationFortySeven
    (k n : Nat)
    (state : Fin (gridSize k) × Fin (gridSize n)) :
    Fin (gridSize k) × Fin (gridSize n) :=
  let after := incrementCombined k n state
  (decrementControl k after.1, after.2)

/-- Canonical controlled n-bit increment target. -/
def controlledIncrementAction
    (k n : Nat)
    (state : Fin (gridSize k) × Fin (gridSize n)) :
    Fin (gridSize k) × Fin (gridSize n) :=
  if state.1 = maxControl k then
    (state.1,
      ⟨(state.2.val + 1) % gridSize n,
        Nat.mod_lt _ (Nat.pow_pos (by decide))⟩)
  else state

/-- Maximum controls are exactly the carry condition. -/
theorem maxControl_iff_carry
    (k : Nat) (word : Fin (gridSize k)) :
    word = maxControl k ↔ word.val + 1 = gridSize k := by
  constructor
  · intro equal
    subst word
    simp [maxControl]
    have positive : 0 < gridSize k := Nat.pow_pos (by decide)
    omega
  · intro carry
    apply Fin.ext
    simp [maxControl]
    omega

/-- Nonmaximal controls are restored and emit no target carry. -/
theorem equationFortySeven_nonmax
    (k n : Nat)
    (state : Fin (gridSize k) × Fin (gridSize n))
    (inactive : state.1 ≠ maxControl k) :
    equationFortySeven k n state = state := by
  have noCarry : state.1.val + 1 ≠ gridSize k := by
    intro carry
    exact inactive ((maxControl_iff_carry k state.1).2 carry)
  have successorLt : state.1.val + 1 < gridSize k := by
    have bound := state.1.isLt
    omega
  have positive : state.1.val + 1 ≠ 0 := by omega
  apply Prod.ext
  · simp [equationFortySeven, incrementCombined, decrementControl,
      noCarry, Nat.mod_eq_of_lt successorLt, positive]
  · simp [equationFortySeven, incrementCombined, noCarry]

/-- All-one controls are restored and the target increments modulo `2^n`. -/
theorem equationFortySeven_max
    (k n : Nat) (target : Fin (gridSize n)) :
    equationFortySeven k n (maxControl k, target) =
      (maxControl k,
        ⟨(target.val + 1) % gridSize n,
          Nat.mod_lt _ (Nat.pow_pos (by decide))⟩) := by
  have carry : (maxControl k).val + 1 = gridSize k := by
    exact (maxControl_iff_carry k (maxControl k)).1 rfl
  simp [equationFortySeven, incrementCombined, decrementControl,
    carry, maxControl]

/-- Exact Equation-(47) semantic identity. -/
theorem equationFortySeven_eq_controlledIncrement
    (k n : Nat)
    (state : Fin (gridSize k) × Fin (gridSize n)) :
    equationFortySeven k n state = controlledIncrementAction k n state := by
  by_cases active : state.1 = maxControl k
  · rcases state with ⟨controls, target⟩
    subst controls
    rw [equationFortySeven_max]
    simp [controlledIncrementAction]
  · rw [equationFortySeven_nonmax k n state active]
    simp [controlledIncrementAction, active]

/-- Resource target for the source Theorem-4 incrementer family. -/
def IncrementerResourceTarget
    (gateCount depth dirtyAncillas : Nat → Nat) : Prop :=
  ∃ gateConstant depthConstant : Nat,
    ∀ width,
      gateCount width ≤ gateConstant * (width + 1) ∧
      depth width ≤ depthConstant * logRank width ∧
      dirtyAncillas width ≤ 1

/-- Literal Corollary-7 resource envelopes. -/
def controlledGateEnvelope
    (incrementGate : Nat → Nat) (k n : Nat) : Nat :=
  incrementGate (k + n) + incrementGate k

/-- Reverse circuit used for decrement has the same depth as increment. -/
def controlledDepthEnvelope
    (incrementDepth : Nat → Nat) (k n : Nat) : Nat :=
  incrementDepth (k + n) + incrementDepth k

/-- Totalized source depth scale. -/
def controlledLogScale (k n : Nat) : Nat :=
  logRank (k + n)

/-- The k-width log rank is bounded by the `(k+n)`-width rank. -/
theorem logRank_left_le (k n : Nat) : logRank k ≤ logRank (k + n) := by
  unfold logRank
  have value : k + 1 ≤ k + n + 1 := by omega
  have logarithm : Nat.log2 (k + 1) ≤ Nat.log2 (k + n + 1) := by
    rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
    exact Nat.log_mono_right value
  omega

/-- Theorem-4 resource evidence closes Corollary 7 uniformly. -/
theorem resource_closure
    (incrementGate incrementDepth incrementDirty : Nat → Nat)
    (resources :
      IncrementerResourceTarget incrementGate incrementDepth incrementDirty) :
    ∃ gateConstant depthConstant : Nat,
      ∀ k n,
        controlledGateEnvelope incrementGate k n ≤
          gateConstant * (k + n + 1) ∧
        controlledDepthEnvelope incrementDepth k n ≤
          depthConstant * controlledLogScale k n := by
  rcases resources with
    ⟨sourceGateConstant, sourceDepthConstant, bounds⟩
  refine ⟨2 * sourceGateConstant, 2 * sourceDepthConstant, ?_⟩
  intro k n
  have whole := bounds (k + n)
  have low := bounds k
  have kScale : k + 1 ≤ k + n + 1 := by omega
  have lowGate : incrementGate k ≤
      sourceGateConstant * (k + n + 1) :=
    low.1.trans (Nat.mul_le_mul_left sourceGateConstant kScale)
  have lowDepth : incrementDepth k ≤
      sourceDepthConstant * logRank (k + n) :=
    low.2.1.trans
      (Nat.mul_le_mul_left sourceDepthConstant (logRank_left_le k n))
  constructor
  · unfold controlledGateEnvelope
    calc
      incrementGate (k + n) + incrementGate k ≤
          sourceGateConstant * (k + n + 1) +
          sourceGateConstant * (k + n + 1) :=
        Nat.add_le_add whole.1 lowGate
      _ = (2 * sourceGateConstant) * (k + n + 1) := by ring
  · unfold controlledDepthEnvelope controlledLogScale
    calc
      incrementDepth (k + n) + incrementDepth k ≤
          sourceDepthConstant * logRank (k + n) +
          sourceDepthConstant * logRank (k + n) :=
        Nat.add_le_add whole.2.1 lowDepth
      _ = (2 * sourceDepthConstant) * logRank (k + n) := by ring

/-- Corollary-7 source workspace remains one dirty ancilla; the same physical
bit may be reused by the whole increment and low decrement. -/
def dirtyAncillas (_k _n : Nat) : Nat := 1

@[simp] theorem one_dirty (k n : Nat) : dirtyAncillas k n = 1 := rfl

end VandaeleCorollary7ControlledIncrementer
end QuantumBlockEncoding
