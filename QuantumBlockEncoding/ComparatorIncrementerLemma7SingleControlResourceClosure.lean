import QuantumBlockEncoding.ComparatorIncrementerEq36ResourceClosure
import QuantumBlockEncoding.VandaeleLadderContract
import Mathlib.Tactic

/-!
# Single-control resource composition in Vandaele Lemma 7

In Figure 9 / the first part of the Lemma-7 proof, the singly controlled strong
promise incrementer is organized into two resource classes:

* the controlled non-ladder layers (slices 2 and 4), handled by Lemma 5;
* two CCX ladders (slices 1 and 3), handled by Lemma 4.

Both classes have uniform O(n) gate count and O(log n) depth.  This file proves
that their literal sum has the same uniform scale.  The underlying Gidney
incrementer correctness and the concrete ladder implementation are separate
source/external obligations; this theorem only formalizes Vandaele's resource
composition step.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma7SingleControlResourceClosure

open ComparatorIncrementerEq36ResourceClosure
open ComparatorIncrementerFanoutSource
open VandaeleLadderContract

/-- Literal gate envelope for controlled non-ladder slices plus two CCX ladders. -/
def singleControlGateEnvelope
    (controlledLayerGateCount ladderGateCount : Nat → Nat)
    (n : Nat) : Nat :=
  controlledLayerGateCount n + 2 * ladderGateCount n

/-- Corresponding serial depth envelope. -/
def singleControlDepthEnvelope
    (controlledLayerDepth ladderDepth : Nat → Nat)
    (n : Nat) : Nat :=
  controlledLayerDepth n + 2 * ladderDepth n

/-- Uniform target for the Figure-9 single-control resource composition. -/
def SingleControlResourceTarget
    (gateCount depth : Nat → Nat) : Prop :=
  ∃ gateConstant depthConstant : Nat,
    ∀ n,
      gateCount n ≤ gateConstant * (n + 1) ∧
      depth n ≤ depthConstant * lemmaTwoLogScale n

/-- Lemma-5 controlled-layer resources plus Lemma-4 ladder resources close the
single-control Figure-9 gate/depth scale. -/
theorem singleControl_uniform_resource_closure
    (controlledLayerGateCount controlledLayerDepth : Nat → Nat)
    (ladderGateCount ladderDepth ladderAncillas : Nat → Nat)
    (controlledLayers :
      TargetLinearLogResourceTarget
        controlledLayerGateCount controlledLayerDepth)
    (ladders :
      LemmaFourUniformResourceTarget
        ladderGateCount ladderDepth ladderAncillas) :
    SingleControlResourceTarget
      (singleControlGateEnvelope
        controlledLayerGateCount ladderGateCount)
      (singleControlDepthEnvelope
        controlledLayerDepth ladderDepth) := by
  rcases controlledLayers with
    ⟨controlledGateConstant, controlledDepthConstant, controlledBounds⟩
  rcases ladders with
    ⟨ladderGateConstant, ladderDepthConstant, ladderBounds⟩
  refine ⟨controlledGateConstant + 2 * ladderGateConstant,
    controlledDepthConstant + 2 * ladderDepthConstant, ?_⟩
  intro n
  have controlledAtN := controlledBounds n
  have ladderAtN := ladderBounds n
  constructor
  · unfold singleControlGateEnvelope
    calc
      controlledLayerGateCount n + 2 * ladderGateCount n ≤
        controlledGateConstant * (n + 1) +
          2 * (ladderGateConstant * (n + 1)) :=
        Nat.add_le_add controlledAtN.1
          (Nat.mul_le_mul_left 2 ladderAtN.1)
      _ = (controlledGateConstant + 2 * ladderGateConstant) *
          (n + 1) := by ring
  · unfold singleControlDepthEnvelope
    have ladderDepthAtScale :
        ladderDepth n ≤ ladderDepthConstant * lemmaTwoLogScale n := by
      simpa [lemmaTwoLogScale] using ladderAtN.2.1
    calc
      controlledLayerDepth n + 2 * ladderDepth n ≤
        controlledDepthConstant * lemmaTwoLogScale n +
          2 * (ladderDepthConstant * lemmaTwoLogScale n) :=
        Nat.add_le_add controlledAtN.2
          (Nat.mul_le_mul_left 2 ladderDepthAtScale)
      _ = (controlledDepthConstant + 2 * ladderDepthConstant) *
          lemmaTwoLogScale n := by ring

/-- Lemma 4's declared workspace bound remains inspectable separately; no
promise-register claim is folded into the gate/depth theorem above. -/
theorem ladder_workspace_bound
    (ladderGateCount ladderDepth ladderAncillas : Nat → Nat)
    (ladders :
      LemmaFourUniformResourceTarget
        ladderGateCount ladderDepth ladderAncillas)
    (n : Nat) :
    ladderAncillas n ≤ n := by
  rcases ladders with ⟨_, _, bounds⟩
  exact (bounds n).2.2

end ComparatorIncrementerLemma7SingleControlResourceClosure
end QuantumBlockEncoding
