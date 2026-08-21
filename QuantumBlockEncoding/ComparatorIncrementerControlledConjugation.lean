import QuantumBlockEncoding.ComparatorIncrementerDirtyAncilla

/-!
# Controlled conjugation refinement for Vandaele Eq. (36)

`ComparatorIncrementerDirtyAncilla` proved the semantic inverse-pair protocol
assuming a final dirty-controlled branch can choose `forward` when the external
control is true and `backward` when it is false.  Vandaele Eq. (36) realizes
exactly that choice with two controlled bitwise-X fan-outs around the decrement
operation.

This module proves the corresponding permutation identity abstractly.  The
remaining paper-specific leaf is gate-level: instantiate `conjugator` with the
bitwise-X permutation on an n-bit register and refine the keyed controlled
conjugators to the paper's controlled fan-out construction over `{CCX,CX,X}`.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerControlledConjugation

open PromiseGateOptimization
open ComparatorIncrementerDirtyAncilla
open Robin.ComplexLCU

/-- Apply a target permutation to the target register exactly when an external
predicate on the key is true.  The dirty flag is preserved and is not itself a
control for this operation. -/
def keyControlledTargetEquiv {κ α : Type*}
    (control : κ → Bool) (target : Equiv.Perm α) :
    Equiv.Perm (κ × Bool × α) where
  toFun state :=
    if control state.1 then
      (state.1, state.2.1, target state.2.2)
    else state
  invFun state :=
    if control state.1 then
      (state.1, state.2.1, target.symm state.2.2)
    else state
  left_inv state := by
    rcases state with ⟨key, flag, value⟩
    cases condition : control key <;> simp [condition]
  right_inv state := by
    rcases state with ⟨key, flag, value⟩
    cases condition : control key <;> simp [condition]

/-- The source identity needs the X-like conjugator to be self-inverse. -/
def InvolutiveConjugator {α : Type*} (conjugator : Equiv.Perm α) : Prop :=
  ∀ value, conjugator (conjugator value) = value

/-- If `X ; forward ; X = forward⁻¹` and `X² = I`, then conversely
`X ; forward⁻¹ ; X = forward`.  This is the algebra used by the controlled
fan-out pair surrounding decrement in Eq. (36). -/
theorem inverse_conjugates_back_to_forward
    {α : Type*} (conjugator forward : Equiv.Perm α)
    (involutive : InvolutiveConjugator conjugator)
    (inverseByConjugation : InverseByConjugation conjugator forward) :
    conjugator.trans (forward.symm.trans conjugator) = forward := by
  have inverseEq :
      conjugator.trans (forward.trans conjugator) = forward.symm :=
    inverseByConjugation
  apply Equiv.ext
  intro value
  change conjugator (forward.symm (conjugator value)) = forward value
  have inversePoint :
      forward.symm (conjugator value) =
        conjugator (forward (conjugator (conjugator value))) := by
    have h := congrArg
      (fun equiv : Equiv.Perm α => equiv (conjugator value)) inverseEq
    simpa only [Equiv.trans_apply] using h.symm
  rw [inversePoint, involutive value, involutive (forward value)]

/-- The gate pattern appearing in the final branch of Eq. (36): controlled X
conjugation, dirty-controlled decrement, controlled X conjugation. -/
def conjugatedDirtyBackwardEquiv {κ α : Type*}
    (control : κ → Bool) (conjugator backward : Equiv.Perm α) :
    Equiv.Perm (κ × Bool × α) :=
  (keyControlledTargetEquiv control conjugator).trans
    ((dirtyFlagControlledTargetEquiv backward).trans
      (keyControlledTargetEquiv control conjugator))

/-- The controlled-conjugation gate pattern realizes exactly the abstract
forward/backward choice used by the inverse-pair protocol.

* external control false: the X-like conjugators are identities, so dirty=1
  selects `backward` and dirty=0 does nothing;
* external control true: dirty=0 sees `X ; X = I`, while dirty=1 sees
  `X ; backward ; X = forward`.
-/
theorem conjugatedDirtyBackward_eq_choice
    {κ α : Type*} (control : κ → Bool)
    (conjugator forward backward : Equiv.Perm α)
    (involutive : InvolutiveConjugator conjugator)
    (inverseByConjugation : InverseByConjugation conjugator forward)
    (inversePair : backward = forward.symm) :
    conjugatedDirtyBackwardEquiv control conjugator backward =
      dirtyFlagControlledChoiceEquiv control forward backward := by
  subst backward
  have backToForward :=
    inverse_conjugates_back_to_forward conjugator forward
      involutive inverseByConjugation
  apply Equiv.ext
  intro state
  rcases state with ⟨key, flag, value⟩
  cases condition : control key <;> cases flag
  · simp [conjugatedDirtyBackwardEquiv, keyControlledTargetEquiv,
      dirtyFlagControlledTargetEquiv, dirtyFlagControlledChoiceEquiv, condition]
  · simp [conjugatedDirtyBackwardEquiv, keyControlledTargetEquiv,
      dirtyFlagControlledTargetEquiv, dirtyFlagControlledChoiceEquiv, condition]
  · simp [conjugatedDirtyBackwardEquiv, keyControlledTargetEquiv,
      dirtyFlagControlledTargetEquiv, dirtyFlagControlledChoiceEquiv,
      condition, involutive]
  · change
      (key, true,
        conjugator (forward.symm (conjugator value))) =
      (key, true, forward value)
    have pointwise :
        conjugator (forward.symm (conjugator value)) = forward value := by
      exact congrArg (fun equiv : Equiv.Perm α => equiv value) backToForward
    exact congrArg (fun target => (key, true, target)) pointwise

/-- Eq. (36) with the abstract choice eliminated in favor of controlled
conjugation around the dirty-controlled inverse operation. -/
def dirtyControlledConjugationProtocolEquiv {κ α : Type*}
    (control : κ → Bool)
    (conjugator forward backward : Equiv.Perm α) :
    Equiv.Perm (κ × Bool × α) :=
  (toggleDirtyFlagEquiv control).trans
    ((dirtyFlagControlledTargetEquiv forward).trans
      ((toggleDirtyFlagEquiv control).trans
        (conjugatedDirtyBackwardEquiv control conjugator backward)))

/-- Exact paper-style dirty-ancilla action after replacing the abstract choice
with the two controlled conjugators. -/
theorem dirtyControlledConjugationProtocol_action
    {κ α : Type*} (control : κ → Bool)
    (conjugator forward backward : Equiv.Perm α)
    (involutive : InvolutiveConjugator conjugator)
    (inverseByConjugation : InverseByConjugation conjugator forward)
    (inversePair : backward = forward.symm)
    (key : κ) (flag : Bool) (value : α) :
    dirtyControlledConjugationProtocolEquiv
        control conjugator forward backward (key, flag, value) =
      (key, flag, if control key then forward value else value) := by
  have refinement := conjugatedDirtyBackward_eq_choice
    control conjugator forward backward involutive
      inverseByConjugation inversePair
  unfold dirtyControlledConjugationProtocolEquiv
  rw [refinement]
  change
    dirtyControlledInversePairEquiv control forward backward
        (key, flag, value) =
      (key, flag, if control key then forward value else value)
  exact dirtyControlledInversePair_action
    control forward backward inversePair key flag value

/-- In particular, the paper-style implementation restores the unknown dirty
bit for every external-control branch. -/
theorem dirtyControlledConjugationProtocol_restoresFlag
    {κ α : Type*} (control : κ → Bool)
    (conjugator forward backward : Equiv.Perm α)
    (involutive : InvolutiveConjugator conjugator)
    (inverseByConjugation : InverseByConjugation conjugator forward)
    (inversePair : backward = forward.symm)
    (key : κ) (flag : Bool) (value : α) :
    (dirtyControlledConjugationProtocolEquiv
        control conjugator forward backward (key, flag, value)).2.1 = flag := by
  rw [dirtyControlledConjugationProtocol_action control conjugator forward backward
    involutive inverseByConjugation inversePair]

/-- The refined Eq. (36) protocol is unitary because it is a basis permutation. -/
theorem dirtyControlledConjugationProtocol_unitary
    {κ α : Type*} [Fintype κ] [DecidableEq κ]
    [Fintype α] [DecidableEq α]
    (control : κ → Bool)
    (conjugator forward backward : Equiv.Perm α) :
    equivPermutationMatrix
        (dirtyControlledConjugationProtocolEquiv
          control conjugator forward backward) ∈
      _root_.Matrix.unitaryGroup (κ × Bool × α) ℂ :=
  equivPermutationMatrix_unitary _

end ComparatorIncrementerControlledConjugation
end QuantumBlockEncoding
