import QuantumBlockEncoding.VandaeleLemma5Contract
import QuantumBlockEncoding.PromiseGateOptimization
import Mathlib.Tactic

/-!
# Vandaele Lemma 5: Equations (13) and (14)

The source proof has two exact circuit identities.

Equation (13), for a singly controlled product of `n` independent involutions,
uses the main control directly for one component and one dirty bit for each
remaining component.  Every remaining `Uᵢ` is used twice under its dirty flag,
with the flag toggled twice by the main control.  Thus `n` source gates require
`n-1` dirty bits.

Equation (14), for k>1 controls, treats the complete product layer as one
involution.  The generic dirty-control identity then uses two predicate toggles
(two `C^k X` gates in the source) and two singly controlled product instances.

This module formalizes those semantic identities exactly.  The next source
layer is the no-ancilla scheduling trick: split the independent gates into two
halves and borrow qubits from one half as the dirty workspace for the other,
while implementing the simultaneous flag toggles with low-depth fan-out.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma5Equations13_14

open PromiseGateOptimization
open VandaeleLemma5Contract

/-- Equation (13) with `tailCount+1` independent target gates and exactly
`tailCount` dirty flags. -/
abbrev Eq13State (tailCount : Nat) (α : Type*) :=
  Bool × (Fin tailCount → Bool) × (Fin (tailCount + 1) → α)

/-- Target output produced by the literal Eq. (13) dirty protocols.
The first component is controlled directly by the main bit; each successor
component uses one independent dirty flag. -/
def eq13Targets {α : Type*} {tailCount : Nat}
    (gates : Fin (tailCount + 1) → Equiv.Perm α)
    (state : Eq13State tailCount α) : Fin (tailCount + 1) → α :=
  Fin.cases
    (if state.1 then gates 0 (state.2.2 0) else state.2.2 0)
    (fun index =>
      (dirtyControlledInvolutionEquiv
        (fun control : Bool => control)
        (gates index.succ)
        (state.1, state.2.1 index, state.2.2 index.succ)).2.2)

/-- Dirty-register output of the same literal protocols. -/
def eq13Dirty {α : Type*} {tailCount : Nat}
    (gates : Fin (tailCount + 1) → Equiv.Perm α)
    (state : Eq13State tailCount α) : Fin tailCount → Bool :=
  fun index =>
    (dirtyControlledInvolutionEquiv
      (fun control : Bool => control)
      (gates index.succ)
      (state.1, state.2.1 index, state.2.2 index.succ)).2.1

/-- Literal Eq. (13) protocol action. -/
def eq13ProtocolAction {α : Type*} {tailCount : Nat}
    (gates : Fin (tailCount + 1) → Equiv.Perm α)
    (state : Eq13State tailCount α) : Eq13State tailCount α :=
  (state.1, eq13Dirty gates state, eq13Targets gates state)

/-- Ideal singly controlled product action. -/
def eq13IdealAction {α : Type*} {tailCount : Nat}
    (gates : Fin (tailCount + 1) → Equiv.Perm α)
    (state : Eq13State tailCount α) : Eq13State tailCount α :=
  (state.1, state.2.1,
    fun index =>
      if state.1 then gates index (state.2.2 index)
      else state.2.2 index)

/-- Each dirty flag in Equation (13) is restored exactly. -/
theorem eq13Dirty_restored
    {α : Type*} {tailCount : Nat}
    (gates : Fin (tailCount + 1) → Equiv.Perm α)
    (involutory : AllInvolutory gates)
    (state : Eq13State tailCount α) :
    eq13Dirty gates state = state.2.1 := by
  funext index
  have local := dirtyControlledInvolution_action
    (fun control : Bool => control)
    (gates index.succ)
    (involutory index.succ)
    state.1 (state.2.1 index) (state.2.2 index.succ)
  exact congrArg (fun result => result.2.1) local

/-- Every target component of Equation (13) equals the ideal singly controlled
product action. -/
theorem eq13Targets_correct
    {α : Type*} {tailCount : Nat}
    (gates : Fin (tailCount + 1) → Equiv.Perm α)
    (involutory : AllInvolutory gates)
    (state : Eq13State tailCount α) :
    eq13Targets gates state =
      fun index =>
        if state.1 then gates index (state.2.2 index)
        else state.2.2 index := by
  funext index
  refine Fin.cases ?_ (fun tail => ?_) index
  · rfl
  · have local := dirtyControlledInvolution_action
      (fun control : Bool => control)
      (gates tail.succ)
      (involutory tail.succ)
      state.1 (state.2.1 tail) (state.2.2 tail.succ)
    exact congrArg (fun result => result.2.2) local

/-- Exact Equation (13) identity. -/
theorem eq13Protocol_eq_ideal
    {α : Type*} {tailCount : Nat}
    (gates : Fin (tailCount + 1) → Equiv.Perm α)
    (involutory : AllInvolutory gates)
    (state : Eq13State tailCount α) :
    eq13ProtocolAction gates state = eq13IdealAction gates state := by
  unfold eq13ProtocolAction eq13IdealAction
  rw [eq13Dirty_restored gates involutory state]
  rw [eq13Targets_correct gates involutory state]

/-- Source bookkeeping for Equation (13) with `tailCount+1` gates. -/
structure Eq13ProtocolCost where
  sourceGates : Nat
  dirtyFlags : Nat
  directlyControlledUses : Nat
  dirtyControlledTargetUses : Nat
  dirtyPredicateToggles : Nat
  deriving DecidableEq, Repr

/-- Literal operation counts before the source's parallel fan-out scheduling. -/
def eq13ProtocolCost (tailCount : Nat) : Eq13ProtocolCost where
  sourceGates := tailCount + 1
  dirtyFlags := tailCount
  directlyControlledUses := 1
  dirtyControlledTargetUses := 2 * tailCount
  dirtyPredicateToggles := 2 * tailCount

@[simp] theorem eq13_uses_n_minus_one_dirty_flags (n : Nat) :
    (eq13ProtocolCost n).dirtyFlags = n := by
  rfl

/-! ## Equation (14): reduce k controls to two singly controlled instances -/

/-- The literal Eq. (14) protocol is exactly the generic dirty-controlled
involution protocol applied to the complete product layer.  `active` is the
k-control conjunction and the extra Bool is the borrowed dirty flag. -/
def eq14ProtocolEquiv {κ α : Type*} {n : Nat}
    (active : κ → Bool)
    (gates : Fin n → Equiv.Perm α) :
    Equiv.Perm (κ × Bool × (Fin n → α)) :=
  dirtyControlledInvolutionEquiv active (productEquiv gates)

/-- Exact Equation (14) action: the dirty bit is restored and the complete
product layer is applied iff all external controls are active. -/
theorem eq14Protocol_action
    {κ α : Type*} {n : Nat}
    (active : κ → Bool)
    (gates : Fin n → Equiv.Perm α)
    (involutory : AllInvolutory gates)
    (key : κ) (dirty : Bool) (state : Fin n → α) :
    eq14ProtocolEquiv active gates (key, dirty, state) =
      (key, dirty,
        if active key then productEquiv gates state else state) := by
  exact dirtyControlledInvolution_action
    active (productEquiv gates)
    (productEquiv_involutive gates involutory)
    key dirty state

/-- The borrowed dirty workspace in Equation (14) is restored unconditionally. -/
theorem eq14Protocol_restores_dirty
    {κ α : Type*} {n : Nat}
    (active : κ → Bool)
    (gates : Fin n → Equiv.Perm α)
    (involutory : AllInvolutory gates)
    (key : κ) (dirty : Bool) (state : Fin n → α) :
    (eq14ProtocolEquiv active gates (key, dirty, state)).2.1 = dirty := by
  rw [eq14Protocol_action active gates involutory key dirty state]

/-- Source bookkeeping for Equation (14): two k-control toggles and two singly
controlled product instances. -/
structure Eq14ProtocolCost where
  multiControlledXToggles : Nat
  singlyControlledProductUses : Nat
  borrowedDirtyFlags : Nat
  deriving DecidableEq, Repr

/-- Exact high-level operation count from the source identity. -/
def eq14ProtocolCost : Eq14ProtocolCost where
  multiControlledXToggles := 2
  singlyControlledProductUses := 2
  borrowedDirtyFlags := 1

@[simp] theorem eq14_cost_exact :
    eq14ProtocolCost =
      { multiControlledXToggles := 2,
        singlyControlledProductUses := 2,
        borrowedDirtyFlags := 1 } := by
  rfl

end VandaeleLemma5Equations13_14
end QuantumBlockEncoding
