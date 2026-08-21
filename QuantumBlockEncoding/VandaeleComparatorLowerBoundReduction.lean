import QuantumBlockEncoding.VandaeleComparatorEq3Reduction
import QuantumBlockEncoding.VandaeleLemma1Contract
import Mathlib.Tactic

/-!
# Lower-bound transfer for Vandaele comparator theorems

Equation (3) gives an exact semantic reduction from `C^k X` to one
classical-quantum threshold comparator.  In the strict Equation-(29) convention,
the equivalent constant is `2^k-2` for k>=1, as proved in
`VandaeleComparatorEq3Reduction`.

This file keeps semantics and gate-model complexity separate.  The caller must
supply the resource inequality saying that reinterpreting the same comparator
circuit as the Equation-(3) `C^k X` implementation does not increase gate count,
depth, or ancilla count.  The known bounded-size-gate lower bounds from Lemma 1
then transfer mechanically.

For the quantum-quantum comparator, the source fixes one input register to a
classical constant, obtaining the classical-quantum comparator while allowing
ancilla qubits.  We therefore transfer only gate/depth lower bounds through that
second reduction; Theorem 2 itself correctly has zero ancillas.
-/

namespace QuantumBlockEncoding
namespace VandaeleComparatorLowerBoundReduction

open ComparatorIncrementerGeneral
open VandaeleLemma1Contract

/-- Gate-count resource edge justified by exact Equation (3), in one fixed gate
model.  `cqGate k c` is the minimum/certified complexity for the strict
Equation-(29) comparator with k address bits and constant c. -/
def EqThreeGateReductionBound
    (controlledXLower : Nat → Nat)
    (cqGate : Nat → Nat → Nat) : Prop :=
  ∀ k, 1 ≤ k →
    controlledXLower k ≤ cqGate k (gridSize k - 2)

/-- Depth analogue of the same source reduction. -/
def EqThreeDepthReductionBound
    (controlledXLower : Nat → Nat)
    (cqDepth : Nat → Nat → Nat) : Prop :=
  ∀ k, 1 ≤ k →
    controlledXLower k ≤ cqDepth k (gridSize k - 2)

/-- Ancilla-count analogue. -/
def EqThreeAncillaReductionBound
    (controlledXMinimumAncillas : Nat → Nat)
    (cqAncillas : Nat → Nat → Nat) : Prop :=
  ∀ k, 1 ≤ k →
    controlledXMinimumAncillas k ≤ cqAncillas k (gridSize k - 2)

/-- External odd-permutation obstruction used by Lemma 1. -/
def CkxAncillaLowerBoundTarget
    (minimumAncillas : Nat → Nat) : Prop :=
  ∀ k, 3 ≤ k → 1 ≤ minimumAncillas k

/-- Explicit lower-bound target for the Equation-(29) comparator family at the
hard constants selected by Equation (3). -/
def ClassicalComparatorTransferredLowerBoundTarget
    (cqGate cqDepth cqAncillas : Nat → Nat → Nat) : Prop :=
  (∀ k, 1 ≤ k →
    k ≤ cqGate k (gridSize k - 2)) ∧
  (∀ k, 1 ≤ k →
    Nat.log2 (k + 1) ≤ cqDepth k (gridSize k - 2)) ∧
  (∀ k, 3 ≤ k →
    1 ≤ cqAncillas k (gridSize k - 2))

/-- External `C^k X` gate/depth/ancilla lower bounds plus the exact Equation-(3)
resource edge give the classical-comparator lower half of Theorem 3. -/
theorem classicalComparator_lower_bound_transfer
    (controlledXGateLower controlledXDepthLower
      controlledXMinimumAncillas : Nat → Nat)
    (cqGate cqDepth cqAncillas : Nat → Nat → Nat)
    (externalGateDepth :
      BoundedGateLowerBoundTarget
        controlledXGateLower controlledXDepthLower)
    (externalAncilla :
      CkxAncillaLowerBoundTarget controlledXMinimumAncillas)
    (gateReduction :
      EqThreeGateReductionBound controlledXGateLower cqGate)
    (depthReduction :
      EqThreeDepthReductionBound controlledXDepthLower cqDepth)
    (ancillaReduction :
      EqThreeAncillaReductionBound controlledXMinimumAncillas cqAncillas) :
    ClassicalComparatorTransferredLowerBoundTarget cqGate cqDepth cqAncillas := by
  rcases externalGateDepth with
    ⟨⟨gateConstant, gatePositive, gateLower⟩,
      ⟨depthConstant, depthPositive, depthLower⟩⟩
  constructor
  · intro k positive
    have oneLe : 1 ≤ gateConstant := by omega
    have scale : k ≤ gateConstant * k := by
      have := Nat.mul_le_mul_right k oneLe
      simpa using this
    exact scale.trans ((gateLower k).trans (gateReduction k positive))
  · constructor
    · intro k positive
      have oneLe : 1 ≤ depthConstant := by omega
      have scale :
          Nat.log2 (k + 1) ≤ depthConstant * Nat.log2 (k + 1) := by
        have := Nat.mul_le_mul_right (Nat.log2 (k + 1)) oneLe
        simpa using this
      exact scale.trans ((depthLower k).trans (depthReduction k positive))
    · intro k large
      exact (externalAncilla k large).trans
        (ancillaReduction k (by omega))

/-- Resource edge obtained by fixing one QQ input register to the classical hard
constant.  The source allows ancilla qubits for this reduction, so only gate
count and depth are transferred. -/
def ClassicalFromQuantumGateReductionBound
    (cqGateLower qqGate : Nat → Nat) : Prop :=
  ∀ k, cqGateLower k ≤ qqGate k

def ClassicalFromQuantumDepthReductionBound
    (cqDepthLower qqDepth : Nat → Nat) : Prop :=
  ∀ k, cqDepthLower k ≤ qqDepth k

/-- Public lower-bound target for the QQ comparator family. -/
def QuantumComparatorTransferredLowerBoundTarget
    (qqGate qqDepth : Nat → Nat) : Prop :=
  (∀ k, 1 ≤ k → k ≤ qqGate k) ∧
  (∀ k, 1 ≤ k → Nat.log2 (k + 1) ≤ qqDepth k)

/-- Any QQ family that can be restricted to the hard CQ family inherits the
same linear/logarithmic lower bounds, while making no ancilla lower-bound claim. -/
theorem quantumComparator_lower_bound_transfer
    (cqGateLower cqDepthLower qqGate qqDepth : Nat → Nat)
    (cqLower :
      (∀ k, 1 ≤ k → k ≤ cqGateLower k) ∧
      (∀ k, 1 ≤ k → Nat.log2 (k + 1) ≤ cqDepthLower k))
    (gateReduction :
      ClassicalFromQuantumGateReductionBound cqGateLower qqGate)
    (depthReduction :
      ClassicalFromQuantumDepthReductionBound cqDepthLower qqDepth) :
    QuantumComparatorTransferredLowerBoundTarget qqGate qqDepth := by
  constructor
  · intro k positive
    exact (cqLower.1 k positive).trans (gateReduction k)
  · intro k positive
    exact (cqLower.2 k positive).trans (depthReduction k)

end VandaeleComparatorLowerBoundReduction
end QuantumBlockEncoding
