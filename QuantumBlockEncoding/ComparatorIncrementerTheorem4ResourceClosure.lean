import QuantumBlockEncoding.ComparatorIncrementerLemma8Contract
import QuantumBlockEncoding.ComparatorIncrementerTheorem4DepthBound
import QuantumBlockEncoding.ComparatorIncrementerTheorem4GateBound
import Mathlib.Tactic

/-!
# Close the resource path from Vandaele Lemma 8 to Theorem 4

The source proof of Theorem 4 uses Lemma 8 as the nonrecursive local circuit in
the recurrences

`C(n) <= L_C(n) + C(alpha(n))`,
`D(n) <= L_D(n) + D(alpha(n))`,

where Lemma 8 supplies uniform `L_C(n)=O(n)` and `L_D(n)=O(log n)` bounds.
The gate and depth recurrence solvers are formalized in separate modules.  This
file connects those layers for one and the same recursive resource family.

Finite widths remain explicit base cases.  No source lower bound or optimality
claim is imported here; this is exactly the upper-bound half of Theorem 4.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerTheorem4ResourceClosure

open ComparatorIncrementerLemma8Contract
open ComparatorIncrementerRecurrence
open ComparatorIncrementerTheorem4DepthBound
open ComparatorIncrementerTheorem4GateBound

/-- Public upper-resource target corresponding to the asymptotic half of
Theorem 4.  Constants are uniform over every width. -/
def TheoremFourUpperResourceTarget
    (gateCount depth : Nat → Nat) : Prop :=
  (∃ constant : Nat, ∀ n,
    gateCount n ≤ constant * (n + 1)) ∧
  (∃ constant : Nat, ∀ n,
    depth n ≤ constant * logRank n)

/-- Lemma-8 local resources plus the exact Eq. (45)/(46) recurrences imply the
full global linear-gate / logarithmic-depth upper bounds.

The finite cutoffs `21` and `2047` are the explicit cutoffs used by the two
recurrence solvers.  They are not source assumptions: all smaller widths are
absorbed into the supplied base constants. -/
theorem theoremFour_upper_from_lemmaEight
    (gateCount depth localGateCost localDepthCost : Nat → Nat)
    (localResources :
      LemmaEightResourceTarget localGateCost localDepthCost)
    (gateRecurrence :
      GateRecurrenceUpper gateCount localGateCost)
    (depthRecurrence :
      DepthRecurrenceUpper depth localDepthCost)
    (baseGateConstant baseDepthConstant : Nat)
    (baseGate : ∀ n, n < 21 →
      gateCount n ≤ baseGateConstant * (n + 1))
    (baseDepth : ∀ n, n < 2047 →
      depth n ≤ baseDepthConstant) :
    TheoremFourUpperResourceTarget gateCount depth := by
  rcases localResources with
    ⟨⟨localGateConstant, localGateBound⟩,
      ⟨localDepthConstant, localDepthBound⟩⟩

  have gateStep : ∀ n, 21 ≤ n →
      gateCount n ≤
        localGateConstant * (n + 1) + gateCount (alpha n) := by
    intro n large
    have recurrence := gateRecurrence n (by omega)
    exact recurrence.trans
      (Nat.add_le_add_right (localGateBound n) (gateCount (alpha n)))

  have globalGate := gate_recurrence_linear_upper
    gateCount localGateConstant baseGateConstant baseGate gateStep

  have depthStep : ∀ n, 2047 ≤ n →
      depth n ≤
        localDepthConstant * logRank n + depth (alpha n) := by
    intro n large
    have recurrence := depthRecurrence n (by omega)
    have localBound :
        localDepthCost n ≤ localDepthConstant * logRank n := by
      simpa [logRank] using localDepthBound n
    exact recurrence.trans
      (Nat.add_le_add_right localBound (depth (alpha n)))

  have globalDepth := depth_recurrence_log_upper_2047
    depth localDepthConstant baseDepthConstant baseDepth depthStep

  constructor
  · refine ⟨baseGateConstant + 2 * localGateConstant, ?_⟩
    exact globalGate
  · refine ⟨baseDepthConstant + 4 * localDepthConstant, ?_⟩
    intro n
    have rankPositive : 1 ≤ logRank n := by
      unfold logRank
      omega
    have baseScaled :
        baseDepthConstant ≤ baseDepthConstant * logRank n := by
      calc
        baseDepthConstant = baseDepthConstant * 1 := by ring
        _ ≤ baseDepthConstant * logRank n :=
          Nat.mul_le_mul_left baseDepthConstant rankPositive
    calc
      depth n ≤
          baseDepthConstant +
            (4 * localDepthConstant) * logRank n :=
        globalDepth n
      _ ≤ baseDepthConstant * logRank n +
            (4 * localDepthConstant) * logRank n :=
        Nat.add_le_add_right baseScaled _
      _ = (baseDepthConstant + 4 * localDepthConstant) *
            logRank n := by ring

end ComparatorIncrementerTheorem4ResourceClosure
end QuantumBlockEncoding