import QuantumBlockEncoding.RemaudVandaeleLadderAlphaContract
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaResource
import Mathlib.Tactic

/-!
# Remaud--Vandaele Algorithm 2: recursive alpha-prime parameters

Algorithm 2 does not recurse on the original alpha vector verbatim.  It removes
intermediate target wires from the selected register `X'`, so the recursive
alpha-vector has to be reindexed.

For `m=k-1` source targets, the recursive call has

`m' = floor(k/2)-1`

targets.  Its ordinary targets come from original indices `2,4,6,...`; when k
is even, the final recursive target is the special original index `k-3=m-2`.
The alpha-prime coordinate is the original physical target coordinate, shifted
by `alpha_0` and by the number of intermediate target wires deleted from `X'`.

This module formalizes exactly that pseudocode arithmetic.  It deliberately does
not yet claim that the resulting vector is a complete physical subregister; the
next source node constructs the `X'` wire embedding and proves that these
coordinates are its target positions.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaRecursiveParameters

open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaResource

/-- Number of targets in the recursive alpha-prime vector. -/
def recursiveTargetCount (m : Nat) : Nat :=
  recursiveK (m + 1) - 1

/-- The source special tail occurs exactly when k=m+1 is even and j is the
final recursive target. -/
def isSpecialTail (m : Nat) (j : Fin (recursiveTargetCount m)) : Prop :=
  (m + 1) % 2 = 0 ∧ j.val + 1 = recursiveTargetCount m

/-- The special-tail branch is an arithmetic proposition over naturals, hence
constructively decidable.  Supplying this instance is important because the
source index itself is a dependent `Fin m` selected by this branch. -/
instance instDecidableIsSpecialTail
    (m : Nat) (j : Fin (recursiveTargetCount m)) :
    Decidable (isSpecialTail m j) := by
  unfold isSpecialTail
  infer_instance

/-- Original alpha-vector index selected by recursive target j. -/
def recursiveOriginalTargetIndex
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) : Fin m :=
  if special : isSpecialTail m j then
    ⟨m - 2, by omega⟩
  else
    ⟨2 * j.val + 2, by
      have hj := j.isLt
      unfold recursiveTargetCount recursiveK at hj
      unfold isSpecialTail at special
      omega⟩

/-- Ordinary recursive targets are alpha_(2j+2). -/
theorem recursiveOriginalTargetIndex_ordinary
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (ordinary : ¬ isSpecialTail m j) :
    (recursiveOriginalTargetIndex m large j).val = 2 * j.val + 2 := by
  simp [recursiveOriginalTargetIndex, ordinary]

/-- Even-k special tail is alpha_(k-3)=alpha_(m-2). -/
theorem recursiveOriginalTargetIndex_special
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (special : isSpecialTail m j) :
    (recursiveOriginalTargetIndex m large j).val = m - 2 := by
  simp [recursiveOriginalTargetIndex, special]

/-- Number of physical target wires deleted before recursive target j. -/
def deletedTargetCount
    (m : Nat) (j : Fin (recursiveTargetCount m)) : Nat :=
  if isSpecialTail m j then j.val else j.val + 1

/-- Algorithm-2 alpha-prime value in compact X' coordinates. -/
def recursiveAlphaValue
    {q m : Nat} (plan : AlphaPlan q m)
    (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) : Nat :=
  (plan.target (recursiveOriginalTargetIndex m large j)).val -
    (plan.target ⟨0, by omega⟩).val -
      deletedTargetCount m j

/-- Pseudocode line 14: ordinary value
`alpha_(2i) - alpha_0 - i`, where i=j+1. -/
theorem recursiveAlphaValue_ordinary
    {q m : Nat} (plan : AlphaPlan q m)
    (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (ordinary : ¬ isSpecialTail m j) :
    recursiveAlphaValue plan large j =
      (plan.target ⟨2 * j.val + 2, by
        have h := (recursiveOriginalTargetIndex m large j).isLt
        simpa [recursiveOriginalTargetIndex, ordinary] using h⟩).val -
      (plan.target ⟨0, by omega⟩).val - (j.val + 1) := by
  simp [recursiveAlphaValue, recursiveOriginalTargetIndex,
    deletedTargetCount, ordinary]

/-- Pseudocode line 17: even-k special value
`alpha_(k-3) - alpha_0 - k/2 + 2`.  Since the special recursive index is
`j=k/2-2`, this is equivalently subtraction by j. -/
theorem recursiveAlphaValue_special
    {q m : Nat} (plan : AlphaPlan q m)
    (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (special : isSpecialTail m j) :
    recursiveAlphaValue plan large j =
      (plan.target ⟨m - 2, by omega⟩).val -
      (plan.target ⟨0, by omega⟩).val - j.val := by
  simp [recursiveAlphaValue, recursiveOriginalTargetIndex,
    deletedTargetCount, special]

/-- Special-tail source index identity `j = k/2-2`. -/
theorem specialTail_index_value
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (special : isSpecialTail m j) :
    j.val = (m + 1) / 2 - 2 := by
  rcases special with ⟨even, last⟩
  unfold recursiveTargetCount recursiveK at last
  omega

/-- Consequently the special source formula matches the exact pseudocode
subtraction `k/2-2`. -/
theorem recursiveAlphaValue_special_pseudocode
    {q m : Nat} (plan : AlphaPlan q m)
    (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (special : isSpecialTail m j) :
    recursiveAlphaValue plan large j =
      (plan.target ⟨m - 2, by omega⟩).val -
      (plan.target ⟨0, by omega⟩).val - ((m + 1) / 2 - 2) := by
  rw [recursiveAlphaValue_special plan large j special,
    specialTail_index_value m large j special]

end RemaudVandaeleLadderAlphaRecursiveParameters
end QuantumBlockEncoding
