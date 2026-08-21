import QuantumBlockEncoding.ComparatorIncrementerEq39LocalActivation
import QuantumBlockEncoding.ZModPrimitiveBasisBridge
import Mathlib.Tactic

/-!
# Basis-register semantics of Vandaele Equation (39)

The arithmetic Equation-(39) cascade is stated in mixed-radix digits.  Quantum
circuits act on computational-basis block registers.  This module connects the
two without choosing a particular gate synthesis.

For a stream of block widths `w_i`, a block state is a stream of
`PrimitiveBasis w_i`.  Its digit is the canonical little-endian `basisNat`.
Block i is incremented by the already-certified modular basis incrementer iff
the mixed-radix carry entering that block is one.

The resulting block-register function has exactly the mixed-radix output digits,
so every finite width partition summing to n recomposes to the n-bit modular
successor from Equation (39).
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerEq39BasisCascade

open scoped BigOperators
open ComparatorIncrementerEq39BlockCascade
open ComparatorIncrementerEq39LocalActivation
open ComparatorIncrementerGeneral
open MixedRadixIncrement
open ZModPrimitiveBasisBridge

/-- Heterogeneous stream of computational-basis block registers. -/
abbrev BlockBasisState (width : Nat → Nat) :=
  (i : Nat) → PrimitiveBasis (width i)

/-- Canonical mixed-radix digit represented by block i. -/
def basisDigit (width : Nat → Nat)
    (state : BlockBasisState width) (i : Nat) : Nat :=
  basisNat (width i) (state i)

/-- Every computational-basis block digit lies inside its power-of-two radix. -/
theorem basisDigit_lt_blockBase
    (width : Nat → Nat) (state : BlockBasisState width) (i : Nat) :
    basisDigit width state i < blockBase width i := by
  unfold basisDigit basisNat blockBase
  exact (primitiveBasisLEEquiv (width i) (state i)).isLt

/-- Digit stream of one heterogeneous basis state. -/
def basisDigits (width : Nat → Nat)
    (state : BlockBasisState width) : Nat → Nat :=
  fun i => basisDigit width state i

/-- Semantic Equation-(39) block cascade on basis registers.  This is not yet a
low-depth circuit: it applies the canonical block increment permutation exactly
on blocks whose incoming mixed-radix carry is one. -/
def cascadeOutput (width : Nat → Nat)
    (state : BlockBasisState width) : BlockBasisState width :=
  fun i =>
    if blockCarry width (basisDigits width state) i = 1 then
      basisModularIncrementEquiv (width i) (state i)
    else state i

/-- One output basis block represents exactly the corresponding mixed-radix
output digit. -/
theorem cascadeOutput_digit
    (width : Nat → Nat) (state : BlockBasisState width) (i : Nat) :
    basisDigit width (cascadeOutput width state) i =
      blockOutput width (basisDigits width state) i := by
  let digits := basisDigits width state
  have carryBound : blockCarry width digits i ≤ 1 :=
    carry_le_one (blockBase width) digits i
  by_cases active : blockCarry width digits i = 1
  · unfold cascadeOutput basisDigit
    rw [if_pos active]
    have increment := basisModularIncrement_satisfies_spec (width i) (state i)
    unfold ComparatorIncrementerGeneral.IncrementerSpec at increment
    rw [increment]
    simp [blockOutput, output, basisDigits, basisDigit, active, blockBase]
  · have inactive : blockCarry width digits i = 0 := by omega
    unfold cascadeOutput basisDigit
    rw [if_neg active]
    simp [blockOutput, output, basisDigits, basisDigit, inactive,
      Nat.mod_eq_of_lt (basisDigit_lt_blockBase width state i)]

/-- Mixed-radix value represented by the first `blocks` basis registers. -/
def basisBlockValue (width : Nat → Nat)
    (state : BlockBasisState width) (blocks : Nat) : Nat :=
  blockValue width (basisDigits width state) blocks

/-- Recombining the semantic basis cascade is exactly the arithmetic Equation-39
output value. -/
theorem cascadeOutput_blockValue
    (width : Nat → Nat) (state : BlockBasisState width) (blocks : Nat) :
    basisBlockValue width (cascadeOutput width state) blocks =
      blockValue width
        (blockOutput width (basisDigits width state)) blocks := by
  unfold basisBlockValue blockValue MixedRadixIncrement.prefixValue
  apply Finset.sum_congr rfl
  intro i member
  rw [cascadeOutput_digit]

/-- Basis-register Equation-(39) theorem for any mixed-width n-bit partition. -/
theorem basisCascade_nbit_successor
    (n blocks : Nat)
    (width : Nat → Nat)
    (partitions : widthMass width blocks = n)
    (state : BlockBasisState width) :
    basisBlockValue width (cascadeOutput width state) blocks % gridSize n =
      (basisBlockValue width state blocks + 1) % gridSize n := by
  have arithmetic := eq39_nbit_successor
    n blocks width (basisDigits width state)
    (basisDigit_lt_blockBase width state)
    partitions
    (basisBlockValue width state blocks)
    rfl
  rw [cascadeOutput_blockValue]
  exact arithmetic

/-- Canonical square-root block-plan specialization used by Lemma 8. -/
theorem canonicalSquareRoot_basisCascade_successor
    (n : Nat)
    (state : BlockBasisState
      (ComparatorIncrementerEq39SquareRootPlan.canonicalWidth n)) :
    basisBlockValue
        (ComparatorIncrementerEq39SquareRootPlan.canonicalWidth n)
        (cascadeOutput
          (ComparatorIncrementerEq39SquareRootPlan.canonicalWidth n) state)
        (ComparatorIncrementerLemma8Budget.blockSlots n) % gridSize n =
      (basisBlockValue
        (ComparatorIncrementerEq39SquareRootPlan.canonicalWidth n)
        state (ComparatorIncrementerLemma8Budget.blockSlots n) + 1) %
        gridSize n := by
  exact basisCascade_nbit_successor
    n (ComparatorIncrementerLemma8Budget.blockSlots n)
    (ComparatorIncrementerEq39SquareRootPlan.canonicalWidth n)
    (ComparatorIncrementerEq39SquareRootPlan.canonicalWidth_partitions n)
    state

end ComparatorIncrementerEq39BasisCascade
end QuantumBlockEncoding
