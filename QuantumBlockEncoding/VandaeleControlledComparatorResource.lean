import QuantumBlockEncoding.VandaeleComparatorTheorem3Resource
import QuantumBlockEncoding.VandaeleControlledV2Resource
import QuantumBlockEncoding.VandaeleLemma1Contract
import Mathlib.Tactic

/-!
# Controlled comparator resource closures (Corollaries 5 and 6)

The controlled comparator corollaries only add controls to the source components
that actually affect the comparison flag.  Resource-wise this reduces to three
families:

* the uncontrolled comparator structure, O(n) gates / O(log n) depth;
* the controlled V2 component from Equation (28), O(k+n) / O(log k + log n);
* one additional multi-controlled-X style predicate toggle, O(k) / O(log k).

This file closes that algebra uniformly.  For the quantum-quantum comparator the
source uses no external ancilla; for the classical-quantum comparator the single
dirty ancilla of Theorem 3 is retained.  Concrete Corollary-5/6 circuits must
still prove that their actual counts are bounded by the envelopes below.
-/

namespace QuantumBlockEncoding
namespace VandaeleControlledComparatorResource

open ComparatorIncrementerTheorem4DepthBound
open VandaeleControlledV2Resource
open VandaeleLemma1Contract

/-- Common controlled-comparator logarithmic scale. -/
def combinedLogScale (controls n : Nat) : Nat :=
  logRank n + VandaeleLemma1Contract.logScale controls

/-- Uncontrolled comparator structural resource target. -/
def BaseComparatorResourceTarget
    (gateCount depth : Nat → Nat) : Prop :=
  ∃ gateConstant depthConstant : Nat,
    ∀ n,
      gateCount n ≤ gateConstant * (n + 1) ∧
      depth n ≤ depthConstant * logRank n

/-- Conservative controlled-comparator gate envelope. -/
def gateEnvelope
    (baseGate : Nat → Nat)
    (controlledV2Gate : Nat → Nat → Nat)
    (multiXGate : Nat → Nat)
    (controls n : Nat) : Nat :=
  baseGate n + controlledV2Gate controls n + multiXGate controls

/-- Corresponding serial depth envelope. -/
def depthEnvelope
    (baseDepth : Nat → Nat)
    (controlledV2Depth : Nat → Nat → Nat)
    (multiXDepth : Nat → Nat)
    (controls n : Nat) : Nat :=
  baseDepth n + controlledV2Depth controls n + multiXDepth controls

/-- Uniform O(k+n)/O(log k + log n) closure shared by Corollaries 5 and 6. -/
theorem controlledComparator_resource_closure
    (baseGate baseDepth : Nat → Nat)
    (controlledV2Gate controlledV2Depth : Nat → Nat → Nat)
    (multiXGate multiXDepth multiXDirty : Nat → Nat)
    (baseResources : BaseComparatorResourceTarget baseGate baseDepth)
    (controlledV2Resources :
      ControlledV2ResourceTarget controlledV2Gate controlledV2Depth)
    (multiXResources :
      LemmaOneUniformResourceTarget multiXGate multiXDepth multiXDirty) :
    ∃ gateConstant depthConstant : Nat,
      ∀ controls n,
        gateEnvelope baseGate controlledV2Gate multiXGate controls n ≤
          gateConstant * (controls + n + 2) ∧
        depthEnvelope baseDepth controlledV2Depth multiXDepth controls n ≤
          depthConstant * combinedLogScale controls n := by
  rcases baseResources with
    ⟨baseGateConstant, baseDepthConstant, baseBounds⟩
  rcases controlledV2Resources with
    ⟨v2GateConstant, v2DepthConstant, v2Bounds⟩
  rcases multiXResources with
    ⟨multiGateConstant, multiDepthConstant, multiBounds⟩
  refine ⟨baseGateConstant + v2GateConstant + multiGateConstant,
    baseDepthConstant + v2DepthConstant + multiDepthConstant, ?_⟩
  intro controls n
  have base := baseBounds n
  have v2 := v2Bounds controls n
  have multi := multiBounds controls
  have nScale : n + 1 ≤ controls + n + 2 := by omega
  have kScale : controls + 1 ≤ controls + n + 2 := by omega
  have baseGateGlobal :
      baseGate n ≤ baseGateConstant * (controls + n + 2) :=
    base.1.trans (Nat.mul_le_mul_left baseGateConstant nScale)
  have multiGateGlobal :
      multiXGate controls ≤ multiGateConstant * (controls + n + 2) :=
    multi.1.trans (Nat.mul_le_mul_left multiGateConstant kScale)
  constructor
  · unfold gateEnvelope
    calc
      baseGate n + controlledV2Gate controls n + multiXGate controls ≤
          baseGateConstant * (controls + n + 2) +
          v2GateConstant * (controls + n + 2) +
          multiGateConstant * (controls + n + 2) :=
        Nat.add_le_add (Nat.add_le_add baseGateGlobal v2.1) multiGateGlobal
      _ = (baseGateConstant + v2GateConstant + multiGateConstant) *
          (controls + n + 2) := by ring
  · unfold depthEnvelope combinedLogScale
    have baseDepthGlobal :
        baseDepth n ≤ baseDepthConstant *
          (logRank n + VandaeleLemma1Contract.logScale controls) :=
      base.2.trans (Nat.mul_le_mul_left baseDepthConstant (by omega))
    have multiDepthGlobal :
        multiXDepth controls ≤ multiDepthConstant *
          (logRank n + VandaeleLemma1Contract.logScale controls) :=
      multi.2.1.trans (Nat.mul_le_mul_left multiDepthConstant (by omega))
    have v2DepthGlobal :
        controlledV2Depth controls n ≤ v2DepthConstant *
          (logRank n + VandaeleLemma1Contract.logScale controls) := by
      have source := v2.2
      unfold VandaeleControlledV2Resource.combinedLogScale at source
      have controlScale :
          VandaeleLemma1Contract.logScale (controls + 1) ≤
            2 * VandaeleLemma1Contract.logScale controls := by
        unfold VandaeleLemma1Contract.logScale
        have positive : 1 ≤ Nat.log2 (controls + 1) + 1 := by omega
        have argument : controls + 2 ≤ 2 * (controls + 1) := by omega
        have logBound :
            Nat.log2 (controls + 2) ≤ Nat.log2 (2 * (controls + 1)) := by
          rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
          exact Nat.log_mono_right argument
        have powerBound :
            Nat.log2 (2 * (controls + 1)) ≤ Nat.log2 (controls + 1) + 1 := by
          rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
          exact Nat.log_mul_le_add_log 2 (controls + 1)
        omega
      have sourceScaled :
          controlledV2Depth controls n ≤ v2DepthConstant *
            (logRank n + 2 * VandaeleLemma1Contract.logScale controls) :=
        source.trans (Nat.mul_le_mul_left v2DepthConstant
          (Nat.add_le_add_left controlScale (logRank n)))
      have totalScale :
          logRank n + 2 * VandaeleLemma1Contract.logScale controls ≤
            2 * (logRank n + VandaeleLemma1Contract.logScale controls) := by
        omega
      exact sourceScaled.trans
        (Nat.mul_le_mul_left v2DepthConstant totalScale)
    calc
      baseDepth n + controlledV2Depth controls n + multiXDepth controls ≤
          baseDepthConstant *
              (logRank n + VandaeleLemma1Contract.logScale controls) +
          (2 * v2DepthConstant) *
              (logRank n + VandaeleLemma1Contract.logScale controls) +
          multiDepthConstant *
              (logRank n + VandaeleLemma1Contract.logScale controls) := by
        exact Nat.add_le_add
          (Nat.add_le_add baseDepthGlobal (by
            calc
              controlledV2Depth controls n ≤ v2DepthConstant *
                    (2 * (logRank n + VandaeleLemma1Contract.logScale controls)) :=
                v2DepthGlobal
              _ = (2 * v2DepthConstant) *
                    (logRank n + VandaeleLemma1Contract.logScale controls) := by ring))
          multiDepthGlobal
      _ = (baseDepthConstant + 2 * v2DepthConstant + multiDepthConstant) *
          (logRank n + VandaeleLemma1Contract.logScale controls) := by ring
      _ ≤ (baseDepthConstant + v2DepthConstant + multiDepthConstant +
          v2DepthConstant) *
          (logRank n + VandaeleLemma1Contract.logScale controls) := by ring_nf

/-- Corollary-5 ancilla target: no external ancilla. -/
def ControlledQQAncillas (_controls _n : Nat) : Nat := 0

/-- Corollary-6 ancilla target: retain exactly the one dirty ancilla of Theorem 3. -/
def ControlledCQDirtyAncillas (_controls _n : Nat) : Nat := 1

@[simp] theorem controlledQQ_no_ancilla (controls n : Nat) :
    ControlledQQAncillas controls n = 0 := rfl

@[simp] theorem controlledCQ_one_dirty (controls n : Nat) :
    ControlledCQDirtyAncillas controls n = 1 := rfl

end VandaeleControlledComparatorResource
end QuantumBlockEncoding
