import QuantumBlockEncoding.PrimitiveSemantics
import Mathlib.Tactic

/-!
# Conditional computational-basis bit toggles

Parallelized overlapping reversible circuits repeatedly use the same local
algebra.  One stage changes a control bit conditionally, a recursive correction
changes a later target on the conjunction of that condition with a suffix
predicate, and a final stage reads the changed control.  The two target toggles
then cancel the correction and recover the source predicate on the original
control bit.

Remaud--Vandaele Algorithm 2 is one important consumer, but the lemma is stated
without circuit-specific geometry so later comparator/incrementer and state-
preparation constructions can reuse it.
-/

namespace QuantumBlockEncoding
namespace ConditionalBitToggle

/-- Toggle one computational-basis bit exactly when a proposition holds. -/
def toggleIf (condition : Prop) [Decidable condition]
    (bit : Fin 2) : Fin 2 :=
  if condition then flipBit bit else bit

@[simp] theorem toggleIf_true (bit : Fin 2) :
    toggleIf True bit = flipBit bit := by
  simp [toggleIf]

@[simp] theorem toggleIf_false (bit : Fin 2) :
    toggleIf False bit = bit := by
  simp [toggleIf]

/-- The local cancellation identity behind the odd/even wall recursion.

Interpretation:
* `x` is the original predecessor target;
* `A` is the left-wall activation that may flip `x`;
* `B` is the remaining suffix-control predicate;
* the recursive child toggles `y` on `A ∧ B`;
* the right wall toggles that corrected `y` when the modified predecessor is
  one and `B` holds.

The net effect is exactly the source toggle on the original predicate
`x = 1 ∧ B`. -/
theorem correction_then_modified_control
    (A B : Prop) [Decidable A] [Decidable B]
    (x y : Fin 2) :
    toggleIf (toggleIf A x = 1 ∧ B)
        (toggleIf (A ∧ B) y) =
      toggleIf (x = 1 ∧ B) y := by
  by_cases hA : A <;> by_cases hB : B <;>
    fin_cases x <;> fin_cases y <;>
    simp [toggleIf, hA, hB, flipBit]

/-- Conditional toggling is involutive when the condition is evaluated on an
unchanged external state. -/
theorem toggleIf_twice
    (condition : Prop) [Decidable condition]
    (bit : Fin 2) :
    toggleIf condition (toggleIf condition bit) = bit := by
  by_cases h : condition <;> fin_cases bit <;>
    simp [toggleIf, h, flipBit]

end ConditionalBitToggle
end QuantumBlockEncoding