import QuantumBlockEncoding.ComparatorIncrementerFanoutSource
import QuantumBlockEncoding.VandaeleLemma1Contract
import Mathlib.Tactic

/-!
# Vandaele Equation (37): uniform resource closure

Equation (37) implements one k-controlled fan-out using exactly two ordinary
first-order fan-outs and one `C^k X` gate.  The semantic identity lives in
`ComparatorIncrementerFanoutIdentity`; this file closes the corresponding
family-level resource algebra from source Lemmas 1 and 2.

The depth estimate below is deliberately conservative: it sums the three
component depths.  This is sufficient for the source asymptotic
`O(log(kn))` claim and does not rely on an unproved parallel schedule.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerEq37ResourceClosure

open ComparatorIncrementerFanoutSource
open VandaeleLemma1Contract

/-- Gate envelope read directly from Equation (37). -/
def eq37GateEnvelope
    (fanoutGateCount multiXGateCount : Nat → Nat)
    (width controls : Nat) : Nat :=
  2 * fanoutGateCount width + multiXGateCount controls

/-- Conservative sequential depth envelope for the same construction. -/
def eq37DepthEnvelope
    (fanoutDepth multiXDepth : Nat → Nat)
    (width controls : Nat) : Nat :=
  2 * fanoutDepth width + multiXDepth controls

/-- Totalized logarithmic scale matching `O(log(kn))`. -/
def jointLogScale (width controls : Nat) : Nat :=
  Nat.log2 ((width + 1) * (controls + 1)) + 1

/-- Each individual logarithmic factor is bounded by the joint product scale. -/
theorem widthLog_le_jointLog (width controls : Nat) :
    lemmaTwoLogScale width ≤ jointLogScale width controls := by
  have factorPos : 1 ≤ controls + 1 := by omega
  have valueBound : width + 1 ≤ (width + 1) * (controls + 1) := by
    nlinarith
  have logBound :
      Nat.log2 (width + 1) ≤
        Nat.log2 ((width + 1) * (controls + 1)) := by
    rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
    exact Nat.log_mono_right valueBound
  unfold lemmaTwoLogScale jointLogScale
  omega

/-- Same monotonicity for the multi-control factor. -/
theorem controlLog_le_jointLog (width controls : Nat) :
    VandaeleLemma1Contract.logScale controls ≤ jointLogScale width controls := by
  have factorPos : 1 ≤ width + 1 := by omega
  have valueBound : controls + 1 ≤ (width + 1) * (controls + 1) := by
    nlinarith
  have logBound :
      Nat.log2 (controls + 1) ≤
        Nat.log2 ((width + 1) * (controls + 1)) := by
    rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
    exact Nat.log_mono_right valueBound
  unfold VandaeleLemma1Contract.logScale jointLogScale
  omega

/-- Uniform Lemma-1 and Lemma-2 resources yield one global Eq.-(37) gate/depth
constant over every fan-out width and every number of controls. -/
theorem eq37_uniform_resource_closure
    (fanoutGateCount fanoutDepth : Nat → Nat)
    (multiXGateCount multiXDepth multiXDirtyAncillas : Nat → Nat)
    (fanoutResources :
      FirstOrderFanoutUniformResourceTarget
        fanoutGateCount fanoutDepth)
    (multiXResources :
      LemmaOneUniformResourceTarget
        multiXGateCount multiXDepth multiXDirtyAncillas) :
    ∃ gateConstant depthConstant : Nat,
      ∀ width controls,
        eq37GateEnvelope fanoutGateCount multiXGateCount width controls ≤
          gateConstant * (width + controls + 1) ∧
        eq37DepthEnvelope fanoutDepth multiXDepth width controls ≤
          depthConstant * jointLogScale width controls := by
  rcases fanoutResources with
    ⟨fanoutGateConstant, fanoutDepthConstant, fanoutBounds⟩
  rcases multiXResources with
    ⟨multiXGateConstant, multiXDepthConstant, multiXBounds⟩
  refine ⟨2 * fanoutGateConstant + multiXGateConstant,
    2 * fanoutDepthConstant + multiXDepthConstant, ?_⟩
  intro width controls
  have fanout := fanoutBounds width
  have multiX := multiXBounds controls
  constructor
  · unfold eq37GateEnvelope
    have widthScale : width + 1 ≤ width + controls + 1 := by omega
    have controlScale : controls + 1 ≤ width + controls + 1 := by omega
    have fanoutGlobal :
        fanoutGateCount width ≤
          fanoutGateConstant * (width + controls + 1) :=
      fanout.1.trans (Nat.mul_le_mul_left fanoutGateConstant widthScale)
    have multiGlobal :
        multiXGateCount controls ≤
          multiXGateConstant * (width + controls + 1) :=
      multiX.1.trans (Nat.mul_le_mul_left multiXGateConstant controlScale)
    calc
      2 * fanoutGateCount width + multiXGateCount controls ≤
          2 * (fanoutGateConstant * (width + controls + 1)) +
            multiXGateConstant * (width + controls + 1) :=
        Nat.add_le_add (Nat.mul_le_mul_left 2 fanoutGlobal) multiGlobal
      _ = (2 * fanoutGateConstant + multiXGateConstant) *
          (width + controls + 1) := by ring
  · unfold eq37DepthEnvelope
    have fanoutGlobal :
        fanoutDepth width ≤
          fanoutDepthConstant * jointLogScale width controls :=
      fanout.2.trans
        (Nat.mul_le_mul_left fanoutDepthConstant
          (widthLog_le_jointLog width controls))
    have multiGlobal :
        multiXDepth controls ≤
          multiXDepthConstant * jointLogScale width controls :=
      multiX.2.1.trans
        (Nat.mul_le_mul_left multiXDepthConstant
          (controlLog_le_jointLog width controls))
    calc
      2 * fanoutDepth width + multiXDepth controls ≤
          2 * (fanoutDepthConstant * jointLogScale width controls) +
            multiXDepthConstant * jointLogScale width controls :=
        Nat.add_le_add (Nat.mul_le_mul_left 2 fanoutGlobal) multiGlobal
      _ = (2 * fanoutDepthConstant + multiXDepthConstant) *
          jointLogScale width controls := by ring

end ComparatorIncrementerEq37ResourceClosure
end QuantumBlockEncoding
