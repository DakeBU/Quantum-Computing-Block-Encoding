import QuantumBlockEncoding.VandaeleLemma1NieRawFamily
import Mathlib.Tactic

/-!
# Uniform resource bounds for the generated Nie family

The exact recursive equations are already proved by the proof-bearing Figure-3
constructor.  This module starts the asymptotic layer by extracting global
constants from those same circuits.

The first invariant is intentionally simple but important: every recursive
node uses the fixed four-gate Step-3 commit, while the five base nodes use at
most the ten-gate fixed `C⁴X` block.  Thus the central commit cost is uniformly
bounded by 10 across the entire generated family.  The linear gate-count and
logarithmic-depth inductions consume this invariant downstream.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma1NieResourceBounds

open VandaeleLemma1NieRawFamily
open VandaeleLemma1NieRecursiveStep
open VandaeleLemma1CleanPromise

/-- Uniform gate-count cap on the persistent central commit of every node. -/
theorem rawSplit_commit_gateCount_le_ten (k : Nat) :
    (rawSplit k).commit.gateCount ≤ 10 := by
  by_cases small : k < 5
  · rcases base_commit_resource_bounds with
      ⟨h0, h1, h2, h3, h4, _d0, _d1, _d2, _d3, _d4⟩
    interval_cases k <;>
      simp only [rawSplit_zero, rawSplit_one, rawSplit_two,
        rawSplit_three, rawSplit_four] <;> assumption
  · have five_le : 5 ≤ k := by omega
    obtain ⟨n, rfl⟩ := Nat.exists_eq_add_of_le five_le
    rw [show 5 + n = n + 5 by omega, rawSplit_succ5]
    simp [recursiveSplit]

/-- Uniform depth cap on the persistent central commit of every node. -/
theorem rawSplit_commit_depth_le_ten (k : Nat) :
    (rawSplit k).commit.depth ≤ 10 := by
  by_cases small : k < 5
  · rcases base_commit_resource_bounds with
      ⟨_g0, _g1, _g2, _g3, _g4, h0, h1, h2, h3, h4⟩
    interval_cases k <;>
      simp only [rawSplit_zero, rawSplit_one, rawSplit_two,
        rawSplit_three, rawSplit_four] <;> assumption
  · have five_le : 5 ≤ k := by omega
    obtain ⟨n, rfl⟩ := Nat.exists_eq_add_of_le five_le
    rw [show 5 + n = n + 5 by omega, rawSplit_succ5]
    simp [recursiveSplit]

end VandaeleLemma1NieResourceBounds
end QuantumBlockEncoding