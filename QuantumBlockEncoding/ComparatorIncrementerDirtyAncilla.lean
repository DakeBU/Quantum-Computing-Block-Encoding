import QuantumBlockEncoding.PromiseGateOptimization

/-!
# Dirty-ancilla protocol for increment/decrement inverse pairs

Vandaele's incrementer cannot use the repository's existing
`dirtyControlledInvolution_action` directly: increment is not involutory.  The
paper instead uses two facts (Equations (35) and (36)):

* bitwise-X conjugates increment into decrement, so an increment followed by
  its X-conjugated copy cancels;
* a dirty flag can select between an increment and an inverse decrement.  When
  the external control is false the inverse pair cancels; when it is true, the
  decrement branch is converted into an increment branch, so exactly one
  increment is applied regardless of the unknown dirty bit.

This module formalizes that second pattern at the level of finite basis
permutations.  A later source-specific leaf will identify the paper's controlled
bitwise-X fan-out with the control-dependent `forward/backward` selector below.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerDirtyAncilla

open PromiseGateOptimization
open Robin.ComplexLCU

/-- Abstract form of Vandaele Eq. (35): conjugating `forward` by `conjugator`
produces the inverse operation.  For the incrementer, `conjugator` is bitwise X
and `forward.symm` is decrement. -/
def InverseByConjugation {α : Type*}
    (conjugator forward : Equiv.Perm α) : Prop :=
  conjugator.trans (forward.trans conjugator) = forward.symm

/-- Eq. (35) as a permutation identity: `forward ; X ; forward ; X = I` whenever
`X ; forward ; X = forward⁻¹`. -/
theorem forward_conjugator_forward_conjugator_eq_refl
    {α : Type*} (conjugator forward : Equiv.Perm α)
    (inverseByConjugation : InverseByConjugation conjugator forward) :
    forward.trans (conjugator.trans (forward.trans conjugator)) =
      Equiv.refl α := by
  rw [inverseByConjugation]
  apply Equiv.ext
  intro value
  simp

/-- Apply a target operation only when the dirty flag is one, choosing the
forward or backward operation from an external predicate.  The flag and key are
left unchanged.

For Vandaele Eq. (36), the `control = true` branch represents the decrement
subcircuit after the controlled bitwise-X fan-out has conjugated it into an
increment. -/
def dirtyFlagControlledChoiceEquiv {κ α : Type*}
    (control : κ → Bool) (forward backward : Equiv.Perm α) :
    Equiv.Perm (κ × Bool × α) where
  toFun state :=
    if state.2.1 then
      (state.1, state.2.1,
        (if control state.1 then forward else backward) state.2.2)
    else state
  invFun state :=
    if state.2.1 then
      (state.1, state.2.1,
        (if control state.1 then forward.symm else backward.symm) state.2.2)
    else state
  left_inv state := by
    rcases state with ⟨key, flag, value⟩
    cases flag <;> simp
    cases condition : control key <;> simp [condition]
  right_inv state := by
    rcases state with ⟨key, flag, value⟩
    cases flag <;> simp
    cases condition : control key <;> simp [condition]

/-- Abstract Eq. (36) protocol.

Chronologically:
1. toggle the dirty flag by the requested external control;
2. apply `forward` when that flag is one;
3. restore/toggle the flag again;
4. on the remaining dirty-one branch, apply `backward` when the external
   control is false and `forward` when it is true.

If `backward = forward⁻¹`, the false-control branch cancels and the true-control
branch applies exactly one copy of `forward`, independently of the incoming
dirty flag. -/
def dirtyControlledInversePairEquiv {κ α : Type*}
    (control : κ → Bool) (forward backward : Equiv.Perm α) :
    Equiv.Perm (κ × Bool × α) :=
  (toggleDirtyFlagEquiv control).trans
    ((dirtyFlagControlledTargetEquiv forward).trans
      ((toggleDirtyFlagEquiv control).trans
        (dirtyFlagControlledChoiceEquiv control forward backward)))

/-- Exact action of the inverse-pair dirty protocol.  This is the reusable
semantic core of Vandaele Eq. (36), separated from the later gate-level proof
that controlled bitwise-X fan-out realizes its control-dependent final branch. -/
theorem dirtyControlledInversePair_action
    {κ α : Type*} (control : κ → Bool)
    (forward backward : Equiv.Perm α)
    (inversePair : backward = forward.symm)
    (key : κ) (flag : Bool) (value : α) :
    dirtyControlledInversePairEquiv control forward backward
        (key, flag, value) =
      (key, flag, if control key then forward value else value) := by
  subst backward
  cases condition : control key <;> cases flag <;>
    simp [dirtyControlledInversePairEquiv, dirtyFlagControlledChoiceEquiv,
      toggleDirtyFlagEquiv, dirtyFlagControlledTargetEquiv, condition]

/-- The dirty workspace is restored for every key, flag, and target state. -/
theorem dirtyControlledInversePair_restoresFlag
    {κ α : Type*} (control : κ → Bool)
    (forward backward : Equiv.Perm α)
    (inversePair : backward = forward.symm)
    (key : κ) (flag : Bool) (value : α) :
    (dirtyControlledInversePairEquiv control forward backward
        (key, flag, value)).2.1 = flag := by
  rw [dirtyControlledInversePair_action control forward backward inversePair]

/-- The protocol is unitary because its complete action is a basis permutation. -/
theorem dirtyControlledInversePair_unitary
    {κ α : Type*} [Fintype κ] [DecidableEq κ]
    [Fintype α] [DecidableEq α]
    (control : κ → Bool) (forward backward : Equiv.Perm α) :
    equivPermutationMatrix
        (dirtyControlledInversePairEquiv control forward backward) ∈
      _root_.Matrix.unitaryGroup (κ × Bool × α) ℂ :=
  equivPermutationMatrix_unitary _

/-- Planner-visible abstract cost shape for Eq. (36).  Concrete gate counts are
not asserted here: the paper-specific fan-out and controlled promise-gate
realizations still have to be refined to `{CCX,CX,X}`. -/
structure InversePairProtocolCost where
  dirtyFlagPredicateToggles : Nat
  dirtyControlledForwardUses : Nat
  dirtyControlledChoiceUses : Nat
  dirtyAncillas : Nat
  deriving DecidableEq, Repr

def inversePairProtocolCost : InversePairProtocolCost where
  dirtyFlagPredicateToggles := 2
  dirtyControlledForwardUses := 1
  dirtyControlledChoiceUses := 1
  dirtyAncillas := 1

@[simp] theorem inversePairProtocol_uses_one_dirty_ancilla :
    inversePairProtocolCost.dirtyAncillas = 1 := by
  rfl

end ComparatorIncrementerDirtyAncilla
end QuantumBlockEncoding
