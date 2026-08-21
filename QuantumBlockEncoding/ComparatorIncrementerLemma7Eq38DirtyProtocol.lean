import QuantumBlockEncoding.ComparatorIncrementerLemma7Eq38Bridge
import QuantumBlockEncoding.ComparatorIncrementerLemma7PromiseBudget
import QuantumBlockEncoding.ZModPrimitiveBasisBridge
import Mathlib.Tactic

/-!
# Vandaele Equation (38) with a borrowed dirty promise bit

The clean Equation-(38) semantics is already closed.  The source then invokes
Equation (36) to replace its clean carry ancilla by one unknown dirty bit borrowed
from the same promise register.

This module instantiates the generic inverse-by-conjugation protocol directly on
`PrimitiveBasis`:

* key = `(external controls, low register)`;
* active iff all external controls and all low bits are one;
* conjugator = bitwise all-X on the high register;
* forward = high-register modular increment;
* backward = its inverse.

The basis-level Equation-(35) theorem proves the required conjugation identity.
The dirty protocol therefore increments the high block exactly on the carry
branch while restoring the unknown dirty bit.  A final externally controlled low
increment completes the same target action as the clean Equation-(38) protocol.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma7Eq38DirtyProtocol

open ComparatorIncrementerAllX
open ComparatorIncrementerControlledConjugation
open ComparatorIncrementerLemma7Contract
open ComparatorIncrementerLemma7Eq38Bridge
open ComparatorIncrementerLemma7Eq38CleanProtocol
open ComparatorIncrementerLemma7PromiseBudget
open PredicateControlledConjugation
open PrimitiveBasisRegisterSplit
open ZModPrimitiveBasisBridge

/-- Carry predicate used as the external key control in Equation (36). -/
def dirtyCarryActive {k low : Nat}
    (key : PrimitiveBasis k × PrimitiveBasis low) : Bool :=
  if allControlsActive key.1 = true ∧ allControlsActive key.2 = true then
    true
  else false

@[simp] theorem dirtyCarryActive_true_iff
    {k low : Nat} (controls : PrimitiveBasis k)
    (lowState : PrimitiveBasis low) :
    dirtyCarryActive (controls, lowState) = true ↔
      allControlsActive controls = true ∧
        allControlsActive lowState = true := by
  unfold dirtyCarryActive
  by_cases active :
      allControlsActive controls = true ∧
        allControlsActive lowState = true <;> simp [active]

/-- Equation-(36) high-register protocol, with one unknown dirty bit. -/
def dirtyHighIncrementEquiv (k low high : Nat) :
    Equiv.Perm
      ((PrimitiveBasis k × PrimitiveBasis low) × Bool × PrimitiveBasis high) :=
  dirtyControlledConjugationProtocolEquiv
    dirtyCarryActive
    (allXBasisEquiv high)
    (basisModularIncrementEquiv high)
    (basisModularIncrementEquiv high).symm

/-- Exact high-register action and dirty-bit restoration from the generic
Equation-(36) theorem. -/
theorem dirtyHighIncrement_action
    (k low high : Nat)
    (controls : PrimitiveBasis k)
    (lowState : PrimitiveBasis low)
    (dirty : Bool)
    (highState : PrimitiveBasis high) :
    dirtyHighIncrementEquiv k low high
        ((controls, lowState), dirty, highState) =
      ((controls, lowState), dirty,
        if dirtyCarryActive (controls, lowState) then
          basisModularIncrementEquiv high highState
        else highState) := by
  exact dirtyControlledConjugationProtocol_action
    dirtyCarryActive
    (allXBasisEquiv high)
    (basisModularIncrementEquiv high)
    (basisModularIncrementEquiv high).symm
    (basisAllX_involutive high)
    (basisAllX_increment_inverse high)
    rfl
    (controls, lowState) dirty highState

/-- In particular, the unknown promise bit is restored exactly. -/
theorem dirtyHighIncrement_restores_dirty
    (k low high : Nat)
    (controls : PrimitiveBasis k)
    (lowState : PrimitiveBasis low)
    (dirty : Bool)
    (highState : PrimitiveBasis high) :
    (dirtyHighIncrementEquiv k low high
      ((controls, lowState), dirty, highState)).2.1 = dirty := by
  rw [dirtyHighIncrement_action]

/-- Low-register step applied after the dirty high-carry protocol.  Only the
external controls participate in this condition. -/
def externallyControlledLowAfterDirtyEquiv (k low high : Nat) :
    Equiv.Perm
      ((PrimitiveBasis k × PrimitiveBasis low) × Bool × PrimitiveBasis high) where
  toFun state :=
    if allControlsActive state.1.1 = true then
      ((state.1.1, basisModularIncrementEquiv low state.1.2),
        state.2.1, state.2.2)
    else state
  invFun state :=
    if allControlsActive state.1.1 = true then
      ((state.1.1, (basisModularIncrementEquiv low).symm state.1.2),
        state.2.1, state.2.2)
    else state
  left_inv state := by
    rcases state with ⟨⟨controls, lowState⟩, dirty, highState⟩
    by_cases active : allControlsActive controls = true <;>
      simp [active]
  right_inv state := by
    rcases state with ⟨⟨controls, lowState⟩, dirty, highState⟩
    by_cases active : allControlsActive controls = true <;>
      simp [active]

/-- Complete dirty Equation-(38) protocol. -/
def eq38DirtyProtocolEquiv (k low high : Nat) :
    Equiv.Perm
      ((PrimitiveBasis k × PrimitiveBasis low) × Bool × PrimitiveBasis high) :=
  (dirtyHighIncrementEquiv k low high).trans
    (externallyControlledLowAfterDirtyEquiv k low high)

/-- Full dirty-protocol action.  The predicate is evaluated on the original low
register because the high dirty protocol preserves its key before the low
increment is applied. -/
theorem eq38DirtyProtocol_action
    (k low high : Nat)
    (controls : PrimitiveBasis k)
    (lowState : PrimitiveBasis low)
    (dirty : Bool)
    (highState : PrimitiveBasis high) :
    eq38DirtyProtocolEquiv k low high
        ((controls, lowState), dirty, highState) =
      if allControlsActive controls = true then
        ((controls, basisModularIncrementEquiv low lowState),
          dirty,
          if allControlsActive lowState = true then
            basisModularIncrementEquiv high highState
          else highState)
      else
        ((controls, lowState), dirty, highState) := by
  unfold eq38DirtyProtocolEquiv
  rw [dirtyHighIncrement_action]
  by_cases external : allControlsActive controls = true
  · rw [if_pos external]
    by_cases carry : allControlsActive lowState = true
    · rw [if_pos carry]
      have dirtyActive : dirtyCarryActive (controls, lowState) = true :=
        (dirtyCarryActive_true_iff controls lowState).2 ⟨external, carry⟩
      simp [externallyControlledLowAfterDirtyEquiv,
        external, dirtyActive]
    · rw [if_neg carry]
      have dirtyInactive : dirtyCarryActive (controls, lowState) = false := by
        cases condition : dirtyCarryActive (controls, lowState)
        · rfl
        · exfalso
          exact carry
            (dirtyCarryActive_true_iff controls lowState).1 condition
      simp [externallyControlledLowAfterDirtyEquiv,
        external, dirtyInactive]
  · rw [if_neg external]
    have dirtyInactive : dirtyCarryActive (controls, lowState) = false := by
      cases condition : dirtyCarryActive (controls, lowState)
      · rfl
      · exfalso
        exact external
          ((dirtyCarryActive_true_iff controls lowState).1 condition).1
    simp [externallyControlledLowAfterDirtyEquiv,
      external, dirtyInactive]

/-- The borrowed dirty promise bit is restored by the complete protocol. -/
theorem eq38DirtyProtocol_restores_dirty
    (k low high : Nat)
    (controls : PrimitiveBasis k)
    (lowState : PrimitiveBasis low)
    (dirty : Bool)
    (highState : PrimitiveBasis high) :
    (eq38DirtyProtocolEquiv k low high
      ((controls, lowState), dirty, highState)).2.1 = dirty := by
  rw [eq38DirtyProtocol_action]
  split <;> rfl

/-- The dirty and clean Equation-(38) implementations induce the same target
low/high pair for every incoming dirty value. -/
theorem dirty_targets_match_clean
    (k low high : Nat)
    (controls : PrimitiveBasis k)
    (lowState : PrimitiveBasis low)
    (dirty : Bool)
    (highState : PrimitiveBasis high) :
    let dirtyOutput :=
      eq38DirtyProtocolEquiv k low high
        ((controls, lowState), dirty, highState)
    let cleanOutput :=
      eq38CleanProtocolEquiv k low high
        (controls, (0, (lowState, highState)))
    (dirtyOutput.1.2, dirtyOutput.2.2) = cleanOutput.2.2 := by
  dsimp
  rw [eq38DirtyProtocol_action, eq38CleanProtocol_action]
  by_cases external : allControlsActive controls = true <;>
    simp [external]

/-- Recombined dirty-protocol target is exactly the public whole-word
controlled modular increment, independently of the incoming dirty bit. -/
theorem eq38DirtyProtocol_matches_wholeWord
    (k low high : Nat)
    (controls : PrimitiveBasis k)
    (lowState : PrimitiveBasis low)
    (dirty : Bool)
    (highState : PrimitiveBasis high) :
    let output :=
      eq38DirtyProtocolEquiv k low high
        ((controls, lowState), dirty, highState)
    combineBasis low high (output.1.2, output.2.2) =
      (wholeWordControlledIncrementEquiv k low high
        (controls, combineBasis low high (lowState, highState))).2 := by
  dsimp
  have targetMatch := dirty_targets_match_clean
    k low high controls lowState dirty highState
  rw [targetMatch]
  exact eq38CleanProtocol_matches_wholeWord
    k low high controls lowState highState

/-- Source half-width specialization. -/
theorem eq38DirtyHalfSplit_matches_semantic_target
    (k n : Nat)
    (controls : PrimitiveBasis k)
    (lowState : PrimitiveBasis (eq38LowWidth n))
    (dirty : Bool)
    (highState : PrimitiveBasis (eq38HighWidth n)) :
    let output :=
      eq38DirtyProtocolEquiv k (eq38LowWidth n) (eq38HighWidth n)
        ((controls, lowState), dirty, highState)
    combineBasis (eq38LowWidth n) (eq38HighWidth n)
        (output.1.2, output.2.2) =
      (eq38SemanticEquiv k n
        (controls,
          combineBasis (eq38LowWidth n) (eq38HighWidth n)
            (lowState, highState))).2 := by
  simpa [eq38SemanticEquiv, wholeWordControlledIncrementEquiv] using
    (eq38DirtyProtocol_matches_wholeWord
      k (eq38LowWidth n) (eq38HighWidth n)
      controls lowState dirty highState)

/-- Ancilla side-condition: for `n>=3`, the internal Equation-(38) clean
substitutes and this one borrowed dirty bit fit in the source promise register. -/
theorem eq38DirtyProtocol_fits_promise_budget
    {n : Nat} (large : 3 ≤ n) :
    halfIncrementCleanNeed n + reservedDirtyPromiseBits n ≤
      lemmaSevenPromiseWidth n :=
  halfClean_plus_dirty_le_promiseWidth large

end ComparatorIncrementerLemma7Eq38DirtyProtocol
end QuantumBlockEncoding
