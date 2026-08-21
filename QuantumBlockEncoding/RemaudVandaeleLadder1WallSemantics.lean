import QuantumBlockEncoding.RemaudVandaeleLadder1AlgorithmPlan
import QuantumBlockEncoding.ReversibleLayerSemantics
import QuantumBlockEncoding.ReversibleWireEmbedding
import Mathlib.Data.List.OfFn
import Mathlib.Tactic

/-!
# Local semantics and wire geometry of Algorithm 1

Remaud--Vandaele's correctness proof names the two depth-one CNOT walls `U_L`
and `U_R` and then reasons about the recursively selected register `X'`.
This module formalizes exactly those local facts for the physical gate lists from
`RemaudVandaeleLadder1AlgorithmPlan`.

The remaining global proof can therefore follow the paper line by line:

`U_L ; U_X' ; U_R`

without re-expanding the complete CNOT layers.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadder1WallSemantics

open RemaudVandaeleLadder1AlgorithmPlan
open ReversibleLayerSemantics
open ReversibleProgramSupport
open ReversibleWireEmbedding

/-- Computational-basis XOR, written in the same orientation as a CNOT:
`xorBit control target`. -/
def xorBit (control target : Fin 2) : Fin 2 :=
  if control = 0 then target else flipBit target

@[simp] theorem xorBit_zero (target : Fin 2) : xorBit 0 target = target := by
  rfl

@[simp] theorem xorBit_one (target : Fin 2) : xorBit 1 target = flipBit target := by
  rfl

/-- XORing by the same bit twice cancels. -/
theorem xorBit_cancel (control target : Fin 2) :
    xorBit control (xorBit control target) = target := by
  fin_cases control <;> fin_cases target <;> rfl

/-- Parallelogram identity used in the final `U_R U_X' U_L` cancellation. -/
theorem xorBit_parallelogram (shared left right : Fin 2) :
    xorBit (xorBit shared left) (xorBit shared right) =
      xorBit left right := by
  fin_cases shared <;> fin_cases left <;> fin_cases right <;> rfl

/-- Stand-alone CNOT target equation. -/
theorem eval_cx_target
    {q : Nat} (control target : Fin q) (distinct : control ≠ target)
    (state : PrimitiveBasis q) :
    evalReversibleGate (.cx control target distinct) state target =
      xorBit (state control) (state target) := by
  by_cases zero : state control = 0
  · simp [evalReversibleGate, cxBasisEquiv, cxBasisAction,
      xBasisAction, xorBit, zero]
  · simp [evalReversibleGate, cxBasisEquiv, cxBasisAction,
      xBasisAction, xorBit, zero]

/-- Stand-alone CNOT preserves its control. -/
theorem eval_cx_control
    {q : Nat} (control target : Fin q) (distinct : control ≠ target)
    (state : PrimitiveBasis q) :
    evalReversibleGate (.cx control target distinct) state control =
      state control := by
  by_cases zero : state control = 0
  · simp [evalReversibleGate, cxBasisEquiv, cxBasisAction, zero]
  · simp [evalReversibleGate, cxBasisEquiv, cxBasisAction,
      xBasisAction, zero, distinct]

/-- One source right-wall CNOT has the expected local target action even when
executed inside the complete parallel wall. -/
theorem rightLayer_target
    (n : Nat) (j : Fin (outerCount n))
    (state : PrimitiveBasis n) :
    evalReversibleProgram (rightLayer n) state (rightTarget n j) =
      xorBit (state (rightControl n j)) (state (rightTarget n j)) := by
  have member : rightGate n j ∈ rightLayer n := by
    simp [rightLayer]
  have touched : (rightGate n j).touches (rightTarget n j) := by
    simp [rightGate, ReversibleGate.touches]
  calc
    evalReversibleProgram (rightLayer n) state (rightTarget n j) =
        evalReversibleGate (rightGate n j) state (rightTarget n j) :=
      eval_validLayer_member_on_touched
        (rightLayer n) (rightLayer_valid n)
        (rightGate n j) member state (rightTarget n j) touched
    _ = xorBit (state (rightControl n j)) (state (rightTarget n j)) := by
      exact eval_cx_target _ _ _ state

/-- One source right-wall CNOT's control is also unchanged by the complete
parallel wall. -/
theorem rightLayer_control
    (n : Nat) (j : Fin (outerCount n))
    (state : PrimitiveBasis n) :
    evalReversibleProgram (rightLayer n) state (rightControl n j) =
      state (rightControl n j) := by
  have member : rightGate n j ∈ rightLayer n := by
    simp [rightLayer]
  have touched : (rightGate n j).touches (rightControl n j) := by
    simp [rightGate, ReversibleGate.touches]
  calc
    evalReversibleProgram (rightLayer n) state (rightControl n j) =
        evalReversibleGate (rightGate n j) state (rightControl n j) :=
      eval_validLayer_member_on_touched
        (rightLayer n) (rightLayer_valid n)
        (rightGate n j) member state (rightControl n j) touched
    _ = state (rightControl n j) := by
      exact eval_cx_control _ _ _ state

/-- Left-wall target equation. -/
theorem leftLayer_target
    (n : Nat) (j : Fin (outerCount n))
    (state : PrimitiveBasis n) :
    evalReversibleProgram (leftLayer n) state (leftTarget n j) =
      xorBit (state (leftControl n j)) (state (leftTarget n j)) := by
  have member : leftGate n j ∈ leftLayer n := by
    simp [leftLayer]
  have touched : (leftGate n j).touches (leftTarget n j) := by
    simp [leftGate, ReversibleGate.touches]
  calc
    evalReversibleProgram (leftLayer n) state (leftTarget n j) =
        evalReversibleGate (leftGate n j) state (leftTarget n j) :=
      eval_validLayer_member_on_touched
        (leftLayer n) (leftLayer_valid n)
        (leftGate n j) member state (leftTarget n j) touched
    _ = xorBit (state (leftControl n j)) (state (leftTarget n j)) := by
      exact eval_cx_target _ _ _ state

/-- Left-wall controls are unchanged. -/
theorem leftLayer_control
    (n : Nat) (j : Fin (outerCount n))
    (state : PrimitiveBasis n) :
    evalReversibleProgram (leftLayer n) state (leftControl n j) =
      state (leftControl n j) := by
  have member : leftGate n j ∈ leftLayer n := by
    simp [leftLayer]
  have touched : (leftGate n j).touches (leftControl n j) := by
    simp [leftGate, ReversibleGate.touches]
  calc
    evalReversibleProgram (leftLayer n) state (leftControl n j) =
        evalReversibleGate (leftGate n j) state (leftControl n j) :=
      eval_validLayer_member_on_touched
        (leftLayer n) (leftLayer_valid n)
        (leftGate n j) member state (leftControl n j) touched
    _ = state (leftControl n j) := by
      exact eval_cx_control _ _ _ state

/-- A left-wall target is never one of the recursively selected `X'` wires. -/
theorem leftTarget_ne_recursiveWire
    (n : Nat) (left : Fin (outerCount n))
    (recursive : Fin (recursiveWidth n)) :
    leftTarget n left ≠ recursiveWire n recursive := by
  intro equal
  have values := congrArg Fin.val equal
  by_cases leftLast : left.val + 1 = outerCount n <;>
    by_cases recursiveLast : recursive.val + 1 = recursiveWidth n <;>
      simp [leftTarget, recursiveWire, leftLast, recursiveLast] at values <;>
      unfold outerCount recursiveWidth at * <;> omega

/-- Therefore `U_L` leaves the entire recursively selected register `X'`
unchanged, exactly as used in the source proof. -/
theorem leftLayer_preserves_recursiveWire
    (n : Nat) (recursive : Fin (recursiveWidth n))
    (state : PrimitiveBasis n) :
    evalReversibleProgram (leftLayer n) state (recursiveWire n recursive) =
      state (recursiveWire n recursive) := by
  apply eval_layer_preserves_of_no_target
  intro gate member
  simp [leftLayer] at member
  rcases member with ⟨left, rfl⟩
  simp [leftGate, targetsWire, leftTarget_ne_recursiveWire n left recursive]

/-- Reader-facing register version of the previous theorem. -/
theorem leftLayer_preserves_recursiveRegister
    (n : Nat) (state : PrimitiveBasis n) :
    readEmbeddedState (recursiveWire n)
        (evalReversibleProgram (leftLayer n) state) =
      readEmbeddedState (recursiveWire n) state := by
  funext recursive
  exact leftLayer_preserves_recursiveWire n recursive state

/-- Every right-wall block corresponds to one wire in the recursively selected
register. -/
def rightRecursiveIndex
    (n : Nat) (j : Fin (outerCount n)) : Fin (recursiveWidth n) :=
  ⟨j.val, by
    have hj := j.isLt
    unfold outerCount recursiveWidth at *
    omega⟩

/-- Physical identification `X'j = X_(2j+1)` for the right-wall target. -/
theorem recursiveWire_rightRecursiveIndex
    (n : Nat) (j : Fin (outerCount n)) :
    recursiveWire n (rightRecursiveIndex n j) = rightTarget n j := by
  apply Fin.ext
  by_cases last : j.val + 1 = recursiveWidth n
  · simp [recursiveWire, rightRecursiveIndex, rightTarget, last]
    have hj := j.isLt
    unfold outerCount recursiveWidth at *
    omega
  · simp [recursiveWire, rightRecursiveIndex, rightTarget, last]

/-- A right-wall even control is never recursively selected. -/
theorem rightControl_ne_recursiveWire
    (n : Nat) (right : Fin (outerCount n))
    (recursive : Fin (recursiveWidth n)) :
    rightControl n right ≠ recursiveWire n recursive := by
  intro equal
  have values := congrArg Fin.val equal
  by_cases recursiveLast : recursive.val + 1 = recursiveWidth n
  · simp [rightControl, recursiveWire, recursiveLast] at values
    have hr := right.isLt
    unfold outerCount recursiveWidth at *
    omega
  · simp [rightControl, recursiveWire, recursiveLast] at values
    omega

/-- Embedded recursive Algorithm-1 calls leave every right-wall control wire
unchanged. -/
theorem embeddedRecursive_preserves_rightControl
    (n : Nat)
    (recursiveProgram : ReversibleProgram (recursiveWidth n))
    (right : Fin (outerCount n))
    (state : PrimitiveBasis n) :
    evalReversibleProgram
        (mapProgramWires (recursiveWire n)
          (recursiveWire_injective (n := n)) recursiveProgram)
        state (rightControl n right) =
      state (rightControl n right) := by
  apply eval_mapProgramWires_outside
  intro recursive
  exact rightControl_ne_recursiveWire n right recursive

/-- For a nonfirst right-wall gate, the previous recursive wire is the odd
physical wire immediately preceding its even control. -/
def rightPreviousRecursiveIndex
    (n : Nat) (j : Fin (outerCount n)) (nonzero : j.val ≠ 0) :
    Fin (recursiveWidth n) :=
  ⟨j.val - 1, by
    have hj := j.isLt
    unfold outerCount recursiveWidth at *
    omega⟩

/-- The corresponding physical predecessor is `X_(2j-1)`. -/
theorem rightPreviousRecursiveWire_val
    (n : Nat) (j : Fin (outerCount n)) (nonzero : j.val ≠ 0) :
    (recursiveWire n (rightPreviousRecursiveIndex n j nonzero)).val =
      2 * j.val - 1 := by
  have hj := j.isLt
  have previousLt :
      (rightPreviousRecursiveIndex n j nonzero).val + 1 < recursiveWidth n := by
    simp [rightPreviousRecursiveIndex]
    unfold outerCount recursiveWidth at *
    omega
  have notLast :
      (rightPreviousRecursiveIndex n j nonzero).val + 1 ≠ recursiveWidth n := by
    omega
  simp [recursiveWire, rightPreviousRecursiveIndex, notLast]
  omega

/-- Before the recursive middle circuit, a nonfirst even right-wall control has
already acquired the XOR with the preceding odd source wire through `U_L`.
The first control `X0` stays unchanged. -/
theorem leftLayer_rightControl
    (n : Nat) (j : Fin (outerCount n))
    (state : PrimitiveBasis n) :
    evalReversibleProgram (leftLayer n) state (rightControl n j) =
      if zero : j.val = 0 then
        state (rightControl n j)
      else
        xorBit
          (state (recursiveWire n (rightPreviousRecursiveIndex n j zero)))
          (state (rightControl n j)) := by
  by_cases zero : j.val = 0
  · simp [zero]
    apply eval_layer_preserves_of_no_target
    intro gate member
    simp [leftLayer] at member
    rcases member with ⟨left, rfl⟩
    simp [leftGate, targetsWire]
    intro equal
    have values := congrArg Fin.val equal
    by_cases last : left.val + 1 = outerCount n <;>
      simp [leftTarget, rightControl, zero, last] at values <;>
      unfold outerCount at * <;> omega
  · simp [zero]
    let left : Fin (outerCount n) := ⟨j.val - 1, by omega⟩
    have leftNotLast : left.val + 1 ≠ outerCount n := by
      simp [left]
      have hj := j.isLt
      omega
    have targetEq : leftTarget n left = rightControl n j := by
      apply Fin.ext
      simp [leftTarget, rightControl, left, leftNotLast]
      omega
    have controlEq :
        leftControl n left = recursiveWire n (rightPreviousRecursiveIndex n j zero) := by
      apply Fin.ext
      have previous := rightPreviousRecursiveWire_val n j zero
      simp [leftControl, left, leftNotLast]
      omega
    rw [← targetEq, leftLayer_target]
    rw [controlEq, targetEq]

end RemaudVandaeleLadder1WallSemantics
end QuantumBlockEncoding
