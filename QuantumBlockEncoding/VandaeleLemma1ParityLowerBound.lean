import QuantumBlockEncoding.ComparatorIncrementerAncillaLowerBoundReduction
import QuantumBlockEncoding.ReversibleGateParityLowerBound
import QuantumBlockEncoding.VandaeleComparatorLowerBoundReduction

/-!
# Internal parity proof of the Lemma-1 ancilla lower bound

The gate/depth lower bounds for `C^k X` remain cited bounded-gate-set results.
The *ancilla* lower bound no longer needs to remain external in ASPBE.

`ReversibleGateParityLowerBound` proves that for k>=3:

* every ancilla-free `{X,CX,CCX}` program on the k+1 data wires is even;
* the canonical flat `C^k X` target is odd;
* therefore no such ancilla-free program exists.

To connect this semantic impossibility to a numerical minimum-ancilla function,
we state the only model assumption needed: minimum ancilla count is zero exactly
when an ancilla-free program exists in this same reversible gate model.  The
parity theorem then forces that minimum to be at least one.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma1ParityLowerBound

open ReversibleGateParityLowerBound

/-- Existence of an ancilla-free implementation in ASPBE's reversible gate IR. -/
def AncillaFreeProgramExists (k : Nat) : Prop :=
  ∃ program : ReversibleProgram (k + 1),
    evalReversibleProgram program = flatMultiControlledXEquiv k

/-- Connection between a numerical minimum-ancilla complexity function and the
actual zero-ancilla circuit-existence problem.  No assumption is made about
positive values beyond this zero/nonzero equivalence. -/
def MinimumAncillaModel (minimumAncillas : Nat -> Nat) : Prop :=
  ∀ k, minimumAncillas k = 0 ↔ AncillaFreeProgramExists k

/-- Semantic parity obstruction in source-facing form. -/
theorem ancillaFree_impossible
    (k : Nat) (large : 3 <= k) :
    ¬ AncillaFreeProgramExists k := by
  exact no_ancilla_exists large

/-- Any numerical minimum compatible with the circuit-existence model is at
least one for k>=3. -/
theorem minimumAncillas_ge_one
    (minimumAncillas : Nat -> Nat)
    (model : MinimumAncillaModel minimumAncillas) :
    ∀ k, 3 <= k -> 1 <= minimumAncillas k := by
  intro k large
  by_contra notPositive
  have zero : minimumAncillas k = 0 := by omega
  have existsProgram := (model k).mp zero
  exact ancillaFree_impossible k large existsProgram

/-- Discharge the ancilla premise used by the incrementer Equation-(2)
transfer. -/
theorem controlledXNeedsAncilla
    (minimumAncillas : Nat -> Nat)
    (model : MinimumAncillaModel minimumAncillas) :
    ComparatorIncrementerAncillaLowerBoundReduction.ControlledXNeedsAncilla
      minimumAncillas :=
  minimumAncillas_ge_one minimumAncillas model

/-- Discharge the corresponding ancilla premise used by the comparator
Equation-(3) transfer. -/
theorem comparatorCkxAncillaLowerBound
    (minimumAncillas : Nat -> Nat)
    (model : MinimumAncillaModel minimumAncillas) :
    VandaeleComparatorLowerBoundReduction.CkxAncillaLowerBoundTarget
      minimumAncillas :=
  minimumAncillas_ge_one minimumAncillas model

/-- Incrementer ancilla lower bound with the parity premise discharged
internally.  Equation (2), inverse-circuit workspace equality, and monotonicity
of the minimum incrementer workspace are still explicit model assumptions. -/
theorem transferred_incrementer_lower_bound_from_parity
    (controlledXMinimumAncillas incrementAncillas decrementAncillas : Nat -> Nat)
    (model : MinimumAncillaModel controlledXMinimumAncillas)
    (reduction :
      ComparatorIncrementerAncillaLowerBoundReduction.EqTwoAncillaReductionBound
        controlledXMinimumAncillas incrementAncillas decrementAncillas)
    (inverseSameAncillas : ∀ k,
      decrementAncillas k = incrementAncillas k)
    (monotone : ∀ k,
      incrementAncillas k <= incrementAncillas (k + 1)) :
    ComparatorIncrementerAncillaLowerBoundReduction.IncrementerNeedsAncilla
      incrementAncillas := by
  exact ComparatorIncrementerAncillaLowerBoundReduction.
    transferred_incrementer_ancilla_lower_bound
      controlledXMinimumAncillas incrementAncillas decrementAncillas
      (controlledXNeedsAncilla controlledXMinimumAncillas model)
      reduction inverseSameAncillas monotone

/-- Classical-comparator lower-bound transfer can likewise use the internal
parity theorem rather than an external ancilla premise.  Gate/depth lower bounds
remain the cited Lemma-1 assumptions. -/
theorem classicalComparator_lower_bound_from_parity
    (controlledXGateLower controlledXDepthLower
      controlledXMinimumAncillas : Nat -> Nat)
    (cqGate cqDepth cqAncillas : Nat -> Nat -> Nat)
    (model : MinimumAncillaModel controlledXMinimumAncillas)
    (externalGateDepth :
      VandaeleLemma1Contract.BoundedGateLowerBoundTarget
        controlledXGateLower controlledXDepthLower)
    (gateReduction :
      VandaeleComparatorLowerBoundReduction.EqThreeGateReductionBound
        controlledXGateLower cqGate)
    (depthReduction :
      VandaeleComparatorLowerBoundReduction.EqThreeDepthReductionBound
        controlledXDepthLower cqDepth)
    (ancillaReduction :
      VandaeleComparatorLowerBoundReduction.EqThreeAncillaReductionBound
        controlledXMinimumAncillas cqAncillas) :
    VandaeleComparatorLowerBoundReduction.
      ClassicalComparatorTransferredLowerBoundTarget
        cqGate cqDepth cqAncillas := by
  exact VandaeleComparatorLowerBoundReduction.
    classicalComparator_lower_bound_transfer
      controlledXGateLower controlledXDepthLower controlledXMinimumAncillas
      cqGate cqDepth cqAncillas externalGateDepth
      (comparatorCkxAncillaLowerBound controlledXMinimumAncillas model)
      gateReduction depthReduction ancillaReduction

end VandaeleLemma1ParityLowerBound
end QuantumBlockEncoding
