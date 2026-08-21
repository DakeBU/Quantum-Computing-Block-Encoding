import QuantumBlockEncoding.ControlledStrongPromise

/-!
# Predicate-controlled strong promise gates

A single Boolean control is enough for the local Lemma 8 statement, but
Vandaele Lemma 7 uses k quantum control qubits. Their computational-basis
semantics is simply a Boolean predicate on a finite key register: the promise
gate is activated exactly when all k controls are one.

This module generalizes the shared controlled-strong-promise interface from one
Boolean to an arbitrary key type and predicate.  It also proves that such gates
are closed under chronological composition: if each stage unconditionally
restores key/promise and has the declared clean-branch target action, their
composition has the composed target action and the same restoration guarantee.

That closure is deliberately source-agnostic and will be reused by Figure 9,
Figure 10, and later SP/BE promise constructions.
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

/-- Chronological composition of two predicate-controlled strong-promise gates
is again a predicate-controlled strong-promise gate, with composed target. -/
theorem trans
    {κ ρ α : Type*}
    (active : κ → Bool) (cleanPromise : ρ)
    (left right : Equiv.Perm (κ × ρ × α))
    (leftTarget rightTarget : Equiv.Perm α)
    (leftSpec :
      PredicateControlledStrongPromiseSpec
        active cleanPromise left leftTarget)
    (rightSpec :
      PredicateControlledStrongPromiseSpec
        active cleanPromise right rightTarget) :
    PredicateControlledStrongPromiseSpec
      active cleanPromise (left.trans right)
      (leftTarget.trans rightTarget) := by
  constructor
  · intro key value inactive
    change right (left (key, cleanPromise, value)) =
      (key, cleanPromise, value)
    rw [leftSpec.1 key value inactive]
    exact rightSpec.1 key value inactive
  · constructor
    · intro key value enabled
      change right (left (key, cleanPromise, value)) =
        (key, cleanPromise, rightTarget (leftTarget value))
      rw [leftSpec.2.1 key value enabled]
      exact rightSpec.2.1 key (leftTarget value) enabled
    · intro key promise value
      have leftRestores := leftSpec.2.2 key promise value
      let middle := left (key, promise, value)
      have rightRestores :=
        rightSpec.2.2 middle.1 middle.2.1 middle.2.2
      change
        (right middle).1 = key ∧
          (right middle).2.1 = promise
      constructor
      · calc
          (right middle).1 = middle.1 := rightRestores.1
          _ = key := leftRestores.1
      · calc
          (right middle).2.1 = middle.2.1 := rightRestores.2
          _ = promise := leftRestores.2

/-- Three-stage convenience wrapper. -/
theorem trans_three
    {κ ρ α : Type*}
    (active : κ → Bool) (cleanPromise : ρ)
    (first second third : Equiv.Perm (κ × ρ × α))
    (target1 target2 target3 : Equiv.Perm α)
    (spec1 : PredicateControlledStrongPromiseSpec
      active cleanPromise first target1)
    (spec2 : PredicateControlledStrongPromiseSpec
      active cleanPromise second target2)
    (spec3 : PredicateControlledStrongPromiseSpec
      active cleanPromise third target3) :
    PredicateControlledStrongPromiseSpec
      active cleanPromise ((first.trans second).trans third)
      ((target1.trans target2).trans target3) := by
  exact trans active cleanPromise
    (first.trans second) third
    (target1.trans target2) target3
    (trans active cleanPromise first second target1 target2 spec1 spec2)
    spec3

/-- Four-stage convenience wrapper used by the Figure-9 decomposition. -/
theorem trans_four
    {κ ρ α : Type*}
    (active : κ → Bool) (cleanPromise : ρ)
    (first second third fourth : Equiv.Perm (κ × ρ × α))
    (target1 target2 target3 target4 : Equiv.Perm α)
    (spec1 : PredicateControlledStrongPromiseSpec
      active cleanPromise first target1)
    (spec2 : PredicateControlledStrongPromiseSpec
      active cleanPromise second target2)
    (spec3 : PredicateControlledStrongPromiseSpec
      active cleanPromise third target3)
    (spec4 : PredicateControlledStrongPromiseSpec
      active cleanPromise fourth target4) :
    PredicateControlledStrongPromiseSpec
      active cleanPromise
      (((first.trans second).trans third).trans fourth)
      (((target1.trans target2).trans target3).trans target4) := by
  exact trans active cleanPromise
    ((first.trans second).trans third) fourth
    ((target1.trans target2).trans target3) target4
    (trans_three active cleanPromise
      first second third target1 target2 target3 spec1 spec2 spec3)
    spec4

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