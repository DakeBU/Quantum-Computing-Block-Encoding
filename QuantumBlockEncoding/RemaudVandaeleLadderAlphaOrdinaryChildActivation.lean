import QuantumBlockEncoding.MultiControlledXEmbedding
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOrdinaryActivationFactors
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveControlGeometry
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaSelectedMembershipGeometry
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaSelectedOrder
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveOrder
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaTargetMembership
import Mathlib.Tactic

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaOrdinaryChildActivation

open MultiControlledXEmbedding
open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaOrdinaryActivationFactors
open RemaudVandaeleLadderAlphaRankCertificate
open RemaudVandaeleLadderAlphaRecursiveCertificate
open RemaudVandaeleLadderAlphaRecursiveControlGeometry
open RemaudVandaeleLadderAlphaRecursiveEndpointGeometry
open RemaudVandaeleLadderAlphaRecursiveOrder
open RemaudVandaeleLadderAlphaRecursiveParameters
open RemaudVandaeleLadderAlphaSelectedMembershipGeometry
open RemaudVandaeleLadderAlphaSelectedOrder
open RemaudVandaeleLadderAlphaSelectedRegister
open RemaudVandaeleLadderAlphaTargetMembership

/-- The odd alpha target between the two ordinary child endpoints is exactly one
of the wires deleted from X'. -/
theorem ordinaryMiddle_deleted
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (ordinary : ¬ isSpecialTail m j) :
    deletedPhysicalWire plan large
      (plan.target (ordinaryMiddleSourceIndex m large j ordinary)) := by
  let middle := ordinaryMiddleSourceIndex m large j ordinary
  refine ⟨middle, ?_, ?_, rfl⟩
  · simp [middle, ordinaryMiddleSourceIndex]
  · have currentLe := recursiveOriginalTargetIndex_le_end m large j
    have currentVal := recursiveOriginalTargetIndex_ordinary m large j ordinary
    simp [middle, ordinaryMiddleSourceIndex] at *
    omega

/-- Any physical wire in the ordinary two-interval span, except the deleted odd
middle alpha target itself, is retained in X'. -/
theorem ordinaryCompactedControl_mem_selectedList
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (ordinary : ¬ isSpecialTail m j)
    (wire : Fin q)
    (lower :
      (plan.target (ordinaryLowerSourceIndex m large j ordinary)).val ≤ wire.val)
    (upper : wire.val <
      (plan.target (recursiveOriginalTargetIndex m large j)).val)
    (notMiddle : wire ≠
      plan.target (ordinaryMiddleSourceIndex m large j ordinary)) :
    wire ∈ selectedList plan large := by
  let lowerIndex := ordinaryLowerSourceIndex m large j ordinary
  let middle := ordinaryMiddleSourceIndex m large j ordinary
  let current := recursiveOriginalTargetIndex m large j
  have startToLower :
      selectedStart plan large ≤ (plan.target lowerIndex).val := by
    unfold selectedStart
    exact target_le_of_index_le plan (by
      simp [lowerIndex, ordinaryLowerSourceIndex])
  have selectedLower : selectedStart plan large ≤ wire.val :=
    startToLower.trans lower
  have currentToEnd := recursiveTarget_le_end plan large j
  have selectedUpper : wire.val ≤ selectedEnd plan large :=
    upper.le.trans currentToEnd
  have retained : ¬ deletedPhysicalWire plan large wire := by
    intro deleted
    rcases deleted with ⟨source, sourceOdd, _beforeEnd, sourceEq⟩
    have sourceValues := congrArg Fin.val sourceEq
    have sourceNotBeforeLower : ¬ source.val < lowerIndex.val := by
      intro sourceBefore
      have strict := plan.strict (show source < lowerIndex by exact sourceBefore)
      dsimp [lowerIndex] at strict
      rw [sourceEq] at strict
      omega
    have sourceLower : lowerIndex.val ≤ source.val := by omega
    have sourceBeforeCurrent : source.val < current.val := by
      by_contra notBefore
      have indexOrder : current.val ≤ source.val := by omega
      have targetOrder := target_le_of_index_le plan indexOrder
      dsimp [current] at targetOrder
      rw [sourceEq] at targetOrder
      omega
    have endpointValues := ordinary_endpoint_values m large j ordinary
    have lowerVal : lowerIndex.val = 2 * j.val := by
      simpa [lowerIndex] using endpointValues.1
    have middleVal : middle.val = 2 * j.val + 1 := by
      simpa [middle] using endpointValues.2.1
    have currentVal : current.val = 2 * j.val + 2 := by
      simpa [current] using endpointValues.2.2
    have sourceMiddleVal : source.val = middle.val := by
      rw [lowerVal] at sourceLower
      rw [currentVal] at sourceBeforeCurrent
      rw [middleVal]
      omega
    have sourceMiddle : source = middle := Fin.ext sourceMiddleVal
    subst source
    exact notMiddle sourceEq.symm
  exact (mem_selectedList_iff plan large wire).2
    ⟨selectedLower, selectedUpper, retained⟩

/-- Ordinary child activation is exactly the compacted physical two-interval
predicate with the middle odd alpha target removed. -/
theorem recursiveIntervalActive_ordinary_iff_compacted
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q)
    (j : Fin (recursiveTargetCount m))
    (ordinary : ¬ isSpecialTail m j) :
    intervalActive
        (recursivePlan plan large (canonicalCertificate plan large))
        (readEmbedded (selectedWire plan large) state) j ↔
      ordinaryCompactedPhysicalActive plan large state j ordinary := by
  let childPlan := recursivePlan plan large (canonicalCertificate plan large)
  have lowerEq := recursiveControlPhysicalLower_ordinary
    plan large j ordinary
  constructor
  · intro childActive wire lower upper notMiddle
    have member := ordinaryCompactedControl_mem_selectedList
      plan large j ordinary wire lower upper notMiddle
    rcases exists_selectedWire_eq_of_mem plan large member with
      ⟨logical, logicalEq⟩
    have childControl : inControlInterval childPlan j logical := by
      apply (recursivePlan_inControlInterval_iff_physical
        plan large j logical).2
      constructor
      · rw [lowerEq, logicalEq]
        exact lower
      · rw [logicalEq]
        exact upper
    have one := childActive logical childControl
    simpa [readEmbedded, logicalEq] using one
  · intro compacted logical childControl
    have physical :=
      (recursivePlan_inControlInterval_iff_physical
        plan large j logical).1 childControl
    apply compacted (selectedWire plan large logical)
    · rw [← lowerEq]
      exact physical.1
    · exact physical.2
    · intro middleEq
      have member := selectedWire_mem_selectedList plan large logical
      have retained := (mem_selectedList_iff plan large
        (selectedWire plan large logical)).1 member
      apply retained.2.2
      have deleted := ordinaryMiddle_deleted plan large j ordinary
      simpa [middleEq] using deleted

/-- Reader-facing ordinary activation formula used by the cancellation theorem:
child activation is A_j and B_j. -/
theorem recursiveIntervalActive_ordinary_iff_factors
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q)
    (j : Fin (recursiveTargetCount m))
    (ordinary : ¬ isSpecialTail m j) :
    intervalActive
        (recursivePlan plan large (canonicalCertificate plan large))
        (readEmbedded (selectedWire plan large) state) j ↔
      intervalActive plan state
        (ordinaryMiddleSourceIndex m large j ordinary) ∧
      RemaudVandaeleLadderAlphaIntervalFactorization.strictInteriorActive
        plan state (recursiveOriginalTargetIndex m large j) := by
  exact (recursiveIntervalActive_ordinary_iff_compacted
    plan large state j ordinary).trans
      (ordinaryCompactedPhysicalActive_iff plan large state j ordinary)

end RemaudVandaeleLadderAlphaOrdinaryChildActivation
end QuantumBlockEncoding
