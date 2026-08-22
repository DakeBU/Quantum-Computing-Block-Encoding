import QuantumBlockEncoding.PrimitiveSemantics
import Mathlib.Tactic

/-!
# Remaud--Vandaele Algorithm 2: local cancellation algebra

The recursive proof of Equation (7) has one small Boolean core which should not
be buried inside interval arithmetic.

For an ordinary source pair, write:

* `x` for the predecessor alpha bit read by the right-wall source gate;
* `y` for the current source target bit;
* `A` for activation of the left part of the parent control interval;
* `B` for activation of the remaining child/right part.

The left wall first toggles `x` under `A`.  The recursive child toggles `y`
under `A ∧ B`.  The right wall then toggles `y` when the updated predecessor
bit is one and `B` holds.  Their net effect is the original source gate.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaCancellationAlgebra

/-- Toggle one computational-basis bit under a Boolean condition. -/
def toggleBy (condition : Bool) (bit : Fin 2) : Fin 2 :=
  if condition = true then flipBit bit else bit

/-- Boolean test that a computational-basis bit equals one. -/
def bitIsOne (bit : Fin 2) : Bool := decide (bit = 1)

@[simp] theorem toggleBy_false (bit : Fin 2) :
    toggleBy false bit = bit := rfl

@[simp] theorem toggleBy_true (bit : Fin 2) :
    toggleBy true bit = flipBit bit := rfl

/-- Boolean form of the ordinary-pair cancellation identity. -/
theorem ordinary_pair_cancellation
    (x y : Fin 2) (A B : Bool) :
    toggleBy (bitIsOne (toggleBy A x) && B)
        (toggleBy (A && B) y) =
      toggleBy (bitIsOne x && B) y := by
  fin_cases x <;> fin_cases y <;> cases A <;> cases B <;> rfl

/-- Boolean form with the intermediate values named. -/
theorem ordinary_pair_cancellation_after_child
    (x y : Fin 2) (A B : Bool) :
    let predecessorAfterLeft := toggleBy A x
    let targetAfterChild := toggleBy (A && B) y
    toggleBy (bitIsOne predecessorAfterLeft && B) targetAfterChild =
      toggleBy (bitIsOne x && B) y := by
  exact ordinary_pair_cancellation x y A B

/-- Prop-native form matching the source `intervalActive` statements directly.

This theorem is the exact algebra needed after rewriting the left-wall target,
child induction hypothesis, and right-wall target formulas. -/
theorem ordinary_pair_cancellation_prop
    (x y : Fin 2) (A B : Prop) [Decidable A] [Decidable B] :
    let predecessorAfterLeft := if A then flipBit x else x
    let targetAfterChild := if A ∧ B then flipBit y else y
    (if predecessorAfterLeft = 1 ∧ B then
        flipBit targetAfterChild
      else targetAfterChild) =
      (if x = 1 ∧ B then flipBit y else y) := by
  by_cases a : A <;> by_cases b : B <;>
    fin_cases x <;> fin_cases y <;>
    simp [a, b, flipBit]

end RemaudVandaeleLadderAlphaCancellationAlgebra
end QuantumBlockEncoding
