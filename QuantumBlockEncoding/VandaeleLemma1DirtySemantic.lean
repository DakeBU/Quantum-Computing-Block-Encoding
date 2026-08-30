import QuantumBlockEncoding.PromiseGateOptimization
import QuantumBlockEncoding.VandaeleLemma1Contract
import Mathlib.Tactic

/-!
# Semantic clean-to-dirty bridge for Vandaele Lemma 1

Nie et al.'s Figure 2 replaces a clean flag by an arbitrary dirty flag whenever
the controlled target is involutory.  Vandaele Lemma 1 invokes that result for
`C^k X`, whose target operation is Pauli-X and hence squares to the identity.

`PromiseGateOptimization.dirtyControlledInvolution_action` already formalizes
the abstract Figure-2 identity.  This module specializes that reusable theorem
to the exact Definition-2.1 predicate from `VandaeleLemma1Contract`.

What is proved here:

* the incoming dirty bit may be arbitrary;
* it is restored exactly;
* after forgetting that dirty bit, the action is exactly the source `C^k X`
  permutation for every `k`.

What is intentionally *not* claimed here is the `{X,CX,CCX}` gate schedule or
the `Theta(k)` / `Theta(log k)` resource bound.  Those depend on the recursive
conditionally-clean construction and remain a downstream executable frontier.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma1DirtySemantic

open VandaeleLemma1Contract
open PromiseGateOptimization

/-- Local decidability for the finite all-controls predicate. -/
local instance instDecidableAllControlsOne {k : Nat}
    (controls : PrimitiveBasis k) : Decidable (allControlsOne controls) := by
  unfold allControlsOne
  infer_instance

/-- Boolean form of the source Definition-2.1 activation predicate, used by the
reusable dirty-flag protocol. -/
def allControlsBool {k : Nat} (controls : PrimitiveBasis k) : Bool :=
  decide (allControlsOne controls)

@[simp] theorem allControlsBool_eq_true_iff {k : Nat}
    (controls : PrimitiveBasis k) :
    allControlsBool controls = true ↔ allControlsOne controls := by
  simp [allControlsBool]

@[simp] theorem allControlsBool_eq_false_iff {k : Nat}
    (controls : PrimitiveBasis k) :
    allControlsBool controls = false ↔ ¬ allControlsOne controls := by
  simp [allControlsBool]

/-- Pauli-X as an exact permutation of one computational-basis bit. -/
def targetXEquiv : Equiv.Perm (Fin 2) where
  toFun := flipBit
  invFun := flipBit
  left_inv := flipBit_flipBit
  right_inv := flipBit_flipBit

@[simp] theorem targetXEquiv_apply (bit : Fin 2) :
    targetXEquiv bit = flipBit bit := by
  rfl

/-- The target operation used by `C^k X` is involutory, which is precisely the
hypothesis needed by the clean-to-dirty substitution. -/
theorem targetXEquiv_involutive :
    ∀ bit, targetXEquiv (targetXEquiv bit) = bit := by
  intro bit
  exact flipBit_flipBit bit

/-- Product-coordinate form `[controls | dirty | target]` of the Figure-2 dirty
protocol specialized to `C^k X`. -/
def dirtyControlledCkXEquiv (k : Nat) :
    Equiv.Perm (PrimitiveBasis k × Bool × Fin 2) :=
  dirtyControlledInvolutionEquiv
    (fun controls : PrimitiveBasis k => allControlsBool controls)
    targetXEquiv

/-- Exact action of the dirty protocol.  In particular, the dirty bit is absent
from the target formula. -/
theorem dirtyControlledCkX_action
    (k : Nat) (controls : PrimitiveBasis k)
    (dirty : Bool) (target : Fin 2) :
    dirtyControlledCkXEquiv k (controls, dirty, target) =
      (controls, dirty,
        if allControlsOne controls then flipBit target else target) := by
  rw [dirtyControlledInvolution_action
    (fun controls : PrimitiveBasis k => allControlsBool controls)
    targetXEquiv targetXEquiv_involutive]
  by_cases active : allControlsOne controls
  · simp [allControlsBool, active]
  · simp [allControlsBool, active]

/-- The arbitrary incoming dirty bit is restored exactly. -/
theorem dirtyControlledCkX_restores_dirty
    (k : Nat) (controls : PrimitiveBasis k)
    (dirty : Bool) (target : Fin 2) :
    (dirtyControlledCkXEquiv k (controls, dirty, target)).2.1 = dirty := by
  rw [dirtyControlledCkX_action]

/-- After forgetting the restored dirty bit, the product-coordinate protocol is
exactly Vandaele Definition 2.1.  This is the semantic hand-off used by the
future flat-wire `ReversibleProgram` refinement. -/
theorem dirtyControlledCkX_refines_source
    (k : Nat) (controls : PrimitiveBasis k)
    (dirty : Bool) (target : Fin 2) :
    let result := dirtyControlledCkXEquiv k (controls, dirty, target)
    (result.1, result.2.2) = multiControlledXEquiv k (controls, target) ∧
      result.2.1 = dirty := by
  rw [dirtyControlledCkX_action]
  constructor
  · by_cases active : allControlsOne controls
    · simp [multiControlledXEquiv, multiControlledXAction, active]
    · simp [multiControlledXEquiv, multiControlledXAction, active]
  · rfl

/-- The source permutation itself is involutory for every number of controls,
so the same clean-to-dirty principle remains available recursively wherever a
proof state exposes a `C^k X` as the controlled target. -/
theorem sourceCkX_is_involutory (k : Nat) :
    ∀ state, multiControlledXEquiv k (multiControlledXEquiv k state) = state := by
  intro state
  exact multiControlledXAction_involutive k state

/-- Planner-visible protocol accounting inherited from the reusable Figure-2
identity.  This is deliberately *protocol* cost, not a gate-count theorem. -/
def dirtyReductionProtocolCost : ControlledProtocolCost :=
  dirtyFlagProtocolCost

@[simp] theorem dirtyReduction_uses_one_dirty_bit :
    dirtyReductionProtocolCost.dirtyFlags = 1 := by
  rfl

@[simp] theorem dirtyReduction_uses_no_clean_flag :
    dirtyReductionProtocolCost.cleanFlags = 0 := by
  rfl

end VandaeleLemma1DirtySemantic
end QuantumBlockEncoding
