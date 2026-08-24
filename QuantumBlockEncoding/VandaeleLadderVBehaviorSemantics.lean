import QuantumBlockEncoding.VandaeleLadderEquationEighteenSemantics
import Mathlib.Tactic

/-!
# Observable behavior of Vandaele `V₂`

Equation (18) gives a source-faithful three-factor implementation of `V₂`, but
Figure 5 should not need to unfold those ladders again.  This file exposes the
semantic boundary needed by the comparator proof:

* the entire prefix register is restored exactly;
* the shared initial pivot is therefore restored;
* the fresh local control of the final block is preserved;
* only the final target may change, and its exact toggle predicate is the
  activation predicate of the middle CCX after the prefix adjoint.

This turns Equation (18) into a clean one-bit interface for the subsequent
Figure-5/arithmetic bridge.
-/

namespace QuantumBlockEncoding
namespace VandaeleLadderVBehaviorSemantics

open VandaeleLadderContract
open VandaeleLadderEquationFiveSemantics
open VandaeleLadderInverseSemantics
open VandaeleLadderVSemantics
open VandaeleLadderEquationEighteenSemantics

/-- The one new middle source gate is outside the prefix, so restriction simply
forgets it. -/
theorem restrictPrefixState_lastStep
    {localControls prefixSteps : Nat}
    (state : LadderState localControls (prefixSteps + 1)) :
    restrictPrefixState
        (sourceLadderStep localControls (prefixSteps + 1)
          (Fin.last prefixSteps) state) =
      restrictPrefixState state := by
  apply Prod.ext
  · change
      (sourceLadderStep localControls (prefixSteps + 1)
        (Fin.last prefixSteps) state).1 = state.1
    exact sourceLadderStep_preserves_initialPivot
      localControls (prefixSteps + 1) (Fin.last prefixSteps) state
  · funext query
    apply Prod.ext
    · change
        ((sourceLadderStep localControls (prefixSteps + 1)
          (Fin.last prefixSteps) state).2 query.castSucc).1 =
          (state.2 query.castSucc).1
      exact sourceLadderStep_preserves_localControls
        localControls (prefixSteps + 1) (Fin.last prefixSteps)
        query.castSucc state
    · change
        ((sourceLadderStep localControls (prefixSteps + 1)
          (Fin.last prefixSteps) state).2 query.castSucc).2 =
          (state.2 query.castSucc).2
      exact sourceLadderStep_preserves_other_target
        (Fin.last prefixSteps) query.castSucc state
        (ne_of_lt (Fin.castSucc_lt_last query))

/-- Equation (18) restores the complete prefix register exactly.  Semantically,
the forward prefix ladder cancels the prefix adjoint after the middle gate,
because that middle gate lies outside the restricted prefix. -/
theorem equationEighteen_preserves_prefix
    (prefixSteps : Nat)
    (state : LadderState 1 (prefixSteps + 1)) :
    restrictPrefixState (equationEighteenAction prefixSteps state) =
      restrictPrefixState state := by
  unfold equationEighteenAction
  rw [restrictPrefixState_prefixSourceLadder]
  rw [restrictPrefixState_lastStep]
  rw [restrictPrefixState_prefixInverseSourceLadder]
  exact sourceLadder_after_inverseSourceLadder
    1 prefixSteps (restrictPrefixState state)

/-- In particular, `V₂` restores the shared first pivot. -/
@[simp] theorem equationEighteen_preserves_initialPivot
    (prefixSteps : Nat)
    (state : LadderState 1 (prefixSteps + 1)) :
    (equationEighteenAction prefixSteps state).1 = state.1 := by
  have preserved := congrArg Prod.fst
    (equationEighteen_preserves_prefix prefixSteps state)
  simpa [restrictPrefixState] using preserved

/-- Every complete block in the first `n-1` positions is restored exactly. -/
theorem equationEighteen_preserves_prefixBlock
    (prefixSteps : Nat)
    (state : LadderState 1 (prefixSteps + 1))
    (index : Fin prefixSteps) :
    (equationEighteenAction prefixSteps state).2 index.castSucc =
      state.2 index.castSucc := by
  have preserved := congrArg (fun prefix => prefix.2 index)
    (equationEighteen_preserves_prefix prefixSteps state)
  simpa [restrictPrefixState] using preserved

/-- The fresh local control in the final block is also untouched. -/
@[simp] theorem equationEighteen_preserves_lastLocalControls
    (prefixSteps : Nat)
    (state : LadderState 1 (prefixSteps + 1)) :
    ((equationEighteenAction prefixSteps state).2
      (Fin.last prefixSteps)).1 =
      (state.2 (Fin.last prefixSteps)).1 := by
  let prefixInverse :=
    prefixInverseSourceLadderAction 1 prefixSteps state
  let middle :=
    sourceLadderStep 1 (prefixSteps + 1) (Fin.last prefixSteps) prefixInverse
  calc
    ((equationEighteenAction prefixSteps state).2
        (Fin.last prefixSteps)).1 =
        (middle.2 (Fin.last prefixSteps)).1 := by
      exact congrArg (fun block => block.1)
        (prefixSourceLadder_preserves_lastBlock 1 prefixSteps middle)
    _ = (prefixInverse.2 (Fin.last prefixSteps)).1 := by
      exact sourceLadderStep_preserves_localControls
        1 (prefixSteps + 1) (Fin.last prefixSteps)
        (Fin.last prefixSteps) prefixInverse
    _ = (state.2 (Fin.last prefixSteps)).1 := by
      exact congrArg (fun block => block.1)
        (prefixInverseSourceLadder_preserves_lastBlock 1 prefixSteps state)

/-- Boolean signal presented to the middle CCX of Equation (18). -/
def equationEighteenMiddleActive
    (prefixSteps : Nat)
    (state : LadderState 1 (prefixSteps + 1)) : Prop :=
  ladderActive
    (prefixInverseSourceLadderAction 1 prefixSteps state)
    (Fin.last prefixSteps)

/-- Exact final-target behavior of Equation (18): no hidden changes survive;
the target is toggled iff the middle CCX is active after `L₂^(n-1)†`. -/
theorem equationEighteen_lastTarget
    (prefixSteps : Nat)
    (state : LadderState 1 (prefixSteps + 1)) :
    ((equationEighteenAction prefixSteps state).2
      (Fin.last prefixSteps)).2 =
      if equationEighteenMiddleActive prefixSteps state then
        flipBit (state.2 (Fin.last prefixSteps)).2
      else
        (state.2 (Fin.last prefixSteps)).2 := by
  let prefixInverse :=
    prefixInverseSourceLadderAction 1 prefixSteps state
  let middle :=
    sourceLadderStep 1 (prefixSteps + 1) (Fin.last prefixSteps) prefixInverse
  have inverseLast :=
    prefixInverseSourceLadder_preserves_lastBlock 1 prefixSteps state
  have inverseTarget :
      (prefixInverse.2 (Fin.last prefixSteps)).2 =
        (state.2 (Fin.last prefixSteps)).2 :=
    congrArg (fun block => block.2) inverseLast
  calc
    ((equationEighteenAction prefixSteps state).2
        (Fin.last prefixSteps)).2 =
        (middle.2 (Fin.last prefixSteps)).2 := by
      exact congrArg (fun block => block.2)
        (prefixSourceLadder_preserves_lastBlock 1 prefixSteps middle)
    _ = if ladderActive prefixInverse (Fin.last prefixSteps) then
          flipBit (prefixInverse.2 (Fin.last prefixSteps)).2
        else
          (prefixInverse.2 (Fin.last prefixSteps)).2 := by
      exact sourceLadderStep_target
        1 (prefixSteps + 1) (Fin.last prefixSteps) prefixInverse
    _ = if equationEighteenMiddleActive prefixSteps state then
          flipBit (state.2 (Fin.last prefixSteps)).2
        else
          (state.2 (Fin.last prefixSteps)).2 := by
      simp [equationEighteenMiddleActive, prefixInverse, inverseTarget]

/-- Extensional summary: two Equation-(18) outputs agree whenever their input
prefixes, final local controls, final targets, and middle activation predicates
agree.  This is a convenient abstraction boundary for the Figure-5 embedding. -/
theorem equationEighteen_ext_of_interface
    (prefixSteps : Nat)
    (left right : LadderState 1 (prefixSteps + 1))
    (prefixEq : restrictPrefixState left = restrictPrefixState right)
    (lastControlsEq :
      (left.2 (Fin.last prefixSteps)).1 =
        (right.2 (Fin.last prefixSteps)).1)
    (lastTargetEq :
      (left.2 (Fin.last prefixSteps)).2 =
        (right.2 (Fin.last prefixSteps)).2)
    (activeEq :
      equationEighteenMiddleActive prefixSteps left ↔
        equationEighteenMiddleActive prefixSteps right) :
    equationEighteenAction prefixSteps left =
      equationEighteenAction prefixSteps right := by
  apply Prod.ext
  · rw [equationEighteen_preserves_initialPivot,
      equationEighteen_preserves_initialPivot]
    exact congrArg Prod.fst prefixEq
  · funext query
    by_cases isLast : query = Fin.last prefixSteps
    · subst query
      apply Prod.ext
      · simpa using lastControlsEq
      · rw [equationEighteen_lastTarget, equationEighteen_lastTarget]
        by_cases activeLeft : equationEighteenMiddleActive prefixSteps left
        · have activeRight : equationEighteenMiddleActive prefixSteps right :=
            activeEq.mp activeLeft
          simp [activeLeft, activeRight, lastTargetEq]
        · have inactiveRight :
              ¬ equationEighteenMiddleActive prefixSteps right := by
            intro contradiction
            exact activeLeft (activeEq.mpr contradiction)
          simp [activeLeft, inactiveRight, lastTargetEq]
    · have queryLt : query < Fin.last prefixSteps := Fin.lt_last_iff_ne_last.mpr isLast
      let prefixIndex : Fin prefixSteps :=
        ⟨query.val, by
          have queryLtVal : query.val < prefixSteps := by
            simpa using queryLt
          exact queryLtVal⟩
      have queryEq : prefixIndex.castSucc = query := by
        apply Fin.ext
        rfl
      rw [← queryEq,
        equationEighteen_preserves_prefixBlock,
        equationEighteen_preserves_prefixBlock]
      have blockEq := congrArg (fun prefix => prefix.2 prefixIndex) prefixEq
      simpa [restrictPrefixState] using blockEq

end VandaeleLadderVBehaviorSemantics
end QuantumBlockEncoding
