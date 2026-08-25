import QuantumBlockEncoding.VandaeleLadderPermutation
import Mathlib.Tactic

/-!
# Naive reverse ladder refines closed-form Equation (5)

The authoritative Definition-2.3 target is the closed-form Equation (5), while
`VandaeleLadderPermutation.naiveLadderEquiv` is the actual reverse-order gate
permutation.  This file proves they are the same operator.

For a fixed total register and `count <= total`, the descending prefix invariant
is:

* blocks with index `< count` have already received exactly their Equation-(5)
  target toggle, evaluated on the original input;
* blocks with index `>= count` are still untouched;
* initial pivot and all fresh-control words are unchanged.

The reverse chronology is what makes the induction work: a gate at index j can
never change the preceding pivot or fresh controls needed by any lower index.
-/

namespace QuantumBlockEncoding
namespace VandaeleLadderRefinement

open VandaeleLadderContract
open VandaeleLadderPermutation

/-- Closed-form partial Equation-(5) action on indices `< count`. -/
def equationFivePrefixAction
    (localControls total count : Nat)
    (state : LadderState localControls total) :
    LadderState localControls total :=
  (state.1, fun index =>
    if done : index.val < count then
      ((state.2 index).1,
        if ladderActive state index then
          flipBit (state.2 index).2
        else (state.2 index).2)
    else state.2 index)

@[simp] theorem equationFivePrefix_zero
    (localControls total : Nat)
    (state : LadderState localControls total) :
    equationFivePrefixAction localControls total 0 state = state := by
  apply Prod.ext
  · rfl
  · funext index
    simp [equationFivePrefixAction]

/-- Once every block is included, the partial closed form is exactly Equation 5. -/
theorem equationFivePrefix_full
    (localControls total : Nat)
    (state : LadderState localControls total) :
    equationFivePrefixAction localControls total total state =
      equationFiveAction localControls total state := by
  apply Prod.ext
  · rfl
  · funext index
    simp [equationFivePrefixAction, equationFiveAction]

/-- A gate at a strictly higher block index preserves the entire lower block. -/
theorem higherStep_preserves_lower_block
    (localControls total : Nat)
    (higher lower : Fin total)
    (order : lower.val < higher.val)
    (state : LadderState localControls total) :
    (sourceLadderStep localControls total higher state).2 lower =
      state.2 lower := by
  have different : lower ≠ higher := by
    intro equal
    have values := congrArg Fin.val equal
    omega
  apply Prod.ext
  · exact sourceLadderStep_preserves_localControls
      localControls total higher lower state
  · exact
      VandaeleLadderEquationFiveSemantics.sourceLadderStep_preserves_other_target
        higher lower state different

/-- More importantly, a higher gate preserves the lower gate's Equation-(5)
activation predicate, including its preceding pivot. -/
theorem lower_ladderActive_after_higherStep
    (localControls total : Nat)
    (higher lower : Fin total)
    (order : lower.val < higher.val)
    (state : LadderState localControls total) :
    ladderActive (sourceLadderStep localControls total higher state) lower ↔
      ladderActive state lower := by
  have controls :
      ((sourceLadderStep localControls total higher state).2 lower).1 =
        (state.2 lower).1 := by
    exact congrArg Prod.fst
      (higherStep_preserves_lower_block
        localControls total higher lower order state)
  have pivot :
      previousPivot (sourceLadderStep localControls total higher state) lower =
        previousPivot state lower := by
    by_cases first : lower.val = 0
    · simp [previousPivot, first,
        sourceLadderStep_preserves_initialPivot]
    · let previous : Fin total := ⟨lower.val - 1, by omega⟩
      have previousBelow : previous.val < higher.val := by
        simp [previous]
        omega
      have previousState := higherStep_preserves_lower_block
        localControls total higher previous previousBelow state
      rw [previousPivot_nonfirst
        (sourceLadderStep localControls total higher state) lower first]
      rw [previousPivot_nonfirst state lower first]
      exact congrArg Prod.snd previousState
  unfold ladderActive
  rw [pivot, controls]

/-- One newly executed highest gate advances the partial closed-form invariant by
one block before the lower descending prefix is run. -/
theorem prefix_step_rebase
    (localControls total count : Nat)
    (bound : count < total)
    (state : LadderState localControls total) :
    equationFivePrefixAction localControls total count
        (sourceLadderStep localControls total ⟨count, bound⟩ state) =
      equationFivePrefixAction localControls total (count + 1) state := by
  let current : Fin total := ⟨count, bound⟩
  apply Prod.ext
  · simp [equationFivePrefixAction,
      sourceLadderStep_preserves_initialPivot]
  · funext query
    by_cases lower : query.val < count
    · have lowerNew : query.val < count + 1 := by omega
      have order : query.val < current.val := by
        simpa [current] using lower
      have blockPreserved := higherStep_preserves_lower_block
        localControls total current query order state
      have activePreserved := lower_ladderActive_after_higherStep
        localControls total current query order state
      simp only [equationFivePrefixAction]
      rw [dif_pos lower, dif_pos lowerNew]
      rw [blockPreserved]
      by_cases active : ladderActive state query
      · have activeAfter :
            ladderActive
              (sourceLadderStep localControls total current state) query :=
          activePreserved.mpr active
        have activeAfterRaw :
            ladderActive
              (sourceLadderStep localControls total ⟨count, bound⟩ state) query := by
          simpa [current] using activeAfter
        rw [if_pos activeAfterRaw, if_pos active]
      · have inactiveAfter :
            ¬ ladderActive
              (sourceLadderStep localControls total current state) query := by
          intro after
          exact active (activePreserved.mp after)
        have inactiveAfterRaw :
            ¬ ladderActive
              (sourceLadderStep localControls total ⟨count, bound⟩ state) query := by
          simpa [current] using inactiveAfter
        rw [if_neg inactiveAfterRaw, if_neg active]
    · by_cases same : query.val = count
      · have queryEq : query = current := by
          apply Fin.ext
          simpa [current] using same
        subst query
        have notOld : ¬ current.val < count := by
          simp [current]
        have doneNew : current.val < count + 1 := by
          simp [current]
        have target := sourceLadderStep_target
          localControls total current state
        have controls := sourceLadderStep_preserves_localControls
          localControls total current current state
        simp only [equationFivePrefixAction]
        rw [dif_neg notOld, dif_pos doneNew]
        apply Prod.ext
        · exact controls
        · exact target
      · have different : query ≠ current := by
          intro equal
          have values := congrArg Fin.val equal
          simp [current] at values
          exact same values
        have controls := sourceLadderStep_preserves_localControls
          localControls total current query state
        have target :=
          VandaeleLadderEquationFiveSemantics.sourceLadderStep_preserves_other_target
            current query state different
        have blockPreserved :
            (sourceLadderStep localControls total current state).2 query =
              state.2 query := by
          apply Prod.ext
          · exact controls
          · exact target
        have notDoneOld : ¬ query.val < count := by omega
        have notDoneNew : ¬ query.val < count + 1 := by omega
        simp only [equationFivePrefixAction]
        rw [dif_neg notDoneOld, dif_neg notDoneNew]
        exact blockPreserved

/-- Descending gate permutation realizes the partial Equation-(5) action. -/
theorem descendingLadderEquiv_eq_prefix
    (localControls total count : Nat)
    (bound : count ≤ total)
    (state : LadderState localControls total) :
    descendingLadderEquiv localControls total count bound state =
      equationFivePrefixAction localControls total count state := by
  induction count generalizing state with
  | zero =>
      simp [descendingLadderEquiv, equationFivePrefix_zero]
  | succ count induction =>
      have strict : count < total := by omega
      let current : Fin total := ⟨count, strict⟩
      change
        descendingLadderEquiv localControls total count (by omega)
          (ladderStepEquiv localControls total current state) = _
      rw [induction]
      change
        equationFivePrefixAction localControls total count
          (sourceLadderStep localControls total current state) = _
      exact prefix_step_rebase localControls total count strict state

/-- The actual naive ladder permutation directly inhabits the authoritative
Equation-(5) source contract. -/
theorem naiveLadderEquiv_spec
    (localControls steps : Nat) :
    LadderSpec localControls steps (naiveLadderEquiv localControls steps) := by
  intro state
  have forward := descendingLadderEquiv_eq_prefix
    localControls steps steps (Nat.le_refl _) state
  rw [equationFivePrefix_full] at forward
  exact forward

end VandaeleLadderRefinement
end QuantumBlockEncoding
