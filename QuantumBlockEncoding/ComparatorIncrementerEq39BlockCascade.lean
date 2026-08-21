import QuantumBlockEncoding.ComparatorIncrementerGeneral
import QuantumBlockEncoding.ComparatorIncrementerLemma8Budget
import QuantumBlockEncoding.MixedRadixIncrement
import Mathlib.Tactic

/-!
# Vandaele Equation (39): mixed-width block increment cascade

Equation (39) decomposes an n-bit increment into a chain of block increments.
Most blocks have width `ceil(sqrt n)` and the last block may be shorter.  The
correct arithmetic model is therefore mixed-radix, not a padded uniform radix.

For block widths `w_i`, block i has radix `2^w_i`.  The first block receives the
initial carry 1; block i+1 receives a carry exactly when block i overflows.  This
file specializes `MixedRadixIncrement` to powers of two and proves that, when
the block widths sum to n, recombining the block outputs gives the n-bit modular
successor exactly.

The theorem is the global semantic target behind the local controlled promise
increments used later in Equations (41)-(43) and Figure 10.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerEq39BlockCascade

open scoped BigOperators
open ComparatorIncrementerGeneral
open ComparatorIncrementerLemma8Budget
open MixedRadixIncrement

/-- Radix of one block of the declared bit width. -/
def blockBase (width : Nat → Nat) (i : Nat) : Nat :=
  gridSize (width i)

/-- Total number of target bits covered by the first `blocks` blocks. -/
def widthMass (width : Nat → Nat) (blocks : Nat) : Nat :=
  ∑ i ∈ Finset.range blocks, width i

/-- Positional mixed-radix value of a block digit stream. -/
def blockValue (width digit : Nat → Nat) (blocks : Nat) : Nat :=
  prefixValue (blockBase width) digit blocks

/-- Carry entering block i. -/
def blockCarry (width digit : Nat → Nat) (i : Nat) : Nat :=
  carry (blockBase width) digit i

/-- Output digit of block i after the successor carry. -/
def blockOutput (width digit : Nat → Nat) (i : Nat) : Nat :=
  output (blockBase width) digit i

/-- Every power-of-two block radix is positive, including a zero-width block
whose radix is one. -/
theorem blockBase_pos (width : Nat → Nat) (i : Nat) :
    0 < blockBase width i := by
  unfold blockBase gridSize
  exact Nat.pow_pos (by decide)

/-- Mixed-radix positional weight is exactly the power of two determined by all
preceding block widths. -/
theorem blockWeight_eq_gridSize_widthMass
    (width : Nat → Nat) :
    ∀ blocks,
      weight (blockBase width) blocks = gridSize (widthMass width blocks) := by
  intro blocks
  induction blocks with
  | zero =>
      simp [weight, widthMass, gridSize]
  | succ blocks induction =>
      rw [weight_succ]
      rw [induction]
      unfold widthMass blockBase gridSize
      rw [Finset.sum_range_succ]
      rw [pow_add]

/-- Exact Equation-(39) carry telescoping before reducing modulo the total word
size. -/
theorem eq39_weighted_cascade
    (width digit : Nat → Nat)
    (digitBound : ∀ i, digit i < blockBase width i)
    (blocks : Nat) :
    blockValue width (blockOutput width digit) blocks +
        blockCarry width digit blocks * gridSize (widthMass width blocks) =
      blockValue width digit blocks + 1 := by
  have source := weighted_increment
    (blockBase width) digit (blockBase_pos width) digitBound blocks
  simpa [blockValue, blockOutput, blockCarry,
    blockWeight_eq_gridSize_widthMass width blocks] using source

/-- Modulo the product radix, the block cascade is exactly successor. -/
theorem eq39_modular_cascade
    (width digit : Nat → Nat)
    (digitBound : ∀ i, digit i < blockBase width i)
    (blocks : Nat) :
    blockValue width (blockOutput width digit) blocks %
        gridSize (widthMass width blocks) =
      (blockValue width digit blocks + 1) %
        gridSize (widthMass width blocks) := by
  have source := eq39_weighted_cascade width digit digitBound blocks
  have reduced := congrArg
    (fun value => value % gridSize (widthMass width blocks)) source
  have productComm :
      blockCarry width digit blocks * gridSize (widthMass width blocks) =
        gridSize (widthMass width blocks) * blockCarry width digit blocks := by
    ac_rfl
  rw [productComm] at reduced
  simpa using reduced

/-- Source-facing n-bit specialization.  `reconstructs` says the input block
digits are the chosen decomposition of the n-bit word; `partitions` says their
bit widths cover exactly n bits. -/
theorem eq39_nbit_successor
    (n blocks : Nat)
    (width digit : Nat → Nat)
    (digitBound : ∀ i, digit i < blockBase width i)
    (partitions : widthMass width blocks = n)
    (inputValue : Nat)
    (reconstructs : blockValue width digit blocks = inputValue) :
    blockValue width (blockOutput width digit) blocks % gridSize n =
      (inputValue + 1) % gridSize n := by
  have source := eq39_modular_cascade width digit digitBound blocks
  simpa [partitions, reconstructs] using source

/-- The square-root source plan only needs the local width and block-count bounds
for resources; the Equation-(39) correctness theorem itself is valid for every
mixed-width partition. -/
structure SquareRootBlockPlan (n : Nat) where
  blocks : Nat
  width : Nat → Nat
  partitions : widthMass width blocks = n
  blockWidthBound : ∀ i, i < blocks → width i ≤ blockWidth n
  blockCountBound : blocks ≤ blockSlots n

/-- Any square-root block plan inherits the exact n-bit successor theorem. -/
theorem squareRootPlan_successor
    (n : Nat) (plan : SquareRootBlockPlan n)
    (digit : Nat → Nat)
    (digitBound : ∀ i, digit i < blockBase plan.width i)
    (inputValue : Nat)
    (reconstructs : blockValue plan.width digit plan.blocks = inputValue) :
    blockValue plan.width (blockOutput plan.width digit) plan.blocks %
        gridSize n =
      (inputValue + 1) % gridSize n := by
  exact eq39_nbit_successor
    n plan.blocks plan.width digit digitBound
    plan.partitions inputValue reconstructs

end ComparatorIncrementerEq39BlockCascade
end QuantumBlockEncoding
