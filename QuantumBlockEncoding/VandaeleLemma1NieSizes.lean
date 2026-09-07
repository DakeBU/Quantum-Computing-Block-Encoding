import QuantumBlockEncoding.VandaeleLemma1NieLayout
import Mathlib.Tactic

/-!
# Balanced child-size facts for the Nie recursion

The circuit layer keeps the split definition close to Figure 3.  Well-founded
recursion and complexity induction should consume a smaller arithmetic API:
for every non-base node (`k ≥ 5`), both children are strictly smaller than the
parent and their control counts sum to exactly `k-4`.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma1NieSizes

open VandaeleLemma1NieLayout

/-- Left child is strictly smaller at every recursive node. -/
theorem leftSize_lt_parent {k : Nat} (five_le : 5 ≤ k) :
    leftSize k < k := by
  have bound : leftSize k ≤ k - 4 := by
    unfold leftSize
    exact Nat.div_le_self _ _
  omega

/-- Right child is strictly smaller at every recursive node. -/
theorem rightSize_lt_parent {k : Nat} (five_le : 5 ≤ k) :
    rightSize k < k := by
  unfold rightSize
  omega

/-- Recursive controls are exactly the controls not reserved as `I₁,...,I₄`. -/
theorem childSize_sum {k : Nat} (five_le : 5 ≤ k) :
    leftSize k + rightSize k = k - 4 := by
  have partition := split_size k (by omega : 4 ≤ k)
  omega

/-- Each child is bounded by the complete recursive remainder. -/
theorem leftSize_le_remainder {k : Nat} (five_le : 5 ≤ k) :
    leftSize k ≤ k - 4 := by
  have sum := childSize_sum five_le
  omega

/-- Symmetric remainder bound for the right child. -/
theorem rightSize_le_remainder {k : Nat} (five_le : 5 ≤ k) :
    rightSize k ≤ k - 4 := by
  have sum := childSize_sum five_le
  omega

end VandaeleLemma1NieSizes
end QuantumBlockEncoding
