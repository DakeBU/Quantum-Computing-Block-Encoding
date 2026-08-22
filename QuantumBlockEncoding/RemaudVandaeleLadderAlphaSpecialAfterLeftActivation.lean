import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOuterCaseSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaSpecialTailActivation
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaStrictInteriorStageInvariance
import Mathlib.Tactic

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaSpecialAfterLeftActivation

open MultiControlledXEmbedding
open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaIntervalFactorization
open RemaudVandaeleLadderAlphaOuterCaseSemantics
open RemaudVandaeleLadderAlphaRankCertificate
open RemaudVandaeleLadderAlphaRecursiveCertificate
open RemaudVandaeleLadderAlphaRecursiveEndpointGeometry
open RemaudVandaeleLadderAlphaRecursiveParameters
open RemaudVandaeleLadderAlphaSelectedRegister
open RemaudVandaeleLadderAlphaSpecialTailActivation
open RemaudVandaeleLadderAlphaStrictInteriorStageInvariance

/-- The parent predecessor alpha target of an even-k special child is preserved
by the left wall. -/
theorem leftScheduled_preserves_specialPredecessor
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (special : isSpecialTail m j)
    (state : PrimitiveBasis q) :
    (leftScheduled plan).eval state
        (plan.target (specialLowerSourceIndex m large j special)) =
      state (plan.target (specialLowerSourceIndex m large j special)) := by
  have evenK := special.1
  have oddM : m % 2 = 1 := by omega
  by_cases mThree : m = 3
  · subst m
    have lowerZero :
        specialLowerSourceIndex 3 large j special = (⟨0, by decide⟩ : Fin 3) := by
      apply Fin.ext
      simp [specialLowerSourceIndex]
    rw [lowerZero]
    exact leftScheduled_preserves_zeroTarget plan (by omega) state
  · have mLarge : 5 ≤ m := by omega
    let index := specialLowerSourceIndex m large j special
    have even : index.val % 2 = 0 := by
      simp [index, specialLowerSourceIndex]
      omega
    have beforeFinal : index.val + 1 < m := by
      simp [index, specialLowerSourceIndex]
      omega
    exact leftScheduled_preserves_ordinaryEvenTarget
      plan index even beforeFinal state

/-- The parent special-tail source activation itself is unchanged by C_L. -/
theorem intervalActive_special_leftScheduled_iff
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q)
    (j : Fin (recursiveTargetCount m))
    (special : isSpecialTail m j) :
    intervalActive plan ((leftScheduled plan).eval state)
        (recursiveOriginalTargetIndex m large j) ↔
      intervalActive plan state
        (recursiveOriginalTargetIndex m large j) := by
  let current := recursiveOriginalTargetIndex m large j
  have currentNonzero : current.val ≠ 0 := by
    have currentVal := recursiveOriginalTargetIndex_special m large j special
    omega
  rw [intervalActive_nonfirst_iff plan ((leftScheduled plan).eval state)
      current currentNonzero,
    intervalActive_nonfirst_iff plan state current currentNonzero]
  have previousEq :
      (⟨current.val - 1, by omega⟩ : Fin m) =
        specialLowerSourceIndex m large j special := by
    apply Fin.ext
    have currentVal := recursiveOriginalTargetIndex_special m large j special
    simp [specialLowerSourceIndex]
    omega
  rw [previousEq]
  constructor
  · rintro ⟨predecessor, interior⟩
    constructor
    · rw [← leftScheduled_preserves_specialPredecessor
        plan large j special state]
      exact predecessor
    · exact (strictInteriorActive_leftScheduled_iff
        plan state current currentNonzero).mp interior
  · rintro ⟨predecessor, interior⟩
    constructor
    · rw [leftScheduled_preserves_specialPredecessor
        plan large j special state]
      exact predecessor
    · exact (strictInteriorActive_leftScheduled_iff
        plan state current currentNonzero).mpr interior

/-- Therefore the special child, on its actual after-left input, sees exactly
the original parent special-tail activation predicate. -/
theorem recursiveIntervalActive_special_afterLeft_iff_parent
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q)
    (j : Fin (recursiveTargetCount m))
    (special : isSpecialTail m j) :
    intervalActive
        (recursivePlan plan large (canonicalCertificate plan large))
        (readEmbedded (selectedWire plan large)
          ((leftScheduled plan).eval state)) j ↔
      intervalActive plan state
        (recursiveOriginalTargetIndex m large j) := by
  exact (recursiveIntervalActive_special_iff_parent
    plan large ((leftScheduled plan).eval state) j special).trans
      (intervalActive_special_leftScheduled_iff plan large state j special)

end RemaudVandaeleLadderAlphaSpecialAfterLeftActivation
end QuantumBlockEncoding
