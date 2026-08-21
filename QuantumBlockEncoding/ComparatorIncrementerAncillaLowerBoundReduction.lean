import QuantumBlockEncoding.ComparatorIncrementerLowerBoundReduction
import Mathlib.Tactic

/-!
# Ancilla lower-bound transfer through Vandaele Equation (2)

The source parity argument says that, for `k >= 3`, `C^k X` cannot be
implemented over `{CCX,CX,X}` without an additional qubit.  Equation (2) then
transfers that lower bound to incrementers: the `(k+1)`-bit increment circuit
and the k-bit decrement circuit may reuse the same workspace, so the composite
controlled-X construction uses the maximum of their workspace counts rather
than their sum.

ASPBE keeps the parity theorem itself external/source-backed.  This file proves
only the exact conditional resource transfer once a gate-model minimum-ancilla
function for `C^k X` is supplied.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerAncillaLowerBoundReduction

/-- Workspace form of Equation (2): sequential increment/decrement stages can
reuse the same auxiliary register, so their composite needs at most the larger
of the two ancillary widths. -/
def EqTwoAncillaReductionBound
    (controlledXMinimumAncillas incrementAncillas decrementAncillas : Nat → Nat) :
    Prop :=
  ∀ k,
    controlledXMinimumAncillas k ≤
      max (incrementAncillas (k + 1)) (decrementAncillas k)

/-- External/source lower-bound interface for the parity obstruction. -/
def ControlledXNeedsAncilla
    (controlledXMinimumAncillas : Nat → Nat) : Prop :=
  ∀ k, 3 ≤ k → 1 ≤ controlledXMinimumAncillas k

/-- Resulting minimum-ancilla target for incrementers. -/
def IncrementerNeedsAncilla
    (incrementAncillas : Nat → Nat) : Prop :=
  ∀ k, 3 ≤ k → 1 ≤ incrementAncillas (k + 1)

/-- If decrement is circuit reversal of increment and minimum incrementer
workspace is monotone with width, the Equation-(2) construction uses exactly no
more workspace than the `(k+1)`-bit incrementer itself. -/
theorem eqTwo_ancilla_bound_reduces_to_larger_incrementer
    (controlledXMinimumAncillas incrementAncillas decrementAncillas : Nat → Nat)
    (reduction : EqTwoAncillaReductionBound
      controlledXMinimumAncillas incrementAncillas decrementAncillas)
    (inverseSameAncillas : ∀ k,
      decrementAncillas k = incrementAncillas k)
    (monotone : ∀ k,
      incrementAncillas k ≤ incrementAncillas (k + 1)) :
    ∀ k,
      controlledXMinimumAncillas k ≤ incrementAncillas (k + 1) := by
  intro k
  have source := reduction k
  rw [inverseSameAncillas k] at source
  have order := monotone k
  have maximum :
      max (incrementAncillas (k + 1)) (incrementAncillas k) =
        incrementAncillas (k + 1) :=
    max_eq_left order
  simpa [maximum] using source

/-- Conditional minimal-qubit transfer used by the source optimality argument.
The external parity obstruction plus Equation (2) forces every `(k+1)`-bit
incrementer, for `k >= 3`, to use at least one auxiliary qubit in the same gate
model. -/
theorem transferred_incrementer_ancilla_lower_bound
    (controlledXMinimumAncillas incrementAncillas decrementAncillas : Nat → Nat)
    (externalLower : ControlledXNeedsAncilla controlledXMinimumAncillas)
    (reduction : EqTwoAncillaReductionBound
      controlledXMinimumAncillas incrementAncillas decrementAncillas)
    (inverseSameAncillas : ∀ k,
      decrementAncillas k = incrementAncillas k)
    (monotone : ∀ k,
      incrementAncillas k ≤ incrementAncillas (k + 1)) :
    IncrementerNeedsAncilla incrementAncillas := by
  have reductionToLarge :=
    eqTwo_ancilla_bound_reduces_to_larger_incrementer
      controlledXMinimumAncillas incrementAncillas decrementAncillas
      reduction inverseSameAncillas monotone
  intro k large
  exact (externalLower k large).trans (reductionToLarge k)

end ComparatorIncrementerAncillaLowerBoundReduction
end QuantumBlockEncoding