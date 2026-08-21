import QuantumBlockEncoding.VandaeleTheorem1Contract
import QuantumBlockEncoding.VandaeleTheorem1SemanticClosure

/-!
# Vandaele Corollary 2: `{CCX,CX,X}` specialization of Theorem 1

Corollary 2 does not introduce a new circuit transformation.  It specializes
Theorem 1 to the reversible gate set used by the rest of the paper.  The source
conclusions are therefore inherited without changing either the controlled
conjugation semantics or the resource scales:

* clean variant: `O(cV+cU+dU n+k)` gates,
  `O(dV+dU log n+log k)` depth, and
  `max(1,m-k+1)` clean ancillas;
* strong/involutory variant: one guaranteed clean bit may be replaced by one
  dirty bit with the same asymptotic gate/depth scales.

This module makes the corollary a first-class Lean node rather than leaving it
as prose between Theorem 1 and the later arithmetic applications.
-/

namespace QuantumBlockEncoding
namespace VandaeleCorollary2GateSetSpecialization

open VandaeleTheorem1Contract
open VandaeleTheorem1SemanticClosure

/-- Corollary-2 clean resource target is exactly Theorem 1's uniform target. -/
abbrev CleanResourceTarget := UniformResourceTarget

/-- Corollary-2 dirty/involutory resource target is exactly Theorem 1's strong
variant. -/
abbrev DirtyResourceTarget := UniformDirtyResourceTarget

/-- Uniform clean evidence specializes without any change of constants. -/
theorem clean_resources_inherited
    (gateCount depth cleanAncillas : SourceParameters -> Nat)
    (source : UniformResourceTarget gateCount depth cleanAncillas) :
    CleanResourceTarget gateCount depth cleanAncillas :=
  source

/-- Uniform dirty evidence likewise specializes without changing the theorem's
resource scale. -/
theorem dirty_resources_inherited
    (gateCount depth cleanAncillas dirtyAncillas : SourceParameters -> Nat)
    (source : UniformDirtyResourceTarget
      gateCount depth cleanAncillas dirtyAncillas) :
    DirtyResourceTarget gateCount depth cleanAncillas dirtyAncillas :=
  source

/-- Clean semantic specialization: controlling the conjugated target only
requires controlling the middle operation. -/
theorem clean_semantics
    {κ α : Type*} (active : κ -> Bool)
    (outer middle : Equiv.Perm α) :
    ((PredicateControlledConjugation.liftKeyTargetEquiv outer).trans
        (PredicateControlledConjugation.predicateControlledTargetEquiv
          active middle)).trans
          (PredicateControlledConjugation.liftKeyTargetEquiv outer.symm) =
      PredicateControlledConjugation.predicateControlledTargetEquiv active
        (PromiseGateOptimization.conjugatedTargetEquiv outer middle) :=
  clean_controlled_conjugation active outer middle

/-- Strong/involutory local specialization: one extra controlled target use
turns the clean promise protocol into a dirty-flag protocol. -/
theorem dirty_semantics
    {κ α : Type*} (active : κ -> Bool)
    (middle : Equiv.Perm α)
    (involutive : ∀ value, middle (middle value) = value)
    (key : κ) (dirty : Bool) (value : α) :
    ((StrongPromiseComputeUseUncompute.implementation active middle).trans
        (PromiseGateOptimization.dirtyFlagControlledTargetEquiv middle))
        (key, dirty, value) =
      (key, dirty, if active key then middle value else value) :=
  dirty_middle_action active middle involutive key dirty value

/-- The one-clean-to-one-dirty bookkeeping is inherited literally. -/
theorem dirty_workspace_trade (p : SourceParameters) :
    dirtyVariantCleanAncillas p + dirtyVariantDirtyAncillas p =
      cleanAncillaBudget p :=
  dirty_variant_preserves_workspace_count p

end VandaeleCorollary2GateSetSpecialization
end QuantumBlockEncoding
