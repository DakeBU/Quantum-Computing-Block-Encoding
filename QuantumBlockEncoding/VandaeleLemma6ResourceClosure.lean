import QuantumBlockEncoding.ComparatorIncrementerLemma8Budget
import QuantumBlockEncoding.ComparatorIncrementerTheorem4DepthBound
import QuantumBlockEncoding.VandaeleLemma6Contract
import Mathlib.Tactic

/-!
# Figure-6 resource composition for Vandaele Lemma 6

The proof of Lemma 6 separates Figure 6 into three resource classes:

* the first/last multi-controlled ladder structures (Corollary 1);
* fan-in / fan-out structures (Lemma 2);
* O(sqrt N) promise `L_2` / `L_2^†` components, each acting on O(sqrt N)
  wires and having logarithmic depth (Corollary 4).

This file closes only the deterministic resource algebra.  The concrete
Figure-6 scheduled circuit is still required to prove that its component counts
and depths satisfy the envelopes supplied here.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma6ResourceClosure

open ComparatorIncrementerLemma8Budget
open ComparatorIncrementerTheorem4DepthBound
open VandaeleLemma6Contract

/-- Ambient source width N for the `m`-indexed V2 target. -/
def ambientWidth (m : Nat) : Nat := sourceWidth m

/-- Square-root block scale used by Figure 6. -/
def localWidth (m : Nat) : Nat := blockWidth (ambientWidth m)

/-- Common totalized logarithmic scale. -/
def logScale (m : Nat) : Nat := logRank (ambientWidth m)

/-- Linear/log resource target for one structural Figure-6 component family
(ladders or fan-in/fan-out). -/
def StructuralResourceTarget
    (gateCount depth : Nat → Nat) : Prop :=
  ∃ gateConstant depthConstant : Nat,
    ∀ m,
      gateCount m ≤ gateConstant * (ambientWidth m + 1) ∧
      depth m ≤ depthConstant * logScale m

/-- Local resource target for one promise-L2 component. -/
def LocalPromiseResourceTarget
    (gateCount depth : Nat → Nat) : Prop :=
  ∃ gateConstant depthConstant : Nat,
    ∀ m,
      gateCount m ≤ gateConstant * localWidth m ∧
      depth m ≤ depthConstant * logScale m

/-- Gate envelope of all promise-L2 components. -/
def promiseGateEnvelope
    (promiseBlocks perPromiseGates : Nat → Nat) (m : Nat) : Nat :=
  promiseBlocks m * perPromiseGates m

/-- Depth envelope of a constant-round promise-L2 schedule. -/
def promiseDepthEnvelope
    (rounds perPromiseDepth : Nat → Nat) (m : Nat) : Nat :=
  rounds m * perPromiseDepth m

/-- If Figure 6 uses at most `blockConstant * sqrt(N)` local promise gates,
each costing at most `promiseConstant * sqrt(N)`, their total gate count is
linear in N. -/
theorem promise_gate_linear
    (promiseBlocks perPromiseGates : Nat → Nat)
    (blockConstant promiseConstant : Nat)
    (blocksBound : ∀ m,
      promiseBlocks m ≤ blockConstant * localWidth m)
    (perPromiseBound : ∀ m,
      perPromiseGates m ≤ promiseConstant * localWidth m) :
    ∀ m,
      promiseGateEnvelope promiseBlocks perPromiseGates m ≤
        4 * (blockConstant * promiseConstant) * (ambientWidth m + 1) := by
  intro m
  unfold promiseGateEnvelope localWidth
  exact blockwise_gate_budget
    (ambientWidth m)
    (promiseBlocks m) (perPromiseGates m)
    (promiseBlocks m * perPromiseGates m)
    promiseConstant blockConstant
    (blocksBound m) (perPromiseBound m) (Nat.le_refl _)

/-- A uniformly bounded number of rounds preserves logarithmic depth. -/
theorem promise_depth_logarithmic
    (rounds perPromiseDepth : Nat → Nat)
    (roundConstant depthConstant : Nat)
    (roundsBound : ∀ m, rounds m ≤ roundConstant)
    (perPromiseBound : ∀ m,
      perPromiseDepth m ≤ depthConstant * logScale m) :
    ∀ m,
      promiseDepthEnvelope rounds perPromiseDepth m ≤
        (roundConstant * depthConstant) * logScale m := by
  intro m
  unfold promiseDepthEnvelope
  calc
    rounds m * perPromiseDepth m ≤
        roundConstant * (depthConstant * logScale m) :=
      Nat.mul_le_mul (roundsBound m) (perPromiseBound m)
    _ = (roundConstant * depthConstant) * logScale m := by ring

/-- Complete Figure-6 resource closure.  Once a concrete scheduled family proves
that its total count/depth are no larger than the sum of the source component
envelopes, the public Lemma-6 resource theorem follows mechanically. -/
theorem figureSix_resource_closure
    (ladderGate ladderDepth fanoutGate fanoutDepth : Nat → Nat)
    (promiseBlocks perPromiseGate rounds perPromiseDepth : Nat → Nat)
    (totalGate totalDepth : Nat → Nat)
    (ladderResources : StructuralResourceTarget ladderGate ladderDepth)
    (fanoutResources : StructuralResourceTarget fanoutGate fanoutDepth)
    (blockConstant promiseGateConstant
      roundConstant promiseDepthConstant : Nat)
    (promiseBlocksBound : ∀ m,
      promiseBlocks m ≤ blockConstant * localWidth m)
    (perPromiseGateBound : ∀ m,
      perPromiseGate m ≤ promiseGateConstant * localWidth m)
    (roundsBound : ∀ m, rounds m ≤ roundConstant)
    (perPromiseDepthBound : ∀ m,
      perPromiseDepth m ≤ promiseDepthConstant * logScale m)
    (gateComposition : ∀ m,
      totalGate m ≤ ladderGate m + fanoutGate m +
        promiseGateEnvelope promiseBlocks perPromiseGate m)
    (depthComposition : ∀ m,
      totalDepth m ≤ ladderDepth m + fanoutDepth m +
        promiseDepthEnvelope rounds perPromiseDepth m) :
    ResourceTarget totalGate totalDepth := by
  rcases ladderResources with
    ⟨ladderGateConstant, ladderDepthConstant, ladderBounds⟩
  rcases fanoutResources with
    ⟨fanoutGateConstant, fanoutDepthConstant, fanoutBounds⟩
  have promiseGateBound := promise_gate_linear
    promiseBlocks perPromiseGate blockConstant promiseGateConstant
    promiseBlocksBound perPromiseGateBound
  have promiseDepthBound := promise_depth_logarithmic
    rounds perPromiseDepth roundConstant promiseDepthConstant
    roundsBound perPromiseDepthBound
  constructor
  · refine ⟨ladderGateConstant + fanoutGateConstant +
      4 * (blockConstant * promiseGateConstant), ?_⟩
    intro m
    have ladder := (ladderBounds m).1
    have fanout := (fanoutBounds m).1
    have promise := promiseGateBound m
    calc
      totalGate m ≤ ladderGate m + fanoutGate m +
          promiseGateEnvelope promiseBlocks perPromiseGate m := gateComposition m
      _ ≤ ladderGateConstant * (ambientWidth m + 1) +
          fanoutGateConstant * (ambientWidth m + 1) +
          4 * (blockConstant * promiseGateConstant) *
            (ambientWidth m + 1) :=
        Nat.add_le_add (Nat.add_le_add ladder fanout) promise
      _ = (ladderGateConstant + fanoutGateConstant +
          4 * (blockConstant * promiseGateConstant)) *
            (ambientWidth m + 1) := by ring
  · refine ⟨ladderDepthConstant + fanoutDepthConstant +
      roundConstant * promiseDepthConstant, ?_⟩
    intro m
    have ladder := (ladderBounds m).2
    have fanout := (fanoutBounds m).2
    have promise := promiseDepthBound m
    have scaleEq :
        Nat.log2 (sourceWidth m + 1) + 1 = logScale m := by
      rfl
    rw [scaleEq]
    calc
      totalDepth m ≤ ladderDepth m + fanoutDepth m +
          promiseDepthEnvelope rounds perPromiseDepth m := depthComposition m
      _ ≤ ladderDepthConstant * logScale m +
          fanoutDepthConstant * logScale m +
          (roundConstant * promiseDepthConstant) * logScale m :=
        Nat.add_le_add (Nat.add_le_add ladder fanout) promise
      _ = (ladderDepthConstant + fanoutDepthConstant +
          roundConstant * promiseDepthConstant) * logScale m := by ring

end VandaeleLemma6ResourceClosure
end QuantumBlockEncoding
