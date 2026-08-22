import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOuterSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveTargetExclusion
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaSelectedRegister
import Mathlib.Tactic

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaSelectedNoninterference

open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaOuterLayers
open RemaudVandaeleLadderAlphaOuterSemantics
open RemaudVandaeleLadderAlphaRecursiveOrder
open RemaudVandaeleLadderAlphaRecursiveParameters
open RemaudVandaeleLadderAlphaResource
open RemaudVandaeleLadderAlphaSelectedRegister
open MultiControlledXEmbedding

theorem selectedWire_mem_selectedList
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (index : Fin (selectedWidth plan large)) :
    selectedWire plan large index ∈ selectedList plan large := by
  classical
  let physicalIndex : Fin (selectedList plan large).length :=
    ⟨index.val, by simpa [selectedWidth] using index.isLt⟩
  have member := (selectedList plan large).get_mem physicalIndex
  simpa [selectedWire, physicalIndex] using member

theorem selectedWire_le_end
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (index : Fin (selectedWidth plan large)) :
    (selectedWire plan large index).val ≤ selectedEnd plan large := by
  classical
  have selectedMember := selectedWire_mem_selectedList plan large index
  unfold selectedList at selectedMember
  have intervalMember := (List.mem_filter.mp selectedMember).1
  unfold intervalList at intervalMember
  rw [List.mem_map] at intervalMember
  rcases intervalMember with ⟨offset, _offsetMember, wireEq⟩
  have offsetLt : offset.val < selectedRangeLength plan large := offset.isLt
  have startEnd := selectedStart_le_end plan large
  have values := congrArg Fin.val wireEq
  simp [intervalWire] at values
  unfold selectedRangeLength at offsetLt
  omega

theorem recursiveEndOriginalIndex_lt_final
    (m : Nat) (large : 3 ≤ m + 1) :
    (recursiveEndOriginalIndex m large).val < m - 1 :=
  RemaudVandaeleLadderAlphaRecursiveTargetExclusion.recursiveEndOriginalIndex_lt_final
    m large

theorem selectedEnd_lt_finalTarget
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) :
    selectedEnd plan large <
      (plan.target ⟨m - 1, by omega⟩).val := by
  unfold selectedEnd
  apply plan.strict
  exact recursiveEndOriginalIndex_lt_final m large

theorem nonfinalLeftTarget_deleted
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (wallCount m))
    (nonfinal : j.val + 1 ≠ wallCount m) :
    deletedPhysicalWire plan large
      (plan.target (leftSourceIndex m j)) := by
  have hjHalf : j.val < m / 2 := by
    simpa only [wallCount_eq] using j.isLt
  have nonfinalHalf : j.val + 1 ≠ m / 2 := by
    simpa only [wallCount_eq] using nonfinal
  have beforeLast : j.val + 1 < m / 2 := by omega
  have countPos : 0 < recursiveTargetCount m := by
    unfold recursiveTargetCount recursiveK
    omega
  have sourceVal : (leftSourceIndex m j).val = 2 * j.val + 1 := by
    unfold leftSourceIndex
    rw [dif_neg nonfinal]
  refine ⟨leftSourceIndex m j, ?_, ?_, rfl⟩
  · rw [sourceVal]
    omega
  · rw [sourceVal]
    unfold recursiveEndOriginalIndex
    rw [dif_neg (Nat.ne_of_gt countPos)]
    let last : Fin (recursiveTargetCount m) :=
      ⟨recursiveTargetCount m - 1, by omega⟩
    by_cases special : isSpecialTail m last
    · rw [recursiveOriginalTargetIndex_special m large last special]
      omega
    · rw [recursiveOriginalTargetIndex_ordinary m large last special]
      dsimp [last]
      unfold recursiveTargetCount recursiveK at countPos ⊢
      omega

theorem leftSourceTarget_ne_selectedWire
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (wallCount m))
    (index : Fin (selectedWidth plan large)) :
    plan.target (leftSourceIndex m j) ≠ selectedWire plan large index := by
  classical
  by_cases final : j.val + 1 = wallCount m
  · intro equal
    have sourceIndex : leftSourceIndex m j = ⟨m - 1, by omega⟩ := by
      apply Fin.ext
      unfold leftSourceIndex
      rw [dif_pos final]
    have recursiveBound := selectedWire_le_end plan large index
    have finalBound := selectedEnd_lt_finalTarget plan large
    rw [sourceIndex] at equal
    have values := congrArg Fin.val equal
    omega
  · intro equal
    have deleted := nonfinalLeftTarget_deleted plan large j final
    have selectedMember := selectedWire_mem_selectedList plan large index
    unfold selectedList at selectedMember
    have kept := (List.mem_filter.mp selectedMember).2
    have notDeleted :=
      (keepPhysicalWire_eq_true_iff plan large
        (selectedWire plan large index)).1 kept
    apply notDeleted
    simpa [equal] using deleted

theorem leftScheduled_preserves_selectedWire
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q)
    (index : Fin (selectedWidth plan large)) :
    (leftScheduled plan).eval state (selectedWire plan large index) =
      state (selectedWire plan large index) := by
  apply leftScheduled_preserves_of_no_target
  intro j
  exact leftSourceTarget_ne_selectedWire plan large j index

theorem readEmbedded_leftScheduled
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q) :
    readEmbedded (selectedWire plan large) ((leftScheduled plan).eval state) =
      readEmbedded (selectedWire plan large) state := by
  funext index
  exact leftScheduled_preserves_selectedWire plan large state index

end RemaudVandaeleLadderAlphaSelectedNoninterference
end QuantumBlockEncoding