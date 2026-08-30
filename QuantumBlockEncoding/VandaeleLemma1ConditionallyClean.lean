import QuantumBlockEncoding.VandaeleLemma1Contract
import Mathlib.Tactic

/-!
# Conditionally-clean control wires for the Nie/Vandaele recursion

The logarithmic-depth multi-controlled-X construction used by Vandaele Lemma 1
relies on a subtle intermediate invariant from Nie et al.: some input wires are
not globally clean ancillas.  Instead, after an AND flag certifies that a
selected block of controls was all one, unconditional X gates on those selected
controls make them zero *on the certified branch*.  Those zero wires can then be
borrowed as conditionally-clean workspace by recursive subcalls and restored
later.

This module formalizes that semantic invariant without yet claiming the full
recursive `{X,CX,CCX}` schedule.  In particular, `ConditionallyCleanSelected`
contains the branch implication explicitly; it must never be simplified to an
unconditional clean-ancilla statement.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma1ConditionallyClean

/-- A wire lies in an injectively selected control block. -/
def selectedBy {m k : Nat} (select : Fin m ↪ Fin k) (wire : Fin k) : Prop :=
  ∃ index, select index = wire

local instance instDecidableSelectedBy {m k : Nat}
    (select : Fin m ↪ Fin k) (wire : Fin k) :
    Decidable (selectedBy select wire) := by
  unfold selectedBy
  infer_instance

/-- Flip exactly the selected controls and leave every other control untouched.
This is the simultaneous basis action of the source X-normalization layer. -/
def flipSelectedAction {m k : Nat} (select : Fin m ↪ Fin k)
    (state : PrimitiveBasis k) : PrimitiveBasis k :=
  fun wire =>
    if selectedBy select wire then flipBit (state wire) else state wire

/-- The selected-control X layer is self-inverse. -/
theorem flipSelectedAction_involutive {m k : Nat}
    (select : Fin m ↪ Fin k) :
    Function.Involutive (flipSelectedAction select) := by
  intro state
  funext wire
  by_cases selected : selectedBy select wire
  · simp [flipSelectedAction, selected]
  · simp [flipSelectedAction, selected]

/-- Exact reversible permutation for the selected-control X layer. -/
def flipSelectedEquiv {m k : Nat} (select : Fin m ↪ Fin k) :
    Equiv.Perm (PrimitiveBasis k) where
  toFun := flipSelectedAction select
  invFun := flipSelectedAction select
  left_inv := flipSelectedAction_involutive select
  right_inv := flipSelectedAction_involutive select

/-- Every selected control is flipped exactly once. -/
@[simp] theorem flipSelectedAction_selected {m k : Nat}
    (select : Fin m ↪ Fin k) (state : PrimitiveBasis k) (index : Fin m) :
    flipSelectedAction select state (select index) =
      flipBit (state (select index)) := by
  have selected : selectedBy select (select index) := ⟨index, rfl⟩
  simp [flipSelectedAction, selected]

/-- Unselected controls are untouched. -/
theorem flipSelectedAction_unselected {m k : Nat}
    (select : Fin m ↪ Fin k) (state : PrimitiveBasis k) (wire : Fin k)
    (unselected : ¬ selectedBy select wire) :
    flipSelectedAction select state wire = state wire := by
  simp [flipSelectedAction, unselected]

/-- The selected block was all one before the normalization X layer. -/
def SelectedAllOne {m k : Nat} (select : Fin m ↪ Fin k)
    (state : PrimitiveBasis k) : Prop :=
  ∀ index, state (select index) = 1

/-- A computed flag certifies the only implication needed for conditional
cleanliness.  The full source AND computation will later provide this witness. -/
def FlagCertifiesSelectedAllOne {m k : Nat} (select : Fin m ↪ Fin k)
    (state : PrimitiveBasis k) (flag : Bool) : Prop :=
  flag = true → SelectedAllOne select state

/-- Selected wires are clean only on the branch where the flag is true. -/
def ConditionallyCleanSelected {m k : Nat} (select : Fin m ↪ Fin k)
    (state : PrimitiveBasis k) (flag : Bool) : Prop :=
  flag = true → ∀ index, state (select index) = 0

/-- Core Nie invariant: if the flag certifies that the selected inputs were all
one, then the unconditional X-normalization layer exposes those same inputs as
zero wires on the flag=true branch. -/
theorem certified_flag_exposes_conditionally_clean
    {m k : Nat} (select : Fin m ↪ Fin k)
    (state : PrimitiveBasis k) (flag : Bool)
    (certifies : FlagCertifiesSelectedAllOne select state flag) :
    ConditionallyCleanSelected select (flipSelectedAction select state) flag := by
  intro flagTrue index
  rw [flipSelectedAction_selected]
  have one : state (select index) = 1 := certifies flagTrue index
  simp [one, flipBit]

/-- If the certifying branch is active, every selected wire is explicitly zero
after normalization. -/
theorem selected_zero_on_certified_branch
    {m k : Nat} (select : Fin m ↪ Fin k)
    (state : PrimitiveBasis k) (flag : Bool)
    (certifies : FlagCertifiesSelectedAllOne select state flag)
    (flagTrue : flag = true) (index : Fin m) :
    flipSelectedAction select state (select index) = 0 := by
  exact certified_flag_exposes_conditionally_clean
    select state flag certifies flagTrue index

/-- Outside the certified branch no cleanliness claim is made.  This theorem
records that the implication is intentionally vacuous for a false flag. -/
@[simp] theorem conditionallyClean_false {m k : Nat}
    (select : Fin m ↪ Fin k) (state : PrimitiveBasis k) :
    ConditionallyCleanSelected select state false := by
  simp [ConditionallyCleanSelected]

/-- Normalizing twice restores the complete original control register.  This is
the semantic cleanup fact used when the recursive computation is uncomputed. -/
@[simp] theorem flipSelectedEquiv_twice {m k : Nat}
    (select : Fin m ↪ Fin k) (state : PrimitiveBasis k) :
    flipSelectedEquiv select (flipSelectedEquiv select state) = state := by
  exact flipSelectedAction_involutive select state

end VandaeleLemma1ConditionallyClean
end QuantumBlockEncoding
