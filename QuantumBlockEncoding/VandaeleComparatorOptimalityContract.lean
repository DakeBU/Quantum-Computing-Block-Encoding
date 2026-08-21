import QuantumBlockEncoding.VandaeleComparatorLowerBoundReduction
import QuantumBlockEncoding.VandaeleComparatorTheorem2Resource
import QuantumBlockEncoding.VandaeleComparatorTheorem3Resource

/-!
# Conditional optimality closure for Vandaele comparator theorems

The source upper constructions and lower-bound reductions are deliberately kept
separate throughout the library.  This module is the final bookkeeping layer:
once the external bounded-gate `C^k X` lower theorem is supplied in the same gate
model as the comparator circuits, the already-proved reductions close the
optimality claims automatically.

For Theorem 2, the construction has linear gate count, logarithmic depth, and no
ancillas.  The lower reduction supplies matching gate/depth lower bounds; no
ancilla lower bound is needed because zero is already minimal.

For Theorem 3, the construction uses one dirty ancilla.  Equation (3) supplies
hard classical constants for which `C^k X` embeds exactly, so one dirty ancilla
is necessary in the source bounded-size gate model for those instances.  This
establishes worst-case optimal qubit count for the uniform classical-comparator
family.
-/

namespace QuantumBlockEncoding
namespace VandaeleComparatorOptimalityContract

open VandaeleComparatorLowerBoundReduction
open VandaeleComparatorTheorem2Resource
open VandaeleComparatorTheorem3Resource

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
worst-case CQ optimality.  `upperGate`/`upperDepth` are uniform in the classical
constant, while the lower theorem is required only on the hard shifted constants
selected by Equation (3), exactly as in the source argument. -/
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

end VandaeleComparatorOptimalityContract
end QuantumBlockEncoding
