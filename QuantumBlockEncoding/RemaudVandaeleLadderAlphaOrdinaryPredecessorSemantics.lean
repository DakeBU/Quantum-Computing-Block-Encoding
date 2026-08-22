import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOuterCaseSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveStageExclusionSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOrdinaryActivationFactors
import Mathlib.Tactic

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaOrdinaryPredecessorSemantics

open MultiControlledXEmbedding
open RemaudVandaeleLadderAlphaAlgorithmSchedule
open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaOrdinaryActivationFactors
open RemaudVandaeleLadderAlphaOuterCaseSemantics
open RemaudVandaeleLadderAlphaOuterLayers
open RemaudVandaeleLadderAlphaRankCertificate
open RemaudVandaeleLadderAlphaRecursiveCertificate
open RemaudVandaeleLadderAlphaRecursiveParameters
open RemaudVandaeleLadderAlphaRecursiveStageExclusionSemantics
open RemaudVandaeleLadderAlphaSelectedRegister

/-- The ordinary middle source index `2j+1` is an ordinary odd parent target. -/
theorem ordinaryMiddle_beforeTail
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (ordinary : ¬ isSpecialTail m j) :
    (ordinaryMiddleSourceIndex m large j ordinary).val + 2 < m := by
  let current := recursiveOriginalTargetIndex m large j
  have currentNotFinal := recursiveOriginalTargetIndex_ne_final m large j
  have currentLt := current.isLt
  have currentBeforeFinal : current.val + 1 < m := by
    dsimp [current] at currentNotFinal currentLt ⊢
    omega
  have currentVal := recursiveOriginalTargetIndex_ordinary m large j ordinary
  dsimp [current] at currentBeforeFinal
  rw [currentVal] at currentBeforeFinal
  simp [ordinaryMiddleSourceIndex]
  omega

/-- The left wall toggles the odd predecessor exactly according to the original
left source activation A_j. -/
theorem leftScheduled_ordinaryMiddle_target
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q)
    (j : Fin (recursiveTargetCount m))
    (ordinary : ¬ isSpecialTail m j) :
    (leftScheduled plan).eval state
        (plan.target (ordinaryMiddleSourceIndex m large j ordinary)) =
      if intervalActive plan state
          (ordinaryMiddleSourceIndex m large j ordinary) then
        flipBit (state
          (plan.target (ordinaryMiddleSourceIndex m large j ordinary)))
      else
        state (plan.target (ordinaryMiddleSourceIndex m large j ordinary)) := by
  apply leftScheduled_ordinaryOdd_target
  · simp [ordinaryMiddleSourceIndex]
  · exact ordinaryMiddle_beforeTail m large j ordinary

/-- The embedded recursive child does not target the ordinary odd predecessor,
so it preserves the value produced by C_L. -/
theorem mappedRecursive_preserves_ordinaryMiddle
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q)
    (j : Fin (recursiveTargetCount m))
    (ordinary : ¬ isSpecialTail m j) :
    (mapScheduled
      (selectedWire plan large)
      (selectedWire_injective plan large)
      (algorithm (recursivePlan plan large (canonicalCertificate plan large)))).eval
      state (plan.target (ordinaryMiddleSourceIndex m large j ordinary)) =
      state (plan.target (ordinaryMiddleSourceIndex m large j ordinary)) := by
  apply mappedRecursive_preserves_ordinaryOddTarget
  · simp [ordinaryMiddleSourceIndex]
  · exact ordinaryMiddle_beforeTail m large j ordinary

end RemaudVandaeleLadderAlphaOrdinaryPredecessorSemantics
end QuantumBlockEncoding
