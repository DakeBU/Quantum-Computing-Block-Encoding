import QuantumBlockEncoding.VandaeleLemma5ResourceClosure
import QuantumBlockEncoding.VandaeleTheorem1Contract
import Mathlib.Tactic

/-!
# Uniform resource closure for Vandaele Theorem 1

The source proof of Theorem 1 has three quantitative ingredients:

* the two uncontrolled outer circuits `V` and `V†`;
* a singly-controlled implementation of each of the `dU` layers of `U`, using
  Lemma 5 with one control;
* two `C^k X` gates from Figure 3(b), using Lemma 1.

The important counting point is that the `O(k)` contribution from the two
multi-controlled X gates is paid once, not once per layer of `U`.  This file
formalizes the resulting family-level resource algebra.  It still does not
manufacture gate syntax: the fan-out and `C^k X` implementation families are
explicit inputs.

For totalized zero-width parameters we record the harmless structural condition
`dU <= cU + 1`.  Any ordinary nonempty layered circuit satisfies the stronger
`dU <= cU`; the `+1` only avoids making boundary bookkeeping part of the
asymptotic theorem.
-/

namespace QuantumBlockEncoding
namespace VandaeleTheorem1ResourceClosure

open VandaeleLemma1Contract
open VandaeleLemma5ResourceClosure
open VandaeleTheorem1Contract

/-- Minimal structural consistency required of the source `U` resource tuple. -/
def WellFormedMiddle (p : SourceParameters) : Prop :=
  p.middleDepth ≤ p.middleGateCount + 1

/-- Gate envelope obtained by reading the proof of Theorem 1 literally. -/
def theoremOneGateEnvelope
    (fanoutGateCount multiXGateCount : Nat → Nat)
    (p : SourceParameters) : Nat :=
  2 * p.outerGateCount + p.middleGateCount +
    p.middleDepth *
      (singlyGateEnvelope fanoutGateCount p.targetQubits) +
    2 * multiXGateCount p.controls

/-- Depth envelope from the same proof. -/
def theoremOneDepthEnvelope
    (fanoutDepth multiXDepth : Nat → Nat)
    (p : SourceParameters) : Nat :=
  2 * p.outerDepth +
    p.middleDepth *
      (singlyDepthEnvelope fanoutDepth p.targetQubits) +
    2 * multiXDepth p.controls

/-- The `dU * (n+1)` totalized layer mass is already covered by the source gate
scale once the basic depth/gate consistency of `U` is recorded. -/
theorem middle_layer_mass_le_gateScale
    (p : SourceParameters) (wellFormed : WellFormedMiddle p) :
    p.middleDepth * (p.targetQubits + 1) ≤ gateScale p + 1 := by
  unfold WellFormedMiddle at wellFormed
  unfold gateScale
  calc
    p.middleDepth * (p.targetQubits + 1) =
        p.middleDepth * p.targetQubits + p.middleDepth := by ring
    _ ≤ p.middleDepth * p.targetQubits +
        (p.middleGateCount + 1) :=
      Nat.add_le_add_left wellFormed _
    _ ≤ p.outerGateCount + p.middleGateCount +
        p.middleDepth * p.targetQubits + p.controls + 1 := by
      omega

/-- The outer source gate count is one component of the Theorem-1 scale. -/
theorem outer_gate_le_scale (p : SourceParameters) :
    p.outerGateCount ≤ gateScale p + 1 := by
  unfold gateScale
  omega

/-- Likewise for the original middle gate count. -/
theorem middle_gate_le_scale (p : SourceParameters) :
    p.middleGateCount ≤ gateScale p + 1 := by
  unfold gateScale
  omega

/-- The multi-control width is covered by the source gate scale. -/
theorem controls_succ_le_gateScale (p : SourceParameters) :
    p.controls + 1 ≤ gateScale p + 1 := by
  unfold gateScale
  omega

/-- The corresponding components of the source depth scale. -/
theorem outer_depth_le_scale (p : SourceParameters) :
    p.outerDepth ≤ depthScale p + 1 := by
  unfold depthScale
  omega

/-- One logarithmic target-width factor, multiplied by `dU`, is exactly a
component of `depthScale`. -/
theorem middle_log_mass_le_depthScale (p : SourceParameters) :
    p.middleDepth *
        (Nat.log2 (p.targetQubits + 1) + 1) ≤
      depthScale p + 1 := by
  unfold depthScale
  omega

/-- The control logarithm is also a direct source-depth component. -/
theorem control_log_le_depthScale (p : SourceParameters) :
    VandaeleLemma1Contract.logScale p.controls ≤
      depthScale p + 1 := by
  unfold VandaeleLemma1Contract.logScale depthScale
  omega

/-- Uniform Lemma-1 and first-order Lemma-2 resources close the clean-ancilla
resource statement of Theorem 1 for the explicit source envelope. -/
theorem theoremOne_uniform_resource_closure
    (fanoutGateCount fanoutDepth : Nat → Nat)
    (multiXGateCount multiXDepth multiXDirtyAncillas : Nat → Nat)
    (fanoutResources :
      ComparatorIncrementerFanoutSource.FirstOrderFanoutUniformResourceTarget
        fanoutGateCount fanoutDepth)
    (multiXResources :
      LemmaOneUniformResourceTarget
        multiXGateCount multiXDepth multiXDirtyAncillas)
    (wellFormed : ∀ p, WellFormedMiddle p) :
    UniformResourceTarget
      (theoremOneGateEnvelope fanoutGateCount multiXGateCount)
      (theoremOneDepthEnvelope fanoutDepth multiXDepth)
      cleanAncillaBudget := by
  rcases singly_uniform_bounds
      fanoutGateCount fanoutDepth fanoutResources with
    ⟨singleGateConstant, singleDepthConstant, singleBounds⟩
  rcases multiXResources with
    ⟨multiXGateConstant, multiXDepthConstant, multiXBounds⟩
  refine ⟨2 + 1 + singleGateConstant + 2 * multiXGateConstant,
    2 + singleDepthConstant + 2 * multiXDepthConstant, ?_⟩
  intro p
  have singleAtN := singleBounds p.targetQubits
  have multiAtK := multiXBounds p.controls

  have layerGateBound :
      p.middleDepth *
          singlyGateEnvelope fanoutGateCount p.targetQubits ≤
        singleGateConstant * (gateScale p + 1) := by
    calc
      p.middleDepth *
          singlyGateEnvelope fanoutGateCount p.targetQubits ≤
        p.middleDepth *
          (singleGateConstant * (p.targetQubits + 1)) :=
        Nat.mul_le_mul_left p.middleDepth singleAtN.1
      _ = singleGateConstant *
          (p.middleDepth * (p.targetQubits + 1)) := by ring
      _ ≤ singleGateConstant * (gateScale p + 1) :=
        Nat.mul_le_mul_left singleGateConstant
          (middle_layer_mass_le_gateScale p (wellFormed p))

  have multiGateGlobal :
      multiXGateCount p.controls ≤
        multiXGateConstant * (gateScale p + 1) :=
    multiAtK.1.trans
      (Nat.mul_le_mul_left multiXGateConstant
        (controls_succ_le_gateScale p))

  have layerDepthBound :
      p.middleDepth *
          singlyDepthEnvelope fanoutDepth p.targetQubits ≤
        singleDepthConstant * (depthScale p + 1) := by
    calc
      p.middleDepth *
          singlyDepthEnvelope fanoutDepth p.targetQubits ≤
        p.middleDepth *
          (singleDepthConstant *
            VandaeleLemma5SplitBudget.logScale p.targetQubits) :=
        Nat.mul_le_mul_left p.middleDepth singleAtN.2
      _ = singleDepthConstant *
          (p.middleDepth *
            (Nat.log2 (p.targetQubits + 1) + 1)) := by
        simp [VandaeleLemma5SplitBudget.logScale]
        ring
      _ ≤ singleDepthConstant * (depthScale p + 1) :=
        Nat.mul_le_mul_left singleDepthConstant
          (middle_log_mass_le_depthScale p)

  have multiDepthGlobal :
      multiXDepth p.controls ≤
        multiXDepthConstant * (depthScale p + 1) :=
    multiAtK.2.1.trans
      (Nat.mul_le_mul_left multiXDepthConstant
        (control_log_le_depthScale p))

  constructor
  · unfold theoremOneGateEnvelope
    calc
      2 * p.outerGateCount + p.middleGateCount +
          p.middleDepth *
            singlyGateEnvelope fanoutGateCount p.targetQubits +
          2 * multiXGateCount p.controls ≤
        2 * (gateScale p + 1) + (gateScale p + 1) +
          singleGateConstant * (gateScale p + 1) +
          2 * (multiXGateConstant * (gateScale p + 1)) := by
        exact Nat.add_le_add
          (Nat.add_le_add
            (Nat.add_le_add
              (Nat.mul_le_mul_left 2 (outer_gate_le_scale p))
              (middle_gate_le_scale p))
            layerGateBound)
          (Nat.mul_le_mul_left 2 multiGateGlobal)
      _ = (2 + 1 + singleGateConstant + 2 * multiXGateConstant) *
          (gateScale p + 1) := by ring
  · constructor
    · unfold theoremOneDepthEnvelope
      calc
        2 * p.outerDepth +
            p.middleDepth *
              singlyDepthEnvelope fanoutDepth p.targetQubits +
            2 * multiXDepth p.controls ≤
          2 * (depthScale p + 1) +
            singleDepthConstant * (depthScale p + 1) +
            2 * (multiXDepthConstant * (depthScale p + 1)) := by
          exact Nat.add_le_add
            (Nat.add_le_add
              (Nat.mul_le_mul_left 2 (outer_depth_le_scale p))
              layerDepthBound)
            (Nat.mul_le_mul_left 2 multiDepthGlobal)
        _ = (2 + singleDepthConstant + 2 * multiXDepthConstant) *
            (depthScale p + 1) := by ring
    · exact Nat.le_refl _

/-- Under the strong/involutory hypotheses, the same gate/depth envelope also
closes the source dirty-ancilla variant: exactly one guaranteed clean bit is
replaced by one dirty bit. -/
theorem theoremOne_uniform_dirty_resource_closure
    (fanoutGateCount fanoutDepth : Nat → Nat)
    (multiXGateCount multiXDepth multiXDirtyAncillas : Nat → Nat)
    (fanoutResources :
      ComparatorIncrementerFanoutSource.FirstOrderFanoutUniformResourceTarget
        fanoutGateCount fanoutDepth)
    (multiXResources :
      LemmaOneUniformResourceTarget
        multiXGateCount multiXDepth multiXDirtyAncillas)
    (wellFormed : ∀ p, WellFormedMiddle p) :
    UniformDirtyResourceTarget
      (theoremOneGateEnvelope fanoutGateCount multiXGateCount)
      (theoremOneDepthEnvelope fanoutDepth multiXDepth)
      dirtyVariantCleanAncillas dirtyVariantDirtyAncillas := by
  rcases theoremOne_uniform_resource_closure
      fanoutGateCount fanoutDepth
      multiXGateCount multiXDepth multiXDirtyAncillas
      fanoutResources multiXResources wellFormed with
    ⟨gateConstant, depthConstant, bounds⟩
  refine ⟨gateConstant, depthConstant, ?_⟩
  intro p
  have bound := bounds p
  exact ⟨bound.1, bound.2.1, Nat.le_refl _, rfl⟩

end VandaeleTheorem1ResourceClosure
end QuantumBlockEncoding
