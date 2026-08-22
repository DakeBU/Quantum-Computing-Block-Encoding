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

end RemaudVandaeleLadderAlphaSelectedOrder
end QuantumBlockEncoding
