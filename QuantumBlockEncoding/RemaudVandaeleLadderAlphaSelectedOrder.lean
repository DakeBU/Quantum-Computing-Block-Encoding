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

/-- Compact coordinate order agrees with physical-wire order. -/
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

/-- Weak compact order gives weak physical order. -/
theorem selectedWire_mono
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    {i j : Fin (selectedWidth plan large)} (order : i ≤ j) :
    (selectedWire plan large i).val ≤
      (selectedWire plan large j).val := by
  rcases Fin.eq_or_lt_of_le order with rfl | strict
  · exact le_rfl
  · exact (selectedWire_strict plan large strict).le

end RemaudVandaeleLadderAlphaSelectedOrder
end QuantumBlockEncoding
