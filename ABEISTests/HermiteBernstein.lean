import QuantumBlockEncoding.HermiteBernstein

noncomputable section

open QuantumBlockEncoding.HermiteBernstein
open QuantumBlockEncoding.HermitePolynomial

example : sourceBernsteinCoefficient 0 0 = Real.exp (-1) := by
  norm_num [sourceBernsteinCoefficient, leftCoefficient_eq, sourceCoefficient_eq]

example : sourceBernsteinCoefficient 0 1 = 1 := by
  norm_num [sourceBernsteinCoefficient, leftCoefficient_eq, sourceCoefficient_eq]

example : pathCoordinate [true, false, true] 0 = (5 / 8 : ℝ) := by
  norm_num [pathCoordinate, childCoordinate]

example (c : ℕ → ℝ) :
    leftRestriction (1 / 2) c 2 = (c 0 + 2 * c 1 + c 2) / 4 := by
  rw [leftRestriction_half]
  norm_num [Finset.sum_range_succ]
  ring

example (c : ℕ → ℝ) :
    rightRestriction 3 (1 / 2) c 1 = (c 1 + 2 * c 2 + c 3) / 4 := by
  rw [rightRestriction_half 3 1 (by omega)]
  norm_num [Finset.sum_range_succ]
  ring

example (k : ℕ) :
    subdivisionPath (2 * k + 1)
      (restrictCoefficients (2 * k + 1) (1 / 4) (3 / 4)
        (sourceBernsteinCoefficient k)) [true, false] 0 =
      (sourceInterpolant k).eval (-1 / 2) := by
  have he := sourceInterpolant_subdivision_readout k (1 / 4) (3 / 4)
    (by norm_num) [true, false]
  norm_num [pathCoordinate, childCoordinate] at he
  simpa only [neg_div] using he

example (k : ℕ) (u v : ℝ) (hu : u ≠ 1) :
    subdivisionPath (2 * k + 1)
      (restrictCoefficients (2 * k + 1) u v (sourceBernsteinCoefficient k)) [] 0 =
      (sourceInterpolant k).eval (u - 1) := by
  simpa [pathCoordinate] using sourceInterpolant_subdivision_readout k u v hu []

example (d : ℕ) (c : ℕ → ℝ)
    (hc : ∀ r ≤ d, c r ∈ Set.Icc (0 : ℝ) 2) (i : ℕ) (hi : i ≤ d) :
    restrictCoefficients d (1 / 4) (3 / 4) c i ∈ Set.Icc (0 : ℝ) 2 :=
  restrictCoefficients_bounds d c (1 / 4) (3 / 4) 0 2
    (by norm_num) (by norm_num) (by norm_num) hc i hi

#print axioms sourceInterpolant_bernstein
#print axioms sourceBernsteinCoefficient_nonneg
#print axioms casteljau_eq_sum
#print axioms restrictCoefficients_eval
#print axioms restrictCoefficients_bounds
#print axioms sourceInterpolant_subdivision_readout
