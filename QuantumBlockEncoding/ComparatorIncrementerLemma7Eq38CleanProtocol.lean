import QuantumBlockEncoding.ComparatorIncrementerEq40ControlInvariant
import QuantumBlockEncoding.ComparatorIncrementerLemma7Eq38Semantics
import Mathlib.Tactic

/-!
# Clean reversible protocol behind Vandaele Equation (38)

The numerical half-split theorem does not by itself explain why the auxiliary
carry qubit can be cleaned.  This file records the reversible compute/use/
uncompute mechanism.

For external controls `c`, low block `x`, clean flag `f=0`, and high block `y`:

1. toggle `f` iff all external controls are one and `x` is all ones;
2. increment `x` iff all external controls are one;
3. increment `y` iff `f=1`;
4. toggle `f` iff all external controls are one and the *new* low block is zero.

A modular increment maps the all-ones word exactly to zero.  Injectivity shows
that no other low input maps to zero.  Therefore steps 1 and 4 use equivalent
predicates on the active branch, and the clean carry flag is restored.

This is an exact basis-permutation protocol.  The source Figure-9/Eq.-(38)
program still has to refine this semantic object while using promise-register
workspace and satisfying the resource closure proved separately.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma7Eq38CleanProtocol

open ComparatorIncrementerEq40ControlInvariant
open ComparatorIncrementerLemma7Contract
open ZModPrimitiveBasisBridge

/-- Product-register state for the clean Eq.-(38) protocol. -/
abbrev Eq38CleanState (k low high : Nat) :=
  PrimitiveBasis k × (Fin 2 × (PrimitiveBasis low × PrimitiveBasis high))

/-- All bits of one register are zero. -/
def allZeroBits {n : Nat} (state : PrimitiveBasis n) : Prop :=
  ∀ wire, state wire = 0

/-- Toggle the clean carry flag on the pre-increment overflow predicate. -/
def computeCarryFlagEquiv (k low high : Nat) :
    Equiv.Perm (Eq38CleanState k low high) where
  toFun state :=
    let active :=
      allControlsActive state.1 = true ∧
        allControlsActive state.2.2.1 = true
    (state.1,
      (if active then flipBit state.2.1 else state.2.1,
        state.2.2))
  invFun state :=
    let active :=
      allControlsActive state.1 = true ∧
        allControlsActive state.2.2.1 = true
    (state.1,
      (if active then flipBit state.2.1 else state.2.1,
        state.2.2))
  left_inv state := by
    rcases state with ⟨controls, flag, lowState, highState⟩
    by_cases active :
        allControlsActive controls = true ∧
          allControlsActive lowState = true
    · simp [active, flipBit_flipBit]
    · simp [active]
  right_inv state := by
    rcases state with ⟨controls, flag, lowState, highState⟩
    by_cases active :
        allControlsActive controls = true ∧
          allControlsActive lowState = true
    · simp [active, flipBit_flipBit]
    · simp [active]

/-- Increment the low block under the external all-controls-one predicate. -/
def externallyControlledLowIncrementEquiv (k low high : Nat) :
    Equiv.Perm (Eq38CleanState k low high) where
  toFun state :=
    if allControlsActive state.1 = true then
      (state.1,
        (state.2.1,
          (basisModularIncrementEquiv low state.2.2.1,
            state.2.2.2)))
    else state
  invFun state :=
    if allControlsActive state.1 = true then
      (state.1,
        (state.2.1,
          ((basisModularIncrementEquiv low).symm state.2.2.1,
            state.2.2.2)))
    else state
  left_inv state := by
    rcases state with ⟨controls, flag, lowState, highState⟩
    by_cases active : allControlsActive controls = true <;>
      simp [active]
  right_inv state := by
    rcases state with ⟨controls, flag, lowState, highState⟩
    by_cases active : allControlsActive controls = true <;>
      simp [active]

/-- Use the carry flag to increment the high block. -/
def flagControlledHighIncrementEquiv (k low high : Nat) :
    Equiv.Perm (Eq38CleanState k low high) where
  toFun state :=
    if state.2.1 = 1 then
      (state.1,
        (state.2.1,
          (state.2.2.1,
            basisModularIncrementEquiv high state.2.2.2)))
    else state
  invFun state :=
    if state.2.1 = 1 then
      (state.1,
        (state.2.1,
          (state.2.2.1,
            (basisModularIncrementEquiv high).symm state.2.2.2)))
    else state
  left_inv state := by
    rcases state with ⟨controls, flag, lowState, highState⟩
    by_cases active : flag = 1 <;> simp [active]
  right_inv state := by
    rcases state with ⟨controls, flag, lowState, highState⟩
    by_cases active : flag = 1 <;> simp [active]

/-- Uncompute the carry using the post-increment zero predicate. -/
def uncomputeCarryFromZeroEquiv (k low high : Nat) :
    Equiv.Perm (Eq38CleanState k low high) where
  toFun state :=
    let active :=
      allControlsActive state.1 = true ∧ allZeroBits state.2.2.1
    (state.1,
      (if active then flipBit state.2.1 else state.2.1,
        state.2.2))
  invFun state :=
    let active :=
      allControlsActive state.1 = true ∧ allZeroBits state.2.2.1
    (state.1,
      (if active then flipBit state.2.1 else state.2.1,
        state.2.2))
  left_inv state := by
    rcases state with ⟨controls, flag, lowState, highState⟩
    by_cases active :
        allControlsActive controls = true ∧ allZeroBits lowState
    · simp [active, flipBit_flipBit]
    · simp [active]
  right_inv state := by
    rcases state with ⟨controls, flag, lowState, highState⟩
    by_cases active :
        allControlsActive controls = true ∧ allZeroBits lowState
    · simp [active, flipBit_flipBit]
    · simp [active]

/-- Complete clean Eq.-(38) compute/use/uncompute protocol. -/
def eq38CleanProtocolEquiv (k low high : Nat) :
    Equiv.Perm (Eq38CleanState k low high) :=
  (computeCarryFlagEquiv k low high).trans
    ((externallyControlledLowIncrementEquiv k low high).trans
      ((flagControlledHighIncrementEquiv k low high).trans
        (uncomputeCarryFromZeroEquiv k low high)))

/-- Boolean all-ones predicate determines the canonical all-ones basis state. -/
theorem state_eq_allOnes_of_active
    {n : Nat} (state : PrimitiveBasis n)
    (active : allControlsActive state = true) :
    state = allOnesBasisState n := by
  funext wire
  have bitOne := (allControlsActive_iff state).mp active wire
  rw [bitOne]
  symm
  exact allOnesBasisState_apply n wire

/-- Conversely the canonical all-ones state activates the predicate. -/
theorem allOnes_active (n : Nat) :
    allControlsActive (allOnesBasisState n) = true := by
  apply (allControlsActive_iff (allOnesBasisState n)).mpr
  exact allOnesBasisState_apply n

/-- A correct modular basis increment maps all ones to all zero. -/
theorem basisIncrement_allOnes_to_zero (n : Nat) :
    basisModularIncrementEquiv n (allOnesBasisState n) =
      zeroBasisState n :=
  incrementerSpec_allOnes_to_zero
    n (basisModularIncrementEquiv n)
    (basisModularIncrement_satisfies_spec n)

/-- No non-all-ones input can map to zero under the increment permutation. -/
theorem basisIncrement_ne_zero_of_not_allOnes
    {n : Nat} (state : PrimitiveBasis n)
    (inactive : allControlsActive state ≠ true) :
    basisModularIncrementEquiv n state ≠ zeroBasisState n := by
  intro mapsZero
  have onesMap := basisIncrement_allOnes_to_zero n
  have equalInput : state = allOnesBasisState n := by
    apply (basisModularIncrementEquiv n).injective
    calc
      basisModularIncrementEquiv n state = zeroBasisState n := mapsZero
      _ = basisModularIncrementEquiv n (allOnesBasisState n) := onesMap.symm
  apply inactive
  rw [equalInput]
  exact allOnes_active n

/-- Pointwise zero predicate for the canonical zero state. -/
theorem allZeroBits_zeroBasis (n : Nat) :
    allZeroBits (zeroBasisState n) := by
  intro wire
  rfl

/-- Non-all-ones inputs remain nonzero after increment. -/
theorem not_allZeroBits_increment_of_not_allOnes
    {n : Nat} (state : PrimitiveBasis n)
    (inactive : allControlsActive state ≠ true) :
    ¬ allZeroBits (basisModularIncrementEquiv n state) := by
  intro allZero
  apply basisIncrement_ne_zero_of_not_allOnes state inactive
  funext wire
  exact allZero wire

/-- Exact clean-flag action.  On the active external-control branch, the low
block always increments; the high block increments exactly when the pre-low
block was all ones.  The carry flag is restored to zero. -/
theorem eq38CleanProtocol_action
    (k low high : Nat)
    (controls : PrimitiveBasis k)
    (lowState : PrimitiveBasis low)
    (highState : PrimitiveBasis high) :
    eq38CleanProtocolEquiv k low high
        (controls, (0, (lowState, highState))) =
      if allControlsActive controls = true then
        (controls,
          (0,
            (basisModularIncrementEquiv low lowState,
              if allControlsActive lowState = true then
                basisModularIncrementEquiv high highState
              else highState)))
      else
        (controls, (0, (lowState, highState))) := by
  by_cases external : allControlsActive controls = true
  · rw [if_pos external]
    by_cases carry : allControlsActive lowState = true
    · rw [if_pos carry]
      have lowOnes := state_eq_allOnes_of_active lowState carry
      have lowZero :
          basisModularIncrementEquiv low lowState = zeroBasisState low := by
        rw [lowOnes]
        exact basisIncrement_allOnes_to_zero low
      have postZero :
          allZeroBits (basisModularIncrementEquiv low lowState) := by
        rw [lowZero]
        exact allZeroBits_zeroBasis low
      simp [eq38CleanProtocolEquiv, computeCarryFlagEquiv,
        externallyControlledLowIncrementEquiv,
        flagControlledHighIncrementEquiv, uncomputeCarryFromZeroEquiv,
        external, carry, postZero, flipBit]
    · rw [if_neg carry]
      have postNotZero :
          ¬ allZeroBits (basisModularIncrementEquiv low lowState) :=
        not_allZeroBits_increment_of_not_allOnes lowState carry
      simp [eq38CleanProtocolEquiv, computeCarryFlagEquiv,
        externallyControlledLowIncrementEquiv,
        flagControlledHighIncrementEquiv, uncomputeCarryFromZeroEquiv,
        external, carry, postNotZero, flipBit]
  · rw [if_neg external]
    simp [eq38CleanProtocolEquiv, computeCarryFlagEquiv,
      externallyControlledLowIncrementEquiv,
      flagControlledHighIncrementEquiv, uncomputeCarryFromZeroEquiv,
      external, flipBit]

/-- Promise-cleanliness consequence consumed by the eventual flat program. -/
theorem eq38CleanProtocol_restores_flag
    (k low high : Nat)
    (controls : PrimitiveBasis k)
    (lowState : PrimitiveBasis low)
    (highState : PrimitiveBasis high) :
    (eq38CleanProtocolEquiv k low high
      (controls, (0, (lowState, highState)))).2.1 = 0 := by
  rw [eq38CleanProtocol_action]
  split <;> rfl

/-- External controls are preserved by the complete clean protocol. -/
theorem eq38CleanProtocol_preserves_controls
    (k low high : Nat)
    (controls : PrimitiveBasis k)
    (lowState : PrimitiveBasis low)
    (highState : PrimitiveBasis high) :
    (eq38CleanProtocolEquiv k low high
      (controls, (0, (lowState, highState)))).1 = controls := by
  rw [eq38CleanProtocol_action]
  split <;> rfl

end ComparatorIncrementerLemma7Eq38CleanProtocol
end QuantumBlockEncoding
