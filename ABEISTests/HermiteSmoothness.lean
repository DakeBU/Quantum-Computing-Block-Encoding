import QuantumBlockEncoding.HermiteSmoothness

/-! General-order integration tests for the actual piecewise initial datum. -/

open QuantumBlockEncoding.HermitePolynomial QuantumBlockEncoding.HermiteSmoothness

example (k : ℕ) : ContDiff ℝ k (smoothInitial k) := smoothInitial_contDiff k

example (k : ℕ) : Continuous (smoothInitial k) := (smoothInitial_contDiff k).continuous

-- The derivative remains continuous all the way through the requested order.
example (k j : ℕ) (hj : j ≤ k) : Continuous (iteratedDeriv j (smoothInitial k)) :=
  (contDiff_nat_iff_iteratedDeriv.mp (smoothInitial_contDiff k)).1 j hj

-- Every lower-order derivative is differentiable, including at both junctions.
example (k j : ℕ) (hj : j < k) : Differentiable ℝ (iteratedDeriv j (smoothInitial k)) :=
  (contDiff_nat_iff_iteratedDeriv.mp (smoothInitial_contDiff k)).2 j hj

example (k : ℕ) :
    ContDiff ℝ k (splice (-1) Real.exp
      (splice 0 (fun p => (sourceInterpolant k).eval p) (fun p => Real.exp (-p)))) :=
  contDiff_double_splice k

example (k : ℕ) (p : ℝ) :
    smoothInitial k p = splice (-1) Real.exp
      (splice 0 (fun q => (sourceInterpolant k).eval q) (fun q => Real.exp (-q))) p :=
  congrFun (smoothInitial_eq_double_splice k) p
