import QuantumBlockEncoding.RemaudVandaeleLadderAlphaAlgorithmSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaAlgorithmBaseSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaTargetSupport
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaSourceCaseClassification
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOrdinaryTargetCaseSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaSimpleTargetCaseSemantics
import Mathlib.Tactic

/-!
# Remaud--Vandaele Algorithm 2 refines Equation (7)

This is the semantic closure theorem for the general ladder-alpha synthesis.
The proof is strong induction on the number `m=k-1` of parent source targets.
All physical-register and Boolean bookkeeping has already been isolated in the
upstream proof graph, so the induction itself follows the source algorithm:

* non-alpha wires are preserved because every generated MCX target is a parent
  alpha target;
* source target zero is completed by the right wall;
* ordinary odd targets are completed by the left wall;
* ordinary even targets are the genuine recursive/cancellation case;
* the even-k special target `k-3` is completed by the recursive child alone;
* the final source target `k-2` is completed by the special final left-wall gate.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaEquationSeven

open RemaudVandaeleLadderAlphaAlgorithmBaseSemantics
open RemaudVandaeleLadderAlphaAlgorithmSchedule
open RemaudVandaeleLadderAlphaAlgorithmSemantics
open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaMappedRecursiveTargetSemantics
open RemaudVandaeleLadderAlphaOrdinaryTargetCaseSemantics
open RemaudVandaeleLadderAlphaRankCertificate
open RemaudVandaeleLadderAlphaRecursiveCertificate
open RemaudVandaeleLadderAlphaRecursiveParameters
open RemaudVandaeleLadderAlphaSimpleTargetCaseSemantics
open RemaudVandaeleLadderAlphaSourceCaseClassification
open RemaudVandaeleLadderAlphaTargetSupport

/-- Main semantic theorem: the concrete proof-bearing Algorithm-2 schedule is
exactly the closed-form Definition-6 / Equation-(7) action. -/
theorem algorithm_refines_equationSeven :
    ∀ {q m : Nat} (plan : AlphaPlan q m), AlgorithmSpec plan := by
  intro q m
  induction m using Nat.strong_induction_on generalizing q with
  | h m induction =>
      intro plan state
      by_cases zeroM : m = 0
      · subst m
        exact algorithm_zero_refines plan state
      by_cases oneM : m = 1
      · subst m
        exact algorithm_one_refines plan state
      have recursiveRegime : 2 ≤ m := by omega
      have sourceLarge : 3 ≤ m + 1 := by omega
      let childPlan := recursivePlan plan sourceLarge (canonicalCertificate plan sourceLarge)
      have smaller : recursiveTargetCount m < m :=
        recursiveTargetCount_lt recursiveRegime
      have childCorrect : ChildAlgorithmSpec childPlan := by
        intro childState
        exact induction (recursiveTargetCount m) smaller childPlan childState
      funext wire
      by_cases hit : ∃ index : Fin m, plan.target index = wire
      · rcases hit with ⟨index, rfl⟩
        rw [equationSeven_target plan state index]
        have staged :=
          congrFun (algorithm_step_eval plan sourceLarge state) (plan.target index)
        rw [staged]
        rcases sourceIndex_cases m recursiveRegime index with
          zeroIndex | finalOrRest
        · have indexEq : index = (⟨0, by omega⟩ : Fin m) := by
            apply Fin.ext
            exact zeroIndex
          simpa [indexEq, afterLeft, middleScheduled, afterMiddle, afterRight, childPlan] using
            zeroTarget_stage_action plan sourceLarge state
        · rcases finalOrRest with finalIndex | specialOrRest
          · have indexEq : index = (⟨m - 1, by omega⟩ : Fin m) := by
              apply Fin.ext
              exact finalIndex
            simpa [indexEq, afterLeft, middleScheduled, afterMiddle, afterRight, childPlan] using
              finalTarget_stage_action plan sourceLarge state
          · rcases specialOrRest with specialCase | ordinaryOrOdd
            · rcases specialCase with ⟨oddM, indexSpecial⟩
              have mLarge : 3 ≤ m := by omega
              let child := specialChildSlot m mLarge oddM
              have childSpecial : isSpecialTail m child :=
                specialChildSlot_isSpecialTail m mLarge oddM
              have childIndex :
                  recursiveOriginalTargetIndex m sourceLarge child = index := by
                apply Fin.ext
                have source := recursiveOriginalTargetIndex_specialChildSlot
                  m mLarge oddM
                dsimp [child]
                omega
              have specialStage := specialTarget_stage_action
                plan sourceLarge state child childSpecial childCorrect
              simpa [afterLeft, middleScheduled, afterMiddle, afterRight,
                childPlan, child, childIndex] using specialStage
            · rcases ordinaryOrOdd with ordinaryEven | ordinaryOdd
              · rcases ordinaryEven with ⟨even, positive, beforeFinal⟩
                let child := ordinaryEvenChildSlot index even positive beforeFinal
                have childOrdinary : ¬ isSpecialTail m child :=
                  ordinaryEvenChildSlot_not_special
                    sourceLarge index even positive beforeFinal
                have childIndex :
                    recursiveOriginalTargetIndex m sourceLarge child = index :=
                  recursiveOriginalTargetIndex_ordinaryEvenChildSlot
                    sourceLarge index even positive beforeFinal
                have ordinaryStage := ordinaryTarget_stage_action
                  plan sourceLarge state child childOrdinary childCorrect
                simpa [afterLeft, middleScheduled, afterMiddle, afterRight,
                  childPlan, child, childIndex] using ordinaryStage
              · rcases ordinaryOdd with ⟨odd, beforeTail⟩
                simpa [afterLeft, middleScheduled, afterMiddle, afterRight, childPlan] using
                  ordinaryOddTarget_stage_action
                    plan sourceLarge state index odd beforeTail
      · have notAlpha : ∀ index : Fin m, plan.target index ≠ wire := by
          intro index equal
          exact hit ⟨index, equal⟩
        exact algorithm_eq_equationSeven_nonAlpha plan state wire notAlpha

/-- Source-facing specification form. -/
theorem algorithm_spec
    {q m : Nat} (plan : AlphaPlan q m) : AlgorithmSpec plan :=
  algorithm_refines_equationSeven plan

end RemaudVandaeleLadderAlphaEquationSeven
end QuantumBlockEncoding
