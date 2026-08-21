import QuantumBlockEncoding.ReversibleSchedule
import QuantumBlockEncoding.VandaeleLadderContract
import QuantumBlockEncoding.VandaeleLemma4AppendixResource
import Mathlib.Tactic

/-!
# Proof-bearing scheduled program target for Vandaele Lemma 4

Lemma 4 implements the second-order ladder `L_2^(n)` with O(n) CCX gates,
O(log n) depth, and n clean ancilla qubits. Appendix A.1 introduces those
workspace qubits through the clean compute/use/uncompute identity (58).

This module fixes a flat source layout and ties semantic correctness, the clean
workspace condition, the fact that every logical gate is CCX, gate count, and
parallel depth to one `ScheduledReversibleProgram` family.

The Appendix transformation itself is formalized separately in
`VandaeleLemma4AppendixResource`. The bridge theorem below shows exactly how a
concrete transformed schedule inherits the Lemma-4 uniform resource target from
Equations (60)-(62). It does not invent the cited [9] baseline schedule.

The stronger arbitrary-promise restoration property from Appendix A.3 is kept
for the Corollary-4 refinement; it is not silently folded into Lemma 4.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma4ProgramFamily

open VandaeleLadderContract
open VandaeleLemma4AppendixResource

/-- Data wires of `L_2^(steps)`. -/
def ladderDataWidth (steps : Nat) : Nat := 2 * steps + 1

/-- Lemma-4 physical workspace allocation. The Appendix uses at most this many
workspace bits; keeping all `steps` slots in the flat layout makes the register
embedding stable across recursive implementations. -/
def ladderWorkspaceWidth (steps : Nat) : Nat := steps

/-- Complete flat width including clean workspace. -/
def lemmaFourFlatWidth (steps : Nat) : Nat :=
  ladderDataWidth steps + ladderWorkspaceWidth steps

/-- Initial source pivot `x_0`. -/
def pivotWire (steps : Nat) : Fin (lemmaFourFlatWidth steps) :=
  ⟨0, by unfold lemmaFourFlatWidth ladderDataWidth ladderWorkspaceWidth; omega⟩

/-- Fresh second control of step i, source wire `x_{2i+1}`. -/
def freshControlWire (steps : Nat) (index : Fin steps) :
    Fin (lemmaFourFlatWidth steps) :=
  ⟨2 * index.val + 1, by
    have indexLt := index.isLt
    unfold lemmaFourFlatWidth ladderDataWidth ladderWorkspaceWidth
    omega⟩

/-- Target of step i, source wire `x_{2i+2}`; it is the pivot of step i+1. -/
def dataTargetWire (steps : Nat) (index : Fin steps) :
    Fin (lemmaFourFlatWidth steps) :=
  ⟨2 * index.val + 2, by
    have indexLt := index.isLt
    unfold lemmaFourFlatWidth ladderDataWidth ladderWorkspaceWidth
    omega⟩

/-- Clean workspace starts after all ladder data wires. -/
def workspaceWire (steps : Nat) (index : Fin (ladderWorkspaceWidth steps)) :
    Fin (lemmaFourFlatWidth steps) :=
  ⟨ladderDataWidth steps + index.val, by
    have indexLt := index.isLt
    unfold lemmaFourFlatWidth
    omega⟩

/-- Logical ladder state read from the data prefix of a flat basis state. -/
def extractLadderState (steps : Nat)
    (state : PrimitiveBasis (lemmaFourFlatWidth steps)) :
    LadderState 1 steps :=
  (state (pivotWire steps), fun index =>
    ((fun _ : Fin 1 => state (freshControlWire steps index)),
      state (dataTargetWire steps index)))

/-- All Lemma-4 workspace qubits are initially clean. -/
def workspaceClean (steps : Nat)
    (state : PrimitiveBasis (lemmaFourFlatWidth steps)) : Prop :=
  ∀ index : Fin (ladderWorkspaceWidth steps),
    state (workspaceWire steps index) = 0

/-- Exact clean-branch source contract. Every named data wire agrees with the
source Definition-2.3 ladder action and every workspace wire is returned to
zero. -/
def LemmaFourCleanFlatSpec (steps : Nat)
    (implementation : Equiv.Perm
      (PrimitiveBasis (lemmaFourFlatWidth steps))) : Prop :=
  ∀ state, workspaceClean steps state ->
    let expected := sourceLadderAction 1 steps (extractLadderState steps state)
    implementation state (pivotWire steps) = expected.1 ∧
    (∀ index : Fin steps,
      implementation state (freshControlWire steps index) =
        (expected.2 index).1 0 ∧
      implementation state (dataTargetWire steps index) =
        (expected.2 index).2) ∧
    ∀ index : Fin (ladderWorkspaceWidth steps),
      implementation state (workspaceWire steps index) = 0

/-- Predicate saying one reversible gate is exactly a CCX gate. -/
def IsCCX {qubits : Nat} : ReversibleGate qubits -> Prop
  | .ccx _ _ _ _ _ _ => True
  | _ => False

/-- Every gate in the scheduled program is a CCX, as required by Lemma 4. -/
def OnlyCCX {qubits : Nat} (program : ReversibleProgram qubits) : Prop :=
  ∀ gate ∈ program, IsCCX gate

/-- Final proof-bearing source family for Lemma 4. -/
structure LemmaFourScheduledFamily where
  scheduled : (steps : Nat) ->
    ScheduledReversibleProgram (lemmaFourFlatWidth steps)
  correctness : ∀ steps,
    LemmaFourCleanFlatSpec steps
      (evalReversibleProgram (scheduled steps).program)
  onlyCCX : ∀ steps, OnlyCCX (scheduled steps).program
  resources :
    LemmaFourUniformResourceTarget
      (fun steps => (scheduled steps).gateCount)
      (fun steps => (scheduled steps).depth)
      ladderWorkspaceWidth

/-- The physical workspace allocation is exactly n. -/
@[simp] theorem workspaceWidth_eq_steps (steps : Nat) :
    ladderWorkspaceWidth steps = steps := by
  rfl

/-- Resource proof is tied to the same scheduled CCX family. -/
theorem family_resources (family : LemmaFourScheduledFamily) :
    LemmaFourUniformResourceTarget
      (fun steps => (family.scheduled steps).gateCount)
      (fun steps => (family.scheduled steps).depth)
      ladderWorkspaceWidth :=
  family.resources

/-- Bridge from Appendix A.1 to a concrete Lemma-4 schedule.

The caller must provide one actual scheduled circuit family and prove that the
same circuit's gate count and depth fit Vandaele's Equation-(60)/(61)
envelopes. Once those two implementation facts are known, the Appendix resource
transformation automatically supplies the uniform O(n)/O(log n) theorem.

The family layout allocates `steps` workspace wires. This is conservative but
source-faithful because Equation (62) proves that the number actually introduced
by the transformed recursion is at most `steps`. -/
theorem resources_of_appendix_envelopes
    (scheduled : (steps : Nat) ->
      ScheduledReversibleProgram (lemmaFourFlatWidth steps))
    (baselineDepth : Nat -> Nat)
    (baseline : BaselineDepthTarget baselineDepth)
    (gateEnvelope : ∀ steps,
      (scheduled steps).gateCount <= appendixGateCount steps)
    (depthEnvelope : ∀ steps,
      (scheduled steps).depth <= appendixDepth baselineDepth steps) :
    LemmaFourUniformResourceTarget
      (fun steps => (scheduled steps).gateCount)
      (fun steps => (scheduled steps).depth)
      ladderWorkspaceWidth := by
  rcases appendix_closes_lemmaFour_resources baselineDepth baseline with
    ⟨gateConstant, depthConstant, appendixBounds⟩
  refine ⟨gateConstant, depthConstant, ?_⟩
  intro steps
  have bounds := appendixBounds steps
  constructor
  · exact (gateEnvelope steps).trans bounds.1
  · constructor
    · exact (depthEnvelope steps).trans bounds.2.1
    · simp [ladderWorkspaceWidth]

/-- Equation (62) certifies that the Appendix's actually introduced workspace
fits inside the stable physical workspace allocation used by this family. -/
theorem appendix_workspace_fits_layout (steps : Nat) :
    appendixAncillas steps <= ladderWorkspaceWidth steps := by
  simpa [ladderWorkspaceWidth] using appendixAncillas_le steps

end VandaeleLemma4ProgramFamily
end QuantumBlockEncoding
