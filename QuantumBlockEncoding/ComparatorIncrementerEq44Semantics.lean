import QuantumBlockEncoding.ComparatorIncrementerModularConjugation
import QuantumBlockEncoding.ComparatorIncrementerRecurrence
import QuantumBlockEncoding.ComparatorIncrementerRecursiveSplit
import Mathlib.Tactic

/-!
# Semantic constructor behind Vandaele Eq. (44)

Equation (44) in the proof of Theorem 4 combines three ingredients already
separated in ASPBE:

* Eq. (34): split an increment into a low-block successor plus one carry into
  the high block;
* Eq. (36): use an increment/decrement inverse pair to condition a modular
  increment on that carry while restoring an unknown dirty bit;
* the Theorem 4 split `alpha = 2 ceil(sqrt n)`, `beta = n-alpha`.

This file closes the semantic composition without yet claiming the concrete
Figure 10 promise-register circuit or its asymptotic resource analysis.  In
particular, the high register below is represented algebraically by `ZMod`; a
later representation theorem must identify the source's concrete high-register
circuit with this modular action.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerEq44Semantics

open ComparatorIncrementerModularConjugation
open ComparatorIncrementerRecurrence
open ComparatorIncrementerRecursiveSplit

/-- Boolean carry predicate for the low block in Eq. (34). -/
def carryControl (lowWidth highWidth : Nat)
    (word : Fin (gridSize (lowWidth + highWidth))) : Bool :=
  if incrementCarry lowWidth highWidth word = 1 then true else false

/-- The Boolean control is true exactly on the arithmetic overflow event used
by the recursive split. -/
theorem carryControl_true_iff
    (lowWidth highWidth : Nat)
    (word : Fin (gridSize (lowWidth + highWidth))) :
    carryControl lowWidth highWidth word = true ↔
      gridSize lowWidth ∣ word.val + 1 := by
  constructor
  · intro active
    by_cases carry : incrementCarry lowWidth highWidth word = 1
    · exact (incrementCarry_eq_one_iff lowWidth highWidth word).mp carry
    · simp [carryControl, carry] at active
  · intro overflow
    have carry :=
      (incrementCarry_eq_one_iff lowWidth highWidth word).mpr overflow
    simp [carryControl, carry]

/-- The source's dirty-ancilla increment/decrement protocol increments the high
modular register exactly when the low block emits a carry. -/
theorem dirtyHighIncrement_action
    (lowWidth highWidth : Nat)
    (word : Fin (gridSize (lowWidth + highWidth)))
    (dirty : Bool) (highValue : ZMod (gridSize highWidth)) :
    dirtyControlledConjugationProtocolEquiv
        (carryControl lowWidth highWidth)
        (modularComplementEquiv (gridSize highWidth))
        (modularIncrementEquiv (gridSize highWidth))
        (modularIncrementEquiv (gridSize highWidth)).symm
        (word, dirty, highValue) =
      (word, dirty,
        if incrementCarry lowWidth highWidth word = 1 then
          modularIncrementEquiv (gridSize highWidth) highValue
        else highValue) := by
  have sourceAction := dirtyControlledModularIncrement_action
    (gridSize highWidth)
    (carryControl lowWidth highWidth)
    word dirty highValue
  simpa [carryControl] using sourceAction

/-- The unknown dirty bit is restored independently of whether the low block
carries. -/
theorem dirtyHighIncrement_restoresFlag
    (lowWidth highWidth : Nat)
    (word : Fin (gridSize (lowWidth + highWidth)))
    (dirty : Bool) (highValue : ZMod (gridSize highWidth)) :
    (dirtyControlledConjugationProtocolEquiv
        (carryControl lowWidth highWidth)
        (modularComplementEquiv (gridSize highWidth))
        (modularIncrementEquiv (gridSize highWidth))
        (modularIncrementEquiv (gridSize highWidth)).symm
        (word, dirty, highValue)).2.1 = dirty := by
  exact dirtyControlledModularIncrement_restoresFlag
    (gridSize highWidth)
    (carryControl lowWidth highWidth)
    word dirty highValue

/-- Numeric Eq. (34) recomposition used by Eq. (44).  This alias records the
exact place where the gate-level constructor must eventually connect to the
already-proved arithmetic semantics. -/
theorem increment_recomposition
    (lowWidth highWidth : Nat)
    (word : Fin (gridSize (lowWidth + highWidth))) :
    (word.val + 1) % gridSize (lowWidth + highWidth) =
      incrementLowValue lowWidth highWidth word +
        gridSize lowWidth * incrementHighValue lowWidth highWidth word :=
  increment_eq_low_plus_high lowWidth highWidth word

/-- Theorem 4's chosen block widths, written in the low-then-high order used by
`ComparatorIncrementerRecursiveSplit`. -/
theorem theoremFour_width_partition
    {n : Nat} (large : 7 ≤ n) : beta n + alpha n = n := by
  have partition := alpha_add_beta large
  omega

/-- A finite-index transport from the low/high split register back to the
original n-bit flat register. -/
def theoremFourWordEquiv (n : Nat) (large : 7 ≤ n) :
    Fin (gridSize (beta n + alpha n)) ≃ Fin (gridSize n) :=
  finCongr (by rw [theoremFour_width_partition large])

/-- Eq. (44) high-block dirty protocol specialized to the exact Theorem 4 split.
The high modular register is incremented iff the beta-bit low block overflows. -/
theorem theoremFour_dirtyHighIncrement_action
    (n : Nat) (large : 7 ≤ n)
    (word : Fin (gridSize (beta n + alpha n)))
    (dirty : Bool) (highValue : ZMod (gridSize (alpha n))) :
    dirtyControlledConjugationProtocolEquiv
        (carryControl (beta n) (alpha n))
        (modularComplementEquiv (gridSize (alpha n)))
        (modularIncrementEquiv (gridSize (alpha n)))
        (modularIncrementEquiv (gridSize (alpha n))).symm
        (word, dirty, highValue) =
      (word, dirty,
        if incrementCarry (beta n) (alpha n) word = 1 then
          modularIncrementEquiv (gridSize (alpha n)) highValue
        else highValue) := by
  exact dirtyHighIncrement_action (beta n) (alpha n) word dirty highValue

/-- The corresponding dirty-workspace restoration theorem at the Theorem 4
split. -/
theorem theoremFour_dirtyHighIncrement_restoresFlag
    (n : Nat) (large : 7 ≤ n)
    (word : Fin (gridSize (beta n + alpha n)))
    (dirty : Bool) (highValue : ZMod (gridSize (alpha n))) :
    (dirtyControlledConjugationProtocolEquiv
        (carryControl (beta n) (alpha n))
        (modularComplementEquiv (gridSize (alpha n)))
        (modularIncrementEquiv (gridSize (alpha n)))
        (modularIncrementEquiv (gridSize (alpha n))).symm
        (word, dirty, highValue)).2.1 = dirty := by
  exact dirtyHighIncrement_restoresFlag
    (beta n) (alpha n) word dirty highValue

/-- The arithmetic output of the same split recomposes to the n-bit successor.
The equality is stated before transporting by `theoremFourWordEquiv`, so no
register-order convention is hidden. -/
theorem theoremFour_increment_recomposition
    (n : Nat) (large : 7 ≤ n)
    (word : Fin (gridSize (beta n + alpha n))) :
    (word.val + 1) % gridSize (beta n + alpha n) =
      incrementLowValue (beta n) (alpha n) word +
        gridSize (beta n) * incrementHighValue (beta n) (alpha n) word := by
  exact increment_recomposition (beta n) (alpha n) word

/-- The split really corresponds to the original n-bit modulus. -/
theorem theoremFour_modulus_eq
    (n : Nat) (large : 7 ≤ n) :
    gridSize (beta n + alpha n) = gridSize n := by
  rw [theoremFour_width_partition large]

end ComparatorIncrementerEq44Semantics
end QuantumBlockEncoding
