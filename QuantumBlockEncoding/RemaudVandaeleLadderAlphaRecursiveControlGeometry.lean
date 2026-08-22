import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRankCertificate
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaSelectedOrder
import Mathlib.Tactic

/-!
# Algorithm 2: physical geometry of recursive control intervals

The recursive child is expressed in compact `X'` coordinates, while Equation
(7) is stated on physical parent wires.  The canonical alpha-prime certificate
and strict order of `selectedWire` together give an exact translation of one
child control interval back to physical coordinates.

For child target `j`, the upper physical endpoint is the original source alpha
target selected by `recursiveOriginalTargetIndex`.  For `j=0`, the lower
endpoint is physical `alpha_0`; otherwise it is the physical parent target of
the preceding child target.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaRecursiveControlGeometry

open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaRankCertificate
open RemaudVandaeleLadderAlphaRecursiveCertificate
open RemaudVandaeleLadderAlphaRecursiveParameters
open RemaudVandaeleLadderAlphaSelectedOrder
open RemaudVandaeleLadderAlphaSelectedRegister

/-- Physical lower endpoint of the child control interval. -/
def recursiveControlPhysicalLower
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) : Nat :=
  if first : j.val = 0 then
    selectedStart plan large
  else
    (plan.target
      (recursiveOriginalTargetIndex m large
        ⟨j.val - 1, by omega⟩)).val

/-- Exact compact-to-physical control-interval translation. -/
theorem recursivePlan_inControlInterval_iff_physical
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (wire : Fin (selectedWidth plan large)) :
    inControlInterval
        (recursivePlan plan large (canonicalCertificate plan large)) j wire ↔
      recursiveControlPhysicalLower plan large j ≤
          (selectedWire plan large wire).val ∧
        (selectedWire plan large wire).val <
          (plan.target (recursiveOriginalTargetIndex m large j)).val := by
  let childPlan := recursivePlan plan large (canonicalCertificate plan large)
  have upperPhysical :
      selectedWire plan large (childPlan.target j) =
        plan.target (recursiveOriginalTargetIndex m large j) := by
    simpa [childPlan] using canonical_recursive_target_physical plan large j
  by_cases first : j.val = 0
  · constructor
    · intro interval
      have upperCompact : wire < childPlan.target j := by
        unfold inControlInterval upperEndpoint at interval
        exact interval.2
      have physicalUpper := selectedWire_strict plan large upperCompact
      rw [upperPhysical] at physicalUpper
      have physicalLower :
          recursiveControlPhysicalLower plan large j ≤
            (selectedWire plan large wire).val := by
        simpa [recursiveControlPhysicalLower, first] using
          selectedWire_ge_start plan large wire
      exact ⟨physicalLower, physicalUpper⟩
    · rintro ⟨_physicalLower, physicalUpper⟩
      have upperCompact : wire < childPlan.target j := by
        apply (selectedWire_lt_iff plan large).mp
        rw [upperPhysical]
        exact physicalUpper
      unfold inControlInterval lowerEndpoint upperEndpoint
      constructor
      · simp [first]
      · exact upperCompact
  · let previous : Fin (recursiveTargetCount m) :=
      ⟨j.val - 1, by omega⟩
    have previousPhysical :
        selectedWire plan large (childPlan.target previous) =
          plan.target (recursiveOriginalTargetIndex m large previous) := by
      simpa [childPlan, previous] using
        canonical_recursive_target_physical plan large previous
    constructor
    · intro interval
      have lowerCompact : childPlan.target previous ≤ wire := by
        unfold inControlInterval lowerEndpoint upperEndpoint at interval
        simpa [childPlan, first, previous] using interval.1
      have upperCompact : wire < childPlan.target j := by
        unfold inControlInterval upperEndpoint at interval
        exact interval.2
      have physicalLower := selectedWire_mono plan large lowerCompact
      have physicalUpper := selectedWire_strict plan large upperCompact
      rw [previousPhysical] at physicalLower
      rw [upperPhysical] at physicalUpper
      exact ⟨by
        simpa [recursiveControlPhysicalLower, first, previous] using physicalLower,
        physicalUpper⟩
    · rintro ⟨physicalLower, physicalUpper⟩
      have lowerSelected :
          (selectedWire plan large (childPlan.target previous)).val ≤
            (selectedWire plan large wire).val := by
        rw [previousPhysical]
        simpa [recursiveControlPhysicalLower, first, previous] using physicalLower
      have lowerCompact : childPlan.target previous ≤ wire :=
        (selectedWire_le_iff plan large).mp lowerSelected
      have upperSelected :
          (selectedWire plan large wire).val <
            (selectedWire plan large (childPlan.target j)).val := by
        rw [upperPhysical]
        exact physicalUpper
      have upperCompact : wire < childPlan.target j :=
        (selectedWire_lt_iff plan large).mp upperSelected
      unfold inControlInterval lowerEndpoint upperEndpoint
      constructor
      · simpa [childPlan, first, previous] using lowerCompact
      · exact upperCompact

/-- Reader-facing first-child specialization: the physical child interval starts
at parent `alpha_0`. -/
theorem recursivePlan_firstControl_iff_physical
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) (first : j.val = 0)
    (wire : Fin (selectedWidth plan large)) :
    inControlInterval
        (recursivePlan plan large (canonicalCertificate plan large)) j wire ↔
      selectedStart plan large ≤ (selectedWire plan large wire).val ∧
        (selectedWire plan large wire).val <
          (plan.target (recursiveOriginalTargetIndex m large j)).val := by
  simpa [recursiveControlPhysicalLower, first] using
    recursivePlan_inControlInterval_iff_physical plan large j wire

end RemaudVandaeleLadderAlphaRecursiveControlGeometry
end QuantumBlockEncoding
