import QuantumBlockEncoding.ComparatorIncrementerLemma7Eq38CleanProtocol
import QuantumBlockEncoding.ComparatorIncrementerLemma7Eq38Semantics
import QuantumBlockEncoding.PrimitiveBasisRegisterSplit
import Mathlib.Tactic

/-!
# Equation (38): product-register / whole-word commuting bridge

The clean carry protocol acts on separate low and high basis registers, while
the public Lemma-7 target is one n-bit modular incrementer.  This file proves
that the two views are exactly the same operation.

The central predicate identity is

`low overflows under +1  <->  low is the all-ones bit string`.

Together with the little-endian register recomposition theorem, this identifies
the clean protocol's low successor, carry, and high successor with the existing
`ComparatorIncrementerControlledSplit` arithmetic and then with the transported
whole-word modular incrementer.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma7Eq38Bridge

open ComparatorIncrementerControlledSplit
open ComparatorIncrementerEq40ControlInvariant
open ComparatorIncrementerGeneral
open ComparatorIncrementerLemma7Contract
open ComparatorIncrementerLemma7Eq38CleanProtocol
open PredicateControlledConjugation
open PrimitiveBasisRegisterSplit
open ZModPrimitiveBasisBridge

/-- Flat integer represented by one explicit low/high basis pair. -/
def combinedIndex
    (low high : Nat)
    (lowState : PrimitiveBasis low)
    (highState : PrimitiveBasis high) :
    Fin (gridSize (low + high)) :=
  primitiveBasisLEEquiv (low + high)
    (combineBasis low high (lowState, highState))

@[simp] theorem combinedIndex_value
    (low high : Nat)
    (lowState : PrimitiveBasis low)
    (highState : PrimitiveBasis high) :
    (combinedIndex low high lowState highState).val =
      (primitiveBasisLEEquiv low lowState).val +
        gridSize low * (primitiveBasisLEEquiv high highState).val := by
  exact primitiveBasisLEEquiv_combineBasis_value
    low high (lowState, highState)

/-- All-ones control is equivalent to the maximum little-endian value. -/
theorem allControlsActive_iff_value_max
    (width : Nat) (state : PrimitiveBasis width) :
    allControlsActive state = true ↔
      (primitiveBasisLEEquiv width state).val = gridSize width - 1 := by
  constructor
  · intro active
    have stateEq := state_eq_allOnes_of_active state active
    rw [stateEq]
    exact primitiveBasisLEEquiv_allOnes_value width
  · intro valueMax
    have stateEq : state = allOnesBasisState width := by
      apply (primitiveBasisLEEquiv width).injective
      apply Fin.ext
      rw [valueMax, primitiveBasisLEEquiv_allOnes_value]
    rw [stateEq]
    exact allOnes_active width

/-- For a value already inside `[0,2^width)`, adding one is divisible by the
modulus exactly at the maximal value. -/
theorem successor_divisible_iff_max
    (width : Nat) (value : Fin (gridSize width)) :
    gridSize width ∣ value.val + 1 ↔
      value.val = gridSize width - 1 := by
  rw [Nat.dvd_iff_mod_eq_zero]
  have sizePos : 0 < gridSize width := Nat.pow_pos (by decide)
  have valueLt := value.isLt
  constructor
  · intro modZero
    by_cases maximal : value.val + 1 = gridSize width
    · omega
    · have below : value.val + 1 < gridSize width := by omega
      rw [Nat.mod_eq_of_lt below] at modZero
      omega
  · intro maximal
    have successorEq : value.val + 1 = gridSize width := by omega
    rw [successorEq, Nat.mod_self]

/-- The source overflow predicate on a combined word is exactly the all-ones
predicate on its explicit low register. -/
theorem combined_low_overflow_iff_allOnes
    (low high : Nat)
    (lowState : PrimitiveBasis low)
    (highState : PrimitiveBasis high) :
    gridSize low ∣
        (combinedIndex low high lowState highState).val + 1 ↔
      allControlsActive lowState = true := by
  have lowMod := primitiveBasisLEEquiv_combineBasis_mod_low
    low high (lowState, highState)
  have successorMod :
      ((combinedIndex low high lowState highState).val + 1) % gridSize low =
        ((primitiveBasisLEEquiv low lowState).val + 1) % gridSize low := by
    rw [Nat.add_mod, Nat.add_mod, lowMod]
  rw [Nat.dvd_iff_mod_eq_zero, successorMod]
  have maxIff :
      ((primitiveBasisLEEquiv low lowState).val + 1) % gridSize low = 0 ↔
        (primitiveBasisLEEquiv low lowState).val = gridSize low - 1 := by
    have lowIndex := primitiveBasisLEEquiv low lowState
    exact successor_divisible_iff_max low lowIndex
  exact maxIff.trans (allControlsActive_iff_value_max low lowState).symm

/-- Low successor in the numerical split is exactly the value of the actual
low-register basis incrementer. -/
theorem incrementLowValue_combined
    (low high : Nat)
    (lowState : PrimitiveBasis low)
    (highState : PrimitiveBasis high) :
    incrementLowValue low high (combinedIndex low high lowState highState) =
      (primitiveBasisLEEquiv low
        (basisModularIncrementEquiv low lowState)).val := by
  have lowMod := primitiveBasisLEEquiv_combineBasis_mod_low
    low high (lowState, highState)
  have successorMod :
      ((combinedIndex low high lowState highState).val + 1) % gridSize low =
        ((primitiveBasisLEEquiv low lowState).val + 1) % gridSize low := by
    rw [Nat.add_mod, Nat.add_mod, lowMod]
  have increment := basisModularIncrement_satisfies_spec low lowState
  unfold IncrementerSpec basisNat at increment
  unfold incrementLowValue
  rw [successorMod]
  exact increment.symm

/-- Carry bit of the numerical split is one exactly on the clean protocol's
all-ones low-register branch. -/
theorem incrementCarry_combined_eq_one_iff
    (low high : Nat)
    (lowState : PrimitiveBasis low)
    (highState : PrimitiveBasis high) :
    incrementCarry low high (combinedIndex low high lowState highState) = 1 ↔
      allControlsActive lowState = true := by
  rw [incrementCarry_eq_one_iff]
  exact combined_low_overflow_iff_allOnes low high lowState highState

/-- The numerical high successor agrees with the high basis register produced
by the clean protocol. -/
theorem incrementHighValue_combined
    (low high : Nat)
    (lowState : PrimitiveBasis low)
    (highState : PrimitiveBasis high) :
    incrementHighValue low high (combinedIndex low high lowState highState) =
      if allControlsActive lowState = true then
        (primitiveBasisLEEquiv high
          (basisModularIncrementEquiv high highState)).val
      else
        (primitiveBasisLEEquiv high highState).val := by
  have highDiv := primitiveBasisLEEquiv_combineBasis_div_low
    low high (lowState, highState)
  by_cases carry : allControlsActive lowState = true
  · rw [if_pos carry]
    have carryOne :
        incrementCarry low high (combinedIndex low high lowState highState) = 1 :=
      (incrementCarry_combined_eq_one_iff low high lowState highState).2 carry
    have increment := basisModularIncrement_satisfies_spec high highState
    unfold IncrementerSpec basisNat at increment
    unfold incrementHighValue
    rw [highDiv, carryOne]
    exact increment.symm
  · rw [if_neg carry]
    have carryNotOne :
        incrementCarry low high (combinedIndex low high lowState highState) ≠ 1 := by
      intro equal
      exact carry
        ((incrementCarry_combined_eq_one_iff low high lowState highState).1 equal)
    have carryZero :
        incrementCarry low high (combinedIndex low high lowState highState) = 0 := by
      have atMostOne := incrementCarry_le_one
        low high (combinedIndex low high lowState highState)
      omega
    unfold incrementHighValue
    rw [highDiv, carryZero, Nat.add_zero]
    exact Nat.mod_eq_of_lt (primitiveBasisLEEquiv high highState).isLt

/-- Whole-word target used on the right side of the commuting square. -/
def wholeWordControlledIncrementEquiv (k low high : Nat) :
    Equiv.Perm
      (PrimitiveBasis k × PrimitiveBasis (low + high)) :=
  predicateControlledTargetEquiv
    allControlsActive (basisModularIncrementEquiv (low + high))

/-- Main Equation-(38) commuting theorem.  Starting with a clean carry flag,
run the explicit low/high compute-use-uncompute protocol, discard the restored
flag, and combine the two target registers.  The result is exactly the public
whole-word controlled modular increment target. -/
theorem eq38CleanProtocol_matches_wholeWord
    (k low high : Nat)
    (controls : PrimitiveBasis k)
    (lowState : PrimitiveBasis low)
    (highState : PrimitiveBasis high) :
    let output :=
      eq38CleanProtocolEquiv k low high
        (controls, (0, (lowState, highState)))
    combineBasis low high output.2.2 =
      (wholeWordControlledIncrementEquiv k low high
        (controls, combineBasis low high (lowState, highState))).2 := by
  dsimp
  rw [eq38CleanProtocol_action]
  by_cases external : allControlsActive controls = true
  · rw [if_pos external]
    simp [wholeWordControlledIncrementEquiv,
      predicateControlledTargetEquiv, external]
    apply (primitiveBasisLEEquiv (low + high)).injective
    apply Fin.ext
    rw [primitiveBasisLEEquiv_combineBasis_value]
    rw [incrementLowValue_combined low high lowState highState]
    rw [incrementHighValue_combined low high lowState highState]
    have recomposition := increment_eq_low_plus_high
      low high (combinedIndex low high lowState highState)
    have targetIncrement :=
      basisModularIncrement_satisfies_spec (low + high)
        (combineBasis low high (lowState, highState))
    unfold IncrementerSpec basisNat at targetIncrement
    rw [targetIncrement]
    exact recomposition.symm
  · rw [if_neg external]
    simp [wholeWordControlledIncrementEquiv,
      predicateControlledTargetEquiv, external]

/-- Source half-width specialization of the same commuting theorem. -/
theorem eq38HalfSplit_matches_semantic_target
    (k n : Nat)
    (controls : PrimitiveBasis k)
    (lowState : PrimitiveBasis (eq38LowWidth n))
    (highState : PrimitiveBasis (eq38HighWidth n)) :
    let output :=
      eq38CleanProtocolEquiv k (eq38LowWidth n) (eq38HighWidth n)
        (controls, (0, (lowState, highState)))
    combineBasis (eq38LowWidth n) (eq38HighWidth n) output.2.2 =
      (eq38SemanticEquiv k n
        (controls,
          combineBasis (eq38LowWidth n) (eq38HighWidth n)
            (lowState, highState))).2 := by
  exact eq38CleanProtocol_matches_wholeWord
    k (eq38LowWidth n) (eq38HighWidth n)
    controls lowState highState

end ComparatorIncrementerLemma7Eq38Bridge
end QuantumBlockEncoding
