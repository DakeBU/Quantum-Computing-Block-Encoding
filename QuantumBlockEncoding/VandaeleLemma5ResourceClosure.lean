import QuantumBlockEncoding.ComparatorIncrementerFanoutSource
import QuantumBlockEncoding.VandaeleLemma1Contract
import QuantumBlockEncoding.VandaeleLemma5Contract
import QuantumBlockEncoding.VandaeleLemma5SplitBudget
import Mathlib.Tactic

/-!
# Uniform resource closure for Vandaele Lemma 5

The semantic circuit identities (13)/(14) and the split-and-borrow ancilla
arithmetic are formalized separately.  This file closes the remaining resource
algebra at the family level.

Assume:

* a first-order fan-out family satisfying Lemma 2 uniformly;
* a C^k X family satisfying Lemma 1 uniformly.

Then the source construction has one uniform O(n+k) gate constant,
O(log n + log k) depth constant, and zero additional ancillas.  The theorem does
not manufacture the missing gate syntax: it proves that once the two source
primitive families and Eq. (13)/(14) scheduler are refined to circuits, their
resource evidence composes exactly as claimed.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma5ResourceClosure

open ComparatorIncrementerFanoutSource
open VandaeleLemma1Contract
open VandaeleLemma5Contract
open VandaeleLemma5SplitBudget

/-- Explicit singly-controlled gate envelope from Equation (13) after splitting
into two halves. -/
def singlyGateEnvelope
    (fanoutGateCount : Nat → Nat) (n : Nat) : Nat :=
  4 * fanoutGateCount (upperHalf n) + 2 * n

/-- Explicit singly-controlled depth envelope. -/
def singlyDepthEnvelope
    (fanoutDepth : Nat → Nat) (n : Nat) : Nat :=
  4 * fanoutDepth (upperHalf n) + 2

/-- Explicit k-controlled Equation-(14)-over-both-halves gate envelope. -/
def lemmaFiveGateEnvelope
    (fanoutGateCount multiXGateCount : Nat → Nat)
    (n controls : Nat) : Nat :=
  4 * singlyGateEnvelope fanoutGateCount n +
    4 * multiXGateCount controls

/-- Corresponding depth envelope. -/
def lemmaFiveDepthEnvelope
    (fanoutDepth multiXDepth : Nat → Nat)
    (n controls : Nat) : Nat :=
  4 * singlyDepthEnvelope fanoutDepth n +
    4 * multiXDepth controls

/-- Lemma-2 uniform evidence gives a uniform linear/log bound for the complete
singly-controlled Equation-(13) construction. -/
theorem singly_uniform_bounds
    (fanoutGateCount fanoutDepth : Nat → Nat)
    (resources :
      FirstOrderFanoutUniformResourceTarget
        fanoutGateCount fanoutDepth) :
    ∃ gateConstant depthConstant : Nat,
      ∀ n,
        singlyGateEnvelope fanoutGateCount n ≤
          gateConstant * (n + 1) ∧
        singlyDepthEnvelope fanoutDepth n ≤
          depthConstant * logScale n := by
  rcases resources with ⟨fanoutGateConstant, fanoutDepthConstant, fanoutBounds⟩
  refine ⟨4 * fanoutGateConstant + 2,
    4 * fanoutDepthConstant + 2, ?_⟩
  intro n
  have fanoutAtHalf := fanoutBounds (upperHalf n)
  constructor
  · unfold singlyGateEnvelope
    exact singlyControlled_gate_budget
      n (fanoutGateCount (upperHalf n))
      (4 * fanoutGateCount (upperHalf n) + 2 * n)
      fanoutGateConstant
      fanoutAtHalf.1 (by rfl)
  · unfold singlyDepthEnvelope
    have halfLogMonotone :
        ComparatorIncrementerFanoutSource.lemmaTwoLogScale (upperHalf n) ≤
          logScale n := by
      have halfBound : upperHalf n + 1 ≤ n + 1 := by
        unfold upperHalf lowerHalf
        omega
      have logBound :
          Nat.log2 (upperHalf n + 1) ≤ Nat.log2 (n + 1) :=
        Nat.log2_le_log2 halfBound
      unfold ComparatorIncrementerFanoutSource.lemmaTwoLogScale logScale
      omega
    have fanoutDepthAtN :
        fanoutDepth (upperHalf n) ≤ fanoutDepthConstant * logScale n :=
      fanoutAtHalf.2.trans
        (Nat.mul_le_mul_left fanoutDepthConstant halfLogMonotone)
    exact singlyControlled_depth_budget
      n (fanoutDepth (upperHalf n))
      (4 * fanoutDepth (upperHalf n) + 2)
      fanoutDepthConstant
      fanoutDepthAtN (by rfl)

/-- Uniform Lemma-1 + Lemma-2 resources close the full Lemma-5 asymptotic
resource target for the explicit source envelopes. -/
theorem lemmaFive_uniform_resource_closure
    (fanoutGateCount fanoutDepth : Nat → Nat)
    (multiXGateCount multiXDepth multiXDirtyAncillas : Nat → Nat)
    (fanoutResources :
      FirstOrderFanoutUniformResourceTarget
        fanoutGateCount fanoutDepth)
    (multiXResources :
      LemmaOneUniformResourceTarget
        multiXGateCount multiXDepth multiXDirtyAncillas) :
    LemmaFiveUniformResourceTarget
      (lemmaFiveGateEnvelope fanoutGateCount multiXGateCount)
      (lemmaFiveDepthEnvelope fanoutDepth multiXDepth)
      (fun _ _ => 0) := by
  rcases singly_uniform_bounds
      fanoutGateCount fanoutDepth fanoutResources with
    ⟨singleGateConstant, singleDepthConstant, singleBounds⟩
  rcases multiXResources with
    ⟨multiXGateConstant, multiXDepthConstant, multiXBounds⟩
  refine ⟨4 * singleGateConstant + 4 * multiXGateConstant,
    4 * singleDepthConstant + 4 * multiXDepthConstant, ?_⟩
  intro n controls
  have singleAtN := singleBounds n
  have multiAtK := multiXBounds controls
  constructor
  · unfold lemmaFiveGateEnvelope
    exact kControlled_gate_budget
      n controls
      (singlyGateEnvelope fanoutGateCount n)
      (multiXGateCount controls)
      (4 * singlyGateEnvelope fanoutGateCount n +
        4 * multiXGateCount controls)
      singleGateConstant multiXGateConstant
      singleAtN.1 multiAtK.1 (by rfl)
  · constructor
    · unfold lemmaFiveDepthEnvelope
      have combined := kControlled_depth_budget
        n controls
        (singlyDepthEnvelope fanoutDepth n)
        (multiXDepth controls)
        (4 * singlyDepthEnvelope fanoutDepth n +
          4 * multiXDepth controls)
        singleDepthConstant multiXDepthConstant
        singleAtN.2 multiAtK.2.1 (by rfl)
      simpa [VandaeleLemma5Contract.depthScale,
        VandaeleLemma5SplitBudget.combinedLogScale,
        VandaeleLemma5SplitBudget.logScale] using combined
    · rfl

end VandaeleLemma5ResourceClosure
end QuantumBlockEncoding
