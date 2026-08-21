import QuantumBlockEncoding.VandaeleLemma5Equations13_14
import Mathlib.Tactic

/-!
# Vandaele Lemma 5: split-and-borrow resource budget

After Equations (13) and (14), the source removes their apparent dirty-ancilla
requirement by splitting the n independent gates into two halves.  Qubits acted
on by one half serve as dirty workspace for the other half.

The key inequality is

`ceil(n/2) - 1 <= floor(n/2)`.

Thus Equation (13) on the larger half needs no more dirty bits than are supplied
by target qubits from the smaller half.  Swapping the roles handles the other
half.  The source then uses four low-depth fan-outs, while every singly
controlled `U_i` is used at most twice.

This module proves the exact natural-number borrowing inequalities and exposes
explicit gate/depth composition bounds.  The fan-out implementation itself is
still supplied by Lemma 2 / its future concrete certificate.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma5SplitBudget

/-- Floor half. -/
def lowerHalf (n : Nat) : Nat := n / 2

/-- Complementary ceiling half. -/
def upperHalf (n : Nat) : Nat := n - lowerHalf n

@[simp] theorem halves_partition (n : Nat) :
    lowerHalf n + upperHalf n = n := by
  unfold lowerHalf upperHalf
  omega

/-- The floor half is never larger than the ceiling half. -/
theorem lowerHalf_le_upperHalf (n : Nat) :
    lowerHalf n ≤ upperHalf n := by
  unfold lowerHalf upperHalf
  omega

/-- The two halves differ by at most one. -/
theorem upperHalf_le_lowerHalf_add_one (n : Nat) :
    upperHalf n ≤ lowerHalf n + 1 := by
  unfold lowerHalf upperHalf
  omega

/-- Equation (13) on the larger half needs at most as many dirty flags as the
smaller half can donate target qubits. -/
theorem upperHalf_pred_le_lowerHalf (n : Nat) :
    upperHalf n - 1 ≤ lowerHalf n := by
  have close := upperHalf_le_lowerHalf_add_one n
  omega

/-- The reverse borrowing direction is automatically safe as well. -/
theorem lowerHalf_pred_le_upperHalf (n : Nat) :
    lowerHalf n - 1 ≤ upperHalf n := by
  have order := lowerHalf_le_upperHalf n
  omega

/-- Package the exact no-extra-workspace arithmetic used in the source proof. -/
structure BorrowingBudget (n : Nat) where
  firstSubset : Nat
  secondSubset : Nat
  partitions : firstSubset + secondSubset = n
  firstNeedsAtMostSecond : firstSubset - 1 ≤ secondSubset
  secondNeedsAtMostFirst : secondSubset - 1 ≤ firstSubset

/-- Canonical floor/ceiling split. -/
def canonicalBorrowingBudget (n : Nat) : BorrowingBudget n where
  firstSubset := lowerHalf n
  secondSubset := upperHalf n
  partitions := halves_partition n
  firstNeedsAtMostSecond := lowerHalf_pred_le_upperHalf n
  secondNeedsAtMostFirst := upperHalf_pred_le_lowerHalf n

/-- Totalized logarithmic scale for the singly controlled source case. -/
def logScale (n : Nat) : Nat := Nat.log2 (n + 1) + 1

/-- Four fan-out layers of width at most the larger half plus at most two
controlled uses of every source U_i give an explicit linear gate envelope. -/
theorem singlyControlled_gate_budget
    (n fanoutGateCount totalGates fanoutConstant : Nat)
    (fanoutBound :
      fanoutGateCount ≤ fanoutConstant * (upperHalf n + 1))
    (totalBound :
      totalGates ≤ 4 * fanoutGateCount + 2 * n) :
    totalGates ≤ (4 * fanoutConstant + 2) * (n + 1) := by
  have halfBound : upperHalf n + 1 ≤ n + 1 := by
    unfold upperHalf lowerHalf
    omega
  have fanoutLinear :
      fanoutGateCount ≤ fanoutConstant * (n + 1) :=
    fanoutBound.trans (Nat.mul_le_mul_left fanoutConstant halfBound)
  calc
    totalGates ≤ 4 * fanoutGateCount + 2 * n := totalBound
    _ ≤ 4 * (fanoutConstant * (n + 1)) + 2 * n :=
      Nat.add_le_add
        (Nat.mul_le_mul_left 4 fanoutLinear)
        (Nat.le_refl _)
    _ ≤ 4 * (fanoutConstant * (n + 1)) + 2 * (n + 1) := by
      omega
    _ = (4 * fanoutConstant + 2) * (n + 1) := by ring

/-- If one fan-out layer has logarithmic depth, the four fan-outs plus two
parallel controlled-U layers still have logarithmic depth. -/
theorem singlyControlled_depth_budget
    (n fanoutDepth totalDepth depthConstant : Nat)
    (fanoutBound : fanoutDepth ≤ depthConstant * logScale n)
    (totalBound : totalDepth ≤ 4 * fanoutDepth + 2) :
    totalDepth ≤ (4 * depthConstant + 2) * logScale n := by
  have scalePos : 1 ≤ logScale n := by
    unfold logScale
    omega
  calc
    totalDepth ≤ 4 * fanoutDepth + 2 := totalBound
    _ ≤ 4 * (depthConstant * logScale n) + 2 :=
      Nat.add_le_add_right (Nat.mul_le_mul_left 4 fanoutBound) 2
    _ ≤ 4 * (depthConstant * logScale n) + 2 * logScale n := by
      omega
    _ = (4 * depthConstant + 2) * logScale n := by ring

/-- Equation (14) is applied once to each subset.  Since one Eq. (14)
application uses two C^k X toggles and two singly-controlled product instances,
the complete split proof uses at most four of each high-level component. -/
structure KControlledSplitUses where
  eq14Applications : Nat
  multiControlledXToggles : Nat
  singlyControlledProductUses : Nat
  deriving DecidableEq, Repr

/-- Exact high-level count from applying Equation (14) to both halves. -/
def kControlledSplitUses : KControlledSplitUses where
  eq14Applications := 2
  multiControlledXToggles := 4
  singlyControlledProductUses := 4

@[simp] theorem kControlledSplitUses_exact :
    kControlledSplitUses =
      { eq14Applications := 2,
        multiControlledXToggles := 4,
        singlyControlledProductUses := 4 } := by
  rfl

/-- Gate-count composition for the k-controlled case. -/
theorem kControlled_gate_budget
    (n controls singleGateCount multiXGateCount totalGates
      singleConstant multiXConstant : Nat)
    (singleBound :
      singleGateCount ≤ singleConstant * (n + 1))
    (multiXBound :
      multiXGateCount ≤ multiXConstant * (controls + 1))
    (totalBound :
      totalGates ≤ 4 * singleGateCount + 4 * multiXGateCount) :
    totalGates ≤
      (4 * singleConstant + 4 * multiXConstant) *
        (n + controls + 1) := by
  have nScale : n + 1 ≤ n + controls + 1 := by omega
  have kScale : controls + 1 ≤ n + controls + 1 := by omega
  have singleGlobal :
      singleGateCount ≤ singleConstant * (n + controls + 1) :=
    singleBound.trans (Nat.mul_le_mul_left singleConstant nScale)
  have multiGlobal :
      multiXGateCount ≤ multiXConstant * (n + controls + 1) :=
    multiXBound.trans (Nat.mul_le_mul_left multiXConstant kScale)
  calc
    totalGates ≤ 4 * singleGateCount + 4 * multiXGateCount := totalBound
    _ ≤ 4 * (singleConstant * (n + controls + 1)) +
          4 * (multiXConstant * (n + controls + 1)) :=
      Nat.add_le_add
        (Nat.mul_le_mul_left 4 singleGlobal)
        (Nat.mul_le_mul_left 4 multiGlobal)
    _ = (4 * singleConstant + 4 * multiXConstant) *
          (n + controls + 1) := by ring

end VandaeleLemma5SplitBudget
end QuantumBlockEncoding
