import QuantumBlockEncoding.PredicateControlledConjugation
import QuantumBlockEncoding.PromiseGateOptimization
import Mathlib.Tactic

/-!
# Generic compute-use-uncompute strong promise gate

A recurring source pattern is

`compute predicate into flag ; use flag as control ; uncompute predicate`.

The flag need not start clean in order to be restored: the first and last
predicate toggles are identical and the middle operation does not write the
flag.  What cleanliness controls is only the *target semantics*.  On the clean
`false` branch the target operation is applied exactly when the external
predicate is true; away from that branch the target action may depend on the
incoming flag.

This is the abstract mechanism behind Vandaele Equation (58), Appendix A.3,
and many later SP/BE promise-register constructions.  Unlike the four-step
dirty-involution protocol, no involutivity assumption on the target is needed
because a strong promise gate leaves dirty-fibre target behavior unspecified.
-/

namespace QuantumBlockEncoding
namespace StrongPromiseComputeUseUncompute

open PredicateControlledConjugation
open PromiseGateOptimization

/-- Compute/use/uncompute in key/flag/target coordinates. -/
def implementation {κ α : Type*}
    (active : κ -> Bool) (target : Equiv.Perm α) :
    Equiv.Perm (κ × Bool × α) :=
  (toggleDirtyFlagEquiv active).trans
    ((dirtyFlagControlledTargetEquiv target).trans
      (toggleDirtyFlagEquiv active))

/-- The flag is restored for every key, target value, and incoming flag. -/
theorem restores_flag
    {κ α : Type*} (active : κ -> Bool) (target : Equiv.Perm α)
    (key : κ) (flag : Bool) (value : α) :
    (implementation active target (key, flag, value)).2.1 = flag := by
  cases condition : active key <;> cases flag <;>
    simp [implementation, toggleDirtyFlagEquiv,
      dirtyFlagControlledTargetEquiv, condition]

/-- The key is also preserved unconditionally. -/
theorem preserves_key
    {κ α : Type*} (active : κ -> Bool) (target : Equiv.Perm α)
    (key : κ) (flag : Bool) (value : α) :
    (implementation active target (key, flag, value)).1 = key := by
  cases condition : active key <;> cases flag <;>
    simp [implementation, toggleDirtyFlagEquiv,
      dirtyFlagControlledTargetEquiv, condition]

/-- On a clean false flag, the requested predicate-controlled target action is
implemented exactly. -/
theorem clean_action
    {κ α : Type*} (active : κ -> Bool) (target : Equiv.Perm α)
    (key : κ) (value : α) :
    implementation active target (key, false, value) =
      (key, false, if active key then target value else value) := by
  cases condition : active key <;>
    simp [implementation, toggleDirtyFlagEquiv,
      dirtyFlagControlledTargetEquiv, condition]

/-- Reassociate the flag as the promise register. -/
def flagFirstEquiv {κ α : Type*} :
    κ × Bool × α ≃ Bool × (κ × α) where
  toFun state := (state.2.1, (state.1, state.2.2))
  invFun state := (state.2.1, state.1, state.2.2)
  left_inv state := by
    rcases state with ⟨key, flag, value⟩
    rfl
  right_inv state := by
    rcases state with ⟨flag, key, value⟩
    rfl

/-- Promise-first view of the same compute/use/uncompute permutation. -/
def promiseImplementation {κ α : Type*}
    (active : κ -> Bool) (target : Equiv.Perm α) :
    Equiv.Perm (Bool × (κ × α)) :=
  flagFirstEquiv.symm.trans
    ((implementation active target).trans flagFirstEquiv)

/-- Main reusable theorem: compute/use/uncompute is a strong promise gate whose
clean branch is the predicate-controlled target. -/
theorem strongPromiseSpec
    {κ α : Type*} (active : κ -> Bool) (target : Equiv.Perm α) :
    StrongPromiseSpec
      false
      (promiseImplementation active target)
      (predicateControlledTargetEquiv active target) := by
  constructor
  · intro value
    rcases value with ⟨key, payload⟩
    change
      flagFirstEquiv
        (implementation active target (key, false, payload)) =
      (false, predicateControlledTargetEquiv active target (key, payload))
    rw [clean_action]
    cases condition : active key <;>
      simp [flagFirstEquiv, predicateControlledTargetEquiv, condition]
  · intro promise value
    rcases value with ⟨key, payload⟩
    change
      (flagFirstEquiv
        (implementation active target (key, promise, payload))).1 = promise
    exact restores_flag active target key promise payload

end StrongPromiseComputeUseUncompute
end QuantumBlockEncoding
