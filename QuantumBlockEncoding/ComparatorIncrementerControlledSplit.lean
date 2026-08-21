import QuantumBlockEncoding.ComparatorIncrementerRecursiveSplit
import Mathlib.Tactic

/-!
# Controlled recursive split for the incrementer

For the Lemma-7 / Equation-(38) line we first isolate the arithmetic statement
from the promise-register implementation.

For an `(lowWidth + highWidth)`-bit word and an external Boolean control:

* when the control is false, both blocks are unchanged;
* when the control is true, the low block is incremented modulo `2^lowWidth`;
* the high block is incremented iff that active low block overflows.

The low/high recomposition is exactly the externally controlled full-word
increment.  A later promise/dirty circuit only has to refine this semantic
contract; it does not need to re-prove the modular arithmetic.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerControlledSplit

open ComparatorIncrementerRecursiveSplit

/-- Low block under an external control. -/
def controlledLowValue
    (lowWidth highWidth : Nat)
    (active : Bool)
    (word : Fin (gridSize (lowWidth + highWidth))) : Nat :=
  if active then
    incrementLowValue lowWidth highWidth word
  else
    word.val % gridSize lowWidth

/-- Carry sent to the high block under the external control. -/
def controlledCarry
    (lowWidth highWidth : Nat)
    (active : Bool)
    (word : Fin (gridSize (lowWidth + highWidth))) : Nat :=
  if active then incrementCarry lowWidth highWidth word else 0

/-- High block after receiving the controlled carry. -/
def controlledHighValue
    (lowWidth highWidth : Nat)
    (active : Bool)
    (word : Fin (gridSize (lowWidth + highWidth))) : Nat :=
  (word.val / gridSize lowWidth +
      controlledCarry lowWidth highWidth active word) %
    gridSize highWidth

/-- Whole-word externally controlled increment. -/
def controlledIncrementValue
    (lowWidth highWidth : Nat)
    (active : Bool)
    (word : Fin (gridSize (lowWidth + highWidth))) : Nat :=
  if active then
    (word.val + 1) % gridSize (lowWidth + highWidth)
  else word.val

@[simp] theorem controlledCarry_false
    (lowWidth highWidth : Nat)
    (word : Fin (gridSize (lowWidth + highWidth))) :
    controlledCarry lowWidth highWidth false word = 0 := by
  rfl

@[simp] theorem controlledCarry_true
    (lowWidth highWidth : Nat)
    (word : Fin (gridSize (lowWidth + highWidth))) :
    controlledCarry lowWidth highWidth true word =
      incrementCarry lowWidth highWidth word := by
  rfl

/-- On the active branch the high block is the existing Eq.-(34) high block. -/
@[simp] theorem controlledHighValue_true
    (lowWidth highWidth : Nat)
    (word : Fin (gridSize (lowWidth + highWidth))) :
    controlledHighValue lowWidth highWidth true word =
      incrementHighValue lowWidth highWidth word := by
  rfl

/-- On the inactive branch the high block is unchanged. -/
theorem controlledHighValue_false
    (lowWidth highWidth : Nat)
    (word : Fin (gridSize (lowWidth + highWidth))) :
    controlledHighValue lowWidth highWidth false word =
      word.val / gridSize lowWidth := by
  unfold controlledHighValue controlledCarry
  simp only [ite_false, add_zero]
  have highBound := old_high_lt_gridSize lowWidth highWidth word
  exact Nat.mod_eq_of_lt highBound

/-- Exact controlled split/recomposition identity. -/
theorem controlled_increment_recomposition
    (lowWidth highWidth : Nat)
    (active : Bool)
    (word : Fin (gridSize (lowWidth + highWidth))) :
    controlledIncrementValue lowWidth highWidth active word =
      controlledLowValue lowWidth highWidth active word +
        gridSize lowWidth *
          controlledHighValue lowWidth highWidth active word := by
  cases active with
  | false =>
      unfold controlledIncrementValue controlledLowValue
      simp only [ite_false]
      rw [controlledHighValue_false]
      have sizeSplit :
          gridSize (lowWidth + highWidth) =
            gridSize lowWidth * gridSize highWidth := by
        simp [gridSize, pow_add]
      have decomposition := Nat.mod_mul word.val (gridSize lowWidth) (gridSize highWidth)
      have wordMod :
          word.val % (gridSize lowWidth * gridSize highWidth) = word.val := by
        rw [← sizeSplit]
        exact Nat.mod_eq_of_lt word.isLt
      rw [wordMod] at decomposition
      exact decomposition
  | true =>
      unfold controlledIncrementValue controlledLowValue
      simp only [ite_true]
      rw [controlledHighValue_true]
      exact increment_eq_low_plus_high lowWidth highWidth word

/-- Predicate form: the high block receives a carry exactly when the external
control is active and the low block overflows. -/
theorem controlledCarry_eq_one_iff
    (lowWidth highWidth : Nat)
    (active : Bool)
    (word : Fin (gridSize (lowWidth + highWidth))) :
    controlledCarry lowWidth highWidth active word = 1 ↔
      active = true ∧ gridSize lowWidth ∣ word.val + 1 := by
  cases active with
  | false => simp [controlledCarry]
  | true =>
      simp only [controlledCarry, ite_true, true_and]
      exact incrementCarry_eq_one_iff lowWidth highWidth word

/-- Key-predicate specialization used by a k-controlled circuit. -/
theorem predicate_controlled_increment_recomposition
    {κ : Type*}
    (lowWidth highWidth : Nat)
    (control : κ → Bool) (key : κ)
    (word : Fin (gridSize (lowWidth + highWidth))) :
    controlledIncrementValue lowWidth highWidth (control key) word =
      controlledLowValue lowWidth highWidth (control key) word +
        gridSize lowWidth *
          controlledHighValue lowWidth highWidth (control key) word :=
  controlled_increment_recomposition
    lowWidth highWidth (control key) word

end ComparatorIncrementerControlledSplit
end QuantumBlockEncoding
