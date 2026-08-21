import QuantumBlockEncoding.VandaeleLemma4ProgramFamily

/-!
# Proof-bearing strong-promise ladder target for Vandaele Corollary 4

Appendix A.3 observes that the clean ancillas introduced by Equation (58) in the
Lemma-4 construction occur only in compute/use/uncompute patterns.  The final
uncompute does not depend on the workspace's initial value.  Reinterpreting the
workspace as a promise register therefore gives a strong promise gate:

* the promise register is preserved for every basis input;
* on the all-zero promise branch, the data register undergoes the source ladder;
* the same low-depth scheduled circuit and asymptotic resource bounds are used.

This file records the second-order specialization required by Lemma 7.  The
paper's general `L_k` Corollary-4 statement can later be layered on top of the
same interface and Corollary 1.
-/

namespace QuantumBlockEncoding
namespace VandaeleCorollary4ProgramFamily

open VandaeleLadderContract
open VandaeleLemma4ProgramFamily

/-- Strong-promise refinement of the Lemma-4 flat contract. -/
def LemmaFourStrongPromiseFlatSpec (steps : Nat)
    (implementation : Equiv.Perm
      (PrimitiveBasis (lemmaFourFlatWidth steps))) : Prop :=
  (∀ state, ∀ index : Fin (ladderWorkspaceWidth steps),
    implementation state (workspaceWire steps index) =
      state (workspaceWire steps index)) ∧
  ∀ state, workspaceClean steps state →
    let expected := sourceLadderAction 1 steps (extractLadderState steps state)
    implementation state (pivotWire steps) = expected.1 ∧
    (∀ index : Fin steps,
      implementation state (freshControlWire steps index) =
        (expected.2 index).1 0 ∧
      implementation state (dataTargetWire steps index) =
        (expected.2 index).2)

/-- Strong promise semantics immediately imply the clean Lemma-4 contract,
because unconditional workspace preservation returns every clean bit to zero. -/
theorem strongPromise_implies_cleanSpec
    (steps : Nat)
    (implementation : Equiv.Perm
      (PrimitiveBasis (lemmaFourFlatWidth steps)))
    (strong : LemmaFourStrongPromiseFlatSpec steps implementation) :
    LemmaFourCleanFlatSpec steps implementation := by
  intro state clean
  let expected := sourceLadderAction 1 steps (extractLadderState steps state)
  have data := strong.2 state clean
  refine ⟨data.1, data.2, ?_⟩
  intro index
  rw [strong.1 state index]
  exact clean index

/-- Proof-bearing second-order strong-promise ladder family. -/
structure CorollaryFourSecondOrderScheduledFamily where
  scheduled : (steps : Nat) →
    ScheduledReversibleProgram (lemmaFourFlatWidth steps)
  strongCorrectness : ∀ steps,
    LemmaFourStrongPromiseFlatSpec steps
      (evalReversibleProgram (scheduled steps).program)
  onlyCCX : ∀ steps, OnlyCCX (scheduled steps).program
  resources :
    LemmaFourUniformResourceTarget
      (fun steps => (scheduled steps).gateCount)
      (fun steps => (scheduled steps).depth)
      ladderWorkspaceWidth

/-- Forgetting the stronger promise guarantee recovers an ordinary Lemma-4
scheduled family on the very same programs. -/
def toLemmaFourFamily
    (family : CorollaryFourSecondOrderScheduledFamily) :
    LemmaFourScheduledFamily where
  scheduled := family.scheduled
  correctness := fun steps =>
    strongPromise_implies_cleanSpec steps _ (family.strongCorrectness steps)
  onlyCCX := family.onlyCCX
  resources := family.resources

/-- Promise restoration can be retrieved directly by downstream controlled
promise constructions. -/
theorem restores_workspace
    (family : CorollaryFourSecondOrderScheduledFamily)
    (steps : Nat)
    (state : PrimitiveBasis (lemmaFourFlatWidth steps))
    (index : Fin (ladderWorkspaceWidth steps)) :
    evalReversibleProgram (family.scheduled steps).program state
        (workspaceWire steps index) =
      state (workspaceWire steps index) :=
  (family.strongCorrectness steps).1 state index

end VandaeleCorollary4ProgramFamily
end QuantumBlockEncoding
