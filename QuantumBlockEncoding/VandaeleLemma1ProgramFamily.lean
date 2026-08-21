import QuantumBlockEncoding.ReversibleSchedule
import QuantumBlockEncoding.VandaeleLemma1Contract
import Mathlib.Tactic

/-!
# Proof-bearing scheduled program target for Vandaele Lemma 1

The source resource theorem for `C^k X` is useful downstream only when gate
count, parallel depth, dirty-workspace behavior, and exact basis semantics refer
to the same circuit family.

This module fixes the flat wire order

`[ k controls | target | dirty ]`

and packages the final proof obligation as a family of
`ScheduledReversibleProgram`s.  No implementation is constructed here; the
cited Nie-et-al. construction or a later ASPBE re-proof must inhabit this
interface.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma1ProgramFamily

open VandaeleLemma1Contract

/-- Total wire count including the one source dirty bit. -/
def lemmaOneFlatWidth (k : Nat) : Nat := k + 2

/-- External control wires occupy the low prefix. -/
def controlWire (k : Nat) (wire : Fin k) : Fin (lemmaOneFlatWidth k) :=
  ⟨wire.val, by unfold lemmaOneFlatWidth; omega⟩

/-- Target wire immediately follows the controls. -/
def targetWire (k : Nat) : Fin (lemmaOneFlatWidth k) :=
  ⟨k, by unfold lemmaOneFlatWidth; omega⟩

/-- Unknown dirty workspace is the final wire. -/
def dirtyWire (k : Nat) : Fin (lemmaOneFlatWidth k) :=
  ⟨k + 1, by unfold lemmaOneFlatWidth; omega⟩

/-- All flat control wires are one. -/
def allFlatControlsOne (k : Nat)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) : Prop :=
  ∀ wire : Fin k, state (controlWire k wire) = 1

/-- Exact flat basis contract for the source `C^k X` implementation with one
unknown dirty workspace bit. -/
def LemmaOneFlatSpec (k : Nat)
    (implementation : Equiv.Perm (PrimitiveBasis (lemmaOneFlatWidth k))) : Prop :=
  ∀ state,
    (∀ wire : Fin k,
      implementation state (controlWire k wire) =
        state (controlWire k wire)) ∧
    implementation state (targetWire k) =
      if allFlatControlsOne k state then
        flipBit (state (targetWire k))
      else state (targetWire k) ∧
    implementation state (dirtyWire k) = state (dirtyWire k)

/-- Every wire in the flat layout is either a control, the target, or the dirty
workspace.  This is useful when later implementations prove extensional
correctness. -/
theorem wire_classification
    (k : Nat) (wire : Fin (lemmaOneFlatWidth k)) :
    wire.val < k ∨ wire = targetWire k ∨ wire = dirtyWire k := by
  unfold lemmaOneFlatWidth at wire
  by_cases control : wire.val < k
  · exact Or.inl control
  · right
    by_cases target : wire.val = k
    · left
      apply Fin.ext
      exact target
    · right
      apply Fin.ext
      omega

/-- Final source implementation interface for Lemma 1. -/
structure LemmaOneScheduledFamily where
  scheduled : (k : Nat) → ScheduledReversibleProgram (lemmaOneFlatWidth k)
  correctness : ∀ k,
    LemmaOneFlatSpec k
      (evalReversibleProgram (scheduled k).program)
  resources :
    LemmaOneUniformResourceTarget
      (fun k => (scheduled k).gateCount)
      (fun k => (scheduled k).depth)
      (fun _ => 1)

/-- Resource evidence in the proof-bearing family is definitionally tied to the
same scheduled circuit used by the semantic proof. -/
theorem family_resource_functions
    (family : LemmaOneScheduledFamily) :
    LemmaOneUniformResourceTarget
      (fun k => (family.scheduled k).gateCount)
      (fun k => (family.scheduled k).depth)
      (fun _ => 1) :=
  family.resources

end VandaeleLemma1ProgramFamily
end QuantumBlockEncoding
