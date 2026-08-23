import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOuterSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveTargetExclusion
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaSelectedRegister
import Mathlib.Tactic

/-!
# Algorithm 2: the left outer wall preserves the recursive register X'

The source recursion is only semantically useful once the state entering the
embedded child can be identified with the original state restricted to the
selected physical register `X'`.

Algorithm 2 was designed exactly for this.  Every nonfinal target of the left
wall is an odd intermediate alpha target and is therefore deleted from `X'`;
the final left-wall target is the final source target and lies strictly after
the recursive end.  Consequently `C_L` cannot target any selected wire.

This module turns that source geometry into the exact readback theorem needed by
the Equation-(7) induction.
-/

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

/-- Every compact coordinate denotes an actual member of the physical selected
register list. -/
theorem selectedWire_mem_selectedList
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (index : Fin (selectedWidth plan large)) :
    selectedWire plan large index ∈ selectedList plan large := by
  classical
  let physicalIndex : Fin (selectedList plan large).length :=
    ⟨index.val, by simpa [selectedWidth] using index.isLt⟩
  have member := (selectedList plan large).get_mem physicalIndex
  simpa [selectedWire, physicalIndex] using member

/-- Every selected physical wire lies no later than the physical recursive end. -/
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

/-- Reuse the already-verified recursive-target exclusion theorem: the physical
recursive end lies strictly before the final parent source target. -/
theorem recursiveEndOriginalIndex_lt_final
    (m : Nat) (large : 3 ≤ m + 1) :
    (recursiveEndOriginalIndex m large).val < m - 1 :=
  RemaudVandaeleLadderAlphaRecursiveTargetExclusion.recursiveEndOriginalIndex_lt_final
    m large

/-- Therefore the final source target is physically strictly after the selected
recursive interval. -/
theorem selectedEnd_lt_finalTarget
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) :
    selectedEnd plan large <
      (plan.target ⟨m - 1, by omega⟩).val := by
  unfold selectedEnd
  apply plan.strict
  exact recursiveEndOriginalIndex_lt_final m large

/-- A nonfinal left-wall slot is exactly one of the deleted odd intermediate
source targets. -/
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
  refine ⟨leftSourceIndex m j, ?_, ?_, rfl⟩
  · simp [leftSourceIndex, nonfinal]
  · simp [leftSourceIndex, nonfinal]
    unfold recursiveEndOriginalIndex
    split_ifs with empty
    · unfold recursiveTargetCount recursiveK at empty
      omega
    · let last : Fin (recursiveTargetCount m) :=
        ⟨recursiveTargetCount m - 1, by omega⟩
      change 2 * j.val + 1 <
        (recursiveOriginalTargetIndex m large last).val
      by_cases special : isSpecialTail m last
      · rw [recursiveOriginalTargetIndex_special m large last special]
        have specialEven := special.1
        omega
      · rw [recursiveOriginalTargetIndex_ordinary m large last special]
        have lastLt := last.isLt
        unfold recursiveTargetCount recursiveK at lastLt
        omega

/-- No left-wall source target is one of the selected physical X' wires. -/
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
      simp [leftSourceIndex, final]
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

/-- The concrete left wall preserves every coordinate of the selected physical
recursive register. -/
theorem leftScheduled_preserves_selectedWire
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q)
    (index : Fin (selectedWidth plan large)) :
    (leftScheduled plan).eval state (selectedWire plan large index) =
      state (selectedWire plan large index) := by
  apply leftScheduled_preserves_of_no_target
  intro j
  exact leftSourceTarget_ne_selectedWire plan large j index

/-- Exact readback statement: entering the recursive child after `C_L` sees the
same logical X' basis state as restricting the original parent input to X'. -/
theorem readEmbedded_leftScheduled
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q) :
    readEmbedded (selectedWire plan large) ((leftScheduled plan).eval state) =
      readEmbedded (selectedWire plan large) state := by
  funext index
  exact leftScheduled_preserves_selectedWire plan large state index

end RemaudVandaeleLadderAlphaSelectedNoninterference
end QuantumBlockEncoding