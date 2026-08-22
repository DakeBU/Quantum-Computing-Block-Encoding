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
under `A && B`.  The right wall then toggles `y` when the *updated* predecessor
bit is one and `B` holds.  The theorem below says that these two target
corrections collapse exactly to the original source action: toggle `y` iff the
*original* predecessor bit is one and `B` holds.

This is the algebraic reason Algorithm 2's odd/even wall construction works.
The geometric proof later only has to identify the source control interval with
the two predicates `A` and `B`.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaCancellationAlgebra

/-- Toggle one computational-basis bit under a Boolean condition. -/
def toggleBy (condition : Bool) (bit : Fin 2) : Fin 2 :=
  Bool.cond condition (flipBit bit) bit

/-- Boolean test that a computational-basis bit equals one. -/
def bitIsOne (bit : Fin 2) : Bool := decide (bit = 1)

@[simp] theorem toggleBy_false (bit : Fin 2) :
    toggleBy false bit = bit := rfl

@[simp] theorem toggleBy_true (bit : Fin 2) :
    toggleBy true bit = flipBit bit := rfl

/-- Core ordinary-pair cancellation identity.

`A` toggles the predecessor; `A && B` is the child correction; and the final
right-wall correction tests the updated predecessor together with `B`.  Their
net action is the parent source gate controlled by the original predecessor and
`B`. -/
theorem ordinary_pair_cancellation
    (x y : Fin 2) (A B : Bool) :
    toggleBy (bitIsOne (toggleBy A x) && B)
        (toggleBy (A && B) y) =
      toggleBy (bitIsOne x && B) y := by
  fin_cases x <;> fin_cases y <;> cases A <;> cases B <;> rfl

/-- The same identity exposed as a two-stage correction equation, convenient
when the child target value has already been rewritten by an induction
hypothesis. -/
theorem ordinary_pair_cancellation_after_child
    (x y : Fin 2) (A B : Bool) :
    let predecessorAfterLeft := toggleBy A x
    let targetAfterChild := toggleBy (A && B) y
    toggleBy (bitIsOne predecessorAfterLeft && B) targetAfterChild =
      toggleBy (bitIsOne x && B) y := by
  exact ordinary_pair_cancellation x y A B

end RemaudVandaeleLadderAlphaCancellationAlgebra
end QuantumBlockEncoding
