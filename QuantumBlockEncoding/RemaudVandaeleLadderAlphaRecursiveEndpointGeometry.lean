import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveControlGeometry
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveEndpointArithmetic
import Mathlib.Tactic

/-!
# Algorithm 2: physical lower endpoints of recursive child gates

The compact child interval geometry becomes source-facing once its lower
endpoint is identified with an original alpha target.

* Ordinary child target j has physical lower endpoint alpha_(2j).
* The even-k special child target has physical lower endpoint alpha_(m-3).
* That special lower endpoint is exactly the source lower endpoint of its parent
  gate at index m-2=k-3.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaRecursiveEndpointGeometry

open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaRecursiveControlGeometry
open RemaudVandaeleLadderAlphaRecursiveEndpointArithmetic
open RemaudVandaeleLadderAlphaRecursiveParameters
open RemaudVandaeleLadderAlphaSelectedRegister

def ordinaryLowerSourceIndex
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (ordinary : ¬ isSpecialTail m j) : Fin m :=
  ⟨2 * j.val, by
    have currentLt := (recursiveOriginalTargetIndex m large j).isLt
    rw [recursiveOriginalTargetIndex_ordinary m large j ordinary] at currentLt
    omega⟩

theorem recursiveControlPhysicalLower_ordinary
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (ordinary : ¬ isSpecialTail m j) :
    recursiveControlPhysicalLower plan large j =
      (plan.target (ordinaryLowerSourceIndex m large j ordinary)).val := by
  by_cases zero : j.val = 0
  · unfold recursiveControlPhysicalLower selectedStart ordinaryLowerSourceIndex
    rw [dif_pos zero]
    apply congrArg (fun index : Fin m => (plan.target index).val)
    apply Fin.ext
    simp [zero]
  · unfold recursiveControlPhysicalLower
    rw [dif_neg zero]
    apply congrArg (fun index : Fin m => (plan.target index).val)
    apply Fin.ext
    simpa [ordinaryLowerSourceIndex, previousChild] using
      previousOriginalTargetIndex_ordinary m large j zero ordinary

def specialLowerSourceIndex
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (special : isSpecialTail m j) : Fin m :=
  ⟨m - 3, by
    have evenK := special.1
    omega⟩

theorem recursiveControlPhysicalLower_special
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (special : isSpecialTail m j) :
    recursiveControlPhysicalLower plan large j =
      (plan.target (specialLowerSourceIndex m large j special)).val := by
  by_cases zero : j.val = 0
  · have mThree := specialTail_zero_forces_m_three m large j special zero
    subst m
    unfold recursiveControlPhysicalLower selectedStart specialLowerSourceIndex
    rw [dif_pos zero]
    apply congrArg (fun index : Fin 3 => (plan.target index).val)
    apply Fin.ext
    simp
  · unfold recursiveControlPhysicalLower
    rw [dif_neg zero]
    apply congrArg (fun index : Fin m => (plan.target index).val)
    apply Fin.ext
    simpa [specialLowerSourceIndex, previousChild] using
      previousOriginalTargetIndex_special m large j zero special

theorem parentLowerEndpoint_special
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (special : isSpecialTail m j) :
    lowerEndpoint plan (recursiveOriginalTargetIndex m large j) =
      (plan.target (specialLowerSourceIndex m large j special)).val := by
  have currentVal := recursiveOriginalTargetIndex_special m large j special
  have evenK := special.1
  have currentNonzero :
      (recursiveOriginalTargetIndex m large j).val ≠ 0 := by
    omega
  unfold lowerEndpoint
  rw [dif_neg currentNonzero]
  apply congrArg (fun index : Fin m => (plan.target index).val)
  apply Fin.ext
  simp [specialLowerSourceIndex]

theorem recursiveControlPhysicalLower_special_eq_parentLowerEndpoint
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (special : isSpecialTail m j) :
    recursiveControlPhysicalLower plan large j =
      lowerEndpoint plan (recursiveOriginalTargetIndex m large j) := by
  rw [recursiveControlPhysicalLower_special plan large j special,
    parentLowerEndpoint_special plan large j special]

end RemaudVandaeleLadderAlphaRecursiveEndpointGeometry
end QuantumBlockEncoding
