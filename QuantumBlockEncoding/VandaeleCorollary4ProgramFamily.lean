import QuantumBlockEncoding.VandaeleEquation58PromiseGadget
import QuantumBlockEncoding.VandaeleLemma4ProgramFamily

/-!
# Proof-bearing strong-promise ladder target for Vandaele Corollary 4

Appendix A.3 observes that the clean ancillas introduced by Equation (58) in the
Lemma-4 construction occur only in compute/use/uncompute patterns. The local
Equation-(58) gadget is formalized in `VandaeleEquation58PromiseGadget`: its
promise bit is restored for every incoming basis value, and on the clean branch
the intended higher-control target action is obtained exactly.

At the full-circuit level Corollary 4 requires both facts to refer to the *same*
transformed schedule:

* unconditional restoration of every allocated promise/workspace wire;
* clean-branch `L_2` semantics;
* only CCX logical gates;
* Appendix A.1 gate/depth envelopes for that same schedule.

This module records that proof boundary explicitly and turns any schedule that
meets it into the public Corollary-4 family. No independent resource object can
be paired with an unrelated semantic implementation.
-/

namespace QuantumBlockEncoding
namespace VandaeleCorollary4ProgramFamily

open VandaeleEquation58PromiseGadget
open VandaeleLadderContract
open VandaeleLemma4AppendixResource
open VandaeleLemma4ProgramFamily

/-- Strong-promise refinement of the Lemma-4 flat contract. -/
def LemmaFourStrongPromiseFlatSpec (steps : Nat)
    (implementation : Equiv.Perm
      (PrimitiveBasis (lemmaFourFlatWidth steps))) : Prop :=
  (∀ state, ∀ index : Fin (ladderWorkspaceWidth steps),
    implementation state (workspaceWire steps index) =
      state (workspaceWire steps index)) ∧
  ∀ state, workspaceClean steps state ->
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
  scheduled : (steps : Nat) ->
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

/-- The local Equation-(58) theorem used by Appendix A.3. This named bridge
keeps the full-circuit Corollary-4 contract connected to the actual gadget proof
rather than to a prose citation. -/
theorem equation58_local_promise_restoration :
    PromiseGateOptimization.StrongPromiseSpec
      0 promiseImplementation cleanTargetEquiv :=
  equation58_strongPromise

/-- Proof-bearing realization boundary for the *transformed* Appendix schedule.

The schedule itself is the remaining implementation object inherited from the
[9] baseline plus Vandaele's gate replacement. The fields require all semantic
and resource claims to be proved about this one schedule. -/
structure AppendixStrongScheduleRealization
    (baselineDepth : Nat -> Nat) where
  scheduled : (steps : Nat) ->
    ScheduledReversibleProgram (lemmaFourFlatWidth steps)
  strongCorrectness : ∀ steps,
    LemmaFourStrongPromiseFlatSpec steps
      (evalReversibleProgram (scheduled steps).program)
  onlyCCX : ∀ steps, OnlyCCX (scheduled steps).program
  gateEnvelope : ∀ steps,
    (scheduled steps).gateCount <= appendixGateCount steps
  depthEnvelope : ∀ steps,
    (scheduled steps).depth <= appendixDepth baselineDepth steps

/-- Appendix A.1 resource bounds plus Appendix A.3 promise restoration close a
full Corollary-4 second-order family, provided the transformed schedule supplies
the proof-bearing realization fields above. -/
def ofAppendixRealization
    (baselineDepth : Nat -> Nat)
    (baseline : BaselineDepthTarget baselineDepth)
    (realization : AppendixStrongScheduleRealization baselineDepth) :
    CorollaryFourSecondOrderScheduledFamily where
  scheduled := realization.scheduled
  strongCorrectness := realization.strongCorrectness
  onlyCCX := realization.onlyCCX
  resources := resources_of_appendix_envelopes
    realization.scheduled baselineDepth baseline
    realization.gateEnvelope realization.depthEnvelope

/-- The Corollary-4 realization and its ordinary Lemma-4 view use literally the
same scheduled programs. -/
theorem ofAppendixRealization_same_program
    (baselineDepth : Nat -> Nat)
    (baseline : BaselineDepthTarget baselineDepth)
    (realization : AppendixStrongScheduleRealization baselineDepth)
    (steps : Nat) :
    ((toLemmaFourFamily
      (ofAppendixRealization baselineDepth baseline realization)).scheduled steps).program =
      (realization.scheduled steps).program := by
  rfl

end VandaeleCorollary4ProgramFamily
end QuantumBlockEncoding
