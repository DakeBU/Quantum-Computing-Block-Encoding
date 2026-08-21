import QuantumBlockEncoding.ComparatorIncrementerEq40ControlInvariant
import QuantumBlockEncoding.VandaeleLemma1Contract
import Mathlib.Tactic

/-!
# Vandaele Equation (2): C^k X from increment and decrement

Section 2.1 transfers the known lower bounds for multi-controlled X gates to
incrementers. Equation (2) is the semantic reduction: regard the k control bits
as the low part of a `(k+1)`-bit word and the X target as its high bit.
Increment the whole `(k+1)`-bit word and then decrement only the low k-bit
register. If the low register was not all ones, the two low-register changes
cancel. If it was all ones, the full increment carries into the high bit and
the low decrement restores the all-ones controls. Hence exactly the target bit
is toggled on the all-ones control branch.

This file proves that reduction identity exactly and records the conditional
resource transfer in one fixed gate model.  The quantitative lower bound for
`C^k X` itself remains the external/source result represented by
`VandaeleLemma1Contract.BoundedGateLowerBoundTarget`; ASPBE does not manufacture
that theorem here.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLowerBoundReduction

open ComparatorIncrementerEq40ControlInvariant
open VandaeleLemma1Contract

/-- Maximum k-bit value, i.e. the all-ones control word. -/
def maxWord (k : Nat) : Fin (gridSize k) :=
  ⟨gridSize k - 1, by
    have positive := gridSize_pos k
    omega⟩

/-- Low-register modular successor plus the carry into the high target bit. -/
def incrementPair (k : Nat)
    (state : Fin (gridSize k) × Fin 2) : Fin (gridSize k) × Fin 2 :=
  if carry : state.1.val + 1 = gridSize k then
    (⟨0, gridSize_pos k⟩, flipBit state.2)
  else
    (⟨state.1.val + 1, by
      have bound := state.1.isLt
      omega⟩, state.2)

/-- Modular decrement of only the low k-bit register. -/
def decrementLow (k : Nat) (word : Fin (gridSize k)) : Fin (gridSize k) :=
  if zero : word.val = 0 then
    maxWord k
  else
    ⟨word.val - 1, by
      have bound := word.isLt
      omega⟩

/-- Equation (2) composite. -/
def eqTwoReduction (k : Nat)
    (state : Fin (gridSize k) × Fin 2) : Fin (gridSize k) × Fin 2 :=
  let afterIncrement := incrementPair k state
  (decrementLow k afterIncrement.1, afterIncrement.2)

/-- Semantic C^k X action in the integer-coded control register. -/
def multiControlledXAction (k : Nat)
    (state : Fin (gridSize k) × Fin 2) : Fin (gridSize k) × Fin 2 :=
  if state.1 = maxWord k then
    (state.1, flipBit state.2)
  else state

/-- Being the maximum finite word is exactly the arithmetic carry condition. -/
theorem eq_maxWord_iff_succ_eq_gridSize
    (k : Nat) (word : Fin (gridSize k)) :
    word = maxWord k ↔ word.val + 1 = gridSize k := by
  constructor
  · intro equal
    subst word
    simp [maxWord]
    have positive := gridSize_pos k
    omega
  · intro carry
    apply Fin.ext
    simp [maxWord]
    omega

/-- If the input is not maximal, successor followed by low decrement restores
it exactly and emits no high-bit carry. -/
theorem eqTwoReduction_nonmax
    (k : Nat) (state : Fin (gridSize k) × Fin 2)
    (nonmax : state.1 ≠ maxWord k) :
    eqTwoReduction k state = state := by
  have noCarry : state.1.val + 1 ≠ gridSize k := by
    intro carry
    exact nonmax ((eq_maxWord_iff_succ_eq_gridSize k state.1).mpr carry)
  have successorPositive : state.1.val + 1 ≠ 0 := by omega
  simp [eqTwoReduction, incrementPair, decrementLow, noCarry,
    successorPositive]

/-- On the all-ones controls, the full increment carries into the target and
the low decrement restores the all-ones word. -/
theorem eqTwoReduction_max
    (k : Nat) (target : Fin 2) :
    eqTwoReduction k (maxWord k, target) =
      (maxWord k, flipBit target) := by
  have carry : (maxWord k).val + 1 = gridSize k := by
    simp [maxWord]
    have positive := gridSize_pos k
    omega
  simp [eqTwoReduction, incrementPair, decrementLow, carry, maxWord]

/-- Exact Equation (2) identity: increment `(k+1)`-word semantics followed by
low-k decrement is the k-controlled X action. -/
theorem eqTwoReduction_eq_multiControlledX
    (k : Nat) (state : Fin (gridSize k) × Fin 2) :
    eqTwoReduction k state = multiControlledXAction k state := by
  by_cases active : state.1 = maxWord k
  · rcases state with ⟨word, target⟩
    subst word
    rw [eqTwoReduction_max]
    simp [multiControlledXAction]
  · rw [eqTwoReduction_nonmax k state active]
    simp [multiControlledXAction, active]

/-- The reduction preserves the entire k-bit control word. -/
theorem eqTwoReduction_preserves_controls
    (k : Nat) (state : Fin (gridSize k) × Fin 2) :
    (eqTwoReduction k state).1 = state.1 := by
  rw [eqTwoReduction_eq_multiControlledX]
  by_cases active : state.1 = maxWord k <;>
    simp [multiControlledXAction, active]

/-- The target toggles iff all k controls are one. -/
theorem eqTwoReduction_target
    (k : Nat) (state : Fin (gridSize k) × Fin 2) :
    (eqTwoReduction k state).2 =
      if state.1 = maxWord k then flipBit state.2 else state.2 := by
  rw [eqTwoReduction_eq_multiControlledX]
  by_cases active : state.1 = maxWord k <;>
    simp [multiControlledXAction, active]

/-! ## Conditional resource lower-bound transfer -/

/-- Resource statement justified by Equation (2) once concrete increment and
decrement implementations are supplied in one fixed gate model. -/
def EqTwoGateReductionBound
    (controlledXLower incrementGateCost decrementGateCost : Nat → Nat) : Prop :=
  ∀ k,
    controlledXLower k ≤
      incrementGateCost (k + 1) + decrementGateCost k

/-- Depth analogue for chronological composition in the same gate model. -/
def EqTwoDepthReductionBound
    (controlledXLower incrementDepth decrementDepth : Nat → Nat) : Prop :=
  ∀ k,
    controlledXLower k ≤
      incrementDepth (k + 1) + decrementDepth k

/-- If decrement is implemented by reversing the increment circuit, it has the
same gate count. Equation (2) then lower-bounds the sum of two adjacent
incrementer widths. -/
theorem gate_lower_transfers_to_adjacent_incrementers
    (controlledXLower incrementGateCost decrementGateCost : Nat → Nat)
    (reduction :
      EqTwoGateReductionBound
        controlledXLower incrementGateCost decrementGateCost)
    (inverseSameCost : ∀ k,
      decrementGateCost k = incrementGateCost k) :
    ∀ k,
      controlledXLower k ≤
        incrementGateCost (k + 1) + incrementGateCost k := by
  intro k
  simpa [inverseSameCost k] using reduction k

/-- The same adjacent-width transfer holds for depth when circuit reversal
preserves the certified depth. -/
theorem depth_lower_transfers_to_adjacent_incrementers
    (controlledXLower incrementDepth decrementDepth : Nat → Nat)
    (reduction :
      EqTwoDepthReductionBound
        controlledXLower incrementDepth decrementDepth)
    (inverseSameDepth : ∀ k,
      decrementDepth k = incrementDepth k) :
    ∀ k,
      controlledXLower k ≤
        incrementDepth (k + 1) + incrementDepth k := by
  intro k
  simpa [inverseSameDepth k] using reduction k

/-- With monotonic minimum gate complexity, the adjacent-width inequality gives
`L(k) <= 2*C(k+1)`. -/
theorem gate_lower_transfers_of_monotone
    (controlledXLower incrementGateCost : Nat → Nat)
    (adjacent : ∀ k,
      controlledXLower k ≤
        incrementGateCost (k + 1) + incrementGateCost k)
    (monotone : ∀ k,
      incrementGateCost k ≤ incrementGateCost (k + 1)) :
    ∀ k,
      controlledXLower k ≤ 2 * incrementGateCost (k + 1) := by
  intro k
  have source := adjacent k
  have order := monotone k
  omega

/-- Depth counterpart of the monotone transfer. -/
theorem depth_lower_transfers_of_monotone
    (controlledXLower incrementDepth : Nat → Nat)
    (adjacent : ∀ k,
      controlledXLower k ≤
        incrementDepth (k + 1) + incrementDepth k)
    (monotone : ∀ k,
      incrementDepth k ≤ incrementDepth (k + 1)) :
    ∀ k,
      controlledXLower k ≤ 2 * incrementDepth (k + 1) := by
  intro k
  have source := adjacent k
  have order := monotone k
  omega

/-- Explicit lower-bound target inherited by incrementers after the Equation-(2)
reduction.  This formulation avoids division of natural-number constants:
`k <= 2*C(k+1)` and `log2(k+1) <= 2*D(k+1)` are already uniform linear and
logarithmic lower bounds up to a fixed factor. -/
def IncrementerTransferredLowerBoundTarget
    (incrementGateCost incrementDepth : Nat → Nat) : Prop :=
  (∀ k, k ≤ 2 * incrementGateCost (k + 1)) ∧
  (∀ k, Nat.log2 (k + 1) ≤ 2 * incrementDepth (k + 1))

/-- The external bounded-gate lower bound for `C^k X`, the exact Equation-(2)
resource reduction, circuit-reversal invariance, and monotonicity of *minimum*
incrementer complexity together imply explicit linear/logarithmic incrementer
lower bounds.

The theorem is intentionally conditional on the gate-model quantities supplied
by the caller.  In particular, it does not identify an arbitrary candidate
circuit's cost with the minimum complexity. -/
theorem transferred_incrementer_lower_bound
    (controlledXGateLower controlledXDepthLower : Nat → Nat)
    (incrementGateCost incrementDepth : Nat → Nat)
    (decrementGateCost decrementDepth : Nat → Nat)
    (externalLower :
      BoundedGateLowerBoundTarget
        controlledXGateLower controlledXDepthLower)
    (gateReduction :
      EqTwoGateReductionBound
        controlledXGateLower incrementGateCost decrementGateCost)
    (depthReduction :
      EqTwoDepthReductionBound
        controlledXDepthLower incrementDepth decrementDepth)
    (inverseSameCost : ∀ k,
      decrementGateCost k = incrementGateCost k)
    (inverseSameDepth : ∀ k,
      decrementDepth k = incrementDepth k)
    (gateMonotone : ∀ k,
      incrementGateCost k ≤ incrementGateCost (k + 1))
    (depthMonotone : ∀ k,
      incrementDepth k ≤ incrementDepth (k + 1)) :
    IncrementerTransferredLowerBoundTarget
      incrementGateCost incrementDepth := by
  rcases externalLower with
    ⟨⟨gateConstant, gatePositive, gateLower⟩,
      ⟨depthConstant, depthPositive, depthLower⟩⟩
  have adjacentGate :=
    gate_lower_transfers_to_adjacent_incrementers
      controlledXGateLower incrementGateCost decrementGateCost
      gateReduction inverseSameCost
  have adjacentDepth :=
    depth_lower_transfers_to_adjacent_incrementers
      controlledXDepthLower incrementDepth decrementDepth
      depthReduction inverseSameDepth
  have gateTransfer :=
    gate_lower_transfers_of_monotone
      controlledXGateLower incrementGateCost adjacentGate gateMonotone
  have depthTransfer :=
    depth_lower_transfers_of_monotone
      controlledXDepthLower incrementDepth adjacentDepth depthMonotone
  constructor
  · intro k
    have unitLe : 1 ≤ gateConstant := by omega
    have scaled : k ≤ gateConstant * k := by
      have := Nat.mul_le_mul_right k unitLe
      simpa using this
    exact scaled.trans ((gateLower k).trans (gateTransfer k))
  · intro k
    have unitLe : 1 ≤ depthConstant := by omega
    have scaled :
        Nat.log2 (k + 1) ≤
          depthConstant * Nat.log2 (k + 1) := by
      have := Nat.mul_le_mul_right (Nat.log2 (k + 1)) unitLe
      simpa using this
    exact scaled.trans ((depthLower k).trans (depthTransfer k))

end ComparatorIncrementerLowerBoundReduction
end QuantumBlockEncoding