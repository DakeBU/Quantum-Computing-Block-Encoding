import QuantumBlockEncoding.VandaeleCorollary7ControlledIncrementer
import QuantumBlockEncoding.VandaeleLemma1Contract
import QuantumBlockEncoding.VandaeleTheorem5Resource
import Mathlib.Tactic

/-!
# Vandaele Corollary 8: controlled classical-adder resources

Equations (53)-(54) write `c = 2c' + r`.

* both parity cases use two uncontrolled n-bit adders (+c' and -c');
* both use two `C^k X` gates;
* the odd case `r=1` adds one k-controlled n-bit incrementer (Corollary 7).

This file closes the deterministic resource algebra.  It intentionally accepts
already-certified resource functions for those three component families rather
than assigning costs to the semantic Equation-(53)/(54) diagrams by fiat.
-/

namespace QuantumBlockEncoding
namespace VandaeleCorollary8ControlledAdderResource

open ComparatorIncrementerTheorem4DepthBound
open VandaeleCorollary7ControlledIncrementer
open VandaeleLemma1Contract
open VandaeleTheorem5Resource

/-- Totalized gate scale matching `k + n log n`. -/
def gateScale (controls n : Nat) : Nat :=
  controls + (n + 1) * logRank n + 1

/-- Totalized depth envelope.  The explicit `logRank(k+n)` term comes from the
Corollary-7 incrementer in the odd branch; it is asymptotically absorbed by the
source `log k + log^2 n` statement. -/
def depthScale (controls n : Nat) : Nat :=
  VandaeleLemma1Contract.logScale controls +
    logRank n * logRank n +
    logRank (controls + n)

/-- Literal worst-case gate envelope of Equations (53)-(54). -/
def gateEnvelope
    (adderGate : Nat → Nat)
    (multiXGate : Nat → Nat)
    (controlledIncrementGate : Nat → Nat → Nat)
    (controls n : Nat) : Nat :=
  2 * adderGate n + 2 * multiXGate controls +
    controlledIncrementGate controls n

/-- Worst-case serial depth envelope. -/
def depthEnvelope
    (adderDepth : Nat → Nat)
    (multiXDepth : Nat → Nat)
    (controlledIncrementDepth : Nat → Nat → Nat)
    (controls n : Nat) : Nat :=
  2 * adderDepth n + 2 * multiXDepth controls +
    controlledIncrementDepth controls n

/-- Uniform resource target for a controlled-increment component. -/
def ControlledIncrementResourceTarget
    (gateCount depth : Nat → Nat → Nat) : Prop :=
  ∃ gateConstant depthConstant : Nat,
    ∀ controls n,
      gateCount controls n ≤ gateConstant * (controls + n + 1) ∧
      depth controls n ≤ depthConstant * logRank (controls + n)

/-- Theorem-5 + Lemma-1 + Corollary-7 resource functions close Corollary 8. -/
theorem resource_closure
    (adderGate adderDepth adderDirty : Nat → Nat)
    (multiXGate multiXDepth multiXDirty : Nat → Nat)
    (controlledIncrementGate controlledIncrementDepth : Nat → Nat → Nat)
    (adderResources :
      TheoremFiveUpperTarget adderGate adderDepth adderDirty)
    (multiXResources :
      LemmaOneUniformResourceTarget multiXGate multiXDepth multiXDirty)
    (controlledIncrementResources :
      ControlledIncrementResourceTarget
        controlledIncrementGate controlledIncrementDepth) :
    ∃ gateConstant depthConstant : Nat,
      ∀ controls n,
        gateEnvelope adderGate multiXGate controlledIncrementGate controls n ≤
          gateConstant * gateScale controls n ∧
        depthEnvelope adderDepth multiXDepth controlledIncrementDepth controls n ≤
          depthConstant * depthScale controls n := by
  rcases adderResources with
    ⟨⟨adderGateConstant, adderGateBound⟩,
      ⟨adderDepthConstant, adderDepthBound⟩,
      adderDirtyBound⟩
  rcases multiXResources with
    ⟨multiGateConstant, multiDepthConstant, multiBounds⟩
  rcases controlledIncrementResources with
    ⟨incGateConstant, incDepthConstant, incBounds⟩
  refine ⟨2 * adderGateConstant + 2 * multiGateConstant + incGateConstant,
    2 * adderDepthConstant + 2 * multiDepthConstant + incDepthConstant, ?_⟩
  intro controls n
  have addG := adderGateBound n
  have addD := adderDepthBound n
  have mx := multiBounds controls
  have inc := incBounds controls n
  have adderGateScale :
      (n + 1) * logRank n ≤ gateScale controls n := by
    unfold gateScale
    omega
  have controlGateScale : controls + 1 ≤ gateScale controls n := by
    unfold gateScale
    omega
  have incGateScale : controls + n + 1 ≤ gateScale controls n := by
    unfold gateScale
    have rankPositive : 1 ≤ logRank n := by
      unfold logRank
      omega
    have nCovered : n ≤ (n + 1) * logRank n := by
      nlinarith
    omega
  have addGGlobal :
      adderGate n ≤ adderGateConstant * gateScale controls n :=
    addG.trans (Nat.mul_le_mul_left adderGateConstant adderGateScale)
  have mxGGlobal :
      multiXGate controls ≤ multiGateConstant * gateScale controls n :=
    mx.1.trans (Nat.mul_le_mul_left multiGateConstant controlGateScale)
  have incGGlobal :
      controlledIncrementGate controls n ≤
        incGateConstant * gateScale controls n :=
    inc.1.trans (Nat.mul_le_mul_left incGateConstant incGateScale)
  constructor
  · unfold gateEnvelope
    calc
      2 * adderGate n + 2 * multiXGate controls +
          controlledIncrementGate controls n ≤
        2 * (adderGateConstant * gateScale controls n) +
          2 * (multiGateConstant * gateScale controls n) +
          incGateConstant * gateScale controls n :=
        Nat.add_le_add
          (Nat.add_le_add
            (Nat.mul_le_mul_left 2 addGGlobal)
            (Nat.mul_le_mul_left 2 mxGGlobal))
          incGGlobal
      _ = (2 * adderGateConstant + 2 * multiGateConstant + incGateConstant) *
          gateScale controls n := by ring
  · unfold depthEnvelope depthScale
    have addDGlobal :
        adderDepth n ≤ adderDepthConstant *
          (VandaeleLemma1Contract.logScale controls +
            logRank n * logRank n + logRank (controls + n)) :=
      addD.trans (Nat.mul_le_mul_left adderDepthConstant (by omega))
    have mxDGlobal :
        multiXDepth controls ≤ multiDepthConstant *
          (VandaeleLemma1Contract.logScale controls +
            logRank n * logRank n + logRank (controls + n)) :=
      mx.2.1.trans (Nat.mul_le_mul_left multiDepthConstant (by omega))
    have incDGlobal :
        controlledIncrementDepth controls n ≤ incDepthConstant *
          (VandaeleLemma1Contract.logScale controls +
            logRank n * logRank n + logRank (controls + n)) :=
      inc.2.trans (Nat.mul_le_mul_left incDepthConstant (by omega))
    calc
      2 * adderDepth n + 2 * multiXDepth controls +
          controlledIncrementDepth controls n ≤
        2 * (adderDepthConstant *
          (VandaeleLemma1Contract.logScale controls +
            logRank n * logRank n + logRank (controls + n))) +
        2 * (multiDepthConstant *
          (VandaeleLemma1Contract.logScale controls +
            logRank n * logRank n + logRank (controls + n))) +
        incDepthConstant *
          (VandaeleLemma1Contract.logScale controls +
            logRank n * logRank n + logRank (controls + n)) :=
        Nat.add_le_add
          (Nat.add_le_add
            (Nat.mul_le_mul_left 2 addDGlobal)
            (Nat.mul_le_mul_left 2 mxDGlobal))
          incDGlobal
      _ = (2 * adderDepthConstant + 2 * multiDepthConstant + incDepthConstant) *
          (VandaeleLemma1Contract.logScale controls +
            logRank n * logRank n + logRank (controls + n)) := by ring

/-- Corollary 8 keeps the one dirty ancilla of the source adder family. -/
def dirtyAncillas (_controls _n : Nat) : Nat := 1

@[simp] theorem one_dirty (controls n : Nat) : dirtyAncillas controls n = 1 := rfl

end VandaeleCorollary8ControlledAdderResource
end QuantumBlockEncoding
