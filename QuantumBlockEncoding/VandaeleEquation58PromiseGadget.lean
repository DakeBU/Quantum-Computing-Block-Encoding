import QuantumBlockEncoding.PrimitiveSemantics
import QuantumBlockEncoding.PromiseGateOptimization
import Mathlib.Tactic

/-!
# Vandaele Equation (58): CCX compute-use-uncompute promise gadget

Appendix A.1 replaces one middle multi-control dependency by introducing one
ancilla/promise bit in the three-CCX pattern

`compute ; use ; uncompute`.

For basis bits `(a,b,c,p,t)`:

1. compute `p <- p xor (a and b)`;
2. use p as one control of `t <- t xor (p and c)`;
3. repeat the first CCX, restoring p.

The promise bit p is restored for **every** incoming value.  On the designated
clean branch p=0, the target toggles exactly by `a and b and c`.  This is the
source mechanism used in Appendix A.1 and the strong-promise argument of
Corollary 4.

The target action away from p=0 is intentionally unconstrained by the promise
contract; it depends on the incoming dirty value, while restoration remains
exact.
-/

namespace QuantumBlockEncoding
namespace VandaeleEquation58PromiseGadget

open PromiseGateOptimization

/-- Compact product-coordinate state for Equation (58). -/
abbrev GadgetState := Fin 2 × Fin 2 × Fin 2 × Fin 2 × Fin 2

/-- Boolean CCX toggle on a target bit. -/
def ccxToggle (left right target : Fin 2) : Fin 2 :=
  if left = 1 ∧ right = 1 then flipBit target else target

/-- Compute the promise bit from controls a,b. -/
def compute (state : GadgetState) : GadgetState :=
  (state.1, state.2.1, state.2.2.1,
    ccxToggle state.1 state.2.1 state.2.2.2.1,
    state.2.2.2.2)

/-- Use the promise bit and control c to toggle the final target. -/
def use (state : GadgetState) : GadgetState :=
  (state.1, state.2.1, state.2.2.1, state.2.2.2.1,
    ccxToggle state.2.2.2.1 state.2.2.1 state.2.2.2.2)

/-- Complete Equation-(58) action. -/
def action (state : GadgetState) : GadgetState :=
  compute (use (compute state))

/-- One CCX-style toggle is self-inverse in its target. -/
theorem ccxToggle_involutive (left right : Fin 2) :
    Function.Involutive (ccxToggle left right) := by
  intro target
  by_cases active : left = 1 ∧ right = 1
  · simp [ccxToggle, active, flipBit_flipBit]
  · simp [ccxToggle, active]

/-- The compute map is self-inverse. -/
theorem compute_involutive : Function.Involutive compute := by
  intro state
  rcases state with ⟨a,b,c,p,t⟩
  simp [compute, ccxToggle_involutive]
  exact ccxToggle_involutive a b p

/-- The use map is self-inverse. -/
theorem use_involutive : Function.Involutive use := by
  intro state
  rcases state with ⟨a,b,c,p,t⟩
  simp [use]
  exact ccxToggle_involutive p c t

/-- Proof-bearing permutation of the Equation-(58) gadget. -/
def computeEquiv : Equiv.Perm GadgetState where
  toFun := compute
  invFun := compute
  left_inv := compute_involutive
  right_inv := compute_involutive

/-- Middle-use permutation. -/
def useEquiv : Equiv.Perm GadgetState where
  toFun := use
  invFun := use
  left_inv := use_involutive
  right_inv := use_involutive

/-- Exact three-CCX permutation. -/
def equation58Equiv : Equiv.Perm GadgetState :=
  (computeEquiv.trans useEquiv).trans computeEquiv

/-- External source controls a,b,c are preserved. -/
theorem preserves_controls (state : GadgetState) :
    (equation58Equiv state).1 = state.1 ∧
    (equation58Equiv state).2.1 = state.2.1 ∧
    (equation58Equiv state).2.2.1 = state.2.2.1 := by
  rfl

/-- Core Corollary-4 fact: the ancilla/promise bit is restored for arbitrary
initial contents. -/
theorem restores_promise (state : GadgetState) :
    (equation58Equiv state).2.2.2.1 = state.2.2.2.1 := by
  rcases state with ⟨a,b,c,p,t⟩
  by_cases ab : a = 1 ∧ b = 1
  · simp [equation58Equiv, computeEquiv, useEquiv,
      compute, use, ccxToggle, ab, flipBit_flipBit]
  · simp [equation58Equiv, computeEquiv, useEquiv,
      compute, use, ccxToggle, ab]

/-- On clean promise p=0, the target toggles iff all three source controls are
one. -/
theorem clean_target_action
    (a b c target : Fin 2) :
    (equation58Equiv (a,b,c,0,target)).2.2.2.2 =
      if a = 1 ∧ b = 1 ∧ c = 1 then flipBit target else target := by
  by_cases ab : a = 1 ∧ b = 1
  · rcases ab with ⟨ha,hb⟩
    subst a
    subst b
    fin_cases c <;> fin_cases target <;>
      rfl
  · by_cases abc : a = 1 ∧ b = 1 ∧ c = 1
    · exact (ab ⟨abc.1, abc.2.1⟩).elim
    · simp [equation58Equiv, computeEquiv, useEquiv,
        compute, use, ccxToggle, ab, abc]

/-- Promise-first state used by the reusable strong-promise interface. -/
abbrev PromiseState := Fin 2 × (Fin 2 × Fin 2 × Fin 2 × Fin 2)

/-- Reassociate the five bits so the promise is first. -/
def promiseFirstEquiv : GadgetState ≃ PromiseState where
  toFun state :=
    (state.2.2.2.1, (state.1, state.2.1, state.2.2.1, state.2.2.2.2))
  invFun state :=
    (state.2.1, state.2.2.1, state.2.2.2.1, state.1, state.2.2.2.2)
  left_inv state := by rcases state with ⟨a,b,c,p,t⟩; rfl
  right_inv state := by rcases state with ⟨p,a,b,c,t⟩; rfl

/-- Equation-(58) in promise-first coordinates. -/
def promiseImplementation : Equiv.Perm PromiseState :=
  promiseFirstEquiv.symm.trans (equation58Equiv.trans promiseFirstEquiv)

/-- Three-control target action on `(a,b,c,target)`. -/
def cleanTargetEquiv : Equiv.Perm (Fin 2 × Fin 2 × Fin 2 × Fin 2) where
  toFun state :=
    (state.1, state.2.1, state.2.2.1,
      if state.1 = 1 ∧ state.2.1 = 1 ∧ state.2.2.1 = 1 then
        flipBit state.2.2.2 else state.2.2.2)
  invFun state :=
    (state.1, state.2.1, state.2.2.1,
      if state.1 = 1 ∧ state.2.1 = 1 ∧ state.2.2.1 = 1 then
        flipBit state.2.2.2 else state.2.2.2)
  left_inv state := by
    rcases state with ⟨a,b,c,t⟩
    by_cases active : a = 1 ∧ b = 1 ∧ c = 1 <;>
      simp [active, flipBit_flipBit]
  right_inv state := by
    rcases state with ⟨a,b,c,t⟩
    by_cases active : a = 1 ∧ b = 1 ∧ c = 1 <;>
      simp [active, flipBit_flipBit]

/-- Exact strong-promise interpretation of Equation (58). -/
theorem equation58_strongPromise :
    StrongPromiseSpec 0 promiseImplementation cleanTargetEquiv := by
  constructor
  · intro value
    rcases value with ⟨a,b,c,t⟩
    apply Prod.ext
    · exact restores_promise (a,b,c,0,t)
    · apply Prod.ext
      · rfl
      · apply Prod.ext
        · rfl
        · apply Prod.ext
          · rfl
          · exact clean_target_action a b c t
  · intro promise value
    rcases value with ⟨a,b,c,t⟩
    exact restores_promise (a,b,c,promise,t)

/-- Source resource record of the gadget itself: three CCX gates and one
promise bit. -/
def logicalCCXCount : Nat := 3

def promiseBits : Nat := 1

@[simp] theorem logicalCCXCount_eq : logicalCCXCount = 3 := rfl
@[simp] theorem promiseBits_eq : promiseBits = 1 := rfl

end VandaeleEquation58PromiseGadget
end QuantumBlockEncoding
