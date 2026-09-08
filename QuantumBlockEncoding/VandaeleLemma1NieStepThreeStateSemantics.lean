import QuantumBlockEncoding.VandaeleLemma1NiePublicLogic
import Mathlib.Tactic

/-!
# Whole-state semantics of Figure-3 Step 3

The fixed-gadget layer already proves the target equation of the embedded
`C^3 X` and restoration of its borrowed `I₂` wire.  For compute/use/uncompute
reasoning we need the stronger extensional fact that Step 3 changes *no* parent
wire except the outer target `T`.

This module derives that fact from the same certified k=3 gadget.  Wires outside
the embedding are handled by embedding noninterference; wires inside the
embedding use the native `LemmaOneFlatSpec 3` control/dirty clauses.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma1NieStepThreeStateSemantics

open VandaeleLemma1ProgramFamily
open VandaeleLemma1NieLayout
open VandaeleLemma1NieFixedSemantics
open VandaeleLemma1NiePublicLogic
open VandaeleLemma1BorrowedNCTGadgets
open ReversibleWireEmbedding
open ScheduledWireEmbedding

/-- Every parent wire other than `T` is pointwise preserved by Figure-3 Step 3. -/
theorem stepThree_preserves_non_target
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k))
    (wire : Fin (lemmaOneFlatWidth k))
    (nonTarget : wire ≠ targetWire k) :
    evalReversibleProgram (stepThreeScheduled k four_le).program state wire =
      state wire := by
  classical
  by_cases inImage : ∃ logical, stepThreeEmbed k four_le logical = wire
  · rcases inImage with ⟨logical, image⟩
    let childState : PrimitiveBasis (lemmaOneFlatWidth 3) :=
      readEmbeddedState (stepThreeEmbed k four_le) state
    have transport :=
      readEmbeddedState_eval_mapScheduledWires
        (stepThreeEmbed k four_le) (stepThreeEmbed_injective k four_le)
        k3Scheduled state
    have atLogical := congrFun transport logical
    rcases wire_classification 3 logical with control | targetOrDirty
    · let j : Fin 3 := ⟨logical.val, control⟩
      have logicalEq : logical = controlWire 3 j := by
        apply Fin.ext
        rfl
      have controlSpec := (k3_correct childState).1 j
      calc
        evalReversibleProgram (stepThreeScheduled k four_le).program state wire =
            evalReversibleProgram (stepThreeScheduled k four_le).program state
              (stepThreeEmbed k four_le logical) := by rw [image]
        _ = evalReversibleProgram k3Scheduled.program childState logical := by
          simpa [stepThreeScheduled, childState, readEmbeddedState] using atLogical
        _ = childState logical := by
          rw [logicalEq]
          exact controlSpec
        _ = state wire := by
          simp [childState, readEmbeddedState, image]
    · rcases targetOrDirty with target | dirty
      · have wireTarget : wire = targetWire k := by
          rw [← image, target, stepThreeEmbed_target]
        exact (nonTarget wireTarget).elim
      · have dirtySpec := (k3_correct childState).2.2
        calc
          evalReversibleProgram (stepThreeScheduled k four_le).program state wire =
              evalReversibleProgram (stepThreeScheduled k four_le).program state
                (stepThreeEmbed k four_le logical) := by rw [image]
          _ = evalReversibleProgram k3Scheduled.program childState logical := by
            simpa [stepThreeScheduled, childState, readEmbeddedState] using atLogical
          _ = childState logical := by
            rw [dirty]
            exact dirtySpec
          _ = state wire := by
            simp [childState, readEmbeddedState, image]
  · rw [stepThreeScheduled, mapScheduledWires_program]
    exact eval_mapProgramWires_outside
      (stepThreeEmbed k four_le) (stepThreeEmbed_injective k four_le)
      k3Scheduled.program state wire
      (fun logical equal => inImage ⟨logical, equal⟩)

/-- Extensional source-facing semantics: Step 3 is exactly a conditional X on
`T`, with activation predicate `I₁ ∧ I₃ ∧ A`. -/
theorem stepThree_state_action
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    evalReversibleProgram (stepThreeScheduled k four_le).program state =
      if StepThreeActive k four_le state then
        xBasisAction (targetWire k) state
      else state := by
  classical
  funext wire
  by_cases hit : wire = targetWire k
  · subst wire
    rw [stepThree_target_action]
    by_cases active : StepThreeActive k four_le state <;>
      simp [active, xBasisAction]
  · rw [stepThree_preserves_non_target k four_le state wire hit]
    by_cases active : StepThreeActive k four_le state <;>
      simp [active, xBasisAction, hit]

end VandaeleLemma1NieStepThreeStateSemantics
end QuantumBlockEncoding