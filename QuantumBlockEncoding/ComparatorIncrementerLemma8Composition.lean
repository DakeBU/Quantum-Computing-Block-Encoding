import QuantumBlockEncoding.ComparatorIncrementerLemma8Budget
import Mathlib.Tactic

/-!
# Resource composition for Vandaele Lemma 8 / Figure 10

The source cost analysis separates Figure 10 into three families:

* the two C^kX ladders;
* fan-out layers;
* O(sqrt n) controlled strong promise increment/decrement gates, each acting on
  O(sqrt n) wires and scheduled in a constant number of rounds.

The individual circuit families still need concrete Lean implementations.  This
module proves the deterministic composition step: explicit local linear /
square-root/logarithmic inequalities imply the advertised global O(n) gate and
O(log n) depth upper bounds.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma8Composition

open ComparatorIncrementerLemma8Budget

/-- Common explicit logarithmic scale used instead of hiding constants inside
asymptotic notation. -/
def logScale (n : Nat) : Nat := Nat.log2 (n + 1) + 1

/-- Gate-count composition for Figure 10.

`ladderConstant` and `fanoutConstant` bound the two structural families
linearly.  Promise gates come in at most `blockConstant * ceilSqrt n` copies,
each of size/cost at most `promiseConstant * ceilSqrt n`. -/
theorem lemmaEight_gate_composition
    (n ladderGates fanoutGates promiseBlocks perPromiseGates
      promiseGates totalGates
      ladderConstant fanoutConstant blockConstant promiseConstant : Nat)
    (ladderBound : ladderGates ≤ ladderConstant * (n + 1))
    (fanoutBound : fanoutGates ≤ fanoutConstant * (n + 1))
    (promiseBlocksBound :
      promiseBlocks ≤ blockConstant * blockWidth n)
    (perPromiseBound :
      perPromiseGates ≤ promiseConstant * blockWidth n)
    (promiseTotalBound :
      promiseGates ≤ promiseBlocks * perPromiseGates)
    (totalBound :
      totalGates ≤ ladderGates + fanoutGates + promiseGates) :
    totalGates ≤
      (ladderConstant + fanoutConstant +
        4 * (promiseConstant * blockConstant)) * (n + 1) := by
  have promiseLinear := blockwise_gate_budget
    n promiseBlocks perPromiseGates promiseGates
      promiseConstant blockConstant
      promiseBlocksBound perPromiseBound promiseTotalBound
  have componentBound :
      ladderGates + fanoutGates + promiseGates ≤
        ladderConstant * (n + 1) +
          fanoutConstant * (n + 1) +
          4 * (promiseConstant * blockConstant) * (n + 1) :=
    Nat.add_le_add
      (Nat.add_le_add ladderBound fanoutBound)
      promiseLinear
  calc
    totalGates ≤ ladderGates + fanoutGates + promiseGates := totalBound
    _ ≤ ladderConstant * (n + 1) +
          fanoutConstant * (n + 1) +
          4 * (promiseConstant * blockConstant) * (n + 1) :=
      componentBound
    _ = (ladderConstant + fanoutConstant +
          4 * (promiseConstant * blockConstant)) * (n + 1) := by ring

/-- Depth composition for Figure 10.

The source promise gates are scheduled in two rounds.  If each of the ladder,
fan-out, and per-round promise layers has an explicit constant-times-log bound,
the entire Figure 10 circuit has one as well. -/
theorem lemmaEight_depth_composition
    (n ladderDepth fanoutDepth promiseRoundDepth promiseDepth totalDepth
      ladderConstant fanoutConstant promiseConstant : Nat)
    (ladderBound : ladderDepth ≤ ladderConstant * logScale n)
    (fanoutBound : fanoutDepth ≤ fanoutConstant * logScale n)
    (promiseRoundBound :
      promiseRoundDepth ≤ promiseConstant * logScale n)
    (promiseTwoRounds : promiseDepth ≤ 2 * promiseRoundDepth)
    (totalBound :
      totalDepth ≤ ladderDepth + fanoutDepth + promiseDepth) :
    totalDepth ≤
      (ladderConstant + fanoutConstant + 2 * promiseConstant) * logScale n := by
  have promiseBound :
      promiseDepth ≤ (2 * promiseConstant) * logScale n := by
    calc
      promiseDepth ≤ 2 * promiseRoundDepth := promiseTwoRounds
      _ ≤ 2 * (promiseConstant * logScale n) :=
        Nat.mul_le_mul_left 2 promiseRoundBound
      _ = (2 * promiseConstant) * logScale n := by ring
  have componentBound :
      ladderDepth + fanoutDepth + promiseDepth ≤
        ladderConstant * logScale n +
          fanoutConstant * logScale n +
          (2 * promiseConstant) * logScale n :=
    Nat.add_le_add
      (Nat.add_le_add ladderBound fanoutBound)
      promiseBound
  calc
    totalDepth ≤ ladderDepth + fanoutDepth + promiseDepth := totalBound
    _ ≤ ladderConstant * logScale n +
          fanoutConstant * logScale n +
          (2 * promiseConstant) * logScale n := componentBound
    _ = (ladderConstant + fanoutConstant + 2 * promiseConstant) *
          logScale n := by ring

/-- Package the two explicit bounds in exactly the resource proposition exposed
by the Lemma 8 semantic contract. -/
theorem composition_implies_resource_target
    (gateCount depth : Nat → Nat)
    (gateConstant depthConstant : Nat)
    (gateBound : ∀ n, gateCount n ≤ gateConstant * (n + 1))
    (depthBound : ∀ n, depth n ≤ depthConstant * logScale n) :
    ComparatorIncrementerLemma8Contract.LemmaEightResourceTarget
      gateCount depth := by
  constructor
  · exact ⟨gateConstant, gateBound⟩
  · refine ⟨depthConstant, ?_⟩
    intro n
    simpa [logScale] using depthBound n

end ComparatorIncrementerLemma8Composition
end QuantumBlockEncoding
