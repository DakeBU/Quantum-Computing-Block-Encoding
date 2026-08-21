import QuantumBlockEncoding.StrongPromiseComputeUseUncompute
import QuantumBlockEncoding.VandaeleEquation58PromiseGadget
import Mathlib.Tactic

/-!
# Equation (58) is an instance of the generic promise pattern

`StrongPromiseComputeUseUncompute` isolates the general

`compute predicate ; use temporary flag ; uncompute predicate`

mechanism.  This file proves that Vandaele Equation (58) is literally that
mechanism after a register reassociation:

* key = the two controls `(a,b)`;
* promise flag = `p`;
* payload = `(c,t)`;
* compute predicate = `a AND b`;
* middle target = CNOT `c -> t`.

The identity makes Equation (58) a leaf of the shared promise-gate theorem
rather than an unrelated special-purpose proof.
-/

namespace QuantumBlockEncoding
namespace VandaeleEquation58GenericBridge

open StrongPromiseComputeUseUncompute
open VandaeleEquation58PromiseGadget

abbrev Key := Fin 2 × Fin 2
abbrev Payload := Fin 2 × Fin 2
abbrev GenericState := Key × Bool × Payload

/-- Predicate computed into the Equation-(58) promise bit. -/
def abActive (key : Key) : Bool :=
  if key.1 = 1 ∧ key.2 = 1 then true else false

/-- Middle payload operation: preserve c and toggle t iff c=1. -/
def cControlledXAction (state : Payload) : Payload :=
  (state.1, if state.1 = 1 then flipBit state.2 else state.2)

/-- The middle CNOT-style payload action is involutory. -/
theorem cControlledXAction_involutive :
    Function.Involutive cControlledXAction := by
  intro state
  rcases state with ⟨control,target⟩
  fin_cases control <;> fin_cases target <;> rfl

/-- Middle payload permutation used by the generic theorem. -/
def cControlledXEquiv : Equiv.Perm Payload where
  toFun := cControlledXAction
  invFun := cControlledXAction
  left_inv := cControlledXAction_involutive
  right_inv := cControlledXAction_involutive

/-- Reassociate `(a,b,c,p,t)` as `((a,b),p,(c,t))`. -/
def genericCoordinates : GadgetState ≃ GenericState where
  toFun state := ((state.1, state.2.1), state.2.2.2.1,
    (state.2.2.1, state.2.2.2.2))
  invFun state := (state.1.1, state.1.2, state.2.2.1,
    state.2.1, state.2.2.2)
  left_inv state := by
    rcases state with ⟨a,b,c,p,t⟩
    rfl
  right_inv state := by
    rcases state with ⟨⟨a,b⟩,p,c,t⟩
    rfl

/-- Generic compute/use/uncompute transported back to Equation-(58) coordinates. -/
def genericEquation58Equiv : Equiv.Perm GadgetState :=
  genericCoordinates.trans
    ((StrongPromiseComputeUseUncompute.implementation
      abActive cControlledXEquiv).trans genericCoordinates.symm)

/-- Exact structural identity: Equation (58) is the generic strong-promise
compute/use/uncompute construction. -/
theorem genericEquation58Equiv_eq_source :
    genericEquation58Equiv = equation58Equiv := by
  apply Equiv.ext
  intro state
  rcases state with ⟨a,b,c,p,t⟩
  fin_cases a <;> fin_cases b <;> fin_cases c <;>
    fin_cases p <;> fin_cases t <;> rfl

/-- The generic theorem therefore explains the source promise restoration; this
statement keeps that proof-graph edge explicit for downstream documentation. -/
theorem source_restoration_is_generic
    (state : GadgetState) :
    (genericEquation58Equiv state).2.2.2.1 = state.2.2.2.1 := by
  rw [genericEquation58Equiv_eq_source]
  exact restores_promise state

end VandaeleEquation58GenericBridge
end QuantumBlockEncoding
