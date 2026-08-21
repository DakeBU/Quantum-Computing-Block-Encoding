import QuantumBlockEncoding.ComparatorIncrementerEq39SquareRootPlan
import QuantumBlockEncoding.ComparatorIncrementerLemma8Lemma7LocalBounds
import Mathlib.Tactic

/-!
# Canonical promise-gate gate budget in Vandaele Lemma 8

The square-root plan has `s = ceil(sqrt n)` slots.  A source implementation uses
at most one local Lemma-7 increment/decrement per slot up to constant factors.
Rather than bounding an abstract product `blocks * perBlock`, this module sums
the actual Lemma-7 gate-count function over the canonical mixed-width block
stream:

`G_promise(n) = sum_{i<s} G_7(1, w_i)`.

The Lemma-7 uniform resource theorem and `w_i <= s` imply each summand is O(s),
while `s^2 <= 4(n+1)`.  Hence this exact finite sum is O(n).
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma8PromiseGateBudget

open ComparatorIncrementerEq39SquareRootPlan
open ComparatorIncrementerLemma7Contract
open ComparatorIncrementerLemma8Budget
open ComparatorIncrementerLemma8Lemma7LocalBounds

/-- Sum of one-control Lemma-7 gate costs over every canonical square-root slot.
This is a conservative envelope: unused/zero-width slots only overcount. -/
def canonicalPromiseGateSum
    (gateCount : Nat → Nat → Nat) (n : Nat) : Nat :=
  ∑ i ∈ Finset.range (blockSlots n),
    gateCount 1 (canonicalWidth n i)

/-- The exact canonical sum has one uniform linear bound inherited from the same
Lemma-7 resource family. -/
theorem canonicalPromiseGateSum_linear
    (gateCount depth : Nat → Nat → Nat)
    (resources : LemmaSevenResourceTarget gateCount depth) :
    ∃ constant : Nat, ∀ n,
      canonicalPromiseGateSum gateCount n ≤ constant * (n + 1) := by
  rcases oneControl_local_bounds gateCount depth resources with
    ⟨localGateConstant, localDepthConstant, localBounds⟩
  refine ⟨4 * localGateConstant, ?_⟩
  intro n
  by_cases zero : n = 0
  · subst n
    simp [canonicalPromiseGateSum, blockSlots,
      ComparatorIncrementerRecurrence.ceilSqrt]
  · have positive : 0 < n := Nat.pos_of_ne_zero zero
    have each : ∀ i ∈ Finset.range (blockSlots n),
        gateCount 1 (canonicalWidth n i) ≤
          localGateConstant * blockWidth n := by
      intro i member
      have indexBound : i < blockSlots n := Finset.mem_range.mp member
      exact (localBounds n (canonicalWidth n i) positive
        (canonicalWidth_le_blockWidth n i)).1
    have sumBound :
        canonicalPromiseGateSum gateCount n ≤
          blockSlots n * (localGateConstant * blockWidth n) := by
      unfold canonicalPromiseGateSum
      calc
        (∑ i ∈ Finset.range (blockSlots n),
            gateCount 1 (canonicalWidth n i)) ≤
          ∑ i ∈ Finset.range (blockSlots n),
            localGateConstant * blockWidth n := by
              exact Finset.sum_le_sum each
        _ = blockSlots n * (localGateConstant * blockWidth n) := by
              simp
    have squareBound := block_square_linear n
    unfold blockSlots at sumBound
    unfold blockWidth at squareBound ⊢
    calc
      canonicalPromiseGateSum gateCount n ≤
          ComparatorIncrementerRecurrence.ceilSqrt n *
            (localGateConstant * ComparatorIncrementerRecurrence.ceilSqrt n) :=
        sumBound
      _ = localGateConstant *
          (ComparatorIncrementerRecurrence.ceilSqrt n *
            ComparatorIncrementerRecurrence.ceilSqrt n) := by ring
      _ ≤ localGateConstant * (4 * (n + 1)) :=
        Nat.mul_le_mul_left localGateConstant squareBound
      _ = (4 * localGateConstant) * (n + 1) := by ring

end ComparatorIncrementerLemma8PromiseGateBudget
end QuantumBlockEncoding
