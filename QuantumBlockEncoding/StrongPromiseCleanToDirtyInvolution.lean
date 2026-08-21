import QuantumBlockEncoding.StrongPromiseComputeUseUncompute
import QuantumBlockEncoding.PromiseGateOptimization
import Mathlib.Tactic

/-!
# From a clean strong-promise flag to a dirty involution protocol

The clean compute/use/uncompute construction is

`toggle predicate ; controlled-U ; toggle predicate`.

Vandaele Figure 2(a) / Theorem 1 appends one more `controlled-U`.  When `U` is
involutory, that one extra use removes the dependence on the incoming flag:
the flag may be dirty, is still restored, and the payload undergoes exactly the
requested predicate-controlled U.

This file makes the relationship exact.  It connects the generic strong-promise
construction to the already-formalized dirty-involution protocol and explains
semantically why the resource bookkeeping replaces one clean bit by one dirty
bit at the price of one extra controlled-target use.
-/

namespace QuantumBlockEncoding
namespace StrongPromiseCleanToDirtyInvolution

open PromiseGateOptimization
open StrongPromiseComputeUseUncompute

/-- The dirty-involution protocol is literally the clean compute/use/uncompute
protocol followed by one additional flag-controlled target use. -/
theorem dirtyProtocol_eq_cleanProtocol_then_extraUse
    {κ α : Type*} (active : κ -> Bool) (target : Equiv.Perm α) :
    dirtyControlledInvolutionEquiv active target =
      (StrongPromiseComputeUseUncompute.implementation active target).trans
        (dirtyFlagControlledTargetEquiv target) := by
  rfl

/-- Semantic clean-to-dirty upgrade.  If U is involutory, the extra target use
turns the strong-promise clean-flag protocol into a true controlled-U operation
for every incoming dirty flag while restoring that flag exactly. -/
theorem dirty_upgrade_action
    {κ α : Type*} (active : κ -> Bool) (target : Equiv.Perm α)
    (involutive : ∀ value, target (target value) = value)
    (key : κ) (flag : Bool) (value : α) :
    ((StrongPromiseComputeUseUncompute.implementation active target).trans
        (dirtyFlagControlledTargetEquiv target))
        (key, flag, value) =
      (key, flag, if active key then target value else value) := by
  rw [← dirtyProtocol_eq_cleanProtocol_then_extraUse]
  exact dirtyControlledInvolution_action
    active target involutive key flag value

/-- The dirty flag is restored unconditionally in the upgraded protocol. -/
theorem dirty_upgrade_restores_flag
    {κ α : Type*} (active : κ -> Bool) (target : Equiv.Perm α)
    (involutive : ∀ value, target (target value) = value)
    (key : κ) (flag : Bool) (value : α) :
    (((StrongPromiseComputeUseUncompute.implementation active target).trans
        (dirtyFlagControlledTargetEquiv target))
        (key, flag, value)).2.1 = flag := by
  rw [dirty_upgrade_action active target involutive key flag value]

/-- On a clean flag the extra-use dirty protocol agrees with the requested
predicate-controlled target, so the semantic target of the clean and dirty
constructions is identical on the clean fibre. -/
theorem clean_fibre_target_unchanged
    {κ α : Type*} (active : κ -> Bool) (target : Equiv.Perm α)
    (involutive : ∀ value, target (target value) = value)
    (key : κ) (value : α) :
    (((StrongPromiseComputeUseUncompute.implementation active target).trans
        (dirtyFlagControlledTargetEquiv target))
        (key, false, value)).2.2 =
      (predicateControlledTargetEquiv active target (key, value)).2 := by
  rw [dirty_upgrade_action active target involutive key false value]
  cases condition : active key <;>
    simp [predicateControlledTargetEquiv, condition]

/-- Resource-level companion already encoded in `PromiseGateOptimization`: the
upgrade removes one clean flag, introduces one dirty flag, and adds exactly one
controlled target use. -/
theorem resource_trade :
    dirtyFlagProtocolCost.cleanFlags = 0 ∧
    dirtyFlagProtocolCost.dirtyFlags = 1 ∧
    dirtyFlagProtocolCost.controlledTargetUses =
      cleanFlagProtocolCost.controlledTargetUses + 1 :=
  dirtyFlag_replaces_cleanFlag

end StrongPromiseCleanToDirtyInvolution
end QuantumBlockEncoding
