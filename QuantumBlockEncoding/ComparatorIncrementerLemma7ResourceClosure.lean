import QuantumBlockEncoding.ComparatorIncrementerEq37ResourceClosure
import QuantumBlockEncoding.ComparatorIncrementerLemma7AncillaBudget
import QuantumBlockEncoding.ComparatorIncrementerLemma7Contract
import Mathlib.Tactic

/-!
# Uniform resource assembly for Vandaele Lemma 7

The source proof of Lemma 7 has two quantitative pieces after Equation (38):

* a constant number of singly-controlled promise increment/decrement blocks on
  registers of width `ceil(n/2)`, each with linear gate count and logarithmic
  depth;
* the dirty-ancilla replacement from Equation (36), whose k-controlled fan-out
  pieces are implemented by Equation (37) using Lemmas 1 and 2.

This file closes the family-level resource algebra and connects it to the exact
Equation-(38) promise-register budget.  The envelope is intentionally
conservative: four half-size increment/decrement blocks and two Eq.-(37)
controlled fan-outs dominate the source construction by a constant factor.
A future gate-level Figure-9/Eq.-(38) refinement only has to prove that its
actual counts lie below this envelope.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma7ResourceClosure

open ComparatorIncrementerEq37ResourceClosure
open ComparatorIncrementerLemma7AncillaBudget
open ComparatorIncrementerLemma7Contract
open ComparatorIncrementerFanoutSource
open VandaeleLemma1Contract

/-- Uniform resource target for the singly-controlled half-size promise
incrementers used inside Equation (38). -/
def HalfIncrementUniformResourceTarget
    (gateCount depth : Nat → Nat) : Prop :=
  ∃ gateConstant depthConstant : Nat,
    ∀ width,
      gateCount width ≤ gateConstant * (width + 1) ∧
      depth width ≤ depthConstant * (Nat.log2 (width + 1) + 1)

/-- Conservative gate envelope for the complete Lemma-7 source assembly. -/
def lemmaSevenGateEnvelope
    (halfGateCount : Nat → Nat)
    (fanoutGateCount multiXGateCount : Nat → Nat)
    (controls n : Nat) : Nat :=
  4 * halfGateCount (ceilHalf n) +
    2 * eq37GateEnvelope fanoutGateCount multiXGateCount n controls

/-- Conservative sequential depth envelope.  Constant-factor overcounting is
harmless for the source asymptotic target. -/
def lemmaSevenDepthEnvelope
    (halfDepth : Nat → Nat)
    (fanoutDepth multiXDepth : Nat → Nat)
    (controls n : Nat) : Nat :=
  4 * halfDepth (ceilHalf n) +
    2 * eq37DepthEnvelope fanoutDepth multiXDepth n controls

/-- A half-size logarithm is bounded by the Lemma-7 joint logarithmic scale. -/
theorem halfLog_le_lemmaSevenLog (controls n : Nat) :
    Nat.log2 (ceilHalf n + 1) + 1 ≤
      Nat.log2 ((controls + 1) * (n + 1)) + 1 := by
  have halfBound : ceilHalf n + 1 ≤ n + 1 := by
    unfold ceilHalf
    omega
  have rightFactor : n + 1 ≤ (controls + 1) * (n + 1) := by
    have positive : 1 ≤ controls + 1 := by omega
    nlinarith
  have valueBound :
      ceilHalf n + 1 ≤ (controls + 1) * (n + 1) :=
    halfBound.trans rightFactor
  have logBound :
      Nat.log2 (ceilHalf n + 1) ≤
        Nat.log2 ((controls + 1) * (n + 1)) := by
    rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
    exact Nat.log_mono_right valueBound
  omega

/-- The Eq.-(37) joint logarithmic scale is the Lemma-7 scale up to
commutativity of multiplication. -/
theorem eq37Log_le_lemmaSevenLog (controls n : Nat) :
    jointLogScale n controls ≤
      Nat.log2 ((controls + 1) * (n + 1)) + 1 := by
  unfold jointLogScale
  rw [Nat.mul_comm]

/-- Uniform half-increment resources plus Lemmas 1 and 2 close the full
Lemma-7 gate/depth resource target for the explicit source envelope. -/
theorem lemmaSeven_uniform_resource_closure
    (halfGateCount halfDepth : Nat → Nat)
    (fanoutGateCount fanoutDepth : Nat → Nat)
    (multiXGateCount multiXDepth multiXDirtyAncillas : Nat → Nat)
    (halfResources :
      HalfIncrementUniformResourceTarget halfGateCount halfDepth)
    (fanoutResources :
      FirstOrderFanoutUniformResourceTarget
        fanoutGateCount fanoutDepth)
    (multiXResources :
      LemmaOneUniformResourceTarget
        multiXGateCount multiXDepth multiXDirtyAncillas) :
    LemmaSevenResourceTarget
      (lemmaSevenGateEnvelope
        halfGateCount fanoutGateCount multiXGateCount)
      (lemmaSevenDepthEnvelope
        halfDepth fanoutDepth multiXDepth) := by
  rcases halfResources with
    ⟨halfGateConstant, halfDepthConstant, halfBounds⟩
  rcases eq37_uniform_resource_closure
      fanoutGateCount fanoutDepth
      multiXGateCount multiXDepth multiXDirtyAncillas
      fanoutResources multiXResources with
    ⟨eq37GateConstant, eq37DepthConstant, eq37Bounds⟩
  constructor
  · refine ⟨4 * halfGateConstant + 2 * eq37GateConstant, ?_⟩
    intro controls n
    have half := halfBounds (ceilHalf n)
    have eq37 := eq37Bounds n controls
    have halfWidth : ceilHalf n + 1 ≤ controls + n + 1 := by
      unfold ceilHalf
      omega
    have halfGlobal :
        halfGateCount (ceilHalf n) ≤
          halfGateConstant * (controls + n + 1) :=
      half.1.trans (Nat.mul_le_mul_left halfGateConstant halfWidth)
    have eq37Global :
        eq37GateEnvelope fanoutGateCount multiXGateCount n controls ≤
          eq37GateConstant * (controls + n + 1) := by
      simpa [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc] using eq37.1
    unfold lemmaSevenGateEnvelope
    calc
      4 * halfGateCount (ceilHalf n) +
          2 * eq37GateEnvelope fanoutGateCount multiXGateCount n controls ≤
        4 * (halfGateConstant * (controls + n + 1)) +
          2 * (eq37GateConstant * (controls + n + 1)) :=
        Nat.add_le_add
          (Nat.mul_le_mul_left 4 halfGlobal)
          (Nat.mul_le_mul_left 2 eq37Global)
      _ = (4 * halfGateConstant + 2 * eq37GateConstant) *
          (controls + n + 1) := by ring
  · refine ⟨4 * halfDepthConstant + 2 * eq37DepthConstant, ?_⟩
    intro controls n
    have half := halfBounds (ceilHalf n)
    have eq37 := eq37Bounds n controls
    have halfGlobal :
        halfDepth (ceilHalf n) ≤
          halfDepthConstant *
            (Nat.log2 ((controls + 1) * (n + 1)) + 1) :=
      half.2.trans
        (Nat.mul_le_mul_left halfDepthConstant
          (halfLog_le_lemmaSevenLog controls n))
    have eq37Global :
        eq37DepthEnvelope fanoutDepth multiXDepth n controls ≤
          eq37DepthConstant *
            (Nat.log2 ((controls + 1) * (n + 1)) + 1) :=
      eq37.2.trans
        (Nat.mul_le_mul_left eq37DepthConstant
          (eq37Log_le_lemmaSevenLog controls n))
    unfold lemmaSevenDepthEnvelope
    calc
      4 * halfDepth (ceilHalf n) +
          2 * eq37DepthEnvelope fanoutDepth multiXDepth n controls ≤
        4 * (halfDepthConstant *
          (Nat.log2 ((controls + 1) * (n + 1)) + 1)) +
        2 * (eq37DepthConstant *
          (Nat.log2 ((controls + 1) * (n + 1)) + 1)) :=
        Nat.add_le_add
          (Nat.mul_le_mul_left 4 halfGlobal)
          (Nat.mul_le_mul_left 2 eq37Global)
      _ = (4 * halfDepthConstant + 2 * eq37DepthConstant) *
          (Nat.log2 ((controls + 1) * (n + 1)) + 1) := by ring

/-- The same source assembly has enough promise-register capacity for all
Equation-(38) internal workspace plus the dirty bit required by Equation (36). -/
theorem lemmaSeven_ancilla_budget_closed
    {n : Nat} (large : 3 ≤ n) :
    eq38InternalPromiseAncillas n + 1 ≤ lemmaSevenPromiseWidth n :=
  eq38_plus_dirty_fits_promise_register large

end ComparatorIncrementerLemma7ResourceClosure
end QuantumBlockEncoding
