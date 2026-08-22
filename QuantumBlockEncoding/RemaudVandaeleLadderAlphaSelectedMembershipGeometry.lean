import QuantumBlockEncoding.RemaudVandaeleLadderAlphaSelectedRegister
import Mathlib.Tactic

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaSelectedMembershipGeometry

open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaSelectedRegister

/-- A physical wire is in the unfiltered selected interval iff it lies between
its inclusive physical endpoints. -/
theorem mem_intervalList_iff_bounds
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (wire : Fin q) :
    wire ∈ intervalList plan large ↔
      selectedStart plan large ≤ wire.val ∧
        wire.val ≤ selectedEnd plan large := by
  constructor
  · intro member
    unfold intervalList at member
    rw [List.mem_map] at member
    rcases member with ⟨offset, _member, equal⟩
    have offsetLt := offset.isLt
    have values := congrArg Fin.val equal
    simp [intervalWire] at values
    unfold selectedRangeLength at offsetLt
    omega
  · rintro ⟨lower, upper⟩
    let offsetValue := wire.val - selectedStart plan large
    have offsetLt : offsetValue < selectedRangeLength plan large := by
      unfold offsetValue selectedRangeLength
      omega
    let offset : Fin (selectedRangeLength plan large) :=
      ⟨offsetValue, offsetLt⟩
    unfold intervalList
    rw [List.mem_map]
    refine ⟨offset, List.mem_finRange offset, ?_⟩
    apply Fin.ext
    simp [intervalWire, offset, offsetValue]
    exact Nat.add_sub_of_le lower

/-- Geometric characterization of the actual compact recursive register X'. -/
theorem mem_selectedList_iff
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (wire : Fin q) :
    wire ∈ selectedList plan large ↔
      selectedStart plan large ≤ wire.val ∧
      wire.val ≤ selectedEnd plan large ∧
      ¬ deletedPhysicalWire plan large wire := by
  unfold selectedList
  rw [List.mem_filter,
    mem_intervalList_iff_bounds plan large wire,
    keepPhysicalWire_eq_true_iff plan large wire]
  aesop

end RemaudVandaeleLadderAlphaSelectedMembershipGeometry
end QuantumBlockEncoding
