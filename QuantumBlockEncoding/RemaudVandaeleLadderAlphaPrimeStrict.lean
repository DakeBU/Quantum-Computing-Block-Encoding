import QuantumBlockEncoding.RemaudVandaeleAlphaGap
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRankArithmetic
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveOrder
import Mathlib.Tactic

/-!
# Algorithm 2: alpha-prime is strictly increasing

The recursive source indices are separated by at least two original alpha
indices.  A strict alpha plan therefore gains at least two physical wires, while
compaction deletes at most one additional target over that step.  Hence the
pseudocode alpha-prime vector remains strictly increasing and is a valid
recursive ladder target vector.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaPrimeStrict

open RemaudVandaeleAlphaGap
open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaRankArithmetic
open RemaudVandaeleLadderAlphaRecursiveOrder
open RemaudVandaeleLadderAlphaRecursiveParameters
open RemaudVandaeleLadderAlphaSelectedRegister

/-- Consecutive recursive source targets are separated by at least two original
source indices. -/
theorem recursiveOriginalTargetIndex_gap_two
    (m : Nat) (large : 3 ≤ m + 1)
    {i j : Fin (recursiveTargetCount m)} (order : i < j) :
    (recursiveOriginalTargetIndex m large i).val + 2 ≤
      (recursiveOriginalTargetIndex m large j).val := by
  by_cases specialJ : isSpecialTail m j
  · unfold isSpecialTail at specialJ
    rcases specialJ with ⟨evenK, jLast⟩
    have ordinaryI : ¬ isSpecialTail m i := by
      intro specialI
      have iLast := specialI.2
      omega
    rw [recursiveOriginalTargetIndex_ordinary m large i ordinaryI]
    have specialJ' : isSpecialTail m j := ⟨evenK, jLast⟩
    rw [recursiveOriginalTargetIndex_special m large j specialJ']
    have hi := i.isLt
    unfold recursiveTargetCount RemaudVandaeleLadderAlphaResource.recursiveK at hi jLast
    omega
  · have ordinaryI : ¬ isSpecialTail m i := by
      intro specialI
      have iLast := specialI.2
      have hj := j.isLt
      omega
    rw [recursiveOriginalTargetIndex_ordinary m large i ordinaryI,
      recursiveOriginalTargetIndex_ordinary m large j specialJ]
    omega

/-- Half-index deletion count grows strictly slower than the physical source
index gap relevant to recursive targets. -/
theorem half_gap_strict
    {a b : Nat} (gap : a + 2 ≤ b) :
    b / 2 - a / 2 < b - a := by
  omega

/-- Compact-rank alpha-prime values are strictly increasing. -/
theorem recursiveAlphaValue_strict
    {q m : Nat} (plan : AlphaPlan q m)
    (large : 3 ≤ m + 1)
    {i j : Fin (recursiveTargetCount m)} (order : i < j) :
    recursiveAlphaValue plan large i <
      recursiveAlphaValue plan large j := by
  rw [recursiveAlphaValue_eq_compactRank,
    recursiveAlphaValue_eq_compactRank]
  unfold compactRank
  let ri := recursiveOriginalTargetIndex m large i
  let rj := recursiveOriginalTargetIndex m large j
  have sourceGap : ri.val + 2 ≤ rj.val :=
    recursiveOriginalTargetIndex_gap_two m large order
  have indexOrder : ri.val ≤ rj.val := by omega
  have targetGap := target_gap_ge_index_gap plan ri rj indexOrder
  have startToI := target_from_zero_gap plan ri
  have startToJ := target_from_zero_gap plan rj
  have deleteGap := half_gap_strict sourceGap
  dsimp [ri, rj] at *
  omega

end RemaudVandaeleLadderAlphaPrimeStrict
end QuantumBlockEncoding
