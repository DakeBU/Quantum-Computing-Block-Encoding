import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveOrder
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaSelectedRegister
import Mathlib.Data.List.FinRange
import Mathlib.Tactic

/-!
# Algorithm 2: recursive targets are retained physical wires

Before counting the compacted rank, we separate the order/membership facts.
Every recursive alpha-prime target comes from one original alpha target.  This
module proves that its physical wire:

* lies inside the inclusive `[alpha_0, recursiveEnd]` interval;
* is not one of the deleted odd intermediate targets;
* therefore belongs to `selectedList`;
* has unfiltered interval-list index exactly `alpha_r - alpha_0`.

The only remaining rank step is then to subtract the number of deleted odd
targets before r.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaTargetMembership

open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaRecursiveOrder
open RemaudVandaeleLadderAlphaRecursiveParameters
open RemaudVandaeleLadderAlphaSelectedRegister

/-- Recursive source target indices are positive whenever they exist. -/
theorem recursiveOriginalTargetIndex_pos
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    0 < (recursiveOriginalTargetIndex m large j).val := by
  by_cases special : isSpecialTail m j
  · rw [recursiveOriginalTargetIndex_special m large j special]
    have hj := j.isLt
    have last := special.2
    unfold recursiveTargetCount RemaudVandaeleLadderAlphaResource.recursiveK at hj last
    omega
  · rw [recursiveOriginalTargetIndex_ordinary m large j special]
    omega

/-- Strict alpha plans are monotone on source indices. -/
theorem target_le_of_index_le
    {q m : Nat} (plan : AlphaPlan q m)
    {i j : Fin m} (order : i.val ≤ j.val) :
    (plan.target i).val ≤ (plan.target j).val := by
  by_cases equal : i = j
  · subst j
    rfl
  · have strictIndex : i < j := by
      have valuesNe : i.val ≠ j.val := by
        intro values
        apply equal
        exact Fin.ext values
      omega
    exact (plan.strict strictIndex).le

/-- One recursive target lies no earlier than alpha_0. -/
theorem recursiveTarget_ge_start
    {q m : Nat} (plan : AlphaPlan q m)
    (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    selectedStart plan large ≤
      (plan.target (recursiveOriginalTargetIndex m large j)).val := by
  unfold selectedStart
  exact target_le_of_index_le plan (Nat.zero_le _)

/-- One recursive target lies no later than the selected physical end. -/
theorem recursiveTarget_le_end
    {q m : Nat} (plan : AlphaPlan q m)
    (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    (plan.target (recursiveOriginalTargetIndex m large j)).val ≤
      selectedEnd plan large := by
  unfold selectedEnd
  exact target_le_of_index_le plan
    (recursiveOriginalTargetIndex_le_end m large j)

/-- Physical offset of one recursive target from alpha_0. -/
def recursiveTargetOffset
    {q m : Nat} (plan : AlphaPlan q m)
    (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) : Nat :=
  (plan.target (recursiveOriginalTargetIndex m large j)).val -
    selectedStart plan large

/-- Offset fits in the inclusive selected interval. -/
theorem recursiveTargetOffset_lt
    {q m : Nat} (plan : AlphaPlan q m)
    (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    recursiveTargetOffset plan large j < selectedRangeLength plan large := by
  have lower := recursiveTarget_ge_start plan large j
  have upper := recursiveTarget_le_end plan large j
  unfold recursiveTargetOffset selectedRangeLength
  omega

/-- Canonical interval-list index of one recursive target. -/
def recursiveTargetIntervalIndex
    {q m : Nat} (plan : AlphaPlan q m)
    (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    Fin (selectedRangeLength plan large) :=
  ⟨recursiveTargetOffset plan large j,
    recursiveTargetOffset_lt plan large j⟩

/-- The interval embedding at that offset is exactly the original physical
alpha target. -/
theorem intervalWire_recursiveTargetIndex
    {q m : Nat} (plan : AlphaPlan q m)
    (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    intervalWire plan large (recursiveTargetIntervalIndex plan large j) =
      plan.target (recursiveOriginalTargetIndex m large j) := by
  apply Fin.ext
  simp [recursiveTargetIntervalIndex, recursiveTargetOffset,
    intervalWire]
  have lower := recursiveTarget_ge_start plan large j
  omega

/-- Recursive target belongs to the full unfiltered interval list. -/
theorem recursiveTarget_mem_intervalList
    {q m : Nat} (plan : AlphaPlan q m)
    (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    plan.target (recursiveOriginalTargetIndex m large j) ∈
      intervalList plan large := by
  unfold intervalList
  rw [List.mem_map]
  exact ⟨recursiveTargetIntervalIndex plan large j,
    List.mem_finRange _, intervalWire_recursiveTargetIndex plan large j⟩

/-- A recursive target is never deleted.  Ordinary targets have even source
index; the only possible odd recursive target is the final retained end. -/
theorem recursiveTarget_not_deleted
    {q m : Nat} (plan : AlphaPlan q m)
    (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    ¬ deletedPhysicalWire plan large
      (plan.target (recursiveOriginalTargetIndex m large j)) := by
  intro deleted
  rcases deleted with ⟨index,odd,before,equal⟩
  have indexEq : index = recursiveOriginalTargetIndex m large j :=
    target_injective plan equal
  subst index
  have endEq := odd_recursiveTarget_eq_end m large j odd
  rw [endEq] at before
  omega

/-- Therefore every recursive target is retained in X'. -/
theorem recursiveTarget_mem_selectedList
    {q m : Nat} (plan : AlphaPlan q m)
    (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    plan.target (recursiveOriginalTargetIndex m large j) ∈
      selectedList plan large := by
  unfold selectedList
  rw [List.mem_filter]
  exact ⟨recursiveTarget_mem_intervalList plan large j,
    (keepPhysicalWire_eq_true_iff plan large _).2
      (recursiveTarget_not_deleted plan large j)⟩

/-- The unfiltered ordered interval rank is exactly physical offset from alpha0. -/
theorem recursiveTarget_interval_idxOf
    {q m : Nat} (plan : AlphaPlan q m)
    (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    (intervalList plan large).idxOf
      (plan.target (recursiveOriginalTargetIndex m large j)) =
        recursiveTargetOffset plan large j := by
  let sourceIndex : Fin (intervalList plan large).length :=
    ⟨recursiveTargetOffset plan large j, by
      simpa [intervalList] using recursiveTargetOffset_lt plan large j⟩
  have value :
      (intervalList plan large).get sourceIndex =
        plan.target (recursiveOriginalTargetIndex m large j) := by
    unfold intervalList
    simpa [sourceIndex, recursiveTargetIntervalIndex] using
      intervalWire_recursiveTargetIndex plan large j
  have source := List.get_idxOf (intervalList_nodup plan large) sourceIndex
  rw [value] at source
  simpa [sourceIndex] using source

end RemaudVandaeleLadderAlphaTargetMembership
end QuantumBlockEncoding
