import QuantumBlockEncoding.MultiControlledXEmbedding
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveEndpointGeometry
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaSelectedMembershipGeometry
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaSelectedOrder
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveOrder
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaTargetMembership
import Mathlib.Tactic

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaSpecialTailActivation

open MultiControlledXEmbedding
open RemaudVandaeleLadderAlphaContract
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

theorem specialParentControl_mem_selectedList
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (special : isSpecialTail m j)
    (wire : Fin q)
    (control : inControlInterval plan
      (recursiveOriginalTargetIndex m large j) wire) :
    wire ∈ selectedList plan large := by
  let current := recursiveOriginalTargetIndex m large j
  let lowerIndex := specialLowerSourceIndex m large j special
  have currentVal := recursiveOriginalTargetIndex_special m large j special
  have currentOdd : current.val % 2 = 1 := by
    dsimp [current]
    rw [currentVal]
    omega
  have currentEnd : current = recursiveEndOriginalIndex m large :=
    odd_recursiveTarget_eq_end m large j currentOdd
  have controlLower := control.1
  rw [parentLowerEndpoint_special plan large j special] at controlLower
  have startToLower :
      selectedStart plan large ≤ (plan.target lowerIndex).val := by
    unfold selectedStart
    exact target_le_of_index_le plan (by
      simp [lowerIndex, specialLowerSourceIndex])
  have selectedLower : selectedStart plan large ≤ wire.val :=
    startToLower.trans controlLower
  have selectedUpper : wire.val ≤ selectedEnd plan large := by
    have controlUpper := control.2
    unfold selectedEnd
    rw [← currentEnd]
    exact controlUpper.le
  have retained : ¬ deletedPhysicalWire plan large wire := by
    intro deleted
    rcases deleted with ⟨source, sourceOdd, beforeEnd, sourceEq⟩
    have sourceValues := congrArg Fin.val sourceEq
    have sourceNotBeforeLower : ¬ source.val < lowerIndex.val := by
      intro sourceBeforeLower
      have targetStrict :
          (plan.target source).val < (plan.target lowerIndex).val :=
        plan.strict sourceBeforeLower
      omega
    have sourceLowerBound : lowerIndex.val ≤ source.val := by omega
    rw [← currentEnd] at beforeEnd
    have lowerVal : lowerIndex.val = m - 3 := by
      simp [lowerIndex, specialLowerSourceIndex]
    rw [lowerVal] at sourceLowerBound
    have sourceVal : source.val = m - 3 := by
      dsimp [current] at beforeEnd
      rw [currentVal] at beforeEnd
      omega
    rw [sourceVal] at sourceOdd
    omega
  exact (mem_selectedList_iff plan large wire).2
    ⟨selectedLower, selectedUpper, retained⟩

theorem recursiveIntervalActive_special_iff_parent
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q)
    (j : Fin (recursiveTargetCount m))
    (special : isSpecialTail m j) :
    intervalActive
        (recursivePlan plan large (canonicalCertificate plan large))
        (readEmbedded (selectedWire plan large) state) j ↔
      intervalActive plan state
        (recursiveOriginalTargetIndex m large j) := by
  let childPlan := recursivePlan plan large (canonicalCertificate plan large)
  have lowerEq :=
    recursiveControlPhysicalLower_special_eq_parentLowerEndpoint
      plan large j special
  constructor
  · intro childActive wire parentControl
    have member := specialParentControl_mem_selectedList
      plan large j special wire parentControl
    rcases exists_selectedWire_eq_of_mem plan large member with
      ⟨logical, logicalEq⟩
    have childControl : inControlInterval childPlan j logical := by
      apply (recursivePlan_inControlInterval_iff_physical
        plan large j logical).2
      constructor
      · rw [lowerEq, logicalEq]
        exact parentControl.1
      · rw [logicalEq]
        exact parentControl.2
    have one := childActive logical childControl
    simpa [readEmbedded, logicalEq] using one
  · intro parentActive logical childControl
    have physicalControl :=
      (recursivePlan_inControlInterval_iff_physical
        plan large j logical).1 childControl
    apply parentActive (selectedWire plan large logical)
    constructor
    · rw [← lowerEq]
      exact physicalControl.1
    · exact physicalControl.2

end RemaudVandaeleLadderAlphaSpecialTailActivation
end QuantumBlockEncoding