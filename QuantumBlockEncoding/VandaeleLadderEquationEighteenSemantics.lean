import QuantumBlockEncoding.VandaeleLadderVSemantics
import Mathlib.Tactic

/-!
# Vandaele Equation (18): source factorization of `V₂`

Immediately after Definition 2.4, the comparator section uses the source-circuit
factorization of `V₂^(n)`: an `L₂^(n-1)†` ladder, one middle CCX gate, and an
`L₂^(n-1)` ladder.  In the basis-state chronology this is not a new semantic
assumption.  It follows by splitting the full descending chronology for
`L_k^(n)` into its final source block followed by the embedded prefix ladder.

This file proves that factorization first for arbitrary positive order
`k = localControls + 1`, where the middle gate is `C^k X`, and then specializes
to `localControls = 1`, where the middle source gate is exactly CCX and the
result is the paper's Equation (18).
-/

namespace QuantumBlockEncoding
namespace VandaeleLadderEquationEighteenSemantics

open VandaeleLadderContract
open VandaeleLadderEquationFiveSemantics
open VandaeleLadderInverseSemantics
open VandaeleLadderVSemantics

/-- Descending chronology for an `n = prefixSteps + 1` ladder starts with the
last block and then runs the embedded prefix in descending order. -/
theorem fullDescendingIndices_succ
    (prefixSteps : Nat) :
    (List.finRange (prefixSteps + 1)).reverse =
      Fin.last prefixSteps :: (embeddedPrefixIndices prefixSteps).reverse := by
  simp [List.finRange_succ, embeddedPrefixIndices]

/-- Full-register implementation of the forward `L_k^(n-1) ⊗ I` factor. -/
def prefixSourceLadderAction (localControls prefixSteps : Nat)
    (state : LadderState localControls (prefixSteps + 1)) :
    LadderState localControls (prefixSteps + 1) :=
  runLadderSteps (embeddedPrefixIndices prefixSteps).reverse state

/-- Restricting the embedded forward prefix factor gives exactly the previously
verified source action of `L_k^(n-1)`. -/
theorem restrictPrefixState_prefixSourceLadder
    (localControls prefixSteps : Nat)
    (state : LadderState localControls (prefixSteps + 1)) :
    restrictPrefixState (prefixSourceLadderAction localControls prefixSteps state) =
      sourceLadderAction localControls prefixSteps (restrictPrefixState state) := by
  unfold prefixSourceLadderAction sourceLadderAction embeddedPrefixIndices
  simpa using
    (restrictPrefixState_runLadderSteps_map_castSucc
      ((List.finRange prefixSteps).reverse) state)

/-- The forward embedded prefix factor also acts identically on the complete
last fresh block. -/
theorem prefixSourceLadder_preserves_lastBlock
    (localControls prefixSteps : Nat)
    (state : LadderState localControls (prefixSteps + 1)) :
    (prefixSourceLadderAction localControls prefixSteps state).2
        (Fin.last prefixSteps) =
      state.2 (Fin.last prefixSteps) := by
  unfold prefixSourceLadderAction
  apply Prod.ext
  · exact runLadderSteps_preserves_localControls
      (embeddedPrefixIndices prefixSteps).reverse state (Fin.last prefixSteps)
  · exact runLadderSteps_preserves_target_of_avoids
      (embeddedPrefixIndices prefixSteps).reverse state (Fin.last prefixSteps) (by
        intro step stepMem
        have stepMemForward : step ∈ embeddedPrefixIndices prefixSteps := by
          simpa using stepMem
        exact embeddedPrefixIndices_avoids_last prefixSteps step stepMemForward)

/-- Source chronology factorization for a full ladder:

`L_k^(n) = (L_k^(n-1) ⊗ I) · middle(C^k X)`

when read as basis-state execution from right to left. -/
theorem sourceLadderAction_succ_factorization
    (localControls prefixSteps : Nat)
    (state : LadderState localControls (prefixSteps + 1)) :
    sourceLadderAction localControls (prefixSteps + 1) state =
      prefixSourceLadderAction localControls prefixSteps
        (sourceLadderStep localControls (prefixSteps + 1)
          (Fin.last prefixSteps) state) := by
  unfold sourceLadderAction prefixSourceLadderAction
  rw [fullDescendingIndices_succ]
  rfl

/-- General source factorization of Definition 2.4.  The prefix adjoint runs
first, then the one new middle `C^k X`, then the forward prefix ladder. -/
theorem vandaeleVAction_source_factorization
    (localControls prefixSteps : Nat)
    (state : LadderState localControls (prefixSteps + 1)) :
    vandaeleVAction localControls prefixSteps state =
      prefixSourceLadderAction localControls prefixSteps
        (sourceLadderStep localControls (prefixSteps + 1)
          (Fin.last prefixSteps)
          (prefixInverseSourceLadderAction localControls prefixSteps state)) := by
  rw [← sourceLadder_prefixInverse_refines_vandaeleV
    localControls prefixSteps state]
  exact sourceLadderAction_succ_factorization localControls prefixSteps
    (prefixInverseSourceLadderAction localControls prefixSteps state)

/-- Paper Equation (18), specialized to `k = 2`.  Since
`localControls = 1`, the middle source step has the preceding pivot plus one
fresh local control and is therefore exactly a CCX gate. -/
def equationEighteenAction (prefixSteps : Nat)
    (state : LadderState 1 (prefixSteps + 1)) :
    LadderState 1 (prefixSteps + 1) :=
  prefixSourceLadderAction 1 prefixSteps
    (sourceLadderStep 1 (prefixSteps + 1) (Fin.last prefixSteps)
      (prefixInverseSourceLadderAction 1 prefixSteps state))

/-- Equation (18) exactly implements the Definition-2.4 `V₂^(n)` permutation. -/
theorem equationEighteen_refines_vandaeleV2
    (prefixSteps : Nat)
    (state : LadderState 1 (prefixSteps + 1)) :
    equationEighteenAction prefixSteps state =
      vandaeleVAction 1 prefixSteps state := by
  exact (vandaeleVAction_source_factorization 1 prefixSteps state).symm

/-- Equation (18), packaged as the same certified permutation as Definition 2.4.
The theorem above is the source-circuit refinement certificate connecting the
three-factor gate chronology to this abstract reversible interface. -/
def equationEighteenEquiv (prefixSteps : Nat) :
    Equiv.Perm (LadderState 1 (prefixSteps + 1)) :=
  vandaeleVEquiv 1 prefixSteps

@[simp] theorem equationEighteenEquiv_apply
    (prefixSteps : Nat)
    (state : LadderState 1 (prefixSteps + 1)) :
    equationEighteenEquiv prefixSteps state =
      equationEighteenAction prefixSteps state := by
  rw [equationEighteen_refines_vandaeleV2]
  rfl

end VandaeleLadderEquationEighteenSemantics
end QuantumBlockEncoding
