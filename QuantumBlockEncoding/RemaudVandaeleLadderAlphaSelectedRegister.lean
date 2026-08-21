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
  let endIndex := recursiveEndOriginalIndex m large
  by_cases zero : endIndex.val = 0
  · have equal : endIndex = ⟨0, by omega⟩ := by
      apply Fin.ext
      exact zero
    rw [equal]
  · have order : (⟨0, by omega⟩ : Fin m) < endIndex := by omega
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
    have endLt := (plan.target (recursiveEndOriginalIndex m large)).isLt
    unfold selectedRangeLength selectedEnd at offsetLt
    omega⟩

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

/-- Full ordered physical interval before deleting intermediate targets. -/
def intervalList
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) : List (Fin q) :=
  (List.finRange (selectedRangeLength plan large)).map
    (intervalWire plan large)

/-- Source-selected physical recursive register X'. -/
noncomputable def selectedList
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) : List (Fin q) :=
  (intervalList plan large).filter
    (fun wire => ¬ deletedPhysicalWire plan large wire)

/-- Inclusive interval has no duplicate physical wires. -/
theorem intervalList_nodup
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) :
    (intervalList plan large).Nodup := by
  apply List.Nodup.map
  · exact List.nodup_finRange _
  · exact intervalWire_injective plan large

/-- Deleting wires preserves no-duplication. -/
theorem selectedList_nodup
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) :
    (selectedList plan large).Nodup := by
  classical
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
  apply Fin.ext
  have getInjective := List.Nodup.get_injective (selectedList_nodup plan large)
  have indexEqual := getInjective equal
  exact congrArg Fin.val indexEqual

/-- The first selected physical wire is alpha_0. -/
theorem selectedList_head
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) :
    (plan.target ⟨0, by omega⟩) ∈ selectedList plan large := by
  classical
  unfold selectedList intervalList
  rw [List.mem_filter]
  constructor
  · rw [List.mem_map]
    let zeroOffset : Fin (selectedRangeLength plan large) :=
      ⟨0, by
        unfold selectedRangeLength
        omega⟩
    refine ⟨zeroOffset, ?_, ?_⟩
    · exact List.mem_finRange zeroOffset
    · apply Fin.ext
      simp [intervalWire, selectedStart]
  · intro deleted
    rcases deleted with ⟨index,odd,before,equal⟩
    have values := congrArg Fin.val equal
    by_cases zeroIndex : index.val = 0
    · omega
    · have strict := plan.strict
        (show (⟨0, by omega⟩ : Fin m) < index by omega)
      simp [selectedStart] at values
      omega

/-- The recursive end target is retained rather than deleted. -/
theorem selectedList_contains_end
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) :
    plan.target (recursiveEndOriginalIndex m large) ∈
      selectedList plan large := by
  classical
  unfold selectedList intervalList
  rw [List.mem_filter]
  constructor
  · rw [List.mem_map]
    let endOffset : Fin (selectedRangeLength plan large) :=
      ⟨selectedEnd plan large - selectedStart plan large, by
        unfold selectedRangeLength
        omega⟩
    refine ⟨endOffset, List.mem_finRange endOffset, ?_⟩
    apply Fin.ext
    simp [intervalWire, endOffset, selectedEnd]
    have startEnd := selectedStart_le_end plan large
    omega
  · intro deleted
    rcases deleted with ⟨index,odd,before,equal⟩
    apply Nat.not_lt_of_ge (show
      (recursiveEndOriginalIndex m large).val ≤ index.val by
        by_contra lower
        have order : index < recursiveEndOriginalIndex m large := by omega
        have strict := plan.strict order
        have values := congrArg Fin.val equal
        omega)
    exact before

end RemaudVandaeleLadderAlphaSelectedRegister
end QuantumBlockEncoding
