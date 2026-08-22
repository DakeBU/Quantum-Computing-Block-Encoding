import QuantumBlockEncoding.MultiControlledXScheduleSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaAlgorithmSchedule
import Mathlib.Tactic

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaMappedRecursiveTargetSemantics

open MultiControlledXEmbedding
open MultiControlledXSchedule
open MultiControlledXScheduleSemantics
open RemaudVandaeleLadderAlphaAlgorithmSchedule
open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaRankCertificate
open RemaudVandaeleLadderAlphaRecursiveCertificate
open RemaudVandaeleLadderAlphaRecursiveParameters
open RemaudVandaeleLadderAlphaSelectedRegister

/-- A local semantic hypothesis for one recursively synthesized child. -/
def ChildAlgorithmSpec
    {q m : Nat} (plan : AlphaPlan q m) : Prop :=
  ∀ state, (algorithm plan).eval state = equationSevenAction plan state

/-- The embedded child action on its j-th logical target is exactly the child
Equation-(7) target action, read back at the corresponding parent physical
alpha target.  This theorem is independent of the left outer wall. -/
theorem mappedRecursive_target_action
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q)
    (j : Fin (recursiveTargetCount m))
    (childCorrect : ChildAlgorithmSpec
      (recursivePlan plan large (canonicalCertificate plan large))) :
    (mapScheduled
      (selectedWire plan large)
      (selectedWire_injective plan large)
      (algorithm
        (recursivePlan plan large (canonicalCertificate plan large)))).eval
      state
      (plan.target (recursiveOriginalTargetIndex m large j)) =
    equationSevenAction
      (recursivePlan plan large (canonicalCertificate plan large))
      (readEmbedded (selectedWire plan large) state)
      ((recursivePlan plan large (canonicalCertificate plan large)).target j) := by
  let childPlan := recursivePlan plan large (canonicalCertificate plan large)
  have readback := congrFun
    (readEmbedded_evalScheduled
      (selectedWire plan large)
      (selectedWire_injective plan large)
      (algorithm childPlan) state)
    (childPlan.target j)
  have physical :
      selectedWire plan large (childPlan.target j) =
        plan.target (recursiveOriginalTargetIndex m large j) := by
    simpa [childPlan] using canonical_recursive_target_physical plan large j
  have childSemantics := childCorrect (readEmbedded (selectedWire plan large) state)
  change
    (mapScheduled
      (selectedWire plan large)
      (selectedWire_injective plan large)
      (algorithm childPlan)).eval state
      (plan.target (recursiveOriginalTargetIndex m large j)) =
      equationSevenAction childPlan
        (readEmbedded (selectedWire plan large) state)
        (childPlan.target j)
  unfold readEmbedded at readback
  rw [physical] at readback
  rw [childSemantics] at readback
  exact readback

end RemaudVandaeleLadderAlphaMappedRecursiveTargetSemantics
end QuantumBlockEncoding
