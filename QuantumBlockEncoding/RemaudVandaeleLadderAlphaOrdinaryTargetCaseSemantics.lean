import QuantumBlockEncoding.RemaudVandaeleLadderAlphaMappedRecursiveTargetSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOrdinaryAfterLeftActivation
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOrdinaryPredecessorSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOuterCaseSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveTargetExclusion
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaStrictInteriorStageInvariance
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaCancellationAlgebra
import Mathlib.Tactic

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaOrdinaryTargetCaseSemantics

open MultiControlledXEmbedding
open RemaudVandaeleLadderAlphaAlgorithmSchedule
open RemaudVandaeleLadderAlphaCancellationAlgebra
open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaIntervalFactorization
open RemaudVandaeleLadderAlphaMappedRecursiveTargetSemantics
open RemaudVandaeleLadderAlphaOrdinaryActivationFactors
open RemaudVandaeleLadderAlphaOrdinaryAfterLeftActivation
open RemaudVandaeleLadderAlphaOrdinaryPredecessorSemantics
open RemaudVandaeleLadderAlphaOuterCaseSemantics
open RemaudVandaeleLadderAlphaOuterLayers
open RemaudVandaeleLadderAlphaRankCertificate
open RemaudVandaeleLadderAlphaRecursiveCertificate
open RemaudVandaeleLadderAlphaRecursiveParameters
open RemaudVandaeleLadderAlphaRecursiveTargetExclusion
open RemaudVandaeleLadderAlphaSelectedRegister
open RemaudVandaeleLadderAlphaStrictInteriorStageInvariance

/-- The complete `C_L ; child ; C_R` stage action on an ordinary recursive
source target is exactly the parent Equation-(7) source-gate action. -/
theorem ordinaryTarget_stage_action
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q)
    (j : Fin (recursiveTargetCount m))
    (ordinary : ¬ isSpecialTail m j)
    (childCorrect : ChildAlgorithmSpec
      (recursivePlan plan large (canonicalCertificate plan large))) :
    let current := recursiveOriginalTargetIndex m large j
    let leftState := (leftScheduled plan).eval state
    let childState :=
      (mapScheduled
        (selectedWire plan large)
        (selectedWire_injective plan large)
        (algorithm (recursivePlan plan large (canonicalCertificate plan large)))).eval
        leftState
    (rightScheduled plan).eval childState (plan.target current) =
      if intervalActive plan state current then
        flipBit (state (plan.target current))
      else state (plan.target current) := by
  let current := recursiveOriginalTargetIndex m large j
  let middle := ordinaryMiddleSourceIndex m large j ordinary
  let childPlan := recursivePlan plan large (canonicalCertificate plan large)
  let leftState := (leftScheduled plan).eval state
  let childProgram :=
    mapScheduled
      (selectedWire plan large)
      (selectedWire_injective plan large)
      (algorithm childPlan)
  let childState := childProgram.eval leftState
  have currentVal := recursiveOriginalTargetIndex_ordinary m large j ordinary
  have currentEven : current.val % 2 = 0 := by
    dsimp [current]
    rw [currentVal]
    omega
  have currentPositive : 2 ≤ current.val := by
    dsimp [current]
    rw [currentVal]
    omega
  have currentBeforeFinal : current.val + 1 < m := by
    dsimp [current]
    exact recursiveOriginalTargetIndex_before_final m large j
  have currentNonzero : current.val ≠ 0 := by omega
  have middleEqPrevious :
      (⟨current.val - 1, by omega⟩ : Fin m) = middle := by
    apply Fin.ext
    dsimp [current, middle]
    rw [currentVal]
    simp [ordinaryMiddleSourceIndex]

  have leftCurrent :
      leftState (plan.target current) = state (plan.target current) := by
    dsimp [leftState]
    exact leftScheduled_preserves_ordinaryEvenTarget
      plan current currentEven currentBeforeFinal state

  have leftMiddle :
      leftState (plan.target middle) =
        if intervalActive plan state middle then
          flipBit (state (plan.target middle))
        else state (plan.target middle) := by
    dsimp [leftState]
    simpa [middle] using
      leftScheduled_ordinaryMiddle_target plan large state j ordinary

  have childTargetRaw := mappedRecursive_target_action
    plan large leftState j childCorrect
  have childInputTarget :
      readEmbedded (selectedWire plan large) leftState (childPlan.target j) =
        leftState (plan.target current) := by
    unfold readEmbedded
    have physical := canonical_recursive_target_physical plan large j
    dsimp [childPlan, current] at physical ⊢
    rw [physical]
  have childActivation :=
    recursiveIntervalActive_ordinary_afterLeft_iff_factors
      plan large state j ordinary
  have childTarget :
      childState (plan.target current) =
        if intervalActive plan state middle ∧
            strictInteriorActive plan state current then
          flipBit (state (plan.target current))
        else state (plan.target current) := by
    rw [equationSeven_target] at childTargetRaw
    by_cases factors :
        intervalActive plan state middle ∧
          strictInteriorActive plan state current
    · have childActive :
          intervalActive
            (recursivePlan plan large (canonicalCertificate plan large))
            (readEmbedded (selectedWire plan large) leftState) j := by
        exact childActivation.mpr factors
      rw [if_pos childActive] at childTargetRaw
      rw [if_pos factors]
      rw [childInputTarget, leftCurrent] at childTargetRaw
      simpa [middle, current, childPlan, leftState, childProgram, childState] using childTargetRaw
    · have childInactive :
          ¬ intervalActive
            (recursivePlan plan large (canonicalCertificate plan large))
            (readEmbedded (selectedWire plan large) leftState) j := by
        intro active
        exact factors (childActivation.mp active)
      rw [if_neg childInactive] at childTargetRaw
      rw [if_neg factors]
      rw [childInputTarget, leftCurrent] at childTargetRaw
      simpa [middle, current, childPlan, leftState, childProgram, childState] using childTargetRaw

  have childMiddle :
      childState (plan.target middle) = leftState (plan.target middle) := by
    dsimp [childState, childProgram, childPlan, middle]
    simpa [middle, childPlan] using
      mappedRecursive_preserves_ordinaryMiddle
        plan large leftState j ordinary

  have interiorChildToLeft :
      strictInteriorActive plan childState current ↔
        strictInteriorActive plan leftState current := by
    dsimp [childState, childProgram, childPlan]
    exact strictInteriorActive_mappedRecursive_iff
      plan large leftState current currentNonzero
  have interiorLeftToOriginal :
      strictInteriorActive plan leftState current ↔
        strictInteriorActive plan state current := by
    dsimp [leftState]
    exact strictInteriorActive_leftScheduled_iff
      plan state current currentNonzero
  have interiorChild :
      strictInteriorActive plan childState current ↔
        strictInteriorActive plan state current :=
    interiorChildToLeft.trans interiorLeftToOriginal

  have rightActivation :
      intervalActive plan childState current ↔
        (if intervalActive plan state middle then
            flipBit (state (plan.target middle))
          else state (plan.target middle)) = 1 ∧
        strictInteriorActive plan state current := by
    rw [intervalActive_nonfirst_iff plan childState current currentNonzero,
      middleEqPrevious, childMiddle, leftMiddle]
    exact and_congr Iff.rfl interiorChild

  have parentActivation :
      intervalActive plan state current ↔
        state (plan.target middle) = 1 ∧
          strictInteriorActive plan state current := by
    rw [intervalActive_nonfirst_iff plan state current currentNonzero,
      middleEqPrevious]

  have rightTarget := rightScheduled_ordinaryEven_target
    plan current currentEven currentPositive currentBeforeFinal childState
  simp only [rightActivation] at rightTarget
  rw [childTarget] at rightTarget

  have cancellation :=
    ordinary_pair_cancellation_prop
      (state (plan.target middle))
      (state (plan.target current))
      (intervalActive plan state middle)
      (strictInteriorActive plan state current)
  have parentFactorization :
      (if state (plan.target middle) = 1 ∧
            strictInteriorActive plan state current then
          flipBit (state (plan.target current))
        else state (plan.target current)) =
      (if intervalActive plan state current then
          flipBit (state (plan.target current))
        else state (plan.target current)) := by
    by_cases active : intervalActive plan state current
    · have factors := parentActivation.mp active
      rw [if_pos factors, if_pos active]
    · have factors :
          ¬ (state (plan.target middle) = 1 ∧
              strictInteriorActive plan state current) := by
        intro factored
        exact active (parentActivation.mpr factored)
      rw [if_neg factors, if_neg active]
  exact rightTarget.trans (cancellation.trans parentFactorization)

end RemaudVandaeleLadderAlphaOrdinaryTargetCaseSemantics
end QuantumBlockEncoding
