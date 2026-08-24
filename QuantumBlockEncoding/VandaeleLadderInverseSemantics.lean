import QuantumBlockEncoding.VandaeleLadderEquationFiveSemantics
import Mathlib.Tactic

/-!
# Inverse semantics for Vandaele ladder gate lists

Each source ladder block is a multi-controlled X whose controls exclude its own
target.  Hence the block activation predicate is unchanged by executing that
block, so every source block is an involution.  Reversing an arbitrary
chronological gate list therefore gives its exact inverse.

For the source ladder `L_k^(n)`, whose forward chronology is descending
`n-1,...,0`, the adjoint/inverse chronology is ascending `0,...,n-1`.
This is the semantic fact needed to formalize Vandaele Definition 2.4,
`V_k^(n) = L_k^(n) (L_k^(n-1)† ⊗ I)`.

The final layer below transports this gate-list inverse through the already
verified refinement theorem `sourceLadder_refines_equationFive`.  Consequently
the authoritative closed-form Equation (5) is exposed as an actual permutation,
with the ascending source chronology as its certified inverse.
-/

namespace QuantumBlockEncoding
namespace VandaeleLadderInverseSemantics

open VandaeleLadderContract
open VandaeleLadderEquationFiveSemantics

/-- Executing one block does not change the pivot that controls that same block. -/
theorem sourceLadderStep_preserves_previousPivot_self
    {localControls steps : Nat}
    (index : Fin steps)
    (state : LadderState localControls steps) :
    previousPivot (sourceLadderStep localControls steps index state) index =
      previousPivot state index := by
  by_cases first : index.val = 0
  · simpa [previousPivot, first] using
      sourceLadderStep_preserves_initialPivot localControls steps index state
  · let previous : Fin steps := ⟨index.val - 1, by
      have indexLt := index.isLt
      omega⟩
    have previousLt : previous < index := by
      change previous.val < index.val
      simp [previous]
      omega
    have preserved := sourceLadderStep_preserves_other_target
      index previous state (ne_of_lt previousLt)
    simpa [previousPivot, first, previous] using preserved

/-- The controls of a source block, and therefore its activation predicate, are
unchanged by executing that same block. -/
theorem ladderActive_sourceLadderStep_self
    {localControls steps : Nat}
    (index : Fin steps)
    (state : LadderState localControls steps) :
    ladderActive (sourceLadderStep localControls steps index state) index ↔
      ladderActive state index := by
  unfold ladderActive
  rw [sourceLadderStep_preserves_previousPivot_self index state]
  rw [sourceLadderStep_preserves_localControls
    localControls steps index index state]

/-- Every individual ladder gate is an involution on computational-basis states. -/
theorem sourceLadderStep_involutive
    {localControls steps : Nat}
    (index : Fin steps) :
    Function.Involutive (sourceLadderStep localControls steps index) := by
  intro state
  by_cases active : ladderActive state index
  · have activeAfter :
        ladderActive (sourceLadderStep localControls steps index state) index :=
      (ladderActive_sourceLadderStep_self index state).2 active
    apply Prod.ext
    · simp [sourceLadderStep, active, activeAfter]
    · funext query
      apply Prod.ext
      · simp [sourceLadderStep, active, activeAfter]
      · by_cases same : query = index
        · subst query
          simp [sourceLadderStep, active, activeAfter, flipBit_flipBit]
        · simp [sourceLadderStep, active, activeAfter, same]
  · have inactiveAfter :
        ¬ ladderActive (sourceLadderStep localControls steps index state) index := by
      intro contradiction
      exact active ((ladderActive_sourceLadderStep_self index state).1 contradiction)
    simp [sourceLadderStep, active, inactiveAfter]

/-- Running a gate list and then the reversed gate list restores the state. -/
theorem runLadderSteps_reverse_after
    {localControls steps : Nat}
    (indices : List (Fin steps))
    (state : LadderState localControls steps) :
    runLadderSteps indices.reverse (runLadderSteps indices state) = state := by
  induction indices generalizing state with
  | nil => rfl
  | cons index rest induction =>
      rw [List.reverse_cons, runLadderSteps_append]
      change sourceLadderStep localControls steps index
        (runLadderSteps rest.reverse
          (runLadderSteps rest
            (sourceLadderStep localControls steps index state))) = state
      rw [induction]
      exact sourceLadderStep_involutive index state

/-- The other cancellation direction follows by applying reverse cancellation
to the reversed list. -/
theorem runLadderSteps_after_reverse
    {localControls steps : Nat}
    (indices : List (Fin steps))
    (state : LadderState localControls steps) :
    runLadderSteps indices (runLadderSteps indices.reverse state) = state := by
  simpa using
    (runLadderSteps_reverse_after (localControls := localControls)
      (steps := steps) indices.reverse state)

/-- Basis-state semantics of `L_k^(n)†`: execute the same source blocks in
ascending order. -/
def inverseSourceLadderAction (localControls steps : Nat)
    (state : LadderState localControls steps) :
    LadderState localControls steps :=
  runLadderSteps (List.finRange steps) state

/-- `L_k^(n)† L_k^(n) = I`. -/
theorem inverseSourceLadder_after_sourceLadder
    (localControls steps : Nat)
    (state : LadderState localControls steps) :
    inverseSourceLadderAction localControls steps
        (sourceLadderAction localControls steps state) = state := by
  unfold inverseSourceLadderAction sourceLadderAction
  simpa using
    (runLadderSteps_after_reverse (localControls := localControls)
      (steps := steps) (List.finRange steps) state)

/-- `L_k^(n) L_k^(n)† = I`. -/
theorem sourceLadder_after_inverseSourceLadder
    (localControls steps : Nat)
    (state : LadderState localControls steps) :
    sourceLadderAction localControls steps
        (inverseSourceLadderAction localControls steps state) = state := by
  unfold inverseSourceLadderAction sourceLadderAction
  exact runLadderSteps_reverse_after (List.finRange steps) state

/-- The ascending source chronology is a left inverse of the authoritative
closed-form Equation (5), not merely of the gate-list implementation. -/
theorem inverseSourceLadder_after_equationFive
    (localControls steps : Nat)
    (state : LadderState localControls steps) :
    inverseSourceLadderAction localControls steps
        (equationFiveAction localControls steps state) = state := by
  rw [← sourceLadder_refines_equationFive localControls steps state]
  exact inverseSourceLadder_after_sourceLadder localControls steps state

/-- The ascending source chronology is also a right inverse of the authoritative
closed-form Equation (5). -/
theorem equationFive_after_inverseSourceLadder
    (localControls steps : Nat)
    (state : LadderState localControls steps) :
    equationFiveAction localControls steps
        (inverseSourceLadderAction localControls steps state) = state := by
  rw [← sourceLadder_refines_equationFive localControls steps
    (inverseSourceLadderAction localControls steps state)]
  exact sourceLadder_after_inverseSourceLadder localControls steps state

/-- Equation (5) packaged as a certified permutation.  This is the reusable
interface for downstream `L_k^(n)†`, `V_k^(n)`, comparator, incrementer, and
adder semantics: users of this node no longer need to unfold the source gate
chronology. -/
def equationFiveEquiv (localControls steps : Nat) :
    Equiv.Perm (LadderState localControls steps) where
  toFun := equationFiveAction localControls steps
  invFun := inverseSourceLadderAction localControls steps
  left_inv := inverseSourceLadder_after_equationFive localControls steps
  right_inv := equationFive_after_inverseSourceLadder localControls steps

@[simp] theorem equationFiveEquiv_apply
    (localControls steps : Nat)
    (state : LadderState localControls steps) :
    equationFiveEquiv localControls steps state =
      equationFiveAction localControls steps state := by
  rfl

@[simp] theorem equationFiveEquiv_symm_apply
    (localControls steps : Nat)
    (state : LadderState localControls steps) :
    (equationFiveEquiv localControls steps).symm state =
      inverseSourceLadderAction localControls steps state := by
  rfl

end VandaeleLadderInverseSemantics
end QuantumBlockEncoding
