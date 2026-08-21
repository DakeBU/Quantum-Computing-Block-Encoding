import QuantumBlockEncoding.RemaudVandaeleLadder1AlgorithmSchedule
import QuantumBlockEncoding.VandaeleLemma3ProgramFamily
import Mathlib.Data.Nat.Log
import Mathlib.Tactic

/-!
# Resource closure for Remaud--Vandaele Algorithm 1

The preceding modules reproduce the actual Algorithm-1 scheduled circuit and
its exact source recurrences.  This file removes the remaining asymptotic black
box needed by Vandaele 2026 Lemma 3.

We prove directly from those recurrences that

* `C(n) <= 2 n`, and
* `D(n) <= 2 (floor(log2 n) + 1)`.

These constants are deliberately simple rather than optimized.  They are
uniform, are derived from the same proof-bearing scheduled circuit, and exactly
match the resource scale expected by `VandaeleLemma3ProgramFamily` after the
identification `n = steps + 1`.

The sharper closed forms from Remaud--Vandaele Lemma 2 remain useful for source
fidelity, but are no longer needed as an unproved input for the 2026 paper.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadder1ResourceClosure

open RemaudVandaeleLadder1AlgorithmPlan
open RemaudVandaeleLadder1AlgorithmSchedule
open VandaeleLadderContract
open VandaeleLemma3ProgramFamily

/-- The exact CNOT recurrence is uniformly linear. -/
theorem gateRecurrence_le_two_mul :
    ∀ n, gateRecurrence n ≤ 2 * n := by
  intro n
  induction n using Nat.strong_induction_on with
  | h n induction =>
      rcases n with (_ | _ | _ | m)
      · rfl
      · rfl
      · norm_num [gateRecurrence]
      · have smaller : (m + 3) / 2 < m + 3 := by omega
        have recursive := induction ((m + 3) / 2) smaller
        rw [gateRecurrence_step (n := m + 3) (by omega)]
        unfold outerCount recursiveWidth
        omega

/-- Binary logarithm drops by exactly one under the source `floor(n/2)`
recursive call in the non-base regime. -/
theorem log2_half_add_one
    {n : Nat} (large : 2 ≤ n) :
    Nat.log2 n = Nat.log2 (n / 2) + 1 := by
  rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
  exact Nat.log_of_one_lt_of_le (by omega) large

/-- The exact depth recurrence is uniformly logarithmic. -/
theorem depthRecurrence_le_two_log :
    ∀ n, depthRecurrence n ≤ 2 * (Nat.log2 n + 1) := by
  intro n
  induction n using Nat.strong_induction_on with
  | h n induction =>
      rcases n with (_ | _ | _ | m)
      · simp [depthRecurrence]
      · simp [depthRecurrence]
      · norm_num [depthRecurrence]
      · have smaller : (m + 3) / 2 < m + 3 := by omega
        have recursive := induction ((m + 3) / 2) smaller
        have logarithm := log2_half_add_one (n := m + 3) (by omega)
        rw [depthRecurrence_step (n := m + 3) (by omega)]
        unfold recursiveWidth
        omega

/-- The actual Algorithm-1 schedule inherits the linear gate bound. -/
theorem algorithm_gateCount_linear (n : Nat) :
    (algorithm n).gateCount ≤ 2 * n := by
  rw [algorithm_gateCount_eq_recurrence]
  exact gateRecurrence_le_two_mul n

/-- The actual Algorithm-1 schedule inherits the logarithmic depth bound. -/
theorem algorithm_depth_logarithmic (n : Nat) :
    (algorithm n).depth ≤ 2 * (Nat.log2 n + 1) := by
  rw [algorithm_depth_eq_recurrence]
  exact depthRecurrence_le_two_log n

/-- Resource functions specialized to the `steps` convention of Vandaele 2026
Lemma 3.  An `L_1^(steps)` circuit acts on `steps+1` wires. -/
def gateCountBySteps (steps : Nat) : Nat :=
  (algorithm (steps + 1)).gateCount

def depthBySteps (steps : Nat) : Nat :=
  (algorithm (steps + 1)).depth

/-- Remaud--Vandaele Algorithm 1 by itself supplies the complete *resource*
half of Vandaele 2026 Lemma 3, with uniform constants 2 and 2. -/
theorem algorithm_resources_for_vandaele :
    LemmaThreeUniformResourceTarget gateCountBySteps depthBySteps := by
  refine ⟨2, 2, ?_⟩
  intro steps
  constructor
  · unfold gateCountBySteps
    exact algorithm_gateCount_linear (steps + 1)
  · unfold depthBySteps
    exact algorithm_depth_logarithmic (steps + 1)

end RemaudVandaeleLadder1ResourceClosure
end QuantumBlockEncoding
