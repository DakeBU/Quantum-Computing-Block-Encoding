import QuantumBlockEncoding.ComparatorIncrementerFanoutResourceClosure
import QuantumBlockEncoding.VandaeleLemma1Contract
import Mathlib.Tactic

/-!
# Uniform resource wrapper for Vandaele Equation (36)

Equation (36) is the clean-to-dirty conversion used by Lemma 7 and later by the
main incrementer construction.  At the source-operation level it contains a
constant number of:

* increment/decrement target operations;
* k-controlled fan-outs, implemented through Equation (37);
* C^k X predicate toggles.

This file records a conservative explicit envelope with two uses of each class.
The exact permutation/action and dirty restoration are already proved in
`ComparatorIncrementerDirtyAncilla` and
`ComparatorIncrementerControlledConjugation`; this layer only closes the
uniform gate/depth algebra.

The dirty-workspace count is intentionally not inferred here, because the source
reuses available register qubits differently in different consumers.  Lemma 7
and Theorem 4 track that workspace separately.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerEq36ResourceClosure

open ComparatorIncrementerFanoutResourceClosure
open ComparatorIncrementerFanoutSource
open VandaeleLemma1Contract

/-- Uniform linear/log resource target for one increment/decrement family. -/
def TargetLinearLogResourceTarget
    (gateCount depth : Nat → Nat) : Prop :=
  ∃ gateConstant depthConstant : Nat,
    ∀ n,
      gateCount n ≤ gateConstant * (n + 1) ∧
      depth n ≤ depthConstant * lemmaTwoLogScale n

/-- Conservative high-level gate envelope of the Eq.-(36) wrapper. -/
def eq36GateEnvelope
    (targetGateCount : Nat → Nat)
    (controlledFanoutGateCount : Nat → Nat → Nat)
    (multiXGateCount : Nat → Nat)
    (n controls : Nat) : Nat :=
  2 * targetGateCount n +
    2 * controlledFanoutGateCount n controls +
    2 * multiXGateCount controls

/-- Conservative serial depth envelope.  Any scheduling overlap can only lower
this quantity. -/
def eq36DepthEnvelope
    (targetDepth : Nat → Nat)
    (controlledFanoutDepth : Nat → Nat → Nat)
    (multiXDepth : Nat → Nat)
    (n controls : Nat) : Nat :=
  2 * targetDepth n +
    2 * controlledFanoutDepth n controls +
    2 * multiXDepth controls

/-- Uniform source-scale target for the Eq.-(36) wrapper. -/
def Eq36UniformResourceTarget
    (gateCount depth : Nat → Nat → Nat) : Prop :=
  ∃ gateConstant depthConstant : Nat,
    ∀ n controls,
      gateCount n controls ≤
          gateConstant * (n + controls + 1) ∧
      depth n controls ≤
          depthConstant * combinedLogScale n controls

/-- Linear/log target operations, Eq.-(37) controlled fan-out resources, and
Lemma-1 C^k X resources compose to the claimed Eq.-(36) scale. -/
theorem eq36_uniform_resource_closure
    (targetGateCount targetDepth : Nat → Nat)
    (controlledFanoutGateCount controlledFanoutDepth
      controlledFanoutDirtyAncillas : Nat → Nat → Nat)
    (multiXGateCount multiXDepth multiXDirtyAncillas : Nat → Nat)
    (targetResources :
      TargetLinearLogResourceTarget targetGateCount targetDepth)
    (fanoutResources :
      ControlledFanoutUniformResourceTarget
        controlledFanoutGateCount controlledFanoutDepth
        controlledFanoutDirtyAncillas)
    (multiXResources :
      LemmaOneUniformResourceTarget
        multiXGateCount multiXDepth multiXDirtyAncillas) :
    Eq36UniformResourceTarget
      (eq36GateEnvelope
        targetGateCount controlledFanoutGateCount multiXGateCount)
      (eq36DepthEnvelope
        targetDepth controlledFanoutDepth multiXDepth) := by
  rcases targetResources with
    ⟨targetGateConstant, targetDepthConstant, targetBounds⟩
  rcases fanoutResources with
    ⟨fanoutGateConstant, fanoutDepthConstant, fanoutBounds⟩
  rcases multiXResources with
    ⟨multiXGateConstant, multiXDepthConstant, multiXBounds⟩
  refine ⟨2 * targetGateConstant + 2 * fanoutGateConstant +
      2 * multiXGateConstant,
    2 * targetDepthConstant + 2 * fanoutDepthConstant +
      2 * multiXDepthConstant, ?_⟩
  intro n controls
  have targetAtN := targetBounds n
  have fanoutAtNK := fanoutBounds n controls
  have multiAtK := multiXBounds controls
  have nScale : n + 1 ≤ n + controls + 1 := by omega
  have kScale : controls + 1 ≤ n + controls + 1 := by omega
  have targetGateGlobal :
      targetGateCount n ≤
        targetGateConstant * (n + controls + 1) :=
    targetAtN.1.trans
      (Nat.mul_le_mul_left targetGateConstant nScale)
  have multiGateGlobal :
      multiXGateCount controls ≤
        multiXGateConstant * (n + controls + 1) :=
    multiAtK.1.trans
      (Nat.mul_le_mul_left multiXGateConstant kScale)
  constructor
  · unfold eq36GateEnvelope
    calc
      2 * targetGateCount n +
          2 * controlledFanoutGateCount n controls +
          2 * multiXGateCount controls ≤
        2 * (targetGateConstant * (n + controls + 1)) +
          2 * (fanoutGateConstant * (n + controls + 1)) +
          2 * (multiXGateConstant * (n + controls + 1)) := by
        exact Nat.add_le_add
          (Nat.add_le_add
            (Nat.mul_le_mul_left 2 targetGateGlobal)
            (Nat.mul_le_mul_left 2 fanoutAtNK.1))
          (Nat.mul_le_mul_left 2 multiGateGlobal)
      _ = (2 * targetGateConstant + 2 * fanoutGateConstant +
          2 * multiXGateConstant) * (n + controls + 1) := by ring
  · unfold eq36DepthEnvelope
    have targetDepthGlobal :
        targetDepth n ≤
          targetDepthConstant * combinedLogScale n controls :=
      targetAtN.2.trans
        (Nat.mul_le_mul_left targetDepthConstant (by
          unfold combinedLogScale
          omega))
    have multiDepthGlobal :
        multiXDepth controls ≤
          multiXDepthConstant * combinedLogScale n controls :=
      multiAtK.2.1.trans
        (Nat.mul_le_mul_left multiXDepthConstant (by
          unfold combinedLogScale
          omega))
    calc
      2 * targetDepth n +
          2 * controlledFanoutDepth n controls +
          2 * multiXDepth controls ≤
        2 * (targetDepthConstant * combinedLogScale n controls) +
          2 * (fanoutDepthConstant * combinedLogScale n controls) +
          2 * (multiXDepthConstant * combinedLogScale n controls) := by
        exact Nat.add_le_add
          (Nat.add_le_add
            (Nat.mul_le_mul_left 2 targetDepthGlobal)
            (Nat.mul_le_mul_left 2 fanoutAtNK.2.1))
          (Nat.mul_le_mul_left 2 multiDepthGlobal)
      _ = (2 * targetDepthConstant + 2 * fanoutDepthConstant +
          2 * multiXDepthConstant) * combinedLogScale n controls := by ring

end ComparatorIncrementerEq36ResourceClosure
end QuantumBlockEncoding
