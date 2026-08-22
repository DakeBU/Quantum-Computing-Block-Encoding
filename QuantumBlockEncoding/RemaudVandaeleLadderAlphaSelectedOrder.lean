import QuantumBlockEncoding.RemaudVandaeleLadderAlphaSelectedRegister
import Mathlib.Data.List.Pairwise
import Mathlib.Tactic

/-!
# Algorithm 2: physical order of the selected recursive register

`X'` is not merely an injective set of physical wires: Algorithm 2 keeps the
physical order inherited from the contiguous parent interval.  This order is
the bridge needed later to translate a child control interval in compact
coordinates back into a parent physical interval.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaSelectedOrder

open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaSelectedRegister

/-- The unfiltered inclusive physical interval is strictly increasing in
physical wire number. -/
theorem intervalList_pairwise_val_lt
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) :
    (intervalList plan large).Pairwise
      (fun left right => left.val < right.val) := by
  unfold intervalList
  rw [← List.ofFn_eq_map, List.pairwise_ofFn]
  intro i j order
  simp [intervalWire]
  omega

/-- Filtering out intermediate targets preserves strict physical order. -/
theorem selectedList_pairwise_val_lt
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) :
    (selectedList plan large).Pairwise
      (fun left right => left.val < right.val) := by
  classical
  unfold selectedList
  exact (intervalList_pairwise_val_lt plan large).filter _

/-- Every compact coordinate is an actual retained physical wire. -/
theorem selectedWire_mem_selectedList
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (index : Fin (selectedWidth plan large)) :
    selectedWire plan large index ∈ selectedList plan large := by
  classical
  let physicalIndex : Fin (selectedList plan large).length :=
    ⟨index.val, by simpa [selectedWidth] using index.isLt⟩
  have member := (selectedList plan large).get_mem physicalIndex
  simpa [selectedWire, physicalIndex] using member

/-- Every retained physical wire has a compact `X'` coordinate. -/
theorem exists_selectedWire_eq_of_mem
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    {wire : Fin q} (member : wire ∈ selectedList plan large) :
    ∃ index : Fin (selectedWidth plan large),
      selectedWire plan large index = wire := by
  classical
  rcases List.mem_iff_get.mp member with ⟨physicalIndex, value⟩
  let index : Fin (selectedWidth plan large) :=
    ⟨physicalIndex.val, by
      simpa [selectedWidth] using physicalIndex.isLt⟩
  refine ⟨index, ?_⟩
  simpa [selectedWire, index] using value

/-- Every selected wire lies at or to the right of physical `alpha_0`. -/
theorem selectedWire_ge_start
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (index : Fin (selectedWidth plan large)) :
    selectedStart plan large ≤ (selectedWire plan large index).val := by
  classical
  have selectedMember := selectedWire_mem_selectedList plan large index
  unfold selectedList at selectedMember
  have intervalMember := (List.mem_filter.mp selectedMember).1
  unfold intervalList at intervalMember
  rw [List.mem_map] at intervalMember
  rcases intervalMember with ⟨offset, _offsetMember, wireEq⟩
  have values := congrArg Fin.val wireEq
  simp [intervalWire] at values
  omega

/-- Compact coordinate order gives physical-wire order. -/
theorem selectedWire_strict
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    {i j : Fin (selectedWidth plan large)} (order : i < j) :
    (selectedWire plan large i).val <
      (selectedWire plan large j).val := by
  classical
  let i' : Fin (selectedList plan large).length :=
    ⟨i.val, by simpa [selectedWidth] using i.isLt⟩
  let j' : Fin (selectedList plan large).length :=
    ⟨j.val, by simpa [selectedWidth] using j.isLt⟩
  have indexOrder : i' < j' := by
    simpa [i', j'] using order
  have physicalOrder :=
    (selectedList_pairwise_val_lt plan large).rel_get_of_lt indexOrder
  simpa [selectedWire, i', j'] using physicalOrder

/-- Strict compact and physical orders are equivalent. -/
theorem selectedWire_lt_iff
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    {i j : Fin (selectedWidth plan large)} :
    (selectedWire plan large i).val <
        (selectedWire plan large j).val ↔ i < j := by
  constructor
  · intro physical
    by_contra notOrder
    have reverse : j ≤ i := by omega
    rcases Fin.eq_or_lt_of_le reverse with equal | strict
    · subst i
      omega
    · have backward := selectedWire_strict plan large strict
      omega
  · exact selectedWire_strict plan large

/-- Weak compact order gives weak physical order. -/
theorem selectedWire_mono
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    {i j : Fin (selectedWidth plan large)} (order : i ≤ j) :
    (selectedWire plan large i).val ≤
      (selectedWire plan large j).val := by
  rcases Fin.eq_or_lt_of_le order with rfl | strict
  · exact le_rfl
  · exact (selectedWire_strict plan large strict).le

/-- Weak compact and physical orders are equivalent. -/
theorem selectedWire_le_iff
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    {i j : Fin (selectedWidth plan large)} :
    (selectedWire plan large i).val ≤
        (selectedWire plan large j).val ↔ i ≤ j := by
  constructor
  · intro physical
    by_contra notOrder
    have strict : j < i := by omega
    have backward := selectedWire_strict plan large strict
    omega
  · exact selectedWire_mono plan large

/-- If `X'` is nonempty, compact coordinate zero is exactly physical
`alpha_0`. -/
theorem selectedWire_zero
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (nonempty : 0 < selectedWidth plan large) :
    selectedWire plan large ⟨0, nonempty⟩ =
      plan.target ⟨0, by omega⟩ := by
  classical
  rcases exists_selectedWire_eq_of_mem plan large (selectedList_head plan large) with
    ⟨index, indexValue⟩
  have indexZero : index.val = 0 := by
    by_contra nonzero
    have order : (⟨0, nonempty⟩ : Fin (selectedWidth plan large)) < index := by
      omega
    have physicalStrict := selectedWire_strict plan large order
    rw [indexValue] at physicalStrict
    have lower := selectedWire_ge_start plan large
      (⟨0, nonempty⟩ : Fin (selectedWidth plan large))
    unfold selectedStart at lower
    omega
  have indexEq : index = (⟨0, nonempty⟩ : Fin (selectedWidth plan large)) :=
    Fin.ext indexZero
  rw [indexEq] at indexValue
  exact indexValue

end RemaudVandaeleLadderAlphaSelectedOrder
end QuantumBlockEncoding
