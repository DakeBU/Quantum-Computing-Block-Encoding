import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveParameters
import Mathlib.Data.List.FinRange
import Mathlib.Tactic

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaSelectedRegister

open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaRecursiveParameters

def recursiveEndOriginalIndex
    (m : Nat) (large : 3 ≤ m + 1) : Fin m :=
  if empty : recursiveTargetCount m = 0 then
    ⟨0, by omega⟩
  else
    recursiveOriginalTargetIndex m large
      ⟨recursiveTargetCount m - 1, by omega⟩

theorem recursiveEndOriginalIndex_nonnegative
    (m : Nat) (large : 3 ≤ m + 1) :
    0 ≤ (recursiveEndOriginalIndex m large).val := Nat.zero_le _

def selectedStart
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) : Nat :=
  (plan.target ⟨0, by omega⟩).val

def selectedEnd
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) : Nat :=
  (plan.target (recursiveEndOriginalIndex m large)).val

theorem selectedStart_le_end
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) :
    selectedStart plan large ≤ selectedEnd plan large := by
  unfold selectedStart selectedEnd
  by_cases zero : (recursiveEndOriginalIndex m large).val = 0
  · have equal : recursiveEndOriginalIndex m large = ⟨0, by omega⟩ := by
      apply Fin.ext
      exact zero
    rw [equal]
  · have order :
        (⟨0, by omega⟩ : Fin m) < recursiveEndOriginalIndex m large := by
      change 0 < (recursiveEndOriginalIndex m large).val
      omega
    exact (plan.strict order).le

def selectedRangeLength
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) : Nat :=
  selectedEnd plan large - selectedStart plan large + 1

def intervalWire
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (offset : Fin (selectedRangeLength plan large)) : Fin q :=
  ⟨selectedStart plan large + offset.val, by
    have startEnd := selectedStart_le_end plan large
    have offsetLt := offset.isLt
    unfold selectedRangeLength at offsetLt
    have atMostEnd :
        selectedStart plan large + offset.val ≤ selectedEnd plan large := by
      omega
    have endLt : selectedEnd plan large < q := by
      unfold selectedEnd
      exact (plan.target (recursiveEndOriginalIndex m large)).isLt
    exact lt_of_le_of_lt atMostEnd endLt⟩

@[simp] theorem intervalWire_val
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (offset : Fin (selectedRangeLength plan large)) :
    (intervalWire plan large offset).val =
      selectedStart plan large + offset.val := rfl

theorem intervalWire_injective
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) :
    Function.Injective (intervalWire plan large) := by
  intro left right equal
  apply Fin.ext
  have values := congrArg Fin.val equal
  simp only [intervalWire_val] at values
  omega

def deletedPhysicalWire
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (wire : Fin q) : Prop :=
  ∃ index : Fin m,
    index.val % 2 = 1 ∧
    index.val < (recursiveEndOriginalIndex m large).val ∧
    plan.target index = wire

instance instDecidableDeletedPhysicalWire
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (wire : Fin q) : Decidable (deletedPhysicalWire plan large wire) := by
  unfold deletedPhysicalWire
  exact Fintype.decidableExistsFintype

def keepPhysicalWire
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (wire : Fin q) : Bool :=
  decide (¬ deletedPhysicalWire plan large wire)

@[simp] theorem keepPhysicalWire_eq_true_iff
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (wire : Fin q) :
    keepPhysicalWire plan large wire = true ↔
      ¬ deletedPhysicalWire plan large wire := by
  simp [keepPhysicalWire]

def intervalList
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) : List (Fin q) :=
  (List.finRange (selectedRangeLength plan large)).map
    (intervalWire plan large)

noncomputable def selectedList
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) : List (Fin q) :=
  (intervalList plan large).filter (keepPhysicalWire plan large)

theorem intervalList_nodup
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) :
    (intervalList plan large).Nodup := by
  unfold intervalList
  exact (List.nodup_finRange _).map (intervalWire_injective plan large)

theorem selectedList_nodup
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) :
    (selectedList plan large).Nodup := by
  unfold selectedList
  exact (intervalList_nodup plan large).filter _

noncomputable def selectedWidth
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) : Nat :=
  (selectedList plan large).length

noncomputable def selectedWire
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (index : Fin (selectedWidth plan large)) : Fin q :=
  (selectedList plan large).get
    ⟨index.val, by simpa [selectedWidth] using index.isLt⟩

theorem selectedWire_injective
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) :
    Function.Injective (selectedWire plan large) := by
  intro left right equal
  let leftIndex : Fin (selectedList plan large).length :=
    ⟨left.val, by simpa [selectedWidth] using left.isLt⟩
  let rightIndex : Fin (selectedList plan large).length :=
    ⟨right.val, by simpa [selectedWidth] using right.isLt⟩
  have indexEqual : leftIndex = rightIndex :=
    (selectedList_nodup plan large).injective_get (by
      simpa [selectedWire, leftIndex, rightIndex] using equal)
  apply Fin.ext
  exact congrArg Fin.val indexEqual

theorem selectedList_head
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) :
    (plan.target ⟨0, by omega⟩) ∈ selectedList plan large := by
  classical
  unfold selectedList
  rw [List.mem_filter]
  constructor
  · unfold intervalList
    rw [List.mem_map]
    let zeroOffset : Fin (selectedRangeLength plan large) :=
      ⟨0, by
        unfold selectedRangeLength
        omega⟩
    refine ⟨zeroOffset, List.mem_finRange zeroOffset, ?_⟩
    apply Fin.ext
    simp [intervalWire, selectedStart, zeroOffset]
  · apply (keepPhysicalWire_eq_true_iff plan large _).2
    intro deleted
    rcases deleted with ⟨index,odd,_before,equal⟩
    have indexEq : index = ⟨0, by omega⟩ := target_injective plan equal
    have values := congrArg Fin.val indexEq
    simp at values
    omega

theorem selectedList_contains_end
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) :
    plan.target (recursiveEndOriginalIndex m large) ∈
      selectedList plan large := by
  classical
  unfold selectedList
  rw [List.mem_filter]
  constructor
  · unfold intervalList
    rw [List.mem_map]
    let endOffset : Fin (selectedRangeLength plan large) :=
      ⟨selectedEnd plan large - selectedStart plan large, by
        unfold selectedRangeLength
        omega⟩
    refine ⟨endOffset, List.mem_finRange endOffset, ?_⟩
    apply Fin.ext
    change
      selectedStart plan large +
          (selectedEnd plan large - selectedStart plan large) =
        (plan.target (recursiveEndOriginalIndex m large)).val
    calc
      selectedStart plan large +
          (selectedEnd plan large - selectedStart plan large) =
          selectedEnd plan large :=
        Nat.add_sub_of_le (selectedStart_le_end plan large)
      _ = (plan.target (recursiveEndOriginalIndex m large)).val := rfl
  · apply (keepPhysicalWire_eq_true_iff plan large _).2
    intro deleted
    rcases deleted with ⟨index,_odd,before,equal⟩
    have indexEq : index = recursiveEndOriginalIndex m large :=
      target_injective plan equal
    have values := congrArg Fin.val indexEq
    omega

end RemaudVandaeleLadderAlphaSelectedRegister
end QuantumBlockEncoding
