import QuantumBlockEncoding.PromiseGateOptimization
import QuantumBlockEncoding.PredicateControlledConjugation
import Mathlib.Tactic

/-!
# Promise-gate circuit identities after Definitions 3.1 and 3.2

This module formalizes, for computational-basis promise permutations, the
source rules immediately following Vandaele Definitions 3.1 and 3.2.

* Equation (10): on the clean promise fibre, applying the same promise gate
  twice cancels whenever the target U is involutory.  This only needs the weak
  promise guarantee, because the first clean application returns the promise
  register to the clean state.
* Equation (11): the promise gate associated with U† is, by convention, the
  adjoint/inverse of the *same underlying promise unitary* associated with U.
  We show that inverse of a weak/strong promise gate has target U† and that the
  two underlying permutations cancel globally.
* Equation (12): a controlled promise gate has an external control that makes
  the entire promise implementation identity when false.  This is a different
  type of object from a promise gate whose target happens to be controlled-U.

The arbitrary-unitary matrix definitions live in `PromiseGateUnitary`; the
present file is the exact reversible specialization used by the concrete
arithmetic circuits.
-/

namespace QuantumBlockEncoding
namespace PromiseGateCircuitIdentities

open PredicateControlledConjugation
open PromiseGateOptimization

/-- Equation-(10) clean-fibre cancellation for any weak promise gate whose
target is involutory. -/
theorem equation10_clean_double_cancel
    {ρ α : Type*}
    (cleanPromise : ρ)
    (implementation : Equiv.Perm (ρ × α))
    (target : Equiv.Perm α)
    (weak : WeakPromiseSpec cleanPromise implementation target)
    (involutive : ∀ value, target (target value) = value)
    (value : α) :
    (implementation.trans implementation) (cleanPromise, value) =
      (cleanPromise, value) := by
  change implementation (implementation (cleanPromise, value)) = _
  rw [weak value]
  rw [weak (target value)]
  rw [involutive value]

/-- Inverse of a weak promise implementation is a weak promise gate for U†. -/
theorem weakPromise_inverse
    {ρ α : Type*}
    (cleanPromise : ρ)
    (implementation : Equiv.Perm (ρ × α))
    (target : Equiv.Perm α)
    (weak : WeakPromiseSpec cleanPromise implementation target) :
    WeakPromiseSpec cleanPromise implementation.symm target.symm := by
  intro value
  apply implementation.injective
  simp only [Equiv.apply_symm_apply]
  have source := weak (target.symm value)
  rw [target.apply_symm_apply] at source
  exact source.symm

/-- Inverse of a strong promise gate is strong as well. -/
theorem strongPromise_inverse
    {ρ α : Type*}
    (cleanPromise : ρ)
    (implementation : Equiv.Perm (ρ × α))
    (target : Equiv.Perm α)
    (strong : StrongPromiseSpec cleanPromise implementation target) :
    StrongPromiseSpec cleanPromise implementation.symm target.symm := by
  constructor
  · exact weakPromise_inverse cleanPromise implementation target strong.1
  · intro promise value
    have restored := strong.2
    let input := implementation.symm (promise, value)
    have source := restored input.1 input.2
    have roundtrip : implementation input = (promise, value) :=
      implementation.apply_symm_apply (promise, value)
    have firstEq : (implementation input).1 = promise :=
      congrArg Prod.fst roundtrip
    exact source.trans firstEq

/-- Equation-(11), one orientation: one promise unitary followed by the chosen
adjoint promise unitary cancels globally. -/
theorem equation11_then_adjoint
    {ρ α : Type*} (implementation : Equiv.Perm (ρ × α)) :
    implementation.trans implementation.symm = Equiv.refl (ρ × α) := by
  apply Equiv.ext
  intro state
  simp

/-- Equation-(11), the reverse orientation. -/
theorem equation11_adjoint_then
    {ρ α : Type*} (implementation : Equiv.Perm (ρ × α)) :
    implementation.symm.trans implementation = Equiv.refl (ρ × α) := by
  apply Equiv.ext
  intro state
  simp

/-- External control of a promise implementation: false means identity on
**all** promise/target fibres, true applies the selected promise unitary. -/
def controlledPromiseEquiv
    {ρ α : Type*}
    (implementation : Equiv.Perm (ρ × α)) :
    Equiv.Perm (Bool × ρ × α) where
  toFun state := if state.1 then (state.1, implementation state.2) else state
  invFun state := if state.1 then (state.1, implementation.symm state.2) else state
  left_inv state := by
    rcases state with ⟨control,promise,value⟩
    cases control <;> simp
  right_inv state := by
    rcases state with ⟨control,promise,value⟩
    cases control <;> simp

@[simp] theorem controlledPromise_false
    {ρ α : Type*}
    (implementation : Equiv.Perm (ρ × α))
    (promise : ρ) (value : α) :
    controlledPromiseEquiv implementation (false, promise, value) =
      (false, promise, value) := by
  rfl

@[simp] theorem controlledPromise_true
    {ρ α : Type*}
    (implementation : Equiv.Perm (ρ × α))
    (promise : ρ) (value : α) :
    controlledPromiseEquiv implementation (true, promise, value) =
      (true, implementation (promise, value)) := by
  rfl

/-- If the underlying promise gate is strong, externally controlling it still
preserves the promise register for every control/promise/target input. -/
theorem controlledStrongPromise_restores
    {ρ α : Type*}
    (cleanPromise : ρ)
    (implementation : Equiv.Perm (ρ × α))
    (target : Equiv.Perm α)
    (strong : StrongPromiseSpec cleanPromise implementation target)
    (control : Bool) (promise : ρ) (value : α) :
    (controlledPromiseEquiv implementation (control, promise, value)).2.1 =
      promise := by
  cases control
  · rfl
  · exact strong.2 promise value

/-- Controlled-promise clean-fibre action. -/
theorem controlledPromise_clean_action
    {ρ α : Type*}
    (cleanPromise : ρ)
    (implementation : Equiv.Perm (ρ × α))
    (target : Equiv.Perm α)
    (weak : WeakPromiseSpec cleanPromise implementation target)
    (control : Bool) (value : α) :
    controlledPromiseEquiv implementation (control, cleanPromise, value) =
      (control, cleanPromise,
        if control then target value else value) := by
  cases control
  · rfl
  · simp [weak value]

/-- A promise gate whose *target* is controlled-U has the external Boolean bit
inside the target register.  This type alias makes the distinction from
`controlledPromiseEquiv` explicit in Lean. -/
abbrev PromiseWithControlledTargetState (ρ α : Type*) := ρ × (Bool × α)

/-- Source-facing weak contract for a promise gate whose target is controlled-U.
Unlike `controlledPromiseEquiv`, this contract imposes no behavior on violated
promise fibres even when the Boolean control is false. -/
def PromiseWithControlledTargetSpec
    {ρ α : Type*}
    (cleanPromise : ρ)
    (implementation : Equiv.Perm (PromiseWithControlledTargetState ρ α))
    (target : Equiv.Perm α) : Prop :=
  WeakPromiseSpec cleanPromise implementation
    (controlledTargetEquiv target)

end PromiseGateCircuitIdentities
end QuantumBlockEncoding
