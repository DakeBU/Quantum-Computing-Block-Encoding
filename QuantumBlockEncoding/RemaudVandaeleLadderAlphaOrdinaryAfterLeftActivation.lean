import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOrdinaryChildActivation
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOuterActivationStability
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOuterIndexCoverage
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaStrictInteriorStageInvariance
import Mathlib.Tactic

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaOrdinaryAfterLeftActivation

open MultiControlledXEmbedding
open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaIntervalFactorization
open RemaudVandaeleLadderAlphaOrdinaryActivationFactors
open RemaudVandaeleLadderAlphaOrdinaryChildActivation
open RemaudVandaeleLadderAlphaOuterActivationStability
open RemaudVandaeleLadderAlphaOuterIndexCoverage
open RemaudVandaeleLadderAlphaOuterLayers
open RemaudVandaeleLadderAlphaRankCertificate
open RemaudVandaeleLadderAlphaRecursiveCertificate
open RemaudVandaeleLadderAlphaRecursiveParameters
open RemaudVandaeleLadderAlphaSelectedRegister
open RemaudVandaeleLadderAlphaStrictInteriorStageInvariance

/-- The odd middle source target of an ordinary child gate lies in a nonfinal
left-wall slot. -/
def ordinaryMiddleLeftSlot
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (ordinary : ¬ isSpecialTail m j) : Fin (wallCount m) :=
  leftSlotOfOddBeforeTail
    (ordinaryMiddleSourceIndex m large j ordinary)
    (by simp [ordinaryMiddleSourceIndex])
    (by
      have currentLt := (recursiveOriginalTargetIndex m large j).isLt
      rw [recursiveOriginalTargetIndex_ordinary m large j ordinary] at currentLt
      simp [ordinaryMiddleSourceIndex]
      omega)

/-- That slot really is the ordinary odd source index `2j+1`. -/
theorem leftSourceIndex_ordinaryMiddleLeftSlot
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (ordinary : ¬ isSpecialTail m j) :
    leftSourceIndex m (ordinaryMiddleLeftSlot m large j ordinary) =
      ordinaryMiddleSourceIndex m large j ordinary := by
  unfold ordinaryMiddleLeftSlot
  exact leftSourceIndex_leftSlotOfOddBeforeTail
    (ordinaryMiddleSourceIndex m large j ordinary)
    (by simp [ordinaryMiddleSourceIndex])
    (by
      have currentLt := (recursiveOriginalTargetIndex m large j).isLt
      rw [recursiveOriginalTargetIndex_ordinary m large j ordinary] at currentLt
      simp [ordinaryMiddleSourceIndex]
      omega)

/-- On the state actually entering the embedded child, ordinary child
activation is exactly the original parent factors A_j and B_j. -/
theorem recursiveIntervalActive_ordinary_afterLeft_iff_factors
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q)
    (j : Fin (recursiveTargetCount m))
    (ordinary : ¬ isSpecialTail m j) :
    intervalActive
        (recursivePlan plan large (canonicalCertificate plan large))
        (readEmbedded (selectedWire plan large)
          ((leftScheduled plan).eval state)) j ↔
      intervalActive plan state
          (ordinaryMiddleSourceIndex m large j ordinary) ∧
        strictInteriorActive plan state
          (recursiveOriginalTargetIndex m large j) := by
  have childFactors := recursiveIntervalActive_ordinary_iff_factors
    plan large ((leftScheduled plan).eval state) j ordinary
  rw [childFactors]
  let slot := ordinaryMiddleLeftSlot m large j ordinary
  have slotEq := leftSourceIndex_ordinaryMiddleLeftSlot
    m large j ordinary
  have leftActivation := intervalActive_leftScheduled_iff plan slot state
  rw [slotEq] at leftActivation
  have currentNonzero :
      (recursiveOriginalTargetIndex m large j).val ≠ 0 := by
    have positive := RemaudVandaeleLadderAlphaTargetMembership.recursiveOriginalTargetIndex_pos
      m large j
    omega
  have interior := strictInteriorActive_leftScheduled_iff
    plan state (recursiveOriginalTargetIndex m large j) currentNonzero
  exact and_congr leftActivation interior

end RemaudVandaeleLadderAlphaOrdinaryAfterLeftActivation
end QuantumBlockEncoding
