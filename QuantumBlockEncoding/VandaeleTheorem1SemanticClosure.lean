import QuantumBlockEncoding.StrongPromiseCleanToDirtyInvolution
import QuantumBlockEncoding.VandaeleTheorem1Contract

/-!
# Semantic closure of Vandaele Theorem 1

The source theorem has two semantic layers:

1. if `W = V† U V`, then controlling W is equivalent to leaving V,V†
   uncontrolled and controlling only U;
2. if the controlled middle operation is implemented through a strong promise
   flag and U is involutory, one clean flag can be replaced by one dirty flag by
   appending one extra controlled-U use.

Both ingredients are already formalized generically.  This module packages them
as the source-facing semantic closure of Theorem 1, leaving the quantitative
resource transformation to `VandaeleTheorem1ResourceClosure`.
-/

namespace QuantumBlockEncoding
namespace VandaeleTheorem1SemanticClosure

open PredicateControlledConjugation
open PromiseGateOptimization
open StrongPromiseCleanToDirtyInvolution
open StrongPromiseComputeUseUncompute
open VandaeleTheorem1Contract

/-- Clean-promise semantic form of Theorem 1. -/
theorem clean_controlled_conjugation
    {κ α : Type*} (active : κ -> Bool)
    (outer middle : Equiv.Perm α) :
    ((liftKeyTargetEquiv outer).trans
        (predicateControlledTargetEquiv active middle)).trans
          (liftKeyTargetEquiv outer.symm) =
      predicateControlledTargetEquiv active
        (conjugatedTargetEquiv outer middle) :=
  semantic_control_reduction active outer middle

/-- The clean compute/use/uncompute middle-control protocol is a strong promise
implementation of predicate-controlled U. -/
theorem clean_middle_strongPromise
    {κ α : Type*} (active : κ -> Bool)
    (middle : Equiv.Perm α) :
    StrongPromiseSpec
      false
      (StrongPromiseComputeUseUncompute.promiseImplementation active middle)
      (predicateControlledTargetEquiv active middle) :=
  StrongPromiseComputeUseUncompute.strongPromiseSpec active middle

/-- Dirty/involutory semantic form of Theorem 1.  The same controlled target is
obtained for every incoming dirty flag, while the flag is restored. -/
theorem dirty_middle_action
    {κ α : Type*} (active : κ -> Bool)
    (middle : Equiv.Perm α)
    (involutive : ∀ value, middle (middle value) = value)
    (key : κ) (dirty : Bool) (value : α) :
    ((StrongPromiseComputeUseUncompute.implementation active middle).trans
        (dirtyFlagControlledTargetEquiv middle))
        (key, dirty, value) =
      (key, dirty, if active key then middle value else value) :=
  dirty_upgrade_action active middle involutive key dirty value

/-- The dirty variant restores the borrowed flag exactly. -/
theorem dirty_middle_restores_flag
    {κ α : Type*} (active : κ -> Bool)
    (middle : Equiv.Perm α)
    (involutive : ∀ value, middle (middle value) = value)
    (key : κ) (dirty : Bool) (value : α) :
    (((StrongPromiseComputeUseUncompute.implementation active middle).trans
        (dirtyFlagControlledTargetEquiv middle))
        (key, dirty, value)).2.1 = dirty :=
  dirty_upgrade_restores_flag active middle involutive key dirty value

/-- The exact local resource trade used by the strong/involutory variant. -/
theorem clean_to_dirty_local_trade :
    dirtyFlagProtocolCost.cleanFlags = 0 ∧
    dirtyFlagProtocolCost.dirtyFlags = 1 ∧
    dirtyFlagProtocolCost.controlledTargetUses =
      cleanFlagProtocolCost.controlledTargetUses + 1 :=
  resource_trade

end VandaeleTheorem1SemanticClosure
end QuantumBlockEncoding
