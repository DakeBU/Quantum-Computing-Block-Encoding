import QuantumBlockEncoding.ComparatorIncrementerTheorem4DepthBound
import QuantumBlockEncoding.VandaeleLemma5SplitBudget
import Mathlib.Tactic

/-!
# Vandaele Theorem 5: Figure-11 resource and recurrence contract

Figure 11 recursively splits the classical adder into floor/ceiling half-width
adders.  Its nonrecursive layer consists of the carry comparator, fan-out,
controlled incrementers, and ordinary incrementers.  After substituting
Theorems 3/4, Lemma 2, and Corollary 7, that layer has O(n) gates and O(log n)
depth.

The source then states Equations (49)-(50):

`C(n) = Theta(n) + 2 C(n/2)`,
`D(n) = Theta(log n) + D(n/2)`.

For exact natural-number bookkeeping we use both actual halves:
`upperHalf n + lowerHalf n = n`.  Gate cost is bounded by the sum of both
recursive halves; recursive depth by their maximum.  This module fixes those
recurrence interfaces and closes the nonrecursive component algebra.  The final
master-recurrence proof of O(n log n)/O(log^2 n) is deliberately kept as a named
separate target rather than silently asserted.
-/

namespace QuantumBlockEncoding
namespace VandaeleTheorem5Resource

open ComparatorIncrementerTheorem4DepthBound
open VandaeleLemma5SplitBudget

/-- Linear-gate/log-depth target for one Figure-11 local component family. -/
def LocalComponentResourceTarget
    (gateCount depth : Nat → Nat) : Prop :=
  ∃ gateConstant depthConstant : Nat,
    ∀ n,
      gateCount n ≤ gateConstant * (n + 1) ∧
      depth n ≤ depthConstant * logRank n

/-- One-level gate envelope from four nonrecursive component classes. -/
def localGateEnvelope
    (carryGate fanoutGate controlledIncrementGate incrementGate : Nat → Nat)
    (n : Nat) : Nat :=
  carryGate n + 2 * fanoutGate n +
    2 * controlledIncrementGate n + 2 * incrementGate n

/-- Conservative one-level serial depth envelope.  Figure-11 scheduling may
parallelize some of these components, which can only improve the bound. -/
def localDepthEnvelope
    (carryDepth fanoutDepth controlledIncrementDepth incrementDepth : Nat → Nat)
    (n : Nat) : Nat :=
  carryDepth n + 2 * fanoutDepth n +
    2 * controlledIncrementDepth n + 2 * incrementDepth n

/-- All four source component families close to one O(n)/O(log n) local layer. -/
theorem local_resource_closure
    (carryGate carryDepth fanoutGate fanoutDepth
      controlledIncrementGate controlledIncrementDepth
      incrementGate incrementDepth : Nat → Nat)
    (carryResources : LocalComponentResourceTarget carryGate carryDepth)
    (fanoutResources : LocalComponentResourceTarget fanoutGate fanoutDepth)
    (controlledIncrementResources :
      LocalComponentResourceTarget controlledIncrementGate controlledIncrementDepth)
    (incrementResources :
      LocalComponentResourceTarget incrementGate incrementDepth) :
    LocalComponentResourceTarget
      (localGateEnvelope carryGate fanoutGate controlledIncrementGate incrementGate)
      (localDepthEnvelope carryDepth fanoutDepth
        controlledIncrementDepth incrementDepth) := by
  rcases carryResources with ⟨cg, cd, carry⟩
  rcases fanoutResources with ⟨fg, fd, fanout⟩
  rcases controlledIncrementResources with ⟨kg, kd, controlled⟩
  rcases incrementResources with ⟨ig, id, increment⟩
  refine ⟨cg + 2 * fg + 2 * kg + 2 * ig,
    cd + 2 * fd + 2 * kd + 2 * id, ?_⟩
  intro n
  have c := carry n
  have f := fanout n
  have k := controlled n
  have i := increment n
  constructor
  · unfold localGateEnvelope
    calc
      carryGate n + 2 * fanoutGate n +
          2 * controlledIncrementGate n + 2 * incrementGate n ≤
        cg * (n + 1) + 2 * (fg * (n + 1)) +
          2 * (kg * (n + 1)) + 2 * (ig * (n + 1)) :=
        Nat.add_le_add
          (Nat.add_le_add
            (Nat.add_le_add c.1 (Nat.mul_le_mul_left 2 f.1))
            (Nat.mul_le_mul_left 2 k.1))
          (Nat.mul_le_mul_left 2 i.1)
      _ = (cg + 2 * fg + 2 * kg + 2 * ig) * (n + 1) := by ring
  · unfold localDepthEnvelope
    calc
      carryDepth n + 2 * fanoutDepth n +
          2 * controlledIncrementDepth n + 2 * incrementDepth n ≤
        cd * logRank n + 2 * (fd * logRank n) +
          2 * (kd * logRank n) + 2 * (id * logRank n) :=
        Nat.add_le_add
          (Nat.add_le_add
            (Nat.add_le_add c.2 (Nat.mul_le_mul_left 2 f.2))
            (Nat.mul_le_mul_left 2 k.2))
          (Nat.mul_le_mul_left 2 i.2)
      _ = (cd + 2 * fd + 2 * kd + 2 * id) * logRank n := by ring

/-- Exact natural-number form of Equation (49). -/
def GateRecurrenceUpper
    (cost localCost : Nat → Nat) : Prop :=
  ∀ n, 2 ≤ n →
    cost n ≤ localCost n + cost (upperHalf n) + cost (lowerHalf n)

/-- Exact natural-number form of Equation (50): recursive halves may be
scheduled in parallel, so only their maximum contributes to the recursive depth. -/
def DepthRecurrenceUpper
    (depth localDepth : Nat → Nat) : Prop :=
  ∀ n, 2 ≤ n →
    depth n ≤ localDepth n + max (depth (upperHalf n)) (depth (lowerHalf n))

/-- Source Theorem-5 asymptotic target. -/
def TheoremFiveUpperTarget
    (gateCount depth dirtyAncillas : Nat → Nat) : Prop :=
  (∃ constant : Nat, ∀ n,
    gateCount n ≤ constant * (n + 1) * logRank n) ∧
  (∃ constant : Nat, ∀ n,
    depth n ≤ constant * logRank n * logRank n) ∧
  (∀ n, dirtyAncillas n ≤ 1)

/-- Named remaining master-recurrence obligation.  A complete Theorem-5 Lean
proof must inhabit this interface from Equations (49)-(50) and finite base cases. -/
def MasterRecurrenceClosure : Prop :=
  ∀ (gateCount depth localGate localDepth : Nat → Nat),
    (∃ gateConstant : Nat, ∀ n,
      localGate n ≤ gateConstant * (n + 1)) →
    (∃ depthConstant : Nat, ∀ n,
      localDepth n ≤ depthConstant * logRank n) →
    GateRecurrenceUpper gateCount localGate →
    DepthRecurrenceUpper depth localDepth →
    (∃ gateConstant : Nat, ∀ n,
      gateCount n ≤ gateConstant * (n + 1) * logRank n) ∧
    (∃ depthConstant : Nat, ∀ n,
      depth n ≤ depthConstant * logRank n * logRank n)

end VandaeleTheorem5Resource
end QuantumBlockEncoding
