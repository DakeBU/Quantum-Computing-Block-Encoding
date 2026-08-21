import QuantumBlockEncoding.VandaeleComparatorTheorem2Resource
import QuantumBlockEncoding.VandaeleLemma1Contract
import Mathlib.Tactic

/-!
# Vandaele Equation (28): controlled V2 resource closure

Corollary 5 controls the V2 component of the comparator.  Equation (28)
expresses a k-controlled `V_2^(n)` using a constant number of ordinary V2
components together with two `C^(k+1) X` predicate toggles.  The source uses one
dirty qubit internally; when n>1 this qubit is borrowed from the existing V2
register, so no external ancilla is added.

This file closes the resource algebra from Theorem 2 and Lemma 1.  It does not
claim a concrete gate list for Equation (28); that remains the later circuit
refinement of the same envelope.
-/

namespace QuantumBlockEncoding
namespace VandaeleControlledV2Resource

open ComparatorIncrementerTheorem4DepthBound
open VandaeleComparatorTheorem2Resource
open VandaeleLemma1Contract

/-- Common logarithmic scale for the controlled V2 source statement. -/
def combinedLogScale (controls n : Nat) : Nat :=
  logRank n + VandaeleLemma1Contract.logScale (controls + 1)

/-- Literal high-level gate envelope read from Equation (28). -/
def controlledV2GateEnvelope
    (v2Gate multiXGate : Nat → Nat)
    (controls n : Nat) : Nat :=
  2 * v2Gate n + 2 * multiXGate (controls + 1)

/-- Conservative serial depth envelope. -/
def controlledV2DepthEnvelope
    (v2Depth multiXDepth : Nat → Nat)
    (controls n : Nat) : Nat :=
  2 * v2Depth n + 2 * multiXDepth (controls + 1)

/-- Uniform source target for Equation (28). -/
def ControlledV2ResourceTarget
    (gateCount depth : Nat → Nat → Nat) : Prop :=
  ∃ gateConstant depthConstant : Nat,
    ∀ controls n,
      gateCount controls n ≤ gateConstant * (controls + n + 2) ∧
      depth controls n ≤ depthConstant * combinedLogScale controls n

/-- Theorem-2 linear/log V2 resources and Lemma-1 multi-X resources close the
uniform Equation-(28) target. -/
theorem controlledV2_resource_closure
    (v2Gate v2Depth : Nat → Nat)
    (multiXGate multiXDepth multiXDirty : Nat → Nat)
    (v2GateConstant v2DepthConstant : Nat)
    (v2GateBound : ∀ n, v2Gate n ≤ v2GateConstant * (n + 1))
    (v2DepthBound : ∀ n, v2Depth n ≤ v2DepthConstant * logRank n)
    (multiXResources :
      LemmaOneUniformResourceTarget multiXGate multiXDepth multiXDirty) :
    ControlledV2ResourceTarget
      (controlledV2GateEnvelope v2Gate multiXGate)
      (controlledV2DepthEnvelope v2Depth multiXDepth) := by
  rcases multiXResources with
    ⟨multiGateConstant, multiDepthConstant, multiBounds⟩
  refine ⟨2 * v2GateConstant + 2 * multiGateConstant,
    2 * v2DepthConstant + 2 * multiDepthConstant, ?_⟩
  intro controls n
  have v2G := v2GateBound n
  have v2D := v2DepthBound n
  have mx := multiBounds (controls + 1)
  have nScale : n + 1 ≤ controls + n + 2 := by omega
  have kScale : controls + 1 + 1 ≤ controls + n + 2 := by omega
  have v2GateGlobal :
      v2Gate n ≤ v2GateConstant * (controls + n + 2) :=
    v2G.trans (Nat.mul_le_mul_left v2GateConstant nScale)
  have mxGateGlobal :
      multiXGate (controls + 1) ≤
        multiGateConstant * (controls + n + 2) :=
    mx.1.trans (Nat.mul_le_mul_left multiGateConstant kScale)
  constructor
  · unfold controlledV2GateEnvelope
    calc
      2 * v2Gate n + 2 * multiXGate (controls + 1) ≤
          2 * (v2GateConstant * (controls + n + 2)) +
          2 * (multiGateConstant * (controls + n + 2)) :=
        Nat.add_le_add
          (Nat.mul_le_mul_left 2 v2GateGlobal)
          (Nat.mul_le_mul_left 2 mxGateGlobal)
      _ = (2 * v2GateConstant + 2 * multiGateConstant) *
          (controls + n + 2) := by ring
  · unfold controlledV2DepthEnvelope combinedLogScale
    have v2DepthGlobal :
        v2Depth n ≤ v2DepthConstant *
          (logRank n + VandaeleLemma1Contract.logScale (controls + 1)) :=
      v2D.trans (Nat.mul_le_mul_left v2DepthConstant (by omega))
    have mxDepthGlobal :
        multiXDepth (controls + 1) ≤ multiDepthConstant *
          (logRank n + VandaeleLemma1Contract.logScale (controls + 1)) :=
      mx.2.1.trans (Nat.mul_le_mul_left multiDepthConstant (by omega))
    calc
      2 * v2Depth n + 2 * multiXDepth (controls + 1) ≤
          2 * (v2DepthConstant *
            (logRank n + VandaeleLemma1Contract.logScale (controls + 1))) +
          2 * (multiDepthConstant *
            (logRank n + VandaeleLemma1Contract.logScale (controls + 1))) :=
        Nat.add_le_add
          (Nat.mul_le_mul_left 2 v2DepthGlobal)
          (Nat.mul_le_mul_left 2 mxDepthGlobal)
      _ = (2 * v2DepthConstant + 2 * multiDepthConstant) *
          (logRank n + VandaeleLemma1Contract.logScale (controls + 1)) := by ring

/-- In the source regime n>1, at least one existing V2-register qubit is
available to serve as the internal dirty bit, so Equation (28) needs no external
ancilla. -/
def borrowedDirtyWire (n : Nat) (large : 1 < n) : Fin n :=
  ⟨0, by omega⟩

/-- External ancilla cost of Equation (28) is zero in the stated source regime. -/
def controlledV2ExternalAncillas (_controls n : Nat) : Nat :=
  if 1 < n then 0 else 1

@[simp] theorem controlledV2ExternalAncillas_eq_zero
    (controls n : Nat) (large : 1 < n) :
    controlledV2ExternalAncillas controls n = 0 := by
  simp [controlledV2ExternalAncillas, large]

end VandaeleControlledV2Resource
end QuantumBlockEncoding
