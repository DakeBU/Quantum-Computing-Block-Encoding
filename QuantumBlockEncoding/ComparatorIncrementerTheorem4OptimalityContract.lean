import QuantumBlockEncoding.ComparatorIncrementerAncillaLowerBoundReduction
import QuantumBlockEncoding.ComparatorIncrementerLowerBoundReduction
import QuantumBlockEncoding.ComparatorIncrementerTheorem4ResourceClosure
import QuantumBlockEncoding.VandaeleLemma1ParityLowerBound
import Mathlib.Tactic

/-!
# Conditional optimality closure for Vandaele Theorem 4

Theorem 4 has three logically different parts:

1. a concrete incrementer family with O(n) gates and O(log n) depth;
2. matching gate/depth lower bounds transferred from `C^k X` through Equation (2);
3. one auxiliary qubit, together with the parity obstruction showing that zero
   auxiliary qubits are impossible in the same `{X,CX,CCX}` gate model.

The gate/depth lower theorem remains the cited bounded-gate result.  The ancilla
parity obstruction is now proved internally in `VandaeleLemma1ParityLowerBound`.
This module packages the final comparison while keeping minimum-resource
functions and construction-resource functions explicitly distinct.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerTheorem4OptimalityContract

open ComparatorIncrementerAncillaLowerBoundReduction
open ComparatorIncrementerLowerBoundReduction
open ComparatorIncrementerTheorem4DepthBound
open ComparatorIncrementerTheorem4ResourceClosure
open VandaeleLemma1ParityLowerBound

/-- Explicit gate/depth sandwich between one construction and the minimum
complexity in the same gate model. -/
def GateDepthOptimalitySandwich
    (constructedGate constructedDepth
      minimumGate minimumDepth : Nat → Nat) : Prop :=
  (∀ n, minimumGate n ≤ constructedGate n) ∧
  (∀ n, minimumDepth n ≤ constructedDepth n) ∧
  (∀ k, k ≤ 2 * minimumGate (k + 1)) ∧
  (∀ k, Nat.log2 (k + 1) ≤ 2 * minimumDepth (k + 1)) ∧
  TheoremFourUpperResourceTarget constructedGate constructedDepth

/-- The upper/lower resource interfaces compose directly into a same-model
optimality sandwich. -/
theorem gateDepth_optimality_closure
    (constructedGate constructedDepth
      minimumGate minimumDepth : Nat → Nat)
    (constructionUpper :
      TheoremFourUpperResourceTarget constructedGate constructedDepth)
    (minimumLower :
      IncrementerTransferredLowerBoundTarget minimumGate minimumDepth)
    (minimumLeConstructionGate : ∀ n,
      minimumGate n ≤ constructedGate n)
    (minimumLeConstructionDepth : ∀ n,
      minimumDepth n ≤ constructedDepth n) :
    GateDepthOptimalitySandwich
      constructedGate constructedDepth minimumGate minimumDepth := by
  exact ⟨minimumLeConstructionGate,
    minimumLeConstructionDepth,
    minimumLower.1,
    minimumLower.2,
    constructionUpper⟩

/-- Reader-facing explicit linear upper/lower form for gate complexity. -/
theorem gate_sandwich_pointwise
    (constructedGate minimumGate : Nat → Nat)
    (upperConstant : Nat)
    (upper : ∀ n,
      constructedGate n ≤ upperConstant * (n + 1))
    (lower : ∀ k,
      k ≤ 2 * minimumGate (k + 1))
    (minimumLeConstruction : ∀ n,
      minimumGate n ≤ constructedGate n)
    (k : Nat) :
    k ≤ 2 * constructedGate (k + 1) ∧
      constructedGate (k + 1) ≤ upperConstant * (k + 2) := by
  constructor
  · exact (lower k).trans
      (Nat.mul_le_mul_left 2 (minimumLeConstruction (k + 1)))
  · simpa [Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] using
      upper (k + 1)

/-- Pointwise logarithmic depth sandwich. -/
theorem depth_sandwich_pointwise
    (constructedDepth minimumDepth : Nat → Nat)
    (upperConstant : Nat)
    (upper : ∀ n,
      constructedDepth n ≤ upperConstant * logRank n)
    (lower : ∀ k,
      Nat.log2 (k + 1) ≤ 2 * minimumDepth (k + 1))
    (minimumLeConstruction : ∀ n,
      minimumDepth n ≤ constructedDepth n)
    (k : Nat) :
    Nat.log2 (k + 1) ≤ 2 * constructedDepth (k + 1) ∧
      constructedDepth (k + 1) ≤ upperConstant * logRank (k + 1) := by
  exact ⟨(lower k).trans
      (Nat.mul_le_mul_left 2 (minimumLeConstruction (k + 1))),
    upper (k + 1)⟩

/-- Same-model auxiliary-qubit sandwich: the concrete family uses at most one
auxiliary qubit and the minimum complexity needs at least one for the source
regime. -/
def AncillaOptimalitySandwich
    (constructedAncillas minimumAncillas : Nat → Nat) : Prop :=
  (∀ n, minimumAncillas n ≤ constructedAncillas n) ∧
  (∀ n, constructedAncillas n ≤ 1) ∧
  (∀ k, 3 ≤ k → 1 ≤ minimumAncillas (k + 1))

/-- If the construction uses at most one extra qubit and the transferred parity
lower bound forces at least one, then it is ancilla-optimal for widths >= 4. -/
theorem ancilla_optimality_closure
    (constructedAncillas minimumAncillas : Nat → Nat)
    (minimumLeConstruction : ∀ n,
      minimumAncillas n ≤ constructedAncillas n)
    (constructionAtMostOne : ∀ n,
      constructedAncillas n ≤ 1)
    (minimumNeedsOne : IncrementerNeedsAncilla minimumAncillas) :
    AncillaOptimalitySandwich constructedAncillas minimumAncillas := by
  exact ⟨minimumLeConstruction, constructionAtMostOne, minimumNeedsOne⟩

/-- Same optimality closure with the C^kX ancilla premise discharged by the
internal parity proof.  The remaining assumptions are exactly the Equation-(2)
workspace reduction and the minimum-complexity model relations. -/
theorem ancilla_optimality_from_parity
    (controlledXMinimumAncillas incrementAncillas decrementAncillas
      constructedAncillas : Nat → Nat)
    (controlledXModel : MinimumAncillaModel controlledXMinimumAncillas)
    (eqTwoReduction : EqTwoAncillaReductionBound
      controlledXMinimumAncillas incrementAncillas decrementAncillas)
    (inverseSameAncillas : ∀ k,
      decrementAncillas k = incrementAncillas k)
    (minimumMonotone : ∀ k,
      incrementAncillas k ≤ incrementAncillas (k + 1))
    (minimumLeConstruction : ∀ n,
      incrementAncillas n ≤ constructedAncillas n)
    (constructionAtMostOne : ∀ n,
      constructedAncillas n ≤ 1) :
    AncillaOptimalitySandwich constructedAncillas incrementAncillas := by
  have lower := transferred_incrementer_lower_bound_from_parity
    controlledXMinimumAncillas incrementAncillas decrementAncillas
    controlledXModel eqTwoReduction inverseSameAncillas minimumMonotone
  exact ancilla_optimality_closure
    constructedAncillas incrementAncillas
    minimumLeConstruction constructionAtMostOne lower

/-- In the source lower-bound regime, both minimum and construction ancillary
counts are exactly one. -/
theorem ancilla_exactly_one
    (constructedAncillas minimumAncillas : Nat → Nat)
    (sandwich :
      AncillaOptimalitySandwich constructedAncillas minimumAncillas)
    (k : Nat) (large : 3 ≤ k) :
    minimumAncillas (k + 1) = 1 ∧
      constructedAncillas (k + 1) = 1 := by
  have minimumLower := sandwich.2.2 k large
  have constructionUpper := sandwich.2.1 (k + 1)
  have minimumToConstruction := sandwich.1 (k + 1)
  constructor <;> omega

end ComparatorIncrementerTheorem4OptimalityContract
end QuantumBlockEncoding
