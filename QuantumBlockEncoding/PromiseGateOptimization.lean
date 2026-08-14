import QuantumBlockEncoding.Robin.ComplexLCU

/-!
# Promise-register circuit identities

This module formalizes two reusable circuit transformations from
arXiv:2603.12917:

* in a controlled conjugation, only the middle operation needs the control;
* if the target operation is involutory, a clean flag can be replaced by a
  dirty flag using a second controlled target operation.

The statements are exact finite basis-permutation identities.  They are useful
as planning lemmas, but applying them to a concrete ASPBE candidate still
requires proofs that the candidate's promise register and restoration
conditions match these interfaces.
-/

namespace QuantumBlockEncoding
namespace PromiseGateOptimization

/-- Apply a target permutation without changing its control register. -/
def liftTargetEquiv {α : Type*} (target : Equiv.Perm α) :
    Equiv.Perm (Bool × α) :=
  Equiv.prodCongr (Equiv.refl Bool) target

/-- Apply the target permutation exactly on the `true` control branch. -/
def controlledTargetEquiv {α : Type*} (target : Equiv.Perm α) :
    Equiv.Perm (Bool × α) where
  toFun state :=
    if state.1 then (state.1, target state.2) else state
  invFun state :=
    if state.1 then (state.1, target.symm state.2) else state
  left_inv state := by
    rcases state with ⟨control, value⟩
    cases control <;> simp
  right_inv state := by
    rcases state with ⟨control, value⟩
    cases control <;> simp

/-- Chronological `V`, then `U`, then `V†`. -/
def conjugatedTargetEquiv {α : Type*}
    (outer middle : Equiv.Perm α) : Equiv.Perm α :=
  outer.trans (middle.trans outer.symm)

/-- Figure 3(a): controlling `V† U V` is equivalent to leaving `V` and `V†`
uncontrolled and controlling only `U`. -/
theorem controlledConjugation_equiv {α : Type*}
    (outer middle : Equiv.Perm α) :
    ((liftTargetEquiv outer).trans
        (controlledTargetEquiv middle)).trans
          (liftTargetEquiv outer.symm) =
      controlledTargetEquiv (conjugatedTargetEquiv outer middle) := by
  apply Equiv.ext
  intro state
  rcases state with ⟨control, value⟩
  cases control <;> simp [liftTargetEquiv, controlledTargetEquiv,
    conjugatedTargetEquiv]

/-- Matrix form of the controlled-conjugation identity. -/
theorem controlledConjugation_matrix
    {α : Type*} [Fintype α] [DecidableEq α]
    (outer middle : Equiv.Perm α) :
    Robin.ComplexLCU.equivPermutationMatrix (liftTargetEquiv outer.symm) *
        (Robin.ComplexLCU.equivPermutationMatrix (controlledTargetEquiv middle) *
          Robin.ComplexLCU.equivPermutationMatrix (liftTargetEquiv outer)) =
      Robin.ComplexLCU.equivPermutationMatrix
        (controlledTargetEquiv (conjugatedTargetEquiv outer middle)) := by
  rw [Robin.ComplexLCU.equivPermutationMatrix_mul]
  rw [Robin.ComplexLCU.equivPermutationMatrix_mul]
  rw [controlledConjugation_equiv]

/-- Exact clean-branch contract for a weak promise gate.  No behavior is
required away from `cleanPromise`. -/
def WeakPromiseSpec {ρ α : Type*}
    (cleanPromise : ρ) (implementation : Equiv.Perm (ρ × α))
    (target : Equiv.Perm α) : Prop :=
  ∀ value, implementation (cleanPromise, value) =
    (cleanPromise, target value)

/-- A strong promise gate additionally restores its promise register for every
basis input. -/
def StrongPromiseSpec {ρ α : Type*}
    (cleanPromise : ρ) (implementation : Equiv.Perm (ρ × α))
    (target : Equiv.Perm α) : Prop :=
  WeakPromiseSpec cleanPromise implementation target ∧
    ∀ promise value, (implementation (promise, value)).1 = promise

theorem StrongPromiseSpec.weak {ρ α : Type*}
    {cleanPromise : ρ} {implementation : Equiv.Perm (ρ × α)}
    {target : Equiv.Perm α}
    (spec : StrongPromiseSpec cleanPromise implementation target) :
    WeakPromiseSpec cleanPromise implementation target :=
  spec.1

/-- Toggle a possibly dirty flag exactly when the control predicate holds. -/
def toggleDirtyFlagEquiv {κ α : Type*} (control : κ → Bool) :
    Equiv.Perm (κ × Bool × α) where
  toFun state :=
    (state.1, if control state.1 then !state.2.1 else state.2.1, state.2.2)
  invFun state :=
    (state.1, if control state.1 then !state.2.1 else state.2.1, state.2.2)
  left_inv state := by
    rcases state with ⟨key, flag, value⟩
    cases condition : control key <;> cases flag <;> simp [condition]
  right_inv state := by
    rcases state with ⟨key, flag, value⟩
    cases condition : control key <;> cases flag <;> simp [condition]

/-- Apply the target when the dirty flag is set, preserving key and flag. -/
def dirtyFlagControlledTargetEquiv {κ α : Type*}
    (target : Equiv.Perm α) : Equiv.Perm (κ × Bool × α) where
  toFun state :=
    if state.2.1 then (state.1, state.2.1, target state.2.2) else state
  invFun state :=
    if state.2.1 then (state.1, state.2.1, target.symm state.2.2) else state
  left_inv state := by
    rcases state with ⟨key, flag, value⟩
    cases flag <;> simp
  right_inv state := by
    rcases state with ⟨key, flag, value⟩
    cases flag <;> simp

/-- Compute-use-uncompute-use protocol from Figure 2(a), right-hand side. -/
def dirtyControlledInvolutionEquiv {κ α : Type*}
    (control : κ → Bool) (target : Equiv.Perm α) :
    Equiv.Perm (κ × Bool × α) :=
  (toggleDirtyFlagEquiv control).trans
    ((dirtyFlagControlledTargetEquiv target).trans
      ((toggleDirtyFlagEquiv control).trans
        (dirtyFlagControlledTargetEquiv target)))

/-- A dirty flag is restored and the requested controlled target is applied,
provided the target is involutory. -/
theorem dirtyControlledInvolution_action
    {κ α : Type*} (control : κ → Bool) (target : Equiv.Perm α)
    (involutive : ∀ value, target (target value) = value)
    (key : κ) (flag : Bool) (value : α) :
    dirtyControlledInvolutionEquiv control target (key, flag, value) =
      (key, flag, if control key then target value else value) := by
  cases condition : control key <;> cases flag <;>
    simp [dirtyControlledInvolutionEquiv, toggleDirtyFlagEquiv,
      dirtyFlagControlledTargetEquiv, condition, involutive]

/-- The dirty-flag protocol is unitary because it is a basis permutation. -/
theorem dirtyControlledInvolution_unitary
    {κ α : Type*} [Fintype κ] [DecidableEq κ]
    [Fintype α] [DecidableEq α]
    (control : κ → Bool) (target : Equiv.Perm α) :
    Robin.ComplexLCU.equivPermutationMatrix
        (dirtyControlledInvolutionEquiv control target) ∈
      _root_.Matrix.unitaryGroup (κ × Bool × α) ℂ :=
  Robin.ComplexLCU.equivPermutationMatrix_unitary _

/-- Abstract operation counts exposed to the ASPBE planner. -/
structure ControlledProtocolCost where
  predicateToggles : Nat
  controlledTargetUses : Nat
  cleanFlags : Nat
  dirtyFlags : Nat
  deriving DecidableEq, Repr

/-- Standard clean-flag construction: compute, use, uncompute. -/
def cleanFlagProtocolCost : ControlledProtocolCost where
  predicateToggles := 2
  controlledTargetUses := 1
  cleanFlags := 1
  dirtyFlags := 0

/-- Involutory dirty-flag construction: one extra controlled target use. -/
def dirtyFlagProtocolCost : ControlledProtocolCost where
  predicateToggles := 2
  controlledTargetUses := 2
  cleanFlags := 0
  dirtyFlags := 1

@[simp] theorem dirtyFlag_replaces_cleanFlag :
    dirtyFlagProtocolCost.cleanFlags = 0 ∧
      dirtyFlagProtocolCost.dirtyFlags = 1 ∧
      dirtyFlagProtocolCost.controlledTargetUses =
        cleanFlagProtocolCost.controlledTargetUses + 1 := by
  decide

end PromiseGateOptimization
end QuantumBlockEncoding
