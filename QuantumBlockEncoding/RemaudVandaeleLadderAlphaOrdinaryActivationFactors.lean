import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveEndpointGeometry
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaIntervalFactorization
import Mathlib.Tactic

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaOrdinaryActivationFactors

open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaIntervalFactorization
open RemaudVandaeleLadderAlphaRecursiveEndpointGeometry
open RemaudVandaeleLadderAlphaRecursiveParameters

/-- The odd parent source gate immediately between ordinary child endpoints. -/
def ordinaryMiddleSourceIndex
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (ordinary : ¬ isSpecialTail m j) : Fin m :=
  ⟨2 * j.val + 1, by
    have currentLt := (recursiveOriginalTargetIndex m large j).isLt
    rw [recursiveOriginalTargetIndex_ordinary m large j ordinary] at currentLt
    omega⟩

/-- The three parent source indices are consecutive: 2j,2j+1,2j+2. -/
theorem ordinary_endpoint_values
    (m : Nat) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m))
    (ordinary : ¬ isSpecialTail m j) :
    (ordinaryLowerSourceIndex m large j ordinary).val = 2 * j.val ∧
    (ordinaryMiddleSourceIndex m large j ordinary).val = 2 * j.val + 1 ∧
    (recursiveOriginalTargetIndex m large j).val = 2 * j.val + 2 := by
  simp [ordinaryLowerSourceIndex, ordinaryMiddleSourceIndex,
    recursiveOriginalTargetIndex_ordinary m large j ordinary]

/-- Physical activation after compacting away the odd middle alpha target. -/
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

/-- The compacted physical predicate is exactly left-wall activation times the
strict interior of the current even source gate. -/
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
  have endpoints := ordinary_endpoint_values m large j ordinary
  have lowerVal : lower.val = 2 * j.val := by
    simpa [lower] using endpoints.1
  have middleVal : middle.val = 2 * j.val + 1 := by
    simpa [middle] using endpoints.2.1
  have currentVal : current.val = 2 * j.val + 2 := by
    simpa [current] using endpoints.2.2
  have lowerMiddle : middle.val = lower.val + 1 := by omega
  have middleCurrent : current.val = middle.val + 1 := by omega
  have lowerMiddleStrict :
      (plan.target lower).val < (plan.target middle).val := by
    apply plan.strict
    change lower.val < middle.val
    omega
  have middleCurrentStrict :
      (plan.target middle).val < (plan.target current).val := by
    apply plan.strict
    change middle.val < current.val
    omega
  have middleNonzero : middle.val ≠ 0 := by omega
  have currentNonzero : current.val ≠ 0 := by omega
  have middlePrevEq :
      (⟨middle.val - 1, by
        have h := middle.isLt
        omega⟩ : Fin m) = lower := by
    apply Fin.ext
    omega
  have currentPrevEq :
      (⟨current.val - 1, by
        have h := current.isLt
        omega⟩ : Fin m) = middle := by
    apply Fin.ext
    omega
  have middleInteriorIff :
      strictInteriorActive plan state middle ↔
        ∀ wire : Fin q,
          (plan.target lower).val < wire.val →
          wire.val < (plan.target middle).val →
          state wire = 1 := by
    unfold strictInteriorActive
    split
    · next first => exact (middleNonzero first).elim
    · next _ => rw [middlePrevEq]
  have currentInteriorIff :
      strictInteriorActive plan state current ↔
        ∀ wire : Fin q,
          (plan.target middle).val < wire.val →
          wire.val < (plan.target current).val →
          state wire = 1 := by
    unfold strictInteriorActive
    split
    · next first => exact (currentNonzero first).elim
    · next _ => rw [currentPrevEq]
  constructor
  · intro compacted
    constructor
    · rw [intervalActive_succIndex_iff plan state lower middle lowerMiddle]
      constructor
      · apply compacted (plan.target lower) le_rfl
          (lowerMiddleStrict.trans middleCurrentStrict)
        intro equal
        have valuesEq := congrArg Fin.val equal
        omega
      · rw [middleInteriorIff]
        intro wire lowerWire upperWire
        apply compacted wire lowerWire.le (upperWire.trans middleCurrentStrict)
        intro equal
        have valuesEq := congrArg Fin.val equal
        omega
    · rw [currentInteriorIff]
      intro wire lowerWire upperWire
      apply compacted wire
      · exact lowerMiddleStrict.le.trans lowerWire.le
      · exact upperWire
      · intro equal
        have valuesEq := congrArg Fin.val equal
        omega
  · rintro ⟨leftActive, currentInterior⟩
    rw [intervalActive_succIndex_iff plan state lower middle lowerMiddle] at leftActive
    have lowerOne := leftActive.1
    have middleInterior := leftActive.2
    rw [middleInteriorIff] at middleInterior
    rw [currentInteriorIff] at currentInterior
    intro wire lowerWire upperWire notMiddle
    by_cases beforeMiddle : wire.val < (plan.target middle).val
    · by_cases atLower : wire = plan.target lower
      · simpa [atLower] using lowerOne
      · apply middleInterior wire
        · have valueNe : wire.val ≠ (plan.target lower).val := by
            intro equal
            apply atLower
            apply Fin.ext
            exact equal
          omega
        · exact beforeMiddle
    · apply currentInterior wire
      · have middleNe : wire.val ≠ (plan.target middle).val := by
          intro equal
          apply notMiddle
          apply Fin.ext
          exact equal
        omega
      · exact upperWire

end RemaudVandaeleLadderAlphaOrdinaryActivationFactors
end QuantumBlockEncoding
