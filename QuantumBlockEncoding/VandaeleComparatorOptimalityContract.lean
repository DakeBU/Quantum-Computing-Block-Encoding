import QuantumBlockEncoding.VandaeleComparatorLowerBoundReduction
import QuantumBlockEncoding.VandaeleComparatorTheorem2Resource
import QuantumBlockEncoding.VandaeleComparatorTheorem3Resource
import QuantumBlockEncoding.VandaeleLemma1ParityLowerBound

/-!
# Conditional optimality closure for Vandaele comparator theorems

The source upper constructions and lower-bound reductions are deliberately kept
separate throughout the library.  This module is the final bookkeeping layer.
The bounded-gate `C^k X` gate/depth lower theorem remains a cited input in the
same gate model as the comparator circuits.  The ancilla parity obstruction is
now proved internally by `VandaeleLemma1ParityLowerBound`.

For Theorem 2, the construction has linear gate count, logarithmic depth, and no
ancillas.  The lower reduction supplies matching gate/depth lower bounds; no
ancilla lower bound is needed because zero is already minimal.

For Theorem 3, the construction uses one dirty ancilla.  Equation (3) supplies
hard classical constants for which `C^k X` embeds exactly; the internal parity
proof then forces one ancillary qubit on those hard instances once the numerical
minimum-ancilla function is linked to zero-ancilla circuit existence.
-/

namespace QuantumBlockEncoding
namespace VandaeleComparatorOptimalityContract

open VandaeleComparatorLowerBoundReduction
open VandaeleComparatorTheorem2Resource
open VandaeleComparatorTheorem3Resource
open VandaeleLemma1ParityLowerBound

/-- Explicit two-sided asymptotic target for one QQ construction/minimum pair. -/
def QuantumComparatorOptimalityTarget
    (constructedGate constructedDepth constructedAncillas : Nat → Nat)
    (minimumGate minimumDepth : Nat → Nat) : Prop :=
  TheoremTwoUpperTarget constructedGate constructedDepth constructedAncillas ∧
  QuantumComparatorTransferredLowerBoundTarget minimumGate minimumDepth

/-- Upper Theorem-2 evidence and transferred QQ lower evidence close the target
without any additional arithmetic. -/
theorem quantumComparator_optimality_closure
    (constructedGate constructedDepth constructedAncillas : Nat → Nat)
    (minimumGate minimumDepth : Nat → Nat)
    (upper :
      TheoremTwoUpperTarget constructedGate constructedDepth constructedAncillas)
    (lower :
      QuantumComparatorTransferredLowerBoundTarget minimumGate minimumDepth) :
    QuantumComparatorOptimalityTarget
      constructedGate constructedDepth constructedAncillas
      minimumGate minimumDepth :=
  ⟨upper, lower⟩

/-- Hard-instance lower target for the source CQ family. -/
def ClassicalHardInstanceOptimalityTarget
    (constructedGate constructedDepth constructedDirty : Nat → Nat → Nat)
    (minimumGate minimumDepth minimumAncillas : Nat → Nat → Nat) : Prop :=
  (∃ gateConstant : Nat, ∀ n constant,
    constructedGate n constant ≤ gateConstant * (n + 1)) ∧
  (∃ depthConstant : Nat, ∀ n constant,
    constructedDepth n constant ≤ depthConstant *
      (ComparatorIncrementerTheorem4DepthBound.logRank n)) ∧
  (∀ n constant, constructedDirty n constant = 1) ∧
  ClassicalComparatorTransferredLowerBoundTarget
    minimumGate minimumDepth minimumAncillas

/-- Theorem-3 upper family and Equation-(3) transferred lower bounds close
worst-case CQ optimality. -/
theorem classicalComparator_optimality_closure
    (constructedGate constructedDepth constructedDirty : Nat → Nat → Nat)
    (minimumGate minimumDepth minimumAncillas : Nat → Nat → Nat)
    (gateConstant depthConstant : Nat)
    (upperGate : ∀ n constant,
      constructedGate n constant ≤ gateConstant * (n + 1))
    (upperDepth : ∀ n constant,
      constructedDepth n constant ≤ depthConstant *
        ComparatorIncrementerTheorem4DepthBound.logRank n)
    (oneDirty : ∀ n constant, constructedDirty n constant = 1)
    (lower :
      ClassicalComparatorTransferredLowerBoundTarget
        minimumGate minimumDepth minimumAncillas) :
    ClassicalHardInstanceOptimalityTarget
      constructedGate constructedDepth constructedDirty
      minimumGate minimumDepth minimumAncillas := by
  exact ⟨⟨gateConstant, upperGate⟩,
    ⟨depthConstant, upperDepth⟩, oneDirty, lower⟩

/-- Same classical-comparator optimality closure with the C^kX ancillary lower
premise discharged by the repository's parity theorem.  The bounded-gate
linear/logarithmic lower theorem and Equation-(3) resource inequalities remain
explicit source/model inputs. -/
theorem classicalComparator_optimality_from_parity
    (constructedGate constructedDepth constructedDirty : Nat → Nat → Nat)
    (minimumGate minimumDepth minimumAncillas : Nat → Nat → Nat)
    (controlledXGateLower controlledXDepthLower
      controlledXMinimumAncillas : Nat → Nat)
    (controlledXModel : MinimumAncillaModel controlledXMinimumAncillas)
    (externalGateDepth :
      VandaeleLemma1Contract.BoundedGateLowerBoundTarget
        controlledXGateLower controlledXDepthLower)
    (gateReduction : EqThreeGateReductionBound controlledXGateLower minimumGate)
    (depthReduction : EqThreeDepthReductionBound controlledXDepthLower minimumDepth)
    (ancillaReduction :
      EqThreeAncillaReductionBound controlledXMinimumAncillas minimumAncillas)
    (gateConstant depthConstant : Nat)
    (upperGate : ∀ n constant,
      constructedGate n constant ≤ gateConstant * (n + 1))
    (upperDepth : ∀ n constant,
      constructedDepth n constant ≤ depthConstant *
        ComparatorIncrementerTheorem4DepthBound.logRank n)
    (oneDirty : ∀ n constant, constructedDirty n constant = 1) :
    ClassicalHardInstanceOptimalityTarget
      constructedGate constructedDepth constructedDirty
      minimumGate minimumDepth minimumAncillas := by
  have lower := classicalComparator_lower_bound_from_parity
    controlledXGateLower controlledXDepthLower controlledXMinimumAncillas
    minimumGate minimumDepth minimumAncillas
    controlledXModel externalGateDepth gateReduction depthReduction ancillaReduction
  exact classicalComparator_optimality_closure
    constructedGate constructedDepth constructedDirty
    minimumGate minimumDepth minimumAncillas
    gateConstant depthConstant upperGate upperDepth oneDirty lower

end VandaeleComparatorOptimalityContract
end QuantumBlockEncoding
