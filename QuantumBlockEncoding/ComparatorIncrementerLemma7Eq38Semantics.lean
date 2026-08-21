import QuantumBlockEncoding.ComparatorIncrementerControlledSplit
import QuantumBlockEncoding.ComparatorIncrementerLemma7BasisContract
import QuantumBlockEncoding.VandaeleLemma5SplitBudget
import Mathlib.Tactic

/-!
# Vandaele Equation (38): controlled half-split semantics

Equation (38) is the register-halving identity used inside Lemma 7.  Before
committing to the source's concrete promise-register gate layout, ASPBE fixes
the exact arithmetic target of that layout.

Let

* `low = floor(n/2)`,
* `high = ceil(n/2)`.

For k external controls, the target register is unchanged unless every control
is one.  On the active branch it is incremented modulo `2^(low+high)`.  The
existing controlled-split theorem then proves that this action is exactly:

* increment the low block modulo `2^low`;
* emit one carry iff the active low block overflows;
* increment the high block modulo `2^high` iff that carry is one.

This is the semantic refinement target for the future Figure-9 / Equation-(38)
`ReversibleProgram`; no resource claim is attached to the semantic permutation.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma7Eq38Semantics

open ComparatorIncrementerControlledSplit
open ComparatorIncrementerGeneral
open ComparatorIncrementerLemma7BasisContract
open ComparatorIncrementerLemma7Contract
open PredicateControlledConjugation
open VandaeleLemma5SplitBudget
open ZModPrimitiveBasisBridge

/-- Source lower half. -/
def eq38LowWidth (n : Nat) : Nat := lowerHalf n

/-- Source upper/ceiling half. -/
def eq38HighWidth (n : Nat) : Nat := upperHalf n

@[simp] theorem eq38_width_partition (n : Nat) :
    eq38LowWidth n + eq38HighWidth n = n := by
  unfold eq38LowWidth eq38HighWidth
  exact halves_partition n

/-- Exact controlled full-word target before exposing its low/high arithmetic. -/
def eq38SemanticEquiv (k n : Nat) :
    Equiv.Perm
      (PrimitiveBasis k ×
        PrimitiveBasis (eq38LowWidth n + eq38HighWidth n)) :=
  predicateControlledTargetEquiv
    allControlsActive
    (basisModularIncrementEquiv (eq38LowWidth n + eq38HighWidth n))

/-- External controls are preserved. -/
theorem eq38Semantic_preserves_controls
    (k n : Nat)
    (controls : PrimitiveBasis k)
    (state : PrimitiveBasis (eq38LowWidth n + eq38HighWidth n)) :
    (eq38SemanticEquiv k n (controls, state)).1 = controls := by
  cases condition : allControlsActive controls <;>
    simp [eq38SemanticEquiv, predicateControlledTargetEquiv, condition]

/-- Numeric action of the controlled basis permutation is exactly the
whole-word controlled increment used by `ComparatorIncrementerControlledSplit`. -/
theorem eq38Semantic_numeric_action
    (k n : Nat)
    (controls : PrimitiveBasis k)
    (state : PrimitiveBasis (eq38LowWidth n + eq38HighWidth n)) :
    basisNat (eq38LowWidth n + eq38HighWidth n)
        (eq38SemanticEquiv k n (controls, state)).2 =
      controlledIncrementValue
        (eq38LowWidth n) (eq38HighWidth n)
        (allControlsActive controls)
        (primitiveBasisLEEquiv
          (eq38LowWidth n + eq38HighWidth n) state) := by
  cases condition : allControlsActive controls with
  | false =>
      simp [eq38SemanticEquiv, predicateControlledTargetEquiv,
        controlledIncrementValue, basisNat, condition]
  | true =>
      have increment :=
        basisModularIncrement_satisfies_spec
          (eq38LowWidth n + eq38HighWidth n) state
      unfold IncrementerSpec at increment
      simp [eq38SemanticEquiv, predicateControlledTargetEquiv,
        controlledIncrementValue, condition]
      exact increment

/-- Equation-(38) arithmetic decomposition: the controlled whole-word target
recomposes from the controlled low successor and the carry-updated high block. -/
theorem eq38Semantic_recomposition
    (k n : Nat)
    (controls : PrimitiveBasis k)
    (state : PrimitiveBasis (eq38LowWidth n + eq38HighWidth n)) :
    basisNat (eq38LowWidth n + eq38HighWidth n)
        (eq38SemanticEquiv k n (controls, state)).2 =
      controlledLowValue
          (eq38LowWidth n) (eq38HighWidth n)
          (allControlsActive controls)
          (primitiveBasisLEEquiv
            (eq38LowWidth n + eq38HighWidth n) state) +
        gridSize (eq38LowWidth n) *
          controlledHighValue
            (eq38LowWidth n) (eq38HighWidth n)
            (allControlsActive controls)
            (primitiveBasisLEEquiv
              (eq38LowWidth n + eq38HighWidth n) state) := by
  rw [eq38Semantic_numeric_action]
  exact controlled_increment_recomposition
    (eq38LowWidth n) (eq38HighWidth n)
    (allControlsActive controls)
    (primitiveBasisLEEquiv
      (eq38LowWidth n + eq38HighWidth n) state)

/-- The high-half carry condition is active exactly when all external controls
are one and the low half overflows. -/
theorem eq38Semantic_carry_iff
    (k n : Nat)
    (controls : PrimitiveBasis k)
    (state : PrimitiveBasis (eq38LowWidth n + eq38HighWidth n)) :
    controlledCarry
        (eq38LowWidth n) (eq38HighWidth n)
        (allControlsActive controls)
        (primitiveBasisLEEquiv
          (eq38LowWidth n + eq38HighWidth n) state) = 1 ↔
      allControlsActive controls = true ∧
        gridSize (eq38LowWidth n) ∣
          (primitiveBasisLEEquiv
            (eq38LowWidth n + eq38HighWidth n) state).val + 1 := by
  exact controlledCarry_eq_one_iff
    (eq38LowWidth n) (eq38HighWidth n)
    (allControlsActive controls)
    (primitiveBasisLEEquiv
      (eq38LowWidth n + eq38HighWidth n) state)

end ComparatorIncrementerLemma7Eq38Semantics
end QuantumBlockEncoding
