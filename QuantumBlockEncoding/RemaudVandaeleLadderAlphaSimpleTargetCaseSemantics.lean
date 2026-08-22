import QuantumBlockEncoding.RemaudVandaeleLadderAlphaFirstIntervalNoninterference
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaMappedRecursiveTargetSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOuterCaseSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveStageExclusionSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaSpecialAfterLeftActivation
import Mathlib.Tactic

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaSimpleTargetCaseSemantics

open MultiControlledXEmbedding
open RemaudVandaeleLadderAlphaAlgorithmSchedule
open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaFirstIntervalNoninterference
open RemaudVandaeleLadderAlphaMappedRecursiveTargetSemantics
open RemaudVandaeleLadderAlphaOuterCaseSemantics
open RemaudVandaeleLadderAlphaOuterLayers
open RemaudVandaeleLadderAlphaRankCertificate
open RemaudVandaeleLadderAlphaRecursiveCertificate
open RemaudVandaeleLadderAlphaRecursiveParameters
open RemaudVandaeleLadderAlphaRecursiveStageExclusionSemantics
open RemaudVandaeleLadderAlphaSelectedRegister
open RemaudVandaeleLadderAlphaSpecialAfterLeftActivation

/-- The complete recursive stage action on parent source target zero is exactly
the source Equation-(7) action. -/
theorem zeroTarget_stage_action
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q) :
    let zero : Fin m := ⟨0, by omega⟩
    let leftState := (leftScheduled plan).eval state
    let childState :=
      (mapScheduled
        (selectedWire plan large)
        (selectedWire_injective plan large)
        (algorithm (recursivePlan plan large (canonicalCertificate plan large)))).eval
        leftState
    (rightScheduled plan).eval childState (plan.target zero) =
      if intervalActive plan state zero then
        flipBit (state (plan.target zero))
      else state (plan.target zero) := by
  let zero : Fin m := ⟨0, by omega⟩
  let leftState := (leftScheduled plan).eval state
  let childState :=
    (mapScheduled
      (selectedWire plan large)
      (selectedWire_injective plan large)
      (algorithm (recursivePlan plan large (canonicalCertificate plan large)))).eval
      leftState
  have leftTarget : leftState (plan.target zero) = state (plan.target zero) := by
    dsimp [leftState, zero]
    exact leftScheduled_preserves_zeroTarget plan (by omega) state
  have childTarget : childState (plan.target zero) = leftState (plan.target zero) := by
    dsimp [childState, zero]
    exact mappedRecursive_preserves_zeroTarget plan large leftState
  have leftActivation :
      intervalActive plan leftState zero ↔ intervalActive plan state zero := by
    dsimp [leftState]
    exact firstIntervalActive_leftScheduled_iff plan zero (by simp [zero]) state
  have childActivation :
      intervalActive plan childState zero ↔ intervalActive plan leftState zero := by
    dsimp [childState]
    exact firstIntervalActive_mappedRecursive_iff
      plan large zero (by simp [zero]) leftState
  have activation :
      intervalActive plan childState zero ↔ intervalActive plan state zero :=
    childActivation.trans leftActivation
  have right := rightScheduled_zero_target plan (by omega) childState
  change
    (rightScheduled plan).eval childState (plan.target zero) =
      if intervalActive plan state zero then
        flipBit (state (plan.target zero))
      else state (plan.target zero)
  simpa [zero, activation, childTarget, leftTarget] using right

/-- An ordinary odd parent target is completed by C_L; the child and C_R both
preserve it. -/
theorem ordinaryOddTarget_stage_action
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q) (index : Fin m)
    (odd : index.val % 2 = 1)
    (beforeTail : index.val + 2 < m) :
    let leftState := (leftScheduled plan).eval state
    let childState :=
      (mapScheduled
        (selectedWire plan large)
        (selectedWire_injective plan large)
        (algorithm (recursivePlan plan large (canonicalCertificate plan large)))).eval
        leftState
    (rightScheduled plan).eval childState (plan.target index) =
      if intervalActive plan state index then
        flipBit (state (plan.target index))
      else state (plan.target index) := by
  let leftState := (leftScheduled plan).eval state
  let childState :=
    (mapScheduled
      (selectedWire plan large)
      (selectedWire_injective plan large)
      (algorithm (recursivePlan plan large (canonicalCertificate plan large)))).eval
      leftState
  have leftTarget := leftScheduled_ordinaryOdd_target
    plan index odd beforeTail state
  have childTarget : childState (plan.target index) = leftState (plan.target index) := by
    dsimp [childState]
    exact mappedRecursive_preserves_ordinaryOddTarget
      plan large leftState index odd beforeTail
  have rightTarget :
      (rightScheduled plan).eval childState (plan.target index) =
        childState (plan.target index) :=
    rightScheduled_preserves_ordinaryOddTarget plan index odd childState
  change
    (rightScheduled plan).eval childState (plan.target index) =
      if intervalActive plan state index then
        flipBit (state (plan.target index))
      else state (plan.target index)
  rw [rightTarget, childTarget]
  exact leftTarget

/-- The even-k special target is untouched by both walls; the recursive child
implements exactly the parent source gate. -/
theorem specialTarget_stage_action
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q)
    (j : Fin (recursiveTargetCount m))
    (special : isSpecialTail m j)
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
  let childPlan := recursivePlan plan large (canonicalCertificate plan large)
  let leftState := (leftScheduled plan).eval state
  let childProgram :=
    mapScheduled
      (selectedWire plan large)
      (selectedWire_injective plan large)
      (algorithm childPlan)
  let childState := childProgram.eval leftState
  have currentVal := recursiveOriginalTargetIndex_special m large j special
  have oddM : m % 2 = 1 := by
    have evenK := special.1
    omega
  have mLarge : 3 ≤ m := by
    have childLt := j.isLt
    unfold recursiveTargetCount RemaudVandaeleLadderAlphaResource.recursiveK at childLt
    omega
  have currentEq : current = (⟨m - 2, by omega⟩ : Fin m) := by
    apply Fin.ext
    dsimp [current]
    exact currentVal
  have leftTarget : leftState (plan.target current) = state (plan.target current) := by
    dsimp [leftState]
    rw [currentEq]
    exact leftScheduled_preserves_specialTail plan mLarge oddM state
  have childRaw := mappedRecursive_target_action
    plan large leftState j childCorrect
  have childInputTarget :
      readEmbedded (selectedWire plan large) leftState (childPlan.target j) =
        leftState (plan.target current) := by
    unfold readEmbedded
    have physical := canonical_recursive_target_physical plan large j
    dsimp [childPlan, current] at physical ⊢
    rw [physical]
  have childActivation := recursiveIntervalActive_special_afterLeft_iff_parent
    plan large state j special
  have childTarget :
      childState (plan.target current) =
        if intervalActive plan state current then
          flipBit (state (plan.target current))
        else state (plan.target current) := by
    rw [equationSeven_target] at childRaw
    simp only [childActivation] at childRaw
    rw [childInputTarget, leftTarget] at childRaw
    simpa [childState, childProgram, childPlan, current] using childRaw
  have rightTarget :
      (rightScheduled plan).eval childState (plan.target current) =
        childState (plan.target current) := by
    rw [currentEq]
    exact rightScheduled_preserves_specialTail plan mLarge oddM childState
  change
    (rightScheduled plan).eval childState (plan.target current) =
      if intervalActive plan state current then
        flipBit (state (plan.target current))
      else state (plan.target current)
  rw [rightTarget]
  exact childTarget

/-- The final source target is completed by the special final C_L gate before
the child changes its predecessor; the child and C_R preserve the final target. -/
theorem finalTarget_stage_action
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q) :
    let final : Fin m := ⟨m - 1, by omega⟩
    let leftState := (leftScheduled plan).eval state
    let childState :=
      (mapScheduled
        (selectedWire plan large)
        (selectedWire_injective plan large)
        (algorithm (recursivePlan plan large (canonicalCertificate plan large)))).eval
        leftState
    (rightScheduled plan).eval childState (plan.target final) =
      if intervalActive plan state final then
        flipBit (state (plan.target final))
      else state (plan.target final) := by
  let final : Fin m := ⟨m - 1, by omega⟩
  let leftState := (leftScheduled plan).eval state
  let childState :=
    (mapScheduled
      (selectedWire plan large)
      (selectedWire_injective plan large)
      (algorithm (recursivePlan plan large (canonicalCertificate plan large)))).eval
      leftState
  have leftTarget :
      leftState (plan.target final) =
        if intervalActive plan state final then
          flipBit (state (plan.target final))
        else state (plan.target final) := by
    dsimp [leftState, final]
    exact leftScheduled_final_target plan (by omega) state
  have childTarget : childState (plan.target final) = leftState (plan.target final) := by
    dsimp [childState, final]
    exact mappedRecursive_preserves_finalTarget plan large leftState
  have rightTarget :
      (rightScheduled plan).eval childState (plan.target final) =
        childState (plan.target final) := by
    dsimp [final]
    exact rightScheduled_preserves_finalTarget plan (by omega) childState
  change
    (rightScheduled plan).eval childState (plan.target final) =
      if intervalActive plan state final then
        flipBit (state (plan.target final))
      else state (plan.target final)
  rw [rightTarget, childTarget]
  exact leftTarget

end RemaudVandaeleLadderAlphaSimpleTargetCaseSemantics
end QuantumBlockEncoding
