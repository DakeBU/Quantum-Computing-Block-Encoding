import QuantumBlockEncoding.FilteredListRank
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRankArithmetic
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaTargetMembership
import Mathlib.Tactic

/-!
# Algorithm 2: exact deleted-target count before one recursive target

For recursive source target r, the unfiltered physical interval prefix ends
immediately before alpha_r. Algorithm 2 deletes exactly alpha_i with odd source
index i<r. There are floor(r/2) such indices. We prove the cardinality by two
injections, one in each direction.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaDeletedPrefixCount

open FilteredListRank
open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaRankArithmetic
open RemaudVandaeleLadderAlphaRecursiveOrder
open RemaudVandaeleLadderAlphaRecursiveParameters
open RemaudVandaeleLadderAlphaSelectedRegister
open RemaudVandaeleLadderAlphaTargetMembership

def targetPrefix
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) : List (Fin q) :=
  (intervalList plan large).take (recursiveTargetOffset plan large j)

def deletePhysicalWireBool
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) :
    Fin q → Bool :=
  FilteredListRank.deleteOfKeep (keepPhysicalWire plan large)

@[simp] theorem deletePhysicalWireBool_eq_true_iff
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (wire : Fin q) :
    deletePhysicalWireBool plan large wire = true ↔
      deletedPhysicalWire plan large wire := by
  unfold deletePhysicalWireBool FilteredListRank.deleteOfKeep
  by_cases deleted : deletedPhysicalWire plan large wire
  · simp [keepPhysicalWire, deleted]
  · simp [keepPhysicalWire, deleted]

def deletedPrefix
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) : List (Fin q) :=
  (targetPrefix plan large j).filter (deletePhysicalWireBool plan large)

theorem targetPrefix_length
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    (targetPrefix plan large j).length = recursiveTargetOffset plan large j := by
  unfold targetPrefix
  rw [List.length_take]
  have bound : recursiveTargetOffset plan large j ≤ (intervalList plan large).length := by
    have strict := recursiveTargetOffset_lt plan large j
    simpa [intervalList] using strict.le
  exact min_eq_left bound

theorem earlierTarget_mem_prefix
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (source : Fin m)
    (earlier : source.val < (recursiveOriginalTargetIndex m large j).val) :
    plan.target source ∈ targetPrefix plan large j := by
  have startLower : selectedStart plan large ≤ (plan.target source).val := by
    unfold selectedStart
    exact target_le_of_index_le plan (Nat.zero_le _)
  have targetStrict :
      (plan.target source).val <
        (plan.target (recursiveOriginalTargetIndex m large j)).val :=
    plan.strict (by omega)
  let offset := (plan.target source).val - selectedStart plan large
  have offsetLt : offset < recursiveTargetOffset plan large j := by
    unfold offset recursiveTargetOffset
    omega
  have intervalBound : offset < selectedRangeLength plan large :=
    offsetLt.trans (recursiveTargetOffset_lt plan large j)
  let fullIndex : Fin (intervalList plan large).length :=
    ⟨offset, by simpa [intervalList] using intervalBound⟩
  have fullValue : (intervalList plan large).get fullIndex = plan.target source := by
    unfold intervalList
    apply Fin.ext
    simpa [fullIndex, intervalWire, offset] using Nat.add_sub_of_le startLower
  let prefixIndex : Fin (targetPrefix plan large j).length :=
    ⟨offset, by simpa [targetPrefix_length plan large j] using offsetLt⟩
  apply List.mem_iff_get.mpr
  refine ⟨prefixIndex, ?_⟩
  unfold targetPrefix
  simpa [prefixIndex, fullIndex] using fullValue

theorem mem_prefix_lt_recursiveTarget
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (wire : Fin q) (member : wire ∈ targetPrefix plan large j) :
    wire.val < (plan.target (recursiveOriginalTargetIndex m large j)).val := by
  rcases List.mem_iff_get.mp member with ⟨index,indexValue⟩
  have indexLt : index.val < recursiveTargetOffset plan large j := by
    simpa [targetPrefix_length plan large j] using index.isLt
  have fullIndexLt : index.val < (intervalList plan large).length := by
    have source := recursiveTargetOffset_lt plan large j
    simpa [intervalList] using indexLt.trans source
  let fullIndex : Fin (intervalList plan large).length := ⟨index.val, fullIndexLt⟩
  have takeValue : (intervalList plan large).get fullIndex = wire := by
    unfold targetPrefix at indexValue
    simpa [fullIndex] using indexValue
  unfold intervalList at takeValue
  have physical : wire.val = selectedStart plan large + index.val := by
    rw [← takeValue]
    simp [fullIndex, intervalWire]
  unfold recursiveTargetOffset at indexLt
  have lower := recursiveTarget_ge_start plan large j
  omega

theorem deleted_prefix_source_before
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (wire : Fin q)
    (prefixMember : wire ∈ targetPrefix plan large j)
    (deleted : deletedPhysicalWire plan large wire) :
    ∃ source : Fin m,
      source.val % 2 = 1 ∧
      source.val < (recursiveOriginalTargetIndex m large j).val ∧
      plan.target source = wire := by
  rcases deleted with ⟨source,odd,_beforeEnd,equal⟩
  have physicalLt := mem_prefix_lt_recursiveTarget plan large j wire prefixMember
  have sourceBefore :
      source.val < (recursiveOriginalTargetIndex m large j).val := by
    by_contra notBefore
    have indexOrder :
        (recursiveOriginalTargetIndex m large j).val ≤ source.val := by omega
    have targetOrder := target_le_of_index_le plan indexOrder
    rw [equal] at targetOrder
    omega
  exact ⟨source,odd,sourceBefore,equal⟩

theorem deletedPrefix_nodup
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    (deletedPrefix plan large j).Nodup := by
  unfold deletedPrefix targetPrefix
  exact (intervalList_nodup plan large).take.filter _

noncomputable def deletedSourceIndex
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (entry : Fin (deletedPrefix plan large j).length) : Fin m :=
  Classical.choose (deleted_prefix_source_before plan large j
    ((deletedPrefix plan large j).get entry)
    (by
      have member : (deletedPrefix plan large j).get entry ∈
          deletedPrefix plan large j := List.get_mem _ _
      exact (List.mem_filter.mp member).1)
    (by
      have member : (deletedPrefix plan large j).get entry ∈
          deletedPrefix plan large j := List.get_mem _ _
      exact (deletePhysicalWireBool_eq_true_iff plan large _).1
        (List.mem_filter.mp member).2))

theorem deletedSourceIndex_spec
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (entry : Fin (deletedPrefix plan large j).length) :
    (deletedSourceIndex plan large j entry).val % 2 = 1 ∧
    (deletedSourceIndex plan large j entry).val <
      (recursiveOriginalTargetIndex m large j).val ∧
    plan.target (deletedSourceIndex plan large j entry) =
      (deletedPrefix plan large j).get entry :=
  Classical.choose_spec (deleted_prefix_source_before plan large j
    ((deletedPrefix plan large j).get entry)
    (by
      have member : (deletedPrefix plan large j).get entry ∈
          deletedPrefix plan large j := List.get_mem _ _
      exact (List.mem_filter.mp member).1)
    (by
      have member : (deletedPrefix plan large j).get entry ∈
          deletedPrefix plan large j := List.get_mem _ _
      exact (deletePhysicalWireBool_eq_true_iff plan large _).1
        (List.mem_filter.mp member).2))

noncomputable def deletedToHalf
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    Fin (deletedPrefix plan large j).length →
      Fin ((recursiveOriginalTargetIndex m large j).val / 2) :=
  fun entry =>
    let source := deletedSourceIndex plan large j entry
    ⟨source.val / 2, by
      have spec := deletedSourceIndex_spec plan large j entry
      omega⟩

theorem deletedToHalf_injective
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    Function.Injective (deletedToHalf plan large j) := by
  intro left right equal
  have leftSpec := deletedSourceIndex_spec plan large j left
  have rightSpec := deletedSourceIndex_spec plan large j right
  have halfEq := congrArg Fin.val equal
  simp [deletedToHalf] at halfEq
  have sourceEqVal :
      (deletedSourceIndex plan large j left).val =
        (deletedSourceIndex plan large j right).val := by
    omega
  have sourceEq :
      deletedSourceIndex plan large j left =
        deletedSourceIndex plan large j right := Fin.ext sourceEqVal
  have getEq :
      (deletedPrefix plan large j).get left =
        (deletedPrefix plan large j).get right := by
    rw [← leftSpec.2.2, ← rightSpec.2.2, sourceEq]
  exact (deletedPrefix_nodup plan large j).injective_get getEq

def halfSourceIndex
    {q m : Nat} (_plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (half : Fin ((recursiveOriginalTargetIndex m large j).val / 2)) : Fin m :=
  ⟨2 * half.val + 1, by
    have halfLt := half.isLt
    have targetLt := (recursiveOriginalTargetIndex m large j).isLt
    omega⟩

theorem halfSourceIndex_before
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (half : Fin ((recursiveOriginalTargetIndex m large j).val / 2)) :
    (halfSourceIndex plan large j half).val <
      (recursiveOriginalTargetIndex m large j).val := by
  have halfLt := half.isLt
  simp [halfSourceIndex]
  omega

theorem halfSource_target_mem_deletedPrefix
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (half : Fin ((recursiveOriginalTargetIndex m large j).val / 2)) :
    plan.target (halfSourceIndex plan large j half) ∈
      deletedPrefix plan large j := by
  unfold deletedPrefix
  rw [List.mem_filter]
  constructor
  · exact earlierTarget_mem_prefix plan large j
      (halfSourceIndex plan large j half)
      (halfSourceIndex_before plan large j half)
  · apply (deletePhysicalWireBool_eq_true_iff plan large _).2
    refine ⟨halfSourceIndex plan large j half, ?_, ?_, rfl⟩
    · simp [halfSourceIndex]
    · have sourceBefore := halfSourceIndex_before plan large j half
      exact sourceBefore.trans_le
        (recursiveOriginalTargetIndex_le_end m large j)

noncomputable def halfToDeleted
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    Fin ((recursiveOriginalTargetIndex m large j).val / 2) →
      Fin (deletedPrefix plan large j).length :=
  fun half =>
    ⟨(deletedPrefix plan large j).idxOf
        (plan.target (halfSourceIndex plan large j half)),
      List.idxOf_lt_length_iff.2
        (halfSource_target_mem_deletedPrefix plan large j half)⟩

theorem halfToDeleted_injective
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    Function.Injective (halfToDeleted plan large j) := by
  intro left right equal
  let leftEntry := halfToDeleted plan large j left
  let rightEntry := halfToDeleted plan large j right
  have leftValue :
      (deletedPrefix plan large j).get leftEntry =
        plan.target (halfSourceIndex plan large j left) := by
    have member := halfSource_target_mem_deletedPrefix plan large j left
    rcases List.mem_iff_get.mp member with ⟨actual,actualValue⟩
    have rank := List.get_idxOf (deletedPrefix_nodup plan large j) actual
    rw [actualValue] at rank
    have actualEq : actual = leftEntry := by
      apply Fin.ext
      simpa [leftEntry, halfToDeleted] using rank.symm
    simpa [leftEntry, actualEq] using actualValue
  have rightValue :
      (deletedPrefix plan large j).get rightEntry =
        plan.target (halfSourceIndex plan large j right) := by
    have member := halfSource_target_mem_deletedPrefix plan large j right
    rcases List.mem_iff_get.mp member with ⟨actual,actualValue⟩
    have rank := List.get_idxOf (deletedPrefix_nodup plan large j) actual
    rw [actualValue] at rank
    have actualEq : actual = rightEntry := by
      apply Fin.ext
      simpa [rightEntry, halfToDeleted] using rank.symm
    simpa [rightEntry, actualEq] using actualValue
  have entryEq : leftEntry = rightEntry := equal
  have targetEq :
      plan.target (halfSourceIndex plan large j left) =
        plan.target (halfSourceIndex plan large j right) := by
    rw [← leftValue, ← rightValue, entryEq]
  have sourceEq := target_injective plan targetEq
  apply Fin.ext
  have values := congrArg Fin.val sourceEq
  simp [halfSourceIndex] at values
  omega

theorem deletedPrefix_length
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    (deletedPrefix plan large j).length =
      (recursiveOriginalTargetIndex m large j).val / 2 := by
  have forward := Fintype.card_le_of_injective
    (deletedToHalf plan large j)
    (deletedToHalf_injective plan large j)
  have reverse := Fintype.card_le_of_injective
    (halfToDeleted plan large j)
    (halfToDeleted_injective plan large j)
  simpa using Nat.le_antisymm forward reverse

end RemaudVandaeleLadderAlphaDeletedPrefixCount
end QuantumBlockEncoding
