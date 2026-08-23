import QuantumBlockEncoding.VandaeleLadderContract
import QuantumBlockEncoding.VandaeleLadderDescendingIndices
import Mathlib.Tactic

/-!
# Vandaele Equation (5): source ladder semantics

The source ladder is executed in descending block order.  The essential reason
this realizes the closed-form Equation (5) is chronological:

* already-executed blocks have strictly larger indices;
* therefore they cannot have modified the predecessor pivot read by the current
  block;
* every source step preserves every fresh local-control word;
* after the current block is executed, all remaining lower-index blocks avoid
  its target.

Thus the activation predicate seen when block `i` executes is exactly the
Equation-(5) predicate of the original input state.
-/

namespace QuantumBlockEncoding
namespace VandaeleLadderEquationFiveSemantics

open VandaeleLadderContract
open VandaeleLadderDescendingIndices

/-- Sequential execution respects chronological list concatenation. -/
theorem runLadderSteps_append
    {localControls steps : Nat}
    (first second : List (Fin steps))
    (state : LadderState localControls steps) :
    runLadderSteps (first ++ second) state =
      runLadderSteps second (runLadderSteps first state) := by
  induction first generalizing state with
  | nil => rfl
  | cons index rest induction =>
      simp only [List.cons_append, runLadderSteps]
      exact induction (sourceLadderStep localControls steps index state)

/-- A source step can change only its own block target. -/
theorem sourceLadderStep_preserves_other_target
    {localControls steps : Nat}
    (step query : Fin steps)
    (state : LadderState localControls steps)
    (different : query ≠ step) :
    ((sourceLadderStep localControls steps step state).2 query).2 =
      (state.2 query).2 := by
  by_cases active : ladderActive state step
  · simp [sourceLadderStep, active, different]
  · simp [sourceLadderStep, active]

/-- A chronological sub-run that never targets `query` preserves its target
bit exactly. -/
theorem runLadderSteps_preserves_target_of_avoids
    {localControls steps : Nat}
    (indices : List (Fin steps))
    (state : LadderState localControls steps)
    (query : Fin steps)
    (avoids : ∀ step ∈ indices, query ≠ step) :
    ((runLadderSteps indices state).2 query).2 =
      (state.2 query).2 := by
  induction indices generalizing state with
  | nil => rfl
  | cons step rest induction =>
      have queryNeStep : query ≠ step := avoids step (by simp)
      have restAvoids : ∀ later ∈ rest, query ≠ later := by
        intro later laterMem
        exact avoids later (by simp [laterMem])
      calc
        ((runLadderSteps (step :: rest) state).2 query).2 =
            ((runLadderSteps rest
              (sourceLadderStep localControls steps step state)).2 query).2 := rfl
        _ = ((sourceLadderStep localControls steps step state).2 query).2 :=
          induction (sourceLadderStep localControls steps step state) restAvoids
        _ = (state.2 query).2 :=
          sourceLadderStep_preserves_other_target step query state queryNeStep

/-- If every executed block has larger index than `current`, the predecessor
pivot read by `current` is still its original input value. -/
theorem previousPivot_run_of_larger
    {localControls steps : Nat}
    (indices : List (Fin steps))
    (state : LadderState localControls steps)
    (current : Fin steps)
    (larger : ∀ step ∈ indices, current < step) :
    previousPivot (runLadderSteps indices state) current =
      previousPivot state current := by
  by_cases first : current.val = 0
  · simpa [previousPivot, first] using
      runLadderSteps_preserves_initialPivot indices state
  · let previous : Fin steps := ⟨current.val - 1, by
      have currentLt := current.isLt
      omega⟩
    have previousLt : previous < current := by
      change previous.val < current.val
      simp [previous]
      omega
    have avoids : ∀ step ∈ indices, previous ≠ step := by
      intro step stepMem
      exact ne_of_lt (previousLt.trans (larger step stepMem))
    have preserved :=
      runLadderSteps_preserves_target_of_avoids indices state previous avoids
    simpa [previousPivot, first, previous] using preserved

/-- A prefix consisting only of larger source indices preserves the exact
Equation-(5) activation predicate for the current block. -/
theorem ladderActive_run_of_larger
    {localControls steps : Nat}
    (indices : List (Fin steps))
    (state : LadderState localControls steps)
    (current : Fin steps)
    (larger : ∀ step ∈ indices, current < step) :
    ladderActive (runLadderSteps indices state) current ↔
      ladderActive state current := by
  unfold ladderActive
  rw [previousPivot_run_of_larger indices state current larger]
  rw [runLadderSteps_preserves_localControls indices state current]

/-- The source implementation is definitionally the run over our named
`descendingIndices` chronology. -/
theorem sourceLadderAction_eq_run_descending
    (localControls steps : Nat)
    (state : LadderState localControls steps) :
    sourceLadderAction localControls steps state =
      runLadderSteps (descendingIndices steps) state := by
  rfl

/-- Exact target formula for the full reverse-order source ladder. -/
theorem sourceLadderAction_target
    (localControls steps : Nat)
    (state : LadderState localControls steps)
    (current : Fin steps) :
    ((sourceLadderAction localControls steps state).2 current).2 =
      if ladderActive state current then
        flipBit (state.2 current).2
      else (state.2 current).2 := by
  rcases exists_descending_split current with
    ⟨earlierPart, laterPart, split, earlierLarger, laterSmaller⟩
  let before := runLadderSteps earlierPart state
  let afterCurrent := sourceLadderStep localControls steps current before

  have earlierAvoids : ∀ step ∈ earlierPart, current ≠ step := by
    intro step stepMem
    exact ne_of_lt (earlierLarger step stepMem)
  have beforeTarget :
      (before.2 current).2 = (state.2 current).2 := by
    dsimp [before]
    exact runLadderSteps_preserves_target_of_avoids
      earlierPart state current earlierAvoids
  have activeBefore :
      ladderActive before current ↔ ladderActive state current := by
    dsimp [before]
    exact ladderActive_run_of_larger
      earlierPart state current earlierLarger

  have stepTargetRaw :=
    sourceLadderStep_target localControls steps current before
  have afterCurrentTarget :
      (afterCurrent.2 current).2 =
        if ladderActive state current then
          flipBit (state.2 current).2
        else (state.2 current).2 := by
    by_cases active : ladderActive state current
    · have activeBefore' : ladderActive before current := activeBefore.mpr active
      simpa [afterCurrent, active, activeBefore', beforeTarget] using stepTargetRaw
    · have inactiveBefore : ¬ ladderActive before current := by
        intro contradiction
        exact active (activeBefore.mp contradiction)
      simpa [afterCurrent, active, inactiveBefore, beforeTarget] using stepTargetRaw

  have laterAvoids : ∀ step ∈ laterPart, current ≠ step := by
    intro step stepMem
    exact (ne_of_lt (laterSmaller step stepMem)).symm
  have laterPreserves :
      ((runLadderSteps laterPart afterCurrent).2 current).2 =
        (afterCurrent.2 current).2 :=
    runLadderSteps_preserves_target_of_avoids
      laterPart afterCurrent current laterAvoids

  have execution :
      sourceLadderAction localControls steps state =
        runLadderSteps laterPart afterCurrent := by
    rw [sourceLadderAction_eq_run_descending, split,
      runLadderSteps_append]
    rfl
  rw [execution]
  exact laterPreserves.trans afterCurrentTarget

/-- The naive reverse-order ladder realization exactly refines the closed-form
source Equation (5), on every computational-basis ladder state. -/
theorem sourceLadder_refines_equationFive
    (localControls steps : Nat) :
    NaiveLadderRefinement localControls steps := by
  intro state
  apply Prod.ext
  · change (sourceLadderAction localControls steps state).1 = state.1
    exact sourceLadder_preserves_initialPivot localControls steps state
  · funext index
    apply Prod.ext
    · change ((sourceLadderAction localControls steps state).2 index).1 =
        (state.2 index).1
      exact sourceLadder_preserves_localControls localControls steps state index
    · change ((sourceLadderAction localControls steps state).2 index).2 =
        if ladderActive state index then
          flipBit (state.2 index).2
        else (state.2 index).2
      exact sourceLadderAction_target localControls steps state index

/-- Reader-facing alias matching the contract name. -/
theorem naiveLadderRefinement
    (localControls steps : Nat) :
    NaiveLadderRefinement localControls steps :=
  sourceLadder_refines_equationFive localControls steps

end VandaeleLadderEquationFiveSemantics
end QuantumBlockEncoding
