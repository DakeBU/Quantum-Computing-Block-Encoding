import QuantumBlockEncoding.VandaeleComparatorTheorem3Resource
import QuantumBlockEncoding.VandaeleControlledV2Resource
import QuantumBlockEncoding.VandaeleLemma1Contract
import Mathlib.Tactic

/-!
# Controlled comparator resource closures (Corollaries 5 and 6)

The controlled comparator corollaries only add controls to the source components
that actually affect the comparison flag. Resource-wise this reduces to three
families:

* the uncontrolled comparator structure, O(n) gates / O(log n) depth;
* the controlled V2 component from Equation (28), O(k+n) / O(log k + log n);
* one additional multi-controlled-X style predicate toggle, O(k) / O(log k).

The Equation-(28) component naturally contains `C^(k+1) X`, so the totalized
logarithmic scale below keeps `logScale(k+1)` explicitly.  This avoids an
unnecessary fragile logarithm identity while representing the same asymptotic
source statement.
-/

namespace QuantumBlockEncoding
namespace VandaeleControlledComparatorResource

open ComparatorIncrementerTheorem4DepthBound
open VandaeleControlledV2Resource
open VandaeleLemma1Contract

/-- Totalized controlled-comparator logarithmic scale. -/
def combinedLogScale (controls n : Nat) : Nat :=
  logRank n + VandaeleLemma1Contract.logScale (controls + 1)

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

/-- Ordinary `C^k X` log scale is bounded by the `C^(k+1) X` scale already
present in Equation (28). -/
theorem controlLog_mono (controls : Nat) :
    VandaeleLemma1Contract.logScale controls ≤
      VandaeleLemma1Contract.logScale (controls + 1) := by
  unfold VandaeleLemma1Contract.logScale
  have value : controls + 1 ≤ controls + 2 := by omega
  have logarithm :
      Nat.log2 (controls + 1) ≤ Nat.log2 (controls + 2) := by
    rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
    exact Nat.log_mono_right value
  omega

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
          (logRank n + VandaeleLemma1Contract.logScale (controls + 1)) :=
      base.2.trans (Nat.mul_le_mul_left baseDepthConstant (by omega))
    have multiDepthGlobal :
        multiXDepth controls ≤ multiDepthConstant *
          (logRank n + VandaeleLemma1Contract.logScale (controls + 1)) :=
      multi.2.1.trans
        (Nat.mul_le_mul_left multiDepthConstant
          ((controlLog_mono controls).trans (by omega)))
    have v2DepthGlobal :
        controlledV2Depth controls n ≤ v2DepthConstant *
          (logRank n + VandaeleLemma1Contract.logScale (controls + 1)) := by
      simpa [VandaeleControlledV2Resource.combinedLogScale] using v2.2
    calc
      baseDepth n + controlledV2Depth controls n + multiXDepth controls ≤
          baseDepthConstant *
              (logRank n + VandaeleLemma1Contract.logScale (controls + 1)) +
          v2DepthConstant *
              (logRank n + VandaeleLemma1Contract.logScale (controls + 1)) +
          multiDepthConstant *
              (logRank n + VandaeleLemma1Contract.logScale (controls + 1)) :=
        Nat.add_le_add (Nat.add_le_add baseDepthGlobal v2DepthGlobal)
          multiDepthGlobal
      _ = (baseDepthConstant + v2DepthConstant + multiDepthConstant) *
          (logRank n + VandaeleLemma1Contract.logScale (controls + 1)) := by ring

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
