import QuantumBlockEncoding.MultiControlledXEmbedding
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveEndpointGeometry
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaSelectedMembershipGeometry
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaSelectedOrder
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveOrder
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaTargetMembership
import Mathlib.Tactic

/-!
# Algorithm 2: special-tail activation equivalence

For even k, the final child target is the special parent source target k-3.
Unlike an ordinary child target, its parent source interval contains no deleted
intermediate alpha target: it is the single consecutive interval from
alpha_(k-4) to alpha_(k-3).  Hence the child interval on X' and the parent source
interval contain exactly the same physical control wires.
-/

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

/-- Every physical wire in the parent special-tail source interval is retained
in X'. -/
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
  have evenK := special.1
  have mOdd : m % 2 = 1 := by omega
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
      simp [lowerIndex, specialLowerSourceIndex]
      omega)
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
        plan.strict (by exact sourceBeforeLower)
      omega
    have sourceLowerBound : lowerIndex.val ≤ source.val := by omega
    rw [← currentEnd] at beforeEnd
    have lowerVal : lowerIndex.val = m - 3 := by
      simp [lowerIndex, specialLowerSourceIndex]
    have sourceVal : source.val = m - 3 := by
      dsimp [current] at beforeEnd
      rw [currentVal] at beforeEnd
      omega
    rw [sourceVal] at sourceOdd
    omega
  exact (mem_selectedList_iff plan large wire).2
    ⟨selectedLower, selectedUpper, retained⟩

/-- Child activation on the original parent input restricted to X' is exactly
parent special-tail source activation. -/
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
  let current := recursiveOriginalTargetIndex m large j
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
