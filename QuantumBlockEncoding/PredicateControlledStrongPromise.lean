import QuantumBlockEncoding.ControlledStrongPromise

/-!
# Predicate-controlled strong promise gates

A single Boolean control is enough for the local Lemma 8 statement, but
Vandaele Lemma 7 uses k quantum control qubits.  Their computational-basis
semantics is simply a Boolean predicate on a finite key register: the promise
gate is activated exactly when all k controls are one.

This module generalizes the shared controlled-strong-promise interface from one
Boolean to an arbitrary key type and predicate.  It is intentionally arithmetic
agnostic and can be reused by later State Preparation / Block Encoding promise
constructions.
-/

namespace QuantumBlockEncoding
namespace PredicateControlledStrongPromise

open PromiseGateOptimization

/-- Exact semantic contract for a predicate-controlled strong promise gate. -/
def PredicateControlledStrongPromiseSpec {κ ρ α : Type*}
    (active : κ → Bool) (cleanPromise : ρ)
    (implementation : Equiv.Perm (κ × ρ × α))
    (target : Equiv.Perm α) : Prop :=
  (∀ key value, active key = false →
    implementation (key, cleanPromise, value) =
      (key, cleanPromise, value)) ∧
  (∀ key value, active key = true →
    implementation (key, cleanPromise, value) =
      (key, cleanPromise, target value)) ∧
  (∀ key promise value,
    (implementation (key, promise, value)).1 = key ∧
    (implementation (key, promise, value)).2.1 = promise)

/-- Control an arbitrary promise-register implementation by a Boolean predicate
on a separate key register. -/
def predicateControlledPromiseEquiv {κ ρ α : Type*}
    (active : κ → Bool)
    (implementation : Equiv.Perm (ρ × α)) :
    Equiv.Perm (κ × ρ × α) where
  toFun state :=
    if active state.1 then
      (state.1, implementation state.2)
    else state
  invFun state :=
    if active state.1 then
      (state.1, implementation.symm state.2)
    else state
  left_inv state := by
    rcases state with ⟨key, promise, value⟩
    cases condition : active key <;> simp [condition]
  right_inv state := by
    rcases state with ⟨key, promise, value⟩
    cases condition : active key <;> simp [condition]

/-- Predicate control preserves the strong-promise guarantee. -/
theorem predicateControlledPromise_of_strong
    {κ ρ α : Type*} (active : κ → Bool)
    (cleanPromise : ρ)
    (implementation : Equiv.Perm (ρ × α))
    (target : Equiv.Perm α)
    (strong : StrongPromiseSpec cleanPromise implementation target) :
    PredicateControlledStrongPromiseSpec active cleanPromise
      (predicateControlledPromiseEquiv active implementation) target := by
  constructor
  · intro key value inactive
    simp [predicateControlledPromiseEquiv, inactive]
  · constructor
    · intro key value enabled
      change
        (key, implementation (cleanPromise, value)) =
          (key, cleanPromise, target value)
      rw [strong.1 value]
    · intro key promise value
      by_cases enabled : active key = true
      · simp [predicateControlledPromiseEquiv, enabled, strong.2 promise value]
      · have inactive : active key = false := by
          cases condition : active key <;> simp_all
        simp [predicateControlledPromiseEquiv, inactive]

/-- Key and promise restoration are unconditional. -/
theorem predicateControlledPromise_restores
    {κ ρ α : Type*} (active : κ → Bool)
    (cleanPromise : ρ)
    (implementation : Equiv.Perm (ρ × α))
    (target : Equiv.Perm α)
    (strong : StrongPromiseSpec cleanPromise implementation target)
    (key : κ) (promise : ρ) (value : α) :
    (predicateControlledPromiseEquiv active implementation
      (key, promise, value)).1 = key ∧
    (predicateControlledPromiseEquiv active implementation
      (key, promise, value)).2.1 = promise := by
  exact (predicateControlledPromise_of_strong
    active cleanPromise implementation target strong).2.2 key promise value

end PredicateControlledStrongPromise
end QuantumBlockEncoding
