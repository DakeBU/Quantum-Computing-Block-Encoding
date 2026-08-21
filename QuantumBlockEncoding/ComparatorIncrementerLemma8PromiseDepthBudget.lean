import QuantumBlockEncoding.ComparatorIncrementerEq39SquareRootPlan
import QuantumBlockEncoding.ComparatorIncrementerLemma8Lemma7LocalBounds
import QuantumBlockEncoding.ComparatorIncrementerLemma8TwoRoundSchedule
import Mathlib.Tactic

/-!
# Canonical two-round promise-gate depth budget in Vandaele Lemma 8

Equation (42) colors adjacent promise-gate slots by parity.  Same-round slots
have disjoint block support, so their internal circuits may run in parallel.
Numerically, the depth of one round is therefore bounded by the maximum local
Lemma-7 depth in that round, not their sum.

This file makes that maximum explicit with a small prefix-max recursion and
proves that the sum of the two round maxima is O(log n) from the *same* uniform
Lemma-7 resource family.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma8PromiseDepthBudget

open ComparatorIncrementerEq39SquareRootPlan
open ComparatorIncrementerLemma7Contract
open ComparatorIncrementerLemma8Budget
open ComparatorIncrementerLemma8Composition
open ComparatorIncrementerLemma8Lemma7LocalBounds
open ComparatorIncrementerLemma8TwoRoundSchedule

/-- Maximum of `f 0,...,f(n-1)`, totalized by zero. -/
def prefixMax (f : Nat → Nat) : Nat → Nat
  | 0 => 0
  | n + 1 => max (prefixMax f n) (f n)

/-- Prefix max is bounded whenever every member of the prefix is bounded. -/
theorem prefixMax_le
    (f : Nat → Nat) (bound : Nat) :
    ∀ n, (∀ i, i < n → f i ≤ bound) → prefixMax f n ≤ bound := by
  intro n
  induction n with
  | zero =>
      intro _
      simp [prefixMax]
  | succ n induction =>
      intro all
      have previous := induction (fun i lower => all i (by omega))
      have current := all n (by omega)
      simp [prefixMax, max_le_iff, previous, current]

/-- Local depth assigned to one parity round; slots of the other parity
contribute zero to that round's maximum. -/
def roundLocalDepth
    (depth : Nat → Nat → Nat) (n roundLabel i : Nat) : Nat :=
  if i % 2 = roundLabel then
    depth 1 (canonicalWidth n i)
  else 0

/-- Depth envelope of one canonical parity round. -/
def canonicalRoundDepth
    (depth : Nat → Nat → Nat) (n roundLabel : Nat) : Nat :=
  prefixMax (roundLocalDepth depth n roundLabel) (blockSlots n)

/-- Two-round promise-layer depth envelope. -/
def canonicalPromiseDepth
    (depth : Nat → Nat → Nat) (n : Nat) : Nat :=
  canonicalRoundDepth depth n 0 + canonicalRoundDepth depth n 1

/-- One round inherits the local Lemma-7 logarithmic bound. -/
theorem canonicalRoundDepth_bound
    (gateCount depth : Nat → Nat → Nat)
    (resources : LemmaSevenResourceTarget gateCount depth) :
    ∃ constant : Nat, ∀ n roundLabel,
      canonicalRoundDepth depth n roundLabel ≤ constant * logScale n := by
  rcases oneControl_local_bounds gateCount depth resources with
    ⟨localGateConstant, localDepthConstant, localBounds⟩
  refine ⟨localDepthConstant, ?_⟩
  intro n roundLabel
  by_cases zero : n = 0
  · subst n
    simp [canonicalRoundDepth, blockSlots,
      ComparatorIncrementerRecurrence.ceilSqrt, prefixMax]
  · have positive : 0 < n := Nat.pos_of_ne_zero zero
    apply prefixMax_le
    intro i indexBound
    unfold roundLocalDepth
    split
    · exact (localBounds n (canonicalWidth n i) positive
        (canonicalWidth_le_blockWidth n i)).2
    · exact Nat.zero_le _

/-- The two parity rounds have one uniform logarithmic depth bound. -/
theorem canonicalPromiseDepth_logarithmic
    (gateCount depth : Nat → Nat → Nat)
    (resources : LemmaSevenResourceTarget gateCount depth) :
    ∃ constant : Nat, ∀ n,
      canonicalPromiseDepth depth n ≤ constant * logScale n := by
  rcases canonicalRoundDepth_bound gateCount depth resources with
    ⟨roundConstant, roundBound⟩
  refine ⟨2 * roundConstant, ?_⟩
  intro n
  unfold canonicalPromiseDepth
  calc
    canonicalRoundDepth depth n 0 + canonicalRoundDepth depth n 1 ≤
        roundConstant * logScale n + roundConstant * logScale n :=
      Nat.add_le_add (roundBound n 0) (roundBound n 1)
    _ = (2 * roundConstant) * logScale n := by ring

end ComparatorIncrementerLemma8PromiseDepthBudget
end QuantumBlockEncoding
