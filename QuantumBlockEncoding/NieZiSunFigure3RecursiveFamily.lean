import QuantumBlockEncoding.NieZiSunControlSplit
import QuantumBlockEncoding.NieZiSunControlSplitAllOne
import QuantumBlockEncoding.NieZiSunFigure3FirstHalf
import QuantumBlockEncoding.PromiseGateOptimization
import QuantumBlockEncoding.VandaeleLemma1Contract
import Mathlib.Tactic

/-!
# Recursive semantic family for Nie--Zi--Sun Theorem 1

This module removes the remaining semantic recursion parameter from Figure 3.
For small control width we use the direct canonical multi-controlled-X
permutation.  For n>=5 we split the physical controls into four head wires and
two smaller tails, recursively construct their first halves, and feed those
halves into the source Figure-3 protocol.

The resulting family is still a *logical/macro* circuit family: this file proves
the source recursion and exact basis action, while the subsequent B2 realization
layer assigns concrete CNOT/single-qubit schedules to the constant-size Figure-3
macros.  This separation is essential because Nie--Zi--Sun work over B2, not the
ASPBE reversible gate IR.
-/

namespace QuantumBlockEncoding
namespace NieZiSunFigure3RecursiveFamily

open NieZiSunControlSplit
open NieZiSunControlSplitAllOne
open NieZiSunFigure3FirstHalf
open NieZiSunFigure3Protocol
open NieZiSunFigure3Resource
open VandaeleLemma1Contract

/-- Direct small-width half computation: preserve work and flip target by the
full control conjunction. -/
def directHalfAction (n : Nat)
    (state : PrimitiveBasis n × Fin 2 × Fin 2) :
    PrimitiveBasis n × Fin 2 × Fin 2 :=
  if active : allOne state.1 then
    (state.1,state.2.1,flipBit state.2.2)
  else state

/-- Direct half is involutory. -/
theorem directHalfAction_involutive (n : Nat) :
    Function.Involutive (directHalfAction n) := by
  intro state
  by_cases active : allOne state.1
  · simp [directHalfAction, active, flipBit_flipBit]
  · simp [directHalfAction, active]

/-- Proof-bearing direct half. -/
def directHalf (n : Nat) : HalfComputation n where
  forward :=
    { toFun := directHalfAction n
      invFun := directHalfAction n
      left_inv := directHalfAction_involutive n
      right_inv := directHalfAction_involutive n }
  cleanTarget := by
    intro group
    by_cases active : allOne group
    · simp [directHalfAction, active, flipBit]
    · simp [directHalfAction, active]

/-- The actual recursive first-half family. -/
def halfFamily : (n : Nat) → HalfComputation n
  | 0 => directHalf 0
  | 1 => directHalf 1
  | 2 => directHalf 2
  | 3 => directHalf 3
  | 4 => directHalf 4
  | n + 5 =>
      asHalfComputation
        (halfFamily (leftTailWidth (n + 5)))
        (halfFamily (rightTailWidth (n + 5)))
        (splitControls (n + 5) (by omega))
termination_by n => n

decreasing_by
  all_goals
    unfold leftTailWidth rightTailWidth
    omega

/-- Every recursive tail is genuinely smaller, matching the termination proof. -/
theorem halfFamily_tail_smaller
    {n : Nat} (large : 5 ≤ n) :
    leftTailWidth n < n ∧ rightTailWidth n < n := by
  unfold leftTailWidth rightTailWidth
  omega

/-- Public midpoint theorem of the recursively constructed half family. -/
theorem halfFamily_cleanTarget
    (n : Nat) (controls : PrimitiveBasis n) :
    ((halfFamily n).forward (controls,0,0)).2.2 =
      if allOne controls then 1 else 0 :=
  (halfFamily n).cleanTarget controls

/-- Complete one-level Figure-3 permutation in source coordinates. -/
def levelEquiv
    {leftWidth rightWidth : Nat}
    (left : HalfComputation leftWidth)
    (right : HalfComputation rightWidth) :
    Equiv.Perm (Figure3State leftWidth rightWidth) :=
  ((((step1Equiv.trans (step2Equiv left right)).trans step3Equiv).trans
      (step2Equiv left right).symm).trans step1Equiv)

/-- Its action is exactly the five-step source protocol. -/
theorem levelEquiv_apply
    {leftWidth rightWidth : Nat}
    (left : HalfComputation leftWidth)
    (right : HalfComputation rightWidth)
    (state : Figure3State leftWidth rightWidth) :
    levelEquiv left right state = protocol left right state := by
  rfl

/-- Coordinate equivalence for the complete `(controls,work,target)` register. -/
def fullCoordinate
    (n : Nat) (large : 4 ≤ n) :
    (PrimitiveBasis n × Fin 2 × Fin 2) ≃
      Figure3State (leftTailWidth n) (rightTailWidth n) where
  toFun state :=
    let parts := splitControls n large state.1
    (parts.1,parts.2.1,parts.2.2,state.2.1,state.2.2)
  invFun state :=
    ((splitControls n large).symm (state.1,state.2.1,state.2.2.1),
      state.2.2.2.1,state.2.2.2.2)
  left_inv state := by
    rcases state with ⟨controls,work,target⟩
    simp
  right_inv state := by
    rcases state with ⟨head,leftGroup,rightGroup,work,target⟩
    simp

/-- Recursive full Figure-3 circuit at a non-base width. -/
def recursiveFullEquiv
    (n : Nat) (large : 5 ≤ n) :
    Equiv.Perm (PrimitiveBasis n × Fin 2 × Fin 2) :=
  ((fullCoordinate n (by omega)).trans
      (levelEquiv
        (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n)))).trans
    (fullCoordinate n (by omega)).symm

/-- Totalized complete logical Figure-3 family. -/
def fullFamily (n : Nat) :
    Equiv.Perm (PrimitiveBasis n × Fin 2 × Fin 2) :=
  if large : 5 ≤ n then recursiveFullEquiv n large
  else (directHalf n).forward

/-- Direct source target in `(controls,work,target)` coordinates. -/
def desiredAction (n : Nat)
    (state : PrimitiveBasis n × Fin 2 × Fin 2) :
    PrimitiveBasis n × Fin 2 × Fin 2 :=
  if active : allOne state.1 then
    (state.1,state.2.1,flipBit state.2.2)
  else state

/-- Main semantic closure of the Figure-3 recursion on a clean ancillary bit. -/
theorem fullFamily_clean_action
    (n : Nat) (controls : PrimitiveBasis n) (target : Fin 2) :
    fullFamily n (controls,0,target) =
      if allOne controls then
        (controls,0,flipBit target)
      else (controls,0,target) := by
  by_cases large : 5 ≤ n
  · rw [show fullFamily n = recursiveFullEquiv n large by
      simp [fullFamily, large]]
    let parts := splitControls n (by omega) controls
    have source := protocol_correct
      (halfFamily (leftTailWidth n))
      (halfFamily (rightTailWidth n))
      parts.1 parts.2.1 parts.2.2 target
    have activation := allOne_split_iff (n := n) (by omega) controls
    unfold recursiveFullEquiv
    rw [levelEquiv_apply]
    simpa [fullCoordinate, parts, fullActive, activation] using source
  · have small : n < 5 := by omega
    simp [fullFamily, large, directHalf, directHalfAction]

/-- Package the public n-Toffoli target used by the downstream Vandaele source. -/
def promiseFirstCoordinate (n : Nat) :
    (Fin 2 × (PrimitiveBasis n × Fin 2)) ≃
      (PrimitiveBasis n × Fin 2 × Fin 2) where
  toFun state := (state.2.1,state.1,state.2.2)
  invFun state := (state.2.1,(state.1,state.2.2))
  left_inv state := by rcases state with ⟨work,controls,target⟩; rfl
  right_inv state := by rcases state with ⟨controls,work,target⟩; rfl

/-- Figure-3 family in clean-ancilla-first coordinates. -/
def cleanAncillaImplementation (n : Nat) :
    Equiv.Perm (Fin 2 × (PrimitiveBasis n × Fin 2)) :=
  ((promiseFirstCoordinate n).trans (fullFamily n)).trans
    (promiseFirstCoordinate n).symm

/-- The clean ancilla implementation is exactly a weak promise gate for C^n X.
This is the semantic content of Nie--Zi--Sun Theorem 1. -/
theorem cleanAncilla_weakPromise (n : Nat) :
    PromiseGateOptimization.WeakPromiseSpec
      (0 : Fin 2)
      (cleanAncillaImplementation n)
      (multiControlledXEquiv n) := by
  intro state
  rcases state with ⟨controls,target⟩
  rw [show cleanAncillaImplementation n (0,(controls,target)) =
      let output := fullFamily n (controls,0,target)
      (output.2.1,(output.1,output.2.2)) by rfl]
  rw [fullFamily_clean_action]
  by_cases active : allOne controls
  · have sourceActive : allControlsOne controls := by
      intro wire
      exact active wire
    simp [active, multiControlledXEquiv, multiControlledXAction, sourceActive]
  · have sourceInactive : ¬ allControlsOne controls := by
      intro all
      exact active all
    simp [active, multiControlledXEquiv, multiControlledXAction, sourceInactive]

end NieZiSunFigure3RecursiveFamily
end QuantumBlockEncoding
