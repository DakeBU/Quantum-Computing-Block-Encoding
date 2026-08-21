import QuantumBlockEncoding.RemaudVandaeleLadder1AlgorithmSchedule
import QuantumBlockEncoding.RemaudVandaeleLadder1TargetGeometry
import QuantumBlockEncoding.ScheduledWireEmbedding
import QuantumBlockEncoding.VandaeleLemma3ProgramFamily
import Mathlib.Tactic

/-!
# Correctness of Remaud--Vandaele Algorithm 1

This module completes the semantic part of the citation used by Vandaele 2026
Lemma 3.  It follows the source proof of Remaud--Vandaele Lemma 2:

1. apply the left depth-one wall `U_L`;
2. recursively apply `L_1` to the selected register `X'`;
3. apply the right depth-one wall `U_R`;
4. cancel the shared odd predecessor by XOR associativity.

The final theorem states that the *actual proof-bearing scheduled circuit* from
`RemaudVandaeleLadder1AlgorithmSchedule` implements

`x_0 -> x_0`, `x_i -> x_i xor x_(i-1)` for every `i>0`,

which is exactly Vandaele Definition-2.3 Equation (5) for `L_1`.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadder1AlgorithmSemantics

open RemaudVandaeleLadder1AlgorithmPlan
open RemaudVandaeleLadder1AlgorithmSchedule
open RemaudVandaeleLadder1TargetGeometry
open RemaudVandaeleLadder1WallSemantics
open ReversibleLayerSemantics
open ReversibleProgramSupport
open ReversibleWireEmbedding
open ScheduledWireEmbedding
open VandaeleLadderContract
open VandaeleLemma3ProgramFamily

/-- Closed-form first-order ladder action directly on a flat n-wire basis. -/
def adjacentXorAction (n : Nat)
    (state : PrimitiveBasis n) : PrimitiveBasis n :=
  fun wire =>
    if first : wire.val = 0 then state wire
    else xorBit (state ⟨wire.val - 1, by omega⟩) (state wire)

/-- Source Algorithm-1 correctness proposition at physical width n. -/
def AlgorithmSpec (n : Nat) : Prop :=
  ∀ state,
    evalReversibleProgram (algorithm n).program state =
      adjacentXorAction n state

/-- State after the source left wall. -/
def afterLeft {n : Nat} (state : PrimitiveBasis n) : PrimitiveBasis n :=
  evalReversibleProgram (leftLayer n) state

/-- Embedded recursive middle schedule. -/
def middleScheduled (n : Nat) : ScheduledReversibleProgram n :=
  mapScheduledWires
    (recursiveWire n)
    (recursiveWire_injective (n := n))
    (algorithm (recursiveWidth n))

/-- State after left wall and recursive subcircuit. -/
def afterMiddle {n : Nat} (state : PrimitiveBasis n) : PrimitiveBasis n :=
  evalReversibleProgram (middleScheduled n).program (afterLeft state)

/-- Complete source step state. -/
def afterRight {n : Nat} (state : PrimitiveBasis n) : PrimitiveBasis n :=
  evalReversibleProgram (rightLayer n) (afterMiddle state)

/-- The recursive schedule definition evaluates exactly as `U_R U_X' U_L`. -/
theorem algorithm_step_eval
    {n : Nat} (large : 3 ≤ n)
    (state : PrimitiveBasis n) :
    evalReversibleProgram (algorithm n).program state = afterRight state := by
  rw [algorithm_step large]
  simp [afterRight, afterMiddle, afterLeft, middleScheduled,
    oneLayerScheduled, ScheduledReversibleProgram.seq_program,
    evalReversibleProgram_append]

/-- The left wall preserves physical X0. -/
theorem left_preserves_zero
    {n : Nat} (large : 3 ≤ n)
    (state : PrimitiveBasis n) :
    afterLeft state ⟨0, by omega⟩ = state ⟨0, by omega⟩ := by
  unfold afterLeft
  apply eval_layer_preserves_of_no_target
  intro gate member
  simp [leftLayer] at member
  rcases member with ⟨index, rfl⟩
  simp [leftGate, targetsWire]
  intro equal
  have values := congrArg Fin.val equal
  by_cases last : index.val + 1 = outerCount n <;>
    simp [leftTarget, last] at values <;> omega

/-- The recursive middle circuit is outside physical X0. -/
theorem middle_preserves_zero
    {n : Nat} (large : 3 ≤ n)
    (state : PrimitiveBasis n) :
    afterMiddle state ⟨0, by omega⟩ = afterLeft state ⟨0, by omega⟩ := by
  unfold afterMiddle middleScheduled
  rw [mapScheduledWires_program]
  apply eval_mapProgramWires_outside
  intro recursive
  intro equal
  have values := congrArg Fin.val equal
  by_cases last : recursive.val + 1 = recursiveWidth n <;>
    simp [recursiveWire, last] at values <;> omega

/-- The right wall also preserves physical X0. -/
theorem right_preserves_zero
    {n : Nat} (large : 3 ≤ n)
    (state : PrimitiveBasis n) :
    afterRight state ⟨0, by omega⟩ = afterMiddle state ⟨0, by omega⟩ := by
  unfold afterRight
  apply eval_layer_preserves_of_no_target
  intro gate member
  simp [rightLayer] at member
  rcases member with ⟨index, rfl⟩
  simp [rightGate, targetsWire, rightTarget]

/-- Hence the complete recursive step preserves the first source bit. -/
theorem step_preserves_zero
    {n : Nat} (large : 3 ≤ n)
    (state : PrimitiveBasis n) :
    afterRight state ⟨0, by omega⟩ = state ⟨0, by omega⟩ := by
  rw [right_preserves_zero large, middle_preserves_zero large,
    left_preserves_zero large]

/-- The recursive call acts on one selected X' coordinate according to the
induction hypothesis, while the preceding left wall is invisible on X'. -/
theorem middle_selected_action
    {n : Nat} (large : 3 ≤ n)
    (recursiveCorrect : AlgorithmSpec (recursiveWidth n))
    (state : PrimitiveBasis n)
    (index : Fin (recursiveWidth n)) :
    afterMiddle state (recursiveWire n index) =
      adjacentXorAction (recursiveWidth n)
        (readEmbeddedState (recursiveWire n) state) index := by
  have embedded := readEmbeddedState_eval_mapScheduledWires
    (recursiveWire n)
    (recursiveWire_injective (n := n))
    (algorithm (recursiveWidth n))
    (afterLeft state)
  have coordinate := congrFun embedded index
  have recursive := congrFun
    (recursiveCorrect
      (readEmbeddedState (recursiveWire n) (afterLeft state))) index
  have leftRegister := leftLayer_preserves_recursiveRegister n state
  unfold afterMiddle middleScheduled
  rw [mapScheduledWires_program]
  change
    readEmbeddedState (recursiveWire n)
      (evalReversibleProgram
        (mapProgramWires (recursiveWire n)
          (recursiveWire_injective (n := n))
          (algorithm (recursiveWidth n)).program)
        (afterLeft state)) index = _
  rw [coordinate, recursive, leftRegister]

/-- Reader-facing form of the previous theorem for a right-wall target. -/
theorem middle_rightTarget_action
    {n : Nat} (large : 3 ≤ n)
    (recursiveCorrect : AlgorithmSpec (recursiveWidth n))
    (state : PrimitiveBasis n)
    (j : Fin (outerCount n)) :
    afterMiddle state (rightTarget n j) =
      if zero : j.val = 0 then
        state (rightTarget n j)
      else
        xorBit
          (state (recursiveWire n (rightPreviousRecursiveIndex n j zero)))
          (state (rightTarget n j)) := by
  let recursiveIndex := rightRecursiveIndex n j
  have selected := middle_selected_action
    large recursiveCorrect state recursiveIndex
  rw [recursiveWire_rightRecursiveIndex n j] at selected
  by_cases zero : j.val = 0
  · simp [zero]
    have first : recursiveIndex.val = 0 := by simp [recursiveIndex, rightRecursiveIndex, zero]
    simpa [adjacentXorAction, first, readEmbeddedState,
      recursiveIndex, rightRecursiveIndex,
      recursiveWire_rightRecursiveIndex n j] using selected
  · simp [zero]
    have nonfirst : recursiveIndex.val ≠ 0 := by
      simp [recursiveIndex, rightRecursiveIndex, zero]
    let previous : Fin (recursiveWidth n) :=
      ⟨recursiveIndex.val - 1, by omega⟩
    have previousEq : previous = rightPreviousRecursiveIndex n j zero := by
      apply Fin.ext
      simp [previous, recursiveIndex, rightRecursiveIndex,
        rightPreviousRecursiveIndex]
    simpa [adjacentXorAction, nonfirst, readEmbeddedState,
      previous, previousEq, recursiveIndex,
      recursiveWire_rightRecursiveIndex n j] using selected

/-- The recursive middle circuit leaves every right-wall even control unchanged;
therefore its value is exactly the value produced by U_L. -/
theorem middle_rightControl_action
    {n : Nat} (large : 3 ≤ n)
    (state : PrimitiveBasis n)
    (j : Fin (outerCount n)) :
    afterMiddle state (rightControl n j) =
      afterLeft state (rightControl n j) := by
  unfold afterMiddle middleScheduled
  rw [mapScheduledWires_program]
  exact embeddedRecursive_preserves_rightControl
    n (algorithm (recursiveWidth n)).program j (afterLeft state)

/-- The complete right-wall action on one odd target. -/
theorem final_rightTarget_action
    {n : Nat} (large : 3 ≤ n)
    (recursiveCorrect : AlgorithmSpec (recursiveWidth n))
    (state : PrimitiveBasis n)
    (j : Fin (outerCount n)) :
    afterRight state (rightTarget n j) =
      xorBit (state (rightControl n j)) (state (rightTarget n j)) := by
  unfold afterRight
  rw [rightLayer_target]
  rw [middle_rightControl_action large]
  rw [leftLayer_rightControl]
  rw [middle_rightTarget_action large recursiveCorrect]
  by_cases zero : j.val = 0
  · simp [zero]
  · simp [zero]
    exact xorBit_parallelogram
      (state (recursiveWire n (rightPreviousRecursiveIndex n j zero)))
      (state (rightControl n j))
      (state (rightTarget n j))

/-- The final physical wire is changed only by the special last gate of U_L. -/
theorem final_lastWire_action
    {n : Nat} (large : 3 ≤ n)
    (state : PrimitiveBasis n) :
    afterRight state ⟨n - 1, by omega⟩ =
      xorBit (state ⟨n - 2, by omega⟩) (state ⟨n - 1, by omega⟩) := by
  let lastLeft := lastLeftIndex n large
  have leftTargetEq := leftTarget_last n large
  have leftControlEq := leftControl_last n large
  have leftAction := leftLayer_target n lastLeft state
  rw [leftTargetEq, leftControlEq] at leftAction
  have middlePreserves :
      afterMiddle state ⟨n - 1, by omega⟩ =
        afterLeft state ⟨n - 1, by omega⟩ := by
    unfold afterMiddle middleScheduled
    rw [mapScheduledWires_program]
    apply eval_mapProgramWires_outside
    intro recursive
    intro equal
    have values := congrArg Fin.val equal
    by_cases last : recursive.val + 1 = recursiveWidth n <;>
      simp [recursiveWire, last] at values <;> omega
  have rightPreserves :
      afterRight state ⟨n - 1, by omega⟩ =
        afterMiddle state ⟨n - 1, by omega⟩ := by
    unfold afterRight
    apply eval_layer_preserves_of_no_target
    intro gate member
    simp [rightLayer] at member
    rcases member with ⟨j, rfl⟩
    simp [rightGate, targetsWire]
    intro equal
    have values := congrArg Fin.val equal
    simp [rightTarget] at values
    have hj := j.isLt
    unfold outerCount at hj
    omega
  rw [rightPreserves, middlePreserves, leftAction]

/-- A normal even nonlast target is produced entirely by U_L and then preserved
by both later stages. -/
theorem final_normalEven_action
    {n : Nat} (large : 3 ≤ n)
    (state : PrimitiveBasis n)
    (wire : Fin n)
    (positiveWire : 0 < wire.val)
    (even : wire.val % 2 = 0)
    (notPenultimate : wire.val ≠ n - 2)
    (nonlast : wire.val ≠ n - 1) :
    afterRight state wire =
      xorBit (state ⟨wire.val - 1, by omega⟩) (state wire) := by
  let left := leftIndexOfEven large wire positiveWire even notPenultimate nonlast
  have targetEq := leftTarget_of_even
    large wire positiveWire even notPenultimate nonlast
  have controlVal := leftControl_of_even
    large wire positiveWire even notPenultimate nonlast
  have leftAction := leftLayer_target n left state
  rw [targetEq] at leftAction
  have controlEq : leftControl n left = ⟨wire.val - 1, by omega⟩ := by
    apply Fin.ext
    exact controlVal
  rw [controlEq] at leftAction
  have middlePreserves : afterMiddle state wire = afterLeft state wire := by
    unfold afterMiddle middleScheduled
    rw [mapScheduledWires_program]
    apply eval_mapProgramWires_outside
    intro recursive
    exact even_not_recursive
      large wire positiveWire even notPenultimate recursive
  have rightPreserves : afterRight state wire = afterMiddle state wire := by
    unfold afterRight
    apply eval_layer_preserves_of_no_target
    intro gate member
    simp [rightLayer] at member
    rcases member with ⟨j, rfl⟩
    simp [rightGate, targetsWire]
    intro equal
    have values := congrArg Fin.val equal
    have division := Nat.mod_add_div wire.val 2
    simp [rightTarget] at values
    omega
  rw [rightPreserves, middlePreserves, leftAction]

/-- The special even penultimate wire of an even-width register is the last
recursive `X'` coordinate and gets its adjacent XOR from the recursive call. -/
theorem final_penultimateEven_action
    {n : Nat} (large : 4 ≤ n)
    (penultimateEven : (n - 2) % 2 = 0)
    (recursiveCorrect : AlgorithmSpec (recursiveWidth n))
    (state : PrimitiveBasis n) :
    afterRight state ⟨n - 2, by omega⟩ =
      xorBit (state ⟨n - 3, by omega⟩) (state ⟨n - 2, by omega⟩) := by
  let last := lastRecursiveIndex n (by omega)
  have selected := middle_selected_action
    (n := n) (by omega) recursiveCorrect state last
  rw [recursiveWire_last n (by omega)] at selected
  have widthTwo : 2 ≤ recursiveWidth n := by
    unfold recursiveWidth
    omega
  have lastNonzero : last.val ≠ 0 := by
    simp [last, lastRecursiveIndex]
    omega
  let previous : Fin (recursiveWidth n) := ⟨last.val - 1, by omega⟩
  have previousWire := recursiveWire_before_last large penultimateEven
  dsimp at previousWire
  have selectedAction :
      afterMiddle state ⟨n - 2, by omega⟩ =
        xorBit (state ⟨n - 3, by omega⟩) (state ⟨n - 2, by omega⟩) := by
    simpa [adjacentXorAction, lastNonzero, readEmbeddedState,
      previous, previousWire] using selected
  have rightPreserves :
      afterRight state ⟨n - 2, by omega⟩ =
        afterMiddle state ⟨n - 2, by omega⟩ := by
    unfold afterRight
    apply eval_layer_preserves_of_no_target
    intro gate member
    simp [rightLayer] at member
    rcases member with ⟨j, rfl⟩
    simp [rightGate, targetsWire]
    intro equal
    have values := congrArg Fin.val equal
    have hj := j.isLt
    simp [rightTarget] at values
    unfold outerCount at hj
    omega
  rw [rightPreserves, selectedAction]

/-- Main recursive correctness theorem in flat coordinates. -/
theorem algorithm_correct : ∀ n, AlgorithmSpec n := by
  intro n
  induction n using Nat.strong_induction_on with
  | h n induction =>
      rcases n with (_ | _ | _ | m)
      · intro state
        funext wire
        exact Fin.elim0 wire
      · intro state
        funext wire
        fin_cases wire
        rfl
      · intro state
        funext wire
        fin_cases wire
        · rfl
        · simpa [algorithm, baseTwoScheduled, oneLayerScheduled,
            adjacentXorAction, xorBit] using
            eval_cx_target (0 : Fin 2) (1 : Fin 2) (by decide) state
      · let n := m + 3
        have large : 3 ≤ n := by omega
        have smaller : recursiveWidth n < n := recursiveWidth_lt (by omega)
        have recursiveCorrect := induction (recursiveWidth n) smaller
        intro state
        rw [algorithm_step_eval large]
        funext wire
        by_cases first : wire.val = 0
        · have wireZero : wire = ⟨0, by omega⟩ := by
            apply Fin.ext
            exact first
          subst wire
          simpa [adjacentXorAction] using step_preserves_zero large state
        · have positiveWire : 0 < wire.val := Nat.pos_of_ne_zero first
          by_cases last : wire.val = n - 1
          · have wireLast : wire = ⟨n - 1, by omega⟩ := by
              apply Fin.ext
              exact last
            subst wire
            simpa [adjacentXorAction, first] using final_lastWire_action large state
          · by_cases odd : wire.val % 2 = 1
            · let j := rightIndexOfOdd large wire last odd
              have targetEq := rightTarget_of_odd large wire last odd
              have controlVal := rightControl_of_odd large wire last odd
              have source := final_rightTarget_action large recursiveCorrect state j
              rw [targetEq] at source
              have controlEq : rightControl n j = ⟨wire.val - 1, by omega⟩ := by
                apply Fin.ext
                exact controlVal
              rw [controlEq] at source
              simpa [adjacentXorAction, first] using source
            · have modLt : wire.val % 2 < 2 := Nat.mod_lt _ (by omega)
              have even : wire.val % 2 = 0 := by omega
              by_cases penultimate : wire.val = n - 2
              · have nLarge : 4 ≤ n := by
                  have wireLt := wire.isLt
                  omega
                have penultimateEven : (n - 2) % 2 = 0 := by
                  simpa [penultimate] using even
                have wireEq : wire = ⟨n - 2, by omega⟩ := by
                  apply Fin.ext
                  exact penultimate
                subst wire
                simpa [adjacentXorAction, first] using
                  final_penultimateEven_action
                    nLarge penultimateEven recursiveCorrect state
              · simpa [adjacentXorAction, first] using
                  final_normalEven_action large state wire positiveWire even
                    penultimate last

/-- Physical Algorithm-1 action at width `steps+1` gives exactly the flat
Equation-(5) contract used by Vandaele 2026 Lemma 3. -/
theorem algorithm_vandaele_flatSpec (steps : Nat) :
    LemmaThreeFlatSpec steps
      (evalReversibleProgram (algorithm (steps + 1)).program) := by
  intro state
  have correctness := congrFun (algorithm_correct (steps + 1) state)
  let expected := equationFiveAction 0 steps (extractLadderState steps state)
  constructor
  · have pivot := correctness (pivotWire steps)
    simpa [adjacentXorAction, pivotWire, expected,
      equationFiveAction, extractLadderState] using pivot
  · intro index
    have target := correctness (targetWire steps index)
    by_cases first : index.val = 0
    · have activeIff :
          ladderActive (extractLadderState steps state) index ↔
            state (pivotWire steps) = 1 := by
        unfold ladderActive allLocalControlsOne
        rw [previousPivot]
        simp [first, extractLadderState]
      fin_cases hcontrol : state (pivotWire steps) <;>
        simp [expected, equationFiveAction, activeIff,
          adjacentXorAction, targetWire, pivotWire,
          extractLadderState, xorBit, first, hcontrol] at target ⊢
    · let previous : Fin steps := ⟨index.val - 1, by omega⟩
      have activeIff :
          ladderActive (extractLadderState steps state) index ↔
            state (targetWire steps previous) = 1 := by
        unfold ladderActive allLocalControlsOne
        rw [previousPivot_nonfirst (extractLadderState steps state) index first]
        simp [extractLadderState, previous]
      have previousPhysical :
          targetWire steps previous = ⟨index.val, by
            have hi := index.isLt
            unfold flatWidth
            omega⟩ := by
        apply Fin.ext
        simp [targetWire, previous]
        omega
      fin_cases hcontrol : state (targetWire steps previous) <;>
        simp [expected, equationFiveAction, activeIff,
          adjacentXorAction, targetWire, extractLadderState,
          xorBit, first, previous, previousPhysical, hcontrol] at target ⊢

end RemaudVandaeleLadder1AlgorithmSemantics
end QuantumBlockEncoding
