import QuantumBlockEncoding.ComparatorIncrementerFanoutIdentity
import QuantumBlockEncoding.ComparatorIncrementerFanoutSource
import QuantumBlockEncoding.VandaeleLemma1Contract
import Mathlib.Tactic

/-!
# Uniform resource closure for Vandaele Equation (37)

Equation (37) implements the k-controlled fan-out used by Equation (36) as

`fanout ; C^k X(on pivot) ; fanout`.

The exact permutation identity is already formalized in
`ComparatorIncrementerFanoutIdentity`.  This file combines the two source
resource ingredients:

* first-order fan-out from Lemma 2: O(n) gates and O(log n) depth;
* C^k X from Lemma 1: O(k) gates and O(log k) depth with at most one dirty bit.

The resulting constants are uniform in both fan-out width n and control count k.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerFanoutResourceClosure

open ComparatorIncrementerFanoutSource
open VandaeleLemma1Contract

/-- Literal gate envelope of Equation (37). -/
def controlledFanoutGateEnvelope
    (fanoutGateCount multiXGateCount : Nat → Nat)
    (targets controls : Nat) : Nat :=
  2 * fanoutGateCount targets + multiXGateCount controls

/-- Literal serial depth envelope.  Any parallel overlap in a concrete
implementation can only improve this upper bound. -/
def controlledFanoutDepthEnvelope
    (fanoutDepth multiXDepth : Nat → Nat)
    (targets controls : Nat) : Nat :=
  2 * fanoutDepth targets + multiXDepth controls

/-- Totalized source logarithmic scale. -/
def combinedLogScale (targets controls : Nat) : Nat :=
  lemmaTwoLogScale targets + VandaeleLemma1Contract.logScale controls

/-- Genuine uniform Eq.-(37) target. -/
def ControlledFanoutUniformResourceTarget
    (gateCount depth dirtyAncillas : Nat → Nat → Nat) : Prop :=
  ∃ gateConstant depthConstant : Nat,
    ∀ targets controls,
      gateCount targets controls ≤
          gateConstant * (targets + controls + 1) ∧
      depth targets controls ≤
          depthConstant * combinedLogScale targets controls ∧
      dirtyAncillas targets controls ≤ 1

/-- Lemma 2 + Lemma 1 close the resource theorem for the exact Eq.-(37)
envelope. -/
theorem controlledFanout_uniform_resource_closure
    (fanoutGateCount fanoutDepth : Nat → Nat)
    (multiXGateCount multiXDepth multiXDirtyAncillas : Nat → Nat)
    (fanoutResources :
      FirstOrderFanoutUniformResourceTarget
        fanoutGateCount fanoutDepth)
    (multiXResources :
      LemmaOneUniformResourceTarget
        multiXGateCount multiXDepth multiXDirtyAncillas) :
    ControlledFanoutUniformResourceTarget
      (controlledFanoutGateEnvelope fanoutGateCount multiXGateCount)
      (controlledFanoutDepthEnvelope fanoutDepth multiXDepth)
      (fun _ controls => multiXDirtyAncillas controls) := by
  rcases fanoutResources with
    ⟨fanoutGateConstant, fanoutDepthConstant, fanoutBounds⟩
  rcases multiXResources with
    ⟨multiXGateConstant, multiXDepthConstant, multiXBounds⟩
  refine ⟨2 * fanoutGateConstant + multiXGateConstant,
    2 * fanoutDepthConstant + multiXDepthConstant, ?_⟩
  intro targets controls
  have fanoutAtN := fanoutBounds targets
  have multiAtK := multiXBounds controls
  have nScale : targets + 1 ≤ targets + controls + 1 := by omega
  have kScale : controls + 1 ≤ targets + controls + 1 := by omega
  have fanoutGateGlobal :
      fanoutGateCount targets ≤
        fanoutGateConstant * (targets + controls + 1) :=
    fanoutAtN.1.trans
      (Nat.mul_le_mul_left fanoutGateConstant nScale)
  have multiGateGlobal :
      multiXGateCount controls ≤
        multiXGateConstant * (targets + controls + 1) :=
    multiAtK.1.trans
      (Nat.mul_le_mul_left multiXGateConstant kScale)
  constructor
  · unfold controlledFanoutGateEnvelope
    calc
      2 * fanoutGateCount targets + multiXGateCount controls ≤
        2 * (fanoutGateConstant * (targets + controls + 1)) +
          multiXGateConstant * (targets + controls + 1) :=
        Nat.add_le_add
          (Nat.mul_le_mul_left 2 fanoutGateGlobal)
          multiGateGlobal
      _ = (2 * fanoutGateConstant + multiXGateConstant) *
          (targets + controls + 1) := by ring
  · constructor
    · unfold controlledFanoutDepthEnvelope combinedLogScale
      have fanoutDepthGlobal :
          fanoutDepth targets ≤
            fanoutDepthConstant *
              (lemmaTwoLogScale targets +
                VandaeleLemma1Contract.logScale controls) :=
        fanoutAtN.2.trans
          (Nat.mul_le_mul_left fanoutDepthConstant (by omega))
      have multiDepthGlobal :
          multiXDepth controls ≤
            multiXDepthConstant *
              (lemmaTwoLogScale targets +
                VandaeleLemma1Contract.logScale controls) :=
        multiAtK.2.1.trans
          (Nat.mul_le_mul_left multiXDepthConstant (by omega))
      calc
        2 * fanoutDepth targets + multiXDepth controls ≤
          2 * (fanoutDepthConstant *
            (lemmaTwoLogScale targets +
              VandaeleLemma1Contract.logScale controls)) +
          multiXDepthConstant *
            (lemmaTwoLogScale targets +
              VandaeleLemma1Contract.logScale controls) :=
          Nat.add_le_add
            (Nat.mul_le_mul_left 2 fanoutDepthGlobal)
            multiDepthGlobal
        _ = (2 * fanoutDepthConstant + multiXDepthConstant) *
            (lemmaTwoLogScale targets +
              VandaeleLemma1Contract.logScale controls) := by ring
    · exact multiAtK.2.2

end ComparatorIncrementerFanoutResourceClosure
end QuantumBlockEncoding
