import QuantumBlockEncoding.ComparatorIncrementerEq36ResourceClosure
import QuantumBlockEncoding.ComparatorIncrementerLemma7Contract
import QuantumBlockEncoding.ComparatorIncrementerLemma7PromiseBudget
import QuantumBlockEncoding.ComparatorIncrementerLemma7SingleControlResourceClosure
import Mathlib.Tactic

/-!
# Uniform resource closure for Vandaele Lemma 7

This layer now follows the source dependency graph without duplicating fan-out
or promise-budget arithmetic:

1. Figure 9 provides the singly-controlled strong-promise incrementer resource
   family (`ComparatorIncrementerLemma7SingleControlResourceClosure`).
2. Equation (38) uses two half-size instances of that family to obtain a clean
   controlled incrementer with O(n) gates and O(log n) depth.
3. Equation (36) replaces the clean ancilla by a dirty one.  Its controlled
   fan-outs are already closed from Lemmas 1 and 2 by
   `ComparatorIncrementerEq36ResourceClosure`.
4. `ComparatorIncrementerLemma7PromiseBudget` proves that the Equation-(38)
   workspace plus this dirty bit fits in the declared `n-1` promise register.

No resource number is attached to the semantic oracle implementation: a final
`LemmaSevenFamilyCertificate` still requires a concrete gate-level refinement.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma7ResourceClosure

open ComparatorIncrementerEq36ResourceClosure
open ComparatorIncrementerFanoutResourceClosure
open ComparatorIncrementerFanoutSource
open ComparatorIncrementerLemma7Contract
open ComparatorIncrementerLemma7PromiseBudget
open ComparatorIncrementerLemma7SingleControlResourceClosure
open VandaeleLemma1Contract
open VandaeleLemma5SplitBudget

/-- Clean Equation-(38) gate envelope: two singly-controlled half-size promise
incrementers. -/
def eq38CleanGateEnvelope
    (singleGateCount : Nat → Nat) (n : Nat) : Nat :=
  2 * singleGateCount (upperHalf n)

/-- Conservative serial depth envelope for the same clean construction. -/
def eq38CleanDepthEnvelope
    (singleDepth : Nat → Nat) (n : Nat) : Nat :=
  2 * singleDepth (upperHalf n)

/-- The half-width single-control family closes to a full-width linear/log
resource target for the clean Equation-(38) construction. -/
theorem eq38_clean_uniform_resource_closure
    (singleGateCount singleDepth : Nat → Nat)
    (singleResources :
      SingleControlResourceTarget singleGateCount singleDepth) :
    TargetLinearLogResourceTarget
      (eq38CleanGateEnvelope singleGateCount)
      (eq38CleanDepthEnvelope singleDepth) := by
  rcases singleResources with
    ⟨singleGateConstant, singleDepthConstant, singleBounds⟩
  refine ⟨2 * singleGateConstant, 2 * singleDepthConstant, ?_⟩
  intro n
  have half := singleBounds (upperHalf n)
  have halfWidth : upperHalf n + 1 ≤ n + 1 := by
    unfold upperHalf lowerHalf
    omega
  have halfLog : lemmaTwoLogScale (upperHalf n) ≤ lemmaTwoLogScale n := by
    have logBound :
        Nat.log2 (upperHalf n + 1) ≤ Nat.log2 (n + 1) := by
      rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
      exact Nat.log_mono_right halfWidth
    unfold lemmaTwoLogScale
    omega
  constructor
  · unfold eq38CleanGateEnvelope
    calc
      2 * singleGateCount (upperHalf n) ≤
          2 * (singleGateConstant * (upperHalf n + 1)) :=
        Nat.mul_le_mul_left 2 half.1
      _ ≤ 2 * (singleGateConstant * (n + 1)) :=
        Nat.mul_le_mul_left 2
          (Nat.mul_le_mul_left singleGateConstant halfWidth)
      _ = (2 * singleGateConstant) * (n + 1) := by ring
  · unfold eq38CleanDepthEnvelope
    calc
      2 * singleDepth (upperHalf n) ≤
          2 * (singleDepthConstant * lemmaTwoLogScale (upperHalf n)) :=
        Nat.mul_le_mul_left 2 half.2
      _ ≤ 2 * (singleDepthConstant * lemmaTwoLogScale n) :=
        Nat.mul_le_mul_left 2
          (Nat.mul_le_mul_left singleDepthConstant halfLog)
      _ = (2 * singleDepthConstant) * lemmaTwoLogScale n := by ring

/-- Each separate logarithmic source factor is bounded by the joint
`log((k+1)(n+1))` scale used by the public Lemma-7 contract. -/
theorem combinedLog_le_two_jointLog (n controls : Nat) :
    combinedLogScale n controls ≤
      2 * (Nat.log2 ((controls + 1) * (n + 1)) + 1) := by
  have nValue : n + 1 ≤ (controls + 1) * (n + 1) := by
    have positive : 1 ≤ controls + 1 := by omega
    nlinarith
  have kValue : controls + 1 ≤ (controls + 1) * (n + 1) := by
    have positive : 1 ≤ n + 1 := by omega
    nlinarith
  have nLog :
      Nat.log2 (n + 1) ≤
        Nat.log2 ((controls + 1) * (n + 1)) := by
    rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
    exact Nat.log_mono_right nValue
  have kLog :
      Nat.log2 (controls + 1) ≤
        Nat.log2 ((controls + 1) * (n + 1)) := by
    rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
    exact Nat.log_mono_right kValue
  unfold combinedLogScale lemmaTwoLogScale
    VandaeleLemma1Contract.logScale
  omega

/-- Figure-9 single-control resources, Lemmas 1/2, Equation (36), and Equation
(38) close the full uniform gate/depth statement of Lemma 7. -/
theorem lemmaSeven_uniform_resource_closure
    (singleGateCount singleDepth : Nat → Nat)
    (fanoutGateCount fanoutDepth : Nat → Nat)
    (multiXGateCount multiXDepth multiXDirtyAncillas : Nat → Nat)
    (singleResources :
      SingleControlResourceTarget singleGateCount singleDepth)
    (fanoutResources :
      FirstOrderFanoutUniformResourceTarget fanoutGateCount fanoutDepth)
    (multiXResources :
      LemmaOneUniformResourceTarget
        multiXGateCount multiXDepth multiXDirtyAncillas) :
    LemmaSevenResourceTarget
      (eq36GateEnvelope
        (eq38CleanGateEnvelope singleGateCount)
        (controlledFanoutGateEnvelope fanoutGateCount multiXGateCount)
        multiXGateCount)
      (eq36DepthEnvelope
        (eq38CleanDepthEnvelope singleDepth)
        (controlledFanoutDepthEnvelope fanoutDepth multiXDepth)
        multiXDepth) := by
  have cleanResources :=
    eq38_clean_uniform_resource_closure
      singleGateCount singleDepth singleResources
  have controlledFanoutResources :=
    controlledFanout_uniform_resource_closure
      fanoutGateCount fanoutDepth
      multiXGateCount multiXDepth multiXDirtyAncillas
      fanoutResources multiXResources
  have eq36Resources :=
    eq36_uniform_resource_closure
      (eq38CleanGateEnvelope singleGateCount)
      (eq38CleanDepthEnvelope singleDepth)
      (controlledFanoutGateEnvelope fanoutGateCount multiXGateCount)
      (controlledFanoutDepthEnvelope fanoutDepth multiXDepth)
      (fun _ controls => multiXDirtyAncillas controls)
      multiXGateCount multiXDepth multiXDirtyAncillas
      cleanResources controlledFanoutResources multiXResources
  rcases eq36Resources with
    ⟨gateConstant, depthConstant, bounds⟩
  constructor
  · refine ⟨gateConstant, ?_⟩
    intro controls n
    have bound := (bounds n controls).1
    simpa [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc] using bound
  · refine ⟨2 * depthConstant, ?_⟩
    intro controls n
    have bound := (bounds n controls).2
    calc
      eq36DepthEnvelope
          (eq38CleanDepthEnvelope singleDepth)
          (controlledFanoutDepthEnvelope fanoutDepth multiXDepth)
          multiXDepth n controls ≤
        depthConstant * combinedLogScale n controls := bound
      _ ≤ depthConstant *
          (2 * (Nat.log2 ((controls + 1) * (n + 1)) + 1)) :=
        Nat.mul_le_mul_left depthConstant
          (combinedLog_le_two_jointLog n controls)
      _ = (2 * depthConstant) *
          (Nat.log2 ((controls + 1) * (n + 1)) + 1) := by ring

/-- Exact workspace side of the same source proof: Eq.-(38) internal clean
substitutes plus the one dirty bit from Eq.-(36) fit in the `n-1` promise
register. -/
theorem lemmaSeven_ancilla_budget_closed
    {n : Nat} (large : 3 ≤ n) :
    halfIncrementCleanNeed n + reservedDirtyPromiseBits n ≤
      lemmaSevenPromiseWidth n :=
  halfClean_plus_dirty_le_promiseWidth large

end ComparatorIncrementerLemma7ResourceClosure
end QuantumBlockEncoding
