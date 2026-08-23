import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveEndpointGeometry
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaIntervalFactorization
import Mathlib.Tactic

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaOrdinaryActivationFactors

open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaIntervalFactorization
open RemaudVandaeleLadderAlphaRecursiveEndpointGeometry
open RemaudVandaeleLadderAlphaRecursiveParameters

def ordinaryMiddleSourceIndex
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (ordinary : ¬ isSpecialTail m j) : Fin m :=
  ⟨2 * j.val + 1, by
    have currentLt := (recursiveOriginalTargetIndex m large j).isLt
    rw [recursiveOriginalTargetIndex_ordinary m large j ordinary] at currentLt
    omega⟩

theorem ordinary_endpoint_values
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (ordinary : ¬ isSpecialTail m j) :
    (ordinaryLowerSourceIndex m large j ordinary).val = 2 * j.val ∧
    (ordinaryMiddleSourceIndex m large j ordinary).val = 2 * j.val + 1 ∧
    (recursiveOriginalTargetIndex m large j).val = 2 * j.val + 2 := by
  simp [ordinaryLowerSourceIndex, ordinaryMiddleSourceIndex,
    recursiveOriginalTargetIndex_ordinary m large j ordinary]

def ordinaryCompactedPhysicalActive
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q)
    (j : Fin (recursiveTargetCount m))
    (ordinary : ¬ isSpecialTail m j) : Prop :=
  ∀ wire : Fin q,
    (plan.target (ordinaryLowerSourceIndex m large j ordinary)).val ≤ wire.val →
    wire.val <
      (plan.target (recursiveOriginalTargetIndex m large j)).val →
    wire ≠ plan.target (ordinaryMiddleSourceIndex m large j ordinary) →
    state wire = 1

theorem ordinaryCompactedPhysicalActive_iff
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q)
    (j : Fin (recursiveTargetCount m))
    (ordinary : ¬ isSpecialTail m j) :
    ordinaryCompactedPhysicalActive plan large state j ordinary ↔
      intervalActive plan state
        (ordinaryMiddleSourceIndex m large j ordinary) ∧
      strictInteriorActive plan state
        (recursiveOriginalTargetIndex m large j) := by
  let lower := ordinaryLowerSourceIndex m large j ordinary
  let middle := ordinaryMiddleSourceIndex m large j ordinary
  let current := recursiveOriginalTargetIndex m large j
  have endpointValues := ordinary_endpoint_values m large j ordinary
  have lowerMiddle : middle.val = lower.val + 1 := by
    dsimp [lower, middle]
    omega
  have middleCurrent : current.val = middle.val + 1 := by
    dsimp [middle, current]
    omega
  have lowerMiddleStrict :
      (plan.target lower).val < (plan.target middle).val :=
    plan.strict (by omega)
  have middleCurrentStrict :
      (plan.target middle).val < (plan.target current).val :=
    plan.strict (by omega)
  have middleNonzero : middle.val ≠ 0 := by omega
  have currentNonzero : current.val ≠ 0 := by omega
  have middlePreviousEq :
      (⟨middle.val - 1, by omega⟩ : Fin m) = lower := by
    apply Fin.ext
    change middle.val - 1 = lower.val
    omega
  have currentPreviousEq :
      (⟨current.val - 1, by omega⟩ : Fin m) = middle := by
    apply Fin.ext
    change current.val - 1 = middle.val
    omega
  constructor
  · intro compacted
    constructor
    · rw [intervalActive_succIndex_iff plan state lower middle lowerMiddle]
      constructor
      · apply compacted (plan.target lower) le_rfl
          (lowerMiddleStrict.trans middleCurrentStrict)
        intro equal
        have valuesEq := congrArg Fin.val equal
        exact (ne_of_lt lowerMiddleStrict) valuesEq
      · unfold strictInteriorActive
        rw [dif_neg middleNonzero]
        intro wire lowerWire upperWire
        rw [middlePreviousEq] at lowerWire
        apply compacted wire lowerWire.le (upperWire.trans middleCurrentStrict)
        intro equal
        rw [equal] at upperWire
        exact (lt_irrefl _ upperWire)
    · unfold strictInteriorActive
      rw [dif_neg currentNonzero]
      intro wire lowerWire upperWire
      rw [currentPreviousEq] at lowerWire
      apply compacted wire
      · exact lowerMiddleStrict.le.trans lowerWire.le
      · exact upperWire
      · intro equal
        rw [equal] at lowerWire
        exact (lt_irrefl _ lowerWire)
  · rintro ⟨leftActive, currentInterior⟩
    rw [intervalActive_succIndex_iff plan state lower middle lowerMiddle] at leftActive
    have lowerOne := leftActive.1
    have middleInterior := leftActive.2
    unfold strictInteriorActive at middleInterior currentInterior
    rw [dif_neg middleNonzero] at middleInterior
    rw [dif_neg currentNonzero] at currentInterior
    intro wire lowerWire upperWire notMiddle
    change (plan.target lower).val ≤ wire.val at lowerWire
    change wire.val < (plan.target current).val at upperWire
    change wire ≠ plan.target middle at notMiddle
    by_cases beforeMiddle : wire.val < (plan.target middle).val
    · by_cases atLower : wire = plan.target lower
      · simpa [atLower] using lowerOne
      · apply middleInterior wire
        · rw [middlePreviousEq]
          have valueNe : (plan.target lower).val ≠ wire.val := by
            intro equal
            apply atLower
            apply Fin.ext
            exact equal.symm
          omega
        · exact beforeMiddle
    · apply currentInterior wire
      · rw [currentPreviousEq]
        have middleNe : (plan.target middle).val ≠ wire.val := by
          intro equal
          apply notMiddle
          apply Fin.ext
          exact equal.symm
        omega
      · exact upperWire

end RemaudVandaeleLadderAlphaOrdinaryActivationFactors
end QuantumBlockEncoding
