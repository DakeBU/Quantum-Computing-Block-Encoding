import QuantumBlockEncoding.HermitePolynomial

/-! Independent checks for the source Hermite construction and its public API. -/

open Polynomial QuantumBlockEncoding.HermitePolynomial

-- Universal tests retain arbitrary order: finite examples cannot replace these contracts.
example (k j : ℕ) (hj : j ≤ k) :
    iteratedDeriv j (fun p => (sourceInterpolant k).eval p) (-1) = Real.exp (-1) :=
  sourceInterpolant_left_iteratedDeriv k j hj

example (k j : ℕ) (hj : j ≤ k) :
    iteratedDeriv j (fun p => (sourceInterpolant k).eval p) 0 = (-1 : ℝ) ^ j :=
  sourceInterpolant_right_iteratedDeriv k j hj

example (k : ℕ) : (sourceInterpolant k).natDegree ≤ 2 * k + 1 :=
  sourceInterpolant_degree k

example (k : ℕ) (p : ℝ) : 0 < smoothInitial k p := smoothInitial_pos k p

-- The smallest member is the required linear Hermite bridge, not a constant surrogate.
example (p : ℝ) :
    (sourceInterpolant 0).eval p = -Real.exp (-1) * p + (p + 1) := by
  simp [sourceInterpolant_eval, coefficientPolynomial_eval]

-- The cubic member has A_1(t) = 1 + 3t, including the derivative constraints.
example (t : ℝ) : (coefficientPolynomial 1).eval t = 1 + 3 * t := by
  norm_num [coefficientPolynomial_eval, Finset.sum_range_succ]

example (k : ℕ) : interpolant k = sourceInterpolant k :=
  interpolant_eq_sourceInterpolant k

example (k : ℕ) : smoothInitial k (-1) = Real.exp (-1) := by
  rw [smoothInitial_middle k (-1) (by constructor <;> norm_num)]
  simpa using sourceInterpolant_left_jet k 0 (Nat.zero_le k)

example (k : ℕ) : smoothInitial k 0 = 1 := by
  rw [smoothInitial_middle k 0 (by constructor <;> norm_num)]
  simpa using sourceInterpolant_right_jet k 0 (Nat.zero_le k)
