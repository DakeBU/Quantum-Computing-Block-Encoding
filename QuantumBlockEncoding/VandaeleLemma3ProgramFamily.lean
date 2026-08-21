import QuantumBlockEncoding.ReversibleSchedule
import QuantumBlockEncoding.VandaeleLadderRefinement
import Mathlib.Tactic

/-!
# Proof-bearing scheduled family for Vandaele Lemma 3

Lemma 3 cites [9] for a low-depth implementation of the first-order ladder
`L_1^(n)` with `O(n)` CX gates and `O(log n)` depth.  The cited scheduling
algorithm is external, but the semantic target is already fully formalized in
ASPBE: `naiveLadderEquiv 0 n` refines the closed-form Equation (5).

This module fixes the missing proof-bearing interface.  A valid imported or
re-proved Lemma-3 family must tie all of the following to the *same* scheduled
reversible program:

* exact `L_1^(n)` basis semantics;
* every logical gate is CX;
* linear gate count and logarithmic depth with uniform constants;
* no ancilla register is present in the flat layout.

Comparator and adder constructions can therefore depend on a concrete family
object rather than on a prose citation.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma3ProgramFamily

open VandaeleLadderContract
open VandaeleLadderPermutation
open VandaeleLadderRefinement

/-- `L_1^(steps)` acts on one initial pivot plus `steps` targets. -/
def flatWidth (steps : Nat) : Nat := steps + 1

/-- Initial pivot wire. -/
def pivotWire (steps : Nat) : Fin (flatWidth steps) :=
  ⟨0, by unfold flatWidth; omega⟩

/-- Target wire of ladder step i. -/
def targetWire (steps : Nat) (index : Fin steps) : Fin (flatWidth steps) :=
  ⟨index.val + 1, by
    have := index.isLt
    unfold flatWidth
    omega⟩

/-- Read the flat register as the first-order ladder state.  Each block has no
fresh local controls; its only source control is the preceding pivot/target. -/
def extractLadderState (steps : Nat)
    (state : PrimitiveBasis (flatWidth steps)) : LadderState 0 steps :=
  (state (pivotWire steps), fun index =>
    ((fun impossible : Fin 0 => Fin.elim0 impossible),
      state (targetWire steps index)))

/-- Exact flat source contract for Lemma 3. -/
def LemmaThreeFlatSpec (steps : Nat)
    (implementation : Equiv.Perm (PrimitiveBasis (flatWidth steps))) : Prop :=
  ∀ state,
    let expected := equationFiveAction 0 steps (extractLadderState steps state)
    implementation state (pivotWire steps) = expected.1 ∧
    ∀ index : Fin steps,
      implementation state (targetWire steps index) = (expected.2 index).2

/-- Predicate saying one reversible gate is exactly CX. -/
def IsCX {qubits : Nat} : ReversibleGate qubits -> Prop
  | .cx _ _ _ => True
  | _ => False

/-- Every gate in the program is CX. -/
def OnlyCX {qubits : Nat} (program : ReversibleProgram qubits) : Prop :=
  ∀ gate ∈ program, IsCX gate

/-- Final proof-bearing external family for Lemma 3. -/
structure LemmaThreeScheduledFamily where
  scheduled : (steps : Nat) -> ScheduledReversibleProgram (flatWidth steps)
  correctness : ∀ steps,
    LemmaThreeFlatSpec steps
      (evalReversibleProgram (scheduled steps).program)
  onlyCX : ∀ steps, OnlyCX (scheduled steps).program
  resources :
    LemmaThreeUniformResourceTarget
      (fun steps => (scheduled steps).gateCount)
      (fun steps => (scheduled steps).depth)

/-- Uniform resource evidence is read from the same scheduled family. -/
theorem family_resources (family : LemmaThreeScheduledFamily) :
    LemmaThreeUniformResourceTarget
      (fun steps => (family.scheduled steps).gateCount)
      (fun steps => (family.scheduled steps).depth) :=
  family.resources

/-- Reader-facing correctness: the flat family realizes the authoritative
Equation-(5) first-order ladder target. -/
theorem family_action
    (family : LemmaThreeScheduledFamily)
    (steps : Nat)
    (state : PrimitiveBasis (flatWidth steps)) :
    let expected := equationFiveAction 0 steps (extractLadderState steps state)
    evalReversibleProgram (family.scheduled steps).program state (pivotWire steps) =
        expected.1 ∧
      ∀ index : Fin steps,
        evalReversibleProgram (family.scheduled steps).program state
            (targetWire steps index) = (expected.2 index).2 :=
  family.correctness steps state

end VandaeleLemma3ProgramFamily
end QuantumBlockEncoding
