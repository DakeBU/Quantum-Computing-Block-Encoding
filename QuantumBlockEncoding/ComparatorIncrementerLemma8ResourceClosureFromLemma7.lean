import QuantumBlockEncoding.ComparatorIncrementerLemma8Composition
import QuantumBlockEncoding.ComparatorIncrementerLemma8PromiseDepthBudget
import QuantumBlockEncoding.ComparatorIncrementerLemma8PromiseGateBudget
import Mathlib.Tactic

/-!
# Lemma-8 resource closure from the actual Lemma-7 resource family

The Figure-10 resource analysis has three component classes:

* the two structural ladders, together O(n) gates / O(log n) depth;
* fan-out layers, together O(n) gates / O(log n) depth;
* the square-root collection of Lemma-7 promise increments/decrements.

The last class is no longer an abstract `blocks * perBlock` placeholder:
`ComparatorIncrementerLemma8PromiseGateBudget` sums the actual Lemma-7 gate
function over the canonical block plan, while
`ComparatorIncrementerLemma8PromiseDepthBudget` takes the exact two parity-round
maxima.

Therefore a concrete Figure-10 scheduled family only has to prove that its total
resources are bounded by the three component envelopes below.  This theorem then
produces the public `LemmaEightResourceTarget` mechanically.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma8ResourceClosureFromLemma7

open ComparatorIncrementerLemma7Contract
open ComparatorIncrementerLemma8Composition
open ComparatorIncrementerLemma8Contract
open ComparatorIncrementerLemma8PromiseDepthBudget
open ComparatorIncrementerLemma8PromiseGateBudget

/-- Uniform linear-gate / logarithmic-depth target for one structural component
family of Figure 10. -/
def StructuralResourceTarget
    (gateCount depth : Nat → Nat) : Prop :=
  ∃ gateConstant depthConstant : Nat,
    ∀ n,
      gateCount n ≤ gateConstant * (n + 1) ∧
      depth n ≤ depthConstant * logScale n

/-- Ladder + fan-out + canonical Lemma-7 promise resources close the complete
Lemma-8 asymptotic resource target. -/
theorem figureTen_resource_closure
    (ladderGate ladderDepth : Nat → Nat)
    (fanoutGate fanoutDepth : Nat → Nat)
    (lemmaSevenGate lemmaSevenDepth : Nat → Nat → Nat)
    (totalGate totalDepth : Nat → Nat)
    (ladderResources : StructuralResourceTarget ladderGate ladderDepth)
    (fanoutResources : StructuralResourceTarget fanoutGate fanoutDepth)
    (lemmaSevenResources :
      LemmaSevenResourceTarget lemmaSevenGate lemmaSevenDepth)
    (gateComposition : ∀ n,
      totalGate n ≤
        ladderGate n + fanoutGate n +
          canonicalPromiseGateSum lemmaSevenGate n)
    (depthComposition : ∀ n,
      totalDepth n ≤
        ladderDepth n + fanoutDepth n +
          canonicalPromiseDepth lemmaSevenDepth n) :
    LemmaEightResourceTarget totalGate totalDepth := by
  rcases ladderResources with
    ⟨ladderGateConstant, ladderDepthConstant, ladderBounds⟩
  rcases fanoutResources with
    ⟨fanoutGateConstant, fanoutDepthConstant, fanoutBounds⟩
  rcases canonicalPromiseGateSum_linear
      lemmaSevenGate lemmaSevenDepth lemmaSevenResources with
    ⟨promiseGateConstant, promiseGateBound⟩
  rcases canonicalPromiseDepth_logarithmic
      lemmaSevenGate lemmaSevenDepth lemmaSevenResources with
    ⟨promiseDepthConstant, promiseDepthBound⟩
  constructor
  · refine ⟨ladderGateConstant + fanoutGateConstant + promiseGateConstant, ?_⟩
    intro n
    have ladder := (ladderBounds n).1
    have fanout := (fanoutBounds n).1
    have promise := promiseGateBound n
    calc
      totalGate n ≤
          ladderGate n + fanoutGate n +
            canonicalPromiseGateSum lemmaSevenGate n := gateComposition n
      _ ≤ ladderGateConstant * (n + 1) +
          fanoutGateConstant * (n + 1) +
          promiseGateConstant * (n + 1) :=
        Nat.add_le_add (Nat.add_le_add ladder fanout) promise
      _ = (ladderGateConstant + fanoutGateConstant + promiseGateConstant) *
          (n + 1) := by ring
  · refine ⟨ladderDepthConstant + fanoutDepthConstant + promiseDepthConstant, ?_⟩
    intro n
    have ladder := (ladderBounds n).2
    have fanout := (fanoutBounds n).2
    have promise := promiseDepthBound n
    calc
      totalDepth n ≤
          ladderDepth n + fanoutDepth n +
            canonicalPromiseDepth lemmaSevenDepth n := depthComposition n
      _ ≤ ladderDepthConstant * logScale n +
          fanoutDepthConstant * logScale n +
          promiseDepthConstant * logScale n :=
        Nat.add_le_add (Nat.add_le_add ladder fanout) promise
      _ = (ladderDepthConstant + fanoutDepthConstant + promiseDepthConstant) *
          logScale n := by ring

end ComparatorIncrementerLemma8ResourceClosureFromLemma7
end QuantumBlockEncoding
