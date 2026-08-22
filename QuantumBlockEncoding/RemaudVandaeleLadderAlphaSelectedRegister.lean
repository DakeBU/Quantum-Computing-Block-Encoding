import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveParameters
import Mathlib.Data.List.FinRange
import Mathlib.Tactic

/-!
# Remaud--Vandaele Algorithm 2: physical recursive register X'

The Algorithm-2 pseudocode constructs an ordered physical subregister `X'`.
It starts at physical target `alpha_0`, proceeds to the final recursive target,
and deletes exactly the intermediate odd-numbered ladder targets that have been
consumed by the left outer wall.

This module constructs that list of *actual physical Fin q wires* and proves it
has no duplicates.  Consequently `List.get` gives a canonical injective
embedding from the compact recursive register into the parent physical register.

The next module identifies the compact rank of every recursive target with the
`alpha'` arithmetic formalized previously.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaSelectedRegister

open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaRecursiveParameters

/-- Final original alpha index included in X'.  If the recursive alpha-vector
is empty (k=3), Algorithm 2 still keeps the single starting wire alpha_0. -/
def recursiveEndOriginalIndex
    (m : Nat) (large : 3 ≤ m + 1) : Fin m :=
  if empty : recursiveTargetCount m = 0 then
    ⟨0, by omega⟩
  else
    recursiveOriginalTargetIndex m large
      ⟨recursiveTargetCount m - 1, by omega⟩

/-- End index is never before alpha_0. -/
theorem recursiveEndOriginalIndex_nonnegative
    (m : Nat) (large : 3 ≤ m + 1) :
    0 ≤ (recursiveEndOriginalIndex m large).val := Nat.zero_le _

/-- Physical start of X'. -/
def selectedStart
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) : Nat :=
  (plan.target ⟨0, by omega⟩).val

/-- Physical final wire of X'. -/
def selectedEnd
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) : Nat :=
  (plan.target (recursiveEndOriginalIndex m large)).val

/-- Start is no later than end by strict alpha ordering. -/
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
      omega
    exact (plan.strict order).le

/-- Inclusive physical interval length. -/
def selectedRangeLength
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) : Nat :=
  selectedEnd plan large - selectedStart plan large + 1

/-- Translate one compact offset in the full interval to a physical wire. -/
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

/-- No offset collision in the inclusive physical interval. -/
theorem intervalWire_injective
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) :
    Function.Injective (intervalWire plan large) := by
  intro left right equal
  apply Fin.ext
  have values := congrArg Fin.val equal
  simp only [intervalWire_val] at values
  omega

/-- Intermediate source targets removed from X'.  These are exactly odd target
indices strictly before the recursive end target. -/
def deletedPhysicalWire
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (wire : Fin q) : Prop :=
  ∃ index : Fin m,
    index.val % 2 = 1 ∧
    index.val < (recursiveEndOriginalIndex m large).val ∧
    plan.target index = wire

/-- Deletion is a finite existential over source indices and is therefore
constructively decidable. -/
instance instDecidableDeletedPhysicalWire
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (wire : Fin q) : Decidable (deletedPhysicalWire plan large wire) := by
  unfold deletedPhysicalWire
  exact Fintype.decidableExistsFintype

/-- Boolean retention predicate used by the actual list filter. -/
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

/-- Full ordered physical interval before deleting intermediate targets. -/
def intervalList
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) : List (Fin q) :=
  (List.finRange (selectedRangeLength plan large)).map
    (intervalWire plan large)

/-- Source-selected physical recursive register X'. -/
noncomputable def selectedList
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) : List (Fin q) :=
  (intervalList plan large).filter (keepPhysicalWire plan large)

/-- Inclusive interval has no duplicate physical wires. -/
theorem intervalList_nodup
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) :
    (intervalList plan large).Nodup := by
  unfold intervalList
  exact (List.nodup_finRange _).map (intervalWire_injective plan large)

/-- Deleting wires preserves no-duplication. -/
theorem selectedList_nodup
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) :
    (selectedList plan large).Nodup := by
  unfold selectedList
  exact (intervalList_nodup plan large).filter _

/-- Compact recursive register width. -/
noncomputable def selectedWidth
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) : Nat :=
  (selectedList plan large).length

/-- Canonical physical embedding of compact X' coordinates. -/
noncomputable def selectedWire
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (index : Fin (selectedWidth plan large)) : Fin q :=
  (selectedList plan large).get
    ⟨index.val, by simpa [selectedWidth] using index.isLt⟩

/-- The physical X' embedding is injective because the selected list is nodup. -/
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

/-- The first selected physical wire is alpha_0. -/
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

/-- The recursive end target is retained rather than deleted. -/
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
    simp [intervalWire, endOffset, selectedEnd]
    have startEnd := selectedStart_le_end plan large
    omega
  · apply (keepPhysicalWire_eq_true_iff plan large _).2
    intro deleted
    rcases deleted with ⟨index,_odd,before,equal⟩
    have indexEq : index = recursiveEndOriginalIndex m large :=
      target_injective plan equal
    have values := congrArg Fin.val indexEq
    omega

end RemaudVandaeleLadderAlphaSelectedRegister
end QuantumBlockEncoding
