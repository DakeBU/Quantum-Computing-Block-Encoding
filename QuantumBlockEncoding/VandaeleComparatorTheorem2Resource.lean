import QuantumBlockEncoding.ComparatorIncrementerTheorem4DepthBound
import QuantumBlockEncoding.ComparatorIncrementerTheorem4GateBound
import Mathlib.Tactic

/-!
# Resource recurrence closure for Vandaele Theorem 2

Theorem 2's recursive V2 construction satisfies the same square-root recursive
argument as the incrementer:

`alpha(n) = 2 ceil(sqrt n)`.

The source recurrences are Equations (26)-(27):

`C(n) = Theta(n) + C(alpha(n))`,
`D(n) = Theta(log n) + D(alpha(n))`.

The arithmetic closure of these recurrences was already proved generically for
Theorem 4, so this module reuses it rather than duplicating an asymptotic proof.
The remaining comparator-specific work is to construct the Figure-5/V2 circuit
family and prove its local resource inequalities.
-/

namespace QuantumBlockEncoding
namespace VandaeleComparatorTheorem2Resource

open ComparatorIncrementerRecurrence
open ComparatorIncrementerTheorem4DepthBound
open ComparatorIncrementerTheorem4GateBound

/-- Source Equation-(26) interface. -/
def ComparatorGateRecurrenceUpper
    (cost localCost : Nat → Nat) : Prop :=
  GateRecurrenceUpper cost localCost

/-- Source Equation-(27) interface. -/
def ComparatorDepthRecurrenceUpper
    (depth localDepth : Nat → Nat) : Prop :=
  DepthRecurrenceUpper depth localDepth

/-- Public upper-resource target for one comparator circuit family. -/
def TheoremTwoUpperTarget
    (gateCount depth ancillas : Nat → Nat) : Prop :=
  (∃ gateConstant : Nat, ∀ n,
    gateCount n ≤ gateConstant * (n + 1)) ∧
  (∃ depthConstant : Nat, ∀ n,
    depth n ≤ depthConstant * logRank n) ∧
  (∀ n, ancillas n = 0)

/-- Equations (26)-(27), finite base cases, and the source zero-ancilla property
close the complete upper half of Theorem 2. -/
theorem theoremTwo_upper_closure
    (gateCount depth ancillas : Nat → Nat)
    (localGateConstant localDepthConstant
      gateBaseConstant depthBaseConstant : Nat)
    (gateBase : ∀ n, n < 21 →
      gateCount n ≤ gateBaseConstant * (n + 1))
    (depthBase : ∀ n, n < 2047 →
      depth n ≤ depthBaseConstant)
    (gateRecurrence : ComparatorGateRecurrenceUpper gateCount
      (fun n => localGateConstant * (n + 1)))
    (depthRecurrence : ComparatorDepthRecurrenceUpper depth
      (fun n => localDepthConstant * logRank n))
    (noAncillas : ∀ n, ancillas n = 0) :
    TheoremTwoUpperTarget gateCount depth ancillas := by
  have gateGlobal := gate_recurrence_contract_linear_upper
    gateCount localGateConstant gateBaseConstant gateBase gateRecurrence
  have depthStep : ∀ n, 2047 ≤ n →
      depth n ≤ localDepthConstant * logRank n +
        depth (ComparatorIncrementerRecurrence.alpha n) := by
    intro n large
    exact depthRecurrence n (by omega)
  have depthGlobal := depth_recurrence_log_upper_2047
    depth localDepthConstant depthBaseConstant depthBase depthStep
  constructor
  · exact ⟨gateBaseConstant + 2 * localGateConstant, gateGlobal⟩
  · constructor
    · exact ⟨4 * localDepthConstant, fun n => by
        have bound := depthGlobal n
        exact bound.trans (by
          apply Nat.add_le_of_le_sub
          · exact Nat.mul_le_mul_left (4 * localDepthConstant)
              (Nat.zero_le (logRank n))
          · omega)⟩
    · exact noAncillas

end VandaeleComparatorTheorem2Resource
end QuantumBlockEncoding
