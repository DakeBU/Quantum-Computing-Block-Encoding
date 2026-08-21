import QuantumBlockEncoding.ComparatorIncrementerRecurrence
import Mathlib.Tactic

/-!
# Square-root block budget in Vandaele Lemma 8

Lemma 8 partitions the incrementer into registers of width at most
`s = ceil(sqrt n)`.  There are O(s) such registers, and each controlled
increment/decrement promise gate acts on O(s) target/promise wires.  The crucial
resource arithmetic is therefore that O(s) blocks times O(s) work per block is
still O(n).

This file proves that deterministic arithmetic layer.  It does not assign any
cost to a circuit component: later Figure 10 refinements must prove their own
local gate/depth bounds and may then use the composition lemmas below.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma8Budget

open ComparatorIncrementerRecurrence

/-- Uniform block width used in the square-root decomposition. -/
def blockWidth (n : Nat) : Nat := ceilSqrt n

/-- A padded square plan with at most one block per square-root slot.  The source
uses a shorter last register; padding only makes the counting envelope explicit. -/
def blockSlots (n : Nat) : Nat := ceilSqrt n

/-- The padded square plan has enough capacity for all n target wires. -/
theorem block_capacity (n : Nat) :
    n ≤ blockSlots n * blockWidth n := by
  simpa [blockSlots, blockWidth] using le_ceilSqrt_sq n

/-- Lemma 8's promise-register budget is twice the square-root block width. -/
def promiseWidth (n : Nat) : Nat := 2 * blockWidth n

@[simp] theorem promiseWidth_eq_alpha (n : Nat) :
    promiseWidth n = alpha n := by
  rfl

/-- The square of the natural ceiling square root is bounded linearly in n.
The constant 4 is intentionally loose: it gives a robust deterministic bound
sufficient for later O(n) composition without optimizing small-width constants. -/
theorem block_square_linear (n : Nat) :
    blockWidth n * blockWidth n ≤ 4 * (n + 1) := by
  have ceilingBound := ceilSqrt_le_sqrt_add_one n
  have squareBelow : Nat.sqrt n ^ 2 ≤ n := Nat.sqrt_le' n
  have sqrtBelow : Nat.sqrt n ≤ n := Nat.sqrt_le_self n
  unfold blockWidth
  nlinarith

/-- Generic gate-count composition for the Lemma 8 block pattern.

If there are at most `b*s` blocks, each costs at most `a*s` gates, and `total`
is bounded by their product, then the total is at most
`4*a*b*(n+1)`. -/
theorem blockwise_gate_budget
    (n blocks perBlock total a b : Nat)
    (blocksBound : blocks ≤ b * blockWidth n)
    (perBlockBound : perBlock ≤ a * blockWidth n)
    (totalBound : total ≤ blocks * perBlock) :
    total ≤ 4 * (a * b) * (n + 1) := by
  calc
    total ≤ blocks * perBlock := totalBound
    _ ≤ (b * blockWidth n) * (a * blockWidth n) :=
      Nat.mul_le_mul blocksBound perBlockBound
    _ = (a * b) * (blockWidth n * blockWidth n) := by ring
    _ ≤ (a * b) * (4 * (n + 1)) :=
      Nat.mul_le_mul_left (a * b) (block_square_linear n)
    _ = 4 * (a * b) * (n + 1) := by ring

/-- A constant number of rounds preserves a logarithmic per-round depth bound.
The theorem is deliberately elementary; a later asymptotic wrapper can turn the
explicit inequality into Mathlib `IsBigO` evidence if desired. -/
theorem constant_round_depth_budget
    (n rounds perRound total constant : Nat)
    (perRoundBound : perRound ≤ constant * (Nat.log2 (n + 1) + 1))
    (totalBound : total ≤ rounds * perRound) :
    total ≤ (rounds * constant) * (Nat.log2 (n + 1) + 1) := by
  calc
    total ≤ rounds * perRound := totalBound
    _ ≤ rounds * (constant * (Nat.log2 (n + 1) + 1)) :=
      Nat.mul_le_mul_left rounds perRoundBound
    _ = (rounds * constant) * (Nat.log2 (n + 1) + 1) := by ring

/-- Direct specialization for the source's two-round promise-gate scheduling. -/
theorem two_round_depth_budget
    (n perRound total constant : Nat)
    (perRoundBound : perRound ≤ constant * (Nat.log2 (n + 1) + 1))
    (totalBound : total ≤ 2 * perRound) :
    total ≤ (2 * constant) * (Nat.log2 (n + 1) + 1) := by
  exact constant_round_depth_budget
    n 2 perRound total constant perRoundBound totalBound

end ComparatorIncrementerLemma8Budget
end QuantumBlockEncoding
