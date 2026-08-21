import QuantumBlockEncoding.PromiseGateOptimization

/-!
# Controlled strong-promise semantics

A strong promise gate preserves its promise register on every basis input and
implements a target permutation on the declared clean-promise branch.  Vandaele
uses controlled strong promise gates throughout the comparator/incrementer
constructions.

This module isolates the generic semantic fact: adding one external Boolean
control to a strong promise gate yields a controlled strong promise gate.  The
result is independent of any particular arithmetic target and is intended to be
a shared Lean node for later State Preparation / Block Encoding constructions
that use promise-register compute/use/uncompute patterns.
-/

namespace QuantumBlockEncoding
namespace ControlledStrongPromise

open PromiseGateOptimization

/-- Semantic contract for a controlled strong promise gate.

* external control false: identity on the declared clean-promise branch;
* external control true: apply `target` on the declared clean-promise branch;
* every promise-register basis value is preserved for both control branches.
-/
def ControlledStrongPromiseSpec {ρ α : Type*}
    (cleanPromise : ρ)
    (implementation : Equiv.Perm (Bool × ρ × α))
    (target : Equiv.Perm α) : Prop :=
  (∀ value,
    implementation (false, cleanPromise, value) =
      (false, cleanPromise, value)) ∧
  (∀ value,
    implementation (true, cleanPromise, value) =
      (true, cleanPromise, target value)) ∧
  (∀ control promise value,
    (implementation (control, promise, value)).2.1 = promise)

/-- Add one external control to a promise-register implementation. -/
def controlledStrongPromiseEquiv {ρ α : Type*}
    (implementation : Equiv.Perm (ρ × α)) :
    Equiv.Perm (Bool × ρ × α) :=
  controlledTargetEquiv implementation

/-- A strong promise gate remains strong after adding one external control. -/
theorem controlledStrongPromise_of_strong
    {ρ α : Type*} (cleanPromise : ρ)
    (implementation : Equiv.Perm (ρ × α))
    (target : Equiv.Perm α)
    (strong : StrongPromiseSpec cleanPromise implementation target) :
    ControlledStrongPromiseSpec cleanPromise
      (controlledStrongPromiseEquiv implementation) target := by
  constructor
  · intro value
    simp [controlledStrongPromiseEquiv, controlledTargetEquiv]
  · constructor
    · intro value
      change
        (true, implementation (cleanPromise, value)) =
          (true, cleanPromise, target value)
      rw [strong.1 value]
    · intro control promise value
      cases control
      · simp [controlledStrongPromiseEquiv, controlledTargetEquiv]
      · change (implementation (promise, value)).1 = promise
        exact strong.2 promise value

/-- The controlled wrapper preserves the promise register on arbitrary inputs,
not only on the clean branch. -/
theorem controlledStrongPromise_restores_promise
    {ρ α : Type*} (cleanPromise : ρ)
    (implementation : Equiv.Perm (ρ × α))
    (target : Equiv.Perm α)
    (strong : StrongPromiseSpec cleanPromise implementation target)
    (control : Bool) (promise : ρ) (value : α) :
    (controlledStrongPromiseEquiv implementation
      (control, promise, value)).2.1 = promise := by
  exact (controlledStrongPromise_of_strong
    cleanPromise implementation target strong).2.2 control promise value

end ControlledStrongPromise
end QuantumBlockEncoding
